Return-Path: <kvm+bounces-42115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC580A73211
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 13:11:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F70D3BE25E
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 12:08:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D99AD2139CF;
	Thu, 27 Mar 2025 12:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GZXGQ+A5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0372135DF
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 12:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743077339; cv=fail; b=mdSf7PqSkupSultD6d8WoRdEirbAvROuVFNrXYO4BhLwTqaaqlbCHsgX8talUoEvcYb9Zwj5nEABRAQ0uTEJ8zeOp2IO+XXyKAnlRuzdTFhH/kftdegAbESG1gbmi7BuUBuoNmB0Iw1iej5zkULUDeTrQue83iXkKqHtQhsgG7c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743077339; c=relaxed/simple;
	bh=OIs31qRytfdn5wcr5E35tYX/KMVunmUnjXGFGYR/gN4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aNrUI2H4Pp5aLMpche3ehW4h0MMueEB7abo4nZIvbAmO7mg1BkVNLMsbVofNOIHj7iUiMnvJovfhonkSmWuvL4WuHYILJ3214Ow60rSsHAyZT5Meb/n4+aTBMb0wwEtT5Pj+uPcBFuiRC/yjJIH8HCjVhU8wvmyGfI9uqir4uMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GZXGQ+A5; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743077337; x=1774613337;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=OIs31qRytfdn5wcr5E35tYX/KMVunmUnjXGFGYR/gN4=;
  b=GZXGQ+A54lRHS4C6dAsiTGRlTDP+Evk2ecvc9sG4oB0+61SyBp70tNHa
   Ey6eRhQ/924K6HJmlADTwXX+nNrRnMPqHDCpCk6B6IsUZqOKbEtZarD7B
   4aRw8a+kCewg3Aeh9BFZdMz4qj+T8i+jLSyPOwVwVbyfaaoK4ZzrNv8Y0
   dUGSQ3C1aO0P2kd691WyzTWF1qb0F2JXNTuxK5vNkqeHKEUimr2fECcr6
   z82m7jClbOXNL8u+R+l3DVYYuMJyWOohRs7IkccuCqUwJOWAN5AAyRxAp
   /EsiNsOrxXj8ElB8WjERxEIkB5pIvrSDNjINUq1qlnrT1fvgVJEEanK2G
   w==;
X-CSE-ConnectionGUID: XI6C74RTQ0GocE4nHYQTaQ==
X-CSE-MsgGUID: 6wzdbBpqScauIVFI/NqZVA==
X-IronPort-AV: E=McAfee;i="6700,10204,11385"; a="44528372"
X-IronPort-AV: E=Sophos;i="6.14,280,1736841600"; 
   d="scan'208";a="44528372"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2025 05:08:56 -0700
X-CSE-ConnectionGUID: mt+01DBuSvatubLSMwdIrA==
X-CSE-MsgGUID: VFqXAQngQIaIYG0g1LIECg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,280,1736841600"; 
   d="scan'208";a="148308868"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2025 05:08:56 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 27 Mar 2025 05:08:55 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 27 Mar 2025 05:08:55 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 27 Mar 2025 05:08:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qjL+tJcNKARwE+Bz1EVmi8Dv3iXdZHA2S1I5tqZboFWh6tPj5BOlKn7VLywuCY63BbUG/eKUC1TivaaeJ3srfqXLirKmRtYWOvzyPj5DryuciRoB+qmTkpxeGeb11xlkeWn9fv0A0LWq/t6l3JAU8MGOhzsG8OMYgZZma36Q54UPLZdT3/YmF8FOZTZS1nrCm6tdqHxet2hT9DepN9fy1Rx4c2KG0rJVstKuWxz0L5XJB4W+J3f/i75CVNwrt07715k/TvYB1FHAq7T4YlYTcObrL7GdXT0nDX9pihss3aY/gd5b74xvZUHNd28I5UEkDhx/th1Ox8II3Gjd4UwJwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B/ETTU/+Dkh41unNcatAR5WP4QOtKx1iVPJ0FOlX/EI=;
 b=EgYBCIpUtBN5ZVOnpMGZrQKIh7y5jl0LxEaLUQIrWJcO5RWB5pBHQaVComNjx6bV2Nya/+U1SsjeHFjbq0E7lrMC8MO0ZQ3uYalQj1FHoY4VXQd1/b2d5PbSSpVDVefYCe7sHfQkqiLpQt6iGwBKdsZU7H53P9SR5BwrKFoLmX9zShW4JpJ2nAeyZui2LK7Or5OIHFKfudr6hNhO8Pww7u75xGXcB+En15C/rY4OuJwUpDTwmUA4H88Ff81WEuNkXBfv9+JTEjzhWfCVotrANbCtQMqFM5/3tKu/ktw25zbX3eC8YBTwkZYLZTtGv2PhHoSf7ksGAunotPd7xDfqsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN0PR11MB6135.namprd11.prod.outlook.com (2603:10b6:208:3c9::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.44; Thu, 27 Mar 2025 12:08:26 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8534.043; Thu, 27 Mar 2025
 12:08:25 +0000
Date: Thu, 27 Mar 2025 20:06:51 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Sean Christopherson <seanjc@google.com>, Maxim Levitsky
	<mlevitsk@redhat.com>, <kvm@vger.kernel.org>, James Houghton
	<jthoughton@google.com>
Subject: Re: Lockdep failure due to 'wierd' per-cpu wakeup_vcpus_on_cpu_lock
 lock
Message-ID: <Z+U/W202ngjZxBOV@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <e61d23ddc87cb45063637e0e5375cc4e09db18cd.camel@redhat.com>
 <Z9ruIETbibTgPvue@google.com>
 <CABgObfa1ApR6Pgk8UaxvU0giNeEfZ_u9o56Gx2Y2vSJPL-KwAQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfa1ApR6Pgk8UaxvU0giNeEfZ_u9o56Gx2Y2vSJPL-KwAQ@mail.gmail.com>
X-ClientProxiedBy: SI2PR02CA0038.apcprd02.prod.outlook.com
 (2603:1096:4:196::22) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN0PR11MB6135:EE_
X-MS-Office365-Filtering-Correlation-Id: f32d41fb-c21d-4c01-a648-08dd6d2813d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OHcrZXkxK1ZSZVp1YllLbGhBVUZkd1lEVzFqZUIwcVJUQ1BHZGhMazBHVGp3?=
 =?utf-8?B?bnZmRzNDaVpaYjdsL0h2ajMwUlJ4QlFtSUpuYkliM3pzcTdOUExqTTh1SHc1?=
 =?utf-8?B?QTFyaXArYnNCc3FUeTJzS0pZbGx1aGVQUXhrbXMwR2hzNVlOVkpjbEtQY0Jo?=
 =?utf-8?B?VnRncE5EanQ3aDNaOHNUeS9JTVN3dHo2YTNrWHc4RVQ5a1ZOcFUrcndtaVgz?=
 =?utf-8?B?c1NweSt1YUlWL0JJbUxsTU9wWFJtWjFSbXVGdzZxcm1HaHlYRnlLQ3VpWllz?=
 =?utf-8?B?Y3BycXVtbkY2UVVZYmgvS1FmV3ZhMFc0M3MrRVBON1kxRndPZ0lLbGlRU0U0?=
 =?utf-8?B?ZGZmd1VON1BpSUxMZDc2SWl1YllIM0pPdFFCVXEzbzg1eFY1S0kxeHNGanpP?=
 =?utf-8?B?bWVVYXNUVXRBWTJqSHhNcGxKYnZ5M0dyWGxEQTNFZ3dLWHVCV05tajdvN3Y0?=
 =?utf-8?B?Y214dzBpLzR3clIwZ1p6UE5qelA3cll2akZ1VkgvVmZVMlZOc2xDK3ZLQ3NC?=
 =?utf-8?B?RU5neDk0bUpEb0xDM1N6cGI4SXlmckl0OEF4VnJ3S0k1V2dPMTFOY2F3cHdR?=
 =?utf-8?B?QUVLSWNERjBreGNGQm9WU0o1M3FZYzlwM0NPODRtUjZzclArRFFrQW81ekVF?=
 =?utf-8?B?ZzArbHU0NTFua1Vmb25oSG1wZnFSQnVpaXprOG96UW5zOEwrSkFjSXRqd3Zq?=
 =?utf-8?B?SVdUeHVxejlUaWxrRlA1Tk1Yb1lMNDlNVEFRbGIxY0tFTXpWY0o1VXpLOXVT?=
 =?utf-8?B?QkR6RWZ1SVh2WlBhRW5wSlZlRDNPak85WmYwQ2pZOUN0MTRhaEpWOHBaQWFk?=
 =?utf-8?B?eTJhOW42UzBpYzBtMjNBSEJvWForMG00V0xPTndwamhLVGZEY0NiTUd4U0w2?=
 =?utf-8?B?MUVJSFNzeE9ZSmMwellOdytYUFNrYVJQeStYQnBJY1JCeGx6QzNRNWptYVcr?=
 =?utf-8?B?aDdqV3kzclFpQzZWNVc1cC9zQW9rR1BKQjgzVnU2TVl1QzJkTzBVL0t3S3ZS?=
 =?utf-8?B?WGVyWjdxemlkQTN6SVk0TkhDSHlUb3VlaVpIb2d6QlIyckRjTUNnbmZNaDhs?=
 =?utf-8?B?dTRpVVM3SzVIL1YrNGtBUVhhVmtVR1VLbEl4N0xtYjdiU1RiUk1MMSt6VWhp?=
 =?utf-8?B?ZDZHSmNZUkVzVFZOdzFTMEVTajQ4M1dpVzNSbjFMaU0vazcwMnFxZ2I3M1RZ?=
 =?utf-8?B?eURGb3NIUlFRNDZtRkRZRjJGaHhDbTFxdFJtd3M5NDNld0lMTG5VSnZRSXp3?=
 =?utf-8?B?MGpaODRub0UrN1ppMi9kMm9XVi9rMVVkOEg5ZXFDck5Wd0ozNmZERDExWVF5?=
 =?utf-8?B?NU4zYzlrUVpaaENGZDBZYXQ3L3lVMUYycUpQN2wvU3ZVc3hROWpwYTFISDdz?=
 =?utf-8?B?bzNSdUs4VEJONTZpdndNSjhNU1NIWmFyOVZsN0FMTkRNMlpMVHU0Skp5Q3RR?=
 =?utf-8?B?N0FtWGFJQW1CYVBjRnNPbkNENXNLdVpwdDVJaXNvSHJkK3FvWFF5V21ib1hQ?=
 =?utf-8?B?eTR0U2J0RGlLdS9QVVdnMmQ3ODVCdEhoUXVGUkcvazdyMXJXTEVZcUI0a2Rh?=
 =?utf-8?B?RkpwUERsLy9DUVJrazVaRkdCaFBtWkF5ck9maGF4SW1Dajl5MDg2VHpoMHVy?=
 =?utf-8?B?N05TVGgwaUNjaTRISmxDWTg5M1VIT1dyS0RoNnB2bU9kL0xDVTZuV0hBa0xt?=
 =?utf-8?B?emZxbi9pV0VFQnpiS1lFaENhb3FEdGxCb3o3T1hrWUxETTJDRHdJSkpXVmJW?=
 =?utf-8?B?SzNVbzA4MU8xSG9IUEJsd3I2WkdUSk5hMjk5eFl1bU9vbUd6MDNQZEZGZW9Q?=
 =?utf-8?B?aHZtd2lCV1ZlbkxBVjVRTG9iV3dvZ21UMllHUmZ4NFpJNVB3R1hlRjJmQ3I0?=
 =?utf-8?Q?aZYIk49dSYemH?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TjlzZmN1ZUE1YVg1Sk8rZXpwQTNqaHNSY0FGZXZ2NGJnR3hXc2kvZUI3WWRh?=
 =?utf-8?B?TllCQ2J4czFWM2JlMy9aYU90TjR3NnJmcjRIbmx0VHNJNGxxRkVtb3ByYWJ4?=
 =?utf-8?B?cjc1LzljWUkwQTlCZjdtWTMxekhzZ2dnNExqNW9OSWhWU2ZmOXc5Vlhub2Z3?=
 =?utf-8?B?RkxZVGl3dWFDYTczMmJtdjRXYUQvTlFZdGQxSE8xa2s5WkI0Vk0xajNzMm4r?=
 =?utf-8?B?S2wxa3VnNlRDSXlBWXNMZjcxVlEyc0xVc2MvWGV1Ylg5VEh6SE1xZjlkM1Zq?=
 =?utf-8?B?Rk04ejd0Q25lZ25qdzBiY25xM3duWHVEWXpDbVlZNEphb0FnMlpQbk5reFBW?=
 =?utf-8?B?am9oQTFiUDdiMFhUdHYxRXo0ZzdYZTVseXZEUWNqKzU0ZWZQRkNhWXBXTzI5?=
 =?utf-8?B?TW9kN2pqTHJIQXQwVE5iWVZMVjdYTWFMQktMNE1xeG5wNTlPRi8wSmx0NVJa?=
 =?utf-8?B?NzkwcmNZVmZ1MjVvRmFtaDZ0Wk1OTE5DOGZEa1ZqUmlOZ0NiQUw2K1NEREww?=
 =?utf-8?B?cWRRVFI5Ui9IaXBlS2RWMExRc2x4MlNnNDRKUWR0WHg1ZEtUSUdtTTQxMTJ3?=
 =?utf-8?B?cnZEdHVuR0lMMFM5Nk9TditTWjFzUnVmakVZNEVSUUdyZmNaemlXMnlxOUdX?=
 =?utf-8?B?b1NNd2paSUFydndWS2ZWVjlPZ1RCT3pocXR5UTh0eUVBQmdRdFNXeWppMDVw?=
 =?utf-8?B?Skxzd21VaWU1UzRxU011elZCeWN2SWw1dVdWWnd2QkVMUTVyVXVBN3ljakcx?=
 =?utf-8?B?cUE2K2lKSzhoaVgwVzFWSmR1a01XamlrZmNXaStmUURCcFV4NEdLSXZ2ZUFp?=
 =?utf-8?B?cVpXenNQb09YQXdDNXB4bUx0R2dSZWdUVHVia1FrNjQxVkk3T3pzbmRKcmlP?=
 =?utf-8?B?aUZIZEpFcUpRNCsxaFg0TWNJbno2Nks0S1RyZ0NuUW1tYXVxQzlDQUpVQ0Ex?=
 =?utf-8?B?d2lLMW5peWpwM0xLd0M3RVJrQ0I3S3o3S0trOEtWZWRrNXcyaTZadU5aNzBD?=
 =?utf-8?B?TzRkczBrYzRQbnBQTFBFRDZreWRUcEQxOGt3L1RXalYxVm9WMk40MWJTUmk4?=
 =?utf-8?B?SnFNdm5vQkM0RkoyTit4a3ZjZjEybEI4L0hjQTVMa3o0UlVIYW83dzhqRVNG?=
 =?utf-8?B?a3poWjkxa0V3eENSUkIrTlh0KzdHc051bldvRFNUcFBGdlJHc2Nnb1JvSndv?=
 =?utf-8?B?SWozeUFUaS9aZ042d2h0b01ySVFDeFNpSzI0VUE3UVVQV1ovcWZreE1HSlVa?=
 =?utf-8?B?SlZabnI5VkQ4bm1wZDJrV093bDJGSTRvKzY5TzJ1SDRTN3FNT3F2YTlnMW4v?=
 =?utf-8?B?UVZRcXJDZk1XQnh1a2pBc3Y1aXlDaW1XMWRvTXhyMVJUQlZvY05OSkRzbnNZ?=
 =?utf-8?B?c3I2bHlrbWxlLzVxaDM5RWNWcHVkVVFTdjk4UWs4dk84V2c2UXNoMTJSaWE5?=
 =?utf-8?B?WHA1aFJtQTBtZHBqbmlmSFFoZ0NpcVppR1FnUlhNRllWMTJZZUljTjdCWDZy?=
 =?utf-8?B?V0c2aWJ2aDMycWo0dGxPcDVUSW5qakxYYkIyRGpRTmpYTVJYbk5NcHFqSSt5?=
 =?utf-8?B?MXR6NXpSYS9lL2NucnJPMkNtQm9NZ2NobUdoWERTa1ByOUQzbDNaMWtubkpQ?=
 =?utf-8?B?RzRsazNwNXU0VnEzbjAwWTBXUjR5QUYrU0h2NkFGYXlqZG1wZDNTTjVuQmI4?=
 =?utf-8?B?THkxL1BTdENBa1Z6dEhMYWY4VzhMRThqSTE0TzVGNkNYNzRnbU5IdjFkdHky?=
 =?utf-8?B?cENjN1ZHMnBUZU1TMVlRVE9TWnYzQlNLN0FScUZjcUNNLzB6emhZaW55TXpv?=
 =?utf-8?B?a3pUcGEva1NFaklsWHZGWlZlTUoxa3UyVmh2aC9DTlplYXViUk1tVVJpczMw?=
 =?utf-8?B?V090NjVkblE0SUpQMmwxL3IyaFNpcko3TmZudHRGRG5veWIwVHZza21ZRWtm?=
 =?utf-8?B?Z3RFR0tJRnR3eFhxUDJNRnRrZWFUaE5iY21VZHZmOHBFWmUzOU5rSlZIYVNV?=
 =?utf-8?B?cVZkQWVHQzQ5NFBQUzZ0WjBWU2d5Q0Qvc29WeTRxeEd4S3g3VHppL0pacFhT?=
 =?utf-8?B?bmZ5c013eEJ0QTUzN0F1SGViOEhlVzRJemVKbVZ0NEdyOHQ5NnUvNG5rMGQ3?=
 =?utf-8?Q?IfhNiWsCKODMh2djsU0C4Hxir?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f32d41fb-c21d-4c01-a648-08dd6d2813d9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2025 12:08:25.7853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dupbSVfa0GkApBUmCUEZRInKpggzUbUpMJV+pkSMR2XMKJ5d+iGP/8GX8UATSH65isEl4KVGoo5g4u8Zh1YC9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6135
X-OriginatorOrg: intel.com

On Fri, Mar 21, 2025 at 12:49:42PM +0100, Paolo Bonzini wrote:
> On Wed, Mar 19, 2025 at 5:17 PM Sean Christopherson <seanjc@google.com> wrote:
> > Yan posted a patch to fudge around the issue[*], I strongly objected (and still
> > object) to making a functional and confusing code change to fudge around a lockdep
> > false positive.
> 
> In that thread I had made another suggestion, which Yan also tried,
> which was to use subclasses:
> 
> - in the sched_out path, which cannot race with the others:
>   raw_spin_lock_nested(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu), 1);
>
> - in the irq and sched_in paths, which can race with each other:
>   raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
Hi Paolo, Sean, Maxim,

The sched_out path still may race with sched_in path. e.g.
    CPU 0                 CPU 1
-----------------     ---------------
vCPU 0 sched_out
vCPU 1 sched_in
vCPU 1 sched_out      vCPU 0 sched_in

vCPU 0 sched_in may race with vCPU 1 sched_out on CPU 0's wakeup list.


So, the situation is
sched_in, sched_out: race
sched_in, irq:       race
sched_out, irq: mutual exclusive, do not race


Hence, do you think below subclasses assignments reasonable?
irq: subclass 0
sched_out: subclass 1
sched_in: subclasses 0 and 1

As inspired by Sean's solution, I made below patch to inform lockdep that the
sched_in path involves both subclasses 0 and 1 by adding a line
"spin_acquire(&spinlock->dep_map, 1, 0, _RET_IP_)".

I like it because it accurately conveys the situation to lockdep :)
What are your thoughts?

Thanks
Yan

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index ec08fa3caf43..c5684225255a 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -89,9 +89,12 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
         * current pCPU if the task was migrated.
         */
        if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR) {
-               raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
+               raw_spinlock_t *spinlock = &per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu);
+               raw_spin_lock(spinlock);
+               spin_acquire(&spinlock->dep_map, 1, 0, _RET_IP_);
                list_del(&vmx->pi_wakeup_list);
-               raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
+               spin_release(&spinlock->dep_map, _RET_IP_);
+               raw_spin_unlock(spinlock);
        }

        dest = cpu_physical_id(cpu);
@@ -152,7 +155,7 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)

        local_irq_save(flags);

-       raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
+       raw_spin_lock_nested(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu), 1);
        list_add_tail(&vmx->pi_wakeup_list,
                      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
        raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));



