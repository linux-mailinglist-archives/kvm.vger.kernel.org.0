Return-Path: <kvm+bounces-19667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B944F908AB7
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 13:24:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD0861C235EF
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 11:24:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF6D11953BB;
	Fri, 14 Jun 2024 11:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="b1g42sgy"
X-Original-To: kvm@vger.kernel.org
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2099.outbound.protection.outlook.com [40.107.14.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2036413B2AD
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 11:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.14.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718364237; cv=fail; b=tE0wCpCULkTRgAAdFCGaZfOfvQ4jtoXc1CBLGaBcwmTpksaQbL80D7Lf9mZ3ByL+GZjp15dUEP/VZ9YyxEoX46RB3H8zfJKH4QVOmHE9wGaBsseldjkjGHkT6mDasICwQbKDsGh9QuhnWmWmq008e98C3NsNlM/rwRs2IWfP6kE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718364237; c=relaxed/simple;
	bh=b+oKN0JtwlHJprplxju76aKOwbp8gduhSSKW4YsGiZY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GlJifayDi27U8CNykFpetG5QlJFIt2AbUznQpcAUpoeXgDpz8uGOZoL5bDLK3SGjPKlmQorVtBjGlDmk4rkKKshnTkpgGU+XBjSyATSrDuqKK1NFJcj/DShmZcnvYVpUVCBIjLSoomOqq5Whu3zRWsvoC1wl1IAaxzbFRsniMAg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=b1g42sgy; arc=fail smtp.client-ip=40.107.14.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i8YIYPe4ZJx0VIQp8Y7kihlWdLKMOdp2sI8ngLM+sfivHBuQMqlrMqOAUxwLERIND1m9N5jtiBDmOnDLHv2bRri9jl8BeBUuQESh9gOt/HrQV7GQ6MfZ7TUThDb/43mG1eq1pzq4DIf0ZBHb3OdGXcolrFy3ZNSo3XJYt6UsyMB6SvHfRl0fUcf1S0pSILW3yrjT38ZBueHSYSKu5E+ioXTz2iiAN9VePAP9WhwOiPvb0CZHQDghtcesGwRvPl0G3pDyBeajJ2/oBySCYPqatHzWfpphR6lm9zFhHukAuznO+FZhKVwSlC6IlkAkbMJGy07/PzZdAhBHVvO8Sxr2Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8rTisjdU4IwnT/g13nrXQsOkdmmfHkt8Q1YRiLH5hCc=;
 b=GdLiTj03aW/iaeoMRFe8+vcejA5FoaUrQRo5GcenxoBq5XZE4wZO4kvP9n3FG/LWse6zuOK5p/dhgmqKX6Ow4ivqH5owMVf7jP7AFAu+0QureLS09xlP/jQNrWxX+dg53aUHen3v2xn94ZbwJ5RR2zFaIKvwyxRJjQC2+yaBJ/34Bf9GZlyKL3WAIib6y3J4SSFGEZOmkp/kAGVRBJ1i1Oo9MqBr0MdXEkwfblNIh3eBCXdWh9YcnWCgjjKKfMvMTkfE2iuDAUmo6KYZeg4uGn/XwRmV+53rbKZhBp470k6SKwz7vYrCjpyknN/5NfWvCWX7e7dxY4tRA2JgfQyF5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8rTisjdU4IwnT/g13nrXQsOkdmmfHkt8Q1YRiLH5hCc=;
 b=b1g42sgy2J033mlvqkC0cOJh82ZDqnnmlsiVoiZYAdV5nHLjK1ZRyj995F+cgQyHtjDXG/Uqcpx/HOoPnxV7ytnFhU0weoKC/x8y+MY+0X84Vms3ls5BSmnallBKkRNmxGwicHNDffv5r7Xak9POImMhBU2u0sbJ0ECW7/DLEu8jMDh/4kxGLFSgJOzlbCE2lFVbYKkyFifEhpmuzlI5hvbN9gPa1klQ+XecSFwSi1YYOlY7RLXoBJhQqNCGsrCOJegc3xChEBrV52O+hQ1hfVkITx4bizc7F10QY5rtqShcB+EUBuqpivitILOGrdfTEelK1LDBgLW3ZrlWzmQdvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from DBAPR08MB5830.eurprd08.prod.outlook.com (2603:10a6:10:1a7::12)
 by AS8PR08MB8707.eurprd08.prod.outlook.com (2603:10a6:20b:563::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Fri, 14 Jun
 2024 11:23:51 +0000
Received: from DBAPR08MB5830.eurprd08.prod.outlook.com
 ([fe80::574e:cc8a:6519:efdf]) by DBAPR08MB5830.eurprd08.prod.outlook.com
 ([fe80::574e:cc8a:6519:efdf%3]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 11:23:51 +0000
Message-ID: <3fcc1210-a4c9-4391-9583-a2263dbe6e72@virtuozzo.com>
Date: Fri, 14 Jun 2024 13:23:49 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Fix Issue: When VirtIO Backend providing VIRTIO_BLK_F_MQ
 feature, The file system of the front-end OS fails to be mounted.
To: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
 Lynch <lynch.wy@gmail.com>
Cc: jasowang@redhat.com, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, vzdevel <devel@openvz.org>,
 Alexander Atanasov <alexander.atanasov@virtuozzo.com>
References: <5bc57d8a-88c3-2e8a-65d4-670e69d258af@virtuozzo.com>
 <20240517053451.25693-1-Lynch.wy@gmail.com>
 <af6817c2-ddee-4e69-9e55-37b0133c1d3b@virtuozzo.com>
Content-Language: en-US
From: Konstantin Khorenko <khorenko@virtuozzo.com>
In-Reply-To: <af6817c2-ddee-4e69-9e55-37b0133c1d3b@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P195CA0037.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::26) To DBAPR08MB5830.eurprd08.prod.outlook.com
 (2603:10a6:10:1a7::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBAPR08MB5830:EE_|AS8PR08MB8707:EE_
X-MS-Office365-Filtering-Correlation-Id: 6aed0c13-ffc8-4f29-720a-08dc8c6477c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|376011|1800799021;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TWJ5OHZSWi9kclArcXdrWkhuQWxneldyK2h0S0lnV3E4OXFJL3oyV3d4aXVl?=
 =?utf-8?B?ck9DUVVlaVNHTUNuMGtmYWIxOEZvam13U2dPVk9ub0RRVGUvUDFYSDJpUnNL?=
 =?utf-8?B?V2l6NWUrcHJ5Qkh4THhiS1c4QjhVdk9zNzBDRlVRanFuN1lpek9JOEg2Wmds?=
 =?utf-8?B?OFZzMTVsd3pQa3VxcFpWWFFnRndBem00aUMrZWpVTnNMVmJrNWZWS0FmV0hq?=
 =?utf-8?B?U3U5TGtHU2prOGNlUjNkdlYrcTNpYTFKYzJ6WmQwTHJKRVlmbUF1SGRZSzJw?=
 =?utf-8?B?dzNVRnVCVzZpUldzTUNvVDhlcHNqdmpZbkg5d2o5S040OXpKb0tlTlVsSXhB?=
 =?utf-8?B?cUxYTDNhNTQ3SjBpaVltOFNvb3pLYk1mUHJCWVdUcWxCZFJRcHk2cnhlK01X?=
 =?utf-8?B?MGM3RHdseGNPbHNZaTRnSHZQTXU0Umw0bmplMVp5dE00S0c2S2s4bDJzamlW?=
 =?utf-8?B?MTQ4VFlUcW1UOXJjZHNpTnVPb0YwODF5eVAzZ1hzbllOY1BmYVJ6a3ljMWFO?=
 =?utf-8?B?eWdid2xVeWxVOTMzcUYvanZoV3BxN0IxRXpCMnBHcit2c0Z0WkloUVNmNFlM?=
 =?utf-8?B?eE1scGI4ZFgyYkQzN3VPLzh2QUtGK3ZVd0djdDVjL1lmcHhkbnMxdDRyWGFs?=
 =?utf-8?B?QWVGMXlxTmpMK1Y0RG05VkxuQUNiMFAwWGxxVWV4M3RYcHhUWmFLdCt5QTZ2?=
 =?utf-8?B?YVVLSDAvTTZ1M0k4R3AyRlVkclNVQStPVGlGMnRPM3U0NkxqU0VjeitITmZB?=
 =?utf-8?B?UkhqS3NmYW1mZDhBYU4rbklnKzB5VmNzWHdCSitQbmc3ZHRITzBqVWY2bUJF?=
 =?utf-8?B?S21xVHdPeTdvbWhNU1MwdmlVcUxpN2xIYmhZRFdwUXJHekk1L01USXpBVzM3?=
 =?utf-8?B?bU9JQU9XY05zN29xZHV6cGpnY2RMc1FMTzRqNi85Ykl3c3FRRHZwVFFiVng3?=
 =?utf-8?B?K0xXY2tDeDhYaHRLVE9ic09US2ZlZzB2VktIZDJ4eFJyemsrYjA4Mlo2SE1z?=
 =?utf-8?B?WEllTVlTQnpWbk9qWEgxRGtJLzlKYmpDWDA0cng2LzR5SFc0VlJlYXM1MFA5?=
 =?utf-8?B?amhqRisva0hOR05Ta0lrSTFQNGE2MHI3aVZwUUw4a1c5djFWSHpwc2dWc2cw?=
 =?utf-8?B?bnUxSlc3YktBaGY4aERseUkzbmNCa0dMNUlIZmNBYng3WnE1eVk1a1NEZTRj?=
 =?utf-8?B?Y1hzblNpRnl0bjA3b21odCtvaGFPYVRYNUlCam5jczVKMGJFeEgrWjI1UXR6?=
 =?utf-8?B?TE5zbFcrSm5wTU1WT1VWQ3hmYkdvaGJzRHY3bWFDaFhoNGtuUTRjWFRKdTA2?=
 =?utf-8?B?WVZCakZqcVdvOVkyUjN5MGV6M3dZazUwd1ZWSC9uZGllUXJOVWd0UmxVeEgx?=
 =?utf-8?B?UDJBSXlzb2VxT1JSZGc1UWJlUWRnck9YZ3NCUzh5RTJyMlJSbm85b0RFOXJ5?=
 =?utf-8?B?YXRLT3UwMzBIc2UycENpVElGVXVrQWlabFQyZGNEczFEdW1GKy9FWE5HeERM?=
 =?utf-8?B?RDZORG95eEhtQ0RwcXZhL2xWM1kwUkJsc2RFcStEcE45c3h5NFVmZUVQMytN?=
 =?utf-8?B?dE1jdldBR3piYjcycERocmhDSndhMFA0VUpvNXE0bTduUzFWQ0Q2VStvd1da?=
 =?utf-8?B?YTRzYW95K1NnT1RZenRxQWxwSVNxY0VQL01TbE9FbXdIZlFpd3g2aDl0VzYw?=
 =?utf-8?B?eXpBZVU5MU5zU2tCQS9naENpUGxFdVZKeDhPcE1hWkpoYmQxZ1VHN0p4ZmJi?=
 =?utf-8?Q?8AjD6Swlh6qcxCgdHc2HIFxs+ja39NJCheplOWL?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5830.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(1800799021);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VzZDWCtXdm9sU1JCZlcyYy90RjVEQWRQTGRIUktQM2lOSWNPbzNuV0xGa2Ru?=
 =?utf-8?B?WmFIQ050NVdiamgwTG84T25IWkVVOFlsMDNvckkwU0Z2S1JaQ0lQazJRMDcz?=
 =?utf-8?B?VnhETndoN0dMMVIxczFKZUlYWFdERjZpZTF1QVpJVWhYNTRSaTlBYXpkODk4?=
 =?utf-8?B?L0JYczRYUC9MNmVsRTdJbTcrSHMvUmQ1Tiswd2NVMFU1ZGxXNWdlSnJrd2hG?=
 =?utf-8?B?WXZMcVNzQnNXcnlGcE04T09ZWXR1SUF0UlF1RDlpMTlLSG1xdDlTUVBXODJY?=
 =?utf-8?B?blBEOW5WbUhmT29yNjhuZGZuSHpucGswYmV3SXFYN3RGeGtLVE9JeGFLQkQy?=
 =?utf-8?B?RkFmWktVZ1pJbzFlSjdYYVNBWGR6ZjhpaFdaWUhsc2hlM3p5NmNVd1R1eTRK?=
 =?utf-8?B?TVp1QnpsUEgvanJ0dHE3SUV1TVppa05xb2NySlZtSUJmTTFsVkQ5Sm9acHhN?=
 =?utf-8?B?RjlWNmpDTUUzb0pqZHVHamxsWkZYOUxVUFpPK0c1SVhxalk5SlU5Z1JmRmFT?=
 =?utf-8?B?VldrS25vZ3RCaVpDdllDZ0NrZ0NMd3RRbHFPUnZFWThmYnFTZk1HZExpL0E0?=
 =?utf-8?B?ZVNXNm1hR3I4M0gxaWgvVWJzYW1BaUR5MFl6NGNuQkFVeHZMV1g0Szg3S0pU?=
 =?utf-8?B?Z1FqR21rVTBYdnZLZFhJUjZRYXRTOVYyNklGZHRHcHViV1BHZ1d0Q3pmVmxq?=
 =?utf-8?B?S0dOc294dGdPeHRCU2pUbmVxWDlpZ29GY0ZKbXJOaUdyUmY1OThybGtKUlZC?=
 =?utf-8?B?YjJOZ1pHWEZQZ0VTYWgzbUpKS0JCUEtlL0h0bVlxQjZRNVVuTUU5ZElzYmxW?=
 =?utf-8?B?bHZvQS9JbCsyTmUxemVxQXpnanByZWowT2xiQzJsR2JTVWg0Q2s4VVF3b242?=
 =?utf-8?B?VGJ6T0t4eERKWXVsRFM3QjdXWXlpcnVFR2gwcm5VbEpGZ09MUU8zYS90UlEr?=
 =?utf-8?B?MWEwYnpqaEVSSjZNeFJyTmlBaS9JSkJZbGd0UEl2NXJHN25odzk1NDA2R2lz?=
 =?utf-8?B?TkRNSUZNM3U3QnVReU03MUxxWnlqd2IvUEQyRHBDSXpMLzFEdlE1Q001N1N2?=
 =?utf-8?B?Y3Y3dFJHd3BJUW4xcFpBUFp3dytqdHdYaFhNaWlFdVk3UU1hUEhjZXdmeEJs?=
 =?utf-8?B?dUhQOWVhNWJYQXNTeGorWHFUbDV3cWFhZ0VhT3E2S2srL0tuaG9mejluaSs5?=
 =?utf-8?B?VENxMXlmS3RTbm1nc2ZWS05kbStyS2JQMUdxakQ0MWNiSENWdlgyTXUreFBH?=
 =?utf-8?B?VXV3Z1BaeUpMVS9QaUFRNVVVVm1rY1hvcGd0RGt1UmZ6Y3JvZE9GRW82Y2hV?=
 =?utf-8?B?TEF6UW5LRkdjeGdLeEYwL3JLbEwzdTZTWit1WjFCVWNaTzRqU0RiU0h1VHN3?=
 =?utf-8?B?aWgyc2REejNxWUJGd0hxZ0Z1ckw5MTQ3M0lQWkJYR0RTSUlZR0g4OTBoR2NH?=
 =?utf-8?B?SHQvdnJhT0xyNmVjL0hpYzVLMCsyY2hXOFhOODd6VW5MY0FjSmN0bVBhb3R3?=
 =?utf-8?B?VmpGU0dha0Y3YkhkVmMvUEoyWkFIcTdESHhlYVRma1RTemVjSG1LS0V2ZWVX?=
 =?utf-8?B?cytkamM0YXRjeXYwOTVQSmF3LzAwUDZyZkVhRklDTUdWZStuY0YrNzM1ZUFm?=
 =?utf-8?B?VEVxRWJzdGEwaysyeTZERHhrOVZNdU8vNjhId1MrQk1VWDA0NURmNXNDZm5F?=
 =?utf-8?B?TkFteW5DVW5EUlIxWnNBcFFHd0VNL29NTDk4c3oxNjJtbkRtWW5GL1d6ZUdD?=
 =?utf-8?B?RjFHZ1VIZVlZU2FjMkpEMzJueGtKTVhCakxwdngwcHFndm5kdHNCU2lDaFNi?=
 =?utf-8?B?dGVUTVpiOGpLMlBBWFpwUWlMT3BkaWRraWFFVzAxdE1DVGFZVmVPVlNiNjFa?=
 =?utf-8?B?SkdiYWpmSzFLZE85bEk0cEE1eGNXL2o3MXdYSWxOSlVzcjQrZWZOYzR5Ujla?=
 =?utf-8?B?d0ZtWHQ3bEk5Z2w1MnJYMW1ldGVyNnBZS1BJb0pRcERNZHBFVnNlejJjUE1y?=
 =?utf-8?B?WHdxMjhSOS9tWGtySnM4RHZDRWljbXJ3bUxMNVU0Y3RweU9PUm9VQStKWG5k?=
 =?utf-8?B?T3BOeUlFaVNaWGc1bERPblp5am1Rek1yemV1TktVYW5waXdVNVF2VG8ySGwy?=
 =?utf-8?B?Mm85WGcva2VqUDZsRkFuQ0UxdlA5QlpqRzd4M2FuUEdTeDFFRWlkZno1bE9Q?=
 =?utf-8?B?UWc9PQ==?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aed0c13-ffc8-4f29-720a-08dc8c6477c2
X-MS-Exchange-CrossTenant-AuthSource: DBAPR08MB5830.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 11:23:51.5731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l1ca7o3FabwSPBTX1msW58YS94ks2Xsw7UpLMo+PKHfChd3B2pBwwejaBWdOraKfZvE6Bx+uUB5uVZAWe2o1pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8707

Hi Lynch, Andrey,

thank you for the patch, but can you please describe the problem it fixes in a bit more details?
i see that the patch preserves original req->sector, but why/how that becomes important in case 
VIRTIO_BLK_F_MQ feature is set?

Thank you.

--
Best regards,

Konstantin Khorenko,
Virtuozzo Linux Kernel Team

On 17.05.2024 11:09, Andrey Zhadchenko wrote:
> Hi
> 
> Thank you for the patch.
> vhost-blk didn't spark enough interest to be reviewed and merged into
> the upstream and the code is not present here.
> I have forwarded your patch to relevant openvz kernel mailing list.
> 
> On 5/17/24 07:34, Lynch wrote:
>> ---
>>    drivers/vhost/blk.c | 6 ++++--
>>    1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vhost/blk.c b/drivers/vhost/blk.c
>> index 44fbf253e773..0e946d9dfc33 100644
>> --- a/drivers/vhost/blk.c
>> +++ b/drivers/vhost/blk.c
>> @@ -251,6 +251,7 @@ static int vhost_blk_bio_make(struct vhost_blk_req *req,
>>    	struct page **pages, *page;
>>    	struct bio *bio = NULL;
>>    	int bio_nr = 0;
>> +	sector_t sector_tmp;
>>    
>>    	if (unlikely(req->bi_opf == REQ_OP_FLUSH))
>>    		return vhost_blk_bio_make_simple(req, bdev);
>> @@ -270,6 +271,7 @@ static int vhost_blk_bio_make(struct vhost_blk_req *req,
>>    		req->bio = req->inline_bio;
>>    	}
>>    
>> +	sector_tmp = req->sector;
>>    	req->iov_nr = 0;
>>    	for (i = 0; i < iov_nr; i++) {
>>    		int pages_nr = iov_num_pages(&iov[i]);
>> @@ -302,7 +304,7 @@ static int vhost_blk_bio_make(struct vhost_blk_req *req,
>>    				bio = bio_alloc(GFP_KERNEL, pages_nr_total);
>>    				if (!bio)
>>    					goto fail;
>> -				bio->bi_iter.bi_sector  = req->sector;
>> +				bio->bi_iter.bi_sector  = sector_tmp;
>>    				bio_set_dev(bio, bdev);
>>    				bio->bi_private = req;
>>    				bio->bi_end_io  = vhost_blk_req_done;
>> @@ -314,7 +316,7 @@ static int vhost_blk_bio_make(struct vhost_blk_req *req,
>>    			iov_len		-= len;
>>    
>>    			pos = (iov_base & VHOST_BLK_SECTOR_MASK) + iov_len;
>> -			req->sector += pos >> VHOST_BLK_SECTOR_BITS;
>> +			sector_tmp += pos >> VHOST_BLK_SECTOR_BITS;
>>    		}
>>    
>>    		pages += pages_nr;

