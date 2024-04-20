Return-Path: <kvm+bounces-15411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D7108AB9E0
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 07:42:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 313DD1C2096E
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 05:42:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 947A4FC0A;
	Sat, 20 Apr 2024 05:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iJELWLkB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0837A205E26
	for <kvm@vger.kernel.org>; Sat, 20 Apr 2024 05:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713591751; cv=fail; b=bsgD4YU5UgoT+R/l0kj6pDv0ilbjmvIGgAU2G1q9QtsIv7jo8GH8nDXI8gQCPzd126tASsRKi/3/2Mfu7Hhg2TutJMnKR3QdcIEu//gBajuqh18ZAI70/rMnfFEqeiEx3syTJ67h/JYENPuyWR0UFpS3owittePkwr7pMO1r1Z4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713591751; c=relaxed/simple;
	bh=JU8p6aFNQEF2Yh9erxxyd0etFd7PBahSHHbXi0hnIPc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sA2omdPz4UzkXT7FpGaIU3xWvbaX1ULSl9ZgdweSEbNjkEaV47+AXT7dhdPywB/D+dg2074TaN+/hMHIP1l53BSwtaBfbATt/K90EBAK2ICD55KkR7/WXojeNuM3cZR37tVE2l/IeVbPvBszvGsbp2lzLAhXDL169qqDQpd6vFw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iJELWLkB; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713591750; x=1745127750;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JU8p6aFNQEF2Yh9erxxyd0etFd7PBahSHHbXi0hnIPc=;
  b=iJELWLkB0mYWVaJ9RPBC61KwZSsH6L/8NGW/ugvKtB5W38GlycWUDqED
   qIjkBMb60bVA7XJx1YfqsyK/lnMEi3WvG8QNLwlGRTr+42+omKz6gCnwr
   0f5wuGS4v5C0Io+MBf22BQiBoRJm1skYJGBVrxZoOh9T+DklaiBx4j1bR
   EcivOv8Fh9qSh9vlzKFxcPFTxwZXR73o7FHbzYbPKs6IMU9/JHKBgsROk
   oHQaBIdYjEhUYEbNyQntj68/AOVMtpAyI3QWtQuTFAhQQAcEwkxqvtkgO
   i5Fgn9UCnzqTPXZBgUAcFyQud6M+ddoqg70On0Ajf+pbVnJbs1O/mVcBe
   Q==;
X-CSE-ConnectionGUID: MFieeNk4RAi6UMVl7win7A==
X-CSE-MsgGUID: qqAOyfRTSsyzP8TdtQfrpQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11049"; a="13044305"
X-IronPort-AV: E=Sophos;i="6.07,215,1708416000"; 
   d="scan'208";a="13044305"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 22:42:29 -0700
X-CSE-ConnectionGUID: mrrjQzbURraJKpXzLltovw==
X-CSE-MsgGUID: qGUI79VqTwW1rWqIM+2jRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,215,1708416000"; 
   d="scan'208";a="23586891"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Apr 2024 22:42:29 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 19 Apr 2024 22:42:27 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 19 Apr 2024 22:42:27 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 19 Apr 2024 22:42:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TNbSBnfHxGr0eawCfVemwhyIb1BWcuGFJLL6zEKRxl6agmeYLoFYGCX7JX2aFeBAxufaCpqzvS5Rd7bsq+C2/swqQeZ9oD92PGc/CqVD005meBAdOOTGaRZG4ShPkOSEKTe6Wqp72HaSLqerTnQs5iS9AEy0pooG3xK85bfqaPviIUrYRjyw+fMPmhtBFlz5drEu34w2RaJ0yQmboJXLgFR5sVDP+5fVL/V+IEEwh3wAIPuNV45uykp67fbe+tOq7XS0zuYAqnfn58nrvyxkwBch2XGl44d/v55FBLeGiFQf5ELGy7EVuxZ3zB3iar4znEHx44ynLQYt/2nEt+Q7mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HAW0ZMxP9p54P5J7CwwdO1ij0lylGmVCuAzX80oL8I4=;
 b=PMsRF0RbYIzpDdogRaw85rG4NN8fTrShlmgX1p4jjrykMiReD7BRuGZdnjL45WGXmYNV1Zzo0W7alcgNqQEUBiBJ74p54M+Bhy80/pjqmag1VVsKSCNtRbLohpUe3m4svc0SQWCwiy/hH891rU9VcdoISyrVRnDEocdzyFwRvWF5OFTgn19rqRp0t95Q7CgVvC7h6FjC9mVgnKZJgi84PrDoa2sz4C3mcF9EZzpwAH8e+n/ZHOws1i/yAwWRQigWSAsxPom54DLmBCeqLC2cXHInM9bqnVMYugGeKzbafScncH5bBAnIg3LMiOiuw4E6NwknsciBwf/6tPU5TppETg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH3PR11MB8591.namprd11.prod.outlook.com (2603:10b6:610:1af::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.16; Sat, 20 Apr
 2024 05:42:26 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%7]) with mapi id 15.20.7519.010; Sat, 20 Apr 2024
 05:42:25 +0000
Message-ID: <fa27cf95-1be0-4d98-be72-8892f9cc003b@intel.com>
Date: Sat, 20 Apr 2024 13:45:57 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/12] iommu: Allow iommu driver to populate the
 max_pasids
Content-Language: en-US
To: "Tian, Kevin" <kevin.tian@intel.com>, Baolu Lu <baolu.lu@linux.intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>, "Pan,
 Jacob jun" <jacob.jun.pan@intel.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-6-yi.l.liu@intel.com>
 <ef76c9bc-cafb-43a8-9b1c-f832043b8330@linux.intel.com>
 <BN9PR11MB52766AFD83D662181A4AE09E8C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB52766AFD83D662181A4AE09E8C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:4:194::23) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CH3PR11MB8591:EE_
X-MS-Office365-Filtering-Correlation-Id: 9eda3dec-9be4-4ed9-66af-08dc60fca85b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005|7416005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TGQvUllhc0JFQzhaOVZqN3V3cTZTamd6VXRmV2F3VkNvSUNSWlFxYnY2VVVy?=
 =?utf-8?B?RDdVZmlHb1h3OEhjaEprajg4aHhYOFo2OG9rSzJKWHZTUjI0R2sxTjN0Mmdj?=
 =?utf-8?B?QWFGSllsdmZ0L0duTXQyZml3N3JRaENCUS9scDJldllDQUEzY21kU2VwcGZP?=
 =?utf-8?B?dmF6b09NVTgvV1pkM1JRaUtsenVuUWlyMHpTQ29jZElTbWxGdjNpamJkWkZT?=
 =?utf-8?B?TVN1MGNnQzRWM1F1bEhUWWlHSkVUQi9jS3ZUQTBRbDY3bXlVTlh1UG53VE5l?=
 =?utf-8?B?Skc4cnlrQ2IybkJxMUJlWXdPZFVYTno5K2hRMTltR3pudU81SVYwdnJqYWdl?=
 =?utf-8?B?emMzejlkNW9DWGlwemYyWFlTWG5CMnBhZXU1b0lPNDlRL0VPQ2JtNU9QU255?=
 =?utf-8?B?SHhESWRnOTd6N0JWQldrblU4cmlleG1nYVM3QXpUZUZ6a0tCYVRvYnNPOWdz?=
 =?utf-8?B?QWl6dEUyVTd5eFdFVlNhSGZDb3ZZSjhGT0Qzejg5VEFNL3lTK2ZuTjY5aGxn?=
 =?utf-8?B?VG45YlpRdUp2VEdMSkFHc1d4TXRGbkVMREpCWHdIMjUyZFI2RS93YVNORVhk?=
 =?utf-8?B?YXFRck1xSEFQV0tJNkhTcUpBcFZxQWJjbzIraGN2SWRHYjBoQy9ncUNjZThM?=
 =?utf-8?B?bzFUUndtMFlhd0NXQVNYVjVUNDdUTUZBemtDRFgwaFBuNWJZZG9YR1Z0ZjZa?=
 =?utf-8?B?V0I5RExkYVk1alBNd0R5aDVqNlRiSE4zbTNXS3VxaFJ4S2I1Z2t2TG1Ub2Y4?=
 =?utf-8?B?S0RZSmgyVVc1T0lldnRLK29UZ2pYN3lZWHgydnVheU13Ti81ckRCYy95YVVL?=
 =?utf-8?B?VHEzVlRJYUtGZHBzUkQ1UXlVSWh6MzlLZkxHbzRMblhNYnFFRFpNb0JBaThJ?=
 =?utf-8?B?VEdUTlRWbzcySFQ3WnozTXhIM1hsTTZhbmEyRVBJeDBCZDlPdXBVamxFRDg0?=
 =?utf-8?B?REYzcG55cDRhdzJiVlUwbWlIVnlvNlhZU0FCSkZJQ2NFTGFpQzhRMjN1VEdt?=
 =?utf-8?B?YUtMQlhLYkJYRWVYNzRHcGJTdW5STVpxTHNmWExYYjNCZmIwSlUyTi9DYWVo?=
 =?utf-8?B?cUdQVWNHMVR0VU4ybmNLYk9BNzZHcUpoSDV1SXpGMUs5c1UxZUdYa2VyL1g5?=
 =?utf-8?B?YVA5VmdBTytrbms2cVkyaWhKUy90WW5ucmJ0REw3ZytMSkovSTJaQXJSZHZw?=
 =?utf-8?B?SjVWOVV5MFA1emtLcnA5RkhKMDdBbVVGSnlzUi90YlFDaTVIalFPcGpFOUpT?=
 =?utf-8?B?N0EwZzdiRmtrRzYzV0pkZmh1Z0Z2RjJjUHVmeitITHczMXRLL29MSHNZQ1Zw?=
 =?utf-8?B?YTJhRndGbG1uM2dOM0UzblhyQSt1TjQrZTRWUTkxcjNsOUtDRUE3L1VDVDFC?=
 =?utf-8?B?VFlwdmp2SmdHcnJEZ2NUQ1oyQTlWeGE1ZjFVemNEMFA3REoxRW52dUp6NkR0?=
 =?utf-8?B?V3BsZmpMMHRYazFZdXRxY0RlQnMxZloxU0ZUTDdXeThodld1OE1JbWxIUldC?=
 =?utf-8?B?MXp4T24yUHdTMEFsTHptL1pWb2RiaEdMMnFoYTNuM3ZNSDdkMlVDVE9HbzNX?=
 =?utf-8?B?K1laYVVFdHROTm0zMVl4RzFyMWthM2c3TWdGbGhQeUppY0llQlhWZG4rL0xz?=
 =?utf-8?B?MnV5UXBPNHZBU2NYN08yc3BrM3RScVFkbGJDbE1OM1NCa2J2QWxVT2k1VCtn?=
 =?utf-8?B?VHVwVkl6dUtZTDI1V1I2V1hqRGxiNUNYR1YxdXhjcDBYSHFhNmQxaVBBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzlxeXZZY0t6anV5WlJ2dHUzK1V4RUFzTEI5SWk1clNiZllCbHJabmwrVTV3?=
 =?utf-8?B?OXh5VWl2Ym1XZE84c3RUS1lsZkVaKyswWExWYlE2VU5xL1RmSTZoaXBXMW1P?=
 =?utf-8?B?ZU5uaExOR3VML2w0bTU1S3BCL3ZvTWhubDMrR1JMU3VVWGU4UUhRd3Nib1VQ?=
 =?utf-8?B?eG5ybG05d1FtaG40ZnhJNXFOaVVPelVsdW85M0RlUGxhSWd6S1JlVXZ5K3Bq?=
 =?utf-8?B?WlJPR3dUdUJzcGwrTXR0UVV0RCtjNm1hcFRUdEdZcEJCZXU0K2RWb3A4cXJB?=
 =?utf-8?B?K2sxYWFhbnB4RmFrOVVlRWVTWHJmSjltTEkyaXdtZ0pjZS9MZHBHZmVwM2hY?=
 =?utf-8?B?UG01L202dWZuU3huakphdnRLYUlmbkV6a1QzRGRiQTBQZVI5WnNXU29OUUtM?=
 =?utf-8?B?OTY5MUFrbkI4YzFhbmEzYi9VVE1EWDdVZTdqZGorZmFaeW00d3JURzQrM3g1?=
 =?utf-8?B?ZFhNUDlsQVI1ZUVhUlFabm5zdTJyMno3NlJzVVBsMVBKQjlzTjMwSDRvL1k2?=
 =?utf-8?B?S0IxRzFFTVRxdWxTdGtRZlN6RjM1dlZySFJrTlNXVVAzZWZTRlYzVXN1UTFL?=
 =?utf-8?B?ei9OUzZPeG8rMHk2MVhRNVFGdlIreGl5SC9SL3cwOW05cEhqUHBXZEM1TDZm?=
 =?utf-8?B?eFU5dGw0VDA4WXR4eUZXbVVNVXkwMVpoNW1DWW41dDJLRk9rSS9abEhra21W?=
 =?utf-8?B?dW5YbFFCdmtiNGY3cW4vQ1FodGZwbHJSY2tCQ0ZoYUJoZ0daZXdkR3RGbXBr?=
 =?utf-8?B?S3BtVTVwM1M2YWJtS3BzcDlPclYvcWNjY2tPaXhhTUg0Sk5rYXBRcEhKa0o4?=
 =?utf-8?B?b21xQTROM0lKVHM0dW80dTJoNzFQa1BScEl0Mk5kQjlFUWszc210WERySWFI?=
 =?utf-8?B?RTA5eE9IMmZJbkRENVh1NWVGL0tUcUk4SGFmNWZXM1F6K3hYeGtpVW1WenNo?=
 =?utf-8?B?a0UyYXpuV0xuZ3hNSEQyUTNraE1RY2tGeGNIV2dDd1NZVkc0aU8xNm8yY2Jl?=
 =?utf-8?B?enVWelJVcThKZ1FEUGpPUlpUNTJjTm5qUWl4LzZQSms3M2NZd1hCaVBqcUo1?=
 =?utf-8?B?VExzdUpGMFVGZVNxdmg2aEJXRnBvV3NFTWk1UmpkTkk3MHhKTkhZRTJKMzhU?=
 =?utf-8?B?Y2t3WmxpOXU4RXIvbENHTzhERnpCYkxMTnhjemFoVzN3WFV3eWZqVUlhSVRu?=
 =?utf-8?B?UWJUbXZuZS9hZ0dwb0hhbVA1M3ZQTUphRWRuaktNQ3dCSVp6SHFQSEVWYTBI?=
 =?utf-8?B?N1dONllOdXh4cDMzWWY3SWRoVXdPdC9vbHg0am12WFVBYml3L2NhaTI1Zm9o?=
 =?utf-8?B?UElFY2JZVSt4QWUwSXlESXhoZnBBbEllR05WbmZaNXIrV2JTZzNNd0xkL281?=
 =?utf-8?B?UENaN3ZyNzdDczNEREFaNncxeWEvQjk0bWhsTWs2RWR2eDJLdThYSHhobWVa?=
 =?utf-8?B?ZVRJT2lXYXNCRm02Qmkxd1J2QlVBNVV0eFZabFN4OEU5VjZBVXF1VkkwSnE5?=
 =?utf-8?B?WTlpMWI1KzdJVGNkZGs2aU5ENlR6VmNsVER6VWg4ZHNvUjFERW9YeGFXRWtS?=
 =?utf-8?B?S2U4OEdVTkNoT25CZjY2dHV4VGFDMWthQ3hNYVlQOGc1MTcrcTBKd0NsWVY1?=
 =?utf-8?B?UTVTcUtiT0N0b25GdG9KTnBIVGZZcDdzVERCMUxqb3NtRE9EcVNFNUFoZ2g4?=
 =?utf-8?B?YWpaMDg5bCtRWGJGbG9YSVlucm9MYXY1cGRHdFZmZHh0cGdEdUNyUzBYODlV?=
 =?utf-8?B?QlNGdVdrUWI2N1U5NDdYZVlwSUluWmt5N2lIME5aV0NhSUg2YTFZS3ljYlpk?=
 =?utf-8?B?TXlETHZRRnRPSWVidklEMGp6RmhjdGFvRGpUYWNqS293eHRQdXlqR0dVakRv?=
 =?utf-8?B?bUxxdFNDblp2eVJ5eVhsN0hLSEdIWkVwZ2ZNdzFERFFSWm4zUVFLZmRldTJD?=
 =?utf-8?B?WnM0WStVREpWSGlia1FCU3RDazFSYVU0R3VLV3ZyUzVWN3p6WGw4QWlKcXRK?=
 =?utf-8?B?MWE4cDU2ZURqL2UrMXZNZXpVR3hya0cydmM1RUQ5TTZxZXpWM0VZTDZjQmor?=
 =?utf-8?B?RWM2QkNtUFIvY0tWejd2a3V4ZXBxUUNuSW5zbHp6bmdzK3Vkakh1WTluTmc2?=
 =?utf-8?Q?mnJ2uIJEB0L6tUKDi9x7ShVPC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eda3dec-9be4-4ed9-66af-08dc60fca85b
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2024 05:42:25.7400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q65xfHfkyMVC+nX/GLY9bWici6UKBcg/Rkd5MiZkCtV5NwL6Bq/5Pn2q2SHHrL0gon8N1u0tOlRFfDpxwWNYWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8591
X-OriginatorOrg: intel.com

On 2024/4/17 16:49, Tian, Kevin wrote:
>> From: Baolu Lu <baolu.lu@linux.intel.com>
>> Sent: Monday, April 15, 2024 1:42 PM
>>
>> On 4/12/24 4:15 PM, Yi Liu wrote:
>>> Today, the iommu layer gets the max_pasids by pci_max_pasids() or
>> reading
>>> the "pasid-num-bits" property. This requires the non-PCI devices to have a
>>> "pasid-num-bits" property. Like the mock device used in iommufd selftest,
>>> otherwise the max_pasids check would fail in iommu layer.
>>>
>>> While there is an alternative, the iommu layer can allow the iommu driver
>>> to set the max_pasids in its probe_device() callback and populate it. This
>>> is simpler and has no impact on the existing cases.
>>>
>>> Suggested-by: Jason Gunthorpe<jgg@nvidia.com>
>>> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
>>> ---
>>>    drivers/iommu/iommu.c | 9 +++++----
>>>    1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> The code does not appear to match the commit message here.
>>
>> The code in change is a refactoring by folding the max_pasid assignment
>> into its helper. However, the commit message suggests a desire to expose
>> some kind of kAPI for device drivers.
>>
> 
> it's not about exposing a new kAPI. Instead it allows the driver to
> manually set dev->iommu->max_pasids before calling
> iommu_init_device(). kind of another contract to convey the
> max pasid.
> 
> But as how you are confused, I prefer to defining a "pasid-num-bits"
> property in the mock driver. It's easier to understand.

@Jason, how about your thought? :) Adding a "pasid-num-bits" may be
more straightforward.

-- 
Regards,
Yi Liu

