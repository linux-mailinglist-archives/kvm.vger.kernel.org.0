Return-Path: <kvm+bounces-54443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 76BB2B21672
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 22:31:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 796ED7A3350
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 20:29:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2A132DBF5D;
	Mon, 11 Aug 2025 20:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="p+VpV416"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC522139CE;
	Mon, 11 Aug 2025 20:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754944246; cv=fail; b=HarcRjLT0TDgJ6GmnN+4Ne2y1ZMIGc8SX7mhdyGmXqYKjeLegXAJnerhYydlFVE1n+qmWJZ0w0C7FKDfVo6DHwRdb3z4Wb39KRiZamLpuaVYhe7Ih7Ei4v6cN9+VhbB7E9TbzuCHZslenSdNrlxg3oQ0qIq9vQ+yaH02kdjdWpk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754944246; c=relaxed/simple;
	bh=3CsPy640ASAkacaWz6SLRFW6B047OwYZJWo2LzKq3fI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hJzR4UyrQKEbEUmlFwotD9Ncf27mD1tbwLlKj33OvCYawTF4qBLwZZefIqQaieHJGIoieleQ4hFym2Nk898wR+N1Pb2ZozmUWHkH4+wck3FLgTls2PV3pc+qpLvZWCpszcx6hjIRtPN+kWH6nd9Oqf54WPt/3lidIg68XKBBhgE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=p+VpV416; arc=fail smtp.client-ip=40.107.93.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fz3BVprCU79a+CIFAwTqBmIJTM1RjAPVX2aRHnZS2L3sscyeWeP/Mwfviqf417e8QrAIRrc19ymAnLxPdNrG/V9EEDbV5p5mO15bK9pzpipt0R3kDldTc3wBRtOMmO2qZQe/6dBgfiR/e9eWCiQQeL76ticq00EYpkOSNdGHdl0euGOpyTzIKCtwrnLPUgxZNwsnWBE2LvvCDkoa60L6vIzH7SouelS1zO3pda/8dG2mprMAQvfCVMs+W0xKMSHlKESXbpJFBAKXhxjWZ8P3djWpDNtL95ZLci3l5Dv2KPXtpAjUNdlaq31DB9sczQVSQ2VvUd6TUKNseMJC8kXlHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3CsPy640ASAkacaWz6SLRFW6B047OwYZJWo2LzKq3fI=;
 b=g49diJN/lM3ZfljbczMmAUlbLfRAyFLCrq5EjTEYXjb7LjVd1FxF+kwyv/88+OmHHGcWWbHI2YC5prwO0xvBWjSE/ZSg1ILyPAlaPtZyiL7QFYZ73GCMZnmDx4LpBf0WNnGsxR54Q0v0v424cGieG2ausMq+ksStNEzAs2qm3uIpuLPzdFy9VYeFj8CMsb2Pkvk4sBKh5ks5v+xDbK7GuKv+Mjtlo+u404TGGYQjwzNOoLywnlo9CEeBGlftrPrUdTeoC5QuUg58HiAFqxekQuWHkE7krPgAoak7O3De1b5PydqrNf2AQNk1H6oL0CJV16tZLPnXM1Y0s+Ede1aUZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3CsPy640ASAkacaWz6SLRFW6B047OwYZJWo2LzKq3fI=;
 b=p+VpV416I41oBboylVBnJ/wNcXgQjbPt/thcn2ZU5IWMRIGPTBdUKK4ZhnHP/KR/nEWgIGeMQAmnmmWBqPCOsZLr3X3GiVFi57eyZnVlZgX6XgaMdsA20xFciGlZ7prjPRxSMlK1Ls52RYtKDmhzK+wA2eA2GkK5cdC+DY2kqNU=
Received: from DM6PR07CA0128.namprd07.prod.outlook.com (2603:10b6:5:330::20)
 by DS0PR12MB7748.namprd12.prod.outlook.com (2603:10b6:8:130::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 20:30:40 +0000
Received: from DS3PEPF000099D7.namprd04.prod.outlook.com
 (2603:10b6:5:330:cafe::c0) by DM6PR07CA0128.outlook.office365.com
 (2603:10b6:5:330::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.21 via Frontend Transport; Mon,
 11 Aug 2025 20:30:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D7.mail.protection.outlook.com (10.167.17.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Mon, 11 Aug 2025 20:30:40 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Aug
 2025 15:30:37 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <ashish.kalra@amd.com>
CC: <Neeraj.Upadhyay@amd.com>, <aik@amd.com>, <akpm@linux-foundation.org>,
	<ardb@kernel.org>, <arnd@arndb.de>, <bp@alien8.de>, <corbet@lwn.net>,
	<dave.hansen@linux.intel.com>, <davem@davemloft.net>,
	<herbert@gondor.apana.org.au>, <hpa@zytor.com>, <john.allen@amd.com>,
	<kvm@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<michael.roth@amd.com>, <mingo@redhat.com>, <nikunj@amd.com>,
	<paulmck@kernel.org>, <pbonzini@redhat.com>, <rostedt@goodmis.org>,
	<seanjc@google.com>, <tglx@linutronix.de>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>
Subject: Re: [PATCH v7 0/7] Add SEV-SNP CipherTextHiding feature support
Date: Mon, 11 Aug 2025 20:30:25 +0000
Message-ID: <20250811203025.25121-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1752869333.git.ashish.kalra@amd.com>
References: <cover.1752869333.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D7:EE_|DS0PR12MB7748:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dbd255d-5579-4056-52fd-08ddd915f03f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nqtp3JzIVZbww92kty7BPcNcCOlJbCFaGeF5fc/G1+8HJRVheNjZfURhrEwW?=
 =?us-ascii?Q?rAUQl1qZA0UnfsXLxonXtKT2plnVO5tvCDwfvgl76DFgVZCs3cXLrlap7jaY?=
 =?us-ascii?Q?Qm/tRODZzK6DVx0WY+mtKt7HTfKhwUdMk3fTsMHZLcKkFbwQc9CB4PTZduTZ?=
 =?us-ascii?Q?eRoA9Zn47cporbqiys4769DwzGwBdnJNRgCYhYYHA+cGfHd35UrD9mMdUPUg?=
 =?us-ascii?Q?XMOfvz0BTV1ERqkeyL7zpuKlz8ffOm7bdIfIR73Mpb0R+xAyFcLK2l9CB6vi?=
 =?us-ascii?Q?pMwnbyaCF5LDl/pbn6vNMOmp6t8EcZYOqMrunaNYiURfhTcJTjlcqTKb1HMi?=
 =?us-ascii?Q?wbE44UNN27Pr3h+AuZGYnKK66o2fHqCRSiR88Dym0i3UKUERJPcWzb3CT8TZ?=
 =?us-ascii?Q?BzJEyyQ/QWoHJofP19pWDQR20dGxCg85K4iA/kn3tx7j+FWSv8nppnNv6L+n?=
 =?us-ascii?Q?TceOWmWRz64YuVFMshRJ2KK5ArYlZYhWV8hOVxz4fmJGO6OizfF5Dm+4xIkE?=
 =?us-ascii?Q?ly8gpXuHwqCz8HNJcUAQ5QcaGFtgdBpBYB9aYMPxMXAs80WxTovsaXwJJ8DO?=
 =?us-ascii?Q?sQ6dYasNmPkM5DiU/Z0lxwnLzy6ou5KdIc1sJx45WUMJBvGyrEHztLZzX4CF?=
 =?us-ascii?Q?oPCZZW1LxYHf+wi1LeWUfJxKNzawlMrpLAqq+/xgBqQooMlxdKXKZCD0nzid?=
 =?us-ascii?Q?1wsPHyzzas3nak3wm1HoEDKNYKUVqdl+x5UJSwM8eJ2s4Cr+wfb6md3Vwnry?=
 =?us-ascii?Q?Dov8mw72ItGhsLc9/SDTnsnPOf5L/lQH5iVhEQGTWWhjwJtavx/K7Q//LBlE?=
 =?us-ascii?Q?7QjKInEqMbNJwuLpva6MAmIPTAhldww/MhOm2Z8m5l5eon1jcqjugb1IeCWh?=
 =?us-ascii?Q?osiqvA3DvZ6bXrTbwmfwP/kSWHAMSLCBbPBoBnsTU7hGVZqlxyZVOyxyJeab?=
 =?us-ascii?Q?jBRgRfPTKvbjMD4f4UMkpNM3tp+KQhe8f96GgrFJ1WchIc2Qb/f+6oCNXcC7?=
 =?us-ascii?Q?XVqKgbWyEM2MA0HbyH3p9oH5L6Y1X5htYYd05Z7u3oVPu/xwv1t6YqNvLcTt?=
 =?us-ascii?Q?Ytt6sUnVTZVjpGhVqcWa1mkedkQIwsJIgFNvD8MPv3RoeDIGu4xbq6ZzZd6a?=
 =?us-ascii?Q?78eB+iQnAxsWwnlHAzJQxJZP3RV/uOwa/IHqOoMshHlca6fmtKwUbE2byGpn?=
 =?us-ascii?Q?ujm9O4iZFeDI8lbE8Pkg1N+6EhbgNNvmLzJWSAad07h0TsehMZbTVhQu7X1Y?=
 =?us-ascii?Q?MOQ/t57xFtFdc+cUgV7HOCw8rxDe6NDzejpZ3oFJ1teDzL1qYibZO13mzdtT?=
 =?us-ascii?Q?4bkmKGL7SKNA2NsMTjSdlWYU42QZSXa6mTir9oiVQ5Jkc1cev9qSTFKle6XY?=
 =?us-ascii?Q?uy4EUZbRSymBhd0C0RWxUKrdWbyQ31LzcTHRs0pg7nDPHKhgfyrIdFLNrGli?=
 =?us-ascii?Q?HWQ2qOJsjbTMfEBGeT4rPJuiisqVoCIx+hBA9ZAhRHsQAO4zjKwtQ+7JYzza?=
 =?us-ascii?Q?ZRs6D/tYqYAEx+QPju0O9GST5iZxEh0nw2IM?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 20:30:40.3890
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dbd255d-5579-4056-52fd-08ddd915f03f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7748

Hi Herbert, can you please merge patches 1-5.

Paolo/Sean/Herbert, i don't know how do you want handle cross-tree merging
for patches 6 & 7.

Thanks,
Ashish

