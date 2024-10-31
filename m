Return-Path: <kvm+bounces-30158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E1E479B775A
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 10:24:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FABB1C22AE5
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 09:24:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C7371946C8;
	Thu, 31 Oct 2024 09:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cE5XeWDt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CFE1BD9ED;
	Thu, 31 Oct 2024 09:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730366647; cv=none; b=hFTbreDJ93j47XNFCwyuxmvrHPttDH2GfgaK1wstgHJPYyGpmFTs5yXpWnPkPt3a3eZK2iPEgfsHbFMGyQe5wkD7lN7xrfgIp79jdvc5NYgo041pPqaFFoY0DhBq45QvIj+Y8XK95ol3cFaXAuGKOWVI5Y8gveG9ub3RHbWDaSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730366647; c=relaxed/simple;
	bh=nWEBW4vG5RFt9y/V/HxLxjTkrY1/5Kav632LVfcQ+lM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ilN9k50JuO920YXRqpYq8Wt/cwxaYOeVSA+7VjCg0DQrjZA8bNFhU4rHOjhnMQfll2kd92B+hXJHa30F2CaIWjLK2rooRvhEDA4rtKZGMji3eCer4tHVTgP5qBKuwPPzVTI7MqSKGDKM8CmbPdf0B+Mchy2v11k7XUgDukITL1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cE5XeWDt; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730366645; x=1761902645;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nWEBW4vG5RFt9y/V/HxLxjTkrY1/5Kav632LVfcQ+lM=;
  b=cE5XeWDts5qr1sSXCPQwfXsJxVCRxLzBtoDjIEMUM4QWQ3bG4UZiUGo6
   UQQXogsqSLOPShtCLCifRNeJYAYlJ4xbcjOA3y93g3lLRjb8K9/pXkeae
   +m4nUN/x93wPtMihPqweWi1qAxI2EQGRRleFRBC7HpJcbSQj/92Ysg/w7
   SEaeUtm+EXRIC+Ptk2RwnEGldcnh7z1s92r8hgsrdL9C7amtVmg7HxYvT
   3RgHYLhoCTP96SbZ9+IGh7oIPB7gPRg6WDxZoS6Ili5qUH9mJbrO7vFvT
   IrpDfCNe0fdje84eHzzAJ2+MyvnjtgaUxoRXz+EYi+33bBux3p9iuAIKh
   g==;
X-CSE-ConnectionGUID: hYNvuuflRIyGSqv7wOjpzw==
X-CSE-MsgGUID: dZnjQvLqSDmjByvCjjhCVw==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="47572093"
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="47572093"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 02:24:04 -0700
X-CSE-ConnectionGUID: NNtXuiCNT8CJybqP5jFu+w==
X-CSE-MsgGUID: rqVLvLnfQzaJ8YTbk1jnmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="87363647"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.227.172]) ([10.124.227.172])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 02:24:01 -0700
Message-ID: <bb60b05d-5ccc-49ab-9a0c-a7f87b0c827c@intel.com>
Date: Thu, 31 Oct 2024 17:23:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 16/25] KVM: TDX: Get system-wide info about TDX module
 on initialization
To: Binbin Wu <binbin.wu@linux.intel.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, pbonzini@redhat.com,
 seanjc@google.com
Cc: yan.y.zhao@intel.com, isaku.yamahata@gmail.com, kai.huang@intel.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 tony.lindgren@linux.intel.com, reinette.chatre@intel.com,
 Isaku Yamahata <isaku.yamahata@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <20241030190039.77971-17-rick.p.edgecombe@intel.com>
 <88ea52ea-df9f-45d6-9022-db4313c324e2@linux.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <88ea52ea-df9f-45d6-9022-db4313c324e2@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/31/2024 5:09 PM, Binbin Wu wrote:
> 
> 
> 
> On 10/31/2024 3:00 AM, Rick Edgecombe wrote:
> [...]
>> +static u32 tdx_set_guest_phys_addr_bits(const u32 eax, int addr_bits)
>> +{
>> +    return (eax & ~GENMASK(23, 16)) | (addr_bits & 0xff) << 16;
>> +}
>> +
>> +#define KVM_TDX_CPUID_NO_SUBLEAF    ((__u32)-1)
>> +
>> +static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, 
>> unsigned char idx)
>> +{
>> +    const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
>> +
>> +    entry->function = (u32)td_conf->cpuid_config_leaves[idx];
>> +    entry->index = td_conf->cpuid_config_leaves[idx] >> 32;
>> +    entry->eax = (u32)td_conf->cpuid_config_values[idx][0];
>> +    entry->ebx = td_conf->cpuid_config_values[idx][0] >> 32;
>> +    entry->ecx = (u32)td_conf->cpuid_config_values[idx][1];
>> +    entry->edx = td_conf->cpuid_config_values[idx][1] >> 32;
>> +
>> +    if (entry->index == KVM_TDX_CPUID_NO_SUBLEAF)
>> +        entry->index = 0;
>> +
>> +    /* Work around missing support on old TDX modules */
>> +    if (entry->function == 0x80000008)
>> +        entry->eax = tdx_set_guest_phys_addr_bits(entry->eax, 0xff);
> Is it necessary to set bit 16~23 to 0xff?
> It seems that when userspace wants to retrieve the value, the GPAW will
> be set in tdx_read_cpuid() anyway.

here it is to initialize the configurable CPUID bits that get reported 
to userspace. Though TDX module doesn't allow them to be set in TD_PARAM 
for KVM_TDX_INIT_VM, they get set to 0xff because KVM reuse these bits 
EBX[23:16] as the interface for userspace to configure GPAW of TD guest 
(implemented in setup_tdparams_eptp_controls() in patch 19). That's why 
they need to be set as all-1 to allow userspace to configure.

And the comment above it is wrong and vague. we need to change it to 
something like

	/*
          * Though TDX module doesn't allow the configuration of guest
          * phys addr bits (EBX[23:16]), KVM uses it as the interface for
          * userspace to configure the GPAW. So need to report these bits
          * as configurable to userspace.
          */
>> +}
>> +
>>
> [...]


