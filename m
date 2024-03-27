Return-Path: <kvm+bounces-12860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C02288E8F4
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 16:27:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC336B252C1
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 14:36:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75CDA15572A;
	Wed, 27 Mar 2024 13:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nGNIJsPV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5740155382;
	Wed, 27 Mar 2024 13:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711544857; cv=fail; b=vBTl9O67cvJR0CaMtcRUpqKEJsNgi/de2fMmI5kPqYwO6mGpl3DGImONTJybILYrRL++uDh+uBwl3JBxXgSGmK7LqVxQ97BE0b4a9XJSuPj/OB+po3kVMxuGzosMNpNaBRDA5LOww4T15oK4vm3TtDeGIolsMXOerCUyJNPJhZk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711544857; c=relaxed/simple;
	bh=qOlOWTXlpMjsewdgrs4U6WFOHyxIL8flmMq7FO/PWjk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TNglsTa3Ch+ojVrP3OVOvmw9QV6BpyLwxIN6zIDVYcACtJb07SrEaOR49pybjFnb8+7wu444uhOWx2eOIvKCiwHw33Qs6RTWx+br0n8JaTPaBGJQHCZcx/zfppMzx4QkI+zI7T5ljhfJdYLj/muOx27+vsjfCP0ZPsKN8UCud8A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nGNIJsPV; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711544855; x=1743080855;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qOlOWTXlpMjsewdgrs4U6WFOHyxIL8flmMq7FO/PWjk=;
  b=nGNIJsPVRRVS+bUMqyhZhLwyo6Iei2Ey91NRBiAXABXJEc5jrgzZDbNv
   09JkrseXoFNLjQmq6nBP3LNCRnfrhpIzpfdsqxaT/8wSZ0zXG3YjOybmk
   4AwO/Iai0Rqa3m39U13ZmsDeHADyqrP9hePVHFt1MHxK5m0o6RPlfmGh8
   7FpVnH9GQpuw62WIhfZdzstl7YlhMtqeNcamZvtil1QI2Ss/xQEleTANL
   rMsXZkCZNFyhgoHqhPnDgcxTHWxSqtojbjKdDpysTnpbJqfF8yM9yvJFf
   iHIIgKc5p7OsK5eVAIzG8tUP1o9NYXyb0lP69kZMOWS+3/Rmno99/+eBw
   Q==;
X-CSE-ConnectionGUID: W4S5004qQPu7jnSJ1jYlmA==
X-CSE-MsgGUID: Ynhv+SdGR8ubGe4xQTXyNQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="6469794"
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="6469794"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 06:07:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="16242594"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 06:07:34 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 06:07:34 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 06:07:34 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 06:07:34 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 06:07:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=glihmwI6kryi/YniBpM1pZtNhP1FoNyCUcKvI8Fu5UuzjwTF2HkqOWvSOrs3LAnSpWn0lPQL5hakJ/xnTFAEO3ksiGGfbZ7ef2mng4dKIcfz9HnEOL7foNSgvX3AITrnQJAQYYU0cX1sqW7IQHeibPyJoWEG9wUL/jl8+MIlYg4ok549C7RDsD7wrGpe7MxSxqABW8n0J9tEsslibgFUAoBgLOdPO6BFivsO76fi0ik+lbISUwJ0SxEDfaZVz21zzdY6JoXtf32mxptZXLdCW8zhkniP8PZS4QYpb1cesybr+pIEnGd84oVRyt8NEW4AuxVl6E/2Bg3xOsx6+TZe4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hj6rakd+2gF+6/ewGZ4VI+AaNbfvc+5JVWBOPb8FyKI=;
 b=bpvSS1bxLnvQIQ+JYv9S5HaHYqGI6lM2RqIf70nz+YKgZu3WhwfBsCVDxAnYZRUgEMB5Qr2HsVTna9ciNXccrFzvn3213bm8+XI3nqRxyD/748LO0zuAZFug4jYjTIwPjTiwrWCrhzxPnMnIjwV/5IF5NRD04M4KYEr3iPTpoozn8bZCU2WEolZL+PBM7bsvKbsisHdJTeZCgR88xbO1oiZOUFxwuR6TOXopmB1CgC7ZDqmxSMCCM+6To5/iev8Vq2a6rKMmoRoln+lasqN6F/95gHq9Km7n0hlnI/FIZCXNrhFRRl5x5vH6gv5BGzB3iOOFDJXuAXXhcx9lKvxRNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM6PR11MB4579.namprd11.prod.outlook.com (2603:10b6:5:2ab::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 13:07:31 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 13:07:31 +0000
Date: Wed, 27 Mar 2024 21:07:21 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
Subject: Re: [PATCH v19 062/130] KVM: x86/tdp_mmu: Support TDX private
 mapping for TDP MMU
Message-ID: <ZgQaCcdb4AshplI6@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <fc97847d04f2b469d8f4cfceee84c7ef055ab1ac.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fc97847d04f2b469d8f4cfceee84c7ef055ab1ac.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SI2PR01CA0005.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::23) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM6PR11MB4579:EE_
X-MS-Office365-Filtering-Correlation-Id: 53f574d9-489c-48e8-1385-08dc4e5edc5a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ac6EbwftS6hYHaI3PemESGpzlNwSvYkC9gIr3NkEoNtbiBsYB/awm2m0dmTPtCTn5u6FLw7t1IjxmBa7Gh9Cmk2KVT63LpRkkw6EVkBWRIg9WB/mSTsk2CHEPWbSKTZnefoWveLaReqQovPkbHAzYBIqVMGeGs6eFowOBsGwTUtNX7ob7NNu6EUY4Qs0MIhZAlnU1SsgWkLg0m/JabhWxcR5K2BkRvttOl0wy4KKHHbUAVkb7vtPoLXpUKHSCtPNEQzs10Ey+G1+BA5fX0o7OeasX59fXaD9s8//9LSkULjfj/MzTaZZnIWGCS1Z5UnVw9NsrvT30HFT/dooH31ZF+356xXF+1MhlZ06Ehhj8s9nzFZ1UnGCKNsueHNcyZ9+pmBWGxvsMEQNaZFnSDX7omurbHir6ndMWVbClWlGdEl44mvAvGv4u6ho7CcPVMCWLrx6favkoaY0OTygI1lQuhgPW7R8qI0obmQFg08S/pxkP7o57PQmbCfQHmzn1R8WTgU1R0d6g84ErBA4lk7Dxzzz9sKzWegrNN9Gp2dveyhQ2NE5+daCYDfN4xj+/J3E1kwjtU764pYvXiOqDRuklYsc5QyfXO+QAE1OCqbnXnFxk6A8+pEvOSOJyHjvWsJ0hPlzuOB64QfuB3KT/pwuBW8fWv8XtILedXk5r0s6HTs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QAcFBVU2a6WQaezrkqmRXhD3lyQmS+veJpsHXs+fyCMycPUUKMrxphXL8PWD?=
 =?us-ascii?Q?5IAf36HIvSq4hiYlNMZRVXTfnQ6usYBR799c0PPE6kjWHg4zCqkKD7WrDmcn?=
 =?us-ascii?Q?DVOL9SdtnPBE/+lsU4TZNNseEQyok+KfmgfwzxSVMAVlCPQP9n37Jr/VAqVH?=
 =?us-ascii?Q?12Dlktc9t4geLoD23Bq+oXZiVsf8gsUuyZfBIn+W2KJjmaPcO1Fj/tLKXxHz?=
 =?us-ascii?Q?ffKKnlC8f7UjWlZiEImClmp24KuMse6IZ/8yyzqhTqhGSGndKyW+Y7JQ0dKN?=
 =?us-ascii?Q?E2TXlScv97087IzNoHu1+s1DI6aE6Xxi31GYDZSS/efLYDEQJ+vZdRXUAwtz?=
 =?us-ascii?Q?3pcTq8gfVOgGHPFEVZTHmXe1PifqqazEEM9/LlTvQ0bl3BNM5aVaRnA3vaXq?=
 =?us-ascii?Q?Bu8J7BuzlvCyjEX5+McpDO1IbXuSiTPRhyKWim6SjCqMfN7Kdb2jXWfnZsAt?=
 =?us-ascii?Q?NOQtomv6UK0jh2iKf33Kktp9SS1RrRLMxrF4klBYCYZaFqnAWXxuEF2/jE2o?=
 =?us-ascii?Q?x2PP2ag3SY1HCLnSRHM3zAYr0eZiXMS7oZWnZhscsEQ/G8F1XyAIJ0EBHPcq?=
 =?us-ascii?Q?OwxYscfa88JWfEIPRLVp+bV73yTcHppqxu8xHFPT/tQ96qq9uizuzTKD6cPs?=
 =?us-ascii?Q?EXTlQI1CmS+NfxhOsNr18tYWWh+mo+xSyxlMzUxV7Z0glhlIzo6FYalSAKey?=
 =?us-ascii?Q?k4TVIV3cDVmxZcZh6bT8LYiDtZfdyPDNXvap9r8mY/TJtqaI6ExRIpDKUk6w?=
 =?us-ascii?Q?+P/24Z2EakPmCwYBJA05JhmZ9LU1uXbpiYki7iPNeW/0z5LkqRSuPWu7pz/4?=
 =?us-ascii?Q?AKC7mCeVyfTs5FOIvMjwrlkcSsAgWp5ibWXs5kMpEOPns3pCIqZkvTXBtN/4?=
 =?us-ascii?Q?C8YsM9RUaEvqpgck0M4hyisebBX/oM/aK2jEhEV8doDw7WG7gP0bBAMXe3rg?=
 =?us-ascii?Q?pzAFhow1Mau02sj1ilEeCi8J0wTgh39EClCcGRXAyuiwMepKSA9H8g63kuoo?=
 =?us-ascii?Q?hzse9RcdPby8H832Wjyvx0bZ3MjiRiY09YFNs5kzeo5E4Nraw1TQiE5rjwLP?=
 =?us-ascii?Q?6lYHLI6H9PdtLRX3LLPgIXLoHVeHWznfi9LXDMR9gbmvrRx2Ubj5dHZn97Wm?=
 =?us-ascii?Q?YS4ABuifqRRE2+d2T6v8ikw/QDd+popYW8aATa1ZmhrvfT1OuLFLcLDTiRbE?=
 =?us-ascii?Q?/XIFwLvsyRkpBDeqX3lYb53dPFhZcgtwqcH5JQvbFYyTh44lQuyVx4zN94A/?=
 =?us-ascii?Q?OZqttOzi0BCHJtkA9zzcmZR9zRZt9hB4w+LIijC9huU7+wRg1U27rc0XSjFp?=
 =?us-ascii?Q?AXYWcMDfv3fovk2zYrpLKr6jHfOh/OTTw5mYzsTcvQ9MPuFfLw8m/d8t9PRf?=
 =?us-ascii?Q?klYvnupNxFh5Yk7QTGv8FErjYe7Ky3h+IP5GTp4nwMFjCG/fjlbx03+lQoG6?=
 =?us-ascii?Q?tPrDZresE6M17xcygr6TSSSjTzfmzv7QnlJpXBz7I8xmWXSWVU+po1Zfbgh+?=
 =?us-ascii?Q?Oc7RIRYU06EwFdh+LBb/ORs83Gv+qe/VTUL/PFxQ0pk7W/rGhYcOKFgjeEaF?=
 =?us-ascii?Q?JnBznWjP8l1nCZBV7bwrHesr1xhpSSlqrODTHQlu?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 53f574d9-489c-48e8-1385-08dc4e5edc5a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 13:07:31.2991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N4f+uFvRky80QUZ5eIpqLsJr18hleXF0xT5xBTnpSzt4VJQiYI4S36BwshH/BWh25erUqDWbtc9ntEjIgMt2cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4579
X-OriginatorOrg: intel.com

>--- a/arch/x86/kvm/mmu/mmu.c
>+++ b/arch/x86/kvm/mmu/mmu.c
>@@ -3717,7 +3717,12 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
> 		goto out_unlock;
> 
> 	if (tdp_mmu_enabled) {
>-		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
>+		if (kvm_gfn_shared_mask(vcpu->kvm) &&
>+		    !VALID_PAGE(mmu->private_root_hpa)) {
>+			root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu, true);
>+			mmu->private_root_hpa = root;

just
			mmu->private_root_hpa =
				kvm_tdp_mmu_get_vcpu_root_hpa(vcpu, true);
>+		}
>+		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu, false);
> 		mmu->root.hpa = root;

ditto

> 	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
> 		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level);
>@@ -4627,7 +4632,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> 	if (kvm_mmu_honors_guest_mtrrs(vcpu->kvm)) {
> 		for ( ; fault->max_level > PG_LEVEL_4K; --fault->max_level) {
> 			int page_num = KVM_PAGES_PER_HPAGE(fault->max_level);
>-			gfn_t base = gfn_round_for_level(fault->gfn,
>+			gfn_t base = gfn_round_for_level(gpa_to_gfn(fault->addr),
> 							 fault->max_level);

...

> 
> 			if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
>@@ -4662,6 +4667,7 @@ int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
> 	};
> 
> 	WARN_ON_ONCE(!vcpu->arch.mmu->root_role.direct);
>+	fault.gfn = gpa_to_gfn(fault.addr) & ~kvm_gfn_shared_mask(vcpu->kvm);

Could you clarify when shared bits need to be masked out or kept? shared bits
are masked out here but kept in the hunk right above and ..

>+++ b/arch/x86/kvm/mmu/tdp_iter.h
>@@ -91,7 +91,7 @@ struct tdp_iter {
> 	tdp_ptep_t pt_path[PT64_ROOT_MAX_LEVEL];
> 	/* A pointer to the current SPTE */
> 	tdp_ptep_t sptep;
>-	/* The lowest GFN mapped by the current SPTE */
>+	/* The lowest GFN (shared bits included) mapped by the current SPTE */
> 	gfn_t gfn;

.. in @gfn of tdp_iter.

> 	/* The level of the root page given to the iterator */
> 	int root_level;


> 
>-hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
>+static struct kvm_mmu_page *kvm_tdp_mmu_get_vcpu_root(struct kvm_vcpu *vcpu,

Maybe fold it into its sole caller.

>+						      bool private)
> {
> 	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
> 	struct kvm *kvm = vcpu->kvm;
>@@ -221,6 +225,8 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> 	 * Check for an existing root before allocating a new one.  Note, the
> 	 * role check prevents consuming an invalid root.
> 	 */
>+	if (private)
>+		kvm_mmu_page_role_set_private(&role);
> 	for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
> 		if (root->role.word == role.word &&
> 		    kvm_tdp_mmu_get_root(root))
>@@ -244,12 +250,17 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> 
> out:
>-	return __pa(root->spt);
>+	return root;
>+}
>+
>+hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu, bool private)
>+{
>+	return __pa(kvm_tdp_mmu_get_vcpu_root(vcpu, private)->spt);
> }
> 
> static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>-				u64 old_spte, u64 new_spte, int level,
>-				bool shared);
>+				u64 old_spte, u64 new_spte,
>+				union kvm_mmu_page_role role, bool shared);
> 
> static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> {
>@@ -376,12 +387,78 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
> 							  REMOVED_SPTE, level);
> 		}
> 		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
>-				    old_spte, REMOVED_SPTE, level, shared);
>+				    old_spte, REMOVED_SPTE, sp->role,
>+				    shared);
>+	}
>+
>+	if (is_private_sp(sp) &&
>+	    WARN_ON(static_call(kvm_x86_free_private_spt)(kvm, sp->gfn, sp->role.level,

WARN_ON_ONCE()?

>+							  kvm_mmu_private_spt(sp)))) {
>+		/*
>+		 * Failed to unlink Secure EPT page and there is nothing to do
>+		 * further.  Intentionally leak the page to prevent the kernel
>+		 * from accessing the encrypted page.
>+		 */
>+		kvm_mmu_init_private_spt(sp, NULL);
> 	}
> 
> 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
> }
> 

> 	rcu_read_lock();
> 
> 	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
>@@ -960,10 +1158,26 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
> 
> 	if (unlikely(!fault->slot))
> 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
>-	else
>-		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
>-					 fault->pfn, iter->old_spte, fault->prefetch, true,
>-					 fault->map_writable, &new_spte);
>+	else {
>+		unsigned long pte_access = ACC_ALL;
>+		gfn_t gfn = iter->gfn;
>+
>+		if (kvm_gfn_shared_mask(vcpu->kvm)) {
>+			if (fault->is_private)
>+				gfn |= kvm_gfn_shared_mask(vcpu->kvm);

this is an open-coded kvm_gfn_to_shared().

I don't get why a spte is installed for a shared gfn when fault->is_private
is true. could you elaborate?

>+			else
>+				/*
>+				 * TDX shared GPAs are no executable, enforce
>+				 * this for the SDV.
>+				 */

what do you mean by the SDV?

>+				pte_access &= ~ACC_EXEC_MASK;
>+		}
>+
>+		wrprot = make_spte(vcpu, sp, fault->slot, pte_access, gfn,
>+				   fault->pfn, iter->old_spte,
>+				   fault->prefetch, true, fault->map_writable,
>+				   &new_spte);
>+	}
> 
> 	if (new_spte == iter->old_spte)
> 		ret = RET_PF_SPURIOUS;
>@@ -1041,6 +1255,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> 	struct kvm *kvm = vcpu->kvm;
> 	struct tdp_iter iter;
> 	struct kvm_mmu_page *sp;
>+	gfn_t raw_gfn;
>+	bool is_private = fault->is_private && kvm_gfn_shared_mask(kvm);
> 	int ret = RET_PF_RETRY;
> 
> 	kvm_mmu_hugepage_adjust(vcpu, fault);
>@@ -1049,7 +1265,17 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> 
> 	rcu_read_lock();
> 
>-	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
>+	raw_gfn = gpa_to_gfn(fault->addr);
>+
>+	if (is_error_noslot_pfn(fault->pfn) ||
>+	    !kvm_pfn_to_refcounted_page(fault->pfn)) {
>+		if (is_private) {
>+			rcu_read_unlock();
>+			return -EFAULT;

This needs a comment. why this check is necessary? does this imply some
kernel bugs?

