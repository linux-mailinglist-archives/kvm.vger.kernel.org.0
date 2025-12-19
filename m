Return-Path: <kvm+bounces-66379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F9F1CD0B3F
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:03:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0CF14301F1D0
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA3373624C0;
	Fri, 19 Dec 2025 15:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kxDFO0YZ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kxDFO0YZ"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013051.outbound.protection.outlook.com [52.101.83.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4E1361DB9
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.51
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159666; cv=fail; b=d1PANsE9jZU4CFwY2UlVRWBA/wjbEQgA71jo2yLKc2Ofk3AKdu6SCtIxgoMx03KRMRJVZt+ineHa2ENTBTmrTQsW96LyqzO2hjT0VKnexrzvK57INr+TiRnisJAV8Q60rev+6nxBKT8GsRfPjDpmsvWFd4hlUp5VCwgyuKskIxQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159666; c=relaxed/simple;
	bh=yiOP2BCzNVHcMsfPZbhm2ns3O80OxCEKL64dxy0/GFA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TEYyPmKGN80AQIpGYenY9PAGiPSIXPVS69tEoiQU0Z2VjTQdxiGvG00hQg8V6PKAlgzNRcR5teRUVhwnYGmgWNnIl47vR9UgDkqVbcYUA8HCTahUn2pbMLpkAdTtUo8g28gEoHDVEMNWrXdfasjDIAg3vinEjXSP8Rj45jI9h5w=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=fail smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kxDFO0YZ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kxDFO0YZ; arc=fail smtp.client-ip=52.101.83.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ixYm3IhkZUslWPYpHk3UInrBETD9YTYYF5NRD9ySgSzNG+8mwms+oLkZG9S/ifEiPt0/Bn426udJKpRxfEKaiJk5yFMt2OL/2qoI91E2YmEiJsO+sLp85JKWYDh5NwmrwtNg0rk6bGZhsRSWZG/rpNQVBuk1yoa7f+oe/D5w6IuTQC+xGgGFxKaz6GWxOSyaJHNA7UqEVC+FDvwaPhl9/e9tSpyRfNzbsIg5mIGewtse0Q/bSQFkKchvj+C/RdUW+zBMM9FZziLrBxYEaHBqkkMebAwUOhJaX5eSsqD7P1+EOiiXPbGeDFJLyzJyhoQTXNCTNXIX25kxxbY2i4KaLQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=juYI1FMXu5DQltUeNDu4uMhmRt3TCuj6qWj4/72y17c=;
 b=WUPWE+Qzt9rvNQjd4Lyxnob724JqwTREW0kSQbGwXsHAG6lYC+6vvFYhVbG9N6FyHvUNzVjrWMEXrc5iuLenU0gI1UY9PYTJTDHxI8E3JibVVL8g5mvn3dwDuyRLAwM0/RGNuZBn4joWZ62TB9YHGDvsX4Pr8L4ZmYa3/0Sg642cGB6vIMvslb7zkGv0wQr7Rn5J6k7//gigbTBMFFnUvqjp3+Bx6PLHHe9ZwgCnpcUVYp7xaBNX53gU3uS0K+baYMKvPFJ5nEbbymH00U6uetOebYU/EHSsTrPEcREBcupOAzysC2/Vbk2faPW9iGwXVyiAkBCJVERo/9c2S9kq5Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=juYI1FMXu5DQltUeNDu4uMhmRt3TCuj6qWj4/72y17c=;
 b=kxDFO0YZJvlLOa5TNwmAxG6Yg4y3W4HtNbYl+/Vp2WNoPnIJWPKRnxOwnQ4S3iZYj05YLBCZ8ZSSJk3lHvRcavoqxNUmCungiySjpssDZzXQZ/36+NPQIbkP/YY+wCUnm9xBkq3kDeAGmcx7fKT7EpsB0bT63PslR0jkExfMBXo=
Received: from AS8P250CA0030.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:330::35)
 by AM8PR08MB6449.eurprd08.prod.outlook.com (2603:10a6:20b:364::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:54:20 +0000
Received: from AM1PEPF000252DB.eurprd07.prod.outlook.com
 (2603:10a6:20b:330:cafe::aa) by AS8P250CA0030.outlook.office365.com
 (2603:10a6:20b:330::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.8 via Frontend Transport; Fri,
 19 Dec 2025 15:54:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DB.mail.protection.outlook.com (10.167.16.53) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:54:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VI0VsDKNVgNIhPu4EviEhTEDh44aQE9lIfIssH5wTrWVFRk8IlUZelNpH6PcsQnRg7MihY1TrCnmG1rW/3mCpMxHgfW1uXf71KBPtmzQgJmWBu4K+Zj5PdXQnIGMmpkzr6aDryF45VE93kbUY/2hUu+258ljvUXkOctugEdd6OQJTFH2cyg6q6oLrZi+Q0wHki7D3OiZtLI3Ky9X/yqV/gHvVHfpMNOYnfNTunguKs3l+VY7wauZye9JgYRpKrb2Fgmd1YYmsaJKE25gIlQGwl1ZN1Bbxk9nrSQzHDcshdPnboNKl5nqNzk+viC9nQymCyTM+BuWHcC0NLc7FRukNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=juYI1FMXu5DQltUeNDu4uMhmRt3TCuj6qWj4/72y17c=;
 b=ymZQPqhytyXjqh0j9hZUQfLNeEOkOO+h9YkCrtH4WAr3QS6kwes4Sih+77R/Qon1R12wOoshri3dqhT2VvY73qg5UTurmWYxS7cYzCOeDOU7cs+iehRK6unrmzmuuXR3kCCNj6Q4hXPnMQb7ALwEktlNT3iNkaqcJ48DPACpgXhOMdfY27WZ9ZhgDCSavPwyM8Wql+3G7ixOHMzytxTxnUyPa1itt8tvysAuKQLV9IPqb/oB7eUIitPkoAlS0bLexjiTh2qz6zQwY20RPN5Oe9HcRSx1ca8mxMiE5qeTT8ynQhAfvcOQ31r49EbK4hRLztLLQoGDxkfEq+YH5DJg9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=juYI1FMXu5DQltUeNDu4uMhmRt3TCuj6qWj4/72y17c=;
 b=kxDFO0YZJvlLOa5TNwmAxG6Yg4y3W4HtNbYl+/Vp2WNoPnIJWPKRnxOwnQ4S3iZYj05YLBCZ8ZSSJk3lHvRcavoqxNUmCungiySjpssDZzXQZ/36+NPQIbkP/YY+wCUnm9xBkq3kDeAGmcx7fKT7EpsB0bT63PslR0jkExfMBXo=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AM8PR08MB6515.eurprd08.prod.outlook.com (2603:10a6:20b:369::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:53:17 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:53:17 +0000
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
Subject: [PATCH v2 30/36] KVM: arm64: gic-v5: Introduce kvm_arm_vgic_v5_ops
 and register them
Thread-Topic: [PATCH v2 30/36] KVM: arm64: gic-v5: Introduce
 kvm_arm_vgic_v5_ops and register them
Thread-Index: AQHccP+FEaF6KlUfE0Ckw9tafdGziw==
Date: Fri, 19 Dec 2025 15:52:46 +0000
Message-ID: <20251219155222.1383109-31-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|AM8PR08MB6515:EE_|AM1PEPF000252DB:EE_|AM8PR08MB6449:EE_
X-MS-Office365-Filtering-Correlation-Id: f85475c0-b05e-4524-31fb-08de3f16df2b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?yhAEzTDBrmzd9ORtc+iWOVYkbIMsmXfie8Nlv3nwVJeeoyFT6c+WzFTzoI?=
 =?iso-8859-1?Q?JpCruBPEdo4ml1Ulz/5rKXuZXDaIf6+saX3TmVnvjitSdvZX76W0/T60os?=
 =?iso-8859-1?Q?dxQNaGQ01KtGxhPnrLpc7IX5dWTxl/s7bGcYpg/fVpV8HETgnFnZyTMyda?=
 =?iso-8859-1?Q?pXAYsAmDxBxN2AYC2/6ZPc+GA4U7vxFnoC+v4y3UCG+QQlhlg4cxDEyPsD?=
 =?iso-8859-1?Q?d54tS6APr8lGkRLpRAZxC8zwBJleSYyFkTtXmyJXFDvh++gfctp/T/yHyR?=
 =?iso-8859-1?Q?BCDVgM5dDf49nHkkRO22Ak1+CUFnO1+NcO6WWbGGuDwMIoqLhHL36aV/Fe?=
 =?iso-8859-1?Q?uvoZJkqzzV9VjCpTparA1/jOhy/Sx4e1A+xLjy1pK9+rD4R7ezq9cSCTB5?=
 =?iso-8859-1?Q?veozU8+1PJPlhBglLZuORJoqWO1aGIYcNxXwULpHqiOIcRt+SIA29uwxgi?=
 =?iso-8859-1?Q?tmR9khhSGYhfvtIhkZPHalvoCJH/HyUobNGlrWpIfWBfJHX31y4lqPRViL?=
 =?iso-8859-1?Q?Oiv8aY/FpNxLutszfZojNryoGRxOJa6RRq5ut5rOoul3t/6p2S8UVZM1Gc?=
 =?iso-8859-1?Q?EXOCb2vGoujWIyUTa7eltBYFIwOpms+oF636PxUO4YFzABIQHcOibv1v0X?=
 =?iso-8859-1?Q?uUdfx5WWb04THmj3qhfnarsTTGRQdb+Wo1k8qAmyzdu4pu0qBdaDnI9tuB?=
 =?iso-8859-1?Q?NLolKJhUxBSpWvCB2Qm7AcCD2IcAWDwzihPilZOw3ExDBDPuF820+Wtyt9?=
 =?iso-8859-1?Q?eUZwpjTjMsp3wd/a3ktdbFXzU0SCVz5F/2rZdwrFzpI26vR/6lSKkXhpIg?=
 =?iso-8859-1?Q?44zBFVgV4GgVSfARdL9H1x1Nx3Q4hsNYaQzS+Ug8EOoe4r5x8fiBOC2/ww?=
 =?iso-8859-1?Q?irPKCxTS6i5DbcyhA+pyDDxJMaJNpt3U2c9Eo/Bplvka1exoGGDubqd9J5?=
 =?iso-8859-1?Q?Lba7yugWzKUmmYyTF/2uA59XlKzPuioNRrxAFk3N7hpPfqjn9/g+SNRQmd?=
 =?iso-8859-1?Q?RNy2L9kVnihhTl3EI2v9MsrzUjCUykVeJCTITg8GepZzHBEknnwwTLovxU?=
 =?iso-8859-1?Q?QqLWslyq5UB/JyqTNdvFA+zUGRUThDIRX5W/vc7YjndO0JFSYELO26wM/l?=
 =?iso-8859-1?Q?VDLv5jf4FciRAMHB0UT5h8y3cQf6D3bTVFI5CAcNo3QmUdrWPBQuuqUO5D?=
 =?iso-8859-1?Q?e2qvK7p+E0rY6++2lKVzq4wPy0c2m0kdiaYhii8KV7HrFkUixc9RKuNow6?=
 =?iso-8859-1?Q?6sBRr7RVhvOeuwZkomQrPPp4h2DnqTEzOeQfs62zg8HgX45F4qT5U8uJrw?=
 =?iso-8859-1?Q?1i/K11yr63zAx7Ovl5Wsx2Tb35dXPMIbJQhniffLTFlvVzVPTmg/OzZc7c?=
 =?iso-8859-1?Q?72PqxMiXPHOs/kh5VfPHfOMxE+T1/rF9x+JSMTw8JHltc7rw1XldZa+TpE?=
 =?iso-8859-1?Q?dCE0GnL2Ax4nz0IVzEnhQm6NmmONvxR1dN03JyqW+YqTPhpOcV2xxOuuH4?=
 =?iso-8859-1?Q?gW/BsowUqsT/LlUHA/6HFaXcXx+B22Bff2u2MxZtrKHPfyfUt8BvFxR1+j?=
 =?iso-8859-1?Q?FrIcEYNbBbv2r+A00u3NICrE2kvT?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6515
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252DB.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	84597f61-727c-4e37-c00c-08de3f16ba16
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?XMxt/hsgC00l9NhT+b30Q0pPiBlAXEAF1mEie5FDFm7IV8zJgtsvrZKvyB?=
 =?iso-8859-1?Q?uD50afhOgwO5zrXW+GC4H4yeUnVhuwsJEgW+BqSau7jEbUYijJssiI4nu2?=
 =?iso-8859-1?Q?Vq8BkDrmVmzye4ytXrn9yt7H0/m1FkpvsiGijyQdrUQFXFj9yqXfIqiiDS?=
 =?iso-8859-1?Q?tcIiz20XCzpnZKIt9ykG2axSLijiqwSh18ZtATHCrJ/I8qhSAMoSVlCbyM?=
 =?iso-8859-1?Q?G5S0Hqk98pjNlGVK+WvUTUpq5uvCcvwPOPBaxkL8Ys/XdhO308GqdTnIJM?=
 =?iso-8859-1?Q?5dZwlRDlvI4+9iYo81j2uJgRZ5Wxsr5Ef0wsVOXw6hIXqqCJFCnyG72nv3?=
 =?iso-8859-1?Q?UoCntJBP5IjieVsNX/OHjOfBGivWvD4VgVISPhsLN+uDSHYe3xpklkX7zU?=
 =?iso-8859-1?Q?qNl+revVOfDXGNTffi/fdiTELBKVWIho0o0+kv3JFKkVhsPeIfWGWTuLpA?=
 =?iso-8859-1?Q?mtZRqYAfCK1pVhBXEl+y2gjjH4RZCithjAIkiG8KN9gSWPLYKgim1Iu5kQ?=
 =?iso-8859-1?Q?gN9FS22BtwuK5sydinGRM/Hg1BumJAgduYKJ4V5XKZlFSFJU0yrjqwL/p+?=
 =?iso-8859-1?Q?183pYJBGuUoccyanc8eumdq84yQwm+3x8OQa2/Hc2gK19rKi6eE1YHahjU?=
 =?iso-8859-1?Q?KibPzMXR2W4RVRZx6MKBb/LDYJQ1agO4jf0B99KWVtJ0ZzEOWrboeMikqR?=
 =?iso-8859-1?Q?Gukp+EcKlYRyHjHZ1zSLj3Nhesy6rf1iAm5Yq701+gLSiwobpD38l7JYz3?=
 =?iso-8859-1?Q?bCuaOjJjwAVjjzGQESzgC2/f/IpQsPuRi0uIR0495Xy0hRPaObK+QPdlXe?=
 =?iso-8859-1?Q?kAhGzCJnqfnEklMTDjEH7Zo4X6BpnrFbzMLU103VgOPjx/tu0m6hjimLtO?=
 =?iso-8859-1?Q?0Kx8Wx5TZ+7NEm3LvMmozuZFles5u0Ujj3eC9Wui+OkTp0x/wnY1RtKM9v?=
 =?iso-8859-1?Q?rhOLenLnnP3Y3E15L3w+F5iXqLFuuf55nB9bHa1cLTwvH+P2lnQF3WG2ki?=
 =?iso-8859-1?Q?eZbQ/jEBL6edmIDdMr+pAFTj6jjzVqeSuVtaVsueOCXp9n9vyuht7Cz9nF?=
 =?iso-8859-1?Q?pp661dfw8vGZC/pyClx7C200b2ktNviJk6RLoOO+Y0gIDeIv1yHdQ0DCOH?=
 =?iso-8859-1?Q?Swl96+YSe4tSLgLY85smCg67IBCeeEHCZ6LztZz8AemC7hH89QA21EwiNk?=
 =?iso-8859-1?Q?JBU8l9y3hkTbDKqXzq9qxjft/k/D9tYAWCp48yuGHfEFJ1F93GVlJCL7v0?=
 =?iso-8859-1?Q?5cyund7ss5Tiuv3gnkEatyTmLpWK3JwHNYrGDPag+4YZEw289Ic7yFEoXO?=
 =?iso-8859-1?Q?oSKX6LvChRtjAwzh7pHGP7EJUfWD4Q9IpwFY50j/L2zSCjy3wH/5RKAU7V?=
 =?iso-8859-1?Q?9SbuWQ6RZYZKgpQKsZ0jh5fhKB5qPQxxe4/hfuBGo+yBoZ7G37C+qJaY9d?=
 =?iso-8859-1?Q?KN3c7tiezEPSLSnn4lVYJcu7CkQ29lp33t+cKrEA6nxU8pbOuAtRQ+FOjr?=
 =?iso-8859-1?Q?g5NQXtj1kyzs65bBaB1+0vgDGp6+AOag0b47Cb64KgoDLkkf2FD6l6a7JG?=
 =?iso-8859-1?Q?AvFr5ZK9gFUa966bvvnL4I5rk7uBgH6VPxNyd9PbckIpQlTqf4mySk8fxc?=
 =?iso-8859-1?Q?CcNTLCaSOEnBg=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:54:19.8220
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f85475c0-b05e-4524-31fb-08de3f16df2b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DB.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6449

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

