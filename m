Return-Path: <kvm+bounces-65790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CC0ADCB6CD6
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 18:51:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B8F7C3011B2E
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 17:51:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE50231D381;
	Thu, 11 Dec 2025 17:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="F4t7XgDd";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="F4t7XgDd"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013049.outbound.protection.outlook.com [52.101.83.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DC631CA68
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 17:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.49
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765473872; cv=fail; b=kz9N2+4RuNgawz3bTafeMoI9YDSmkDMD3da39uO0d+xrxWAcIsBRXa63XUDKzLcEsNpjXusRBwKACHko0keY5zvheVHkQop2cy/LeeF5jzNiZIwt8wprKhmrIhmgplFe3r6faAjHIV1jqO+7TiybXNA2WMgpzzE4sPJ77BvBlSo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765473872; c=relaxed/simple;
	bh=DoV3zUhwaEN/xor+0kaojsLVs7wxb9B44NP8u+Ui3gs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QZQo2KSu/ocnUgQAmOuQuiZC3vwxm210E/KapWYduaFanov27Ivgm0+gnb3J0mIPff/T1rccn3zbWZkMt4GmcaF4keN/ZGNoWqCzba0VoGra46rvTZHy7V3mQ/D0YtpjNhUGtVP9Ipp3ERg0mo8/8RuQrSAU2jGfyWTEfdnER0I=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=F4t7XgDd; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=F4t7XgDd; arc=fail smtp.client-ip=52.101.83.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=TXJlu88uslN8HZuob8Emu01JpXxhJwLQ718KlhtjvNN37OtU0TExJ1lIFLua0sPj7uN995gP01ubttepAAgupquzG0rBWApWAGVx4iqmZBBNj55xgqRvDpCFB8TuDQYlu9c0EVPYaKH9R6VqslLW7Ovbn8Rc1ZViIR+TMQ14cdBFGoNzVGj8Hl2i/7bh/hiYRSN+wBgNfvD7YxjMbRhJzR67HU4crSr20ojsuUt9hV5C2K5A6TDBrit36wi6OTTOxRN0wgFjiJwMP7Qs77hR556QZUpd+soxMhw+ISYSmIW9/+z4L5qSiJ+jncfjRrRu0nbaQ9ayhQgMk2FHsJXGvQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DoV3zUhwaEN/xor+0kaojsLVs7wxb9B44NP8u+Ui3gs=;
 b=g1WKAKNN4Aq0LlKFPwHalT3yhz6squ0AsLfBiycHscbFPYMz50ux9qH1UrAOy3mrGfOHE6IqQ8DeroslBBkQI7YSLVNkrgbK19rJrRb5w1TjaEHBgdcpc63F5qqZ5Y/CiupYzbauQVg4yk3vPPn4ko+TFNHDtxn00uIKvQ+q7Wk+y688g2hmF+SZOQU0IMDUXt94gUa53K2t66Zn6Th42NFAKAatyTcMsOMWMKL7Y2PYMNuQ8P13tbO3aFIWUnLTZUU+MKRANM2Ud+c0TOnV7TZL0bGmDmCnEiFJ/Ql45fCsSoRIEE0gj/chu0Jffjalxgc5kjrJawvZSlGorp3dnQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DoV3zUhwaEN/xor+0kaojsLVs7wxb9B44NP8u+Ui3gs=;
 b=F4t7XgDdZi5Jxc5oKecwIiVR4xXalpIGH8UVcsg2QhF6zHdn6JWmislHn6eQN3r9n/URT20ezdyyVEZoT6qXqbdqhn9LWE9ymQoZiQLZQWV2tvZgOdTumNJXG3S0rpx17qZ0PtQWoJOxzW6omuVbtdIDhE4OoDsS+5QTMXuEO/A=
Received: from AS4P191CA0020.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:5d9::8)
 by AM9PR08MB6228.eurprd08.prod.outlook.com (2603:10a6:20b:281::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Thu, 11 Dec
 2025 17:24:22 +0000
Received: from AM3PEPF0000A797.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d9:cafe::6f) by AS4P191CA0020.outlook.office365.com
 (2603:10a6:20b:5d9::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.9 via Frontend Transport; Thu,
 11 Dec 2025 17:24:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A797.mail.protection.outlook.com (10.167.16.102) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Thu, 11 Dec 2025 17:24:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qza65GgpwzYoWhk46idozSa/HhE3K/M3Oe/XbnO0VuJxdsccaSd0JsDIsrE6OlzoES8a/6lCPdAHEptFJZZwuKW1Eh3D0FNX19KGRFR3ukXVhcmdcR+BAQpZR4LpxrZb1mgwMb8bzV8Pje0PKzHxp6EwMiLuz73qboBf5XZUCwU1PNEu7Ip98VOsP7qvubE6zRaF9exQoytx8v7R5duQ0pnOrq1mW3ggL4TGSy9qgsMviytjIiR7WO0YNKa4iOmEOIIxDcUfhn2E4y1pCqJh9x6NlXhondwYYf5ypLKjuab8Ongak1bSNIYzuqtrajGLMiI45Y2WIZhwtSz7QnGeYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DoV3zUhwaEN/xor+0kaojsLVs7wxb9B44NP8u+Ui3gs=;
 b=Y1q1VtgolXGDzHV8NjnNUkTmk2voCSmFpagmctihejaDHmjwQr7+s/6MMRJU6MoKBKLyTe7uvUJ9bGt+mMHssL2g/AtHTGUHLw/RddFYjo4ZhdGxOljhQdSm34zZ1qoSV7upgO00cSLE1wyqCNrjkzOk871PjJ3gtt0xh/K/qfAajQAdGH4BcaL50XAndmv2MUUJeRLOXMErTPcJEo0oRkDcOq0i8rOgZ70TC1zXc+KXWkk0/b2kBdH0pze/UsKUSqCqqLeViShC2HXE+dMKmI/MCBfCs3vDPksteGfXFd1nnTk2rgWH6S25HbSIH8tHkdmCoMnvYIfVTH5BRKJ6lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DoV3zUhwaEN/xor+0kaojsLVs7wxb9B44NP8u+Ui3gs=;
 b=F4t7XgDdZi5Jxc5oKecwIiVR4xXalpIGH8UVcsg2QhF6zHdn6JWmislHn6eQN3r9n/URT20ezdyyVEZoT6qXqbdqhn9LWE9ymQoZiQLZQWV2tvZgOdTumNJXG3S0rpx17qZ0PtQWoJOxzW6omuVbtdIDhE4OoDsS+5QTMXuEO/A=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by DBBPR08MB6315.eurprd08.prod.outlook.com (2603:10a6:10:209::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Thu, 11 Dec
 2025 17:23:19 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Thu, 11 Dec 2025
 17:23:18 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "qperret@google.com"
	<qperret@google.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"sebastianene@google.com" <sebastianene@google.com>, nd <nd@arm.com>,
	"oupton@kernel.org" <oupton@kernel.org>, Alexandru Elisei
	<Alexandru.Elisei@arm.com>, Joey Gouly <Joey.Gouly@arm.com>,
	"tabba@google.com" <tabba@google.com>
Subject: Re: [PATCH v2 4/6] KVM: arm64: Account for RES1 bits in
 DECLARE_FEAT_MAP() and co
Thread-Topic: [PATCH v2 4/6] KVM: arm64: Account for RES1 bits in
 DECLARE_FEAT_MAP() and co
Thread-Index: AQHcafqzerzCxQwTBEaRHf0l/OTftbUcsbeA
Date: Thu, 11 Dec 2025 17:23:17 +0000
Message-ID: <91a09142b6cb76ab68903095eefd5b9e17dfcf37.camel@arm.com>
References: <20251210173024.561160-1-maz@kernel.org>
	 <20251210173024.561160-5-maz@kernel.org>
In-Reply-To: <20251210173024.561160-5-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|DBBPR08MB6315:EE_|AM3PEPF0000A797:EE_|AM9PR08MB6228:EE_
X-MS-Office365-Filtering-Correlation-Id: 7712f3a5-213b-4b67-9748-08de38da1fb0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?RlpLdnhpTEJCWFROcWtwYXhoSE1rVUdnMllybi9Tb1JkbzBXNGxYYWNZQzZk?=
 =?utf-8?B?K0liV0RXbUsxb3VUVm9mQURhM1cwaUFtNTF0T2hGdURqWThzbTR2cVprYmFX?=
 =?utf-8?B?VjFONmZ1OXd2Vi9OMENERUNxV0lOeGFLM0hEL0x0dTFtRmpZTlR5NDB0Q0Fm?=
 =?utf-8?B?ZU5JY0FLeEN3R1RobGN5ZS9jZXNIaWl6ckYzeFduZnBmWVRaY3lzb0hhWXRj?=
 =?utf-8?B?VUlSUmdSajlGVDY0T0NneHpvVksrZWtFQnFoQy9PZU1CTkZ6dVJvMVF6UlhS?=
 =?utf-8?B?LythSlk0eGVJRnEzUVcwQmdaZUVDTStEY1dUYytsOEszQVcrelhGa0dkcks2?=
 =?utf-8?B?a2pRM3puMGtqWDNSeGpYbEZKbTFTYmp3Wm9TbVV4VGJTSlo1OEJGY0o4QWd1?=
 =?utf-8?B?RWIweXMzREo5T0lseXptN2Fqb2FMRFJrU2s5UzV5S1pSb3B1RVBnclQ3ZHBr?=
 =?utf-8?B?OEtSbzdtamFxMVYwWllBcGsxSVZUOU9CSHFXb0hXcHV6NVRIcnRBNHY4dUtl?=
 =?utf-8?B?dkJJQjlJT1FJZ1hpanlNN05JRWpCbCtJRnYxQnMreitzc3d4MTNUVHE1bzZF?=
 =?utf-8?B?MFNzZllpZUhPT0lGcjF2c3BjKzUwZUtSSEgxZld5aVA1K3E4TnlFWmtNajRH?=
 =?utf-8?B?czAzdUg4bThVQ2gvVC8wTk9iQWhIbGlrUzUyZ3NmbXBIQkNXeWVGSXpCcWd4?=
 =?utf-8?B?Vkk5VklCWU1EaGF5Si9qQUdWVE42NUdCcmJFcEhOWE5FMCtGS0t1WnYzMUxN?=
 =?utf-8?B?UEdicDQvV1hndldMRHRyYmxZMlE4TmxVY1VuNG55V0xHc0JaS2VGL0FiMzk5?=
 =?utf-8?B?L0k4dXVPRklSa0lzbmhpRUlyZ2Ird1FSTUhhZmtYR1h2RURDMUV5c3owaXA5?=
 =?utf-8?B?dHAxbUlwb1oybm5XdDNPSit5V0c5Y3g2cUxMQVAxKzdRazR0Wjd4VmxaVjRT?=
 =?utf-8?B?b3RvMEliUFVnZitsTnUxK1V2RzZZNmxIQ1N1b2t0TjRhTW4zcmVtazBYSVBa?=
 =?utf-8?B?d3BENk9qM2M5ZXlaeU5La21DdGdwbmtUU0YyaU93elZnNDViQXJwZFcrRHdz?=
 =?utf-8?B?U1FFSW9wR3ozWHhOQXVqT2JqUm56Y2N3eGtMK2cvTlpBRjhnU3FZdmRPNzAx?=
 =?utf-8?B?Y3d1NDFpanNMeGRvbUlZRm4xbFhKbUF2Wi9kMTBaemhjalpPWG1BQVRYdFhC?=
 =?utf-8?B?b0FGMkY3SWkxaFZvRENwSDVPTFBnYS8wazBGRVhyYThzcERxMVdVd1cyMWVq?=
 =?utf-8?B?VzBOakE1cVo1d2FwbEpwNVJ0YjRMb0xPbjcwTHhJWDVHZ2gzR1hERm1kb2lj?=
 =?utf-8?B?b3Z0aGRaSklSRi81bUFKV3Y3ektWSVVPVU9sYjRxT1EzQXJva2djc0Zyd3pJ?=
 =?utf-8?B?TXoxU0lwaFdjTVJWV0EvejFzcmdNOTFqNWRMTFlPQStmbmcvTndGbjhDNmNN?=
 =?utf-8?B?ajF3aHNhVzQrQmNmK0V6bjdpSHoxVGNWYnYreWNxaTFIMHczZmNjeVBaazVE?=
 =?utf-8?B?VnM5bnh0eTltNlNvOWg0TlVWcitzaFJPMGFNemdQSWNJNG1VRDF4WVkzc1Jy?=
 =?utf-8?B?Q21ZV2dVMzZaU2Z0ZkxnT0J0bmg3d1ppTnZiQkRzS3pUQ1pGWDNHemJUQ0VL?=
 =?utf-8?B?cWx1eW1EZ2pFUnYwZEpEbitDc0pHcUtFTEVwK0V6ampEc1hwbVB5LzFFcytD?=
 =?utf-8?B?UzZGbkdvOFZIN2hXdjM4cGhBY0RUUkxkZ3hoRkhibWxOQzdBMjVKaXFaeVk4?=
 =?utf-8?B?cjVYdkc1TDVXelA3UVA2T0kzenlGZ083R0JudnBsMHVnYndHS3RISWFzUEJS?=
 =?utf-8?B?MTdsWUwwRmZHdHF0NFpzR1ozQVR3TzhFZDZiNGgzSVJqVWV4eXl0OHNIamp2?=
 =?utf-8?B?ZXNvVm40VnVEUlRETWJwNWJFNEFHL0dJSjJHMWpqUzMrY3phMktiaEhpVVJG?=
 =?utf-8?B?azh1NDRHWU00RDIzdkF2bi9OdVErOGRQcTFWeUhqWHJDRkhVYldEc2toVTN2?=
 =?utf-8?B?UG83K1hxQnNxKzUwY1pPaXFZYkxuVkZ3ZEZxSmpjczQ0TEplYTRvb2JGanlB?=
 =?utf-8?Q?BvnDHS?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <0C7013091200BC47AA98A1DEBC0B09EA@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6315
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A797.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0141c744-7fda-4c8e-51f0-08de38d9f9a3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|36860700013|1800799024|82310400026|14060799003|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UVNPRVdzOGMwVlkxU0x2V1A3U1luZ3ppVExJcTZOd0ZHS1B5bCtLUHhyRmp2?=
 =?utf-8?B?L1lMZUZQTHgxVDNYODIxOHRRYWhxMHNuZnZoMTYrSmZuYUdzQW1lUE5jRmhz?=
 =?utf-8?B?S2YwL3IzMG9TaUtma3NaYndUNlVXTHpITVorcDRnTWo3MVZSZlVreElHOEVr?=
 =?utf-8?B?clhLa1cyS1JhQUx5TGcyNUdZWDRTSmJNNzlobFh6T2J3VGloWHZZRG9rVU9m?=
 =?utf-8?B?UUltS0FwUE1YY1YxdVRVRUpxY2hndnlmcG1sM1lwVEhTVjlRNkx3V3pvdXdk?=
 =?utf-8?B?SFBhTXZ4S0Q1K09ZcVdKdlg1MGRINHFlUWpXdk9FZTQraFF2UlZoN2RvWlh4?=
 =?utf-8?B?VTJXMFpnUC9nM3ZCQjB2N1pNSEJCc3FhMnpTdDRVT01YYzBiZTJZRWpOMEx3?=
 =?utf-8?B?QmFScHNIR0tKdHBNK3B5VHZ1K05ueVU5cnFFY3dFU1pra1QxcTlCck4wcTNz?=
 =?utf-8?B?bksrTGJsenAzQkNpeEZrVmRzN094a3NFOElSL3Y0VmJ1OTU5OUxvRWpnK3dF?=
 =?utf-8?B?MEhnR1RjbGt4WGNzc3J0U25pOE9LdGZGN3FTaE9sZ0crYzhEbUNmRkJ5OWlx?=
 =?utf-8?B?WDEyNnZzYmxnM0E2Y3Z3WHJ5UGlrUytpenV6aTAxZ3RjNVVoMXJYQ0Zkc3I4?=
 =?utf-8?B?VzRubTZrdzc3dFllSmV3VjR1L0RDSitNcGFuMWhoU2VjTHlYMmRWbmRZWTQr?=
 =?utf-8?B?MlNVZ0Joc2U2S2p2SjJFbC9KU2xObElMcHQzUG8rZDI0SWNZWDlidzlZbmpU?=
 =?utf-8?B?U1FYdmhoV3QwZjUrLzE0RXJjUzlLTjduQWlZSlhKMWdaald3d29rZGlmU1B2?=
 =?utf-8?B?YzAzTWF1L1ZhaDdoa2J5aGZ1aHNIVDZ2MXhFQ0RKZUdBWXp4SFRCVDhZcFVs?=
 =?utf-8?B?T01obC9IUFp2M3lKZmZHVWhldjRZOElQQ0hGVjY4NUQzc3ZiVmhyZXZRdnV3?=
 =?utf-8?B?akVhaVg3dy9zMjBoeEZYVkh1R2xzbXA4eCtha21zZWE0OHJ4VlIvNU1sY2J5?=
 =?utf-8?B?Sm4wSFVNaWpzUy9NRkVRbGJ2dU9SY2dGNG9PLzdDMDBYaW9ybmFxUnFOcnlE?=
 =?utf-8?B?Ni8vcVNzdFoyVlV3TkRzaGhvdzBaa245L0d2b0VIcTFwZU4vM2VDU1hDdXFl?=
 =?utf-8?B?bnNuekNlSGw4bGIwdVVlQWliRXNldnptdHIvdGo5d2swd251RjNjcE9wb3Vo?=
 =?utf-8?B?cUNzblFpQmo5bWNIbmVqd1NtSEs4T3RMRHdZSDlkOXlEQWlENTAwUk9VUk9r?=
 =?utf-8?B?ZHBjQUU3d2NQTnU3alk1WVdLVEc2aSsvTWtaQ0o5SWRxa3QrTHcvUnZWRkVV?=
 =?utf-8?B?ME02OFE2bUZqWlNLTk9JelVvWVlpaVlOYXVTYUxoRFFMT2VFMnlpZUxFc0E0?=
 =?utf-8?B?bzJmY0ZBOTdnMDRRUEIxRlYyeVREVjBMS1oxNDZhckJOVWErN080a3BxUFcv?=
 =?utf-8?B?ZzlFenhZRThKdlVaNFFhd05Sam1sSUlueCtGSEdIU2dFRE5kVk84aFRCSTFz?=
 =?utf-8?B?c1RSV3A5L3VKRUVRdVh4bDFSaitGRVh3M2lmTjJtOUZOU2dpZzUxOHhZUC9G?=
 =?utf-8?B?c3lXNWphNWsxM2FRdVd5Z2pKNTRzbVhGM3hiczhYc2VJMG5wMkF3SUZUTDRD?=
 =?utf-8?B?elVhQ0kzbGM1YzlxN1E5VTBWKzJZcFgzcU52WnV5T0xGemNpekpmVmgzeXpt?=
 =?utf-8?B?bTdzZnhtTnp4UXk0a3JlaldWWlFjcDNqK2ZxSkV2elczSGV1aGdrRldSbG5T?=
 =?utf-8?B?MjJYOTlKbVd5SlpNR3U4a296MlBnbVZtdkdIbUdjSHdpU3poSW5RcGFqN0U4?=
 =?utf-8?B?MkEyZWtJcUU4R2NQK3BUWkV4SUF3cjVJZkc1K0ZzYTZ0cis1MmVsUk5CK2xT?=
 =?utf-8?B?aXBXbVhac1Y5RXJpL05OMmZYcUNWb09uUzZnMmpiYUJhSVVqZXJiS20yUTVS?=
 =?utf-8?B?azlwdlpPOHYvT083UjhEeDVPZkhvbWdpOHFmNG50QkEyYWFOL1BWcVlpSk5l?=
 =?utf-8?B?ZkVSdklRM25EUFFMRWdTMmFKbllDR0crS1Q0Zy9mOURjM1FRWGJjY21HeEZr?=
 =?utf-8?B?c0JEWkQrdlpkbHpObXpkdktzYjE0YXVtY3FUc0lZVjlTd1gwb25abVljUWx1?=
 =?utf-8?Q?yrKo=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(36860700013)(1800799024)(82310400026)(14060799003)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2025 17:24:21.7969
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7712f3a5-213b-4b67-9748-08de38da1fb0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A797.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6228

T24gV2VkLCAyMDI1LTEyLTEwIGF0IDE3OjMwICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE5vbmUgb2YgdGhlIHJlZ2lzdGVycyB3ZSBtYW5hZ2UgaW4gdGhlIGZlYXR1cmUgZGVwZW5kZW5j
eQ0KPiBpbmZyYXN0cnVjdHVyZQ0KPiBzbyBmYXIgaGFzIGFueSBSRVMxIGJpdC4gVGhpcyBpcyBh
Ym91dCB0byBjaGFuZ2UsIGFzIFZUQ1JfRUwyIGhhcw0KPiBpdHMgYml0IDMxIGJlaW5nIFJFUzEu
DQo+IA0KPiBJbiBvcmRlciB0byBub3QgZmFpbCB0aGUgY29uc2lzdGVuY3kgY2hlY2tzIGJ5IG5v
dCBkZXNjcmliaW5nIGEgYml0LA0KPiBhZGQgUkVTMSBiaXRzIHRvIHRoZSBzZXQgb2YgaW1tdXRh
YmxlIGJpdHMuIFRoaXMgcmVxdWlyZXMgc29tZSBleHRyYQ0KPiBzdXJnZXJ5IGZvciB0aGUgRkdU
IGhhbmRsaW5nLCBhcyB3ZSBub3cgbmVlZCB0byB0cmFjayBSRVMxIGJpdHMgdGhlcmUNCj4gYXMg
d2VsbC4NCj4gDQo+IFRoZXJlIGFyZSBubyBSRVMxIEZHVCBiaXRzICp5ZXQqLiBXYXRjaCB0aGlz
IHNwYWNlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9y
Zz4NCg0KSSd2ZSB0ZXN0ZWQgdGhpcyBjaGFuZ2Ugd2l0aCBteSBXSVAgdmdpY192NSBzdXBwb3J0
LCB3aGljaCBpbmRlZWQNCmludHJvZHVjZXMgYSBSRVMxIEZHVCBiaXQuIEkgY2FuIGNvbmZpcm0g
dGhhdCB0aGUgRkdUIHN1cHBvcnQgaXMgbm93DQp3b3JraW5nIGFzIEknZCBleHBlY3QgaXQgdG8u
IFRoYW5rcyBmb3IgdGhpcyBjaGFuZ2UhDQoNClRlc3RlZC1ieTogU2FzY2hhIEJpc2Nob2ZmIDxz
YXNjaGEuYmlzY2hvZmZAYXJtLmNvbT4NCg0KVGhhbmtzLA0KU2FzY2hhDQoNCj4gLS0tDQo+IMKg
YXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oIHzCoCAxICsNCj4gwqBhcmNoL2FybTY0
L2t2bS9jb25maWcuY8KgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMjUgKysrKysrKy0tLS0tLS0NCj4g
wqBhcmNoL2FybTY0L2t2bS9lbXVsYXRlLW5lc3RlZC5jwqDCoCB8IDU1ICsrKysrKysrKysrKysr
KysrLS0tLS0tLS0tLS0tDQo+IC0tDQo+IMKgMyBmaWxlcyBjaGFuZ2VkLCA0NSBpbnNlcnRpb25z
KCspLCAzNiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2luY2x1
ZGUvYXNtL2t2bV9ob3N0LmgNCj4gYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgN
Cj4gaW5kZXggYWM3Zjk3MGM3ODgzMC4uYjU1MmExZTAzODQ4YyAxMDA2NDQNCj4gLS0tIGEvYXJj
aC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQo+ICsrKyBiL2FyY2gvYXJtNjQvaW5jbHVk
ZS9hc20va3ZtX2hvc3QuaA0KPiBAQCAtNjM4LDYgKzYzOCw3IEBAIHN0cnVjdCBmZ3RfbWFza3Mg
ew0KPiDCoAl1NjQJCW1hc2s7DQo+IMKgCXU2NAkJbm1hc2s7DQo+IMKgCXU2NAkJcmVzMDsNCj4g
Kwl1NjQJCXJlczE7DQo+IMKgfTsNCj4gwqANCj4gwqBleHRlcm4gc3RydWN0IGZndF9tYXNrcyBo
ZmdydHJfbWFza3M7DQo+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9jb25maWcuYyBiL2Fy
Y2gvYXJtNjQva3ZtL2NvbmZpZy5jDQo+IGluZGV4IDI0YmIzZjM2ZTlkNTkuLjM4NDViMTg4NTUx
YjYgMTAwNjQ0DQo+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL2NvbmZpZy5jDQo+ICsrKyBiL2FyY2gv
YXJtNjQva3ZtL2NvbmZpZy5jDQo+IEBAIC0xNiwxNCArMTYsMTQgQEANCj4gwqAgKi8NCj4gwqBz
dHJ1Y3QgcmVnX2JpdHNfdG9fZmVhdF9tYXAgew0KPiDCoAl1bmlvbiB7DQo+IC0JCXU2NAliaXRz
Ow0KPiAtCQl1NjQJKnJlczBwOw0KPiArCQl1NjQJCSBiaXRzOw0KPiArCQlzdHJ1Y3QgZmd0X21h
c2tzICptYXNrczsNCj4gwqAJfTsNCj4gwqANCj4gwqAjZGVmaW5lCU5FVkVSX0ZHVQlCSVQoMCkJ
LyogQ2FuIHRyYXAsIGJ1dCBuZXZlciBVTkRFRg0KPiAqLw0KPiDCoCNkZWZpbmUJQ0FMTF9GVU5D
CUJJVCgxKQkvKiBOZWVkcyB0byBldmFsdWF0ZSB0b25zIG9mDQo+IGNyYXAgKi8NCj4gwqAjZGVm
aW5lCUZJWEVEX1ZBTFVFCUJJVCgyKQkvKiBSQVovV0kgb3IgUkFPL1dJIGluIEtWTQ0KPiAqLw0K
PiAtI2RlZmluZQlSRVMwX1BPSU5URVIJQklUKDMpCS8qIFBvaW50ZXIgdG8gUkVTMCB2YWx1ZQ0K
PiBpbnN0ZWFkIG9mIGJpdHMgKi8NCj4gKyNkZWZpbmUJTUFTS1NfUE9JTlRFUglCSVQoMykJLyog
UG9pbnRlciB0byBmZ3RfbWFza3MNCj4gc3RydWN0IGluc3RlYWQgb2YgYml0cyAqLw0KPiDCoA0K
PiDCoAl1bnNpZ25lZCBsb25nCWZsYWdzOw0KPiDCoA0KPiBAQCAtOTIsOCArOTIsOCBAQCBzdHJ1
Y3QgcmVnX2ZlYXRfbWFwX2Rlc2Mgew0KPiDCoCNkZWZpbmUgTkVFRFNfRkVBVF9GSVhFRChtLCAu
Li4pCQkJXA0KPiDCoAlfX05FRURTX0ZFQVRfRkxBRyhtLCBGSVhFRF9WQUxVRSwgYml0cywgX19W
QV9BUkdTX18sIDApDQo+IMKgDQo+IC0jZGVmaW5lIE5FRURTX0ZFQVRfUkVTMChwLCAuLi4pCQkJ
CVwNCj4gLQlfX05FRURTX0ZFQVRfRkxBRyhwLCBSRVMwX1BPSU5URVIsIHJlczBwLCBfX1ZBX0FS
R1NfXykNCj4gKyNkZWZpbmUgTkVFRFNfRkVBVF9NQVNLUyhwLCAuLi4pCQkJCVwNCj4gKwlfX05F
RURTX0ZFQVRfRkxBRyhwLCBNQVNLU19QT0lOVEVSLCBtYXNrcywgX19WQV9BUkdTX18pDQo+IMKg
DQo+IMKgLyoNCj4gwqAgKiBEZWNsYXJlIHRoZSBkZXBlbmRlbmN5IGJldHdlZW4gYSBzZXQgb2Yg
Yml0cyBhbmQgYSBzZXQgb2YNCj4gZmVhdHVyZXMsDQo+IEBAIC0xMDksMTkgKzEwOSwyMCBAQCBz
dHJ1Y3QgcmVnX2ZlYXRfbWFwX2Rlc2Mgew0KPiDCoCNkZWZpbmUgREVDTEFSRV9GRUFUX01BUChu
LCByLCBtLA0KPiBmKQkJCQkJXA0KPiDCoAlzdHJ1Y3QgcmVnX2ZlYXRfbWFwX2Rlc2MgbiA9DQo+
IHsJCQkJCVwNCj4gwqAJCS5uYW1lCQkJPQ0KPiAjciwJCQkJXA0KPiAtCQkuZmVhdF9tYXAJCT0g
TkVFRFNfRkVBVCh+ciMjX1JFUzAsDQo+IGYpLMKgCVwNCj4gKwkJLmZlYXRfbWFwCQk9IE5FRURT
X0ZFQVQofihyIyNfUkVTMA0KPiB8CVwNCj4gKwkJCQkJCcKgwqDCoMKgwqDCoCByIyNfUkVTMSks
DQo+IGYpLAlcDQo+IMKgCQkuYml0X2ZlYXRfbWFwCQk9DQo+IG0sCQkJCVwNCj4gwqAJCS5iaXRf
ZmVhdF9tYXBfc3oJPQ0KPiBBUlJBWV9TSVpFKG0pLAkJXA0KPiDCoAl9DQo+IMKgDQo+IMKgLyoN
Cj4gwqAgKiBTcGVjaWFsaXNlZCB2ZXJzaW9uIG9mIHRoZSBhYm92ZSBmb3IgRkdUIHJlZ2lzdGVy
cyB0aGF0IGhhdmUNCj4gdGhlaXINCj4gLSAqIFJFUzAgbWFza3MgZGVzY3JpYmVkIGFzIHN0cnVj
dCBmZ3RfbWFza3MuDQo+ICsgKiBSRVN4IG1hc2tzIGRlc2NyaWJlZCBhcyBzdHJ1Y3QgZmd0X21h
c2tzLg0KPiDCoCAqLw0KPiDCoCNkZWZpbmUgREVDTEFSRV9GRUFUX01BUF9GR1QobiwgbXNrLCBt
LA0KPiBmKQkJCQlcDQo+IMKgCXN0cnVjdCByZWdfZmVhdF9tYXBfZGVzYyBuID0NCj4gewkJCQkJ
XA0KPiDCoAkJLm5hbWUJCQk9DQo+ICNtc2ssCQkJCVwNCj4gLQkJLmZlYXRfbWFwCQk9IE5FRURT
X0ZFQVRfUkVTMCgmbXNrLnJlczAsDQo+IGYpLFwNCj4gKwkJLmZlYXRfbWFwCQk9IE5FRURTX0ZF
QVRfTUFTS1MoJm1zaywNCj4gZiksCVwNCj4gwqAJCS5iaXRfZmVhdF9tYXAJCT0NCj4gbSwJCQkJ
XA0KPiDCoAkJLmJpdF9mZWF0X21hcF9zegk9DQo+IEFSUkFZX1NJWkUobSksCQlcDQo+IMKgCX0N
Cj4gQEAgLTExNjgsMjEgKzExNjksMjEgQEAgc3RhdGljIGNvbnN0IERFQ0xBUkVfRkVBVF9NQVAo
bWRjcl9lbDJfZGVzYywNCj4gTURDUl9FTDIsDQo+IMKgCQkJwqDCoMKgwqDCoCBtZGNyX2VsMl9m
ZWF0X21hcCwgRkVBVF9BQTY0RUwyKTsNCj4gwqANCj4gwqBzdGF0aWMgdm9pZCBfX2luaXQgY2hl
Y2tfZmVhdF9tYXAoY29uc3Qgc3RydWN0IHJlZ19iaXRzX3RvX2ZlYXRfbWFwDQo+ICptYXAsDQo+
IC0JCQkJwqAgaW50IG1hcF9zaXplLCB1NjQgcmVzMCwgY29uc3QgY2hhcg0KPiAqc3RyKQ0KPiAr
CQkJCcKgIGludCBtYXBfc2l6ZSwgdTY0IHJlc3gsIGNvbnN0IGNoYXINCj4gKnN0cikNCj4gwqB7
DQo+IMKgCXU2NCBtYXNrID0gMDsNCj4gwqANCj4gwqAJZm9yIChpbnQgaSA9IDA7IGkgPCBtYXBf
c2l6ZTsgaSsrKQ0KPiDCoAkJbWFzayB8PSBtYXBbaV0uYml0czsNCj4gwqANCj4gLQlpZiAobWFz
ayAhPSB+cmVzMCkNCj4gKwlpZiAobWFzayAhPSB+cmVzeCkNCj4gwqAJCWt2bV9lcnIoIlVuZGVm
aW5lZCAlcyBiZWhhdmlvdXIsIGJpdHMgJTAxNmxseFxuIiwNCj4gLQkJCXN0ciwgbWFzayBeIH5y
ZXMwKTsNCj4gKwkJCXN0ciwgbWFzayBeIH5yZXN4KTsNCj4gwqB9DQo+IMKgDQo+IMKgc3RhdGlj
IHU2NCByZWdfZmVhdF9tYXBfYml0cyhjb25zdCBzdHJ1Y3QgcmVnX2JpdHNfdG9fZmVhdF9tYXAg
Km1hcCkNCj4gwqB7DQo+IC0JcmV0dXJuIG1hcC0+ZmxhZ3MgJiBSRVMwX1BPSU5URVIgPyB+KCpt
YXAtPnJlczBwKSA6IG1hcC0NCj4gPmJpdHM7DQo+ICsJcmV0dXJuIG1hcC0+ZmxhZ3MgJiBNQVNL
U19QT0lOVEVSID8gKG1hcC0+bWFza3MtPm1hc2sgfCBtYXAtDQo+ID5tYXNrcy0+bm1hc2spIDog
bWFwLT5iaXRzOw0KPiDCoH0NCj4gwqANCj4gwqBzdGF0aWMgdm9pZCBfX2luaXQgY2hlY2tfcmVn
X2Rlc2MoY29uc3Qgc3RydWN0IHJlZ19mZWF0X21hcF9kZXNjICpyKQ0KPiBkaWZmIC0tZ2l0IGEv
YXJjaC9hcm02NC9rdm0vZW11bGF0ZS1uZXN0ZWQuYw0KPiBiL2FyY2gvYXJtNjQva3ZtL2VtdWxh
dGUtbmVzdGVkLmMNCj4gaW5kZXggODM0ZjEzZmIxZmI3ZC4uNzVkNDlmODMzNDJhNSAxMDA2NDQN
Cj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vZW11bGF0ZS1uZXN0ZWQuYw0KPiArKysgYi9hcmNoL2Fy
bTY0L2t2bS9lbXVsYXRlLW5lc3RlZC5jDQo+IEBAIC0yMTA1LDIzICsyMTA1LDI0IEBAIHN0YXRp
YyB1MzIgZW5jb2RpbmdfbmV4dCh1MzIgZW5jb2RpbmcpDQo+IMKgfQ0KPiDCoA0KPiDCoCNkZWZp
bmUgRkdUX01BU0tTKF9fbiwNCj4gX19tKQkJCQkJCVwNCj4gLQlzdHJ1Y3QgZmd0X21hc2tzIF9f
biA9IHsgLnN0ciA9ICNfX20sIC5yZXMwID0gX19tLCB9DQo+IC0NCj4gLUZHVF9NQVNLUyhoZmdy
dHJfbWFza3MsIEhGR1JUUl9FTDJfUkVTMCk7DQo+IC1GR1RfTUFTS1MoaGZnd3RyX21hc2tzLCBI
RkdXVFJfRUwyX1JFUzApOw0KPiAtRkdUX01BU0tTKGhmZ2l0cl9tYXNrcywgSEZHSVRSX0VMMl9S
RVMwKTsNCj4gLUZHVF9NQVNLUyhoZGZncnRyX21hc2tzLCBIREZHUlRSX0VMMl9SRVMwKTsNCj4g
LUZHVF9NQVNLUyhoZGZnd3RyX21hc2tzLCBIREZHV1RSX0VMMl9SRVMwKTsNCj4gLUZHVF9NQVNL
UyhoYWZncnRyX21hc2tzLCBIQUZHUlRSX0VMMl9SRVMwKTsNCj4gLUZHVF9NQVNLUyhoZmdydHIy
X21hc2tzLCBIRkdSVFIyX0VMMl9SRVMwKTsNCj4gLUZHVF9NQVNLUyhoZmd3dHIyX21hc2tzLCBI
RkdXVFIyX0VMMl9SRVMwKTsNCj4gLUZHVF9NQVNLUyhoZmdpdHIyX21hc2tzLCBIRkdJVFIyX0VM
Ml9SRVMwKTsNCj4gLUZHVF9NQVNLUyhoZGZncnRyMl9tYXNrcywgSERGR1JUUjJfRUwyX1JFUzAp
Ow0KPiAtRkdUX01BU0tTKGhkZmd3dHIyX21hc2tzLCBIREZHV1RSMl9FTDJfUkVTMCk7DQo+ICsJ
c3RydWN0IGZndF9tYXNrcyBfX24gPSB7IC5zdHIgPSAjX19tLCAucmVzMCA9IF9fbSAjIyBfUkVT
MCwNCj4gLnJlczEgPSBfX20gIyMgX1JFUzEgfQ0KPiArDQo+ICtGR1RfTUFTS1MoaGZncnRyX21h
c2tzLCBIRkdSVFJfRUwyKTsNCj4gK0ZHVF9NQVNLUyhoZmd3dHJfbWFza3MsIEhGR1dUUl9FTDIp
Ow0KPiArRkdUX01BU0tTKGhmZ2l0cl9tYXNrcywgSEZHSVRSX0VMMik7DQo+ICtGR1RfTUFTS1Mo
aGRmZ3J0cl9tYXNrcywgSERGR1JUUl9FTDIpOw0KPiArRkdUX01BU0tTKGhkZmd3dHJfbWFza3Ms
IEhERkdXVFJfRUwyKTsNCj4gK0ZHVF9NQVNLUyhoYWZncnRyX21hc2tzLCBIQUZHUlRSX0VMMik7
DQo+ICtGR1RfTUFTS1MoaGZncnRyMl9tYXNrcywgSEZHUlRSMl9FTDIpOw0KPiArRkdUX01BU0tT
KGhmZ3d0cjJfbWFza3MsIEhGR1dUUjJfRUwyKTsNCj4gK0ZHVF9NQVNLUyhoZmdpdHIyX21hc2tz
LCBIRkdJVFIyX0VMMik7DQo+ICtGR1RfTUFTS1MoaGRmZ3J0cjJfbWFza3MsIEhERkdSVFIyX0VM
Mik7DQo+ICtGR1RfTUFTS1MoaGRmZ3d0cjJfbWFza3MsIEhERkdXVFIyX0VMMik7DQo+IMKgDQo+
IMKgc3RhdGljIF9faW5pdCBib29sIGFnZ3JlZ2F0ZV9mZ3QodW5pb24gdHJhcF9jb25maWcgdGMp
DQo+IMKgew0KPiDCoAlzdHJ1Y3QgZmd0X21hc2tzICpybWFza3MsICp3bWFza3M7DQo+ICsJdTY0
IHJyZXN4LCB3cmVzeDsNCj4gwqANCj4gwqAJc3dpdGNoICh0Yy5mZ3QpIHsNCj4gwqAJY2FzZSBI
RkdSVFJfR1JPVVA6DQo+IEBAIC0yMTU0LDI0ICsyMTU1LDI3IEBAIHN0YXRpYyBfX2luaXQgYm9v
bCBhZ2dyZWdhdGVfZmd0KHVuaW9uDQo+IHRyYXBfY29uZmlnIHRjKQ0KPiDCoAkJYnJlYWs7DQo+
IMKgCX0NCj4gwqANCj4gKwlycmVzeCA9IHJtYXNrcy0+cmVzMCB8IHJtYXNrcy0+cmVzMTsNCj4g
KwlpZiAod21hc2tzKQ0KPiArCQl3cmVzeCA9IHdtYXNrcy0+cmVzMCB8IHdtYXNrcy0+cmVzMTsN
Cj4gKw0KPiDCoAkvKg0KPiDCoAkgKiBBIGJpdCBjYW4gYmUgcmVzZXJ2ZWQgaW4gZWl0aGVyIHRo
ZSBSIG9yIFcgcmVnaXN0ZXIsIGJ1dA0KPiDCoAkgKiBub3QgYm90aC4NCj4gwqAJICovDQo+IC0J
aWYgKChCSVQodGMuYml0KSAmIHJtYXNrcy0+cmVzMCkgJiYNCj4gLQnCoMKgwqAgKCF3bWFza3Mg
fHwgKEJJVCh0Yy5iaXQpICYgd21hc2tzLT5yZXMwKSkpDQo+ICsJaWYgKChCSVQodGMuYml0KSAm
IHJyZXN4KSAmJiAoIXdtYXNrcyB8fCAoQklUKHRjLmJpdCkgJg0KPiB3cmVzeCkpKQ0KPiDCoAkJ
cmV0dXJuIGZhbHNlOw0KPiDCoA0KPiDCoAlpZiAodGMucG9sKQ0KPiAtCQlybWFza3MtPm1hc2sg
fD0gQklUKHRjLmJpdCkgJiB+cm1hc2tzLT5yZXMwOw0KPiArCQlybWFza3MtPm1hc2sgfD0gQklU
KHRjLmJpdCkgJiB+cnJlc3g7DQo+IMKgCWVsc2UNCj4gLQkJcm1hc2tzLT5ubWFzayB8PSBCSVQo
dGMuYml0KSAmIH5ybWFza3MtPnJlczA7DQo+ICsJCXJtYXNrcy0+bm1hc2sgfD0gQklUKHRjLmJp
dCkgJiB+cnJlc3g7DQo+IMKgDQo+IMKgCWlmICh3bWFza3MpIHsNCj4gwqAJCWlmICh0Yy5wb2wp
DQo+IC0JCQl3bWFza3MtPm1hc2sgfD0gQklUKHRjLmJpdCkgJiB+d21hc2tzLT5yZXMwOw0KPiAr
CQkJd21hc2tzLT5tYXNrIHw9IEJJVCh0Yy5iaXQpICYgfndyZXN4Ow0KPiDCoAkJZWxzZQ0KPiAt
CQkJd21hc2tzLT5ubWFzayB8PSBCSVQodGMuYml0KSAmIH53bWFza3MtDQo+ID5yZXMwOw0KPiAr
CQkJd21hc2tzLT5ubWFzayB8PSBCSVQodGMuYml0KSAmIH53cmVzeDsNCj4gwqAJfQ0KPiDCoA0K
PiDCoAlyZXR1cm4gdHJ1ZTsNCj4gQEAgLTIxODAsNyArMjE4NCw2IEBAIHN0YXRpYyBfX2luaXQg
Ym9vbCBhZ2dyZWdhdGVfZmd0KHVuaW9uDQo+IHRyYXBfY29uZmlnIHRjKQ0KPiDCoHN0YXRpYyBf
X2luaXQgaW50IGNoZWNrX2ZndF9tYXNrcyhzdHJ1Y3QgZmd0X21hc2tzICptYXNrcykNCj4gwqB7
DQo+IMKgCXVuc2lnbmVkIGxvbmcgZHVwbGljYXRlID0gbWFza3MtPm1hc2sgJiBtYXNrcy0+bm1h
c2s7DQo+IC0JdTY0IHJlczAgPSBtYXNrcy0+cmVzMDsNCj4gwqAJaW50IHJldCA9IDA7DQo+IMKg
DQo+IMKgCWlmIChkdXBsaWNhdGUpIHsNCj4gQEAgLTIxOTQsMTAgKzIxOTcsMTQgQEAgc3RhdGlj
IF9faW5pdCBpbnQgY2hlY2tfZmd0X21hc2tzKHN0cnVjdA0KPiBmZ3RfbWFza3MgKm1hc2tzKQ0K
PiDCoAkJcmV0ID0gLUVJTlZBTDsNCj4gwqAJfQ0KPiDCoA0KPiAtCW1hc2tzLT5yZXMwID0gfiht
YXNrcy0+bWFzayB8IG1hc2tzLT5ubWFzayk7DQo+IC0JaWYgKG1hc2tzLT5yZXMwICE9IHJlczAp
DQo+IC0JCWt2bV9pbmZvKCJJbXBsaWNpdCAlcyA9ICUwMTZsbHgsIGV4cGVjdGluZw0KPiAlMDE2
bGx4XG4iLA0KPiAtCQkJIG1hc2tzLT5zdHIsIG1hc2tzLT5yZXMwLCByZXMwKTsNCj4gKwlpZiAo
KG1hc2tzLT5yZXMwIHwgbWFza3MtPnJlczEgfCBtYXNrcy0+bWFzayB8IG1hc2tzLT5ubWFzaykN
Cj4gIT0gR0VOTUFTSyg2MywgMCkgfHwNCj4gKwnCoMKgwqAgKG1hc2tzLT5yZXMwICYgbWFza3Mt
PnJlczEpwqAgfHwgKG1hc2tzLT5yZXMwICYgbWFza3MtDQo+ID5tYXNrKSB8fA0KPiArCcKgwqDC
oCAobWFza3MtPnJlczAgJiBtYXNrcy0+bm1hc2spIHx8IChtYXNrcy0+cmVzMSAmIG1hc2tzLQ0K
PiA+bWFzaynCoCB8fA0KPiArCcKgwqDCoCAobWFza3MtPnJlczEgJiBtYXNrcy0+bm1hc2spIHx8
IChtYXNrcy0+bWFzayAmIG1hc2tzLQ0KPiA+bm1hc2spKSB7DQo+ICsJCWt2bV9pbmZvKCJJbmNv
bnNpc3RlbnQgbWFza3MgZm9yICVzICglMDE2bGx4LA0KPiAlMDE2bGx4LCAlMDE2bGx4LCAlMDE2
bGx4KVxuIiwNCj4gKwkJCSBtYXNrcy0+c3RyLCBtYXNrcy0+cmVzMCwgbWFza3MtPnJlczEsDQo+
IG1hc2tzLT5tYXNrLCBtYXNrcy0+bm1hc2spOw0KPiArCQltYXNrcy0+cmVzMCA9IH4obWFza3Mt
PnJlczEgfCBtYXNrcy0+bWFzayB8IG1hc2tzLQ0KPiA+bm1hc2spOw0KPiArCX0NCj4gwqANCj4g
wqAJcmV0dXJuIHJldDsNCj4gwqB9DQoNCg==

