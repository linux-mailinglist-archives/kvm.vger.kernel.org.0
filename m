Return-Path: <kvm+bounces-66367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AAE9FCD12DA
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 18:38:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4C7FB3029B99
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:36:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 469A3364020;
	Fri, 19 Dec 2025 15:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cDaXaBJt";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cDaXaBJt"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013047.outbound.protection.outlook.com [40.107.162.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D55A3624B0
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.47
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159642; cv=fail; b=WeRZaEd0xFOBBGJBM0fSwL8324O0DQD+GxQmWMZ2b6xAVuVijJ0vFWZUnWv0nR4U3zdeO33o+BQuWak8DQw+xuPn/PktCAzv+LdPlZIcwBg3aVfRKWcx5mprEcDkkqRmBSKNpn9NyN3l/Bc9QPRfR1aFtjH1gar4XRAdezfV97o=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159642; c=relaxed/simple;
	bh=j+Y7odTfiFf1paG/u7a5RjSP2B06R93NYCjaCjpjTOo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OG5+uZ9qgh7+/m86Fe8glcDiSUnG0rSmudcquyyI3vbJUyqQ6lSRcPmuvVM9qvjR80dUNm5KWVWQxuzoJgSNJ6+mE5wgf/v6x4wWGJPp8ACn0JK/5UOaCAewL1p/rnbDYYStdc66ErOVoIM6cZfizP/ulgPmGwyfw+egIsBdBDQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cDaXaBJt; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cDaXaBJt; arc=fail smtp.client-ip=40.107.162.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=UG0h7CaFfxav1qHw3+afg14OZq3L07DJz8S17c5N8jSHuFRAGpjIzzZJ2kB/fRyIX8+6iw/7L26pFNVA02VgX12JYkM5IsGJQXRcCywVgUfXu0oSWfbEa+q8a3K4C5/ZwSwkq/Bpo4WLNQdGahuU8eLbldZrgbghhvNOHfqt8ACzae624Hl3XxMS012Es0qt2E/vBdRQ0eVBeRwWn8ntzgkukJni5KPlG3AjIhoVaZjCD7lEVpfTJ9hDWRnNdlbnHHw618yt8z9Q2IgWHATOfwDTu2jxJqrKXnn9D9H1CbGlybcZTfe3bdVk/vwvEQSwTrPk6Dr7rreoyf41ChfgxA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h91RFbVpxxG4vi2MuACM9fIipdOKlwPadpTQWK1rxDw=;
 b=fQApwye+nL47JFla8M5SOFSQkH/hOyzsbIzklgImRfXz05bvUcdIWecNx9Yo5IFbILBlxF4ACI3FM4AecYQimMvAIMdNqR/LkRoxLey5UZTY4x1kBmcslNtDGfkeu1Q+6+wgkRSy6iLlAXGTjqVqjdcF7FTO9rpDF27OPqbQfh/colUEZOZJzgKIAPLMzEwYq7iHzDkmDDlgvc8WRd+QpFcAjqd/OXCdhF0UWLHs8Uv8FUd0DxQNcruDJfBZFAjkKUC5ySYIhBSuvW7aHergz5P2FgS/lEMKEJjYjLOUTz6XmaoD45r8HqLtSo/cLQdboKjhPY6Gq4WDjZR9kg9QyA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h91RFbVpxxG4vi2MuACM9fIipdOKlwPadpTQWK1rxDw=;
 b=cDaXaBJttvUhi5mcLHgsODtBgnBewqlV019W94sqqGVrzTdjQKMp4H5ivfobA7Wv09TVO6EsvwQfG747J9xIJjN06vxEEpNJ9XXXIYAaTFuuPtLvuHtt3I7N+35IEzahHl89I7QXe+VCIFQua51Y9RJZFH+nX/k7urrsSNDTjEY=
Received: from DUZPR01CA0066.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c2::14) by GV1PR08MB11073.eurprd08.prod.outlook.com
 (2603:10a6:150:1ef::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:53:48 +0000
Received: from DU2PEPF0001E9C4.eurprd03.prod.outlook.com
 (2603:10a6:10:3c2:cafe::2) by DUZPR01CA0066.outlook.office365.com
 (2603:10a6:10:3c2::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.8 via Frontend Transport; Fri,
 19 Dec 2025 15:54:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF0001E9C4.mail.protection.outlook.com (10.167.8.73) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via
 Frontend Transport; Fri, 19 Dec 2025 15:53:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xh045NbwjuFTtQfsiQrruZe+uUGOseBGElW5qyW85S/UD/3a+z5Hg12eFROXVBsIQr4L6ofPkZ/TgFO8qCGaUXEnY4F1YvtuyrhrZxDqHd5szaPCvuzb7bS4uxSlroqe90mtmvBcCd0kbkSCgMxYl+jhXss+YlnLcXBLcNx1R+ho1ArgAj+bpl9pfIFyhmqhAMCnwvfGoXUIUzY+lcXC1Y3hs0WEclBmAACTwz2IGijIiIqdQtEWEIUpWo84LYIQNtGpis2lYdNcJuCdnu/X9EeR8mjT0L6f4wmSwputsgJqJ4F7dxVjsJGbm7WYNS8BfP+nUpMrROjaHYFYYMWeHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h91RFbVpxxG4vi2MuACM9fIipdOKlwPadpTQWK1rxDw=;
 b=VryuaX/vbM4QCKBwrycJaOw4lpO6Fz27UzR7cKgKdegl+lYLIjpPBk+ljegYd74WbQVWjTcD67j3iReyComML1m0oAxUMYmHr+mEylYNrf7Yn2i51wN8LJBkQsGyWqLbc2Zihpe7XlRCyi7MoZvGUcm21hswnI4NiRs64scg/VeMdOwTHW2ZywALPZTu20quOOzMK3yDQy5CLmUdPsVSow2pgpqLRijDeEhUGdQfkwmgfqxkaPtz9KyJfZstNcouD6WQG1zXLECZvDp2HZ5sq5sOB1ZFBKH+fzl09McVVK7XLOasPtSUKxR48y7p7F/J2UnxxrzoCa6XmGD7d/pmRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h91RFbVpxxG4vi2MuACM9fIipdOKlwPadpTQWK1rxDw=;
 b=cDaXaBJttvUhi5mcLHgsODtBgnBewqlV019W94sqqGVrzTdjQKMp4H5ivfobA7Wv09TVO6EsvwQfG747J9xIJjN06vxEEpNJ9XXXIYAaTFuuPtLvuHtt3I7N+35IEzahHl89I7QXe+VCIFQua51Y9RJZFH+nX/k7urrsSNDTjEY=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PR3PR08MB5676.eurprd08.prod.outlook.com (2603:10a6:102:82::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:52:46 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:52:46 +0000
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
Subject: [PATCH v2 25/36] KVM: arm64: gic-v5: Reset vcpu state
Thread-Topic: [PATCH v2 25/36] KVM: arm64: gic-v5: Reset vcpu state
Thread-Index: AQHccP+Dm1ALypmq+02v/d6WyTk6LA==
Date: Fri, 19 Dec 2025 15:52:44 +0000
Message-ID: <20251219155222.1383109-26-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
In-Reply-To: <20251219155222.1383109-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|PR3PR08MB5676:EE_|DU2PEPF0001E9C4:EE_|GV1PR08MB11073:EE_
X-MS-Office365-Filtering-Correlation-Id: c647471c-0e95-40ce-9774-08de3f16cc4b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?PZIrIBOjoe2yFkBP9cX/huZQVtSHV11B9EpbWBvopU4xrsluiwpmhytX5J?=
 =?iso-8859-1?Q?C/HVChq/gqmwZ+sdVFvs/XQqUAEAV4bnGTDAKEaJ/+dyf+6DVQfp9ckcJ7?=
 =?iso-8859-1?Q?rgHjpSiamuuXRtGyz20JawWnE/D7Vvs0RKs9gAHG8iW9coNTK6VK5kWjtO?=
 =?iso-8859-1?Q?mE2Q7r8eHorzvOv6IMzdXxQh2Hz0H+JFDGScbHA1yEzTgkvqkbQLD9F2vC?=
 =?iso-8859-1?Q?pePzr6r3E9wW/2Hhk7oMQgxx36vakSHRrBC5RWwfcAZVn8Xo3l/vj+uPW2?=
 =?iso-8859-1?Q?RRd951QtTilnnV77LxDbjI9PqdxGtD4FSt58wwc3nneTIBI3/dE9hBcAbP?=
 =?iso-8859-1?Q?pYMVu12KvMBQCKpot5Jrm8TdGeISi+yUugiA3uJKlLP5Nj1bw+IuHV9ZjT?=
 =?iso-8859-1?Q?hFHZSxmaNniNVb7ZjZxQ/kwTRE9MkGDzFDZNkW4K1QUPPOFZei7ePM06iJ?=
 =?iso-8859-1?Q?XRW/PNhaRPW3GiiYrZ+qebqI0KZBQCYHhNIk9jbVKbVoc8PVdKqltteusX?=
 =?iso-8859-1?Q?tQzjEhsnFLeJe2SIPDgUY0utzDd/wGJrBsk/8OxffHBM2wXzYuYkaSaJjO?=
 =?iso-8859-1?Q?10/21tL5/D8Lr2MVzFvxkGpteuBAOFXvtSBv8WGlMXCpUu6LFX+lBa0u2M?=
 =?iso-8859-1?Q?AycqmuXdsEl8oN2DaedeM366mAbJ8o5K5Oz/lDKqs/fcv1BcBFgjpBI8bM?=
 =?iso-8859-1?Q?exuzFv61/FMCmWAUr5/ftHIiuHxaMuDCspCpfuUM0Vz/6UUd4hwH8LPyuc?=
 =?iso-8859-1?Q?6ueXVuSLjTpbU0EXVfD/m6mrCoGQTnrH7VMu+v6fc6Yj1NjxPAgLsC7vNH?=
 =?iso-8859-1?Q?fyO4drz5PCOJPsb6BgqTGnySxy8iG1GcjQau949E+q8rz6i7xpXfUemqtP?=
 =?iso-8859-1?Q?ZL7tbuetLSeBov7snifvpdQMdpusXzehY6I3KmKsWi5QPw2Uu/sVTfE4vd?=
 =?iso-8859-1?Q?u55+qRYzMlTpmrxPn6kH16LvRGtn+t63ziGVrPD+oG2C5xPtNIZiSvfrq0?=
 =?iso-8859-1?Q?NIxYP+cRfjAym6rVjcKO/GFpg4RCFO0IHGCMPZxdGiZn18sXs4XCGLAmEi?=
 =?iso-8859-1?Q?5GDgsxh3+ouZc1ULpp4HbM0rYrpNudyPik/T3yfDZXigQlo9WIDZqtQUpP?=
 =?iso-8859-1?Q?zcSjBg7OmWgZeC8yRbuhAiVkNhWfjNLAIzU0q+D7f1DB0+t7WGHR7A2QdN?=
 =?iso-8859-1?Q?xZwgWjo1b6yeGs/HHE9TcM1/dsQ9PQpTEZno8n5UaSBXYFTwEhidJU2+ml?=
 =?iso-8859-1?Q?5KKZvpAIK5caFSXgPo889qtiNw3xK87PXgHoiscn+TV3awegLBoeWB4K68?=
 =?iso-8859-1?Q?RDr6iKBpph3bQE3JbMVwfAud67CMGY7qY2pb33hvzucpg06u8PRZoZNXTH?=
 =?iso-8859-1?Q?/zzemYwdzQzccSHgYicfy4v3Ts1DsPXXMq5CNzyi7XaUlgxVMFKUmRaqEy?=
 =?iso-8859-1?Q?pivXO/RbXbrC+M4Fb97GzsZzRFH7qa8WhGL79plhrbWo7rPgexJwIz/RUx?=
 =?iso-8859-1?Q?DZGZ24Y2wqhjicQAT+zIbm1+4wse+ToxdfqWYp3Y/iX0Mu3Jz8kkJaL2Os?=
 =?iso-8859-1?Q?0v/wuiIvQL6On3hOCmNoSURDbrCO?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5676
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF0001E9C4.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e3b1b3a0-ce6e-466d-047f-08de3f16a73c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|14060799003|35042699022|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?gz/GoOZT01VDryfuVY+YSxJ9edKw0PLVqJ4YejCVOtJmTFyBL3lVMElzgF?=
 =?iso-8859-1?Q?+hKc6dUbQHl+HQGW/E78WcqCGSgIMZvufQfmlR1sBO3jSEsbAbNwbiOOW4?=
 =?iso-8859-1?Q?dbewTfA+awo0TkSymgwVW2lWiQ+UCZmTRuJ6IA3tDPYm0utW+VUlPeBjs0?=
 =?iso-8859-1?Q?2MyakJQ6FgdUUT4bv1bwmEiRsrfwuFQKWPFkxD2oSwAftLK7h5m+3DQRAV?=
 =?iso-8859-1?Q?NWS7K2UKAnaeEdeKSaNJbkF8oV8rkHg8I1IlegpKEGYKpGy7Y4ILVHjT02?=
 =?iso-8859-1?Q?J0R3MZG9f7RPkKRrO93pFAVC6wWpLEqDseEY7sJA9EMtCuT1QyKZnqfv4P?=
 =?iso-8859-1?Q?KB3l/p3XP9ArQO4LKx6Uv7uEGyS6dIoN3Sd2cXwtK+dKutJ8RAYdRXC2zg?=
 =?iso-8859-1?Q?//fWBvYBWYyZJKLqaSryKSRn3K0NLUQfe1co+S2WtegepUzS7C7KRnfvpw?=
 =?iso-8859-1?Q?7JHHIdfQfJKR17/7lVsXjkVo74oN8C2muy1vMQlBjuRjJ+py6jSs1fkEf8?=
 =?iso-8859-1?Q?1xkjnWvkbTGwcXTVcfmQnyUlyMWy4PZwl+aU92c4sxfUFm3DGfluK3BTCq?=
 =?iso-8859-1?Q?so3v37fBpFuhgag9UMueX8m8NdrmFEZLLTfClrpRJNOr+ANtvMZcqtnaxJ?=
 =?iso-8859-1?Q?A9P6EiB0oOoqhdzNUuUtiopbk3mdZ6asd4zJe9iyIYeeE//ATJzj7LsgIp?=
 =?iso-8859-1?Q?0JgwaIT7VATiFT+ns5gkyvTga7qK6aJ4lqblNtQzQ15iTq2YxVCKwg//iE?=
 =?iso-8859-1?Q?VzOKVYT4F6inzYf5h2bJU5akeKXTDYZsNu5uJmG5b76fo9cdllUfJmqJ4+?=
 =?iso-8859-1?Q?UylwPi4AB9SpWXhp/AkbN2wnp+4yNMDBdhJwkl0w5MaHiS6IMftl0vDIuh?=
 =?iso-8859-1?Q?/u+DXZH4LEFkLW5IjJNFCrsqKcBmcFW8/+lmo64Fx+PkTTDxDzZQrvAnJO?=
 =?iso-8859-1?Q?bo4TwcSO/TV2LaEENcalsur3bRtYNh0WlLOb7y8l6SCDk2IkKE+Hq+ktRe?=
 =?iso-8859-1?Q?9IELEr/ougv+UV97kO0kqu2RE1/pYq28H8BjLkbyEG46jKZfJrZ7tNcFvN?=
 =?iso-8859-1?Q?/cEebY45YELUuU61xQ4yYXns/81QQvV7cDIp/X9Xu4crIdo3YH2LWQPIDT?=
 =?iso-8859-1?Q?JZ2OunwIMX2W65I+iDb8WG3F3aCW4cxDlg+M6oYCVLH9Hh9hAGTr7ozvoG?=
 =?iso-8859-1?Q?aBVmyXlRMMR4wpNCliEWvm4/8/PnZUWxilr3bhZ0A5tF2K2oWe6tT+50xo?=
 =?iso-8859-1?Q?CHoaJcxCSsypvVpmvoPHJ4UfL0AKix401CAwRkjkbIjj2M0WJp6plqetR6?=
 =?iso-8859-1?Q?HjMk5FQ/gOYQu6V17pvAGyE51dvsfXeXFeKbGZbfZkbnRIaOMoAvpS02qh?=
 =?iso-8859-1?Q?gLyhD9TnO+Ab0IzVjkACi8ICO2Nvh8UFbDPHK90nOrCma+4NnERraxF3rT?=
 =?iso-8859-1?Q?8SThApvMdqLoXNc7wMZucbGWRM8Sa6lRaetOJfmap+679yl5ma3XFg1PQz?=
 =?iso-8859-1?Q?8+3fNvw6NBxir8oxUJrps/jRC0iL1SAtqzXrJwyH5thjIUHbRw0KNa+rNb?=
 =?iso-8859-1?Q?6nb6meh1p63FLauhJmzEbHc4TGDP1Wh++YUAsScu784YDumQXJlY/uWZaf?=
 =?iso-8859-1?Q?5JtrJCgsN6jvo=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(14060799003)(35042699022)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:48.1543
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c647471c-0e95-40ce-9774-08de3f16cc4b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF0001E9C4.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB11073

Limit the number of ID and priority bits supported based on the
hardware capabilities when resetting the vcpu state.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c |  6 +++++-
 arch/arm64/kvm/vgic/vgic-v5.c   | 30 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h      |  1 +
 3 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index afb5888cd8219..56cd5c05742df 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -396,7 +396,11 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
=20
 static void kvm_vgic_vcpu_reset(struct kvm_vcpu *vcpu)
 {
-	if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
+	const struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
+
+	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+		vgic_v5_reset(vcpu);
+	else if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
 		vgic_v2_reset(vcpu);
 	else
 		vgic_v3_reset(vcpu);
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 17001b06af600..feba175a5047d 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -56,6 +56,36 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+void vgic_v5_reset(struct kvm_vcpu *vcpu)
+{
+	u64 idr0;
+
+	idr0 =3D read_sysreg_s(SYS_ICC_IDR0_EL1);
+	switch (FIELD_GET(ICC_IDR0_EL1_ID_BITS, idr0)) {
+	case ICC_IDR0_EL1_ID_BITS_16BITS:
+		vcpu->arch.vgic_cpu.num_id_bits =3D 16;
+		break;
+	case ICC_IDR0_EL1_ID_BITS_24BITS:
+		vcpu->arch.vgic_cpu.num_id_bits =3D 24;
+		break;
+	default:
+		pr_warn("unknown value for id_bits");
+		vcpu->arch.vgic_cpu.num_id_bits =3D 16;
+	}
+
+	switch (FIELD_GET(ICC_IDR0_EL1_PRI_BITS, idr0)) {
+	case ICC_IDR0_EL1_PRI_BITS_4BITS:
+		vcpu->arch.vgic_cpu.num_pri_bits =3D 4;
+		break;
+	case ICC_IDR0_EL1_PRI_BITS_5BITS:
+		vcpu->arch.vgic_cpu.num_pri_bits =3D 5;
+		break;
+	default:
+		pr_warn("unknown value for priority_bits");
+		vcpu->arch.vgic_cpu.num_pri_bits =3D 4;
+	}
+}
+
 int vgic_v5_init(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index f974b55fb8058..c8ff545e777c2 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -386,6 +386,7 @@ void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_get_implemented_ppis(void);
+void vgic_v5_reset(struct kvm_vcpu *vcpu);
 int vgic_v5_init(struct kvm *kvm);
 int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
--=20
2.34.1

