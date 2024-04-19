Return-Path: <kvm+bounces-15180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 720618AA684
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 03:20:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CAF3AB221A7
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 01:20:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9DF915A4;
	Fri, 19 Apr 2024 01:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Atkya+/E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7247E2;
	Fri, 19 Apr 2024 01:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713489608; cv=fail; b=Tt9gEbT6tUWe9WgxD0+TW37cHFD1v+QIP9Cs1iV+Fg2BjPa01idZD+uICTmXR/P99Xc2hFUisS37Fj4NDwM5zJk7KzuQGHcNwgTW4PjgPNbgHFOG8DTNWCaELGToOq+UAPRrHooyxdh7ayCPs127YsM60jh0ewnqQM5qQbABZ5k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713489608; c=relaxed/simple;
	bh=3y3sq6tnPcCZD9seVcPzPV+zTsSniUps734NaS9GsPo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RnQF86QgF3o9WjrHtgQecUZtmI1QuS2u+uyLMeQvIW5bEsIrF82qkBYKPcLecVk4tgbOKDHUiOS/g5vR52Le9Nr3+Lb3W7Es+t09ZhtFPlx00t5/VRLdJ85H26rp+2defb9vz+f/Yb+OoHp9Go9RZP+Kr8NcAYIFSvsshVl7wzU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Atkya+/E; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713489606; x=1745025606;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=3y3sq6tnPcCZD9seVcPzPV+zTsSniUps734NaS9GsPo=;
  b=Atkya+/EEtDDN9CAaNRxuusFbd76598oOBYvww/J+mlgzqVj1FA6Vj3b
   8qbzy+C2nc9jvKfNjkjOqCQrFsjj/B3EwsWtEmwuNkZ8pU54C3RJZSnIt
   STKlAODzEqOk3ZNQOM51l6BfIvj0K2h0C15NPFbrR3GD8+tXXNMi3jve1
   G6/ipkxF70avBwQJNlc0fQ2ZNqxjVsSTeisxg+l8jHDHD05GyFofz9508
   FItno/QpuonfJ3BK2mBtlQxjV4PwpIr5utMYm7Ny93ftPyDuV0wB4M8zf
   c5kkvSUL1fObbaAYxkUhY+vQDUksHhCa4/qfIoLVIU4yONO5AKKaYbEzg
   Q==;
X-CSE-ConnectionGUID: JDS7dM8pToS/RliWsIwPIw==
X-CSE-MsgGUID: cLQK0/7WSmO7VeerbphqYQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="12909762"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="12909762"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 18:20:05 -0700
X-CSE-ConnectionGUID: rrym30iKQE6XiUerij14jg==
X-CSE-MsgGUID: yiAsPvgKQDi6x5168Zd6Fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="46461053"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Apr 2024 18:20:04 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 18 Apr 2024 18:20:04 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 18 Apr 2024 18:20:04 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 18 Apr 2024 18:20:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J8k0tH1ocN2Yu6Dx4gBfocGaA409cpOc70wYyzI71qlFFoVatPXfnhOzDz81KiiCWPMDMtPntwVVsAQtITPpklqjMXXhszZbATM4TI4C7MCRDrT+E//IAtnLBmT3sJ0Jwhobz//1tSwinigwuha6CUGlKUYtIDn+skODd+QdSw+Kjx+fMGITSdSzHR040nX8pZrhqeXHWGuYu5570LHZy99HiGpZl37AR7qJLaIhVLvXPUlZ0z4NM22Njb6KGT+gkXMxBhU6sRoerqZeIhf4IEpij3kvxg9Y/CQUSbkQ4ldMpqZKyz+cIoSOBOccid/H/Vqqrq76Po4lm53YPA0oyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MuMzn4/Vh4VUHst1GLhiTQLGwDtLm4tKO5lqOf9dtho=;
 b=QJVqcUkmTaHpYrZtyh6Twl7l1cgSXAiDgi3Q3sGOP9ESJtyCarLBye1dgVCjs83/zkQ2+s9+0xRWhAI81SdyRSITieooIM0T9cPOcZ/OFf16J/dHc5+tViQtJ/r+y8yX4SfTdLxXgDCSWr0EhwdPQAYiUBJP6NswC5W26kH3Xf7i2bgaq5Mf4xtEdFtI44hKdU01+Ads+PHcVEfz6OIybEvMnnk2K1CVbtLDHqqsY7c0VlwvlfyC+5tr/C5TJ976Z/LYyT+h6PXyfIL8bBdv9fHhGZoPCnLaN/g2IcbFE8r+iy8trKZTog2AxzHCOCou/8bAF+jCkaGlvrQ856bZhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB7450.namprd11.prod.outlook.com (2603:10b6:510:27e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.12; Fri, 19 Apr
 2024 01:20:00 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::55f1:8d0:2fa1:c7af]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::55f1:8d0:2fa1:c7af%5]) with mapi id 15.20.7472.042; Fri, 19 Apr 2024
 01:20:00 +0000
Date: Fri, 19 Apr 2024 09:19:29 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
Subject: Re: [PATCH v19 010/130] KVM: x86: Pass is_private to gmem hook of
 gmem_max_level
Message-ID: <ZiHGoUUcGlZObQvx@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <8108cc2b8ff01ec22de68f0d0758ef0671db43fc.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8108cc2b8ff01ec22de68f0d0758ef0671db43fc.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SI2P153CA0015.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB7450:EE_
X-MS-Office365-Filtering-Correlation-Id: 82acfa71-037b-4129-4679-08dc600ed553
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: MIR62ymj8A+qSuLIKIO8qrfOvzlxr7Iyz4sEoVsnJ98ml2KLHQY36PfLDoA43Gxl/BNEPT84n5XxjhnOX0YLBGrr6rZriG1v1UOBrwq/8ZC1PG6gnaDVNOYuczEase3fMHZePX3cZ/OISn4Nu+BtwaPqtqAfR1we6Oc5Ipp4q5pUmxNeUodDYV/uYWJ23FavOwFoq0x1bIY8GoSomgxAIwjM/23JS2Mtd7Az7dG7auk2tP12SaeCyfJiSIYGlALlbO+QEwm5VVeYnmYueKOVTL4bSUjJ75230aiXMn7kzSG4UVB2qCxkUp1PACxQ/I8HpXmgLu84BD/oZcx8rx1/GmjJlBOXkgBESPP4BRcHorg8BsU64qG0VUQoa9LdgKFgN4PFOB/nrxbF82t8zl2RisWmcQIzu4vKzW9SN+Uh1JqHn+rzGWS4EnvLhf9JeEdmgZmfLh3U3L8oyI/qSuNuXArkrhzpkx0eFzhclCF5mCB39EwnFaWQjOPTmgiVQq1iM40/teXbeFLMLEzmskR04EWhmXKwoK8CWx8zkfaujyLypuCWlRjkw2lLPGZgqri73pUfEv+G7WUxK9SqIUAhjKGSAjgOPD4Z/VE4gWXwb1LzH7DXBpVuNY0CDlCr8r73xuOGJDEs7nk1kcynSPQtyBwkkhzF7aO8VC1jhoVEUzg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?npuQps64/wUWKsTtgbK4SEu3fTTGfjw6HN1NMSkDobk6eOVyJoQl770EBfWj?=
 =?us-ascii?Q?XmZOZ8Ev9n5A/k4G+LI6juaubCyz1M+ByHxkNlhdo+P1XkP/yr8OPsToAgJ/?=
 =?us-ascii?Q?tZJCyDLYaXaAomUThsMVUiOHLGy/mewez7QEpKtM4mEgKh3bAflvGQ/uESI2?=
 =?us-ascii?Q?/78jGNPbijoTVJk95yuarYDTFkKUvmA7w0pbCg0PWWhL641xt8VKQqp8gbfl?=
 =?us-ascii?Q?024ncfYodtJ9EeWJyHtYczl+RlnCoD+vtyH+U5TYEBURdmjhlY9st2k7VdWZ?=
 =?us-ascii?Q?u8Okc7qT5xTfI/daPVdzE6Oml5gcH9Jeduo5IGuWTG6/v/+Ex8X1+dJn/+ER?=
 =?us-ascii?Q?rjb81zyZES2zqFVMBthx85hMvZTIB/aVuB3DwrNr2bhYG9eYF9+LmVIbEHm6?=
 =?us-ascii?Q?ivkgwED+hXTdUh7FrtjfAuUPAHJ5Ky3V9HJvZ1KuyLXTAP0ESog2+12JcONV?=
 =?us-ascii?Q?V3cnEVuiOfbXVfRbmnDsjB2taIyVBwXXeuu59BLSc54cccHqwYRyQssZKMOK?=
 =?us-ascii?Q?5JB2TFs2psoZuG8LEvsVK08BruvTvAxgtYsXKjkS0EZ5Ropxz9RGfnE6aJEH?=
 =?us-ascii?Q?wKdHqxqrRFTZMUGS0Re6ivMX7/IDVETje4rfUgEXdK2sSu+wht4lohcRv5T5?=
 =?us-ascii?Q?mLwFFWFMCYWCRM6CqChfCr0TDAQmK7A9G+2ZmMZagYV60amgl3PwKNsy6rRS?=
 =?us-ascii?Q?SYe8wuUVexcXbq2E2ZGa5FcvZo/YhPiitiwgPbamelhV8MkZBFA0MgB0ilvL?=
 =?us-ascii?Q?64J3TK3ca82zdksvLSES0GVu8PrIkuTDlx8UxK9Wupcumb+1bWlVk/uFkghr?=
 =?us-ascii?Q?iPEWRklSfoAvSjVlnnxmf4D6me4MnJtwMASfxXcIMhBkgbXb48EACF0sCGfG?=
 =?us-ascii?Q?QlwCNFkZm4DzeXe8Tyh+EfHg6AfPkBUUojCX6NN1ZnZDaGq4JvDi1BoT0k0E?=
 =?us-ascii?Q?g4e7Lqx5dQXJRbOq2DBzB4VfoB/bwvtP1KO0kLwNDrG5TQ68qV/Zq0s+Yp/Z?=
 =?us-ascii?Q?YT9pQJVM5jbQq9EWhD8t7/X+Vq3oTTHaRKUEbf2k0Y/Igko/0LfeTXwTuQGF?=
 =?us-ascii?Q?tcwpVW9L5SxUiCGpsxWTAsXdDpiKRNP7oH8tjaccWUFOFW8xIhlhDynwF0Jc?=
 =?us-ascii?Q?LE0fo28p3Y+PwZGTMcnHUf/MudpGi1Q4zyHipZM6aZBVG8IzZacO9ffOClYE?=
 =?us-ascii?Q?bm2eQBOYSX5TXyKCdJ+O74S39cmPeyUl4LYWwI1c3APDgvh+BTqNWOlLkMhp?=
 =?us-ascii?Q?gHE9GDBRlibWVafoWT0OXUA/+dzlFkH3pQFErgWIPyWBVMtafN/y9lvFd+vI?=
 =?us-ascii?Q?WUYpS4GDmazshxlAL8SL1HfsH3bUZ3o2koagw5LoKipjfM4Pedk3ZnzUhXvu?=
 =?us-ascii?Q?tOxCbuQMolELlAG4hEMT2MfUhJzc3jBzrSCI7tgGnA7leL/YjJzpRlepnuSN?=
 =?us-ascii?Q?6DFjRYVaLXl0pTZtdglkEPzszZBmD6JrpcinZsdMTqgQ604FDxi0SUWLzmPT?=
 =?us-ascii?Q?yREofitk7vxE8iUYQoaWKvW3mYOtlknUA6gtJV1/qnnbf1TDIifSBjXxPo86?=
 =?us-ascii?Q?WGXodu7n5Dhk8BwNtkDL0Zzqd0nDB+1SNl2StwTw?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 82acfa71-037b-4129-4679-08dc600ed553
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 01:20:00.5796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /JwphqgG1WDNznrxkrmYvzwedQdOuTkm74XhDyEv8N2NzZnmJdpTL5HDF4QueQ4XMO5YY69w8qd/uMSPsbHjDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7450
X-OriginatorOrg: intel.com

On Mon, Feb 26, 2024 at 12:25:12AM -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDX wants to know the faulting address is shared or private so that the max
> level is limited by Secure-EPT or not.  Because fault->gfn doesn't include
> shared bit, gfn doesn't tell if the faulting address is shared or not.
> Pass is_private for TDX case.
> 
> TDX logic will be if (!is_private) return 0; else return PG_LEVEL_4K.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 3 ++-
>  arch/x86/kvm/mmu/mmu.c          | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d15f5b4b1656..57ce89fc2740 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1797,7 +1797,8 @@ struct kvm_x86_ops {
>  
>  	gva_t (*get_untagged_addr)(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
>  
> -	int (*gmem_max_level)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, u8 *max_level);
> +	int (*gmem_max_level)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn,
> +			      bool is_private, u8 *max_level);
>  };
>  
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 1e5e12d2707d..22db1a9f528a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4324,7 +4324,8 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
>  
>  	max_level = kvm_max_level_for_order(max_order);
>  	r = static_call(kvm_x86_gmem_max_level)(vcpu->kvm, fault->pfn,
> -						fault->gfn, &max_level);
> +						fault->gfn, fault->is_private,
> +						&max_level);
fault->is_private is always true in kvm_faultin_pfn_private().
Besides, as shared page allocation will not go to kvm_faultin_pfn_private(),
why do we need to add the "is_private" parameter ?

>  	if (r) {
>  		kvm_release_pfn_clean(fault->pfn);
>  		return r;
> -- 
> 2.25.1
> 
> 

