Return-Path: <kvm+bounces-21559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB54892FF08
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:07:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 749D52824F3
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:07:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76AFD17D8AF;
	Fri, 12 Jul 2024 17:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xj6l2CTD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13135178377
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 17:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803715; cv=none; b=mcL+mN/Emf6hfDKq1iHAfI0Xs5zX811mmmKBmTuJMZ5f9dFf0cvvcvgLulxEPo0osCoKJMJjR7SCGZQjaDXRCyCgirgtkuuuancH6Nlar7QTBrrBmnPThZFWZWVPRq+DYZ5J4fvtlSoYBlr818Z0YnypgKj/rRIrPZSKGmzIyNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803715; c=relaxed/simple;
	bh=RlnEc2kzUTtJVPred8ra/z6KZ+O/0UJVwVIJk8uU5UA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cV/UAmMNrpFRDyB6SxpSecbNUgkG5rFpgI75qLVJLJ9+J5I2aix4QtWesiXWonYrCurYLUxBVp+Fwug+AaGLUMmUVD28ANSbCoi1vkOTu+KRVjTXsjo1+ovJ10S8q4sfebOHl1vUNQTF1GtTZpiRj75l6MVZhs9aT6wvT9kKmH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xj6l2CTD; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-64b9800b377so41515377b3.0
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 10:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720803713; x=1721408513; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6yzlvtdLlwV2xo7wLZNn52PBY89yLp9ZWddfXkgzdEU=;
        b=xj6l2CTDjePDABHZ9WMo+3Xh/938jSAYAMhAJCnh4Tshfaw+ePABB2aERXMuWtp3Yk
         gK2jfxOIOhxqeXitFIDeh5pq09qig6YXzajhNnofOyS1g8qDWhhYeX3XFnENctbqm5ih
         W9ZUQGdHOaBSI2W0xyQ+kZTRZkF5i7zmXq48ALKbtZj/LM76ORowR0dRhN9m1IH0g9hr
         zB0G6SfY3HpPSUvqA9e3+GO2hPGu+32Wt9U/m8spK5B0/JkMYfoXU1I7zez6I8sFUHVd
         dY+UuyH9wQjv/W002TzLG0N9BtU9Pe8LKE9XsS9o1ytbKs5l4XpJEQjCejWDYKTwgkZR
         LLlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803713; x=1721408513;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6yzlvtdLlwV2xo7wLZNn52PBY89yLp9ZWddfXkgzdEU=;
        b=EzgE/8Ryh5VzOMpfhmh0i0vn2Ev9Woeh0ycGSZquAh/Scw3zQWI5w7K+1qc+7eZ9PU
         IyLB3Mjk5OJXhFKLtB5EFtEklNWsA3PTi5DHx2FzR21YD5kqhs/qdznbz8lWrUKlgyBt
         oiZP0x4AQ7NKhiFKmHrYkBdsEM9M2ULZ244vONIUlSaiH7tnggnOQqSVTPRHibHa/BKv
         VENviYha7twqYTLRgjHuPZjFbCFT2Ta4krCrwXbDoQ2l8nG41dZgnK7jemwsXAWSt7FR
         4YH6D0WxaQZum02EgjVn2NW8OuY6pZvhPUVh7U58IflIQgkKAUJ3m3mqrK+8QSj9wv70
         eppw==
X-Forwarded-Encrypted: i=1; AJvYcCWl0SNmYEWSOPbWRDguOAEtsG/qf62cpg5bVeiZMc9cilBfMcTGtBCKtCT9bKjmLXkffaGA7PekxtRAABQ4SrrwjiGD
X-Gm-Message-State: AOJu0Yy+SYYuMj/DaLbwSl4zBIws+eDDaWoIs1PXMJ38qwIpOMF1yjj7
	5EQqGUJKKbFqRtM79p+ZH4nz3eQIOfL3IaQHZMT24MXzi27EY+YcYNYys5OJOhFmjGeZWECLu6I
	G8dKN8TvbIw==
X-Google-Smtp-Source: AGHT+IGnjpXnxbERxy2U1NWxsSb37YpVUWZ9S/9b1Rm5PwazcdcV13kMgwRbwaJighCTP4xDBxvKZC1Kul9XcQ==
X-Received: from beeg.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11db])
 (user=jackmanb job=sendgmr) by 2002:a05:6902:1389:b0:e02:f35c:d398 with SMTP
 id 3f1490d57ef6-e058a707db8mr92172276.0.1720803713060; Fri, 12 Jul 2024
 10:01:53 -0700 (PDT)
Date: Fri, 12 Jul 2024 17:00:39 +0000
In-Reply-To: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
X-Mailer: b4 0.14-dev
Message-ID: <20240712-asi-rfc-24-v1-21-144b319a40d8@google.com>
Subject: [PATCH 21/26] KVM: x86: asi: Restricted address space for VM execution
From: Brendan Jackman <jackmanb@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexandre Chartre <alexandre.chartre@oracle.com>, Liran Alon <liran.alon@oracle.com>, 
	Jan Setje-Eilers <jan.setjeeilers@oracle.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
	Lorenzo Stoakes <lstoakes@gmail.com>, David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Michal Hocko <mhocko@kernel.org>, Khalid Aziz <khalid.aziz@oracle.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Valentin Schneider <vschneid@redhat.com>, Paul Turner <pjt@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Junaid Shahid <junaids@google.com>, Ofir Weisse <oweisse@google.com>, 
	Yosry Ahmed <yosryahmed@google.com>, Patrick Bellasi <derkling@google.com>, 
	KP Singh <kpsingh@google.com>, Alexandra Sandulescu <aesa@google.com>, 
	Matteo Rizzo <matteorizzo@google.com>, Jann Horn <jannh@google.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kvm@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"

An ASI restricted address space is added for KVM. It is currently only
enabled for Intel CPUs.

This change incorporates an extra asi_exit at the end of vcpu_run. We
expect later iterations of ASI to drop that call as we gain the
ablity to context switch within the ASI domain.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/svm/svm.c          |  2 ++
 arch/x86/kvm/vmx/vmx.c          | 36 ++++++++++++++++++++++--------------
 arch/x86/kvm/x86.c              | 29 +++++++++++++++++++++++++++--
 4 files changed, 54 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6efd1497b0263..6c3326cb8273c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -36,6 +36,7 @@
 #include <asm/kvm_page_track.h>
 #include <asm/kvm_vcpu_regs.h>
 #include <asm/hyperv-tlfs.h>
+#include <asm/asi.h>
 
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
 
@@ -1514,6 +1515,8 @@ struct kvm_arch {
 	 */
 #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
 	struct kvm_mmu_memory_cache split_desc_cache;
+
+	struct asi *asi;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9aaf83c8d57df..6f9a279c12dc7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4108,6 +4108,7 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
 	guest_state_enter_irqoff();
 
 	amd_clear_divider();
+	asi_enter(vcpu->kvm->arch.asi);
 
 	if (sev_es_guest(vcpu->kvm))
 		__svm_sev_es_vcpu_run(svm, spec_ctrl_intercepted,
@@ -4115,6 +4116,7 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
 	else
 		__svm_vcpu_run(svm, spec_ctrl_intercepted);
 
+	asi_relax();
 	guest_state_exit_irqoff();
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 22411f4aff530..1105d666a8ade 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -49,6 +49,7 @@
 #include <asm/mwait.h>
 #include <asm/spec-ctrl.h>
 #include <asm/vmx.h>
+#include <asm/asi.h>
 
 #include <trace/events/ipi.h>
 
@@ -7255,14 +7256,32 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 					unsigned int flags)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	unsigned long cr3;
 
 	guest_state_enter_irqoff();
+	asi_enter(vcpu->kvm->arch.asi);
+
+	/*
+	 * Refresh vmcs.HOST_CR3 if necessary.  This must be done immediately
+	 * prior to VM-Enter, as the kernel may load a new ASID (PCID) any time
+	 * it switches back to the current->mm, which can occur in KVM context
+	 * when switching to a temporary mm to patch kernel code, e.g. if KVM
+	 * toggles a static key while handling a VM-Exit.
+	 * Also, this must be done after asi_enter(), as it changes CR3
+	 * when switching address spaces.
+	 */
+	cr3 = __get_current_cr3_fast();
+	if (unlikely(cr3 != vmx->loaded_vmcs->host_state.cr3)) {
+		vmcs_writel(HOST_CR3, cr3);
+		vmx->loaded_vmcs->host_state.cr3 = cr3;
+	}
 
 	/*
 	 * L1D Flush includes CPU buffer clear to mitigate MDS, but VERW
 	 * mitigation for MDS is done late in VMentry and is still
 	 * executed in spite of L1D Flush. This is because an extra VERW
 	 * should not matter much after the big hammer L1D Flush.
+	 * This is only after asi_enter() for performance reasons.
 	 */
 	if (static_branch_unlikely(&vmx_l1d_should_flush))
 		vmx_l1d_flush(vcpu);
@@ -7283,6 +7302,8 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 
 	vmx->idt_vectoring_info = 0;
 
+	asi_relax();
+
 	vmx_enable_fb_clear(vmx);
 
 	if (unlikely(vmx->fail)) {
@@ -7311,7 +7332,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long cr3, cr4;
+	unsigned long cr4;
 
 	/* Record the guest's net vcpu time for enforced NMI injections. */
 	if (unlikely(!enable_vnmi &&
@@ -7354,19 +7375,6 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 		vmcs_writel(GUEST_RIP, vcpu->arch.regs[VCPU_REGS_RIP]);
 	vcpu->arch.regs_dirty = 0;
 
-	/*
-	 * Refresh vmcs.HOST_CR3 if necessary.  This must be done immediately
-	 * prior to VM-Enter, as the kernel may load a new ASID (PCID) any time
-	 * it switches back to the current->mm, which can occur in KVM context
-	 * when switching to a temporary mm to patch kernel code, e.g. if KVM
-	 * toggles a static key while handling a VM-Exit.
-	 */
-	cr3 = __get_current_cr3_fast();
-	if (unlikely(cr3 != vmx->loaded_vmcs->host_state.cr3)) {
-		vmcs_writel(HOST_CR3, cr3);
-		vmx->loaded_vmcs->host_state.cr3 = cr3;
-	}
-
 	cr4 = cr4_read_shadow();
 	if (unlikely(cr4 != vmx->loaded_vmcs->host_state.cr4)) {
 		vmcs_writel(HOST_CR4, cr4);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 91478b769af08..b9947e88d4ac6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -85,6 +85,7 @@
 #include <asm/emulate_prefix.h>
 #include <asm/sgx.h>
 #include <clocksource/hyperv_timer.h>
+#include <asm/asi.h>
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -318,6 +319,8 @@ u64 __read_mostly host_xcr0;
 
 static struct kmem_cache *x86_emulator_cache;
 
+static int __read_mostly kvm_asi_index = -1;
+
 /*
  * When called, it means the previous get/set msr reached an invalid msr.
  * Return true if we want to ignore/silent this failed msr access.
@@ -9750,6 +9753,11 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	if (r)
 		goto out_free_percpu;
 
+	r = asi_register_class("KVM", NULL);
+	if (r < 0)
+		goto out_mmu_exit;
+	kvm_asi_index = r;
+
 	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
 		host_xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 		kvm_caps.supported_xcr0 = host_xcr0 & KVM_SUPPORTED_XCR0;
@@ -9767,7 +9775,7 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 
 	r = ops->hardware_setup();
 	if (r != 0)
-		goto out_mmu_exit;
+		goto out_asi_unregister;
 
 	kvm_ops_update(ops);
 
@@ -9820,6 +9828,8 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 out_unwind_ops:
 	kvm_x86_ops.hardware_enable = NULL;
 	static_call(kvm_x86_hardware_unsetup)();
+out_asi_unregister:
+	asi_unregister_class(kvm_asi_index);
 out_mmu_exit:
 	kvm_mmu_vendor_module_exit();
 out_free_percpu:
@@ -9851,6 +9861,7 @@ void kvm_x86_vendor_exit(void)
 	cancel_work_sync(&pvclock_gtod_work);
 #endif
 	static_call(kvm_x86_hardware_unsetup)();
+	asi_unregister_class(kvm_asi_index);
 	kvm_mmu_vendor_module_exit();
 	free_percpu(user_return_msrs);
 	kmem_cache_destroy(x86_emulator_cache);
@@ -11436,6 +11447,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	r = vcpu_run(vcpu);
 
+	/*
+	 * At present ASI doesn't have the capability to transition directly
+	 * from the restricted address space to the user address space. So we
+	 * just return to the unrestricted address space in between.
+	 */
+	asi_exit();
+
 out:
 	kvm_put_guest_fpu(vcpu);
 	if (kvm_run->kvm_valid_regs)
@@ -12539,10 +12557,14 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	kvm_mmu_init_vm(kvm);
 
-	ret = static_call(kvm_x86_vm_init)(kvm);
+	ret = asi_init(kvm->mm, kvm_asi_index, &kvm->arch.asi);
 	if (ret)
 		goto out_uninit_mmu;
 
+	ret = static_call(kvm_x86_vm_init)(kvm);
+	if (ret)
+		goto out_asi_destroy;
+
 	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
 	atomic_set(&kvm->arch.noncoherent_dma_count, 0);
 
@@ -12579,6 +12601,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	return 0;
 
+out_asi_destroy:
+	asi_destroy(kvm->arch.asi);
 out_uninit_mmu:
 	kvm_mmu_uninit_vm(kvm);
 	kvm_page_track_cleanup(kvm);
@@ -12720,6 +12744,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_destroy_vcpus(kvm);
 	kvfree(rcu_dereference_check(kvm->arch.apic_map, 1));
 	kfree(srcu_dereference_check(kvm->arch.pmu_event_filter, &kvm->srcu, 1));
+	asi_destroy(kvm->arch.asi);
 	kvm_mmu_uninit_vm(kvm);
 	kvm_page_track_cleanup(kvm);
 	kvm_xen_destroy_vm(kvm);

-- 
2.45.2.993.g49e7a77208-goog


