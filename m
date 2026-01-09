Return-Path: <kvm+bounces-67614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E233D0B85A
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:09:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9F0A6303E706
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:07:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13254368263;
	Fri,  9 Jan 2026 17:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aXNmZE4l";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aXNmZE4l"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012004.outbound.protection.outlook.com [52.101.66.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A614364E9E
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.4
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978361; cv=fail; b=j/cc2irLi+I7laqqVYBKnCpG2dAP2YLbOY2fgVpTL0AAyDrBS4d1WoPbf7NLTo48RMP+WfPtSzQJquvC2IHJCmzYdyOuVIzU9zKGneUjQHhFyMRKim93s2bfTYaoT56rHM4o8stmwbO1TUuhS2FobPLF8xi8ZIFPb5SkxoOPATw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978361; c=relaxed/simple;
	bh=hvFjRFDvm0A0nIx/wTo/jjiP1syu782iktRNzo37oUM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SCQ4kIR5VBUQvnBV7jPBHWN6x0fZan+1AjmjBuBVS7kVYJ6i7BhZSjy6TJUnvUPh8frmXckIn7aDhmUfptqZsJxeUMBVYBzV5JfZP++yOiQ94S/qLNqkrS2QmnL3z5JLqu9jID0/M++nbfIbCEAG3htvMvns3xK56bMm6INWigE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aXNmZE4l; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aXNmZE4l; arc=fail smtp.client-ip=52.101.66.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=vC91oHBI5gbx0+xCvgymUF0Oio941ySr7gKuZeTxuO49h2jhhC5YQLkSFhxjeZC10LbzvDPNJS7M3fTJKME0b2LUHNw7HPpteulipXCJOnayknGQkvzfnH5gEmywh9EAn2ibGZZQu2QeDQsAh9v6PK2ltwe8tU8qTHVVe1a8mXVi/lqGiCceU9fnIPXt2LM+vTV2lYI3ZFEa+b7WIHLQenNUnv4YoBBkfjGgI/Dn1N6ntg8v3i1rteMUZDvJiZwBLknCAC9TW+MXbt8fP+wvXHlsbI9CTzMZa8FPM0jGrOh9y5n6ChfbuEwXTTURiF189woOdPMKoCimNFyGgA+plg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D7tPy7hpiCQEWJX3ejj7ZUzfB1uUxNEdD3RIARp1mjQ=;
 b=i4z5wmpBcUTgxJ059+WlrmHULXbOzkweiMP3t1msrECIxR8TKi4IGropVGxrC1lSRUzILlZI71T12FES7NugyVmGLcNFKhZ7d0v7APFDzCD4d6yhcD+J4vMeeDAzr12CAnxdwnl+GP61C7WXH5wbH9DN+OLm9Q6kExW14wy1+Ve6zCPuHYibghg/3xD9xricrc+/3OmYy+tPfssR6HBUHvRlRxbVGk3R0c5KkIG/kDyi3DxOdsJfl9Xafja2YMrBWf4LJbGS52sVyqZg6ph+KEGyymk537kTxxsqXCi4bp5yx6H0cnXVkwQILl+q+PUeIxBuprqTTq3CKY+HWqBhzQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D7tPy7hpiCQEWJX3ejj7ZUzfB1uUxNEdD3RIARp1mjQ=;
 b=aXNmZE4laoaMXhlMnM1NqypiJN7bJGa28vtBnX9bFZXHZIRo3JMQGEpcroVHS2qcpKDyoGS/lKyinNk9NF9rsycU4vLd5uN7y6j9YbVH4V3qgbB1bkA7fzkRDW4oVrWnx1nViT3/otepqxn5QpESesJIKiIWXLsAj7KXPMt+Gdo=
Received: from DB8PR06CA0061.eurprd06.prod.outlook.com (2603:10a6:10:120::35)
 by AS4PR08MB7879.eurprd08.prod.outlook.com (2603:10a6:20b:51e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 17:05:52 +0000
Received: from DB5PEPF00014B8D.eurprd02.prod.outlook.com
 (2603:10a6:10:120:cafe::e) by DB8PR06CA0061.outlook.office365.com
 (2603:10a6:10:120::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.4 via Frontend Transport; Fri, 9
 Jan 2026 17:05:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B8D.mail.protection.outlook.com (10.167.8.201) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:05:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aLTSHnnTk4LopOwKVQdHWokoAxk6pCEYFOnFXD2+PRbw/xjr0iuFyMpwO3xoTlIix02iLfk/hQFVoG8TeYVpLDQg3oVLUXxeUiddoHu2dlnS9gi3Es+7RoER8rx8HfY482yr+CibECgFsBTiREcwbY0ch2noAUuO8Za2FrVuPKVBgOZzfc1XtiWTTM+SlW6o2isc8mMtMwjB8Q5mjWS9bpbWMRS7gDA4QUiyKTjrwCvhkPTINkqvv+5G70LdtncNwjs/fA5AEYQyy63sHV/Zz23yqyAkbNe1AqY8yRJKmt1+ffK1BgaHogRHmDbSAuZ0EKbmvn18r5PIUD5hIpggNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D7tPy7hpiCQEWJX3ejj7ZUzfB1uUxNEdD3RIARp1mjQ=;
 b=JbOO+HVoMhxz6fC/EEdIiUsFAw+0ZxalepwQYPErvgUe0qtbrI2J9s4w5HV2dMIFKU0Eo/+qh2hz0AxvpV2lxFuIpJJN+rjIzDLyxji4t/5bsv8s6vYC0tyYi9ym2fkiNCuEn7EeXIhYtlKwpwmUvOgamRFgYncmlqqdRMVOK15Dfom64ea9fuYn386tbUwFrdU/kS2OpPb3OedWQEgvq1OJ3L+Wi48niAYFjn64GHyhwr21x+DTe7JtZYniyEeqqnsX0FYXeD5RWA+ZWPUVZoDjquu35HxSLwlrfN+hpIpQ2hO2dj+VVpbef1OKfXT3aBiR66oY6MwiK85dqBoKnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D7tPy7hpiCQEWJX3ejj7ZUzfB1uUxNEdD3RIARp1mjQ=;
 b=aXNmZE4laoaMXhlMnM1NqypiJN7bJGa28vtBnX9bFZXHZIRo3JMQGEpcroVHS2qcpKDyoGS/lKyinNk9NF9rsycU4vLd5uN7y6j9YbVH4V3qgbB1bkA7fzkRDW4oVrWnx1nViT3/otepqxn5QpESesJIKiIWXLsAj7KXPMt+Gdo=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by PA4PR08MB7386.eurprd08.prod.outlook.com (2603:10a6:102:2a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 17:04:48 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:48 +0000
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
Subject: [PATCH v3 24/36] KVM: arm64: gic-v5: Create, init vgic_v5
Thread-Topic: [PATCH v3 24/36] KVM: arm64: gic-v5: Create, init vgic_v5
Thread-Index: AQHcgYoOoswDtfJzk0+DfdGHbK3CBw==
Date: Fri, 9 Jan 2026 17:04:47 +0000
Message-ID: <20260109170400.1585048-25-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|PA4PR08MB7386:EE_|DB5PEPF00014B8D:EE_|AS4PR08MB7879:EE_
X-MS-Office365-Filtering-Correlation-Id: 1712103e-cc93-4f4b-a93f-08de4fa15815
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?0/T+5WvSxnW7p9U3cHJcaWD6v46T65nxCNvWLvs3iFSVIMeTnj26f8tDLg?=
 =?iso-8859-1?Q?RLlz5n/JsO08y6mgTOwnVv6OFHaMQ5L05Y6mlWeTp8UJZdkR/8kbGGLkwu?=
 =?iso-8859-1?Q?XIyu1IY5i/djkyjpcqUtMTqihIHuZOTi+Dx2TAHQxKzBM8YTbuwf5u31sI?=
 =?iso-8859-1?Q?vsHzbPhDf5mBMX2woQnjjDEf4nLCDs7BVeSkqYR37GgukqjPaa9QqyddIz?=
 =?iso-8859-1?Q?TSs3GSAqsTQl2ltTusZP+j9uxDxb66CcY9LucsBWcNao09XRkMjjYVJoIG?=
 =?iso-8859-1?Q?ynwqU9H+TAbtblCamkS6NbOcyTQogcL4WnUYCVfqZvOV2A+YqweQW0jmqF?=
 =?iso-8859-1?Q?P5pQOcwuxEhKBVDw03hWeFNs+ZkiqQO4Z6K4sQkMZOLBZkbRvaDkgm1t6H?=
 =?iso-8859-1?Q?UAgtuq+jAjuNyB3gZ/Js9FJLwjL6SuK7ebhrywTCe5CCiy1bDCRZB8yI2y?=
 =?iso-8859-1?Q?O3bTKwRNX0xJ/sJNd+TESYsSDuEsqlgI1dLaePQOFUCPBz1t4cIMmHNUBi?=
 =?iso-8859-1?Q?SDux0OwsBsIDxv83W5t79g8omR4xTbevdZA6ZcS+qbxMkY7NsbSDhpDjEO?=
 =?iso-8859-1?Q?F4nxPXAFLkknAbqVya04Ab9OTaq38ttrTIbQmqGrOrqse1ZUF0zzd0I23e?=
 =?iso-8859-1?Q?c1xegahOmSdl89m2XgP6ry2V107MepslWd0GKrf8sAA26mE5SGJ/+j7HSh?=
 =?iso-8859-1?Q?DSnjj6v9T9MAyPDvCE8KGuwCtCWx7bwybUmCkU4jUfWiB3GKF//9mgGB1S?=
 =?iso-8859-1?Q?NTUcT3HpXIOEi6GmqzbQBo2dUYzTZwd6Lh8qh8s4wxNQ5MzVO6+JsedpGo?=
 =?iso-8859-1?Q?gPRtSEw//5ypAGxbiCC3aH3hT9BW2jwuuAuWhmyUJlwRQ+B7CdaK8m7RQQ?=
 =?iso-8859-1?Q?cxLEYw0JzKRb3bK1/Vh4sJQW3JW89Rb0aU6nbIZ04I9nbkg7pn+XriDjRT?=
 =?iso-8859-1?Q?LQohQbZV76hbhaQfgHCH4nK/3Anl+u9zUkFySaj/LmZnRiJe/D7FePY7VL?=
 =?iso-8859-1?Q?nH8jk/N0tVo94oqUk37NjHOsYD6NvhsKeS/vhNR9lMZQ1XinJKWojXJ4y/?=
 =?iso-8859-1?Q?gurmgaqFe4phEEF7WlZfp4/qq2sPCKp2K5U3vdzRw0WrFFmAWOhEw4DzHY?=
 =?iso-8859-1?Q?6C2KYqbeOk+h7NeYnnQxxbJoWCcdeL6lRzQz8nJBao/6bmVJZs+ZRIrmQx?=
 =?iso-8859-1?Q?0ahLB2PMDZpHgBScrCUOrh7Pcy0uVqnvVEYmJmv7/feolydm+wpvS+/V1g?=
 =?iso-8859-1?Q?ds943wnBCzADcUa2fp9oDnwaZORbXdrFx2RtGqqpbdYGu/z0iE05qFT4Dn?=
 =?iso-8859-1?Q?TcB8GDJcoLrruu6DK+kbaFKKrWpdxJnykLUVUOlJAX6BFAiEnhp+7pCiTj?=
 =?iso-8859-1?Q?sh6PQoenpaX3WkcyTX868prLXUd5/tcDIb5A+hHxpiErsEKbYCyuDcqR5V?=
 =?iso-8859-1?Q?nUCHFe+xCwjF5bYGDdgUK3IDwB2/oyhExWh3So1wRkr2rJLokzhFpZhLhg?=
 =?iso-8859-1?Q?bmqz+5g7IMY6FSfxJz5j52QGi9U4vu4trYsrTM6pwsOqEIHDnhtV8su1Ix?=
 =?iso-8859-1?Q?+4gLEO9xqvR4yhZgH8hntvXiu440?=
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
 DB5PEPF00014B8D.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3cd82e6e-066e-4f76-c7ee-08de4fa13233
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?tV9IeQKUH6oFHDuN2H8kgphEcXwd4UD6tCD32Agg6blaIKnROQ37NHWBiE?=
 =?iso-8859-1?Q?bk3tnZbjbij4K6e9EQr8eYdeRy6Ce+AyVkC8KLTU7XD0e/RI3GX9NZ11p5?=
 =?iso-8859-1?Q?sLDLgCDYxvF5Mdet/AChdV0hrssstYiRoktW6oue7m7X4CZtHpBlyfNZiE?=
 =?iso-8859-1?Q?KbNP7g4VmSClQ4PKPOH0r8fZVq16B+AO9/EBtlH3s/TVcar8wweiFmjuSV?=
 =?iso-8859-1?Q?LTBFugdIrCTVRKnMu4sr9sEhfpCpjmw3HfSTvHDC/Iy7vkbUUqBwg/4EMF?=
 =?iso-8859-1?Q?2vkJxKeGBx0hGcKeDmdkiunRSbGnJtxLKupz95NOSRhlmoD2Oc3W7wn/7P?=
 =?iso-8859-1?Q?Hb6e0jCesUfsgLOCGlmhdHcKYJhYAz63B2iRr/2gyhJiob+gNQYwWTirGi?=
 =?iso-8859-1?Q?jsmY7B9HCki6ptF9+UumOY1cea0j8Yhxv4P6eYXP2KVRFLf71yFWJVE4YE?=
 =?iso-8859-1?Q?M1aNNRLBJoAnC96W/Xh6QhYhHTwR6J/dGG9ZA8OBTchKVm2b4ohmx2MZO5?=
 =?iso-8859-1?Q?tql3NE7SIXUpeEVZWJqswECOrnBvipeYrqoxZdEWBGqwGlqIJxAJXJiRsQ?=
 =?iso-8859-1?Q?3fOUYckeEDZv2D8xnydHxDO9Kok1UlWzwR3jxnn6c2CqbfHz8DWxStD4f/?=
 =?iso-8859-1?Q?kvpnmUUdml2shWIUq7jstM7ncUjnViHTpOg6JqNefAG4gYi6b+9YY1mw4l?=
 =?iso-8859-1?Q?QRaZ+azAsyCJFmTCqpiHo/ni7u6KKHlu8KiTcyt64xTk2fIdymnsMTM3B8?=
 =?iso-8859-1?Q?oMXLqVJTPPiOTagYFM5zYhBT6GFYvlGfrk3vPgCmxo2KhpcYmspTLDhzU/?=
 =?iso-8859-1?Q?jJxO4uWRAzwVJs5cQZwe2a5pQBlWx7RiUkFjJmtUbEawnN1n2t4NqEu6jf?=
 =?iso-8859-1?Q?aXPOaue1ha8tOxCaMJ9vEL+j46Y6E4wiCRX4qetHQi8b+k8rtWo8EtlsNw?=
 =?iso-8859-1?Q?n1bIizVXA+ekLvs7QV1tJerIKeqqtr0BhIG10PIDeSo3aqdPn1FaqsYe1F?=
 =?iso-8859-1?Q?lHKfbc2SgB6IBmw4ESPmAcBHxdDuDESFeiAWMd3jFbY7Gc7TSoi92Kl4ws?=
 =?iso-8859-1?Q?S5HUClsmWMEUW6yOUj+PG8f7IsZHLBQkhThmDDus4duK7I6uYo74p1yeQS?=
 =?iso-8859-1?Q?84gLcLwVQeY1IdyJBUCyHPIvH57iue+g3xTEQ4x4M0jqzMRF0Z3c2k53ut?=
 =?iso-8859-1?Q?SyuOprVX0uUx5JVjzlgOC+QfoR5KoAIS/yXbCng11YsfDC4Hn9QInZOuuC?=
 =?iso-8859-1?Q?6upZXW9WmQGYHIlwyWyJ/H64a/sKe5+nBWe6B/IX8R7Nq5AcG/rnPHd2AQ?=
 =?iso-8859-1?Q?+abhLrHj3jj9YxN6xgMQryQuITfqk6MCASqiiP4HbAQyk+oTkqYc1FrfYc?=
 =?iso-8859-1?Q?8CaQrf4GEy7DuO7FRe/pWrhBVH6T3/FlH9ZGRWwxdBURygYmu0hSFsfCwJ?=
 =?iso-8859-1?Q?73CAD5wzqWYpsupfKgvkza9cNvYUa0kjDBYMcs6oVZg0pKlqaN4w8Cr+ce?=
 =?iso-8859-1?Q?oa+ZcxnvYD6YIgxeV4Xp+2DCkk5SnxX/HYfxLAYK+15S/KFcrSVb+Oq/Ir?=
 =?iso-8859-1?Q?ob9y63n3wwnrwdLf78SFMgyXXxguTQKZkZbGyHdVXqxJdTC2vOHd6mhtKv?=
 =?iso-8859-1?Q?LPHFl8joQEsnQ=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:51.8188
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1712103e-cc93-4f4b-a93f-08de4fa15815
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B8D.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7879

Update kvm_vgic_create to create a vgic_v5 device. When creating a
vgic, FEAT_GCIE in the ID_AA64PFR2 is only exposed to vgic_v5-based
guests, and is hidden otherwise. GIC in ~ID_AA64PFR0_EL1 is never
exposed for a vgic_v5 guest.

When initialising a vgic_v5, skip kvm_vgic_dist_init as GICv5 doesn't
support one. The current vgic_v5 implementation only supports PPIs, so
no SPIs are initialised either.

The current vgic_v5 support doesn't extend to nested guests. Therefore,
the init of vgic_v5 for a nested guest is failed in vgic_v5_init.

As the current vgic_v5 doesn't require any resources to be mapped,
vgic_v5_map_resources is simply used to check that the vgic has indeed
been initialised. Again, this will change as more GICv5 support is
merged in.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 60 +++++++++++++++++++++------------
 arch/arm64/kvm/vgic/vgic-v5.c   | 26 ++++++++++++++
 arch/arm64/kvm/vgic/vgic.h      |  2 ++
 include/kvm/arm_vgic.h          |  1 +
 4 files changed, 68 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 973bbbe56062c..bde5544b58b09 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -66,12 +66,12 @@ static int vgic_allocate_private_irqs_locked(struct kvm=
_vcpu *vcpu, u32 type);
  * or through the generic KVM_CREATE_DEVICE API ioctl.
  * irqchip_in_kernel() tells you if this function succeeded or not.
  * @kvm: kvm struct pointer
- * @type: KVM_DEV_TYPE_ARM_VGIC_V[23]
+ * @type: KVM_DEV_TYPE_ARM_VGIC_V[235]
  */
 int kvm_vgic_create(struct kvm *kvm, u32 type)
 {
 	struct kvm_vcpu *vcpu;
-	u64 aa64pfr0, pfr1;
+	u64 aa64pfr0, aa64pfr2, pfr1;
 	unsigned long i;
 	int ret;
=20
@@ -132,8 +132,11 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
=20
 	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2)
 		kvm->max_vcpus =3D VGIC_V2_MAX_CPUS;
-	else
+	else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3)
 		kvm->max_vcpus =3D VGIC_V3_MAX_CPUS;
+	else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+		kvm->max_vcpus =3D min(VGIC_V5_MAX_CPUS,
+				     kvm_vgic_global_state.max_gic_vcpus);
=20
 	if (atomic_read(&kvm->online_vcpus) > kvm->max_vcpus) {
 		ret =3D -E2BIG;
@@ -163,17 +166,21 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	kvm->arch.vgic.vgic_dist_base =3D VGIC_ADDR_UNDEF;
=20
 	aa64pfr0 =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_=
EL1_GIC;
+	aa64pfr2 =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR2_EL1) & ~ID_AA64PFR2_=
EL1_GCIE;
 	pfr1 =3D kvm_read_vm_id_reg(kvm, SYS_ID_PFR1_EL1) & ~ID_PFR1_EL1_GIC;
=20
 	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
 		kvm->arch.vgic.vgic_cpu_base =3D VGIC_ADDR_UNDEF;
-	} else {
+	} else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3) {
 		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
 		aa64pfr0 |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, GIC, IMP);
 		pfr1 |=3D SYS_FIELD_PREP_ENUM(ID_PFR1_EL1, GIC, GICv3);
+	} else {
+		aa64pfr2 |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR2_EL1, GCIE, IMP);
 	}
=20
 	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1, aa64pfr0);
+	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR2_EL1, aa64pfr2);
 	kvm_set_vm_id_reg(kvm, SYS_ID_PFR1_EL1, pfr1);
=20
 	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3)
@@ -418,22 +425,28 @@ int vgic_init(struct kvm *kvm)
 	if (kvm->created_vcpus !=3D atomic_read(&kvm->online_vcpus))
 		return -EBUSY;
=20
-	/* freeze the number of spis */
-	if (!dist->nr_spis)
-		dist->nr_spis =3D VGIC_NR_IRQS_LEGACY - VGIC_NR_PRIVATE_IRQS;
+	if (!vgic_is_v5(kvm)) {
+		/* freeze the number of spis */
+		if (!dist->nr_spis)
+			dist->nr_spis =3D VGIC_NR_IRQS_LEGACY - VGIC_NR_PRIVATE_IRQS;
=20
-	ret =3D kvm_vgic_dist_init(kvm, dist->nr_spis);
-	if (ret)
-		goto out;
+		ret =3D kvm_vgic_dist_init(kvm, dist->nr_spis);
+		if (ret)
+			return ret;
=20
-	/*
-	 * Ensure vPEs are allocated if direct IRQ injection (e.g. vSGIs,
-	 * vLPIs) is supported.
-	 */
-	if (vgic_supports_direct_irqs(kvm)) {
-		ret =3D vgic_v4_init(kvm);
+		/*
+		 * Ensure vPEs are allocated if direct IRQ injection (e.g. vSGIs,
+		 * vLPIs) is supported.
+		 */
+		if (vgic_supports_direct_irqs(kvm)) {
+			ret =3D vgic_v4_init(kvm);
+			if (ret)
+				return ret;
+		}
+	} else {
+		ret =3D vgic_v5_init(kvm);
 		if (ret)
-			goto out;
+			return ret;
 	}
=20
 	kvm_for_each_vcpu(idx, vcpu, kvm)
@@ -441,11 +454,11 @@ int vgic_init(struct kvm *kvm)
=20
 	ret =3D kvm_vgic_setup_default_irq_routing(kvm);
 	if (ret)
-		goto out;
+		return ret;
=20
 	vgic_debug_init(kvm);
 	dist->initialized =3D true;
-out:
+
 	return ret;
 }
=20
@@ -590,6 +603,7 @@ int vgic_lazy_init(struct kvm *kvm)
 int kvm_vgic_map_resources(struct kvm *kvm)
 {
 	struct vgic_dist *dist =3D &kvm->arch.vgic;
+	bool needs_dist =3D true;
 	enum vgic_type type;
 	gpa_t dist_base;
 	int ret =3D 0;
@@ -608,12 +622,16 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
 		ret =3D vgic_v2_map_resources(kvm);
 		type =3D VGIC_V2;
-	} else {
+	} else if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3) {
 		ret =3D vgic_v3_map_resources(kvm);
 		type =3D VGIC_V3;
+	} else {
+		ret =3D vgic_v5_map_resources(kvm);
+		type =3D VGIC_V5;
+		needs_dist =3D false;
 	}
=20
-	if (ret)
+	if (ret || !needs_dist)
 		goto out;
=20
 	dist_base =3D dist->vgic_dist_base;
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 3e2a01e3008c4..f6b0879dd705a 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -56,6 +56,32 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+int vgic_v5_init(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	unsigned long idx;
+
+	if (vgic_initialized(kvm))
+		return 0;
+
+	kvm_for_each_vcpu(idx, vcpu, kvm) {
+		if (vcpu_has_nv(vcpu)) {
+			kvm_err("Nested GICv5 VMs are currently unsupported\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+int vgic_v5_map_resources(struct kvm *kvm)
+{
+	if (!vgic_initialized(kvm))
+		return -EBUSY;
+
+	return 0;
+}
+
 int vgic_v5_finalize_ppi_state(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 2c067b571d563..c7d7546415cb0 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -364,6 +364,8 @@ void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_get_implemented_ppis(void);
+int vgic_v5_init(struct kvm *kvm);
+int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
 int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi);
 bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4d6791c1ae55e..96cc222204960 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -21,6 +21,7 @@
 #include <linux/irqchip/arm-gic-v4.h>
 #include <linux/irqchip/arm-gic-v5.h>
=20
+#define VGIC_V5_MAX_CPUS	512
 #define VGIC_V3_MAX_CPUS	512
 #define VGIC_V2_MAX_CPUS	8
 #define VGIC_NR_IRQS_LEGACY     256
--=20
2.34.1

