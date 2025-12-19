Return-Path: <kvm+bounces-66358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B9EFCCD0A79
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:58:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 49F2031048C6
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 15:54:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EA30364022;
	Fri, 19 Dec 2025 15:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GWAZUJQ3";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GWAZUJQ3"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011061.outbound.protection.outlook.com [40.107.130.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24CD361DDE
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.61
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159635; cv=fail; b=Yuoo08ZqcAqcEnQiv0BeK89yJ3B3QD35RQ7M7ZYCBFUkoWAp0h5xExhkHbxhIUL2o1FBoIVwolrQZPFwgl3IqAXs56cItfVhrlN5wfgojjw8vxvKZk7xPlKbR43xvj8gojgUMoJ6T9OfKtvPwXSlttJYFDOX5VxncH9gfX+OBEc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159635; c=relaxed/simple;
	bh=SsaOCVUNKbsxeoRm0MefRnkjUyFKaQ650LOAyTmYvL4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dY1FP2EFAUCKgvrcCEwGT62MS/z6lO+5Xt8HVu+2Fr/dpxDaZu/bnkilG09Rlirgx1/CnZNqCu7UnHf1jo1K3xaH0sV2Dzl8ZUs/vAQ5iclyQ94H6iurUirNL8tJeXVGN//SuxIElxhlBZlpBPqx51yFc+iWm/qxhnlfWTkOduA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GWAZUJQ3; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GWAZUJQ3; arc=fail smtp.client-ip=40.107.130.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=xs9Mnr4IQ7LCtcfR959T9ie4ahJ1Ojqmw565ZjOYT/QNwFv9rOP02ELpzWMnpVgDp7lsRmpC+ZoxNclyKxIh+mR/lf5l6oBj7ys+UZEe9xOYbffpK3n9iAB6Ejtb06G/kSaVXDdxW7yNTeJnKxpkqJdBjFlQEUO/C672xjx/v/oIcjYa+7D2kw7PoW7AcFQZVhoa8kB+2tPrg5plnMn4B9qDBErO0YLtRjLkuV70cCC/CW26rXBHuBhMY7ZcDynGEQRUD9FNvS9GrvB9cSbEMjU0db7eRcrOndtRY+d1I2JN5pYP8LNd0aXm3+M56RjnDjyq2VX4wqPgKMc7g8GzJA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PawtP/yyVguTfA//yNWv3/ElFM6gQ3HXv0vuxoXf2LM=;
 b=Zs/gIS7Y/fkX6px7jTP6imvaF32tFFmy8jj5AF9wQg6GzApuQ/pGRHPoy3i6j9JSOX4HjSKOwTW1ufiyYR8ctcGkR2dit1Aid0daRCa9Js/A9UIt7gYb4NVhkLTYY7AoVRTOZRSRvxHelY5OApoREuyPBgAuGIDlOtcYTlBVEduBrrXUiZdu7Pad45ZldI6FjGiBuZGGHQtwEMH1Y2I2uKNwEkTY/kn5xYDbNgOBK3xPJDc6Vn217X+UqUWsWV7ZBQzdtdywRVvi9GRLI6eM/F/GGZG+0ZdjYjPkE1BABC7xT9ZJmksBTNddGe6cAI3pm2KrGFZ96UkK1id7hR98AQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PawtP/yyVguTfA//yNWv3/ElFM6gQ3HXv0vuxoXf2LM=;
 b=GWAZUJQ3Fh0EFHeUbY4/3x6xGfnzqeSkkTa8gIVPUhHn9aj9EipGiyXxe8Ix0VTVzjktOiOmDrQoVY7kCFQyYtk2P7NGR7O49gJkdgMg8M5Pv3diYNl03eK/29jYP6jbPAhqAZqgPruCTijj+EhCHuoxKEXtQ0k6Dm+f6WOa8hY=
Received: from DU6P191CA0058.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53e::29)
 by DU0PR08MB9371.eurprd08.prod.outlook.com (2603:10a6:10:421::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:53:44 +0000
Received: from DU2PEPF00028D00.eurprd03.prod.outlook.com
 (2603:10a6:10:53e:cafe::9e) by DU6P191CA0058.outlook.office365.com
 (2603:10a6:10:53e::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.9 via Frontend Transport; Fri,
 19 Dec 2025 15:53:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D00.mail.protection.outlook.com (10.167.242.184) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 19 Dec 2025 15:53:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K15EbC3bT/tW7FshbaqFJQg4i8ajAREoXSBMbQ8xy5cCQ5c7qasYpF8CcWBuGdRJ1gqzKLSUD72kK05OcyyI4IN3wBju08ej0do3KTWKaHQMmRDfibkVpDGCdggE3mIBwnwdPOLrXXdmDRClSYcrKNQv7OMSDy5qu0XkNNC3MBXpnyHAIuUGDR6taOFHaLF/GuU1Ch6F60RGhhA6cA5CEPREEEcjgOS9XG57LX6L8F7slPaTox05qgeMWA9+QTyhyY1kIwj/t7/EA9MTKjz4+nYzruDs+rc8l2f5njBu8/mcjIAWW6/EwO8hrf8U4zDTgzC0lH8U+XaOR3VJVyB9xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PawtP/yyVguTfA//yNWv3/ElFM6gQ3HXv0vuxoXf2LM=;
 b=v5cOfCEjr7CeOA2FdTrqrym/JcMbQ9cCKkdwWJfjScSgaW46dCI/T4bkSxiJ3psECIYiJ+o2FeOKkKraaJuTKbGOK/5xnY3rNfLAInMBcezh+MqkcTCz2i2+gdkp4gQZbqmMsJetDE+AkpSgKfOru8Sg7Irt3lO2ezLevTNvtL4AVM5uGDGZ7yu1zkjiI+gqXV9Hu8XlIv4IRRVzJhmkZbOD3ZMT42K76rVLjNiG0APUGqR0ZwCXBpby7R2Nl7wRYuus2Xk1EALQo4g4sN3/6lhCPJl9hCTHM67lwDJmtwl353dymNr50kW+EglRPG2jQumiead7p7jRIKPCLlcK0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PawtP/yyVguTfA//yNWv3/ElFM6gQ3HXv0vuxoXf2LM=;
 b=GWAZUJQ3Fh0EFHeUbY4/3x6xGfnzqeSkkTa8gIVPUhHn9aj9EipGiyXxe8Ix0VTVzjktOiOmDrQoVY7kCFQyYtk2P7NGR7O49gJkdgMg8M5Pv3diYNl03eK/29jYP6jbPAhqAZqgPruCTijj+EhCHuoxKEXtQ0k6Dm+f6WOa8hY=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AM8PR08MB6546.eurprd08.prod.outlook.com (2603:10a6:20b:355::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:52:40 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:52:40 +0000
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
Subject: [PATCH v2 10/36] KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE
Thread-Topic: [PATCH v2 10/36] KVM: arm64: gic-v5: Sanitize
 ID_AA64PFR2_EL1.GCIE
Thread-Index: AQHccP+A2Tk0cVHCD0G6AA5H+3aHGQ==
Date: Fri, 19 Dec 2025 15:52:39 +0000
Message-ID: <20251219155222.1383109-11-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|AM8PR08MB6546:EE_|DU2PEPF00028D00:EE_|DU0PR08MB9371:EE_
X-MS-Office365-Filtering-Correlation-Id: af548c24-2adb-492c-6130-08de3f16c9cd
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?HURFh1sRig94oqCv7OPdlqnuv1Q5jRNdq9Nsezys1L2kOERM4PzM3MiXMu?=
 =?iso-8859-1?Q?laFuSiwCJoD/4JhD9j7gOZUJe9HJ1JciixkFoCajlxDyFI1wxm4lO7Ixkj?=
 =?iso-8859-1?Q?4Sx6xpBtYke8AE8xfejSGVT0PdfGeDArPPwf1VbsODV5IK09Ee6y1s5YQ3?=
 =?iso-8859-1?Q?twagkd4GC7Mn2NvC4MHUgh+qjHUao7ZUmSE7FpKx5/o1EhaA72KNWr7KQt?=
 =?iso-8859-1?Q?J8p4dvY2SA3V5vY/V6bng+JFzaHCfksjs/1HymswbYX+wuN82ls5rp+ljs?=
 =?iso-8859-1?Q?hLfr8sjfUGQyBCuxFnj1D6FB/2nHwpP6tG2jNdXZsQdawc/hUTfzNYJd8/?=
 =?iso-8859-1?Q?YQz80vADryGA74unL8l5iKAvtOkpcSQh+QZEeFSxWwj4EIvwDD4F2swsLy?=
 =?iso-8859-1?Q?yRytx6nD8jFy7GjVQnQni91YLFljk31EuiZAiz3wpaYkiLtlhiuxoXBGi/?=
 =?iso-8859-1?Q?VaPblzLkiMTuNk2u4alsa+4k9Atvg4DVT58qS1nIiXU5Lp9wYwIsAYXFGw?=
 =?iso-8859-1?Q?rJ7MWBwqu73pQXJzjYYgX4iHbcJ4zYvFVY9VYTtCaFiQzm6x8VuWdr5EJf?=
 =?iso-8859-1?Q?VPRILBXRZ4xHc0npgE28PrzXQ2kXkT7ARysZ3SRXvmSlfB1btaqhAQwOs5?=
 =?iso-8859-1?Q?SWvbQeXcAQI+vE7Sy/B8EwIykPP8e9cWC+lXnrBgSZpmlgWw90FZJXildl?=
 =?iso-8859-1?Q?Hl3CSvKH8gd3g+m2coiKHdU1n91snSWF4S8udW8erDu2vjTr6G5MHnm8Pw?=
 =?iso-8859-1?Q?3cmXMYZxALy7HlpMLtCAvZ/r57jb9PDQJvjQ71DHyNSr3A+8THsVTB9KsU?=
 =?iso-8859-1?Q?oIvB0VrFTWCKNwpSjVt1dfXtp1OKhjHWH3nkFYBOYpsKnvlL8lhvXG72Qd?=
 =?iso-8859-1?Q?QrJBTnSKE8okqb+t7J2U9I83LS/WabiqwuHp/B6sxsLZUia1JWfhI2TeK9?=
 =?iso-8859-1?Q?JHBFCjf2rKNTRM0Hh7frIKdidXDiGcVBPx2PEjdduBkhGthhBd5fH9X/3H?=
 =?iso-8859-1?Q?ctsv4YVRqzOrudC+hXbWOQ9glfDM4ojGLFB18WIp72pqDH+1HZ7QESGt3m?=
 =?iso-8859-1?Q?DAA6ML8MmSHK9WHAc1Ovi15vO9CEkh/Z7lnLUEBHQPX5/pMKEU3sMTcPyy?=
 =?iso-8859-1?Q?1mZB2L1OTeeCImXqZhUd7q5Ssp2meGdCqcBYA9RBkPhbT5RBkzOmQkpL6b?=
 =?iso-8859-1?Q?1lDYZj+EqBix5HQk9NKxCAUtTqiTYBopC0LAK3KTe3vYvle7jHaLexs2of?=
 =?iso-8859-1?Q?7slg9f+V8VW/UEoG60ckCEpD/yRO7IU1Cu2+k6Cp2XzE5V8ImPG6rgOOLg?=
 =?iso-8859-1?Q?XRCV/qFK1D4M4ytn0nfsTG/8ZFabG7ZjOljkirrkveIlAc0kFXYUl/zf6c?=
 =?iso-8859-1?Q?LJn/4rJglFg91lGWRZpPgIKgacGD5V086Huwgt83ubGbySsq8XAmJTvLoU?=
 =?iso-8859-1?Q?Qgdm2uhJTtop6nWktxE8t56BabxE1WNDwCYJ0qCtmhnQ0imZWGbELWa6mP?=
 =?iso-8859-1?Q?zrJY9Hk4jT1L1C7+0kFUNJSK/Da1VH1+wDtPdHVxUPmvMlmh+3TLwX7SFB?=
 =?iso-8859-1?Q?DatmFXhYBsa1O4Dl+CjDT35soPXk?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6546
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D00.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c1760636-bedc-47df-8b85-08de3f16a3de
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|35042699022|14060799003|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?FXY+bTqXmE3f86qmGr+YM2FujXolfxNQ+vU+Ze4dOQBnh1Gab8I7gyxvLr?=
 =?iso-8859-1?Q?n4A1L3mWv5bGqH3aVElWA6NHEihpBea0MiCVGnf0Vylm6Fc8b3AlS3YU2f?=
 =?iso-8859-1?Q?uRGpABFAtiCqGEKKyWOiVgNcKyytvFZmeorLUfzMky9y4YnhUikL4SbNuX?=
 =?iso-8859-1?Q?r0A99hhpjpLXsMC+7Efp+2hhs8hMs6NLQT7LXYtcdAiPYXw9DeVnVWq6U7?=
 =?iso-8859-1?Q?TaXObyJ5svhsn+rAgrjSHRmc783hKtMu7tEBBqmCTkShelM8rryyrcOvps?=
 =?iso-8859-1?Q?KWd9ydqoOxACav6ueduTSiWJVoaK5RqLUMRS+eNJqaNzW3S48z22oCHVas?=
 =?iso-8859-1?Q?kk4nJmhlqmDOz5Y0kQ6zS5dXBvjX/iDUN32y8KwgVugaaKuH79DOCplEtp?=
 =?iso-8859-1?Q?dKsOfbiGib/A42oPuO+rUQ2CrHEVYMTaJXHSibx+ZLJWgkI2fqtuICll5e?=
 =?iso-8859-1?Q?lLPO/j/J/FWmSaX/vnLviqlidwfO5NKYd3MY6DfzD0u8abfTZ6qp3prRgt?=
 =?iso-8859-1?Q?TSu36jxU791sy1XFpPQTeWWiZrnsvFWf5mPHdo8Nu8EIRDgNYQy8LWBSlK?=
 =?iso-8859-1?Q?xGn7NT1Q9MOPTq3+rEvdcm/ow0gOgcCb+0eytz9ODzdJihY/u2jwgsD8Sp?=
 =?iso-8859-1?Q?augozBgdpD5F0sAyN0bj5yj23ufaNEpEqiHmmxctgimi7CZNvD65Cqbgrh?=
 =?iso-8859-1?Q?4Y0mdvNJDWKmY0IX+STKcW2DX7nXmUyVDBdMVYLJN56i+rPVJhTUz2X53g?=
 =?iso-8859-1?Q?HUWP9n/8rPPFclg9oeYLQRlO2DekHTiK2D2w75mfOiUSuHwKi0EYU2bfVY?=
 =?iso-8859-1?Q?BMv7v9daUIgHcKYxU3YG7NTHis0k7KjtfHg6wUwbVfOV0P+0rPVOF+gwX+?=
 =?iso-8859-1?Q?uPGXqo8JEly35xKGYnA1VICqL4Kcs3s+n21tdm4CSJsGRD1Wez3pC5hHDY?=
 =?iso-8859-1?Q?V5vMW/YCS0Qv5+uAu2tOIS8oWagPM4IAbh9PF7Bx7qvgFymOZjk5sxkW19?=
 =?iso-8859-1?Q?skejWzR9eqMnKp5V4KG4EIi0XuwTarfNup7j+/w0dM42slXhtHb+++K/cy?=
 =?iso-8859-1?Q?PCyrQu0OfiuY5I1+aT8K6V1DZmFsyjR0lXDj40srYqGnYcWjWOPHypqP55?=
 =?iso-8859-1?Q?PdrEGmqGsFnBG3jkOhjYO0h8Sy9IxaanCF/Rbunb7D5WAwHqUkOwR0Hyye?=
 =?iso-8859-1?Q?3NB0VeiNAjt31lEzCXM5ZUEi9mq4mhx24tYqFrr6v0aB4dzCNb6cSsM7zG?=
 =?iso-8859-1?Q?Oc5hcPPq/BnJeM3QXTwY1ty1VITt9EkkugDV5lU/b7m8SzmqAZy7qae8le?=
 =?iso-8859-1?Q?2+hzehq/C1i61/BFRXZaleshxW7z8dEnesZTovdfQGAb1HOwoQRdbxAEFt?=
 =?iso-8859-1?Q?2i95KjkqhtncoPQrV2UX7hcVw6tRa4z0pncCJ++EqzLOEzHzFlrj3nAjQu?=
 =?iso-8859-1?Q?1pONLd4ypa2dAQR3iAiMf+8S4M+svZjRcH/1QK3JCqeh98VYyF72Z47bWq?=
 =?iso-8859-1?Q?uAocZjcrSkp+wsx1VA1ixzJoOfhLNGmHcsGWmF48uUY5IYjaUiu0ySR8BV?=
 =?iso-8859-1?Q?pGh6VP5436zTc8w3Eo4a4mjAkRclTKCvwA/AOWaSR3TBiH4/qKowz8vpsq?=
 =?iso-8859-1?Q?bmegi1WsTqHig=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(35042699022)(14060799003)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:43.9609
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af548c24-2adb-492c-6130-08de3f16c9cd
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D00.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9371

Set the guest's view of the GCIE field to IMP when running a GICv5 VM,
NI otherwise. Reject any writes to the register that try to do
anything but set GCIE to IMP when running a GICv5 VM.

As part of this change, we also introduce vgic_is_v5(kvm), in order to
check if the guest is a GICv5-native VM. We're also required to extend
vgic_is_v3_compat to check for the actual vgic_model. This has one
potential issue - if any of the vgic_is_v* checks are used prior to
setting the vgic_model (that is, before kvm_vgic_create) then
vgic_model will be set to 0, which can result in a false-positive.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/sys_regs.c  | 39 ++++++++++++++++++++++++++++++--------
 arch/arm64/kvm/vgic/vgic.h | 10 +++++++++-
 2 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c8fd7c6a12a13..a065f8939bc8f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1758,6 +1758,7 @@ static u8 pmuver_to_perfmon(u8 pmuver)
=20
 static u64 sanitise_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
 static u64 sanitise_id_aa64pfr1_el1(const struct kvm_vcpu *vcpu, u64 val);
+static u64 sanitise_id_aa64pfr2_el1(const struct kvm_vcpu *vcpu, u64 val);
 static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
=20
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
@@ -1783,10 +1784,7 @@ static u64 __kvm_read_sanitised_id_reg(const struct =
kvm_vcpu *vcpu,
 		val =3D sanitise_id_aa64pfr1_el1(vcpu, val);
 		break;
 	case SYS_ID_AA64PFR2_EL1:
-		val &=3D ID_AA64PFR2_EL1_FPMR |
-			(kvm_has_mte(vcpu->kvm) ?
-			 ID_AA64PFR2_EL1_MTEFAR | ID_AA64PFR2_EL1_MTESTOREONLY :
-			 0);
+		val =3D sanitise_id_aa64pfr2_el1(vcpu, val);
 		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
@@ -2024,6 +2022,20 @@ static u64 sanitise_id_aa64pfr1_el1(const struct kvm=
_vcpu *vcpu, u64 val)
 	return val;
 }
=20
+static u64 sanitise_id_aa64pfr2_el1(const struct kvm_vcpu *vcpu, u64 val)
+{
+	val &=3D ID_AA64PFR2_EL1_FPMR |
+		(kvm_has_mte(vcpu->kvm) ?
+			ID_AA64PFR2_EL1_MTEFAR | ID_AA64PFR2_EL1_MTESTOREONLY : 0);
+
+	if (vgic_is_v5(vcpu->kvm)) {
+		val &=3D ~ID_AA64PFR2_EL1_GCIE_MASK;
+		val |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR2_EL1, GCIE, IMP);
+	}
+
+	return val;
+}
+
 static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
 {
 	val =3D ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, V8P8);
@@ -2221,6 +2233,16 @@ static int set_id_aa64pfr1_el1(struct kvm_vcpu *vcpu=
,
 	return set_id_reg(vcpu, rd, user_val);
 }
=20
+static int set_id_aa64pfr2_el1(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *rd, u64 user_val)
+{
+	if (vgic_is_v5(vcpu->kvm) &&
+	    FIELD_GET(ID_AA64PFR2_EL1_GCIE_MASK, user_val) !=3D ID_AA64PFR2_EL1_G=
CIE_IMP)
+		return -EINVAL;
+
+	return set_id_reg(vcpu, rd, user_val);
+}
+
 /*
  * Allow userspace to de-feature a stage-2 translation granule but prevent=
 it
  * from claiming the impossible.
@@ -3202,10 +3224,11 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
 				       ID_AA64PFR1_EL1_RES0 |
 				       ID_AA64PFR1_EL1_MPAM_frac |
 				       ID_AA64PFR1_EL1_MTE)),
-	ID_WRITABLE(ID_AA64PFR2_EL1,
-		    ID_AA64PFR2_EL1_FPMR |
-		    ID_AA64PFR2_EL1_MTEFAR |
-		    ID_AA64PFR2_EL1_MTESTOREONLY),
+	ID_FILTERED(ID_AA64PFR2_EL1, id_aa64pfr2_el1,
+		    ~(ID_AA64PFR2_EL1_FPMR |
+		      ID_AA64PFR2_EL1_MTEFAR |
+		      ID_AA64PFR2_EL1_MTESTOREONLY |
+		      ID_AA64PFR2_EL1_GCIE)),
 	ID_UNALLOCATED(4,3),
 	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
 	ID_HIDDEN(ID_AA64SMFR0_EL1),
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 15f6afe6b75e1..eb16184c14cc5 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -456,8 +456,16 @@ void vgic_v3_nested_update_mi(struct kvm_vcpu *vcpu);
=20
 static inline bool vgic_is_v3_compat(struct kvm *kvm)
 {
+	/*
+	 * We need to be careful here. This could be called early,
+	 * which means that there is no vgic_model set. For the time
+	 * being, fall back to assuming that we're trying run a legacy
+	 * VM in that case, which keeps existing software happy. Long
+	 * term, this will need to be revisited a little.
+	 */
 	return cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF) &&
-		kvm_vgic_global_state.has_gcie_v3_compat;
+		kvm_vgic_global_state.has_gcie_v3_compat &&
+		kvm->arch.vgic.vgic_model !=3D KVM_DEV_TYPE_ARM_VGIC_V5;
 }
=20
 static inline bool vgic_is_v3(struct kvm *kvm)
--=20
2.34.1

