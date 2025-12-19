Return-Path: <kvm+bounces-66370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 59935CD0B6B
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:04:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4843E30602D6
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1847364EA5;
	Fri, 19 Dec 2025 15:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bws//Dmk";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bws//Dmk"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011061.outbound.protection.outlook.com [52.101.65.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026913624D1
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.61
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159644; cv=fail; b=ffld9sYFvP5ZHYfFbQUtZpzuQU9aCRn3jNRGVY1vBURvohtu4pfGpjKBVpy7/vC5QOnkJZg/RDjDMVbhehRhp0IqrDHQszhQPWRGBr8T98GKIrCwGvgq6/xkNOxfv+omxAJKYD6zWghcvuEpflCxkXIiFwAfbcAHS2hhWMcH13c=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159644; c=relaxed/simple;
	bh=ac+8P8hhjw5f1W2QnxgoTFMqF/W/m0oGPN1VNkIHcQE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gEazqr0wxKr5PlQyjg5/ECBU8R7ucgXn69bRsLf7pR+gsrRTeX6hJiMTRPcAx5AYwseFJa/i/OTsFgDdX3GEd1Ittx311DP5TtvIAqDmHhklrqfJyC4xHv4YFBsJ/+gjFDmvR1113HxJSz+Prsn7CUKpZae5UBgl2xLqQJRlDbk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bws//Dmk; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bws//Dmk; arc=fail smtp.client-ip=52.101.65.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=xXW1v7ULigqKuBPOxvyBoLPAUqA80mh8ne7ZAkqRLL2Nf7UUYmYV5IPT7uovBCX8M+QvTOv3+C6wjtOkQRrK10zkq8Ewr7MuRTF6RyxV+zP/lkOVKnRcP/UUX34LcEk2keWVJkaJCMytZGbJyd1eayql7LXvMmhloi9RO0CCii2foe2FJVDSdw4/JZyXqUF7TL7umkTbCNPxZGEWu5i4bds7JEtv5HcjKg3eAbFVcd6xOzLdadDLGLsyOLy3/jEPuaU9lVXCW4c1+4abJf304IL1FBj2hfFE/ZykbNQwyMi5tGWwGqyCVQ420gGWogxpneUuuExG03g9acGYP5aHPA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2nVi6RptfTXPiD60USm+bP11TlWh2C6n4vwK0dZ6PB8=;
 b=U0/WGDK6F8vcGMbUGV+UQD27AfDmElTl0FT1rvEHYAJeWcGYuAG8EA1BcOszzRweOvmUGUYK0erfL68g3uSIwsAXzRbZfS/orE9yd4S6ud1iu8CNA3wMusSBlmRj/lEWvG2J0s6BoMRH3C8Ju1bFbgo0z4NWXwGIO+O9X9UmNn3lIJeRJCrW6sr64ogIB8CrpCLO6N1t82JwYykOnIfGIT+k5gANegmG6h7N/gxuzELsDcjC2DuLRREM96rkf9YDYDCARG57fge46dIsFkU1bWHNIUztLGQJLRLbGLXKefw5pSZGDMXv0Aver4BWzd1A3jiwIQxoXiB5sF7ayZ9V9w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2nVi6RptfTXPiD60USm+bP11TlWh2C6n4vwK0dZ6PB8=;
 b=bws//DmkoksjHF6ljhgiKzGOoeHNG4n/GVS+wqJNn3IODCBGOH4HGRjOKqFBd4370G/duk1LuXG7zaXtRj0r5YoMhmZIOOFlgMw910NEuzhZfQamJtS5d7nFh95cIlevt6RaA/5mpyo9GSZrSqkOjj9y4YWvH8dELKk2amIrU2k=
Received: from AS4P192CA0022.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:5e1::20)
 by DU0PR08MB8564.eurprd08.prod.outlook.com (2603:10a6:10:403::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Fri, 19 Dec
 2025 15:53:49 +0000
Received: from AMS0EPF000001B5.eurprd05.prod.outlook.com
 (2603:10a6:20b:5e1:cafe::c8) by AS4P192CA0022.outlook.office365.com
 (2603:10a6:20b:5e1::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.9 via Frontend Transport; Fri,
 19 Dec 2025 15:53:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001B5.mail.protection.outlook.com (10.167.16.169) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:53:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EjD0otmq6WelH5Yo5HRUvJNDUdYUqhJH8O2mfgdWUCNZgJIidxbf25lt0DzYoS38tezYTArOvpjGp5CrU3dhag7KcFZlGIpL7Jq8nKudzuFAh1U5rAQzGiil5ya0MVVBXw48K5uothb0o509OWuZNzSCS17Lb3Jrt4g3WSbBXdWLdsbJeZ7hCBeuRARFOYHkqaFkGMuM9np6HeOjbq44Ibk8+tXXS55Bx21myTkKt2jZwSC4o48+1btyvzHBzfBda4b/aKVUD5ssiT4+2kGpnUlxZhFOlmuLJo8+wxZfPLsPb2lVvCIf3wrruj8ZgpJyBdOhAvuCvqGYz/7+OkjQFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2nVi6RptfTXPiD60USm+bP11TlWh2C6n4vwK0dZ6PB8=;
 b=FGJXdPSY3YabiTVhhD+F9HkSJG5ZpDo6Maa5e4m83pteoo30S1o8cui7HXTgY818LmynukPUS5F6B8orOAlxlzPvsAaCmLmSekVxiwp2Hf6vrPrRbyEHVJj45YnpIG9S5U+Jx/GP8K4SgrXoo/+7JqjJ3snoRBfjZlaDxL8g2a09M1tQ79L51wQFNpaXshqpzC1VenMl6IBjMLChhIGgfdMp+wP6QpV5lz9u0vzCOYDpSQK6hKwR1b0ivmrKGMxPcLCsg3RABSctjpWG4hSNfbHVyFVzE55gKEsYdBJdLKlFaDYrZpABj3cEswzvRmmSXYB+mHqtcr8ig2p7Hh4Qog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2nVi6RptfTXPiD60USm+bP11TlWh2C6n4vwK0dZ6PB8=;
 b=bws//DmkoksjHF6ljhgiKzGOoeHNG4n/GVS+wqJNn3IODCBGOH4HGRjOKqFBd4370G/duk1LuXG7zaXtRj0r5YoMhmZIOOFlgMw910NEuzhZfQamJtS5d7nFh95cIlevt6RaA/5mpyo9GSZrSqkOjj9y4YWvH8dELKk2amIrU2k=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AM8PR08MB6515.eurprd08.prod.outlook.com (2603:10a6:20b:369::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:52:47 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:52:47 +0000
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
Subject: [PATCH v2 28/36] KVM: arm64: gic: Hide GICv5 for protected guests
Thread-Topic: [PATCH v2 28/36] KVM: arm64: gic: Hide GICv5 for protected
 guests
Thread-Index: AQHccP+EHnMyvLvMqkahpu7IMgywRw==
Date: Fri, 19 Dec 2025 15:52:45 +0000
Message-ID: <20251219155222.1383109-29-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|AM8PR08MB6515:EE_|AMS0EPF000001B5:EE_|DU0PR08MB8564:EE_
X-MS-Office365-Filtering-Correlation-Id: d0d0624a-a319-443d-b95b-08de3f16ccee
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?5Y0P+KAPPzPOreDPVY3sCbrC0/sCsxi2SPjEe10YG+fPQf+0eHm693q9Y+?=
 =?iso-8859-1?Q?hsZdZjUz1jcuMPVxJobJpwm5jO12Ovucfn9ONoOB/N4Vpj3M3mkDKyAkkX?=
 =?iso-8859-1?Q?UJ45YmJGV3GUJLV8gznGSbiTLpp7Y81Ft40YjsRjchj31katS2RICHybiw?=
 =?iso-8859-1?Q?vQ0aIARbd6m6IvuKx9ivSbyYPwvUkUCGfgEhXQvV7gZGZZCcm0JBXNAleg?=
 =?iso-8859-1?Q?E4/ub+RFF2SVzecfS3SQjCq34j0B8Hoz94QgcCcg9uLNMTqa7I/OM2yP6N?=
 =?iso-8859-1?Q?dw/AsW1GgsH/uJ/septn7FmO93iXitxCn5rZxNIsHyyhrd6QPlQrkdtNwj?=
 =?iso-8859-1?Q?fIvz+BoAfDEPC+XkmovqtoBzISsygeVk0cMOE75ojX3SLPM9ItY1EN5k5c?=
 =?iso-8859-1?Q?aWpY9kA/5am8oOxlmt4J5NY+fYWbOcsosYXruOdm/v0igYxzi6+iAhvY1F?=
 =?iso-8859-1?Q?jEj0cZjSEhcmEwUIYKxUDoXq8MPvcs9TfwMzqyPCQSSqgCtpkFbafqCrz2?=
 =?iso-8859-1?Q?Ae7VXmbqRvO2eeJDgstt51dhJouDQkIJL/jTbD22i5/b1wx07aYTrLGMc9?=
 =?iso-8859-1?Q?RrNZ8evYsnwqkSeVYTSJDMcJm5p/wMgTmnzbV3LlfQrYoc2niLg8PJ1y63?=
 =?iso-8859-1?Q?9qCIoMIcveSgy8qswFiZaLKX/kCYyeSEsRV/anxgx8mx4RTDHu/9jx3DpY?=
 =?iso-8859-1?Q?V+sJl0TRCrclm7GlD566pMuKUSsJTXOyqKKgZYGHBnhWA1RYeMPmLXbq5L?=
 =?iso-8859-1?Q?/fBm4rJHYjxCdGMaBy1uYC5Qm9cr2toD+7uwNjwFs0aAlrHQ6l54K5t5fi?=
 =?iso-8859-1?Q?R668neoIi+IJnEcJ+y/uw7hiuZ3+PU8a2cD44T5pyEPw5wtxlho9IjAxLb?=
 =?iso-8859-1?Q?uU4Gdzu9Z/uMCubNFSj9LI1WF8GQYCtWyj9m2XT+AkbIlo+7Lp+09Fa4Dw?=
 =?iso-8859-1?Q?gv6UZjNae1kuNtrDvuZGXJp9ccbbGULWzqmvKJQbSDFRrsdNULy4sMLDmw?=
 =?iso-8859-1?Q?aW15hETV6lnKf5CHhGtiHVeFBD2BRWZ8fP9BnA53kzGBosMNJFC3X0p0Vp?=
 =?iso-8859-1?Q?IGItAyleD41gavzyJPf66ayYOoPhpjxactoqSW8xenHDhPPFxyncNabOrN?=
 =?iso-8859-1?Q?NI8oMLSgkUhEfdGYSyzfj9tuPVPosooZpEWCE4gbplCuOGghVMYLuvLLgU?=
 =?iso-8859-1?Q?iIBaWCa8LYzQHmjdL4H51Ufo2BdHQYu1PO6RGOiCP8OjRbudMF+zU26Hhv?=
 =?iso-8859-1?Q?RDPmxQEZqJTXzxhjT1g6br9qNUOS8zn7Sn+e48RJsVKLobJvI1FEJt/bDW?=
 =?iso-8859-1?Q?ohyGjHEn5Qv9EKOaDNjOmVa5yFdGT1l3t09KvA7BBQ7A+uyXO7G7Fv+IBK?=
 =?iso-8859-1?Q?UW1rnF6w5vd26kb7V2WJkIpwRKbvfdU63OqOy+wpF0jLWsWgscGgMfHMrS?=
 =?iso-8859-1?Q?De7SL+QltiHBeE3wNkQyXZGG4zs3P/JWtH2a5X9jkt7FI55tHenxh3kZtR?=
 =?iso-8859-1?Q?KnqmPPpeBB24ACIf+hN2EYk1ieGMMQVYgbcaIXSYFDBMP03wLKh6zMBN5a?=
 =?iso-8859-1?Q?9uWlAMltOaT8CL7f6K9MRDtbVrmr?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6515
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001B5.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	bbef64f1-abae-4d75-4338-08de3f16a7c9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024|14060799003|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?rZ3aCtKGcK6H0q5Il2HTruVHEFf5lLxSIOHa+WHK1ZsL1mCTBpp3B5zWJD?=
 =?iso-8859-1?Q?3X3QR4EFVcUFTP4BhXGR6IkfSwaXLbt1RfkcPMEuf6hD9/JL363/lYR9qt?=
 =?iso-8859-1?Q?k79xEy4OhlQka+QxvSC8QAzmk/p5HI90RxwrnxYk2QfUYENscHlolb3RWQ?=
 =?iso-8859-1?Q?fGQfhq56H1jmMrUUS8JFCgLxsSUIZgK6mvQwXD4oQBeBs6Pl4jePD9m5KS?=
 =?iso-8859-1?Q?fw0hYXyiSoRU0HXQ+KGCdps1czfDhE50wyBPSULImOICIAncK8HorxyDm5?=
 =?iso-8859-1?Q?7AqjjjkMPzXZEmBg2M7PQJowFTG9qiCWh/KuWEmH9Mor4+2QKFKA1aAn3R?=
 =?iso-8859-1?Q?5/D+6LBlwD2M1SAUjgQdtgWCBzgjmbrX4ZZsS/IOS3wW07Nm4EZuNJJTrd?=
 =?iso-8859-1?Q?5zK6yZQ+bozF8HbTk4vdpPZ+2ZpA8vIiBM8Bo9mlvShSE50FhSi60ihyn/?=
 =?iso-8859-1?Q?KJ4TafV2Zdmkp4pTm6ZiB2FY167LibA9LPvDltTVF7xrESqHSecCDqj8oN?=
 =?iso-8859-1?Q?2B5EotgtwD2+iWAHG5ray21/TQYeMJTViGqrcA69psu4CJ2DtMgWSIlxi6?=
 =?iso-8859-1?Q?EGpJ/CGgWMK9UDhuyI78pzUN32+Cjroeg97tlRW6hmY6nWPqukI5UtxL6K?=
 =?iso-8859-1?Q?rpI4OZpiIL8S3OgBFZFPBEIVI7srXbKcW1e/FXd5ar+5Pn9pd1PG3pXFAd?=
 =?iso-8859-1?Q?9d0vVxyRm1u0Jw2esy3bGYAbARg6qHbwgE6MTm1421Uj6p8aHE2uajCBJ8?=
 =?iso-8859-1?Q?dWRqzLIciN4wlSjkG2BZJ49DZeOrNkTC8gS1TSu+UgCBtbtFzMB2PiuKQh?=
 =?iso-8859-1?Q?9fgiOnXz3Ws6rd4AxDvgYQME/7dPavM2btj+1W8/eZtTxGltUxAs0140xJ?=
 =?iso-8859-1?Q?KDcxYQBFwLaJsxb+B7UgGYKQxcROE1+rAU7T49c1YTcjh3G1aWOG8oauqC?=
 =?iso-8859-1?Q?GFkKYsrgde+E6ytevax3QGd70nc6hFcoRUvDxWdkVU7KEE6/XICaYp7W2h?=
 =?iso-8859-1?Q?S5u+CUBmpH68APnraQ3pulge5OTCxGi7mpS1J7vTZSWWOfOESibFLgdJSR?=
 =?iso-8859-1?Q?RkdazdJbectvRB0YEqAmM6i45Or5SNNcQwOnjK44ljAN/XZhW+/qvRViim?=
 =?iso-8859-1?Q?hKsLc7tGF/EHP/qqJ5XO9tF1ny+fdNLq7EeSvwLJ0jl1MOhIYDohNpbvTD?=
 =?iso-8859-1?Q?t5H073Q6qIK0yhdOnAIgFExYdPhuN1I5dqyfDO22qUD5NC1Ogase7RFOgs?=
 =?iso-8859-1?Q?9/FUZ6pd69QV7FnGbtBQSqqv6eDWA+Ei/jSnxTYgbMKS6do1MmGzKI2As+?=
 =?iso-8859-1?Q?b39m4WC/slenLAxZ//f6gd1U13NjIDbir0q3zqZf220/cE3HoVXv27zhZV?=
 =?iso-8859-1?Q?VjVe0wOf6uvGsVES4sD6ppQMlDhR14Jh3TBjl2sv9iyc8H/eqSJ6uGDdXz?=
 =?iso-8859-1?Q?lDJi4jwRXwKYY/FTgJJ5VUS09eY3BH5pDcFvODnm2feFE9Y+Hce2K3jvgC?=
 =?iso-8859-1?Q?afsFizb12IIIT8lhI5KDMlP0mvRk4Kueqv0UNj6ny4lObLh6NYefwdLK6z?=
 =?iso-8859-1?Q?Pok0yczvE460N0GhyWOknWSncnzIrPFQfItf3/hT8nUAd8PZiCGVkhj6q0?=
 =?iso-8859-1?Q?u8I3Km9IT0Dyc=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024)(14060799003)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:49.2367
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0d0624a-a319-443d-b95b-08de3f16ccee
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B5.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8564

We don't support running protected guest with GICv5 at the
moment. Therefore, be sure that we don't expose it to the guest at all
by actively hiding it when running a protected guest.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h   | 1 +
 arch/arm64/kvm/arm.c               | 1 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 8 ++++++++
 3 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index c965f4e178cee..7322ea3faded7 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -145,6 +145,7 @@ void __noreturn __host_enter(struct kvm_cpu_context *ho=
st_ctxt);
=20
 extern u64 kvm_nvhe_sym(id_aa64pfr0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64pfr1_el1_sys_val);
+extern u64 kvm_nvhe_sym(id_aa64pfr2_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar1_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar2_el1_sys_val);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4448e8a5fc076..1d3f2f713769f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2471,6 +2471,7 @@ static void kvm_hyp_init_symbols(void)
 {
 	kvm_nvhe_sym(id_aa64pfr0_el1_sys_val) =3D get_hyp_id_aa64pfr0_el1();
 	kvm_nvhe_sym(id_aa64pfr1_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_A=
A64PFR1_EL1);
+	kvm_nvhe_sym(id_aa64pfr2_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_A=
A64PFR2_EL1);
 	kvm_nvhe_sym(id_aa64isar0_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_=
AA64ISAR0_EL1);
 	kvm_nvhe_sym(id_aa64isar1_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_=
AA64ISAR1_EL1);
 	kvm_nvhe_sym(id_aa64isar2_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_=
AA64ISAR2_EL1);
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/s=
ys_regs.c
index 3108b5185c204..9652935a6ebdd 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -20,6 +20,7 @@
  */
 u64 id_aa64pfr0_el1_sys_val;
 u64 id_aa64pfr1_el1_sys_val;
+u64 id_aa64pfr2_el1_sys_val;
 u64 id_aa64isar0_el1_sys_val;
 u64 id_aa64isar1_el1_sys_val;
 u64 id_aa64isar2_el1_sys_val;
@@ -108,6 +109,11 @@ static const struct pvm_ftr_bits pvmid_aa64pfr1[] =3D =
{
 	FEAT_END
 };
=20
+static const struct pvm_ftr_bits pvmid_aa64pfr2[] =3D {
+	MAX_FEAT(ID_AA64PFR2_EL1, GCIE, NI),
+	FEAT_END
+};
+
 static const struct pvm_ftr_bits pvmid_aa64mmfr0[] =3D {
 	MAX_FEAT_ENUM(ID_AA64MMFR0_EL1, PARANGE, 40),
 	MAX_FEAT_ENUM(ID_AA64MMFR0_EL1, ASIDBITS, 16),
@@ -221,6 +227,8 @@ static u64 pvm_calc_id_reg(const struct kvm_vcpu *vcpu,=
 u32 id)
 		return get_restricted_features(vcpu, id_aa64pfr0_el1_sys_val, pvmid_aa64=
pfr0);
 	case SYS_ID_AA64PFR1_EL1:
 		return get_restricted_features(vcpu, id_aa64pfr1_el1_sys_val, pvmid_aa64=
pfr1);
+	case SYS_ID_AA64PFR2_EL1:
+		return get_restricted_features(vcpu, id_aa64pfr2_el1_sys_val, pvmid_aa64=
pfr2);
 	case SYS_ID_AA64ISAR0_EL1:
 		return id_aa64isar0_el1_sys_val;
 	case SYS_ID_AA64ISAR1_EL1:
--=20
2.34.1

