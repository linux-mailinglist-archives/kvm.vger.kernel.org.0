Return-Path: <kvm+bounces-67359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 45D6DD02941
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 13:20:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9D67B30DF211
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 11:58:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CA823ACA44;
	Thu,  8 Jan 2026 09:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YpdBEzCQ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YpdBEzCQ"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013009.outbound.protection.outlook.com [40.107.159.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2210E3A7DE3
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 09:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.9
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767864896; cv=fail; b=YVcfQiW8nCqcQMidZ0t4Iae2bpIylJ2dLyWR4M5rU1ZrsOoBOPi5QlAILtPJ4GsNsNZ5JjMgOLr/MU2AVJ8SCw06pTR0aF+v+XVsUCvMBpYSErZk2fe0x4yg7i6g/XawkdQ8cWXhUPY7dT2XHHiHBkcLVpn66iE7XaHGBD+MnRE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767864896; c=relaxed/simple;
	bh=yyd4cGPy4pPLsa0RjXj8ymzplSqEfD6juBNKx0BMVo4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=h7cS4USCASKIwSNV6voo3uv9A+LxE2KZ1yZBxoChGKN5l6/H6uTykUHdFXEcH3Pp081boBMfKnhjPXeoLHfKYbTI0MG+JIRtuTtGtaES2i1JGLO12lmV6X2HBeGSatX95Fe3AuZ1e5cChhnOTz4c1sNFAdZyBqg1yClcdUKug6Q=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YpdBEzCQ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YpdBEzCQ; arc=fail smtp.client-ip=40.107.159.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Mi2MXFHr+qJkKKMKteHdPy9K14vhEUlcidUAhsGXQFzCR3x4xCVMEjG0Nn2nnlb4RJWFyHnu5DPBmY0YNUiahW7r7B1NTgGOS+PkDtavCFj9p++9rOxw+kSJrg5cwYTbCFYbf0DDO+ah/zkVurRezyfhp9demZtykZKYYy42a0t8PvN/UTXKOahkl4OYdtIxgatuDxsXnjtilLbxe7irZyya9csohiRAjVXx5XDLcevc15KOMeVzmE83f2F4mGlAJapvn/utw8FjQ4nJinukrazn3PlsoFWAzpMnvc/K+6aO4XZgGo+dI3b+b90Nbq1UrqHLoWwkNL5+IQx63IYYWw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yyd4cGPy4pPLsa0RjXj8ymzplSqEfD6juBNKx0BMVo4=;
 b=JRcr7L5zGZJsKtJBARNow2BV35I7Ct2OdcrASwyIrbaMzoOrGLxBs3nW+hOKBfYTHkKUnWayGY237TisIFHgSikr+/tXw/0AgnEenMe6fQTA1Y0OdhTTDCAYXLQ+kwhw6KTPiR8UqkaAiwOF0Ru23CcCu/TBkFMadGqlKvxkxPvsHIV1ifwF3JM99JjvETFD/7CqNfZCaWIUVNGAsNuzDbEVekm8tuEzsVWJTbV8BlSstVD8ZVc2IZOkial4KIdp2gYL0J/aD2PT3G0bU1vO+1Q3a3nKfL8MBsWUE3yYfrnA+P9FaYNrR2Bp3tl0T0IpZP/IGGc/Slvmdii3gN7z4g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yyd4cGPy4pPLsa0RjXj8ymzplSqEfD6juBNKx0BMVo4=;
 b=YpdBEzCQWBJHTRq+TyWhF57iokJU7Qyt146aK/aZ12iPFHr5GkYFP6Qjo78lQBEXNS74pcTQTedIzL48aUlLQBZYcorT5XLSBTjr04C2LerMcL4C72KrlFzeCxr1B2WkXfVu8Wo7EtMZZ/Iy+N+bcakcCZNQ/zKS30scGirZd6o=
Received: from DUZPR01CA0022.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46b::12) by VI0PR08MB10390.eurprd08.prod.outlook.com
 (2603:10a6:800:207::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Thu, 8 Jan
 2026 09:34:35 +0000
Received: from DU6PEPF0000B61C.eurprd02.prod.outlook.com
 (2603:10a6:10:46b:cafe::1a) by DUZPR01CA0022.outlook.office365.com
 (2603:10a6:10:46b::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.3 via Frontend Transport; Thu, 8
 Jan 2026 09:35:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B61C.mail.protection.outlook.com (10.167.8.135) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Thu, 8 Jan 2026 09:34:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xV8tk+6jGmOedeMBRwnRPMeilhoWZO/Iegsokv/CHbdA8xqKgZ9OxgTsB1R9/EevSIiDYPGQVT+9kdIDGqkpXaG21PlR4Ijtw5KzqSVcGImmHE+eu5ZlTSp/aS6TtYmfaHyhgIuQgKl1xNknqN980Mm0FBBwnlwwy9rkSmC0RGMFNbFUr1Ze/v0dAaaydMO4rpH+jlLIzRbRVdprwnWqLdZRPLeXs/dyQlJ0bIcfOR13/ZlHuqEY6Fri10qsE3haWL+kItZa3WOKU+C6pQpMWrJT9utejZMJkQ8Ci65ED4k6zzUKtX8L0nqavc7zXJjvrunFSZLWgwZl3abQoRxrZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yyd4cGPy4pPLsa0RjXj8ymzplSqEfD6juBNKx0BMVo4=;
 b=vk+s+6bBRtIv84FCfNZoCYH+I0kk5ShHnGSgU2Lh8YJCEVVKDzm+Ka5SQiFVeQ38MtCCYBDKu+D40R4Mv5k0Frr8JaUqcGjwrYOGtxmijq6AVJbW21ykQfnyiAUtS9hHwCMGiftjH+JM/3QAVPSTM7VkxQC6J0Aeh9WDOoMtyaNsn38m4oFe2QxI2G2uMRxhvz5Idnap+ECKuiiEj8RxC/W15b2vSrg0tGnAEcd74eTrnmbuvFYLy0iK05Q7nUW2XF+s9eJPvPeq0YOYulNFBiJRWX2mz9Wskkvm7Iu+nl95KU3MmEFoaha3Yv56xUUOVqT5Guc0mYZwD8NY00YapA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yyd4cGPy4pPLsa0RjXj8ymzplSqEfD6juBNKx0BMVo4=;
 b=YpdBEzCQWBJHTRq+TyWhF57iokJU7Qyt146aK/aZ12iPFHr5GkYFP6Qjo78lQBEXNS74pcTQTedIzL48aUlLQBZYcorT5XLSBTjr04C2LerMcL4C72KrlFzeCxr1B2WkXfVu8Wo7EtMZZ/Iy+N+bcakcCZNQ/zKS30scGirZd6o=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS8PR08MB6278.eurprd08.prod.outlook.com (2603:10a6:20b:29a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Thu, 8 Jan
 2026 09:33:31 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 09:33:30 +0000
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
Subject: Re: [PATCH v2 07/36] KVM: arm64: gic: Introduce interrupt type
 helpers
Thread-Topic: [PATCH v2 07/36] KVM: arm64: gic: Introduce interrupt type
 helpers
Thread-Index: AQHccP+Amw5F4YQtr0Wu9c2UcjY0frVFlqCAgAKLEoA=
Date: Thu, 8 Jan 2026 09:33:30 +0000
Message-ID: <5b9fd030e3048fadcd4ac95ddb0671e1af7dc960.camel@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	 <20251219155222.1383109-8-sascha.bischoff@arm.com>
	 <20260106184313.00002a8c@huawei.com>
In-Reply-To: <20260106184313.00002a8c@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|AS8PR08MB6278:EE_|DU6PEPF0000B61C:EE_|VI0PR08MB10390:EE_
X-MS-Office365-Filtering-Correlation-Id: ab8ce925-715f-4c11-64b7-08de4e99224e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?NkdGVWs4TUxjVkV0Z2Q1UHVtb1ZjSjVpSDdUZk5nL2JoMmFsU01iVisyRU1q?=
 =?utf-8?B?dGg4eFh4eUZka2xGOFF2b0NoZXg5dFVXZGR1QWV1elpkbnVNbVN0SFNLUEFu?=
 =?utf-8?B?NWJBVjIyVFRMdmc4UzhvajRDNlJ1dS8xQnJMUTcvRkM0Yi9vTWtDV1l3b1lx?=
 =?utf-8?B?aXNRbHhBRzRHbms1dFZCeWNqOHdrTGZYQVlIVnRaS0NDMzgyZTc5L1gvQzVY?=
 =?utf-8?B?NU5ocWdqeVpTTUFqVlN6SmxGNzJ1a0g2cTRPYUpUd04xdk1LOGhDUEVFbWxu?=
 =?utf-8?B?dzRRcVNGMVlEMzU3SEpISHZsNU00SGQ5NHpKMVpSdXlMM3BBYTBqcHpjRVJj?=
 =?utf-8?B?QVhtSnhpRW9LelZpQnFMWmNialB1c1ZkT0pSYVNVS3pVWWRocDU3OERZQ00y?=
 =?utf-8?B?dFNJZ1hXUW0wN2FaQUlXVVk5eWJxcEM4UnJVM1RsTjV2ZkxRRktIWlNzWEgr?=
 =?utf-8?B?M0JhM1JONW9hNXFlV3VURkUrUjJVQnlOZFdWQ1NROE5hZytRaW5mMGZwYVVx?=
 =?utf-8?B?MndPL1pRcUtiSm5NTW1hWTViT09Pb0tiZXgzakt3WEowdlRwR0xMWE1GMW1w?=
 =?utf-8?B?eXZSaDI5MlRCbTF0MkYraWE1UHZ0bHppTi9Qdnc3SlRlNU8xWEVqZ21oMFFE?=
 =?utf-8?B?WFNaeDFOK0ZJYWN0YXpGOUJpMUxyZEJITC9LSkVQMTdOTWVEdlFHcldoKzB3?=
 =?utf-8?B?SGVUa2xkS1RKTk5Kci9zVU1vaDNlSk1hNTdKQVBESWdWbnczMTU1OURFbzlZ?=
 =?utf-8?B?NVk5dEZtdk5HaVdMRTlOK3dVTUplSm1qQ1N5ZWxwbDlDMlk0MXZldUR1ejdo?=
 =?utf-8?B?T2lRWmZnTzl5Nk5sQytKSkZ5R0lNNnZueEc2WkJtZWgrbTg5QXRncERMcktx?=
 =?utf-8?B?OCtic3l2VDhPeGxoeTdFN2d3QjRaYVpmVlpaeGUybHhlUWhaVmZZSkhWVkxT?=
 =?utf-8?B?SkVqMEJLdHZnZEc4TXZJOHJQcVV3NXNvUzZhL1NLdkRuOHBUU1E4dmlKSVA4?=
 =?utf-8?B?Q09kSW1wNHIzbnhQbWZXN3NPVDBZSXd3MG44WUsydWxPdXV4ZTNCNEVYcXlP?=
 =?utf-8?B?NFhGb3NiT1R5U01qSnBsZ0UrL01ob21OTW5hUVNiVnpuSTl0Mk9NcExUWmFl?=
 =?utf-8?B?b0hYQUxYa0piYVNxU1FPY0V3dDVCeDl1b1BLZHluS3N2WTVJbXhPaXozK0Ft?=
 =?utf-8?B?UmFCUE0wcmdXQlc5czVJTEZVUzVuZThENFNLbTNWQVc1TG44WmgzK1NMeEhN?=
 =?utf-8?B?UmVYL2tvOXRkc2Q5bGVPbzUwaE5jOTBuWE5zb2lsc0kzcXNrWUdUVi81blBC?=
 =?utf-8?B?cHN1dEIzdmdkZjVBMENuSmVhVUJxbzFzTitXM2QwN0Y0aC92OUZ6b1NvL3Ay?=
 =?utf-8?B?M3lvYlQydTZXTkJkT2dHTkRrZEpEUmNpRUtKZjc3L09PMHB2YVFyZS9ORGx0?=
 =?utf-8?B?MWFLb3R5Z0NRQXRubGRkbW5TalMyN2orNjU4MWJZaWR3Mm1GS3ppZllMODFn?=
 =?utf-8?B?VUoxbGVEcFVzYTFEUXJJMUdxd2s0SFNYclNmNmxyTnlWZUdtTWo2Sm5DL2lG?=
 =?utf-8?B?MFFHM0FRQStJWUpueDJHbUhtcUkweHZVTjJTdDlwZWo3MlN2cG1wZDRVL3pu?=
 =?utf-8?B?eVBKOHpadkczYUVTY2R0TktNaVJNY0VBSGZVWmVFcUJEUTMwQ0dDVGxGeVdu?=
 =?utf-8?B?WUs1VEY3OC9jV0kvRTltenp1dUFPbzE4Rkhpa3RQdDhXdi9pNWZDLysyUFAv?=
 =?utf-8?B?WHVZeFpJRGFEdkMwZktSWmp6VFEwYzhhbUh1Y2JGdUl3YXhiYWVNbDE0eVR0?=
 =?utf-8?B?TndTMUp0RlcrQ0o1NS9CeHRxcGdxRWdER1BiS3A1VnhXV2xCSFBiOGxJSENE?=
 =?utf-8?B?dENVLyt5bWxMbUlWd2hMaHNTc1lhRFc1aW0wZy9ObGFQZ2dkRVNiWEhSbDNN?=
 =?utf-8?B?L0RYNGc0MDArdFIwcGY0RWg1OElRbGVBWGdITkM4b0RzY01BTUdDdUJpWWxB?=
 =?utf-8?B?TS81M3ByRFpIMmVveFlQdmp6U2pLUE85Z1hyVWgwaUhaN2tZSXRZbk9vWHhm?=
 =?utf-8?Q?LTLDNe?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <2F13F5E32425D249BFBDBD4417E4BCEC@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6278
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B61C.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a281dd0d-bbb3-45ce-a222-08de4e98fc03
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|35042699022|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MVRUMnJPMDNEODlIQ3RhYWJ2ZEE3dnZNVEJET2EwZG5uYXZSVC85dW4vNGZ2?=
 =?utf-8?B?MERJZ0xmb1dQaWZveE5UcS8wVDVwT0hsZUpQYlI4L3FtNG0zcHphaW1NVWE5?=
 =?utf-8?B?SzV3YkN6OVdSU3Q5ZGQ3ODlxSENid1NSYVFZR0JKSVBQSE02Mk9ySG1KaUtn?=
 =?utf-8?B?TUdNaHh6TEQ2MFc1eGFKUnhySWdkbmV3NERXWEkzLzQrY3JrWXVab05weVFI?=
 =?utf-8?B?MGhJTUJUR0xWQ0FveTJ0T1lINjNpVjJ2OEtTRVA4bzNHQ2h5Q3RKRkU2R2Zj?=
 =?utf-8?B?dG5hNUxESm8yWXROMW5rS2Q3Nm5OUlZ1K0ptR0E0S0ZJbDBMVkV2M3hLSmpl?=
 =?utf-8?B?cnB0OWo1OGE3RlEvVjdKU3dQWTFXSU5RK1Z6SmVxQzRhb1BwZ0lGUlZITm5P?=
 =?utf-8?B?djRUSVpQRUhYNzhrMWF2Qk9ndlljd1gvdS8yTVhHK20vRHIvQlZRTWRNL1N6?=
 =?utf-8?B?bWlPaXVSMERoN21hZGkvZVdzcThWZmV6RGtzQUZNUUphekxhWFpoMm1XYU9R?=
 =?utf-8?B?MFQ2dVBWcDJNaHVGRUplSVZjSEdYYlhhQWxXS3NVQXhOYUdxUEEyaFdFUElX?=
 =?utf-8?B?MlpmZFNzdW9SS0tHV2pybFVERHV2NUltZHZnS21MVG9nT3lsdzZCZmkyYVBk?=
 =?utf-8?B?T2NGdE9Ha3hSUnpjdkkySU5uYVZKaVRLQll6ZW1VZVdoM1czNFVlZXNPWmRI?=
 =?utf-8?B?N0NPTWNaN2EvOENoUFFaaGh6eUFXb0hvVlVtUDRCbStBdW5wNE1pbTg5eUMy?=
 =?utf-8?B?UmNmbVIweVI1dmIzZ2dnUmxQVW1Mbm9ndHhka2ZiVFlQbk9EQ0Z4MjhsT0hi?=
 =?utf-8?B?b2t6QVZ0OUZOcVpndUVsdEVzU2ZQdEpiSHFUYnpnU0hXYWdBbWExWFhjZ0I4?=
 =?utf-8?B?aFo1S1RKdEgvL1dmcjZNVUFNUzZxdHZlNlF2a2tKNWpNSHpSa0wwc0xFanBQ?=
 =?utf-8?B?QytZcWdielFpNnpkaCtkaFZjK25CQ243dVVLWUpWSERROUY4d2JtVHFMUnBC?=
 =?utf-8?B?VXZBOFVLdjZjcThMRVI4U2JQZTN3WUlBaHBpMC82a3o1K1FTK3FMcklWeTFO?=
 =?utf-8?B?OGZQTHYxMDQ4c0dycG94Zm5yQVNGZURvYWtXOVZ0WDJ6NDIrSjV6MEEzMXda?=
 =?utf-8?B?U1dheXhRWURYanpwRWN2SEtKdmxJd2d5VWRYMUk1NGUvT3dZdnJwV0hhYkE1?=
 =?utf-8?B?R2k1VHJob2VqQThTQVN5d044VEJhM2RlTGtMTWpMbVM5NVMyalpOdHBXbUhq?=
 =?utf-8?B?NkVzTFQ5ODRwQlVJS1dqTkEwQTdkK3dRdkkrMWtZbmxFU3hBRjRFaFlEb2Vz?=
 =?utf-8?B?SEdLak1jbUhhRjRVRTVoUzE2VEFuOXFVR0EwTkxITCtrZGpiS0VMKy95MHhQ?=
 =?utf-8?B?a3FhTnBlUmJ4Qm1TOVFSK011L0tDd2hFRXFUZmlaVnBabWZJSzdMWlRHSWx6?=
 =?utf-8?B?aHlOVjFzeG1SVW9TOHNhOVpzY2swUDlCWmRaRk51SGU4dmNNY2I2Z0s2d1pS?=
 =?utf-8?B?dlM5TDl1di9LRWxadGpsTHJoT2lZTXZpN2FGM1BiV1VKZ3RuT2ZRQXFtdndK?=
 =?utf-8?B?NytIOWtHdVl3ajljVW1uakJQL3BWSER3UTZkY0NiSjQvcU5MWC9KV29iWTYv?=
 =?utf-8?B?VHFnWW5lY005QlhmVnJ1WUZDbnVuWEZwZ3QwQndRaG9ibW10M3lqY0lvYnRv?=
 =?utf-8?B?cnhNT2NsNC8wN0cvcWZxVHRKVVcySHhKamxpRHltTGcwbFQ0SHhmbkkxalZ5?=
 =?utf-8?B?cXpnNFg3ZXpwM0RleTIrVkQ0N3I2dTVXeHNHMEl6TytSSnJhRHR1Ry9PTTNK?=
 =?utf-8?B?QmhIdXg0T3VPRmE1ME5OcVppdnN2NmUwZGwzSGNYbEZtUEFjTGZLRGw1akNG?=
 =?utf-8?B?cXg0Sm43RWp3SW4wb0kxOU5DNDU0MUcwOHdpZ3d3Rkd6YzhoRWd1czN1aWJL?=
 =?utf-8?B?b05QbVRma1p5ZkZPcXhEanV6SEFKR0NSVEhPb1ZNYzRJeGJ1VTNHNzZXRjZK?=
 =?utf-8?B?V2tDdEgrNmZXVHpwM1pqdHdYWkROdEFieDl6VWVqMnk5c0V3QXJvMkh0OS9q?=
 =?utf-8?B?UnZQYTNCS3oySzJlSFFoSDloNmtmcnZNL0g1TkRsMmdSdVd6ajRBSWdVM1l4?=
 =?utf-8?Q?QMVs=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(35042699022)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 09:34:34.4622
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab8ce925-715f-4c11-64b7-08de4e99224e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B61C.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10390

T24gVHVlLCAyMDI2LTAxLTA2IGF0IDE4OjQzICswMDAwLCBKb25hdGhhbiBDYW1lcm9uIHdyb3Rl
Og0KPiBPbiBGcmksIDE5IERlYyAyMDI1IDE1OjUyOjM4ICswMDAwDQo+IFNhc2NoYSBCaXNjaG9m
ZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiANCj4gPiBHSUN2NSBoYXMgbW92
ZWQgZnJvbSB1c2luZyBpbnRlcnJ1cHQgcmFuZ2VzIGZvciBkaWZmZXJlbnQgaW50ZXJydXB0DQo+
ID4gdHlwZXMgdG8gdXNpbmcgc29tZSBvZiB0aGUgdXBwZXIgYml0cyBvZiB0aGUgaW50ZXJydXB0
IElEIHRvIGRlbm90ZQ0KPiA+IHRoZSBpbnRlcnJ1cHQgdHlwZS4gVGhpcyBpcyBub3QgY29tcGF0
aWJsZSB3aXRoIG9sZGVyIEdJQ3MgKHdoaWNoDQo+ID4gcmVseQ0KPiA+IG9uIHJhbmdlcyBvZiBp
bnRlcnJ1cHRzIHRvIGRldGVybWluZSB0aGUgdHlwZSksIGFuZCBoZW5jZSBhIHNldCBvZg0KPiA+
IGhlbHBlcnMgaXMgaW50cm9kdWNlZC4gVGhlc2UgaGVscGVycyB0YWtlIGEgc3RydWN0IGt2bSos
IGFuZCB1c2UNCj4gPiB0aGUNCj4gPiB2Z2ljIG1vZGVsIHRvIGRldGVybWluZSBob3cgdG8gaW50
ZXJwcmV0IHRoZSBpbnRlcnJ1cHQgSUQuDQo+ID4gDQo+ID4gSGVscGVycyBhcmUgaW50cm9kdWNl
ZCBmb3IgUFBJcywgU1BJcywgYW5kIExQSXMuIEFkZGl0aW9uYWxseSwgYQ0KPiA+IGhlbHBlciBp
cyBpbnRyb2R1Y2VkIHRvIGRldGVybWluZSBpZiBhbiBpbnRlcnJ1cHQgaXMgcHJpdmF0ZSAtIFNH
SXMNCj4gPiBhbmQgUFBJcyBmb3Igb2xkZXIgR0lDcywgYW5kIFBQSXMgb25seSBmb3IgR0lDdjUu
DQo+ID4gDQo+ID4gVGhlIGhlbHBlcnMgYXJlIHBsdW1iZWQgaW50byB0aGUgY29yZSB2Z2ljIGNv
ZGUsIGFzIHdlbGwgYXMgdGhlDQo+ID4gQXJjaA0KPiA+IFRpbWVyIGFuZCBQTVUgY29kZS4NCj4g
PiANCj4gPiBUaGVyZSBzaG91bGQgYmUgbm8gZnVuY3Rpb25hbCBjaGFuZ2VzIGFzIHBhcnQgb2Yg
dGhpcyBjaGFuZ2UuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogU2FzY2hhIEJpc2Nob2ZmIDxz
YXNjaGEuYmlzY2hvZmZAYXJtLmNvbT4NCj4gSGkgU2FzY2hhLA0KPiANCj4gQSBiaXQgb2YgYmlr
ZXNoZWRkaW5nIC8gJ3ZhbHVhYmxlJyBuYW1pbmcgZmVlZGJhY2sgdG8gZW5kIHRoZSBkYXkuDQo+
IE90aGVyd2lzZSBMR1RNLg0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9rdm0vYXJtX3Zn
aWMuaCBiL2luY2x1ZGUva3ZtL2FybV92Z2ljLmgNCj4gPiBpbmRleCBiMjYxZmIzOTY4ZDAzLi42
Nzc4ZjY3NmVhZjA4IDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUva3ZtL2FybV92Z2ljLmgNCj4g
PiArKysgYi9pbmNsdWRlL2t2bS9hcm1fdmdpYy5oDQo+IC4uLg0KPiANCj4gPiDCoGVudW0gdmdp
Y190eXBlIHsNCj4gPiDCoAlWR0lDX1YyLAkJLyogR29vZCBvbCcgR0lDdjIgKi8NCj4gPiBAQCAt
NDE4LDggKzQ4OCwxMiBAQCB1NjQgdmdpY192M19nZXRfbWlzcihzdHJ1Y3Qga3ZtX3ZjcHUgKnZj
cHUpOw0KPiA+IMKgDQo+ID4gwqAjZGVmaW5lIGlycWNoaXBfaW5fa2VybmVsKGspCSghISgoaykt
PmFyY2gudmdpYy5pbl9rZXJuZWwpKQ0KPiA+IMKgI2RlZmluZSB2Z2ljX2luaXRpYWxpemVkKGsp
CSgoayktPmFyY2gudmdpYy5pbml0aWFsaXplZCkNCj4gPiAtI2RlZmluZSB2Z2ljX3ZhbGlkX3Nw
aShrLCBpKQkoKChpKSA+PSBWR0lDX05SX1BSSVZBVEVfSVJRUykgJiYNCj4gPiBcDQo+ID4gKyNk
ZWZpbmUgdmdpY192YWxpZF9udjVfc3BpKGssIGkpCSgoKGkpID49DQo+ID4gVkdJQ19OUl9QUklW
QVRFX0lSUVMpICYmIFwNCj4gPiDCoAkJCSgoaSkgPCAoayktPmFyY2gudmdpYy5ucl9zcGlzICsN
Cj4gPiBWR0lDX05SX1BSSVZBVEVfSVJRUykpDQo+ID4gKyNkZWZpbmUgdmdpY192YWxpZF92NV9z
cGkoaywgaSkJKGlycV9pc19zcGkoaywgaSkgJiYgXA0KPiA+ICsJCQkJIChGSUVMRF9HRVQoR0lD
VjVfSFdJUlFfSUQsIGkpIDwNCj4gPiAoayktPmFyY2gudmdpYy5ucl9zcGlzKSkNCj4gPiArI2Rl
ZmluZSB2Z2ljX3ZhbGlkX3NwaShrLCBpKSAodmdpY19pc192NShrKQ0KPiA+ID8JCQkJXA0KPiA+
ICsJCQnCoMKgwqDCoMKgIHZnaWNfdmFsaWRfdjVfc3BpKGssIGkpIDoNCj4gPiB2Z2ljX3ZhbGlk
X252NV9zcGkoaywgaSkpDQo+IA0KPiBudiBpcyBhIGxpdHRsZSBhd2t3YXJkIGFzIGEgbmFtZSBh
cyBpbW1lZGlhdGVseSBtYWtlcyBtZSB0aGlua2luZw0KPiBuZXN0ZWQgdmlydHVhbGl6YXRpb24g
aW5zdGVhZCBvZiBub3QgdjUgKHdoaWNoIEkgZ3Vlc3MgaXMgdGhlDQo+IHRoaW5raW5nIGJlaGlu
ZCB0aGF0PykNCj4gDQo+IFByb2JhYmx5IGp1c3QgbWUgYW5kIG5hbWluZyBpdCB2MjMgd2lsbCBi
cmVhayBpZiB3ZSBnZXQgdG8gR0lDDQo+IHZlcnNpb24gMjMgOikNCj4gbnY1IGJyZWFrcyB3aGVu
IHdlIGdldCBHSUN2NiA7KQ0KDQpBYnNvbHV0ZWx5IGFncmVlZCBoZXJlLiBUaGUgdjUgYW5kIG52
NSBtYWNyb3Mgd2VyZSBub3QgdXNlZCBhbnl3aGVyZSwNCnNvIEkndmUgcmUtd29ya2VkIHRoaXMg
YSBiaXQgdG8gYmUgbW9yZSBpbiB0aGUgc3R5bGUgb2YgdGhvc2UgYWRkZWQNCmVhcmxpZXI6DQoN
Ci0jZGVmaW5lIHZnaWNfdmFsaWRfbnY1X3NwaShrLCBpKSAgICAgICAoKChpKSA+PSBWR0lDX05S
X1BSSVZBVEVfSVJRUykgJiYgXA0KLSAgICAgICAgICAgICAgICAgICAgICAgKChpKSA8IChrKS0+
YXJjaC52Z2ljLm5yX3NwaXMgKyBWR0lDX05SX1BSSVZBVEVfSVJRUykpDQotI2RlZmluZSB2Z2lj
X3ZhbGlkX3Y1X3NwaShrLCBpKSAgICAgICAgKGlycV9pc19zcGkoaywgaSkgJiYgXA0KLSAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgKEZJRUxEX0dFVChHSUNWNV9IV0lSUV9JRCwgaSkg
PCAoayktPmFyY2gudmdpYy5ucl9zcGlzKSkNCi0jZGVmaW5lIHZnaWNfdmFsaWRfc3BpKGssIGkp
ICh2Z2ljX2lzX3Y1KGspID8gICAgICAgICAgICAgICAgICAgICAgICAgIFwNCi0gICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHZnaWNfdmFsaWRfdjVfc3BpKGssIGkpIDogdmdpY192YWxpZF9u
djVfc3BpKGssIGkpKQ0KKyNkZWZpbmUgdmdpY192YWxpZF9zcGkoaywgaSkgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KKyAgICAgICAoeyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KKyAgICAg
ICAgICAgICAgIGJvb2wgX19yZXQgPSBpcnFfaXNfc3BpKGssIGkpOyAgICAgICAgICAgICAgICAg
ICAgICAgICAgXA0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KKyAgICAgICAgICAgICAgIHN3aXRjaCAoKGsp
LT5hcmNoLnZnaWMudmdpY19tb2RlbCkgeyAgICAgICAgICAgICAgICAgICAgXA0KKyAgICAgICAg
ICAgICAgIGNhc2UgS1ZNX0RFVl9UWVBFX0FSTV9WR0lDX1Y1OiAgICAgICAgICAgICAgICAgICAg
ICAgICAgXA0KKyAgICAgICAgICAgICAgICAgICAgICAgX19yZXQgJj0gRklFTERfR0VUKEdJQ1Y1
X0hXSVJRX0lELCBpKSA8IChrKS0+YXJjaC52Z2ljLm5yX3NwaXM7IFwNCisgICAgICAgICAgICAg
ICAgICAgICAgIGJyZWFrOyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IFwNCisgICAgICAgICAgICAgICBkZWZhdWx0OiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIFwNCisgICAgICAgICAgICAgICAgICAgICAgIF9fcmV0ICY9IChp
KSA8ICgoayktPmFyY2gudmdpYy5ucl9zcGlzICsgVkdJQ19OUl9QUklWQVRFX0lSUVMpOyBcDQor
ICAgICAgICAgICAgICAgfSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBcDQorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQorICAgICAgICAgICAgICAgX19yZXQ7
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQorICAg
ICAgIH0pDQoNCk1vcmUgdmVyYm9zZSAod2l0aCBhbm5veWluZyBsaW5lIGxlbmd0aHMpLCBidXQg
Y2VydGFpbmx5IG1vcmUgc2NhbGFibGUNCmFuZCByZW1vdmVzIHRoZSBuYW1pbmcgaXNzdWUgYWx0
b2dldGhlci4gUGVyc29uYWxseSwgSSBwcmVmZXIgaXQNCmJlY2F1c2UgaXQgaXMgbW9yZSBhbGln
bmVkIHdpdGggdGhlIHJlbGF0ZWQgbWFjcm9zIGFib3ZlLg0KDQpJcyB0aGlzIHByZWZlcmFibGUv
YWNjZXB0YWJsZT8NCg0KVGhhbmtzLA0KU2FzY2hhDQoNCj4gDQo+IA0KPiA+IMKgDQo+ID4gwqBi
b29sIGt2bV92Y3B1X2hhc19wZW5kaW5nX2lycXMoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsNCj4g
PiDCoHZvaWQga3ZtX3ZnaWNfc3luY19od3N0YXRlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQo+
IA0KDQo=

