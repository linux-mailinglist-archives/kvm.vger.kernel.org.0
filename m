Return-Path: <kvm+bounces-30875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D84FE9BE135
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:42:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 36FD4B24D01
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:42:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C4291D5ACF;
	Wed,  6 Nov 2024 08:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sc5D2YYX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67387FBAC
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 08:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730882535; cv=fail; b=uuqHWW9hnF2i/TYH3lVb22h/zVB0qgV/T1CofQ/D7lYOaW/WxwFwzQv6r8ZjHp2cGPr8IJOUYoKMNrC5jnDq1P9dHmF0aJByKKBHFKIXDc8I1TqYBoJPncgO7HYMdyMnknyWS4tBfQ2D/eIqGRFlvbsulxEr0FHsIyaDY0TEyLo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730882535; c=relaxed/simple;
	bh=vkWMMI3KshBdrJLkuBad5RWibLHBsbk1T2zpmilACTM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=S9pTiDl9M3uEQUypHAgB3PS5yWXEZlWULJOGZ7h9MIy+lc6gTYAYhWAsZsi2LogUFb/M+FoKMbMuocQ1LQrhyISj0Tq9l7vhkYxKeHF0nqVadY9s5/nLhrRqNTz4ont5Z4sAZy42EOAg6Gn+/X0XzZD4fEokp/fR3dc0TQcTbJw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sc5D2YYX; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730882533; x=1762418533;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vkWMMI3KshBdrJLkuBad5RWibLHBsbk1T2zpmilACTM=;
  b=Sc5D2YYXORd6ATkmourWcfnhlKuTsEN22bKXNdZRon72N2rWRNcBgAVg
   tjbBVBbOihm6TOsT6LacHERQIZWE7lJGn+GhaXPuDtDcaYXpz+gNC+Y/4
   a/RQ1ojdVXcvofbdP1QSPvpTSz6Wn1v/hJJkqS2Bjj6HNp75asZT5+5kj
   wfqZ8r+3W/zCGlhmwAQUlg9anM0juH1oCo7K6wgxf61Nl8K7YgXc7SNn0
   RlO3B5429YSh7Aaa8OtoaqMvhi+llWpHsjcLfJh2TnhFMT7w4b0SaG84B
   HzRlPRAvFHu1OGZpDNpb2DlPDwXu48zC9pmj1QRmmchyUxTQad8pld/mW
   A==;
X-CSE-ConnectionGUID: tjedvay2SMi0iwowJmDsrQ==
X-CSE-MsgGUID: barceQF1TkGPae32MW0t6A==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="42049615"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="42049615"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 00:42:12 -0800
X-CSE-ConnectionGUID: 8tyeHI+8T3ih2G9wkWn8uw==
X-CSE-MsgGUID: +YHXYV3PSA2vVGgx+a69ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="89263837"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 00:41:15 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 00:41:14 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 00:41:14 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 00:41:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L6zX+zbPUlZhoDb+mpfvC07Wl1vgq2MxyouXYkNzz0ADlZvfGT3riFjMbo2yIs8lhCytM6GDOLnTTQVyJUSH8lgSJprJCgyPtWwXKWEdTCss+rXfwX9/0pumw6vjd1csZZ7sG9L1EZjcS+pXAvgDPSir5VDxnAeTEH2WwG1jktTnxOMFp9q9unMb3v5CRxVnMQ94d5+4yGnMGkkLpGf5tIrS6jkIU9HBQWSfJ4jzrjqGtclL9h2b2rfPVP0z24dbHxqVKqSLXxW0+90wSANLRpfmfMM6RY2RE0m0kigpTqzdBM7H0kwchcxL4vMX3AlakNZUtujDJB4xYXJgZP/DKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ggx7vbqFMpIjo5zsX+JPiDwtbq2nZe0C+m12IqvChJc=;
 b=ohP5u5O2jbo6GVn254j6Q9Pt0xXzqCuDpLiCVaSaUmHvAfKc0XhY7kSrArq3mw+GdQuJJYw68ikarIJquVB+fvRogiIqaM0d5b/Xt+d9gKTBsFYE0C+MvmSucyHePTIVx1mnwbrew12Anvtthrr22ItuvfwIZUV7NXMEti8QzVtp/9A3qyqZQ1E7f4+7jg5rNazW9876qAar96YbMLcozv/F5B4Z0Yokd/pgIScBoDnAYtonYXU2f0aMF50Om+neAsmJRicXan7LQbYUfeMDIOfG0+50IAYKekCrZRka9mQvnBS56kmVmhoFYqP6qNN1D8iwD1woDfUW0VXxkDrI0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ0PR11MB5792.namprd11.prod.outlook.com (2603:10b6:a03:425::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18; Wed, 6 Nov
 2024 08:41:12 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 08:41:11 +0000
Message-ID: <b6442ba7-7979-4619-8b47-87ee90792517@intel.com>
Date: Wed, 6 Nov 2024 16:45:47 +0800
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
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276D12FF07A6066CEAAF4308C532@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR06CA0188.apcprd06.prod.outlook.com (2603:1096:4:1::20)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SJ0PR11MB5792:EE_
X-MS-Office365-Filtering-Correlation-Id: 616d615e-c7a7-4508-ab5d-08dcfe3ec45e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VWdDL0RVYjVjTnlhMUlQZW9hQ1NCMG1jTjlzeWRQNFc4NzhhdWtGeHI5MC9T?=
 =?utf-8?B?QkhoUDRrdmh5K1pMQmhQY2hVOWFxTUhndWFzQTJicUZ0SW1OV3o0dkVLQStw?=
 =?utf-8?B?VnFKYzZhejZ1STk4SUo2c3pOMkszZitVMWJTbTV3SGZ2d0RYcTZPSENJZ3hk?=
 =?utf-8?B?dWdzN1VTdXJOMDF3QmJSTTg1a1l2b3pMM1ZpNHRTQTlxekx1amZneUpmbHo2?=
 =?utf-8?B?ME1Ec21XTGUwRTB3UitPblhNd09uc21ZOEczL0dNOTliYmJSaWJUUGNydHo4?=
 =?utf-8?B?dnR4NjVWZENwOWNtTG1DTWJXNUkwWU1NWXR0ZzR0emNJMDNtOGJHbThPdFJa?=
 =?utf-8?B?SDh5R3ZBK1o3bXhkUTh1bW8xbVZFRWVrSUZYK1VZM2VPTWFHWHJhVTZpbGdS?=
 =?utf-8?B?c3hyR3hvUmp2aTlMalpNWWQrMjYvMWtNUGFIbURYRkVrMitLMjYrdC9jczYx?=
 =?utf-8?B?YTRSek9wcU5JaGF3VUM0TkJxYjZLNFJvSTlSaUw0eHVlNzdsR2NRRFlFb3B4?=
 =?utf-8?B?eW9kVEtaUWVocmNlNDE5NVdVQ21PRUdWRjFYQ0s2VHpKQ1hsd2d1TlloMEls?=
 =?utf-8?B?Wmc3VWFzME5QcS9ySFBFWjk1T1RqZ25QUHZEdURVWHB3S25UYnhHbnpTeWZ2?=
 =?utf-8?B?Yy9NY1hrVXkvZTQ1L1ZkZWtkYnNxakFsdXpIWjlkSXBRMUhkdWJZeEVQRmhT?=
 =?utf-8?B?UWt5TFJQNjlCcVNyTXdzVWg0VHJOZ0ZxaXhLREVOUnpoU0R2bllIbkcvZ0dC?=
 =?utf-8?B?SzYvS2hOQmtTV3BFakN2R2RoUFRTRFVaZTIxRGJVdGgrMDFtTjBPSS9scXdV?=
 =?utf-8?B?YU84M0JyNnpPbzA4d1J5YTA4OXRXUldoSThFTFl1dGVTRFRaaXFIK1N3SGZm?=
 =?utf-8?B?K2dlSW54RFNBMXhBa0N6K2VTenp2QXYxTDVaQnJ1NGlYLzhNSjZQRkdWcWJF?=
 =?utf-8?B?Zyt0Z2JnWkVhY2ZEQWh1TEhXZWVtbWRUVHE0VEp1cUNzVWpXZ2FCZDZINzMv?=
 =?utf-8?B?N0I4cDRQcXkwY1lRa0FoRVVnSXNzSC9zVkt3TW95ak80RjRYa2ZuS2lZYWk1?=
 =?utf-8?B?R0JNalpXWXZjWVA4c0QxOFo2Q0FQdGx3Y1VYYUIvN3VaK2RsTTlteUgrS0xG?=
 =?utf-8?B?c29LQ2xqZXlsbGtjeVRta2xDVFI4cUpWdktJUXV5dmhLd0FWQ3diRGRwcUh4?=
 =?utf-8?B?enk4NUNCNS9OKzBuWCtwd1hnVG9janlUZUxJQ3hRdmUwVU94WWV0cjFSRUww?=
 =?utf-8?B?Z0VkelhleU81MDNkdVFSZTlTajBKN3UyL2xFQnNFQUEyc2pUd0NQbGVlZmdh?=
 =?utf-8?B?Mzk1YTFJY2VFYm5jZ1l1aVF3NFVVcFZlWnkzcFlBNjdENFZLZ3ZZb3hqUkFm?=
 =?utf-8?B?ZitRUVdPM0ZSaGhaK3BmZGRVVElneDNmQ3c1R3pzaXlWV0owSEIveC9LRVcw?=
 =?utf-8?B?TnNwNkFqQ1FlbjRyRlNvYU1zTTEzNkpxeG1SRjNRUnIxKzVFVGlJQzNTdDJI?=
 =?utf-8?B?dWxrRXViQ3BCeVRyVU9ORVdRaTJOaExnMmhhNnRvcGJpWWNrSlUyN1VKMjYw?=
 =?utf-8?B?SzJ6VDl2NTN4bVN2YTZjaUh3SzVsSytacE5YZnVLU2lFcDU5c09BaHhkNFhX?=
 =?utf-8?B?TVVseUZDcnlWRmN0RkMzYWpSaUk2d2VnQnNtdXlxUUYwbTl5SEZ2QzNOdUVZ?=
 =?utf-8?B?V0VnbDBMQ213RlMyMEdxdGhrZHdWQ0twVWp6a09JWC9sYzl6bzE0OWcrQmJv?=
 =?utf-8?Q?Nw5MB0SHJPzMBN8grs2qe4g2iSjEFO2zQHf5xIZ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RzVXQzE0WDBtNU9KUmp6Vy96dG1KOS9oTE13cUw5V1R5empHd3RCNmcwVDJL?=
 =?utf-8?B?R0ZiM3VwT3Q2VFg5RitEa0V5SnVuMXJkMTlFcUJCMEI2YzNUaW1lbGxTbHk3?=
 =?utf-8?B?QVdQMTJCbGlDcllpdnM4UW45Wmc0NzJqaEFkTitLUWZlUGp2Q2dkTkNteFF5?=
 =?utf-8?B?bDd0TmtuWTRJSjR2MzRKZFFmTHloRmtZcUxSTDN2dm5CK2lUdWg3aTVyeStF?=
 =?utf-8?B?Zk10ZWY4THNLMW00U0dOalp2azdRc2VJYk9YdkNuSnVuWmxXN045dGEvQTcw?=
 =?utf-8?B?YUZBYjFsMjFwbHhjNkJHREZBYVpHZ2l2SDBtRlJSaVdkb3hGWVQ3MUtTZGp3?=
 =?utf-8?B?K21SOHEvS01rdVNvSXRGU3BwTGxRbVVGUXcrdGp2N2V6eDVVanNGRTJ3Tjl6?=
 =?utf-8?B?Q2FTQ3RVbmMzUDlRR3paSmZONkFqS1psT3F3d3llUG0zOVFlMlV3c0dGOW1K?=
 =?utf-8?B?NklzMmltbzA3SFk3VHNRcGEweXQwK0QvVkg1RGRjb1E4aUFZRU1RWDMveFBF?=
 =?utf-8?B?Yk5GZUM2bWVKTXZLV24zY3U2bkEvVnZmMk9jQXduU2VUOTY5UkpQaE00aTdW?=
 =?utf-8?B?clFqU1FEZ2U0OVcvZnlYaDk0a0xnYmpzaXpYb2VrSGsyT3dkMU1ZU21CdkdJ?=
 =?utf-8?B?a0xicDFaUFBWbkZPZERyeGluVUt1cUlnaFdDUFhFOTdiWEdZeUV4R1JDWTV5?=
 =?utf-8?B?bE8xQU5MdHZURHNiZDBQZFJTMkl6b08xV0VBR0JjdDZoUUJxc3VaNXRld0VG?=
 =?utf-8?B?ZS90KzlGSjRYRUxPOWJiVjVaNTVrbkZkOXNwWnM4bGpQTHlNTytYZGNqNUR1?=
 =?utf-8?B?eVNtOU9zTjdMQVR2Wlc5U0FuNlVEQUsxbW1xYTNHTWcrSVYwQWw1YUdMVHJY?=
 =?utf-8?B?ZU1vcUVjdmpEMTJ2cWJ1VjlkZmh5WWFkQmRhMW12Tm91QitQK1lCa3B3WURE?=
 =?utf-8?B?Ym1zSUVDc2ducVlkdnVGelJWMzM5L01heFFMVmhSbXpKditLb2diV295V2Mv?=
 =?utf-8?B?c1JUbVR5Y2Y1Y1d3ZDlETlRxZ292TnFyOVdCaVdYOWtSU0ZwRlc0bm12T3lT?=
 =?utf-8?B?Tm1SYWZISmZYdGRtdTQ5WmtkV001aWx1elZGSVFEbmFsTzB4M2tSZ29vSVVV?=
 =?utf-8?B?Nk1aVHR3TkI2NE9tejlIRFBoTUtPMU9SbWJsb3dEc0tLMzlTM3R2QnU3ZGN6?=
 =?utf-8?B?Z2JkWDJjaUtPNUoyeHA0aHRxbTJneW9qaFZveHMvR2ZkZ05uaDJSUmp4RE03?=
 =?utf-8?B?alV4K3pVWHE1ZUNDbXJHT1haWlJBalJnZE51eEpQNmxmMnBOZnJucWhoNjRQ?=
 =?utf-8?B?LzZzQ2FkSzNGUkRVZnpSUVRSNGdRUEFobTBpeTNpRU5DMFlhRDVrUUNEZFhk?=
 =?utf-8?B?dThJMGRJSHpqeUJydFFWcURMNjlUQy8xYVROTHd1UlorZUxiR1Q0WURha3Jy?=
 =?utf-8?B?T1g5OXR5K2w1d3RoVjA1QU5YNTdtMTIzTlpDTitDQk5RdHFabFEyQVAzRnF1?=
 =?utf-8?B?RFpyNHVsMXlDb29CaTArdjc5WUVGWVJPYzk4NHNxZFFhWDNjNHpNQ1VJTEw2?=
 =?utf-8?B?djJSRmIxM3Mway9LRFB0SjdDb0RqczhrQ3UrNHJOOFhYTnJweldEeDJHdmxW?=
 =?utf-8?B?OG1CcDdhY3BBa1MxNnBRem4yRXhRNmc5WWNIVWEyUDUzN2JDeTREMnB6bTdN?=
 =?utf-8?B?cWFRZENZa3RHMk5xSnBuRmtyWXBZMFl3T2FaNWoyWXVsRndENDJsQkc3Q3h2?=
 =?utf-8?B?MHYvRVN0WlUvLzVIOVh6OFpYaHJ6dm5RWVNPcHVPVllXcTZvR29LRFRUWTBO?=
 =?utf-8?B?bk5BZDFsL2U4dlhRQzRzOTdSNXVmZFI5ZFlvZXVTWVpPeFYrUUdxWVN3NnNt?=
 =?utf-8?B?Z3hwOVYyZTFSRDV0K0FJOUNHMTF0VmczZWZRQTJLTEoveldGRkdwVXRSZ3Bx?=
 =?utf-8?B?YVJEbG1nN005ZWRua2VwZExOZ3J1MHdDMXR0c0trZXVWblZONXU2dzRRVWt4?=
 =?utf-8?B?N1hERmhGRjFuSzFId0VGYkRKekc1NkVTd1lLd21SelBSSUZCMFlCY1picE1q?=
 =?utf-8?B?a1hGZU42QW02bzh2alBqQzZJbG9pL2VwbVpLeEZOOGFvdGJOTEhnZnZwbW0v?=
 =?utf-8?Q?Oj8wPUoNCcBquUvpzt1FPtx5O?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 616d615e-c7a7-4508-ab5d-08dcfe3ec45e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 08:41:11.8853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GEbbwtN2OFLiFlln2iJumUneXZ7CveiRW9OuEpoTIhwhNHMftxpS4g/iSiLliLXgC0dGFcGO4gyIl5RdlCUFxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5792
X-OriginatorOrg: intel.com

On 2024/11/6 15:11, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Monday, November 4, 2024 9:19 PM
>>
>> There are more paths that need to flush cache for present pasid entry
>> after adding pasid replacement. Hence, add a helper for it. Per the
>> VT-d spec, the changes to the fields other than SSADE and P bit can
>> share the same code. So intel_pasid_setup_page_snoop_control() is the
>> first user of this helper.
> 
> No hw spec would ever talk about coding sharing in sw implementation.

yes, it's just sw choice.

> and according to the following context the fact is just that two flows
> between RID and PASID are similar so you decide to create a common
> helper for both.

I'm not quite getting why RID is related. This is only about the cache
flush per pasid entry updating.

>>
>> No functional change is intended.
>>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>> ---
>>   drivers/iommu/intel/pasid.c | 54 ++++++++++++++++++++++++-------------
>>   1 file changed, 36 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
>> index 977c4ac00c4c..81d038222414 100644
>> --- a/drivers/iommu/intel/pasid.c
>> +++ b/drivers/iommu/intel/pasid.c
>> @@ -286,6 +286,41 @@ static void pasid_flush_caches(struct intel_iommu
>> *iommu,
>>   	}
>>   }
>>
>> +/*
>> + * This function is supposed to be used after caller updates the fields
>> + * except for the SSADE and P bit of a pasid table entry. It does the
>> + * below:
>> + * - Flush cacheline if needed
>> + * - Flush the caches per the guidance of VT-d spec 5.0 Table 28.
> 
> while at it please add the name for the table.

sure.

> 
>> + *   ”Guidance to Software for Invalidations“
>> + *
>> + * Caller of it should not modify the in-use pasid table entries.
> 
> I'm not sure about this statement. As long as the change doesn't
> impact in-fly DMAs it's always the caller's right for whether to do it.
> 
> actually based on the main intention of supporting replace it's
> quite possible.

This comment is mainly due to the clflush_cache_range() within this
helper. If caller modifies the pte content, it will need to call
this again.

> otherwise this looks good,
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

-- 
Regards,
Yi Liu

