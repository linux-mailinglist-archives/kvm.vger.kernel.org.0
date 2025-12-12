Return-Path: <kvm+bounces-65861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 07C73CB91D7
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:27:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E2D1C30E7F81
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E545032549B;
	Fri, 12 Dec 2025 15:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iMxIsHVB";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iMxIsHVB"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012038.outbound.protection.outlook.com [52.101.66.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570A6321F5F
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.38
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553036; cv=fail; b=XXx/i3FMEC9Qy3gkpLuvDUCM+w2iRLMiIT0scwWajuJZ8VykP7KJbjlMODQrrLlEWHq6V+g6zRnaNdB1fa2e96XOztKWJH0YDK/kJYCTFj20JPJ5JiXN9DZL/1MJ/sfX9oSN3TAE82cLw1ObhG7ElXel/sqLi0VZeQn4Fo71pCw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553036; c=relaxed/simple;
	bh=WKlyZmdzm5xLjmaq13QucBkn42hbAur++c2tQm1F14A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=V0gBpoXngE2xThu4iq3g9eJozGFo6VTRJIX+B0M67wfIj45oqx4X4ynfqMNDEHXwrQgGTrGEKVyenyMtlcCVulW9fInz3QDMe5t/7ELPZnehKN8/EGqkUun1IhsbA9wCVHt00EZFxk4JIm5zFYDJR+url4WZQJRPPw3lu3R155c=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iMxIsHVB; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iMxIsHVB; arc=fail smtp.client-ip=52.101.66.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=FwP8JVsScNuwfYN/rU8WNHJzbLmc3mJnX+z3mbf0NOBRNKBE2NaUQay2PMuOv9gZ8GgNJwAcKNFpP65SwJmSC+pLJ/zbY07eVyfLDhJ8MnJLEnczpzzyLTEjOw7EFvAI6jAsPLiXVR+VEuQmFnKRWWqN6zAmzEEtfrikvEckJXNvs18meOZig7HhKIef9kJJaaQ6gr7b+lH4pfxSQQSN118bW90iDAeT8vAA/Mf8rD5CJflyW/C2+Jbw6oYTXeE70Lt1deHK4jVvyyuW1tdHK+sypYuq/EwGsrePDYUKog88EYw5+8/nSfWwljJr5WsxTaxqqTbtSaFdzVqVQNVVCA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MvhxeB90XV+hIe5UF5vVpE1iscIYB7Zt4kgCavwPku8=;
 b=gx7XudOSCJG7us9229BCckhSdKhlGYHOiqG06hdS0Cl+L5SDR/2gEkUzhIAbaw2PMitE+mj3sqcuk/Irm7kAYxzeIEanVxNMhJOXX2lkzC1S8J4Y98gZFO18pWmXlHWpGQ8OrjiEgKi6vcdpE6p3ZfByyPbl9NbpODHv+74gNvUydAy3mpSMUJ1kfy3kBglKPvznB4GBux/gwurP7WNcEmzYxgpKL7Pr0/j/NGBEqppYwgvkxrJBONEnPImiYMka5mLFxNjP2v7t4oGG5WRrX/ZjJZ4MYrKSGurjq6JhZ+YiL1mXKCn0JZbeVH1yfV2gm7GHKSb0a9OViXGqnuQnrQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvhxeB90XV+hIe5UF5vVpE1iscIYB7Zt4kgCavwPku8=;
 b=iMxIsHVB8PNiGNipARrmyCpuFHs2ccPhOWfHhszPGusWMbQ7lXX8pgZHVlm2Y0J0slaiLH4Us2XVYw5rYvguQCwGuWb10/E1TQFrSa3J5rgyfKJHeX0kdtz/aEV0An4rY7UgYXcanUNqq5NcH5Kf/iZxDJmG1l0ibTktcA8id4M=
Received: from DUZPR01CA0287.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b7::29) by GV1PR08MB8215.eurprd08.prod.outlook.com
 (2603:10a6:150:5e::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Fri, 12 Dec
 2025 15:23:42 +0000
Received: from DB1PEPF000509ED.eurprd03.prod.outlook.com
 (2603:10a6:10:4b7:cafe::e2) by DUZPR01CA0287.outlook.office365.com
 (2603:10a6:10:4b7::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.10 via Frontend Transport; Fri,
 12 Dec 2025 15:23:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509ED.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.8
 via Frontend Transport; Fri, 12 Dec 2025 15:23:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LPlE7Js7R4IQNfvqRiBSwHxdwoBxrV2r3Qw5G2So7GjX5HoiYAjG4Dr0NYK3IrT48vHSeJ194cZB9215voJxebf4YMZJWWPTJ6KoBBZbsBR7dnpjSavmGoP3yb7zqsg+UJDNMMDItKCVXWWOVdsXwcypmutx8vz/cKeX+1rnCsUa/njzsJ4cCwosW2jSQN4epTmki5vat3wFgJkrZ4x7xFq6ZPqVyUHAnsSxlhB3j8uHClRCwCngmbWsr1RyaoaYdmfwklEfvIiTGXqRjFY/3Iv3G/5XYwUGrL5nvbzB+9NKYO5QzFrHBV9GjQbKM3WybnDG76UqltF9T67usTM66Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MvhxeB90XV+hIe5UF5vVpE1iscIYB7Zt4kgCavwPku8=;
 b=ffZFnpkN6VYn5tftcj1ikJkK3M4ZSkVrSkrO1xzOnQWTFbLw3fAkc1d98ceutcKLAbZabRX7OGCqWu1VPTK2JFJA/Qmfs0S6QbL6Wu88um8ZYFgMMSdlcgQNSFZtDzcgYBv4T8fHHyMldKeaK4JWJjzBMJV+7NidwgO616mhZiw2lFSDm1EAPqxNwqvYJtjfyyKaQhHIGzLw3BN3ZP5je7sUDz5VrlggFbKX5jj72ku2h3Z7roYwNj7AEstG8IWIyMM3GraKY0VWPw64cwspWNTGRybVCAvrp+zTLSL9++scy/ln3UhWvCzOIjubQMp65eP0IbGP+ElmPC1u4QEATA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvhxeB90XV+hIe5UF5vVpE1iscIYB7Zt4kgCavwPku8=;
 b=iMxIsHVB8PNiGNipARrmyCpuFHs2ccPhOWfHhszPGusWMbQ7lXX8pgZHVlm2Y0J0slaiLH4Us2XVYw5rYvguQCwGuWb10/E1TQFrSa3J5rgyfKJHeX0kdtz/aEV0An4rY7UgYXcanUNqq5NcH5Kf/iZxDJmG1l0ibTktcA8id4M=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PA6PR08MB10565.eurprd08.prod.outlook.com (2603:10a6:102:3ca::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 15:22:38 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:38 +0000
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
Subject: [PATCH 09/32] KVM: arm64: gic-v5: Compute GICv5 FGTs on vcpu load
Thread-Topic: [PATCH 09/32] KVM: arm64: gic-v5: Compute GICv5 FGTs on vcpu
 load
Thread-Index: AQHca3smCJPVvLo5RUaFm1cfrYqWoA==
Date: Fri, 12 Dec 2025 15:22:38 +0000
Message-ID: <20251212152215.675767-10-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|PA6PR08MB10565:EE_|DB1PEPF000509ED:EE_|GV1PR08MB8215:EE_
X-MS-Office365-Filtering-Correlation-Id: 36c3254b-627d-4904-468a-08de39926e3f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?DHztK97PQGQN/naLmyIxXGSwRiax20huSUYHplcJI6Er19B93LW1RmyHjo?=
 =?iso-8859-1?Q?kfss10SSzD3hDH1h1bh0Ok+hXVztDNE+6PH0Vcvzle0HHVVxiBUGtizu2u?=
 =?iso-8859-1?Q?AIM2brH4AvKIBIvhd5k7ZzrcZbEomFU0kDml6oroiILR9KuEQSrCly53bM?=
 =?iso-8859-1?Q?X3T/h8zRq15sx4omw1vkwQH9W6MVepO8/tjpamJ8aRfDtMSVfxnWqaBdJ+?=
 =?iso-8859-1?Q?iBdWLwz7Nb4kvcnK30HvhmN1pZNwWwYPAgN/VmL0MXqI010Evg+UnTUyfV?=
 =?iso-8859-1?Q?HmKooLelI1KCNxbMZhvAPRgHdPvd6R7JW1/gbHF+a/kvSj4/iyW8Zeo5P0?=
 =?iso-8859-1?Q?SbApZO3S4k2sHy0BPWN/FnybVkAFZWHnCOTcrO8rqsQWMwtRkGBhyXncZr?=
 =?iso-8859-1?Q?+xR+7DfGH4htUx906r7gQjc30x7siH/FOZBqDi+peCVppD6W2jwaTNQWj4?=
 =?iso-8859-1?Q?Q4KaIv3ZHfuClJJeqRsvns6bO1b8DMC6roi+lRtFU7IRxba2YJrPZRnWrm?=
 =?iso-8859-1?Q?9th4RZfFE/R3cgIIC5QIM2vCTAcGWWK7eaA67sR1h/4jz2G17+Bu2/4dTi?=
 =?iso-8859-1?Q?exfBKdWp1MfKkhyrUJxrYYyQKwOXThYr9+tsRrAXsdUHQ/5bjL93bkVqNr?=
 =?iso-8859-1?Q?GTnfA7d7pY07P3e0OJyw5JKtAR8B9/cyDLcG+A8wc/H66CCihcnw4lQnv5?=
 =?iso-8859-1?Q?c8mlS3AXg5w5PT3oL+27FWHH1iyz3Dn8fcFXKcFKDn1wDYmbU1gexxTQPD?=
 =?iso-8859-1?Q?lqZfgXQcizPyIq/BkOrUtToLlIY/1tDQ7+qb/V+KbFkc+ztQ5xELdoHnao?=
 =?iso-8859-1?Q?wnMOnOkLVgywmCW7MVahzGpxadIx7gBGyYvdqxWvFV1M6AH0R9elLlug7Q?=
 =?iso-8859-1?Q?U8pYcdP8M+J2ELt3HEZ05Kpq4WYVGsYsGdTkHDnoTCr3D17yYonfYsmgt8?=
 =?iso-8859-1?Q?8KdVCGU38sTfGGbqa/p+F4Ia1OKSrJnp5/yqT/kYXFqHMoPBpVKecEKzyV?=
 =?iso-8859-1?Q?HYmzO20PjNKwhu2DSiyi92LpxOATUnrGEjj6MUs03x0nr2im0w3uHni+iW?=
 =?iso-8859-1?Q?E6fYdWCo2BsoDphlNWABfkWcSrgR2KyAM9JfpTKhRri3lU1Hi/bmz/Mq3E?=
 =?iso-8859-1?Q?Yic5UblbxlY9+6z4g8bWA01jEP8fIezpk8o4/N8S6MV//KRamxU/b/SCrP?=
 =?iso-8859-1?Q?ZXf3z6w8t6fsVbcYa/3K2gVR6ITqTtMF0KODrBAnTbZGVAqNC2gYYHIRWj?=
 =?iso-8859-1?Q?OCCsy92Abs8dYsZloiVpYTuO69RFT7KPw3E9hq1TtDEhiycT9RdxJxJjuu?=
 =?iso-8859-1?Q?KyEYEp+qhjMMbFNK0/5nNYuvIj/Xx5m5qTw5KIjZBm65t65SJRsyrGmwQf?=
 =?iso-8859-1?Q?QKPpbJ/iKXs6Xi6pBKsigC/YjEONsU4eVjwhka+JRKxNj3/0orcEMUekDl?=
 =?iso-8859-1?Q?AuBm+TeXj34kb0V1QIUJBFXWh9Xtn8wxpafZJ0H8RmgY3yJ0003lZOec8c?=
 =?iso-8859-1?Q?2JiG0b9OB/xTo7mvDsbDipJJbj+JX7cQtVVhzlWAjhbUuwysql7Smmsp2T?=
 =?iso-8859-1?Q?yQLdpx/fD47lpgdmq7XatEXkmpLi?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10565
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509ED.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	adee4feb-9b1f-416d-2ecd-08de399248e9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|14060799003|36860700013|35042699022|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?P4V3FLBzrkLNKvkDBES5fvyf93qtRusbxbbkLM/l7a+fg8CYS2SRnE0SYw?=
 =?iso-8859-1?Q?WmYPeJpxjfzyj02VMXlZ2bl5sHmdIw1EQJllT/iHECUSBTM1yUGgMNlLqL?=
 =?iso-8859-1?Q?/7cVwXNuowlEsEJIKzwdG0jO3yBGOCsgjAt7/ogn/MWWQDyfMg8ldXEIVY?=
 =?iso-8859-1?Q?b/M0UkbMQPANAHbgVXUN67lo0vRqxeyn+Z/SP7xcXaMYDx+Nv9pH6+5qlP?=
 =?iso-8859-1?Q?7bcYQwksI+ac6RXojB5RSikMkyO5yG2fKqKbaVlgOQFXKgxSoVXPJZgf+p?=
 =?iso-8859-1?Q?sFJb3AOm1DtzrL5OL/v+rnK0zp95R+8n0HoRcHrO7851IvYiaKzjl6Gy4V?=
 =?iso-8859-1?Q?6e2zOMtysT3VRb/bUp+t/ECcT2AU4gNssyifGiHR0LZUgN7kfxBlA5QuWO?=
 =?iso-8859-1?Q?G/MEQ0f+C3LhPcSrtS+epNi5XMr3XV6ZlsdaX+14ADTJ4SNnfVU9/D7JHN?=
 =?iso-8859-1?Q?2FkKHsH+DlDyedboUCwhL34MG2ICB5Y9pGbOj2NdO7Ja0qKSRUJLI6X/8e?=
 =?iso-8859-1?Q?9iEbfCCqKFmuqpH/IL/gSb+9cR/w380HD5F6S7aL1MU0g3q3uNXqvuv1FY?=
 =?iso-8859-1?Q?LjimpMd3kKxAgGCWukh9UctDwK2/FKr9+ZHLUcxqCQwdZcI5Z/hGz2VXT2?=
 =?iso-8859-1?Q?CJdWXUsFsAbHW8owOUaECP68UoIij6vrwin60bVuhOGf3KRQADEkJa0f0J?=
 =?iso-8859-1?Q?1ROSXsEPqVH9YnGVP9wXIfUCc1agsdlXJhxVCTXkLsXt8x6C45hBGGvZre?=
 =?iso-8859-1?Q?sYoWPkBygsR0qvPVQ9aCaAl3IZRa6MP2PA3C7qYJp8c/SPIajrAjWx6ceT?=
 =?iso-8859-1?Q?4rAV5xzRiL4eaMKXzQ45IbMsB0MRL4OapA1MdL5HZYAjVJKSCKc+djrf0o?=
 =?iso-8859-1?Q?HvxfpuY3k5xP1ZJUMZKZExCQOjfkC5kvKYcsD41H6YJDnX+4VBN01IWyXX?=
 =?iso-8859-1?Q?YUHoj3a0czgLRMEOK2gO54cYxQ7BiyXBP20qQXHnQqnSuyEzx2CcUDS5PV?=
 =?iso-8859-1?Q?yAbCWPnyYmIqVoPnTyWxoA3/5i3enuj9z05AOYNF+G/idoB3eOa0o/kK1A?=
 =?iso-8859-1?Q?sU0jpSKMoezmKQXG5T3KflHkJvUY9++s/I+TtrFTjTytI88h841Pp2a6x6?=
 =?iso-8859-1?Q?DjzcsAFyLXce6SQn8RnbxfywXC053NqC/GJc+Jlgr8gNrPLXcuBUPimU2U?=
 =?iso-8859-1?Q?ASDbwl/DSG/3DIP3RrYtS2yHNVDY5Yp/A+jO0kfH7nPW/p+Qp9DtWyam50?=
 =?iso-8859-1?Q?c1O6Epr6fTZVwGLrhKIP0DJPbCeZn08R7PUWMXg+bfoax3/iZVaG7TwlXH?=
 =?iso-8859-1?Q?E+OK+QTC2VduO/FoaGfRRT/XjhwNXREvmsizMdtR7X/0LcmMXT4yI1nDnh?=
 =?iso-8859-1?Q?oFYoGmoq2kfGm/uXKvIdIhOHBpIVlyVQlVu73Vucc76HCbC7Zaek2qcno1?=
 =?iso-8859-1?Q?zqxTX6d0abDhPuSqkeHD2i2u5jvSFF21tsLNpXGFTXAzPOSCNLYU5BlJa9?=
 =?iso-8859-1?Q?WBbMTlSnbsofEh+luA8mwPN1bk5VYfP6OOeQHtpepzzuXFjU4vAeHDnxvX?=
 =?iso-8859-1?Q?BaNY8Z8rY4dr+aN1ZHnWwtDZY6Sj8lQ7zGBDGnLy+gY0h8S89XOir86mv5?=
 =?iso-8859-1?Q?XK8sCXCFIwgdw=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(14060799003)(36860700013)(35042699022)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:40.9712
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 36c3254b-627d-4904-468a-08de39926e3f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509ED.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8215

Extend the existing FGT infrastructure to calculate and activate any
required GICv5 traps (ICH_HFGRTR_EL2, ICH_HFGWTR_EL2, ICH_HFGITR_EL2)
before entering the guest, and restore the original ICH_HFGxTR_EL2
contents on the return path. This ensures that the host and guest
behaviour remains independent.

As of this change, none of the GICv5 instructions or register accesses
are being trapped, but this will change in subsequent commits as some
GICv5 system registers must always be trapped (ICC_IAFFIDR_EL1,
ICH_PPI_HMRx_EL1).

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_host.h       | 19 +++++
 arch/arm64/include/asm/vncr_mapping.h   |  3 +
 arch/arm64/kvm/arm.c                    |  3 +
 arch/arm64/kvm/config.c                 | 96 ++++++++++++++++++++++++-
 arch/arm64/kvm/emulate-nested.c         | 68 ++++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 27 +++++++
 arch/arm64/kvm/hyp/nvhe/switch.c        |  3 +
 arch/arm64/kvm/sys_regs.c               |  2 +
 8 files changed, 219 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h
index b552a1e03848c..0e535ef50c231 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -287,6 +287,9 @@ enum fgt_group_id {
 	HDFGRTR2_GROUP,
 	HDFGWTR2_GROUP =3D HDFGRTR2_GROUP,
 	HFGITR2_GROUP,
+	ICH_HFGRTR_GROUP,
+	ICH_HFGWTR_GROUP =3D ICH_HFGRTR_GROUP,
+	ICH_HFGITR_GROUP,
=20
 	/* Must be last */
 	__NR_FGT_GROUP_IDS__
@@ -623,6 +626,10 @@ enum vcpu_sysreg {
 	VNCR(ICH_HCR_EL2),
 	VNCR(ICH_VMCR_EL2),
=20
+	VNCR(ICH_HFGRTR_EL2),
+	VNCR(ICH_HFGWTR_EL2),
+	VNCR(ICH_HFGITR_EL2),
+
 	NR_SYS_REGS	/* Nothing after this line! */
 };
=20
@@ -652,6 +659,9 @@ extern struct fgt_masks hfgwtr2_masks;
 extern struct fgt_masks hfgitr2_masks;
 extern struct fgt_masks hdfgrtr2_masks;
 extern struct fgt_masks hdfgwtr2_masks;
+extern struct fgt_masks ich_hfgrtr_masks;
+extern struct fgt_masks ich_hfgwtr_masks;
+extern struct fgt_masks ich_hfgitr_masks;
=20
 extern struct fgt_masks kvm_nvhe_sym(hfgrtr_masks);
 extern struct fgt_masks kvm_nvhe_sym(hfgwtr_masks);
@@ -664,6 +674,9 @@ extern struct fgt_masks kvm_nvhe_sym(hfgwtr2_masks);
 extern struct fgt_masks kvm_nvhe_sym(hfgitr2_masks);
 extern struct fgt_masks kvm_nvhe_sym(hdfgrtr2_masks);
 extern struct fgt_masks kvm_nvhe_sym(hdfgwtr2_masks);
+extern struct fgt_masks kvm_nvhe_sym(ich_hfgrtr_masks);
+extern struct fgt_masks kvm_nvhe_sym(ich_hfgwtr_masks);
+extern struct fgt_masks kvm_nvhe_sym(ich_hfgitr_masks);
=20
 struct kvm_cpu_context {
 	struct user_pt_regs regs;	/* sp =3D sp_el0 */
@@ -1632,6 +1645,11 @@ static __always_inline enum fgt_group_id __fgt_reg_t=
o_group_id(enum vcpu_sysreg
 	case HDFGRTR2_EL2:
 	case HDFGWTR2_EL2:
 		return HDFGRTR2_GROUP;
+	case ICH_HFGRTR_EL2:
+	case ICH_HFGWTR_EL2:
+		return ICH_HFGRTR_GROUP;
+	case ICH_HFGITR_EL2:
+		return ICH_HFGITR_GROUP;
 	default:
 		BUILD_BUG_ON(1);
 	}
@@ -1646,6 +1664,7 @@ static __always_inline enum fgt_group_id __fgt_reg_to=
_group_id(enum vcpu_sysreg
 		case HDFGWTR_EL2:					\
 		case HFGWTR2_EL2:					\
 		case HDFGWTR2_EL2:					\
+		case ICH_HFGWTR_EL2:					\
 			p =3D &(vcpu)->arch.fgt[id].w;			\
 			break;						\
 		default:						\
diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm=
/vncr_mapping.h
index c2485a862e690..14366d35ce82f 100644
--- a/arch/arm64/include/asm/vncr_mapping.h
+++ b/arch/arm64/include/asm/vncr_mapping.h
@@ -108,5 +108,8 @@
 #define VNCR_MPAMVPM5_EL2       0x968
 #define VNCR_MPAMVPM6_EL2       0x970
 #define VNCR_MPAMVPM7_EL2       0x978
+#define VNCR_ICH_HFGITR_EL2	0xB10
+#define VNCR_ICH_HFGRTR_EL2	0xB18
+#define VNCR_ICH_HFGWTR_EL2	0xB20
=20
 #endif /* __ARM64_VNCR_MAPPING_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4f80da0c0d1de..b7cf9d86aabb7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2474,6 +2474,9 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(hfgitr2_masks) =3D hfgitr2_masks;
 	kvm_nvhe_sym(hdfgrtr2_masks)=3D hdfgrtr2_masks;
 	kvm_nvhe_sym(hdfgwtr2_masks)=3D hdfgwtr2_masks;
+	kvm_nvhe_sym(ich_hfgrtr_masks) =3D ich_hfgrtr_masks;
+	kvm_nvhe_sym(ich_hfgwtr_masks) =3D ich_hfgwtr_masks;
+	kvm_nvhe_sym(ich_hfgitr_masks) =3D ich_hfgitr_masks;
=20
 	/*
 	 * Flush entire BSS since part of its data containing init symbols is rea=
d
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 3845b188551b6..57ef67f718113 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -219,6 +219,7 @@ struct reg_feat_map_desc {
 #define FEAT_FGT2		ID_AA64MMFR0_EL1, FGT, FGT2
 #define FEAT_MTPMU		ID_AA64DFR0_EL1, MTPMU, IMP
 #define FEAT_HCX		ID_AA64MMFR1_EL1, HCX, IMP
+#define FEAT_GCIE		ID_AA64PFR2_EL1, GCIE, IMP
=20
 static bool not_feat_aa64el3(struct kvm *kvm)
 {
@@ -1168,6 +1169,58 @@ static const struct reg_bits_to_feat_map mdcr_el2_fe=
at_map[] =3D {
 static const DECLARE_FEAT_MAP(mdcr_el2_desc, MDCR_EL2,
 			      mdcr_el2_feat_map, FEAT_AA64EL2);
=20
+static const struct reg_bits_to_feat_map ich_hfgrtr_feat_map[] =3D {
+	NEEDS_FEAT(ICH_HFGRTR_EL2_ICC_APR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_IDRn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_CR0_EL1 |
+		   ICH_HFGRTR_EL2_ICC_HPPIR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PCR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_ICSR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_IAFFIDR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_HMRn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_ENABLERn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_PENDRn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_PRIORITYRn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_ACTIVERn_EL1,
+		   FEAT_GCIE),
+};
+
+static const DECLARE_FEAT_MAP_FGT(ich_hfgrtr_desc, ich_hfgrtr_masks,
+				  ich_hfgrtr_feat_map, FEAT_GCIE);
+
+static const struct reg_bits_to_feat_map ich_hfgwtr_feat_map[] =3D {
+	NEEDS_FEAT(ICH_HFGWTR_EL2_ICC_APR_EL1 |
+		   ICH_HFGWTR_EL2_ICC_CR0_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PCR_EL1 |
+		   ICH_HFGWTR_EL2_ICC_ICSR_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PPI_ENABLERn_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PPI_PENDRn_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PPI_PRIORITYRn_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PPI_ACTIVERn_EL1,
+		   FEAT_GCIE),
+};
+
+static const DECLARE_FEAT_MAP_FGT(ich_hfgwtr_desc, ich_hfgwtr_masks,
+				  ich_hfgwtr_feat_map, FEAT_GCIE);
+
+static const struct reg_bits_to_feat_map ich_hfgitr_feat_map[] =3D {
+	NEEDS_FEAT(ICH_HFGITR_EL2_GICCDEN |
+		   ICH_HFGITR_EL2_GICCDDIS |
+		   ICH_HFGITR_EL2_GICCDPRI |
+		   ICH_HFGITR_EL2_GICCDAFF |
+		   ICH_HFGITR_EL2_GICCDPEND |
+		   ICH_HFGITR_EL2_GICCDRCFG |
+		   ICH_HFGITR_EL2_GICCDHM |
+		   ICH_HFGITR_EL2_GICCDEOI |
+		   ICH_HFGITR_EL2_GICCDDI |
+		   ICH_HFGITR_EL2_GICRCDIA |
+		   ICH_HFGITR_EL2_GICRCDNMIA,
+		   FEAT_GCIE),
+};
+
+static const DECLARE_FEAT_MAP_FGT(ich_hfgitr_desc, ich_hfgitr_masks,
+				  ich_hfgitr_feat_map, FEAT_GCIE);
+
 static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
 				  int map_size, u64 resx, const char *str)
 {
@@ -1211,6 +1264,9 @@ void __init check_feature_map(void)
 	check_reg_desc(&tcr2_el2_desc);
 	check_reg_desc(&sctlr_el1_desc);
 	check_reg_desc(&mdcr_el2_desc);
+	check_reg_desc(&ich_hfgrtr_desc);
+	check_reg_desc(&ich_hfgwtr_desc);
+	check_reg_desc(&ich_hfgitr_desc);
 }
=20
 static bool idreg_feat_match(struct kvm *kvm, const struct reg_bits_to_fea=
t_map *map)
@@ -1342,6 +1398,16 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id =
fgt)
 		val |=3D compute_reg_res0_bits(kvm, &hdfgwtr2_desc,
 					     0, NEVER_FGU);
 		break;
+	case ICH_HFGRTR_GROUP:
+		val |=3D compute_reg_res0_bits(kvm, &ich_hfgrtr_desc,
+					     0, NEVER_FGU);
+		val |=3D compute_reg_res0_bits(kvm, &ich_hfgwtr_desc,
+					     0, NEVER_FGU);
+		break;
+	case ICH_HFGITR_GROUP:
+		val |=3D compute_reg_res0_bits(kvm, &ich_hfgitr_desc,
+					     0, NEVER_FGU);
+		break;
 	default:
 		BUG();
 	}
@@ -1425,6 +1491,18 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_s=
ysreg reg, u64 *res0, u64 *r
 		*res0 =3D compute_reg_res0_bits(kvm, &mdcr_el2_desc, 0, 0);
 		*res1 =3D MDCR_EL2_RES1;
 		break;
+	case ICH_HFGRTR_EL2:
+		*res0 =3D compute_reg_res0_bits(kvm, &ich_hfgrtr_desc, 0, 0);
+		*res1 =3D ICH_HFGRTR_EL2_RES1;
+		break;
+	case ICH_HFGWTR_EL2:
+		*res0 =3D compute_reg_res0_bits(kvm, &ich_hfgwtr_desc, 0, 0);
+		*res1 =3D ICH_HFGWTR_EL2_RES1;
+		break;
+	case ICH_HFGITR_EL2:
+		*res0 =3D compute_reg_res0_bits(kvm, &ich_hfgitr_desc, 0, 0);
+		*res1 =3D ICH_HFGITR_EL2_RES1;
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		*res0 =3D *res1 =3D 0;
@@ -1457,6 +1535,12 @@ static __always_inline struct fgt_masks *__fgt_reg_t=
o_masks(enum vcpu_sysreg reg
 		return &hdfgrtr2_masks;
 	case HDFGWTR2_EL2:
 		return &hdfgwtr2_masks;
+	case ICH_HFGRTR_EL2:
+		return &ich_hfgrtr_masks;
+	case ICH_HFGWTR_EL2:
+		return &ich_hfgwtr_masks;
+	case ICH_HFGITR_EL2:
+		return &ich_hfgitr_masks;
 	default:
 		BUILD_BUG_ON(1);
 	}
@@ -1501,7 +1585,7 @@ static void __compute_hdfgwtr(struct kvm_vcpu *vcpu)
 void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 {
 	if (!cpus_have_final_cap(ARM64_HAS_FGT))
-		return;
+		goto skip_feat_fgt;
=20
 	__compute_fgt(vcpu, HFGRTR_EL2);
 	__compute_hfgwtr(vcpu);
@@ -1511,11 +1595,19 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 	__compute_fgt(vcpu, HAFGRTR_EL2);
=20
 	if (!cpus_have_final_cap(ARM64_HAS_FGT2))
-		return;
+		goto skip_feat_fgt;
=20
 	__compute_fgt(vcpu, HFGRTR2_EL2);
 	__compute_fgt(vcpu, HFGWTR2_EL2);
 	__compute_fgt(vcpu, HFGITR2_EL2);
 	__compute_fgt(vcpu, HDFGRTR2_EL2);
 	__compute_fgt(vcpu, HDFGWTR2_EL2);
+
+skip_feat_fgt:
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
+		return;
+
+	__compute_fgt(vcpu, ICH_HFGRTR_EL2);
+	__compute_fgt(vcpu, ICH_HFGWTR_EL2);
+	__compute_fgt(vcpu, ICH_HFGITR_EL2);
 }
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-neste=
d.c
index 75d49f83342a5..de316bdf90d46 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2044,6 +2044,60 @@ static const struct encoding_to_trap_config encoding=
_to_fgt[] __initconst =3D {
 	SR_FGT(SYS_AMEVCNTR0_EL0(2),	HAFGRTR, AMEVCNTR02_EL0, 1),
 	SR_FGT(SYS_AMEVCNTR0_EL0(1),	HAFGRTR, AMEVCNTR01_EL0, 1),
 	SR_FGT(SYS_AMEVCNTR0_EL0(0),	HAFGRTR, AMEVCNTR00_EL0, 1),
+
+	/*
+	 * ICH_HFGRTR_EL2 & ICH_HFGWTR_EL2
+	 */
+	SR_FGT(SYS_ICC_APR_EL1,			ICH_HFGRTR, ICC_APR_EL1, 0),
+	SR_FGT(SYS_ICC_IDR0_EL1,		ICH_HFGRTR, ICC_IDRn_EL1, 0),
+	SR_FGT(SYS_ICC_CR0_EL1,			ICH_HFGRTR, ICC_CR0_EL1, 0),
+	SR_FGT(SYS_ICC_HPPIR_EL1,		ICH_HFGRTR, ICC_HPPIR_EL1, 0),
+	SR_FGT(SYS_ICC_PCR_EL1,			ICH_HFGRTR, ICC_PCR_EL1, 0),
+	SR_FGT(SYS_ICC_ICSR_EL1,		ICH_HFGRTR, ICC_ICSR_EL1, 0),
+	SR_FGT(SYS_ICC_IAFFIDR_EL1,		ICH_HFGRTR, ICC_IAFFIDR_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_HMR0_EL1,		ICH_HFGRTR, ICC_PPI_HMRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_HMR1_EL1,		ICH_HFGRTR, ICC_PPI_HMRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_ENABLER0_EL1,	ICH_HFGRTR, ICC_PPI_ENABLERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_ENABLER1_EL1,	ICH_HFGRTR, ICC_PPI_ENABLERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_CPENDR0_EL1,		ICH_HFGRTR, ICC_PPI_PENDRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_CPENDR1_EL1,		ICH_HFGRTR, ICC_PPI_PENDRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_SPENDR0_EL1,		ICH_HFGRTR, ICC_PPI_PENDRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_SPENDR1_EL1,		ICH_HFGRTR, ICC_PPI_PENDRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR0_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR1_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR2_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR3_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR4_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR5_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR6_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR7_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR8_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR9_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR10_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR11_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR12_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR13_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR14_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR15_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_CACTIVER0_EL1,	ICH_HFGRTR, ICC_PPI_ACTIVERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_CACTIVER1_EL1,	ICH_HFGRTR, ICC_PPI_ACTIVERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_SACTIVER0_EL1,	ICH_HFGRTR, ICC_PPI_ACTIVERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_SACTIVER1_EL1,	ICH_HFGRTR, ICC_PPI_ACTIVERn_EL1, 0),
+
+	/*
+	 * ICH_HFGITR_EL2
+	 */
+	SR_FGT(GICV5_OP_GIC_CDEN,	ICH_HFGITR, GICCDEN, 0),
+	SR_FGT(GICV5_OP_GIC_CDDIS,	ICH_HFGITR, GICCDDIS, 0),
+	SR_FGT(GICV5_OP_GIC_CDPRI,	ICH_HFGITR, GICCDPRI, 0),
+	SR_FGT(GICV5_OP_GIC_CDAFF,	ICH_HFGITR, GICCDAFF, 0),
+	SR_FGT(GICV5_OP_GIC_CDPEND,	ICH_HFGITR, GICCDPEND, 0),
+	SR_FGT(GICV5_OP_GIC_CDRCFG,	ICH_HFGITR, GICCDRCFG, 0),
+	SR_FGT(GICV5_OP_GIC_CDHM,	ICH_HFGITR, GICCDHM, 0),
+	SR_FGT(GICV5_OP_GIC_CDEOI,	ICH_HFGITR, GICCDEOI, 0),
+	SR_FGT(GICV5_OP_GIC_CDDI,	ICH_HFGITR, GICCDDI, 0),
+	SR_FGT(GICV5_OP_GICR_CDIA,	ICH_HFGITR, GICRCDIA, 0),
+	SR_FGT(GICV5_OP_GICR_CDNMIA,	ICH_HFGITR, GICRCDNMIA, 0),
 };
=20
 /*
@@ -2118,6 +2172,9 @@ FGT_MASKS(hfgwtr2_masks, HFGWTR2_EL2);
 FGT_MASKS(hfgitr2_masks, HFGITR2_EL2);
 FGT_MASKS(hdfgrtr2_masks, HDFGRTR2_EL2);
 FGT_MASKS(hdfgwtr2_masks, HDFGWTR2_EL2);
+FGT_MASKS(ich_hfgrtr_masks, ICH_HFGRTR_EL2);
+FGT_MASKS(ich_hfgwtr_masks, ICH_HFGWTR_EL2);
+FGT_MASKS(ich_hfgitr_masks, ICH_HFGITR_EL2);
=20
 static __init bool aggregate_fgt(union trap_config tc)
 {
@@ -2153,6 +2210,14 @@ static __init bool aggregate_fgt(union trap_config t=
c)
 		rmasks =3D &hfgitr2_masks;
 		wmasks =3D NULL;
 		break;
+	case ICH_HFGRTR_GROUP:
+		rmasks =3D &ich_hfgrtr_masks;
+		wmasks =3D &ich_hfgwtr_masks;
+		break;
+	case ICH_HFGITR_GROUP:
+		rmasks =3D &ich_hfgitr_masks;
+		wmasks =3D NULL;
+		break;
 	}
=20
 	rresx =3D rmasks->res0 | rmasks->res1;
@@ -2223,6 +2288,9 @@ static __init int check_all_fgt_masks(int ret)
 		&hfgitr2_masks,
 		&hdfgrtr2_masks,
 		&hdfgwtr2_masks,
+		&ich_hfgrtr_masks,
+		&ich_hfgwtr_masks,
+		&ich_hfgitr_masks,
 	};
 	int err =3D 0;
=20
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/i=
nclude/hyp/switch.h
index c5d5e5b86eaf0..14805336725f5 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -235,6 +235,18 @@ static inline void __activate_traps_hfgxtr(struct kvm_=
vcpu *vcpu)
 	__activate_fgt(hctxt, vcpu, HDFGWTR2_EL2);
 }
=20
+static inline void __activate_traps_ich_hfgxtr(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *hctxt =3D host_data_ptr(host_ctxt);
+
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
+		return;
+
+	__activate_fgt(hctxt, vcpu, ICH_HFGRTR_EL2);
+	__activate_fgt(hctxt, vcpu, ICH_HFGWTR_EL2);
+	__activate_fgt(hctxt, vcpu, ICH_HFGITR_EL2);
+}
+
 #define __deactivate_fgt(htcxt, vcpu, reg)				\
 	do {								\
 		write_sysreg_s(ctxt_sys_reg(hctxt, reg),		\
@@ -267,6 +279,19 @@ static inline void __deactivate_traps_hfgxtr(struct kv=
m_vcpu *vcpu)
 	__deactivate_fgt(hctxt, vcpu, HDFGWTR2_EL2);
 }
=20
+static inline void __deactivate_traps_ich_hfgxtr(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *hctxt =3D host_data_ptr(host_ctxt);
+
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
+		return;
+
+	__deactivate_fgt(hctxt, vcpu, ICH_HFGRTR_EL2);
+	__deactivate_fgt(hctxt, vcpu, ICH_HFGWTR_EL2);
+	__deactivate_fgt(hctxt, vcpu, ICH_HFGITR_EL2);
+
+}
+
 static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
 {
 	u64 r =3D MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
@@ -330,6 +355,7 @@ static inline void __activate_traps_common(struct kvm_v=
cpu *vcpu)
 	}
=20
 	__activate_traps_hfgxtr(vcpu);
+	__activate_traps_ich_hfgxtr(vcpu);
 	__activate_traps_mpam(vcpu);
 }
=20
@@ -347,6 +373,7 @@ static inline void __deactivate_traps_common(struct kvm=
_vcpu *vcpu)
 		write_sysreg_s(ctxt_sys_reg(hctxt, HCRX_EL2), SYS_HCRX_EL2);
=20
 	__deactivate_traps_hfgxtr(vcpu);
+	__deactivate_traps_ich_hfgxtr(vcpu);
 	__deactivate_traps_mpam();
 }
=20
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/swi=
tch.c
index d3b9ec8a7c283..c23e22ffac080 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -44,6 +44,9 @@ struct fgt_masks hfgwtr2_masks;
 struct fgt_masks hfgitr2_masks;
 struct fgt_masks hdfgrtr2_masks;
 struct fgt_masks hdfgwtr2_masks;
+struct fgt_masks ich_hfgrtr_masks;
+struct fgt_masks ich_hfgwtr_masks;
+struct fgt_masks ich_hfgitr_masks;
=20
 extern void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc)=
;
=20
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a065f8939bc8f..fbbd7b6ff6507 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5630,6 +5630,8 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 	compute_fgu(kvm, HFGRTR2_GROUP);
 	compute_fgu(kvm, HFGITR2_GROUP);
 	compute_fgu(kvm, HDFGRTR2_GROUP);
+	compute_fgu(kvm, ICH_HFGRTR_GROUP);
+	compute_fgu(kvm, ICH_HFGITR_GROUP);
=20
 	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
 out:
--=20
2.34.1

