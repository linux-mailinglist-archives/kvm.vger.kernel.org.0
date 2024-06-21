Return-Path: <kvm+bounces-20261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 441EC9125C7
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:45:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C485F1F21324
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:45:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D189A171062;
	Fri, 21 Jun 2024 12:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Vmt5jMGS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2082.outbound.protection.outlook.com [40.107.236.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779FD16B38E;
	Fri, 21 Jun 2024 12:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973622; cv=fail; b=ViEsfJ5xjPwYwXUYho8mnAWWTcfTsjlSfVSK2QLx1RXnh5OQMGiD8G6CoXKlnNOB7X6LOoPOryOrOid6hE95LFbe9zc9q2NjIKHsM0SPCTgzs8AcCe9aQfsCJAgIbsbTq9p7GFQG4uHiCpCagm6cQq/HlEcUdcCOrY/67ii9ayE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973622; c=relaxed/simple;
	bh=OYQ2uE7cNW/mD7SpEhLT7D66gKuqp4N4Dm0gIz2rHmo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rzp/BQ0AV3OlA19z6vtWkQSB6B9OucQ4LNoucGMsHj6DPRcLyYiSrVlxRo67Pvc579nldLsAeSPrv6s5Cuh1xdFkSY3dA8DYmz7EdVdh8Gjo0a5Eb5LdSDj2k0RuNEiVFU3MmLid5LpvLpexHZRHSy9FxleJyAfCCYRieinnih0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Vmt5jMGS; arc=fail smtp.client-ip=40.107.236.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MIYM7oRILS01GU+JXkx+6kHUCqys8oBA3FRJ+XEo0nzZkFyW1vNrl41P0FYbTb/PJSXwrhyV+yZ6LvezT/C/bJoTfnwvZdIHL/6vlDgEVr9+MamDqaNNHJ+jDsKWPl/Si5xyRPuRq+clxVEW6oxBW2XN5sbKUVJxrN7t4fDu4B58hRNjJtuyBskhuNflVzMD+A4hgHgZhEt8+vX0nCB79F+mGcRbLr1WbS/PqXqzYBjLPNAoq+qDaQWazkD1ybIJ47KaWLIbQsbQtE1lyc4In4d4nDldLGRGOmaYFRRBrvSIGtog2bdRGpB2mset4iLi8Hg5TmuYJJO6I0CQjBm2+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4SHxr8ZoV6qbqyWGn1heGZaHUZ8pFBQ8d/JPs4/x7QE=;
 b=SsYBfJ7NuVKLfGNWiltiDsh152tJ5ofZsBWkeM8hW0JHkF3HJuY4ZLHg/jrZ2l1QNsxnpb0u4oa3jtHJfpQYOXALRVHiRKbY2nF22InUXxk5bvfCCy/P7e4x3rnnsas88kBbUnnePEP19lCrkyLLV/WFv38s65FKzE1qaRm+LiIslvAe9dcg8usj7PLGWDzYulqgM0+H7Yh97CerEFUX/XaiZNS4I5Cj5461Jv6Zjg7Z0Yxw9BbViie714WoTWKxh8X6LYgzCwVydNdkUIBfni82DmG+0rvRvKgTB6rQHQ7QwJ/v7o6HpkM1NAePvUMo6Dib3OWDTIRlqU1leGMw2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4SHxr8ZoV6qbqyWGn1heGZaHUZ8pFBQ8d/JPs4/x7QE=;
 b=Vmt5jMGS8aHdONfiVRRrYNF8Hz1QRKI+RdfXkaVsBY9ij1d/pN33HTabJQyO2SKoBzooZxRg4HMM5DSP+oMrHKAfeQU3HxMEVo7QWosJxNdzVP+dAeSeFKyNdERsDA1+26vMKISVWV8wfkJyElqHQdbdamMVHk7AGy0fizmprXI=
Received: from PH7PR10CA0018.namprd10.prod.outlook.com (2603:10b6:510:23d::15)
 by CH3PR12MB7617.namprd12.prod.outlook.com (2603:10b6:610:140::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.19; Fri, 21 Jun
 2024 12:40:13 +0000
Received: from SJ1PEPF00001CDE.namprd05.prod.outlook.com
 (2603:10b6:510:23d:cafe::fa) by PH7PR10CA0018.outlook.office365.com
 (2603:10b6:510:23d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.37 via Frontend
 Transport; Fri, 21 Jun 2024 12:40:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDE.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 12:40:10 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 07:40:05 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v10 12/24] x86/sev: Make snp_issue_guest_request() static
Date: Fri, 21 Jun 2024 18:08:51 +0530
Message-ID: <20240621123903.2411843-13-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240621123903.2411843-1-nikunj@amd.com>
References: <20240621123903.2411843-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDE:EE_|CH3PR12MB7617:EE_
X-MS-Office365-Filtering-Correlation-Id: f999212f-444f-4be4-65b4-08dc91ef4a56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|82310400023|376011|1800799021|7416011|36860700010;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nNUemPlXBYpQqg9jOnbp2/0tTYLZSaKGVezKF61iGJdTct9parwigIVHOhgg?=
 =?us-ascii?Q?C5aVWx7jFEtPkEdVbEYxM6uMspxDdoXCvvhLTkB2faYXKA1O7b8IwLiP8wm5?=
 =?us-ascii?Q?FKqU5101L1kollxZwu2NAZAMBaTDZcJoxUcige5h9r+p8Zda5Q/n/s5HXNof?=
 =?us-ascii?Q?4fvBBszARIcfkT8bBEyCbKu6+kvCANyfm0v9Grs3LY/vl16X5z9N7j2MpXdf?=
 =?us-ascii?Q?oI2zRbt8ER6NdpesGAVmyx2CuVRMPzlisFfPVgwTTPz1GIAwpoLmXDWSIfuz?=
 =?us-ascii?Q?z1kHriMeZiPCe2Q66LecihiVe29bpbHFfLUyRFoeLvenqZSB/yshzjGL5L7W?=
 =?us-ascii?Q?0qBVwYvRWAsB/Y6ZHMniO73BHVMmeW5IUydM5CYbJ3RPMSTRd3HpMJt6AUrP?=
 =?us-ascii?Q?l/B/Pcq4LLhrx3uO8U7QiKfZiWogrOWtqT04mu8x0lWKwkNbeTxhQ3/EBoXE?=
 =?us-ascii?Q?LYcNFjPG65LiSqjDGLGXc60or/gndIqlWC9AkMb8whytULoCJDe4p6XGP1BQ?=
 =?us-ascii?Q?hp0RXJLIWiyMPjxu3V2C4rVu01dbD3y0oGIwmuxEwDVCILaHIwOMIYWEXNEx?=
 =?us-ascii?Q?80fvX3evL+4Afu2ufIwXdQwPXAaOUcbaz7+vyjMT83+pir094Lvd4y6jhkGM?=
 =?us-ascii?Q?Zmegf0YvREqJAnMohKGi34fyuu9Rq163eEv+cFUZWY2J8tcH7b5M7cbRA8UE?=
 =?us-ascii?Q?t3eW2vVGN0YdWfRdwqj/0dC8klM9pmCduC2O70HRdV+DdUIvhb1pQsTbvIBh?=
 =?us-ascii?Q?a5Vcf/smq1g4QNrbuM3VnhU1BvNSMtatvrCofi5qedGfYM1aq7RFpBhGuwqw?=
 =?us-ascii?Q?5Yaz/Q+J67DXcNzx/YoDM4+4fgSU72fcmvxn2yvWCSfcbWOVhIHazsJJM0Vs?=
 =?us-ascii?Q?28q6RyUfrw287Phq9bjdiGBQ2Fd3nkglCWbKjNFz/KtVq0idFeYkLObA0YM4?=
 =?us-ascii?Q?+tSGhPfCYMzBDmLJ2YD5Tha/bbZTQftpl19zUkiGrx4Y9E8sTQFPCnqCei7+?=
 =?us-ascii?Q?dGbCWQvO9c16EYoreGvK6ArFTU564SEMOxyz6BRP+jZF5IkEitHFqNsAAtMG?=
 =?us-ascii?Q?lp0WSWqtylWbQAj/ZXqcMhrTHh0KTXPjEmCn3gkFFHAiDqbQL2SzQEV+LN/I?=
 =?us-ascii?Q?3WwOtl3HFRCuf64JHvOinLk82yv0I91jzJ73LNoofvJFIy6qZvKFIbMkymuT?=
 =?us-ascii?Q?i8LEJN7WfXH0dBF+3MAGxBbOuWZEYTDO6VhaCE8vXjJyxpO2HRcdg3TkjBEF?=
 =?us-ascii?Q?9jhvQXdERiSf77XJcURSsokd/jjRuu1CdR2YCQhGsww+HcUuOkAi9emquAAZ?=
 =?us-ascii?Q?ROzzJi6WEkbX3B0iNillSEqs1tO2Twwi/wX5h/ANrKv4IzhL3APypdjbd1Ke?=
 =?us-ascii?Q?d/JoFjNlGdHxqwbuH54si3EA8KXljwS56IEuqJo4ULJwgxODNg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(82310400023)(376011)(1800799021)(7416011)(36860700010);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 12:40:10.9373
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f999212f-444f-4be4-65b4-08dc91ef4a56
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7617

As there is no external caller for snp_issue_guest_request() anymore,
make it static and drop the prototype from the header.

No functional change.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/sev.h | 7 -------
 arch/x86/coco/sev/core.c   | 5 ++---
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index f0e43ca5e424..f16dd1900206 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -435,8 +435,6 @@ void snp_set_wakeup_secondary_cpu(void);
 bool snp_init(struct boot_params *bp);
 void __noreturn snp_abort(void);
 void snp_dmi_setup(void);
-int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
-			    struct snp_guest_request_ioctl *rio);
 int snp_issue_svsm_attest_req(u64 call_id, struct svsm_call *call, struct svsm_attest_call *input);
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
@@ -504,11 +502,6 @@ static inline void snp_set_wakeup_secondary_cpu(void) { }
 static inline bool snp_init(struct boot_params *bp) { return false; }
 static inline void snp_abort(void) { }
 static inline void snp_dmi_setup(void) { }
-static inline int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
-					  struct snp_guest_request_ioctl *rio)
-{
-	return -ENOTTY;
-}
 static inline int snp_issue_svsm_attest_req(u64 call_id, struct svsm_call *call, struct svsm_attest_call *input)
 {
 	return -ENOTTY;
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 0112e4c5dbcd..5f5339eda4a9 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -2442,8 +2442,8 @@ int snp_issue_svsm_attest_req(u64 call_id, struct svsm_call *call,
 }
 EXPORT_SYMBOL_GPL(snp_issue_svsm_attest_req);
 
-int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
-			    struct snp_guest_request_ioctl *rio)
+static int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
+				   struct snp_guest_request_ioctl *rio)
 {
 	struct ghcb_state state;
 	struct es_em_ctxt ctxt;
@@ -2505,7 +2505,6 @@ int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *inpu
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(snp_issue_guest_request);
 
 static struct platform_device sev_guest_device = {
 	.name		= "sev-guest",
-- 
2.34.1


