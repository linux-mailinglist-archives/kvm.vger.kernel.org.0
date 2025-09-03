Return-Path: <kvm+bounces-56680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F3884B41A58
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 11:45:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B663E562CE2
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 09:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 075B826980F;
	Wed,  3 Sep 2025 09:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DwKDEfNx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E780523C513;
	Wed,  3 Sep 2025 09:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756892719; cv=fail; b=H9M/lneY+qh6rFWc/sfZdlLyUpy+jAHvTdvmfXhfJLt44H0gTolwy03N98AKaHexMJNImAlZAfFbNNhMrXdMISffimtABomlbaablcxGdnS8I8CHXthJo1hwHxtCyn5Y6u/aSkZsfKVvDe764iHOxfubkJpDvHss/YnQzWtdfcc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756892719; c=relaxed/simple;
	bh=ZO55b012Lwr0c2s5WWBhvFSW0h6FZcUWbt/RnfcwftI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lZsp1/eyEeRLwkN6aE87PjHBtnhv75xc1TKSPBreyYR1Z6leXZZKX5ixTDcHAhwB+MDAtTIl57TQg6Tfu6YmyuH7HRgwbsPJUW+A2PbE+SDKYn0xN5EjFsgPbZoq64ipfitB8vpykpaTpq1GUR3LMUz+OM3sPJjQihpDi7d06uo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DwKDEfNx; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756892717; x=1788428717;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=ZO55b012Lwr0c2s5WWBhvFSW0h6FZcUWbt/RnfcwftI=;
  b=DwKDEfNxX9bLDnUA68Ir4aSi4k7KL9crHn+TTy0/o8YAI9/ngHzIqj2g
   zmLDwTj9b9nnCMMgTu4W4jh4KYdo84Sv6NWsjG3kAKB8rSvAj/a9pYwiO
   gK03e8PXUNQ/45BrHntAfnpFonrkYM3mDtKaC8Ed1f7Lyb0Kh/tnL5M6m
   tNXEuGXhrgJ2WwjkCmxNjf9olTmKIjOhzrc/Trr3/6OBcKn9X0f55gA06
   gPtEaK4xh3sT8mfYs6e6MWyQuFuradqBs8SV5Coaj6wq9sUCZr/i88LBx
   g4TsgjKpJaDVsnLr4xEEXkNubFbhU0lQRiQRGgpcawZQ1zFii1UzfnGqt
   g==;
X-CSE-ConnectionGUID: VSa+rA14RsO9Q8bE7NCp+w==
X-CSE-MsgGUID: pyywplkKTkuydgPAuW1aJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="70577777"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="70577777"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 02:45:14 -0700
X-CSE-ConnectionGUID: I0L1OIWDRrCSYbL8tt8YdQ==
X-CSE-MsgGUID: Rqp3RrjGQ/y5h7EC9+zgFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="171690967"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 02:45:14 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Sep 2025 02:45:13 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 3 Sep 2025 02:45:13 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.75) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Sep 2025 02:45:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TirJg2XS1qVG8rux/dgJqS5rcKRj+Rgbn/daESlMErSkN4V14ctMr6sFfLHGiqlmhwzbY7weyzcqSAp/UnHPJIWKij7ILD2n403qsHBIrQPICECu+NPabNIhRL8j/873lEWavmAmhchXVDMgzVEwfvUM4nBrMA6+fHveTy+Re0e03WNFdY6tIbaWJWJ8huHXAlvZGy79zWylKwGSoxv0NGe9+Y/bk5UXfZp5MWnuiZ/ShWNtEyUpQLTwOtLh3cVqFQ4KiJ121NHKYiio4yu7I//TI369JnkM12LI9god4h4yPDFvmOeYr7czpqizdbVgKpTBnTf9iAQx/elVZzKeyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KwNfuGi0uS8uBWyx61OK83U0O6YcECLt8kRQOnCrkyI=;
 b=oZdJzYn1GkKMR6ZLpDFnuKe0A7or6nIWHDP1x/9026Ak6nHUbK57JNoDppPjkT2zn/3Uozc4ItgHIkILrfcXfJTHjuu1CQCfyjEr5NCa+tPINDm8jqPWCLzjGHyyIVdXoqDXTkAqbxxTyyjN+I8WT8NYyoxAfPXPLYGHu8eLdxh68GSuDy5WCwnTeKO1bXO24gcIyA1q0ewGc2v0swWKxtveOkhjVq5xk4Kiv6fw9V/Psvuidc6tK0sjU0xoWVsVBK6wP0n4mTyWgv8BmUBo05kyGIbdn1VWfD5YQRLcbHC937SzkAsaCouCuFPe3m6vCK9fxFAe2+WpPxGOm/7/9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB7316.namprd11.prod.outlook.com (2603:10b6:930:9f::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.27; Wed, 3 Sep 2025 09:45:10 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 09:45:10 +0000
Date: Wed, 3 Sep 2025 17:44:13 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>, <kas@kernel.org>,
	<tabba@google.com>, <ackerleytng@google.com>, <quic_eberman@quicinc.com>,
	<michael.roth@amd.com>, <david@redhat.com>, <vannapurve@google.com>,
	<vbabka@suse.cz>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<zhiquan1.li@intel.com>, <fan.du@intel.com>, <jun.miao@intel.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<chao.p.peng@intel.com>
Subject: Re: [RFC PATCH v2 12/23] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Message-ID: <aLgN7aQjLPkEj95o@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094358.4607-1-yan.y.zhao@intel.com>
 <ac774797-f82c-4717-9c40-8602e799e966@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ac774797-f82c-4717-9c40-8602e799e966@linux.intel.com>
X-ClientProxiedBy: SI2PR01CA0034.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::9) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB7316:EE_
X-MS-Office365-Filtering-Correlation-Id: 44920c0d-7aff-4caf-bebd-08ddeace926a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?cHr80HspLjrPnLGtDYOrcXr4hibGVm4Z7aXCUVS5mi55MAWXmBzukC7tT28P?=
 =?us-ascii?Q?xCm9lHRj1X8q+lFEq5JB1+6YQ23rb722f3HPyp3+CLEI6oC6XgABlI8AQrjZ?=
 =?us-ascii?Q?JDI03gxsalvDwP1IWkLFUtAzu3mRacvDsR0XL9SY4RylwZs28RPIRE6QB9bT?=
 =?us-ascii?Q?r+LckfeLHFwdhsrw55WK2jlo3Zj4kHE/S6hvAUzBlmMXImrWd5u/wPznM4bq?=
 =?us-ascii?Q?WDc0WDSEogHP0qKIOJ2s3Vp+QfofwFh5HkVvgMs7CxmtCAzoV1Kh1fq/QK0c?=
 =?us-ascii?Q?acLjIPkMDed9KRMtp/WdjZ9Y8K6i9MbTOw89ddDoAgHG1NNPbnNTa1i9XqL8?=
 =?us-ascii?Q?xZumTNbtaYjdJdSOhuvwhZaTzTqGoe3ct4zJPgq1C+l/ObUcve2YklLPCCFn?=
 =?us-ascii?Q?RYo38E1b3nnajPBbQ+pYERuyUDYkKNpzv5viQVIB6XnYCWWVWo1eP+o0WGUW?=
 =?us-ascii?Q?TP5gczOBD8xPq20HfNRG6c+1kqT4nj+2/2bC9b+Stwsb4EVWhXxhetq/+JZC?=
 =?us-ascii?Q?qAk+Wi70Z9YIil+WlHoj3zLl/lD2P8yApogOj1amBneGVyk8pcbQWftLtE6+?=
 =?us-ascii?Q?llQIgK/AsTxVBSqwY82o+TRv125uvvUwdM51kpfWzyIXZVi4T0SAhDL9nXYq?=
 =?us-ascii?Q?l5c6eHhWowhQ7LCrSQ21OSpnC5VEb+avd6aywRUOxpbXwziMPJJyw0hL5Cwn?=
 =?us-ascii?Q?7QY0VcL34ivJEIW4VyHNih1Swo/g0NKfQf5Y0BC+33Ngj+qPKLP0aE9stQso?=
 =?us-ascii?Q?mXSf9UF8TXD9m94WrKi5V6JJASBbxbQl5QG4fpFm87IwQuROZP9RM//xUoc9?=
 =?us-ascii?Q?i1ZfFz0yjplb3JBO3ka0zJ9mp8W2cF2Chka0GL853HJ/fbtPK4ii2uDyoaIb?=
 =?us-ascii?Q?Za8auKHyVMxbLby9DRcPFvKGO+KfpA5d0z1y1tpOiVN2DMb7HeTPS7naRBvG?=
 =?us-ascii?Q?dIEgK8eRWdfBj4BHSx9wY8SfAZV1jLHRI8rE6+m6B2eQA9wjozl1f9kM10Zi?=
 =?us-ascii?Q?x2PGMOWudlOjZW70go6LDOwEnHtegR7a1qTiCgPm+69GgeAysr5SpPe9lzJZ?=
 =?us-ascii?Q?AY0q456D5ThwadOqzta7mncNDBrydVdCOs5ezF8LMO7Fqn8mcZFNVGxHy/sQ?=
 =?us-ascii?Q?iPbe2X4T0+TfUcMqawu+s1/1GQlvZXM3e9FbGeIXeFYFKMuiE2R55pjIYRpm?=
 =?us-ascii?Q?J8s9iPs63gWPsRnkdHwmBEchYx/nDGg53SSgpQ3QyihJrDwD3F9MaXQ/LUmC?=
 =?us-ascii?Q?muqbHMQWgaq2aorvmt7bewnbpEld5NC0oucszxYrzVRFBOvURK5z/RsGS9/o?=
 =?us-ascii?Q?rw2dWBLaoH8Doi+fM+kQNwrLs4kZa0YCSDIbkjmFqHTK3qtFndDrQFlqTFTY?=
 =?us-ascii?Q?fF7inGwONNlvHa+N14XGmgeUyqUUShvFG36/9sz6/hLsxRGIoO6U4C3BOlPp?=
 =?us-ascii?Q?+B19+ugxs9M=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wKSi6U/Om9VGhS/PRJJkHDBI1MfKt9iBPc8UaVolN0say6kzB3rBdbBs5fkt?=
 =?us-ascii?Q?pDG6MEkSBFlZHDmWXVt/1eim7urTq7AceaVYgFQBJoqFJ7akvAewOvd1clOt?=
 =?us-ascii?Q?prcilbi6+kmtGTHCmyhyG8AWolwONd9lfu+VzkjbGy3L6hhA8/TwzZFUBceG?=
 =?us-ascii?Q?RV2Ec6T8tccaUaNlOhr80GglataodkQrtY6jMqYsPQMaVv4vxatWxqRjC9od?=
 =?us-ascii?Q?n/3gIFNXBnuwevSY7SPMVMwa64DUgXNa8uJSA2yAllVQqJGbhNzhHkvAw8Q+?=
 =?us-ascii?Q?leOS4zkuuhfC9Da0UzE0sDtDggNWQYDVYBNyPY6l4j1rI+Jxn5MmzIWiuubT?=
 =?us-ascii?Q?JVi4/xg2gjLA5IQUAXsXw3/qNqyUXHavcIUjo+6bTXD2zV4SMkqquJyhyPGs?=
 =?us-ascii?Q?uZaTMwWwz+GHmY+EL+YWoGqpNZ8zDrBokqQmogP7en7SbyouJiCqU/hRs+29?=
 =?us-ascii?Q?ZwnEICcoRTVCRSf2rB/8qbWpESdf7Mcj6gYHuxXcccYPjSYpQqs/Y6xLH+Ck?=
 =?us-ascii?Q?tLJXhwu/IETKIvtLcuqDpXdTjvpMqT/RtkBUqLYAvETgrkTHkTwOUl7OAaRf?=
 =?us-ascii?Q?+S9ehiPX7GA5BHGpsQlL+k7UGal9N1oxbZAnDJNJbBh2iaJHysT8cgMYi2Qh?=
 =?us-ascii?Q?6pNKFeFpGGpZef+1xWiBHTTyFD2gU3FRaDhcdJ85S6rsVuQLQlZmWrSkx0Tr?=
 =?us-ascii?Q?uhm/So/72QMnLzaxuKj9P3seVFKWm0VTnpufuzgA22DIBTwzl1uy9fCbU5+1?=
 =?us-ascii?Q?e/W05zyi3+DdOwc5NlygHy3bc3At1dkXNNr198Nj6f4vuSk4bh3Nr5gbBsWN?=
 =?us-ascii?Q?LsFSRdJafcm3lVm+NFK5NL8qMEDKaV0ANN5oPKtAzh8iWIHYSwcH4405BnN+?=
 =?us-ascii?Q?/AtYhKNoEjU85uUk7faEdZ0xi2h1YIYEEYnlM2XtdaJdKnEYAUgebGbmG5Xd?=
 =?us-ascii?Q?nLujx01606yCFuGrNsPt+ap2IxuvPbwOM4xs7j8yYt4IehFKasb2SuCebIRn?=
 =?us-ascii?Q?RJ493+g5USB/FzlXM1gQl5V7ktyWf5SCAPtqMbAsnARvOdoZBOgotUoog3rV?=
 =?us-ascii?Q?La4tnGozFwAMA4lqiBUCLYIjMO0ZdoMpXbC26dnp+tqu3clV+oSg+ppv9fso?=
 =?us-ascii?Q?YMAKWcA+PF2dR572ToYyxgG+/mtxl5HtkxWwEH0M7g8Sh8QomrShuPnDkNMJ?=
 =?us-ascii?Q?uS6i+la6C718bHZYLf6oihGdimBufDkAEwqN4J7fySUECmXuhMGlVhw6yYmK?=
 =?us-ascii?Q?4qZsDQwCfNKZlgqfmuUbGOenTe2DkboqpxGX+TvEsCP0Kf+nhKwYuLZ8Vz/7?=
 =?us-ascii?Q?syfuF6DiHBTt6pefjpuAZ6NMmTIy03FdhibVnjinbcfe7Z65L7Lf1TtoNGJj?=
 =?us-ascii?Q?mDg9aauUJW6qmMPu4Fw4zmMGo6sbS7bDRa4bvM3yLGLs8KUZ2U5BZGXiiHyp?=
 =?us-ascii?Q?NZEZf/4Th0ce9gQfYYjr0C0WeEiOAKdC312/RnLfia/7Hl4uBbGEvemgJY6a?=
 =?us-ascii?Q?jfEKFu33mZy3Qmypo4OPonP6nf56y8MgwJqGK0dsfTtPKfpDm6zrLnZYVs+e?=
 =?us-ascii?Q?wJI7c44/axpLbnwOUHEy5UeL30gXPVVgfahhCQab?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 44920c0d-7aff-4caf-bebd-08ddeace926a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 09:45:09.9189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WoFWQtxHWg6Dkui4hyBrdQMs3oAe+YQATb8czDPQhyKbvCF0Q4lTwlFg0jjBr7U8VgJeKixbxv676A1Fgx39Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7316
X-OriginatorOrg: intel.com

On Wed, Sep 03, 2025 at 02:57:07PM +0800, Binbin Wu wrote:
> 
> 
> On 8/7/2025 5:43 PM, Yan Zhao wrote:
> > Introduce kvm_split_cross_boundary_leafs() to split huge leaf entries that
> > cross the boundary of a specified range.
> > 
> > Splitting huge leaf entries that cross the boundary is essential before
> > zapping the range in the mirror root. This ensures that the subsequent zap
> > operation does not affect any GFNs outside the specified range. This is
> > crucial for the mirror root, as the private page table requires the guest's
> > ACCEPT operation after a GFN faults back.
> > 
> > The core of kvm_split_cross_boundary_leafs() leverages the main logic from
> > tdp_mmu_split_huge_pages_root(). It traverses the specified root and splits
> > huge leaf entries if they cross the range boundary. When splitting is
> > necessary, kvm->mmu_lock is temporarily released for memory allocation,
> > which means returning -ENOMEM is possible.
> > 
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> > RFC v2:
> > - Rename the API to kvm_split_cross_boundary_leafs().
> > - Make the API to be usable for direct roots or under shared mmu_lock.
> > - Leverage the main logic from tdp_mmu_split_huge_pages_root(). (Rick)
> > 
> > RFC v1:
> > - Split patch.
> > - introduced API kvm_split_boundary_leafs(), refined the logic and
> >    simplified the code.
> > ---
> >   arch/x86/kvm/mmu/mmu.c     | 27 +++++++++++++++
> >   arch/x86/kvm/mmu/tdp_mmu.c | 68 ++++++++++++++++++++++++++++++++++++--
> >   arch/x86/kvm/mmu/tdp_mmu.h |  3 ++
> >   include/linux/kvm_host.h   |  2 ++
> >   4 files changed, 97 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 9182192daa3a..13910ae05f76 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1647,6 +1647,33 @@ static bool __kvm_rmap_zap_gfn_range(struct kvm *kvm,
> >   				 start, end - 1, can_yield, true, flush);
> >   }
> > +/*
> > + * Split large leafs crossing the boundary of the specified range
> > + *
> > + * Return value:
> > + * 0 : success, no flush is required;
> > + * 1 : success, flush is required;
> > + * <0: failure.
> > + */
> > +int kvm_split_cross_boundary_leafs(struct kvm *kvm, struct kvm_gfn_range *range,
> > +				   bool shared)
> > +{
> > +	bool ret = 0;
> > +
> > +	lockdep_assert_once(kvm->mmu_invalidate_in_progress ||
> > +			    lockdep_is_held(&kvm->slots_lock) ||
> > +			    srcu_read_lock_held(&kvm->srcu));
> > +
> > +	if (!range->may_block)
> > +		return -EOPNOTSUPP;
> > +
> > +	if (tdp_mmu_enabled)
> > +		ret = kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs(kvm, range, shared);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_split_cross_boundary_leafs);
> > +
> >   bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
> >   {
> >   	bool flush = false;
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index ce49cc850ed5..62a09a9655c3 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1574,10 +1574,17 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
> >   	return ret;
> >   }
> > +static bool iter_cross_boundary(struct tdp_iter *iter, gfn_t start, gfn_t end)
> > +{
> > +	return !(iter->gfn >= start &&
> > +		 (iter->gfn + KVM_PAGES_PER_HPAGE(iter->level)) <= end);
> > +}
> > +
> >   static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
> >   					 struct kvm_mmu_page *root,
> >   					 gfn_t start, gfn_t end,
> > -					 int target_level, bool shared)
> > +					 int target_level, bool shared,
> > +					 bool only_cross_bounday, bool *flush)
> s/only_cross_bounday/only_cross_boundary
Will fix.

> >   {
> >   	struct kvm_mmu_page *sp = NULL;
> >   	struct tdp_iter iter;
> > @@ -1589,6 +1596,13 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
> >   	 * level into one lower level. For example, if we encounter a 1GB page
> >   	 * we split it into 512 2MB pages.
> >   	 *
> > +	 * When only_cross_bounday is true, just split huge pages above the
> > +	 * target level into one lower level if the huge pages cross the start
> > +	 * or end boundary.
> > +	 *
> > +	 * No need to update @flush for !only_cross_bounday cases, which rely
> > +	 * on the callers to do the TLB flush in the end.
> 
> I think API wise, it's a bit confusing, although it's a local API.
> If just look at the API without digging into the function implementation, my
> initial thought is *flush will tell whether TLB flush is needed or not.
> 
> Just update *flush unconditionally? Or move the comment as the description for
> the function to call it out?
> 
> I have thought another option to combine the two inputs, i.e., if *flush is a
> valid pointer, it means it's for only_cross_boundary. Otherwise, just passing
> NULL. But then I felt it was a bit risky to reply on the pointer to indicate the
> scenario.

I feel it's better not to combine flush and only_cross_boundary.
Will add a function description to tdp_mmu_split_huge_pages_root().

> > +	 *
> >   	 * Since the TDP iterator uses a pre-order traversal, we are guaranteed
> >   	 * to visit an SPTE before ever visiting its children, which means we
> >   	 * will correctly recursively split huge pages that are more than one
> > @@ -1597,12 +1611,19 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
> >   	 */
> >   	for_each_tdp_pte_min_level(iter, kvm, root, target_level + 1, start, end) {
> >   retry:
> > -		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
> > +		if (tdp_mmu_iter_cond_resched(kvm, &iter, *flush, shared)) {
> > +			if (only_cross_bounday)
> > +				*flush = false;
> >   			continue;
> > +		}
> >   		if (!is_shadow_present_pte(iter.old_spte) || !is_large_pte(iter.old_spte))
> >   			continue;
> > +		if (only_cross_bounday &&
> > +		    !iter_cross_boundary(&iter, start, end))
> > +			continue;
> > +
> >   		if (!sp) {
> >   			rcu_read_unlock();
> > @@ -1637,6 +1658,8 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
> >   			goto retry;
> >   		sp = NULL;
> > +		if (only_cross_bounday)
> > +			*flush = true;
> >   	}
> >   	rcu_read_unlock();
> [...]

