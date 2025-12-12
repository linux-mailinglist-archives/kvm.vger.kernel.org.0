Return-Path: <kvm+bounces-65874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1498ECB923A
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:30:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0B2003129084
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:25:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39FA5322537;
	Fri, 12 Dec 2025 15:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TR8INroD";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TR8INroD"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011055.outbound.protection.outlook.com [52.101.65.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552581EDA2B
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.55
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553047; cv=fail; b=VX7NQkBM3sfaZHsQ0TzbZpmisfq/bUOXsOVP9Zf243mL5aD2ZifeNYe2CxfzrgCAG8Ftd2gW0vls1optQteRIIwbLXgZejVCbie3lygTXRz2w0aSwd03JI+XAN86Okj2UJw59QGhJNV+4/Knx7iIBVaWNSSqBegTKFymMH7dSqA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553047; c=relaxed/simple;
	bh=9jn03XVOXwEOLZJyhAfnPrz88B2v/FOgXMOe6YcjJvA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=V9PSdNIHLExTyrA6k8G4AXZHD0LV9qcyf7+ShV56r8J6Uy7C6FOnpmcYOI18jxYHeBZKsYKbfMHNWQflSqDDZ9SRjUUrUg5uqoWOiOJf2Xg5IYwjQjlqNGAlUkzu95Ji8gEu4V6rTmhcIaQn4rgeuKe/MGv26KQAHV1+CZa5j3E=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TR8INroD; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TR8INroD; arc=fail smtp.client-ip=52.101.65.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=WC7EiHb92LRJ4LvDEEJRp7o7LO7IPTj4N9RYZGbe+Zjw56INOd4uROv/Cy3MJPzPWb/3X0pfsGqEUBWbCaRU1574M6Oxmb1jtJnL7ynhSeeSWV6W5vu3hY1+rBiwFW5WtUS1Gqi6SaflGWtL0WLwud9emuTzlt84nsYDy8ZX6s8Ihm5vGVBpLZurnrDg+ZE3q5Kqwh29wPBcwiPNxCUS5iCtEU+AT0apck5dtaX8EnisH25AiO47604cDP2lHWwPIgukSAOeL/pNpXXzsf4Ei/NlIziE2BKhTCfGF2t+em26AHtAg74t5cPW4PmyaJFui7Yh+fXWw5c+VvAdsO4UHQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GscteBrmGjeJ+0dh2VNwot9hN7RlZHvryOFOwGGFf+g=;
 b=OcvZaLZuyVMONM5WH7IwE2uV+2CMi1Pr8swFayzaeOnzC+mCQItkB4bTjwHeg1fQS6H9yKxE8/P88zh74pfCFvYDMDfJor6Mb+UsQIwkPGGmTIYS8f8y+VqontBDnpovX7vM8CVRK7/ue2Gg80465EcNjFGmMWBxkJLZ9/DKDl6CT42tgbdWwcuTrNZLLnnPki3zT+Kr84oi8kE+tCoLAxTGLjb5yBKNqLc0/Fwraa12MXr+qeniaseAT+lufsOiKp+FPUq/Zu4jcRoeo8Y+62lWJY9aLCQxubyf3MGCKDRZciCTtcNUS6Iuv1R7+mfxiHgWG8s4nfRNhbx5Gm/gQg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GscteBrmGjeJ+0dh2VNwot9hN7RlZHvryOFOwGGFf+g=;
 b=TR8INroDG2TejDF/BVd6d+XVjWyAAQqj5IYjiCtPJcXtszYQa3NBJFrtTLu7SBeda/hccWztN+aS2d+d8rCO/yIrLtuMQBx2FkKEufsSXARH1dWbjVDMHvEJDDNSRy6qbWknARgLsn5JhtIJOkaV3tHh5k4FJcpY0R64dId8WFk=
Received: from DU2PR04CA0167.eurprd04.prod.outlook.com (2603:10a6:10:2b0::22)
 by AS1PR08MB7426.eurprd08.prod.outlook.com (2603:10a6:20b:4c5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.11; Fri, 12 Dec
 2025 15:23:53 +0000
Received: from DB1PEPF00039231.eurprd03.prod.outlook.com
 (2603:10a6:10:2b0:cafe::32) by DU2PR04CA0167.outlook.office365.com
 (2603:10a6:10:2b0::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.9 via Frontend Transport; Fri,
 12 Dec 2025 15:23:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00039231.mail.protection.outlook.com (10.167.8.104) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 12 Dec 2025 15:23:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HkDI+cHU/i2GgRKwlW7eUAtLo4Ij/8uTe9oRIS+ieTcl/Z7vjXM33gXTAT3KfL/BTqcJYxWbt943V5/FH5u8Fix1lJw874pJVnwXRkV0COYWvmxPtp7mbQEd1MShJEdfSvfSyyfJSoibgGo7lN1g2TX9+Udlk+1gRUL1b0g3lIfFqdJYrFv6CwOvBz2yQ0Do7PeCa9FsRRT9A1PyAheLkVl8q2Bc7TGLTilOVxFkRDXrCrdwJLY2khdfwUBvqI6kMR2rEFg1i3tzIgA+Z6xkbyIT1xRnjgnjXFbbofY8NFZIUJASdxT7IsYknz5s3Ymv2pvL1CZmOFBZdaaRJdV62w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GscteBrmGjeJ+0dh2VNwot9hN7RlZHvryOFOwGGFf+g=;
 b=Arlehv2L2GZKzx4wOzdiTijRl2yfQtYmffYNQLr3iK7DlpYXkQVEBf0bPJEM7PbdtVT0BsExdCIzGSgxCUsU9zRUu3x6+bgDFHsptA4vn+TjKyX4Nz8SZeefKQpES18/20gM3chm1B37jqVE+hJiT9ljcapE3vs3LP32t0amS1lsY7ePgCCnAqguwCOIYibwunsZ6yCFWbA8MUbKeCw+j3miZYidxngosxRXQnUKY+f+pd9t8oVHzKuBRIggyOe//p+wBRc68J6dj68pjr4EnE4VmBaWl+3HiLqR2i/ZC9GIMrWTAfp5vRUp/akycwaR7yLxHoR/PkToYjd4OoMN+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GscteBrmGjeJ+0dh2VNwot9hN7RlZHvryOFOwGGFf+g=;
 b=TR8INroDG2TejDF/BVd6d+XVjWyAAQqj5IYjiCtPJcXtszYQa3NBJFrtTLu7SBeda/hccWztN+aS2d+d8rCO/yIrLtuMQBx2FkKEufsSXARH1dWbjVDMHvEJDDNSRy6qbWknARgLsn5JhtIJOkaV3tHh5k4FJcpY0R64dId8WFk=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AS8PR08MB9386.eurprd08.prod.outlook.com (2603:10a6:20b:5a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Fri, 12 Dec
 2025 15:22:51 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:51 +0000
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
Subject: [PATCH 29/32] irqchip/gic-v5: Check if impl is virt capable
Thread-Topic: [PATCH 29/32] irqchip/gic-v5: Check if impl is virt capable
Thread-Index: AQHca3sqngrJahSBvk+AZkcPoZI69g==
Date: Fri, 12 Dec 2025 15:22:45 +0000
Message-ID: <20251212152215.675767-30-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|AS8PR08MB9386:EE_|DB1PEPF00039231:EE_|AS1PR08MB7426:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f1f6452-627d-4ad8-6025-08de399275b5
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?/46/03s6UVldogYQETnfDcXAR9UZinTr11FRRUf1oKtHPghIiozCg5clOQ?=
 =?iso-8859-1?Q?5+ZxjcsGb6NQVF+ZP1jbBKeiLMSkoivdJTp6k7gn3CFHeV7yYh0hz9orU7?=
 =?iso-8859-1?Q?lvVumOaQGHhDPXYPW2w0iQea4Cxb+BFLj8HMSqeVBgKb8L4cxgtS1k3/33?=
 =?iso-8859-1?Q?sdx0L3a3CVsdNTr9e42lHPmCskB++BZkrz2u0pv3GwVigWGoL8Y2BWvDvt?=
 =?iso-8859-1?Q?rXgatago/IGPZ7VSZdAyIT36qW+jezZfbJCPsGAisLLsgqNHKwa0YbnlMO?=
 =?iso-8859-1?Q?Hb5H2uNyhOFZJj6lc0k+ZQyr+oZjba3yOPvms0X57JOA/ZYpGLEZIPifpm?=
 =?iso-8859-1?Q?rARi9S1Nii3HwLvgIL5wW3ggkh/dzFivf/AaPKI3ry8Kk2yCQSztdF8n2/?=
 =?iso-8859-1?Q?LuCoCPkNx/YI4YKfIIpxiKING0wewzhjxhdeflzpQoeAz1N8CM1B5jHDO2?=
 =?iso-8859-1?Q?lIL0cnCAv5yZHs2W8aUX0wZcWuiEbtwaLSx9YCXZkCC/Pgcj2oyq0S+Vda?=
 =?iso-8859-1?Q?27BqowABSkbD1Q+WHnnAHWByJhoD3gisKWuG8xAoWHX0dGfxJUcx5GdPTZ?=
 =?iso-8859-1?Q?43fsJU/BBPABYmygTH194UAsitPtpuL7iGmqiSC9OoaWpc4FXYBJgz4iuM?=
 =?iso-8859-1?Q?lavelmdki8mrljCnTLXBnxjBFyHJsEG+28ImK/+y8NWmaIMEouEAhFak58?=
 =?iso-8859-1?Q?iOyA224hc+3n4ZmXSNV/U9PElvoXFpFxyh6UkI3KWyeOAcRKjvGFrQ4Usj?=
 =?iso-8859-1?Q?GRuOtmNaMpe/PoM3g0Iti3x+w8/7L4K074fnCf3WxLZgmws/HuXb2VWw1K?=
 =?iso-8859-1?Q?W9SyGT5bq3QzoHVAaWI6JObq5JPMQFIrBH4R9Sx8I7h2ONZXk4jWVjc/N6?=
 =?iso-8859-1?Q?fV7ezTxWmigf9pNhUr1Y2KhmeKE5IbpETh53PKPHMYY/9efV5objIajuxO?=
 =?iso-8859-1?Q?yKt1r4ueUNN0ZsG551gU+GxlLmfSQY7UZYRmAbBuO0ip/UeQGeLBJOMQ9M?=
 =?iso-8859-1?Q?oPDEnall6qUMByj7/S/Ec6dDouAPvcenFiYAsgWaBiFhqRE10f9wQjmeDd?=
 =?iso-8859-1?Q?Sh/hpUhxST7GHczIPpj3R29C1jcgXydt2hmUwRaqpImVyDgsrFw1Z51OZz?=
 =?iso-8859-1?Q?divgeRyx6aR2hRBoNqZpJaRnAINsU0cE/JIyWgAhkReq8nb7eDZA3i6sER?=
 =?iso-8859-1?Q?NCUjSfCCCql5rNBFZSuf978EY3oMCHRH1bvnJ5KXHVPXiYzJX7Jvky3x1v?=
 =?iso-8859-1?Q?3smd2hQFwSYftSULws5jmnDDRsDxhZazJklbMACyrUDD0qt1R5kFVigMC4?=
 =?iso-8859-1?Q?fHT6sDBnq2qINaOGmWGU4fS5gZO+CGEiwIq/IACa2ts5v1yXnD8cYwMJud?=
 =?iso-8859-1?Q?Kd0ERpbQrCDZ48m2NGaqwrBBzNAVchmLBWnSIZQfURItx/yqufeTrf6Kyh?=
 =?iso-8859-1?Q?X5YQvf4jpYQr5FjF2WhPARjq7ZpDuZ5LZRMypPCAB8xK221OsvOmpTDf7X?=
 =?iso-8859-1?Q?PrX6xAEnnJB+tj22zqHJYa5qHOB9eWm4mJ3cfijk2gQNkT/bOghpPM9iuW?=
 =?iso-8859-1?Q?x4kBKi9XJPm3OUmdyayiOIy+b1mi?=
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
 DB1PEPF00039231.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f5a890b4-cb8a-44e6-3e08-08de399250b9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|14060799003|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?FatEQnlsVmqgU3NbQxRJ3fvwLji/RNypUsE2cHILXEyMrak7bf43VUGCC7?=
 =?iso-8859-1?Q?9hwO1PaRvwyqxbJUWOJhYku66yTDFzZSo/acaaP85MnzpWeD+fy2r2PVPh?=
 =?iso-8859-1?Q?eWdHshiag07OPOrZuLzrYg9iRd1j8tH4ObvvlwJqddrVSpwOnw429dqRfM?=
 =?iso-8859-1?Q?8LdI1ChqwkDs97N7IajpVUy//t52EvToKoXvO7l5/ic5MeBlisHrefxWcW?=
 =?iso-8859-1?Q?pASfAL7NWDgNNCshkF84ewFTJmN7rpOjnqdzLMkRUgSx5uVUmX4jFI8tux?=
 =?iso-8859-1?Q?fGbRLNzoDB2TcaPLv5le05d0zANAiqrFz48oFhz2HwQSihhMIXcCfOIxsu?=
 =?iso-8859-1?Q?waqYjwMPKd5clMqSNKSoy8TWxjLnFSAs7OTrE8fzh5NY7LEoFG1wp/FbTp?=
 =?iso-8859-1?Q?p5407ltmmAr3nJogP+LKDdlFhL9YLGJxqdZHiES1qoR8Yoxnl7LaycMjsU?=
 =?iso-8859-1?Q?i6apVTq0Lvm3AWwfGY3sO0TRAzJXs5jx+LgMBz3WUcH1/2b4olnT2kK2vr?=
 =?iso-8859-1?Q?04GjVCvKapuEeffCfRwiFTgcnNOa1Ds4PoG4ySiVOXuTscnZ3UJuDzFUTM?=
 =?iso-8859-1?Q?VjrqfSuq6R2i4xU16LhyWw2vlsG2GCz/3ULIwEvnGRarToH4OhRF5h54o/?=
 =?iso-8859-1?Q?EU/Z8HnkSPQFLQeJlGN7vXJ9U1QVQ8vvii9l9AoPF623uoZmeNo5F1UG5K?=
 =?iso-8859-1?Q?fS39FTUZA8ei4SAxLjGwpXkb+4hj5YXtB5ZgjTZOkxTvRFTjwlwVeJFG6K?=
 =?iso-8859-1?Q?qksmAB9F8+mUkaUHJT2QB1w89x9j036fWpum0ox1RXDG3mVWsXJlbljNOn?=
 =?iso-8859-1?Q?YnD6DFvWlOB4wAeitCF0PGfiYnldO2SfAj4EkzcD3Rm37oafBKotUoHcfr?=
 =?iso-8859-1?Q?XDGdnTkeP+B6j6XZ3kHkapJ+XR7pyC212f0dhuKt87eWy9XijyEww4srU5?=
 =?iso-8859-1?Q?fctIz3eMPw0zQw1saBzQ/n5cdmzOMLXdr4uLm6dWrH5P1eBaa7uZvzq6s4?=
 =?iso-8859-1?Q?/cszmCoHVTxeP46Ik816F43NNnRaNdmTjH+SCvMSlOrCjmYfftJwHhDyig?=
 =?iso-8859-1?Q?yvaJkLTJhdCbhIlWOXvz1RHAjhtOPgIm2feLcUGob5yaNk0NnyDveUoqB6?=
 =?iso-8859-1?Q?Mm1aunIg2jA9PElWYGUNhOi+YOK8gsnEOQbfwye5MF/3IU25NpMo1gEYds?=
 =?iso-8859-1?Q?Gs0HJ3jcAZJ4HtzKqn7N6JYpG/uU34CquVWu5Q60qF/010dgp7Ji2Z1FTh?=
 =?iso-8859-1?Q?aSGfhDkW+DxiOyXUX+Lvn7/N9W6LBBU7qieWARKEEgL+i0DxMTf3jvkvf/?=
 =?iso-8859-1?Q?ryaIdfZ1Bu5CU5uc/r93WpPU0By5+3IssEI9MCKdHPfrZtlM6nr98uum5O?=
 =?iso-8859-1?Q?Lbd9KE4GxrR30MwDjQFnvobPgbc1Y1/ElvKzAllSNup8hXcrhLFwL0Z7Mc?=
 =?iso-8859-1?Q?IvAtMjwshN6JD1eQB9n90g7Kxo7yqv1+dyrgXSGyA+21ZFpwjHGYmOSoQ2?=
 =?iso-8859-1?Q?DCpVs/Co71opZjcj4fYVRNd4B6t018A24zRkYAyFayx2xU85H4IliiYBvA?=
 =?iso-8859-1?Q?5+T8VVLL7lH9PA+KDCTQL9dvswT77toOS2n85Cb2p+NNXRh4boQeSieWUh?=
 =?iso-8859-1?Q?PzhY9Rnz9TL6E=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(14060799003)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:53.5039
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f1f6452-627d-4ad8-6025-08de399275b5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00039231.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7426

Now that there is support for creating a GICv5-based guest with KVM,
check that the hardware itself supports virtualisation, skipping the
setting of struct gic_kvm_info if not.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 drivers/irqchip/irq-gic-v5-irs.c   | 4 ++++
 drivers/irqchip/irq-gic-v5.c       | 5 +++++
 include/linux/irqchip/arm-gic-v5.h | 4 ++++
 3 files changed, 13 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-=
irs.c
index ce2732d649a3e..eebf9f219ac8c 100644
--- a/drivers/irqchip/irq-gic-v5-irs.c
+++ b/drivers/irqchip/irq-gic-v5-irs.c
@@ -744,6 +744,10 @@ static int __init gicv5_irs_init(struct device_node *n=
ode)
 	 */
 	if (list_empty(&irs_nodes)) {
=20
+		idr =3D irs_readl_relaxed(irs_data, GICV5_IRS_IDR0);
+		gicv5_global_data.virt_capable =3D
+			!!FIELD_GET(GICV5_IRS_IDR0_VIRT, idr);
+
 		idr =3D irs_readl_relaxed(irs_data, GICV5_IRS_IDR1);
 		irs_setup_pri_bits(idr);
=20
diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index 41ef286c4d781..f5b17a2557aa1 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -1064,6 +1064,11 @@ static struct gic_kvm_info gic_v5_kvm_info __initdat=
a;
=20
 static void __init gic_of_setup_kvm_info(struct device_node *node)
 {
+	if (!gicv5_global_data.virt_capable) {
+		pr_info("GIC implementation is not virtualization capable\n");
+		return;
+	}
+
 	gic_v5_kvm_info.type =3D GIC_V5;
=20
 	/* GIC Virtual CPU interface maintenance interrupt */
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 9607b36f021ee..36f4c0e8ef8e9 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -45,6 +45,7 @@
 /*
  * IRS registers and tables structures
  */
+#define GICV5_IRS_IDR0			0x0000
 #define GICV5_IRS_IDR1			0x0004
 #define GICV5_IRS_IDR2			0x0008
 #define GICV5_IRS_IDR5			0x0014
@@ -65,6 +66,8 @@
 #define GICV5_IRS_IST_STATUSR		0x0194
 #define GICV5_IRS_MAP_L2_ISTR		0x01c0
=20
+#define GICV5_IRS_IDR0_VIRT		BIT(6)
+
 #define GICV5_IRS_IDR1_PRIORITY_BITS	GENMASK(22, 20)
 #define GICV5_IRS_IDR1_IAFFID_BITS	GENMASK(19, 16)
=20
@@ -280,6 +283,7 @@ struct gicv5_chip_data {
 	u8			cpuif_pri_bits;
 	u8			cpuif_id_bits;
 	u8			irs_pri_bits;
+	bool			virt_capable;
 	struct {
 		__le64 *l1ist_addr;
 		u32 l2_size;
--=20
2.34.1

