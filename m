Return-Path: <kvm+bounces-48659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA299AD027D
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 14:45:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 002093AF013
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 12:44:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09385288C2E;
	Fri,  6 Jun 2025 12:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ILxdDoDO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BACD28851F
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 12:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749213908; cv=fail; b=f+36yWzVNfW15cOJF8lavyUcjBsxVhma6wy6OZcsWz/0N0euJkF1dbWdwoUwPmM75yrwlkywg9LdjlueBWgwDD/D5s8KDCDSZ1uJAPKqU+Cp3LfYWZaaLzt5XGrlgGpSoGK2M4Bv3UpTAi4JoJDQrXjXF3HvkSRzSD3nP0k0QWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749213908; c=relaxed/simple;
	bh=pmZABIrPisnCnzcIvFNXjxDV7yWHQBwFYEt9z1JPY44=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GxEDFnELJZBZWYOEpHL7+FE9E/Pa1x0Gh64lpd3FlfoOxeKzAs9iIXEI1+glmuGzpDsYeTGA8IO9ebav5NdY3WL7AOWp+TZpzLrdS3WoZFlhOj8ssdJKsxQ8rB0TanwsoHukP/Bk6j5pLuqgol9IDbAtQK1MBoWS25P8/fy5eyw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ILxdDoDO; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749213906; x=1780749906;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=pmZABIrPisnCnzcIvFNXjxDV7yWHQBwFYEt9z1JPY44=;
  b=ILxdDoDOv1dVCibE1BwvphOAPEf18FxE8Mu5tuRUOgb7R71rFrc/WLPG
   QjyNH/OTdubKtPvzZWltAns7sIcDdK9m2FCwMkOPzP87Zz1S3vjU7QM+t
   Lmc45vih5n0NQ3aD5aoImu9zYXt2ykgIx+cSsGulp7syc2dxkT9ub5yqd
   Y1S/EqiAHDMMGMJ3lilkRN2ljasdNHkjtIczep9ylUKwTskLKQzM+AkNO
   8iJiNbELEThi3vyjZEHQuutY73CGbcCTzge+BSiXIXhy+B584uViZNuUI
   6F4CGfIYAYQmRH8rmG/Z6F2DPf1j5aGLGnJyCw1ta9hlR2v5MuDFHmkAV
   g==;
X-CSE-ConnectionGUID: LzFgyGknSzSAYd45Hxqg0A==
X-CSE-MsgGUID: vdbSbqioS4WhdDr7zT8GPA==
X-IronPort-AV: E=McAfee;i="6800,10657,11456"; a="62408589"
X-IronPort-AV: E=Sophos;i="6.16,215,1744095600"; 
   d="scan'208";a="62408589"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2025 05:45:05 -0700
X-CSE-ConnectionGUID: U/n3ShSMQzqnwqmVIVVWPQ==
X-CSE-MsgGUID: r1Qsbqe2SmuUsGVFjOQfAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,215,1744095600"; 
   d="scan'208";a="176769998"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2025 05:45:05 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 6 Jun 2025 05:45:04 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 6 Jun 2025 05:45:04 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.61) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 6 Jun 2025 05:45:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IuN4gv3fTXZQw1MrvlbY4Rhu7CEJcK7GtLgstFcHPov8mMcs5znd39gP7VcWzyCrHEMW4Qz8cnjYs7L6qWjweQphXIC9tMHEYOVeRGwOjAEa6UaeLOWG4XFlN4nXR1xs7C17MZlxqi9j++G8Gxhtue2lY+vpy5wAhQc7BDGD8mt6VduUicU7qK5dVdQ3fDz5PRp7kefvmHH7fOBQ81GC7zXLxKpgMthNmRz3tuu3rzbteW1Y5pYipPsIGxcYtbfkeaDfi2MkPrJkujNch/JJEqUZPE9vCe1BfZOFKwmTkWqEROz51aeP51cSmvFCC9EnevA0ZN998QK57gqrmm5HSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Np+UhOXvfVDWVVK3aCY2WKRecFB4nZQ/j67IT4H8ta0=;
 b=UV6upGB8a6s1ZHBKCcE1lQBVksO3g9Xeo7rdp9Uhraf4N5keBzpuBpnvKSyV/fUk1LCimW0lvkzE8OjznnLwdgxTGIOHHfZfY73hzKYcdVGPn1i11ggoPN7u3B5M8okW0Q9QZvkvjA2eE3BhoAXv4G49Wt3Mw/DV+olwORp9oS1HnrP+cO/0DjGSNo5SdlV2YI0GSk3lMHl8L/RNWyuW2uxaPZWaUfd10z9QHxpm6FPbel+ckk1srAQJkYFVrlrAh6Kw2K6ZMi1s6M5O+vRBrLZVWCk8wIi4pV6TeioDKBc+jL3sRdvDsSj/viffIvUkn3p2z08yEJoC8ofyFCFW/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA1PR11MB6784.namprd11.prod.outlook.com (2603:10b6:806:24c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.22; Fri, 6 Jun
 2025 12:45:02 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8813.020; Fri, 6 Jun 2025
 12:45:01 +0000
Date: Fri, 6 Jun 2025 20:44:53 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 2/3] x86/msr: Add a testcase to verify
 SPEC_CTRL exists (or not) as expected
Message-ID: <aELixaeTRl+BcfcH@intel.com>
References: <20250605192643.533502-1-seanjc@google.com>
 <20250605192643.533502-3-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250605192643.533502-3-seanjc@google.com>
X-ClientProxiedBy: SG2PR04CA0216.apcprd04.prod.outlook.com
 (2603:1096:4:187::18) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA1PR11MB6784:EE_
X-MS-Office365-Filtering-Correlation-Id: 681e9327-fb3d-4544-9555-08dda4f7f3cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?HkCevYK4ZtYGiDXNA1cz+5blO2TeiVa5HU4w5rAgCw/rlhz0CPHTeBb+iEVJ?=
 =?us-ascii?Q?0MeG1pBSgxMRM7SthXe6JZpS338uUN/RAdVN0VYEbEzwhy5wCJun+MU2W7gU?=
 =?us-ascii?Q?jogbB91anFUhMzh4iGEvYW8eiwfMs4GlOkbM1Bv20goun6laWM6jM4x3ZPx8?=
 =?us-ascii?Q?3Ho+hxyOBI62oyrTqhlM5BoKbl5aOWdE95S97q7gMsuFdYV+49rt0gEVyV5r?=
 =?us-ascii?Q?7AWNmxQ93A1tqKJx8WbypGqw0HBVs1ybeph4vEtZXta+HUYvBFLsFz1JVW/g?=
 =?us-ascii?Q?twmy/8znaRLGelSa1DDir7zbaRRBT+K+0Dd613Q9fl8KzX+gcKc61gtxi4CC?=
 =?us-ascii?Q?2dR42bgWJbSuunW3eqckc+0a6rGbrfvQiFqzWGwAhIQZfNFpXG69HhYE9XR2?=
 =?us-ascii?Q?hECNSDJyfhsFCa5iSK+laqMZQc1k58Y1OK4MmPXgRdOLjetxWDTf4xy5bylG?=
 =?us-ascii?Q?6GIkMnaQVrsiTyaeeXI943OUiUgDeKkPCr83B/zsCWcnoyboa8QddQyOTnK6?=
 =?us-ascii?Q?hQG0HIGLNu29iXzFUDYuWCoIasxvTXeOpQAWUwhuPvlc0lbNPZur/qyfTjs2?=
 =?us-ascii?Q?TcIdkhs/z7PU1JrTsEwHGnXXeqlNrGSTTgK/9vXHOnjGxNvGDVVCkkVEhdej?=
 =?us-ascii?Q?6sH8tnHgbYaVjAZHkW8S0GPhN8nZ8rFXTuNTjQsAGm4x2lQ6kln6QllfC+yA?=
 =?us-ascii?Q?ry4qn2YRVImMz63GoG0p5zrXG/nWBz374fICKfkmctSV0CZN4l+CSwHnIK26?=
 =?us-ascii?Q?eDx1qgFpNtFrtbfAyEek6BBulCnO6qdWId1zMfj/q1lv5pbBNBxDQL/1Psju?=
 =?us-ascii?Q?k8QIK7fR/BUpItUgRJx854fmtQ0QWC/Xbj3bEH7Ireis4CgbLNlVcXcW0akG?=
 =?us-ascii?Q?mxVS1/CPM0xKtClWrBxs1EbELs0DQYlLa1+LVV3o/4TQcwNWNPAePzBv1nAK?=
 =?us-ascii?Q?ujQ04dPKnlbMff+19mhcVV1SoKuRpCH9uCqjk3B81ELsdPKbh43jx+RmI1Ms?=
 =?us-ascii?Q?ShTKU53VjPjqBgcLdEGZve41OUo+zfcokkl8zB30cjiiUOJneTVvEd24w/3v?=
 =?us-ascii?Q?m01lNzYi+xd6JFEUb2xg9TRVklzThdQvhWwQgldXcZj8ZG9CPsMpbgAyXfo1?=
 =?us-ascii?Q?CdqvDaFamqzQqqvpTkkm2Y+w0qw1eX7GX7YQlvZFjWDsvaRshg/C7foV5uZb?=
 =?us-ascii?Q?eclkrECFdn+r9XDHwynrYL3zVfFHdTHottgDoWgsl5Sa7J0LHR8s9rYwi9Gy?=
 =?us-ascii?Q?d9GVLJZkHK7NPAnTrZIEvJTZVlzKCrXzdGMvQc5WaLfv2gPlpIABm+KgIKpu?=
 =?us-ascii?Q?1WWDWzUBAjAfKfNxaNUb+4H96yrvoizWV6jUG8xxf/YudF+cSPH9bSX2tU+8?=
 =?us-ascii?Q?5Jp5MQnM3fFX9VlUFJIw9PoMWSyCmzYfW/bU6D2WbgnqEkrABg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x0hvw5wzpsM1HQevvdrWmerQ27LmgMYqCrlFD4JGrttlhG/JB2VWKtzwzXgz?=
 =?us-ascii?Q?IgTHgoW/K6Osa22guyzwuv18qmaaV8/NOOY9kAVBRPYHlYHOcYZm61n+oEAp?=
 =?us-ascii?Q?y4cCGyc4nyZdLsH0H8dpqFNUJgktXnHj6MfQSFIgHy+8L6xgxKqkE8OclJph?=
 =?us-ascii?Q?BjUlc9wsuwRMEyufg+mBQ1yAbd96whysVhcfavi/QmiFAu8wuFhvWjFJQFIm?=
 =?us-ascii?Q?7l94T660WEXwASw6nwE4xiu6pviZSlzwyLg2NS53RVxDYLMZjNwmhL1vAH5Y?=
 =?us-ascii?Q?/Rv0RW3AaoQ48wiyiBmk6OBxFGQkkMlHDG5hNJj2cavVoo/YVzo9wX/nVr6o?=
 =?us-ascii?Q?DhPjXMplrqm9WBU2VBwtHDYbaQv0nCMeXpL6aZXKnkjJGSQohgSkl91H9Ery?=
 =?us-ascii?Q?LGLuohUqIQGR9FKYs6NK3oBy/acxsAEJOdJsAhwGQP0VY5JRMeIft9yEgzmZ?=
 =?us-ascii?Q?04Hw13U2eWkzLqNG62RZM7PnsLVPjqrVknyUwqU+EVul2VRp9RixNy22gDhB?=
 =?us-ascii?Q?7aegQmiz9KzwdPk2UFJ5o8zq0xfCAg0Ned/ozu7JzbHuyK6qyeaCvRMeI47p?=
 =?us-ascii?Q?yBTZwNXJ1sEpjBP79KT90tUkaX+i8g+2Mnnb+5E7jArt0ygTL7HJ44mZWYGy?=
 =?us-ascii?Q?CBdmrznRQn9xxUwVxZZOd8lueK4CC8jeDuUcJYtNEBaTlGRW/gfOGe3lJrWB?=
 =?us-ascii?Q?aco/cW2bhggFooTiI3JAd5Btv/FtquuFK54DvTdsWRWPx39acBeK/eXEA1jN?=
 =?us-ascii?Q?cLzzuy9CHNrZLH/FiDZ5OcnSLPU4wWf1tCpi/mhUEYWFLHQ9M2rbH92ngyIp?=
 =?us-ascii?Q?DIKyHBl1aEQMeDCbfSH3KIdHA2w/Br8YPV+Nytkb8odbvIevl4zZR48WJRoJ?=
 =?us-ascii?Q?kr9pw+MOf3QTzOifKfD2INcONOmLEskoe1PJYzlKRBa2wPBEaruSvgRytsFq?=
 =?us-ascii?Q?rkVikMk4H+b4pkmLqsXUFB1/x1Db7bx4TeDI3hCgcEbjA1eCQ0qy6KSVhu3D?=
 =?us-ascii?Q?22jIl1fYARWY30e8QM6jbo6IMrVM2yMyaVbCyyEp98nUk23SohfBMc2NS1JR?=
 =?us-ascii?Q?GgtQUM2Z7WKdDTiMNe0wcog1D6sRmdlvqVJL7xxdGaT1/1DjYAAYBkO4ef+c?=
 =?us-ascii?Q?yCE8IbvTVPjn7vXgBXaOTTbckbJDbdIHyd/xf2H5juvZi24JXpaoC9zu4K0I?=
 =?us-ascii?Q?jEAfIZ9PVtbb+xLHadVHGjrDTrFqHAmbDr0PKMg88t8NYZerkY5kuMFuSFuF?=
 =?us-ascii?Q?MY72oTHtqhBJkNsxe1/pdLpmXEvw4qiHAMjncJl1ZpIS9vsym5a+PUuMigyS?=
 =?us-ascii?Q?n4vpsIC9WSvik/upaOO4Iee/DEusuFdEWN7sIIv5Y1zsIOCrgOhU2u0A+hiU?=
 =?us-ascii?Q?dqpmiLOgDZ3hnT2X2KlqfoCMawtbmrNSK5iBT1QQ1IBHEekIydvcNEKVdmgD?=
 =?us-ascii?Q?1XD23KksVb82IP/+iDCmpM2Ltq3CzZ0YmDF3oV1FxokVbwgFetuBSeqAbizh?=
 =?us-ascii?Q?mOd4396/V1hyhYpJSRLmAwMaTBfF8dsCzyGWpOlOnW78u6IjPC+rTnnZEO3B?=
 =?us-ascii?Q?epv+pRht7tYqzVPfymxGpIX5Ml3vHVsb9A+winYL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 681e9327-fb3d-4544-9555-08dda4f7f3cb
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2025 12:45:01.2238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lulsG5aTULK+GAI4HR9LLXRDNKetTv8r6lZ3lJuS8LEUXltFh5AXqAcJIG1gZsAqynysscBijgm0Cb4i99/9TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6784
X-OriginatorOrg: intel.com

On Thu, Jun 05, 2025 at 12:26:42PM -0700, Sean Christopherson wrote:
>Verify that SPEC_CTRL can be read when it should exist, #GPs on all reads
>and writes does not exist, and that various bits can be set when they're
>supported.
>
>Opportunistically define more AMD mitigation features.
>
>Cc: Chao Gao <chao.gao@intel.com>
>Signed-off-by: Sean Christopherson <seanjc@google.com>
>---
> lib/x86/msr.h       |  8 ++++++--
> lib/x86/processor.h |  9 +++++++--
> x86/msr.c           | 31 +++++++++++++++++++++++++++++--
> 3 files changed, 42 insertions(+), 6 deletions(-)
>
>diff --git a/lib/x86/msr.h b/lib/x86/msr.h
>index ccfd6bdd..cc4cb855 100644
>--- a/lib/x86/msr.h
>+++ b/lib/x86/msr.h
>@@ -32,8 +32,12 @@
> #define EFER_FFXSR		(1<<_EFER_FFXSR)
> 
> /* Intel MSRs. Some also available on other CPUs */
>-#define MSR_IA32_SPEC_CTRL              0x00000048
>-#define MSR_IA32_PRED_CMD               0x00000049
>+#define MSR_IA32_SPEC_CTRL		0x00000048
>+#define SPEC_CTRL_IBRS			BIT(0)
>+#define SPEC_CTRL_STIBP			BIT(1)
>+#define SPEC_CTRL_SSBD			BIT(2)
>+
>+#define MSR_IA32_PRED_CMD		0x00000049
> #define PRED_CMD_IBPB			BIT(0)
> 
> #define MSR_IA32_FLUSH_CMD		0x0000010b
>diff --git a/lib/x86/processor.h b/lib/x86/processor.h
>index 9e3659d4..cbfaa018 100644
>--- a/lib/x86/processor.h
>+++ b/lib/x86/processor.h
>@@ -288,13 +288,13 @@ struct x86_cpu_feature {
> #define	X86_FEATURE_LA57		X86_CPU_FEATURE(0x7, 0, ECX, 16)
> #define	X86_FEATURE_RDPID		X86_CPU_FEATURE(0x7, 0, ECX, 22)
> #define	X86_FEATURE_SHSTK		X86_CPU_FEATURE(0x7, 0, ECX, 7)
>+#define	X86_FEATURE_PKS			X86_CPU_FEATURE(0x7, 0, ECX, 31)
> #define	X86_FEATURE_IBT			X86_CPU_FEATURE(0x7, 0, EDX, 20)
> #define	X86_FEATURE_SPEC_CTRL		X86_CPU_FEATURE(0x7, 0, EDX, 26)
> #define	X86_FEATURE_FLUSH_L1D		X86_CPU_FEATURE(0x7, 0, EDX, 28)
> #define	X86_FEATURE_ARCH_CAPABILITIES	X86_CPU_FEATURE(0x7, 0, EDX, 29)
>-#define	X86_FEATURE_PKS			X86_CPU_FEATURE(0x7, 0, ECX, 31)
>+#define X86_FEATURE_SSBD		X86_CPU_FEATURE(0x7, 0, EDX, 31)

nit: looks adding a tab after "#define" is the convention in this file

> #define	X86_FEATURE_LAM			X86_CPU_FEATURE(0x7, 1, EAX, 26)
>-
> /*
>  * KVM defined leafs
>  */
>@@ -312,6 +312,11 @@ struct x86_cpu_feature {
> #define	X86_FEATURE_LM			X86_CPU_FEATURE(0x80000001, 0, EDX, 29)
> #define	X86_FEATURE_RDPRU		X86_CPU_FEATURE(0x80000008, 0, EBX, 4)
> #define	X86_FEATURE_AMD_IBPB		X86_CPU_FEATURE(0x80000008, 0, EBX, 12)
>+#define	X86_FEATURE_AMD_IBRS		X86_CPU_FEATURE(0x80000008, 0, EBX, 14)
>+#define X86_FEATURE_AMD_STIBP		X86_CPU_FEATURE(0x80000008, 0, EBX, 15)
>+#define X86_FEATURE_AMD_STIBP_ALWAYS_ON	X86_CPU_FEATURE(0x80000008, 0, EBX, 17)
>+#define X86_FEATURE_AMD_IBRS_SAME_MODE	X86_CPU_FEATURE(0x80000008, 0, EBX, 19)
>+#define X86_FEATURE_AMD_SSBD		X86_CPU_FEATURE(0x80000008, 0, EBX, 24)

ditto

> #define	X86_FEATURE_NPT			X86_CPU_FEATURE(0x8000000A, 0, EDX, 0)
> #define	X86_FEATURE_LBRV		X86_CPU_FEATURE(0x8000000A, 0, EDX, 1)
> #define	X86_FEATURE_NRIPS		X86_CPU_FEATURE(0x8000000A, 0, EDX, 3)
>diff --git a/x86/msr.c b/x86/msr.c
>index ac12d127..ca265fac 100644
>--- a/x86/msr.c
>+++ b/x86/msr.c
>@@ -290,10 +290,37 @@ static void test_x2apic_msrs(void)
> 	__test_x2apic_msrs(true);
> }
> 
>-static void test_cmd_msrs(void)
>+static void test_mitigation_msrs(void)
> {
>+	u64 spec_ctrl_bits = 0, val;
> 	int i;
> 
>+	if (this_cpu_has(X86_FEATURE_SPEC_CTRL) || this_cpu_has(X86_FEATURE_AMD_IBRS))
>+		spec_ctrl_bits |= SPEC_CTRL_IBRS;
>+
>+	if (this_cpu_has(X86_FEATURE_SPEC_CTRL) || this_cpu_has(X86_FEATURE_AMD_STIBP))
>+		spec_ctrl_bits |= SPEC_CTRL_STIBP;

CPUID.(EAX=07H, ECX=0):EDX[26] enumerates IBRS and IBPB support, but it doesn't
enumerate STIBP support. EDX[27] does.

Aside from this, the patch looks good to me.

Reviewed-by: Chao Gao <chao.gao@intel.com>

>+
>+	if (this_cpu_has(X86_FEATURE_SSBD) || this_cpu_has(X86_FEATURE_AMD_SSBD))
>+		spec_ctrl_bits |= SPEC_CTRL_SSBD;
>+
>+	if (spec_ctrl_bits) {
>+		for (val = 0; val <= spec_ctrl_bits; val++) {
>+			/*
>+			 * Test only values that are guaranteed not to fault,
>+			 * virtualization of SPEC_CTRL has myriad holes that
>+			 * won't be ever closed.
>+			 */
>+			if ((val & spec_ctrl_bits) != val)
>+				continue;
>+
>+			test_msr_rw(MSR_IA32_SPEC_CTRL, "SPEC_CTRL", val);
>+		}
>+	} else {
>+		test_rdmsr_fault(MSR_IA32_SPEC_CTRL, "SPEC_CTRL");
>+		test_wrmsr_fault(MSR_IA32_SPEC_CTRL, "SPEC_CTRL", 0);
>+	}
>+
> 	test_rdmsr_fault(MSR_IA32_PRED_CMD, "PRED_CMD");
> 	if (this_cpu_has(X86_FEATURE_SPEC_CTRL) ||
> 	    this_cpu_has(X86_FEATURE_AMD_IBPB) ||
>@@ -332,7 +359,7 @@ int main(int ac, char **av)
> 		test_misc_msrs();
> 		test_mce_msrs();
> 		test_x2apic_msrs();
>-		test_cmd_msrs();
>+		test_mitigation_msrs();
> 	}
> 
> 	return report_summary();
>-- 
>2.50.0.rc0.604.gd4ff7b7c86-goog
>

