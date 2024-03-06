Return-Path: <kvm+bounces-11208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B53DE8742CD
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 23:35:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D91F41C21B35
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 22:35:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D49E01C2A0;
	Wed,  6 Mar 2024 22:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hEleNG2C"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7A11BDCB;
	Wed,  6 Mar 2024 22:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709764515; cv=fail; b=a4sg2jFildtCxHxffYMK+b15ALqX9xj6nByS65UFtjv0yDEXWzbfHOAb5us3mCHogKhBSV6zbBVlaiZzE7CPBte9eU0I+QUYY5fIk+s5aERdgd1BM4bOviv2+2MVtj4gupOkC5ayKe34BRXx4QwG/Q5jRkl56z0kD63atQ4m+NQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709764515; c=relaxed/simple;
	bh=FKFqU/9j84YcZH5iniwfAARO1aZ+3of6vdZhT7yGvv0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I6eJyZECoVya40uWZgkabxVHo9v2kGhaNHBEuGIgsEw7k8dIqfTmRM1fvisTKUMWt5v4w55RX0MW5R+DuTLf0gWzWsaF8LmHP4peLiJsou7nc6fR10QmChEV2G/G7CfNDY2BxfULoKMWKcGOy1DzfQze4s+4tZsvfi82vbOexAA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hEleNG2C; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709764513; x=1741300513;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FKFqU/9j84YcZH5iniwfAARO1aZ+3of6vdZhT7yGvv0=;
  b=hEleNG2CVnWa7fhsTnaJXUlamplf7dZyGQBPv4x/l9TusOU7AFf29Aki
   oyMWRaXk7nupQswEML4imchbT6/AGooWIK5ZnKque8Eb6nysffSpMckbR
   pjb+/ct417i3033lqq3mQx/+eOdATXqUMu1/VZ8LPgtYecZ3vWoACgfb8
   I5G/aXk3QP4wLG8Up7pJUaTJJxVNnOaNmAV3IhQTS/rlhxr//dxdFw/lV
   IZdalFo2igbyFpwOpx3XUxAYIS5/A/DwyjLf8hSwnSt3cHXrtgFjLFWwo
   L4a+iUJqoLlzSYdoU5EpNJXlZvnio+BeJzO64//PwwWQs5HU+4d/D+mIr
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="8170716"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="8170716"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 14:35:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="9989628"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2024 14:35:12 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 14:35:11 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Mar 2024 14:35:11 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Mar 2024 14:35:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=al6OG1aUvDkePaG4eF19g5yZbkcMe+R1pPxAbkgLw9BtgRGNZeBcbEGd1T6IV0xhS00QXI6HQWKechdIc+6yjwuyt3LKjuiOBagUP9aZlMImG87XPncei4vhDJII4AY2l3Rv9Wk5oSMMJQ1K++kuZRuYu64aPRwKJ3AyQR3nTVsd9bzbIUMUJerjvMxhNV56PGuVo8W9++hUyPlTbzxp+5gSAUxeIMu7PbNQndyHkQ4Sinr/f9+PMOY+BElHU9KjPpKSh9cWlOPNAzEZaYQKDHtz1bG3ajuBylBU05nLMZnTrUZ2F7keMXc69sT2oOWCuU9ZYmRfGZ+j5mAoZcVAcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=48v7yDcmfFZN7/DDrGb74DzqczuOxWxz0LZHXNry77s=;
 b=jTahYtsxUdImuNWDE2WDgAqZA+93KBz5RS9Kxn9oufxTNg2o/D7g9oP+vQsXm52YCU+JfhHeEwst5LxMKX1G8xaZAiT5/vP3eHL979bT2hTxIaXNIEKvts8c3cOriWMxSfdoxjUA6rAzvoIjrk9d/jYDOxax90ZnkXOfqmdM0ZSf4uJLGjIArA9LnZbvgOF9e5WBGwAgLgVmPIbsUrVBKeAwq6dxr6aALTgSoT9PbGnpORMe5Igy6hcUHDDqPftkny19MHHgeEiy5qx7oLeBXvamCv40+0FanPS95xYAqOHpNXjZKug5+sGPKAIvFmW72warkh29bhMaBeOir4G7Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB6563.namprd11.prod.outlook.com (2603:10b6:510:1c2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.23; Wed, 6 Mar
 2024 22:35:09 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7362.019; Wed, 6 Mar 2024
 22:35:09 +0000
Message-ID: <0a05d5ec-5352-4bab-96ae-2fa35235477c@intel.com>
Date: Thu, 7 Mar 2024 11:35:00 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/16] KVM: x86/mmu: Explicitly disallow private accesses
 to emulated MMIO
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yan Zhao
	<yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, "Michael
 Roth" <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, Chao
 Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, David
 Matlack <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-12-seanjc@google.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240228024147.41573-12-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0299.namprd03.prod.outlook.com
 (2603:10b6:303:b5::34) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH8PR11MB6563:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e04aa84-bcfb-498e-4c1f-08dc3e2dadd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YCCGipN/Yhk5muoa3sJJCIoyu1CSUp5ml0PHRhjP6TD10rR041HLrNfZSBcYaNytELyxdw3KBgKljYRuKD4UOZfvGQyaB91SSYocCAHRte52uG9pbS/1r6/NyLWiHL8bcXlbdsd5dpARSFvYNoEai9jKe5B7Lm64W/gnPYPUtNqU5L6ZcRHPP9+QergP0nDIaMx8s6NkGsof6jeCvo6zTxwzk75wx7J6kr0XVWnUMLju+qM21Ih/2iRbrsNm8Qqds3cr8Wu+TRip82smGdOQO/La7t9fg7PyWsmnGoC0M9ZqPv8cThft+/99JnVEVlfJQ0OTlU739DIiw608Vpe9Qr+f6xl4qUF3Yctf1dWp38uT63cVig4tebNcC/gKPdv8f3U9eSk6XYcH0GL6r86O/qv7URtZrVMRDsrwm+WiFhOpvReo0FljOMLhzLBfiTrPoBHlvwURKGnAGDJLTXn6puIPMip8DBPzlquPpn3lxhIULRQ3HmnWk/hglG1kzxiHJu7SlQc6N0x6tU0VKlCJXgxJBWD7YqbJK899sqExflhg+g1bWVjDf7fHITb9/LMPyBEfJWJNw64ygLGbmpqGCJ3c5YyFrvv6bv8+i/0XUx6OHPZsLADV7CgRng/Kmv1ryCbClo1YF1xR7Cye5tGmdfmoAbjM6xkT21YAGbXYKak=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NjVNL3owdmlnaUZodkFGZ1BSNVpzQ1B6eHZyK2JTWG85d0lRdHNNRGRZVlYx?=
 =?utf-8?B?Skg4NDMxNm04OEt0VmswVlh3VWtWYlh2TmsxMldCMVZnc2V1Q0tvMmFGVkds?=
 =?utf-8?B?VDExU3ptdXVtQzVUUVYzVU5FVXRLWG5iMDlWTEhzNG5oSkhETUFaVzVSMGRi?=
 =?utf-8?B?cFI4NldiVlZGVXRlK291T0wvb2UvMGozaXV0anRqaElGL2ROSitJMCtrWnJB?=
 =?utf-8?B?TUFPOWN0YmkyejByQkQ4aXBlVHhHaGxuSDltK1ViWDFkZVlTSnZvU3BHZ0Vh?=
 =?utf-8?B?ZmsrR253UTN6a2FNVWVCT0s5NW0vV1IzTVkwejN0R1pSSGJmNVJCS3BJd0tk?=
 =?utf-8?B?alhUZStQZExESEtUUkNKVEl3dkt5WVB4RmpaMjJkcXh4NDlocjhqSWlMZ2hi?=
 =?utf-8?B?ckdOSlU2cGIvZm5wRjlDaWZwbk1FdHJtbW1RSnc3WUpUN2g1NWUvWVZuNGI0?=
 =?utf-8?B?UVNaSnZFV2JkNGExa1ZGbUNpSnJLbkZ2VkhqUGdoTmhsd1FiTkl6SkdkT1lG?=
 =?utf-8?B?WXc2blBlWWJER0JmYW8zUlMzVC9JQWJ3TDkvZEc2S1ltVFBUeWJadmdSb0Fj?=
 =?utf-8?B?K3VqU3BDTWFqb2VyUGt3TlNFZ2EzOGNsM2VueXByd1dHQlQzeEhxSWJ6eFY3?=
 =?utf-8?B?RFdNZnZ0aElnaHMvQ2U5TlZFaldRVzZRSnFwWXVXUnFwTlVUdHgrMm1zVkd6?=
 =?utf-8?B?M0Fua2xQSklVUHdKTWkwVWhQaU9SOEtuVU01bzFaRlNaV3AyZ1ZKazZ3U3J0?=
 =?utf-8?B?WHRFOUJhM1Jqdk92V1JpUDdQRkdtZDZjQ1IyYWJER3prZFlnbW5UUVZKUmtr?=
 =?utf-8?B?cGl2VHRVQlkyc1NVYjNVSlM1R1AycU84cVRoSHlMM2tJZUhadEEvTVhWRURk?=
 =?utf-8?B?eFFleXFUNVJLS3dKUHczWVErMXhKbnFreEh2UHpIcGZoWUlXVU1qbjQ1MkxK?=
 =?utf-8?B?SW9DZUJka1dwclFybGZjT0NpTk5KYitscVArUUhWMWlqaDFGTDJmT0RURysy?=
 =?utf-8?B?RGlxL1piQ2I4eTgrWVVYQWRGaGhlNUY5aWZFc0QzejJCSER5dEFTdnRvMkUx?=
 =?utf-8?B?aTFsajBVSWJybHIrR3hWZ0FYSFlBeGdPRk41OGFTUG5RMk4rOERaSUFLN1BM?=
 =?utf-8?B?WHdFT0RaUXpQOFBiUnd2UFUzNjJzRW9PN1NMemFaWGtQK3VkaEliZ0VCN1Y1?=
 =?utf-8?B?Wk0yQ09ncDVrYmFnZExhRk55OXNCL0Ixa3lmTG84ZHg0VkhMM0dLbVlaV2JN?=
 =?utf-8?B?U3FMczJsYzBwcTN5cDZKanNHM3N6QkZXMHN6amtTbXl6dG1Uc3lUQ0xCYTBv?=
 =?utf-8?B?Y3lWNkxpanJuYUFiM1NWUFJ2aUc1L3NSQTBIOWlOb1BQMWJkb0tmSnJULzFy?=
 =?utf-8?B?K24zOEJFZlVkZVkyaXVMYmhKQldUWWUwU1h1TW51WUUvYmtBUERlaXNrRUhU?=
 =?utf-8?B?WThPZ3RCYXNYMVMrYTV4aC9EeEpjMkhZd2RCQWU5UG5tL01hR3F5Nnl6aEhR?=
 =?utf-8?B?czhhYUlEQTdmTmRxOXduQWEyTkhqT2YwVjdzTmVNUEhFcVJXcmNHamVKSWgw?=
 =?utf-8?B?am9SeGg5aTVLc3ZWbnQyRVdrZTVEMlN6M1B3YUpCZlNHSFR5Z2lGYXl4ZDM2?=
 =?utf-8?B?V1k5TWVVS2lCN0FXWjBUbkFQLytmd0ZiWlJVaDQyRVdkSElvWU5vQ0lvUVJy?=
 =?utf-8?B?SFNKUWlaSFR0bEhkTUhGZFJSc0pSL2xLSUhFR3R1QXYwSW1Bc0ZsWmorc1Ar?=
 =?utf-8?B?dmk3OERLRnpkTWY2OEdPQmNFRDRGbFVpK0JUdWNQSHhwNG95cU96dWI5UVpq?=
 =?utf-8?B?aUcwdjVid1gveWhXKzRwNGxzdExZdHVkWWpjUU9CcmljdDRDbThKVERaR0F6?=
 =?utf-8?B?akpacDh3d2VOZllzSlpRMTdGT1crem50MW1SRE81c0VqcHFLM2dXOWpIQUVH?=
 =?utf-8?B?VjJSeWFEdGxRTHF4VURRYitUZGpMcTJXWXZvb3RoNnRKenJzd2hnUlJtRnpG?=
 =?utf-8?B?MUN2NWlXdG4waEh3dWZNWnJwTDhCd1Yza2RRMDBmWFRUK3UxK1dnWDlFcERw?=
 =?utf-8?B?cis4UU10NVBmaUVYNmFlMjdHR2EyeHZ0NC9sYndWTzJudnRnU2xaRlR3S1RB?=
 =?utf-8?Q?pcfnYimGCk3PhVjDspkbtd1GI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e04aa84-bcfb-498e-4c1f-08dc3e2dadd0
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2024 22:35:09.2119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6TuRVMzVufHxOQTbZX59xzSc9gH7Cj+ye7boc6xKPErs/dav23cLWlVevHAQlLYZPXfrVx75jpQTWUVfpDwFBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6563
X-OriginatorOrg: intel.com



On 28/02/2024 3:41 pm, Sean Christopherson wrote:
> Explicitly detect and disallow private accesses to emulated MMIO in
> kvm_handle_noslot_fault() instead of relying on kvm_faultin_pfn_private()
> to perform the check.  This will allow the page fault path to go straight
> to kvm_handle_noslot_fault() without bouncing through __kvm_faultin_pfn().
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5c8caab64ba2..ebdb3fcce3dc 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3314,6 +3314,11 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
>   {
>   	gva_t gva = fault->is_tdp ? 0 : fault->addr;
>   
> +	if (fault->is_private) {
> +		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> +		return -EFAULT;
> +	}
> +

As mentioned in another reply in this series, unless I am mistaken, for 
TDX guest the _first_ MMIO access would still cause EPT violation with 
MMIO GFN being private.

Returning to userspace cannot really help here because the MMIO mapping 
is inside the guest.

I am hoping I am missing something here?

