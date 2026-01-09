Return-Path: <kvm+bounces-67615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 3655ED0B8DB
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:14:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 19487305E7E8
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:07:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F5EC36999C;
	Fri,  9 Jan 2026 17:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Kf8RXYEg";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Kf8RXYEg"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013035.outbound.protection.outlook.com [40.107.159.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD3E36827D
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.35
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978362; cv=fail; b=o/ppOC+IJuMp26tCtuJAg1NrCKEHFuoMbKaIlBal6H5zwhfxd5S3CYzRoFS1d87Ncq6NZhCKbRHn2r6AItCNzQsLoTLnbFGZFvhvR9ujIk+T4TY5M8Ik87OWHaooyQkfDR81s2uC0BIk2lbZmHM4epQ/5L83YfhqLW95IKdPb4c=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978362; c=relaxed/simple;
	bh=ZFZMKMIdKXQngo5zDud2Ic1LAaW/ePplNXQRb15FLDY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ukWUhHh1kt9CViVO72CVBaIYlPg8J7FKQLcXXu5gZasUN/P5fpl7m82eIX5pb4aagoEm8y87BgrqI+LZUOhWAnzM8Vbwtau2alI2ddTbspfJQT6Ol+mXTarDWhBP++3zQR2CEKXagdrHLaRcgZRYBZ6tbBuGvpFJt3vmN2k/1K8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Kf8RXYEg; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Kf8RXYEg; arc=fail smtp.client-ip=40.107.159.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=J/tO7pee9Ufbeo87AM4WQY0hH6Vn6n64iFvL6XKA3mrEKfTZx1SDV5MZJilMYbmhxqdj/ROTts0su9oEvICHgpd+vJgbQti05kiabI755vCIUQsHtQw3ZGSbma/eV5IiDP+CAJ6kKwh6rQvmLIr5khC5tt8GF6Aa7W81O9sukAk1KilEB+xOdZIsLZ/W74KcDZuw2ziShlcJybfn7UXUEPbrJRt9w5W3LKe1TYkfmwrlBsEU34M0DlW+QVMhbzAMc2Zr7OW7u3vJgQ/y4khx4hJt8FGUMt3P8CMu3g1rh0x0qmlEej0MbBK72tf9iYUv0IiiFfKS/4BizCzS3VJuPw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uAngeOcNcSBDRjc2Td/6+OFwW+UpshSy2BPzuMeJSOc=;
 b=QrarOxWwXaeCT9tA5Ab3BIlJR/3frT8tRQdenYTz0Qqd/Mu0MyYtxvZK/+6ITOj0P9L6gK9dCijV9kQ5ynDVY/DI8u652GcgZl3XHjListvMkCO2HRtl3XSrRdr/Hn2AnCKNAYDKkAoxiXjiKoSE67KdFFyKds7cpE7tMc3WUcs8dgAQ9xxksaj7ZUDVgaEYVZV+iuB50cvlNs3Xjl1QHNpS2wbs7McieED+CCihpEgCEjMHGac5AuQny2Y1o3vs2yCSdBpnZMIBx9WFM9snYcwa5dJvPUI21sDFJrwfJO4eHv2ssPIlXT3j8xoY2rdAtgD5ziT7Ys4lQT6X2ijLWg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uAngeOcNcSBDRjc2Td/6+OFwW+UpshSy2BPzuMeJSOc=;
 b=Kf8RXYEg2hGltE57rO3kX2u3rQb28i/N2NQR7LFw4KxDnORdn1o6oVuNUMVLohaS2aCH1wPCCftPCHc3X/YNc+rH5GMgOAt530d42ZLcgVyme9wsuam/MLwzBsCnu95EjhhjLUaOwBR7+1ui9nn9WZ+RH3ynDZSx46++L1BkgQM=
Received: from AS4PR10CA0020.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5d8::10)
 by GV2PR08MB11540.eurprd08.prod.outlook.com (2603:10a6:150:2c9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:05:48 +0000
Received: from AM1PEPF000252DC.eurprd07.prod.outlook.com
 (2603:10a6:20b:5d8:cafe::3d) by AS4PR10CA0020.outlook.office365.com
 (2603:10a6:20b:5d8::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.5 via Frontend Transport; Fri, 9
 Jan 2026 17:05:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DC.mail.protection.outlook.com (10.167.16.54) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:05:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QR2GeVuI2uCMKIari7b58A31idIzHtXL9ZO9A5hhmMPTSkWM9PxYQuwnCZDAqtfvIqh4yc2zMqNVb4Z0Xk7aLqlQ8dGZj/taK7vBvj2PJI09wAcKZkGtvV45uLCLc0dMpB8MjY7ti+Atak1FMJ8fidPMjlgaQfbEkFDm5vmnEnLZG6dyeVt0H+CfnDAkx6n2HMJ0APFlxN87+oLpoNYsI4jnnOBsR/uO5xgvXd2/TFMKnU+S6251o7oSvCR8e2/ymbiTTjRa8OCPZpWKuPt3c3BMAA7KmfqVWCrCjmGT8NUhOSrADm5RWs32JSDmndVOKjryTPFfu84H0At35+TPCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uAngeOcNcSBDRjc2Td/6+OFwW+UpshSy2BPzuMeJSOc=;
 b=tG96bcVn6Q/KIHOI2qeHyNuuQQQCY4VVFWjVwrn6eI7WzjmTcRc4rRuTV0R2yT1Tj5VLTBojtrIzkW16jhrgkMoCaVNGuMqFkZ5+/0US/liLK1Tcx1MfgqHZNERBsjbYupg8qpcU4v48CK6O29k/nH33ghQeI0RlmJcS/Hgjosd4Qs5va9CNboeQZ/cPEzik03CDR9mEtXVfzkfDmX+CHQBduRZe2SELfgNLSv54GLlyiEzGJqmlvslczrTVVNxWfVH2UVvK4SjqjLWBSg5AxphotHD5sEvr10PZ+z2FOfa2Z45HLSZORlQ1L9pQ2FgWoZ7w2pKpGtZchNpMyx8FIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uAngeOcNcSBDRjc2Td/6+OFwW+UpshSy2BPzuMeJSOc=;
 b=Kf8RXYEg2hGltE57rO3kX2u3rQb28i/N2NQR7LFw4KxDnORdn1o6oVuNUMVLohaS2aCH1wPCCftPCHc3X/YNc+rH5GMgOAt530d42ZLcgVyme9wsuam/MLwzBsCnu95EjhhjLUaOwBR7+1ui9nn9WZ+RH3ynDZSx46++L1BkgQM=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS8PR08MB6216.eurprd08.prod.outlook.com (2603:10a6:20b:29c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:04:45 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:45 +0000
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
Subject: [PATCH v3 15/36] KVM: arm64: gic-v5: Implement GICv5 load/put and
 save/restore
Thread-Topic: [PATCH v3 15/36] KVM: arm64: gic-v5: Implement GICv5 load/put
 and save/restore
Thread-Index: AQHcgYoNuP0mM43sl0ee5XSBBQND3A==
Date: Fri, 9 Jan 2026 17:04:44 +0000
Message-ID: <20260109170400.1585048-16-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS8PR08MB6216:EE_|AM1PEPF000252DC:EE_|GV2PR08MB11540:EE_
X-MS-Office365-Filtering-Correlation-Id: 92f470d9-febc-421d-d7d9-08de4fa155a4
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?WDnmx0A3mh8+njTF5kULt1DLb94hbhKRZUha9o9scMUZ6FMtxLsyTxn+yk?=
 =?iso-8859-1?Q?EmdxvLhhTsiAalSq3x1LN9eNdKk1Z/n18kih3VI7X5Q54XETYcS/w250HG?=
 =?iso-8859-1?Q?IFFaHu7l9PFv14Gr2lg7mR7uBFmOTJJtJbR5s6LRWpk65idc5xsd4YgNnw?=
 =?iso-8859-1?Q?/O6a/12zpotoOS9StQbG4Lf5M0fXOZOQ2RUz0MUJ9B6/nhHffMBPvJPRtL?=
 =?iso-8859-1?Q?+YTAmxPI6wjS3AG20PLuk3IBwIdnvTLjPy30/FvJHTKTFSJWTlMM798GG/?=
 =?iso-8859-1?Q?w8cBuK4dmsUHl1BvTX2O8ddFR3jJjVdwAUhggAZzFVBcqwRaYYoJZrtPrh?=
 =?iso-8859-1?Q?WPcFchdsKtjp7OowqVhlOqUXtBbw+V5c2p/rFm/xYOlm5Vz36C9aYtVLUI?=
 =?iso-8859-1?Q?QG7cTayAK1cnDfI0uYgYjTmTuWEmHv9mGGyQKMnlw3dEtroyfVLbm1BSvO?=
 =?iso-8859-1?Q?x3Q2sBcE9Gk6LOA2Qx6RzX7v7I1/fPZtcfiQYm2fsaIqxRxEgnJvIbzIMx?=
 =?iso-8859-1?Q?VGy06mkvLwDO4HCIOrm5LcjDgULB5Jtu7jmGZkXXqOxVrPQWaDTZZxFDgC?=
 =?iso-8859-1?Q?zzIqZD09dmSwXftW6AjkTgvnx3pSrubjPN54uQao+dwu7FQifv38vyfXlu?=
 =?iso-8859-1?Q?mstZkIN9XVuWHzz3932hScyQXuOvf5bV0aS6jVie6ExJ0+8MqB/H9Z08Gs?=
 =?iso-8859-1?Q?cMP1ikO7Z9cc0EvlkEePvVYAc6j9Dx1MoI+YCovN85/IgmmppLoGyw4H2h?=
 =?iso-8859-1?Q?/P3MHB8oN+uR8qf2Dlw6f3+B6Tia8oOcYKytG56sSB6CEjhARglqJ5nqiA?=
 =?iso-8859-1?Q?4KRhbLASTh+UD99LfYVwhSxshE/eM9nDQyTfmRX9yMCndA8w2i4uMAOPZi?=
 =?iso-8859-1?Q?6EmIONMgSS+Mv617pE/midijfEZwx1IqyR7tPytUuubE0Kdn6VfO0qq5Up?=
 =?iso-8859-1?Q?gKFYnWwe+JrGQe2viZLcabqXUkI416zD6CdyCiUTfyqJGdbe86ZUrTIFWC?=
 =?iso-8859-1?Q?7NgMgXxUpjLLoXIhlbbuLON/3zyQTewc6r7u5mc5i75WLqM2bIeN3wrhAL?=
 =?iso-8859-1?Q?0UL2W++ANnEfWUhWnI7p27RmZ26AC+c3W9j8uPflbRFHjBLnE9VHKOf/lr?=
 =?iso-8859-1?Q?5mPieVM6A6eRH8R8yxKGLwZKh37QpIoBOW1cHqkjz5Kgzp7mO7Pbo75clQ?=
 =?iso-8859-1?Q?jLe4vqjuEqFtiRVf1auTxJv85TgobdZWTOOqDB1mDYvQBJlJL+k7qTBx19?=
 =?iso-8859-1?Q?LXKvKcXfNT7A0m5QwMaN67jpMrbU78RigWCN0X3nsvfaIBy6b99yx2oIhV?=
 =?iso-8859-1?Q?n7C0txzRNEob5ty9Z+b00HNElb46FgF54BCNm/yqvocQmL8kgSlwlK+Cgb?=
 =?iso-8859-1?Q?TbRDTOB39tpn5gX+kTZy+Cekd6Ck3oCpY2IrFFIfSrt5suR7C17R39zANT?=
 =?iso-8859-1?Q?TU7ClHltytunVhhDWc5Iw446yrKV2CFJHDLd3BFPS0uQk1F4V0eX7EhR4k?=
 =?iso-8859-1?Q?1iJDY7weS0R5uff6hBST941BJ+B2sPrwjfLe/2/ajNj/XYAAwIWQPZzlT/?=
 =?iso-8859-1?Q?kU3sV6cdbp7xf4zkvDGY1vxaVNDt?=
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
 AM1PEPF000252DC.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d80371eb-d0a5-487b-d37d-08de4fa13069
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|14060799003|1800799024|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?TnWm6jirxCeIDrPd9+GMUvBvG/zvnf4tLJNDt/EwMjxZZNjBYhHdiQ2S86?=
 =?iso-8859-1?Q?7sA5phhoa0v8DrEM9p82xqPBmSaTJHTUh9yr5593w8xiihyp2V9hPdmXpl?=
 =?iso-8859-1?Q?cVK6yN0+TclbH/CbQjWPokIjBBdoAStSsGQwW/oywx6wIJxUF8AaZZVKrA?=
 =?iso-8859-1?Q?zkYV+2nF/r4zvMHRI1CTM23S0ylxdTXDRdcgWvFPUEpaRb4DddvDrVUZlu?=
 =?iso-8859-1?Q?pSPg7IWwAuMF4kroxr6wvYXQQwZ/EQ/wVd1O72+P83Zerz6k6J7tu+z0Vv?=
 =?iso-8859-1?Q?UCcGGHYntyGuEId7JTZzT6cf1jA5xCuE+iq1WUhRjal4cLYdjqsRVVRJrQ?=
 =?iso-8859-1?Q?yxECoUIGiRzJKCxPDtLYU7kwmZEPQXlPhrKHmIekGtq9SIlQOpWsYior68?=
 =?iso-8859-1?Q?HHP/nNYrJjYkIlAC2+GWurMOBdMl0l3uaVaJaiXOxPg2ZXDdMpxe4A4Vqn?=
 =?iso-8859-1?Q?daOCXGTgUwHqYGcvIXIG4g4lQwYjK0a1yt9a3jMDjOEmc5yeFT10bYbMDk?=
 =?iso-8859-1?Q?kxgkwqVTGZJhV5sRqvdzYQ6eSWOWoNevPD7JitLqcWjs8CmSXayFoiQyj4?=
 =?iso-8859-1?Q?srqpYdMM6V806CEnhRCCU0GhQi5xUTdZIVt2ycv56ELFdhOaHUTpZ4N8tU?=
 =?iso-8859-1?Q?dKcYhisOnREdPF0taGP1AmdZOKTerUZvM8np8yaWX4AujX9wbyXDiGuO7t?=
 =?iso-8859-1?Q?uXrkRmMKodF5RkDyfFLdclk6+ID82NllxNP/Tw4SYI+Z9Nk1of1NCquuZL?=
 =?iso-8859-1?Q?uJCj/bKzQYuuzn9cMtL5Z+7y3kbytEgdyvvHYZVcM6u3dcxk1m8iZQOczx?=
 =?iso-8859-1?Q?o4SqNgCy4JGf7h5ANhrpssZo5v5Qh4U8va6Z/MirV40mgsyAd/KmU9q8nB?=
 =?iso-8859-1?Q?y/gNCggrlO8z3tFXj4ACX53of4qPrht20LubH7xqQr0Zn1HrR7YAbGa/zm?=
 =?iso-8859-1?Q?4eLhEnv+cU+HDPV4wqoux05HOfOvjSeFj3szhIkhRtHfgcdVx1giJbsLgm?=
 =?iso-8859-1?Q?9Z3SPatIyRcN5GkDxn/N4FNa3ynOYldhNWCmC9OMvPNzs81sZBJokSN3WO?=
 =?iso-8859-1?Q?i7CdRlL1Y5s/CpMH/zGx9ys/tRTlihimk9MLce/uma16n1jqQAcix8+PqC?=
 =?iso-8859-1?Q?17Rdf69Re1rrCPjpgDqpnVzUOko/ytgm85ToqJ5t3GwuhTMk1MIEihmHiK?=
 =?iso-8859-1?Q?N67iO+PhGmFeWXY+qme6R3BzCTnuWsqFrA/LYnrPh4sYO68jjDxo8hrysb?=
 =?iso-8859-1?Q?cO3lw9jKlnd5oMmyNLVtx2ID/dIeiSD8llM3nMKN9Nb96K+kz5EvrvaWnV?=
 =?iso-8859-1?Q?JoQNJDaF+IqR/zDzjvOzx7pTo2vq/eLJcWZmW6usN1KfRhlZyLDMO93RvM?=
 =?iso-8859-1?Q?fC2AWfdhy6PnQzFWvX8BSu5Wb01+m1IFnBBYpo5I2hdkM/gwWW+mWLeOcs?=
 =?iso-8859-1?Q?o/NtUaNtWDe2ZgN3lltts/3BOIc1L31sS/3zOj7U25JZQ+gpPvwV7le/0G?=
 =?iso-8859-1?Q?ukEEzqWm86xymjX4xwqMK7zdC6WO6mZxK3ukl6Pk0zQTUxKgrFgT7k7pw3?=
 =?iso-8859-1?Q?zPgETCJ+EgBFHQ9YzQ86QDXfV9/wJlwmeL8ne4hCDl6RoQKImC3+IwH9LT?=
 =?iso-8859-1?Q?k+FTniICbi5lM=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(14060799003)(1800799024)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:47.7282
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92f470d9-febc-421d-d7d9-08de4fa155a4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DC.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11540

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
 arch/arm64/kvm/hyp/nvhe/switch.c   | 12 +++++
 arch/arm64/kvm/vgic/vgic-mmio.c    | 28 +++++++----
 arch/arm64/kvm/vgic/vgic-v5.c      | 74 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c         | 32 ++++++++-----
 arch/arm64/kvm/vgic/vgic.h         |  7 +++
 include/kvm/arm_vgic.h             |  2 +
 include/linux/irqchip/arm-gic-v5.h |  5 ++
 7 files changed, 141 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/swi=
tch.c
index c23e22ffac080..bc446a5d94d68 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -113,6 +113,12 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 /* Save VGICv3 state on non-VHE systems */
 static void __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 {
+	if (kern_hyp_va(vcpu->kvm)->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_=
VGIC_V5) {
+		__vgic_v5_save_state(&vcpu->arch.vgic_cpu.vgic_v5);
+		__vgic_v5_save_ppi_state(&vcpu->arch.vgic_cpu.vgic_v5);
+		return;
+	}
+
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
 		__vgic_v3_save_state(&vcpu->arch.vgic_cpu.vgic_v3);
 		__vgic_v3_deactivate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
@@ -122,6 +128,12 @@ static void __hyp_vgic_save_state(struct kvm_vcpu *vcp=
u)
 /* Restore VGICv3 state on non-VHE systems */
 static void __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 {
+	if (kern_hyp_va(vcpu->kvm)->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_=
VGIC_V5) {
+		__vgic_v5_restore_state(&vcpu->arch.vgic_cpu.vgic_v5);
+		__vgic_v5_restore_ppi_state(&vcpu->arch.vgic_cpu.vgic_v5);
+		return;
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
index 85f9ee5b0ccad..d09b8992345eb 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -89,3 +89,77 @@ void vgic_v5_get_implemented_ppis(void)
 	if (system_supports_pmuv3())
 		ppi_caps->impl_ppi_mask[0] |=3D BIT_ULL(GICV5_ARCH_PPI_PMUIRQ);
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
+	kvm_call_hyp(__vgic_v5_restore_vmcr_apr, cpu_if);
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
+	kvm_call_hyp(__vgic_v5_save_apr, cpu_if);
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
+	__vgic_v5_restore_state(cpu_if);
+	kvm_call_hyp(__vgic_v5_restore_ppi_state, cpu_if);
+	dsb(sy);
+}
+
+void vgic_v5_save_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	__vgic_v5_save_state(cpu_if);
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
index eb16184c14cc5..9905317c9d49d 100644
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
@@ -363,6 +364,12 @@ void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_get_implemented_ppis(void);
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
index 7682ee72af775..872c278bc7319 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -433,6 +433,8 @@ struct vgic_v5_cpu_if {
 	 * it is the hyp's responsibility to keep the state constistent.
 	 */
 	u64	vgic_icsr;
+
+	struct gicv5_vpe gicv5_vpe;
 };
=20
 /* What PPI capabilities does a GICv5 host have */
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index d0103046ceb5e..f557dc7f250b8 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -364,6 +364,11 @@ int gicv5_spi_irq_set_type(struct irq_data *d, unsigne=
d int type);
 int gicv5_irs_iste_alloc(u32 lpi);
 void gicv5_irs_syncr(void);
=20
+/* Embedded in kvm.arch */
+struct gicv5_vpe {
+	bool			resident;
+};
+
 struct gicv5_its_devtab_cfg {
 	union {
 		struct {
--=20
2.34.1

