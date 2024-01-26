Return-Path: <kvm+bounces-7046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F19E183D314
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:54:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 695731F23A0B
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 03:54:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4D95AD59;
	Fri, 26 Jan 2024 03:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R5KJ7XKQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E18B8480;
	Fri, 26 Jan 2024 03:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=134.134.136.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706241280; cv=fail; b=LVjvo+RVEGWR7hHG9oZhfIQSQp7ulKMLT8sB1HCQqqbCZ6k/xqPkVxdA9wUjNoMeckGf6t4LFSZladoHABTY/Z/FH5MPVHDtmJf8ONf88P9lpDe3b0NJxrpgYYwmYhFrFxnwnmkJt4J7Mbqa59wrnuvVahmHf+yml+eB8siZXjs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706241280; c=relaxed/simple;
	bh=9TX1sRljLiofLBUy2V9PiqYusne+x16lbUorvD5KgMA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YNAEswsbzS5l7n/Lv7WIMGO6Dhycq3SButzk1DmX8zxd4Ky8Kcuzxy+NjYDMZHkDR1lTJ2+DxyqXz1uy99kUyipOrGawCzFCaJ2TL4TZiC3rZmu/gkhtOaiKxZcViFYv3WiA5F285y0BSeIeU9IBwc3cR34DTroIRgUGwBPmAxs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R5KJ7XKQ; arc=fail smtp.client-ip=134.134.136.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706241278; x=1737777278;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9TX1sRljLiofLBUy2V9PiqYusne+x16lbUorvD5KgMA=;
  b=R5KJ7XKQmbumY9QzQ03AZvwmpznnpXVkY+7LC/N4iMlPsc4TpPSqUGCc
   bm/kq6z0D7QRoZgrrTvwBmQG9UMOGwvwBCty4F1+/ZvB4eTpEuWrgeftZ
   i7BUnB0xuLLlQ+yvb7FAXERgKnEhzl6qv9VIuDIpiL5d37pQxn9Kzwke/
   P8j6aaTOwhFAXvFgk0AM9gNzFEgNHjhBpiZrdl8OD2Q+cLNSDMbPo7eCI
   QxXLVGEwLCYWFkVsKac5yqPaLfrXpQyrrO9LTuNWoajL9fmWKxGaQN9un
   0Yfn2oLrX/sBK5bIEFEp/1yFtT4cQzdWSD8hCLDqoyzu5ugU8RVAABE6J
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="406115928"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="406115928"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 19:54:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="21287167"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jan 2024 19:54:35 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Jan 2024 19:54:34 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Jan 2024 19:54:33 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Jan 2024 19:54:33 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Jan 2024 19:54:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GyXuQvwkJILYI1iTSL27ZFx5f53GAxzJ9cTnUmsnKg7sNTh+/GPOVe5I5sH3JDf2pyazYjwOgPLCFAJx3XLul3fYvKoYpGAVJ2IL8gQjowPfil3ub/DgqG+yBtShvBR89LTRU3DIWTafwyHBSx0YY3UYMoqKZCRdFYNq6NFKKfNIONVO45DuRHUWAvKOgPtrVc+7Fmi0YzQL9AtQs1LnH/9tkk8E+Qf64vL5pDmF9ISXEHiBlod/NUckyWz7fmIoEJJyRrTi8LaElaOr6jblyp1yE3yv7Bs9BsQVPVcaiyXXLUtvR2AAdyy2PQdOhylUCANDJJGOKJEXBx3RZswvjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=soVHfUFAOHjgbfEF0WBobg84cSqvfRKbK0KilhbNTO4=;
 b=TVRYrOmz3evVA/i+y8wV4M8bwfMTYCfj4E0uEKQr+7+AJ/Wznb9vMZqP5g74ZoS3O04EV8jnOAuy0y7gk77Csdi/0QJmVaQ6Hc39oG2aAwcHPXOd787bFaEaazgmeb9scBg1IUAl8emZcRrAq+GuExaB3xuqpmgBPqBGcJZhgOhCIFtxCNRPunx5Kdnh146YP7lgFQQTnEpX2YRLn7I83vG5eNACTdArESvU6MuZ46r9SRxURXLc/xSVK5JKM0pUXlY18GpfZESdeZdT1bclARnX3yyGvsIETwiYsP2UgrOGs99Nw4RZURvpILhn/wqDxdSZNOBH1Bn5tJpYL4rvnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8665.namprd11.prod.outlook.com (2603:10b6:8:1b8::6) by
 PH0PR11MB5659.namprd11.prod.outlook.com (2603:10b6:510:ea::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7228.27; Fri, 26 Jan 2024 03:54:26 +0000
Received: from DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::c66e:b76c:59ae:2c5d]) by DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::c66e:b76c:59ae:2c5d%7]) with mapi id 15.20.7228.027; Fri, 26 Jan 2024
 03:54:25 +0000
Date: Fri, 26 Jan 2024 11:54:16 +0800
From: Chao Gao <chao.gao@intel.com>
To: Yang Weijiang <weijiang.yang@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<yuan.yao@linux.intel.com>, <peterz@infradead.org>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>
Subject: Re: [PATCH v9 22/27] KVM: VMX: Set up interception for CET MSRs
Message-ID: <ZbMs6KsCWqE0fpQv@chao-email>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
 <20240124024200.102792-23-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240124024200.102792-23-weijiang.yang@intel.com>
X-ClientProxiedBy: SI2PR01CA0005.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::23) To DS0PR11MB8665.namprd11.prod.outlook.com
 (2603:10b6:8:1b8::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8665:EE_|PH0PR11MB5659:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ec9944f-9a14-4091-ef17-08dc1e227cf9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1HaOkNQ1LGw5s6jsDswehjggXKjJHToxApeniCHml8/qcyZTZBtSVta9qTx+Rzimlt2llx++9NOA6C8nqZiHbpjk2YsGCdrIjLT3dtc7Vx1Ph/C4+/wn5zK4vYOJSPEl7klJKfFFHJ5w6Vg+GnZ9ox7LUoXb9p/n4rdNC0oLMI6o/kahzCTrkXIefpLltql1wrg2Ni6hpsJ4t5Hiy+Hh5Xx3y1exvhYnFDafYMkGwxQ+YP07HHsJbai9PNurameoJhVHBdLWEV1/cmzw//CvFRJU/7l8h3iZUfhCitbWLcxRqiLcpkjOB9luXGXjp7Zdmv1/H6AaFlfBQhyEBQJ6SOmsZepmKO/IZlLXX574vJAKWMsusO4icdmbmbrVqf91R4ziWenJ3eac+2NhzJqJcr5hslhEJfRkRrL3YQlnGhbP/zgIbup3FCnhXBtY1PietVlC/pHZIYOBTd9HyfeMdHJCHZhR94se4+VVnC8H2wJP4L8GF2DUqt1aHI4NWuU43fFaKRPjrwYrJZYb4Jz7PpUNNXzODeaWXLIqQUN3XlCn3lrQMnTu147lAXeoSssI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8665.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(39860400002)(376002)(396003)(136003)(346002)(366004)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(33716001)(41300700001)(26005)(6486002)(6636002)(478600001)(66476007)(6512007)(9686003)(6506007)(6666004)(83380400001)(38100700002)(82960400001)(5660300002)(2906002)(44832011)(66556008)(66946007)(316002)(86362001)(8936002)(4326008)(8676002)(6862004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hvvjFvvCxHeO6My1TffOxQrjqnjUe5hjGgzdahun7FZ7SqqkBKxgxGcNOKGJ?=
 =?us-ascii?Q?3mVA7ihV6iL/DeVj9cQnHK/QaYCFZh8vyrE7hsCDKnTgaJbkSPQ/2nFE7s+R?=
 =?us-ascii?Q?t61weDnkApOjJWf2MB5eFK0v/O0/ns7jo6xoB3gAJ0d6WTW7am9qwQSdQKfD?=
 =?us-ascii?Q?85QbsXPbgTcz0s6r+vmvsehVeP7u1utCPU39C1qLbeeOx5S0Y9uSYAB2ZnmB?=
 =?us-ascii?Q?31ammxdiP0le5g0mVKcCII3Dv1hNlXRVKvDM7ouDRrHaO8FwFksFZoTDVU/a?=
 =?us-ascii?Q?2ACaNYWQh8zXmZKJ9Y5Np3D8zZ3TZASeoXZGMf6vhUpMRqMZAr+ymnNJb4VZ?=
 =?us-ascii?Q?yZ0T712sszOEfXRC5V82F8UugUdjjeMb6NocuaHVN8um6bUAFd4V5iLAjN23?=
 =?us-ascii?Q?gjIJhG/aC0lfFPxaiv+4QxwM7AuxNfkpQR+LpnfdG2yZlKZvsi5IOfZiXK0x?=
 =?us-ascii?Q?QZ1MU3qdTlDmv4nfrg2NtGifRKyEval+MPD8uG5xLUShPvbaz2AxCycc2Ggu?=
 =?us-ascii?Q?cEpf+VuukDLlDxIi1Zs3sihXuKaeGtjgFQbkG2UdO+raLMBlkyIwSyxsmInX?=
 =?us-ascii?Q?jhuSpY+lyA3Tox7Js3I1Q7g7OiJqZy2EcIKh40XuaVsFDR0R32aBYbZEAeqw?=
 =?us-ascii?Q?zO6vHTsSdSbEI3Nj3QXGbnL9giVF6p2LeT14TvsnNPy21PRLWLYEf0YkhCFh?=
 =?us-ascii?Q?oFqVDwMMW+nqbmSaZURtWwnTjjRRVO9gMgPb6N31nQoy3dkZLCmLAlroHVB6?=
 =?us-ascii?Q?b79uGB9+Rt4QBVIXNmTXj+cRhNnh0+x9kdIWVmMH7Ly8Fevhh79wfJs2heYc?=
 =?us-ascii?Q?J/SwGYD8I9FqspSG9ibu2vLDVm4fIb8bgIbXJTOk83muXLSkKct/dE2V7Ay1?=
 =?us-ascii?Q?HvgyaLMIT/wUDGKAtq6EKeZTf68UtSGVOx4piHcEsuF16OQN+Fz//EPNMKBG?=
 =?us-ascii?Q?+bDMIG3CwLdrgs1x71pL9RxQxf0pj2EvpqSeKtPdj1DOO74Rn7YC5yHTBtQR?=
 =?us-ascii?Q?a8lAGVUL88e/dlLsM3nySECniqpaWXkENKzw9HOYpRINjx/COqkBl6Jf5UIQ?=
 =?us-ascii?Q?YXOqalNutC4rXpY1ftqOkRvUIkzOYODPwTwDgpulcPv6WHo9S2CbZoWhhWFv?=
 =?us-ascii?Q?9yURezpPEYx08uaKnl1sRL3H7N4hBhR3czxoce5Yr9yJcK1QYmKE9pNQdo9o?=
 =?us-ascii?Q?4X3GUpXd8Ufbv78kILSBydZ1WAIuW9fyVSnZAg8PtjWXa6ogfiGGKpY8K47N?=
 =?us-ascii?Q?jrvx3cAAwWvXSySv7kJuJdNNUOHcrW34of2kEVywBACjQLtN+zeKmRfu4uGo?=
 =?us-ascii?Q?/gALPIk3INXT+i3HZM5Cr0lGdG8eVVWglOKRstp8SSSghoIBXe4OujgweRMd?=
 =?us-ascii?Q?y8USAMkr8PRdLjBDF/gmunWta9vzHWTva8he4s4nknqqoL8CjrwnF7QHjpdC?=
 =?us-ascii?Q?/gixQ3mSUIqtru8vVudpQvH3KBy9Gt4O/7EqqjoAo11KjnHMUngIdVSN7xhO?=
 =?us-ascii?Q?vbLFJG1wGtzlUW/ut+3mGDbEbEgxC5EKfNulS9dBwDUxIRVfBr5UMnXS2pJ0?=
 =?us-ascii?Q?h5VVmf65ZvDicy5X/D6ltWovcWWgt1LEGL0GTg8T?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ec9944f-9a14-4091-ef17-08dc1e227cf9
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8665.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 03:54:25.7429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RJmOHl0DVzR5ak/REVTNJ/sQUgmY910SuJamFsg7lPVt8XhlvtB/1SNPteIjEWAJlEHFM8v4d739HALBWElvSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5659
X-OriginatorOrg: intel.com

On Tue, Jan 23, 2024 at 06:41:55PM -0800, Yang Weijiang wrote:
>Enable/disable CET MSRs interception per associated feature configuration.
>Shadow Stack feature requires all CET MSRs passed through to guest to make
>it supported in user and supervisor mode while IBT feature only depends on
>MSR_IA32_{U,S}_CETS_CET to enable user and supervisor IBT.
>
>Note, this MSR design introduced an architectural limitation of SHSTK and
>IBT control for guest, i.e., when SHSTK is exposed, IBT is also available
>to guest from architectual perspective since IBT relies on subset of SHSTK
>relevant MSRs.
>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

one nit below,

>---
> arch/x86/kvm/vmx/vmx.c | 41 +++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 41 insertions(+)
>
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index 064a5fe87948..34e91dbbffed 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -692,6 +692,10 @@ static bool is_valid_passthrough_msr(u32 msr)
> 	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
> 		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
> 		return true;
>+	case MSR_IA32_U_CET:
>+	case MSR_IA32_S_CET:
>+	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
>+		return true;

Please update the comment above vmx_possible_passthrough_msrs[] to indicate CET
MSRs are also handled separately.

> 	}
> 
> 	r = possible_passthrough_msr_slot(msr) != -ENOENT;
>@@ -7767,6 +7771,41 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
> 		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
> }
> 
>+static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
>+{
>+	bool incpt;
>+
>+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
>+		incpt = !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
>+
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
>+					  MSR_TYPE_RW, incpt);
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
>+					  MSR_TYPE_RW, incpt);
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
>+					  MSR_TYPE_RW, incpt);
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
>+					  MSR_TYPE_RW, incpt);
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
>+					  MSR_TYPE_RW, incpt);
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP,
>+					  MSR_TYPE_RW, incpt);
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
>+					  MSR_TYPE_RW, incpt);
>+		if (!incpt)
>+			return;
>+	}
>+
>+	if (kvm_cpu_cap_has(X86_FEATURE_IBT)) {
>+		incpt = !guest_cpuid_has(vcpu, X86_FEATURE_IBT);
>+
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
>+					  MSR_TYPE_RW, incpt);
>+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
>+					  MSR_TYPE_RW, incpt);
>+	}
>+}
>+
> static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> {
> 	struct vcpu_vmx *vmx = to_vmx(vcpu);
>@@ -7845,6 +7884,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> 
> 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
> 	vmx_update_exception_bitmap(vcpu);
>+
>+	vmx_update_intercept_for_cet_msr(vcpu);
> }
> 
> static u64 vmx_get_perf_capabilities(void)
>-- 
>2.39.3
>

