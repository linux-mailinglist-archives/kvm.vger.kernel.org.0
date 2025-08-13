Return-Path: <kvm+bounces-54616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBD2BB256E9
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 00:45:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3CC0A7BA666
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 22:43:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BAA02FD7C2;
	Wed, 13 Aug 2025 22:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N41joFjn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F832FE04E;
	Wed, 13 Aug 2025 22:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755125044; cv=fail; b=AWdkddM+UHhYCPuc3I/i+fCM6nTyzPCUZoSIjy1KTgytrIzzpsFdkvG35cDQJ6mjPcYa8mj3/8vf7MVhMlXcZxpJel1+CaDnoY43ai2s+U6RDuqumr/pEF3jhcuji6Yhg+XTcXjiC/IBhDK/V213isYtnbynYU0Br/ImfkRCw6w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755125044; c=relaxed/simple;
	bh=g4PVcy4THMSh1E8B48Clp/2tRMdGRt6DESkdxMJ9tnw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l1IzF/QGE0CH0yMXCcCWAFLg0X1KRSgnBrdqqepk6ucA0dHGk0ngbMUO39cQqxmCQcutzgvZkOrqjAi0sus5aCtKOKZkO7jkeIMuxSBNyFURqNsGJ8PnOS29q6HoQhviWOSqDAUmAeC3EqJsUPtS59/vuOTLKzb4u+zO0fYJj9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N41joFjn; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755125043; x=1786661043;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=g4PVcy4THMSh1E8B48Clp/2tRMdGRt6DESkdxMJ9tnw=;
  b=N41joFjno5jxWTBgqaZEzI5RYwplxpk3/gB6/cow1QaeXQMvuMsRlGQ8
   Zcpk1n9JlGTCS10bJ7/5KEsVm8j6L63ZGAyIYB4In9ThNPu/6O3Jnm6jq
   4x/obCs5TFJ7+2PfICJptJImdN90ouWOTQCwqafH2e0vKEMOE9SRvQEoo
   AMkQcIhhmNpfIyO4ZWztVyhil9i154MEK2xyJ/sKAS0OV8ua0SI1vQ7Tz
   umpo0QGMTLHZrvGjktIse7vf14FpyZBb1hsGeqYRnJ2v/qNYbJBMl91wk
   PEOoxSTexIoROtJ49B7fplF6uup8ZLrpa0JSdT9KjsOUN9sXhSVztcYgg
   g==;
X-CSE-ConnectionGUID: PRBZeWMTQ4ihHrsPUHXsUg==
X-CSE-MsgGUID: qrYG6lXyTQaQoA4sXNgZlA==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="68813386"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="68813386"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 15:44:02 -0700
X-CSE-ConnectionGUID: zgzaTR7pQleFM59LKo5fpg==
X-CSE-MsgGUID: OWCdnYshTHC3vblNv+tBZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="190304804"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 15:44:02 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 Aug 2025 15:44:01 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 13 Aug 2025 15:44:01 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.68) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 13 Aug 2025 15:44:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sc1WfVat9/I7Vmr7h3Ts15E60W25BmycZh8air0b9xEoL/88FJYZXkFdQ30kcihdyJsZrDYoTyodCELK/bcPolh1dFITymnJswavOXfnJuIMq+bHyRnyCrAu6xc7wTFPe+UVeR2eGwJChhoqHJJvYUHZbwvkoVQUbcv+Q5ZrDVfFgHoj5fpyU1L1MNlsxFsDfOQLIfCmgXQz+brpU0h65jRESC8B31+pO4bg/O5z/j3VDl5FGjJdL4cw/zfK/0oNem3REIJ2q6LMONt5wjmxjOMPtF0vJjSUgaGqRKSGB21Lqzdt7USvkHdqP6lTI2G/QsjaN4fWwyzxRBmOE15EEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g4PVcy4THMSh1E8B48Clp/2tRMdGRt6DESkdxMJ9tnw=;
 b=Qe2zuiY9sKJAqBoyrLblz/uBOB+wX20XYjyORbZ/pi6h6TC2HYoUmuPPp0XTFMccsrPd39ktaYiZkWBYr/piglk/KuhbmNrhAtFqbkRJM/dnTXDCfnYQboBcYvyhSaNzoS6aSFoGsIZhbrhIVYb6WbMcSbDQzPySuP6jVz6z1ZKaLD4ePfvBzXKP8mk168SLgwLwDtxVSWEwEylEPxl7GwWgLfazvtv/YRB23BfFZE7pGEjp/B/cjJZrbL7VFUz3P3/YebQFVQLAaZQm7SCzruoBawFogq8e+k3ymXMqpd+H/HFTgIvTXm1WC0DPkL1yYGMTL6ubI4W4tPD22GkEsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MN2PR11MB4518.namprd11.prod.outlook.com (2603:10b6:208:24f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.14; Wed, 13 Aug
 2025 22:43:59 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9031.014; Wed, 13 Aug 2025
 22:43:59 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"kas@kernel.org" <kas@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Thread-Topic: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Thread-Index: AQHb2XKrCJQDYmgN9EmkL7mVJaZZf7RZwqaAgAOdgICAAQwrgIAAOwMAgALtSQA=
Date: Wed, 13 Aug 2025 22:43:59 +0000
Message-ID: <f38f55de6f4d454d0288eb7f04c8c621fb7b9508.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
	 <d432b8b7cfc413001c743805787990fe0860e780.camel@intel.com>
	 <sjhioktjzegjmyuaisde7ui7lsrhnolx6yjmikhhwlxxfba5bh@ss6igliiimas>
	 <c2a62badf190717a251d269a6905872b01e8e340.camel@intel.com>
	 <aJqgosNUjrCfH_WN@google.com>
In-Reply-To: <aJqgosNUjrCfH_WN@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MN2PR11MB4518:EE_
x-ms-office365-filtering-correlation-id: 1911043f-6d0a-44cc-4f09-08dddabae4cc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ckZpVW80bzk5RzNSMUE0dGo0UTlHRnRZNUw4QkJrdU03U2RsYU1Va2FLZkhq?=
 =?utf-8?B?UXRTZm1tZ2RiSGd2NlIzTDBmTll1dkN3TWMyMms3SGxxT0lscnRBdXN6dWlB?=
 =?utf-8?B?NjgzT3hSWS9ydG1QV3NGWmhhMlNRUkhHMVBwM1hsSnVSR2kvckF0Mk41Q3R3?=
 =?utf-8?B?R2xQYUp4NWd6ZVdZeGNlaTFaVmhKVzU5ZTdVTHAwOXNISHNycEtkemUxQTla?=
 =?utf-8?B?WGc4MU80VGdueFlpakRSNkFLcDQ0UUtPWllqTmxuNlRTbjZvcG9sUXNWTW01?=
 =?utf-8?B?SDE2OGhibEN6SWlZaWllQklzSzVoZWE4dnEwWEpvdnc0bWFjSmEyTjRZSkln?=
 =?utf-8?B?YTh2Tm9jTmRxVHd6cHljNWR4amhZTkZHOUJDdzdib2t1UVMxSkV3ZDN6MzJn?=
 =?utf-8?B?WWROYWNEdnZJYXBxWHo4QUFZYk9DMmZZanQ4OHpVTVdhdnFUNFFhVFlyUU9o?=
 =?utf-8?B?MWowUys0SXVRcGhDWXg2V2hLMFIyZVVya29aaUVIQmtJbmZhelh4ajM4QUNI?=
 =?utf-8?B?cVR1SUg1ODBNU2ZlVzg2dXh4Qkl4TW4zVkEzZUowOW1xOUkrSC9lTE1qNjlt?=
 =?utf-8?B?QVY4Wk0yOC9KVHpXbTAwOWNEalJpVXFRL1FHSzhCQzFPbzQ1Q2JUMm5mRkRy?=
 =?utf-8?B?RUpIM2RieFNnK0J0Rkp3SFJncE16V3pSVTcyNHo4NlIvSlZkaVRGN1FTaG5a?=
 =?utf-8?B?eFBLelBDZWt4ZVZGSHRSS2RqcTltN0tCdU5TMXAyN2VYemxZazE2V0VMTjVE?=
 =?utf-8?B?bkE2bGNrck14UmtMSWszTHl6MWpGTGlPU0plWmdtc1hJWktLUmF4czdpNTN1?=
 =?utf-8?B?b21SbTNJbElRL3JpdG9lenVsQ2tMcFEycVVQU0hSdXJuejBwSzM4V1F5OGdv?=
 =?utf-8?B?bDBSbkxnRytaUGVmVHNnL3EzdzVtK3c2enFaVVBHRGJ6V250TjVNQTFiOFpB?=
 =?utf-8?B?RkU2SXVoZy9uclU2a1YyZ013dlc1eTY0YWN6V3VBMlZkQ2Zpb3BORGtFVUdx?=
 =?utf-8?B?cGJpZ3NadzZTNkloWjNocS9paHE4QlVqVHMvTzRkTGY5STJXY29PeUVWVzg1?=
 =?utf-8?B?R3psWms5S01URTVZbFp1NzRON2VhdUhaTmZqMnlGRFRGZ1pKQy9WSzFyR2Mr?=
 =?utf-8?B?cWZGd2QyOXNGejcvRnUvb0pQR25MT0R3WmFiNUtLM3JYT0dXV05XMW0rbW8z?=
 =?utf-8?B?TDd4RElEWjErZVE0SWxyRzhVZHhNS2R0VDMrMTBwanVVSkpLSWEvVldXUTdt?=
 =?utf-8?B?ZzNvVm85ZTRjUW5od01KVkVqaGYrNE96cHJNejJvSHQzNGxzUlFSTnp4M3VV?=
 =?utf-8?B?RkdueDFnS0Myc0pvckFDODZoNGIrYk5oUlU1dnQ1alh1NmpyNHUwN2hrVS9m?=
 =?utf-8?B?RS9RM1Q0Q0x3L1pGOU1MamdHSnF0ajF0c3RsSE1CYzlsai9Kb1FoZ29HOVZP?=
 =?utf-8?B?bzBhanowN0h5NU1rWnhMV1MzVUMwb2RzN0FKQ3VQR1ZONi9pNGoyS2FaT0NU?=
 =?utf-8?B?eGN6dVlCa3kyZUVleXBTeVdYd1BCektGYTBTam9uVHhtbUhQUzBicTg3dnda?=
 =?utf-8?B?MUkyTTJwM3V1U1RqV01ld1BBQ1FHZTJXYW9qc25yMGQ1NHppOXBlTVc1MUxk?=
 =?utf-8?B?ZlhGZmVvQ2ZvNldnczd6YW4yQVVGemdRMW8zNjE4N2ZWc2pPZE0rNzV6MlV2?=
 =?utf-8?B?ckhuTjRLSVMyVmRndVFHVHBGSXlzWXFMd0hGempMbksra0pDcTE1RTF5Zkg0?=
 =?utf-8?B?bGhxVUJXZVcwZ2pjTmdkYXltU1A5aDJmS0M2RjN2amZHN1I4d0VYTG4ycVN4?=
 =?utf-8?B?Z2VCS1Y0K2gyaWZrZWQ2MklrdGxzMWd2eW12aVova3ZsUGJCWFFTL2Zpclhx?=
 =?utf-8?B?NHpBYStkOEUxZ3o0cXRBQXhSYkJYVW44bWRCUGJrenJrcTdKWTJTQVVSNnY5?=
 =?utf-8?B?UmhZMGc2T3FiRXp5V0V6amIrTW1hVzYvNHovQlZBaTY1SEpTSDh5bUVTUisw?=
 =?utf-8?B?dnZKUGJWUXJnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TDZYQ0FHMERNdGxJMkxGVWkzdFgyYS9EUkplUXpiU1lGSGhLWTNtQjRiZGpC?=
 =?utf-8?B?ODJBYXRtQ2xkdEdXTUovb0E4N055VnpJS24yVXo2a3hzb3RNcHBxclc1cTc4?=
 =?utf-8?B?elR4Z1JCdXFqR3N0SHYvSkk3blJ3azgwUGI2NThxVmFtVkRob0d6dkxSSXhr?=
 =?utf-8?B?aktQZVR0UEplRHNGbVRpeE5Md1VpaHMwSVN2dUE3SWIycFEwRDZlbXVkNVdL?=
 =?utf-8?B?YWYzNEl4UjgrMUF3K3duclBZSHZHQk01NS9DUm92QnZ0bDFnZ3hOS0YxSTVQ?=
 =?utf-8?B?UmZjME9SbVNVSHhLMGY0d0F2U1ZtYkR4TlZyM0N3dWtWaktXYXFkZ3hzR1JT?=
 =?utf-8?B?aU4xTlBBS1JTd0tHQzczSFlwY3Vidmo4a2Nhc0xMQk9OTUxxODVGRS9EODA0?=
 =?utf-8?B?aWhEaGJTTEhqbXhrT3ZKd0hEeWM1bVpBV20wZVMzWTJMUzg3QmROSUV1c08y?=
 =?utf-8?B?UXRLY0RJWko4N2liK3Zvb3lmaHlua1p4YVhqY0ZDVkgzVTRVSGJtNTBwSHVU?=
 =?utf-8?B?aDZRWHB0bHhlK1I1bW1UaGE5dmdTcGJITEEwUkVnalp3amY5VThDNzhMQksz?=
 =?utf-8?B?QTc2c2FOazAvQXZMcFF1clRKL0tTakxPamZKd2V4Qy9uRnc1MGQvQzV1ZVBD?=
 =?utf-8?B?TmFEYW8xWDZpN0V0Uy9ZYVc4dmhLSGZRUkt0ZE81MGZHK2lhQzF2VWVEdmRr?=
 =?utf-8?B?akJpZWVReTcrRkZHbGlyWW9Ma1VobWdnSXo0OU1yQU5qOG5abzFUcHNxeGdG?=
 =?utf-8?B?SDVZazI0UXI1Wkg0VFQ0QUJsQmhQT0pacmZTSCtLSFgyeGhkLzc4MXVmRTVK?=
 =?utf-8?B?TEUzR3dLbFhoWWg5Yks5V0JDM0lma0RzVDk4YTg1NWhGMElrcTVCU1hzZXl1?=
 =?utf-8?B?RzZUSWh4dk9vRWNWVU5QQjhCSWJFUkNCa1Z2VUNtdmNKaFhDZ3Jqb0NMOU02?=
 =?utf-8?B?NVRYZkpXSjhkYXEwbGIyQVJqVm9HNmhXK1lQOUYrZlhLOXpqRUFYQS83SlR3?=
 =?utf-8?B?RXFaazNnNk5ZTGlXc3VaZkZjdmhhVmlpek9rRkZBM0VDbG5DNXp0c0NoRVox?=
 =?utf-8?B?TVlCb1NBY0F1WmRESWpLQXFKaVNEY0d6Z2poUHlEbndzZTNIU0RWUGhWZ1B6?=
 =?utf-8?B?M3VYcDdVK21zOFVVRHNSaUdXV3dsMmNyYTBDdy9ZUmZJQ2hNRTNsQ0VlaFBy?=
 =?utf-8?B?bytTZmlHV044Rk1jV0F4Nm05b3JBbzZITVBubzBML002SWxBY29WbGZyekhS?=
 =?utf-8?B?NE5MZzFvdFdQZ2xJSVFTaWtSWGJMRFJuRlVVKzh1R29OYmFvTllRYVIxcVV3?=
 =?utf-8?B?aWlQWUhyNHlTdXRQU2lnVnFLNm1peThsYXpWL2pETjlwNVhzOWdiUHhSbzZO?=
 =?utf-8?B?ZU5uTk5Fclp0REtPRVlZa2wxV0R3cHB4Y2xadW5Xank3L3NOcVJSNjZLdlZB?=
 =?utf-8?B?QiswbDBhQm5QNFc5bmdhbzJzM2h1SWpHUm5nRVFDZGpPUnVlQTQwYjZWU1RM?=
 =?utf-8?B?SFpIYUs2Y2VQR2NoRFRpcklsQ25kZ20xNmV2OEJUZEtVSE1CWER6MmlwQURP?=
 =?utf-8?B?RWoxL3dKZklpdjZmMm56SksvNjFYN2FWOHZmbElBRVUwZUt1RlRqYkVxN05W?=
 =?utf-8?B?RnhORFpMeEkvOVhzYUExT0EwTGpMRENKVE90bkgvcEh0RXZCVnVNRHpSbmZM?=
 =?utf-8?B?NW8yMm5GdThLTnFNUE9hdWpFdGtrNWl6NDVWc0RPT2t0NFIrZWtTTkZSNEF0?=
 =?utf-8?B?WU1QQTJFdWJNdktmdUFkQ0I4dFV2SU1BM3BZR2ZvQXE1UHJzUFFHKzc5aWVu?=
 =?utf-8?B?TTJBaEJZUW9wKzB0YXB4byszMk9kOHFkN0VtZ1BaSXNEWStrejZSamJ6WTZv?=
 =?utf-8?B?dG1RQ2szNldJSDNtUHhETHpOT1IrcFllZHJYcFZWNktCdEhsNVVVRXdPazhk?=
 =?utf-8?B?clRPZ3NvWlpsWGh2VXhqRjZLTGhWSVpFWk9ZdzR2Y25KNnVmKzR5THVlUXdp?=
 =?utf-8?B?V1dicmhVWThNcjRkQkJNVmIxWi90SHJDelhoMVNFanJHNGtiRUYzS3FUbDJs?=
 =?utf-8?B?TC9TMG51ZUVnVjlsL0YwZWFkZUVGejJjaVU5cDJqRks0bzZQUElLMmdZMWFN?=
 =?utf-8?B?dkV1bjFBWmd5L0R0Y3dITXRXS2c2ekR2WDkzT05BM2lFbjJqSlp6K0FYN0Qy?=
 =?utf-8?B?Rmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CBB3B00BEAB7834299E9307A0E31C125@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1911043f-6d0a-44cc-4f09-08dddabae4cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2025 22:43:59.3304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V7V9xmoc8exuLRWfQn0iTfnPfxxrA1KjZhUJIKO4Mn8mTQMcAtbQtLEf92Nv+hPBRhi0M6lXWOdx3HKYypcXGQrgy6ylnUqgEg9fe9kdVwc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4518
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA4LTExIGF0IDE5OjAyIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEkganVzdCBkaWQgYSB0ZXN0IG9mIHNpbXVsdGFuZW91c2x5IHN0YXJ0aW5nIDEw
IFZNcyB3aXRoIDE2R0Igb2YgcmFtIChub24NCj4gPiBodWdlDQo+IA0KPiBIb3cgbWFueSB2Q1BV
cz/CoCBBbmQgd2VyZSB0aGUgVk1zIGFjdHVhbGx5IGFjY2VwdGluZy9mYXVsdGluZyBhbGwgMTZH
aUI/DQoNCjQgdkNQVXMuDQoNCkkgcmVkaWQgdGhlIHRlc3QuIEJvb3QgMTAgVERzIHdpdGggMTZH
QiBvZiByYW0sIHJ1biB1c2Vyc3BhY2UgdG8gZmF1bHQgaW4gbWVtb3J5DQpmcm9tIDQgdGhyZWFk
cyB1bnRpbCBPT00sIHRoZW4gc2h1dGRvd24uIFREcyB3ZXJlIHNwbGl0IGJldHdlZW4gdHdvIHNv
Y2tldHMuIEl0DQplbmRlZCB1cCB3aXRoIDExMzYgY29udGVudGlvbnMgb2YgdGhlIGdsb2JhbCBs
b2NrLCA0bXMgd2FpdGluZy4NCg0KSXQgc3RpbGwgZmVlbHMgdmVyeSB3cm9uZywgYnV0IGFsc28g
bm90IHNvbWV0aGluZyB0aGF0IGlzIGEgdmVyeSBtZWFzdXJhYmxlIGluDQp0aGUgcmVhbCB3b3Js
ZC4gTGlrZSBLaXJpbGwgd2FzIHNheWluZywgdGhlIGdsb2JhbCBsb2NrIGlzIG5vdCBoZWxkIHZl
cnkgbG9uZy4NCkknbSBub3Qgc3VyZSBpZiB0aGlzIG1heSBzdGlsbCBoaXQgc2NhbGFiaWxpdHkg
aXNzdWVzIGZyb20gY2FjaGVsaW5lIGJvdW5jaW5nIG9uDQpiaWdnZXIgbXVsdGlzb2NrZXQgc3lz
dGVtcy4gQnV0IHdlIGRvIGhhdmUgYSBwYXRoIGZvcndhcmRzIGlmIHdlIGhpdCB0aGlzLg0KRGVw
ZW5kaW5nIG9uIHRoZSBzY2FsZSBvZiB0aGUgcHJvYmxlbSB0aGF0IGNvbWVzIHVwIHdlIGNvdWxk
IGRlY2lkZSB3aGV0aGVyIHRvDQpkbyB0aGUgbG9jayBwZXItMk1CIHJlZ2lvbiB3aXRoIG1vcmUg
bWVtb3J5IHVzYWdlLCBvciBhIGhhc2hlZCB0YWJsZSBvZiBOIGxvY2tzDQpsaWtlIERhdmUgc3Vn
Z2VzdGVkLg0KDQpTbyBJJ2xsIHBsYW4gdG8ga2VlcCB0aGUgZXhpc3Rpbmcgc2luZ2xlIGxvY2sg
Zm9yIG5vdyB1bmxlc3MgYW55b25lIGhhcyBhbnkNCnN0cm9uZyBvYmplY3Rpb25zLg0KDQo+IA0K
PiBUaGVyZSdzIGFsc28gYSBub2lzeSBuZWlnaGJvciBwcm9ibGVtIGx1cmtpbmcuwqAgRS5nLiBt
YWxpY2lvdXMvYnVnZ3kgVk0gc3BhbXMNCj4gcHJpdmF0ZTw9PnNoYXJlZCBjb252ZXJzaW9ucyBh
bmQgdGh1cyBpbnRlcmZlcmVzIHdpdGggUEFNVCBhbGxvY2F0aW9ucyBmb3INCj4gb3RoZXINCj4g
Vk1zLg0KDQpIbW0sIGFzIGxvbmcgYXMgaXQgZG9lc24ndCBibG9jayBpdCBjb21wbGV0ZWx5LCBp
dCBzZWVtcyBvaz8NCg==

