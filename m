Return-Path: <kvm+bounces-31813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A8F99C7DC2
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 22:44:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9E96EB22670
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 21:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B8F018B49D;
	Wed, 13 Nov 2024 21:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="COwldz5H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502FF1632FD;
	Wed, 13 Nov 2024 21:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731534268; cv=fail; b=kEqz4EC8Nmg66TQr9qaGIIbUzTz6T+E35qZxD4ZSvNmj9PJVwNBu0HO8W6Ir8rBCptoxzq94MInshkJGsS2GL0Bw5ew4Jj/JjrLtnlqw+xCsoPGXELxJLBkDBKc+TUFi3MwV2U0ql9TZGuI550pNKIwUNv5uV/uuNLRGYZ/ijLE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731534268; c=relaxed/simple;
	bh=KEjUDReIFRakI+mc0wloNMTBrebHsmboKs4DjlZUFqw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=d3XX6UUdaZfKmW2Q8QeV55616xU47qicXkQtPmiXzFvBq5dj5CeySW/lgnz1QrwUWO+BusjGTTPN8d/5uO6PKRhipPwlL3bBStDl0O3u3qwL7GkyamT08uVDZBWhwsHoM9AF/V4kgK4cloWCy1L4bp7ICOZb32ucIdpSh28Du8I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=COwldz5H; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731534267; x=1763070267;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KEjUDReIFRakI+mc0wloNMTBrebHsmboKs4DjlZUFqw=;
  b=COwldz5Hp0uJ5Ig7GwRTijHVNxfJIGVXTj41jvezITVcONxcdz70ePQM
   /a3ld/KIHXOtlMRojVjntjRnX2toktR74NZL5W2NciX+wtAkAzM7CUzjZ
   ygwxHQMIBJiIbLa3TnNFFLWYy0XOOZrz2REFncfKciYDFew7/jc4DL5SF
   mcX4uYMJ8C/UO6qeSoAr9/TU/MrJADnhGiW+VTI//qEOLTZi+GkO06VLJ
   ugZewAUh5XNNEuqFuqqCzdoyv+hXY46ZOsU8YO7Q6TvsknEqxlnqmc5mI
   FrZJLeWEmSSTxNx/w9vad7YUEh6REbxVIeQd+nlDkjJbU51rLK+h4n/lR
   Q==;
X-CSE-ConnectionGUID: 0fwyFnshTEm7z19p24b7Eg==
X-CSE-MsgGUID: dcQ6ajoYQwaMLjmxmCaX4g==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="42865253"
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="42865253"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 13:44:26 -0800
X-CSE-ConnectionGUID: z5kXG4u2Qk+PJzWFIhlNEw==
X-CSE-MsgGUID: VdHksIQiS9Wdc7oRWhPtcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="92916969"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Nov 2024 13:44:26 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 13 Nov 2024 13:44:25 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 13 Nov 2024 13:44:25 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 13 Nov 2024 13:44:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h15W8kTdp6PzswTrum5mp+CQOo5UjWATVhLNEb0Bj+bzI+NVb1UapGaxpvuk9O3zI6m9AoHnLLkEzTzKaNmfwNCHImnnecHnV5JTSSZVu9voTryAVfaTDZdZC21BvpNS6VbjI/f4M+KhLXfadeKJ9gI0d6DBvmCjewUIFMbN8rLr09pZEIUseavQxKGf2YF+59hyVde7XdlWE2hb0EftFtgqKiDZyQ2FRibIE8FeQ5jKZXnUrwtkquCgEOVK7EeqlZapQNCSHnY77pDrn526L4pOCPSrd6gm84rUjhmEiQkSYUgA4fnDtN2Z1OvOTg13uoBfbOthkem4w5W3ICZs7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KEjUDReIFRakI+mc0wloNMTBrebHsmboKs4DjlZUFqw=;
 b=d2Jc/h1hvw/mCorxfsWSE4czPzkupRebVuN7MH/37qjynBIC4PwrkvWklDfTlk4jD0jYpiYpZIq439HHafW0kpzlr3xmFH6++u2R+Mpc9G35RGDeAhKGRG3KNEVQcKpVdkBo2dh38K3UsQodb19oLt+Ue3hsH/qrU9RyFhlJfTLxeVUkpwAfHs6wVsGA04gHFZJJCPR5OWTwUcA2gD0pgBGwgxN9gaC2JUpAMN49cNiS08quoCJ8rJGLSdZti9eForQNNcvW3abTpv2IljdqBMLF7R3xOOyfWJi07H/nfLFbbk07FyZ8ZDEgYhRNAuCgWNdojmYBHTGfPKLG06Uyug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by DS0PR11MB8069.namprd11.prod.outlook.com (2603:10b6:8:12c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Wed, 13 Nov
 2024 21:44:22 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d%6]) with mapi id 15.20.8158.013; Wed, 13 Nov 2024
 21:44:22 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>
CC: "Yao, Yuan" <yuan.yao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
Subject: Re: [PATCH v2 08/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX page
 cache management
Thread-Topic: [PATCH v2 08/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 page cache management
Thread-Index: AQHbKv4rca7tZFwUNEOLKBi110Inj7K0baeAgAFX54CAAATNAIAACg6A
Date: Wed, 13 Nov 2024 21:44:22 +0000
Message-ID: <2adb22bef3f5d2b7e606031f406528e982a6360a.camel@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
	 <20241030190039.77971-9-rick.p.edgecombe@intel.com>
	 <aff59a1a-c8e7-4784-b950-595875bf6304@intel.com>
	 <309d1c35713dd901098ae1a3d9c3c7afa62b74d3.camel@intel.com>
	 <ff549c76-59a3-47f6-b68d-64ef957a7765@intel.com>
In-Reply-To: <ff549c76-59a3-47f6-b68d-64ef957a7765@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|DS0PR11MB8069:EE_
x-ms-office365-filtering-correlation-id: 5acfeef1-fe18-45fa-715d-08dd042c55ca
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Zjl3UnlacUl0WmR0bkxnNlJwUXlBK21rSjA2NHVGNm5KL05obDRIcmJtbmhY?=
 =?utf-8?B?cjJ0RGM0NFRGVTZyY3FRbHB6bEF4cWhWUWZlQTlVa1BQMFhIT28yTmZlQkhi?=
 =?utf-8?B?SjczR3Z1NWxqSmg1bEJ3YzN6M3VkaGdDRGEwNG5BaXlJQWtBdThvTmJyQTBj?=
 =?utf-8?B?d0ZDRDhrZWNjTWNpL0J5WjlTSFhKN0phVEZYZjYzZXBqNmtBZlAzSkJJc0gx?=
 =?utf-8?B?MWNvTXZwYWVHZzc0L29Zcm5Dbm54UGhYTzk2OG56bDY4cEpQR245Zmk5eEEw?=
 =?utf-8?B?emRNMnVPdDVBMjV0V2RoMUFWUWZLd0l6WFgyNW9LZjRxZG1UMm1JNzlxVFM0?=
 =?utf-8?B?QkRkdmI3RWZkelk2c01xcUVEWWw1MFdrME1qS0RlNkdDZUNDZ1hMTEkzU1FG?=
 =?utf-8?B?MzdpajZTa0srcHpxa0UrODRVVDVTNHFlRTg5aFB0ZlI0U05rajdGMEF2Vmpw?=
 =?utf-8?B?M3R4SWQ0TFd3VTVSODBEUUhyR0tUN1VOQ2RkeFVtTmVVdE1yVEtNWm5HS0Zw?=
 =?utf-8?B?MElGc3FVMnJSSlRLY3VSQlFzS3NOaEt0Q2NISy81OWJ5UExndmJiQ0VzTEJk?=
 =?utf-8?B?dmVFaDdWS3FsQmFOSytXL1VOTm5DS1ZkNHJmWk9PWTZLM0VJOWZhMy8xYmhZ?=
 =?utf-8?B?SWJNOXBLc2lxYmc2eHMydGFraHVHVm5sckNKOHJnTWFlRFdSSW5ZUHN4bjR5?=
 =?utf-8?B?RHl0NDVKeEVJRTlVRS9SRkUzOUZNYlhMaFcwUTExa1hCY1lva1NMM3hFZi9n?=
 =?utf-8?B?SmJHU2htRDNuVU5GSlRXYko1UERyM1RsUnZ1Vkh0VkNOUy85S2U3U283NkdC?=
 =?utf-8?B?VHoxTVZGNU1rSHJoVWtaSHF2OUxHaHBlbHBJZDk4ZnJmWUYwWXI5MmpReng0?=
 =?utf-8?B?UmJzQWczc3FydklQMGlqUStqNVgvUXNPczYvTFd3aWgzSGFubVl2RHkza0FI?=
 =?utf-8?B?ejlOVXRIejMzSXJBbk5BMXJrb3JUWGRCTGJhNnBSb0E3a0E2NThJb2R3a1pK?=
 =?utf-8?B?eE1vc3Y4WW9wWFpNb0hqY0ZtRlBXMURkaXJNVkZKbFh0K2FPM1FjODllV1NF?=
 =?utf-8?B?MVNCUHA3WXUzNnR4NE9scVZGZEYyamNicEd3RDl5VnBmNkdzK2J4V2xqd1FW?=
 =?utf-8?B?ZXZyL2dLRHBHRnpPcXZydVNWUXI3TnhpeFkzSXl4dlZ1WXJmK2plbkUydUxs?=
 =?utf-8?B?Myt5OERsM1lhUnUrOUNCd3lIcE1ybTk1RWNNcDYvNjg0ZUpGdk1Ja2UyeDcv?=
 =?utf-8?B?M0Y4WUZaZzJYQVlHT2RzZ2MzY1B0bnhNcEtEL3VJQ1lBdE1mRTNHV21LbmpG?=
 =?utf-8?B?ajN2LzFSYUdTN01Hc2w1WTY2MDJ0eDdBMTFZQWpTRkpWUEdxVjdvS1djR3Vv?=
 =?utf-8?B?cmRFUW9wY1djK0VpSlZldFltUVpPak9rdWpVdTVmZzZpcEkxZDgwWkhKcC9P?=
 =?utf-8?B?RmYvRWVvaVpsZjJMWDM5d29ueFZoWXJFQTNiWG1yQ3NQMXRFWFAwcnFVVFJV?=
 =?utf-8?B?T3MraXZIUFNtYUhTOVMxV3dJeTFJVXlJRDIzcG5kbFY2TjFiVHpXM0tlVU1m?=
 =?utf-8?B?dUFLYWhIcE9MWHc5OUQ0Q0RvU1JvUjZGampvV0lDc3lHaUpodGNSdC9OblR1?=
 =?utf-8?B?OElYZ080WXBDblV5SFZHMUhSTVdvNVdFaHJVblUvTjMzSjhGakkwU3NzdTNo?=
 =?utf-8?B?Q1RVVGZ1bVdmS3VQaUk0TUZUbzIzRU41Sy9YQTYweEZBSEdVM0JvbmxCTUow?=
 =?utf-8?B?UG9uS2VWcEZvazI0U0kwNHkzUFRwVERaYXpjQ00ya1dzT1c5M01BeC9NNjVG?=
 =?utf-8?Q?Z1fKllmudc3Ekvh8E64+WLPz3c7D7Y6RaWh7o=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RFNFT1lmTFRMd0hrU0Vacmd1bDNUVUJpYzdSMDVLWks2RldEQWhrcmRrbk5v?=
 =?utf-8?B?aXNhNGFMQVk2ekZIZTFaVnZvZmh0SXdFWEY2WlYreUI0Zk1jRlA4YmxMdXR5?=
 =?utf-8?B?ak56NGN1MWV3Tk5YU0tsa1N0RnRYUVRKVFNlazlXWFFDRlRoREd1SW5BdVNk?=
 =?utf-8?B?M1EyTGttelEzMFZWYVp0VTB2Ykljb1k5MnNTcEZPMzNzeHJobWJjZDRVU3BK?=
 =?utf-8?B?cXhlY0VqQ2VQNkJsRjZvZHNwc2t5K21lNGNEcVFJdlhpVHZzdm9aTVJLcUNw?=
 =?utf-8?B?bmdNTHM0Mzd1eDZjTU5tU3Q4OS9aWll1V3o2cEpBRitZbXpuQ1gwc3FoWjFN?=
 =?utf-8?B?UzFIVmEzLzBYRHh6WUFudU5LbDVGazBNL2hjOWxzTW1QdkNORVRZRStTZC83?=
 =?utf-8?B?VTNqQjVMbVo3WTNxZ1pxL3BVZWhDUnVYQnBBdjZXcEJyR0ltZ3RtcENIKzJ4?=
 =?utf-8?B?Y0hnaTcrR01seHdlS216Z0NjOHViWnlueDh4ME42TUo4bzNyOWc1eUY4cjdp?=
 =?utf-8?B?Z2x1QSs5UWlma2pBTnZVVStBWEVSazBScDIzRktOUklDa3ovWTRmVkJNUW9G?=
 =?utf-8?B?SDBBVnRMVEQ5dWVuazltL0RHZXlhc2s0VGFCaW5CSG1XT1BWZjkzN0p0V2dP?=
 =?utf-8?B?aVNHZElIUDk4RjZmLzBEMTJxYlRyTFc0UlVYSWYwcWhTSEgxYnpVMk8wZ29H?=
 =?utf-8?B?aGhRQ2FvY2dqMlV1QW1VaG1tcExBaUFpMVZMT2VDSkhSMUF4NkJocExqOVdi?=
 =?utf-8?B?Y1lhNzJZTUMrdXVZYTFuRmpSRCtjVG14b3I3NVVNWjdqUFdqMmFjZk5XQzB4?=
 =?utf-8?B?MjlJbnYyTGk5dStlVWNVK3ZrZW9zOXpDWmpFNUxKbko0YTlTbXVlcHBZN09V?=
 =?utf-8?B?Y29kTlloTXp6djZ4S0Z4bWI1aVVXc211SCtJdCtteXg3R3RBcjQ5WEpkbWdF?=
 =?utf-8?B?WmxZWERVa3VOMEorZDhWUHFHMWFJRERLdkZlRXVHaGI4Zm1Ib216UnJqclJY?=
 =?utf-8?B?SnpPcHVtd1JmWkU3QStzVWdQZ1I3WVRiZndkRTJFWmMrNGNDTUpYSkU4SHNu?=
 =?utf-8?B?QVpQVzMxSGJMb010Tmx3N1ljV2dKNkdTM0thNEtVZzNwbXRpMnNOUXJ4TmdI?=
 =?utf-8?B?ak5sdlR1bERxb2M3dVFLYUhMWm5ERG1ydHhZVXNhOFMvSDhhSEdtNmlBZTJN?=
 =?utf-8?B?ZmZXTHc5U1F6aU9iSWRscEU0Mko3WDd5WmthZTlHeHB3ellkQllvNjVRWXhG?=
 =?utf-8?B?UjdxaDNuKzg0OTdBd0ZLNVNSWHBEYmhLMGhoUkZNTERvcGVIWW5UY3hGYUhs?=
 =?utf-8?B?WHZDOXVzMUVVS3RtYWlOWG5BU0Q5VVJNa01KRjFGVjdVa2gxU3FHMmtBcFhV?=
 =?utf-8?B?US9vNHBHYjUxaWhkdmJoME45UExGcFArTTRMbFM4dG1rM241NmY3K21NSlQy?=
 =?utf-8?B?VlQxbzhoUjBuMm15cW5TczBIRFFjaC96ZnowN056WEtZUlFBaWdFajlkSnFj?=
 =?utf-8?B?ek5HeHVCQkNxaERPZnN3a3I1ZmRCcmRzYm9mYzEwVnFxaTIvTHJmZ1NPemdz?=
 =?utf-8?B?Mk9SR2JiRVp0UWRMNEN1ZGxVUkF6OTkzUEFlZks1M1RZck9YQStBcXo3RGRH?=
 =?utf-8?B?YnZSUHBuMHJvNEFvR3MxWWlLQ2JpeHB6Nmd3UG5kVFhtZFlnRGpFTi96U0dF?=
 =?utf-8?B?SVdPZ2YvUXdObmkyZTVBSVNkSlhGMUJRT2Y1VnArSjdqZDJodmcxZnoweGMy?=
 =?utf-8?B?c3VxMHM1YWJ5SDZMcWREVGx4QlBKYkU1SkJ1K3d3b1hoMXFTUzdBY0d5bm1B?=
 =?utf-8?B?T1pWQXVaQTZWZG4rMVREL09TQ0tBalJJOHdEY2prMGNCTDY4V0dmMlVRcU16?=
 =?utf-8?B?Zk9DY2Z4RzJvelNQZzNsZVdNMFhmU1gzVThkV1ZqNW9PRHV5RzMvM2tMc2Zh?=
 =?utf-8?B?NTMwcjcxUzdRei84TThPam5BcnpVclFJaStJK0IzeElFVWRTQ3dLOWNaN1F5?=
 =?utf-8?B?SDhCSmpnaytqSENFU3FzTEIvaFFuWkNlSlZWSXI4R0dKYWlobmdJeTJua3BN?=
 =?utf-8?B?M2xjMlY3U3hoSU94OGFDNDU3QjFzQk81MS9jZUlBT1Y2YlY1YmVPMGxPd09o?=
 =?utf-8?B?a0tidDQvN3JXZXA0K3RmTkdKendEL0RRYjV6d3ZBSnNHVUpFRWFYODJyeE1u?=
 =?utf-8?B?b1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9B3CCFB795699F4C99F0A1E6349C1E87@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5acfeef1-fe18-45fa-715d-08dd042c55ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2024 21:44:22.0714
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: li0SHfqDMMuet3HBrEg00FkK0aTF1npONWzYdqo9m2TFOL7Gy7nsq4qu7M2OZmkP0jbPRggy1I0LV0opiKolQqKfiL6Ju2SKBZYZCPqkAWY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8069
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTExLTEzIGF0IDEzOjA4IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
TGV0J3Mgc2F5IEkgc2VlIHRoZSBlcnJvciBnZXQgc3BpdCBvdXQgb24gdGhlIGNvbnNvbGUuwqAg
SSBjYW4ndCBtYWtlIGFueQ0KPiBzZW5zZSBvdXQgb2YgaXQgZnJvbSB0aGlzIHNwb3QuwqAgSSBu
ZWVkIHRvIGdvIG92ZXIgdG8gdGhlIFREWCBkb2NzIG9yDQo+IHRkaF9waHltZW1fcGFnZV9yZWNs
YWltKCkgdG8gbG9vayBhdCB0aGUgKmNvbW1lbnQqIHRvIGZpZ3VyZSBvdXQgd2hhdA0KPiB0aGVz
ZSB0aGUgcmVnaXN0ZXJzIGFyZSBuYW1lZC4NCj4gDQo+IFRoZSBjb2RlIGFzIHByb3Bvc2VkIGhh
cyB6ZXJvIHNlbGYtZG9jdW1lbnRpbmcgcHJvcGVydGllcy7CoCBJdCdzDQo+IGFjdHVhbGx5IGNv
bXBsZXRlbHkgbm9uLXNlbGYtZG9jdW1lbnRpbmcuwqAgSXQgaXNuJ3QgX2FueV8gYmV0dGVyIGZv
cg0KPiByZWFkYWJpbGl0eSB0aGFuIGp1c3QgZG9pbmc6DQo+IA0KPiAJc3RydWN0IHRkeF9tb2R1
bGVfYXJncyBhcmdzID0ge307DQo+IA0KPiAJZm9yIChpID0gVERYX1NFQU1DQUxMX1JFVFJJRVM7
IGkgPiAwOyBpLS0pIHsNCj4gCQlhcmdzLnJjeCA9IHBhOw0KPiAJCWVyciA9IHNlYW1jYWxsX3Jl
dChUREhfUEhZTUVNX1BBR0VfUkVDTEFJTSwgJmFyZ3MpOw0KPiAJCS4uLg0KPiAJfQ0KPiANCj4g
CXByX3RkeF9lcnJvcl8zKFRESF9QSFlNRU1fUEFHRV9SRUNMQUlNLCBlcnIsDQo+IAkJCWFyZ3Mu
cmN4LCBhcmdzLnJkeCwgYXJncy5yOCk7DQoNCklmIHdlIGV4dHJhY3RlZCBtZWFuaW5nIGZyb20g
dGhlIHJlZ2lzdGVycyBhbmQgcHJpbnRlZCB0aG9zZSwgdGhlbiB3ZSB3b3VsZCBub3QNCmhhdmUg
YW55IG5ldyBiaXRzIHRoYXQgcG9wcGVkIHVwIGluIHRoZXJlLiBGb3IgZXhhbXBsZSwgY3VycmVu
dGx5IHI4IGhhcyBiaXRzDQo2MzozIGRlc2NyaWJlZCBhcyByZXNlcnZlZC4gV2hpbGUgZXhwZWN0
YXRpb25zIGFyb3VuZCBURFggbW9kdWxlIGJlaGF2aW9yDQpjaGFuZ2VzIGFyZSBzdGlsbCBzZXR0
bGluZywgSSdkIHJhdGhlciBoYXZlIHRoZSBmdWxsIHJlZ2lzdGVyIGZvciBkZWJ1Z2dpbmcgdGhh
bg0KYW4gZWFzeSB0byByZWFkIGVycm9yIG1lc3NhZ2UuIEJ1dCB3ZSBoYXZlIGFjdHVhbGx5IGdv
bmUgZG93biB0aGlzIHJvYWQgYSBsaXR0bGUNCmJpdCBhbHJlYWR5IHdoZW4gd2UgYWRqdXN0ZWQg
dGhlIEtWTSBjYWxsaW5nIGNvZGUgdG8gc3RvcCBtYW51YWxseSBsb2FkaW5nIHRoZQ0Kc3RydWN0
IHRkeF9tb2R1bGVfYXJncy4NCg0KPiANCj4gQWxzbywgdGhpcyBpcyBhbHNvIHNob3dpbmcgYSBs
YWNrIG9mIG5hbWluZyBkaXNjaXBsaW5lIHdoZXJlIHRoaW5ncyBhcmUNCj4gbmFtZWQuwqAgVGhl
IGZpcnN0IGFyZ3VtZW50IGlzICdwYScgaW4gaGVyZSBidXQgJ3BhZ2UnIG9uIHRoZSBvdGhlciBz
aWRlOg0KPiANCj4gPiArdTY0IHRkaF9waHltZW1fcGFnZV9yZWNsYWltKHU2NCBwYWdlLCB1NjQg
KnJjeCwgdTY0ICpyZHgsIHU2NCAqcjgpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCB0ZHhfbW9kdWxl
X2FyZ3MgYXJncyA9IHsNCj4gPiArCQkucmN4ID0gcGFnZSwNCj4gDQo+IEkgY2FuJ3QgdGVsbCB5
b3UgaG93IG1hbnkgcmVjb21waWxlcyBpdCdzIGNvc3QgbWUgd2hlbiBJIGdvdCBsYXp5IGFib3V0
DQo+IHBoeXNpY2FsIGFkZHIgdnMuIHZpcnR1YWwgYWRkciB2cy4gc3RydWN0IHBhZ2UgdnMuIHBm
bi4NCg0KU3RhbmRhcmRpemluZyBvbiBWQXMgZm9yIHRoZSBTRUFNQ0FMTCB3cmFwcGVycyBzZWVt
cyBsaWtlIGEgZ29vZCBpZGVhLiBJIGhhdmVuJ3QNCmNoZWNrZWQgdGhlbSBhbGwsIGJ1dCBzZWVt
cyB0byBiZSBwcm9taXNpbmcgc28gZmFyLg0KDQo+IA0KPiBTbywgeWVhaCwgSSdkIHJhdGhlciBu
b3QgZXhwb3J0IHNlYW1jYWxsX3JldCgpLCBidXQgSSdkIHJhdGhlciBkbyB0aGF0DQo+IHRoYW4g
aGF2ZSBhIGxheWVyIG9mIGFic3RyYWN0aW9uIHRoYXQncyBhZGRpbmcgbGl0dGxlIHZhbHVlIHdo
aWxlIGl0DQo+IGFsc28gYnJpbmdzIG9iZnVzY2F0aW9uLg0KDQpJbiBLVk0gdGhlc2UgdHlwZXMg
Y2FuIGdldCBldmVuIG1vcmUgY29uZnVzaW5nLiBUaGVyZSBhcmUgZ3Vlc3QgcGh5c2ljYWwgYWRk
cmVzcw0KYW5kIHZpcnR1YWwgYWRkcmVzc2VzIGFzIHdlbGwgYXMgdGhlIGhvc3QgcGh5c2ljYWwg
YW5kIHZpcnR1YWwuIFNvIGluIEtWTSB0aGVyZQ0KaXMgYSB0eXBlZGVmIGZvciBob3N0IHBoeXNp
Y2FsIGFkZHJlc3NlczogaHBhX3QuIFByZXZpb3VzbHkgdGhlc2Ugd3JhcHBlcnMgdXNlZA0KaXQg
YmVjYXVzZSB0aGV5IGFyZSBpbiBLVk0gY29kZS4gSXQgd2FzOg0KK3N0YXRpYyBpbmxpbmUgdTY0
IHRkaF9waHltZW1fcGFnZV9yZWNsYWltKGhwYV90IHBhZ2UsIHU2NCAqcmN4LCB1NjQgKnJkeCwN
CisJCQkJCSAgdTY0ICpyOCkNCit7DQorCXN0cnVjdCB0ZHhfbW9kdWxlX2FyZ3MgaW4gPSB7DQor
CQkucmN4ID0gcGFnZSwNCisJfTsNCisJdTY0IHJldDsNCisNCisJcmV0ID0gc2VhbWNhbGxfcmV0
KFRESF9QSFlNRU1fUEFHRV9SRUNMQUlNLCAmaW4pOw0KKw0KKwkqcmN4ID0gaW4ucmN4Ow0KKwkq
cmR4ID0gaW4ucmR4Ow0KKwkqcjggPSBpbi5yODsNCisNCisJcmV0dXJuIHJldDsNCit9DQoNCk1v
dmluZyB0aGVtIHRvIGFyY2gveDg2IG1lYW5zIHdlIG5lZWQgdG8gdHJhbnNsYXRlIHNvbWUgdGhp
bmdzIGJldHdlZW4gS1ZNJ3MNCnBhcmxhbmNlIGFuZCB0aGUgcmVzdCBvZiB0aGUga2VybmVscy4g
VGhpcyBpcyBleHRyYSB3cmFwcGluZy4gQW5vdGhlciBleGFtcGxlDQp0aGF0IHdhcyB1c2VkIGlu
IHRoZSBvbGQgU0VBTUNBTEwgd3JhcHBlcnMgd2FzIGdwYV90LCB3aGljaCBLVk0gdXNlcyB0byBy
ZWZlcnMNCnRvIGEgZ3Vlc3QgcGh5c2ljYWwgYWRkcmVzcy4gdm9pZCAqIHRvIHRoZSBob3N0IGRp
cmVjdCBtYXAgZG9lc24ndCBmaXQsIHNvIHdlDQphcmUgYmFjayB0byB1NjQgb3IgYSBuZXcgZ3Bh
IHN0cnVjdCAobGlrZSBpbiB0aGUgb3RoZXIgdGhyZWFkKSB0byBzcGVhayB0byB0aGUNCmFyY2gv
eDg2IGxheWVycy4NCg0KU28gSSB0aGluayB3ZSB3aWxsIG5lZWQgc29tZSBsaWdodCBsYXllcnMg
b2YgYWJzdHJhY3Rpb24gaWYgd2Uga2VlcCB0aGUgd3JhcHBlcnMNCmluIGFyY2gveDg2Lg0KDQoN
Cg==

