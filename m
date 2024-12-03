Return-Path: <kvm+bounces-32879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CA3099E115B
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 03:33:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7536BB2367B
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 02:33:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E943514F136;
	Tue,  3 Dec 2024 02:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ehpiDc/n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8080251016;
	Tue,  3 Dec 2024 02:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733193211; cv=none; b=QlmUmbRzpLMoQoa8W7C3DPmBVjYcwJiucTWYGzc++Z1C6O6AcotMeEkdUw3zj95bhfRo7UqaorTtBZ4YQ8ZxLlPI0fy/l6Y6Gsz6BQPUwouZjeS4Omxf653/BXaPSvIRZdJ3ITna1b9DWk24pqh+Q6NIaJFWMCDs9/+nZJRHBNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733193211; c=relaxed/simple;
	bh=Q2j6W69w8t91tsJKiOYWiNCCv0Zm/54dio8YcM3qdL4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HiuNrowC+dltPn29WZ+HI+fHWq9BozhyY/eASAVgNHANkJe0LJdOF9zoO5MUQKh9N7SWIvwKEGEvBzbcV0/FGo6ID4iFx3zwCtV3OZH6uHk4n+ej+GD2UV7VchKACRbIpmU7mpMu+SY/hUnh1LLm4yO87pbsmxyZXydiHi+9fK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ehpiDc/n; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733193209; x=1764729209;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Q2j6W69w8t91tsJKiOYWiNCCv0Zm/54dio8YcM3qdL4=;
  b=ehpiDc/n40fxkCsG3rKqfHiP6V28xUrZ8O0QgulmLEYl6T7Nm3SS22bJ
   a9+/YreIpTMOeNKw8nzUl9MXthhASHvt6i8ONrT5PV6k0HjZaTn3WOq6C
   uKkPBsO7SE3WH2REKZujnfEKBjo5V14Eh5l5Zo9n3CcrB7NeBuK2piCMm
   471jqyUUnP6QqX4a6UoO1LYYXQ7WGCQz7N5JR0kVWOlEt+3CgLX+D28m5
   +J932xJokRL+W/5+xvJlP2ECT0ZEZC90ZbQgdeK/kriuXhK5pAmph/12q
   OB/DU6LwSuDr0B9jZiq2Ox63X6MwphbOhR2zSETBhyZPeY3mbwuu3jXRS
   w==;
X-CSE-ConnectionGUID: GzOCXLU5Tl6EwjW5/vWuBQ==
X-CSE-MsgGUID: kP7WgfMVSm6Te2De+/VYwg==
X-IronPort-AV: E=McAfee;i="6700,10204,11274"; a="33522914"
X-IronPort-AV: E=Sophos;i="6.12,204,1728975600"; 
   d="scan'208";a="33522914"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 18:33:29 -0800
X-CSE-ConnectionGUID: hYmx3LiWSKOWK1EUnobh5Q==
X-CSE-MsgGUID: OhIXwgmkSJWiYDE2uOPm/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,204,1728975600"; 
   d="scan'208";a="93120973"
Received: from unknown (HELO [10.238.9.154]) ([10.238.9.154])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 18:33:26 -0800
Message-ID: <a2b2bf58-0d6b-4f27-999b-d9b40ae34ce8@linux.intel.com>
Date: Tue, 3 Dec 2024 10:33:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 4/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 page cache management
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
 dave.hansen@intel.com, isaku.yamahata@gmail.com, kai.huang@intel.com,
 linux-kernel@vger.kernel.org, tony.lindgren@linux.intel.com,
 xiaoyao.li@intel.com, yan.y.zhao@intel.com, x86@kernel.org,
 adrian.hunter@intel.com, Isaku Yamahata <isaku.yamahata@intel.com>,
 Yuan Yao <yuan.yao@intel.com>
References: <20241203010317.827803-1-rick.p.edgecombe@intel.com>
 <20241203010317.827803-5-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20241203010317.827803-5-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 12/3/2024 9:03 AM, Rick Edgecombe wrote:
[...]
> +
> +/*
> + * TDX ABI defines output operands as PT, OWNER and SIZE. These are TDX defined fomats.
fomats -> formats

> + * So despite the names, they must be interpted specially as described by the spec. Return
interpted -> interpreted

> + * them only for error reporting purposes.
> + */
> +u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size)
> +{
> +	struct tdx_module_args args = {
> +		.rcx = page_to_pfn(page) << PAGE_SHIFT,
> +	};
> +	u64 ret;
> +
> +	ret = seamcall_ret(TDH_PHYMEM_PAGE_RECLAIM, &args);
> +
> +	*tdx_pt = args.rcx;
> +	*tdx_owner = args.rdx;
> +	*tdx_size = args.r8;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(tdh_phymem_page_reclaim);
> +
[...]


