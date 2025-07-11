Return-Path: <kvm+bounces-52086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA8F9B0126D
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 06:54:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23FD216D2EA
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 04:54:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BD761ADC90;
	Fri, 11 Jul 2025 04:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RsudcVgY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060.outbound.protection.outlook.com [40.107.223.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9ABB3FFD;
	Fri, 11 Jul 2025 04:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752209675; cv=fail; b=Le6byTseNphj/j+yVL3UKjMtlGIykuTr3R+xocgjevaSHbMLvGrhxTeWyKtPNA8deU6G/JhNVPYBn7HUDyl6FbYCWPOoVpqzczvQQ9FGRWWrFhTD8vdDI5gpJZlC5Kd7N9Xl9Ezx5/K80hBBsH2UE8uXOObrXcQ3cjMCMh5Wvxg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752209675; c=relaxed/simple;
	bh=4AtJGXqLIO3mY+9CWB0P0qivU7rPzPBq7r071da2frI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VtnjGzFkFpShf60dJBYgbzKrdrFu2IanEGoGy5PT059RF8X/ROdPFTdl7hNcnhq08j5acDEnxkx/BMWFzHvirWMObmiWrGbOUyljT4Xo1xzMHT8teC/ydpOjFuJOb/qwZmybxKQxj3ZN2IpOIUjOhopC/Dp0KE23fiQYfNzWSME=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RsudcVgY; arc=fail smtp.client-ip=40.107.223.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B8p2LA595+QJXFd9Mj2LE944RCITRUZ1yHhnI6e4WUESWqYo1o8YvUxuGcnGF/tx9nde1WJXxQZGxLsMnEzVCfr6p3K72iUaEdmZQm09aPpo7Gb06O+B0h14HucSHYMd0AJoGprmsqdr9vX9K3I58b4e2NSTv78rE0GFADN8VK0WJEOEdDt6n9oH5HiDDS0KIC9SYX+AgE3qv/k+6hy1ZjIt+uWgtTjNwY1GI8Q3hDBilQxNyJN/smxCepcZuk3+KDYPsybaGHfx/s+mZIGUcrMDMJscANiZEPAQf14K8Lpgt3KtKODsKxeVKBq4uez6je1M0LyVTGXVdgX7trgRhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qqntcgKxsBeD8myYTppR9261b5UQE3Sxe8rcv11WMys=;
 b=LoBSdwL66XQKv0kF6KJNSzJfOj9+VhW87DT/JAW3CpdUQPHfoo+sdPQhc5lNPSH2RGnbHtxUMiBcAacTrpJO1TBHEPhypjilodVJ/MAj1IYfR6YA7FxQv/3vu1mXePJk/gMgHWqU6fM1gbOl9aZ3BhYk8s+mE3d/GF9Zuzar75a3v8sQTQ8998j7Xuarq6lGTERK4wFuZzAmxfaW71Zg330G3IHXWCDsFSUPSBPgjT3FHNtqXngzp9gB33BW6wQD+nTnaG3NSyK2MMUNRaj1uQgUuF3QVgXnD2jR5/JKp27ZHB+cAO+qspuGSI2Q5W47uvRVIhTedlZX/GsMs+3Sag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qqntcgKxsBeD8myYTppR9261b5UQE3Sxe8rcv11WMys=;
 b=RsudcVgYlqWUH283/aPfl2YBzP/n4TInhvFWMyMNmu/WxMvP7auBa51vtN8ZlDUColRmmqMVo1W2Nd4Ovdd0ZQ+mRxPnh78sR2QpmCJrROV253UDg3DgHqmkaBtvhx0fAy0QOc4cMy8FuPg5EkqftGuP5hfue17T7x59eZKg1FA=
Received: from BY5PR13CA0010.namprd13.prod.outlook.com (2603:10b6:a03:180::23)
 by DM4PR12MB6038.namprd12.prod.outlook.com (2603:10b6:8:ab::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.28; Fri, 11 Jul
 2025 04:54:28 +0000
Received: from CO1PEPF000075F4.namprd03.prod.outlook.com
 (2603:10b6:a03:180:cafe::94) by BY5PR13CA0010.outlook.office365.com
 (2603:10b6:a03:180::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.7 via Frontend Transport; Fri,
 11 Jul 2025 04:54:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000075F4.mail.protection.outlook.com (10.167.249.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Fri, 11 Jul 2025 04:54:27 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 10 Jul
 2025 23:54:24 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, Michael Roth <michael.roth@amd.com>,
	<stable@vger.kernel.org>
Subject: [PATCH] KVM: SEV: Enforce minimum GHCB version requirement for SEV-SNP guests
Date: Fri, 11 Jul 2025 10:24:08 +0530
Message-ID: <20250711045408.95129-1-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F4:EE_|DM4PR12MB6038:EE_
X-MS-Office365-Filtering-Correlation-Id: 756b7eee-2daf-4e88-954d-08ddc0370414
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JX46vfEP1T4YR2ScBEoybdb6G94hKORJTydYkIpzxOQfgRVZSk+BYg0vz2Pr?=
 =?us-ascii?Q?tVEYhvJAq6FNwLT8ap5zKTzXWBECFy83cEoKnJWOzaNig19e2hFrAMVoDPel?=
 =?us-ascii?Q?n6TXeDz96BYv4TjzYn/5CYF+umI813ZJasqLJBsfdTxP/x9CBlhauQ+Oqx72?=
 =?us-ascii?Q?z0ni1/83lyMebqTBlJkBUGIElSHOa5ucvNuSzVb4ix08SMKngDw+Vza7nun1?=
 =?us-ascii?Q?JMZchxR2Aqhro08yrxd3zNYNp95ImuKyLp+OzC3mcaRLTvSCKtNeS8gdxMbT?=
 =?us-ascii?Q?TaEESaP7mPWdoTqZjGO582s2ZK4GzSpU5I9SRB2HTtCyq0rt6B/tdtCXIZEA?=
 =?us-ascii?Q?SNRHKRZd3tqpfQz2uTKiYCn4CgnpDvPv8Zmy1JukhWQ0IHtcyFadg+uAy2v3?=
 =?us-ascii?Q?uUf8effOvPuE4AijdaObj1/KC31gpCX99KaMQrsincrjlA0W2qsnza5yZvD6?=
 =?us-ascii?Q?yAHXZNsrtE6A7DIZJvTFg4Iq8MVwRfzSWakAs41Q6+huotRNJkBv5ZihwP1l?=
 =?us-ascii?Q?tkU6neXJobnnQJ8AX2dhiO6WfMEyZUXuKu7pIGXxO9+tZBZ+KnlacpbPJv/d?=
 =?us-ascii?Q?A+K8go/3EgCSoiWiSEo4Ne0ekjCiw8WFgf5GPhLwH3Z8e5qVAfVEGuOpWvxw?=
 =?us-ascii?Q?VhOjB16d5GDdYA012nKn30eiAeML6VKWwoi6J5IzblZYSvt8zUQCG6jh4vuP?=
 =?us-ascii?Q?gWmTSD1Fz4iQfeQuQMCdQaHwE30t1jJI8cG2UpLNO9qSxZqfS7n1ihK2OYRv?=
 =?us-ascii?Q?UezBq9iUsQjhN+6FItIBcJkLrE7dAC9Tejb7WjfCxrlzGPtA6yj+bgow10ki?=
 =?us-ascii?Q?YYfXYFPXG9mRfNK1iWLEbk/L+dOc8UCLm2FWW6KBq6QdTkvlXkCCoIsasNx6?=
 =?us-ascii?Q?rxPoB9vCjchD0+zRysRPBcV/kYBzs7bc5eqLN6Fkcf+tIuv3B7cvJCJT1XZz?=
 =?us-ascii?Q?OfEwKZslDu/b8lL5ascfhHQMGX7KEqgTbZClR3VqoulJatvdJtMNjoVx0bEL?=
 =?us-ascii?Q?dGhYUaagger9WAYAzSLRAFlqf52AR55KD3gaW3ye1dstznzZGImXn+V3RPJD?=
 =?us-ascii?Q?36B7Jx/zhC700ADKGYeVh9W7C5VKZas7VjPivmVYEGcPPZkQvNNFAcJ6+owP?=
 =?us-ascii?Q?G7Kgv5bEDFci0YRZR4a4PZrLfgg9QcnUnacZvBtIBiAmi+i3u9tyW2SC3SmS?=
 =?us-ascii?Q?G/29Ja8S5/iRKwIAvs/bUp4E4Hr8uZwM0eXhmIVVwrSaNJh7JUhUknZ/FEX8?=
 =?us-ascii?Q?2S89hdRFdfQtzvhydBaPY5tbqtCrMATQBax2JQTZiCLXaf/40urHg2g599hj?=
 =?us-ascii?Q?Huz0Xr+4auUrJw2SZ7JFw6uMQC2UxQisf37vPhLPJJT7r2HaiQMikA9c0ARQ?=
 =?us-ascii?Q?34wnZYizTrxBFbAylVOkNUqxFl1wQzvig6Pdh+YsR5QyERCwJANd3NLMFGLP?=
 =?us-ascii?Q?/IKJILY+lwfP4SXEe10s8iIde+JPH5OInXB1DZOF20h28jYpM9oIiDXgjQeO?=
 =?us-ascii?Q?7nY82FVyyWl0VzJDbQStmV/MgKwiM0JTwt7a?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 04:54:27.9329
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 756b7eee-2daf-4e88-954d-08ddc0370414
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6038

Require a minimum GHCB version of 2 when starting SEV-SNP guests through
KVM_SEV_INIT2. When a VMM attempts to start an SEV-SNP guest with an
incompatible GHCB version (less than 2), reject the request early rather
than allowing the guest to start with an incorrect protocol version and
fail later.

Fixes: 4af663c2f64a ("KVM: SEV: Allow per-guest configuration of GHCB protocol version")
Cc: Thomas Lendacky <thomas.lendacky@amd.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Michael Roth <michael.roth@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kvm/svm/sev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a12e78b67466..91d06fb91ba2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -435,6 +435,9 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (unlikely(sev->active))
 		return -EINVAL;
 
+	if (snp_active && data->ghcb_version && data->ghcb_version < 2)
+		return -EINVAL;
+
 	sev->active = true;
 	sev->es_active = es_active;
 	sev->vmsa_features = data->vmsa_features;
-- 
2.43.0


