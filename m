Return-Path: <kvm+bounces-65860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 54744CB91D4
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:27:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D206430DBB31
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:24:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7940231D390;
	Fri, 12 Dec 2025 15:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="H82Wg1gH";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="H82Wg1gH"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011030.outbound.protection.outlook.com [52.101.70.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A132E1C65
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.30
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553035; cv=fail; b=bX0HiylHtECApt4P0mNEqiK+XC7OXfNWzBNzvrp3SiyIRZ0zCIiBrnjJ8y8rXZI3C/VDObgmS00rRveR3aJtHCHoIxppvS0ym4+iDjneaQhnqbnPFHo/ghxvmAD5dsRfLGLQRLjIs1uGpUqfszBp6C3adqKYyxPRlSu87hJHNIU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553035; c=relaxed/simple;
	bh=8ZQPknqYmMVOFVjykk1qwSzAJwcDtjLkUEbv2mdciCQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PrwHtxhCCIH5QaPYa47jJneht0a5hUeF+uUBq9jJmXLNMbWESX/DNciUDu8MbngsG7R/6+kwrU+x5op1VCDnNZ1P+pmspKg4YduKep/0VImfZAg4x9pAgobNQxMhneszAGh9BTMxhaWDaEcyjKkBRG9HVvJ5BkzNc5/wx7jdWA4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=H82Wg1gH; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=H82Wg1gH; arc=fail smtp.client-ip=52.101.70.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dgblXVvczrZMCXqvqPDfkgx85qgI/sIH6lkC45WGWkuQTXsGH7n4vKRxU6GDWIyiJTgalqS6TI1aIca9h+Qd/xrzPsqKxKBzF9QGP9uYx9C1LOuuXauwYbOiZaqZQa87fqTQa/9d7DCrL5Qb/5REN0h2YKJfdwMGIrllQQ0dQIBt5Y1CxCCr7/5Rvy2kG0Vl8jnRJUMklcUBrCV9wKWm9rekmmRqHRxlx1HaYyWBpe4+l8l8x6NoJ4ymUpSDvA9v6LrySixL/xqbeynlgJojhzvxHg+XdmTYUOmXolrOD9imJsKxpm6ALywuVXJM4w0+xMC+CTvOv+lUoRrZyiJvrQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aGpFxoiPCbtm8fUiFGS6KMjKD3K0/KNn6pMtYGsW2RY=;
 b=eVuUJ74VZDFELsOK4gKKaw/697LVoUOusv11zUDuetdxqF2JTKIJBQVF2eGoC+M6S60QZXmGrHV7/kXNNtBy/7Sg17VjAWlAe3ItbJAGDsTvi2lf/TVDkKSvfiHP3oBLHnj8aXgOFZ1V7k3rrlphg1jn7YL6/X72D9LEA7snBCb9OrEqhzIipKynKB25oECFlzeLusmfl8F072udj8HE0sr62rKt/NZaBkslIZ33bXF72ViAJgVRvlG0peX3qucqF37fML0p9iL7VdaKMNXqLySnTHNZbtTPaXgOnILE1QCWOc7TAyCwLGRbuc5RoMyX4Oii0Jiup1b1rJn3zhBmvg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGpFxoiPCbtm8fUiFGS6KMjKD3K0/KNn6pMtYGsW2RY=;
 b=H82Wg1gHwfDw4JKE7D+IiiKj3eU5PbF7bvoO02A6pCiUba28pfIIInzhDHZcd2RthRhUDPE1HBxTBNGpukwYcLGGozcGRigt6IoS0WHhmW11An/UC9/jBrlhX1UGRW35ej4oE4yRLh+9GM3Fi1OxI22XUhE+xGs202q6zue1MHs=
Received: from AM6PR02CA0026.eurprd02.prod.outlook.com (2603:10a6:20b:6e::39)
 by AS8PR08MB8350.eurprd08.prod.outlook.com (2603:10a6:20b:56c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Fri, 12 Dec
 2025 15:23:43 +0000
Received: from AMS0EPF000001B6.eurprd05.prod.outlook.com
 (2603:10a6:20b:6e:cafe::49) by AM6PR02CA0026.outlook.office365.com
 (2603:10a6:20b:6e::39) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.10 via Frontend Transport; Fri,
 12 Dec 2025 15:23:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001B6.mail.protection.outlook.com (10.167.16.170) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 12 Dec 2025 15:23:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y3hHHDeZIxnDQu6yv2hziY46yzysEFTcwl7v//JpANMYaoRmzJLDxe5pAGrWUwICxQ1fzs/qEEBqzUiNDaXBCdulXCULfLDrqTQF9wIz1JRNBYLBHBNL8Lbu00RPvkhZegWcht4vVscW6qHr6x/9gm5kuvL4zOMmhLUmG17fR3oQHKWFXrXVFpyy3nMOQwDUZmjcFdf71Sd5JnWt5riuGdnj9HEsvc7Y1hSOOffBVCZjEg+hVjriIjIqNPa094ZQpVyFllpcPyNyLoIoA6Ouq4AEHQZIFkjdciKUldUK1/MWMz0G/lJsWK5KHB93NA5lKAAL3dXfs+E34IhAHf3Krw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aGpFxoiPCbtm8fUiFGS6KMjKD3K0/KNn6pMtYGsW2RY=;
 b=lk5P1M2j6g0dT6Y5kjYwXmqqxBiARYSSJ+g0INjx6cMNciHJ7zfa0L63jOBbQmGQA0LVwpCSMK+ILOoYwfFI15uNmb2uavaHacZEHuRgr7wERAqppWLoc7SgIJp5WIl/vgdzu/PIhve7feHykqpYo/21Y5xuUxKvLiZzrrNMoxdSQLyB+Bw2MR408FnmhBfyGQCBjLtdt9t8957vxem5nBI2a6Q0lwzwQOk6AtVADVdj3jbxNt8bDr5w+xCQyFg9/RNfgbeHZIAiAFME8AQ8D/1ac9Z7iLj2ytnE6zT+zg6+vK31apcrsuyWJALwO6iELntmCI+BwsRMTFyx7q0+Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGpFxoiPCbtm8fUiFGS6KMjKD3K0/KNn6pMtYGsW2RY=;
 b=H82Wg1gHwfDw4JKE7D+IiiKj3eU5PbF7bvoO02A6pCiUba28pfIIInzhDHZcd2RthRhUDPE1HBxTBNGpukwYcLGGozcGRigt6IoS0WHhmW11An/UC9/jBrlhX1UGRW35ej4oE4yRLh+9GM3Fi1OxI22XUhE+xGs202q6zue1MHs=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by DB9PR08MB9756.eurprd08.prod.outlook.com (2603:10a6:10:45f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Fri, 12 Dec
 2025 15:22:36 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:35 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, Sascha Bischoff
	<Sascha.Bischoff@arm.com>
Subject: [PATCH 02/32] KVM: arm64: gic-v3: Switch vGIC-v3 to use generated
 ICH_VMCR_EL2
Thread-Topic: [PATCH 02/32] KVM: arm64: gic-v3: Switch vGIC-v3 to use
 generated ICH_VMCR_EL2
Thread-Index: AQHca3skmTnBmPvFJEucTVfSTrklLQ==
Date: Fri, 12 Dec 2025 15:22:35 +0000
Message-ID: <20251212152215.675767-3-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|DB9PR08MB9756:EE_|AMS0EPF000001B6:EE_|AS8PR08MB8350:EE_
X-MS-Office365-Filtering-Correlation-Id: adf91eb1-faea-4be0-a515-08de39926ef6
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?EDbz/xN2Ove0uY43Tjwhz6ZDwMGtaRqSbg1aRZ/ubbRUuSoBbWqvAFTSKH?=
 =?iso-8859-1?Q?GsqPxYHQO10525C5Sef/oC2DWbygBMk9RsBD2F+ncrvi8VYPxZZZVWmZnc?=
 =?iso-8859-1?Q?ocHLhj5krX7uSpYYXZyiUGYArNiP704eUMipfuai7UuE6nXnJ5QSA0zyJe?=
 =?iso-8859-1?Q?o/xg99BZ3tlsla408gxF8Kp6iWWdrRcsOE/yC+mwkVbqG7DeaycCgNjw1H?=
 =?iso-8859-1?Q?beYvcploKtgMGauEL9+sklTbai2TZsAGzsqw7y4l0Dbt6+UlYSj9Oz17IR?=
 =?iso-8859-1?Q?dr2bUvltTLJM1q4sFlLjO2g5XIEnEKVNOQyG7zJjmb7WJ6ef+QP2d2fO/J?=
 =?iso-8859-1?Q?2EiHngTxvVG/13jyIjQzg4HboX4qw/yxj7i9q2r8B+fSt8UQoInWTSEQmw?=
 =?iso-8859-1?Q?TpvBj865ESwrj9QopRjoY+4bm/vufRtmqf6dzgIe3/eAuYnySdaYJREj6t?=
 =?iso-8859-1?Q?ftS416HP99Dxo7G78LEXVpuK/2lSbEtXxoMpl3b2gFx7s5S2S2TpYXt3qy?=
 =?iso-8859-1?Q?ESH22BFnSyYTHdIo2MNXQfUYxK6wsRl5fBWZaU8SgoBuhWE1HOAhmKTH0s?=
 =?iso-8859-1?Q?DzWkzkhVvjWel58VsGyAvNhhxXKdgffbrHdC5ZrYOs/FwAZCVccRymCksi?=
 =?iso-8859-1?Q?Kt+CQDrrGLsKI/p3CMOEWHCSqvEa8cWuFI7c2cu/Voup/8+5pdtXY/Zq6m?=
 =?iso-8859-1?Q?JnP/1oxQV9Yf4KtLXpg2Sqxp8tm6dWM/qeQJX1emMa4VM6qy3L9CG3MO29?=
 =?iso-8859-1?Q?LmxF6rTEw5heltUN8v+McOe5DWZrufuvGhf9mcnMDl425ENLPvZ9B/yLXW?=
 =?iso-8859-1?Q?fFTs1Zxrr6QeJuYegP8T2RjpdB5F8X6/MrEcoiziQCj8HFalVDSlNMccPH?=
 =?iso-8859-1?Q?cnIsbJf1JMkK2GxZ/L/vbbsh1yw+9sf62CtuPHwI6dFzh7HHaG4TZN97HH?=
 =?iso-8859-1?Q?9Pp2GFO7o3nzLaehc/I5mV5MYzIfwiUxSfHzo1lxO4G5GbJUGz6RFoIrEn?=
 =?iso-8859-1?Q?SuvbAy0NLR9oftGia6uaX0L8/d3aI1Q//wWZ2DbJKpMqBFhDa7dowg3fpp?=
 =?iso-8859-1?Q?5cKCx/C7cLY9l2GthcI5EUk8Av5p34mGVpfZcmO0/qqGq+f0trLovLAK9R?=
 =?iso-8859-1?Q?5764nkBlNc3k01bytn5apuUv8grpKBf/JhEFxaDKuPXstxRt5LG7ka1PQi?=
 =?iso-8859-1?Q?jbntdREeBZezyuWMHLbG8aPxyvzVIZ4VBbrYS8x9WU7jGrIviV9ArNXImy?=
 =?iso-8859-1?Q?+wlso53+roRgv0USche8IHyPZLyWMDhz21yMLMpF5HgIKbN1XcfWD/V4rZ?=
 =?iso-8859-1?Q?imj4vuxq5i/rmnfQOyKya0JCYSSHo20ATMo5pOR7vNHw83Wx5CrpGRUjTS?=
 =?iso-8859-1?Q?f2bUR4tLJ90yV24Ra80UdyYc8AxT/nqS7lg5YDtB8rRlmyn0JIE8NuEZ6x?=
 =?iso-8859-1?Q?hC+nRIVHUROrDRxWEC/aVe7n/XUCouUsR9VPkR26alJ2ZILTmScCurVl6W?=
 =?iso-8859-1?Q?wO1O/41ZpKWhuWAXJUnbbBZxAD2k00epOeWk9TQV3vTj+Sefz3whsOQSco?=
 =?iso-8859-1?Q?bTTDZoqEDgDbEODXxgmUoMIjb48S?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9756
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001B6.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	eab9688e-0d92-4506-ceea-08de39924760
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|36860700013|1800799024|14060799003|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?rDEDdJEeSo+aHWfzn7azFoqhonbGEqNWrXhxU+KkbC77wFXANu+/aVFDXR?=
 =?iso-8859-1?Q?XByGP+RLukDMvREHHYsMT0YCK+2OX3vLnvXD1Ea5myxj07EbNCf23w7SEe?=
 =?iso-8859-1?Q?LyircDITZQtvJx8652ksF/r6BEtY5Kj3BG3OZkpo3NYLQmkoiyjzojhSzS?=
 =?iso-8859-1?Q?Y7ShE4Z/MQ9igxBdtBq6gYYY3Eycgzh+hkFu61leS4ATdU26+x2Qs0/IRm?=
 =?iso-8859-1?Q?+0nBQ3adYIJH9mA7sOhn7rGuoxJ2FhEvHW1KIJiNcMyYiNWDIHvqzoNvht?=
 =?iso-8859-1?Q?A0dmFuDw+Z1suCVJ7gpLX85VJkK59ugU4iPW8SCPq7+s29Pvcf3f5Qp7A4?=
 =?iso-8859-1?Q?UFFb94xiWqijAw+0scSQhH7VdOD0I3quYSB1yp3CbK3y/zqb2VAIdF5/PC?=
 =?iso-8859-1?Q?eYgxGXgnKMs97sOdRIXl1W2MiseqLoR+YqPEfDNI6HYcFAFkngbUpaCV8d?=
 =?iso-8859-1?Q?6MBVDeHqSM00LRS9EawF2bVUfvtYjeacWUQBpX+2sHZkyvuiSZLUiOQL0M?=
 =?iso-8859-1?Q?RC4kjcKeTulHLHKJbA4cT0o+Z+C1DD6jWVx579ZyRiD489c5z5ic7KG9NA?=
 =?iso-8859-1?Q?xbn8Clx7IBSO2f2cyYSxCTjRZRZJml1qe2HSGlOwc+ODsZ561zQU23LG4V?=
 =?iso-8859-1?Q?YNJNYZqLMW1aLEyG0p4QiclpwUlknaRw5Wjevd5B9Jyzc60gjt5MlcA16t?=
 =?iso-8859-1?Q?9QUzYEit7Wa88cEa0m4IkeTgIvQiQPYEhBpeE8DAl2oMa3w02XEDsB6CQf?=
 =?iso-8859-1?Q?IDAJ1VH0cnGntkVeA1FnoOU1VGIchZz1LF26WVxnAsxLucnhhksubda0Ws?=
 =?iso-8859-1?Q?/FIGCERzxBZfzopqEKJOxBC+kfIpVvn33iU5mO6QKSiiOLVTE9GgRnpcFe?=
 =?iso-8859-1?Q?F0g0oHNId9RshuYdzBp7V7UZISMiV4ElY30dL//8rOqY0WG62ZkxBrUCTo?=
 =?iso-8859-1?Q?C0RzNbZHubUyos/6tDnYE4HO3213znTZOJ8TsKtODerQ2GWqLmKlnyNZTV?=
 =?iso-8859-1?Q?Spn/mW+9mvnq/+yaS1q0y5rds88skqGD4/VkbHbSLmB08mJMS5jtlHblu7?=
 =?iso-8859-1?Q?s6CBAhDKI8OmM8jzmY4ciZAalIT4Q5FVNZpg50xQZ+mpgZV6GyJgL0xdUc?=
 =?iso-8859-1?Q?Uaj7tdR34V2+/H9yXCOhawM5TXIIDPs5PeR8bENVUGwPZRqbTPKCKzY8y1?=
 =?iso-8859-1?Q?CqwmWHBENoeTvk0m2WGK4hXpb50TqrRy6UDkPzr4JVvanljEWIONRbYIul?=
 =?iso-8859-1?Q?rSBnhWOmGq07D8TcfRREpvg6N8dtRkNs6R8pfioQwzyNeyNMiVg//fPxbL?=
 =?iso-8859-1?Q?D4DlRTDsBuUskQfRGjlkgm+hje+Vz0+iP/dKGErKR58h51tOQ64QEa9zW+?=
 =?iso-8859-1?Q?rO9miKKLGxEzD2ZwyUeSqr40PN23IqfTnciYg9cMfJ3jLwOWlOVDlDsXtJ?=
 =?iso-8859-1?Q?PPJfE/Qb6et7mer74g4MnngAuMLtx/nC2Fyq8Uy53rgjRzzCounspVVDbS?=
 =?iso-8859-1?Q?YNLBGxazf5pHbzl4w+Y2LaajG0BTwI6ADdrxvVQa7KbdhcoxD5QF8hnv+f?=
 =?iso-8859-1?Q?NPavN1Hblc+WlBMZkzqq78pjAr8UNhlJVFGosFwzWD6Vx8uCLvUn3+34TA?=
 =?iso-8859-1?Q?3/TVoCHQqmGGs=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(36860700013)(1800799024)(14060799003)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:42.1858
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: adf91eb1-faea-4be0-a515-08de39926ef6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B6.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8350

From: Sascha Bischoff <Sascha.Bischoff@arm.com>

The VGIC-v3 code relied on hand-written definitions for the
ICH_VMCR_EL2 register. This register, and the associated fields, is
now generated as part of the sysreg framework. Move to using the
generated definitions instead of the hand-written ones.

There are no functional changes as part of this change.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/sysreg.h      | 21 ---------
 arch/arm64/kvm/hyp/vgic-v3-sr.c      | 64 ++++++++++++----------------
 arch/arm64/kvm/vgic/vgic-v3-nested.c |  8 ++--
 arch/arm64/kvm/vgic/vgic-v3.c        | 48 ++++++++++-----------
 4 files changed, 54 insertions(+), 87 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysre=
g.h
index 9df51accbb025..b3b8b8cd7bf1e 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -560,7 +560,6 @@
 #define SYS_ICC_SRE_EL2			sys_reg(3, 4, 12, 9, 5)
 #define SYS_ICH_EISR_EL2		sys_reg(3, 4, 12, 11, 3)
 #define SYS_ICH_ELRSR_EL2		sys_reg(3, 4, 12, 11, 5)
-#define SYS_ICH_VMCR_EL2		sys_reg(3, 4, 12, 11, 7)
=20
 #define __SYS__LR0_EL2(x)		sys_reg(3, 4, 12, 12, x)
 #define SYS_ICH_LR0_EL2			__SYS__LR0_EL2(0)
@@ -988,26 +987,6 @@
 #define ICH_LR_PRIORITY_SHIFT	48
 #define ICH_LR_PRIORITY_MASK	(0xffULL << ICH_LR_PRIORITY_SHIFT)
=20
-/* ICH_VMCR_EL2 bit definitions */
-#define ICH_VMCR_ACK_CTL_SHIFT	2
-#define ICH_VMCR_ACK_CTL_MASK	(1 << ICH_VMCR_ACK_CTL_SHIFT)
-#define ICH_VMCR_FIQ_EN_SHIFT	3
-#define ICH_VMCR_FIQ_EN_MASK	(1 << ICH_VMCR_FIQ_EN_SHIFT)
-#define ICH_VMCR_CBPR_SHIFT	4
-#define ICH_VMCR_CBPR_MASK	(1 << ICH_VMCR_CBPR_SHIFT)
-#define ICH_VMCR_EOIM_SHIFT	9
-#define ICH_VMCR_EOIM_MASK	(1 << ICH_VMCR_EOIM_SHIFT)
-#define ICH_VMCR_BPR1_SHIFT	18
-#define ICH_VMCR_BPR1_MASK	(7 << ICH_VMCR_BPR1_SHIFT)
-#define ICH_VMCR_BPR0_SHIFT	21
-#define ICH_VMCR_BPR0_MASK	(7 << ICH_VMCR_BPR0_SHIFT)
-#define ICH_VMCR_PMR_SHIFT	24
-#define ICH_VMCR_PMR_MASK	(0xffUL << ICH_VMCR_PMR_SHIFT)
-#define ICH_VMCR_ENG0_SHIFT	0
-#define ICH_VMCR_ENG0_MASK	(1 << ICH_VMCR_ENG0_SHIFT)
-#define ICH_VMCR_ENG1_SHIFT	1
-#define ICH_VMCR_ENG1_MASK	(1 << ICH_VMCR_ENG1_SHIFT)
-
 /*
  * Permission Indirection Extension (PIE) permission encodings.
  * Encodings with the _O suffix, have overlays applied (Permission Overlay=
 Extension).
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-s=
r.c
index 0b670a033fd87..24a2074f3a8cf 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -569,11 +569,11 @@ static int __vgic_v3_highest_priority_lr(struct kvm_v=
cpu *vcpu, u32 vmcr,
 			continue;
=20
 		/* Group-0 interrupt, but Group-0 disabled? */
-		if (!(val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_ENG0_MASK))
+		if (!(val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_EL2_VENG0_MASK))
 			continue;
=20
 		/* Group-1 interrupt, but Group-1 disabled? */
-		if ((val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_ENG1_MASK))
+		if ((val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_EL2_VENG1_MASK))
 			continue;
=20
 		/* Not the highest priority? */
@@ -646,19 +646,19 @@ static int __vgic_v3_get_highest_active_priority(void=
)
=20
 static unsigned int __vgic_v3_get_bpr0(u32 vmcr)
 {
-	return (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
+	return FIELD_GET(ICH_VMCR_EL2_VBPR0, vmcr);
 }
=20
 static unsigned int __vgic_v3_get_bpr1(u32 vmcr)
 {
 	unsigned int bpr;
=20
-	if (vmcr & ICH_VMCR_CBPR_MASK) {
+	if (vmcr & ICH_VMCR_EL2_VCBPR_MASK) {
 		bpr =3D __vgic_v3_get_bpr0(vmcr);
 		if (bpr < 7)
 			bpr++;
 	} else {
-		bpr =3D (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
+		bpr =3D FIELD_GET(ICH_VMCR_EL2_VBPR1, vmcr);
 	}
=20
 	return bpr;
@@ -758,7 +758,7 @@ static void __vgic_v3_read_iar(struct kvm_vcpu *vcpu, u=
32 vmcr, int rt)
 	if (grp !=3D !!(lr_val & ICH_LR_GROUP))
 		goto spurious;
=20
-	pmr =3D (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
+	pmr =3D FIELD_GET(ICH_VMCR_EL2_VPMR, vmcr);
 	lr_prio =3D (lr_val & ICH_LR_PRIORITY_MASK) >> ICH_LR_PRIORITY_SHIFT;
 	if (pmr <=3D lr_prio)
 		goto spurious;
@@ -806,7 +806,7 @@ static int ___vgic_v3_write_dir(struct kvm_vcpu *vcpu, =
u32 vmcr, int rt)
 	int lr;
=20
 	/* EOImode =3D=3D 0, nothing to be done here */
-	if (!(vmcr & ICH_VMCR_EOIM_MASK))
+	if (!FIELD_GET(ICH_VMCR_EL2_VEOIM_MASK, vmcr))
 		return 1;
=20
 	/* No deactivate to be performed on an LPI */
@@ -849,7 +849,7 @@ static void __vgic_v3_write_eoir(struct kvm_vcpu *vcpu,=
 u32 vmcr, int rt)
 	}
=20
 	/* EOImode =3D=3D 1 and not an LPI, nothing to be done here */
-	if ((vmcr & ICH_VMCR_EOIM_MASK) && !(vid >=3D VGIC_MIN_LPI))
+	if (FIELD_GET(ICH_VMCR_EL2_VEOIM_MASK, vmcr) && !(vid >=3D VGIC_MIN_LPI))
 		return;
=20
 	lr_prio =3D (lr_val & ICH_LR_PRIORITY_MASK) >> ICH_LR_PRIORITY_SHIFT;
@@ -865,12 +865,12 @@ static void __vgic_v3_write_eoir(struct kvm_vcpu *vcp=
u, u32 vmcr, int rt)
=20
 static void __vgic_v3_read_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int rt=
)
 {
-	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG0_MASK));
+	vcpu_set_reg(vcpu, rt, !!FIELD_GET(ICH_VMCR_EL2_VENG0_MASK, vmcr));
 }
=20
 static void __vgic_v3_read_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt=
)
 {
-	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG1_MASK));
+	vcpu_set_reg(vcpu, rt, !!FIELD_GET(ICH_VMCR_EL2_VENG1_MASK, vmcr));
 }
=20
 static void __vgic_v3_write_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int r=
t)
@@ -878,9 +878,9 @@ static void __vgic_v3_write_igrpen0(struct kvm_vcpu *vc=
pu, u32 vmcr, int rt)
 	u64 val =3D vcpu_get_reg(vcpu, rt);
=20
 	if (val & 1)
-		vmcr |=3D ICH_VMCR_ENG0_MASK;
+		vmcr |=3D ICH_VMCR_EL2_VENG0_MASK;
 	else
-		vmcr &=3D ~ICH_VMCR_ENG0_MASK;
+		vmcr &=3D ~ICH_VMCR_EL2_VENG0_MASK;
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -890,9 +890,9 @@ static void __vgic_v3_write_igrpen1(struct kvm_vcpu *vc=
pu, u32 vmcr, int rt)
 	u64 val =3D vcpu_get_reg(vcpu, rt);
=20
 	if (val & 1)
-		vmcr |=3D ICH_VMCR_ENG1_MASK;
+		vmcr |=3D ICH_VMCR_EL2_VENG1_MASK;
 	else
-		vmcr &=3D ~ICH_VMCR_ENG1_MASK;
+		vmcr &=3D ~ICH_VMCR_EL2_VENG1_MASK;
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -916,10 +916,8 @@ static void __vgic_v3_write_bpr0(struct kvm_vcpu *vcpu=
, u32 vmcr, int rt)
 	if (val < bpr_min)
 		val =3D bpr_min;
=20
-	val <<=3D ICH_VMCR_BPR0_SHIFT;
-	val &=3D ICH_VMCR_BPR0_MASK;
-	vmcr &=3D ~ICH_VMCR_BPR0_MASK;
-	vmcr |=3D val;
+	vmcr &=3D ~ICH_VMCR_EL2_VBPR0_MASK;
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VBPR0, val);
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -929,17 +927,15 @@ static void __vgic_v3_write_bpr1(struct kvm_vcpu *vcp=
u, u32 vmcr, int rt)
 	u64 val =3D vcpu_get_reg(vcpu, rt);
 	u8 bpr_min =3D __vgic_v3_bpr_min();
=20
-	if (vmcr & ICH_VMCR_CBPR_MASK)
+	if (FIELD_GET(ICH_VMCR_EL2_VCBPR_MASK, val))
 		return;
=20
 	/* Enforce BPR limiting */
 	if (val < bpr_min)
 		val =3D bpr_min;
=20
-	val <<=3D ICH_VMCR_BPR1_SHIFT;
-	val &=3D ICH_VMCR_BPR1_MASK;
-	vmcr &=3D ~ICH_VMCR_BPR1_MASK;
-	vmcr |=3D val;
+	vmcr &=3D ~ICH_VMCR_EL2_VBPR1_MASK;
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VBPR1, val);
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -1029,19 +1025,15 @@ static void __vgic_v3_read_hppir(struct kvm_vcpu *v=
cpu, u32 vmcr, int rt)
=20
 static void __vgic_v3_read_pmr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
-	vmcr &=3D ICH_VMCR_PMR_MASK;
-	vmcr >>=3D ICH_VMCR_PMR_SHIFT;
-	vcpu_set_reg(vcpu, rt, vmcr);
+	vcpu_set_reg(vcpu, rt, FIELD_GET(ICH_VMCR_EL2_VPMR, vmcr));
 }
=20
 static void __vgic_v3_write_pmr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	u32 val =3D vcpu_get_reg(vcpu, rt);
=20
-	val <<=3D ICH_VMCR_PMR_SHIFT;
-	val &=3D ICH_VMCR_PMR_MASK;
-	vmcr &=3D ~ICH_VMCR_PMR_MASK;
-	vmcr |=3D val;
+	vmcr &=3D ~ICH_VMCR_EL2_VPMR_MASK;
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VPMR, val);
=20
 	write_gicreg(vmcr, ICH_VMCR_EL2);
 }
@@ -1064,9 +1056,9 @@ static void __vgic_v3_read_ctlr(struct kvm_vcpu *vcpu=
, u32 vmcr, int rt)
 	/* A3V */
 	val |=3D ((vtr >> 21) & 1) << ICC_CTLR_EL1_A3V_SHIFT;
 	/* EOImode */
-	val |=3D ((vmcr & ICH_VMCR_EOIM_MASK) >> ICH_VMCR_EOIM_SHIFT) << ICC_CTLR=
_EL1_EOImode_SHIFT;
+	val |=3D FIELD_GET(ICH_VMCR_EL2_VEOIM, vmcr) << ICC_CTLR_EL1_EOImode_SHIF=
T;
 	/* CBPR */
-	val |=3D (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
+	val |=3D FIELD_GET(ICH_VMCR_EL2_VCBPR, vmcr);
=20
 	vcpu_set_reg(vcpu, rt, val);
 }
@@ -1076,14 +1068,14 @@ static void __vgic_v3_write_ctlr(struct kvm_vcpu *v=
cpu, u32 vmcr, int rt)
 	u32 val =3D vcpu_get_reg(vcpu, rt);
=20
 	if (val & ICC_CTLR_EL1_CBPR_MASK)
-		vmcr |=3D ICH_VMCR_CBPR_MASK;
+		vmcr |=3D ICH_VMCR_EL2_VCBPR_MASK;
 	else
-		vmcr &=3D ~ICH_VMCR_CBPR_MASK;
+		vmcr &=3D ~ICH_VMCR_EL2_VCBPR_MASK;
=20
 	if (val & ICC_CTLR_EL1_EOImode_MASK)
-		vmcr |=3D ICH_VMCR_EOIM_MASK;
+		vmcr |=3D ICH_VMCR_EL2_VEOIM_MASK;
 	else
-		vmcr &=3D ~ICH_VMCR_EOIM_MASK;
+		vmcr &=3D ~ICH_VMCR_EL2_VEOIM_MASK;
=20
 	write_gicreg(vmcr, ICH_VMCR_EL2);
 }
diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgi=
c-v3-nested.c
index 61b44f3f2bf14..c9e35ec671173 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -202,16 +202,16 @@ u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu)
 	if ((hcr & ICH_HCR_EL2_NPIE) && !mi_state.pend)
 		reg |=3D ICH_MISR_EL2_NP;
=20
-	if ((hcr & ICH_HCR_EL2_VGrp0EIE) && (vmcr & ICH_VMCR_ENG0_MASK))
+	if ((hcr & ICH_HCR_EL2_VGrp0EIE) && (vmcr & ICH_VMCR_EL2_VENG0_MASK))
 		reg |=3D ICH_MISR_EL2_VGrp0E;
=20
-	if ((hcr & ICH_HCR_EL2_VGrp0DIE) && !(vmcr & ICH_VMCR_ENG0_MASK))
+	if ((hcr & ICH_HCR_EL2_VGrp0DIE) && !(vmcr & ICH_VMCR_EL2_VENG0_MASK))
 		reg |=3D ICH_MISR_EL2_VGrp0D;
=20
-	if ((hcr & ICH_HCR_EL2_VGrp1EIE) && (vmcr & ICH_VMCR_ENG1_MASK))
+	if ((hcr & ICH_HCR_EL2_VGrp1EIE) && (vmcr & ICH_VMCR_EL2_VENG1_MASK))
 		reg |=3D ICH_MISR_EL2_VGrp1E;
=20
-	if ((hcr & ICH_HCR_EL2_VGrp1DIE) && !(vmcr & ICH_VMCR_ENG1_MASK))
+	if ((hcr & ICH_HCR_EL2_VGrp1DIE) && !(vmcr & ICH_VMCR_EL2_VENG1_MASK))
 		reg |=3D ICH_MISR_EL2_VGrp1D;
=20
 	return reg;
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 1d6dd1b545bdd..2afc041672311 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -41,9 +41,9 @@ void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu,
 	if (!als->nr_sgi)
 		cpuif->vgic_hcr |=3D ICH_HCR_EL2_vSGIEOICount;
=20
-	cpuif->vgic_hcr |=3D (cpuif->vgic_vmcr & ICH_VMCR_ENG0_MASK) ?
+	cpuif->vgic_hcr |=3D (cpuif->vgic_vmcr & ICH_VMCR_EL2_VENG0_MASK) ?
 		ICH_HCR_EL2_VGrp0DIE : ICH_HCR_EL2_VGrp0EIE;
-	cpuif->vgic_hcr |=3D (cpuif->vgic_vmcr & ICH_VMCR_ENG1_MASK) ?
+	cpuif->vgic_hcr |=3D (cpuif->vgic_vmcr & ICH_VMCR_EL2_VENG1_MASK) ?
 		ICH_HCR_EL2_VGrp1DIE : ICH_HCR_EL2_VGrp1EIE;
=20
 	/*
@@ -215,7 +215,7 @@ void vgic_v3_deactivate(struct kvm_vcpu *vcpu, u64 val)
 	 * We only deal with DIR when EOIMode=3D=3D1, and only for SGI,
 	 * PPI or SPI.
 	 */
-	if (!(cpuif->vgic_vmcr & ICH_VMCR_EOIM_MASK) ||
+	if (!(cpuif->vgic_vmcr & ICH_VMCR_EL2_VEOIM_MASK) ||
 	    val >=3D vcpu->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS)
 		return;
=20
@@ -408,25 +408,23 @@ void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct v=
gic_vmcr *vmcrp)
 	u32 vmcr;
=20
 	if (model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
-		vmcr =3D (vmcrp->ackctl << ICH_VMCR_ACK_CTL_SHIFT) &
-			ICH_VMCR_ACK_CTL_MASK;
-		vmcr |=3D (vmcrp->fiqen << ICH_VMCR_FIQ_EN_SHIFT) &
-			ICH_VMCR_FIQ_EN_MASK;
+		vmcr =3D FIELD_PREP(ICH_VMCR_EL2_VAckCtl, vmcrp->ackctl);
+		vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VFIQEn, vmcrp->fiqen);
 	} else {
 		/*
 		 * When emulating GICv3 on GICv3 with SRE=3D1 on the
 		 * VFIQEn bit is RES1 and the VAckCtl bit is RES0.
 		 */
-		vmcr =3D ICH_VMCR_FIQ_EN_MASK;
+		vmcr =3D ICH_VMCR_EL2_VFIQEn_MASK;
 	}
=20
-	vmcr |=3D (vmcrp->cbpr << ICH_VMCR_CBPR_SHIFT) & ICH_VMCR_CBPR_MASK;
-	vmcr |=3D (vmcrp->eoim << ICH_VMCR_EOIM_SHIFT) & ICH_VMCR_EOIM_MASK;
-	vmcr |=3D (vmcrp->abpr << ICH_VMCR_BPR1_SHIFT) & ICH_VMCR_BPR1_MASK;
-	vmcr |=3D (vmcrp->bpr << ICH_VMCR_BPR0_SHIFT) & ICH_VMCR_BPR0_MASK;
-	vmcr |=3D (vmcrp->pmr << ICH_VMCR_PMR_SHIFT) & ICH_VMCR_PMR_MASK;
-	vmcr |=3D (vmcrp->grpen0 << ICH_VMCR_ENG0_SHIFT) & ICH_VMCR_ENG0_MASK;
-	vmcr |=3D (vmcrp->grpen1 << ICH_VMCR_ENG1_SHIFT) & ICH_VMCR_ENG1_MASK;
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VCBPR, vmcrp->cbpr);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VEOIM, vmcrp->eoim);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VBPR1, vmcrp->abpr);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VBPR0, vmcrp->bpr);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VPMR, vmcrp->pmr);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VENG0, vmcrp->grpen0);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VENG1, vmcrp->grpen1);
=20
 	cpu_if->vgic_vmcr =3D vmcr;
 }
@@ -440,10 +438,8 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vg=
ic_vmcr *vmcrp)
 	vmcr =3D cpu_if->vgic_vmcr;
=20
 	if (model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
-		vmcrp->ackctl =3D (vmcr & ICH_VMCR_ACK_CTL_MASK) >>
-			ICH_VMCR_ACK_CTL_SHIFT;
-		vmcrp->fiqen =3D (vmcr & ICH_VMCR_FIQ_EN_MASK) >>
-			ICH_VMCR_FIQ_EN_SHIFT;
+		vmcrp->ackctl =3D FIELD_GET(ICH_VMCR_EL2_VAckCtl, vmcr);
+		vmcrp->fiqen =3D FIELD_GET(ICH_VMCR_EL2_VFIQEn, vmcr);
 	} else {
 		/*
 		 * When emulating GICv3 on GICv3 with SRE=3D1 on the
@@ -453,13 +449,13 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct v=
gic_vmcr *vmcrp)
 		vmcrp->ackctl =3D 0;
 	}
=20
-	vmcrp->cbpr =3D (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
-	vmcrp->eoim =3D (vmcr & ICH_VMCR_EOIM_MASK) >> ICH_VMCR_EOIM_SHIFT;
-	vmcrp->abpr =3D (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
-	vmcrp->bpr  =3D (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
-	vmcrp->pmr  =3D (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
-	vmcrp->grpen0 =3D (vmcr & ICH_VMCR_ENG0_MASK) >> ICH_VMCR_ENG0_SHIFT;
-	vmcrp->grpen1 =3D (vmcr & ICH_VMCR_ENG1_MASK) >> ICH_VMCR_ENG1_SHIFT;
+	vmcrp->cbpr =3D FIELD_GET(ICH_VMCR_EL2_VCBPR, vmcr);
+	vmcrp->eoim =3D FIELD_GET(ICH_VMCR_EL2_VEOIM, vmcr);
+	vmcrp->abpr =3D FIELD_GET(ICH_VMCR_EL2_VBPR1, vmcr);
+	vmcrp->bpr  =3D FIELD_GET(ICH_VMCR_EL2_VBPR0, vmcr);
+	vmcrp->pmr  =3D FIELD_GET(ICH_VMCR_EL2_VPMR, vmcr);
+	vmcrp->grpen0 =3D FIELD_GET(ICH_VMCR_EL2_VENG0, vmcr);
+	vmcrp->grpen1 =3D FIELD_GET(ICH_VMCR_EL2_VENG1, vmcr);
 }
=20
 #define INITIAL_PENDBASER_VALUE						  \
--=20
2.34.1

