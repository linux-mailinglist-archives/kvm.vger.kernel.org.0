Return-Path: <kvm+bounces-66394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 70312CD117F
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 18:16:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4F3313040AED
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:16:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B94C382D4B;
	Fri, 19 Dec 2025 16:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EVrHRhHU";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EVrHRhHU"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011002.outbound.protection.outlook.com [52.101.65.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE36F37D130
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 16:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.2
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766160853; cv=fail; b=K3Tg1xiz3AW+PgY5yRyPCUXpg/OZAzrwXo9Rwku+8tnSaG4G4ajj7j5s4DNCJaN70lmXgPW22cyFpAJae8we1k25UC/qN8sHRhjg3C8EFZh9kAZ75PBy7cFz6wFsCm5zSCgGya/SKVrrNKl1qV8OqhzkPTIkaERX92Mx7NYZWOE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766160853; c=relaxed/simple;
	bh=BoUDEBIM1671onRia5qudxRSi4Fp1Vnb1zAwwCPNwvM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ByFPBidLBv/xMKBbJeJVAyrGfxGxTuav7hN9D6rvPQ3q0ZccZ74PT1KVmcrsWzCQltavyxqTl0No03f+Zbi6CY1Z1bOaw98OOEuoEgUF9DB9yGXOMIRGx7s+PDXIRnUnJU93hqoBl2JjC6J33zXsj/PL5RDLNfS6hY8rqWmmaGc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EVrHRhHU; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EVrHRhHU; arc=fail smtp.client-ip=52.101.65.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=t3etWc4s+IzufXMKMXHCQ8wUj7Dx4MDM/F11ZsF9VeTNOocZuhWGTZVFov3pG4vQosuuWEH7oQxyfIyfplu7EqnuL+KR8XO3aHWSVhkJdGrZd9pKGJ8hWJ3LgL49iQ2nq9YAJJXRaRBtSdVmApN8aW2mW15nWo3sYeJVZZI2h8AMOTjhbzqe4jOkT/gVcsl8iV0uHWbr5d9BavJKDXzXGI3ZbdKZTefiNh4PYPCjVZnfJ7oyMmmAUd1Z7j2fXfcO1g/v+Bp24CpgoVGVQT/vvun9tvA/HelUSiJgBYUv6BiyyokpMW3hz/bbzuIXOZHjWOjoy2zrmKeIB5v9K1LdWQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BCzE45xsPoxr84K3GbfS52HzaErypsiK1c0cCRcbA28=;
 b=e1SP4HIFKYJLELMPPVj4XD0SZqLFyyLE0QDzghxbjOG50oBZ1oIx7fwe0tt+SXiZr2oq73sNRhW9VgbrJQEF6gFlwyseahkZObzwugOqt0+m5M2ADl1agZC6DkrgVBe1N973GG1vi9h/UV8H+N1Gpna/vpOdVhWbEiHcAY13Bdm34aGJxhfKlvlfTNP+rjPk9ONCZNbShOt+o09EG7D5ly2R3/Yuof6XJP1kac4tB9w1KXs2nWWf3EFJWQvVoviMI9dDXyn/QdmjZPqzdTdI3ybdGVkHWu21ogeOPg0iDUy39PTQzNjIc7zGtGtG10KgZHYNbnMnpuIMeiEGOlDisA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCzE45xsPoxr84K3GbfS52HzaErypsiK1c0cCRcbA28=;
 b=EVrHRhHUd/x2CKabWZdqctOaCxElAZdyBmh8I7oZd7gzbjzhxAqVoDH+OdhoqzYVpjXtA4T6hFAT30UvKtBQsnF9FoAscvFlUr93V9TwPvTwymDB5uQSRZNrQUKHumLZ1oG8cgnRomG6vOuJAOJPxwi9DU3nU/hT764+/+8vi/A=
Received: from DU2PR04CA0347.eurprd04.prod.outlook.com (2603:10a6:10:2b4::27)
 by GV1PR08MB8572.eurprd08.prod.outlook.com (2603:10a6:150:84::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 16:14:03 +0000
Received: from DB3PEPF0000885D.eurprd02.prod.outlook.com
 (2603:10a6:10:2b4:cafe::e8) by DU2PR04CA0347.outlook.office365.com
 (2603:10a6:10:2b4::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.8 via Frontend Transport; Fri,
 19 Dec 2025 16:13:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885D.mail.protection.outlook.com (10.167.242.8) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 16:14:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N3gwuM5FjkW6XnDUGs/LWCR/kEGrxwDFhwwym8imJ/2FlggW4SgIkGKmHcTx/p5R+A2EPak9/c5l63jf0v1otpMj4eZjPQo15puPUI7A71R0jhMdlnUyjrXoayoZzJf6XhTh57lYNKQPK7bFwn8a6A85VAPSQ4QSBPq6H2FAKQyIwkYOVy/AmBfvRJIyxJQ6TuWY++EITp5uD4UG/S4cWrXDCpvLBAjKQdYT7S4KQRndAvh4f4ryFsEMfwcoemsBkMPVge01UYh2dNqXrQIH0bFkqiPsHC5wu1ze6Bk9GlRseAZin/hHFyhUIm1tiSh2DiA5Ox7gI2nOcNVlRa7dYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BCzE45xsPoxr84K3GbfS52HzaErypsiK1c0cCRcbA28=;
 b=DhfUYTRalaZ7GtqxU6ACnQeCgj4Kx7CmzDkoLn0YO1FItsZMQ0EfMtI1wiVG9Mg0Mn9Vfu1+iPLC8U4saq/2jBHLHUkICZH57b+pWYYpTtaDits6Z7bXJFrUFBmkO2LdM+z4ncPfN84+dvOH2EkjtIOBOYcICOMmWxuKcJeiXFOVpC4APb8fdLzNr9HCgODwGIiXA6gKnQt+E1b121nsXNLjoV4BC/t46cS1vvUDw3lJ1LIsaTYd8WjE09atZUHNowyLEcArmIjndwBOEE6tLmEKQbRcoZCvLHBtU9072gVsOxbVolxgW6JRMLd3JRIOO855fJhNHXT1ygdp2GARcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCzE45xsPoxr84K3GbfS52HzaErypsiK1c0cCRcbA28=;
 b=EVrHRhHUd/x2CKabWZdqctOaCxElAZdyBmh8I7oZd7gzbjzhxAqVoDH+OdhoqzYVpjXtA4T6hFAT30UvKtBQsnF9FoAscvFlUr93V9TwPvTwymDB5uQSRZNrQUKHumLZ1oG8cgnRomG6vOuJAOJPxwi9DU3nU/hT764+/+8vi/A=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by DU0PR08MB9582.eurprd08.prod.outlook.com (2603:10a6:10:44a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 16:13:01 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 16:13:01 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH 14/17] arm64: Bump PCI FDT code for GICv5
Thread-Topic: [PATCH 14/17] arm64: Bump PCI FDT code for GICv5
Thread-Index: AQHccQJXxj2s5uUCPkyoyZFBDWs9/w==
Date: Fri, 19 Dec 2025 16:12:58 +0000
Message-ID: <20251219161240.1385034-15-sascha.bischoff@arm.com>
References: <20251219161240.1385034-1-sascha.bischoff@arm.com>
In-Reply-To: <20251219161240.1385034-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|DU0PR08MB9582:EE_|DB3PEPF0000885D:EE_|GV1PR08MB8572:EE_
X-MS-Office365-Filtering-Correlation-Id: 8db46d7a-ee11-4157-015f-08de3f19a0a7
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?DVRkhMLxr9pGWZTwwgk1jWbGa4ylJEJ2WWco81pimOMLz0ut8xbOMn0FRt?=
 =?iso-8859-1?Q?Z2LSeFNGet3JCWK1+tSawD79KfJHETbQey3k9ZejNfJCWQgb5lHUn9IA+d?=
 =?iso-8859-1?Q?v1lkUROZWYVcDNjspe0Niybb78aaneGNDLxKbiDiU9Gkt/FNP6JNQS2RBB?=
 =?iso-8859-1?Q?3ReN5aaNi4CqmRho6/i+ZZ21kQI3/njzMbX5HOuyztfzttDgy4qNQKGYAC?=
 =?iso-8859-1?Q?kkKu+iyTvES9xHmZi9fzRJaRTAh4IPM+3oQ1EOLuri1ZATqLNPArOztMg/?=
 =?iso-8859-1?Q?LCJxIw32UDzavdNG35eAMvZKexcZHJDvnnMrvgFJXpKGOSJl3ZLWp7Q2eO?=
 =?iso-8859-1?Q?tKz6cphoyKU4X7WQSbtgkOQhYFayihukA7jfjl0UvGvkWySM8Xj8d/Whud?=
 =?iso-8859-1?Q?JmP7Rv+0YqS6ExUJc5NP7ArXqkDiz/vy0PBJ1snp8E2FMN8g1AVtWVpVV2?=
 =?iso-8859-1?Q?QtaVFuxfnMcmDKbuA/kOhPfBtlLBVqr/UmW+rT5VFsDG2zS5hYeu5QOTtZ?=
 =?iso-8859-1?Q?yHMtq4YjN07UGCHbqwdgtP9Y6YlE73pho/+xLVOT9dL7WeoTas6G+oktHs?=
 =?iso-8859-1?Q?1uXxMvVSgXVL+yFMCdOAP4hZos011G7n9MB7oGloyFhI4sCzGsSpaviBPU?=
 =?iso-8859-1?Q?WHkOgJzVaBFxApVZxnkeaRT9u7yl7/vyUzwUAZ5DMtVD5xIYNBJiZCIR+K?=
 =?iso-8859-1?Q?hTK45dpNl8a5IU76E6xmgvdTCILALQGV3wRNWUP2YmJw/i6SDZ2ingyoY6?=
 =?iso-8859-1?Q?zcQdmjRPgzune9Kka4bqwnuDjJNMjUa0Ls1zSeuoLRIkwQWZ/7tKwsviaT?=
 =?iso-8859-1?Q?9ITxbsXDXcguqJlFGUtmxgicW8dI0Cz1YUwTO53L16ohjkCjVwAK5yvp+U?=
 =?iso-8859-1?Q?x8jSMdzN99d334mHrphS3JVjztgvdA160OC7VFKiz74zqHmIx7DaQi4GiD?=
 =?iso-8859-1?Q?HQLY7YLPYENEKTx2X1LVOdzA5CIIe2SrBWIEqbfHt/2xatklf5VyRl9L+Q?=
 =?iso-8859-1?Q?LaSNErGZUwMVX3xO3lkXqPJSn1trgfmN096RFfUWJY+/BisKqjs0mpcQXX?=
 =?iso-8859-1?Q?Egbu1Zbrp68fflTtMBsL7kCummC2BaUDb955Ik7c+2pS1F6M0Nal69apb6?=
 =?iso-8859-1?Q?4Qs5R2Wzzg81tRDOLxNDm+yACIcMG2PreyUTYWbsNQvc9pICVMOO/9WOOE?=
 =?iso-8859-1?Q?kW3XpJauD+Rr4w0JKu6VwJDkbzP018c4ORJRXSyW5/bETA1HGKl1a8KszJ?=
 =?iso-8859-1?Q?U8xQK0mcrGzIY8EMFwAphH9Q30iK3d6rZU+n/nZudRoe46GBzwD722+gkW?=
 =?iso-8859-1?Q?TMBJEjtbB9HSF48yXnbi/uO/mv+Q1j7Zg6+/edvJ/vn3i7MMMS1FGZVdmY?=
 =?iso-8859-1?Q?vStWNRgOtjalezMniPjs+lgBSq5ez5vw+nt10uhNWvtXSn254awmpvPdPp?=
 =?iso-8859-1?Q?Wl7DXTD+tY8Ei/6wgOOLGs2j9QSXRCsRd2CTPOTVfub9skVQOZGa1ZsZlF?=
 =?iso-8859-1?Q?/RcyT3S1LX/fRBIrTbtQU3QtRgVkDcXUcnTYIy6xAQ5krNLLtQxrE32+Bt?=
 =?iso-8859-1?Q?22Q52D033uadCg6B5u11/6ylNrPV?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9582
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885D.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4a5ca5b9-baef-404d-abfe-08de3f197b5c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|14060799003|1800799024|35042699022|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?WBSvOhcgbqSP0u4uerQsYn/qExi7XfSUi7Djlvs4TZk4d9XqoqRxwj4SRv?=
 =?iso-8859-1?Q?EHedtqA4a7SDcdqpTl3sGokcqXPQrHF3o6VP4qpDPgCEmr3chjsSxw9W95?=
 =?iso-8859-1?Q?NYODXZAMGes8Qz7Z0b/wDa5HCJe0Tz7UhYfyiAUnwUnsUWg/k+Fg6V0jOY?=
 =?iso-8859-1?Q?17ktjlvdH0UJDBG/++RlgNU/Lt+9RN9lE9cbtipceVh19fVn/NtePdUgHc?=
 =?iso-8859-1?Q?CsEHHhAGjq9A7uXwrDw6bDyg8c9E/cElS8X0t9FxCReB17DjHVEOzYvb6I?=
 =?iso-8859-1?Q?9M80Hm6WMWThqHhq9UGOGtj+irN9F1/8n9nWUht1Jwx1TUkqCx4dRMdwU8?=
 =?iso-8859-1?Q?Kl37mR0vh6lctjQapNDj0WkVQMNck5+NnzOhHjs7ia1M7df5uC6TxvCS3A?=
 =?iso-8859-1?Q?5MuRyXoRGjSV/hSoGhUrZHe6djRLr+wAoIDisbMMC6NJnSggfjqlpJOj2u?=
 =?iso-8859-1?Q?q84/WHerfuys9PKTXfpDT44yM5w9AjsLWibJwjBl/2HFkJns6beHo20BMP?=
 =?iso-8859-1?Q?7d0tjy3i6gvl0/3ZGRZ9p95XhPlBdKPDkmWVgck/ryGFdvWNpD55I4hRT0?=
 =?iso-8859-1?Q?AnLsR6Vl6dFNsLzuy1hCpYWNILs5PPfLhSLH3ZiqVRG1ARftA06Gm8PZEM?=
 =?iso-8859-1?Q?/KG1C2tOu00hg0JqjRzAnoUYjXag9iLcUpYVK6qiK5o1mcEpcLdq3tV8wV?=
 =?iso-8859-1?Q?i1Y5llgFFJf+LI96rj7G/5gbO/i1iITQ+ho+N+kYIsnyzeDgIwrrPHlGNa?=
 =?iso-8859-1?Q?SHgnmj6hGFqVNurWYLa0RkRnucedzoNzBQV5Sz7JamB0JH900IrOxNIGT0?=
 =?iso-8859-1?Q?AYfTtAiBNJRlvMZi9/IMyMPNPo8DRqgT8n5jDPpX3ZUQ2C6C/PekKn9Tl/?=
 =?iso-8859-1?Q?OivGInAwCkbqhfVkdSCa9TorvtUxr/HKnjXSPmt7dT84Moik8l9YmLq5bi?=
 =?iso-8859-1?Q?WNwCK3xiU1w0L1nQADERZgyV7H0Ck9rAz0WW19995u4wDYd3z29ShWHjB6?=
 =?iso-8859-1?Q?+Lj4wjh0gPeArfDMji/g/qt1nsfBNhgrtAYWqqM1h28piu0POhBkyATgt1?=
 =?iso-8859-1?Q?wq7iMO8aJoF5R3ldQLZzY/i5ZOxAPxkX4PxpQUE2ZRSpF4jlyh8N35bkCP?=
 =?iso-8859-1?Q?K7HpifG3/X/J/JgQCYYu6Z01GDoCEqT58g57twpicHq3h0+4uaoVK6iZu9?=
 =?iso-8859-1?Q?20PODC5ww+e/Jd7z+YjhmUYCKFN8wE9oa0wHkN8yYu2TZKniir1MtLrr57?=
 =?iso-8859-1?Q?nDa6IAiSqYAS9t1FDF1bQiN2s8Q9uzRR5HVVvR9WhvzIU+U2kiMqnEHyMi?=
 =?iso-8859-1?Q?F6PnkMAsBj/y5HQNYzFO/fsHscyGkISkv3PRKcUCA6Xy0nL2TiyC/Lcpal?=
 =?iso-8859-1?Q?J7i1pCeTXZLin/BFFkYAN0QgPkw7Lj1eur1iGv5JfUq76WdH1o9Gj8pNPf?=
 =?iso-8859-1?Q?8JZHoQ6j6RC5fyDHD4/LJWRWIRNFPb4BNRsU7/G9daF+J1QJSu2WJRBeet?=
 =?iso-8859-1?Q?2Q2ph8ptNtw13QJ3szeeGcjp3bdN40R2b11u/MzWPXiosmr9BfGWoYJp1A?=
 =?iso-8859-1?Q?H8KOcfipw9D4G0PMB9zF5hU+sBptMhymGVbqoaoMG7vQnAEeXD14Q1X56F?=
 =?iso-8859-1?Q?TX2jxlD2rbvMQ=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(14060799003)(1800799024)(35042699022)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 16:14:03.4243
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8db46d7a-ee11-4157-015f-08de3f19a0a7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885D.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8572

Update the PCI FDT code to generate GICv5-compatible interrupt
descriptors for the legacy INTx interrupts. These are used by a guest
if MSIs are available.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/pci.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arm64/pci.c b/arm64/pci.c
index 03667833..79ca34e8 100644
--- a/arm64/pci.c
+++ b/arm64/pci.c
@@ -82,6 +82,7 @@ void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 		u8 pin =3D pci_hdr->irq_pin;
 		u8 irq =3D pci_hdr->irq_line;
 		u32 irq_flags =3D pci_hdr->irq_type;
+		u32 int_type, int_id;
=20
 		/*
 		 * Avoid adding entries in "interrupt-map" for devices that
@@ -93,6 +94,14 @@ void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 			continue;
 		}
=20
+		if (!gic__is_v5()) {
+			int_type =3D GIC_FDT_IRQ_TYPE_SPI;
+			int_id =3D irq - GIC_SPI_IRQ_BASE;
+		} else {
+			int_type =3D GICV5_FDT_IRQ_TYPE_SPI;
+			int_id =3D irq;
+		}
+
 		*entry =3D (struct of_interrupt_map_entry) {
 			.pci_irq_mask =3D {
 				.pci_addr =3D {
@@ -106,8 +115,8 @@ void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm=
)
 			.gic_addr_hi	=3D 0,
 			.gic_addr_lo	=3D 0,
 			.gic_irq =3D {
-				.type	=3D cpu_to_fdt32(GIC_FDT_IRQ_TYPE_SPI),
-				.num	=3D cpu_to_fdt32(irq - GIC_SPI_IRQ_BASE),
+				.type	=3D cpu_to_fdt32(int_type),
+				.num	=3D cpu_to_fdt32(int_id),
 				.flags	=3D cpu_to_fdt32(irq_flags),
 			},
 		};
--=20
2.34.1

