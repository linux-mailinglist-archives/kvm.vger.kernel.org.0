Return-Path: <kvm+bounces-65845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DD320CB918F
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:24:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B801B3062BF2
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:23:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88DCE3168F6;
	Fri, 12 Dec 2025 15:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Dts6Umr3";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Dts6Umr3"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012004.outbound.protection.outlook.com [52.101.66.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312BF2F60A1
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.4
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553027; cv=fail; b=SM5/QWRZ2XlP0fJJaqVLLg33CFKbpxNTtyXZJkvY8+BARr6kuWwsils40p8cpcgKNGx/npEb/PILmL/EohE8J1e5GP9UT/r7bagoonAhDSsP+Zgf1S6TuZccbxWXocf66TAWsCPUQxJqIczpwgf4ndP3rUvfbGp0oLan3N9HYrw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553027; c=relaxed/simple;
	bh=rXMTz+8LAhYlXoPKYpHEc5iQmC8zGelXZS5eKVw3F3I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E94JsfGmWYB1KaYYxhnZ1UNn3IGhkKenMhhxE8tXLoz34F4peleShyZUJSrcgswcVf3by9s1hG7nYwI5wY4+2/8jpFkmPNgoa6qP+XkINwTJrQ3X/pXS29C7f5UBTbDX+Y6LKTfS20rQGQJ6jDIc5DK8GDbCZrSdpU6DSdQ2Pok=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Dts6Umr3; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Dts6Umr3; arc=fail smtp.client-ip=52.101.66.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=G3NV6lBdUjMQu5UjcME4hTOSuSaoVpE6dz4eGs/ppUd4CNWprEE2eByaefP4IcVlea7W6+ZZeGdt9nkOmx+kB68qYNIA0ArzkBmlXPzqexQBgkyqi2RAK+d6l2tjnZ9Xalf2mT8C2o2KXim9aGPCYgpQyXiJzGxS5Rj1zYbS0RuSK0NEk3pxRzor9318bBW1vHNdd2Bsip2zQOStACEPksmAT+vprL33G83TIlD7EdFQr8909WeekHqaAZk2tSrfCiuETOgMIdybn3XghspL42Wvyg8F/Pwod/cHFuDvuLbJD/kzeaCVFjOFLv9DZ2FGeCLn/bgFEtzdmVpLBnJcIg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iarA8BFrAw4Rl4cXvdNoeUzhKBBABxNAdUcLdriiCUs=;
 b=L5ArQscmzu9O0IqjPCg1GiVaU6TQAbA/lXodCuFCA5iWVi5Kz9QSfD1ngo9gxc596JeO3SWn6qL5NUpz5sJCJV/UR7udzD7GRFkumnVi6UevgXcyNXuBtNME+E0F34VVIW9WKlEa75JwgPfMQI7igcH5idi4OGrsGI6g10iU22Zl3qjfdonPingc+OdoWAG2Sr7xqw02sLpCbmjBKfEr9j5nmB6+cFA60YehHv9uzkw9MZ+C0Fm+al0TMch7mlz6NmAsMXfQH6mNghDkDJd8sMI+OBpeY1CnQ0YNk0jMN1M1A0XRREWtz8l4LKxMCamk/s+0qvg5F0ODnBN1X5zyqA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iarA8BFrAw4Rl4cXvdNoeUzhKBBABxNAdUcLdriiCUs=;
 b=Dts6Umr3c2kqjO85gyQNPDSJ4TDmzGMS+Llsr4qqIfGM900u0UVMKTOMNZHWqXtJJHaTDc13sZlqkdG4lsSQKFkjdYpCqiIoagSKfpV+DnqT840QPnlEHA/rCYJ8TmwIoCPyFvluMIc9hWoraWLge0YWWauadQpRiJ7EJL6uUGs=
Received: from DUZPR01CA0078.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46a::20) by AM8PR08MB6595.eurprd08.prod.outlook.com
 (2603:10a6:20b:365::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 15:23:40 +0000
Received: from DB1PEPF000509FF.eurprd03.prod.outlook.com
 (2603:10a6:10:46a:cafe::be) by DUZPR01CA0078.outlook.office365.com
 (2603:10a6:10:46a::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.11 via Frontend Transport; Fri,
 12 Dec 2025 15:23:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FF.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 12 Dec 2025 15:23:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bK4VwUYELP9DbnOL8pnAehQc7TamXJP44RdGl4pl0wteTofc6RfuEe+ia4k8RS2NAAO7oNzRDFkhgkHb/kc1O0fGRrcoi4O51kKq5QjNd+YMuJxGB6L0mZVsDia2vRszjg2eBGp7FyhgqEOEdcHnufhcHFrREESgKfI/qPTPNOWM7/ZACIfXLonURY9aeAkEQd1IBkMmVGyDHppmjZG2Sf2bRih/rnKI7XFHmdPsrFPaItg0txvBk8wkoukifybKa/nta/kV9KsvH4xaIBI+73FuvBJyzJB+SFl4HVt2RtsjbtCTJGCE1oz7Kfd8dFZrVMzr22a5HmgkNFmfWVkaWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iarA8BFrAw4Rl4cXvdNoeUzhKBBABxNAdUcLdriiCUs=;
 b=YeTOKzH56aTPo+mW7NgNprPh4s16l5TZ56IhDFZKBNM4YLetk2PmUZTES86gaI3u1WCYLVcuy5T2EZidMdzXM1Xl2l4Bdfqxv/5WknrrRk1fRq2uz91UKVdLj0/p/3YqQ+Fo6fMdUVRGHIXVAnGe1rmnCDLs/tk4unRwTrU+IyIfFXSYQTjbwQEouCBztW3kE14K7mRpJ9SQ1cepGSPGZuK1USfs+D9nPEqjDJUY8XKsnPADFUu2BRqTkGoPV0l0dlkqBYNFfyUXxGiAfE0OhrNRW8ZfqyZfEQxJF43sjf5RO6ohBLFp+LuOBerWfVTlnfHW8/BPFKSq2dpBkMzbhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iarA8BFrAw4Rl4cXvdNoeUzhKBBABxNAdUcLdriiCUs=;
 b=Dts6Umr3c2kqjO85gyQNPDSJ4TDmzGMS+Llsr4qqIfGM900u0UVMKTOMNZHWqXtJJHaTDc13sZlqkdG4lsSQKFkjdYpCqiIoagSKfpV+DnqT840QPnlEHA/rCYJ8TmwIoCPyFvluMIc9hWoraWLge0YWWauadQpRiJ7EJL6uUGs=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PA6PR08MB10565.eurprd08.prod.outlook.com (2603:10a6:102:3ca::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 15:22:37 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:37 +0000
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
Subject: [PATCH 06/32] KVM: arm64: gic-v5: Add ARM_VGIC_V5 device to KVM
 headers
Thread-Topic: [PATCH 06/32] KVM: arm64: gic-v5: Add ARM_VGIC_V5 device to KVM
 headers
Thread-Index: AQHca3sldzBrI9BiBU6DB9OYN3JR0w==
Date: Fri, 12 Dec 2025 15:22:37 +0000
Message-ID: <20251212152215.675767-7-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|PA6PR08MB10565:EE_|DB1PEPF000509FF:EE_|AM8PR08MB6595:EE_
X-MS-Office365-Filtering-Correlation-Id: 20c08daa-91d4-494c-ff4c-08de39926dc0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?KtrMB7yhksw3VKKTkPuERs5DCUzXLzRICKVhAISHpAXeDRGEO1pSPg+Ogf?=
 =?iso-8859-1?Q?v56nX2oVk5x8O+wWuHcV7r0Yso72ekIHyViqQKdhPCZYK+ua9QUAY/9yuV?=
 =?iso-8859-1?Q?+SDdYAvBLD7p90n6BlUQKmu8u5FQFpWMacNKsArqWHShX/GYWCZrD202sh?=
 =?iso-8859-1?Q?unVea4+didhI0imkv/rLcnfBteBOj2QJQBLd/5AcWSEgO2yeok2tytGBmj?=
 =?iso-8859-1?Q?a75WXnbodbiv+gRwJ0gGlYPc8R45MiHIp3Pwyca5nTXX/wKqx3Vl8DuUfr?=
 =?iso-8859-1?Q?nOpXcapdNRAVmIIwnl261JUR+GsuoC2d2fuaw0BrF7h2/BN9IrG+D/INfw?=
 =?iso-8859-1?Q?HcoCpm7d/n84qjVREQ0rZ4r1r6Ro9YWfVp+ACgH5ZVJoJ/Nj1BoNVp4WUs?=
 =?iso-8859-1?Q?i/4LRZMXjZgSJvLkmCth26GieYATOIY7NxSgcFhvJipxzDTD58hyvGEU6u?=
 =?iso-8859-1?Q?JNhyFu451h3eDla1+jFS+2T/dPN8xu6YG+aD3XpC5WgraSeDRsZ09Mh89o?=
 =?iso-8859-1?Q?LMgMJ8SfCyYuSxode6BeIjCctIm9+/ICrLQHGBx3ogpLuTmAbJdR0Cs++l?=
 =?iso-8859-1?Q?AZuLYqOC9Mm16BfwNWznd/Il1S8kpG3qORiloBwPDKtKL84NX0ybxXWOsP?=
 =?iso-8859-1?Q?w6mcWa4i8W60Yj+wTgZsIEpKyXaZGNJQWtoSYWrB0Vqj/qGbrsp1amLY2j?=
 =?iso-8859-1?Q?rwLcjA3dPOR4hEFa7BZkCc2hO4W67mZbCbSGjODyf9FHcPBJTuC7J6Hzzr?=
 =?iso-8859-1?Q?5Wpm07wD9nbON2nFbBIFZvv/zruhTJd73M/fGGIf1xJRQmMvy3++DhK9v2?=
 =?iso-8859-1?Q?N/VuWXAcxis9O8pTa6KzgtsUAUShi5wNvDMfHMR6hjJ+b9RvqIUzva74+D?=
 =?iso-8859-1?Q?b0tDX8MD8UEjtlgzqPZudVesus+7hbD2yo7AduWFHsEPIRJmj3mrfKT5lA?=
 =?iso-8859-1?Q?sAbsH4/aWHKeAAppg/wv3oP1SiceyaYVXmQTxhxVOvzVZdKpE0rKHhCQ2X?=
 =?iso-8859-1?Q?lmq3FntB+FgmAIf7SjrNyo4UA96uIwOepSGG/BKgq0H/C+/zQOzozmTc8d?=
 =?iso-8859-1?Q?2kuAlk1poCOZvlq7p4m1hgilOE8TDTA7okmePElEKsf+zm5fDZj8/Jtxgs?=
 =?iso-8859-1?Q?33q8JSKytOTkzTso6AS7oCcrDvz/GVlVwrVzS+KlYgbeGo3dVbhoop3+dU?=
 =?iso-8859-1?Q?tSExw+s1WYKSpB473oTK/h1KFjId0m2rGj15VPHJWbLZRTqmre3RCgLJET?=
 =?iso-8859-1?Q?omudnPunCK0rluj5E/kYV7WhIm1rsFhMym3qBfkIsrsVqaGsgPojuhXhSl?=
 =?iso-8859-1?Q?Tsx9jsRSdVpC+QjN2gZw9PEPmqZvvUncHuEqoJgV9VtwMkxSHSVxmplSrG?=
 =?iso-8859-1?Q?M/hcftu/DBfqc12HdkIJjp52a2o/IHnxXOj1SLGOteG4y3b5J0htWEg0BR?=
 =?iso-8859-1?Q?pX/K/Kn/wIHH3C7M1Yn0t9E9t+ZLtpDjduAnFziZv1WWOX5yMkZ5BLHEju?=
 =?iso-8859-1?Q?UWudQ5jSX1+ZTm2HkS1QAn58HZB42GiAtgM3iX1GU0agnarbh+xcodVmpg?=
 =?iso-8859-1?Q?yT112WlMrR19V7Az06lbHGzPGgv+?=
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
 DB1PEPF000509FF.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e1f6c272-0f4e-4567-63bb-08de39924863
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|14060799003|35042699022|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?sXALxpB84UHikeepMSlbjwoEpleyMVmQ89PUhlbNx0nRc2ijX6dFRK5sUB?=
 =?iso-8859-1?Q?KYkGaruDfBD5gjJ2ZujFkSRtcA7F0eQLHLq+U622alofX1mvBxcDQiy2kJ?=
 =?iso-8859-1?Q?mdRy+I7LjVuKF4Kq5Ts+YU45Bkt3D7VeLO36KyCx9VIl1IQe6g8LoODb0K?=
 =?iso-8859-1?Q?F/kseAdL59YFWt2t7Uu4rwUmbjfT0h/0fEjsF+4KWVW1jfbJaouoV3hg/4?=
 =?iso-8859-1?Q?xDDcrEY0KpCZTVpj0BwHdS5byjaLicf9jZ/3WFsYmzPyjuroeRlLqEkfAz?=
 =?iso-8859-1?Q?r0bjNbi5IdRyIr6OaM7AbdhL0qz5F2Bsfudb95PdEeJ75zwOWZX15/dfw0?=
 =?iso-8859-1?Q?Ozwqxf02r1YEYQABI6xBQwUkkQcClFa1ViL0h6YjWQIW5KRPIicmid+Pht?=
 =?iso-8859-1?Q?a3bx7tjyT4q5utMoq7KFNdhj+KkaL9eLufDIDIC7K8duFOoxE/TIKgPBo8?=
 =?iso-8859-1?Q?z+dhhbdacbF0dcS7iECC2rnpchnbP907qFB4HJ/2vOnyZ2uTYNWAoMdN6c?=
 =?iso-8859-1?Q?WjRtgW1vg/R2zBSpcLJexBD3276KD7bkNkJ0fvVAeZOJQ/QRxI8yBEsrj+?=
 =?iso-8859-1?Q?extfwbaSeksxwogTjWaOGHZ+IzESfOAHsC42/gZ5iOWyX4OHV0tT6W6FV9?=
 =?iso-8859-1?Q?U5ThiIUOPReX2BazSNC1QWkK7+AjUMzMZ1eZ9xIdLs1LVuCE7IoZrRLrXN?=
 =?iso-8859-1?Q?3CRDKFmK3P1vmOOjtGwTxY3KUqTy1nETra4E3/hPncY9zfx0lzZ46wRNwc?=
 =?iso-8859-1?Q?c40pQAR0zCkFOvh4Nkn9+F53IKK4+fQCuvLXEfAnYu2Jnz0f08aMtPaYnC?=
 =?iso-8859-1?Q?KRPbGcIfY/fj+/yACkDJnmleMx5JX9w6k89Z+ThmTEIa1RmBMRT9cyTxLw?=
 =?iso-8859-1?Q?2qdi6m6JtKe+QtxMzum2QqSfvzQJp4SK9zXbchjUh3MFgYPhR1V1c4xnCY?=
 =?iso-8859-1?Q?tFf47YGDJcAPgO9+hDzCWvavwMwi402DfyHVwD6ijkUa0eTfR0OGD48+IN?=
 =?iso-8859-1?Q?L1ewiL7uou0ep8aTzpqemwCIDYOJ7uwOwTkC1U63nPR6rfEH+ZXKUkKWAj?=
 =?iso-8859-1?Q?qN8JdBPLh+joRnxZ9oYFXETNfdgPkxWiSurH57565JisdRHR14PHZo4rGI?=
 =?iso-8859-1?Q?zu3LpPDBxHL9ELl4LhLlFBN97CvVjRSLerDD6tdWotZLFClg5c6OcJSuIh?=
 =?iso-8859-1?Q?9G6uS7VZv0UPb7CABwrKNM+QQyHED3QlffngPaeDBiAmxAs3GB3WCFPcm3?=
 =?iso-8859-1?Q?0QHnlurPJSjrbA1hcLk+UZmvFManixt+8kBgwGPyzt4NdoBYyt5VQpJJF3?=
 =?iso-8859-1?Q?Leuyz5LSB+ktNEzV2jdfhQjuSvR2WMEvj+Mi5+Hf+h3h0qdNknLB01F4Rd?=
 =?iso-8859-1?Q?N2iJVLVVmi29IU9JCDtvYswMV5jYXii5CMDAK97oUaEpAvYnUy59sETvN8?=
 =?iso-8859-1?Q?OeZvi5vKchonXNIB3mfarKgURHGX0vYRu90w0qH9tnUOZBP3evx6oak23X?=
 =?iso-8859-1?Q?DB83lTQYYty9DK2JElJKNDcxF4mHC9tq6v+Tc0rlMChU42glBzc5kDQe1E?=
 =?iso-8859-1?Q?aQK+iZ3yRoy0rCgIO/peZJXqLcbDSIHV0/ip+1YEQPtxCIhI1KuW4mKX5Y?=
 =?iso-8859-1?Q?96hruHhWOxd6Q=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(14060799003)(35042699022)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:40.1561
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20c08daa-91d4-494c-ff4c-08de39926dc0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FF.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6595

This is the base GICv5 device which is to be used with the
KVM_CREATE_DEVICE ioctl to create a GICv5-based vgic.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 include/uapi/linux/kvm.h       | 2 ++
 tools/include/uapi/linux/kvm.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index dddb781b0507d..f7dabbf17e1a7 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1209,6 +1209,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_LOONGARCH_EIOINTC	KVM_DEV_TYPE_LOONGARCH_EIOINTC
 	KVM_DEV_TYPE_LOONGARCH_PCHPIC,
 #define KVM_DEV_TYPE_LOONGARCH_PCHPIC	KVM_DEV_TYPE_LOONGARCH_PCHPIC
+	KVM_DEV_TYPE_ARM_VGIC_V5,
+#define KVM_DEV_TYPE_ARM_VGIC_V5	KVM_DEV_TYPE_ARM_VGIC_V5
=20
 	KVM_DEV_TYPE_MAX,
=20
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.=
h
index 52f6000ab0208..8303124973e2a 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1198,6 +1198,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_LOONGARCH_EIOINTC	KVM_DEV_TYPE_LOONGARCH_EIOINTC
 	KVM_DEV_TYPE_LOONGARCH_PCHPIC,
 #define KVM_DEV_TYPE_LOONGARCH_PCHPIC	KVM_DEV_TYPE_LOONGARCH_PCHPIC
+	KVM_DEV_TYPE_ARM_VGIC_V5,
+#define KVM_DEV_TYPE_ARM_VGIC_V5	KVM_DEV_TYPE_ARM_VGIC_V5
=20
 	KVM_DEV_TYPE_MAX,
=20
--=20
2.34.1

