Return-Path: <kvm+bounces-27663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48B039899A6
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 06:00:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CF8FFB2182F
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 04:00:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 534E23BBC5;
	Mon, 30 Sep 2024 04:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HKXnto1D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F191228F5
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 04:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727668817; cv=fail; b=sK9cvoGLWoHfBTDnuPLXmh4ruVwG6kyCI3XYKhfmsw27Jma16NXJKdI6WMtGsPSuLYkpW49Ls8NBU8tE9fbWMYcJIWNQbjpPwxSrwILYtmnsc/tyG/WUBjdYXw8937MqAqunupEt8mqZbYAURcWiNg5mTiheyPOpefHz+/r96pA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727668817; c=relaxed/simple;
	bh=ykdRq9AM6pbrFBotWSs/FSSMKhIvudCesaGTprm322g=;
	h=Message-ID:Date:Subject:To:References:CC:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Vu07xi8MHbHNTY2Z5wJBXGDL9lDzH4Wu2UUnR2hIbgKwKdnze0lZUfFhSYIf6wFWILtUVZseKy2lLYpfEa1CHtc6u16awwglCbq3bEKq+8g0zVcwWhu+OEvfLfjXOoi2GUz1X/elAcpACgaRyoxmUBxWMQOiiUquehbwzmhMbtg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HKXnto1D; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727668815; x=1759204815;
  h=message-id:date:subject:to:references:cc:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ykdRq9AM6pbrFBotWSs/FSSMKhIvudCesaGTprm322g=;
  b=HKXnto1D0IXNrmmTCEzdBwN03VPQLiL/3ViLmTJ48aLw6IVDVDuOepcW
   jnMUxsvY6e3uZAyAn1ot+VfavxrXRY7soIqmkon+7YFZeN5xBy33xiFE/
   4BNmHLNdUJtAf+VAqz9Vp9UrDJo3ugdctAzzAd6jF09liPVg8TIhqYyPT
   EACcM1g9LKprRJtnFWDMYJBEVEC96qO0CB/qwNKQaJ2Imi5AyAAbS5Xx4
   N0G+ptsR8SFFdOpTMx2nBJMGu1CH6XYC9uAQ6DvTh3sTmWCxQfFNI2jf4
   byxdO7GuH4TngV7hJh6Y9mgECvnzbagJqL57q47ElbYF8vMHjMXgjTEhD
   w==;
X-CSE-ConnectionGUID: KmVP2OxMQoi/GKvCCDdUgg==
X-CSE-MsgGUID: h7CJYJe5RqOVHQoZl5RdBQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11210"; a="44200984"
X-IronPort-AV: E=Sophos;i="6.11,164,1725346800"; 
   d="scan'208";a="44200984"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2024 21:00:14 -0700
X-CSE-ConnectionGUID: oHBGQFC8Tpiscen3d3GMQA==
X-CSE-MsgGUID: 85FNp7/DTIWnY6hK2RY7LA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,164,1725346800"; 
   d="scan'208";a="77243306"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Sep 2024 21:00:08 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 29 Sep 2024 21:00:06 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 29 Sep 2024 21:00:05 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 29 Sep 2024 21:00:05 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 29 Sep 2024 21:00:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yHBPJGtYHkCecn32SNUYLrFbR5JDpiOwyC9FTp+GGH7C04sriaJt3mdkXcDKfX+F9QrU32X0KixnIxea3ePLd+Cve5vCoPL11hy00IwTzV0TVKoaUGpPTTFfhsS4cCA/PqJRC3NbPkOHHKzuRHRAQ+D9Dvd+YL+ZhM97iD1HhPbQh0wGBKcKn0IlI+Ptseixtjfcxljz3Ai9ttuZgtfQPIchIHgBkzKshnzvNZMOBTv8FH+2Z6QodINkcjrQOGpdcuRNFX1UZBQHQd98vmEJK4tOjHmm7yKUh87O0srQir+sIjDX6V001XzmcZF7wCbpHh3QwLzxz5hF6+vCxrqFmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=13tXV9ZgYj8JAnaX+8GXaoOOJrxrZD4CbvG/Wlz+E24=;
 b=EfziPpCx+87CtVgvNsDir9etMRmezcyuY0SqiCVUA5uJ3ODwXDZgFIJ1/Nj6Df4h95CkTitxDShxeFsTdWK/Y4by7Fi5Epi2meT2mH0ZCFWykRh3u0HwJAlabjzTLX+Zjb/dIuDMS3mm7ntna0z4lt1i6msTi7ssSqgj9GD8yj4LtubUrrW97p9SZvK81O6WHZuB/QQEHMomfVd0eZOn+Npjaob+9HkTl1gPNAWUAj40OBsJH9iozIqDkdfwFQGu6qPZVwILyoh1WD0DRZCDjLl2kGZU/aAw2C4B0dLjEXA0YtVe3GTBMqxFuTuB2tj3r2eB9C8mT1FtsBUlrpT12Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ2PR11MB7597.namprd11.prod.outlook.com (2603:10b6:a03:4c6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.26; Mon, 30 Sep
 2024 04:00:03 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8005.024; Mon, 30 Sep 2024
 04:00:03 +0000
Message-ID: <e3680d93-0463-42d6-be13-03dd90bb0d8a@intel.com>
Date: Mon, 30 Sep 2024 12:04:40 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: Supporting VFIO on nVidia's Orin platform
To: Michael Williamson <mike.a.williamson@gmail.com>, <kvm@vger.kernel.org>
References: <CACcEcgQq_yxvjAo7BticTw6ne8S2uUjbCFxPTnWHT24oMkxf=w@mail.gmail.com>
Content-Language: en-US
CC: Jason Gunthorpe <jgg@nvidia.com>, Nicolin Chen <nicolinc@nvidia.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <CACcEcgQq_yxvjAo7BticTw6ne8S2uUjbCFxPTnWHT24oMkxf=w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0022.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::8)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SJ2PR11MB7597:EE_
X-MS-Office365-Filtering-Correlation-Id: af3fd9d8-abf7-4bb4-579b-08dce1045d03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eUlYUndud3BvUnFJb3NLZ0hiZVp3SVNQYktSbTd4bXAxQStOcTJrNGxEbVdh?=
 =?utf-8?B?d1dGR3M1cnV0aS9JZnFMd1oxb2pFb2JLeDFlYllLWTVhTmxzTlloKzNLa0s4?=
 =?utf-8?B?NGV4c1c2cnp5T0lJVmhNaW4xSXI4K0JmRXBsV3hjdXBZQkgwUTNPZ25MaHVL?=
 =?utf-8?B?TjNuR1Zydkk4M0FqT2U5WC81c25tbGxWeXVEdUFYY2c4VWlzTWtxOTJJTzAy?=
 =?utf-8?B?V3ZTTXprKzE5STV6eVdjaGlVVWtnM0phNWV1U2NPbUt5Nm5kYi90dFRMMGgx?=
 =?utf-8?B?bWI2UlphcDgzN2FZeW1XZTAwdWhva1JqSlRMZURXcksxOW1XSHhza0k4TG1N?=
 =?utf-8?B?UFZyZ20wNitjZjNPRnN1aTVaemtsVXdML0V3L0VqTEdqanY4OVkwcE9iRzkr?=
 =?utf-8?B?b1l6dGovZUdiV0YvRVRYa1RGWkFVdmZpeGRLL3lMZDQzdXlLTHVhNUw2d09M?=
 =?utf-8?B?OVBvQkt4UldVYmxuYlNKY2c4TFRXdjhJZzBHREFkbk5XejcyamRsM2RXdzRN?=
 =?utf-8?B?SERnamMrRGpMc1hXaWxLTm8yZ2tpNGlybFNRVUhJODY5bk4zRnNRY3lzMm1k?=
 =?utf-8?B?Sm1oTFBXbm40U0hkc25oWGhpc1BadEU0c3FnYmtVNlZYczFqdXpMN2tDQTRk?=
 =?utf-8?B?MStlb2RubHhIMkZ0b1FZQjczY3VzclE0YXFVcWtuQVJyUURHUW51VDhxT2RY?=
 =?utf-8?B?UVRLdVRIS3d1NlBneE5yT3Z6ZDRLTUlKNEkxUjFObmkyeWJ1L0o3L2UzdXk1?=
 =?utf-8?B?MTJJaTFYd0FUZjFLOWhaaXdFclRweTRtZWNiSWVXZlBwdUNGUUNWRWp3ckVy?=
 =?utf-8?B?a0RZV05RaG9EU3BQRVpzTkZTOGpoVTFiUEZId3A4NWdWR3Q5Zkc5UEYxTUVn?=
 =?utf-8?B?QWcyWW5iRkFvZXNCRmEvT0ZxakNCUElCbDFRTC94SS9GdHVuamtISVFweUMx?=
 =?utf-8?B?ZDBEeWdkckZyWDhxbVoyMFFhVEJVemlrdjFlNVkvNktzVWdvS25TMVYvRFIz?=
 =?utf-8?B?Tjc2VnkzdEo4cWlwUWdDbVNkOXpBUS8vQjRtRm1vSjJIRkFzUzQ1bVBkakRj?=
 =?utf-8?B?WExFQlBYSkhmTTVaRFNZWDgvUUtEeGV0WVBtQ2ZRRHBVcFNpc1pBaGtFMXFK?=
 =?utf-8?B?ZU1nU3VoUFpMQjZia2NDc3kzZzBtRjZ2eWhEeExsQlh5dWNrR0hCRlJIRG1I?=
 =?utf-8?B?bW9LU3lUMVBZamhJYmF3WmZjU2FabG1WcGNDbUxsRTE5UnNRUEpTMVRWVldY?=
 =?utf-8?B?TmlCWnJubzNCUEgvTGtHcFRrVGhzZXBZdjYwd1krQU43VDl3dXV0dTBFQzNu?=
 =?utf-8?B?dCtLdHdZUHdQSFEya0hPMFZxM05iODNDTHRkOXFUY2tacDhJaEFVcGxCRlBn?=
 =?utf-8?B?dWhIUDR1YXNueDBsQ21zcTJ6UzhPSmcxMlcyRURzaDY4c1U1RUgrUU9Ibisv?=
 =?utf-8?B?aFlQOVJkYWM0YWNsdXlPanNyRHJaRFh6M1BuS3NodEN0ZlhEaDJhczRvdlBI?=
 =?utf-8?B?RFZuN1cwY3ZRQlRzWVlQYlFpTVJRajJLSWxibHpBemd6bzV3ZHZmUWNjRkVn?=
 =?utf-8?B?RWNhMXFtUHFiWnB6WjY3NnhTMjYrY3BQMEZveUR2aEw3SU9vNjgzR0YyeitS?=
 =?utf-8?B?NTNBNkZFTjRUaUhXOUpQSWxuSE5lUUtzbjVkRkIzNlJWTGFqQjFRYzdHYzJD?=
 =?utf-8?B?M1hJK3dpaTBLM24zR044SXFHRjZLaDNLQkEzdFMvS2QxTVVqREZBbFk4NWFj?=
 =?utf-8?B?Tm41aUF5SlFBS21iZG1UdGhpVWVIeGozOTNJSjR4aythTzZ0ZmdSK1NyMEor?=
 =?utf-8?B?ODNFZklGbWcyOUVTZGVVQT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z0lyeFFqOVlhRENDZ0xTSGJVSk5OZnd4R1kzR3hJaEdDQ1ZNVWhpdDRQeVR5?=
 =?utf-8?B?UW44VWk4Y3ZQWW5lZnF1SkhzSlhsVnFLenhqbCtQNVVmVk1kaytTMGJHa1JG?=
 =?utf-8?B?RDRzdWN3ZEE1dDVUamJsc1RyT1JTNkpTYzNBQ3JOZzZMY3B0ZGxBSW5EaVdj?=
 =?utf-8?B?Rk9kcTV0dWJCWE11U01YRExGdVJOUVRzRUVncUZSb2tQYTVCTU1iT2xjdndz?=
 =?utf-8?B?RjFNV3NpZm9YelZuQnl4MWlMYm45QU5xM1JxTkhMQXl4RjN3M3NOdWozVlJS?=
 =?utf-8?B?VDVrc0VyQUNMZHI4NEZYS081SmJEM2lFN2hBekNoL2R0bC9jNDhtWWx0OGVm?=
 =?utf-8?B?UWVxbVJlVnBjV0ZQTHcyOE5IcFREQjBFMmJ4eFAvckRSNzNJNGNQL3dZZVhH?=
 =?utf-8?B?cmNPWkVOZUZFSGVQdzFSREE3eU5OVWpSQWxteVN1ZjAxaFhob3FtSmZxRlNi?=
 =?utf-8?B?enZUUHNOaURXODhpZ3NtdXBKdDVRaWdobTJUUDgrQldZclNqeHZXaThBaDlS?=
 =?utf-8?B?aGVDL25Iay9sUHU2WW9aZmsvd0M0UUpENWlpVFU4ODdHN0w3WnhBbHVIdXlV?=
 =?utf-8?B?akR0UWJpT082cXo4N3M4WVNrSzdLNTBUdzVDSENkVVZBWjhneG1rVGJGWHZH?=
 =?utf-8?B?RVZweE90aFB6M2E4U1Y0TGUwR0R6d3lsT09ibkhTLzJKKzB4SzZUbjZkamQ5?=
 =?utf-8?B?VEc5enQ4SnJLeDdVdGVITkhHdDdLaENDZEE4YzFidTErK0tyVkpwMlMxUmdX?=
 =?utf-8?B?WjFVZU81My9DSU0yKzdDUEdKaUpNaG9Id0V6LzVIUjZmTkVjWmZVVmFwUGUr?=
 =?utf-8?B?bmRqOW1uOHg4YVpIM1RjQ2RSYW01aFZvaVY0aDB3N3RsMjhWQVEyM2YySDNo?=
 =?utf-8?B?RmJYZ3dtbmR1UzRCRldIbkVSZDNBWE96R0Z4UWMvUXB1NVV5b3JicDFHL2Vq?=
 =?utf-8?B?ZnM0aDlmN3RueW5DWnNlbWkweXJHSy9nWWQyTVRleG56WGlaeUwxNHkrZW96?=
 =?utf-8?B?MzJzMTVjaWtYUkZ2OG9UU0phQTl6SDhROThNLzdESUpLMSt5RFJxQWZHcDJX?=
 =?utf-8?B?OW01eUdpbmcxOHdGbzdxVGlGa25jNHN2TkR5Y2NoSWhrRWl4NCtMZWRoVnBS?=
 =?utf-8?B?Z0hUNGYxL2hUc0QwdWtlQTF3Qkw2YkcwbDBtQzB1VUNpTy9yUUZtaTc4OEdG?=
 =?utf-8?B?ZmtkOUlZdEF1bDdWSGJhYzV3WC9rKzh2bURCV3RZS2RGcUFDOUJ0L2dtUUc1?=
 =?utf-8?B?WmsrSld1R0F1aGNBN2UvS2Z6RlN3N0M4azNUMXhXbUpBQlFXMU42QWRzUHZY?=
 =?utf-8?B?MDlORHhyRExuU1ZUWk54WkN0WU85WW5Rb2JWWlk4T08yWjM5NXo0UEN0bmpQ?=
 =?utf-8?B?VDlDZ1o2MFJMb3hzdk1Vdm8yRXRhS3ZjSWdub25VWCtFWlJUSTFxTnpRVEpR?=
 =?utf-8?B?ZUgwNCtDQ2xrS2ErQ0ptM0NWL05zRkFxTS90RDBTVk1zN0lreEdVekc1Uy9K?=
 =?utf-8?B?ZkY5Y1U2akc3bTlXcG8xWlNhQUxyNG9qUkFXbm9hMTl0cU8yRGJQMWxmZ2V0?=
 =?utf-8?B?cnk4SGZwQUkxQWZIY1BsckpFanh0eUNaLzJ3QzZrby9keWttREtGS3VCaG1R?=
 =?utf-8?B?anBmcUE0eWZGVVA4d2l0TE5CY1dtVU9tKzJnNittd2dpQ1NOYWhPNG5mRUNm?=
 =?utf-8?B?aUxNRzdsazdlWndDeVJKd0xCTFNyVFVJQVBuT3ZUNkhHM2x1Q1JTRkFzamJr?=
 =?utf-8?B?RXhBT2d0UUZ1RFdicHBsYWdsVVhTL243QUNLVENxaWduK2Y1RUd2bWxEVXNB?=
 =?utf-8?B?blk4WnhlZGM1amRibXhXNlVlb3JMT3dybVdFVlNtOGdaZkg4T2lDNVh5MU05?=
 =?utf-8?B?Zng5aXFZZlZRN0RySWp5eU5EQ1FIS1pvOC9yM05QSjhUQllpdzBzWWx0UkhV?=
 =?utf-8?B?ZUdDaEJtNndQeEkrdzFGUWJIRnM2OHNqZzR3YkR0THBSKzlBbVhuMVU2OTlH?=
 =?utf-8?B?ejVubjUwbTN1WENyY2cxNXlGMWNDWnNXbXlwOFo5WVZuOXZEdzJxUEZIdDNU?=
 =?utf-8?B?RU01QVZ5N0VCbzFsZ0lhaGFXeDBSWkFzRFcwNHcyS00vMkVhRXR0NzR3YzZX?=
 =?utf-8?Q?Tof/u7ObakQJGeYQ+pLtOboQy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: af3fd9d8-abf7-4bb4-579b-08dce1045d03
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2024 04:00:03.7561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mtxsu/1v6O5AhjDwmeifT5LxyX7bqF4yzjHGDMj1whoijgggPhbfOXX3K/TI4kcpAGyKP361dLKIqAw5fKboQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7597
X-OriginatorOrg: intel.com

On 2024/9/29 23:02, Michael Williamson wrote:
> Hello,
> 
> I've been trying to get VFIO working on nVidia's Orin platform (ARM64) in
> order to support moving data efficiently off of an attached FPGA PCIe board
> using the SMMU from a user space application.  We have a full application
> working on x86/x64 boxes that properly support the VFIO interface.  We're
> trying to port support to the Orin.
> 
> I'm on nVidia's 5.15.36 branch.  It doesn't work out of the box, as the
> tegra194-pcie platform controller is lumped in the same iommu group as the
> actual PCIe card.  The acs override patch didn't help to separate them.
> 
> I have a patch below that *seems* to work for us, but I will admit I do not
> know the implications of what I am doing here.

your below patch is to pass the vfio_dev_viable() check I suppose. If you
are sure the tegra194-pcie platform controller will not issue DMA, then it
is fine. If not, you should be careful about it.

> Can anyone let me know if this is (and why it is) a bad idea, and what really
> needs to be done?  Or if this is the wrong mailing list, point me in the right
> direction?

this is the right place to ask. +NV folks I know.

> Thanks,
> Mike
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 818e47fc0896..a598a2204781 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -638,8 +638,15 @@ static struct vfio_device
> *vfio_group_get_device(struct vfio_group *group,
>    * breaks anything, it only does so for user owned devices downstream.  Note
>    * that error notification via MSI can be affected for platforms that handle
>    * MSI within the same IOVA space as DMA.
> + *
> + * [MAW] - the tegra194-pcie driver is a platform PCie device controller and
> + * fails the dev_is_pci() check below.  Not sure if it's because its grouping
> + * needs to be reworked, but I don't know how this is (or if it
> should be) done.
> + * This is a hack to see if we can get it going well enough to use the
> + * SMMU from user space.  The other two devices (for the Orin) in the group
> + * are the host bridge and the PCIe card itself.
>    */
> -static const char * const vfio_driver_allowed[] = { "pci-stub" };
> +static const char * const vfio_driver_allowed[] = { "pci-stub",
> "tegra194-pcie" };
> 
>   static bool vfio_dev_driver_allowed(struct device *dev,
>                                      struct device_driver *drv)
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 66bbb125d761..e34fbe17ae1a 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -45,7 +45,8 @@
>   #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
>   #define DRIVER_DESC     "Type1 IOMMU driver for VFIO"
> 
> -static bool allow_unsafe_interrupts;
> +/** [MAW] - hack, need this set for Orin test, not compiled is module
> currently */
> +static bool allow_unsafe_interrupts = true;
>   module_param_named(allow_unsafe_interrupts,
>                     allow_unsafe_interrupts, bool, S_IRUGO | S_IWUSR);
>   MODULE_PARM_DESC(allow_unsafe_interrupts,
> @@ -1733,8 +1734,18 @@ static int vfio_bus_type(struct device *dev, void *data)
>   {
>          struct bus_type **bus = data;
> 
> -       if (*bus && *bus != dev->bus)
> +       /**
> +        * [MAW] - hack.  the orin tegra194-pcie is in this group and
> +        * reports in as bus-type of "platform".  We will ignore it
> +        * in an attempt to get vfio to play along.
> +        */
> +       if (!strcmp(dev->bus->name,"platform")) {
> +               return 0;
> +       }
> +
> +       if (*bus && *bus != dev->bus) {
>                  return -EINVAL;
> +       }
> 
>          *bus = dev->bus;
> 

-- 
Regards,
Yi Liu

