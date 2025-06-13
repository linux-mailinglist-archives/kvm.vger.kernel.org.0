Return-Path: <kvm+bounces-49528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 079D3AD96D3
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 23:03:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F8431BC21EF
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 21:03:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 828CD25F796;
	Fri, 13 Jun 2025 21:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ehvl6d5W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A53525B676
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 21:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749848595; cv=none; b=vBI5rbwXf24389S7cZgmqVANgsnbwMNP+dQstPzEaoRfUB6Vk/I5ge8G0pS0IdIf4hBbh6Qx9Ri37oXRUGJp/6x0PgufrA6y0t7Va3vbNZfK/8exBvEIGZaBcAFfUDjtO9raRLjHN8fmG8YPfghbqqIJLIUv4XflLSEMClQL8iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749848595; c=relaxed/simple;
	bh=lT7Zcp8p6wA3KAogKquAqZSGA7HSCm6dNohixcuq6/I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S0gzgpunWN63cPBggPl2VyaVzXbra7XvIigaj4KWMHfp6dlh8E7CTpMHjyRctns2+HbLBkRRuwX0rGfwEHzZXHQKUBnoE2ckJDwPJXt9Ik18qQif4Bxh15J/xZ98Y5Y7ImF8dRl29zLhegsbfiHj9mmUgp6YDStseSMcigf47L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ehvl6d5W; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b1fa2cad5c9so1662537a12.2
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 14:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749848593; x=1750453393; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A3Wch+x3uNF1XdTWEOPRulvN+JzipLoRE2aMsLqF+rU=;
        b=ehvl6d5W2/oZIW6V/ezMJYg81ZPJt/W8lYcv8GHnzutzT1Ee4H0zu6udFrZxbALpiW
         PhbpCX/dl28T9GtymTuA687Yl3uNJZOtZk2/c5tbP9beV2jz3hafZpFjCOyUl3WBBW7x
         K54qFPET3gwVyzWHemYrwxWP/ecE04x34QJ0dMeIs3xl2USxqjJsS46MSz+Crs0EWN2G
         Olq1HfBpsSMS8Vate17vA07Vm6ZJTWNkiHgcdF0za4Zc6boCIpMxaT866orj9X18deUQ
         xElrr5AOsF+2OIMK2EamiBqV3M/iIDdG99XqbJr2U+510RDdCwUc6EPWWB4DMgdgQpDX
         HPnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749848593; x=1750453393;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A3Wch+x3uNF1XdTWEOPRulvN+JzipLoRE2aMsLqF+rU=;
        b=EDGLTxMe0a7GVo+x1nqQnGxfi6E48+w31VPBUGTfGdrEOikZY2c5H7Kif/+gCy3e5m
         b3I8EloFL3DeNBGj+hZZHgV5Aivur4PIi/qQev/uRQZQPdU/sYWtY4pomEZ0iTuT76cA
         JPWGK6SFmVoavW7E3EtZtNYyZdOzskxBS+gXQj8woqr4NTkWkR2SB6ktp8p10wIM/Obw
         7IK6vahQQwU9fXZFwPPiGWN1CRiWe3eMcQI135RCAYlSKx2ynfYAhWEpeuPVZ+eoqdh+
         dsf545DqbebQ+IUy7EWCYcFRs+VoNf/lwnbfEsRuiP23KPXFzkevQ/QEZCw0t5CLEXnu
         CQng==
X-Gm-Message-State: AOJu0Yxp6DISkFIuNb9vYA7I60RZjn94Y7akwotrWF/on6QFRBCXh49D
	NL+nZdCIEQKHlK4qzGWBz72lIByM2VZ7ePeDF6cVziBqk2XiMCwvohrOXqqkD/hxFqtG1+kO/tv
	fr1+eLg==
X-Google-Smtp-Source: AGHT+IFCqUrg4V9bdDrybRc7q8t0EQEaXYwnc3flICr7EMgc9UCftl1VaSgXOwrdPngPPXCTz+jIrKW0iLY=
X-Received: from pfbch3.prod.google.com ([2002:a05:6a00:2883:b0:746:22b3:4c0d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3a48:b0:1f3:2e85:c052
 with SMTP id adf61e73a8af0-21fbd634e55mr1185002637.35.1749848592921; Fri, 13
 Jun 2025 14:03:12 -0700 (PDT)
Date: Fri, 13 Jun 2025 14:03:11 -0700
In-Reply-To: <20250611133330.1514028-9-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <20250611133330.1514028-9-tabba@google.com>
Message-ID: <aEySD5XoxKbkcuEZ@google.com>
Subject: Re: [PATCH v12 08/18] KVM: guest_memfd: Allow host to map guest_memfd pages
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
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
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 11, 2025, Fuad Tabba wrote:
> This patch enables support for shared memory in guest_memfd, including

Please don't lead with with "This patch", simply state what changes are being
made as a command.

> mapping that memory from host userspace.

> This functionality is gated by the KVM_GMEM_SHARED_MEM Kconfig option,
> and enabled for a given instance by the GUEST_MEMFD_FLAG_SUPPORT_SHARED
> flag at creation time.

Why?  I can see that from the patch.

This changelog is way, way, waaay too light on details.  Sorry for jumping in at
the 11th hour, but we've spent what, 2 years working on this? 

> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index d00b85cb168c..cb19150fd595 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1570,6 +1570,7 @@ struct kvm_memory_attributes {
>  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
>  
>  #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
> +#define GUEST_MEMFD_FLAG_SUPPORT_SHARED	(1ULL << 0)

I find the SUPPORT_SHARED terminology to be super confusing.  I had to dig quite
deep to undesrtand that "support shared" actually mean "userspace explicitly
enable sharing on _this_ guest_memfd instance".  E.g. I was surprised to see

IMO, GUEST_MEMFD_FLAG_SHAREABLE would be more appropriate.  But even that is
weird to me.  For non-CoCo VMs, there is no concept of shared vs. private.  What's
novel and notable is that the memory is _mappable_.  Yeah, yeah, pKVM's use case
is to share memory, but that's a _use case_, not the property of guest_memfd that
is being controlled by userspace.

And kvm_gmem_memslot_supports_shared() is even worse.  It's simply that the
memslot is bound to a mappable guest_memfd instance, it's that the guest_memfd
instance is the _only_ entry point to the memslot.

So my vote would be "GUEST_MEMFD_FLAG_MAPPABLE", and then something like
KVM_MEMSLOT_GUEST_MEMFD_ONLY.  That will make code like this:

	if (kvm_slot_has_gmem(slot) &&
	    (kvm_gmem_memslot_supports_shared(slot) ||
	     kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
		return kvm_gmem_max_mapping_level(slot, gfn, max_level);
	}

much more intutive:

	if (kvm_is_memslot_gmem_only(slot) ||
	    kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE))
		return kvm_gmem_max_mapping_level(slot, gfn, max_level);

And then have kvm_gmem_mapping_order() do:

	WARN_ON_ONCE(!kvm_slot_has_gmem(slot));
	return 0;

>  struct kvm_create_guest_memfd {
>  	__u64 size;
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 559c93ad90be..e90884f74404 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -128,3 +128,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
>  config HAVE_KVM_ARCH_GMEM_INVALIDATE
>         bool
>         depends on KVM_GMEM
> +
> +config KVM_GMEM_SHARED_MEM
> +       select KVM_GMEM
> +       bool
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 6db515833f61..06616b6b493b 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -312,7 +312,77 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>  	return gfn - slot->base_gfn + slot->gmem.pgoff;
>  }
>  
> +static bool kvm_gmem_supports_shared(struct inode *inode)
> +{
> +	const u64 flags = (u64)inode->i_private;
> +
> +	if (!IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
> +		return false;
> +
> +	return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> +}
> +
> +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)

And to my point about "shared", this is also very confusing, because there are
zero checks in here about shared vs. private.

> +{
> +	struct inode *inode = file_inode(vmf->vma->vm_file);
> +	struct folio *folio;
> +	vm_fault_t ret = VM_FAULT_LOCKED;
> +
> +	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
> +		return VM_FAULT_SIGBUS;
> +
> +	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> +	if (IS_ERR(folio)) {
> +		int err = PTR_ERR(folio);
> +
> +		if (err == -EAGAIN)
> +			return VM_FAULT_RETRY;
> +
> +		return vmf_error(err);
> +	}
> +
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
> +	return ret;
> +}
> +
> +static const struct vm_operations_struct kvm_gmem_vm_ops = {
> +	.fault = kvm_gmem_fault_shared,
> +};
> +
> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	if (!kvm_gmem_supports_shared(file_inode(file)))
> +		return -ENODEV;
> +
> +	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
> +	    (VM_SHARED | VM_MAYSHARE)) {

And the SHARED terminology gets really confusing here, due to colliding with the
existing notion of SHARED file mappings.

> +		return -EINVAL;
> +	}
> +
> +	vma->vm_ops = &kvm_gmem_vm_ops;
> +
> +	return 0;
> +}
> +
>  static struct file_operations kvm_gmem_fops = {
> +	.mmap		= kvm_gmem_mmap,
>  	.open		= generic_file_open,
>  	.release	= kvm_gmem_release,
>  	.fallocate	= kvm_gmem_fallocate,
> @@ -463,6 +533,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>  	u64 flags = args->flags;
>  	u64 valid_flags = 0;
>  
> +	if (kvm_arch_supports_gmem_shared_mem(kvm))
> +		valid_flags |= GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> +
>  	if (flags & ~valid_flags)
>  		return -EINVAL;
>  
> -- 
> 2.50.0.rc0.642.g800a2b2222-goog
> 

