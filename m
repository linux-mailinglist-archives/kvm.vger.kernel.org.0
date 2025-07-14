Return-Path: <kvm+bounces-52363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CFA5BB04A6C
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 00:20:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FB3B1A62E53
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 22:20:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 430EE277C95;
	Mon, 14 Jul 2025 22:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TFI22ITP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EB41DF985
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 22:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752531452; cv=none; b=ahTzED+g9T28o2Ark+86Wju0RIsWzN25Cl5rhZ23b5ax50DH3Su6UBNLghmzJe7wEwdMO0grjXYN0wggUM3Hsk4yt97/rB6808qqDCokPA1Bl8W2izGPlDUcuN6O1kuxiKbD8RpfRE1JwwH7m+WGcc9SQPg1WJBmPAb86GoYX68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752531452; c=relaxed/simple;
	bh=q6PdS6wlvZ8hWbAhQaU+AV70alnsbuxe09DmeKdhbgE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EbrBIF/5GA8BmoU2BoXZ77vtiF73Rn1HETytaha/c//aC/h5Kw140MgiehYy9pBoWQ/BnyLdZNjGyeeeBWFPjwfRkrpWWcvJxpxdIEhwyejm7njMQUJIzJC8ayC0Zi4QmVKp8KC5nBbczV02ESBV8X6sO/otzsiaK3+7u4WMimM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TFI22ITP; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2c36951518so5339272a12.2
        for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 15:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752531450; x=1753136250; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YsfqHZF2eex1fFWEZK+9hGZCkr1RmGiBcZKUCMjWg4E=;
        b=TFI22ITPwGpOWveDiykfdPJsCXMtC0pZdHlVtwQJogOSngzh5U4LESdWY4/mJMZZAL
         DIUMPEFydd/P40hwSaz1G2h0QfTF8Hrh8H4ZGa5xlgQJAKTgME48liU9HgbMCD3RdYBq
         O+M0Z07JEmlaej2P5S4COk+O5/VvYd7leY9J7/aWXBfUCm3xo/xDRKAK9DxAItJsY3rD
         5mM0X0rHcWtIQMM6Peas7VLChb/8YpWuFqPq0+VAKcVcV2pe+jgoCPxb9N0poSN5GXuJ
         4L3eHKreAA025VjopsG1D4v3gMEjYaCkkI4ezZtcq4Q+VnqPIrVPZwaTB6cSALwPHwRe
         qgoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752531450; x=1753136250;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YsfqHZF2eex1fFWEZK+9hGZCkr1RmGiBcZKUCMjWg4E=;
        b=crUlAD/N4SehOUs2sSwjCImpeNoJtE/1gO4IBykJZ1cqVSRLYJKALhXwDPVfXbwQBz
         t4C6xGrI992YMjMdTlIMlTLfBzoJ08LVyf11n5RIBoqZgPczMVxMZJcxgpwzaT5G/QK/
         awkBKwatlZQwH+TpDVgZOoKuKsyRKBiL+q1uLaBq6sdk3E6evTHDs5bY/eOD403jmSBp
         mCSOZ6QAuheWboFhzNe0UshHXVCKFGwhdbYoRq4cnsZmLaxuEcs6BhIv/2G2fV9+w+M3
         qSIZt4BFPsENJTxgE74xLadc7kLtqTwB7M7mfrXbMJxk5yYRS3MnVCeR1nZYBMvaGNi+
         grBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfeRbzg97H0lScAprH54sPsdxyCJy1V3G+7p/LQK8kaLRR2zlQvMXmB59MKGs5OiW6iao=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHSHtS7bB2GLmhdg906RcOL0wb2dstOjvs2xyRQYKnyqnaFf6i
	0WFPnWV0AC1Tk53FVXIf8OdjSnAzOAILgupMlhvuzi2XEhV4tJo3y5h/gVqX9xemTg7uMymlmdJ
	irtQdQg==
X-Google-Smtp-Source: AGHT+IENFWroR9VdJzaKaolkunqI1VmDLzziPdV/9v1noDcfmOsawCXVJaeB2x5PgPIld5+VOoiKV62f+d8=
X-Received: from pgac7.prod.google.com ([2002:a05:6a02:2947:b0:b2f:6290:cd48])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:e198:b0:220:9174:dd5f
 with SMTP id adf61e73a8af0-2311e53433bmr27105907637.15.1752531449933; Mon, 14
 Jul 2025 15:17:29 -0700 (PDT)
Date: Mon, 14 Jul 2025 15:17:28 -0700
In-Reply-To: <aHU1PGWwp9f6q8sk@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <935a82e3-f7ad-47d7-aaaf-f3d2b62ed768@amd.com> <F7AF073C-D630-45A3-8746-DE66B15FC3E1@sjtu.edu.cn>
 <aHUYwCNDWlsar3qk@google.com> <15D0C887-E17F-4432-8716-BF62EEE61B6B@sjtu.edu.cn>
 <aHUe5HY4C2vungCd@google.com> <aHU1PGWwp9f6q8sk@google.com>
Message-ID: <aHWB-JPG8r_x2w-A@google.com>
Subject: Re: [BUG] NULL pointer dereference in sev_writeback_caches during KVM
 SEV migration kselftest on AMD platform
From: Sean Christopherson <seanjc@google.com>
To: Zheyun Shen <szy0127@sjtu.edu.cn>
Cc: Srikanth Aithal <sraithal@amd.com>, linux-next@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 14, 2025, Sean Christopherson wrote:
> So as much as I want to avoid allocating another cpumask (ugh), it's the right
> thing to do.  And practically speaking, I doubt many real world users of SEV will
> be using MAXSMP, i.e. the allocations don't exist anyways.
> 
> Unless someone objects and/or has a better idea, I'll squash this:
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 95668e84ab86..e39726d258b8 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2072,6 +2072,17 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>         if (ret)
>                 goto out_source_vcpu;
>  
> +       /*
> +        * Allocate a new have_run_cpus for the destination, i.e. don't copy
> +        * the set of CPUs from the source.  If a CPU was used to run a vCPU in
> +        * the source VM but is never used for the destination VM, then the CPU
> +        * can only have cached memory that was accessible to the source VM.
> +        */
> +       if (!zalloc_cpumask_var(&dst_sev->have_run_cpus, GFP_KERNEL_ACCOUNT)) {
> +               ret = -ENOMEM;
> +               goto out_source_vcpu;
> +       }
> +
>         sev_migrate_from(kvm, source_kvm);
>         kvm_vm_dead(source_kvm);
>         cg_cleanup_sev = src_sev;
> @@ -2771,13 +2782,18 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>                 goto e_unlock;
>         }
>  
> +       mirror_sev = to_kvm_sev_info(kvm);
> +       if (!zalloc_cpumask_var(&mirror_sev->have_run_cpus, GFP_KERNEL_ACCOUNT)) {
> +               ret = -ENOMEM;
> +               goto e_unlock;
> +       }
> +
>         /*
>          * The mirror kvm holds an enc_context_owner ref so its asid can't
>          * disappear until we're done with it
>          */
>         source_sev = to_kvm_sev_info(source_kvm);
>         kvm_get_kvm(source_kvm);
> -       mirror_sev = to_kvm_sev_info(kvm);
>         list_add_tail(&mirror_sev->mirror_entry, &source_sev->mirror_vms);
>  
>         /* Set enc_context_owner and copy its encryption context over */

This isn't quite right either, because sev_vm_destroy() won't free the cpumask
for mirror VMs.

Aha!  And KVM will also unnecessarily leak have_run_cpus if SNP decomission
fails (though that should be an extremely rare error scecnario).

KVM is guaranteed to have blasted WBINVD before reaching sev_vm_destroy() (see
commit 7e00013bd339 "KVM: SVM: Remove wbinvd in sev_vm_destroy()"), so unless I'm
missing something, KVM can simply free have_run_cpus at the start of sev_vm_destroy().

Ooh, side topic!  The fact that sev_vm_destroy() wasn't blasting WBINVD would
have been a bug if not for kvm_arch_guest_memory_reclaimed() and
kvm_arch_gmem_invalidate() taking care of mirror VMs.

New hash for the patch:

  KVM: SVM: Flush cache only on CPUs running SEV guest
  https://github.com/kvm-x86/linux/commit/6f38f8c57464

And the full contexts of what I force-pushed:

--
From: Zheyun Shen <szy0127@sjtu.edu.cn>
Date: Thu, 22 May 2025 16:37:32 -0700
Subject: [PATCH] KVM: SVM: Flush cache only on CPUs running SEV guest

On AMD CPUs without ensuring cache consistency, each memory page
reclamation in an SEV guest triggers a call to do WBNOINVD/WBINVD on all
CPUs, thereby affecting the performance of other programs on the host.

Typically, an AMD server may have 128 cores or more, while the SEV guest
might only utilize 8 of these cores. Meanwhile, host can use qemu-affinity
to bind these 8 vCPUs to specific physical CPUs.

Therefore, keeping a record of the physical core numbers each time a vCPU
runs can help avoid flushing the cache for all CPUs every time.

Take care to allocate the cpumask used to track which CPUs have run a
vCPU when copying or moving an "encryption context", as nothing guarantees
memory in a mirror VM is a strict subset of the ASID owner, and the
destination VM for intrahost migration needs to maintain it's own set of
CPUs.  E.g. for intrahost migration, if a CPU was used for the source VM
but not the destination VM, then it can only have cached memory that was
accessible to the source VM.  And a CPU that was run in the source is also
used by the destination is no different than a CPU that was run in the
destination only.

Note, KVM is guaranteed to do flush caches prior to sev_vm_destroy(),
thanks to kvm_arch_guest_memory_reclaimed for SEV and SEV-ES, and
kvm_arch_gmem_invalidate() for SEV-SNP.  I.e. it's safe to free the
cpumask prior to unregistering encrypted regions and freeing the ASID.

Cc: Srikanth Aithal <sraithal@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20250522233733.3176144-9-seanjc@google.com
Link: https://lore.kernel.org/all/935a82e3-f7ad-47d7-aaaf-f3d2b62ed768@amd.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 71 ++++++++++++++++++++++++++++++++++++------
 arch/x86/kvm/svm/svm.h |  1 +
 2 files changed, 63 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ed39f8a4d9df..a62cd27a4f45 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -447,7 +447,12 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	init_args.probe = false;
 	ret = sev_platform_init(&init_args);
 	if (ret)
-		goto e_free;
+		goto e_free_asid;
+
+	if (!zalloc_cpumask_var(&sev->have_run_cpus, GFP_KERNEL_ACCOUNT)) {
+		ret = -ENOMEM;
+		goto e_free_asid;
+	}
 
 	/* This needs to happen after SEV/SNP firmware initialization. */
 	if (vm_type == KVM_X86_SNP_VM) {
@@ -465,6 +470,8 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	return 0;
 
 e_free:
+	free_cpumask_var(sev->have_run_cpus);
+e_free_asid:
 	argp->error = init_args.error;
 	sev_asid_free(sev);
 	sev->asid = 0;
@@ -709,16 +716,31 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
 	}
 }
 
-static void sev_writeback_caches(void)
+static void sev_writeback_caches(struct kvm *kvm)
 {
+	/*
+	 * Note, the caller is responsible for ensuring correctness if the mask
+	 * can be modified, e.g. if a CPU could be doing VMRUN.
+	 */
+	if (cpumask_empty(to_kvm_sev_info(kvm)->have_run_cpus))
+		return;
+
 	/*
 	 * Ensure that all dirty guest tagged cache entries are written back
 	 * before releasing the pages back to the system for use.  CLFLUSH will
 	 * not do this without SME_COHERENT, and flushing many cache lines
 	 * individually is slower than blasting WBINVD for large VMs, so issue
-	 * WBNOINVD (or WBINVD if the "no invalidate" variant is unsupported).
+	 * WBNOINVD (or WBINVD if the "no invalidate" variant is unsupported)
+	 * on CPUs that have done VMRUN, i.e. may have dirtied data using the
+	 * VM's ASID.
+	 *
+	 * For simplicity, never remove CPUs from the bitmap.  Ideally, KVM
+	 * would clear the mask when flushing caches, but doing so requires
+	 * serializing multiple calls and having responding CPUs (to the IPI)
+	 * mark themselves as still running if they are running (or about to
+	 * run) a vCPU for the VM.
 	 */
-	wbnoinvd_on_all_cpus();
+	wbnoinvd_on_cpus_mask(to_kvm_sev_info(kvm)->have_run_cpus);
 }
 
 static unsigned long get_num_contig_pages(unsigned long idx,
@@ -2046,6 +2068,17 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	if (ret)
 		goto out_source_vcpu;
 
+	/*
+	 * Allocate a new have_run_cpus for the destination, i.e. don't copy
+	 * the set of CPUs from the source.  If a CPU was used to run a vCPU in
+	 * the source VM but is never used for the destination VM, then the CPU
+	 * can only have cached memory that was accessible to the source VM.
+	 */
+	if (!zalloc_cpumask_var(&dst_sev->have_run_cpus, GFP_KERNEL_ACCOUNT)) {
+		ret = -ENOMEM;
+		goto out_source_vcpu;
+	}
+
 	sev_migrate_from(kvm, source_kvm);
 	kvm_vm_dead(source_kvm);
 	cg_cleanup_sev = src_sev;
@@ -2707,7 +2740,7 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
 		goto failed;
 	}
 
-	sev_writeback_caches();
+	sev_writeback_caches(kvm);
 
 	__unregister_enc_region_locked(kvm, region);
 
@@ -2749,13 +2782,18 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 		goto e_unlock;
 	}
 
+	mirror_sev = to_kvm_sev_info(kvm);
+	if (!zalloc_cpumask_var(&mirror_sev->have_run_cpus, GFP_KERNEL_ACCOUNT)) {
+		ret = -ENOMEM;
+		goto e_unlock;
+	}
+
 	/*
 	 * The mirror kvm holds an enc_context_owner ref so its asid can't
 	 * disappear until we're done with it
 	 */
 	source_sev = to_kvm_sev_info(source_kvm);
 	kvm_get_kvm(source_kvm);
-	mirror_sev = to_kvm_sev_info(kvm);
 	list_add_tail(&mirror_sev->mirror_entry, &source_sev->mirror_vms);
 
 	/* Set enc_context_owner and copy its encryption context over */
@@ -2817,7 +2855,13 @@ void sev_vm_destroy(struct kvm *kvm)
 
 	WARN_ON(!list_empty(&sev->mirror_vms));
 
-	/* If this is a mirror_kvm release the enc_context_owner and skip sev cleanup */
+	free_cpumask_var(sev->have_run_cpus);
+
+	/*
+	 * If this is a mirror VM, remove it from the owner's list of a mirrors
+	 * and skip ASID cleanup (the ASID is tied to the lifetime of the owner).
+	 * Note, mirror VMs don't support registering encrypted regions.
+	 */
 	if (is_mirroring_enc_context(kvm)) {
 		struct kvm *owner_kvm = sev->enc_context_owner;
 
@@ -3106,7 +3150,7 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
 	return;
 
 do_sev_writeback_caches:
-	sev_writeback_caches();
+	sev_writeback_caches(vcpu->kvm);
 }
 
 void sev_guest_memory_reclaimed(struct kvm *kvm)
@@ -3119,7 +3163,7 @@ void sev_guest_memory_reclaimed(struct kvm *kvm)
 	if (!sev_guest(kvm) || sev_snp_guest(kvm))
 		return;
 
-	sev_writeback_caches();
+	sev_writeback_caches(kvm);
 }
 
 void sev_free_vcpu(struct kvm_vcpu *vcpu)
@@ -3451,6 +3495,15 @@ int pre_sev_run(struct vcpu_svm *svm, int cpu)
 	if (sev_es_guest(kvm) && !VALID_PAGE(svm->vmcb->control.vmsa_pa))
 		return -EINVAL;
 
+	/*
+	 * To optimize cache flushes when memory is reclaimed from an SEV VM,
+	 * track physical CPUs that enter the guest for SEV VMs and thus can
+	 * have encrypted, dirty data in the cache, and flush caches only for
+	 * CPUs that have entered the guest.
+	 */
+	if (!cpumask_test_cpu(cpu, to_kvm_sev_info(kvm)->have_run_cpus))
+		cpumask_set_cpu(cpu, to_kvm_sev_info(kvm)->have_run_cpus);
+
 	/* Assign the asid allocated with this SEV guest */
 	svm->asid = asid;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index e6f3c6a153a0..a7c6f07260cf 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -113,6 +113,7 @@ struct kvm_sev_info {
 	void *guest_req_buf;    /* Bounce buffer for SNP Guest Request input */
 	void *guest_resp_buf;   /* Bounce buffer for SNP Guest Request output */
 	struct mutex guest_req_mutex; /* Must acquire before using bounce buffers */
+	cpumask_var_t have_run_cpus; /* CPUs that have done VMRUN for this VM. */
 };
 
 #define SEV_POLICY_NODBG	BIT_ULL(0)

base-commit: a77896eea33db6fe393d1db1380e2e52f74546a2
--

