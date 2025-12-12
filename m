Return-Path: <kvm+bounces-65856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 393FCCB9198
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:24:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2CE6F300AC41
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF3833242D5;
	Fri, 12 Dec 2025 15:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kmjzBrim";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kmjzBrim"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011012.outbound.protection.outlook.com [52.101.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F5A317711
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.12
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553033; cv=fail; b=WDiM/PmIKQbvyuQO+uOMZxFNdFuN+riMiq1oMCEghe7suoyubvYXjDRvMag3hTAFYFTNi6upBv1rZKSnxGeInf/oWniL4oamcReHtVT0JgBA61EfnySWDarm/34FRtJYfSJ9NWmcdCSFE37I+WeQbNn/Uoijv1rG+hW/e4lyfP8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553033; c=relaxed/simple;
	bh=fB+GNv2d2FB7gfOjsiNRKbhF5QnGMAh5f3XEaPSbmyk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=o4gcfFZ9oj1GKOR4xtccGcwjpNciLVBsUQfwPb80dsTtYVEdd1+kNUn1IHcZOZ4vJrULktxuANDnWeUPzb5C47NKEf051H4u98tcPVb3boaA7U7gcH+K3CzF0e0pPHk94tkZpboWvgEFy9rDbeZLlggz6TpDGeAen0IS6sUfT44=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kmjzBrim; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kmjzBrim; arc=fail smtp.client-ip=52.101.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=fFGSW1/RktISMK8dd8ZR2r5auEbs1Sbvyt3yBgLs03gmE5ufmiM+6aij5Ssdbd43raqhW1u2IYtemCkJleYSAMl8PAnLUTH/25FcbZo23lJ4iArSFC8g9pzyHj5kNtBvqaEPJW43DUiJgZXx7oHRJP8pE+GIExgVIslgcCV7ZMfONIpD5ioUHBJ17s4DydURoR3W6id4vbueFrdxLrXSx4JExuwwLCfvYgxp8e4cS4tJDIz8KYJQXWgmX5uwuD1P1ME+fcGSwHzpYYh3uKvTwmo0Z9NxRnWXZFci4Ed8bHwXge9KjGkvsAR31huTd8b+LzDVtX1xCfZVHZh0NqZpUw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tFdvtdvddPT5KgEjYsk8pYAWKHkONdDG7sGtyiAsRLU=;
 b=aqnFAAFMjTyAN7S1moUX7yZOpdE1vzNTGJWAzbdfLYWm3O/Rv8iKxo985LN1EtcREyR78LMk9lOzuUOPnMsWPdmsQJzXRD4SwYcEHDVxyqOJbYHtCxJNXIgQ6PxH0g5SnRp0TEWU/zWmaNmu6Y7Nlhj0tECKtNqCGv7lotZaFGUmKp7hjnikXvOFKbOG+lMfY7z3JHHZZ8Oq3aA0ra8k8cI86qXdfF3sJNqMpj2pSAgdafiW7eGrqeE+lPSCsDgxBQzxFlWwv1Hkl0D6sT6Gg9mnSJgNlkr7IVA8g2MowZ66ly/isNJlOIe/0vT7sMN5a188RVICIAIL8C180sM7qg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tFdvtdvddPT5KgEjYsk8pYAWKHkONdDG7sGtyiAsRLU=;
 b=kmjzBrimBOeou8BMHoMbYVnbXaBrAqpdlWijT0vmykg42XrDtr2nf2fEiHFVHmw+ynBXMT1yVVQhF/RAi74j6y3Hav9X//rdT1P6v+wrwDIqljAmABnsZpAShqoTFGmmwBQiffEBjuG6rmcreVS9LrTnP9cvnxh7N+7c/I1tbx8=
Received: from DU6P191CA0051.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53e::7) by
 AS2PR08MB8928.eurprd08.prod.outlook.com (2603:10a6:20b:5fb::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.9; Fri, 12 Dec 2025 15:23:42 +0000
Received: from DB3PEPF00008859.eurprd02.prod.outlook.com
 (2603:10a6:10:53e:cafe::2e) by DU6P191CA0051.outlook.office365.com
 (2603:10a6:10:53e::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.10 via Frontend Transport; Fri,
 12 Dec 2025 15:23:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF00008859.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 12 Dec 2025 15:23:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OfAld+buqwtobqDv02G7uy5MxVxDloNa9zXGIsRpMZT1p6WCR6zOEuKBR6E+rfX1Ftsf9tzKrZwyEMV8aeZ7tjNwxKMyYKIo0yX5jSb5tLlkWcr3PmXDJS/PfpuQtM0+pU3WQYN5PEBx0703/qV3M4YRL37cjUCIbZE1fVjbaCeGs9iaymPvl+TR4qiVcSEsFygHN1GDte8JeLJUntmJAeSySFkhNBKERmeOlWzeWQFJ4BxnOKWozyzlPmHxlp/2/yZ+Rmdp90kL/F0IMGuTV9IxjC9o/J+8zFu7+eknaLlNOAgu8DZpful7lB15lZeG5elaaHnWqGMH83s9CgDu4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tFdvtdvddPT5KgEjYsk8pYAWKHkONdDG7sGtyiAsRLU=;
 b=VVFxP5jxT/5oQPHZkt8wJnb8Z/em4oiT8IKI0gvfONT5cS9cmaICqd+JL3shXf0s6TEOLkWChBjwMhqF/ASFc9Ptpq5ehj3+QT3jLdGRd91JrhdybsIe2ypsiyQ16kWfBg2Kii4STXEG9jYhaZz2q0RyvnGKQv3KS/XaV2eRpKI8Nat49/7rUAvM2x0GzGBI3Z80MNSc/hZIggVj1rzUpB16zLjKUnz+Eg57gmcezqs5IKkevxPUF5cBI53XBV85n9LLsf5PahbElKBAlmo+0rY/+r2P9KzC0sYYko+MGPKOMWzjad+XdJI15U0xWZ9w+a4wf5PeutGLPOZc11ahOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tFdvtdvddPT5KgEjYsk8pYAWKHkONdDG7sGtyiAsRLU=;
 b=kmjzBrimBOeou8BMHoMbYVnbXaBrAqpdlWijT0vmykg42XrDtr2nf2fEiHFVHmw+ynBXMT1yVVQhF/RAi74j6y3Hav9X//rdT1P6v+wrwDIqljAmABnsZpAShqoTFGmmwBQiffEBjuG6rmcreVS9LrTnP9cvnxh7N+7c/I1tbx8=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PA6PR08MB10565.eurprd08.prod.outlook.com (2603:10a6:102:3ca::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 15:22:40 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:40 +0000
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
Subject: [PATCH 14/32] KVM: arm64: gic-v5: Implement GICv5 load/put and
 save/restore
Thread-Topic: [PATCH 14/32] KVM: arm64: gic-v5: Implement GICv5 load/put and
 save/restore
Thread-Index: AQHca3snr2OLKgEPBUyx+ouJOXBKPg==
Date: Fri, 12 Dec 2025 15:22:40 +0000
Message-ID: <20251212152215.675767-15-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|PA6PR08MB10565:EE_|DB3PEPF00008859:EE_|AS2PR08MB8928:EE_
X-MS-Office365-Filtering-Correlation-Id: 23fff8ca-62d6-4661-087f-08de39926f0d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?L++Zz+mWfUcOsr4acBglxdTfEBNS5RkorxZCGAPyMwuVLflkHdeCx8Ji0n?=
 =?iso-8859-1?Q?dX2Vg8sTQtuNUA28rG6MBcbvIyDKwLq2ZwDaZGuLms1uILJqv2inyJRw3o?=
 =?iso-8859-1?Q?DSJ/K0BhH4o5EGGsPQ+0y73zvDHGUxcrttyEsR4bkhsdsL/Ls+dlyFCh2w?=
 =?iso-8859-1?Q?ZuQXAeQxdEAWkMB2dxp9aL7u0+ZPjdA/tjvUvfrh6Cowa4+YgsjncDK6rz?=
 =?iso-8859-1?Q?BKO8+rfcJxgQXirAhrLRXQw8gEvbawBHskl6OYimt5Fnbrb44jEhUTtkTS?=
 =?iso-8859-1?Q?yQOQ8fU35oI32Ac65Z9LWoPjErMk/Hm3AnaKZnQiTNrGvgAcbBbq5QFsxP?=
 =?iso-8859-1?Q?O3V2fRpzl/OKQE9GZE9pj9kJeRT91aZrAy78oky2042UWbtmuwdrztMhds?=
 =?iso-8859-1?Q?qST7nnscejO3yM/ZWNAHeGxcxK7IZLuzKwETAaa3aU+tZbDfzvRs1wdekx?=
 =?iso-8859-1?Q?xNquFt8+nf90lCsV0f9ovg4kd6JmSc6STyDqYROmhQLmKHvpk9Q9uQxYYl?=
 =?iso-8859-1?Q?mo9hg5aUNk8AiTYb71PjMUw3hQYR6qCvUqmfJQbElRWfYOE5iWYujmxmOd?=
 =?iso-8859-1?Q?9cSYMGN5fbQN+0RVA987BM9GNGzRQ0NWqVNTmm5X6jvSxXaiBsmogiPsKF?=
 =?iso-8859-1?Q?ZhtrMcvcdygYthrAbCM7IT+9RVW0cOt6n68koIhW50kmSJD8Gd2fMylvGZ?=
 =?iso-8859-1?Q?JpGXTRIxTtg8fa4JGZhRxIDQBue2giN0ZI84LaS1Bw7qL7yRoJf6L/tbTY?=
 =?iso-8859-1?Q?66ziXcNCfga4k3gYHwHOpIfde/faWpPPBsbVxnKfK8Ti161zM5clVHGRDC?=
 =?iso-8859-1?Q?emTOADXQYA8hnj/vWKpCFXzHZUvKyD/3lgRT00a6hyXE/kwecv9lmX5JgV?=
 =?iso-8859-1?Q?caEYK2adSAcPT7PQjboufaKTdZuNtgNA4ZmYpdVJm2sASqvQerqfINervo?=
 =?iso-8859-1?Q?68B0pdECBtI9+XQvvweZk03J4CMgAtcGQvwMVDWAVxfComVZJsSCdOkB8w?=
 =?iso-8859-1?Q?VKRTC2S0q5rr7tzeldIE5XzCtsjHCIOqqKoUzqPL4I3GH692/SCkCrCzSF?=
 =?iso-8859-1?Q?IqSxCJFdcHw5LR6257yDSbjxEcYeesR+xqCQjT4DUynXJ92CunkmQGscDW?=
 =?iso-8859-1?Q?9re1UQUuNDtnTVIBaPH9WjN2nNRERCbzn6xJ0hEivUE9k/65RLxsJOcEHT?=
 =?iso-8859-1?Q?VsZTr0C7YPfyrMeaGgUq/y4osfQn19N/N0wht5HaefMAqD8ETuqA9bC0bH?=
 =?iso-8859-1?Q?+HlvwwLeFlNhVzdKe66Jwtz52MxuufkXgQEg0u8JVhuj/3Oi25DHLRWkHM?=
 =?iso-8859-1?Q?czHp8T2vgt6m3WiY5dfrw49tiadRCgs2KgcLom8GZ2WHI5amsf+0WDHeOt?=
 =?iso-8859-1?Q?73FD6tTPWCibWdzZWONHpAkCvy3wSnG9eFM1IWa2BMeHg2hnzoRp9/f8t2?=
 =?iso-8859-1?Q?YWrvp8awI03jeTJJ+d1R2SarQGtdO/gi5DvHOiEsc8W0i8p78jf9THZrqY?=
 =?iso-8859-1?Q?KpRl5vLV7OcOFF0b2bLdOQqyhogVGublU3BHNgK2Lwd8JbS6K0JXDlwTha?=
 =?iso-8859-1?Q?kKD/k3qg7vu69oAD1/Cz5vxfYTHu?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10565
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF00008859.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f1df3382-545e-483f-af1a-08de39924a01
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|35042699022|14060799003|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?06ghibRpasxi2kGX6N5J8RmSz+JoWy30mA6BBHNAkFMORrOuiFWtL6cjeJ?=
 =?iso-8859-1?Q?wfmSvLO7INNrbWmoKikR2LSUbwt9GV8zFbrgLvSuR0VIx2c0xdmNeogluZ?=
 =?iso-8859-1?Q?SEDUaJVOAc5N1gD8r2nrJEuGK/AD7VHEfhlYJfFtKSFajFEZdtkNBCrXlQ?=
 =?iso-8859-1?Q?TxArv1Hnwkwcm41yChaQPjk4N8gjHyf3Ud93Wwrj4bEtvSLZNUXKsbeRK4?=
 =?iso-8859-1?Q?Y0jzE4ylftPx2DNuxO7NMw+kkIGR7aVq6x0ppcHh+V5HFh+qcgE4UcR8+d?=
 =?iso-8859-1?Q?lBPmPwK6hgiFj5u42/gf+3mcW4MO9QYkO2XM5rOw9BpYfyzo4SSXBW8v10?=
 =?iso-8859-1?Q?dvzyPX8qyAPK5LSuHv8m/oYSqa53TVYG4aKq8xVY9kIkQO9fE9LtMGlPsM?=
 =?iso-8859-1?Q?wwwrXSS7UTIUCvTaMpzgCIVfH6SyGr4y3lk2d2SEkk0dQs7OpK5FhB2xBF?=
 =?iso-8859-1?Q?pQLcuq69vcrXKFtWkiTlABbvjCVBtGQwWj4IiFMy+GeFF842itz49PIbet?=
 =?iso-8859-1?Q?i4wXylLiok3Qkr8uzl2/QqrgkcSUunNx3iB+lGb6nKq/XngS/XhhXumS1q?=
 =?iso-8859-1?Q?n8IRrTZEwJZMS8o6171oJ5asZB2DbGeU5G00JF4+0Luj+ffMBPHUM8Abdz?=
 =?iso-8859-1?Q?57C0S/QBFIAYlPPreylELfcFoI32+9/J1l++2RUm3+KbNa2rVjDyERK8cj?=
 =?iso-8859-1?Q?ojZmpcwfwu9N8KXj9XCpJVfdjw/6WkKZb1pZFin+gb8jmN5Z7d8mlzycho?=
 =?iso-8859-1?Q?a0ZKehrKMkUvWsj/O+BnORvzhGJB6+UCqfNqTGifKBRgemmplY0h413Dgb?=
 =?iso-8859-1?Q?T+Z8f8i0PGt5tIUj5k6XCBkjXp6C/iueerOAI0hjCc/7FK6qviGF9vQtP5?=
 =?iso-8859-1?Q?S6YLTAcTqIqK4DHgMIdGMNU7HBIDU/j9QjBa5odVc5qQbxHPRTNHL80Zjv?=
 =?iso-8859-1?Q?/i62iGjoIqwTU5MeGtgfCO8m/DQvUT0yRQEn5Nhndh6o9ksbC0ctlU4YMH?=
 =?iso-8859-1?Q?Xk/vdKQhOynVTznNppeCIBQGdDbxpGF3pnFRHcMAjmNQAe6PauQPoWUqhc?=
 =?iso-8859-1?Q?DdA42BcDYMeShnWKGooRE25km8yXmp8ktiYtFnw4HoOV3KDEeCYrzaDAsO?=
 =?iso-8859-1?Q?eN8Qrrn3Uyfwgvf+GPzb/96SvI5fQQcRYorniw8yMivKdJ2NZgLF+0aeGZ?=
 =?iso-8859-1?Q?KhJqUJJVEzuUZPU4Lu7U74JkDOGihJHOQpdTopt8Y+RSttpMz67y6DlRXO?=
 =?iso-8859-1?Q?PnTtj+bFbtqBjWBFFbO5ExTr7EEw9qkz194gYNY2GtMZt8GA56DIDWEQ3Z?=
 =?iso-8859-1?Q?1PYH98Mqgdik7UpFcReyISAhQd+D98kCgSH4jnBT3zEcei2pD9iE7v+iTd?=
 =?iso-8859-1?Q?XoNbz6138ln3jMD+9PpF2jV4dsyCJSwQa7SOjTvfTE8So3TSd/XaW19Z5V?=
 =?iso-8859-1?Q?8v9vW7MiZGiezUhcQ6XljW3lyGIXqadOInx5I9j2b8ZGMylEec2H8CDK/c?=
 =?iso-8859-1?Q?nyFjcKm3zDbniWSvcK9+Clbs5dpX+kL2f3kaQNOQjMcimeVwuHlp8p2Ggg?=
 =?iso-8859-1?Q?rCltu8P0Qe3ODw0YHhgryK3nYGHIMxIEIdL9hr/XuHrlCtdB63RibUn0Fw?=
 =?iso-8859-1?Q?8JcAh+Vw+HPow=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(35042699022)(14060799003)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:42.3246
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 23fff8ca-62d6-4661-087f-08de39926f0d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF00008859.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8928

This change introduces GICv5 load/put. Additionally, it plumbs in
save/restore for:

* PPIs (ICH_PPI_x_EL2 regs)
* ICH_VMCR_EL2
* ICH_APR_EL2
* ICC_ICSR_EL1

A GICv5-specific enable bit is added to struct vgic_vmcr as this
differs from previous GICs. On GICv5-native systems, the VMCR only
contains the enable bit (driven by the guest via ICC_CR0_EL1.EN) and
the priority mask (PCR).

A struct gicv5_vpe is also introduced. This currently only contains a
single field - bool resident - which is used to track if a VPE is
currently running or not, and is used to avoid a case of double load
or double put on the WFI path for a vCPU. This struct will be extended
as additional GICv5 support is merged, specifically for VPE doorbells.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c   | 10 ++++
 arch/arm64/kvm/vgic/vgic-mmio.c    | 28 +++++++----
 arch/arm64/kvm/vgic/vgic-v5.c      | 77 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c         | 32 ++++++++-----
 arch/arm64/kvm/vgic/vgic.h         |  7 +++
 include/kvm/arm_vgic.h             |  2 +
 include/linux/irqchip/arm-gic-v5.h |  9 ++++
 7 files changed, 146 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/swi=
tch.c
index c23e22ffac080..e25f1f000536b 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -113,6 +113,11 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 /* Save VGICv3 state on non-VHE systems */
 static void __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 {
+	if (kern_hyp_va(vcpu->kvm)->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_=
VGIC_V5) {
+		__vgic_v5_save_icsr(&vcpu->arch.vgic_cpu.vgic_v5);
+		__vgic_v5_save_ppi_state(&vcpu->arch.vgic_cpu.vgic_v5);
+	}
+
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
 		__vgic_v3_save_state(&vcpu->arch.vgic_cpu.vgic_v3);
 		__vgic_v3_deactivate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
@@ -122,6 +127,11 @@ static void __hyp_vgic_save_state(struct kvm_vcpu *vcp=
u)
 /* Restore VGICv3 state on non-VHE systems */
 static void __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 {
+	if (kern_hyp_va(vcpu->kvm)->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_=
VGIC_V5) {
+		__vgic_v5_restore_icsr(&vcpu->arch.vgic_cpu.vgic_v5);
+		__vgic_v5_restore_ppi_state(&vcpu->arch.vgic_cpu.vgic_v5);
+	}
+
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
 		__vgic_v3_activate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
 		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmi=
o.c
index a573b1f0c6cbe..675c2844f5e5c 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -842,18 +842,30 @@ vgic_find_mmio_region(const struct vgic_register_regi=
on *regions,
=20
 void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
 {
-	if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
-		vgic_v2_set_vmcr(vcpu, vmcr);
-	else
-		vgic_v3_set_vmcr(vcpu, vmcr);
+	const struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
+
+	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5) {
+		vgic_v5_set_vmcr(vcpu, vmcr);
+	} else {
+		if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
+			vgic_v2_set_vmcr(vcpu, vmcr);
+		else
+			vgic_v3_set_vmcr(vcpu, vmcr);
+	}
 }
=20
 void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
 {
-	if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
-		vgic_v2_get_vmcr(vcpu, vmcr);
-	else
-		vgic_v3_get_vmcr(vcpu, vmcr);
+	const struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
+
+	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5) {
+		vgic_v5_get_vmcr(vcpu, vmcr);
+	} else {
+		if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
+			vgic_v2_get_vmcr(vcpu, vmcr);
+		else
+			vgic_v3_get_vmcr(vcpu, vmcr);
+	}
 }
=20
 /*
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 2d3811f4e1174..2fb2db23ed39a 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1,4 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 Arm Ltd.
+ */
=20
 #include <kvm/arm_vgic.h>
 #include <linux/irqchip/arm-vgic-info.h>
@@ -50,3 +53,77 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
=20
 	return 0;
 }
+
+void vgic_v5_load(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/*
+	 * On the WFI path, vgic_load is called a second time. The first is when
+	 * scheduling in the vcpu thread again, and the second is when leaving
+	 * WFI. Skip the second instance as it serves no purpose and just
+	 * restores the same state again.
+	 */
+	if (READ_ONCE(cpu_if->gicv5_vpe.resident))
+		return;
+
+	kvm_call_hyp(__vgic_v5_restore_vmcr_aprs, cpu_if);
+
+	WRITE_ONCE(cpu_if->gicv5_vpe.resident, true);
+}
+
+void vgic_v5_put(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/*
+	 * Do nothing if we're not resident. This can happen in the WFI path
+	 * where we do a vgic_put in the WFI path and again later when
+	 * descheduling the thread. We risk losing VMCR state if we sync it
+	 * twice, so instead return early in this case.
+	 */
+	if (!READ_ONCE(cpu_if->gicv5_vpe.resident))
+		return;
+
+	kvm_call_hyp(__vgic_v5_save_vmcr_aprs, cpu_if);
+
+	WRITE_ONCE(cpu_if->gicv5_vpe.resident, false);
+}
+
+void vgic_v5_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u64 vmcr =3D cpu_if->vgic_vmcr;
+
+	vmcrp->en =3D FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_EN, vmcr);
+	vmcrp->pmr =3D FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_VPMR, vmcr);
+}
+
+void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u64 vmcr;
+
+	vmcr =3D FIELD_PREP(FEAT_GCIE_ICH_VMCR_EL2_VPMR, vmcrp->pmr) |
+	       FIELD_PREP(FEAT_GCIE_ICH_VMCR_EL2_EN, vmcrp->en);
+
+	cpu_if->vgic_vmcr =3D vmcr;
+}
+
+void vgic_v5_restore_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	__vgic_v5_restore_icsr(cpu_if);
+	kvm_call_hyp(__vgic_v5_restore_ppi_state, cpu_if);
+	dsb(sy);
+}
+
+void vgic_v5_save_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	__vgic_v5_save_icsr(cpu_if);
+	kvm_call_hyp(__vgic_v5_save_ppi_state, cpu_if);
+	dsb(sy);
+}
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 2c0e8803342e2..1005ff5f36235 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -996,7 +996,9 @@ static inline bool can_access_vgic_from_kernel(void)
=20
 static inline void vgic_save_state(struct kvm_vcpu *vcpu)
 {
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (vgic_is_v5(vcpu->kvm))
+		vgic_v5_save_state(vcpu);
+	else if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_save_state(vcpu);
 	else
 		__vgic_v3_save_state(&vcpu->arch.vgic_cpu.vgic_v3);
@@ -1005,14 +1007,16 @@ static inline void vgic_save_state(struct kvm_vcpu =
*vcpu)
 /* Sync back the hardware VGIC state into our emulation after a guest's ru=
n. */
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
-	/* If nesting, emulate the HW effect from L0 to L1 */
-	if (vgic_state_is_nested(vcpu)) {
-		vgic_v3_sync_nested(vcpu);
-		return;
-	}
+	if (!vgic_is_v5(vcpu->kvm)) {
+		/* If nesting, emulate the HW effect from L0 to L1 */
+		if (vgic_state_is_nested(vcpu)) {
+			vgic_v3_sync_nested(vcpu);
+			return;
+		}
=20
-	if (vcpu_has_nv(vcpu))
-		vgic_v3_nested_update_mi(vcpu);
+		if (vcpu_has_nv(vcpu))
+			vgic_v3_nested_update_mi(vcpu);
+	}
=20
 	if (can_access_vgic_from_kernel())
 		vgic_save_state(vcpu);
@@ -1034,7 +1038,9 @@ void kvm_vgic_process_async_update(struct kvm_vcpu *v=
cpu)
=20
 static inline void vgic_restore_state(struct kvm_vcpu *vcpu)
 {
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (vgic_is_v5(vcpu->kvm))
+		vgic_v5_restore_state(vcpu);
+	else if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_restore_state(vcpu);
 	else
 		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
@@ -1094,7 +1100,9 @@ void kvm_vgic_load(struct kvm_vcpu *vcpu)
 		return;
 	}
=20
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (vgic_is_v5(vcpu->kvm))
+		vgic_v5_load(vcpu);
+	else if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_load(vcpu);
 	else
 		vgic_v3_load(vcpu);
@@ -1108,7 +1116,9 @@ void kvm_vgic_put(struct kvm_vcpu *vcpu)
 		return;
 	}
=20
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (vgic_is_v5(vcpu->kvm))
+		vgic_v5_put(vcpu);
+	else if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_put(vcpu);
 	else
 		vgic_v3_put(vcpu);
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index bf5bae023751b..6e1f386dffade 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -187,6 +187,7 @@ static inline u64 vgic_ich_hcr_trap_bits(void)
  * registers regardless of the hardware backed GIC used.
  */
 struct vgic_vmcr {
+	u32	en; /* GICv5-specific */
 	u32	grpen0;
 	u32	grpen1;
=20
@@ -362,6 +363,12 @@ void vgic_debug_init(struct kvm *kvm);
 void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
+void vgic_v5_load(struct kvm_vcpu *vcpu);
+void vgic_v5_put(struct kvm_vcpu *vcpu);
+void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_v5_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_v5_restore_state(struct kvm_vcpu *vcpu);
+void vgic_v5_save_state(struct kvm_vcpu *vcpu);
=20
 static inline int vgic_v3_max_apr_idx(struct kvm_vcpu *vcpu)
 {
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 525c8b83e83c9..45d83f45b065d 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -388,6 +388,8 @@ struct vgic_v5_cpu_if {
 	 * it is the hyp's responsibility to keep the state constistent.
 	 */
 	u64	vgic_icsr;
+
+	struct gicv5_vpe gicv5_vpe;
 };
=20
 struct vgic_cpu {
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 68ddcdb1cec5a..ff10d6c7be2ae 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -354,6 +354,15 @@ int gicv5_spi_irq_set_type(struct irq_data *d, unsigne=
d int type);
 int gicv5_irs_iste_alloc(u32 lpi);
 void gicv5_irs_syncr(void);
=20
+#ifdef CONFIG_KVM
+
+/* Embedded in kvm.arch */
+struct gicv5_vpe {
+	bool			resident;
+};
+
+#endif // CONFIG_KVM
+
 struct gicv5_its_devtab_cfg {
 	union {
 		struct {
--=20
2.34.1

