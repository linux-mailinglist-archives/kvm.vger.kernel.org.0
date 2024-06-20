Return-Path: <kvm+bounces-20034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B87FE90FB4F
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 04:25:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B30B21C2114F
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 02:25:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 654C31CD06;
	Thu, 20 Jun 2024 02:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E/ErAPtI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F050318EB0;
	Thu, 20 Jun 2024 02:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718850314; cv=fail; b=BMZhRH4vlDpAbdOLxrdwii2AZi6VIN+KeppVY2HoCdtu9KAWKze2VCmlfpw7J00y05NjNhNZEAM3Y6FlW+rZ/n5jmPY62MkzPkObCz8/HQ37evmDl19jZtRbsxKNPpK93CWT/0HwyHzTDy4LLEGcVShMPLv+oZXBXE9g3Xg5MwU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718850314; c=relaxed/simple;
	bh=yHPVxepaxFCka37xf3i9uCTkZumlRtBHzxLu2JgtNy8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sFlsKv6IJ+VLAANdnGTolGQ2BBM5zwgOheQ29GBt2xH85KdEoaMO++cjNw9UiragfoYjbrXRBgMKesUZO41/haOJrBJpv63672ErpilKbZddFwpY0EC6Ze5JbnLUN/r902xS/5hFTQwUydhpukyG12wT9tcjmceHfKid6MXa/uw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E/ErAPtI; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718850313; x=1750386313;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yHPVxepaxFCka37xf3i9uCTkZumlRtBHzxLu2JgtNy8=;
  b=E/ErAPtIHh1gQRDT/Ksgzigss8g9qsl75oFI1FUQiJG8sOkujypXezXx
   zS1E9A/f3rZwd+qlq7NZTRwF87BGgxLIJuNXeA0M7YBZawaIt3k8+LOKj
   rhFv278eFYBjUoyAptsGoKrzAJ7R1J23T+1skja/WQA7sGNyxiznxkp+O
   Cxlqghjgx6ronME48FXL+Jzp+o5HCq/bb7zHA/6mZVGgzYhfg0zSXikae
   RGAYWiKFtAmoWgQcAM3XrQjhRmPZD6uamCsCsI/WO1lt2jBa2YNndKcgm
   Vezyf9eYzUvXTGOMJT32KPEwevOaVMnNIH09R0PJv0LppI0JvSHW0V0jj
   w==;
X-CSE-ConnectionGUID: GHL+bUmkTwGRuWAnQDxVmA==
X-CSE-MsgGUID: 4cFZygVpQ8qnwCscmsgf9w==
X-IronPort-AV: E=McAfee;i="6700,10204,11108"; a="15637860"
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="15637860"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 19:25:12 -0700
X-CSE-ConnectionGUID: x8NA+2zrQgq3PLE6tyBiAA==
X-CSE-MsgGUID: FWtjY2fUQmyOwuE5eEfHWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="42548271"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Jun 2024 19:25:11 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 19 Jun 2024 19:25:10 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 19 Jun 2024 19:25:10 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 19 Jun 2024 19:25:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b66ggTUkgg5InDnfuhPWKhQULhCoW8AWhUnL/6WCKqKHLXDBngYnD7or4tMlHkuiObtwiYYv+lQWSqcPmFWXffdhNsdsvIo9YCcuuldP4G6An39KNePgdxXuidAB30+O632DqjT454RjRTrwzhzZ+QxFUvTklOU9JQo9/dQtkTbtmhI1WhZThTkGq2piBn3PtrTKi9gBmq5rb9oy81KgfvwBuyJt0apGvtdQ6QUL3Q2oytI5+s/xkTyzcfPM5+DZTBUyI64fCbQ4JGKDi3zVQlIEal7LzZkKOBvxTQdSGzLNB8nexuzHb92tblK0QwZhnYnOR8VO+H3/WkOwMTvj/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=orcqT3U0JGonbeEpnWXcQnY/x8EsOl1NcdrT0IFDmYQ=;
 b=ndLs0xNlbmWkD+OM92wR2SKwvHgHovB/U/GfinuIo2rQWm/cKfQbHLuk8jHJkbGOCT01OQBfH/5gSTb/+j5dXPKhbB54YPy1LKsCj6kevu8WDxnVcP6SC/MzJh+8VmhF4OyxRzNH1cngH5dF2rxfuvEuSj7sFvJj+rpD279NvyEYfn8ib27Z9TZETKrJc8ev431o2uDPXC2fU9NCkkXJLdPRVhBuL0yT4l39fDoW+P5d6YiD8p6xOGj/FxgbKM6jf/I6j/q0opUi6TiIB16IzlzIJGVaYMmuJjXRchAOO2U3hLaFMin2cyE16t71XqbiNWhPNPEeqpETWt3zS3Iq0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by MN6PR11MB8243.namprd11.prod.outlook.com (2603:10b6:208:46e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Thu, 20 Jun
 2024 02:25:08 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%7]) with mapi id 15.20.7698.017; Thu, 20 Jun 2024
 02:25:08 +0000
Message-ID: <574c6d64-719d-4367-89f4-cea12e24f873@intel.com>
Date: Thu, 20 Jun 2024 10:24:55 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 38/49] KVM: x86: Initialize guest cpu_caps based on
 guest CPUID
To: Sean Christopherson <seanjc@google.com>
CC: Vitaly Kuznetsov <vkuznets@redhat.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>,
	Binbin Wu <binbin.wu@linux.intel.com>, Robert Hoo
	<robert.hoo.linux@gmail.com>
References: <20240517173926.965351-1-seanjc@google.com>
 <20240517173926.965351-39-seanjc@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20240517173926.965351-39-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR06CA0196.apcprd06.prod.outlook.com (2603:1096:4:1::28)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|MN6PR11MB8243:EE_
X-MS-Office365-Filtering-Correlation-Id: 3be4b82f-c8e3-4daf-722a-08dc90d0343b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|7416011|376011|1800799021;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RXVDd1A2V3NDbCtNdTRsRW4xTXJIeEp0czh3Tm1BdXB5V2puM0xDNlZma3Bu?=
 =?utf-8?B?WkN3dms2ZDhZelhzNmRRNzN0eGwraTJTOUUxbkJsZDR5dDB0R2Q5a28rakYw?=
 =?utf-8?B?aGQyZWpvSjZwNS8xdEwxT1lrbjFNUDloNkJJOTluOUcxb3A3OTM1YUJVOW5z?=
 =?utf-8?B?eHJpVVN3WHFCaTJtZng0bEZuOXllRUNweWwzZFI5RlluRzRtU2s1VDNjYXJl?=
 =?utf-8?B?Yi9rK0h0d3NFejU5dkd5VTVxMUkrQmhtejJVQUpaSlUzOUxuVkE1ZEpGSHVP?=
 =?utf-8?B?V20zMkhoYk9uRXVqZW1RdjJ3anFlejh2MUN5YlUxL0piUldQaGRnUk1NMi9U?=
 =?utf-8?B?aTRhc0ZUUEd3Z0VFNnc0cFFjNGtBTkRYdmplM3A0amtwalozYS9ZcmV4M21l?=
 =?utf-8?B?TGtEc1diTHI4ZG5UMWIyOVJZd3hEQi9IK0pSS1ZsSWtNUmRsdDVQSU4rQWFo?=
 =?utf-8?B?WGxuYXJKTU5FUVo0L2xxbDJjTmh4dGRsNUZCK1FVOG81SHZoZDAwT1paNVFG?=
 =?utf-8?B?SmxvMTduUEVFTFlLRGhXNmlHUkRsbWtIeUNyaDd5ZHdRNTR3NzNQWkpXZDRl?=
 =?utf-8?B?OGRHcCtmYmZCcUpwbk5rWlhReWtpdWw3QXFiaUo5NUU0Z1FQaVprOTlsWFRH?=
 =?utf-8?B?SDJhbUxEQU9LQUNpWHZqVDFkaU1xcmtHeWREYkFxaTU4VEZ4RFlXaGcyMGFP?=
 =?utf-8?B?UzliQXpXTjVrRUdKelZ2Z2hOeXBpc3NaQit4L0gwa3V2eXdrNXVHWFN4VVJP?=
 =?utf-8?B?OWVYVUxsM2duNmFLMUthYmxhclY4VjBzMVRxM0R5VnhEYktjTElBaEdqS3Bi?=
 =?utf-8?B?anhGTndmTGtNZGUxZjdvVUJ0RE0rSUJmQ3BvbjdCaDFvMnpENHF5M0x2M0wr?=
 =?utf-8?B?bldQT1ArU20rbTBKQWdQbG9zTW9Qc2V6dFJnc1RyZXpwemUydTVkK0FmNDNl?=
 =?utf-8?B?OE9TSkNWR2hmYXB6WUhKaWtobkwvb0dXYUplTEk2N0ZWcmVnUm1ZRmU4K3lm?=
 =?utf-8?B?TldOQzFMSm4zbkxva3J4Y0U3ZE9iUGMzeDlyTEtqTXdEMysvbW9USGpuK3Rl?=
 =?utf-8?B?ckpGUEpWeHVqZTlac0MzOG9mS0J4NWtNZVl2aWdjeGVndGpuSXRjVGNYckg0?=
 =?utf-8?B?MGxDMm5xbjV1MlFnd0cvNHlWMGVsYkQvbGU2ei9TWklXTjdpM2hqRERkMDNh?=
 =?utf-8?B?K0dvaUF6WXZodmlMQkhzY3dRZGk0b3B4amtYN1gzTTY0Z1kzRk1FakI4bWZw?=
 =?utf-8?B?c1pkNVRxUjFCZ2xXWHRpQ01vMXVzalRieWh0U2xjM20vNHhBMit5cDVJNi9D?=
 =?utf-8?B?VDh5N09QbDk0bUpjWnRqVm43QlF5SVBZZkdiOGova254RFJ0eEExWVRVbzc4?=
 =?utf-8?B?WmNmQkNxL2o3UjJ0OWRuZ09YUVlBVkg3bWhkQnJKdW5Ya3hWSWZ4em1WWHVj?=
 =?utf-8?B?OWV5YWU3dm53c3FTb09pSFNQd2xSbHBCTGFqTXZFTGdWdkdTeTdPOWdLUFZI?=
 =?utf-8?B?blBtUWllYjR3bHhTY1FHbnd1K2p2VllTWUJmS2grNTJadzlRTnVHeU1xU3Vk?=
 =?utf-8?B?c3hRS1lwb0xrUWYyemc5UmxvZldTS0FHZU5ValVmOW9wenpNUzB5TnQ1R2cx?=
 =?utf-8?B?TUt6ZjRIY2hvam5meEdEeDhlS3g0MzdYVGl1ZkVBOXFuTDJGZStTQ2xHVTVV?=
 =?utf-8?B?dE1rcFphc2NxSDlGNW4rMjdsNmI3d0xXa1JiNVVteWVUMFgvWFpOdGVGYzlm?=
 =?utf-8?Q?Hx/w32qO/88doSgYI95GmTTwyWduZKW99J64Xr8?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(7416011)(376011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Njd1c2YxdFlQellKcFloWkdkRnRqYU1lYkIwbnJ6WW13L2lqNis4b2o2Mlhw?=
 =?utf-8?B?Qmw5b1BXT0lWcjVTWnptcC9HcTZBR2x5bjBnZTBpcVZRNGdFUVFLRXdBNTJa?=
 =?utf-8?B?eDM0bThkYnBjc0ovYU9zMUxJa01iUlo4SnJWZ0JWSWNKMlQvQld0a3psTG9P?=
 =?utf-8?B?dFlNQldQNDBxSnlOQTZKcUllTXJhQmJxd0xtckgxNXB3YStDMnlPNHhTMHFl?=
 =?utf-8?B?VVE4cUFWY2JYblVIZFB4N3Vka0piYS95SEJZUW9qVis5ZnlDQkorbDcyRnR3?=
 =?utf-8?B?YWJQS3N5UFlwbXA3blZJRTVyaFpCcExBQllEcjJZZ0pmYlRWWE5MU0E0eUNM?=
 =?utf-8?B?QmgyZy9uMGRYb01tM3pvU1p0ZmQzQW1yNFZsbGI5aS9wRGVpeU1ReWcxTnZx?=
 =?utf-8?B?KzRkcnZKbFh2VGhNcEdWZWlLemUvdk5JTE84OUlRdm5NZCtqNHVpam42SFdC?=
 =?utf-8?B?STgybXBtdzErY3BLZnNUV1VpKzlFY1k5RFVIbjJwVG5ubXdwekVOYm1ZUGZk?=
 =?utf-8?B?Q1hFeURTdWJ1cG5vZjd1MkdxZ3p6ZzFRYTZoWWgvdWUveG0rcXdVMUtGd2t0?=
 =?utf-8?B?Mm5IUVdNeFNtT2pSaG41R08vM2pCekd2c0pXK05mS1pLN2dxQ3I5OUhBOUhP?=
 =?utf-8?B?cTIvUjZySnN4MGdmbnI1bmFYTThnaDljRGtkdHhubTBoRGgvRHZGblZOTmsv?=
 =?utf-8?B?UXpFWkZhS05uSFlkTFcvcjBWUXBBMmduZTAxcEMxaVJOWlgrWTNaL2c3L1RT?=
 =?utf-8?B?VjZBV3A4WDZJUk1TT29JRXpVbzc3MXBNMUxiMGNhY1k0VjRpazh4SWJiSDdW?=
 =?utf-8?B?K1VMMkNrT0dpSjhmZXFNWENONzFkQTFVL1ROb0tWYTlXei81OW8zaVdBeWxy?=
 =?utf-8?B?c2p3Nm02eUV4N1lxNnRWdjlORitRSnF3Zi9hQnNOTFhsOFhHV1NIVnBYV3Ru?=
 =?utf-8?B?YWxSdStoU0UvN1RiZWNFNmhDTTBrUm1tN2pVWGk3MStnNnRaV2FJYlB0Z3Rq?=
 =?utf-8?B?ZWhQaXpwUTZLYkVtNWNBaUJYUkQ3RjNHQXY1T0hmQnFFMW9tTW12QlBKL3kv?=
 =?utf-8?B?bS9wdGtmSWhxbUFaZWg5SEVFNE10b05mU3h3K2cvaEI1b1BCNGpoUGt5ajM0?=
 =?utf-8?B?dThzUEtTTFZualpwbTVNVkQ0VVFzMGFMVHpjakZTR1RGS3VsRFFESUY5SGMw?=
 =?utf-8?B?d0xOQ0VKMWlkVXVBQ0NZdVg3dnJaS1RNWHo1bFFsSzArS1o5SmNBeWRoSXJR?=
 =?utf-8?B?V0xzS0dBZ2M1TnlJQmJtRGUrYXVQNG01MTgyMFJONDhJRnh3U01UczhzblhV?=
 =?utf-8?B?UGJxakM3UDZBTk9DSlRJamdVUjBVbmNWL2dVT1AyUHFpai8vYjNhOVpMMzNE?=
 =?utf-8?B?YnJIOU8zUGJMUWNTMDJocTVEVHFlWEVCTkN3NGpKbEUrWE5ha3VaNnBiTjlo?=
 =?utf-8?B?QVdwK3BqeE9Hb1pmZXZrV1paRjVPMGM3MFNxWG9WRmZEMjZWcFFMOUxkakVv?=
 =?utf-8?B?OEhYNmFxV3l5UVVnLzJMdEFwVkVybmJXT2lIQzVvQ2xLaVdCNjQ5OGFXWUht?=
 =?utf-8?B?NjFZZVF4MS9KTnFNMXVuK3ptT0JTc0Rzc2FvVjNJdXRRVzE4eEJDMm5tY3FU?=
 =?utf-8?B?eEZnSDZNNzVRbmRRbVd0a2pkNkUreHY0TTQ4dkpCQU1OTFUxcnJzVjlvVjF2?=
 =?utf-8?B?YnVxeGJhMTlPRE84MUVoUGFlK3NpZTFSWEQxWWY0N2ROcUY0RlFnUnRUQkVv?=
 =?utf-8?B?ZlRUTy9UbDFIc2ljbHZlN0lTTloyNmVjMU1saUoxMFl6bUZiTW5ocUtNQUFY?=
 =?utf-8?B?MzBvSXl5bDY3VjVBWk9VMFd0azBhaXBvY3M0K2VaQW9GS3FlMTJNQkNTUGZi?=
 =?utf-8?B?U0dZMGtyNDVyWDdwa3R3NGpVUHJ4di9xTnJRR1JwSEhXTGlGbFdzZG0rdmdp?=
 =?utf-8?B?QUFxWm9JQXo3TVpvcFBORkZmUUZ1ekZhcUtEdmRRN0lzek02ZmlucFF0Zzlj?=
 =?utf-8?B?WUJmM3NadkdENnk5M1JtUUgwS3ZCd2xvNHE0SmZveGpLTm5zV3ZvMVlHWDlm?=
 =?utf-8?B?NHNReW9kNDF3UzhyR0ZNSDhBODFHd3lkS3FZdHVRa3RsaFRmU0FBc3AwaGlM?=
 =?utf-8?B?WHcvUVVoRFU4enc3cHNIQWlvTVdGUVR1ajFTNG1aaENCQUpzd0x2NDJpelJK?=
 =?utf-8?B?amc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3be4b82f-c8e3-4daf-722a-08dc90d0343b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 02:25:08.7755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 48TYGYFqDNz06Q2cnJ0M/alkt3BKDDXfUYn9LC+KUYXusSAh5kgrgUyudLJOwZnZFfXnvAOvtFVucIEpqwfL4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8243
X-OriginatorOrg: intel.com

On 5/18/2024 1:39 AM, Sean Christopherson wrote:

[...]

>   
> -static __always_inline void guest_cpu_cap_check_and_set(struct kvm_vcpu *vcpu,
> -							unsigned int x86_feature)
> +static __always_inline void guest_cpu_cap_clear(struct kvm_vcpu *vcpu,
> +						unsigned int x86_feature)
>   {
> -	if (kvm_cpu_cap_has(x86_feature) && guest_cpuid_has(vcpu, x86_feature))
> +	unsigned int x86_leaf = __feature_leaf(x86_feature);
> +
> +	reverse_cpuid_check(x86_leaf);

Unnecessary reverse_cpuid_check()  same as in previous patch.

> +	vcpu->arch.cpu_caps[x86_leaf] &= ~__feature_bit(x86_feature);
> +}
> +
>
[...]


