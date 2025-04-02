Return-Path: <kvm+bounces-42423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79F60A78580
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 02:16:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3AFFD16E010
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 00:15:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5DC61EB39;
	Wed,  2 Apr 2025 00:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R81scety"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D2336D;
	Wed,  2 Apr 2025 00:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743552896; cv=fail; b=KySjTvdXbRww/xgvPOTEX63GVkTXrGxUMO3Y9zPOaAIFxiHOmAFTGGkCbJmOK2XOU2PoG5H6hNZW+PUZ2RlFkIE2SIEQv94GxUFS65OIczDwF97N2S6QUkQXr8FRQWOc8ky6erR7IGgLhgVbUDeNtPX8Y67Yi+4X2C6GWM6nrpo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743552896; c=relaxed/simple;
	bh=EkujmQck8XCufglemDSJL0/DpkkVLeNl200H9e6gOqw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RtIM8MRoDiINu0+AYsWJ/+XoVwZOXeqtLuPsaU+uW03tqYgHISQJjataCIkiWNkVn9SjYu5tN+kkbr3Sp+vVJPGgViFgQiRRcLb3teOw89tlr15USnUMwz2WaPuXJTS0teGoZbK0pAmFh1yMAVtDx3OF9u2q+Vb/PYMFjiE5OA8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R81scety; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743552895; x=1775088895;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=EkujmQck8XCufglemDSJL0/DpkkVLeNl200H9e6gOqw=;
  b=R81scetyPcv+ZFNRaYoUZ3OGOKbqRTs36nfIm05PePnneH6+7Yii+0bh
   8kHvF+0bJRAWXEGvUt7ycs1H3wuLTcfhvHLkmqvSDL6MomyXC6SQnjsH6
   7+3RlMaLIT0qUZtpOFc8y50RfpcpXDn8RLV3cqsA2yfD95MM0fDAgFbgh
   jXAzEkiEKobDi0Vjw60/S4TTU0/yNVDRuGUnfFxjT90g6C7DplfuRAgYQ
   7kN3KrMMnpIf9zhcE/e9i2JAvGuZSER8seuKBVD0aqBR8U7Pw3YRsyRwQ
   OxFsELDsYQWSaw9Vn43BO73+EMcipFIvxTX3cp/sumBpHw8vh2K0vs4qa
   Q==;
X-CSE-ConnectionGUID: B2tSzBMGSA6T/3CeP37Fvw==
X-CSE-MsgGUID: 9JZzfx9ES4Cz5Jml4zQazg==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="45021558"
X-IronPort-AV: E=Sophos;i="6.14,294,1736841600"; 
   d="scan'208";a="45021558"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 17:14:54 -0700
X-CSE-ConnectionGUID: jwHRvGqiSXqm0OoSbUTbGg==
X-CSE-MsgGUID: k3+jkZpvRgaSNlq0Yesu3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,294,1736841600"; 
   d="scan'208";a="131728864"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 17:14:53 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Tue, 1 Apr 2025 17:14:53 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 1 Apr 2025 17:14:53 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 1 Apr 2025 17:14:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rKric6k1LTTyzqZbU0OAWkVSFYICpMesvfnNETT4rRuXNqAaIsBvHAw6lXE91ARsEXkKXYzkThjCn0ncTBQ9toZcd/i9ZnsfLBP4opU+9CLVkTTJ6i07f1osBPiyGjVjJEm3rgowv8kWDhwhF0XScuzvz/PeZp/z7uaU+1O/LtRCKBaO53WYi/vGvwn6Y1DPpke9+EBLKMDFzIU1sijbDtrnsvRvABA5ahbkhoFZ2NxsrbgK3Mj5cwlZh9wkxa4U4xtq1VxqrSEiMjm7VJXS8LNDnVaB4M/aSVPxhqHvjT7sTdH0g6D+KETSbn5E9eZHRPcTNuhF8zaBI3RCd7ewzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VIx60LEngkKHpPqIC9KN1S/edt8j84qtlmJqHYrssOw=;
 b=cA0sIhDbXjBCgqwN94g29LBC+Xc9+xMeOAyAskaEihXFXBwEQa+Eg8CZSBb5LnJtVAiKsL1DR9E9dxsdV0833nS7sht3aW52jBBF+gfKQWkz0QxvNsaeY30HV/fQmWKjXbhdVRWlZ3xeZptcD3uws1aPeEYUfb3tzzJoIXozzVdDpPJJ0y9BqBSznBNSyu+eT02eJ16gnOMIElVOeWwu2961h8wpNUBV1Rv4iktNugzWdv8SMUDCk2oRELadwYg/pqRGgPqpzmDMQzAR/sOtNkOOcOcrAJfK3z6AldiLimEXLEL5PGp1/ofB179qJAq1DgO/Nw6qIbnI7dhM/X4XGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB6347.namprd11.prod.outlook.com (2603:10b6:208:388::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.44; Wed, 2 Apr 2025 00:14:50 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8534.043; Wed, 2 Apr 2025
 00:14:50 +0000
Date: Wed, 2 Apr 2025 08:13:14 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: Add a quirk to (not) honor guest PAT on CPUs
 that support self-snoop
Message-ID: <Z+yBGgoqv3dcgfg6@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250401221107.921677-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250401221107.921677-1-seanjc@google.com>
X-ClientProxiedBy: SI2PR04CA0015.apcprd04.prod.outlook.com
 (2603:1096:4:197::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB6347:EE_
X-MS-Office365-Filtering-Correlation-Id: 95064811-7de5-4346-fa77-08dd717b6287
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?tyyrzjVreaYFXOdxvHBPsI64rrb/V6sYmJk0aOIM2+/TngmxIEsqQFCPcmjW?=
 =?us-ascii?Q?4XW0qCN/xkVF6yHJspcmQSTz5Zijfmp8dl2iQEr9bZdVYuIozHFsxfCEfM6N?=
 =?us-ascii?Q?+V1msTPQ/I5GaZNosrlisRzMEqqK16T6oJJL1BWrgHfsZgo1IkWdPkiRgNxm?=
 =?us-ascii?Q?zNSFIdzq87F/GlPqlt1MJPahfjTVlknGYulK+7mLa4Fe1nrbGLZvbYX5Q92U?=
 =?us-ascii?Q?f68x/lj22MQ8DtmbabpFtDVXoYiZc38lcFn/FBxmy2lMv+poRyZSE6SlaiNj?=
 =?us-ascii?Q?a3JcN0hM5EgeVSc3WqINiCSHiShHD9XOD67+hNLrwbY+nJLcoueZUawpfcXF?=
 =?us-ascii?Q?AIqbE9VBlN4YNsfBOmcbxnKYHbwgLWN5yt/u01ebQB2cgVANEauSjm1rhUYH?=
 =?us-ascii?Q?PUOqb9bL2P/lDXThGLhpPsMFl4j1vGJAjguA1LflYghPvw3GVU7sspKpx9V9?=
 =?us-ascii?Q?U3AoistHPo0HxwKA+HyRKEHD+8Y/4x3YbEKd5Sbadt9SxqBGk52vgo6k/mRG?=
 =?us-ascii?Q?b8ekrdbkQESDq0Rk0Yib6R49uZxESiRxyX5wnHP7ssjExy13QjjO5xSgJR5Q?=
 =?us-ascii?Q?1GSrdYW2fnJnP/YWsoLyhDzK1iWqKauFF2rvNV7gSCo54Z3IVB3MDpKSfYyo?=
 =?us-ascii?Q?MeykoAxKOrPZwSqBDoYrEiXq36AFbPLtL+gSGC6nrz3c3xba6X9WZFaNvnWo?=
 =?us-ascii?Q?nfLlQ3KMWxJGt3O6Xwz7ZBDfoR4e241uAAuclFL3YZlz0hU9P2G6XbByE42q?=
 =?us-ascii?Q?I7XzNb22do/gLHSxkugUZyLyuN9/JMV1TNowAfnzs/H2i8RvIfwXDOD9NQ1K?=
 =?us-ascii?Q?IOr5svloLv1xK33UtW538pVD6wwUSsItWZGevZcfpB0cBhA1rhRlWwKR1MDB?=
 =?us-ascii?Q?x/3URrHkNn1oJNWpBZ18gdpMtfVV7Nb7aBG54teBtNsI71oLp2m3ccc1hNXk?=
 =?us-ascii?Q?uJkBsmFn/sLodELzcGcnkT4yod1yVKwEeeRHAfPmUnsJGGwYfjVwlBa+1kl2?=
 =?us-ascii?Q?uyJ62Uk1T+4dTZDEuJ/JpEF7tvQGM1oTnEJsz6BnsPXMcBEgpIEfJjgB7bO2?=
 =?us-ascii?Q?4Rb2okUMdMCxhKA6xegqtWMADoIBygKY+xXOFcYeD9H1vzMe6xY3pu+hg+UP?=
 =?us-ascii?Q?1y+EJbbexC1P5++qkMOW7GHWDrdhb0Dlj2z+A4vkQ/ikopIEKVNP/CgnaEAO?=
 =?us-ascii?Q?U8vuVp92mkaZidKSyhiLBAnvTEEKNidhJK1J+a44r5LXYruYSbNsRvuSCTCQ?=
 =?us-ascii?Q?SOSy+rYShOmDdSiYZblTX1M9Plz2Dr9RMVn3dOB9/O1k76vfXY5QUFL3mNSo?=
 =?us-ascii?Q?4DlUn4HhJUnashJM9FQoqXnmOKTWHLrA7jlleQfkLeQtFoiEroQiYGl3pfcS?=
 =?us-ascii?Q?cw0w2T1bTUfS8Np0DGWIvRcS5vx7vU3LFeWxErHA41qhbbXozQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2E1icgMMOlAVWCLaYFvnonXBFimskQOv4iHFYTQn/zUawLtRQBTFdCy26Uz5?=
 =?us-ascii?Q?nmtKuPUXj7RZkFrZahm5RA4esv/LB2MoFESBsbsl8yLuj+6hLpd41Rydo1q4?=
 =?us-ascii?Q?UElYmCAS+qPPn4KPVrif0Q27gfwgewMx4bGSumOzQeRSyj8Jt48dfpbmAViR?=
 =?us-ascii?Q?TnOh+ACq9aykxVFxMbrMY8JXsgmOd+rXyd8ALFND653j+zM4qDJ0ru1T+eQg?=
 =?us-ascii?Q?IEAV7T03HB/hhJbmilvpR6ZmK1YfSufF9gfpe+5wgY2Z4d67vAwiGTgIYGUo?=
 =?us-ascii?Q?EOthvG6FN4nQasTm/ITkEITU3/7qVGAWQWTSjX9Hmm0Jnw7IlylxOBN/bRF7?=
 =?us-ascii?Q?4lpmVhp/hd9PFGSq6NQqhtP9ZGuEo+BVCpT258NW+dvuH+oFKWlQbbWDupg2?=
 =?us-ascii?Q?hZf993f2eQHrMRZhr3uKe0PL/Dv8A4O6CPRWsJGL6OPq+4y0miM6Ty40W/8c?=
 =?us-ascii?Q?y/mQn+d1PwVFeb6JSBcgZ1cqXgk0Qy0p/Tl0q2F3qsTrLFBqx5qnzgcky8aV?=
 =?us-ascii?Q?M00YwvKBYFbvUjhjFJwODXb4rOSSMq/OHoc3ZLuTJ2aP8unMM+ErIbWqiR4A?=
 =?us-ascii?Q?T6RB6VtCUBf+yvyamwBjVsNWc6C9amW8Y+Pbowxyweinonpfqy8g7/ssIIO0?=
 =?us-ascii?Q?0k09vkxot6647sZYRisbLk33FhiR7QvYuZ/lnF1RzG4f92xSNgcIH9kaAGtz?=
 =?us-ascii?Q?3wXGbfFcVyfd85fI5M2LEOVSIuuO1nwYIwbf5eEIch7M9gYMBEqL3VNW6ZOh?=
 =?us-ascii?Q?LlDbbs7YMuzIkFt/Ybaq/a4cI4ZX1tOi8R0mN7OZ85h/p0lbzINoa/QYHVRZ?=
 =?us-ascii?Q?hZB3X+EKDqhcrBH2+QMTC3x39MiEOYe5RaUf/1ar8AGQT6B778h/ogmbczzb?=
 =?us-ascii?Q?IuHF3BASf6xJJqwJiC73FwJyC1ETkpSOFtOXaBHiCnk31Hzi6HyISyTASl9j?=
 =?us-ascii?Q?/PpUEb84+0A6c8HTwOoJ1o23kVXGBw2QF8GvOVgWk0nzGyIRayAuOOu1j0LZ?=
 =?us-ascii?Q?CMT/sJ342PcU+VMBRy/dM4PwltNcRfqDzrQYVqngxRK84ln+siVuLxvnl0uA?=
 =?us-ascii?Q?5K82srpDUhOQ1At0CfK6Zi0vbnkLbCBSu1zZ6xkRN4cbYbAd69Eju1DLQXTJ?=
 =?us-ascii?Q?k8fxQhekiCFaUE47yx7fXH4S6AdpmJFPjbIbm48Pu4D2RK1yQMakAi1+Pt4A?=
 =?us-ascii?Q?t32nD52hogvVvPIPnjHEN8cqtR+KA/NrffO6U6gTD/YCkJ7STpkOWaNXSrxm?=
 =?us-ascii?Q?GyfEefddYZOf4WoCfj18KwVWVjf21gkKOW9taQTeu05h93wH8ryMSY/ql/GR?=
 =?us-ascii?Q?HYX/wPhYX8mI0B87KzFg9rKW2wKvE4XA9Qjltft++66vJYOsJ+gLilY0WEUf?=
 =?us-ascii?Q?Mgd3PrTsfB9+2JoVuo06HEw2s7bQOT7weFn4pTmb0Sj4J4iUZ/umFmQWau3P?=
 =?us-ascii?Q?LKmfvuTOuaDk6cm9O8mdxz6bGfc7Pb8mc8ZQj+kvnY9ajNLBTbO+va+jKKCy?=
 =?us-ascii?Q?pn3YifaYuSKPJjgFh0wOWYz5DYD89BELlZTDcSNBhPfo36wj0+0zmfO1y0QM?=
 =?us-ascii?Q?c2tHcuzDwHLflcJZcUgIezm4tyVKGB40L+zdIBqB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 95064811-7de5-4346-fa77-08dd717b6287
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2025 00:14:50.6104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dyaoBFM4cH/EjAWJgDDEQrwixFxqNjcZCP1adoQ3Vy6RupQpPr0Ga90pOkWBRRak7nkDBgE9ujrei84vlqOOWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6347
X-OriginatorOrg: intel.com

On Tue, Apr 01, 2025 at 03:11:07PM -0700, Sean Christopherson wrote:
> Add back support for honoring guest PAT on Intel CPUs that support self-
> snoop (and don't have errata), but guarded by a quirk so as not to break
> existing setups that subtly relied on KVM forcing WB for synthetic
> devices.
> 
> This effectively reverts commit 9d70f3fec14421e793ffbc0ec2f739b24e534900
> and reapplies 377b2f359d1f71c75f8cc352b5c81f2210312d83, but with a quirk.
> 
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>
Hi Sean,

> AFAIK, we don't have an answer as to whether the slow UC behavior on CLX+
> is working as intended or a CPU flaw, which Paolo was hoping we would get
We did answer the slow UC behavior is working as intended at [1].

"After consulting with CPU architects,
 it's told that this behavior is expected on ICX/SPR Xeon platforms due to
 the snooping implementation."

Paolo then help update the series to v2 [2] /v3 [3].

Did you overlook those series, or is there something I missed?

Thanks
Yan

[1] https://lore.kernel.org/all/20250224070716.31360-1-yan.y.zhao@intel.com/
[2] https://lore.kernel.org/all/20250301073428.2435768-1-pbonzini@redhat.com/
[3] https://lore.kernel.org/all/20250304060647.2903469-1-pbonzini@redhat.com/
> before adding a quirk.  But I don't want to lose sight of honoring guest
> PAT, nor am I particularly inclined to force end users to wait for a
> definitive answer on hardware they may not even care about.


> 
>  Documentation/virt/kvm/api.rst  | 25 +++++++++++++++++++++++++
>  arch/x86/include/asm/kvm_host.h |  3 ++-
>  arch/x86/include/uapi/asm/kvm.h |  1 +
>  arch/x86/kvm/mmu.h              |  2 +-
>  arch/x86/kvm/mmu/mmu.c          | 17 +++++++++++++----
>  arch/x86/kvm/vmx/vmx.c          | 11 +++++++----
>  arch/x86/kvm/x86.c              |  2 +-
>  7 files changed, 50 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 1f8625b7646a..2a1444d99c37 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8158,6 +8158,31 @@ KVM_X86_QUIRK_STUFF_FEATURE_MSRS    By default, at vCPU creation, KVM sets the
>                                      and 0x489), as KVM does now allow them to
>                                      be set by userspace (KVM sets them based on
>                                      guest CPUID, for safety purposes).
> +
> +KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT  By default, on Intel CPUs with TDP (EPT)
> +                                    enabled, KVM ignores guest PAT unless the
> +                                    VM has an assigned non-coherent device,
> +                                    even if it is entirely safe/correct for KVM
> +                                    to honor guest PAT.  When this quirk is
> +                                    disabled, and the host CPU fully supports
> +                                    selfsnoop (isn't affected by errata), KVM
> +                                    honors guest PAT for all VMs.
> +
> +                                    The only _known_ issue with honoring guest
> +                                    PAT is when QEMU's Bochs VGA is exposed to
> +                                    a VM on Cascade Lake and later Intel server
> +                                    CPUs, and the guest kernel is running an
> +                                    outdated driver that maps video RAM as UC.
> +                                    Accessing UC memory on the affected Intel
> +                                    CPUs is an order of magnitude slower than
> +                                    previous generations, to the point where
> +                                    the access latency prevents the guest from
> +                                    booting.  This quirk can likely be disabled
> +                                    if the above do not hold true.
> +
> +                                    Note, KVM always honors guest PAT on AMD
> +                                    CPUs when TDP (NPT) is enabled.  KVM never
> +                                    honors guest PAT when TDP is disabled.
>  =================================== ============================================
>  
>  7.32 KVM_CAP_MAX_VCPU_ID
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a884ab544335..427b906da5cc 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2409,7 +2409,8 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
>  	 KVM_X86_QUIRK_FIX_HYPERCALL_INSN |	\
>  	 KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS |	\
>  	 KVM_X86_QUIRK_SLOT_ZAP_ALL |		\
> -	 KVM_X86_QUIRK_STUFF_FEATURE_MSRS)
> +	 KVM_X86_QUIRK_STUFF_FEATURE_MSRS |	\
> +	 KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT)
>  
>  /*
>   * KVM previously used a u32 field in kvm_run to indicate the hypercall was
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 460306b35a4b..074e2b74e68c 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -441,6 +441,7 @@ struct kvm_sync_regs {
>  #define KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS	(1 << 6)
>  #define KVM_X86_QUIRK_SLOT_ZAP_ALL		(1 << 7)
>  #define KVM_X86_QUIRK_STUFF_FEATURE_MSRS	(1 << 8)
> +#define KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT	(1 << 9)
>  
>  #define KVM_STATE_NESTED_FORMAT_VMX	0
>  #define KVM_STATE_NESTED_FORMAT_SVM	1
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 050a0e229a4d..639264635a1a 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -231,7 +231,7 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  	return -(u32)fault & errcode;
>  }
>  
> -bool kvm_mmu_may_ignore_guest_pat(void);
> +bool kvm_mmu_may_ignore_guest_pat(struct kvm *kvm);
>  
>  int kvm_mmu_post_init_vm(struct kvm *kvm);
>  void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 63bb77ee1bb1..16c64e80d946 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4835,18 +4835,27 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
>  }
>  #endif
>  
> -bool kvm_mmu_may_ignore_guest_pat(void)
> +bool kvm_mmu_may_ignore_guest_pat(struct kvm *kvm)
>  {
>  	/*
> -	 * When EPT is enabled (shadow_memtype_mask is non-zero), and the VM
> +	 * When EPT is enabled (shadow_memtype_mask is non-zero), the CPU does
> +	 * not support self-snoop (or is affected by an erratum), and the VM
>  	 * has non-coherent DMA (DMA doesn't snoop CPU caches), KVM's ABI is to
>  	 * honor the memtype from the guest's PAT so that guest accesses to
>  	 * memory that is DMA'd aren't cached against the guest's wishes.  As a
>  	 * result, KVM _may_ ignore guest PAT, whereas without non-coherent DMA,
> -	 * KVM _always_ ignores guest PAT (when EPT is enabled).
> +	 * KVM _always_ ignores or honors guest PAT, i.e. doesn't toggle SPTE
> +	 * bits in response to non-coherent device (un)registration.
> +	 *
> +	 * Due to an unfortunate confluence of slow hardware, suboptimal guest
> +	 * drivers, and historical use cases, honoring self-snoop and guest PAT
> +	 * is also buried behind a quirk.
>  	 */
> -	return shadow_memtype_mask;
> +	return (!static_cpu_has(X86_FEATURE_SELFSNOOP) ||
> +		kvm_check_has_quirk(kvm, KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT)) &&
> +	       shadow_memtype_mask;
>  }
> +EXPORT_SYMBOL_GPL(kvm_mmu_may_ignore_guest_pat);
>  
>  int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b70ed72c1783..734db162cab3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7730,11 +7730,14 @@ u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>  
>  	/*
>  	 * Force WB and ignore guest PAT if the VM does NOT have a non-coherent
> -	 * device attached.  Letting the guest control memory types on Intel
> -	 * CPUs may result in unexpected behavior, and so KVM's ABI is to trust
> -	 * the guest to behave only as a last resort.
> +	 * device attached, and either the CPU doesn't support self-snoop or
> +	 * KVM's quirk to ignore guest PAT is enabled.  Letting the guest
> +	 * control memory types on Intel CPUs without self-snoop may result in
> +	 * unexpected behavior, and so KVM's (historical) ABI is to trust the
> +	 * guest to behave only as a last resort.
>  	 */
> -	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
> +	if (kvm_mmu_may_ignore_guest_pat(vcpu->kvm) &&
> +	    !kvm_arch_has_noncoherent_dma(vcpu->kvm))
>  		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
>  
>  	return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c841817a914a..4a94eb974f0d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13528,7 +13528,7 @@ static void kvm_noncoherent_dma_assignment_start_or_stop(struct kvm *kvm)
>  	 * (or last) non-coherent device is (un)registered to so that new SPTEs
>  	 * with the correct "ignore guest PAT" setting are created.
>  	 */
> -	if (kvm_mmu_may_ignore_guest_pat())
> +	if (kvm_mmu_may_ignore_guest_pat(kvm))
>  		kvm_zap_gfn_range(kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
>  }
>  
> 
> base-commit: 782f9feaa9517caf33186dcdd6b50a8f770ed29b
> -- 
> 2.49.0.504.g3bcea36a83-goog
> 

