Return-Path: <kvm+bounces-67610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 646EDD0B8C9
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:13:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9BC273139578
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06CFA369236;
	Fri,  9 Jan 2026 17:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OlPmc629";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OlPmc629"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011007.outbound.protection.outlook.com [52.101.70.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FAA366556
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.7
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978360; cv=fail; b=AA4zVjI1lvY0ff5EMwDadb/s06uj4rGwlpeWKOhYzlLuUSZSiZIyeVjpVhRjpVm4367gUTLsjemouSBJo/zXB3a3wHvmbndIHYamV30oeiKwwodmFzDndFMa0oMvpH0WkdsbOR8F0orA/6Ss2Mn5idjwo4ecHvC6Xzmw3jFmrOU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978360; c=relaxed/simple;
	bh=aKvPPe+y1AU95NVWgQGaufm26tCYOD/hBBwNepGInf8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oKAyQSSjJA0xxUkSgvpLwe3RfI4H+PszKrOzgriT1ZZ66fWjTyd0Fws0msA5ZVMRxa+MeAvOPU+xSxYbEXtCa73IEaVoHwexlA+30ctX/Oaxe2LiYYrEtJ+mBonCEcbewLsS6pngWeukQ8S5r4u3OlHg+OISb9vJvwUNwpFu/jI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OlPmc629; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OlPmc629; arc=fail smtp.client-ip=52.101.70.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=e/6ABF5BEFro19gbYiO2HwtvOp9AC6D4lsV9cbTl9pLypysE5YFQb++dL4xGMrunoygz2URrbsX94HGuG0NJmQBcAHgcZsOubsg9v2rbWvDS16VVHEQxWOQAHXXRZYF1sBG23MWQDxKGzZ/ChNsSv45xxL1z8t8+5VpSh0mWDCAOV0hOXMUPI97roELNMedPfR1YJOpqpi4EomryLw2g4ko6a/558mldsUtMEj51lWauQqrWIajaVdkv6CysaaejPoTYGWqH5qfnKHp4d6TNUgN5PeJbA0bYEtXDEubyExsaoHUNJxymw0bWw6vY4VXouPlVmU813KkF9l65iGq/kQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q33Zq4pfB2ijEVnHbaG5iTBtMBf61aGS3uzXEcqkcSc=;
 b=RfgPrJ3Qll9Z9uhDhSU2i1Du2d+OVn515oih+9HW1YoqORzpGbyjrEb++OfVqJGCebD2nlZkIj/RglCOZQNp6/jpaWk8+QXtvK4t+S7vxcUNSblqnq28yYSTT01c3n+mfMofmSyTcBBuZ8/NwLCIFRFue70WdyapHtHPwqGc85+ueovsGEMcCtCyXKP0W905/uI29cANCAUL2SZCL0DoMZ5NJG4zBMfVJvXTwLvaj/ItiZCEWdoWaLPvWa22dGBvvyjsd832J+Cad1aSsDAfoiWTKVQ9Y1U9lbD1D0u7RP4XlFhWnkKerATHcQpGK62dpbqauh29GMduDN9IO/22eQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q33Zq4pfB2ijEVnHbaG5iTBtMBf61aGS3uzXEcqkcSc=;
 b=OlPmc629KA06Bqlb7na7jxyjjWtFC4dAho9N2QoupOH2Zimy6fI/nUeYZFOIo8pcPsxub26LcOtSG7coS0/1aobaOuCXUyuAP0fxcYquiWbGSobKfZa39RBo9irNE9EowYzyqLEwvAmrk2S+ozX9ubRNTcGHKdpkQxutx/wsozc=
Received: from PAYP264CA0033.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:11f::20)
 by GV2PR08MB8341.eurprd08.prod.outlook.com (2603:10a6:150:bb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.5; Fri, 9 Jan
 2026 17:05:46 +0000
Received: from AM4PEPF00025F98.EURPRD83.prod.outlook.com
 (2603:10a6:102:11f:cafe::89) by PAYP264CA0033.outlook.office365.com
 (2603:10a6:102:11f::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.4 via Frontend Transport; Fri, 9
 Jan 2026 17:05:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F98.mail.protection.outlook.com (10.167.16.7) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.0 via
 Frontend Transport; Fri, 9 Jan 2026 17:05:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VORUuPP9+sQndHIQnyUUFQ+9mQXEqOF87EsEHP0FIjR/i5maq9PH47ZTIbA09jWuv91CZ5UwXA1wuvQZllyzqIbeIndUOx+Tukq02QzFs6qhXNP7MModLyNbvfM9rb+GlLdia1Mk8zZ2MmuL1pQFg3J8wop7kT3A1eEEaftktKFpG8IdMvCpO4p3jdYYr5GUSL7sn4fjpjdFOsTrQc2lm+QHMPCKLW9R8PpPFTYHrOeCVHNYIr9neLd1Og9ox/86/L4CtOLa9FZbRDwv6ijKGIDh5rfCHF++fCpiCcSPqswNz4j5/r+gURCEZ77Eckx6W9CwSKMF68oPppE+PKm2Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q33Zq4pfB2ijEVnHbaG5iTBtMBf61aGS3uzXEcqkcSc=;
 b=lJ+CpyoW3Gn36qGeKFVYZY4YLwzNOMDepqkQv7IVx1d0qaE7loARE7RFTQfeh844W9Mb2G1kGWHvoELbVSayVWKcT/rzzMz7xt4yA2PNx1UKebzLQ1Y+oBbZOmbzc+5MrogqM1btFuaOj62/UVWZnvnl9bE5h9LOKYsN7R0eAWrkaNqkrsEe0QHG2zOupMLLKuyEucoZWHQqiai6gxFBg0qrZ+FNRAXMzoTDhpI0N2mHvEnHtFm6cpwhwC2W9nAlfJz21q17q7mm5mF7LOSc9NVa3hcxhI1iFoAPYrqfLyFwCQhAnpCAx8kJhKLrvZddey/YcfO79YOo98fhECZQ1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q33Zq4pfB2ijEVnHbaG5iTBtMBf61aGS3uzXEcqkcSc=;
 b=OlPmc629KA06Bqlb7na7jxyjjWtFC4dAho9N2QoupOH2Zimy6fI/nUeYZFOIo8pcPsxub26LcOtSG7coS0/1aobaOuCXUyuAP0fxcYquiWbGSobKfZa39RBo9irNE9EowYzyqLEwvAmrk2S+ozX9ubRNTcGHKdpkQxutx/wsozc=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS8PR08MB6216.eurprd08.prod.outlook.com (2603:10a6:20b:29c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:04:43 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:43 +0000
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
Subject: [PATCH v3 12/36] KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs
Thread-Topic: [PATCH v3 12/36] KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs
Thread-Index: AQHcgYoMtL6cCWOtMEmcgqUMbByYFg==
Date: Fri, 9 Jan 2026 17:04:42 +0000
Message-ID: <20260109170400.1585048-13-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS8PR08MB6216:EE_|AM4PEPF00025F98:EE_|GV2PR08MB8341:EE_
X-MS-Office365-Filtering-Correlation-Id: 88c27aa6-628f-4755-f501-08de4fa154df
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?4MN3bMqyihyh3jzWGL2VTONvIWOPDuUfAuoYhgzMKaN7MoykXhrAxp94Ot?=
 =?iso-8859-1?Q?G53aVRyvreLxyqchb3JlXalRmI4RWXSUFSXk75/pcjiK5HunEZHuAAMNDb?=
 =?iso-8859-1?Q?baf6oT77Fvy2zfN8U4SMJ6lGNU3mZ/X9PAPfdg83Zm3iEEkHN8dS5eGcyQ?=
 =?iso-8859-1?Q?xzfN7kFcZ0Bd+xGor+7eMH4hKwCohUQYJ2/JmDP174BdrIGgftXiUL8wsn?=
 =?iso-8859-1?Q?muVuiDEZ4GjMR9cks2/uJB9ZSHAHyJ27nc3cVzaMjjMERhLcVNTfvSFTc3?=
 =?iso-8859-1?Q?r7YdWTipJoPyJ0/mNJzBDhlozy034PsmRaWvFehGTEqDVnYnHscbUysoES?=
 =?iso-8859-1?Q?f2S2EVCon7grsLKNxFS3uXWcJTcj3BLYFWOn/yBO6G2MNxv3rO17IOtQhn?=
 =?iso-8859-1?Q?aiirtYY9/rqpU3/lC/gdLnGi5dbUcwcWFad3Af8Ntp7C7wpNvXTTmWyV6H?=
 =?iso-8859-1?Q?dP7/gedNsd4qOLJ8wE2Xo1i8WbCtwpmOS95dPFA1vcmWtW6IEp4MGOaPOD?=
 =?iso-8859-1?Q?PCjFDd0bA2XmwK/2LhkZX4CFxLTj6bV0N2lZQG6naVn9H5vsz8xN1lZBRF?=
 =?iso-8859-1?Q?JZvqG4a0LzKsvfK3EQUCNbRiZh3ig+nmCJISli1kNWG0WcP98BSgl4OOv/?=
 =?iso-8859-1?Q?BLuQzCdYnQ3TojljqGqQyCx1wMDDDNe1FS7G4sr9AS4Wdx+ZbVUm0KGqxS?=
 =?iso-8859-1?Q?iEXYpSSPbDVIoGEMF3qDVdBdvdoCgAIsh4UKO79qLbJKLZvwjS6CZBTLNS?=
 =?iso-8859-1?Q?+ptdzGQ7k3Yj2mpzJMKnoFllbSiQPrp4JEoqzB5V3dOflWJvvz0KHbK8fc?=
 =?iso-8859-1?Q?ZO4LH6fIPnVbSqKRM877LxTAQW71/DU/yXZta9BfMKBso1poJ4PQvqufW6?=
 =?iso-8859-1?Q?TFjSBLmb1tUvsdG93rQhRDz9VdImsSVTcdECw0EEo64wLydXZViyQiOcK5?=
 =?iso-8859-1?Q?b2o6n5tOxdnWGAuJKPqQcw4e/vLdI1DOB80AweJpM7ABV5z/as4HCij/sx?=
 =?iso-8859-1?Q?4WLEt9bSJ2HODrX4WQRhiuJkbHH/CxV1dTkltt8IEsYbHsBX5Ic/4E6Qmi?=
 =?iso-8859-1?Q?jL3IJo6n0RYtEZ7ts8bP4BpdSw00dsWCTzeG8zwsIt9s+Wh4zclEbdjYWL?=
 =?iso-8859-1?Q?r22tXDRNYJZNOnmYFSHVuft6+9mGqQXhaSoT8UXNcdUVLfiBm89Dc1ovzd?=
 =?iso-8859-1?Q?fAbJiGQlAaGOXLSrohH8IvMeEVFhqU8eo1aACPH7ao1JsKiZIfAydmiYyj?=
 =?iso-8859-1?Q?qAvc5yei5rrpPyQaitlbgEMxUZWrWq5cYiGgScdmC3aMjURWa+U3I8yrWe?=
 =?iso-8859-1?Q?tcm2A2i/9AXpbwQ64eCgXM6fTSf5hLXCP/hmphdv01zWwkb2NU3p2ASN/n?=
 =?iso-8859-1?Q?kHvTz3bcDbvf3ymvsHYjo1R0AemqS4gbcAi2I5GSMPYDjR6eVQXpBeA93q?=
 =?iso-8859-1?Q?4wUBMuRnyCCNnRhHfwJMdhz7O2KuwSM5jQs2+0fwElmzvQgBBb/66DTgvC?=
 =?iso-8859-1?Q?AlQDDkGrxJk6oheCigevgot1X7LDE28vt7f1Bw5kvtHBvLoP1QataXhoDv?=
 =?iso-8859-1?Q?GFsD9FuldXqTtWbcOGNMju26MqYe?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6216
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F98.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	12b4bac1-8242-454d-7bc0-08de4fa12f04
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|36860700013|1800799024|82310400026|35042699022|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?P+C2SsqO3Xs8J0gsIaU4fbiyTBiZJUYP5/ox0dY0/JlIULE6RS5CNazSq+?=
 =?iso-8859-1?Q?1UYZBtDw5cyb4m0zF8UWcBJoGoG2420s90RAss/766g/GFNM1uncSVJi1t?=
 =?iso-8859-1?Q?RkG9TKrp40BJPFCE06zZ/YjTqbfk7Y277tGFVGMK5mHu3i38olzIixCyjL?=
 =?iso-8859-1?Q?+J1/W9YeUo+ZQjafMcbOeDPakC8vxLNLSOaPVTytzkyh6o9OzKyxZ1cMMq?=
 =?iso-8859-1?Q?/mDxZVqclaKovrs8Kljv6wBg6rir6v3na5xX42jESlhfjllpsWrxJEAI0F?=
 =?iso-8859-1?Q?JHskO4yUYU8A/xm80NadV5ZSaAXZigELWJNMUGoBOwxJb6rJ2Xn2z4YPnF?=
 =?iso-8859-1?Q?eT1XDmIo7/KVyjuIisGbu/rTvC36xhCpz1eDvNboEaSme56+yGruy0B+cj?=
 =?iso-8859-1?Q?ZJlJToKpmIwImMcF+EqZaKJ8RywxlrDnxFzBD4qxUI7yykQz5UdSN1urG4?=
 =?iso-8859-1?Q?VdK18y2mq+ahIFr2mrZoW91OGRH0Sm04qpKhZgz/aIf7zuLeSjzK7VrN/L?=
 =?iso-8859-1?Q?Z+GDaCZw26Bj+UaK+oT/TzaUeWSGbx6xYEgTaCpNi9C2zWUuDpPWfJD1KG?=
 =?iso-8859-1?Q?iG1xrIi1x3jGY6dNYf5IrABA5vecqArCBDJVtfA1Rksnlr5AZBh/5kulEX?=
 =?iso-8859-1?Q?djeNGnH5VKNhhXIwJCm2F8oULPxBazI6ryo3AZly86SBy36Mb7H2YevIok?=
 =?iso-8859-1?Q?h+iwKtCNQXlXPCKKDtHkYDeR6E6x/3a77lf1hcQqyNHL0CEe/dEAGkOXp0?=
 =?iso-8859-1?Q?eqojJn4Jkqt1xE5OE5DBXtHPBAVpDGp217WiFO4UVmvN+cPKYNhdv0eg/W?=
 =?iso-8859-1?Q?Zj5bU5E6mkM6EtxKoUhtAOFP9kAU8YtK17J5uvsyLlk4EhGcVVRgh5eGcI?=
 =?iso-8859-1?Q?F/RCCnrNHqfSGtXRo0VgPDdmfRCJpF2c96MBck5HBgXOdy7BSQnYix6zr1?=
 =?iso-8859-1?Q?YJmjpAfYXFMpVYpsNyLB53ESDZgsO9p3iV82W0a3d3CQAXyC3PSLvRm3Ty?=
 =?iso-8859-1?Q?HslseN6DQ4bEHQoSUqpKBmkHBJKdwGB9Dxb2lj3GHRMqPSNFd1mnuRQ9mJ?=
 =?iso-8859-1?Q?xA9BZ9FjYVrDEa+202WhcI60L0ExpM7zKp5Ra+XdLrT5zUcJYX3rrzBynz?=
 =?iso-8859-1?Q?TSV4pM8iPdLu1h8Xm72dGFHa+M3eXkdX/O68YPwULBeTiLTABcjnX7N8EJ?=
 =?iso-8859-1?Q?KojKgmKLfAYSTPpXC52GUVVvBqxyV4UbAzf5qmt26hQR/hHD2IRgsKa74f?=
 =?iso-8859-1?Q?26RueWcze9MmAuzuVBkPIHPAyL0wlxDk2vHa1c3QS07Am99BS7OZrUhvMT?=
 =?iso-8859-1?Q?zh/8RDZi36stVMPHXo/kcAA48smcMjeAyBovxC4FzNAQoB6/UXx3hjvc+I?=
 =?iso-8859-1?Q?xM7EZEmldnYoQDqixIIvDMgKIYZXSCw7Ytv6ggHTAAY6vc6ePTUymAJBzf?=
 =?iso-8859-1?Q?h9o5j/zLzmTtAYOak77zKFEP/8xGM4nZM7Eal22suf1zm2cXgjN/uZjvJF?=
 =?iso-8859-1?Q?Bb8NgWcrayx9pRxvoD0KW9DcNPWxfVwdj4/n9u4Cja2hypipDHhg5UiOjY?=
 =?iso-8859-1?Q?PT9nG/OK/J/Dwh9K6ZuJTHbLlnW09jRwA44GEmiBVP73d+rzWjjnRRIXmY?=
 =?iso-8859-1?Q?EN5v/M2h24zlo=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(36860700013)(1800799024)(82310400026)(35042699022)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:46.4525
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 88c27aa6-628f-4755-f501-08de4fa154df
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F98.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8341

Extend the existing FGT/FGU infrastructure to include the GICv5 trap
registers (ICH_HFGRTR_EL2, ICH_HFGWTR_EL2, ICH_HFGITR_EL2). This
involves mapping the trap registers and their bits to the
corresponding feature that introduces them (FEAT_GCIE for all, in this
case), and mapping each trap bit to the system register/instruction
controlled by it.

As of this change, none of the GICv5 instructions or register accesses
are being trapped.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_host.h       |  19 +++++
 arch/arm64/include/asm/vncr_mapping.h   |   3 +
 arch/arm64/kvm/arm.c                    |   3 +
 arch/arm64/kvm/config.c                 | 103 ++++++++++++++++++++++--
 arch/arm64/kvm/emulate-nested.c         |  68 ++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h |  27 +++++++
 arch/arm64/kvm/hyp/nvhe/switch.c        |   3 +
 arch/arm64/kvm/sys_regs.c               |   2 +
 8 files changed, 221 insertions(+), 7 deletions(-)

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
index 3845b188551b6..6e8ec127c0cea 100644
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
@@ -1510,12 +1594,17 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 	__compute_hdfgwtr(vcpu);
 	__compute_fgt(vcpu, HAFGRTR_EL2);
=20
-	if (!cpus_have_final_cap(ARM64_HAS_FGT2))
-		return;
+	if (cpus_have_final_cap(ARM64_HAS_FGT2)) {
+		__compute_fgt(vcpu, HFGRTR2_EL2);
+		__compute_fgt(vcpu, HFGWTR2_EL2);
+		__compute_fgt(vcpu, HFGITR2_EL2);
+		__compute_fgt(vcpu, HDFGRTR2_EL2);
+		__compute_fgt(vcpu, HDFGWTR2_EL2);
+	}
=20
-	__compute_fgt(vcpu, HFGRTR2_EL2);
-	__compute_fgt(vcpu, HFGWTR2_EL2);
-	__compute_fgt(vcpu, HFGITR2_EL2);
-	__compute_fgt(vcpu, HDFGRTR2_EL2);
-	__compute_fgt(vcpu, HDFGWTR2_EL2);
+	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
+		__compute_fgt(vcpu, ICH_HFGRTR_EL2);
+		__compute_fgt(vcpu, ICH_HFGWTR_EL2);
+		__compute_fgt(vcpu, ICH_HFGITR_EL2);
+	}
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
index 5fb7b4356b287..41699042a445e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5633,6 +5633,8 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
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

