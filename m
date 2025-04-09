Return-Path: <kvm+bounces-42984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A4580A81C66
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 07:53:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63FB41BA0311
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 05:53:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 065D81DC98C;
	Wed,  9 Apr 2025 05:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D6hKidbM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8267E152E02
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 05:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744177988; cv=fail; b=LU8xKAfQDg8X09Jlg4an1GzEdQZkRY8FGjIulmHqtuRkb3uR/m2sp9MV6wVIDzVUM70wocD5L/6sJcn3JTMscuwnEl7iUE2IxvRUrenNNCTefl9rrH8UGwI1uw1+45ryqgp55wVsmYipU+nhPmXyByswkj0YMqL1YD5mpoeP1Ms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744177988; c=relaxed/simple;
	bh=r3CCOLT+n20IQnZQDz4WUEB278A0pp3DRGg7rEmsLLw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qbvEkwMjJWYvRT3OFZq/zayJpboMsK+FSn8c2Bn0RFKHUAsiauWAaaRZu5hQRSQrjRrwtvgkW2jb/bAr97zQZsf0ta4m3g/HxyjB9ND07NpxW3o3Cv9bDY0F1fUgd8eRkTQAEKcyUAhK6iWSQmj4FBCIK6Jiiuzvo1ACqYfVmao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D6hKidbM; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744177985; x=1775713985;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r3CCOLT+n20IQnZQDz4WUEB278A0pp3DRGg7rEmsLLw=;
  b=D6hKidbMHfFJYWwErduRcWEu4io1aD4v0DnpuNnaN7PwFgah761/a/gx
   vSqNXDDmkBKhfFLfKBRprH5zg01AwQ8GMjI10NOAZb5LPLVin6YNzf5i/
   1JJW3tUtBRq7cz5H5cZJ6ltaEbubmSzPB4Fo7QQWwemIa9s56VuZXl6iy
   T2b6ghNB6+Zv4X9Gs39mUfR+oluATEHjCUw+8cZpQP6HTrjIES2SRYQGD
   KlZwDTFl0XNqb9PKcf6mPYwYpfYEwWtKWUvDqzqBwbRpoeHDB+SxsKOdZ
   qNzEx8uzCUzI2dhHgRPVP0Iw2URMejolBkKfGEvrp7tcaCUhxBFsXWWyN
   w==;
X-CSE-ConnectionGUID: lNh05R+fQCad+bLEh3qkPA==
X-CSE-MsgGUID: Jc581rRuT7O3kmx2hw/WgQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="71009801"
X-IronPort-AV: E=Sophos;i="6.15,199,1739865600"; 
   d="scan'208";a="71009801"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2025 22:53:04 -0700
X-CSE-ConnectionGUID: 58Z1LcP7TP+pvYKQzOzftg==
X-CSE-MsgGUID: gQhF2N9DThmLDLswGbOchQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,199,1739865600"; 
   d="scan'208";a="128990865"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Apr 2025 22:53:04 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 8 Apr 2025 22:53:03 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 8 Apr 2025 22:53:03 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 8 Apr 2025 22:53:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Doqz/51I+Q2hQN7xCu2HeTFnqZ6dqFse9WPxHYTxTXEUCaXxL9ArHMsiffLJmg/dYT60rjmsBlruFV1JSaoHlrbufzG/vtSYaFGItOzcZCagUdz17qHcupHBpHJBClA0AGZfHW8TA4ixFyZH+niYMB4FMNDbUorm0PhCqh1a3l7RTFic1FEaqg8Zya3STzfQabscK4MiLSCJz7RAU2PgtD2Ijmy/ERc5wTaHvUX6X9QoEbrCN5pcUne28uKmuUMeApOdmociFochJPdfIvDMTo9MZPsfd2prM5q/zPWZXadn66qyI0EkR2ZTttz1E4me1+d0ARuSZPO9cf/kOy9VOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SSJm+HyosYeKyo4s55kD83kPI8VDlCH9liA8gUvCXRE=;
 b=KC4L/BH6yhG4jYtGtCEh1OQokLq6PmIBHXhYS4aRSNXYIVRuMcxCYJlCnRLtjYbWIg4YJJ1DiFKgQ225p366/XjSya3dKT2JTtzqzodcvx0V9GfBi8RaY18XJhiW6Db6R6NK2mpVzZAzKggnw3G7rT71Ug8akCSzpTZ15cGixHwvCYPMR2lhR+4XBh91on1biDXqbl1Xlyya/D5YHede4idMcK93aoRp4T/b6jhyqr3AZszrEpP3luYaTx3ce/mbI9J8MEQxGlCb4jWl3JLxp6GPNFo5+uB9k80MtapbNWYUAvVQK0uMD1ixjEay9pk7+YW7251wrqd3qgaFxiS2QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 PH7PR11MB6402.namprd11.prod.outlook.com (2603:10b6:510:1fa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Wed, 9 Apr
 2025 05:53:01 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%7]) with mapi id 15.20.8606.033; Wed, 9 Apr 2025
 05:53:01 +0000
Message-ID: <7436cdd9-513c-483a-a994-8602142c7551@intel.com>
Date: Wed, 9 Apr 2025 13:52:52 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/13] memory: Change
 memory_region_set_ram_discard_manager() to return the result
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-3-chenyi.qiang@intel.com>
 <d4b44d77-3522-42bd-b02f-fe2e9be65857@amd.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <d4b44d77-3522-42bd-b02f-fe2e9be65857@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0041.apcprd02.prod.outlook.com
 (2603:1096:4:196::20) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|PH7PR11MB6402:EE_
X-MS-Office365-Filtering-Correlation-Id: d7d3020a-d850-45a0-6bee-08dd772ac97d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?b0F3NXZCbHBwOUVhczc2MnBWWm5NVWxLd0w0Tm02cGNEQlFQeGc2dzd6Y3VB?=
 =?utf-8?B?UEVNaDk4YVBJZVJWL3kzSWhEQWpTSUxQcTdDeDJ6ZnN6S3UzNlBoYU5qS2Ev?=
 =?utf-8?B?L09EV0VXSWcwOXQyZTE4SXpXejV2a2JUUlBWeXk0NDVZYlUxWlh5Q01YWFZ1?=
 =?utf-8?B?ZVh1U0VuWWJjWlVuSzBZcHNvdENKalNpbTQyTk5zeUFEZW9VY2JUUTg0bENF?=
 =?utf-8?B?QkJtZk85NXgzdjcwbnRXMnNMek55aUJ6bVRXbXh4WDNqV2c3MENBNmx1TWJV?=
 =?utf-8?B?RlZ1TmIyaHIxN2NOVkV5UmlSMVlyc256VzFDR2NIcHVoTWRlei9rWDVtVGtz?=
 =?utf-8?B?OFVjL2xKMUpFOFcyZG9vQmlNK256bU4wN094eUE5Q0tUL0FlSjV2NkdrbWZz?=
 =?utf-8?B?aWEzbldVWGErN3NIWDFXTmFQQW5RRk80dEVFWE9lMUlndTRsRTd6ZVByNlVh?=
 =?utf-8?B?YXlwVjdkckxFSnpaL0J6Wk9POUswazhOSExnSSt3TUYyZC9uMVp0NnA4ZnRU?=
 =?utf-8?B?VFpIVUF0QS9STkNJTk5NMktweFVXdFc1NzdwUEZvZEhEZHF0RGljVmZ1UG5y?=
 =?utf-8?B?T3lrUnVDeTVyTVNCN3ZkS0lsZkNVTkdMM2dObndJcjZSbENqRnhTUGpTMy8w?=
 =?utf-8?B?a0tmOFZISU12R1ZBeUxhbUZzNVZDQ3VkTnl1d1pzNGtka2s1cWRIOHpuWGxp?=
 =?utf-8?B?V0Y1TjAyZEdpaHZGeWRQbVJoSjZQTi8xdHcwVklUZFNodytvTGpuVU5ibFN1?=
 =?utf-8?B?R2JUVjd2ZFdpZHZTdlVpVGhJVTd6b3YzSTZDcFR0c2dPcFpucWozTTVmcVZz?=
 =?utf-8?B?bjFmeDJ6Rm5iV1NqTnl3VzlhbUE4SFpiQnIrSE9Fc2lZeURRQkdTWGwzUWVp?=
 =?utf-8?B?dEhNSWFBUkJUQlA4Z2h2dm0yRHlOT0JRQlhRTGhYcEU2UjYzSmNtdG93UnpE?=
 =?utf-8?B?WVBiOE8xTVdKKzBYOWdQbFNkOTVtMTliMkZNS3JHbldlV2tJRGJHa0pjRXdJ?=
 =?utf-8?B?dnFHT0U2L2RvWUVIZTk3U29XZnd5SThmYlRONWNlRWFKbk45V3RvakJSMWhn?=
 =?utf-8?B?RjdNZzB2QThoZUxLMEY3WFoyYlZqUG1yVGRHbFNEc3NXTXlUbURwUm5vTFl3?=
 =?utf-8?B?QTVMaFphZ3U4bTZEbENPYUZXSVpQcFVOZjVIcTB0RVp3Q0ZNZ1pZS2daeXVK?=
 =?utf-8?B?OTJ6T2duMUQyNXVRSmlDNVdKQ0VneEFSTDdvWkZnM2o1NmpDNFNRMEtCSXFl?=
 =?utf-8?B?b3JXU2p3ZE9BMW9rbzlpVGpHbmhUOENFQmU5SGdkNzRwVlVieHpmU0l6UHBO?=
 =?utf-8?B?WjJnQzJqTmdvVUdySkNZZVRHVUdQTXRBWU5zOXk0ZFFuMmF6SlVhM2U0NCtU?=
 =?utf-8?B?SnpOVmZ2cG0vU0kydk9hWCsyOGhHS1dld3pqK1hOekFYdGlLNk8zY3NFVzl2?=
 =?utf-8?B?eC9udGlaTDBhbFBLRDdRY0I4N201NkNIeHVaT1dWdFVQYUZKTkFCbjVZR0ty?=
 =?utf-8?B?blpTVGFTOUtGZG1sWm91Y29qNXJQb3NBWURmNEIvQ2xVRlNnaWpEYzB3TlVq?=
 =?utf-8?B?M0MyYTVhZ2hjUjJEWnpXdEVwSGdnKzREa2VIZE9PMGlBN1dRRmhqRVN1SHFF?=
 =?utf-8?B?K1hDeVAyQTg5bmZPWjVBL2t4Qy9lNksrbE8rRERyZlc3RlEzTDRoa28rT2tT?=
 =?utf-8?B?NXREQWFERUZjcDkxQjRDMUxGRDRERml1eE5QNGRhMVFIZGJLSS8zS1NFV3Bu?=
 =?utf-8?B?ZjBwYjdDcnVSSXl3Sk5wS1ZOelowZXZ6SUZ5UDVmc0xXRUZnTGIwU2FXMkls?=
 =?utf-8?B?eWFidTZJclRLRDdTUk5EaTlJM044WFlXUUtGa0RqbGdSemZqdHdyM3R2eWIv?=
 =?utf-8?Q?n52TVkTz0YCQw?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L2pxdGZmRUFHaEUrS21rMUZDSVZFY3lJcWRIVkxVNStxWm0vWkFUYUMrcFRE?=
 =?utf-8?B?blhBU0NucmdoMlU2dEhJd01LczZGRVU5R3ZwcUhiNFlzVG9JZTNTT25pcVk0?=
 =?utf-8?B?a3VvWlRNbThndnFkdGxROHA3NlFZTzgvMnYxd1JnYVZMWkNXaldjaWdzUmM1?=
 =?utf-8?B?MjlRWkpiR05kTmQ1cVNCNFYyV21IaTVzSHhrMmYvdURWL1JSWXRFdk5MOVQ0?=
 =?utf-8?B?M243WmZuU2pabEVFUldJaEU2QU5QaDRGVlQrUEdKdG52cXppanhVdHpUbmVG?=
 =?utf-8?B?NVUxSmsxTFJDNjgrR1pPL3VuRTNta2hSNXU3WCtIN1JGdU85YmR1c3NraVRJ?=
 =?utf-8?B?aTRtcGI5NjFFdDdGY0Y4R21VcUVWSWhvcEFoZTV1S2ExTi8zcUdEdUtsdkhi?=
 =?utf-8?B?dktIQ09XZWRFdFZwcHFkSUx4NitJMVJka3VTNUVqYmV5ckZZMkI1U0xNNXh3?=
 =?utf-8?B?Nnlma3N3Tkh3bFFPZTV0dldZbHI4WDZQdWJWM2kvdnVJWjYwdjdSM245eC9T?=
 =?utf-8?B?Yy9rM2ZsMzJrMlNwM2xNN0toUVgxNGVkRHFFL0tscUFBR1BCRHZibjM2TW5R?=
 =?utf-8?B?cnZsNmlHWnJ2MUJZT0hHb2RxWHJxb2hnSlhaRklhMFpFb3ltRldkN2RzbTJB?=
 =?utf-8?B?NkhUZkJrMGg0N0tnT2lnTUFqSGNZTVBORkxvK3d6anhJQ2hRUGZzbTAyYmNa?=
 =?utf-8?B?VGRoQUo0dEF5NGJqTUxVaXRsYmNJWnVzQUo0LytmK1c2RDNiV2Q3TDNncXM0?=
 =?utf-8?B?ZVB0TCtvOG5uMURDMHUxNHdQaW1mUU9pYnlaREZPejM3TGc4NFhzU1FPaVJy?=
 =?utf-8?B?MXh4NlI0SVV2S0NMNkdvVTQrMXJYWmhHcVNmalJVK3ZCUEQ5VTFSUVQwYy9z?=
 =?utf-8?B?a3E3Q2l6cWNEVHVHYjVDU21UVVlISmx5SWQ5ZE5mbTRpMjYyVXBCR0MweVZm?=
 =?utf-8?B?Ry9pSHJESmJzWkVFYlFuNVNQS3FSOFFiN0VXTlZ3Y2NrdVF1N0N2WUVVZDVh?=
 =?utf-8?B?S05KUHFtRnBQZ0ZXbnpFM21MMTI4eHBKankraXRwa2lvSGw5R0ozb0w0cnYx?=
 =?utf-8?B?OEZmN01Dd0hnMDdiRW1JMDBzZ01oU3lIVmRRR210cG54K1grNnk1Y0VDa2l4?=
 =?utf-8?B?WjRyOGJGZi9udnZ3ZG5iOW0rRDZmV2lONXR0ZCtKREpIRGsyMlQ0Y3NqeVBq?=
 =?utf-8?B?OFllNEFuRkQzNWVYNEJWY01pNDY0Y2tFaEQ2M0JtcTZoclVEcW5uODZzQ0Iy?=
 =?utf-8?B?Y29pM0Jra0dwL2cxajFjMDUza3RMQUxaZVRWTlRzL3VkVVNyYy9RVGdaZ3lI?=
 =?utf-8?B?Uk95U2NUYkdZYlZEWTNQZkFUNUNLSExBUkJGcllaSDA0Z3Z3OVdXMDgxN0s1?=
 =?utf-8?B?L2RvN3dGc1V5Zk5mTEZQQUgvMEJRM1VOOWNrNm9FaUU5Tjg4eC9uYy9CZjgy?=
 =?utf-8?B?dXBsbjVQY2R0L3JLMDAwQVllQndsdlJtTXNxMEdJdzZTTDdNemhGdWZZVUww?=
 =?utf-8?B?YTZGK3JUL1VNOEkzUnhreXkrK2JhaWlpb1dUMVJqVUk5NEs1S2twUjFCOUd6?=
 =?utf-8?B?TzdsU2lUbWFlbFZBV3h2dWdUelJkSmh5NkxHQ0s1M01pVUhyUStVSnhpcGtP?=
 =?utf-8?B?V3g3cmwrOE5CYTMxTStRR05vczVFbEg5MDVQQ3VQQmZuWDM4M2ZiUDF5VVFo?=
 =?utf-8?B?MXlhckl2WU5DSW5LUGVHa2dXWXNEYzZGVzhWQVJqZjRLb0RNVHpIMnFaSEJQ?=
 =?utf-8?B?YWx6azVaRjRnS3hITFZxVWpBbWVOVWg1NWlBZTNEalJ2UmtUQVZQdTlMby96?=
 =?utf-8?B?QzAyQ1lsNy93MTJMbHg5SHE5d2RJT0pjdTVTd2E3SEl5dDlwZzV1UW12QTBw?=
 =?utf-8?B?VWxtaWczaTBMSnIxSEw0dGNBVU94U1Jod05jcktBRzh3dEVaTjRVdkxEa1R5?=
 =?utf-8?B?U0pPejIycEVzZjY3VHUrU1JaWFg3bFVmUHVuOGxVWktUSUVJNS8vSHE4OGtL?=
 =?utf-8?B?OWlJbHRnSDZvaXd2RlEvWml3cHM0NG1CejdVNGhieTBOcjBlZFJFRGV6YkRm?=
 =?utf-8?B?aDNqSWcweVBVMlVIdEl3TVdobVA3NFJuaTQyQ3RvRXdZRFAyTGhuYkZ4b3d2?=
 =?utf-8?B?ZmMvdjYwMW9WTU15eHVzVWk4VHZ5VDR6ZzVtWi9icGpxL3h0Wm5TblFtQktj?=
 =?utf-8?B?N1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d7d3020a-d850-45a0-6bee-08dd772ac97d
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 05:53:01.2637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XjZE4ogWS6qvUZGYhayYeNZhIPWcK1srNN/c1aFFbtM+7pHXM5SD3oLDj+E24Cgv4nA+nG+oRc68vavL5PtuUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6402
X-OriginatorOrg: intel.com



On 4/9/2025 1:35 PM, Alexey Kardashevskiy wrote:
> 
> 
> On 7/4/25 17:49, Chenyi Qiang wrote:
>> Modify memory_region_set_ram_discard_manager() to return false if a
>> RamDiscardManager is already set in the MemoryRegion. The caller must
>> handle this failure, such as having virtio-mem undo its actions and fail
>> the realize() process. Opportunistically move the call earlier to avoid
>> complex error handling.
>>
>> This change is beneficial when introducing a new RamDiscardManager
>> instance besides virtio-mem. After
>> ram_block_coordinated_discard_require(true) unlocks all
>> RamDiscardManager instances, only one instance is allowed to be set for
>> a MemoryRegion at present.
>>
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>> Changes in v4:
>>      - No change.
>>
>> Changes in v3:
>>      - Move set_ram_discard_manager() up to avoid a g_free()
>>      - Clean up set_ram_discard_manager() definition
>>
>> Changes in v2:
>>      - newly added.
>> ---
>>   hw/virtio/virtio-mem.c | 29 ++++++++++++++++-------------
>>   include/exec/memory.h  |  6 +++---
>>   system/memory.c        | 10 +++++++---
>>   3 files changed, 26 insertions(+), 19 deletions(-)
>>
>> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
>> index 21f16e4912..d0d3a0240f 100644
>> --- a/hw/virtio/virtio-mem.c
>> +++ b/hw/virtio/virtio-mem.c
>> @@ -1049,6 +1049,17 @@ static void
>> virtio_mem_device_realize(DeviceState *dev, Error **errp)
>>           return;
>>       }
>>   +    /*
>> +     * Set ourselves as RamDiscardManager before the plug handler
>> maps the
>> +     * memory region and exposes it via an address space.
>> +     */
>> +    if (memory_region_set_ram_discard_manager(&vmem->memdev->mr,
>> +                                             
>> RAM_DISCARD_MANAGER(vmem))) {
>> +        error_setg(errp, "Failed to set RamDiscardManager");
>> +        ram_block_coordinated_discard_require(false);
>> +        return;
>> +    }
>> +
>>       /*
>>        * We don't know at this point whether shared RAM is migrated using
>>        * QEMU or migrated using the file content. "x-ignore-shared"
>> will be
> 
> Right after the end of this comment block, do not you want
> memory_region_set_generic_state_manager(..., NULL)?

Nice catch! Miss to add memory_region_set_generic_state_manager(NULL)
for the ram_block_discard_range() failure case.

> 
> 
>> @@ -1124,13 +1135,6 @@ static void
>> virtio_mem_device_realize(DeviceState *dev, Error **errp)
>>       vmem->system_reset = VIRTIO_MEM_SYSTEM_RESET(obj);
>>       vmem->system_reset->vmem = vmem;
>>       qemu_register_resettable(obj);
>> -
>> -    /*
>> -     * Set ourselves as RamDiscardManager before the plug handler
>> maps the
>> -     * memory region and exposes it via an address space.
>> -     */
>> -    memory_region_set_ram_discard_manager(&vmem->memdev->mr,
>> -                                          RAM_DISCARD_MANAGER(vmem));
>>   }
>>     static void virtio_mem_device_unrealize(DeviceState *dev)
>> @@ -1138,12 +1142,6 @@ static void
>> virtio_mem_device_unrealize(DeviceState *dev)
>>       VirtIODevice *vdev = VIRTIO_DEVICE(dev);
>>       VirtIOMEM *vmem = VIRTIO_MEM(dev);
>>   -    /*
>> -     * The unplug handler unmapped the memory region, it cannot be
>> -     * found via an address space anymore. Unset ourselves.
>> -     */
>> -    memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
>> -
>>       qemu_unregister_resettable(OBJECT(vmem->system_reset));
>>       object_unref(OBJECT(vmem->system_reset));
>>   @@ -1156,6 +1154,11 @@ static void
>> virtio_mem_device_unrealize(DeviceState *dev)
>>       virtio_del_queue(vdev, 0);
>>       virtio_cleanup(vdev);
>>       g_free(vmem->bitmap);
>> +    /*
>> +     * The unplug handler unmapped the memory region, it cannot be
>> +     * found via an address space anymore. Unset ourselves.
>> +     */
>> +    memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
>>       ram_block_coordinated_discard_require(false);
>>   }
>>   diff --git a/include/exec/memory.h b/include/exec/memory.h
>> index 3bebc43d59..390477b588 100644
>> --- a/include/exec/memory.h
>> +++ b/include/exec/memory.h
>> @@ -2487,13 +2487,13 @@ static inline bool
>> memory_region_has_ram_discard_manager(MemoryRegion *mr)
>>    *
>>    * This function must not be called for a mapped #MemoryRegion, a
>> #MemoryRegion
>>    * that does not cover RAM, or a #MemoryRegion that already has a
>> - * #RamDiscardManager assigned.
>> + * #RamDiscardManager assigned. Return 0 if the rdm is set successfully.
>>    *
>>    * @mr: the #MemoryRegion
>>    * @rdm: #RamDiscardManager to set
>>    */
>> -void memory_region_set_ram_discard_manager(MemoryRegion *mr,
>> -                                           RamDiscardManager *rdm);
>> +int memory_region_set_ram_discard_manager(MemoryRegion *mr,
>> +                                          RamDiscardManager *rdm);
>>     /**
>>    * memory_region_find: translate an address/size relative to a
>> diff --git a/system/memory.c b/system/memory.c
>> index b17b5538ff..62d6b410f0 100644
>> --- a/system/memory.c
>> +++ b/system/memory.c
>> @@ -2115,12 +2115,16 @@ RamDiscardManager
>> *memory_region_get_ram_discard_manager(MemoryRegion *mr)
>>       return mr->rdm;
>>   }
>>   -void memory_region_set_ram_discard_manager(MemoryRegion *mr,
>> -                                           RamDiscardManager *rdm)
>> +int memory_region_set_ram_discard_manager(MemoryRegion *mr,
>> +                                          RamDiscardManager *rdm)
>>   {
>>       g_assert(memory_region_is_ram(mr));
>> -    g_assert(!rdm || !mr->rdm);
>> +    if (mr->rdm && rdm) {
>> +        return -EBUSY;
>> +    }
>> +
>>       mr->rdm = rdm;
>> +    return 0;
> 
> This is a change which can potentially break something, or currently
> there is no way to trigger -EBUSY? Thanks,

Before this series, virtio-mem is the only user to
set_ram_discard_manager(), there's no way to trigger -EBUSY. With this
series, guest_memfd-backed RAMBlocks become the second user. It can be
triggered if we try to use virtio-mem in confidential VMs.

> 
> 
>>   }
>>     uint64_t ram_discard_manager_get_min_granularity(const
>> RamDiscardManager *rdm,
> 


