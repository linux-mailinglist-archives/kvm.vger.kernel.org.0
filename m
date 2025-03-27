Return-Path: <kvm+bounces-42124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F53AA7361C
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 16:55:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 35680189C81D
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 15:55:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFC091A707A;
	Thu, 27 Mar 2025 15:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DkQBM5JX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FA219B3EE
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 15:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743090863; cv=none; b=PA9CB5uVEPiFquVF6e3wlsOSwbQZo4EZ1hmJxnKfnFR3j2OpQp3AHrgduDREUEyBMNYOzthrNSoWLZtPOZ5p3VYrPQ5iuRvY2MnCyvryFZRzi6NFclmkN9rQjHunwN1r9XU9SI53GjZDVNxH6o6xVCh3OkSCbuMGs7baxRkKqhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743090863; c=relaxed/simple;
	bh=WzDnZoRL2GHoBw2iX6vBVgEqYQTZatoXKuplpOVra0s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=al+LnNjNVYbKSNUUWfGJeWPnJ0wpIB4/H4DmTe+RQG4RFNxxUMWY4rzTW9HSPDOUOgrgbjK5vrMSPiJo3hlbNsD6Cy9vmoo1d7SVkqzujbiZEic/pJsNAEvTjfgQwdbuJPg6gqzV7Ntn8gohdgyO/60s6qRjKvte/+yh9M9gWmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DkQBM5JX; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff5296726fso3061692a91.0
        for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 08:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743090861; x=1743695661; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JPOek5XIFaCLSO51WWUE4tWRga3usE6vEqnf0+ZqRAU=;
        b=DkQBM5JXTd5yu8ZkXh6d2FGpusQo0aP40i0C3sVZpE90RA3fuvf+B8A4QtVqYPR6Pm
         LfFXkoANQ7aZCUZ7qzdAXJFojm6Dl07n0rgHhe7x0nnJDlqPnyzFzEtXvUwlLYPWMu06
         kzzL3J8yXoDsaxOnhTfrvbWpn54VjUkOztop4/jgZQfFDMozuB+Wni10LLbspBTdxC/f
         qjfEQAVEqhUJcLAA/GdScPS0TLvN8wlzadVNyE7EawByoQMNWD69I7Bhuh/ln7bFOz2n
         pOPpVq47rfCpLcTwMWQ54IF+9a+p7wDLcOxgk51U16/MWET5LTzcUH0+2ZaWZjy43gc0
         samQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743090861; x=1743695661;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JPOek5XIFaCLSO51WWUE4tWRga3usE6vEqnf0+ZqRAU=;
        b=D6NdMGOnuiNkbz1zw2Oz2KByb6v8E/RphmiXn6DfiSP3qQDhLuD5vfU1Y/LwuxUWkE
         MHLL0ZVraZMKepvnHTY1pUxYN4PM9I5WRZ0QYRQL09buLTdvVtkYm0oJYZ53T2nuLJyP
         FaYNFKxaNEZM69uznuiWFaNlZzoTFVChzfPQQSwD6KlX/K3uyyb0fuWrs0caC/XouoF+
         68QbrZPVwI57yT3F0uMBpsHuUaCHk02DQNe5jNh6i3+NtTouzIX+HHgCMowU5hW7OziD
         niJONxLZtKNn5I4MmC9AmpJwHOO0ECz/FpTEdOUBWmYtLbFYHJfex3t/FnDd06Fg3Yc8
         KNJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzonJ/eQdm0gca82wEZs6YJdgxA3BJhyo2tknAKBXWs2aBQjekBq6bXzbb/s+MQCDzPmA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLBu4fk4RVzZ69v4rKut034kaMwregqhwtQWep8KFfw0Rxfy78
	Fcyav7nXse1yQ4igQxyXnH1TMKIG8lrWbOsbDmgyRx/JiepDAdYgEZyVMAAx/TC0rJbEQ/SPeZ0
	dHQ==
X-Google-Smtp-Source: AGHT+IEpsv3H+6GDKLikeC+QMNXPJuol4rgiTqt3+uFNYZnj+ykaPsz001YnHBSz/X3FMFw68HdiYxMtMSU=
X-Received: from pjbsv4.prod.google.com ([2002:a17:90b:5384:b0:2ff:6e58:8a03])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3147:b0:2fe:8c22:48b0
 with SMTP id 98e67ed59e1d1-303a7f653d4mr6822095a91.15.1743090861520; Thu, 27
 Mar 2025 08:54:21 -0700 (PDT)
Date: Thu, 27 Mar 2025 08:54:19 -0700
In-Reply-To: <20250313181629.17764-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250313181629.17764-1-adrian.hunter@intel.com>
Message-ID: <Z-V0qyTn2bXdrPF7@google.com>
Subject: Re: [PATCH RFC] KVM: TDX: Defer guest memory removal to decrease
 shutdown time
From: Sean Christopherson <seanjc@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kirill.shutemov@linux.intel.com, kai.huang@intel.com, 
	reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com, 
	isaku.yamahata@intel.com, linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 13, 2025, Adrian Hunter wrote:
> Improve TDX shutdown performance by adding a more efficient shutdown
> operation at the cost of adding separate branches for the TDX MMU
> operations for normal runtime and shutdown.  This more efficient method was
> previously used in earlier versions of the TDX patches, but was removed to
> simplify the initial upstreaming.  This is an RFC, and still needs a proper
> upstream commit log. It is intended to be an eventual follow up to base
> support.

...

> == Options ==
> 
>   1. Start TD teardown earlier so that when pages are removed,
>   they can be reclaimed faster.
>   2. Defer page removal until after TD teardown has started.
>   3. A combination of 1 and 2.
> 
> Option 1 is problematic because it means putting the TD into a non-runnable
> state while it is potentially still active. Also, as mentioned above, Sean
> effectively NAK'ed it.

Option 2 is just as gross, arguably even worse.  I NAK'd a flavor of option 1,
not the base concept of initiating teardown before all references to the VM are
put.

AFAICT, nothing outright prevents adding a TDX sub-ioctl to terminate the VM.
The locking is a bit heinous, but I would prefer heavy locking to deferring
reclaim and pinning inodes.

Oh FFS.  This is also an opportunity to cleanup RISC-V's insidious copy-paste of
ARM.  Because extracting (un)lock_all_vcpus() to common code would have been sooo
hard.  *sigh*

Very roughly, something like the below (*completely* untested).

An alternative to taking mmu_lock would be to lock all bound guest_memfds, but I
think I prefer taking mmu_lock is it's easier to reason about the safety of freeing
the HKID.  Note, the truncation phase of a PUNCH_HOLE could still run in parallel,
but that's a-ok.  The only part of PUNCH_HOLE that needs to be blocked is the call
to kvm_mmu_unmap_gfn_range().

---
 arch/x86/kvm/vmx/tdx.c | 61 ++++++++++++++++++++++++++++++------------
 1 file changed, 44 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 87f188021cbd..6fb595c272ab 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -472,7 +472,7 @@ static void smp_func_do_phymem_cache_wb(void *unused)
 		pr_tdx_error(TDH_PHYMEM_CACHE_WB, err);
 }
 
-void tdx_mmu_release_hkid(struct kvm *kvm)
+static void __tdx_release_hkid(struct kvm *kvm, bool terminate)
 {
 	bool packages_allocated, targets_allocated;
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
@@ -485,10 +485,11 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	if (!is_hkid_assigned(kvm_tdx))
 		return;
 
+	if (KVM_BUG_ON(refcount_read(&kvm->users_count) && !terminate))
+		return;
+
 	packages_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
 	targets_allocated = zalloc_cpumask_var(&targets, GFP_KERNEL);
-	cpus_read_lock();
-
 	kvm_for_each_vcpu(j, vcpu, kvm)
 		tdx_flush_vp_on_cpu(vcpu);
 
@@ -500,12 +501,8 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	 */
 	mutex_lock(&tdx_lock);
 
-	/*
-	 * Releasing HKID is in vm_destroy().
-	 * After the above flushing vps, there should be no more vCPU
-	 * associations, as all vCPU fds have been released at this stage.
-	 */
 	err = tdh_mng_vpflushdone(&kvm_tdx->td);
+	/* Uh, what's going on here? */
 	if (err == TDX_FLUSHVP_NOT_DONE)
 		goto out;
 	if (KVM_BUG_ON(err, kvm)) {
@@ -515,6 +512,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 		goto out;
 	}
 
+	write_lock(&kvm->mmu_lock);
 	for_each_online_cpu(i) {
 		if (packages_allocated &&
 		    cpumask_test_and_set_cpu(topology_physical_package_id(i),
@@ -539,14 +537,21 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	} else {
 		tdx_hkid_free(kvm_tdx);
 	}
-
+	write_unlock(&kvm->mmu_lock);
 out:
 	mutex_unlock(&tdx_lock);
-	cpus_read_unlock();
 	free_cpumask_var(targets);
 	free_cpumask_var(packages);
 }
 
+void tdx_mmu_release_hkid(struct kvm *kvm)
+{
+	cpus_read_lock();
+	__tdx_release_hkid(kvm, false);
+	cpus_read_unlock();
+}
+
+
 static void tdx_reclaim_td_control_pages(struct kvm *kvm)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
@@ -1789,13 +1794,10 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	struct page *page = pfn_to_page(pfn);
 	int ret;
 
-	/*
-	 * HKID is released after all private pages have been removed, and set
-	 * before any might be populated. Warn if zapping is attempted when
-	 * there can't be anything populated in the private EPT.
-	 */
-	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
-		return -EINVAL;
+	if (!is_hkid_assigned(to_kvm_tdx(kvm)), kvm) {
+		WARN_ON_ONCE(!kvm->vm_dead);
+		return tdx_reclaim_page(pfn_to_page(pfn));
+	}
 
 	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
 	if (ret <= 0)
@@ -2790,6 +2792,28 @@ static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	return 0;
 }
 
+static int tdx_td_terminate(struct kvm *kvm)
+{
+	struct kvm_memory_slot *slot;
+	struct kvm_memslots *slots;
+	int bkt;
+
+	cpus_read_lock();
+	guard(mutex)(&kvm->lock);
+
+	r = kvm_lock_all_vcpus();
+	if (r)
+		goto out;
+
+	kvm_vm_dead(kvm);
+	kvm_unlock_all_vcpus();
+
+	__tdx_release_hkid(kvm);
+out:
+	cpus_read_unlock();
+	return r;
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
@@ -2805,6 +2829,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	if (tdx_cmd.hw_error)
 		return -EINVAL;
 
+	if (tdx_cmd.id == KVM_TDX_TERMINATE_VM)
+		return tdx_td_terminate(kvm);
+
 	mutex_lock(&kvm->lock);
 
 	switch (tdx_cmd.id) {

base-commit: 2156c3c7d60c5be9c0d9ab1fedccffe3c55a2ca0
-- 

