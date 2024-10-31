Return-Path: <kvm+bounces-30154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53B8B9B7719
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 10:09:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17CA228541C
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 09:09:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBAD519343F;
	Thu, 31 Oct 2024 09:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IyOmfLW1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE4415D1;
	Thu, 31 Oct 2024 09:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730365765; cv=none; b=IFIXzpMtFJDj5eAHEYjS1mS+fdpBUNRTsAxDQcmvAeBwooodVMulN2toJIavPv3nPPdDQoiylNSxXr9eisU0fLT/pBWhsjAcnBog19J6OVkFg73AE70jHJtZMV7y8a2Tu23uVK0YHAwBIRs/2Xkk/EBenjm37eZglosPHh5/7fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730365765; c=relaxed/simple;
	bh=Kgf3BSsfk1NmCr+Am2gcyywRX+BwRXWH+SDDKnW/JrU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jIILyGFUln4i1UNDclC7IXn9G5gttl2YZ5x0iarJhL+xbLebsQr8qyZhbwE2HObnum4BryCMhDSVbq24TU13uugiV0rqRqEo5CyjuSrBELX6fMUJ3qPV3ZTq+aYs7WmU0o7SNFDS8MeWmo/Zst7cT1W2nxCMjJcUx5Zxu0++DFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IyOmfLW1; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730365764; x=1761901764;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Kgf3BSsfk1NmCr+Am2gcyywRX+BwRXWH+SDDKnW/JrU=;
  b=IyOmfLW1wiPGu+E43TpqhAtKoqhiBqPUQmBsdbTbut2fz1MpJvJPQ36y
   aabss3myjScXX/K4wxelVbYSXzbIU9YOz6dMPYQfYeHH94gXZcazzPh7Y
   QVQ2ICoyXAgJYSepW+AsW2iNgky4Yra+0H5AvnspyBVEIAj6tX9i+y+1C
   oEAU9GkOTSR2SjLUA31VRy6ZI0wW/p1Yi8LGQy6HlvFBr/p9OmflHNbLs
   lDp9atWF2KCznHx41BLKCw5URfjWDW0ESDrngOjmjMKhlDgnJsQuY6NVK
   7dv5s4RCS7QuxoC+zNiMBf0XyqsqWHQb9BzMGPmPplb6c+UMeQhbmBQt+
   g==;
X-CSE-ConnectionGUID: nK+m/TByTlibDlOhN+YUjw==
X-CSE-MsgGUID: FNsT8Q2PSu6UT9Z84JQVHw==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="32932267"
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="32932267"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 02:09:23 -0700
X-CSE-ConnectionGUID: 26OoygqFQ4eulXIQKu9YoA==
X-CSE-MsgGUID: WPpWlX9rTNiWmCHUfh0JFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="82733213"
Received: from unknown (HELO [10.238.12.149]) ([10.238.12.149])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 02:09:20 -0700
Message-ID: <88ea52ea-df9f-45d6-9022-db4313c324e2@linux.intel.com>
Date: Thu, 31 Oct 2024 17:09:17 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 16/25] KVM: TDX: Get system-wide info about TDX module
 on initialization
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, pbonzini@redhat.com,
 seanjc@google.com
Cc: yan.y.zhao@intel.com, isaku.yamahata@gmail.com, kai.huang@intel.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
 reinette.chatre@intel.com, Isaku Yamahata <isaku.yamahata@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <20241030190039.77971-17-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20241030190039.77971-17-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 10/31/2024 3:00 AM, Rick Edgecombe wrote:
[...]
> +static u32 tdx_set_guest_phys_addr_bits(const u32 eax, int addr_bits)
> +{
> +	return (eax & ~GENMASK(23, 16)) | (addr_bits & 0xff) << 16;
> +}
> +
> +#define KVM_TDX_CPUID_NO_SUBLEAF	((__u32)-1)
> +
> +static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char idx)
> +{
> +	const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
> +
> +	entry->function = (u32)td_conf->cpuid_config_leaves[idx];
> +	entry->index = td_conf->cpuid_config_leaves[idx] >> 32;
> +	entry->eax = (u32)td_conf->cpuid_config_values[idx][0];
> +	entry->ebx = td_conf->cpuid_config_values[idx][0] >> 32;
> +	entry->ecx = (u32)td_conf->cpuid_config_values[idx][1];
> +	entry->edx = td_conf->cpuid_config_values[idx][1] >> 32;
> +
> +	if (entry->index == KVM_TDX_CPUID_NO_SUBLEAF)
> +		entry->index = 0;
> +
> +	/* Work around missing support on old TDX modules */
> +	if (entry->function == 0x80000008)
> +		entry->eax = tdx_set_guest_phys_addr_bits(entry->eax, 0xff);
Is it necessary to set bit 16~23 to 0xff?
It seems that when userspace wants to retrieve the value, the GPAW will
be set in tdx_read_cpuid() anyway.

> +}
> +
>
[...]

