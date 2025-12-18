Return-Path: <kvm+bounces-66264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 54E35CCC2F7
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 15:10:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7782A3019892
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 14:07:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AB6D343D84;
	Thu, 18 Dec 2025 14:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="rGcs5TYs"
X-Original-To: kvm@vger.kernel.org
Received: from out28-148.mail.aliyun.com (out28-148.mail.aliyun.com [115.124.28.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CEB340D93;
	Thu, 18 Dec 2025 14:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766066474; cv=none; b=U8FqUcokIOfX4HrK7jR1j3yBGnWCuSTnIry1EOPV/iw/gdI1Xp+WW5owSpw7iIkU1BrZKdEInbnwK1bX+RR7Spg2Bs05p/JPdzIcDkQrhf29iuYdqiGhBui49cbFD6X2GB3Yqsn9QbOii7ZxMNQ4vHgk+0ZWYIW55o1Fv5HWQPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766066474; c=relaxed/simple;
	bh=R3YK9B38wu/oiIJtPzlJr0HCTmUwKMeWu4ucBm+cPF0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fvCJmTaFrubUbJD2LeLaBX1tEthTWCNr4zuaEfQcVzghOoyaudpKpWgqyZ3CzyuhKIv0EeIzpd4tT+zS1Ha5JpzNZ8Z9kYqWI/QJ25uv5zXfZVGEa4go7IdoDvUc5VAq5SKxV91DNMcbSZ3ohN1ghEtmLmTCWmTxYkgVD7aBpWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=rGcs5TYs; arc=none smtp.client-ip=115.124.28.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1766066462; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=XKfSRsgufZz35Jo2Mc/srTw4TeEmjiGm2YkpIyQmbl4=;
	b=rGcs5TYsb+X8zHQM27kw0QninCsLYHiM8y8iXRrgK9QcaPR6OGiSZvrNz4JrzOXxx9JMP6TkWsArRDneRlMDMCqhxL1yze6gKH8w20s27SxS6Cs33l1SiRZpycKLTUnsmFG/sKZyOGj+eMLlpykdDw5OP5tnYwKTR1u6SfQ+o+w=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.fneRYrx_1766066461 cluster:ay29)
          by smtp.aliyun-inc.com;
          Thu, 18 Dec 2025 22:01:01 +0800
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
Subject: [PATCH v2 4/9] KVM: x86: Only check effective code breakpoint in emulation
Date: Thu, 18 Dec 2025 22:00:39 +0800
Message-Id: <19dc9f355b395a8e7c99b449ca5e93c8fbf5c49c.1766066076.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1766066076.git.houwenlong.hwl@antgroup.com>
References: <cover.1766066076.git.houwenlong.hwl@antgroup.com>
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
index 824eb489de43..3000139a19db 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9272,6 +9272,9 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_skip_emulated_instruction);
 
 static bool kvm_is_code_breakpoint_inhibited(struct kvm_vcpu *vcpu)
 {
+	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)
+		return false;
+
 	if (kvm_get_rflags(vcpu) & X86_EFLAGS_RF)
 		return true;
 
@@ -9288,6 +9291,8 @@ static bool kvm_is_code_breakpoint_inhibited(struct kvm_vcpu *vcpu)
 static bool kvm_vcpu_check_code_breakpoint(struct kvm_vcpu *vcpu,
 					   int emulation_type, int *r)
 {
+	unsigned long dr7 = kvm_get_eff_dr7(vcpu);
+
 	WARN_ON_ONCE(emulation_type & EMULTYPE_NO_DECODE);
 
 	/*
@@ -9308,34 +9313,14 @@ static bool kvm_vcpu_check_code_breakpoint(struct kvm_vcpu *vcpu,
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


