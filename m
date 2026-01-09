Return-Path: <kvm+bounces-67608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 8144FD0B84B
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:08:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B445D3035BE9
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:07:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8E0836922D;
	Fri,  9 Jan 2026 17:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gCyzVHH6";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gCyzVHH6"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010022.outbound.protection.outlook.com [52.101.84.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA837366DC0
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.22
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978360; cv=fail; b=fT5LYQj+WGutDTvJkV1xRgdGsxlvWXpHaJVqtLEB7Hr2CeymyGRdbJx8EN55VAjY+UIopxVr6xx31txCLxL5CFYWZZIwgpPc7G+TJRVhWSWJwN1dVY7t724kbjqneG9dIaUQ6EaFxyJx4xoH4/ySIgU4k1i8v9fZERKTPaUFVLM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978360; c=relaxed/simple;
	bh=3J4NcWwSZp79P6zvuSpLBlzJrvUHSwl/gGk1x/wfx54=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J89dC/blIW/OWUMuney3WQnBXtTGAsfQC/qa8pZUWl39ybGq170qneaommS6IeM39DucljLV+NSDz7ZIOcoiND+t+XRRN+Rks+75KBdwdZdJvDJpmzWarp4gkDMWd3iCWPbtI+ABSbovOEziu1HfWJYwpHyisSq1xsbu0dEDMew=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gCyzVHH6; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gCyzVHH6; arc=fail smtp.client-ip=52.101.84.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=a6UEZ8xfDYyFWbw23BQ4//9Kdw8qIjNpJ7ruRVUaD3Z1PeLuclStNaHgUxWuDb079Q+FODZqQlG473Jb2EPJoJdJ2RveojqOTTzu/R9NGJ7MN+BTb56nocY5CYR47hrehKktMRPlAIturmgjoH/toe2qBnG2t2OEA2bKa9OAtgowNNrUmK7cYaaEFP2rSpfxPnW1bOLU1xO42pIMulUx5m4tfZRJREvenoZMiA3vjLtXezUDZtB8T94ersCVp1vcoew3a/s6phb47v9axtKHG7ASqJ7MSafnSDNmxD59io1k0phWd8NMsIN9TcbtmTRVSLhk9Qs36aOaZJvUGnhWwA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7rE1UYUXO/Cd2UbSXOSuMXIPh6S0sL5Fgtg6F+t8Fgc=;
 b=BpJjyzdl6vcDI71Ser3cVRExlN8Jb79D2ttpIRtI0NXsr62W8U8V6oGHCMGkrM9CBUWQV6IdnmNpV72nBGIaDCPA4XmXVK8vVu8riWSufg9xDlL40EZ6XAtdJ/NdVJTXAhXKemeoZBvnLhnqXhq77jCYkpGHh6uaOQ9JPv9y6h1y7CkyDhReeHMt4Eg15FI8yp64/SfeR9gZHmCzQhsu7/D9mdXtmZcD7SVCnip0QYkobpoDAu1OZdPv3yj1b4qREmwQyccLttvK1YIg2iajQ1UAKwRdgfFDTvhLhqLlWxTLCFYizJnL77L+d/O/+cwGxHRxoXRRzbmJAtKODXkVMw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7rE1UYUXO/Cd2UbSXOSuMXIPh6S0sL5Fgtg6F+t8Fgc=;
 b=gCyzVHH6RVviX6F7x5TzMI/T5dMCTQ9NktBVBPYp7VyWwMxAcC2gPfqE1Flwz3RnAgoghV3eymzne94PVJkL5b9kgeuxjpAI6hhH9x+kkUMwbpd0hbZBzEOw4tQfCNoLSH+z4UXnFRBni9mwNXTlojCW7JACqyU80M7ucjKgs9Y=
Received: from DB9PR06CA0028.eurprd06.prod.outlook.com (2603:10a6:10:1db::33)
 by AM8PR08MB5745.eurprd08.prod.outlook.com (2603:10a6:20b:1c5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Fri, 9 Jan
 2026 17:05:52 +0000
Received: from DB3PEPF0000885B.eurprd02.prod.outlook.com
 (2603:10a6:10:1db:cafe::bc) by DB9PR06CA0028.outlook.office365.com
 (2603:10a6:10:1db::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.4 via Frontend Transport; Fri, 9
 Jan 2026 17:05:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885B.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:05:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DHCWdBUCke3iZLuA5zBccx7vypotg5QyixIaIf/yE59jXtyP6xgARWt8CmUl4LX5vsRY7nl69l6Npmdgua9fbz3GXTiAmDl6pmu14Ao0Gyx+BzcceAmlPXm/Tblr4xUScNADhEWVJTNtze8egr+3uIDjIQoROhWcadGZ9pMWil2uPIvmH8G8TrMhM/yLX6NSXrT7WMKUeST1QO+VLKFYXi1eZPheYw+/NVwImnxgYiksGtAjN769EqaNBSPr41mld3qkQaoF7ZXEGKI5D+nKRuv8J7p+8Av1r8qsBobH5LUeTfEu18lJuKfOc0o2++FeMtUl36xeLpJOIKepOa/sJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7rE1UYUXO/Cd2UbSXOSuMXIPh6S0sL5Fgtg6F+t8Fgc=;
 b=qQ/xDHkS+ESfcGZaDEKLvQPaFIoR3uKmjuPu7cyv7GzubbnHLv8Ri+qZGa/vuPUKXLhMdIPMGvwZ5R1gB2fsu9w29AAE71OWgkPt7OwSuS3hQSFY4bMJYfCTOgox3DOae6CQelH5BVlMx4eSx4c7w3d51aG0+lRmIcDxQayQUEcw82CUavoWZm0Hh4Ifrz39CXfmKTX1XvbYhNV+MFih7eT0uDlo3sjVmytk0aGZU8xHs+qVnlNxMRBvhpBP/5vhC92aIJd7odj2APdFacvtHioHYQTudB0rVGdnYtvtz/MygOCSZhmrPp8JAKS8v1V8JfNhTg+rJhR1yIa1YMDuVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7rE1UYUXO/Cd2UbSXOSuMXIPh6S0sL5Fgtg6F+t8Fgc=;
 b=gCyzVHH6RVviX6F7x5TzMI/T5dMCTQ9NktBVBPYp7VyWwMxAcC2gPfqE1Flwz3RnAgoghV3eymzne94PVJkL5b9kgeuxjpAI6hhH9x+kkUMwbpd0hbZBzEOw4tQfCNoLSH+z4UXnFRBni9mwNXTlojCW7JACqyU80M7ucjKgs9Y=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by PA4PR08MB7386.eurprd08.prod.outlook.com (2603:10a6:102:2a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 17:04:49 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:49 +0000
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
Subject: [PATCH v3 25/36] KVM: arm64: gic-v5: Reset vcpu state
Thread-Topic: [PATCH v3 25/36] KVM: arm64: gic-v5: Reset vcpu state
Thread-Index: AQHcgYoPLqemAy9GZESF0cTozIJX4w==
Date: Fri, 9 Jan 2026 17:04:47 +0000
Message-ID: <20260109170400.1585048-26-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|PA4PR08MB7386:EE_|DB3PEPF0000885B:EE_|AM8PR08MB5745:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ac9fff6-bf3c-4cd0-35c5-08de4fa15849
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?yjYft1KfANagXwo0tWT8Ce1GxtFol1TsqihavwD2NTyNrt3pn3HgtddqIH?=
 =?iso-8859-1?Q?o4951OAgeXDoobARI+pG7OZfH9qoN9bI4Nw5JQK0rBuW7hiRmyKDylxB0l?=
 =?iso-8859-1?Q?ipbBson2X5cmtZ1EbEpw6heosClRzgR/dl0x8WHmwCpUrMvYJ9fBY8sba1?=
 =?iso-8859-1?Q?NQkff+Z8B+flN/QgCq131nHDvR/zN51CyFF4y7qM1yq8gQxk6W7DW6J3o0?=
 =?iso-8859-1?Q?zbGXE0adbsGmVPZsNePtbztWQNkoTBO23rzUfzIeyGx/GfZSY3Cy0/J+Uu?=
 =?iso-8859-1?Q?caNYtZjUGzQ5v/7A9Katv1s3eJlzV/O0w3kSgpkLeazBL+LJ9TVu7bPa1C?=
 =?iso-8859-1?Q?wfInoAJ/A6XFaA6NLtTxMQHJ/8ZjaQiWvNCqXX6xl0YFXY01psiyHcDrPM?=
 =?iso-8859-1?Q?E+myqZaMD/9Wk0vx594ibmakdmDLmJdr+JmtC+4ODnhC0AuxxMqlVpwytl?=
 =?iso-8859-1?Q?1ejhLL1jiojTH582nija31sX+PP3jh/jXq7t0V4OkKxSgddNMympHJrZgL?=
 =?iso-8859-1?Q?LH/7gG5MIW0xfgEX8GqL1Kq8noNsmeuTHFhOUpidhUzNPtl3FnjY06RrQU?=
 =?iso-8859-1?Q?qGRgKLz8o14FxiknLk+MA7IPNFE+GDYAivfQEpXJp7IvAnuk/PiiXh+cf8?=
 =?iso-8859-1?Q?OHWCYWCRirt8THO+EtCP6oeoofW60Jkf3nSsEOS1c8NnP9H4sPxrVMgwV5?=
 =?iso-8859-1?Q?mliK6nDjVSjYItdDuly/XKKpqAyYdh+tvOPs2JbCChYVnh5wR6eUNgYlFa?=
 =?iso-8859-1?Q?zAmqkxWmsS7TqPdlafsPBNdG5qD00ime5Ssbpo+pifTPhX7jBv2127ZfEk?=
 =?iso-8859-1?Q?VEYgZAjLeLlhKND6gnMRzKgEgfhKQDRIVgIn2+QvuDkcSzHjgT366dgAWn?=
 =?iso-8859-1?Q?HFPt2wrjs+QOweHDbu1vmP8ilQi/INah6AsXtPyH2Ig8ESMi5yLp0UZ2+l?=
 =?iso-8859-1?Q?XtKqXKZfruaY1HFnG8UmvHcYYsi4VPWkrDywfCnc5FwFDeDBg5hWAGVHdz?=
 =?iso-8859-1?Q?KCTvMKiAvv8+hGgsA0LrWkZfLGUhUYcSKTZSSge7YpZpoeIkqejSrRxuZQ?=
 =?iso-8859-1?Q?x/4h9DpBOeCW4fgFnETPguuguNA7fibA75Jl/KvCg1a1DwPDZtkgdL/OGu?=
 =?iso-8859-1?Q?bnmr6bFcQ2PmscykMtIs5jI16EM4okSN7X4fcMrQ2vbrmSS/aPV7sjHEBB?=
 =?iso-8859-1?Q?uxn2ol1K8PdlfMoQ96Xq5cXu1WSvUVvY7if2MDAuRi/2UQF/T5/vbzO6ZI?=
 =?iso-8859-1?Q?dmlF4avIbkFSydgWMKjy2swYk89NvQy2FbdanOCFivPAOTp6Jl2ftwt1zN?=
 =?iso-8859-1?Q?J/gHjd1VM2szYV2WdlvOre1GLi+05vlsUsjhjbByXasZYmH1XexDBKZDGd?=
 =?iso-8859-1?Q?lsWlTrAoUUmhygtzbhOT76+zQKQ5r5RE6UDbDM6c/ML8gkJFOOGbHkWBQz?=
 =?iso-8859-1?Q?YTKE2VbufbuusMChMQJj4lkSZYR5fX0JzsqACFmgDMkvnxrgF6BthyfvzT?=
 =?iso-8859-1?Q?Bg8LekZfdQmJUPQP0AcFv9yQSu63qDhHCarRAg1HIcpLx4FWyXm+ePcB4W?=
 =?iso-8859-1?Q?H04p/ikLj3PcaHwoPmfE5OfqNWpm?=
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
 DB3PEPF0000885B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	877f7a3b-7738-410e-8b7e-08de4fa132dd
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?JM7nn3I1GCcblWMK5VgDMaS6XMDtX+LDo6KjMHVyWvEkw/0kvpjc/UcF24?=
 =?iso-8859-1?Q?UlMAfab0e90EpK+AGSNiR3cEiNkflZuwiv834lt4scf+jFZQfwG0feOaFw?=
 =?iso-8859-1?Q?A1lXMaHP0D/hPbrqzob0Mw53073ZVln5Bmz60WOvrQbq8wCqn0wST6R5kf?=
 =?iso-8859-1?Q?bdLcw164lP5huObVI8u8AB607uuanSsAMzKmW+Ougnzgyo76dWG6QJEND/?=
 =?iso-8859-1?Q?irMdTgZIblAsqD/F8iJXU049lcNbnwnTOqtdUzE6LQHy0Yy4Dm+OPmaLRJ?=
 =?iso-8859-1?Q?A1Fka5Afe8SzFDXTH46dvgo8ntd1c9SGbz3vhwLKFYUliQzTyDw8mQWakB?=
 =?iso-8859-1?Q?WL1s+RpHtmRyQr+3vurLSGeprE1IvJ96QePDsxuaDpQm8JzDxK6QGllbhu?=
 =?iso-8859-1?Q?AEfSCxqnUyA4kczOICi2hvkDNpLvgpdb0GZxzyrB3i85yNpcLURG3X2e4b?=
 =?iso-8859-1?Q?rutocHX9/ER3pAB33z2mB+pbUFvvK3bpdiBRApU7G/dm9GtJ86V0V0CziK?=
 =?iso-8859-1?Q?/dLih9vcJsuWVGtl80A8wUlVT+XID3mRvTVSWxTLHT8ArUObf0xqTJTJ8T?=
 =?iso-8859-1?Q?YHjZFgHIW+LvP+l6InutDedbMe1cG0GsNxdfemneEfQE7fBQcFD00UFJSZ?=
 =?iso-8859-1?Q?2wTExjBy9Ac4Fs3Itjl6SY/nJcn+sQLukccpE+hWlmkTo+GridVrSfrnvy?=
 =?iso-8859-1?Q?wE9nabsG9Qsj1WkrHQVktrXL9vhFEVJi899fQvcrul7EST/Awv81nT3tjq?=
 =?iso-8859-1?Q?rwz3xulxZ7/nKx+XsIRFbaTvgkL2VF6Xgev0xoIZ0syHuB52/Yf4ciq19V?=
 =?iso-8859-1?Q?WN/Cm2U623YgY68HKOVuELQkp+lnvUU+VOo0i6pKuFuuUWNcVUmG1VuiM4?=
 =?iso-8859-1?Q?alOkmJh6DJN50WslhMPs1q3DHEEcbLDE5L06VzKeeTtBZVgWaHBVarGcfC?=
 =?iso-8859-1?Q?+Bl5k8BFoxVOpJQN5othvnKaYnPsGfUL150auvbFVVwzEEntWNUfQX9xXX?=
 =?iso-8859-1?Q?WJi6m0BvMg1xIYFBNzW7NauOKaXKu7PddVfvXFBLpJ7OiqHQNioN7Mmm3F?=
 =?iso-8859-1?Q?F7XtrRrDLBGJrCufarjnrYJw0vu287VIPePhw0ef5AVeVTwnEp8M46J696?=
 =?iso-8859-1?Q?9BqH6gQ4qhqzxu2d3CJK8LjmtnWBDL82HryR5Ayb0hfNkKLDJM5TvzR2dS?=
 =?iso-8859-1?Q?cs18cHYp8DsD/UlxOld4Ykiv/TNlBDCrqgMhirmebuspMmpSCj7o7hXPTO?=
 =?iso-8859-1?Q?1PEL2732kppDwuo7ckWo0iYgXtfGuXQF44LMd1eQtM+PkcMZq44EOzAo4y?=
 =?iso-8859-1?Q?nDNqma9JpbviaOdjMf+k8Wrmb9TwbCbVgMqTKO8md5doVO7zYqNqBTD22b?=
 =?iso-8859-1?Q?i5xE/QjxQ8rNn9HusFSG+2flmQAtXX6RN5QcoBLfVCrTA2kQoHipu2paPE?=
 =?iso-8859-1?Q?/U15ZEDjaV6xQd6p/UNXLyysNnZdu6qWQQTRG0urKYb0nn1XlD6TUfcnXV?=
 =?iso-8859-1?Q?F3/WgNWUbewbyWs/+DX/zlshY2skBKynhEA3wdq5GmFPqI/GgZmBw3A5CF?=
 =?iso-8859-1?Q?KTOPbDZcwojkPZ0OeIMN2IgYJpyZyvfVltLZkv+Cgy/BQAFKgXTJfAWCgX?=
 =?iso-8859-1?Q?Vti+deJFPWxkc=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:52.1634
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ac9fff6-bf3c-4cd0-35c5-08de4fa15849
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5745

Limit the number of ID and priority bits supported based on the
hardware capabilities when resetting the vcpu state.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-init.c |  6 +++++-
 arch/arm64/kvm/vgic/vgic-v5.c   | 30 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h      |  1 +
 3 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index bde5544b58b09..cad4e217a9f30 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -394,7 +394,11 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
=20
 static void kvm_vgic_vcpu_reset(struct kvm_vcpu *vcpu)
 {
-	if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
+	const struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
+
+	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+		vgic_v5_reset(vcpu);
+	else if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
 		vgic_v2_reset(vcpu);
 	else
 		vgic_v3_reset(vcpu);
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index f6b0879dd705a..c813f439ac9d2 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -56,6 +56,36 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+void vgic_v5_reset(struct kvm_vcpu *vcpu)
+{
+	u64 idr0;
+
+	idr0 =3D read_sysreg_s(SYS_ICC_IDR0_EL1);
+	switch (FIELD_GET(ICC_IDR0_EL1_ID_BITS, idr0)) {
+	case ICC_IDR0_EL1_ID_BITS_16BITS:
+		vcpu->arch.vgic_cpu.num_id_bits =3D 16;
+		break;
+	case ICC_IDR0_EL1_ID_BITS_24BITS:
+		vcpu->arch.vgic_cpu.num_id_bits =3D 24;
+		break;
+	default:
+		pr_warn("unknown value for id_bits");
+		vcpu->arch.vgic_cpu.num_id_bits =3D 16;
+	}
+
+	switch (FIELD_GET(ICC_IDR0_EL1_PRI_BITS, idr0)) {
+	case ICC_IDR0_EL1_PRI_BITS_4BITS:
+		vcpu->arch.vgic_cpu.num_pri_bits =3D 4;
+		break;
+	case ICC_IDR0_EL1_PRI_BITS_5BITS:
+		vcpu->arch.vgic_cpu.num_pri_bits =3D 5;
+		break;
+	default:
+		pr_warn("unknown value for priority_bits");
+		vcpu->arch.vgic_cpu.num_pri_bits =3D 4;
+	}
+}
+
 int vgic_v5_init(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index c7d7546415cb0..ba155020ea99c 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -364,6 +364,7 @@ void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_get_implemented_ppis(void);
+void vgic_v5_reset(struct kvm_vcpu *vcpu);
 int vgic_v5_init(struct kvm *kvm);
 int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
--=20
2.34.1

