Return-Path: <kvm+bounces-31069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE2F99C0016
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 09:36:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5FA81C217A1
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 08:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D2E71DFE0F;
	Thu,  7 Nov 2024 08:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hVY46HMC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDCA1DCB31
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 08:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730968520; cv=fail; b=kwQ5ptCoj0t1rXRzfV36bDW/j20trKBf+qzzwL/RMOHfmyrtJqwKyCTnfypaxzNMlO5NWpIAfRllXQ9FLSUKHoAFiUamVBI6tuKCsQSySwiOzuyvkBYJxXUMNs4xeqWMr+eu4FgTLcobCd/X6qnwPkjsDI59i5kr85qG5dNt2jU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730968520; c=relaxed/simple;
	bh=ZXKnAVQ8mvYdm7VWNQ0kXUpcKK7zlCrsVP/HJAyDdlE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tvy0dMvfZAFRli8/A1gD8C3LyDqDgRH4EA0vpN/tgPQKNaXObf0SFMsT2kK2X4Mv0Tk8vvs+08cukop8Hi6uowk1b7adebyQ4J0ArLzA1nzvYCNp5cUWmYJPrCeXE6AdCy5YFdC+yjXLWguchdJjaQCxlt5tAgCXmNkk5bmbQ7g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hVY46HMC; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730968518; x=1762504518;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZXKnAVQ8mvYdm7VWNQ0kXUpcKK7zlCrsVP/HJAyDdlE=;
  b=hVY46HMC9kXG1YqQQFONE/CMkK48FDlxDmrnS1+uZPvQSxdz32qwSpch
   8Ipzk+HO27lFpt7fjEISgTwVPT1nmnu+d+KSBHFAAG4gZRonu4xZDxxVc
   Oyatg5aVayPUuYL65jIXoK9q5jLl6bOG5tnFUxbnpNuOcyKCfd3L0E9Id
   8YxiZBF2076N10X97F2cswOL545UMyOw8ZAxCv7EbJiQgwC21RQWYLgcO
   8VeLxADpO2cCalW8FeQbuAtjgPen91P6mD4jCo0TqC4EV99hnLWvgOQ7X
   2D9o+tuy6h5Ty8MPntptePIXG7Mbj0T+QIBBGA9bGLfv4vuorohMOMR+N
   A==;
X-CSE-ConnectionGUID: gGNQyoOuTZeS58Bx8nNQBA==
X-CSE-MsgGUID: UgW7robwTD2FlV0/Ct7hNA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41902357"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41902357"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 00:35:18 -0800
X-CSE-ConnectionGUID: CMsjWGJjQj2q4Y+5ZFDxdA==
X-CSE-MsgGUID: m4BTJl2zQpeRHjpGLYSIyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,265,1725346800"; 
   d="scan'208";a="84958438"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Nov 2024 00:35:18 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 7 Nov 2024 00:35:16 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 7 Nov 2024 00:35:16 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 7 Nov 2024 00:35:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h4f831/SjuEyNaq4mZ3bBeaV+/Lxzp1e/zkICZvUSG022p2/KjIT9SqUEYUqRQlALYNqXOknIRnaKUj3w27K+vmEFvHgxeABmuPQzKJS31fXtgajphAci90fzX18SqH+nbsbP5t3qoHLeKGnl0CmxQgJndV4HkYE/aJpK1F8YZR/qaQytD0FoPafiiNp9Ap5os3TtRz7tWO7dNkZPSUt2yQEIINc9CdgZPk8MIWIgdlpYqC8tcaWBdr8ZwaI9smxKQQXRvGOEc+Wp7IAothXNceTzoMSoThOHEswevHF5wuRjFz8eY+UBRkjhKb2DOGWWuKPFQYi0T+/X3ElBGA8hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EyK8Mb5o4ZdF6Wy5MyYzHvk4IqAVKVn2k+F/L7bn1FQ=;
 b=f7nYw9+EgZvFnsu7mVrscAE7vVHrNMjHSwxRoO3nD8oSNOT9WwghkEqF3gZuDY4quj6dm9RJBYRr3YHKCPVPjKcURsWEQ15DwsFm6FEH2GjmwTSZYHV7xME9Mr5hLNqD/dBcHeRL/uf2BlL0+YFYn1U5E+0J6w6/Dj+btX9gXqBSPT7OfjiVwnU7Gh6pm0hWIiYovnUpgOUFbpSgbV5Y4RlwKths2e7NysMgEvNV9gbZxs9zO89CxnCCfX4lxCWare6ASrtFZquoNYzd63mu1QRw0T3DcPzlM0wHB+PCBC66H0Wvfcn9vfZv/cm0x3p9dXDSDKvhPhRXlriR91TLCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB7357.namprd11.prod.outlook.com (2603:10b6:8:136::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Thu, 7 Nov
 2024 08:35:14 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 08:35:14 +0000
Message-ID: <f73869de-38b1-41cf-bd20-d91523e4fd08@intel.com>
Date: Thu, 7 Nov 2024 16:39:51 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/13] iommu/vt-d: Add pasid replace helpers
To: Baolu Lu <baolu.lu@linux.intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"willy@infradead.org" <willy@infradead.org>
References: <20241106154606.9564-1-yi.l.liu@intel.com>
 <20241106154606.9564-5-yi.l.liu@intel.com>
 <268b3ac1-2ccf-4489-9358-889f01216b59@linux.intel.com>
 <8de3aafe-af94-493f-ab62-ef3e086c54da@intel.com>
 <BN9PR11MB5276EEA35FBEB68E4172F1958C5C2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <7d4cfaef-0b3e-449b-bda3-31e3eb8ab300@intel.com>
 <8d015a7d-fa64-4034-8bdb-fffb957c0025@linux.intel.com>
 <9cc98d30-6257-4d9c-8735-f1147bd1d966@intel.com>
 <27c2acfb-a428-486a-bd10-7d34a8cae4ed@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <27c2acfb-a428-486a-bd10-7d34a8cae4ed@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0048.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::17) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DS0PR11MB7357:EE_
X-MS-Office365-Filtering-Correlation-Id: ab1e172c-1870-4196-d991-08dcff0719af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cW42aTk1QlJXOTVQTEZrbElrY1VnajJrMDZhRWFkUS93eWRSVDQvYVlxZ3Fv?=
 =?utf-8?B?bTZvWWhsOVo3cHVLSG4vYy81RFV6Q29ObHlEMUhOYkRPSnErdzk0VkFwVTNB?=
 =?utf-8?B?UjhIVW1DSlR0YllDcWlBTFBDV0xrTU56QVhjT0NXd3U0akhISEdtaTRxK2lR?=
 =?utf-8?B?VCsvTWNPRUJoMVRkanB2YjhUaU5iajJOaDBtTGFpelRXQ2NhUVRKeFkvZDdU?=
 =?utf-8?B?ejBsNWNwMlNPUVB6dkwyNjlidm5pcWt2eWxjQzlnTElOQ09iR3RmWTVQRTNo?=
 =?utf-8?B?N3duMmxmNTgxR2prb0NVVHU2OC8zVVUrSWU0UHNaQUJpK0JaU0hzMFRyUXBu?=
 =?utf-8?B?czNxcUhSL3A4SjlPd2x1d25mRDFRUlVMcjlqNnM4MDFQcEFTTldLV0Q4OUhV?=
 =?utf-8?B?SExRU0RZQjZwbjhQTDBMS2ZsZDgvcWdvTnA2SkplejlLY1YwRkZrdy9KdFdX?=
 =?utf-8?B?M0duTFZlSmQwMXFpa2p0dENFVlU4V1VqQVpUQVp1Y2g4M2JaU1dLMmZ0SWNt?=
 =?utf-8?B?K3hhYXRTUlpOKzdPSzBYKzRRRlRQWGgyV3RaVGtqRnJmei9mYjZCQjU4TE4z?=
 =?utf-8?B?ZVc0dTVKM0N4eEZERk40TWVKeG5uVDdCQlZWdmxOQUNTand2ZStIbmxPbHJk?=
 =?utf-8?B?NTBlWDZVMTA5c3YxTkNuRWI2UnRxVW14cDNwTXZNUm9WbVdCSXMrUzFrUkU0?=
 =?utf-8?B?UnF0a29LTVdhRERNNENBQy8xeURoTENBWDlMOXJtRTlGc01xeVZQVmNLRk9w?=
 =?utf-8?B?UDFYUnluVDAyemlJT1pMTWtRZGMwdFp2MWR1bE1meml3NG1HbXBjdmE0clhW?=
 =?utf-8?B?S3lObmdHbVptcXVSUUZlQXFuUjg1d2Zib1FKd1R0eWR6bzNlOHRLaThuakFi?=
 =?utf-8?B?YmJzd3krUEE3b08zdDdlTnU2ZVJZWVJFcEdISVpxUWVRMkxvMWE5bE9qRVFi?=
 =?utf-8?B?WFgxODVIeHIvRTRhb0JZbUp6T09Dcy91R3ZFWmY5N0lmejRMQWFVMGVzRXlP?=
 =?utf-8?B?dUxkMkFGVTZmYzBpY0ZXZmlaMStTSTI3NlYxWGRCMlRIOGZtS2RPWTJWcEVY?=
 =?utf-8?B?YVpaeXhpMTBGdFc2MW9NNUJFaXd3YUxoTGdOY2Nab29VNlYwWENKTUszMWwx?=
 =?utf-8?B?STFWUmtLYjRRek83OTQzbGNTQ2tXdHRnbFVKNzJwTjZzQ2NSdE14WkV1d2Yy?=
 =?utf-8?B?M2o1UldJTTFNQk45OHZLZk1hektjdVByWTdlTGtvNm1HR0dXVDJ5OGtaV2Fo?=
 =?utf-8?B?ZGFhcWFNU1ZaNWpqNVRVSDFtcnIvc2hFalVyWWtTYm9nZEVsZ1lIdnVCNnFs?=
 =?utf-8?B?dUM4bW54TldYMXVwL2ZDQWg0Y056eURrQ3V2UTZja055eWliRnkxK0NjQ2I3?=
 =?utf-8?B?WDFkdzZYbWkvQ1VxNXFqU0ZOQWt6emxjclFQYVpaeTBXMitlYmZLdHZOSkI3?=
 =?utf-8?B?c3dZOFhZbThDaE1ESkZrNUNDZk9WVmdOUjAxdTZ6eW5LcUtCVWFwMVo0WDJR?=
 =?utf-8?B?aHRyNy9Ba3N4MFBTMFpnWkJDSG1saEJ0TzFXeXkwREFhQXFQbkg5b3FCZTdD?=
 =?utf-8?B?VHBtaGZHdmpieHYxdFdseUpXMFJRTEgzSkd5YTNNZ3FFeC9HSGtjS3dRRDVi?=
 =?utf-8?B?dmtlOFZRSHUyN3VEWGhVS3pxcVNCaHkzbDBReUNLeFhXeEUvUElueGhEMDl6?=
 =?utf-8?B?NTdvNGkwRHh5K0Zpd1AxclhxZnZxRW85UGx2K2FvNjdETHNQQmIzaDVkRlNw?=
 =?utf-8?Q?DIUC9kYjh8bwU69Xbs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjR4VDkxS3N6RHVNc1c1Nk1CL0tkSVIxWWxSUHRhVjVHeS9Nd0ZrcDRSdytq?=
 =?utf-8?B?QUxtOVBZcnBKdThBSXgwS1JOS1RDSmFHYjBoY0pUSCtwZzlUWG5ubEN3ZWlE?=
 =?utf-8?B?RmR6WVRueExIenJKa1FqRVd3Y3FFYzdmU1ZHdFhnTEtTMmhUL1AvR000bDJP?=
 =?utf-8?B?a2FCVzVSZ0srTHNlM0YvUlhzdGhyekZ1V3AzczlESmh6bUVIV3NxaFJteG1Y?=
 =?utf-8?B?WThzZURPVXBTRWJEZDZtUTFVekpLWk8vbHZvbVdBaTJGTTBueVIrRVhjYlZp?=
 =?utf-8?B?TUtvM0dXYlBETjU2cGZuSWxwTEU3dWMvZy9WTlBkTkRmaTVxMnd4UG9hcGtw?=
 =?utf-8?B?TStwSEkwUTdDYzNobXJKcVAyUVZrOTFZT3VuQUpScnhwNG4yT0dGWnNOYzhj?=
 =?utf-8?B?aHdsZzRPbGlydlhOQUljV1ZSOWNQMVVGdi92RlNIaWw0c0NSM1NPWmlSZy9a?=
 =?utf-8?B?KzlXYm5iMTBpNVduUE00YnB4SWJrYit3UW1YNjZDbk83UEhrVUNHdnkzMXc4?=
 =?utf-8?B?a2d2QmJtQnRNRnRmVFpTTnJxK0cwdkxoMlgxRjREQktKcU50OVUycDZiclMr?=
 =?utf-8?B?UURIWjJBekk5ZSt4dnI2UGs2ZHVQcVRCd0E5amlMbHFTQ2dqZFF4Z2ovTTNr?=
 =?utf-8?B?VlJTU2dMQTR2TmNlNk5KSXVUdkh2eTRHbWpab1BMOHk5bjlSWG1jZmNoWFQ1?=
 =?utf-8?B?UjFUbHNCR1dvME56RGZoU3EvVyt3LzNTa3pPRmpKR3JrQmlvV2ljQVZGTXFP?=
 =?utf-8?B?TTd5Slh1c0FtQUpveGZIcy84QURSNjdBZ3ptbWl1djNtSDd5cW0rbTRvR1hV?=
 =?utf-8?B?YnVyNGF5MGM2WHpZZGNOTFRwSVE2Zlc4ZEJTbVNoaGl2VUpmSWMzUTJXaCs5?=
 =?utf-8?B?Mmw2UzVJVVJEU0JmR3E1UElvbGpwVndLYU02M2F1YmRWbm94UE5nbnloVWxl?=
 =?utf-8?B?ZDRTbVF2U08vc0Y4ay9DUWUrNlpYSlNzL0ExWWRoRGNtU3UwdzRxaUdtQVRt?=
 =?utf-8?B?SXBQYW1SN3hwQzZHNS9meFMyN2YxMWZwc1NYbEtBRjZuM3ErTFBsejJYcktj?=
 =?utf-8?B?MzcwNjZERjE3ZzhCZkpXTnJQaGhMNmltMHhYM2IzZHNjcWp4VjF6OHBqRVRY?=
 =?utf-8?B?WTNRSE9RVVc0cjhMSm1wMmRDUzQyK05mcTdWQjBrQkNFSkpVZXZJais4WkE0?=
 =?utf-8?B?cEFVRDdQVEQ0RENSQWNyUzFpTXFUNFNBM3R3b2w0TDlQUWNVcG83TDJsZmw0?=
 =?utf-8?B?SjNJY2MrMnNBMEVIYzlmWHJGY211R2ZldStMdS9jOS9lQ0F6SEVkWEg0NGJH?=
 =?utf-8?B?OHdodUJZc0J2VXhVNFJSZFRxL3RWSUxMeGZOc3BnVXIzdGZ6QXNwUkJxK05o?=
 =?utf-8?B?VThXWUs4YzE3VlN3TXF2bnBjak5hOGRjbWEwNjdhTE13RVdMdWo3eXp5T1BT?=
 =?utf-8?B?Um5sSGZXUWQ3Wk1UNFdtNjhVVlFDTWF3WjFuejlKVDM0NHBvc3hQbjJscHhZ?=
 =?utf-8?B?aVYyR1puY2orRFp1bERVL0pRbGp0Mko3czB4ZXBJaGF2Rmxubk85aWk1K2lY?=
 =?utf-8?B?Z0RoUGVTdU83MkVWV1FGbjhPcjBhNUd3a1BNUGJ2djBYREdoeE9qZkdQSWRO?=
 =?utf-8?B?YUlpWEs1OEpWRHBHMlJuZnd2S1NJNzlkUjlqNTNJSXVrZFBEVVVKQVR6Wm5a?=
 =?utf-8?B?UmxHZEYrVFlEajFVcXNwbm1jdXFubHluMkQwc0I4L1Z0djYyMUsxRlBwUERS?=
 =?utf-8?B?YnZlSEJaMWRqVGlzTXNUdHB4dXRjTWxxaWFLSFVrdkVJZ2ZZRTlqZklsZXQr?=
 =?utf-8?B?dksxR0xwTk1iNFR1NmJ1YzF4dG1EVENQWUVYNnQxUnBQUkt1OThIK0Vkakxr?=
 =?utf-8?B?QnQ3ekM2S3g2L01jbG02U2NRRU9wN1ViZ2RacWJVdHF6bWxmVXZqZVpzTE1D?=
 =?utf-8?B?dEExU3JkWGJsdThLc2F4eTBvV3ovUURmTmpDak90cE16NHRlUmkyLzdsRXIz?=
 =?utf-8?B?akxWSXplbFZoTUFFZ3pldGxqd1dmSlVESm9XMnd5MEt4blF0UEFYaU10R2Vk?=
 =?utf-8?B?ZlRxNHNkdnFqZDVVTFJ2M0FnbVFWeHhlWTVJR1luZzdlVThRYlZvZzhyNmc0?=
 =?utf-8?Q?ZDpOnBmEq+pze3GbEHYs+7yeq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ab1e172c-1870-4196-d991-08dcff0719af
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 08:35:14.1846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QHnFem6i3+LmFRY2zCBhTuaMDTcNIsI5ptSd8XfZ719fvGtjey7MrVVFKu58eFn+8ZUl9Yzgn9ZR394zupUYFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7357
X-OriginatorOrg: intel.com

On 2024/11/7 16:04, Baolu Lu wrote:
> On 2024/11/7 15:57, Yi Liu wrote:
>> On 2024/11/7 14:53, Baolu Lu wrote:
>>> On 2024/11/7 14:46, Yi Liu wrote:
>>>> On 2024/11/7 13:46, Tian, Kevin wrote:
>>>>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>>>>> Sent: Thursday, November 7, 2024 12:21 PM
>>>>>>
>>>>>> On 2024/11/7 10:52, Baolu Lu wrote:
>>>>>>> On 11/6/24 23:45, Yi Liu wrote:
>>>>>>>> +int intel_pasid_replace_first_level(struct intel_iommu *iommu,
>>>>>>>> +                    struct device *dev, pgd_t *pgd,
>>>>>>>> +                    u32 pasid, u16 did, u16 old_did,
>>>>>>>> +                    int flags)
>>>>>>>> +{
>>>>>>>> +    struct pasid_entry *pte;
>>>>>>>> +
>>>>>>>> +    if (!ecap_flts(iommu->ecap)) {
>>>>>>>> +        pr_err("No first level translation support on %s\n",
>>>>>>>> +               iommu->name);
>>>>>>>> +        return -EINVAL;
>>>>>>>> +    }
>>>>>>>> +
>>>>>>>> +    if ((flags & PASID_FLAG_FL5LP) && !cap_fl5lp_support(iommu- 
>>>>>>>> >cap)) {
>>>>>>>> +        pr_err("No 5-level paging support for first-level on %s\n",
>>>>>>>> +               iommu->name);
>>>>>>>> +        return -EINVAL;
>>>>>>>> +    }
>>>>>>>> +
>>>>>>>> +    spin_lock(&iommu->lock);
>>>>>>>> +    pte = intel_pasid_get_entry(dev, pasid);
>>>>>>>> +    if (!pte) {
>>>>>>>> +        spin_unlock(&iommu->lock);
>>>>>>>> +        return -ENODEV;
>>>>>>>> +    }
>>>>>>>> +
>>>>>>>> +    if (!pasid_pte_is_present(pte)) {
>>>>>>>> +        spin_unlock(&iommu->lock);
>>>>>>>> +        return -EINVAL;
>>>>>>>> +    }
>>>>>>>> +
>>>>>>>> +    WARN_ON(old_did != pasid_get_domain_id(pte));
>>>>>>>> +
>>>>>>>> +    pasid_pte_config_first_level(iommu, pte, pgd, did, flags);
>>>>>>>> +    spin_unlock(&iommu->lock);
>>>>>>>> +
>>>>>>>> +    intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
>>>>>>>> +    intel_iommu_drain_pasid_prq(dev, pasid);
>>>>>>>> +
>>>>>>>> +    return 0;
>>>>>>>> +}
>>>>>>>
>>>>>>> pasid_pte_config_first_level() causes the pasid entry to transition 
>>>>>>> from
>>>>>>> present to non-present and then to present. In this case, calling
>>>>>>> intel_pasid_flush_present() is not accurate, as it is only intended for
>>>>>>> pasid entries transitioning from present to present, according to the
>>>>>>> specification.
>>>>>>>
>>>>>>> It's recommended to move pasid_clear_entry(pte) and
>>>>>>> pasid_set_present(pte) out to the caller, so ...
>>>>>>>
>>>>>>> For setup case (pasid from non-present to present):
>>>>>>>
>>>>>>> - pasid_clear_entry(pte)
>>>>>>> - pasid_pte_config_first_level(pte)
>>>>>>> - pasid_set_present(pte)
>>>>>>> - cache invalidations
>>>>>>>
>>>>>>> For replace case (pasid from present to present)
>>>>>>>
>>>>>>> - pasid_pte_config_first_level(pte)
>>>>>>> - cache invalidations
>>>>>>>
>>>>>>> The same applies to other types of setup and replace.
>>>>>>
>>>>>> hmmm. Here is the reason I did it in the way of this patch:
>>>>>> 1) pasid_clear_entry() can clear all the fields that are not supposed to
>>>>>>      be used by the new domain. For example, converting a nested 
>>>>>> domain to
>>>>>> SS
>>>>>>      only domain, if no pasid_clear_entry() then the FSPTR would be 
>>>>>> there.
>>>>>>      Although spec seems not enforce it, it might be good to clear it.
>>>>>> 2) We don't support atomic replace yet, so the whole pasid entry 
>>>>>> transition
>>>>>>      is not done in one shot, so it looks to be ok to do this stepping
>>>>>>      transition.
>>>>>> 3) It seems to be even worse if keep the Present bit during the 
>>>>>> transition.
>>>>>>      The pasid entry might be broken while the Present bit indicates 
>>>>>> this is
>>>>>>      a valid pasid entry. Say if there is in-flight DMA, the result 
>>>>>> may be
>>>>>>      unpredictable.
>>>>>>
>>>>>> Based on the above, I chose the current way. But I admit if we are 
>>>>>> going to
>>>>>> support atomic replace, then we should refactor a bit. I believe at that
>>>>>> time we need to construct the new pasid entry first and try to 
>>>>>> exchange it
>>>>>> to the pasid table. I can see some transition can be done in that way 
>>>>>> as we
>>>>>> can do atomic exchange with 128bits. thoughts? 🙂
>>>>>>
>>>>>
>>>>> yes 128bit cmpxchg is necessary to support atomic replacement.
>>>>>
>>>>> Actually vt-d spec clearly says so e.g. SSPTPTR/DID must be updated
>>>>> together in a present entry to not break in-flight DMA.
>>>>>
>>>>> but... your current way (clear entry then update it) also break in- 
>>>>> flight
>>>>> DMA. So let's admit that as the 1st step it's not aimed to support
>>>>> atomic replacement. With that Baolu's suggestion makes more sense
>>>>> toward future extension with less refactoring required (otherwise
>>>>> you should not use intel_pasid_flush_present() then the earlier
>>>>> refactoring for that helper is also meaningless).
>>>>
>>>> I see. The pasid entry might have some filed that is not supposed to be
>>>> used after replacement. Should we have a comment about it?
>>>
>>> I guess all fields except SSADE and P of a pasid table entry should be
>>> cleared in pasid_pte_config_first_level()?
>>
>> perhaps we can take one more step forward. We can construct the new pte 
>> in a local variable first and then push it to the pte in the pasid table. :)
>>
> 
> That sounds better! The entry is composed on the stack and then copied
> over to the pasid table as a whole.

that's it. Like the below.

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 6841b9892d55..0f2a926d3bd5 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -389,6 +389,50 @@ int intel_pasid_setup_first_level(struct intel_iommu 
*iommu,
  	return 0;
  }

+int intel_pasid_replace_first_level(struct intel_iommu *iommu,
+				    struct device *dev, pgd_t *pgd,
+				    u32 pasid, u16 did, u16 old_did,
+				    int flags)
+{
+	struct pasid_entry *pte, new_pte;
+
+	if (!ecap_flts(iommu->ecap)) {
+		pr_err("No first level translation support on %s\n",
+		       iommu->name);
+		return -EINVAL;
+	}
+
+	if ((flags & PASID_FLAG_FL5LP) && !cap_fl5lp_support(iommu->cap)) {
+		pr_err("No 5-level paging support for first-level on %s\n",
+		       iommu->name);
+		return -EINVAL;
+	}
+
+	pasid_pte_config_first_level(iommu, &new_pte, pgd, did, flags);
+
+	spin_lock(&iommu->lock);
+	pte = intel_pasid_get_entry(dev, pasid);
+	if (!pte) {
+		spin_unlock(&iommu->lock);
+		return -ENODEV;
+	}
+
+	if (!pasid_pte_is_present(pte)) {
+		spin_unlock(&iommu->lock);
+		return -EINVAL;
+	}
+
+	WARN_ON(old_did != pasid_get_domain_id(pte));
+
+	*pte = new_pte;
+	spin_unlock(&iommu->lock);
+
+	intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
+	intel_iommu_drain_pasid_prq(dev, pasid);
+
+	return 0;
+}
+
  /*
   * Set up the scalable mode pasid entry for second only translation type.
   */
@@ -456,6 +500,57 @@ int intel_pasid_setup_second_level(struct intel_iommu 
*iommu,
  	return 0;
  }

+int intel_pasid_replace_second_level(struct intel_iommu *iommu,
+				     struct dmar_domain *domain,
+				     struct device *dev, u16 old_did,
+				     u32 pasid)
+{
+	struct pasid_entry *pte, new_pte;
+	struct dma_pte *pgd;
+	u64 pgd_val;
+	u16 did;
+
+	/*
+	 * If hardware advertises no support for second level
+	 * translation, return directly.
+	 */
+	if (!ecap_slts(iommu->ecap)) {
+		pr_err("No second level translation support on %s\n",
+		       iommu->name);
+		return -EINVAL;
+	}
+
+	pgd = domain->pgd;
+	pgd_val = virt_to_phys(pgd);
+	did = domain_id_iommu(domain, iommu);
+
+	pasid_pte_config_second_level(iommu, &new_pte, pgd_val,
+				      domain->agaw, did,
+				      domain->dirty_tracking);
+
+	spin_lock(&iommu->lock);
+	pte = intel_pasid_get_entry(dev, pasid);
+	if (!pte) {
+		spin_unlock(&iommu->lock);
+		return -ENODEV;
+	}
+
+	if (!pasid_pte_is_present(pte)) {
+		spin_unlock(&iommu->lock);
+		return -EINVAL;
+	}
+
+	WARN_ON(old_did != pasid_get_domain_id(pte));
+
+	*pte = new_pte;
+	spin_unlock(&iommu->lock);
+
+	intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
+	intel_iommu_drain_pasid_prq(dev, pasid);
+
+	return 0;
+}
+
  /*
   * Set up dirty tracking on a second only or nested translation type.
   */
@@ -568,6 +663,38 @@ int intel_pasid_setup_pass_through(struct intel_iommu 
*iommu,
  	return 0;
  }

+int intel_pasid_replace_pass_through(struct intel_iommu *iommu,
+				     struct device *dev, u16 old_did,
+				     u32 pasid)
+{
+	struct pasid_entry *pte, new_pte;
+	u16 did = FLPT_DEFAULT_DID;
+
+	pasid_pte_config_pass_through(iommu, &new_pte, did);
+
+	spin_lock(&iommu->lock);
+	pte = intel_pasid_get_entry(dev, pasid);
+	if (!pte) {
+		spin_unlock(&iommu->lock);
+		return -ENODEV;
+	}
+
+	if (!pasid_pte_is_present(pte)) {
+		spin_unlock(&iommu->lock);
+		return -EINVAL;
+	}
+
+	WARN_ON(old_did != pasid_get_domain_id(pte));
+
+	*pte = new_pte;
+	spin_unlock(&iommu->lock);
+
+	intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
+	intel_iommu_drain_pasid_prq(dev, pasid);
+
+	return 0;
+}
+
  /*
   * Set the page snoop control for a pasid entry which has been set up.
   */
@@ -698,6 +825,69 @@ int intel_pasid_setup_nested(struct intel_iommu 
*iommu, struct device *dev,
  	return 0;
  }

+int intel_pasid_replace_nested(struct intel_iommu *iommu,
+			       struct device *dev, u32 pasid,
+			       u16 old_did, struct dmar_domain *domain)
+{
+	struct iommu_hwpt_vtd_s1 *s1_cfg = &domain->s1_cfg;
+	struct dmar_domain *s2_domain = domain->s2_domain;
+	u16 did = domain_id_iommu(domain, iommu);
+	struct pasid_entry *pte, new_pte;
+
+	/* Address width should match the address width supported by hardware */
+	switch (s1_cfg->addr_width) {
+	case ADDR_WIDTH_4LEVEL:
+		break;
+	case ADDR_WIDTH_5LEVEL:
+		if (!cap_fl5lp_support(iommu->cap)) {
+			dev_err_ratelimited(dev,
+					    "5-level paging not supported\n");
+			return -EINVAL;
+		}
+		break;
+	default:
+		dev_err_ratelimited(dev, "Invalid stage-1 address width %d\n",
+				    s1_cfg->addr_width);
+		return -EINVAL;
+	}
+
+	if ((s1_cfg->flags & IOMMU_VTD_S1_SRE) && !ecap_srs(iommu->ecap)) {
+		pr_err_ratelimited("No supervisor request support on %s\n",
+				   iommu->name);
+		return -EINVAL;
+	}
+
+	if ((s1_cfg->flags & IOMMU_VTD_S1_EAFE) && !ecap_eafs(iommu->ecap)) {
+		pr_err_ratelimited("No extended access flag support on %s\n",
+				   iommu->name);
+		return -EINVAL;
+	}
+
+	pasid_pte_config_nestd(iommu, &new_pte, s1_cfg, s2_domain, did);
+
+	spin_lock(&iommu->lock);
+	pte = intel_pasid_get_entry(dev, pasid);
+	if (!pte) {
+		spin_unlock(&iommu->lock);
+		return -ENODEV;
+	}
+
+	if (!pasid_pte_is_present(pte)) {
+		spin_unlock(&iommu->lock);
+		return -EINVAL;
+	}
+
+	WARN_ON(old_did != pasid_get_domain_id(pte));
+
+	*pte = new_pte;
+	spin_unlock(&iommu->lock);
+
+	intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
+	intel_iommu_drain_pasid_prq(dev, pasid);
+
+	return 0;
+}
+
  /*
   * Interfaces to setup or teardown a pasid table to the scalable-mode
   * context table entry:
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index dde6d3ba5ae0..082f4fe20216 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -303,6 +296,21 @@ int intel_pasid_setup_pass_through(struct intel_iommu 
*iommu,
  				   struct device *dev, u32 pasid);
  int intel_pasid_setup_nested(struct intel_iommu *iommu, struct device *dev,
  			     u32 pasid, struct dmar_domain *domain);
+int intel_pasid_replace_first_level(struct intel_iommu *iommu,
+				    struct device *dev, pgd_t *pgd,
+				    u32 pasid, u16 did, u16 old_did,
+				    int flags);
+int intel_pasid_replace_second_level(struct intel_iommu *iommu,
+				     struct dmar_domain *domain,
+				     struct device *dev, u16 old_did,
+				     u32 pasid);
+int intel_pasid_replace_pass_through(struct intel_iommu *iommu,
+				     struct device *dev, u16 old_did,
+				     u32 pasid);
+int intel_pasid_replace_nested(struct intel_iommu *iommu,
+			       struct device *dev, u32 pasid,
+			       u16 old_did, struct dmar_domain *domain);
+
  void intel_pasid_tear_down_entry(struct intel_iommu *iommu,
  				 struct device *dev, u32 pasid,
  				 bool fault_ignore);

> With these two issues addressed, do u mind sending a new version? Let's
> try to catch the pull request window. There are other series (iommufd
> and vfio) about user space PASID support depending on this.

yes, for sure.

-- 
Regards,
Yi Liu

