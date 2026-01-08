Return-Path: <kvm+bounces-67377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 47841D03B4D
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 16:15:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7EE6F307DFFE
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 15:08:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3814746BBE0;
	Thu,  8 Jan 2026 13:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZoXgyS3p";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZoXgyS3p"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013013.outbound.protection.outlook.com [52.101.83.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D19350286
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 13:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.13
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767879740; cv=fail; b=oAl4ehpfHzJAA6RdID5OUMhMqhW9RGd6kX7v9UJFXoZXmacjASxXinpPKV9y0Fq68m3Dr/RMfb5HEpjs39O4g7kb+ks5Ol7c0zUcK8LhtumX4JmiyfTeX6mk+KGuTkmp1s4DeYxlxn3Ka5ulcS3iTH10Rwko3GOi0fBAkejPb/c=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767879740; c=relaxed/simple;
	bh=99EzBOB9zQ3uFfeEC82PtOejOE2ZZYIVtJ7PGD0Ce3E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kLJc/Q8mZph24ef3V29g5BmZc/UzxUtRBwpE7Z7iF3bgDNwZai7nutxl3hP5PKJtqdSUIme/YMotSwzAChDjsEqFjtCF7pgCP0IB9Dxr3G6oYE7ORar6LrtqnqEOsnYrMVWpi+U6nuvBbfWCaW2+vArAK8rN9W45Q64iwU+9NVs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZoXgyS3p; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZoXgyS3p; arc=fail smtp.client-ip=52.101.83.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=oRO4KRNWS+EGDSxyE9nN0Xc3aJgFBswCd8UHDbn4CW8xl4e6XNcocLce9Xb1IrvCflZIuj8p0gsDeae7quHpXueUM2Typ44zDgV+VWKOSq5aKGGyyn8FmIq4aEjBpW7hnldn1ISIhD1MivOL12KUi3RpqRNx1GeZ1d81FfxlqNqi5bEQOl4Vin9VnfX4xYI9g1FW+e5XgYRoZ5KwqzpctKX+Lkdf7LjXr4x34pDIXlIQUy1XpitsZPl3om2eoBsLX1g8QH4+isRaNKor6cBiStPvSpCOcZrmAjBZQ7bHk9SBLxLaEaKoS7GV2pZGUxncyvRtpjNMQd6A5QpLiekHTw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=99EzBOB9zQ3uFfeEC82PtOejOE2ZZYIVtJ7PGD0Ce3E=;
 b=vUGmVsqNJRIbN3Yk3Sk51Iwe91zpYgjIwtg1AnF9GEbl/DMBU8Ztaeu9ZdoZeNt6u+VLT1RjDHoz0JQlyQTNUhibJu4CwnHvaBrsaAwip2f8V7NfyQ5i9PDjdQlv+IdHuCdbz0RJff53RWGtUIRXZ7K0YKD5NSnqOLfeO1RcjKTund09wVl60m+WwAbE58fHOO88GcaD7S9Bt+5bf3IZWhbY94kkcOopsYodLevAWVm9UOEiU66E4qDMHBdZDQf/dCwscxHJ2VJy43qmLlXi2ZF4tXYFhOYJhc1RkI0/2wZuMEIvcrMbmIz0r7v1sCnxePP8uOVmsUHvCq0HgErO6Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=99EzBOB9zQ3uFfeEC82PtOejOE2ZZYIVtJ7PGD0Ce3E=;
 b=ZoXgyS3p+/jM7vNmbNY74yDGvJnClKgiS4HaaPwqE5NPYyQI54rOfC3wD0rqTzLO/vX/M9S6zQKY7tBGVvjXrkhUycnHp40Bn2yd1G37SpgrfFIFXPtqKxmxz8kc0uzhmQoZAkQYN9w8K5QfAg4sYv27ourFH0eEWnCrbpAklVk=
Received: from CWLP123CA0221.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:19d::10)
 by VE1PR08MB5871.eurprd08.prod.outlook.com (2603:10a6:800:1ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Thu, 8 Jan
 2026 13:41:54 +0000
Received: from AM1PEPF000252E1.eurprd07.prod.outlook.com
 (2603:10a6:400:19d:cafe::68) by CWLP123CA0221.outlook.office365.com
 (2603:10a6:400:19d::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.3 via Frontend Transport; Thu, 8
 Jan 2026 13:41:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252E1.mail.protection.outlook.com (10.167.16.59) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Thu, 8 Jan 2026 13:41:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jvcn5zcBoiEls0YL0bfJ7LZyVicfqJp/Jij+HtOgBG7zXaO5EG8DbpdeovnMPToKXyM6PcrNCjlZ0ZvM6EpB5S6GfFArQ5fAH0sQgN+4amzXoi2uYXNRt43Z1lq0+FViZjqHki3Cx9eSYHnsHFOTkmaBzfvdwPt7v7DccvcOD94LfXiyJATEQwYxG7ojEkq4+xoVLhe3eBlENLnDhQQMRySjjnu5OROO60tKdSc7flGlE5nkIHnqNhM/2QYRZF61L/gljMKAnwGuxEWxR4KWoLBZrhbnu+YVM5KJsgeHoyhyq4CGRSVE+EbdmMRd7nTiBWigZhiGlfNS3w38R7EzRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=99EzBOB9zQ3uFfeEC82PtOejOE2ZZYIVtJ7PGD0Ce3E=;
 b=LV0W02TbwE52emSySBujXtTVBbapmyswcsEAyqf87j2nFqFHn0Y9VckfkeUPDcpLuf6FCEG/2UWCuXXQOprqkhUlMQB1A65/P2TbV4xdOwDsU8TUv3VMhz6pRjCSkIlxf7Hm2JmbN4dzVAABgxpbb6L/mzmDEA4sQLIGQQc02e5dsmb/jREF4GPQHj0qz81UPcUDI8CommN4wQDRuKyj1+RjA+rhJugB9woE8JMgCkaVJarpnb3Fr72ic3s3HzDJvqEEox+ZsK8tvxUJM0fNetm1DnKpjZWSSQ1+meMaxt16+VAHimILS6kh8LyA5mnv3LNcfKOM5JagAjPzo4s5Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=99EzBOB9zQ3uFfeEC82PtOejOE2ZZYIVtJ7PGD0Ce3E=;
 b=ZoXgyS3p+/jM7vNmbNY74yDGvJnClKgiS4HaaPwqE5NPYyQI54rOfC3wD0rqTzLO/vX/M9S6zQKY7tBGVvjXrkhUycnHp40Bn2yd1G37SpgrfFIFXPtqKxmxz8kc0uzhmQoZAkQYN9w8K5QfAg4sYv27ourFH0eEWnCrbpAklVk=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DB9PR08MB8740.eurprd08.prod.outlook.com (2603:10a6:10:3d0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Thu, 8 Jan
 2026 13:40:48 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 13:40:48 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>, Suzuki
 Poulose <Suzuki.Poulose@arm.com>, nd <nd@arm.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH v2 15/36] KVM: arm64: gic-v5: Implement GICv5 load/put and
 save/restore
Thread-Topic: [PATCH v2 15/36] KVM: arm64: gic-v5: Implement GICv5 load/put
 and save/restore
Thread-Index: AQHccP+BGZDC+5Twx0q4ysOAVcN8GbVGwF+AgAGma4A=
Date: Thu, 8 Jan 2026 13:40:48 +0000
Message-ID: <7d0defd915db9ca1a3fcb4dce70697d97622aeac.camel@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	 <20251219155222.1383109-16-sascha.bischoff@arm.com>
	 <20260107122853.0000131c@huawei.com>
In-Reply-To: <20260107122853.0000131c@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|DB9PR08MB8740:EE_|AM1PEPF000252E1:EE_|VE1PR08MB5871:EE_
X-MS-Office365-Filtering-Correlation-Id: b02e9ce2-f698-4286-860d-08de4ebbae85
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?TnJ4VUVVR29hK1h3WmRFS242cmo0VlFNMUgrL2NQNzlFRkRNT1lSZDBmd2Vm?=
 =?utf-8?B?TFpHSTBsZWNSZUtxUWVtMVRWSSs5U0NHVkZCTVhiWnMybGNIQXpYQlBxN3Qr?=
 =?utf-8?B?Ly9ucjdwaVhZa1RpZ0FMajhMSW1zKzdWUUNKM1NlZXJ5dVlOOFk2Q3p2eTAy?=
 =?utf-8?B?eFk5K2pkblN0Y0FSWnNBTUVoa2F3Q2Y3L082dElneUJPenpzaDBjNks2UGZK?=
 =?utf-8?B?ZEYrNUgxRmRhcXZvbnE1bWN2OHFiWHlBajhITFl6VEhRdDA5V3c3S0pVUU5Y?=
 =?utf-8?B?TDFLbW1OWG9KZE9OV0ZRZG5yYkJndzd0Rk95QTltNzh6dGJaSC9uTWkvaXEw?=
 =?utf-8?B?ZVNNcld3Z2xnQ0s4Zkxrb01UczdxOGRVYVgvS1BKY0NHUlRRWCt3dHpwb3Ay?=
 =?utf-8?B?UWVpLzVmLzRObWhQSmlzN3daK3lCQ2FMaUovbm54VGxGWFkyTERYajh0VVBx?=
 =?utf-8?B?RU5WTklIcnAzUUMzcHJIalNubWRDb1FucnVUT0RPdjNEN0ZVVkk0YnR0L213?=
 =?utf-8?B?N1RXb1kweVlOcTlFdDRwRGRDcG9sQjBWbk9FaHAyN2NKS2U2emJCTm1ldnRl?=
 =?utf-8?B?dktMLzQrZUlwYndWdlhObjRFYmFtbmlwUnUrWWtVVFNZeDNscE5lOEk5bHAy?=
 =?utf-8?B?N3E2U1dHVUlLeVZScDZDTmtWUTJGeWNiaUpzNStHV0xHVzQ0NnQ1ZFZoaHhV?=
 =?utf-8?B?U2RUckRNOGRxV25BTVRVQjdvN1RWblZaN1NaTVpBaW0za0VIemMrdWE5UXlR?=
 =?utf-8?B?aXZrL3dGMUVlbTI5RWR6RXRWTjB5YlUrc2U3cWhleFdkWVFxWTVLRnhwbGJP?=
 =?utf-8?B?NFUvd0tWT1Q3TjRseHYvL29IRVpML2xkN0tzMWlwU2Z2VElaZUhkOXNlZ0hN?=
 =?utf-8?B?eGVsSXZsY3BVZGJETkJuM2xlWTJ5UHZ6enB3Q3lEZG8waHFOZDdOSUhodGFh?=
 =?utf-8?B?ZlhObElnYUxBaGRjR1hCQmxLajF4Wlp5cm50WTUwcFFrYWZYWll0R0VvV1lY?=
 =?utf-8?B?MnM1c21DYkk2d2N6QnRNV2dYQ0NwNWtBODRxSW9ZSEU2RXptdU0yaUNuZk1p?=
 =?utf-8?B?djlJQ3VvU0VSSVhXVXE0QnUyMkhqMnR3eVNjdVo3WVZVRWYwNEo5MklNZWJB?=
 =?utf-8?B?ZU1vVDhlTzA2MEZ3TVlPTTZLWmw1bmUzTzFHSFBFb1JraEErSStWTVhCejh5?=
 =?utf-8?B?ekYzYXVjZm5ETFBOclhKUE1pb202SFA4WXUzQ1p2SnQxQVQ0NUJtdjJ0aDcw?=
 =?utf-8?B?S0c0TWtNNkVKWmE2UXNqTklucDZJODk2QXdOaXVJNEw1T3ZiaW4wcFQ2dXVC?=
 =?utf-8?B?S1NKSG5xb1BSUFRrL01yZkZmcjhRendOcy9IeS9WR0s1YUFQWm8vaUpycGtZ?=
 =?utf-8?B?WlRmcFRTMFZsL3pUdWpHc2NKSk9CWkhXc09QSHFRTFlzTmNOYXVMZ2JIeUcv?=
 =?utf-8?B?ZW1uc2ZuU0IyOVVxbmVObzNubm1aTmd4V0xObmZGb1BPbmJaMEVEMHMySzVQ?=
 =?utf-8?B?YXNCbloyMlVhRytYQTJibVdsT3V3eVZ3ZnNIWGh0bUdvWkR1cEZOYk5ORFRI?=
 =?utf-8?B?RnF4Mi9JVHUyTGZ6ci8vemdZNGRKUWxleFJWOVFZUVJVY0ptUXFXdVpxcHZo?=
 =?utf-8?B?RFR6TG1jRkJodnJReFlKanF4VzUyUzM2V0pMOXFocUNBMHdCVVdHOTMvRmhn?=
 =?utf-8?B?aDJSTWg4TjFVdk9zbXlya1RzaVcrcnlRNDdlUXUzRFlZVjdSSlNNMW1yaDBE?=
 =?utf-8?B?dEZ4Wi9ISGpkRUpFUlpxRDlWU2Y5ZzRwSjZGeWszVmtIdXlsOEVZWGRVNTZL?=
 =?utf-8?B?cXR3T2FrRWRlRHpKT2RwRWkvRU50TEV2VHRqVmRwRkFOQ2hDZVZkem02ZFZS?=
 =?utf-8?B?cTVhYU5GRmFoSHhWdm9hb2Q4Sm5qd0wwVmg4YkdVWUtvQmNzLzd5OWZFello?=
 =?utf-8?B?eG1zamk2MkR2dlBOZjgvREpnTVRvV1g3YnRyZDJVOTF5Y1JDdnJTV2xXVkVU?=
 =?utf-8?B?THRSR2t5dEZXUWF4N3hrcXRQaDNFNHpVdzVVQ3lhUDQvVk5NNlVsRTNwSnNU?=
 =?utf-8?Q?2k1ShW?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <F13EB4432E80D74FBDCD3253F74DE09B@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8740
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252E1.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	32a403c9-5f6e-4244-5120-08de4ebb8860
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|35042699022|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NUh1cVhYMWdDaGhSek5TNUcwdVhBb2ovN2hySUxjMndBQTk2Yi9qMzE1c3Fu?=
 =?utf-8?B?bzZQNlYwQWNMSkJWa1BKbWJ6UlQ1MS9PZW9pdGN5NWs5NjUxRkFYR3c0NXdj?=
 =?utf-8?B?QVNVU2hndmd0UjdjYkxZR2NUZThWVk1SSVNDQ016b2dvRERLM0dzK21yaURK?=
 =?utf-8?B?M2taSFA2SVdXd09GbStsYXROMkticS8zdzhhR0ZCTldNVjhoS1RkcFc3Zkxk?=
 =?utf-8?B?TkxkM2J6Z0Q0anJxSEx2S2Q4cDVMNG14bk11TjJHOHZIU3JvbU9aeDhPdlIw?=
 =?utf-8?B?MzZENFhYeXFLcGhUOVYveHY1WVcxV2FxVVNVNEU5MEIrY1hzZUFjQkJzbHU5?=
 =?utf-8?B?d0tZanBJanlQOUR6SkNFYTV2bk0zN05DODhEdkFjc3BTZU9heDczVjRkL1p3?=
 =?utf-8?B?anZPeFBSbS9SVGNEK294R29BVmRRRm5KbU01ZXdxcFdCSDhueXZueVgyemFt?=
 =?utf-8?B?TnZMM1NxUnFLTlZlY2dVVDEyQitqRlY0RGlEZ0F2TmpXdFBKRW00bkFQQ3Iy?=
 =?utf-8?B?dXdkTlFmTmVoNnpzTHpxR1cxMjVCaGRwYkNMK1pBNitkaUVNSVFDMUdXOTI2?=
 =?utf-8?B?ejc4RG13RlpUYXE5TzdhbERlVVhIbHMwbFV4a3FqUXp5RncvNFQyM1dlYXNO?=
 =?utf-8?B?OXJIOXpHT1lRYXVPcVJEUXd6Sm1BbC96T1hYYUFqL2duR0o1MTlPOVVNVFFP?=
 =?utf-8?B?UFczZ1czbENNMU5JYlIydWs0aVBoMGo4OCtjT0VDYjRoVTJkUzlLbml5Z25p?=
 =?utf-8?B?aG9PMURYVDdSdVdqWFp5SjB0Q1NibE9xQUw0SjBVZDBrc3ZFTHdnckorYWxi?=
 =?utf-8?B?aXhCSDRNOTAxQWZYa3BCeGdxNEtKR1Y1bUV4djdUZmRxWkFaTERLcHAvOFpv?=
 =?utf-8?B?bENHbjJqK2xxcmdUQ1JpRStnRHFHZllleUJXbmpBZUFTbW1OSXhVUXd0alBS?=
 =?utf-8?B?RGhqZVJxajI0VmhjRm96QWtOVXZ3U2d6UWp0amdIZEJOdHF1SytHTFdMZGRM?=
 =?utf-8?B?Y2N2c3Evclk3NUxrOGJpUnluRnJYUSsxbnJtOFJMbmxIeFEvS2QwQmpwQUZq?=
 =?utf-8?B?QjBCRy90Wnk4V2hncXYwNEtQcEhSMEQvREErS2dCVWZoa29pSmFnRUZlYTNB?=
 =?utf-8?B?dVhnVzhOMTdSS0YyVFJaNUpob3VqbUR4K3VKbzNxTVBxY0YrbndBakErYzd6?=
 =?utf-8?B?ODZKdlVubDgzSFNSYitZYWdrbWZVU3R5VlB5bjBHVU03eTZobkE2UVcxWHIr?=
 =?utf-8?B?L1hXQTZVS1NYaFAwSnA4WDlZUy9odUQ0ZUVITXpiQjM5N1hta0VKRzNkc1Bk?=
 =?utf-8?B?dWRncDVUVTVVNE9aSDludzc2blhOVmVaMTVaY00vL1o1UVA2cjEvaHJ5ZnRm?=
 =?utf-8?B?SzR1OVZ3TDI5SGFrcyt0WVhOS1lGTHdsMk54b1I4Q2pYVkxLcmVZVkMyZEVj?=
 =?utf-8?B?cVB0SGx5YlhNQXczODJOSWVvOTVVSjF3azRFaVkwcFlISmxtWTd2YW1uVjdM?=
 =?utf-8?B?L1Z5OGR3UmhRaUcvM2FaNHZTV0VYREIySU9vekJXOTE4K2ZsS2EzQ0s2Ylll?=
 =?utf-8?B?clc1TXBEaXYvcU9xUE5xZDBKbkFnL29QK3VobHVrTFZYb05YLzhIdzZmSHFK?=
 =?utf-8?B?MnVVZkJPYUtmZ0NMZEU5bll1Mjl2YTNXbWRqRS9VY2J0RUR6TWdTVGRpK2xt?=
 =?utf-8?B?TXBCY0ZkN1FLTkFBTlQ1RFNpQmdLSzRWYmk3M2pkWWh3cnJiclRiazdCRkxr?=
 =?utf-8?B?RDZ3UGdNZXQ4cks5dlRnNWY2KzRwMVVvRjRTajlNUWJEVHc0My9hVXVHRUJm?=
 =?utf-8?B?dy8xUU93cVdNRE1adlNVREUyZGRIM0R0dFRTdkNSc2Y4VzFzRU5JeStpMUlH?=
 =?utf-8?B?bjdLQlZVZHpSclkwN0l0NGVRSWZhV0pSZGRPMFZiaXM4L09Zb0g5dWQ3amdZ?=
 =?utf-8?B?UkJPSFByZ3JoRmFoRXpJd2ZlYm4yV29lZjVhL1NuKzdiL213Y3JkbnFMRjM4?=
 =?utf-8?B?ZU9iSU1SUkdLMHJlVHRMVE5LUXE1dy9xM1E3RkhsYXBuQk5uNzVEcUhqMXAv?=
 =?utf-8?B?SXVJbk0yM0tDWEhFWHZrclFpQVRxUmd6OU1NNUY5VHpwOThMUStTcWJFN215?=
 =?utf-8?Q?xmgo=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(35042699022)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 13:41:52.6138
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b02e9ce2-f698-4286-860d-08de4ebbae85
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252E1.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5871

T24gV2VkLCAyMDI2LTAxLTA3IGF0IDEyOjI4ICswMDAwLCBKb25hdGhhbiBDYW1lcm9uIHdyb3Rl
Og0KPiBPbiBGcmksIDE5IERlYyAyMDI1IDE1OjUyOjQxICswMDAwDQo+IFNhc2NoYSBCaXNjaG9m
ZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiANCj4gPiBUaGlzIGNoYW5nZSBp
bnRyb2R1Y2VzIEdJQ3Y1IGxvYWQvcHV0LiBBZGRpdGlvbmFsbHksIGl0IHBsdW1icyBpbg0KPiA+
IHNhdmUvcmVzdG9yZSBmb3I6DQo+ID4gDQo+ID4gKiBQUElzIChJQ0hfUFBJX3hfRUwyIHJlZ3Mp
DQo+ID4gKiBJQ0hfVk1DUl9FTDINCj4gPiAqIElDSF9BUFJfRUwyDQo+ID4gKiBJQ0NfSUNTUl9F
TDENCj4gPiANCj4gPiBBIEdJQ3Y1LXNwZWNpZmljIGVuYWJsZSBiaXQgaXMgYWRkZWQgdG8gc3Ry
dWN0IHZnaWNfdm1jciBhcyB0aGlzDQo+ID4gZGlmZmVycyBmcm9tIHByZXZpb3VzIEdJQ3MuIE9u
IEdJQ3Y1LW5hdGl2ZSBzeXN0ZW1zLCB0aGUgVk1DUiBvbmx5DQo+ID4gY29udGFpbnMgdGhlIGVu
YWJsZSBiaXQgKGRyaXZlbiBieSB0aGUgZ3Vlc3QgdmlhIElDQ19DUjBfRUwxLkVOKQ0KPiA+IGFu
ZA0KPiA+IHRoZSBwcmlvcml0eSBtYXNrIChQQ1IpLg0KPiA+IA0KPiA+IEEgc3RydWN0IGdpY3Y1
X3ZwZSBpcyBhbHNvIGludHJvZHVjZWQuIFRoaXMgY3VycmVudGx5IG9ubHkgY29udGFpbnMNCj4g
PiBhDQo+ID4gc2luZ2xlIGZpZWxkIC0gYm9vbCByZXNpZGVudCAtIHdoaWNoIGlzIHVzZWQgdG8g
dHJhY2sgaWYgYSBWUEUgaXMNCj4gPiBjdXJyZW50bHkgcnVubmluZyBvciBub3QsIGFuZCBpcyB1
c2VkIHRvIGF2b2lkIGEgY2FzZSBvZiBkb3VibGUNCj4gPiBsb2FkDQo+ID4gb3IgZG91YmxlIHB1
dCBvbiB0aGUgV0ZJIHBhdGggZm9yIGEgdkNQVS4gVGhpcyBzdHJ1Y3Qgd2lsbCBiZQ0KPiA+IGV4
dGVuZGVkDQo+ID4gYXMgYWRkaXRpb25hbCBHSUN2NSBzdXBwb3J0IGlzIG1lcmdlZCwgc3BlY2lm
aWNhbGx5IGZvciBWUEUNCj4gPiBkb29yYmVsbHMuDQo+ID4gDQo+ID4gQ28tYXV0aG9yZWQtYnk6
IFRpbW90aHkgSGF5ZXMgPHRpbW90aHkuaGF5ZXNAYXJtLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5
OiBUaW1vdGh5IEhheWVzIDx0aW1vdGh5LmhheWVzQGFybS5jb20+DQo+ID4gU2lnbmVkLW9mZi1i
eTogU2FzY2hhIEJpc2Nob2ZmIDxzYXNjaGEuYmlzY2hvZmZAYXJtLmNvbT4NCj4gDQo+IA0KPiA+
IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+IGIvYXJjaC9h
cm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiBpbmRleCAxZmUxNzkwZjFmODc0Li4xNjg0NDdl
ZTNmYmVkIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+
ID4gKysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiBAQCAtMSw0ICsxLDcg
QEANCj4gPiDCoC8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkNCj4gPiAr
LyoNCj4gPiArICogQ29weXJpZ2h0IChDKSAyMDI1IEFybSBMdGQuDQo+ID4gKyAqLw0KPiANCj4g
V2h5IGluIHRoaXMgcGF0Y2g/wqAgSXQncyB0cml2aWFsIGVub3VnaCB0aGF0IG1heWJlIGl0IGRv
ZXNuJ3QgbmVlZCB0bw0KPiBiZQ0KPiBvbiBpdCdzIG93biwgYnV0IHRoZSBmaXJzdCBwYXRjaCB0
b3VjaGluZyB0aGlzIGZpbGUgc2VlbXMgbGlrZSBhIG1vcmUNCj4gbG9naWNhbCBwbGFjZSB0byBm
aW5kIGl0Lg0KDQpJIHdob2xlaGVhcnRlZGx5IGFncmVlLCBidXQgaXQgd2FzIHVuaW50ZW50aW9u
YWxseSBvbWl0dGVkIHdoZW4gdGhlDQpHSUN2NSBjb21wYXQgbW9kZSBjaGFuZ2VzIHdlcmUgaW50
cm9kdWNlZC4gSXQgd2FzIG9yaWdpbmFsbHkgaW4gdGhlDQpmaXJzdCBjb21taXQgaW4gdGhpcyBz
ZXJpZXMgdG8gdG91Y2ggdGhlIGZpbGUsIGJ1dCB0aGVuIHRoaW5ncyBnb3QgcmUtDQp3b3JrZWQg
c28gaXQgYmVjYW1lIHRoZSBzZWNvbmQuIEknbGwgbWFrZSBzdXJlIHRoYXQgaXQgbGl2ZXMgaW4g
dGhlDQpmaXJzdCBjb21taXQgb2YgdGhpcyBzZXJpZXMgdG8gdG91Y2ggdGhlIGZpbGUuDQoNClNh
c2NoYQ0KDQo=

