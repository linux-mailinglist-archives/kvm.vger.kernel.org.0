Return-Path: <kvm+bounces-31356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EC0E9C30D0
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 04:56:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D697281AFC
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 03:56:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A42C91474A5;
	Sun, 10 Nov 2024 03:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sH4sxhtg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2065.outbound.protection.outlook.com [40.107.96.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E602813B7BC;
	Sun, 10 Nov 2024 03:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731210961; cv=fail; b=HSF3vzqGoYEP8k7tWiA2zE06yigbg0szO8RBsW4IaIQF8MbhxmerfsX67C2v7NrJ9iW6udNo42pzjB+73kmsu5qQJ99Ihp+7Ei+EyrUFLABrHtq/rOv030K2J+TWZDJpNZJkIGwteAdX9+iwb45iQXZEPZhELtAu+J724iXh6pQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731210961; c=relaxed/simple;
	bh=Xg1MGd4+J+59LH4CNHbi/tONW80TwsNXt8iCrkIFA3I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=V6seoI3m1PvRO7g/rP7Nf5kLdId42aidRkfUI7X/kzIhTl4VUlaeRZBUhHpRlQfypeR77WXOoaVu/IGkadsLEKWSLlSWWVqSHzoRV6D6oANcOF6qrb+W9OSzTwt46S7HoxQ6Oxin/8x+64ID9DRk3IaTi0/t9yua8OSbUZJ59h4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sH4sxhtg; arc=fail smtp.client-ip=40.107.96.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EDlXop+XYXUREA76pswnZRYQRJrkugnhbmPjzfmyaiyV71IRa+9iOE7xr2DVk29dmD5vqMnrDSfG3NG5mUFb+IIzlsm6X88wkK6GJp+odOvhP+j28BT0CW2v2VyLJjzTMaxFhPygKXxw5orBdRu8uJYzVxlmuOrTytQDKc9r2DS94gI8DBdmAuS4JLK3kNd50Z71it3kmOVWjDvAr/U5zYqzMM2VRhcm5haTHIEUjEDK9Z0E394UtlgzeOQwIU8pyhRhtKY7yZ6p5GNvLllRYvD98g8Yj8tynSRqnliS9ulJKpFQUezAoMBriVLU8F4cv2isZMZLx7/Aje03YQyk7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7S1nClL0jNMnze6QcYhuR3TdyKFIWJaSzLXrebJk0Hw=;
 b=PMn//HCDkiCkRtJdn1demneubk5Kf2JhmiBqTWe9Sgpt8ilsNqv52kJ3JJZwhLDqdO8Vgjavuk1MzOsbWbAd83hvpPcBCmTEWCUtRckseDhF8YuiSdwGKjqhjf9ufsMlRL1lplRtwle9CyDBKN0bR05Hwi5V9VHDj3csZAPKICnJzDJhHGJ4R7WOs3TZpLNHItaxsx2t0n7L4xMFQJa9XJIjeVA6b2XNggMAKmqf5n04IeGN7oxYbm7boEE38+DCD9YfN9p+gNuq0wlD9xWK4Drp8mNl6d1MHYEoMaalrPjtaj7w+5ZFyieD1HW7CZ8aqPeZZT+A+b7egrO9NnEKVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7S1nClL0jNMnze6QcYhuR3TdyKFIWJaSzLXrebJk0Hw=;
 b=sH4sxhtg5oHdk5abmwg8cMBEuFo+aq4jNgQLjbFGVrD5gn/T1C4gQ1d6b2VpZMbVwwRhJS6ltxN3G3lwvOsYXqhQ6NS+s/68i1Fh/SPBdvqTP1c5ClaT7pdUK2BNK9GoPUc98xVv68d7VbaQr6Quf8ZR9aPdB57/dcqJm9UjC14=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 PH7PR12MB7209.namprd12.prod.outlook.com (2603:10b6:510:204::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.21; Sun, 10 Nov
 2024 03:55:54 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%3]) with mapi id 15.20.8137.019; Sun, 10 Nov 2024
 03:55:47 +0000
Message-ID: <29d161f1-e4b1-473b-a1f5-20c5868a631a@amd.com>
Date: Sun, 10 Nov 2024 09:25:34 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [sos-linux-ext-patches] [RFC 05/14] x86/apic: Initialize APIC ID
 for Secure AVIC
To: "Melody (Huibo) Wang" <huibo.wang@amd.com>, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, bp@alien8.de,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-6-Neeraj.Upadhyay@amd.com>
 <f4ce3668-28e7-4974-bfe9-2f81da41d19e@amd.com>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <f4ce3668-28e7-4974-bfe9-2f81da41d19e@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:806:20::11) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|PH7PR12MB7209:EE_
X-MS-Office365-Filtering-Correlation-Id: c7b45b3b-4f96-411c-a9fe-08dd013b8f0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bGNDUDYwbEttc3V6SFl3dFlONHRpUnJ6RDcvclF2SUZGMjlDaCtSdjMxRVlT?=
 =?utf-8?B?blhGNFZNSG5GajNUU1lhMGI0TnFObWJCdllnalZ3M1VuS2NnTXdycWQ5dmxM?=
 =?utf-8?B?QlZBekVSVzErMjB3blBtVm00cGdPamRSd0xkVmZVKzBrSnVOR2VFSTg3TEJQ?=
 =?utf-8?B?QTVGNzF2NllhRkw3R1AyWFNXMGViNERmTUZDVVZEbDZUTkhJSC9jaEJsM1hK?=
 =?utf-8?B?RjRtLzhWdnVLWUwyUHFsZWNEeXBKWWNsWU03cklEWWoyd3M3a3o4djFsa0sy?=
 =?utf-8?B?cUlUeDhIVnpkTERPdWd2anVLazdFRFR0cGtUZ1dqcXAvK0U5OWRMMVFhdzh1?=
 =?utf-8?B?WjlRQW5Xak1kaEplbGdVQkM3Q1A5dCtYY0IrMVBhNzZmTUJ1N0k0THo0anJa?=
 =?utf-8?B?dmh6bTA1S3NJR3N4K0N3M2I3RjVINDVKUkxZak4vcHRlbEdoaXdoUkhkTUor?=
 =?utf-8?B?cTJYaVQyT0VKNWxJV3hJSVF1blF4MUVwbUVod1JndFA5SmZoT0pzZHZlcS9I?=
 =?utf-8?B?eTR4eS8yTXVOWmt2bHpWVGlWQndRclhnSHo5YTlndTVJMlBNZWl3MXNocjRV?=
 =?utf-8?B?SWRQN3hyOTQ5a1dJaXdQOS83UGkvMElmKzVWaVpNelpXZk5JY2FjYXpiOGJ1?=
 =?utf-8?B?MVNUNlBBRG5RM2dvMTkxK1FEdHkvczJJN1hjOWo1Z1pYdklMaEhsTFYzczBF?=
 =?utf-8?B?dldrbmFndUNSWG1hWGpHdE5TVFB0aUp4OGY5cE15RjlQS0NvYjZ5WTArbWlB?=
 =?utf-8?B?QWtWZmJneWJJVlcvU1VuNmh2WGpZbmowYmlDQStkUzlqc1p5SVBHaTZtZEpD?=
 =?utf-8?B?OW1xVUlOMFVDTDlzd242dy9YMi9TRXJWNUVzOUI1TnZzbXFxNlBUSERYL1V0?=
 =?utf-8?B?VmFLS3pRd1JkWno3NWhzVlg5Q3NGaDgyeFl5eUZJd3g0N3B5WlljMFlzcFEv?=
 =?utf-8?B?VnZ2Z2U0QXAxcy9qa0tTNVZaQUlQU2NTbTUyaEowVWVzWGgxdGpIN08xYTVo?=
 =?utf-8?B?ak5Kc2NKZ2FidHlYN0pKMm0xOWM4dTJCRWtTN3d5OUg2NExmTTlsWWQ0Wkdj?=
 =?utf-8?B?c2FnQjBoQkNZaFdTNEFBWFowNFphb3pBT0s2MmltVUE1Y0t4ajEzV1MwS3lF?=
 =?utf-8?B?Zm43YVBkUXVSZkcyVGRtcnpWTSt2YTFxVlk5L3ROUllrMFZnRmlBZnZCWU05?=
 =?utf-8?B?MHBkSFRQSTYzQ0xaZ005c1ovdk1zbFJlNHJWbld4NjFVL2V2S3M5YjJ4dEcz?=
 =?utf-8?B?RHZLTERzSEhCaTBvcmhXdVNiQzJXck9mekNXNUFobnhpdWRjc1BVenNuTWdE?=
 =?utf-8?B?UkFZaVJ4eDJOc1JydTRucmFJMEZlZy8xOGM1N0V0U2ZDQUs0QW5nYldDVW9y?=
 =?utf-8?B?N0pRRGk4RzY1Vmh0V3c4aWU1cnB5UHlmSWtidHlRTXdlQ1ptZFFKdVFXTVY5?=
 =?utf-8?B?UnVnM0JaakxCVmtWaUEyb2ptM1Y1OU5mcHdCcWpVZzZVY21qdWxHZVY0cTZr?=
 =?utf-8?B?L3JkSDNOMVZ2Mi9EOVpsakx5RDNlSVV1OG5xaTdFc05VNkNWLzBlWitrK3Fp?=
 =?utf-8?B?eEdHSm9yS016U0JjTW4rUFNwRndBd3FodW0zd0d5SEtGM1VaU3lqT0RkWmZQ?=
 =?utf-8?B?QUUvWkswQVZpY0lHWmVpV2VNVGRLZmVMMDVDdGJiYnRBMmZBZm0rdDF4SGNl?=
 =?utf-8?B?dGt1Yk9KWUtaZ0lGcTRKeTNVTllHRHFBT3VYTXZ6dEtkak1iQm1LL3Q5MTNL?=
 =?utf-8?Q?1QoNzc9fNsuzNgFqWgdIH/8jIAQ/XOEsCLDefz2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1JuQUpkYXdHOFJQMVV1VDV3YXNGMmVjYzFlNTlUR3BaM2JlNDlwVE1RUlYz?=
 =?utf-8?B?T1FrQURKYWQ5eDkwOWtIbUhuRGdteXkrT05ibCtaR3FJREkvU2xLcGlTcmEw?=
 =?utf-8?B?UWk1d2dWelhLQWRYbzlhQzVrYnpkRHFCQmR3VnAvWmRpUmdOZHNiUE54YXVV?=
 =?utf-8?B?N0ttbFhFY2hrUitaS2l2anBkRUs4Q2NTR2ZSUTR3WDVDQnFhNjU0MEk0SHp4?=
 =?utf-8?B?dnA1ODYycVNPbU5BTzBsM3RmOWxHRmdRemtHYVlMdExhQlJTQ0R4WkN3OGdM?=
 =?utf-8?B?K2lDeU01cy9IVEFha3FlKzh4QVJObFdzM3lXRnZXUFhwczZrS3FVU1RSdnJS?=
 =?utf-8?B?VnVZRjlBMlBsWWJ5WXFSRThkUG9uaVhMRHZWNitFZHM3NGw1Uyt3WmszbXlo?=
 =?utf-8?B?NzhqcTdhdWdURUNDWFovc005UC8xRmE5bXpITUc4ZENFcXpvbkpNeHZBYUhP?=
 =?utf-8?B?OTBuWndJWUJndzd5b1EyQitWOGdJZGY1d21aVEFKNGp6Q0pWQTVybmQ2VUVT?=
 =?utf-8?B?bTFyQ1ZBYmhGenVNTnFTT1RUY080ZzI3eXNWUUpnRHRlSncwSDhabUtsVGVZ?=
 =?utf-8?B?U3JuRkkveFd4K1ozM3E2TFJMRUxFVU5IQ3Nlc1duYVBVTlc0MzM0cWJGdzIw?=
 =?utf-8?B?SUFEQThIUUlranRWT2VqbXdWMmVYNERwcDl0Z1ZoT1BiRkFRRUI3RHovemMw?=
 =?utf-8?B?V0dpM0MxNm9qcGduRUJNWUdTQVI0aVJ1aTJoazFIU3YwTUZxbWYwMzh5V2Zq?=
 =?utf-8?B?aFd5OEZyMVZFUGdjT3J1MUE2K0RETjNZM2RyRktTTWVNZkpaVGFDYjBIejBn?=
 =?utf-8?B?TUtlY3lsVWVBSk1DOEZGQmgxVDlqRkQ0ZjZiQmVPOHEzSlJYaTJTNlFvaWk2?=
 =?utf-8?B?Z0hGRHp4c3NXRXVsT2dySmQ1WUtjbXdOS0daeGpobTMvWGR0Y1Qzb2pkNThm?=
 =?utf-8?B?ZU50WlNPQnRJdkdRaUpuNVBoSUJHcEhLRmt3OXdtWGpWNkxtOGRSTll1bmRr?=
 =?utf-8?B?Y1hKaC9NQXFQaDhDbzkzRmdGeWhObjN3RmJ5NDV1MXBURWhuT3NXbU5TYkZu?=
 =?utf-8?B?UlgvSUN2cm1yencxQnJIWWZLWDdwc1VxMHlXVmN0NkgxNHd5WklkU0xubWlD?=
 =?utf-8?B?QU9xQ3JXNHAxdWkzNjdocTVNbDhFckJ4Y3RqMlhTR0g4VFJybm1YSnF3alN4?=
 =?utf-8?B?VWswZU9yWXdET2lFS3JDdng2ckNxSHNMNFVBRzZlY1NqRDQ0U3pMRE1JdWVh?=
 =?utf-8?B?WTRjbjQzNDdrWFVRakIybVIzQTRvWjhHaVJKVHErOEJteUIrOFVOZ3d2STFH?=
 =?utf-8?B?TytvMFFBeUFVaE4ranVsSzFrbDdHeXRjUUhyVldXZ0xvZlNmY29LaStvendi?=
 =?utf-8?B?K2VYTGtZb24rM1dRMlFsS3FwQk9FcnV6UFJ4Y3FTRzEyYnBZZUw2ckN5SXFW?=
 =?utf-8?B?T3k5dzB2TGxpUG9EZjRFMkhhMk5mVmNldy84bjIwdkhJOHJWZ1VERHB6Rm5i?=
 =?utf-8?B?ZWh0VFJEekV5WU9BNnhFVE5xTGpPR3NJaDlWTVlzd0dnQWl0WWxqdWF2YzVJ?=
 =?utf-8?B?RE5CTnRYTHhtbDVuMkJhKzJYVWFodUtmbndReEVYb2o4dlFFU01US2ZpeDA1?=
 =?utf-8?B?eEp2TlNJTmJKeEFyZWNWSUozYUNVWU5zZWMwMXhvY1JqeVlUeWl4bU5aY2Ft?=
 =?utf-8?B?Q1BiU2ZvMEFBVjhXTjR6RWVXdlMyOEIzUXNRV2txYlhwVnZEdjdrVVNSakpF?=
 =?utf-8?B?blNsRW1WaEFoems2LzQ5d3U2VzlwOWsvbXp1T1dFSW9ZYUZCRTNXYkU3UWQ0?=
 =?utf-8?B?ZlZnZlZ4SGZEN29xRFFzUlB3ZnFWTW53NSs1a2tKUXR4eXE4YTFjeXRjWEVT?=
 =?utf-8?B?cnY2QU1VcGRzcEtyWUdXYmRmWmEvMDFsNVlTbE5MNVV4c21DaSt0K0ZyZXRK?=
 =?utf-8?B?Y2UyaXJKdzc3UHpzbE0zMWxPb2cvZSt6VmM3WWZ6MXdzekYySXNndzM0OHR0?=
 =?utf-8?B?T1VNalIyS2hoUlVEdkdNOXJoZzlsRHYvVS90OG94azRLTVdwd0pBRmpod2F1?=
 =?utf-8?B?QTNDWVNzUmVjaHovc2dhZm1FekFGU1BIenRIRGVCSWxTU3Z5SnFXYW43MGs3?=
 =?utf-8?Q?slUa0cFh1BEzk3OoEYqJu/VDw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7b45b3b-4f96-411c-a9fe-08dd013b8f0f
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2024 03:55:47.3449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ogxh/GM3GDGJrfDHcd/FG5GbcV2KwMd8ykiNn5wykcIhdHvFHJ9eexyHUOlTye+Jny9SVYL4FUaGbmM+FnX0dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7209



>>  static void init_backing_page(void *backing_page)
>>  {
>> +	u32 hv_apic_id;
>> +	u32 apic_id;
>>  	u32 val;
>>  	int i;
>>  
>> @@ -220,6 +223,13 @@ static void init_backing_page(void *backing_page)
>>  
>>  	val = read_msr_from_hv(APIC_LDR);
>>  	set_reg(backing_page, APIC_LDR, val);
>> +
>> +	/* Read APIC ID from Extended Topology Enumeration CPUID */
>> +	apic_id = cpuid_edx(0x0000000b);
>> +	hv_apic_id = read_msr_from_hv(APIC_ID);
>> +	WARN_ONCE(hv_apic_id != apic_id, "Inconsistent APIC_ID values: %d (cpuid), %d (msr)",
>> +			apic_id, hv_apic_id);
>> +	set_reg(backing_page, APIC_ID, apic_id);
>>  }
>>  
> With this warning that hv_apic_id and apic_id  is different, do you still want to set_reg after that? If so, wonder why we have this warning?
> 

"apic_id" as read from cpuid is the source of truth for guest and is the one
guest would be  using for its interrupt/IPI flow.

Guest IPI flow does below:

1. Source vCPU updates the IRR bit in the destination vCPU's backing page.
2. Source vCPU takes an Automatic Exit to hv by doing ICR wrmsr operation.
   The destination APIC ID in ICR write data contains "apic_id".
3. Hv uses "apic_id" to either kick the corresponding destination vCPU (
   if not running) or write to AVIC doorbell to notify the running
   destination vCPU about the new interrupt.

Given that in step 3, hv uses "apic_id" (provided by guest) to find the
corresponding vCPU information, "apic_id" and "hv_apic_id" need to match.
Mismatch is not considered as a fatal event for guest (snp_abort() is not
triggered) and a warning is raise, as even if hv fails to kick or notify
the target vCPU, the IPI (though delayed) will get handled the next time
target vCPU vmrun happens.

I will include this information in commit message and change WARN_ONCE() to
pr_warn() (while at it, will change the format specifiers from %d to %u).


- Neeraj





