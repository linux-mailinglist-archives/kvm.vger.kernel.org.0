Return-Path: <kvm+bounces-67597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id F3B2DD0B825
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:06:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EFA2F3028F8C
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90395366DAE;
	Fri,  9 Jan 2026 17:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FX8aLBFj";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FX8aLBFj"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013026.outbound.protection.outlook.com [52.101.72.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88C2365A1B
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.26
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978354; cv=fail; b=exWQoWrehndYi72Xv5RlXQ3xo0IsRvZzJ7ohfPuyBih0AQ21MeeU5cH282L7GwK58G2hy6XNpMVraYhFercZ2JrrBC5i8r8RUahd3KjZ47G9Z1xeVAbpWNKttRHhLZR8aeQXw6WOufrX4iHPvDck5LXXuKcciDlVX/GRl+lOtCQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978354; c=relaxed/simple;
	bh=mMH8QYaeRiPeNQZeomDxgjPVQRn778rpp2OI6PhazlU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=joTAbcnEIqr2pjHJodjioPkkqSbOS29NQr9ZpO/ITb4izTVWbEw78g3vVV7C4ans7Y+1wgGpI0nGnScDIz2ffuRpqZP93J8SkWh64piXpMqqsE49dlR9yM4ystRnj0TEWIv4I1SAXiaOD6BmeKgzKwrTu95BnX1L5zJMPsNGQj4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FX8aLBFj; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FX8aLBFj; arc=fail smtp.client-ip=52.101.72.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Vbjwmh/K8pc8m8+nmtoFzjY0ooDSwZEyO1/187E8r6K1lCKY714hDmOspziNSkwkT1bjkbWbv83hfeKkttGdgj0TAAo8cbF4VzDGoiwcfApoREtLptPu15qSDewjfET6qnYHdnfhgD+fZFFz2SvuUTLNob7lwnIufr11aNrJ922jbbpCHY8mK5+uCPs/RPbzxgsq6bQS0C17zomi2GXfGaeoToro8EfKL+zSqp9FTrEVaRPIOMC7TaO5Edeb/QR0GcAP9xaUGR222VXHY7ljXlVOSauimonA9dCKB6rZ5XU2vKMoo0JEkchdoKpQmh1qmJw+Vsus2Viy11g9LCQOJw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UMslK98FkUUbM9bUncQfuUU5se6nkhiDr3QMqtzjuRw=;
 b=Z4vTJum3hc2TLj1eMh5MCouAwWcLHuccCjbqmFaHvOixPtQYj2d9UgG7mpbuV4Sv5xdncCfuvXlVw5NX4Gb5G2fYhuzcU3dTGdAzH/jiVuey8WxGMIgca4xRUKoOxM4XxlEGyLoRfNmS4+SbzsBEPINO5bX18r61xY63YN+BH6eAupWWa0NTpNlLjBSXISP2mYs6SZxxJyOVVLZfSzdWni+dOx3sndDANwySxMFbfVLtASV7BrfirhxdAjqtmvkCN4N78B7GzC6xnjbWV3oYecTnO31cISKOGF8CAhPIjAUUyimXcVVwOam8tARpGk5o7soDRkVqUbb9OSQzfDjiPw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UMslK98FkUUbM9bUncQfuUU5se6nkhiDr3QMqtzjuRw=;
 b=FX8aLBFjr+D/XJc0buActvQ+I1LbT8AgBWmuw0rTf83FGhiwPV6dTnsL5zamVUE81Pm7aliqrkTb3PfT1Mf1Oieyuy8MvUdtNGlSU8swGoSZG0Tj+Cz6fcB14o2Nj3Tys306Os7SKQyqoME4gdKphrTlkaOY8zprDSxqFcDoXTc=
Received: from AM6PR08CA0003.eurprd08.prod.outlook.com (2603:10a6:20b:b2::15)
 by VI0PR08MB10710.eurprd08.prod.outlook.com (2603:10a6:800:207::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:05:46 +0000
Received: from AM3PEPF0000A78D.eurprd04.prod.outlook.com
 (2603:10a6:20b:b2:cafe::46) by AM6PR08CA0003.outlook.office365.com
 (2603:10a6:20b:b2::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.5 via Frontend Transport; Fri, 9
 Jan 2026 17:05:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A78D.mail.protection.outlook.com (10.167.16.116) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:05:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fOtv3ue1BOtTYCX8vde5msJlLN7d69/olpY4kXRjzf+A07kldkuRk2m6InTuTzJ+SbDJy78eLsv2VWYBBSY65BVVBkiJW1bj7cQ9vYhkf/u3S87ivw9piDg6R2zsuNRnTwSV/1SIwp/wnY/qf0/AOi72/UU+9KgBoAWOznj2fSvrOKlVkrtQ9vXvV+VpHGn9XmkVIB3WjJ1cxXKmggdDZ71EMVnoXJRg4Fr9g3n764sStmcAVWVO/IuM5cOdl+6IQzZ5FoJIAmtPm7v5Wx+fg1P/1J1ykk+RVEFCO1ZXGeAvWGcZSggw/dSC7hpsrR+NlS/WRQfAA2CwBs0sjNCISg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UMslK98FkUUbM9bUncQfuUU5se6nkhiDr3QMqtzjuRw=;
 b=ARNoAgjAaU4RPxQLHssRfU8ZTuv20b3cZcg3Gk1IZIvMxUxpE+GP1tQEVbZQgfVTkZSRD2pdtYXbGjCwo3uwd6IjAaxjH0ZTlADJGwVkxFwsG8LObNdkVl7aS7kKi7ApYmSTecithH5tvxdqe0r3W6IgBwaejRlky2/EmvtdgSJXWVwYd18axMiBZ5rDXeV4iOAtCifOo5EtsJ1sZgGqosS/vaFfml6yVwaghIIBivSWaqrlP+F0tADUti00haA/ixtbUClgf4ql4i2IY7N430RyTexihbrA+L3QDYSubzuNlvfKFcMG6MkObM7JzKrgtnjmAFcOBntp8+JHP35Ykw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UMslK98FkUUbM9bUncQfuUU5se6nkhiDr3QMqtzjuRw=;
 b=FX8aLBFjr+D/XJc0buActvQ+I1LbT8AgBWmuw0rTf83FGhiwPV6dTnsL5zamVUE81Pm7aliqrkTb3PfT1Mf1Oieyuy8MvUdtNGlSU8swGoSZG0Tj+Cz6fcB14o2Nj3Tys306Os7SKQyqoME4gdKphrTlkaOY8zprDSxqFcDoXTc=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS8PR08MB6216.eurprd08.prod.outlook.com (2603:10a6:20b:29c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:04:42 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:42 +0000
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
Subject: [PATCH v3 11/36] KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE
Thread-Topic: [PATCH v3 11/36] KVM: arm64: gic-v5: Sanitize
 ID_AA64PFR2_EL1.GCIE
Thread-Index: AQHcgYoMkdQolx0us0S17cENVQQJMw==
Date: Fri, 9 Jan 2026 17:04:42 +0000
Message-ID: <20260109170400.1585048-12-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS8PR08MB6216:EE_|AM3PEPF0000A78D:EE_|VI0PR08MB10710:EE_
X-MS-Office365-Filtering-Correlation-Id: e36aebfb-a2fd-43b6-2e95-08de4fa154ab
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?xd62cl9XCEvJn7JZTxZa/QEkhbacERz20kPAyiBRF5DGsYhEK8/iKrYf+n?=
 =?iso-8859-1?Q?Czi/TZGTk2NISHMtDZmK/cimlsL1A9kSDDQFH7R8GTdjuleiQ/jWME8/34?=
 =?iso-8859-1?Q?b3/yh6XMjJNigWa3S+X6EPmXSciMfiSACr0rrvdfJPbRTAczgPqYxUkNsU?=
 =?iso-8859-1?Q?/vUeKaZU7M4V2kCd+ySbbSkSsdX1mHRirGGxs4ol3EyqxIqjjkIPQyuhC3?=
 =?iso-8859-1?Q?fgiWfT4ND8PXycMSEcs9v1U+pAr3osAUCmbIJbn2jNSlFdbA2Dl2NaVoW6?=
 =?iso-8859-1?Q?NV3MXKlvx1Sbn0Z3YIBy/WWZoneWeIOxfnaNevECvKslC/M0JPoJ+0cbQX?=
 =?iso-8859-1?Q?fx/SV1ZPgiWDrBhyxk6icWHbi7L0bVw6j1YnqjgyEsxGvVqhQrfn+SKMgh?=
 =?iso-8859-1?Q?DADTjOmXOUEWUCct5J8XP8eY1U2NlafCNktUjj/2Xr+tqYW+p6AXjCPQqc?=
 =?iso-8859-1?Q?1QWtptUH3bRrAKrBp9c2raDxpKJr7L829IUY2XXQvkrT/l4D46YgyNfNxQ?=
 =?iso-8859-1?Q?s1IT9zBU2X31RHM3iVAA8/Dy8vRcJd8QxZWXVbhiErHVwpjRoUFWYYzYr1?=
 =?iso-8859-1?Q?qASofeh5sodd9M1fTeUgB6xjwETOZa/5ZqUNGxtcoHs1CYIzG55+c4rwcU?=
 =?iso-8859-1?Q?FWUzDd71kR8KXjRnbz3QYVPQ2Lor2BpBBglhWifo32Xw5vysTWWgmlFetX?=
 =?iso-8859-1?Q?q5opqVGJAHhISYtQcr0gfkf7DDbTNXqszlgniySrZ3lla3f/5GyAM+tIot?=
 =?iso-8859-1?Q?3a4Fq+zurF7bF1jy10C6ZA+I4PV6l/xpAw0fN+uZ7EpHo6IKAl2eYCUccq?=
 =?iso-8859-1?Q?wm6SAUC4Rtybf/RZqo15hzG19XQXBG4+bLk3tgx+xd5Wasgsvow+kU7QSB?=
 =?iso-8859-1?Q?INgX0WQDtaHY4L0c4DcJUqYjl465jkw7YxIJK7eoTocG8+dUi4vaGgnhx9?=
 =?iso-8859-1?Q?bCypR2lzR4CdKf6HmvcSFH2Sgp3IwogKmUhukaEQ7qS0Aibwti4ra208pD?=
 =?iso-8859-1?Q?mC53cqJfudfqj1FjK6pfplK9FLrpzpnl7mQwlYQi4Q3IuagmUbraCmJ4uW?=
 =?iso-8859-1?Q?q8NUq3oyzmnMqDAVAzAzi1OiyiFNfg+v/ZejpruJd49oTAVYOD7lbfQTFd?=
 =?iso-8859-1?Q?HB9BVdIfVTCYTC4Fljk22gQFClHpKPz4QGSAA2Zzx+NIPflYCma3rP1Be7?=
 =?iso-8859-1?Q?mC//7D3eOzzsdBJUqHQnmU8+f6BJ2Cxd90gvoqpOaY2odpkhksAgVvqRC7?=
 =?iso-8859-1?Q?uputsS8x+JMnVjEq2o41VxrXGFq1BP9OFbJJabhbzONV7Zf6b5+9nf16bS?=
 =?iso-8859-1?Q?wq8hbFF7nMBNk3GlamGTijbOchz80q+jVjMGJ0f8HFFlNUXuZv/7ZdO4b8?=
 =?iso-8859-1?Q?2n2KrqEZGvOEU/hMYydWz2A3uH6qxXk90FX1dPSAAfTdXNTL04NO5zzOg5?=
 =?iso-8859-1?Q?jxLLlYc9cT0TLawMd1hR3eOS8dYNkfHq1MihttoY7qFRwP0rK2LCx3P2SJ?=
 =?iso-8859-1?Q?3YGjjoVgQgqPR7t/KRstf+85M/kKO4NaG1MYT5Ldcq5RBSfO0EoedISjO1?=
 =?iso-8859-1?Q?scdk64kCNQ8As39isptuFnJHX4Zc?=
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
 AM3PEPF0000A78D.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	128c5ce2-ea01-4827-c5e6-08de4fa12eca
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|14060799003|82310400026|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?vnKTLPgCteXZAM2H//XuSGC8wG7ohC/LAVUSuEK1/yzcUpFtjjQmnpPD8x?=
 =?iso-8859-1?Q?evtbYKhjHiRzX/mAwPb8dGVwkg0kGH2CfxNGtBur4l6z4Fe21bzAr+67R0?=
 =?iso-8859-1?Q?nVgDCCux8DD0sYhWz49G6Hh/hPv5gbnefTKMVMrTIRJGbwcp6geR0egsZZ?=
 =?iso-8859-1?Q?HgQ16M/yvYPPOlJqeOQfD3/Fsym9WXo3lVuDqsICar5GyMIpPkyERB/xua?=
 =?iso-8859-1?Q?ZZHXA1fzkx927QxtKOv7fwRzQKMejgBjFoBZmMs3IW/xAPgWDg+7hdHMKA?=
 =?iso-8859-1?Q?RcrzzTlwhqMr3G1RYiwkqu3EW23roImuJNxE1D0xIG4ZDIM8ttdaRI8nNR?=
 =?iso-8859-1?Q?KBQ+ZK37i/pougFdFOM6tWX3jB3mYxNncW206ornk7Mn16tFsIFhWoMz9v?=
 =?iso-8859-1?Q?auCGvd+OJl920ide7YQ+7vNIt2OoMO48sF/F652fUnLS2WbUzjp3x+ty0N?=
 =?iso-8859-1?Q?PqmUZ5RRE8xg0PnxbQYxZSxozlgOaUo4pnSgDxNvf7seWYpqmwlIIFbu77?=
 =?iso-8859-1?Q?5hvC9akm3SqGu01DP08gZ6DTeWaOJZGM3Uckh2OohclR18rvSxPo/zk924?=
 =?iso-8859-1?Q?eJVLOXk4LL5LCoGdKj4fmiG5gCtWLoNCHquCo226p9xWY+ZEE9RLi7VM0I?=
 =?iso-8859-1?Q?Jbo0Fb+7oQSlJoF8ik9kxx8L9QvGK21TlyTHw0qjZkwHL7bhkpMB2SI8zO?=
 =?iso-8859-1?Q?7vigiQJxD//3bia04z67PpDdl7Pq97c9QALPJNdF/hrxF5QoVv9g12ns39?=
 =?iso-8859-1?Q?kztI9QvYhO9tsNtNBmgAvBHWzNXrlDJLC+xOYuyvyGhr2VReW0gmRhlf3M?=
 =?iso-8859-1?Q?7Fuf0dv9PpW19eHTxEKwOc3OknbE/wf1ZlMZnm3lE1j0imyORY7dI9N5Hy?=
 =?iso-8859-1?Q?K5ymix5d+kaP7CKJTQH0Rasw8ehHApL6UKZNBC9Tx7/uQpkTYVNApaFrPY?=
 =?iso-8859-1?Q?S2E9J2dYiA2Ge9FPWE3ESSovhl9/aj1Bkhb6M8WJNpa/8TlNtUtkC5nlew?=
 =?iso-8859-1?Q?Pq5F4YILiATk1OrCBbKPMCEwWRe2L/289Jjp3iUlZOLk6DHkpIdoAyc//T?=
 =?iso-8859-1?Q?5HD46lWrU59QkyHjFSeAUER5BvtRV2O/IUSfYWJmd6mQa/zMDTQyq8XFC1?=
 =?iso-8859-1?Q?/18LfJoOWLoqVI6Pd5wixZcQRSiLa8D7zws8FaYubYx8TTJQeqHoa3Dq08?=
 =?iso-8859-1?Q?d2GOnncZbDo0P695FfyyIyYkjBwcvftPHDp6WeGlDfngN5+45wF26MVcbj?=
 =?iso-8859-1?Q?t6DNyPHIsqSYLB3+iz0cfcg6q/dD30UnX1kFWVrhdmsiWxMj+FHTs7UcYm?=
 =?iso-8859-1?Q?IUGVhx0L/qAYdcerHWNxPS9EbQzFYLBGXzuNeNMDLQdpU7eeYoYneflrIE?=
 =?iso-8859-1?Q?B+OfCsQElRhz5P/zJXzKn/oUBdC5UtovG1Z6WPDqK878If84wqV2gN+hMX?=
 =?iso-8859-1?Q?JfoNijjS49dQKdm9nLdVzwg6jz5rQcjsQPiIiLXe60VPt8Hk6Uo+BH/p/r?=
 =?iso-8859-1?Q?1qdbhbiutQZDN3UFLuKXxusl/LpDt5HCFLP1Dg6erdie0S0PamiIKTmcjs?=
 =?iso-8859-1?Q?36BJImefKVYY/On3TU1jGv7PvDxuFlTVrUqesClLBsa3nUTfOqmUgw7/ve?=
 =?iso-8859-1?Q?XH4CRBEt35xI8=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(14060799003)(82310400026)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:46.0984
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e36aebfb-a2fd-43b6-2e95-08de4fa154ab
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A78D.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10710

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
 arch/arm64/kvm/sys_regs.c  | 42 ++++++++++++++++++++++++++++++--------
 arch/arm64/kvm/vgic/vgic.h | 10 ++++++++-
 2 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c8fd7c6a12a13..5fb7b4356b287 100644
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
@@ -2024,6 +2022,23 @@ static u64 sanitise_id_aa64pfr1_el1(const struct kvm=
_vcpu *vcpu, u64 val)
 	return val;
 }
=20
+static u64 sanitise_id_aa64pfr2_el1(const struct kvm_vcpu *vcpu, u64 val)
+{
+	val &=3D ID_AA64PFR2_EL1_FPMR |
+	       ID_AA64PFR2_EL1_MTEFAR |
+	       ID_AA64PFR2_EL1_MTESTOREONLY;
+
+	if (!kvm_has_mte(vcpu->kvm)) {
+		val &=3D ~ID_AA64PFR2_EL1_MTEFAR;
+		val &=3D ~ID_AA64PFR2_EL1_MTESTOREONLY;
+	}
+
+	if (vgic_is_v5(vcpu->kvm))
+		val |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR2_EL1, GCIE, IMP);
+
+	return val;
+}
+
 static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
 {
 	val =3D ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, V8P8);
@@ -2221,6 +2236,16 @@ static int set_id_aa64pfr1_el1(struct kvm_vcpu *vcpu=
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
@@ -3202,10 +3227,11 @@ static const struct sys_reg_desc sys_reg_descs[] =
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

