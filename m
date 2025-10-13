Return-Path: <kvm+bounces-59890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ADF2BBD2D04
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 13:42:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68E513B41C8
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 11:42:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 764E026158B;
	Mon, 13 Oct 2025 11:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PgQZHPYd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF77834BA57;
	Mon, 13 Oct 2025 11:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760355749; cv=fail; b=h89T7E6ii6G1xKLhEksaXgrKy8DOS1Qd3i6vVi2n5IGD+G2venPDEJ2t6DWLz0jU+0a1+TO6xNWlAVHQtfiyj/viRPyIohSqiTLmoU3lvNXIf8+ELvp7a14q7gUN0ncMFqSv50uQP1chh9NX2B9qSh3Bo03ZQQz0YkpZiRkzoaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760355749; c=relaxed/simple;
	bh=pdlsQGhaaP87I8p27h8oktxJrkfNNiPVUlamc+s4OFU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FUPwC2GkyTPcrKCee8njSPlYuYTHPwSSHxKdIKRaAgvAqSnVDXj5lNKZhkHG5vLLYpAC/kRrwtMEikviwugVH5GKzjCf/ngDt9u4yLLFo2W1uSsJIH1p1XZI6YNwv1KLfT6xAvKywhKNPNnaoq75jTZgN6Fm+eT9mm+0BmUVukA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PgQZHPYd; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760355748; x=1791891748;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pdlsQGhaaP87I8p27h8oktxJrkfNNiPVUlamc+s4OFU=;
  b=PgQZHPYdeHUWWsyHomksKmR0e/kHyXjm+Zn3dELMvFsdbRqG3j5lE/+r
   /X2M1oRHYUmjYYHTQImv2enk72Rvv2d8NUu++Qw4HNPHDM6JooOAKXjhA
   uZuAqN9dX7AAeWkPNiavd0euNMriDX/Ig1LnuZTJV46f0TmV9vD6uoUqr
   b3h0NTrEoShwEiRBo9CHDSzTqPpuRNDyBEu7TOOuq5o9ZhesYzavYJMZC
   8jiMzdepffZ5UiBASycwLh3y9zdGV+QAR4/ZTY6Yv2mMRacdORvLn/3fN
   7t1TBo/e1OMQdcVutk3PZ4hshmT49qQDDpdHYnNJdc0A2mn+tSC3TYjpG
   g==;
X-CSE-ConnectionGUID: dGWtcJj6T4a+yHq3uCo+XQ==
X-CSE-MsgGUID: wiuEq7MwTV+oKMutTtEFyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11580"; a="62644926"
X-IronPort-AV: E=Sophos;i="6.19,225,1754982000"; 
   d="scan'208";a="62644926"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 04:42:27 -0700
X-CSE-ConnectionGUID: G8mu9SycTGGlwagnKk6obA==
X-CSE-MsgGUID: 25LxfYAsQXOL1SUsb3nDQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,225,1754982000"; 
   d="scan'208";a="212537779"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 04:42:26 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 04:42:25 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 13 Oct 2025 04:42:25 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.15) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 04:42:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qVv6EVoUyWdO2DEpjzeSzIUIuYaW7o4CHQzpT0U/hY0c6L1rb829rzuJWxbmEiTc0ydn0clhMtsX8teNc3cVj0lNyfS8F6go4jcDjVUsJ1tklpaCmkKdDrgLhUPFusE5VYYz75xg4J68/Qzs1ZT8MDfSLU1oHC+Ie7DjUN/wCdepc8mstRTsnbZsGDJOKK8kSARmS9SEbWirOvId1PLSh/jWV/lBlFtBw69mV9SeSze3vFImeHc+2CP+b3MNHTeWNY/3DZfdYSanzdqUlq/ZLmz00nSRK7d03hSEkgdSkMAzHB3foTZCWfaGxG6nvAK9nmI7mIImn2FZqUez+Axwlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qWnn3DIoeyT1zCg47q98uChQCKmdtvsLqEwzn1gTaIg=;
 b=ckeGacSJQIUMRyZamMcMkzCFjLCPq0s2sJIiLyIDmTzABkR0PwDJC66LBAMjx26EtDkWDnglb1TLMXeYTchOF7hV7imhH3oI8aXJUi0wFVOsdgHgkck0zoMHr3B3jWSKMGs5kFTXowsnsM2bLU6d/sixj9yaO9sD0VMX00bfUbqea+WPCS7tCpeb3RhsEXcr4yzIdmJ63qgGHcutfDqsn5opmlu4q7vhYaNW8VQnS+bm+78HTqt0xA00kOavAvRAxqKwt97zXZCL5C/xYR+42IXkrzY4bmw6WW0NaP5JNsN5o37nMGfjfsqVCWaqXc0HbAfGmMCtTH4hneHHSKieiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6011.namprd11.prod.outlook.com (2603:10b6:208:372::6)
 by IA3PR11MB9157.namprd11.prod.outlook.com (2603:10b6:208:57b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Mon, 13 Oct
 2025 11:42:22 +0000
Received: from MN0PR11MB6011.namprd11.prod.outlook.com
 ([fe80::bbbc:5368:4433:4267]) by MN0PR11MB6011.namprd11.prod.outlook.com
 ([fe80::bbbc:5368:4433:4267%6]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 11:42:22 +0000
Message-ID: <6840c1d2-6513-43e6-b924-b6b0e7aef049@intel.com>
Date: Mon, 13 Oct 2025 13:42:16 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/26] drm/xe/pf: Don't save GuC VF migration data on
 pause
To: =?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, "Alex
 Williamson" <alex.williamson@redhat.com>, Lucas De Marchi
	<lucas.demarchi@intel.com>, =?UTF-8?Q?Thomas_Hellstr=C3=B6m?=
	<thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Kevin Tian
	<kevin.tian@intel.com>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, <intel-xe@lists.freedesktop.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: <dri-devel@lists.freedesktop.org>, Matthew Brost
	<matthew.brost@intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, "Joonas
 Lahtinen" <joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin
	<tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, Simona Vetter
	<simona@ffwll.ch>, Lukasz Laguna <lukasz.laguna@intel.com>
References: <20251011193847.1836454-1-michal.winiarski@intel.com>
 <20251011193847.1836454-15-michal.winiarski@intel.com>
Content-Language: en-US
From: Michal Wajdeczko <michal.wajdeczko@intel.com>
In-Reply-To: <20251011193847.1836454-15-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1P190CA0042.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:1bb::14) To MN0PR11MB6011.namprd11.prod.outlook.com
 (2603:10b6:208:372::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6011:EE_|IA3PR11MB9157:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d0e8096-5f3e-4cab-a131-08de0a4d92cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MFBrY0hHVWFrQVdrWHVNU0ZRKzBRVTdWcFdSVWFidWRPVEpBdXhaUFVSREd4?=
 =?utf-8?B?N0tXMU9PUjNhcGY4OFFmeElLMVhIRTJyK3FHR0dGRXlUeFV0Sk83a2RkY0x3?=
 =?utf-8?B?bWpBWDZJWUh2VzBod3JjbTFIa2cwTVlvaEtFNGs5cWNtMjFiMzU3cEtyYnJG?=
 =?utf-8?B?ZDBJU1hMc2NwWnBpTWphak1tZGZoTmNMdTNCNkpKcGhwaUtmaGJ4RXBML3BG?=
 =?utf-8?B?bWpQTURIUUtOTkJlMGdEc0Q1U3c1Y2dCOXlRTFdXd2g3cVhVWnc4MlZZRm51?=
 =?utf-8?B?enBNRWJlb2laSFc2QkgzRkJQTVdSelRSVG96VXJhN0xuUFM2UVZLOWNLVE5s?=
 =?utf-8?B?K3o2TzdYbXVYWTZuejRnUGd5ZVl1QkFvV1hKQW5jU1NjY0FDRkV1MzNuWUhy?=
 =?utf-8?B?aTRjR1htRHZmanZDeEU5M1ErSThkcCtiVW8xeGN3ZEFHb3FnWURHUU11Zzht?=
 =?utf-8?B?cCs4RW1hbHovemN6TFY0OHRrNmNGTk53djVDQmxySDZIRWdFbFhNelNnb3Zk?=
 =?utf-8?B?WmVCQUhxNkwxNFpRaUxNVzc5djhLbnVtUml5VmZWdEo4V0x0SlROdTVsQ0Mz?=
 =?utf-8?B?d29EOUoyUlE2ZkM5anE1dGhyTCtzTEd1UlVBeFExNEJBZmZlWEJZdGJYQ2Vn?=
 =?utf-8?B?enpRV2Nib0FHRTNyVDVZLzhWWEJVT1dXcWxMTTJFcldFSzNTeUluYTFSckdn?=
 =?utf-8?B?Q28wTExoWHYyWUU4Q0tYU0FzUmlWVHRaZTVJeFNhTzh0MWxiMm5iT2J1TUhG?=
 =?utf-8?B?VnZYU0tPQjVlU2JtcWpQZEF2N0xBRHZvOHd6Qm1La1VIL1lxRkd3NHUvOEhs?=
 =?utf-8?B?RVRhdUJsbVVaNG9SVEYvZ3IxcGhUUzRDWFR4cVVNZG9Wc2N5WXIzQ1AxbndF?=
 =?utf-8?B?N2pvY0ZGZzVJNEx5aEJpSW1DNEVlZVcxekJmajVIa0JMUTN0dVZwNUNnNzZC?=
 =?utf-8?B?dnFyckhsMnAvbm5kd1ZleGhzVzR3NGN5MXFXQ3Bsci9DcFV4bVBQMHNuSlJ4?=
 =?utf-8?B?MGpkbnkzbDF6aU1RbUthOE5DYldXaFFLTHkxVVlCczY0dEJkRTE5ZVVOQ21i?=
 =?utf-8?B?K0dnakdBZlVuYllGcEJmbjhmK29XQ1g0MzV0VG5nQk5TaWlQckVOUDI2dFlz?=
 =?utf-8?B?Q0NsYURVVUI5NUxpRjB0OXJISExjYnpTUzRXZVZEck5KK3A2QUI3QUNZQm1M?=
 =?utf-8?B?dENURS9kUFdESWM5Z1B5TWNMRGRHWUZpMWpPcmUwdHVhNmVPQ2VYZG1MRXJS?=
 =?utf-8?B?eWg5VEE0cGZ2TkZBRDY0RXNBRmRPUmNkNWFINGt2TEtZK0pvVzBOQ1pRVUdQ?=
 =?utf-8?B?bzc5Nm12djNtSzZHU3NsZWJxMnlJU2lWenUrRHhIcmlIMWlwV1hSc2R3elQv?=
 =?utf-8?B?NGthaldrK2tjVVhvaVBzY0EwZ2VwbDE1N0NybmZnZ2RzKzVmRGY3L3lUSFNB?=
 =?utf-8?B?aHJjeVBrUzRxVnpiSVp1ckJRTWdjTW9CcC9hZFRPV3loNitzd3pSY1ltOHY3?=
 =?utf-8?B?VkhVRnVQUXBwRllyU09IMVFxd1E1dFZIYnA2OVM1Y0drUHBTSHFDbTU0QS9u?=
 =?utf-8?B?Tm9EUm9jT2JrbUVjeGxnTjJPR3BQM3VKM0dOODdRUFRCcFpyaU9tQ2ZrYW9l?=
 =?utf-8?B?R2V4bWg5QllFY0hJUEpUdjM1VUlRaG1mOFhZRHNySGZVS3FjTjhhaTFVU1RP?=
 =?utf-8?B?aXVOL3VON053SU1LY0tZQ3VoeTFNZDJyYTVyOHNHckZMZjZrRlZNcWdDV0M0?=
 =?utf-8?B?MUdZTFBQYms0K0xidEJPUjJteC9YaEVjeDhtbi9NbE5vTjVkV1RoTTdmTk9M?=
 =?utf-8?B?U2VCWFNuR0dkOVB6TExEMjJ3a3lQWnV2aW9uNFM2bWhuanB5Q1gvLzkrY0U0?=
 =?utf-8?B?N3gzYzhUVEZmbmNaSFVuYUl4TmNXYXhsRWc3Qm4yYUtwYVE1dEh6Um1LMC9r?=
 =?utf-8?B?MjdRVVU5Z0FBSXc3NmhDQkRaN05vT0FjSGljcWxlQkpHUys5Tk5PNkdhd0dK?=
 =?utf-8?Q?pSlUzD/tHbbVoJ5QIDRl2bzRliC5II=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6011.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rm1BQk40VDhKdnp4RGhDZXZuS3Z5TFRoRWovUUJSb005UTJ3YVVDQjh0UWVY?=
 =?utf-8?B?cW5wejQxR21IVVowRnFPbEZCeWJqT2orYUtUekJjOXh3c1AycFN6S0s4NS93?=
 =?utf-8?B?SkcvZUNHTzducXRGQWcrM05pbnpDVWk3czNva1RqSytFSFhJWkVYaVVtTi9T?=
 =?utf-8?B?ZDhaRFFpamZ2cVkyLy95UVU4aytUemQ3aks4Y2NaUStxYVBNbzJKVTk1YWdR?=
 =?utf-8?B?VVVBYitVNlJieFFlU1J0VE1JTjdIdzltMzMrdk5jRVR5WW9TbE02Z3M3TjZQ?=
 =?utf-8?B?YlliR3k0SUdkbXJpVDNONzdlUlZrRlVNY3FSdjdSMXZ6VFBFaGgvZzNXRWNk?=
 =?utf-8?B?UVRrM3YrRXd1Y09HeGpVdGV1c3IxTEFsL3hOWENPUFVOMFlRdTRMVnlGZ2VT?=
 =?utf-8?B?ejJVenJhNkFhcXNjeDFkNjRvSnpxMWZDVG8zS1BYaUpDVGpmak9DcmNoQXFO?=
 =?utf-8?B?M1JIYXl4blZMZWdoRW5IaktNNkUwcDh2Y3FOUzk5TW5nbUlOYk5tOWxWUVlz?=
 =?utf-8?B?ZVMzZEJGRmZpalRHU0JJSFA0dkRlOFoyMmRtc2hkTnBsamlmckc1N1p3TzJV?=
 =?utf-8?B?ek9MdzhMeUk0SjQ1UlUxUGduKzNXVFNLbmZ3SGpEOFQwMDEwNGVrek0xVlpw?=
 =?utf-8?B?QUFRQjUwMGVINkphb3F2ZFlkMG9uRzhqM1VlMC94UXBpM24wbzFIcFpMTXp0?=
 =?utf-8?B?WEczQ0d4YVVQM0RuMlM1ZkV1L1NOOW1Xc0xqaWJVMnVuVlFNSWVOZHJUWVdY?=
 =?utf-8?B?K2kyNm1mcmFQSi9ZbVhEVzZnQi9Kbzl4K3ZQY1hBUUhJaDJiazB0UVBySW42?=
 =?utf-8?B?UnJKZG5aVlhubGNzQ0VXUFdVMGhMckp6VnRnQ1N0UnhqUUNlRHVMSFVIUUJP?=
 =?utf-8?B?UlhmbmZhNFNFcDFQaVp4enBzSUt6dy9OWjY5ZEhpcTQzS1dUOXlNbm4yUEZF?=
 =?utf-8?B?dHpwcjZxeTg5bmdJZitwbkNnbjlxSUtnSzJKeWJjSThCRmxrWGpYNlNqVnN5?=
 =?utf-8?B?WXB1b2tpUlhFbjZVMGhkVFBiQ2llT1prV1VXVEVOeHBNZ0Z5UWFtUWUvSnlh?=
 =?utf-8?B?eGNkTzdDbXNEdjhHTFgwUWYwRkh3VGxheisydHl6RjQ0ZWJyOEd0U0ZkSnJj?=
 =?utf-8?B?TkEyU1NNNmdTQmhkUU85WStuZmc1dGRPWml2MDI1cC92QnY3SitKLytZTUl4?=
 =?utf-8?B?anJ3Z3pETHVjOGhJTUlMaXlmaFIyRnArYXErak41VmRNUVhvUUUxMUJEbnJR?=
 =?utf-8?B?NWJ4Y0NwQitDQkIvS3QwK1BIQ1ZkN1Vud0x4SVcwR01qZFR6U0JPMUZTRnY2?=
 =?utf-8?B?VUk2ZzdNZmR1NHlKem01aHk4STlWcXptbFMxOGYyOHIwTkU0VXl4SDAyWTQw?=
 =?utf-8?B?RkpWNkdQMzArQmhEVVN1TFF0T2gxWEVzUTlrcEg2VjZtWURZWGN2b1d5cjBu?=
 =?utf-8?B?TTlBdkFvUytaUitNbE9QY1hkQ21IdStDS1JVdTVNelRqSitReU1pT0wxMDBw?=
 =?utf-8?B?cjZXNnM2TCs5cEVZWHpuRU1OZnkzbVZjL0c0clExQ2ZMdjQ2TFhBUGhYZWhl?=
 =?utf-8?B?TU10K3IyZDBRbGlyWng1WXFzUWNDWVZqMnlVaW1GdmtVYmFqQXZGV1lncWl6?=
 =?utf-8?B?L25meFJwSHJGQzlDeURWTkExY1NjRXJEaGRwODd4ajZqOFJhV3BkdS8xTHQw?=
 =?utf-8?B?bDg0VFMrTkRWL3F5dmJvS3hHOTJIQ2VnR3JxNjgzc3hRSnhUMGZwNFZublhY?=
 =?utf-8?B?RHVKY2gyV1FtMGNyRC9qajhNMFpTVDFFNzBrVzZFSk8rNTNLdEsvRHk2N3Jw?=
 =?utf-8?B?RlRxQittSlZNVjdxTkFXUTRnVmNXaFZTMHd6anJQSkRHaEdNR1lncEpLdUR0?=
 =?utf-8?B?a3RJNGl2M2d1b0Y5ZTJFWFNEUlBEMGxOZjZxcjBJemhia1AzaWdtd01sK0pM?=
 =?utf-8?B?QmZkVENkL0RRUlJIYTRWOURhUFd3QTdGWkcyRi9rT1ZMRE5Mams5OGF6ZENS?=
 =?utf-8?B?N2FuYTQwSlRtQ1dBM0JvclIybmlIWlFhb1haQVBLNE5qUVl5RWhHeFJSRkRW?=
 =?utf-8?B?YmRYNitEY2JjWG0ydThlU05mWXhsRHUxNVFzaXlxR1BzellDVU9hOGU3VGdG?=
 =?utf-8?B?V3NtMkIzWlgzUk1hRDZQZ256enc5RWd0OFhsYkk1N1pYQlRSc1pmVW5zYzZx?=
 =?utf-8?B?Z2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d0e8096-5f3e-4cab-a131-08de0a4d92cb
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6011.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 11:42:22.6245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ix/ZtHD72CwVogWGP2ahS72rU0a1XncP3FK/RRlVpoHyF3+OdH44DevCUzGLdq24gVaumAuHOJt51q7BzJK7s8CMbkNjgJZYZ5zRKuuLjNY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9157
X-OriginatorOrg: intel.com



On 10/11/2025 9:38 PM, Michał Winiarski wrote:
> In upcoming changes, the GuC VF migration data will be handled as part
> of separate SAVE/RESTORE states in VF control state machine.
> Remove it from PAUSE state.

still waiting for the full SAVE/RESTORE state diagrams,
but that split makes sense, as this extra SAVE_GUC step was for early-debug, so:

Reviewed-by: Michal Wajdeczko <michal.wajdeczko@intel.com>

> 
> Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
> ---
>  drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c   | 39 +------------------
>  .../gpu/drm/xe/xe_gt_sriov_pf_control_types.h |  2 -
>  2 files changed, 2 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
> index 092d3d710bca1..6ece775b2e80e 100644
> --- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
> +++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
> @@ -183,7 +183,6 @@ static const char *control_bit_to_string(enum xe_gt_sriov_control_bits bit)
>  	CASE2STR(PAUSE_SEND_PAUSE);
>  	CASE2STR(PAUSE_WAIT_GUC);
>  	CASE2STR(PAUSE_GUC_DONE);
> -	CASE2STR(PAUSE_SAVE_GUC);
>  	CASE2STR(PAUSE_FAILED);
>  	CASE2STR(PAUSED);
>  	CASE2STR(MIGRATION_DATA_WIP);
> @@ -451,8 +450,7 @@ static void pf_enter_vf_ready(struct xe_gt *gt, unsigned int vfid)
>   *	:       PAUSE_GUC_DONE                          o-----restart
>   *	:        |                                      :
>   *	:        |   o---<--busy                        :
> - *	:        v  /         /                         :
> - *	:       PAUSE_SAVE_GUC                          :
> + *	:       /                                       :
>   *	:      /                                        :
>   *	:     /                                         :
>   *	:....o..............o...............o...........:
> @@ -472,7 +470,6 @@ static void pf_exit_vf_pause_wip(struct xe_gt *gt, unsigned int vfid)
>  		pf_escape_vf_state(gt, vfid, XE_GT_SRIOV_STATE_PAUSE_SEND_PAUSE);
>  		pf_escape_vf_state(gt, vfid, XE_GT_SRIOV_STATE_PAUSE_WAIT_GUC);
>  		pf_escape_vf_state(gt, vfid, XE_GT_SRIOV_STATE_PAUSE_GUC_DONE);
> -		pf_escape_vf_state(gt, vfid, XE_GT_SRIOV_STATE_PAUSE_SAVE_GUC);
>  	}
>  }
>  
> @@ -503,41 +500,12 @@ static void pf_enter_vf_pause_rejected(struct xe_gt *gt, unsigned int vfid)
>  	pf_enter_vf_pause_failed(gt, vfid);
>  }
>  
> -static void pf_enter_vf_pause_save_guc(struct xe_gt *gt, unsigned int vfid)
> -{
> -	if (!pf_enter_vf_state(gt, vfid, XE_GT_SRIOV_STATE_PAUSE_SAVE_GUC))
> -		pf_enter_vf_state_machine_bug(gt, vfid);
> -}
> -
> -static bool pf_exit_vf_pause_save_guc(struct xe_gt *gt, unsigned int vfid)
> -{
> -	int err;
> -
> -	if (!pf_exit_vf_state(gt, vfid, XE_GT_SRIOV_STATE_PAUSE_SAVE_GUC))
> -		return false;
> -
> -	err = xe_gt_sriov_pf_migration_save_guc_state(gt, vfid);
> -	if (err) {
> -		/* retry if busy */
> -		if (err == -EBUSY) {
> -			pf_enter_vf_pause_save_guc(gt, vfid);
> -			return true;
> -		}
> -		/* give up on error */
> -		if (err == -EIO)
> -			pf_enter_vf_mismatch(gt, vfid);
> -	}
> -
> -	pf_enter_vf_pause_completed(gt, vfid);
> -	return true;
> -}
> -
>  static bool pf_exit_vf_pause_guc_done(struct xe_gt *gt, unsigned int vfid)
>  {
>  	if (!pf_exit_vf_state(gt, vfid, XE_GT_SRIOV_STATE_PAUSE_GUC_DONE))
>  		return false;
>  
> -	pf_enter_vf_pause_save_guc(gt, vfid);
> +	pf_enter_vf_pause_completed(gt, vfid);
>  	return true;
>  }
>  
> @@ -1788,9 +1756,6 @@ static bool pf_process_vf_state_machine(struct xe_gt *gt, unsigned int vfid)
>  	if (pf_exit_vf_pause_guc_done(gt, vfid))
>  		return true;
>  
> -	if (pf_exit_vf_pause_save_guc(gt, vfid))
> -		return true;
> -
>  	if (pf_handle_vf_save_wip(gt, vfid))
>  		return true;
>  
> diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control_types.h b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control_types.h
> index 02b517533ee8a..68ec9d1fc3daf 100644
> --- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control_types.h
> +++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control_types.h
> @@ -28,7 +28,6 @@
>   * @XE_GT_SRIOV_STATE_PAUSE_SEND_PAUSE: indicates that the PF is about to send a PAUSE command.
>   * @XE_GT_SRIOV_STATE_PAUSE_WAIT_GUC: indicates that the PF awaits for a response from the GuC.
>   * @XE_GT_SRIOV_STATE_PAUSE_GUC_DONE: indicates that the PF has received a response from the GuC.
> - * @XE_GT_SRIOV_STATE_PAUSE_SAVE_GUC: indicates that the PF needs to save the VF GuC state.
>   * @XE_GT_SRIOV_STATE_PAUSE_FAILED: indicates that a VF pause operation has failed.
>   * @XE_GT_SRIOV_STATE_PAUSED: indicates that the VF is paused.
>   * @XE_GT_SRIOV_STATE_MIGRATION_DATA_WIP: indicates that the new data is expected in migration ring.
> @@ -66,7 +65,6 @@ enum xe_gt_sriov_control_bits {
>  	XE_GT_SRIOV_STATE_PAUSE_SEND_PAUSE,
>  	XE_GT_SRIOV_STATE_PAUSE_WAIT_GUC,
>  	XE_GT_SRIOV_STATE_PAUSE_GUC_DONE,
> -	XE_GT_SRIOV_STATE_PAUSE_SAVE_GUC,
>  	XE_GT_SRIOV_STATE_PAUSE_FAILED,
>  	XE_GT_SRIOV_STATE_PAUSED,
>  


