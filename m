Return-Path: <kvm+bounces-29122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38FE19A32A3
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 04:23:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F25B82855F9
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 02:23:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E8EF152196;
	Fri, 18 Oct 2024 02:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fB6aG3HU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6262158DB1;
	Fri, 18 Oct 2024 02:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729218111; cv=none; b=mie3AMRqCCWJthnNNVY7F7cOIS+3tF4Qkxr1GzBRQ3Mg6Sl2O3an7siJekM5+yq+uj8C+C3lyzmbxq6QymsDcUvVf5ViZTFg+g+FKl3UXdbpvj5G/Gg5n1/V6jxeR7+hM3m0yotajXJf2S75SY+DbrLUG5uQ/hs++NKmlA5mXCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729218111; c=relaxed/simple;
	bh=Nry3rVCi8/za/36G9Tg8vsDLl0xoAWHmEVnhEGzG+oQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SLkUNTgjzz4ts0c8Mce9OU17kRL18laLSIY8LQB84ejzWQgOOeQW0SPG0fROWtmplE82hRNI5r8VzVMj2gYA164pdiklqbNC/dHcDoZU9xM7QQOvW8+PnhiYg3ThfU/ThgnaqDB/oz5Lm8WLm0AJKhDgp8ngUjEwPJdxitbkl6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fB6aG3HU; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729218109; x=1760754109;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Nry3rVCi8/za/36G9Tg8vsDLl0xoAWHmEVnhEGzG+oQ=;
  b=fB6aG3HUQ805d7ZJQPdMAOpgcmYyiW8hBm7w5kGTkZQDxYMKgwn1VtkF
   5HfzNaDzQ5ZupQB7Vzo5Yjp4C5R5bJIqDtHJF9MLDqaQz/ziVF3btpVlG
   vAHqrj/7DkJQPMhayYyqDw2mXphLgvG9oBJzppdif/lqJrlSWsbaPXCoH
   mFv2GBSmEXLAcO3GjAhyIDdkxC4XzuOg5pBtlIq6RODrgMjnfrdEvHX5p
   0hXA1zd/4Onk6lNCpwgW17psCNJGbufbhPw60SLLHCPzMAQ8D8XGWq9F7
   0+PR1QJepWv8Dq+7c5CIZpbwKK01idMJ1oXpKkGwfOMcS/tJlmyz38u4n
   A==;
X-CSE-ConnectionGUID: 2NfEmx/FRm2qOQua4Fukzg==
X-CSE-MsgGUID: 96Z2KwPCQ6SRbmpliawfnQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28834035"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="28834035"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 19:21:49 -0700
X-CSE-ConnectionGUID: k3g80N+MTRKmVhktp9Jz2A==
X-CSE-MsgGUID: weiLgmf8TK6MhJcOZRqcjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,212,1725346800"; 
   d="scan'208";a="83376224"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.38]) ([10.124.224.38])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 19:21:46 -0700
Message-ID: <aa3d2db8-e72c-42e2-b08f-6a4c9ad78748@intel.com>
Date: Fri, 18 Oct 2024 10:21:36 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/25] KVM: TDX: Do TDX specific vcpu initialization
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Hunter, Adrian" <adrian.hunter@intel.com>,
 "yuan.yao@linux.intel.com" <yuan.yao@linux.intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
 <kai.huang@intel.com>, "isaku.yamahata@gmail.com"
 <isaku.yamahata@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-19-rick.p.edgecombe@intel.com>
 <20240813080009.zowu3woyffwlyazu@yy-desk-7060>
 <1a200cd3-ad73-4a53-bc48-661f7d022ac0@intel.com>
 <1be47d7f9d4b812c110572d8b413ecdbb537ceb7.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <1be47d7f9d4b812c110572d8b413ecdbb537ceb7.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/17/2024 1:42 AM, Edgecombe, Rick P wrote:
> On Wed, 2024-10-09 at 18:01 +0300, Adrian Hunter wrote:
>> tdh_vp_init_apicid() passes x2APIC ID to TDH.VP.INIT which
>> is one of the steps for the TDX Module to support topology
>> information for the guest i.e. CPUID leaf 0xB and CPUID leaf 0x1F.
>>
>> If the host VMM does not provide CPUID leaf 0x1F values
>> (i.e. the values are 0), then the TDX Module will use native
>> values for both CPUID leaf 0x1F and CPUID leaf 0xB.
>>
>> To get 0x1F/0xB the guest must also opt-in by setting
>> TDCS.TD_CTLS.ENUM_TOPOLOGY to 1.  AFAICT currently Linux
>> does not do that.
>>
>> In the tdh_vp_init() case, topology information will not be
>> supported.
>>
>> If topology information is not supported CPUID leaf 0xB and
>> CPUID leaf 0x1F will #VE, and a Linux guest will return zeros.
>>
>> So, yes, it seems like tdh_vp_init_apicid() should only
>> be called if there is non-zero CPUID leaf 0x1F values provided
>> by host VMM. e.g. add a helper function
>>
>> bool tdx_td_enum_topology(struct kvm_cpuid2 *cpuid)
>> {
>> 	const struct tdx_sys_info_features *modinfo = &tdx_sysinfo->features;
>> 	const struct kvm_cpuid_entry2 *entry;
>>
>> 	if (!(modinfo->tdx_features0 & MD_FIELD_ID_FEATURES0_TOPOLOGY_ENUM))
>> 		return false;
>>
>> 	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0x1f, 0);
>> 	if (!entry)
>> 		return false;
>>
>> 	return entry->eax || entry->ebx || entry->ecx || entry->edx;
>> }
> 
> KVM usually leaves it up to userspace to not create nonsensical VMs. So I think
> we can skip the check in KVM.

It's not nonsensical unless KVM announces its own requirement for TD 
guest that userspace VMM must provide valid CPUID leaf 0x1f value for 
topology.

It's architectural valid that userspace VMM creates a TD with legacy 
topology, i.e., topology enumerated via CPUID 0x1 and 0x4.

> In that case, do you see a need for the vanilla tdh_vp_init() SEAMCALL wrapper?
> 
> The TDX module version we need already supports enum_topology, so the code:
> 	if (modinfo->tdx_features0 & MD_FIELD_ID_FEATURES0_TOPOLOGY_ENUM)
> 		err = tdh_vp_init_apicid(tdx, vcpu_rcx, vcpu->vcpu_id);
> 	else
> 		err = tdh_vp_init(tdx, vcpu_rcx);
> 
> The tdh_vp_init() branch shouldn't be hit.

We cannot know what version of TDX module user might use thus we cannot 
assume enum_topology is always there unless we make it a hard 
requirement in KVM that TDX fails being enabled when

   !(modinfo->tdx_features0 & MD_FIELD_ID_FEATURES0_TOPOLOGY_ENUM)

