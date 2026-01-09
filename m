Return-Path: <kvm+bounces-67594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 37B90D0B8AB
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:12:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2076C3116F29
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:06:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA4C2366567;
	Fri,  9 Jan 2026 17:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kd7YRgNa";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kd7YRgNa"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012054.outbound.protection.outlook.com [52.101.66.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5F73644A6
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.54
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978353; cv=fail; b=CL48/7TLuIf+87OreHyFEATgrq4dzlCq7s4HK9s5+f0f88I7s6hZWIuCWACnqCdQ1HtsevUFR05TnnpL9KJpjDDhAZGrnx+OF2mwD/HYaIPWbXrILhe6nMzKhGK5ixJj7+G3g1CqIu9yzN139OV2H+3aKDkitCaeQZuDJagdTfA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978353; c=relaxed/simple;
	bh=74qkYXcMNou8hSfMUYAn1BIddJjVthqFsW/esuEaq0U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TwgjLQ0UzXCJppbRR3fhAmc24FJ0QS0Q0SygGkWppL2jI6HymNiljKkd3NeSzOdBHuMsIuzGevR9buh0p6XI3zKKo7EYTk9iqy9gPA73tqFbZcEC/QfuGZ3X4V3Y4RIMAz8iJfzqX7kjgS/JINgAKQmE2Opf+6s4HSKdR+MkQy8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kd7YRgNa; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kd7YRgNa; arc=fail smtp.client-ip=52.101.66.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Ks5Z8gpYtMUrOwCLP24H6RaAjCfJbWkzuC/s0lmEic/XRnAeU+lg1zplMeU+XCDcvH+DSYqxiyHij0dHG/ie4S5pFxMNpg4xeYUWnylDyPQl7nkCNRIvtWoTPuKELAoxIBVDJR+GVxrtTuGOX4ae7+42UA7LWkbOhd9Tu7eWcuY89GV3fah7LvGGXnQVnCpbpzpJisql+3vZO0DWyrxv9iOPbHZT0Wf19mXIZlbzqhDbrxN6112262bmIDXCdhyqEjtN2xpO7ZfGvUdjY9YfhoJduuV88VKwLoEAt/xrpzzxssep2cNGP7JHwRJRbQqgdWoRNbgwbmJ8GGgr2T1kZg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=unsyUYFMRbNv8uyuaW4qKmX8ixQABtTpH9QshZ0cpao=;
 b=tIqYhOyhEydRRaGEfhOgEAuTp5ljZ4/q15+XELyZkA0DVU3wuTdtE9OCAjAuMwFr4a1yEJOzV+qeMeABoRVnWOKp+P57eiSacZktiAKVJL4qwOOjan5yNheSBYzMaaHORSZ/sLZA2RJBCGeaJNfKHUp/s1BWKSjPzApmrlvxBoj0sjcI52jl2eQInFVX07RK4ThmW3wLshP397WqfTzrx53kNxZMZSzg2XfGylBfC8dtWXetWtN5oXpFCxPR8Nx82TDqxQX4NjInEGkusiOubWPAdqH24amgE02X2CoCS6FoG6y2Fc+HQGESaRkWxqqsonhzuw7iHV7AyJ0xo6oFJQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unsyUYFMRbNv8uyuaW4qKmX8ixQABtTpH9QshZ0cpao=;
 b=kd7YRgNa/ep6TgLgjxr19Wb1nsdWavgatr88xjLJTMsUflvZ8w4TSzXjRuN6TR6j7tOMS+a2zhrdZgnPaLe04h1zmip48tuksV8AN8X8togz7emLyzp+5Xoe2CT4uqjvP5Z55D9wNc9ONzpf8fKoaAYSsiImzzuYNtwdQNmQA1c=
Received: from DU2PR04CA0055.eurprd04.prod.outlook.com (2603:10a6:10:234::30)
 by DB8PR08MB5322.eurprd08.prod.outlook.com (2603:10a6:10:114::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.1; Fri, 9 Jan
 2026 17:05:45 +0000
Received: from DB1PEPF000509EA.eurprd03.prod.outlook.com
 (2603:10a6:10:234:cafe::a6) by DU2PR04CA0055.outlook.office365.com
 (2603:10a6:10:234::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.4 via Frontend Transport; Fri, 9
 Jan 2026 17:05:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509EA.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:05:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bIRow09tGMIa5V7vl1/0kcPLbAEeTfII+EMSoO/XMdqs1isIa9k95XEb3hSIGIoBSco+ge+j7u+H421CJ2kXPBG8SS/3T6TY6v9JiiVPxqToXr4X6CcniKJzranfqhpaXG1v77yNhOK1rTVWX/isFm2uL938rycuwg7EIDSb5Aq9HltEIlBLjQKald3cajjKxE3/d/fD8VSIW06n5B9ub5grXRbe4sfHEfQ6j4JKjtV3K0M0xTr9wC24rJxNO2cE283j9+Ojl5moTilQxokV13uXwBT6BgNyOm9seO1Hq2IgjJKzQmrC/C31WYqiq6OmnSwNoAWIp9mU1SDAGtElLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=unsyUYFMRbNv8uyuaW4qKmX8ixQABtTpH9QshZ0cpao=;
 b=K0nip406OsDFE6tnwYrAK1Nal1w/b/OQTi0MK9KzZZWL2WDM3/CXe1ilVahJuH/YGWyLwm/XJ0BPkmPy5WrHJp3qL/7gjS1TOkEBojjs7DHUmBMf24ebZg2o0+FdxnjQt77pcQ1BanmV8RZePJ0/WhOMI9WMwGJ7kymUOEd7Hbu1P/VW6zI5dzETzo276CqpJDl5kMtCqlypB+GVvDZiA2clRrtHxsbeVXhFQovanlLgfKEM9siMCe2Y87XTbXZtJj+fy9l7j0Hqk0JZKOZRdPunmU1oltktm73vte10efdnedrSuHZ9Or+oOIAGGGM6wuRu50p9OBm7INsg9f7XMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unsyUYFMRbNv8uyuaW4qKmX8ixQABtTpH9QshZ0cpao=;
 b=kd7YRgNa/ep6TgLgjxr19Wb1nsdWavgatr88xjLJTMsUflvZ8w4TSzXjRuN6TR6j7tOMS+a2zhrdZgnPaLe04h1zmip48tuksV8AN8X8togz7emLyzp+5Xoe2CT4uqjvP5Z55D9wNc9ONzpf8fKoaAYSsiImzzuYNtwdQNmQA1c=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS8PR08MB6216.eurprd08.prod.outlook.com (2603:10a6:20b:29c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:04:41 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:41 +0000
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
Subject: [PATCH v3 08/36] KVM: arm64: gic: Introduce interrupt type helpers
Thread-Topic: [PATCH v3 08/36] KVM: arm64: gic: Introduce interrupt type
 helpers
Thread-Index: AQHcgYoLOBU0OpvefECEEtcET4fz3Q==
Date: Fri, 9 Jan 2026 17:04:41 +0000
Message-ID: <20260109170400.1585048-9-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS8PR08MB6216:EE_|DB1PEPF000509EA:EE_|DB8PR08MB5322:EE_
X-MS-Office365-Filtering-Correlation-Id: 41175c16-2071-43f8-0cdd-08de4fa1543a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?n8wE4NRmu0jesHytq7r6mnAdnt221Hjpbmqfw5z3brdsDy7/gRiENRUAZW?=
 =?iso-8859-1?Q?WP43qAVr79yKjmlbQfrft8RgzG02VMgdC1eABcMCrRD2Ap8u0kpjcH8PUE?=
 =?iso-8859-1?Q?+BOV1GSNRZlREXRtG7mihUUpDEMQPlSXZaIQTJkPWZTbDC23T9NQ0fAE8w?=
 =?iso-8859-1?Q?Qgo6rz60Xu3d8XMSgGrplCOLRBo5/t7vGbvMgXUQgUEFT4yf7bW49DTYZc?=
 =?iso-8859-1?Q?haZCcPKstS0Jee3Sr+w/yez+Xp8gCxEKTk7UUJjAd7j7TsrC3rHJHnUqbB?=
 =?iso-8859-1?Q?ho+xL6F52C3nPNh+DUD7n0hLTd6xAJEoMKGSJcNMGB+T96QhctiboAQ1NX?=
 =?iso-8859-1?Q?zj+WLnyYDkaihsq3KGd7Qq6t1Iwgq07rgn2go09d8WAcDkt/MFf+S4n5kv?=
 =?iso-8859-1?Q?J2slciLi0JqY+BJX6C0O09KQA4bq2BSEOrK3ioKBQEzlMR6eEsmPV1lTAc?=
 =?iso-8859-1?Q?T1ptoluXZAYQVy/K/3M0ForSCC9a9LzpyrqKCfcmm9SDSEXlM6T47TZbj2?=
 =?iso-8859-1?Q?dI6H/8w9JNr1qkZZmiFNx3vTzbVyaJLdJ0bTWoQ8aSUoM+Z4EnjSEic9n2?=
 =?iso-8859-1?Q?4bhCstAK68vZHqnH8imw7gMZQVB62QdiNSHS0K5xisYxXP/NJoxfjXVhrg?=
 =?iso-8859-1?Q?FGBRwqBqbGI8Uw8zB5RF3mW+jP60xDXMm4OmcxCNgV9Gp6jLXk3Lu8BGTg?=
 =?iso-8859-1?Q?8nIDK59znbK13WXAM6QKGjaphzeEwoqeoJD2NHMq+DQRNr0FS4/TxCWqmb?=
 =?iso-8859-1?Q?UiJKnLspUrP8+xdCA66BrFCGF55GAWIjt3S73hgb4kiqugVycSw+QKy1WA?=
 =?iso-8859-1?Q?juTW9x9OunUGyxL0bR7Wv6V0QdsgydDIdx+FO+uqJb3OcBlH6HcYLt91iM?=
 =?iso-8859-1?Q?tRN1ITB9gcRyd9xvsw1wMC+7GacF0y5dR+83g6PJyLKAGZqk1RPt6vYlPJ?=
 =?iso-8859-1?Q?j5L1aHeWvlzPMKH2dcVb7rPeA8p0gThHkZCMYeU3USpWGRQPoC1AlCtFlP?=
 =?iso-8859-1?Q?bQUIhykOEtU0P6PRbfK0IEfRg6mJoYNo50G+02RIAFWTjYXUpsLI2ogsxu?=
 =?iso-8859-1?Q?gBGS1Voio5WhV452eypZIGlvmEk65BVaEVu4Mgzh6EP/45DBZB3iB5NdtR?=
 =?iso-8859-1?Q?9u3HsT9qKYJLAb8RasxxIAs1CmY9QmDK1oFU9hDSUtOr0vjUepnIkkSa3r?=
 =?iso-8859-1?Q?inUF6jJja+dKogiU076IgJwmrlNISzLJSbGVVyABDVsMQWAvhsN8uvy7mV?=
 =?iso-8859-1?Q?ZP11gWixISGaz24XKEXf5jnRrc1XDmN+lwUJnlDHwRxLOUZWk8vE5ZQzFQ?=
 =?iso-8859-1?Q?T7H2GmAlkThvCUoJNC3hTM67mbP/CGSTaAeWdtrtYdTOWT2/iHdOdgn95I?=
 =?iso-8859-1?Q?5NsbGYwgu3iHbp1hbpsBiKT10WxnzvSXh91YV8b9lP55L2Wg+RhypOOidQ?=
 =?iso-8859-1?Q?qVlZ0LyB/JP+HZQbkLcIAVIFb+omnNu4s7rSAQYWH+atIRPO3NVzmEBKE1?=
 =?iso-8859-1?Q?w2zNgbeYS/eHBAIn+W1lbqf2mDPniaeFiI0FJOB4pEUsHs4IiejOMsXCzh?=
 =?iso-8859-1?Q?Sj2tEShvdC2rEFGM6ZtKRAZn4GNl?=
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
 DB1PEPF000509EA.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	16e54d7a-b68e-4252-ec42-08de4fa12e38
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013|14060799003|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?+ZzYAunqdUo0IJBQC5dU33Jy24uKUECRhUJ1ulkYfW1nc05q6IiHIkT7jm?=
 =?iso-8859-1?Q?+kbmQXwgd0jRtNUe6i7EP8FF4YmuwqIv67T9+2KdMN56yEpRfIs+6sdym4?=
 =?iso-8859-1?Q?aQ6lHQ76Z8Qdaf35f3hnzZv/tHEs+AhfJ3gtGBtJugi8hqvzkrhetjCGnM?=
 =?iso-8859-1?Q?Kb4PL/4nM0BFKTQuWPqz1iORv4FRNDGsPEAtcQVPAijFQgKbOiPPW+PEHc?=
 =?iso-8859-1?Q?AZRQVLz+SdJcf0ofJ6BlNPX4euRLgoRsHH+Z3K5yMq+2XieGOwUAH/BYbA?=
 =?iso-8859-1?Q?EZcg1uPFn7sC/bKanzyRgH7N811wFT1MJKoQxuXailnM6MHSJd7BCvCPzL?=
 =?iso-8859-1?Q?gHhmdxPeKeCvqlmcb4Z+qdVepDGryigm3o8ZQKMMJcaE1vXRA/Fx7awz1Z?=
 =?iso-8859-1?Q?8qVDt79Jhina1yIjwl1Cdva1M1P6Y/ekKITF4zK7ONeMV1WUVseQDH9LWT?=
 =?iso-8859-1?Q?eaLAP+aSpz+HzG0eeNuSMxdiessjY3fyBFZgh+gAbR2UcvtdLOzKfGxoLS?=
 =?iso-8859-1?Q?hZFSEfiUtR1HchLeP99n//khbrVFOnkot1743wsGfBhu4ReOBXNzNQysN7?=
 =?iso-8859-1?Q?xUGLIhNhBWwLL7x5qHE9pa+aWtrSMnDVrr3St8+LhcyM2byi5EBsqnD/Wt?=
 =?iso-8859-1?Q?ucTBvBp+ikUcUmEcej6IISgq0i40rU/FP/aJFIa0SEgyGM+EPDkM3Yg44Q?=
 =?iso-8859-1?Q?FA44JKCSubZFWdNDvnU+ccV26+BMO+gd1KIOslLZc+e8j/r4fr2W/yJZrU?=
 =?iso-8859-1?Q?uouTxd5rGKr+eZ8dEz4BFZEebLxDXuyzPHW85NpsCbDqBVjWZ2qJi91lj8?=
 =?iso-8859-1?Q?3CM9jnULczlVgSpSMHBATopqIyIuVaInAOmjoFNw73Rd3i1bb/32rZ6WHB?=
 =?iso-8859-1?Q?LlyQTYSnhL5xi43yBUAruEiIzTuT+Cz7kGFjGts93A25jTFoxsg/4krcw9?=
 =?iso-8859-1?Q?HDiB4WIeBl/gcUNtaX371bv39ok1q5IKmj3973aGslzZ6OT0DRcX/2CTBc?=
 =?iso-8859-1?Q?PElAh5jI0pMfUQFDG+SU6rGx7BJD0tYb2DYkYdUd0onlrfVjDNF1ULAKyf?=
 =?iso-8859-1?Q?jp9Pf6LyI7+h+bM1t9/lstipdxybIWcyHaD3yOzyNf6PNom9OENWA+8Ip0?=
 =?iso-8859-1?Q?YWR16U0qSsfpCwCybioD4PYOSS/yV/R5WWEKmxndO5ALip+0gSnxgfRBaD?=
 =?iso-8859-1?Q?FWx5DsPkKzJrGNk7t9YRirfJ6Pv/N716Qq9JvGnKiukMSdewG0I3pSBTiM?=
 =?iso-8859-1?Q?44z65vWI8Mfo064Af/pXNSc/zbehq44aK7848b1A3UD90n7usqRjNapzt1?=
 =?iso-8859-1?Q?szjxJ2rugDOv00XuhsjPDhpzU9hCni6QzkpiF9rs5J9IBYkhb4j1DgDiac?=
 =?iso-8859-1?Q?vLGM0T1U8I8aguoKmVD3WqckSQ+65eXzQDFVAqi1XNrrqJCchA9LVXjtTX?=
 =?iso-8859-1?Q?EQzjjx8Ih45uRfB3F/ELCbAF7B4V/+LkVZsCvJh2/MaXMRJIIdnV5iQ/tm?=
 =?iso-8859-1?Q?eixHZgdFMLhvuBdIgGaWN/X+Uf8qi5DPi6mmopV8d4P5uTj4n2Zp9KNFrD?=
 =?iso-8859-1?Q?qMDWFtJrJmjZRJsrtTnBsVwJyc9VDUZOwKzTT137LF1pqNSe/jEWJprrWk?=
 =?iso-8859-1?Q?/rO65uOiyE4zw=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013)(14060799003)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:45.3457
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 41175c16-2071-43f8-0cdd-08de4fa1543a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509EA.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5322

GICv5 has moved from using interrupt ranges for different interrupt
types to using some of the upper bits of the interrupt ID to denote
the interrupt type. This is not compatible with older GICs (which rely
on ranges of interrupts to determine the type), and hence a set of
helpers is introduced. These helpers take a struct kvm*, and use the
vgic model to determine how to interpret the interrupt ID.

Helpers are introduced for PPIs, SPIs, and LPIs. Additionally, a
helper is introduced to determine if an interrupt is private - SGIs
and PPIs for older GICs, and PPIs only for GICv5.

The helpers are plumbed into the core vgic code, as well as the Arch
Timer and PMU code.

There should be no functional changes as part of this change.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
---
 arch/arm64/kvm/arch_timer.c           |  2 +-
 arch/arm64/kvm/pmu-emul.c             |  7 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c |  2 +-
 arch/arm64/kvm/vgic/vgic.c            | 14 ++--
 include/kvm/arm_vgic.h                | 92 +++++++++++++++++++++++++--
 5 files changed, 100 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 99a07972068d1..6f033f6644219 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1598,7 +1598,7 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, str=
uct kvm_device_attr *attr)
 	if (get_user(irq, uaddr))
 		return -EFAULT;
=20
-	if (!(irq_is_ppi(irq)))
+	if (!(irq_is_ppi(vcpu->kvm, irq)))
 		return -EINVAL;
=20
 	mutex_lock(&vcpu->kvm->arch.config_lock);
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index b03dbda7f1ab9..afc838ea2503e 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -939,7 +939,8 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 		 * number against the dimensions of the vgic and make sure
 		 * it's valid.
 		 */
-		if (!irq_is_ppi(irq) && !vgic_valid_spi(vcpu->kvm, irq))
+		if (!irq_is_ppi(vcpu->kvm, irq) &&
+		    !vgic_valid_spi(vcpu->kvm, irq))
 			return -EINVAL;
 	} else if (kvm_arm_pmu_irq_initialized(vcpu)) {
 		   return -EINVAL;
@@ -991,7 +992,7 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 		if (!kvm_arm_pmu_irq_initialized(vcpu))
 			continue;
=20
-		if (irq_is_ppi(irq)) {
+		if (irq_is_ppi(vcpu->kvm, irq)) {
 			if (vcpu->arch.pmu.irq_num !=3D irq)
 				return false;
 		} else {
@@ -1142,7 +1143,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, st=
ruct kvm_device_attr *attr)
 			return -EFAULT;
=20
 		/* The PMU overflow interrupt can be a PPI or a valid SPI. */
-		if (!(irq_is_ppi(irq) || irq_is_spi(irq)))
+		if (!(irq_is_ppi(vcpu->kvm, irq) || irq_is_spi(vcpu->kvm, irq)))
 			return -EINVAL;
=20
 		if (!pmu_irq_is_valid(kvm, irq))
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 3d1a776b716d7..b12ba99a423e5 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -639,7 +639,7 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
 		if (vgic_initialized(dev->kvm))
 			return -EBUSY;
=20
-		if (!irq_is_ppi(val))
+		if (!irq_is_ppi(dev->kvm, val))
 			return -EINVAL;
=20
 		dev->kvm->arch.vgic.mi_intid =3D val;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 430aa98888fda..2c0e8803342e2 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -94,7 +94,7 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid)
 	}
=20
 	/* LPIs */
-	if (intid >=3D VGIC_MIN_LPI)
+	if (irq_is_lpi(kvm, intid))
 		return vgic_get_lpi(kvm, intid);
=20
 	return NULL;
@@ -123,7 +123,7 @@ static void vgic_release_lpi_locked(struct vgic_dist *d=
ist, struct vgic_irq *irq
=20
 static __must_check bool __vgic_put_irq(struct kvm *kvm, struct vgic_irq *=
irq)
 {
-	if (irq->intid < VGIC_MIN_LPI)
+	if (!irq_is_lpi(kvm, irq->intid))
 		return false;
=20
 	return refcount_dec_and_test(&irq->refcount);
@@ -148,7 +148,7 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq=
)
 	 * Acquire/release it early on lockdep kernels to make locking issues
 	 * in rare release paths a bit more obvious.
 	 */
-	if (IS_ENABLED(CONFIG_LOCKDEP) && irq->intid >=3D VGIC_MIN_LPI) {
+	if (IS_ENABLED(CONFIG_LOCKDEP) && irq_is_lpi(kvm, irq->intid)) {
 		guard(spinlock_irqsave)(&dist->lpi_xa.xa_lock);
 	}
=20
@@ -186,7 +186,7 @@ void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
 	raw_spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);
=20
 	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
-		if (irq->intid >=3D VGIC_MIN_LPI) {
+		if (irq_is_lpi(vcpu->kvm, irq->intid)) {
 			raw_spin_lock(&irq->irq_lock);
 			list_del(&irq->ap_list);
 			irq->vcpu =3D NULL;
@@ -521,12 +521,12 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_v=
cpu *vcpu,
 	if (ret)
 		return ret;
=20
-	if (!vcpu && intid < VGIC_NR_PRIVATE_IRQS)
+	if (!vcpu && irq_is_private(kvm, intid))
 		return -EINVAL;
=20
 	trace_vgic_update_irq_pending(vcpu ? vcpu->vcpu_idx : 0, intid, level);
=20
-	if (intid < VGIC_NR_PRIVATE_IRQS)
+	if (irq_is_private(kvm, intid))
 		irq =3D vgic_get_vcpu_irq(vcpu, intid);
 	else
 		irq =3D vgic_get_irq(kvm, intid);
@@ -685,7 +685,7 @@ int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned =
int intid, void *owner)
 		return -EAGAIN;
=20
 	/* SGIs and LPIs cannot be wired up to any device */
-	if (!irq_is_ppi(intid) && !vgic_valid_spi(vcpu->kvm, intid))
+	if (!irq_is_ppi(vcpu->kvm, intid) && !vgic_valid_spi(vcpu->kvm, intid))
 		return -EINVAL;
=20
 	irq =3D vgic_get_vcpu_irq(vcpu, intid);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index b261fb3968d03..67dac9bcc7b01 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -19,6 +19,7 @@
 #include <linux/jump_label.h>
=20
 #include <linux/irqchip/arm-gic-v4.h>
+#include <linux/irqchip/arm-gic-v5.h>
=20
 #define VGIC_V3_MAX_CPUS	512
 #define VGIC_V2_MAX_CPUS	8
@@ -31,9 +32,78 @@
 #define VGIC_MIN_LPI		8192
 #define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
=20
-#define irq_is_ppi(irq) ((irq) >=3D VGIC_NR_SGIS && (irq) < VGIC_NR_PRIVAT=
E_IRQS)
-#define irq_is_spi(irq) ((irq) >=3D VGIC_NR_PRIVATE_IRQS && \
-			 (irq) <=3D VGIC_MAX_SPI)
+#define is_v5_type(t, i)	(FIELD_GET(GICV5_HWIRQ_TYPE, (i)) =3D=3D (t))
+
+#define __irq_is_sgi(t, i)						\
+	({								\
+		bool __ret;						\
+									\
+		switch (t) {						\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret =3D false;					\
+			break;						\
+		default:						\
+			__ret  =3D (i) < VGIC_NR_SGIS;			\
+		}							\
+									\
+		__ret;							\
+	})
+
+#define __irq_is_ppi(t, i)						\
+	({								\
+		bool __ret;						\
+									\
+		switch (t) {						\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret =3D is_v5_type(GICV5_HWIRQ_TYPE_PPI, (i));	\
+			break;						\
+		default:						\
+			__ret  =3D (i) >=3D VGIC_NR_SGIS;			\
+			__ret &=3D (i) < VGIC_NR_PRIVATE_IRQS;		\
+		}							\
+									\
+		__ret;							\
+	})
+
+#define __irq_is_spi(t, i)						\
+	({								\
+		bool __ret;						\
+									\
+		switch (t) {						\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret =3D is_v5_type(GICV5_HWIRQ_TYPE_SPI, (i));	\
+			break;						\
+		default:						\
+			__ret  =3D (i) <=3D VGIC_MAX_SPI;			\
+			__ret &=3D (i) >=3D VGIC_NR_PRIVATE_IRQS;		\
+		}							\
+									\
+		__ret;							\
+	})
+
+#define __irq_is_lpi(t, i)						\
+	({								\
+		bool __ret;						\
+									\
+		switch (t) {						\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret =3D is_v5_type(GICV5_HWIRQ_TYPE_LPI, (i));	\
+			break;						\
+		default:						\
+			__ret  =3D (i) >=3D 8192;				\
+		}							\
+									\
+		__ret;							\
+	})
+
+#define irq_is_sgi(k, i) __irq_is_sgi((k)->arch.vgic.vgic_model, i)
+#define irq_is_ppi(k, i) __irq_is_ppi((k)->arch.vgic.vgic_model, i)
+#define irq_is_spi(k, i) __irq_is_spi((k)->arch.vgic.vgic_model, i)
+#define irq_is_lpi(k, i) __irq_is_lpi((k)->arch.vgic.vgic_model, i)
+
+#define irq_is_private(k, i) (irq_is_ppi(k, i) || irq_is_sgi(k, i))
+
+#define vgic_is_v5(k) ((k)->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_V=
GIC_V5)
=20
 enum vgic_type {
 	VGIC_V2,		/* Good ol' GICv2 */
@@ -418,8 +488,20 @@ u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu);
=20
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	((k)->arch.vgic.initialized)
-#define vgic_valid_spi(k, i)	(((i) >=3D VGIC_NR_PRIVATE_IRQS) && \
-			((i) < (k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS))
+#define vgic_valid_spi(k, i)						\
+	({								\
+		bool __ret =3D irq_is_spi(k, i);				\
+									\
+		switch ((k)->arch.vgic.vgic_model) {			\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret &=3D FIELD_GET(GICV5_HWIRQ_ID, i) < (k)->arch.vgic.nr_spis; \
+			break;						\
+		default:						\
+			__ret &=3D (i) < ((k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS); \
+		}							\
+									\
+		__ret;							\
+	})
=20
 bool kvm_vcpu_has_pending_irqs(struct kvm_vcpu *vcpu);
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
--=20
2.34.1

