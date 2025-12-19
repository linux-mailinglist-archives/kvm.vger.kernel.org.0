Return-Path: <kvm+bounces-66371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 50DAFCD0B5F
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:04:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B5AD2303EDF6
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB1FA361DCF;
	Fri, 19 Dec 2025 15:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hDOvE8cI";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hDOvE8cI"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011060.outbound.protection.outlook.com [40.107.130.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B165363C63
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.60
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159644; cv=fail; b=iZHXV+4L8s+rhI/t6CAcXkdiv/AiI/NCIRk13A4POqbZTJukHbNRVa7FcV3HgjuMC1cbJ2odcsypMbzomT3NJ0Yv4G2dh5OJoHpE8eXD+F7LV3ChOi4qOJ4KZZmq4BmYoZzsBHNVlaxm6HmFQSYQng47m93raEzJJ1/WESEa/W0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159644; c=relaxed/simple;
	bh=jNp7nUrFHRkzbEsqEN7N2hPplqIifKL7sBEs8c6ZReA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=inSNRKDhKHsvXu8LecAAdZqWHhjYiR9+h7BketufCNtdhFmZ5OiA2b3LXipSGSqTC1E5PjvlQ4mfv8jaR58rsELtG4V5gsqWIlAfMf3U1ty1pEvuk8bCeSXYGaqgXHniw25JTZmidYTpmFXBSRvi3lRlrXGwAXxQ+8iQMBLvk1c=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hDOvE8cI; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hDOvE8cI; arc=fail smtp.client-ip=40.107.130.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=d3vV1y9JBwqthymsIW6jvkq2UPFwpDuamJYU/u8dzo0jsiXKK58fGvXytbLEFsgOAis333Ml6Pd0x6Nm05XJOukZtXMlMcyVUIhaFzb6wF/lPYIk2SiLjVMlW3LbLBZUevLrk+12Z9d9wiz32jexc/xmqmNH0ixPUOGUOYx7GGReyOTIAP5usYarcqjvXQseIZqKRqgxL95S+F0y0SFUZs2Eq76T3lxubvYxDy8prnFEUWzfohMAO9rmiup3aQDf0RCRZw4MIK19/iJdKqdT52nOLYnKqU58s+RqCol/UeCeM5Sap/Ln32EWCq9pOUkC/dKyJevpR+vPDV+b+sRi0A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hn7IeW4CjFvq1YLy/rZBYSBXvoXbisAZ2xECaiHx9eE=;
 b=eMClYDw23zlT192LDPwkNU/jvOIbhIZ8/fXGy0r6XZMp9XdoA2xQZxhMcf7YjT/UhGsx2FZzdeb2kiMLaq0Ng/mSbS7BrwtCOg96st4ZOSty/rSRDEpdqLFiAPoAE7ShjR10f5CInjgf+Ix164fztqoI9EB4sVRaBqhH0LSoVOrROSbJhbrPTiqD5SRStD4pQRKzXspulrTMcQcNClV8faAHR/ybXRDyAcFOU/YWuoIU4EjthbFgFNpiLRAfnIE7JjLtJa2HR7z36j//EUH2A6/N7ojpdxSKxwP6r/aEjnb/p9WO8lEwpeIAMA4hr0YyEizmjd4vPy0KrW/NcmoUbw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hn7IeW4CjFvq1YLy/rZBYSBXvoXbisAZ2xECaiHx9eE=;
 b=hDOvE8cIRmKezu0pcOHkjR37J44JuM0mijYZLDMepao+bX8SSoJeH8oOg4n3BkWREC14QPZ5CXg4vYeXg8rfvsfoNmhErJKfQzHMf8QgwqdZjsOguCprnNop4gE+44lvStjTn1WelsdwBT/7p0+kxd1eXdtIO/GJCr+MciYHUvQ=
Received: from DU6P191CA0001.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:540::11)
 by VI0PR08MB11514.eurprd08.prod.outlook.com (2603:10a6:800:2fd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:53:51 +0000
Received: from DB1PEPF000509F8.eurprd02.prod.outlook.com
 (2603:10a6:10:540:cafe::80) by DU6P191CA0001.outlook.office365.com
 (2603:10a6:10:540::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.9 via Frontend Transport; Fri,
 19 Dec 2025 15:53:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F8.mail.protection.outlook.com (10.167.242.154) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:53:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CAIA/2u74ddP53s6Va6TOYJW3r8c478KJBZ7jDyIPFmKvkIuq7g4UUDDvztoXKItzz8ywxBCFpT/GZfEfc6YaKFb3mUyYChg3bXSn2DfBJYbUXliq0sGoP6f1JSXtUJGOn15hJct0/u4CbCi1vNUmHp/rDvtHsTop1wUdMLIuJdO9Bai15pgsJ9ZiokO9UMouaxL1YfwzsTY47nn5CELJ2k+iu+P2rj7cCbrtuVEP/RVzoGLPKPTtE8YkcCVeUr3E7FpKFDWx0H/Y2g4okX6+hjM5Ig9JQnrYNKY4Md9N0D1WadK2eqxJlQpPIIM5a6JZcIfgd25LMXwM+r5ShJ7fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hn7IeW4CjFvq1YLy/rZBYSBXvoXbisAZ2xECaiHx9eE=;
 b=vVMSbbLNoT5/tz7vYYIpgn0olHimaHusC9kA3MgWrDyTmwIoOIoaXrMGmjYRSj6viMgd6pYem+PgrwMl/oIqoThh6qBJ5qOpz32jU8lW6KEQshSzYfGAR+x+08HtC1zJx9/BkJ+EfA+El9rHkSiRWdL/3MK/xznU6Z6s6fuJEYBdYs+ASa+v7DBVIBrmNpzkSCD1E0JjrngseXXlIDBJt81E10YjtNNNsWt/egGNB8FtHP+1iKK741b+mE/IFaffA+B5D7qBLuTFqkgd3WB8VjsHILiLuOvrw0Ao4SZLzuj34qsEw8wLahD8uD696qkmD/xLeGMd9P+Duq594scpMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hn7IeW4CjFvq1YLy/rZBYSBXvoXbisAZ2xECaiHx9eE=;
 b=hDOvE8cIRmKezu0pcOHkjR37J44JuM0mijYZLDMepao+bX8SSoJeH8oOg4n3BkWREC14QPZ5CXg4vYeXg8rfvsfoNmhErJKfQzHMf8QgwqdZjsOguCprnNop4gE+44lvStjTn1WelsdwBT/7p0+kxd1eXdtIO/GJCr+MciYHUvQ=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AM8PR08MB6515.eurprd08.prod.outlook.com (2603:10a6:20b:369::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:52:47 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:52:47 +0000
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
Subject: [PATCH v2 29/36] KVM: arm64: gic-v5: Hide FEAT_GCIE from NV GICv5
 guests
Thread-Topic: [PATCH v2 29/36] KVM: arm64: gic-v5: Hide FEAT_GCIE from NV
 GICv5 guests
Thread-Index: AQHccP+EIibzd6ai8Ui90VgcwzOUHQ==
Date: Fri, 19 Dec 2025 15:52:46 +0000
Message-ID: <20251219155222.1383109-30-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|AM8PR08MB6515:EE_|DB1PEPF000509F8:EE_|VI0PR08MB11514:EE_
X-MS-Office365-Filtering-Correlation-Id: 8028c076-5576-4d9a-92dd-08de3f16cd34
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?Sby1ENaDjX9cO4O0GJ3Ini05zBP2RgIR5Rf5fopSXjBy54cNzyFiRue4yd?=
 =?iso-8859-1?Q?WrnT0TiaECGpssQcNWZJybQBhTTUslDxkmE2bw6ZVfYpgKWkMnzL3zonv8?=
 =?iso-8859-1?Q?d6YB8R9kMtlKe3uIXh/GuiJ3NQ0tifLLaK8pbrLNv7oi2IWr84Avf8o60j?=
 =?iso-8859-1?Q?Q4BJcP7qMxMX8CrDUNkbJeFPbms8A3rQQONXEx8T/Anw5q6+jGn2VNrDtb?=
 =?iso-8859-1?Q?xj9POgHaAbsS6KFedVuS49UjIGnBVCp77wLDjRrZORwrHl/DLeSPtLrmTy?=
 =?iso-8859-1?Q?9SaAZ2W5j50jFY0lfuw3s3d3RRs0rPFsxJT9dYxTYdLQtVSlSzVkz4sMSw?=
 =?iso-8859-1?Q?btr1gmNq5D0W1cVbcLlr4JRw6hw73EDQ78rjfzxrVW/+zIuks0wdOgM+40?=
 =?iso-8859-1?Q?dVJ7F/v2PKi/W36cSYer7oP4gwHT377LcxKTzakK5n1HfAg3Wu/HL6UeDE?=
 =?iso-8859-1?Q?4ACQCf2QJO6W7PvjdScKORVrWUnMCa386JGh+qZBbf+9Oq5TilEH3fjJTv?=
 =?iso-8859-1?Q?iANq4H3UDCMGO62SlGSBltEpZb3l8yaUHFAlKxGCLmKY0kZ2k3+eJbrIuh?=
 =?iso-8859-1?Q?Gyu7x8r1PJKHCgWsVDHycsh3wV4CcpnJDy4v2T9jarBgI1yUZT7oxo+uaP?=
 =?iso-8859-1?Q?Clq5fkC2X+0PR2IfUX9ZPwAdWeJUfKc5VrUGnOap/6/C9yovIpYyCiHABx?=
 =?iso-8859-1?Q?G1fYzWx4GCFUQHgK1wtnvBrI0t4wRWScaeEy9ziRhpsmLB95z9Nh0AvKl4?=
 =?iso-8859-1?Q?AtKqcS8kA9ImAxqe3v4gAvRVIyanLEh+wfQ0r1weFNm7P3CwB2m5XwNa1R?=
 =?iso-8859-1?Q?16qhGXBEoV8+uE1Ute/h6ObN2KHaFRLaAd65ZxLJPk89o0PWJZB3QX32sl?=
 =?iso-8859-1?Q?nlKVOpUOXSlvYWJ0gjR+1UKU2zmM8euzJjizS83mCKXO/Z7JvL4XaLxF4z?=
 =?iso-8859-1?Q?N2o0wLEtgSkFoxWD7P1pzfD28St0vRUS7pzpbCiQR4faiNfrwjjdka+9GN?=
 =?iso-8859-1?Q?tYFHSODdvBnYJNU5BhvIGBkkJSdmgHzOE+MPRW7KckOk48/W6DUnKOnlfv?=
 =?iso-8859-1?Q?DdiYGLuDHWmLH5CWCB/mctisctu0kLt4CMC/OFp/3Y9A7Md4nszV9cPVLv?=
 =?iso-8859-1?Q?K5zWFQ4JGMsUhO1EHjLmje2Vi5eme9yKoGwTuX9tdou9+sE9s9SUK+vAJL?=
 =?iso-8859-1?Q?tAaBAvgYZZ542oN5vmpB7/ggAg6Hm+XmCz7Qcg1EJtNEqkTbTflnQO1WK3?=
 =?iso-8859-1?Q?ELZvOa71X4mX0pVEC1+5C5+0vWSZAAHBqakgBkZTsRwbu/HDoerW3RDkFc?=
 =?iso-8859-1?Q?LltqZI6iUjgKBUS2+aV0reUoocj6rrshfUcsAKRFY4xqzhOdVILFbZ9aaH?=
 =?iso-8859-1?Q?updOGQi3+6u7xQQ5cH6pwjAxHX8Vr4DNmoQsJNSWQPrbuQni0BSp86D3qN?=
 =?iso-8859-1?Q?w6RI5kqAc4Wh08gxqJ6roQpHKX/aUVQkWFJWbMzINq4bwDOYPwh427x7J9?=
 =?iso-8859-1?Q?rMHDqg2vIqLru1/+e/hfkW2mUWk3gWSkXo7arxPlAxMt9spGlx0eDI5kg5?=
 =?iso-8859-1?Q?VG0PqdSgLZVaRHecVZiecHwPJYsG?=
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
 DB1PEPF000509F8.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	278437ed-098a-4bf3-df36-08de3f16a7f0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|82310400026|376014|35042699022|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?kHff3rsLYDw8R2Jr+MSSr3R7ngVTfZfmejEKvyJGSJ4uiYetea7gCIneiF?=
 =?iso-8859-1?Q?EER6Smv1WChnlaxgwOwuec6Ab1DJjU0zREN5tgNr6yknG7NX8TtHSoi6xg?=
 =?iso-8859-1?Q?jhbzX9LuxMBuMemrcai+OXq+xWJCfEKqYeBDvuVTahlDkM+PsXy7Qm46fw?=
 =?iso-8859-1?Q?dcjS9Aj92ARNc+WoiySD+iIr5R2Cy75/nypr1cdNYofGVCe3o8QSabMJZe?=
 =?iso-8859-1?Q?Udpl3Qo9UIME3Crm0SjMrn4OOke6pkuFzIBZ7/hxC9/yJLN3aHsNX6LM4p?=
 =?iso-8859-1?Q?x2ZDq/pow3UfabFgPwrdYEriDgUf85fWjKo94nS6ROIc1jSqTwyEVkhvfc?=
 =?iso-8859-1?Q?oBH0Q/MOhVLGX2MbA+i4MTijEHQGrcrRdc7FZ733ir97TdSzZNZOw3RQQC?=
 =?iso-8859-1?Q?0IXZc2d9q3HeL+M3j2y/CUfs0cHLoHGe3+dlC0n0WIa4B1Xt1F65nRh484?=
 =?iso-8859-1?Q?k2Y3vAdnPN+CbjSHQRT4h/dF9YsOglNhcNXRO6jE71Qam+rx4JBMrlteZW?=
 =?iso-8859-1?Q?1TLITlVP4grHsNxXJgAr1YIEcu8FLoqt4q/sDpXr6ju8FLmYHZgxGHEtl1?=
 =?iso-8859-1?Q?0/OrCExBkgO0Hlt3+FcVSpOwDxDSicSCrp+G27sZDaI65v9ONDAyucGYqM?=
 =?iso-8859-1?Q?VJj5i+0DQqDUjkGalEBtBia/ItZ8ku0o2ZmJ9VghuYFyIsGZ9OyiCP1922?=
 =?iso-8859-1?Q?2aQ4H8VJ9Ja0pzp7+UrmLs+/SO+MMLgPeR9uUSRuH0zopBnMrmfMrW4vjQ?=
 =?iso-8859-1?Q?OTqBW03OzsJDgm0xgN6IMmsxJub1L655C6jRYArkrspgBN51m5sa7YqnkG?=
 =?iso-8859-1?Q?i0BlsrWblHmBgL9XnoYAXjjMG4bXHEh0Q6bNSKzF66JSGQ3WqlM3nk8et8?=
 =?iso-8859-1?Q?LvxYJPeuufhwSwotlJQJOS2vFSvOqkxCoGJ3r3RUInmyP/MR5Odpp0oNAD?=
 =?iso-8859-1?Q?md9Znit9a6f+wu9ZAuhJRiuUKahyAXpxd8WUidEsYFRhxr0M8PeAQ1dtno?=
 =?iso-8859-1?Q?lCPCISZ7Q2NV6g8shu+T6GpxYggb4eYVdBXp99BE3kNpu2sPiYr+zArb7W?=
 =?iso-8859-1?Q?hDsTm+N1YsH5hin0sbMOZDy5REsYzayR6WRPj3gag8z/fYQhmrqsXRggK+?=
 =?iso-8859-1?Q?yBfYfMONnNg4HPMBsYi1slATTW7twQ1T2POdcf79NM8ExOXuMNsed9/Izc?=
 =?iso-8859-1?Q?nOrjYgR2hC6zVYtXbO/czDm3Q+PMxglrQ2u3efa6VnVJxiJXwsf4d4iyGA?=
 =?iso-8859-1?Q?D3C7Hsl3r5Lq1Uv4njbT8yOAJHPB4A+IAP3NVuGZO/YyXmUSnr/KNOjdqp?=
 =?iso-8859-1?Q?Oy204h9K38Cio8vqnrIEV8FkeY9VAUExdneGg81rruFLUxRLC6PRz+6BKE?=
 =?iso-8859-1?Q?R9WY8gfk11AwpvsGSbr/1IrjkB4SC382VIEJVqgNQpOan3fqrNLYozUadh?=
 =?iso-8859-1?Q?4toYBpkiLoJndOoYK3qBf/kXuYplVwROcO4R9QcZ9BeIXOGXGQnT/WHiIS?=
 =?iso-8859-1?Q?M17jevBh+htbkWMpYTr2SWjKK6jzN7iFXPnOsLl+lVC/L2zx5Avf3Snzju?=
 =?iso-8859-1?Q?+RV72c5XY6y9xInZf0QaFfkBEmU594pZ0CoTry2UfpkWN59AbJLB7/ZUHw?=
 =?iso-8859-1?Q?sc04bl5ykdUPw=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(82310400026)(376014)(35042699022)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:49.6780
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8028c076-5576-4d9a-92dd-08de3f16cd34
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F8.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11514

Currently, NV guests are not supported with GICv5. Therefore, make
sure that FEAT_GCIE is always hidden from such guests.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/nested.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index cdeeb8f09e722..66404d48405e7 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1547,6 +1547,11 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 va=
l)
 			 ID_AA64PFR1_EL1_MTE);
 		break;
=20
+	case SYS_ID_AA64PFR2_EL1:
+		/* GICv5 is not yet supported for NV */
+		val &=3D ~ID_AA64PFR2_EL1_GCIE;
+		break;
+
 	case SYS_ID_AA64MMFR0_EL1:
 		/* Hide ExS, Secure Memory */
 		val &=3D ~(ID_AA64MMFR0_EL1_EXS		|
--=20
2.34.1

