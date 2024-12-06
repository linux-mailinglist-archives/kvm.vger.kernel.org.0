Return-Path: <kvm+bounces-33198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0037F9E6919
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 09:37:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C490F1643D3
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 08:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24ABA1DF742;
	Fri,  6 Dec 2024 08:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EhXcDZUe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369366FBF;
	Fri,  6 Dec 2024 08:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733474244; cv=none; b=u89cDNnrOSpmChUyFJZ+8IaludZJuPh9lhTrxu1OrD4EVTDqy6Si7mUQNn3Xe7IhPO6JD25/mkTteU9IWsCsFpZ19em3uZTmdbo0Hhviu4nJ5bQOsTB05lB7yAs+hOUCD5eR2lK4fGKczvV2AfdozYvDN0LLl6Z78P94kDeErmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733474244; c=relaxed/simple;
	bh=JsbgN2Pws5qzquuulR3Z7RmjwzQ4j1E8bQ/Qd16QjxY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fvQY8fOkahcFXeSm8CbLIdgpXlDlrWiFSw+R6cSXhfQlDje7EDUKBMqnXc+xZ3CtJLJeSPT6lxX6a38/qe5JD8/96NliNN6+4u5VSmT0E0+0EtWnvCCkKA4gdmrUaLIacZ1FGQJ4xiI7sR9tgleBG/8PxS+6R/K6i8xPPanF9F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EhXcDZUe; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733474242; x=1765010242;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JsbgN2Pws5qzquuulR3Z7RmjwzQ4j1E8bQ/Qd16QjxY=;
  b=EhXcDZUexrFQp2pCmWQhO7CTN52C6weKI3PlyPZx6DTYgt3ohWYGh12E
   UpVHPVMguH3Y0bfmlik5XQtdBJF8saTgYLVQnASpjCw7Ek2PhJet0Lcdn
   lBqhHz+ZsaZ9wA7dlGOew8oBMBDtI/BCHJN3CPbbFmgrTDWijQibuG/Z2
   5BH0XQwEnE5Dq2I25NenOLKtn76gjJlUNiWeiRvUf86Jmb+sK5NRHJoUM
   ojHVrhCOSwNYHDkp9IPrZ3pk6vYcX12X9bYVGPkRke0YJ3dRy+ceo9gVf
   xCuCSZ5CIGJutT/vJT73xOdNdh4V3U/Y5yyuFq4m/0G/yopj7n534fDB8
   w==;
X-CSE-ConnectionGUID: FRCWnL2RTxyDCGDlUhZiZQ==
X-CSE-MsgGUID: 2eRCNJxdRBSt2HvvEh3lPQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11277"; a="33736781"
X-IronPort-AV: E=Sophos;i="6.12,212,1728975600"; 
   d="scan'208";a="33736781"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2024 00:37:20 -0800
X-CSE-ConnectionGUID: IeahADspQleSUDPjsj2CwQ==
X-CSE-MsgGUID: 5izyphEaQjS2j7V0UKJIEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,212,1728975600"; 
   d="scan'208";a="94421358"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2024 00:37:17 -0800
Message-ID: <419a166c-a4a8-46ad-a7ed-4b8ec23ca7d4@intel.com>
Date: Fri, 6 Dec 2024 16:37:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/25] x86/virt/tdx: Read essential global metadata for
 KVM
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, pbonzini@redhat.com,
 seanjc@google.com
Cc: yan.y.zhao@intel.com, isaku.yamahata@gmail.com, kai.huang@intel.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 tony.lindgren@linux.intel.com, reinette.chatre@intel.com
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <20241030190039.77971-4-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20241030190039.77971-4-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/2024 3:00 AM, Rick Edgecombe wrote:
> From: Kai Huang <kai.huang@intel.com>
> 
> KVM needs two classes of global metadata to create and run TDX guests:
> 
>   - "TD Control Structures"
>   - "TD Configurability"
> 
> The first class contains the sizes of TDX guest per-VM and per-vCPU
> control structures.  KVM will need to use them to allocate enough space
> for those control structures.
> 
> The second class contains info which reports things like which features
> are configurable to TDX guest etc.  KVM will need to use them to
> properly configure TDX guests.
> 
> Read them for KVM TDX to use.
> 
> The code change is auto-generated by re-running the script in [1] after
> uncommenting the "td_conf" and "td_ctrl" part to regenerate the
> tdx_global_metadata.{hc} and update them to the existing ones in the
> kernel.
> 
>    #python tdx.py global_metadata.json tdx_global_metadata.h \
> 	tdx_global_metadata.c
> 
> The 'global_metadata.json' can be fetched from [2].
> 
> Link: https://lore.kernel.org/kvm/0853b155ec9aac09c594caa60914ed6ea4dc0a71.camel@intel.com/ [1]
> Link: https://cdrdv2.intel.com/v1/dl/getContent/795381 [2]
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> uAPI breakout v2:
>   - New patch
> ---
>   arch/x86/include/asm/tdx_global_metadata.h  | 19 +++++++++
>   arch/x86/virt/vmx/tdx/tdx_global_metadata.c | 46 +++++++++++++++++++++
>   2 files changed, 65 insertions(+)
> 
> diff --git a/arch/x86/include/asm/tdx_global_metadata.h b/arch/x86/include/asm/tdx_global_metadata.h
> index fde370b855f1..206090c9952f 100644
> --- a/arch/x86/include/asm/tdx_global_metadata.h
> +++ b/arch/x86/include/asm/tdx_global_metadata.h
> @@ -32,11 +32,30 @@ struct tdx_sys_info_cmr {
>   	u64 cmr_size[32];
>   };
>   
> +struct tdx_sys_info_td_ctrl {
> +	u16 tdr_base_size;
> +	u16 tdcs_base_size;
> +	u16 tdvps_base_size;
> +};
> +
> +struct tdx_sys_info_td_conf {
> +	u64 attributes_fixed0;
> +	u64 attributes_fixed1;
> +	u64 xfam_fixed0;
> +	u64 xfam_fixed1;
> +	u16 num_cpuid_config;
> +	u16 max_vcpus_per_td;
> +	u64 cpuid_config_leaves[32];
> +	u64 cpuid_config_values[32][2];
> +};
> +
>   struct tdx_sys_info {
>   	struct tdx_sys_info_version version;
>   	struct tdx_sys_info_features features;
>   	struct tdx_sys_info_tdmr tdmr;
>   	struct tdx_sys_info_cmr cmr;
> +	struct tdx_sys_info_td_ctrl td_ctrl;
> +	struct tdx_sys_info_td_conf td_conf;
>   };
>   
>   #endif
> diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
> index 2fe57e084453..44c2b3e079de 100644
> --- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
> +++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
> @@ -76,6 +76,50 @@ static int get_tdx_sys_info_cmr(struct tdx_sys_info_cmr *sysinfo_cmr)
>   	return ret;
>   }
>   
> +static int get_tdx_sys_info_td_ctrl(struct tdx_sys_info_td_ctrl *sysinfo_td_ctrl)
> +{
> +	int ret = 0;
> +	u64 val;
> +
> +	if (!ret && !(ret = read_sys_metadata_field(0x9800000100000000, &val)))
> +		sysinfo_td_ctrl->tdr_base_size = val;
> +	if (!ret && !(ret = read_sys_metadata_field(0x9800000100000100, &val)))
> +		sysinfo_td_ctrl->tdcs_base_size = val;
> +	if (!ret && !(ret = read_sys_metadata_field(0x9800000100000200, &val)))
> +		sysinfo_td_ctrl->tdvps_base_size = val;
> +
> +	return ret;
> +}
> +
> +static int get_tdx_sys_info_td_conf(struct tdx_sys_info_td_conf *sysinfo_td_conf)
> +{
> +	int ret = 0;
> +	u64 val;
> +	int i, j;
> +
> +	if (!ret && !(ret = read_sys_metadata_field(0x1900000300000000, &val)))
> +		sysinfo_td_conf->attributes_fixed0 = val;
> +	if (!ret && !(ret = read_sys_metadata_field(0x1900000300000001, &val)))
> +		sysinfo_td_conf->attributes_fixed1 = val;
> +	if (!ret && !(ret = read_sys_metadata_field(0x1900000300000002, &val)))
> +		sysinfo_td_conf->xfam_fixed0 = val;
> +	if (!ret && !(ret = read_sys_metadata_field(0x1900000300000003, &val)))
> +		sysinfo_td_conf->xfam_fixed1 = val;
> +	if (!ret && !(ret = read_sys_metadata_field(0x9900000100000004, &val)))
> +		sysinfo_td_conf->num_cpuid_config = val;
> +	if (!ret && !(ret = read_sys_metadata_field(0x9900000100000008, &val)))
> +		sysinfo_td_conf->max_vcpus_per_td = val;
> +	for (i = 0; i < sysinfo_td_conf->num_cpuid_config; i++)

It is not safe. We need to check

	sysinfo_td_conf->num_cpuid_config <= 32.

If the TDX module version is not matched with the json file that was 
used to generate the tdx_global_metadata.h, the num_cpuid_config 
reported by the actual TDX module might exceed 32 which causes 
out-of-bound array access.

> +		if (!ret && !(ret = read_sys_metadata_field(0x9900000300000400 + i, &val)))
> +			sysinfo_td_conf->cpuid_config_leaves[i] = val;
> +	for (i = 0; i < sysinfo_td_conf->num_cpuid_config; i++)
> +		for (j = 0; j < 2; j++)
> +			if (!ret && !(ret = read_sys_metadata_field(0x9900000300000500 + i * 2 + j, &val)))
> +				sysinfo_td_conf->cpuid_config_values[i][j] = val;
> +
> +	return ret;
> +}
> +
>   static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
>   {
>   	int ret = 0;
> @@ -84,6 +128,8 @@ static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
>   	ret = ret ?: get_tdx_sys_info_features(&sysinfo->features);
>   	ret = ret ?: get_tdx_sys_info_tdmr(&sysinfo->tdmr);
>   	ret = ret ?: get_tdx_sys_info_cmr(&sysinfo->cmr);
> +	ret = ret ?: get_tdx_sys_info_td_ctrl(&sysinfo->td_ctrl);
> +	ret = ret ?: get_tdx_sys_info_td_conf(&sysinfo->td_conf);
>   
>   	return ret;
>   }


