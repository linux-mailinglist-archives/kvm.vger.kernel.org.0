Return-Path: <kvm+bounces-37950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 92B47A31DBF
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 06:08:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33C193A7419
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 05:07:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45C7B1E7C0E;
	Wed, 12 Feb 2025 05:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I5QyH4xW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9BA3594F
	for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 05:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739336876; cv=none; b=LW4jKuGRGSoU3hjoV4Otr2qwRUytHwLwXZgzXbqRFWgQW7aqmV+Mr0Ka3T9cq87pVn+bmzn5tWvfgiogkGuXbrgArSWfsTA+dQosX/TnL42ZkrmURU9RjZ1pJ3LF72qK5fgknSo9cAXbufEutiHxI+lwcEY4nMZyzw1rSAGmg9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739336876; c=relaxed/simple;
	bh=p4LKk4ZdoFiJUlp2//n7xvv88iRTuP8XnvJuId+5tgA=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=OGMYPesazVWukOv7Sr1xv+z9K1SJsD7adjmYS2Njf9ArZZ6wlmPy0wIh/j6CYvV451rmggltiNoudR2Xjw6ywWb8SYKrtQQ35hTm/0aNeO7fHnS42ioXpG1paGh0iuRac2yHktMp3V9qw0aoyHkZK4Ygu4ld2sXelGb8alfUlMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I5QyH4xW; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fa1c093f12so16635032a91.2
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 21:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739336874; x=1739941674; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zOJxpI1x9MLAiq9h9+DTjl81Sa/nSgc2QKSMD+NAq0c=;
        b=I5QyH4xWlER47LM8sfV4SYpnl/mil0VVF0XPVllwfIvCdzchr545Vdeb06b4eI6z27
         6ozROaM+XEjzerDLUu2WVlTMjl07tY8nHI+ABPBSFmB9NmGspY6+ys3Cv9t/XL7S/sKQ
         A7P8UI/No3Hjgha9xQL7TgxcnN4hdwwysJgA3qDaqUA3DZgkNudSD6JR0KfazzFhO07L
         o6fX4naLLxYbWPc+NCynLw5XeHp6zFQZUxhdYFFMPFUzYn4oG1hHogcZn+FB3meJE6t9
         iL2Dca7ZJH8PUv61ZMXEprNV68IjJwmufODqRhb9GuzOs3Qu/pfDJ04pObwABClKAiPE
         HYHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739336874; x=1739941674;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zOJxpI1x9MLAiq9h9+DTjl81Sa/nSgc2QKSMD+NAq0c=;
        b=UXFDGWEEZ6OIiBCJpXbAiw8DSbAFjZYRqR969iPC5FNFWT9oXZcysnd3NY97+T4EvF
         RNdWyRYAXd1R85cE8bC9qCQ1sHOz3fnNT3Gu3zunm5ieMBRUAG3mHY7l2XuC0erykCDc
         DilXq8KU24hnFGKgWKK+HrzgjiVZnPN6u6RPcOPK3WHh17mcwfG4Xi8IIlm4RCkS9+Lt
         ikotvoYoCIibulP6Rpmg2o/4QAxvKgBcvfIOEDHXUTOsWHIuqvoBfmxf/AEEA9aotgUO
         nEt6xL0Lvy/DMYpcaQOsoxdY8rPJ2mS5n65HfVCBdZESlKNHqSsX3kE4HY8AaAWKYcbL
         zFkg==
X-Gm-Message-State: AOJu0YyzuLj8GHsfP5Nhmtp7iZbEB3wvsbYHMBQLoVLFbcb1vpCentPW
	+wwJD6+Y24XTEsL6+OA8Ma4UMo9KQYA/I/ZP2uNZqbByK3pR1So04gOGDdEcGYI8qWY6tB8exsK
	BYlkx2s2R31WEo4USxbxCxQ==
X-Google-Smtp-Source: AGHT+IH/xh6quStbzptBl/mL0TU0XPEI8Jdwu7q7FhIn9TFDXRLhgpliEbXcKvvkSkGPR9+aPEy3XINR4VxNZv86ug==
X-Received: from pjbsv3.prod.google.com ([2002:a17:90b:5383:b0:2ef:71b9:f22f])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2c8e:b0:2ea:712d:9a82 with SMTP id 98e67ed59e1d1-2fbf5c71357mr2767999a91.29.1739336874097;
 Tue, 11 Feb 2025 21:07:54 -0800 (PST)
Date: Wed, 12 Feb 2025 05:07:52 +0000
In-Reply-To: <20250211121128.703390-4-tabba@google.com> (message from Fuad
 Tabba on Tue, 11 Feb 2025 12:11:19 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzed0392dz.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v3 03/11] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fuad Tabba <tabba@google.com> writes:

> Add support for mmap() and fault() for guest_memfd backed memory
> in the host for VMs that support in-place conversion between
> shared and private (shared memory). To that end, this patch adds
> the ability to check whether the VM type has that support, and
> only allows mapping its memory if that's the case.
>
> Additionally, this behavior is gated with a new configuration
> option, CONFIG_KVM_GMEM_SHARED_MEM.
>
> Signed-off-by: Fuad Tabba <tabba@google.com>
>
> ---
>
> This patch series will allow shared memory support for software
> VMs in x86. It will also introduce a similar VM type for arm64
> and allow shared memory support for that. In the future, pKVM
> will also support shared memory.

Thanks, I agree that introducing mmap this way could help in having it
merged earlier, independently of conversion support, to support testing.

I'll adopt this patch in the next revision of 1G page support for
guest_memfd.

> ---
>  include/linux/kvm_host.h | 11 +++++
>  virt/kvm/Kconfig         |  4 ++
>  virt/kvm/guest_memfd.c   | 93 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 108 insertions(+)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 8b5f28f6efff..438aa3df3175 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -728,6 +728,17 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>  }
>  #endif
>  
> +/*
> + * Arch code must define kvm_arch_gmem_supports_shared_mem if support for
> + * private memory is enabled and it supports in-place shared/private conversion.
> + */
> +#if !defined(kvm_arch_gmem_supports_shared_mem) && !IS_ENABLED(CONFIG_KVM_PRIVATE_MEM)
> +static inline bool kvm_arch_gmem_supports_shared_mem(struct kvm *kvm)
> +{
> +	return false;
> +}
> +#endif

Perhaps this could be declared in the #ifdef CONFIG_KVM_PRIVATE_MEM
block?

Could this be defined as a __weak symbol for architectures to override?
Or perhaps that can be done once guest_memfd gets refactored separately
since now the entire guest_memfd.c isn't even compiled if
CONFIG_KVM_PRIVATE_MEM is not set.

> +
>  #ifndef kvm_arch_has_readonly_mem
>  static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
>  {
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 54e959e7d68f..4e759e8020c5 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -124,3 +124,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
>  config HAVE_KVM_ARCH_GMEM_INVALIDATE
>         bool
>         depends on KVM_PRIVATE_MEM
> +
> +config KVM_GMEM_SHARED_MEM
> +       select KVM_PRIVATE_MEM
> +       bool
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index c6f6792bec2a..85467a3ef8ea 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -317,9 +317,102 @@ void kvm_gmem_handle_folio_put(struct folio *folio)
>  {
>  	WARN_ONCE(1, "A placeholder that shouldn't trigger. Work in progress.");
>  }
> +
> +static bool kvm_gmem_offset_is_shared(struct file *file, pgoff_t index)
> +{
> +	struct kvm_gmem *gmem = file->private_data;
> +
> +	/* For now, VMs that support shared memory share all their memory. */
> +	return kvm_arch_gmem_supports_shared_mem(gmem->kvm);
> +}
> +
> +static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
> +{
> +	struct inode *inode = file_inode(vmf->vma->vm_file);
> +	struct folio *folio;
> +	vm_fault_t ret = VM_FAULT_LOCKED;
> +
> +	filemap_invalidate_lock_shared(inode->i_mapping);
> +
> +	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> +	if (IS_ERR(folio)) {
> +		ret = VM_FAULT_SIGBUS;

Will it always be a SIGBUS if there is some error getting a folio?

> +		goto out_filemap;
> +	}
> +
> +	if (folio_test_hwpoison(folio)) {
> +		ret = VM_FAULT_HWPOISON;
> +		goto out_folio;
> +	}
> +
> +	/* Must be called with folio lock held, i.e., after kvm_gmem_get_folio() */
> +	if (!kvm_gmem_offset_is_shared(vmf->vma->vm_file, vmf->pgoff)) {
> +		ret = VM_FAULT_SIGBUS;
> +		goto out_folio;
> +	}
> +
> +	/*
> +	 * Only private folios are marked as "guestmem" so far, and we never
> +	 * expect private folios at this point.
> +	 */

Proposal - rephrase this comment as: before typed folios can be mapped,
PGTY_guestmem is only tagged on folios so that guest_memfd will receive
the kvm_gmem_handle_folio_put() callback. The tag is definitely not
expected when a folio is about to be faulted in.

I propose the above because I think technically when mappability is NONE
the folio isn't private? Not sure if others see this differently.

> +	if (WARN_ON_ONCE(folio_test_guestmem(folio)))  {
> +		ret = VM_FAULT_SIGBUS;
> +		goto out_folio;
> +	}
> +
> +	/* No support for huge pages. */
> +	if (WARN_ON_ONCE(folio_test_large(folio))) {
> +		ret = VM_FAULT_SIGBUS;
> +		goto out_folio;
> +	}
> +
> +	if (!folio_test_uptodate(folio)) {
> +		clear_highpage(folio_page(folio, 0));
> +		kvm_gmem_mark_prepared(folio);
> +	}
> +
> +	vmf->page = folio_file_page(folio, vmf->pgoff);
> +
> +out_folio:
> +	if (ret != VM_FAULT_LOCKED) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}
> +
> +out_filemap:
> +	filemap_invalidate_unlock_shared(inode->i_mapping);
> +
> +	return ret;
> +}
> +
> +static const struct vm_operations_struct kvm_gmem_vm_ops = {
> +	.fault = kvm_gmem_fault,
> +};
> +
> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct kvm_gmem *gmem = file->private_data;
> +
> +	if (!kvm_arch_gmem_supports_shared_mem(gmem->kvm))
> +		return -ENODEV;
> +
> +	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
> +	    (VM_SHARED | VM_MAYSHARE)) {
> +		return -EINVAL;
> +	}
> +
> +	file_accessed(file);
> +	vm_flags_set(vma, VM_DONTDUMP);
> +	vma->vm_ops = &kvm_gmem_vm_ops;
> +
> +	return 0;
> +}
> +#else
> +#define kvm_gmem_mmap NULL
>  #endif /* CONFIG_KVM_GMEM_SHARED_MEM */
>  
>  static struct file_operations kvm_gmem_fops = {
> +	.mmap		= kvm_gmem_mmap,

I think it's better to surround this with #ifdef
CONFIG_KVM_GMEM_SHARED_MEM so that when more code gets inserted between
the struct declaration and the definition of kvm_gmem_mmap() it is more
obvious that .mmap is only overridden when CONFIG_KVM_GMEM_SHARED_MEM is
set.

>  	.open		= generic_file_open,
>  	.release	= kvm_gmem_release,
>  	.fallocate	= kvm_gmem_fallocate,

