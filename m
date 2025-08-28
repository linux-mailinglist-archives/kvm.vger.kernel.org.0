Return-Path: <kvm+bounces-56087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 829BBB39ADA
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 13:02:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 84B821C271BB
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:02:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39CEC30FC33;
	Thu, 28 Aug 2025 11:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="l6KtxoNV";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="l6KtxoNV"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013057.outbound.protection.outlook.com [52.101.83.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1706D30F520;
	Thu, 28 Aug 2025 11:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.57
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756378829; cv=fail; b=npSqlprDqSOHX5NNei5eteetsASKqWYui06lEirqw9TR65KXqKp2VY70S9Jj66HnRBsx5POUEpdp3oiucBYf5me85/OZaJVwi0ISGt1vcJojoJ8h7lVZ3kSug3YiQoTxgzf5bpLLjQSCeTBnL5fxZRnEkwG7jr3ciOAcZRTpjX8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756378829; c=relaxed/simple;
	bh=vWIm/gpauHnkARUTmbtgqsUrovezeuFJejw9ji14pRg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ITBLui7gQhefWonVkbi2OIhOYK6l6rg3xWU65Et9ZXl7IpDe5maa7M+/7VtX94fUDgSFZ+lUIXegCf8SUAv9jdNLoGUOb29AQjIYLk8n7Xd8Aq7jq1U9ceiKFm1vaJTnFj0Anlh6SBTfnbbipIy5Ixr/bss87c+SRHasdFxjtNM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=l6KtxoNV; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=l6KtxoNV; arc=fail smtp.client-ip=52.101.83.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=tAICki53tpmbwblznkoVkXmaFEu5EVP3OOAA0nO9hPzo0h9jMq3dJpUmR8E5ag/XYtRAiPqs4cJpRB5ZWQJYL29BaD230P8a+y6fMyHNXda2D3Aq82rkejPjEg7CLXKqSZM+vJHU3+BIv2a/gR99CcjgmVlJ7pLaICF/gajKmqgPItxAUG9MDkUOnyNUSreKOmImAIRBJJJmfjE1J60AqtuZ+8ZMIjWzjZ9EdGAu5ChUm5HigYOFUCXVTKD5F67OCLgx/mjbrd1NjpwDUjWnVnuHHDVb6Nk8JzdACV5ld873Tn4Vod5rlFlqNWdV5aynPCp4oZMSPvrfKPR5KauTjQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=12/J5PiADaIlxQSne7HTtap20AYzfUvBVkAPYfQ765Q=;
 b=F0SFkBHlNmnWKJm3MNEaC/vlOs3zHJHtY2QBk9bNHpnd6Yvt0EgSpO5BIVEqOikN+SROZTehGGQa7G/hOWok0lBWh68xBmj5EwXnbAB0egBG2IcQ9QFgnanV0YZ3un8C2Jw31d6ownb9sP5+SsOUWPEL+AXgPaeTN52upEKQ3XoW2X/e4bhORGCOukYnMZ0FjmVz5so/Xn1wYf7JN2A4PE8qb728RRIbdLN1/Kv6Qb7uiTCfGyNA/GFs3sVX1VZrb350U5sy2CJ59lPiXAQrrekXdVYYKi8AKjA4YRlSuXPYEkvRTa2GyeApX38VTFtCnI3HlUw+KiMHxizZttRh1Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=12/J5PiADaIlxQSne7HTtap20AYzfUvBVkAPYfQ765Q=;
 b=l6KtxoNVDLy884vo/2V8ZczUP7NXKdZ9HcnFT8aXpTNC1BK4WISTaKXG/d0zL4J086wv1VwVdSUwvP/Vd16qKsCpx5oXmfQyS+0Uy74qB8FljNxjiMjPgddVsd+xR7gbE8Wsc2fMmYkGueFkqGEuNipNrv5J9TkVSIwSb2vdfoo=
Received: from DUZPR01CA0012.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c3::14) by GVXPR08MB10587.eurprd08.prod.outlook.com
 (2603:10a6:150:15c::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Thu, 28 Aug
 2025 11:00:15 +0000
Received: from DU6PEPF0000A7DE.eurprd02.prod.outlook.com
 (2603:10a6:10:3c3:cafe::8e) by DUZPR01CA0012.outlook.office365.com
 (2603:10a6:10:3c3::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.17 via Frontend Transport; Thu,
 28 Aug 2025 11:00:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7DE.mail.protection.outlook.com (10.167.8.38) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.11 via
 Frontend Transport; Thu, 28 Aug 2025 11:00:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sUjPtHqK1IC2p7jIsZ9h7xhCdxphcky+orji69vznI2cTZhrcw1hYbEdjtIuaEErokgeNyNZ62nRRv6lBxvwqj7zkIVCFWcFR5sDi69yNWgnzXjcM/s4jU7k/XbWR3621tHMllEjaX3awW0MlR92i0wR1fhHfmhC1LflmBxHclxxHHAGBjyfGZxU0JZjmkP7npQAtzNMglKmxaXnuQAJw38X6JcDZ7BIjZfWUXuvar6L3ZSGqLvYLcFmKy94TXd6p4rpz630sbCYKDO0F28ak2YQmvHzZndpXzXHUgfG1XJ9oJmtM9RpXIKwi0gzI50jh9BBfIJSKS/dbjEJ+z7n1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=12/J5PiADaIlxQSne7HTtap20AYzfUvBVkAPYfQ765Q=;
 b=ltAm2KHbQOf8tnt4YXxQelC2do/i/8gBYNnuayLifR9oG/f35vhEKKcd+6VgO/diknv+q7qm7RcJXvOEm/M1+gQdaGDlKTXNRhzhImyC31PL5cpe9upKHhGxTHtMEqw0A2YyXWuzByQKiqC5XZlOxZZ6JmZBtw+oxQoPiGxiAZh694UnPQsVcrTzLHYHlBGc+lEQFoq3gNbbRooHDY8Ag6pym41q7MTOUPmEgStOVCIj7wzB322ru2fzmcNqXgn9rgkDq05c8dC1LMB+1rshA0cMAD6TlaZXjuoWJ/X22JYNBpH/v/IyoHkUMbvDHU//ozXoExaogmRJ38RkESUhqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=12/J5PiADaIlxQSne7HTtap20AYzfUvBVkAPYfQ765Q=;
 b=l6KtxoNVDLy884vo/2V8ZczUP7NXKdZ9HcnFT8aXpTNC1BK4WISTaKXG/d0zL4J086wv1VwVdSUwvP/Vd16qKsCpx5oXmfQyS+0Uy74qB8FljNxjiMjPgddVsd+xR7gbE8Wsc2fMmYkGueFkqGEuNipNrv5J9TkVSIwSb2vdfoo=
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com (2603:10a6:10:46e::5)
 by DBBPR08MB10481.eurprd08.prod.outlook.com (2603:10a6:10:539::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Thu, 28 Aug
 2025 10:59:42 +0000
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31]) by DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31%3]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 10:59:42 +0000
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
Subject: [PATCH 2/5] KVM: arm64: Enable nested for GICv5 host with
 FEAT_GCIE_LEGACY
Thread-Topic: [PATCH 2/5] KVM: arm64: Enable nested for GICv5 host with
 FEAT_GCIE_LEGACY
Thread-Index: AQHcGArbejWxh4wtrEmz8XcSS9ZFqg==
Date: Thu, 28 Aug 2025 10:59:42 +0000
Message-ID: <20250828105925.3865158-3-sascha.bischoff@arm.com>
References: <20250828105925.3865158-1-sascha.bischoff@arm.com>
In-Reply-To: <20250828105925.3865158-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB10202:EE_|DBBPR08MB10481:EE_|DU6PEPF0000A7DE:EE_|GVXPR08MB10587:EE_
X-MS-Office365-Filtering-Correlation-Id: b64854aa-a9ef-4bfb-a88f-08dde62211a3
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?JciHyvMTDRaaXxOlYd+uoyWUMqdWJ6ik4vY0lqUZVAfwwmmkuGXdt+gFFr?=
 =?iso-8859-1?Q?OT289BeY2yr+4uFr5+YgnhoHcq4+b4RDJHBGInw1YR4EKQpG5DoqkLnmko?=
 =?iso-8859-1?Q?HAbge7q3gta9I5k1SLRLs8JOmQiPq/dfVPQdUNPBMJ8XSIOChWeTgeSuD7?=
 =?iso-8859-1?Q?G5K2xIGBn4rWDSO5Ud1TVFtg1TYWzN8o24q7yJ7b+LsEGz1czqR+Z3Amnd?=
 =?iso-8859-1?Q?IT0wqdM/doSF1UGdE+taSSzXb3iia9PFli1Q54qpJO9cpwYKuAtWQTqXRz?=
 =?iso-8859-1?Q?788FSzzp3ztCN9FAT7/DxiD3HqiTP80oQ5qGCkHD/NTSsZKhK5sjb0X2AM?=
 =?iso-8859-1?Q?uVHK8EdeKaECzs89GvBhYMihQj72RVwhTx+wEWA4ZzQWa18pkUo9J1aiUq?=
 =?iso-8859-1?Q?EB8YDyijZsmcGLhJM3qbejEwcfaWUiICeboli6WkvsqVBlaMHZ5x9psnCs?=
 =?iso-8859-1?Q?wiEsQSvTvJIssqZv2RNq33eo6j58G6pdidvjTXujPOWxMRGM57lGw69FpR?=
 =?iso-8859-1?Q?nHplbI9TSCF87A9QJLcqefuK8dc+Mb7pN5Cnx4Q6xkunwXxbCyZWCK8Ctb?=
 =?iso-8859-1?Q?L6etal+Ur0XYV551IgFv5fncaqOfhiQafD0MmVHF2bihLtnlvk2aXlUI83?=
 =?iso-8859-1?Q?1qmfLKXGeDjRTMrlgRnflz3Efhin2FO+GyHlBM0s5esk8iYmfr/+YI6b9/?=
 =?iso-8859-1?Q?43tSd7E4HwHW5LKwbmx1cZiXJkcBxbI6t3NnW3vj3YQAYh1mG9eAH4Sfcx?=
 =?iso-8859-1?Q?pAjMDvDSxo7sqmrP3JLU7RyR0vtHGlraA3b86+CCh9IV/ou0/v9+MdyR1a?=
 =?iso-8859-1?Q?v8b0WNiqf0vymx/GiEvDpnxE7b7QJ7Lcn1m5JTgSa6L0WwFpeKBKexX2sS?=
 =?iso-8859-1?Q?fX2+mNkcGPXrdJLvjQcIjRhJggUpACG0tljquQw58mEzw3CfN3I17PmH0O?=
 =?iso-8859-1?Q?z/XIv41ql8sWCgFHK4gHxE9tc7z0NyoFXksH0sF4SeuRZpf72CvEqK5uWR?=
 =?iso-8859-1?Q?emMJdv9OA3WUE7PY/8EPJw0wRuG6He6Xjda2v35tGuQAaSnNUbotRS07wb?=
 =?iso-8859-1?Q?jrXM7UA00klPmnvxteYHueoj39JIWJWpRBEHxHaXgb1NfQxp/H4ZKA94uT?=
 =?iso-8859-1?Q?BJwq+oMaRaSaYkxr0aczFYYUxKXF6VrEf5Dpx/gKrPy4q2wSaRQAQHGD2V?=
 =?iso-8859-1?Q?esysBl6A6frLYg8wKrBBisgDTsMrktPGxx4TrZ6sjtwNHlwPKrj9WdaOeC?=
 =?iso-8859-1?Q?WTx9utsGzXj6i8PNyiMQ5ZRdrD+BdZ5IpKigxstl2edppmkKH1aHQ8YgZn?=
 =?iso-8859-1?Q?58MlgDjNk/bxMR67UfCi2R+ChXp1+IbSAyOtPsJOREdVEptFw5CCY+9+pR?=
 =?iso-8859-1?Q?Gdh0sL3u3EulffnucK5+sl1rF0QxJQaqgZAl3LfZ5yIez6RwjAJJXErvlU?=
 =?iso-8859-1?Q?T41ovzIEb+vXSbPBpDzo1t0dplRNshQL0xDqP+makqg9JQcQ6vt+6EDCwS?=
 =?iso-8859-1?Q?tFDYaJ23lC1goBMmrH4Utk4B8YTxgWrqONNfPNlIGt5A=3D=3D?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10481
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000A7DE.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	dfdc61dd-b779-4405-b3ca-08dde621fdf5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|7416014|1800799024|35042699022|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?MKZOS/qnNQ0hUTrn9kvTH+OWuflzw/hMVNOmGAbPKNXLy3GzjtevnPg3PY?=
 =?iso-8859-1?Q?j7csb0CEDnZ469DQ2ArYB7o2uJmLqw9d11pDfjeXBiOY6k7glK1FH6k8nG?=
 =?iso-8859-1?Q?EXavb+I2Vx9WDOgTw48re/L7wNFYcCZysEFRqA9NDKQGfiNx165Pa3KvZI?=
 =?iso-8859-1?Q?f2/GSiUWGKr+zynRQxF2Q/xgm4O2ZUftvmJVUulqTVlVnkchNz0nzMXHea?=
 =?iso-8859-1?Q?6IZSne/J4A7HHWXmionWPO65IyVj70+yYoNLRzv5B2JLlpIpiETNZ2tCeX?=
 =?iso-8859-1?Q?+mte+eqiTLRloaPMyTIrBytbAzI6zIDqXw0TpQu5zJBKWcvqSWSQHOqQaL?=
 =?iso-8859-1?Q?VkSfq4Bb4ftbyhZslcJhhsc1mUInSjihdF+ED5Bqt927p94p2Xw4iiZU0o?=
 =?iso-8859-1?Q?oRWdda2jA0rlg8tVohCKjkTjgJYPfMHPCCSPRQFC/B/vpLyFzA+4drE/KW?=
 =?iso-8859-1?Q?kwOOYVruiIlNCY9s9Dl9oiNWoVOxYkzlPonTOenQaYcgdrHJOUS1sixBrP?=
 =?iso-8859-1?Q?mgOReAWFrs6yWf7ZXHeFB8NQDSCtt/L1Zlvyyr+tdLNftn4HcVHZyGpBsf?=
 =?iso-8859-1?Q?U91BPeOUZRhUTBe5CO6IBhJaA0NH9Qd35TSp6f5fBYwkOldp+RpqBYesuu?=
 =?iso-8859-1?Q?z/2gOgcb2j+2yyf127Ubn78SfiCuVz9KhfIg7wCKpZa8NMy0WaD7nq4LkO?=
 =?iso-8859-1?Q?+fFRiG6o15UQNjPB2oEHbdxkqSrvwzJLBbAneX+rVmT5sGFH/AvYrpRVOF?=
 =?iso-8859-1?Q?3wNA9XD359/EbgIobkTvpeoRU2S+8cLDICq17PcfwFF62nXkQEHc0k6kQg?=
 =?iso-8859-1?Q?vSRTxlaYL1B9s7WjIADAeLPE0BnQDWDmJELnvFaes8t3EVzQzy4b5zj7vW?=
 =?iso-8859-1?Q?Pii0Aeq56bSoUja94cmJMu4c6odSJNDWChLrvzEgH+2TGVfHnX/LOzgCte?=
 =?iso-8859-1?Q?q62FDmf+xUoEPgyIsjtLQ1ofVEMnnNXye7nfTrcM1P3q0F2DfS7wdYviOC?=
 =?iso-8859-1?Q?Q5G/hVLo+i/Cx3lveomf4AFy4jNzXc3iInnPPhesaoQhlGEoXaxCIQ06q6?=
 =?iso-8859-1?Q?OdC0cR0olPEsHOpWFE6JvkhxvSU2zFm+pego9C0kB0JEucGyq6I8VzfyMc?=
 =?iso-8859-1?Q?24jJt+h2ZkbKzhoPFgPj+RZDKK08dBwSkp1at3S6piIJqC9LwFFTJoFMGD?=
 =?iso-8859-1?Q?GS8d8Y0+r8yok7uNEsq5YYND3ApEzGZeLrJDoiCOeEBqeoj8EJ31Wyorpk?=
 =?iso-8859-1?Q?kiZMxxnO6RMCMXP8dG8q/UPwVFFygP3tLwbjn8NKtejj9TIeuTgts+NzVb?=
 =?iso-8859-1?Q?Ak7WeNKqnPqrNUP58e9Ybx+za35GHLO0WDljnrvbLr4Y+Fif5h9Y0IW/Q+?=
 =?iso-8859-1?Q?hfnb8MSiOUJkVLewtFk3KLxSnAA4BVB+aytq5PPOFDQIlSXVUEAuftOlAp?=
 =?iso-8859-1?Q?Uc6zM3OH6n32xU6fTXw3CS+2qdX5ED+hGwzIEeUaSAx+fbcV38cKPJs9JY?=
 =?iso-8859-1?Q?ySnasT6jUY/sPcumHdbJFyGfn00GjMkG+n/E1AiYUhddIn5qVRINt2U7nc?=
 =?iso-8859-1?Q?gojS4ZW/T68o36USG3Ium8kpq4ZN?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(7416014)(1800799024)(35042699022)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 11:00:15.4712
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b64854aa-a9ef-4bfb-a88f-08dde62211a3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7DE.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10587

Extend the NV check to pass for a GICv5 host that has
FEAT_GCIE_LEGACY. The has_gcie_v3_compat flag is only set on GICv5
hosts (that explicitly support FEAT_GCIE_LEGACY), and hence the
explicit check for a VGIC_V5 is omitted.

As of this change, vGICv3-based VMs can run with nested on a
compatible GICv5 host.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/arm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 888f7c7abf54..73ac33425927 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2315,8 +2315,9 @@ static int __init init_subsystems(void)
 	}
=20
 	if (kvm_mode =3D=3D KVM_MODE_NV &&
-	   !(vgic_present && kvm_vgic_global_state.type =3D=3D VGIC_V3)) {
-		kvm_err("NV support requires GICv3, giving up\n");
+		!(vgic_present && (kvm_vgic_global_state.type =3D=3D VGIC_V3 ||
+				   kvm_vgic_global_state.has_gcie_v3_compat))) {
+		kvm_err("NV support requires GICv3 or GICv5 with legacy support, giving =
up\n");
 		err =3D -EINVAL;
 		goto out;
 	}
--=20
2.34.1

