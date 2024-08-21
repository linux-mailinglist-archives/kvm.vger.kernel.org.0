Return-Path: <kvm+bounces-24702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FD089598C3
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 12:59:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02ED32816AC
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 10:59:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AB9E1EC0A0;
	Wed, 21 Aug 2024 09:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="W6K88qKT"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11020114.outbound.protection.outlook.com [52.101.61.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32B71EB123
	for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 09:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.114
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724232515; cv=fail; b=kd4HRNH4C0u+NURkjDhyEjVRFH+YuQ/YJOiAV+bUH957QcnznSLiZNi9Iz7RsucK73v4UEV/7PZKaNzaA2OYr9QeKiUehoJNnKrFKScUZ/cLxHzOw4pm32dIjCNH1Jlm9Tp5y2+AyYwUbTUwG799WH9QwelKVBdPNOz6PWhLTC4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724232515; c=relaxed/simple;
	bh=2txt5oBaSGb4T0KAisLkqFmAyPmvsqGL+DaKB1ELEfE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AsryAXeY7glZxTzFnM03+ttokemS2ooqCEvAJ0qmo95N5ZoaTuskyb/LnUGoN4Ch5Q0Enkh3mdE4a6Hwbu2mVrV2hV9ybOaQS0Bw40IGWRtGx+CXVIuRQ6aI9FqyW1sk02vQ5+50r9/F2ifetYOLLxhpD2tSGgDEgMP4hsWPJRY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=W6K88qKT; arc=fail smtp.client-ip=52.101.61.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nG26MMrQUipdSX9vPrpvz0bx7AE2ivb1xDsl20uiqUF6/0Tgh//NFJODp1DVTGal8HvoS6ZJcvEVThej6Dd6OKffY5QpitnwlMjokj7Mdw0KMSbgDd3nMeraQnaPaqPc73fZ80t9OQs6e9eHyCoEnBEWiCaEdkLEubk9YnTYEueKnmKGcQBYgR2v13Xof3WZt7ym0VhS1NfYWBJcZL3s5sI3pquw0kcioww6pHSlTg3kuAp0T4//AGJLy2ELnm/8TNiz8F9GToJMe4biHf283rENUs9ApC/ThB6RlW2Rjb+62s6WzAllRMMFJHUzPWTlifwH9si+cqFh8iAGkeDYBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=guIu/yBnT7SdOGv3ZHUHDL8XqhY8HFEw0ZNNBXMtYsU=;
 b=KVoZn3bI5SMWZZS7r4BZkrZJWrMje38Fs8fdTGHRIjrRm1wVf6uYJJ+1bQAMahPyBuVd0JOu/W7o0b+EfEpPhXqIqDihJuq4YzgZ2Cin1ygOtZOe4tMCEtZlwYOfvMjsWDEaZIPkg2w/7FNRiM1eRos/ZGElZQ7+uwb5KZbXZC5dTtwUwArfL0+5RrGiRilNcpGf5tIFdhrU4de9ddR3+Qn75d3rCYF9pNipCXpjVzm/K+1iZ68Xit9xL90eDRfQoF3axip2gY7dcgBKYUAb2VPy66HmxYotefAf1N39bWRobCvwhG9vX2CAqTQ5EoLgYD2WhfKfz1BJ3ChoPyeTmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=guIu/yBnT7SdOGv3ZHUHDL8XqhY8HFEw0ZNNBXMtYsU=;
 b=W6K88qKTobYKxXZOy4JimIpZ+HKMVeaEGaAVDjM9QxvOqn5Jr8gmfEYqywJfNyloI6Epj9GEepZvcCYyW8udAha9yZicVCFdnPPG+s/GDcy4MWxS8j2bjhedbNoItwyi/ec5PlO9I/AkkRhN9tfQ+I0Z7lDrJLOkM3bDz0sn8hU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 PH0PR01MB8071.prod.exchangelabs.com (2603:10b6:510:29a::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7875.21; Wed, 21 Aug 2024 09:28:29 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9%4]) with mapi id 15.20.7875.018; Wed, 21 Aug 2024
 09:28:29 +0000
Message-ID: <73f106eb-e3e8-482e-bf30-907b35b03f90@os.amperecomputing.com>
Date: Wed, 21 Aug 2024 14:58:20 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/18] KVM: arm64: nv: Add support for address
 translation instructions
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Anshuman Khandual <anshuman.khandual@arm.com>,
 Przemyslaw Gaj <pgaj@cadence.com>
References: <20240820103756.3545976-1-maz@kernel.org>
 <b3e34ca2-911e-471f-8418-5a3144044e56@os.amperecomputing.com>
 <ZsWRFGifEUJrUj7G@linux.dev>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <ZsWRFGifEUJrUj7G@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXP287CA0007.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:49::20) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|PH0PR01MB8071:EE_
X-MS-Office365-Filtering-Correlation-Id: 5296b237-418e-4568-c4a7-08dcc1c39e15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y1dDMjdRL0ZsYk1zOHc5MXZOQmJ1MWprb3dkZ05ZcVowSXhQeU81M0VnL0ZL?=
 =?utf-8?B?V3haTHZXRXRpcVBHMjhpVzI0dGswUE1JNzBjdndzQ0VUYUR1WnhCM0Q0L0hV?=
 =?utf-8?B?ZXExdmRET0s0QnNsMWw2VzBjbVp6RWUvbktZTGMzeWFXMk9PdSs5UU1pUjVo?=
 =?utf-8?B?SGI1Z2FrQ01URGdpMHZKNUFDL2F5UmxxSWg5VWsrVGJXcjYwek1aR1VnYWNl?=
 =?utf-8?B?Wkg5NklhL1hmM2xqVDdLWkQ3TVhaY2dRSWhCcDgvN1lCSXZob0hRSmRmUG1v?=
 =?utf-8?B?K1VhVGdnODFhamkxSGM0Qjc2bXJrQjR2VDNWeGRSWnZOOUtxTG5UYUF0NGpz?=
 =?utf-8?B?N3A5c0JKWktIakx4Y2JMcUhNNE1nVllDUXdaUU5VWmFwTVJDTytwVWJuaE9J?=
 =?utf-8?B?SFFpblc0ZDRlVUlaeUQ4SEl4OW53VUYrL0JxMGkwdDl0bEprNTU5Qm9LSUtJ?=
 =?utf-8?B?K1dQalZVSTREQzlxQkoyTXhBUlNka1E2VTVOZkxIUVkxOTBUUC96WlVLemo2?=
 =?utf-8?B?cjM0L2NteHZOYmpYTXZJeHZCblVRSmN0d2JuWk42akVkOTV2V1EwZ3hxcmdB?=
 =?utf-8?B?dlAvYm5XOUNERHZvM1AzVU81WDJNM0F2TjlBWDV6R0xRM2tBK1J6dmRkS3dO?=
 =?utf-8?B?alg4VTVlanJXbEUxNVdxejVkaUI5dHpWV1VKaFpqNlpHeGJUTEhqOGlITmpN?=
 =?utf-8?B?U2QyUUU4clVqK05pc3U1M3NOR2s2b3JEcGFUWVVPdlN3MG5zaEpWTG1idFdh?=
 =?utf-8?B?L0NoMkFObHZwT01UVkVUcTVjNUdpdkVQbUNGQW5RZUVQSHBmNVg5OVNvbzMx?=
 =?utf-8?B?cnkxLzZxOENWcElsS1Y0QThQYTdvaTc4bkpSamlGb2VWY0NtRytkZmVheXFO?=
 =?utf-8?B?SGJhK3RmQ1h1bzR6MVdwU3g4ZlROKzFJSEwxZ0FHenQvakNEMEk2MlplQ3Js?=
 =?utf-8?B?bXc1NjJVZEdkL0R4Q1BrakdqSDVMRHRSODRQZk9Qai9BWGJJekg1cUNyMkk4?=
 =?utf-8?B?YzV3SGIzQnhhM3lDOWJHUG5kZWk5dXFqZlBqa1NRNXMrZjVXbTdRRnhkTjRo?=
 =?utf-8?B?c1lwZkRoTVhodklVZlV4ZmM0VnJQaElMOVBqWkRQTmZpZUlRV1BFYk9VYU1C?=
 =?utf-8?B?eVd2NjhpOUowaXM4R1lIVDRzeDVBdkdOelVWMDQ4dkhaaVFsUFhzWUNQUHpJ?=
 =?utf-8?B?WWwwQXNjbjlXRENhWTJkU29BVjlYSE9YckZJeEd1K2dLUVJYbGpKRzc2Q2V5?=
 =?utf-8?B?L2JxV1VrVkdZdGhVWkhpOTFzck1ETFlTdkRXMEh3eDhHNVZLZ2lIVVdBOThU?=
 =?utf-8?B?Q2s4N0xGMHBvZHJuNlNmTURRK0tvWUlPcER0NldDQzAzL3RYVlUrckcvNmtx?=
 =?utf-8?B?cWpnY05zbGMwZ0RsWnNXeWZDYk40NUwxY2h5ajNTcWo0c0JLSSt0MU40RTRU?=
 =?utf-8?B?bWR6OE5WcHZQWlhFWEFjdFgrSi81QkdVZ1U4QXdLOG5zb2ErUG1Nenh5aTdt?=
 =?utf-8?B?K2NrNGF5NmRKM3lncTBVanhKREtmSmdFZ0RZc2ZFeHUzSmZNYU9RRGt2c1Vt?=
 =?utf-8?B?ZDdEdmxvd3c1RU9kQ3dHcm9yQkZGK01mS0JWZktSNUhaQmNmY1JMTS9XajRE?=
 =?utf-8?B?ODV1R0ZNUUhRZWdmRkJ2SWRhcXRxdHRkUHhxczlPU2c4NXl5TlZCOFRiUmtX?=
 =?utf-8?B?VXlIYmsrSEhBNVIrUEJaZ3A2aVZwenFta05EZEVoSm5JanFuZEdtZHNEazdW?=
 =?utf-8?B?MTl0dWloamN0S1IvWWh5OVNyUUpFWE1Mb3h1MURsTG95Q3c5WldHYjBKejMv?=
 =?utf-8?B?T1EyMUJPRnlDamJHZktnQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y3o3WTZkV241VVg0Tm4zYzhSRzk0YzhCbWFYUExzK09Ob3NLY05hcStuZ3Rm?=
 =?utf-8?B?aFhuN0xOYnY3N3ZzWEIyVkI5VmpPTGJkSVF3SmowTC9iTDk4YlcwaC9vcG1p?=
 =?utf-8?B?aDRtSnZ3T1pYZzI0dFQ1bTZUdnZRYTAwYTZlNGJaRlZnN3ozbmVsTExMWVF2?=
 =?utf-8?B?ME5qTHN1UmhnN3ZiZXE3eTY4VGdIVFVXQlZ3QmlDL3ZNYnFQMVBMNUhvd1d2?=
 =?utf-8?B?L3FQQ3k0WDlLZDVOZy80SWIyTUZ6S2dBcUh1enVtTFF1MldUMTluODhNZitQ?=
 =?utf-8?B?L3pxT2ZBeXkvOUFnVGZRTEJNcnBoUXBGMkpRMlhyV25sNXZYTG94RE1QeGJF?=
 =?utf-8?B?SU9tMHY5MjI1ZmYrc1pOamlvakxqRHlLcXRsNFVqR1BlV1ZDQ3ZVN1BDWGpP?=
 =?utf-8?B?VVAzcFR2MWEyaDhSSmFLYmZOYVhsT0x3NmVRYWx0ZEtzK09udFdxQStRNGVt?=
 =?utf-8?B?MEdScnREei9YY3BEa1pZbHgxY0RLWFdkQVowRWlUNUVFNUpidFJZRjNzQUQr?=
 =?utf-8?B?aTNEbXU0T2pKM3B5ZG91VXByNUNkaDJKOE9WTmhPZU5pYjN6Yjh1RU43Y2d3?=
 =?utf-8?B?RmZzUXhWSzZYK3BQTnl2T1ZvRU44YjB2UVpoZ1g0cVU1anYzTTlnU3JlQVJi?=
 =?utf-8?B?OXBtTmg5Lys2ZFUrZk1UMHp6S3Ryd2tmQ3VMR0x4U0RwWG1ZVUw3aGhmaWR3?=
 =?utf-8?B?S2VvaDJjSnBvUXpzbWRRZGRFSGx5KzVKT3Jab013Nkxzd2NsSDVTVDBIUlAw?=
 =?utf-8?B?QXF6R1MyalRBbG9QaCt5Z29qekR5U2RGN1JGbmN1NUMweDRac1huampjY092?=
 =?utf-8?B?Y3FSNmNMdE5LcC8xY0R5bVo3Y0VIckFXNUVuU3FEWXRVZnY2Y1hxZ2tweTRR?=
 =?utf-8?B?VklFWHdyU2lNb0Y5UzZTMjYwVGFlT25WTjQ1cStDVjRZUmk4VFNla01ZVnhQ?=
 =?utf-8?B?OUdlM1RMcmVRYmY2WHA1VS8vYUdGQjM3bVY0V2ZoZFJIWEZ4aFFzQm1zNDY4?=
 =?utf-8?B?b3hoZHRhajVSRVhmTENrcUUvNG5DSi83M1NLVGVUcTZWSWNBWWV6RkN6Um5k?=
 =?utf-8?B?NGc1OUM1SldFemJ0V0hwckRoRGJBdE1BVXY2MEdKSFFSbXVCYXhxalNlQW5i?=
 =?utf-8?B?QU5Ia0pzc1dod25vdXlIRWdSWFBmRlQ0WnFBQ3l6aUp5MWNxUVFmRDFCWm1M?=
 =?utf-8?B?aW9lNXpnczZFekZnTmJSdVdYOHpJcFFlL3pNVlRhZG1nZy9CWlhyQUxWeUZZ?=
 =?utf-8?B?K01PRlRmaXUyOURGT1hCVVZqa0E1QnZ2WkZoRHNhcHdQYk90UW9xMTZ0U05i?=
 =?utf-8?B?eXlBYVVJTk9hckVKTzRRREpNckpET2x1OW5OQWhrOG90UkJzVGJNaUVRbTR6?=
 =?utf-8?B?eVR6TDRJQ3EvQTExZFI5bDNQS0tRUlozVmNrSC9taWtJNzFseW1BY3I2Nitr?=
 =?utf-8?B?R3ZlZHppYmlWOWJNcUQyclFBRGRERWd4ZHBBNTd5b0JkVTg3UG9PQnNqQ1Q2?=
 =?utf-8?B?bDBuZFRjWjVyKzJQS3ZUaHpFT285VEdMY1dSa3ZReVI1d1llRkNrVjRtVVox?=
 =?utf-8?B?bzZTT0VsOElYZHlxNHJ4TFZzRDQ0MHZqVEsvcDlXZ1M0N0haaDZRUkptUVJM?=
 =?utf-8?B?SGIwdi85dUV3ZDN3RUpoOXE0ODYwY1p5ZkNWN1l3NFBROGlRTlJSYno3aFdE?=
 =?utf-8?B?dFNrWWVrbWxkaU5tMkE2bFlybUNHNURrT0ZpbDFBZU9WWnh1bFgzaHFpZFAx?=
 =?utf-8?B?NXNZZGhFY1NJWk4xaWY1Sit2Tm1MU29pNGFJNjZVL0toS2hIZElVMm9tOFJY?=
 =?utf-8?B?Skh1VnFkVUhuajdSeXl2bDFNT1pmdklwZFdPWEQ2bkhJU0wvQkJCR1RubDQ1?=
 =?utf-8?B?K3IxaElpNDdFaXVrcVpYdDdjdG9SOEpIdS9uY3dFclVyL2lPbXNxZVo5cFM2?=
 =?utf-8?B?enJxeGhwd3ZrY216QjRwU0FKSXNDQWUzNWh0RE5RSWlyQVlaeGFNNUpaYW14?=
 =?utf-8?B?MmxpMm9UZ3U2QmF5Nms1Z1VWRUsvUUxiM054dEorV0FOQlNSR21Cb1VYN3dK?=
 =?utf-8?B?V1JJcHB3SkNZVkVVdzZMODJtNUQ4YVphbkFhZWI2amN5RFFSL3NCRWcwK3ZU?=
 =?utf-8?B?NE5wdjZuTXJQMlhVMmN0U2tiU3Z5V1pabHVKbUxwWGViUkVhc2w2T0EwUEpY?=
 =?utf-8?Q?5REYj33H+Bi1SbwoFJ5FV+c=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5296b237-418e-4568-c4a7-08dcc1c39e15
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 09:28:29.7406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V/xfE8jYAF6BSOanPBPTlDqT6QVMaiP1zwDDxr82QpxGk/gOValGbge3IjPrZIhxeeHcyNGTR406YuvGphIdTuT4ehTFmZGrxWTfsJ1xHQ1JDTaqjbH9u7nhRgr9ZCIV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB8071



On 21-08-2024 12:32 pm, Oliver Upton wrote:
> Hi Ganapat,
> 
> On Wed, Aug 21, 2024 at 09:55:37AM +0530, Ganapatrao Kulkarni wrote:
>> Have you tested/tried NV with host/L0 booted with GICv4.x enabled?
>> We do see L2 boot hang and I don't have much debug info at the moment.
> 
> Sorry, I've been sitting on a fix for this that I've been meaning to
> send out.
> 
> The issue has to do with the fact that the vpe is marked as runnable
> (its_vpe::pending_last = true) when descheduled w/o requesting a
> doorbell IRQ. Once KVM completes the nested ERET, it believes an IRQ is
> pending for L1 (kvm_vgic_vcpu_pending_irq() returns true), and injects
> the nested exception.

Ah OK, I could see it was returning back to L1 after ERET in ftrace and 
this was getting in loop and L2 was never getting a chance to run.

> 
> This can be papered over by requesting the doorbell IRQ, which we need
> anyway to kick us out of the L2 when an IRQ becomes pending for L1.
> 
> Could you take this diff for a spin?

Thanks Oliver for this fix!.
I could boot L1 and then L2 with this diff.

> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 0ae093bae054..9d07184d79b1 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -613,6 +613,12 @@ struct cpu_sve_state {
>    * field.
>    */
>   struct kvm_host_data {
> +	/* SVE enabled for EL0 */
> +#define HOST_SVE_ENABLED	0
> +	/* SME enabled for EL0 */
> +#define HOST_SME_ENABLED	1
> +	unsigned long flags;
> +
>   	struct kvm_cpu_context host_ctxt;
>   
>   	/*
> @@ -908,10 +914,8 @@ struct kvm_vcpu_arch {
>   /* Save TRBE context if active  */
>   #define DEBUG_STATE_SAVE_TRBE	__vcpu_single_flag(iflags, BIT(6))
>   
> -/* SVE enabled for host EL0 */
> -#define HOST_SVE_ENABLED	__vcpu_single_flag(sflags, BIT(0))
> -/* SME enabled for EL0 */
> -#define HOST_SME_ENABLED	__vcpu_single_flag(sflags, BIT(1))
> +/* KVM is currently emulating a nested ERET */
> +#define IN_NESTED_ERET		__vcpu_single_flag(sflags, BIT(0))
>   /* Physical CPU not in supported_cpus */
>   #define ON_UNSUPPORTED_CPU	__vcpu_single_flag(sflags, BIT(2))
>   /* WFIT instruction trapped */
> @@ -1294,6 +1298,10 @@ DECLARE_KVM_HYP_PER_CPU(struct kvm_host_data, kvm_host_data);
>   	 &this_cpu_ptr_hyp_sym(kvm_host_data)->f)
>   #endif
>   
> +#define host_data_set_flag(nr)		set_bit(nr, host_data_ptr(flags))
> +#define host_data_test_flag(nr)		test_bit(nr, host_data_ptr(flags))
> +#define host_data_clear_flag(nr)	clear_bit(nr, host_data_ptr(flags))
> +
>   /* Check whether the FP regs are owned by the guest */
>   static inline bool guest_owns_fp_regs(void)
>   {
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 05166eccea0a..fd3d6275b777 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2310,6 +2310,7 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
>   	}
>   
>   	preempt_disable();
> +	vcpu_set_flag(vcpu, IN_NESTED_ERET);
>   	kvm_arch_vcpu_put(vcpu);
>   
>   	if (!esr_iss_is_eretax(esr))
> @@ -2321,6 +2322,7 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
>   	*vcpu_cpsr(vcpu) = spsr;
>   
>   	kvm_arch_vcpu_load(vcpu, smp_processor_id());
> +	vcpu_clear_flag(vcpu, IN_NESTED_ERET);
>   	preempt_enable();
>   }
>   
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index c53e5b14038d..f7712c89adef 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -64,14 +64,14 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
>   	*host_data_ptr(fp_owner) = FP_STATE_HOST_OWNED;
>   	*host_data_ptr(fpsimd_state) = kern_hyp_va(&current->thread.uw.fpsimd_state);
>   
> -	vcpu_clear_flag(vcpu, HOST_SVE_ENABLED);
> +	host_data_clear_flag(HOST_SVE_ENABLED);
>   	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
> -		vcpu_set_flag(vcpu, HOST_SVE_ENABLED);
> +		host_data_set_flag(HOST_SVE_ENABLED);
>   
>   	if (system_supports_sme()) {
> -		vcpu_clear_flag(vcpu, HOST_SME_ENABLED);
> +		host_data_clear_flag(HOST_SME_ENABLED);
>   		if (read_sysreg(cpacr_el1) & CPACR_EL1_SMEN_EL0EN)
> -			vcpu_set_flag(vcpu, HOST_SME_ENABLED);
> +			host_data_set_flag(HOST_SME_ENABLED);
>   
>   		/*
>   		 * If PSTATE.SM is enabled then save any pending FP
> @@ -167,7 +167,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
>   	 */
>   	if (has_vhe() && system_supports_sme()) {
>   		/* Also restore EL0 state seen on entry */
> -		if (vcpu_get_flag(vcpu, HOST_SME_ENABLED))
> +		if (host_data_test_flag(HOST_SME_ENABLED))
>   			sysreg_clear_set(CPACR_EL1, 0, CPACR_ELx_SMEN);
>   		else
>   			sysreg_clear_set(CPACR_EL1,
> @@ -226,7 +226,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
>   		 * for EL0.  To avoid spurious traps, restore the trap state
>   		 * seen by kvm_arch_vcpu_load_fp():
>   		 */
> -		if (vcpu_get_flag(vcpu, HOST_SVE_ENABLED))
> +		if (host_data_test_flag(HOST_SVE_ENABLED))
>   			sysreg_clear_set(CPACR_EL1, 0, CPACR_EL1_ZEN_EL0EN);
>   		else
>   			sysreg_clear_set(CPACR_EL1, CPACR_EL1_ZEN_EL0EN, 0);
> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
> index 74a67ad87f29..9f3f06ac76cc 100644
> --- a/arch/arm64/kvm/vgic/vgic-v4.c
> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
> @@ -336,6 +336,22 @@ void vgic_v4_teardown(struct kvm *kvm)
>   	its_vm->vpes = NULL;
>   }
>   
> +static inline bool vgic_v4_want_doorbell(struct kvm_vcpu *vcpu)
> +{
> +	if (vcpu_get_flag(vcpu, IN_WFI))
> +		return true;
> +
> +	if (likely(!vcpu_has_nv(vcpu)))
> +		return false;
> +
> +	/*
> +	 * GICv4 hardware is only ever used for the L1. Mark the vPE (i.e. the
> +	 * L1 context) nonresident and request a doorbell to kick us out of the
> +	 * L2 when an IRQ becomes pending.
> +	 */
> +	return vcpu_get_flag(vcpu, IN_NESTED_ERET);
> +}
> +
>   int vgic_v4_put(struct kvm_vcpu *vcpu)
>   {
>   	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
> @@ -343,7 +359,7 @@ int vgic_v4_put(struct kvm_vcpu *vcpu)
>   	if (!vgic_supports_direct_msis(vcpu->kvm) || !vpe->resident)
>   		return 0;
>   
> -	return its_make_vpe_non_resident(vpe, !!vcpu_get_flag(vcpu, IN_WFI));
> +	return its_make_vpe_non_resident(vpe, vgic_v4_want_doorbell(vcpu));
>   }
>   
>   int vgic_v4_load(struct kvm_vcpu *vcpu)
> 

-- 
Thanks,
Ganapat/GK

