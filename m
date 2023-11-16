Return-Path: <kvm+bounces-1876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D46E07EDB9A
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 07:35:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EE32281051
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 06:35:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E30D10A14;
	Thu, 16 Nov 2023 06:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BpkK8WF9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1259D130;
	Wed, 15 Nov 2023 22:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700116540; x=1731652540;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=M6Kj7ZVfefbTWmwT4t5wkfnorCdmmojdk0ojb43vGZE=;
  b=BpkK8WF97dknALHszo2xIRyZ+isWfrxXC721NKQknBG5YLxO1bTh/AqA
   hfwuoWRj0v4ecWuEF6rYIdQ+MW/19y7o7awFsbdBQ8hwsux415tNJJktz
   4pDdllAAun3bM4qcUuFJywMMbRnsflzUYED5L13PIu+zVcQdTaLH2ljxH
   8YI1wCKToH2rY/xpdSKu1l2xMeDoS2zrX8/AGPi/I+TnQOWsaCqjZXAn0
   HnvNRNhdAbEbKNuyHIjdS4Y7uid1FbLXqxtxGRpSfGmHppAUSFLQDHzIh
   x52R9m20nkPRKEyNrqOcN/Gd9wjhfMdqT9agxOuCS9oQVDQUZA30cE5kM
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="457519052"
X-IronPort-AV: E=Sophos;i="6.03,307,1694761200"; 
   d="scan'208";a="457519052"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 22:35:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,307,1694761200"; 
   d="scan'208";a="6427183"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.126]) ([10.238.10.126])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 22:35:36 -0800
Message-ID: <c9413cb8-8aae-4233-b55f-fbac91459173@linux.intel.com>
Date: Thu, 16 Nov 2023 14:35:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 059/116] KVM: TDX: Create initial guest memory
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
 Kai Huang <kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 gkirkpatrick@google.com
References: <cover.1699368322.git.isaku.yamahata@intel.com>
 <e8fdc92439efeed0ee05f39b1cd2dc1023014c11.1699368322.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <e8fdc92439efeed0ee05f39b1cd2dc1023014c11.1699368322.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/7/2023 10:56 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Because the guest memory is protected in TDX, the creation of the initial
> guest memory requires a dedicated TDX module API, tdh_mem_page_add, instead
> of directly copying the memory contents into the guest memory in the case
> of the default VM type.  KVM MMU page fault handler callback,
> private_page_add, handles it.
>
> Define new subcommand, KVM_TDX_INIT_MEM_REGION, of VM-scoped
> KVM_MEMORY_ENCRYPT_OP.  It assigns the guest page, copies the initial
> memory contents into the guest memory, encrypts the guest memory.  At the
> same time, optionally it extends memory measurement of the TDX guest.  It
> calls the KVM MMU page fault(EPT-violation) handler to trigger the
> callbacks for it.
>
> Reported-by: gkirkpatrick@google.com
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>
> ---
> v15 -> v16:
> - add check if nr_pages isn't large with
>    (nr_page << PAGE_SHIFT) >> PAGE_SHIFT
>
> v14 -> v15:
> - add a check if TD is finalized or not to tdx_init_mem_region()
> - return -EAGAIN when partial population
> ---
>   arch/x86/include/uapi/asm/kvm.h       |   9 ++
>   arch/x86/kvm/mmu/mmu.c                |   1 +
>   arch/x86/kvm/vmx/tdx.c                | 167 +++++++++++++++++++++++++-
>   arch/x86/kvm/vmx/tdx.h                |   2 +
>   tools/arch/x86/include/uapi/asm/kvm.h |   9 ++
>   5 files changed, 185 insertions(+), 3 deletions(-)
>
[...]
>   
> +static int tdx_sept_page_add(struct kvm *kvm, gfn_t gfn,
> +			     enum pg_level level, kvm_pfn_t pfn)

For me, the function name is a bit confusing.
I would relate it to a SEPT table page instead of a normal private page 
if only by the function name.

Similar to tdx_sept_page_aug(), though it's less confusing due to there 
is no seam call to aug a sept table page.


> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	hpa_t hpa = pfn_to_hpa(pfn);
> +	gpa_t gpa = gfn_to_gpa(gfn);
> +	struct tdx_module_args out;
> +	hpa_t source_pa;
> +	bool measure;
> +	u64 err;
> +
> +	/*
> +	 * KVM_INIT_MEM_REGION, tdx_init_mem_region(), supports only 4K page
> +	 * because tdh_mem_page_add() supports only 4K page.
> +	 */
> +	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> +		return -EINVAL;
> +
> +	/*
> +	 * In case of TDP MMU, fault handler can run concurrently.  Note
> +	 * 'source_pa' is a TD scope variable, meaning if there are multiple
> +	 * threads reaching here with all needing to access 'source_pa', it
> +	 * will break.  However fortunately this won't happen, because below
> +	 * TDH_MEM_PAGE_ADD code path is only used when VM is being created
> +	 * before it is running, using KVM_TDX_INIT_MEM_REGION ioctl (which
> +	 * always uses vcpu 0's page table and protected by vcpu->mutex).
> +	 */
> +	if (KVM_BUG_ON(kvm_tdx->source_pa == INVALID_PAGE, kvm)) {
> +		tdx_unpin(kvm, pfn);
> +		return -EINVAL;
> +	}
> +
> +	source_pa = kvm_tdx->source_pa & ~KVM_TDX_MEASURE_MEMORY_REGION;
> +	measure = kvm_tdx->source_pa & KVM_TDX_MEASURE_MEMORY_REGION;
> +	kvm_tdx->source_pa = INVALID_PAGE;
> +
> +	do {
> +		err = tdh_mem_page_add(kvm_tdx->tdr_pa, gpa, hpa, source_pa,
> +				       &out);
> +		/*
> +		 * This path is executed during populating initial guest memory
> +		 * image. i.e. before running any vcpu.  Race is rare.
> +		 */
> +	} while (unlikely(err == TDX_ERROR_SEPT_BUSY));
> +	if (KVM_BUG_ON(err, kvm)) {
> +		pr_tdx_error(TDH_MEM_PAGE_ADD, err, &out);
> +		tdx_unpin(kvm, pfn);
> +		return -EIO;
> +	} else if (measure)
> +		tdx_measure_page(kvm_tdx, gpa);
> +
> +	return 0;
> +
> +}
> +
[...]


