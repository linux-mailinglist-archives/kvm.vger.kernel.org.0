Return-Path: <kvm+bounces-44699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3880AAA02DE
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:16:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C569163D37
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:16:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36848274FEA;
	Tue, 29 Apr 2025 06:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="h8a6FaiP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2051.outbound.protection.outlook.com [40.107.237.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2BC26C3B5;
	Tue, 29 Apr 2025 06:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745907291; cv=fail; b=kye54BUo3XunNK6shvp4862BnTaWjZvrDgy3urEVrtuaqytNAGRWvZRMValYpSPswEs0Wxiyrra3Lh88DQz6sg9eMrqoFQbmpaoEgiXNaVP/16JIz4vCNSVUQUcXihNLa6QLqeoTITGDEeSle4+RSL6NHmG9Pe01JV5/qupAZWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745907291; c=relaxed/simple;
	bh=LHFkdVZVrXopoUPAjVYWnZvZKlaHYUt+1A0NoaGVo30=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SrPn15gQ5pK4SUxIUbcf6g7lIswb5znaHFTnYlxac2+5w1aKfmz2twNDv7vCd+uoCv1RArkYZdBxk4q1xsURzg5EFpajs1W1F0oWl5o8xznF5wO7x3USpww98euUBSYYxpcY4ARlI+ZpGlKECcf6bodlqyWhH+n/6cX2kdn5DXY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=h8a6FaiP; arc=fail smtp.client-ip=40.107.237.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qvGmkge9chKed+NIfmvfwbxBnD6PxwxPt1DxeEvcJtPBbklog5TJbS3ZGIUjATLzGjccuKVBmho8b4XOnVGFZYwigTLhzC+PZeIC0bzqpHJMlR5ybffNoHyRNP5OfWCoEBeH2O6e0S6+T/0q/YpvsQG9fAQLsrBQWZbQnigWcT8iqgh4OUMJ3VF6k3SVjkiTplTmvC4L+Uv+XDSWw91jqj46rls4XepphuLJHlOLTx7RfECkIdxqbWIDANFbs6jr1Pkz8ivQuAAOP2XgAKmFJUT72Hpf+Y3EC19Pb27WjK0uNMFYnYpsONKU7PO7qPv0yLmEAwSY6C1XsYRzlaRCVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gzfFYZvP1PlDChO0iz/QckYWiu6we29wxbg47MZ5XE8=;
 b=FPUQNMZH/1n8xoh5i5x/7Pk3mdLAJmzJaKnJTWciVteUElAYxryk/7rJ/S1bvfk2ZphLDawieaWYjTbkJaVhJK+Q8HguRMj0CWRDeaW6g74F6kG4xGemExcLh+M7uYsO+1x7zr2zSw4Ei0/b5XRkP1ywO8p7hCAPOoS2r7jIv3KWjJEwiPe58Fo1hEnhWXxF9m5czD7HP7izvrR+dQbmZaICY1sGxkxY014CjtLWkh7calVwtqoozL6FfODCLM42scuV+CbN2LvUoQjAJdV9gE+N/kUzED5hVudgC9xfGVHfE7mB2757yIbSyv5xjo5BmG0eDFqLHC0Rc8rVF4P+gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gzfFYZvP1PlDChO0iz/QckYWiu6we29wxbg47MZ5XE8=;
 b=h8a6FaiPLsz9jOyse/K/IKLN3rNGv5OKUvIkYhDcY31ybsiWDc233mkcvzVx3E0nqhZyGUqJf4TWnPRNjSXp+AXu7bEczyAb7d6OJvWSh+X7V3gDPUDXCKX4jZBW8bEFJDSCYlJTTRx5DpzHzV7P1SKUr9Rl6ZdPAhJSUFF2gqg=
Received: from DM6PR03CA0028.namprd03.prod.outlook.com (2603:10b6:5:40::41) by
 CYXPR12MB9441.namprd12.prod.outlook.com (2603:10b6:930:dc::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8678.29; Tue, 29 Apr 2025 06:14:46 +0000
Received: from DS2PEPF00003439.namprd02.prod.outlook.com
 (2603:10b6:5:40:cafe::c5) by DM6PR03CA0028.outlook.office365.com
 (2603:10b6:5:40::41) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.37 via Frontend Transport; Tue,
 29 Apr 2025 06:14:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003439.mail.protection.outlook.com (10.167.18.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8699.20 via Frontend Transport; Tue, 29 Apr 2025 06:14:46 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 29 Apr 2025 01:14:38 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v5 11/20] x86/sev: Initialize VGIF for secondary VCPUs for Secure AVIC
Date: Tue, 29 Apr 2025 11:39:55 +0530
Message-ID: <20250429061004.205839-12-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
References: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF00003439:EE_|CYXPR12MB9441:EE_
X-MS-Office365-Filtering-Correlation-Id: ba74c013-00dd-4ecd-0207-08dd86e523e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AeZcgkkAsSGKUPYJsI8/y4Db/rYQpkGRlLP0GUbOqzpB/XQAjgkbloeMYwFQ?=
 =?us-ascii?Q?qz72R+TDx6WaqtRY88kg+v7dp+Y7eaaTXnsA0Yp9Ka5RvAIqLkqkjHSyiZcp?=
 =?us-ascii?Q?wy2k2TlkC9rNrq9vFARmfn6jBqXxpuAg1kbuLf2DdjP/hHxgjxm/IRjH1G8t?=
 =?us-ascii?Q?WrntEJcfqoIDUPes2ywej2wt0hS8PZi/PnxqmQxaYajQjhEGrE/XPXqIJK/3?=
 =?us-ascii?Q?q0tHNkXKHwwCgP9ZfDOrXbQX24Jk/JTVxbFCBVuP0SgUlxql5bctMYNGWAE/?=
 =?us-ascii?Q?J3WInUod/j2NLEcSNm41+32Gijbpuz+3qdpxd1zB76fJO7LSouEUlWvvgneo?=
 =?us-ascii?Q?Xua7znHOmtrOw35X2YQ3fWoDwEThgqqk4zWhMffkDxZP8wiu0JqzQ8uoaoQL?=
 =?us-ascii?Q?i3+nIb3OifeotoTSBxXG6vGOpuwfE9NUc9S0UnA3p1jFG54ck93szjvuo4JI?=
 =?us-ascii?Q?BP34T8ahI0Ui0VdPxg1m99yvP2v9gnBjqpfsn949jS4Tu/HvgElgKkU5QJWa?=
 =?us-ascii?Q?jaoTTZ7V73igf+CGMdMG4YT7WfnyIv8xVjGMe+bh2uNqH/p/e7J94sHXOOUt?=
 =?us-ascii?Q?AG4hVEl/JwAIOmhQOlkiSZLnPHo+fftWuPvvDRKab5LYh+hKCnb8Igswxmpk?=
 =?us-ascii?Q?9UDYX4FoK2XDlgtFY5RS+VMbqIgiqP4CDDs0UPPBRJGInT5PaUmWKp6XkINN?=
 =?us-ascii?Q?00P1YX3W5ownvee0+GB1qCXT3dzaZL+zVYe8uovvNTboUF0tzQByiGEBY3Jo?=
 =?us-ascii?Q?cjCg8sax7QZ/s4Yf3FIJ7+5ikQ2Pz13OIzj3F1kNy5DFG+EN96wJ36sdRPzJ?=
 =?us-ascii?Q?5HcuMSLVM43mvGHuuGJpMtqZkA6Ik/GHTtZ5wTb851RAVsEeu4OlwB4xywhL?=
 =?us-ascii?Q?Yq0w8Az4dGhxjh9t1oPfEBd+o/0JKkfxJHfyo1s+ob5mUSbuZtFPqqErX/Z0?=
 =?us-ascii?Q?pUPLrk85Y1iSZkyZ5iq4AQlLmIuJZlln1VzW+GHKiReyfqbf9xSPbqDRO8cg?=
 =?us-ascii?Q?E3pEMLk30mK3FSpUH1g/rPErN0FWOW43HrKRF0FBTOTUgJTIhUAuzCxn8zxZ?=
 =?us-ascii?Q?U48LYKtD2hUtQuVcUPoqZohEUw3nJu/x945/peEOnH8RjYLkUveqnFzmbCTF?=
 =?us-ascii?Q?KE49FVkQeEhMUMzXV+rJB5VkIBfT4/BXrjmQdbq2eeEzAIqSfCJu9s8ZraXI?=
 =?us-ascii?Q?0Q8nx93vUiwGskruWeI176gnv2WWHrY22+CzYYHmPbBqio8fFPV/25lrgubs?=
 =?us-ascii?Q?NTNpqFjGik0ovmY++Wl4wVj55DotiPbwwNh98wMJ89BocgDPhfHGShIvEA+R?=
 =?us-ascii?Q?x04gt7+lI8IphXvIiJaajCcOcu8ujslLGaRPqlxZ9sNchhy8vvsfZQTWUnJO?=
 =?us-ascii?Q?NPv42Xst4UwelTeOHK9zyuPI0TOxtuIy0kISPEUMs7LjsP3me7naEXlkjTdF?=
 =?us-ascii?Q?Qeq36Jd2sHqFcDzNKu7p7xwlp5DNC5IwIZOQ94KKlfoey9Ffggo4TR/Xjm/c?=
 =?us-ascii?Q?KxYNbzHi03PCgfs3IT/LfP1TELgIUYDnU1Ml?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 06:14:46.3592
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba74c013-00dd-4ecd-0207-08dd86e523e6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003439.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9441

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Secure AVIC requires VGIF to be configured in VMSA. Configure
for secondary vCPUs (the configuration for boot CPU is done by
the hypervisor).

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v4:
 - No change.

 arch/x86/coco/sev/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index d62075379a33..1c6028f2ff3c 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -857,6 +857,9 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
 	vmsa->x87_ftw		= AP_INIT_X87_FTW_DEFAULT;
 	vmsa->x87_fcw		= AP_INIT_X87_FCW_DEFAULT;
 
+	if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
+		vmsa->vintr_ctrl	|= V_GIF_MASK;
+
 	/* SVME must be set. */
 	vmsa->efer		= EFER_SVME;
 
-- 
2.34.1


