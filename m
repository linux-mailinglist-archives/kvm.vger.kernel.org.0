Return-Path: <kvm+bounces-13257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11816893809
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 07:06:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCD6D1F21431
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 05:06:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E77BE8F44;
	Mon,  1 Apr 2024 05:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S8claIly"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABC4320C
	for <kvm@vger.kernel.org>; Mon,  1 Apr 2024 05:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711947975; cv=none; b=HDmTwowBz69DNXWTXsCpnWHXranDUmk7lG11esg6cjjHBEhwhIpA+vX4/T1eahdWNL5HbTrXhXALZp4ZklDjo0GiQGn392gboWakTe8BLDEwVLvMgqy1KZrdWtbn2ETRLwEJun/KFWZU6ZT9hvJ/RDc05jpkilafMnaukuZ4MIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711947975; c=relaxed/simple;
	bh=lAnFIXPsMqEx1PIRHECT6EIpKl4ob5ivc4XO1J5She8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gpBtODzy9Hryop8wkq7niWNGQiH/5QAQ+I4Yc7mRaloUecTCBYqiqHhQsWg2QnbGzph93nfroZ3b0J0FZBBXm28AwnplJ1pXlFVftzmM8e1XQiEk+3jx+T5hiRYu2SK8q5NPZxiKySdA1BsvZJUpxb5kjScR0DhBY3o/Sm0M+Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S8claIly; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711947973; x=1743483973;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lAnFIXPsMqEx1PIRHECT6EIpKl4ob5ivc4XO1J5She8=;
  b=S8claIlyAW5d8hb9SnvIRPiFmlslUkyjUUzYHzud4KzMK/dQyQI0TnmV
   bnEt6mWSaS59A/xdqLfunqn6NjjC5Y/zRhN80V2EOcYF2U2Urv9CtP2Oy
   Sz4sZhKpn8pNfFqRcP3PXdn9+2PVaAkQ+jvI9BpXZF8lelgNzKq8GwMkZ
   q41LN78Xd6iuCKx4Hx+t2R/6/D9CT+qsQlk4fyZ6UtmM6zipx/lx+ErhU
   NVC+xHjSEkH0xIitnmno0dSLcXVWKeaF4PyJpfz4zbaKvrwIdHzq2SNoI
   duf1rRJpA8rY+mmlUMCZfPDHbKNDxZLyRf/gwOrjwyqHOzQLz9equaPv2
   Q==;
X-CSE-ConnectionGUID: 09/tEOl3R42Dg0hZaGXA/w==
X-CSE-MsgGUID: 4O0XBqZXQ7G1TCw2RJRgtQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11030"; a="17686543"
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="17686543"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2024 22:06:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="48586391"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.225]) ([10.238.10.225])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2024 22:06:10 -0700
Message-ID: <297fd9b8-9321-40e3-816b-2de92cb1a3ae@linux.intel.com>
Date: Mon, 1 Apr 2024 13:06:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH gmem 2/6] KVM: guest_memfd: Only call
 kvm_arch_gmem_prepare hook if necessary
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>,
 Isaku Yamahata <isaku.yamahata@linux.intel.com>,
 Xu Yilun <yilun.xu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>
References: <20240329212444.395559-1-michael.roth@amd.com>
 <20240329212444.395559-3-michael.roth@amd.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240329212444.395559-3-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/30/2024 5:24 AM, Michael Roth wrote:
> It has been reported that the internal workings of
> kvm_gmem_prepare_folio() incurs noticeable overhead for large guests
> even for platforms where kvm_arch_gmem_prepare() is a no-op.
>
> Provide a new kvm_arch_gmem_prepare_needed() hook so that architectures
> that set CONFIG_HAVE_KVM_GMEM_PREPARE can still opt-out of issuing the
> kvm_arch_gmem_prepare() callback

Just wondering which part has big impact on performance,
the issue of kvm_arch_gmem_prepare() callback or the preparation code for
the kvm_arch_gmem_prepare()?


> if the particular KVM instance doesn't
> require any sort of special preparation of its gmem pages prior to use.
>
> Link: https://lore.kernel.org/lkml/20240228202906.GB10568@ls.amr.corp.intel.com/
> Suggested-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   include/linux/kvm_host.h |  1 +
>   virt/kvm/guest_memfd.c   | 10 ++++++++++
>   2 files changed, 11 insertions(+)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 2f5074eff958..5b8308b5e4af 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2466,6 +2466,7 @@ static inline int kvm_gmem_undo_get_pfn(struct kvm *kvm,
>   
>   #ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
>   int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order);
> +bool kvm_arch_gmem_prepare_needed(struct kvm *kvm);
>   #endif
>   
>   #ifdef CONFIG_HAVE_KVM_GMEM_INVALIDATE
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 74e19170af8a..4ce0056d1149 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -13,6 +13,13 @@ struct kvm_gmem {
>   	struct list_head entry;
>   };
>   
> +#ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
> +bool __weak kvm_arch_gmem_prepare_needed(struct kvm *kvm)
> +{
> +	return false;
> +}
> +#endif
> +
>   static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct folio *folio)
>   {
>   #ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
> @@ -27,6 +34,9 @@ static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct fol
>   		gfn_t gfn;
>   		int rc;
>   
> +		if (!kvm_arch_gmem_prepare_needed(kvm))
> +			continue;

Can multiple gmems (if any) bound to the same inode's address space 
belong to different kvm instances?
If not, just return here?

> +
>   		slot = xa_load(&gmem->bindings, index);
>   		if (!slot)
>   			continue;


