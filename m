Return-Path: <kvm+bounces-59719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CE85EBCA41A
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 18:55:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B99BC19E6E74
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 16:56:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B6D723A9AC;
	Thu,  9 Oct 2025 16:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Lg2vab7v";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Lg2vab7v"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011062.outbound.protection.outlook.com [52.101.70.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62054226D1E;
	Thu,  9 Oct 2025 16:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.62
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760028928; cv=fail; b=ZUnjjUrJUq/wPSR2ZsZR5pdQO04m7Ec11e1RPcXpYgBzXVORxS4LzCAgaBDB0q5EXzueW/iSdiqLxRqiI8fD4uJSmS/uoAaBlZfN48oIAhfVvIo0G3oFvwLUhY/Xbojmg0wakQ3q1SrUJ6ZSx83Z/2NjWP2QPwpu/ln0ATEZKfI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760028928; c=relaxed/simple;
	bh=bQhNQZLbzxQOhRsPqp2Z+kANnu894W+qNcH5Me31+oM=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=GaoqqrxrjqNoAn5n6eWqiffVEO7ezTkD85xb4CU9UMehgnQLvm4OF4V9XA/uZvUAO9VwiRmgUGTE7iNws1l59inDTaBbLwR3pMJJgn6O4+S+uiY4SYkp+2MC/3yheUAtcv2fnxRBa/vm7c34wKTo86NGFEdQyRV0bn+M0tCK/4c=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Lg2vab7v; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Lg2vab7v; arc=fail smtp.client-ip=52.101.70.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=O259lZ8VXYILJ8cpcwUSA2SfMRaQIZh3EhZea3ykt8kvqw/uF+RvoPwCM1V4sh365DizRi2gjuIhW3nA9iGctuGDqy4HQq3HzHEI17bQ1nx96YbHVriVIL+DJMtV4ZJ4UcoJJVws+TVdVrwS9evstQUpNZIUm0M7M+NJYXhCA1Wrea5c1JUtrBcHjW/FI36Bns0jInMi0U7uhDOhpyvh+pItKwkAQ22PPXHe4wx/i64YKOD7DAgYD8z6x82ZLOFHmWIy/Lrq1s9zwlSJa7E7UxhF5cHKkmNePj2dnSpUc5zK0NVNXIoWCK/hGnvinLpRuvbC9ngZHyvb6KmcCDgjcw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c3wMjnpVeLSjSX7nlm1AJfjKZIY3310ROKkilnyI2XM=;
 b=J9kHhaAqVGZJ32/7lPvVagRu/kfilj3ArVPeaiB+mcAM8yl/vP+xPb1BgS1BsLM7hiywQ6FXYthrMcFp8exZILYypIXeq8IxJefPi+ZLP+2iegf3bgiycJvPvGglVDtXaolwRwdRHOsK7UF5gqUsePBuQSnjjGzSrsF/0Ww8Lr76Qf/Texwzq6tkkIwzOvUAHXyFyClOFZCp8hG8NfYaW4nuzz+MKWdmARQ7IRvyg/LV1/3ylW4aQl2scF1V9n8xC0fRgxDL/nBLnNg/itP8geJrvEDZkiOpOujrSDbS319cgxfBL01B4wNHKv5aDttXx3MCzoidmtnI5miSut5W+w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3wMjnpVeLSjSX7nlm1AJfjKZIY3310ROKkilnyI2XM=;
 b=Lg2vab7vyY7jmasXdUs8zOgcBYVGqqqrKlbxBaoEqfXAQciZGr7/AMrit4ZA3nenQZ9IBGRTanV6g4PXs+XOeZ9dlRQVah51KEcRXM2UyQaC1c9k0G4d7nQhUaWBjEbENJOIO1FtnR03i6prWzNdHqL/sjdEVDmnkBdTf8sgR7s=
Received: from DU6P191CA0041.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53f::21)
 by DB9PR08MB6730.eurprd08.prod.outlook.com (2603:10a6:10:2a2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Thu, 9 Oct
 2025 16:55:20 +0000
Received: from DB3PEPF0000885F.eurprd02.prod.outlook.com
 (2603:10a6:10:53f:cafe::f0) by DU6P191CA0041.outlook.office365.com
 (2603:10a6:10:53f::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.10 via Frontend Transport; Thu,
 9 Oct 2025 16:55:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885F.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.9
 via Frontend Transport; Thu, 9 Oct 2025 16:55:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oIexj8guJkQQn9OtAHHZcbYHj/r5y84cVB9C3+WS/02uQg6FDlXk7QL5Umkd9DbFW8huHi8YXVipfipgVru9yOrgGeqcYf1+zHSjSmTH6WZ/5X7z+3jWsq5IWRHc0zMh14euLCyp25VF0KITVHTdq3MvdZDOCHRTB6xjIjzRAZMW4ScYA2i/m7lTS9Ee1cWJOk20piOAfYuagvMsMmtpI9026HfxnHITde8g4F7oXqIbaCuMYl81lZdxsDxDk/c4NJSq5rim2EU0rnaryiplub8XbiAjoX0Tw/C8kyDZamX7CBiO+1D569gB//eqwh41lUE5AWLn581/rNrXdpL4Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c3wMjnpVeLSjSX7nlm1AJfjKZIY3310ROKkilnyI2XM=;
 b=EyvvVxGzi41UPDTmip45I4YCbvbnuXuCB/X4JVXkhgRWL5d5dOt9m2FG3BbXyaPix78hm0a14fR14b8wUdXWM52pzhq32DNMSy7wY+rCErd8d1BTgs/ZWGO8x8NpaOPRQxOn9VkX8R+JjRGg/FOnnISdnTIrFMSD/fTmRLO5KVM4d/aNIpCC94CWjVCOmceijWWRI5RcUGPdpbOh62ZyDR+GO/kSL0EULapyVdhP2BytMNSdv3cl3f1Bvg+EH+WAHDBusl2RcGz5+scx35WxO0/VRqRdqH+jB5AScni6QTqy73kO9+cS0K93YIB6JgRc6bEs61mvGi8rpUy2BlNoew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3wMjnpVeLSjSX7nlm1AJfjKZIY3310ROKkilnyI2XM=;
 b=Lg2vab7vyY7jmasXdUs8zOgcBYVGqqqrKlbxBaoEqfXAQciZGr7/AMrit4ZA3nenQZ9IBGRTanV6g4PXs+XOeZ9dlRQVah51KEcRXM2UyQaC1c9k0G4d7nQhUaWBjEbENJOIO1FtnR03i6prWzNdHqL/sjdEVDmnkBdTf8sgR7s=
Received: from PR3PR08MB5786.eurprd08.prod.outlook.com (2603:10a6:102:85::9)
 by DB3PR08MB8795.eurprd08.prod.outlook.com (2603:10a6:10:432::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Thu, 9 Oct
 2025 16:54:48 +0000
Received: from PR3PR08MB5786.eurprd08.prod.outlook.com
 ([fe80::320c:9322:f90f:8522]) by PR3PR08MB5786.eurprd08.prod.outlook.com
 ([fe80::320c:9322:f90f:8522%4]) with mapi id 15.20.9203.009; Thu, 9 Oct 2025
 16:54:47 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, Mark Rutland <Mark.Rutland@arm.com>, Mark Brown
	<broonie@kernel.org>, Catalin Marinas <Catalin.Marinas@arm.com>,
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>
Subject: [PATCH v2 0/4] arm64/sysreg: Introduce Prefix descriptor and
 generated ICH_VMCR_EL2 support
Thread-Topic: [PATCH v2 0/4] arm64/sysreg: Introduce Prefix descriptor and
 generated ICH_VMCR_EL2 support
Thread-Index: AQHcOT1rU/YaliigvEWUajx68LDMiw==
Date: Thu, 9 Oct 2025 16:54:47 +0000
Message-ID: <20251009165427.437379-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR3PR08MB5786:EE_|DB3PR08MB8795:EE_|DB3PEPF0000885F:EE_|DB9PR08MB6730:EE_
X-MS-Office365-Filtering-Correlation-Id: ef117968-f2f9-42e2-d515-08de0754a1a4
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?ZMAqPqB2s6+uyzpt/4uzEvWy5PyEcaCScbJ8z/XZAQ7D79G/AB38vzrph8?=
 =?iso-8859-1?Q?wFAagVY9m/CKSFeUsxIQoSCceol/Vqlwnoxzv4NyxTfOiZ+QrRSxdcRwzU?=
 =?iso-8859-1?Q?ZCLdJZEbE4cXuLZ/eIyQbfPpoDMix83nMYEE1wtbwK1CWc38Hw7bppi+DG?=
 =?iso-8859-1?Q?u2X9JizCLscwjgDweSVE4iqBWtJrBBlXWK45qTtRlajy+fZSq7KrF1Brcr?=
 =?iso-8859-1?Q?2J0/hdTuawBGrH1OCqiNYw9rEM7FWFWtjECy9T1u4O7MHKCBc811vGl8KS?=
 =?iso-8859-1?Q?DXke2VI74dcopSVK2R3Z+WILgRpdLf4oEiYWiq2dbuq9OQE9sY34HAew7R?=
 =?iso-8859-1?Q?PRwFxpu9B0ZMsPemm72Drm/mhCSLlChE2XYfprdapAmSf0cBdXpn82lxbD?=
 =?iso-8859-1?Q?sfJnRVcJpexHBOYiaVWAYcJgR/BzLjOaHDFoWawqE+EsSkjyaIY5zCXGJF?=
 =?iso-8859-1?Q?YNbsYLgv0PEdJdAPCqou8xpoB9PHNZqv9cij9oln6QdttsN0Wbxp7uiUHl?=
 =?iso-8859-1?Q?k+EOtN/q2t4EaHztYjim9tiK1FbSZwZvYZCh01COTFbHx8z95PFDDhDqnC?=
 =?iso-8859-1?Q?I1H1LSzDBBHnU+VJ+sYJtcLz7RnsWGXq+9jRYvRKtoHjOeNZO9r9me8QtK?=
 =?iso-8859-1?Q?39u2TXjEDm+7siNefieWNa9MJHskTqpJQxMfMf6fLnMJoTKCnYEUivTUCC?=
 =?iso-8859-1?Q?ZMIuxkXvJnuo6FiL2tOfkHRQgJxygNuki0psFKvGDmERuDN0uSOKwE+a4d?=
 =?iso-8859-1?Q?BqwO1wzrWmrOr2roqDkOzOfagevNLnGgpiRxnmylX8A2SQcjiwLLjJfsmZ?=
 =?iso-8859-1?Q?kP743HyrhBVWolKvojsxXDrlCG/fy3ThYUxhNhn+8W9cMP68EujXEMIows?=
 =?iso-8859-1?Q?YWqhbRg09p0HFWHP4nSeENOpazLQyurxh2b+x3VLZnnOcbptOa0x3pTUVs?=
 =?iso-8859-1?Q?4KfoRaM5qB2wEmp5zPFNS5jwMteeOatUMCX4UUBPsv9j2YlJ7ANORrH58U?=
 =?iso-8859-1?Q?UA6BzHXikNp1rDjQoJURQtwM/zRMJKKQhrMJPAwM2/x5tM7etk1g53UTm1?=
 =?iso-8859-1?Q?mBUGsoOZ4XUYbKjmwYTZoWCtOersMDycXOmJWAPtBNM9Ywo0kUfxa9wJ+B?=
 =?iso-8859-1?Q?CT9xnGB8lVMPutyskTlmmn++XuHSe+4rxGXl+MgLwvNeKxUj5CxlSLudI4?=
 =?iso-8859-1?Q?TmAmEg45sm/+hg09MD8v5aD2SfHEjPUfQy455Wi7MO0or317p6+LN3dDg1?=
 =?iso-8859-1?Q?RBbUgkpWYM98AtFNQozM4INzTE1lepGhvsyVMjCeGQt9cB2B5UfZO4Skjd?=
 =?iso-8859-1?Q?zEE/Yt5tEtSOo59kKWJchknFL2vixyywH7ZJL7ijU5UAOm2Tq7WsDr4ddp?=
 =?iso-8859-1?Q?pHvE3yRpO5lhbhdrLopjEsohBkWpvS4W+f5DUhwrrXSy73+oICsXGNDh67?=
 =?iso-8859-1?Q?gIVNuEVFW6im8J4uqVcd1MNG+x3Cexx54PhA4Qylq4Jn4JidLpR9m3ybeM?=
 =?iso-8859-1?Q?r9GA9BNKloq3Zvxq8WCsHJfy14MmtMO6cye0Kix/Q7kRJlIZetxDVy6+wp?=
 =?iso-8859-1?Q?O71sdJW9BtASroUoN1uPZOj5gn5O?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR08MB5786.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB8795
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885F.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c15d84bd-4e09-444b-966e-08de07548e14
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|1800799024|14060799003|35042699022|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?JiOz3Bwrs/kX1/HwDSYlsMdIz76vH4V1iABKjBzNbIvLE/X7vwBOzvC5TU?=
 =?iso-8859-1?Q?dNLUgK0/GI9ulqUuFj8kUbYmqcvPYCU6lqxFs+Ys/B1S6nFLvDBGpCtkAH?=
 =?iso-8859-1?Q?Fys/GLZf1C4raEWuCwUtiUDVWiltgDuEsIXdgWU5j+47X1Jp8JX5uvUOYL?=
 =?iso-8859-1?Q?HvKQTtqFGVOmMsgy4ta8/PNXlMoTaKzNbhpqdG537gr7xOCX89hc+4xhDY?=
 =?iso-8859-1?Q?i2gjY4ImWLYEvFJRc8MbskL9YilV37xatsscSmmHsREARfH9vQWroMj0rt?=
 =?iso-8859-1?Q?nTmwATb+C9+jJwSOOmhb0eYIqiX7znp+lVVi0cSc/8qgO70mcjW3FlNwgt?=
 =?iso-8859-1?Q?z8bY1zH/tSjrWbWQzpnpjc2y6BvN7CfCpv5DtBLq4Q0cVf542WZzO3dH8k?=
 =?iso-8859-1?Q?wZV0vmpmOIyLrlmQFUZx8ObXLrqnzn6HfqvwUheE+DIqmbC+Dm64B9KtH9?=
 =?iso-8859-1?Q?Rn3bgaJnFt2B/VC6maD0g+9GPnqnTKNm6FbxPhLDJRU7LBZUf+an/CSyiO?=
 =?iso-8859-1?Q?lmsb1pndUYjqY9S9EBlBAm31tbRpQkj8YuK18dOJsICWGTXvhIWwU3JsGE?=
 =?iso-8859-1?Q?3sqE1qribz5JNMcDWmHsWpaBQnvhtrD4vQiH5MdNnOXZiw/Q2sX+DmEGzM?=
 =?iso-8859-1?Q?1AEaFta+L+32xQxilnagUiStYLaUA+zqY9+W38pd8wT0YswNInH8BwfATY?=
 =?iso-8859-1?Q?izH9wNrpsaWRFmP5pgdjOwmnSIKqv/WNpjgTbw5NJMGBC6NzlSJ04MCC09?=
 =?iso-8859-1?Q?2wExKPRqwXbiCRdgXHCQd2XykoVhoBGBibXHSjhE7rwjjpgbq85dX8fq0h?=
 =?iso-8859-1?Q?OpdBA/gtZKEVpOdmtXro9sDDsrng1rZOQ5QrFApchbLD+HR+1VTC7SnEF9?=
 =?iso-8859-1?Q?oCLQYG4VAby/F/BHEcq16xi3ykHqw+pDBKnrdPr9mZ3TCPgWf65C61jU2U?=
 =?iso-8859-1?Q?GyCAp8xUFBKMVvOJATvTI11WXKQtl3Z2DRGFelD602nzwnTTWmAsmjDXox?=
 =?iso-8859-1?Q?9+N63OgwlQiuJgW+r1vGCPnV66DYcPR+4WBimHUnkSsKwb/aMB8fCsSnvZ?=
 =?iso-8859-1?Q?kDX6egVEEBDFk7aBVj6SHnIehycUnqc22Tg4dpz9Ksl/YpoG7XRxpAJ5mG?=
 =?iso-8859-1?Q?GotrVhww2/KaB8xR/QzHEMl2/QAyo3C8n+uXUuwMksY8nZys98cZ8xh3VJ?=
 =?iso-8859-1?Q?qGQbAg+yNWfNwvo/dU5byZsEo1EWKFgpbVyyfPG7NmW/6tGAtqjEeH3Oih?=
 =?iso-8859-1?Q?gbNbZQhu0V2WjgEyZ8aFQBBFT0VOWApMxBqP9An5aN7AGicHKf3/MHe49O?=
 =?iso-8859-1?Q?C1bVT9f4iv7YDdJHJU0i3MO0kfvBmPCqMrvEpB8791LbXOehXMWE4z+fOV?=
 =?iso-8859-1?Q?E357ChD9vWlh+Rh4TQco01Z1teFUte120mbfCVr9sxpqUePm4v7Ro6S+AX?=
 =?iso-8859-1?Q?c1/Li9j82kpbBzFgcwMOQCmTqDz4VukJGQxYOXu7UXZGSLpsNukUPtkQ7f?=
 =?iso-8859-1?Q?wUqkdQoKkD1XcdWWpS1R1Ed+KAWT6JYo7zgkdxMNaPUa8n92q63T5d/7k7?=
 =?iso-8859-1?Q?+7GyFhitwsKuGUU6+1RKpgef+jkDTwt5z14Vhdzy+fJmUOQfrbtk1hQIHE?=
 =?iso-8859-1?Q?5xWUJKSzgaTYc=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(1800799024)(14060799003)(35042699022)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2025 16:55:20.2787
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef117968-f2f9-42e2-d515-08de0754a1a4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885F.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6730

This series introduces support for conditional field encodings in the
sysreg description framework and migrates the vGIC-v3 code to use
generated definitions for ICH_VMCR_EL2, in part as an example of how
the Prefix descriptor can be used. In addition, it fixes an issue with
the tracking of incomplete system register efinitions.

The first patch addresses an issue where next_bit was checked for > 0
instead of >=3D 0 to determine if all 64-bits had been defined. The
result was that the generator didn't catch cases where bit 0 of a
system register was not defined. Thankfully, there were no such cases.

The next patch adds the Prefix descriptor, allowing sysreg definitions
to be prefixed with an optional condition (e.g., GICv3 vs GICv5). The
Prefix/EndPrefix construct enables generation of prefixed field
encodings without affecting legacy definitions which remain
unchanged. This forms the basis for supporting feature-dependent
register layouts.

The third patch adds the generated description for ICH_VMCR_EL2,
including both its GICv3 and GICv5 variants. This register was
previously defined manually in the KVM GICv3 code; moving it into the
sysreg framework ensures consistency and reduces duplication.

Finally, the last patch updates the KVM vGIC-v3 implementation to use
the generated ICH_VMCR_EL2 definitions. This replaces and removes the
hand-written definitions, with no functional change to behaviour.

Together, these patches complete the migration of ICH_VMCR_EL2 to the
sysreg framework and establish the infrastructure needed to describe
registers with multiple field encodings.

Thanks,
Sascha

Sascha Bischoff (4):
  arm64/sysreg: Fix checks for incomplete sysreg definitions
  arm64/sysreg: Support feature-specific fields with 'Prefix' descriptor
  arm64/sysreg: Add ICH_VMCR_EL2
  KVM: arm64: gic-v3: Switch vGIC-v3 to use generated ICH_VMCR_EL2

 arch/arm64/include/asm/sysreg.h      |  21 ----
 arch/arm64/kvm/hyp/vgic-v3-sr.c      |  64 ++++++-------
 arch/arm64/kvm/vgic/vgic-v3-nested.c |   8 +-
 arch/arm64/kvm/vgic/vgic-v3.c        |  42 ++++----
 arch/arm64/tools/gen-sysreg.awk      | 137 ++++++++++++++++++---------
 arch/arm64/tools/sysreg              |  21 ++++
 6 files changed, 162 insertions(+), 131 deletions(-)

--=20
2.34.1

