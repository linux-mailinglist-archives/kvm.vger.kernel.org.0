Return-Path: <kvm+bounces-55261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A9BA0B2EF87
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 09:26:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C31D51886601
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 07:25:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFA462E8B85;
	Thu, 21 Aug 2025 07:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WWwdNPdz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1C52E8B7F;
	Thu, 21 Aug 2025 07:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755761074; cv=fail; b=BJauFDp8m1ZB+JBrNtFRAaOi4kdnv4HfGiLWs3kSeh0c9/fahufQDjMvxIDdSV4HNrxmb26BrRB+9PCX7fVobz4QnbIFWrXPqu5XzviinYDnnfjtycXW2yaHjA9QU0X+DQeQdJRSpkMf3x5Anj/Gw+e40lb+gObNY9UVKvYwkok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755761074; c=relaxed/simple;
	bh=gGTMDuFgeLNdu2Or4J/g6CicgJpwQBZdA4fb0WnFTqE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fJeyfJfhW9LGnn9y56p9sMqjMmkTweHsxepbOTuAVS2Y6b1raH1uw0lJZS2i72XlNLfYgrVv7aPbdEg0jJO64BCITVDjoE7IJbDpF//1xLgRz/HWcQBZ/INMXaQvSApTdDKT/J9CdjjVWxex6+pYs5uPitoc7dKjDywKUwJeKm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WWwdNPdz; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755761073; x=1787297073;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gGTMDuFgeLNdu2Or4J/g6CicgJpwQBZdA4fb0WnFTqE=;
  b=WWwdNPdz1XvBTW4fciLpr/Da76KF+4xaSfaJVI/QkmxXXr92cRmUHxBi
   ta3YMwLuPUNNvnoDJklTi2jWpc1CLGmJdns7LU8XW1KuHT1fEbArM3gA9
   lqr8Qcf+Ke/cK3cTYazSwmQ14y2aBvzhImPnn65i0qrFj8/odSe4feK1L
   UVSG84f5EB67KC+OOZ0kNeJ1sEGE4360AmzBf7BR1QZY4ZwnQqURwS4y4
   F1oMWOc7vBjyshJMo/doq5nOlHJSA8rsD3eEun5538PYbOSboEqE0XJWX
   Ig9SQPMBgas3RkbIvPJAu6wg9gLgOnZlB/7tQvRvQcWvE/Tqq7Mw/+Ivz
   w==;
X-CSE-ConnectionGUID: 3su4VQ/2QhmS9pd3n55iSA==
X-CSE-MsgGUID: iDQms9mhQc6lB5c6zdHVww==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="68745005"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="68745005"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 00:24:32 -0700
X-CSE-ConnectionGUID: CClGXhL7SwqyvHp4sdDRbQ==
X-CSE-MsgGUID: XKBht8s3QhaMVud+kXZdAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="169133037"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 00:24:32 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 21 Aug 2025 00:24:31 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 21 Aug 2025 00:24:31 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.68)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 21 Aug 2025 00:24:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w71TRbqfzOirwx+a6/t+pVLF4SrpnB+38BAyrfAfSLk82dg9GwCT/+9BHD5SE28NaFybA5b4YJm8oI5TK3HNfATKSKCEXX/NVZU8bDZ2Sb77TAvMLBMv9f21HcDYH+nw27SRRdeZT+tg+EI1P21f97nuvVKvkZpTcQp+QLD3qmg9PGzmrxgvrBzzDsXNG1loZdHGZ4d+uSh+7lj2xQO7+mUx5SfAjun5PM1ayM+QlnR4XBiJF2yeEwXpeGCOjbkN4YwL4lSDHVULqAwudzNrpDZkUOXrDzu9bUgsc5D1yL8gbIQO6pZF5EYnfpLr35qaTq2HQAq+pe5dDJaVkYUpmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GfP+5u7xM5ja3MYSrwHm9F1HHp+Z4aRfXKV8c9WuItg=;
 b=vo6Yyywj6gcZEeZuMUoFEoANeYhN/VcaylUUZKpbPNfzkG080NB2E6SN0PRXsj+lH/vq3nWPBmi8foJGloozpo9AXXhLq4bmWdBQhVieYuMvWxYkTXpWirDHjxjo+Sm1u59+DMQcBLSdYPh5k668Dh6umFHyaQ3BnqT6g45iZcSvEnO24MbiCCXh7TPhTi5b3Mvz/XlzO16qFTfxxnDnPnxKuAid2KUCojVJHgtbmkC3pXGlZ0RtKoxvSg7eVBi2bUrLfEWtpCNuQDz7yymYN5DnM7F0YzKRba652IC78X10/7Dmk1wOALtcqyKXYvaqdJ4Z8b6xB66g9scD+MAy6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by DS7PR11MB6152.namprd11.prod.outlook.com (2603:10b6:8:9b::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.14; Thu, 21 Aug 2025 07:24:28 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905%5]) with mapi id 15.20.9052.014; Thu, 21 Aug 2025
 07:24:28 +0000
Message-ID: <10587d02-1133-45fa-9ec8-2288a8868b68@intel.com>
Date: Thu, 21 Aug 2025 10:24:22 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND V2 1/2] x86/mce: Fix missing address mask in
 recovery for errors in TDX/SEAM non-root mode
To: Borislav Petkov <bp@alien8.de>
CC: Dave Hansen <dave.hansen@linux.intel.com>, Tony Luck
	<tony.luck@intel.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vannapurve@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, <x86@kernel.org>, H Peter Anvin <hpa@zytor.com>,
	<linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, Fan Du <fan.du@intel.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>, <yan.y.zhao@intel.com>,
	<chao.gao@intel.com>
References: <20250819162436.137625-1-adrian.hunter@intel.com>
 <20250819162436.137625-2-adrian.hunter@intel.com>
 <20250819213247.GJaKTtf1er-Ced_mzP@fat_crate.local>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <20250819213247.GJaKTtf1er-Ced_mzP@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU7P190CA0014.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:10:550::12) To IA1PR11MB7198.namprd11.prod.outlook.com
 (2603:10b6:208:419::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|DS7PR11MB6152:EE_
X-MS-Office365-Filtering-Correlation-Id: fdc2c024-8070-4c98-6d2c-08dde083c35e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OWxwamJ2WWFVWndDUEFOTjB0cWJkK1daK2lkb2RNRjJxK1BCMEV3bHdwM1VE?=
 =?utf-8?B?VUdkZXJ0dnFQdHVnVU1QbUEwa3ExMVZGcmc1ZVk0SHduR2FkN1czS0tib29F?=
 =?utf-8?B?K0tqT1g3Y2VlZW80SWY1VTZ3ZmRRNmEwTXJjMVFxbmhYbndqK2ZWN05XQW9T?=
 =?utf-8?B?RDlmYXhLK1BHK2htTVhMakNKMEhvWTg0TGNUc1I1bzNDQmNkS0ZuaEVNNXRy?=
 =?utf-8?B?UU1DRVA3UUVmNGw4TWFKWjM4NFF0SW13S2RJTGtUVEM1Vm1YU3BvTHpSNmh1?=
 =?utf-8?B?MTFyQkp5ZWlFamRidEZOU2QyaFV6TFFWWW5JWGlhOU4vb2c4a293V0VxcUkx?=
 =?utf-8?B?VEZhekwzQ1djZWNobExhZ2pkUmVjTjU5MStCdGI4ZjBaeFhyclFHeHlxZ2RH?=
 =?utf-8?B?bldNTHB3TUtMWVNQR1NWUVF1RitkTDgxSUYxOVIxeTdZVVgvR3NUZk4yUG9i?=
 =?utf-8?B?Y1puK1FsMEhGMFdmRXdSd3h4MGFRMm9KRFRQR2l5OHNsME52U1RnT0pQeGxP?=
 =?utf-8?B?QW1HaWFIVHZzREdDQ0cvSFlVS3ppaml2eVZnT2g1Y1NBeWRkdlNRWDNoVUd2?=
 =?utf-8?B?U2c4SjlzT2hjR0JvYVltZDB5YUd2RzdxbHZMVG9vbHltUmliMThHTFlFVGRR?=
 =?utf-8?B?ZDhuZ0swVXZuRlVmcmtyT2FIRjlPdnplbi9ZOGVGdUJ3WnJDRTZmTVdtL3FY?=
 =?utf-8?B?MDhpS3crQ0s2UkZucXNMWHUrRVVUalVwcldncDhvNkwvQmJYZEVLY05ybXZ0?=
 =?utf-8?B?UHpkWFN0UnRjQjFkSWw1QzB0Y3FmRkRoeHNTQy9UbHZ4Y2FTa2xlU1FZQ1Bo?=
 =?utf-8?B?K000aFhkTW5IZ0VDUzZRV2IyNHZYMjBvUUFRNWhiOVQ4TkZMTU1kNEp0NXg2?=
 =?utf-8?B?NzQrRit6ZjA4djE5UTZpNCsvY2dlVjR2ZWZjaU5pQUNTM3JnTUNlakE3clUz?=
 =?utf-8?B?VHlWRzIyVmpqd3R2QkdMR1p4NVprM1FEc1B0bSttVTZrdFQyUE0valVFbjRZ?=
 =?utf-8?B?ay82ODFUWWNyNDJHUGVSMkZYcFVkb3Z2ZWpVdzgyMzQ3N1MvZWlqTHdtZXpu?=
 =?utf-8?B?MUo0TlJ6endtYVFXYVVGWDJ4SXNLSExQZGhMRW1TWEJ6WGViUzlrSG1BTkRY?=
 =?utf-8?B?RjlyQXFncGRBMythcHZCUzFjcFJXR2xGbC9IM0Jzcjh3MkdVWHM5QnJod0kv?=
 =?utf-8?B?Z0ZwL1hKWHdDbGVwdGl6NTE1MVlwSWNvS05iWENHT1V0OEhldkRuNWliay8z?=
 =?utf-8?B?RW91ajVmZlU5eDJORC9VTzZRVU8zZy9EclRKRm1VNXR6UEpmNDlYY3RiM0Jn?=
 =?utf-8?B?MkVHdUsrVkI3ekR0WXozc0xsZys2clNMUjNVa2EvM3hGZUpOcjVkVFp5M0M4?=
 =?utf-8?B?OVVOeVZLVDROMW9mNktZSzBZNEU3bjJWaG9NbXc0VE93cEhSMGJnZWhRRDMy?=
 =?utf-8?B?ZC9ldHNyOVhmOTc5NXZ2TU5SczRHMEw5WnViZHpic1BsRkhhQVg1cm5IVTla?=
 =?utf-8?B?eGNDRUlHemtEUXdNZTZTL0ljaGNtbVVQLzlqTldGSkprQVZ3bm9FNjZDL2dX?=
 =?utf-8?B?ODYzVFM0TFA1T0IzNzBUU0laT25YdzhWOFcvQkJiRmhBK1p6OHE0UVpLcG0z?=
 =?utf-8?B?V3ljUXRDNTM3dW1EeWlYMXE4VW5JWDFNU2RXS2Rad21mYWR6Y0YrUGMvYnNX?=
 =?utf-8?B?R1Vzd0ZsUDE3OXVleTNIVWg4UDJjV3o0by9RSk02eDBGUUlSd1RoL2VmaWpU?=
 =?utf-8?B?YW1PVHlCM0I0TVdTWFhGT0tqU1hJaTZrMUMvTG1Ga2tlUVgxME13R1psdXpT?=
 =?utf-8?B?V1dMbGljSkxBMmJibzJxRlhzSytjQ2VzZXRBcmhPTTFWYUJHaU84OS9ZNnhF?=
 =?utf-8?B?MVFjRTJMWmZKdXRDODR1MzNwRytUS3ZoTHFrcEV3dExQS3ZGZGhWRWpYS2hQ?=
 =?utf-8?Q?2RwHuCJK0yY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K0dtUkVsMGdONUliNFRVQTU4cnByaHp0ZGZRc1pkaStQZ3FIVHZuMWJiUjU1?=
 =?utf-8?B?M3grZWFHdUR5ZHZhR2pISnV3V1BWaUYwSHEwWEJHdEk3RTdoYU4xYlNWaDlS?=
 =?utf-8?B?K2dXRi9OQVhac09tcGRrTDh5U1d6NmNoN0pwa3VGUTRtd0xuSjJvUFUzOEl2?=
 =?utf-8?B?bDVEdHJGdTUrWjY4VndJM0F0eWRUcVpmUnlJOHNOOE45M2FhL0RhYzFLamdv?=
 =?utf-8?B?S1Z4NHdteC9MQ2lYNGlOekRnYWZzZEJZZkdhN2JVVFVyYndoWEFZejdESlU3?=
 =?utf-8?B?R1VLcE5BL3VWdCs5V2R5REF4YVBSa1B0NmRtS3ZhKzR0NjlpT2VzZ3BjbWJS?=
 =?utf-8?B?Z1FXZlJ1OTlOdFQ2K1dpVEMwOFNWQkRzSis3L2c5cTYyVnRYSmdrTzFoM3FG?=
 =?utf-8?B?M1lPQ0FZU3UzNHg0S0krZUdLdEtXWjhNQlNQUEVXblczbHZxbkExeUlWb21Y?=
 =?utf-8?B?U3gvS2c4MU5nYUhVVHVYZ3lTTGwvNEFqdmRMR0QwYlFya1NIbjJtU2ZMNHRt?=
 =?utf-8?B?bFUwMGhOVEF3dmFTRnZSTWZxc2huWVR4TGZ3ZnZPVTFiQnZUSW03bVNpS1ow?=
 =?utf-8?B?b25YMmxzYkJMeGx6QWpFdUUrWHJ3Unp1c2VMRTdWMHV6OHN0WjZ3QWxINzRD?=
 =?utf-8?B?TkpLUWdaMCtTLzhvUUFuaVRndE1wdWdicG9Gb2p3Nzk0VHhDNkZwMjByWTU2?=
 =?utf-8?B?d1Q2MS9xUE5TdGQ5N3JaTzNHZ0tVNm02MFUxNk8zY0cwYTdIWElzZ1RGVDJX?=
 =?utf-8?B?YUpVei9kK2RWSlVMdSt5L0ZaWTJ6ZnduQSttSDY4bm9waVJmVWJqNUtwMFYw?=
 =?utf-8?B?R2llY01hVFg4UzhkaXlQM2NOMldjeERDeGFMdkRMcGJ0NElvSTI3b29tNTVh?=
 =?utf-8?B?aXZ0TFh3ak50OWFvL2dJQmFJZXJZdTJHVVEzQTdDWlJ5TmtCcjBhV0xMaFVB?=
 =?utf-8?B?UnI0UzkrNkhGeDdxN2JEWmV0VTV3WGQ0ZnNKVU5IaVdEdU5NZVR4bzk4Znc4?=
 =?utf-8?B?RVp1UGxxZFQzdW5UcjFBaHNGbitlNmQ0Qi9uQ0w5dHlja1ROenRwZjhkb1Fq?=
 =?utf-8?B?QldyT0lGRkUvbUlBbnhIOU1sQXIrNFBTa1ZFYlVDTEV1b3JyTk1Ickx3Z3ZT?=
 =?utf-8?B?R3JLUGpETGZCbEJocTBicFF1OEpuSjMrckRaMmpVUUZwUHlJV2MxYnlxMTlJ?=
 =?utf-8?B?NFVoV3pzeW5PdngxS3BSZ21OaVcyMzBZUlMxY0FrNFBONWhNc01HYnBaVEM0?=
 =?utf-8?B?RTVhY2Y2c0IyQUlXTENOazc3WVlKRGg2dGZpblRQaWt2VEd5emVSMWJVNWlr?=
 =?utf-8?B?MmRiS01OOWcxYmdCNE9jK1J6RXJiRm92WkFKWTNmdHJQZFVFWk9WbFRrbWlB?=
 =?utf-8?B?QlVyaHdKZGRoNzRtSDJRViszYjhyQXV2YXVJWjFtZW03U3d3MnRnc2ZmSnBv?=
 =?utf-8?B?SzVIWnNXb3RiMTYzWlk1TVFVQU0xTXpEWW1xbHdPaGhXWkZxRXdjaTVva1FE?=
 =?utf-8?B?ZVlzWTY3YzBScjY1OXRlcXVib3Z0bENodWZYRG9LaEY2UWs0dDNmdFNTU2ts?=
 =?utf-8?B?ajFkWEYzZjlTUjgwdU5CWVN0eUFZWlFwdjhyZVlLdjBKZDRxUml4U0kzbDR0?=
 =?utf-8?B?MnUwTTFtU0RIYUgwSTN0QnBBbUZXakFrbVVSYlhzc21SVmF0L1YwaTVRYkhC?=
 =?utf-8?B?NWJHV1MxTW9veFFmNzhMRjZEMHpHMEhQNi9kN1daWEJUWEQ0MG1QeXhJTm1x?=
 =?utf-8?B?TlVPZ3kvNldBTmtMNUVvRTZnUytMdlY0WmdVSVZLb3FSdEh6Q2lNRmxJU2tl?=
 =?utf-8?B?VnlrN3hZd21Pb1pUNDFLUWFDY0Rza3U4ZGJhTGZwTnlrdzJ2aFhQYVZSK28w?=
 =?utf-8?B?VWJrWHZJUnlZR042MHFtMmVCdHpJY1ZxeWlsaVhCY2hYUlBZTWVCak9SQ01S?=
 =?utf-8?B?K0k4WDdncUhPcERtUjdrdkhFdkdDVS9FdDN5YnhaR1ZVUnRWaXhkOEpPOGYr?=
 =?utf-8?B?cVJ4MFVwT3Y5ZTMvcEQ5RjUzRFVZbU4rRTRGY0VQRThQc0tFMDhmbnU2VE5Q?=
 =?utf-8?B?TFh1QkZuNnpyMFJRL3lUb3FIbHRWQUREUWlMNVUzNXFuczhwdnVBUTBKOThz?=
 =?utf-8?B?TkJpRnMxVG5tdFQvaWtNN1J3REp4a1VZNUJBbWxjRkFaVUlNUlNtcEdUc0Zy?=
 =?utf-8?B?cXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fdc2c024-8070-4c98-6d2c-08dde083c35e
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 07:24:28.2613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J6M9XxCyBVyij99hKKVuV0W2oqSUXUaWmDQ+a0ivKGi05p74QrckrCLsWuCQ6SJOC1EE7ZrhY5BLNHKI5nemiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6152
X-OriginatorOrg: intel.com

On 20/08/2025 00:32, Borislav Petkov wrote:
> On Tue, Aug 19, 2025 at 07:24:34PM +0300, Adrian Hunter wrote:
>> Commit 8a01ec97dc066 ("x86/mce: Mask out non-address bits from machine
>> check bank") introduced a new #define MCI_ADDR_PHYSADDR for the mask of
>> valid physical address bits within the machine check bank address register.
>>
>> This is particularly needed in the case of errors in TDX/SEAM non-root mode
>> because the reported address contains the TDX KeyID.  Refer to TDX and
>> TME-MK documentation for more information about KeyIDs.
>>
>> Commit 7911f145de5fe ("x86/mce: Implement recovery for errors in TDX/SEAM
>> non-root mode") uses the address to mark the affected page as poisoned, but
>> omits to use the aforementioned mask.
>>
>> Investigation of user space expectations has concluded it would be more
>> correct for the address to contain only address bits in the first place.
>> Refer https://lore.kernel.org/r/807ff02d-7af0-419d-8d14-a4d6c5d5420d@intel.com
>>
>> Mask the address when it is read from the machine check bank address
>> register.  Do not use MCI_ADDR_PHYSADDR because that will be removed in a
>> later patch.
> 
> Why is this patch talking about TDX-something but doing "global" changes to
> mce.addr?

It falls a bit into the category of: easier to maintain a
global way of doing things than have lots of special-cases.

> 
> Why don't you simply do a TDX-specific masking out when you're running on
> in TDX env and leave the rest as is?
> 

It was kinda like that in V1:

	https://lore.kernel.org/r/20250618120806.113884-2-adrian.hunter@intel.com/

where the code change was dealing with SEAM_NR in the block starting:

	} else if (m->mcgstatus & MCG_STATUS_SEAM_NR) {

Then Dave asked about changing addr itself:

	https://lore.kernel.org/all/487c5e63-07d3-41ad-bfc0-bda14b3c435e@intel.com/
	https://lore.kernel.org/all/79eca29a-8ba4-4ad9-b2e0-54d8e668f731@intel.com/

And it seems like user space does expect addr to be a physical address:

	https://lore.kernel.org/r/807ff02d-7af0-419d-8d14-a4d6c5d5420d@intel.com

Something like below would work, but doesn't answer Dave's question
of why not do it in mce_read_aux()

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 4da4eab56c81..53c7ea3d0464 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1655,28 +1655,30 @@ noinstr void do_machine_check(struct pt_regs *regs)
 	} else if (m->mcgstatus & MCG_STATUS_SEAM_NR) {
 		/*
 		 * Saved RIP on stack makes it look like the machine check
 		 * was taken in the kernel on the instruction following
 		 * the entry to SEAM mode. But MCG_STATUS_SEAM_NR indicates
 		 * that the machine check was taken inside SEAM non-root
 		 * mode.  CPU core has already marked that guest as dead.
 		 * It is OK for the kernel to resume execution at the
 		 * apparent point of the machine check as the fault did
 		 * not occur there. Mark the page as poisoned so it won't
 		 * be added to free list when the guest is terminated.
 		 */
 		if (mce_usable_address(m)) {
-			struct page *p = pfn_to_online_page(m->addr >> PAGE_SHIFT);
+			struct page *p;
 
+			m->addr &= MCI_ADDR_PHYSADDR;
+			p = pfn_to_online_page(m->addr >> PAGE_SHIFT);
 			if (p)
 				SetPageHWPoison(p);
 		}
 	} else {


