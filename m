Return-Path: <kvm+bounces-30701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9595B9BC7AC
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 09:08:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27D091F22D40
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 08:08:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED3261FF023;
	Tue,  5 Nov 2024 08:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h/RUiJ2V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E611C57B2
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 08:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730794088; cv=fail; b=ECAQw0rQKajnYbpHvXbUWguNA/RaNcWLCxwsojlwrWyYQwr0GUY1JSfZgOBqr2E3F8iqXUvoFhM8iDpfd26MLHWoRKnzR/uvpfHsQeTGbIUtnqgov5r9Z/T0PhCDTnVgLj3bwbxG1eRTuhHBas3/MyDDvDwnZntKm8Hz75fNFgo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730794088; c=relaxed/simple;
	bh=chl8eAmcYrMihCy1cRJVYhIIEk8YP9C2+QtRvoQWqlE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SRZlmYiv94LjAbcg5pISI6S51oD5tL5XzfZF5U0pN2EPNiJ+0xzn5Lqq8dcr+LfM9RCZVxikUheBX+76jNaorOg+c7j1jKeiApomwmNOqyaIQ+yXNtVMnmruuQWly9CuTMzSNbHT/l4FFjRxItd0hcffX55gmSVdORH89616Tmw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h/RUiJ2V; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730794087; x=1762330087;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=chl8eAmcYrMihCy1cRJVYhIIEk8YP9C2+QtRvoQWqlE=;
  b=h/RUiJ2VhNF0tTHB91UXa1bUrY4f804F6I+ZVq0VVxqa9N3f4gdMxfms
   nO/0L4PtJlw2OArUq1yu7PgIMs0pNmIV+ULo00B6a2aWDtyIz5NwMgdLV
   6M9PPwWmMnWRy1rgd3xDE1yGm59Uc3gzPwmiOVTmAJvlDJGppb3bjtURl
   z0d9IL9CrY+sWzgjil2wwA3O2VEvBCatthS4eOBskF2BHQ8Hi7eUJy2Gc
   WB15aBNle7mvFgLXROMQRZsCPBcgOF1lmB0RpToVQ3Rjqee3gYgHeSWnU
   tGlH3DKzhxaBpXCJRdXML9G7j1QPA9+yLdFJoVCz6+VBVKCtJ9F165WJH
   g==;
X-CSE-ConnectionGUID: MBwfauQ0T5C7MdMh6wrABw==
X-CSE-MsgGUID: +ig92Jm/TUSm+LhXdBZdjQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="18144531"
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="18144531"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 00:08:06 -0800
X-CSE-ConnectionGUID: iG04hpF/Tcy3sBZNiqrroA==
X-CSE-MsgGUID: GSz0ZQFTQieKze6yPzLdiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83808803"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Nov 2024 00:08:06 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 5 Nov 2024 00:08:04 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 5 Nov 2024 00:08:04 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 00:08:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j9v8ShqbMmEP0G4setEsSkSnNDQc3wdSTDjHCk81IOcFxmjDARmXJhMTjkFx5B/qRn/qHBEwl+UyC/7Db8+udVKSIif4Y5t44ZM48mcB85drOwOcjwtkg6Fu3jO2Nw9i6peIy+yACIs8C1KGOlW+UZCtxX6cXNHxS5cFBeeNih2ELH8M4TT57r+AGzpsxAmCmp2BrpK6UkOo20ZzrrOVFRhxst7UkkyhtP/P2BHOqQovQKyLvsFNeMdjlnTDLi4/lq/G1DFpDSKmf/YTNi6hLL4BKBOVsE3kHprXRUjoRlpJGFHADfAIDSalna5yyfpClJLzdN9eOOYIwa/mzaMBQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=px1s9TQBDjsNmV/eAR9ZuiIyrzicP0gPoV9cRREENmg=;
 b=swEVHkJ+D2BN9Sd0tLSmpZR01WSoj1cki60kXjQChBY+38hIcBLL9jPGnMdjV4NOyxdqxmIrQQX4CywP50WBHdIpvMvUyJpC7HcSI4trl7PeFVpQIBmnX/HZSbtTxMHUDLL09VFjcCltltOLcc4RLuk3mMvmaXKffEvF/saYp05ZqgRrlxBCpDYbmI8vATQBmtnnTr9dAdXunnAmolnBIpMG7z33H7hs2bku/9e0f0L598v/fAyiRqDVA5cARWmcTaCzQlbgHcUu7SEDGV8lcCK3GjhyYtutHnxkJB6849SkBFJ/lv3/zeRV/5RgwlzyyxHrJ+cGnkl8tREsel9P4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by SN7PR11MB7491.namprd11.prod.outlook.com (2603:10b6:806:349::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 08:08:02 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::399f:ff7c:adb2:8d29]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::399f:ff7c:adb2:8d29%3]) with mapi id 15.20.8114.028; Tue, 5 Nov 2024
 08:08:02 +0000
Message-ID: <f423e9ff-c9ca-4de8-a2ac-3125d4f203ed@intel.com>
Date: Tue, 5 Nov 2024 16:12:39 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/12] iommufd: Refactor __fault_domain_replace_dev()
 to be a wrapper of iommu_replace_group_handle()
To: Baolu Lu <baolu.lu@linux.intel.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>
CC: <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241104132513.15890-3-yi.l.liu@intel.com>
 <7c0367f7-634c-485f-8c87-879ddfa2d29d@linux.intel.com>
 <a7cf853d-be52-4a61-8e0b-3638d0559853@intel.com>
 <9ddc9d2f-b894-4c6b-ab34-4a3fbde9d18f@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <9ddc9d2f-b894-4c6b-ab34-4a3fbde9d18f@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR03CA0119.apcprd03.prod.outlook.com
 (2603:1096:4:91::23) To SN7PR11MB7540.namprd11.prod.outlook.com
 (2603:10b6:806:340::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7540:EE_|SN7PR11MB7491:EE_
X-MS-Office365-Filtering-Correlation-Id: 54eba9f9-99b4-4554-4548-08dcfd70f80f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?d0Y0L0U5MkZFajJ3bDRMMFlnYXVyYWUvMnp4QXFCS2JRUWczcGR3WG0rcWtt?=
 =?utf-8?B?Qlk5U01ZZ255MWRzeFNBMGJ2a1hObzRzN0dCbFI0QWJLdFBFdDFjVndVamZM?=
 =?utf-8?B?ZE5GdGFYeWhkTHkrV0tlZ3dvUmxMMmNYSEh2Tm92WFNGWCtRSWtVM013bzRI?=
 =?utf-8?B?V1cvRS8zMUplMzI3b1daL3d5cE1QNGdDZFJOajZCVUxyRVQvSXF6RElxSWtP?=
 =?utf-8?B?S25JaDVOSW5mQkFoVGRxMStJZFNMYjU3b2pDV1NJczIzQm1qWitaakxHSEow?=
 =?utf-8?B?OS8zNnF2VEwySWxhcStraldvZkJVTVBiMFdvempUR2tSSDM4blZQU1MvMXBF?=
 =?utf-8?B?LzdFNG1kMWdYR1gzdTcxYUhlYmRaYi9nMzlEbHZDaktka1UwTjdIYmZ5YUdQ?=
 =?utf-8?B?cGZCNVF5SGdGczNyZEZEZTdHSHdpVUVXTzZhaWZPRDVFMEtBSzVNRThNRTZl?=
 =?utf-8?B?ZklCbklSM2ZsR1dPNFMwcHZyWko3UHMxRjJjbDhQd2Nyb0VtSlJIcGRkaklB?=
 =?utf-8?B?QVJIRFEvZ2NXdkFvdTJYMXFVUE9Gc2EwRGJDd05uM3VvRTNIaFZibTZ4ZXJJ?=
 =?utf-8?B?QWluWGpCaEF1aitITFFybDQvWGJweDlyRWpjdHRCajF6ZStkalRXZnhNZmxN?=
 =?utf-8?B?cWZpTVFhUXh1ZHY3dVM5WGZnQStzNXNPaFZTRHorRUg3ODhNaXlzVTRmQmZO?=
 =?utf-8?B?U1hCS1JqV3pQaXFxOTlocWhGcHZFU0NKQTFUNHUvL0VPV0k1ZDZsbS85eVdj?=
 =?utf-8?B?R1NydjBNQTRDNC91YzRwT2hpVm94dCtHRVBOOEJYZlVRM1grdDQ1cjlEQk1T?=
 =?utf-8?B?K1RLY0FMdDM5NGtDYW41TkdSZnRjQ244TjVvdUJOL2hrL3Q0b3F2UGUzK1o3?=
 =?utf-8?B?Y2lLRmJJZTI3YlAvdEdtYjMxWWR2YmRZdjhadFZ1ZWFid2ora0hUTlNXUWE4?=
 =?utf-8?B?TnNQYVNSM3ZuWjVZMllyUTZnWXd4Yk8xUU9xYlN5Z0I3bVFUWXdVb1cyRU9h?=
 =?utf-8?B?RllEeHRvYmc4WVdUTEJaVDdSTlNZeW10aGxkbjByc0JVdVNnQ2l3L2tXczNG?=
 =?utf-8?B?QVc1aVpndDZ0RjlKOGV2WHJvaU1pbmdCY29la3NXaFpneW9EV1ZsWEFleHlP?=
 =?utf-8?B?enhzckxyNFIrclFmLzZ3aGRpRW1TU1RvQlJRcENIOWxsQTZnOGVZMW5mU2hS?=
 =?utf-8?B?OUhwMTZQRmZtNDhqSUtGUVc5VWVzL01CYkRBRjdSL3ZIQ2ZnbkUwQmZjNS9m?=
 =?utf-8?B?SUZNb1kxVGs3VGFpQ0QwMnV3STZKSjVwNndQeTZuZ1hVREt3NkZRZVlLSG9J?=
 =?utf-8?B?eWVrOUVqZnNLVHVJS1BzZk1jcFh2cGVUaEN2YkIxdm8yaDBaOHQ2NUx0SCtC?=
 =?utf-8?B?aDlYWkI3OWh4cUFzTXA3QXNOYWZLbGVGN2dlYXBjQWtQZFFpdTV5UTJsRUpn?=
 =?utf-8?B?TFMrcnRMRUJGUE56SWZRc3BEcUJ2Q2xtWGxmbjBMRWVsWklLbkhtUU9kSnRh?=
 =?utf-8?B?cEJic3lTMGVrWlJ6azlWVGRaTlRFN2U1TkZvbWlMaHZCaENCNXUxTFQzQjJy?=
 =?utf-8?B?WDhrMkRQc3I5RGp5YmpyYjZWUkNCV21QdFlsMGh2UktRL0V2MFZIZmdwUkVC?=
 =?utf-8?B?TlZEYStlL3RXN1JJSjh0SFM4TFZIejJFRU5BMmFuaEZ4TUVwQlRTYy9rVkZE?=
 =?utf-8?B?dmJJUDhPQUNtM1lEY0VvWUoyU3FrdXJQRjZVWHdmK01RL2J2WGtMZW5jekYw?=
 =?utf-8?Q?mh/GYaSEKDBu2CWpQc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ejhYR09Ed2R2RlpWOUl2TU5OTGNCUVo3OE5CTnlRYVNDSkY3anJPdkFneWFI?=
 =?utf-8?B?MS9SbWtYTXc0THkzZXZOLzBOb3hsWXU3YXplNmNGTHljRVIrQ2RYWkFOVFcy?=
 =?utf-8?B?TkFXVmRQa2VoVXR3V01mUlhYbnEybk1qOXFtK0FlSDZsYkVjbDVqTTQxUDJw?=
 =?utf-8?B?NnlnN1dmdlFMb0RtZm9xSjlKMHM0MkxBdHcrb0xVVjZkOEdaUEZOeFlmUlJI?=
 =?utf-8?B?d0NwZHUrSWtPdzhNTVVraVl2WHRNekJJNTJiTDREY1QwT0NCTi9aeDNzc1VY?=
 =?utf-8?B?RTFHV3htdk03bEt5TndQUGMvbnBwQ1BzcExqU2JNVXEwZmJydjdVVXhLUUhQ?=
 =?utf-8?B?bWhMbGwzVWZ1T3BVZEJXbXZCMVdVdmsrVkY4TjltRWh0bTdKM2loOUFhQmQz?=
 =?utf-8?B?RlJMbTJJZ2J5MS81WnFBZG9jdVhtTHhQejhyWGFBYWE4MDZJVzNNYnNDK1F0?=
 =?utf-8?B?dzEya1gvVVU1QlloQkpXNFB5azRWcmluaEhFQmFadDhxT3paSDY3MzRLZ2o1?=
 =?utf-8?B?c1pwYnBGYkNFRVJpTGEvb0w1TUFFT0VQbGp5ZlhMakpaekJiaVJoT2wrQkl5?=
 =?utf-8?B?Yk1PSkRJUG5wRVVYeWdHcWtLUG80Y2NoeEhuZTU1c1ZDck9KamxLeGlmM3lQ?=
 =?utf-8?B?WXl6eXFiMEgvNnRDWTR1RWw3cXVVOU1scFhzODZjWFZ1d3ZOU0RUclhYWlJF?=
 =?utf-8?B?ODQwOFNSTzQraklvVk5JMnBsTXRMSlI2Nmo5OWRoblo3YmgzUGYyUVZ4dHFW?=
 =?utf-8?B?TlZZZG1OTC9UdDV6U01pbkMzRzQ5dXJCL1A4QmhCd1dza3R4ZlcvRjIvWGZE?=
 =?utf-8?B?T3RNOWNqcWU0am8xUTllb29pbXpQWXZzUDRkTlNkbm5Xak5kdExPZXJNTDEr?=
 =?utf-8?B?NlQvTW1HbzJmb0xsK1pwbVBJckJTb2x2ZStZUjVoeXlIZW1BSEpvOUloQ2NM?=
 =?utf-8?B?cm1MamZ6TG90cnJHSTdVV05wM0kyT2hTcWJLMGpMUmN4TmIrMDJldDl1UDFG?=
 =?utf-8?B?bFlqM2lHTmlRQ2RXS3ZleXRLRjlMVkF6N0FKQ3Vrdjd0V0dzcXhWUGttM3BZ?=
 =?utf-8?B?UWVwUGRXUEJJU0tXMytCR2dTeXVtSGQ1ZzNjWWlYVXdXN0hLTTZ4MFB5cnpl?=
 =?utf-8?B?dThZazhvSXR4bE4xbkRvK0oxNWZ6SDl2RnVRd3k5WE9KY1Byeml6VkNDSEpY?=
 =?utf-8?B?b1NXc1VwRkFOVG1xakhleXdUT2daRUtmMFRpclNTbWcxaVUzdG16NUdnVDhM?=
 =?utf-8?B?VVlBeUsxaDdRTkUrcCtWVUVkcHMrbmw3d1pRaDNRQ00yd2xUazFqTnY2cXZB?=
 =?utf-8?B?QWtRc1grZnFhckZpKzFYalNyMVZxNWxUSTlQeVhCOUQvSHF4VkJUODdaSXNz?=
 =?utf-8?B?cHVqa1c5Y0pVQUhOekZvTDl4V2NPMFJYYmw2NW9TMjI2R0ZJR1hpcUFVTGtN?=
 =?utf-8?B?bE9oUXdueHIxSVpKbDIyWXhnOWpnK2NJZGUwL1hTWFRmVzNEdXJoeXNPT3ow?=
 =?utf-8?B?RDk3bHM4TmpJbmRROFVsRDZKdVF5NE1nV1R6WDJMM3g3bldQa244WDNXSnFP?=
 =?utf-8?B?Q295Y3V1SnFaaFQ0NTVuZUNCcGNmQTNkZzhtaUFlUGFCaCtWVGtmU2tYd2tr?=
 =?utf-8?B?TTZxNFRwM2ZENmlqV2c0Z1BOZ3FqK0pMcE45WUN3T2trWVdpYk0wYkdQN0dl?=
 =?utf-8?B?YUtuRzdkOTVreFFuKzZmVDM3ZStDQzJ5aGJmV0o5NzRSZVFnaytQN3ZjUmhI?=
 =?utf-8?B?NllzRHU3bFpERC9oMjNCb3VidEdwMlhMNTFjdGk0KzBHMWZ3YllGSjcwTE4x?=
 =?utf-8?B?R2t0RnJHTEl2elhSS1JUY1NnSEttTDBnTVl0b3JRdW5EN1VGR0NPQUNFOTBV?=
 =?utf-8?B?N1BKZFNxT3RwVC9wVGp1U0hrOGlCeTlPU2gxQzQ5Mm9GcDV6U2VSN0RtNVlV?=
 =?utf-8?B?aXVTQ3B4WWVMdHo4UWZJdVM1OXY4K2gvaWk2L1JOdUpMVDZMQWk0aXAxUmd4?=
 =?utf-8?B?V05DbmhSTUVrUUxMY25ZR3BjM0dNVUVMQVBIaHQzTlhtSDhSbFpoRVNwNlFC?=
 =?utf-8?B?S3FlWGFqU3FFWE1Dc01yV01qaVYrVUIvM3MvTFQxZWIzem5RRFgwTWM3QXNr?=
 =?utf-8?Q?N14W408ET7DqrlBDNiPXArGUP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 54eba9f9-99b4-4554-4548-08dcfd70f80f
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 08:08:02.2570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kmcxHqEcIVvVx7no9CoeIHpCm2trtPyLyLIWDWinAg7iEK/ndG4nae3MkhDySbovlpFG7LVfRxRWn772FUUOxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7491
X-OriginatorOrg: intel.com

On 2024/11/5 16:03, Baolu Lu wrote:
> On 2024/11/5 16:01, Yi Liu wrote:
>> On 2024/11/5 13:06, Baolu Lu wrote:
>>> On 11/4/24 21:25, Yi Liu wrote:
>>>> There is a wrapper of iommu_attach_group_handle(), so making a wrapper for
>>>> iommu_replace_group_handle() for further code refactor. No functional 
>>>> change
>>>> intended.
>>>
>>> This patch is not a simple, non-functional refactoring. It allocates
>>> attach_handle for all devices in domain attach/replace interfaces,
>>> regardless of whether the domain is iopf-capable. Therefore, the commit
>>> message should be rephrased to accurately reflect the patch's purpose
>>> and rationale.
>>
>> This patch splits the __fault_domain_replace_dev() a lot, the else branch 
>> of the below code was lifted to the iommufd_fault_domain_replace_dev().
>> While the new __fault_domain_replace_dev() will only be called when the
>> hwpt->fault is valid. So the iommu_attach_handle is still allocated only
>> for the iopf-capable path. When the hwpt->fault is invalid, the
>> iommufd_fault_domain_replace_dev() calls iommu_replace_group_handle() with
>> a null iommu_attach_handle. What you described is done in the patch 04 of
>> this series. 🙂
>>
>> -    if (hwpt->fault) {
>> -        handle = kzalloc(sizeof(*handle), GFP_KERNEL);
>> -        if (!handle)
>> -            return -ENOMEM;
>> -
>> -        handle->idev = idev;
>> -        ret = iommu_replace_group_handle(idev->igroup->group,
>> -                         hwpt->domain, &handle->handle);
>> -    } else {
>> -        ret = iommu_replace_group_handle(idev->igroup->group,
>> -                         hwpt->domain, NULL);
>> -    }
> 
> Okay, I overlooked that part.
> 
> Below change caused me to think that attach handle is always allocated
> in this patch no matter ...

aha, because the caller of this chunk would check hwpt->fault first.

> 
> -    if (hwpt->fault) {
> -        handle = kzalloc(sizeof(*handle), GFP_KERNEL);
> -        if (!handle)
> -            return -ENOMEM;
> -
> -        handle->idev = idev;
> -        ret = iommu_replace_group_handle(idev->igroup->group,
> -                         hwpt->domain, &handle->handle);
> -    } else {
> -        ret = iommu_replace_group_handle(idev->igroup->group,
> -                         hwpt->domain, NULL);
> -    }
> +    handle = kzalloc(sizeof(*handle), GFP_KERNEL);
> +    if (!handle)
> +        return -ENOMEM;
> 
> If no functional change, please just ignore this comment.

yep, no functional change is intended in this patch. But do let me know if
you find one. :)

-- 
Regards,
Yi Liu

