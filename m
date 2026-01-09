Return-Path: <kvm+bounces-67617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D5D2FD0B8D2
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:13:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 654E830B6B70
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:07:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B444A3659F2;
	Fri,  9 Jan 2026 17:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cn5rn5ya";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cn5rn5ya"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013002.outbound.protection.outlook.com [52.101.83.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31A5500973
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.2
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978390; cv=fail; b=uYN/QjKySb7aQ40X5XtLbBdlZeT4kHdPUXHqWJOvqCTTbB7tSyD5fvM+KSNTyfKBeMID3rzJN1rvuvSuqbMxkNMhgyql3aAJiyM9R75LwdqD+1IlIdX9V7yGSz4TaDzKoCALd+fyZfoU0fZWPQxWMUCSU91Gx8IVmd0Ik44Uh0E=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978390; c=relaxed/simple;
	bh=5+V4FtC1HhqoAz2M5P+L4A0ZmT5f4ADmw7slBKzzZiw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fxFpCSky3sfMCTdjP+Q6sqSHuxMBPzoHUbWyi55D4cLsFJS9z5/M54FayTARPWK44YspeznxPRY3clhK5By2UeAQqzjJUd85LEsDgDDUHPzwJKQepgh0UUr2eu3vMiiupeRVqaec9wcxHDXAftD2lBJTMJBnH4JaW5KxwyBUg8c=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cn5rn5ya; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cn5rn5ya; arc=fail smtp.client-ip=52.101.83.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=gPHGIA6hzeLNaj/nTyuD6QaiI0gn2jW71NdnX9//BSQrPs+wqyKHBsaP0Kx4+GcIEowlLKPpiew/kiZnj/dgKIkp8PzAwGjIbn3vag0msRW0iDXFmtnKZNMeFJUsMWhT07SOadi20N/CT2zpHF48xRiV9YoTMmUZITWNbZgm44pnrylC9W8pYsWjnyMzagGyhKPclLeMozQEIJghY5vUCq1O8V/81CTsTmfMOn2zHFUhelGhBNi1Us/EyHEbjdRjKvAfxvRpX5uYEhqiyf/MsbFSDm/GdzWhwyDh0JpOKT/Abp4AaUf6vTWdRUMTIiXDjq9ztNJhmbcLyr/CIGeKfw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UP9Z036mSRE+H6pWH3werY+sAvQkJvBs+OKzBle1E4s=;
 b=D6XbsidhKtfZoUK0F5P/8jHpX+SSkqvfY9hV8lMMeMU4IBZLIBlNUk33akqUxA7V05P9O7qbBVHnlVXxycUZPMy1XtUIBuj80GzoFsY+5ReaTgazmGgicYnX4D/48lnJFV2QoNbMk4QBBnTLW+Llpqf+qmjub21psor31fmnXBYy97kQar0U+GYlj7UynTXtRX42Cd3pghQM3s22Hkiw4ZkBTQhf6jXtDiuShBhH4AbjQPpqEY8N+BaJdR98SKb7OqmWpHI5tQVIfCwovhtf5DMnljfI7rb5FTUFJroxXKSYo2K6fq2Ou5HXwYq/WZ2oJ1kFM7kxC7Klq1lwEQ5vWA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UP9Z036mSRE+H6pWH3werY+sAvQkJvBs+OKzBle1E4s=;
 b=cn5rn5yaFNDVXiONkib+dwpgxjxRzYa1NVWRnWtj53AHGl7aRU+kNSa8L78WktHLtnZ2NgjD/DtTs+ppSPnop2j9mgwGbSyZmdcHCvAP4a6NMYdJ2e2cTgBmUEEGa4D1qV0vHSya9cb1/KUD023V9k01s+GwwbDk70mtL/nDIKQ=
Received: from AS4P251CA0016.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:5d3::8)
 by AS4PR08MB8096.eurprd08.prod.outlook.com (2603:10a6:20b:58b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Fri, 9 Jan
 2026 17:06:24 +0000
Received: from AM4PEPF00027A69.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d3:cafe::5c) by AS4P251CA0016.outlook.office365.com
 (2603:10a6:20b:5d3::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.5 via Frontend Transport; Fri, 9
 Jan 2026 17:06:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A69.mail.protection.outlook.com (10.167.16.87) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:06:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bwlv9QNXppwCBClSFFKw72l8lqVrWYkXh1rp/Ar/cVp70tJwsBcQgKutj815EBJTFLEft51c3qHpbP5s3TqPyqXU35Qxg33YRr00+1V9XcfeL1NnejEI4d3pOY6ME2UxViSOsXaY3+gmn+KP6/vU39rHkz6+L1QrNK40s+V/SSINRsaG31xlei14LeFtr1K2GX9ytvL1FG6nr5693yHQC8atbGWDVRS57Lbrp+Isu5lCeDH5+3le1OhkfuKNIq7+aS8JNpJM5YhJ+P2iz2OUIzp4zvvSRgDl7xdq14QKPPBCQ0Ro6YnyFCooL0StQMPhj6usenppe2YOqfLbEIOpTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UP9Z036mSRE+H6pWH3werY+sAvQkJvBs+OKzBle1E4s=;
 b=AgpuOlsxYQx9ij+EoMgRn+iI/PZZUYq4Ei5hsm1VpS4kmlUqx9KXXO3tHx1WWSTfxaA0q/jfSohYpr86IcZzkNdrfsFlTClowNCK0z4M480GFXhYvLk5DMVKGI1qk+W1UbOI9UwwJ3M8sdGkaFBLWSYaecB9tID1IybvNv324GoarefZJi29NbL5I4tHdSHoqxSIF8K1LW9hAabTgAM3VwZvly3VqXBMm4skVAxJhJZo/MiXfdAl2w7iyHrKLjt0nhOxxcfDgUzBoG2loLpm6tItYJM51FsjTj9io6Kl0ukssimWgva/x1B9kCOn2dTqwxwU0vGQywFL7n1WthPbCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UP9Z036mSRE+H6pWH3werY+sAvQkJvBs+OKzBle1E4s=;
 b=cn5rn5yaFNDVXiONkib+dwpgxjxRzYa1NVWRnWtj53AHGl7aRU+kNSa8L78WktHLtnZ2NgjD/DtTs+ppSPnop2j9mgwGbSyZmdcHCvAP4a6NMYdJ2e2cTgBmUEEGa4D1qV0vHSya9cb1/KUD023V9k01s+GwwbDk70mtL/nDIKQ=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by PA4PR08MB7386.eurprd08.prod.outlook.com (2603:10a6:102:2a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 17:05:21 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:05:21 +0000
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
Subject: [PATCH v3 30/36] KVM: arm64: gic-v5: Introduce kvm_arm_vgic_v5_ops
 and register them
Thread-Topic: [PATCH v3 30/36] KVM: arm64: gic-v5: Introduce
 kvm_arm_vgic_v5_ops and register them
Thread-Index: AQHcgYoQBOXgYNTtGU+zeixJ68FeHw==
Date: Fri, 9 Jan 2026 17:04:48 +0000
Message-ID: <20260109170400.1585048-31-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|PA4PR08MB7386:EE_|AM4PEPF00027A69:EE_|AS4PR08MB8096:EE_
X-MS-Office365-Filtering-Correlation-Id: 5090f747-0b7f-4bc9-811a-08de4fa16b75
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?GL5S+c57jEvumh8Cv6YhH4j7nwBTecqiMDsQcgul9NjJSmL5pU2i8b8zQO?=
 =?iso-8859-1?Q?UamaaIPbZy/Qi4r6hKL2NG8DK/cMqcO2SP76KhCMXrk9kPOYt3VleMp2Aa?=
 =?iso-8859-1?Q?bqHCQI4KwBPBJchHkkByZHa9Fk1Uzz+N9+S/Oaiu04wc/SayyimeVx1H9q?=
 =?iso-8859-1?Q?pTY/Q148EfHG9Bh/iKw4G0FFJVbigYZdg54kzx9KRuIQtE+wz1dgwnrs07?=
 =?iso-8859-1?Q?P2k6fgMoE95Twzw41Smbq+2fNYM+dBQSKp9OA9Unrxp6WSNvFkHxMj9ECD?=
 =?iso-8859-1?Q?ZwDc5pjr3TiAT/y7laRYBHWVLu/lUg65yIm3RTajlsclj0MHEyuCIUMEJN?=
 =?iso-8859-1?Q?eRKa7QDQWH3yzUHaaFiZg5Av7rjK5ozF1Jyz88v2Zbr8mBsudRVyrHJXxY?=
 =?iso-8859-1?Q?aKhheSssjvTjMBEq5xO+F0zA3jSKUfmXCSof4aKbTVWYwesJW+eXFTmHYu?=
 =?iso-8859-1?Q?u3eA8LosCIRrAkga6QZtL1FJDKqazUBgu9ZjlA5eLtAlijE6bw9QfaBT57?=
 =?iso-8859-1?Q?6vu9dTqQJcXtEXq9/Wx4WDqipUgscz+BFon/Q5p9nMer4y+JURo4IE4b+z?=
 =?iso-8859-1?Q?EkCQwfMo/ZsQkWjfQ5g0+y7RFnRmig+epeCbBpn5JTjKnMBM5l18dvkWhf?=
 =?iso-8859-1?Q?uEVWfz9wxFKmwNIw+Ihb0YSlFO0UobUgyDCu9fXL7jEiSVg+WQwzy8AuSE?=
 =?iso-8859-1?Q?NSpCV6kMSLwDBOf0MQB4MTENwsrMmYS/jocb/pR2HhybeavD7TyJTpBhgu?=
 =?iso-8859-1?Q?Trfs6JHbtoDJMIt9et9+zhPNa5volAuQdBnpmCc95YwI3tfjy0aR75t7FU?=
 =?iso-8859-1?Q?b4bBZRGkd6AEaVrQQvDciQYy/EOz3brwgjtaGID1WgxWojyeK1ettFVRkS?=
 =?iso-8859-1?Q?9OMbEHtV5c7a8EQi7zQV296xrQ1qz3Y+qkAj1j4dEJ2UJMPC96rFK9tQen?=
 =?iso-8859-1?Q?5tj7Vx9et9LpmCDdrlxWAqx99vHdamI7OzsujuQCzwgDVQ6RzNzA7YApDS?=
 =?iso-8859-1?Q?3AIsm4Jkam2jCyei5OYPo+toqzQAX6Q42Xn/zePFwkyJXGVVEGYYiXJGjV?=
 =?iso-8859-1?Q?mwkouO62uKsAiDEn5UQRVpsmM7jBwB0Jc4eXfY+MTmdtakbUlJaQoK+/oq?=
 =?iso-8859-1?Q?4VZkU+vnPT0b9FH+Ru5YKRtRJBPVMJGNoyzvyAMFrbjCkQXD+a5zaA/MKH?=
 =?iso-8859-1?Q?syKbXZjbu1+6Jj0VJ1kct32xVxk+zzxdunPTuJCybDwU7HeSjaxyptcEOJ?=
 =?iso-8859-1?Q?/DEUAS0c6nuOKChhA8PFsBEv8i0F1J/eHh3HtaI/bU7YvYZQqfbx4mHNWI?=
 =?iso-8859-1?Q?Y2i6xH2/pEXUL19pNTmNbrhtcH7AEYi7us46YnD5YtCHQeij7sWI/g2ZHm?=
 =?iso-8859-1?Q?PsBipcuRe619VwaqoUYaw4wpktMFWNvZqzDeRllttVP91FmFCEpexNI6Sw?=
 =?iso-8859-1?Q?hQXpUn/Tb+0aNQHjy53Rz7PGe4Gb2R6y2aGqG5YbYKY2Wf3no34rWqUXci?=
 =?iso-8859-1?Q?WYQbGPv0akx4BcWqtw7pPhUQtSm6Snx8ydnp5qMGvTlu540mhyNLiGi/qf?=
 =?iso-8859-1?Q?CloqLC8LIBoDrfcEcuRvwfuvvAJn?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB7386
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A69.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	09cece7d-72bf-49e4-f166-08de4fa1461b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|35042699022|1800799024|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?RAWXR2I8M+P1VBfWyPeUkfJ/SFWHrwS687gfq5DxyxVuDoJVyJRh4GpQTS?=
 =?iso-8859-1?Q?l4Rc6HoSlVxuBB7IJHwyykHv2GMv7Wi1LuNWZMVbajJRtFZITrEBQgN6Nt?=
 =?iso-8859-1?Q?lpJXtFr2SzRu103QYFuSd9eY0usisNdszlBGncbHJNfV5OccutqAPPvys0?=
 =?iso-8859-1?Q?6ZllF+Nx8LTSuVAJGcTiDqfOCkoXgSe8zYCBdEVIWqLzuEAxTMUNZkL5F5?=
 =?iso-8859-1?Q?gPOXjJRT7iAw5u4rG4zLsFFHhE0Rafnn2uZ3ytQWwrYYQJ4fUx9fxpDsQZ?=
 =?iso-8859-1?Q?M9f5Yim23Hi3X+q2wcWiDmi1gAWzvjfVIVcEKeHNK3cRLgYUQ6Eq7Ifao0?=
 =?iso-8859-1?Q?7fQoUIW6r+GdMtoGwiCJaUn07pt5amZmo5c61Qm6+i+KEdAeqS1+oVaVha?=
 =?iso-8859-1?Q?FCsFlgeGhohtqPnacyfJ1jY+71ptPn+DlezHU20Z7UholQ8431cDzaBALm?=
 =?iso-8859-1?Q?9KwRbK0vTwGkksbolprATxu9Q2q1F46Oqx9bcC0hMoDf3GTz+vkBbC6WiC?=
 =?iso-8859-1?Q?Krm8eu+CZkXoe+gknFF9rml8kGAnKzFoLspJMbOKXEhXpr6uCiR65GZTLF?=
 =?iso-8859-1?Q?p5VczS3u9O7HNTdydlowZ28Tx1IgQs7dzXtJhWD/DjfxNFhBJE9PcwPml2?=
 =?iso-8859-1?Q?FS236YUfwugf105p4qq5Xu2kzMEOp++A55Mutxv3+/98AAHg6dlqzXmm/d?=
 =?iso-8859-1?Q?1W0MfI6h3C30oHhPCRdctMxFCF1miDRXiQcxhYEdEw6gvajoy2H5TsH8LL?=
 =?iso-8859-1?Q?Zi4M0hvO6hJdeVYarJ+kfOetXD2359YdWRHCtOCWHjBG0AlbtgMGd1h9G6?=
 =?iso-8859-1?Q?nPFr3Zy/yW3MK70ApGuIQrOQrCHMpnoxX4ySSq17f+3qiUspqcYXwF5klY?=
 =?iso-8859-1?Q?d9g8v+EfCeR8y1iu6w+b/NfwDuQTWwGTkqi4NI6a+eThd3StWmU70eqw/a?=
 =?iso-8859-1?Q?Z1DgTVPvgvh24Gi8hhSwlRY+6ZlVBcHLOizej8DryfT+rJpX5+fdEZWwYD?=
 =?iso-8859-1?Q?Wo8/IepuO4nih4CW0V3JObrKWaLy94Y1KTwVSubr1xP4cXf1m0v5jp6V73?=
 =?iso-8859-1?Q?fUeIIJups4nqJPvqq4+5rvqJGrz2Qj1wVIMpTodpVhbY9TZMsPDOcNIZBY?=
 =?iso-8859-1?Q?su/LmpPgkuljcWz7CvUHGiHx0EQKs9kP04uvP03It6BB2A5IrOIEEKnhQa?=
 =?iso-8859-1?Q?YcXYqZfdM+0+DxKAlzpjVFtH86lyLjzDrBuaMd2nISWUEFeNfAo6a9hxdi?=
 =?iso-8859-1?Q?Kci0swwtSDNHFCZnbfXTA55EaCDjEXN9C0bRuZKsgXdOFCgJkXIrTPE3k5?=
 =?iso-8859-1?Q?mULaBr0nrrsecmffXID4LhJ6pTB+shixcnIrx4mMsupUKJA56WLZFnND/G?=
 =?iso-8859-1?Q?RsoHOT1GH1vo+VWN/THy80zmsQAXg6k//Gl3dBOuzA3CI2yMK4cEeqZz+b?=
 =?iso-8859-1?Q?E9JIlHJVLszpQxxJoa8PKZHiEBrgITR/nFBGKXaZsiZcOroZjfFseTDHeM?=
 =?iso-8859-1?Q?qdvxLnrwt6rstJV6M/tvx95rPNOGVFcjx03YpT2NaopS/GZkPPhpxnAdYY?=
 =?iso-8859-1?Q?ZsTdLtlSNzNO620vy7YryGeZDel1L/+LWAKM/voamauHxwnXvG9lkYmsyN?=
 =?iso-8859-1?Q?VEpaIo6V2E6UQ=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(35042699022)(1800799024)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:06:24.3386
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5090f747-0b7f-4bc9-811a-08de4fa16b75
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A69.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB8096

Only the KVM_DEV_ARM_VGIC_GRP_CTRL->KVM_DEV_ARM_VGIC_CTRL_INIT op is
currently supported. All other ops are stubbed out.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 74 +++++++++++++++++++++++++++
 include/linux/kvm_host.h              |  1 +
 2 files changed, 75 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index b12ba99a423e5..772da54c1518b 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -336,6 +336,10 @@ int kvm_register_vgic_device(unsigned long type)
 			break;
 		ret =3D kvm_vgic_register_its_device();
 		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		ret =3D kvm_register_device_ops(&kvm_arm_vgic_v5_ops,
+					      KVM_DEV_TYPE_ARM_VGIC_V5);
+		break;
 	}
=20
 	return ret;
@@ -715,3 +719,73 @@ struct kvm_device_ops kvm_arm_vgic_v3_ops =3D {
 	.get_attr =3D vgic_v3_get_attr,
 	.has_attr =3D vgic_v3_has_attr,
 };
+
+static int vgic_v5_set_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			return vgic_set_common_attr(dev, attr);
+		default:
+			return -ENXIO;
+		}
+	default:
+		return -ENXIO;
+	}
+
+}
+
+static int vgic_v5_get_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			return vgic_get_common_attr(dev, attr);
+		default:
+			return -ENXIO;
+		}
+	default:
+		return -ENXIO;
+	}
+}
+
+static int vgic_v5_has_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			return 0;
+		default:
+			return -ENXIO;
+		}
+	default:
+		return -ENXIO;
+	}
+}
+
+struct kvm_device_ops kvm_arm_vgic_v5_ops =3D {
+	.name =3D "kvm-arm-vgic-v5",
+	.create =3D vgic_create,
+	.destroy =3D vgic_destroy,
+	.set_attr =3D vgic_v5_set_attr,
+	.get_attr =3D vgic_v5_get_attr,
+	.has_attr =3D vgic_v5_has_attr,
+};
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d93f75b05ae22..d6082f06ccae3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2368,6 +2368,7 @@ void kvm_unregister_device_ops(u32 type);
 extern struct kvm_device_ops kvm_mpic_ops;
 extern struct kvm_device_ops kvm_arm_vgic_v2_ops;
 extern struct kvm_device_ops kvm_arm_vgic_v3_ops;
+extern struct kvm_device_ops kvm_arm_vgic_v5_ops;
=20
 #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
=20
--=20
2.34.1

