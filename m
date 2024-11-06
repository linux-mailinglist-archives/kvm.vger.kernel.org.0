Return-Path: <kvm+bounces-30909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DD24B9BE40A
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 11:18:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D2D41F230D6
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:18:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B02331DD9AB;
	Wed,  6 Nov 2024 10:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KPbBIaIH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A1D1DC194
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 10:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730888279; cv=fail; b=SbAqiMg3/Hrj8fOLPZBUC1KxYFTYmoXOro7OjbALYZlC88EBu1W3ErpkwBNpsRFSRTRA1J49ZCZw+ovMGjIfRTncTqAoGlRDyBJif6+xKgDidPD9A1iajWSBKvtNCSST8nTkDezyw4C96rNasxzW0YB+VgFZHn52q3LEEMyOH+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730888279; c=relaxed/simple;
	bh=aJW23bvLAW+BchA7ZtfpZOHGb/4q885fnjCM++LpgaY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=P3GzZIHUztBv9HKkr+jcaae0OV2r4MBqT1iscKot9C0mIfhWdtVPRb59Xqf84QkKQe0jsbru5EYcv5ErZ08ObLG30CjKpLq4eydaL2dTn/iPsTSTNspBhzLqchJMosP62MSjPxnJaqNqTywi+uuH49V7PKUPFrvyc4ZxAjhzblU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KPbBIaIH; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730888278; x=1762424278;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aJW23bvLAW+BchA7ZtfpZOHGb/4q885fnjCM++LpgaY=;
  b=KPbBIaIHk6PhYPQ7esd5nY9XvTXfZMjCZqlTDPUKXsqgSmphxztBbNUn
   3Go9QNgIS3OGNjCiFzoVNJy7I5BeH8AlieYny7EV5MlX9SeRnzGo/krde
   WLyJlBkw87HyhynNebypw2cBoaIuh1qMsraSkBoTZyUccIr25OdAKGuSb
   k4aam5GAvXt5ryJ8nt1RvN5VDrgNb6H3aNNSN182BId4FolNT6Y1GBDuY
   CN+rkgwT/uP6CaEoU2uBITbQcsOjX2coQ2IGuCqrxIhxozeSb9gxO7P+s
   hBhDu1eJ1+NANmAw50wTBICGa0pUdqrH0D37zS0QzjQ+XvpT0Ot3GKIOW
   A==;
X-CSE-ConnectionGUID: ACQD/BHoSwej4d5XgMyZIg==
X-CSE-MsgGUID: EBdFDbIRTJWeH3VjEeFPoQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30531131"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30531131"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 02:17:57 -0800
X-CSE-ConnectionGUID: zZreQkxwRweNRPMD/LadLA==
X-CSE-MsgGUID: fLi+dTHWQWqdsWwQp1RETA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="84370360"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 02:17:57 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 02:17:56 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 02:17:56 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 02:17:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X0mfb2OgA3ndP7n7EyWEs6mi4W7bJ6j/0Wiic2Q4WfydEKX739BX9N1X6CL77kHZ6/o9lfn7s0sUOvgkquhnQIo5AhbCkAWh7JGUcqrswMObsvirxd7zAsxk0Xv7eR6srjG1KkMutPjplryYA9aRspaKYpknpcrQxs6ojFzgfCP4GM4tbErzihhF0d2k8IZjAHaGC6rDf9aFf8FJF2FmjyhCyV19fSZ3EvToyfQsH3m1pt6E6hXrGS5pQx7+pyKuF54lmvDepoHEqKHeDyWSkRBxmqEMbhuh2Qk1Z1ZNapwsqeO9jqdMxHQQdSjsjYDYliV17us2a07HvUGeCg9ncA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7SryydX5Siz5W5Zp7GgeIum0gyGhDohnq/O6cGFO8OI=;
 b=J4Wkug4t53S62tTll1kqat8D0FzHIwQBYgRWCOTqAQhWPlS8WZxVAGGgbPQj8plyj4Lw6q5ht93TVfqO5RpUpSLk0sX/KEkzhnjvi47SODPM7OARc3zpfWQF9MqaWheqtWh23XIjK6tLf84QeSwM3YUc4cTOYptPnBZQQAF5svosWS9pgw2K/EI6cF+fgSlzRgDRjARYtfEQKibM9qdaqqWvZ1D0aVpIScJqVRzi1Nq7BHlMfl1CuuQlBlP/7gtz6kmtpbiHaQcUEGtsqgJQiOiTxWqmC74MZAczD+z8Xci6j3aRIW6/b6dzsBNsm6CIIcMnc+OAFCqrk4hMvBuF0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB7788.namprd11.prod.outlook.com (2603:10b6:8:f5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Wed, 6 Nov
 2024 10:17:54 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 10:17:54 +0000
Message-ID: <2f770fe6-627a-45f0-a3e0-4488f635856a@intel.com>
Date: Wed, 6 Nov 2024 18:22:31 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/13] iommu/vt-d: Add a helper to flush cache for
 updating present pasid entry
To: "Tian, Kevin" <kevin.tian@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-3-yi.l.liu@intel.com>
 <BN9PR11MB5276D12FF07A6066CEAAF4308C532@BN9PR11MB5276.namprd11.prod.outlook.com>
 <b6442ba7-7979-4619-8b47-87ee90792517@intel.com>
 <BN9PR11MB5276DC217F91F706C0100A738C532@BN9PR11MB5276.namprd11.prod.outlook.com>
 <0edd54a4-b8ee-423c-9094-af0c841ea140@intel.com>
 <BN9PR11MB52760B5C45AD8D7B553404A98C532@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB52760B5C45AD8D7B553404A98C532@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0034.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::9) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DS0PR11MB7788:EE_
X-MS-Office365-Filtering-Correlation-Id: 4161a008-d25c-4dd5-6df2-08dcfe4c4709
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aEtkQTZqZzQ2c0FmclVQRjJsalVzVHBpVkpxeW8rK3RyZGcybnNiSXFIbzNs?=
 =?utf-8?B?amQxcG5LbThGeVYzOU91M2tMblMrTjlDVXVpRnJLangySzFuVzRLMkZPb0lF?=
 =?utf-8?B?OEFGVW9tUXBxVzZqeFB2YXJCbm91K3F6eUx5T1dBNHlWN0gwcU1YM2JzT1BO?=
 =?utf-8?B?ODJUN28zZUhaSlI4dndReDFDajlCTHVIbFFkcml1YUNHMEZKR3JWSGxlZHBH?=
 =?utf-8?B?eVZUbFRiNGpUVEYrMXE4MUxya2tEYmk1UldSdlZpcXNkY1BXcCtSaDFtVGVL?=
 =?utf-8?B?TDUxMHZ4ODU2dHFiM1JwN1dYWWQrYTEwYU1DcVp2VFZSRHNHdEcrdHg1QXJV?=
 =?utf-8?B?SUFQMXh6b2w5NVhaQWUzQVEwUVpiM0tHaWZKTnVvdmVDUXRadlNhV0NFc3Yz?=
 =?utf-8?B?ajNjWHRkUFlOS2c5bHBFWGMwVWcrQXluOTltRDZvblBmNjg0aTJKU0pFanZp?=
 =?utf-8?B?c205aVlsMWJCcUkweHlPNGxKWEo0VTMvbExTbnlXb0F5OWptWlk1U0NCcmtT?=
 =?utf-8?B?dzQ5ejU4RTcrV3Fia3Nqb1Q3OVRuVCtoQXNLbHZsTmszL0pyQXhESUFIbkVw?=
 =?utf-8?B?R3h4SDM4cktBNEhPMUxwOGt6K09ETEtvNTBtZUcyTy9ZbTdFdUtEd0FwZmty?=
 =?utf-8?B?THdNU29rSUh2WnVEZVhZSm9DaWVTOXpaamVvQlJRMXNrQktGT1BQWDFCTjRB?=
 =?utf-8?B?M255MndmcmxEZ0JFQU9vOVBNTCs1SzBQbzZuMHlzQzJjQ3B6N3k0R2J5bVJx?=
 =?utf-8?B?aTN0OFlPQ1plcHViUnI3UTVOSjIzSExPYmVUdFFXRUdjZHp0dDBNUFduYzZL?=
 =?utf-8?B?Rk5MaXhQQWlQUWY1YzUrSlR0YlVxVm9wcVIvYXhjczY3WDlJK0R1dm05N21i?=
 =?utf-8?B?UlJKYzh2T1RoOWd6TStmM3VwcmptbTdnTVp3ZVo2bDloVGlnMm1iWGl4Nmov?=
 =?utf-8?B?TCtJME9BU2RNTFRLTFpaeXlidkhOK0pORWdoY1pCRFpIWFFGeElZVWdnVjRl?=
 =?utf-8?B?aFZkcHhWc1VPUUtCNExraE9YSkUyWEJybzMvUVJXM3dzRnBDTVdUcEdZY1Rv?=
 =?utf-8?B?Wk5LUFErWG94MXlURFhYVzNaOW9ZclEwalJWeFhYUi9rOWpKdG1pN2lCWnJW?=
 =?utf-8?B?eG9QRkxBdGFTNk82Y3kwWmVIbStWUG12Tm95clJqQXN0WmZhaDhEQmNmclJQ?=
 =?utf-8?B?TzY2c1oyOGUvTzh0bkhzaVdySnB3UERsMnhDcGVHckJmcVFYMmVweUl1eFhz?=
 =?utf-8?B?RWJjcVArNW1Gdk85S0pJRWR0NENVUlVReWJrL1BRdC9SWEExTkVSamZQNWhh?=
 =?utf-8?B?LzQ3ZzI0YUF3dFppeVFPbEJuOHZ1SDA2QU53RDBXZVhuU3dWeEsxZUFGTG1T?=
 =?utf-8?B?cVA4TDhLNDV0aXg2ZVpEZzQ1RVo2WWpqLytDSUErMjRlRDNsS0tUUVh5Sll4?=
 =?utf-8?B?UXl6Q2xSYXUyajVGZlBjU0hNTUxhYnpmaENvak0xUXhZZWxCMW1JSlBZd1gy?=
 =?utf-8?B?bjduQzdOM2VQVTFuTFdVbnRIcVZXQmhTRk5OU09rcjRrYjl3ZWR0aUc3UmRJ?=
 =?utf-8?B?ZHZValROMWVPeWcwV2k3eWtmL256cWF5L0w4Uzl0SlFtSDVaeVk3Szc2ZWpQ?=
 =?utf-8?B?UkE4U2VyOXpPa1hOWk4waW9yS0RnNWpjTktHWS9FazVmQzNCQ3RXemU1RVB6?=
 =?utf-8?B?VjVwVE9jYnVkenhINTduNW0wRVdYRTBraTI2a285bHBENDB0RG9qbVd0SHZI?=
 =?utf-8?Q?eZT2PT99UI9Lecrf38=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cG51c09mbS9zK2lpTTVYZnBuUVd2MW9XSzd3WnBjOWJsN0RSMURWUWNXWG1S?=
 =?utf-8?B?cFNFMm9McXduUndDOHU0NmFoSDhGSE1qN3ZxbU1STUdNZU03RzNpM0dYVTk1?=
 =?utf-8?B?TVQ3RFE0Qk9jQTI1aVZMUGducEdKWWFtLzZRYmZxNnFVc0JQNGo5TnNoMktr?=
 =?utf-8?B?dVh5Z25qeVg4WVBYS0ViYS85NmVKNnNrTnB5S3pPUUVxNHIxb2ZpNlJzZjk3?=
 =?utf-8?B?eG56TmM3NkNaMkpFTzNpM1cvNTV4dFJQK29jbm41NFpWelhySmVyeXkyRnFE?=
 =?utf-8?B?SnpKandTaWFjdkFaSElsMFozaUFtakVrZ0Zlc1A4SGlOSzB1T3B2Z09aYmdU?=
 =?utf-8?B?UmwyME9JTWtRK0tuVEYzY2RMRjZ4SFN5d3h4MW5TNFZVR2JkVi9XZTk2S0Jk?=
 =?utf-8?B?Zm5wbjlVY045N0F0WnBkZGZMNk41UWlPZk5NQXlHZCsrWFZsL1FpdUFRejVQ?=
 =?utf-8?B?MG1XWERFNytDU2NJa3MrMkZQdndmT3FmNnJOdTBZWWVEV0tnTHd2TlVYZVZr?=
 =?utf-8?B?dXRpb1MzNXZHZjJWZHRDSG1yRFlRZGJVNVRldGNmUVlzRUx2REJoZGQ5bG1s?=
 =?utf-8?B?dlZYS0tvNlFtbksxQnp1NTl3cWxTUUNTZ1BTVUlaM2g2R3FreENFV1M0MkNv?=
 =?utf-8?B?UEJJVjlPZHNBT3J4WTZSSngrM2psMWlZcExzVndhd1Z4M1JVaDQ2THd1akJa?=
 =?utf-8?B?aEVYSVpvVW1pNmRjSEdmYTVpRTVxNElNb3o1Uk9HN1JoTElhTnFrclhmMllX?=
 =?utf-8?B?cm9DcUFTZHlva0VLOGFHMEdSL2I5ZC8yOCt5RXd6Z2ZBdEZUTDZUb21OK3l1?=
 =?utf-8?B?NW1FVlV4VzRKVGZKSjhYSVpRbnRIaWdNZmEyMkxxZ0hGS2RXbEp2bmlHODc3?=
 =?utf-8?B?UTVZdFJqR0xZZEs3OG9BVW5iOERZTGF5bXdwbkVQYU9COXN0ZmZ3Q1NKclR2?=
 =?utf-8?B?UnVRL0RDeVo5ZUhKZU5FT3lOcUxsN0IyeVNwVWpTWnlpaFNkVXczVURmSEk2?=
 =?utf-8?B?bENLYXdzVUh3V2NjckpQRVN1YVVrV3IxSkkrMnFudDhXQzdabFZheVZIRi85?=
 =?utf-8?B?SitIN2VtSE5NK0tlcTZ2OGVrWGZmU3QvZUVjSllVTStmbmhQV2xHWnk0VWxm?=
 =?utf-8?B?bDAxejhxZWpwQ1kyVXN5cUZiOC9tSkxxRlRweFpJeVpvcit4blVaQWJJK2M3?=
 =?utf-8?B?VU9jMUpKZzQydWFtWmg2d3lObjcrRUovUm5uOHVWOEJzd2tLTkZEUlRlMWtZ?=
 =?utf-8?B?VXJLVlV3NlJIa3N2RXBBcFA3REw1dVloTmtoWi80RWFTc3E1bFQ4V1FYMXdt?=
 =?utf-8?B?OVVpYkVxQWs4c2hBT3lpdW1KZi9nanZJazFLTTdoWnVzcVcvdVZSSUJROU85?=
 =?utf-8?B?KzBRL29yYXFRT0Q3VEM3WXJQU2I3TThGWDduS2RVMDVlZkx1Z3pkMVpUSlVK?=
 =?utf-8?B?bnlyV1NvUVhKcGtRN3YzQnFvcXd3aTJRR0NZaUFMdEs1ZzUzcTFmZVlROEhk?=
 =?utf-8?B?LzJxbTB4MkFHNE01NlZnQUE2bFFkSkgrVkFmVm8rQy9CZDg2YUJBekdDanBZ?=
 =?utf-8?B?VGxtd2RRa2d4RGh1aHE5aXppYW1CMy9paVhiZmV3R0V5YmgzakRKRmNuWE1a?=
 =?utf-8?B?TDhmMElHeG5YbzRmQkxnZDBrWkpHaVRoVDJUWG5yY0dlNkh3UXlCVHFybkM5?=
 =?utf-8?B?aXNnVnNFYlBDSEU5TUVUaFJib0tBYTk5d3BTMGtBckppM1hRdlpUdlovM21k?=
 =?utf-8?B?OEszcmlwMkNYK2JFQis0NlM0WGFuMFVxL2tBQnZvSXNad0hpUSsxdEJpMFpH?=
 =?utf-8?B?c2VScmF1TkRGaHBncHlDTnF3aFA0eU9taWVBTFdUbHpXQW8vOThreGpYTUI4?=
 =?utf-8?B?WWkzZ2QvZTlNT2srNzVIWmJiZUpCcFVTWHZaNWh5eFhwK0lJb0hLeXJGSTBw?=
 =?utf-8?B?YzhJN3kwVitZMFV6c2NjcjVQVVE5SGFHRTYrTmpVQVhHaHZZL3N4VGFPUFlw?=
 =?utf-8?B?dVFKNnF1NWNYOGlOTmJsMGYrd3NUbllxbm9aYWtmSzlpTWdrM05XN3k1VnNw?=
 =?utf-8?B?aCtvMzR0ajcvclRjRXB5UFgzNGpGSHRQUVp1NndFc0pCWEQxckx6SjdWaFEy?=
 =?utf-8?Q?qncaoigjHSyZSKThCwUIvc/Ci?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4161a008-d25c-4dd5-6df2-08dcfe4c4709
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 10:17:54.5649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DN6OFhbEbmLJno7qc1njScPzDtvXzZ1sW7wbur4pINyROUNbryDSiRWHKhDp/87qCZpntEyCK6ALXeP6G7KrPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7788
X-OriginatorOrg: intel.com

On 2024/11/6 18:01, Tian, Kevin wrote:

> Then just say that this patch generalizes the logic for flushing
> pasid cache upon changes to bits other than SSADE and P which
> requires a different flow according to VT-d spec

sure.

-- 
Regards,
Yi Liu

