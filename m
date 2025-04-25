Return-Path: <kvm+bounces-44247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FCB2A9BEE0
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 08:51:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E9D0927A45
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 06:51:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FA3F22D7B7;
	Fri, 25 Apr 2025 06:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NzqbSrsT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1594414;
	Fri, 25 Apr 2025 06:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745563888; cv=none; b=IXP8mfCMlGqt58tHixOObXmlTNV/FrhSzhqs8+I5BBW2nKHSe3vTt16skYMglVu/Co3q3iMbDHERrb2cdX3PpSsaZMc28W+vxy22jdZkvk3SaeGRg3PtCrksTbt8Ukj/xjq2MuPqb6ZfLwDW/Vom9ClvcOZ9yBTtFg68qs4Z5NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745563888; c=relaxed/simple;
	bh=qE5He3lSxJhvmVM8Nl+q+b9mw5NmT3/KuhkzFgiNOLo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fN8pHJQSV+nQy0EV6WRi1FeyJKYTJJJMs7LnVj5nNFNJsbbX+ALiom86LVpaW3UBsg5eTTigqHjkrmUc1NV66ve1KqlieAwZ+LNtKKzbquvvi3oJIMC9xqsB/UPi2pE65W1ZKehArPWAx3OV4HpDnIX1d9LL5nn0o+FOrp9VeKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NzqbSrsT; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745563887; x=1777099887;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qE5He3lSxJhvmVM8Nl+q+b9mw5NmT3/KuhkzFgiNOLo=;
  b=NzqbSrsTGNFz6qt9R1k6fGgUjFmVPKf2gjMHC9Ayjb59VFCxGQ54/Hb9
   rdh2uZ1jvHqlKj3arQdX8QMB4CPWxdqV4AaauN5mW6kJt/huZN+BCRZb2
   Y4sFwZrAr9gSrCaA+XOpNFXcLqLue9MUyQzk8K7tJBBDP04BJcabHCi3R
   IIjKVdTknlY+HcMKj+Fokx70h6sZ0YPFLyFrVbcVEMMlsdxFADM07PHmi
   a0vlDPEYueMd+3jG9tmGq4SZYGuxQuFwmRKW7tNIz24t8Ob1i+wgR6Wej
   hONU1E3FdYWYUlnx1PylQl4M3m8ye1l3YA/+Az+lrWt9PHobz7oDrdwzC
   Q==;
X-CSE-ConnectionGUID: GiHcf1MPTpiKrd+/g+qtZw==
X-CSE-MsgGUID: hryq7iFnRf6ADgf8hXndtQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11413"; a="50883773"
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="50883773"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 23:51:27 -0700
X-CSE-ConnectionGUID: TqDgjc2aSviPiddjNwNzuA==
X-CSE-MsgGUID: OTrdxKbbQLa5Ms3pu2HTYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="137987480"
Received: from yijiemei-mobl.ccr.corp.intel.com (HELO [10.238.2.108]) ([10.238.2.108])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 23:51:21 -0700
Message-ID: <a7d0988d-037c-454f-bc6b-57e71b357488@linux.intel.com>
Date: Fri, 25 Apr 2025 14:51:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/21] x86/virt/tdx: Enhance tdh_mem_page_aug() to
 support huge pages
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com,
 dave.hansen@intel.com, kirill.shutemov@intel.com, tabba@google.com,
 ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com,
 david@redhat.com, vannapurve@google.com, vbabka@suse.cz, jroedel@suse.de,
 thomas.lendacky@amd.com, pgonda@google.com, zhiquan1.li@intel.com,
 fan.du@intel.com, jun.miao@intel.com, ira.weiny@intel.com,
 isaku.yamahata@intel.com, xiaoyao.li@intel.com, chao.p.peng@intel.com
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030428.32687-1-yan.y.zhao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250424030428.32687-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 4/24/2025 11:04 AM, Yan Zhao wrote:
> Enhance the SEAMCALL wrapper tdh_mem_page_aug() to support huge pages.
>
> Verify the validity of the level and ensure that the mapping range is fully
> contained within the page folio.
>
> As a conservative solution, perform CLFLUSH on all pages to be mapped into
> the TD before invoking the SEAMCALL TDH_MEM_PAGE_AUG. This ensures that any
> dirty cache lines do not write back later and clobber TD memory.
>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>   arch/x86/virt/vmx/tdx/tdx.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index f5e2a937c1e7..a66d501b5677 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -1595,9 +1595,18 @@ u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u
>   		.rdx = tdx_tdr_pa(td),
>   		.r8 = page_to_phys(page),
>   	};
> +	unsigned long nr_pages = 1 << (level * 9);
> +	struct folio *folio = page_folio(page);
> +	unsigned long idx = 0;
>   	u64 ret;
>   
> -	tdx_clflush_page(page);
> +	if (!(level >= TDX_PS_4K && level < TDX_PS_NR) ||
> +	    (folio_page_idx(folio, page) + nr_pages > folio_nr_pages(folio)))
> +		return -EINVAL;
> +
> +	while (nr_pages--)
> +		tdx_clflush_page(nth_page(page, idx++));
Is the following better to save a variable?

while (nr_pages)
     tdx_clflush_page(nth_page(page, --nr_pages));


> +
>   	ret = seamcall_ret(TDH_MEM_PAGE_AUG, &args);
>   
>   	*ext_err1 = args.rcx;


