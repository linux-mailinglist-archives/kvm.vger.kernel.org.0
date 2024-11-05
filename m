Return-Path: <kvm+bounces-30589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 225AA9BC2D8
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 02:55:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 86388B215F3
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 01:55:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37E52286A1;
	Tue,  5 Nov 2024 01:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EHF2Dflo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78933C30
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 01:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730771743; cv=fail; b=UXB/MAVok4osh1kL3/qgoCmk17eCfNZgVHoD5Lk7W8xjipmpqkXszwg8z2CpAEG11fu4zl70fXZ6Lg292ZOUJKa8GS6JQdd0bgZE+f/vTdPgZMeuzl9jSTINy4Q0j4514LP9C3KC5poeBr5crDLwdpflrs5RJJc2NNhAL5EoMFc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730771743; c=relaxed/simple;
	bh=xY3BnhhB/XAQYVvC87pcm5MBEiYrShifzBCe2+hGNP4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PdnZA+5PFBjGuCBmkzzHV/dGTf/p2bpDnD3tV51ymfr9tL/kL3fs1xN8cRI0OYzHPhdqwDvhEKztunPSqsu58WVYMlh4YCqPi0PCDuaglCsKeo8Q7hkB+th6Ww0MIcYwsNA3KvckPu0j6633ktCliutv8Xxy0yrP9ys6HjnmF8M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EHF2Dflo; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730771742; x=1762307742;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xY3BnhhB/XAQYVvC87pcm5MBEiYrShifzBCe2+hGNP4=;
  b=EHF2DfloDEVjMCXXb37R4540YlWHdWzjO+XYzn9kZsgo7XJnLGNgeZ/4
   G3ap5Um3htB9qUb0kQ+yE22BUdSjtRJTTsi+aSm0Au60JtUdz3OF9kHUS
   5K8DGirENeiSKqUYHyQgxxMJFjZs0B1Se75wWVFAgJWKuLVfIsw9np4fJ
   gF24rGeMKYr0HKRWzvy9e/LsJCNBeoUFfKVyjaTw7+/O+Q21IK7UuIMGy
   Qww3M55cqNlLvv7DERGLZsltKfdIdcQYA89AoVWfly9KLDioFbIaFJ9+O
   OWlVjY1FVVVMv6QwaHlMysbUTgWIxFwT21z0xv/0uXTUJKRnOjJlIX9Qz
   w==;
X-CSE-ConnectionGUID: LJ+KsMmHQziyKjZqal/QnA==
X-CSE-MsgGUID: vH0CKNjlRVOt/conLo4Xzg==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="30608199"
X-IronPort-AV: E=Sophos;i="6.11,258,1725346800"; 
   d="scan'208";a="30608199"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 17:55:41 -0800
X-CSE-ConnectionGUID: t5fPa+HIQ0entICoHeDcpw==
X-CSE-MsgGUID: 0Bg6iJMYSkGEqozscN6Y/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,258,1725346800"; 
   d="scan'208";a="83722606"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Nov 2024 17:55:41 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 4 Nov 2024 17:55:40 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 4 Nov 2024 17:55:40 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 4 Nov 2024 17:55:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=shJxaR//YfQbpNTbXwtMSug3UAksBDVdREbkDHFMw0RO8Zyh6wdJfw8/YikfHQwhqDzrdicmFhZYcqvTll1C3Cn58D24hf5lsaXzruvVFE4ETn3k7BhjzYrJpyhe2eDA0d8KnsZttHB6EPsdGdOAxwdyZZrspdXxEjJtAxYzpugxlqkmPLnOW48wXIMUCEjR75K98ch1nqEbUfmj6qn+XC6I0z7sGI7o6vlXjsGGhTh90xXf0fV/dg+0TpGgkD20VSySwQTPh6LRRPbu5v61ZfoK+25FVal4OktZoYStBJy8c4TiSArhqGUuWn3rqVjrL3Tz3HiwpKK3AVKeo/BwJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OwoBNvyBtz4ofAKnj6rDpSLdZZsSjiv66zVv/SMwUpE=;
 b=GAMhk7CYe26fUQe7ygzdEBLnLk7+oQNOxUOmEQtjQwm7G2U4q/0iE65VLDuVLRnCXyeQCOlr9sNHc8tpdMX8X/BB10knQMHOehUPVUGaGnfMij4/VnqTAKddZq19/20HBQ82rZCtVZ27vgHevdzjTxi5gTx39VWLf6ebClAwmypKhQ0xVsOCaqA/B9If7K6dDNDwM+v6xxa0agMN1MlEMd43Mvk8VNrHEfF/x17z+4mEFMhVjZU96Mt1SYz9DNGN/vhR+OihpP0m/3ptA7+wT1eI4IVcTs/zkwS/ytAHxq5iXhLYKFCApjIAELVQtBDXxuKli0vFtRMWtABgIa+Olg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ0PR11MB5104.namprd11.prod.outlook.com (2603:10b6:a03:2db::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 01:55:38 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%6]) with mapi id 15.20.8114.028; Tue, 5 Nov 2024
 01:55:37 +0000
Message-ID: <69e3466d-2219-45ad-9065-a55f4c2cf417@intel.com>
Date: Tue, 5 Nov 2024 10:00:13 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/4] vfio-iommufd: Support pasid [at|de]tach for
 physical VFIO devices
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <kevin.tian@intel.com>, <joro@8bytes.org>,
	<eric.auger@redhat.com>, <nicolinc@nvidia.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <iommu@lists.linux.dev>,
	<baolu.lu@linux.intel.com>, <zhenzhong.duan@intel.com>,
	<vasant.hegde@amd.com>, <willy@infradead.org>
References: <20241104132732.16759-1-yi.l.liu@intel.com>
 <20241104132732.16759-3-yi.l.liu@intel.com>
 <20241104135936.22f7a18b.alex.williamson@redhat.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20241104135936.22f7a18b.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0014.APCP153.PROD.OUTLOOK.COM (2603:1096:4:140::6)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SJ0PR11MB5104:EE_
X-MS-Office365-Filtering-Correlation-Id: 205c032c-9001-4fd3-acf4-08dcfd3cf1c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?a00wSDlnUGpCdUxLbENZbHpGRDBLVXE3bFpFeHlYVzNrMFM1aGdaa2k1eVBD?=
 =?utf-8?B?RHB1cDlYRHpodHNsNlZpUk1KdW12NDFoaGRabnRZSE42eFJRY0FHaW8vSDEz?=
 =?utf-8?B?TFVkNC85aVdaL2M0L2JyTkl6SjFTV2FIbFJFT3dOTG5EVHFUaTZUMUNaTmhG?=
 =?utf-8?B?azdRMnFuWWZGSW5jcHpiNVNBZzFkYllWaHFqa0dWSWhSVDhkTjhvbUZ3MEti?=
 =?utf-8?B?SVdSNEZNam10RzhoSlJPck1LajZqajNVNDZiclNmbXFDOEg4cW50ZnQ3WjVr?=
 =?utf-8?B?ZDZZZ2R1NXJhWTJsbDVhM29tdW9HYlBNYlpTYmo0djkxN0FNTEVXR3UrSE85?=
 =?utf-8?B?dGJXWmV1bHk2VitQcytGREJ0QkpURVRFOW5vdnVlY3hsTVBVLzVYM2tkZXlO?=
 =?utf-8?B?d0FMZEh3S2RTanRoNkNFbnlWNHR5c1VzVVhac280MHVsTVBWUjlzV1JPUm5R?=
 =?utf-8?B?allBSjdsblJtYUJ3OW9XOHFnSlNpa0VZZDNqd3lxcE52cE5uUkZuNFZkSW1D?=
 =?utf-8?B?L0hUcGtpWU5zeTFkLzZZbjl4QXluVyswVk55VTY4Rm5LbytOOEZaVWY1S2pP?=
 =?utf-8?B?dHRHNjIyWitoMWlrM0haaTNtcXQyMS80YktoWEExVTlUV3E0dWE4cWtLVEJi?=
 =?utf-8?B?SHBhMVRDZG1tUXZDcVFXdTlETlNSMHJrZ2F2S29WU1hZTmNhUjdHSWE5dUY4?=
 =?utf-8?B?MWpvcEc5bXozZm5xcy9mTlMydVBNdWdPaE1oTUhoT1JqMlVzYWt0VGNKdzU3?=
 =?utf-8?B?SDdqZjJFelZ5VnlPaElRcHhld0ZBUHpZVmoxNmp6VTVYNTFaa1hqSlVsU0My?=
 =?utf-8?B?TmRueWxOOGJ1UDNLQjFKRWFHM2kvckZlZGxXM2dGVzNPWnJZbUpnNHZGTzBC?=
 =?utf-8?B?MkVLNGIrWFNFYTZDWEkzZ3U0b2R3aVBsUlZBY092WWFqMHZPU2JjUVZvL0da?=
 =?utf-8?B?bmZBU2oyM0J5S0szNzltUXp5RGtzR1l4ODd0UEhhbVVqZWQ3NTZxNjVTL0Ur?=
 =?utf-8?B?elRtdXR5OW9ybUg1QjNyT0d0aFc3bGxFaW91NjJSUEF5N3pSVEc1YjRjR2dJ?=
 =?utf-8?B?WVh1R0JtMkVnREl6ZkMwNGsvdng4ak9rMENhZkd6a3E4aUdJOGsyTzJ2U2hH?=
 =?utf-8?B?NEdRWHhJcmlZNUFrWVpyN0pVdXp4Z1V1amk0eFNIRWNLRUtCaUJjbHNUY2FW?=
 =?utf-8?B?Umo1RmNuTWNKUUczalpOYmhpQXBkSzZtUDhhMlk5MEpTL0lCUGNKa24xWXlz?=
 =?utf-8?B?UTZndDgrUW5BVFI5c2VmT0pmN1VtSVJBVysvYWthZ1Yvbk9kMmN4YkNNUzdL?=
 =?utf-8?B?dTJBUVpPV1RYQVBOWCtRVXY0aHpNOGRWd3lZN3V2ckxmMVpMWmNoVXh5SWlp?=
 =?utf-8?B?QVErbzdLODE0c3dZZkt4dzg5TXpOeFhabnlINnFuT3lyVTlZcGt1RmhKRzRj?=
 =?utf-8?B?RVVlUytoUmQ5amlEQzZUdEV0ZGlaTmgyNlIzU212ZWd4RXEySkZweEZaeTNK?=
 =?utf-8?B?MkhPb0RMZGJhNnNqaXlUTS9LVkZJR3RMT3NQYmx1VFgwd09YREJ6MTg1UXJQ?=
 =?utf-8?B?Z3VBdm9HZlhKR2l3OGEyQmFmaXZyOGJwUU1XejJZSWh1MjJhaUx1Y0cyWDZs?=
 =?utf-8?B?aGVTaGMwZDIzZHEvc3NGYW9MYWNadmhOc0pxMnBPTTNjazR1UXpBZ0hMK3F3?=
 =?utf-8?B?T0srZFBIV2NjS1N2bkNrdTJWQ1R4NmNlbU95ZGlyNzdlWWVxTldpWVY2ajEy?=
 =?utf-8?Q?YsfuIpHXtwNOEg5VrDwpXl/A49l8FmA5tV4DhoS?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R2ViUzA1Z3pYVmw4cGNHTzNqc1VYWnRLTlVHVGg2NVhIMGpTUWtXQ3RWVXlu?=
 =?utf-8?B?YW03ZEFkZENmQUM3VTBadTlVbUhDNkVsaE5zak9NQktZdSszc3laRFlLejhY?=
 =?utf-8?B?bGVnR3JSOHNQWFloUXJhTEJKQ2FuaDFVeEVUc0g0a1B4YnVpQ1VKTVBRZmpP?=
 =?utf-8?B?TU5QOFNOM2Qxc2lIcGV0elAvcmhlcFpaTndtWitDN3lGNUVhcHJ3VkEzS0pj?=
 =?utf-8?B?NncyLytWbFR4cWRQZTZBQXRiUVhTYXE5bk1kY2JBZElqK3ZRRTFWRjlNUWly?=
 =?utf-8?B?TW5ublIwVnhCajk1a05JZVdvVjgrWXRSQ2RHeU96T2tLTzB1czNFTXVHOWg0?=
 =?utf-8?B?TnFXdUl6VThkN2xadHBjQUxqTzVrcDkvSGhXMUljK2x3cTlSeTlCakRyVXly?=
 =?utf-8?B?ODFxM09VeEhpMVgvMDZrL0ZOc0EzWGNCTFo0MVlZZFNSbm1tNXZ1QXdFZEhh?=
 =?utf-8?B?Q1NveGFyYkltQ3V6RzM1cVcrZXh0U0NUYjZRbExydHVJa0RjOVBnV2xmTkxi?=
 =?utf-8?B?ZmxNcXhwNnUzS1NPd0tkS2U0eFVCWWZCUTFsdlhQZU9wTnp1NTgrdFc4bnNr?=
 =?utf-8?B?Z2tWV1dvTUkySG50RVNTZXFvajFqV2xMVzlYOE9CMys0bzNRYXBtYmR1UjBx?=
 =?utf-8?B?cnZ6WFlqUVY2a2R5OThOK3A1cHBuUjhHQmt2YjlkaCtWKy9ZK0l3TG8zVzIw?=
 =?utf-8?B?VDcxd1NldGt2cW1rRFRScGxXN0FXTmVrakxFMGwyNjZ1SVB6L25XNzMwRFQx?=
 =?utf-8?B?dGJsZUtWNDlzcFJ5MytjdW9QN3B4ZlhWMjNzMmJ4QXhyb3JONXVFeFkvS2FO?=
 =?utf-8?B?SE5vN2NqbFozUFpNODRaUkVYOUZRS2JnM1pWNllPbFNlcjFxNU9xS2pJK1VC?=
 =?utf-8?B?QVNXZnA2bHFMbldSbkVYQUs3Mkg0RmNvRTh4Yy9hRXNwWm5ONGFhQjF5c2pO?=
 =?utf-8?B?ODRESlNtK1J2S05VRFdnZ0VJMzhVTzY2ZG1uM2d4dVM5cHpTNWZKdkIwN1Bs?=
 =?utf-8?B?bkd0bTlOWDhjQ3h1ekwvYVZKV2hiOUJkcnhOdkxrTUdEMHRCS3cycE1FWXdz?=
 =?utf-8?B?N0IvWlY4UHdlRWhicG1uQXdEM0RROElFV1kyZFpnR3VuUW5wVm9Md0JmWEhr?=
 =?utf-8?B?bXhuQXU1OCs2VEppajN1SnZHdkxmQ0hQdXFzaVdzdWd5Wi9iNEREVFZNaUtw?=
 =?utf-8?B?d2NPaS82WS9MQjVjeGtxaEYzUU5TZ3p0YUp3c0FIMnorN2hUNStSN2JxWFBv?=
 =?utf-8?B?LzFWRDZNbHdGdUpnUDFMdFlFUjhyL0ZaTjBGVWFEeWRDMHJQRU54c1cyTVNK?=
 =?utf-8?B?ZmsrN3BrY21PZVVQK0JFTGhuOUlMZDd6NFlhQ2hPWXhQOEtEVmh5NHFhSitN?=
 =?utf-8?B?WHpOMXViQ0ZoWUpndnIrMldnYTdkdURTam0wRUQ5bE84b0p5aWVVSVpXNmYx?=
 =?utf-8?B?OURJQ3VEVit0dFhYUUg0bzgrbXVZNTNYYURaL0lWMndQWW9XR1E5dlhVS2w2?=
 =?utf-8?B?VmRvL2l1a29nYkMyem9LcGFkbWNXU0N5VGJqQ3N1MzFLWTRGbU5FS1FnVWNz?=
 =?utf-8?B?UE95NU1KeC9TU3VEZkxVQ09xWjB4Tm1GM1Z1MFhvWmI2cTgxdnYxQTJ0a0hu?=
 =?utf-8?B?dWlBRTV0Wk41b1k0THgyYjBQZ2JvbEdBR0Vvc2pRSnREaUgxL2lFWXhTSTln?=
 =?utf-8?B?SmpXc2wwRHVscHh2ck04TmpKNXdQZUJnbHZhTlp0RFlSa0Z0SmlLWUtMbExC?=
 =?utf-8?B?Y1hpc0FYNkVILzAzQStwK1FuRW9SMXdBcmN0NzJMcTdzaUNrcjRFblRPczhR?=
 =?utf-8?B?R2dsOFpGVmhFNTVMN1dueUg1ZjJLVktlSmxZNFZVQWluYlV5S2tKQXBtUEY3?=
 =?utf-8?B?K1BhbGZZMm1DOVBCa2NMSVRYQ1hNV1RJSVIwYzJhTlloaFRTeUJyRU9sNnB6?=
 =?utf-8?B?aGJncDZVNnFnTldVcnVtUWhodEQvZkYwUXVUSzlBdUhRSU4zaW80OHdOalBN?=
 =?utf-8?B?Wkg5SjFUcFVnT3BnRFBveHVKa2xPSllIZkZMZDdyTHQxOW1rdFhyVmN6M3p2?=
 =?utf-8?B?M1hxbTRpbGxyekp5VmNDTUVwbkpjK2dUYm5XS1V2NThIekRudjdTaWJ2ckZO?=
 =?utf-8?Q?nG8SUjUc/+tqYivbS8DVi9qeQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 205c032c-9001-4fd3-acf4-08dcfd3cf1c1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 01:55:37.9110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jrMFZm45v6e3OtxVsnjPn5OXJ4HDq3T01ARmfVxqaXNGOc0StXGUMaZBiZEmQIdDcisAa8haVuOR6SY5nrepOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5104
X-OriginatorOrg: intel.com

On 2024/11/5 04:59, Alex Williamson wrote:
> On Mon,  4 Nov 2024 05:27:30 -0800
> Yi Liu <yi.l.liu@intel.com> wrote:
> 
>> This adds pasid_at|de]tach_ioas ops for attaching hwpt to pasid of a
>> device and the helpers for it. For now, only vfio-pci supports pasid
>> attach/detach.
>>
>> Signed-off-by: Kevin Tian <kevin.tian@intel.com>
>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>> ---
>>   drivers/vfio/iommufd.c      | 50 +++++++++++++++++++++++++++++++++++++
>>   drivers/vfio/pci/vfio_pci.c |  2 ++
>>   include/linux/vfio.h        | 11 ++++++++
>>   3 files changed, 63 insertions(+)
>>
>> diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
>> index 82eba6966fa5..2f5cb4f616ce 100644
>> --- a/drivers/vfio/iommufd.c
>> +++ b/drivers/vfio/iommufd.c
>> @@ -119,14 +119,22 @@ int vfio_iommufd_physical_bind(struct vfio_device *vdev,
>>   	if (IS_ERR(idev))
>>   		return PTR_ERR(idev);
>>   	vdev->iommufd_device = idev;
>> +	ida_init(&vdev->pasids);
>>   	return 0;
>>   }
>>   EXPORT_SYMBOL_GPL(vfio_iommufd_physical_bind);
>>   
>>   void vfio_iommufd_physical_unbind(struct vfio_device *vdev)
>>   {
>> +	int pasid;
>> +
>>   	lockdep_assert_held(&vdev->dev_set->lock);
>>   
>> +	while ((pasid = ida_find_first(&vdev->pasids)) >= 0) {
>> +		iommufd_device_pasid_detach(vdev->iommufd_device, pasid);
>> +		ida_free(&vdev->pasids, pasid);
>> +	}
>> +
>>   	if (vdev->iommufd_attached) {
>>   		iommufd_device_detach(vdev->iommufd_device);
>>   		vdev->iommufd_attached = false;
>> @@ -168,6 +176,48 @@ void vfio_iommufd_physical_detach_ioas(struct vfio_device *vdev)
>>   }
>>   EXPORT_SYMBOL_GPL(vfio_iommufd_physical_detach_ioas);
>>   
>> +int vfio_iommufd_physical_pasid_attach_ioas(struct vfio_device *vdev,
>> +					    u32 pasid, u32 *pt_id)
>> +{
>> +	int rc;
>> +
>> +	lockdep_assert_held(&vdev->dev_set->lock);
>> +
>> +	if (WARN_ON(!vdev->iommufd_device))
>> +		return -EINVAL;
>> +
>> +	if (ida_exists(&vdev->pasids, pasid))
>> +		return iommufd_device_pasid_replace(vdev->iommufd_device,
>> +						    pasid, pt_id);
>> +
>> +	rc = ida_alloc_range(&vdev->pasids, pasid, pasid, GFP_KERNEL);
>> +	if (rc < 0)
>> +		return rc;
>> +
>> +	rc = iommufd_device_pasid_attach(vdev->iommufd_device, pasid, pt_id);
>> +	if (rc)
>> +		ida_free(&vdev->pasids, pasid);
>> +
>> +	return 0;
> 
> I think you meant to return rc here.  Thanks,

you are absolutely right. :)

-- 
Regards,
Yi Liu

