Return-Path: <kvm+bounces-67616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 38D0CD0B860
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:09:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C9C6C3042C16
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5978B369997;
	Fri,  9 Jan 2026 17:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Hr3BBu46";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Hr3BBu46"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010044.outbound.protection.outlook.com [52.101.69.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E26369210
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.44
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978363; cv=fail; b=X/G72xkE+bCyywVUe5CSXsbrjhN20wT9GtzHdk6GMds7Zdv//mRsUSsTf1t2E6roL8xdcGrBuaN1FJvMc0Z3+7sW9zVq751smwftMKYTttfiYc3XxtMM2WH1TC9dZt370GyLyKtC9zUulBGQ/63q69KbXZ7akw9yis0++BawbV0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978363; c=relaxed/simple;
	bh=NGxlUWjZqtZ5TRaczIph0ux4X7U4BAOWR/o+zxakEMY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YWjC+2QVDC4OvoRY4Cw8ziM53XdF3g8oUgYBDRBMpHxjWMksgG4cDlrKz/Fos1vpDGxL8PtsjCkPCZR+dat0m6/cTh0vcRwFdKpQ9Llgn59oSDW38xxE5CLsVLd65+RNIGJCpMn5iMTTD9m1aPSDRpAAkoBMWAnH81zIxKHOpHY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Hr3BBu46; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Hr3BBu46; arc=fail smtp.client-ip=52.101.69.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=BGjnhTyca+/Afus8ymKMHv++DSDltIzNV/3RCuO5RQpvIBIMB0SoR9MINI0wgkVbwEWAeDF0LEH9GvoVPQs70ihBFcyoisXL7xYqqs3xem5CTvhernstsezQk8LgYrnDyxea3DYv+qlY0f2JBlHVbX2iY6UduyfHVkD2wofk8OG38gHyyfERtRu4zHF3rhYbFx05IaKl8r+/dg01OqftMRVYn4Fzjww5kbwlqL/bB2GgMZP0ivDY7td6MErV+Vug3olEzWXLkjvMpi6DcsCZizvJKbDRpEqEyU249hRzLKCvvnucU88LgIJCu3xK9AgVIn2Ky07xVw+hw0gZSOt4mw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BFTMF6CDGQmBcjmMDIW7JDwgRFD5pXPqqMjrpqxZxx4=;
 b=oZiMmkbQ8Xizvlc0Ti4Jvp7uvuYRa8atwkWfNPHI4Wg2X/wf7DJLA1TET+KfYap90+l821bZAiaV/nrHL8ab3hgjCl/FxrXRKPI7AK0Zf5qKs2YYnmNvDQw8CioI+Ce4uNL4rQoLI/2ij0awwQsXDLEtpLhWCctWUbiehVRheiZWaX9xik2WCFxXySedzlZAdamRFElb02HPSY83GuPEIBSigLmdIZ9Zn2urhVdOuDSfOcJ5EdSr4YhQOu968mkTaPuGGl/Y7rFFaCuyRenFtZiNQYD2ttZdQk38lQLfySgGO+zIQks7wi23BfKQEZ/w7cJVq39GVqIudvI1fnId6w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BFTMF6CDGQmBcjmMDIW7JDwgRFD5pXPqqMjrpqxZxx4=;
 b=Hr3BBu46mlsV1hZ+sAeXnNN7L86pw7Qyc54HqPLsJ5rDZBKbbq5lPLZgkQDiGJq1xvxsaRfYbKMKuTBm93savyolu4ixZG/cqTwgWj+yJMvibE8lQxM/9qJ25DR3XNGBoI1rNrbTnwcCjq9zSLTMnF4jOEDTeEa3eMUZq53vTlQ=
Received: from DB9PR05CA0014.eurprd05.prod.outlook.com (2603:10a6:10:1da::19)
 by DBAPR08MB5639.eurprd08.prod.outlook.com (2603:10a6:10:1a2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Fri, 9 Jan
 2026 17:05:53 +0000
Received: from DB5PEPF00014B9B.eurprd02.prod.outlook.com
 (2603:10a6:10:1da:cafe::4c) by DB9PR05CA0014.outlook.office365.com
 (2603:10a6:10:1da::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.4 via Frontend Transport; Fri, 9
 Jan 2026 17:05:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B9B.mail.protection.outlook.com (10.167.8.168) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:05:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dilewgB4vTFgOO6mBWv4RTbubY/hVTnuq6mstAwRHqOn4QMK2yTQSu5GRoGBlNQHgIl1JcxYD2Hoi8B8UKUolD+YT5c8dm6YFeR/iY7KzzRdkWzolUA640eKAQkA6tdt2bis2VR1Dbwa88fafDq1auq4qhs1QHM0wk3r4kFptvd2lp/6hYmQYzBjb05YtlNtqbE/5WXAJWLMv6v6nm2QVkMoMn0HAk8pIz7ylgmzgSfCgeBO1vd/ogC7n9RUYyQn86sEE7P1U+wKOQwSXyyv2PuJPT0oo76JuiPopR/N5G3cQbqT8fyxWsex89Tr4ARoOpXn09r1rfmkedqqeVA9cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BFTMF6CDGQmBcjmMDIW7JDwgRFD5pXPqqMjrpqxZxx4=;
 b=DryDkujnp5wVMIMNcBECvCsO/dRTkfuc+3tW4EO6YGFyOWwQvncdYUeYDmnH8dEKvMryO0GXWyL+5MWKP6HojUMmh9vuE2Miw8PTcZ9LxbSvr+BmFnEuqkuITxOQzwkEuGvSmGb/pZlO15uM4+MqqzWgAOBoc3GY1LTKh4j6N2IRlFL9G1jJDFHUyxN2eWz2Oo1TieFciTW3CAUyJWkhyps+uEIlJ86M6JeE1c2MCOHMKBwOR6cJBDti89coGPtTKHGoHqLtIP6EH/0BwHOWXT0w1ez8Szs1v8G6S/6OXur/DtO7/PLJ5FaNs7sm3phiCQdu++mObPS2Dllwc+w/+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BFTMF6CDGQmBcjmMDIW7JDwgRFD5pXPqqMjrpqxZxx4=;
 b=Hr3BBu46mlsV1hZ+sAeXnNN7L86pw7Qyc54HqPLsJ5rDZBKbbq5lPLZgkQDiGJq1xvxsaRfYbKMKuTBm93savyolu4ixZG/cqTwgWj+yJMvibE8lQxM/9qJ25DR3XNGBoI1rNrbTnwcCjq9zSLTMnF4jOEDTeEa3eMUZq53vTlQ=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by PA4PR08MB7386.eurprd08.prod.outlook.com (2603:10a6:102:2a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 17:04:49 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:49 +0000
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
Subject: [PATCH v3 26/36] KVM: arm64: gic-v5: Bump arch timer for GICv5
Thread-Topic: [PATCH v3 26/36] KVM: arm64: gic-v5: Bump arch timer for GICv5
Thread-Index: AQHcgYoPZi/NkB/f9Uqz2OxMhF1uEw==
Date: Fri, 9 Jan 2026 17:04:47 +0000
Message-ID: <20260109170400.1585048-27-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|PA4PR08MB7386:EE_|DB5PEPF00014B9B:EE_|DBAPR08MB5639:EE_
X-MS-Office365-Filtering-Correlation-Id: e9f52602-4a65-467b-ffe8-08de4fa1587a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?gfKlmgGNoERY1t1GOR09HxT0ED5IzIGCdR2aW5Pm94LRokrobOmdqqe2nw?=
 =?iso-8859-1?Q?YrlX3GV4VQwepwIyv1v9PGwq+oSB2x71SzLMgs6p1HeU/A9uiIp3rvnYMs?=
 =?iso-8859-1?Q?tukbfm9sMQYd84k741TAYnRhyON2tqDsIxGITgrUrQFImpoQ4CwYLloaMp?=
 =?iso-8859-1?Q?CebK03fxl4ubb28H2DMK/f+pzPRtMcLD6AYpbpNHBMvg7pMBXSOtZl1mkT?=
 =?iso-8859-1?Q?Kow9A/FaF9mKFsDFdqGWVt4pvLXBn8zMeM3svMMZOzJc7239yqgCW0S9h8?=
 =?iso-8859-1?Q?9D6ovN3tVlDKCK1wj8mIguSDZ0wPJUhSDn8qY9akqjxpToFB+30uT150gu?=
 =?iso-8859-1?Q?TlNxjEI+VZSAF8jYrgpJJymnjorGV3poRzancJBIdmx1fbByUR+sRxM8Da?=
 =?iso-8859-1?Q?NAe3cUkwgtjPXWmiGDwuYQEacOoL1W8oy0t9rjjfqWGwNK7zu2raDl+/sZ?=
 =?iso-8859-1?Q?ZvWNsrA1VGTazbITacTopTonD8joiMp6B86CHvViHkdWo8PT0BjSgVj2FR?=
 =?iso-8859-1?Q?tugS0VJfYaK5WeMlrqcK3sI+FnR2eMmV4s+YrYNcH3fsr8acjOhyXvTTP+?=
 =?iso-8859-1?Q?4bGcuU7CHXmsjs5SNZINZBFngAbU/59rvwZj5eWHBGQjDr90yWZhA7/afi?=
 =?iso-8859-1?Q?8dDqoxh2Ql55fYZeSHhGEgPx8KgZvKwYMajNQ9r7f32gWz5+LinyJsC3sa?=
 =?iso-8859-1?Q?LyKEJ4dI3VIiTMkZZgftSUTCpYMR75BoOH8M2jtzCVA/LMLPYymgRrYWBO?=
 =?iso-8859-1?Q?lZ913O1i+Fy4klfZFFtRWCs1q0REpMYiVcS8cUVcu5fHx+gbkp/1GBPKFE?=
 =?iso-8859-1?Q?wP1Npniymo2oQUTGbd9sPscVGHDHusbRGLi+oPdgqL7lNMvQdaQNRZ1NIW?=
 =?iso-8859-1?Q?W/J7aObOaNgcAySV7NNckzMyIc78CLz9PY7MrA3adiECsE+27EOzwWXNFL?=
 =?iso-8859-1?Q?RhqYeSvI2ZVJ5yAUfmEO7lxj30rwsWTbbzKv1Nu89iBY1GJyTg5ti00XTs?=
 =?iso-8859-1?Q?K67Czvg1RYB/DtOsTbk55u1jA4DuhhevrVZrLTH0vizrbYvNkYsEefsqL5?=
 =?iso-8859-1?Q?7ablfyQ0hJB9cI6ehdmAbglPwMchNBooM9M06H6q+5zun/OtnzpFlyeviB?=
 =?iso-8859-1?Q?oTKbt5c2DmiScjN3c6bUaQl1nCXQgdOf3SqDaRZjQhp3RfZKdQhFnZ5LWC?=
 =?iso-8859-1?Q?lVeEYbv7hpSrvAZ2jhmeI5iX6BMsfRu8rEUzpkJiVGfVfwLx49nqOuH7eC?=
 =?iso-8859-1?Q?KfF6H7lPevwOcuLbc8p0St/X61Ruq0ajrMUeZlAzkUiI7GndLsDxkmO2jK?=
 =?iso-8859-1?Q?EZeo/KpuOPM3cFKriqNBZk7KAQ3CgT7chHeyi8FH4WH1SAPWnGvdb91fR0?=
 =?iso-8859-1?Q?M6cUihZfAD58ogwckYEJVq3uFpQe3HrcOW3ffyZbagU5DRRg4cAmp2CMo8?=
 =?iso-8859-1?Q?y45KGolRIv4vlHU9M0T8jvIGEGLrkyHWpjDTjQGTFEkLq2eqPf8zPgXGbf?=
 =?iso-8859-1?Q?Yy4ge+9V+xsh+/eU9UtBsDcbeGfUuweX4ohk3a3rx2T0QNbdRg7xYmwcL9?=
 =?iso-8859-1?Q?Z9SAH2bQgsbAGUDYlPf7u+1ExQnL?=
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
 DB5PEPF00014B9B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f07c9759-b385-4c56-0957-08de4fa1330f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|14060799003|82310400026|35042699022|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?G0rnC1EirQrG8WHg0ZdrnC5iiomUKffTxkRJTkskbbZb+kvseYNuVBp6WK?=
 =?iso-8859-1?Q?NE+z0j2tBe2VlSizGiiiCuw1eBO7OSTHsfITK72RzKBN2DA0LoFVvfQw12?=
 =?iso-8859-1?Q?YgDyL/S8xwTrT/9TDrFdp5g7gitq8972pz0v6R9upe8GaE9bJYArqazmA7?=
 =?iso-8859-1?Q?FtGFDy5GfzdMgNs89LkkYxeORebeuu7cdAHlnEPlptsKXfjU40NcjWiF0E?=
 =?iso-8859-1?Q?rJTG7em6k1mJYSAnEzhimGjFCY49remIQ2M8YmS87pw3YLoAVrdsA8UYMq?=
 =?iso-8859-1?Q?8/gyZYTFFb2FFpFavS3CCftjpbIzLxbCgdRK3aHjaGCyUcJIqpJB5Kwjpw?=
 =?iso-8859-1?Q?hVljw5kZMAIICA7KG/+GlV0ORea7FaPOjRanH8GbfsqYh4/qdiz5XxYLeJ?=
 =?iso-8859-1?Q?S1CBMFzaVMci+lZ7uwRdHA0NnT2OoBKZC6wtcifNEwpslOqRwnfXLNntIg?=
 =?iso-8859-1?Q?O4kBG+ow6Z6J0dr4zfs+JEauIMZGn6ohFKxvIOBNtUQfSD8Rz4CdKKTFB0?=
 =?iso-8859-1?Q?Dc/TN1upWxqBRpn5YC3dcWaSgJTAjZBnaLkdayGeEhdw9bwgOWQ5SZFyIO?=
 =?iso-8859-1?Q?OqbNNCfSEStXRHrt6HI0PvJF/jq2zJx3m/W6qs3EzBPYwTyHf7QHGgk+UP?=
 =?iso-8859-1?Q?04jxq/TVXEuJAQ4L1CVG3T2chYpeCKrGO0zRhEtl+ATjIq0crYT4uGp7YY?=
 =?iso-8859-1?Q?DFmP8j+NaUznqg8G2AXlbcrpw6gVZ2pWTmyNBRbRE1OBZdJFhIbnF3wzzg?=
 =?iso-8859-1?Q?GR2JFd1oK4ORguqJvFyiQueXDmUpIAGwbdvKQiHgYfQqlL4IZ4p+Qp4CLD?=
 =?iso-8859-1?Q?Ow95KDkaVct1jFN35iUsv3E0RV6JC7kCLfY+hJzNYCFTcZURpm0pkK1iwB?=
 =?iso-8859-1?Q?7t9uDXtKfGYW4jd8u7C8UyaP0Inds2g+7eRa2KoNxJF8L+DQ3SS5RcknEB?=
 =?iso-8859-1?Q?MrtatA+Hw7hqepWogFxWdX6sX1kfZHDOdDL/2bGsdvWlZdLxWv1qIcREkO?=
 =?iso-8859-1?Q?Jjc2cGHLkJTxs7M/lxQk1J4ab0MKJwc3CvCRzxcKePvLO+mIwtuwEG4JNv?=
 =?iso-8859-1?Q?1bSpFDsSTIfjm5IBTnj8DgctuyfM8ojxgHRWhXYzI+aAB8ALyMUHrbvX7i?=
 =?iso-8859-1?Q?b5TX9ZypjtNpvM4Cze289pswiwIJiHyZWFXYa5uIWKbbNdNCeM0VfpU8YZ?=
 =?iso-8859-1?Q?1aYA9ca0H9Etl01GlHs4W2URIPCZ73wL9Wby6j+HVr+dGkSzgzTTpWUUtT?=
 =?iso-8859-1?Q?rI6IfarVFyxvut8bpvLwLsnqp2Lhou8IR4HUBd7EpUk6WHr5vhMZjIFVp1?=
 =?iso-8859-1?Q?0lhOOxhmtRffNLCAsdmz1+MLH0bBg09xs8EJLGtW312gUH9H70tXvu5HT2?=
 =?iso-8859-1?Q?6ZdNO+srRPEgeo9RyrtR4xlvjxoXG9go+/1e517fZlOctUohKnfH6xz23u?=
 =?iso-8859-1?Q?pvzTbVD9Nn17THOPqbxt9F1AWaymheS0a7Ld9P6RPoxgk4Cw+UXIMTQZ7X?=
 =?iso-8859-1?Q?jlB1hfSPFUN70vKT0VqW6C5raH14hs6AQ+RaeDlSqf3jFYFzVuIlrd3nfL?=
 =?iso-8859-1?Q?E5Ks5uzieisgZC8tLSHLTzmp/bQVioH1652fdtVse18AfMmo/8XT6Gjj2A?=
 =?iso-8859-1?Q?slpKzBpXwsCp8=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(14060799003)(82310400026)(35042699022)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:52.4844
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9f52602-4a65-467b-ffe8-08de4fa1587a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B9B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5639

Now that GICv5 has arrived, the arch timer requires some TLC to
address some of the key differences introduced with GICv5.

For PPIs on GICv5, the set_pending_state and queue_irq_unlock irq_ops
are used as AP lists are not required at all for GICv5. The arch timer
also introduces an irq_op - get_input_level. Extend the
arch-timer-provided irq_ops to include the two PPI ops for vgic_v5
guests.

When possible, DVI (Direct Virtual Interrupt) is set for PPIs when
using a vgic_v5, which directly inject the pending state into the
guest. This means that the host never sees the interrupt for the guest
for these interrupts. This has three impacts.

* First of all, the kvm_cpu_has_pending_timer check is updated to
  explicitly check if the timers are expected to fire.

* Secondly, for mapped timers (which use DVI) they must be masked on
  the host prior to entering a GICv5 guest, and unmasked on the return
  path. This is handled in set_timer_irq_phys_masked.

* Thirdly, it makes zero sense to attempt to inject state for a DVI'd
  interrupt. Track which timers are direct, and skip the call to
  kvm_vgic_inject_irq() for these.

The final, but rather important, change is that the architected PPIs
for the timers are made mandatory for a GICv5 guest. Attempts to set
them to anything else are actively rejected. Once a vgic_v5 is
initialised, the arch timer PPIs are also explicitly reinitialised to
ensure the correct GICv5-compatible PPIs are used - this also adds in
the GICv5 PPI type to the intid.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/arch_timer.c     | 117 +++++++++++++++++++++++++-------
 arch/arm64/kvm/vgic/vgic-init.c |   9 +++
 arch/arm64/kvm/vgic/vgic-v5.c   |   8 +--
 include/kvm/arm_arch_timer.h    |  11 ++-
 include/kvm/arm_vgic.h          |   4 ++
 5 files changed, 119 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 6f033f6644219..2f30d69dbf1ac 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -56,6 +56,12 @@ static struct irq_ops arch_timer_irq_ops =3D {
 	.get_input_level =3D kvm_arch_timer_get_input_level,
 };
=20
+static struct irq_ops arch_timer_irq_ops_vgic_v5 =3D {
+	.get_input_level =3D kvm_arch_timer_get_input_level,
+	.set_pending_state =3D vgic_v5_ppi_set_pending_state,
+	.queue_irq_unlock =3D vgic_v5_ppi_queue_irq_unlock,
+};
+
 static int nr_timers(struct kvm_vcpu *vcpu)
 {
 	if (!vcpu_has_nv(vcpu))
@@ -177,6 +183,10 @@ void get_timer_map(struct kvm_vcpu *vcpu, struct timer=
_map *map)
 		map->emul_ptimer =3D vcpu_ptimer(vcpu);
 	}
=20
+	map->direct_vtimer->direct =3D true;
+	if (map->direct_ptimer)
+		map->direct_ptimer->direct =3D true;
+
 	trace_kvm_get_timer_map(vcpu->vcpu_id, map);
 }
=20
@@ -396,7 +406,11 @@ static bool kvm_timer_should_fire(struct arch_timer_co=
ntext *timer_ctx)
=20
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	return vcpu_has_wfit_active(vcpu) && wfit_delay_ns(vcpu) =3D=3D 0;
+	struct arch_timer_context *vtimer =3D vcpu_vtimer(vcpu);
+	struct arch_timer_context *ptimer =3D vcpu_ptimer(vcpu);
+
+	return kvm_timer_should_fire(vtimer) || kvm_timer_should_fire(ptimer) ||
+	       (vcpu_has_wfit_active(vcpu) && wfit_delay_ns(vcpu) =3D=3D 0);
 }
=20
 /*
@@ -447,6 +461,10 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu=
, bool new_level,
 	if (userspace_irqchip(vcpu->kvm))
 		return;
=20
+	/* Skip injecting on GICv5 for directly injected (DVI'd) timers */
+	if (vgic_is_v5(vcpu->kvm) && timer_ctx->direct)
+		return;
+
 	kvm_vgic_inject_irq(vcpu->kvm, vcpu,
 			    timer_irq(timer_ctx),
 			    timer_ctx->irq.level,
@@ -657,6 +675,24 @@ static inline void set_timer_irq_phys_active(struct ar=
ch_timer_context *ctx, boo
 	WARN_ON(r);
 }
=20
+/*
+ * On GICv5 we use DVI for the arch timer PPIs. This is restored later
+ * on as part of vgic_load. Therefore, in order to avoid the guest's
+ * interrupt making it to the host we mask it before entering the
+ * guest and unmask it again when we return.
+ */
+static inline void set_timer_irq_phys_masked(struct arch_timer_context *ct=
x, bool masked)
+{
+	if (masked) {
+		disable_percpu_irq(ctx->host_timer_irq);
+	} else {
+		if (ctx->host_timer_irq =3D=3D host_vtimer_irq)
+			enable_percpu_irq(ctx->host_timer_irq, host_vtimer_irq_flags);
+		else
+			enable_percpu_irq(ctx->host_timer_irq, host_ptimer_irq_flags);
+	}
+}
+
 static void kvm_timer_vcpu_load_gic(struct arch_timer_context *ctx)
 {
 	struct kvm_vcpu *vcpu =3D timer_context_to_vcpu(ctx);
@@ -675,7 +711,10 @@ static void kvm_timer_vcpu_load_gic(struct arch_timer_=
context *ctx)
=20
 	phys_active |=3D ctx->irq.level;
=20
-	set_timer_irq_phys_active(ctx, phys_active);
+	if (!vgic_is_v5(vcpu->kvm))
+		set_timer_irq_phys_active(ctx, phys_active);
+	else
+		set_timer_irq_phys_masked(ctx, true);
 }
=20
 static void kvm_timer_vcpu_load_nogic(struct kvm_vcpu *vcpu)
@@ -719,10 +758,14 @@ static void kvm_timer_vcpu_load_nested_switch(struct =
kvm_vcpu *vcpu,
 					      struct timer_map *map)
 {
 	int hw, ret;
+	struct irq_ops *ops;
=20
 	if (!irqchip_in_kernel(vcpu->kvm))
 		return;
=20
+	ops =3D vgic_is_v5(vcpu->kvm) ? &arch_timer_irq_ops_vgic_v5 :
+				      &arch_timer_irq_ops;
+
 	/*
 	 * We only ever unmap the vtimer irq on a VHE system that runs nested
 	 * virtualization, in which case we have both a valid emul_vtimer,
@@ -741,12 +784,12 @@ static void kvm_timer_vcpu_load_nested_switch(struct =
kvm_vcpu *vcpu,
 		ret =3D kvm_vgic_map_phys_irq(vcpu,
 					    map->direct_vtimer->host_timer_irq,
 					    timer_irq(map->direct_vtimer),
-					    &arch_timer_irq_ops);
+					    ops);
 		WARN_ON_ONCE(ret);
 		ret =3D kvm_vgic_map_phys_irq(vcpu,
 					    map->direct_ptimer->host_timer_irq,
 					    timer_irq(map->direct_ptimer),
-					    &arch_timer_irq_ops);
+					    ops);
 		WARN_ON_ONCE(ret);
 	}
 }
@@ -864,7 +907,8 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 	get_timer_map(vcpu, &map);
=20
 	if (static_branch_likely(&has_gic_active_state)) {
-		if (vcpu_has_nv(vcpu))
+		/* We don't do NV on GICv5, yet */
+		if (vcpu_has_nv(vcpu) && !vgic_is_v5(vcpu->kvm))
 			kvm_timer_vcpu_load_nested_switch(vcpu, &map);
=20
 		kvm_timer_vcpu_load_gic(map.direct_vtimer);
@@ -934,6 +978,14 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
=20
 	if (kvm_vcpu_is_blocking(vcpu))
 		kvm_timer_blocking(vcpu);
+
+	/* Unmask again on GICV5 */
+	if (vgic_is_v5(vcpu->kvm)) {
+		set_timer_irq_phys_masked(map.direct_vtimer, false);
+
+		if (map.direct_ptimer)
+			set_timer_irq_phys_masked(map.direct_ptimer, false);
+	}
 }
=20
 void kvm_timer_sync_nested(struct kvm_vcpu *vcpu)
@@ -1092,10 +1144,19 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 		      HRTIMER_MODE_ABS_HARD);
 }
=20
+/*
+ * This is always called during kvm_arch_init_vm, but will also be
+ * called from kvm_vgic_create if we have a vGICv5.
+ */
 void kvm_timer_init_vm(struct kvm *kvm)
 {
+	/*
+	 * Set up the default PPIs - note that we adjust them based on
+	 * the model of the GIC as GICv5 uses a different way to
+	 * describing interrupts.
+	 */
 	for (int i =3D 0; i < NR_KVM_TIMERS; i++)
-		kvm->arch.timer_data.ppi[i] =3D default_ppi[i];
+		kvm->arch.timer_data.ppi[i] =3D get_vgic_ppi(kvm, default_ppi[i]);
 }
=20
 void kvm_timer_cpu_up(void)
@@ -1347,6 +1408,7 @@ static int kvm_irq_init(struct arch_timer_kvm_info *i=
nfo)
 		}
=20
 		arch_timer_irq_ops.flags |=3D VGIC_IRQ_SW_RESAMPLE;
+		arch_timer_irq_ops_vgic_v5.flags |=3D VGIC_IRQ_SW_RESAMPLE;
 		WARN_ON(irq_domain_push_irq(domain, host_vtimer_irq,
 					    (void *)TIMER_VTIMER));
 	}
@@ -1497,10 +1559,13 @@ static bool timer_irqs_are_valid(struct kvm_vcpu *v=
cpu)
 			break;
=20
 		/*
-		 * We know by construction that we only have PPIs, so
-		 * all values are less than 32.
+		 * We know by construction that we only have PPIs, so all values
+		 * are less than 32 for non-GICv5 VGICs. On GICv5, they are
+		 * architecturally defined to be under 32 too. However, we mask
+		 * off most of the bits as we might be presented with a GICv5
+		 * style PPI where the type is encoded in the top-bits.
 		 */
-		ppis |=3D BIT(irq);
+		ppis |=3D BIT(irq & 0x1f);
 	}
=20
 	valid =3D hweight32(ppis) =3D=3D nr_timers(vcpu);
@@ -1538,6 +1603,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer =3D vcpu_timer(vcpu);
 	struct timer_map map;
+	struct irq_ops *ops;
 	int ret;
=20
 	if (timer->enabled)
@@ -1556,22 +1622,20 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 	}
=20
+	ops =3D vgic_is_v5(vcpu->kvm) ? &arch_timer_irq_ops_vgic_v5 :
+				      &arch_timer_irq_ops;
+
 	get_timer_map(vcpu, &map);
=20
-	ret =3D kvm_vgic_map_phys_irq(vcpu,
-				    map.direct_vtimer->host_timer_irq,
-				    timer_irq(map.direct_vtimer),
-				    &arch_timer_irq_ops);
+	ret =3D kvm_vgic_map_phys_irq(vcpu, map.direct_vtimer->host_timer_irq,
+				    timer_irq(map.direct_vtimer), ops);
 	if (ret)
 		return ret;
=20
-	if (map.direct_ptimer) {
+	if (map.direct_ptimer)
 		ret =3D kvm_vgic_map_phys_irq(vcpu,
 					    map.direct_ptimer->host_timer_irq,
-					    timer_irq(map.direct_ptimer),
-					    &arch_timer_irq_ops);
-	}
-
+					    timer_irq(map.direct_ptimer), ops);
 	if (ret)
 		return ret;
=20
@@ -1601,12 +1665,11 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, s=
truct kvm_device_attr *attr)
 	if (!(irq_is_ppi(vcpu->kvm, irq)))
 		return -EINVAL;
=20
-	mutex_lock(&vcpu->kvm->arch.config_lock);
+	guard(mutex)(&vcpu->kvm->arch.config_lock);
=20
 	if (test_bit(KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE,
 		     &vcpu->kvm->arch.flags)) {
-		ret =3D -EBUSY;
-		goto out;
+		return -EBUSY;
 	}
=20
 	switch (attr->attr) {
@@ -1623,10 +1686,16 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, s=
truct kvm_device_attr *attr)
 		idx =3D TIMER_HPTIMER;
 		break;
 	default:
-		ret =3D -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
=20
+	/*
+	 * The PPIs for the Arch Timers are architecturally defined for
+	 * GICv5. Reject anything that changes them from the specified value.
+	 */
+	if (vgic_is_v5(vcpu->kvm) && vcpu->kvm->arch.timer_data.ppi[idx] !=3D irq=
)
+		return -EINVAL;
+
 	/*
 	 * We cannot validate the IRQ unicity before we run, so take it at
 	 * face value. The verdict will be given on first vcpu run, for each
@@ -1634,8 +1703,6 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, str=
uct kvm_device_attr *attr)
 	 */
 	vcpu->kvm->arch.timer_data.ppi[idx] =3D irq;
=20
-out:
-	mutex_unlock(&vcpu->kvm->arch.config_lock);
 	return ret;
 }
=20
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index cad4e217a9f30..595fb5ef40164 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -177,6 +177,15 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		pfr1 |=3D SYS_FIELD_PREP_ENUM(ID_PFR1_EL1, GIC, GICv3);
 	} else {
 		aa64pfr2 |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR2_EL1, GCIE, IMP);
+
+		/*
+		 * We now know that we have a GICv5. The Arch Timer PPI
+		 * interrupts may have been initialised at this stage, but will
+		 * have done so assuming that we have an older GIC, meaning that
+		 * the IntIDs won't be correct. We init them again, and this
+		 * time they will be correct.
+		 */
+		kvm_timer_init_vm(kvm);
 	}
=20
 	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1, aa64pfr0);
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index c813f439ac9d2..f3d2e2088606b 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -218,8 +218,8 @@ static u32 vgic_v5_get_effective_priority_mask(struct k=
vm_vcpu *vcpu)
 	return min(highest_ap, priority_mask + 1);
 }
=20
-static bool vgic_v5_ppi_set_pending_state(struct kvm_vcpu *vcpu,
-					  struct vgic_irq *irq)
+bool vgic_v5_ppi_set_pending_state(struct kvm_vcpu *vcpu,
+				   struct vgic_irq *irq)
 {
 	struct vgic_v5_cpu_if *cpu_if;
 	const u32 id =3D FIELD_GET(GICV5_HWIRQ_ID, irq->intid);
@@ -250,8 +250,8 @@ static bool vgic_v5_ppi_set_pending_state(struct kvm_vc=
pu *vcpu,
  * need the PPIs to be queued on a per-VCPU AP list. Therefore, sanity che=
ck the
  * state, unlock, and return.
  */
-static bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq =
*irq,
-					 unsigned long flags)
+bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
+				  unsigned long flags)
 	__releases(&irq->irq_lock)
 {
 	struct kvm_vcpu *vcpu;
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 7310841f45121..a7754e0a2ef41 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -10,6 +10,8 @@
 #include <linux/clocksource.h>
 #include <linux/hrtimer.h>
=20
+#include <linux/irqchip/arm-gic-v5.h>
+
 enum kvm_arch_timers {
 	TIMER_PTIMER,
 	TIMER_VTIMER,
@@ -47,7 +49,7 @@ struct arch_timer_vm_data {
 	u64	poffset;
=20
 	/* The PPI for each timer, global to the VM */
-	u8	ppi[NR_KVM_TIMERS];
+	u32	ppi[NR_KVM_TIMERS];
 };
=20
 struct arch_timer_context {
@@ -74,6 +76,9 @@ struct arch_timer_context {
=20
 	/* Duplicated state from arch_timer.c for convenience */
 	u32				host_timer_irq;
+
+	/* Is this a direct timer? */
+	bool				direct;
 };
=20
 struct timer_map {
@@ -130,6 +135,10 @@ void kvm_timer_init_vhe(void);
 #define timer_vm_data(ctx)		(&(timer_context_to_vcpu(ctx)->kvm->arch.timer=
_data))
 #define timer_irq(ctx)			(timer_vm_data(ctx)->ppi[arch_timer_ctx_index(ctx=
)])
=20
+#define get_vgic_ppi(k, i) (((k)->arch.vgic.vgic_model !=3D KVM_DEV_TYPE_A=
RM_VGIC_V5) ? \
+			    (i) : (FIELD_PREP(GICV5_HWIRQ_ID, i) |	\
+				   FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI)))
+
 u64 kvm_arm_timer_read_sysreg(struct kvm_vcpu *vcpu,
 			      enum kvm_arch_timers tmr,
 			      enum kvm_arch_timer_regs treg);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 96cc222204960..b705b9e04ad0b 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -595,6 +595,10 @@ void vgic_v4_commit(struct kvm_vcpu *vcpu);
 int vgic_v4_put(struct kvm_vcpu *vcpu);
=20
 int vgic_v5_finalize_ppi_state(struct kvm *kvm);
+bool vgic_v5_ppi_set_pending_state(struct kvm_vcpu *vcpu,
+				   struct vgic_irq *irq);
+bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
+				  unsigned long flags);
=20
 bool vgic_state_is_nested(struct kvm_vcpu *vcpu);
=20
--=20
2.34.1

