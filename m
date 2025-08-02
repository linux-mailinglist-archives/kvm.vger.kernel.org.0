Return-Path: <kvm+bounces-53866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 83E69B189D5
	for <lists+kvm@lfdr.de>; Sat,  2 Aug 2025 02:16:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50A0B1885F61
	for <lists+kvm@lfdr.de>; Sat,  2 Aug 2025 00:17:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2335B13C8FF;
	Sat,  2 Aug 2025 00:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="LAUQuqS1"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F8E6FC3;
	Sat,  2 Aug 2025 00:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754093767; cv=none; b=T/ESgAjQrf/FxyKKkKTL5xjva6X3n6ufFTb/ZLPrCDo1J7wXm3LIhVd9zG8CCmj/MVUr+xVRoCai+NbSoiANY4ueatHaJeD+DaVqQun98gQoUNOBth86p0k+R5tHD00GHvll531EfIb67EqKa+77VvpJt44TqIEqFYlTnxU5fVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754093767; c=relaxed/simple;
	bh=AHwmC+gm7+qpdc3IAvsnVa4r2mizxUsEuxjacD0Nb4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsP0nymtJvKofHRp/+dktbGJF1RDNKUobA5+E1YplVJleC1TYdOz0jo0nmlekIjg8LVfZSFJn/nAgvILtU3Xvl3PdoowtKs7M8cjNkRfWVeGJHr3vXTqF6K/4SGkv8ytJjShSG4KuEqMnvJBHmnlxpjcrfJBHC0soLO3pFG29G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=LAUQuqS1; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5720FKpI3142596
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 1 Aug 2025 17:15:29 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5720FKpI3142596
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1754093730;
	bh=g0BFgLXFoLbPOU1iuB9rAuWpOPog/vwxok3IAd7sUD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LAUQuqS1EXmaY2Gr8d2qPNDTcTpJVJ/Wizjb7L6uMIbvbePpwgi2Gj0pFLg0ZmjEV
	 E4m745OJCV54KU2E15ha18uiBsplfCgsXmqCIjQ5+y5nwNsBm1QSohFA/GL3CPXBzq
	 St6TObaGEbpMV1gklOrh4ayA/Nn7cy7sE6yU6Evv8DW/8Xh3JyEI4yqBvqV+w4OchG
	 tA7g1swOFaXK+aSSjv5o4z/8RlMX/SihfnFyBpDC3imgiEAzmUBMJz8QTYYqTCHKAB
	 6Rm6ZcjBEqP/xjc8ekTORPZ6iaaykiaH4tXpci5hZp9ag1IkU5dOwo2ai95d+l4VWN
	 USNTLQn1/NJIg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, chao.gao@intel.com
Subject: [PATCH v2 3/4] KVM: VMX: Support the immediate form WRMSRNS in fastpath
Date: Fri,  1 Aug 2025 17:15:19 -0700
Message-ID: <20250802001520.3142577-4-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250802001520.3142577-1-xin@zytor.com>
References: <20250802001520.3142577-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactored handle_fastpath_set_msr_irqoff() to accept MSR index and data
directly via input arguments, enabling it to handle both implicit and
immediate form WRMSRNS through appropriate wrappers.  Also rename it to
__handle_fastpath_wrmsr().

BTW, per Sean's suggestion, rename handle_fastpath_set_msr_irqoff() to
handle_fastpath_wrmsr().

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---

Change in v2:
*) Moved fastpath support in a separate patch (Sean).
---
 arch/x86/kvm/svm/svm.c |  2 +-
 arch/x86/kvm/vmx/vmx.c |  5 ++++-
 arch/x86/kvm/x86.c     | 19 +++++++++++++------
 arch/x86/kvm/x86.h     |  3 ++-
 4 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d9931c6c4bc6..4abc34b7c2c7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4189,7 +4189,7 @@ static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 	case SVM_EXIT_MSR:
 		if (!svm->vmcb->control.exit_info_1)
 			break;
-		return handle_fastpath_set_msr_irqoff(vcpu);
+		return handle_fastpath_wrmsr(vcpu);
 	case SVM_EXIT_HLT:
 		return handle_fastpath_hlt(vcpu);
 	default:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c112595dfff9..2cd865e117a8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7191,7 +7191,10 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu,
 
 	switch (vmx_get_exit_reason(vcpu).basic) {
 	case EXIT_REASON_MSR_WRITE:
-		return handle_fastpath_set_msr_irqoff(vcpu);
+		return handle_fastpath_wrmsr(vcpu);
+	case EXIT_REASON_MSR_WRITE_IMM:
+		return handle_fastpath_wrmsr_imm(vcpu, vmx_get_exit_qual(vcpu),
+						 vmx_get_msr_imm_reg());
 	case EXIT_REASON_PREEMPTION_TIMER:
 		return handle_fastpath_preemption_timer(vcpu, force_immediate_exit);
 	case EXIT_REASON_HLT:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fe12aae7089c..9aede349b6ec 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2202,10 +2202,8 @@ static int handle_fastpath_set_tscdeadline(struct kvm_vcpu *vcpu, u64 data)
 	return 0;
 }
 
-fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
+static fastpath_t __handle_fastpath_wrmsr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 {
-	u32 msr = kvm_rcx_read(vcpu);
-	u64 data;
 	fastpath_t ret;
 	bool handled;
 
@@ -2213,11 +2211,9 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 
 	switch (msr) {
 	case APIC_BASE_MSR + (APIC_ICR >> 4):
-		data = kvm_read_edx_eax(vcpu);
 		handled = !handle_fastpath_set_x2apic_icr_irqoff(vcpu, data);
 		break;
 	case MSR_IA32_TSC_DEADLINE:
-		data = kvm_read_edx_eax(vcpu);
 		handled = !handle_fastpath_set_tscdeadline(vcpu, data);
 		break;
 	default:
@@ -2239,7 +2235,18 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(handle_fastpath_set_msr_irqoff);
+
+fastpath_t handle_fastpath_wrmsr(struct kvm_vcpu *vcpu)
+{
+	return __handle_fastpath_wrmsr(vcpu, kvm_rcx_read(vcpu), kvm_read_edx_eax(vcpu));
+}
+EXPORT_SYMBOL_GPL(handle_fastpath_wrmsr);
+
+fastpath_t handle_fastpath_wrmsr_imm(struct kvm_vcpu *vcpu, u32 msr, int reg)
+{
+	return __handle_fastpath_wrmsr(vcpu, msr, kvm_register_read(vcpu, reg));
+}
+EXPORT_SYMBOL_GPL(handle_fastpath_wrmsr_imm);
 
 /*
  * Adapt set_msr() to msr_io()'s calling convention
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index bcfd9b719ada..de22c19b47fe 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -437,7 +437,8 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
 				    void *insn, int insn_len);
 int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			    int emulation_type, void *insn, int insn_len);
-fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
+fastpath_t handle_fastpath_wrmsr(struct kvm_vcpu *vcpu);
+fastpath_t handle_fastpath_wrmsr_imm(struct kvm_vcpu *vcpu, u32 msr, int reg);
 fastpath_t handle_fastpath_hlt(struct kvm_vcpu *vcpu);
 
 extern struct kvm_caps kvm_caps;
-- 
2.50.1


