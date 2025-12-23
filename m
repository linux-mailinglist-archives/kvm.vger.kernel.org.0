Return-Path: <kvm+bounces-66570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CBF3CCD8092
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:16:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 901643015ECD
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 04:16:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D68D32E03F1;
	Tue, 23 Dec 2025 04:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="tbiNBF5v";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="O9Q3IpvI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94ED2556E;
	Tue, 23 Dec 2025 04:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766463402; cv=fail; b=SYsgYTTappvXQe8b1aKXS3J+wuIDYim9bupGTPM9RdCmmEuxAF9XcTiNe42t5ZaE0BLpe6lL/wFdnyj/rAdzWXA83LWm8TeA1ZZqUx+QL4rADsae5u05O647ys1vEo0YLIRq/Cud68fbZYdRlNOBHMwYzx0Rynu+NhxIcA22peg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766463402; c=relaxed/simple;
	bh=WosaY+si6NXPTZ91x26UtWI5EJjUhXTjZouPIYPFfFg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AaXuI90ANl8dBG7hMm2CjG4uyPO0RmrcJ2y/+KN3Db+me7ce5prHI9om99anPYeJYl9eXjfBAbFfYutkuBB6olgt5gKdBxCUNXQqEP3FyNbcX97yt4cvk5Fi0L6K2AXOlTEMa0RiHpCX00YKvMav1Oz7Z2RJqn1ukXpoAg3pbfU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=tbiNBF5v; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=O9Q3IpvI; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMLwsHm3941971;
	Mon, 22 Dec 2025 20:15:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=WosaY+si6NXPTZ91x26UtWI5EJjUhXTjZouPIYPFf
	Fg=; b=tbiNBF5vn4Hs9B5NCxmZuCczsb5S+nw8W+UtUFlDNEnhgcFESxhC79nq8
	GxnWGUECIjEptBOeq91dN7hzOG1IRvizXvJ7cwawMQK7USthAoF/lo8T9JDmgkAC
	ud/iaTRd2dntinFFtKw9N5xCtc6TIG8JIlv0yajE+qh1mTj/cZYB7DldSNfPVb4e
	JFqUEGcD1ugfYcVdoy/i+3jqjbERVDMBmSR/BRXgaiUU5OfpzAyBzh1+GuDz9Uti
	I8GySf76RBNxw4pngMPMzsluE/AemjvFvp49GSbo3eBP6Ki+I7bzPl1z7weegFtJ
	5M8ZrJfa0G24X7mObScMSE00nHfaQ==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11020090.outbound.protection.outlook.com [40.93.198.90])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4b7ecgrmmm-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 20:15:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p0IGdSPU8o057NS0tzH1s17Xd9I8BtCvOX9vXoo24Z+T/4rNowdZwBsxxwF9jfso8ZG2X2DyBD4ZQHeXT6faacZBmkJo1Vq+8Io+7xDHBf9o1SteVgTC6lp1u9XKc7wRo54OC+1queAusOuzby1UtKRGrbooOp9JQTJmuCMg5WZVAFEQvjKyKEjEKec6PjWT/+nabj5JsxZkst+YLHiJPi7clVVTv8+NW8PowfBN3LrdWvU9tVJmc2JtzgJRb5y6Kc/wIqSxNt/2mRfbcSLA1yIW5Ys/Zni4EPazflfXZ1W+EIX7MhP8OL+UQf8jFvWlgKOSEfBGJ6LuXvPUVmKeLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WosaY+si6NXPTZ91x26UtWI5EJjUhXTjZouPIYPFfFg=;
 b=IQFImWMYr/iFDRwfeuSBWsVdhtJeQzt2Rb3pnWQdXGZFPRJlP1KIhtWUvylMqCU58FhpVgB7L3+wnb42OGgUuW9w9153DWZPaTcoMj4rou7ljwqLkTYKdz/5S35kSum7Xewd323d8DHLajFGRCG6YXO1s0HmuvJs+2oT4MqdL2+NrqKm1dFYQDS0UOPD1/HYCsTiVUqClC0e5xEn+vikJsZWykgC4NhDnjsOtr+X7fGh500Wh1tUj6dd9ZreV4sT8MddcNrezG4bEYQx6+whgUWTm4OC4pcACeQz3C5Cgx+2m0C/TEeRnJdg0TonwkvEN9usElTvYPnyzeGTc91VVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WosaY+si6NXPTZ91x26UtWI5EJjUhXTjZouPIYPFfFg=;
 b=O9Q3IpvIAmDneLhugHAEkgJ+b15CachhBHAkmQZEPnwQEO/NUi0dhWmu50sSntM9qKd25TRygzLlL8ooIPmTCy3IyyDMJTVwmw4w7a3ab5M3sEjyWzQMJndfZ7G3/gPNOE80jFy7RTXgS9dawUVt36qtqn00EZUbX41rk2IoNjZYPOQR02dhTSowWmqG32hbsLB8+FeKHtCgkVPli4HdWmCpCKfX5pLt9tHQvlXEspdo1tej51IxIFrYOQyyQTxurKVsQw4XA2ZuwJdq5Dj4QQZ5e7AW06xapA11t3vMALnUJEQhqAhqOI4S0miD+L9uibca8K5gRQhcM2gugKEQOA==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SJ0PR02MB7759.namprd02.prod.outlook.com
 (2603:10b6:a03:329::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 04:15:56 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 04:15:56 +0000
From: Jon Kohler <jon@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de"
	<tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
	<bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        Sergey Dyasli <sergey.dyasli@nutanix.com>
Subject: Re: [RFC PATCH 15/18] KVM: x86/mmu: Extend make_spte to understand
 MBEC
Thread-Topic: [RFC PATCH 15/18] KVM: x86/mmu: Extend make_spte to understand
 MBEC
Thread-Index: AQHblFP84BlVF0wWWUSY/v0FR0BUXrPP4TcAgWB7wAA=
Date: Tue, 23 Dec 2025 04:15:56 +0000
Message-ID: <F2043F2D-B2F4-410E-8E9D-333343C87B1E@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250313203702.575156-16-jon@nutanix.com> <aCJoNvABQugU2rdZ@google.com>
In-Reply-To: <aCJoNvABQugU2rdZ@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3864.300.41.1.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|SJ0PR02MB7759:EE_
x-ms-office365-filtering-correlation-id: 5107bc12-eae5-4a72-6305-08de41d9f8a4
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?WFpvQWFMM1oyV3hpRUdmdlJjYnJ0NWczWEIwTmp1aXRSSUJHZGpWVHNpZkdL?=
 =?utf-8?B?WUg0V01CZURibWU5eVJWeUhINm1WUDE4cVhxV1Uxd244VTRCNGtENC9OYkto?=
 =?utf-8?B?SlJTRFdxTXA5eDhMd3g1UCtFMUpXcU5SV1dvMjc2MDlWb3ZOY3RaUmVDOGda?=
 =?utf-8?B?N2V3QlFNN2kwNC8zWXk3S09SeTJjSllEWW44YTlDV0Rma1dwUDFlZ0VWWi9a?=
 =?utf-8?B?L1R6Uy9qVDU4LzNWUUFRV2hEY3JpUU9YZ056WS8zUlp6OElqZU4yQWszeUR3?=
 =?utf-8?B?UUVxdGd4d25GazBKSWxKQ0Z6T1dGS3k3djZuWi95MXhBbmQ2UUFPaVFlc1Nu?=
 =?utf-8?B?dXA0ek5KRnZyNnJVOGhFS20xeDNhdGRhNXlaT20vNWNBR09RLzBmbnllQ3M3?=
 =?utf-8?B?bjRmN2xtcVlCM0h1ZkRjNzZJT0tFR0ZDMy9EV0N0SGRjaEIzQlRlTWY5Y3hv?=
 =?utf-8?B?Nnh6amVaRWh5cGxNaklwSElkamh1bFVLQ3pBRXErckJBejRQaGdieHdzQXNM?=
 =?utf-8?B?bnZ3QTYrSVkyajJsb1RieGVBQXJ1bXcxRjVNdWFpTnNCUTUvV09VRysxTk5M?=
 =?utf-8?B?RW1KQlVVTXBwbjNUb2tKUGxuMGtuWHBXVUJWeTBUb1YxblJKQVFaZDlJR3RO?=
 =?utf-8?B?WERmcVBPTmY3bnl0NzMwaGFPQUh3emZNc0h1czZxNlpDYW14bVZ2NUQwb3Fi?=
 =?utf-8?B?cWFPY1FzaVlNNVZjS2hCc1VSd3Z3Y2JzYmx6b01wZUtWeWRpZXpFSjFyTGRp?=
 =?utf-8?B?WDladWEycjlRNGVwdFJCejV3UFV4Y1lpN0Q4WE5vcnU4emxvcUhzeTVsQjNw?=
 =?utf-8?B?SXFHajUydDRvYzhYSisyL3c4NzdXNmJqbUY1WFdiQWs3dUZhNFlNTG4zcWF5?=
 =?utf-8?B?MzIyVnhuUldtbGRVQmdicHpkUXZYYXdodnpxbGcwVjFOQ244U2cvV1lQRE9S?=
 =?utf-8?B?M3VHbS9yRWVLUjBOTkl4WlFPWVk5R2ZQN3NGbmpIV0tnQnhVUlVwcG5PbnRN?=
 =?utf-8?B?NDNTMWZYdzF0S0FFZ2k2R29ZQ05uVWFnZkNZQzZrWVdrMmxubUwyMWpXU21C?=
 =?utf-8?B?M1kxMDRLV1hUZ1ZWa0ViMURSSVNucXN5UlpHaGp5SlBOaW9YTWU0Q1pSdXlh?=
 =?utf-8?B?ZE1SNy9MT0RWamFXVm9YK1dtLzJhcU5wQVVIdk9HdXhlUm9ucnJSaWdURUFm?=
 =?utf-8?B?Rkp6TXo3ZnVOWU1IVmFBck5pQUc0Sld0RzZtbVdrU0wyak85VnZiTi9XRVNL?=
 =?utf-8?B?ZnIwRG8vSzhRODV3Y3o3RytwN2FNbk1IM2M5ZFVHcE5zRXFGSjU1SjJZRWtk?=
 =?utf-8?B?T2ZhQkRXejZtK1Exbk9semJla2dKZE0zYXRwQVRtVWZOdmJNM3hmSlFJREYr?=
 =?utf-8?B?WHlENXppUGRVL29tRDQyejQ4TEdxaFFPNmZ6VUdmK1c0bDdSNXdoYS9WN25w?=
 =?utf-8?B?UHR6eFpVL1JkeXVUYmlPTUVoS0FZc1hmblNPRlBibnlqV1gxb0svRkJCSzN3?=
 =?utf-8?B?NjhkQ0JnOTRzbVluZmF5czlyV3RDaGQ5NWFudm9zWDNjSmRSSzRITTdzSXRP?=
 =?utf-8?B?R0VYZ1JPWTdEaVFXci9oVzUyZ2JYQ0RkLzJvbCthK0UvL2ZGbE96TFFJTXlC?=
 =?utf-8?B?N0g4VmhmVnA1N051cGgxak53UWpyZHN2dzQxcWRVbTRwZ0J4aGJHN1V6bjBo?=
 =?utf-8?B?V3dzd0ZYc2JHWndOQWpDQmRya3Q4bVQ0RlladXVVNFRKQVI1Q1FHbSt4U2hY?=
 =?utf-8?B?aUhXQ3JlTTVQL0VCOXZLVzNSYklRd1VGeTc3OTR0MVJacnFnc3B2V0plWkpV?=
 =?utf-8?B?WGhqbDQwR3ptbEFDMzBQUG9WcytIN1EyeGVrQno3VUh4clJVeGpDcjJkUkxW?=
 =?utf-8?B?a3RCcWpXdmQxejRHTVk0NHV5VkR4cVRUMTBxY1YvUHZQcnZKVVlTL1RZNTgx?=
 =?utf-8?B?Q2pCWTlRczNacFl0ZXcyVVlkL0kyMUdudDExWXcyakRGdFIzNUJNSWQ2UWFm?=
 =?utf-8?B?aHNqbnpvZ2Y1TTJEYUd2UEFJUG15K3lzL09QTmMzTVJpSUk1Qk1WNnJuTUhp?=
 =?utf-8?Q?m4Qf48?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UVhxZjYxbmtHT2phWlVDdjc5ekhNVVM4N0owK2N0ZlhkSkhheG5pMm5PQmN1?=
 =?utf-8?B?ZThwcmR6WjIycWFBR0Rqd2QzTTVGSEJieXJjZEtQTEcxQkx6aGl6NkRaMjlD?=
 =?utf-8?B?Q3lDK0MrWGpvRi9HaysvSnlvLzFnaE8yL0tUcTZ4dlRneW9CRWwvUzVPbVZ2?=
 =?utf-8?B?V2RpK0pSaHpTKzZLQ2hoWWhiMGVDOGx3ZWRvODVFeGFlbytxZzM2R2xGYlNB?=
 =?utf-8?B?K3Bodk5kdGU2Q0RyWmE4UmIzY05velB1YnV4UWIzcnVRYUJwUGdvSFNlZzBz?=
 =?utf-8?B?dms1bDhwVjdVeE5ZNmxwMGJrWC9NeXJxOVF3M2syNUlKS2JMemY4d25YMHRZ?=
 =?utf-8?B?TysvMEcwdnJtMzJQN1J6WStpd21Fd2FFU1FXVkp0TTJKR2xraDNZZzFwN2dB?=
 =?utf-8?B?emhVMjYxV25xRzBtTk5tNnd4dHFWWGpLbjJWT0xFSk0wSDh1NUtUZFNMKzFL?=
 =?utf-8?B?ekRVOUR1a0dqSnJFRWxtVnFEL1V5RjY3RjdCTk40ZVpoUlJveXJIaEtNTXYw?=
 =?utf-8?B?U0xiSFpSRFQ4Qm82clMra3JhWThaQm4yTzM3NjB6VlFmTnFteXFWNkt2QXVS?=
 =?utf-8?B?a05iQmswaDJmd0tVUU9WRTBjWm1lZnIwOEgxYXBJVkpnSndzR3QwUFpvUGlG?=
 =?utf-8?B?b3Jnczg0bUZyUWZIczlJc3N6cTZUMmh2MzhxWkZmSzZVM2ZZUVpnTldwdW9s?=
 =?utf-8?B?QzNDdGUzSjNEY2xybDlEZGtySUZVRTY0WEMwWjNJbEx5b1ZURzFIREdQVUFM?=
 =?utf-8?B?Z1k4OTMzMFc0T3UwUngwcFUwQzd6dEZQbUcyaTBGVFh2T2R3WThYdmNzS0hM?=
 =?utf-8?B?WUxjZnQ4QzRoNDJRWit4b1ZIMkp3cDJyUWNUUWRxcFZVRjhpV0hRVG5nSEFi?=
 =?utf-8?B?QWpJSkdVVEtBY2pIU3phTTQ5VWdtaW5PYlM3ZzFPa0lQQ3U1RnlaeTdNR2Zr?=
 =?utf-8?B?eDRoVHViTE1DMTB1MGkrcUlHQXBiVTRCbU5pdlZCQ25ML0dUZ2x5eFo2ZUlm?=
 =?utf-8?B?dEN1U24xQ2djZ3BaQWJscktNbkRsR2JINkVBRGRiSzNkVUxSenZLTXhYaDdI?=
 =?utf-8?B?NFdDS2xGUzVOb29paG92WGpTM25tcEdtYXR6OHMwTFZRMHBDSkloZDE3Rlh2?=
 =?utf-8?B?cWMzYVZ4b3J3QWd3Ti9vSEMvcDdudHVZQ3RubkZtODhvcmNTeG9iUExyRnNM?=
 =?utf-8?B?SGFOUnRpeDNVMmV0cDRyNWhOaUM5Nmd1V0JRbG9BU29icGF0RjhFdEVkaGdY?=
 =?utf-8?B?ejhaYk5MVUk4OStZNURQRzhvWjdTVVlRdkhkV24vNHd2QkJKWkpiNFRKQ2cx?=
 =?utf-8?B?eFhJWWQ3U1E5WEVTanZTVHhPT1R4Wm43cUJOZjM5VjJBbm1scjBhK0FjNGdp?=
 =?utf-8?B?dkJVZ2FpQk9mSTdxYjBZU0ZHaW1IbG5YUDV6TSs1NWM4OTdUWHd3TTlVY3N3?=
 =?utf-8?B?NlpXeXBpWVpGaitPSEZNandFYlQ1RHZPZCs2YXlvd2FUWVByMnNRdE10eHZv?=
 =?utf-8?B?Slc2RXFhZ0dwczR1MG8vZjhzaHVRY2doZ1gwOW5vWkRyOEVIRWxNNXhqZ1Bz?=
 =?utf-8?B?Q0VvOUdjQ3NGKzQwUmhRQ0Z6ditpcXZ1RzBIUUZleVU1NnlURFRkNEROMVlT?=
 =?utf-8?B?ek5RNlVaS0w5eHZQWVk3Z2w4V3dkTUhZRHZ4L2FmNVZQbEJjdGxNZHh5U0ts?=
 =?utf-8?B?OVBua1VaL2J0NlY3aWpRVnhyT1RLYTlvbzVob21kcFhrRGp1eHh0d0Y5UTdH?=
 =?utf-8?B?aUpxUVJKcG1LY0d0ZWJVb0VEN2ZJc1J2REhzQ3lXYk1Rd2RQanZsTUpiZWht?=
 =?utf-8?B?c1E4WkVJWXRmcUp1a2JzK0dMLzlxMWZjNnVpMnB3NXh6WFR0b1N1cWxLOFBD?=
 =?utf-8?B?V3FoajFtTDYralp4c1QvUk13YTFpVXdjb3lndXhnSHZHUzBXdnJHckZqSzBo?=
 =?utf-8?B?WjJPYmxPZlBGTW5VcHladmgwRHc5TUMraXF5Rkk2S2lvZURwMmVpNUFzcTdm?=
 =?utf-8?B?M21Zb3c3UzdUOVhjQUxLOUVYRXRSamJnZExOeFBaZlNrenBVeHNNcjJpVGNu?=
 =?utf-8?B?ZERyQ2JyN1ZhSGllN08xSnNaeSs3L01nTUhsYnAyRUFPd2RKZUFzdjhORGpw?=
 =?utf-8?B?b0pFcGEvVmRlLy9QS1lBN2xobHZtcUduUm9lSG1WekMyTUpxSzZhaEpiNEtE?=
 =?utf-8?B?RndwanZoWDNRNHNwazZLdVk5bE5VZS9NejdJTUR5TUxqSHQ5a3JyeEZNY3pp?=
 =?utf-8?B?eVptNVFRT0RtanA2N3RDY0FjYlJsa2hIcXlnd25TRGN5NHFHaFpzOXpXUzVC?=
 =?utf-8?B?bWpEY0hvMkFOT0RCdytrR0VRSnBsTE9TN1FwVS9mRng5dVZWZjdpeFB0TDFo?=
 =?utf-8?Q?UoTWcg2+2PT0aK7vE6egCLqJK6NDSM/cE/SnAzfFEGxab?=
x-ms-exchange-antispam-messagedata-1: i2Fw1qGZHDHeYGFcCIH5/2Uzywkg/pf68Uo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9DB9AE6820F82B478A305F79D3D73FB6@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5107bc12-eae5-4a72-6305-08de41d9f8a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2025 04:15:56.8200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8QyEG6msB3SUazc7ZwSDmtWQRYq8VN43CZW6/nUvexIHp/NC5ZduyeDqfxeeqWn5JP5pa6f7dUGuJqRBN6wxUUXbH4dR5G6zm191esVEsO4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7759
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDAzMyBTYWx0ZWRfXx+R4RWfrB8kG
 1A7SLsgLdF/ptT+aUWzrgtrLZpNEpdLNdyA0OySTcCVULxndgDuQQtSMzQi3bG5zEVksUabKfWp
 xu17aJlxiJbcd5YE0FUXyDp70Lcl+um2tEK0FMNrUIs0zxYTmxbeZ47mcFWdO3/e4s/KuZSLcon
 kJPW463g4KEdH0Rbxx9MKYYSOzltW6qkPn8B+0KDWaGiK1X7Mz5LDXwtN2P7NPX3JNMSt0YRUGQ
 hY7lLxGTWJKZJhuTIZzD+xW5IUNw3uGxlSAKovCvGlGp8vXhcFeJqkOnLNlKqs3ocBqT4gRmjVk
 Z2ZX5Ua7ktfZyK5mybwfAsnAZk2FDANE2BQ1eQQ3zamUETirZhybp9aXNYJXYJDEKNpvdIvEb+D
 uRpAlxM3cRKGbFzzW8g1DoLvp841/8kcrziynb7j3W+74Vwe/UxRDnUbQsty+SiIIpgtVGAmppM
 3m4rdratYHayMUnO7Gg==
X-Proofpoint-ORIG-GUID: FriJVnCSwZXBtl5aBRDVKvlDl7hlteww
X-Proofpoint-GUID: FriJVnCSwZXBtl5aBRDVKvlDl7hlteww
X-Authority-Analysis: v=2.4 cv=R7YO2NRX c=1 sm=1 tr=0 ts=694a177f cx=c_pps
 a=O2bURPg9OTzncuCi5jyorA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=64Cc0HZtAAAA:8 a=RTXGalF2iBwoXAbM_BQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDEyLCAyMDI1LCBhdCA1OjI54oCvUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+IE9uIFRodSwgTWFyIDEzLCAyMDI1LCBK
b24gS29obGVyIHdyb3RlOg0KPj4gRXh0ZW5kIG1ha2Vfc3B0ZSB0byBtYXNrIGluIGFuZCBvdXQg
Yml0cyBkZXBlbmRpbmcgb24gTUJFQyBlbmFibGVtZW50Lg0KPiANCj4gU2FtZSBjb21wbGFpbnRz
IGFib3V0IHRoZSBzaG9ydGxvZyBhbmQgY2hhbmdlbG9nIG5vdCBzYXlpbmcgYW55dGhpbmcgdXNl
ZnVsLg0KDQpBY2svZG9uZSwgZml4ZWQgYWNyb3NzIHRoZSBib2FyZCBpbiB2MS4NCg0KPj4gTm90
ZTogRm9yIHRoZSBSRkMvdjEgc2VyaWVzLCBJJ3ZlIGFkZGVkIHNldmVyYWwgJ0ZvciBSZXZpZXcn
IGl0ZW1zIHRoYXQNCj4+IG1heSByZXF1aXJlIGEgYml0IGRlZXBlciBpbnNwZWN0aW9uLCBhcyB3
ZWxsIGFzIHNvbWUgbG9uZyB3aW5kZWQNCj4+IGNvbW1lbnRzL2Fubm90YXRpb25zLiBUaGVzZSB3
aWxsIGJlIGNsZWFuZWQgdXAgZm9yIHRoZSBuZXh0IGl0ZXJhdGlvbg0KPj4gb2YgdGhlIHNlcmll
cyBhZnRlciBpbml0aWFsIHJldmlldy4NCj4+IA0KPj4gU2lnbmVkLW9mZi1ieTogSm9uIEtvaGxl
ciA8am9uQG51dGFuaXguY29tPg0KPj4gQ28tZGV2ZWxvcGVkLWJ5OiBTZXJnZXkgRHlhc2xpIDxz
ZXJnZXkuZHlhc2xpQG51dGFuaXguY29tPg0KPj4gU2lnbmVkLW9mZi1ieTogU2VyZ2V5IER5YXNs
aSA8c2VyZ2V5LmR5YXNsaUBudXRhbml4LmNvbT4NCj4+IA0KPj4gLS0tDQo+PiBhcmNoL3g4Ni9r
dm0vbW11L3BhZ2luZ190bXBsLmggfCAgMyArKysNCj4+IGFyY2gveDg2L2t2bS9tbXUvc3B0ZS5j
ICAgICAgICB8IDMwICsrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLQ0KPj4gMiBmaWxlcyBj
aGFuZ2VkLCAyOSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPj4gDQo+PiBkaWZmIC0t
Z2l0IGEvYXJjaC94ODYva3ZtL21tdS9wYWdpbmdfdG1wbC5oIGIvYXJjaC94ODYva3ZtL21tdS9w
YWdpbmdfdG1wbC5oDQo+PiBpbmRleCBhM2E1Y2FjZGE2MTQuLjc2NzUyMzlmMmRkMSAxMDA2NDQN
Cj4+IC0tLSBhL2FyY2gveDg2L2t2bS9tbXUvcGFnaW5nX3RtcGwuaA0KPj4gKysrIGIvYXJjaC94
ODYva3ZtL21tdS9wYWdpbmdfdG1wbC5oDQo+PiBAQCAtODQwLDYgKzg0MCw5IEBAIHN0YXRpYyBp
bnQgRk5BTUUocGFnZV9mYXVsdCkoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3Qga3ZtX3Bh
Z2VfZmF1bHQgKmZhdWx0DQo+PiAqIHRoZW4gd2Ugc2hvdWxkIHByZXZlbnQgdGhlIGtlcm5lbCBm
cm9tIGV4ZWN1dGluZyBpdA0KPj4gKiBpZiBTTUVQIGlzIGVuYWJsZWQuDQo+PiAqLw0KPj4gKyAv
LyBGT1IgUkVWSUVXOg0KPj4gKyAvLyBBQ0NfVVNFUl9FWEVDX01BU0sgc2VlbXMgbm90IG5lY2Vz
c2FyeSB0byBhZGQgaGVyZSBzaW5jZQ0KPj4gKyAvLyBTTUVQIGlzIGZvciBrZXJuZWwtb25seS4N
Cj4+IGlmIChpc19jcjRfc21lcCh2Y3B1LT5hcmNoLm1tdSkpDQo+PiB3YWxrZXIucHRlX2FjY2Vz
cyAmPSB+QUNDX0VYRUNfTUFTSzsNCj4gDQo+IEkgd291bGQgc3RyYWlnaHQgdXAgV0FSTiwgYmVj
YXVzZSBpdCBzaG91bGQgYmUgaW1wb3NzaWJsZSB0byByZWFjaCB0aGlzIGNvZGUgd2l0aA0KPiBB
Q0NfVVNFUl9FWEVDX01BU0sgc2V0LiAgSW4gZmFjdCwgdGhpcyBlbnRpcmUgYmxvYiBvZiBjb2Rl
IHNob3VsZCBiZSAjaWZkZWYnZA0KPiBvdXQgZm9yIFBUVFlQRV9FUFQuICBBRkFJQ1QsIHRoZSBv
bmx5IHJlYXNvbiBpdCBkb2Vzbid0IGJyZWFrIG5FUFQgaXMgYmVjYXVzZQ0KPiBpdHMgaW1wb3Nz
aWJsZSB0byBoYXZlIGEgV1JJVEUgRVBUIHZpb2xhdGlvbiB3aXRob3V0IFJFQUQgKGEuay5hLiBV
U0VSKSBiZWluZw0KPiBzZXQuDQoNClRoYW5rcywgSSByZXdvcmtlZCB0aGlzIGVudGlyZSBwYXRj
aCBzZXQsIGl0IGlzIG11Y2ggY2xlYW5lciBpbiB2MS4NCg0KPj4gfQ0KPj4gZGlmZiAtLWdpdCBh
L2FyY2gveDg2L2t2bS9tbXUvc3B0ZS5jIGIvYXJjaC94ODYva3ZtL21tdS9zcHRlLmMNCj4+IGlu
ZGV4IDZmNDk5NGIzZTZkMC4uODliZGFlM2Y5YWRhIDEwMDY0NA0KPj4gLS0tIGEvYXJjaC94ODYv
a3ZtL21tdS9zcHRlLmMNCj4+ICsrKyBiL2FyY2gveDg2L2t2bS9tbXUvc3B0ZS5jDQo+PiBAQCAt
MTc4LDYgKzE3OCw5IEBAIGJvb2wgbWFrZV9zcHRlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3Ry
dWN0IGt2bV9tbXVfcGFnZSAqc3AsDQo+PiBlbHNlIGlmIChrdm1fbW11X3BhZ2VfYWRfbmVlZF93
cml0ZV9wcm90ZWN0KHNwKSkNCj4+IHNwdGUgfD0gU1BURV9URFBfQURfV1JQUk9UX09OTFk7DQo+
PiANCj4+ICsgLy8gRm9yIExLTUwgUmV2aWV3Og0KPj4gKyAvLyBJbiBNQkVDIGNhc2UsIHlvdSBj
YW4gaGF2ZSBleGVjIG9ubHkgYW5kIGFsc28gYml0IDEwDQo+PiArIC8vIHNldCBmb3IgdXNlciBl
eGVjIG9ubHkuIERvIHdlIG5lZWQgdG8gY2F0ZXIgZm9yIHRoYXQgaGVyZT8NCj4+IHNwdGUgfD0g
c2hhZG93X3ByZXNlbnRfbWFzazsNCj4+IGlmICghcHJlZmV0Y2gpDQo+PiBzcHRlIHw9IHNwdGVf
c2hhZG93X2FjY2Vzc2VkX21hc2soc3B0ZSk7DQo+PiBAQCAtMTk3LDEyICsyMDAsMzEgQEAgYm9v
bCBtYWtlX3NwdGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3Qga3ZtX21tdV9wYWdlICpz
cCwNCj4+IGlmIChsZXZlbCA+IFBHX0xFVkVMXzRLICYmIChwdGVfYWNjZXNzICYgQUNDX0VYRUNf
TUFTSykgJiYNCj4gDQo+IE5lZWRzIHRvIGNoZWNrIEFDQ19VU0VSX0VYRUNfTUFTSy4NCg0KQWNr
L2RvbmUuDQoNCj4+ICAgIGlzX254X2h1Z2VfcGFnZV9lbmFibGVkKHZjcHUtPmt2bSkpIHsNCj4+
IHB0ZV9hY2Nlc3MgJj0gfkFDQ19FWEVDX01BU0s7DQo+PiArIGlmICh2Y3B1LT5hcmNoLnB0X2d1
ZXN0X2V4ZWNfY29udHJvbCkNCj4+ICsgcHRlX2FjY2VzcyAmPSB+QUNDX1VTRVJfRVhFQ19NQVNL
Ow0KPj4gfQ0KPj4gDQo+PiAtIGlmIChwdGVfYWNjZXNzICYgQUNDX0VYRUNfTUFTSykNCj4+IC0g
c3B0ZSB8PSBzaGFkb3dfeF9tYXNrOw0KPj4gLSBlbHNlDQo+PiAtIHNwdGUgfD0gc2hhZG93X254
X21hc2s7DQo+PiArIC8vIEZvciBMS01MIFJldmlldzoNCj4+ICsgLy8gV2UgY291bGQgcHJvYmFi
bHkgb3B0aW1pemUgdGhlIGxvZ2ljIGhlcmUsIGJ1dCB0eXBpbmcgaXQgb3V0DQo+PiArIC8vIGxv
bmcgaGFuZCBmb3Igbm93IHRvIG1ha2UgaXQgY2xlYXIgaG93IHdlJ3JlIGNoYW5naW5nIHRoZSBj
b250cm9sDQo+PiArIC8vIGZsb3cgdG8gc3VwcG9ydCBNQkVDLg0KPiANCj4gSSBhcHByZWNpYXRl
IHRoZSBlZmZvcnQsIGJ1dCB0aGlzIGRpZCBmYXIgbW9yZSBoYXJtIHRoYW4gZ29vZC4gIFJldmll
d2luZyBjb2RlDQo+IHRoYXQgaGFzIHplcm8gY2hhbmNlIG9mIGJlaW5nIHRoZSBlbmQgcHJvZHVj
dCBpcyBhIHdhc3RlIG9mIHRpbWUuICBBbmQgdW5sZXNzIEknbQ0KPiBvdmVybG9va2luZyBhIHN1
YnRsZXR5LCB5b3UncmUgbWFraW5nIHRoaXMgd2F5IGhhcmRlciB0aGFuIGl0IG5lZWRzIHRvIGJl
Og0KPiANCj4gaWYgKHB0ZV9hY2Nlc3MgJiAoQUNDX0VYRUNfTUFTSyB8IEFDQ19VU0VSX0VYRUNf
TUFTSykpIHsNCj4gaWYgKHB0ZV9hY2Nlc3MgJiBBQ0NfRVhFQ19NQVNLKQ0KPiBzcHRlIHw9IHNo
YWRvd194X21hc2s7DQo+IA0KPiBpZiAocHRlX2FjY2VzcyAmIEFDQ19VU0VSX0VYRUNfTUFTSykN
Cj4gc3B0ZSB8PSBzaGFkb3dfdXhfbWFzazsNCj4gfSBlbHNlIHsNCj4gc3B0ZSB8PSBzaGFkb3df
bnhfbWFzazsNCj4gfQ0KPiANCj4gS1ZNIG5lZWRzIHRvIGVuc3VyZSBBQ0NfVVNFUl9FWEVDX01B
U0sgaXNuJ3Qgc3B1cmlvdXNseSBzZXQsIGJ1dCBLVk0gc2hvdWxkIGJlDQo+IGRvaW5nIHRoYXQg
YW55d2F5cy4NCg0KR3JlYXQsIHRoYW5rcyBmb3IgdGhlIHN1Z2dlc3Rpb24sIEkgaW50ZWdyYXRl
ZCB0aGlzLiANCg0KPj4gKyBpZiAoIXZjcHUtPmFyY2gucHRfZ3Vlc3RfZXhlY19jb250cm9sKSB7
IC8vIG5vbi1tYmVjIGxvZ2ljDQo+PiArIGlmIChwdGVfYWNjZXNzICYgQUNDX0VYRUNfTUFTSykN
Cj4+ICsgc3B0ZSB8PSBzaGFkb3dfeF9tYXNrOw0KPj4gKyBlbHNlDQo+PiArIHNwdGUgfD0gc2hh
ZG93X254X21hc2s7DQo+PiArIH0gZWxzZSB7IC8vIG1iZWMgbG9naWMNCj4+ICsgaWYgKHB0ZV9h
Y2Nlc3MgJiBBQ0NfRVhFQ19NQVNLKSB7IC8qIG1iZWM6IGtlcm5lbCBleGVjICovDQo+PiArIGlm
IChwdGVfYWNjZXNzICYgQUNDX1VTRVJfRVhFQ19NQVNLKQ0KPj4gKyBzcHRlIHw9IHNoYWRvd194
X21hc2sgfCBzaGFkb3dfdXhfbWFzazsgLy8gS01YID0gMSwgVU1YID0gMQ0KPj4gKyBlbHNlDQo+
PiArIHNwdGUgfD0gc2hhZG93X3hfbWFzazsgIC8vIEtNWCA9IDEsIFVNWCA9IDANCj4+ICsgfSBl
bHNlIGlmIChwdGVfYWNjZXNzICYgQUNDX1VTRVJfRVhFQ19NQVNLKSB7IC8qIG1iZWM6IHVzZXIg
ZXhlYywgbm8ga2VybmVsIGV4ZWMgKi8NCj4+ICsgc3B0ZSB8PSBzaGFkb3dfdXhfbWFzazsgLy8g
S01YID0gMCwgVU1YID0gMQ0KPj4gKyB9IGVsc2UgeyAvKiBtYmVjOiBueCAqLw0KPj4gKyBzcHRl
IHw9IHNoYWRvd19ueF9tYXNrOyAvLyBLTVggPSAwLCBVTVggPSAwDQo+PiArIH0NCj4+ICsgfQ0K
Pj4gDQo+PiBpZiAocHRlX2FjY2VzcyAmIEFDQ19VU0VSX01BU0spDQo+PiBzcHRlIHw9IHNoYWRv
d191c2VyX21hc2s7DQo+PiAtLSANCj4+IDIuNDMuMA0KPj4gDQo+IA0KDQo=

