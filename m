Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A53479F896
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 05:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbjINDG4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 23:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234033AbjINDGy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 23:06:54 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394F51BD7;
        Wed, 13 Sep 2023 20:06:50 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1c337aeefbdso4397255ad.0;
        Wed, 13 Sep 2023 20:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694660809; x=1695265609; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oSY9oehCmsassunipNzl1VVTMw2/RZt+mSgC6ITLdDI=;
        b=fBpOPf3d6jEM7560jqorLUH8OlWUntLwTMmMViq28BdpdYs3n1x9Epi2gkfTvHgnNS
         77tmDSphd7Ub1JJyYzJTIhyyvg6silddH90Z6TAGDeavzcIvX4y492q9kWerN5Fiip6f
         1aoJbSQIE8DQJVC14twyMA4n4Vtfjfn/F/2LcbO9KmfjZtFE9U28YjbPo0Q4QUvWX0l6
         9sYrdqpN8FUpP5fauhJ47GtBdVSQoWGkYBcGtcYT4VGvlBT28q/aJU1dTMhUJJnY0TkH
         POxvNQ7poA5OLYRRFJCKaCAH3WZVzSa6gVmlQrsxhgnlIa6pI75YjQiRvY9Weui43pkk
         EtSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694660809; x=1695265609;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oSY9oehCmsassunipNzl1VVTMw2/RZt+mSgC6ITLdDI=;
        b=XxzaPCoScehITSIa4x5eUlvwUAlLTNo/BOVyiYTd41UWKaiuRUeroDvMJlqPKboaYg
         sn2b9V4qmBeCyvSPL0AhXocy+VjsiFgDYSL8djyV5UlTe+NJvaDajrMkIOUasb1Mij3X
         346EOoATCZDoFBJQ/2S72h4MfKZCINVOYWYDVMKOsVmHQAXX/KRHmfiGIudZ+A9tEKpk
         K/KzjBF5Gj+6dqUkoWllBF3GQuGN1CZa1SnZ7jkuSwCjDmlHCKbMY3PpSrNzar4nVo3X
         i+Bd3k+fv8wTSdCbHhhYr8pT4nUFGr0VehazkRT2jFHNCQ3SSKJn2tP4w3MGH6E98znY
         NwCg==
X-Gm-Message-State: AOJu0Yxrt7EHXbrmuTZxNxLEHGmONNRBO67D9fJlg/4uFLEX51nwcyYc
        jB47GdLkoW6NRtTlgpznFSo=
X-Google-Smtp-Source: AGHT+IGnu8zA+4mlLmPqha+HlIDYjbZ8/UyV6Vj+T+MhIRCBcwZUfp/UdMMeWnqtEPpTZsWzRWz+XA==
X-Received: by 2002:a17:902:9896:b0:1bc:6c8:cded with SMTP id s22-20020a170902989600b001bc06c8cdedmr3836452plp.67.1694660809595;
        Wed, 13 Sep 2023 20:06:49 -0700 (PDT)
Received: from pwon.ozlabs.ibm.com ([146.112.118.69])
        by smtp.gmail.com with ESMTPSA id w2-20020a170902904200b001b567bbe82dsm330521plz.150.2023.09.13.20.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 20:06:49 -0700 (PDT)
From:   Jordan Niethe <jniethe5@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, npiggin@gmail.com,
        mikey@neuling.org, paulus@ozlabs.org, vaibhav@linux.ibm.com,
        sbhat@linux.ibm.com, gautam@linux.ibm.com,
        kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com,
        David.Laight@ACULAB.COM, mpe@ellerman.id.au, sachinp@linux.ibm.com,
        Jordan Niethe <jniethe5@gmail.com>
Subject: [PATCH v5 07/11] KVM: PPC: Book3S HV: Introduce low level MSR accessor
Date:   Thu, 14 Sep 2023 13:05:56 +1000
Message-Id: <20230914030600.16993-8-jniethe5@gmail.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230914030600.16993-1-jniethe5@gmail.com>
References: <20230914030600.16993-1-jniethe5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvmppc_get_msr() and kvmppc_set_msr_fast() serve as accessors for the
MSR. However because the MSR is kept in the shared regs they include a
conditional check for kvmppc_shared_big_endian() and endian conversion.

Within the Book3S HV specific code there are direct reads and writes of
shregs::msr. In preparation for Nested APIv2 these accesses need to be
replaced with accessor functions so it is possible to extend their
behavior. However, using the kvmppc_get_msr() and kvmppc_set_msr_fast()
functions is undesirable because it would introduce a conditional branch
and endian conversion that is not currently present.

kvmppc_set_msr_hv() already exists, it is used for the
kvmppc_ops::set_msr callback.

Introduce a low level accessor __kvmppc_{s,g}et_msr_hv() that simply
gets and sets shregs::msr. This will be extend for Nested APIv2 support.

Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
---
v4:
  - New to series
---
 arch/powerpc/kvm/book3s_64_mmu_hv.c  |  5 ++--
 arch/powerpc/kvm/book3s_hv.c         | 34 ++++++++++++++--------------
 arch/powerpc/kvm/book3s_hv.h         | 10 ++++++++
 arch/powerpc/kvm/book3s_hv_builtin.c |  5 ++--
 4 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index efd0ebf70a5e..fdfc2a62dd67 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -28,6 +28,7 @@
 #include <asm/pte-walk.h>
 
 #include "book3s.h"
+#include "book3s_hv.h"
 #include "trace_hv.h"
 
 //#define DEBUG_RESIZE_HPT	1
@@ -347,7 +348,7 @@ static int kvmppc_mmu_book3s_64_hv_xlate(struct kvm_vcpu *vcpu, gva_t eaddr,
 	unsigned long v, orig_v, gr;
 	__be64 *hptep;
 	long int index;
-	int virtmode = vcpu->arch.shregs.msr & (data ? MSR_DR : MSR_IR);
+	int virtmode = __kvmppc_get_msr_hv(vcpu) & (data ? MSR_DR : MSR_IR);
 
 	if (kvm_is_radix(vcpu->kvm))
 		return kvmppc_mmu_radix_xlate(vcpu, eaddr, gpte, data, iswrite);
@@ -385,7 +386,7 @@ static int kvmppc_mmu_book3s_64_hv_xlate(struct kvm_vcpu *vcpu, gva_t eaddr,
 
 	/* Get PP bits and key for permission check */
 	pp = gr & (HPTE_R_PP0 | HPTE_R_PP);
-	key = (vcpu->arch.shregs.msr & MSR_PR) ? SLB_VSID_KP : SLB_VSID_KS;
+	key = (__kvmppc_get_msr_hv(vcpu) & MSR_PR) ? SLB_VSID_KP : SLB_VSID_KS;
 	key &= slb_v;
 
 	/* Calculate permissions */
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 25025f6c4cce..5743f32bf45e 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1374,7 +1374,7 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
  */
 static void kvmppc_cede(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.shregs.msr |= MSR_EE;
+	__kvmppc_set_msr_hv(vcpu, __kvmppc_get_msr_hv(vcpu) | MSR_EE);
 	vcpu->arch.ceded = 1;
 	smp_mb();
 	if (vcpu->arch.prodded) {
@@ -1589,7 +1589,7 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 	 * That can happen due to a bug, or due to a machine check
 	 * occurring at just the wrong time.
 	 */
-	if (vcpu->arch.shregs.msr & MSR_HV) {
+	if (__kvmppc_get_msr_hv(vcpu) & MSR_HV) {
 		printk(KERN_EMERG "KVM trap in HV mode!\n");
 		printk(KERN_EMERG "trap=0x%x | pc=0x%lx | msr=0x%llx\n",
 			vcpu->arch.trap, kvmppc_get_pc(vcpu),
@@ -1640,7 +1640,7 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 		 * so that it knows that the machine check occurred.
 		 */
 		if (!vcpu->kvm->arch.fwnmi_enabled) {
-			ulong flags = (vcpu->arch.shregs.msr & 0x083c0000) |
+			ulong flags = (__kvmppc_get_msr_hv(vcpu) & 0x083c0000) |
 					(kvmppc_get_msr(vcpu) & SRR1_PREFIXED);
 			kvmppc_core_queue_machine_check(vcpu, flags);
 			r = RESUME_GUEST;
@@ -1670,7 +1670,7 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 		 * as a result of a hypervisor emulation interrupt
 		 * (e40) getting turned into a 700 by BML RTAS.
 		 */
-		flags = (vcpu->arch.shregs.msr & 0x1f0000ull) |
+		flags = (__kvmppc_get_msr_hv(vcpu) & 0x1f0000ull) |
 			(kvmppc_get_msr(vcpu) & SRR1_PREFIXED);
 		kvmppc_core_queue_program(vcpu, flags);
 		r = RESUME_GUEST;
@@ -1680,7 +1680,7 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 	{
 		int i;
 
-		if (unlikely(vcpu->arch.shregs.msr & MSR_PR)) {
+		if (unlikely(__kvmppc_get_msr_hv(vcpu) & MSR_PR)) {
 			/*
 			 * Guest userspace executed sc 1. This can only be
 			 * reached by the P9 path because the old path
@@ -1758,7 +1758,7 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 			break;
 		}
 
-		if (!(vcpu->arch.shregs.msr & MSR_DR))
+		if (!(__kvmppc_get_msr_hv(vcpu) & MSR_DR))
 			vsid = vcpu->kvm->arch.vrma_slb_v;
 		else
 			vsid = vcpu->arch.fault_gpa;
@@ -1782,7 +1782,7 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 		long err;
 
 		vcpu->arch.fault_dar = kvmppc_get_pc(vcpu);
-		vcpu->arch.fault_dsisr = vcpu->arch.shregs.msr &
+		vcpu->arch.fault_dsisr = __kvmppc_get_msr_hv(vcpu) &
 			DSISR_SRR1_MATCH_64S;
 		if (kvm_is_radix(vcpu->kvm) || !cpu_has_feature(CPU_FTR_ARCH_300)) {
 			/*
@@ -1791,7 +1791,7 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 			 * hash fault handling below is v3 only (it uses ASDR
 			 * via fault_gpa).
 			 */
-			if (vcpu->arch.shregs.msr & HSRR1_HISI_WRITE)
+			if (__kvmppc_get_msr_hv(vcpu) & HSRR1_HISI_WRITE)
 				vcpu->arch.fault_dsisr |= DSISR_ISSTORE;
 			r = RESUME_PAGE_FAULT;
 			break;
@@ -1805,7 +1805,7 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 			break;
 		}
 
-		if (!(vcpu->arch.shregs.msr & MSR_IR))
+		if (!(__kvmppc_get_msr_hv(vcpu) & MSR_IR))
 			vsid = vcpu->kvm->arch.vrma_slb_v;
 		else
 			vsid = vcpu->arch.fault_gpa;
@@ -1895,7 +1895,7 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 		kvmppc_dump_regs(vcpu);
 		printk(KERN_EMERG "trap=0x%x | pc=0x%lx | msr=0x%llx\n",
 			vcpu->arch.trap, kvmppc_get_pc(vcpu),
-			vcpu->arch.shregs.msr);
+			__kvmppc_get_msr_hv(vcpu));
 		run->hw.hardware_exit_reason = vcpu->arch.trap;
 		r = RESUME_HOST;
 		break;
@@ -1919,11 +1919,11 @@ static int kvmppc_handle_nested_exit(struct kvm_vcpu *vcpu)
 	 * That can happen due to a bug, or due to a machine check
 	 * occurring at just the wrong time.
 	 */
-	if (vcpu->arch.shregs.msr & MSR_HV) {
+	if (__kvmppc_get_msr_hv(vcpu) & MSR_HV) {
 		pr_emerg("KVM trap in HV mode while nested!\n");
 		pr_emerg("trap=0x%x | pc=0x%lx | msr=0x%llx\n",
 			 vcpu->arch.trap, kvmppc_get_pc(vcpu),
-			 vcpu->arch.shregs.msr);
+			 __kvmppc_get_msr_hv(vcpu));
 		kvmppc_dump_regs(vcpu);
 		return RESUME_HOST;
 	}
@@ -1980,7 +1980,7 @@ static int kvmppc_handle_nested_exit(struct kvm_vcpu *vcpu)
 		vcpu->arch.fault_dar = kvmppc_get_pc(vcpu);
 		vcpu->arch.fault_dsisr = kvmppc_get_msr(vcpu) &
 					 DSISR_SRR1_MATCH_64S;
-		if (vcpu->arch.shregs.msr & HSRR1_HISI_WRITE)
+		if (__kvmppc_get_msr_hv(vcpu) & HSRR1_HISI_WRITE)
 			vcpu->arch.fault_dsisr |= DSISR_ISSTORE;
 		srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 		r = kvmhv_nested_page_fault(vcpu);
@@ -2940,7 +2940,7 @@ static int kvmppc_core_vcpu_create_hv(struct kvm_vcpu *vcpu)
 	spin_lock_init(&vcpu->arch.vpa_update_lock);
 	spin_lock_init(&vcpu->arch.tbacct_lock);
 	vcpu->arch.busy_preempt = TB_NIL;
-	vcpu->arch.shregs.msr = MSR_ME;
+	__kvmppc_set_msr_hv(vcpu, MSR_ME);
 	vcpu->arch.intr_msr = MSR_SF | MSR_ME;
 
 	/*
@@ -4188,7 +4188,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		__this_cpu_write(cpu_in_guest, NULL);
 
 		if (trap == BOOK3S_INTERRUPT_SYSCALL &&
-		    !(vcpu->arch.shregs.msr & MSR_PR)) {
+		    !(__kvmppc_get_msr_hv(vcpu) & MSR_PR)) {
 			unsigned long req = kvmppc_get_gpr(vcpu, 3);
 
 			/*
@@ -4667,7 +4667,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	if (!nested) {
 		kvmppc_core_prepare_to_enter(vcpu);
-		if (vcpu->arch.shregs.msr & MSR_EE) {
+		if (__kvmppc_get_msr_hv(vcpu) & MSR_EE) {
 			if (xive_interrupt_pending(vcpu))
 				kvmppc_inject_interrupt_hv(vcpu,
 						BOOK3S_INTERRUPT_EXTERNAL, 0);
@@ -4880,7 +4880,7 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 		if (run->exit_reason == KVM_EXIT_PAPR_HCALL) {
 			accumulate_time(vcpu, &vcpu->arch.hcall);
 
-			if (WARN_ON_ONCE(vcpu->arch.shregs.msr & MSR_PR)) {
+			if (WARN_ON_ONCE(__kvmppc_get_msr_hv(vcpu) & MSR_PR)) {
 				/*
 				 * These should have been caught reflected
 				 * into the guest by now. Final sanity check:
diff --git a/arch/powerpc/kvm/book3s_hv.h b/arch/powerpc/kvm/book3s_hv.h
index acd9a7a95bbf..95241764dfb4 100644
--- a/arch/powerpc/kvm/book3s_hv.h
+++ b/arch/powerpc/kvm/book3s_hv.h
@@ -51,6 +51,16 @@ void accumulate_time(struct kvm_vcpu *vcpu, struct kvmhv_tb_accumulator *next);
 #define end_timing(vcpu) do {} while (0)
 #endif
 
+static inline void __kvmppc_set_msr_hv(struct kvm_vcpu *vcpu, u64 val)
+{
+	vcpu->arch.shregs.msr = val;
+}
+
+static inline u64 __kvmppc_get_msr_hv(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.shregs.msr;
+}
+
 #define KVMPPC_BOOK3S_HV_VCPU_ACCESSOR_SET(reg, size)			\
 static inline void kvmppc_set_##reg ##_hv(struct kvm_vcpu *vcpu, u##size val)	\
 {									\
diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index f3afe194e616..fa0e3a22cac0 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -32,6 +32,7 @@
 
 #include "book3s_xics.h"
 #include "book3s_xive.h"
+#include "book3s_hv.h"
 
 /*
  * Hash page table alignment on newer cpus(CPU_FTR_ARCH_206)
@@ -514,7 +515,7 @@ void kvmppc_set_msr_hv(struct kvm_vcpu *vcpu, u64 msr)
 	 */
 	if ((msr & MSR_TS_MASK) == MSR_TS_MASK)
 		msr &= ~MSR_TS_MASK;
-	vcpu->arch.shregs.msr = msr;
+	__kvmppc_set_msr_hv(vcpu, msr);
 	kvmppc_end_cede(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvmppc_set_msr_hv);
@@ -552,7 +553,7 @@ static void inject_interrupt(struct kvm_vcpu *vcpu, int vec, u64 srr1_flags)
 	kvmppc_set_srr0(vcpu, pc);
 	kvmppc_set_srr1(vcpu, (msr & SRR1_MSR_BITS) | srr1_flags);
 	kvmppc_set_pc(vcpu, new_pc);
-	vcpu->arch.shregs.msr = new_msr;
+	__kvmppc_set_msr_hv(vcpu, new_msr);
 }
 
 void kvmppc_inject_interrupt_hv(struct kvm_vcpu *vcpu, int vec, u64 srr1_flags)
-- 
2.39.3

