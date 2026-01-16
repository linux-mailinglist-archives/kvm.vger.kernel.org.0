Return-Path: <kvm+bounces-68362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 77FA3D38408
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 19:11:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DA7C730D120E
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:11:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B057379998;
	Fri, 16 Jan 2026 18:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kLzyQUzy";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kLzyQUzy"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010060.outbound.protection.outlook.com [52.101.84.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F056E344025
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 18:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.60
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768587082; cv=fail; b=LMLATFhX/U59ejlAHRhuGBvOy4LEbpSESgwkgkKXQcOAlcaVhTsV+XocG8lfdAn4Jn5rlkdqoaTmU79hHzUdNHRXjX1R0kSfVOtN2wMkmJgJLGZey3hNxQ6Z1GrxwdO/8KHjyX/8j/bcH3SNcFttefRdzKhr8dtdcnC/yyh/4/k=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768587082; c=relaxed/simple;
	bh=bulxRA0lhooBlWotkQN24CUZ6e9E0hSVB3Q2jf3Zf/4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=V1yOikv/kg1lRHhRKilYJVMgNi4xRmlrdiQSDXFioul0l7FTtvu1ZMBnsUiR68W36bSWBp9CzwVXQVtS9Vcp96IpFgdLMOAU9F8dhQFQnmn15jJqVaVm5VMxw5+uoKb++KKt1mUmUEeYZ/lI3WLr0UN2Zscxvnhz6ZZV7kBpuDE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kLzyQUzy; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kLzyQUzy; arc=fail smtp.client-ip=52.101.84.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=mmqtoYSPkjzOZ0PTOqSr6kZcCVLs4atWjXODh0I1nZ4NmhXba8iCKa7UdZWysWmMjNA14I+xM9LVmGFqa8B8IR/H5eAeMwKTKUiOk7akfszVjUOemh7o2cI5X745rj/+yl3GSIdP9uyMlOQaj6xa8GWSrbGsKOv1tqzJXcbyvBhx7hJMfsh4CoiDqNGQ8LRMlPlM2RFW0w2wR+TubQcu3B4t+8xIDJO1hd8PIoKOMnqXLzmGgnrU4TlVLko00ktlJrFuCXkY4KrrmZemjH0520dG529PYT+mEOu3aal3ZQGeOVR7bODVuxlAyxUFO4JmKURjtgBpVOhwMUtuDBGT+g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bulxRA0lhooBlWotkQN24CUZ6e9E0hSVB3Q2jf3Zf/4=;
 b=TlR8NW5ABpkOW7lWSdy3PN3hMsgCisQwu1rFqvkwkSGN/OcGBTSuVM+adONWfrmLbI5I1TE3I3pMQjFrqsSRfL6odlwwupa0F8rWAKnIkUFxPiziLa9Irse6DI3Mg1iiYafHkqoo8GUOcTnNOsrS4+cbges5xstTzT09fcA6zAN8/L9DwkDVWuqcdgteS/BiAvtXXUtQ7NHHxD8QEVdJkDtsTJ+h1Hhc7QCqPXCtVz7VnFk/7g2plkvUdP/xVjv1ShyvU/LwJfLEwIl+8DseERR6wmApS3twvlWoDNQGLplToF9NfOd9lAO7cmUxJa/LzTZSCs9U1+SXX6aFBXn1CQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bulxRA0lhooBlWotkQN24CUZ6e9E0hSVB3Q2jf3Zf/4=;
 b=kLzyQUzyhX8XjSSh3noz0lVASJSlHItKY8SEv+axpHgLaBkftTvGZRiLZUJSp6lP86G+Biy7GdsXrgfPAbqoSBhCdhI0in2SObYjw3pgCAB5GDm+1DmZghqmbhVvACjfhZ525cX5Pmap2tsBwalXy4xQGI4W5s4125+YzN6BmUg=
Received: from DU2PR04CA0204.eurprd04.prod.outlook.com (2603:10a6:10:28d::29)
 by AS8PR08MB8419.eurprd08.prod.outlook.com (2603:10a6:20b:567::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 18:11:17 +0000
Received: from DU2PEPF00028D05.eurprd03.prod.outlook.com
 (2603:10a6:10:28d:cafe::ff) by DU2PR04CA0204.outlook.office365.com
 (2603:10a6:10:28d::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.7 via Frontend Transport; Fri,
 16 Jan 2026 18:11:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D05.mail.protection.outlook.com (10.167.242.165) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 16 Jan 2026 18:11:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UEtKXhA4EjFz2v2yni3Goji1DYGSMoH64KQrul98bY6SbFkI+zItpre8f06XCjJ2bew9bccMPx554eF/wUvXRVtmfjULfedtp5IKI1d+tUavyhyndLwDjpAKxLxNIKr7Ij6pRjVMHOThNiRUUNI1NwQxO4zOUw7fdnY7au6ln6UYFw+wfUF4s2ug5VraAm28hGRwewdna2QDitji8mlD6JtrdxOrJSv3u4KPBLM1zCmJJKMIYk59gPT/5E/5tz8TOxRgVzcViSsayw1JOHRrzyGUCdEgQFkiZxCaZEEN/jUiIjt4duovUTSt9hnb6a75KcmWuSa8ggiWOWXYQ+YbKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bulxRA0lhooBlWotkQN24CUZ6e9E0hSVB3Q2jf3Zf/4=;
 b=EY99pl7v6Ei/rlBbVszdUYvIfjNpHXTUR/QafnE5oUzAMklwXJOpGy4Rk36N33INbtlUPJTq5f/vHU7zK0Rl8tvjJqcVOQUbps4JqDU2AftFcSFVwAvvi8k2M7N8fDyY6Dd2PyRsSPqDAKw1vu2hiPCiI93EPEqXSuIMOSUFvBJ6rLHsUctoYWgWWxXWYFBOes0h/RMzAksRbqwppZJt94oWmXb6lOBnmyL1i6lxYzv76StKCivwspc9v/saV86JdUHukCqs+weCNfGfSiIuGvd4AHDMHNrVVJyJpnKjiTi8x1Facw+gVfvPovUKnsuJaNjoO80cwUlAOJ1N1JRE0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bulxRA0lhooBlWotkQN24CUZ6e9E0hSVB3Q2jf3Zf/4=;
 b=kLzyQUzyhX8XjSSh3noz0lVASJSlHItKY8SEv+axpHgLaBkftTvGZRiLZUJSp6lP86G+Biy7GdsXrgfPAbqoSBhCdhI0in2SObYjw3pgCAB5GDm+1DmZghqmbhVvACjfhZ525cX5Pmap2tsBwalXy4xQGI4W5s4125+YzN6BmUg=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by GV2PR08MB9376.eurprd08.prod.outlook.com (2603:10a6:150:d0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 18:10:11 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 18:10:11 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: Andre Przywara <Andre.Przywara@arm.com>, "will@kernel.org"
	<will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Alexandru Elisei <Alexandru.Elisei@arm.com>, nd <nd@arm.com>
Subject: Re: [PATCH kvmtool v4 3/7] arm64: nested: Add support for setting
 maintenance IRQ
Thread-Topic: [PATCH kvmtool v4 3/7] arm64: nested: Add support for setting
 maintenance IRQ
Thread-Index: AQHcg6rlZrYu4QboQ02LT26IdoPyCrVVH14A
Date: Fri, 16 Jan 2026 18:10:11 +0000
Message-ID: <3d2a364595956d06624102684418bdad2a9d20b6.camel@arm.com>
References: <20250924134511.4109935-1-andre.przywara@arm.com>
	 <20250924134511.4109935-4-andre.przywara@arm.com>
In-Reply-To: <20250924134511.4109935-4-andre.przywara@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|GV2PR08MB9376:EE_|DU2PEPF00028D05:EE_|AS8PR08MB8419:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ba15a68-06ee-47a2-e266-08de552aa41e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?ajdIbDl4RHE4eDJhOHp0VUpBaG10MzBycjN5azNiVjhGM0F0dWtKaktmdHRs?=
 =?utf-8?B?N25oVEVnZEl4ZnlLQWJLdFhDa09xUjZxTjBXYzFINlZOaGRaQ1lPTTZ4ajg3?=
 =?utf-8?B?cUN3VWlCTjFNanF3WUd4SXc3aVJjakNoWjFWbkFydGl4eUtGSEtHam1BNzNt?=
 =?utf-8?B?TzZRTTlqeWlXMnlPbmZJbEJpem1uMmtkQkxidjlzQThIMWhxRUJIQ1RjTmQv?=
 =?utf-8?B?aWh0aFBQUVl2UnhiSXQ5RWxrVjcxMElGMmxxMWNJTFNGaUFTRXpYK3hPeFZl?=
 =?utf-8?B?VHBMNlBDMDliaVN6ZVdPVjlBMm1kQUVlcWhQTncrOXhkN2FGcG1QdEEydyt4?=
 =?utf-8?B?VklYQXZJclNjZmxSbFdLSUFvSlpLZk43N2VIR3FmRTlEaXJEU3oxMmt0OGRB?=
 =?utf-8?B?dkFGamUzVHpZcEIrSlhYSWd0MUMvRWt1eGdGNkNRaWxKeUlkbFJEUERnbkl5?=
 =?utf-8?B?NFlidnRvbVVpS29qZTBZa3I5YTQxcWExVjFRd3RSL3FidFBIc21KZjR5a3kv?=
 =?utf-8?B?M0JwZmp4Vk5xeGFsVFI0ME9OT0JxWUdZb3g1Tm9Vai9Nak9USFFWVGljYXor?=
 =?utf-8?B?V2VIOC9hSEFYMG9PUUhrNmpvdnZNVUZuTXZVMzNsU2ZQWDJERTN2Vy8raTZm?=
 =?utf-8?B?bTc0VHgwcWtHZm1tSFhZTTFZbkRxWEhKR2NqcWw3Y00zcFN2NUo0VGMvdDB4?=
 =?utf-8?B?cUprNWs2MVlGME56NkNEYjQ4aFVnVjVrcngyaTJBK1BOTUd4bDQ4YlN6dEFX?=
 =?utf-8?B?OGViVXV1OHlVSWdOb2hVS0FHMWxOU0h0YVpvT0J0WHZrRGJzRmtwYlhsNFZ3?=
 =?utf-8?B?bEpEMzE3Q3M3aWJma3ZOeWsxWDVFUjl2S2l2Mys3MG0vemUzaTFhOGlacUpW?=
 =?utf-8?B?a0MwZTI2a3p6UWx2MU1zMk9YYVpVWkgzT2FnS0gzM2xZUXFGc21oVm1TUy9v?=
 =?utf-8?B?a3hDTjJVVVJYWC90MHZ6RTBJb1FVYUpNYWdFbnVkbUV0Sm16UlFwRDdsZk93?=
 =?utf-8?B?WFpPUFJnalNMYS9ueVZCRFNWdjJhaThGVU5wZG1jaHgrWG9KZ1JlS3Zacm1Y?=
 =?utf-8?B?UzlkaDBJcDhObEsza09lZ29udlVBUUZMbGFMdlVlYm5FYUVkaTZKODBVczVz?=
 =?utf-8?B?dkJQaFpJS2F3SDJ0blJBeWVWRU9uT016bnhoOG9CdXFJTUhZR2M2aldHVXEv?=
 =?utf-8?B?cmY5SDJ3TldvSTVQRG9ybEg4SDJoZXJPU2NwNzVtd3laazFqQ3F6SVl4OTVr?=
 =?utf-8?B?M2pucXRVaEg3c0NLVTVSYkpUSzRzOUtGT2x4dkVMK2gzVEdLRW1tRFVTaCtq?=
 =?utf-8?B?UHdUNzRFWEZtbGRzYkZFVHZ5L3k1SExNd3N4anNNRUlkSkRyU1YvbUZiU2kv?=
 =?utf-8?B?U1E0QWhsTE1pNFBncWxSWWFVdXRiZXdsS01qVVhJZlNrR3BNWm5GQXJvQ0hk?=
 =?utf-8?B?Wk1DalVuckdlTDl2YkpJdXZxUVVielNLWHhJaVJzaDRCbjhueUQwWjIvT3FV?=
 =?utf-8?B?S1drS0pzL1EvT2lwaTlSL202U2VQdERBdW9IZ0ZLbGFyZTZtRmJ3ZUhnRUs0?=
 =?utf-8?B?R3JPSHgrajdXUWFrUnRXV3hFdUxsT3lSVVFWRkE5OXFtZFNLTWVMcWM2ZjVp?=
 =?utf-8?B?RWFYSHJ2M01aaXRJM3BGVzVmU2pIYVlEL29VZ2dhT0ZGYmtRRDNldU8yL2FU?=
 =?utf-8?B?U3dEcVdXbDRqaVNqOUl0ajZLQnBqaFhOT1hFbDltTFpaZjkrd2pBOXFPZHo3?=
 =?utf-8?B?YmNHRlJoN25WTmMxUjFPbi83QkYyZjA0d2pEMk41YlBYREE0dGhqVndUZlYz?=
 =?utf-8?B?NXRlaHc5QlBQV2cxWWY5ZmlhNnR5TDhDa1VQbkF1V1BoT0ZwWFFDeTJEWm5s?=
 =?utf-8?B?YUZtY3hVMTIzUm1KSlBiQkt6c1hpby9UVVBPeTk0Mkp3cmFndCtLKzN5RHdk?=
 =?utf-8?B?QVFHSXNJbExheS9KS05Wc1lqamh3ZnhMQVo4SUR1OGNZREVjYWlTZnNtdk1o?=
 =?utf-8?B?UWlPN0dDcVFxZ2tYZ01ybjNoZkM5VGRrdXJWZjNzMmFGaEREb2s4dWljQlBi?=
 =?utf-8?B?b0k1dmhtZWc0YXBIUWdhVEJ6Vkh6d0ZPOE12OFJrdnF0NTZDVHJmWW4yQVRU?=
 =?utf-8?B?WWtObmVNOURKR2prQTMrOVI4NHllUnlSTG5KTktlREFaOE1HZzNNS3VIMEt3?=
 =?utf-8?Q?E4A1m9KpUJt2FvLzIpAEUOw=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <2798D33CFF916A47BE48CFF57D90A128@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB9376
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D05.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b206a923-ce6e-45f7-2538-08de552a7d64
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|376014|14060799003|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZDhpL2lkNklBcE85cGpiRUZRLzV4VGtuZzV0em9BNnQrdi9mT1pVMldtSGVQ?=
 =?utf-8?B?ZWhENXlUT3orKzR6Wjh5ajFZM3Fvandwa1RVS0s3R0haRHQ4V0R3azZTcjBD?=
 =?utf-8?B?TUE1eGtoMnpreHhpMUhSaEQ5YWZSd3VTUHEranY3dWlJcU9KMU1VQXVEOU92?=
 =?utf-8?B?L0hnMjdldGlOUUZoSkxTV0g4SzBrUXdQNy9JVHBFNkN4MUJlL2tCenYyVVZ0?=
 =?utf-8?B?Y3VHWVp4SUFaajlLaUF5bU80VU00YjR0TmhtR3VEZ0dRRzJpb1JQMVBzQm80?=
 =?utf-8?B?NlBsZlRGdkV6QjlHNVpxUTVweWxrdDlmeWFTK3VnTjVlR1htTVExRUJDVnVm?=
 =?utf-8?B?MjZpZGF3WXl4SEE1WWRDSi96Wk8yc3RXQk84TVJZMXhLb2N3L2Y3RTNEdzFC?=
 =?utf-8?B?Qm1BekNZK29ERmpEanIvL1B6TXpQUS9RaHB4N1BUTGxaMi9HWFFUTkFTMjFx?=
 =?utf-8?B?THNRdDZ6cFBVMVdJNzFqU0lNdTlvOUo2QmY4VmFqTm53OHJYakVRSG81cy8w?=
 =?utf-8?B?Q3FrK3JrQkxQdmZKelo1dkhIaUVYRThWSlRDTmNMbVg4dG9oUWNFZHZoMjlV?=
 =?utf-8?B?RlRsQkFPajFiVWJ0c3FuUWF0U1NpaUptbDBtSmVHcEpZM0FySmg2ZFd3Sldr?=
 =?utf-8?B?c0xOdWsya0M0RzRNbVowMkh2RXZ0NUJlUG5WQk5QbExseGhOYUFva0dYNTdi?=
 =?utf-8?B?UENuNjZUMjBHeDI3TWNyUU1OaXZXU09CY0dmbU41WVpNcXpabTdaYmtZUGkw?=
 =?utf-8?B?UVlGUjY3VExQSjEvS0FnUUxxMjIvbWkxVDByeVcyS3J0dFdMNXNlR3hGZE9q?=
 =?utf-8?B?T29xY25NaG50Tk5yK0psRlVSNTdXUEhhcXVINVFiTUk0dHNDSFZCeXNJUGVJ?=
 =?utf-8?B?UlZHQmprY21DMXNuaTkwcWQ0c0dJYXhRYVJUT2ZzM3FiZllLUzlCMjlWaGtU?=
 =?utf-8?B?Tjdub2NIdEkxR0VCKzBWQVZGb3RRd3pGak42NnRERDl4WVVVMU1OUXJEQ1J6?=
 =?utf-8?B?dnpkWEdrUjRnQkpGZlFpRlBKUlFKQjVOd2RWWmF4UCtKczlYWGgzN0xUVzZy?=
 =?utf-8?B?bW9paVI0OU9lK1EwSzFSVGIxUy9STXJFRXBXRjhLczlqU1Q2eFd6QlVWYzBT?=
 =?utf-8?B?cy9SNDFtNWNwYlVnaUNTMlNnaWFBZUdkcE1tWVh1TzVTem1OSUxBd3dvNWxi?=
 =?utf-8?B?SS9JK1BpS1lOd1RzbjVnaEIzWkxTcTkzNWJZUzJmcWkzV3JEZHRhZ0g3QXE0?=
 =?utf-8?B?Y2l0YlN1bmZ4VXVOUmNRaXpHUE9SQXE1QmorMFRzU1RyWldaUytJQXl2VWhy?=
 =?utf-8?B?L21HNUpId0RTOXljaUFqYU1BdllHU0VDRTg0SzYxTmRnTmtRa1h3bW94UE1O?=
 =?utf-8?B?SWZJOU9NQitsa1huUm9jM0R0K29UWHRkNFJuYXBwdGJNT0dkY3lsUUlPVmNr?=
 =?utf-8?B?V2xNQ1JidFREM0NXVmpaYVdFQkMzb0YyRDNnUWtDL1FqOTdnN3NGYzAvMm5Z?=
 =?utf-8?B?cGNpYnZYdk5KdHM2WTgremh2STlRenUvbkFPOEtYZloyT1prVnEzeVZWVWhG?=
 =?utf-8?B?SitGQml5aEdqSHF3M1Z2Nm96cUhYQjNld2lhWHFqTm1zVU4yN3VnRUhSOUNp?=
 =?utf-8?B?NFN6aXVqWXVBZ1BKR0U4RUhNSVNicHBtYUpaQWZwdFllZ1BQei9reFIralFH?=
 =?utf-8?B?cC9VTzRhUWVmZnBpWkUwTFhTbENCb2JGV3VqQXgzSnFDRWpPVlUzTHorOFRB?=
 =?utf-8?B?a0FsWU8yYVRGeE9tUktOOUZETjdCQ0M2Q0hKSXV4NzluRlRQNUJFQlB6TEVz?=
 =?utf-8?B?K0lBcDdDUFF6SVpKMVUxM3VzaUp3YnBYMUxidXdFcEFUV0IreUF2YnpyZE9a?=
 =?utf-8?B?S1hUaENEYktqOEFoaWJ1WWNDOHhVLzhJZHhPdklmMGV1cWNFYWltVEF1Rkhu?=
 =?utf-8?B?SzkydHpvbFg0a3VtZTV5WGJwRjIveFpPSlhKT044YWRRZnNvTXlxYWdtZDJZ?=
 =?utf-8?B?bmdTd2IzK0FIK2NQT21TTWN5STZSdHljaVlWZEhsN2hPRkYwU2NTeTJocUli?=
 =?utf-8?B?RDlKUWliV1RpSnhoYURGL2RQNUYrenEzakNRQUZuNTZHN0N1Wlpuc3NoYUlj?=
 =?utf-8?B?RjFwTEtDcmNZc1dqd2pzOTAwbDR3ekZVOGdtdHZXalMrRVNlWFQrS0JoZG4v?=
 =?utf-8?B?aC8wbVdXUmZjSzJlQkZONEltdGk5a0VxQjFxUE45Rm5OMU9CTFVYRndsU20w?=
 =?utf-8?B?R1c3czAvR3hnOXZWcUE1QlBiRU1nPT0=?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(376014)(14060799003)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 18:11:16.2580
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ba15a68-06ee-47a2-e266-08de552aa41e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D05.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8419

T24gV2VkLCAyMDI1LTA5LTI0IGF0IDE0OjQ1ICswMTAwLCBBbmRyZSBQcnp5d2FyYSB3cm90ZToN
Cj4gVXNlcyB0aGUgbmV3IFZHSUMgS1ZNIGRldmljZSBhdHRyaWJ1dGUgdG8gc2V0IHRoZSBtYWlu
dGVuYW5jZSBJUlEuDQo+IFRoaXMgaXMgZml4ZWQgdG8gdXNlIFBQSSA5LCBhcyBhIHBsYXRmb3Jt
IGRlY2lzaW9uIG1hZGUgYnkga3ZtdG9vbCwNCj4gbWF0Y2hpbmcgdGhlIFNCU0EgcmVjb21tZW5k
YXRpb24uDQo+IFVzZSB0aGUgb3Bwb3J0dW5pdHkgdG8gcGFzcyB0aGUga3ZtIHBvaW50ZXIgdG8N
Cj4gZ2ljX19nZW5lcmF0ZV9mZHRfbm9kZXMoKSwNCj4gYXMgdGhpcyBzaW1wbGlmaWVzIHRoZSBj
YWxsIGFuZCBhbGxvd3MgdXMgYWNjZXNzIHRvIHRoZSBuZXN0ZWRfdmlydA0KPiBvbg0KPiB0aGUg
d2F5Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQW5kcmUgUHJ6eXdhcmEgPGFuZHJlLnByenl3YXJh
QGFybS5jb20+DQo+IC0tLQ0KPiDCoGFybTY0L2FybS1jcHUuY8KgwqDCoMKgwqDCoMKgwqAgfMKg
IDIgKy0NCj4gwqBhcm02NC9naWMuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IDI2ICsrKysr
KysrKysrKysrKysrKysrKysrKy0tDQo+IMKgYXJtNjQvaW5jbHVkZS9rdm0vZ2ljLmggfMKgIDIg
Ky0NCj4gwqAzIGZpbGVzIGNoYW5nZWQsIDI2IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJtNjQvYXJtLWNwdS5jIGIvYXJtNjQvYXJtLWNwdS5jDQo+
IGluZGV4IDY5YmIyY2IyYy4uMDg0M2FjMDUxIDEwMDY0NA0KPiAtLS0gYS9hcm02NC9hcm0tY3B1
LmMNCj4gKysrIGIvYXJtNjQvYXJtLWNwdS5jDQo+IEBAIC0xNCw3ICsxNCw3IEBAIHN0YXRpYyB2
b2lkIGdlbmVyYXRlX2ZkdF9ub2Rlcyh2b2lkICpmZHQsIHN0cnVjdA0KPiBrdm0gKmt2bSkNCj4g
wqB7DQo+IMKgCWludCB0aW1lcl9pbnRlcnJ1cHRzWzRdID0gezEzLCAxNCwgMTEsIDEwfTsNCj4g
wqANCj4gLQlnaWNfX2dlbmVyYXRlX2ZkdF9ub2RlcyhmZHQsIGt2bS0+Y2ZnLmFyY2guaXJxY2hp
cCk7DQo+ICsJZ2ljX19nZW5lcmF0ZV9mZHRfbm9kZXMoZmR0LCBrdm0pOw0KPiDCoAl0aW1lcl9f
Z2VuZXJhdGVfZmR0X25vZGVzKGZkdCwga3ZtLCB0aW1lcl9pbnRlcnJ1cHRzKTsNCj4gwqAJcG11
X19nZW5lcmF0ZV9mZHRfbm9kZXMoZmR0LCBrdm0pOw0KPiDCoH0NCj4gZGlmZiAtLWdpdCBhL2Fy
bTY0L2dpYy5jIGIvYXJtNjQvZ2ljLmMNCj4gaW5kZXggYjBkM2ExYWJiLi5lMzU5ODZjMDYgMTAw
NjQ0DQo+IC0tLSBhL2FybTY0L2dpYy5jDQo+ICsrKyBiL2FybTY0L2dpYy5jDQo+IEBAIC0xMSw2
ICsxMSw4IEBADQo+IMKgDQo+IMKgI2RlZmluZSBJUlFDSElQX0dJQyAwDQo+IMKgDQo+ICsjZGVm
aW5lIEdJQ19NQUlOVF9JUlEJOQ0KPiArDQo+IMKgc3RhdGljIGludCBnaWNfZmQgPSAtMTsNCj4g
wqBzdGF0aWMgdTY0IGdpY19yZWRpc3RzX2Jhc2U7DQo+IMKgc3RhdGljIHU2NCBnaWNfcmVkaXN0
c19zaXplOw0KPiBAQCAtMzAyLDEwICszMDQsMTUgQEAgc3RhdGljIGludCBnaWNfX2luaXRfZ2lj
KHN0cnVjdCBrdm0gKmt2bSkNCj4gwqANCj4gwqAJaW50IGxpbmVzID0gaXJxX19nZXRfbnJfYWxs
b2NhdGVkX2xpbmVzKCk7DQo+IMKgCXUzMiBucl9pcnFzID0gQUxJR04obGluZXMsIDMyKSArIEdJ
Q19TUElfSVJRX0JBU0U7DQo+ICsJdTMyIG1haW50X2lycSA9IEdJQ19QUElfSVJRX0JBU0UgKyBH
SUNfTUFJTlRfSVJROw0KPiDCoAlzdHJ1Y3Qga3ZtX2RldmljZV9hdHRyIG5yX2lycXNfYXR0ciA9
IHsNCj4gwqAJCS5ncm91cAk9IEtWTV9ERVZfQVJNX1ZHSUNfR1JQX05SX0lSUVMsDQo+IMKgCQku
YWRkcgk9ICh1NjQpKHVuc2lnbmVkIGxvbmcpJm5yX2lycXMsDQo+IMKgCX07DQo+ICsJc3RydWN0
IGt2bV9kZXZpY2VfYXR0ciBtYWludF9pcnFfYXR0ciA9IHsNCj4gKwkJLmdyb3VwCT0gS1ZNX0RF
Vl9BUk1fVkdJQ19HUlBfTUFJTlRfSVJRLA0KPiArCQkuYWRkcgk9ICh1NjQpKHVuc2lnbmVkIGxv
bmcpJm1haW50X2lycSwNCj4gKwl9Ow0KPiDCoAlzdHJ1Y3Qga3ZtX2RldmljZV9hdHRyIHZnaWNf
aW5pdF9hdHRyID0gew0KPiDCoAkJLmdyb3VwCT0gS1ZNX0RFVl9BUk1fVkdJQ19HUlBfQ1RSTCwN
Cj4gwqAJCS5hdHRyCT0gS1ZNX0RFVl9BUk1fVkdJQ19DVFJMX0lOSVQsDQo+IEBAIC0zMjUsNiAr
MzMyLDEzIEBAIHN0YXRpYyBpbnQgZ2ljX19pbml0X2dpYyhzdHJ1Y3Qga3ZtICprdm0pDQo+IMKg
CQkJcmV0dXJuIHJldDsNCj4gwqAJfQ0KPiDCoA0KPiArCWlmIChrdm0tPmNmZy5hcmNoLm5lc3Rl
ZF92aXJ0ICYmDQo+ICsJwqDCoMKgICFpb2N0bChnaWNfZmQsIEtWTV9IQVNfREVWSUNFX0FUVFIs
ICZtYWludF9pcnFfYXR0cikpIHsNCj4gKwkJcmV0ID0gaW9jdGwoZ2ljX2ZkLCBLVk1fU0VUX0RF
VklDRV9BVFRSLA0KPiAmbWFpbnRfaXJxX2F0dHIpOw0KPiArCQlpZiAocmV0KQ0KPiArCQkJcmV0
dXJuIHJldDsNCj4gKwl9DQoNCldpdGggR0lDdjMgYXJlIHRoaW5ncyBub3QgYSBsaXR0bGUgYnJv
a2VuIGlmIHdlJ3JlIHRyeWluZyB0byBkbyBuZXN0ZWQNCmJ1dCBkb24ndCBoYXZlIHRoZSBhYmls
aXR5IHRvIHNldCB0aGUgbWFpbnQgSVJRPyBJdCBmZWVscyB0byBtZSBhcyBpZg0KYW4gZXJyb3Ig
c2hvdWxkIGJlIHJldHVybmVkIGlmIHRoZSBhdHRyIGRvZXNuJ3QgZXhpc3QuDQoNCkFsc28sIHRo
ZSB3YXkgdGhhdCB0aGUgRkRUIGlzIGdlbmVyYXRlZCBtZWFucyB0aGF0IHdlJ2Qgc3RpbGwgZ2Vu
ZXJhdGUNCnRoZSBwcm9wZXJ0eSBmb3IgdGhlIG1haW50IElSUSwgZXZlbiBpZiB3ZSBjYW4ndCBz
ZXQgaXQgaGVyZS4NCg0KVGhhbmtzLA0KU2FzY2hhDQoNCj4gKw0KPiDCoAlpcnFfX3JvdXRpbmdf
aW5pdChrdm0pOw0KPiDCoA0KPiDCoAlpZiAoIWlvY3RsKGdpY19mZCwgS1ZNX0hBU19ERVZJQ0Vf
QVRUUiwgJnZnaWNfaW5pdF9hdHRyKSkgew0KPiBAQCAtMzQyLDcgKzM1Niw3IEBAIHN0YXRpYyBp
bnQgZ2ljX19pbml0X2dpYyhzdHJ1Y3Qga3ZtICprdm0pDQo+IMKgfQ0KPiDCoGxhdGVfaW5pdChn
aWNfX2luaXRfZ2ljKQ0KPiDCoA0KPiAtdm9pZCBnaWNfX2dlbmVyYXRlX2ZkdF9ub2Rlcyh2b2lk
ICpmZHQsIGVudW0gaXJxY2hpcF90eXBlIHR5cGUpDQo+ICt2b2lkIGdpY19fZ2VuZXJhdGVfZmR0
X25vZGVzKHZvaWQgKmZkdCwgc3RydWN0IGt2bSAqa3ZtKQ0KPiDCoHsNCj4gwqAJY29uc3QgY2hh
ciAqY29tcGF0aWJsZSwgKm1zaV9jb21wYXRpYmxlID0gTlVMTDsNCj4gwqAJdTY0IG1zaV9wcm9w
WzJdOw0KPiBAQCAtMzUwLDggKzM2NCwxMiBAQCB2b2lkIGdpY19fZ2VuZXJhdGVfZmR0X25vZGVz
KHZvaWQgKmZkdCwgZW51bQ0KPiBpcnFjaGlwX3R5cGUgdHlwZSkNCj4gwqAJCWNwdV90b19mZHQ2
NChBUk1fR0lDX0RJU1RfQkFTRSksDQo+IGNwdV90b19mZHQ2NChBUk1fR0lDX0RJU1RfU0laRSks
DQo+IMKgCQkwLCAwLAkJCQkvKiB0byBiZSBmaWxsZWQgKi8NCj4gwqAJfTsNCj4gKwl1MzIgbWFp
bnRfaXJxW10gPSB7DQo+ICsJCWNwdV90b19mZHQzMihHSUNfRkRUX0lSUV9UWVBFX1BQSSksDQo+
IGNwdV90b19mZHQzMihHSUNfTUFJTlRfSVJRKSwNCj4gKwkJZ2ljX19nZXRfZmR0X2lycV9jcHVt
YXNrKGt2bSkgfCBJUlFfVFlQRV9MRVZFTF9ISUdIDQo+ICsJfTsNCj4gwqANCj4gLQlzd2l0Y2gg
KHR5cGUpIHsNCj4gKwlzd2l0Y2ggKGt2bS0+Y2ZnLmFyY2guaXJxY2hpcCkgew0KPiDCoAljYXNl
IElSUUNISVBfR0lDVjJNOg0KPiDCoAkJbXNpX2NvbXBhdGlibGUgPSAiYXJtLGdpYy12Mm0tZnJh
bWUiOw0KPiDCoAkJLyogZmFsbC10aHJvdWdoICovDQo+IEBAIC0zNzcsNiArMzk1LDEwIEBAIHZv
aWQgZ2ljX19nZW5lcmF0ZV9mZHRfbm9kZXModm9pZCAqZmR0LCBlbnVtDQo+IGlycWNoaXBfdHlw
ZSB0eXBlKQ0KPiDCoAlfRkRUKGZkdF9wcm9wZXJ0eV9jZWxsKGZkdCwgIiNpbnRlcnJ1cHQtY2Vs
bHMiLA0KPiBHSUNfRkRUX0lSUV9OVU1fQ0VMTFMpKTsNCj4gwqAJX0ZEVChmZHRfcHJvcGVydHko
ZmR0LCAiaW50ZXJydXB0LWNvbnRyb2xsZXIiLCBOVUxMLCAwKSk7DQo+IMKgCV9GRFQoZmR0X3By
b3BlcnR5KGZkdCwgInJlZyIsIHJlZ19wcm9wLCBzaXplb2YocmVnX3Byb3ApKSk7DQo+ICsJaWYg
KGt2bS0+Y2ZnLmFyY2gubmVzdGVkX3ZpcnQpIHsNCj4gKwkJX0ZEVChmZHRfcHJvcGVydHkoZmR0
LCAiaW50ZXJydXB0cyIsIG1haW50X2lycSwNCj4gKwkJCQnCoCBzaXplb2YobWFpbnRfaXJxKSkp
Ow0KPiArCX0NCj4gwqAJX0ZEVChmZHRfcHJvcGVydHlfY2VsbChmZHQsICJwaGFuZGxlIiwgUEhB
TkRMRV9HSUMpKTsNCj4gwqAJX0ZEVChmZHRfcHJvcGVydHlfY2VsbChmZHQsICIjYWRkcmVzcy1j
ZWxscyIsIDIpKTsNCj4gwqAJX0ZEVChmZHRfcHJvcGVydHlfY2VsbChmZHQsICIjc2l6ZS1jZWxs
cyIsIDIpKTsNCj4gZGlmZiAtLWdpdCBhL2FybTY0L2luY2x1ZGUva3ZtL2dpYy5oIGIvYXJtNjQv
aW5jbHVkZS9rdm0vZ2ljLmgNCj4gaW5kZXggYWQ4YmNiZjIxLi44NDkwY2NhNjAgMTAwNjQ0DQo+
IC0tLSBhL2FybTY0L2luY2x1ZGUva3ZtL2dpYy5oDQo+ICsrKyBiL2FybTY0L2luY2x1ZGUva3Zt
L2dpYy5oDQo+IEBAIC0zNiw3ICszNiw3IEBAIHN0cnVjdCBrdm07DQo+IMKgaW50IGdpY19fYWxs
b2NfaXJxbnVtKHZvaWQpOw0KPiDCoGludCBnaWNfX2NyZWF0ZShzdHJ1Y3Qga3ZtICprdm0sIGVu
dW0gaXJxY2hpcF90eXBlIHR5cGUpOw0KPiDCoGludCBnaWNfX2NyZWF0ZV9naWN2Mm1fZnJhbWUo
c3RydWN0IGt2bSAqa3ZtLCB1NjQgbXNpX2ZyYW1lX2FkZHIpOw0KPiAtdm9pZCBnaWNfX2dlbmVy
YXRlX2ZkdF9ub2Rlcyh2b2lkICpmZHQsIGVudW0gaXJxY2hpcF90eXBlIHR5cGUpOw0KPiArdm9p
ZCBnaWNfX2dlbmVyYXRlX2ZkdF9ub2Rlcyh2b2lkICpmZHQsIHN0cnVjdCBrdm0gKmt2bSk7DQo+
IMKgdTMyIGdpY19fZ2V0X2ZkdF9pcnFfY3B1bWFzayhzdHJ1Y3Qga3ZtICprdm0pOw0KPiDCoA0K
PiDCoGludCBnaWNfX2FkZF9pcnFmZChzdHJ1Y3Qga3ZtICprdm0sIHVuc2lnbmVkIGludCBnc2ks
IGludA0KPiB0cmlnZ2VyX2ZkLA0KDQo=

