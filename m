Return-Path: <kvm+bounces-66399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 22A12CD1183
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 18:17:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id EF7E13043401
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:16:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 752363845A3;
	Fri, 19 Dec 2025 16:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cE+4CC/1";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cE+4CC/1"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013002.outbound.protection.outlook.com [52.101.72.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DAC382BE3
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 16:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.2
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766160853; cv=fail; b=SjaUQVyA6Hhum8a6akzV17eih42b1xqc2KcFAjLNx//ddmVLtzHPuCbN3r6eCc081Za8BU1SDNjmiEHatoQeBOFK96lx3nHeEVhwtX1/2ye6hde+coaf33N0TRoiF7ueoF2mubP/5It9cuck2LaXLv7/ChDrD/tVfdeuGCNgmME=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766160853; c=relaxed/simple;
	bh=CV/xcYzCP6sOXCrXYwnAGe5KW/qi3mu3twSGgZSxRwg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Vy1e2R8VJQKjv08gf7iX+h5/oj5mCronG/qHEMtgtjwGvEbVZ18ZT6Vf26TTdtQIthOpG3PHIn8uKZAo3sawRG3pFkz+36GUARNjFp6roVRpe0QL3YUt23mAx+FK58KQXTNVWvyGpWlgzk9SpGrzM7P7rxJuYHt2vwYet1QNME8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cE+4CC/1; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cE+4CC/1; arc=fail smtp.client-ip=52.101.72.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ZDDlsyE2U7QLoDMObnTl/007BWZw+2OAS1AQeKPU+u/q+qDFU7BJnAK/pmg7RO6NvLzUsUlScnTpleyY5MOELfUYLBE7vzPV1FU+LJMdqa/yHfT5mClIe8rW/JF2chgfppb8kxrLwNbmqmKsPymJpzskHFv5QKbBh9JnBllfob4oTabAhPuB4BLPfSlZeMvTamB/q5GqWFT+nW1R2jnAbf+DAFVWDbkGcHLv8tBb8VFFEtIxKm4jSupHZ01PViVwolhngTjQ1HtUtXl3MYIX3qYlE0xLyQGpJRY6c4QPyLTse81IdbeE/Ek9eiJZs7QJFy+gZlAHXX30micKyZKsHg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ymlnpHWgmR9TKCN1ZvZGYVzjWW1NIi+rQ2FqsaCl/U=;
 b=Ijt2YdwGrbOQ2zLSnmMIi4u2RnneyrcdJEueOqUasrBNfyEbmhIDNRrMQwPDpblDpkpg8g//PK9tb4tJ/9UEDBMYODm4uyIROvC4/z6JEmNViP511I8F9TcWxgzSQxmxqej9LWeapqLNTJfxPdax4zkd4duQt4MA0F0slstfqmnUqCT3V4yqLHPjR9GaER13rXr0G8xDJ6Px9NPH6//LGVlWZuwXIBwfaegeS62vus64LetONp79YhXgiFsj4wi3b8e7YoqbD06/0LshMIAcPDqpr3nuafsujv6EKxmc5uThbNrf3zdQoczwEzr33s8ii8flXxjlbqP99ZpbPHACQg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ymlnpHWgmR9TKCN1ZvZGYVzjWW1NIi+rQ2FqsaCl/U=;
 b=cE+4CC/1I6EGT5NFmJfTO6l9loz9bUjw+6FvkpP5PZCqiGNZviwXk9740RFcVj6qPd9Rr7Q40J9+tuz1Q6uObPT3NCvF3zETwl8mLc7tbeVCwxwU1ncnh9+QPsHvPYARxHm6bxzc/4RJ/yWHjgA2FVLDnxkKjXwSsP7wi1X0inM=
Received: from DU7P194CA0014.EURP194.PROD.OUTLOOK.COM (2603:10a6:10:553::31)
 by PAVPR08MB9090.eurprd08.prod.outlook.com (2603:10a6:102:327::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 16:14:05 +0000
Received: from DB1PEPF000509EE.eurprd03.prod.outlook.com
 (2603:10a6:10:553:cafe::6d) by DU7P194CA0014.outlook.office365.com
 (2603:10a6:10:553::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.9 via Frontend Transport; Fri,
 19 Dec 2025 16:14:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509EE.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 16:14:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rPUdQUG/aPLcsXdF/HFYHguRUaLRiRcmFqqDPFAOXAqwamA3fo7F6kQSfeDaco3mS4I1ZbzNh9Oh4y2ob8o8nynAFhpLNmBltFgqQdVQuqe9Kge7tvwo50TLrI4dG+M+LLv1ubwFO43vJJ5rNbhkA79Zh7HarZELgJi76y6iRvwMfOGTqE+FjU0IhWTgHk4R6KWHlSMgkmpG4dozOl5pxqdommcWRfDofWBnWVbrCSHgLIGEKev2F5nAJWvtxs6x+M/gUVg8Gmziy56kEJmbsD8oyv1zLyYLKwG+CmdpF9XplFKMA0/4Ohot2/lkjf/l84KE+d2wGjbvQzJnLQ0cLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ymlnpHWgmR9TKCN1ZvZGYVzjWW1NIi+rQ2FqsaCl/U=;
 b=Q6NLe30cUZjUG0oXMielhX2Sr+fksCP9LBk5P/p+mvkH4AOJjKTDFiWZm9+VBCA1vIY3PusUjnDT4AHlVBHwlWLZxxbLDI74HEXsRdW9+lXGCTX/tLonhO5DCKLHMs2U8d1YnCV6+G6cWNLMD6/wVV9Fc45r6s1fbh6u7gECkeFkcCZu9Dj5JF1M3RoxUuX0PIkHSx4x7JAJFzowrqntZb40dXicFUHMI6v+m6Cb1W5KGAGr0KJZh7tRSRrOJ7wdgrXRuM0nk9dl9qtHRqAfXKUf/mo33WhWfn5zU182sIGoQMfmOsIMGCXvOxHZ5B2rcf5zz9lXMx/LAZht+PtQog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ymlnpHWgmR9TKCN1ZvZGYVzjWW1NIi+rQ2FqsaCl/U=;
 b=cE+4CC/1I6EGT5NFmJfTO6l9loz9bUjw+6FvkpP5PZCqiGNZviwXk9740RFcVj6qPd9Rr7Q40J9+tuz1Q6uObPT3NCvF3zETwl8mLc7tbeVCwxwU1ncnh9+QPsHvPYARxHm6bxzc/4RJ/yWHjgA2FVLDnxkKjXwSsP7wi1X0inM=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by DU0PR08MB9582.eurprd08.prod.outlook.com (2603:10a6:10:44a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 16:13:00 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 16:13:00 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH 13/17] arm64: Update generic FDT interrupt desc generator for
 GICv5
Thread-Topic: [PATCH 13/17] arm64: Update generic FDT interrupt desc generator
 for GICv5
Thread-Index: AQHccQJXrXsISbYPgkeh4tQb+mK4KA==
Date: Fri, 19 Dec 2025 16:12:58 +0000
Message-ID: <20251219161240.1385034-14-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|DU0PR08MB9582:EE_|DB1PEPF000509EE:EE_|PAVPR08MB9090:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a843f4a-6793-427f-8df5-08de3f19a077
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?PwIkOGs/g2INx5bwb6M29rT9cXCfl8oNufAxayD80vO5fUKns87v4Mgo/T?=
 =?iso-8859-1?Q?krrBIDpWrYYUo1d+r4+lcZBSSgtIlNihx3b1nJb4kzjvI/hBfeyXDIIKLG?=
 =?iso-8859-1?Q?4A8dkZx31xawjQOi3S0yJDIGNfD4mmE8bVAPRpNmtAftZifxZ1ghD8e0G+?=
 =?iso-8859-1?Q?uBEHwVxmPEs9hRoURSsVPN27o4H0uGyMLGofkJBohV58Nl0hdAg0X/g+WS?=
 =?iso-8859-1?Q?/0TXL8X6ypMLBNL9OoU0TsNQUI9mgRlmCsJYhmPgrKoS5MEW/dLalRz1v1?=
 =?iso-8859-1?Q?BlXtCiuwrKa6hFbNPfmTUZALqybxKMwm9wBYoqZTmQevCYiy34+5+SXYp2?=
 =?iso-8859-1?Q?yOXDdLRmZsmkM8AHGj/vtmvSG+eAPN3sb4jZ1wAs/waRDYUhaWUyyNyI4k?=
 =?iso-8859-1?Q?rAiVg0FQEIS5NGIk04+Yl85bHjIjSgxgJJFduIl9vXN9maLocz1wgy6teI?=
 =?iso-8859-1?Q?/2Qfm6/W+/qhFd5lEOj+yNrwAGUbr8lEHiDvJtuvGKx53U/DtCQvaLWmo3?=
 =?iso-8859-1?Q?rmGSEVhhsrWHmbDiz6oFsE78z6wKky2MAMhkPjAPRP3+2/LE+HHDQfya/8?=
 =?iso-8859-1?Q?tBdcBYV1VvawK173a9aUgFLoRAqSD6Wa47u17cmf3uFGzZm1QP6IfttXoK?=
 =?iso-8859-1?Q?DaYHZnO3nERktrsfykmEh6e4Yvntb/rR7qqX8Sryi7MKaeRRRKoAthFMzt?=
 =?iso-8859-1?Q?6QKq6je06d5qnvBKTcwL7/HaRYR/UZzRoVi3orSyLFVqHh1J6N2QqcVABO?=
 =?iso-8859-1?Q?7/w/VLvkHsode6g0L1HCHAnKDXqTK3S0CJylLKQAqLJFZsCBAl/CZM43zl?=
 =?iso-8859-1?Q?ibED5Y44N5+tCl2I7sEjfL4yttbM7KXPgBE0hUyOAHgL7JQpD5dnE7Qr17?=
 =?iso-8859-1?Q?89EWAtz1SYoixiA4pTwGHtvRAzbQ69vnk+gEblnvnz6uk9z5mEw5GGaP0D?=
 =?iso-8859-1?Q?qTLyVxDvfET/culmyEoa9RlCarrE30KcNfPauyN0DTONVKoyreTPhNh5mR?=
 =?iso-8859-1?Q?QjpBngYNs/6rm9Z/PNeXC0K1Ym00WExY/IAYBYpUxidYZcgNo0dyCGlw8u?=
 =?iso-8859-1?Q?OkbrLlqO8+8mOzDDVswVG/J2d1o3k9nq7+zb7nV9x+bq0Xv9QXAh4lvHaa?=
 =?iso-8859-1?Q?VwmWV2hHhnWG3q1CRGRcVH8ERZXWcRHYsvXAGpAN7gmkp4qTDsim3fFl7l?=
 =?iso-8859-1?Q?tDRW6OdpUWbyc8WRw5WL+A/e/a6dx9kKpQGPnvOkqzOKdXwItidD4pSH/h?=
 =?iso-8859-1?Q?IKdkhY2A+iA4iURX06tAJ9rxxKX24M2HjCzKuu/vHyibH4Mw/qof5jQfkc?=
 =?iso-8859-1?Q?QcZvvTSaCH1vz3B3S80Cbea+JEbPKT5LOFrB4f+PKKgde9DD+Wot4Zd5wB?=
 =?iso-8859-1?Q?8nBx9FyREE1kgRknwtCo2bYiba5hoHdiZsImvZ9zWn4MZcP8A0KyRSO5VJ?=
 =?iso-8859-1?Q?mJO1ZLwcC9jMkpLy7vTRiHMxaRCQjS72aDfd7IzRH+l94evT3sxVwiOYxD?=
 =?iso-8859-1?Q?4VEXCmdqLjk/NK6rv0witeSe9LxaBluuc61rf7AY/nvQHdFyUm/ReNJ8zp?=
 =?iso-8859-1?Q?E9emCkPaMM8EPwAl1065sVifNR+Z?=
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
 DB1PEPF000509EE.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9125fdd8-aaa0-4f0e-627d-08de3f197b1e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?ShqcCZYAyBuMh6UtIKGaBlW3SY2qMRsIgr7+kVAHawlgRxHJcA7T9yiBva?=
 =?iso-8859-1?Q?OY+3z243y9V2ece7cEL4znbMauIk+TAc5G2lGnp9be54leAUvT9oTHldar?=
 =?iso-8859-1?Q?R7rrgW00+iDgPci5200+JvMU/l2coNqVckIeDL6RMiXxdT7dAeaE4dGs3G?=
 =?iso-8859-1?Q?Ikp3cgvopXnmuQmpr0a74YAloYmfKmhwIG5kwqm4qsEht4DrB0UKiVkI6y?=
 =?iso-8859-1?Q?Je7mXFQqQ5tSku4hm9GX9Slno+GNJx3yEeQs/uLFFBk/uU4hosQKGNb8lu?=
 =?iso-8859-1?Q?FA/olw0UHMMT4b2CK3oCJK9edXEIhTZgqwYquM2BpGPigV0fitO4v6juzA?=
 =?iso-8859-1?Q?Jv3s7y+oPA64nICE8J6UX06rjdU+9McmSpNsuDHKUY2evUQxE/uNrLC/yu?=
 =?iso-8859-1?Q?bmWW7c+BEPaoX5kESdNVyZ8TitVZ22nyn8HTbIMRS25KkdQBkaBhk3Q1GE?=
 =?iso-8859-1?Q?wFd1hAK0dj76IFTOx+djcwxrlBAWr0bkMZI6CaFheJfXQYwbIcXgNiqRC5?=
 =?iso-8859-1?Q?uf3EcQze/yQ9dT5oLqcgAidLadb1oY0QKnQ2D4N3HdU4hJ7yrxNlzSde4l?=
 =?iso-8859-1?Q?4hajasPa7wtcHM4axscwTAmDivcjmr/Xg8on51J9QebAEuNr3KsMMKu4MM?=
 =?iso-8859-1?Q?tOFUZFrZb2BDhz7X9m1+lSvOv73u1NUiiqH25jb9AfKsBVs7xxgbCFyC7W?=
 =?iso-8859-1?Q?tKVGUZ17DOtzanxkT053bSvXuypnHdUfY4bz8DX9o+niXB5Cd4kypFNbmI?=
 =?iso-8859-1?Q?AG0clvinSvaktHzfXH8IxM2VJgsYg2NcRt4wERrjcK4gzVv39ftUpnzmct?=
 =?iso-8859-1?Q?PPr2kGz6GMujvzP9UwyTGJgdPDW0v3uYlmpDnVVCsyNji9b2EwNRDQmzsh?=
 =?iso-8859-1?Q?mmQA/SxQZLaZYPkC+CStvNzNbd8gsXF1SNZruDxDjOoMidFjza5VyZvLk1?=
 =?iso-8859-1?Q?4aDOyPkFsFvwzRWpRyjIpwfyZ4oRcvpgoA2+s4VR6hhyJFC1x1/hN9I1s+?=
 =?iso-8859-1?Q?5CHp9f+b6RPjwxqWHbLk9V//goE8KNQptJMzLhc0Hhw320ZZqbJnzfdMj/?=
 =?iso-8859-1?Q?oWGQugGv/qedAeBxyBEhyAZrvCRTZzXfsjUCGQB8CB2CyYB5CKhophiMqL?=
 =?iso-8859-1?Q?MBq8z5EXS8vtAOQKAFXzByO8Mh/0AEEm3cxQMm0A+tntgm6dfduGk1e3GP?=
 =?iso-8859-1?Q?l8dyCUBtPa/d0i24f9vl+7nTZXchPXH18TWGvJ4xZBviQwy81p4KVehtpa?=
 =?iso-8859-1?Q?VySdaph2axBmzsFeuGuwkXrU7aKUNXJPsTsrxq/QR7a9rbE8SHrR2Hvaxw?=
 =?iso-8859-1?Q?nzCGLtlgUmG+eUit+19oqsgobpEK6lo4fFXePJt4GbqwevIXN2TS6sTT/e?=
 =?iso-8859-1?Q?yUb/zxVYAgsFF1zFmgRnmp2CtN/6BHSyKS/ZqKoLzaqlD0dvMojt3OUYU6?=
 =?iso-8859-1?Q?sohWI1BDru0S59/MMbUaymyHwnaQ52MeXXFUQvtJJxrwDJxoYrTC7/uRTw?=
 =?iso-8859-1?Q?7ga/TrPa4l26sECveRxcp36Ox0sSttSZnnEWEWLr/IPfSNHO1Xi7/Wmp92?=
 =?iso-8859-1?Q?XYMg76Y79oe95Z1wPNk1xA61JmIIpAIC2Htpu8crIe+ZwETdWewr18SqFq?=
 =?iso-8859-1?Q?jcqMCXmtEXpEU=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 16:14:03.1090
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a843f4a-6793-427f-8df5-08de3f19a077
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509EE.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9090

Add support for generating SPI interupt defs that match either GICv5,
or legacy GICs. This checks if the GIC is v5 or not, and generates
either a GICv2/v3-compatible entry, or one that is
GICv5-compatible. This ensures that devices using this interface (RTC,
Virtio MMIO) don't need to be aware that a GICv5 irqchip is being
used, and are able to directly generate the correct FDT entries.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/fdt.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/arm64/fdt.c b/arm64/fdt.c
index 44361e6b..07556dff 100644
--- a/arm64/fdt.c
+++ b/arm64/fdt.c
@@ -65,11 +65,20 @@ static void generate_cpu_nodes(void *fdt, struct kvm *k=
vm)
=20
 static void generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type)
 {
-	u32 irq_prop[] =3D {
-		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_SPI),
-		cpu_to_fdt32(irq - GIC_SPI_IRQ_BASE),
-		cpu_to_fdt32(irq_type)
-	};
+	u32 irq_prop[3];
+	u32 type, offset;
+
+	if (gic__is_v5()) {
+		type =3D GICV5_FDT_IRQ_TYPE_SPI;
+		offset =3D 0;
+	} else {
+		type =3D GIC_FDT_IRQ_TYPE_SPI;
+		offset =3D -GIC_SPI_IRQ_BASE;
+	}
+
+	irq_prop[0] =3D cpu_to_fdt32(type);
+	irq_prop[1] =3D cpu_to_fdt32(irq + offset);
+	irq_prop[2] =3D cpu_to_fdt32(irq_type);
=20
 	_FDT(fdt_property(fdt, "interrupts", irq_prop, sizeof(irq_prop)));
 }
--=20
2.34.1

