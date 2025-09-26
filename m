Return-Path: <kvm+bounces-58854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74A22BA2FCF
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 10:41:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 610DA7B7A64
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 08:40:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96A8E299957;
	Fri, 26 Sep 2025 08:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MRuPR6cj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C9935950;
	Fri, 26 Sep 2025 08:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758876094; cv=none; b=VzcXv4KGOhPrThcxD8Zc4yBUP929Tf36VuBM5UFm+ffcjIoZ667dNntvI4bfHbRZifQOEOU0F8Yg87S6hMcOd8tZWLmD85D2qctDa2YgW9K3D3ZevOCflY6JbrtpjJ3cKyKSZDupK0Fh+dIzS7uqtCelIE0BM3s/kG5sMh1F6ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758876094; c=relaxed/simple;
	bh=xROXHT4VoPRRKHqoPg/tMmdBbOqnhdU8Px917+aIcKo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TG7wOL9uEgP7Zyr5xpdgOKbI7Ko4lYuFOpDJsrHLMkpFCKfl4A1t+DYA/efOcZTfznsRT5pnRu5mkW33CkLeeau4N4F9rhjQT4o6KwZBxmlH08ciH9qMQT+81RkhADY6cAVAM3IrkYnRW1T5djI+PhjzdCbYvIjNEf6o01yYgTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MRuPR6cj; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758876092; x=1790412092;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xROXHT4VoPRRKHqoPg/tMmdBbOqnhdU8Px917+aIcKo=;
  b=MRuPR6cj0gMRYAOiofscjyPkRs2ZIZgyGZxG33Aty67o+Tu7dBF3Mb2D
   Ql32S33+hhzC+SPQcxjyVcZNAWbbarRCqwT00rBJ8pTm3fR3mexf5NULz
   Kk34CS5MTiOlX+B7wsLTuRjlrWpzz0/MAcpBITWtEssHc6Sf5nloAIX95
   RyzeilCVbWXsC5qz0sRg3qDwMsaPJ5WK90+F1W8sKqRfKZ1NQ269Dgeq5
   KnloXU3Lsy9psapI8KuyvEvSiDe6AU4ihdPcvoQhXIFUshHEVLXKDgjn/
   vcY6tzJusalZHXfE/CsA6Ae32bMdno2KTv6tcShZLCH9dfVrzB0pTCDVQ
   Q==;
X-CSE-ConnectionGUID: yFmMvwBtSfCMFl7/10w3xA==
X-CSE-MsgGUID: c62VjFBIRtahl4wk5S3mUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="61126305"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="61126305"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 01:41:31 -0700
X-CSE-ConnectionGUID: 11PsIL0ARiap/71JCpSvUg==
X-CSE-MsgGUID: q0Zoyy8RQP26KP5BrBw6EQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="208313518"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 01:41:26 -0700
Message-ID: <ba3de7ec-56bd-4e24-a9d3-5d272afe4b0f@intel.com>
Date: Fri, 26 Sep 2025 16:41:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/16] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, kas@kernel.org,
 bp@alien8.de, chao.gao@intel.com, dave.hansen@linux.intel.com,
 isaku.yamahata@intel.com, kai.huang@intel.com, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, mingo@redhat.com,
 pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de, x86@kernel.org,
 yan.y.zhao@intel.com, vannapurve@google.com,
 Dan Williams <dan.j.williams@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-5-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250918232224.2202592-5-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

+ Dan,

On 9/19/2025 7:22 AM, Rick Edgecombe wrote:
> diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
> index 13ad2663488b..683925bcc9eb 100644
> --- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
> +++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
> @@ -33,6 +33,9 @@ static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
>   		sysinfo_tdmr->pamt_2m_entry_size = val;
>   	if (!ret && !(ret = read_sys_metadata_field(0x9100000100000012, &val)))
>   		sysinfo_tdmr->pamt_1g_entry_size = val;
> +	if (!ret && tdx_supports_dynamic_pamt(&tdx_sysinfo) &&
> +	    !(ret = read_sys_metadata_field(0x9100000100000013, &val)))
> +		sysinfo_tdmr->pamt_page_bitmap_entry_bits = val;
>   
>   	return ret;
>   }

It looks like the update is not produced by the script[1], but manually, 
right?

Looking at the history

   git log arch/x86/virt/vmx/tdx/tdx_global_metadata.c

It looks the expectation is always adding new fields by updating the 
script[1] and running it with the latest 'tdx_global_metadata.c'.

Dan Williams also expressed internally that we should have checked the 
script[1] into the kernel. I agree with him and it's never too late to 
do it.

[1]https://lore.kernel.org/kvm/0853b155ec9aac09c594caa60914ed6ea4dc0a71.camel@intel.com/

