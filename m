Return-Path: <kvm+bounces-52186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B356B021F3
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 18:38:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89AF1171C28
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 16:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47E642EF29A;
	Fri, 11 Jul 2025 16:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zbs/fxqU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540D61CDA3F;
	Fri, 11 Jul 2025 16:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752251881; cv=none; b=oSf97JfnQQWlhvW9uj7DxTjdAr+V9OX+V4APa0If3E26BNvLKJ7TZtCFYEKMIkGcXgV/T/JMlbyCPw25K1PhDeU2DwZ7mxt1ifD5nzUG/PT2yisHHxw6WFPwi2BY5nYFwsKoyzyGBG1mP1lteb1wkV+gwfY8v0KIySvg6nWMGfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752251881; c=relaxed/simple;
	bh=QAZcD5rwRQEymEaXE3HeYg5QulhnM/zknP1OwbVjQO0=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ndl656he8hC1Y1CEVMCM5jI0OamRgpHSSLzeRKz15wKA49x/MbUyeX5ZA4/4cJW3IH7MGF9s12P6nbHLei5J7nez/vuY2sAqsijjHKSAS+wy1USuqlS8c8ji8y2wgpa4mqXKLZ0O9HpbZ+lWwmKba9XPLbPqIxBG9TJNRS9FzOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zbs/fxqU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C8FC4CEED;
	Fri, 11 Jul 2025 16:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752251880;
	bh=QAZcD5rwRQEymEaXE3HeYg5QulhnM/zknP1OwbVjQO0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Zbs/fxqUBNGKLoaGChnrfgIXjCFT8qgS1NFYne+Dntrv03UofO6RaqUtVoGCE+qXT
	 4LtX9qSLWq9UEYXm2ndP+LYmAv1x/QXGD3xVHV5mBSjnPpEB2JeQyWIM9zAd/dzjAr
	 0kTk4tkpChqqlHuypQ1vg9t4JOW3VKGz5H2FExq+gJ9SFjngAv4IbeGCor1hutvXTt
	 CptaZVwXmq8EnVrNTabapFOmexWrDoBvxj85EkBU83yo8mpowJ4QeVoFEoTAvCbELS
	 NA40GDZsp8oDBlgqLLQnbL9JvGCF3suVqRJKzFwasbcrvuOpxcgLWBMNVGfUD7q1v8
	 zOVHb92flLc3Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uaGl3-00EwZT-Mo;
	Fri, 11 Jul 2025 17:37:57 +0100
Date: Fri, 11 Jul 2025 17:37:56 +0100
Message-ID: <865xfyadjv.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-mm@kvack.org,
	kvmarm@lists.linux.dev,
	pbonzini@redhat.com,
	chenhuacai@kernel.org,
	mpe@ellerman.id.au,
	anup@brainfault.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	seanjc@google.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	willy@infradead.org,
	akpm@linux-foundation.org,
	xiaoyao.li@intel.com,
	yilun.xu@intel.com,
	chao.p.peng@linux.intel.com,
	jarkko@kernel.org,
	amoorthy@google.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	mic@digikod.net,
	vbabka@suse.cz,
	vannapurve@google.com,
	ackerleytng@google.com,
	mail@maciej.szmigiero.name,
	david@redhat.com,
	michael.roth@amd.com,
	wei.w.wang@intel.com,
	liam.merwick@oracle.com,
	isaku.yamahata@gmail.com,
	kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com,
	steven.price@arm.com,
	quic_eberman@quicinc.com,
	quic_mnalajal@quicinc.com,
	quic_tsoni@quicinc.com,
	quic_svaddagi@quicinc.com,
	quic_cvanscha@quicinc.com,
	quic_pderrin@quicinc.com,
	quic_pheragu@quicinc.com,
	catalin.marinas@arm.com,
	james.morse@arm.com,
	yuzenghui@huawei.com,
	oliver.upton@linux.dev,
	will@kernel.org,
	qperret@google.com,
	keirf@google.com,
	roypat@amazon.co.uk,
	shuah@kernel.org,
	hch@infradead.org,
	jgg@nvidia.com,
	rientjes@google.com,
	jhubbard@nvidia.com,
	fvdl@google.com,
	hughd@google.com,
	jthoughton@google.com,
	peterx@redhat.com,
	pankaj.gupta@amd.com,
	ira.weiny@intel.com
Subject: Re: [PATCH v13 16/20] KVM: arm64: Handle guest_memfd-backed guest page faults
In-Reply-To: <20250709105946.4009897-17-tabba@google.com>
References: <20250709105946.4009897-1-tabba@google.com>
	<20250709105946.4009897-17-tabba@google.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/30.1
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: tabba@google.com, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, quic_pderr
 in@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 09 Jul 2025 11:59:42 +0100,
Fuad Tabba <tabba@google.com> wrote:
> 
> Add arm64 architecture support for handling guest page faults on memory
> slots backed by guest_memfd.
> 
> This change introduces a new function, gmem_abort(), which encapsulates
> the fault handling logic specific to guest_memfd-backed memory. The
> kvm_handle_guest_abort() entry point is updated to dispatch to
> gmem_abort() when a fault occurs on a guest_memfd-backed memory slot (as
> determined by kvm_slot_has_gmem()).
> 
> Until guest_memfd gains support for huge pages, the fault granule for
> these memory regions is restricted to PAGE_SIZE.
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/mmu.c | 82 ++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 79 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 58662e0ef13e..71f8b53683e7 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1512,6 +1512,78 @@ static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
>  	*prot |= kvm_encode_nested_level(nested);
>  }
>  
> +#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED)
> +
> +static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> +		      struct kvm_s2_trans *nested,
> +		      struct kvm_memory_slot *memslot, bool is_perm)
> +{
> +	bool write_fault, exec_fault, writable;
> +	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
> +	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> +	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> +	struct page *page;
> +	struct kvm *kvm = vcpu->kvm;
> +	void *memcache;
> +	kvm_pfn_t pfn;
> +	gfn_t gfn;
> +	int ret;
> +
> +	ret = prepare_mmu_memcache(vcpu, true, &memcache);
> +	if (ret)
> +		return ret;
> +
> +	if (nested)
> +		gfn = kvm_s2_trans_output(nested) >> PAGE_SHIFT;
> +	else
> +		gfn = fault_ipa >> PAGE_SHIFT;
> +
> +	write_fault = kvm_is_write_fault(vcpu);
> +	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> +
> +	if (write_fault && exec_fault) {
> +		kvm_err("Simultaneous write and execution fault\n");
> +		return -EFAULT;
> +	}

I don't think we need to cargo-cult this stuff. This cannot happen
architecturally (data and instruction aborts are two different
exceptions, so you can't have both at the same time), and is only
there because we were young and foolish when we wrote this crap.

Now that we (the royal We) are only foolish, we can save a few bits by
dropping it. Or turn it into a VM_BUG_ON() if you really want to keep
it.

> +
> +	if (is_perm && !write_fault && !exec_fault) {
> +		kvm_err("Unexpected L2 read permission error\n");
> +		return -EFAULT;
> +	}

Again, this is copying something that was always a bit crap:

- it's not an "error", it's a permission fault
- it's not "L2", it's "stage-2"

But this should equally be turned into an assertion, ideally in a
single spot. See below for the usual untested hack.

Thanks,

	M.

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index b92ce4d9b4e01..c79dc8fd45d5a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1540,16 +1540,7 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	write_fault = kvm_is_write_fault(vcpu);
 	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
-
-	if (write_fault && exec_fault) {
-		kvm_err("Simultaneous write and execution fault\n");
-		return -EFAULT;
-	}
-
-	if (is_perm && !write_fault && !exec_fault) {
-		kvm_err("Unexpected L2 read permission error\n");
-		return -EFAULT;
-	}
+	VM_BUG_ON(write_fault && exec_fault);
 
 	ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
 	if (ret) {
@@ -1616,11 +1607,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
 	VM_BUG_ON(write_fault && exec_fault);
 
-	if (fault_is_perm && !write_fault && !exec_fault) {
-		kvm_err("Unexpected L2 read permission error\n");
-		return -EFAULT;
-	}
-
 	/*
 	 * Permission faults just need to update the existing leaf entry,
 	 * and so normally don't require allocations from the memcache. The
@@ -2035,6 +2021,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		goto out_unlock;
 	}
 
+	VM_BUG_ON(kvm_vcpu_trap_is_permission_fault(vcpu) &&
+		  !write_fault && !kvm_vcpu_trap_is_exec_fault(vcpu));
+
 	if (kvm_slot_has_gmem(memslot))
 		ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
 				 esr_fsc_is_permission_fault(esr));

-- 
Without deviation from the norm, progress is not possible.

