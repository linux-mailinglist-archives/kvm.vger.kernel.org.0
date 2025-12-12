Return-Path: <kvm+bounces-65852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DBFBECB9192
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:24:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BBE3A3016261
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:24:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DCD4314D31;
	Fri, 12 Dec 2025 15:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XBsfNGV0";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XBsfNGV0"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013041.outbound.protection.outlook.com [52.101.72.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88322315D48
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.41
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553029; cv=fail; b=EwK5VA724DGmvPwEd5xCuDu1W0vplnVHQ62wuSCnyXM3smyuRhHduIlMads13tEbTf5ZKoxEgvnrq8olNifYbsdIs24QWQwOOR3U25yLOB3ul90i9uoRXG2+8oT87zW4ZejckG3uIRzwue5BQjthwLPSx4SZCwGvlAAf8GQEMw8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553029; c=relaxed/simple;
	bh=jCQZqLiY+3aMj4vgy1XHWFr2muuTjiSSAntyqkRcfpE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q6AIKmibgn9oKwz76G+x8ZRqJQj5k6fie1I2iXleBwjezf/W4a+uRcNaXFqD2T5shfV4Mmtd59zRdWXVnaeWXiYnEtd8jmT/8r3n79v65wzkEodFdsYYuUeKvQWNpFuLudWFfxnyQ7ijOZCODIanms3lUKzYzaqnhyqJsNcw3UY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XBsfNGV0; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XBsfNGV0; arc=fail smtp.client-ip=52.101.72.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=HyftqDix8CBET9QtrB888gqJln2B+kCs1mlTGIYMYqvWkl6B8UN8ZKPpfU5apEBPeyzFHUbeQZ3gJ5v7ZYruJSiIPGc6XFNBIvjq1TaV5by7K/ndO78NGyqwELyGsB4DR3SQ2BxQcU6WOjEV5Iij10MuR0wkyM1K1aEoizXVwU8gOTVGnsB9CEprRIGCSc6+knbvqusAiTD3upZD2OJCSL/OB2Ce9nfJBKigANFFSvSwT6pUBPcx1nV4VtF6FpTkrCgvioc+vie1zHEidvOCbvsdF9Ry4879/GoqGTTe6GuZzvco6HRzy7JuwIJ4IV+/zszpkLnn8A72VVImraFhOA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VkoDozlZ166jvQqCUBiCwmAcXDHVmuehEAfo0H4lOCU=;
 b=I/PykTdGTls7hSdWD6O1F3HHq12w6b1xTotPjY+kl4fj0lmJtEI+kjs8zhQcSHyJTna8KJE3+iOClGODIJU6DPwHNC9F3xftMi1bZ5g3S7hWQY1kJkoGr1qMy0jOD7m9pX/zatOV6K9rXDQJZDVvMKIdMs3oEb9JJQZ+FMjQ4Zs9cN+dRWllzYMhLHcAfIuvascrPuyTnWbZFwqhoTR7AY6ETVVmI5w3CTpr4P+VNghL5aVt8cGK9V5i1k1arR2pkSDzHd43mOUu/OacCfKwRg+7fIqTCEJZtXArBh5qPtwFYp9QfY10TZgkb3F1iFN3mRAQFO5GcxRJ0dMpnDBjGg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VkoDozlZ166jvQqCUBiCwmAcXDHVmuehEAfo0H4lOCU=;
 b=XBsfNGV0oA+zxotk/GLHFHw7pf7f0gt4cbRjQQJtRaY8YJ9fRvEnYTmkncWc5cAHw4bzhbXQ/1nfMKUEKVfSnPmFZBoPtfTfxPkwkjy7+Q6S9hdF1/txHZPNBN5aSGYVBKWQd5qH5rM9PTAsizKe3IRFbSzVRoJ4qNS6jVGScqw=
Received: from DB9PR06CA0021.eurprd06.prod.outlook.com (2603:10a6:10:1db::26)
 by AM0PR08MB5362.eurprd08.prod.outlook.com (2603:10a6:208:180::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.11; Fri, 12 Dec
 2025 15:23:42 +0000
Received: from DB1PEPF00039231.eurprd03.prod.outlook.com
 (2603:10a6:10:1db:cafe::65) by DB9PR06CA0021.outlook.office365.com
 (2603:10a6:10:1db::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.10 via Frontend Transport; Fri,
 12 Dec 2025 15:23:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00039231.mail.protection.outlook.com (10.167.8.104) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 12 Dec 2025 15:23:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lr6qmu7ROzAcLhJ5O3Oa1h6gOPjWqBNkmy2QCAtUrOy4YN8fLW14HYfPOs3K4H8BroJpxIPu4PuJtvf00F16/6NhQvSFuNKpgLZWp/R4OZ7i+QG6xSvhIWpaB6KgVyvg2q9a7BItlxRAIKSvIjMrb8gCcf1HtaiCkA6T7HGcOy0EdYgEkljT3AyDp57HpRcOVY8jLuELRBa81ADSANFIBoqXTqwn/o6A9eKjqVVxXV/1Pg65dIRm5UMNpm83HAXWnMoMoDNAV3QLKJS7yNxRk24o9iepn4BhyOK6HP0bps3GrRc/d2LkLiQGvM93cM16RpUfGlChjnUPNggMW6bVZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VkoDozlZ166jvQqCUBiCwmAcXDHVmuehEAfo0H4lOCU=;
 b=Ie8s7d2zhgbD5B6waWiGSrs/DbM6tByOGBAIiIJ5tpmzJTNYNy8wptoZY3A9N9kZLRq+5ZZ/P+QZ2vXQyE6eky3lGs38Pqka2SOfTpQlMwjpuqe0wQHOaMm12EJoIiCTuPirXwZ+1SJmdovjlHlcUwVd2K6AVGsH5R8mmE7mH9knLwZQtqC70oiwmkdIe/XgsvpxMD9TidYcrgn+svGaJoZe5cc2zVhp3mfF8Tpi8ZSlbAECDLDenSh7TZtTaka+Tb1hrpvT+J0nYjw0x6mfRUeEqJNvGmZT3UtZ6eAauymo0SIZV+WYYewYdIRhIBJ5oLEJTBAAuJYFk3YtS+ALDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VkoDozlZ166jvQqCUBiCwmAcXDHVmuehEAfo0H4lOCU=;
 b=XBsfNGV0oA+zxotk/GLHFHw7pf7f0gt4cbRjQQJtRaY8YJ9fRvEnYTmkncWc5cAHw4bzhbXQ/1nfMKUEKVfSnPmFZBoPtfTfxPkwkjy7+Q6S9hdF1/txHZPNBN5aSGYVBKWQd5qH5rM9PTAsizKe3IRFbSzVRoJ4qNS6jVGScqw=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PA6PR08MB10565.eurprd08.prod.outlook.com (2603:10a6:102:3ca::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 15:22:39 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:39 +0000
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
Subject: [PATCH 11/32] KVM: arm64: gic-v5: Trap and emulate ICH_PPI_HMRx_EL1
 accesses
Thread-Topic: [PATCH 11/32] KVM: arm64: gic-v5: Trap and emulate
 ICH_PPI_HMRx_EL1 accesses
Thread-Index: AQHca3sm8YhLTF3L20aOpfRBsh1L6Q==
Date: Fri, 12 Dec 2025 15:22:39 +0000
Message-ID: <20251212152215.675767-12-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|PA6PR08MB10565:EE_|DB1PEPF00039231:EE_|AM0PR08MB5362:EE_
X-MS-Office365-Filtering-Correlation-Id: eea9f1d5-ad3e-463e-1ab2-08de39926e96
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?Gzsn37C0CZZDv6a0Q5KRo4uSV2NCaorjcvtWvJOBV3NXV4UAt8LOMHqD70?=
 =?iso-8859-1?Q?f1KnACk5xzDNpTILbcDuBq+SKvMfukb/Ebihicj3BlbATbuY7A94jES/ma?=
 =?iso-8859-1?Q?aJGiUrpHEW0BoY+Nb8Whjzb9PXEN5Ta8l8FfJtdl1ksN/Ws1n1KI+J6qGX?=
 =?iso-8859-1?Q?zCBwlr80bGkSd4gsr371IFMhg5ENwixNOjnNuY9/eUaxqPadzyJZEOgpQy?=
 =?iso-8859-1?Q?0OMhIYtZj+vDcVHk0DRmLmlMN2OPpe6wxs4oDQjQXp4Ms+ntINOur7mtr+?=
 =?iso-8859-1?Q?zmy0nqyOyWFG+Kci5h5fomi+IUmjcARbrKIqEc6pkA2SYhsYsCIXyXCtl0?=
 =?iso-8859-1?Q?48rYIzmhhAxH5wlcTEOfX5H1jcBqIJURf+1yijUp0FVhruB2k3XfoRPS4G?=
 =?iso-8859-1?Q?QOehYwh7uMXDF7h+384DS1p5DyrzFwl2F47UK4OMMCKQETfBq0BFDFu7Rg?=
 =?iso-8859-1?Q?L3VSmja2tAK0vqum+GUAwneZrDXbfKo0AZt/u+2QL6E/FGpIVOjZzcORqJ?=
 =?iso-8859-1?Q?jGOj1AmhrI06Iw3rBoM2IzYGVm34qC/lKuczNCak6YoLsLKn0Al9YoH9mA?=
 =?iso-8859-1?Q?HIwaRxGjkEBfq7go8qF2PH2coD+fotVv4RYbLiKp2MPEugP3hRTPWO04qG?=
 =?iso-8859-1?Q?kK98xKbfZkxGkvnFpDQO9TYaXMf2sBzz/YeC7WwrZ6OXRb513/ZMH76ilR?=
 =?iso-8859-1?Q?cIL77M3ss4ZqqtyHzP6jPEKmshp86Rok+SUVwKe+T9auQFV6o/PTpE8EMR?=
 =?iso-8859-1?Q?BMjS3p4YQcFa7LIPc/nyiM4bhlbQ7gqcTKn3hK4HLyf4O++79JOMat9ZZO?=
 =?iso-8859-1?Q?aFm7vWHVHNur6eHo01x6LJRnnrQi2X7OatCMgDtsoET/+GnW+xB8CiW/uL?=
 =?iso-8859-1?Q?jgEP/pNkDixHS7p/KCDJlrq8/Tft8hpQeFrXZRJj/NrtKMTEio9wXS+t03?=
 =?iso-8859-1?Q?m/4U0WG+AsO2VzCkDMAzMdqiZV4TgXFbAUEsvmP3wTrariDr4E5YTZvY7X?=
 =?iso-8859-1?Q?cJAfoLTCWuT79LcmZZ/Q6GTCugIur7synWJ65FjaQTMjHfPKtxAmwdM1hO?=
 =?iso-8859-1?Q?+VLxLH1CSjKHBRatE2Y4HFLKteblDmCZAQPu89O7UpPv7ovLse5xELRnNO?=
 =?iso-8859-1?Q?vEba0UAEvvnvsmFP2bW0fGADROzLcfGB7edcqt/dJuFM95tPnqfpvB1p+g?=
 =?iso-8859-1?Q?IU//RHanNlRB7ZdvGygrLGfxZuhEnUJvmNDN1KkcXFRPRc3PLrKYKe0073?=
 =?iso-8859-1?Q?kl+E4PBLY+8XZAnXNGujCUH6DNCRf5pax8lylIkmev/ZrJWtga4cVzj/C9?=
 =?iso-8859-1?Q?3lfy/Jk6rDIz33StFybtOjBH5R63HXqjXAOKog94RkUpWCFP0h0d1BDYSs?=
 =?iso-8859-1?Q?DPnEVWa0wGmd1cbXLk5CVmG3f8IYwFqv3kReDdmtM/MOscyZstUxgfkVIK?=
 =?iso-8859-1?Q?258iQa91f/47rXVcUDyM+RiaGNGmd5ULW69PqWdYnjxD9uUH1jrMge5Y1o?=
 =?iso-8859-1?Q?eFaKl25yEKxopz6K4Hdocgen69Ye+JiopR5CWEisqzbZD5s+bZfFGtXUHa?=
 =?iso-8859-1?Q?GqnhgxMAF/qkC7gvH+sg2nfCwqWu?=
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
 DB1PEPF00039231.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c09e84a8-b9c7-4515-0d28-08de39924953
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|14060799003|36860700013|35042699022|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?p6rPVEzniLdOxrKRgRbDQRxqpd12JVB4Gs6Tpnv21/ZzDzKjDPixKB0Cce?=
 =?iso-8859-1?Q?NfMWB0NwBc79eWA+Ikccs2LkROHWSPdFskm7w6iVDHRjHJAYamuE0HH3aU?=
 =?iso-8859-1?Q?rRFyWLbtFno4ri4hypJoIyw8nSOl6Q9TF7c+8IjuU3DQfUqWU+Q9ZQCK6P?=
 =?iso-8859-1?Q?/TRVQLhexLA/u/KM78SkcFAzJ9SEHxx8yvaXLPVSTI3FmjLh8AZvHJxoUJ?=
 =?iso-8859-1?Q?EnH264kcCKz/I70VIzw0Ms4U+PJH4QMmLUMSzPBS36FYach69L/bvQiNgw?=
 =?iso-8859-1?Q?O3tBDcQM5GrM/cpE4LaZcDNtUz/YKht5Xrw2KzzhfoADoAo6JXTuV21ijD?=
 =?iso-8859-1?Q?4Vqz6/AeKUBpRZKdoX6pXRUVPqqE4zY389J4urv4ZGj1HGQAQlhXrQpz3c?=
 =?iso-8859-1?Q?LI6WN5ZtKkoDkH2sKt8YNQMwrEltJFLwjpIO7XxuZD5WoQ0YHbqPhcGR9R?=
 =?iso-8859-1?Q?m7NhIUKOke/JUEd73N3HbrTAJTj1Q9o1kEMk+SW6UCAZg+JgJx8KEsaetp?=
 =?iso-8859-1?Q?Pi3S0x+046SqNguEmPKvInN05sHeFDQMnxxwDjrGz+dYpOwCYT/qptuk1e?=
 =?iso-8859-1?Q?jJ64dSiDXUJbRkWam/yX4+Il2dubyr1m6XfxZRvrOWRdfGKPV3GsTv9zdm?=
 =?iso-8859-1?Q?CzYpydR+Vl6QejjfT2fBhK1VeHZp3gWEy7kKwwNryE3A8vOaU22LyBAWTz?=
 =?iso-8859-1?Q?+xLuUVGNgYwMHF3qch1YQwpswzClTg0ukjT4cxrM1n+hCS/yO9vyudLHSI?=
 =?iso-8859-1?Q?MDQQpvKqVT4Z+nCmncjPHmEgR4nQxOE4z2ufTFUWxXdr4pG2GV+/PqBoM/?=
 =?iso-8859-1?Q?+vGceEBG4UsutWpgy2+sgvCbmQuzS6dJRfa/2bDOrFeRa9o2MSsE0K0Kbs?=
 =?iso-8859-1?Q?FBK6wvhciU8U8zfNkLJReSgNeBJtxSJF3Y7PmBccMiavJDfUNMqCPH06B+?=
 =?iso-8859-1?Q?1LSb7v3KGasxNFLXoKJqnnrNUW2YavvKJz5hPR47kiytJ5p2eDkAiaLJJI?=
 =?iso-8859-1?Q?aGYvdztNpIT/yVHjKsiVKLvwmKXMo5POzk1AHJd5c5e1qfIcHcjvd5Jhck?=
 =?iso-8859-1?Q?PNq8FOBwZsgLkhIqudgm0ttY6LHSdx+BaBmKNZ1LgyD98OL9laMmxXomLP?=
 =?iso-8859-1?Q?UXfCv9zTk0lOUevbp9k+KaAf7CR0NvBg85FqQbOGdTR1EfqmGrCPEbK/fG?=
 =?iso-8859-1?Q?0bUwUs8lKPI8938nNB9DOwYwwfYdccMThO4w0cJ0x50EmkiDkFYIIZ7JUq?=
 =?iso-8859-1?Q?UMDkFmIigLUAUUnIFwPLCdarMZ9pIIMvtqgXcopKVUB/YJpt1b6AakaUi2?=
 =?iso-8859-1?Q?PNN4j287Os6kI5EYUFRMuCPRYx4F34gxEIgNbB95rlwRJnmiPrZbQLXuDv?=
 =?iso-8859-1?Q?LD05EJYqw1LzDRWMvqG1r+PYHd5cKtSPEXLHA82f+CjZT68vL1D8eK5co6?=
 =?iso-8859-1?Q?rueOec6iUDZaDfsrA08u+3Lx+s9VIXptwfABTHWgwV2fIgxECtvCqs/pld?=
 =?iso-8859-1?Q?YeK6niCcCc9Xrva+nSKKZZQ3eGzXkaeynCiuFme9rdSVyWX8klGQ9/mVvz?=
 =?iso-8859-1?Q?CSZGGNRPzIG6gQ2jiNFzSoJeQ5IGHwXLzewB1NZoBAyOZF+byOuIi0NagD?=
 =?iso-8859-1?Q?hZ5MRjTpN0DaE=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(14060799003)(36860700013)(35042699022)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:41.5536
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eea9f1d5-ad3e-463e-1ab2-08de39926e96
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00039231.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5362

The ICC_PPI_HMRx_EL1 register is used to determine which PPIs use
Level-sensitive semantics, and which use Edge. For a GICv5 guest, the
correct view of the virtual PPIs must be provided to the guest.

The GICv5 architecture doesn't provide an ICV_PPI_HMRx_EL1 or
ICH_PPI_HMRx_EL2 register, and therefore all guest accesses must be
trapped to avoid the guest directly accessing the host's
ICC_PPI_HMRx_EL1 state. This change hence configures the FGTs to
always trap and emulate guest accesses to the HMR running a
GICv5-based guest.

This change also introduces the struct vgic_v5_cpu_if, which includes
the vgic_hmr. This is not yet populated as it can only be correctly
populated at vcpu reset time. This will be introduced in a subsquent
change.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/config.c   |  6 +++++-
 arch/arm64/kvm/sys_regs.c | 26 ++++++++++++++++++++++++++
 include/kvm/arm_vgic.h    |  5 +++++
 3 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index cbdd8ac90f4d0..7683407ce052a 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1586,8 +1586,12 @@ static void __compute_ich_hfgrtr(struct kvm_vcpu *vc=
pu)
 {
 	__compute_fgt(vcpu, ICH_HFGRTR_EL2);
=20
-	/* ICC_IAFFIDR_EL1 *always* needs to be trapped when running a guest */
+	/*
+	 * ICC_IAFFIDR_EL1 and ICH_PPI_HMRx_EL1 *always* needs to be
+	 * trapped when running a guest.
+	 **/
 	*vcpu_fgt(vcpu, ICH_HFGRTR_EL2) &=3D ~ICH_HFGRTR_EL2_ICC_IAFFIDR_EL1;
+	*vcpu_fgt(vcpu, ICH_HFGRTR_EL2) &=3D ~ICH_HFGRTR_EL2_ICC_PPI_HMRn_EL1;
 }
=20
 void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 31c08fd591d08..a4ae034340040 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -699,6 +699,30 @@ static bool access_gicv5_iaffid(struct kvm_vcpu *vcpu,=
 struct sys_reg_params *p,
 	return true;
 }
=20
+static bool access_gicv5_ppi_hmr(struct kvm_vcpu *vcpu, struct sys_reg_par=
ams *p,
+				 const struct sys_reg_desc *r)
+{
+	if (!vgic_is_v5(vcpu->kvm))
+		return undef_access(vcpu, p, r);
+
+	if (p->is_write)
+		return ignore_write(vcpu, p);
+
+	/*
+	 * For GICv5 VMs, the IAFFID value is the same as the VPE ID. The VPE ID
+	 * is the same as the VCPU's ID.
+	 */
+
+	if (p->Op2 =3D=3D 0) {	/* ICC_PPI_HMR0_EL1 */
+		p->regval =3D vcpu->arch.vgic_cpu.vgic_v5.vgic_ppi_hmr[0];
+	} else {		/* ICC_PPI_HMR1_EL1 */
+		p->regval =3D vcpu->arch.vgic_cpu.vgic_v5.vgic_ppi_hmr[1];
+	}
+
+	return true;
+}
+
+
 static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
@@ -3429,6 +3453,8 @@ static const struct sys_reg_desc sys_reg_descs[] =3D =
{
 	{ SYS_DESC(SYS_ICC_AP1R1_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_AP1R2_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_AP1R3_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_PPI_HMR0_EL1), access_gicv5_ppi_hmr },
+	{ SYS_DESC(SYS_ICC_PPI_HMR1_EL1), access_gicv5_ppi_hmr },
 	{ SYS_DESC(SYS_ICC_IAFFIDR_EL1), access_gicv5_iaffid },
 	{ SYS_DESC(SYS_ICC_DIR_EL1), access_gic_dir },
 	{ SYS_DESC(SYS_ICC_RPR_EL1), undef_access },
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index be1f45a494f78..fbbaef4ad2114 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -358,11 +358,16 @@ struct vgic_v3_cpu_if {
 	unsigned int used_lrs;
 };
=20
+struct vgic_v5_cpu_if {
+	u64	vgic_ppi_hmr[2];
+};
+
 struct vgic_cpu {
 	/* CPU vif control registers for world switch */
 	union {
 		struct vgic_v2_cpu_if	vgic_v2;
 		struct vgic_v3_cpu_if	vgic_v3;
+		struct vgic_v5_cpu_if	vgic_v5;
 	};
=20
 	struct vgic_irq *private_irqs;
--=20
2.34.1

