Return-Path: <kvm+bounces-17002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 806E98BFEA3
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 15:23:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B9E51F236F8
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 13:23:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFE9575803;
	Wed,  8 May 2024 13:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V+0OEmZw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8787754FA3
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 13:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715174603; cv=fail; b=LTTCmLwFyneCIbva1e561A9IgmyCftd0SgDSqtlADZKRWNgdwYs5c+vcMYsZJNUURu5NNVHRfsgJekh8fZRlzJAarzNdmXcPZV83k30DgELf5vEnhFk7fi1dZ6VwX6cuDnG6lnqd8mOi7RtBfNt/6kIwASVl/2OIB4q4Ra/4hpk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715174603; c=relaxed/simple;
	bh=yTOpQXb4yEMsnAPKGi2qIJ6IPRRGcenA8AeIBPy6fkY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BcDi6xEoQPjqBVKiYybAU19Nw2QRs/+jzEuJxgFE3UoayqpBBGW5GdfC04/dU2zbOa1ZkRnAxG3CjsczuDMfuC+6G1UnMVa3eUNfkKG4BZ6s/gDTvnMGbSSCDAglRUgBekQ8tWgdjqTU1XghXPtZq0Q8LRZ0Wi8R/cZHxYiCnAc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V+0OEmZw; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715174601; x=1746710601;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yTOpQXb4yEMsnAPKGi2qIJ6IPRRGcenA8AeIBPy6fkY=;
  b=V+0OEmZwmJfyw64BL5KfPBhUDjeDIZIdOzRELS/pHIikD/0CiDhqLwlA
   uO81pAvGIMWky4+wNcsUEb6zu+NsXwseqW8JoqxB/OZIfsTLbaeTbVyLb
   Rip4mrkuvA2/p6UTqyJobt7dKCjaBFopcEEV1oIGfHfetIIJel8fwptUt
   tPbYxX/hlGYoDgFfiNgMS9IgR0uNDS1a8LNDqIVIH4xQSmTivmMRLWoym
   hXnMHRwFzYVXwUZXuF6w2EH6AfOryUR9FQfJNJEoTB43zQvvR1IZ/NzXh
   sL2j+PILe6s04S24fL2X+gAue5LJzpzUcuLZOPw2ly7ngOtoJR8RwDszA
   w==;
X-CSE-ConnectionGUID: 2mvOk3uFQ42BpsUaEWHunQ==
X-CSE-MsgGUID: T5nLDrxuQPWieA+eBuRkkQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="10902609"
X-IronPort-AV: E=Sophos;i="6.08,145,1712646000"; 
   d="scan'208";a="10902609"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 06:23:21 -0700
X-CSE-ConnectionGUID: zHyolC9xSHKC2iD3fyK5yQ==
X-CSE-MsgGUID: TcTqcOlnTYyDaydOy8SwWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,145,1712646000"; 
   d="scan'208";a="28851879"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 May 2024 06:23:20 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 8 May 2024 06:23:20 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 8 May 2024 06:23:19 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 8 May 2024 06:23:19 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 8 May 2024 06:23:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=egC2ylITI0GBKMwH2QnN9GBPtirzYdFxnxyKRbpixWFKhhN9huU5So7mOKiHsJl3ap88oZiwGA3hPzDgx6ZQoU2Qpl+OAsu/ZtOeTY3FwVR7GlrJ0vfhe76b2XlrVSON5BfWSqn8xWC6C9iVhvHlwBNQaG9ezkCfQMz8LmHBx5iKMVijmkRImwDMm3Zqw6ggRRdyXWXOnKKeO0yhWT5Q9kyYycQujdCFrWJWs7RN0DK3CVYRX0NveriNRF/aufqS8Npl6N6vguRT7BI4p+T2QdWw5jydujLJssT2ypc9YgvzKMhEWxAn0FzKxcaMFO4vQ3VyBtK1nnIqo3SC8Ob/wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H1MFNfNRtKmL+6RabsKnp0euFwG+4huF+huBUDBERYo=;
 b=AtYtvFAVhirjE1J2p33PYBe/pW94JZ7C/BS1MRr+9nm82bHrkldCCWukwMNC2H1fpNsxKKK5KA2DZN+L37IYYYUDT++09xs0Cwyfknj401ctlY9yLhQNu/AbrPgOsgtIAgYwb+u0v63w9Es/kfUE2sau3509ekPlIL4rersg6lKXVU7opWtKruqMImhnH3clGLBKk5ID1mgWw34omnuPR2gVaA2GnEF5a/GvB90tDwwc0VTQPWj0L/8H32Vnr2pkakyRtIoLAmETvzBmEkxSLkco61lFAnLQORGydFGZ/yw0SFpEtQTlWBI1L/qCfyxHUXPfK8dLK+g4DJngXGc9FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB7530.namprd11.prod.outlook.com (2603:10b6:8:146::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Wed, 8 May
 2024 13:23:16 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%7]) with mapi id 15.20.7544.041; Wed, 8 May 2024
 13:23:14 +0000
Message-ID: <5efdd36d-2759-4f71-92f6-4b639fc9dbc8@intel.com>
Date: Wed, 8 May 2024 21:26:47 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/12] iommu/vt-d: Add set_dev_pasid callback for
 nested domain
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Baolu Lu <baolu.lu@linux.intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Pan, Jacob jun" <jacob.jun.pan@intel.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-13-yi.l.liu@intel.com>
 <BN9PR11MB5276E97AECE1A58D9714B0C38C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d466eb97-8c2b-4262-8213-b6a9987f59ea@intel.com>
 <b4fe7b7c-d988-4c71-a34c-6e3806327b27@linux.intel.com>
 <20240506133635.GJ3341011@nvidia.com>
 <14a7b83e-0e5b-4518-a5d5-5f4d48aa6f2b@intel.com>
 <20240507151847.GQ3341011@nvidia.com>
 <07e0547d-1ece-4848-8e59-393013b75da8@intel.com>
 <20240508122556.GF4650@nvidia.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240508122556.GF4650@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0020.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::6) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DS0PR11MB7530:EE_
X-MS-Office365-Filtering-Correlation-Id: 39dbfbfd-7bca-4abc-9d4d-08dc6f6203bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|7416005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?R2JvOWYvcXpGcUtmMDNsdHJVYlhEOUZFa1VkdkRqZEdMTlV4QVlXMVVRSE5q?=
 =?utf-8?B?eFFLMy94L0ozb1dNZyt5TDBUeFZWdk5TdUJSWEVKcVQwSHFjSWZnSXFmV096?=
 =?utf-8?B?dEJZQ001eTJhaUR6NWhld3dCVHk4OWdVWjRQQWsrUEpjbGo1K1FzTnhDY0w1?=
 =?utf-8?B?TkI1NmZzV1NMS2pORHBXcVFYMmY3OFJNUm9ScFUzNDZsdHJ1TkFmMy9uT3Ar?=
 =?utf-8?B?aVBMcjArZkdGTU5JVzBTMDFBVmJoVkk0UEtNZ2VuTjFtS3VMWXNlQlQ5MktU?=
 =?utf-8?B?SE1NZlpST3VNbThHM3Bzd01lUnJHb1Z1d3BDNm9EWmpZK2x2ek1VaXozUUVj?=
 =?utf-8?B?UlB2dDBnd0VKWU9ndzltaFBwbTJ0cGpxTU5kNkl3Q1kvckFjWDFuNDlITU4v?=
 =?utf-8?B?RVErV0hINDF1VHpab3RRaVVXbnc1OFVubnA5aGVKek9kZVFqT1ZSY2R3bXl1?=
 =?utf-8?B?MWp5K2F4Y3hPK1dFb2M1NllIZnUzVC9ldkRnd1d1ZGYwM2xHMGZIZXBKVkpV?=
 =?utf-8?B?amN6Smw2UkxRYllpZUVJOVhhZUZnMktaTXJuWjd2RHVGTC9MeGJBTmtmeTll?=
 =?utf-8?B?U0NWZWdDanRhL0ExOURqZ0hITldraXk5M3FKemZldTI4SFVhOHpaY0ZwS09O?=
 =?utf-8?B?aHY2Nkt1R0xBK0tTOHpJWm9kb1doTDA5ekI2L0s0UDhtKzQ5a3Y3Y2UrNWZR?=
 =?utf-8?B?WmNJR3MwQWtLaGE2UGtRMEZwK3JUS21zU0syb1A0UGo2TkZnQTBITUVNZVg2?=
 =?utf-8?B?ZmIxTGFTa3hzZjRyKzl2UzZORERRbFR6VkM5Vk5hdG9ReXBoek1kcXVrU214?=
 =?utf-8?B?SFFSL3lQenlGQzE2a1hTcmc3WDlqNC85VEFqUVA0UlA3dURtb3dsaUlQMDZF?=
 =?utf-8?B?bk54SXBRU3Roci9CNjJzMDJMVysxWGRXVUxQY2p0dGExVmp4dS85aWFKZXA2?=
 =?utf-8?B?emxrMG9VSlpnTkpnSzYyVHNCd3h3d2NlWkdMZHRHVU9ydUpZNk9zTDh2cjNU?=
 =?utf-8?B?MEFKdVJUcjlYcGNadEtsYzFpd08xdEVEbG8yb05EVnp6dmIvR1BvdXhOaG0w?=
 =?utf-8?B?Y3FTVG5PVjk0SzhUWjE3SEMzemNkVVNJSFQySmJMR2o0aU9uS3FaYTF6WnpG?=
 =?utf-8?B?MVA5cHNld1dkTTIxU3VNWTNOV3phNHI0ZjFvdnM2c3hiTzdvK1luL0JGTXc3?=
 =?utf-8?B?czB4cEJvcFM0bjJpS3AvUzZiZk5MNlgzTTdzaHJvcHQyU25XclpvVnF1Tyti?=
 =?utf-8?B?STE2MVNZY05JanM3cVNUaklFL1NwUUZjVGl4dm5VdjVPVE9nWS9TcWVWYi95?=
 =?utf-8?B?NEFHbWVVL2ozRVpzM0tFMTNBd0svZitPaGV0KzNLVllWdUMxZ2VzRm9IK0d1?=
 =?utf-8?B?M0orelptZ09jY3NWdTBZTkk0L2NZR055SFFGMHlBbU1VSHVuVEMwTzJoKy9C?=
 =?utf-8?B?Y0FoeHh3UDI1aCtWaDExYXlXTHZ5anhxSVNwcUl2SzVaUlhNaXByVE1qd1F6?=
 =?utf-8?B?SGUyZ1JUWnRLckZ4RDBETkF6VDA3T21EMHFwZmtXY1JSV0lXY243MzVrMDB2?=
 =?utf-8?B?Vk5FeFNnME01MTNjR1dBd2FSZnB1NjVLU0hYVG5BSVlqVzl5YzcrN05QUy9V?=
 =?utf-8?B?WnVNbmVQcEpFQUN4ZHlCOWRPaHRGOWxERHF6REYzODJlR0FZYkk2dEpJWnA0?=
 =?utf-8?B?bjg1aFVWaG81SXF3TFBUL0doZGVhM3p1YVRnOXlpYVVEYlVDbkJwOVpBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WU53MjF5QTV6MUJUeGppUElhbHJXY01tZjlVNEhYWE9zOVNHNGxCV2dudC80?=
 =?utf-8?B?c2hZK2pzWGhBNUl1SmxUdHBZUWJCNlNmemFWdjk4M3J2ZFh3OHlVcFhHeGtj?=
 =?utf-8?B?ay92Nmdrc25xVno5cjZHenVOV0U5NXMwWEhqMzd2dFcyc1hBOXYzVStPQ05j?=
 =?utf-8?B?WEJOQW1zYTVneEsyRWdIWEhiZWppWnNudGZrZFdqYWU3cUtVWk9GTzgrSkVH?=
 =?utf-8?B?bC9qSHcrUnZyK2JKZHFuYVRBc3BQT1ZtdGJoN1dWNlJENzl4amxjdEdnUEZn?=
 =?utf-8?B?NUh6WGVYeXZ2TjB1dzVublpUWm91TjlVUHpaUEpuTms4STd3Y1MydkpZT0xR?=
 =?utf-8?B?Z3NaRUFOaS9rdHlHWjNzcW1pbmxlTXlYT214Tm5kZ0RET3U5dCt1d2UrSTRD?=
 =?utf-8?B?S1NTOW1acTVrZU01RTMzMTJvcUZNcWxFamtGalUxYVNjSERNQ1FicEx3NHdK?=
 =?utf-8?B?M2ljSmlBVmd2WDhrTTdza25TSXhKNXRibE9wZjBUeVJjM3MvTTJobGExSW9y?=
 =?utf-8?B?cC9wa2ZBdWZONjZaQjJUb0Yvei9GL1hkMkRxdHVqK3IrRHF1RzIvU2JEUjB3?=
 =?utf-8?B?QmdKRWZ1UTd0bjZSblVTMFJLVmcyWk5ycWtWV2IzMjdVRXZwTDFEK2lNT0lv?=
 =?utf-8?B?cGVKYzcwMUJJNHBQWlBEOERZMzBQNFd5NTV3d1hYMzVlOTI5V2tYM1h0TzBC?=
 =?utf-8?B?dk5FY04xU0NUT2FWM0szc1piSkg2QWMvWmJiMFUvNFREUW9RM1hEUHMyRGpU?=
 =?utf-8?B?aDVqSUVNeVJzRDdHQ1QzZ1BFN0VaaDRHaS91djU0c0JlRG5SaGNsRjhqQTV2?=
 =?utf-8?B?T2RlR3VYZTVyTU9LZFB4a2hkZnQ1alEwMVhSekFkQjBHeDRMZ0F3eStoWmk3?=
 =?utf-8?B?Z1FDQWhyck00dWhvekhHZWp1VlB3ZU9HMmRwMFE1OTdkMVUrakpaNG1vaG9R?=
 =?utf-8?B?RGxpVWlwRlJXeUxWNkJwVVo1TWNTRWpUTTNndjV6dllUVlBIRlZxa0w1MWJW?=
 =?utf-8?B?Zk5rQmVHbC95ZXZKOUdkNzcybmVsYTNwQTNpMStKQmpOOXUvbDR0Y2RvNnNj?=
 =?utf-8?B?NlJ4NUduaUdGSXF0c3plZ1ZQMm1mcVVoOVkrWlFDUUFCSHVTakFUMEYvY055?=
 =?utf-8?B?S1pWUTNtUitIN0NhdTNuc3VEaEdYRzNpMWFjSm5LWkN2dk5sSjVYTXdBK3JD?=
 =?utf-8?B?bUNTSXhOSmlvSmR0dTNnZDBFYnZyZ1pYL2RTYTZFQzVIY1ArWEw2Mkp2Q1oy?=
 =?utf-8?B?MFl1VVVyR0FpUk00L0t0dFVBamZtWkVSY05naFFKU0hmWnhUQXMrbXo0ZTNa?=
 =?utf-8?B?L2t3ZFVTZ09yVy84dFBid2dBdi82elJSaW90eE92MXpiM0VJSU5lajkzM1VE?=
 =?utf-8?B?WWdjUXVIWHpranppaU1La1BueFR2cjc5ZlVnUDViMDY5bUVkQTRIaENCK3k4?=
 =?utf-8?B?TDlSS1ZaZ21jV2EvTnFIZ2J1NTZWeGdnOUhlUkdtS1VTWndXY2FsaUIrYUN2?=
 =?utf-8?B?cTUxdzZWcG54Zythb2oxcWhGRFp1SDJVbjF4c0tDK1AzZHpyNnUwMWd6Ri8x?=
 =?utf-8?B?UGVJM2drOTJBVXVaSU1MbGU4N201SjMwcDFwSDBGK3NDWVYvMkFKRGUvQVJ4?=
 =?utf-8?B?SXkvcW5TY0ZOVEJjdmorNlR0Tnk0MEV3QkdlNVZ0bHJDVFp2NE95aVBYYmll?=
 =?utf-8?B?ZlhmdFlDYVdnMkZmeVlOVEtpRXUzaDJEWjZvU3JXaE9NaThnTHB6dlo0SGVh?=
 =?utf-8?B?NVkrSWlHRFo0d05LWlM1bTN6VnFZbUJxUWt6WHhrSmYvT1ROZ2w1aTR4Ukla?=
 =?utf-8?B?L21MRm40ZTdoV3lveWIvTTJtVlR5ckdnclR2dFZ5dUthNUVUaThkSjlKUnlv?=
 =?utf-8?B?a2pBSTgvRTNKR3Z5S2VjUm1oYkhSeG9DWCtCMldiM3FkZU9sazIrUUpvRFNq?=
 =?utf-8?B?aDEvSFh3NHFrZzc0QnZYaHdOaDdoeEtBUDBtN2pkNWF2ZWk3NWRpZVFuSGJh?=
 =?utf-8?B?cVRkVmZaeGFTbjRKVXQ0M2Vqb1QzYXhGR3E2TEpyNmpvWk9kSmZmaUZqMllW?=
 =?utf-8?B?QTcrcGlJOXJSbUpFOHhqaFdYdzFsLzhtalJjL0lBcnVhMU1PTzBhbHBHb2NF?=
 =?utf-8?Q?v6lJO4uaSfSEnKnOj6DETJ+mK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 39dbfbfd-7bca-4abc-9d4d-08dc6f6203bc
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 13:23:14.3366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uFukYYvFyCKznOZFL8yleSIO3OdPcLtQRp8ZvB9DpVgnZApaEgI8Q8+MQxfj3VHYCOM28rlGTqjuM7C3o4V7kA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7530
X-OriginatorOrg: intel.com

On 2024/5/8 20:25, Jason Gunthorpe wrote:
> On Wed, May 08, 2024 at 02:10:05PM +0800, Yi Liu wrote:
>> On 2024/5/7 23:18, Jason Gunthorpe wrote:
>>> On Tue, May 07, 2024 at 10:28:34AM +0800, Yi Liu wrote:
>>>>>> We still need something to do before we can safely remove this check.
>>>>>> All the domain allocation interfaces should eventually have the device
>>>>>> pointer as the input, and all domain attributions could be initialized
>>>>>> during domain allocation. In the attach paths, it should return -EINVAL
>>>>>> directly if the domain is not compatible with the iommu for the device.
>>>>>
>>>>> Yes, and this is already true for PASID.
>>>>
>>>> I'm not quite get why it is already true for PASID. I think Baolu's remark
>>>> is general to domains attached to either RID or PASID.
>>>>
>>>>> I feel we could reasonably insist that domanis used with PASID are
>>>>> allocated with a non-NULL dev.
>>>>
>>>> Any special reason for this disclaim?
>>>
>>> If it makes the driver easier, why not?
>>
>> yep.
>>
>>> PASID is special since PASID is barely used, we could insist that
>>> new PASID users also use the new domian_alloc API.
>>
>> Ok. I have one doubt on how to make it in iommufd core. Shall the iommufd
>> core call ops->domain_alloc_paging() directly or still call
>> ops->domain_alloc_user() while ops->domain_alloc_user() flows into the
>> paging domain allocation with non-null dev?
> 
> I mostly figured we'd need a new iommu_domain_alloc_dev() sort of
> thing? VFIO should be changed over too.

Would this new iommu-domain_alloc_dev() have flags and user_data input?
As below code snippet, the existing iommufd core uses domain_alloc_user
op to allocate the s2 domain (paging domain), and will fall back to
iommu_domain_alloc() only if the domain_alloc_user op does not exist. The
typical reason is to use domain_alloc_user op is to allocate a paging
domain with NESTED_PARENT flag. I suppose the new iommu_domain_alloc_dev()
shall allow allocating s2 domain with NESTED_PARENT as well. right?


struct iommufd_hwpt_paging *
iommufd_hwpt_paging_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
			  struct iommufd_device *idev, u32 flags,
			  bool immediate_attach,
			  const struct iommu_user_data *user_data)
{

	...
	if (ops->domain_alloc_user) {
		hwpt->domain = ops->domain_alloc_user(idev->dev, flags, NULL,
						      user_data);
		if (IS_ERR(hwpt->domain)) {
			rc = PTR_ERR(hwpt->domain);
			hwpt->domain = NULL;
			goto out_abort;
		}
		hwpt->domain->owner = ops;
	} else {
		hwpt->domain = iommu_domain_alloc(idev->dev->bus);
		if (!hwpt->domain) {
			rc = -ENOMEM;
			goto out_abort;
		}
	}
	...
}

-- 
Regards,
Yi Liu

