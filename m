Return-Path: <kvm+bounces-65871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 83F93CB922E
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:29:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 520B930A2158
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:25:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33216317704;
	Fri, 12 Dec 2025 15:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Y/RHqIxo";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Y/RHqIxo"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012013.outbound.protection.outlook.com [52.101.66.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0A03242B4
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.13
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553044; cv=fail; b=DHmu/kufydPnIHD6ae07r09kvmKTBG5rBeygbibxahmnAZn62b8uLqKdfGFqDxR7t+KcAbwhkoMf+G+RZn5l8YPwwy6Eb4dWGMpib9t4EErsK3edOSwJjleseopNFOys6P1NtkGCYDFE2a1tDEx6FgJUB3F+NXSz9o5EAidhwhs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553044; c=relaxed/simple;
	bh=xBoq6SOxWaiffHPE/WY6w3zL6Cyp+0nng6I73DHskcY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gqGrxfVeOmXNbsxSDgU25kL5kaB6gSCFRS3RidzBvPgQkNlhWQmQwLf25x7ikuykeAtm7aFJFoQql4Avfrzv9/evUC36jHB391YlSZ9kUhhCO3wifLE1KTXJNFaqFoUD00DFxxhPMuIVIxFU9uLxI1hpNNqTFlLVJ7d97G6b4QM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Y/RHqIxo; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Y/RHqIxo; arc=fail smtp.client-ip=52.101.66.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=faPULzZBBneSfYc2C0bELM3K/uLQJ+WPA0Y50FIHyh6lSTtXn/zXNXjQ5LLO+Y/B8lZfESwzEW26V1LzpT40f6ul/uS1ekPu9tXDJHoysUvJp3gO6aHjT5bBY62bfe7qLmZPHSUQS3zN3AewDROs+fLX7NwEWMvanCqe50m2rWyxNtab/ho+acqR9BTxD+44TlmL/VKrpEcX3Bhl4B2AdZqCG7DSJgbGKTNZMIPcH6x6fDdFIlteAZ16LjsBQ8RbgFBqjG5bJ853pqNZOTX573xXdYjdkZwYalv1hkzhQLSVyOO7gVHTaDksdLbF+K5tm9X95DkYqeKssrPF9fMw/w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DD9lN89bkszR2YhYdJqxPkIRToBd3dUJhVRkq9M7zn8=;
 b=V+TJ1FM4IFcn201x4ee2kYOXBuRuy5frPS1qMVnSow2J0GGPsp+I8Yi/g/wqexJ2czTYIf6G1DE5edDEb/Vf6oq69AqSgLZIbMFQyaBF451VCkU6IJf9ur1V+jSRan3NibyT7azj8Q+PdtYKJRixpZ2nwTo+/E565PubvhGi+7wEVMsk1Y77/+3V755olNAHD5RkNPqOfsv+rVXaZyO4FvBa0EEVDfwePuByVmCk7X+3oCF+SAD8junHp/4uys5wzp6UqvgLIkcOYUwHqKXRpXDqVzbPy9Z51F/WeSmGWQwXjvMnp2lmZYOT5gk5OjN8+klZghL1e4UcEcIQVfmM3Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DD9lN89bkszR2YhYdJqxPkIRToBd3dUJhVRkq9M7zn8=;
 b=Y/RHqIxoVDkBikXX8yd9yXnV5XWrb8KkQ9eieFqiD4Gd9nsSQrfwHPSSpWKqIrDomMufA8YiNmyNAO3wWTkuNzQ/pbLd0OoTziF2AOjoFWrc+Q4euseYxhb+/0fzwn3kBIyt9Vlon8hs68bPkkHOudbij5wlVobszQf1/T7RJgs=
Received: from AS4P251CA0018.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:5d3::10)
 by AS8PR08MB6503.eurprd08.prod.outlook.com (2603:10a6:20b:33b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Fri, 12 Dec
 2025 15:23:49 +0000
Received: from AMS1EPF0000004A.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d3:cafe::42) by AS4P251CA0018.outlook.office365.com
 (2603:10a6:20b:5d3::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.11 via Frontend Transport; Fri,
 12 Dec 2025 15:23:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000004A.mail.protection.outlook.com (10.167.16.134) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 12 Dec 2025 15:23:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bqj4gBlCPgj/EY2wakOoRm1KVUTXzIDlXlk9zyZvElOHDvmLqmrbGAC4ovKRCfgUWDLjcJSg01lGwha2KCzzhB0t1BGFXxyVnXZ14yBZYfUUED7TPr+DYbJ98SUn5nvttR01FHDUs0NTrupJ7z1l5TxhsTloogdcGUm+O+J9F3rGrW2kESP5m80KD54IofBDVA+O9tNeNM3FzXFRcJaq/cOrsUf+/ZC3D/JhTjUJECiMLkYMmR8nyqUyI+cm503+rvYfcdWa6ARXIyBV6a6+pg+jyDYY6yOIcmKFqEMwca9qCGwapHAo/pEHL11SMHIHlJ+PlgNkpzlvvw4BRRzDGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DD9lN89bkszR2YhYdJqxPkIRToBd3dUJhVRkq9M7zn8=;
 b=ync3wSvrk53mPCm+793JzHVsMXbl6lDi6Wemd3wHuIR4+mTx6LoMtTx9P5vArrtFLc/sKdch/sVhK6YTNuziVBtGLtwld9fwAC9XL0UQttgq+c+FI8a58AmAfWqsfA6EG1aa4cNk2TtLJLCvxytpms8E05PI0SRMsnzTJwiL0IVOCsmguvQzjZelVell15+ajE0VbkP7FeQGLDz4Rj3xwqLhY0NVavhgyueGwHghUJ2OOIiehxboac/B8knrknICtf9vhuNi6wCY9//hHBKWqgAryoNP2BJGiNQKQF1zwC1YKerbMWV9ROGGhjJy/FQxWCpB2/EXMv2ecUjSNDldEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DD9lN89bkszR2YhYdJqxPkIRToBd3dUJhVRkq9M7zn8=;
 b=Y/RHqIxoVDkBikXX8yd9yXnV5XWrb8KkQ9eieFqiD4Gd9nsSQrfwHPSSpWKqIrDomMufA8YiNmyNAO3wWTkuNzQ/pbLd0OoTziF2AOjoFWrc+Q4euseYxhb+/0fzwn3kBIyt9Vlon8hs68bPkkHOudbij5wlVobszQf1/T7RJgs=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PA6PR08MB10565.eurprd08.prod.outlook.com (2603:10a6:102:3ca::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 15:22:46 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:46 +0000
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
Subject: [PATCH 23/32] KVM: arm64: gic-v5: Bump arch timer for GICv5
Thread-Topic: [PATCH 23/32] KVM: arm64: gic-v5: Bump arch timer for GICv5
Thread-Index: AQHca3spYNl0WGlNZUmPJyki2EbHPA==
Date: Fri, 12 Dec 2025 15:22:43 +0000
Message-ID: <20251212152215.675767-24-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|PA6PR08MB10565:EE_|AMS1EPF0000004A:EE_|AS8PR08MB6503:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e618c1e-394b-41aa-7dd7-08de39927264
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?z1bUlvqRKuirVnvwnkBhPkr/QUpdjoilLub7YJQEXNKTXNiw1aVOCpNtvw?=
 =?iso-8859-1?Q?clByjiMsXzKmBFLxgojTq0p0CLyNhygsk9BtM/W0Dz8po5OHuLSSradHah?=
 =?iso-8859-1?Q?1zOOTMk4X741vTFPZWhn0gaZ+xcZMjpsC0B/x78mABX1b0tYW2QMEMj5+Z?=
 =?iso-8859-1?Q?0QrLBhEjILFidHideJ7cL37brpugZS4pR4Inr2bIeqRKnVCrZ4TYEWocnO?=
 =?iso-8859-1?Q?RTCWNngxKapFr7dHAxHtRYSpvJf5UywQICWXq7fIhUuaREYr3PlHHJqRjt?=
 =?iso-8859-1?Q?ZbN7ID4KD7vnRfjxqgCKBk1cJ6vpyk1NRUIGnBM5GL/h62GdXs/MHEOYlY?=
 =?iso-8859-1?Q?m8oFa9h3lTp+g2zzk+NuUTcDqAE/EezZ/B6U6s9dANABvCu9FX2ot1F2vq?=
 =?iso-8859-1?Q?dkden9Uj/qJ+EZKdxfwHwotzbd3RjHU9wTxufIVgzSXOo4VIUE4oH0X9Gw?=
 =?iso-8859-1?Q?PjU4iy0DKj+LyS/3k63XDTlBEenY0dAmODT+Gt3F1kVLrUHKV424PAHGXe?=
 =?iso-8859-1?Q?+CFW14+LqxQS1ACFOB9YbJOjASLmf2TMX6bX+jQowJu0+KpAdUolFfnalX?=
 =?iso-8859-1?Q?lDw2Pc9snVVKFt/aDw3eqrqPkVNa34MBilazYsqYEH7qmooUQzfNQTiA2O?=
 =?iso-8859-1?Q?dW/pnnFmaibZmWMhkoqozK+TGxyPnbOjGyaGK7P9m1tE/Avvy7GnoUSNYD?=
 =?iso-8859-1?Q?i3MjXpy7VdcA/krOGHG/V5IlfiInrkpXGHSxTk0HQMOkJ7EH+AINTafRK7?=
 =?iso-8859-1?Q?lccmpKcVemWFIHuj10Wtj8R4GXqPFaKpbxJ8lFopF51UPfrm2tYmkOamxD?=
 =?iso-8859-1?Q?/gHSxcg6VxyZYpUiZDoB4oYer/67fTYILpHBPDG+wsNB3PCDuYbSVLN74R?=
 =?iso-8859-1?Q?mwxOqG7M+tRtatmv1O7vmGuZv+nKPm+lcwCLdLTyLuviZlLiUVzOSF1GX+?=
 =?iso-8859-1?Q?GTVb24dG9pLt2tM1/6THEgcbTuXLbkur5PJ5bZxqRZEp0mLKG2zck8VbbA?=
 =?iso-8859-1?Q?x19Oihe9la7Crvsim+az0uEdBkcEbm68EvJppnxN0yPlhd9OCRjOr4W6hy?=
 =?iso-8859-1?Q?PQTCeY9DYsrdDiOKZy2+kb61DrRzXMlcw5L3IFyMGgG8go7Y8MXw06K1s2?=
 =?iso-8859-1?Q?9tfd2ddchKm2sEw8KP9/I/F1ovOjOecrxTYTBpq1ukPorYYlzGxXIfMybM?=
 =?iso-8859-1?Q?LLe+hgxxoj2lgpaTf++l7HRWaARFyZBmjVysm6RUBVkxPEi/qbFkZySnx/?=
 =?iso-8859-1?Q?nz9+gNttR9cjJ63CIngyzWwXgzDSiHIbARVbLh8CBfejehs86li512969k?=
 =?iso-8859-1?Q?43dqZH2RXA+FrY7k6w2jhlrNzbd4OWrA+iMg7eO2VjaYEZUyeZVUVxfA7c?=
 =?iso-8859-1?Q?wNvMZa5igq/FMwFdQEDhtEmZn2ZFkGd0N4eARPs2t8/EtRPgJMUkD9RZXm?=
 =?iso-8859-1?Q?7OGnlhCP9qFX72A2YdbHCKTNcZnwGOrMQ86oFKq0tnQDzlwf26w3Ju5XP4?=
 =?iso-8859-1?Q?RC1scAtAFt8hHzl7VeLpcAqOBe4SFoWJI9JKZWSu25dNha0ElmxmxiZT7f?=
 =?iso-8859-1?Q?FoY71cXfT+6t/9f1ueB5Qj0m6x/x?=
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
 AMS1EPF0000004A.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b93d0559-a7ab-418a-75dd-08de39924d62
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|35042699022|36860700013|82310400026|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?ovH8Lbr5mPGhi774/ZbV1gcfFUItcn5d1YlYl4nAJ4LNIEQjfLn553Ci7X?=
 =?iso-8859-1?Q?0omAotdv3rC57r8eTjhgRzagJlMm29QsP350xlX1l2OBYnR6jODNzVO/xZ?=
 =?iso-8859-1?Q?KklRXw03NNEjAOZAST1pRdp2fEGdGEVzCWsq6aZ9C7JFacNQyd6poUQDu5?=
 =?iso-8859-1?Q?37gSegCBTHXN+t/lNiyo8dFgNaDxNt/+3mjLXl2o0x9eFN/N9QO4WaNjdV?=
 =?iso-8859-1?Q?tEwE7+nrnTKf/LNBSpixwKl6fP5Vbm6bT7cWf/8i9LN2zC/C10jDk+w9Hb?=
 =?iso-8859-1?Q?eQ4bmlujnhwuRRhKI1VUBU3T3pEN2YdtICsZZ4ej2TyxLCGDCRjT+5akR1?=
 =?iso-8859-1?Q?ZY07f83cORgOzknG/RQo/1uApLQ0670NOU/CWvxb3y5wwg4BBamFmAyN4U?=
 =?iso-8859-1?Q?6wccBcgj9JMyS9tIyQmOJbbTICka5pgYNPcAP4tPlyRrLDcqnk1g1Q3mnU?=
 =?iso-8859-1?Q?gBHFuFKADibT1Up5Y8RggGHCUjN8kyz2fqyHns+SdI8V9mug05ouWSJWy7?=
 =?iso-8859-1?Q?sZzFDwbVjVCGZ2Hwz2pdPDNrI9urMm0k5CxKwWR8s5E95/IbfjfWpnTWf5?=
 =?iso-8859-1?Q?r0Y6BrY98aZXkqJ/xVBs333iROWoxd6zJeXg/2DWoJcSozy3NpwLqaf3OC?=
 =?iso-8859-1?Q?bL/EeoEGVCm34hyPoxZ/+zlUy7yzldJmF2K3yGDDF+b5fj5x+quDNiera2?=
 =?iso-8859-1?Q?RrNEZ9v8IF4+V3QtOBsA49YxYw5+E7P8QW0Gsn8nSjYgrgVVcZdaIO3nnU?=
 =?iso-8859-1?Q?p9GgF6g5G7yTyjlymstL88XwPDtuOobQT0E+bWCXuGtBwl0x53SkmzHgZI?=
 =?iso-8859-1?Q?unRClvJnWIw0/IGMWE1+u6PZkqdxSiYwyCrmriGtbukKZFW5BfT0Zq/jNQ?=
 =?iso-8859-1?Q?aIwYdHV2k9oGawSlTq4L7jZL2mcGP/ru/Xv+37UX5d8H4IDCkUUqexHHVt?=
 =?iso-8859-1?Q?BqSmZ6GUYjdbsSPb30suwbS4pjh4UKy6xW76U/A7UpfI69FMLWfrWxGGLA?=
 =?iso-8859-1?Q?AGM82Q+WZwQ3S2tWuJzapejJ8J4z75QREQkLYc3qkAPeWJ952w0QqhCu3W?=
 =?iso-8859-1?Q?knt0iT8/NvAaT1QfaPEEauttism4oQps4umJ/hT2U10XaOlilymxCpd/lA?=
 =?iso-8859-1?Q?ll7NjG5Co8FuzUPCE1aLTGpiH/h9GkjWRn6u61ci1hCl73fveSok+zByKr?=
 =?iso-8859-1?Q?BKFsTgoItu+Tl5CNq6W7gE6eIFh+ips/w4sdyu628leYLZR7XiQfWT/CJA?=
 =?iso-8859-1?Q?c12Wf+HvDADn37XEdzO3Q/1hTC14plXuNfCQxkWmrcTjkl98vGqcSl3eIl?=
 =?iso-8859-1?Q?6a2XY2z+ngGPhv9FtSnCV1aw9Kb9QstHLc+LBxd/Lz+PQh5biyK4pJVlHf?=
 =?iso-8859-1?Q?Tki9A/LL0ZYvfmIf8p2N826DbDByB6dLEW1wq2qYPjntpcoTg+O19Vdc8e?=
 =?iso-8859-1?Q?Nbu5yADL/Dgvkl9UE595o8hLrzm32++RM2RvpIEjrPrMYeOBvLiw0O+8DX?=
 =?iso-8859-1?Q?5AYQqiFtNye/+ht0bsoFPyBWrqICQWpW4s8nSOY4zz09KRqDKRcKPuIS5h?=
 =?iso-8859-1?Q?5F3Sev9TD4Hwp+dJr/sSO4QuS6/uTkeyg9TEiE7qIHotPa9giArDTcL/JV?=
 =?iso-8859-1?Q?mQd8GYZ0r2XIM=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(35042699022)(36860700013)(82310400026)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:47.9459
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e618c1e-394b-41aa-7dd7-08de39927264
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000004A.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6503

Now that GICv5 has arrived, the arch timer requires some TLC to
address some of the key differences introduced with GICv5.

For PPIs on GICv5, the set_pending_state and queue_irq_unlock irq_ops
are used as AP lists are not required at all for GICv5. The arch timer
also introduces an irq_op - get_input_level. Extend the
arch-timer-provided irq_ops to include the two PPI ops for vgic_v5
guests.

When possible, DVI (Direct Virtual Interrupt) is set for PPIs when
using a vgic_v5, which directly inject the pending state in to the
guest. This means that the host never sees the interrupt for the guest
for these interrupts. This has two impacts.

* First of all, the kvm_cpu_has_pending_timer check is updated to
  explicitly check if the timers are expected to fire.

* Secondly, for mapped timers (which use DVI) they must be masked on
  the host prior to entering a GICv5 guest, and unmasked on the return
  path. This is handled in set_timer_irq_phys_masked.

The final, but rather important, change is that the architected PPIs
for the timers are made mandatory for a GICv5 guest. Attempts to set
them to anything else are actively rejected. Once a vgic_v5 is
initialised, the arch timer PPIs are also explicitly reinitialised to
ensure the correct GICv5-compatible PPIs are used - this also adds in
the GICv5 PPI type to the intid.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/arch_timer.c     | 114 +++++++++++++++++++++++++++-----
 arch/arm64/kvm/vgic/vgic-init.c |   9 +++
 arch/arm64/kvm/vgic/vgic-v5.c   |   6 +-
 include/kvm/arm_arch_timer.h    |   7 +-
 include/kvm/arm_vgic.h          |   5 ++
 5 files changed, 119 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 6f033f6644219..b0a5a6c6bf8da 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -56,6 +56,17 @@ static struct irq_ops arch_timer_irq_ops =3D {
 	.get_input_level =3D kvm_arch_timer_get_input_level,
 };
=20
+static struct irq_ops arch_timer_irq_ops_vgic_v5 =3D {
+	.get_input_level =3D kvm_arch_timer_get_input_level,
+	.set_pending_state =3D vgic_v5_ppi_set_pending_state,
+	.queue_irq_unlock =3D vgic_v5_ppi_queue_irq_unlock,
+};
+
+static bool vgic_is_v5(struct kvm_vcpu *vcpu)
+{
+	return vcpu->kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5;
+}
+
 static int nr_timers(struct kvm_vcpu *vcpu)
 {
 	if (!vcpu_has_nv(vcpu))
@@ -396,7 +407,11 @@ static bool kvm_timer_should_fire(struct arch_timer_co=
ntext *timer_ctx)
=20
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	return vcpu_has_wfit_active(vcpu) && wfit_delay_ns(vcpu) =3D=3D 0;
+	struct arch_timer_context *vtimer =3D vcpu_vtimer(vcpu);
+	struct arch_timer_context *ptimer =3D vcpu_ptimer(vcpu);
+
+	return kvm_timer_should_fire(vtimer) || kvm_timer_should_fire(ptimer) ||
+	       (vcpu_has_wfit_active(vcpu) && wfit_delay_ns(vcpu) =3D=3D 0);
 }
=20
 /*
@@ -657,6 +672,24 @@ static inline void set_timer_irq_phys_active(struct ar=
ch_timer_context *ctx, boo
 	WARN_ON(r);
 }
=20
+/*
+ * On GICv5 we use DVI for the arch timer PPIs. This is restored later
+ * on as part of vgic_load. Therefore, in order to avoid the guest's
+ * interrupt making it to the host we mask it before entering the
+ * guest and unmask it again when we return.
+ */
+static inline void set_timer_irq_phys_masked(struct arch_timer_context *ct=
x, bool masked)
+{
+	if (masked) {
+		disable_percpu_irq(ctx->host_timer_irq);
+	} else {
+		if (ctx->host_timer_irq =3D=3D host_vtimer_irq)
+			enable_percpu_irq(ctx->host_timer_irq, host_vtimer_irq_flags);
+		else
+			enable_percpu_irq(ctx->host_timer_irq, host_ptimer_irq_flags);
+	}
+}
+
 static void kvm_timer_vcpu_load_gic(struct arch_timer_context *ctx)
 {
 	struct kvm_vcpu *vcpu =3D timer_context_to_vcpu(ctx);
@@ -675,7 +708,10 @@ static void kvm_timer_vcpu_load_gic(struct arch_timer_=
context *ctx)
=20
 	phys_active |=3D ctx->irq.level;
=20
-	set_timer_irq_phys_active(ctx, phys_active);
+	if (!vgic_is_v5(vcpu))
+		set_timer_irq_phys_active(ctx, phys_active);
+	else
+		set_timer_irq_phys_masked(ctx, true);
 }
=20
 static void kvm_timer_vcpu_load_nogic(struct kvm_vcpu *vcpu)
@@ -719,10 +755,14 @@ static void kvm_timer_vcpu_load_nested_switch(struct =
kvm_vcpu *vcpu,
 					      struct timer_map *map)
 {
 	int hw, ret;
+	struct irq_ops *ops;
=20
 	if (!irqchip_in_kernel(vcpu->kvm))
 		return;
=20
+	ops =3D vgic_is_v5(vcpu) ? &arch_timer_irq_ops_vgic_v5 :
+				 &arch_timer_irq_ops;
+
 	/*
 	 * We only ever unmap the vtimer irq on a VHE system that runs nested
 	 * virtualization, in which case we have both a valid emul_vtimer,
@@ -741,12 +781,12 @@ static void kvm_timer_vcpu_load_nested_switch(struct =
kvm_vcpu *vcpu,
 		ret =3D kvm_vgic_map_phys_irq(vcpu,
 					    map->direct_vtimer->host_timer_irq,
 					    timer_irq(map->direct_vtimer),
-					    &arch_timer_irq_ops);
+					    ops);
 		WARN_ON_ONCE(ret);
 		ret =3D kvm_vgic_map_phys_irq(vcpu,
 					    map->direct_ptimer->host_timer_irq,
 					    timer_irq(map->direct_ptimer),
-					    &arch_timer_irq_ops);
+					    ops);
 		WARN_ON_ONCE(ret);
 	}
 }
@@ -864,7 +904,8 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 	get_timer_map(vcpu, &map);
=20
 	if (static_branch_likely(&has_gic_active_state)) {
-		if (vcpu_has_nv(vcpu))
+		/* We don't do NV on GICv5, yet */
+		if (vcpu_has_nv(vcpu) && !vgic_is_v5(vcpu))
 			kvm_timer_vcpu_load_nested_switch(vcpu, &map);
=20
 		kvm_timer_vcpu_load_gic(map.direct_vtimer);
@@ -934,6 +975,15 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
=20
 	if (kvm_vcpu_is_blocking(vcpu))
 		kvm_timer_blocking(vcpu);
+
+	/* Unmask again on GICV5 */
+	if (vgic_is_v5(vcpu)) {
+		set_timer_irq_phys_masked(map.direct_vtimer, false);
+
+		if (map.direct_ptimer)
+			set_timer_irq_phys_masked(map.direct_ptimer, false);
+
+	}
 }
=20
 void kvm_timer_sync_nested(struct kvm_vcpu *vcpu)
@@ -1034,12 +1084,15 @@ void kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 	if (timer->enabled) {
 		for (int i =3D 0; i < nr_timers(vcpu); i++)
 			kvm_timer_update_irq(vcpu, false,
-					     vcpu_get_timer(vcpu, i));
+					vcpu_get_timer(vcpu, i));
=20
 		if (irqchip_in_kernel(vcpu->kvm)) {
-			kvm_vgic_reset_mapped_irq(vcpu, timer_irq(map.direct_vtimer));
+			kvm_vgic_reset_mapped_irq(
+				vcpu, timer_irq(map.direct_vtimer));
 			if (map.direct_ptimer)
-				kvm_vgic_reset_mapped_irq(vcpu, timer_irq(map.direct_ptimer));
+				kvm_vgic_reset_mapped_irq(
+					vcpu,
+					timer_irq(map.direct_ptimer));
 		}
 	}
=20
@@ -1092,10 +1145,19 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 		      HRTIMER_MODE_ABS_HARD);
 }
=20
+/*
+ * This is always called during kvm_arch_init_vm, but will also be
+ * called from kvm_vgic_create if we have a vGICv5.
+ */
 void kvm_timer_init_vm(struct kvm *kvm)
 {
+	/*
+	 * Set up the default PPIs - note that we adjust them based on
+	 * the model of the GIC as GICv5 uses a different way to
+	 * describing interrupts.
+	 */
 	for (int i =3D 0; i < NR_KVM_TIMERS; i++)
-		kvm->arch.timer_data.ppi[i] =3D default_ppi[i];
+		kvm->arch.timer_data.ppi[i] =3D get_vgic_ppi(kvm, default_ppi[i]);
 }
=20
 void kvm_timer_cpu_up(void)
@@ -1347,6 +1409,7 @@ static int kvm_irq_init(struct arch_timer_kvm_info *i=
nfo)
 		}
=20
 		arch_timer_irq_ops.flags |=3D VGIC_IRQ_SW_RESAMPLE;
+		arch_timer_irq_ops_vgic_v5.flags |=3D VGIC_IRQ_SW_RESAMPLE;
 		WARN_ON(irq_domain_push_irq(domain, host_vtimer_irq,
 					    (void *)TIMER_VTIMER));
 	}
@@ -1497,10 +1560,12 @@ static bool timer_irqs_are_valid(struct kvm_vcpu *v=
cpu)
 			break;
=20
 		/*
-		 * We know by construction that we only have PPIs, so
-		 * all values are less than 32.
+		 * We know by construction that we only have PPIs, so all values
+		 * are less than 32. However, we mask off most of the bits as we
+		 * might be presented with a GICv5 style PPI where the type is
+		 * encoded in the top-bits.
 		 */
-		ppis |=3D BIT(irq);
+		ppis |=3D BIT(irq & 0x1f);
 	}
=20
 	valid =3D hweight32(ppis) =3D=3D nr_timers(vcpu);
@@ -1538,7 +1603,9 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer =3D vcpu_timer(vcpu);
 	struct timer_map map;
+	struct irq_ops *ops;
 	int ret;
+	int irq;
=20
 	if (timer->enabled)
 		return 0;
@@ -1556,20 +1623,22 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 	}
=20
+	ops =3D vgic_is_v5(vcpu) ? &arch_timer_irq_ops_vgic_v5 :
+				 &arch_timer_irq_ops;
+
 	get_timer_map(vcpu, &map);
=20
-	ret =3D kvm_vgic_map_phys_irq(vcpu,
-				    map.direct_vtimer->host_timer_irq,
-				    timer_irq(map.direct_vtimer),
-				    &arch_timer_irq_ops);
+	irq =3D timer_irq(map.direct_vtimer);
+	ret =3D kvm_vgic_map_phys_irq(vcpu, map.direct_vtimer->host_timer_irq,
+				    irq, ops);
 	if (ret)
 		return ret;
=20
 	if (map.direct_ptimer) {
+		irq =3D timer_irq(map.direct_ptimer);
 		ret =3D kvm_vgic_map_phys_irq(vcpu,
 					    map.direct_ptimer->host_timer_irq,
-					    timer_irq(map.direct_ptimer),
-					    &arch_timer_irq_ops);
+					    irq, ops);
 	}
=20
 	if (ret)
@@ -1627,6 +1696,15 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, st=
ruct kvm_device_attr *attr)
 		goto out;
 	}
=20
+	/*
+	 * The PPIs for the Arch Timers arch architecturally defined for
+	 * GICv5. Reject anything that changes them from the specified value.
+	 */
+	if (vgic_is_v5(vcpu) && vcpu->kvm->arch.timer_data.ppi[idx] !=3D irq) {
+		ret =3D -EINVAL;
+		goto out;
+	}
+
 	/*
 	 * We cannot validate the IRQ unicity before we run, so take it at
 	 * face value. The verdict will be given on first vcpu run, for each
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 120f28b329738..5955dcbfd051f 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -177,6 +177,15 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		pfr1 |=3D SYS_FIELD_PREP_ENUM(ID_PFR1_EL1, GIC, GICv3);
 	} else {
 		aa64pfr2 |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR2_EL1, GCIE, IMP);
+
+		/*
+		 * We now know that we have a GICv5. The Arch Timer PPI
+		 * interrupts may have been initialised at this stage, but will
+		 * have done so assuming that we have an older GIC, meaning that
+		 * the IntIDs won't be correct. We init them again, and this
+		 * time they will be correct.
+		 */
+		kvm_timer_init_vm(kvm);
 	}
=20
 	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1, aa64pfr0);
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index a3d52ce066869..1a6c9fc86ed07 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -166,7 +166,7 @@ static void vgic_v5_construct_hmrs(struct kvm_vcpu *vcp=
u)
 	}
 }
=20
-static bool vgic_v5_ppi_set_pending_state(struct kvm_vcpu *vcpu,
+bool vgic_v5_ppi_set_pending_state(struct kvm_vcpu *vcpu,
 				   struct vgic_irq *irq)
 {
 	struct vgic_v5_cpu_if *cpu_if;
@@ -196,8 +196,8 @@ static bool vgic_v5_ppi_set_pending_state(struct kvm_vc=
pu *vcpu,
  * save/restore, but don't need the PPIs to be queued on a per-VCPU AP
  * list. Therefore, sanity check the state, unlock, and return.
  */
-static bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq =
*irq,
-					 unsigned long flags)
+bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
+				  unsigned long flags)
 	__releases(&irq->irq_lock)
 {
 	struct kvm_vcpu *vcpu;
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 7310841f45121..6cb9c20f9db65 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -10,6 +10,8 @@
 #include <linux/clocksource.h>
 #include <linux/hrtimer.h>
=20
+#include <linux/irqchip/arm-gic-v5.h>
+
 enum kvm_arch_timers {
 	TIMER_PTIMER,
 	TIMER_VTIMER,
@@ -47,7 +49,7 @@ struct arch_timer_vm_data {
 	u64	poffset;
=20
 	/* The PPI for each timer, global to the VM */
-	u8	ppi[NR_KVM_TIMERS];
+	u32	ppi[NR_KVM_TIMERS];
 };
=20
 struct arch_timer_context {
@@ -130,6 +132,9 @@ void kvm_timer_init_vhe(void);
 #define timer_vm_data(ctx)		(&(timer_context_to_vcpu(ctx)->kvm->arch.timer=
_data))
 #define timer_irq(ctx)			(timer_vm_data(ctx)->ppi[arch_timer_ctx_index(ctx=
)])
=20
+#define get_vgic_ppi(k, i) (((k)->arch.vgic.vgic_model !=3D KVM_DEV_TYPE_A=
RM_VGIC_V5) ? \
+				(i) : ((i) | FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI)))
+
 u64 kvm_arm_timer_read_sysreg(struct kvm_vcpu *vcpu,
 			      enum kvm_arch_timers tmr,
 			      enum kvm_arch_timer_regs treg);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 099b8ac02999e..6863e19d6eeb7 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -533,6 +533,11 @@ int vgic_v4_load(struct kvm_vcpu *vcpu);
 void vgic_v4_commit(struct kvm_vcpu *vcpu);
 int vgic_v4_put(struct kvm_vcpu *vcpu);
=20
+bool vgic_v5_ppi_set_pending_state(struct kvm_vcpu *vcpu,
+				   struct vgic_irq *irq);
+bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
+				  unsigned long flags);
+
 bool vgic_state_is_nested(struct kvm_vcpu *vcpu);
=20
 /* CPU HP callbacks */
--=20
2.34.1

