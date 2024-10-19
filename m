Return-Path: <kvm+bounces-29193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 616AB9A4B53
	for <lists+kvm@lfdr.de>; Sat, 19 Oct 2024 07:39:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78FF41C218B3
	for <lists+kvm@lfdr.de>; Sat, 19 Oct 2024 05:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F27261D63D2;
	Sat, 19 Oct 2024 05:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EVAgUrMp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE30A1D0169;
	Sat, 19 Oct 2024 05:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729316339; cv=fail; b=Td9fNXPbBlFyrxilJdW1b2+CK78qTIkkNZqgFqfz7gspmwcmRyI+Qjm6eHX/KK76bRtnWLAZf5qYLbbi3aF29Zkyfp2JDmHUBdJIWiFfWGWmNgxjoboA9//x2FBjNUXVJ6xZgK1hUT4/b8MfYhAU8l3NAvcDfYBfjPIJAuo50DE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729316339; c=relaxed/simple;
	bh=7UJHapq4g+V5iMdSrfSnztA6Xf2RytsogxI03QJTOKo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AGuriKl+VP2PIlejMCFJUMSj0x6bwxGcgzvFx8IRs+ahlFb8JzYbUal0pUOPuB96TkOEw/Xw8fMBzFKL2avNJCkBa2fk4RYjw9QJFwor6QUDNojeHL8vtG238lA1TjVPDMJq+1BG7S+WhMHbZ2MzVsHgZTMZ5cHjZAya0lbivNU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EVAgUrMp; arc=fail smtp.client-ip=40.107.92.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xNoapxaGckBPtGqZtasGWC6j9sI9s4B8TVO4YpO3Hj1Z6qfanYkWN1GMFGPUGDyFDIrijaPtzm8IYP4hpv1LclSQpWYxWKEnxmTASDHF6do3Rtd3eaYr3NII5UL2Yj7aLGYE8ov+pIigOyKlwT3cR7I190zTr/ju28oy/90gIP6LviKlnEQNQBBohGwG/0YYt8Vw+PcXI1T4oFeCsbFeTKyiSLnsiA8bAiPxlg6dqq/hbnEGkR5Tb7SPYufKK0eiBw6PJhulJcA5jEDLFnCHneXLUL9SfOb5TA/O1K4RmSYf741A4y5hB2Q0acl72UNWc17IOws6LJ/r9SFjGF8zDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7UJHapq4g+V5iMdSrfSnztA6Xf2RytsogxI03QJTOKo=;
 b=FBmOYV3SwWYtqOl98fYB5lroFGJfBIz8QA1UsX1ASE7ULlpAU0ufEL1t+OOnqIQ2Wb7BY5w7GGduzSe0PGuzFHdCisNHr2K2MpO7uEBF/Gew/2Qb1DkRnpexbKCx6V9Mak62CWFebR65fb8+aC8nkuR89BqJs9rZeWWavXJuwKAxWc4/iRYopszVwgEti93X1x546wh0KrmsN8PDMKjunKEYQFJjZ1KX5ybKb197OFpveWqFNVCIdZOsGzwloQePKlcJNTQ6MJsm2GQyDj1mRlN6q5ShuySpcdVD5txF+3ulO8OgNiqYATuBVxnzGzCl/nqKdgXVcXJ+HwCJgp2Ndw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7UJHapq4g+V5iMdSrfSnztA6Xf2RytsogxI03QJTOKo=;
 b=EVAgUrMpbM5YbI7Ybfev+S5VV/HcO0QfsoPqDx17Abty/phPMyJ7w/pj6icUR40jY81D8g8EE9+izJoFha0Eqwf/5arEiBnAeqdU+/S0f1mzoOcKWuZIIBG0vK9AYFcBrNa/ScVtCAXOIC1kzO6HixJMhIJH256FsfZbCAKoKePNh5eI5IaJBm8VPLyV+tNm2tEk0IQlieacF60/TL9TfcunDOan1KL+sCwzuvjwQIuTKFuRerOURjiknKd0z+0kGrOuQVs67cJEFUZh8aapI8TdWeSVLphJw2B7K1eYLBXG1cYJg7haEzl5KjqKE5HaZhdr9OuUWVoWoK5AZHA5NA==
Received: from SA1PR12MB6870.namprd12.prod.outlook.com (2603:10b6:806:25e::22)
 by PH7PR12MB7282.namprd12.prod.outlook.com (2603:10b6:510:209::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18; Sat, 19 Oct
 2024 05:38:53 +0000
Received: from SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::8e11:7d4b:f9ae:911a]) by SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::8e11:7d4b:f9ae:911a%4]) with mapi id 15.20.8048.017; Sat, 19 Oct 2024
 05:38:53 +0000
From: Zhi Wang <zhiw@nvidia.com>
To: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>, "alison.schofield@intel.com"
	<alison.schofield@intel.com>, "dan.j.williams@intel.com"
	<dan.j.williams@intel.com>, "dave.jiang@intel.com" <dave.jiang@intel.com>,
	"dave@stgolabs.net" <dave@stgolabs.net>, "ira.weiny@intel.com"
	<ira.weiny@intel.com>, "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"alucerop@amd.com" <alucerop@amd.com>, Andy Currid <ACurrid@nvidia.com>, Neo
 Jia <cjia@nvidia.com>, Surath Mitra <smitra@nvidia.com>, Ankit Agrawal
	<ankita@nvidia.com>, Aniket Agashe <aniketa@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	"zhiwang@kernel.org" <zhiwang@kernel.org>
Subject: Re: [RFC 02/13] cxl: introduce cxl_get_hdm_info()
Thread-Topic: [RFC 02/13] cxl: introduce cxl_get_hdm_info()
Thread-Index: AQHbC61aCtCMEvbifk6adg/llA05crKLP68AgAJ7VYA=
Date: Sat, 19 Oct 2024 05:38:53 +0000
Message-ID: <38fddcd6-ebb6-4f1e-b161-61d9b95e534e@nvidia.com>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
 <20240920223446.1908673-3-zhiw@nvidia.com>
 <20241017164458.00003c1f@Huawei.com>
In-Reply-To: <20241017164458.00003c1f@Huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6870:EE_|PH7PR12MB7282:EE_
x-ms-office365-filtering-correlation-id: 17bb4731-bcc4-4001-075e-08dcf0005190
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WERNM3dMZVJUalE5OGRkdTR4UGNQVlhveDRKSUllNHhwcE9UQVd0MzB4UGhH?=
 =?utf-8?B?UXZsTG5qUWQ2TUZVL0luMENiNkxDTnZQd1VZS0V5MXlvUHY1dG0xRDZwUDZG?=
 =?utf-8?B?Q1NHUHVQR3AzUmNpaXBmRmRHNGdhOG02Qmk4ZVliQk45alF1VlA1SEllY0F6?=
 =?utf-8?B?V21aZW9SZW1HVk92SFpwUlNFcEdBY3hzQTNhNXorZDRkOE55OURVZk5ZM0E3?=
 =?utf-8?B?Qk1wUE5GbnhyRVNldzRKZ1B4RXN2TzJmaEoxNXRGd3V2bWxocFhJRDJxTnM2?=
 =?utf-8?B?aU1ROUZ0RmpRcnRFeXROWC8zTEU1eklvMkxLQjF4dmRKM1BCS1ZScXlLTjMr?=
 =?utf-8?B?QWc5WTM0WVZnS211cElLU1l2WW92ZjJXeGhMWW1jcnhhbVIrZ3hsYkYvRTZh?=
 =?utf-8?B?cFA3U1Y0cFJvQjJVT3g5aDMwcE5KNEpvU1N5YTFsN3RjeHJKVHRwUnBNbzBo?=
 =?utf-8?B?bE5BSVVlWHV3azU0VWw2eFhQS2p3ckQyYWxtZUJSNHpVMFNERjh5NUJNaFhx?=
 =?utf-8?B?RkVIN0ZZc1AvMFpNTE53YWk0d1dvSU8wam9meDBVeHZxSHlNYkk3TXhiREZZ?=
 =?utf-8?B?QmxKUk5lV2M4NGpMUGo3d216bnZYOVRKMjlzR0VLWm5CRlZZNW5iVlY2aUlP?=
 =?utf-8?B?bGpVa2o0MmYwRVNsbDRZbkUzbEhlQXkyM0RYbzlycDc2RUVveXZpNEkrRFVJ?=
 =?utf-8?B?eTlwb1NNZjhxOExtbXBSTXpUTUdVbDBOWm84QVhlMHpPYjNoRmVUODdRV3Z6?=
 =?utf-8?B?T1JTMkpzTVpMYkN5TUJTWUxMWjlGbmUwYkp4OUg2Rk1pbHZKZHFOb3FxWURH?=
 =?utf-8?B?Nkd4dURKdHZGNUpqekxyTFdsMXZzWklsTlBvTXlQUEEyM1dGTEdRT1QraWY3?=
 =?utf-8?B?bUJNWDYwRDFTVDhySENhQ3JkRURCQWhqNk1LS09DK2NDb0d3bDdZSDNBN2Fh?=
 =?utf-8?B?N0ZJSit0cjRFeE9nNmZnd3JQZHdzSXo3blpIVWoybDgzbFYxZVZtUFR1YTk3?=
 =?utf-8?B?YUpoNlBkdHJKZmNVL1RPYmprZGdvTm5zK3A3dTRaY28raDlWdk1UTloxL2Fk?=
 =?utf-8?B?ZFJaNW9jY1VMMmRwQTR3OGZyQVVBcjY0dGhjQ2xDbUNNa3o0Ui96ajRIK1JP?=
 =?utf-8?B?SGlXS1hnemlMN01qWWUzTXdFL01lRXB2RVZjTXRodmJTVU1pSUh0bXJySGwr?=
 =?utf-8?B?L1E5THVUM2ttYUdkVkxXdk9LVldtYXNVaUdnYkFxV2ZrQ21pVlE1NUdVVWxi?=
 =?utf-8?B?azVrNXNzdHJneTVOeFJ0TVVPdEdRbnpFQXU3L1ZkU0dSZ0loek5RUEhzWWlv?=
 =?utf-8?B?WmgvRHBrbjE2NUJrVHQ3aDZBV3dnUWtydkVwSkJsZ0NhY0pUTGNQNUJDQllJ?=
 =?utf-8?B?MlRCZWh1UHJrak5tcU9rZG0wMXM5N0dZelIxWDRaUFlpOGk0U0kvR1Zja3Bt?=
 =?utf-8?B?MFZmc1pIRks2Uk1FYW9ORDUyUW5kVG82aEoreUFlV0srdUVrNTZYaWRvVWdw?=
 =?utf-8?B?WUhpWEVHK1Rta1AvZGgrVFRjdmx3NGxrdE5MM2hheVR1dDRlL041SUJhdXVq?=
 =?utf-8?B?R3RiWEtDazF0NGp0c2VsM0lrMU9vNXZRVm5KVWVkU2NkU010ZU9ubmhoRWxp?=
 =?utf-8?B?WG5xZDJsZXpmL0s1WnpOVXBqS3NHV0xNSHAvQ2E0Vk1LRnZUbFJMdW5ydGRs?=
 =?utf-8?B?bVIrWllNcitsdHllejNHL3BPZWhvVFVJRm5ieG8xNDZ5OG5SNmx3bnE2NVJl?=
 =?utf-8?B?Mm1rRnVNWFIybHlSa0NhVjMzeVRrZkNrQVJya3RqKzdqeUhCNUZVQ1B1cXBz?=
 =?utf-8?Q?Ae/vhS1mFV+y/JNB0CVKMk+du3RaZDKME1Evs=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6870.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UHR0QmJ5bXpKRk5IeXZvZnQ2RjFVczhDdDZEaXAzL0o5R2ZGODdkd3RGQ0hS?=
 =?utf-8?B?cUZRcUtQNCs3RUJ5MjBaTnBIRXlINEE0Z3I5UFZLZ0lsMmJWTFgxZlAzNDFh?=
 =?utf-8?B?eTZwRm4yNXlicVVUZU5PcGQzckliUVU2ZzhtUGRnT0dQUkljY25Lb0V5b0RV?=
 =?utf-8?B?eWUyRFhlcFBpODdsVkVraExZRUNCZUFZbFNYeG8ydlh3U29pUlU3cnN6REZW?=
 =?utf-8?B?a28yaStHaVNjVTU3VWY4ZTlUZDZuOExoZGc0OFhCN0lpaEQrOW5NVWxvc0E5?=
 =?utf-8?B?Q0R3YjJtdVI0eTMxUEdQMWYzaUpVSW5ldjFCcDZlL2RRc1N3ZTJOYWgrSHVD?=
 =?utf-8?B?a3dRbGd5Z1dFT0dBZlVCTEt4VGdhUmU0akJ4ZnBMMmJ1N3NRUjVuM2pCSEpj?=
 =?utf-8?B?QTE4NEppczVjdXRwanZ0TUlScGN4cndIVlhHMldrZWFjRE5zeDB0MjVQcGZO?=
 =?utf-8?B?QkJpNi9OQjArMGlvL0xiUGdHRWNlUzdLQW9RVXZRaDhGTzlBbUtmQzBrSlg3?=
 =?utf-8?B?YTRNVUdqWGVPanVtVW9NTEVpK0tCdzJoMlo0Tjd0MmRWdDFHYU5yZXZwNFRN?=
 =?utf-8?B?WXk5QnB2ZGNZelNXMERFOXdqWHBmc0RkSnRHSXhKeG1IcHdoWnVVSG5aMEt2?=
 =?utf-8?B?RFM3ZVJjbXhMcUFnbFlTODRobmNTMnhqUmNYbnB2WnFUZ2JxejdYMmUxYjFh?=
 =?utf-8?B?Rm1mUFViVEVsM2JaSHNRYzhLSnpRekdhQ2F2Rlp6TlFvOUd5eDBQdTJYeDdD?=
 =?utf-8?B?VTNwRWVVbEx0MGxyckVWenNwVG10b0oySU4xTEMrbUp3QWNvMVVhZ3BPU2xL?=
 =?utf-8?B?LzIyQmxsSmpFQlB3UUw2RzY0WUY4TXc4MXpuVmxKK0FLZ0c3R0x4aktFbzJ3?=
 =?utf-8?B?VVg5QmFwZ1hFV1BXYXJSajhIbFFMcHp4amh1SGJxQmxQNVpRdy9TcTVOanpI?=
 =?utf-8?B?RkdqUThUZGNpVzhxZkRqS3E5NjZiM25TcFJTQVdqcUdpNTJGSWJNd0dCTVUy?=
 =?utf-8?B?L3BFRlpTZWkvZHNWSyt2K2pDYzlsOUg3WDJaQ2N5TitzVmZWRktOLzVPempR?=
 =?utf-8?B?NTIwRUtQKzBvN0tpanR0UU8wTkxTaGFNYlN4dnFEdTdnL1h0bFAyZFNKRytn?=
 =?utf-8?B?d2ZvdFo5S0RqNWMxTHhScWR6c28xVXJRQ2p0MEdDWVUyTXh5MHhTRmdkSlgr?=
 =?utf-8?B?QS9sblVOQlJPKzF4SFNFdlpuN1dQNHZPZHA2U2lGUlVEUGM1ZzFzWGkvUTBP?=
 =?utf-8?B?NHNPRFdyNFJjR0kxcUl0KzZzWkZuWVVDYlZ2REkyc0xFL2VMYjNyZ1hRb0Q1?=
 =?utf-8?B?QUtCcFdvSFN6SGxyTVVTRFZEUjVETXZSL3lEUzQ1N3RmU252S29DSHNVYmx3?=
 =?utf-8?B?aTNpR3A2cTdhZFZWaU9OSWNxWE9tU1NUUXgxemVyZUYwRUYyUkVNS0VPSG9x?=
 =?utf-8?B?WDVFYUxTL2Vaelc4VDRianhQMThqTVBqRldxbjl4aXkrb20rVjMveUEySXRT?=
 =?utf-8?B?bnI1cjZrL2VYYytQMkE4VGZUZ3c4UkMvMkE5Tjd3cVU4dnYrRG01OWVPMlJ2?=
 =?utf-8?B?NitXYk1oMUpNN1E3Z0IvTHRhVUoyVmlmT2tYNDh2ZE1FOXJLNDlHbFl5aGRo?=
 =?utf-8?B?VlNwOEJwdmhPMWpKQlJpMEVWRHR3aXBzYlMvNXZYZXpPZG5EMjVnY2ZJKzNI?=
 =?utf-8?B?aklDZXRkRUdtWS83TXg3UU1MVHEwY2gzTnpzdTJMY09ia1pVc3F3N3lXZkJr?=
 =?utf-8?B?NkRhV24wSllQaWdYdW5Zai9XaFI0bW9nUVBCYVByUG5sVWhLWjBrdnI2d1Vl?=
 =?utf-8?B?WHZ3a0ZxMDhWSnNnNXFuRkp2QWthMG0rL2hPcFR3dmFrUXZLVk5xVHMrSmxT?=
 =?utf-8?B?VGwvbFJzZUI1RXVNeVJLTTU4RU5JNTZRMlNnS2lJN3NZZzFCcTV0RjZSK3p4?=
 =?utf-8?B?QWx3cmszbFBtd1JJNzVMZmJzeW1wVzhJQlByd21PU0pyUkY0eW1MUXJFMVV2?=
 =?utf-8?B?SVVBVHhjY08rSWdJd2M0RmNXc3hZcmpBRWt2V2pSWG5OSmJ5S25sOHZpMTJn?=
 =?utf-8?B?ZlQ2d0pWdGlWci9zcHpFTkVneGdSQllwTFhnc3pSVVk4L1F3TElDMEFXTGhC?=
 =?utf-8?Q?02DU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C55ADCD15C7B7F4B9FCDBB3EC61ACA3F@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 17bb4731-bcc4-4001-075e-08dcf0005190
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2024 05:38:53.8239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: reDvvaspjUyrUhT0k8+/5PUsZWHS5HvSC5sgDpI9VaOKMnrCrWFnU8tGqyaYtNE/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7282

T24gMTcvMTAvMjAyNCAxOC40NCwgSm9uYXRoYW4gQ2FtZXJvbiB3cm90ZToNCj4gRXh0ZXJuYWwg
ZW1haWw6IFVzZSBjYXV0aW9uIG9wZW5pbmcgbGlua3Mgb3IgYXR0YWNobWVudHMNCj4gDQo+IA0K
PiBPbiBGcmksIDIwIFNlcCAyMDI0IDE1OjM0OjM1IC0wNzAwDQo+IFpoaSBXYW5nIDx6aGl3QG52
aWRpYS5jb20+IHdyb3RlOg0KPiANCj4+IENYTCBjb3JlIGhhcyB0aGUgaW5mb3JtYXRpb24gb2Yg
d2hhdCBDWEwgcmVnaXN0ZXIgZ3JvdXBzIGEgZGV2aWNlIGhhcy4NCj4+IFdoZW4gaW5pdGlhbGl6
aW5nIHRoZSBkZXZpY2UsIHRoZSBDWEwgY29yZSBwcm9iZXMgdGhlIHJlZ2lzdGVyIGdyb3Vwcw0K
Pj4gYW5kIHNhdmVzIHRoZSBpbmZvcm1hdGlvbi4gVGhlIHByb2Jpbmcgc2VxdWVuY2UgaXMgcXVp
dGUgY29tcGxpY2F0ZWQuDQo+Pg0KPj4gdmZpby1jeGwgcmVxdWlyZXMgdGhlIEhETSByZWdpc3Rl
ciBpbmZvcm1hdGlvbiB0byBlbXVhbHRlIHRoZSBIRE0gZGVjb2Rlcg0KPiBIaSBaaGksDQo+IA0K
PiBJIGtub3cgdGhlc2Ugd2VyZSBhIGJpdCBydXNoZWQgb3V0IHNvIEknbGwgb25seSBjb21tZW50
IG9uY2UuDQo+IEdpdmUgeW91ciBwYXRjaCBkZXNjcmlwdGlvbnMgYSBzcGVsbCBjaGVjayAoSSBh
bHdheXMgZm9yZ2V0IDopDQo+IGVtdWxhdGUNCj4gDQoNClRoYW5rcyBmb3IgcG9pbnRpbmcgaXQg
b3V0LiBXaWxsIHByb2NlZWQuIExvbC4gTWUgdGhlIHNhbWUuIEkgd3JpdGUgYSANCnNjcmlwdCBv
ZiBzZW5kaW5nIHBhdGNoZXMgdGhhdCBhc2sgZm9yIGNvbmZpcm1pbmcgZXZlcnkgaXRlbSB3YXMg
aW4gdGhlIA0KY2hlY2tsaXN0IG5vdy4NCg0KPj4gcmVnaXN0ZXJzLg0KPj4NCj4+IEludHJvZHVj
ZSBjeGxfZ2V0X2hkbV9pbmZvKCkgZm9yIHZmaW8tY3hsIHRvIGxldmVyYWdlIHRoZSBIRE0NCj4+
IHJlZ2lzdGVyIGluZm9ybWF0aW9uIGluIHRoZSBDWEwgY29yZS4gVGh1cywgaXQgZG9lc24ndCBu
ZWVkIHRvIGltcGxlbWVudA0KPj4gaXRzIG93biBwcm9iaW5nIHNlcXVlbmNlLg0KPj4NCj4+IFNp
Z25lZC1vZmYtYnk6IFpoaSBXYW5nIDx6aGl3QG52aWRpYS5jb20+DQo+PiAtLS0NCj4+ICAgZHJp
dmVycy9jeGwvY29yZS9wY2kuYyAgICAgICAgfCAyOCArKysrKysrKysrKysrKysrKysrKysrKysr
KysrDQo+PiAgIGRyaXZlcnMvY3hsL2N4bHBjaS5oICAgICAgICAgIHwgIDMgKysrDQo+PiAgIGlu
Y2x1ZGUvbGludXgvY3hsX2FjY2VsX21lbS5oIHwgIDIgKysNCj4+ICAgMyBmaWxlcyBjaGFuZ2Vk
LCAzMyBpbnNlcnRpb25zKCspDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3hsL2NvcmUv
cGNpLmMgYi9kcml2ZXJzL2N4bC9jb3JlL3BjaS5jDQo+PiBpbmRleCBhNjYzZTc1NjZjNDguLjdi
NmMyYjYyMTFiMyAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvY3hsL2NvcmUvcGNpLmMNCj4+ICsr
KyBiL2RyaXZlcnMvY3hsL2NvcmUvcGNpLmMNCj4+IEBAIC01MDIsNiArNTAyLDM0IEBAIGludCBj
eGxfaGRtX2RlY29kZV9pbml0KHN0cnVjdCBjeGxfZGV2X3N0YXRlICpjeGxkcywgc3RydWN0IGN4
bF9oZG0gKmN4bGhkbSwNCj4+ICAgfQ0KPj4gICBFWFBPUlRfU1lNQk9MX05TX0dQTChjeGxfaGRt
X2RlY29kZV9pbml0LCBDWEwpOw0KPj4NCj4+ICtpbnQgY3hsX2dldF9oZG1faW5mbyhzdHJ1Y3Qg
Y3hsX2Rldl9zdGF0ZSAqY3hsZHMsIHUzMiAqaGRtX2NvdW50LA0KPj4gKyAgICAgICAgICAgICAg
ICAgIHU2NCAqaGRtX3JlZ19vZmZzZXQsIHU2NCAqaGRtX3JlZ19zaXplKQ0KPj4gK3sNCj4+ICsg
ICAgIHN0cnVjdCBwY2lfZGV2ICpwZGV2ID0gdG9fcGNpX2RldihjeGxkcy0+ZGV2KTsNCj4+ICsg
ICAgIGludCBkID0gY3hsZHMtPmN4bF9kdnNlYzsNCj4+ICsgICAgIHUxNiBjYXA7DQo+PiArICAg
ICBpbnQgcmM7DQo+PiArDQo+PiArICAgICBpZiAoIWN4bGRzLT5yZWdfbWFwLmNvbXBvbmVudF9t
YXAuaGRtX2RlY29kZXIudmFsaWQpIHsNCj4+ICsgICAgICAgICAgICAgKmhkbV9yZWdfb2Zmc2V0
ID0gKmhkbV9yZWdfc2l6ZSA9IDA7DQo+IFByb2JhYmx5IHdhbnQgdG8gemVybyBvdXQgdGhlIGhk
bV9jb3VudCBhcyB3ZWxsPw0KPiANCj4+ICsgICAgIH0gZWxzZSB7DQo+PiArICAgICAgICAgICAg
IHN0cnVjdCBjeGxfY29tcG9uZW50X3JlZ19tYXAgKm1hcCA9DQo+PiArICAgICAgICAgICAgICAg
ICAgICAgJmN4bGRzLT5yZWdfbWFwLmNvbXBvbmVudF9tYXA7DQo+PiArDQo+PiArICAgICAgICAg
ICAgICpoZG1fcmVnX29mZnNldCA9IG1hcC0+aGRtX2RlY29kZXIub2Zmc2V0Ow0KPj4gKyAgICAg
ICAgICAgICAqaGRtX3JlZ19zaXplID0gbWFwLT5oZG1fZGVjb2Rlci5zaXplOw0KPj4gKyAgICAg
fQ0KPj4gKw0KPj4gKyAgICAgcmMgPSBwY2lfcmVhZF9jb25maWdfd29yZChwZGV2LA0KPj4gKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBkICsgQ1hMX0RWU0VDX0NBUF9PRkZTRVQsICZj
YXApOw0KPj4gKyAgICAgaWYgKHJjKQ0KPj4gKyAgICAgICAgICAgICByZXR1cm4gcmM7DQo+PiAr
DQo+PiArICAgICAqaGRtX2NvdW50ID0gRklFTERfR0VUKENYTF9EVlNFQ19IRE1fQ09VTlRfTUFT
SywgY2FwKTsNCj4+ICsgICAgIHJldHVybiAwOw0KPj4gK30NCj4+ICtFWFBPUlRfU1lNQk9MX05T
X0dQTChjeGxfZ2V0X2hkbV9pbmZvLCBDWEwpOw0KDQo=

