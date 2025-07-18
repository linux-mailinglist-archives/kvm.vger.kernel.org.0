Return-Path: <kvm+bounces-52865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D8AD3B09BB6
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 08:51:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 85438189DFBD
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 06:51:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 592B920296E;
	Fri, 18 Jul 2025 06:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YVn5Ey4P"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBAC21ABBB;
	Fri, 18 Jul 2025 06:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752821416; cv=none; b=Fixn3h328v8eeYQ7YgOF4T8jpXmPguIi+Y/J3wBdDYtSTgct5vE1G7NBsIOwoH3n2Px+kYFWfhQTOOPhYC49lY5efSiWRbkFcKf/zCZ6YZT5AtjXwZd4ApBpXmbo9LQNRZtmyJGf/N7eRZ1vsXXcuD8wgP0HfV3iXaP74jjQfPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752821416; c=relaxed/simple;
	bh=9731/s6eltTcDtXhboJvL5byihH/nF+YTadAEVTXanw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIHNb73KBZUmiAKTmyuYBOSjORuUtr/mi6Y26YJZe53+JqAMeKiKqPmeS/Tfpx15GgoB9j41eAHWBIUVMq+aNRyOV4HtmDZZge8uyM0Ev62G6tVs4+/YHtZ661YUCjfY+6Fnx68AwMjpQIOBkIQTThHMXosjp2pvbzB64TUmXHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YVn5Ey4P; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D852DC4CEED;
	Fri, 18 Jul 2025 06:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752821416;
	bh=9731/s6eltTcDtXhboJvL5byihH/nF+YTadAEVTXanw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YVn5Ey4PinJb7vhJuR5BhYTBAHi1CbRbpa5hm/9JHbTupgs2Oj8eA1SlGyC4jgOhg
	 sAxHYy9GYR3DxUvuxBhp86bke49ezqNID/IJH0g/G6et0PIzL87QpD/Yn8JsIZggpH
	 RXQBQvD7ucjwQuavUPRzIw5dl6Kg/QQhzVom0iTooXOiIcyZ6JYX8DmZKfPZDfwZZb
	 DAfAE1KWfpLlgyUvYEbAIcdd1J+5sry+HnAGBGd4GtjkN43n8KP+jEQBa8Bfuq9nOh
	 EcWxM2vWSZMkrh45OjipiGehbzhACjI+xj3+UezVExHy7F+XIcwQw3YApwENosFNSY
	 7QA8i0QSKYDHA==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [RFC PATCH 1/3] KVM: SVM: Fix clearing IRQ window inhibit with nested guests
Date: Fri, 18 Jul 2025 12:13:34 +0530
Message-ID: <4d0107f9b68d972edf9406cf903204dee9f75142.1752819570.git.naveen@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1752819570.git.naveen@kernel.org>
References: <cover.1752819570.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clearing IRQ window inhibit today relies on interrupt window
interception, but that is not always reachable when nested guests are
involved.

If L1 is intercepting IRQs, then interrupt_window_interception() will
never be reached while L2 is active, because the only reason KVM
would set the V_IRQ intercept in vmcb02 would be on behalf of L1, i.e.
because of vmcb12.  svm_clear_vintr() always operates on (at least)
vmcb01, and VMRUN unconditionally sets GIF=1, which means that
enter_svm_guest_mode() will always do svm_clear_vintr() via
svm_set_gif(svm, true). I.e. KVM will keep the VM-wide inhibit set until
control transfers back to L1 *and* an interrupt window is triggered.

If L1 is not intercepting IRQs, KVM may immediately inject L1's ExtINT
into L2 if IRQs are enabled in L2 without taking an interrupt window
interception.

Address this by clearing the IRQ window inhibit when KVM actually
injects an interrupt and there are no further injectable interrupts.
That way, if L1 isn't intercepting IRQs, KVM will drop the inhibit as
soon as an interrupt is injected into L2. And if L1 is intercepting
IRQs, KVM will keep the inhibit until the IRQ is injected into L2. So,
AVIC won't be left inhibited.

---
 arch/x86/kvm/svm/svm.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

I think patch tags for this should be:
	From: Sean Christopherson <seanjc@google.com>

	Signed-off-by: Sean Christopherson <seanjc@google.com>
	Co-Developed-by: Naveen N Rao (AMD) <naveen@kernel.org>
	Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>

- Naveen

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d9931c6c4bc6..bbe439c0e36a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3108,20 +3108,6 @@ static int interrupt_window_interception(struct kvm_vcpu *vcpu)
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	svm_clear_vintr(to_svm(vcpu));
 
-	/*
-	 * If not running nested, for AVIC, the only reason to end up here is ExtINTs.
-	 * In this case AVIC was temporarily disabled for
-	 * requesting the IRQ window and we have to re-enable it.
-	 *
-	 * If running nested, still remove the VM wide AVIC inhibit to
-	 * support case in which the interrupt window was requested when the
-	 * vCPU was not running nested.
-
-	 * All vCPUs which run still run nested, will remain to have their
-	 * AVIC still inhibited due to per-cpu AVIC inhibition.
-	 */
-	kvm_clear_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_IRQWIN);
-
 	++vcpu->stat.irq_window_exits;
 	return 1;
 }
@@ -3684,6 +3670,20 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 type;
 
+	/*
+	 * If AVIC was inhibited in order to detect an IRQ window, and there's
+	 * no other injectable interrupts pending or L2 is active (see below),
+	 * then drop the inhibit as the window has served its purpose.
+	 *
+	 * If L2 is active, this path is reachable if L1 is not intercepting
+	 * IRQs, i.e. if KVM is injecting L1 IRQs into L2.  AVIC is locally
+	 * inhibited while L2 is active; drop the VM-wide inhibit to optimize
+	 * the case in which the interrupt window was requested while L1 was
+	 * active (the vCPU was not running nested).
+	 */
+	if (!kvm_cpu_has_injectable_intr(vcpu) || is_guest_mode(vcpu))
+		kvm_clear_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_IRQWIN);
+
 	if (vcpu->arch.interrupt.soft) {
 		if (svm_update_soft_interrupt_rip(vcpu))
 			return;
-- 
2.50.1


