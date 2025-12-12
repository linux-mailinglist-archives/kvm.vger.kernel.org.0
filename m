Return-Path: <kvm+bounces-65876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F0E46CB9243
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:31:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DB91E3135C90
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C4D431A54F;
	Fri, 12 Dec 2025 15:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NyNq+mN1";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NyNq+mN1"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013052.outbound.protection.outlook.com [52.101.72.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7023B31B118
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.52
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553074; cv=fail; b=l5jaOLx/VZyM6nH0hPvkg4J4qLZrzl3IcTTfV7OmsZw6qd9shz1izgW4pDskSnCW1Mw9sA4/7ozwtrrFodz7h8x7sfYQNYsh2ZDuS2+7Bc+bLECm/Z9EK210qIeEk+IC2vudwP/jkiVCYGt9dciEQdaGNY368nec1WtocmM08xc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553074; c=relaxed/simple;
	bh=8RLzt4QBBMCufQmLjTgakMTEnc1FfOJVyrLUtdQ5PTU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J5Q//TOGDj0KfDEc1m363tF1ngfxGLou2C4XsF0YJrvFjsJwTqUO2kmnLsbQ33bs61NCmsR7wqXkd+/oeCLvXByf55kUgvQwS5WANKTFuzMFkeAyaLKmnSzmtrgDdqTFO+r/t4lEZvNHqC0FUtT6e6lkmaI1iePQO5+1Y5YPI/k=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NyNq+mN1; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NyNq+mN1; arc=fail smtp.client-ip=52.101.72.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=av7oMHsqMNzWyXOYmg7060Gw7fBA13bNcydHTX1CVY4QZOTePSoFBlx3wB1dFTbB5Ctdtz+8go1fBG8nLf52DAz+/3oeQNz5ZgGg9ekGPNP6e2uoD7FETwsCfKUfWMjy+HKBc0RUM4l9ZPAXbHyvx5rcjrpQ0JsuH9W0U30sUTrgk3fexFiLO0P/1GbN8BMhF1T2yceBZvMAoBKIU3dts/P04OK0/f98sEnBlmjeljdjZnaLMw30nfkqj8EIBvX+oDL8er9yBcrjaJAPWJTgKxT7MH+gy87hW7vY68ElelqD4ZTOsLFyToST0ejltewyGcLrjcQO7craW6sDF6h2Xw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O1PalpqgIf9s9P6MODg+cmOS281d5hdgDkUr80tsX3A=;
 b=tRa0tbhYEFOL6ZCp7fR2yxPAOboecoQiWCaP/na/Dw/D8OQWlIHoS34aC7PHZzXHtxto9epBQQm4LhqA/aEtYAZwBytX88tHWCSEq0okP2Snnbg0OTpfBW8SCR1VXWEHpFkRpAQShRW4S44GaxiDP/iKjec/90W/iHxaTnwxEDIjdpZbt6TWvjDscE2ShZ/8oFMSBwH8oE8ZlwV2S2L/Ev/p8C3bs6fVoBACeI6veXhj4DRY2CPfWgPt77LlCmQfraKdO0m1BbwX9Q003u1Ui134Jaz6r133/Py/VS1+v5KdKRVOiGDkmtBPcWJQfFa4Up+Gn+IV6FrGrnHq65DDWg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O1PalpqgIf9s9P6MODg+cmOS281d5hdgDkUr80tsX3A=;
 b=NyNq+mN1VGi2EvYn8eQuKlo+8OC3GAIbzhLJ9C/nPCVft3SMD6Z6jqr1ts20bbW82MCqe1B3NRry73Z/kEdu43t+aGvfxPk0OUiDN0S5QFRgn1E8t6PSvKB3U9AgveiO2aBT1KzqPcCB0mQqXzTuXmr90dz5teQkwFXKnG/DUME=
Received: from AS4P251CA0027.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:5d3::13)
 by AM8PR08MB6419.eurprd08.prod.outlook.com (2603:10a6:20b:316::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 15:24:26 +0000
Received: from AMS1EPF0000004A.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d3:cafe::63) by AS4P251CA0027.outlook.office365.com
 (2603:10a6:20b:5d3::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.10 via Frontend Transport; Fri,
 12 Dec 2025 15:24:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000004A.mail.protection.outlook.com (10.167.16.134) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 12 Dec 2025 15:24:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=buLp/D8LTsafTnTw1nNcrQUO8ZRMr5XXgIF0xOmKuoD+neRiA0UjdyvogiaOYld+gaRmXfbZkdnf4AyZKNBtB2PMR0zexJPpdQzNBj8dmQqmCCZ0+epnoJ5qFZyWLDThDhrcbCvob1HUXiwi18ADuFkZANnPSv8Q+Fkgc9nsY2ZGasRRfp4oQLas6lesAOYYntuWx4rLNSIo5RJ57EbBmO85Qvjjns4F86i7G/MSJWGRhemkPArjbseXiohMljnl0H++aumzXHM8xA0PY85j5lapbB1feZ0MAgf0OjSqh8CpAE+DR6QqgWdQrrtokY8094+wMvqpX5GoUre+4Vwzag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O1PalpqgIf9s9P6MODg+cmOS281d5hdgDkUr80tsX3A=;
 b=yVax/ifXNT7g/1HxdGmayQMOzOcDBhcnpHbEjS3MHOLpmX6bnLJ0zdAgXS2xjvn9B5jYxpyOvnNP6upBtn9oS0O/N8YgA12vNapKUASRg8ftg1eUgJjdc2uOBp0j5IlvJ0nX2Wd8xJSEVj9HQvV9lpVBpS0bLF9o5YzcHEdFm5qbM9j/LS711pz88ccjJUCj205qdLdxA0HxPzyo3QGDE9sndnowsoP0l/TZlF2SfzIqIiw+VjiBffhZIRDKifqrjhATaIEeAVVqfaBKvP9JwrJZgKyEBExtWE7VRbU9yoxeKOoGpbfUvMFs9BNtzHaTo5p6+YOXwcU7islsOnA8uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O1PalpqgIf9s9P6MODg+cmOS281d5hdgDkUr80tsX3A=;
 b=NyNq+mN1VGi2EvYn8eQuKlo+8OC3GAIbzhLJ9C/nPCVft3SMD6Z6jqr1ts20bbW82MCqe1B3NRry73Z/kEdu43t+aGvfxPk0OUiDN0S5QFRgn1E8t6PSvKB3U9AgveiO2aBT1KzqPcCB0mQqXzTuXmr90dz5teQkwFXKnG/DUME=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AS8PR08MB9386.eurprd08.prod.outlook.com (2603:10a6:20b:5a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Fri, 12 Dec
 2025 15:23:22 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:23:22 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH 32/32] KVM: arm64: selftests: Introduce a minimal GICv5 PPI
 selftest
Thread-Topic: [PATCH 32/32] KVM: arm64: selftests: Introduce a minimal GICv5
 PPI selftest
Thread-Index: AQHca3srXPsD2M3AwkSjl1/X4AzAPQ==
Date: Fri, 12 Dec 2025 15:22:46 +0000
Message-ID: <20251212152215.675767-33-sascha.bischoff@arm.com>
References: <20251212152215.675767-1-sascha.bischoff@arm.com>
In-Reply-To: <20251212152215.675767-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|AS8PR08MB9386:EE_|AMS1EPF0000004A:EE_|AM8PR08MB6419:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ac49f33-8313-4a04-de94-08de399288e5
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?eAWst40CI0uL2SzVRVsWvB2EFcPMrSfjl8jFVFTeGhJvEpWWzcF2/2CYeU?=
 =?iso-8859-1?Q?5thzVEIaPM6FHLcOQkxtpGVINucFxGI88gmzNZN5DipBFmKUZPGZrwsgT9?=
 =?iso-8859-1?Q?ATXCca5v6AIyY1KPxgT0zok+RSfKQaZLAyWi+3vcj++YzlL+eU2zJclEEq?=
 =?iso-8859-1?Q?V0HwJe4tuDDCKt6+K8FIV6jouNUKVktJRwiDguVNb9fLXzQ6WIpBOo8WT0?=
 =?iso-8859-1?Q?GFxcySpwaX5isFvs3mBpYoyOhKHTRI2dXmvtmiz6xUPLm96nK4kaNq6PvE?=
 =?iso-8859-1?Q?46zdk3MHRAMpWD/Axr9OuwUVPDcgu/UuAI1Fp5d6JqfYyz878X5hTX5gZn?=
 =?iso-8859-1?Q?KPMH7YR3vprHGN1iCJsOe5M0NFyif6LLqkBp7aVEpIj3+SBIL/v2l9W32F?=
 =?iso-8859-1?Q?f4+epuXX5xjTZ0ndOH9naLsQYfsX6+bzrh2ouKr5/5z2Atn6MVR5S9ieCe?=
 =?iso-8859-1?Q?cp1wz+jnP9v/QLs2Bw/PANjZjaDQjx5qPlQfczV69n9JwKARnGceOPkm3W?=
 =?iso-8859-1?Q?rJbzIjtLPTrrCIkF68PTXzqgEDbtoX8xGZ+k2DRLGjqal/Cr9sj9vafSD1?=
 =?iso-8859-1?Q?l1RvryzjoH1pM8pecdyDTqiaF8SeID4iC0C7WY6ap7xYMgd1XO5HbNNxlp?=
 =?iso-8859-1?Q?oByukuF2XoOo7bi0hQeQtDkAE1+NYgWvu1JDl22XmQNjvY3RBuclkqWz2j?=
 =?iso-8859-1?Q?98nwcwGAn70PY3JHW7Y4fuTyE0SJpJBDw2g551cAA/GWCadXVezhvgg+nS?=
 =?iso-8859-1?Q?qlAL1Ko57ai8XCcRC5PhCLOeUQlfoVCCi3GPm4L3zjQtqfvMPbwxzt7Hr2?=
 =?iso-8859-1?Q?Nyl2MzN02rde/Rr17b3+gbXbP39z8iWG8xKJm0DOv29ztYFxJO2PaWnt1A?=
 =?iso-8859-1?Q?ovum/cLjXVjXTgmFcQRME0oRdT1bMBAqLqm4NyNHiS/Itl+bVEhGIS1nXH?=
 =?iso-8859-1?Q?B/u9wHliJqd9uOVymaalFiWb7aOXrPdHOAyZXrlp3qO6dE43Vp42CT4me0?=
 =?iso-8859-1?Q?sKS/ldYhABc0au1yLLDj58wrJaWzACdc2kNwoQ++p7uYkGZZuqFfvGDYEw?=
 =?iso-8859-1?Q?4d9jv7GuSEDrPOj2/n66yffOhIMzaoc8tV9xyRA+rTqt2Oe5QX3igw75j4?=
 =?iso-8859-1?Q?ZwQKOvuj0w0Wbiy6MtJxthb1E772M0lggZRWVsdgWWR6i0LwxQ+Nqw41Lf?=
 =?iso-8859-1?Q?Klyf90zhFnQEIrSDnsURRqsKuZu9wKwziaAuPwqyZk/G0zyoVC7xXCRRkR?=
 =?iso-8859-1?Q?9ZGLlxIVTGxEBNX94gvsoKuZuXry9Z+8PamJwdJuVx39HwbsyqPPqEOhC2?=
 =?iso-8859-1?Q?3dCjfrXvJE4Bg/XOjcmS5aUuGkMJuyNv/k/tz7wr9uKnu8jR3Z6R4mGYD8?=
 =?iso-8859-1?Q?eQ00h8hm4EMukr1b7h4YaGFCYvS6mhcwd/VQkZ5kfHPWQNdiMekLKwVnyf?=
 =?iso-8859-1?Q?nVJl0csECcEOJTlhIm35jg7s2xstrWkpTLRbDdKotys13b34dbw/jB5iQz?=
 =?iso-8859-1?Q?jrNZZKGnRUesF4nUQkDytaGmWaaKEvQsR2EcjnEUt2oPs5KYNYpNJ4nC3j?=
 =?iso-8859-1?Q?DE69hWa8/7RKFF8aIZbhArcildOi?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9386
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000004A.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	de5f8512-d366-4489-9407-08de3992632b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|14060799003|35042699022|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?l+9sPN/+F4vnpU99V63ki6ndAl4iHg2yj3ChcjMhk1J5Eu/jPnS0AyDXzi?=
 =?iso-8859-1?Q?1RVvvm9AO0Uyg5ptzmCz1/qdylTga1DtUyFRbkgcEfRzR+BrwhKKXMhNKM?=
 =?iso-8859-1?Q?+7kfvWuvxVDKZYyqK6fQ6jNp+/YN3D3U43aP/I9/0XI8fvxwwFXysfO100?=
 =?iso-8859-1?Q?6PXYEOWusVv9/gLMC5s4eWg4d+D3OIb+CxXSrB64LSj089fDHU/pr+aPIx?=
 =?iso-8859-1?Q?Lig1LM1oB0tU4aphdjTJXwteyDXoJ/KyroFc1PUD98cs24y2bHlzJF0YKr?=
 =?iso-8859-1?Q?kG5l+RBSIwTefU3FLra19JZry7IfskaUa2IpXeqgtDIj0ba9CJT1mdHBVc?=
 =?iso-8859-1?Q?xUKnJ4+hJQcqJ5f0xDWPpNaAlUBfbeawyrnoBhNAN6StlFHy1AjHzWEIAj?=
 =?iso-8859-1?Q?FKfObl7hSfMhQrxpAtb/LQ9D7UqEA9pPXtd2hg1vTQxsxq8ZyZdbdmIpaa?=
 =?iso-8859-1?Q?OsYGgATxXlfF9eF4T4Ouww1/sQL43LM1CJxFN/EomE05Phsf2BonQ8GRSZ?=
 =?iso-8859-1?Q?Z1g4oNgEbES2ePmS2IIfF2QmS85hDuJTELlJUR/O8hQAdPaQqO5RWzM7Tm?=
 =?iso-8859-1?Q?CYvaD8Vou5fT3FE2pqcaxSQZyoL3Zpd80x2FMWv49ZN3nVYXv2bkgPedSw?=
 =?iso-8859-1?Q?AwuGyZeQQR6SzKC2ffVZq0x3SKTpi+qfDwfHaI0vXY0HrYZ4UWB7uEP3rd?=
 =?iso-8859-1?Q?dIleG/4sMKOk90YLP/7M4Rh99u4jFRtU1a8PR8gAbx+1Cm+HPTdnZ4C5Zc?=
 =?iso-8859-1?Q?k7SB1sVDK1N7/C1YV4sJh9K+3vnQYhCkbmQrJDW00TBcdzzEDTK6CXmghh?=
 =?iso-8859-1?Q?au7Q7OGxr1/jp06GOaq1uWyxzcisar2ElnkyQcR913S00OeyLCsevIchFf?=
 =?iso-8859-1?Q?AMbuVIMEh24p9ywqrq/32DgiHOW39Eh14Qgw+osFcRXB8RyQsvKPQl2OSG?=
 =?iso-8859-1?Q?0tj+pqx5lxkuePAuNGLLH7YNISivj65Jh3rXfzzDqEttgv9JEnMSgOy3HK?=
 =?iso-8859-1?Q?Dco4wjrBkz4xrkmqhi34yJf2BPaBZ+Igzi8bC4w3YAGTKKFTDKQImy81pP?=
 =?iso-8859-1?Q?KGjYDtHoq9Z0asEPhD4/kcXBuO8rEe2pehICigWLkKnPdGbK+JlfygRcF6?=
 =?iso-8859-1?Q?XKjqrTI7/jGo3RZkQyiWLlk1xSmu3DMU5Hjv50vfjgAWvyFTL1veHL3wPy?=
 =?iso-8859-1?Q?JMC7m9e0O8Up0lugkt1M7Y16Cvv3o27gN7e/th1uNtr9kCX/RfrcNsaZDL?=
 =?iso-8859-1?Q?/PwVCdPxpfsF46LVZOiMqRkz7EuEhaCKs2oZr/vLctdVgiw9/qlJqk8XnU?=
 =?iso-8859-1?Q?4ncxYRt6TqL/xFZIRJuiA3u0mqNWUJJ0wjtnjM5I1CA5EaA9ycziwF7iU6?=
 =?iso-8859-1?Q?76rvauSM4mQuMpMIZC3FsaqPS/SRI4foNnWCvmGZiaGK3clCLzwVZs82CO?=
 =?iso-8859-1?Q?yNdQ3lynuXdmx2qtwyJbkodPW6NYrXxrFPMx4UY1vwq7PDePqfZY9/UctJ?=
 =?iso-8859-1?Q?XVERJWGZvzYODEcNJIRHabYhIfK3Ka2Z/SttCJfJMF7bt5mfAjQGx38y9m?=
 =?iso-8859-1?Q?FtEBL2lXF6S5MbYpLdg6JJj3llJhyVf8I78CFEHpD/LVatqF+osUHYa5Fc?=
 =?iso-8859-1?Q?wbk7J3h7nxX8w=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(14060799003)(35042699022)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:24:25.6928
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ac49f33-8313-4a04-de94-08de399288e5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000004A.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6419

This basic selftest creates a vgic_v5 device (if supported), and tests
that one of the PPI interrupts works as expected with a basic
single-vCPU guest.

Upon starting, the guest enables interrupts. That means that it is
initialising all PPIs to have reasonable priorities, but marking them
as disabled. Then the priority mask in the ICC_PCR_EL1 is set, and
interrupts are enable in ICC_CR0_EL1. At this stage the guest is able
to recieve interrupts. The first IMPDEF PPI (64) is enabled and
kvm_irq_line is used to inject the state into the guest.

The guest's interrupt handler has an explicit WFI in order to ensure
that the guest skips WFI when there are pending and enabled PPI
interrupts.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 248 ++++++++++++++++++
 .../selftests/kvm/include/arm64/gic_v5.h      | 148 +++++++++++
 3 files changed, 397 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/vgic_v5.c
 create mode 100644 tools/testing/selftests/kvm/include/arm64/gic_v5.h

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selft=
ests/kvm/Makefile.kvm
index ba5c2b643efaa..5c325b8a0766d 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -173,6 +173,7 @@ TEST_GEN_PROGS_arm64 +=3D arm64/vcpu_width_config
 TEST_GEN_PROGS_arm64 +=3D arm64/vgic_init
 TEST_GEN_PROGS_arm64 +=3D arm64/vgic_irq
 TEST_GEN_PROGS_arm64 +=3D arm64/vgic_lpi_stress
+TEST_GEN_PROGS_arm64 +=3D arm64/vgic_v5
 TEST_GEN_PROGS_arm64 +=3D arm64/vpmu_counter_access
 TEST_GEN_PROGS_arm64 +=3D arm64/no-vgic-v3
 TEST_GEN_PROGS_arm64 +=3D arm64/kvm-uuid
diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
new file mode 100644
index 0000000000000..5879fbd71042d
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -0,0 +1,248 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/kernel.h>
+#include <sys/syscall.h>
+#include <asm/kvm.h>
+#include <asm/kvm_para.h>
+
+#include <arm64/gic_v5.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "vgic.h"
+
+#define NR_VCPUS		1
+
+struct vm_gic {
+	struct kvm_vm *vm;
+	int gic_fd;
+	uint32_t gic_dev_type;
+};
+
+static uint64_t max_phys_size;
+
+#define GUEST_CMD_IRQ_CDIA	10
+#define GUEST_CMD_IRQ_DIEOI	11
+#define GUEST_CMD_IS_AWAKE	12
+#define GUEST_CMD_IS_READY	13
+
+static void guest_irq_handler(struct ex_regs *regs)
+{
+	bool valid;
+	u32 hwirq;
+	u64 ia;
+	static int count;
+
+	/*
+	 * We have pending interrupts. Should never actually enter WFI
+	 * here!
+	 */
+	wfi();
+	GUEST_SYNC(GUEST_CMD_IS_AWAKE);
+
+	ia =3D gicr_insn(CDIA);
+	valid =3D GICV5_GICR_CDIA_VALID(ia);
+
+	GUEST_SYNC(GUEST_CMD_IRQ_CDIA);
+
+	if (!valid)
+		return;
+
+	gsb_ack();
+	isb();
+
+	hwirq =3D FIELD_GET(GICV5_GIC_CDIA_INTID, ia);
+
+	gic_insn(hwirq, CDDI);
+	gic_insn(0, CDEOI);
+
+	++count;
+	GUEST_SYNC(GUEST_CMD_IRQ_DIEOI);
+
+	if (count >=3D 2)
+		GUEST_DONE();
+
+	/* Ask for the next interrupt to be injected */
+	GUEST_SYNC(GUEST_CMD_IS_READY);
+}
+
+static void guest_code(void)
+{
+	local_irq_disable();
+
+	gicv5_cpu_enable_interrupts();
+	local_irq_enable();
+
+	/* Enable PPI 64 */
+	write_sysreg_s(1UL, SYS_ICC_PPI_ENABLER1_EL1);
+
+	/* Ask for the first interrupt to be injected */
+	GUEST_SYNC(GUEST_CMD_IS_READY);
+
+	/* Loop forever waiting for interrupts */
+	while (1);
+}
+
+
+/* we don't want to assert on run execution, hence that helper */
+static int run_vcpu(struct kvm_vcpu *vcpu)
+{
+	return __vcpu_run(vcpu) ? -errno : 0;
+}
+
+static void vm_gic_destroy(struct vm_gic *v)
+{
+	close(v->gic_fd);
+	kvm_vm_free(v->vm);
+}
+
+static void test_vgic_v5_ppis(uint32_t gic_dev_type)
+{
+	struct ucall uc;
+	struct kvm_vcpu *vcpus[NR_VCPUS];
+	struct vm_gic v;
+	int ret, i;
+
+	v.gic_dev_type =3D gic_dev_type;
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+
+	v.gic_fd =3D kvm_create_device(v.vm, gic_dev_type);
+
+	for (i =3D 0; i < NR_VCPUS; ++i)
+		vcpus[i] =3D vm_vcpu_add(v.vm, i, guest_code);
+
+	vm_init_descriptor_tables(v.vm);
+	vm_install_exception_handler(v.vm, VECTOR_IRQ_CURRENT, guest_irq_handler)=
;
+
+	for (i =3D 0; i < NR_VCPUS; i++)
+		vcpu_init_descriptor_tables(vcpus[i]);
+
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	while (1) {
+		ret =3D run_vcpu(vcpus[0]);
+
+		switch (get_ucall(vcpus[0], &uc)) {
+		case UCALL_SYNC:
+			/*
+			 * The guest is ready for the next level
+			 * change. Set high if ready, and lower if it
+			 * has been consumed.
+			 */
+			if (uc.args[1] =3D=3D GUEST_CMD_IS_READY ||
+			    uc.args[1] =3D=3D GUEST_CMD_IRQ_DIEOI) {
+				u64 irq =3D 64;
+				bool level =3D uc.args[1] =3D=3D GUEST_CMD_IRQ_DIEOI ? 0 : 1;
+
+				irq &=3D KVM_ARM_IRQ_NUM_MASK;
+				irq |=3D KVM_ARM_IRQ_TYPE_PPI << KVM_ARM_IRQ_TYPE_SHIFT;
+
+				_kvm_irq_line(v.vm, irq, level);
+			} else if (uc.args[1] =3D=3D GUEST_CMD_IS_AWAKE) {
+				pr_info("Guest skipping WFI due to pending IRQ\n");
+			} else if (uc.args[1] =3D=3D GUEST_CMD_IRQ_CDIA) {
+				pr_info("Guest acknowledged IRQ\n");
+			}
+
+			continue;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+
+done:
+	TEST_ASSERT(ret =3D=3D 0, "Failed to test GICv5 PPIs");
+
+	vm_gic_destroy(&v);
+}
+
+/*
+ * Returns 0 if it's possible to create GIC device of a given type (V2 or =
V3).
+ */
+int test_kvm_device(uint32_t gic_dev_type)
+{
+	struct kvm_vcpu *vcpus[NR_VCPUS];
+	struct vm_gic v;
+	uint32_t other;
+	int ret;
+
+	v.vm =3D vm_create_with_vcpus(NR_VCPUS, guest_code, vcpus);
+
+	/* try to create a non existing KVM device */
+	ret =3D __kvm_test_create_device(v.vm, 0);
+	TEST_ASSERT(ret && errno =3D=3D ENODEV, "unsupported device");
+
+	/* trial mode */
+	ret =3D __kvm_test_create_device(v.vm, gic_dev_type);
+	if (ret)
+		return ret;
+	v.gic_fd =3D kvm_create_device(v.vm, gic_dev_type);
+
+	ret =3D __kvm_create_device(v.vm, gic_dev_type);
+	TEST_ASSERT(ret < 0 && errno =3D=3D EEXIST, "create GIC device twice");
+
+	/* try to create the other gic_dev_types */
+	other =3D KVM_DEV_TYPE_ARM_VGIC_V2;
+	if (!__kvm_test_create_device(v.vm, other)) {
+		ret =3D __kvm_create_device(v.vm, other);
+		TEST_ASSERT(ret < 0 && (errno =3D=3D EINVAL || errno =3D=3D EEXIST),
+				"create GIC device while other version exists");
+	}
+
+	other =3D KVM_DEV_TYPE_ARM_VGIC_V3;
+	if (!__kvm_test_create_device(v.vm, other)) {
+		ret =3D __kvm_create_device(v.vm, other);
+		TEST_ASSERT(ret < 0 && (errno =3D=3D EINVAL || errno =3D=3D EEXIST),
+				"create GIC device while other version exists");
+	}
+
+	other =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	if (!__kvm_test_create_device(v.vm, other)) {
+		ret =3D __kvm_create_device(v.vm, other);
+		TEST_ASSERT(ret < 0 && (errno =3D=3D EINVAL || errno =3D=3D EEXIST),
+				"create GIC device while other version exists");
+	}
+
+	vm_gic_destroy(&v);
+
+	return 0;
+}
+
+void run_tests(uint32_t gic_dev_type)
+{
+	pr_info("Test VGICv5 PPIs\n");
+	test_vgic_v5_ppis(gic_dev_type);
+}
+
+int main(int ac, char **av)
+{
+	int ret;
+	int pa_bits;
+	int cnt_impl =3D 0;
+
+	test_disable_default_vgic();
+
+	pa_bits =3D vm_guest_mode_params[VM_MODE_DEFAULT].pa_bits;
+	max_phys_size =3D 1ULL << pa_bits;
+
+	ret =3D test_kvm_device(KVM_DEV_TYPE_ARM_VGIC_V5);
+	if (!ret) {
+		pr_info("Running VGIC_V5 tests.\n");
+		run_tests(KVM_DEV_TYPE_ARM_VGIC_V5);
+		cnt_impl++;
+	} else {
+		pr_info("No GICv5 support; Not running GIC_v5 tests.\n");
+		exit(KSFT_SKIP);
+	}
+
+	return 0;
+}
+
+
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/tes=
ting/selftests/kvm/include/arm64/gic_v5.h
new file mode 100644
index 0000000000000..5daaa84318bb1
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
@@ -0,0 +1,148 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __SELFTESTS_GIC_V5_H
+#define __SELFTESTS_GIC_V5_H
+
+#include <asm/barrier.h>
+#include <asm/sysreg.h>
+
+#include <linux/bitfield.h>
+
+#include "processor.h"
+
+/*
+ * Definitions for GICv5 instructions for the Current Domain
+ */
+#define GICV5_OP_GIC_CDAFF		sys_insn(1, 0, 12, 1, 3)
+#define GICV5_OP_GIC_CDDI		sys_insn(1, 0, 12, 2, 0)
+#define GICV5_OP_GIC_CDDIS		sys_insn(1, 0, 12, 1, 0)
+#define GICV5_OP_GIC_CDHM		sys_insn(1, 0, 12, 2, 1)
+#define GICV5_OP_GIC_CDEN		sys_insn(1, 0, 12, 1, 1)
+#define GICV5_OP_GIC_CDEOI		sys_insn(1, 0, 12, 1, 7)
+#define GICV5_OP_GIC_CDPEND		sys_insn(1, 0, 12, 1, 4)
+#define GICV5_OP_GIC_CDPRI		sys_insn(1, 0, 12, 1, 2)
+#define GICV5_OP_GIC_CDRCFG		sys_insn(1, 0, 12, 1, 5)
+#define GICV5_OP_GICR_CDIA		sys_insn(1, 0, 12, 3, 0)
+#define GICV5_OP_GICR_CDNMIA		sys_insn(1, 0, 12, 3, 1)
+
+/* Definitions for GIC CDAFF */
+#define GICV5_GIC_CDAFF_IAFFID_MASK	GENMASK_ULL(47, 32)
+#define GICV5_GIC_CDAFF_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDAFF_IRM_MASK	BIT_ULL(28)
+#define GICV5_GIC_CDAFF_ID_MASK		GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDDI */
+#define GICV5_GIC_CDDI_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDDI_ID_MASK		GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDDIS */
+#define GICV5_GIC_CDDIS_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDDIS_TYPE(r)		FIELD_GET(GICV5_GIC_CDDIS_TYPE_MASK, r)
+#define GICV5_GIC_CDDIS_ID_MASK		GENMASK_ULL(23, 0)
+#define GICV5_GIC_CDDIS_ID(r)		FIELD_GET(GICV5_GIC_CDDIS_ID_MASK, r)
+
+/* Definitions for GIC CDEN */
+#define GICV5_GIC_CDEN_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDEN_ID_MASK		GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDHM */
+#define GICV5_GIC_CDHM_HM_MASK		BIT_ULL(32)
+#define GICV5_GIC_CDHM_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDHM_ID_MASK		GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDPEND */
+#define GICV5_GIC_CDPEND_PENDING_MASK	BIT_ULL(32)
+#define GICV5_GIC_CDPEND_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDPEND_ID_MASK	GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDPRI */
+#define GICV5_GIC_CDPRI_PRIORITY_MASK	GENMASK_ULL(39, 35)
+#define GICV5_GIC_CDPRI_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDPRI_ID_MASK		GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDRCFG */
+#define GICV5_GIC_CDRCFG_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDRCFG_ID_MASK	GENMASK_ULL(23, 0)
+
+/* Definitions for GICR CDIA */
+#define GICV5_GIC_CDIA_VALID_MASK	BIT_ULL(32)
+#define GICV5_GICR_CDIA_VALID(r)	FIELD_GET(GICV5_GIC_CDIA_VALID_MASK, r)
+#define GICV5_GIC_CDIA_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDIA_ID_MASK		GENMASK_ULL(23, 0)
+#define GICV5_GIC_CDIA_INTID		GENMASK_ULL(31, 0)
+
+/* Definitions for GICR CDNMIA */
+#define GICV5_GIC_CDNMIA_VALID_MASK	BIT_ULL(32)
+#define GICV5_GICR_CDNMIA_VALID(r)	FIELD_GET(GICV5_GIC_CDNMIA_VALID_MASK, =
r)
+#define GICV5_GIC_CDNMIA_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDNMIA_ID_MASK	GENMASK_ULL(23, 0)
+
+#define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
+#define gic_insn(v, insn)		write_sysreg_s(v, GICV5_OP_GIC_##insn)
+
+#define __GIC_BARRIER_INSN(op0, op1, CRn, CRm, op2, Rt)			\
+	__emit_inst(0xd5000000					|	\
+		    sys_insn((op0), (op1), (CRn), (CRm), (op2))	|	\
+		    ((Rt) & 0x1f))
+
+#define GSB_SYS_BARRIER_INSN		__GIC_BARRIER_INSN(1, 0, 12, 0, 0, 31)
+#define GSB_ACK_BARRIER_INSN		__GIC_BARRIER_INSN(1, 0, 12, 0, 1, 31)
+
+#define gsb_ack()	asm volatile(GSB_ACK_BARRIER_INSN : : : "memory")
+#define gsb_sys()	asm volatile(GSB_SYS_BARRIER_INSN : : : "memory")
+
+#define REPEAT_BYTE(x)	((~0ul / 0xff) * (x))
+
+#define GICV5_IRQ_DEFAULT_PRI 0b10000
+
+void gicv5_ppi_priority_init(void)
+{
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR0=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR2=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR3=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR4=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR5=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR6=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR7=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR8=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR9=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
0_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
1_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
2_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
3_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
4_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
5_EL1);
+
+	/*
+	 * Context syncronization required to make sure system register writes
+	 * effects are synchronised.
+	 */
+	isb();
+}
+
+void gicv5_cpu_disable_interrupts(void)
+{
+	u64 cr0;
+
+	cr0 =3D FIELD_PREP(ICC_CR0_EL1_EN, 0);
+	write_sysreg_s(cr0, SYS_ICC_CR0_EL1);
+}
+
+void gicv5_cpu_enable_interrupts(void)
+{
+	u64 cr0, pcr;
+
+	write_sysreg_s(0, SYS_ICC_PPI_ENABLER0_EL1);
+	write_sysreg_s(0, SYS_ICC_PPI_ENABLER1_EL1);
+
+	gicv5_ppi_priority_init();
+
+	pcr =3D FIELD_PREP(ICC_PCR_EL1_PRIORITY, GICV5_IRQ_DEFAULT_PRI);
+	write_sysreg_s(pcr, SYS_ICC_PCR_EL1);
+
+	cr0 =3D FIELD_PREP(ICC_CR0_EL1_EN, 1);
+	write_sysreg_s(cr0, SYS_ICC_CR0_EL1);
+}
+
+#endif
--=20
2.34.1

