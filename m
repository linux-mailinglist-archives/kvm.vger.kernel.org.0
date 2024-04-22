Return-Path: <kvm+bounces-15517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A95148ACFE7
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 16:50:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 36AE61F22433
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 14:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2DEB152518;
	Mon, 22 Apr 2024 14:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DCA5iY34"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369B8152195;
	Mon, 22 Apr 2024 14:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713797388; cv=none; b=p3CsfTzFkfvqpiZuNkLBRrR1qqPKr7wjGy/KiwMvJaKDmwhzGhR8/vGiBQNqkCRGTS+2vUQ2CfuoQhKRVS1v0fjNYZ7fD8v10IbmcmyIW3p6DK42NAxKFTET/WydP6ZNFcKWIvOp53cLggn2gGV4ttKvhsN/+c7f2EO6GIvPI5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713797388; c=relaxed/simple;
	bh=hSW6/00CexkAj4yr/ss/j1zrPQ6JrexwJDPsR17Ywmc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hd6/mXnyNh4RH4Ql773mXSYWYFtonXKRX/eQTgHfQQDttAnS07gKny5N1HTeCasGmdM+QvX1cuV1Aj4AG1MfE42JbCfNSgtROaQBdhgh/HalXmmtrI2C4l3G3DBwyKaEnkBCsOG1Rc6ZYm9qPgaXXR4e9rwA4BuKZ2mk70SjqbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DCA5iY34; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713797387; x=1745333387;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hSW6/00CexkAj4yr/ss/j1zrPQ6JrexwJDPsR17Ywmc=;
  b=DCA5iY34ZxfJGABPA1vitXsleRT4kdVTa00CtKvrI8+0VRCzKpXylCPd
   IHh3BE0Hx7B8W0T5muQjNzTcwrS0fo0yzzge0kZWj4fFUjU068efeaLHh
   49JAjxmLJjgOukWA50TCfuawRMw8n2Kwz8ptjEBE4jO7KRUelnHMvNZ5s
   y2lzibYiSzqWLd1wNnHY8ZhmE6PjD9Y258I0G8zoWNZJvUn5orkeBB40p
   5NoWbF/0xryL2br5NvADj4DagH7dY3dfBAuEUFeBxg3qfRt4vbJXhHvYD
   Yz1CkKN/U6VDKpyOHEi2oyVFbnGGXQTconLjrLiwd29cF9MSEYbutNRKS
   Q==;
X-CSE-ConnectionGUID: NDamN9LWT3K4PM+mTX2VuA==
X-CSE-MsgGUID: dYszhE4iS8GB9LgFbBuBDw==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="20033641"
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="20033641"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 07:49:45 -0700
X-CSE-ConnectionGUID: Hz+KqllpRdmDG/nq7k5yuw==
X-CSE-MsgGUID: F/ISxkcXQFCr4hBb59nOEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="24067383"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa009.fm.intel.com with ESMTP; 22 Apr 2024 07:49:44 -0700
Date: Mon, 22 Apr 2024 22:44:24 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
	michael.roth@amd.com, isaku.yamahata@intel.com
Subject: Re: [PATCH 09/11] KVM: guest_memfd: Add interface for populating
 gmem pages with user data
Message-ID: <ZiZ3yDxEX+n6Za9b@yilunxu-OptiPlex-7050>
References: <20240404185034.3184582-1-pbonzini@redhat.com>
 <20240404185034.3184582-10-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240404185034.3184582-10-pbonzini@redhat.com>

On Thu, Apr 04, 2024 at 02:50:31PM -0400, Paolo Bonzini wrote:
> During guest run-time, kvm_arch_gmem_prepare() is issued as needed to
> prepare newly-allocated gmem pages prior to mapping them into the guest.
> In the case of SEV-SNP, this mainly involves setting the pages to
> private in the RMP table.
> 
> However, for the GPA ranges comprising the initial guest payload, which
> are encrypted/measured prior to starting the guest, the gmem pages need
> to be accessed prior to setting them to private in the RMP table so they
> can be initialized with the userspace-provided data. Additionally, an
> SNP firmware call is needed afterward to encrypt them in-place and
> measure the contents into the guest's launch digest.
> 
> While it is possible to bypass the kvm_arch_gmem_prepare() hooks so that
> this handling can be done in an open-coded/vendor-specific manner, this
> may expose more gmem-internal state/dependencies to external callers
> than necessary. Try to avoid this by implementing an interface that
> tries to handle as much of the common functionality inside gmem as
> possible, while also making it generic enough to potentially be
> usable/extensible for TDX as well.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Co-developed-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  include/linux/kvm_host.h | 26 ++++++++++++++
>  virt/kvm/guest_memfd.c   | 78 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 104 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 33ed3b884a6b..97d57ec59789 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2450,4 +2450,30 @@ int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_ord
>  bool kvm_arch_gmem_prepare_needed(struct kvm *kvm);
>  #endif
>  
> +/**
> + * kvm_gmem_populate() - Populate/prepare a GPA range with guest data
> + *
> + * @kvm: KVM instance
> + * @gfn: starting GFN to be populated
> + * @src: userspace-provided buffer containing data to copy into GFN range
> + *       (passed to @post_populate, and incremented on each iteration
> + *       if not NULL)
> + * @npages: number of pages to copy from userspace-buffer
> + * @post_populate: callback to issue for each gmem page that backs the GPA
> + *                 range
> + * @opaque: opaque data to pass to @post_populate callback
> + *
> + * This is primarily intended for cases where a gmem-backed GPA range needs
> + * to be initialized with userspace-provided data prior to being mapped into
> + * the guest as a private page. This should be called with the slots->lock
> + * held so that caller-enforced invariants regarding the expected memory
> + * attributes of the GPA range do not race with KVM_SET_MEMORY_ATTRIBUTES.
> + *
> + * Returns the number of pages that were populated.
> + */
> +long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
> +		       int (*post_populate)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> +					    void __user *src, int order, void *opaque),
> +		       void *opaque);
> +
>  #endif
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 51c99667690a..e7de97382a67 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -602,3 +602,81 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	return r;
>  }
>  EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
> +
> +static int kvm_gmem_undo_get_pfn(struct file *file, struct kvm_memory_slot *slot,
> +				 gfn_t gfn, int order)
> +{
> +	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
> +	struct kvm_gmem *gmem = file->private_data;
> +
> +	/*
> +	 * Races with kvm_gmem_unbind() must have been detected by
> +	 * __kvm_gmem_get_gfn(), because the invalidate_lock is
> +	 * taken between __kvm_gmem_get_gfn() and kvm_gmem_undo_get_pfn().
> +	 */
> +	if (WARN_ON_ONCE(xa_load(&gmem->bindings, index) != slot))
> +		return -EIO;
> +
> +	return __kvm_gmem_punch_hole(file_inode(file), index << PAGE_SHIFT, PAGE_SIZE << order);
> +}
> +
> +long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
> +		       int (*post_populate)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> +					    void __user *src, int order, void *opaque),
> +		       void *opaque)
> +{
> +	struct file *file;
> +	struct kvm_memory_slot *slot;
> +
> +	int ret = 0, max_order;
> +	long i;
> +
> +	lockdep_assert_held(&kvm->slots_lock);
> +	if (npages < 0)
> +		return -EINVAL;
> +
> +	slot = gfn_to_memslot(kvm, gfn);
> +	if (!kvm_slot_can_be_private(slot))
> +		return -EINVAL;
> +
> +	file = kvm_gmem_get_file(slot);
> +	if (!file)
> +		return -EFAULT;
> +
> +	filemap_invalidate_lock(file->f_mapping);
> +
> +	npages = min_t(ulong, slot->npages - (gfn - slot->base_gfn), npages);
> +	for (i = 0; i < npages; i += (1 << max_order)) {
> +		gfn_t this_gfn = gfn + i;
> +		kvm_pfn_t pfn;
> +
> +		ret = __kvm_gmem_get_pfn(file, slot, this_gfn, &pfn, &max_order, false);
> +		if (ret)
> +			break;
> +
> +		if (!IS_ALIGNED(this_gfn, (1 << max_order)) ||
> +		    (npages - i) < (1 << max_order))
> +			max_order = 0;
> +
> +		if (post_populate) {
> +			void __user *p = src ? src + i * PAGE_SIZE : NULL;
> +			ret = post_populate(kvm, this_gfn, pfn, p, max_order, opaque);

I don't see the main difference between gmem_prepare() and post_populate()
from gmem's point of view.  They are all vendor callbacks invoked after
__filemap_get_folio(). Is it possible gmem choose to call gmem_prepare()
or post_populate() outside __kvm_gmem_get_pfn()? Or even pass all
parameters to a single gmem_prepare() and let vendor code decide what to
do.

> +		}
> +
> +		put_page(pfn_to_page(pfn));
> +		if (ret) {
> +			/*
> +			 * Punch a hole so that FGP_CREAT_ONLY can succeed
> +			 * again.
> +			 */
> +			kvm_gmem_undo_get_pfn(file, slot, this_gfn, max_order);
> +			break;
> +		}
> +	}
> +
> +	filemap_invalidate_unlock(file->f_mapping);
> +
> +	fput(file);
> +	return ret && !i ? ret : i;
> +}
> +EXPORT_SYMBOL_GPL(kvm_gmem_populate);
> -- 
> 2.43.0
> 
> 
> 

