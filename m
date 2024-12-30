Return-Path: <kvm+bounces-34415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E9EF9FEAA3
	for <lists+kvm@lfdr.de>; Mon, 30 Dec 2024 21:37:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1308D1883566
	for <lists+kvm@lfdr.de>; Mon, 30 Dec 2024 20:37:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 350B919B59C;
	Mon, 30 Dec 2024 20:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oMBpOT8n"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2059.outbound.protection.outlook.com [40.107.101.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F7018784A;
	Mon, 30 Dec 2024 20:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735591023; cv=fail; b=Ssa9pEZ4Jfe6X74G1tTosgJMfvNulHux6Sf/x5o9HzJ+4DKydn0AOYCH7TMG6eCbq/UqEF3mO6904kTZKdqVzk8cXks3WcWuLIkTKxrHamLvPGERMlDrU0tlCsQcX9x6rZ3s5BUFHBsMctGVubtoF+Y63kB5bhhfKv7+jTqaVXg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735591023; c=relaxed/simple;
	bh=58rYJZpraWZOQWO9L145SPrbXjUW4GZ3dn2Q3NJkBgU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mJwHtxlHBGfJW7n6OyoraM9m5xK8ETt4c+U7kdUJvyv4pjDZPkui5OWHnDkIcK8ExXDY5yDiTo9/yGKC5ARN8DER1Kr3WHZZsvZjM9zq8peJL0x9LAOr9mqAPTioXzq9nUOxI5Hhne42aK0ekyKptBPOf+6qykQLsRLbQL9qLQ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oMBpOT8n; arc=fail smtp.client-ip=40.107.101.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R199tJJTC1kQpo0b5P+9spqD47lSY+H2Cqp4+gWyFfySR7v/EDumjXWcK1PtN35PVSfsW2fo/iJXPnLV6MnJBnvG+tZZdJQ+ifGCHnU9iLec1LpXmMCj7Li2u87M0aFI8cjFF89uLZ+OD8GQdRV662eXQnXGnCT3Sl05ZLgWvZ0vztKHQm5BFJ+4gCG9YpVJ9Z3czoSQ5zjY2SZ8hCNw2Cq7ZKFQTdwqWRlNVTeYtpUrP790wbAe5GkjhD6yWrstrcQhwzepasv6al4Cw4CKESZW28Doi3X7woPoH2p85ubq+Ro3vDzDd13WMJZqyxEE582jqcjUmAThQogSGymvbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R8VrxDNGchWhAJz/d66Tnf8Psrl/KmQTejA54hyOQys=;
 b=QTI5oYiBbT9pg06p5SCx1VEJ0LJVgaNR5ECivJH6HHacSM+sojPQnXhegqsUqyMUvwND0v47gvMcPS4N8Zf5wK2R9Ka+rv6gRwhrDbVQ0aXmOQIKEHb+2uJZWIC+TadhM6F3kRdQZ4ceDi8RH7SjduyrApmZguWI6RxzYZrdJDUN8IJj9UOnt0kaGtl2RLdFwGfNLrDKQWngfOoPfiI39d6GKZ3ROIhDcZnZ5ixdbVX5LGbOGrfzrq/OY27JCUh3Yqx1sZS/wgTr1IVICGGwv83HFDJVAz8UxO/LxAYW0cp5klioKjRjlcHmAJKZi/IQsQfSXkqMvQdS0zzwlVyfbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R8VrxDNGchWhAJz/d66Tnf8Psrl/KmQTejA54hyOQys=;
 b=oMBpOT8nVP8sAPJmMUsxixqoH5tRhYWyKrr0xPU13RsEBfT61xGpwcplCkzjaShB5uSYJa4dV+dsnS7s9tluYMo984AWwPeO2qS2gIgdE3sg2FJ8TDvTKSqeh51/VxAadthobJbSXq0J+lu0K1WD0BtJHm7QjJWSjGQQ5bs3/6w=
Received: from DM6PR03CA0037.namprd03.prod.outlook.com (2603:10b6:5:100::14)
 by PH7PR12MB5925.namprd12.prod.outlook.com (2603:10b6:510:1d8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.18; Mon, 30 Dec
 2024 20:36:54 +0000
Received: from CH3PEPF00000017.namprd21.prod.outlook.com
 (2603:10b6:5:100:cafe::f5) by DM6PR03CA0037.outlook.office365.com
 (2603:10b6:5:100::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8293.19 via Frontend Transport; Mon,
 30 Dec 2024 20:36:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000017.mail.protection.outlook.com (10.167.244.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8335.0 via Frontend Transport; Mon, 30 Dec 2024 20:36:54 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 30 Dec
 2024 14:36:53 -0600
From: Melody Wang <huibo.wang@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, LKML
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Dhaval Giani <dhaval.giani@amd.com>, Melody Wang <huibo.wang@amd.com>
Subject: [PATCH v4 0/2] KVM: SVM: Make VMGEXIT GHCB exit codes more readable
Date: Mon, 30 Dec 2024 20:36:38 +0000
Message-ID: <cover.1735590556.git.huibo.wang@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000017:EE_|PH7PR12MB5925:EE_
X-MS-Office365-Filtering-Correlation-Id: eb53a78c-191e-4e70-39ba-08dd2911b2a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FgQbi+fdMK3lDp4nXZ7zHddyGCETkfyYdX3tNifVxEGUhKnzBBIPkfFL/928?=
 =?us-ascii?Q?yL6AR5kowT468sLUo6G8ZhkGQTFTCg5tU3sAQyBPY6HrB7YQKcrLWz+U6AcQ?=
 =?us-ascii?Q?Mbq7YV54bVFNQgITIT/drL5ZNE4dAr9k1oCJplqlu65bFEf+l5/s6MoIoHyB?=
 =?us-ascii?Q?ik2EnYP8Ig8etLwkqXSTUfAdheGNmMie95g2n2FI0ObNhXGDllyN6vwZUnh7?=
 =?us-ascii?Q?YtQMaMlHwTQ96N4I4t+WQMSXkxli7pWFYoeGfGcmi81wpGKeUiYLHgrTD6rM?=
 =?us-ascii?Q?7w4NmVvDl7bR3Eh7b5h5BsrT4+uSsWjsEGuO3UWxx9IFnbJVSpwN/NgW2EAw?=
 =?us-ascii?Q?du8mrb4wfRMuRlk20WIeIlHh73xqfaBJiJ040C8dPX1Au2hA6B46nhgnCFjH?=
 =?us-ascii?Q?QW33E1tOXNES1dVFb6IoqQblgjnEoLQ+EWcAyMiy+K61x3FMNKGrnvdLRieA?=
 =?us-ascii?Q?412obv+44B28J7Zo39nT0+/uzf5pCiiVIeradZ4jNnghSG3JvhiQpCR/WT49?=
 =?us-ascii?Q?YSl9aiQriHHYuOXuc1a1wiY7MDThQ+wmn6LYseXG+Qf/PvSgPk7cL6vsACo5?=
 =?us-ascii?Q?NzYwfFPTi2WcrDWug+BJfA7X5mkE8qa983DS3p/j+Qn9Q29nfnclrLM+bgdz?=
 =?us-ascii?Q?hKvLPCBSO6jdhOxF1m/0tBEhsm6k/ze0pgnwyKLL6Im9PtgqVhajOGI2714L?=
 =?us-ascii?Q?TVq+ah3g0NQbmc8cr3tRQ5aorptBHC0Q+HNWqzmn68PI3ze9MGJWJPrRlwGw?=
 =?us-ascii?Q?sVpq3bNMPv2AJzpyFqyUDlrXkFB803ngpdn9q4AW1TyfCKUwX6YqHJ5n/PcG?=
 =?us-ascii?Q?3uImU+OLy+3hFA4+y8GGsNxZl5kjiTZJ9M7RLjMaekONu+T7kUCdJHwL1c9G?=
 =?us-ascii?Q?qSC3rXgr23VT5Dok6qElBcgFm6avNgFAFk7sGG6jps0Y1u0YWpkOduIeg+RW?=
 =?us-ascii?Q?xn0hOg7nYWdQ7nGPa2hMFIB0xWvufNsFQU1TLhYR/F3dEfWu3cO5LHCtXi0Y?=
 =?us-ascii?Q?Ln4aiuoXxAt537JsrR8ni4qtv0DAAmNC9UbheybeFd50lNMwwJylsT0hT/d9?=
 =?us-ascii?Q?PdGBSXJ5wgV/vcjmOadtOrMktjXv6Sb2eE14ZiE5kqMj91wl4SfZiJ1S6/8+?=
 =?us-ascii?Q?eBP/x2M7dY0nfOfUJdgVqnKCcU8pyIuou0jrBUBa5/Kfmf2IhQsrt5AY02J8?=
 =?us-ascii?Q?wCXgH2MSdIoJn20ElYV2/+w+kF4f8oFdlgagOjcItjDD/VuwM3ou5zkuuoYC?=
 =?us-ascii?Q?5Y2rUgGG2N9bUHFeZzHznIR4tWAy+zZ1V2VeB6keRlgK3kNR0n9ASi0I8A1h?=
 =?us-ascii?Q?doxa3S02AJRp3UU48sQe+k/RcsVKQ7ubC/WULAQWopOzRW2QNfYzMAsRBZhl?=
 =?us-ascii?Q?6mVDsF9+irfiEh5J2eJOkmrCEA3/HJRkNY/URxMbqcmzSw3GzxZG4cVlie99?=
 =?us-ascii?Q?M8tO6cwzXPvudcG1pnu4wDydFZ3tpFytsBunRLGcNR3n7VFjHj6MIlxyXVaN?=
 =?us-ascii?Q?taTbMDS6zbyHZ/c=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2024 20:36:54.3765
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb53a78c-191e-4e70-39ba-08dd2911b2a3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000017.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5925

Hi all,

This patchset addresses all of review comments from Sean. All feedback is appreciated.

Thanks,
Melody

Changelog:
v3:

Here are two patches to make VMGEXIT GHCB exit codes more readable. All
feedback is appreciated.

Melody Wang (2):
  KVM: SVM: Convert plain error code numbers to defines
  KVM: SVM: Provide helpers to set the error code

 arch/x86/include/asm/sev-common.h |  8 +++++++
 arch/x86/kvm/svm/sev.c            | 36 ++++++++++++++++---------------
 arch/x86/kvm/svm/svm.c            |  6 +-----
 arch/x86/kvm/svm/svm.h            | 29 +++++++++++++++++++++++++
 4 files changed, 57 insertions(+), 22 deletions(-)

-- 
2.34.1


