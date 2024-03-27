Return-Path: <kvm+bounces-12742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F16088D380
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 01:48:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0E0C2C5E41
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 00:48:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02FFB18E1D;
	Wed, 27 Mar 2024 00:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nBrVbisA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25934125C1;
	Wed, 27 Mar 2024 00:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711500496; cv=none; b=qSxwO2Ta4podXKgrMZqoXxv1y+mO7cC2yFIDj6zXmre8JCDDJryxsU2CqMJi9Y880GfK2cc6xhP9Lm6ljbYUFzJh1m8VTwTgEAm1IlQLVz5rkLVsdl3cllV1faL7Mat6hHRg4AV0Nd2MpnrzugR52XTVDdMPtzZaXv5O1jzMOxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711500496; c=relaxed/simple;
	bh=vRIhKjtK5KUqqD/xM6V+L7t8LjfRUzw5/jZWpRZcMiY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RT7dF8fYBupQlclYAVdb4moRmUpo+rBDDFTIyGWENhE6YfvOdfBTD0VID/r+x7kwlSv/JtjDNrc5Kw8BnRf1IdrD3hEffxwo7NId7vFTU3KIiMoMDMrGw2zVC8IoocXmLESZpTDUuO/kAPAdvyTF41c3et3DJMtMcFluTf6ZVrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nBrVbisA; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711500494; x=1743036494;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vRIhKjtK5KUqqD/xM6V+L7t8LjfRUzw5/jZWpRZcMiY=;
  b=nBrVbisArdnhCcw6TuZaONQZsKS+yosp/G7/zS1ERb+ic7V3X7hbDe5n
   GTV3cKoUzf/wQ+sj6crYUHoZ6aujKp1PqF3nnmiINO0tL/04Z+oVAuLp2
   uFLZS+UrePkK9SifHUyU/VMqgOc4pN2i1v9W3NuZ8ViPVH2TfMI+4BSEJ
   +JYyh7mNWLLM1nIPs5JLtwX16mWAGZgE/UGQmmhfG0qrDD0zpX82TX83Z
   rVogNkttWdngXpwYnl2kSQwup6+I0czAb8AlukgmR+rJQIf5PhcGkdHD0
   uHdjZ4kSiJ60igmmDVQowLGDMNb6VCtJkOvHn30UbwIdkidH0fBBLixDj
   w==;
X-CSE-ConnectionGUID: z+TD5Vu/QBiKEjJXl3Joqg==
X-CSE-MsgGUID: 9TNezZRnQ2mvAidIdBt2ig==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="17311751"
X-IronPort-AV: E=Sophos;i="6.07,157,1708416000"; 
   d="scan'208";a="17311751"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 17:48:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,157,1708416000"; 
   d="scan'208";a="20609157"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.225]) ([10.238.10.225])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 17:47:57 -0700
Message-ID: <a3d0b8dd-4831-4cf3-839e-ef40bdcea234@linux.intel.com>
Date: Wed, 27 Mar 2024 08:47:54 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 048/130] KVM: Allow page-sized MMU caches to be
 initialized with custom 64-bit values
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 isaku.yamahata@linux.intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9c392612eac4f3c489ad12dd4a4d505cf10d36dc.1708933498.git.isaku.yamahata@intel.com>
 <d2ea2f8e-80b1-4dda-bf47-2145859e7463@linux.intel.com>
 <20240326173414.GA2444378@ls.amr.corp.intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240326173414.GA2444378@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/27/2024 1:34 AM, Isaku Yamahata wrote:
> On Tue, Mar 26, 2024 at 11:53:02PM +0800,
> Binbin Wu <binbin.wu@linux.intel.com> wrote:
>
>>
>> On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
>>> From: Sean Christopherson <seanjc@google.com>
>>>
>>> Add support to MMU caches for initializing a page with a custom 64-bit
>>> value, e.g. to pre-fill an entire page table with non-zero PTE values.
>>> The functionality will be used by x86 to support Intel's TDX, which needs
>>> to set bit 63 in all non-present PTEs in order to prevent !PRESENT page
>>> faults from getting reflected into the guest (Intel's EPT Violation #VE
>>> architecture made the less than brilliant decision of having the per-PTE
>>> behavior be opt-out instead of opt-in).
>>>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>> ---
>>>    include/linux/kvm_types.h |  1 +
>>>    virt/kvm/kvm_main.c       | 16 ++++++++++++++--
>>>    2 files changed, 15 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
>>> index 9d1f7835d8c1..60c8d5c9eab9 100644
>>> --- a/include/linux/kvm_types.h
>>> +++ b/include/linux/kvm_types.h
>>> @@ -94,6 +94,7 @@ struct gfn_to_pfn_cache {
>>>    struct kvm_mmu_memory_cache {
>>>    	gfp_t gfp_zero;
>>>    	gfp_t gfp_custom;
>>> +	u64 init_value;
>>>    	struct kmem_cache *kmem_cache;
>>>    	int capacity;
>>>    	int nobjs;
>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>> index de38f308738e..d399009ef1d7 100644
>>> --- a/virt/kvm/kvm_main.c
>>> +++ b/virt/kvm/kvm_main.c
>>> @@ -401,12 +401,17 @@ static void kvm_flush_shadow_all(struct kvm *kvm)
>>>    static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
>>>    					       gfp_t gfp_flags)
>>>    {
>>> +	void *page;
>>> +
>>>    	gfp_flags |= mc->gfp_zero;
>>>    	if (mc->kmem_cache)
>>>    		return kmem_cache_alloc(mc->kmem_cache, gfp_flags);
>>> -	else
>>> -		return (void *)__get_free_page(gfp_flags);
>>> +
>>> +	page = (void *)__get_free_page(gfp_flags);
>>> +	if (page && mc->init_value)
>>> +		memset64(page, mc->init_value, PAGE_SIZE / sizeof(mc->init_value));
>> Do we need a static_assert() to make sure mc->init_value is 64bit?
> I don't see much value.  Is your concern sizeof() part?
> If so, we can replace it with 8.
>
>          memset64(page, mc->init_value, PAGE_SIZE / 8);

Yes, but it's trivial. So, up to you. :)


