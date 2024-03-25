Return-Path: <kvm+bounces-12583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 94B7C88A3D4
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 15:13:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 09BE71F39F23
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 14:13:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BC34170A56;
	Mon, 25 Mar 2024 10:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eOdHQFDX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498B018E0E4;
	Mon, 25 Mar 2024 09:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711360736; cv=none; b=psLAYzFt3wkJr9IfXigVM1P5tPYXmmtpA9R4oxNx/7+gqQBBAt4r3s/J7aPmyxmiA8DNeW+w71KdgMG1+2W6XSEGC5iOmAET8iQ6BTxYOlIq1/VwY7zc24MDyseDizLInUNKMKYYiiGkO8eAPJWBnAilih6UojV06o4ABx5Pxb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711360736; c=relaxed/simple;
	bh=ugri9IdhvbgQiiHtwIt5j6DpjMT2Yzmc1v7CVG2wUZ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f6dtJp4sHKO51rIZxp+BS+93YFM/VUQ8sxvzF0ykxh7JkGbEYul2mPXlh/dyD1+kJzgYQu9e6dAlbZtO+ziqn7HIiZtDG6DlOB3m8iGmfPJCtI4R5GijKD2JmLYWZjG4+SVnK1MQgu5MTXWVG+ReU0UkjjgN+6H+HNNNlaMi8PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eOdHQFDX; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711360734; x=1742896734;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ugri9IdhvbgQiiHtwIt5j6DpjMT2Yzmc1v7CVG2wUZ4=;
  b=eOdHQFDXog4groP9nRZdrc8aNErbnvUgXYXySMs4X/MPK/zcjL5mNWvJ
   MM9jFWSQJt4xl0B+dOUcQuE3mVIYLo6RxoAJqEg29QhRQ46Wfyd04wzCt
   zjQP78GDFbmkD69Bsm3gfGIiysptVItdkf1nIXuAnB4OmTi2QP6ZiEW0b
   Q9OB5jtTPVbNcgpS2+zCx1VE53DN6GBo+ssgIRmFiYlrm6LZ0qhj3gwdR
   8bsp8fknD2x92OOdOYMte0i6WiRP5ZOKOU88uks0lad6afeEMjWO7qocj
   BZDgC29ABv9E8vamfnUMA9nvRo5ZyT7+MpE1+VhhCXVji0ebCm5WCskou
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11023"; a="17495130"
X-IronPort-AV: E=Sophos;i="6.07,152,1708416000"; 
   d="scan'208";a="17495130"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 02:58:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,152,1708416000"; 
   d="scan'208";a="15969992"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.0.234]) ([10.238.0.234])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 02:58:50 -0700
Message-ID: <ba217de2-cdcb-4f50-80cc-c61a0e8255b2@linux.intel.com>
Date: Mon, 25 Mar 2024 17:58:47 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> As the first step to create TDX guest, create/destroy VM struct.  Assign
> TDX private Host Key ID (HKID) to the TDX guest for memory encryption and
> allocate extra pages for the TDX guest. On destruction, free allocated
> pages, and HKID.
>
> Before tearing down private page tables, TDX requires some resources of the
> guest TD to be destroyed (i.e. HKID must have been reclaimed, etc).  Add
> mmu notifier release callback

It seems not accurate to say "Add mmu notifier release callback", since the
interface has already been there. This patch extends the cache flush 
function,
i.e, kvm_flush_shadow_all() to do TDX specific thing.

> before tearing down private page tables for
> it.
>
> Add vm_free() of kvm_x86_ops hook at the end of kvm_arch_destroy_vm()
> because some per-VM TDX resources, e.g. TDR, need to be freed after other
> TDX resources, e.g. HKID, were freed.
>
> Co-developed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>
> ---
> v19:
> - fix check error code of TDH.PHYMEM.PAGE.RECLAIM. RCX and TDR.
>
> v18:
> - Use TDH.SYS.RD() instead of struct tdsysinfo_struct.
> - Rename tdx_reclaim_td_page() to tdx_reclaim_control_page()
> - return -EAGAIN on TDX_RND_NO_ENTROPY of TDH.MNG.CREATE(), TDH.MNG.ADDCX()
> - fix comment to remove extra the.
> - use true instead of 1 for boolean.
> - remove an extra white line.
>
> v16:
> - Simplified tdx_reclaim_page()
> - Reorganize the locking of tdx_release_hkid(), and use smp_call_mask()
>    instead of smp_call_on_cpu() to hold spinlock to race with invalidation
>    on releasing guest memfd
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/kvm-x86-ops.h |   2 +
>   arch/x86/include/asm/kvm_host.h    |   2 +
>   arch/x86/kvm/Kconfig               |   3 +-
>   arch/x86/kvm/mmu/mmu.c             |   7 +
>   arch/x86/kvm/vmx/main.c            |  26 +-
>   arch/x86/kvm/vmx/tdx.c             | 475 ++++++++++++++++++++++++++++-
>   arch/x86/kvm/vmx/tdx.h             |   6 +-
>   arch/x86/kvm/vmx/x86_ops.h         |   6 +
>   arch/x86/kvm/x86.c                 |   1 +
>   9 files changed, 520 insertions(+), 8 deletions(-)
>
[...]
> +
> +static void tdx_clear_page(unsigned long page_pa)
> +{
> +	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> +	void *page = __va(page_pa);
> +	unsigned long i;
> +
> +	/*
> +	 * When re-assign one page from old keyid to a new keyid, MOVDIR64B is
> +	 * required to clear/write the page with new keyid to prevent integrity
> +	 * error when read on the page with new keyid.
> +	 *
> +	 * clflush doesn't flush cache with HKID set.  The cache line could be
> +	 * poisoned (even without MKTME-i), clear the poison bit.
> +	 */
> +	for (i = 0; i < PAGE_SIZE; i += 64)
> +		movdir64b(page + i, zero_page);
> +	/*
> +	 * MOVDIR64B store uses WC buffer.  Prevent following memory reads
> +	 * from seeing potentially poisoned cache.
> +	 */
> +	__mb();

Is __wmb() sufficient for this case?

> +}
> +
[...]

> +
> +static int tdx_do_tdh_mng_key_config(void *param)
> +{
> +	hpa_t *tdr_p = param;
> +	u64 err;
> +
> +	do {
> +		err = tdh_mng_key_config(*tdr_p);
> +
> +		/*
> +		 * If it failed to generate a random key, retry it because this
> +		 * is typically caused by an entropy error of the CPU's random

Here you say "typically", is there other cause and is it safe to loop on 
retry?

> +		 * number generator.
> +		 */
> +	} while (err == TDX_KEY_GENERATION_FAILED);
> +
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_MNG_KEY_CONFIG, err, NULL);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
[...]


