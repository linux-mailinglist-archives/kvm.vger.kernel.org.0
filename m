Return-Path: <kvm+bounces-66400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B61A2CD11A1
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 18:19:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7105B300EE41
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:16:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D03093845B7;
	Fri, 19 Dec 2025 16:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sMShdz69";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sMShdz69"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013041.outbound.protection.outlook.com [52.101.72.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F40382D21
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 16:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.41
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766160855; cv=fail; b=DnzoqeRnGzEv9om5uKwyh1NyEMH7/jO+1SMUSqqIWFYNWNafMR+0n6zXt4gMc6aWXC8XPuK6u6fyOCEww+rDD8w9fPSUDvk4pLlvg1Dl912Q9xm0wzoMNc8DQhh4o5MzX3EaAiNJwo+5SvHeQBo25o5QcDx/gMWNILMDtSBQMJg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766160855; c=relaxed/simple;
	bh=D5IKlUHhZ6lOSNU7JmtnvEMMRrXpJ+N3iVFsJkIIxFM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ks3zWmJOFMLRDXuwFnKtgln7PawubaG46N9ZVr6v/99dM/Sg1PApJ06H0iaozncQanO/vgWGWXnysL54t4jr5Ccb0mYTxUgQypHN9D1p8/gEq+aQNn2OLm1mWvjhtNq0dVYWfQxMSjGuc3cZ+iO8DA10W3b6uzmSc7Ikn83n1Dk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sMShdz69; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sMShdz69; arc=fail smtp.client-ip=52.101.72.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=pI83C3d+s1BDpI/IU1e64u4uf6HzxwENwzlqmD/GPO6BUckZZDUbQFQ3BzZQ3OQzzpAiRqoetOlbuY1k+AEMA37j9LjQrVXkNtT/XYWQA5bQnhDZaRoOstZY9oaeZUoLVM9KK6SDMK7o5e2rs5E3EAS9MV85yiNO+8OtKa6msFeirIHa2t8pSl2F2eg+oNN1vekAJQXQj50Yf1/wOVa6LiR/bxB+Dh06XkWOPMKc0xwWlIV9Q0zRjkz1p15iO8nqjA5RgoDjym+nSN5OIiB0LUssOovZYoEyCM36hFDhOJbAbsT1PN8IOh+4gdZmguGGngEagG8biQwXP7cImltVeQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cHt4x0S9NMScThiV7jrQcBA2d40ykb4Mzn3ReRecnvQ=;
 b=eH4WNtQZu9yUMQafVmXLOFp6cA3eGxezDkwDuKDj2sqxrJMSvwrbvds0yg92WjRuRK9xjs1WptXq/J5WBC2xEX3MWSCsxWn6atMWkrFyTnaYNbCp0ojFKPjyVXK9PjgYPKtqB7AVn5HcBQ+1Mu50c2ev50ZUG6jllYhGwgumnI5DtmYAdOfGjt6peV1KQnte8iP6ZETa1JciFBuPkJP08HJhS0wgme80qB2E4c+LO4PvGX93lmBMe9+KaK5td6rnXOdSTjMZpTwnK/Qe673Wx9W+dsD4gqWUxqr3z+RdfY/MgdkI7ydyyPQwfl/rMZhaiFgMw3O8Tb0gbuTffWgjGA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cHt4x0S9NMScThiV7jrQcBA2d40ykb4Mzn3ReRecnvQ=;
 b=sMShdz69TvpH/0jVUcAoT8UCDqfNLPdTvVBlFC3Jv6dtuxwleNormDc/hWj44e+HcXsA2Lv89t8YbfJzltMcLo+GtrJmO1HOZqfSc98cq/fJpdikA1XaUZ2o7mNLae6muGXUpVbIK4YAg46JejgZSNRPkxhHAFQmOmh2AF13tAg=
Received: from AS9P309CA0008.EURP309.PROD.OUTLOOK.COM (2603:10a6:20b:45d::15)
 by DB9PR08MB8314.eurprd08.prod.outlook.com (2603:10a6:10:3de::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 16:14:07 +0000
Received: from AMS1EPF0000004C.eurprd04.prod.outlook.com
 (2603:10a6:20b:45d:cafe::f) by AS9P309CA0008.outlook.office365.com
 (2603:10a6:20b:45d::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9456.5 via Frontend Transport; Fri,
 19 Dec 2025 16:14:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000004C.mail.protection.outlook.com (10.167.16.137) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 16:14:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X+Tlg/uCOqnW8TMFSce5k3qNwkdGC9ZhsEAyN7Z3z/4uvHQh9VZNyAUVZTkCtL22WMOtdqzhz6ihUF7sf7cWYa6fxV7Dr+UZG6saYr0E0nqJUUPZsazrXUMBp30zeJAdeUuVEJigd1kG2osehzKp2/oYRtO98VkYNpBKH4rly3vjr8FIB5Ue7FmeoL2UXVwzvvIuPwfFCsPStX3W+zMbAivLw31YjOINzd9jhK0oZITSjg4XMmLOdbfko8ji+KQHN6o6WqGEOtwFkDfizLDAynqNbrsWKVtEqKZcKdZd9/g/StT7c1CYhaCDHPNV6yWMOpYxoUndPkI1OGqlSpxrsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cHt4x0S9NMScThiV7jrQcBA2d40ykb4Mzn3ReRecnvQ=;
 b=ejJEKIoMsAZ6buCVzN1SGKcDrCbSP0tyc84MNNsVirRhQa0UZqtg2lydIu51Xr00qiHq8Zs2yxsWPXURNMmybwwyvS/ugr8R/r3oGiJPfSLCmE7YOF70dBVn6wWedGKTh15TbXFz5IWJqWRBuoog6AfA4rMBGRLJ353HA3d3X6kDKdiyc7UX4kmtuHs+Cs4VoN0Ev8HlOBS8iWeRCL2FuOrBEncVNCKhCtDrlm7NcyM03wIcSu+t/O1MGUgQUGUphmFaYs86aH21ko+75OwMn/PEW5rSOHKX51WiyRJcqbqUZ6XNElXU0U3/1hetjqPvJRRGWGhUeFtzyE8HJEd2PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cHt4x0S9NMScThiV7jrQcBA2d40ykb4Mzn3ReRecnvQ=;
 b=sMShdz69TvpH/0jVUcAoT8UCDqfNLPdTvVBlFC3Jv6dtuxwleNormDc/hWj44e+HcXsA2Lv89t8YbfJzltMcLo+GtrJmO1HOZqfSc98cq/fJpdikA1XaUZ2o7mNLae6muGXUpVbIK4YAg46JejgZSNRPkxhHAFQmOmh2AF13tAg=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by DU0PR08MB9582.eurprd08.prod.outlook.com (2603:10a6:10:44a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 16:13:02 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 16:13:02 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH 17/17] arm64: Update PCI FDT generation for GICv5 ITS MSIs
Thread-Topic: [PATCH 17/17] arm64: Update PCI FDT generation for GICv5 ITS
 MSIs
Thread-Index: AQHccQJYGu6c0eScjE+v34oZtSwUeg==
Date: Fri, 19 Dec 2025 16:12:59 +0000
Message-ID: <20251219161240.1385034-18-sascha.bischoff@arm.com>
References: <20251219161240.1385034-1-sascha.bischoff@arm.com>
In-Reply-To: <20251219161240.1385034-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|DU0PR08MB9582:EE_|AMS1EPF0000004C:EE_|DB9PR08MB8314:EE_
X-MS-Office365-Filtering-Correlation-Id: 680bcfd9-ec2d-405f-65b2-08de3f19a1b0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?GnWPsUMVQ0+hOXM8bw0BnZq0hMvvm62oj+ZBsbk9Sxw4gbBwKYb20LPLRG?=
 =?iso-8859-1?Q?hkyGzb2FDS8K9lEeC8qh1BaHAZF9kP5S1qOC08uI3Es8XSjHqjI3r16xvB?=
 =?iso-8859-1?Q?ObgnSWI8PUNT1byHEA5BWeKbFccimO/KeoyUnZtTrXuORC+FVPAgvSkHTM?=
 =?iso-8859-1?Q?sy6sLO8slERHXdaRLAI/GW2At1IluTpdbwtxN0rcnSaXKfniaA0KVuhbZy?=
 =?iso-8859-1?Q?I0tjgUzHTdyRiLWIJ9d23fm44J9yUl7rWssCgOlidro+lwTCVzFJnX4Xs+?=
 =?iso-8859-1?Q?VxqnWlCUrL1vnSZP9zKNuQfwL2SkM9dBUfI4pZaELnY/+2HYdVQSyiXNWM?=
 =?iso-8859-1?Q?t//MVJkxwRlhl/wP11EDheA/7tMDvx0GFmJu5cz72S2h3oz9lQw8eiuRDD?=
 =?iso-8859-1?Q?/T8EhY6bZNbjgCqddqehNhZ51lOrGBtzPmy3T3iFZJM7UKPBCv7hu4kHsT?=
 =?iso-8859-1?Q?VXw7/qikCyBx7FgrRW14/674eMzPID05r03CNFR6mTxP9JMi4qQd21Zy0G?=
 =?iso-8859-1?Q?8cVJGn8h0i2zxo0wfEHh6iKBifHwawfuuPZs3yOUz+uVL22Qpme9+u8Jm1?=
 =?iso-8859-1?Q?6VqOpdeZXxBKaj3BWoFzj3CHSAj4auo4gimPBEmC0+X2eUB0sE5fC974Mc?=
 =?iso-8859-1?Q?Dx75OnA08/hMeEKtmoME4gzt0Q6XcJOpWlu7boG1Hf3t1emloT2URopqMI?=
 =?iso-8859-1?Q?1qi21ne7UfKmdMoziZYsUCcgd84CMKimP0xNUPwQIu8/GvQXfRcynurZKx?=
 =?iso-8859-1?Q?DFMAz56mBfMcI3/U4F73NJDhoXSNX7APy4l0NNYIa2jXHWIoYvjnd4dfYU?=
 =?iso-8859-1?Q?S1Y7VMOV4w7uWfcbLg6DFFEq/yqMUjxdsvYFhNKTF/uBXXiTbt8eziRceT?=
 =?iso-8859-1?Q?7UkMz0N8vn3YtbwLLPY+dOBN/qyan1JD2aeA4dbpj5IZ9T4GFatCdGXy39?=
 =?iso-8859-1?Q?okvB/wfuOVEozKewfEfQutpxq+J3gZpKlPcZ7bSfMrHh84BDGQX0Os/dug?=
 =?iso-8859-1?Q?5ioxg0JXMXi8tN9b0ftKByun8Z/okS3vfXtPNhUyJxeGHNoNGxxmESDPrO?=
 =?iso-8859-1?Q?4s4R4TKV0E9Ka31qZTSNsTrMaKOckrxoyZfVMwe89MuQC0h3723FBh1yeF?=
 =?iso-8859-1?Q?OhitwwIh1gfTUh1Rbt+i9cw6RUAA9REaApMpq67EdYXCINv7MvLf7AZ+/a?=
 =?iso-8859-1?Q?5iPr6/eNJHPOWa3PjE5XjGJMiZZpm6X+S11zy3ParIGL20O1ruiXz1hW4o?=
 =?iso-8859-1?Q?nVn8ekKI9qWvZk2qngrpWBkwyqj4z23DwGXE0k6m0wOLABn9ndggQxtxVu?=
 =?iso-8859-1?Q?j4PwPsF8cp0x6RPCHzbcKfVzqz4duUAWWGynCzUOeoKttOfx9Z2lagixzg?=
 =?iso-8859-1?Q?h3tx2h17UVFZUONvnBgvfb0IXNeuJLRCVrFFxjE3L6gnnLmH1D+GIwlv/Z?=
 =?iso-8859-1?Q?4gpl0vOZ3tSqyM6zbw9KYcUakbBF3VRKSJ0AzFHKt3u0BKjH3FqJHXq0Bt?=
 =?iso-8859-1?Q?VoMwAhZqUJPFhAknsvczE9HbvDrwKkbEoqzsr4ipZUTpLYqJgHVDcFWpuH?=
 =?iso-8859-1?Q?rAUjCE4f1NUFpOdoC4OL7B1uvJZS?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9582
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000004C.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0ac09d1d-df6b-4cec-76b5-08de3f197c66
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|35042699022|14060799003|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?ERfXvbNLS7bRhxKJYZwrsx0xsOflHfq1CniEgIVqvKj5kOw6qpl625dERV?=
 =?iso-8859-1?Q?a8JSQ7ZcX+o6uAQk9fik0CRmkIEfVqAbewe3tLaQPcIgiuupBAhMcPT+gX?=
 =?iso-8859-1?Q?sf5xQw2UQAICHJaHESlaSVdHmhhBzhmw5f4nOOinDq++hBlYSy/ekMltkK?=
 =?iso-8859-1?Q?y66ToNHUPSXue2kF0/VElQbO4NwsDhTmBEr8VYfNbih3DVDiP8l2BgIGZ7?=
 =?iso-8859-1?Q?pDSFI0d9VYvsxBucq36zJb+IAFngeglh+wSQa4z5b8PKg4gQCTYgtxBims?=
 =?iso-8859-1?Q?uCbK9RLXCwtFi2wsh1TBp3+Nh4L9FdHd51zM+0leDoXv6NoEGRj8UihF8a?=
 =?iso-8859-1?Q?m70jFOl4JbkuORsjCNTTUzvBDxUbtWmO6TX0+JkYQPunM7llbus9U5Dljx?=
 =?iso-8859-1?Q?x1c6qsc2HHsE0rezrbJL+uJc9Jz6JD4TwIjrf5m/wfF/XcswY2DfHakwlG?=
 =?iso-8859-1?Q?tosVCeHazJuEMj1N+Nu1GS1Ot0zjOfN/bSQRgmoFOPy6OSNG33N+SGSmg/?=
 =?iso-8859-1?Q?OUzwHCcbVzxCHGomy1X1FKHTfZ8vCioJd6H5bvvsdCQjfFEehrrk8OCIvs?=
 =?iso-8859-1?Q?/RP8GdzUtk16n8hfcW7Ghl0171D+zH9pd0aJiloimKkDhwsZwr81gYgYko?=
 =?iso-8859-1?Q?icWamS2/5x5tk7rBBgbZyEaPDR9qFHxuQIi9GrIyBLI0N02/A734ON+b4g?=
 =?iso-8859-1?Q?W2clZk0MMHPS1rZWpYz5ktatka7GkmptQ8AeWhG00BDA1AT5zff8tx7/39?=
 =?iso-8859-1?Q?HjkqHLIgYZdsOqi7K6OgFvI2m4W0Zjdfg0kdPOHTKUwKYemgyRwbRxOHpF?=
 =?iso-8859-1?Q?OfmFQH2uhROyHbDL1WuQOGNRDO4Cw/fzsD4k4GfUmDas/eeM7UFczIgjAg?=
 =?iso-8859-1?Q?Z7zEUYYVfj63Lr89n4dMM36DP0y7PwzLHBddF3mFY0W20usEkCWDDrKh5n?=
 =?iso-8859-1?Q?HvPy9YKLXM/1hRuBi/X3XlgT/5XZumH4YbKmzmrvqQGAdPJ2CsXpxALTjT?=
 =?iso-8859-1?Q?XTuvO3iEYpWQKjdMUowKP98joKbN71E3iLb3wYbxpfgP5shQRo0qB9Fbf/?=
 =?iso-8859-1?Q?BhUnM1BrANy8Lpzbcy5BYyiPyiyQ1qxlpZmZFFRhbjPa0VBcUjbOFa7Xf9?=
 =?iso-8859-1?Q?/QpQmMwUiyLovrD/tRrcNSuGMfBXJ+8aLF0Y8gZDzeaEpJ44h+HQZjrigV?=
 =?iso-8859-1?Q?uu3/vADo6Pu3PDe7h/r32laXYioGQY7iJw7K1X3PVFfgRhsmlhGldAnVrJ?=
 =?iso-8859-1?Q?Hzh+D7u9clnUbhTMRS3Z/M0Gn8Vs8OnCO9coMAlVhIMrPZ1BPnvIIH4n7k?=
 =?iso-8859-1?Q?KWc9+rAFTH7UmCNhIZSWgiy+L9YDFpn0r/sLOHdMmYIaQZI3buq0rdQZqA?=
 =?iso-8859-1?Q?fongYRPfoMg/B0euU1i+AcaY9HySpP7C9mKI0l7iByomk0PMmxmycsY1vo?=
 =?iso-8859-1?Q?AgINx4Xq9Z/TMbbgKo5JvnhHeYi+zva+UzSwn73E7Ea5BLdzlJantVoGyv?=
 =?iso-8859-1?Q?W56Rm3NlnGwpLnlh6kQUOphrk4wxSwHqRxpyu2+zLnffBW+Y/c9mlFZa6B?=
 =?iso-8859-1?Q?k2FKu3qgMtE2V+YuAFjM21iLPToHWefHqyPAwcgzpA5nCbYsSiCAGQh7R6?=
 =?iso-8859-1?Q?tS1nMtGhWo5Kw=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(35042699022)(14060799003)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 16:14:05.1626
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 680bcfd9-ec2d-405f-65b2-08de3f19a1b0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000004C.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8314

Now that GICv5's ITS is supported, point the MSI-generating devices to
PHANDLE_MSI for the GICv5 ITS config.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arm64/pci.c b/arm64/pci.c
index 79ca34e8..aacaf6b6 100644
--- a/arm64/pci.c
+++ b/arm64/pci.c
@@ -70,7 +70,8 @@ void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 	_FDT(fdt_property(fdt, "reg", &cfg_reg_prop, sizeof(cfg_reg_prop)));
 	_FDT(fdt_property(fdt, "ranges", ranges, sizeof(ranges)));
=20
-	if (irqchip =3D=3D IRQCHIP_GICV2M || irqchip =3D=3D IRQCHIP_GICV3_ITS)
+	if (irqchip =3D=3D IRQCHIP_GICV2M || irqchip =3D=3D IRQCHIP_GICV3_ITS ||
+	    irqchip =3D=3D IRQCHIP_GICV5_ITS)
 		_FDT(fdt_property_cell(fdt, "msi-parent", PHANDLE_MSI));
=20
 	/* Generate the interrupt map ... */
--=20
2.34.1

