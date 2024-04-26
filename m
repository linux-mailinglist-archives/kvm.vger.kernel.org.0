Return-Path: <kvm+bounces-16032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAA8B8B3374
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 10:58:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0862B1C21333
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 08:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A0FC13CFA9;
	Fri, 26 Apr 2024 08:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HInF2IJ3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF50E13A242
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 08:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714121902; cv=fail; b=eh7bgOSHrREg/+2GKnRDj+6PJjtZTXrera8ObGJQxCyKSSk+osHWJrOyzYn6fzJobIix6fWYfe64MkboiPK5xt2S39xKmuozeaANxlrKZc40YopsTjp0x5p2StIrYGQD2X7HFIm76yjtWDDesabpINJ3Dc7aQLPnNI1Mh1sIKmY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714121902; c=relaxed/simple;
	bh=rONSEEHRZ2aaDqFfwq/OZttbnZaoqBu1SR41eWGZKgE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZkqBZZAWJeaKPbYF27LjwaTMy9Cj7v1o65siqkXUsbmvYryS2KvDfR+EEnluL3ZvcoVMl57FdKt8tl1wnKVeV7LCi+G0EtYIxih2pbRz+akQ1thYrknHodH3MuV/Rl9nffkLfQUSIp61SUPaBSEbNxChMtQAQvuF6EL9iEtEfDQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HInF2IJ3; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714121900; x=1745657900;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rONSEEHRZ2aaDqFfwq/OZttbnZaoqBu1SR41eWGZKgE=;
  b=HInF2IJ3U1HTHYxg8VOx1F5FcQiA45vxAyvpt+0D6LUdbvTrsgnK/ddj
   Gr/4YLYY+mQuY3gSf0qETMiApw0YPRH/TP0ZigL+vBctP9QHnekaKJx+e
   xwn9O6B02ZOfCoq2lWUXETOw2wfe23zQrZA2oWASoxpjrBMvwsqF9W9K6
   EDkkwqt2mnZjJUsDZ/yCfdHkdd9kyU24LzaWDK1IlC2zIOKjaiAmqOmB8
   bzf8P8abEeS5OLAAsi1ss/0JQC3Yhry3haydK1dYBLkmo4iyDu/hpJXW+
   Fiy+93nM1S2lAX64HA6F3o7gvHAVPrVlkeTgOIVzUaDvWC/mSLbXTC6Tz
   A==;
X-CSE-ConnectionGUID: 94saenZqQvG891lKusxiyQ==
X-CSE-MsgGUID: J7/vWAJIQM6LjU9623whXg==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="35237971"
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="35237971"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 01:58:20 -0700
X-CSE-ConnectionGUID: ayr1jJt0Qga9bmybimlBCA==
X-CSE-MsgGUID: SDmm6O/sSjCLWH0njPHHQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="30011773"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Apr 2024 01:58:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Apr 2024 01:58:19 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 26 Apr 2024 01:58:19 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 26 Apr 2024 01:58:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AfcYMR9+5cV3ddYC6l/hVsYTXu2r0DmSpHOT/Nw2PKTy0d8/c7sruG4BvITvQqXmTlsbPS/DTIev6640Zd9u/oF/y85k0Zyu9j8JHZDPV5U6dJmH8qHdFegH5AicG3F0tbRxftbOs0iHfhXNrVq/T6FZyWivKxhJDl/Um4wLnq9bARwO+b4qbR/BmXfET3rpd0pcoj90R3lZ36JavEvq7v8JgDxXxx0bnZABkVmGgKWh18jb9idjsQ3f7OUODbU4hlc3OgfN4bXVNw8AInxzUgpjK2DGyR7mbqp0R1Az8RwiSykMEmSKkmZU2uQb/z2NqH8zab1Uw4VT4+jh/Dc3nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uTLApEuFvBLq4yOsP18DsMDFslAQpAY3Je+nZahRarQ=;
 b=dvoK6ObpRFsYcsYLU04w/NSd7QG51nd8Xd7P520tLyxC7ElLnPUc/Jwmne3E4SE4NdBTUGFdKqBnd28hhDan+HmB8eSdJWJVT/Q5PL5SNhKtTGlRFtNmmT+TLd0jLuBqg0E+FyzFur51z2Z7PyShHl4r2CYsoKGH3LoA59e0n4U9uuUtenfjcjHdeYuz29vFnn38ZhOw1N7zXy3fbYC/T4xFn0rlcIyS2NqxnaWMxFFAmrGkb4xUTw7/YADvEzNt+29iZtdTypvUHEVFKGJbtBle9aovc37e8gEk2Fuhvi/YwnI0Bs+kFbLB+/i07Bia3EAYPsMw7K5Cs9y0ijI6uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY8PR11MB7394.namprd11.prod.outlook.com (2603:10b6:930:85::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.21; Fri, 26 Apr
 2024 08:58:15 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%7]) with mapi id 15.20.7519.021; Fri, 26 Apr 2024
 08:58:15 +0000
Message-ID: <2ac004ba-2a3f-4e89-8ecb-e613daa10500@intel.com>
Date: Fri, 26 Apr 2024 17:01:49 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
References: <20240417122051.GN3637727@nvidia.com>
 <20240417170216.1db4334a.alex.williamson@redhat.com>
 <BN9PR11MB52765314C4E965D4CEADA2178C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4037d5f4-ae6b-4c17-97d8-e0f7812d5a6d@intel.com>
 <20240418143747.28b36750.alex.williamson@redhat.com>
 <BN9PR11MB5276819C9596480DB4C172228C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240419103550.71b6a616.alex.williamson@redhat.com>
 <BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240423120139.GD194812@nvidia.com>
 <BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240424001221.GF941030@nvidia.com>
 <20240424122437.24113510.alex.williamson@redhat.com>
 <07fbea50-b88d-46d8-b438-b4abda0447bb@intel.com>
 <20240425065827.66b3b9b8.alex.williamson@redhat.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240425065827.66b3b9b8.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY2PR02CA0032.apcprd02.prod.outlook.com
 (2603:1096:404:a6::20) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CY8PR11MB7394:EE_
X-MS-Office365-Filtering-Correlation-Id: fa28cb0a-d9bf-4420-5ccc-08dc65cf0244
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|7416005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aUZZejZFUGE5QWdqU0pldEpabGxZRGVacHhKcWt1RlpKeGFwWjBFYlhtdytU?=
 =?utf-8?B?SlBrQ3JIVGp6UklhSjJQeXBzMFd1TlFCdStycWJHS0QyQ3NDdUREUzg1VkV3?=
 =?utf-8?B?aDE4c3RaY2pkeG9oNGNrbWhla0JvNW53cDV1TjVKTGlocmNSVmFSdWVaUGVO?=
 =?utf-8?B?NUd2ZWhFckFlSTFXYXRqeDlNY0ZyakN0b1lKd2E1RnFLSHlhMGhzaE9ZT0do?=
 =?utf-8?B?WXlpcFRUa0tSd1E2SHQzNVVrQ05FRVF4T01nSExvaFduTE83NzBWSjhxUlJV?=
 =?utf-8?B?YUEvUHdFV0Q4OGo4Wk90OXlxZFI0Z1hrclZDeFl3bXNid00yNmg5dThKUGU2?=
 =?utf-8?B?cDhHUTBsTndSb2QxR3I4OFYwMmQ3cjh5REZzOHpkc2xUSGZWVHFVcUJLbkFZ?=
 =?utf-8?B?OWZaU3UyaHJZekJrTHJ4SVZXQVZ0QXlCSzBOK3hzcnJpQVBlTUhXWjFVei9U?=
 =?utf-8?B?LzUxcVFkdk91WnU4dWpQdnV2VXlQT0xuaC9nMTRxVWFQY3lpZzdIeW91d01O?=
 =?utf-8?B?OWUzL0JRYUZNNDA0c29LOGI4UjdML1Zmbkh6UTBFWklMVlFNbHQ3SlR5Vzhk?=
 =?utf-8?B?aDIrdE9TTUFuS2lFVXcxWWxoSm1tSXlhMzZPNnYxTWNyaDlVWWxZSXpHcm1H?=
 =?utf-8?B?RkIwbktPY2NNSTdYYkJ4MFp0M2hDeGxOLytSSngvM0RGUTBRbGx1NkxJaEkr?=
 =?utf-8?B?QTB1NEFhbTdreEV2cFVXS1o5YVBLeVo5cW00TWIzKzExdUE5TDJvd0lDMmt6?=
 =?utf-8?B?Q2JkRGFFVHRzakh2RlNPcWFMTnBnaDQrZThQMDV3b2UrOXFLQnF5dWdYYWl0?=
 =?utf-8?B?WjFsK3hyR0ViWHNreStTazkvaTdBMUF5dGhyb0pEVlpRS0I4K0RTZXp6dmxF?=
 =?utf-8?B?RTByZkRYRXMvaEdkazFDWFgyYzNMT1EvZ20yT2pIZVpBc0JORk5Gc3IyQmk5?=
 =?utf-8?B?V0pIelI1cmw5S052S3FhT1NPWks3c08wWUdvRVAwckZYUE5pbVdKQjN2Ulpj?=
 =?utf-8?B?Rk1WSmRMNjg5aGJPamkxY3BXdnBaeDNjU1ZKU2tmTHRIdWRQOVZpRml1aTdT?=
 =?utf-8?B?L1V6RTAwOU5ibVRoSFdKdnpGeFlKeTNUZllGZmtTZlNYT1B6NWNVS0VuOGhq?=
 =?utf-8?B?dTRWYkp3d1hLL1ZGVHAyODNhYjdGdjVBdGVPSG15VDBINTQ2d21FTVFyUkVJ?=
 =?utf-8?B?REFIOE5aNG5taEloZExreHFocGlxSTQ1RHd5QXcvSjZ0akpRSkJ2d3drQWxO?=
 =?utf-8?B?QmdpYTdtVXdQbnlQcElhMWl2bFdEck9keldyTllDTGwwWGFrOFo4L1pGcUxw?=
 =?utf-8?B?UTZoQ0VUT3FoT2pwTnJCZkRnTm9acUFZOU9DYURIMVhaMFYwQUhWQ1AyT0Rq?=
 =?utf-8?B?VnBCODdGZnZQNjJsSnIzd2JxU3RUb0xtbnhXTGw1V0lPaVBtR2lJTVpaZjVU?=
 =?utf-8?B?V0pRdXJ6VCtIOFRIS3ZBS2E5K1owMjNSRUhnWHBkaHF5RVF5TWtqNTVJZ0hk?=
 =?utf-8?B?UlcvL0pucjA1V0plQTRDQUg0SzFzZlZCeHlHQlMyd3RoNkxzaDBPZEwrd1R4?=
 =?utf-8?B?MlNjT01sdUJ2TXlpNU9qdXJIRXRrL0pzUG5xWGFFNXp3aGpwV1oyTER6WUJa?=
 =?utf-8?Q?2NisCEgX/5txbDLChp6WYCP0dM/KD1ozEprzejS+FnM0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ykd1U3pLVm1IT3VlaXNma0NoUmpNVVlvL3Naa0VrMmpmNC9rZDFOWVpJd29y?=
 =?utf-8?B?RWVaLzBwMmlHNWtVVGNxTEgyTWxhS1RJZzNvOTZqZm53aE9JTGhPSGorZGM1?=
 =?utf-8?B?NkQzbE51ZWhXbkQ4d0puMmJLRWlscVBEc0ZuQmN6YlFIVjhJTzRrOUF4RTMr?=
 =?utf-8?B?TTFXbjRZM1JBaGh4WUx6NjBQcmpSeUk0UjgyWGRGOUJtQ3EvZk5kTUxQTUMz?=
 =?utf-8?B?N2h3V1VndUlveGFhN0hZSDYxVUlMVDR2Tkttcm5VZ0J0UUhpbE1iZXF0azBI?=
 =?utf-8?B?dFZrTFNseUxtYnBjcDkzZnBMWTduNm8yOXRiSzd3dDJzMHcvWXFMMi92Vi9n?=
 =?utf-8?B?RzkrdEdsRTFjMVNkaTA5T2FyeDJMMEhtYTFjVnpmcGkzaGtKdjkrM3c4NkVq?=
 =?utf-8?B?M3VoaStFNitQeFVlc2h4ZFdqVXN3cUwxWVdjQ2hMVlRPeWZIQktVcG1PQnlO?=
 =?utf-8?B?L0xLUUlCYmxnLzBCSWdqQ3ZGRW9uVXBaTXI5YjVta0oraWIwcW1zYTJTSVhO?=
 =?utf-8?B?cUJwUkpsZ0FaZU92OXFNMUdMKy82NnJzdUhoNEV3U1FvSlYxczhBTkFRMG9W?=
 =?utf-8?B?cEZHMmhXcythRW5Dc3ZCNVRDLzFjelg1Z0ZIL3JBZ0hvR2dNT08wZFFMWTYx?=
 =?utf-8?B?Y0FyOW5NRHordit2cUdQa0YwV2FuMUFBZXdNTmJQT3NkRkJnQTBRY1JHRXRs?=
 =?utf-8?B?aE1RbTlqa2Z3WFRMTGlIWExHcU95ZGcxYkl1dEZHd2U1N0gvMUZZNkZhUG5o?=
 =?utf-8?B?UnBLMlExSW5IcUQ5QVovQ0QzM3JLeHZiTWxqdndyUVk3ZGFWb1VWN3JjbzdL?=
 =?utf-8?B?UDhmZUNreUlIbjc0NTQ1dHhuM3BvUk10SU5pcUNGL3pHTVFiTXoyWVlrR1Vp?=
 =?utf-8?B?eG1tRHE0NW1CaFpzNXVaR1FRd290blNRWnFtbzNaaTNIMlcyUUZKNmlFMG1P?=
 =?utf-8?B?OVNuVW1tZ3lyUEZFS1QzcEF3SVc5bFZWd21vUlZiem9wUmxSU0FHNVJnWUpD?=
 =?utf-8?B?ODZSVmg0QWFwZjlCOTVjc0NVaDRObXl4NHZqM3dEYTh5eWNNMHIvcXQ0S2hQ?=
 =?utf-8?B?WXIvRzhQUWo1OGhkL0pGSzZHQWdOUzNXN0JBVTFLcWh2ck5BaDVZajU3MGU2?=
 =?utf-8?B?cFJiamlvakI3ajc2elBoWFVSYkRIYm13VVZ5UXllMmhoQ08wREhhdE9xL0xu?=
 =?utf-8?B?MStSZzRjdmNrNDgzazJEblBON2x6S0k0dElNUnMzNXEwaVN6OHVqdWpNcEF1?=
 =?utf-8?B?c1lFVG9WKys3K0tOSUowVW1CaU9DSnNFcDRFMkNkR25CLzNZYW12NG82ZHBt?=
 =?utf-8?B?Qi95VksreVJhYjU2alEyY3Q0RW9mT285ZnVEZGJ0WE9heGNxcktkYzJCay9Z?=
 =?utf-8?B?Q21nMHJHYjV2OE5Ta0QzMmhmeTMxT0FTWkdLaDNxT3RreGJlU29LQkJHak82?=
 =?utf-8?B?Q3dLN1hIYTVZVnBkU2VsU0xDRDBiZVk1MFVBK1J1WGhiOXBsaWZqVllnak80?=
 =?utf-8?B?eUZyTnBsQ0NPWWJMTEttaE5KcExvbHhoRlZIc1I1RTFNdWoxblJHd2VOaE4y?=
 =?utf-8?B?K2VkRkF1ZDd1SExueHNxbERDTjYrY2E2Z0lpZHBHZTdaNmNQbXpyS2E4RU8y?=
 =?utf-8?B?TnlRVENBbHNzVGwwbzU0QSt2R28rcWhIbzhFSElBOW0wMW9BTWhyV1lRVWc0?=
 =?utf-8?B?STJIeWVIaFlQWC9QU01JdTA5SDhkcTJHV0NrNDNtT0RUT2ZYOEtLaVNwSXFH?=
 =?utf-8?B?L2Q3MlBtOUdCcy9RQkNGYk9SMHRTclIvc1lDeVdSenlGZkhIbkRzOEMyakdw?=
 =?utf-8?B?YkdlbDBxN05pcGJSdTFMMENyTDRyZUJYcnVUSUVjNFJ4b2hrMVg1RjRGcjJv?=
 =?utf-8?B?dUlzUkphblhOM2lhQmNhTlpSRmkvOXQ5aExCd1kyNGM2Yks2ekRLSVRxT2Jx?=
 =?utf-8?B?RXRWN1ZXMXkzUkN1ZWxqL2t5NzNHUnl1bDFMTTRIOVJ5alRYYkdReGNiNDdH?=
 =?utf-8?B?aE5lTUJtSGdYL2RkcU1MRkJrbUIyTDg0TFBWOGZtT1pYRjFhLyt4Wk90WVQr?=
 =?utf-8?B?NUlVNGRsSk5TZzhzcmNxNGtVeC9aYUViaUlzZWpJb0dkUnNZWmRBbFk4YTdK?=
 =?utf-8?Q?70/8nupZ7rxrl846lQkD59+JN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fa28cb0a-d9bf-4420-5ccc-08dc65cf0244
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2024 08:58:15.2836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dHAbwsQcECLiLlA5gXVtWh4VP3W6+ZGK/suvd4rOpOZyzBatPgd16cgEoT31aecR74iKRKxDh9ZYKgLu/U5ojw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7394
X-OriginatorOrg: intel.com

On 2024/4/25 20:58, Alex Williamson wrote:
> On Thu, 25 Apr 2024 17:26:54 +0800
> Yi Liu <yi.l.liu@intel.com> wrote:
> 
>> On 2024/4/25 02:24, Alex Williamson wrote:
>>> On Tue, 23 Apr 2024 21:12:21 -0300
>>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>    
>>>> On Tue, Apr 23, 2024 at 11:47:50PM +0000, Tian, Kevin wrote:
>>>>>> From: Jason Gunthorpe <jgg@nvidia.com>
>>>>>> Sent: Tuesday, April 23, 2024 8:02 PM
>>>>>>
>>>>>> On Tue, Apr 23, 2024 at 07:43:27AM +0000, Tian, Kevin wrote:
>>>>>>> I'm not sure how userspace can fully handle this w/o certain assistance
>>>>>>> from the kernel.
>>>>>>>
>>>>>>> So I kind of agree that emulated PASID capability is probably the only
>>>>>>> contract which the kernel should provide:
>>>>>>>     - mapped 1:1 at the physical location, or
>>>>>>>     - constructed at an offset according to DVSEC, or
>>>>>>>     - constructed at an offset according to a look-up table
>>>>>>>
>>>>>>> The VMM always scans the vfio pci config space to expose vPASID.
>>>>>>>
>>>>>>> Then the remaining open is what VMM could do when a VF supports
>>>>>>> PASID but unfortunately it's not reported by vfio. W/o the capability
>>>>>>> of inspecting the PASID state of PF, probably the only feasible option
>>>>>>> is to maintain a look-up table in VMM itself and assumes the kernel
>>>>>>> always enables the PASID cap on PF.
>>>>>>
>>>>>> I'm still not sure I like doing this in the kernel - we need to do the
>>>>>> same sort of thing for ATS too, right?
>>>>>
>>>>> VF is allowed to implement ATS.
>>>>>
>>>>> PRI has the same problem as PASID.
>>>>
>>>> I'm surprised by this, I would have guessed ATS would be the device
>>>> global one, PRI not being per-VF seems problematic??? How do you
>>>> disable PRI generation to get a clean shutdown?
>>>>   
>>>>>> It feels simpler if the indicates if PASID and ATS can be supported
>>>>>> and userspace builds the capability blocks.
>>>>>
>>>>> this routes back to Alex's original question about using different
>>>>> interfaces (a device feature vs. PCI PASID cap) for VF and PF.
>>>>
>>>> I'm not sure it is different interfaces..
>>>>
>>>> The only reason to pass the PF's PASID cap is to give free space to
>>>> the VMM. If we are saying that gaps are free space (excluding a list
>>>> of bad devices) then we don't acutally need to do that anymore.
>>>
>>> Are we saying that now??  That's new.
>>>    
>>>> VMM will always create a synthetic PASID cap and kernel will always
>>>> suppress a real one.
>>>>
>>>> An iommufd query will indicate if the vIOMMU can support vPASID on
>>>> that device.
>>>>
>>>> Same for all the troublesome non-physical caps.
>>>>   
>>>>>> There are migration considerations too - the blocks need to be
>>>>>> migrated over and end up in the same place as well..
>>>>>
>>>>> Can you elaborate what is the problem with the kernel emulating
>>>>> the PASID cap in this consideration?
>>>>
>>>> If the kernel changes the algorithm, say it wants to do PASID, PRI,
>>>> something_new then it might change the layout
>>>>
>>>> We can't just have the kernel decide without also providing a way for
>>>> userspace to say what the right layout actually is. :\
>>>
>>> The capability layout is only relevant to migration, right?  A variant
>>> driver that supports migration is a prerequisite and would also be
>>> responsible for exposing the PASID capability.  This isn't as disjoint
>>> as it's being portrayed.
>>>    
>>>>> Does it talk about a case where the devices between src/dest are
>>>>> different versions (but backward compatible) with different unused
>>>>> space layout and the kernel approach may pick up different offsets
>>>>> while the VMM can guarantee the same offset?
>>>>
>>>> That is also a concern where the PCI cap layout may change a bit but
>>>> they are still migration compatible, but my bigger worry is that the
>>>> kernel just lays out the fake caps in a different way because the
>>>> kernel changes.
>>>
>>> Outside of migration, what does it matter if the cap layout is
>      ^^^^^^^^^^^^^^^^^^^^
>>> different?  A driver should never hard code the address for a
>>> capability.
>>>      
>>
>> But it may store the offset of capability to make next cap access more
>> convenient. I noticted struct pci_dev stores the offset of PRI and PASID
>> cap. So if the layout of config space changed between src and dst, it may
>> result in problem in guest when guest driver uses the offsets to access
>> PRI/PASID cap. I can see pci_dev stores offsets of other caps (acs, msi,
>> msix). So there is already a problem even put aside the PRI and PASID cap.
> 
> Yes, I had noted "outside of migration" above.  Config space must be
> consistent to a running VM.  But the possibility of config space
> changing like this only exists in the case where the driver supports
> migration, so I think we're inventing an unrealistic concern that a
> driver that supports migration would arbitrarily modify the config space
> layout in order to make an argument for VMM managed layout.  Thanks,

I was considering a case in which the src VM has a v1 hw device, while the
dst VM has a v2 hw device. Due to whatever reasons, the config space
layouts are different between v1 and v2 hw. Since the current vfio copies
the physical layout (except for the hidden caps) to VMM, the layout between
the src and dst VM would be different. This would result in problem since 
the cap offsets are stale. It seems to be a problem you mentioned in
another email of this thread[1]. :)

[1] "So in either case, the problem might be more along the
lines of how to make a V1 device from a V2 driver, which is more the
device type/flavor/persona problem.
" 
https://lore.kernel.org/linux-iommu/20240424141349.376bdbf9.alex.williamson@redhat.com/


> Alex
> 
>> #ifdef CONFIG_PCI_PRI
>> 	u16		pri_cap;	/* PRI Capability offset */
>> 	u32		pri_reqs_alloc; /* Number of PRI requests allocated */
>> 	unsigned int	pasid_required:1; /* PRG Response PASID Required */
>> #endif
>> #ifdef CONFIG_PCI_PASID
>> 	u16		pasid_cap;	/* PASID Capability offset */
>> 	u16		pasid_features;
>> #endif
>> #ifdef CONFIG_PCI_P2PDMA
>> 	struct pci_p2pdma __rcu *p2pdma;
>> #endif
>> #ifdef CONFIG_PCI_DOE
>> 	struct xarray	doe_mbs;	/* Data Object Exchange mailboxes */
>> #endif
>> 	u16		acs_cap;	/* ACS Capability offset */
>>
>> https://github.com/torvalds/linux/blob/master/include/linux/pci.h#L350
>>
>>>> At least if the VMM is doing this then the VMM can include the
>>>> information in its migration scheme and use it to recreate the PCI
>>>> layout withotu having to create a bunch of uAPI to do so.
>>>
>>> We're again back to migration compatibility, where again the capability
>>> layout would be governed by the migration support in the in-kernel
>>> variant driver.  Once migration is involved the location of a PASID
>>> shouldn't be arbitrary, whether it's provided by the kernel or the VMM.
>>>
>>> Regardless, the VMM ultimately has the authority what the guest
>>> sees in config space.  The VMM is not bound to expose the PASID at the
>>> offset provided by the kernel, or bound to expose it at all.  The
>>> kernel exposed PASID can simply provide an available location and set
>>> of enabled capabilities.  Thanks,
>>>
>>> Alex
>>>    
>>
> 

-- 
Regards,
Yi Liu

