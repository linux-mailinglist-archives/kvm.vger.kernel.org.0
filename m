Return-Path: <kvm+bounces-66393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 746BECD119E
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 18:19:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0575930AE79D
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:16:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDBAD382D42;
	Fri, 19 Dec 2025 16:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OlxjDLRK";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OlxjDLRK"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013050.outbound.protection.outlook.com [40.107.159.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC96337D52D
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 16:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.50
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766160852; cv=fail; b=Tq/Mv7y+ErfQqbhcIuPPHFMHwt1loaE6od/fuXju0E5BGR7kUIwK2tIBL4gq/usQ0x6wq9jzOjXM5LIkzMJdNByYikOXSi9AlS8Gwk0EMlZ6Dqou9wFYNiN7lF7HFfN03Nd7wwr+VNhiSqrRn1ITwe7HC/PPrsiWpY/ko1yOQSI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766160852; c=relaxed/simple;
	bh=f2hYsYkchU8bjG8gA6btLafquP71li79pcjC+nt9K20=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HnZuYFtufZBH6XciXja70qbU4ZN3B2zuQ4HCiPejYaEUTXTHuunMKYoyqRzR8hYP8Nbz/kKuf2Ysd/Ul2pX0Z9Ubv5LxJrU5N4EnW5hppYPG/4F0VYylXX2mMxOLCeInENpXX4usqV9q7tQg7PMm1IIAJEQoS3xl/TumzpVuNL0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OlxjDLRK; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OlxjDLRK; arc=fail smtp.client-ip=40.107.159.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Lx/ybblsZ3y2LnoLFUP4yZFym77TsOnZVR3Bnw1eFIZiNEbh177V0YE40swpwGFR2+L+QhzDvmIFg5CYKMwhJwy9oWBWhGZ4K4f9Uum19wD6jj9pwoVxdo0jLuef8VeTnV0/VgnYHlnhfsPUd1VM3cGIprKtmDRzgnXa+agCH5AR0bAtk52e8nqVkORaxqxiE33gTJP/eR++lh1ubkc5bsxjBRwLd2E3N7hSVNELrSe5ATT6lsKoZocRtnW81nv3ReHm7pnpSFwfythK/dpiTiHCu+eNb4q2lFQer4Yap0vY4Au38e3zv9HB7o53Kb/H55rMyIv4BDc2hwMT1FN1Nw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DWdRGIpvP/Fx57gKSxv6bcEUzq1PhkaDbmAHcCFPEoE=;
 b=ih080rbZIo1oakdSCFkKcZmYaYCxvtNnhqOkeIChBdzdL5VetCroSNhYODmklSJYxvfZ93OjNtusYaBxlv4FkwNOWB2pQKdqfOQydyMasfRDdeMqbWyd/uqpF4ngn6PGF/uvh7ruJNQXrGpDQgAKPo6SMankFcrdeOPvYnWAjS+oBVOUXxaam5QafUr1/618ShwKkhvwPEesJMXc9JS9QfFgMQ9aiorROj8udTNZ7Hurm+GQ6/urPdw5u6gRgkoLALJOtv1MtDKv2/GY2hLyjz8vo+JlnJAevpSTmKBnhZ1YuaHQq5df24tYJiJHwKsHJdcfuxzhn3HZIvq4FQ5Xyg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DWdRGIpvP/Fx57gKSxv6bcEUzq1PhkaDbmAHcCFPEoE=;
 b=OlxjDLRKmH3J5VjKmZLM2yeyZuQJki71bELigNhN7ZE5VouSh04VVD4dVPo/Pvs2oLe9CEhswLqHTQOd5+9gNLbA3DFPBvqEvk+ZV/HYPtpcex+0uqwu7Isln8CXePp0pjMS68EZW9rV1wkGoKC3cFD8rMy9VsTTNMfwxG6oPmU=
Received: from AS4P189CA0026.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5db::13)
 by AS8PR08MB7742.eurprd08.prod.outlook.com (2603:10a6:20b:50a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 16:14:05 +0000
Received: from AM4PEPF00027A5E.eurprd04.prod.outlook.com
 (2603:10a6:20b:5db:cafe::b2) by AS4P189CA0026.outlook.office365.com
 (2603:10a6:20b:5db::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.9 via Frontend Transport; Fri,
 19 Dec 2025 16:13:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A5E.mail.protection.outlook.com (10.167.16.72) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 16:14:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hRbJPtISzZO1B7UeEap/JveOOfYfjF+5wp33xlnaVPKqBOp8qRG/ub7ZmERpXTmRbfSfeQnziG2Ah6Of15ECSPFE3QB2CeNFzt6BjBYY4hMTOQ5x9KHkYjbynEhc6yV/Bt4XMlhus2YN6g4plwypjFXok9fYl7eoJImS5mENbI/6jJ8dT3F3YdAXwDfKA7LXxRwY7IlGHV7bf8ME3R2l8jAxg3qW8mRLXR2LA2Lo8P5t34m2vSX61+ysHYI/htgOr4EqS3Znw519Fq01c/z5BTXb2Du32OyJPO0c1Z/lj3HIAPbBqqXpTNgndaGcfIWU3fDGWmEGourBukaGq9Yx9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DWdRGIpvP/Fx57gKSxv6bcEUzq1PhkaDbmAHcCFPEoE=;
 b=Tlp+/5lFOUj9MwSTzh+zrSWHSsoYk//W2Rouf0VB+rw6eKkksZOjmqh3JDoRj6Y2X5BWqrWiUuKBocdwBg8ZYa4NlZD+x6NsehEjWRT+kRIhzWq7saut4LNjcq3gT8mwQdrXAwruKB87/IdlXcMjvrbBaYbYmkZgjmZaNAbGu6qT0NBxULvikt362cX/wALZ5+I8uDCDYGQQsUVxmanGGS0b+UT97AGLc0jsqvdG2ha78X+hRCYRB1kNtm9+ak7gY2MVY54ajQzpl5u7VB33/mO1ociWXk/ThFxBeiAfT34k9WhRMgHcsljPobLDQtzoeLe4A4Nnh0UYvD+nuNlnfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DWdRGIpvP/Fx57gKSxv6bcEUzq1PhkaDbmAHcCFPEoE=;
 b=OlxjDLRKmH3J5VjKmZLM2yeyZuQJki71bELigNhN7ZE5VouSh04VVD4dVPo/Pvs2oLe9CEhswLqHTQOd5+9gNLbA3DFPBvqEvk+ZV/HYPtpcex+0uqwu7Isln8CXePp0pjMS68EZW9rV1wkGoKC3cFD8rMy9VsTTNMfwxG6oPmU=
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
Subject: [PATCH 16/17] arm64: Add GICv5 ITS node to FDT
Thread-Topic: [PATCH 16/17] arm64: Add GICv5 ITS node to FDT
Thread-Index: AQHccQJYKwgvVDTbmkW39qS4asxmig==
Date: Fri, 19 Dec 2025 16:12:59 +0000
Message-ID: <20251219161240.1385034-17-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|DU0PR08MB9582:EE_|AM4PEPF00027A5E:EE_|AS8PR08MB7742:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b4ad014-5652-47f8-f36d-08de3f19a17e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?Jgcd8C0hVgC/g2vns9JVeEii6hpQm1KDPBkfzrXGLTdQPnrokZOmXnWRdR?=
 =?iso-8859-1?Q?OAU1BKX/JVsCcUsH2QQ/mXmHMLHF9kx5VH1RuGzJLZs7klmu+QfRCc18C/?=
 =?iso-8859-1?Q?j1hoDqNPmaUUd5CFIR4Q9B/SrIgBIvo7t65IfVzMWViy+rOKLPNHZf2D3H?=
 =?iso-8859-1?Q?tcayALnnQ6CgA40xGLmiGRIp2vkHlSFI+wZ9ukdeq2vbb+Cn4GY6WPMpbc?=
 =?iso-8859-1?Q?6JJZsXxypuc39t8xN5PfMRlM+vpnE1JWyzgvrbLHRbSBijXnASfFgDfjVt?=
 =?iso-8859-1?Q?09mW3msuVA3U8U2oF/n89q3OE2vKiPlpbIUoUpAkgPcptT86b0ftIOwvNE?=
 =?iso-8859-1?Q?q8Kp1cDHbl6CwYgOxZlPOGl4LZNQn+RO76nrzpSCK7rwVEQF5Is8Asyiiy?=
 =?iso-8859-1?Q?mwFYoZ+xEeBFb8d+sLOWsMXTlv3o8QTk1niZYPLyjDPmSKGMojAYYVa0Rb?=
 =?iso-8859-1?Q?A0nqxWKSUDxAZ6Vs8lR6jTPav+4SUY0iTeKsogoDrZkXaxS0t6wEPoZZyQ?=
 =?iso-8859-1?Q?YjoxYb2iJd/HLEM+c6DXmdxy3JJK6qiK7j9VtrRxnJxCTUYN/JOIW2uNPs?=
 =?iso-8859-1?Q?gS2QztE0s+48x4qJhCU02jrCPirtR/mHcIGyeRz3M4W/uQ0m43lK0MhuIV?=
 =?iso-8859-1?Q?0VBb/WzG1WuZa0jWfAN3fJch4NPx3bweeuiAG/8cXnGrlXs0KGlMfUc5SY?=
 =?iso-8859-1?Q?oCSR8UW/SxqagjMExS5HhaV0Xc817reH+wEj/3lEPNlfyDuGleea96G78z?=
 =?iso-8859-1?Q?bmzW4fMBfs2G8J+iIskC0ep6IYNuMgrezPQT1bIYrL0F2t+AHjid6wGvf5?=
 =?iso-8859-1?Q?zYMAHOtgKzDNLyDw7W1TSAu/PEb0KlSuXTe9PiuHVaz0ULMgLDI3Q7Cf15?=
 =?iso-8859-1?Q?smBLuEwT/9B2EuMZ5uulioDxehh084tirvTp74wGvS6OBRk2C978LGIXYi?=
 =?iso-8859-1?Q?N1/sqXUXHqd0PY02/Fs3CliERbTu3ZD7aN7qZ4bHvb/GvrVVhln3nWJrSO?=
 =?iso-8859-1?Q?8YvpaceOtTCVVdTUzRdscO4eTB1rpnjuhmdFlLisfPXcZyg5WgSrakQpuq?=
 =?iso-8859-1?Q?9zMbLlmek+Y6i3/vRuafux2A91OSEndrgr1m33zfsJrHYuutKznQE5Gbo7?=
 =?iso-8859-1?Q?pv6qm/06RxUNhWyo0tCNFxV3x83fvx6vhPilkVzmGD4+i+pWh8BWdK0uGo?=
 =?iso-8859-1?Q?J18IWCxZU7qzTIWbLfi2mFr6kx8t1WrqVoSa6U4oyIpD6mKjpjfhvm2qgn?=
 =?iso-8859-1?Q?kSCxNvN/u4MOagKJ6zWm4sdrcjlJHmVdk5n7zODEoHHSG+u+0N6MqDU7B3?=
 =?iso-8859-1?Q?iwD+0NpoQZUicK0pRbBkPjEAU3ckFoU3nid0uWnJ9YPLfHvnpq68gzk7KQ?=
 =?iso-8859-1?Q?wOcZ6bte0WHvsXD+WCe/Tm0YRT1Gga7o3+66JGgjeD6xrvptdddl5uA7uG?=
 =?iso-8859-1?Q?R8E91SKQoB/noScQDUsW0SOz9/AguGWoAC0NmyZSQeuUC2M8tmspeeam7g?=
 =?iso-8859-1?Q?EiTASJXNTNe9YQ/HMB/kY+fMRlVr5Ky+i0+r9iiPbf6skK/DnpfSW+wMC4?=
 =?iso-8859-1?Q?YvlJacl9hGR5eWuNrBIqwxrVCfW9?=
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
 AM4PEPF00027A5E.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	65082b23-cd81-426c-cc02-08de3f197c30
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|376014|36860700013|14060799003|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?qcb0HweODPYJJWis4Mj8BYqkHk0XvpIRhewP44sE0cE/cQlfBkIIDRwajE?=
 =?iso-8859-1?Q?wUg7DNg8PHoLwKoxJBclmaafvdStj9pqaLBIw5Z4CopNmBOp766cpimY69?=
 =?iso-8859-1?Q?4Tf0QBxazJ77GaTJ9tDXhyZHnpqyUrKidc6aY0jhSwAnEU2lLDdkKT5q/J?=
 =?iso-8859-1?Q?NvtxhU1rQEcMpnmUYrywPzwwXlaKiFEJaxT98pxrqdYCvJd8TjwwAg8ub2?=
 =?iso-8859-1?Q?QOrkiSWNRdxBDH3ni8EXV8xEUaNW6MgSzIT9A8y5/p8I359PhR0EOROoLm?=
 =?iso-8859-1?Q?sXWf+UcdLNi2tL3JYoc7PWJmrnKbUuPYGBOTtBdR/sOvyxYkrQTzBfkXw1?=
 =?iso-8859-1?Q?E3TX1b7dFWdiaVAuPHT2VASIa05vaSztfBe0dvBUsF4vJ6ijsSMFF1tfEA?=
 =?iso-8859-1?Q?XyYbQHecGkXV3jLv1B26Jyf8G89pDBqVLitfSqHMzBoZ54EL1FdpZm+b0w?=
 =?iso-8859-1?Q?5GUfowz7ddEfiYT0ZlsKOQZFvDYSVvTDZQXRHtO5VEjKzVZ+Kv7hRnpEN1?=
 =?iso-8859-1?Q?50mAwOzkQlQjsKWw6ZJVGtMmxzA93vqe+w+S7BOKrl8VnHaYW026nMUuqB?=
 =?iso-8859-1?Q?amxcgF07duoEMYlTjnyQA4QLX+JJt6tRwkpho+qSGpRBV98ofiOo7oWGWj?=
 =?iso-8859-1?Q?S7mIAWHI7A4CeGpfmgLt0c2kIDKAyydXJnqJWXr/6bYA3c/xXDYisNcZNX?=
 =?iso-8859-1?Q?WoUrMB70OyKpgE9dMQqnKMaFwatym3MXT4a45eDAf3PuRX1sfEcUR5FOUJ?=
 =?iso-8859-1?Q?nhvvWW1vKpicoCm1e/KLZ4n/F2dZ94Q4AJJ7eK4wFPipLqdVLkFUW9qP1X?=
 =?iso-8859-1?Q?pwtuAnA5G8JU3YXndTMpp1djdt7P3mAk4Lqgge4M5b8jb47cFXrFmwX776?=
 =?iso-8859-1?Q?rnWvk7+D9AoC+OVIJRhK1ckYwkg1EScGresh/Iu/MbHzMLDJxqU4MYF1r5?=
 =?iso-8859-1?Q?eeYsUwHre78aTinD433o4cpO98fP6TBDf5yl8oiR/0jrJ7mUon6tE/eiOz?=
 =?iso-8859-1?Q?tOjD6hRt6rkI5aTnASuMy2ivs1F5lWNeBP5v1kZjWqlFBS9G22vqJ6mBcr?=
 =?iso-8859-1?Q?zZq8HtclDA+K1wiTvfhMpHy5NrqdYogUYikLNnHuiBzDgbjE4pxCXfyjEb?=
 =?iso-8859-1?Q?WlLSJ2SSqowrQWr/qWvvbg8bPfDik5YXPxmzyHCoEvyLx81YdhQ6qOl/EQ?=
 =?iso-8859-1?Q?CiDGVhP3UgoDvF7ZbrH+DbJ03pmOxxaUBDZ5+cccRMz5SWgHeFkjPmFJYe?=
 =?iso-8859-1?Q?559oyFuT6tIk6ho64VWAqPgM3syB2rGhibcE9ld/ae3Fx8av26oJfLN1Mv?=
 =?iso-8859-1?Q?gl1qsog8/SB8YiVX9gTvI8cuZLirGWDEMwWlyZhS+YKMz4a1o1mv4eJpew?=
 =?iso-8859-1?Q?kAhKLNCncICRpx+pi/NaLNVvBXUh0a/cQtqJfWxsamtmShOzTvj3pr7pm/?=
 =?iso-8859-1?Q?elZBCbbC56GFYv9R068AQfV00NzovuDX3DHj1o8yehwktOBAFmPjImPe5g?=
 =?iso-8859-1?Q?2MVY+422WqzYvRBTKvzrvNEVA6rQz4cVGiu5gbencTgxqaS503YIyk3oyM?=
 =?iso-8859-1?Q?mk4wOROC/W0wlf9czfTzeQ/8C69Ev2O0uL1nSgY4VU1qq6ejQlBPXCGgBG?=
 =?iso-8859-1?Q?mFclZmViSIQmA=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(376014)(36860700013)(14060799003)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 16:14:04.8351
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b4ad014-5652-47f8-f36d-08de3f19a17e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A5E.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7742

Now that KVM supports the GICv5 ITS, add in the FDT to describe it to
the guest.

This ITS node is the MSI controller node used for MSIs, and hence MSIs
are now supported. It is marked with PHANDLE_MSI.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arm64/gic.c b/arm64/gic.c
index 45dd2dab..b32462a8 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -448,6 +448,7 @@ void gic__generate_fdt_nodes(void *fdt, enum irqchip_ty=
pe type, bool nested,
 		reg_prop[2] =3D cpu_to_fdt64(gic_redists_base);
 		reg_prop[3] =3D cpu_to_fdt64(gic_redists_size);
 		break;
+	case IRQCHIP_GICV5_ITS:
 	case IRQCHIP_GICV5:
 		return gic__generate_gicv5_fdt_nodes(fdt, type, nested, nr_cpus);
 	default:
@@ -495,6 +496,16 @@ static void gic__generate_gicv5_fdt_nodes(void *fdt, e=
num irqchip_type type,
 		cpu_to_fdt64(ARM_GICV5_IRS_SETLPI_SIZE)
 	};
=20
+	u64 its_config_reg_prop[] =3D {
+		cpu_to_fdt64(ARM_GICV5_ITS_CONFIG_BASE),
+		cpu_to_fdt64(ARM_GICV5_ITS_CONFIG_SIZE),
+	};
+
+	u64 its_trans_reg_prop[] =3D {
+		cpu_to_fdt64(ARM_GICV5_ITS_TRANSL_BASE),
+		cpu_to_fdt64(ARM_GICV5_ITS_TRANSL_SIZE)
+	};
+
 	_FDT(fdt_begin_node(fdt, "gicv5-cpuif"));
 	_FDT(fdt_property_string(fdt, "compatible", "arm,gic-v5"));
 	_FDT(fdt_property_cell(fdt, "#interrupt-cells", GIC_FDT_IRQ_NUM_CELLS));
@@ -527,6 +538,33 @@ static void gic__generate_gicv5_fdt_nodes(void *fdt, e=
num irqchip_type type,
 	_FDT(fdt_property(fdt, "cpus", cpus, sizeof(u32) * nr_cpus));
 	_FDT(fdt_property(fdt, "arm,iaffids", iaffids, sizeof(u16) * nr_cpus));
=20
+	if (type =3D=3D IRQCHIP_GICV5_ITS) {
+		/*
+		 * GICv5 ITS node
+		 */
+		snprintf(node_at_addr, 64, "gicv5-its@%lx", fdt64_to_cpu(its_config_reg_=
prop[0]));
+		_FDT(fdt_begin_node(fdt, node_at_addr));
+		_FDT(fdt_property_string(fdt, "compatible", "arm,gic-v5-its"));
+		_FDT(fdt_property_cell(fdt, "#address-cells", 2));
+		_FDT(fdt_property_cell(fdt, "#size-cells", 2));
+		_FDT(fdt_property(fdt, "ranges", NULL, 0));
+
+		_FDT(fdt_property(fdt, "reg", its_config_reg_prop, sizeof(its_config_reg=
_prop)));
+		_FDT(fdt_property_string(fdt, "reg-names", "ns-config"));
+
+		snprintf(node_at_addr, 64, "msi-controller@%lx", fdt64_to_cpu(its_trans_=
reg_prop[0]));
+		_FDT(fdt_begin_node(fdt, node_at_addr));
+		_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_MSI));
+		_FDT(fdt_property(fdt, "msi-controller", NULL, 0));
+
+		_FDT(fdt_property(fdt, "reg", its_trans_reg_prop, sizeof(its_trans_reg_p=
rop)));
+		_FDT(fdt_property_string(fdt, "reg-names", "ns-translate"));
+
+		_FDT(fdt_end_node(fdt)); // End of ITS msi-controller node
+
+		_FDT(fdt_end_node(fdt)); // End of ITS node
+	}
+
 	_FDT(fdt_end_node(fdt)); // End of IRS node
=20
 	_FDT(fdt_end_node(fdt)); // End of GIC node
--=20
2.34.1

