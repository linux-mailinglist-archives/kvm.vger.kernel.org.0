Return-Path: <kvm+bounces-59805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 05729BCFA68
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 20:05:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C8FF18999DE
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 18:05:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3C8F27FD48;
	Sat, 11 Oct 2025 18:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AlLyFKur"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011045.outbound.protection.outlook.com [52.101.62.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0186A2AD0D;
	Sat, 11 Oct 2025 18:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760205888; cv=fail; b=cgVZ/DvXGSCXuLbtN9hmtAa8pTf5uEIWNWf+/0pGQisbNoA2HSmuTk83obxoj/B8Pe3eU63GZCkzX9aaKVFWk/GqHnRQwTzrk/zd/eU6mY79WP0MPkFAKMnkIfSFVYO48l+/ltbRHq2zMbamFfs11kOWZ9SMuUpOcGYTYjFaYQc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760205888; c=relaxed/simple;
	bh=I0qoBnCC68GvLd2unx9uJoRrgoJEdiZp62ZVHoX/rAY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IFHJYNFOv9P0Ykt4yaxEIiYEymCNcPbrC/bWrz/JRIh8TeZvd9kV/nG8Mf83z9txW7tpgTF8OtupICJaDd401E3Ek/P7y8xrmS571XOcJStcSF87TbucErWnls06nfSd32UHfRbGjiQIq0vr2BincBFT6QdUTWLCxlOsSwaXJlA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AlLyFKur; arc=fail smtp.client-ip=52.101.62.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T4y+1o3TBeL1+WkXjeRSWnZYbmjo51xoWAIrdWguZ9n01vKGSGzZ7EeS++73HwtV4trhwjsTn/FUIv+sDQnOdHDC1xpV9EGxmrM9/HViDNFMPWH3quJHG+Q8Gqpe+IJs2SdhP7/ilGzwMtOObyhNhMsPpATCf7RNnzY31NyKECwryAgGwDwlSFnmqXqZncYYC3fKwkP20tMKSX8X/f48790ew6j5SLbmeKY6MGWFfCha5flkr0InvrwekrkeRwmsAdliCwPaIyt0L2DNYSIfuM8KpMlWtMOUzXjb02Mi7tAl/e2j+Cz1PPUBgYnq28I0ENNxnUbBLbvgu5+9hBhiaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z9ujf9zl02XPCLvrdJMvpgXS3dPvRBPt6sU46BWRWp0=;
 b=goAOrFkImp6+VlidCvo8GVZok/L/+2ETHsJpC3qu36B7lVoaUDOuAwLg3HhJNwpZZemA0hZSo9ROyXWAhIqIqLlDhhkWFKaQ8GwEwLHPy5Q6BKPexle0h2qfSxC3ij/SWquvWaENDfqTTwxNFc1S3lXnNmmHu10Z3AJJXEkEaAJqnKS4+oxWr1mJgazZC4YnLQ+SGN1N9T3OhIzw0XBoBxgX3FujE9qwKBFUiBSUBgNGhgnA2EuNO4ZOHzClhTwb9ktcwa0QoxvYsOK5AsbnsalZeFm0IW5XZn2EeEaEsXUEd56SqLYvQXcB2uSwF0EIN3Hf91A0tWV981xbVRF+NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z9ujf9zl02XPCLvrdJMvpgXS3dPvRBPt6sU46BWRWp0=;
 b=AlLyFKurk82TV2MolgDh3TSvUWKNU0jk9QOYiAvwQrpuYrqTbJF1PWvhA6mDaRYJiuts3pdOMMbqhVKhRGSmbZkcnQYDLP95d9yoVldxg63hDhX3GjibOUZmOB455SMuLqcc6ARm3kt94dDM2j5CDz5FlsQn6uknuegnQlzFYGs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PR12MB8301.namprd12.prod.outlook.com (2603:10b6:208:40b::13)
 by CY5PR12MB6551.namprd12.prod.outlook.com (2603:10b6:930:41::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.11; Sat, 11 Oct
 2025 18:04:44 +0000
Received: from IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823]) by IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823%4]) with mapi id 15.20.9203.009; Sat, 11 Oct 2025
 18:04:44 +0000
Message-ID: <57e1b0de-00d4-4137-a56b-5135ece6736e@amd.com>
Date: Sat, 11 Oct 2025 23:34:36 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 kvm-next] KVM: guest_memfd: use kvm_gmem_get_index() in
 more places and smaller cleanups
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, david@redhat.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev
References: <20250902080307.153171-2-shivankg@amd.com>
 <aOlCBEw1DpdLlWA1@google.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <aOlCBEw1DpdLlWA1@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR01CA0155.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:68::25) To IA0PR12MB8301.namprd12.prod.outlook.com
 (2603:10b6:208:40b::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8301:EE_|CY5PR12MB6551:EE_
X-MS-Office365-Filtering-Correlation-Id: a2099eb4-e157-4887-094d-08de08f0a7ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OS9LV0d1cWsxcnJsb3pHNFNQK3ltaWxWQ283RmJzQUc1a3ZvRjJDWlE0RmlY?=
 =?utf-8?B?aG9zanVPL010K1V3Y2RWaEtUL0k3Qk5iV1ZuM0R1M2RxWUMrdnZZcURQYVNY?=
 =?utf-8?B?ZDBlWXc3RWNzWm5KTVZRVXNDVnE1bjYrbHdxeUZteFdiQ25ZQWhkaUV0elVz?=
 =?utf-8?B?OFZhQzJTRklHV3FQVFhyR0k2UFNoOGgrT0Y4MW0zU09qWXhoV1l2QzRnclZv?=
 =?utf-8?B?VW5kamV4MHl4L1Q0RlZVM21PZkdqQUl5ZXlZaGdieVJWWjdvYVBHaFNuemlS?=
 =?utf-8?B?Ry8xS1RCdjBCMTJScGVqTzFGTFBoOWkzY2tjazI0SUkra09QTVJWN0VtcWNR?=
 =?utf-8?B?Y2RYOGlDb1lJc3BHZFlEajRndDJXTnRoc0laNU1xb3dFVE9MaGdzMVphdHpm?=
 =?utf-8?B?SG1PM3BVOTlVTVhzMWkrNCtzR3lhaEptK1FFTnVjdWFKOHRoejErQXVEVTR6?=
 =?utf-8?B?Z1hWcWk0RG5GY05JSThqT3R6N29nTmpML213UXpGbnpzbklieDV6NUpUNnI1?=
 =?utf-8?B?WDROVWNlVmIzVUZHcy95aUQ1WUdacjlkeS9hNUhNRjJnRzI4bU9BQjVKTXg0?=
 =?utf-8?B?eFJsZXRyWHYzVC9ZS3hGVnJSNW1ndzZPYzJoOVltMEg1TnJEWlVMYnJjRDgx?=
 =?utf-8?B?RHBuYnZNSHQrWVJ5K01rR08zY25SYVcySFpnWGZzV1JkOXBqMHMwM25oQTlx?=
 =?utf-8?B?TzhsWmxSNGhGQnhpWUFuellzQ20zekwyZi8yWHhnRHdLRnlqeWN3SE4yWmo2?=
 =?utf-8?B?MWJ6WTlmclZScTJoT1lxbEhsczBuVzY4UzVQcmliNVBGaktHUGVHK1Z4VlJ5?=
 =?utf-8?B?SEZtUUFMZGRvSnFka0tiWUEvRmZDcDhHajRRMnZTTE1NVm1YNkRJS2t1YXBD?=
 =?utf-8?B?Z2VXZUJuSmc2V01xNEV5bjYvQ1daODFwNHI3dldHbVpSblJVL05rYWV2Y0tp?=
 =?utf-8?B?dng5TTQ3blptclNxd3NhamJQQm9remgwMEE3MkoxM0VrSVNlSExGVVBKamV2?=
 =?utf-8?B?ZGpZTHpSSnlvMk45TWNkbzY3YW1tREZSNHVKeTJEc1lyVFlNdUUyNVd1L1cy?=
 =?utf-8?B?SkdEbmVacGc1WjQzbmwxRDlzWk9XSklBWkUzNm5MTFlCejJqWFdyMUNDK0R6?=
 =?utf-8?B?VDhSRzJuVHBLcldyT3Y0cE1MZXF0WlFJK3dJTnRrTkdiN1FwcEo4ZHIydlR2?=
 =?utf-8?B?NllLUWtYL0xsVUFLSVZaVXBvZWJGOHVWQU0xSDBQZjFzUzdzOUEwWnVRdkx4?=
 =?utf-8?B?cjQ5bHh6a05QVTkvaEoyMSt2NjhwNmtoczdMbUt5dWxXMGJzVHl0dUNsWUJs?=
 =?utf-8?B?d0xTWnZ6bkdtVkFRdHdJQ2FCNFlXR2wvdW5pdFJQK0srVk5OYTk1dXRISUNz?=
 =?utf-8?B?N1JzY2xxVnRBbEUvcHh5cWxLRHdRT2pxRld4cWQxMWtFZmlDOGVBNmtNR3pB?=
 =?utf-8?B?bE1yMmNsak9OQ2xtdkV5T2NpNFBMOTB0QkhIeEo0a1FheGVMUUdOYnZXd0wx?=
 =?utf-8?B?V2pydFJWbGhoQ1p4amw1c2RvS2RGQmxyYmJiTzNnQS9UTzI3cTdIaFFzcDlZ?=
 =?utf-8?B?em1uNXFwWUVVdEU0aVkzYlpGdWJyYnM3emRCOTg3c0xXWVIwTUR0R3Bra1hy?=
 =?utf-8?B?b092MzhoOFJlY3ZvWTlnODhreVZqZ1JIWjFZMmJhM3d6cSsxZnlFNWF0L1FH?=
 =?utf-8?B?QjFJWHZNZ01VblpKQlR2K2ROMmtGYXJrOWMxcStRK2w3am0xWEkwQWxYY21W?=
 =?utf-8?B?NWlhRkJoVnhkTzM5bjJ4TDJ6ZlE2L1ExVEFQSitQOFdIQjVzNnJkM09zTzRB?=
 =?utf-8?B?SGZIMzB6NmtYb1RzQVdIcE1XcXpLdG9VTWdPYXZHQlJ5MzN3cjRZVzNhbThF?=
 =?utf-8?B?NmhNTythczRaYlRadTF4cHRLVGNyWExwYjlyeDZZQ3VPRnlIMzhWZXh5b1p6?=
 =?utf-8?Q?avoB2OZd+650T9BBmP1JwgN09VGNXuYG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8301.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z0pSVlRDbzRlUlJqcGtKZjJGNkdBSlhoakdiMGZYWmVSeWdzUnJJZnVDZWV3?=
 =?utf-8?B?ZzFUeHYrUmhIZ1A3RENDU3FBZ2pVc05NblFWQVplYjZsVU5tdVNiV1BLQVdi?=
 =?utf-8?B?S1o1emcrZElHZ3RlMnNpeTUveUZ6ZklrY2pyaHRoM1E0QnkySC9Eb2UwV2tD?=
 =?utf-8?B?ZmVhWVFVRFljZXA1UnE1aUJKMVk1Y0poay9vMER5VHRtaUx5dUNIaDNuUWp4?=
 =?utf-8?B?RFhialdDRXhiZGU4L1hQUG96YTZNczdEY0dWS0paQmdxckM1QTdHeXBOZEdj?=
 =?utf-8?B?NEloN2U2Z1JVWXlvUHhtZ25IMElxWTB3SXJQRGtOS2JVS0RHNUxJUUZEYXU4?=
 =?utf-8?B?VE03cUZYbEZFcnMxaGVwYUhSWFRNOUplK1gyR3hiVDhta25ZWUJHT0lTOG8x?=
 =?utf-8?B?T2pFcndPZUFuREZ1ZHBwTjErV1B2QVpHRWJwTjc2ZUphNkJHbWh4TFlRaXRn?=
 =?utf-8?B?OGZrczRUNjFsTUd3dG9NSC9jaWhHOTU5bklhUktTNFYxbDgwcHJCZ1ZuaWV1?=
 =?utf-8?B?TTVxUWszNmhtWXBYVHZ6NFBVYWZOaXh5d0RtUmdkUHR4Q2l3YzBTRUpjbnIz?=
 =?utf-8?B?dTgzblpuQnFOb3JwWFBJOVA5a3Z5c1hpa3NyNjJ3VXgvUCtja3c4VTdtZHVj?=
 =?utf-8?B?aHBOQ1I2c0NlRmhSbHM5aDZRdUFzcXUyVndpYjcyM2RmQjNHT2taemtMb0Qv?=
 =?utf-8?B?V2oxMTk0dDl6NTFxa0h2ZU9lSW01UmVqSlhwa2VndW5JbG5CVnFCN0Q4YW9F?=
 =?utf-8?B?cTBFQnU3bkFVRGpYa2x3TG9RTUNNWWp3L2N6SlFpdG5vRnBZUkFFdU9yZG9I?=
 =?utf-8?B?c0xCb24ycFVYVHAwSVM1bDYwMmtrR1B2TFRwcENtWlFiZnFqcVROWmdIdkhB?=
 =?utf-8?B?ZmpNRVFuTDdLVmJmeUxqdEV6azFKelhnMytFS09SNXUwWnFCRHhBeXNDYUc3?=
 =?utf-8?B?MDJJa3k4ZTlueTJKY0VQemFmd3pyamIzcG9qTDBkOEdWMjZWWTlONGd6cGdz?=
 =?utf-8?B?NkxuV2hlR1g1b3VFU095cS82S3V1VjV0VHBuREJUYXlBbDdseGZVcE5uc2ZM?=
 =?utf-8?B?aHFYTzBRaVgycEc3Z0JVcnZpcVAyV2hJMVp1c3FYSFUxdkxneXdYbEpjMkVl?=
 =?utf-8?B?R3k5b29lb09uYkxDSHlBdG01L3ZDQ3hnYndIcWlBZ2ZWaE9VOWtuMko0S3dJ?=
 =?utf-8?B?QXFsNzZPVkNsMzdhZGRmMHV4UjZFNHdZYUZwNVNtbjdtWExiUjJMdERNZ1VL?=
 =?utf-8?B?RXFCdC9XVjY3RitQSkRmRVZia2pjRnNMOFhmWmxPRGxkdDFvamFPSm1tS1Na?=
 =?utf-8?B?Q0hRWmVSZkRVdXdvUDhuL0JuTG9PMGViZE4zMm1OZEpWUXE0cHVkMEVtc0RC?=
 =?utf-8?B?bHdjSXl6cXFVQ2M3bTdQa1htenVHY0Ivd1Q5R1IreERGN0g1K2hqZzN6Y3Zz?=
 =?utf-8?B?ZWJSSHUwcDRaRFpEWlQ3VytPd1VSY3lHTkVoUWFSUDU2VzRnWTc3TmllTjJG?=
 =?utf-8?B?eW9qMW4zdVU2ZWswbUZHQ2NFVkwvYXd0N29NS3Riak5rY1l4Rnd3Z3JETmxm?=
 =?utf-8?B?eW1XNVlYYWlIYnZVanBWNlBQa3JPTTYxNm1pbkJlSW5PYUpXK0d5TUQvelZI?=
 =?utf-8?B?bk4xU3B4OE55d2czZW1NSW1wU3VqM25XQUprMk83UFpVemlYekl5MzNzTXZq?=
 =?utf-8?B?Vy82a3ZDZ3pGYTg3SW9udDlNUGZuYXpOdU90WURjL3JXZzVwK0FvUUMvZFZn?=
 =?utf-8?B?eUlpYWhYK2x4R2VuamN2ZThQT0IvRG5KdHpwRWxYUGVuVVlGelRaL3h2R25F?=
 =?utf-8?B?NVJ2bVdHVlBtY2RpSkN3VXNVc1RBUElKV1p0OFVqOXZTWkg2cUY2VG91alJq?=
 =?utf-8?B?Q21JMmpWRnZiVDBWL0duK2ZPaXNZK1FOUUJFSlU4Q0xPWThOSzVKamlTRjli?=
 =?utf-8?B?b3dQS0Rmc2tBbGQ0MUpiNFE2MDd4Mkk3U1hLaXEydGpYQ2VsVTVZWVFTMm5z?=
 =?utf-8?B?dFRRVkJUWHBXbytjdjdwNWlnNXRZWit5NGczQVorekF6eW1FUENpZ0czTUlw?=
 =?utf-8?B?ODNXTDI2OFdOQitJd0tJZmlJb2c1b0EyNlJxUTFmMW92ajJwL1MyM0NQZUph?=
 =?utf-8?Q?UxvpeTv/3zWLiZjkyH6pfKCeF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2099eb4-e157-4887-094d-08de08f0a7ec
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8301.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2025 18:04:44.3344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zwgYgdO1peDaDt5Y7FR3CF8eTQObeZEm1bkmKQhYjaK/e5F6p4n8rpX8KcGVM5I3MxYvh+rxsQfQDnF+6IhBsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6551



On 10/10/2025 10:57 PM, Sean Christopherson wrote:
> TL;DR: Please split this into three patches, call out the use of
> kvm_gmem_get_index() in kvm_gmem_prepare_folio, and unless someone feels strongly
> about the ULONG_MAX change, just drop it.
> 
> On Tue, Sep 02, 2025, Shivank Garg wrote:
>> Move kvm_gmem_get_index() to the top of the file and make it available for
>> use in more places.
> 
> Not just "in more places", specifically for kvm_gmem_prepare_folio().  And this
> also has kvm_gmem_prepare_folio() _use_ the helper.  That detail matters, because
> without having actual user, such code movement would be completely arbitrary and
> likely pointless churn.  E.g. AFAICT, it's not needed for the NUMA support or
> even for the WIP-but-functional in-place conversion patches I have.
> 
>> Remove redundant initialization of the gmem variable because it's already
>> initialized.
>>
>> Replace magic number -1UL with ULONG_MAX.
> 
> This is quite clearly three distinct patches.  Yes, they're trivial, but that's
> exactly why they should be split up: it takes so, so little brain power to review
> super trivial patches.  Bundling such patches together almost always increases
> the total review cost relative to if they are split up.  I.e. if split, the cost
> is A + B + C, but bundled together, the cost is A + B + C + X, where 'X' is the
> extra effort it takes to figure out what changes go with what part of the changelog.
> And sometimes (and for me, it's the case here), X > A + B + C, which makes for
> grumpy reviewers.
> 
> Case in point, it took me way too long to spot the new use of kvm_gmem_get_index()
> in kvm_gmem_prepare_folio(), due to the noise from the other changes getting in
> the way.
> 
> More importantly, bundling things together like this makes it an all-or-nothing
> proposition.  That matters, because I don't want to take the ULONG_MAX change.
> The -1 pattern is meaningful (at least, IMO), as KVM is very specifically
> invalidating 0 => 0xffffffff_ffffffff.  I don't love hiding those details behind
> ULONG_MAX.  I realize it's a somewhat silly position, because xarray uses ULONG_MAX
> for it's terminal value, but it gets weird in the guest_memfd code because @end is
> used for both the xarray and for gfn range sent over to KVM.
> 
> Amusingly, the -1UL is also technically wrong, because @end is exclusive.  AFAIK
> it's not actually possible to populate offset -1, so it's a benign off-by-one,
> but I think super duper technically, we would want something absurd like this:
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index cfbb2f1aa1ab..f4d15cda2029 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -231,12 +231,13 @@ static void __kvm_gmem_invalidate_begin(struct gmem_file *f, pgoff_t start,
>                                         pgoff_t end,
>                                         enum kvm_gfn_range_filter attr_filter)
>  {
> +       pgoff_t last  = end == -1UL ? ULONG_MAX : end;
>         bool flush = false, found_memslot = false;
>         struct kvm_memory_slot *slot;
>         struct kvm *kvm = f->kvm;
>         unsigned long index;
>  
> -       xa_for_each_range(&f->bindings, index, slot, start, end - 1) {
> +       xa_for_each_range(&f->bindings, index, slot, start, last) {
>                 pgoff_t pgoff = slot->gmem.pgoff;
>  
>                 struct kvm_gfn_range gfn_range = {
> 


Thanks for the detailed feedback and review, Sean.
I didn't think enough about this from a reviewer/maintainer's perspective.
I'll split this up, make suggested changes, drop the ULONG_MAX
change, and rebase on kvm-x86 gmem for v3.

Thanks again,
Shivank

