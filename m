Return-Path: <kvm+bounces-10747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 326DB86F953
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 05:48:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E1991C20C5A
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 04:48:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E988F6FAD;
	Mon,  4 Mar 2024 04:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SjEHjVn2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4B217F3;
	Mon,  4 Mar 2024 04:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709527702; cv=none; b=Pm4UGQ/E1OWsR48JLHMIbxtp72xKHdA/FiQ86BSU01wPUKkFHPzz1wHb12kGHvY1FvqbmHjNopDSilXY3bivGwvsWeGXynvJS9x2VR96ox0b6CVgWHO7xiQP+ROSaON0aMDB0wRdnizL/ZLfkQd/wuOMK0D36AOraWkJBBDYBO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709527702; c=relaxed/simple;
	bh=TkObtEKI/tyB4jiEf0y2L56Ri8j/zice+wU0hAX+lVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qKcBC14olPhoMAUQe6IQjetwkpe4sSvvRNM8K7wP3GFEK1KXI0QbJ2n0YTeOv5TFJ3t70xIuh+wmtp+MZFyJw7B5UjFYuaf6FwQSG4wl6SG9k9LXmICubVr+EMLhxoeOjxg+od+sxQ80VeMsH3AAvWBmKydNPsyJ8NCdrzabmpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SjEHjVn2; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709527700; x=1741063700;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TkObtEKI/tyB4jiEf0y2L56Ri8j/zice+wU0hAX+lVw=;
  b=SjEHjVn2ijKtG4M4D3kYqrCBffIo3nkXjPa2v8TFhOxNroBRb3RdgQ/N
   SC3JbfxfTFVxHYkvpg80D6zHmlB6WnXkCNVgF9bViLHFm8MhYJg4tFBQ1
   v1NhxChpRbbHiTAkpab2Xu2Mi7dN/WAIzH/sEFyieU6+Ao6wEEpFCXre3
   QKQgxVPBP0UvweirX3CrZ+FTG8AWwJlndtYrD6cK5dGcloxfflhZK5fFT
   uRk11sgGIR3SDAw12utAxJ3mDFJ+vn/WodV2s3ucgfDL4FsHnlPGSdTkI
   Tm5Vo84bdYOcKbem65+d8/060Qbw8XJDrwqUS+8tiKpoGZ5chfh0evZ70
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11002"; a="4167322"
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="4167322"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2024 20:48:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="13437328"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa003.fm.intel.com with ESMTP; 03 Mar 2024 20:48:18 -0800
Date: Mon, 4 Mar 2024 12:44:07 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
	michael.roth@amd.com, isaku.yamahata@intel.com,
	thomas.lendacky@amd.com
Subject: Re: [PATCH 19/21] KVM: guest_memfd: add API to undo
 kvm_gmem_get_uninit_pfn
Message-ID: <ZeVRlzYC7huTFddO@yilunxu-OptiPlex-7050>
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-20-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227232100.478238-20-pbonzini@redhat.com>

On Tue, Feb 27, 2024 at 06:20:58PM -0500, Paolo Bonzini wrote:
> In order to be able to redo kvm_gmem_get_uninit_pfn, a hole must be punched
> into the filemap, thus allowing FGP_CREAT_ONLY to succeed again.  This will
> be used whenever an operation that follows kvm_gmem_get_uninit_pfn fails.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  include/linux/kvm_host.h |  7 +++++++
>  virt/kvm/guest_memfd.c   | 28 ++++++++++++++++++++++++++++
>  2 files changed, 35 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 03bf616b7308..192c58116220 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2436,6 +2436,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
>  int kvm_gmem_get_uninit_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  		            gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
> +int kvm_gmem_undo_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> +			  gfn_t gfn, int order);
>  #else
>  static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>  				   struct kvm_memory_slot *slot, gfn_t gfn,
> @@ -2452,6 +2454,11 @@ static inline int kvm_gmem_get_uninit_pfn(struct kvm *kvm,
>  	KVM_BUG_ON(1, kvm);
>  	return -EIO;
>  }
> +
> +static inline int kvm_gmem_undo_get_pfn(struct kvm *kvm,
> +				        struct kvm_memory_slot *slot, gfn_t gfn,
> +				        int order)
> +{}

return -EIO;

or compiler would complain that no return value.

>  #endif /* CONFIG_KVM_PRIVATE_MEM */
>  
>  #ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 7ec7afafc960..535ef1aa34fb 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -590,3 +590,31 @@ int kvm_gmem_get_uninit_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	return __kvm_gmem_get_pfn(kvm, slot, gfn, pfn, max_order, false);
>  }
>  EXPORT_SYMBOL_GPL(kvm_gmem_get_uninit_pfn);
> +
> +int kvm_gmem_undo_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> +		          gfn_t gfn, int order)

Didn't see the caller yet, but do we need to ensure the gfn is aligned
with page order? e.g.

	WARN_ON(gfn & ((1UL << order) - 1));

> +{
> +	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
> +	struct kvm_gmem *gmem;
> +	struct file *file;
> +	int r;
> +
> +	file = kvm_gmem_get_file(slot);
> +	if (!file)
> +		return -EFAULT;
> +
> +	gmem = file->private_data;
> +
> +	if (WARN_ON_ONCE(xa_load(&gmem->bindings, index) != slot)) {
> +		r = -EIO;
> +		goto out_fput;
> +	}
> +
> +	r = kvm_gmem_punch_hole(file_inode(file), index << PAGE_SHIFT, PAGE_SHIFT << order);
                                                                       ^
PAGE_SIZE << order

Thanks,
Yilun

> +
> +out_fput:
> +	fput(file);
> +
> +	return r;
> +}
> +EXPORT_SYMBOL_GPL(kvm_gmem_undo_get_pfn);
> -- 
> 2.39.0
> 
> 
> 

