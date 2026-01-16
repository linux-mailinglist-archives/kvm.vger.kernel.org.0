Return-Path: <kvm+bounces-68372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DAEE2D38448
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 19:29:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EBC6630A888E
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:27:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D5413A0B26;
	Fri, 16 Jan 2026 18:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Q/LrCPWV";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Q/LrCPWV"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010020.outbound.protection.outlook.com [52.101.69.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFB039A7F7
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 18:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.20
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588064; cv=fail; b=KexMZKGURJwng4uN7hiFIdDC/yJznrbdBXzBtoy743SwfobpBp31aIp1S80hCGthBQoDH/h90q7VFb0obtC2NkVv+S75+8v2ItnNh4bUTNoUUo4d5ZeOdBY7b3krEmMHLRrygOH1DSoQWzKrbJBSmlp544KkEszcyY2BQZbz7Pc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588064; c=relaxed/simple;
	bh=ZNOs4Gfi3Y1dp2MVE226cC953EAZkci9TedruQWJQLE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=B2ndRi5qJoIBqQ8Etbpn57mJVJb58ju1TQLxHBt/SK894XXTi/Gcx7hQhMUkrhcrZ8luMSNmGdQzSOX/1UbKJKKm4iAQmyUmNOHQz+F8abP2NZDr/4Z+eR/QETKP5obwMabyF4XQ35sS9EJw8gfC1vXhkjXRS2Cufvx4sWIrQKg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Q/LrCPWV; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Q/LrCPWV; arc=fail smtp.client-ip=52.101.69.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=aww/4qbRWRXU+HbSgVtqj6T5i1QWxznYfaYkMHIWDZ76ZK1OhebX/P3KPcUHHelbWjMt1W+Weq/3uq0061B8G+H3Lu3DuffDNSnNOGbqcs3pYlpzVMrWmrX2Nff+N/+Z9ognL+1pxnZvLqhlZ4vDxRr3992Ep0kLPI+YpXUqlSSALZZ7XapRT2/qR6yLLraTcjJRZduW6b/K8jMirrEZ0+OzqqN/MuzYkhaDLQ5WwdIiTcXfSwEBousJH889DcmheajdFrpnORDINLboze5eFCSChFyNpInoTOR/zwFwshT/di7gZ6IpZUsOcWt13ZsU5doMMCciM+3yv9x8m55uDQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4KwbjUG14M3diYSjRqtMuN6xTXrCqZp1b7VR3gUzH8c=;
 b=ItZ5c2NZx6aX7ULiDztk8E91nIoGGsbBSizAys2rr9lvRrdDUMh8PPsS/XShcBdDNQ8sVqMjD8o4xFliMs31r4UEBGOemQnsg2/WAaDfXjI5kS0pI+QUbhTOCp3ddoQZImt3mO+HwMT2UslpPkU9gHbShAzPyie1pOxv8a0+1j+oz7yxAOnW2/g3m4d5nbISMsL4xEwIAfooZ7lYmM2yeefhNelEbgMWO6tmgzJ2+RMbxllaKHShcNjYpufDP6bS0MrEfDlfi7mn9IYfxCM8/41/LA8ugb9xJI4rNvzNEOUqj81g/AztV/olJEwnnB0dG7qjAW7mnKgDLcdRJvvIEA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4KwbjUG14M3diYSjRqtMuN6xTXrCqZp1b7VR3gUzH8c=;
 b=Q/LrCPWVS47AurJDzw6kz3vUYX+HsApt5Ua3Sjvr9HYsaK/MmTx1QYxVmx/sMrp1yACM5IdEQjE2wYjqV0KwgUghYMlaKzvOekQCmajCgRZkCP9YsQPc52WKCSIxYaNimIKkR6sIFAmOMklQ5NZ27KvxDX+aexxlavJjH38vbhU=
Received: from DU7PR01CA0015.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50f::13) by PAVPR08MB9040.eurprd08.prod.outlook.com
 (2603:10a6:102:32d::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Fri, 16 Jan
 2026 18:27:39 +0000
Received: from DB1PEPF00039230.eurprd03.prod.outlook.com
 (2603:10a6:10:50f:cafe::ad) by DU7PR01CA0015.outlook.office365.com
 (2603:10a6:10:50f::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.8 via Frontend Transport; Fri,
 16 Jan 2026 18:27:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00039230.mail.protection.outlook.com (10.167.8.103) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 16 Jan 2026 18:27:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IlZ6nxRPgp0d40j/z9BeF0+YfyaYqvHCqMkD7h1yQM1pPSglCOprun+Fbe9y8dn29WlkN4boqyyet6rKrizkxlSaDAA9yQWsgRGgx4jTl5iy2apwiP4r+ma6g+ODmbms4o3rnxnrkrCL5g/p/ZYBj6Mn7eWdLUiiOojpPe6Nq26uCw6TnmmY8TjrgzBpP5J1ffeFVTq8tnaSuqhITu7o8BJBth1Nol4x1oLjNfX+G4FVA/WFLj4SYkkXY98KFZ+Cy3oaGfmJ0op1cPoPufLVfwoAOgsvxTuzT8LtRVsrckPqXlBBOd2IjNnyK0hkH/ajKAqfbjGUg8SMW2e3fQgBjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4KwbjUG14M3diYSjRqtMuN6xTXrCqZp1b7VR3gUzH8c=;
 b=QLMrDAY4nLeH44y/2kId72agnKKQnloe4HI4AoE5tT+jLO/XlMnhCcqbG8Vcwreqt7T/kKQ/SQUVtWxzwP5UXKWyEhZC+c9QCLrZeeY6uk/YGJ2B+XZr5JwbnHUmqx/DJQ9tuTLKGU0D5CKdbGFYGptwHuPmNXcaGD50F1KlTL5woUqaoSI4lrFuNshmOroSB/YoK/w2QgukmIOW1r/yF+vADqAWTNFPp2hadV7ShkGA6wEzQOK9teP2J3eqzmwJpvRBRELLeUuFNEVut6883V7VAkWLYJxfFAlw/YKkTBWJir0iUiV3QItaGSvndbeA1uARbYt7SCfVQYbJD7jPsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4KwbjUG14M3diYSjRqtMuN6xTXrCqZp1b7VR3gUzH8c=;
 b=Q/LrCPWVS47AurJDzw6kz3vUYX+HsApt5Ua3Sjvr9HYsaK/MmTx1QYxVmx/sMrp1yACM5IdEQjE2wYjqV0KwgUghYMlaKzvOekQCmajCgRZkCP9YsQPc52WKCSIxYaNimIKkR6sIFAmOMklQ5NZ27KvxDX+aexxlavJjH38vbhU=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DU0PR08MB8731.eurprd08.prod.outlook.com (2603:10a6:10:401::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 18:26:34 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 18:26:34 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH kvmtool v2 05/17] arm64: Generate GICv5 FDT node
Thread-Topic: [PATCH kvmtool v2 05/17] arm64: Generate GICv5 FDT node
Thread-Index: AQHchxWkSoVfcFljUUGNAopm/cH7dg==
Date: Fri, 16 Jan 2026 18:26:34 +0000
Message-ID: <20260116182606.61856-6-sascha.bischoff@arm.com>
References: <20260116182606.61856-1-sascha.bischoff@arm.com>
In-Reply-To: <20260116182606.61856-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|DU0PR08MB8731:EE_|DB1PEPF00039230:EE_|PAVPR08MB9040:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fe4fd23-4ff7-47da-e073-08de552cedb6
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?FofS3dFBAbQFR/VZTKDe9c1MjGG4dbS3ebmC9BmGptYOGeWr+hqDapbTbW?=
 =?iso-8859-1?Q?w695E2oMrgBoXJJt5IyycikeYe0GzEx6ro8LH6EFDZZDeq5tGmESY+53ro?=
 =?iso-8859-1?Q?zZYM0WLFPGk2N9WI32Va0iLyvzC1Xac9sOw66qCNM+gwxBy+xpUO1LPlE8?=
 =?iso-8859-1?Q?sTECJEUy6D1cxA1PmXZhi0BPHyqEusPyvrpzb02FCOGsbuJgBoHLjx66tu?=
 =?iso-8859-1?Q?0yfYdwLBP+tFNcV0CL8qQNye37WN1nFtH1cJlQvxLan9ZDAClxRfRWBiou?=
 =?iso-8859-1?Q?i5FJeFlm795kpbeq6lDFKbZkGEceCIpJ1lD8qKryQ8A1ACwlolhEHh8gPb?=
 =?iso-8859-1?Q?6KEPtwhj92NWRL42g+wVDLdTGEZsp+RAtvviBp9/XZVYx+aSp7I23WR9d0?=
 =?iso-8859-1?Q?y+I5K5v6zall8kHJc1P7HUydmvm6yzUdMmGghJvkeWdbNJ/5oRhDs/DJDW?=
 =?iso-8859-1?Q?g9Gg1LDqV/alY7B9BQJZklvl0UEpjyobyV/tIjsRf3qJZZkU6BkDAti1L2?=
 =?iso-8859-1?Q?WLdd5ip/S40W4JGCd2Mxq7aoV+r4pFlPMWerWfepCCcRlatOgZlzqQGW1Y?=
 =?iso-8859-1?Q?fvxMEpIWApHXverow/fC1QpR94pIKT/iIYiWPTQQsvgp57sKkJZUKpb8l+?=
 =?iso-8859-1?Q?xPsGwWUWYa+Dhgz2OZeh3AemgDYcH2A8Pb6JtyLJJYWrUS794Gj/auiLcV?=
 =?iso-8859-1?Q?gQnqkDIphWL2ZJDLGgagD5zfyho3tJVDIt1O6SALepqFyFjWGotyl4JHT1?=
 =?iso-8859-1?Q?/V5QizXB0xRNCeVyLUmBmJFJ57ouTE1tt09zqLuI4lHoyBqUgIYF6jmLz1?=
 =?iso-8859-1?Q?Wefi7+DzOwfD4YHIj1GIWLNbalhtyrQRz7/399zIpCPiIA7833/LshsY3J?=
 =?iso-8859-1?Q?VvBmt7FPPmGnUcBGv8C7RcJut6l3r6T9MTppCNimZEDXbF/zupxg8hrnP6?=
 =?iso-8859-1?Q?oZs8ugg1wijPjBBRPolHWYSI9cPzC1nZEiTbQLa9EnScIThjTPl2C4FVHn?=
 =?iso-8859-1?Q?LdtmA3x8SmPQUCdkn6ZGEEXCR8gmlkTGuquOaIFjXkt7vELcI5hRgzHvJo?=
 =?iso-8859-1?Q?R1fay2gCmRQN305xaGO/LptQ7JMZwHCJ3/mzNh3PmPPvgbKsLBjdbyQKjz?=
 =?iso-8859-1?Q?/p3grWA0sYDEw8+A8IVBIvkfIMkF/x9okON/xtV5nE51vAjJ2ReGkZhS2w?=
 =?iso-8859-1?Q?Cxxe7a6WEcEvWv1a5Dml62F/17/S4MBrbTheP2GNsz9UOyzDifDpjr/lGp?=
 =?iso-8859-1?Q?IEpKYbqesUrLAWRKHm1S85zVttic4Lrma3yyoPQpmD2Ofl6b4tn0kE62Qg?=
 =?iso-8859-1?Q?9A0eRh1jd6o+2RrDkCBNhjKB74noiRJGJpsCFjg5zABFMyd5YTA32D/hXw?=
 =?iso-8859-1?Q?XIOfUUZGwB5SrASvCZt+a3OMpWtfTcUAoM7OY+uWNJDos52NeVzhLp9pfV?=
 =?iso-8859-1?Q?qhI/e5sedJl9C3tWoLiDy3XN/qH43P9Zx8ZX4ZJ/+S+xf0JEINpAoVNl2r?=
 =?iso-8859-1?Q?fkeywStvT2t6UC9xAvUCwLy7w8W91buLn+Y1NNkH9PT4XL52BkX6df+qvv?=
 =?iso-8859-1?Q?mrT9j1OuAp6SnpqMNgI22Jw6RcQIsx/FA6jRUHSHWuvscB2KQ0G5SFOZKF?=
 =?iso-8859-1?Q?b5IwlSy2Ug1NPvHhox2sXmZJpvQRXn3sowzeDKWUX0zVeDu9plzf1kJf5j?=
 =?iso-8859-1?Q?88EPvfcMhk9jscrsoa8=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8731
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF00039230.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1e6f136d-4d40-4b45-3e1d-08de552cc76b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|82310400026|35042699022|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?diBH/KpUS2CDlP4Eozcz7iYfhybYH4W9GtSVYS04vMzcroS8zAU+O+6Dmb?=
 =?iso-8859-1?Q?H8Bjpx2Atb4vdLI6fsiG+4vHoFCUpWRMs8jXOPPl4HqDEDzr8ac4XUDl8P?=
 =?iso-8859-1?Q?xOCTpSNnkESUToKaAWQ6Q7qY1uug2CqHCighPR8LEnG11/pQBujyntF+Ht?=
 =?iso-8859-1?Q?yY/Eg+sr3rlwDddYubDlIEnLJoyXkMN8/RLGmOFLfyWwBqCejWT3ux0G/Z?=
 =?iso-8859-1?Q?qWrjUjT4sgB05Qea2QPM2PQmQf50e6YQpraO77jzBgSlNjUZVALSbMOQJZ?=
 =?iso-8859-1?Q?uiWC1ecXoapZmp9RbDAzNlCzoGtYBiKGx1x4jObyboUaqTJojLmO4Hg7pS?=
 =?iso-8859-1?Q?JnBiz6P5yTF3UMZR2KSvM1SRE2NHDNHs+X9n/lFGtJrHTx9C3EWwxwJm9d?=
 =?iso-8859-1?Q?InmMcab3i5z0ppwyVA90yp1yRYuWcIT44HsLkxLbiRd3kmtDL4iTBs5lCV?=
 =?iso-8859-1?Q?2UqUjhrRJEejCa7mTsWhTJbsQm9gCuYfXTmgTqYxWCxkohHntGKu4Gm0o1?=
 =?iso-8859-1?Q?8dfRWWRBhDADL7yvgoKf2EN5eZ/ljR40JQ74yaZwZTNYaqqKqC7F+mt+w7?=
 =?iso-8859-1?Q?khwq5hFvnwkzErq0nm6MS00GfdXVryegRQUSBU8CuboKFaHS6tN90WAYI9?=
 =?iso-8859-1?Q?VHY1ou5Yw/1dJLw/qc7BcY0yBdSDxQ7kdLJMy4SXkQBL7hk0ms0xPOaQWZ?=
 =?iso-8859-1?Q?YzimEES/jOUnCRdTskP0pPKdN9RQj/od6qnNahOs2TK34gzN7CDUGNNxN7?=
 =?iso-8859-1?Q?JRVH8apUAOxC+lVFAd975CV2TmIq2ajqzHwDHkF/VZoEJFFxi/MJHmXwGx?=
 =?iso-8859-1?Q?VfgdVDlzoTgGOKiCozXfyNLuu8niIVoSjJxbui8N3Eb3Anl4OLscgxtFoN?=
 =?iso-8859-1?Q?3K45D7yp0TY3nXZ0k1efOrJxpbrF/PLI/wYcjHxQqkeD6FjZnlXYELvd6s?=
 =?iso-8859-1?Q?v1PnmmLSCkfbgHuJpJ+pKOfGvI7rYLejaRfM2PefNac20bu+4pK0w9mSBH?=
 =?iso-8859-1?Q?QUfZgdksNazP0cnjauwMSbgrsbX1C5SPSaHXp5MVUtPFV3ArIjkqzE0S2W?=
 =?iso-8859-1?Q?tfM8nRdsQEdf4lE6k/naV3cU41FpmtxyJGwyqpk+WcUf1LvJbPgBmkfHha?=
 =?iso-8859-1?Q?+ZTy2XHmDO5IbH2oTdgLkGecc0Znlt+3Gx9AkFSE4vPdhIBZj5TX4FRCm9?=
 =?iso-8859-1?Q?w/WBbe9HP20lLSj/5LfiwYEa96dXrni0xbrapjksl7OZ38YyV1Q+eUZaxi?=
 =?iso-8859-1?Q?+JdrVr/KcxpYZyLuUGYLgQcXSum7ojAcGGurwbCKW0b0Ke8oRivqqs67GX?=
 =?iso-8859-1?Q?1xzJo0bVNZpEgTMimk68RGbwmo1jhaM4Qt32xa03R+pGFOGMTVCYm6oRe+?=
 =?iso-8859-1?Q?mCZEshLgbKj3MfZMD8z9F5RSHND1ZQXiLC0PLQrrOpIQStqbMr/aZhCmUN?=
 =?iso-8859-1?Q?I+HsD90TOJgFUS8I1oD7FJ+J1TMGNKMcKHUQY19/Z2+fiTeDqZOUzMlfXO?=
 =?iso-8859-1?Q?xcoxlrXKVRVPWJwhIjMhQUvGW/VVm14M4JalAjjgneKbVe5dHkankDyoGw?=
 =?iso-8859-1?Q?UExiLa4gg1h+KLSGyFEaMDccu7zXyW65TFydvxaPo680DyOrujDtxN+11H?=
 =?iso-8859-1?Q?hXaOD8Omkx3fNLidb++okOwLVjC4R3UwOzslNoF0+IVApauKvIRwA2VFMd?=
 =?iso-8859-1?Q?v+nmw1LgrUWsask6tS6q8UfKZ4FST3IIrtCGxWpC6hvnTgmZg9kGYkpbcO?=
 =?iso-8859-1?Q?XIng=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(82310400026)(35042699022)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 18:27:38.7262
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fe4fd23-4ff7-47da-e073-08de552cedb6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00039230.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9040

GICv5 requires a different set of FDT nodes to what was required for
GICv2/v3. Therefore, add in a GICv5-specific function to generate the
FDT nodes as this is much cleaner than trying to adapt the existing
code to generate both variants.

This change generates nodes for the GICv5 CPU interface only. This is
enough to support PPIs. Additional FDT changes are to follow as the
IRS and ITS support is added.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arm64/gic.c b/arm64/gic.c
index 725f0d52..189309e1 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -377,6 +377,8 @@ static int gic__init_gic(struct kvm *kvm)
 }
 late_init(gic__init_gic)
=20
+static void gic__generate_gicv5_fdt_nodes(void *fdt, struct kvm *kvm);
+
 void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
 	const char *compatible, *msi_compatible =3D NULL;
@@ -407,6 +409,8 @@ void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm=
)
 		reg_prop[2] =3D cpu_to_fdt64(gic_redists_base);
 		reg_prop[3] =3D cpu_to_fdt64(gic_redists_size);
 		break;
+	case IRQCHIP_GICV5:
+		return gic__generate_gicv5_fdt_nodes(fdt, kvm);
 	default:
 		return;
 	}
@@ -440,6 +444,22 @@ void gic__generate_fdt_nodes(void *fdt, struct kvm *kv=
m)
 	_FDT(fdt_end_node(fdt));
 }
=20
+static void gic__generate_gicv5_fdt_nodes(void *fdt, struct kvm *kvm)
+{
+	_FDT(fdt_begin_node(fdt, "gicv5-cpuif"));
+	_FDT(fdt_property_string(fdt, "compatible", "arm,gic-v5"));
+	_FDT(fdt_property_cell(fdt, "#interrupt-cells", GIC_FDT_IRQ_NUM_CELLS));
+	_FDT(fdt_property(fdt, "interrupt-controller", NULL, 0));
+	_FDT(fdt_property_cell(fdt, "#address-cells", 2));
+	_FDT(fdt_property_cell(fdt, "#size-cells", 2));
+	_FDT(fdt_property(fdt, "ranges", NULL, 0));
+
+	/* Use a hard-coded phandle for the GIC to help wire things up */
+	_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_GIC));
+
+	_FDT(fdt_end_node(fdt)); // End of GIC node
+}
+
 u32 gic__get_fdt_irq_cpumask(struct kvm *kvm)
 {
 	/* Only for GICv2 */
--=20
2.34.1

