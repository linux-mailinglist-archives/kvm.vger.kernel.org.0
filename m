Return-Path: <kvm+bounces-68381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 92A29D38460
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 19:32:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9D6283173C31
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:28:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 082743A0E9A;
	Fri, 16 Jan 2026 18:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Hsd7K2P8";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Hsd7K2P8"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011032.outbound.protection.outlook.com [40.107.130.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EADF346FAD
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 18:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.32
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588112; cv=fail; b=EH2lEpg8coS0Ym0Q1ojrfQJBhXgvdpRXmy4uNnyZEJTxm2tphhKr5hfvBqJQbOWinwA9v1e9jN8C7ZAp2QDAo5EcQgxqS9d1OaXAsgsYLDLp3vTXYZxMMBieVNpZ2XXqBzeqMsQ5Uhtyu4e00sNNAtSwjY+4d6maZvYovSf/MSg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588112; c=relaxed/simple;
	bh=C7jbCGht73qnsm+qa1lVtgc1AM+9il2GebgyddMBBOk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gCZoA76mXKthEMwQFua2SfLzW8FUNPFIOKYWi14g8UWwOBqz2weo+PNzB0RFkk0kT1KF7oQFCT08AoQXsS4d+ZxUuHhAPSYGFxdxM+km8vXHN6CZLePl4PiMV6jP8FISUh7ba6CjB1ueDYk/5qcBNynz3zVsLQzbpgfPWkFiumM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Hsd7K2P8; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Hsd7K2P8; arc=fail smtp.client-ip=40.107.130.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ayKQKNrkpYnJ6LMFxFo4dESmJc527b+UaM1BSg2IjK5WUY7dK9x1PGzRHwtzWGz/AeM7bAM5kfslUywcvHWStx648AML0hL7IRPYUZoXndGWdQF2vP6Dqtk0WVbuMUyeaQSpoUvSweqeqZY4HnGw8FxEQ1t9/hiRoIyzZOFW7QoUJ2fCkIMAtPp6y/b8gkTleb7ZDAECr6i277qj5j1CPuZ/mqfYFQ3WxjYfDfJpXifBo1DyPTEJcfZfnZ6NZxDNcAE1MaNhHjf4plbV3tCh8Vq0RwnJRWF/9bLU40Iwnk1umKirMPulgalebkVdtR4p//eEPnZqiXFgnrN8u/RvMQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xhbbQUgMMfVJ2TEKjqcbIR3ygPtkontFpO2osQOn9TA=;
 b=esXqWpKvoiRAX/g0BxK07f4zvNvn7W92wQLRxsTNFSYMY+nKB5mej7YbOwAwf3xCdKAHxxWiFWn30N4FhEzPri281iSeTtJ05zgcS7LCRjxBFmBhpIXbvFUhHQoiRWJBAfzR5uj7v39dvgWs4Qx5EylcJSQUdQs0Lp6BoFlOVQ6Eq7V2GXMKLS++gEoqztCA0N+CHMrPFl40M0gWxQbyDvLsMPNWm++QpyDMGTcf+FIBrM23UXDPIq5o3YpfRt5G73DnUV+Gs/PQvuC1oFZuq57FEpLL9Yz85c6iidC80UBeB03nU2wH3YPbzZ1lp/vc9eWyovPOX+vN2C10tKQqOA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xhbbQUgMMfVJ2TEKjqcbIR3ygPtkontFpO2osQOn9TA=;
 b=Hsd7K2P8kINRkS6Nz1CEh/2qY7mkfIrg47iaAHip1L2Nn1nCp/+0OnD20lcUllsdz3IAG+Mxj/T14aXIgETcWTVm+v4WPBHSZuPcWVx1GjNqdW7KrZqpD0Q+ASL0bNPyBpyVKIt2DHsUrAuNRHTrhKS1nxsemydJ1fgdR5ulxlY=
Received: from AS4P189CA0032.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5dd::18)
 by DU2PR08MB7325.eurprd08.prod.outlook.com (2603:10a6:10:2e4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 18:28:26 +0000
Received: from AM2PEPF0001C70F.eurprd05.prod.outlook.com
 (2603:10a6:20b:5dd:cafe::c2) by AS4P189CA0032.outlook.office365.com
 (2603:10a6:20b:5dd::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.8 via Frontend Transport; Fri,
 16 Jan 2026 18:28:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C70F.mail.protection.outlook.com (10.167.16.203) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.4
 via Frontend Transport; Fri, 16 Jan 2026 18:28:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hXAWVXDXyOrqAhYKhWU3zEClnLWlp1CU1RWJrk2FcG+BSx8qLBg9EByMdj3GK1DqMhLhr1Wi2p1E/rupo4/n2lU6Cl/SrRrQMSeF6c7+mYLhHr1PSPBLzxootYyCWHWc4UjfFltTRuBctU5NYqvTUVUEd5hPrQ3QWPUUq1pg+Ff0dma46vihVz5rO66eyBRfcmd6jCmNBySYlIgXEuonzY+LLtsEkztBLFnphmKRXSDJH4gBqD1qax6tt/QVdDqt3x6tKSRz48Ry1dxOqYfniaUdkC1ax6z7+PjMGh/H74a07UDVg8v/EdiGzXsPrHgIlgf0O7ayZn5ilrn+U9I2rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xhbbQUgMMfVJ2TEKjqcbIR3ygPtkontFpO2osQOn9TA=;
 b=QnMMHnZbVaNlESesEGCNIzObzN2dCr/3b988F4h+7DGQxCLyoh9tRBO72cFbIQ8OFPNWc10fRZENaegyXx8FL/nWhJGimckiwU0pMHDhgYzF1YrnjqEbc8HbI8fmnkwlTIV+TU1GW90ep3KJG2lG1Qu4WaXpVHMON6ZreRH3lz7MvqGTlpQG3ApjnroPNdqqcyLvLaQzPf4PdEdUQz+6kVIh2tveRwUgpCnPF7FntvffYX7vXZTls+fkWlHPlUiZHRN0/JLTOum2qx9+5YUlWuKEwsd6g+Kb1umpkbb2PrPjekmsapOD473Dk2iIZw+aNQaGud/zMdaxGH2UOG2ZQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xhbbQUgMMfVJ2TEKjqcbIR3ygPtkontFpO2osQOn9TA=;
 b=Hsd7K2P8kINRkS6Nz1CEh/2qY7mkfIrg47iaAHip1L2Nn1nCp/+0OnD20lcUllsdz3IAG+Mxj/T14aXIgETcWTVm+v4WPBHSZuPcWVx1GjNqdW7KrZqpD0Q+ASL0bNPyBpyVKIt2DHsUrAuNRHTrhKS1nxsemydJ1fgdR5ulxlY=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by VE1PR08MB5616.eurprd08.prod.outlook.com (2603:10a6:800:1a1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Fri, 16 Jan
 2026 18:27:23 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 18:27:23 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH kvmtool v2 14/17] arm64: Bump PCI FDT code for GICv5
Thread-Topic: [PATCH kvmtool v2 14/17] arm64: Bump PCI FDT code for GICv5
Thread-Index: AQHchxXC+0T8D6+N+Um6ASvaZrg1+A==
Date: Fri, 16 Jan 2026 18:27:23 +0000
Message-ID: <20260116182606.61856-15-sascha.bischoff@arm.com>
References: <20260116182606.61856-1-sascha.bischoff@arm.com>
In-Reply-To: <20260116182606.61856-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|VE1PR08MB5616:EE_|AM2PEPF0001C70F:EE_|DU2PR08MB7325:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d015211-cf04-44ee-acb0-08de552d09bc
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?2vSydxOGb1IdtK2ejdbjPnAyMZ1cANCnhhdQoIiCKzjDG1ErK36OqKybKT?=
 =?iso-8859-1?Q?xkqOiGu8um7F5DpOlNt63ejSBqZ5JECFYfg3lC+TJ2aQaqZJUbBMoRiU4G?=
 =?iso-8859-1?Q?MSDX0lGv3HgUpIjihKQn6szAfZOXAXzYpL+xDWqIuxGqm2pcHpXe6G5vQv?=
 =?iso-8859-1?Q?Wscya8op6vry+YVEmlJV6dZx8iAOhZxx5ZNTBiMF6cqWw4jGhpWoZg4RMv?=
 =?iso-8859-1?Q?gb9KiYiDpuH8jzQYshFp+sBWI7W5wR12aEQ7lLCX7An24I+qh6gbXASqIu?=
 =?iso-8859-1?Q?Z48/d+AtMlVPy5isxy1U3AXuj3zrOCeHP1xvFT0OUXvzB+roOk7GPNdEKX?=
 =?iso-8859-1?Q?eWGWh6hgCOniH+6jtwnINXA614WL2TSHp4fS+Lmmnq5s61OrtTHEnHWut2?=
 =?iso-8859-1?Q?b+MtdX9TvzyF4pA7MIwgoeMV0SKGlJsQAUCcnMRr+1OP64R+9aYMo/mnoI?=
 =?iso-8859-1?Q?26O6/a78csCEPrZH8JngcFVLisl3GycYioWodrZZcgLw2QOAKJkM+dCz2J?=
 =?iso-8859-1?Q?2x5mPmYTrl9599jQE3+/qtngEI01JxnEI7tjw89vMywvqXkW3g1Nuqeea3?=
 =?iso-8859-1?Q?JP0paeKihv56nJeoyG+S6BiG22tBJnWOs+XLvqc4HrzEabd8HwmdPB8rLn?=
 =?iso-8859-1?Q?VDljqBSCFjLuTlNst9oYXk0O/W+x1u4E87KZpbCOQmZr5LLR0OKQYD30XG?=
 =?iso-8859-1?Q?2c1LSQFHqKh25EFMOnHvKSXjBgLv4BucsqlUKJ0E5Y7elnHDni//iOhf9w?=
 =?iso-8859-1?Q?dTijywOpbuN1v2ev5dnWnZzP45lW4uaCIy4UuSQGNJIyM98FeIeELPkbcp?=
 =?iso-8859-1?Q?pyieaMcPUoyj1LLZ3tYrj5op75m10lBrvsgkJ9t/wCelSiHqNAg8oyoAa1?=
 =?iso-8859-1?Q?xfHtNAt5BbinoPiBoaLMqUQ+nxreheXbeW34WftiLq9WSWn397w6n86Z3z?=
 =?iso-8859-1?Q?Qnh62Imvk6p2mq+pUjPwOBCwPGXtntuMEOyIlHu+AhbZS8jH9TV+uPZ84I?=
 =?iso-8859-1?Q?JysFztbmM21iwbVzQWMnAjra3fw2ebOK8TfL7NoAGc35FWfk6ff3ptkKkU?=
 =?iso-8859-1?Q?GvVA7KMp/Ec7FRLJPOXitSJJhpdAKt0bpMsBjIIDo89G2FLe4MYiK8MHxd?=
 =?iso-8859-1?Q?ISZM+uoXhl8XbdC2OUWwvWkHYj/P0bXVgJFFJ2d3bKxGOTwT8R7k5T+/sx?=
 =?iso-8859-1?Q?rMYx8DIZPYzERe7p4anDsaWcivpqgDKTPPEjbgFrVRQ/XnL0EkXqjv9en0?=
 =?iso-8859-1?Q?gjOh28dTq9zPrJtUQloQ0LEA4mllUi2sKh17Gxxx+3R/HfjoQZO6VkerI9?=
 =?iso-8859-1?Q?5adLB+98i0By5LV4ssCDq2Iy3aGq8l0/9VVZxz+D/HwF11R8vV6WI3PLnH?=
 =?iso-8859-1?Q?xw97ILAnCby5F1qcKWjQwE9NtOEAZ5E+pWTWo9mTYH+sVVDVa5E75chdxU?=
 =?iso-8859-1?Q?9ngnkaoEtSWyLS6dnQU7KcGizfvRtNecvOmKmth4ePs2XHqojSoXUFZrKL?=
 =?iso-8859-1?Q?L+mYiNG9CxOkka4ekcLKIl0LdCHpkgZRiu1nhUSfwGIQn0Ghbwtj3ra0Y8?=
 =?iso-8859-1?Q?XxzfGeDGyP6pmd/7Z3ZVt5fIceUyMZK98DYmz0Sr33ZuzKptugvkUR6L/B?=
 =?iso-8859-1?Q?7bUYsdukbjTCVUBrlPQLjiowAVFZ2FA3Yw/MWgbsFXwMNSdlieV2dbVOps?=
 =?iso-8859-1?Q?qoPMWsZNneXPlYnOeMo=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5616
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C70F.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4a9b2635-f2cc-4249-1419-08de552ce4b8
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|1800799024|376014|36860700013|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?/PcaQ661IbzdwaNjsWsH/MzCJlfJMvI0HIwA1yXocsTFI02+slOp34nE6f?=
 =?iso-8859-1?Q?iCzVzZOPCSeHxC3B+hhiML3/kSAGsKUCf9/Hef2/aZ2CTABV+f3TZTMAhb?=
 =?iso-8859-1?Q?Frf/1uq9Ep9FRoArrvjLdg6bx1S3agIN9mP7Rf+aqUxX1xPM0Hr0wFqYFz?=
 =?iso-8859-1?Q?ADJzFAdAKglGGby30ccaQv1Ln0P5sb1TU41yxXFrKDnJcSz0RnhozXWjlI?=
 =?iso-8859-1?Q?UZAO2Zb2tkhVG5f8vq5E4563f/CcJ6zLAoHIjzyEy1W8tBpsxrFWTcBP4d?=
 =?iso-8859-1?Q?NvTyiFx3kxEh/oFVIqEVqxuZNvG4+9FPOxHlsuNgkG5otDSn6a1xJVD5KM?=
 =?iso-8859-1?Q?nYCdJgJu2WcLC3OnyY5w4Axf4u44kkPfDEPEzq+4BdJCi+2JJbyRg70Ag7?=
 =?iso-8859-1?Q?QVqGo3Z8BTYjn5Z2MTrrUVqn91WoQ70f/Dxk7iPDNyOcwwkE0Di1e885kI?=
 =?iso-8859-1?Q?81gioHAt4J16BGxAKUMUVayde1gCHYkahyeMttT+yTBPi04UWOS/SJ6PEF?=
 =?iso-8859-1?Q?8tyTB817JkxxhqXtpS2TPeT/lW6wxXWfjdf3Ltc/xnBBbPlx3KByOyMlKz?=
 =?iso-8859-1?Q?et26ntOhc/Z2iJ3Tz9IdWLJTK34J5Ok2pVcgOLOCA7xKF+XyHgqYnJ0FnD?=
 =?iso-8859-1?Q?8rNALIF+jVOB29606Gfc+3/RnsGz6gP4UXOO39iyPUelu2/pTF4UjzIlzQ?=
 =?iso-8859-1?Q?8uT4LVsWXw7QdEZNCG1nbgl/QOyu382AIm29+8p8IbIMkqsfavegDD9UGT?=
 =?iso-8859-1?Q?oKwcjsh4AZfOHeb7gICtbwRMuy08tuLiDsniS8UJJvIiYSfqze0hjhzSND?=
 =?iso-8859-1?Q?lPnZCqNQMFvYMtyJMR2VYDD8gjs115wVUGCy8TcErBZ4m2UaE506dopP2g?=
 =?iso-8859-1?Q?1CEBIUoaem0HyS1EGO+HyRLU5CO8VZJxP4+Ang/B65Sv5GQVHsuGmbkMa0?=
 =?iso-8859-1?Q?lZZoKSg+L2vpd1GSXLhbqD0PqScfsY8w4T5BqMqBKhLTKaMJzwC38Rj98n?=
 =?iso-8859-1?Q?a50aq4tj2iG/EPr9KFw1FlEDIjYhZ3lkQcKHpYPgSNPdyZlUMAb0Edqr46?=
 =?iso-8859-1?Q?8G72R6T55uwytM9IqqpeX3/jWwW7vpiWy2frAHJVOEnG0P5E8PNcwxAxw/?=
 =?iso-8859-1?Q?px8jf/NonAh/+9l8vQgRwZ9RzXB5h54bfE6kXiPLR7gbpn7FWbmcWD7Qcv?=
 =?iso-8859-1?Q?Qx4+KyoG0/OckmtftJOVKJPwqpa5U/kO0xF0w5G97Y3b2y237gSx1bp2aP?=
 =?iso-8859-1?Q?XKMkZKNJNBBYGIehtASycDwpcumKsejaKETViOCCwbflSq62F52sKZlwQ6?=
 =?iso-8859-1?Q?Z3u9H5NVBvvkkA+RmQMkT4lzqv3JnoHh4cb34e+pkYzS6SveId7trzFi3D?=
 =?iso-8859-1?Q?J0Xxa2OtyFSMkZn0XLsU5t/4XKeihPCPLa8048Uq7lBO2jnTokAgAZQUdf?=
 =?iso-8859-1?Q?ry/f1xM+uTfDKRCBEwDi9zipsaX0H2NQ8pp4XrHUIHVg7iAubilCZ3YvWD?=
 =?iso-8859-1?Q?099LAicfLk5qbScYbRcqi7/jgqzpWKLSHnKEWLBn15S5I7sugKmsQZD6Gw?=
 =?iso-8859-1?Q?vUKDtdWNU/cP6cX5LEAavb+AIzE1bbCUMGV9fOk9jU45PlCJdZVawdBR3F?=
 =?iso-8859-1?Q?ia1PABMOgnxoRQ3KMHbADSCWTyfB8augfcq95jjtLvW1PH/D5zuAISRmOf?=
 =?iso-8859-1?Q?5X/UnX5KLyb7euBinnjzTLlekKPpY0ATUOqiabYGiNfOVvW+vO8lmihFUU?=
 =?iso-8859-1?Q?gsFA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(1800799024)(376014)(36860700013)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 18:28:25.7608
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d015211-cf04-44ee-acb0-08de552d09bc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C70F.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB7325

Update the PCI FDT code to generate GICv5-compatible interrupt
descriptors for the legacy INTx interrupts. These are used by a guest
if MSIs are unavailable.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/pci.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arm64/pci.c b/arm64/pci.c
index 03667833..79ca34e8 100644
--- a/arm64/pci.c
+++ b/arm64/pci.c
@@ -82,6 +82,7 @@ void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 		u8 pin =3D pci_hdr->irq_pin;
 		u8 irq =3D pci_hdr->irq_line;
 		u32 irq_flags =3D pci_hdr->irq_type;
+		u32 int_type, int_id;
=20
 		/*
 		 * Avoid adding entries in "interrupt-map" for devices that
@@ -93,6 +94,14 @@ void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 			continue;
 		}
=20
+		if (!gic__is_v5()) {
+			int_type =3D GIC_FDT_IRQ_TYPE_SPI;
+			int_id =3D irq - GIC_SPI_IRQ_BASE;
+		} else {
+			int_type =3D GICV5_FDT_IRQ_TYPE_SPI;
+			int_id =3D irq;
+		}
+
 		*entry =3D (struct of_interrupt_map_entry) {
 			.pci_irq_mask =3D {
 				.pci_addr =3D {
@@ -106,8 +115,8 @@ void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm=
)
 			.gic_addr_hi	=3D 0,
 			.gic_addr_lo	=3D 0,
 			.gic_irq =3D {
-				.type	=3D cpu_to_fdt32(GIC_FDT_IRQ_TYPE_SPI),
-				.num	=3D cpu_to_fdt32(irq - GIC_SPI_IRQ_BASE),
+				.type	=3D cpu_to_fdt32(int_type),
+				.num	=3D cpu_to_fdt32(int_id),
 				.flags	=3D cpu_to_fdt32(irq_flags),
 			},
 		};
--=20
2.34.1

