Return-Path: <kvm+bounces-21628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E501930F3C
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 10:02:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AED96B20E50
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 08:02:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B03018309D;
	Mon, 15 Jul 2024 08:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N4N+k4u+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC21FC11
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 08:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721030516; cv=fail; b=o5aefI3DuA8kDEtN5APWj+/d5XNnOf2dySZH+Mf9cXsogTmXEziypsRU4/2fYjdPC8AkGhP/VO4v+6Q30DcVDKBgDFgQLWTEv9UO1CVsoaVEN3e5y5jnRm5WFNmFg8M2pmbFBOlLZOTPKkLJxiH7n81/kH2fgHtKwQLJrOPvpNs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721030516; c=relaxed/simple;
	bh=2W6DIGd/f4csMEjpg7ISw4Lh5JBPXMJTo95IF63wsc0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TxEbrUlplU6fnFeR1rXxCWxTHCjSKu9kCvPuMTP5IB906muUolHYMgCUk89lvGyXknAEsdlYt0SQCHQFu1UJCMasEYuVrFxez/zEXNH+w3vBsyz2QmzzW1yJlU7XbuzGwFthLqBhaEYW1hiQiqScPJuxRk1JAtGIsl8dLFpKgYA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N4N+k4u+; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721030515; x=1752566515;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2W6DIGd/f4csMEjpg7ISw4Lh5JBPXMJTo95IF63wsc0=;
  b=N4N+k4u++Ac3Lqkj3+RM+GmXwIL02LpfmkYoCbvg9Ee5+ZEVSvF0adnq
   9Gf1xbFYYCrI1OMJbTi9XssZCkEUZUzD1Ws/UYfjbAZMnRIVN7s18jXmn
   DLjIv8ZRLLHHWgK//V+cW+LvpOz7L3AIcA1fNH6rHbPy2ozW+8oiuO7Xz
   VbpBhFue663xsnfLmlsybZF0vwg4/d1x0TTqIMeuRqrBr/KnPs/uh2SuI
   UaBHMXkpP3EGDGLYFWdP8GfOI7dEPRXbixTmDyoFqKZMn+V5B3ymfp+22
   Kvo0qIOE6KnDI6akSl5vdLOxYfUmk+Fuo/Q9DNW0VGk8FfL0mNjNEUArg
   Q==;
X-CSE-ConnectionGUID: Z7ZKhqx6Q16cMVA+lZGCeQ==
X-CSE-MsgGUID: hUnKjTiZSnqt0aQtWN8o5g==
X-IronPort-AV: E=McAfee;i="6700,10204,11133"; a="29545253"
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="29545253"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 01:01:54 -0700
X-CSE-ConnectionGUID: 3RYVhsUyTuO8qivUJaZL/Q==
X-CSE-MsgGUID: 2/CkFytESuOJN9lHlCV3LQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="49511504"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jul 2024 01:01:54 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 15 Jul 2024 01:01:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 15 Jul 2024 01:01:53 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 15 Jul 2024 01:01:53 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 15 Jul 2024 01:01:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GXbJLjNs+YfIGlLChjzKIfqhKluj317NDGnCUpcXYzeRO6m2BMVPp3yCekMZO3DxT7yvgwa/B0jf6HTJfm0qTgzt5rzn3LDc8Q5p7JF3W6z2rc6BkOe2hHhbKQngFOErzvlzAA+B3mF6ARQGIYr8rTF9+fyLZMtFAxCxdQKdviDGR4hxHRTErEioDSP9/Uk5b43vh9pI3P/wbWSv8CCvN7GfsaQnIG5sta8IntFbYB6cn7VPzkn2jiwke5ppGkvIyUCb3aWFKqhks3XSZWM1FLmLbJe/vubrz+7hv8z1XtcfcO/twgRlDkCH0k1oebn2enQ0/NZ2QxMl4QWpGgVzmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f0/lkeV8VcAuvfResLfrADuFZ0ggBMYvgVKXBDY3R/o=;
 b=IYu23XHbfTZEMWWYSPIWAqeKzmaIdLgFfexyJUqOeVgk2LbErkwPOmd/NXzE3ovUDZVdjs/s/JQd1/WxlBEkOkZglYXsUfPiRCZiOMwI5/ibf7RNMg3lnlRK6TeHVOM2m3/YEiBC68Xa83Gi2AjRTjQ/TilBFlXID4jXqRjDkgjugtUEeo/SzK0j0qf7tirqmzm/TV0dd8A0VZBR1cPUOW3f1tsLMBCNgVaUAM9MIQ70Y8CqMMLeDvxLAH3Pm2HLoi/frHJXRlEkvRkvZELxEdMWn9QmnWYrD5j1CEj0PyqnWKpXQaGdq0HSCiZDHdIc699DI6BuQkRFvTS5AMe+Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ0PR11MB5894.namprd11.prod.outlook.com (2603:10b6:a03:42a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Mon, 15 Jul
 2024 08:01:51 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 08:01:51 +0000
Message-ID: <8882de71-dcb1-4cd6-9f3c-bac7775bdff4@intel.com>
Date: Mon, 15 Jul 2024 16:05:46 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] iommu/vt-d: Make helpers support modifying present
 pasid entry
To: "Tian, Kevin" <kevin.tian@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>
References: <20240628085538.47049-1-yi.l.liu@intel.com>
 <20240628085538.47049-4-yi.l.liu@intel.com>
 <BN9PR11MB52765AC4F822E3E99FB55DD88CA12@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB52765AC4F822E3E99FB55DD88CA12@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0107.apcprd02.prod.outlook.com
 (2603:1096:4:92::23) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SJ0PR11MB5894:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d215c95-4e11-40ec-ce8e-08dca4a46225
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?U1I5ajlHL1c5MjNMeGdpWVpyazBmRGJOQS9sZVpDVm5tWjBsOVBVbE10TmE5?=
 =?utf-8?B?bmFQWFRodDZKeXNMaTZHcUt1RU5MUmZaVi9Mem9xSGgvbnJaYkhxbzNZSnRF?=
 =?utf-8?B?a1NvMWRMdmFQZ0YwcEJST3U5d3o4QnJ5TDYweHl1bjhadkVvbkFiOVRyaTZ5?=
 =?utf-8?B?aXJ5Y0xwbmNqbFJZWEMxamVRN0YvYXdpOVcwWUliSE5SOUkyMXZsNnNLQm5I?=
 =?utf-8?B?M01QUGJBMXdsY3k4RWVtTWhmK2hKVDU2TWJScGd1ZVpKREs5TkRaRVpzcmdp?=
 =?utf-8?B?dS9DcmdhYWtLWm1DV0VDamxqZmpqL2wwbHZ0bFBHNG5Jc3VkVjM0OVJuWTA1?=
 =?utf-8?B?Rk9EeWZuTC9qOFdxcWh1QmRDQkk3SURaS3R3d1IyTGFYMUk5RloyVDZpbXh6?=
 =?utf-8?B?eXYrKzFsamFJN2M4TVdqby8vMzBLV0hzUXgrekpSOVZXWjRJUU1mZ25kUVJZ?=
 =?utf-8?B?QnZ5VUdVaC9tL2NHT2hCdUNzejk1S0x1TVFMT2x3U0h1bXhFM254T25ITjUx?=
 =?utf-8?B?WG1yVnBBV0tkbm9Tc0o4QjhiMUJxbndVcVMzbjk1d3UwQWNPRlpTTEY1dVVs?=
 =?utf-8?B?aGwveGZNYkVyTWNqa3Vyc3ZXODZIMDNKeXBQaE1IVlRaWDArOTkwTm1ZOUVT?=
 =?utf-8?B?dSt4RFZsZjI2OWthbU8yeGw4UWlwRktiT1h1UkVuSHNFdlI2RG9vYkRPNEFH?=
 =?utf-8?B?YkhiZXozaW5UTGpoYmRFSWJGNkE5YTlseVJ3U0tIWCsya3E2YzFUaWI0SmNF?=
 =?utf-8?B?OEdRQU80eDl2MmVSYXJ1NCtsUENUK3NYaFo1MzlBbXRGbVU2NXM2QkZ6U0RV?=
 =?utf-8?B?ZForTXc0eTFyYjRVaVlER2FEc1AzQTZxVWdxK3BTQ3lpNm9JU2dFQmJCajBR?=
 =?utf-8?B?UHNWYUIzU1FaNmxmY3pGRXF5bnkvZnhtWCtqZmRVM0JEM3l4VmFzTXFxYTRl?=
 =?utf-8?B?ZkltVUlIdGFyS3NwZExwV1l5MXBtTGFvNVN2VVo3MDh0UkFPYXl0QWJURFcv?=
 =?utf-8?B?ZDB1NU96WldIc2p1eXFkRlVQT1habXoraUV2ZW50T2pIRUtYTzA0S2hiWkZk?=
 =?utf-8?B?Mm5od3VlaG5nWUNOK0hhblVxM3o5bmg3NEh3dWE4L3gzQkNlYnRvWlR1TVJS?=
 =?utf-8?B?TFUyV3FiVDVtYmNsRTR3WW9wcTZlSTArV0h6MG93bEpOai9OSm5iMmtvM0lR?=
 =?utf-8?B?dFcvU3liZHE0WjNlOHI3VzBUQmprdnNMM2JrYjlURUk0TnBKTWZZMEp1SDZo?=
 =?utf-8?B?UDNsMmdDRnhlSno5MG51dFJHNzF3Uml5WElFeHJUZGszdGJsTWR1bk85alhO?=
 =?utf-8?B?S1l6QzQvTWtJQkZmdXBiZjlxbmRZMExyUWpjT1Rab2Z0Q0o5R2h1TmtVOGQ4?=
 =?utf-8?B?bjk4Wmx1cVgvV1YyKzRTKzdlTEsvVkN4bXlZQVIwTzkrYXN1SCtKWk56YTFX?=
 =?utf-8?B?MG5LTDFwUndId2R0dkVadjBhR1prSjhTREo4a095TituWGp2SnRhL1RwQ21i?=
 =?utf-8?B?RWdUSlhSd0YvSTB6Unhpd3lXSWxzWWN2QzNvK1dERUVyVk5JZGpOMHZmTEsv?=
 =?utf-8?B?S0VqblFqQUpuNmZ3Wlh4elJkd3dnSGhCMit4SXBCS2NSbWg5WFdsdHlHcE5t?=
 =?utf-8?B?MGdsTVQ4UkRkNlZkSENIZ2ptakFobE0xOWRpQ1ZDa00yenl2UFdSeWFFUmdJ?=
 =?utf-8?B?UHpDeWwwMWtpL0U5eXV3cVJ0bjl1aFNPbGZpZ1d4TmZ5L01QeEFmUDVDa2Zy?=
 =?utf-8?B?SjQrREZxci9ITUZvdk1ud1NUR0tZalRBeCtUUUtpU2paMkpQS3hubVdidUUr?=
 =?utf-8?B?NkMyRXFUTE5ZTGVORG5NZz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VDQwejFiV21RQ0Fuc0J0b1EvZHZYbzh0ME92OEJnQlBwYzV3NHJNOEx6K0Nr?=
 =?utf-8?B?L1FEU2pQMFJYbzdvMFA2ZWJsWlBzZVlqVUV3b0wyd3k4ODJ2c2NoanBRNkhY?=
 =?utf-8?B?ZkJUaWp4Zjg1cVdkN1czUmFOSGhHWU9GOUVGYVo2Mis2c3g3V3FkNTdvaXUw?=
 =?utf-8?B?WTFNTXRKUHRTS0tFRG5GZWZKaW1ZZ1ZFZEZyZmZFWEFFbXVwY28rOWl1REpq?=
 =?utf-8?B?c2V4TXBKTmNvWHB6V1c4NGJLZmZ6aThXc0lIa1VheFZKWTU0bXhyTjZGNk5Z?=
 =?utf-8?B?eUUyb0Y0WlJwYkNFRkd5aDU1eXFWeUdvOGNMdHBvNUd3Z2VoK2I5N2Q3dGVZ?=
 =?utf-8?B?aUE2RC9SVzFybXcvd05hb0FXZTJxVi9vd29FN3Npc1JQZ3pHYThQc1k5RDJG?=
 =?utf-8?B?cXQ0NTdha1RRK1J2MEp5TGt1WEFWNFZVcGd2VFdrNG1yZ1RNOGRzOFkyYnQw?=
 =?utf-8?B?V05nUTFVSFgxRVBUQ2F0RTVPc2ZTQU01bFZDZVlQMVB0UmpMSVVTRXhtNG8v?=
 =?utf-8?B?NjU3cXVyeEZCcnE0Nk9qMEF2bGJRblBvYXo0cUp1VGdlR1BPNTJQeGZ0UTR4?=
 =?utf-8?B?NzRrVjhZL040bEZkY0FGSkw2b2hDSTlJUEtvbGZqMXJ1YW45UGRiSjNoOTdx?=
 =?utf-8?B?T1I0UlU3OFFYemlncGJFcTh3NmpUMmFUeEtORkI3R1VmQjVjU090L1h3Tjk3?=
 =?utf-8?B?MHhmY1BhU0R5RXZEamxhaGgycmhKS2luWGVDdFNPWlJHakIyOExuTC9Uanph?=
 =?utf-8?B?b0NGeVhwQ1lpVEpvSjBRTzBDTzgrY3JESHh1anN6anVpU3VxaUhnNkcvVUY1?=
 =?utf-8?B?eTJEdDJjdXZ0L2ZsRUxyR3hVRXhLZklJbU1OQkFxK2V0SWxqWnJ1MUt4c1Y2?=
 =?utf-8?B?eURDWWdHcG5XWHpYOG91K0RmT1BIYVRZbXN6RjdaUlhONmwrVFB4Q2ROYWJ4?=
 =?utf-8?B?b2s2ak9qdmR3SmgvL01zMjFkWEdKbktvUVZIZ3hXRERPNG9nWnYvemJkQ0Jz?=
 =?utf-8?B?MUdLZitNRzRMVWVZM0E4bHp6UVNVMnU4aVcrb2UzaGEzQUVLT2Zwa0FWM04x?=
 =?utf-8?B?NUIrb2pmc3pKa09IYlNscnRyQUQ1STVodUV3dC80NGQyaTZHZGtTajgzS2Zr?=
 =?utf-8?B?MDdib0lNcjVrZzR3dUhwKzlkTVNNNmpNMXNhWEdTVWZsQk9ZdE1tVTRhaXRC?=
 =?utf-8?B?K04xenpHbVRZSEdseFUzeGpqWkhldDYxNkNLU2ZPOXFhbFpueXp5ZlFyZnRk?=
 =?utf-8?B?SmxIVWhESm5sMVRtbWRPbnU5VzlUL0xSNHpIVFhsZExUZXVnU2FnNDJtV0Mv?=
 =?utf-8?B?MkI1YlRZZzFGQ2lwL3RkRkZXblNjZFByUElaOUlCTzdtNXliNHpEUkFXQjZB?=
 =?utf-8?B?VUN4NmxKWjEzaEhxMkQvU2NGRXFuYzlUVFMyYlM0Y3lkeVl5ZkZoVEVWMENO?=
 =?utf-8?B?dDExQUYxd01ybXMzbDk3MHJyckR3dDN6MnJBanlOWDRvWVU0UldjS3lvWG5j?=
 =?utf-8?B?SDU0dEdOeHdnMUl0TUpzOWc2Tlh6WHQ2QmtEK3NldEo3QTM3L0dqWmNMNVBZ?=
 =?utf-8?B?T2daTnBab3cxeWVzV0d3NUZJVnFSWC9wa3NRMDBFbW4xUGpjMXk4cFczdHlh?=
 =?utf-8?B?ajB0MjNXOStNcFBiQUZKYnZDd2ZndTlnMjNuaGJLRjFneTZwQWVJR2lieHBU?=
 =?utf-8?B?emhrSWQ2UHNYd0F0T2w4ajA0WXAzVHRDS3YzOUpkdHg1b2c3RjloOEQxem1G?=
 =?utf-8?B?VnY2a2lRL05yd1pydGtFODhyaktZQ3U3YXpZeUZ0U0hFSXlxUUY0NWtFYWI3?=
 =?utf-8?B?am5QRFZYazdMQ3IzYjlQeXp6Q1oyZGJacWFueUJxTlBVQmRuZjdwRW1JUkI4?=
 =?utf-8?B?UnpkZ2U4Unc2SW5jWnREN0dZZkNTck9wQ1V3Ykd5OFo0bG53YS9UM2p6R3No?=
 =?utf-8?B?NWgrbEJ2MEFuK0o4ZTB2bnhTTDE1aFg3cDUzckIvc1FLazlRd3BsZUJNeGU5?=
 =?utf-8?B?MDg5TlZGU0k3dkprY0tRRzQzNUdMWHBIei9MalloR2Job1RJaVRBYmFtTk15?=
 =?utf-8?B?cENxMXFnSldRY2JyRUZXOERONStRYlcraUwxc2NkblJGcS83TzU3L25ZQWZH?=
 =?utf-8?Q?2xR+IJo7416XYGl+zZ4kg/lJv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d215c95-4e11-40ec-ce8e-08dca4a46225
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2024 08:01:51.1062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xH8N6mvVa+LTR5/ND77CopojL6vtFE7qa/xWwnqwzzDe/JwyrhcxBrdYmTNhq2kaVRsYnfGFu9biwIRFSA3T6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5894
X-OriginatorOrg: intel.com

On 2024/7/15 15:53, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Friday, June 28, 2024 4:56 PM
>>
>> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
>> index b18eebb479de..5d3a12b081a2 100644
>> --- a/drivers/iommu/intel/pasid.c
>> +++ b/drivers/iommu/intel/pasid.c
>> @@ -314,6 +314,9 @@ int intel_pasid_setup_first_level(struct intel_iommu
>> *iommu,
>>   		return -EINVAL;
>>   	}
>>
>> +	/* Clear the old configuration if it already exists */
>> +	intel_pasid_tear_down_entry(iommu, dev, pasid, false, true);
>> +
>>   	spin_lock(&iommu->lock);
>>   	pte = intel_pasid_get_entry(dev, pasid);
>>   	if (!pte) {
> 
> with this change there will be two invocations on
> intel_pasid_tear_down_entry() in the call stack of RID attach:
> 
>    intel_iommu_attach_device()
>      device_block_translation()
>        intel_pasid_tear_down_entry()
>      dmar_domain_attach_device()
>        domain_setup_first_level()
>          intel_pasid_tear_down_entry()
> 
> it's not being a real problem as intel_pasid_tear_down_entry()
> exits early if the pasid entry is non-present, but it will likely cause
> confusion when reading the code.
> 
> What about moving it into intel_iommu_set_dev_pasid() to
> better show the purpose?

I see. will do.

-- 
Regards,
Yi Liu

