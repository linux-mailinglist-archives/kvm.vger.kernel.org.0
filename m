Return-Path: <kvm+bounces-29192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B31689A4B4E
	for <lists+kvm@lfdr.de>; Sat, 19 Oct 2024 07:31:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A0261F22EF4
	for <lists+kvm@lfdr.de>; Sat, 19 Oct 2024 05:31:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABC2D1D3588;
	Sat, 19 Oct 2024 05:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Uq5T1Q1K"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A12D1EA73;
	Sat, 19 Oct 2024 05:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729315859; cv=fail; b=EW4WakZEfh080Hub3ui4WVsuQBOx6h6aHyeB5A+uI1q1B4KDnfFAjsc2XI4InyAf6IE//9MiVYAMoQghVpXFlXO6NNud6cq/IxvcrXc9/HmGwuufYwQLWcgJSlXPTplY12gO+oaYN7Z/sNkf0frxj0J8L7fV6HhLwZhyQwcdbyE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729315859; c=relaxed/simple;
	bh=BVxNftaILmkglJ/VFKz4fckxm9AupFY3WLEM7dDMui8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UAYDbMyco51v6AmtiErEdGuzdCmk2UwmW80Q3DC/v47YvdwmSmyFDCf6bHTXpu7WgrgcG2p0r0Dj9GHfE6fg6fabmpUvmkdkYIp2DMb51V2kljocX3n1aa+uWss5bg5NEXPlA3ppDHxcdprgGIRCim/n2UJ7ncUi5uU30Bugwig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Uq5T1Q1K; arc=fail smtp.client-ip=40.107.92.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tYg6S8r0XG5ee77kdRbjwoqkwjM3vcZFvt7gyApZEPX1QMBZd4sYZyBE9Fq3Y3kXmBRpcFyFhLXhxhuGXU0fM5ja5SNLLUyJ0NRGLdw8OyXIkSpK/5U4fOgock4BWJMWLlNIlFFj8ebX+H9Xk+vHsF1ISWmS4HmOhDj9KhFSGoRodjrT2fT7YrKeFnUaqSvld24DTjIQyhHgVVg+v/7h0UvFCkgnN8HqQOo6iMolYKoXt99LsTiQjRvzDszQfjwX7mPvrkmH4akfIafz7b0wa+k9gM/SWfo2VYz9w1VauazwVBHmyEiZkpZtbpLAfWzwx2jZCNPWfqcUEC9VmnG9Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BVxNftaILmkglJ/VFKz4fckxm9AupFY3WLEM7dDMui8=;
 b=MTZyGHwZ8KBM9SdwuiiHQJgpZweVrsNGxOZd0phrroFsezjr54qxhNykSo8mxnZZtlHXLhjp4ZmVTiurYR12P1BiNvFIL06W6QemwEu3KGwjMk05LdweN9Mj5TXgl/87A+dQ2/ttJO1PVvBxy7gbdnNkqUYFPY9fhT0v7vrYebdwTIP/4TFmbvttNy0v2DPXye+RLXWfSK7VpB5jxJx/oRyia29Q+QLOcnxcJRT9PmGvhbmHwbnzNugnfeKRiJWYU6HFMonQs12EWLwXMCw4bw9GDoGNrrNw55AtSv6E8xB7hHqHR+KF2VOr0mkgGmndJYrh/PykJVKVoLnlMUQsCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BVxNftaILmkglJ/VFKz4fckxm9AupFY3WLEM7dDMui8=;
 b=Uq5T1Q1KpiNU5ir2fKDoSduB5gtYoi3Cl7ZGOLeRndIvxxQkg3J0M4pyzfsLMUkhccwIabUM0Kn49ks8ANXYbyHjnQRE8j52QJbvlTTjVZZlgU/jX9gySCIz3To4etKtuuy/25uY7uOUJ3fe7IkcIKB7gzjtRJUEVtFDbMj46OXZo4jXrgheHV7fz0SFkCNgMxfQ0oGZoMRFfatg2Z0pOvfSJT1Xg3nSBPJb57lZNXmrofrAkFGi/NSNlqbqbwc6wc9yNPUQFiWOUrOLF+4KtXgWOQzJ9qhSH1qmTWWC/QLy8eJ/4gTQDfSf/xmZhrNyIO4VNzXRlT/UWwjyXFPDtg==
Received: from SA1PR12MB6870.namprd12.prod.outlook.com (2603:10b6:806:25e::22)
 by PH7PR12MB7282.namprd12.prod.outlook.com (2603:10b6:510:209::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18; Sat, 19 Oct
 2024 05:30:53 +0000
Received: from SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::8e11:7d4b:f9ae:911a]) by SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::8e11:7d4b:f9ae:911a%4]) with mapi id 15.20.8048.017; Sat, 19 Oct 2024
 05:30:53 +0000
From: Zhi Wang <zhiw@nvidia.com>
To: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
CC: "Tian, Kevin" <kevin.tian@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>, "Schofield,
 Alison" <alison.schofield@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>,
	"dave@stgolabs.net" <dave@stgolabs.net>, "Weiny, Ira" <ira.weiny@intel.com>,
	"Verma, Vishal L" <vishal.l.verma@intel.com>, "alucerop@amd.com"
	<alucerop@amd.com>, Andy Currid <ACurrid@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Surath Mitra <smitra@nvidia.com>, Ankit Agrawal
	<ankita@nvidia.com>, Aniket Agashe <aniketa@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	"zhiwang@kernel.org" <zhiwang@kernel.org>
Subject: Re: [RFC 00/13] vfio: introduce vfio-cxl to support CXL type-2
 accelerator passthrough
Thread-Topic: [RFC 00/13] vfio: introduce vfio-cxl to support CXL type-2
 accelerator passthrough
Thread-Index:
 AQHbC61b9ki2ojKvx0ySv/3ut0ogdLJlBfmAgAGapQCAAd8ngIACw8mAgAtJcICAFyvIgA==
Date: Sat, 19 Oct 2024 05:30:52 +0000
Message-ID: <aed9bc24-415c-4180-ad5b-192a7232d10d@nvidia.com>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
 <BN9PR11MB5276B821A9732BF0A9EC67988C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <75c0c6f1-07e4-43c1-819c-2182bdd0b47c@nvidia.com>
 <20240925140515.000077f5@Huawei.com>
 <5ad34682-5fa9-44ee-b36b-b17317256187@nvidia.com>
 <20241004124013.00004bca@Huawei.com>
In-Reply-To: <20241004124013.00004bca@Huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6870:EE_|PH7PR12MB7282:EE_
x-ms-office365-filtering-correlation-id: e3d1b4f3-a777-49b2-fd04-08dcefff32ea
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?eEh5OStjYWxJYVgvbEVFUG5nLytHY0ZxRkg1Y1BWVkhLa1c4NmpqNzByOFMz?=
 =?utf-8?B?TXJUSXVFVDVqVUNyK2p6emNRaFUvbU5UVTBSQm9pVVUzL2dRNndpbWtPaWhD?=
 =?utf-8?B?NVNnWnVacDB6UzQ0Z2NENWZqeGVaWUFjVXVQM2E3dVFMUTBXVDEySlhDZ2ho?=
 =?utf-8?B?VFFneVNnRS9tUktweWhKdGNZM0tnMEIyOHFnc1JuU0tyTWpqSkd2d1NCc09z?=
 =?utf-8?B?OERoRklqSUhWZS9xUFZ3NUI5UEtRTUloWkYvcERjS2RsSlZWLzJGTmV1Mm05?=
 =?utf-8?B?ZndpWE83TjBkTHc0bXdMaCt0TFUwWHFjeE9yazdlUDF2YS9KeUNoUHhlaHZ5?=
 =?utf-8?B?S1pVZHkvK3BPNGlBYmJmMzJSWnUwMGgxL3lPa1Z3V0dQSmYrbEpUZDJ6L2ZX?=
 =?utf-8?B?Sm5FOVlnYTRrc2ZJMkV0MVV1Q1dTa0xxWG1na0V5aGpGS3R0VDQ4U0ZvdjQ4?=
 =?utf-8?B?ejRoRlZTcTZ4eWhneTJjMDhRbFVGMmxXdG5NdklXVWVuNmlOQ01Ba09YTVBx?=
 =?utf-8?B?NW82RVVxaG9oeHAvWlF0cW5LUjgyOTJNU1p4T2lBeUthemRYQUVEeFZQNHdC?=
 =?utf-8?B?amdaUWJLZlhBK1RZL1EvVzBMeHgveEhkb0pia0NVejBFamJlb3FQNWc0RDZw?=
 =?utf-8?B?L2cyd0Q5aFRDbnRjUVZkOW1XT1RHYVd3aXJGS3BraUpyQ3V5WjFoTGIva0k3?=
 =?utf-8?B?a29Wb1M1NFd1SDRxaFNKbU1sWEZoR21MMHlrUmxGNm1TM2oxdzdHRGNJeTZ4?=
 =?utf-8?B?eVYvb08rZkJtRnRzSjJGU0xQTDZiZi9Sc0ZNcFRSU1ZOc0xnaHpiOTd2QnBV?=
 =?utf-8?B?WEtuQXZmNkU2bGVXOUJkVlFoTjA4aGU1ZEhNb1dnaE5MTyt3VUZ0TVVwSktu?=
 =?utf-8?B?TktiQjlpUzJzd2NwejBUYi9laTRJVStaZnFYcWwvVUNCSVh4YWJGcVJGYUNx?=
 =?utf-8?B?bk5IYWZsOENVNmljajMyVlRrZEsxUjZFcDY3ekNsUjY5WGpYU1hkRDVwamJT?=
 =?utf-8?B?RFRIbm9VK1p1eGo2ODNGMjd6cS9kZWNJMmtDS3Z1V3FVYVU2TGFrSDg1eHJL?=
 =?utf-8?B?TkVlSFl0NHlRbXFnV0x0Nm9BQ2tBbWkrSU8wMk5SYkJqYWJkaThrc2VnV2dw?=
 =?utf-8?B?NDZrK0NtekhRNEZDUDJ6dWROcnhMZkQ1QWJoRitKK25FdnlCbTVjZld1bHpH?=
 =?utf-8?B?dUFZeEN3d216MTVOMXBzbFlzQVE4VFppVHNhZk5ObXJBRk4ydXJWMFdva2xF?=
 =?utf-8?B?aFNvRER0SDY2NnBHc2VHVGV0dm9aLzcvY2NYMTBZSFJzK3piY2ZlZjJZSUQ0?=
 =?utf-8?B?MnRua0M5dkJucXNyek1ZK1pwZXEvT0ZMWno1Vnc4M1FDVWNBbmdnbElzV0Nu?=
 =?utf-8?B?a2I0b0h5blVSWWpweHhXWUdtMTdqakVCRU1QU3RkUi9sUVUrWi9MZUlCVVJX?=
 =?utf-8?B?akhaYXlHOFdYQ1IybFpid0tYSVBPWjZwdm1oTXBERzlsVFNQaGVjKzRNd2Y1?=
 =?utf-8?B?RWM5TWx3QUVlelJXbkVPTC8zSS9jUUtSWS9VK3RDQWV5Ylh4d092S201NWxr?=
 =?utf-8?B?cDdnblZkTTlXbStrYzAyRVFWL3g0K01xaDZDR1YvaVc4a1ozTXRWeXVKb1B1?=
 =?utf-8?B?K1FpTkk2SURpdlJNSlVuV0d3V2lvVUozeGp4NjIzajNjSWlBS0dHYURGOEVP?=
 =?utf-8?B?UjNOaVZEdmZrSjZQaFcvdHlaNFAxZXZ4ZTdGbXFlQjd4SThEU2hlcFBzaklK?=
 =?utf-8?B?elJkc3JFaWl0NWdFREhZVDZSSWpPSG5hQUpoVGR3cFVMKzFZbXhIcXUrSWl5?=
 =?utf-8?Q?rAoD4f7dqDyFOJqk20R8A2FWKHNMExIltU4Zc=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6870.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MlB0OWRRN3FhWS9xS0xaQjhoeVVoVS9vZUxrZlBOazVBM2NMSTRDZUY5bWxp?=
 =?utf-8?B?ZGNVQS9TZ29pT3QwQWFjV0J2TWplZGV3M0xFcDR1NHA4c0tGbmxYbC9NNjE1?=
 =?utf-8?B?NENCdmxnUjUzN1NXVlJVeEpNQzBtTXBzdEFCWlNsb3FBdnZ6MUt5emVGL0tC?=
 =?utf-8?B?dUlHdUJVb0VKYVFGWWk0UzZnams0cThhQzM1QUtrbEdkaUd6aGZaOXo3QTZK?=
 =?utf-8?B?YlVxYkxVSFc3ZTZSRHE1eGxvY2NWVzlFOUpQeldmTitoeHlzVlV6VjkvTmla?=
 =?utf-8?B?QmhjanNkc21ORWdVUEpoY3ptQVhkRHJmOVNsU2U4REc2YmdKTFdyS3M1Zm8z?=
 =?utf-8?B?b055TmxQSnNMK1RRd0ZvUENSWVJEOHBzNVg0VG01dkxLS3ZtTTBjNThaYnlq?=
 =?utf-8?B?YjVQZGtPNDNMVTUxbmhCOGNnV1FLaUJzSGJQU295ZkY5eklvemdMcGgyV09t?=
 =?utf-8?B?OWJ1RUVDVG5jUURFbFhMNGhudU1xSEVvWjBuYk0zVzBoMTdyb0lTYWpKSHlE?=
 =?utf-8?B?VDhLeDcxNUlGY0FhamNMWmxxOGUwY3k0amlCZGlYdWI4LzhCQmhsdkRKNmo1?=
 =?utf-8?B?TWtRdURWOFh2RldvRUNWQ25ONHFIQ0lycmtYNkJ3SEVZTjVrQU91S01TODBw?=
 =?utf-8?B?NFMrM3NJa0FzWjFwTG9FcWNGelhWSTFOUEtHUFRBOW5TME9saWFGWmhsaWFC?=
 =?utf-8?B?WG1QcTFDdkhXWWNFb0Y1WXFIelB4Q05VMmxxR0kxSlVPY1JGWFg2dU5QcEZE?=
 =?utf-8?B?Q0VtbFl0MzZKaUsrczBjU2tRZ3dwSHppb1RUcURMK21LTTZiUU4zL2NrM29J?=
 =?utf-8?B?UklaUTZUdVhRamtHZzhGQU85bkR3U2pVT2hpOVJPc3BJRW9udTI1bk1FWHYz?=
 =?utf-8?B?QjRtb0dKcVJXWk9oaXJUa1VRZVR3aHdaclYvSDJWd2JNR3hGd09MZUdoUVlB?=
 =?utf-8?B?Zy9ROWxQcjVQQXkrZTZQOS84ajhPY081R0VYc0UrZjU2amxCQmk1UElnSmdU?=
 =?utf-8?B?eldiTk1kZU92V3hlUHA5emdoUVFOOHFkK2RQU1BZNTJNWXZRdDNXdElJMTJn?=
 =?utf-8?B?L0liUDR4d2szWTQrWGJVTS9ZdmhzdEdndnNrMnBpNnlVVDJyZ0M5c2J4Q0Fl?=
 =?utf-8?B?MHBqT2xiLzRpek5ES3k5WVd3NnF0dmlYM0FXWUFMZnV1WmIwZ1hyZW1md0sv?=
 =?utf-8?B?MVRYYWFXSUExTDNrajdOeUFyeHgvRmwzZ2FzeDJIeEdTU1dVQzUxSlUrbFVP?=
 =?utf-8?B?eW1DMU10ME1CN3h6MUtaRWd4RHZycjJrdjU4THdMVE4vcVhRaGwwOHl1Q3BY?=
 =?utf-8?B?YUUwTjNaWjBrSWgwQ1ArQ3BPL200OUVMQzc0L25oYnRuZ1NKU1dhNkxIam9h?=
 =?utf-8?B?VHE0ZWp1Uk52dzMzYnFCbm8vNWpNNzI5L0ZtY2pDWHoyYnlXYjFDVkxQcmJ5?=
 =?utf-8?B?MCs2ODlPeUd5WUg0NWFwOHdWbzhoN1NqZCtlWjZqeEF2eCtRYmt3SHhRL3Vt?=
 =?utf-8?B?NWk4WXZUcVdkcEc5ZHF5Ukt5aDd6MC9pb2poaURRN3RDb2ptTUxMNDY3aWs2?=
 =?utf-8?B?WUVESkg0YjNtWkxkVGZocGVpLzBMWWVtVEVIdUR0N3Q2T2tLRG8ra0hYbzB0?=
 =?utf-8?B?NHpVUGVoUjFVWHE3RFNqTU5makVZSkI2SytLNWcrbm04QkFTem4rT3RlVmJX?=
 =?utf-8?B?ZFcrNCt3QlRBbVBjNWI2eW1KUGVJTmUxMnVYOGhsTmdHd0F0aWV3eG44RU8w?=
 =?utf-8?B?eW1zaG5mY1ArcUxYaW44Y2VTOXhKL1d6dmtwVmFGbUxrVHVDTUtzeHhMTklT?=
 =?utf-8?B?Nk5oL25adXZMZWsvc2FYSlVEeUo2b044aXRCSStsVkFJcEhjU1R6YVkwSjJT?=
 =?utf-8?B?M1JneG1sOFd4NEFkeC8wendBMUhPa2VtQnlLZFp3UlZqOTB0ZjkrZG81Y25K?=
 =?utf-8?B?bmVhay95RzBHelozbFc2MDlGcXliZEYySk05a1dvVHNWY0JmRVRsdzRkNXk3?=
 =?utf-8?B?UVhiSHZSNXZEMWNtWVZHbjM3UGYrWHluMHRHZTd3UjRvNlZSaWc1YUtQVkpj?=
 =?utf-8?B?K0JjUTlDWWhLL1paNnlRQ1JrbWd1RjBtNVpLdGtSQUFSNFE3Y1pjbXp6RDBj?=
 =?utf-8?Q?eXgY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC07936D612D7342BE1F440CDDCEFAB0@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB6870.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3d1b4f3-a777-49b2-fd04-08dcefff32ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2024 05:30:52.9250
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vJ/UhzVvgLGKMQZeKrOY6aFPb1ffeJLTuYzMOydQOme/s27r7gO3gCliJvVICsZ5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7282

T24gMDQvMTAvMjAyNCAxNC40MCwgSm9uYXRoYW4gQ2FtZXJvbiB3cm90ZToNCj4gRXh0ZXJuYWwg
ZW1haWw6IFVzZSBjYXV0aW9uIG9wZW5pbmcgbGlua3Mgb3IgYXR0YWNobWVudHMNCj4gDQo+IA0K
Pj4+DQo+Pj4+DQo+Pj4+IFByZXN1bWFibHksIHRoZSBob3N0IGNyZWF0ZXMgb25lIGxhcmdlIENY
TCByZWdpb24gdGhhdCBjb3ZlcnMgdGhlIGVudGlyZQ0KPj4+PiBEUEEsIHdoaWxlIFFFTVUgY2Fu
IHZpcnR1YWxseSBwYXJ0aXRpb24gaXQgaW50byBkaWZmZXJlbnQgcmVnaW9ucyBhbmQNCj4+Pj4g
bWFwIHRoZW0gdG8gZGlmZmVyZW50IHZpcnR1YWwgQ1hMIHJlZ2lvbiBpZiBRRU1VIHByZXNlbnRz
IG11bHRpcGxlIEhETQ0KPj4+PiBkZWNvZGVycyB0byB0aGUgZ3Vlc3QuDQo+Pj4NCj4+PiBJJ20g
bm90IHN1cmUgd2h5IGl0IHdvdWxkIGRvIHRoYXQuIENhbid0IHRoaW5rIHdoeSB5b3UnZCBicmVh
ayB1cA0KPj4+IGEgaG9zdCByZWdpb24gLSBtYXliZSBJJ20gbWlzc2luZyBzb21ldGhpbmcuDQo+
Pj4NCj4+DQo+PiBJdCBpcyBtb3N0bHkgY29uY2VybmluZyBhYm91dCBhIGRldmljZSBjYW4gaGF2
ZSBtdWx0aXBsZSBIRE0gZGVjb2RlcnMuDQo+PiBJbiB0aGUgY3VycmVudCBkZXNpZ24sIGEgbGFy
Z2UgcGh5c2ljYWwgQ1hMIChwQ1hMKSByZWdpb24gd2l0aCB0aGUgd2hvbGUNCj4+IERQQSB3aWxs
IGJlIHBhc3NlZCB0byB0aGUgdXNlcnNwYWNlLiBUaGlua2luZyB0aGF0IHRoZSBndWVzdCB3aWxs
IHNlZQ0KPj4gdGhlIHZpcnR1YWwgbXVsdGlwbGUgSERNIGRlY29kZXJzLCB3aGljaCB1c3VhbGx5
IFNXIGlzIGFza2luZyBmb3IsIHRoZQ0KPj4gZ3Vlc3QgU1cgbWlnaHQgY3JlYXRlIG11bHRpcGxl
IHZpcnR1YWwgQ1hMIHJlZ2lvbnMuIEluIHRoYXQgY2FzZSBRRU1VDQo+PiBuZWVkcyB0byBtYXAg
dGhlbSBpbnRvIGRpZmZlcmVudCByZWdpb25zIG9mIHRoZSBwQ1hMIHJlZ2lvbi4NCj4gDQo+IERv
bid0IGxldCB0aGUgZ3Vlc3Qgc2VlIG11bHRpcGxlIEhETSBkZWNvZGVycz8NCj4gDQo+IFRoZXJl
IGlzIG5vIG9idmlvdXMgcmVhc29uIHdoeSBpdCB3b3VsZCB3YW50IHRoZW0gb3RoZXIgdGhhbiB0
eXBlDQo+IGRpZmZlcmVuY2VzLg0KPiANCj4gV2h5IGlzIGl0IHVzZWZ1bCBmb3IgYSB0eXBlIDIg
ZGV2aWNlIHRvIGJlIHNldHVwIGZvciBtdWx0aXBsZSBDWEwgcmVnaW9ucz8NCj4gSXQgc2hvdWxk
bid0IGJlIGEgcGVyZm9ybWFuY2UgdGhpbmcuIE1pZ2h0IGJlIGNvbnZlbmllbnQgZm9yIG1hbmFn
ZW1lbnQNCj4gSSBndWVzcywgYnV0IHRoZSBkcml2ZXIgY2FuIGxheWVyIGl0J3Mgb3duIGFsbG9j
YXRvciBldGMgb24gdG9wIG9mIGEgc2luZ2xlDQo+IHJlZ2lvbiBzbyBJJ20gbm90IHN1cmUgSSBz
ZWUgYSByZWFzb24gdG8gZG8gdGhpcy4uLg0KPiANCg0KU29ycnkgZm9yIHRoZSBsYXRlIHJlcGx5
IGFzIEkgd2VyZSBjb25maXJtaW5nIHRoZSB0aGlzIHJlcXVpcmVtZW50IHdpdGggDQpmb2xrcy4g
SXQgbWFrZSBzZW5zZSB0byBoYXZlIG9ubHkgb25lIEhETSBkZWNvZGVyIGZvciB0aGUgZ3Vlc3Qg
Q1hMIA0KdHlwZS0yIGRldmljZSBkcml2ZXIuIEkgdGhpbmsgaXQgaXMgc2ltaWxhciB0byBlZnhf
Y3hsIGFjY29yZGluZyB0byB0aGUgDQpjb2RlLiBBbGVqYW5kcm8sIGl0IHdvdWxkIGJlIG5pY2Ug
eW91IGNhbiBjb25maXJtIHRoaXMuDQoNClRoYW5rcywNClpoaS4NCj4gSm9uYXRoYW4NCj4gDQo+
IA0KDQo=

