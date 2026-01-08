Return-Path: <kvm+bounces-67419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2922CD04A13
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 18:01:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D58873091AFF
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 16:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B64D32E6CD2;
	Thu,  8 Jan 2026 16:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SWCqLCgF";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SWCqLCgF"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013067.outbound.protection.outlook.com [52.101.83.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7852DFA25
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 16:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.67
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767891237; cv=fail; b=G/mx0cjkjVTeVwz04qs5cjSfBRzwyuLsiYWV06LomfzQcHtCU1sNNsoDPzLI9mlkTeCpAYiYCTp5/XiOP9tdyNZp9sFwE0eEfPDleO1dnP/3c+yyC5exg0qJ4egqGHAtAMu+T5kuH8T6JDupX+fmOTAEwD/Jr60jM5fwTUAlvUE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767891237; c=relaxed/simple;
	bh=jXc6HgbZpOBgHAIAYQfb+lzpUfr7ry21gUB2F6NULKo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=k/OhF4pPS/nAEBxbKlXnHDGN/qF9HfIc4n3i2GjoUmSffieIbAAqI7EQ/hgkpSHaG21Ub3aMo1y8G0iqmF/zd0OksszTKcFNDpg2RK9LO4D0xljVsFsptaWrCaT3I21szMgwVV0JMvVImvflnub1q2bC1YZ4VASQ/4hzSHnWnZ4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SWCqLCgF; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SWCqLCgF; arc=fail smtp.client-ip=52.101.83.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=v2IuKsZSqfsvbk+v1eejU0iGKmMRmFewpn0mZs+BI3QYJ3PvvDW/d3pTd7MRxN2JxoJaE4ko8CG2p9fu3Z9MGu56N6Bo3H2lv1wLHfXoO+ovZs7EjgIHxh/lra7hISxZSSDP4xoc8yUQ+EHzDwNhBLPhtbn0MQKv3dd3oedtTJ93GzetrDMhVgE9zgf53MZuJT87Im6IQlNPBasa13SnOGVWMvtvUQ4KyEM6hR7gx44bq1QQIVIgXGAWitPpO2VwLW3GIBf1I5Y1WMYVCoKEaImnXATks+FEOin2qgtStH9g6kkC3yEVAS+nMPnqD1fyKCDms/II0ab0gl0CFImHng==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jXc6HgbZpOBgHAIAYQfb+lzpUfr7ry21gUB2F6NULKo=;
 b=qVnGjsnVIi6gmmEXqhCydhh9D+6mB15rl8Tp/GbGLh/RTKDI39QkxW98M1MAm9E3hmQ/jGxuy5OSFwT15vP+h8EQtCWz13tfPObvWo1ZsTaCrdn7ECGHC68Lt0gcZmXSSdOpnM8JIhZ2sJpUc+JE00WHJYWC9fblWQzhATQH23rvCIuuRnkFViHHdRQdyLAuTv86MFewQcro5nYZs8gSGOFjH0FhRrOLBwqqR4tXjGg4+xkltn3lF8SgK0DX7TCnGHGe8pKzQaMVi76alZNnUavfB+zd8u682R1noqnYOC5owYqdgYnwnhgUlCQhkvDZIQ1qskVDxz7271/8MTsr+w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jXc6HgbZpOBgHAIAYQfb+lzpUfr7ry21gUB2F6NULKo=;
 b=SWCqLCgFtInbm9HagTN0SuddXbun2O58va6j3Azo0fWauK0pn3pCIPMe8w4eu1OCEn9cEEM0Z9fGseq+uxtNhBpEkuspWpn/GVOEY6+SYQtwVv7qjXZNTJ/sNejX5IZDlZLEWArWhyp7aLQeI+kHo/2Ux5HlNt42MY/gFcgp40E=
Received: from DUZPR01CA0008.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c3::17) by PAXPR08MB7384.eurprd08.prod.outlook.com
 (2603:10a6:102:22f::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Thu, 8 Jan
 2026 16:53:49 +0000
Received: from DU2PEPF00028CFF.eurprd03.prod.outlook.com
 (2603:10a6:10:3c3:cafe::9b) by DUZPR01CA0008.outlook.office365.com
 (2603:10a6:10:3c3::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.3 via Frontend Transport; Thu, 8
 Jan 2026 16:53:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028CFF.mail.protection.outlook.com (10.167.242.183) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Thu, 8 Jan 2026 16:53:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QBHvFOgMlWi3rSp7RYqUYgVay06/Px0Kllw0025NVZd9+B84T+A5jH80n+pNhDJfPdJF5Yi21Ek1JNHSSBXFwPh4GsPTvLn0OJCg76olJG83MK9HS4/a/ao/QsDT5qTC9tvF4+DWFbvVVdi0w97ky/dPq/r3QScKMv/aM67Cs7L4fmCZf4jBYYSmTeFI1BSHxrJosHZs5ee6QUSYKI7f7ojktbR0JPbOvYu/BMx/NB72O/mqCs+KgzBHNggV3z7i3AmBZMV1otFS5xLGUl4dkOHYiHW3K19IXiiwDXE2m6RarztyIOfWBmx4g5TYRLcMMxFZJ4bnghSgFSrMwL/JLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jXc6HgbZpOBgHAIAYQfb+lzpUfr7ry21gUB2F6NULKo=;
 b=Zq8YVtmWTeBSdu1jn6KoJyZS/y2VIivT5ocJRtKbWHoPwHjK0gJ0buEx8SW8/O8avaInsFy5WbDnRNDeRsYip0uyaXUbL79YEaJFZ1vUrro0vjkxkQkrkBntz4tKg+2PEURJLCi3YrwGKj0lAKz/jArYqdGW/HKDzfTHHJ/BqhoCfzUq9CqmdIXxpgS+EjI51hRUzPcgEl/WosVzOPOGBUd/z62iH+fpP1XGh4U+uUmwuHeucHhXmOFcNf07Ddbl418u2fWPE1uDWLzYZCHi67qwnFmL5DvQzHKp8hJTFzr7xR27IzTHjvJuE0rpCqwUSHjwaWRcGECiDlgRfn6CPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jXc6HgbZpOBgHAIAYQfb+lzpUfr7ry21gUB2F6NULKo=;
 b=SWCqLCgFtInbm9HagTN0SuddXbun2O58va6j3Azo0fWauK0pn3pCIPMe8w4eu1OCEn9cEEM0Z9fGseq+uxtNhBpEkuspWpn/GVOEY6+SYQtwVv7qjXZNTJ/sNejX5IZDlZLEWArWhyp7aLQeI+kHo/2Ux5HlNt42MY/gFcgp40E=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by PAVPR08MB9377.eurprd08.prod.outlook.com (2603:10a6:102:302::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 16:52:44 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 16:52:44 +0000
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
Subject: Re: [PATCH v2 01/36] KVM: arm64: Account for RES1 bits in
 DECLARE_FEAT_MAP() and co
Thread-Topic: [PATCH v2 01/36] KVM: arm64: Account for RES1 bits in
 DECLARE_FEAT_MAP() and co
Thread-Index: AQHccP9+5jWMu1BdNkKu1sIiC+BHFbVFgEuAgAMcH4A=
Date: Thu, 8 Jan 2026 16:52:44 +0000
Message-ID: <b0659e1fc109052248a967f588c6c5e3604b16c5.camel@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	 <20251219155222.1383109-2-sascha.bischoff@arm.com>
	 <20260106172317.00001463@huawei.com>
In-Reply-To: <20260106172317.00001463@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|PAVPR08MB9377:EE_|DU2PEPF00028CFF:EE_|PAXPR08MB7384:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b5368f4-d7d6-4536-f12a-08de4ed67ec9
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?aHRhMzEyNmw2M0xvVk1aeVRidGNYNkhhaFV0VHp2NkFjTWhXQjZUVFNjSjJO?=
 =?utf-8?B?cmZmWUs3MXVyRitUNDB5aDkzQjFpenByWWxNQWpWSzJoNDE4T05lcVRvTXRw?=
 =?utf-8?B?Z3pSVDNVamhDbFRGMURDbDJmTEltcG5JdlFIMW1WenJUd2ZZUjJvWjRZb3hQ?=
 =?utf-8?B?NGNoT21aNkluaXNzZGxkK2dDMjJuUGk2djZCSmZUOC96YVp2MFNXbUZCbHpQ?=
 =?utf-8?B?b0s3WE5QSnFpTU1WWWkzenZmM0M3NTdpWitNbTZvZ0pUTVpIUGNnMVdaSzVF?=
 =?utf-8?B?ckcva2R5WWRCV2t6VDhVdzhLRHY4ZXBoa2tOdXZpM2x0N1RidllOaHlaSGRz?=
 =?utf-8?B?Mi9nNmdGMFlSRmQ4QWJYV1hOSWV3Vm8ybStLOXp1L1dRazNiODFPM3NjRE9Z?=
 =?utf-8?B?djdzT1Z4VFRMdmp0cGpiTmMvOUkxOGU3SFdSTTdXbzZHelZqR1ArZGREaFJV?=
 =?utf-8?B?RjBmNm9objJyVlBDZVplVzZBZWtrRXExRDJCZ05vYytlVnR5RHE2WUIvOSs0?=
 =?utf-8?B?NmRjTkRsMjJjKzM0RVc2TmcvRXhKNkVIWEtLb2ZWTDNkQXRqU2JOeUkrclFI?=
 =?utf-8?B?K1liUnhyMmQzTHVBK2o5YlJWRVVtOUFrT3hldjk4UGIwNkVveVpXRHFWbzlm?=
 =?utf-8?B?cUpKaS9nL0FhMjJEWHhOY3gxcWdLUEFuNUlFMzNjY3R3OEcxNkl6blZKYUNL?=
 =?utf-8?B?ZlVETzNDSkVkTkdMWHF2bEZPbUc2MUpWRTA0YzEyRnM0N0ZHclZjZVEzRFhG?=
 =?utf-8?B?RFNZUk04R0JoZjRQa1U2Q09ZOE5lSlkzUUhMeDF6SFBPanYyRU5DeGU1cUFY?=
 =?utf-8?B?VkE0eUFROGtRcGZlWTVuVmQ2WkNRakd5Yk15Tzl4SS9NN3VOYU5Jd2hENS9w?=
 =?utf-8?B?YXpzYTRhUzdLMjZOdjZ4NmFnK041WUxlbjR1aG5YM3FLU3FaRCtEVWFYMmx2?=
 =?utf-8?B?a3lZTjRPMFRGRDVPSU5TK05HT0lOdjlsZnRRVDNIQXFWdUEwd2RUcVFicjEx?=
 =?utf-8?B?UEFReUEwMnZwTncyYUNNajNJQ3E3eXhaMWV5QmhTajFZSWNjbU1IaTVjNGVS?=
 =?utf-8?B?M2NJNDhRc2h1VVZUb09tMm1tdkc2Q0pPaCtZckQvQ1NNZGc1SVBSL1drUWdk?=
 =?utf-8?B?aDVhRjVpVHhCNEJKcFBNZ2t2WHBxZTZNYVVRem52czc4ckE4WUwwSzN4Tkx1?=
 =?utf-8?B?SStNVGRYamRvdFc5WDNaVFhJNSt6ZE9oWlNiUjZ2b0s2cFdxTWduY1VQMEV3?=
 =?utf-8?B?VlZNMEhlVzRrNVBGZkZpZWJLdnhFRmpTaDFFcmpxaHZvaUFGTHdiUjdXb2o5?=
 =?utf-8?B?bk5KSFp4UkxRNFNkbzJKUkhzalNXMmdCN1pxaFJhQTJxQjNFZ3RBK1MveUVR?=
 =?utf-8?B?TVJFdFJIN1I3dTdZZkVWUkQrZFUwYjZwTEpUdThEdVl3TzJ0UW11SjRsWGFE?=
 =?utf-8?B?QTlOV0ltaWZpOWY5bGtVQ21mYXRMZUo2RnRrOUdmRGRZM1R4OEFqMWRqRjdo?=
 =?utf-8?B?bFlVYUltU1d3bVRIVXdyZE1kMzhOTG5FRmRpVzExRCs3dmZBcnZTQ1Vwbmwy?=
 =?utf-8?B?SWdHYjg1WUdmbnFxcWtIeGtZajQ0ZHp4S25DRTJSSG5TcDNyMGgyUWloK2lo?=
 =?utf-8?B?WCtSWWt1dkVXVlQ5VUI2dGU4YkpiV2NhK2wxUjc1bWVZYjZpNU1hWnVRVGJ6?=
 =?utf-8?B?bTg5MkVZbno0K003ZXJGYzY5NHRJTUhQYmdHbTVSN0ZGZEVMNTVxRXdYY2xR?=
 =?utf-8?B?eVpaOTg1WmZEYXVGL1NNYUFwQ0tZVWxrcGQ1TU5GZWpZYzFCL3ptcU00N1Nx?=
 =?utf-8?B?NHFCeDZaUU5IcWQ1R0Z4SUFTekdFV29xbnMyMmRjUzE1b2NpOXE2WUVsMHhq?=
 =?utf-8?B?cWpVZEp6ZEkvTFQxSWh4TjRBVnZ0R09nSnViR1FHbzI4UE5RVElvZHhFaXFu?=
 =?utf-8?B?ZEltNkQwN2xBNFJqUnkwWHVvU1A5NmNOeXdwSVF3UmZPWE8vdjJnMWk4Y2F0?=
 =?utf-8?B?TFVlRCs5dmJ2QTVzWEVuMUdpSzJuZFRhMzhLTk0wemdYVjFpZm1zT2dncWFM?=
 =?utf-8?Q?TVbxU9?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <643040BA828F5E42A86062E94288DF33@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9377
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028CFF.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e3d392c7-e25f-4911-72ee-08de4ed65880
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|36860700013|35042699022|1800799024|376014|82310400026|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VVFNNXhtVllSWVREK3hkMVd3UFJYQ080TDVtb0RBd1ZBVVJIaFQ5eDc3dk1k?=
 =?utf-8?B?a05BWU5aMjd1WlhwMkxKbldZR1o5MStuYXZlbFJ4cmRqQkwyS2F2N05ROFBX?=
 =?utf-8?B?VHRpU0o4VUpFWVcwMkNzcDdiNjZXQVllaFFwK2l6TVhnUDczdmlzMzJCMldI?=
 =?utf-8?B?NlllWXdQZTI0MUxLNVZGK0tXSlE0eDlmZnlES2hvajVkeWFJK25PbWI2Skox?=
 =?utf-8?B?RGJCNTN0S0lINkw3YnBqWVJDNnJ6SWhsaFZrZ3dMQzhod0ZGa2F6MFFCbjA4?=
 =?utf-8?B?NlltSWdwMkZTUW9xVGhlVkV5enNtMnV6emlsUFRhb0d4KzhOZ3RhSS9VaFor?=
 =?utf-8?B?ajdNYlpNVGZWVDd6UmsvZ3F2MVZVT3dTUWovSnl4Q3lGZk1uSGxwTVVndmV6?=
 =?utf-8?B?N29aTlZsY0NuSmg3WVBpd0VheVJXTldrWnN0THp5L3ZpU2YwanRZMEdKMFpR?=
 =?utf-8?B?YUZHZ2srd292STNqS1d0Qjd6SkhKZzFVSlFJVmR0elppSUQ1T3JJSGtpWlFp?=
 =?utf-8?B?SENOQkIyZENZYXRRbDRIQmtobkdJRUF0LzB4L2swc0FsS1VMN3FoK1ZwY0xB?=
 =?utf-8?B?akhOM1l2OXplVkU1TjMvem1UTXRGcVplb2gxOURFTkVRdk9wSlVIV0hiWXB0?=
 =?utf-8?B?R29veWNtVWlvdDRVYURIb3hhUmFrVzk4bFEzdVpRZUQ1bXpzem9ubmh1bUZF?=
 =?utf-8?B?WjVlTlI3YkJmNGo4T1VndGt6RVA3Q3JqZ0xDdDBKS25SOS9DdzgrVTQvSGZi?=
 =?utf-8?B?RFdIQWsreDVNNURJN0hvUWVXMU5qT1U4RmE4SFZjL1U5Qkp5S0V0MS95WG1i?=
 =?utf-8?B?Zit6Y3l2WE5pOTE5R1JROFNJeDkrSzltd1d3QUNEODhPOS9RQ1IzaitWKzEz?=
 =?utf-8?B?dU9EZFRWV1RxNmxBZVFXek50aU5WaFkySmdqMjVjUnNwbysxUzNmdlpjVFE5?=
 =?utf-8?B?M1hkUHJzaUx4Ny91KzIxdkJRbG1wT0pJNEh1bERIV1lNUC9nalU0RGsxYTg4?=
 =?utf-8?B?SkxrUytLTUttcVo0T2hyUUJJN2V5SUdiM1FZVzJMN2UwajdRbWhhdVNhblFn?=
 =?utf-8?B?MmttdlhpQmdGMVlPcUhuZzdZRDRqeEUzaWhkTXVCWnNEZXhNUW1uQmE4YTBD?=
 =?utf-8?B?QkVEcnZHL2dCb1pLSlhLZlhnRUQxS3pJT0d5YVVPMDdMenpVK2dwZXowODUw?=
 =?utf-8?B?WnU0NzB5NFZNWjc5THlxb2FJMjlnWEhnVVU4MVhma2tpMC96WmU3TVliSkYv?=
 =?utf-8?B?N3crdUpLcW9nY1VkYUgvSU9CbmhoaElEcEd3SEg0bWVFVkJZZDV5T1NNWDh0?=
 =?utf-8?B?S1VPTEdrSFZTK2RnOG5tYjZ6REgwU3pqeTFhZTQybnN3Lys1NlNOWVp6aUF1?=
 =?utf-8?B?aDVRK1dEVFNBZWNXKzJnY0dtUTJqd1JSUFpOTGtqcHNIVTFoRHMrYjhQTlZK?=
 =?utf-8?B?ZmpHeGVJOTVRNDcyR2oxS1pHRmw1bDVxVUsxV3pwczFrRVUyNHJxMDF4MFBn?=
 =?utf-8?B?Ym53OXZkQ1A4b0ZabmJzajJyQWE3bVpmbmEwUTFycW1YM1F4T1hiVzZZeFFr?=
 =?utf-8?B?clBhSkx4NEVhbFBzbWNjeVAvYWFwNFIzNDNrYThKN0hXcGNPUXR1dGt0ck5r?=
 =?utf-8?B?SnZqTmFUNlY4by9vWFBsNkF0dHc3cDJDdHpDSWh3Ynl4RWlnZlhaUmlIdzRT?=
 =?utf-8?B?SXdIUGNDZWRFYzNodFd0eHQ4akJKOUFiTUZ6aTR3QVJHL1B6YXhkQVgybGxU?=
 =?utf-8?B?d002Z3R4andMVFpnN3NVRU5KbTliYlpORnhMbjhmWXBmaUw3OGpGQ1RRY2I1?=
 =?utf-8?B?S0R1SGF4eGdVWEs5QkNLa1NtTjdxQ2lDQktqc2pSeEJGZW9PVWtEdXErazVP?=
 =?utf-8?B?RU10YjA1eEJKNXl4RUd4UDhrU0c0Rk1IU1BiSHNONXRhRFNuSVI0aDlJaTQ0?=
 =?utf-8?B?ZmFIZlNmVE12L0JrSm1kYjBiNjdDeGtvRkVObmkwVmZ5dzAzK3V6cWtsNndM?=
 =?utf-8?B?YnBYYlVhZ1EvZXB3TG4rUzkxVjRLNHlPQlN6MUFKOThuUHBtNGd4RHBLM0l1?=
 =?utf-8?B?T0JSdm9WOXNRcmlTNDJhaVA1YlZST0xLbTRPOVJqZVlWV05XYjVoekRlUzlV?=
 =?utf-8?Q?h4MM=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(36860700013)(35042699022)(1800799024)(376014)(82310400026)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 16:53:48.9227
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b5368f4-d7d6-4536-f12a-08de4ed67ec9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028CFF.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7384

T24gVHVlLCAyMDI2LTAxLTA2IGF0IDE3OjIzICswMDAwLCBKb25hdGhhbiBDYW1lcm9uIHdyb3Rl
Og0KPiBPbiBGcmksIDE5IERlYyAyMDI1IDE1OjUyOjM2ICswMDAwDQo+IFNhc2NoYSBCaXNjaG9m
ZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiANCj4gPiBGcm9tOiBNYXJjIFp5
bmdpZXIgPG1hekBrZXJuZWwub3JnPg0KPiA+IA0KPiA+IE5vbmUgb2YgdGhlIHJlZ2lzdGVycyB3
ZSBtYW5hZ2UgaW4gdGhlIGZlYXR1cmUgZGVwZW5kZW5jeQ0KPiA+IGluZnJhc3RydWN0dXJlDQo+
ID4gc28gZmFyIGhhcyBhbnkgUkVTMSBiaXQuIFRoaXMgaXMgYWJvdXQgdG8gY2hhbmdlLCBhcyBW
VENSX0VMMiBoYXMNCj4gPiBpdHMgYml0IDMxIGJlaW5nIFJFUzEuDQo+IA0KPiBPaCBnb29keS4N
Cj4gDQo+ID4gDQo+ID4gSW4gb3JkZXIgdG8gbm90IGZhaWwgdGhlIGNvbnNpc3RlbmN5IGNoZWNr
cyBieSBub3QgZGVzY3JpYmluZyBhDQo+ID4gYml0LA0KPiA+IGFkZCBSRVMxIGJpdHMgdG8gdGhl
IHNldCBvZiBpbW11dGFibGUgYml0cy4gVGhpcyByZXF1aXJlcyBzb21lDQo+ID4gZXh0cmENCj4g
PiBzdXJnZXJ5IGZvciB0aGUgRkdUIGhhbmRsaW5nLCBhcyB3ZSBub3cgbmVlZCB0byB0cmFjayBS
RVMxIGJpdHMNCj4gPiB0aGVyZQ0KPiA+IGFzIHdlbGwuDQo+ID4gDQo+ID4gVGhlcmUgYXJlIG5v
IFJFUzEgRkdUIGJpdHMgKnlldCouIFdhdGNoIHRoaXMgc3BhY2UuDQo+ID4gDQo+ID4gU2lnbmVk
LW9mZi1ieTogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4NCj4gRldJVyBpdCBzZWVtcyBj
b3JyZWN0LsKgIFRoZSBvbmx5IHRoaW5nIEkgd29uZGVyZWQgYWJvdXQgaXMNCj4gdGhlIGFzc3Vt
cHRpb24gdGhhdCBpZiB0aGVyZSBpcyBhbiBlcnJvciBiZXN0IHRoaW5nIHRvIGRvIGlzDQo+IHRv
IGFzc3VtZSBpdCB3YXMgcmVzMCB0aGF0IHdhcyB3cm9uZyBhbmQgcGFwZXIgb3ZlciBpdC4NCj4g
SSBndWVzcyB3ZSBjYW4ndCBkbyBhbnl0aGluZyBiZXR0ZXIgaWYgdGhhdCBkb2VzIGhhcHBlbi4N
Cj4gDQo+IFJldmlld2VkLWJ5OiBKb25hdGhhbiBDYW1lcm9uIDxqb25hdGhhbi5jYW1lcm9uQGh1
YXdlaS5jb20+DQo+IA0KPiBQcm9jZXNzIHRoaW5nIHRob3VnaDogYmVmb3JlIGFueW9uZSBjYW4g
bWVyZ2UgdGhpcywgU2FzaGENCj4gcGxlYXNlIHRha2UgYSBsb29rIGF0IHN1Ym1pdHRpbmcgcGF0
Y2hlcyBkb2N1bWVudGF0aW9uLg0KPiANCj4gV2hlbiB5b3UgJ3Bvc3QnIGEgcGF0Y2ggdGhhdCB3
YXMgd3JpdHRlbiBieSBzb21lb25lIGVsc2UgeW91IGhhdmUNCj4gaGFuZGxlZCB0aGUgcGF0Y2gg
YW5kIGZvciB0aGUgRGV2ZWxvcGVyIENlcnRpZmljYXRlIG9mIG9yaWdpbiBzdHVmZg0KPiB0byB3
b3JrIHlvdSBoYXZlIHRvIGFkZCB5b3VyIFNpZ25lZC1vZmYtYnkgYWZ0ZXIgdGhlaXJzLg0KDQpU
aGFua3MgZm9yIHBvaW50aW5nIHRoYXQgb3V0LiBBcyBNYXJjIGhhcyBwb3N0ZWQgdGhpcyBmb3Ig
cmV2aWV3DQpzZXBhcmF0ZWx5IEknZCB3cm9uZ2x5ICghKSBhc3N1bWVkIHRoYXQgdGhhdCBJIHNo
b3VsZG4ndCBoYXZlIHNpZ25lZCBpdA0Kb2ZmIGhlcmUuIEhhdmUgYWRkZWQgdGhhdCBub3csIHRo
YW5rcy4NCg0KU2FzY2hhDQoNCj4gDQo+IEpvbmF0aGFuDQoNCg==

