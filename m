Return-Path: <kvm+bounces-66354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 36128CD0A67
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:57:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 438AB30DF4B2
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 15:54:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFC5F363C58;
	Fri, 19 Dec 2025 15:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XT1bbD9r";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XT1bbD9r"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010070.outbound.protection.outlook.com [52.101.84.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC7E3375CB
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.70
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159631; cv=fail; b=so6FHlZMSS7kJ4iU6paerKF9Xd7P2U/rXsc+NGEDMXI9gNaQnAq9vmGMcagCACswX2xmowMvqEQDyVf9xg5mBOL1lPkjECV/kR+3V80N0xC8sjj0+YpBJnArK2jwWQGuTAfwWq2h/J1mAcMWKjTpy8uP/6wHkk0waEwuEn4g2D8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159631; c=relaxed/simple;
	bh=rXMTz+8LAhYlXoPKYpHEc5iQmC8zGelXZS5eKVw3F3I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kGoEz/y3n14OGVO16hl55D63vBc2CtgLZznojEDsjB1hvjOGJ68IdfhqVfFjdGnQL7hk+EWtsrEz69dUk9vfYtR3NZKcahCUPV/3G9sdlXjKTcZNDPHPPby7e+lIxROBYghxQ/MQQXn+0M54nwdNk+RunsForHEnb+57Q++p5O0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XT1bbD9r; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XT1bbD9r; arc=fail smtp.client-ip=52.101.84.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=GRqx7KiBjjBfzCM2Q/Kv0Z9h6wxqkHm6EURpENhTWkM/M+9baIC0957YsOcHaFALrZFjofcs8BKXJaKFr+TAENl6GS9RVcl8dKZZqn8aNRqMzNhjxwcmCyasauxUZ0lzJIUyPSeRQOMMRf5A65rH9yVSSsMm5qhTpksrYqxH86rx3aYucXGLHmHX5oXHkMU7W5A+D76qsbCtfGSs/sFQNx/qF6xQkd5ObecmWNQQ2arLeZ8sZMKqVvJ7auAnOszeCxlDyAwxgpvinKhl2scwrru5xgFpN6b4M6ZAgLdj7g0S+X/BzzIxhwCp6O7s9o/fMB/bSQvTOcI68vUnE97ulw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iarA8BFrAw4Rl4cXvdNoeUzhKBBABxNAdUcLdriiCUs=;
 b=FL25KMYjFwmS3+8eWbJi5FdudRkbRAxNuwvgHa5PPoBc5KSh5RkRXOBccx3BXY1wpEVwwuS/CHZxh/nnywGanBhgS2XV4a/6wgEmatsRCAVovvOmd+jy9yL+mAu0h/cx+UUNP2ts4q07jVDKgGPxkhK26wzjXV9ILJv5rrTcDsexZzVPutv9iJq8+BWkdZ1xwoZJcb89sIVVYLO9+9bqp37zN7CffM9rXMpZdbkhg3ML8depJ0qpKMEy64HknRdypiCf5DH1RBwD6RkqzoqGAewK4qwN5pX9rio+EMQSwWaYhv1ZTsrSxoqPlXayl2fpJ/9WTPod9aqQ19QesywJJg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iarA8BFrAw4Rl4cXvdNoeUzhKBBABxNAdUcLdriiCUs=;
 b=XT1bbD9rOG8dGp69Mjz/QkgJKoqsE91MES2SvASjmfM8JVNeWzdzsTCO8EUcEXdTxn+TA+1mu/6dYmCJ/fj+Wnrs6X9JM/p8yJ4g8VsRJLUfM+BkbUJAFkvh6Ko2iPMxRWXkjQ0t5nuhUsy93mRAalyElVC/QkNqT042nVtyo2A=
Received: from DB3PR08CA0021.eurprd08.prod.outlook.com (2603:10a6:8::34) by
 GV1PR08MB10641.eurprd08.prod.outlook.com (2603:10a6:150:16c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:53:42 +0000
Received: from DB1PEPF00039232.eurprd03.prod.outlook.com
 (2603:10a6:8:0:cafe::20) by DB3PR08CA0021.outlook.office365.com
 (2603:10a6:8::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.7 via Frontend Transport; Fri,
 19 Dec 2025 15:53:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00039232.mail.protection.outlook.com (10.167.8.105) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:53:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VcPpkNP8b43yWp1wrjRisxmmnIGcZVTZhWd0ocJRyFVRFS2vHEPBlsmcts3TI+FhJVENW5LDowYXR83vic4ogc/Ar0tVQ4wgxLXVmlEPxoG2eVEr/aNAv4D2CtK7zxE3POX7MSW+D8A7CKo69LnXT46wKy2qd6OkVZ+/JT724Gq0F9xZkKRr9NRzX1o2X8T6QpmOQCrcGFBoXtaL/CwqnoZnyePKb1uCPlQCQWMK3IkWwNUGc94T1hvWNYWlU4KYyRJaKGADiSII64mMtsiv3GZtK95tYo7rtgGYvE7aVMXdBtexJhibisQbgeH3ErVBuU3VMzX4Cm3gXEHJ7tl1CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iarA8BFrAw4Rl4cXvdNoeUzhKBBABxNAdUcLdriiCUs=;
 b=wKj1V4RPyoxYrH8BIQIXmnCyMoZ8NOy1zgy8vEQBOlePubknwI1ATLeZeI5VoAVT25kWuo3qA87F6bY9eQzdQbAKJVQ0ez79B1EJ76pO7dtuQRAZLCFjClVM54JjcVWDHXPknV95e8pLsA7GqnsMCfWMqFARavDhpy1BC0+9ljHE8GhAGEgcoLjTQP679n0BL9irzEEOBMjk99sF47dfRAep26HSlrnBRi6N+k2S4RQp1/u/PyQWLP9/akx0zD7U5B7MwG0Swxd7nbA0tU7cE6gFnr/X9XuqVV6B6MrBsMgF+UZ3XsbEqhnx5L/VwW0SMNLHYrZjM/0neMuTQKMb6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iarA8BFrAw4Rl4cXvdNoeUzhKBBABxNAdUcLdriiCUs=;
 b=XT1bbD9rOG8dGp69Mjz/QkgJKoqsE91MES2SvASjmfM8JVNeWzdzsTCO8EUcEXdTxn+TA+1mu/6dYmCJ/fj+Wnrs6X9JM/p8yJ4g8VsRJLUfM+BkbUJAFkvh6Ko2iPMxRWXkjQ0t5nuhUsy93mRAalyElVC/QkNqT042nVtyo2A=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PAVPR08MB9403.eurprd08.prod.outlook.com (2603:10a6:102:300::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:52:39 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:52:38 +0000
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
Subject: [PATCH v2 06/36] KVM: arm64: gic-v5: Add ARM_VGIC_V5 device to KVM
 headers
Thread-Topic: [PATCH v2 06/36] KVM: arm64: gic-v5: Add ARM_VGIC_V5 device to
 KVM headers
Thread-Index: AQHccP9/PQWd473+e0Ky9uNPCbfAtg==
Date: Fri, 19 Dec 2025 15:52:37 +0000
Message-ID: <20251219155222.1383109-7-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|PAVPR08MB9403:EE_|DB1PEPF00039232:EE_|GV1PR08MB10641:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a4b49aa-5b2f-4fd9-c0c0-08de3f16c8c6
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?fDL5SuQ2lBb9jsWuCwCQ8ZpwFTZqAO1xq0qFHri/46v87NAQvK8wwfmsdq?=
 =?iso-8859-1?Q?g0lWftLQXD+A/af9WSmkk8io2lFze9SNnKNhr0mhY5B8o/Ks5MlsGrQhR/?=
 =?iso-8859-1?Q?9hg1MqSm9Ea/OwsdVSRqFbPG5+IhrvWTHbLuPYW5zPTWqfi3sQHGmuhqFz?=
 =?iso-8859-1?Q?5Tz1whKkespNjyFDg5rG9lVFiJCrLlUKg2esC/794ycbYFwHjkS+48nc12?=
 =?iso-8859-1?Q?qsCuGTgk+MXaQE/wunGrW+gz6KMU30Iyd66cjQbv/aJ2BpBa/jfP3kimXz?=
 =?iso-8859-1?Q?JHhCR9qiOdlciy5gB3Ae1Jr5MIgcHgJBHTt80lQtAdL+sK6j36Q9pWf0lj?=
 =?iso-8859-1?Q?4evWv4F4jaO9uRNolEidkThxV8Tfc1QqVjM11VOgPh3I4NRMAl9NmnK31A?=
 =?iso-8859-1?Q?TsCs9PHDILZW+dFWvP0bS6n6hatXRKJ8SecxDOTqjcRLxkyP1vX2FS0V+g?=
 =?iso-8859-1?Q?tYGPPvcNHColSzpkwgUbsO/EY+PKvlflvWMnXU0BpNKT6WF7cPrgW3FBN+?=
 =?iso-8859-1?Q?mlkltRaq97rUrZxEaUzAUjIXQtY+YFDssRhyw9UK3CtNx0+9mKIel6Wdh/?=
 =?iso-8859-1?Q?n3i4IbMwU3CrH+sTFi0S7WJWIJ/JtOYf/ioyBLo9te7VYUGbLOhfndJ9Ot?=
 =?iso-8859-1?Q?NFGO6VFPo/L0MpeTIPOIZU5XZxK1O1uKUfehDVTLe7hFFiSgbwJvMKlhlq?=
 =?iso-8859-1?Q?sL5hhrUzWscdYemfquPxbimom5FlrtxEQU8BocUYfXQ96eEVCmj/ZvHzRE?=
 =?iso-8859-1?Q?v3ccBzslrUS6rWHI3V5EIyyIx8vIEtvkeFxsHNNq385S5/pEHG858Cc2IY?=
 =?iso-8859-1?Q?Yh/OLQ8KLSKzFXHhZZ+7e2/T91IPdubFRHahiqQVMexdKJbOCpvS9smxDc?=
 =?iso-8859-1?Q?Ft5HJAX4ANHiS9ITI75DNWX4nigeXqBrCXv5N4oZHpf4cSwcr9Fch1dTZH?=
 =?iso-8859-1?Q?oT27LF5I5g5Im+1An5i4VZI2Q1sGXZrCvb+kuF7InZ3sda9Hpx5mAdT6dK?=
 =?iso-8859-1?Q?fc/3uLeQjabQAEExrUkcrG0xp288GqAppUFyD8wILfANE+VTCMoe9sPQxw?=
 =?iso-8859-1?Q?df5qkXTSz3Y5f2gOOhpnZn0Eqpqs26C9sc8gQWQgT0UMeEXrIA3q3zHT/J?=
 =?iso-8859-1?Q?2Osr6/cJdrsiDWwofxlNifKMQizvSj051xWk6LY6pjGZrMpVsrJ7SPNtfm?=
 =?iso-8859-1?Q?jvqgDZQm3TYCnSXPtbh2iZ5NM2gLR57jdNlmhnM5o8PHZs5SFadP7UpS71?=
 =?iso-8859-1?Q?gPNHNHQrl8Rdl4Uclm9Bgagv5xBWvmGoZpj/AwQk/nacc/F2+rV/AYXx4C?=
 =?iso-8859-1?Q?VqdiZcypwuNrE8qhFSHcJfne5TcrhB8cFXu82gOd69mC90gOZZjQxBvNH/?=
 =?iso-8859-1?Q?AqoPgBI+4i2Jv+zo+Cm141RKJThxD4iSmvy6ozY2+GLSa2iqBCIUFD8m3m?=
 =?iso-8859-1?Q?yAWrugjkAmZku0O+lRkrdgbKIrGNDkeyQZqO4KknhG1VBzTUwR0AlP5UsY?=
 =?iso-8859-1?Q?4VHsf2Q2AdTnPUVoMGab8j4+guKei1bG5Cy3urIgI5ZtujzhzZYQCHCAQI?=
 =?iso-8859-1?Q?Sm7FuVNeYyHG8Qo0rMomGGO6+Z0E?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9403
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF00039232.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8bf5caab-bb0e-4830-a9c1-08de3f16a2f9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?TY+G4npPV6Ch8iOaqxjFzCIyO40KV0JcE4yEoBASFcIptxZXyeSWJjEaFP?=
 =?iso-8859-1?Q?lC307T+6cglG48hgUlMfeub9CZnV9soKgpvXmwT6mKefBS/7oPWuJAW7ZA?=
 =?iso-8859-1?Q?EaRNvhHmeowwmXiX/7EFBEdt9XQI86Xv+B03Kj9Bi0hDYb74TWk7NThun1?=
 =?iso-8859-1?Q?Tudt2sI0FEu6MV8xzJ3ZkWQUfUQjVnWC+P3WNfP3yD6NH/IVW3DVJ85Cgz?=
 =?iso-8859-1?Q?j5YBXXkqS2AvP0fvfxSBRUQ+yNZFrLC6xbiZaa0P8f5s0kyPAIp4kHLxr6?=
 =?iso-8859-1?Q?T3wnapSL6hwWNZSaAMwvoLYaUFY70CHTZDQIfU85JVNby1c3wlu6Cnhlmd?=
 =?iso-8859-1?Q?JyI+LJU/KuhRwr7SstElqW3sag5B4mcRaFlVHJ0w9GG6bVtlWRzqEWIRFv?=
 =?iso-8859-1?Q?xzN5fYrZdW4aaOfT5jBHJsby66vQ+SsomkwKMWYpqrSWy8k+QaMFiwDP6d?=
 =?iso-8859-1?Q?LHay0Iklpg0Xurd44D11UMGQzf8A34aMar10aspEI6Qqe5q/xmTrHkfTeQ?=
 =?iso-8859-1?Q?WMkxVF9eXtyPktjVgg6DSXhZ0+7e8dZkCHAGqV8htJNrH3K6qs/QG+2z11?=
 =?iso-8859-1?Q?8wZmW9SRAcSSu27ehW6niK5peSyDb5Q3qo6jPfdRvmH5W2n2B17rPoa8mH?=
 =?iso-8859-1?Q?sc9iznKqot4eovhN+CVL+laSjHS5Z/qQBOvYuX7+DBpmThQH+805Obyqsd?=
 =?iso-8859-1?Q?sNH1uXDjJWlQ1JI4MbStpMjxHoHvU+1DBYUtY38UQNuudwbFtA980N2tfg?=
 =?iso-8859-1?Q?HtnyDLCPVx3P2HFyBZwk8rHbL190E71qPb3QPo9APWMMa7mtMg3t2Dx92w?=
 =?iso-8859-1?Q?F3igyNgwbwPTj9uSu18k8cvNmsHnS5vTHKk4YL3WIB6VxD00SMJn2M+Xyk?=
 =?iso-8859-1?Q?DWcM47iGcWJu6Kufy55mWiNsxjZzB55SnO812aqg/RcryHp2heuDgOc+ff?=
 =?iso-8859-1?Q?V4Z+80DiZo9TU0LbM82bRV+YXrhnI3vcaLc0n+eItnGimA6IfafSECgp8F?=
 =?iso-8859-1?Q?e2cZ3kpQTxS05uQ0m9J8/GLzm0xYgwlL6ETn0gUuw/bDpaOUxh5+5WpmkW?=
 =?iso-8859-1?Q?sKFQZieM9G/lCIGapeFd9g5PN6Dx5ZNg9LUh4lwiJAqp46ODuppLdQ9UDq?=
 =?iso-8859-1?Q?0kLKAqpoi7ibPemxBoSjEaoz0rQvFdBdke7mKEEsMqhTb4pV89/6sX7mZa?=
 =?iso-8859-1?Q?sPzP1pKE3UIpk1cAmP3Lbao0GVosarKymt+XC1XkYKatsgkykTeljh3l7T?=
 =?iso-8859-1?Q?nD6TTi1kqLXrT+2SamVIy84Y132g4DOSzfTJ3/ShCy77j/lv5ovQqhkb6a?=
 =?iso-8859-1?Q?EMWY2ObptUMCyTXjWRkgQ8eTBZBNuA59OeadfexzJUtpXead7r5gH9057w?=
 =?iso-8859-1?Q?JFunS47uXaXMb5m4enK2ZPBtmcu6rpynayPrq+Vj38vkUdp/TR4aw064GG?=
 =?iso-8859-1?Q?BzPUHJDB0x7vNFqBxhpL7jAOMhxLASxvkTuDYYT3s0YoVFpNN+InZf59bn?=
 =?iso-8859-1?Q?hox0QKSB0DIbYwbCbPNcoyP0D0jc+q7FK4rYFcy9tYujYEFwsyuP3AKhih?=
 =?iso-8859-1?Q?tTO8l08T5LFpaEfSpCXEnfE8YZ2j2TPlMV21JIjopcxret0QSgzKoBzraF?=
 =?iso-8859-1?Q?P1n7pziG7XPU8=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:42.2487
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a4b49aa-5b2f-4fd9-c0c0-08de3f16c8c6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00039232.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10641

This is the base GICv5 device which is to be used with the
KVM_CREATE_DEVICE ioctl to create a GICv5-based vgic.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 include/uapi/linux/kvm.h       | 2 ++
 tools/include/uapi/linux/kvm.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index dddb781b0507d..f7dabbf17e1a7 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1209,6 +1209,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_LOONGARCH_EIOINTC	KVM_DEV_TYPE_LOONGARCH_EIOINTC
 	KVM_DEV_TYPE_LOONGARCH_PCHPIC,
 #define KVM_DEV_TYPE_LOONGARCH_PCHPIC	KVM_DEV_TYPE_LOONGARCH_PCHPIC
+	KVM_DEV_TYPE_ARM_VGIC_V5,
+#define KVM_DEV_TYPE_ARM_VGIC_V5	KVM_DEV_TYPE_ARM_VGIC_V5
=20
 	KVM_DEV_TYPE_MAX,
=20
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.=
h
index 52f6000ab0208..8303124973e2a 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1198,6 +1198,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_LOONGARCH_EIOINTC	KVM_DEV_TYPE_LOONGARCH_EIOINTC
 	KVM_DEV_TYPE_LOONGARCH_PCHPIC,
 #define KVM_DEV_TYPE_LOONGARCH_PCHPIC	KVM_DEV_TYPE_LOONGARCH_PCHPIC
+	KVM_DEV_TYPE_ARM_VGIC_V5,
+#define KVM_DEV_TYPE_ARM_VGIC_V5	KVM_DEV_TYPE_ARM_VGIC_V5
=20
 	KVM_DEV_TYPE_MAX,
=20
--=20
2.34.1

