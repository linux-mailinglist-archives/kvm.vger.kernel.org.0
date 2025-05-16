Return-Path: <kvm+bounces-46841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C4B56ABA1E2
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 19:34:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74A2B1C001A4
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 17:34:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A68C0221F0D;
	Fri, 16 May 2025 17:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G5gUv1DW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B23635;
	Fri, 16 May 2025 17:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747416853; cv=fail; b=swiboVl8428gg4u+mfovKBwbDCZJL3mAT6u/cYPQUufjR704nBVm8/4RKtNmBbrQScwNTTF7trHkRR6ydvLsrVu3ags369j+KAh1dGOLxNcmvjFk1d4ise5TPxzJiQvOfhKX6F/AnpdTN/6H7e6hndXLAlsomau+f3TPVgyBKnE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747416853; c=relaxed/simple;
	bh=58D5IgrGflxYTFqMGwb+qssDw+j8hLe+VzphzMc5Erg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=riok5hK/Vxhj1kgt9TEgx5AWb9my3xy5ecF4W04sdGXRQ06+xUaHLpdvaUbJEhhgTgS5NOdg1+F48REFANrUGLjyF9ZbsIHhrbz4xiwZgkseeCejENcBNO8W+lnh0lprWTzh3ei6wE2L2XvXNEyhKu93LXOsT2/dbBMWZ16E0Ss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G5gUv1DW; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747416852; x=1778952852;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=58D5IgrGflxYTFqMGwb+qssDw+j8hLe+VzphzMc5Erg=;
  b=G5gUv1DWQNMekQeKT10axE6LXLXk8wKTbfQ7o9CFaG0V3OPCUyajURHh
   svEnpWf9p/65e5oyNlvgd+MA84tYcUAuMcu1+QoAf647+u3+8djBKABjE
   pqrQVzKMwbeiInP5jevXNVjAe2+0MOIliluSwswqtBxVcjN2+4/4R5XZe
   +SX3WEXlOlgcOqibLzYXycOU78dTpiaVoYG0peadyXir+VwNbJX8+3xZ7
   6eCE5mbPDR2Mc1MdUBmTWBN+urgEgQDdo0MwsWkXwlineM0HTW0ipXPrt
   ldX922xu9X77i9zeYgQUslgNBkABOjItesEtyAFIpfpJHtxcaEtKXmFYa
   w==;
X-CSE-ConnectionGUID: Z0z2bSIgQAW3Rty11bTKdA==
X-CSE-MsgGUID: fIGgru4FSxeAo0/t/oUIYg==
X-IronPort-AV: E=McAfee;i="6700,10204,11435"; a="53068362"
X-IronPort-AV: E=Sophos;i="6.15,294,1739865600"; 
   d="scan'208";a="53068362"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 10:34:12 -0700
X-CSE-ConnectionGUID: 1WxCXDDbTQSK+pHoY6s2Yw==
X-CSE-MsgGUID: s4IZLy7mTnan2qKH6Rn9AA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,294,1739865600"; 
   d="scan'208";a="138662996"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 10:34:11 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 16 May 2025 10:34:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 16 May 2025 10:34:10 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 16 May 2025 10:34:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KSBxiEJfK9Oa5faIRP2Cff4sfafdj7hRpgf9UEVH0Dgeu3FMPGyuLXVqjB8Entn358KqRdjXqnHw7BRsaJ+q0h2eJox9kiZfBnP4/JwWssiawQhyYrIfu7RmLA4vLB/RsPsWcLZ9AyNfv4eE09aT96eLXzDdVOh1D7bQdu3+5UYCfHz0g4ag6DYVdEbbtNxbtcndzTbuqgqzHIWXfWa/GsB2EnCGKSVC1Trqw/Tdro+DRLMQ16mJZlQYoZes17tQivXm0oOoj61jfdO3Y8HHLr42YtJ+zh/Bb5zOVJNZ+iH9yV5V1sicsE0gS5SYwn39S2cUmopBAaRXi/n2CzMTAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=58D5IgrGflxYTFqMGwb+qssDw+j8hLe+VzphzMc5Erg=;
 b=K53xen39uqscy3j+BKR8DbiveD1rGR3umXQHVSYWl8H/wZsFaCNZhBRUSlYkTIcDr/fSMstmezsWdLNTgmyELa3KptsrTFKitfbOSWoHIKhJ2gsXsX8XXSgyG+Xdn8LKSpv7k1tTOo1acElnklLY2Yn+VNbovcyMZ9G3ZEuNKf7ixiBv+Nodd5wFWLIMVFw7xPs6Cvt9jtJdlKAqbrQ4JGfZ0MoqhdNQOvCRRt0xlh+FgetMcQEeyoCJeELCpxf0WjR5q22BjBTmTH8OtzS5xkmJYw2Qyvdl8/P13eJQ7cMfAE5kzHzOA/tRX/71+ICOXPosr961iNArZZTsXUW7vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB6568.namprd11.prod.outlook.com (2603:10b6:806:253::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Fri, 16 May
 2025 17:34:04 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Fri, 16 May 2025
 17:34:04 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 06/21] KVM: TDX: Assert the reclaimed pages were
 mapped as expected
Thread-Topic: [RFC PATCH 06/21] KVM: TDX: Assert the reclaimed pages were
 mapped as expected
Thread-Index: AQHbtMYHct23az52zU++ddPeLvRl9LPREAUAgAOWGQCAAQHEgA==
Date: Fri, 16 May 2025 17:34:04 +0000
Message-ID: <c1ff041b87fa44f1f1d93e73ccfbdb5407edddaf.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030532.32756-1-yan.y.zhao@intel.com>
	 <846bfd9ba7a3a2c6feb2d74b07c8cb1b42dcd323.camel@intel.com>
	 <aCae0HX3URjeHwOh@yzhao56-desk.sh.intel.com>
In-Reply-To: <aCae0HX3URjeHwOh@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB6568:EE_
x-ms-office365-filtering-correlation-id: 5a3f8120-0cea-4c6f-d482-08dd949fdabe
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?OGhQU1FjVkdmTTNiMnVhRWRYTEU3RmUxR1NGWHhESm1aVGlIVG1BRTZ6RVBa?=
 =?utf-8?B?L1FQQlZYTHgzVm1UQlkvZDYvMkQ0TTlOOWN4dFdSdXlod2c5Y1ZpWUN5enhv?=
 =?utf-8?B?ZzRPaGV6MnpyY2RTcTBUK0RDaE1URUJXWkxkV0F3aks0UU1zY3p5NklGWkJx?=
 =?utf-8?B?a21kZWl2ZVlaQ0FNTEI0VzAzVjU2MFlqMXdZajdoQVhSblI2VmE5dk53b21a?=
 =?utf-8?B?cDNYNTJtZzVRWWN6bmVpTTNSditNNWVYVmlHeFBkVDVOYjh6RDVsejJNS3lN?=
 =?utf-8?B?UCszQ1hMZUVMQXJtUmh0aUExRTlFaGpla0hueU9icUQ5UHZFTDZhREtGazJj?=
 =?utf-8?B?a0RybnJQSElEcS8rUXY1bnNLeXI2bUN1RnIzbEs0bUt4VkJ3SmJHOVJ3NlJD?=
 =?utf-8?B?TmczUkswQk5EMVJLQjBKVnVwd0k4eXdjWTdmTzJ0YlBIblRFWkFnZk8xWkpM?=
 =?utf-8?B?QktZdmtnUVB2b3RWRm5UT1dzNmFiMDJMbCtBTTZzU2hoU2hKS0x4OE5VS3po?=
 =?utf-8?B?NDd1WEtCTG9SOXNvckhlbGJHNVJSV3MzaWNMbW53cTZRWE1iZGlqSmZkeXVn?=
 =?utf-8?B?TXBTRXIwOHJWeC80TEhSbXI1T1p2N29yYzVLTFRiQXpxZStjdVN1YmxMcWYv?=
 =?utf-8?B?bzBGcjFPQ05DNmphZkdZbFAwbHNUSFVMVGk0WDh4UzFjREVhbzNIMzM0TE91?=
 =?utf-8?B?enhiVW80UWNUWTJNZzRCcUEzd2pYZmovNUJCWmV2MmtOZklZYWFVeURHYUN5?=
 =?utf-8?B?ZFNrUEdUNnJ0d0hTQTFzVUVjdmJuOWVJTzlyZXc1UWlFQm94eWhnanV5bUty?=
 =?utf-8?B?R09MbGhyT0VLUFFtOFdSY3NhZjFpc3lDUXZnSC9kSUdzMEpiREp0Z0lYaVdZ?=
 =?utf-8?B?NngvR2RMWmhhQ3k3US8zZy9XVkhFZkdIVWJDNXo5SFFOSHhkbFdPSFdlVmkr?=
 =?utf-8?B?LzlGUWVwK09FRzBTd2JnaTZDUzlEVzJpRllkM29FZEFGdWp1QURWNFE4dThF?=
 =?utf-8?B?TFhyeGIvQitUOURjVWxYUUlEay9PY0w2UFZISXhMVXFrMU93VlZmemo1Tm9m?=
 =?utf-8?B?SWVXNzNzeDRQUW9weGdNMklxMktZY1QrQS9LUzZ2K2dIdHZLYllJczkvN29z?=
 =?utf-8?B?N3BLMVFrL3BnTUljN21yZ0JVTUUzVUJrQXZnSmVhRE1ITjV5Z3BGUWdxRWNv?=
 =?utf-8?B?YUhudnUrQmlqQ0xBbFNBSFVZeUlCU2U5UjM1QTF1VVFYT2NuckROcWw1VEpW?=
 =?utf-8?B?aGgrRWk3SFl3ZE9jNnkvSXRzN0hXSUtVankzTDZlS2s3M3UzVlF2TjJPUTRB?=
 =?utf-8?B?KzRMaTNCNmhMck9kR3ppcWZXdWtIUjhqRlM0alplMFU0OWY3c0JNVGtzU3BT?=
 =?utf-8?B?WGkyWVM3QXdiRFdJd2hxUE82Ri91L25UNS9kV0V5SUwwbitUVFpzR3ltZ0d3?=
 =?utf-8?B?SHBaVnloRitxWk1rM3VaT0ZWMDkvLzBHYUxURXA4M2RjbVdjMVJGOTl5NmMw?=
 =?utf-8?B?cStDcEs4OU1pUG55VUE3RC9lUUp0WWNLVXJUbGd1cFAvbzJhM25ZSUZCU29z?=
 =?utf-8?B?UXg0TllLOWNPakpMUVR5WVJ1azViUGZieE1xVGlWNE5udEtwbmtDVmdyeU94?=
 =?utf-8?B?WXE2T0hYK3kyR1FhYUhzQURBQ0R4Tm9GZllXdVhJK0VBc2Vpb0wxNmdSWWpa?=
 =?utf-8?B?UXlmTnlrVytWdXk5ckNEWlJYelFZdlppRTZrWnNxL1Z1MEdJL1lEVXc5eHli?=
 =?utf-8?B?M1kyVWh4OU5VL2x5TFhEZkhNc0sxMWIxOWk2WW41ZTE2K0VvWE9KOEs4ZnNp?=
 =?utf-8?B?YWx5MGdQcXhJa0JqQ1N2L0FIWjR4aGJNa2pVUmZXcG4yTkNVRnFnYnpqemlG?=
 =?utf-8?B?TXVzeTFNM0JLZ1ZOLzFML001U0lPYjFYT21pVWhMVUthVWRmQUFXUElPd2RP?=
 =?utf-8?B?VVIvM01kcCtwS2dBUHVEZnV6T3J4eE85ckJCSUYyS3c2eGRkeWZqNSt0eFl0?=
 =?utf-8?Q?rcCHqDxsL+NK3QQC8a37XN6rzkWcCQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZHB4SkNNWjVwWXZvams3cUt6UTVCK2RLcjZodzJ2UmR6Rm9ydHJhdXcvMm91?=
 =?utf-8?B?eklrZU5NNktoVGxoVWtkREVPZ2R2dUtsVWNRUzZ3aFMyREFNNjZUNlJ1d1c1?=
 =?utf-8?B?bUJGSmRTbWQreFFCd2FIWTRVdFJxdmNWdzd0Nm0yb0g3N1pGYW1UdGs5Rkp6?=
 =?utf-8?B?R0t0NUhmSVRpZmE0ZmUraTlKcWxqaXJSQlVha1hzNjFUam5CUnR0dGkvQm9v?=
 =?utf-8?B?STFoQUFjaEJSVDhYYm1hcVNkMnQ4a3ZrUkdxeHBhM0JHRFZFZHBUWnlNYTJR?=
 =?utf-8?B?SGRwWlhKRDZBZjNkY1BSYjFoYXZvdFVLdmlmRzFpTjVRanYwRTAxOHh4QUtr?=
 =?utf-8?B?Q2piY1RmOW1lVGpzY2JRWEdsVWdONEw2ZXBKQnNUc1g2THdKOVRqa2ZkTDFq?=
 =?utf-8?B?aTVQWnNrTkc4WjIyV0dUK1VFeUQxNFFtUlBxc0N4OUhNWitYelJISGU0YjNn?=
 =?utf-8?B?d0Z0WE8zVzlrY25JZ0VVODY3V3l1ck52OWpkYXVnc3V5MzErVmxINmRWQ2hK?=
 =?utf-8?B?WHhrSGhJS2NtLzFCTUJnUUtwUnFwTVBZbWxvTjNZWUtmc3FucXRpdHhwa2pX?=
 =?utf-8?B?TDlod3ZaUFI4eUFBN1Y4V2hCbkk4MVBSS3duNk1JR0UvZmE1aDFtT0lGUEg1?=
 =?utf-8?B?NDBJZVBZVFR6dTA4NXhxaGZPZkhpbHpYQy9HT1J3TXExT0QramFXVndzUXRM?=
 =?utf-8?B?OW1OZWIxWVJsT0Q2bCsvTVRRMVJCTDVidFpmUnJPSW52OUE2a1d6WmdkVk1U?=
 =?utf-8?B?UFg1d28wOEtSTnl2MWxzSEkwVFJNNEdoRGFJdUNJR0JBUDVtVThZU2hpVENa?=
 =?utf-8?B?QUNCUEV1Tk1QQ0Q3eXNXdEFFUFZqZ25WekJQNk05MzRBbXF5dGkyRmYwQlZh?=
 =?utf-8?B?Y2JhUG5sU0YwbjRnWkJ4SndSLzE3UXl1NVhPNy8xak52U1U3WTFDdk9nZFBl?=
 =?utf-8?B?VWtKT054eU1RMW1GY1BQY3orSGtjUzVZWGk3SGtWeVJtdnJYZ1VZUlhSeFpI?=
 =?utf-8?B?WWRxd0NiZTZ2YnNPVnhKdFlDQzBPYndJOHVpZHgzVjA4NTJzZVRDQXJoTmtJ?=
 =?utf-8?B?VXhSQy9KSW1PT081THozNUlKMHBtVXIxYnVRRHVHeFVGZ2ZTVjBqVE1zdVEz?=
 =?utf-8?B?MFEyaDVXb3ducE02cGc2TEtlWkNnT21pcXBrY0xmNVgyMWNKOFNweWhMS0du?=
 =?utf-8?B?eTdCZGNaTVdOWXlCM2FPMmxSUWYwZ0tyZVFuQXlCNzdGejRFNFlORGRYSkZn?=
 =?utf-8?B?aFRhVDdFUUZKUnY0djJjSmhycTBvdVdjNFBTeXlyS2FzeXpqdGRLY00yV1RK?=
 =?utf-8?B?d1ZQSzdySm8rQmw4emZjUmlwblZqdDZYU3g1Z3dTMUMwVXlKMkZFcGkwZDZE?=
 =?utf-8?B?MkpaZEdrazNGVURURGtrYUNIMlQzWUE2YlMrREM5Um02REdldGFUL051QUlY?=
 =?utf-8?B?NDd0M2RxZll1TEZneHUwalI0Nzl1dVFQSXZvcFFudmRlZm92QXZhUEZVSWhx?=
 =?utf-8?B?YWpDQW8zcVVpbXpuVDd1ZWlMaUd5dEQ4NkZGWGRObVRsOEtwL1FFN1FRLzRv?=
 =?utf-8?B?dDh3dmFsTDkwTEJEYlpSbVZhcFAzN0FWeHNUTCtIeXRITXpWRmlYNEh5Nys5?=
 =?utf-8?B?dWJ0dzZVaHo3a2ZXbVBxYW9TSWkxajhtQnM5RkJ0b3dIUFp4VUxqVCtVanhj?=
 =?utf-8?B?NEhrNXNTYVNLYjRaOERuNEJFQkNXM0UxeXM4cytkc2xnajdkaVhjakpVNExm?=
 =?utf-8?B?QlgvQ3N5a0VmNFBKRVdmVFp4cWNPd09Za0xNcjdwSy9YZm1qMUJlK3pqdTQ4?=
 =?utf-8?B?cDRBUS8vYkc3WnhuOG1lT2ViYklXSmt6eldGT0REZ21URlRXTmgxRkxZcXVm?=
 =?utf-8?B?MUhqWEErVEI1MnliYzh5TGF0WUdmdU9zUEU0dlJudTBJb3J3Z1h1eXVzUGh2?=
 =?utf-8?B?RjBwMzNsaHRNMmU0Q1hobnpFdkQ2MTF4REkvak9Yd0pRVllnR3h3UTJZc3FK?=
 =?utf-8?B?dmhtZmIrUHBmQ2RScTZld0lSbjZCbU52WHU5Q3ZvU251dm5rcHJGc2ZEOHp6?=
 =?utf-8?B?TStvZU14MjRYa0xnUENXSXc1Sk5qTUY5RmhXQ3c5ZzJtMFZHYWdxUXVOY2Zj?=
 =?utf-8?B?SWJkVVBnWEpKbkZsNFJxMGM4UW5lVmR6MnFrS2gyQ1hPM2MyY2szSVdWOGpk?=
 =?utf-8?B?R0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4C9A9347559F9847B2C6144E1BEFF032@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a3f8120-0cea-4c6f-d482-08dd949fdabe
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2025 17:34:04.6929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oZ+Vt6N0dHF4GC1++NNFu59SxK6ToenWSbB6OE/X3xozuF3qGhHk8SLM58jB3bZzYmlFVx7xahsUR6E0u0H4kOG0IkOYeV6XPXOzOO4nr3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6568
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA1LTE2IGF0IDEwOjExICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBO
byBjYWxsZXJzIGluIHRoZSBzZXJpZXMgcGFzcyBhbnl0aGluZyBvdGhlciB0aGFuIFBHX0xFVkVM
XzRLLCBzbyBkbyB3ZSBuZWVkDQo+ID4gdGhpcyBwYXRjaD8NCj4gT2gsIHRoaXMgcGF0Y2ggaXMg
b25seSBmb3IgZnV0dXJlIFZNIHNodXRkb3duIG9wdGltaXphdGlvbiB3aGVyZSBodWdlIGd1ZXN0
DQo+IHBhZ2VzIGNvdWxkIGJlIHJlY2xhaW1lZC4NCj4gV2UgY2FuIG9mIGNvdXNlIGluY2x1ZGUg
aXQgaW4gdGhlIFZNIHNodXRkb3duIG9wdGltaXphdGlvbiBzZXJpZXMgaWYgeW91IHRoaW5rDQo+
IGl0J3MgYmV0dGVyLg0KDQpJIHRoaW5rIGl0J3MgYmV0dGVyLg0K

