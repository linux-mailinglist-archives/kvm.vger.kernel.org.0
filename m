Return-Path: <kvm+bounces-14646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C58558A5114
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 15:23:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57AAA1F21C68
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 13:23:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A9E612C48B;
	Mon, 15 Apr 2024 13:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="atVGsh1g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9739F12BF30;
	Mon, 15 Apr 2024 13:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713186478; cv=fail; b=H3F5NcE1JXC6aOO9ug2YyC4ndMETW9qlUqZHNjGZ29tA3JgZvNrAP5a+EpC07ZP2L9PvX47lcM7qPbd5NOoXe4zAXzjo+B1R7gSKCXDXupgNa1Ns+W3uv3NKigE+IJseqhHLhZCY8mYqVXotECTN4LAVMbufjrnayjOLJ6C+JkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713186478; c=relaxed/simple;
	bh=B7gW3qyzvPHAZaj9wd9f/oE+9SolP81kCxDW5n07JgA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=q3o/djyz4MybwWVMa3zPRI/0am09j+wmJz5JkQv/lXAM9YWVfh9p2Nh1ZCflPHEjvKFcJAmatAXL+/k5tj/HOZpEAOCZqRcLE5B6Gzn1hAfgzZOh3Y2Q+85Zwk2tx0D/7+MGssAdYn0kdv3s8dvleeGZpU1QCpVf5t6V8f3FoFc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=atVGsh1g; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713186476; x=1744722476;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=B7gW3qyzvPHAZaj9wd9f/oE+9SolP81kCxDW5n07JgA=;
  b=atVGsh1g9qPJ9lYMcFoZKn+Hac5JWOY8xE5t0dbHVdu+sE6dHkOs/3DK
   RXHVbIkmIqAmCDsf5OlzLIsPhXJnG8IV2QnHdTBaAYxiQZvnyGgAHaqHX
   FbniluZhcj6HI5s5NA8SW8Ia0+o0Vl3bZuewA1bvxQL1N5a+km0O4p6n/
   3wIcNwcx1T6/94mQmjH9YTDl7TTIveJNKckxzgJYx9EnvLtpt3W1IlOSH
   38L3eL/s4i39lG/X9JYduAHWRSIBKIHbknuIE4rPPHXH3FAP1kTZwOG8x
   J0XSvP/mwjGvg5/PuvDFU7+IotKse9/iUBnBwpWn2sCAEKL/7qiZYoOWk
   g==;
X-CSE-ConnectionGUID: zaObGTXoTd695QrqzjnMNw==
X-CSE-MsgGUID: W31gPHCWTrGudVJXQvn4rg==
X-IronPort-AV: E=McAfee;i="6600,9927,11044"; a="9125374"
X-IronPort-AV: E=Sophos;i="6.07,203,1708416000"; 
   d="scan'208";a="9125374"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 06:07:55 -0700
X-CSE-ConnectionGUID: PGlr5TdSR/6XgPESgYZUAw==
X-CSE-MsgGUID: HFjBWRcPRz+tS4b65xo8PA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,203,1708416000"; 
   d="scan'208";a="21816318"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Apr 2024 06:07:56 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Apr 2024 06:07:55 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Apr 2024 06:07:54 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 15 Apr 2024 06:07:54 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 15 Apr 2024 06:07:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JnDD8bVDs/kuUW8gYZf8rXNRPT9eryTz9c72OWowsCm9QopKc3sUU2veS5fPXh813mpb+qs/fw4djfkRoiwLQxDQOKxHUG1pI9TSiF1PytAeb0IEoVWU2nFkzkV7JlbMv+d+hWmhexIDtqPbdopC3BiuGzrcUKeQH8e15ZLvhNEYKwbfCldpr33CzCmlqndj2LM7dhJPKrtxUlYNYFOd+3vT66iO3BZxPciNM2SWURcuDxCbJqZgeVG4L1B4VGkqdE3TU06EiyqZRRnY83Tdsv2VV4dpY9d7swNSpsGrvzt5brKDQtgaaV8KcKx063TS+0r2TiOJuUnPF4I8DqbMlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ru0U0p2DZn+Hix6wGqYktH+sTGYjuzWDJhlTXysISyg=;
 b=miucZCCjssxJAyZ2OoYZOAbVSB0usKdIYOaJnLS7xW3hdrRMMqfN1xvs1CgchskZ5vWhQGIj3wxPuP5tD7VUHDbv8bXRL/p8ZVodI7T++95C97AY45LQtFZ1+ORXfX/ebrdrD8eS0p8JrLdoUDk50in6/NwqWNUFb1SKJxT2Wzqw6LhsVf5tDZlD3VVJ627bByXUrSOi35w7EW3vqovefM5fdZKbC5yIuqZr7NS2ZKII9+PiuNbqxnt69NJT5UcRtVXHUB7kZso5qilFb84KV2OuSSBno8EYcKPR7H2Qq8GBdpVWow8jZSmT+MjlKm6HpxHUJX+WtQo+IFZfKwYF2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB6834.namprd11.prod.outlook.com (2603:10b6:510:1ed::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Mon, 15 Apr
 2024 13:07:52 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7452.041; Mon, 15 Apr 2024
 13:07:52 +0000
Date: Mon, 15 Apr 2024 21:07:45 +0800
From: Chao Gao <chao.gao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Isaku Yamahata
	<isaku.yamahata@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH 04/10] KVM: x86/mmu: Add Suppress VE bit to EPT
 shadow_mmio_mask/shadow_present_mask
Message-ID: <Zh0mocWeGCGWmBvA@chao-email>
References: <20240412173532.3481264-1-pbonzini@redhat.com>
 <20240412173532.3481264-5-pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240412173532.3481264-5-pbonzini@redhat.com>
X-ClientProxiedBy: SGXP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::28)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB6834:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dec6ecd-a982-4855-e76f-08dc5d4d0ef2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2hroI36lm5SUewjtx/XxwkZHSXzHuT42bQDcSnp8a3/eBDpcdcu7oGd6Mmdk9fycgypuzqC5y1DF382G2dH6jha1XVtlX9yqNKDQRDRuv9kYCldXZuXAVAcZXF61DjXw1yCpbRnIXy1lHUlmbj6JL2DjrLTTREyRFz6DHrMYQF6YA0vPHbCPB6lN8Gt7KM3ofLd4rC6T783hembz9Ld2mkATdfbfArP7yd1EfJIZ/xWPS0b1hKxyNmfaFmnvb3eQztqV+IOTAj4T4cXClrlEvFdsdUXH6jG8Jq87BHoP1g8g5dYFhhAaTU7XAgfpCjVv2h90sEyXF2uEeZ4ILD0YwoIXxUVqoWXO1sPiPsApx7POnwrbGsFDdFmozqoZQA1DZa+4/2C9L3cVbwEyUJ9WvHEMsIvHwWGE3LU5zskGWr2lB/JDgIJrn6Hau+p7waYRHVmoxIUPAUNgKfOKtiaa7EiqOO3IhZknk1ck6uHtZJpPDCt8gui/yjTpSaggK5zqCOdkLZ1qkbECQqN5RzbzEbXjYDtpAvAk84XbwG93O/9dOMVJvTJ74m9iD0UZ7WlxtYK2EZGmAOq63+nHSmisEZdPXb8HoFSfTeX6xCFasflttveI/uEU8VSPDGyBPyuXJHfIKsdpWw40TpLgyaMGB7CEvE4neRfJlcvasj5yuzk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ERVqwg0eIfiRU1PfEbChT9zzHHNTY53M2aKzyWm2jOh4aRWsglhqFlTEt51t?=
 =?us-ascii?Q?F00n/UpSSJ8ycu6am3pCI30emGVQ2xiweG7cjIRFynWz33wGMvpGSa6QcieY?=
 =?us-ascii?Q?A/q/pbhRVqbtUKyUe4LvegKCHGUlz3I0dISfUDbFoCHbFveR16zEJWz+79nD?=
 =?us-ascii?Q?7PJO7UY7ayv24AuUAh+Ja+xKckihzAhVU3a8SHREg5XlmvBus+Sojb37ozJu?=
 =?us-ascii?Q?hFqBGqFHTonv63XFThOGLS9HygIJY46sGgneWaF1zc0XPFA5bBoByV4N/SGs?=
 =?us-ascii?Q?MDtUBzzpsDjLZmxYV2WXt4Mp9nDGXlTC2axGaQxFHk9Xzfjqso6/LNvA0qEd?=
 =?us-ascii?Q?7+gQNxwbfwv8rrzfsWvYlw3jLBDhpcEPnQ5HFTA+vw6xEiZN4K4We35+jEFk?=
 =?us-ascii?Q?y9w3N6cCr/AaTT+JL8Pbs5jrPNqgggk3Bg0yQ7gETBeHt9GUmEh7RWJpjGYH?=
 =?us-ascii?Q?WRnWf2gtPvC2L74YLzQDF09HLCTvvtTQ8UmIM1DBafyStKB9IVXoLPeT5OSA?=
 =?us-ascii?Q?1YgC+mA006AcORZ7NJsr6w6sXJJCrhmBO2N9G0V0TLG/Wm5by9p0IL5wtwQe?=
 =?us-ascii?Q?K3cVy67pqBGJgJRqwIIA4RRF4kggtQ3I6oJ+IeF1u14kbD/WIu6/YwxKyYAu?=
 =?us-ascii?Q?GM+wFsRq5GgCx39tiW/GMGWrk5vdW+fjJ2DVOSRFI6bEmKPpvG5D+wtP19Q9?=
 =?us-ascii?Q?ySdllT+g41fSuOvE5G0NHiVhhb1VlYbd+dhJWAgN+mIILyn2Tkqco1ZMYDfo?=
 =?us-ascii?Q?ReAhPsI1IdHDp4NvvsYioNUaDkhtje1Erpt6pW0m/0BNlvEXsEDWV/zEbsEe?=
 =?us-ascii?Q?zcjaf7mX2MIpoIAJzkneb521+HEcTX1wshFKExPbdZ03igiyyirY5vxpR3pc?=
 =?us-ascii?Q?ru6Ht1Ui0ZCmK8CYzKPhynLeZAcrHsZQNnH+Q0i5vYIaImaN8qfDv5aYY+Id?=
 =?us-ascii?Q?iN760dS2yM0N0yedQMBVP5zO+jFLXth/d6UhKKtxzrByxw1fYSdNlTsivM1Z?=
 =?us-ascii?Q?EJGPGD7zVqHY3DsLPvSFIR1rBc9hWj/+Mrb3limFgNP2AwHkXJRMCbXJvAH5?=
 =?us-ascii?Q?R8M2zb9PTm7Zoo5fCL5YdvAaIUKDmWgWMCRwSr+IMFkH8OgMrcw2ofoL7e+V?=
 =?us-ascii?Q?WTUY17kYe4WVOlmbqJTELWSpZZAHHR/YDdFl6LMgaAttZ+vcnA/+1cWMBV8k?=
 =?us-ascii?Q?es28fweYrMpcJpiNa6XBdahmeMbF4nGl9m3il7600M4JXdsqBh4oIlBHLhO6?=
 =?us-ascii?Q?CijzEyDiw/TyuWuS12iVxm26f5AAy9R4fhI2HIqX5QTNRy79qGxIxzv478kR?=
 =?us-ascii?Q?l3tnCvC5saFB3vBGslwoxnu2/1T8pOEf1CmENDRhuJeyIfp0bOfEjgyH+jiM?=
 =?us-ascii?Q?GydL3ImiqqXjhdIIg3LVn6YHNpMLcBFp//3nV45Rf8FAvAHQTd/vvjRkFKiN?=
 =?us-ascii?Q?rzdgOOT0YAwRVr0rQqvoy+grz+gqxWA3ub7Mg/WGD8EYIH9YxriSQi0+zYmV?=
 =?us-ascii?Q?HwwFRCsa78MLSWnI+UXCdLMbd3Us/SP08g3mgksy9WCRxW/mO0RGT2M62dzv?=
 =?us-ascii?Q?El9yuTZZioOTf6xZSZrlHxyRrNwUgxVW8NQ+BVoO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dec6ecd-a982-4855-e76f-08dc5d4d0ef2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2024 13:07:52.5808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bf3R1kzWWh3mqqoGgoZv3SymipPHBr5YQCfvv+LGyQ3P36nfhCg7NHVesnvJlV4/0asut+snoEEEXXeOfjEy1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6834
X-OriginatorOrg: intel.com

>+++ b/arch/x86/include/asm/vmx.h
>@@ -514,6 +514,7 @@ enum vmcs_field {
> #define VMX_EPT_IPAT_BIT    			(1ull << 6)
> #define VMX_EPT_ACCESS_BIT			(1ull << 8)
> #define VMX_EPT_DIRTY_BIT			(1ull << 9)
>+#define VMX_EPT_SUPPRESS_VE_BIT			(1ull << 63)
> #define VMX_EPT_RWX_MASK                        (VMX_EPT_READABLE_MASK |       \
> 						 VMX_EPT_WRITABLE_MASK |       \
> 						 VMX_EPT_EXECUTABLE_MASK)
>diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
>index 6c7ab3aa6aa7..d97c4725c0b7 100644
>--- a/arch/x86/kvm/mmu/spte.c
>+++ b/arch/x86/kvm/mmu/spte.c
>@@ -413,7 +413,9 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
> 	shadow_dirty_mask	= has_ad_bits ? VMX_EPT_DIRTY_BIT : 0ull;
> 	shadow_nx_mask		= 0ull;
> 	shadow_x_mask		= VMX_EPT_EXECUTABLE_MASK;
>-	shadow_present_mask	= has_exec_only ? 0ull : VMX_EPT_READABLE_MASK;
>+	/* VMX_EPT_SUPPRESS_VE_BIT is needed for W or X violation. */
>+	shadow_present_mask	=
>+		(has_exec_only ? 0ull : VMX_EPT_READABLE_MASK) | VMX_EPT_SUPPRESS_VE_BIT;

This change makes !shadow_present_mask checks in FNAME(sync_spte) and
make_spte() pointless as shadow_present_mask will never be zero.

And the first sentence below in make_spte() also becomes stale. I suppose
this needs an update.

	/*
	 * For the EPT case, shadow_present_mask is 0 if hardware
	 * supports exec-only page table entries.  In that case,
	 * ACC_USER_MASK and shadow_user_mask are used to represent
	 * read access.  See FNAME(gpte_access) in paging_tmpl.h.
	 */


> 	/*
> 	 * EPT overrides the host MTRRs, and so KVM must program the desired
> 	 * memtype directly into the SPTEs.  Note, this mask is just the mask
>@@ -430,7 +432,7 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
> 	 * of an EPT paging-structure entry is 110b (write/execute).
> 	 */
> 	kvm_mmu_set_mmio_spte_mask(VMX_EPT_MISCONFIG_WX_VALUE,
>-				   VMX_EPT_RWX_MASK, 0);
>+				   VMX_EPT_RWX_MASK | VMX_EPT_SUPPRESS_VE_BIT, 0);
> }
> EXPORT_SYMBOL_GPL(kvm_mmu_set_ept_masks);
> 
>-- 
>2.43.0
>
>
>

