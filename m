Return-Path: <kvm+bounces-59991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D130FBD77C4
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 07:49:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 96FEC4EF70F
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 05:49:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB7DB29B204;
	Tue, 14 Oct 2025 05:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2bg1I47M"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012069.outbound.protection.outlook.com [52.101.48.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483DD219E8;
	Tue, 14 Oct 2025 05:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760420982; cv=fail; b=jQogt0lNn6XXzS5uwsigTkYD6d3rItsFp1GtkdUhNdJZFI4yFw6fYxFnUVHjH4/RC1jGCiyrLt3hBbHsrCO48QubYbv+zXo4kGyDKDGWKD0i4um4NAsayt7agXmckPPH7MrzF2vDkn/nj946f8S8MykMNLbnBhW+BV4a50kEZ2A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760420982; c=relaxed/simple;
	bh=Z60gpo/Z+mR3iNBXHdxr40NQSbkou1nN6ZsiXylnuco=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nleLAKNmPy+GXpJ57VvJcVWWsqBRuB9MfRoobZ1QYnLGNiy4IkhXDV0mraFBHEnNwjzkL2yict0/8WJxvpZGZzq84Fd3/C85fpe4J515gL42FFNhEO0OZO//qSFxsCEe1p/CWGGGbibzhk/RhhOhBgqCAa3JbAKHYkSfk8Q5laQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2bg1I47M; arc=fail smtp.client-ip=52.101.48.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pj4f5/srWRtF8S2pspnmRbjJ2aelLk37ZrY1qyfBSunm9mIQwUwPiM2ERVQ2gCrDapC7UTMquGXdvhJCrdlTY+QV4VtLBugGjwZ5IG7WY1cBrIqjm67qQ4LZ5F6j0+ylI9rrz/+kzS0kiwcn1KGLu3qXGqk6B1zYYi31ZsIVfu/ZwPzccs9f9r7uRzeZ9eG/1BJXx6cMOh8EpRcfD1rsK9IDaMczqLtaKLt1T7jBflIhg6BfwTzChHhRZV7UDUFYvRDHl427tl+dTqvbiPSdCADfAgaSia07v28UlCqru6bhROUOL1F7ncArzvhOr5z9wNkd0sScw2mMOWgctgfxIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3N/n9nSsijsOSWseBTuv/zoKfgck9vVC6lH0ZAy/bZk=;
 b=i20wvllld5gPyToX8stRvWZNDeiMlyOfRL275oEFJdqLz8k2bo4QvNnLFTAr8GHQkMmyoRYzesiboRXI8hVqx9ZMClHa2rfYVbt4f48cw20xtudKQ/FGmi7bqHzOOP7HNT7dMTycF48D8AdR0NxPCI6d/+2GG8MEvv6XRKi8BZrBut8+ERN9XSuRbnfJWt5rT3CovAhCHjak+fr4e+G9Jpce06nsPmRx8BuUhvic+ga2VJbe/ZtCh+fhFdhc+tcj8W6NaIPpviIYUtO+bo3O5/rRHEzvxMibboAP8u+Qd4pJHdMJdIpn9ztS4wAb0yII7UCibkVSx1BF5KUTUi1NiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3N/n9nSsijsOSWseBTuv/zoKfgck9vVC6lH0ZAy/bZk=;
 b=2bg1I47M8G1bJJ33AlhxaSgTBLAQJBvh90AOVduVnGuf31pao6XbO+xw+qKvG7yYW50AkPYorsl8BcHox8WuN5or4Kt+tfPx6RMFE02pfdJ/wTFSUjm3eCzLM+l9HF7MLLyOPk9ty9auu0knnB2Y4kVdrh90Kt9Qw5+NAUU7Vsg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PR12MB8301.namprd12.prod.outlook.com (2603:10b6:208:40b::13)
 by SA3PR12MB7783.namprd12.prod.outlook.com (2603:10b6:806:314::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Tue, 14 Oct
 2025 05:49:38 +0000
Received: from IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823]) by IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823%4]) with mapi id 15.20.9228.009; Tue, 14 Oct 2025
 05:49:37 +0000
Message-ID: <528d8293-a1a0-4d4f-87a6-e06eff7c559a@amd.com>
Date: Tue, 14 Oct 2025 11:19:30 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 kvm-x86/gmem 1/2] KVM: guest_memfd: move
 kvm_gmem_get_index() and use in kvm_gmem_prepare_folio()
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, david@redhat.com, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20251012071607.17646-1-shivankg@amd.com>
 <aO0G9Ycu_SlISBih@google.com> <aO1CGlKGso4LLtS5@google.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <aO1CGlKGso4LLtS5@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0094.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:2af::7) To CH3PR12MB8283.namprd12.prod.outlook.com
 (2603:10b6:610:12a::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8301:EE_|SA3PR12MB7783:EE_
X-MS-Office365-Filtering-Correlation-Id: 62f0a8ac-f02d-4c41-a4d8-08de0ae575a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V0YwbitpTytFeWdIYUtvTUhKZkNRMGNaYXBJUDE5WFg3R0x0RDZIOVB3MmRO?=
 =?utf-8?B?UHJYUE50Wk82b0FUNHZSTEZadXVObmVYQVU2Wjg2WE5ocVo5aFQvYjZlb0Ev?=
 =?utf-8?B?UkRvd2diYmVIR0w3N1didUhHdzV2N3J5MEtVdnFMU1FhR2ltLy9WUE10dE4z?=
 =?utf-8?B?SkI5Vjg0NmdOK3VOWmpvWTZ4d043UUpNY3p0aEV6TElBbDdHWm05dDBtSWYv?=
 =?utf-8?B?QnY2ckdDSEVKVk40N3ZlalFCVUMvZlp1bXlDYVJ0VHE0aWgzRHFKSkFkYmZW?=
 =?utf-8?B?M2JvZW1EZnRMZjRuRnd4S3d2YjZCZGdOeFBIbmp3Y2tTbHhsZGwwTDNBZi8z?=
 =?utf-8?B?QWtUci9Ka1RiV1BhN1lyaWhib2xKME83ck4xcmpYMzVQTHhMNVFDeGRXN0c0?=
 =?utf-8?B?ajFiM1J6cFZXeS8vUW00MSttV1NjeEtXbUNaMFVySHlja05sWndEVFFUUGJ4?=
 =?utf-8?B?eXJWa2pxdEhTZFN1aklzR3lKL0ZyTnRncy9UVmJINm1idVVtemw2bFI1Q1pV?=
 =?utf-8?B?TEF1WngySmE3b3Q2NEZZLzY1aHpUZXA0elh1NW05SWljR2VETER1ZGEwWVlx?=
 =?utf-8?B?bGw1elI3UjhOQmlHcFEraE5rN3EzMXloY1V1Nm1hU1owMzZIajJZb25zZ09y?=
 =?utf-8?B?VlEwZnRWY1Nkc0RmUHE1dlRnY1J4U3lPNmtLZE40Qk1rYm5mVGxWYjdTdEUx?=
 =?utf-8?B?em90aTBVdW8zSzFVRWxscU5LUlJ6QTNqdjROQ1B0a0FDQnNZMjV0T2RRSVJV?=
 =?utf-8?B?MnloT2hyQmRRTmtieDZqWFNXYWE3K2Y0b2YyUDZRUmJpNWxUMTAxMmxFc0Vs?=
 =?utf-8?B?dWhDdHQ2aWlQM2FhYk8xMTFWamtMWGl3Q2pmUDBNQU1oaVREQ0s0QjJSbnhR?=
 =?utf-8?B?Q1hPUWpjYk03V09VN1FLek9veFREZTNZZ2Z3cy9KWXBmYzhDQTk1b3hGV2sr?=
 =?utf-8?B?aGJTbWsrVEo5VjFqTVI1VlU4RG9vaTliT1E0MjZOTjJ0Q3I2N0xZZ3ZJamgz?=
 =?utf-8?B?SjRZazROMnJuWWVkL2VSdFF6STUxOVhkb3p4TU12WG1nWk9XT1hKUGtXWGRw?=
 =?utf-8?B?dmhQOXNDbU9TV1Z6b0VMYWErR1VWNVBHcTl1a3ZpSXpPanhlVGNSVDBJZmpv?=
 =?utf-8?B?YVFjTTllRkpkem5QTTUzRVJLa1kwVlJLQU12MjhEUUh2L2tjeklIOEx0NEpB?=
 =?utf-8?B?Zk1BZ0hITzRvakl6dXd6dmxkMEVlYUxJMVQ2U01KMHJjdGZJdUI0NzFhRTJ4?=
 =?utf-8?B?UFlHMWhCd2ZIZDBtVURHK0FkZGtPVXU0MHQ4bHIvNUROWGZYTlUyTkFta3Rx?=
 =?utf-8?B?MjRWZWpYM1g2WE1RYUxhQzVDakoyMDladUVRSTRqdGh0VWNhR2V4bW1OWnhO?=
 =?utf-8?B?L2ZlRkJEWDZTQXZaYW9YKzV1U1QxRUtCYlZBZ0pHY3lXamFOMWJCOU1wRXhG?=
 =?utf-8?B?UWQ3UlVnN1dGN1laK3BKeWx3ZHIxNElCVmZMVkkySVBraiszZjVlSHFLeWpn?=
 =?utf-8?B?OHBKbVhWMVhKb2J0QUd4OHNzeUw5TVJLVWttcWdxbkRSTGlvRDFMQ0wxMDhU?=
 =?utf-8?B?cG9hc1dQSlQ1a2c2RitTaUtvVEwwRkZQeXhKMkZYbWJYS0J5SHAwRytaTU5Q?=
 =?utf-8?B?SnRLZkxZZk1IcEU2b25zelBMaXdCNmt1UlEzdmtMWVUvc3RtbGlYdTBzN3d3?=
 =?utf-8?B?VUZFbm9qVnh1TGIyOWhDSStNcWc0NDl4bkM3dUh4RXRsd3BaUU51dTRjZm52?=
 =?utf-8?B?NWo3VHRBMUwzd2xoeWdKdXBXbDZJbjcwb05kYzM4RDZ1eVg0MGlzR05rUW8x?=
 =?utf-8?B?Y2ltQmYrdHJWYkZBTlhScWo0eGRGa00reFpMakRRUFJkaTc5UFpiRjNlRE1Q?=
 =?utf-8?B?N3lVdXVPZTdPaWp0SzJCVkpjVU42SWFRWU5KT0tpQk03MG5ZcWZkUDlMd2w4?=
 =?utf-8?Q?iS1Dry06uK9kcl0HsVpIgW939E9+8JXC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8301.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N0NmS1piYlhwQUxjOVVHcFBZa3pobXh6MGx1S09VNUNlRksyY2NUTmpkME9m?=
 =?utf-8?B?ZDdWdnFtd3BtdCtsK3pvNm9FcW9IK1N4eDVsMEt5cHRVL2ZWU0ZNNEFIbGc3?=
 =?utf-8?B?VnNVUzBuSlFJeUFpYnI4SGQ5ZGZqbk1RUGh4L3cvQmI1eVl2bWl5WXNqL2ln?=
 =?utf-8?B?WVNIV0poYVU3Mnl5NGhDNkRtbXhKQ0JZcExadEV1L21ubmdSMVdwQ2NySDNJ?=
 =?utf-8?B?ZzJZUThrdUlWaFhuM2JVYUhLUFZMdTVHNlpxVWNnbW5BZm5kMFNRVXVRWUpX?=
 =?utf-8?B?L1NNUGJhQ1dvV1U4cFU4cUJFUWw2MkJ4M3lYNWduYjl4WC8yek10SERNS24y?=
 =?utf-8?B?K1ZuSFdEK1NCNlcyMjdyK2RrWmNSLzAydGxLWjZ4c1pidkpnK2lwTTZHbmlu?=
 =?utf-8?B?T3FvNjFmcFpFUHJiVUNjWnNCaDNSSzcwQzdmNGdQWVNQQmh0SVBFRWhDUER3?=
 =?utf-8?B?NWg2dzZxeW1yQTQ2WVd2RSt0aGE5VlpqUnpxdi8vZnFwY3kvR25QM3BJL3A2?=
 =?utf-8?B?ZHN1Y2tvUjZZZUVDWkdBWnFOemN5SFdtUnF0UDZReGtiekxrbmJ2Y0pRdkE0?=
 =?utf-8?B?aTJyZFdCQUQvV25DMUpOT1ZvNXBMZ3NGUzVjdktlaVd6ZjJIejJNdFFuNTZz?=
 =?utf-8?B?OWhvMlFzaTE2cWUyREh3MTVQZWxFaDE1MjhaRU41c1l6ajNsKzNJZmhubHZl?=
 =?utf-8?B?K0ZoMFVGY3ZCQnBGRGRFVzdlS0EzMU5uMS8xYzRHRFZxUjNpY0NIWm9UNE55?=
 =?utf-8?B?M09xc3pZUGRPQjBLVk5iblM3S2E1OXI2N1B4R1Vnam90VWxCK2UxS2owVE5t?=
 =?utf-8?B?MkpJUHE3ZWZVazJvSVFJZkJUUFpZWjE5T2FRcmdTWWV3ZWs4bCtDemxrdG5G?=
 =?utf-8?B?S0lvanJLNHo4aU1ERjVCa1FzbXFtNzdGWE80eHpKaVhsdVJGb3UzZmV6YlE0?=
 =?utf-8?B?QTNpWjZGMTZMelN5SFlPQjVXSVYxNjZlbnVsN0NiZTVmTUY3d3o1clFwVThH?=
 =?utf-8?B?RjE4TzhPTU42N0JlR1FkU3VCczhUbk5LSlJObjdGQ1ozTHlkV0MxazNPUVRy?=
 =?utf-8?B?QVRobmpEZWJML2ZxWFZlRVNWdTJ4SngrTlhhYXN0QndtcHJObHJxendPYnZK?=
 =?utf-8?B?K2x6MFQ2cDJpK0dleWc5NVAxZXJIbXQwbnREOWNZV1BoRmJESG9mRW5SMG9z?=
 =?utf-8?B?ditvNCtkRkNGNSt3L29XUHNJcXVmWTdXNitmaVhVaEhHK2MzTTVMQ1NrZTJK?=
 =?utf-8?B?NUpBUTVERU9ac1FWWHF3eWthK0xPWkdYc0wvYXp6V1FhTDE1WFVVeDg5UUNW?=
 =?utf-8?B?UnlPR0c3Vk1SM0ZTQkt3cGV6TXhCMW15L2hOQ0ljSnpCRU92ZWtyYSszdjBP?=
 =?utf-8?B?NnppbXhCRXB6U1JuS3QyV1hBSHVEbUkxeGpJeUtBckU0cG9LMTFDQWlzaER3?=
 =?utf-8?B?eUs2WElYZ2tRWHlDVlp5eFBmWXNLWVB0aEV3OGMxN0ZUOWVXYTliTjl5elB4?=
 =?utf-8?B?NEVXdk15TmU0TmJmWnh6dUFWZWJsaU0vTEdZZU1MTTBIQzl6SHZBbGpuWWlk?=
 =?utf-8?B?MzZPVmg2UDRhVHhoWkNGbllNaEQwV1BKcHhFSWROTFd1aEppOW5oUkxsNFN2?=
 =?utf-8?B?K21jT2E0aGF6bkoySzJwQUpGcFIyMHhJTi82OVY2VFM3eFlxMzF4MExoVDhr?=
 =?utf-8?B?QzNiR0REUXU3ZEI2TmFHdXkwb2Z6Ym85TzlCMVR0dG9wWWdGaU9GcjZ6RjJR?=
 =?utf-8?B?Z2NIQSt2MXorRUNFMFFsN2RFTjl5aFF3a3dSZHIydmF4Sjc3KzlHUUJLOUZ0?=
 =?utf-8?B?QTJqNS9IQTQrVXZXNWNhTEtqNHlpZzJwSi9veGpHNlFyUll0YlM3RkdFSGUz?=
 =?utf-8?B?bHVycysrcXJiVXY4SWFYQk0zOXhrNXg5VjZQUHB3ei9XZGxQcDZXSnF6b1dM?=
 =?utf-8?B?YkR6ZUdTTzhYbWN6QkZDdGZPYXZkMUlWWEoyU0VmY095K0VTdzNVLzVlMXdF?=
 =?utf-8?B?NVBhOFdqbHNES1JVQ0dzL2xPM2F2dGVieGRWdTNZUFVvcllTY0J0NlZ5L2tp?=
 =?utf-8?B?OERjRmRPS3cwWUVHUVNFcXRrR3pzaklZSEpKSXpjbFhNbU1mQ2Q0SFRwczZy?=
 =?utf-8?Q?4q6UDKNisV1nwcSDh9YARhVSi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62f0a8ac-f02d-4c41-a4d8-08de0ae575a9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8283.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 05:49:37.7998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LJvjVpI1eY1On8nF4pn9AD05U7/V+TGprGphqPsHRi54dSCQ6RLEzpkAZS0522RRM11wed0LTXxT5iYm6dSEWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7783



On 10/13/2025 11:46 PM, Sean Christopherson wrote:
> On Mon, Oct 13, 2025, Sean Christopherson wrote:
>> FWIW, there's no need to put the base (target?) branch in the subject.  The
>> branch name is often incomplete information; by the time someone goes to apply
>> the patch, the branch may have changed significantly, or maybe have even been
>> deleted, e.g. I use ephemeral topic branch for kvm-x86 that get deleted once
>> their content is merge to kvm/next.
>>
>> >From Documentation/process/maintainer-kvm-x86.rst, my strong preference is that
>> contributors always use kvm-x86/next as the base branch,
> 
> Oh, right, this is a funky situation though due to kvm-x86/gmem not yet being
> folded into kvm-x86/next.  So yeah, calling out the base branch is helpful in
> that case, but providing the --base commit is still preferred (and of course,
> they don't have to be mutually exclusive).
> 
>>   Base Tree/Branch
>>   ~~~~~~~~~~~~~~~~
>>   Fixes that target the current release, a.k.a. mainline, should be based on
>>   ``git://git.kernel.org/pub/scm/virt/kvm/kvm.git master``.  Note, fixes do not
>>   automatically warrant inclusion in the current release.  There is no singular
>>   rule, but typically only fixes for bugs that are urgent, critical, and/or were
>>   introduced in the current release should target the current release.
>>   
>>   Everything else should be based on ``kvm-x86/next``, i.e. there is no need to
>>   select a specific topic branch as the base.  If there are conflicts and/or
>>   dependencies across topic branches, it is the maintainer's job to sort them
>>   out.
>>   
>>   The only exception to using ``kvm-x86/next`` as the base is if a patch/series
>>   is a multi-arch series, i.e. has non-trivial modifications to common KVM code
>>   and/or has more than superficial changes to other architectures' code.  Multi-
>>   arch patch/series should instead be based on a common, stable point in KVM's
>>   history, e.g. the release candidate upon which ``kvm-x86 next`` is based.  If
>>   you're unsure whether a patch/series is truly multi-arch, err on the side of
>>   caution and treat it as multi-arch, i.e. use a common base.
>>
>> and then use the --base option with git format-patch to capture the exact hash.
>>
>>   Git Base
>>   ~~~~~~~~
>>   If you are using git version 2.9.0 or later (Googlers, this is all of you!),
>>   use ``git format-patch`` with the ``--base`` flag to automatically include the
>>   base tree information in the generated patches.
>>   
>>   Note, ``--base=auto`` works as expected if and only if a branch's upstream is
>>   set to the base topic branch, e.g. it will do the wrong thing if your upstream
>>   is set to your personal repository for backup purposes.  An alternative "auto"
>>   solution is to derive the names of your development branches based on their
>>   KVM x86 topic, and feed that into ``--base``.  E.g. ``x86/pmu/my_branch_name``,
>>   and then write a small wrapper to extract ``pmu`` from the current branch name
>>   to yield ``--base=x/pmu``, where ``x`` is whatever name your repository uses to
>>   track the KVM x86 remote.
>>
>> My pushes to kvm-x86/next are always --force pushes (it's rebuilt like linux-next,
>> though far less frequently), but when pushing, I also push a persistent tag so
>> that the exact object for each incarnation of kvm-x86/next is reachable.  Combined
>> with --base, that makes it easy to apply a patch/series even months/years after
>> the fact (assuming I didn't screw up or forget the tag).

Thanks for the detailed explanation on --base usage. I wasn't aware of this 
flag and will use it going forward.

I see you've already merged these changes into kvm-x86/gmem. Should I resend 
these patches with kvm-x86/next and --base, or is the current version sufficient?

Thank you,
Shivank

