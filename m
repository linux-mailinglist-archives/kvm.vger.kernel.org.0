Return-Path: <kvm+bounces-63345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3201AC6320B
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 10:20:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 248343ADD14
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 09:17:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55AE6326D75;
	Mon, 17 Nov 2025 09:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fBxUbmgf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD9C31E107;
	Mon, 17 Nov 2025 09:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763371057; cv=none; b=qlXU6KZ6xOfgVpJOit1ulJo9/V+IrDkAQu6MeWo5wZgi7zKQif4r14a25iDqbwkGUDTQ+4xPVGWFJjZc0Ny9oqJHPyc89+9eSFAi3OAXo8odljnn+/eM2wyaPH1EED6t8KG4OxVpcbBX+01kDBbIiyCnE1WWcsQJ7RGnrSqawq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763371057; c=relaxed/simple;
	bh=TZE5yDYJutkZg9tMPF5UhEQJMyeYiBNos2LEjWFdTtA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HpGodiJU9tUQFeH5086rN1A4cMbCMhujU7AOxjmTjYZk3DzAXJICBrcjLggbcS6Pk8eGmNQhw2O2CTqidCK/QNBre2t0Wd0dyLjuoN8e0svz2JfzLSCrjrpAkOeu8OWEC6SSyKJy8XifwoQRb36kYjKkSxoTJdgWch5GVOUHT/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fBxUbmgf; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763371055; x=1794907055;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TZE5yDYJutkZg9tMPF5UhEQJMyeYiBNos2LEjWFdTtA=;
  b=fBxUbmgf8h8gHYvQLDuWoCIZiOC7WihcqfnUeDh3HyMVc5Je9mhlrKdL
   e1LlisMXoVMigCNd0+9lwBGLjOmnEWVMbMJAXePVEidppQYfy0GfSAW0r
   cdAy4qprLx/CuMA4VDGztJVVCazl2Q5LttndM6/yA2aEH4Pyq2xIVVQPi
   RRgdxzkxlfM1Few89NnfQe59sAi6euxwmj10fSv2sxAUP7ksx1+JcfBMv
   9Tc0h0DVWWZ+H2IhPIRt5jxvsNSYj6NjmyaRRb5s6HgpJhI3Jyx/xZz3F
   4huhxZJU6rp7q8jxbrlcJEMCttTrtBQRr1utwRgWRudxd9Bt31LTF8rUv
   w==;
X-CSE-ConnectionGUID: NOMsymhiQGWHBez1SiFeSA==
X-CSE-MsgGUID: YkZ6qIFKTCGpQO91jcdc6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="82991217"
X-IronPort-AV: E=Sophos;i="6.19,311,1754982000"; 
   d="scan'208";a="82991217"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 01:17:34 -0800
X-CSE-ConnectionGUID: ZFW2Z9yyQ8CjfhjgYhjkIQ==
X-CSE-MsgGUID: ZTIqem80TbmW40YXElDwFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,311,1754982000"; 
   d="scan'208";a="213801415"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 01:17:29 -0800
Message-ID: <3d452a46-451d-4e68-be3b-90f4bdec07d9@linux.intel.com>
Date: Mon, 17 Nov 2025 17:17:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 10/23] KVM: TDX: Enable huge page splitting under
 write kvm->mmu_lock
To: Yan Zhao <yan.y.zhao@intel.com>, "Huang, Kai" <kai.huang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>,
 "Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
 <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>,
 "kas@kernel.org" <kas@kernel.org>,
 "michael.roth@amd.com" <michael.roth@amd.com>,
 "Weiny, Ira" <ira.weiny@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "Peng, Chao P" <chao.p.peng@intel.com>,
 "Annapurve, Vishal" <vannapurve@google.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
 "pgonda@google.com" <pgonda@google.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094333.4579-1-yan.y.zhao@intel.com>
 <9aa8b3967af614142c6d2ce7d12773fa2bc18478.camel@intel.com>
 <aRVyYdBlnS7DD1SS@yzhao56-desk.sh.intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <aRVyYdBlnS7DD1SS@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/13/2025 1:53 PM, Yan Zhao wrote:
> On Tue, Nov 11, 2025 at 06:20:40PM +0800, Huang, Kai wrote:
>> On Thu, 2025-08-07 at 17:43 +0800, Yan Zhao wrote:
>>> Implement the split_external_spt hook to enable huge page splitting for

Nit:
split_external_spt(), similar as Kai mentioned in patch 9.

>>> TDX when kvm->mmu_lock is held for writing.
>>>
>>> Invoke tdh_mem_range_block(), tdh_mem_track(), kicking off vCPUs,
>>> tdh_mem_page_demote() in sequence. All operations are performed under
>>> kvm->mmu_lock held for writing, similar to those in page removal.
>>>
>>> Even with kvm->mmu_lock held for writing, tdh_mem_page_demote() may still
>>> contend with tdh_vp_enter() and potentially with the guest's S-EPT entry
>>> operations. Therefore, kick off other vCPUs and prevent tdh_vp_enter()
>>> from being called on them to ensure success on the second attempt. Use
>>> KVM_BUG_ON() for any other unexpected errors.
>> I thought we also need to do UNBLOCK after DEMOTE, but it turns out we don't
>> need to.
> Yes, the BLOCK operates on PG_LEVEL_2M, and a successful DEMOTE updates the SEPT
> non-leaf 2MB entry to point to the newly added page table page with RWX
> permission, so there's no need to do UNBLOCK on success.
>
> The purpose of BLOCK + TRACK + kick off vCPUs is to ensure all vCPUs must find
> the old huge guest page is no longer mapped in the SEPT.
>
>> Maybe we can call this out.
> Will do.
>
>>> +static int tdx_spte_demote_private_spte(struct kvm *kvm, gfn_t gfn,
>>> +					enum pg_level level, struct page *page)
>>> +{
>>> +	int tdx_level = pg_level_to_tdx_sept_level(level);
>>> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>>> +	gpa_t gpa = gfn_to_gpa(gfn);
>>> +	u64 err, entry, level_state;
>>> +
>>> +	err = tdh_mem_page_demote(&kvm_tdx->td, gpa, tdx_level, page,
>>> +				  &entry, &level_state);
>>> +
>>> +	if (unlikely(tdx_operand_busy(err))) {
>>> +		tdx_no_vcpus_enter_start(kvm);
>>> +		err = tdh_mem_page_demote(&kvm_tdx->td, gpa, tdx_level, page,
>>> +					  &entry, &level_state);
>>> +		tdx_no_vcpus_enter_stop(kvm);
>>> +	}
>>> +
>>> +	if (KVM_BUG_ON(err, kvm)) {
>>> +		pr_tdx_error_2(TDH_MEM_PAGE_DEMOTE, err, entry, level_state);
>>> +		return -EIO;
>>> +	}
>>> +	return 0;
>>> +}
>>> +
>>> +static int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn, enum pg_level level,
>>> +				      void *private_spt)
>>> +{
>>> +	struct page *page = virt_to_page(private_spt);
>>> +	int ret;
>>> +
>>> +	if (KVM_BUG_ON(to_kvm_tdx(kvm)->state != TD_STATE_RUNNABLE ||
>>> +		       level != PG_LEVEL_2M, kvm))
>>> +		return -EINVAL;
>>> +
>>> +	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
>> I don't quite follow why you pass 'private_spt' to
>> tdx_sept_zap_private_spte(),
> Simply because tdx_sept_zap_private_spte() requires a "page", which is actually
> not used by tdx_sept_zap_private_spte() in the split path.
>
>> but it doesn't matter anymore since it's gone
>> in Sean's latest tree.
> Right.
>


