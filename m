Return-Path: <kvm+bounces-14652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 94F988A5160
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 15:31:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B57CB1C22540
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 13:31:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF2AC1272A0;
	Mon, 15 Apr 2024 13:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jaLialeB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011F285C46;
	Mon, 15 Apr 2024 13:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713187323; cv=fail; b=lHBcVO20wUKg4t2QdoaFRY2uCYxO4oD9bMM7Di1fB2jF2hZqjOwdJjl+AXKfv2RYsly0JyGkIsetK/IiLiUr3DRQMiuWYrEUMn6PuS+5LMRBFml8JoDrpszebM1zklkydS7Qi1KRxav5IZsMcMVNQolAOOeTKsa5bbJ4FDCyEuM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713187323; c=relaxed/simple;
	bh=O/MnUPgAvzUvRqj5cebPKyRPlbPoitLPAxGevIXesb0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ATYrkUWvsoXsW7WymuSsdqR4SmPfhGjmMN6v+ZhctO780uC8IJhEZhP+MAhRbanQDE/JgmqHlczjMfHOQTg9neTJSjl4a5xTDh0jSACkQ34QU9+vOFdPZhOxz9QCZkb3xBII8gFB4sNoRI9EAJN5dAG4yU01+5jyEy/4E/SUmxE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jaLialeB; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713187321; x=1744723321;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=O/MnUPgAvzUvRqj5cebPKyRPlbPoitLPAxGevIXesb0=;
  b=jaLialeBzCRdAqZjZ1vGkm7yIFJKPjRwA85DJbykHbLTtRp5+SAZqlWB
   qfpuS/l+017/iJ8irKf3fILe+A5k8a2qubctHiHg1mikNn6/P18uC8eYY
   bGXAtgZB2dOWMOy3yll4nw19MY2fstbNI6MAHe/vBbeI+N6/pjzVSdrdu
   cZ5ncFoiotZwfU4HBgP8JblScpenPcPHBvghMcJjo/p+Lbi4/usi5VsC3
   G4rOhQZWMnfZs0mso4ordwFRPqp7qCd+1iMX8kho52bfNHSzhy5dH93WW
   gSM15eUvdhUcuABaB+ISmQ5kDarPaX3rdR9MYniepiSsWtBSCEsbUyZ0K
   w==;
X-CSE-ConnectionGUID: OqQMTA5jQfyO/ZP9nX214w==
X-CSE-MsgGUID: pXLsfvDJSV+BHhD/xOY/sA==
X-IronPort-AV: E=McAfee;i="6600,9927,11044"; a="19724771"
X-IronPort-AV: E=Sophos;i="6.07,203,1708416000"; 
   d="scan'208";a="19724771"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 06:22:00 -0700
X-CSE-ConnectionGUID: 6w2oyz1+QVKS8LjMiLoZow==
X-CSE-MsgGUID: +DsG19R0RouZa61R314FgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,203,1708416000"; 
   d="scan'208";a="26334747"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Apr 2024 06:22:00 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Apr 2024 06:21:59 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Apr 2024 06:21:58 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 15 Apr 2024 06:21:58 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 15 Apr 2024 06:21:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eb2GzfCGWHW+QKkt17EnQT8d+owSu7tzMZ35MP89p701O89CHlyR9VM645pH3nUl+BUdceejFXwikvxEyIfrp49kq2SSKo0hSnlT66Fnwd0C0QlxxNG6fx/QLjpqASn7YEt0ElGKGwDMBR0HOCqO9ip9UaflxItVm2+ILwA/cNJjkMvNK4hxrmOZsvzdZuRp42InvKiKpYckNBJBZVwHqao9cZ0/twWv83RDPXvIvx1YEB61d/43Al5Y/iNx9QRvCpfoW4Fzh8oF/j+3nNf3H+6nusqE3htQPOvw5JOJhf/pHMFqHIUUm+7J9WR4F2++nwmW2RwoEtKea7m4DGBX5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zct7Yv8RIHFsx8KcET64d/xGeL1NBrb5RumHusn5+6o=;
 b=OOlqqXwWWPccb8ATuWLobsxMukK3mn8LeyUheWGtvsaIY8BCzWULinJn52t/Ck/dMAJ/ItZ0uCeRjBQ7wjLw2TM9rxEbU6UdiLtqwe+TaB5336VQ7Dia6+RWdBhVuiQpS4uQpz8pE2/7kXWUw/h33pLp2tyrYHBTJN839XQaYwW5jYc0on2ZWMQyyjJrcb/KI7eqnJm9fNBEtaEP4YtnAhiuSWlRcF6pQ5mRFiLYdbJ6vgroqodwOyR39EHCQcAEB4WOIaxN894qXbH/nacxi8xhd4yiyOYO/EutEHbtB3DTtQdgd+TyL16iGMIOBaZjEcBcjABRKzvA7LPK0IaTMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM4PR11MB6017.namprd11.prod.outlook.com (2603:10b6:8:5c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.26; Mon, 15 Apr
 2024 13:21:56 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7452.041; Mon, 15 Apr 2024
 13:21:51 +0000
Date: Mon, 15 Apr 2024 21:21:44 +0800
From: Chao Gao <chao.gao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Isaku Yamahata
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH 07/10] KVM: VMX: Introduce test mode related to EPT
 violation VE
Message-ID: <Zh0p6Jz5eKBBmWci@chao-email>
References: <20240412173532.3481264-1-pbonzini@redhat.com>
 <20240412173532.3481264-8-pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240412173532.3481264-8-pbonzini@redhat.com>
X-ClientProxiedBy: SI2PR01CA0036.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::22) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM4PR11MB6017:EE_
X-MS-Office365-Filtering-Correlation-Id: dadbd176-7879-4a9b-6492-08dc5d4f02dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fJzO8zUOCvWallPD8XxLOh6vrMbUMtfA0nWtgpmKytTjNFIRDS76GfnDmYW5SOh+U3/NlSfS6NUxvnA8birrhi+btZevlcDsW4uQJk69PU3A1K2TJP4w3ci/b8W7HkWdk5PzW09KqhO1eTnhChOKam7aybeze67WpCEILjxtncy7aR7Xrn+FHyj3h3Wr7bvLJTHHpI9/JyQWkjr39kR8SH+XEXiKCpFtPwV6ceiiZt1GJtLusU2z5nbsFhgGTMti6k1iQjEvysJsDtGYhjlCnHQrSAZLNqacSQ0wbbdT5Jp/rlxS4F9dOFKYv7WWEGv6DnzqLkRuWnyjqqpTqZQ8apz4NkAgsS4RPypawazbrbMbxL15VGCLxewACEKMoBaJxplT9gyFGE8RK7ZAI/eV3P+3DyZi+6Ys9tBbcs2MnnxCBDu6a5BR1U/sgwy5qhQIk95Z8aDIIiStI7dirUscARMX0KlOBV2OVTg6BVunw5wFum+H5LVbc4kGx946NX+ir9Wbpf0/Y19QmT0FLe2YJwAtH+WSJkdMK7ispXGXsuJ/2aVJSKNAHJPH7GPMl6SWUpjINCGKxti4cTdZtph6RTw3hn0y84WhFwQisRUjuCKRXvoNaJZ/4gfijFPFFy9HAMakQASx8EaKoRyAVtSdfvq2VmFhIRVhuWoJQfEEHXQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SwoGRCEXujtNCAVfUXllDy1puYRVo+jBQTv8P8E1QDZ1L+/atZwBUBmd4HE0?=
 =?us-ascii?Q?0CM/fserM/NPEs8RHjqvbXtiP6kNO++C2xu7QvGwCNmFk4SDlxvDIG4MLnxH?=
 =?us-ascii?Q?CESsdqA9smNSjfpANDioYSzWFwKP4GOKNc2KS4AgJ6LoWnfspGeAJRGd/ZWt?=
 =?us-ascii?Q?ahnCO3V7hr5+F4S+E7OoEJCa7mq8Ap52hF1/A+4mwx687A9uIvyA0Fiow1e/?=
 =?us-ascii?Q?eyMCj1/0mu35fu2RHkYDPVd1FZVMu+JuUEN+cVh2hi76ncY/ImEnoJHDcZy2?=
 =?us-ascii?Q?SQBjug5Q2Sp8HmDD/6MA9I/qADUuFNusKqeWp8fgyA48SMRKKkGmpXJuvDXl?=
 =?us-ascii?Q?XQQ2H4VnDzfk6jTbuZ0q6CbPFEg8hk4J+cUlKEwW2qz1kt6wJlDzGz/q/XtN?=
 =?us-ascii?Q?CQlZJ0TBxda/SKkR7sidJeYwQwzc4unf9m4p+4u/8fM/LSdt9smeG2m2npJ6?=
 =?us-ascii?Q?YWj8F1klxRsmNWfFHQd3AvzxM3idcRZ02ErRAcE8HbX1WMIplwK1hxTFGnSm?=
 =?us-ascii?Q?s2FfEq6mxhfOSwSedeFaO7zgday4mXOyQ9nsgxs0oRe02H1utqiSZWjwiWzd?=
 =?us-ascii?Q?HcGxGT9i6C208UGJU93g1W2BVKRBiHAnDBao3/scNCyXLorR4Rohsw0/W9DA?=
 =?us-ascii?Q?qNFL+sQtWi7llBTd2/pLK+GPaZlJuZQ0IJ45nThGYNlUpgWrAwndDtjm1pwE?=
 =?us-ascii?Q?FzGT8OGZxM9guR0p7916XW3+M5wMcWwr4Oe4C+R62fuc26VNYcdcWot4zyvA?=
 =?us-ascii?Q?phcFZj/rBM0qxj//iBXkt8++Oj2+/Kak8zwGWMEdDoEJsvxK8dPJ9Ja7hMJY?=
 =?us-ascii?Q?/mtr2pZaSEsM/cp2CsegemG3pljDoP8WMzIPZvVziKyK/6Of8MPYG9Y1m2sU?=
 =?us-ascii?Q?ZDTrHgzt/4GOn7rwkLkSLeepoplzLdyR16M+azZIU7xSliYWNrCgsUOVNgWJ?=
 =?us-ascii?Q?/EbDD4HulObVh8ahoAihreyksnXsb+O+C4BpGIflvf0Sw53b/uBDmH6ynBRm?=
 =?us-ascii?Q?97OkqXBv2I4WiAPHVLUZ48GMuP7Ha6q3Yzx7q4rN0/FSEcHDFqcnRUQKHTPS?=
 =?us-ascii?Q?QA2YsCC4Thk3iJXLK0+Gk9Cp9m33asGB+C50r91xqmPQruFmuQwHJCtinBma?=
 =?us-ascii?Q?XTfLGJ0nn11zDzoH1qA4rwbr5xCqCrWAgbRSQ1fEg9NZbHorAvdBV0rUuQ0o?=
 =?us-ascii?Q?VyMDEDWmZO6TJPa0jzgJ5iDbNsj8UEBkuSUgnQvzgAf4R8gMrnkptuJSo6ZE?=
 =?us-ascii?Q?n9Yv9p+bbh9A03miUiOWPzFGXxvuKjVSoVKyypsVf564uEOgDqSUL/YJuTeQ?=
 =?us-ascii?Q?oicN2pH1QuWBGRgGbh9G7hx/e+SxLGB4QrcsgC+na6cUlpvrHGC01KEb8Nzv?=
 =?us-ascii?Q?wtaFlNC4A4qwHvf1VGqGwyqmjOkkViIpKzrH7JY8k0LhaIbUiXdfWC6zCKlS?=
 =?us-ascii?Q?ea/+7RyY6FkI07WidnKi+FhkIvBv6dJAMIzqFJa3GzxvSrMGHiHUB6APkPC2?=
 =?us-ascii?Q?9F/bzDip3dgOL/6PXCyHQkeRn+VjOMWVQN/W+FUGoaPEHURcoHG5VWd1rBz7?=
 =?us-ascii?Q?S98kmkorgs53wVPtd/7l28WPGoZZg4d7D8srS5n3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dadbd176-7879-4a9b-6492-08dc5d4f02dc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2024 13:21:51.5032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zdwlj0kOL+D84O6OA5YiG/MrOJpm7Vq/3LJiBGhedy5UYNP3MMjqeoaKeVK1lCHhmhi5anX+uNYRhqyav+ZmFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6017
X-OriginatorOrg: intel.com

> 
>-	if (cpu_has_secondary_exec_ctrls())
>+	if (cpu_has_secondary_exec_ctrls()) {
> 		secondary_exec_controls_set(vmx, vmx_secondary_exec_control(vmx));
>+		if (secondary_exec_controls_get(vmx) &
>+		    SECONDARY_EXEC_EPT_VIOLATION_VE) {
>+			if (!vmx->ve_info) {

how about allocating ve_info in vmx_vcpu_create()? It is better to me because:

a. symmetry. ve_info is free'd in vmx_vcpu_free().
b. no need to check if this is the first call of init_vmcs(). and ENOMEM can
be returned on allocation failure.

>+				/* ve_info must be page aligned. */
>+				struct page *page;
>+
>+				BUILD_BUG_ON(sizeof(*vmx->ve_info) > PAGE_SIZE);
>+				page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>+				if (page)
>+					vmx->ve_info = page_to_virt(page);
>+			}
>+			if (vmx->ve_info) {
>+				/*
>+				 * Allow #VE delivery. CPU sets this field to
>+				 * 0xFFFFFFFF on #VE delivery.  Another #VE can
>+				 * occur only if software clears the field.
>+				 */
>+				vmx->ve_info->delivery = 0;

Is it necessary to reset ve_info->delivery to 0 given __GFP_ZERO?

>+				vmcs_write64(VE_INFORMATION_ADDRESS,
>+					     __pa(vmx->ve_info));

I think the logic here should just be:

		if (secondary_exec_controls_get(vmx) & SECONDARY_EXEC_EPT_VIOLATION_VE)
			vmcs_write64(VE_INFORMATION_ADDRESS, __pa(vmx->ve_info));

>+			} else {
>+				/*
>+				 * Because SECONDARY_EXEC_EPT_VIOLATION_VE is
>+				 * used only for debugging, it's okay to leave
>+				 * it disabled.
>+				 */
>+				pr_err("Failed to allocate ve_info. disabling EPT_VIOLATION_VE.\n");
>+				secondary_exec_controls_clearbit(vmx,
>+								 SECONDARY_EXEC_EPT_VIOLATION_VE);
>+			}
>+		}
>+	}
> 
> 	if (cpu_has_tertiary_exec_ctrls())
> 		tertiary_exec_controls_set(vmx, vmx_tertiary_exec_control(vmx));
>@@ -5200,6 +5243,12 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
> 	if (is_invalid_opcode(intr_info))
> 		return handle_ud(vcpu);
> 
>+	/*
>+	 * #VE isn't supposed to happen.  Block the VM if it does.
>+	 */
>+	if (KVM_BUG_ON(is_ve_fault(intr_info), vcpu->kvm))
>+		return -EIO;
>+
> 	error_code = 0;
> 	if (intr_info & INTR_INFO_DELIVER_CODE_MASK)
> 		error_code = vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
>@@ -7474,6 +7523,8 @@ void vmx_vcpu_free(struct kvm_vcpu *vcpu)
> 	free_vpid(vmx->vpid);
> 	nested_vmx_free_vcpu(vcpu);
> 	free_loaded_vmcs(vmx->loaded_vmcs);
>+	if (vmx->ve_info)
>+		free_page((unsigned long)vmx->ve_info);
> }
> 
> int vmx_vcpu_create(struct kvm_vcpu *vcpu)
>diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>index 65786dbe7d60..0da79a386825 100644
>--- a/arch/x86/kvm/vmx/vmx.h
>+++ b/arch/x86/kvm/vmx/vmx.h
>@@ -362,6 +362,9 @@ struct vcpu_vmx {
> 		DECLARE_BITMAP(read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
> 		DECLARE_BITMAP(write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
> 	} shadow_msr_intercept;
>+
>+	/* ve_info must be page aligned. */

this comment is not so useful. I think this should be placed above the call
of alloc_page().

>+	struct vmx_ve_information *ve_info;
> };
> 
> struct kvm_vmx {
>@@ -574,7 +577,8 @@ static inline u8 vmx_get_rvi(void)
> 	 SECONDARY_EXEC_ENABLE_VMFUNC |					\
> 	 SECONDARY_EXEC_BUS_LOCK_DETECTION |				\
> 	 SECONDARY_EXEC_NOTIFY_VM_EXITING |				\
>-	 SECONDARY_EXEC_ENCLS_EXITING)
>+	 SECONDARY_EXEC_ENCLS_EXITING |					\
>+	 SECONDARY_EXEC_EPT_VIOLATION_VE)
> 
> #define KVM_REQUIRED_VMX_TERTIARY_VM_EXEC_CONTROL 0
> #define KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL			\
>-- 
>2.43.0
>
>
>

