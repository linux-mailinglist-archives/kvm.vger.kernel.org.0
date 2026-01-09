Return-Path: <kvm+bounces-67598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 71713D0B8A2
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:12:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5C1D43121071
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:06:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78B293659F1;
	Fri,  9 Jan 2026 17:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="T3tpDTQa";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="T3tpDTQa"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010032.outbound.protection.outlook.com [52.101.84.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D4031280D
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.32
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978355; cv=fail; b=eFW39ln3Z2//xs/JWEJilaAO0wlk7cOQ2oxsgITFZWoHYSoxV0AR3vWXHfTOZtqzOrkQgVGyk/9JZycXRR/PiX29tO458JwyfYScZatkrj5PEUYrw3hi3JTFQQGsZLrA/1mY45RZf7ldvrw6GYqBbcZKf/cMVPct6T0i5xNQ8Y8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978355; c=relaxed/simple;
	bh=oMJkMP/hVglNoenXrSMpDWyI+E93bFu0ezIppp6HY2M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kDwKaTML4nSF/Flb47yJPFsvae1rvDu78nQwTEv7H32OiLbH8Yc7mM72gYcdzjN/XCuSRXUXVCn3X4miYvdeNb49hkQi5wrPgT77wJPls/X4Um/HJQzs+1RgMvKXmMSJaIoNa6XSduJF0YHiyH2avw3y1Bo/Va1MgNE763e5v9s=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=T3tpDTQa; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=T3tpDTQa; arc=fail smtp.client-ip=52.101.84.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dS0X+JF+RX8NLaB+No8xH+WI1dP6HHPs4q6Id46ucLGwK6/EHHT/Fb0SXiBgJeX0csVNRCh7FwZu5+qtSgWHnDfbRrXP5jDXMf8fLRfNGAk16xxUiREOYR7dz1KtYXUQlQLh0tuiLwQfzp2SBze7BXy0LhLoUcZzaErJp/kfBvdxXB6inhYuzS3rLQUtzZr9oipMxUTYf8lcwvEAvFIDFm3yKZQzzxCmL8DKf9L1KD7DkAkpiK6CrdGCzTBfrP76EV0v2LLPcnlpgY7CaGH4sOsO4EgUx69Nlk5+Tl01b24ulWS5WPvDwb3KFmSUwknrWaepUf5XLkNw0hyHVTqVoA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ubTPUF+F6xwuiXBDvzBxSkKdrC9XCK2JrrMhWmQgQI=;
 b=kXd02TtrzKMzjoR4W0r4/aZlbuHKXZn1fv4S7VNZNgX6ChU5PzQBdAawmAj7+7WO8iasBHs1ORcjTLfgYtSvbERae7NxoIrAPep3sbV1kY9aXXM3ZM6FqJI5lNumtzREKEzFqIfwCyAADEowjflUCnPX4hknR4clnJLXUCTTmjHraqK6u+3I04Fiv2vFDSshIHGThSQQocpbiy+YE3/3PsRGZ4/Y9JolyrnuAjeUvZWQKq/DOS2hzfncmS/Ng6Pxc+ijPugGJnQJnqixW0fuy3iwe0MWnnjNyi6Sju94mhircyQVxpBvb3opbzxohXBkj9L1eP7eCjZL7IMEnJuVQA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ubTPUF+F6xwuiXBDvzBxSkKdrC9XCK2JrrMhWmQgQI=;
 b=T3tpDTQa8KWg+oW30bd1NnhgR1ayxPIxGdo4O50Axr88cwosKnpH2JHff86cHTumKVhQ+yOjhDrhA3Imba2qU667Em4Sh5uUp3SL/HD1AkgGvgyyIUQpo2P2iAJIyHs4aWsv8BdMi3d4r8MmbfoF4W7UGFB3A698ERuUj47QrKw=
Received: from AS4P251CA0010.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:5d2::12)
 by GV2PR08MB8076.eurprd08.prod.outlook.com (2603:10a6:150:7a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Fri, 9 Jan
 2026 17:05:48 +0000
Received: from AM4PEPF00027A5F.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d2:cafe::47) by AS4P251CA0010.outlook.office365.com
 (2603:10a6:20b:5d2::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.4 via Frontend Transport; Fri, 9
 Jan 2026 17:05:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A5F.mail.protection.outlook.com (10.167.16.74) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:05:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hC6HJ4uZ6gSS/0bBz4lVaSR0+8W9jEBwiFzVm9vlHluuoLIdcEFM/kjcUiT4ZU6eRvnZR/b41bWZBrH1qHB/STU6xHfEwS7HOI26C8a8gE2rbxNZsYRkJLii8b9igzFmSNmd+2n4VY73fAeWagA5FNUs3y0qXNGiHOE0O/5E4sDZwRelO6rJ5gD/lQPJjo9AOFUv4C/vI6Nhg45TqiYDMsWRS7HQHlvLtnCtmy5rw1HO3OWeS994vRCrbUDu4v1rifLqLM14EkuLD7vzdRvWzjYEBcVHQ9+fG7bokfPKQqIXQDWz37oh/tsKtR7R2qq5pebvp2XH3qNrpn98Nl0NXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ubTPUF+F6xwuiXBDvzBxSkKdrC9XCK2JrrMhWmQgQI=;
 b=X0B4QUaFF8wJoLFR2M+OqBHv+YihhfhPYl+Rodbn1vYRmQzt+kK7/9R4lEna9/QL/oNE6sQxtUr4pbc06xeU5wcYcStEluYTjzohpnJFepn1IqfhmJFdvG2Y89icxN+juSFPYywBR4ZbBgfR4QxT9P4+qiP43uHcyqL9hDN/8y8ffHMlay2ppb2C/0fcKT9zI3I5QoAX1exTaWNbAmBTAx3SgLrx8YB6u9H1NoLaEYy0hsjRrDHzLP5Sq4Mg6FvnyTp9kBHLHd6+YWz63m30fb0mfc0R6xr84h6cDnQDAlZ19UaNAlYbgQLc9nycsnCAx/HAtrxqQMVNwPfrY2ipAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ubTPUF+F6xwuiXBDvzBxSkKdrC9XCK2JrrMhWmQgQI=;
 b=T3tpDTQa8KWg+oW30bd1NnhgR1ayxPIxGdo4O50Axr88cwosKnpH2JHff86cHTumKVhQ+yOjhDrhA3Imba2qU667Em4Sh5uUp3SL/HD1AkgGvgyyIUQpo2P2iAJIyHs4aWsv8BdMi3d4r8MmbfoF4W7UGFB3A698ERuUj47QrKw=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS8PR08MB6216.eurprd08.prod.outlook.com (2603:10a6:20b:29c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:04:45 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:45 +0000
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
Subject: [PATCH v3 16/36] KVM: arm64: gic-v5: Implement direct injection of
 PPIs
Thread-Topic: [PATCH v3 16/36] KVM: arm64: gic-v5: Implement direct injection
 of PPIs
Thread-Index: AQHcgYoNzywNJdcPk0aC2Bnok26p/g==
Date: Fri, 9 Jan 2026 17:04:44 +0000
Message-ID: <20260109170400.1585048-17-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS8PR08MB6216:EE_|AM4PEPF00027A5F:EE_|GV2PR08MB8076:EE_
X-MS-Office365-Filtering-Correlation-Id: 267fcf5e-28b2-4714-b7d1-08de4fa155c5
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?wnwSkXJJQeuN7wKs+YSzHrNnnPgVrloODQf+NoJ0vpGeZZ2tZh5+K3HzUf?=
 =?iso-8859-1?Q?KqoM+T698gWP7hg3beE1E2CK49ZNDSz0/3rl7TEYAQQI/lLFJKPhXrEtJg?=
 =?iso-8859-1?Q?yKly7kV7cCdec2xWs3KDc2UyrzJd7tUt9cXKc3rnUK0wmkznkdo26ccKmV?=
 =?iso-8859-1?Q?9ZcgycgXbdkD7orFmCKMVp/ZGvamMiij9ElzCf8bMo+aeZ9g0tRf+tfn73?=
 =?iso-8859-1?Q?PimC2B3lpLIIjImQIaKgU/uGqYILs4EIur+4nLuZ8MSi7lMAvBPxQX26+z?=
 =?iso-8859-1?Q?7AQk+94IqsAGjdDDSEMwLreRuNgL6Qj9B7ZVqL0aJY8KGsH2X70VbtaMRv?=
 =?iso-8859-1?Q?Uz4hiM31LcGvKLSpckxWUJ3j+p3WLjWknOi7JBUp2dLDxxt1N5+gSSb0L+?=
 =?iso-8859-1?Q?fIVj4JJdUbC9Y5ruRtlbTy6TsvtVLINyF3HYoxYFyF5OQBVXk1xutKh4jZ?=
 =?iso-8859-1?Q?WBsenPRgbFk5u3kuo91QVhWpBvKY9qME2BEyOl6lqsqPHfZgrv3y6FXQsc?=
 =?iso-8859-1?Q?ytWu86yIABOmnmKKsPv9ydpDqzdESoreK8Om7gXilufhfpErTuunVu9LUA?=
 =?iso-8859-1?Q?yrT+tIysDgUJb3xgqFaN99iCjY/Ts7OfbCMHnWbntHlyAMvxKXyjOI/2U4?=
 =?iso-8859-1?Q?r8+18pbxFlTUcVEBBEZR8IGjQfeYxfguvSSmw4KS0Lh3Xnn8mfCV6OVpqi?=
 =?iso-8859-1?Q?LbIXst3gV0Kb+D+mixDZuVE7I7pywDZdOvWdQkoiYEuJp97hlKXMzGABri?=
 =?iso-8859-1?Q?6KLPE38OVUQsV75rbmEqeouNeqRFp1nBjq6LrwHfgBghXNVHLRM/8cjzgD?=
 =?iso-8859-1?Q?aXoE+dmqEzjc3Fna385xe/LAY/ylwfqnL+xDUIEihAljYzM4tjs8DzRHEZ?=
 =?iso-8859-1?Q?EjIIq8+GrdnCcuSGKBpYT8U/tVccT+80PuJsKmG/SkDHlRZwXl+hhWyTWc?=
 =?iso-8859-1?Q?JqMkN+dPLfyKn5HWEnmZmh2NZf0VpnhKAZUzZbPiL76pGE6DCrQbLB2srJ?=
 =?iso-8859-1?Q?up3eahBRjEUUXVUgW/oAfpIyZYFrWSMeAFtXqUjdQ2TakHnmsLLfKT3KGw?=
 =?iso-8859-1?Q?PLbc5GagLvfKfAiU05hSMwqlOd5OCAij9MGawzQSeg+xNMua+UXnX59Nke?=
 =?iso-8859-1?Q?ZzspcFUaCa+Hyc902Nluz0XbCkMfG9Ptq4qcdBP/Q7lam8u8yhyjOlGOMW?=
 =?iso-8859-1?Q?birykj+fsdUw2NiLVQ1EoVWPQouZysG6MDtNiPNwvcASrljqC277RtnZDG?=
 =?iso-8859-1?Q?PjP4XPMPDclE4KQ50Tp4JJP5O8Lc+MrXyhFz+TfIShGlaVETaAKe7l7ptq?=
 =?iso-8859-1?Q?8mZkSAWmfv7iq7Ob8W59Nk0pwOVfeIN9Bugn2WMKkcaqgxPmBunQ0nD9pW?=
 =?iso-8859-1?Q?26MSxWRBlypLkzzbYbZWTKaIC83englJEFfgBR9PB+FpsLk0j5B4BIYtBA?=
 =?iso-8859-1?Q?iz+5Vix38FHFuHJHmKtJ+dtwSJV/fJKdtSC+sduvscE3ubj9ZPX6mxIpAy?=
 =?iso-8859-1?Q?zY7CHU2zurpuNSsdBNpdqxxGPj6vuVl9/zUrkxOMU4OzjvlDt1c3LFtRVs?=
 =?iso-8859-1?Q?QUUe4eIldoKjheb3Z47mJTjRUz9R?=
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
 AM4PEPF00027A5F.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1f917d03-96ba-4640-f94f-08de4fa13091
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|14060799003|35042699022|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?ygWOZYpYYgVlBsmLcOqXKUVda9dt7FYd9dZB7Z4I6aWZi056yKld/KQwTx?=
 =?iso-8859-1?Q?UmXMzZ9NMB2pKA8dScChL2RXoDhahJIunPex8/DVHcSPY/9jGRc0xVWowP?=
 =?iso-8859-1?Q?/gUJv3djjkkO10ojXsNpozPkc+YtsvyCyreH3a6DA2ObXMVqHZelNgEXPw?=
 =?iso-8859-1?Q?AZykxhpgUppStnUZN0c0923NPhDRtS2vsME9BCh9CzhH6Bs6Zd7qc9y2ll?=
 =?iso-8859-1?Q?wAExNbxZiTjuRAD1rPQ+aHLfzjksR8oaZjm+Avn3lKYetu0XWd1bQcmWbm?=
 =?iso-8859-1?Q?A5c5tmKZfTA0eCGqE8FNqrP05cOx/q8TW1428xVLmIZZD/fhVMu+e+p0vu?=
 =?iso-8859-1?Q?7P3uOlD0JmOxtwxX3e8uUdWfo9eziJoh4gzd3yTgh27eRDMtR3EMgmcrJm?=
 =?iso-8859-1?Q?hN3wAj6nazhQKC5eLXlEHC2EPomf3olRQlIvpKoz03ureOJW+bEP3oT7fT?=
 =?iso-8859-1?Q?ikihczBeKkzg494sD6kqf+tMhxeq9KLIdoqqQ/TUhex7g69AhnGYQKn97Q?=
 =?iso-8859-1?Q?3y03enyC75PJN6NFLVfJJvEOZdr04WtcMk94qHNNvUTxfRAmOhRBgV94HG?=
 =?iso-8859-1?Q?h9yZRdYfYX1+QKXY4oG7+k5TjuM65cD5Z3H9dZuAxHUEGQgmkhkRBTnynB?=
 =?iso-8859-1?Q?B4l5/jng1YwMaWxVm+L3W7inJd0UA9Kz8Y3Wtaf9htofvuLO8t4LmgZJBQ?=
 =?iso-8859-1?Q?btlQBB4WIqFnQH1rtk32bwcnggDcmeEO9n0YPynHsgqGAOw9J2iJdjMI5p?=
 =?iso-8859-1?Q?J+sq7M2afxbg3tDD2RzMHW14TNuL+0bHD7NBzI1iyA0MY7S8oG6/40MNDT?=
 =?iso-8859-1?Q?O2pCpYAioItqpDRgffwjjjL1FR8RbQt7JoYD4Zqp6kyIXlucriD7OOLTS3?=
 =?iso-8859-1?Q?TkG03CHMfg8ngx9RsYEAXFOaYcx25gZiVrXXptums/bBwUfAzXBQcfMVOA?=
 =?iso-8859-1?Q?6H3WkuTcIt/mSs1JZe5nRCwqRxkMR5i+o8N+QVmPgOVkXIO4YmjNLkA12H?=
 =?iso-8859-1?Q?gMBUd4p7P9/HKxpVVpkYKG23gzt6MpvdfFrRuxbLynnGPoa8AXK2M3Zbvm?=
 =?iso-8859-1?Q?TjAWhj07p97Dfo4GEzcezBPBeyGabzdj45tOPD574usS+BBtqgckl2+87S?=
 =?iso-8859-1?Q?yslPqLRsI5wOx+1LottzN521qkxyp6llHZzGnhCeF/nwaZyr/FZtL4j0i5?=
 =?iso-8859-1?Q?uXyU38FKjUPruR63UOKzDMToSk6WzS+TqwzsOFpbMHiws2lNq0cSMzToHh?=
 =?iso-8859-1?Q?1cOqY20Y4j8YQgVoV7L/N/lEMOLrix0HA8GGY6kERJzaniKWSkRa6TZB2E?=
 =?iso-8859-1?Q?DIPxlDjxdQkbnPRNi9yWJthOMWI2HFNz9wL/txb5heL5NysOmlNo9XTRtZ?=
 =?iso-8859-1?Q?saujk3wqtyVyAI28aeVVozSLYO8ZIVtNyK9lxZ8Xhj3OVMiOg43Ijwc7QQ?=
 =?iso-8859-1?Q?q54gBe/3LvaA6QjiFjxmMS3L9kMo0q88klXdV27EwO1+FKfke1mPkEtaxP?=
 =?iso-8859-1?Q?8JlLL/6JjwFcaLdSy8rtdbqenSmjvDtS4qgBgWXcXGe0upDiiKYsAMqDGM?=
 =?iso-8859-1?Q?w2JwhKA/k8XMuXHNgvMARh/KOi8+exoA7CL5uKoSX2emyocKfPOUjxKOzK?=
 =?iso-8859-1?Q?hooqyxywqX+Jg=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(14060799003)(35042699022)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:47.9621
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 267fcf5e-28b2-4714-b7d1-08de4fa155c5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A5F.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8076

GICv5 is able to directly inject PPI pending state into a guest using
a mechanism called DVI whereby the pending bit for a paticular PPI is
driven directly by the physically-connected hardware. This mechanism
itself doesn't allow for any ID translation, so the host interrupt is
directly mapped into a guest with the same interrupt ID.

When mapping a virtual interrupt to a physical interrupt via
kvm_vgic_map_irq for a GICv5 guest, check if the interrupt itself is a
PPI or not. If it is, and the host's interrupt ID matches that used
for the guest DVI is enabled, and the interrupt itself is marked as
directly_injected.

When the interrupt is unmapped again, this process is reversed, and
DVI is disabled for the interrupt again.

Note: the expectation is that a directly injected PPI is disabled on
the host while the guest state is loaded. The reason is that although
DVI is enabled to drive the guest's pending state directly, the host
pending state also remains driven. In order to avoid the same PPI
firing on both the host and the guest, the host's interrupt must be
disabled (masked). This is left up to the code that owns the device
generating the PPI as this needs to be handled on a per-VM basis. One
VM might use DVI, while another might not, in which case the physical
PPI should be enabled for the latter.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 15 +++++++++++++++
 arch/arm64/kvm/vgic/vgic.c    | 10 ++++++++++
 arch/arm64/kvm/vgic/vgic.h    |  1 +
 include/kvm/arm_vgic.h        |  1 +
 4 files changed, 27 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index d09b8992345eb..68cf60fc7aa0c 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -90,6 +90,21 @@ void vgic_v5_get_implemented_ppis(void)
 		ppi_caps->impl_ppi_mask[0] |=3D BIT_ULL(GICV5_ARCH_PPI_PMUIRQ);
 }
=20
+/*
+ * Sets/clears the corresponding bit in the ICH_PPI_DVIR register.
+ */
+int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u32 ppi =3D FIELD_GET(GICV5_HWIRQ_ID, irq);
+	unsigned long *p;
+
+	p =3D (unsigned long *)&cpu_if->vgic_ppi_dvir[ppi / 64];
+	__assign_bit(ppi % 64, p, dvi);
+
+	return 0;
+}
+
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 1005ff5f36235..62e58fdf611d3 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -577,12 +577,22 @@ static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, st=
ruct vgic_irq *irq,
 	irq->host_irq =3D host_irq;
 	irq->hwintid =3D data->hwirq;
 	irq->ops =3D ops;
+
+	if (vgic_is_v5(vcpu->kvm) &&
+	    __irq_is_ppi(KVM_DEV_TYPE_ARM_VGIC_V5, irq->intid))
+		irq->directly_injected =3D !vgic_v5_set_ppi_dvi(vcpu, irq->hwintid,
+							      true);
+
 	return 0;
 }
=20
 /* @irq->irq_lock must be held */
 static inline void kvm_vgic_unmap_irq(struct vgic_irq *irq)
 {
+	if (irq->directly_injected && vgic_is_v5(irq->target_vcpu->kvm))
+		WARN_ON(vgic_v5_set_ppi_dvi(irq->target_vcpu, irq->hwintid, false));
+
+	irq->directly_injected =3D false;
 	irq->hw =3D false;
 	irq->hwintid =3D 0;
 	irq->ops =3D NULL;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 9905317c9d49d..d5d9264f0a1e9 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -364,6 +364,7 @@ void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_get_implemented_ppis(void);
+int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi);
 void vgic_v5_load(struct kvm_vcpu *vcpu);
 void vgic_v5_put(struct kvm_vcpu *vcpu);
 void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 872c278bc7319..f3281bbf98454 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -219,6 +219,7 @@ struct vgic_irq {
 	bool enabled:1;
 	bool active:1;
 	bool hw:1;			/* Tied to HW IRQ */
+	bool directly_injected:1;	/* A directly injected HW IRQ */
 	bool on_lr:1;			/* Present in a CPU LR */
 	refcount_t refcount;		/* Used for LPIs */
 	u32 hwintid;			/* HW INTID number */
--=20
2.34.1

