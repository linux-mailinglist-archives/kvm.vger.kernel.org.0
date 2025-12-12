Return-Path: <kvm+bounces-65862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CC65ACB91DD
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:27:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3BE7F30EC0B2
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:24:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B56631B11D;
	Fri, 12 Dec 2025 15:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="c4f7pyd1";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="c4f7pyd1"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013067.outbound.protection.outlook.com [52.101.72.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F114322B8B
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.67
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553037; cv=fail; b=IFMSyuSmMpz3nszq/yMDd0nKJWYH4AnfTk4hkbKzWXYmAIZ+1TSWjj2WYSm8ddg56iPG3zbdzHZhVCJNnhBfgadk+nolQO7/v7SvGMw8lbZQeMqi1/CAa2Pez34SkNJyqwSkgDVDafZ6b3OJpUt3kXPTG/uJ7KNRizmt141MdVs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553037; c=relaxed/simple;
	bh=ReZ9z86deaRkwQzhvXKb7J1jECsCYUuacMo3nqKRucc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eYns/krl0yH88UuxyqcwLTDYgdypNa/hRbwlWhyVXLIZVedYWgQ3gD1WywJFhvRZKOj2etlkb27MyiXDkH5WiCQ35J8SYHrfHCypgsdTehCEMtewbsAff/FYBBkR2MiX5R5PJky/3d+ZTD5qt3wgLPbcAfg8wSLnvKR1htgs9mA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=c4f7pyd1; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=c4f7pyd1; arc=fail smtp.client-ip=52.101.72.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=NYuxM1D2ssYQEV2oXTULLV8kp3BAC1NBnP+KpI+sp9XytdEAbcgGOZ+4HwZ8JKgAI+89kJY6nHxQt97hOaFWkYWJIj4wPST74+dBr5P+eegmWoWUsLWqAd9PG0cJXZf2PMy2top0G+hW6aarF7kyRYhvPOEnWOHiheen9mEiW2wjjZbjU4juCBPS6NUk/Q9H12KI9jv+QiMkuPkrrPBHRlc/YnMaTrQXo0V/dd8zkla5bZS2D7GJZyUF4lKl4EGuZSwiyJ7qU6urNC55c5lW1Ysqz1DxYxE+iaR8RFLXbv+3gbef6GAKOd1rnImqpGr1MyOpodwibXKIdVNItSQ7Gg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jHr3bfwXjkuVaqlAK22HcL0FkOBH5SM8pIwAPJHFcRM=;
 b=hUlbdEL5u/Fx5xlw0nv+ZpdSOf29+DrDk3B+7PHzOJ4ygb7zXZkdkd8Jzw1P/5bSNS9DCCH9msY9HvfJJxtFzYZx9HLct87sU5ok5kKnu4ZTafzY6G7Atsmw6vas16sQwYfbJsiMmVcoxU9/qMgq7LPykiwAjhPOeT/4x2tmXdgZxXdYuuUmX/xzLv4+FER2TUJBQ1qOQI2w/2d68IzA9P7JOWx1bT+Dwb8gyn5qUtX1Au6t4lvotv9YRr6zCuuKJMjFzJ9LaK4z5xet421XfGySDxhee80cM7fNivKs95ixvNBr+HQzX2B0G1vZRG1rgHjIcS75nsAl5EWoPh+G3A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jHr3bfwXjkuVaqlAK22HcL0FkOBH5SM8pIwAPJHFcRM=;
 b=c4f7pyd1MjH1PIszDdNCRuqiXe2AElVBaSc5H67FYTnLUXgtLBPZj4l3m7KSveYa/NqZRbVZH/3jsY6HcgLQWy0jccEceY2JclwN7N+b1u/jKtDwCcXIdYR2arCPRBk/65Gsjupi4zc6ujKUMi6ywmg98C2saVwTXPujTcPPcv4=
Received: from DUZPR01CA0009.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c3::16) by AS8PR08MB9145.eurprd08.prod.outlook.com
 (2603:10a6:20b:57c::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Fri, 12 Dec
 2025 15:23:44 +0000
Received: from DU2PEPF00028CFE.eurprd03.prod.outlook.com
 (2603:10a6:10:3c3:cafe::8b) by DUZPR01CA0009.outlook.office365.com
 (2603:10a6:10:3c3::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.11 via Frontend Transport; Fri,
 12 Dec 2025 15:23:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028CFE.mail.protection.outlook.com (10.167.242.182) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.8
 via Frontend Transport; Fri, 12 Dec 2025 15:23:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=imcektZCoC4/LqGkshQwPRTnevUrr6f+JbyK0jsQGteRis8Om/KsyqRPvso3wAUYgQ/8fEfi/d1wGCen/YI6U55tfVAfUQWZAOpmVPVerv8F3N2cMjrFvBo7hcQhGmth3+f7eFqVYb6ciBpzqL8Kh6BsmSyiOkLYLrwm2+Z4/30ylyCAIeYY3KCXmOkVrLJNhKRVBM2ODl3j6jaL/ULsofdUKdCC/DWGO/YX/XOO9rQ7k1qnle9iW6KQHAsD5jwGf1ugQH1/Mj/QrmcBkpigPTdGFtHBmEIv82Hw6kxGx6Yp47uqVpIsgdDeJr1th/ThjA7Fb4NETfm4vFLYRBd8SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jHr3bfwXjkuVaqlAK22HcL0FkOBH5SM8pIwAPJHFcRM=;
 b=VWri6M7PdH3mw4OVpxnfseEQkfIRxDMShRHt4GQBWgWFPTws7QfbaLaVlhICRXlwR/8QyxH/zs5I/w76h7ne72lIA4goBbmT6ySzgLnm34AX21sk94phoX9Rdnv2wkWIeJWryZyh5yFVn5wt/LEC167EN/bydoWi13Ja/u59c2G3gD66mlIxS0HBXnopkAbWnrb2Foh/f+ML2cvepwaTgci+WedCkSnEYEMxKyviWWT2exXAvU1Lj3mOqnPvpcUkw2YUG5iWoM6YNMe3yE1Y/FDWYBXg731AJ2D4jpCTwUZh8MwIul9HjLfM+ewh/o/XA/qNNHGtgETjedt3cYp+zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jHr3bfwXjkuVaqlAK22HcL0FkOBH5SM8pIwAPJHFcRM=;
 b=c4f7pyd1MjH1PIszDdNCRuqiXe2AElVBaSc5H67FYTnLUXgtLBPZj4l3m7KSveYa/NqZRbVZH/3jsY6HcgLQWy0jccEceY2JclwN7N+b1u/jKtDwCcXIdYR2arCPRBk/65Gsjupi4zc6ujKUMi6ywmg98C2saVwTXPujTcPPcv4=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PA6PR08MB10565.eurprd08.prod.outlook.com (2603:10a6:102:3ca::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 15:22:41 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:41 +0000
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
Subject: [PATCH 17/32] KVM: arm64: gic-v5: Implement PPI interrupt injection
Thread-Topic: [PATCH 17/32] KVM: arm64: gic-v5: Implement PPI interrupt
 injection
Thread-Index: AQHca3soCt0gNoQdTkedfOf0Y/AANA==
Date: Fri, 12 Dec 2025 15:22:41 +0000
Message-ID: <20251212152215.675767-18-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|PA6PR08MB10565:EE_|DU2PEPF00028CFE:EE_|AS8PR08MB9145:EE_
X-MS-Office365-Filtering-Correlation-Id: b1bee296-ed0d-454a-e4ac-08de3992706a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?DrlSLaFg9pRYlRs4FQd1IFE8ALze6jpezMqxe3gdWfnSsDyGjBTswQuiKc?=
 =?iso-8859-1?Q?faRW5dsZIE2vzrwsmm0o/ccLq2v1PQLdbUc3Zp82+MQS6tVNcytvMdb7ll?=
 =?iso-8859-1?Q?/CPeggwgzLaCzaff0Wu6OB/9ufjpdyUNpOS5H+XQWrmwAvf82r+166jQV9?=
 =?iso-8859-1?Q?qfwESUQ8C3Hcw7hvc2fkAxVNsQlIHBXvBoliGtQs7fSYfoVPviI6Tk3TzB?=
 =?iso-8859-1?Q?JuAmJn1w20xGV4U9Ake6UcvoBIaLGsfgm7ZuqCS898faqvCadqo7sF2Kqs?=
 =?iso-8859-1?Q?oniktmTMj5uMSUfvtY32TRFOVv+TzpiVIfIGjbBPTy7+UlXSIebN6irsla?=
 =?iso-8859-1?Q?abXCevaO7isPhOwdsgISqYpqc27/PGny02ELzDM0NHtbmdhIbBr7F8hW7H?=
 =?iso-8859-1?Q?ZhvDIEA1bNp7e1+LRfSeLccyF9pdHk1iY5NMqjhrElY1ti9oadtfSG9vJK?=
 =?iso-8859-1?Q?9ETYK6xxGFX3y6wNWPUXyzs7yGkMS1GwjZ0DIq7O9U/Z5/9ZI1kFmf2LBm?=
 =?iso-8859-1?Q?PYDlIPtHHZAyg9enqPrY5rJy6CnDNxLBRsyBwxh9fPYO5gk/GYopOjYyhl?=
 =?iso-8859-1?Q?nw4CktrxccJ4ut/0wEO00Dn0khyazYxLDm+olMuxEOhWTq8oE6qpGWQzPg?=
 =?iso-8859-1?Q?aMJYD/iYvOjOjrshh1NEQpBKMzpTq++aQXexcX86QH3SsIOF2SiD7hUD8P?=
 =?iso-8859-1?Q?s0cdCB2o2b7fDaxwgWH1mzFiT8uiarYRg8590GczE5C7sMCVAS9wnn6MS6?=
 =?iso-8859-1?Q?/MP6qfwMcDVkvJdfVaMwGltSY21+UsSBF3SoSIjVdMP/O6FtgFzXbJmdMd?=
 =?iso-8859-1?Q?WaawIVSpG+Ek4Fjot6EpH7b0WVtRJrhLBq813XxDgm8xIGp74eajSRR5DQ?=
 =?iso-8859-1?Q?QUyUhoMM6DrEJvkI91H2eIJ5hQmz4LIlU1WS003GBd0gC3p6mz6uYQTyg0?=
 =?iso-8859-1?Q?xHRlxnuUuMwvFzgCNf+EkNrMFPEbqMS69ufCN+MIFcVaiv6TdhES5wgqau?=
 =?iso-8859-1?Q?Ey0PlnDzjlvVVKQj3AATyqXN46pvv235cQSxKNqDOXaKET+i1sSoybA8fm?=
 =?iso-8859-1?Q?EXZhn/i1YNQsO9ZZFxVxfMA2mtpVMs+XIvzIrsQO4WAAeM1XYRnXgxQBYS?=
 =?iso-8859-1?Q?UTKPAQRIhQN8ivWaA4D5BDH6FtTK+5q7TWEvwgTqdPY8CdJXsubIXiEoqQ?=
 =?iso-8859-1?Q?pAOgIIB328Vr1amFZlvezxdICoYmG9t/TaWiz4yoF8rqownVMxCrHGvfab?=
 =?iso-8859-1?Q?3p04y6EySZGuwiyDRLpBffx+LLb8/QEtaaPvlc4uUQjZbhHTbuopJT/np6?=
 =?iso-8859-1?Q?FLVe0C8Jxsw5YtcY4DL1IgmGqDGJZLaAI0N/d94Lidfm7oj49DlF955ngo?=
 =?iso-8859-1?Q?VU7lNti8EDPP2xarXByIOQUl1yKZ3Q2XQEq/+GWCt3Bglc9Db5XDlQdZc4?=
 =?iso-8859-1?Q?kAJRHzL6ageQye9ZHPbukzfW8Tli7aYf+BCahqrqSBNfOqeyBas1e829ku?=
 =?iso-8859-1?Q?f7gCL7VjuVuMPGISV6+XeiteQmrRkPWiElfvQZZhJrH7r0W0zm18O0GgbF?=
 =?iso-8859-1?Q?q6v/uIBWu4CrwJNwlLIcKiEbbi/2?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10565
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028CFE.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6e648be1-a50d-4ae0-97e4-08de39924ae4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|376014|82310400026|36860700013|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?vwJptN3G7l7LZbJdutf9OCcZNNmo3heSUJCC/GPJHWZ+JoxsKOLkyZ4NJ5?=
 =?iso-8859-1?Q?vDwTiexFhA0KKUC19X35tzf/L7zoAyWJ5E6UsVd0BQWb0xEv/yH/PS2+Ww?=
 =?iso-8859-1?Q?Uq7wNcS/n6mxUdBE/YXD4A0KXGAyRl0r1wp49bZp7vRFoDLONlR2931Uap?=
 =?iso-8859-1?Q?D12Q1Yb4TZUIjClC/kJHCMPj0rxpJsFAvi5X/bzEYbBgVxHPr3W/GfIjnV?=
 =?iso-8859-1?Q?W7GnugyxOuvfxSsnoCRNnvP6wZowFdtLcM8lQjS874Ycpm7IHd8fNX/7wM?=
 =?iso-8859-1?Q?jKnPYXvU92v+w4n4nftQ108M/tEC5l55rl2II2oRpg+3jyVk1X1s/06Jz/?=
 =?iso-8859-1?Q?695azF+lCGnd8XRLMfdNRrKgp1NqYT9Li4GBagIemn0dvNKfM8tZAtSzE6?=
 =?iso-8859-1?Q?w+0CSuS6EKZEYdy8XcbGxNPoChJ5qdg/0ZWMkrvcpPEN7/G3ku84Sglgxp?=
 =?iso-8859-1?Q?NU5LmClL2v895KOzMfOmnH1mrN2wXuv4ALrFvLreQfi0v2RhlBq5nkQ6N8?=
 =?iso-8859-1?Q?8nJJH6mTgfRDja4DtcwakW++P9pgMpoyCE+Gl8473VL7zACe5q3UC7TZ3R?=
 =?iso-8859-1?Q?3QVBX5k/mUyQcJIh4XyLeKM6iLeSh2P5ev5BnqUiBfQw4DsSi4DY04Hwzz?=
 =?iso-8859-1?Q?JUi088BLkJueUhpPv/1GCYF3DHruR/xrf7zHZvC4UisiWWb/8ulAf8SAZT?=
 =?iso-8859-1?Q?uAaEfsJXnxYAxYFz4gmR0fcfhrlcvb6zHyh1m+s+xdX0jBKBjN2M2QGW05?=
 =?iso-8859-1?Q?/muILu3Idz8199SlYL+m4jQh3Z+lmZBuHFJ1kqiBHbs6y8s0qHZjU69vRJ?=
 =?iso-8859-1?Q?TUv+LPt/mKZdoTPaguTJ0WG8yoOgnnbMoDoaNhYtME8qJSlkMH5+Dkc8EL?=
 =?iso-8859-1?Q?s8VqLHSVz1t1IxYEqWvfYVNMoJpEeZDTJyVUTzbEozSzqwwi1nrCgkCI8N?=
 =?iso-8859-1?Q?G1YIAexRV9PMRl7FSuul2G5IZMR8Mda7ZioGQ+a8QGXg8+UrLQJKCsRpfY?=
 =?iso-8859-1?Q?3BN0VM0TxB46cW+90YEoU2MBvOggD4dN8OUaAMKaNLOVoufa5RvB45geI3?=
 =?iso-8859-1?Q?BxyEN5kp0Z3PH++FvFf1aH5APzNi/9FUuX+JjdgSuVhLlo07Un6ngQqQyP?=
 =?iso-8859-1?Q?LGyJhfRx5LOIu/umLhaaGyehmBbs21VgqzBoYnK1G9p3Ucx0N0fxroqKQD?=
 =?iso-8859-1?Q?CG2QVLwgJO6thK2fTZdGvVBxonbmzTjk0SeHnhCUDf0j11bIpGoVcO4967?=
 =?iso-8859-1?Q?/Q++c8CakyI2Db3FtAq6yxZAex+OkeXgCZirdtpSIoG19NHqof5dI3FYGO?=
 =?iso-8859-1?Q?TxIBLlF/3bU2S2bV9/0+PVtGXfaMk4HN+IbI/urhgTnJdrFSY7+8iHEFDC?=
 =?iso-8859-1?Q?1RkqXcJWqolvqy1ZRkXxoD0GgKdYzpVcBmJs+tJ/StITqf93W5RSbgKgGr?=
 =?iso-8859-1?Q?VRKN+KlomgQ85ytQ7wLM7OpVhQ241ulHgxO6jWO7cveIi3C3mjx9AaXjUy?=
 =?iso-8859-1?Q?sSIIDGx004oGwu9GRLeMlTfZK/E6jZBljHAqR9FJNS4facxWbXaoAm7Rg9?=
 =?iso-8859-1?Q?Sk8Ny9MOiQjZ0AnN5AxoywSd/zScjVKJ0nlUNmUaZiNjLsW3T4INX2C2Jc?=
 =?iso-8859-1?Q?6x4EmyYPOh9y8=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(376014)(82310400026)(36860700013)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:44.6090
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1bee296-ed0d-454a-e4ac-08de3992706a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028CFE.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9145

This change introduces interrupt injection for PPIs for GICv5-based
guests.

The lifecycle of PPIs is largely managed by the hardware for a GICv5
system. The hypervisor injects pending state into the guest by using
the ICH_PPI_PENDRx_EL2 registers. These are used by the hardware to
pick a Highest Priority Pending Interrupt (HPPI) for the guest based
on the enable state of each individual interrupt. The enable state and
priority for each interrupt are provided by the guest itself (through
writes to the PPI registers).

When Direct Virtual Interrupt (DVI) is set for a particular PPI, the
hypervisor is even able to skip the injection of the pending state
altogether - it all happens in hardware.

The result of the above is that no AP lists are required for GICv5,
unlike for older GICs. Instead, for PPIs the ICH_PPI_* registers
fulfil the same purpose for all 128 PPIs. Hence, as long as the
ICH_PPI_* registers are populated prior to guest entry, and merged
back into the KVM shadow state on exit, the PPI state is preserved,
and interrupts can be injected.

When injecting the state of a PPI the state is merged into the KVM's
shadow state using the set_pending_state irq_op. The directly sets the
relevant bit in the shadow ICH_PPI_PENDRx_EL2, which is presented to
the guest (and GICv5 hardware) on next guest entry. The
queue_irq_unlock irq_op is required to kick the vCPU to ensure that it
seems the new state. The result is that no AP lists are used for
private interrupts on GICv5.

Prior to entering the guest, vgic_v5_flush_ppi_state is called from
kvm_vgic_flush_hwstate. The effectively snapshots the shadow PPI
pending state (twice - an entry and an exit copy) in order to track
any changes. These changes can come from a guest consuming an
interrupt or from a guest making an Edge-triggered interrupt pending.

When returning from running a guest, the guest's PPI state is merged
back into KVM's shadow state in vgic_v5_merge_ppi_state from
kvm_vgic_sync_hwstate. The Enable and Active state is synced back for
all PPIs, and the pending state is synced back for Edge PPIs (Level is
driven directly by the devices generating said levels). The incoming
pending state from the guest is merged with KVM's shadow state to
avoid losing any incoming interrupts.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 157 ++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c    |  35 ++++++--
 arch/arm64/kvm/vgic/vgic.h    |  49 ++++++++---
 include/kvm/arm_vgic.h        |   3 +
 4 files changed, 226 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 22558080711eb..d54595fbf4586 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -54,6 +54,163 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+static bool vgic_v5_ppi_set_pending_state(struct kvm_vcpu *vcpu,
+					  struct vgic_irq *irq)
+{
+	struct vgic_v5_cpu_if *cpu_if;
+	const u32 id_bit =3D BIT_ULL(irq->intid % 64);
+	const u32 reg =3D FIELD_GET(GICV5_HWIRQ_ID, irq->intid) / 64;
+
+	if (!vcpu || !irq)
+		return false;
+
+	/* Skip injecting the state altogether */
+	if (irq->directly_injected)
+		return true;
+
+	cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	if (irq_is_pending(irq))
+		cpu_if->vgic_ppi_pendr[reg] |=3D id_bit;
+	else
+		cpu_if->vgic_ppi_pendr[reg] &=3D ~id_bit;
+
+	return true;
+}
+
+/*
+ * For GICv5, the PPIs are mostly directly managed by the hardware. We
+ * (the hypervisor) handle the pending, active, enable state
+ * save/restore, but don't need the PPIs to be queued on a per-VCPU AP
+ * list. Therefore, sanity check the state, unlock, and return.
+ */
+static bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq =
*irq,
+					 unsigned long flags)
+	__releases(&irq->irq_lock)
+{
+	struct kvm_vcpu *vcpu;
+
+	lockdep_assert_held(&irq->irq_lock);
+
+	if (WARN_ON_ONCE(!irq_is_ppi_v5(irq->intid)))
+		return false;
+
+	vcpu =3D irq->target_vcpu;
+	if (WARN_ON_ONCE(!vcpu))
+		return false;
+
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+
+	/* Directly kick the target VCPU to make sure it sees the IRQ */
+	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
+	kvm_vcpu_kick(vcpu);
+
+	return true;
+}
+
+static struct irq_ops vgic_v5_ppi_irq_ops =3D {
+	.set_pending_state =3D vgic_v5_ppi_set_pending_state,
+	.queue_irq_unlock =3D vgic_v5_ppi_queue_irq_unlock,
+};
+
+void vgic_v5_set_ppi_ops(struct vgic_irq *irq)
+{
+	if (WARN_ON(!irq) || WARN_ON(irq->ops))
+		return;
+
+	irq->ops =3D &vgic_v5_ppi_irq_ops;
+}
+
+/*
+ * Detect any PPIs state changes, and propagate the state with KVM's
+ * shadow structures.
+ */
+static void vgic_v5_merge_ppi_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	unsigned long flags;
+	int i, reg;
+
+	for (reg =3D 0; reg < 2; reg++) {
+		unsigned long changed_bits;
+		const unsigned long enabler =3D cpu_if->vgic_ich_ppi_enabler_exit[reg];
+		const unsigned long activer =3D cpu_if->vgic_ppi_activer_exit[reg];
+		const unsigned long pendr =3D cpu_if->vgic_ppi_pendr_exit[reg];
+
+		/*
+		 * Track what changed across enabler, activer, pendr, but mask
+		 * with ~DVI.
+		 */
+		changed_bits =3D cpu_if->vgic_ich_ppi_enabler_entry[reg] ^ enabler;
+		changed_bits |=3D cpu_if->vgic_ppi_activer_entry[reg] ^ activer;
+		changed_bits |=3D cpu_if->vgic_ppi_pendr_entry[reg] ^ pendr;
+		changed_bits &=3D ~cpu_if->vgic_ppi_dvir[reg];
+
+		for_each_set_bit(i, &changed_bits, 64) {
+			struct vgic_irq *irq;
+			u32 intid;
+
+			intid =3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
+			intid |=3D FIELD_PREP(GICV5_HWIRQ_ID, reg * 64 + i);
+
+			irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+			raw_spin_lock_irqsave(&irq->irq_lock, flags);
+			irq->enabled =3D !!(enabler & BIT(i));
+			irq->active =3D !!(activer & BIT(i));
+			/* This is an OR to avoid losing incoming edges! */
+			if (irq->config =3D=3D VGIC_CONFIG_EDGE)
+				irq->pending_latch |=3D !!(pendr & BIT(i));
+			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+
+			vgic_put_irq(vcpu->kvm, irq);
+		}
+
+		/* Re-inject the exit state as entry state next time! */
+		cpu_if->vgic_ich_ppi_enabler_entry[reg] =3D enabler;
+		cpu_if->vgic_ppi_activer_entry[reg] =3D activer;
+
+		/*
+		 * Pending state is a bit different. We only propagate back
+		 * pending state for Edge interrupts. Moreover, this is OR'd
+		 * with the incoming state to make sure we don't lose incoming
+		 * edges. Use the (inverse) HMR to mask off all Level bits, and
+		 * OR.
+		 */
+		cpu_if->vgic_ppi_pendr[reg] |=3D pendr & ~cpu_if->vgic_ppi_hmr[reg];
+	}
+}
+
+void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/*
+	 * We're about to enter the guest. Copy the shadow state to the pending
+	 * reg that will be written to the ICH_PPI_PENDRx_EL2 regs. While the
+	 * guest is running we track any incoming changes to the pending state in
+	 * vgic_ppi_pendr. The incoming changes are merged with the outgoing
+	 * changes on the return path.
+	 */
+	cpu_if->vgic_ppi_pendr_entry[0] =3D cpu_if->vgic_ppi_pendr[0];
+	cpu_if->vgic_ppi_pendr_entry[1] =3D cpu_if->vgic_ppi_pendr[1];
+
+	/*
+	 * Make sure that we can correctly detect "edges" in the PPI
+	 * state. There's a path where we never actually enter the guest, and
+	 * failure to do this risks losing pending state
+	 */
+	cpu_if->vgic_ppi_pendr_exit[0] =3D cpu_if->vgic_ppi_pendr[0];
+	cpu_if->vgic_ppi_pendr_exit[1] =3D cpu_if->vgic_ppi_pendr[1];
+
+}
+
+void vgic_v5_fold_irq_state(struct kvm_vcpu *vcpu)
+{
+	/* Sync back the guest PPI state to the KVM shadow state */
+	vgic_v5_merge_ppi_state(vcpu);
+}
+
 /*
  * Sets/clears the corresponding bit in the ICH_PPI_DVIR register.
  */
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index fc01c6d07fe62..e534876656ca7 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -105,6 +105,15 @@ struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vc=
pu, u32 intid)
 	if (WARN_ON(!vcpu))
 		return NULL;
=20
+	if (vcpu->kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5) {
+		u32 int_num =3D FIELD_GET(GICV5_HWIRQ_ID, intid);
+
+		if (irq_is_ppi_v5(intid)) {
+			int_num =3D array_index_nospec(int_num, VGIC_V5_NR_PRIVATE_IRQS);
+			return &vcpu->arch.vgic_cpu.private_irqs[int_num];
+		}
+	}
+
 	/* SGIs and PPIs */
 	if (intid < VGIC_NR_PRIVATE_IRQS) {
 		intid =3D array_index_nospec(intid, VGIC_NR_PRIVATE_IRQS);
@@ -258,10 +267,12 @@ struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *=
irq)
 	 * If the distributor is disabled, pending interrupts shouldn't be
 	 * forwarded.
 	 */
-	if (irq->enabled && irq_is_pending(irq)) {
-		if (unlikely(irq->target_vcpu &&
-			     !irq->target_vcpu->kvm->arch.vgic.enabled))
-			return NULL;
+	if (irq_is_enabled(irq) && irq_is_pending(irq)) {
+		if (irq->target_vcpu) {
+			if (!vgic_is_v5(irq->target_vcpu->kvm) &&
+			    unlikely(!irq->target_vcpu->kvm->arch.vgic.enabled))
+				return NULL;
+		}
=20
 		return irq->target_vcpu;
 	}
@@ -1044,7 +1055,11 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 	if (can_access_vgic_from_kernel())
 		vgic_save_state(vcpu);
=20
-	vgic_fold_lr_state(vcpu);
+	if (!vgic_is_v5(vcpu->kvm))
+		vgic_fold_lr_state(vcpu);
+	else
+		vgic_v5_fold_irq_state(vcpu);
+
 	vgic_prune_ap_list(vcpu);
 }
=20
@@ -1105,13 +1120,17 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
=20
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
=20
-	scoped_guard(raw_spinlock, &vcpu->arch.vgic_cpu.ap_list_lock)
-		vgic_flush_lr_state(vcpu);
+	if (!vgic_is_v5(vcpu->kvm)) {
+		scoped_guard(raw_spinlock, &vcpu->arch.vgic_cpu.ap_list_lock)
+			vgic_flush_lr_state(vcpu);
+	} else {
+		vgic_v5_flush_ppi_state(vcpu);
+	}
=20
 	if (can_access_vgic_from_kernel())
 		vgic_restore_state(vcpu);
=20
-	if (vgic_supports_direct_irqs(vcpu->kvm))
+	if (vgic_supports_direct_irqs(vcpu->kvm) && !vgic_is_v5(vcpu->kvm))
 		vgic_v4_commit(vcpu);
 }
=20
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index b6e3f5e3aba18..5a77318ddb87a 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -132,6 +132,28 @@ static inline bool irq_is_pending(struct vgic_irq *irq=
)
 		return irq->pending_latch || irq->line_level;
 }
=20
+/* Requires the irq_lock to be held by the caller. */
+static inline bool irq_is_enabled(struct vgic_irq *irq)
+{
+	if (irq->enabled)
+		return true;
+
+	/*
+	 * We always consider GICv5 interrupts as enabled as we can
+	 * always inject them. The state is handled by the hardware,
+	 * and the hardware will only signal the interrupt to the
+	 * guest once the guest enables it.
+	 */
+	if (irq->target_vcpu) {
+		u32 vgic_model =3D irq->target_vcpu->kvm->arch.vgic.vgic_model;
+
+		if (vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+			return true;
+	}
+
+	return false;
+}
+
 static inline bool vgic_irq_is_mapped_level(struct vgic_irq *irq)
 {
 	return irq->config =3D=3D VGIC_CONFIG_LEVEL && irq->hw;
@@ -306,7 +328,7 @@ static inline bool vgic_try_get_irq_ref(struct vgic_irq=
 *irq)
 	if (!irq)
 		return false;
=20
-	if (irq->intid < VGIC_MIN_LPI)
+	if (irq->target_vcpu && !irq_is_lpi(irq->target_vcpu->kvm, irq->intid))
 		return true;
=20
 	return refcount_inc_not_zero(&irq->refcount);
@@ -363,7 +385,10 @@ void vgic_debug_init(struct kvm *kvm);
 void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
+void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
 int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi);
+void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
+void vgic_v5_fold_irq_state(struct kvm_vcpu *vcpu);
 void vgic_v5_load(struct kvm_vcpu *vcpu);
 void vgic_v5_put(struct kvm_vcpu *vcpu);
 void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
@@ -432,15 +457,6 @@ void vgic_its_invalidate_all_caches(struct kvm *kvm);
 int vgic_its_inv_lpi(struct kvm *kvm, struct vgic_irq *irq);
 int vgic_its_invall(struct kvm_vcpu *vcpu);
=20
-bool system_supports_direct_sgis(void);
-bool vgic_supports_direct_msis(struct kvm *kvm);
-bool vgic_supports_direct_sgis(struct kvm *kvm);
-
-static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
-{
-	return vgic_supports_direct_msis(kvm) || vgic_supports_direct_sgis(kvm);
-}
-
 int vgic_v4_init(struct kvm *kvm);
 void vgic_v4_teardown(struct kvm *kvm);
 void vgic_v4_configure_vsgis(struct kvm *kvm);
@@ -485,6 +501,19 @@ static inline bool vgic_is_v5(struct kvm *kvm)
 	return kvm_vgic_global_state.type =3D=3D VGIC_V5 && !vgic_is_v3_compat(kv=
m);
 }
=20
+bool system_supports_direct_sgis(void);
+bool vgic_supports_direct_msis(struct kvm *kvm);
+bool vgic_supports_direct_sgis(struct kvm *kvm);
+
+static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
+{
+	/* GICv5 always supports direct IRQs */
+	if (vgic_is_v5(kvm))
+		return true;
+
+	return vgic_supports_direct_msis(kvm) || vgic_supports_direct_sgis(kvm);
+}
+
 int vgic_its_debug_init(struct kvm_device *dev);
 void vgic_its_debug_destroy(struct kvm_device *dev);
=20
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 20c908730fa00..5a46fe3c35b5c 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -32,6 +32,9 @@
 #define VGIC_MIN_LPI		8192
 #define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
=20
+/* GICv5 constants */
+#define VGIC_V5_NR_PRIVATE_IRQS	128
+
 #define irq_is_ppi_legacy(irq) ((irq) >=3D VGIC_NR_SGIS && (irq) < VGIC_NR=
_PRIVATE_IRQS)
 #define irq_is_spi_legacy(irq) ((irq) >=3D VGIC_NR_PRIVATE_IRQS && \
 					(irq) <=3D VGIC_MAX_SPI)
--=20
2.34.1

