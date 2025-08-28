Return-Path: <kvm+bounces-56082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C541B39ACF
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 13:01:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DA931C26C6E
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:01:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ADDC30DEDA;
	Thu, 28 Aug 2025 11:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YO4MFBB7";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YO4MFBB7"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010026.outbound.protection.outlook.com [52.101.84.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C8B14A4DB;
	Thu, 28 Aug 2025 11:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.26
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756378822; cv=fail; b=pd+QZIWhmlu4BTge6wCVwV6XgPItskUZxHpGeWXAO9KzRSDFq9MJlxV+r3b7D/Mnv1OuSZTqw7+MM7+4Ak47H6jdmqczgmn/8d13XQbuOcEF7Qv6IFEhFkHHCZ5TNTijQ0ePori+4ZMQQnCVOyG0MhMGjvchU8L8xTa9z7Da3BQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756378822; c=relaxed/simple;
	bh=PrxpyxiCRWZknOKap1YkxhrbStKxgPu2/U7mPPhobjA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Q7UOwyronE/2z4gmxzyFLA0301VkRQGyaJjF5qmtWhXTgZzYd2Lg2wcQZhSdMc95bsoFhHi7pHzkqd0xHev45Yf+kKO/2zjynWS0YApeVowJSlElOUdKoaCk4KFDrCV239kWQODKEiVzKjagfc9DaHHyrE1awfowK2929sEvUB4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YO4MFBB7; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YO4MFBB7; arc=fail smtp.client-ip=52.101.84.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=WsfWVsXPtVtQllUUd7VvRwSruT1rA2HGHrAX3PEwdJOeZB6TO0F7vQd8puFaFUJu0NjPaYsJr+sV/2s3l2Do8H27HM4Dts4vrsnUNfn1uig6NNu0uA4rfZ68Qyd3fkQsmsfO7Moc2CQGNh5lVwralS7NTKJDaQcSG8hN3w+LNbWIkiwZH0geLajYG4rRU8vOnG2EGpCg7Eoj7iJN3ABdbIaQqHCVqcvKKA45hLRoIkb+u6O9OMk1czWBv7Yv6icNkM6o7TM3msI3lpZeE5cvCNkV2nn6qa+WJmijHHUl889LA3hNoCzWJeUkQ3TCrS/51vjtJSjcvnKfp7dpJwWbAQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iKpZ3tNKmCbHfe9L5JIPhEZE/11nQhLdEo9NTFPplJs=;
 b=FzBiKCEH0P3wkyJJ+yXN8pQQ3m8Q7HB9/MpvcX4nnwpmby4lFHOawOTuv7DNEV5KdaatrPXt0IBFYvnrUmc75re8T6WSs6DrUlMiQaJk9Tn0za/PrG3NdMYsFLxYSD71L9jMgrE88zLHzE64afWOeG+MyzNwx9o0Y+OXKyKlF2DAfBtGAqAIYXaDcbtaoc7DpUo3YE5QFE+1RNFTGt1YmdA6L+1FsYbaJnbYA9cMTCGzNtoUcM4kahovfAA9Ug3wdRdB6u5OMaQnubFQAb7NMIqNzrXpVY6aH8DfE3t00U/f4Qc4Iqz4KgDmh4piDx5BqxXII8OhjvKuu6RD2kQk6g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKpZ3tNKmCbHfe9L5JIPhEZE/11nQhLdEo9NTFPplJs=;
 b=YO4MFBB7P/CkPEsIRytjoqkdEyFayHJN6jO4qds6FRwZJOEJZ6WwtSb8TUX2p77+cTFUwEt1tx7XPXCB0UzIpH7pI81slmDa7R6R82s79bGpsrfWD7f8Kt1iThE4+gIfDf8fuU4YGl9gERLOgKX3OJpa5SzPf4L7W1durVkotdQ=
Received: from AM0PR06CA0078.eurprd06.prod.outlook.com (2603:10a6:208:fa::19)
 by PR3PR08MB5627.eurprd08.prod.outlook.com (2603:10a6:102:83::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Thu, 28 Aug
 2025 11:00:16 +0000
Received: from AM2PEPF0001C70A.eurprd05.prod.outlook.com
 (2603:10a6:208:fa:cafe::10) by AM0PR06CA0078.outlook.office365.com
 (2603:10a6:208:fa::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.17 via Frontend Transport; Thu,
 28 Aug 2025 11:00:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C70A.mail.protection.outlook.com (10.167.16.198) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.11
 via Frontend Transport; Thu, 28 Aug 2025 11:00:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oYALepU3e2Ncu+WaylMGuC1fpjs4O1xJDyblO9VneDfq7vgF+6/h4jimYbUR6NSkzmONgudvAcRxEQZZUE174T7ayeVbsendOmrJuF2qhfiWYhD9JXijXtiORLsFzHdL0V7Md7p/U2IZwJkHVrkmJgkskeuNehbWrmrxCZt961rKP38H/WMOC8mm6DwthgktwgAlWat/vVPDh4AhiX5RWbXmsHm8fcs3V0atGYs4rM8Doe/pRZ6zR3BHvdhzfc7fPnbu3M0JUS2LIVti2NO/GBpG4sM5m2V5EgwmibRu8uJzDQ6QR75BUCLUlsKIGVHSd1Q6cEOd8CgpipxPv+yhIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iKpZ3tNKmCbHfe9L5JIPhEZE/11nQhLdEo9NTFPplJs=;
 b=josEZlDfGBdCknzHTa9U4y0097QN1VOGFf1QD+smXcTPwnBmkrtIjqopuDomq6JBrR9HIWz3orCK0r9FtFnJ3slL5EVGSJYRnDuRBKSNtoRuCNtxso4qerLhRBFeuMpG5+ApyTsI7WVj85vmTh8TQsgNn3qH3WWYK1nB+1OEcpDfQY6WxR8f3ZUdq4xAUL/Ih225P7jHMNRIo8A5GDA/kN/fsIOBq0RLn0QjlMnidB7p1WtqXCjxEyu3fPd69VG2StI3FGpA4YReXLi+LMi4awEq8oKQiMqHL74T1RFXKe8WnRG/oXwWGXJHCH0vbJYfc7QGJn7bhc9awV81dJ84pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKpZ3tNKmCbHfe9L5JIPhEZE/11nQhLdEo9NTFPplJs=;
 b=YO4MFBB7P/CkPEsIRytjoqkdEyFayHJN6jO4qds6FRwZJOEJZ6WwtSb8TUX2p77+cTFUwEt1tx7XPXCB0UzIpH7pI81slmDa7R6R82s79bGpsrfWD7f8Kt1iThE4+gIfDf8fuU4YGl9gERLOgKX3OJpa5SzPf4L7W1durVkotdQ=
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com (2603:10a6:10:46e::5)
 by DBBPR08MB10481.eurprd08.prod.outlook.com (2603:10a6:10:539::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Thu, 28 Aug
 2025 10:59:43 +0000
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31]) by DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31%3]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 10:59:43 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "will@kernel.org"
	<will@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Timothy Hayes
	<Timothy.Hayes@arm.com>
Subject: [PATCH 5/5] irqchip/gic-v5: Drop has_gcie_v3_compat from gic_kvm_info
Thread-Topic: [PATCH 5/5] irqchip/gic-v5: Drop has_gcie_v3_compat from
 gic_kvm_info
Thread-Index: AQHcGArbWiVd3kAjtESkgKGD+/3j4A==
Date: Thu, 28 Aug 2025 10:59:43 +0000
Message-ID: <20250828105925.3865158-6-sascha.bischoff@arm.com>
References: <20250828105925.3865158-1-sascha.bischoff@arm.com>
In-Reply-To: <20250828105925.3865158-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB10202:EE_|DBBPR08MB10481:EE_|AM2PEPF0001C70A:EE_|PR3PR08MB5627:EE_
X-MS-Office365-Filtering-Correlation-Id: 3274763c-750b-43d3-111b-08dde622124f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?arYJEKaW3Su1netwU1kBta5fsWc9mWNTB/YuzK3GvlJOayF26Xz/sXFqNY?=
 =?iso-8859-1?Q?1I3e4w8lNr3WP8dguUKJM4sTloXwFsTTFTNq/vrWNL1JzlLJl3gODUr8K6?=
 =?iso-8859-1?Q?S9IT3Mvi4XpxFOh933SzslR+p3kKsrdRhPFO5mbniWjA8jmaL6L11oex4s?=
 =?iso-8859-1?Q?DUUE/aOyixCl+RTUkwC5R6f3pEFjTKJ6ZqlT1YuVrh9RFfdreQlpFQ+uy5?=
 =?iso-8859-1?Q?MbjLAYaWzIOs+MX/BNNNma4H+paD/7k6r43Q8RGjWANQ4CuKE7i6tdEbmr?=
 =?iso-8859-1?Q?oEDN1hYEwfeyanYRbIReUSiw9lsyxc/6oNIBXMe0wByQGrMPgRMld6Y2PI?=
 =?iso-8859-1?Q?ezWISWbPzgYfAuKBR5jE3gyNiaDhsfUu6gkvyDyh4V03p7mlJML2ohC7Ml?=
 =?iso-8859-1?Q?p6Czql8UtSDDqASx/HiBZVjf5EUsKFpzTYnOidOu+JXIjugHvM85N3axm4?=
 =?iso-8859-1?Q?fOiz+CuTDSKWLF3CEj60DzlE+UsQvtfrpKsJfHXrSGVIj02wf9tphxAGyi?=
 =?iso-8859-1?Q?CNYsUeKPHjWl2wer6xvzqbFynjhwecZFXIpT79THDJEkqOvb7ZKiW0j3yC?=
 =?iso-8859-1?Q?6S6ncypIplJwDnPYYNRkxvyFXqYe2Z6b1BBxJ8RPH6hbHgTx46i2V2ZJiY?=
 =?iso-8859-1?Q?0NXM2nlXC18MJz18ATz4GjF8FwCCV047xvINRBqnDokNiWzQu9TTuuo6xz?=
 =?iso-8859-1?Q?tr200aC0YY78m+H6znahIgBOT6tQ7B1KEKZ4HVPpX1u/T+yK3/crkcvBem?=
 =?iso-8859-1?Q?UYs01NucazDBL9v6OB3e6jEM3n3M1XFrwQpdg4Xx5KxzcWTy4Ln5XYhcZ2?=
 =?iso-8859-1?Q?y48BI+1puyIauZcqNyYGLRBuSh3SSo3V9s3DfXa5KNH5RnKYFXBq5Nc81r?=
 =?iso-8859-1?Q?kdVBEQ96JiR2gRIDWRjwm0AoQZQa+XvIYglR6AQybgUGobytPbewheKSFi?=
 =?iso-8859-1?Q?IZF7NG/FEFz0krAlUd+jkCGUOf5XEZRHvTzOpLCHpaIAhtvhm35j2WQuJF?=
 =?iso-8859-1?Q?8xicT2cRm/kM9izZTeP4aGZ2j8omcwV/SW7OJFcw839Jq6DnacDJs1/PXa?=
 =?iso-8859-1?Q?S3U1199S/leSpf9oNs5spNfdT9t4/YzmLsT4CEGOGE79eLAg1FDxcaWWsh?=
 =?iso-8859-1?Q?mzMVUoA4BeiwmXzzedGx4Cx7RmTyjDFyOX8oN81IGgU5AVac2GscOP+q5q?=
 =?iso-8859-1?Q?C8rJ/6R6d5Mu2xf95bqgqi60hujUBmaZL2xEM7jG0fgriMSCnIEpE/9sTF?=
 =?iso-8859-1?Q?0nc13LgQ1sDPYLX810jou/ZMigjBKItQGcU85FRK41+jxj+f40O6u2Jpze?=
 =?iso-8859-1?Q?dYNiXC/YPKe/+rH9YFY79pb6rHIH5bKyGkMDn/XzPIuX8OQJB+eG/xBjZM?=
 =?iso-8859-1?Q?Mk0xzith7MJp98AyA9yAHewtpFQBKy1YXnb5+MWAZYaJ5byhdyWPDZS12Z?=
 =?iso-8859-1?Q?E33dgDatPCYOVUb1pOB9XaCqALuXJhXotNc8JuHQ5VrlRRi8IXB+queFUn?=
 =?iso-8859-1?Q?RKpgxArl2U9hNjQO52E9xX05NisJLZKCssNkCBNq2ZNw=3D=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB10202.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10481
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C70A.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5d5f12c8-d7b3-435e-dbb1-08dde621feb1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|36860700013|82310400026|14060799003|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?rfRNIu5l/ZU+QcoDQaVHs7TGMzeZ4ay1ZbMR5Db1f9RqK9mFWRMqNFUXgb?=
 =?iso-8859-1?Q?LAwFDY90djnuUI+F69hX+NhuofCQX/2xUqBGOPVlUUGHUJjsg97oKNjEo1?=
 =?iso-8859-1?Q?N9fnTy/t5KK9CZM4PX+miWrr+lzkXkyk0vhgPCaRGg4ieapeYcr+/jFXG2?=
 =?iso-8859-1?Q?pXXKITI5i1XoOaZEoPnC1OWrU44yX3CwqnSqCDYH44v9XjFwx8Jv5kHb/T?=
 =?iso-8859-1?Q?M9NtvHsvtvZprC7p6KAR6eRHBWzHxJcHr8AevceRn4bLzBx2CXwFdvZTMU?=
 =?iso-8859-1?Q?Hpx//Xgi3FN470RjkgjYO1yc+Pxlan3cohl3Y9Kgnjyr/z/9Me2vxUrC2q?=
 =?iso-8859-1?Q?qt8ehpR3UJFGrNO4owFXkbj6kBa5X+1JwXqYwFT9ZZxfTc7yhj6qBtSm+G?=
 =?iso-8859-1?Q?BcgHu0E9aYv1lgq6CPtSNV4CYkD0+VqrKXJ2jEedDghRJqINByYPPJ6Won?=
 =?iso-8859-1?Q?yQWlQ27Q4uqsRWmqfG9WUsFRFgh/zQLTNZgiTWL3rAMKiAs3RpMpfazvEh?=
 =?iso-8859-1?Q?LGQr66/F25mnafxm8+v/XZJtCJrEiKZR0G3CyRx8cCApWn7xzCJlXvNZqS?=
 =?iso-8859-1?Q?DiALPssT/mLdVdcSNlE2s09BjIkpoLz8/gERQe2hk3KmLdgW0DJiGgwDpS?=
 =?iso-8859-1?Q?zI8bRRd8bZvQKaEtq3mTd9+OmXUbli2lZi4LexpZHmgg1bks/aJTLpO8q+?=
 =?iso-8859-1?Q?LtptkcO3ALa8I3mXKclBZbqmx5uvXSeMeTZVrQHUis0xlKqW5gOgQJ0KwY?=
 =?iso-8859-1?Q?AwsbmhjxBeGcFeDu3/JK5Dgbfv4n5ytyiOyj5HreZnlqvGwJ3ZDzmM0aQ2?=
 =?iso-8859-1?Q?gqvCpqDAtjNVzGJTSMG0IEuzWW/yFeNHLvwN8nme0gWAj4WOHV9y/TofVS?=
 =?iso-8859-1?Q?FXW1LCdfzd7KiAzHR7z+6XZ1kWqM11yKv8FPCoH34T5zdxYSBnHA3Prtnf?=
 =?iso-8859-1?Q?DGK9A8rf+2D+z/oi0k7I2LFSmgbvkTIhFeHcaG+OE9lb/4Oi3yC7AgzSBB?=
 =?iso-8859-1?Q?yD4MNh0ywjh2xuHwlFF20yxUZcVd7UOc+A+wzj568FgnWQFZe4Vy5OAwdT?=
 =?iso-8859-1?Q?50YPi5nqtGACVWlAi9HO9BoQxjJzcUH6A4/sLlXNFFoWdIFriQFMbgO5Lg?=
 =?iso-8859-1?Q?9wwBwOM5tNnUQeBpxYtyue4CcDK9m55IZ3RgdbPOF76FFNjhv6japoIzmj?=
 =?iso-8859-1?Q?Z8dUjw1zNBEZ6KTvOY4mpabUck1a62HaNviTY9bU+GQoU+z/cdfRx4Njq2?=
 =?iso-8859-1?Q?jtEouIbCNJ+WxElwL4E2zrd8lyXyS+0/KPhtfhGCjYKsNl0fw5fuRrMJSN?=
 =?iso-8859-1?Q?Q1zFVH8o/0ZuLrTKsoe+wUQ/qC1oCBc4ZKFEKig4lWtPhgz9JyAH1/CzZC?=
 =?iso-8859-1?Q?jABCbBpUm/U/P6abSfV2XiyG4evfnLCS7DNNl9RKp/AO64L8GVWQkoRkA+?=
 =?iso-8859-1?Q?mLWVU8CgN/LHfMyYhvjn2kfcd12ZH4LUEBIPZMpLp4mcKA0Ko14dhTUekd?=
 =?iso-8859-1?Q?+3LiSZI9Wifry/kaqs7lGX4+z1EA1v7wOCzKfzsIdrl5aB3qitjbm4aPr+?=
 =?iso-8859-1?Q?gq2FifsZwPtcS7DKuGnUBeJO1xXq?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(36860700013)(82310400026)(14060799003)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 11:00:16.4968
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3274763c-750b-43d3-111b-08dde622124f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C70A.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5627

The presence of FEAT_GCIE_LEGACY is now handled as a CPU
feature. Therefore, drop the check and flag from the GIC driver and
gic_kvm_info as it is no longer required or used by KVM.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 drivers/irqchip/irq-gic-v5.c          | 7 -------
 include/linux/irqchip/arm-vgic-info.h | 2 --
 2 files changed, 9 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index 4bd224f359a7..41ef286c4d78 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -1062,16 +1062,9 @@ static void gicv5_set_cpuif_idbits(void)
 #ifdef CONFIG_KVM
 static struct gic_kvm_info gic_v5_kvm_info __initdata;
=20
-static bool __init gicv5_cpuif_has_gcie_legacy(void)
-{
-	u64 idr0 =3D read_sysreg_s(SYS_ICC_IDR0_EL1);
-	return !!FIELD_GET(ICC_IDR0_EL1_GCIE_LEGACY, idr0);
-}
-
 static void __init gic_of_setup_kvm_info(struct device_node *node)
 {
 	gic_v5_kvm_info.type =3D GIC_V5;
-	gic_v5_kvm_info.has_gcie_v3_compat =3D gicv5_cpuif_has_gcie_legacy();
=20
 	/* GIC Virtual CPU interface maintenance interrupt */
 	gic_v5_kvm_info.no_maint_irq_mask =3D false;
diff --git a/include/linux/irqchip/arm-vgic-info.h b/include/linux/irqchip/=
arm-vgic-info.h
index ca1713fac6e3..a470a73a805a 100644
--- a/include/linux/irqchip/arm-vgic-info.h
+++ b/include/linux/irqchip/arm-vgic-info.h
@@ -36,8 +36,6 @@ struct gic_kvm_info {
 	bool		has_v4_1;
 	/* Deactivation impared, subpar stuff */
 	bool		no_hw_deactivation;
-	/* v3 compat support (GICv5 hosts, only) */
-	bool		has_gcie_v3_compat;
 };
=20
 #ifdef CONFIG_KVM
--=20
2.34.1

