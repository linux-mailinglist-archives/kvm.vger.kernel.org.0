Return-Path: <kvm+bounces-66349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EEBECD0A5B
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:55:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3F69F30B4FC8
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 15:53:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB42136214C;
	Fri, 19 Dec 2025 15:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jYhtyWND";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jYhtyWND"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011031.outbound.protection.outlook.com [52.101.70.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E300D361DBF
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.31
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159628; cv=fail; b=RsCfFWS1s4YjQ45w/wY7aeiXxQfCBIkCtsqf0d7CTjNKIm0mBLj9UnvfiLALjrVfHv0zHlRX/bIcj5N4Ir4DLQIoXh7bQDNdaFhRja7EBwE3LRAoba5wz9bOqbnqIr45wLxJGpiInQTy2f666gnXkA4egqFV8clsoOebE30XqII=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159628; c=relaxed/simple;
	bh=B4aGca0pjZYBK6qK39toqhS+Zj+/ObS4MVs9sTt291M=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=RrYcncQiyg/ezqi636HTtMEyMg1wVviYYurjQ+OHoymXegWw8Z0oRfRbywiQK6waRYPEm1JXKbu94Xm+W4f75Abj5gn+/A7w/xW5GkNOdwptePsIa/wSKs0TjyxL82K/35m6ku99jJy5nQsZOM0zOeNfhxNVoF8lsJpqMaCzmBY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jYhtyWND; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jYhtyWND; arc=fail smtp.client-ip=52.101.70.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=tlNruSqy6veKzetB6IGYajR90JSEe56UuuruJQ2n5GdYrNVlFFVFwvwlbpTqEbs3hwYtlK+1bKgGuJhG81zEDQb2rhFK+b8ywj17K71YNYatuqeo1tMjTLbIeNTejuk1K2/KlhetjQXOOCAqBw0rVQDQ8+Ars96D6euaJCaRmP+yAYCHnX1On++l68qc5cZCamMIlm+I8hTE14Mieuvew+SrkuPBZlbvF23E1MXKoAzr1CvL020FCltSqjOaywcbSWNtPxhGt1yYNzX1aBIf2Bi7ZryctIqr8YPnYtOfCSFFcxHuWX9R6T12MBe1+E6n/cAg/XpQQvlytIFEX3Zwiw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=px4eJLiwC+7hbkDfKU8rUjgp87zeuafLoVvvHPzWI0U=;
 b=LdOZ/z94aDyVt1C9x6D7Q/ityFXGi8/7OvJhCCZnImcBp16ljLHSVWnzN6kIzcMHKjC5Mbkf2uCnzYOW5j6f08ARjYmNxME5lZRnMGhtQfkDcs27lKPFX7KUS4pNbp3oBWFm1DeUGI7+7AveZcDDO3QDmOXGkGGWeFKFc7k+akm1YJuyfPtD/jthYhOV/0muRM+DKfb8jem7VoqnHU+smn83XdYF83eT+MUTmCPe+lnxLYG+Va1VVsEnxYeKnaI1+3//jP8r9JtnB8SkC+Smow0vIFNfam4WXWVk3FzYsDM97O8PECjvsPxZ6qBLe8NdCEbhcRL4tEoSsOhQfZ6OxQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=px4eJLiwC+7hbkDfKU8rUjgp87zeuafLoVvvHPzWI0U=;
 b=jYhtyWND8G0smlYg7zwPhXWnnypfN5BKN8XYEi6ZddUEEf6Im9pzN6GDgOgsbzZoaEL3CgUWwZFqagLLINyCqWt+3KCnSDjSQz5Jl2ZSx3/nXuloLYaJcoCEFdk2IeDRgJcVLT2tYuE5iiTIGQcDd5OgRRum0qWUJTTuNCTm0gc=
Received: from DUZPR01CA0054.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:469::10) by PAWPR08MB11512.eurprd08.prod.outlook.com
 (2603:10a6:102:50a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:53:40 +0000
Received: from DU2PEPF00028D11.eurprd03.prod.outlook.com
 (2603:10a6:10:469:cafe::90) by DUZPR01CA0054.outlook.office365.com
 (2603:10a6:10:469::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.9 via Frontend Transport; Fri,
 19 Dec 2025 15:53:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D11.mail.protection.outlook.com (10.167.242.25) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:53:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m8M45iUicq2hQxmOqO/ilLg8w2UAB3Z1S1FhU+h22u6cxx6v8I2dG9qLPxFAerv0MIHpo0bh0pc9srBT/vjO6Bju/r7Pxmeoed/KoHgbzabk2W6FK2Okv7A2b71z72mHlSEG2d4f+3JTPqrQbmEKQ9EpK5VixzfZSDr4JHUf55UyegJuThWdOt5XOsuo6pJURoAETMi++aC4RTFr7t/eRQX0ki/x5Ifz02RfBEtHU5Zy7J6vfLDgKi5g1VxNy9+DEMdQewgRjTPERuqCkYlA0Lf2PAEcTuIreqNVw4x35bZO30oTN4TAvTQqv8qOD6+RR1YkMJWmJVKaENPLOxO8rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=px4eJLiwC+7hbkDfKU8rUjgp87zeuafLoVvvHPzWI0U=;
 b=n0FKaoD0GCYdUOSOHOgfQsRQ7ijsEHkyeOwf1wRjAr2q4l4L2rzZowCsLWSptgcpmYLl9ZHnWweMPB4rQcYgZBYoFTtWHbkevc51IFoOuvjmEfxcvxoD7WksYtWJ2wj+Li2WVDoQfouMmSEyROLhl4lWa8SFHc5/xofsaQpud2osxC5PIEzaQBbwrQLiYJHXVnYk7SFLN1o0SRBCNlkbprOs5q9VNcVDIPNqcj4obGNSREMNRvQiKJrQX0vf6F+GqcrB95lijfLBeSt6iIudf7rgmxFSWCnjhqKnBxglsbr4r3wIVhkfkTJ7EaBCQkwhH986QyU838A9cxgA1TZNVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=px4eJLiwC+7hbkDfKU8rUjgp87zeuafLoVvvHPzWI0U=;
 b=jYhtyWND8G0smlYg7zwPhXWnnypfN5BKN8XYEi6ZddUEEf6Im9pzN6GDgOgsbzZoaEL3CgUWwZFqagLLINyCqWt+3KCnSDjSQz5Jl2ZSx3/nXuloLYaJcoCEFdk2IeDRgJcVLT2tYuE5iiTIGQcDd5OgRRum0qWUJTTuNCTm0gc=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PAVPR08MB9403.eurprd08.prod.outlook.com (2603:10a6:102:300::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:52:36 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:52:35 +0000
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
Subject: [PATCH v2 00/36] KVM: arm64: Introduce vGIC-v5 with PPI support
Thread-Topic: [PATCH v2 00/36] KVM: arm64: Introduce vGIC-v5 with PPI support
Thread-Index: AQHccP9+BmxsDh9kfUiQTKgHtflD/A==
Date: Fri, 19 Dec 2025 15:52:35 +0000
Message-ID: <20251219155222.1383109-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|PAVPR08MB9403:EE_|DU2PEPF00028D11:EE_|PAWPR08MB11512:EE_
X-MS-Office365-Filtering-Correlation-Id: 10d4e249-1267-4cf6-9f5b-08de3f16c77a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?GZ4Itkce36KgpHG8ZAer1Ozsc/at61tthb9aoV4F/qXF0btwKJ+u1miR46?=
 =?iso-8859-1?Q?erCUEu2upR4i9EQRuj8dP73jn2NV5OGv1zQ3FUrMbboBO+5r9sdIPfj1mK?=
 =?iso-8859-1?Q?ojEtRuW9V4OjhaJLAUS8nA+bcO8bzoyXJNlRKYgfAPH+fmSbR55/1V5t+M?=
 =?iso-8859-1?Q?t5pHiDp+ZNB4jcpth1Q2YHR5vA4P1I/3o73T4iT5GDCx2zpybDY9Hvi4iZ?=
 =?iso-8859-1?Q?Xj1+iSK3mmWoFLGLdh3I7qIm2KEvaIW4VA5FXrq0dkq8Llpdfz3tz4c2uO?=
 =?iso-8859-1?Q?qxTRBODxMvmM59CKDPuxFGwBPkb1N0EsmyaVOv6khzdu/YJTltNOo8Ak1L?=
 =?iso-8859-1?Q?fnrrkqN3jLSXSgb+AOZ+Vtlc1ZmRc5hS7orgJh9uYt0p54cgy6HCHiqgfj?=
 =?iso-8859-1?Q?MzLF//8UiJfCOejzl3FSGU7M5QCY7/4x9lN1J7e/RVSG8+9Gi0Eq31Zz35?=
 =?iso-8859-1?Q?QyUBBa0K9F89l+Fag7nMPxsRwRULl//qFa/0/zxHBxG/V2nqJsZqNPNAQL?=
 =?iso-8859-1?Q?n9ILySoA01zsXI1fxbFguglfDAodqWXmL56JhOh+zLhKDVJZ1AFTGPgyHA?=
 =?iso-8859-1?Q?ASfL/Z4smmc/EhA33hZzlZVpp3Dqs8TYQSBnZYgGf5nUrXFwDpMeeCI1fs?=
 =?iso-8859-1?Q?HddWYw2YgYgRpFJZRnTfKmMELMw5tN291Tim9x9Nx3cyMuC8njP0uZ0y0H?=
 =?iso-8859-1?Q?xKTnesSJzaBWrXN5k60HVZ5ON9pwqm5f+g5U3bjpyp+zc4+a4mySvgVj06?=
 =?iso-8859-1?Q?W7n5IxHItHU2JA4OdPWiH4sRy/UKy9YVlFj2Q0GxI1UdlDdGRjFMesITEE?=
 =?iso-8859-1?Q?pMnkxTR2B2TIPxWPKyLeyPWJobCTfJ9rB4fPgQIQISCDrPQ4G6j7M07OI6?=
 =?iso-8859-1?Q?pacHi4QQl+VrZFUDbdXQYBuz6EOvt0c1vllRcjpXRCECruYv2uvdsfgsY0?=
 =?iso-8859-1?Q?ScE/97J/V6E9nzA/yRpLrKOPquWAlDub67DMujOpeaa7YLQrxhuat6wpcN?=
 =?iso-8859-1?Q?9IZ9lC2akla4lt/C57731fVKjWLJ91eqGZf6LyUpiYP0PcXlUQUcFW+otx?=
 =?iso-8859-1?Q?iaYh+SPNmJq4DprshIs1ohnf+kSqK60Nr3d9hCeBj8DD6KrLtg0XdaDc5g?=
 =?iso-8859-1?Q?IPeoRIzhvj0ZDl/iTZKLl4QL513J2rThuiXPwnFZXXYKeJ6/Pz+jSnyraz?=
 =?iso-8859-1?Q?yHK0xdl3cB2CVCE2J7oVbe5gMIN3cEBME2qp4vu2s9ZDPk4EOccgaQ5GE3?=
 =?iso-8859-1?Q?9W9HPbwNyxPf1rJ4+SrYlh8RPWgEEgOTu6PpqwqfW1W5+/WhKpibVKwZHc?=
 =?iso-8859-1?Q?VfWtCV68BN0h3TToDCfV1YAHcZqrJ1Qpw4yf8h+QOsNpa7pWUVP5sTRMXz?=
 =?iso-8859-1?Q?J933ePbU6dHzR28A3fOUz/Y4wCB2MBOEyHTkV43kYj6mTVc9olDR+fDrjt?=
 =?iso-8859-1?Q?ivQQeh5ErRTSLMKq4ZzjL58a8jw6zDotBU9+c3TIhG4Tq4Xv2u51nGzvNh?=
 =?iso-8859-1?Q?mrkxXtstPx6Ksv5ip2vgnbKibNVGvx0qPdm1ZmU4TApgrWovyAz1qQE2nl?=
 =?iso-8859-1?Q?CDktt+wnK/KXgF/fJOto3GJAfBIC9vbHNh8pHWyZ7Jx+rrPz0Q=3D=3D?=
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
 DU2PEPF00028D11.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	302b1a76-97d0-4421-bfa5-08de3f16a11a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|35042699022|14060799003|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?3jYje8Q2RxR7+b0p2aEHM34P7JIwzfUI61cn1Cgtw+ypIneDlyiXKOLk7z?=
 =?iso-8859-1?Q?OnK1Pm7azn7EdP4zk3GKQv40QQlYel29jgs0wsemvWFxJA9oV+jnWg7j2r?=
 =?iso-8859-1?Q?ekI3WxjLvwPoCMNUeakRhOU/vWwbDq+Hoea8klSX/5IQKJNWbMf0DdNGCo?=
 =?iso-8859-1?Q?XIPfLYYP0ZZF3T7GxOaTfJ8vCedNHic/8ZUgXl9YynuIRU/eaOGU+/9jjv?=
 =?iso-8859-1?Q?E43412h1XsCmepigrEThnt9h10+oGTqwzwgy9ZFlVmoMLh8vDhH/vlNAZH?=
 =?iso-8859-1?Q?IfrkDI6BsP6nQEEty7V1CzYIBCOpCX3xzS04HRRtAtWFVAN/81V+dWjshg?=
 =?iso-8859-1?Q?ItGY/Umx5bzC1NyKpkbXXS06KhcrEQksV8l4OChyI5xbCDxwI1OpvP2v97?=
 =?iso-8859-1?Q?EHnrlm1V386O/zSuc9arkdCwm/Mop8d+Z2B3UpmYXyVZLytcnhRyTLu4g9?=
 =?iso-8859-1?Q?q8qi+nhDZ1hkTXWSKqBBgWez1o509FUdiQ2AiBuubVlF+kl0vbAqYiznIA?=
 =?iso-8859-1?Q?2dUfIR32q4ZmkexjMJ7v6TGObXlpOCJyz9VDxoAdzj4djv10/ByR6K0AA2?=
 =?iso-8859-1?Q?glS6t9ioDOQgjpPx5Of8hyyB6fi/SKgfcy1VQGzhzVd/tRsWZQWmHsJd+h?=
 =?iso-8859-1?Q?Xp4StUVnYgwDyQhBCWWXUAZXv1hUI88RyMzg1A698tvEvOwwHYTFnrDAXx?=
 =?iso-8859-1?Q?UOjCqgnFEFmhK6SFoW1V96SsYEbG9Fklcm5WJFTtQx/izgTHDCUjTOeVLm?=
 =?iso-8859-1?Q?1tke5nEZRY7PZd9ou/8W2MgDXMov11T7fhSuAgyBgkpJ3P7QvyCwZKi1GT?=
 =?iso-8859-1?Q?NY20voXW6Ayc7beZnPCjGYWIOE4GjRio3yo2wk+cINTyZoTXYYkL2/Ms6H?=
 =?iso-8859-1?Q?YycgZwwrqTjG3pLQechyQJRq94vp5zPIisbV9MXP8u9yxiFZtZlMRJGA2Q?=
 =?iso-8859-1?Q?mF42gxTq9t+4WlsDLwIFCEDX6sZ4+YBjGie0iogsNeM06eBYc3B5eOYi2M?=
 =?iso-8859-1?Q?I5dEARG/Q+VSCvUIoYpmX5AGm4FLXlihjRe3DPKyAGwHqSVwbUk1QWQyBf?=
 =?iso-8859-1?Q?Yi8c9H56op0EmK6GBcL676B0/YC6w4T7M/GrmypFq3O8B3+PjigRy3wdGz?=
 =?iso-8859-1?Q?yqKS12EXsH/97qkD3eV82Hhr0zhteUsgwo6Vu776gYwMEIIm1LztAkh+xt?=
 =?iso-8859-1?Q?XGeZZo00MJknrSItF9ePMspEaLs3FIhk7jTgIM9lVF9k+AvzzFgAZn0eBM?=
 =?iso-8859-1?Q?ActdBVan0pODyBB6ZcyRbbeCrRmXy/Warrx08r6X/mvrrfdMoCXE37SwQM?=
 =?iso-8859-1?Q?tEbJ3Eqnhs7SEiHEzJZrx0p8jvtxw0Gqn2W/Gh+196DnlfFZOndCc0fJWS?=
 =?iso-8859-1?Q?uKgaay++igQDrvQUUUoTBqVDsReBv21lO+0dCszrkD4GNs565J9qGoL2id?=
 =?iso-8859-1?Q?MAbh/u4ttqBlBkUttABaljo8RBAE/mF98Ej9ZeS0A6ULw0SQYlgGgvNSQb?=
 =?iso-8859-1?Q?yhn5l1rFfQu3txGa2/3IkgnxL5F6lidthUAaZw69i1+QdRlwMLSCvvDAa3?=
 =?iso-8859-1?Q?+VozlL2goxxCL2VcVN2/XJX1AV9E4Rc122C5CnLeLL1/gcq5bmTC5C4n8s?=
 =?iso-8859-1?Q?ulcxyQi4fzOqaxJNq9+ZfVhUdJNQlTXGj2?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(35042699022)(14060799003)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:40.0602
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10d4e249-1267-4cf6-9f5b-08de3f16c77a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D11.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11512

This is the second version of the patch series to add the virtual
GICv5 [1] device (vgic_v5). Only PPIs are supported by this initial
series, and the vgic_v5 implementation is restricted to the CPU
interface, only. Further patch series are to follow in due course, and
will add support for SPIs, LPIs, the GICv5 IRS, and the GICv5 ITS.

The first version of this series can be found at [2].

The noteworthy changes since V1 of this series are:

1. Added detection of implemented PPIs on a GICv5 host at boot time.
2. Added masking for PPIs that are presented to guests. Only PPIs with
   owners and the SW_PPI (if present) are exposed.
3. Added trapping and masking for all guest writes to the writable
   ICC_PPI_x_EL1 registers. The writes are masked with the subset of
   PPIs exposed to the guest. This ensures that the guest cannot
   discover PPIs that are not intentionally exposed to it.
4. Added an new UAPI to allow userspace to query which PPIs can be
   driven via KVM_IRQ_LINE. For the time being, only the SW_ PPI is
   exposed for guest control.
5. Interrupt type checks are now re-worked to be more readable and
   scalable. Thanks, Marc.

I have addressed some, but alas not all (see below), review comments
against v1 of the series. Thanks a lot Marc, Joey, and Lorenzo!

I'm posting V2 even though I've yet to address all review comments as
I shall be out of office for the next 2 weeks. Therefore, I wanted to
make sure that the latest version was available for anyone to take a
look. Any outstanding and new comments will be addressed on my return.

The main outstanding changes are:

1. Rework the PPI save/restore mechanisms to remove the _entry/_exit
   from the vcpu, and instead use per-cpu data structures.
2. PPI injection needs clean up around shadow state tracking an
   manipulation.
3. PPI state tracking needs to be heaviliy optimised to reduce the
   number of locks taken and PPIs iterated over. This is now possible
   with the introduction of the masks, but remains to be implemented.
4. Allow for sparse PPI state storage. Given that most of the 128
   potential PPIs will never be used with a guest, it is extremely
   wasteful to allocate storage for them.

These changes are based on v6.19-rc1. As before, the first commit has
been cherry-picked from Marc's VTCR sanitisation series [3].

For those that are interested in the overall direction of the GICv5
KVM support, Marc Zyngier has very kindly agreed to host the full
*WIP* set of GICv5 KVM patches which can be found at [4]. These are
not intended for review, and require some serious clean up, but should
give a rough idea of what is still to come.

Thanks all for the feedback so far and any more you have,
Sascha

[1] https://developer.arm.com/documentation/aes0070/latest
[2] https://lore.kernel.org/all/20251212152215.675767-1-sascha.bischoff@arm=
.com/
[3] https://lore.kernel.org/all/20251210173024.561160-1-maz@kernel.org/
[4] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/l=
og/?h=3Dkvm-arm64/gicv5-full

Marc Zyngier (1):
  KVM: arm64: Account for RES1 bits in DECLARE_FEAT_MAP() and co

Sascha Bischoff (35):
  KVM: arm64: gic-v3: Switch vGIC-v3 to use generated ICH_VMCR_EL2
  arm64/sysreg: Drop ICH_HFGRTR_EL2.ICC_HAPR_EL1 and make RES1
  arm64/sysreg: Add remaining GICv5 ICC_ & ICH_ sysregs for KVM support
  arm64/sysreg: Add GICR CDNMIA encoding
  KVM: arm64: gic-v5: Add ARM_VGIC_V5 device to KVM headers
  KVM: arm64: gic: Introduce interrupt type helpers
  KVM: arm64: Introduce kvm_call_hyp_nvhe_res()
  KVM: arm64: gic-v5: Detect implemented PPIs on boot
  KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE
  KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs
  KVM: arm64: gic-v5: Add emulation for ICC_IAFFIDR_EL1 accesses
  KVM: arm64: gic: Set vgic_model before initing private IRQs
  KVM: arm64: gic-v5: Add vgic-v5 save/restore hyp interface
  KVM: arm64: gic-v5: Implement GICv5 load/put and save/restore
  KVM: arm64: gic-v5: Implement direct injection of PPIs
  KVM: arm64: gic: Introduce irq_queue and set_pending_state to irq_ops
  KVM: arm64: gic-v5: Implement PPI interrupt injection
  KVM: arm64: gic-v5: Check for pending PPIs
  KVM: arm64: gic-v5: Init Private IRQs (PPIs) for GICv5
  KVM: arm64: gic-v5: Finalize GICv5 PPIs and generate mask
  KVM: arm64: gic-v5: Trap and mask guest PPI register accesses
  KVM: arm64: gic-v5: Support GICv5 interrupts with KVM_IRQ_LINE
  KVM: arm64: gic-v5: Create, init vgic_v5
  KVM: arm64: gic-v5: Reset vcpu state
  KVM: arm64: gic-v5: Bump arch timer for GICv5
  KVM: arm64: gic-v5: Mandate architected PPI for PMU emulation on GICv5
  KVM: arm64: gic: Hide GICv5 for protected guests
  KVM: arm64: gic-v5: Hide FEAT_GCIE from NV GICv5 guests
  KVM: arm64: gic-v5: Introduce kvm_arm_vgic_v5_ops and register them
  KVM: arm64: gic-v5: Set ICH_VCTLR_EL2.En on boot
  irqchip/gic-v5: Check if impl is virt capable
  KVM: arm64: gic-v5: Probe for GICv5 device
  Documentation: KVM: Introduce documentation for VGICv5
  KVM: arm64: selftests: Introduce a minimal GICv5 PPI selftest
  KVM: arm64: gic-v5: Communicate userspace-drivable PPIs via a UAPI

 Documentation/virt/kvm/api.rst                |   6 +-
 .../virt/kvm/devices/arm-vgic-v5.rst          |  50 ++
 Documentation/virt/kvm/devices/index.rst      |   1 +
 arch/arm64/include/asm/el2_setup.h            |   3 +-
 arch/arm64/include/asm/kvm_asm.h              |   5 +
 arch/arm64/include/asm/kvm_host.h             |  35 +-
 arch/arm64/include/asm/kvm_hyp.h              |  10 +
 arch/arm64/include/asm/sysreg.h               |  28 +-
 arch/arm64/include/asm/vncr_mapping.h         |   3 +
 arch/arm64/include/uapi/asm/kvm.h             |   1 +
 arch/arm64/kvm/arch_timer.c                   | 112 +++-
 arch/arm64/kvm/arm.c                          |  29 +-
 arch/arm64/kvm/config.c                       | 145 ++++-
 arch/arm64/kvm/emulate-nested.c               | 123 +++-
 arch/arm64/kvm/hyp/include/hyp/switch.h       |  27 +
 arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  43 ++
 arch/arm64/kvm/hyp/nvhe/switch.c              |  15 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |   8 +
 arch/arm64/kvm/hyp/vgic-v3-sr.c               |  64 +-
 arch/arm64/kvm/hyp/vgic-v5-sr.c               | 146 +++++
 arch/arm64/kvm/hyp/vhe/Makefile               |   2 +-
 arch/arm64/kvm/nested.c                       |   5 +
 arch/arm64/kvm/pmu-emul.c                     |  21 +-
 arch/arm64/kvm/sys_regs.c                     | 190 +++++-
 arch/arm64/kvm/vgic/vgic-init.c               | 123 +++-
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |  99 ++-
 arch/arm64/kvm/vgic/vgic-mmio.c               |  28 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c          |   8 +-
 arch/arm64/kvm/vgic/vgic-v3.c                 |  48 +-
 arch/arm64/kvm/vgic/vgic-v5.c                 | 571 +++++++++++++++++-
 arch/arm64/kvm/vgic/vgic.c                    | 125 +++-
 arch/arm64/kvm/vgic/vgic.h                    |  70 ++-
 arch/arm64/tools/sysreg                       | 482 ++++++++++++++-
 drivers/irqchip/irq-gic-v5-irs.c              |   4 +
 drivers/irqchip/irq-gic-v5.c                  |  10 +
 include/kvm/arm_arch_timer.h                  |   7 +-
 include/kvm/arm_pmu.h                         |   5 +-
 include/kvm/arm_vgic.h                        | 160 ++++-
 include/linux/irqchip/arm-gic-v5.h            |  15 +
 include/linux/kvm_host.h                      |   1 +
 include/uapi/linux/kvm.h                      |   2 +
 tools/arch/arm64/include/uapi/asm/kvm.h       |   1 +
 tools/include/uapi/linux/kvm.h                |   2 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 248 ++++++++
 .../selftests/kvm/include/arm64/gic_v5.h      | 148 +++++
 47 files changed, 2965 insertions(+), 267 deletions(-)
 create mode 100644 Documentation/virt/kvm/devices/arm-vgic-v5.rst
 create mode 100644 arch/arm64/kvm/hyp/vgic-v5-sr.c
 create mode 100644 tools/testing/selftests/kvm/arm64/vgic_v5.c
 create mode 100644 tools/testing/selftests/kvm/include/arm64/gic_v5.h

--=20
2.34.1

