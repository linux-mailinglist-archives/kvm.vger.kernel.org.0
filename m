Return-Path: <kvm+bounces-11510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 59D5B877B8F
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 09:14:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB06CB2102D
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 08:14:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B4DC125BF;
	Mon, 11 Mar 2024 08:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="auUZPZJs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FEB111BB;
	Mon, 11 Mar 2024 08:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710144885; cv=fail; b=Mgk3OZ0gwyrZuDop2awA15W2LFMjfOKv2W9OlstwZZstMuf3bYcks7HLnvLemMNATXiRz3iwlARoj0xviSbK38MUS4WOEJehx2tQcR6YSl9oL+GXUbdC+GGdqxildpd6C77qY2zL2JUijwrgtUQy8Wz3m6T7imQTJgLy29fHVCk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710144885; c=relaxed/simple;
	bh=osh8owi0H7ULdQUzpdIrj/lm8aHXkL5y1TkWTDj4BT8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ECsl3vcQvaWf0knjzOV7xNfg+rDjjcYY+Uq1PYyzt9sXLv7QxmK4mTWowuan5g/M6V3kQXKMq7+XndP0QDhm5QN63AgC8wMwxVG7K4PBspxasVj4WtZftE2C6HYnCkJP4MGPU5eWETP7ILmc/MP7Tsn3cv/MjYCf8Wy7qS52HPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=auUZPZJs; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710144884; x=1741680884;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=osh8owi0H7ULdQUzpdIrj/lm8aHXkL5y1TkWTDj4BT8=;
  b=auUZPZJsP9lX6wd4m2SaytfxMIv5t6MJUzdkWGYpx1ocxGFqdT+w63S1
   21k7P7IsH2kkTFnu8LcniRn+HclqQ/IA4ZSgR1n0v7h/rg2aJJUo9keTJ
   YLLPz589aFfLlPwk8CFzPBwsLIGPKmtrG/RHP0chIgUilKyKa/JAaxpgn
   xlG2Jn1GO1CzZCA6awXMIl5xlzq98gMUZyW5yEi2sGhMAXd9WBxOeLp8+
   /A6mqkgLOmDFdFohzzhqQvYkwxlyXtet65H04vtN6oe07X9x0BLGn0szF
   gtPOEYl4qu8XO6/IVTTV1Un+ZmwfL1oN0cUKwIEkzUa8vbnsCQzhgikHm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11009"; a="22251032"
X-IronPort-AV: E=Sophos;i="6.07,116,1708416000"; 
   d="scan'208";a="22251032"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 01:14:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,116,1708416000"; 
   d="scan'208";a="15741994"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Mar 2024 01:14:42 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 11 Mar 2024 01:14:41 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 11 Mar 2024 01:14:41 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 11 Mar 2024 01:14:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hLsysmxFCRfOcsRH7RIjqmJLmoXT0jKoTZ8IK7MkBk+rtsfbLRSdWorowbCIc0ytwE/OhxYPaixvWvRsur8FdaZP1M0B5SpS/4rqFTQd32O16wLCyMzUqzYLTeCy3rJ3eLx4P4EOGnIKKMxsE+m5K809a/t4vPS654L6AkbG/fR5x2rZwNi0bXrm9WgkmtMOo/zYrhLxrn8jf/6Ieyfhept/yca4Ecm6LIg+WlkqmVJu1hZU5TBeVvOvaf6RdTsReAMqtR3hH2wGsvTonG4026I7Be4qo4FsfQZvmuigNoa882i+APZNDxSQRbNw1GoRBFdAY8nGCKYWICL7DSvxtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nfNZ3AAiwI8dZrTViR1mS6An965kbW21A7I4pUiANWU=;
 b=HTN7YElNxDjPu6WtnQBJabCMhQfuFC6MSa1vSWaFnx9IRyDYLzupxk313yLmfWP067fJmeE1xBJvbIR3i6WVwwcS1TqqurxAiBoiveUtQ2BhVSypmymSnZlObsxtVlTz1ZYEIF5bjniOAOFjaPzA1jZKWbgQxmOGPciqUxec3YS7E3pXLbgu36pbSmlPcpYe/LUdx4tWVV1GWx5KjgwpG0OrqRXrHft9PdtVM3CdtGGXyyUDPga2lBXxErCNfBLgVwqdTo7CtkoZGW0oaCDpWEZKA3u/enWj9qNJSp/fGzEvEhR8RdtWV2m7wImNzMpRCK9GzOgoqKxQgshJ1H0pgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ2PR11MB7647.namprd11.prod.outlook.com (2603:10b6:a03:4c3::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7386.16; Mon, 11 Mar 2024 08:14:39 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::55f1:8d0:2fa1:c7af]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::55f1:8d0:2fa1:c7af%5]) with mapi id 15.20.7386.016; Mon, 11 Mar 2024
 08:14:39 +0000
Date: Mon, 11 Mar 2024 15:44:46 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Lai Jiangshan
	<jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, "Josh
 Triplett" <josh@joshtriplett.org>, <kvm@vger.kernel.org>,
	<rcu@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Kevin Tian
	<kevin.tian@intel.com>, Yiwei Zhang <zzyiwei@google.com>
Subject: Re: [PATCH 1/5] KVM: x86: Remove VMX support for virtualizing guest
 MTRR memtypes
Message-ID: <Ze62bqgWhbReg9wl@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240309010929.1403984-1-seanjc@google.com>
 <20240309010929.1403984-2-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240309010929.1403984-2-seanjc@google.com>
X-ClientProxiedBy: SI1PR02CA0001.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ2PR11MB7647:EE_
X-MS-Office365-Filtering-Correlation-Id: 3172c274-a666-4a34-16f5-08dc41a34c10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qwMRH/U3SDopuzRVGbLaqK3j/1xq7G22R1ATZgcIO7ZqCMm5IZwdTFw8XyJaHcu/ZOUbRKdtfSXhrRsVohAidDWQ2b6CC++arfWBbLo1s0QZGVFWqbqKz5KTEOXDyegtuUrZPclwp/MRAClCm2GlMjZsjTt7ha3VitneHf8Mka5Zc6j4Y0yLfxd3OI66utXu/+NyuHlbIgqiu4LICZ0oB/7mHqhMHo1+qpbejDTHpdRgFFAtxN4N81rF7wPJ0oBjmVPxA23k4Pz4fmIgCRhJAyrPq1cJ14uGkghJmROH1rlreENXDvx8CUpUUjtRNkZ8z6EvcwueDmHJBipGMmUS6J3Hhj0eDW5IV6YrzBbr3sDKqbbZN4DUSpt9ekUVE9zn8R4biR8ZrDmi60gIrFk1UlfpNsmoZEDavr+BU3jLRD7bXupHt39wOwzr/kzlaf+KCieUR/5RClPKq3JFM6ZIuZZgbYhgTgIx93D2GHrAf2FKPQqCgT4gakABSikT+FgvcV4a0Vk8ByOzuTzte1roiL2ZfBc3zsgst0SHR8cKoWD9DNsh7mWjbwmb4xTRL0tjNPEeaWgqQNESUU/CdzYR1c0RukiDGeqM8OpCjJx0GSe+GLo4mHhzvB1uQCsrbA8Gi3VA5EiSaM39u8f/AOnYlQ91NnZQfak+yxr4VEyPzEU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S/fluQj7rZQJcjbeBN7tMsE95KIq+4Gd3HbVStf2FEZ5gUZYV6/xs4mG7OmV?=
 =?us-ascii?Q?xK8ydkKW4MBUbLgxmn+uTOkjMx6dRJYvJUTt/2O9UOFeTyspIqLLrLk/Iz1g?=
 =?us-ascii?Q?eYPlqVjnSCH+U3+6j4B7EFlMnobMwzLnU7H0O5QyntjBlsvZW0DjaD4bOk/N?=
 =?us-ascii?Q?SO4vP7lVQZzw/J7JnKaXpKUunbsqfSUX8pe5vymm/Z5RolnU8eEeTXlZPWGu?=
 =?us-ascii?Q?D+ipzCmoALUkDH8JGf0wml63KmJHJsBop1eI07lZnAMXLntkGjYKB4aWNyWN?=
 =?us-ascii?Q?gNGIIuCW91owtsRxae43i/ZNCkm03vZHx++88S9Oje7S85QC+9JzIwOgsKIV?=
 =?us-ascii?Q?eun+eE0zO/VavzzXJenAr+oWZv6tF4ZAn8IaeW93sS7vUBx9CjFbf+Z65do0?=
 =?us-ascii?Q?CUachmS5qEX8QZL9Hyl/GmrcatwnB69byQkwGHA5E7t8QRpfe3uMfRvO/GSp?=
 =?us-ascii?Q?VWpxA3nbJKzrJzdW73h0kVce7Fu0RiOnzNbxbBonoHIXeYAJDfJZhCEhT/kw?=
 =?us-ascii?Q?ypp6Df4HI3LVOJ//drHPE6F2SlUojfVs9QLbw2dUFTrM/MGT3Eb3/aBiZGi6?=
 =?us-ascii?Q?cD7q5MSr5jdHUQV4oDtBzfB32COCWYzbbYwmADoQH6qUvDnx22VHyXG/G3Os?=
 =?us-ascii?Q?7zrO863HCLvyDXziweRtAhe2YO7U0BF2JRdLlBUAy5pAooUyZE2ssXedvhrU?=
 =?us-ascii?Q?8teyAzQ6ozorwd9E0DC9XmnqzGT/X8YpaU9jDK6hfk3eGL1pFvWB+ihNo6CF?=
 =?us-ascii?Q?wT+YV7qNTKzbBcn2v3j2LX02wH3r+NyyPji0jFiMwzo1cp8NiDNidU41cpiJ?=
 =?us-ascii?Q?6zkKsJUJlH+bmka0S9ub9z3foyWht43Ua4MTC2U0CjAK+woIxWZabTKlXx12?=
 =?us-ascii?Q?/Oge2Qk20i+DvsekUhvEgetsTZKfbd0rYYJGEA8y0d9cX6rMeiMbVv2Fw0AY?=
 =?us-ascii?Q?57pzvF7B/Gkj0n9yokrXxZXmnMsHAlyoTuHzL0pKYx9JsrvE1Blw+tpjiFPZ?=
 =?us-ascii?Q?kO/6EDagWy65IkBIbT6n/3wfzrEV1Ml8pcBim2AtCr0tKYmv9E1kH1vxR8O9?=
 =?us-ascii?Q?GNqTWvTDm6yjEqjNcnkY2XiXt6uIlxe9J30kyP+6nxnOUFSXnAuENLic/Byf?=
 =?us-ascii?Q?JCHbRCcm1v2YinDYadq0G9AXCNus/8HBy8BihPvCVeTjxh8PVIZCcbPDuqGl?=
 =?us-ascii?Q?/bHCkNXF+7urGNiteCf0ga5SGSRDbLH9wUXr6F45wHRCXki2P7tKWIKsh7Px?=
 =?us-ascii?Q?COanyo5eAJ4s94pvIiKHVf5GkUtHXKnF5luKH+OAjvy9Br8nGGOcoPw4e3DH?=
 =?us-ascii?Q?914foKbZOeYDI85Be90z5mYacCY9sBynzzRR15r8x48yNq2orL68p4LIUo3d?=
 =?us-ascii?Q?EqbgZBEcqUa45im7jkCeviZJ6532RlB//JyEmCpy00CoedqXUJCi5qtW8sIa?=
 =?us-ascii?Q?OxCSu/Tzu6XeXbOIEX2H9HqZS4HfMF+c7CZ1IxrVesFu8n5qbFcjfS/FkRCM?=
 =?us-ascii?Q?tYcTMAjhSIYq23te4ZJkpFbaEry0/Q+cUFM/jIaD/bAga6SyZYl687VKzTMu?=
 =?us-ascii?Q?vgLyCQnKkYpTJuLeJowhqlPMZJhaOCmsLYSY4zoR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3172c274-a666-4a34-16f5-08dc41a34c10
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2024 08:14:39.2708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PmL+3D7DP8cPns4LbcAsc11V6Czgp9L+GaqUezhVTzKGQmHX12U8Cf4P9TBAgGLTj16OkqeYdSNqfqtUdYP9Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7647
X-OriginatorOrg: intel.com

On Fri, Mar 08, 2024 at 05:09:25PM -0800, Sean Christopherson wrote:
> index a67c28a56417..05490b9d8a43 100644
> --- a/arch/x86/kvm/mtrr.c
> +++ b/arch/x86/kvm/mtrr.c
> @@ -19,33 +19,21 @@
>  #include <asm/mtrr.h>
>  
>  #include "cpuid.h"
"cpuid.h" is not required either.

> -#include "mmu.h"
>
...

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 7a74388f9ecf..66bf79decdad 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7596,39 +7596,27 @@ static int vmx_vm_init(struct kvm *kvm)
>  
>  static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>  {
> -	/* We wanted to honor guest CD/MTRR/PAT, but doing so could result in
> -	 * memory aliases with conflicting memory types and sometimes MCEs.
> -	 * We have to be careful as to what are honored and when.
> -	 *
> -	 * For MMIO, guest CD/MTRR are ignored.  The EPT memory type is set to
> -	 * UC.  The effective memory type is UC or WC depending on guest PAT.
> -	 * This was historically the source of MCEs and we want to be
> -	 * conservative.
> -	 *
> -	 * When there is no need to deal with noncoherent DMA (e.g., no VT-d
> -	 * or VT-d has snoop control), guest CD/MTRR/PAT are all ignored.  The
> -	 * EPT memory type is set to WB.  The effective memory type is forced
> -	 * WB.
> -	 *
> -	 * Otherwise, we trust guest.  Guest CD/MTRR/PAT are all honored.  The
> -	 * EPT memory type is used to emulate guest CD/MTRR.
> +	/*
> +	 * Force UC for host MMIO regions, as allowing the guest to access MMIO
> +	 * with cacheable accesses will result in Machine Checks.
This does not always force UC. If guest PAT is WC, the effecitve one is WC.

>  	 */
> -
>  	if (is_mmio)
>  		return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
>  
 

