Return-Path: <kvm+bounces-57165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DACA2B50BCD
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 04:50:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D1B38188F60E
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 02:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C31EE24E4C6;
	Wed, 10 Sep 2025 02:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="sVXRQlv2"
X-Original-To: kvm@vger.kernel.org
Received: from out28-52.mail.aliyun.com (out28-52.mail.aliyun.com [115.124.28.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1711F91E3;
	Wed, 10 Sep 2025 02:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757472577; cv=none; b=D0AcBG8FJnSLJ0l2zUL4aNwoisRyoGkX1yClHWrvCRTZfq6Dk9kNaiC6o740VZ0kEvlg7w34Yn6lGhBvG0P2f1zpRO0RPtyf8iSWmMZEOzFC6sARYO6Vwh18F+1tyuJtcQHEW5aiAF9W5VG+K1equj6t0sXqOXPO9MAA47bQYZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757472577; c=relaxed/simple;
	bh=Tnna44QehBkN4uomOmV1T5siUdJ4l9NkIBpvBlJqAMc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MGZOFxpl26nTxUimHjqgHzQKk0ZuqkWgNRnHJVCZ8zI8mY95DSdGh6ieuuImxqOGA0OL2uCociFI95uqVMZiyKJ6GbwSouJiVmKloZkKpoT555KYBWHAUnNmAXLSNuIYEiF/pkcJwfsFUniwkCKcQxC2Z2YaYM/YzDBYp36DWDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=sVXRQlv2; arc=none smtp.client-ip=115.124.28.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1757472567; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=8ZPH5RhranyasvKwjlXf14i0q2sAaVJOLqLubug0iBk=;
	b=sVXRQlv24dkp6ppPJvS5ei+HecrL/Or5NztMQDwvhDauQlsGiNFXr+ven2/L29dmhnSGccn1WiRfB+ObRFlBxLDIgZXwt6qG9N1AD03SLzLgfwUu6hK0PD16uUHj3er9dK/Vtr8PwaqTMwVxsB4HA6TBy8kKIEUB2DCQ3qW47aU=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.ebfE1in_1757472566 cluster:ay29)
          by smtp.aliyun-inc.com;
          Wed, 10 Sep 2025 10:49:26 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: kvm@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] KVM: x86: Only check effective code breakpoint in emulation
Date: Wed, 10 Sep 2025 10:49:15 +0800
Message-Id: <7cf5f98526f07ceb91135cde0253ed9209fd5269.1757416809.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1757416809.git.houwenlong.hwl@antgroup.com>
References: <cover.1757416809.git.houwenlong.hwl@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When guest debug is enabled, the effective breakpoints are controlled by
guest debug rather than by the guest itself.  Therefore, only check the
code breakpoints of guest debug in emulation if guest debug is enabled,
in order to maintain consistency with hardware behavior.

Fixes: 4a1e10d5b5d8 ("KVM: x86: handle hardware breakpoints during emulation")
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/x86.c | 35 ++++++++++-------------------------
 1 file changed, 10 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf289d04b104..5af652916a19 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8947,6 +8947,9 @@ EXPORT_SYMBOL_GPL(kvm_skip_emulated_instruction);
 
 static bool kvm_is_code_breakpoint_inhibited(struct kvm_vcpu *vcpu)
 {
+	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)
+		return false;
+
 	if (kvm_get_rflags(vcpu) & X86_EFLAGS_RF)
 		return true;
 
@@ -8963,6 +8966,8 @@ static bool kvm_is_code_breakpoint_inhibited(struct kvm_vcpu *vcpu)
 static bool kvm_vcpu_check_code_breakpoint(struct kvm_vcpu *vcpu,
 					   int emulation_type, int *r)
 {
+	unsigned long dr7 = kvm_get_eff_dr7(vcpu);
+
 	WARN_ON_ONCE(emulation_type & EMULTYPE_NO_DECODE);
 
 	/*
@@ -8983,34 +8988,14 @@ static bool kvm_vcpu_check_code_breakpoint(struct kvm_vcpu *vcpu,
 			      EMULTYPE_TRAP_UD | EMULTYPE_VMWARE_GP | EMULTYPE_PF))
 		return false;
 
-	if (unlikely(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) &&
-	    (vcpu->arch.guest_debug_dr7 & DR7_BP_EN_MASK)) {
-		struct kvm_run *kvm_run = vcpu->run;
-		unsigned long eip = kvm_get_linear_rip(vcpu);
-		u32 dr6 = kvm_vcpu_check_hw_bp(eip, 0,
-					   vcpu->arch.guest_debug_dr7,
-					   vcpu->arch.eff_db);
-
-		if (dr6 != 0) {
-			kvm_run->debug.arch.dr6 = dr6 | DR6_ACTIVE_LOW;
-			kvm_run->debug.arch.pc = eip;
-			kvm_run->debug.arch.exception = DB_VECTOR;
-			kvm_run->exit_reason = KVM_EXIT_DEBUG;
-			*r = 0;
-			return true;
-		}
-	}
-
-	if (unlikely(vcpu->arch.dr7 & DR7_BP_EN_MASK) &&
+	if (unlikely(dr7 & DR7_BP_EN_MASK) &&
 	    !kvm_is_code_breakpoint_inhibited(vcpu)) {
 		unsigned long eip = kvm_get_linear_rip(vcpu);
-		u32 dr6 = kvm_vcpu_check_hw_bp(eip, 0,
-					   vcpu->arch.dr7,
-					   vcpu->arch.db);
+		u32 dr6 = kvm_vcpu_check_hw_bp(eip, 0, dr7,
+					       vcpu->arch.eff_db);
 
-		if (dr6 != 0) {
-			kvm_queue_exception_p(vcpu, DB_VECTOR, dr6);
-			*r = 1;
+		if (dr6) {
+			*r = kvm_inject_emulated_db(vcpu, dr6);
 			return true;
 		}
 	}
-- 
2.31.1


