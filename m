Return-Path: <kvm+bounces-64597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BE05C8823F
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 06:21:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29E2C3B2808
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 05:21:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D8DC31281F;
	Wed, 26 Nov 2025 05:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SiJfwWbx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3735D274B58;
	Wed, 26 Nov 2025 05:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764134506; cv=none; b=kGrJOCW8ciYMImPjYkxsp4ui8pMLpDhuJ+taeT0keUP+5RLevwCYHvK/V2Yi4ZH2JCfUMiiqpUfaXXhp5Zxe2YdISmsS01q9OUNN+MJZDTqLmGYHtUHxi6h0/Vjk+yzb0i4k2DUAzov1www4oSb1ux2ID85IPB4G99jIfCM8KVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764134506; c=relaxed/simple;
	bh=V34EkMlx5730oKCbGsZ8UnN8wqaCpact9cdZChfm4Ok=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=HZA8VKsyFGT8VLIIMmQJrirxztkDEM2ntnC9Nn+XCRDygDuVkclgXUtzbBNkmhlnbVT3sEsXGy+/fmRqs4uCzOi3vBQDi9P5Rx2sY57u1Z5Rsg/YmCbSLyEhcs9xaWErPSXZ0xA2uQXfuKSB6uovrVoQdaNZFZme3rXsmcoVc5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SiJfwWbx; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764134503; x=1795670503;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=V34EkMlx5730oKCbGsZ8UnN8wqaCpact9cdZChfm4Ok=;
  b=SiJfwWbxgYj2xRsgHCO/nug3dZB983t82oBvf0QkRKkuPsrUPBA8KW8O
   vTJxpLBA0wf9ZPSH8/jgplKGJRazJYw2i+bq8dePk6lTVsrjMnMWEiOry
   YmkPASWLefe7BDvsww1+x56yfsZ1awECJ1dzkVFCd+H+aAmF5uys3Madx
   XSkh/eXmOtAezOOGdefMTIDNTgYmH/feA9RTVqrOAiqcerHVYN0EitaPL
   lfZRSIwUUL78Zh+l6NHWFEZCuaO3CP61kKZ7pd2P6KAr0uKJo2GS9MeAo
   gJ93R+R1DZOIVe61tfP+rf3jlAPUSnNhhUdB+Sz9Q2hcZycrP8fFMx7I/
   Q==;
X-CSE-ConnectionGUID: 0LXRNBjlT/SFe+mp77D4aA==
X-CSE-MsgGUID: v2fwvRSNTouw5lviBAcB7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="76844966"
X-IronPort-AV: E=Sophos;i="6.20,227,1758610800"; 
   d="scan'208";a="76844966"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 21:21:42 -0800
X-CSE-ConnectionGUID: IQJLDWK2TBmAYVm94bJPjg==
X-CSE-MsgGUID: Zx0Kr9htSVOu9c/mICPSuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,227,1758610800"; 
   d="scan'208";a="192631997"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 21:21:37 -0800
Message-ID: <e6ecd387-e57d-4bfa-b4f7-38662a39a50b@linux.intel.com>
Date: Wed, 26 Nov 2025 13:21:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
From: Binbin Wu <binbin.wu@linux.intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: bp@alien8.de, chao.gao@intel.com, dave.hansen@intel.com,
 isaku.yamahata@intel.com, kai.huang@intel.com, kas@kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
 seanjc@google.com, tglx@linutronix.de, vannapurve@google.com,
 x86@kernel.org, yan.y.zhao@intel.com, xiaoyao.li@intel.com,
 binbin.wu@intel.com
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-13-rick.p.edgecombe@intel.com>
 <7a6f5b4e-ad7b-4ad0-95fd-e1698f9b4e06@linux.intel.com>
Content-Language: en-US
In-Reply-To: <7a6f5b4e-ad7b-4ad0-95fd-e1698f9b4e06@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/26/2025 11:40 AM, Binbin Wu wrote:
>> index 260bb0e6eb44..61a058a8f159 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -1644,23 +1644,34 @@ static int tdx_mem_page_add(struct kvm *kvm, gfn_t gfn, enum pg_level level,
>>     static void *tdx_alloc_external_fault_cache(struct kvm_vcpu *vcpu)
>>   {
>> -    struct vcpu_tdx *tdx = to_tdx(vcpu);
>> +    struct page *page = get_tdx_prealloc_page(&to_tdx(vcpu)->prealloc);
>>   -    return kvm_mmu_memory_cache_alloc(&tdx->mmu_external_spt_cache);
>> +    if (WARN_ON_ONCE(!page))
>> +        return (void *)__get_free_page(GFP_ATOMIC | __GFP_ACCOUNT);
>
> kvm_mmu_memory_cache_alloc() calls BUG_ON() if the atomic allocation failed.
> Do we want to follow?
>
>
Please ignore this one.


