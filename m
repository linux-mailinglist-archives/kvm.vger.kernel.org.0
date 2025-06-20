Return-Path: <kvm+bounces-50120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D8A2AE1FCE
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 18:09:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1643D17ECA8
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 16:09:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAC202E9738;
	Fri, 20 Jun 2025 16:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dJaEZKf7";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dJaEZKf7"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012040.outbound.protection.outlook.com [52.101.66.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FE12DFA35;
	Fri, 20 Jun 2025 16:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.40
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750435713; cv=fail; b=k0QHdQ0hD076ZeHDDtzjUeusbrvoikVfbFhke+KpsYFzbbGKZeVn1lw4uAQQ4e+Isu3Irwd1K1/y+ZKmiAHjJv5O+tNMgfHFYtnbCZkbsSFc8Av1pAE//doadL4oGi3j5BiPb9UsU2nFYa3WmSAirXz/wY0gfNAUt3JP3hVrevk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750435713; c=relaxed/simple;
	bh=6T3zU3ykp6ZocYmSvCsnBk0vCpzvDHlAo7DUvticcFs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pyrk5HwgMSv+aKhfVrKvYc8Lf+9xNdf4NDh9tRwxzGO+jHVDqngtwhS4uaBhQK3PeNcRehCJwxm0WxHgRnsQOTaKMnmmhr/1WbEil7XfUih4CGmtBHLj/YqMEnQhNDbRUHYvPjDHUziTkHtrUg9G3NTzBBT5RkFMzK+ycuJknN4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dJaEZKf7; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dJaEZKf7; arc=fail smtp.client-ip=52.101.66.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=hCS+VWSBwyXJ/V9VWrP2DaANoU0kbpaw40lKUnAbDbH7rkH+NYo+5mz+rL+syuG4/QVITFDcsKa/YVge9GQY/1N8uCCgLor8nIU+4r9D/Ik9mcAED5aMRvFI9jtUkE01Sk8ibBMy8VbxjEVIlvaIq5XikLwkInsKHGlJe2D4ZAErhlEu4hB4rKTk8/5u5uL57prZsDoslWsBpXuYhXbRfVsjIWrKs6YrbUXiiwSSo86ak4MbPgjWj3kOe1BKl6vFokGwzH35BdW8g0n1mKqT38h77DzWLFZkzF5I4g9ycbj36ySizOKQhNex0cx02MVtvp06ptvS4uyzUz7H89OSPg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1dw68NpwQR9fegNGtN3zsHSuLn+pyiAshEG2fMZT/ro=;
 b=d5CZp+h3Cm/gBELf0Pyb5HgJwhAY73yL7Iw6aems5WCctaqZYhkCQXav9cJz+ba0t9vkg0VAonuz3BiWVmRwzyHVNk0s8EEXr6w+4919eUvqVTw2rjU255Q6HGI2yKdUd0qVZCC172W4RvQXOCk1i5NSDBkeabAqkJXbk+XhJcpIv9yqntwaB+mZwZSDjrL+p86EXT77ESIP5oBVEPk0QX+sDc839UgHM2T3Ytt/H0LUaLy0QaDGTRr+Aqv4mS2p2g4hpOl2FLkL50RgtGOumKf+GTSEAews3bMnNfoHvBK91itouRGizdsFoc/bm4XQnRvOA1Km8TFEHE4TkpkXVA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1dw68NpwQR9fegNGtN3zsHSuLn+pyiAshEG2fMZT/ro=;
 b=dJaEZKf7ogXwcBlL5o/bXURoj8fD6ab23O6XWvPMwSh2ANFMeH/n7nCiPegrwuFKF5Q8haFRJ7ifZX4jQKC2SkqQARlp9qNb2GVLJwlXtOyCAdPDU1u3sAM2LzQvD8jprCzLumJpyXIq84kYU78qskgK823q1t4VpON1pFumjl8=
Received: from DUZPR01CA0338.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b8::8) by AM9PR08MB5890.eurprd08.prod.outlook.com
 (2603:10a6:20b:281::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.30; Fri, 20 Jun
 2025 16:08:26 +0000
Received: from DB1PEPF000509E8.eurprd03.prod.outlook.com
 (2603:10a6:10:4b8:cafe::bf) by DUZPR01CA0338.outlook.office365.com
 (2603:10a6:10:4b8::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8857.25 via Frontend Transport; Fri,
 20 Jun 2025 16:08:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E8.mail.protection.outlook.com (10.167.242.58) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8857.21
 via Frontend Transport; Fri, 20 Jun 2025 16:08:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bJUT/bvv/79IKrLED6eCfUbBGYYPkdaIXa6STk6wz9X/MFiOAgk6MQf4l20HxMm/9TWnHrODI+5A+taNgsnjnxs9whyuLQTT9O506VueKo10I1U1TPifrSAp3nHv/gHPdfrpQAE1vwYK196m+KOgk/6/l40bbjGZkwFBPe7c1+G5GfQluH5LGIM/xTEzExJ09MVpAbv71k00HpgTR0TlDZEjZ8E7B7BtC7EUZ7emn2oug854J3C90cJ7LQg/+ciCmukfJG87QBkRpSLq3YEqAN8mjUOqulAdnuZZ0Y7F04M3CQAlhF/VQLoazPDbnQ10cFP6eyBMzqw58/oZ1On1Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1dw68NpwQR9fegNGtN3zsHSuLn+pyiAshEG2fMZT/ro=;
 b=sz9wIcl+hUxMBzZxdMirlpy9KtCNsSX5NpFUVbBDKgpc/jiWa9lIJ5NfLacB5RJYJtaxWEBmGRW8EdD4IpWrjPHrm72U8MC6fySSOXEVT4LQzTJ4MOZJ1cuPpfRC2/NqDA2FMAoVD/PA3flaF943F7KalTeV6bIn/miG81hdBaPhhldVyl/JQSBI13fc6mpBuBQ/7mZO6rgvSgLShrDCHyvhY2brkm3ump/Z9PaWIxh1urO9K3pKex9/ScFAJaLL6Dp90I456lNAwxQwXfAY75L6PaCK0yJjHLjo4O67FkRdeHrobV9hG2PIaz//BgrKw41UH0qYGQ1TUOPiUUcoiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1dw68NpwQR9fegNGtN3zsHSuLn+pyiAshEG2fMZT/ro=;
 b=dJaEZKf7ogXwcBlL5o/bXURoj8fD6ab23O6XWvPMwSh2ANFMeH/n7nCiPegrwuFKF5Q8haFRJ7ifZX4jQKC2SkqQARlp9qNb2GVLJwlXtOyCAdPDU1u3sAM2LzQvD8jprCzLumJpyXIq84kYU78qskgK823q1t4VpON1pFumjl8=
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com (2603:10a6:10:46e::5)
 by AS2PR08MB9474.eurprd08.prod.outlook.com (2603:10a6:20b:5e9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.23; Fri, 20 Jun
 2025 16:07:52 +0000
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31]) by DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31%3]) with mapi id 15.20.8835.027; Fri, 20 Jun 2025
 16:07:52 +0000
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
Subject: [PATCH 3/5] arm64/sysreg: Add ICH_VCTLR_EL2
Thread-Topic: [PATCH 3/5] arm64/sysreg: Add ICH_VCTLR_EL2
Thread-Index: AQHb4f15oBfCFugVDky51NGrm643MQ==
Date: Fri, 20 Jun 2025 16:07:51 +0000
Message-ID: <20250620160741.3513940-4-sascha.bischoff@arm.com>
References: <20250620160741.3513940-1-sascha.bischoff@arm.com>
In-Reply-To: <20250620160741.3513940-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB10202:EE_|AS2PR08MB9474:EE_|DB1PEPF000509E8:EE_|AM9PR08MB5890:EE_
X-MS-Office365-Filtering-Correlation-Id: ae6e88e7-22ac-47c5-fa1b-08ddb014b03e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?jb288a1TfFjk11q8rv1YaCVg7yENXeUvWBK0e0+dbwaxxpnbQ/kXTDp4PJ?=
 =?iso-8859-1?Q?+shfGq9UcD4Whzjp6H9iLgH2KBwjp0BBZgg2QRRn5CIImseMHeig2YTC0R?=
 =?iso-8859-1?Q?KPlaNjIpJR7vLg+9mY80Pe6R5epKlYfp3wz6do2eaJw/Dp6aVxsEtPaMn+?=
 =?iso-8859-1?Q?PKTILbR942GRbDCV802zoVFkTL+oKyvPGbrisotln61a3E6XT2EbUQtt4u?=
 =?iso-8859-1?Q?ZlakfeAvUCmQP7Pw8unN88TNyj8yA9F/CryM3BZ+QTZzcxCs/8rxzfFZ5p?=
 =?iso-8859-1?Q?HQq7e3SSv3+XC40Te5F8dwqEpfx3ssnabrvaf5ses7kPG9spmeAIDR5FBz?=
 =?iso-8859-1?Q?1cQuzF+M76GK2xa1VjuZNlrt2/7vRXzC7RtxebHBsbB7obYAue2L3aE57Q?=
 =?iso-8859-1?Q?yjJMIaiWnqi5wcZWTl+jDCQ30WNecBIm4v2h3Pa2c+hJoLnDToqtmB9FVE?=
 =?iso-8859-1?Q?t5uQdDidmjmDS5nYzONMS/EOnEhchvAJlXIh2a8Mv2AHBBmCgxj5F1/3fC?=
 =?iso-8859-1?Q?5iJix4Sh3RRf0ghzmDoDatldybSqqUL2z46pJAi+oi57REVb12/3OZnIt+?=
 =?iso-8859-1?Q?r6JgsucismJnD4GoFOXPOAIT3vh3AtlTE0hZO2bTRn62TRmD1OiArwDIYC?=
 =?iso-8859-1?Q?k7/NT5op0cDWuIoB4q3Q2wTdb0Ke7a10NdESfwRvBdbCqLP3EPhPp/83lL?=
 =?iso-8859-1?Q?MENmKnEf9YGXZh98g8ONkjq+YTGg1RlCkBhbgDPUSTdb4Hfmm6W0Uj0D3P?=
 =?iso-8859-1?Q?dSMbJdCfM+0R/YCCAYCMsVDGCkHq2eVe3IsXx0E8V892pe79iw9J9GcYYi?=
 =?iso-8859-1?Q?xd89LXl5kOh0+7kTGyygxxs1QG1CT3xbp8ILJTDaiPveutZLO9VY8VKPj3?=
 =?iso-8859-1?Q?OQ2Jl+4uVd6Q9KURmqsELK+yKYSuucT6d4qstvNgZdXcnm08XLNuH2+c+R?=
 =?iso-8859-1?Q?AXF4ST+vJvT/wv4CXL9J6ka8FuKuriZcBzKrkvlX3TwtvmhIpjxt8/Pu3I?=
 =?iso-8859-1?Q?56JUl+dXwLKo7Ox9YmxCQjw2HcXgR6P+Wml1YedBXjcqSa1BL2ksTehOHF?=
 =?iso-8859-1?Q?UrLeYE7MChzHtywKKj1SGrWAqPb+pEp6gLK8hs6hTXPyobkeR/4yBCrGVX?=
 =?iso-8859-1?Q?uscrp/dUNoodW7+DU3MT3WZQ+5Yj36DLzNsK12uWlSvtMdFtdgeEl6W5/S?=
 =?iso-8859-1?Q?UYiPtKgDPoyYmrkB71Pdr4PSGPx9Ug9QAcV6Q/nCdH1NaHVfqvGTMWyW+8?=
 =?iso-8859-1?Q?Jqkgc7nJAN2yHtUR91r2cVrTPXkHcTp3puy8gpwOovzZII5d/0rsu4it3N?=
 =?iso-8859-1?Q?hB6AOiG8ATP3Aij0WDWadBmfvx5OaZ+ByoU1JHO/s0Sb00K5M3JofHWJHh?=
 =?iso-8859-1?Q?BoRRd8FKk7C5AFZi40IcA21wElZOfSUAsnCBThK7FOu5cU/GuQ+Trz9Hzy?=
 =?iso-8859-1?Q?tbFBJ1ecCaTZllIqG9voGp6iipuY4cPSoLEUyJANTbOPyoiW73OovIEh+M?=
 =?iso-8859-1?Q?91PsgdRO/U2qW2SO3igdKrLrDLC5389ebEeOVTOasnpswX3ewKKnyZvwxp?=
 =?iso-8859-1?Q?c4VJfdA=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB10202.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9474
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E8.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8de30d38-91ea-42cd-c5b3-08ddb0149c12
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|7416014|82310400026|1800799024|36860700013|376014|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?/JEBfcVOo73GO5PBd04MuMtHl8nCpWX4hsi5VYgKFu57YtOT/V6QNgXuXw?=
 =?iso-8859-1?Q?HOQHzNfJAW0TgiLHhZguqPmonNCQBbOgcdFwVPMKX1hFuYb1v9WfGbx6nb?=
 =?iso-8859-1?Q?ei3V4AnTICvUBHgh/ZjxmEv1wbOBFluNqOU/VzrK9ejk4JKbBqdIcGUNqF?=
 =?iso-8859-1?Q?2S/1kmiiaNzMoJ+tuNgM91D0c7dIgnF1jm2WPF00LARNQroKFrarnSraoe?=
 =?iso-8859-1?Q?V420+CMjoe+vQuQ53swVzKeft8TV4lnTuxe2o4snHx1R67G++s5ljc6fQ1?=
 =?iso-8859-1?Q?i4Pu4P7zRTLpLCqMkMvchy+RDob5XKT5KuhVyWtkhfxMX5sPb6WfLmJKUf?=
 =?iso-8859-1?Q?Nv0CrtczrPUdtoLiyJMB4qv22lx5HdfeB+KQCWyXSw60mfi9e2CIRMQyGy?=
 =?iso-8859-1?Q?qVrZLFBkpDgPUBOuyAVN5wO0y0cAaWVi30NgY0ddzZF81/Ew+Vmrp85qft?=
 =?iso-8859-1?Q?YcDRFB9c/5qVF1y2AJk849AphY7ADV62RwLgmP92ywhM0C1DVfvDf6XEHP?=
 =?iso-8859-1?Q?tWfwqpUceBMZVsZot1A9zMDxAOs3QeImzu4wjcVFOc+vqvMcVLW/0xfgEG?=
 =?iso-8859-1?Q?oEpzmkhkkNKB83CjY6cD5IOSpuoBlYMNq67HNt9pSUhfqD3vIJ3NX1T1Af?=
 =?iso-8859-1?Q?SVL+iIoueMT6sAepXXTVwglyL8Ksnn/yJ9VmR38AW/1uwjwQ+YNyOw53ot?=
 =?iso-8859-1?Q?lKm+n9HVzbh4zkm2HSrK3eSHS+HhBV5EX2SEUwUuLpUkN8QGmy/B9SO+wr?=
 =?iso-8859-1?Q?WkiU+0IAs+QA8PLqg7UoScqItengvbPzjqM2Simr/SuH1by56DeRzKwyPa?=
 =?iso-8859-1?Q?+ApTOtY4BXVAM8dpNC4nsUyzT0pEOfFGXCdHVxwuS4+M0fLFUw5O369pu0?=
 =?iso-8859-1?Q?iQwOMtpcviLmA4gxR+xQLNyy9nk11PqLXv9OiArOLJ3bVS/Nne/H8CXJ1d?=
 =?iso-8859-1?Q?RS6jp1BbFB667AaYKBg5a4Sp1AdFxUFCneg/Tej/q4ibckZHCX2gZa3gDo?=
 =?iso-8859-1?Q?3FV5x9dEe11CzwyXHpiuXHKXYaYKi1rQvcuWHgauQM0cKjRuoFRU8k0vIZ?=
 =?iso-8859-1?Q?qG5gqEHY0KWHR7WAYNevNB+47Wptd0Rxzn5kPwN+wEtINjbj41URgIOu/b?=
 =?iso-8859-1?Q?AAk9c+VkdnI+RU6NFFKK6Jd55OvdwJGM+ENhboBcuIUdzFWCFVHNp+5seR?=
 =?iso-8859-1?Q?RYHW9hix/32QP+4O8zF3+Ow23i2gc0gE4g7nZf7vc8IQh9O4w94ogIUQco?=
 =?iso-8859-1?Q?oXx1XLcn2RydIKQj5vsGRSynv0B7XSBGW5uPIoLAK5Ond9lk2HQmbSleXu?=
 =?iso-8859-1?Q?UCxoo0zcwyEoKpEh/+4YIEw31PPYGdlCYw/gv01QjPHv4d1EIaDVPmLm+/?=
 =?iso-8859-1?Q?ELFtVAoC5KL1u4ZWuf+/n5zylxTc4GXdjtvzpiAwhc6klyGzhBZ609ILRz?=
 =?iso-8859-1?Q?9qmjXJ9fCAYCiRvLHef+b3+VGUbakKOI5erMKXaGq8jCYz6hlt546+AAZF?=
 =?iso-8859-1?Q?PL9xtdYkLmAvIYNgOOcpJ08EY7TXJyj7RoeOucWgKBAZvEYCl5pUGmrAoQ?=
 =?iso-8859-1?Q?H8Px5w8dPAOqnHa/8Hsk9bIDWvMP?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(7416014)(82310400026)(1800799024)(36860700013)(376014)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2025 16:08:25.8245
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae6e88e7-22ac-47c5-fa1b-08ddb014b03e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E8.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB5890

This system register is required to enable/disable V3 legacy mode when
running on a GICv5 host.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/tools/sysreg | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index aab58bf4ed9c..dd1ae04eb033 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4530,6 +4530,12 @@ Field	1	U
 Field	0	EOI
 EndSysreg
=20
+Sysreg	ICH_VCTLR_EL2	3	4	12	11	4
+Res0	63:2
+Field	1	V3
+Field	0	En
+EndSysreg
+
 Sysreg	CONTEXTIDR_EL2	3	4	13	0	1
 Fields	CONTEXTIDR_ELx
 EndSysreg
--=20
2.34.1

