Return-Path: <kvm+bounces-67604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AD946D0B8BD
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:13:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 84401312E2F5
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:06:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ACBF3659FF;
	Fri,  9 Jan 2026 17:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Uw2pTihG";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Uw2pTihG"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012042.outbound.protection.outlook.com [52.101.66.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A2D36657D
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.42
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978358; cv=fail; b=hWYrTmTn4gMbCFa7US4tnctZpgyU2OEm8EFB/LOuvNvK1o4WiDuMsunMu5OzNFm/oursL8RIp4ksffUjFl2M+PGiJsXIKXujfcOdVpXUH1hSntxCguO3ChB/OdWPQMMyonxVSPMxvkZrKNM9fFwakSB+f6APsYmOQRgaqEziOxU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978358; c=relaxed/simple;
	bh=giDKwqYC1Br/Y4CmQU9dS1eQcoLSB6wHj8rtc+WZfSM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HlLRPa+h8JXhG4tdzTs0+jxanT6FPJPrIYVhK3T0acD7fUdRRHAy7HigikNy/YrE8Kebn/eA+WJZ93ReWpdwe2h8+fI0+Xt5/PzGWzv4SZFUtSdWIowmZnJdG6tUOly/77JwBZY4Xu5iR2fioStoXbGBh9sgvwrx3MqnxLJtriU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Uw2pTihG; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Uw2pTihG; arc=fail smtp.client-ip=52.101.66.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=R/O6g+hG0+WluUFw+QR7EYzTMSjRlFS7saW7XZjElNBS7HaPBlCqHS9iMm+HBUuePErDMyQbF8E/xIqIdmhlJ+ibW4aRwTcTwTK3XXS7PBg85wOCuIAvQ5VSkRozyCpNMv0KRh5k7onPJP0bD1Cqso5d+zhVlMFOaJXec5YKCL/yxucriVynbeWEmU8a9Cx3aOl+wqpf5mVO6WAV2OUk91DF3uUK7ZpHyUV6JhDxXP7kFm9iVv8M23gRNBQwkXvIe6ihUP6SfW9g0RLiqPYAmSU9AWM9Mgen31MFnLDhliHfBFupM+/adU61grBCGyzZbm4uCiWnvNWTqE3lHl9Caw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kw0rQ8iLu+kD0p8YHNwXM0PGM+yKh5hojZ2FNnIhNsQ=;
 b=n1hplHK5bNg+Y8+VM6LCIy2wtvGcBfTleYtcU4yLrXYWqdavnps5j56Qbip6IrhgSzoR7iKmEASsntsYmN7uEKnMsLHbxy7WJkloofHcCqfKhK/h2PmR+60N6CSdAnH4h9w1Q4NrdIB9fmvTcrlRfH5/+2IrinPZMp3nEvw732MUX2nxmbiCfuLQ/5VoZogbEpm7Hi51Z+DbBGJq+ge0xN6xAapVl0JSKU4sY7A7Kldh0zQX8DmjrZrq8xCGL6PeRypPBzYDP3b3ltN7G1Wc81K42hYJi7rCWMMCXOfQmp1xBlO4tZ6O9xLuX7lTif7AVMS1WA4EsSbwRJZ2v3dWgw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kw0rQ8iLu+kD0p8YHNwXM0PGM+yKh5hojZ2FNnIhNsQ=;
 b=Uw2pTihGWib9pU2OWHVaeHNMEGt8gsuRvy7Z+R7ms8dx2lTLIBweWc0nJOMKdSUAW1KRne11MnDkmARtoeOPMDRZQbDO89gIA9y3eGI8H9m/V4I+wcFCYaR8kjG94n6RdVT6mLUuzk38805/VYJ/I2aUBvxOPFM3unn6EOYkURc=
Received: from DB8PR06CA0054.eurprd06.prod.outlook.com (2603:10a6:10:120::28)
 by AM9PR08MB5986.eurprd08.prod.outlook.com (2603:10a6:20b:281::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:05:50 +0000
Received: from DB3PEPF0000885A.eurprd02.prod.outlook.com
 (2603:10a6:10:120:cafe::aa) by DB8PR06CA0054.outlook.office365.com
 (2603:10a6:10:120::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.4 via Frontend Transport; Fri, 9
 Jan 2026 17:05:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885A.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:05:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JoNvzE9qoDm0+SuGfWCjh0BNR3DJ2xqYO2xK1HSUWDpjLnGdwGf221fC3vtnP6tchRqIAW7aItP5Zjtr0kA+FSg2CmWybQy4xxAWsveLuzzdx+O2jG8OC8vFGOBiJtBJflPo8X8T5jjSG1cDw6GLehKVZ/x6Rs0ycuFV48MEXjmYed/hMk9HM4epcOo4Gfes0MSGi6QE5txsLl8oJaRddgK6ABNLDwY42xChGvItmMs1dhZwpPwiFe6G8Xr1T24K9XCIrxY1AkxXmEd4AvsyEKaUH/Dpv7XgS15I29ifSdssuAkbimpMttto19xOJ0RGR4Wk+53yZ7W6lOpj25iJIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kw0rQ8iLu+kD0p8YHNwXM0PGM+yKh5hojZ2FNnIhNsQ=;
 b=bK6YyO7R8lmRPXnTsGV/0IbknzVsTRfcYWeqdMyeyiJK3PpULMywiKcpHFhp9K4ldm76Vqzb2gFiPnGrfikJq+XQWev6plpeArbg2YlVRNe6Osfx1DBAXmW7qFah4Nw7a6+8Q44mEX/l1LUXp5bc/72WtfbK7Zo4Z7gIVn4KiIhQOql7etQsRXK0kx2UpaK1r+Xizpi0MX92QTJTpy2ZxjujDcoQP9Z7YUvsqNPi/rBPi62zWWtiECEsDFwutDSIQY3Dw9OQJh/z2miB31uPWqwFjMujZyLdRp7pEkEYX/mUl1sB8N1dFsXpy3TxNh2LO38eyJItNfBZGV9LSMu6gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kw0rQ8iLu+kD0p8YHNwXM0PGM+yKh5hojZ2FNnIhNsQ=;
 b=Uw2pTihGWib9pU2OWHVaeHNMEGt8gsuRvy7Z+R7ms8dx2lTLIBweWc0nJOMKdSUAW1KRne11MnDkmARtoeOPMDRZQbDO89gIA9y3eGI8H9m/V4I+wcFCYaR8kjG94n6RdVT6mLUuzk38805/VYJ/I2aUBvxOPFM3unn6EOYkURc=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by PA4PR08MB7386.eurprd08.prod.outlook.com (2603:10a6:102:2a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 17:04:47 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:47 +0000
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
Subject: [PATCH v3 20/36] KVM: arm64: gic-v5: Init Private IRQs (PPIs) for
 GICv5
Thread-Topic: [PATCH v3 20/36] KVM: arm64: gic-v5: Init Private IRQs (PPIs)
 for GICv5
Thread-Index: AQHcgYoOaWBPnsM2gEyO7VUOsIdgSw==
Date: Fri, 9 Jan 2026 17:04:45 +0000
Message-ID: <20260109170400.1585048-21-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|PA4PR08MB7386:EE_|DB3PEPF0000885A:EE_|AM9PR08MB5986:EE_
X-MS-Office365-Filtering-Correlation-Id: cc725bc2-667d-4516-ae91-08de4fa156d9
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?gHElh5atBtEnmd+m9a5eIJvSbeg6XmPow2xCHNmDikpoKyGePZUf8SfzVN?=
 =?iso-8859-1?Q?/2uV7NWhY5BTOudejHmxWT2VE69h0AF2uMF+RmbW9maWBCaC3xWl9x+/19?=
 =?iso-8859-1?Q?GfUUhM3O55CbfjM5J6hYJsPVP8ITxX8DIeLKigh2bbNa4ykNiY5LZlgE/1?=
 =?iso-8859-1?Q?0TS4a4ddv0c3g3tyb9xmu8dH237mp3ooLl6ZP+qIV7cOKFTzyBFAUKBzld?=
 =?iso-8859-1?Q?1T8oSqAtjV244ZVoKRsoGfe0cP7DSmOQ1pyxq0VHLYd0f3GfFXB3j8crf5?=
 =?iso-8859-1?Q?XE0yJx3OK0uDsamQpsVwi3smX6XSds60dlY3rdrsgxNEaAPM+h0bXtlTn0?=
 =?iso-8859-1?Q?9+3HlmhdRh513Lmoq6x9m6LsHUUEOgPhy0jwb5AsrkuI9sk0SpBy6o+eGV?=
 =?iso-8859-1?Q?X9PLdBpP9+NUrHL2YeEKSNjlgV5Cm8hcs0/eqBa+cN52DJ44MeoZOWuXXD?=
 =?iso-8859-1?Q?dOl1r+UrZd1RRxbh5O1kbeeVIUvGYC30f+J4McDhmRN3AUOCuoP8k1EqZz?=
 =?iso-8859-1?Q?QG9S+IXWcEySO4bgPCcswN706jqX/kDRwTwq8RznDjE/P9HsYweKMuJTOE?=
 =?iso-8859-1?Q?MjcOKP6YxcNFS1nBqLjvlIjgbzqVlvlBigIB6HoxSS6GYVOS8oOOlWHw0a?=
 =?iso-8859-1?Q?Lz9/suIFo7PhaPZy8OgkA32y76D2AhVSEKrH4wM4sdeXk3W67Q6RVO6WyP?=
 =?iso-8859-1?Q?CgmvvUait6lX1KokJwh86WWhuqx7IN87dhsH2baI9+S50qPtz9XSYR3G/z?=
 =?iso-8859-1?Q?nCWkbhH/lY0W1cYvhEvYuSpzt6FWHX+6D2AZIpm+HzGufp6sZq5cnwv1BM?=
 =?iso-8859-1?Q?WKCKb+VkW9ZPn7emn/YD0BtOqnfewqM+l1dKWt19IN3ZbjJiL60JUcKWbl?=
 =?iso-8859-1?Q?aRtqOPoMpKxWCDLtCd+tTYd2jnnJ/LYQLoMHmo9OKk/oS1uesOmanTdTxV?=
 =?iso-8859-1?Q?ekOEqRRkfEf68/JrP4cWyoH1Ic78RUgMPtPTnMyivBViPB1JhibyPAiVQT?=
 =?iso-8859-1?Q?vQQ7KqXhpyOsxeDWVykY/yegXXV9RbZ9EMBYuLkZd87Umq/z3y2ZoOOrnw?=
 =?iso-8859-1?Q?ycwisgi9eSdEpcnNetfK4PWr1YqWWRBuSXNyPagHY7x9DhvC7r201Ge2ph?=
 =?iso-8859-1?Q?AbEYuNQts3pO/2VDD4VeLugQMAy8zLA8lP4Fb5YVAOs1C66mDOk4l03cA1?=
 =?iso-8859-1?Q?fPz0g6qfOannHGQ5d3XeYRsQthJMvFeTgL40h/LtKQu/WPLdA21JJzair4?=
 =?iso-8859-1?Q?rzoonSC3sI5HYqrn2lEkX3fEhQCNN98LwTt4x5N29ZNsAvbedbRHxik6ko?=
 =?iso-8859-1?Q?+z2g0MWf2ANSwtOylL4ZcEU4sMoQk2Ks5J+pildb5Wp/wJEfxNJu2YXkNZ?=
 =?iso-8859-1?Q?0rME+7ltohufHbxp06hbSqxGRbkuJajPv1TkotOjqFKdCnJYxxmhkJl2a+?=
 =?iso-8859-1?Q?/Kda/CaIYVRH2GVIrlbei7zyPlAnnGJGQiCVOTYq/N5J/HCh3CJBv8E+7R?=
 =?iso-8859-1?Q?P850+EB7AO9ofsQarVdt8hl7TcKmE6e+MJVYQ/3Fdl+JUQzc7stEFD1deW?=
 =?iso-8859-1?Q?nNIybmvnjcfm01OGKXRrn0EGTh/k?=
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
 DB3PEPF0000885A.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6bd2426b-afbc-448c-5ebe-08de4fa13166
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|35042699022|14060799003|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?7sFQ7WE3Qn0R1qr5h82hCBLco36UroKL0kr05clzgcRnSKwIAVt/5ephbW?=
 =?iso-8859-1?Q?xHY5F6oBRHYnQzVgNb74NUHJS8ndZ+uWxZTJr+UvwjOA4dVnhsc1kNEhgh?=
 =?iso-8859-1?Q?GfrDsymnmb+YedD6wQa3K2vfsQJx8ORZoYML2afRu3lWQaxIuEJ6LTn7iW?=
 =?iso-8859-1?Q?9tEoren1oGxQK28jGtpuT9uBCzPB5xg33Yobp2YTLOhZWNhwtJTpvDa2oa?=
 =?iso-8859-1?Q?07S14hlDc5iIp7/KLFhgRBO6kok2kuKb0FMM0hBT/u+XODDeDYt1axvqff?=
 =?iso-8859-1?Q?VHQyOb7Z0CpbJReDHfAuzexhRa4qiZfRvNDqFcJxBRFlGtL0slz7qbY/p7?=
 =?iso-8859-1?Q?fSwAtucGywWdMYBnk0RVpStTBjC++60KjJKZDMH86fouhxU/PGpdYLiTTM?=
 =?iso-8859-1?Q?hd0hVQc0pXk6EycPLITW+Rz46onTvT74/rE3Vw6FKiB3Zk7fMmzllYYiZm?=
 =?iso-8859-1?Q?4xiqkg02KhVEVdHZvEqXJIA6Y+Ao0reuNlnWumBn+TzkAhzJxIJYLXgPA+?=
 =?iso-8859-1?Q?l1ycz+T0sTBG56XPb0jhcOSEk6pd6G8vTmnMVgMmjlg0uByV8tvCvT+XNT?=
 =?iso-8859-1?Q?9hkQXjnK30lwearqEtGYPfKzeO/EVagPKpfez/fKlPd1PdYNun3NnGrjlo?=
 =?iso-8859-1?Q?gM6rQeUQzVtvnp2QJadKUEHbDVwgaqJVGVyAW9VBzumVe1ZnBeg8t/VBcV?=
 =?iso-8859-1?Q?/BgQr4BJn2Qp+1KT6hV4Oq0D4C3OmJOD+nObUX6NbLt5GXG5Z14gzlXFB3?=
 =?iso-8859-1?Q?SCkTRd+xUbGH5NOCxqvNS5DWpds/wopWqliQg3ac67DEVIJt2xZYwrH4xg?=
 =?iso-8859-1?Q?+LqzcEZn9Y7nnAYE8RYdbXeYYvpgK2dx/1AwSPuoOpCXVhW95UOT646P8h?=
 =?iso-8859-1?Q?YSNKBUUW7xJ2z4xe7kCMcXkaV4yP9L1h/yKH9PHw4ujZ0eZPsaKGVKQrzA?=
 =?iso-8859-1?Q?1ryGr+ztckW81tsknihzbUTyqhpbnC0E5+MKA3JZe3wm5rhHlr68oP814A?=
 =?iso-8859-1?Q?Q5ErCHPu3Z2VpMmlzIWosAaCEt5vFpwtsEGfewpy1BL2xWD7lJnEVKR1xF?=
 =?iso-8859-1?Q?fMTTzr0uAmQpcCOz8VIe/hC2euK4sZ18BCVRRRUJi5y3QtlaeBaWK2cUOZ?=
 =?iso-8859-1?Q?MV1bNe0nRL1WS+kxiimVnntLPtbdBrpxgqkhqrOmrF0XYExhJez4w31le3?=
 =?iso-8859-1?Q?ELax3vBnH2rKhBfR4ceQO6/Eu6jySQ9FUS0iFuiky/tL8WEuW5Zva3F/A4?=
 =?iso-8859-1?Q?XgMiYGtxqpqGLJYbZtaCOgXN9PfxS60g8fiqxnzc4mMsk87UI7X2A0AKlE?=
 =?iso-8859-1?Q?NwQzpUu6nfPVjTj77Waa7FxCKn8RkqEpXto8MO53LvJBjoNUeNKk66igWy?=
 =?iso-8859-1?Q?9YEt3TZDOqoeXvlZozFDkYa37XGGySPMzzMxmxVpOV59lQKX7Qa6lZ6fpd?=
 =?iso-8859-1?Q?HqkCw3W19UJgYZWrS5umIa50DErm8xH93WcNMED+B9N3DLCElD/utibG26?=
 =?iso-8859-1?Q?eUfM+8jtdYya/SsPGKwYQSwjrFC0hyt/r8t69dt/uGVBzMmiFkKfHPNEqC?=
 =?iso-8859-1?Q?AW73X1Y/z7RkRNdjDTtE6GHL3UemQcOwHTQYqtYAYe0WsISFpTYsN8VDKk?=
 =?iso-8859-1?Q?Ygdh6OZj7BpME=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(35042699022)(14060799003)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:49.7358
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc725bc2-667d-4516-ae91-08de4fa156d9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885A.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB5986

Initialise the private interrupts (PPIs, only) for GICv5. This means
that a GICv5-style intid is generated (which encodes the PPI type in
the top bits) instead of the 0-based index that is used for older
GICs.

Additionally, set all of the GICv5 PPIs to use Level for the handling
mode, with the exception of the SW_PPI which uses Edge. This matches
the architecturally-defined set in the GICv5 specification (the CTIIRQ
handling mode is IMPDEF, so Level has been picked for that).

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 39 +++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 653364299154e..973bbbe56062c 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -263,13 +263,19 @@ static int vgic_allocate_private_irqs_locked(struct k=
vm_vcpu *vcpu, u32 type)
 {
 	struct vgic_cpu *vgic_cpu =3D &vcpu->arch.vgic_cpu;
 	int i;
+	u32 num_private_irqs;
=20
 	lockdep_assert_held(&vcpu->kvm->arch.config_lock);
=20
+	if (vgic_is_v5(vcpu->kvm))
+		num_private_irqs =3D VGIC_V5_NR_PRIVATE_IRQS;
+	else
+		num_private_irqs =3D VGIC_NR_PRIVATE_IRQS;
+
 	if (vgic_cpu->private_irqs)
 		return 0;
=20
-	vgic_cpu->private_irqs =3D kcalloc(VGIC_NR_PRIVATE_IRQS,
+	vgic_cpu->private_irqs =3D kcalloc(num_private_irqs,
 					 sizeof(struct vgic_irq),
 					 GFP_KERNEL_ACCOUNT);
=20
@@ -280,22 +286,37 @@ static int vgic_allocate_private_irqs_locked(struct k=
vm_vcpu *vcpu, u32 type)
 	 * Enable and configure all SGIs to be edge-triggered and
 	 * configure all PPIs as level-triggered.
 	 */
-	for (i =3D 0; i < VGIC_NR_PRIVATE_IRQS; i++) {
+	for (i =3D 0; i < num_private_irqs; i++) {
 		struct vgic_irq *irq =3D &vgic_cpu->private_irqs[i];
=20
 		INIT_LIST_HEAD(&irq->ap_list);
 		raw_spin_lock_init(&irq->irq_lock);
-		irq->intid =3D i;
 		irq->vcpu =3D NULL;
 		irq->target_vcpu =3D vcpu;
 		refcount_set(&irq->refcount, 0);
-		if (vgic_irq_is_sgi(i)) {
-			/* SGIs */
-			irq->enabled =3D 1;
-			irq->config =3D VGIC_CONFIG_EDGE;
+		if (!vgic_is_v5(vcpu->kvm)) {
+			irq->intid =3D i;
+			if (vgic_irq_is_sgi(i)) {
+				/* SGIs */
+				irq->enabled =3D 1;
+				irq->config =3D VGIC_CONFIG_EDGE;
+			} else {
+				/* PPIs */
+				irq->config =3D VGIC_CONFIG_LEVEL;
+			}
 		} else {
-			/* PPIs */
-			irq->config =3D VGIC_CONFIG_LEVEL;
+			irq->intid =3D FIELD_PREP(GICV5_HWIRQ_ID, i) |
+				     FIELD_PREP(GICV5_HWIRQ_TYPE,
+						GICV5_HWIRQ_TYPE_PPI);
+
+			/* The only Edge architected PPI is the SW_PPI */
+			if (i =3D=3D GICV5_ARCH_PPI_SW_PPI)
+				irq->config =3D VGIC_CONFIG_EDGE;
+			else
+				irq->config =3D VGIC_CONFIG_LEVEL;
+
+			/* Register the GICv5-specific PPI ops */
+			vgic_v5_set_ppi_ops(irq);
 		}
=20
 		switch (type) {
--=20
2.34.1

