Return-Path: <kvm+bounces-19496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EEA58905BBC
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 21:12:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F14D71C23CDF
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 19:12:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94A9F8287D;
	Wed, 12 Jun 2024 19:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="S0BmO7yK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF271EB2A
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 19:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718219556; cv=fail; b=e9VX8ZvqtIxiuq17YOHfpnvMv9zaElUOqbgfD8NHtrIIY2h8Jx2swKc9TA2Pnir21ej0vBmlMrv2vtNe8OShbDd6f8BJ2O8tKmN/aGsSSkJp/hg7PlB0qR3IwkgY1hcbuL68V+bVXDpDcjYFGTnPd8/wGvHUnsEKApiC8lhJml8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718219556; c=relaxed/simple;
	bh=K40jHR9CGRckxLH9C9JooslhtAhvivYyTGSvBhbfnkQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=H3e9GuzRsweXGtevTS+syS1tRyWCENLsD3gc+ohTxEojR72/NgrFFdZTFZBc2XpmguAn/e+3yAcr0P6Eg+rAZcOTZjZLbzS/Cd8hERb/c1qYLQyYvYkdAsLPyoyqiepb0IRTBeDvRTgnFQ4Ebqd8PZLjLyztNuAo/skA44vjtGA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=S0BmO7yK; arc=fail smtp.client-ip=40.107.243.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j/b8idCyKe+G4Y3PEImnl3LDEVbQhwTeutT/V0dU+243WEWeRpnQ4IfNIL5gD5G9a41sQcW4FwUD2kjGPszzeKsFah2wzo10h0/ibA+hmaxmhseMy26dgxiHP6X/oPm90Ef2NGTI8eN5FrL2ebP4YsyVWt3fjS8xGDjC55/CgjzPKJQsDMkupIGWtGllEIq0LJ/HTc+eLGjdnEoeNY3X4iiP8uAiEpVlmdYwgV7HtlK7TErrnVxEI3J1FDYIuievrs2g/Hw1w9eOhySXnSXQbR0tPveymlpEqMRKBfbuvOIWKAXH0s5nfjYzbbNlpZ1wQtnqEgxQbw6Z6wCR9Z6xKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=abdutjUGx5kavoiZQufXrbHrlCnwFwMKoGFc6jW2ToM=;
 b=HR470JINO0yJxZlkzBilu/56xw+Biw4NBrTHjn5GrICZdbFQRKiFMIdEDs9dkQ+dlSQblA5pe22GemIp+jNWVh7YXgeDcddLku+r8zY7IkGMzzRjDsbJGy/fPex6KtvV58OlxnIF9OLT+1fukN1kT94rzimIC3YN29/Oz4NGtb4iA5i2G7awtyjYJ9xWSmp3Dp23+ksnXVUlK6sNMtRyuqo9EOWhHAltPwpsP19SfdAA1ldg5phrJ8EYe3hGBaTma+DP6VpwWjI8Fn7lrBzwqpNH/snxr503POk5R9HG1x1mRfJI9u/VwMA+yZDeeZTvDPWmGU9GAuHEFLtgXjDMCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=abdutjUGx5kavoiZQufXrbHrlCnwFwMKoGFc6jW2ToM=;
 b=S0BmO7yKaUm/T7MKwpLHwpddoitudPa8ZW8w+oHnrlP2D1Uskjkz4hKDy0NFJZeOkqyo77/jKLgfy0oq+sC5V2CWvJGWEtglF0xlnBn5hiWvRRWWQdGd0dzK/3rQzdhUh0zVxzKujBa5LXwONSxQMeQl82kU7zA6a7O9PyrK/oE=
Received: from BYAPR05CA0102.namprd05.prod.outlook.com (2603:10b6:a03:e0::43)
 by PH7PR12MB7453.namprd12.prod.outlook.com (2603:10b6:510:20a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Wed, 12 Jun
 2024 19:12:28 +0000
Received: from SJ1PEPF00002315.namprd03.prod.outlook.com
 (2603:10b6:a03:e0:cafe::6) by BYAPR05CA0102.outlook.office365.com
 (2603:10b6:a03:e0::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.20 via Frontend
 Transport; Wed, 12 Jun 2024 19:12:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002315.mail.protection.outlook.com (10.167.242.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Wed, 12 Jun 2024 19:12:27 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 12 Jun
 2024 14:12:25 -0500
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <qemu-devel@nongnu.org>, <babu.moger@amd.com>, <kvm@vger.kernel.org>
Subject: [PATCH 0/4] i386/cpu: Add support for perfmon-v2, RAS bits and EPYC-Turin CPU model
Date: Wed, 12 Jun 2024 14:12:16 -0500
Message-ID: <cover.1718218999.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002315:EE_|PH7PR12MB7453:EE_
X-MS-Office365-Filtering-Correlation-Id: 6afec269-a446-4da6-6bb1-08dc8b1399bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230034|376008|1800799018|82310400020|36860700007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?50Y3YFQSUEbTEkGA2p+8wdMzCRxWSqbFCzgzlJlRMrd4/zmtmIZKuEePxqC4?=
 =?us-ascii?Q?wLTI1WOf0GHeIJ7bNJyWj8iQXKsQfUCiSm8FR+ViQpgwtupXEQFofbpgrWIO?=
 =?us-ascii?Q?quvGvwXph2+pdD3DCD3eF+QZDJg3AOnrDel3YgS5Gv63wshm7yYiCN2i96OS?=
 =?us-ascii?Q?D4JkeW9e0nO+VpRVBLUrCZuNeJocW3wGOpwrE+J1148cZ9EBK3ZopNFH7QMq?=
 =?us-ascii?Q?qqLG9rJRJZwuemQJaMaB8w0y2mfT9iLaG4tthtu58Aa9AwCuAu45oXwXsw9q?=
 =?us-ascii?Q?q+o9RObV+urqFGCFbRMTSt6A/XffungR+EqZiPdcoD9/Vpq7DmL4Jw+9fzTU?=
 =?us-ascii?Q?7eIkLkqHpDmlpaZ4MHzmawh5ZkUH8wwUZcmJrx8KjUEhB+cGdNg4BTTptYBl?=
 =?us-ascii?Q?Xpq8f0OFeiCoZgr4hwHc46mwzODzeDFpxxmgUyOsQWzq6lso8+S7DQiWFkeo?=
 =?us-ascii?Q?2dbJiuBOwP9Ux4bGB7T/ak+eBORVV4r4Z1af4B5HIYM66v2Blun5q1w9gFKs?=
 =?us-ascii?Q?hkRkxhSbax2JGA1bw20uoB1joesdu9L9scCZsEmblWkR+YvKnMDdQvIJ9tZo?=
 =?us-ascii?Q?o6EyAAGgrZg2rx9Fzqqc+ZrH9QooeVVHx7wLtdKP2ZAuru2X7Of3KQIHd1sf?=
 =?us-ascii?Q?80xIsqYfDYl8eJXKFspgZOywKWBJbBHdQ8tVe/M4iNFk26Gp9Sxkle/0N9Hz?=
 =?us-ascii?Q?vEzmpIYwmfBExmu2nWo31Y/6ip4ALoDh8a+nKKnN3jjR7KeDt/zZz4JID8nw?=
 =?us-ascii?Q?3x2UxU2gmL18V/1jSuYjq/9n36LQZzpUZecWR/j6CnO67ZEQZXbQRyvYsXts?=
 =?us-ascii?Q?pYx3OP+pEETyTulIu9ldXvIDY7rUQ5bT5qcatV+OkFmJIpXJlKaXq7K21RNz?=
 =?us-ascii?Q?usG2LJwjD3gn6ETADDkKTX5tEEWJ992HUPdcTSUFiDaJ3zANYJgTjrqL+jeY?=
 =?us-ascii?Q?31746HS2ZjY5/k5VJIdgWz8eLbKk6IkleL4+OD1/uOhDpL5YkT+IjzJkpWDX?=
 =?us-ascii?Q?B+TKlrzOrYb4818TxrDkCrO2rBPTtkPuiAipWsIbJHnrD9hSh73Gpn1ef8dV?=
 =?us-ascii?Q?KyC8mKcuhxKyJaKE05KwjqSrsQu/5Vla7oV2R9QDFCOkhNMRDo/Az7T40Khb?=
 =?us-ascii?Q?H2NvV+Dx4pAo1uoksRYnYU2dZCdfgr+ktMFrTUI1MsQ9BAMjrW2MHaQpHXx8?=
 =?us-ascii?Q?/Kj4VpudEmEg0F7f741LYgpZKWoX/l8cv1dWxFHqT681A+SJcyeXr3YDRS/x?=
 =?us-ascii?Q?ap5qp5MPyiXJDYZtgQ5Rmrn6DO4W48mIQzRMr4ZxIRqgUDnYFEuiXG5Llkd9?=
 =?us-ascii?Q?0W9YNVvkab/UXrQWa+28ReVARRAKCpnf6x79RuMaQV9h/WPG6U8gPj3EqCqJ?=
 =?us-ascii?Q?gkGsXkjo7viX5ZipjyObqzWav2ajBHC6HGpuTnoHd6vg7KtEHg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230034)(376008)(1800799018)(82310400020)(36860700007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2024 19:12:27.5229
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6afec269-a446-4da6-6bb1-08dc8b1399bb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002315.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7453


This series adds the support for following features in qemu.
1. RAS feature bits (SUCCOR, McaOverflowRecov)
2. perfmon-v2
3. Update EPYC-Genoa to support perfmon-v2 and RAS bits
4. Add support for EPYC-Turin


Babu Moger (3):
  i386/cpu: Add RAS feature bits on EPYC CPU models
  i386/cpu: Enable perfmon-v2 and RAS feature bits on EPYC-Genoa
  i386/cpu: Add support for EPYC-Turin model

Sandipan Das (1):
  i386/cpu: Add PerfMonV2 feature bit

 target/i386/cpu.c | 202 ++++++++++++++++++++++++++++++++++++++++++++++
 target/i386/cpu.h |   4 +
 2 files changed, 206 insertions(+)

-- 
2.34.1


