Return-Path: <kvm+bounces-38142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 760EBA35A2A
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 10:23:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAB5A16E91E
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 09:23:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FD572309B3;
	Fri, 14 Feb 2025 09:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mvOZ/8c1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E53822F388
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 09:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739524982; cv=fail; b=hWNRzlLhUrPJgmf1Ybqjz4wlSBirL72hrl/ihYZD07kqhfxVOIkLwMUWwha+jRyvhcrVlWak4Lkd3BdMkjmC0Av+OEotWwrmgpVtHPVDr6bO3NIQwoff3B8WNsgqBj0S9oQiuYujbLVzzKHW9Ar8GfqXO4RVyf/3o/JDTX8ilqk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739524982; c=relaxed/simple;
	bh=rsuG8mhnum2sRFAkjluIjQkN4tp6lgxJbtRh24DZwxA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZH02Bb+4JAnNW6Ba4WND8Om5br2I8Q23zcNDX7IBq+fK/b/PYovgxXEbaRWSoasoHq5kiWgfbpJmryw/Kpm0oDntyKdnl6jfJ8wbmc8k5koYMyCICjYR0zlWJEUY/dCnDxE39zBud2omjc5YASkIWPP3+kQkp0QHlPiel1R6yeo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mvOZ/8c1; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739524981; x=1771060981;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rsuG8mhnum2sRFAkjluIjQkN4tp6lgxJbtRh24DZwxA=;
  b=mvOZ/8c1C/4MFXdLwQpgMjnizwAz99GWQLuJ4qFwYdIoObO/jRxvht+W
   NO9ErmUxBlVcciz7yG7Tidvm6xbT3BDjvBEsagryhSWQAVWjoY6AabMeM
   kA3WYwOMyKkrwttu3R6RKi8WAT2fwmuQBEyRJx5SVkt0JWWQ0UWx7Ntms
   tSrhEXiAQRIFUSdbuEzDU4H9cyV1+xcORzAbabpKZGbuKm7qAM7jpnMx9
   Su2MmJuK6h1M8Dm2oz/wVRFvXiusf5AsUEfWYSoGTuwATZFdqBbNIwMgm
   npur+t9mKvTC9OhC6XkonvVGtb5/ifFLzCQ9jSLF2StoWxvcy3TPxxDYT
   w==;
X-CSE-ConnectionGUID: rpn16lt8T2u/5GLY1op9JA==
X-CSE-MsgGUID: kggupgBJQGOHuWj0JB0fMw==
X-IronPort-AV: E=McAfee;i="6700,10204,11344"; a="40527502"
X-IronPort-AV: E=Sophos;i="6.13,285,1732608000"; 
   d="scan'208";a="40527502"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2025 01:23:00 -0800
X-CSE-ConnectionGUID: fq18fE7pT4mj5bCNRG/+JQ==
X-CSE-MsgGUID: 2go+8V1sRv+W2PZXNM6lAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="150585723"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2025 01:23:00 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 14 Feb 2025 01:22:59 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 14 Feb 2025 01:22:59 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 14 Feb 2025 01:22:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bDEExm7+er/e3EAhMfrOnirrDYBZG8k6Ss841pdj+wvOskx3UJQDnEU9YhvsV5hO+wACQxI4BykCAN2LL7JMscuR6ZKQP+zfia5xnnOd0CrjTWKgnXasxzBH2iqDj1jZKa60eEKwTiiN2wI7mJEApez+gJvVT3Eip7abr5WyMaOlV8bC0QqD71uf5RePeicX22sphxT5uF5Uq5YGNIM2eICYGDHEut2HQcI9GXl6zJzxGIWTiEQXcdFLZHlGdSgSkbxk9poczLpPVXNcCELLcv01L00MlcQUlmMMKnk4hsBwczKJokNkia35yvs61KJQTx1fS7/GZZxEU8HfNhmRJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Jwqi4KjsLT7lMnC1zOFun6zGcit8IkYDCXdM+fT+0M=;
 b=i6PUUqFRgtODztUr9yOCKAVCt3s7YXSj+9lytsmAtxU6hbEx3864wZbkib1rbiup7WQEINzM5NSS9aOKEkeFVf+i4DNfjSu/2fBAYWSbhi010hT4wTAoWNLy/9pcSddyqOtiY0lJWSycYAa+1GQ5InKpYPf7w0QfEmyb19s157501qccKaKTobBC+fgNOnUhXd6QLjgYCfwjushzl65C8Bu7/Hle4n/TjKpnwmo6aGXU6yEcHjH0iTPNz0S9YncEOvLaS4BrRNHBQOK1n2EwwJW3cZ3lil3/+QFmvrSkURDzdVqOaiOwpxIdFAVHWqpMHOhBitGXVZI06r54NPdZMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB7443.namprd11.prod.outlook.com (2603:10b6:8:148::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.13; Fri, 14 Feb
 2025 09:22:55 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8422.015; Fri, 14 Feb 2025
 09:22:55 +0000
Message-ID: <7f388de7-7ad1-4f3d-a05d-ae55381a8ac8@intel.com>
Date: Fri, 14 Feb 2025 17:28:14 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/5] iommufd: Extend IOMMU_GET_HW_INFO to report PASID
 capability
To: "Tian, Kevin" <kevin.tian@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>
CC: "jgg@nvidia.com" <jgg@nvidia.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"willy@infradead.org" <willy@infradead.org>, "zhangfei.gao@linaro.org"
	<zhangfei.gao@linaro.org>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>
References: <20241219133534.16422-1-yi.l.liu@intel.com>
 <20241219133534.16422-5-yi.l.liu@intel.com>
 <BN9PR11MB52762121B40BC72A2EAAAC638C192@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB52762121B40BC72A2EAAAC638C192@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0110.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::14) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DS0PR11MB7443:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f2f585b-02cf-4167-6d7f-08dd4cd929c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?REVRNkdMOW1wS0krKzBHbEN3UEtOSU1qSFVnWVFBcnZRc3JXSGI1TElWVERo?=
 =?utf-8?B?VkE2ZnJLZXErVGl0ZDB0TjF4d285eDdQVmhCMjRqMzBCNWpxcHdxbnJ3dDBO?=
 =?utf-8?B?dS9ZeTFzaVV5L1A1cXA4WVVZNjEzdmFKOTIvWnZma1cwdmE2TThKc1crWU56?=
 =?utf-8?B?R0VyWkpWbWpKL3JEcnBnTDFCY1cyR3NlWDN4c0hUYnZ2SHIyOTRlUVQ4WVg4?=
 =?utf-8?B?MFcyc1Awd05WZDQybVVIeXFKYmt4dmxpWVJ3UzdlV3BZTjdETzBHU2ZkL3U4?=
 =?utf-8?B?ZWZlcExPNW5WU1pQRWxoeTJxdDhmSWVIcEYrT1JzU0RjYVV3cEc2TEdWOVNK?=
 =?utf-8?B?TkR1cjQzZU02eDJBYXQwWGs3VjJwNnpaOUcwREVMY2U5MGVqcnRQNUtlUWxz?=
 =?utf-8?B?aEIwOXpQWWRBZldWdVpKRlhMT3pjRExtZ3dTZzY1aXpWTFI1RUkxTzRaOE4w?=
 =?utf-8?B?LzBNSEo2UmMxRXh1RkhQbG9pa2tzaHFmcUV0UVJMSzBzekR6YjZwdkJUS0lw?=
 =?utf-8?B?YzVoS1dreUJpdGt1VHEwa2JiV1NRVUthNFR2K1VuRWduVkgzR1JldnI5Z2Fy?=
 =?utf-8?B?YW5ORmRZSkF3dVlkMzRobE96N09YMlpoYWc2L3NYam50dmdBY0V3dnBXM2RV?=
 =?utf-8?B?bHh6MHpUVDVqVUdodVVEUlZFTkJBSFpsNERxbTVIMVF5cWRFME82dG9mbGtF?=
 =?utf-8?B?L1dkNUljZnhocTlvcTVhYzZxZVJKakVTdEsxODlZeEhIRmtrT014SCtibmVP?=
 =?utf-8?B?aWM2ZlFjUGFnT1lZclptY0lFTUo2VUdZZ1NKNFlrTFphT3NPakdNVC9ZODI4?=
 =?utf-8?B?M083TkQ0Rk1RV2h2VjZRdi90Y1V2bEpoUzJ2WmR6UXhXOUdPUHkyYi9UTzJx?=
 =?utf-8?B?czdmUGpLRm41emtCUnQ5K2VrM01jY1dYRUY2VDFRbGpwWTlHQjhQdjN4eHRS?=
 =?utf-8?B?bXFmQWZVZHY2TUR0d2oyRkxCaW5TUFFEWnhXNjVtZUw5WFIzZDJpSkdkSjA5?=
 =?utf-8?B?VkRlQkxPcElxd2pxN20xb3NRRjc2TE53SWI0RjFCVDdvZEtCMk5ZV0xDcXhJ?=
 =?utf-8?B?bzhIVUI3K3M0ZzE4Sm1WOHhta3VMREthS2VXY093TmJGZUVzS3d6eDR2R3VJ?=
 =?utf-8?B?YjRtbG03bTVYRlhIc0E1NUxiMnhUb1NNM2grbW5XWjkxUC9wRWhJOExSUGtO?=
 =?utf-8?B?QnB2NjNKdm1iYXZXbUw5dk1TZDBIRzhxVjZxWTBHRVFYaHZxNHBDRGNsby9m?=
 =?utf-8?B?ZzR3T21Ic3M5dzk2QUZZL1RSWjRlVStYaVpYVmpVMmpQOUMvLzZjSi9pMWdP?=
 =?utf-8?B?bXJ4YUFRZEsxcEVhTkN0TGNPejdOOEVMcTFGK2F0QndtajhhS0RNd3FKWm5Q?=
 =?utf-8?B?YUVEeStQZS9SNGFMUnNHRHAvQWJ4MkNMSGgxUm1USFhpMm9HTFMzZVdhL01x?=
 =?utf-8?B?RDB6NVl5K2lVN1h4bFk1ZWVZVk1lSS82YStPSHV1R01yRFpYMlR3N1RRNVlR?=
 =?utf-8?B?TjhCMFQ2a0NnVlE0a0xjQW5xUDVEL0RVRDdFN3VjVllKeUdoV1krNVZWbXpL?=
 =?utf-8?B?UzB3Sjh2NjQzRStZajVqMG4wVThsY3BFZ1V5bk5kSjZyeFYxdnEyS2xZQ0cv?=
 =?utf-8?B?R3krM2lISUcyaXRZdEszZno2TnlsdWRmcHFFMFVhSXNlOWo3TmxVOHVCOGdo?=
 =?utf-8?B?MEVCVEpUSGtOc0loZFBuRUFtakkybGxmUTlSSE1xdHJQb1g4aDZ2Y09iNzBn?=
 =?utf-8?B?NEVZYlQxLzFuSzlDUHM4VGh5MUVTbXdjVDU4M2NrRng4cnVmZVFDQjB3ZjY1?=
 =?utf-8?B?QzF5bnlFREJSQ1VsWTE0YTBYTmZrNG9SeitOalZjQUU2Sk5oakNab1A4RGM0?=
 =?utf-8?Q?ci3DtcmcYfHPJ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUNMeGE5eXc0d3p5dmc0VUN0ZXNRdVdvN2Qrd0ZWMGtuQUswNVZsSFMvMndx?=
 =?utf-8?B?NWY1OWxtd0MraE9SREp1bElHSStOcDJiZkhwTUI4R254emdTZWp4VDJKL2NQ?=
 =?utf-8?B?dkF3c0Y5NjRWcndiOWx1WG1XTUVCTG5lUnZ1TDBGdUkxTXZOMnZOWlpLdXJh?=
 =?utf-8?B?M05kU203dFlJMlZGRUVFQ0FIN2xPb2xKcTkzc1BBdWk0cXdlUmhYcEh3Q3Jl?=
 =?utf-8?B?VU1HMXc4bjA0bUI0c2JFVXpLL0JDZlhtNERvbG0xZFgvdTZ5RXpQSlBwem90?=
 =?utf-8?B?R2x3RTJWcWRMZGZ0OWU4S2FVR0NpMzN2d0phZEw0VXo2cGdaa3Q3U29CYmp1?=
 =?utf-8?B?NUlTK0cxWWdNUkNuTG5aQkZDVjJ2RkNLcm9Pb0NUUFRpSCtFaHlyN1V6SXVr?=
 =?utf-8?B?ZWovQkZGSms1bW1Ma1hoejJmSXU4UWt0bkprZVFaVnYyNHRJMEh0SGl0WVly?=
 =?utf-8?B?T2ZSSE1iVnhxS2lDRHAreHdNMFliT244T1MxUUphdUpVQ3RqcDJyeC9zZ3RD?=
 =?utf-8?B?WlI2eVlXUytKa2phcGxqY25Vd2h3MTFxK2tuTTJPcUs5WUFua3NDdnFoV3Bz?=
 =?utf-8?B?bU9UR1NscUg1U0d2SVJ1a2xSZWZDZHBFVkxhbGFqT3cvWVFDWjVGdkhrYUVn?=
 =?utf-8?B?Znp3cXdIZUlHMTNrc1lLc2NBTzlmQlZXREwxNVVsUnJUWGpENGVZSm9hM09T?=
 =?utf-8?B?M2txNmhVM3BTclVLSW13dGxZV3k2Z0ZOUFEramZWUE5ndEFzY3ovNFF5eitV?=
 =?utf-8?B?dGI0WUNDTFhmZGthMWZGSUR0ZFVtZEh1RjF0U21HdkZmeG81Vkx6Tlo2NW5y?=
 =?utf-8?B?TDBlVUNwVCszU3ljODdZZXo5WnhvZHJZaVVub01hVGRLN095WjRXYnhSRmZp?=
 =?utf-8?B?aWNkSUk5RlRrVXh6VDBJVkhiV3hyTkJCL1lFeW5mUW5jekY5U2RybG5IV1Ur?=
 =?utf-8?B?NWduU3NSQklQSy8rUVEzdEYzWkxYSlRUQjR1WkhCWEh3UDl1VXQ4eVNDVmV5?=
 =?utf-8?B?WXJVQlhHQ3M0U29GbmQwcWY5RmZ5TllGSlRyZEpXaHdXbVJmUWovb1RXM2dz?=
 =?utf-8?B?dkNFQnh5aE5veGZHcTNaaXZUd3d0eENoNWp1TDdEVmFjVzMxZWpBaGpYNzcx?=
 =?utf-8?B?R2VtUXA2cW9JZjZHdDNsdXhIbGJCZzRabWVaNS9SdFgyM0taQWRna0pYNXJJ?=
 =?utf-8?B?WHNzZ0NwTXJMK24zSi8yaTVDckhCQ2hweEV1UFVHSkJYaHVQa3gwZUgrZWlB?=
 =?utf-8?B?UnRiUjAwYXdmM1MwcnljeXZUME9uMzlwUWxlSXlZU0dzVk0zTnZ3T0xFZXQw?=
 =?utf-8?B?bmxGMzI1SzVpWUQ1cklFVEhDNjhJaFZrUEdPYVlnZFA2enY2WHd2QVd3ekFB?=
 =?utf-8?B?ZnlzbnNCRGtmVHdqYjVDWGMxWld5NDkzYnY3TG81RHRuN2ttcnRZMFFXZlJs?=
 =?utf-8?B?R1FrS2d2REkzb2lUZUlPRUFxY05jRUJMbGxlaS9IM2N0TUlBcmZYSDcvbWw4?=
 =?utf-8?B?WW5oQlRlNm9Ha2gxaU8vZWxDS0JkR1Q1RzQvZkFVV3pRTDhhejhwUTRLWVRy?=
 =?utf-8?B?YmlUdUswd2YvTUZpSUd3ZDMyQlZUNVFPYnpFbG9ZK1ZiRXVBampIc2o0Y3RK?=
 =?utf-8?B?ZWdRSmxVZ3BrZDMyV0U1TUV4dTkvWE9PZ3h5Qmhyc1gyN2x6Q0NLNElNNGV0?=
 =?utf-8?B?VjdMN2FyZjd0Q2FXS2lrWVVFaktSbnRhNllOTi9hb3JRS202TVU3QTJQbEVX?=
 =?utf-8?B?ZWxLVCt0WFFlUFF0K2RpdUNxNXcwTGJwNmVQTWp5TGUyMnJPYjJOOWNaYnJC?=
 =?utf-8?B?TmlZakhzUUhlaGd5dk42V1dVbWVBNVdRS2h2T09aaDdjRFlFcEM0cFZXNlow?=
 =?utf-8?B?ZnhvVzZjU2F0QUVpRHNiM1U2QU8rSzc2VWh3WTV3OTdGY0x4c1dkdXl0aHdn?=
 =?utf-8?B?M29RUEZzb3VmdWQzUVYxYzRJaU1QSHpqNlBlZmRQWmlMUFFpTm1KdEYzdnNn?=
 =?utf-8?B?bVpMZldPSXNEUUdpVDJRZGJINEtLUmV6b1hyS1d3UGRudTIrZjhYYXg1SzNC?=
 =?utf-8?B?d0xqdzdscFJXY2xoTUw3Ui9oMTBZdXBLd2FEZFRVQVpjaVJLaEZkS1pVd3d4?=
 =?utf-8?Q?9w+PqIvXm/sjsgTZWPlTr/rNw?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f2f585b-02cf-4167-6d7f-08dd4cd929c3
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 09:22:55.2291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QBib9il3sghp/GbvbDronkgcLKwbtZPj6lZvtzfmH16+YzSvwzpt13zS23ZN/yFjbfJRdhnkHjgMBD4NqT1LlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7443
X-OriginatorOrg: intel.com

On 2025/1/15 16:11, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Thursday, December 19, 2024 9:36 PM

>> +	 * if it's enabled.
>> +	 */
>> +	if (idev->dev->iommu->max_pasids) {
>> +		cmd->out_max_pasid_log2 = ilog2(idev->dev->iommu-
>>> max_pasids);
>> +
>> +		if (dev_is_pci(idev->dev)) {
>> +			struct pci_dev *pdev = to_pci_dev(idev->dev);
>> +			int ctrl;
>> +
>> +			ctrl = pci_pasid_ctrl_status(pdev);
>> +
>> +			WARN_ON_ONCE(!(ctrl & PCI_PASID_CTRL_ENABLE));
> 
> If not enabled then also clear cmd->out_max_pasid_log2?
> 
> btw pci_pasid_ctrl_status() could return a errno but the check above
> treat it as an unsigned value.

ctrl should never be errno when idev->dev->iommu->max_pasids is non-zero.
Perhaps this warn should check ctrl as well. Like the below:

WARN_ON_ONCE(ctrl < 0 || !(ctrl & PCI_PASID_CTRL_ENABLE));


Regards,
Yi Liu

