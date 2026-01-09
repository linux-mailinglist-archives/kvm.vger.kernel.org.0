Return-Path: <kvm+bounces-67592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 92B92D0B806
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:06:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0988F3024F5D
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:06:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7C5F365A19;
	Fri,  9 Jan 2026 17:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XEPOxUiI";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XEPOxUiI"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013003.outbound.protection.outlook.com [40.107.162.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD5B364E87
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.3
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978351; cv=fail; b=lzxmFbK/d3BQStcXkXvK4nqf2LOBUS8eUPXJoKuIzXIcLJ6FqffvALcEEpM/YMUdAkgMoPqOwuyT3Mpk/Ywel1X1UqS0I8RZfeOJ4df0ibumT8JDjvmWj1p644Ll4xqfqXe75eoYTxjf19r50OiKodIQ8l6EkEhjbO32s5QOqNQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978351; c=relaxed/simple;
	bh=+bwJPL9DpqrySKDRU/vj4lyYaPn3R9I/5fEm2/wS97k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CIYSNpOFCfNgQGSc5JtXixetoWEvY2Fq45iaTLTAYczq+iFFdqiunLrHXo2MfZpLJtyUbxg7Wr7aR7a2pHWW7VfbgUncm0ln2ZXJE3nnymwB9dtc0LEvs6W7oAeVvhIFJTvqyJgwqchKZRNuGi6diuEUpNy1TptOdJLMiTg31Us=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XEPOxUiI; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XEPOxUiI; arc=fail smtp.client-ip=40.107.162.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=gVhO4vF3r+F0ZYk+gPWZcqt44DbZYfKcZ2rns0LSADuGdTYAnBBt6qOjdLyX+GCCxBoLEKE3rpHaCp7qRyrnI+5AnlmD6PCShylGX8l2RAnIn4bYFbAbhm8E5FVWHCOlh9OcSLZsHwY8oICYPVm5k7t+SDazSsttmn57pG0ozSePZgWsoCsWasqBzJrplFGI+y8ZH+uMBDNgtYlfTEApSc3O5J+7D7BT747Thf1oBzduLP66ilOTRq6mQc5TPw1KeeG8YrcirQZZ3CJTdkcHDCdtWdo9/sti18RfUKDCE4bAAvqdLXdVTlKrqLCYzERL6F0/dSY/Tac+JbQOe2cVrQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2WymhPqtrVPJX+ax7Q/WFenbvAiAmkvqVDA2EUy04co=;
 b=UyYKrzb18Ej2KTPjpHGbPQ15/gH7Cqk5FvoARgWgir+un7g4Qwemhy2tIg2JV44iUmf6RjeyCuz29nIyGkX6r5nhXGdcRKFRTznWebCbI8VWUkn1DwEc+MxM+lqoDZlV30gEWANFWVm7/o8KeCqMtVKTj+rH6dmZt0B6+CtoDfWpj0VXUkftgHgj5U++7qo8v/aiuEJykubampxdL7yaTEzEp3iuIsDc33LDLPFBKLgGwukF7eqZqFs6RlWwlz9d0A3gNQtSjHyusR+6m1S6Zcm7pGiYs3wbRn2c/iWMeKsxp0Aul0kcYIPt5rNU5xIaEqYzvX6W9CN02ZhpRpQwhQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2WymhPqtrVPJX+ax7Q/WFenbvAiAmkvqVDA2EUy04co=;
 b=XEPOxUiI1+/aEI809De3VaTiSxqjFZNGdLLuM2yP7pgJDdQtdfdsF6kuieUnqZcySP6cTvsaO4BCNC8trTVkRjU2eBNbRVqJyTpaeM7kN4XpH4N9mOOmU7W7NOu+VoeMpgJN0npQGT1cRCDnDfzJT0v1AUEgWhDKsa6uYUACTuE=
Received: from PAZP264CA0177.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:236::24)
 by AS8PR08MB7909.eurprd08.prod.outlook.com (2603:10a6:20b:52a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:05:44 +0000
Received: from AM4PEPF00025F96.EURPRD83.prod.outlook.com
 (2603:10a6:102:236:cafe::80) by PAZP264CA0177.outlook.office365.com
 (2603:10a6:102:236::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.4 via Frontend Transport; Fri, 9
 Jan 2026 17:05:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F96.mail.protection.outlook.com (10.167.16.5) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.0 via
 Frontend Transport; Fri, 9 Jan 2026 17:05:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pLaMCgUvRxfBWdpqIPeSVTsgV4U6C0Y0ctj7xsRV8D7XeHqvJ06bIbMHZ36/86Wi1ml3th6uOu6CrxYL8mYUWF3JXwwG7KjNnFaUxqictk7kVOuR5XO4OrAWXxoBg580Z7FnsQrw4h4mmVQoLgf+/vnJbtUEpUwR84HccDfLiudctlEUWPxKeTCoYNuN6ZSTwBdYIpQkxUUxtwj0bJUeFpDru3j1O+kEcU1+knAutF1ehVADu/u9JCEpq186L3Di5mhotGZvqVphyZgVIrCD0+9CxW3Q8G08nlUtPibNEHpjuNK1MDUs91doiWbvmD6Bl9y0wqUFczT5HJLQauU7lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2WymhPqtrVPJX+ax7Q/WFenbvAiAmkvqVDA2EUy04co=;
 b=yKel9Wo80bHFfFW9jVM0IelZMuXoUujoJH0tZXybRtVfkcqkkcxbBqCBE9ywgNTWS7nBVA33njsqgEXlUvxYjr6wC3HLShR421VGOektf7u6UBUUeG/SMf5QFTVVajL1fiYFHavQ4lu0esYL+2SUFXLPiT9WGAkCm/4kSGHv3ikcEXHHyW3biFT3ktB9vFuqwKP4Ux36HbPujABFBMsdTZ+3fFGfHJRF/L7v4m1wFKzalvE9/5Uq5CSG3hOMSjLgk355LgbgqIjdSlWM+VLlIk8F2RtV/L77zvaLbFet3v7yQkswsUwvjlk1sp6DydSbUQQweEmCCeDajB1TAldPaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2WymhPqtrVPJX+ax7Q/WFenbvAiAmkvqVDA2EUy04co=;
 b=XEPOxUiI1+/aEI809De3VaTiSxqjFZNGdLLuM2yP7pgJDdQtdfdsF6kuieUnqZcySP6cTvsaO4BCNC8trTVkRjU2eBNbRVqJyTpaeM7kN4XpH4N9mOOmU7W7NOu+VoeMpgJN0npQGT1cRCDnDfzJT0v1AUEgWhDKsa6uYUACTuE=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS8PR08MB6216.eurprd08.prod.outlook.com (2603:10a6:20b:29c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:04:40 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:40 +0000
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
Subject: [PATCH v3 05/36] arm64/sysreg: Add GICR CDNMIA encoding
Thread-Topic: [PATCH v3 05/36] arm64/sysreg: Add GICR CDNMIA encoding
Thread-Index: AQHcgYoLhffKFDzpa0uv6c6so13Olg==
Date: Fri, 9 Jan 2026 17:04:40 +0000
Message-ID: <20260109170400.1585048-6-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS8PR08MB6216:EE_|AM4PEPF00025F96:EE_|AS8PR08MB7909:EE_
X-MS-Office365-Filtering-Correlation-Id: b48cf62d-0dce-4741-6854-08de4fa1533d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?bQPs2DhgJoUiaDwjj2x8O8bil4KYMttEts1/gfnfYt7D7OFbnklQdkCKPq?=
 =?iso-8859-1?Q?72NnYB1aPboW5TDj5l2uZgH1bqJC9afL/4Uz782inPnHhGctYzoav3Dh3o?=
 =?iso-8859-1?Q?WhEKi8QJKqRc+RmddWhjTfh542u1Z8sP7hAw+tP/N4c1Wc0Ta5mq354NQz?=
 =?iso-8859-1?Q?SZ97e2VWqdGfcxfin3NQZOP49SoiC1id+jA05ZaROiuTT5BTRz3rHfaJDp?=
 =?iso-8859-1?Q?uujnv+HCoPXt74bvPSew9qSalhx/4IW7ReK0BXo932R0ZOWziYOiMdx+8H?=
 =?iso-8859-1?Q?m0Gyk9cv3ShLFG9y+sS8KIhhw4hOBfvJiKd4yrwXKf/zyexWZf7zGXcPmr?=
 =?iso-8859-1?Q?z2eY/myc4cJ7GJGKB9z0/fzyk+ym7wplcEoX5GFzy8IVZjfP1pvAkJ6/4D?=
 =?iso-8859-1?Q?UtoRJAZpDJk8qD/dwQ1eCx5DQZsF94xXCAw3BCwc/fwlsnCox3gIW8PPTV?=
 =?iso-8859-1?Q?yH9ErAHy1yAKUyD6Yd9IZuY9DICYEAWWYyoOriUfQ4pxMS+cpGKLXh8qKA?=
 =?iso-8859-1?Q?AsFrUceod5RJBDGEIoQD6w4jwj2f1GPyePhtu9FI10vpjxAVeJDNb6XIht?=
 =?iso-8859-1?Q?UEmPIQ0lwCJ4XgEVGr99Sx0pxIcwfqahqTJiTV3kyX2vFcCPancGZ6DkLb?=
 =?iso-8859-1?Q?B/6ovBAlhtB4w9vUpO2ZRFjal/qjD6SUF9f4h84xUaZmwCvaU5OMC2rWXk?=
 =?iso-8859-1?Q?gsYDPbiJLB19nA1LozdgFFQ4RL0NHh9KOHPCq7Aos2QLH6+AdKg7CtVaec?=
 =?iso-8859-1?Q?b8B2iCuiOuK7BDgvBbPeabmUhSi+upWijmUO/8FHtEFcQ9j6v6Knh0pPnS?=
 =?iso-8859-1?Q?KbWF5kYHYj/Dszeow8LhlsiSIvwUokpo05zO/Gm/bKA29lQQWM/HlD/bPw?=
 =?iso-8859-1?Q?F58rNERt4HC8q6RyUOJPowZDSJyBA8gkl0huV8yw0PPp5leruVGLX4DGfx?=
 =?iso-8859-1?Q?z8Jfpgf25ScLDBNBWfWgIVu2iqeepseQufMb5udFvVdZa5J+RXCtbggKfy?=
 =?iso-8859-1?Q?30IKtBb+jy1iDuPq5N1s+n8uusXcFFob1h9XfGsfTi+Vr1MCgyNvcA2ZoP?=
 =?iso-8859-1?Q?ExU6FscSmyDN2j/cX78HaORVxIyUJcmV7Nnly+IFhRr5ozdlhKfKypHBU3?=
 =?iso-8859-1?Q?5pSr6BRIuhsgQiZF/+A7hMNu45b/qbGa0l58h0nlmqpxRIIyt+b3ntV1Qo?=
 =?iso-8859-1?Q?x5xyMrnWls+GpLU4NGuPLB3UCuxTJ54Jsaj3gsDbekfRfgjbPMXRGu349t?=
 =?iso-8859-1?Q?IpG5XTMuonf5ShsoU6TXo3iesOn5XScAhbsvvRjz6FOVEDmcO+qmJrC5hh?=
 =?iso-8859-1?Q?n0VyY7wOS1arR82EFdxcKRQObVJFIyAmHZIjEdzR+FcYXVMArhTf9ESh6p?=
 =?iso-8859-1?Q?h/7aXAXqcFEYzXfs/NbYk9vuJ1c1FrbOvLQOnIqewGi7PHtnFA3YEQyEcO?=
 =?iso-8859-1?Q?RwmUwAo9iUxvoUrf1gzp7Ish0EVfdvIe+crBPDtnEzG/X1wxzLZFmdj7fp?=
 =?iso-8859-1?Q?Kf9av4HLAYEa7CZrVJss0MqIvK+XNZIqlVsggB3+//ZC/vAsIhRmqlinwG?=
 =?iso-8859-1?Q?CoMOZbOOYzA0eWNYpI5AcvEzQocc?=
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
 AM4PEPF00025F96.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	419d6203-599a-4cb2-96ee-08de4fa12db1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|14060799003|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?GXhgf7vfVr3wGhLdab4xhB5uP3R3PteqrmgU57WXv/11NdqbXoJqR/OXVs?=
 =?iso-8859-1?Q?3FfG87I84MWVgmyIEPUsuL0//WtfcjLDNTafMke5y5eRUIBceu380qBfdq?=
 =?iso-8859-1?Q?Gt+7Rx4Skf3AH1SB4Y/bW627hFr4CoxA6v5dVez2rMRpMXTMfha8bYAxcb?=
 =?iso-8859-1?Q?52Xn3Z9T9nd9dKwoHdI0UdHvjyiQeZt9JH07Iz6UZCrdXSlEa96Zlzfrvk?=
 =?iso-8859-1?Q?04BDfTAQdJ2Phkys5gFmmhAazj2/X933qOOofxsJ6J+Q+vg832OPB9Gcvn?=
 =?iso-8859-1?Q?DzYN/iazEJRpTD3mn+teBsQwZItHP/6eKXDJlhRR9XiRwZZE17X5jMeQSH?=
 =?iso-8859-1?Q?SU/ncpz7khFiaL5lU2BABteEUmt+d1ZY1FvZE3m33TZVA3wLvqpqNgdPoO?=
 =?iso-8859-1?Q?beydNlN67AJ8hUIUwLf6m6bxFNcLZXooswRY8sRffucLdz/jfkjS8KjOcj?=
 =?iso-8859-1?Q?nnCEdZdcZ2wyKCs3vUcUqnMvIQMFont+V4ELgsPUT072paVFX3ymjpXvJq?=
 =?iso-8859-1?Q?fQnzPjpEBwawcHHc6L74lwF9sFRBVrZbm2eQ8IEfcRKpd6218pdYiW+YD6?=
 =?iso-8859-1?Q?NaQhAZcwgTS45bU0yms3g/FpSVLiSRMNqPHlKRVoCwPP7vkGCNRmqNqKQ8?=
 =?iso-8859-1?Q?wsgsCBo76xe1M3haBtel+nqEveq55RJG039U66ep3jxI2Usi3x4HVyysdI?=
 =?iso-8859-1?Q?qQrWCOnoAmS8aVboEVesSEmTs1yiLlvH3v2pHiFXGs1hJ1d/QSFMJ95RO7?=
 =?iso-8859-1?Q?UktM6qvj4wspDOkR6IQK4kuXvnSCW/8RLsu2SWGDZtXX6ubUtBQ3NmEm7n?=
 =?iso-8859-1?Q?gQrxgRqkJ2sXjFT1J8duQbStEYlHfCSgeGtiQ7JTjX+5SWqrutXn1MBu6C?=
 =?iso-8859-1?Q?kQxBUH+EkEW4iM6e234/K08XQxPaCL4RAgLhe8QPdCZoB15NAJw7iBpgfM?=
 =?iso-8859-1?Q?y/h424C2I0b33KDE4Q+Hg1Vg6PUWYIqYW62U/uoMix0eOoViVOv/Bi5JgY?=
 =?iso-8859-1?Q?5laAoRox1puXhXHgPdfU9fuO13rXIYT+NllXdTpzz8dGhwx3HLERnrn53F?=
 =?iso-8859-1?Q?WlJd7VoVH08kIT7yCruT6O+7NAYMUKgPX9s1L3mIAwq/yjP96kCBAO5QGZ?=
 =?iso-8859-1?Q?mEblh1dPdACIjlM0uh+w6j75WafmRKGJ3RLgKSzgiETEuh0aYKmIjgt6Zx?=
 =?iso-8859-1?Q?CEMDxfRerOV9wQflCp8NWCE5NBAWMGyHnCuMpwg15VYoHOqexuQNa/NrUQ?=
 =?iso-8859-1?Q?DVQPq68LHDb0zheJTdgq/e1Lx5qr8TD5kGEAd1MMkNNy53UqB9UgOpy8xg?=
 =?iso-8859-1?Q?a6p+2QXWIGPBPj3LYnXyFDuJUPzn8LxiQC1ow3o0KJ13grfl8HOE4fxMBG?=
 =?iso-8859-1?Q?sTDPtRGmhAtVjPlAmiIG3c6WV3igcF2ikzdQWn7ZkmrSoJnFzDlP6E2X+O?=
 =?iso-8859-1?Q?GnWU19v5mIRedHv+WzmkGPfwD9PUCDmb9kUUwlWT5nOp8U/ZSTBZHFgcBB?=
 =?iso-8859-1?Q?U9JoV8eYan0r9hy1+r937cpvK7TAmCwg90hlkAhcyeZ9KZGENKFwBbfThS?=
 =?iso-8859-1?Q?+wjLqG9btzSdtTdnRBNZQrD0+7EZIlJ9ILE3O+eta40dbEoiIgmBKGp4Cg?=
 =?iso-8859-1?Q?8mWWovZk6FqI4=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(14060799003)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:43.7142
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b48cf62d-0dce-4741-6854-08de4fa1533d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F96.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7909

The encoding for the GICR CDNMIA system instruction is thus far unused
(and shall remain unused for the time being). However, in order to
plumb the FGTs into KVM correctly, KVM needs to be made aware of the
encoding of this system instruction.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/sysreg.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysre=
g.h
index b3b8b8cd7bf1e..97797761a07bf 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1059,6 +1059,7 @@
 #define GICV5_OP_GIC_CDPRI		sys_insn(1, 0, 12, 1, 2)
 #define GICV5_OP_GIC_CDRCFG		sys_insn(1, 0, 12, 1, 5)
 #define GICV5_OP_GICR_CDIA		sys_insn(1, 0, 12, 3, 0)
+#define GICV5_OP_GICR_CDNMIA		sys_insn(1, 0, 12, 3, 1)
=20
 /* Definitions for GIC CDAFF */
 #define GICV5_GIC_CDAFF_IAFFID_MASK	GENMASK_ULL(47, 32)
@@ -1105,6 +1106,12 @@
 #define GICV5_GIC_CDIA_TYPE_MASK	GENMASK_ULL(31, 29)
 #define GICV5_GIC_CDIA_ID_MASK		GENMASK_ULL(23, 0)
=20
+/* Definitions for GICR CDNMIA */
+#define GICV5_GICR_CDNMIA_VALID_MASK	BIT_ULL(32)
+#define GICV5_GICR_CDNMIA_VALID(r)	FIELD_GET(GICV5_GICR_CDNMIA_VALID_MASK,=
 r)
+#define GICV5_GICR_CDNMIA_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GICR_CDNMIA_ID_MASK	GENMASK_ULL(23, 0)
+
 #define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
 #define gic_insn(v, insn)		write_sysreg_s(v, GICV5_OP_GIC_##insn)
=20
--=20
2.34.1

