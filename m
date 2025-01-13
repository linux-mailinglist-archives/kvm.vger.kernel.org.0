Return-Path: <kvm+bounces-35269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47560A0AF83
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 07:58:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C4513A65FD
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 06:58:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05297231C9A;
	Mon, 13 Jan 2025 06:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iZcBbxUG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FCC1BEF98;
	Mon, 13 Jan 2025 06:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736751504; cv=fail; b=NBdwSOLVpRGoULETUpu6bOPX4IR/dtsjH9BQy8lxRnknSPgHnOlV5ibg/YLa7Z1MoeV3saQ7KG/jNqUCVIeaY6FnHD5tAhA6Si9+OxtR1QPP2Zj1rxzim0KUGhdjFvLm7xQAqr9Dzt8VxCz03z+I40OU855Oi32nHqK+lfmI6lg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736751504; c=relaxed/simple;
	bh=MmXbS9kYzYjnSStE0DoKJ/oX3xxxxc7iknkUljqo2ZU=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NdTLRCBpXkv9CAiffyOPdBvPpCW3ejaiqWf0Yr0VPV4B7dXrzTiEeVR0+uMMYGORmKS8JiA1f+t3R/sYpH6y1qQHxyFo2fvsR0ozwxKYTPPiWdyVBCC0MDptLlNffU92n/YRD7w1P6sFHFMNXJzUFgWiEbnXxUQF7AMJqgD7zKI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iZcBbxUG; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736751502; x=1768287502;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=MmXbS9kYzYjnSStE0DoKJ/oX3xxxxc7iknkUljqo2ZU=;
  b=iZcBbxUGAnZXIIqSajM+ucKmRuRgPDZjzAmVZIBeYNAIddktl+BLoVJd
   ZeIz8WfPyUrwe2oDKzCCDmh0VQIgfFEZnoB7kcPziCCBUjwzza9CL/Mgl
   /xFcTENAZhFtQX+rMZ67JAXnpDUDG1iQ3gdnMLk6qwVP3j6aqj3Q6SBgK
   ACW/6RDFGUeNc3mXYc8Ljk3/n21vm+5dX/NcCJpn3x4IsOsi8rRUMyfFd
   /pbq73varHutmjfxg6/L4Ag6X1a+1M0IkfrSiHvNGhqEX9UJX/Mvknmle
   o79iif8m1ClF03mHQYLUE7KjOAFYObOgNRA0u2yeEHTBH4G/211Z0rSPJ
   w==;
X-CSE-ConnectionGUID: 19RFVK72SMmZPz/sTGmhVQ==
X-CSE-MsgGUID: 748wRHC/R+GP+RXsmp1Vlw==
X-IronPort-AV: E=McAfee;i="6700,10204,11313"; a="36279641"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="36279641"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2025 22:58:21 -0800
X-CSE-ConnectionGUID: 5AfoDrYJT82fzFwPe1nAkg==
X-CSE-MsgGUID: yJMJ3LtuSJaShKLZfsJpkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="104339280"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Jan 2025 22:58:21 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sun, 12 Jan 2025 22:58:20 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Sun, 12 Jan 2025 22:58:20 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 12 Jan 2025 22:58:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Si8YDfrcxEwRxfM6ywl5w1KmCzajQTimfRCaofgH3dEIZ/7LSY7yQ+TgYS+lz8UxUcXv58az7UJBY/zkNwr7djvPbjAwdoF6smPsE3MO8IMOVTAKjWHLl//78wQcSUt8UgtYCCmWXhDeEb/XZBNwXId3IKXBKSjno2IgE4Ns/6G2I/vnJ7yCatybOBhypqEdGO4RJrlV8BgkGseNxPTsYPKSWhDTqIYCfOx2jfz3BOvXcspfLnW2JVHP781bVx32ZraFIJ4ZNMX0cqBMlrcjvlvpzwIQkqtSdJ6Jk+UF8kw4HK7viNc3faqemBvEpVpkudI1LKnW0RVLkBw7q5m15w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZZYGm069ytoGdMJ1V6i87ydTwpRczV0AdrWayg1DfXs=;
 b=GywTSUfc6lSp9A8q7cSitIU6/12sDIDymWMIPk+vMXrNOulqEyBTsh+EPL1zdj/4h7qTM56SFiSlE74gdC3RGOhevIrkpjxZ1yOp7U3lsbqaH/M3TJiySlmKNklNn6bTlsgZitupbgsoT1u4U7vGC8GGoPZNuEL4hibzPRewXi7FhVE/I1zNUV1FzuL/StpOs0UPj0K2KGm0pIOz5CTlJSCxqEd+ssWKiEOP/EOdnNCh/z3GhKVLGCJYRm479f/h3nd3qvhLVS2wr4TYnvNrg72eOOlMWvFqS9yd6JsJRfQHrJpYgWUkseI71144SXJqd4QR0OVcCwjj3Bki7l2BSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CO1PR11MB4865.namprd11.prod.outlook.com (2603:10b6:303:9c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.11; Mon, 13 Jan 2025 06:58:16 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8335.017; Mon, 13 Jan 2025
 06:58:16 +0000
Date: Mon, 13 Jan 2025 14:57:23 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 1/5] KVM: Bound the number of dirty ring entries in a
 single reset at INT_MAX
Message-ID: <Z4S5U1B2/+mLPU/f@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250111010409.1252942-1-seanjc@google.com>
 <20250111010409.1252942-2-seanjc@google.com>
 <Z4S3JTP71zdJFJqD@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z4S3JTP71zdJFJqD@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SGAP274CA0006.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::18)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CO1PR11MB4865:EE_
X-MS-Office365-Filtering-Correlation-Id: 83e22860-ec6d-499b-983e-08dd339fa761
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?EEQCRYkyBsq/S63kOGanAWWz8dgj7X7F0qQmx+Fh5a1LESbiW9K1PtsluZ46?=
 =?us-ascii?Q?xFQM5ryXYinSW5l1L4R3MCMjCCzU+6gA6BxLQpT3pTBeQpCmQqz2WeFdKnHp?=
 =?us-ascii?Q?SBoczNhpCCd5irOZdcO8yWGdrq/qhr/Awsh7eTZCGOlUFOs3Z5x2NmsMgnHB?=
 =?us-ascii?Q?bt6vu44IdR4N6lzWuj/bORAE9eAUBN2UOus5R7rBmw75OPmIDZV2xdNeEHr+?=
 =?us-ascii?Q?3+wWM7Mu/tFGuI2tj6QPOEaxKOEojQgDzHcQoVy5QE7W64fJrmCAv561o07d?=
 =?us-ascii?Q?3eIc+6mjpTm5bq+j52EwLWMPYXQr0SPXC7oiIewVWGoEN+fLCOY6XYa6RhZr?=
 =?us-ascii?Q?eF1jeubYIwr3IcQRc9ZyVCV93p8bgCiBD0y455UbaZi7oldv05qwkIql3YsJ?=
 =?us-ascii?Q?OH6ITsgElXHxJOj9U9mKUCAxwl/DlI0wNx6x59RvcvECw8NOlq+YbKxAs3Fk?=
 =?us-ascii?Q?5XDWTMbWEvxf5l4zPpya1k+7iBCceYWUiVwvjN66SGNYiaJJYsu6k4aofV3H?=
 =?us-ascii?Q?LhpuhwQ7wqsAaeA3pNVnUCv6QNlP1jn0hgWrcBnoZen3xT9lTur/nMUuBu1H?=
 =?us-ascii?Q?7NSCMKnX+uIZxzXtY1Szc20hujLMeCxBxHG0mGzXFAiEan/cBkA8eaRC8lye?=
 =?us-ascii?Q?QHy5ThPujZyMwaeT6jbsVflsTLnfN1zoONbkXgvmpB/mw0gKYlhd62GVx8AY?=
 =?us-ascii?Q?++CxZKg9n9wdxZr4jElDcQ3xjgY02g9NJn+9tWQmsVEZN4EHFw6PyGqG36QX?=
 =?us-ascii?Q?JUfeedRERP7KWiX87Y+NyHTDiwpqsPDNANCzpz0r7rf0rp/OCfDM6NxinkhI?=
 =?us-ascii?Q?T5EllS837flLA8TpyRdqMtNWb5PewR7qaqjVv2cbaP9pEIhItL46VzJvnBSI?=
 =?us-ascii?Q?gxAI0GbSIX9pQHr/O9txXOhxR60Lcco6TWsMINY1zW0GZbhNnqBhQ9ntMzVo?=
 =?us-ascii?Q?WCOYykViu0PYcKYo6P7iz0WTWi6SYxCUsya1EG4hnpkblMcSHp0A1azZ+RZT?=
 =?us-ascii?Q?YaCo4Rh8gW1iZMDeNZQiVuXGU9YxoSaJKoACxxMr9Oa9NCw+qgp0P+KIl1T8?=
 =?us-ascii?Q?qu+v95MWBL20DKc1PXu2iKuj/JAPxaHw3Bkr/1j1vT6Ijx2VOWLUosnV0gIz?=
 =?us-ascii?Q?t8iFh1Eb+oy4fziDhB9CAKbrbLmyC/4wBeZQ872xHPoieNAAt0zzK4DGDV1f?=
 =?us-ascii?Q?S6amA0gJnUzT5CiE8hMBSGP13/nHAJyFSjrMxW8m/wxFYYFo2dEYk9iCUbfB?=
 =?us-ascii?Q?daKo4v3GUNksmeYBqOPzcToWNtEli/wiYFtt7hte+OAbh+ebaFS+/qsPbjCp?=
 =?us-ascii?Q?0hdIuKJOLpNDGxjHkaStIcgmtBz5FGYr9h4es4vmtWd+ELqa4O7wChC5EOx/?=
 =?us-ascii?Q?LoW7pDIChOR2EOxs/duCqiSwVqz8?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ai1qU7qQyg8PpzmVsdHO7+OSsfFJcuFMZiFX83RZzX73/KRT/Kr7MvQOXKbR?=
 =?us-ascii?Q?Xo6Fpk7xHPuwx8xoq0vFQPhP/B9W5IMpNNB8c+Xci1F3TaxpK7iwY0WskLa2?=
 =?us-ascii?Q?xP419UXe0hm+yioNfBESZSUNcqSMfR4jGBQZ09FyOajDcDIqVdh6sGk1T5Rh?=
 =?us-ascii?Q?iUnuChfQyyZKair15eEmNkB0NrarL5ylcVBbX1GbC32MTHiY4u5ZUMv/hxJC?=
 =?us-ascii?Q?WNe8+gB0qAy61KIrnHCV1vT2iBWcxywfkSREB9OfkDiLcGMj2dmZfn/gxCvp?=
 =?us-ascii?Q?mk98YarMJBL1DT29KuaScxOBNxxOPOKni0pCqb5UgRzgboorp38cfm3xBU7g?=
 =?us-ascii?Q?uQQaiO2j1trPSM12OaHkRjf2D2+sSzLvl+YvRPTghpopwPLD+rtLY3IDb4Wc?=
 =?us-ascii?Q?7Uz4cHusMSBI4cJskpOiJ9Jy75irSHdueZwQXrhdyxEouIqKbeDovfo02xx3?=
 =?us-ascii?Q?Sb/QzlToUj13vKTJVmQjBqbgebhhHQpGfussgYZ/VydVcQtk32YpXd/yJwMx?=
 =?us-ascii?Q?6g4e7XaaftP1CALjEgaP4SqNqaEX8vdHsqFC2RoQCRiC9QBnWtmK1hs2FHYV?=
 =?us-ascii?Q?u/31aZzUhRNbzAqg/FdLmViN5BfdYsAnIZHxhzThbaRA/tcRVlS8p/5jsB0p?=
 =?us-ascii?Q?GeJchnVWQc5/P4/j2PL5/RCingtEleZ8dBBUXkE2tw0l6ugm/VkeoQnMyZIP?=
 =?us-ascii?Q?Hp3twQs75gEmzCF8ToybgaNtWfYYVsQt78hRv6smxF0mH6FubQmN83NhPapt?=
 =?us-ascii?Q?YBzDU9kpF/VYF1T7Y4Z2Ni6g1ddeAFTpIjoQUDqLdisehRaWO2+aC4qteIjc?=
 =?us-ascii?Q?8MngzedhWqQBYwpz+asmalfP4wmjP1CbqIiwFTyRu0wmupuyaWMWUi15MJNy?=
 =?us-ascii?Q?+nqoIFMDSODU8Qd+k//qJVXq+7ZqEievaxeOA18bzRbNdLc4HsLkq6gYvF7t?=
 =?us-ascii?Q?NgNiP5wOGSB9wfhOL8cMNjHkx4Td6ewyilRTv6G/s7kWEx9hO7lsZ5S7SsDc?=
 =?us-ascii?Q?8OT96LzNow9taggmdRHjVwKAt5HwZTo0hRAq0C/Ghku2xl2q/GrxugrGwmft?=
 =?us-ascii?Q?PU/pDS3ystpTWSzLXykgYy+3eNqEs6ksp7fKUPxVuTpu3EHSwQc9Tt6tFWf0?=
 =?us-ascii?Q?WLKAaIhW92d8zCxLSaFX2n5Esm1Doqc/x+eyTG9jwf+AWdEEXYoIrnDqWBo0?=
 =?us-ascii?Q?2gDosnDWdzQHSEZsXcEYKWKmv65dNj/+J+ahXBrPB6+I5LTl3eVAtrdq7K8Y?=
 =?us-ascii?Q?n48MbhDRLroO0lBpPQr+aOw32xrgzTJF42ctSnOwQAWypSS4m53FDwfNvB+H?=
 =?us-ascii?Q?UE/Y345nV6DLPeSknlLVJ204TqiIwD5bjgejN8MjgCVsiJ3VqO8h3VnuQkPf?=
 =?us-ascii?Q?QL8YnOuYWU4BJEXFQc6WPT6M44nHUJpboKNfcARItxsnLnRYIMB59nzLp9nL?=
 =?us-ascii?Q?NBmU+Au8vtUbuccfCVZ6QIiCPgTiA8ZcGrY14QLVXX5U0raAX54hQqJTxBx2?=
 =?us-ascii?Q?DjB7mItjvPNSRBgiY4BEbyTjR2TsXespmn8v1C23p8tyEXsdyFOoxmH2AP/z?=
 =?us-ascii?Q?u2O1RGirGdN4ZNDP35Bo4u/A8Lo6QVqo/cBs39vg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 83e22860-ec6d-499b-983e-08dd339fa761
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2025 06:58:15.9006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ojton7jHNd9Xty80chtqxpMOIpT5G6O7qcAS+c/AUqDbLTbes+kZ60tzI5OgI4RzK2C+bN7iGjoWi0kA2qBfUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4865
X-OriginatorOrg: intel.com

On Mon, Jan 13, 2025 at 02:48:05PM +0800, Yan Zhao wrote:
> On Fri, Jan 10, 2025 at 05:04:05PM -0800, Sean Christopherson wrote:
> > Cap the number of ring entries that are reset in a single ioctl to INT_MAX
> > to ensure userspace isn't confused by a wrap into negative space, and so
> > that, in a truly pathological scenario, KVM doesn't miss a TLB flush due
> > to the count wrapping to zero.  While the size of the ring is fixed at
> > 0x10000 entries and KVM (currently) supports at most 4096, userspace is
> > allowed to harvest entries from the ring while the reset is in-progress,
> > i.e. it's possible for the ring to always harvested entries.
> > 
> > Opportunistically return an actual error code from the helper so that a
> > future fix to handle pending signals can gracefully return -EINTR.
> > 
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: Yan Zhao <yan.y.zhao@intel.com>
> > Cc: Maxim Levitsky <mlevitsk@redhat.com>
> > Fixes: fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  include/linux/kvm_dirty_ring.h |  8 +++++---
> >  virt/kvm/dirty_ring.c          | 10 +++++-----
> >  virt/kvm/kvm_main.c            |  9 ++++++---
> >  3 files changed, 16 insertions(+), 11 deletions(-)
> > 
> > diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
> > index 4862c98d80d3..82829243029d 100644
> > --- a/include/linux/kvm_dirty_ring.h
> > +++ b/include/linux/kvm_dirty_ring.h
> > @@ -49,9 +49,10 @@ static inline int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring,
> >  }
> >  
> >  static inline int kvm_dirty_ring_reset(struct kvm *kvm,
> > -				       struct kvm_dirty_ring *ring)
> > +				       struct kvm_dirty_ring *ring,
> > +				       int *nr_entries_reset)
> >  {
> > -	return 0;
> > +	return -ENOENT;
> >  }
> >  
> >  static inline void kvm_dirty_ring_push(struct kvm_vcpu *vcpu,
> > @@ -81,7 +82,8 @@ int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size);
> >   * called with kvm->slots_lock held, returns the number of
> >   * processed pages.
> >   */
> > -int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring);
> > +int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
> > +			 int *nr_entries_reset);
> >  
> >  /*
> >   * returns =0: successfully pushed
> > diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> > index 7bc74969a819..2faf894dec5a 100644
> > --- a/virt/kvm/dirty_ring.c
> > +++ b/virt/kvm/dirty_ring.c
> > @@ -104,19 +104,19 @@ static inline bool kvm_dirty_gfn_harvested(struct kvm_dirty_gfn *gfn)
> >  	return smp_load_acquire(&gfn->flags) & KVM_DIRTY_GFN_F_RESET;
> >  }
> >  
> > -int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
> > +int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
> > +			 int *nr_entries_reset)
> >  {
> >  	u32 cur_slot, next_slot;
> >  	u64 cur_offset, next_offset;
> >  	unsigned long mask;
> > -	int count = 0;
> >  	struct kvm_dirty_gfn *entry;
> >  	bool first_round = true;
> >  
> >  	/* This is only needed to make compilers happy */
> >  	cur_slot = cur_offset = mask = 0;
> >  
> > -	while (true) {
> > +	while (likely((*nr_entries_reset) < INT_MAX)) {
> >  		entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
> >  
> >  		if (!kvm_dirty_gfn_harvested(entry))
> > @@ -129,7 +129,7 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
> >  		kvm_dirty_gfn_set_invalid(entry);
> >  
> >  		ring->reset_index++;
> > -		count++;
> > +		(*nr_entries_reset)++;
> >  		/*
> >  		 * Try to coalesce the reset operations when the guest is
> >  		 * scanning pages in the same slot.
> > @@ -166,7 +166,7 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
> >  
> >  	trace_kvm_dirty_ring_reset(ring);
> >  
> > -	return count;
> > +	return 0;
> >  }
> >  
> >  void kvm_dirty_ring_push(struct kvm_vcpu *vcpu, u32 slot, u64 offset)
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 9d54473d18e3..2d63b4d46ccb 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -4877,15 +4877,18 @@ static int kvm_vm_ioctl_reset_dirty_pages(struct kvm *kvm)
> >  {
> >  	unsigned long i;
> >  	struct kvm_vcpu *vcpu;
> > -	int cleared = 0;
> > +	int cleared = 0, r;
> >  
> >  	if (!kvm->dirty_ring_size)
> >  		return -EINVAL;
> >  
> >  	mutex_lock(&kvm->slots_lock);
> >  
> > -	kvm_for_each_vcpu(i, vcpu, kvm)
> > -		cleared += kvm_dirty_ring_reset(vcpu->kvm, &vcpu->dirty_ring);
> Previously "cleared" counts all cleared count in all vCPUs.
> 
> > +	kvm_for_each_vcpu(i, vcpu, kvm) {
> > +		r = kvm_dirty_ring_reset(vcpu->kvm, &vcpu->dirty_ring, &cleared);
> Here it's reset to the cleared count in the last vCPU, possibly causing loss of
> kvm_flush_remote_tlbs(().
Ah, sorry. it's not. (*nr_entries_reset)++ in each vCPU.

> 
> > +		if (r)
> > +			break;
> > +	}
> >  
> >  	mutex_unlock(&kvm->slots_lock);
> >  
> > -- 
> > 2.47.1.613.gc27f4b7a9f-goog
> > 
> 

