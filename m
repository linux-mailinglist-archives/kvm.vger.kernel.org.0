Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7339DB14
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 03:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbfH0Bfp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 21:35:45 -0400
Received: from ozlabs.org ([203.11.71.1]:39169 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726257AbfH0Bfp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 21:35:45 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 46HWfQ58YLz9sDB; Tue, 27 Aug 2019 11:35:42 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1566869742; bh=5tkDZ0zmgPynefhNwg4H1TzlSKE/xtMuzKvCKr0zR50=;
        h=Date:From:To:Cc:Subject:From;
        b=rjA0+iXlcGHmpOPwTgpWCEYWJS6Jg6uYQapAlN3JHrbwqVsNuzLFvEs5e/aevxycv
         xqGhv+AdLGJZRtxNixTfI6LPL9fzwIskV6TAVCyVTnBYV9vBi7tPdXgljWdxHmBRGu
         wmN7lfwmD2g6z0e9o8al9XwF4qvXyuLZ6CWlOgMGVOPPLgmk95C9sbxh/NYpnIuSyk
         fkxBHtoDWOdwSOo+0WJwRMCLF7eClt6lkJt2ZuFXDoiHRtov/SZYCyML/Ew+dh7a40
         /W/clBUy9HxfVHf5cOrCEl5VAXLP1AasQHKykLmO6nVeo6ml/oLqp/5a7bF/XF6SzU
         0OrVMxr6t3LBQ==
Date:   Tue, 27 Aug 2019 11:35:40 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH] KVM: PPC: Book3S HV: Don't lose pending doorbell request on
 migration on P9
Message-ID: <20190827013540.GC16075@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On POWER9, when userspace reads the value of the DPDES register on a
vCPU, it is possible for 0 to be returned although there is a doorbell
interrupt pending for the vCPU.  This can lead to a doorbell interrupt
being lost across migration.  If the guest kernel uses doorbell
interrupts for IPIs, then it could malfunction because of the lost
interrupt.

This happens because a newly-generated doorbell interrupt is signalled
by setting vcpu->arch.doorbell_request to 1; the DPDES value in
vcpu->arch.vcore->dpdes is not updated, because it can only be updated
when holding the vcpu mutex, in order to avoid races.

To fix this, we OR in vcpu->arch.doorbell_request when reading the
DPDES value.

Cc: stable@vger.kernel.org # v4.13+
Fixes: 579006944e0d ("KVM: PPC: Book3S HV: Virtualize doorbell facility on POWER9")
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
---
 arch/powerpc/kvm/book3s_hv.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index ca6c6ec..88c42e7 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1678,7 +1678,14 @@ static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		*val = get_reg_val(id, vcpu->arch.pspb);
 		break;
 	case KVM_REG_PPC_DPDES:
-		*val = get_reg_val(id, vcpu->arch.vcore->dpdes);
+		/*
+		 * On POWER9, where we are emulating msgsndp etc.,
+		 * we return 1 bit for each vcpu, which can come from
+		 * either vcore->dpdes or doorbell_request.
+		 * On POWER8, doorbell_request is 0.
+		 */
+		*val = get_reg_val(id, vcpu->arch.vcore->dpdes |
+				   vcpu->arch.doorbell_request);
 		break;
 	case KVM_REG_PPC_VTB:
 		*val = get_reg_val(id, vcpu->arch.vcore->vtb);
-- 
2.7.4

