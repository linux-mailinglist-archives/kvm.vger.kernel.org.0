Return-Path: <kvm+bounces-65873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C908CB9237
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:30:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 45F4F312812F
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:25:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C291831770B;
	Fri, 12 Dec 2025 15:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WGkwVgVG";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WGkwVgVG"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010011.outbound.protection.outlook.com [52.101.84.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF0E324B37
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.11
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553046; cv=fail; b=AxSU2sMqjDxvc1UZmYxTJpSbSl4mX/UO1Ab78U57CAh1kQVLIpOfr0REnQDI09o6D5q93N7xQp/FF4T7SXY8vvvysAZ2Y1p8bij9dhBIkKcJLU6WB6u/Yz6IqY+4XYYqoL9xA7m8tnjk8SeEuzptu8QQmg1ou+NUoqZs8XhZIHs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553046; c=relaxed/simple;
	bh=yiOP2BCzNVHcMsfPZbhm2ns3O80OxCEKL64dxy0/GFA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fJOUxhHa+GAhnC+noSSvqWCCV9ocl0ZSg1Lw3aiAyOTxvvvmWqOfbjjJnF/UxlJFELIvt6S/rquYwr1Uo1xJr/HsNHAZKUMWhyYKITeZc27ZYY6kC7QSbUYrwthNkZuqmf2LFPKZ5mJVDhCfKzucGEQfTQZwdIlftQRhh03j8fY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WGkwVgVG; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WGkwVgVG; arc=fail smtp.client-ip=52.101.84.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=n6SWPnD+l1HWCJzMdcAK4MxiT5r2ouOb7/5R7aQZCPOEvAp3uNHLed98IiIHp6aJE8kZp1gJd+YALjkXCt3sUcIrfrrYB4ic+rr/NtYay0xU0+/x6ikNlomuQRyOQ7EpcBgYTN6r1IByZYBpEVnsqb9pUypoXENMa3x6HdHCp6nEotabwITdX8sMwPgHBa8dtAonbmCs92+HHOjD+1W9MifFULP5AHi1zpCp2TQiabPErCeioG/RkOr5+XgqareH+WtOyEkPAkRr+GWWPalblpwkLygx+NI2OfQ3BT6V5vMvVGCAEtQsMhUKQjUpcKnzsweBDGJXryDUwvtOkPWVjA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=juYI1FMXu5DQltUeNDu4uMhmRt3TCuj6qWj4/72y17c=;
 b=Sb65PYifamuDiDPyITGV3yEQKvywuvHeNz0MUuPFKhm75UDwhW3YMWpvNx9FWBwNYzkBHs79en0OKB9z974t0NithOfmflngvdyezjhzxCV3pryIa2xZ+ZY18TW1XYo+7i2HJ1u6+hSaF/ya2tk87iwVaKBzdM/wMs+RUoTjrcSvQ4RydlYpcrPK4VWtn6FifOqM/OVAV8pPcWrjKYAEVjT9C01I1/YW2HI6tLlsVbIh9/PBA+faI6VNJ5zzrze3uXLgopJ2Ipa6RQ7gvQ5w0Kw+6vsqYXu/n2eza8IHzesNvDs1nsn6Q/WCLydBqKyGT+7YczLlyKpyUFjYc6rJvQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=juYI1FMXu5DQltUeNDu4uMhmRt3TCuj6qWj4/72y17c=;
 b=WGkwVgVGjsWa88NJDAb2vOFkfkkquELqKtBBt/mpeBjE3PhQtM+lR4C8IIe63Rv9BJTmSUEc9Rq0TkKAQDSCgzr1qAUQUO+p3j1oecCY+dxYMV3POhsLc9FVZqWP9EXZ0QFMCyyPT2bCJshkN8cOKM/NFGJzVH258gAmn+cd4xg=
Received: from AM8P191CA0018.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::23)
 by DU5PR08MB10612.eurprd08.prod.outlook.com (2603:10a6:10:51e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.11; Fri, 12 Dec
 2025 15:23:52 +0000
Received: from AM3PEPF00009B9C.eurprd04.prod.outlook.com
 (2603:10a6:20b:21a:cafe::2b) by AM8P191CA0018.outlook.office365.com
 (2603:10a6:20b:21a::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.10 via Frontend Transport; Fri,
 12 Dec 2025 15:23:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009B9C.mail.protection.outlook.com (10.167.16.21) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 12 Dec 2025 15:23:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xi+w97/HMFn07DPCRA2FLO7tl0uoGpIYd53YPDX36xThXAyJgbuCqdYM6/kpGrkb0pjIDtaK0GQud+Lb2/d0MH5kSKvND6iXgTYAERCGpGP8wR45sJwJKy6qofGnhc9UptLGCin3/rdfSZePXAyhWSHUNCQ6nMSAIkQKX/feyYeSrXTo+puQt4L/ai/BJoMME5Y3p4CLivlbtgRbteqvCWbi+mVSs2s3S9uU5S+jar5pzOEE2so6ME9APoxK8RJq71WNA4Qwba9LxxgJP1Pw/+/wlBNG89Uf9uo6rDSp3uyF5IhoksqhbAmIsoxnqKhErr1QnfPWFKecEIiUjifd7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=juYI1FMXu5DQltUeNDu4uMhmRt3TCuj6qWj4/72y17c=;
 b=qLbsRqViDLNvMNOEOKMBQmhcYibZDasUPGxrlIdep71aC1eCHsiTTBNXDew7BJq4z1obwWNN0Kj7ml+I0ArAK2OKQ4HE51AclhVQ3s3Necz1B2MlXOEp+4h4a+HgQ5JPQJU3SaBDxfxjoLetrQfjXyV2dyf1Ioe3zHRS5jv3qikSMqxh8Pg6Mfpxmjat00caRlTDlKawXtzR6Xl4EGjqFlmpcDC7m7o9tYl8pCVEIuUgQOTVyB6hWmMDqQOMczRHtf0Qri7d77Ls9nicr0DJun+WKeId/Udd0uf/uaFXBJOaLnqkfs8blbOPkcX+np81G/AGwMNVGf/Rd+ET6aaGRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=juYI1FMXu5DQltUeNDu4uMhmRt3TCuj6qWj4/72y17c=;
 b=WGkwVgVGjsWa88NJDAb2vOFkfkkquELqKtBBt/mpeBjE3PhQtM+lR4C8IIe63Rv9BJTmSUEc9Rq0TkKAQDSCgzr1qAUQUO+p3j1oecCY+dxYMV3POhsLc9FVZqWP9EXZ0QFMCyyPT2bCJshkN8cOKM/NFGJzVH258gAmn+cd4xg=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AS8PR08MB9386.eurprd08.prod.outlook.com (2603:10a6:20b:5a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Fri, 12 Dec
 2025 15:22:49 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:49 +0000
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
Subject: [PATCH 27/32] KVM: arm64: gic-v5: Introduce kvm_arm_vgic_v5_ops and
 register them
Thread-Topic: [PATCH 27/32] KVM: arm64: gic-v5: Introduce kvm_arm_vgic_v5_ops
 and register them
Thread-Index: AQHca3sqkBsw8l+Dy0+RjCh06Vz+LA==
Date: Fri, 12 Dec 2025 15:22:44 +0000
Message-ID: <20251212152215.675767-28-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|AS8PR08MB9386:EE_|AM3PEPF00009B9C:EE_|DU5PR08MB10612:EE_
X-MS-Office365-Filtering-Correlation-Id: 397b1c95-35af-4b6e-96d4-08de39927475
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?0d+SgSrSajlXTKBPFSc11kuYE2if6JJg4hl0fgOmfsQ/j059e1xiysoab0?=
 =?iso-8859-1?Q?2M78wDg1C1/H28p0qojgaKqFNthvGKoa2WZyJ8c0CZOX3xrawF43MkWbeI?=
 =?iso-8859-1?Q?JDfN4f70OOBQH20V20OF8a3paHZh23y9mi1qtJMIsYiipLIE+NtPpuHw9C?=
 =?iso-8859-1?Q?bfkLr4wOZRrqRqnnPlGumVpwnUfpyMLZj7r61UW5VS4QHFZxBmz4PWS4m+?=
 =?iso-8859-1?Q?trITXtAvNVXLDiwO+mVDXYm3zomEwaixYS6zaBvRua4pefZQf3LYGFb4n1?=
 =?iso-8859-1?Q?It8UBfO+CZVOtm5gBeL4nPFvPeBkubYwwgUuF+ece8oWrY0fEYv59+eoQB?=
 =?iso-8859-1?Q?gIuLS/CiELobZ0Cm5tmBUhZePFW6PXZR7y+kzpni8lDxNo2vnOkRYSZGBf?=
 =?iso-8859-1?Q?gD+cUoaj/PpNb52W34DnXETzSFcKp2bjtmynit65f10/CorkX7atvuitMd?=
 =?iso-8859-1?Q?cXWIIaUEVtBfzxgUnuGEtORdijehR3AFHrmAyBWziwA5o/96TtO5d2hXeF?=
 =?iso-8859-1?Q?JPGTaDR3q7cygevz8HDOVD32dVyKasHs6l4/Qprg+udYsGQJhQskXhhlE9?=
 =?iso-8859-1?Q?3pvgCW62/mNcBCHx3y3agaoYuPSBs3aitjEskniQndyDsdyTxYNQhwq9CZ?=
 =?iso-8859-1?Q?viXLB/cFOsNSWPRRHn40AljExafojPSDklfsQqw/IPqESwW6wEJo/6ZjHy?=
 =?iso-8859-1?Q?Qvs8L0SnV9Zp2uDdON2x8PcXj0xU0ydAnQWjskDIDQpZUs5a9gSN+Tr0hi?=
 =?iso-8859-1?Q?yOCdxgw4tx1epNtfrnUn+T+DZeopotbPdWq4hWg//hyWQ7J/ch8HtpaNAD?=
 =?iso-8859-1?Q?K8tPA6o7dYIMdTCtpr8bAznJdTSa3L7iq9eTEoQChmRDHe9x/3WIeuay2G?=
 =?iso-8859-1?Q?r4D6kBhnsYtKBRJZdq38LO60JuNRLZcRL4sPZeA3IYdBk5GLHLzrMHHCUj?=
 =?iso-8859-1?Q?lNr7gNIzk6XWfGLiKT/Ybik9A5TNicYxHDYoxv2kGTafT02IZ+GMzoU1+2?=
 =?iso-8859-1?Q?tzvSOMyqQyTlawiDHMVfSqmk74t3AuvEFQ5soiSq/1x4xASUfFMdmAxU+E?=
 =?iso-8859-1?Q?CsJzoebtWxoy3ZbopNBzz0TkU5957udAuuN7NEF8+huwULAxTLJJgO+bzm?=
 =?iso-8859-1?Q?UReAqJl8uY6928tRXfg6ZCo+f1YgWCgp9lLeB7VYa1Vp1dKf0FirfhOavy?=
 =?iso-8859-1?Q?dxZrvO3XTmio0akryZc8C2Torp3jGnB0dzwWvQ7TaU2n/C3ab/1tEeKSfp?=
 =?iso-8859-1?Q?ipth+WZH8/0ONvyBEr9dHiBejJ/H7vw7/IGAVMXF7/Ah7ASQinU9X24KGO?=
 =?iso-8859-1?Q?OKa6tX1eIr0wtVUPTUa0AQSUHfa+IcMSqqxCDP1PUGM8oqTFrGn5gLutb2?=
 =?iso-8859-1?Q?cw6hKuKU4vrmQ+iMEwB05ZOUdnQt/NETZEqNSIZ7d29N/z5gmZPMDBdKe/?=
 =?iso-8859-1?Q?MyUF/eaWMmLGCY1wo+PfZkZcdNR6QT7tEcI8raIdAdWDDoQZCAP+b1mgCe?=
 =?iso-8859-1?Q?Ndh0/R0nUfKkBbxbpxEFsRzwa/YLw/6SKb+fjzzuaKVJpp4xGSjoUUoytp?=
 =?iso-8859-1?Q?NR9AMrnfXOTIgHb/LxVlZ5BFUipS?=
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
 AM3PEPF00009B9C.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b9274630-898d-499d-4e05-08de39924f87
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|14060799003|376014|35042699022|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?V46shj+15ed0pyt5QzdAa5Zd2OulxN40jggLfs+6zlw6nwEKbjmW0Y0hbQ?=
 =?iso-8859-1?Q?RMjlKRJPJ/clajfEJE00hJNCjmgSrrXnNAK6cIfrlC2t1dafHW2qDyy52u?=
 =?iso-8859-1?Q?V45ZfqQWzcF3d+2/jrpzpGU36T+NmXmnBZfaF6HTcHAYEhqy5sPhkVxv73?=
 =?iso-8859-1?Q?3UkQ3GdDUNc8jxEqeCuNcTfEs+Oxhara5p8nqs6SubpK67dMgQDjX0oifW?=
 =?iso-8859-1?Q?z/b9Gim6+pEh9DRiufC6xciodOT524JIRbGGBWtkDpMrlI19b0M3IfRTRn?=
 =?iso-8859-1?Q?64L5tS13nwRyxegqRUjuqwYe+VfGUvhOMiZqaW5QZzWKOcp8x/ircaUtbA?=
 =?iso-8859-1?Q?Yn0CL2Jmdqgy+qeTlSfWgaOWZjX55M/sIc/BGXRBqyKZ90YhICY0VtX4jT?=
 =?iso-8859-1?Q?UvwZydReBzGF9Csfm7vfodUQbL7BQGA1C58DpLdfDKl4axb+fPIaCItdqK?=
 =?iso-8859-1?Q?nezh+i/PPyrGjyvIoQEing872Rw8zcUV4A/G8Zsdjja4123sygQG0cnnEn?=
 =?iso-8859-1?Q?Bz1wnlC1AImbvDxyKMLzS7rqraaWeh2+/7F6mc6jxIAdaR3YhS6djnRsOV?=
 =?iso-8859-1?Q?uPV/9TcZc81t02TocYv2pcVZJgIJIcy5XfrhhrD2TJbrg/SGO1PQkfXl6J?=
 =?iso-8859-1?Q?T3sWfK3ShWizOU8gZuPKw0T2MXxpiNkRrURDgszVLpU5Ul2mKjaELaKkGW?=
 =?iso-8859-1?Q?56+l+Eyj1V9MDq1KUYvM3o73/mbr9njssjCAIO3hFDNgFcb5ilPUiH5WIu?=
 =?iso-8859-1?Q?bRu84lpHYv2r01HO+cn5SqOi+lfUTMmxQIadtDZl2F+o3vfwg8GwCFnCk3?=
 =?iso-8859-1?Q?UwHgblXQy9j5m+QEHsrjSIyvpXtT7fJkNnz6C/jrjrqFOta+/nlGPpYc1M?=
 =?iso-8859-1?Q?30T5thQ+AchVTQTZ3oAk3Up4Qa2r1oL3L6VMzdNc9vfH5jetm8H3KDpMA3?=
 =?iso-8859-1?Q?Se690SmPatOR4n3hWYi86dZXg7EqyoaeDBzkE/avrN819jXOzgyLw5jnEv?=
 =?iso-8859-1?Q?q7iXbLJvEmWKJNQ3AnIAnAtbAXd44I6W/YYCALpsoHIRe+cr2mZTRg1CNe?=
 =?iso-8859-1?Q?ZzdROI8R3adO5DNigYTnBW9QDhNxwQ/7mlPUcMoB2Gr5I6HlEE9Uu3bz7j?=
 =?iso-8859-1?Q?wygpz3sRDFDaWOCKuF4AzfsBBlmNYQOMAdUOfZE7H87taNluEDylwp2tvy?=
 =?iso-8859-1?Q?XalnXlicU4ykB4mL2eRiCsk4zLYUxZpDgjiCdk2d5nkbDUdlqcDGxybOV5?=
 =?iso-8859-1?Q?U2zEJTmsrKbe9BMA7OXf1mWk35mPyCwCK2A9KrryZYvexXZ7Rl1FsK1cSp?=
 =?iso-8859-1?Q?F2XrS17VDgzyDOS30S1NpXptAcTF77+j4SAZU0Jzk6EA7fHSvv/ZUK0JrH?=
 =?iso-8859-1?Q?FzcvLYLqCWCsrQZINsVqnzYGU2QiXB6On4517qThEqSQ1o3/E6vU/JRBs5?=
 =?iso-8859-1?Q?eUVCGBb/z5TsURviFxkk3qJi89noS3urEsSotnrMkpEAxhS6QYhNCRUVxr?=
 =?iso-8859-1?Q?uMsgaFlimPhWGeHJbhqvH6TsLwfg6kny1VTyxijJJWyVfkl98eLmuT03+O?=
 =?iso-8859-1?Q?x1guZJiv8+v6EzhFpfYaX8WPkHcIspm3h63VzSBGLVazuLMe/gKqSfIsyf?=
 =?iso-8859-1?Q?lMPpMDKipbdxE=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(14060799003)(376014)(35042699022)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:51.4140
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 397b1c95-35af-4b6e-96d4-08de39927475
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009B9C.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10612

Only the KVM_DEV_ARM_VGIC_GRP_CTRL->KVM_DEV_ARM_VGIC_CTRL_INIT op is
currently supported. All other ops are stubbed out.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 72 +++++++++++++++++++++++++++
 include/linux/kvm_host.h              |  1 +
 2 files changed, 73 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index b12ba99a423e5..78903182bba08 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -336,6 +336,9 @@ int kvm_register_vgic_device(unsigned long type)
 			break;
 		ret =3D kvm_vgic_register_its_device();
 		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		ret =3D kvm_register_device_ops(&kvm_arm_vgic_v5_ops,
+					      KVM_DEV_TYPE_ARM_VGIC_V5);
 	}
=20
 	return ret;
@@ -715,3 +718,72 @@ struct kvm_device_ops kvm_arm_vgic_v3_ops =3D {
 	.get_attr =3D vgic_v3_get_attr,
 	.has_attr =3D vgic_v3_has_attr,
 };
+
+static int vgic_v5_set_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		break;
+	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			return  vgic_set_common_attr(dev, attr);
+		default:
+			break;
+		}
+	}
+
+	return -ENXIO;
+}
+
+static int vgic_v5_get_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		break;
+	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			return vgic_get_common_attr(dev, attr);
+		default:
+			break;
+		}
+	}
+
+	return -ENXIO;
+}
+
+static int vgic_v5_has_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		break;
+	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			return 0;
+		default:
+			break;
+		}
+	}
+
+	return -ENXIO;
+}
+
+struct kvm_device_ops kvm_arm_vgic_v5_ops =3D {
+	.name =3D "kvm-arm-vgic-v5",
+	.create =3D vgic_create,
+	.destroy =3D vgic_destroy,
+	.set_attr =3D vgic_v5_set_attr,
+	.get_attr =3D vgic_v5_get_attr,
+	.has_attr =3D vgic_v5_has_attr,
+};
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d93f75b05ae22..d6082f06ccae3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2368,6 +2368,7 @@ void kvm_unregister_device_ops(u32 type);
 extern struct kvm_device_ops kvm_mpic_ops;
 extern struct kvm_device_ops kvm_arm_vgic_v2_ops;
 extern struct kvm_device_ops kvm_arm_vgic_v3_ops;
+extern struct kvm_device_ops kvm_arm_vgic_v5_ops;
=20
 #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
=20
--=20
2.34.1

