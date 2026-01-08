Return-Path: <kvm+bounces-67421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A07CCD04AF0
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 18:06:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9D3D030617C6
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 16:56:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D296F2D3738;
	Thu,  8 Jan 2026 16:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NRP8QDYf";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NRP8QDYf"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013019.outbound.protection.outlook.com [40.107.162.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B72F25392A
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 16:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.19
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767891402; cv=fail; b=QwItVUpHMxpa5lRxzgJulky+zZRUW5aRIdN/Tz20N0j6KrXEaamyys9OzAe1N1CpahJSvJR+n7AdH9S19Yu/3r00NT0Et/L6o0nErgHPnPzZfiCqcsStujEFWjiemkI6qzPq1MrrhvGapeEGsJ2dnTj6OKW9U/jltVlp18WPg4A=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767891402; c=relaxed/simple;
	bh=nL0O5tYWCUq1F9eqQRVzd+ymUvYUScpMkQn+6C6QrZs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XEvn1EAGVq/FNYopmMlu+gDj4VppRjner2IDdqC3zoSFg7YEi6MR0U21wreZxjgYRYNpdCI73mfa6U1Jfap1iqubX9E+yEFxUkQc77S4X2VCt10cMh4t46noXLNCgBl1mfeONdopvJhvA/QFq8MRNOu4DqnPsKgotA0HQdVI0ag=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NRP8QDYf; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NRP8QDYf; arc=fail smtp.client-ip=40.107.162.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=lOfFTNwhZHBynnHMaRIsu2q4Hy6g14EpNYboYgH4GTyKp2f5y+u7aTij3DyGp7xhZBu3FrDZQV0s8z+gQnIrP8qK/Zq+QHfaAMw8g4FEZEGtQiT5w1SNxaQ8YkAYGmGrOW6wY16iSL5jX1XbddfvdpDZktjEdJfzscb8or6AqUW9CxyULxPDTInrPtHvi0224CLDQf4HaAhFQa5kosAZ/uE8Ll35Wdx3SDU5dul4vORp8NJMjBWW3hgzFwcNJNaWfs6rcmCgwSaNOwHWqtfU63MCQd7ITl7WAMcgi69SYqmOz9GnjW0yxuVSsNuKMBdiMRU2KiSxuWVZPBQIZ36hNA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nL0O5tYWCUq1F9eqQRVzd+ymUvYUScpMkQn+6C6QrZs=;
 b=k7k9MA/o77V/DHjEYTOUdE3pkCZkWHuq46/0rPNsahixsEz4d+eN0d8zCtnWRH5YDQmszqsTNQ+ttOl2lUs+LGWhFaKOeX3sVl+tuGLD3YCD1WgX2kLssRcfvxQ3ML3KWDtPoGtCJ5E2k09weNXZx7e3ssrpwDl61atYJfx7MMb1VO30+Pdyzfwe/gdNAJKMwqf2KIyeh0ht9SGpffICHANXv7OdE+/E/slxU94uMxKVb9tisGBypWLjzD14RUO8EwAQEsn3gTsLkx28Rsp1UgWTHFR/Z2hJAhModz6KxV2dd0BDrNgzW1gG80CRDHm/zrPVFu7P+c8rT+1J/2rcQw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nL0O5tYWCUq1F9eqQRVzd+ymUvYUScpMkQn+6C6QrZs=;
 b=NRP8QDYfwyFoZ4oSKBU4myDZzzCgf6ejz+HvCTmpB2MXPb2X8NO6tIWyJsnkW4LBw2IesrOgP6Snl24lyldZ92sgmdCnbr/75bLQxD3cBxCph73BpTshikmAkCxdZQCl6lFDSuS2y3PpnD/d1IsK5ryRNQPsCUuHWjUAJ4JsWeM=
Received: from AS4P192CA0010.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:5da::17)
 by AS8PR08MB9576.eurprd08.prod.outlook.com (2603:10a6:20b:618::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 16:56:32 +0000
Received: from AM4PEPF00027A67.eurprd04.prod.outlook.com
 (2603:10a6:20b:5da:cafe::ac) by AS4P192CA0010.outlook.office365.com
 (2603:10a6:20b:5da::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.3 via Frontend Transport; Thu, 8
 Jan 2026 16:56:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A67.mail.protection.outlook.com (10.167.16.84) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Thu, 8 Jan 2026 16:56:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mdrmgkKhq1BRwrTyjnppPQyYEM8FKNc8THvWzuqwdC+rvq3md0z7Ub/S3JHOl6lvnFA2kevzlun1c/M/4eroD1pNlO7uv6QoHPNOMo8kthxg6JUpNgZGQ0KzkiOLWDlWLXqrZ1MStya1lfDmrZ4eERltNND0jlU7a3mi83t3YS+V5Z9nKKAYe1rRDYKbneR7nm6ElKcbWD4BMSqkMUHg80qzvnpt+w2vTnlFt+j6pQYJ9B/dyIQB2eSU1iNKaDHQGz1jXgEqQHKj5tW10m/5utpPTmnv6VGEXOD3EPJ/yOBRpE3H9YUdMU/0FScUzqdopxf0X5avLCsCPlpqsy9XFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nL0O5tYWCUq1F9eqQRVzd+ymUvYUScpMkQn+6C6QrZs=;
 b=d1kW7svwaJIExXGWMmY3H6fMGrnC30QmgITk//Osh2qfkFr2CQH+MokL5HmFXnRRxL3RAQ8hniTP+2Bjc04W5WRd+wsT0XQOy3fKcrERBzthaTXehDiA3Rl6xU9Or2fHiAq3LQKwEIJQwR7epMhEu/Hiah28UhU7Jvldp8tD7CYzgETq5syKA7GF0OatSTsIQEod7U7vypEEs7LvwkBHDXeSbKoxBvdUXUOqfVIpzIsMcfzQn5tJPjJOyIEBGPHv5BiiwsgXiUxOfZ8wtT2Y/PQP1t2DGRPwsPL65qLQpn+Kz1zCyiu8PyTnqmNXxOK5r3IBz8IC0kr7D0hTS9wvug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nL0O5tYWCUq1F9eqQRVzd+ymUvYUScpMkQn+6C6QrZs=;
 b=NRP8QDYfwyFoZ4oSKBU4myDZzzCgf6ejz+HvCTmpB2MXPb2X8NO6tIWyJsnkW4LBw2IesrOgP6Snl24lyldZ92sgmdCnbr/75bLQxD3cBxCph73BpTshikmAkCxdZQCl6lFDSuS2y3PpnD/d1IsK5ryRNQPsCUuHWjUAJ4JsWeM=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by PAVPR08MB9377.eurprd08.prod.outlook.com (2603:10a6:102:302::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 16:55:29 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 16:55:29 +0000
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
Subject: Re: [PATCH v2 24/36] KVM: arm64: gic-v5: Create, init vgic_v5
Thread-Topic: [PATCH v2 24/36] KVM: arm64: gic-v5: Create, init vgic_v5
Thread-Index: AQHccP+DB9N8LwWvhESuT1tUOl71FrVG+FiAgAGk1oA=
Date: Thu, 8 Jan 2026 16:55:28 +0000
Message-ID: <558cecd63bad7f180024ff944eb5fe04a2197d2b.camel@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	 <20251219155222.1383109-25-sascha.bischoff@arm.com>
	 <20260107154913.00005193@huawei.com>
In-Reply-To: <20260107154913.00005193@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|PAVPR08MB9377:EE_|AM4PEPF00027A67:EE_|AS8PR08MB9576:EE_
X-MS-Office365-Filtering-Correlation-Id: e88ed406-3a84-4fb0-7a19-08de4ed6e033
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?MGFNaC9zSjJqakY3NUd3UlRrSDZUYmVvQWt6eHllYVdydGs0WXNmSjRhWGkw?=
 =?utf-8?B?MDRac3pWUmh3cG5EWE00SWVoZ3M5c2V5SUFzdEJIWnNLZmV6eXpGRmJYeVpW?=
 =?utf-8?B?OXc0K2xlUUJzVWNYSXNGVXFWVmkyYVp3ZlI1OUJqOHkzQ2FpQW5UeDlHQXdO?=
 =?utf-8?B?eFVldUhBaVBtUlJPM3BiTjU1UDFCTWdkMVprbWE4Y0djOTQ3WTFsQ2FRVWhH?=
 =?utf-8?B?YnFnLzhWdDRhaE1sY3dpVk9TRzZDeXpWU0Y1Snc0R0RRbG1lNVBOTlZSVitD?=
 =?utf-8?B?aEwrN0RIZ3hMWDNlTkhqcVVrZkxpdzl0YThPSGgvcWU5ck1EaVFUdzk3cGNH?=
 =?utf-8?B?a3NzMUhBeHRHcjUwalMzODBVejRYT2NMSFJ3K0FxZU5EVGlHdHVLb2pIVWhI?=
 =?utf-8?B?ZEFOckZLbmxqSU03NnpOMGRuQ1ZVV1VCZzYwaDZnY0NrMkI2dUxraCtpdjhL?=
 =?utf-8?B?TTltNEFWa0tHbDlmZ0p3VS9vYmJnTVA4SERMR1VZRmlZWEF4dFBHeEpMWWlm?=
 =?utf-8?B?YjFwWFB4aFF1TmN3ZGpacW4rSWpkWVV2bnBQUnErUmkyMGF5a2N1ZUQ1WkVU?=
 =?utf-8?B?VlRFNXc1UEFRZ1BRSHVka2FEZUVOcVV4OUVUUWJ4OEtjcERzS3pNZGxBbXVa?=
 =?utf-8?B?VldGbWpMNXh6LzBWTjNPS09ZaWZaOFN6bVZGRDdPZkVpUUZQL3FHelQ2cWlS?=
 =?utf-8?B?cktqZFUyYUN0REEwOUFuREdOVDlSTVRRL05OMEhLdWxZM3FvNUYvcDRSdDhR?=
 =?utf-8?B?N2VSZktLbk5DaFpXN2dSSlVJWW5tRjh5SVkvcUkxWTRudmxNNytrYVBWM2xG?=
 =?utf-8?B?cDluS3VGQWpOelJvd0RteVNUd0k5bnhvdzQ2ZXJVS0tQNWhIV2dteDRXY1ZB?=
 =?utf-8?B?Rk9kK1JIdUNXUUN5Sm9ydUFOSXRkL01MaGVZZ09meWd0UTFvdVFXMEgzeGVo?=
 =?utf-8?B?SU5SdEVpcWNldCtHdEFPUTkzcnpoRHN0WEpGSmVsMEFDVFVBQUR0cHdXT012?=
 =?utf-8?B?RnBSaEtxWVdncGtpWWRMeEFRT21qUEt5NTFUc2pCWDNnd0ZnRE9tNC9IeVRr?=
 =?utf-8?B?ZEFIbng0MUJCUXF0Tml2UWFpbk02YVpnYVl0UlhaQ05ER1EySVo0UDZraC9m?=
 =?utf-8?B?TmZhWG9lMlJhZm82SHYwWGduNjVXdmNPSzBYKzZlMzhkb3FEYThEOGZqSTdi?=
 =?utf-8?B?YzVlcEQ1S2t0VGdUTjM4WmVTSTVDU1p4NjRVb0YvVzk2MXZuZVByMGxTdEJQ?=
 =?utf-8?B?elN4Q2YvK1RpNDhMTVR5SFJBWTExTzhBcEp6L1RuV2dodHJINmdrRVZEQU13?=
 =?utf-8?B?dzlsd2tNa2tEU0FzL1Bvdk00dGp5Ym84MlZBR3ZYbEZDNmdOYmY0SXZuNGpP?=
 =?utf-8?B?VVpVRWl5VmUwSTFWS3U5Tm0zczNBcEhNY2RoR3lqQytKTUY5aDdSV1pJQmdp?=
 =?utf-8?B?TEhJWGJSN0xEZHU2S0FOQTVlUVdCQnFPdENZMGFuVEJMYUEwWWJoSTRQSFY2?=
 =?utf-8?B?ak1BUVAxeFh3OVJBL2c4SGhtcm8yMFR0aWtqbWdBSys2MVdLMTY3ckpGQmhI?=
 =?utf-8?B?N2ZwYTcvVmlPeVJiZHlrZTZGUXVISmRZK2dsZk0wSHRRUy90L2Y0MloxTFhV?=
 =?utf-8?B?SjBYbEZSck4rWXpaY3FkZ01GSlZRUW82WW1zc1FpWkdyd1ZFOHVtdVdKaHNT?=
 =?utf-8?B?R0RncWk3TDlTdVFzUTJTUEgvQ0FCQ0VIOHRlY3NsWFJNZmYrZUdFRkpVbUxQ?=
 =?utf-8?B?QzZPVS9ZTUphcDc3Ujg1RzRmc1dNQ0VKalNLbkpYYzBYZnN0SXdscnYwNnFQ?=
 =?utf-8?B?bGpEUHlxZlRnNWpvOGNRRFd3bTBHVHB1TS9aZ2c5aDhVRzAraS82TU9aTnFN?=
 =?utf-8?B?RTZTNGtrekdYa0JMbnFnQWZjZUxuWVdxRW4wK2d1YlZmRGUyZitNSzBKMkhZ?=
 =?utf-8?B?Zk51VG1QMkpQTHpBRXFlYnFOLzcxL2VPeTNjRXUxV2pXdm9YWGl6dVFaRmZi?=
 =?utf-8?B?cDlyNGlDVUpxZHRxejdFSFU3dG5rYldFdHA1OVp3QzF0OEJmbTExQmo1bEUv?=
 =?utf-8?Q?x9TLyo?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <DFBCD636402CA642B38D17FC05086A24@eurprd08.prod.outlook.com>
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
 AM4PEPF00027A67.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5adebc1c-ab35-4a04-df7a-08de4ed6ba5a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|14060799003|376014|35042699022|36860700013|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RHVjWXQ3MTI3Vk81b1RmdVlhUjQ4Yld2ZEVkYkxxQ3V0VVlSYk8zTUZXai83?=
 =?utf-8?B?WjNvUHY1WE01QlhHRG9YRnZnYkdxT003eE42UzJFSzZxYkhjL1lYWjhtYmlL?=
 =?utf-8?B?SW5PV0xMTlR4WWVSLytDakdUSFI5M01GN1AwVVlOL1pIRGxXdk1MTnVhcmJ6?=
 =?utf-8?B?cEdoVVEzMlVnNCsrZHdyQUFBaXZGRUhnSUFZNVU2cEl0bVpPMFNUc25IRDZu?=
 =?utf-8?B?Z0xwZkE1dk1GdmJNKytnc2FxYUhCZ1BNWmNDYVdsdjg0c044dlMzVDhqZXBX?=
 =?utf-8?B?cFQ4bVZwK3NkNkgvVWJ0UkVqWGRIRjJoSVBnckxPa2U0eDRKbzBVZnI2ZGZi?=
 =?utf-8?B?eG1IS0pDb2FScUpvM1lFcUdER0VKTFpLVzZRVWdWMkRueGM0VitJNHdjakxN?=
 =?utf-8?B?RnZYa0xCT3NrbU9SVVpkd3dHY1JBRm9IT2VseitMUHN0RjlHYzdNVWg1VkdQ?=
 =?utf-8?B?eitEUnVjdTROdTRDdUpmdmx5cnp4WGgvdkZNM0VPRHlzUTNqK0NKTlVjdWNk?=
 =?utf-8?B?Y01FQjVDdjAwSXo1V1RBT2Z5N0ZORTNHc3pQWHhlRmxTczVPT1pBeW1ZOU1v?=
 =?utf-8?B?WnNmMklQK1dZUVYxSVNFVUtia3M0NVhTaVp4VVNNYTlaekt4Nzd5dFdpbW16?=
 =?utf-8?B?ZUpNTTR6WmdNUTQxaU9qN2NBeEVrYUk5ZU54Wjlha3piRUlzeUN1eTJ0Wmw3?=
 =?utf-8?B?VHAzM3Z0NndWSWRwdEM0MklydzZZWEhEQ2UrQmt3ZHBGNElNbzIzR3RrSk5X?=
 =?utf-8?B?emVSNzZNNkc0NE5sY1kwTnVKbHp3NlUzVUhPdngyZUgyWG1QeVRxNGxRb3Fz?=
 =?utf-8?B?Z0NTdWQ5QVMvaWJFclg4S3ljd1BqMGl6SHoxd1lFZDgxejl3Y0R1UDRYWlk0?=
 =?utf-8?B?VXpZcDRJMER1NDcrVStqbGF3cWxUUG9USVcrYzNvNmFLSDZhR2dTL1I0c2pR?=
 =?utf-8?B?SXgrNFE5WlphVXZ4ZGszdW5xRmJ3Tzh3NTVZYWVOMHNKZTJEa1FxL1FuRUdU?=
 =?utf-8?B?dVdKbkRCdzlNcm0vZy9BRGluODlvOCtLNG9RSDROczQvUUtaN2RlS1AzOEtj?=
 =?utf-8?B?R1NYWHlYWm9hNkRGMjMzdDYwak5kODFKTkVGNnNaWlhuNG43bVlmWmFqanhs?=
 =?utf-8?B?b28xTW1YYmw4RDZQWFlNTkx1WFgxWmRGTzFZaEJZdEh1WVNjaXppK3BXUjZH?=
 =?utf-8?B?WUxHUUNISFJIR2xmWUF1cGxwN3hLMlh5RUlQTzVGUGRiTEdXclUxbThJNFBs?=
 =?utf-8?B?RElJTVhxblFISFdsNFBwdVN2YTBPR3Juc25qbGFDUE9yUGxkSXYrRlNRak5o?=
 =?utf-8?B?ZXlEalMrZWhLYVFqdmUra0lVR21ibXoxMUtWcEdBWXdML0NPdFIzNThVUlE4?=
 =?utf-8?B?R3V6TzBaTTRGdHRvVVloUWRHWHBaVTZLejJwN1JjeDZVVWQ1YmZOSGVTRFp2?=
 =?utf-8?B?Z1RwaFo4d3pmVmNySXB6YldLQnlhYTZld1FHNWQyai9xc1RVZzVWVzJlSWpJ?=
 =?utf-8?B?OW00S0dndFNDM2pKT1AxdHgreFZtNS9HRlhEZWhkRVBWRU1GUEw1b2FSeEVn?=
 =?utf-8?B?ZWg0RHpKYkUraWVRUkY2USthUHZDc2tXc1FrVmNjY1FiTDBkRUIySXNFQjhM?=
 =?utf-8?B?eWJVdU9LQ0w2MEFiMzM1MWs5dlA2NTB3S1BxNzJQTkprZEgzR2w1WTFxaTV0?=
 =?utf-8?B?SzNiMU9NZEVodGYwVzU2WWZvbzY3NEo1ZmVab2hXa1dBS0pYQVcyVEtTYkF3?=
 =?utf-8?B?MHFIS0hpa3Y2Sjg2VmZJaUpPSmd6eHh4TXhIVVRuZkpjSy94Zk9oRDBRakdX?=
 =?utf-8?B?ZXdOUzlvdFhBOFRLUnBwMGM3eVdQaHEyQ2w4TnkxdVQ1RzBMNXBKSTdyN0ZJ?=
 =?utf-8?B?Rkh5RnplOFN5UUE2K2EvZ1lFczFpSlNiSlpPV3h1ZE1Eb0x0aGhJM21CNUxP?=
 =?utf-8?B?aldUYlFzUHkwWnpYSDdDeGZOUUsxSWFEYytzUUNocDhWMGg0L0pscW5MWjBD?=
 =?utf-8?B?N3RQaW5ZMlNQanB5dHRBeHJReVlIcXFOWllRMzZBRW8xR3pqaElJdFNCZ2pY?=
 =?utf-8?B?WWk3RWZVRnFRS2Mzck13MWxBN3JhamZWVmJOV0NSNHFTM0E3V2N5cHdPTlB2?=
 =?utf-8?Q?u63M=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(14060799003)(376014)(35042699022)(36860700013)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 16:56:32.3699
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e88ed406-3a84-4fb0-7a19-08de4ed6e033
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A67.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9576

T24gV2VkLCAyMDI2LTAxLTA3IGF0IDE1OjQ5ICswMDAwLCBKb25hdGhhbiBDYW1lcm9uIHdyb3Rl
Og0KPiBPbiBGcmksIDE5IERlYyAyMDI1IDE1OjUyOjQ0ICswMDAwDQo+IFNhc2NoYSBCaXNjaG9m
ZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiANCj4gPiBVcGRhdGUga3ZtX3Zn
aWNfY3JlYXRlIHRvIGNyZWF0ZSBhIHZnaWNfdjUgZGV2aWNlLiBXaGVuIGNyZWF0aW5nIGENCj4g
PiB2Z2ljLCBGRUFUX0dDSUUgaW4gdGhlIElEX0FBNjRQRlIyIGlzIG9ubHkgZXhwb3NlZCB0byB2
Z2ljX3Y1LWJhc2VkDQo+ID4gZ3Vlc3RzLCBhbmQgaXMgaGlkZGVuIG90aGVyd2lzZS4gR0lDIGlu
IH5JRF9BQTY0UEZSMF9FTDEgaXMgbmV2ZXINCj4gPiBleHBvc2VkIGZvciBhIHZnaWNfdjUgZ3Vl
c3QuDQo+ID4gDQo+ID4gV2hlbiBpbml0aWFsaXNpbmcgYSB2Z2ljX3Y1LCBza2lwIGt2bV92Z2lj
X2Rpc3RfaW5pdCBhcyBHSUN2NQ0KPiA+IGRvZXNuJ3QNCj4gPiBzdXBwb3J0IG9uZS4gVGhlIGN1
cnJlbnQgdmdpY192NSBpbXBsZW1lbnRhdGlvbiBvbmx5IHN1cHBvcnRzIFBQSXMsDQo+ID4gc28N
Cj4gPiBubyBTUElzIGFyZSBpbml0aWFsaXNlZCBlaXRoZXIuDQo+ID4gDQo+ID4gVGhlIGN1cnJl
bnQgdmdpY192NSBzdXBwb3J0IGRvZXNuJ3QgZXh0ZW5kIHRvIG5lc3RlZA0KPiANCj4gT2RkIGVh
cmx5IHdyYXBwaW5nIG9mIG1lc3NhZ2UuDQoNCkZpeGVkLiBJbnRlcmVzdGluZ2x5LCBlbWFjcyBp
cyB2ZXJ5IGluc2lzdGVudCB0aGF0IHRoaXMgaXMgdGhlIGNvcnJlY3QNCndheSB0byB3cmFwIGhl
cmUuDQoNCj4gDQo+ID4gZ3Vlc3RzLiBUaGVyZWZvcmUsIHRoZSBpbml0IG9mIHZnaWNfdjUgZm9y
IGEgbmVzdGVkIGd1ZXN0IGlzIGZhaWxlZA0KPiA+IGluDQo+ID4gdmdpY192NV9pbml0Lg0KPiA+
IA0KPiA+IEFzIHRoZSBjdXJyZW50IHZnaWNfdjUgZG9lc24ndCByZXF1aXJlIGFueSByZXNvdXJj
ZXMgdG8gYmUgbWFwcGVkLA0KPiA+IHZnaWNfdjVfbWFwX3Jlc291cmNlcyBpcyBzaW1wbHkgdXNl
ZCB0byBjaGVjayB0aGF0IHRoZSB2Z2ljIGhhcw0KPiA+IGluZGVlZA0KPiA+IGJlZW4gaW5pdGlh
bGlzZWQuIEFnYWluLCB0aGlzIHdpbGwgY2hhbmdlIGFzIG1vcmUgR0lDdjUgc3VwcG9ydCBpcw0K
PiA+IG1lcmdlZCBpbi4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBTYXNjaGEgQmlzY2hvZmYg
PHNhc2NoYS5iaXNjaG9mZkBhcm0uY29tPg0KPiBDb21tZW50cyBtb3N0bHkgb24gZXhpc3Rpbmcg
Y29kZSwgc28NCj4gUmV2aWV3ZWQtYnk6IEpvbmF0aGFuIENhbWVyb24gPGpvbmF0aGFuLmNhbWVy
b25AaHVhd2VpLmNvbT4NCj4gDQo+ID4gLS0tDQo+ID4gwqBhcmNoL2FybTY0L2t2bS92Z2ljL3Zn
aWMtaW5pdC5jIHwgNTEgKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0NCj4gPiAtLS0tDQo+
ID4gwqBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuY8KgwqAgfCAyNiArKysrKysrKysrKysr
KysrKw0KPiA+IMKgYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmjCoMKgwqDCoMKgIHzCoCAyICsr
DQo+ID4gwqBpbmNsdWRlL2t2bS9hcm1fdmdpYy5owqDCoMKgwqDCoMKgwqDCoMKgIHzCoCAxICsN
Cj4gPiDCoDQgZmlsZXMgY2hhbmdlZCwgNjMgaW5zZXJ0aW9ucygrKSwgMTcgZGVsZXRpb25zKC0p
DQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pbml0LmMN
Cj4gPiBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pbml0LmMNCj4gPiBpbmRleCAwM2Y0NTgx
NjQ2NGIwLi5hZmI1ODg4Y2Q4MjE5IDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3Zn
aWMvdmdpYy1pbml0LmMNCj4gPiArKysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaW5pdC5j
DQo+IA0KPiA+IMKgCWlmICh0eXBlID09IEtWTV9ERVZfVFlQRV9BUk1fVkdJQ19WMykNCj4gPiBA
QCAtNDIwLDIwICs0MjcsMjYgQEAgaW50IHZnaWNfaW5pdChzdHJ1Y3Qga3ZtICprdm0pDQo+ID4g
wqAJaWYgKGt2bS0+Y3JlYXRlZF92Y3B1cyAhPSBhdG9taWNfcmVhZCgma3ZtLT5vbmxpbmVfdmNw
dXMpKQ0KPiA+IMKgCQlyZXR1cm4gLUVCVVNZOw0KPiA+IMKgDQo+ID4gLQkvKiBmcmVlemUgdGhl
IG51bWJlciBvZiBzcGlzICovDQo+ID4gLQlpZiAoIWRpc3QtPm5yX3NwaXMpDQo+ID4gLQkJZGlz
dC0+bnJfc3BpcyA9IFZHSUNfTlJfSVJRU19MRUdBQ1kgLQ0KPiA+IFZHSUNfTlJfUFJJVkFURV9J
UlFTOw0KPiA+ICsJaWYgKCF2Z2ljX2lzX3Y1KGt2bSkpIHsNCj4gPiArCQkvKiBmcmVlemUgdGhl
IG51bWJlciBvZiBzcGlzICovDQo+ID4gKwkJaWYgKCFkaXN0LT5ucl9zcGlzKQ0KPiA+ICsJCQlk
aXN0LT5ucl9zcGlzID0gVkdJQ19OUl9JUlFTX0xFR0FDWSAtDQo+ID4gVkdJQ19OUl9QUklWQVRF
X0lSUVM7DQo+ID4gwqANCj4gPiAtCXJldCA9IGt2bV92Z2ljX2Rpc3RfaW5pdChrdm0sIGRpc3Qt
Pm5yX3NwaXMpOw0KPiA+IC0JaWYgKHJldCkNCj4gPiAtCQlnb3RvIG91dDsNCj4gPiArCQlyZXQg
PSBrdm1fdmdpY19kaXN0X2luaXQoa3ZtLCBkaXN0LT5ucl9zcGlzKTsNCj4gPiArCQlpZiAocmV0
KQ0KPiA+ICsJCQlnb3RvIG91dDsNCj4gDQo+IE5vdCByZWFsbHkgcmVsYXRlZCB0byB0aGlzIHBh
dGNoLCBidXQgSSBoYXZlIG5vIGlkZWEgd2h5IHRoaXMNCj4gZnVuY3Rpb24NCj4gZG9lc24ndCBq
dXN0IGRvIGVhcmx5IHJldHVybnMgb24gZXJyb3IgaW4gYWxsIHBhdGhzIChyYXRoZXIgdGhhbiBq
dXN0DQo+IHNvbWUgb2YgdGhlbSkuDQo+IEl0IG1pZ2h0IGJlIHdvcnRoIGNoYW5naW5nIHRoYXQg
dG8gaW1wcm92ZSByZWFkYWJpbGl0eS4NCg0KWWVhaCwgSSd2ZSBkb25lIHRoYXQuDQoNCj4gDQo+
IA0KPiA+IMKgDQo+ID4gLQkvKg0KPiA+IC0JICogRW5zdXJlIHZQRXMgYXJlIGFsbG9jYXRlZCBp
ZiBkaXJlY3QgSVJRIGluamVjdGlvbiAoZS5nLg0KPiA+IHZTR0lzLA0KPiA+IC0JICogdkxQSXMp
IGlzIHN1cHBvcnRlZC4NCj4gPiAtCSAqLw0KPiA+IC0JaWYgKHZnaWNfc3VwcG9ydHNfZGlyZWN0
X2lycXMoa3ZtKSkgew0KPiA+IC0JCXJldCA9IHZnaWNfdjRfaW5pdChrdm0pOw0KPiA+ICsJCS8q
DQo+ID4gKwkJICogRW5zdXJlIHZQRXMgYXJlIGFsbG9jYXRlZCBpZiBkaXJlY3QgSVJRDQo+ID4g
aW5qZWN0aW9uIChlLmcuIHZTR0lzLA0KPiA+ICsJCSAqIHZMUElzKSBpcyBzdXBwb3J0ZWQuDQo+
ID4gKwkJICovDQo+ID4gKwkJaWYgKHZnaWNfc3VwcG9ydHNfZGlyZWN0X2lycXMoa3ZtKSkgew0K
PiA+ICsJCQlyZXQgPSB2Z2ljX3Y0X2luaXQoa3ZtKTsNCj4gPiArCQkJaWYgKHJldCkNCj4gPiAr
CQkJCWdvdG8gb3V0Ow0KPiA+ICsJCX0NCj4gPiArCX0gZWxzZSB7DQo+ID4gKwkJcmV0ID0gdmdp
Y192NV9pbml0KGt2bSk7DQo+ID4gwqAJCWlmIChyZXQpDQo+ID4gwqAJCQlnb3RvIG91dDsNCj4g
PiDCoAl9DQo+ID4gQEAgLTYxMCw5ICs2MjMsMTMgQEAgaW50IGt2bV92Z2ljX21hcF9yZXNvdXJj
ZXMoc3RydWN0IGt2bSAqa3ZtKQ0KPiA+IMKgCWlmIChkaXN0LT52Z2ljX21vZGVsID09IEtWTV9E
RVZfVFlQRV9BUk1fVkdJQ19WMikgew0KPiA+IMKgCQlyZXQgPSB2Z2ljX3YyX21hcF9yZXNvdXJj
ZXMoa3ZtKTsNCj4gPiDCoAkJdHlwZSA9IFZHSUNfVjI7DQo+ID4gLQl9IGVsc2Ugew0KPiA+ICsJ
fSBlbHNlIGlmIChkaXN0LT52Z2ljX21vZGVsID09IEtWTV9ERVZfVFlQRV9BUk1fVkdJQ19WMykg
ew0KPiA+IMKgCQlyZXQgPSB2Z2ljX3YzX21hcF9yZXNvdXJjZXMoa3ZtKTsNCj4gPiDCoAkJdHlw
ZSA9IFZHSUNfVjM7DQo+ID4gKwl9IGVsc2Ugew0KPiA+ICsJCXJldCA9IHZnaWNfdjVfbWFwX3Jl
c291cmNlcyhrdm0pOw0KPiA+ICsJCXR5cGUgPSBWR0lDX1Y1Ow0KPiA+ICsJCWdvdG8gb3V0Ow0K
PiBUaGlzIHNraXBzIG92ZXIgdGhlIGNoZWNraW5nIG9mIHJldCB3aGljaCBpcyBmaW5lIChnaXZl
biBpdCdzIGp1c3QNCj4gZ290byBvdXQpDQo+IGJ1dCBJJ2QgYWRkIGEgY29tbWVudCB0byBzYXkg
d2h5IHRoZSBuZXh0IGJpdCBpcyBza2lwcGVkIG9yIGEgbW9yZQ0KPiBjb21wbGV4DQo+IGZsb3cg
KG1heWJlIGEgZmxhZyB0byBzYXkgZGlzdCBpcyByZWxldmFudCB0aGF0IGdhdGVzIHRoZSBuZXh0
IGJpdC4NCg0KSSd2ZSBtb3ZlZCB0byB1c2luZyBhIGZsYWcgYXMgaXQgbWFrZXMgdGhpbmdzIG1v
cmUgcmVhZGFibGUuDQoNClNhc2NoYQ0KDQo+IA0KPiA+IMKgCX0NCj4gPiDCoA0KPiA+IMKgCWlm
IChyZXQpDQo+IA0KPiANCg0K

