Return-Path: <kvm+bounces-59733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C12BBCB0C9
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 00:15:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5DA53AE6B4
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 22:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 489E0285CA3;
	Thu,  9 Oct 2025 22:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xXAdcTHI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4002848B3
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 22:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760048138; cv=none; b=Stohk8I77jmI331iFKFn1N5REhjZWBkov7jvLACLWvjJ3m6vOD9PzQrRT+YMHsaXneqigSR/1i/uP+6+u6JscGe1vrIQu+4d+BpOPBbqxkWnPFYtJum0OU2FmYHPIn8uppjagMaoFh8gIceDvvvte54rWt5czEq8CRc8ooxatSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760048138; c=relaxed/simple;
	bh=rPMGm0dfGPMDOOmz7uP8n/Y9PsjG4xAePxsVEMFZ5Fs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Oe6X3JPyKl2JBVQUSXl2PE0hV5dVRcra4wGgwAYiwfJPJT4XB+5J6LdVJ1bvQAKFFpKrFXklIvyJDnNerEKYuQzi31IdvrOxsoGJSSh4UoDbCbbgFxaWgqwFrJss0A6mHOPEY9IbSJ6AIC8iO3VJpD5QT70wv5PX/Jp7XsW4RD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xXAdcTHI; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33428befc3aso3605388a91.2
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 15:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760048136; x=1760652936; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Oll1MPE7hkNDT7M/Q1/FAEUqkNVEA+iYvJPlZMv+EKE=;
        b=xXAdcTHIfMmoj6Wj292E+pBfjHulh5N8pit1x25y5XD0Eq+SyTynam0hUcU3lNaKMv
         SQqDnaij6+6eH8PE4+6/8WFz3ofeeDYFvinwsfdyAlsA6Z53vlByvOrJVZ8A7VxRCHvv
         MYqsC9OssUqc0BZWQpRxbklAzy8FYHEU6P0fL9VBv65faQSBnLZtHDiL+mj+geFUI+GG
         Hk1LCAEjbkC/nfTzukqSUwJi8KVJaiZtv/s9tMNYJP40WSwHIagojyMAGCRWtAnd9bRG
         1YEOAP2k0/cuYnELemvEd487jnjbStG7V4jdJ9fI/yMbTOjIXis19SRXKREzIhyA7b+G
         5z0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760048136; x=1760652936;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oll1MPE7hkNDT7M/Q1/FAEUqkNVEA+iYvJPlZMv+EKE=;
        b=EJ9GyKTl7qZLU/rqqx+tfsnnypD6sSstf/8BGVGu9r2KrWrARo3W09v3xrMwt8d92D
         tBTwjwIIuUvre6923nTbbu9c1uozgGN2LIUBiukV4wV8LxynO9ybMqYsEVG7GHYJO2p9
         Bh2CEIS17S2LkDCOxco22CfIyJhZZtxHFo7hW1vRTKKC0tf1zHcum3PnWwHOmBaYjXiW
         FrdnKiZHfev22RufsVD0AvG9Kvk+dilHvgmvjMgcP2ejDD2o/UcP1mDYgrKg6xEgAsq9
         jRheK7dRTr+v/o/tbdaf77vV19e+SjImvD8q4ZuAV+o68U0hiZba3mdg7vjDAOcxZ6CK
         eR8A==
X-Forwarded-Encrypted: i=1; AJvYcCXFJ3K4Cu71LMd0qpZpp7d4VZ9ECRXANnndYVGL/S0MFpdlvPLSwkgm+xswLsVbt505Fpk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPkdlh4ACIN3rVqybfWeyQi9R1A525Z6sd8VlRZWbx5uFrq7Zr
	oeAs9JVzk5XFOiJ/HydBgy8Du8Nox7OGElVGymFLSfQWxEHqlX3YHayaqDxIHiq6B2mHaZiCMaO
	OBRimWOtA5B+UCXK6jwumKxplvg==
X-Google-Smtp-Source: AGHT+IHgB0xcVfauc1u1HW+fOsPb84FTf4YqLuG37YUk27FkO9AUKT3em4wnlAFSqHZKd0l5szDhiTWCqndJLqsXJA==
X-Received: from pjad22.prod.google.com ([2002:a17:90a:1116:b0:33b:51fe:1a77])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:38ce:b0:32e:5646:d448 with SMTP id 98e67ed59e1d1-33b513b2ab9mr11170579a91.21.1760048135969;
 Thu, 09 Oct 2025 15:15:35 -0700 (PDT)
Date: Thu, 09 Oct 2025 15:15:34 -0700
In-Reply-To: <20251007221420.344669-6-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com> <20251007221420.344669-6-seanjc@google.com>
Message-ID: <diqzo6qfhgc9.fsf@google.com>
Subject: Re: [PATCH v12 05/12] KVM: guest_memfd: Enforce NUMA mempolicy using
 shared policy
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> From: Shivank Garg <shivankg@amd.com>
>
> Previously, guest-memfd allocations followed local NUMA node id in absence
> of process mempolicy, resulting in arbitrary memory allocation.
> Moreover, mbind() couldn't be used  by the VMM as guest memory wasn't
> mapped into userspace when allocation occurred.
>
> Enable NUMA policy support by implementing vm_ops for guest-memfd mmap
> operation. This allows the VMM to map the memory and use mbind() to set the
> desired NUMA policy. The policy is stored in the inode structure via
> kvm_gmem_inode_info, as memory policy is a property of the memory (struct
> inode) itself. The policy is then retrieved via mpol_shared_policy_lookup()
> and passed to filemap_grab_folio_mpol() to ensure that allocations follow
> the specified memory policy.
>
> This enables the VMM to control guest memory NUMA placement by calling
> mbind() on the mapped memory regions, providing fine-grained control over
> guest memory allocation across NUMA nodes.
>
> The policy change only affect future allocations and does not migrate
> existing memory. This matches mbind(2)'s default behavior which affects
> only new allocations unless overridden with MPOL_MF_MOVE/MPOL_MF_MOVE_ALL
> flags, which are not supported for guest_memfd as it is unmovable.
>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> Tested-by: Ashish Kalra <ashish.kalra@amd.com>
> [sean: document the ABI impact of the ->get_policy() hook]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/guest_memfd.c | 69 ++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 67 insertions(+), 2 deletions(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index cc3b25155726..95267c92983b 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -4,6 +4,7 @@
>  #include <linux/falloc.h>
>  #include <linux/fs.h>
>  #include <linux/kvm_host.h>
> +#include <linux/mempolicy.h>
>  #include <linux/pseudo_fs.h>
>  #include <linux/pagemap.h>
>  
> @@ -27,6 +28,7 @@ struct gmem_file {
>  };
>  
>  struct gmem_inode {
> +	struct shared_policy policy;
>  	struct inode vfs_inode;
>  };
>  
> @@ -112,6 +114,19 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	return r;
>  }
>  
> +static struct mempolicy *kvm_gmem_get_folio_policy(struct gmem_inode *gi,
> +						   pgoff_t index)

How about kvm_gmem_get_index_policy() instead, since the policy is keyed
by index?

> +{
> +#ifdef CONFIG_NUMA
> +	struct mempolicy *mpol;
> +
> +	mpol = mpol_shared_policy_lookup(&gi->policy, index);
> +	return mpol ? mpol : get_task_policy(current);

Should we be returning NULL if no shared policy was defined?

By returning NULL, __filemap_get_folio_mpol() can handle the case where
cpuset_do_page_mem_spread().

If we always return current's task policy, what if the user wants to use
cpuset_do_page_mem_spread()?

> +#else
> +	return NULL;

Returning current's task policy in the CONFIG_NUMA case seems to
conflict with returning NULL here.

> +#endif
> +}
> +
>  /*
>   * Returns a locked folio on success.  The caller is responsible for
>   * setting the up-to-date flag before the memory is mapped into the guest.
> @@ -124,7 +139,25 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>  static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>  {
>  	/* TODO: Support huge pages. */
> -	return filemap_grab_folio(inode->i_mapping, index);
> +	struct mempolicy *policy;
> +	struct folio *folio;
> +
> +	/*
> +	 * Fast-path: See if folio is already present in mapping to avoid
> +	 * policy_lookup.
> +	 */
> +	folio = __filemap_get_folio(inode->i_mapping, index,
> +				    FGP_LOCK | FGP_ACCESSED, 0);
> +	if (!IS_ERR(folio))
> +		return folio;
> +
> +	policy = kvm_gmem_get_folio_policy(GMEM_I(inode), index);

If we're going to return NULL if no shared policy is defined, then I
believe we can directly call mpol_shared_policy_lookup() here.

> +	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
> +					 FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
> +					 mapping_gfp_mask(inode->i_mapping), policy);
> +	mpol_cond_put(policy);
> +
> +	return folio;
>  }
>  
>  static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
> @@ -413,8 +446,38 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>  	return ret;
>  }
>  
> +#ifdef CONFIG_NUMA
> +static int kvm_gmem_set_policy(struct vm_area_struct *vma, struct mempolicy *mpol)
> +{
> +	struct inode *inode = file_inode(vma->vm_file);
> +
> +	return mpol_set_shared_policy(&GMEM_I(inode)->policy, vma, mpol);
> +}
> +
> +static struct mempolicy *kvm_gmem_get_policy(struct vm_area_struct *vma,
> +					     unsigned long addr, pgoff_t *pgoff)
> +{
> +	struct inode *inode = file_inode(vma->vm_file);
> +
> +	*pgoff = vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT);
> +
> +	/*
> +	 * Note!  Directly return whatever the lookup returns, do NOT return
> +	 * the current task's policy as is done when looking up the policy for
> +	 * a specific folio.  Kernel ABI for get_mempolicy() is to return
> +	 * MPOL_DEFAULT when there is no defined policy, not whatever the
> +	 * default policy resolves to.

To be more accurate, I think this sentence should be:

Kernel ABI for .get_policy is to return NULL if no policy is specified
at this index. The caller can then replace NULL with the default memory
policy instead of current's memory policy.

> +	 */
> +	return mpol_shared_policy_lookup(&GMEM_I(inode)->policy, *pgoff);
> +}
> +#endif /* CONFIG_NUMA */
> +
>  static const struct vm_operations_struct kvm_gmem_vm_ops = {
> -	.fault = kvm_gmem_fault_user_mapping,
> +	.fault		= kvm_gmem_fault_user_mapping,
> +#ifdef CONFIG_NUMA
> +	.get_policy	= kvm_gmem_get_policy,
> +	.set_policy	= kvm_gmem_set_policy,
> +#endif
>  };
>  
>  static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> @@ -867,11 +930,13 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
>  	if (!gi)
>  		return NULL;
>  
> +	mpol_shared_policy_init(&gi->policy, NULL);
>  	return &gi->vfs_inode;
>  }
>  
>  static void kvm_gmem_destroy_inode(struct inode *inode)
>  {
> +	mpol_free_shared_policy(&GMEM_I(inode)->policy);
>  }
>  
>  static void kvm_gmem_free_inode(struct inode *inode)
> -- 
> 2.51.0.710.ga91ca5db03-goog

