Return-Path: <kvm+bounces-14751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 86E518A672B
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 11:33:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F1E5282346
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 09:32:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF05885942;
	Tue, 16 Apr 2024 09:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dEzjjMbR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6410284E0A
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 09:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713259971; cv=fail; b=GkQjNnNt+wCzSXSRvA3vVAcP7n7fKdF2dhD9a+Lty5XSiSRCOmo0ta3fYH6o7QitNv7JCpaNkUKEvGgB3G4t1bPZ7yuZrvIXX8PnDPSeyOFUuEfVU1qiImVXpxkDJF0rNFM6LcTThkrrxwEa/Mk50CQr17f6+6dWy8ZQD2DL8oo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713259971; c=relaxed/simple;
	bh=tQyVGzYBzKjwth0WP5GMoASaYtt/D/X0UYBO1WlWzgg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fIiwfmOqakC2mX5kfUyUhOCVeBo7KJG/1iT0TufBMpsv+F25RFzUwzl0x5heVEV0FdBTIDIeB74SXkD9pdynFUFPZ/XNE8pkuyEdKby4szVaX0yfmv1fbrcXTYU7876aOifnUOBa3u6E9onuwa3nFPDmQwnPNdgDhyEAulNQLNw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dEzjjMbR; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713259971; x=1744795971;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tQyVGzYBzKjwth0WP5GMoASaYtt/D/X0UYBO1WlWzgg=;
  b=dEzjjMbRLu84hx0KZre3utjrAcXtR04y4+xqHG71NILiRjMS/cN+vkmC
   RThvPEo9Kq8yn5e/eU5tXtUwMsOGCR7HV9vjeBnVs4OKImEQBZJ7AuufK
   f2dtFGG+KPZw0hBMRy13PRd23ZQuyP6fAUBCsBaJlH+UresTVn5MI6zQt
   ND1fKDirgv6akz5Gjbgh3BaE81LSnGZHPeim5faeL5aL5hUohy+ECy72d
   Wydo02R1x2s2l2qKSj5OuJnW2Id/2I6dYH1rRuTJ+8UYmiqeN/T6euW2I
   kpk6FygVrG2VeoomEdD6W4qWVpKgKFs28dHQf8csoulL2VNWiujaQUI2o
   g==;
X-CSE-ConnectionGUID: yt9LuArbRgWw4ecK2TAMMg==
X-CSE-MsgGUID: Hao6eCocTt2ddshzVDwquw==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="12529464"
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="12529464"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 02:32:50 -0700
X-CSE-ConnectionGUID: XK1aQUQRSfWE9oBAB1mp/A==
X-CSE-MsgGUID: vodlXywLTaSuLD7+joDlDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="22277196"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 02:32:49 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 02:32:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 02:32:48 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 02:32:48 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 02:32:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gH3VwYS1wQKKo8myKqXuhdr5jOb7t2paOuLRky6PrDiTGaDIW86nl2cyEd+EUXruxzzQgYcJuURqWBuq5VmAO2RkTlZ3A/IGT7+1I3gvsKzRIPqggO4nnSmQreXTub7qMWJjBLnwo3gorufp6Woi7pohzCFXDiaaYKsGpXSLmsgRNB2/kiS7wo0Wp2xBo0/ac9ozpHuUubp8dWGlTOKzrcFEC8PvsFdoBqHlAnMi0geTrxKMgS3wiDPh0n3ybRWL8STQzCguv2KzGZ1d0Lh+zAZofSjmKsdoB1UUvcQt/PAit8ISTNx9cw9e0nDDrLPU5hTCcCBJklTpbnb5nbpaqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vh+L8IjuSSXeYfXMVqEJSlNAhOjtLdKxFrlMhSMQF1w=;
 b=AmxUukCGCmokfWYye8dLpPGiA6Q9DHi/Z2zXXbc0ZoBakEUr4ddT4iVoy0VM+opLbhXTkaHuJObqTCXRNVFyWYTej5Rl4Ubkz2hLkm84zNlsK1EijPvkAySRQdilkTB/BucsFH9pkIEBDI9DhDFgJkJ/0RD16QvzVCVtINq1zVCKEK+1cdEV+EF8AEHNfYjwW2/REOEm8fFOwXrUKmf5mzEIXedHnhTJOxoKNlR/bS/kOoJKD550UyJLKFErJtnEbePmC7pmzBygd8DsiBW50F3zuvuGyRkwwn5qcudYHb1WdLLwH27gGTNffdeoBOYzzyPSuyQiASyiyAgY0aOh5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB7064.namprd11.prod.outlook.com (2603:10b6:806:2b7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.31; Tue, 16 Apr
 2024 09:32:45 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%6]) with mapi id 15.20.7452.046; Tue, 16 Apr 2024
 09:32:45 +0000
Message-ID: <b9ecc19b-2d76-4f87-9ee7-b8ef728ad58f@intel.com>
Date: Tue, 16 Apr 2024 17:36:17 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] vfio: Add VFIO_DEVICE_PASID_[AT|DE]TACH_IOMMUFD_PT
Content-Language: en-US
To: "Tian, Kevin" <kevin.tian@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <20240412082121.33382-4-yi.l.liu@intel.com>
 <BN9PR11MB5276FF829C765ADB8B8F8ED68C082@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276FF829C765ADB8B8F8ED68C082@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0036.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::20) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SA1PR11MB7064:EE_
X-MS-Office365-Filtering-Correlation-Id: fdbb7006-c403-4ef1-26aa-08dc5df82c2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +jh1aUm3jszjYqlGlMVDBIoFnhXnX2lRqsqTXoIGVJO8KppaYRtptcFzhzzOvbt6k5qQGxlat+nUxYXzYbKQSLqS7oTWWXzbZ+agw6KWVadsHmYeuVR8F5v/mh7kKVyXHkS0Uj5uXh+G4/qZ+AkOgcCUo6iQlTEDLWXG1FLKkMGhO6JaH5UaRaLrBzU3dn/CfMUbw5X2tiwPDxkbLufToZrwtPWfafSTU0byPcgkQWf8DejLeBL10eDGcSs+r5xCSIs7pRddWd9yHqmP9wAGHsyBK3s6qIA0N51DwM183agCOX5OgVyE2EjpGLOgHfqDT2nCoH3u7cnTGVGgsN4TontbHaRgapVak9qYkqQN/2Yey3PEBG1QS3365GRkJqGmKXjHxrwAMLTfRfsNk4kQEWvp5UsYDmGEe+2CMc+mbfba/rJE/++cC9DyY3qBhr7V2OQZRbE0jV58s9TtLGNHvXHnCqL4D0BOTef+W1jWn0VkAVqN8Wjr6QJfOjEaej+i9Z2o1zVh6L8WcK3Xaa7nnQ45+NOYZtD6mhLpA/9+wEWLKAe+Xrqwt/mWIL+R/KMV/KukV9TjVvZwO8F5Ct+cXaxyMySiViv1ShUYI/gw2UvxNkqBenkCE5cQqZc/QjoX/m8KEdzX7X8l/NUJKyioPaN8BPFZyd1x7sd5eNyfJHw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TG9ERkJsTkpLZXJHRG9lL0hGUHE2ZWpNSkNwZmVTYTMwdFRtQ05pMVg1NVh3?=
 =?utf-8?B?b0JMSWR2M2tuTzlQRGVHZzdhTzU0L1p6aG9ROTNFRUhrcHM1UWFRcnh5d2c3?=
 =?utf-8?B?dkc2WmllS2RycjdiaHVQWGNXM21VYUp2WGt3VTluUHlUWW1MZ0I4aHNNd2ND?=
 =?utf-8?B?Vkh1bXZveUptVWdEZWxGL2RCbUhZdVZ1VnZnd0tjemgxMlRuamlOaGtIRzhn?=
 =?utf-8?B?bGxmY3FaNVVJTlBpZ0JNY0U0anF5aDZIN3hrTzY3N1Viamk3bG9yNlBLMkFK?=
 =?utf-8?B?VERPT1VJNkwycDJaaTI4QzRRdzMxWjlJUDRGOWJiaHlsUTMyS1h1bWZySGpS?=
 =?utf-8?B?b1d1SDFtbFhxRXN6aTdNdjRnT2k3VS96aVZQYmlHRUo1cHRJMThTRWV2STNE?=
 =?utf-8?B?NGlrZkRvaWtNMmtXbjFlc3N3NExmcU5Nai9uRzF4clBJMU4rdXhSMFIxZlMv?=
 =?utf-8?B?MGVENUtMcjU1cFpQV2JsN1lKS2cwalE0TXZxS2Vzb21TSTNpK2czaFB5Qk00?=
 =?utf-8?B?MTRmK3IyTnZJM0R1R3llS0pFWjlxV3huazU1TDloK1BTK2JIa0J5MTd2SVBV?=
 =?utf-8?B?K3FWUDNySmZMell5UkQyTTZtSWN5MyszdjFFaTYxMGtsMGVuclhBNUhQYURD?=
 =?utf-8?B?U0xxdk1SRW9kck56a0s4elRSbjE3L05TYlI4ck02djd0Nk9IbWZQdzJYYzlO?=
 =?utf-8?B?UXp4a2hDcVp4Qk9Xb09PMUpUZ2UxSC9KMjNaMXRlZWR5STNrbFVZRTF5NG1n?=
 =?utf-8?B?RS9VWDc1OStFQllZTkxhVFREQ3FzSlBDYUloanhDREo4ekdRbFZlOS8yUXZN?=
 =?utf-8?B?VmZmbGJPV1k0NWtEQld3NDc3V3Q5MW5UQUxiMDdGQVRKaWQvUnM0MGJBeEpa?=
 =?utf-8?B?ODVhaW01ZTVxUk9jQWI5dUlwaVduMXorWkZ5SUtaT3pjN211K1BrNGt0NEZk?=
 =?utf-8?B?OERaZ2drcWFDbndrVDJRa3ZWdVp4UVJCYnM3V1VOWGFUZmw5SFlONDErOU1n?=
 =?utf-8?B?UWJ4M2llVWZkRFFFZEh5MVlpbCszcS90MFpIRWhUTk84SW5RNFRkY0VTalUv?=
 =?utf-8?B?T0ZrdUxpQUZYdzNxTzJaQW9yVlljclgrQTNHMjJzUXpybzhqQjF1SGVZN1Nr?=
 =?utf-8?B?VitlZTI2aVFyVlRIL0RwS0orUUh4Z2pvaUxNZ1RiRHhPWWFGbGl3YlBYRmFv?=
 =?utf-8?B?VklDSE5Da1RpM1orb05ydms4WU1IaDIzdDVKejhBSDQ0dlBPMUM0Z3BKMEVW?=
 =?utf-8?B?V3FnQXkyeXdpNzgwa2IxUGt1OE9hcldoM0dTank0SXZ1UmRTY3M3Y0kwcDA0?=
 =?utf-8?B?cFAwbzdCajVISW5zc3NybWpHL3RpeG9PNmpISmtrcWkwR292bEttYXpkUlZZ?=
 =?utf-8?B?QkdjWVJJZkpleEgxRWh0UXF1K2c0YnllUTlyaDhxUGVLRDVlNDNaK1d5U1do?=
 =?utf-8?B?ZU5hZHllSTY2OVV0N1kvL0lkTnpGYksvcFlIWFJtZjBVRGNXSnJXMW5xT2tq?=
 =?utf-8?B?UXRRYnBpbnBiMnZnbjZqUmdaOUd1MytwTmswZzVObUZLbEtBNGdSaTRGdXZJ?=
 =?utf-8?B?NlFkaGM1R1Y2d0phNUc4VEdRdUNYangzQks4SEtSa1V2QzBMc0lqVkphVmhF?=
 =?utf-8?B?WDRQRmdRUTlHRGptUEhxVkNaMmI2RFVYZ1NBR2JxL2R1bW40d0JrRHRZNkx2?=
 =?utf-8?B?SGt3aGxrcEoyWWZWL3JEczY1YnNJaTduOEN0TlRHSnpHM0t1V05nMHhtWmxU?=
 =?utf-8?B?VmdzWUhTd0VOcGJuQWUzeEk4d05zajdtK2poSFMrRnJ0SnZvWnEzZERCQmdM?=
 =?utf-8?B?d0NDL0k5Y2VSVXdEQkxKMEF3Q0hpSWtJb2xTWm9xN3ZJcHlBb3RnOVhhSm9h?=
 =?utf-8?B?Z2RYaGlVQ0N3ZTlzSkthMWJuZXdDVGE2YTV0eVlCZnpuM2xOSkNGbTRVTGNo?=
 =?utf-8?B?dnl3UzRod2owZGZhMnZBQzNHbHVnSFI3di9nTUZneVpBc3NYNmgxNlN2c203?=
 =?utf-8?B?bklNanUrVVZMWHFodGEvTjBFL1dheXdwdXptbzlZSnZQY3BvMFdVZmJPa281?=
 =?utf-8?B?VEZiU3NEenY4Wk9WMTRmbkM4OGdSZVdJd0FDSkF6OWNlMzFVYTZTbTNnbXhO?=
 =?utf-8?Q?zFBKbnNx6RhTospsWR4fJB3ra?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fdbb7006-c403-4ef1-26aa-08dc5df82c2b
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 09:32:45.7132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /vriDbHgwdrbfGJ6apXqbfSUlMenZ4+aDa0v5tdS52axG76H/tONBLSEWRLrQCext9ttc9eO29MQ1hvohm0POg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7064
X-OriginatorOrg: intel.com

On 2024/4/16 17:13, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Friday, April 12, 2024 4:21 PM
>>
>> +/*
>> + * VFIO_DEVICE_PASID_ATTACH_IOMMUFD_PT - _IOW(VFIO_TYPE,
>> VFIO_BASE + 21,
>> + *					      struct
>> vfio_device_pasid_attach_iommufd_pt)
>> + * @argsz:	User filled size of this data.
>> + * @flags:	Must be 0.
>> + * @pasid:	The pasid to be attached.
>> + * @pt_id:	Input the target id which can represent an ioas or a hwpt
>> + *		allocated via iommufd subsystem.
>> + *		Output the input ioas id or the attached hwpt id which could
>> + *		be the specified hwpt itself or a hwpt automatically created
>> + *		for the specified ioas by kernel during the attachment.
>> + *
>> + * Associate a pasid (of a cdev device) with an address space within the
> 
> remove '(of a cdev device)' as end of the paragraph has "This is only
> allowed on cdev fds". Also a pasid certainly belongs to device hence
> just using pasid alone is clear.

ok

>> + * bound iommufd. Undo by VFIO_DEVICE_PASID_DETACH_IOMMUFD_PT
>> or device fd
>> + * close. This is only allowed on cdev fds.
>> + *
>> + * If a pasid is currently attached to a valid hw_pagetable (hwpt),
> 
> remove 'hw_pagetable'. the abbreviation "hwpt" has been used
> throughout this file (e.g. even when explaining @pt_id in earlier place).
> 

ok

-- 
Regards,
Yi Liu

