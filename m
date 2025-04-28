Return-Path: <kvm+bounces-44519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 328E2A9E5C7
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 03:34:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D592A164BE5
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 01:34:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 630AC14A605;
	Mon, 28 Apr 2025 01:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EOM3HPUY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10C5A945;
	Mon, 28 Apr 2025 01:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745804063; cv=fail; b=ctNlNcbLLupyqEIMfc0rw+PWeEWkE4O54nDRdVeptHfR06tloBQu8/JWhyKGlaPMJ0PgVVxiuXfzkGTXB0Z8KgdYL/yBlq/KzcZY84ajnHN4pcTrrn8bS7+GpBEaA9FI8njI04M+rM5nTmquOkR+C0MGufF7dIY5ust6OmNj7g4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745804063; c=relaxed/simple;
	bh=ESl79LWUyhw1WwRnfGWNch0OeywM6iYpqd8B7d584ho=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oODJn0MYTL11uGsP7ig9zRvmaIx/wnIwzw9c4cqP+VdHNiVosZ+HNR89gSnOAGgmBtoKEKAT9mFeKa11cK3Pztqz5AKiyKaHjPb8mFACEJZmFEDmqzaAINo71xhbYIoCRv9CI9BNpzLjHjC68cEu1wryuqVADin0DXfVB3ah/TM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EOM3HPUY; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745804062; x=1777340062;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=ESl79LWUyhw1WwRnfGWNch0OeywM6iYpqd8B7d584ho=;
  b=EOM3HPUYpuOntNyxV2Auobg+Z9gptguzkXmf0BIROl33YqHxB7WUDEjd
   oRfT2q9O43U+p+mXCV3YhI5dQQ5GXzAPvwUudXdTSB1/lVsb2Gf05+QLD
   9CO/BRx3pJsZpslb52M3gaPK0dgFn5y0HWeqRhW7XrDq43KMSH2g6v6rq
   jepZE+rTX+agoXjtBWp41MVSD4gYF8BvxtkHVpqQ5AM9sIqsPCDb1c5sc
   yDNCVHUiyRkFj7BsYnykRWwyOlB1GFKYFwlJ0rJPsPK07ccD4DolFFc1Q
   SZZGxfGJJQzkNxNsodOlGw01TFKhj1dlReuldnZ/aS1f2ebaN9WwsBrvy
   g==;
X-CSE-ConnectionGUID: 7C3mnyDfQvynLxfZ3og22w==
X-CSE-MsgGUID: mHgXW9tQTtWwkN/1geqgDA==
X-IronPort-AV: E=McAfee;i="6700,10204,11416"; a="64798178"
X-IronPort-AV: E=Sophos;i="6.15,245,1739865600"; 
   d="scan'208";a="64798178"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2025 18:34:21 -0700
X-CSE-ConnectionGUID: xFHxmeS4TFOjxN42wLcx4g==
X-CSE-MsgGUID: 9QA8s/ezRhuCOpYgM+jNHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,245,1739865600"; 
   d="scan'208";a="138195106"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2025 18:34:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 27 Apr 2025 18:34:20 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 27 Apr 2025 18:34:20 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 27 Apr 2025 18:34:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xFZCPrZx8NKy8VMLOF4F0CzlApO6AXhmywntC+SKXJo+zKmYvk8LcG4dXRPE03GPwNEdPXOhM1I1No+lJJPJzcEKVFgeTA4LzB2ZjOvO/zPo7F9Gw3zSTlO3x1LmHEHkIJXLwCFphyEDogzMnyrb/OyHyAItMFG6LyJW/+ZWRTDX8+cnMtWnnvSsV+zlvhCA2ZAgVM0d4/jwpvLNor3/l/HekA38tgeA2ACzPGx7MFuc/TqRRIEvvoC1QhRV5aUgYY/cEPA42JP3SY/tZr+oTakarr49pQ7NLileGW34gfI9kzZr6fJQtox7auH/THzpML5wawcqBeERMd7cwIwwiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SIWuGdMiTs9ySCmjsxMQ95A3H8kLsdJ5thcJMimpmNg=;
 b=J8C8JyUDaBImhtH84TWi/xJYApMSz9FpxaqqGI8dMcsF7Wp2AXKwaE6I6VgVbhGcU7wnSH1LrjFxkmO6khP8BnytdWG7wug7mfoD3ykaKViNA83m+vXdMfCjhgbOlCgxe6BHl5kzM9LewedFuTMW+QMALAneKxXd42Wysp9KznQan0wd3LBgPkia1oNiU2qEreDEyD+phKTvw08XU8YqiPGJZvvENM88yUiQw1d6KKt6ntfGPutRgVvJtnCVO1GdOqHf2uPUqyBldit/kom5wfKGLV5y4T8rgC1RjgeH1aok7RlIT5Nq9ruvWZHyZagNaEwETSvGZ/+SdMDduvnaYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN2PR11MB4616.namprd11.prod.outlook.com (2603:10b6:208:26f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Mon, 28 Apr
 2025 01:34:12 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8678.028; Mon, 28 Apr 2025
 01:34:12 +0000
Date: Mon, 28 Apr 2025 09:32:19 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Michael Roth <michael.roth@amd.com>
Subject: Re: [PATCH] KVM: x86/mmu: Prevent installing hugepages when mem
 attributes are changing
Message-ID: <aA7aozbc1grlevOm@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250426001056.1025157-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250426001056.1025157-1-seanjc@google.com>
X-ClientProxiedBy: SG2PR03CA0123.apcprd03.prod.outlook.com
 (2603:1096:4:91::27) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN2PR11MB4616:EE_
X-MS-Office365-Filtering-Correlation-Id: f636b6a8-b98e-4d9a-e11a-08dd85f4c77a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?wSt0VOD1eAGcsVPfCTpOXN0l3PhjT4zAQ7MLlra178c9WmmPY+oY3uYR9KAv?=
 =?us-ascii?Q?tWxFf7VrEOcJfsfVc/9ZXQ/vV2JDSl0hFRjYk2RCwN4RMcE81ISFXcnY94zJ?=
 =?us-ascii?Q?Pss0KUDSEFg2V8Ld7UvUJiL1L3CG/dsuCjg5NeBjNzbeSM7vakEeWsnlugZv?=
 =?us-ascii?Q?h1U03SPg1csQerF3v3LQx9RwynKhLlYV0ymbsoVzKIJ5QFX7eVrozLyLwGWt?=
 =?us-ascii?Q?loDj+BQRnUI2KrrFL8diu7z9dlXo5hQPyvKSq+QBSXQ0LZ2yYyBVS8/MuwOi?=
 =?us-ascii?Q?VXSob9QZdb3fRErp78OtpzNrlXKcqwg8KOSj0GpPnRNcSFc5us2vK0DlnFya?=
 =?us-ascii?Q?IVBtoNig9W6rJkp1+I5t3Q7OPpdqhbRoMBDaz1+M+bC83l4OlLbFfzv6m84U?=
 =?us-ascii?Q?TjYruhPd6dK8Axn//YwRqmNyzEzeISD3gX+sPn8prJtm0iPweluSbJ7+2p0U?=
 =?us-ascii?Q?3HoeKJaGpzAJi+CU003xLD/9UiQj19914Pz1uEX2n1YLlXbd38ZaU4jr3MtN?=
 =?us-ascii?Q?S6ayMLGGItP8n6vHr5TQExInMzKQSNIommYZcnUt0q2F+lQWHvV429Td6aJG?=
 =?us-ascii?Q?U+x0iuVg8NFCtwt5aND5gAQUDutI998vTDBcZRXMr4FpUTu1O6Zteexu1lbO?=
 =?us-ascii?Q?w9vpr/Iku5R/+WWyFS0kObmzR8TdMe6CHZ3b3xiSqvSK/mvIb27eAscNqrAn?=
 =?us-ascii?Q?idUTcWiW1DYnLHbZv+sc+MlXZ7W6Hg0bpXE120e3/Su1dmdfv3uQohnx2GH2?=
 =?us-ascii?Q?namYv6CPxezwEGotYRihYL0iPot3ZxgPIeDVexvSw/OGp7NOoKzjNZYXRacF?=
 =?us-ascii?Q?HhB1D2hPtX+b6d+T/HUbqaAH04wCeiNbMRFbvDbifRIhrAFs3s5eAW/KDLPF?=
 =?us-ascii?Q?M+K7nwT9gex14MIFOJc3Px172xuEAsZpLuC+clJqgCQrjO95+nxWWKjV4dQ3?=
 =?us-ascii?Q?r4HrJUiCC0bNGtmJ2D8nmMv/kiBHWXBB1CMMBMcdMF/qjzP5/CcShX89WMH2?=
 =?us-ascii?Q?FSTzAH4MGO38hW34B6x/ECGvnRWWfpEXK3dAA93pSy9iEgPOGv9Wr8B7yGfK?=
 =?us-ascii?Q?z+7AKCF+JsIQ6F857WpyJ0W7EQ4DfRx4UJNeZsnWSIRzrcQbqw3FN9M/j8HS?=
 =?us-ascii?Q?/n079C9pc79SBaWVBZz1CzK5gUCfiWO3Tt4BPZ6X55iwbQ6iLpRp4Sp+DKdw?=
 =?us-ascii?Q?HtCezHrq3TErpmEPAc/afV9a6G4dETwdTI+cDtgxMCyYho/SmsUavU9AxXpC?=
 =?us-ascii?Q?u0SVecqQPftdlb90fZVRPUPeEtlw0+Zd3QZllUYj3Nji9EVZ2ESeYtVBMb2I?=
 =?us-ascii?Q?ZwtfF0c6T4OgZUxJEXuP++VYuliRRvuaou5UBTJvE9UZOEmlcFokIHDepbQH?=
 =?us-ascii?Q?8eZhXVIs7ZeLS9b1zYRPizdbPNCxXG5md0//QEe7TJCvcFTgmg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ty0yt60m9ZJjKRkP6kuvKabKBJ125A2VVe2xzBGYWP9TeQW6I7g7IMhhYJ1I?=
 =?us-ascii?Q?ZHi41PI49SErdYOR/rNjGTmLBxdOSVV453ifQFFogvbMDXU6FcjH5YVtgb0k?=
 =?us-ascii?Q?3hlfQIf9Lsn8x2Xl8jgNj2FKPRnJHq0KsUEzZSmvwz8oHMS976+H9mqHSt+K?=
 =?us-ascii?Q?BDINFGi+R8xhWvjCh4DG0UBhKj9nuBHkfHQ3sE/v1xZ9d4lTsWuaDDj+vW/8?=
 =?us-ascii?Q?w0/GdI/B5d+PdP2THpCV1mTQThw3Hbf1Vt/timsulJZCre5v099ubDozOmPV?=
 =?us-ascii?Q?FjfPWdaszubZ1iCLqvt3E0o6x37eoygute76prcpvM9E/f86PEP6UbtgqQiL?=
 =?us-ascii?Q?vZTSUumCo31jGakxyHa2dchAIwyNmwPWU1t9wfT+07NhmTOzLOnNAIU6aKKR?=
 =?us-ascii?Q?q+KQV3vD4Aa+aKEvz6ST9NAzN4oE7wg04qodgWAUl3ByTY7AXincrqno7lF8?=
 =?us-ascii?Q?pB73OhZLmlN18RQcuRk7d9dSXcNEhZyIapuCVsx09IoOLS+bfN6N3pQOsaB7?=
 =?us-ascii?Q?rLl4VFxeZKjsnSkwI3M7X9AgPpntkK0Rc8DCc9MgmLbEuBdPfiQ4JaGNZ3SW?=
 =?us-ascii?Q?HtkG+hDoNqW0HWT0A1H0PmAniwitmAjzlvLJ4t+lNFGOl7zOJ+NGNCG07/IH?=
 =?us-ascii?Q?61/BzxT9tySv2/mEW5zmpNAcKx7TCwNMo7MrpIQ3Bf5rg5HOiJGjn5zKBIoz?=
 =?us-ascii?Q?PPD89GLMYVGYlxUWE/E+2qByUFknaoImvEtV17il6NmXxGiKwYzg98Ae9pk4?=
 =?us-ascii?Q?rgQSHrRKdythyd1jadh0ne1E5MI4E09hXMJr7HhmB5GBFtRqgAmLgl0Ve8oV?=
 =?us-ascii?Q?TitgKCbqRvnIoWGxr4eLTctP8L49yfJUYUcv+Kdfljt+a6k0UgKKQQO/TDnF?=
 =?us-ascii?Q?prIYIxyCePIlo2kbPqvvqUeR3dzYlvo42lU7KLFjZQomt2nBMhRClZ9YRwDy?=
 =?us-ascii?Q?9ZDZWp+vWrHp20DtuNLtpiN0lFGcOFBtiYzuZHA2kNDEsxrq3/yT/gssBX+j?=
 =?us-ascii?Q?s32YFQUA5TFAsP1nFfjIchg/lOuU78gXPFwrGyLaM4euAdC/+IG+htrvyDzg?=
 =?us-ascii?Q?GCYXNUxCauIno90Alwe9vb5Yg3Dbrao0feJ93S3c+dsIlSFsEPXVc6tBne2o?=
 =?us-ascii?Q?N3duNtjsr8WPr+wpsz3fAu3WLjn8iNZ7fLE63Zf2OACUYI0PiARndgTnrgYE?=
 =?us-ascii?Q?k9+R8jSaeR+kz5Tt35nW8HAh+1Zi73YElD42AjzRMOfwQV5zY9VPxFP8WF78?=
 =?us-ascii?Q?N0avotFRjfbuukAD2G0rKkIkHQKs5bTZSPjB1GdIX80sDP9ETQK1wUMOEOoi?=
 =?us-ascii?Q?96bTg4Ks92KS+8OVhqMXVCacobNxV+Lc69YIQBd2rB8Ru7jFV0jxNaYEjw+s?=
 =?us-ascii?Q?W5+mjaGFnwgjWDRNp52nSkNbQV2/JLgcVadQuQBrORfQCdQgZfWaFjvcmktY?=
 =?us-ascii?Q?T+7QXuiwLdQMa0YAIFwOBBdM/EFAmEJzRE1Oc/RWs+kP0S63A9YhcCcR2Nng?=
 =?us-ascii?Q?SdsQZwPq6WwYAyiBgwjFaRlbqqxW/dXy4PMDqgo2MDwJWWSXBHROTqtCBjWy?=
 =?us-ascii?Q?bI5Xju01P6DdThgGYFF9mkvQRfLB5Jl3ATPtafC+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f636b6a8-b98e-4d9a-e11a-08dd85f4c77a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2025 01:34:12.3071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cX1WcKzoUOaek8WUOB0SXXrb8lfBoAN/kWuBBzNU3ulPm5c/kZUwI2GvX5XDSpHp0vb1nMAsGNEkmU3ErVKnZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4616
X-OriginatorOrg: intel.com

On Fri, Apr 25, 2025 at 05:10:56PM -0700, Sean Christopherson wrote:
> When changing memory attributes on a subset of a potential hugepage, add
> the hugepage to the invalidation range tracking to prevent installing a
> hugepage until the attributes are fully updated.  Like the actual hugepage
> tracking updates in kvm_arch_post_set_memory_attributes(), process only
> the head and tail pages, as any potential hugepages that are entirely
> covered by the range will already be tracked.
> 
> Note, only hugepage chunks whose current attributes are NOT mixed need to
> be added to the invalidation set, as mixed attributes already prevent
> installing a hugepage, and it's perfectly safe to install a smaller
> mapping for a gfn whose attributes aren't changing.
> 
> Fixes: 8dd2eee9d526 ("KVM: x86/mmu: Handle page fault for private memory")
> Cc: stable@vger.kernel.org
> Reported-by: Michael Roth <michael.roth@amd.com>
> Tested-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 68 ++++++++++++++++++++++++++++++++----------
>  1 file changed, 52 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 63bb77ee1bb1..218ba866a40e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -7669,9 +7669,30 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
>  }
>  
>  #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> +static bool hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
> +				int level)
> +{
> +	return lpage_info_slot(gfn, slot, level)->disallow_lpage & KVM_LPAGE_MIXED_FLAG;
> +}
> +
> +static void hugepage_clear_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
> +				 int level)
> +{
> +	lpage_info_slot(gfn, slot, level)->disallow_lpage &= ~KVM_LPAGE_MIXED_FLAG;
> +}
> +
> +static void hugepage_set_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
> +			       int level)
> +{
> +	lpage_info_slot(gfn, slot, level)->disallow_lpage |= KVM_LPAGE_MIXED_FLAG;
> +}
> +
>  bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
>  					struct kvm_gfn_range *range)
>  {
> +	struct kvm_memory_slot *slot = range->slot;
> +	int level;
> +
>  	/*
>  	 * Zap SPTEs even if the slot can't be mapped PRIVATE.  KVM x86 only
>  	 * supports KVM_MEMORY_ATTRIBUTE_PRIVATE, and so it *seems* like KVM
> @@ -7686,6 +7707,37 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
>  	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
>  		return false;
>  
> +	if (WARN_ON_ONCE(range->end <= range->start))
> +		return false;
> +
> +	/*
> +	 * If the head and tail pages of the range currently allow a hugepage,
> +	 * i.e. reside fully in the slot and don't have mixed attributes, then
> +	 * add each corresponding hugepage range to the ongoing invalidation,
> +	 * e.g. to prevent KVM from creating a hugepage in response to a fault
> +	 * for a gfn whose attributes aren't changing.  Note, only the range
> +	 * of gfns whose attributes are being modified needs to be explicitly
> +	 * unmapped, as that will unmap any existing hugepages.
> +	 */
> +	for (level = PG_LEVEL_2M; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {
> +		gfn_t start = gfn_round_for_level(range->start, level);
> +		gfn_t end = gfn_round_for_level(range->end - 1, level);
> +		gfn_t nr_pages = KVM_PAGES_PER_HPAGE(level);
> +
> +		if ((start != range->start || start + nr_pages > range->end) &&
> +		    start >= slot->base_gfn &&
> +		    start + nr_pages <= slot->base_gfn + slot->npages &&
> +		    !hugepage_test_mixed(slot, start, level))
Instead of checking mixed flag in disallow_lpage, could we check disallow_lpage
directly?

So, if mixed flag is not set but disallow_lpage is 1, there's no need to update
the invalidate range.

> +			kvm_mmu_invalidate_range_add(kvm, start, start + nr_pages);
> +
> +		if (end == start)
> +			continue;
> +
> +		if ((end + nr_pages) <= (slot->base_gfn + slot->npages) &&
> +		    !hugepage_test_mixed(slot, end, level))
if ((end + nr_pages > range->end) &&
    ((end + nr_pages) <= (slot->base_gfn + slot->npages)) &&
    !lpage_info_slot(gfn, slot, level)->disallow_lpage)

?
> +			kvm_mmu_invalidate_range_add(kvm, end, end + nr_pages);
> +	}
> +
>  	/* Unmap the old attribute page. */
>  	if (range->arg.attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE)
>  		range->attr_filter = KVM_FILTER_SHARED;
> @@ -7695,23 +7747,7 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
>  	return kvm_unmap_gfn_range(kvm, range);
>  }
>  
> -static bool hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
> -				int level)
> -{
> -	return lpage_info_slot(gfn, slot, level)->disallow_lpage & KVM_LPAGE_MIXED_FLAG;
> -}
>  
> -static void hugepage_clear_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
> -				 int level)
> -{
> -	lpage_info_slot(gfn, slot, level)->disallow_lpage &= ~KVM_LPAGE_MIXED_FLAG;
> -}
> -
> -static void hugepage_set_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
> -			       int level)
> -{
> -	lpage_info_slot(gfn, slot, level)->disallow_lpage |= KVM_LPAGE_MIXED_FLAG;
> -}
>  
>  static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
>  			       gfn_t gfn, int level, unsigned long attrs)
> 
> base-commit: 2d7124941a273c7233849a7a2bbfbeb7e28f1caa
> -- 
> 2.49.0.850.g28803427d3-goog
> 
> 

