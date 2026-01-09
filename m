Return-Path: <kvm+bounces-67605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 601E1D0B8A5
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:12:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EA6413042494
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:06:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 779F5366DA9;
	Fri,  9 Jan 2026 17:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HfAxr0ro";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HfAxr0ro"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013059.outbound.protection.outlook.com [40.107.162.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E18366DAA
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.59
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978358; cv=fail; b=QJ5OZcuux49kSYVaevXL+v9545S32FL23jgxRXtoKy8k0/6GPFSJMFsXZKXlsXIHvi2Wbl2Jb66iOu/fBPG/q3QwT0nqFHiv1s6FHqMvsK8vgSwEWBpj8zNTGqHB2+NWYsvWofEjeGAmZ4d75SsiitKetYUxABsZA5psBW1GkpM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978358; c=relaxed/simple;
	bh=E8jxi2t3xvGCIO1pPpy7QP59riIseJ+2jm+6tPfJhqk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tj3/nm8UunAqDC/LninmPCkuTiLAURVq6Dvp30NwGvgEH1O/+r46RJvtmz4hS7kupvtCC+SMCUIFV5Ej5WO8xICZILDTqKMr3trrRzIn2EvU1BkbcKK4qP7sAqAx+oYVtcw+dJEF6TjcKNw0Va8M+uOjWBgbTekLkiNGcSCJH1M=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HfAxr0ro; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HfAxr0ro; arc=fail smtp.client-ip=40.107.162.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=I3UrvKk4HnCkEf5EjKJr05uEHONN2XO0YtguD8kxEAJBMkEcJOzZTyb78lRURRcqaa9sC95L1Bul+UzWJ4x4XJ2X3E3HOE+zo52KizK37euK9bxmofJPA9hnj+dBxnNB3Cng8gUDVVyAGf3TFESyPox0jI2t7XLaa4+yaNOpH1oANRPGG70Bdat7cmUledmtSNvVeXX8r66Fq9r6MBM9KV8B3TujMO5kgRo+zAExOqZBpo7clKBzsiC2vh3e731i3IL2dqySPA5asjg7ZS+Bg1pdFh+zv4r7q/Lg+V6Bq6JHqmnCYGtVMHJ1oPJ9vZm4VMOph5kpXSKcWEnEEW4x8g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UFO3AWpbiZViXyCi/AN6ly1wjtfw6TwgRdwgmhdPz4g=;
 b=XsgmDw6ZlE12+Aol4fOFooDF7KEuVBJumMhcyD7op023WciNnWxP8GNuT8vTsD1PzIcWkyF5eikrMQOoOZW8D5yPHvdHSfCe0EbH8iwRCsCuRYNWKDAIaeHNkSgwo+KnGTWeFxs+tIVCuoRUo/WSCN+rHka9N3d+5MCLcYvJOF+8ELZy/7MZhCjAVH7G0RzHXzjSFCXLJRdniU39vZrpiMYtHp9jwGqXT1iQ6E3Gmri7wY1BJbRmee5/4fb5zvDc5b2RoszjDNxIrNgkBv4dzjGJsX9xSq13qhbnpXbclA7j6xvKt5yuk6Kdn1uvKv5kwqxcsugwTJSO0s+V2KS/zQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UFO3AWpbiZViXyCi/AN6ly1wjtfw6TwgRdwgmhdPz4g=;
 b=HfAxr0roSmX0Qty2L223wMd+Ouf0cHYGo2ujDyzMCVF2K5k4kIcWf1nQ5p0wZAG2nwn9paPfWlEWeJaYrOpQTtUxqB6NVNR+K54HsaZwjKwRuSq/UAFd4rSDiJF1F/0rpSZdABKWTswGG7CLp5QPSlbUDFn9XcxLHynNHk87MM0=
Received: from DU6P191CA0026.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53f::17)
 by VI0PR08MB11751.eurprd08.prod.outlook.com (2603:10a6:800:316::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:05:50 +0000
Received: from DB1PEPF00039232.eurprd03.prod.outlook.com
 (2603:10a6:10:53f:cafe::f8) by DU6P191CA0026.outlook.office365.com
 (2603:10a6:10:53f::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.4 via Frontend Transport; Fri, 9
 Jan 2026 17:05:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00039232.mail.protection.outlook.com (10.167.8.105) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:05:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DCAQoXTPqveSWbDAHiFoPCjYDXIzEqYpF4xzZ1h+u6nY2aiGu4/hpzLI406SZ+I7DUoi3tLcE3DmeR6lgFwjhBVRYgrabdYmhl+9PRPINeNEP6bNZK+R+F9NM1CqXNMbuyzNkNvdkc9ZB9iUHVTfRXm7Dqt210ssRCZyCbJ9s17J/s1oqiupFzpezpYZXNlwbDUnCCZr5yqOs+mVRQkrvmZG2nFxNlamYx3VgKQyo8o9t7EIZ1M1LplsnPpUHXSbVgNF3mug/OsLCKGTiWtvLiW8wd7QHKXswRlBIRZrMUaRq8w/o/K0bNYsRqNyQjSxeTfnMdohxRq5Sm3JzzY0aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UFO3AWpbiZViXyCi/AN6ly1wjtfw6TwgRdwgmhdPz4g=;
 b=sMgzlKIJ6CW4hHMxqRmA6cdd3/RoH/kywf8oV/G4ITTwcjXPKZmcasbDC9g4D06OVjPE8XUbCGdxwLSwKf6vSyFWHr7VTW64BNBQdfLum+PUOKrdPvS4axL7l4+QEVBfs+hn1wIC3hOrFbF3e3td3EMd+J8gOiu0Yz1Iiee8C0BSqyCi3ksSD949CgHYHj9B1JAo2eBbKu6NU/oZotbpWlmlkfi4klL1GQkPtfYWxJPaMvbV2E3xpeDdRxBckR7IJ64c75SC2lcy7NZuXuZ0+IFXB9cvEknkyzgTft0jSsA6qnst5rK/H7vDnESZBQJwsIeGi8QoaxCwbp7gLbry9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UFO3AWpbiZViXyCi/AN6ly1wjtfw6TwgRdwgmhdPz4g=;
 b=HfAxr0roSmX0Qty2L223wMd+Ouf0cHYGo2ujDyzMCVF2K5k4kIcWf1nQ5p0wZAG2nwn9paPfWlEWeJaYrOpQTtUxqB6NVNR+K54HsaZwjKwRuSq/UAFd4rSDiJF1F/0rpSZdABKWTswGG7CLp5QPSlbUDFn9XcxLHynNHk87MM0=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by PA4PR08MB7386.eurprd08.prod.outlook.com (2603:10a6:102:2a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 17:04:46 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:46 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v3 19/36] KVM: arm64: gic-v5: Implement PPI interrupt
 injection
Thread-Topic: [PATCH v3 19/36] KVM: arm64: gic-v5: Implement PPI interrupt
 injection
Thread-Index: AQHcgYoN+DA5KKVJ9UuSzYIpV1odOw==
Date: Fri, 9 Jan 2026 17:04:45 +0000
Message-ID: <20260109170400.1585048-20-sascha.bischoff@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
In-Reply-To: <20260109170400.1585048-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|PA4PR08MB7386:EE_|DB1PEPF00039232:EE_|VI0PR08MB11751:EE_
X-MS-Office365-Filtering-Correlation-Id: c58737a0-d853-4b54-159e-08de4fa156af
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?Zzhnjv7D+bL8AjI7UrpZ4WcV0VUHzSi6PieyQPoG0rB3ebVNnVdk1LVRDW?=
 =?iso-8859-1?Q?2NCmBVF3C+UkLSbtFiVRXj5w1hZoqCvBa6f50hrmfGiJWVDTV5VODK1Fj3?=
 =?iso-8859-1?Q?CDQNYIZhQGtc4S0vQgj5y0FMCiudGL+TbKUywfFpCRs6qHrJu1JUTNThGr?=
 =?iso-8859-1?Q?ylvDfzYmmoH/2Y5HuVesTCtRZPaocSzy87VI/fpPYBE5RkYh/0LBBEixb6?=
 =?iso-8859-1?Q?dRghFPPKzb3xPJ+VVCnHxExLWACynYB+SvDQ+0vKvYeMRUbbkOaFeXCjc5?=
 =?iso-8859-1?Q?plCY18wn+Tf8pnG+8tZoBnwcVK2QTAb0rdqktFIi3no4mtbE3laqnT0FsG?=
 =?iso-8859-1?Q?AzHXQf4nbmLhJuuYc8Tv8+8MRJfo6TFwuEBFa+9dSBM+mx4ByVuEwwaeTG?=
 =?iso-8859-1?Q?MB9JGrODi7g5ylMMhI19cvxewb9PLJtG8aVW7M8UTnY/1pcvR3FVgyp+sR?=
 =?iso-8859-1?Q?Pko8rY9hOgJwJlS5iGGlU3JzDwLRmfsFHVwAulq/FgL5RIbSUemYw8t7nk?=
 =?iso-8859-1?Q?3F5tc59qxS5HytBMV+w5693ilhTy/U05rLcPbsmKslJc+g3VtnsfUx1NEL?=
 =?iso-8859-1?Q?iTutz6nxFdF/h5zVtBUoQ8kKAFn207fc+ia7s7BBqGEMGpxkwnvNa1KzY5?=
 =?iso-8859-1?Q?sAmtMTcYuw65ZvBilmKjLF3w/QJ3IgdBgtQgjoulsWQ7wRdGFPVyrD7E1Q?=
 =?iso-8859-1?Q?slaKgxaQiRWJPy49AToD1xNual7ax/xWUqs2jBhfqJMWk0l/cs3TKk+IzV?=
 =?iso-8859-1?Q?zb2S5v7gWKnTwb7Yt+r7wzOipJi05j55IDfXXHTFBfkLhfncirpyGBj/Wd?=
 =?iso-8859-1?Q?WYVQKp0hcc/QZsixKhdGFuAYu49+8rP636ezOJSMP5L0FiLuMio8eY+ZHb?=
 =?iso-8859-1?Q?DfMnfX2q1j1sUueMb/wFhuPGc9AlOP3fn0InCuCuC5Ppayw6sKo+y7Shu4?=
 =?iso-8859-1?Q?8JYiwXFQgalj01vfKSbcf5pEJUtbI7b37iwcdpJlXSlcEV8ZbEOigEP5pn?=
 =?iso-8859-1?Q?Dy1OtJOhMytY8sI3eTO6qW+NOxM7Dz5srkmDWiWu0RFeSedyEKJXopTMIm?=
 =?iso-8859-1?Q?1wBurf3Ufg7gzwuzu2mGysHPY/UA8M9z8OtTCWr5eDCpbRY7dEOrcO8bY1?=
 =?iso-8859-1?Q?CZgnpvANjJM9ECz7cAaN21Ycyoiv1Uki1V/pXYmb75ccuqsD3AGDNJH6n3?=
 =?iso-8859-1?Q?nHDBWsM+VpO3cBdTuaHnVDlMbuvfy2Eylg6UobzRxoyym2s4MjWXsKa1xH?=
 =?iso-8859-1?Q?i4V/xMtPSUh6fWDYfCSS/02GKL5NEH8bgfXvlODSZMd2YdkpIrXwuqonBC?=
 =?iso-8859-1?Q?0mKBqvnvkb5Qxt5FnjS9YJBRNAt6Eek6rThhQYcyavuVhufC5B5SPwFtBQ?=
 =?iso-8859-1?Q?1a4sJMbn7ovIqdyw5wVVox1lSFnAznEpXb9CDK25QdjL+HqDKjwHBdMkhI?=
 =?iso-8859-1?Q?W/OkHMa24i/zweVeDrY87iuXG2LgSt09f3kI9aoK2atHLXKUh5QdQQFbez?=
 =?iso-8859-1?Q?gHJ1fqrloucPbPxtfluDHFgAFZu1csdtjG6gOa1WlyZBD2wT2l+NyPGJlG?=
 =?iso-8859-1?Q?ybKbzpShQy8G1r7LSRHVR9ZELYxB?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB7386
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF00039232.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9c72040c-1013-405a-8c4d-08de4fa13131
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|35042699022|14060799003|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?3/8HHsoN60pVnuqbwh+PF/OD0MsLdXe7N8u6x8RxqIDSjMnAh+MuCh/v6j?=
 =?iso-8859-1?Q?B36cn/a1a946ir3d2z+9bAYq8dyBoAYJ+JzFvKo3U/ao7wLnQDth7GGwAw?=
 =?iso-8859-1?Q?mDp3jY+xAo+Q6dOIxlTzWJqTlgTsu4MDP296hiq1CVchOLdia5I53kw6rs?=
 =?iso-8859-1?Q?i+79LFNzD5ZTKpyjDJtmck620adSrBBh3IJhI090VciUmEAw8Y6KPA/+EZ?=
 =?iso-8859-1?Q?PKBuJFB0AUdKfmfu/12HTZF0nBk+8g55g3pRlV3cZBTYYcZdL27R50Yosh?=
 =?iso-8859-1?Q?guPq5iflxuZcExB1iJfhBNrzhqa8EjKd07O3j9BucF0zO4KXu7yGYw0JYW?=
 =?iso-8859-1?Q?2cwmFVhcGLktV63RPzeYMySqhcj2dOS73hBWrKNp99CotvERidTy0twGwY?=
 =?iso-8859-1?Q?Z0QlXSzcQDEJ+Oi5I9NigjEDd1poTlADCa1NHxj/g/Sg1a2B30VJ9sJVTw?=
 =?iso-8859-1?Q?/hYYWK7493muFgVxFTbx36iJ7S1j1VrG+6WlYOvg7kjitcm73knrhW6/Fm?=
 =?iso-8859-1?Q?V1q4ypciPdUe+FEnYsw44hzZ+2EltvQwysV59esVmTXkUSFJ07FtOGhcp/?=
 =?iso-8859-1?Q?3xCpYSy/H6Pnbg+51w7THgg8IboUTY6YOkDbFfRy7F18m8NWkfaoSKmtLT?=
 =?iso-8859-1?Q?CyEyHWZi0lgB3KzKorBSyYUFHiryTBiH6ANb6IVwXefUS/3ZI1H1XrazAH?=
 =?iso-8859-1?Q?IEKV7LyXz7NEWCx+0Ztu2lU+VnvUyVXEREK4PTXOfur/t/GIS/myQcgk6H?=
 =?iso-8859-1?Q?3zo0OGYqbSj8lLqetw/o94aEQj74K9R45YYZ8lCZFndNwWUeCFSJ0XY9JH?=
 =?iso-8859-1?Q?c6claxaQOSS4WazjjKyknmk/OPaoUkFcBsFKeguyFBNT7oTQFs2zptq/jV?=
 =?iso-8859-1?Q?PTPYb3Ip+67C//mqly1KFwE9sXImx01h5ZpR/f/eJcOmgLaBlvpHC5P8zU?=
 =?iso-8859-1?Q?bFqwju97rL9sIEY0Wb6qidJbrRWKbShmmR9ZkfApI1B9EdRbGpRGChthIL?=
 =?iso-8859-1?Q?Loxq9/P9Qbf8JosE882fpcwJuNjhbhsUHlNabPfI3X6Fp1Byd6H/N4pgAI?=
 =?iso-8859-1?Q?h+PR1jPLm950fCmskREsEGSPjPrMptiO5aDwGLLZi0e4eSOkbySe0Hco/I?=
 =?iso-8859-1?Q?2NVRhj+77jVdcgLuZWVCQz9F6iraCUfSv1o1XGxMQfCS0cqOUrxqEst6f9?=
 =?iso-8859-1?Q?6tCAKpnUxs4whGKio8PY72cE1IEscLCbuY+YHou5/4MNUYANUzaT06ZbEV?=
 =?iso-8859-1?Q?4KUBocQBtc7SCPw4LwxJQx7wyzzVvN7nhcjdyJhe7zHsXzs3t82ydgjASx?=
 =?iso-8859-1?Q?QtBuLY8cVzmJ1v08Du8qxaO8KsHhPP13/Kkdo7cExqPE0KSRnPOBnYtcKS?=
 =?iso-8859-1?Q?pD1epp+cDZu/L8/uR3OZUjsMl1iQa3xslG6B1H5gQkYzpPJKuYnevGVcpQ?=
 =?iso-8859-1?Q?iRztHY2Aprem/+0pY3/JXFXIHjD0GiMrszysIVDPkXYm8fu6XJj7wEDaSo?=
 =?iso-8859-1?Q?9ASJm5A50qPlLULcFltVuLOGdoBiYCpFKS7UsbAWfUfGqcSR3k7Gkxnijw?=
 =?iso-8859-1?Q?usjSmT8aa4WA8K3Q69MmFqtFdXklK0NB55yQEwlLCD1Ihg4wZhn7sYHPuF?=
 =?iso-8859-1?Q?Ble4w3RY6XJj4=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(35042699022)(14060799003)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:49.4649
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c58737a0-d853-4b54-159e-08de4fa156af
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00039232.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11751

This change introduces interrupt injection for PPIs for GICv5-based
guests.

The lifecycle of PPIs is largely managed by the hardware for a GICv5
system. The hypervisor injects pending state into the guest by using
the ICH_PPI_PENDRx_EL2 registers. These are used by the hardware to
pick a Highest Priority Pending Interrupt (HPPI) for the guest based
on the enable state of each individual interrupt. The enable state and
priority for each interrupt are provided by the guest itself (through
writes to the PPI registers).

When Direct Virtual Interrupt (DVI) is set for a particular PPI, the
hypervisor is even able to skip the injection of the pending state
altogether - it all happens in hardware.

The result of the above is that no AP lists are required for GICv5,
unlike for older GICs. Instead, for PPIs the ICH_PPI_* registers
fulfil the same purpose for all 128 PPIs. Hence, as long as the
ICH_PPI_* registers are populated prior to guest entry, and merged
back into the KVM shadow state on exit, the PPI state is preserved,
and interrupts can be injected.

When injecting the state of a PPI the state is merged into the KVM's
shadow state using the set_pending_state irq_op. The directly sets the
relevant bit in the shadow ICH_PPI_PENDRx_EL2, which is presented to
the guest (and GICv5 hardware) on next guest entry. The
queue_irq_unlock irq_op is required to kick the vCPU to ensure that it
seems the new state. The result is that no AP lists are used for
private interrupts on GICv5.

Prior to entering the guest, vgic_v5_flush_ppi_state is called from
kvm_vgic_flush_hwstate. The effectively snapshots the shadow PPI
pending state (twice - an entry and an exit copy) in order to track
any changes. These changes can come from a guest consuming an
interrupt or from a guest making an Edge-triggered interrupt pending.

When returning from running a guest, the guest's PPI state is merged
back into KVM's shadow state in vgic_v5_merge_ppi_state from
kvm_vgic_sync_hwstate. The Enable and Active state is synced back for
all PPIs, and the pending state is synced back for Edge PPIs (Level is
driven directly by the devices generating said levels). The incoming
pending state from the guest is merged with KVM's shadow state to
avoid losing any incoming interrupts.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 160 ++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c    |  40 +++++++--
 arch/arm64/kvm/vgic/vgic.h    |  25 ++++--
 3 files changed, 209 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index bf2c77bafa1d3..c1899add8f5c3 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -139,6 +139,166 @@ void vgic_v5_get_implemented_ppis(void)
 		ppi_caps->impl_ppi_mask[0] |=3D BIT_ULL(GICV5_ARCH_PPI_PMUIRQ);
 }
=20
+static bool vgic_v5_ppi_set_pending_state(struct kvm_vcpu *vcpu,
+					  struct vgic_irq *irq)
+{
+	struct vgic_v5_cpu_if *cpu_if;
+	const u32 id =3D FIELD_GET(GICV5_HWIRQ_ID, irq->intid);
+	unsigned long *p;
+
+	if (!vcpu || !irq)
+		return false;
+
+	/*
+	 * For DVI'd interrupts, the state is directly driven by the host
+	 * hardware connected to the interrupt line. There is nothing for us to
+	 * do here. Moreover, this is just broken!
+	 */
+	if (WARN_ON(irq->directly_injected))
+		return true;
+
+	cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	p =3D (unsigned long *)&cpu_if->vgic_ppi_pendr[id / 64];
+	__assign_bit(id % 64, p, irq_is_pending(irq));
+
+	return true;
+}
+
+/*
+ * For GICv5, the PPIs are mostly directly managed by the hardware. We (th=
e
+ * hypervisor) handle the pending, active, enable state save/restore, but =
don't
+ * need the PPIs to be queued on a per-VCPU AP list. Therefore, sanity che=
ck the
+ * state, unlock, and return.
+ */
+static bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq =
*irq,
+					 unsigned long flags)
+	__releases(&irq->irq_lock)
+{
+	struct kvm_vcpu *vcpu;
+
+	lockdep_assert_held(&irq->irq_lock);
+
+	if (WARN_ON_ONCE(!__irq_is_ppi(KVM_DEV_TYPE_ARM_VGIC_V5, irq->intid)))
+		goto out_unlock_fail;
+
+	vcpu =3D irq->target_vcpu;
+	if (WARN_ON_ONCE(!vcpu))
+		goto out_unlock_fail;
+
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+
+	/* Directly kick the target VCPU to make sure it sees the IRQ */
+	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
+	kvm_vcpu_kick(vcpu);
+
+	return true;
+
+out_unlock_fail:
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+
+	return false;
+}
+
+static struct irq_ops vgic_v5_ppi_irq_ops =3D {
+	.set_pending_state =3D vgic_v5_ppi_set_pending_state,
+	.queue_irq_unlock =3D vgic_v5_ppi_queue_irq_unlock,
+};
+
+void vgic_v5_set_ppi_ops(struct vgic_irq *irq)
+{
+	if (WARN_ON(!irq))
+		return;
+
+	guard(raw_spinlock_irqsave)(&irq->irq_lock);
+
+	if (!WARN_ON(irq->ops))
+		irq->ops =3D &vgic_v5_ppi_irq_ops;
+}
+
+/*
+ * Detect any PPIs state changes, and propagate the state with KVM's
+ * shadow structures.
+ */
+void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	for (int reg =3D 0; reg < 2; reg++) {
+		const u64 activer =3D host_data_ptr(vgic_v5_ppi_state)->activer_exit[reg=
];
+		const u64 pendr =3D host_data_ptr(vgic_v5_ppi_state)->pendr_exit[reg];
+		unsigned long changed_bits;
+		int i;
+
+		/*
+		 * Track what changed across activer, pendr, but mask with
+		 * ~DVI.
+		 */
+		changed_bits =3D cpu_if->vgic_ppi_activer[reg] ^ activer;
+		changed_bits |=3D host_data_ptr(vgic_v5_ppi_state)->pendr_entry[reg] ^ p=
endr;
+		changed_bits &=3D ~cpu_if->vgic_ppi_dvir[reg];
+
+		for_each_set_bit(i, &changed_bits, 64) {
+			struct vgic_irq *irq;
+			u32 intid;
+
+			intid =3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
+			intid |=3D FIELD_PREP(GICV5_HWIRQ_ID, reg * 64 + i);
+
+			irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+			scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+				irq->active =3D !!(activer & BIT(i));
+
+				/*
+				 * This is an OR to avoid losing incoming
+				 * edges!
+				 */
+				if (irq->config =3D=3D VGIC_CONFIG_EDGE)
+					irq->pending_latch |=3D !!(pendr & BIT(i));
+			}
+
+			vgic_put_irq(vcpu->kvm, irq);
+		}
+
+		/* Re-inject the exit state as entry state next time! */
+		cpu_if->vgic_ppi_activer[reg] =3D activer;
+
+		/*
+		 * Pending state is a bit different. We only propagate back
+		 * pending state for Edge interrupts. Moreover, this is OR'd
+		 * with the incoming state to make sure we don't lose incoming
+		 * edges. Use the (inverse) HMR to mask off all Level bits, and
+		 * OR.
+		 */
+		cpu_if->vgic_ppi_pendr[reg] |=3D
+			pendr & ~vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr[reg];
+	}
+}
+
+void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/*
+	 * We're about to enter the guest. Copy the shadow state to the pending
+	 * reg that will be written to the ICH_PPI_PENDRx_EL2 regs. While the
+	 * guest is running we track any incoming changes to the pending state in
+	 * vgic_ppi_pendr. The incoming changes are merged with the outgoing
+	 * changes on the return path.
+	 */
+	host_data_ptr(vgic_v5_ppi_state)->pendr_entry[0] =3D cpu_if->vgic_ppi_pen=
dr[0];
+	host_data_ptr(vgic_v5_ppi_state)->pendr_entry[1] =3D cpu_if->vgic_ppi_pen=
dr[1];
+
+	/*
+	 * Make sure that we can correctly detect "edges" in the PPI
+	 * state. There's a path where we never actually enter the guest, and
+	 * failure to do this risks losing pending state
+	 */
+	host_data_ptr(vgic_v5_ppi_state)->pendr_exit[0] =3D cpu_if->vgic_ppi_pend=
r[0];
+	host_data_ptr(vgic_v5_ppi_state)->pendr_exit[1] =3D cpu_if->vgic_ppi_pend=
r[1];
+}
+
 /*
  * Sets/clears the corresponding bit in the ICH_PPI_DVIR register.
  */
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index c465ff51cb073..1cdfa5224ead5 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -105,6 +105,18 @@ struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vc=
pu, u32 intid)
 	if (WARN_ON(!vcpu))
 		return NULL;
=20
+	if (vgic_is_v5(vcpu->kvm)) {
+		u32 int_num;
+
+		if (!__irq_is_ppi(KVM_DEV_TYPE_ARM_VGIC_V5, intid))
+			return NULL;
+
+		int_num =3D FIELD_GET(GICV5_HWIRQ_ID, intid);
+		int_num =3D array_index_nospec(int_num, VGIC_V5_NR_PRIVATE_IRQS);
+
+		return &vcpu->arch.vgic_cpu.private_irqs[int_num];
+	}
+
 	/* SGIs and PPIs */
 	if (intid < VGIC_NR_PRIVATE_IRQS) {
 		intid =3D array_index_nospec(intid, VGIC_NR_PRIVATE_IRQS);
@@ -828,9 +840,11 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 		vgic_release_deleted_lpis(vcpu->kvm);
 }
=20
-static inline void vgic_fold_lr_state(struct kvm_vcpu *vcpu)
+static void vgic_fold_state(struct kvm_vcpu *vcpu)
 {
-	if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
+	if (vgic_is_v5(vcpu->kvm))
+		vgic_v5_fold_ppi_state(vcpu);
+	else if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
 		vgic_v2_fold_lr_state(vcpu);
 	else
 		vgic_v3_fold_lr_state(vcpu);
@@ -1037,8 +1051,10 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 	if (can_access_vgic_from_kernel())
 		vgic_save_state(vcpu);
=20
-	vgic_fold_lr_state(vcpu);
-	vgic_prune_ap_list(vcpu);
+	vgic_fold_state(vcpu);
+
+	if (!vgic_is_v5(vcpu->kvm))
+		vgic_prune_ap_list(vcpu);
 }
=20
 /* Sync interrupts that were deactivated through a DIR trap */
@@ -1062,6 +1078,17 @@ static inline void vgic_restore_state(struct kvm_vcp=
u *vcpu)
 		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
 }
=20
+static void vgic_flush_state(struct kvm_vcpu *vcpu)
+{
+	if (vgic_is_v5(vcpu->kvm)) {
+		vgic_v5_flush_ppi_state(vcpu);
+		return;
+	}
+
+	scoped_guard(raw_spinlock, &vcpu->arch.vgic_cpu.ap_list_lock)
+		vgic_flush_lr_state(vcpu);
+}
+
 /* Flush our emulation state into the GIC hardware before entering the gue=
st. */
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 {
@@ -1098,13 +1125,12 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
=20
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
=20
-	scoped_guard(raw_spinlock, &vcpu->arch.vgic_cpu.ap_list_lock)
-		vgic_flush_lr_state(vcpu);
+	vgic_flush_state(vcpu);
=20
 	if (can_access_vgic_from_kernel())
 		vgic_restore_state(vcpu);
=20
-	if (vgic_supports_direct_irqs(vcpu->kvm))
+	if (vgic_supports_direct_irqs(vcpu->kvm) && kvm_vgic_global_state.has_gic=
v4)
 		vgic_v4_commit(vcpu);
 }
=20
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index d5d9264f0a1e9..c8f538e65303f 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -364,7 +364,10 @@ void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_get_implemented_ppis(void);
+void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
 int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi);
+void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
+void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu);
 void vgic_v5_load(struct kvm_vcpu *vcpu);
 void vgic_v5_put(struct kvm_vcpu *vcpu);
 void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
@@ -433,15 +436,6 @@ void vgic_its_invalidate_all_caches(struct kvm *kvm);
 int vgic_its_inv_lpi(struct kvm *kvm, struct vgic_irq *irq);
 int vgic_its_invall(struct kvm_vcpu *vcpu);
=20
-bool system_supports_direct_sgis(void);
-bool vgic_supports_direct_msis(struct kvm *kvm);
-bool vgic_supports_direct_sgis(struct kvm *kvm);
-
-static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
-{
-	return vgic_supports_direct_msis(kvm) || vgic_supports_direct_sgis(kvm);
-}
-
 int vgic_v4_init(struct kvm *kvm);
 void vgic_v4_teardown(struct kvm *kvm);
 void vgic_v4_configure_vsgis(struct kvm *kvm);
@@ -481,6 +475,19 @@ static inline bool vgic_is_v3(struct kvm *kvm)
 	return kvm_vgic_global_state.type =3D=3D VGIC_V3 || vgic_is_v3_compat(kvm=
);
 }
=20
+bool system_supports_direct_sgis(void);
+bool vgic_supports_direct_msis(struct kvm *kvm);
+bool vgic_supports_direct_sgis(struct kvm *kvm);
+
+static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
+{
+	/* GICv5 always supports direct IRQs */
+	if (vgic_is_v5(kvm))
+		return true;
+
+	return vgic_supports_direct_msis(kvm) || vgic_supports_direct_sgis(kvm);
+}
+
 int vgic_its_debug_init(struct kvm_device *dev);
 void vgic_its_debug_destroy(struct kvm_device *dev);
=20
--=20
2.34.1

