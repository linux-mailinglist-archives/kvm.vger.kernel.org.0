Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10FD241588
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 06:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgHKETU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 00:19:20 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:33701 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbgHKETU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 00:19:20 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4BQfjf3pLbz9sTS; Tue, 11 Aug 2020 14:19:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1597119558;
        bh=2NZiS/B9GDmUuTZl+DIdhj2fNIhZ6RGfvaIFICHqFSM=;
        h=From:To:Cc:Subject:Date:From;
        b=WH64YnKMptRO4Eox2YloZbysBg7ADBHWYMCYZMpjNkFkZ7mEP/KxNx5G3tL1CKXQu
         uhBEtjcHOmb30U2vTPlkz9eIoTSffzJN8sLu7PUF5NjsEsY4f3vQru3UoQGzwgIqFU
         0ONoy5meOvv+eWlw4dGBg3SCcKueEgHNmY1/1gNM=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     paulus@samba.org, mpe@ellerman.id.au
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH] powerpc: kvm: Increase HDEC threshold to enter guest
Date:   Tue, 11 Aug 2020 14:08:34 +1000
Message-Id: <20200811040834.45930-1-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before entering a guest, we need to set the HDEC to pull us out again
when the guest's time is up.  This needs some care, though, because the
HDEC is edge triggered, which means that if it expires before entering the
guest, the interrupt will be lost, meaning we stay in the guest
indefinitely (in practice, until the the hard lockup detector pulls us out
with an NMI).

For the POWER9, independent threads mode specific path, we attempt to
prevent that, by testing time has already expired before setting the HDEC
in kvmhv_load_regs_and_go().  However, that doesn't account for the case
where the timer expires between that test and the actual guest entry.
Preliminary instrumentation suggests that can take as long as 1.5µs under
certain load conditions, and simply checking the HDEC value we're going to
load is positive isn't enough to guarantee that leeway.

That test here is sometimes masked by a test in kvmhv_p9_guest_entry(), its
caller.  That checks that the remaining time is at 1µs.  However as noted
above that doesn't appear to be sufficient in all circumstances even
from the point HDEC is set, let alone this earlier point.

Therefore, increase the threshold we check for in both locations to 4µs
(2048 timebase ticks).  This is a pretty crude approach, but it addresses
a real problem where guest load can trigger a host hard lockup.

We're hoping to refine this in future by gathering more data on exactly
how long these paths can take, and possibly by moving the check closer to
the actual guest entry point to reduce the variance.  Getting the details
for that might take some time however.

NOTE: For reasons I haven't yet tracked down yet, I haven't actually
managed to reproduce this on current upstream.  I have reproduced it on
RHEL kernels without obvious differences in this area.  I'm still trying
to determine what the cause of that difference is, but I think it's worth
applying this change as a precaution in the interim.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 arch/powerpc/kvm/book3s_hv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 0f83f39a2bd2..65a92dd890cb 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3435,7 +3435,7 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 	unsigned long host_pidr = mfspr(SPRN_PID);
 
 	hdec = time_limit - mftb();
-	if (hdec < 0)
+	if (hdec < 2048)
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
 	mtspr(SPRN_HDEC, hdec);
 
@@ -3564,7 +3564,7 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	dec = mfspr(SPRN_DEC);
 	tb = mftb();
-	if (dec < 512)
+	if (dec < 2048)
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
 	local_paca->kvm_hstate.dec_expires = dec + tb;
 	if (local_paca->kvm_hstate.dec_expires < time_limit)
-- 
2.26.2

