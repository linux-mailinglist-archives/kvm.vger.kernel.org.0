Return-Path: <kvm+bounces-21564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5946092FF12
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:09:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CEB411F22D0B
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD69617E468;
	Fri, 12 Jul 2024 17:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="imE3CPHt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44177178394
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 17:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803731; cv=none; b=Ucc9Y3kRgxUb2oUO9KoSTR67TsazectOHdAfZ+qc1Vapuz8dJTylbaaWVDRxa5WAZdW4qwC7YFt+n521TMJQDMwh7t1eyw/zlG8BgQwWTZXdcicBo8HBEtXiS1LmkSjhASE36DIM+1CtDeerH0V6vyabS1id0nNn5kz342UM4k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803731; c=relaxed/simple;
	bh=OmLuPXVN7trRIGuXekfaSbCyKoP5mCssZ2C3O0VIpDk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MvoQ0KhcJp52ZatKpdjQpzUPfsQxOtgLlUmzuUTHL/63Q/ItJtP6qHQNFOQTfEDgZNaDi6cPMwC1GLcxbkdA61ARTNjdzp75pROivm7mkz9RFVEeoLpSOxpFYMUMeewPb3ZBG1mQmvN72GQZOW9My0gUdI7vh++AXQucue690xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=imE3CPHt; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-65ef46e8451so7970307b3.0
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 10:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720803728; x=1721408528; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zn579dgno7SZboGdojpY5JJU8xi+US4yr/l6Mjf8vz0=;
        b=imE3CPHt6jlzRoW0vuKAQGp9OZFSpMi25xzF3PEKMFcU1hZhDQWNKP1qvyePWygjd/
         ufbf20V5a2sfpeaEi1gvQIPrb56a4zltC13T1R62xC8d6EpG1UhDblf2tojno2E54gzm
         xD3I+y4D+nRBv4ZhmxCmz+Dfg1yzStVjoUT4W/vbEzJVPhtZe8tCaH/vIIabL8O+uXu0
         /zUvhLbc2ajV1oAh02quZOiCDIJg28/Lf4YpL7A0t9xHxSdLONIDvTpSWXsLGb9tcbIc
         k8fOfsh9Ae3hU6njntbwNjcoctdkhM5iSUeZhUZapmzoGk+wfnhsQ2s4TuatTuDZMlZm
         /Ewg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803728; x=1721408528;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zn579dgno7SZboGdojpY5JJU8xi+US4yr/l6Mjf8vz0=;
        b=up53lEMT+3lCcPad+QvVdd62sWzg9JYFo7kVa2GENLsdUf+pVDgGNQZu9g6r98Tb8a
         0LeJLsNP7AmFVdH54BR9Jomg0/Y6AH+MKgH7wkiQw5aj9MDBRyaiE5eCYhw0S88GeUFb
         zknZ0O684dR/QK+6UdKbAia1HVjPEREq80+1jjeZ6C5KcZrtuAlk0Wf5Ci65dIb5a96B
         u1xQgHJy3Iu2gqRRwvIVsvayArtBK+zTKnVqVxW8Bx5khgqgxaBw4M83a24FSyWZlMxZ
         41v40+f33PyN9y3eLhlILt7XcO+BGzo03S/f6IKOtIwwu6jAQ4mD5qYZyCX+40ot34RR
         lwKg==
X-Forwarded-Encrypted: i=1; AJvYcCVHktXEiu3+Hr0GJ9w94EpkKkxtPneFHvjBHwQEnwPJoFbORF7q23Sdpd6xRDOOrIWSIyGY7y1WBw0G1un40+QI2c+E
X-Gm-Message-State: AOJu0Yym3bPgNXG7Nibbw0jkUp7G7unSSgApKz+yf9HeWenq0BNUwrLu
	NA6g40V0PgLeaUjhUiJuMEVZQQJIA40AgDsVHdk9CC3ZtZonelVxpunZlay2tBHIHIzX8dmd8ac
	rN5Wm0vYTjQ==
X-Google-Smtp-Source: AGHT+IGmf1CJRMIpY+h+xba+0XgEdJs1Sqn1txDmOypcZe8mfXwCEjETMiBlkTEaYdYTy3241JdukP3H8LKm6w==
X-Received: from beeg.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11db])
 (user=jackmanb job=sendgmr) by 2002:a05:690c:46c8:b0:62c:de05:5a78 with SMTP
 id 00721157ae682-658f01fd061mr625407b3.6.1720803728252; Fri, 12 Jul 2024
 10:02:08 -0700 (PDT)
Date: Fri, 12 Jul 2024 17:00:44 +0000
In-Reply-To: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
X-Mailer: b4 0.14-dev
Message-ID: <20240712-asi-rfc-24-v1-26-144b319a40d8@google.com>
Subject: [PATCH 26/26] KVM: x86: asi: Add some mitigations on address space transitions
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

Here we start actually turning ASI into a real exploit mitigation. On
all CPUs we attempt to obliterate any indirect branch predictor training
before mapping in any secrets. We can also flush side channels on the
inverse transition. So, in this iteration we flush L1D, but only on CPUs
affected by L1TF.

The rationale for this is: L1TF seems to have been a relative outlier in
terms of its impact, and the mitigation is obviously rather devastating.
On the other hand, Spectre-type attacks are continuously being found,
and it's quite reasonable to assume that existing systems are vulnerable
to variations that are not currently mitigated by bespoke techniques
like Safe RET.

This is clearly an incomplete policy, for example it probably makes
sense to perform MDS mitigations in post_asi_enter, and there is clearly
a wide range of alternative postures with regard to per-platform vs
blanket mitigation configurations. This also ought to be integrated more
intelligently with bugs.c - this will probably require a fair bit of
discussion so it might warrant a patchset all to itself. For now though,
this ouhgt to provide an example of the kind of thing we might do with
ASI.

The changes to the inline asm for L1D flushes are to avoid duplicate
jump labels breaking the build in the case that vmx_l1d_flush() gets
inlined at multiple locations (as it seems to do in my builds).

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/include/asm/kvm_host.h      |  2 +
 arch/x86/include/asm/nospec-branch.h |  2 +
 arch/x86/kvm/vmx/vmx.c               | 88 ++++++++++++++++++++++++------------
 arch/x86/kvm/x86.c                   | 33 +++++++++++++-
 arch/x86/lib/retpoline.S             |  7 +++
 5 files changed, 101 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6c3326cb8273c..8b7226dd2e027 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1840,6 +1840,8 @@ struct kvm_x86_init_ops {
 
 	struct kvm_x86_ops *runtime_ops;
 	struct kvm_pmu_ops *pmu_ops;
+
+	void (*post_asi_enter)(void);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index ff5f1ecc7d1e6..9502bdafc1edd 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -605,6 +605,8 @@ static __always_inline void mds_idle_clear_cpu_buffers(void)
 		mds_clear_cpu_buffers();
 }
 
+extern void fill_return_buffer(void);
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_X86_NOSPEC_BRANCH_H_ */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1105d666a8ade..6efcbddf6ce27 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6629,37 +6629,18 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
  * is not exactly LRU. This could be sized at runtime via topology
  * information but as all relevant affected CPUs have 32KiB L1D cache size
  * there is no point in doing so.
+ *
+ * Must be reentrant, for use by vmx_post_asi_enter.
  */
-static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
+static inline_or_noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
 {
 	int size = PAGE_SIZE << L1D_CACHE_ORDER;
 
 	/*
-	 * This code is only executed when the flush mode is 'cond' or
-	 * 'always'
+	 * In theory we lose some of these increments to reentrancy under ASI.
+	 * We just tolerate imprecise stats rather than deal with synchronizing.
+	 * Anyway in practice on 64 bit it's gonna be a single instruction.
 	 */
-	if (static_branch_likely(&vmx_l1d_flush_cond)) {
-		bool flush_l1d;
-
-		/*
-		 * Clear the per-vcpu flush bit, it gets set again
-		 * either from vcpu_run() or from one of the unsafe
-		 * VMEXIT handlers.
-		 */
-		flush_l1d = vcpu->arch.l1tf_flush_l1d;
-		vcpu->arch.l1tf_flush_l1d = false;
-
-		/*
-		 * Clear the per-cpu flush bit, it gets set again from
-		 * the interrupt handlers.
-		 */
-		flush_l1d |= kvm_get_cpu_l1tf_flush_l1d();
-		kvm_clear_cpu_l1tf_flush_l1d();
-
-		if (!flush_l1d)
-			return;
-	}
-
 	vcpu->stat.l1d_flush++;
 
 	if (static_cpu_has(X86_FEATURE_FLUSH_L1D)) {
@@ -6670,26 +6651,57 @@ static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
 	asm volatile(
 		/* First ensure the pages are in the TLB */
 		"xorl	%%eax, %%eax\n"
-		".Lpopulate_tlb:\n\t"
+		".Lpopulate_tlb_%=:\n\t"
 		"movzbl	(%[flush_pages], %%" _ASM_AX "), %%ecx\n\t"
 		"addl	$4096, %%eax\n\t"
 		"cmpl	%%eax, %[size]\n\t"
-		"jne	.Lpopulate_tlb\n\t"
+		"jne	.Lpopulate_tlb_%=\n\t"
 		"xorl	%%eax, %%eax\n\t"
 		"cpuid\n\t"
 		/* Now fill the cache */
 		"xorl	%%eax, %%eax\n"
-		".Lfill_cache:\n"
+		".Lfill_cache_%=:\n"
 		"movzbl	(%[flush_pages], %%" _ASM_AX "), %%ecx\n\t"
 		"addl	$64, %%eax\n\t"
 		"cmpl	%%eax, %[size]\n\t"
-		"jne	.Lfill_cache\n\t"
+		"jne	.Lfill_cache_%=\n\t"
 		"lfence\n"
 		:: [flush_pages] "r" (vmx_l1d_flush_pages),
 		    [size] "r" (size)
 		: "eax", "ebx", "ecx", "edx");
 }
 
+static noinstr void vmx_maybe_l1d_flush(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * This code is only executed when the flush mode is 'cond' or
+	 * 'always'
+	 */
+	if (static_branch_likely(&vmx_l1d_flush_cond)) {
+		bool flush_l1d;
+
+		/*
+		 * Clear the per-vcpu flush bit, it gets set again
+		 * either from vcpu_run() or from one of the unsafe
+		 * VMEXIT handlers.
+		 */
+		flush_l1d = vcpu->arch.l1tf_flush_l1d;
+		vcpu->arch.l1tf_flush_l1d = false;
+
+		/*
+		 * Clear the per-cpu flush bit, it gets set again from
+		 * the interrupt handlers.
+		 */
+		flush_l1d |= kvm_get_cpu_l1tf_flush_l1d();
+		kvm_clear_cpu_l1tf_flush_l1d();
+
+		if (!flush_l1d)
+			return;
+	}
+
+	vmx_l1d_flush(vcpu);
+}
+
 static void vmx_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
@@ -7284,7 +7296,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	 * This is only after asi_enter() for performance reasons.
 	 */
 	if (static_branch_unlikely(&vmx_l1d_should_flush))
-		vmx_l1d_flush(vcpu);
+		vmx_maybe_l1d_flush(vcpu);
 	else if (static_branch_unlikely(&mmio_stale_data_clear) &&
 		 kvm_arch_has_assigned_device(vcpu->kvm))
 		mds_clear_cpu_buffers();
@@ -8321,6 +8333,14 @@ gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags
 	return (sign_extend64(gva, lam_bit) & ~BIT_ULL(63)) | (gva & BIT_ULL(63));
 }
 
+#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
+static noinstr void vmx_post_asi_enter(void)
+{
+	if (boot_cpu_has_bug(X86_BUG_L1TF))
+		vmx_l1d_flush(kvm_get_running_vcpu());
+}
+#endif
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.name = KBUILD_MODNAME,
 
@@ -8727,6 +8747,14 @@ static struct kvm_x86_init_ops vmx_init_ops __initdata = {
 
 	.runtime_ops = &vmx_x86_ops,
 	.pmu_ops = &intel_pmu_ops,
+
+#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
+	/*
+	 * Only Intel CPUs currently do anything in post-enter, so this is a
+	 * vendor hook for now.
+	 */
+	.post_asi_enter = vmx_post_asi_enter,
+#endif
 };
 
 static void vmx_cleanup_l1d_flush(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b9947e88d4ac6..b5e4df2aa1636 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9695,6 +9695,36 @@ static void kvm_x86_check_cpu_compat(void *ret)
 	*(int *)ret = kvm_x86_check_processor_compatibility();
 }
 
+#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
+
+static noinstr void pre_asi_exit(void)
+{
+	/*
+	 * Flush out prediction trainings by the guest before we go to access
+	 * secrets.
+	 */
+
+	/* Clear normal indirect branch predictions, if we haven't */
+	if (cpu_feature_enabled(X86_FEATURE_IBPB) &&
+	    !cpu_feature_enabled(X86_FEATURE_IBPB_ON_VMEXIT))
+		__wrmsr(MSR_IA32_PRED_CMD, PRED_CMD_IBPB, 0);
+
+	/* Flush the RAS/RSB if we haven't already. */
+	if (!IS_ENABLED(CONFIG_RETPOLINE) ||
+	    !cpu_feature_enabled(X86_FEATURE_RSB_VMEXIT))
+		fill_return_buffer();
+}
+
+struct asi_hooks asi_hooks = {
+	.pre_asi_exit = pre_asi_exit,
+	/* post_asi_enter populated later. */
+};
+
+#else /* CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION */
+struct asi_hooks asi_hooks = {};
+#endif /* CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION */
+
+
 int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 {
 	u64 host_pat;
@@ -9753,7 +9783,8 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	if (r)
 		goto out_free_percpu;
 
-	r = asi_register_class("KVM", NULL);
+	asi_hooks.post_asi_enter = ops->post_asi_enter;
+	r = asi_register_class("KVM", &asi_hooks);
 	if (r < 0)
 		goto out_mmu_exit;
 	kvm_asi_index = r;
diff --git a/arch/x86/lib/retpoline.S b/arch/x86/lib/retpoline.S
index 391059b2c6fbc..db5b8ee01efeb 100644
--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -396,3 +396,10 @@ SYM_CODE_END(__x86_return_thunk)
 EXPORT_SYMBOL(__x86_return_thunk)
 
 #endif /* CONFIG_MITIGATION_RETHUNK */
+
+.pushsection .noinstr.text, "ax"
+SYM_CODE_START(fill_return_buffer)
+	__FILL_RETURN_BUFFER(%_ASM_AX,RSB_CLEAR_LOOPS)
+	RET
+SYM_CODE_END(fill_return_buffer)
+.popsection

-- 
2.45.2.993.g49e7a77208-goog


