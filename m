Return-Path: <kvm+bounces-67411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id EDC87D048E3
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 17:52:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CE34B30396F0
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 16:25:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4666727F171;
	Thu,  8 Jan 2026 16:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LwiezLOv";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LwiezLOv"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013001.outbound.protection.outlook.com [52.101.83.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58413288525
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 16:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.1
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767889503; cv=fail; b=gyd+fxzDS5dSo69IUDqQloSv/i4CTASo2/48ZPKP8qWOvT8i65m3dARJlN8HuFxiCQfU/YHtH7bUljE/FLS6Z8JdHbP/PsPPHJr4gdQR1sRtI+AF7w1XfLL/i9KysbCUyvWa8ji6meqz/FurOcjNuWOm8STL+cokhreyarBLLuk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767889503; c=relaxed/simple;
	bh=RnB1KPIkDAtfJADzekEY+nPqD6E20UsB/JKNJvpdyGc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dIzgjxQWtpz5RkifjiilgQSx8ztUjzGuhFRM3sTjAlu1mhMIEC4/MYIGN/6un6uro28J4h8eYk/aGW/d+w8KbaeMUQinMLHlChM0bBPRlAh1TZUKJZDQiC1WJYigjNuJ0WuI+3ML8uHJaQWEs6XUYTP6fqa9raKVNYXFqm9r5ko=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LwiezLOv; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LwiezLOv; arc=fail smtp.client-ip=52.101.83.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=KzhlTACpJ3zSkznNB0BANELe2urYC9CUnWkzGfh5W9/WdcbJ361P46Jwe6u0dGcd8yUg+u6L+1Cor/Zf2W3axbKlZ2igDgPND14Xe9D2ybrYwzbmQkhrWWy9QLIjR01V8YBWX3zhxie5fFT2wvTPOmM7a9mKYiy0PenFzCAL1ThFJO5XOP+cFSReMNCvYp22C7/ZLQPk86sW3XWE2ZotfFIwdvzDgWTABL62G8o78FJrwFUyGk2tbuOPbU61k0rJ2aDXxTXZZ4ngq/HnjszXG5FN66b0G9rHb4Mz5dBACOwVUWbV6KbjnyB97ECJz0vgWTFWzSm3Y80j4trMgp4X8Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RnB1KPIkDAtfJADzekEY+nPqD6E20UsB/JKNJvpdyGc=;
 b=eih8GQBc2tbLWejFNauDDIMQW0kJOFUVHMtyj99Ynh4V/EXX8BwRCrNnp18QIKdalCo9715xO+7+4WBYCR1fnpIQ8HBAe8Jlj9Wqcd9alvNtiXZkHmrKMV5z6XwmpW62zwZfvbV5UxNbm4Fh3zykA+ACrsXXpL5Bky30P1ADeuuGSsIvrhZ8NjWUJ2ZMk5HW91ssdNG/T9Bl58VQzq2UPCkfMBu5fyLHybcA9DvULLupFksu5MX0teN53GqELpwJVPZjLDxvDa65h/ziw+ZQaPP3wuF7uUo+yjCE+lZFwfuSnvBi4xnaDYRG4Ku35lfloLvAzgyHwNZkIcDPpvlDyw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RnB1KPIkDAtfJADzekEY+nPqD6E20UsB/JKNJvpdyGc=;
 b=LwiezLOvdQBnnZye7nm3N6GpNK5/LhkUIfUqLSFdjFM9PgOsoQFOme2C3wk5j7I/Ot3741EgTpNLBQg/GjkYQ7dixQnEU3V0jB7s8awM7C/SROjtLxu4LnS5YQeipx7QhsJv093AFKwjGwwEMzJWrrrLEGRGc3HIVSI7iuiWJfc=
Received: from DU2PR04CA0217.eurprd04.prod.outlook.com (2603:10a6:10:2b1::12)
 by DU0PR08MB7517.eurprd08.prod.outlook.com (2603:10a6:10:322::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 16:24:52 +0000
Received: from DU2PEPF00028CFF.eurprd03.prod.outlook.com
 (2603:10a6:10:2b1:cafe::8f) by DU2PR04CA0217.outlook.office365.com
 (2603:10a6:10:2b1::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.3 via Frontend Transport; Thu, 8
 Jan 2026 16:24:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028CFF.mail.protection.outlook.com (10.167.242.183) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Thu, 8 Jan 2026 16:24:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mixM6+DqyRfv5tg5xGOgO7xDBhLMZHlAfHOP7dElfMrS/39CheAoW5ISHDnO25HwKzkFH29Ub+sowCy7Rzq6c1tRyl/AE35cxkbUNTRPx38bJaCAqDKkXj7bntV17WJ9CI1/Amo4cQkxMgAd+A+ruguU5SH/xolT2BcxNBOGO8/KO/a6zuWG60e+9KIMgnRoRBc9q3kzC4zbOzyYcZXzaYnbyWphnKss3M8p3WMYrQFLSu+tBde4yPXoSUO1U04JveEu6Mxh4LUYx/nfAIQHwt48xh0xUmWxjanVTCeN/AdDGay2QCvbt8eK+vVO84aUiIPLAA5VQiQZm6Q6l+z5RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RnB1KPIkDAtfJADzekEY+nPqD6E20UsB/JKNJvpdyGc=;
 b=GfVuZdlAzEzdH2fh2fVaeKCOrtSrz61OUbFqNq7tHRXJybpmmKBdZXUX3wex9h4OFSXczVtyueI3HxEibmRp5GXsG7cHbAIO5kxCcrG7btISwBNivksN+ZjZdNauhBlrIIbESVuv5GP9Y8wtyGogyQd9YBMlHchLaubujYMv0KVKru+TN64rZniCX3twPVny4FChKp5rLwhfyf4VCZsXKa2wGYT1oP3ld0jx0EhyTYiE3pew8csmYrQh5bRrKSZvqTgz4tELe3djUjwQkEWBz4pf0yHE3gsPgWgCmvtK/6d8wRugLIgy1sOLQHOAhLxn31EVG8szvvNEhGHeMQyFBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RnB1KPIkDAtfJADzekEY+nPqD6E20UsB/JKNJvpdyGc=;
 b=LwiezLOvdQBnnZye7nm3N6GpNK5/LhkUIfUqLSFdjFM9PgOsoQFOme2C3wk5j7I/Ot3741EgTpNLBQg/GjkYQ7dixQnEU3V0jB7s8awM7C/SROjtLxu4LnS5YQeipx7QhsJv093AFKwjGwwEMzJWrrrLEGRGc3HIVSI7iuiWJfc=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by PAXPR08MB6637.eurprd08.prod.outlook.com (2603:10a6:102:153::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 16:23:50 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 16:23:48 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>, Suzuki
 Poulose <Suzuki.Poulose@arm.com>, nd <nd@arm.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH v2 19/36] KVM: arm64: gic-v5: Check for pending PPIs
Thread-Topic: [PATCH v2 19/36] KVM: arm64: gic-v5: Check for pending PPIs
Thread-Index: AQHccP+CYg5kbO2rxk6vK6+w3RGKYLVG6qYAgAGpr4A=
Date: Thu, 8 Jan 2026 16:23:48 +0000
Message-ID: <0f8b393f8c9e557ba081a75757f1140c0da75a76.camel@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	 <20251219155222.1383109-20-sascha.bischoff@arm.com>
	 <20260107150012.0000336b@huawei.com>
In-Reply-To: <20260107150012.0000336b@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|PAXPR08MB6637:EE_|DU2PEPF00028CFF:EE_|DU0PR08MB7517:EE_
X-MS-Office365-Filtering-Correlation-Id: 0549335f-b79f-4343-dfe7-08de4ed273b0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?Nmdzd2NvUWJYaCtIdXBpTlJzdllyUk1NcEdyRlFiTURZK3NTNHJNWjdrRm01?=
 =?utf-8?B?bHRQT3VmTzFtQ3RoV1d2T3pRM3dNRzhmZXhJTmRzM3FNRGROdERySUoza0xO?=
 =?utf-8?B?ZWQ4dnU4ZkZlTjduNkk5TmliU0x5TG84Ry9ZaDh6RzFnRXMyL01keU5FaDNz?=
 =?utf-8?B?OS9GeUErR1E5SnlQVDVaTXAzUXYwR0J3L0N2M2FiYXVYZGwyWjBoTVZEN053?=
 =?utf-8?B?MURwRUtTY2h6a3pJd1JJd2xKZ1ROSHZ2bUxyd04zUUROZFlzZk9mdUl5NHJ1?=
 =?utf-8?B?N2RaWHVlNVFDbGZEU0p1SW9vM0VIZVdCdzE1YkMwd3JaTXRUcjYxcjNsWW13?=
 =?utf-8?B?K25rcU5Cc2cyMVVIQ1FTMWtMYlZYWnRyeXBaTnJsYjJ3VTkwaHhIZDl3VCtl?=
 =?utf-8?B?ZVRDakp6MVROcXNUNkpOa2krak9Pb3NUTGJlcEFmdG1oWndyWFJmUzk4dDVX?=
 =?utf-8?B?WDFFMnV4UUs1RmNNNERVd1VEaTFyVlZXWjM2L1dETjQ2dFVpRkpkcUI5WWlC?=
 =?utf-8?B?NjVEVXRqREovME5kV0RsSnF6aEtocmNsS2FCU3VmZ0orSXRHREpoQmJXdVBx?=
 =?utf-8?B?OXhjVU9KV2xiM1FIbU5FeS85RTNXd1RLcFVPeVNWYjJoaHVUSnlCRE1XNHFF?=
 =?utf-8?B?UkhNZFdRV1UyOFh6WkFZR2Z6RjZQM3VuVmloc3h3SHlGSVV4WFZrUHRxUzFZ?=
 =?utf-8?B?UTBURnRUN2RuRTlvc0FWL3JBTVFsalNPVG9FYWowNGdVUVQwSVZFQWY0dGZS?=
 =?utf-8?B?dmFYOTR5RjZ5dVk5TXdaWmdiWDZMTHMrazFPVlNqWElKcHZxMlhJK2xqQ1c5?=
 =?utf-8?B?SEE2RTZTZWxZUHFucWgxcVRZNjVQeTRRRi94T01ORzJFL2dkR1BEcG5SRmpu?=
 =?utf-8?B?Y0lCZ2NoVzc4SlhKQnI1YStzV29GSXUvL1JZbzE4a3lpK1NGSXB4akJOaWQr?=
 =?utf-8?B?ZVl2QnVReTdpaE8zYUNMSklVUTBRR2NRS2Z3S1QwN2s0MGhYSVRRY0JIYkw2?=
 =?utf-8?B?QjBvSi82UWEySDk2YkpsZ3JxYzkrTytWQWJFYUd5S1kzbWcyc1V4a1hISkdr?=
 =?utf-8?B?QW91KzRkdmtvOWtzRVhwb3BEMThFMWprSlV6b0haMUdIWkZzeW5ic0JZRXJu?=
 =?utf-8?B?dXBKZ3BYWUhKbnpRNkhlNVhiWWswRGZ3aWxFaFlqWmFJSTUrZ0hkL28ra0xV?=
 =?utf-8?B?eTk5endxRTU0QzVvUjBnc1RCaVBiSWlQZGJaZjRQNXFldkEreFNibGJ1MHRh?=
 =?utf-8?B?VGdlblBhYWV5WTc3TG1UT3NpZjJKaU56Y1pFckUwcEZQSjFIZGNpbURiQlk4?=
 =?utf-8?B?bVB1UmtaNFRlNHRFMVFCZDhRNHJkbUhKQkJjRExJZEhEQ0pvZ1VkdzBtTVhZ?=
 =?utf-8?B?U1V4WmlXMUVHT09uOUpnOW9hRDBhaDlpV3BGOThzaE9hMHBCZzFCRktTeGRs?=
 =?utf-8?B?TE53L0RuUmJISnRmcFR2dDVsMUkzVnhIcGFVcnVNLzVWOC9tN2t3d0xGeWdJ?=
 =?utf-8?B?SG8zYThjMkZrV1Bvc21mbURld0pBMEZNb2l0a0FHT2FkaldYemNLTFlUMkl1?=
 =?utf-8?B?a20xTDRjV0tqWmZDdE5sV2s5TjNOcFZRTk9lZGcvREs0Vi9jOUE4SHpNWERH?=
 =?utf-8?B?STBpUmRTTi9rNVRNTWt4K1hJUXdVb3JKNU5pRUw2aEt3c0wwYXptcjIyRnJu?=
 =?utf-8?B?MHRoL0o0b3RBemR6bm9mZEUxOXdSaS9ad05IUzBqRzhEc2tHU1RhRjZGUUxj?=
 =?utf-8?B?K2lVVkxhUHRWNWY4amZ6bWVxTmpQR1RjRWI2bkxWT0Rad2trTDFpZTFSOXRK?=
 =?utf-8?B?QjUvQVgwN0xPbGM0NExwV3ZxK1RNWStGK1ZEZFUydjFlRFU0WEcrejlxclNZ?=
 =?utf-8?B?N0E1c1VMcmIxQU4vNFBsNGZ2b1BXb1pNaW1udGY3MkNHQW1NbnowU1ZFcjkv?=
 =?utf-8?B?YnFkaEVwK0hsUE5adVRMR3JGUFVoZnFsTG0rdk1XVXVxU3U5RldMT1JMd0tE?=
 =?utf-8?B?UGNUTVBFeUhrMmJydHlOZE8rbjNiVTJKN1RjUEFQVDM0VWdMNkVVblpraVli?=
 =?utf-8?Q?qgUI3L?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <9073EADF90BA29499A7A82250805760F@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6637
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028CFF.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2efdcadf-b3b4-4e7b-4732-08de4ed24dbe
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|1800799024|82310400026|36860700013|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dnp4OXFwWEdSUm9LeHYvaW55VmVIdnVHRC84TlRPN1FJVUNjcEcreTJqTmhy?=
 =?utf-8?B?T3NjeWp1bGRSZTgrTDRkNFowcS83S1JKdFJYbUUxK1VCZ2hXOHBKOFhybXlh?=
 =?utf-8?B?d0x0ZWlKVlMxQzRiZVU0N3RmT2pEcm54bU5kSlBRSTFPR2hIc3M4Um5yaDJW?=
 =?utf-8?B?M1hLUmUwWmkxOVJ3cnExQjVicG1lKzJRM3c2UXNUK1JTdWNIZXNRTUNhWmFT?=
 =?utf-8?B?TjByWGVLeDFWTEg2TnlqT0Q4L0c2REtndUNCS0NiWkNJNlhSbHYzN3Ardm5a?=
 =?utf-8?B?dVZVeUVTZmFUdWlOM05neXpkYVVSZGNzdDE5a0FVamgrVEhESnYwRk1RTGlQ?=
 =?utf-8?B?YWhaYnMrMkZyNTBrWGFEYk1wdytIdEZ2ZVE0TnhJUXBzTFpBRGJBVERldmRU?=
 =?utf-8?B?UGRPTUVCL3h0MXpmSEMzYVBuMlppL0N4a0ExOFE0SXlmQWVtRnZ6SFZ5REZQ?=
 =?utf-8?B?MU5rdkwyeWJMY21jMWxVdmVsSTllbGUxb1R3aTFOd1YwNEZjRkpwbTRFMUJC?=
 =?utf-8?B?QkQzOWxhTDduMy9HUE1McEF1MkdKcXp3ZVYzcmI4aDVuM1RpVEZkRTNVQ2NY?=
 =?utf-8?B?T3JqRWxrN3U2RCtFbjZDZlVRN1BQSnVmSWNvOUE1Y2RwZmtWeDNmQyt6WUg4?=
 =?utf-8?B?VWViTS9uYVU0cFdqc0dHclhEYmpGRmo0STdPZmhXWjFjT2hIVXl3TVV4RFhX?=
 =?utf-8?B?QWEvWVNKWEpuRGoxOVFZckd4aHlxcExTZTVXQnhiMlhoUDJaNVB6Q3QrbW1M?=
 =?utf-8?B?L3pyL3hNQkhxUE5HVnA3eEVDUXNZUXpjRC9DdS9YMFVTb3RCSmR4a0VtTjM3?=
 =?utf-8?B?eVhrT2tHYTdLaEt3amVsaDlrZzhzM2NWbGg0RWdTRFVTTmpqZTNBQnlmYzlp?=
 =?utf-8?B?SjJIbWxsR0w4ZWh6WkhSWGJQdk1zUUJ1VmtjS3lKQXJVWllHKzJBN3Z4REtC?=
 =?utf-8?B?dGdWNXdONU5QQ3UxV3BSUG0vN2hYS1Nxbno4QW4zV3pNU0pHVnBYSFFvaGpZ?=
 =?utf-8?B?WkxCSjZXV1UvSjc5RitKZ0YybHNFL0htNzF6b29DcFRZOHFoL2NQTFUvU01v?=
 =?utf-8?B?NitWVFZkSmIva2p6MitBNG5ERExFVnFjdWFBWnRwdnlQN1VoZ1BObk5MN0dp?=
 =?utf-8?B?dGRzaGlyUFdhZ1Z2WXowbWF3dkJrRDYxN0xJYTVBRDZsVUtDVEZNZHdoZkxB?=
 =?utf-8?B?OG50RWNMR0lGdmNEYTZTMHZaWXVCRmd0YXdTOENhb05yaTRWNEwxVGEyMlVW?=
 =?utf-8?B?Nm1uN1FxZGVRb1pGSG15YXhneUROSngzV0V5dlFCa3FOanB6RW0xSlpBaEVT?=
 =?utf-8?B?TmNPcHg5YUxMWTJJdlZKNjZvZzFucGhaUHBLbjVWcVRtUXZlRk1hTXhwRlQ1?=
 =?utf-8?B?RlpwcGg1L1VmT2h3eXZMS2hLMi9NQys4WEM4ZDJ5QnRuRExJK3Mwa0o1eWV5?=
 =?utf-8?B?c3hrbG93SzlFakQ1UngvUFdxS1FMWWFES0ZvUjEzckc5YzFWV3Ruems3NDN6?=
 =?utf-8?B?bzdiclhMaHFUdE45S2YrZEhwUDgzWVBlWDQyc3dobk1ZYXM4ZFExUy9ibEhM?=
 =?utf-8?B?UVJ5TUhYaHZhaUo5S1pnSzE4OEVnQmdQOXY5bkhNU3ZUd0svNkZHMEI3QVpq?=
 =?utf-8?B?OW44cUZOdXpsMlg0VjhQRUpjRDV3anltWk03cy85eUJXTExDdWVEbWFpRUJB?=
 =?utf-8?B?Mkc1Y1daQlV6aldhZS8xUXNOT3NzK1VTYTRpWXJJaU1xT1pLSXVENUM3cEJZ?=
 =?utf-8?B?RmpRUXV0ZnU1aFFybUVEazc5ejRnS0QvbDVqdExEWjdLQnhsdlBKKzh1eWxY?=
 =?utf-8?B?d09BNWNRT1VPeTNTMzl3MytXUDhNc1NBMDc0dmRWODdubk02YkRjeFNPUkZU?=
 =?utf-8?B?c0VSYlpWTldzRVp5MHpTaHdDYTQ4MCt6QXBDQ0dJSlF0WC9yR3RLKzZhUldO?=
 =?utf-8?B?T1VXZUkxK1RnUkhGc05xUzF6cU9HdDU5N0dIUU5WNU5sbXV1cFlHWTBBbElS?=
 =?utf-8?B?bTVGbEM4eWYzVUlqd3lZVzRlWWFqcUwzRi9kWk8rZUJybENCOUYwMGkrQWdI?=
 =?utf-8?B?THFXZytoeEpsK3JQMlZGZXJpQXFFaHRXQkp2bzhLWnRyUVJHSXcyN1U3d2tH?=
 =?utf-8?Q?PhYY=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(1800799024)(82310400026)(36860700013)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 16:24:52.3164
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0549335f-b79f-4343-dfe7-08de4ed273b0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028CFF.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7517

T24gV2VkLCAyMDI2LTAxLTA3IGF0IDE1OjAwICswMDAwLCBKb25hdGhhbiBDYW1lcm9uIHdyb3Rl
Og0KPiBPbiBGcmksIDE5IERlYyAyMDI1IDE1OjUyOjQyICswMDAwDQo+IFNhc2NoYSBCaXNjaG9m
ZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiANCj4gPiBUaGlzIGNoYW5nZSBh
bGxvd3MgS1ZNIHRvIGNoZWNrIGZvciBwZW5kaW5nIFBQSSBpbnRlcnJ1cHRzLiBUaGlzDQo+ID4g
aGFzDQo+ID4gdHdvIG1haW4gY29tcG9uZW50czoNCj4gPiANCj4gPiBGaXJzdCBvZiBhbGwsIHRo
ZSBlZmZlY3RpdmUgcHJpb3JpdHkgbWFzayBpcyBjYWxjdWxhdGVkLsKgIFRoaXMgaXMgYQ0KPiA+
IGNvbWJpbmF0aW9uIG9mIHRoZSBwcmlvcml0eSBtYXNrIGluIHRoZSBWUEVzIElDQ19QQ1JfRUwx
LlBSSU9SSVRZDQo+ID4gYW5kDQo+ID4gdGhlIGN1cnJlbnRseSBydW5uaW5nIHByaW9yaXR5IGFz
IGRldGVybWluZWQgZnJvbSB0aGUgVlBFJ3MNCj4gPiBJQ0hfQVBSX0VMMS4gSWYgYW4gaW50ZXJy
dXB0J3MgcHJpb2lyaXR5IGlzIGdyZWF0ZXIgdGhhbiBvciBlcXVhbA0KPiA+IHRvDQo+IA0KPiBw
cmlvcml0eQ0KPiANCj4gPiB0aGUgZWZmZWN0aXZlIHByaW9yaXR5IG1hc2ssIGl0IGNhbiBiZSBz
aWduYWxsZWQuIE90aGVyd2lzZSwgaXQNCj4gPiBjYW5ub3QuDQo+ID4gDQo+ID4gU2Vjb25kbHks
IGFueSBFbmFibGVkIGFuZCBQZW5kaW5nIFBQSXMgbXVzdCBiZSBjaGVja2VkIGFnYWluc3QgdGhp
cw0KPiA+IGNvbXBvdW5kIHByaW9yaXR5IG1hc2suIFRoZSByZXFpcmVzIHRoZSBQUEkgcHJpb3Jp
dGllcyB0byBieSBzeW5jZWQNCj4gPiBiYWNrIHRvIHRoZSBLVk0gc2hhZG93IHN0YXRlIC0gdGhp
cyBpcyBza2lwcGVkIGluIGdlbmVyYWwgb3BlcmF0aW9uDQo+ID4gYXMNCj4gPiBpdCBpc24ndCBy
ZXF1aXJlZCBhbmQgaXMgcmF0aGVyIGV4cGVuc2l2ZS4gSWYgYW55IEVuYWJsZWQgYW5kDQo+ID4g
UGVuZGluZw0KPiA+IFBQSXMgYXJlIG9mIHN1ZmZpY2llbnQgcHJpb3JpdHkgdG8gYmUgc2lnbmFs
bGVkLCB0aGVuIHRoZXJlIGFyZQ0KPiA+IHBlbmRpbmcgUFBJcy4gRWxzZSwgdGhlcmUgYXJlIG5v
dC7CoCBUaGlzIGVuc3VyZXMgdGhhdCBhIFZQRSBpcyBub3QNCj4gPiB3b2tlbiB3aGVuIGl0IGNh
bm5vdCBhY3R1YWxseSBwcm9jZXNzIHRoZSBwZW5kaW5nIGludGVycnVwdHMuDQo+ID4gDQo+ID4g
U2lnbmVkLW9mZi1ieTogU2FzY2hhIEJpc2Nob2ZmIDxzYXNjaGEuYmlzY2hvZmZAYXJtLmNvbT4N
Cj4gSGkgU2FzY2hhLA0KPiANCj4gT25lIHRoaW5nIEkgbm90aWNlIGluIGhlcmUgaXMgdGhlIHVz
ZSBvZiB1bnNpZ25lZCBsb25nIHZzIHU2NCBpcyBhDQo+IGJpdA0KPiBpbmNvbnNpc3RlbnQuwqAg
V2hlbiBpdCdzIGEgcmVnaXN0ZXIgb3Igc29tZXRoaW5nIHdlIGp1c3QgcmVhZCBmcm9tIGENCj4g
cmVnaXN0ZXINCj4gSSdkIGFsd2F5cyB1c2UgdTY0Lg0KDQpZZWFoLCBJJ2QgbGlrZSB0byBkbyB0
aGUgc2FtZS4gVGhlIGlzc3VlIGlzIHRoYXQgdGhlIGZvcl9lYWNoX3NldF9iaXQoKQ0KbG9vcCBj
b25zdHJ1Y3Qgb25seSB3b3JrcyB3aXRoIHVuc2lnbmVkIGxvbmcsIGFuZCBub3QgdTY0LiBJJ2xs
IHJld29yaw0KdGhlIGNvZGUgdG8gdXNlIHU2NCB3aGVyZXZlciBwb3NzaWJsZS4NCg0KPiANCj4g
QSBmZXcgb3RoZXIgdGhpbmdzIGlubGluZS4NCj4gPiAtLS0NCj4gPiDCoGFyY2gvYXJtNjQva3Zt
L3ZnaWMvdmdpYy12NS5jIHwgMTIxDQo+ID4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKw0KPiA+IMKgYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmPCoMKgwqAgfMKgwqAgNSArLQ0K
PiA+IMKgYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmjCoMKgwqAgfMKgwqAgMSArDQo+ID4gwqAz
IGZpbGVzIGNoYW5nZWQsIDEyNiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4gDQo+
ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gYi9hcmNo
L2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+IGluZGV4IGNiM2RkODcyZDE2YTYuLmM3ZWNj
NGY0MGIxZTUgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMN
Cj4gPiArKysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+IEBAIC01Niw2ICs1
NiwzMSBAQCBpbnQgdmdpY192NV9wcm9iZShjb25zdCBzdHJ1Y3QgZ2ljX2t2bV9pbmZvDQo+ID4g
KmluZm8pDQo+ID4gwqAJcmV0dXJuIDA7DQo+ID4gwqB9DQo+ID4gwqANCj4gPiArc3RhdGljIHUz
MiB2Z2ljX3Y1X2dldF9lZmZlY3RpdmVfcHJpb3JpdHlfbWFzayhzdHJ1Y3Qga3ZtX3ZjcHUNCj4g
PiAqdmNwdSkNCj4gPiArew0KPiA+ICsJc3RydWN0IHZnaWNfdjVfY3B1X2lmICpjcHVfaWYgPSAm
dmNwdS0NCj4gPiA+YXJjaC52Z2ljX2NwdS52Z2ljX3Y1Ow0KPiA+ICsJdTMyIGhpZ2hlc3RfYXAs
IHByaW9yaXR5X21hc2s7DQo+ID4gKw0KPiA+ICsJLyoNCj4gPiArCSAqIENvdW50aW5nIHRoZSBu
dW1iZXIgb2YgdHJhaWxpbmcgemVyb3MgZ2l2ZXMgdGhlIGN1cnJlbnQNCj4gPiArCSAqIGFjdGl2
ZSBwcmlvcml0eS4gRXhwbGljaXRseSB1c2UgdGhlIDMyLWJpdCB2ZXJzaW9uIGhlcmUNCj4gPiBh
cw0KPiANCj4gU2hvcnQgd3JhcC7CoCBJJ2xsIHN0b3AgY29tbWVudGluZyBvbiB0aGVzZSBhbmQg
YXNzdW1lIHlvdSdsbCBjaGVjaw0KPiB0aHJvdWdob3V0DQo+IChvciBpZ25vcmUgdGhyb3VnaG91
dCBpZiB5b3UgZGlzYWdyZWUgOykgRXZlcnlvbmUgc2hvdWxkIHVzZSBhbiBlbWFpbA0KPiBjbGll
bnQgd2l0aCBydWxlcnMhDQoNClllYWgsIEknbGwgYWRkcmVzcyB0aGVzZSB3aGVyZXZlciBJIHNw
b3QgdGhlbS4NCg0KPiANCj4gPiArCSAqIHdlIGhhdmUgMzIgcHJpb3JpdGllcy4gMHgyMCB0aGVu
IG1lYW5zIHRoYXQgdGhlcmUgYXJlDQo+ID4gbm8NCj4gPiArCSAqIGFjdGl2ZSBwcmlvcml0aWVz
Lg0KPiA+ICsJICovDQo+ID4gKwloaWdoZXN0X2FwID0gY3B1X2lmLT52Z2ljX2FwciA/IF9fYnVp
bHRpbl9jdHooY3B1X2lmLQ0KPiA+ID52Z2ljX2FwcikgOiAzMjsNCj4gDQo+IElmIHRoZSBjb21t
ZW50IGlzIGdvaW5nIHRvIHNheSAweDIwIG1lYW5zIG5vIGFjdGl2ZSwgdGhlbiB1c2UgaGV4IGlu
DQo+IHRoZSBjb2RlDQo+IGFzIHdlbGwuIE9yIGp1c3QgdXNlIDMyIGluIHRoZSBjb21tZW50Lg0K
DQpEb25lLg0KDQo+IA0KPiA+ICsNCj4gPiArCS8qDQo+ID4gKwkgKiBBbiBpbnRlcnJ1cHQgaXMg
b2Ygc3VmZmljaWVudCBwcmlvcml0eSBpZiBpdCBpcyBlcXVhbA0KPiA+IHRvIG9yDQo+ID4gKwkg
KiBncmVhdGVyIHRoYW4gdGhlIHByaW9yaXR5IG1hc2suIEFkZCAxIHRvIHRoZSBwcmlvcml0eQ0K
PiA+IG1hc2sNCj4gPiArCSAqIChpLmUuLCBsb3dlciBwcmlvcml0eSkgdG8gbWF0Y2ggdGhlIEFQ
UiBsb2dpYyBiZWZvcmUNCj4gPiB0YWtpbmcNCj4gPiArCSAqIHRoZSBtaW4uIFRoaXMgZ2l2ZXMg
dXMgdGhlIGxvd2VzdCBwcmlvcml0eSB0aGF0IGlzDQo+ID4gbWFza2VkLg0KPiA+ICsJICovDQo+
ID4gKwlwcmlvcml0eV9tYXNrID0gRklFTERfR0VUKEZFQVRfR0NJRV9JQ0hfVk1DUl9FTDJfVlBN
UiwNCj4gPiBjcHVfaWYtPnZnaWNfdm1jcik7DQo+ID4gKwlwcmlvcml0eV9tYXNrID0gbWluKGhp
Z2hlc3RfYXAsIHByaW9yaXR5X21hc2sgKyAxKTsNCj4gPiArDQo+ID4gKwlyZXR1cm4gcHJpb3Jp
dHlfbWFzazsNCj4gDQo+IFVubGVzcyB5b3UgYXJlIGdvaW5nIHRvIGRvIG1vcmUgd2l0aCB0aGF0
IGluIGxhdGVyIHBhdGNoZXMNCj4gCXJldHVybiBtaW4oaGlnaGVzdF9hcCwgcHJpb3JpdHlfbWFz
ayArIDEpOw0KPiBEb2Vzbid0IGxvc2UgYW55IHNpZ25pZmljYW50IHJlYWRhYmlsaXR5IHRvIG15
IGV5ZXMuDQoNCkFncmVlZCwgZG9uZS4NCg0KPiANCj4gPiArfQ0KPiA+ICsNCj4gPiDCoHN0YXRp
YyBib29sIHZnaWNfdjVfcHBpX3NldF9wZW5kaW5nX3N0YXRlKHN0cnVjdCBrdm1fdmNwdSAqdmNw
dSwNCj4gPiDCoAkJCQkJwqAgc3RydWN0IHZnaWNfaXJxICppcnEpDQo+ID4gwqB7DQo+ID4gQEAg
LTEzMSw2ICsxNTYsMTAyIEBAIHZvaWQgdmdpY192NV9zZXRfcHBpX29wcyhzdHJ1Y3QgdmdpY19p
cnENCj4gPiAqaXJxKQ0KPiA+IMKgCX0NCj4gPiDCoH0NCj4gPiDCoA0KPiA+ICsNCj4gPiArLyoN
Cj4gPiArICogU3luYyBiYWNrIHRoZSBQUEkgcHJpb3JpdGllcyB0byB0aGUgdmdpY19pcnEgc2hh
ZG93IHN0YXRlDQo+ID4gKyAqLw0KPiA+ICtzdGF0aWMgdm9pZCB2Z2ljX3Y1X3N5bmNfcHBpX3By
aW9yaXRpZXMoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3Qgdmdp
Y192NV9jcHVfaWYgKmNwdV9pZiA9ICZ2Y3B1LQ0KPiA+ID5hcmNoLnZnaWNfY3B1LnZnaWNfdjU7
DQo+ID4gKwlpbnQgaSwgcmVnOw0KPiA+ICsNCj4gPiArCS8qIFdlIGhhdmUgMTYgUFBJIFByaW9y
aXR5IHJlZ3MgKi8NCj4gPiArCWZvciAocmVnID0gMDsgcmVnIDwgMTY7IHJlZysrKSB7DQo+IA0K
PiBJJ2QgZHJhZyB0aGUgZGVjbGFyYXRpb24gaW4gYXMNCj4gCWZvciAoaW50IHJldCA9IDA7DQo+
IA0KDQpEb25lLg0KDQo+ID4gKwkJY29uc3QgdW5zaWduZWQgbG9uZyBwcmlvcml0eXIgPSBjcHVf
aWYtDQo+ID4gPnZnaWNfcHBpX3ByaW9yaXR5cltyZWddOw0KPiA+ICsNCj4gPiArCQlmb3IgKGkg
PSAwOyBpIDwgODsgKytpKSB7DQo+IHNpbWlsYXIgZm9yIGludCBpID0gMCBoZXJlDQo+IA0KPiBL
ZXJuZWwgc3R5bGUgaXMgZ2V0dGluZyBtb3JlIGFjY2VwdGluZyBvZiB0aGVzZSAnbW9kZXJuJyBz
dHlsZSB0aGluZ3MNCj4gOykNCj4gVXAgdG8geW91IHRob3VnaCBpZiB5b3UgcHJlZmVyIG9sZCBz
Y2hvb2wuDQo+IA0KPiA+ICsJCQlzdHJ1Y3QgdmdpY19pcnEgKmlycTsNCj4gPiArCQkJdTMyIGlu
dGlkOw0KPiA+ICsJCQl1OCBwcmlvcml0eTsNCj4gPiArDQo+ID4gKwkJCXByaW9yaXR5ID0gKHBy
aW9yaXR5ciA+PiAoaSAqIDgpKSAmIDB4MWY7DQo+IA0KPiBHRU5NQVNLKDQsIDApOyBtYXliZS7C
oCBJdCdzIHNob3J0IGVub3VnaCAoSSBjYW4gY291bnQgdG8gMSBmIGVhc2lseQ0KPiBlbm91Z2gh
KQ0KPiB0aGF0IEkgZG9uJ3QgcmVhbGx5IG1pbmQgd2hpY2ggc3R5bGUgeW91IHVzZSBmb3IgdGhp
cy4NCg0KRnJhbmtseSwgdGhhdCBtYWtlcyB0aGUgaW50ZW50IGNsZWFyZXIgdG8gbWUgc28gdGhh
dCdzIGJldHRlci4NCg0KPiANCj4gPiArDQo+ID4gKwkJCWludGlkID0gRklFTERfUFJFUChHSUNW
NV9IV0lSUV9UWVBFLA0KPiA+IEdJQ1Y1X0hXSVJRX1RZUEVfUFBJKTsNCj4gPiArCQkJaW50aWQg
fD0gRklFTERfUFJFUChHSUNWNV9IV0lSUV9JRCwgcmVnICoNCj4gPiA4ICsgaSk7DQo+ID4gKw0K
PiA+ICsJCQlpcnEgPSB2Z2ljX2dldF92Y3B1X2lycSh2Y3B1LCBpbnRpZCk7DQo+ID4gKw0KPiA+
ICsJCQlzY29wZWRfZ3VhcmQocmF3X3NwaW5sb2NrLCAmaXJxLT5pcnFfbG9jaykNCj4gPiArCQkJ
CWlycS0+cHJpb3JpdHkgPSBwcmlvcml0eTsNCj4gPiArDQo+ID4gKwkJCXZnaWNfcHV0X2lycSh2
Y3B1LT5rdm0sIGlycSk7DQo+ID4gKwkJfQ0KPiA+ICsJfQ0KPiA+ICt9DQo+ID4gKw0KPiA+ICti
b29sIHZnaWNfdjVfaGFzX3BlbmRpbmdfcHBpKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gPiAr
ew0KPiA+ICsJc3RydWN0IHZnaWNfdjVfY3B1X2lmICpjcHVfaWYgPSAmdmNwdS0NCj4gPiA+YXJj
aC52Z2ljX2NwdS52Z2ljX3Y1Ow0KPiA+ICsJaW50IGksIHJlZzsNCj4gPiArCXVuc2lnbmVkIGlu
dCBwcmlvcml0eV9tYXNrOw0KPiA+ICsNCj4gPiArCS8qIElmIG5vIHBlbmRpbmcgYml0cyBhcmUg
c2V0LCBleGl0IGVhcmx5ICovDQo+ID4gKwlpZiAobGlrZWx5KCFjcHVfaWYtPnZnaWNfcHBpX3Bl
bmRyWzBdICYmICFjcHVfaWYtDQo+ID4gPnZnaWNfcHBpX3BlbmRyWzFdKSkNCj4gDQo+IFRoYXQg
bGlrZWx5IHNlZW1zIGEgbGl0dGxlIGJpdCBkdWJpb3VzLiBJJ2QgYmUgdGVtcHRlZCB0byBub3Qg
bWFyaw0KPiB0aGlzDQo+IHVubGVzcyB5b3UgaGF2ZSBzdGF0cyBvbiBydW5uaW5nIHN5c3RlbXMg
d2hlcmUgdGhlIHByZWRpY3RvcnMgZ2V0IGl0DQo+IHdyb25nDQo+IGVub3VnaCB0aGF0IHRoZSBt
YXJrIGlzIHVzZWZ1bC4NCg0KT0ssIEkndmUgZHJvcHBlZCB0aGF0LiBTb21ldGhpbmcgdG8gcmV2
aXNpdCBvbmNlIHdlIGhhdmUgc29tZSBoYXJkd2FyZS4NCg0KPiANCj4gPiArCQlyZXR1cm4gZmFs
c2U7DQo+ID4gKw0KPiA+ICsJcHJpb3JpdHlfbWFzayA9IHZnaWNfdjVfZ2V0X2VmZmVjdGl2ZV9w
cmlvcml0eV9tYXNrKHZjcHUpOw0KPiA+ICsNCj4gPiArCS8qIElmIHRoZSBjb21iaW5lZCBwcmlv
cml0eSBtYXNrIGlzIDAsIG5vdGhpbmcgY2FuIGJlDQo+ID4gc2lnbmFsbGVkISAqLw0KPiA+ICsJ
aWYgKCFwcmlvcml0eV9tYXNrKQ0KPiA+ICsJCXJldHVybiBmYWxzZTsNCj4gPiArDQo+ID4gKwkv
KiBUaGUgc2hhZG93IHByaW9yaXR5IGlzIG9ubHkgdXBkYXRlZCBvbiBkZW1hbmQsIHN5bmMgaXQN
Cj4gPiBhY3Jvc3MgZmlyc3QgKi8NCj4gPiArCXZnaWNfdjVfc3luY19wcGlfcHJpb3JpdGllcyh2
Y3B1KTsNCj4gPiArDQo+ID4gKwlmb3IgKHJlZyA9IDA7IHJlZyA8IDI7IHJlZysrKSB7DQo+ID4g
KwkJdW5zaWduZWQgbG9uZyBwb3NzaWJsZV9iaXRzOw0KPiA+ICsJCWNvbnN0IHVuc2lnbmVkIGxv
bmcgZW5hYmxlciA9IGNwdV9pZi0NCj4gPiA+dmdpY19pY2hfcHBpX2VuYWJsZXJfZXhpdFtyZWdd
Ow0KPiBHaXZlbiBzdG9yYWdlIG9mIHZnaWNfaWNoX3BwaV9lbmFibGVyX2V4aXRbcmVnXSBpcyBh
IHU2NCBhbmQgeW91IGFyZQ0KPiBnb2luZyB0bw0KPiB1c2UgdGhhdCBsZW5ndGggZXhwbGljaXRs
eSAodGhlIDY0IGluIHRoZSBiaXRtYXAgd2FsayBiZWxvdykgSSdkIG1ha2UNCj4gdGhlc2UNCj4g
dTY0cy7CoCBJJ3ZlIG5vdCByZWFsbHkgYmVlbiBrZWVwaW5nIGFuIGV5ZSBvcGVuIGZvciB0aGlz
IGluIG90aGVyDQo+IHBhdGNoZXMsIHNvDQo+IG1heWJlIGxvb2sgZm9yIG90aGVyIGNhc2VzIHdo
ZXJlIGFuIGV4cGxpY2l0IGxlbmd0aCBpcyBjbGVhcmVyLg0KPiB1NjQgc2hvcnRlciBhcyB3ZWxs
IQ0KDQpZZWFoLCBJJ20gbWFraW5nIHN1cmUgdG8gdXNlIHU2NCB3aGVyZXZlciBwb3NzaWJsZSwg
d2l0aCBoZSBleGNlcHRpb24NCmJlaW5nIGZvciB0aGUgYml0LWJhc2VkIGxvb3BzLg0KDQo+IA0K
PiA+ICsJCWNvbnN0IHVuc2lnbmVkIGxvbmcgcGVuZHIgPSBjcHVfaWYtDQo+ID4gPnZnaWNfcHBp
X3BlbmRyX2V4aXRbcmVnXTsNCj4gPiArCQlib29sIGhhc19wZW5kaW5nID0gZmFsc2U7DQo+ID4g
Kw0KPiA+ICsJCS8qIENoZWNrIGFsbCBpbnRlcnJ1cHRzIHRoYXQgYXJlIGVuYWJsZWQgYW5kDQo+
ID4gcGVuZGluZyAqLw0KPiA+ICsJCXBvc3NpYmxlX2JpdHMgPSBlbmFibGVyICYgcGVuZHI7DQo+
ID4gKw0KPiA+ICsJCS8qDQo+ID4gKwkJICogT3B0aW1pc2F0aW9uOiBwZW5kaW5nIGFuZCBlbmFi
bGVkIHdpdGggbm8NCj4gPiBhY3RpdmUgcHJpb3JpdGllcw0KPiA+ICsJCSAqLw0KPiA+ICsJCWlm
IChwb3NzaWJsZV9iaXRzICYmIHByaW9yaXR5X21hc2sgPiAweDFmKQ0KPiANCj4gSSAndGhpbmsn
IHByaW9yaXR5X21hc2sgPiAweDFmIGlzIGFsd2F5cyAweDIwP8KgIEknZCBtYXRjaCB0aGF0DQo+
IGV4cGxpY2l0bHkgc28gdGhlDQo+IHJlbGF0aW9uc2hpcCB0byB0aGUgbWFnaWMgdmFsdWUgY29t
bWVudCBhYm92ZSBpcyBvYnZpb3VzDQoNClllYWgsIEkndmUganVzdCBjaGFuZ2VkIHRoYXQgdG8g
ZXhwbGljaXRseSBjaGVjayBmb3IgMzIgKG1hdGNoaW5nIHdoYXQNCkkgZGlkIGluIHRoZSBvdGhl
ciBwYXRjaCB0aGF0IGludHJvZHVjZXMgdGhlIGVmZmVjdGl2ZSBwcmlvcml0eQ0KY2FsY3VsYXRp
b24pLg0KDQpUaGFua3MsDQpTYXNjaGENCg0KPiANCj4gPiArCQkJcmV0dXJuIHRydWU7DQo+ID4g
Kw0KPiA+ICsJCWZvcl9lYWNoX3NldF9iaXQoaSwgJnBvc3NpYmxlX2JpdHMsIDY0KSB7DQo+ID4g
KwkJCXN0cnVjdCB2Z2ljX2lycSAqaXJxOw0KPiA+ICsJCQl1MzIgaW50aWQ7DQo+ID4gKw0KPiA+
ICsJCQlpbnRpZCA9IEZJRUxEX1BSRVAoR0lDVjVfSFdJUlFfVFlQRSwNCj4gPiBHSUNWNV9IV0lS
UV9UWVBFX1BQSSk7DQo+ID4gKwkJCWludGlkIHw9IEZJRUxEX1BSRVAoR0lDVjVfSFdJUlFfSUQs
IHJlZyAqDQo+ID4gNjQgKyBpKTsNCj4gPiArDQo+ID4gKwkJCWlycSA9IHZnaWNfZ2V0X3ZjcHVf
aXJxKHZjcHUsIGludGlkKTsNCj4gPiArDQo+ID4gKwkJCXNjb3BlZF9ndWFyZChyYXdfc3Bpbmxv
Y2ssICZpcnEtPmlycV9sb2NrKQ0KPiA+IHsNCj4gPiArCQkJCS8qDQo+ID4gKwkJCQkgKiBXZSBr
bm93IHRoYXQgdGhlIGludGVycnVwdCBpcw0KPiA+ICsJCQkJICogZW5hYmxlZCBhbmQgcGVuZGlu
Zywgc28gb25seQ0KPiA+IGNoZWNrDQo+ID4gKwkJCQkgKiB0aGUgcHJpb3JpdHkuDQo+ID4gKwkJ
CQkgKi8NCj4gPiArCQkJCWlmIChpcnEtPnByaW9yaXR5IDw9DQo+ID4gcHJpb3JpdHlfbWFzaykN
Cj4gPiArCQkJCQloYXNfcGVuZGluZyA9IHRydWU7DQo+ID4gKwkJCX0NCj4gPiArDQo+ID4gKwkJ
CXZnaWNfcHV0X2lycSh2Y3B1LT5rdm0sIGlycSk7DQo+ID4gKw0KPiA+ICsJCQlpZiAoaGFzX3Bl
bmRpbmcpDQo+ID4gKwkJCQlyZXR1cm4gdHJ1ZTsNCj4gPiArCQl9DQo+ID4gKwl9DQo+ID4gKw0K
PiA+ICsJcmV0dXJuIGZhbHNlOw0KPiA+ICt9DQo+ID4gKw0KPiA+IMKgLyoNCj4gPiDCoCAqIERl
dGVjdCBhbnkgUFBJcyBzdGF0ZSBjaGFuZ2VzLCBhbmQgcHJvcGFnYXRlIHRoZSBzdGF0ZSB3aXRo
DQo+ID4gS1ZNJ3MNCj4gPiDCoCAqIHNoYWRvdyBzdHJ1Y3R1cmVzLg0KPiA+IGRpZmYgLS1naXQg
YS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMuYw0KPiA+IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92
Z2ljLmMNCj4gPiBpbmRleCBjYjVkNDNiMzQ0NjJiLi5kZmVjNmVkNzkzNmVkIDEwMDY0NA0KPiA+
IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5jDQo+ID4gKysrIGIvYXJjaC9hcm02NC9r
dm0vdmdpYy92Z2ljLmMNCj4gPiBAQCAtMTE4MCw5ICsxMTgwLDEyIEBAIGludCBrdm1fdmdpY192
Y3B1X3BlbmRpbmdfaXJxKHN0cnVjdA0KPiA+IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+IMKgCXVuc2ln
bmVkIGxvbmcgZmxhZ3M7DQo+ID4gwqAJc3RydWN0IHZnaWNfdm1jciB2bWNyOw0KPiA+IMKgDQo+
ID4gLQlpZiAoIXZjcHUtPmt2bS0+YXJjaC52Z2ljLmVuYWJsZWQpDQo+ID4gKwlpZiAoIXZjcHUt
Pmt2bS0+YXJjaC52Z2ljLmVuYWJsZWQgJiYgIXZnaWNfaXNfdjUodmNwdS0NCj4gPiA+a3ZtKSkN
Cj4gPiDCoAkJcmV0dXJuIGZhbHNlOw0KPiA+IMKgDQo+ID4gKwlpZiAodmNwdS0+a3ZtLT5hcmNo
LnZnaWMudmdpY19tb2RlbCA9PQ0KPiA+IEtWTV9ERVZfVFlQRV9BUk1fVkdJQ19WNSkNCj4gPiAr
CQlyZXR1cm4gdmdpY192NV9oYXNfcGVuZGluZ19wcGkodmNwdSk7DQo+ID4gKw0KPiA+IMKgCWlm
ICh2Y3B1LT5hcmNoLnZnaWNfY3B1LnZnaWNfdjMuaXRzX3ZwZS5wZW5kaW5nX2xhc3QpDQo+ID4g
wqAJCXJldHVybiB0cnVlOw0KPiA+IMKgDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3Zt
L3ZnaWMvdmdpYy5oDQo+ID4gYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMuaA0KPiA+IGluZGV4
IDk3OGQ3Zjg0MjYzNjEuLjY1YzAzMWRhODNlNzggMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC9hcm02
NC9rdm0vdmdpYy92Z2ljLmgNCj4gPiArKysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMuaA0K
PiA+IEBAIC0zODgsNiArMzg4LDcgQEAgaW50IHZnaWNfdjVfcHJvYmUoY29uc3Qgc3RydWN0IGdp
Y19rdm1faW5mbw0KPiA+ICppbmZvKTsNCj4gPiDCoHZvaWQgdmdpY192NV9nZXRfaW1wbGVtZW50
ZWRfcHBpcyh2b2lkKTsNCj4gPiDCoHZvaWQgdmdpY192NV9zZXRfcHBpX29wcyhzdHJ1Y3Qgdmdp
Y19pcnEgKmlycSk7DQo+ID4gwqBpbnQgdmdpY192NV9zZXRfcHBpX2R2aShzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUsIHUzMiBpcnEsIGJvb2wgZHZpKTsNCj4gPiArYm9vbCB2Z2ljX3Y1X2hhc19wZW5k
aW5nX3BwaShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOw0KPiA+IMKgdm9pZCB2Z2ljX3Y1X2ZsdXNo
X3BwaV9zdGF0ZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOw0KPiA+IMKgdm9pZCB2Z2ljX3Y1X2Zv
bGRfcHBpX3N0YXRlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQo+ID4gwqB2b2lkIHZnaWNfdjVf
bG9hZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOw0KPiANCg0K

