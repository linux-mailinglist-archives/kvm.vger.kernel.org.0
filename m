Return-Path: <kvm+bounces-30157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CE179B7757
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 10:22:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F1AA286504
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 09:22:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A9611946C8;
	Thu, 31 Oct 2024 09:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DMWQwnlQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8821BD9ED;
	Thu, 31 Oct 2024 09:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730366533; cv=none; b=hGgZwt0py35a186SZM/c63St8OK2pgMN0Qk+8rCHwbKoxP6xqwxR0qn8ndbGGJZe4atlm9Pbjs30UxMb1/Kco4nBN+VKPPLyujBECqwnntHUvoewdW6fValVy/L7Eih3ZLxM2tZ6CrH94H/3GdGevLrC4iqVv2RCJli7XWA7Fdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730366533; c=relaxed/simple;
	bh=YGnkBVuQIN2Cht2/fLPoFP9QULXzYunea6TBVhxPAZ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RvBsRddVHAO9mKUDtrZfO6pbUJIg8xNBDDIq4mPU0Fe6t53LiKUB1M3ogrdlIQ0fx7oTgSZxV58cvZxAXjbE5aF90MbPG28bgPH6RB7Oh7NFKjp9EYRc5rM/dhGY7BquEPbTloRXnfj4BG/PXcgehF5JodRPunCNGTSIrI/zfdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DMWQwnlQ; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730366532; x=1761902532;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YGnkBVuQIN2Cht2/fLPoFP9QULXzYunea6TBVhxPAZ8=;
  b=DMWQwnlQJ7QRFBZCPL/to+Jh5emtbb/lC+reaxlLZICBRWAew5HE75r4
   MZFTjUpyaaNHivmGaZ8dljM3WkW+1trBcqbXYvbZG0wfiyLMpQRGf/31X
   mc+dEdLndDg3qHjVmw1zzHz2IsT6jobpPcW3FUmzg6iU8+2SXya8RRaCP
   SFbPtKztMaek/dnElP9O+oRa0Et5b9FgC5ZPKKLONL4WmriAvlGa4+B1L
   Bl1ni8ZclH2M35B1IzqI0DvsJIWD9M4tCmzBxANB0JIHiO2fglZVW/qwf
   keY6iv52V1eT4DAtUp6VNjsrbTHcVQYb3FrEBiKWWGFZOMUbM4ZSCMauZ
   w==;
X-CSE-ConnectionGUID: z0HaoX2uR5yikZQdCOQT1A==
X-CSE-MsgGUID: YzRDb7suQNWfgXF0xtHR1A==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="17737764"
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="17737764"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 02:22:11 -0700
X-CSE-ConnectionGUID: iMsz7zTRSaOO7PjEhPYepw==
X-CSE-MsgGUID: MZcSl3FzS6aQSpd7nCJj9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="83377961"
Received: from unknown (HELO [10.238.12.149]) ([10.238.12.149])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 02:22:08 -0700
Message-ID: <fa3d75e8-c459-4b8e-b76a-e4209a23838c@linux.intel.com>
Date: Thu, 31 Oct 2024 17:22:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 16/25] KVM: TDX: Get system-wide info about TDX module
 on initialization
To: Tony Lindgren <tony.lindgren@linux.intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, pbonzini@redhat.com,
 seanjc@google.com, yan.y.zhao@intel.com, isaku.yamahata@gmail.com,
 kai.huang@intel.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 xiaoyao.li@intel.com, reinette.chatre@intel.com,
 Isaku Yamahata <isaku.yamahata@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <20241030190039.77971-17-rick.p.edgecombe@intel.com>
 <88ea52ea-df9f-45d6-9022-db4313c324e2@linux.intel.com>
 <ZyNLYxNlD4WTABvq@tlindgre-MOBL1>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZyNLYxNlD4WTABvq@tlindgre-MOBL1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 10/31/2024 5:18 PM, Tony Lindgren wrote:
> On Thu, Oct 31, 2024 at 05:09:17PM +0800, Binbin Wu wrote:
>>
>>
>> On 10/31/2024 3:00 AM, Rick Edgecombe wrote:
>> [...]
>>> +static u32 tdx_set_guest_phys_addr_bits(const u32 eax, int addr_bits)
>>> +{
>>> +	return (eax & ~GENMASK(23, 16)) | (addr_bits & 0xff) << 16;
>>> +}
>>> +
>>> +#define KVM_TDX_CPUID_NO_SUBLEAF	((__u32)-1)
>>> +
>>> +static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char idx)
>>> +{
>>> +	const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
>>> +
>>> +	entry->function = (u32)td_conf->cpuid_config_leaves[idx];
>>> +	entry->index = td_conf->cpuid_config_leaves[idx] >> 32;
>>> +	entry->eax = (u32)td_conf->cpuid_config_values[idx][0];
>>> +	entry->ebx = td_conf->cpuid_config_values[idx][0] >> 32;
>>> +	entry->ecx = (u32)td_conf->cpuid_config_values[idx][1];
>>> +	entry->edx = td_conf->cpuid_config_values[idx][1] >> 32;
>>> +
>>> +	if (entry->index == KVM_TDX_CPUID_NO_SUBLEAF)
>>> +		entry->index = 0;
>>> +
>>> +	/* Work around missing support on old TDX modules */
>>> +	if (entry->function == 0x80000008)
>>> +		entry->eax = tdx_set_guest_phys_addr_bits(entry->eax, 0xff);
>> Is it necessary to set bit 16~23 to 0xff?
>> It seems that when userspace wants to retrieve the value, the GPAW will
>> be set in tdx_read_cpuid() anyway.
> Leaving it out currently produces:
>
> qemu-system-x86_64: KVM_TDX_INIT_VM failed: Invalid argument
Yes, I forgot that userspace would use the value as the mask to filter cpuid.


>
> Regards,
>
> Tony


