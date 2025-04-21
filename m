Return-Path: <kvm+bounces-43731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 55542A95874
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 23:52:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE89F188D4E6
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 21:53:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D81AF21ADB9;
	Mon, 21 Apr 2025 21:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="k2ZkQYtr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2072.outbound.protection.outlook.com [40.107.243.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A95C21A421;
	Mon, 21 Apr 2025 21:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745272313; cv=fail; b=rkAdi+NIoxPvUtpNe11etS0uvqDK+AC3TgG0CnbvzYnAXYlxUZ91wdHgo6hWA39UsKg8gBAxWNrWCzb6t1Af7wcn2/8jnQlsQt2U7CZaUhU9TGIOwFr2hmoukXX1f8y5gp1gZ4iAbNne5s96GZM7wrNVs3J3NVyFnY7YkgCZslo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745272313; c=relaxed/simple;
	bh=AgrcbNeinw3wKH2MjbkP8yUWLlKqRLxupm5x8j7smy0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FNv4XfxuGT1rKFK2PoMASev7U7CLd5DWAdAVf/u2vCMB8zPsJRxXsAgDCOjTmTdtG+p6xMkKaTKyYDdQeD5jaz3lU52p3hYaylEQ91MxgABqjEM6bwjHqwxWyb7qj7es0RHLjVwTkAPQWNIYplT3ENsMziJEGRsSaZ5YLzPzH3s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=k2ZkQYtr; arc=fail smtp.client-ip=40.107.243.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JHHik8PFuiPRB4aY1HWflX6rOSXujnQoc7ujXWjS673nhwUr2DxVdg07Ezj+8+q5jLOzq0v+2/2NIqjDTLOltEVTq/Lwgt/A5SQIg5eHg0PfA24RjgE2TZRyMtVazYM5t8q97lbI1IJTe7/Avj55V8n9gzBlDgthkBOJDGVV1lgML3/iA0qFziyMnuaSPNe5/0715YIp40iOXvv+EmmdkDmHadSP0Otf7hvyYs8iWvMPCiDEx8IFlw393TJ02SbMOGQZ8lUpOyPSCBmexE/b9qEnkzNGr7KAZuUI9wWpMJAep01e3CsDjdizxElcbtir/fj3K1UDmMfpwjxY2OFMJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p0Us1pwh+WhnPPPKTDYC5IGxIGGcZJNZvtVunNVByO0=;
 b=ve/mg0SG1Dhgs4p+/oYepFUWtgX+sJjLRK9fEgt5GW6A9yrA9wfMUqQOOuH+dA1RIUgbgGbXbYB36Bw+Vha+csy2EmLwbxQ7UrBceKc7AWKoyp6bECNvgsrnxIYpsBiJaXpw/2LHK5NC3ZzLWPxojat7CTC+uegjz1t5yBmgkpTXChAexnsz/uRi4upV/+EI2BXWn52RSJdc0zEfa3N0b80QMs8+OisNRIvt8k9IeA+IeNqvO5UYwpqLP2LiuPm3/tc+Ayf7tW3wIJu+ypLCEX60ASHYWC/2oALSZNZVJdnW/3oOPNnFhuZDgSueOPZJ9DsViz/2F2pDfFvNxLNGXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0Us1pwh+WhnPPPKTDYC5IGxIGGcZJNZvtVunNVByO0=;
 b=k2ZkQYtrSwkHH9T8YXQZYtb+EQQ5kmfGiYDfXpxPM33mfZoVPBtFnf3uQ2akm1UMA/zaEas3w+AbubRdhq4sBHGzfq8+AvxtiFA157TLebrHVX90c6k4KwIiAnvLHjPPSQOUHiPZNvIQHJ5ZyFF/ya2kzJazWPv2yAeHOjrU6SM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DM6PR12MB4203.namprd12.prod.outlook.com (2603:10b6:5:21f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Mon, 21 Apr
 2025 21:51:48 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8655.033; Mon, 21 Apr 2025
 21:51:48 +0000
Message-ID: <c65c129c-a4c7-c621-8446-521f985d0550@amd.com>
Date: Mon, 21 Apr 2025 16:51:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 12/29] KVM: share dirty ring for same vCPU id on different
 planes
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: roy.hopkins@suse.com, seanjc@google.com, ashish.kalra@amd.com,
 michael.roth@amd.com, jroedel@suse.de, nsaenz@amazon.com, anelkz@amazon.de,
 James.Bottomley@HansenPartnership.com
References: <20250401161106.790710-1-pbonzini@redhat.com>
 <20250401161106.790710-13-pbonzini@redhat.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250401161106.790710-13-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P221CA0016.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::21) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DM6PR12MB4203:EE_
X-MS-Office365-Filtering-Correlation-Id: fd1fa2a6-299a-446f-5a69-08dd811eb787
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NWJhWXo1eTZscVdaTDQ0MkZPVWtFZjJ6ck5nYXFGYks0emR0NXI4THZHYzI4?=
 =?utf-8?B?WUZLcUV0d1FYMVRraVRRU3BoZlVsU3VPZ0xGL1pnREpUWU5JVGpTS21jaXFH?=
 =?utf-8?B?a1R6aDdQTm8wSks5cVZmZTlxYjBzQkpGeENEQklMMXkwRjNEYnl2aTh3QVly?=
 =?utf-8?B?N3d2MHA3RHNwaEpHdUVlL285RkEzVTBGU1F4YTFxZXRqYXcxM0h1RGVtMEY2?=
 =?utf-8?B?ZW9JSnNGa2o1RjRKSWFSdEtSODlTdFh5YWpFdEw3ZVF5OFJ2VkczZWpYOVRx?=
 =?utf-8?B?ZFhKN0loczFGMmlVTkcvOUdNZHlveVJKWHlOWVNUN29jVEZCdnFSS1g3Zzl6?=
 =?utf-8?B?UGVSRDlxZWFGby9vVCthMkNGTjI5c05KeW84Q1Z4dVNTSWZwVk9SQzU1Yytm?=
 =?utf-8?B?YVhwbXNVSG5PdS9Cd3pHcU10T3NqSmZVZ001N2VoYXk4R2lTcjBsZ282Y0tS?=
 =?utf-8?B?TTR4SHdGajRRREpSOFBxMHlYT2JQanQyUUtzNlRXMVpmUy9vc0k0bkNOckpv?=
 =?utf-8?B?MG15VFVDU2RVR3lOZ1J6SHVtMjhOWEYrWDAxVG80WG52SlloNll3MTdWeWRB?=
 =?utf-8?B?Y1pqR0ZUaDNCZ3pFNStzOWZORUIvZUJpeFhGa3RqWUdnMFBENm9BMTZkY21n?=
 =?utf-8?B?MEkzaDN4UGUxVlhDMUYwdy9CaUdIM2NnaEg3Sm50a21rRFU1NjhJTGZqdnpH?=
 =?utf-8?B?Z1VNd09hektYTnpRT0pKU3h5aEtaK2twSWQ3NDNrUnFUUUtVL1V2RkdVT0Fh?=
 =?utf-8?B?ZXhXdUF0Q2dkN21aTkN2dU5KS0drWEZGeDI3T3dJWDlvQ0wzT2N5djdLSFFi?=
 =?utf-8?B?OHhiNm4vaWlSZ2xEN3c3VVk5dGFaa0RUSE00SXQxVzA0TkxFM3BvUVp6QVh0?=
 =?utf-8?B?OWxvUkdrblNVVEZwcUtQbUkwVllWTFB0TU54QWRhRjdVcnVNRDZRQUU5blJV?=
 =?utf-8?B?RjlMSXc2ak04Nys5SFFDVmpkZlRpdWo4c2FzUW5GMU9LQkxHOW9hQmNzd2Np?=
 =?utf-8?B?aFBGTmpOc1VYNUpDN01mZDJlL1c2ZlBkWkNkelM1LzBQbmkwaTRoYlNRcGx4?=
 =?utf-8?B?a0tpTkhpcWIwN3gvVXJKYitqaHdibXRZcWFiZVBVdkt2RGhETUgzOWNwWVRE?=
 =?utf-8?B?cENnU2xVMnlBVm1JYUlYMmNJQ094Q2dYZjJ1NURxcWJrL1RScnNVT2dEenRl?=
 =?utf-8?B?dWtMNVcxWVZDVDdXNjNUaTJ5dStPOUt0aDhwOHdoOHQ5SW13dDloNi9zRVgz?=
 =?utf-8?B?ZkMyUmZNK2ZreG1VUDRrOXM1c1o3eVlEMXJuY01yYnROME1ITmF4RVNETnRG?=
 =?utf-8?B?d1hBd1ZMQnRxRmpxMEJOTlpHLzFjU1E3MXlMM1N3UTF6bHNWdG42VGtZY3Nz?=
 =?utf-8?B?OVdEOGg5ZFdEVlpQcXhiSVNqQ3YyN1I2NDNCaEh1aHlDWHphWEZXekhEeStS?=
 =?utf-8?B?YjV2Tld6cDlUU3FBUExmek1OcStUdlRSbjcxQllsWTBvOTBIQXhGdXZRaHQ5?=
 =?utf-8?B?SGZrcHJ5em1RMjNwbHhKY043Z1ozT2pHYXB1ME5lZnM4RkJUWlRKK3M2TXFr?=
 =?utf-8?B?b2ErMzRUTk9ENTVmL0F0VC9IWUdHZzdxczFVbHI5OXYyWUJ1bi9ZUW9oQ1Zu?=
 =?utf-8?B?T29JOGVuTkt5WVpZNTNIU3hDMUtZU004ZlZ1a01aMFZ0N3ZrZlRLMkJyQnNP?=
 =?utf-8?B?dnltdnlENjFGVUt4UFdiRC9jSkY2cFJCaitzSjNXeVNSVlNNa05JaWF4TzFk?=
 =?utf-8?B?RWVXeWV6Q1lLeUhoaWJqOWkrUGx1RCtKYmRjV216alVOT3E5bDNlRGNLRml6?=
 =?utf-8?B?UWI0cGptR0p0dUo1c3BzMVNHTit4UEs5clhOckFXb0szR1ZqQkpvLzgrNnpj?=
 =?utf-8?B?TEc1MmJxei9qeVVkRzVxeGg3OG5uWHk4bC9ORHo0UEtZamdjK3VGcm1aVUZv?=
 =?utf-8?Q?KlDiB24s9c0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VXAyUG4rUi9NTnY2amYrVEdGeU15d0lBU3JRcFlrM3dQUHRQdXpzaVQySjk1?=
 =?utf-8?B?VkJNY2g5M2NyclV2ZkZkVGtBYnRteDRtZXRBcDdrNlBSSFVabkh2WVgzK2l6?=
 =?utf-8?B?cDNDYnZPZHIzYnF1YjZFUDBVK3pxMzhxRnZaVm1FejF6MWJFYXI0b2lLcG5Y?=
 =?utf-8?B?SnVhNWV6L3lOVFJqUG5SRFNvLzFVbFdaWkd6UkNkR2diZzlST2JTZmlZZ2R3?=
 =?utf-8?B?a1VXcEU2QlRFc252NGlFSE9aWGsrL0ZJc1Z5U292Nm1DTDg4MFhFdjZKVGVP?=
 =?utf-8?B?cGhPMCtvSFVxZTRyRnIxVDlMaU96NG9QTVV2eEloOU01OFNZVit3Q2tSVnBr?=
 =?utf-8?B?Uks1dmZrbXlCQ0EvMEtJNDhHV3pCK2l0MWpUeXdlSFpCUmNBbWViUWVxQWM5?=
 =?utf-8?B?ZmU4OFhJdW85WENHVXZ6c0lhUlZFMlp6WlVlOWpuLzRDMUZhRGVhSW14cnE2?=
 =?utf-8?B?L3NKZWxxRFdWNmRCOFFGTndDb0N5R0RhTll2bEpNeHJSaXpOd0NFMjJPQWZt?=
 =?utf-8?B?N2FOcDE1MjM3bitRVnp5cUMyM0txRHAzcHowZjI0eGIzdVVldFhVZjVJeWxW?=
 =?utf-8?B?T2d0ajRmNmxVTU1NREVEenZPUldvbFJJekhSdnNpNUpsVFhIMWt2MTFzdTho?=
 =?utf-8?B?OE1FUzBiVU1nMGN4WkRobXEybVZPVVYzMUY0RERQcGxoV3lENzZLY2FaZ2d2?=
 =?utf-8?B?Mm5HU3pXREpYeGNMQS9FK0NiNi9jMnowN0poZll6QkxiVnBSRFM5VmlTYVFB?=
 =?utf-8?B?a1NPNkJPeThhQmVBRzlBbWhqSkI2c3N4UDhHdFdtWXV6Nkt4MEtKZ3F0TEsz?=
 =?utf-8?B?SVk5dERiM3VvZ2MySWxTUG5MOEdERjhRbS9Kb0pOa2pwRFozRUNKd3p2emc5?=
 =?utf-8?B?STdNOU1ZM3l2d25lcXdDU0dIeXZ2NGRnRW00ZzExckxLOWl4VnhNdTdWaE05?=
 =?utf-8?B?ZDlmVUYrTFcxVXQvTURnMWtibktxaFA5WDhzOXBPbmF4Q0dJNUp0c2Q5NHJ6?=
 =?utf-8?B?SVZqWmNFYklnKy9rTzR6Tmw4OC8ydTFQQkRXNnFSaURBamdIT09yV3k4ajBP?=
 =?utf-8?B?WDFoYzNUT1hpemw5T0xFdmFnTk9ydjB4VlhuZy90NVFjVjZzaXV0dDUxdHJY?=
 =?utf-8?B?SWpLZUNJM1QxM2l0U3hSSitvWWpTK1JZZ2Y4Y0VMYjZodzc5M2pRaWsvbUho?=
 =?utf-8?B?ZjZDd3BzNWZlT3BEbjlncGRTQlRhZ2RhTDJ6RlNTRkxRNDRjUWNiVUxUa1Mw?=
 =?utf-8?B?dnB4dGw1VXpXT2hMb1MzdmxzV21pV0xHK2N5blozL2ZZTlA4ZXR0aXVQaFQr?=
 =?utf-8?B?bVlMaGJ3NlBJWUhSM1duMG9KV1QzWGJzVHBzSm9JRjhyaFZXZERLSkR3enNs?=
 =?utf-8?B?Z28xamF6VHhLaUl6UlFHbklpenFUb1RPUStIaUdqeGNqV0YxT0RoZWxsWVJP?=
 =?utf-8?B?UmVLemIva3UvWjlZd256K2hQSGxMSkZOejJYM01nY0t3R3hlT1U2eXEzcjhF?=
 =?utf-8?B?SWpJWTV6ekJheUQ3L3lhUmRtb0E1MjZ1LzRXV2xtenQ5cEU2ZWZIb0lTZjZp?=
 =?utf-8?B?MVR2Wi9vS1BOSzZBemxHaVpCNWpvZjFqemE4aCtDVlNxaFdsc0M3dkZ3WnZM?=
 =?utf-8?B?OEVnZnBrQ2hhbkdDc2RCbHNtMk1MNzdubjlYVVE3bEpsQlNRTUFrckhUWVJh?=
 =?utf-8?B?ZlBOU3dJRm1VNm01b296Q2lHK0tYMlJpTU56SVVwUTd6VDM2aVFGSnlwNVdZ?=
 =?utf-8?B?YW1WRUN5YUpZTmQ0b2V4dmpWTWdSU2tRM2J1TlJsbTlxVFN2dGlmSnZ3TWdu?=
 =?utf-8?B?U0kwcG12VlEyaVllc3NCVTE1RVBxYVltNGJDYW0zeDVyNGhLSmp1Uk5WWFhm?=
 =?utf-8?B?UzhYQzhzNjk0cTVTajAvTnRxRmQ0OEpFV0xFT1FBUE90anFmYUJGeFlPZ093?=
 =?utf-8?B?SGJ2eUlCTU8rUi84SmZCdmtLMVBDTFl0dXdhQUM2RTU5enErRVdYQmpHRURY?=
 =?utf-8?B?R0o0Y01JcDNJK3dvMmZzRDFSTmVOZ1NNNWlma2IxWGd5bDlUc040ejZVRXhB?=
 =?utf-8?B?MjFjVTZmWkxNTGdYNUlQYzVGY0xrbWJWdkNyUlZSTmRyeTVkT01sSDM3UDRK?=
 =?utf-8?Q?yv+RlyxtvrPCOsuJGVaFwkViG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd1fa2a6-299a-446f-5a69-08dd811eb787
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2025 21:51:48.5714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BXNJlZKYU7N8dvPwywejyNrcpDZb2wnsHelYaFK7upVxaK5UIGNdEoUmyOf6vI1NpWEkaCodChqSZki6NqYJoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4203

On 4/1/25 11:10, Paolo Bonzini wrote:
> The dirty page ring is read by mmap()-ing the vCPU file descriptor,
> which is only possible for plane 0.  This is not a problem because it
> is only filled by KVM_RUN which takes the plane-0 vCPU mutex, and it is
> therefore possible to share it for vCPUs that have the same id but are
> on different planes.  (TODO: double check).
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  include/linux/kvm_host.h |  6 ++++--
>  virt/kvm/dirty_ring.c    |  5 +++--
>  virt/kvm/kvm_main.c      | 10 +++++-----
>  3 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d2e0c0e8ff17..b511aed2de8e 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -394,9 +394,11 @@ struct kvm_vcpu {
>  	bool scheduled_out;
>  	struct kvm_vcpu_arch arch;
>  	struct kvm_vcpu_stat *stat;
> -	struct kvm_vcpu_stat __stat;
>  	char stats_id[KVM_STATS_NAME_SIZE];
> -	struct kvm_dirty_ring dirty_ring;
> +	struct kvm_dirty_ring *dirty_ring;

Looks like the setting of dirty_ring is missing in the patch.

Thanks,
Tom

> +
> +	struct kvm_vcpu_stat __stat;

