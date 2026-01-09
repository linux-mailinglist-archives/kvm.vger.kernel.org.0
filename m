Return-Path: <kvm+bounces-67595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E8E92D0B8AE
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:12:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 32B063043F74
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:06:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06760366577;
	Fri,  9 Jan 2026 17:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WgRiW7bp";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WgRiW7bp"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011061.outbound.protection.outlook.com [40.107.130.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B0B364E97
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.61
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978353; cv=fail; b=m/vN8dPQieyipxTXcSulAzQlh9ows444iSB+omi0EH18IwteaG2lCljItPx/PAwDx9oq6ePLOaH3DTrpYhaLaV7sgZIaXzG9eS/jo8CLI7mwHsNeUdit+jEwt/SbJnE7vODJRLqBAIDflnkGPu6+86X4H6xxpe9ldwRlFl75jHI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978353; c=relaxed/simple;
	bh=XxRiZaxW9tc2sDGCvPXoMPAIL0QDwniRQrgTVRq2C6g=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ddpmDIqufOaCsXTuKve1Fgwe5Ty9Nqz+e6LluVDWPp84bmmRKSlzHzZbVqwMUcZV/u5UqUg4lNzMx3pTnP/mzYLy/UHeEEMnspS1UmoeXm1vLNYuE1hgluvyI+5U6EU0mrWBee+97Xu5UjNmLxfB8EY57BPsn5yTdTxbJ3qakLk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WgRiW7bp; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WgRiW7bp; arc=fail smtp.client-ip=40.107.130.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=yrMKZXtVi8CkLx546BBs3U8e5xEkEqZ4tlg2lcqO2eufE7F4e+KqInclb8KHV8IjRO5MAxvGRHNLHH3BGqev9Eiy/FTyrlCONEcFvOMqSfY9AeLZ136yxBHPlqdh4vdoN4UvXa+binpp/5MqybckvQPQKp8Woy8KKcChf1EcxqVMjUR/Hm6TmaKiPqV3tv+FvPGtI0qVK1/+ktPv0oGAipyXJjZJnMn955iNLjvtLAlHFlH2jBvuy0JPMs8+E3xnBAKio8MVuxm1uM7wr1HCK7aBKJ9jrKLYT795PA0P1OF4RqAmZHAvbmCiGHY3DHAqqivWJ00trh4vvhozUwXmzA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h9QSmx8+MSL2GORrrMf2qAZz+pB9XhrlQBBhm9cnyMw=;
 b=ZayJGpRq2IyhehtOgHpoD7Kyq9xxeLj9M0ukJcdrcU2LbNpwXY7kyuTPYdFsg34TF3gHQ/TDnlQLWSLFtkTtCvSVA5I7yLKf923wAxb7zC+wKcq+OJ4IJvLTR1uJHnsTzBgh65fyj2ifbEcZZCE5kHWFRl10WDatNRdsXN3rhxGsI+t5IYUB9Z0EqzpaBUZst+RKqhCugAGl9kU1x6WMMwANAFwirACjNmw7lr6+NghDJ1UhMFIWsabw0m/zxKit4LENpmI0HF65waub/JHv6teF93AqAqmYMa0P2qSJuLIdb6ukcWJJuzhbXXGKClOjbNAybsU9N32f32ToXSRznw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h9QSmx8+MSL2GORrrMf2qAZz+pB9XhrlQBBhm9cnyMw=;
 b=WgRiW7bpJ98E3rJqlcqRJ5akS+66TC/jrmlp+cZBg4W138k/HMFHuhxJNCvWov6kxDMXjMzUvBbsZnez3BdcS9oKwwBOIEPpUr/pOWfB3m08XMCFrEnuTppD20aPr6nBn+80wkxQJNFEIThLK/A6IuiBduxFuSzJwGAqL1T+TFI=
Received: from CWLP265CA0409.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1b6::8)
 by PAWPR08MB11202.eurprd08.prod.outlook.com (2603:10a6:102:471::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Fri, 9 Jan
 2026 17:05:44 +0000
Received: from AM1PEPF000252DB.eurprd07.prod.outlook.com
 (2603:10a6:400:1b6:cafe::c1) by CWLP265CA0409.outlook.office365.com
 (2603:10a6:400:1b6::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.5 via Frontend Transport; Fri, 9
 Jan 2026 17:05:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DB.mail.protection.outlook.com (10.167.16.53) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:05:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ih6CXsysEmSAIejIKNjKjS7+YH6xxEjFuF+SPE4LHhkYGsB5KWwz4jwLrMbx/br3XBxIAScnHu+IqS3vyAZ/sBsLo1bRZ2dsxkPXrP553DZVuuZTKq6l1DXcahDTUmXsIdcydNFvLEU7vs07649EO9zp82M8UJYmoY/EFI/fhc3hEN0NwsjmaUPWMEuyMlhh2eGvrq70iAbUmqW0NBveGhZ25GppYQHqteFUv2vwsi0WiVEtyMA+TApzAZdnyXlzXgJQt5eiFwWXCEsZXyWnfZENA7jb7jK8nr4K0j1JLZZ28RHKCyS3p55mNK9wo5fr/NAoTbXsBEJzYczpRsmrjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h9QSmx8+MSL2GORrrMf2qAZz+pB9XhrlQBBhm9cnyMw=;
 b=JOeIJcQWTzPmeb0hfzxipmPHdFsxaZBfyb/NPvwRkXfhIohU5JQYhvaEKBz7PO6cXMa1VKO6SM4gpz1UgAdfa4+kO2NBWV4xw69B6RHIJLDiRHGjr5AdtrXHkILtZLXpBkWsiah+MLaJyYVzjzCqSrMzXuMzbIk9LfUmplTuL/heWgMdAiVahTEs1UuaOklv2+kRWsJkk0BY5Py/943Bb+FJjXWTlU9t/QsRS/BAsQ7wvWdreLt+SqB0W3CyRveERGalzZLpTpPW2JCPDvxMJeFE6vpk9ombBv+H/FL986bl3sW/pp69q48aI1hubDhMoW1g7DrT0Fqvo5V3gbXZNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h9QSmx8+MSL2GORrrMf2qAZz+pB9XhrlQBBhm9cnyMw=;
 b=WgRiW7bpJ98E3rJqlcqRJ5akS+66TC/jrmlp+cZBg4W138k/HMFHuhxJNCvWov6kxDMXjMzUvBbsZnez3BdcS9oKwwBOIEPpUr/pOWfB3m08XMCFrEnuTppD20aPr6nBn+80wkxQJNFEIThLK/A6IuiBduxFuSzJwGAqL1T+TFI=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS8PR08MB6216.eurprd08.prod.outlook.com (2603:10a6:20b:29c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:04:39 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:39 +0000
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
Subject: [PATCH v3 00/36] KVM: arm64: Introduce vGIC-v5 with PPI support
Thread-Topic: [PATCH v3 00/36] KVM: arm64: Introduce vGIC-v5 with PPI support
Thread-Index: AQHcgYoKUxTMgxSH6UaHAWZXuDpDTw==
Date: Fri, 9 Jan 2026 17:04:39 +0000
Message-ID: <20260109170400.1585048-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|AS8PR08MB6216:EE_|AM1PEPF000252DB:EE_|PAWPR08MB11202:EE_
X-MS-Office365-Filtering-Correlation-Id: a300146d-55c3-423b-515c-08de4fa152c9
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?QlJsLhT6+NgciD00NgSNTsIOXYcIgIPcBHsFOqFlEGyzBc6de2w7f8OHgg?=
 =?iso-8859-1?Q?/YYdR5CRtzCFtPttEN2/uIKRVv1WXAVSPvk+4+rnF97uNd2F0MQX7nfYdf?=
 =?iso-8859-1?Q?mTT640o5oIUzKFE9MKvNhnXg2HPjj4Mh20/EjRfrTWz2oLYB1xCqCcRnX4?=
 =?iso-8859-1?Q?7jWPQUB0RhSAuq7cdGPTu1rmFybHs4PvUZLD0lFLDNVj0q3lanUGhwzepW?=
 =?iso-8859-1?Q?9Gc5tYQYRHmOXD+uRwznaEN4OE2kKlNy6iMP+RzbW1EpZDzXqspYVaCu9a?=
 =?iso-8859-1?Q?fhboEn65XUhlFijGfPdqG2EZWJSE08hTAZa88v791NyP8PMleSpjaK5wLY?=
 =?iso-8859-1?Q?5b/vAUsGIdBPoKVEmr890BkfsSqeN4Oif6EaPIGos5oA1b7GjotlSnCF5/?=
 =?iso-8859-1?Q?fzYjbta2zHVTdX89H/2m+yCRf1HL9NimG+2S4+SRXYGh3yFtmUxx2WybL0?=
 =?iso-8859-1?Q?2I9JVkf9c3RxslCQfjQTsYGKXpz1cpMEL8GQNomLULL1XeZPZAzEVSqorX?=
 =?iso-8859-1?Q?GFCx83IAVYBIvKDZADvMGvOp1Qgbe0f1ocWdNCJVUM0MALEynUb2sUzROr?=
 =?iso-8859-1?Q?LSyfv4RqgILWcWjluB09yZ3P0b+GlEB+wcYjAffIEXOf+63u+Wg7RajNCE?=
 =?iso-8859-1?Q?3d6+08qmVpMkZGsxmtGN6JxY+Emmmu/TPeEdNOuvnuUM/WtL2XY3H3eDk2?=
 =?iso-8859-1?Q?1MDKf6JB5y3vrTPAROe3QFfumKAF0wPgQxzmkCvpUNfNLTppOH0zgyHvlL?=
 =?iso-8859-1?Q?jGOicppp2U4Ciwp0UVmBXqQO8ZOpnnvXPxnzjPa/kth0f3yAiqPW4leojn?=
 =?iso-8859-1?Q?fltbD16GR0QlxrhNfitbJSXoCsZpoNunaZcKSwuzc4k/TUCsvhBqIP5giv?=
 =?iso-8859-1?Q?xXFoC3gontMx5OXys7GQ/QGGs0BE/eeS4OBDTsgpqUIkiKoAaQ93Xbx6uM?=
 =?iso-8859-1?Q?S4bdJc228uzAaiRC/RwVM6K+lCjh+MocHrS5EEqxW36xBP/yfOSmP+JFWO?=
 =?iso-8859-1?Q?ybLJKB2kwq9ubFV43B9Pb2ebFBrFZKVwzlcN2IuTTPTOEIjK7aF24kYyyO?=
 =?iso-8859-1?Q?jDCpJl3FSegVAwAlz0fOU+C78jUXDhAImOaf2emU43z09JLRRz5MAXRKdb?=
 =?iso-8859-1?Q?Uu8RNmHgw30MIbYtlIL1pK7vmJgYEtH1eAQcfBP+DBzA3UXsta6NWnNLvH?=
 =?iso-8859-1?Q?tlFn+Xj/U/4pF4uZQ+S0quK3OHYO07xqdvCa5OAF8ZGUvX1QhWpsPf+Gvv?=
 =?iso-8859-1?Q?SM6qJiG7NSmXgkhb4BPdwtCYCxiV0PN21oa6sQKfJhKyACRFdq5sg4Ewqm?=
 =?iso-8859-1?Q?hZ1s4ZWzhAn2DNIz3jLtzkftDc8lYysAs358tXer6R1NKX397dz7HX37eZ?=
 =?iso-8859-1?Q?mOl89W+CxEqWMoOozmYcaHbqned7AsBrTcvnfQKqGEgYorYpwOewkqsykN?=
 =?iso-8859-1?Q?ml2aYvuI3xL5GgJnGqg4guNxUnrci0tL6jh8BnwOHYoFwqKxogh5IDbYHm?=
 =?iso-8859-1?Q?jg8MoqoNcBWlB08JLI2d6arvB9RyirVzwMKA9+dB8JbqR/P0vfD6vKQNpc?=
 =?iso-8859-1?Q?26/5m95IRQ7FiLgI4T7Wieehy+VJFDTermtWtu5fME7uze/RoA=3D=3D?=
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
 AM1PEPF000252DB.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	90d7936b-44b9-4784-ac2a-08de4fa12cae
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|14060799003|82310400026|36860700013|35042699022|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?0mMDMDDh5ArnL6xEsa1fQHFo4j9UsCr/DreV7yCtfr8iyhTN9YCEv2T2Gi?=
 =?iso-8859-1?Q?cExVa+HW3HGbn1frcV8A4m38PAlRAxRdjQSqYtj81rGooANS10j/nX3bOs?=
 =?iso-8859-1?Q?goVn9jt6Ap6/QAoo55lgMJo91AnFIS9mja6PfG4Sydk6IL/NsYDGSKhSdp?=
 =?iso-8859-1?Q?bVRzfiCncrV02hOTCSJfKg3EWEAHbH5ewUjg87qGXG+/BeGNAqzAxnZE6+?=
 =?iso-8859-1?Q?CLDOSDM581WcxY5mhnOragKDug42kVFzoTtkbkdeoQhdsRzbl+0RJfkGYq?=
 =?iso-8859-1?Q?9n6IvG4BKSEyZZn05AyAUtW1YjpaBbhK7TA9pkn4zSDS2fXNVCA5A6TRX6?=
 =?iso-8859-1?Q?deHohOflqcpFSbyQzO1gGYRX4EVz3eIdqravmhWDdT3awuT+vLRDtWXV4F?=
 =?iso-8859-1?Q?yX7fRRywjJdk1q4cvgUOI2KwZ9JNdU3N42KENgq2lO8hmisriYf6psIINY?=
 =?iso-8859-1?Q?xgLJ4eKp3JYFEp3YOqzjY5/DyAyHutuSxowk4wYYTt+c6K5J7J0bKxbhDn?=
 =?iso-8859-1?Q?Ij+9XYsjUq12gmA3FdFwVqSdsPSJWPSxQ0T9SjeP/JBqbTeaGymnyg7RnR?=
 =?iso-8859-1?Q?15FrGAHzEKBoyvG0kFMrZBGFqyqBXTzDz3nHRGk9K1gZ4q4/+lnM8Rtqzx?=
 =?iso-8859-1?Q?MKG3vBE6R/OVhpDxfIkg5XsssIYf9Hti4XnPTmnzB0HVA3cvkd0oxWTgxM?=
 =?iso-8859-1?Q?cAK0L1Ee57G4uKC/dsUDWSQ2diUx36IXIqsnN1pg+x2IgnlQH0M/Wf6cIN?=
 =?iso-8859-1?Q?F+Sft7Wm4fwB5juC6dLoMjL8oixh65HPQ2gmLQnCTSGZq1dcQferra4SzQ?=
 =?iso-8859-1?Q?gHKk7yFtL2UttgDevb2Ul9y4eZ+rPmxPgvWiXypst1kv3ZfJ+hz+/5hHA2?=
 =?iso-8859-1?Q?hMmvCFmZktLiCJR8mcJjNlY9k2A1DhHH6N/1qGzT1iTtQ7TJINAfHDaZa7?=
 =?iso-8859-1?Q?Zy3pWeA46USczEiVaSvebqsW0wIQsxmh9qFkjrDiPpR7t5THoeZicQcECM?=
 =?iso-8859-1?Q?lx/EvQjjfdWyy+9HJ1cA1bjjbaZ9qeXcLiGLZscQY+wnWWdscqrF7x3S2a?=
 =?iso-8859-1?Q?nAvFGq+uddVWRbZI8cLU2HlmyAc700YUhfZ9QBgbo3fdA/SDRCNcQ03bX9?=
 =?iso-8859-1?Q?KnNnP3ifuwWyvS2LPMiJzL7ErYrCBJKoZY5bEKD6iiiHE1YTuamb/LnDop?=
 =?iso-8859-1?Q?mKRIkVSJ1t5kEVg5eyTsLfC4wEeeBMW9OUW82jM2qnrGqWPEIzhhwqclnU?=
 =?iso-8859-1?Q?E/sBC9rOv5bavvkrNAdMJCs9ZJpBQfc8SF6QBktkkuiRcOiMnybVncxYhu?=
 =?iso-8859-1?Q?7+dYuHa+RQi+lAsF6MJNG7+dbfsYmeiZa6uNzv7hf+W0FZ9i19I4kVcEcJ?=
 =?iso-8859-1?Q?M63FqU0R8bhRseyK1CaBMcBt9e9OXOp18OJcRc0qjnj9MMoq3EOBcaUmOB?=
 =?iso-8859-1?Q?UsxPqg4+kXBcql7kxVvLEXLlFpQeQt0IYCT/vtYBY65iJkb69Mtg4uqnIn?=
 =?iso-8859-1?Q?1egdnkqi00fL/cCZYoYUF1N1ah1dyvhu6c79n0N2CFNksOhL7DOpIET0ap?=
 =?iso-8859-1?Q?pzefwZypG0lzTRtqCr3Kx/SEDJz9aPVcwknKHlsskCgVT4mYS5/akGUO6w?=
 =?iso-8859-1?Q?1c0ISDrHPVGK0mAqsXMJrFwk4W3cnRZVtM?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(14060799003)(82310400026)(36860700013)(35042699022)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:42.9385
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a300146d-55c3-423b-515c-08de4fa152c9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DB.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11202

This is the third version of the patch series to add the virtual
GICv5 [1] device (vgic_v5). Only PPIs are supported by this initial
series, and the vgic_v5 implementation is restricted to the CPU
interface, only. Further patch series are to follow in due course, and
will add support for SPIs, LPIs, the GICv5 IRS, and the GICv5 ITS.

v1 and v2 of this series can be found at [2] & [3], respectively.

Main changes since v2:

* Reworked the PPI save/restore mechanisms to remove the _entry/_exit
  from the vcpu, and instead use per-cpu data structures
  (kvm_host_data).
* PPI priorities are only synced back to KVM's shadow state on
  entering a WFI, rather than whenever checking for pending PPIs.
* Optimised PPI state tracking to reduce the number of locks taken and
  PPIs iterated over using the masks of PPIs exposed to the
  guest. Where reasonable, masks, HMR are stored once per VM rather
  than per VCPU.
* Reduced PPI trapping requirements - now only the
  ICC_PPI_ENABLERx_EL1 writes are trapped.
* Fixed a case where the GICv3 VMCR clean up did cause a functional
  change (thanks for spotting that one, Jonathan!)
* General code clean-ups, fixes.
* Added Reviewed-by tags where appropriate.

The following is still outstanding:

* Allow for sparse PPI state storage (e.g., xarrays). Given that most
  of the 128 potential PPIs will never be used with a guest, it is
  extremely wasteful to allocate storage for them.

These changes are based on v6.19-rc4. As before, the first commit has
been cherry-picked from Marc's VTCR sanitisation series [4].

Thanks all for the feedback so far (Marc, Jonathan, Joey, & Lorenzo),
and for any more you may have!

Sascha

[1] https://developer.arm.com/documentation/aes0070/latest
[2] https://lore.kernel.org/all/20251212152215.675767-1-sascha.bischoff@arm=
.com/
[3] https://lore.kernel.org/all/20251219155222.1383109-1-sascha.bischoff@ar=
m.com/
[4] https://lore.kernel.org/all/20251210173024.561160-1-maz@kernel.org/

Marc Zyngier (1):
  KVM: arm64: Account for RES1 bits in DECLARE_FEAT_MAP() and co

Sascha Bischoff (35):
  KVM: arm64: gic-v3: Switch vGIC-v3 to use generated ICH_VMCR_EL2
  arm64/sysreg: Drop ICH_HFGRTR_EL2.ICC_HAPR_EL1 and make RES1
  arm64/sysreg: Add remaining GICv5 ICC_ & ICH_ sysregs for KVM support
  arm64/sysreg: Add GICR CDNMIA encoding
  KVM: arm64: gic: Set vgic_model before initing private IRQs
  KVM: arm64: gic-v5: Add ARM_VGIC_V5 device to KVM headers
  KVM: arm64: gic: Introduce interrupt type helpers
  KVM: arm64: gic-v5: Add Arm copyright header
  KVM: arm64: gic-v5: Detect implemented PPIs on boot
  KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE
  KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs
  KVM: arm64: gic-v5: Add emulation for ICC_IAFFIDR_EL1 accesses
  KVM: arm64: gic-v5: Add vgic-v5 save/restore hyp interface
  KVM: arm64: gic-v5: Implement GICv5 load/put and save/restore
  KVM: arm64: gic-v5: Implement direct injection of PPIs
  KVM: arm64: gic-v5: Finalize GICv5 PPIs and generate mask
  KVM: arm64: gic: Introduce queue_irq_unlock and set_pending_state to
    irq_ops
  KVM: arm64: gic-v5: Implement PPI interrupt injection
  KVM: arm64: gic-v5: Init Private IRQs (PPIs) for GICv5
  KVM: arm64: gic-v5: Check for pending PPIs
  KVM: arm64: gic-v5: Trap and mask guest ICC_PPI_ENABLERx_EL1 writes
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
  KVM: arm64: gic-v5: Communicate userspace-driveable PPIs via a UAPI

 Documentation/virt/kvm/api.rst                |   6 +-
 .../virt/kvm/devices/arm-vgic-v5.rst          |  50 ++
 Documentation/virt/kvm/devices/index.rst      |   1 +
 Documentation/virt/kvm/devices/vcpu.rst       |   5 +-
 arch/arm64/include/asm/el2_setup.h            |   3 +-
 arch/arm64/include/asm/kvm_asm.h              |   4 +
 arch/arm64/include/asm/kvm_host.h             |  35 ++
 arch/arm64/include/asm/kvm_hyp.h              |   9 +
 arch/arm64/include/asm/sysreg.h               |  28 +-
 arch/arm64/include/asm/vncr_mapping.h         |   3 +
 arch/arm64/include/uapi/asm/kvm.h             |   1 +
 arch/arm64/kvm/arch_timer.c                   | 119 +++-
 arch/arm64/kvm/arm.c                          |  38 +-
 arch/arm64/kvm/config.c                       | 147 ++++-
 arch/arm64/kvm/emulate-nested.c               | 123 +++-
 arch/arm64/kvm/hyp/include/hyp/switch.h       |  27 +
 arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  32 +
 arch/arm64/kvm/hyp/nvhe/switch.c              |  15 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |   8 +
 arch/arm64/kvm/hyp/vgic-v3-sr.c               |  68 +--
 arch/arm64/kvm/hyp/vgic-v5-sr.c               | 120 ++++
 arch/arm64/kvm/hyp/vhe/Makefile               |   2 +-
 arch/arm64/kvm/nested.c                       |   5 +
 arch/arm64/kvm/pmu-emul.c                     |  20 +-
 arch/arm64/kvm/sys_regs.c                     |  95 ++-
 arch/arm64/kvm/vgic/vgic-init.c               | 126 ++--
 arch/arm64/kvm/vgic/vgic-kvm-device.c         | 100 ++-
 arch/arm64/kvm/vgic/vgic-mmio.c               |  28 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c          |   8 +-
 arch/arm64/kvm/vgic/vgic-v3.c                 |  48 +-
 arch/arm64/kvm/vgic/vgic-v5.c                 | 570 +++++++++++++++++-
 arch/arm64/kvm/vgic/vgic.c                    | 109 +++-
 arch/arm64/kvm/vgic/vgic.h                    |  48 +-
 arch/arm64/tools/sysreg                       | 482 ++++++++++++++-
 drivers/irqchip/irq-gic-v5-irs.c              |   4 +
 drivers/irqchip/irq-gic-v5.c                  |  10 +
 include/kvm/arm_arch_timer.h                  |  11 +-
 include/kvm/arm_pmu.h                         |   5 +-
 include/kvm/arm_vgic.h                        | 151 ++++-
 include/linux/irqchip/arm-gic-v5.h            |  39 ++
 include/linux/kvm_host.h                      |   1 +
 include/uapi/linux/kvm.h                      |   2 +
 tools/arch/arm64/include/uapi/asm/kvm.h       |   1 +
 tools/include/uapi/linux/kvm.h                |   2 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 220 +++++++
 .../selftests/kvm/include/arm64/gic_v5.h      | 148 +++++
 48 files changed, 2797 insertions(+), 283 deletions(-)
 create mode 100644 Documentation/virt/kvm/devices/arm-vgic-v5.rst
 create mode 100644 arch/arm64/kvm/hyp/vgic-v5-sr.c
 create mode 100644 tools/testing/selftests/kvm/arm64/vgic_v5.c
 create mode 100644 tools/testing/selftests/kvm/include/arm64/gic_v5.h

--
2.34.1=

