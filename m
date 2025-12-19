Return-Path: <kvm+bounces-66378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C0DD0CD0BFE
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:09:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 90EF73047B75
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:06:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88CA03624B3;
	Fri, 19 Dec 2025 15:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ME0u435A";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ME0u435A"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011055.outbound.protection.outlook.com [40.107.130.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5A9361DC3
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.55
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159666; cv=fail; b=MqtL1UwlxHT15Wl82Y9h0mZQImlz6Gi1xjtQo4NCYihegiyJKrVUj/UOpUHuW//Cb3jBZcRECszkgwkdHEnAIfcU/qGN8DIHPMUsjzrKWHc7An3RkBkuw5wGbU0GGxbxg2tF0n1mpAPQiylqf1Xj/fh5qxImqCv5hzaNOf6c6iM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159666; c=relaxed/simple;
	bh=yje4Xqo2LIpABEaqRhkj8gjIdQeHw84CVN+bP5MAxac=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bNVzLjZuGyKnRG9dx3RAed3lgHVZWj+Eq9mSbpuHiLDvu1KzS0/tCd+pzNLsp/mqjW8sOlPFl9jniCy/mlSy2ayw2T3jhJn+MXInwkryp6IwL74axhImATeuZx2DVpXwxYKP/lbR4yDsDcC5jUyJUoASXEJLjKhYTa0jG6tPBEU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=fail smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ME0u435A; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ME0u435A; arc=fail smtp.client-ip=40.107.130.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=zNi1jeMbIl1XGBgk4egYJxbeXuQu7d394Qa33DVEyjBCjqTdJZcpN+BMul0GvMUlQ+2XbBfB5qMM1geo6Dquc6ZokiatnpLV1SSfoKoobKLkn2lapmkHTgTeIP3eoXAUgVsGQ55j1RXZ4TjJxak1IigwI+SupzLYH3TKSpHPcQEgvw2sS4HB8id8dbIDIl3fPlw475pV7lzsrHHNaEGoh8GXX52Nu2hMPz+Zr0xhgEemaYeEQyocOWh2VmQwrskN/b/XHEp18tCmc7YShG106jE8iWxnB+aVYgfe4oMRgAG/BqjE7sthPmm6QAJrQCzwmqcntpn1feQEw2v8b3bFXQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5nUFC3HMVj/TXBzRnG1zY91osse0vV7EGPJjQAlgK+o=;
 b=J30jVzNHA0oqeI9k8e3mDvJjhcnVFNWslZfAG8IvRRZz8IIsh7M19NQV+p2D9zbUfSL35sfEA1UsVWfnmE5n5x8DWOO/vCemOgyojTL6ZrakZZM21SestbuK+9kbcjSHAj+9Xq8onWRu7JEbDWBU24enGop4YNFOvy3PCE795HmKmTZM9zWDthMGX0PsDH1WozzeJZll6yr3z8ZRGBp4zQg/htqKx92IP2bAkIZo4epdqqwBunMUZ4oQjhokkLgP1Z1HO5hslyjnOw2k+Dm8arwoBaNCbUpozCd0TXFXjYlnftS0E3/vJp9WV8H5/32rle9qqZJmblUc1ZlXTpdRNg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5nUFC3HMVj/TXBzRnG1zY91osse0vV7EGPJjQAlgK+o=;
 b=ME0u435AV9mO9gH73Tb5GGz6ym0PgzbDH5CtkL+w57Rm8bp5x+sYL8EXxkwOQgTdm37cKsgn5MXQvgOXRN0IzzXFQPXb8cAYZs4E2B0Svk3TGWnfYa5GAkw76KJ0INurItQ0vONnyad7mJhZQwybOxrW5UoM+L0u4dpkvxq+rSQ=
Received: from AS9PR06CA0601.eurprd06.prod.outlook.com (2603:10a6:20b:46e::24)
 by DB9PR08MB6634.eurprd08.prod.outlook.com (2603:10a6:10:23f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:54:20 +0000
Received: from AM3PEPF0000A79B.eurprd04.prod.outlook.com
 (2603:10a6:20b:46e:cafe::71) by AS9PR06CA0601.outlook.office365.com
 (2603:10a6:20b:46e::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.9 via Frontend Transport; Fri,
 19 Dec 2025 15:54:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A79B.mail.protection.outlook.com (10.167.16.106) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:54:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kon01RHit6B3y27yHyhuCmz0CV1KaLksBSDT0xebMFO55i//nZz7VniMN/ZYEKzdlvW0O0976xJm7qDV5nfSoPB1Bs9IuJMrJ9y+6TyY1/rL7VyiEBdgUOdrF9Uafv5OkHzVwDxxboc9QkeRZX7CAskYfovu9KtvF9K8d3/YEZpbjWvmAuV3ESLq4HntssXm3/OUtSWmHoVY02iM64jEJnmn7pQUvVd0K1PLJvWF/Ru8BizqgG/hqr+TZPI6nZBUt6k05fmaTa+MHQW9qv/jRx1b7LndyZAmXj+cE/mh8MguNwf7O7gDi3ccv3qrn/3aJb2M1Hnj0nhLXFwQCONdIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5nUFC3HMVj/TXBzRnG1zY91osse0vV7EGPJjQAlgK+o=;
 b=OwFNMnMbPdR+IOuJpojqeAVQkuA/UYdhTIJz3lQJeaJ1RLQQWg076g3SP6Jbz5Bj9gypJF0wScI4k3Du0/IP+0ud4BvijMgXsx3soGigQqeHaiWvfCpYs4XqQozYmf1GMdPdmp6TWvXTOz01tiRThYqjIif3F3iOyo3hXvVPh59psEQIEx0Mg8oQju3utaqjv5eG/I5oUqMBHLAWX3SsL87ZzKOPYHcl9M4eAlohrCRovIMAPMDCy06NOWK5Miq7coKlHbP2KtGPo2Zl0qV8/FbBZzPhsMczJhp0y41bGv0NfBZcSm21mOoPKysFgYAWRNBEofxJthU6brinDuTuaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5nUFC3HMVj/TXBzRnG1zY91osse0vV7EGPJjQAlgK+o=;
 b=ME0u435AV9mO9gH73Tb5GGz6ym0PgzbDH5CtkL+w57Rm8bp5x+sYL8EXxkwOQgTdm37cKsgn5MXQvgOXRN0IzzXFQPXb8cAYZs4E2B0Svk3TGWnfYa5GAkw76KJ0INurItQ0vONnyad7mJhZQwybOxrW5UoM+L0u4dpkvxq+rSQ=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AM8PR08MB6515.eurprd08.prod.outlook.com (2603:10a6:20b:369::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:53:18 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:53:18 +0000
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
Subject: [PATCH v2 32/36] irqchip/gic-v5: Check if impl is virt capable
Thread-Topic: [PATCH v2 32/36] irqchip/gic-v5: Check if impl is virt capable
Thread-Index: AQHccP+F6Ffsy7PexU6W+br8YgyHUA==
Date: Fri, 19 Dec 2025 15:52:47 +0000
Message-ID: <20251219155222.1383109-33-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|AM8PR08MB6515:EE_|AM3PEPF0000A79B:EE_|DB9PR08MB6634:EE_
X-MS-Office365-Filtering-Correlation-Id: 8128535d-913b-4e27-0f1c-08de3f16df8a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?mPV2pWpqpv5hX8JT3IPBqkajET4g0QdBCDIxR0z1xVYqVp0U0rG+YmOScm?=
 =?iso-8859-1?Q?DC6EGS2Jvw8+E+vZjwrw4ZDtQdIWkwduMxwYQzQ0hgDCHenzMV5WcVhFZl?=
 =?iso-8859-1?Q?dnb3jrcMniDOT4K99tnQB7wAlhRrXzgZgm4gz6C76uo7tLaGB8Q3spCEc8?=
 =?iso-8859-1?Q?1sHKH12s0z0S7e6FNJQhzbYP4nOYHdoJIHkq0zNaQfq8jbIYb+NIRvFmlg?=
 =?iso-8859-1?Q?8UUAixTfXvw4oh1UjHJo55hbrKMg2uoAJtxaOujN+ufz+ViTMx7I7iZ5TI?=
 =?iso-8859-1?Q?MPlvzv3Ln0nE7FbGghBrhxyY6qJWAqf+UIRJc8mEYNQ8iIickitXfkdluk?=
 =?iso-8859-1?Q?JyeQz9sW3/QD6dBj+n4xrlxis5AWC5Dg/MY/kBMC6k5F+OoUN0bqASD+e6?=
 =?iso-8859-1?Q?Mko87OIVIbdW1Jk/hzo9l6RFT+TlhKiEicDCqr0ZD1/mMhLjKNLqLNbdqp?=
 =?iso-8859-1?Q?EJokpCKWZc/zefUzfVezk6ZQ1sSuI4yHtmrRPfjMhNZ+u1h4fZVMBOmSUx?=
 =?iso-8859-1?Q?pEC9zqyxjG2BCH/jlhfPpHizv3Io0cW2ZVcf9WhwfoKtB3FARRZ5tKzTh+?=
 =?iso-8859-1?Q?/CoEEbrBwnH+cQ0aZDcLGNa21g27Lqy1f+XlDwyMLZXuckhEuYXMg6xDoK?=
 =?iso-8859-1?Q?prMxrdnIosiyrgrGEWnAiBH7VNpeOOo/OmbnMdYOeXk3hbP+wuk2zV/RJm?=
 =?iso-8859-1?Q?eYp7zCHRL1EO1E8m+re5S3JsWzw2YFVw3Dl3PaWMdU1vq4/1WUXhkLaEhK?=
 =?iso-8859-1?Q?sFSdA3uflNmxI2HG8BiCiDX0M7IQJFb1c0QnZWkSzCxYECOR5+6AiUMwpI?=
 =?iso-8859-1?Q?bIl9bNZp9seryatjo2FOvD9HFZUXIhDq+oTaM2oMN8Z9L9hdBspl6gqOaB?=
 =?iso-8859-1?Q?4koTQjRgq0ydvLuJvyfEDOTdcvVUMu9slEgJbYSDymwECu3HBvW7sMZ5OY?=
 =?iso-8859-1?Q?XPmn5DZDMP3XQ+664iOqwnIsgzm6LspdSS+3kPNRsZwUJXsmO/SxqGXx49?=
 =?iso-8859-1?Q?4KqPGhMB+OMvne/9WNxeA/oIZA8ZONefg4T9uxkl0gX9iO6EaPl3LPz1I/?=
 =?iso-8859-1?Q?kz3xmFXd+pkWUJRwAd4z1jRaUyS4wOZFwqUTq6fr9kSTIUA4PTNApbSOBf?=
 =?iso-8859-1?Q?RTfL5/eo5bG+7JyhxP7jv0rpvB7jZNo5L2Yp4ZDRHN8whW9lmfouyYkfQ5?=
 =?iso-8859-1?Q?uvY/dtZTeB6KHC3JW3hGqj/eqk6PNcpRxfhhxlFLgupmzC6VARm0PVx8H9?=
 =?iso-8859-1?Q?w1dr0ELq2vOntvrOdp0BQTx/nbdM7R8G2zZOfg/EYp9c8bgmoLm0k6TcPO?=
 =?iso-8859-1?Q?e4Zva4+ntuJLeFC+8f+pKa1LC+uJM6slthr6KGw2trr4D4hpa2tjvPT/AF?=
 =?iso-8859-1?Q?PZIfjxFW9KHydL3UNVden2YjO544ml/GNkC+Umk0e9AbNeTEA5oPH+Qmft?=
 =?iso-8859-1?Q?XEFhTAoCeUtKdrMtDTEgnw5Mi9fDlNP2zgQb1vO5DwuSCBaSpwxEzRa7oi?=
 =?iso-8859-1?Q?WTzojLaRLprtUVQzgAVVYRtjSU3rC6+wlhoemzjO9ln2Kh4YmeTMx6H/ug?=
 =?iso-8859-1?Q?MnL4+p8fcldEJePZRgBgxG1u1ryT?=
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
 AM3PEPF0000A79B.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	729163ee-db7d-4ae8-deb9-08de3f16ba74
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?a8/91hBzfyECIzLtPTQM11NEPHfAZEmqYwKaBjFIISUWFn/Q46JorGXMcg?=
 =?iso-8859-1?Q?NNgbQ7yKHGAlXU0POwsBVMnPuoqRTjFdiEjqDM8UnZ0RB1xL1Lqzk+qc1l?=
 =?iso-8859-1?Q?4sBbTl/1qj3T4qPdFEMY3jZux6Tgh8FSCglAfi7K4XMznyyOHXTlVXJAX7?=
 =?iso-8859-1?Q?qP1+RqDTwwtEK8QCCnGDRq5vA0apn108cK9e9/iYa7B+v8nw286oTAlk+j?=
 =?iso-8859-1?Q?plPhUhEdLbkLzqTMhgsZg4zF65XCoowELOzl8kTioAg50//NMt66r3RNSA?=
 =?iso-8859-1?Q?0AZGD7lWhsgZbImgsILDo5gKFsdxO0ZiWNM0eTDrXzXL/0KBa/+do6PkXb?=
 =?iso-8859-1?Q?VvK3vr0QJGUW3ueLtzMgtX8ZNs+r3kWvOO6A69JUYKz06dzdUdcqG0X8xj?=
 =?iso-8859-1?Q?PP/71FLb4OBO/+fCB5RxGG8OvBskyhuRruRO+ssfRYQpyP1nUFlIR0e3xl?=
 =?iso-8859-1?Q?CZh1GAd/VOqQNFiS8Lkx1/sPNKOETgDBG01e1J8KC8uSLagzKUWRsz3nLs?=
 =?iso-8859-1?Q?Ehe0eop26ngIxcieRdjAdF9CoAVpHNhq7WYWPwsbMuKJ89vRj3k1Q5UAh8?=
 =?iso-8859-1?Q?TFtI8/PgGconC2gTUHKYgmyqSsEfxluLZYzOV7AWtqG74o+EjFS+Z7xFB+?=
 =?iso-8859-1?Q?uSE8l7bvuQQPx/XyIG23kUvSNtdDyNLdkPjdrNUz1bqWhp3W95DFzE6D1e?=
 =?iso-8859-1?Q?2KnUWZfnodmjm0mxZl5VLVr/I9VK8FVhgRqwPqzcSqJ0gTHF2ypsVybdJ1?=
 =?iso-8859-1?Q?ZIP1/sfNCltvKHA1UJ40PHZdCkzEmEPXzPsn9SzHeRu0Xg/EDYSrwuOMqV?=
 =?iso-8859-1?Q?OIWlcot+M272wFX4vvamOGcIhADnYcvxv4awhFJWceaedXTfd0KKSbFGjm?=
 =?iso-8859-1?Q?Tv0QtRzS4ggho0KPgC67xDItumVK+7kcAxbkso1RTNmEyxd6SiHMTLZPG0?=
 =?iso-8859-1?Q?zDcbb1sC4a86TSqdb4qnPuvfaETwXDMYMq2nKcQPHHs0FHG1fSucuxGZVZ?=
 =?iso-8859-1?Q?cO4NJqTVnTzx/F24rH0rc6qnOjX4nG65DFPfWip4QTDe+/su07Z4Gt8qVc?=
 =?iso-8859-1?Q?eLsmQGyHm0iMoHPdXI7XkfE+KNz5pE8zmsDXMFi0AGQbuCE3BLmQjc/4/5?=
 =?iso-8859-1?Q?8LckNQ4EAhqAbBO+kpGDqwYMX72xI83KUpG2rdpijSJ0Ag+IqWJGgrKH+k?=
 =?iso-8859-1?Q?UNwPGWCPdKg61BzfSD4oKtUzgZ+5GnmqlmsQR6/S+mAfnEEPoAqH5HarID?=
 =?iso-8859-1?Q?rg1tmI0iybRW+vqdVnehu4yWndslI1/yPweB+hyED657SSaDyr7hsqEEoK?=
 =?iso-8859-1?Q?Cb6EfdDX20sECc+g2jQUKw2n3wVCn7VGOw0CJimtW+OJ7j04pfZ+JxvCR7?=
 =?iso-8859-1?Q?c4hAB1qutbTtRE4cEdsCEuBZtUPS/e12AN70oA/rwoiMknuGmR93Y7X4hJ?=
 =?iso-8859-1?Q?CAqrgaNe97sE+9X82XgzIDhoEJbhMiAzb8PB/iHB0UnygFdOEc0+erfcw4?=
 =?iso-8859-1?Q?d5tH9fhf+TaLjfBkBk/V/qOELDzChH3pvtzhhyH9nMDuKzxcEx1U+ahpiz?=
 =?iso-8859-1?Q?T84fTzI2V1q4wOopsLVSHKeZhRVDHHLKxizXIdNytBw3di0TS010GHiyGN?=
 =?iso-8859-1?Q?RlS4xrCC8HUNE=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:54:20.4444
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8128535d-913b-4e27-0f1c-08de3f16df8a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A79B.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6634

Now that there is support for creating a GICv5-based guest with KVM,
check that the hardware itself supports virtualisation, skipping the
setting of struct gic_kvm_info if not.

Note: If native GICv5 virt is not supported, then nor is
FEAT_GCIE_LEGACY, so we are able to skip altogether.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
---
 drivers/irqchip/irq-gic-v5-irs.c   |  4 ++++
 drivers/irqchip/irq-gic-v5.c       | 10 ++++++++++
 include/linux/irqchip/arm-gic-v5.h |  4 ++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-=
irs.c
index ce2732d649a3e..eebf9f219ac8c 100644
--- a/drivers/irqchip/irq-gic-v5-irs.c
+++ b/drivers/irqchip/irq-gic-v5-irs.c
@@ -744,6 +744,10 @@ static int __init gicv5_irs_init(struct device_node *n=
ode)
 	 */
 	if (list_empty(&irs_nodes)) {
=20
+		idr =3D irs_readl_relaxed(irs_data, GICV5_IRS_IDR0);
+		gicv5_global_data.virt_capable =3D
+			!!FIELD_GET(GICV5_IRS_IDR0_VIRT, idr);
+
 		idr =3D irs_readl_relaxed(irs_data, GICV5_IRS_IDR1);
 		irs_setup_pri_bits(idr);
=20
diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index 41ef286c4d781..3c86bbc057615 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -1064,6 +1064,16 @@ static struct gic_kvm_info gic_v5_kvm_info __initdat=
a;
=20
 static void __init gic_of_setup_kvm_info(struct device_node *node)
 {
+	/*
+	 * If we don't have native GICv5 virtualisation support, then
+	 * we also don't have FEAT_GCIE_LEGACY - the architecture
+	 * forbids this combination.
+	 */
+	if (!gicv5_global_data.virt_capable) {
+		pr_info("GIC implementation is not virtualization capable\n");
+		return;
+	}
+
 	gic_v5_kvm_info.type =3D GIC_V5;
=20
 	/* GIC Virtual CPU interface maintenance interrupt */
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 2ab7ec718aaea..06ebb2a1cfb1d 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -45,6 +45,7 @@
 /*
  * IRS registers and tables structures
  */
+#define GICV5_IRS_IDR0			0x0000
 #define GICV5_IRS_IDR1			0x0004
 #define GICV5_IRS_IDR2			0x0008
 #define GICV5_IRS_IDR5			0x0014
@@ -65,6 +66,8 @@
 #define GICV5_IRS_IST_STATUSR		0x0194
 #define GICV5_IRS_MAP_L2_ISTR		0x01c0
=20
+#define GICV5_IRS_IDR0_VIRT		BIT(6)
+
 #define GICV5_IRS_IDR1_PRIORITY_BITS	GENMASK(22, 20)
 #define GICV5_IRS_IDR1_IAFFID_BITS	GENMASK(19, 16)
=20
@@ -280,6 +283,7 @@ struct gicv5_chip_data {
 	u8			cpuif_pri_bits;
 	u8			cpuif_id_bits;
 	u8			irs_pri_bits;
+	bool			virt_capable;
 	struct {
 		__le64 *l1ist_addr;
 		u32 l2_size;
--=20
2.34.1

