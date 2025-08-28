Return-Path: <kvm+bounces-56083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49086B39AD0
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 13:01:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13855981748
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:01:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9748B30E0D6;
	Thu, 28 Aug 2025 11:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="P8mOxj7O";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="P8mOxj7O"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011011.outbound.protection.outlook.com [52.101.70.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7341930BBA5;
	Thu, 28 Aug 2025 11:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.11
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756378822; cv=fail; b=onrvR4kvQcIIOUWb2WfaKEsqSWnFy5kRgkPwwz2/SBCFInqcwtWvNm8pQetRccpAYgMwr7qt/hIsVoXnRuYpRbYTHSCJC4F6Fewjai/ko2k3y/3ybSAmGPz89HclNO7ZP4bRfDCQB7ZKXkzcmmc6jfFFVwo1pYKX2FF/zrrGYSM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756378822; c=relaxed/simple;
	bh=yRu2mZT/C7satUwH3gOZp8XDbknk+ys5K//iXTJ+icA=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=aw6OJKrQTdcwVIKJumNlN6zo+Lq3eQ3jC554ujobpFD9eT+xE/8qAzXCnAyvlxxc/WghEas7Ybg6UyG1V6WPAWS3cATmQaxpW3OewUXzQLmH8C5Nbdq9d5rDksVISCZifHprWfYkTM1ih/hkl0PKRqIwvIuKwL8SMbwopHMqMAk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=P8mOxj7O; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=P8mOxj7O; arc=fail smtp.client-ip=52.101.70.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=GOLtlH6IxMGSDMWZQqgvpE8CGKytiXq7PkLWWxugA8u5NsTZSnVQhBCNJ+Ew84VV2lvRjuZsDUIkSu3E+Hri0jfHSqNYeAPI3vgg9o52gWAv6FFyQwki2iiQ8ORZohdMUWOzK+Q6GcgWvHxAqEzJyLExTMhk/lmNnKSq4EegMLmTZpQFttD3sDN+ATgH0uipdlFKcFMp5jTNNJ74UPmT/QEyWLmOxXe/LUx3Bd5vVRSCxGWqzaYjywLLEQ82kqMvCojl/FwQJsoeu94eJ1KM3qpKEewBGBdX2PYvAerQE/TFEDtfw2XPhi/lowx/l2uYYPh6eL6kX883ri/Q0Y2i0Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kTNgFg36ldW57h2qVO3O627fgB6ghwRiIp3aUMtUk5U=;
 b=gC/4+U4OlB5I9OX+8oLvzBJbqVdHz3IQr13q1q903UBJx7XEOk4wEIqVQRj67sYrsmAE640GGS5Mgd/bBdBtSVUGyFTLSMVx5Zsxhgp9FiGbYKC+m1j1CQ9sJKs1o1cy7Cg4t6zOKp86L2gyHOX/R5tlQ34kiHUnYBHSe2MigRmJOV5g0Im7lWyX8RVsQGGv9LgbHAPbvya+PMXREHbjzC6hfyuWINcTQRGa7RW3blGhhLTUCwwcgiHSTpBaRLWqPN0WK6Fu7zHKKrsIlRos9UkcEcGEFFYG84Rs5gjZAA4zba9eu3JvogUZjjISRe2b5WE1E8fvGLiFVeOd6re7HA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kTNgFg36ldW57h2qVO3O627fgB6ghwRiIp3aUMtUk5U=;
 b=P8mOxj7OTb3oOWhRkgqmnbwhpd92ovekjkxJoojGnpCO12OBATbK+voKLUo5iAdvck54lz25jgSUrpiZBq08csk0xdWvN3O7QrSAacUbl3jLpZpUFK7PyGKrcYykAtcZbU1SohYfuedgfYF/BaOVc3z4s7MHT/1XppCfx0J5gN0=
Received: from DU2P251CA0003.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:230::13)
 by DBBPR08MB6073.eurprd08.prod.outlook.com (2603:10a6:10:1f7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Thu, 28 Aug
 2025 11:00:15 +0000
Received: from DU2PEPF00028D0C.eurprd03.prod.outlook.com
 (2603:10a6:10:230:cafe::8e) by DU2P251CA0003.outlook.office365.com
 (2603:10a6:10:230::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.17 via Frontend Transport; Thu,
 28 Aug 2025 11:00:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0C.mail.protection.outlook.com (10.167.242.20) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.11
 via Frontend Transport; Thu, 28 Aug 2025 11:00:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vyg14RH32MUfPOsSVt9+I71SMscu1nAealQ1aNFtIlefhg8rcmA3hdlQRTM1oXyKtuc+KzUts/nunFHaMhZEUhNW360Terq7ePbuUxssqInPeU11GTX0PyPoptDKJSfJ3lzkyrDP8EOCQFgVgQhE7h5C2f1F628nXjkkit8YAHHIZG5v4P6Y5PQEh77fouaxKW8CAo/KHaCZi3onbhKongfaFmxunWlyJy48YvmJRju5m1FV6BejTRTwD8VPam6V4UL+LLe5u/Vxw1AlRk/T3Za0df3gT7vHax5BWyuFRh5q1Gmnxq/B6eJDS8/aizO6KzM6b+ThlbfMazxne77xww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kTNgFg36ldW57h2qVO3O627fgB6ghwRiIp3aUMtUk5U=;
 b=KwEBAZ6l+uZJOJ4sXN9c0FQaI+krmCUZy4hIDH3MthoV2AV9m8hZ3/W12pXFvY4E2WpzJd8rDqGuWjeZ4J3GvbSTL41cy4F860rKlZ9LUrBbWhZUke82zM4tUYwuWHIRmLzJwkVPV7fDbnaPDDELzBGLHYY7G95Oh1s7KmVrvEoi+Nvff03Ax9F4GQ61ccY6OE28oqk94gFJnHNOg17NzW3Lb9sPMFmPlrqU+gLl2U247GK3TkiAy7hVmo5sPNwr7f7kP6SZcI09TOXGSoypWoBq5tqeZQet9M5uuEZurJGTU5kQcNzIHvfZPLOdeNAhH0ngKg46XZs4lfOG+mhttw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kTNgFg36ldW57h2qVO3O627fgB6ghwRiIp3aUMtUk5U=;
 b=P8mOxj7OTb3oOWhRkgqmnbwhpd92ovekjkxJoojGnpCO12OBATbK+voKLUo5iAdvck54lz25jgSUrpiZBq08csk0xdWvN3O7QrSAacUbl3jLpZpUFK7PyGKrcYykAtcZbU1SohYfuedgfYF/BaOVc3z4s7MHT/1XppCfx0J5gN0=
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com (2603:10a6:10:46e::5)
 by AM8PR08MB5716.eurprd08.prod.outlook.com (2603:10a6:20b:1d5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.16; Thu, 28 Aug
 2025 10:59:41 +0000
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31]) by DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31%3]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 10:59:41 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "will@kernel.org"
	<will@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Timothy Hayes
	<Timothy.Hayes@arm.com>
Subject: [PATCH 0/5] KVM: arm64: GICv5 legacy (GCIE_LEGACY) NV enablement and
 cleanup
Thread-Topic: [PATCH 0/5] KVM: arm64: GICv5 legacy (GCIE_LEGACY) NV enablement
 and cleanup
Thread-Index: AQHcGArbVVDxpxTmDkuPXHVOpTXGkw==
Date: Thu, 28 Aug 2025 10:59:41 +0000
Message-ID: <20250828105925.3865158-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB10202:EE_|AM8PR08MB5716:EE_|DU2PEPF00028D0C:EE_|DBBPR08MB6073:EE_
X-MS-Office365-Filtering-Correlation-Id: ea65a16d-3b99-4a62-cced-08dde622110d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?DLJkZP0jV+ET0dj/Q4u4vqXcY+tQQfjh3Jq4FfsgwsSP7P/uQ3Y9C9DNq6?=
 =?iso-8859-1?Q?WNCecQNsfIMUkY/wtG4zycfHmXpHERCGPC3A2NonLFSmMzOQJgJHoTbRBr?=
 =?iso-8859-1?Q?XtzRBGDG1V1M2290pLapzxliM4RCE3YHf4lkM38up2Pm/Pc37TQ+1Lh3S2?=
 =?iso-8859-1?Q?QAhR2/wbO0K2gvIo2Ujopj7GuBhNyUMCBjOGXqZTlHvmyH36OCavhzqz6t?=
 =?iso-8859-1?Q?CBGy4RCIPmXaYSd0bJqDXgbKBzCzjYFJUc77yV1rJBfVyim8PiO2qV7hnl?=
 =?iso-8859-1?Q?rUShCf5l2MjxkUh6Z0rmrpm6SdoeYSrHGH4kzPU5eL/O/FDJGzrelGAOKP?=
 =?iso-8859-1?Q?qatGNABmcJ9WzUaqrjXo6oTGFRsw/qsvGSQl/t+X7Ob4xW6IiKZWZ42/b/?=
 =?iso-8859-1?Q?jwbWGhs3zxyZyW9V8p+gxPtB/VTMPzpE1X3elWD4LEuVfKrZsVRYgPsoae?=
 =?iso-8859-1?Q?EtIRbuql/AXC9F99xYgrvvTKkc+N93Wsuey8+GAZOEFd78t9kSR7z1ltQB?=
 =?iso-8859-1?Q?714vry8aM7LiLs8IWwqd5+rmle3kEMsjNJ/NmfbNHtstq55GWhLS/WoEx2?=
 =?iso-8859-1?Q?zZ8RN1i3890FIqwJgrYON0SbKtiRmYKcp7b91MUvOl5EyLySNiJJwLBtw0?=
 =?iso-8859-1?Q?xDdJz8YBTjCX7IP6YDH8Fb8rNDJN8SAKMrCxg6UHwut0hTtXdc0qbIaxVd?=
 =?iso-8859-1?Q?67TrmrcxApXplVoPnm5pBViCMJCwH5Dipr4041zRnosexPi0OpiEGqJPAA?=
 =?iso-8859-1?Q?AwFMI467B2Eown1IooWNGEQgejWsjXjyhLaXGBMR+kdTPtsqsvkGYCMO0Z?=
 =?iso-8859-1?Q?LyzwNRRD3zOowZpoXeZh2mLF1FMLnKpCnz55fCB4gSGTd4KoYzLXzCeJdQ?=
 =?iso-8859-1?Q?Xf935lydb+kJt0HxEajEdvkZzzZQJDyoe7Je1B9GUD0A8mMHJQvyHtSsBx?=
 =?iso-8859-1?Q?YkyxDI9ukkQ+95V2XKbl27fDy3/c2194z5AD6CFo7HtFFRDDEj3JW19Y+v?=
 =?iso-8859-1?Q?pEqfS9XfLDAls9Jms1r2grBsMDTOaZ3fcfwYYMMngKJQG4fKuUpKknyXM+?=
 =?iso-8859-1?Q?km+UfXr56LwpxZxoW3tWNCKhGCHY6S6RIfm0o7CfMy4xAER/adRNPU6V7I?=
 =?iso-8859-1?Q?/xMqJ5dlDtCIpctqbMGaFRdQMOK/qf1IpNhts0I1dAcR1gmbk+oxzkL/4S?=
 =?iso-8859-1?Q?qNq/9jMLhJL+b6+iuoLs7I7SzH6JzahdgGStnzFquQew625vOCIDVBCCiu?=
 =?iso-8859-1?Q?yybIMEKfR3nmFHDHcZcL0m1yhhEj6/FG/iXFMjw+1CiGYx2pjW5QrJfJa1?=
 =?iso-8859-1?Q?mDafpcRka/60pz+ZfkMTKRmprJMLC8KzoMCIsEFtds7uxLzoI/gGf52TKE?=
 =?iso-8859-1?Q?jO0Ek2czaedALCDbjajqrEDznaS1tSyZDgTRKRtQbwJY2Os7u6nJqo7+N6?=
 =?iso-8859-1?Q?iUBw2aKvNzxkl91q+4kDiavOznqGvikTsMcwpoJgg2chbum7mDh2tp2bkz?=
 =?iso-8859-1?Q?11MVotnhLd+OEvBR1x/h6JZX8O82o35JtEK+x7Km2fDndX/0Y2oc4fLRAx?=
 =?iso-8859-1?Q?Vv0ctQ8=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB10202.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5716
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D0C.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	126eb67f-003f-4da8-ee68-08dde621fd82
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?eBXNs98IvN12Ap2D+XF/nVvSpwJEdCocrc5TMJsZkSCItk6uoyJ5P8CmPm?=
 =?iso-8859-1?Q?mOUSimkluA3iJr0W4I4lPFz4fL4a72Mdzxko8sejvWsmaFyhpwUW91tF8h?=
 =?iso-8859-1?Q?aUU1LHk63wSEQSnkQTmsiRUZR/vXiWXj34sVr9okdvLrGksRv5ka4GSTnT?=
 =?iso-8859-1?Q?N5uGla1NXXia3zlt1VUSmJkn0ANUfXSdTZjbUCWD63mnlFMpuYq9RYdPz7?=
 =?iso-8859-1?Q?rH0P/UuK9drH9HATTKJSoCKl9rmYI02axr2cQKDt9KAzUhVU0kQMpxcf7q?=
 =?iso-8859-1?Q?VwXV2eCmc6vyKUlyZHGHSaQ9guB4w6L7CBNyrbAfMNiTvWe85lOuQIqpMs?=
 =?iso-8859-1?Q?k/SNDk5+BbvM9jgxMBHTZj5CBeajXMPNuFFlDst3rdllwoioG2qPTdBzsz?=
 =?iso-8859-1?Q?4Qxjt66wH/AUWbQE4tbuhXC36qzyBnvgidUppEUYP2XpsIXDYldwuu4EQb?=
 =?iso-8859-1?Q?NAzMu2aptfrJCH90xVNcv7NE35EQetowMn9Hkc42trz9FmW+mE2gEasuHv?=
 =?iso-8859-1?Q?ToqZZ+i3E5nmE4iIkgeEcH8LbibYF8OKAyscO1nJiQgB0lvdnaIrob1w3s?=
 =?iso-8859-1?Q?8qe75wUpWibyspX/5DfhERk+tF25Sz/hlZFNo1UpxCBNPnhgIOnplf7IPz?=
 =?iso-8859-1?Q?XJXWUfPYobL7srocYg04VwSJn6F82umah52nka/hYRDC7HSkHbqR57dOxj?=
 =?iso-8859-1?Q?VgJ1+EvxLkrxoODGHHIRiddzv6R9ymriylyPLx9jCEsJnyGlKVjYpiADph?=
 =?iso-8859-1?Q?N7Jjgr9uUBLmnKQ6ZJF9J/vOCNLOcUbBLmTurY7skECEiJRu5Fpd2xqvZ9?=
 =?iso-8859-1?Q?r9pqoVgD5s/0A4z8uKRJ4rAp+hvC493XFLByV94w1nZ8pCW4mYrLZRkjMn?=
 =?iso-8859-1?Q?aZrkp/Tm/LpZo/Os7bVOz1lfr3EPfdXVH2PMvONEZ9IIEO2WqIeEfGx8u0?=
 =?iso-8859-1?Q?nmuhfH3S7CY2omSO/EgSGddRl9AvDESDojfDFKJ1YzpFjAbO5pRLZQjL+a?=
 =?iso-8859-1?Q?ue8wvHjzEBLbeuJKwWhQMQE8kCyUESGWPOuanzrSXOwkAEO5Laisd9R81D?=
 =?iso-8859-1?Q?yVj2qj4ir+48f7tNdyXeOfaivIOSeqcwyrMwMfd61fVcmDDq4iz7sCED/j?=
 =?iso-8859-1?Q?R2QSMV5rmO8oPg5McJ07F0RiFOPrJJtWF2VK94YW3M44iPjPH1Lp7OLUKb?=
 =?iso-8859-1?Q?GrvhUDy3ByanW4WUuTF7I5zh4QAMqppVT2Sl/Zia6J6cdNWq5Eq19Rp7pc?=
 =?iso-8859-1?Q?ws/JlnThQU8/Zsq5RcSPTOpH7IjmtNodyzBI3QYNo01/O2mbwFmzGmf6Ir?=
 =?iso-8859-1?Q?kUERPfro6dJZeZV/XWhHdI4BMYKX7g8B8/FTsDdSKZJQMBQSQi93MdluJ0?=
 =?iso-8859-1?Q?kq+oFvJDyZPsu/ecXxKaUn6rm+SOR2SFctpGZjuON1k1pEaFw0peZUAz29?=
 =?iso-8859-1?Q?qLnJpgKYuVmWYMjWoJAcaYmUbc/HE6J7HsOn4QcM8VnFy3O6r/8KBANNkl?=
 =?iso-8859-1?Q?M06W8XbAQiTI7gMFRVUoumR1oPnZwWFE7FY527Y55ehsjdCRyXetpfBs7y?=
 =?iso-8859-1?Q?94uL2v3lpDQsjvwaCESNY9gat/iWMDMFbh2P2cF/dQybup+BLA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 11:00:14.4901
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea65a16d-3b99-4a62-cced-08dde622110d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D0C.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6073

Hi all,

This series enables nested virtualization for GICv3-based VMs on GICv5
hosts (w/ FEAT_GCIE_LEGACY) in KVM/arm64. In addition, it adds a CPU
capability to track support for FEAT_GCIE_LEGACY across all CPUs.

The series fixes ICC_SRE_EL2 access handling for GICv5 hosts (to match
the updated bet1+ specification [1]), and extends nested
virtualization support to vGICv3 guests running on compatible GICv5
systems. With these changes, it becomes possible to run with
kvm-arm.mode=3Dnested, and these changes have been tested with three
levels of nesting on simulated hardware (Arm FVP).

Previously, the presence of FEAT_GCIE_LEGACY was tracked in the GICv5
driver via gic_kvm_info, and the probing logic could incorrectly
enable legacy support if the boot CPU exposed the feature while others
did not. This created the risk of mismatched configurations,
particularly when late-onlining CPUs without FEAT_GCIE_LEGACY.

To address this, the series introduces a proper ARM64_HAS_GICV5_LEGACY
CPU capability, and moves KVM to use cpus_have_final_cap() to ensure
consistent system-wide enablement. With this, late-onlined but
mismatched CPUs are cleanly rejected at bring-up.

Patch summary

KVM: arm64: allow ICC_SRE_EL2 accesses on a GICv5 host
    Update handling to reflect the corrected GICv5 specification.

KVM: arm64: Enable nested for GICv5 host with FEAT_GCIE_LEGACY
    Allow nested virtualization for vGICv3 guests on GICv5 hosts with
    legacy support.

arm64: cpucaps: Add GICv5 Legacy vCPU interface (GCIE_LEGACY) capability
    Introduce a new CPU capability that prevents mismatched
    configurations.

KVM: arm64: Use ARM64_HAS_GICV5_LEGACY for GICv5 probing
    Ensure probing is consistent across all CPUs by using cpucaps.

irqchip/gic-v5: Drop has_gcie_v3_compat from gic_kvm_info
    Remove obsolete compatibility flag, as FEAT_GCIE_LEGACY is now a
    CPU feature.

Comments and reviews are very welcome.

Thanks,
Sascha

[1] https://developer.arm.com/documentation/aes0070/latest/

Sascha Bischoff (5):
  KVM: arm64: Allow ICC_SRE_EL2 accesses on a GICv5 host
  KVM: arm64: Enable nested for GICv5 host with FEAT_GCIE_LEGACY
  arm64: cpucaps: Add GICv5 Legacy vCPU interface (GCIE_LEGACY)
    capability
  KVM: arm64: Use ARM64_HAS_GICV5_LEGACY for GICv5 probing
  irqchip/gic-v5: Drop has_gcie_v3_compat from gic_kvm_info

 arch/arm64/kernel/cpufeature.c        | 15 +++++++++++++++
 arch/arm64/kvm/arm.c                  |  5 +++--
 arch/arm64/kvm/hyp/vgic-v3-sr.c       | 27 +++++++--------------------
 arch/arm64/kvm/vgic/vgic-v5.c         |  2 +-
 arch/arm64/tools/cpucaps              |  1 +
 drivers/irqchip/irq-gic-v5.c          |  7 -------
 include/linux/irqchip/arm-vgic-info.h |  2 --
 7 files changed, 27 insertions(+), 32 deletions(-)

--=20
2.34.1

