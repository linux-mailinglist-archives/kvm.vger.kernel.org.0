Return-Path: <kvm+bounces-66376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B547CD0BCB
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:08:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 41EED3008492
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:07:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A88423624D1;
	Fri, 19 Dec 2025 15:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="g2YUgkYv";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="g2YUgkYv"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011029.outbound.protection.outlook.com [52.101.65.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A99C363C4D
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.29
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159647; cv=fail; b=fxI9WQVoZ30IpmJCMQYxk3h08PTd2y20caLte4Rp7Hu+xoUih6tH0mlxmuYo7J0SptzyLY+MSJ2/UsUqjjxzc4XWScOha2kz1S/8/05ovgZ3fXXSClcqudCtDsztOySKqjhA9jtJgTb5Ce5S73IEKc1T3WTSYKmCsFeEIhHQKow=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159647; c=relaxed/simple;
	bh=2ojjynfg24Z43oT2FrZhcLqM5PrUbCpyKB+3uPlhHzY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qMCU3TDRlBGkb3p32qR9qtQtxFvu4nC28A3vqdhE2866Eg4ol0V4Dezzzs7WQ7mL9bnBQ0rzVmWFsO1FyhctS8jsuzeuELPxcSqmzJCP8ncDfyfIHtGvDLu2kJAEPcdN49zaN838rv8c+WjhH5eOKrAsJsh2vxmsYvDlLkyrZiI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=g2YUgkYv; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=g2YUgkYv; arc=fail smtp.client-ip=52.101.65.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=DrAiH+E0TvW+lwmOpwXCr3FZVsnhIvVC2Aq4QoIHATTvRUkmlcdBFXMsDFABWF4NI94qjhjwSoslhJgwBLMuSg7JFzSzO3cSbmW5+mzgnThP2wgMpaNgt1Sr4slap9SO+jGTSMqMYVGAxN+j4yuYcm2lgXEZUv1s3Odo6W4SI2+v0s+7PKCgiXitRrFG/WASGDtcd2/+GgboAnHhc63efswWDDvnRKLvjtFzhlJKKdsQG4a9xAlS6YXOoufEArw6TWI3PvMMovrhIrgIhpxPSadhUWhaQAi7EyVbheWcx7TaTBnvw2JKjNp0S6VtVUtMIqg10xKKRjZAL+I46nIJ4A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1t0aTX5R2lNNpamQtLM8CVWkVtvQi+IqvosIuujAjwY=;
 b=d9LT21ozNeU+C1WbIEDrX4MA3Y51mLZBjBOfL4bGd4Tx3RF3IrPXN8PQzBFy3f4GAxpNPErbcD6+kwio5TwhR3OVbEBdkBlIXFAjS9TryQJkQI6yuFfMp24h2gMLj4OQKhcIcVE2skWAh9Bih5Y4sSDzEWHaCrSxJ6F5wtDsgr/X6zxznNQlewYdNdxszCtB7Ih0jruG+nHRxqbo8RquOBtwpxQtV/Fw/b7i3OzBRAf1pSPDUPF5mK6AoeoHMCwtSA/ZMNk9jNrPwnSnMyqLmrJNDITAP/oHz+sru1J470WoSjPAZnG5PpbXgDDWft4TIQyNOmA4KHxGKOxh4EvqiQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1t0aTX5R2lNNpamQtLM8CVWkVtvQi+IqvosIuujAjwY=;
 b=g2YUgkYvXDGr2v1M7VmH8vJ06ghUQtC5dbn9DX55SZaGGuZwFtvP3BvVUzQcl14mB8E6QK0Q9NOxBYQwsjZ1QKqvbIwWeDaS7bDsvDS8T1/305MUSSC96e8qqbo33jFN/ixgnkbygKn1mn9R2G0EiS/6npJQAjDRPu3KR59LWg4=
Received: from DU2PR04CA0183.eurprd04.prod.outlook.com (2603:10a6:10:28d::8)
 by AS2PR08MB9450.eurprd08.prod.outlook.com (2603:10a6:20b:5ea::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:53:47 +0000
Received: from DB1PEPF000509F7.eurprd02.prod.outlook.com
 (2603:10a6:10:28d:cafe::9c) by DU2PR04CA0183.outlook.office365.com
 (2603:10a6:10:28d::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.8 via Frontend Transport; Fri,
 19 Dec 2025 15:53:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F7.mail.protection.outlook.com (10.167.242.153) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:53:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ty+ukwTRdLtRrwINSFzVKiYd3wkVpddFBmbTnAko0JXhWm0HVgETTBNV8/MIIECFFf1S0ZHS3U5G0hjp0lWOfof130kVfkKcX1eEiMSyDgAlT9l3BomquyPbfpZ2VwAYiYsajae/oTJoHPjCLuF2PIPpa01wwual5MScsFVWD1232e28bB2Fny57uziEOOqzY99vvhqjJrIY9uuN9eyKayAiyuPQu23jQtg0mZZYPhQJpuKiexu3Km2vXjKu1rmYw7hMUxFfLZhOuOWyoudAIZST3z3r894EsfaCT56CMj6c3vp7fcMkx3Zsnr/tTsxjCNkIY28YrhqFkClLT2Ig9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1t0aTX5R2lNNpamQtLM8CVWkVtvQi+IqvosIuujAjwY=;
 b=eAShiamplsLhqOSreMSSI+XEgxMSM+1rL5zoi8puK+wTZhJ1sZ5LyjuqRKpZ4wat2vFtWWG41npUz50KYZFWjyshPyne/NuoMLhXB45wThiMX0Femq+s7+Vn2dpyotuPAApUjYmxtz9Jy53JVaIyO5gI+KAjs/F8+q8F0bDUq+4kuGDdCmWZCGfNyCuRXPlLth1JDegn+czrcIDCVWiLE1/mPJsCTTemSoQLwPFjhK8BaN5D3s/ztoV5ZDOD6CmMiunkvB9JEMP9JftS2iJ48nONCJOOmhMiYcln0Qyeit1QIGvzAaHZGGRwCTGAN+a/NSEtYUN2iLw9VHaBXGYzyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1t0aTX5R2lNNpamQtLM8CVWkVtvQi+IqvosIuujAjwY=;
 b=g2YUgkYvXDGr2v1M7VmH8vJ06ghUQtC5dbn9DX55SZaGGuZwFtvP3BvVUzQcl14mB8E6QK0Q9NOxBYQwsjZ1QKqvbIwWeDaS7bDsvDS8T1/305MUSSC96e8qqbo33jFN/ixgnkbygKn1mn9R2G0EiS/6npJQAjDRPu3KR59LWg4=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PR3PR08MB5676.eurprd08.prod.outlook.com (2603:10a6:102:82::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:52:45 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:52:45 +0000
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
Subject: [PATCH v2 23/36] KVM: arm64: gic-v5: Support GICv5 interrupts with
 KVM_IRQ_LINE
Thread-Topic: [PATCH v2 23/36] KVM: arm64: gic-v5: Support GICv5 interrupts
 with KVM_IRQ_LINE
Thread-Index: AQHccP+Dc9snDtO58EWYfGyuNDvZWg==
Date: Fri, 19 Dec 2025 15:52:43 +0000
Message-ID: <20251219155222.1383109-24-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|PR3PR08MB5676:EE_|DB1PEPF000509F7:EE_|AS2PR08MB9450:EE_
X-MS-Office365-Filtering-Correlation-Id: d72144db-4d14-40f5-0dea-08de3f16cbf1
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?g1cHKFMAyZgROfSFZI2+i9MnwJKs/us9UE0IlG+O8iHvbp775fkIserZo0?=
 =?iso-8859-1?Q?5T5XMX0W3eDW91ceRh9p59WUQhm50TQP8QHL1caenAE8GHMXj2yYL2ikNK?=
 =?iso-8859-1?Q?kEp0m+1/u9dNoJ46LgCsm+H/I95YpkgIU2+RdQDl6HK8pxLKg2IKWJKcuy?=
 =?iso-8859-1?Q?h5oJTp2+PMqtzpoDMxPHIDdMF3RCarnKaCFEqHaCftyday3nyOWfsTBDME?=
 =?iso-8859-1?Q?FEiyyBRc7uYGKHgSnm4W500Cj8sED+ZR12wCm0x0NTQ9fHSajjqhA/bcdr?=
 =?iso-8859-1?Q?3xLIdA+xrirhKJ5HnG8HiOpEPDBoV0LMwJn9zKljB1era6Ik6YRjVYxJuA?=
 =?iso-8859-1?Q?SvwOhpIRVQP3Dvyy4rBGqWrOP/aa5iM/FlV+qBxjUbKlVoCkpQcgDZLuig?=
 =?iso-8859-1?Q?ANDnpnt/FApfrCw7PbUEMCQjOfNtPQQdKU/dXY7z0dLIHjTWj3cIXrF+3O?=
 =?iso-8859-1?Q?WX/sA62WhbsGCQNLYnRC6nKE82yKkQeVg2JeZBfaImQ5wyjJZ5o21fQfnF?=
 =?iso-8859-1?Q?vFqdcw5iFa5UpxhCtZ4tYbO6rRKLrcaDkfGPyGOFI5huQsN13RrxYb7tAU?=
 =?iso-8859-1?Q?zJ9xntp2cvhuv6B5fO3L/ikVK7dy2G6sSkrlpGSoloX8hGIvrv4KyqrFN6?=
 =?iso-8859-1?Q?mVyL1qjK36r0Ol512nM1DNBH5ZXWQyZm2ID2IqPUJfn7YgHirDJGHVPINh?=
 =?iso-8859-1?Q?PtHS/bWkMKLC4pjWhwd0+t+PHhuUHXlpgDvjMBjb3HR0O01OPbpQ8OBteA?=
 =?iso-8859-1?Q?Zj7A6248e3T5qJRsJcff2dczQGSTq2Mta76urWndQeXdcJWJFq1z/h44CM?=
 =?iso-8859-1?Q?ZyGjfEtny+5HcMDIIcq2db+o9fw6sm60a7X6YzDQWDdVF4QbycgPHZNlDg?=
 =?iso-8859-1?Q?pD1p4ca+/wNZQJ2CAvGmwzMnfUvtnUGdKFDFGgZz2QKEP+o7qZFoCzUoXC?=
 =?iso-8859-1?Q?SbXOKP3TPkOrMKYx0QwsmaCbA4WmZ/LAVb+qgM0QvQ6ogW8WDPvdPT0uY4?=
 =?iso-8859-1?Q?Jkd3ZQnMjEoE01p0rJKN6KgrgCVAcL1hcl5/bgVM6qbyXbsJeUIaZcViXg?=
 =?iso-8859-1?Q?jdaBb9ckM44zZWIzEG9v14szJ90N10hxEHtVL/3I11MDvC5Z2ATKfhdPh8?=
 =?iso-8859-1?Q?SPE20I0yPYFx/Ha68mEAQBQubDFmaKWEt0o22zF/Tu/koZn0OAucL+ka3F?=
 =?iso-8859-1?Q?0fuevrbhxRlPHpIgEUN7G3iYcNUSgcQHgthRHneHLgJ0MYHlq6QuTSUoQ5?=
 =?iso-8859-1?Q?Ov4x7DAoqXGl5dPpohoSqMXNmeuejQ7G0FcIcHFBI3BLRd7MqWByWpXhx1?=
 =?iso-8859-1?Q?66ssDmiZLuBWYQeffChi6EekD5WMOdvwuIMAniJo8xGsCE2dI7cZG//pTA?=
 =?iso-8859-1?Q?TPamjY2jKWfh/ftdvU9mXRxdul2JZdKKkku8nqoZTkUDSuUkD3uV7vm9ue?=
 =?iso-8859-1?Q?ydcT9p+7ksNq4ty3D0wwZ4fyTP7xTQWgK9/nbw991QCgArdrd87I1RKsgx?=
 =?iso-8859-1?Q?Cd9afYCBHjj10Zk8daYnG7KF+aOPp4+bRIoGpP2dvQWq0yLxzQKUOetPoq?=
 =?iso-8859-1?Q?2oXnkiYpcmBHUuCuBp31WPf2CO8v?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5676
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F7.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	66ba4e19-d07b-48cb-6e2b-08de3f16a6dd
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|35042699022|14060799003|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?Yp84dFpXTBp3PWUdUoqF81Rxk8nmW2UF0u83Ntfs423g0ibzuehOcANeBL?=
 =?iso-8859-1?Q?F3FAdiUg9daMXY63h3qm6TNWaV5w2jjgcYJzVg7+dNJIcMayIF5W1wBqIo?=
 =?iso-8859-1?Q?vrrBuJBC+CJoATf5bXphLbWEM0s4n6tztaNbkNLHvKshi4lIQRJnsTV/G7?=
 =?iso-8859-1?Q?j5/LSbq6wfMKMUNk9tEIuiFCoeVRMR8GJt0LsPADic62m+dJhKqs1bZJh5?=
 =?iso-8859-1?Q?pWSc3UdD09+ef3JmZgbRHquN7oQHjZoo0NMWWuTbdhN+HtL830srj6wYG+?=
 =?iso-8859-1?Q?t8V3yy26hnxchkHXM04v7IjlxlBnR8wcbOo9Scy0YVnD8WwgSwzSUS4Wny?=
 =?iso-8859-1?Q?k7PfwWgDApzt9GfE5M3ZBtuMI9dXNEFrEgZmNJBmAtjgnQ8vreQ5afgr20?=
 =?iso-8859-1?Q?slBPUeo5W7yiBiaZFTiCBlkuTeGxqBzi2tSQ5x1+zCBMU8+bCz6CHMlJo8?=
 =?iso-8859-1?Q?Riu8VKcNprQ5WQwaK1yP8d8On/k4z9cjuaqhoeyeBl9WBoQ5gJg9zgD9Vx?=
 =?iso-8859-1?Q?KNENwGPVOAxem1cJGV8sHQoB0IQkbCIcacLiUh2i6lb4TeUBTng5F64BuG?=
 =?iso-8859-1?Q?9A8wjRv6xkhEMP1+fRbMs5UmUdn+kVYJCOvFdzqXhhyLwNHREdzZtmdDe2?=
 =?iso-8859-1?Q?OsfMo/DkoCdPuaYFmndGxMXrndCYRHrSlKNQiuyBMYm9P5EHSH2C0H4TyH?=
 =?iso-8859-1?Q?KjqOu+gf7Y2sL0yTnBUruYnLCkK4K54eRMVInPUwiHmzl9pVp1KBZLMnE2?=
 =?iso-8859-1?Q?fVXe0Mbf8c8M1RLXSSKQKQ0CAM+2k+HdCD+A6bSUa+gEAC52jmgX9f4Ri7?=
 =?iso-8859-1?Q?+PqOAF/3z739h7xF8bUU4MqsW9PvIvLzik7BSM9hw9hLpB7p+pVwn0OT1E?=
 =?iso-8859-1?Q?ZxTZiazNdVW01kJ+cDgHxV9kH0TT9AQD9nvdLMmJGcaENpcVt8C9CQU8va?=
 =?iso-8859-1?Q?eAHexggtYWr07Hr8o1HhJx2Umy9QHzrsScNj3CM3k1PQqKng7nMtrO4Lpf?=
 =?iso-8859-1?Q?V4fFVztjEUePcFAgOvlnZLuPlY6CyYPDq3Owye/4YtsPFTvnnFBEwXcZYu?=
 =?iso-8859-1?Q?2ILEpHYHERJSApooZMrvZyJLFZG4NuIHlnO9EBeYNVXsNg4AAzI9baV3wJ?=
 =?iso-8859-1?Q?96+/qgjX1RaFG8XhCrOaP1maIV8EZ/+sWx7HKJbL8tzV/C8q9GmPbNTmJm?=
 =?iso-8859-1?Q?25jV+K+PaAFEIFfVoAunBqJfcEavEU1IG0k0ul9lOgusTDsySlkFGbd1pq?=
 =?iso-8859-1?Q?Oi4Lk64sqQ9Ce02yF7K1y1lxafGzABT6aeZogQ5CVZV5G7v0C6Nb0DmDzT?=
 =?iso-8859-1?Q?CwOQpXKVeA5VdMmXU/yiktkaFuVCDMrluyEWP5n7CyQnD66c/4mVxrZuxd?=
 =?iso-8859-1?Q?gSdM1GPvSUAHX/aNsTIqC6E6X/dap9108tYeVH/hWJkO9lmMUaCOtcL9Jh?=
 =?iso-8859-1?Q?wbhOi4UJUdFLh6Hdd+qkimN8C49G9/n47bPhZr53FStoawF23L3smFoEM0?=
 =?iso-8859-1?Q?5gWgCM/VLvI3AgFBQB6YegJzioI1RYxaGBK3c+4LB/LSRR7u1eXBdPXnJV?=
 =?iso-8859-1?Q?1sEeoHDmsH21EEcucWsaHKVmeghHmQ48I3SaLRHmLM1ed0m8n49Ast7o+M?=
 =?iso-8859-1?Q?8mEBMATBaZmlk=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(35042699022)(14060799003)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:47.5498
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d72144db-4d14-40f5-0dea-08de3f16cbf1
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F7.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9450

Interrupts under GICv5 look quite different to those from older Arm
GICs. Specifically, the type is encoded in the top bits of the
interrupt ID.

Extend KVM_IRQ_LINE to cope with GICv5 PPIs and SPIs. The requires
subtly changing the KVM_IRQ_LINE API for GICv5 guests. For older Arm
GICs, PPIs had to be in the range of 16-31, and SPIs had to be
32-1019, but this no longer holds true for GICv5. Instead, for a GICv5
guest support PPIs in the range of 0-127, and SPIs in the range
0-65535. The documentation is updated accordingly.

The SPI range doesn't cover the full SPI range that a GICv5 system can
potentially cope with (GICv5 provides up to 24-bits of SPI ID space,
and we only have 16 bits to work with in KVM_IRQ_LINE). However, 65k
SPIs is more than would be reasonably expected on systems for years to
come.

Note: As the GICv5 KVM implementation currently doesn't support
injecting SPIs attempts to do so will fail. This restruction will
lifted as the GICv5 KVM support evolves.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 Documentation/virt/kvm/api.rst |  6 ++++--
 arch/arm64/kvm/arm.c           | 21 ++++++++++++++++++---
 arch/arm64/kvm/vgic/vgic.c     |  4 ++++
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rs=
t
index 01a3abef8abb9..460a5511ebcec 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -907,10 +907,12 @@ The irq_type field has the following values:
 - KVM_ARM_IRQ_TYPE_CPU:
 	       out-of-kernel GIC: irq_id 0 is IRQ, irq_id 1 is FIQ
 - KVM_ARM_IRQ_TYPE_SPI:
-	       in-kernel GIC: SPI, irq_id between 32 and 1019 (incl.)
+	       in-kernel GICv2/GICv3: SPI, irq_id between 32 and 1019 (incl.)
                (the vcpu_index field is ignored)
+	       in-kernel GICv5: SPI, irq_id between 0 and 65535 (incl.)
 - KVM_ARM_IRQ_TYPE_PPI:
-	       in-kernel GIC: PPI, irq_id between 16 and 31 (incl.)
+	       in-kernel GICv2/GICv3: PPI, irq_id between 16 and 31 (incl.)
+	       in-kernel GICv5: PPI, irq_id between 0 and 127 (incl.)
=20
 (The irq_id field thus corresponds nicely to the IRQ ID in the ARM GIC spe=
cs)
=20
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 94f8d13ab3b58..4448e8a5fc076 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -45,6 +45,8 @@
 #include <kvm/arm_pmu.h>
 #include <kvm/arm_psci.h>
=20
+#include <linux/irqchip/arm-gic-v5.h>
+
 #include "sys_regs.h"
=20
 static enum kvm_mode kvm_mode =3D KVM_MODE_DEFAULT;
@@ -1430,16 +1432,29 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct k=
vm_irq_level *irq_level,
 		if (!vcpu)
 			return -EINVAL;
=20
-		if (irq_num < VGIC_NR_SGIS || irq_num >=3D VGIC_NR_PRIVATE_IRQS)
+		if (kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5) {
+			if (irq_num >=3D VGIC_V5_NR_PRIVATE_IRQS)
+				return -EINVAL;
+
+			/* Build a GICv5-style IntID here */
+			irq_num |=3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
+		} else if (irq_num < VGIC_NR_SGIS ||
+			   irq_num >=3D VGIC_NR_PRIVATE_IRQS) {
 			return -EINVAL;
+		}
=20
 		return kvm_vgic_inject_irq(kvm, vcpu, irq_num, level, NULL);
 	case KVM_ARM_IRQ_TYPE_SPI:
 		if (!irqchip_in_kernel(kvm))
 			return -ENXIO;
=20
-		if (irq_num < VGIC_NR_PRIVATE_IRQS)
-			return -EINVAL;
+		if (kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5) {
+			/* Build a GICv5-style IntID here */
+			irq_num |=3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_SPI);
+		} else {
+			if (irq_num < VGIC_NR_PRIVATE_IRQS)
+				return -EINVAL;
+		}
=20
 		return kvm_vgic_inject_irq(kvm, NULL, irq_num, level, NULL);
 	}
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index dfec6ed7936ed..d91f7039fed6c 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -86,6 +86,10 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u3=
2 intid)
  */
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid)
 {
+	/* Non-private IRQs are not yet implemented for GICv5 */
+	if (vgic_is_v5(kvm))
+		return NULL;
+
 	/* SPIs */
 	if (intid >=3D VGIC_NR_PRIVATE_IRQS &&
 	    intid < (kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS)) {
--=20
2.34.1

