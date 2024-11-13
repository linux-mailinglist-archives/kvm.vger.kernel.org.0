Return-Path: <kvm+bounces-31709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00D589C67C3
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 04:22:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A96E42824B2
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 03:22:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CF2016D4EF;
	Wed, 13 Nov 2024 03:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dNit+jSc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4AC166F26
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 03:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731468127; cv=fail; b=XCbko2bebnkvPA/2Jats6Ebu0cUBQEOjZyRpbY2mryKPQHeTeuoeMqXoGfOi8oq643VDa4q2E8ICDrwG5NMa5L9SodiMBviAEuzyo0D5TA+UrHgjvunTf6CMoHF5xq1/Q+OJfqv0ChXqVvjyapVIlb+qP9/SZtsz5gxh1ljrLlk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731468127; c=relaxed/simple;
	bh=T2vOy5UfqOYYEXEInE5A/aV7rfgZc3Ohc+hGK7wwh98=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u6Y84akQBoJuEXN9cuq0dc9WJv4VUkoDbNAgoHh28DNc3BQ+IjUgPBM+3ApTTspUBuqYf6DgJWxhMH92ye9ARRUMf38qzoY203o9RT0nP7z1SUvHeJpy3sZKexIyyPl7qYPfyfZ23nZXzWWe4ymxgq/v1d7mzCR0IehSBPdcV9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dNit+jSc; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731468126; x=1763004126;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T2vOy5UfqOYYEXEInE5A/aV7rfgZc3Ohc+hGK7wwh98=;
  b=dNit+jSchU+wkTzuObGmw/dlscaKVOtKeqD6fgzdACeWYM7H2FUqWO/M
   GfvpHG7sjGRaTAeUToK5J2KC4TC0bv22FdsdFGWuWrqEywBZj4WpllCwa
   xreGeWJTtmGNu6yHPZTTmiVX7Cfl5lVhoJ5pGZj9J+muEvKjZShP2wfEk
   uzrpBqmrFFoJEyUrCyILv3FEwE6S9cIYwsiOk0W43neWiXlrNvYBH3tVP
   /4LdaQg06+jNgHox0qTZRktriqgCvUAS5KluSHFxTqU5anAC3hrn+PnYz
   ABWy1M2RU0nCG/XC/3PLcVWuHdE2Ps1qRC2SWu5nBxKkxC1kQQ0xkKvuN
   Q==;
X-CSE-ConnectionGUID: yKQWAC2zSi2+1IRxspYSVQ==
X-CSE-MsgGUID: UykEqBJ1QounpEX6q+/SWw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="48794677"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="48794677"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 19:22:06 -0800
X-CSE-ConnectionGUID: I1aDMbV8SUOcnFC6VYeINA==
X-CSE-MsgGUID: VeU2C+S7RRixX/fgoBJ3iQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="125251096"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Nov 2024 19:22:05 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 12 Nov 2024 19:22:04 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 12 Nov 2024 19:22:04 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Nov 2024 19:22:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZY3T0A0RjzRRX0M+vT72t0+e6/smBq88nQASJm7MXADrpSeQTTQC4guEblxWbS1XD/bfzXfx9nhPRIpXqkAiCs2V/n30K4BoByDWe/HvKh6z1pBFHKkR/Fq8dYGkEZbLoclfcZE/auCpCtEppXx1oHSr4EGI5y8k9FQqVaf9NjaCtnCs1KPthqDBPHH6SZtg6luij95cuj0SwVw4MJt2cg/VM9J7xMXBlwN8BQn9/KW81kdPFzNSdpTwJwEImwZsYRAgpx4lyVkVMqGFWGKN5cy1i8sYW8mY2aV0qzN+nuw3Arv4wFc3wMnIulkEo17cFSlfWjblMeqWsoX4lMV2iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=djtiIDvqYAaEmALs+aA/kRUcca6ZoA+sZSDEW7HZd+Q=;
 b=Sk/6JEi7gfFuaWvXobCTJ8gWsfpsGL4/wXtumH1wQnGFCFbe4m1gptyVE8VeJdEz2q247wuOyAmK8gZZtl4G7AQ2Zxp5aZOk7h2f2nv0N57lO0mYANpIH7FgMTDe2mX6S/sA+srqsuPJfaRi9mFbFueX3/2Hi/GhMeyZQuD+yozebVWpkFl80VaaqoQQZkcLaHMGWy86thUrZTllptx7w5nTBuH0Rzjaign4tqmnTMOFSOSDq8DSMWcRvkJzMndQxTiWtCZ/s9SKe9PI63SAcpYppKS6FddCaouERs4sOcaVLdNig89b96ZB9hDKNaPxmPJdn7G36QofZFV7swiw3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY8PR11MB7105.namprd11.prod.outlook.com (2603:10b6:930:53::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29; Wed, 13 Nov
 2024 03:21:54 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%5]) with mapi id 15.20.8158.013; Wed, 13 Nov 2024
 03:21:54 +0000
Message-ID: <ab2bdbe3-d21a-400c-8a63-ed515b4fab72@intel.com>
Date: Wed, 13 Nov 2024 11:26:32 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/12] iommufd support pasid attach/replace
From: Yi Liu <yi.l.liu@intel.com>
To: Baolu Lu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: <joro@8bytes.org>, <kevin.tian@intel.com>, <alex.williamson@redhat.com>,
	<eric.auger@redhat.com>, <nicolinc@nvidia.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <iommu@lists.linux.dev>,
	<zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241113013748.GD35230@nvidia.com>
 <4d0173f0-2739-47aa-a9f0-429bf3173c0c@linux.intel.com>
 <745904ae-f9d9-4437-88a0-7d4cb5d19053@intel.com>
Content-Language: en-US
In-Reply-To: <745904ae-f9d9-4437-88a0-7d4cb5d19053@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG3P274CA0020.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::32)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CY8PR11MB7105:EE_
X-MS-Office365-Filtering-Correlation-Id: 274583d8-3d53-488a-1a54-08dd0392526b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bDhaay9SNmJpK0lrME9mT1N1Y0U3d1Y4eEVRWXAxVFphUnZ2Q01lSUIyU2xM?=
 =?utf-8?B?ZDVzbFNyeWZMVmdWaUx6dFVrbWcrSy9qamIvU1FNU0pDS0pZZHpNYm9za2Fs?=
 =?utf-8?B?SU1tQU5tRlp0aXFxeXJSbUxweUtuL1ZacytLRWZ3TFNidzh4ZkhZVlFyOHRi?=
 =?utf-8?B?VC9OYjlMZzNaY2ZCVCsyb3gzS29MZFIreXM2akJIS0FYbWtWbDU5akVWTU9p?=
 =?utf-8?B?UU8rL0s3NGlVRW5UU25qVmlBTXZVSXVnV3BtNUphUkhJSG1SV3YvUWtNMm8w?=
 =?utf-8?B?ZUJvZkgvaGJiSk9qbGhrUVpPRnQwUEJ1K0Z0TFBWUEQ4Y2c5TGlhSTBaMDdZ?=
 =?utf-8?B?SzRBeXlZSWtCUUFhN1V1Y2xHbVc1WHNQaHVoZGlUQzRRRFlEbWordWlFZTln?=
 =?utf-8?B?SC92cHVvVmN6YWtmUlJ4Um44QjJ1encxTFdsbWpFeExzNDFNOUNMK0VCVDh2?=
 =?utf-8?B?MEw4VkkxeDBqcWxPTzMxTGhDYnFBTXNXMTd3Q3hyOWFrZk5MRGZWbTcrZmFS?=
 =?utf-8?B?cGtmMkFhd0tUaXJHWUt4OHlzS0t1MmJVR2J0R2lSVUZvVldEWDl3Mm02MFRI?=
 =?utf-8?B?SFVPL1ZKU05xV2VKeXhiRXZhVmV5bjJOWFFCdGtBc3ExZHJaVUtGam9KRlpO?=
 =?utf-8?B?TXZwV1lTbGthd3RQODZiV1FPYUFzQzRPODR0Q2NVcW9MN0xOeVVMRDl5ZTds?=
 =?utf-8?B?d0VlVWpPWnBQSlVpN3hhSVZRNmd0Q05EMjBhbjNLM05waW14QXNheklnNVhq?=
 =?utf-8?B?dVpSL3E3Tk9YVHM1b24zTjREYmJBaG0vNnVyYldZZUhFM21hYjRMUGlkQXJT?=
 =?utf-8?B?Mkc5a0VOQmhhS2lwcnluQXdEK2RjcHJGcEswK0xyZDd0S1FBREowN0RrdU1L?=
 =?utf-8?B?YW9HdmtVbnl0L1RiNFRrejdlL0NLclVzeXZ1UEVBcXZHdURGekxRRUtSd3Fm?=
 =?utf-8?B?bjZ5bHV0STZ5VDV0aERCQmNjb3l5ekdtelVpaWJvQUx1SHpySE81Y09WdEph?=
 =?utf-8?B?OTJaa1o1K0puSnZDbWFVcWx1dVBtMkJBSnhRQlZYbUY0WTgwS2dSRjNNZ1Ev?=
 =?utf-8?B?YXZwdVNpRkxKNVphQVBsdEcrS2FMRHZ4SzJRVGxqaXJOV1ZTNmNpcWlwSXR5?=
 =?utf-8?B?bzJ0OExldlNDRmNYL08wYlRjT1hGN0ZTMkkrUWVHVGVRdHNxWmlsZnY5enln?=
 =?utf-8?B?b0pEc2lja1ZEbXowcnkrdnUvTlVwR1krOFdVVDlzWi9BU0ZxTEVFNjRROC9Z?=
 =?utf-8?B?TDVkSUFBL20vQU9UNUhjOWlSUUU5N2xBY1VqdTY1dFZaYy9lc2RSTWVHZm1W?=
 =?utf-8?B?QVFQdWdWYWFWdGJQdHhmcVVEWHZ3ZlFtMzhKSGpwK0N5MmFYSlN1WHRiZmI0?=
 =?utf-8?B?dWtVS250T2s2K3QwaXp0bHJKRUV3dnhGaG1FQVQ1ZkQ1OUNYbDFXd09qSDVj?=
 =?utf-8?B?Z1N4cUZ6SGpzTHVaak9NNTM1SjdIZHBPN1NOKzFQWVlLMzNBSHZxNFZlTFpR?=
 =?utf-8?B?QnNmTzFMdjV5a3oxeGg1VjRsdVlReDExZ1lNSFFWakMvcHFyQjVhNCtvaUlN?=
 =?utf-8?B?NjRLaE1STFVmTjRmekxodjd4UGpXaXBicEt1alVkcU9ncDRGbVJDZkV3WGdI?=
 =?utf-8?B?b0x2WkEvSDhFRUoxclJkeEx4MGRDTjF5ZWNNY3NubjlZVWRsQlZjRHQ2NnlB?=
 =?utf-8?B?b2xBUWMrMnI0SjQ5Yk1tRmpxYkFxYnNmQ1J4cUpKd1VxT3ZlN1QxdW1yck5w?=
 =?utf-8?Q?B5+vmTCdOuZfd00HutXlR9UgbrWSEE6GOilK47o?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZDNDQ25HSW0xOGxOT3AzMnVjSDdUVEc0VDVOWXhIZFNUOGlLMjlOWVB6NGdC?=
 =?utf-8?B?UlpFRzRIYkUvYWxxRGhnR3R1cC9hU2JwWnFrNzE1a3FjWHAvS1ZJcW9BNWl5?=
 =?utf-8?B?dkYrRDhHK1Y4WkdjQ3d5aXE0YkZBUnZVcHBRYUVMb1FrT2VVd2VQQzh4Y2JL?=
 =?utf-8?B?L1U4RTRqOEpRSTlzeHRhZVJEcVVMc3JYSkdocDc3TExCWTJaajk3bW9mLzZU?=
 =?utf-8?B?UEdNVHd5a0FncVFtVngwZDBhTmtuR25PMXl3Q2FjTmVXcjk4SDVNUmJpY0N3?=
 =?utf-8?B?a2VlSTlTQlpLMk0rb1doNEZWS0ZOUUtJVEJuLzBtUThBcjBwb2hUbE0vQVhj?=
 =?utf-8?B?NXl4UWxwdER4ZUdiSEhGNUpZdUJ5SVFGcWhpRTJHTEowVFZiVGRBNzNVUzB3?=
 =?utf-8?B?cGw0SUZ0WHB4aVd1MmdHZC9HQU1XZUF4cnl1bnBLa2UvY0pMaXJMalRSTzRI?=
 =?utf-8?B?N0VwbGdlN0EzSjdIcHlDbytkYmN2OFJ0MFBsSlhlTjN2L2V4aGxrOGhmL2dW?=
 =?utf-8?B?NUN3ZzdnWEZWNkdYdjF2TnFNTHlyUlVwY1d4d2dmRWxJbEJxKzZZSzdEZFgz?=
 =?utf-8?B?WG01Tk9jR3p5VVdJU2FhM3JCTngvRWdzNWdvamhhMmJoTUFpd1QwOFZWUFE5?=
 =?utf-8?B?T2t4WEZML3FZU3pwNFMvdU5EbGk4cm5FbkJnL1ZReTRYSlhBRC9oZW84MW1F?=
 =?utf-8?B?WHhBeWpDYUVlSk5GT0Q3RFBNcXNnWWVDbWE3VmFVM2RYR3JycDVwaVJFNWNV?=
 =?utf-8?B?bHM4OUZqWUVBTjRYeUFXUWt6SU8xVEltcytqSy8vSithRTdDTXJlakFOS0JL?=
 =?utf-8?B?TXdSaG44NmZieW1jSTN4L3NCandRbmFSRGZua3B1cUp0SlI3ekJqSnFKSmho?=
 =?utf-8?B?NzJWazZIeExFY1NRamtxV0NLWDMxMWVUMCtrM042QzJMd0hQT3dTcm5mbnNE?=
 =?utf-8?B?Z3JMZzUyQVRRMDIvT1NJbjZHekxYVEFUenpaMGEvUm5qTmZQTXFPYTBPc2ln?=
 =?utf-8?B?eWpNUHBvRGpzWFZUSk5RakhGaDkvRGpTdURjTDBBYldoRkNOVWtMbDV0NnBC?=
 =?utf-8?B?M3AzdVY0WEpseTZLQkEvVGJua3RSbEpPYVFHalZDakw0dUdISVplWGx6R0VB?=
 =?utf-8?B?K3ovb0NKK1FFNkx1QjV0QVpGMmVPbDdhMGpZeXhFWTE4TWpKY3hVSy8zNFR0?=
 =?utf-8?B?Y2hsQzJqcnN1cjZvdUlLMTdWTkoxRzZENTZJZk9zdWVyb2JaeE0zMzJSb3hn?=
 =?utf-8?B?aHRRSjh0eFpmbnRkdEl4V1liVklIcVNtSWpwQzNIZkVPVmlFaHc2Z0ZBK01T?=
 =?utf-8?B?WndiMVZoQjgvMEE4NkFOUExSblBSdFpUenpYNmF6WG9Hc1pPeFpCMkp3ejJ0?=
 =?utf-8?B?QjRCbTIrUCtIa2VoUFFjNEp0UWFkbUgzQlVTazllUGZkQ3FyVk9BSmg5Qk5l?=
 =?utf-8?B?R1p1dmduZW90cjdiSG5rY1VFb2doMDAwMFFjeDFVS3JSaERRZjE1bmtVR0lo?=
 =?utf-8?B?K0VoZVlaL1hWT0lFMW9YRG5mRzhwRWwrSWdOaUh6QXkxZW9XNUtteUtZNTEx?=
 =?utf-8?B?LzNublNuM01Iby9QMUhTMndnY0h0ejFHZkE2dnRobk53VXFoM1d1cmpNcDJi?=
 =?utf-8?B?YjRUblZhRFBXSnpsSldpRktWQ040UHpnOXU5QzNqaEMxanhGbTlmZ0JzdXZz?=
 =?utf-8?B?ZzlySFhPd1hZM1FqdHFtSDMzY2pYY1J3T214ZFh1bjZHZkFCdERSTEdpSmVM?=
 =?utf-8?B?ckJCQVZ3OCtRektvTEkrNWx0VW1iZThzd1NvRFJ6eW8yWkliRzI0b0VQZlBT?=
 =?utf-8?B?QytLZ3ZaK01UeXV5clcwUWtQbHlIZFpaYklKMDlxYkYwNXRaUUo0YnlwZ0Nq?=
 =?utf-8?B?TTBCMkVOVDhUeXFNR1l2ckdRdXVYU2gxRm01bE9lNzJtWFU0UnYxMlVwUEg3?=
 =?utf-8?B?L0RvTXVCaGx5RE5oTTIzaG92aEpPZ3ZPSXR3QUJ2ek5PRFpzcUpNVW1oNjVz?=
 =?utf-8?B?dmNHbEhkQ0RVcDFpVFVzclR5bzlCKzVPRmh5QXN3N0pSd0tQNUpMOUo2TzFM?=
 =?utf-8?B?ZGtlRG1pZzFRdlhET3Y5VlBKTmxsSlh5cWVvYTNoVEtLdWdKRUZEV3Vscnoy?=
 =?utf-8?Q?Cqn2x2tt9+1MJ1x1z7nbYVQAp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 274583d8-3d53-488a-1a54-08dd0392526b
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 03:21:54.2296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QPyP8NPtcP8sflb93rNJW+UBMIGThwUYcIFYPF65QJ/8hhIBFMRyKBewgi8WG73be8JQOhHQKpEMfFiU+CrAMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7105
X-OriginatorOrg: intel.com

On 2024/11/13 11:24, Yi Liu wrote:
> On 2024/11/13 11:01, Baolu Lu wrote:
>> On 11/13/24 09:37, Jason Gunthorpe wrote:
>>> On Mon, Nov 04, 2024 at 05:25:01AM -0800, Yi Liu wrote:
>>>
>>>> This series is based on the preparation series [1] [2], it first adds a
>>>> missing iommu API to replace the domain for a pasid.
>>> Let's try hard to get some of these dependencies merged this cycle..
>>
>> The pasid replace has been merged in the iommu tree.
>>
>> Yi, did I overlook anything?
> 
> I think Jason means the two series I listed. The first one has already been
> merged by you and Joerg [1]. While the second one [2] is not yet. It might
> not be a hard dependency of the iommufd pasid series, but as it was
> originated from the iommufd pasid series, so it is listed here as well. I
> think it is already in good shape except one nit spotted by you. Perhaps I
> can update a version and see what we can do for it.
> 
> [1] 
> https://lore.kernel.org/linux-iommu/20241108021406.173972-1-baolu.lu@linux.intel.com/
> [2] https://lore.kernel.org/linux-iommu/20241108120427.13562-1-yi.l.liu@intel.com/
> 
corrected the link [2].

-- 
Regards,
Yi Liu

