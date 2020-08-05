Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7955B23CF0B
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbgHETMq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:12:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729028AbgHES1V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 14:27:21 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EF8D22D05;
        Wed,  5 Aug 2020 18:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596651974;
        bh=p3WNcMvJB/y3Jj8HoY+KqKAm2MlBfzXMw7WEk0zysys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2rFbbck4dYZBBeA5TOv3YBf9m6Zp5JbB0ep8a62uwDKoTkpUZKAkyEw9CBYNXvJhP
         4stTYaai8vd6E8rV4bKsdf2n2IQrXwsdTK7/oQKx64Lp0lcKTUgz/+sa0DQpSJhgNN
         A8I0Ah9urJv3tPrSGFxrmwqYcalNp/+TmyYDJSuc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3Ng2-0004w9-PF; Wed, 05 Aug 2020 18:58:10 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peng Hao <richard.peng@oppo.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [PATCH 54/56] KVM: arm64: Handle data and instruction external aborts the same way
Date:   Wed,  5 Aug 2020 18:56:58 +0100
Message-Id: <20200805175700.62775-55-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com, alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com, christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com, gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com, richard.peng@oppo.com, qperret@google.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Will Deacon <will@kernel.org>

If the guest generates a synchronous external abort which is not handled
by the host, we inject it back into the guest as a virtual SError, but
only if the original fault was reported on the data side. Instruction
faults are reported as "Unsupported FSC", causing the vCPU run loop to
bail with -EFAULT.

Although synchronous external aborts from a guest are pretty unusual,
treat them the same regardless of whether they are taken as data or
instruction aborts by EL2.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Link: https://lore.kernel.org/r/20200729102821.23392-3-will@kernel.org
---
 arch/arm64/kvm/mmu.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8004f1f68946..14c6a9df5c9f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2079,13 +2079,10 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 * For RAS the host kernel may handle this abort.
 		 * There is no need to pass the error into the guest.
 		 */
-		if (!kvm_handle_guest_sea(fault_ipa, kvm_vcpu_get_esr(vcpu)))
-			return 1;
-
-		if (unlikely(!is_iabt)) {
+		if (kvm_handle_guest_sea(fault_ipa, kvm_vcpu_get_esr(vcpu)))
 			kvm_inject_vabt(vcpu);
-			return 1;
-		}
+
+		return 1;
 	}
 
 	trace_kvm_guest_fault(*vcpu_pc(vcpu), kvm_vcpu_get_esr(vcpu),
-- 
2.27.0

