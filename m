Return-Path: <kvm+bounces-65869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AFCECB9210
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:29:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 457F73124572
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:24:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 410BE32573B;
	Fri, 12 Dec 2025 15:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FF7olvtJ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FF7olvtJ"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011036.outbound.protection.outlook.com [52.101.70.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8593233E8
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553041; cv=fail; b=IEf2AxoBRTDNxSu2/NXIdWad/ediTEGQ75QkXFwZJZ84bWzs/qe7KrbpfWV4mSuOKFwz4AEruvGiIe5G6JXdEhGx5cXmfa2XhLEZ5sZegG/sf3iUaV4V2wB59uirRjuTMTuSmQfKT0tBG6ytcDe1bA8zLTiJ22Pxy0Zl7cV0UWo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553041; c=relaxed/simple;
	bh=Gp9zuK6f0HFBxtArxHPwK4Q/+No7ECk2eraUsLhI1OI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OfQhkBh7X+z09Nb/Np0aGNNhLY/lE3Gp1HYMW2WGOVOXdUa+tKXIdFKGgDh7FdCQHKNQGVpBkxm5cPhKOVMLI6hMu0CyTC/YpowtjAFAB1nBOwDWAdn4tcwMscx7yZXvskEoImcw73lPvjQJ0RZJpyI7DOANbIk3Vx63F2R/bhk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FF7olvtJ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FF7olvtJ; arc=fail smtp.client-ip=52.101.70.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=pzk3h7dO4axden6PrMyCUFXXfYorht+cURPiuqU5pzcV19knZjuCyDl02OSZHtDMn0AMkQIK9vHRsUBLKypxleWuEkl7ndUroMpLUwOnttbfyo6mqayFxkdd/MvvQZnw4HiNs84aKMY8AYOT1fGvsR9SgdkKEXDsLcBLvb9Jm1xrpONu0PQn6Y+Jh9XyZlqDn+Lf4I8jr3fgTc7QePEQAxRtxbwzKqMDLoscREK9xb5ubqH0YcOk6H6Sn+ZQE4JYvUzDG44lNOePMBHEfzwYIO9XPLCQvm85dDYj8dWuqppZNUYFOJozqymMC6jbyTz1VAIg8AHjmKDuEZcCeMPzAQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tpgaxj/MF+3xMeZHR+6Cxvg8GcbunoT8BsQiDq6p41c=;
 b=gsGNFZ9+01bi9/y9CLE8SWuhLjaR89kbJvbHFlFfkb/mE2GCzj1siKxkU3qXW0MufTmbXjk84Whn1Pxe9x/do3oA11nNpVJ0Z2G1y2YTvUX+uSiEUy/IS34cAI9SWmFZuuVw0GxOotHHuWDoyLK5liJV4jGzJid36DnQU26Undr/x8y1IJBE0N0ttdD75lCMCdbtQ4N/Py9meAN27bdWWzo0jWtze/osZKgK193Af3UzcueUI1jItmKsP44bZCTJVrKdxfQPYqgJXsU9iOYEcYnxlSnLAaB51v5E98bXMhuUrZz66UIamj0DZHyJCAvywzYwUXVKyRS9QMo40YgqUA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tpgaxj/MF+3xMeZHR+6Cxvg8GcbunoT8BsQiDq6p41c=;
 b=FF7olvtJwxqhw4EC5Vf0mdJ8IkS3a3x/lpssezr6gy4MtfO3Ei3TSPEO2mi/q9WsHEKHyEOnEc4SKEcJdIq+NftIRMw/MGGjRcmsqqlM04URJmVzPBwhEGQIVkM7bLHZqcB4psTtpyYz2dxNxRYg6Zr0zrkUCkVELi9EDK0HXSk=
Received: from AS4P195CA0003.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:5e2::9)
 by DU5PR08MB10561.eurprd08.prod.outlook.com (2603:10a6:10:51f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.11; Fri, 12 Dec
 2025 15:23:53 +0000
Received: from AMS0EPF000001A4.eurprd05.prod.outlook.com
 (2603:10a6:20b:5e2:cafe::46) by AS4P195CA0003.outlook.office365.com
 (2603:10a6:20b:5e2::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.11 via Frontend Transport; Fri,
 12 Dec 2025 15:23:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A4.mail.protection.outlook.com (10.167.16.229) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 12 Dec 2025 15:23:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WIICUkxqR295vq8t34rJzp3Zr4C+X6Z0YC3YopEpPRM2rHiALvLm6NZIgj3Zib60OeEleqsTovEPrbTKhFPNqiY7N84HGGAJK6q77H0XW2r6kdU+2rxvxwgmeMcF3bavAFvTxdqkw+3QOj4fx6xjXxVr2DZKQOrODU97dXCiLWJJKlh4xQEirpDl/TRXmyoR1P9pPFODqOxjJUq5XT7yoT+QWjTw1TL4qpp1ljXcKBaiwXuT49jzlBwTl4SnXARxcDd3HosARMXpASv1I9oFHvlFMprZrefaUgrytqP1bdJT5sf3RmYeLK7id5RbfSzBnagHk37nKRiF1UnoxWhKqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tpgaxj/MF+3xMeZHR+6Cxvg8GcbunoT8BsQiDq6p41c=;
 b=O3PYMRWuUFQlRI6h4xDsI7tIpQ1RoGWxGd+gwJFJn/K10RI9+P+potOdCrypmoClN9sqTV3Ikb1yjgWj5EUHl79FOe9WDQp970tkbrhSXfMxHMGruci+tNTqh+NzDU67jjhrmJ1oP5XoZ3h8ScKx0LkR8wKibkmDUtqZxcPUqcMrDu0aFiLOGMFzSry3TDd1hmeePASrs7sGGolB0JxMSdIgflKaXYt+bKb0kBDL9XYOCQYqmCnHRI/NF57sy9vh7oCOY5UlA6OtS6rnpP7DN8M8eMNuaftl8MLOcxIxcU7D29V0AciwVV42TFDKkBPwrAnphs2evEGQkyas0/4CNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tpgaxj/MF+3xMeZHR+6Cxvg8GcbunoT8BsQiDq6p41c=;
 b=FF7olvtJwxqhw4EC5Vf0mdJ8IkS3a3x/lpssezr6gy4MtfO3Ei3TSPEO2mi/q9WsHEKHyEOnEc4SKEcJdIq+NftIRMw/MGGjRcmsqqlM04URJmVzPBwhEGQIVkM7bLHZqcB4psTtpyYz2dxNxRYg6Zr0zrkUCkVELi9EDK0HXSk=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AS8PR08MB9386.eurprd08.prod.outlook.com (2603:10a6:20b:5a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Fri, 12 Dec
 2025 15:22:49 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:49 +0000
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
Subject: [PATCH 28/32] KVM: arm64: gic-v5: Set ICH_VCTLR_EL2.En on boot
Thread-Topic: [PATCH 28/32] KVM: arm64: gic-v5: Set ICH_VCTLR_EL2.En on boot
Thread-Index: AQHca3sqr9Qyfzd5JkG4QIGxkJVO9w==
Date: Fri, 12 Dec 2025 15:22:44 +0000
Message-ID: <20251212152215.675767-29-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|AS8PR08MB9386:EE_|AMS0EPF000001A4:EE_|DU5PR08MB10561:EE_
X-MS-Office365-Filtering-Correlation-Id: a530b129-4b12-4e24-9667-08de39927593
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?PQjD91sdRGxSP2gG0I7KpUlNC1dsYDwoueGG5H5d6VGzzVUaqNjVKdy5QI?=
 =?iso-8859-1?Q?f8fanID0Yd43wsf63y+05LMcF3gDBGssemIHWWrKZM944ARCtBEwcEhVEW?=
 =?iso-8859-1?Q?XSoKMmTsbNcrjAqVmSed210gtONzxyReMlhHPVHcxEFMfHx4NVX8v+cbE2?=
 =?iso-8859-1?Q?FNPyuSrBBYDONIC6ZdPQRfxEDxNUk3asEJxGKMVDZ8wvuKcMJCpcsihA55?=
 =?iso-8859-1?Q?E6AQSzffHnjGAmUW83oHtDYZWXIyhvLZyLX+q9vCdiVi87mWgwWqU82LDm?=
 =?iso-8859-1?Q?QU9Pu8rz7mH2/RZs3Etr3vyQw8T0XQenjv+yFel/0mr6LvlyPb9PtFYco3?=
 =?iso-8859-1?Q?79REhWyTcmeyjAOirIXy14/nbnTvzXrJZYg6r83l5CYjG7Aiwc082hNOhr?=
 =?iso-8859-1?Q?yv7FThSMPWFyTkMRCBpCIEHZpwbLOupwetxdEibiG3gnCSD2J52H9bwBry?=
 =?iso-8859-1?Q?e4eI32PPtU3GtsRnHPM00Oa2Gg7hvX1shklgGp7tXrD34zKSKTmwXw/l/P?=
 =?iso-8859-1?Q?DQwxVgFI4RBR9aw2/bA+SGma568zpp3AkqX9DwozhGyhAcHwfXLgghQowU?=
 =?iso-8859-1?Q?bYy4VC/xdLpwlWZFpvS1Qsb6L2H8EaoB3F+DbTZTaVzwjzzbDmOtBStPGP?=
 =?iso-8859-1?Q?LWxARWhPuwNzikQuoBCzVvTK4DX5Cu1l+wADvTVHSYXUTpwaqTPwChsn5J?=
 =?iso-8859-1?Q?eBub1tmGapdxf/VoIyJ/RlTwMcLkEsohm6dSmctLjwK0HbYoFjegvqMl4R?=
 =?iso-8859-1?Q?zl269a/P9urY0lHq81Qmd0cfrRAle77yqUehKXUo6/GC28rf45jeL+Vusg?=
 =?iso-8859-1?Q?gMnrvRC9iWFaze5IfqhITdkOJb1mNu2djdjUTBlJyXcZBiZEe3QmtWmtY9?=
 =?iso-8859-1?Q?HqyE9E/cXMq0FXtTX/0okCJCtjwo88V+fxM/+58PHweKZJ0b+1rBE66qFS?=
 =?iso-8859-1?Q?TSXHBOLg5AHWdCWNjFjfObgeNfMhQ4wJRTg4xr8cGCZrZIEerZu0fjQhQp?=
 =?iso-8859-1?Q?4vPQ3u+IjGvLv4Zg+KMoDAAKyE6Sq56mBIVvYUvY6+s1dzqgWstlBDZ4XR?=
 =?iso-8859-1?Q?fD0sHrSC6q/HRALunR9kfAQ2UaobeHqLunZdHUzS571m68IA7De7xhqOIo?=
 =?iso-8859-1?Q?3z1nWo3nLle2bfnogGCvBrvRgL0HKhFx+pGdbt4H4i61TEvT2cJ1K/1dgQ?=
 =?iso-8859-1?Q?JrMKgj36dQ0WTq6LVFkRSnRayWww9KKuCzIWtadZdPub8iwlHnfKf+N1gs?=
 =?iso-8859-1?Q?La4MhIwo6sijgBCEBrATiF6/4JfMBUluLfyzntlO5vjp8cV2nqTlZCd6v3?=
 =?iso-8859-1?Q?W8v4yUTDi054hb0O5Qonss9uNIaqQmnMBHWZopMgtapcUunLdlBz9aNxVa?=
 =?iso-8859-1?Q?wXWsnoUWjiFEtcRn+U07o80rNlqBk+7dG7OGkG/j8HhbBnnH1wW8PO5Nnu?=
 =?iso-8859-1?Q?JFCnxC2anHt8LtMCPMMAU/TyIvY6tSfq0wuK6PiJa7dCqm4+LKykaxEyen?=
 =?iso-8859-1?Q?3s7vZQVDEDJVgEgT92CYsr/fZyJBD6PRgHRHQZmbdK83p13H/Njl1lAN3m?=
 =?iso-8859-1?Q?NuHhTCbOlNdkznUsSNjKFOBzyXeZ?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9386
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A4.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	dced5a56-81bc-4c78-67c9-08de39924fb7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|14060799003|376014|35042699022|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?eKYGcY1+PnggOL6YCivSXeUHVOVzoS9VpkcquqB7DBvvI319ML75oTAUEO?=
 =?iso-8859-1?Q?lIloGnVfJhQEZ/6SRSrFLnrXGHAS/qDvPueNdvg0U7w7V+lvGIYh+j5PI+?=
 =?iso-8859-1?Q?32Iy/wZs7tKa0yxLsGacGtAgYuJoxcDWB/3/leqcY5wOWeT8uvNFSbexsV?=
 =?iso-8859-1?Q?3jfMTtoT/7hgv1VN5ZT1atXme+gOyApOoRj7Z9+iLcZQG6pT8q4nAgiX4W?=
 =?iso-8859-1?Q?ibOQVqnkJZc61RigemqLO0JaOyITRRtGKy9ruBRL6rQHAD3r3dIhFhWNJl?=
 =?iso-8859-1?Q?wJhZfddIrzEyeY5WHBWaHKd7idTfu7nii/fzYUWPtB8Vzi/8hLum9Cej/z?=
 =?iso-8859-1?Q?ZJ7/7N9ex4PUkDZYpaOuLxhz02AHpiQDsZsNnIZx133lUUoIkyMW6Lbnj5?=
 =?iso-8859-1?Q?lGN2TNVhVeNvbeWd2HGO0xkXD21Nfqnky+Hlfp/Ku+xIk1f1Dwfwa+a/1/?=
 =?iso-8859-1?Q?omx3A7BordCotH3/7e0YKgu70dMpDd7E29dUrTXbNTzOa6Etut0YWE5PBI?=
 =?iso-8859-1?Q?hJtY3svKO1BYGjuBMXWVGztoaBLFV9+Q8/aEio9WcTT2yjvDvEp+NuXZMz?=
 =?iso-8859-1?Q?Sg7WK7QLs7TeSUMy7DYWHA93vQ529MYVA3/G2d+C800T+DTjmIqniGCRzQ?=
 =?iso-8859-1?Q?I1XdIYtrYhV2A+p90vYSpPxul9N9Q2xcwpY88VD3LD4UYEEkWYmGhwF7uF?=
 =?iso-8859-1?Q?y8hKPFPO0tj+fIkMpY80Mlb35PwOqrh0lbZf2LcyT1O84M3zUkvelkuJO3?=
 =?iso-8859-1?Q?jrBEJBWlht3QKN06l57J4ySjS5LAq0r7z1Koz1vP4hx9wXzDr87cStc43u?=
 =?iso-8859-1?Q?EyfeW71c8RjA8eBZd74cVIWxAMkQjMeIG5XkQhZxocqjuVehmLQp4ktPPS?=
 =?iso-8859-1?Q?UFxeHjtwfjWViKwe5wM+YtxLtfRcGDCgm0dxGHs7wtBGD9fwa13ex76NXR?=
 =?iso-8859-1?Q?/gViikl+rfUFBfqEYNCTECdKGzlxtcEgJS94Aq6PnLq6MJce/+ywt416wX?=
 =?iso-8859-1?Q?srhCiIql+PnV/Gf3KkFyfrGTNIiAKBakHwj5SOIrdkCMjR6N1YaDvMpiga?=
 =?iso-8859-1?Q?5GyzHe0okj2V/tKVEI2ReunDQpjjs/juu9MafArCPoH+VtbxaaeQH3kqAA?=
 =?iso-8859-1?Q?+pIXod0gP+6Gldo5xSJF2m1R53hiHU0Kmq+gnSld2RCIOSDFOSKF2XIMIJ?=
 =?iso-8859-1?Q?jEvvs0iRKQahJi194O8ktU4SV1cukRcAc1PoAWb5Z3Ldsb9a9NYIkJnrac?=
 =?iso-8859-1?Q?I8670r81jV9FuZDN/2POLXtVGc/PV3HszRChj9YJL/oNE0rmXytCqoyFS/?=
 =?iso-8859-1?Q?3iEMKuwu4YIgD04vdyrRrwuQ2QCFxqW6rMrSeOl6rudxUAkLP4xYl1x1Vt?=
 =?iso-8859-1?Q?RTbedRLVuX5iVp74kN4aMB8ZIRv1POaNf6Bluk3PYosNorZ/8w7N45Zf89?=
 =?iso-8859-1?Q?1L9HW9q8mp2ec6kxM4xf+GuLxUP2h79lNv4Z/uCJLwyLDS2aKdwikPT24g?=
 =?iso-8859-1?Q?AIfvR/5uzP4RA/qg/8rrwPQv5aihuXXTlj7yPs4whoiC/dIL3yJPdf+6XM?=
 =?iso-8859-1?Q?M1mELJBr+/fuzCA4vBbtmeMkd3+fcytuf/QKpar/rn1qTSJSDZFQcAH+XM?=
 =?iso-8859-1?Q?zPUIZxsZCVePQ=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(14060799003)(376014)(35042699022)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:53.2926
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a530b129-4b12-4e24-9667-08de39927593
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A4.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10561

This control enables virtual HPPI selection, i.e., selection and
delivery of interrupts for a guest (assuming that the guest itself has
opted to receive interrupts). This is set to enabled on boot as there
is no reason for disabling it in normal operation as virtual interrupt
signalling itself is still controlled via the HCR_EL2.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/el2_setup.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el=
2_setup.h
index 07c12f4a69b41..e7e39117c79e5 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -238,6 +238,8 @@
 		     ICH_HFGWTR_EL2_ICC_CR0_EL1			| \
 		     ICH_HFGWTR_EL2_ICC_APR_EL1)
 	msr_s	SYS_ICH_HFGWTR_EL2, x0		// Disable reg write traps
+	mov	x0, #(ICH_VCTLR_EL2_En)
+	msr_s	SYS_ICH_VCTLR_EL2, x0		// Enable vHPPI selection
 .Lskip_gicv5_\@:
 .endm
=20
--=20
2.34.1

