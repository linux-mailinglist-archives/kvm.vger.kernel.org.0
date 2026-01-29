Return-Path: <kvm+bounces-69507-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OHBkEVYAe2nKAQIAu9opvQ
	(envelope-from <kvm+bounces-69507-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 07:38:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B8AA3AC431
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 07:38:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0BD27301F332
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 06:37:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27E2A3793B6;
	Thu, 29 Jan 2026 06:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Dpc0bYwj"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010063.outbound.protection.outlook.com [52.101.46.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE602E6CC0;
	Thu, 29 Jan 2026 06:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769668665; cv=fail; b=fhix0Z47oyM1dkGFBmOckAhXVLcWsxr6IHT4mDJm9QdYisOcLEW8/u2hBTFlRJB32GoRB4UGtuFsKITr3zs6e/2J/3T+QMIIHUhMA6ZK4t798zB1vvllBjSnzVmcAX4CLVI6rZWWgRvIR0h2wLCH7Gir7YOYSXo8ou/yekTgssc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769668665; c=relaxed/simple;
	bh=f6xCj9BUada2H5U3ZH+PiIWjdZ/ywRpSMFLrJGbzSv0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZrUbkGRUjE/ckXHcpxy8Vo4neJlKiw6HG/wBbzW0n/aqGHUfBLhEiKb3RxUXxQw/dfou2BmD0hINISnbiPU2rITah4a/bizd1PZoL+csRhD85b2EojnfBtZ/va9ywfyU2G3q3aVeS1QHH+aHz/ag+fPOK+iMbVwljEWd/Iy+zJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Dpc0bYwj; arc=fail smtp.client-ip=52.101.46.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Twlf5W7fwu3FlE/Tf5HdTNRWO3M30Y8+b6Dqc29SQRWYWd/SfvLXDL4yByJ0gSP86AC2UarZl+DQ1x+UFuwv6qlc/6PdOBBBctBPI0C00aeQceahNTXg9B4/yyKcSBoixdG39SU+mJQD2kWwJAGCvt87SoCkv9ZDc6m/dDAYYIh/93pgrBSSGjIS7PdqXD2D2XRgys0CpZUxEiPofXPwzFqux9WooeggaeEuBLPj4dk1gIcvRIVsuRrZCaR4py0u+9zGzDVAvgAhCj0SY+k34bb6XjAzVmUAiNzY+wRmKNUmTDlHxG0ElORGVFSMlZwLPdIERN+pKjqp77sHGhjegg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJGu1Ag9pdgB9vosUGAIPstl2H5/S6CAoNI0oM6yPbo=;
 b=rDEoiZk2UqFnG5g3FQju9qFPNC+gPhDTWSJu8+HUE3GyKLD5h+lkzSwxmzcihc0jkjrmD2BXC+5tojuUlSqJCVXHOHsl8c7u3GptLFPtkHrVuu4lxOMwGyEYKb/oNnxJdXszIs1huHh+kQVqX0glstMcsJupQhv/w7npr1DZ2q1GmQXxxJ/JeMG3psKvvlW1GqZOSiHTTSW5ycWbJ5dlGgfRI8uYHf5bjXdr2EY4HGaF5wMFCGM8VDZCcu+kRwEE/quXnSv0iH+9A3PtAK1YO4pFLsyx/qUR/RDtZG1O1U+cVSJRvpKJeoH2s80vb1GbE9DNOka/p6ApmQtxRM68bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJGu1Ag9pdgB9vosUGAIPstl2H5/S6CAoNI0oM6yPbo=;
 b=Dpc0bYwj2sDYuPhHrJ8w8Tg3dyFVXciU+tUqWEGNF9MuJ0bVqJhrrwpK2Y6v4gubUMLkTUBGd/sTF9DZUE5h2CdeSISfuABwIaizTeIJVHUCryW+qVQZnkqdYm+kKwdoMuynEx8KywwAphwhCKCxBgKugtItIckym8OYihrKF0Y=
Received: from BN9PR03CA0577.namprd03.prod.outlook.com (2603:10b6:408:10d::12)
 by LV9PR12MB9782.namprd12.prod.outlook.com (2603:10b6:408:2f2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Thu, 29 Jan
 2026 06:37:40 +0000
Received: from BN2PEPF00004FC0.namprd04.prod.outlook.com
 (2603:10b6:408:10d:cafe::c7) by BN9PR03CA0577.outlook.office365.com
 (2603:10b6:408:10d::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.8 via Frontend Transport; Thu,
 29 Jan 2026 06:37:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF00004FC0.mail.protection.outlook.com (10.167.243.186) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 29 Jan 2026 06:37:40 +0000
Received: from purico-abeahost.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 29 Jan
 2026 00:37:34 -0600
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<xin@zytor.com>, <nikunj.dadhania@amd.com>, <santosh.shukla@amd.com>
Subject: [PATCH 1/7] KVM: SVM: Initialize FRED VMCB fields
Date: Thu, 29 Jan 2026 06:36:47 +0000
Message-ID: <20260129063653.3553076-2-shivansh.dhiman@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260129063653.3553076-1-shivansh.dhiman@amd.com>
References: <20260129063653.3553076-1-shivansh.dhiman@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FC0:EE_|LV9PR12MB9782:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bb00716-48ff-4603-cdb9-08de5f00e671
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lra9LwmpfmO620oVtv0bQLzBbyKmtq9JWzpzZI16omDe8YED/B8i8tIUGEm0?=
 =?us-ascii?Q?B3JiH3Lhh7jTtuYobwrm27jOeMWrwU/xiXkZRJ2/kK5lma5fyNS2bzLMjKWS?=
 =?us-ascii?Q?vXjVmuIQA0donYeKkPOed2d4y1jmHlTt+fxWbbe2qaghAKnBiqek0KZcfhhk?=
 =?us-ascii?Q?HPgD6a6wuAMNgvKHsbWfsPJlokhKXilVuYLGApygaj5FX4e5G6Daw9gFOzWk?=
 =?us-ascii?Q?diH2vIvXYtEhzfWz+X2+h5NPaLmVBCAYtp4i9tSAxqHG4l/fs7Q2vM68t+oW?=
 =?us-ascii?Q?mIUbnaz0b+1ZOwd9CuyoRXJtli/onfHEhqRxmvYnQdp7VtaOo1UddCVcdOvy?=
 =?us-ascii?Q?qG4fkWyTVD1TDBDCsYgqfu3Qoqt21WASVDMAi10FpbOL+huW1QVoU+BewGh8?=
 =?us-ascii?Q?lqUhkPxBonDb5BC2zLJ7iDzHyT5YqejbocHo3ucGCGGKox8yBaxy+Hf/gBPq?=
 =?us-ascii?Q?eU5Viz/XKPZP7OUVnSTHANNbSxUTcfaOJ/GB2CHqBjpF10KR7G/c0nyXrXg2?=
 =?us-ascii?Q?ce50NIbX6MUDkIj3azFYp5sDFN5ypFJ1Z1iJBLsCh29YWrnBwOUYWFuWHyzW?=
 =?us-ascii?Q?HEBjvjiiNjCbK8fifW0Dz/acWlZwRctpGWWpFx7eRwonirWMfb0BUyTGU9q0?=
 =?us-ascii?Q?9fYYGUV5KEqvjUUQSPZP8adnxaK0xFlBq+t47DRfIIcnFOZgalxm32LI8bYs?=
 =?us-ascii?Q?LQt0iIm+gOkGzYQGEhevyG0ZheSeu06Yz09xbxiTAokGDQvmyBDRMepEnRNF?=
 =?us-ascii?Q?D4FfL1njNqXWg5AU8vG30k7Bk/5ZTCpUGEzFqOS0G3i1ZcLvLv9uKcHGibFG?=
 =?us-ascii?Q?Vo1IguNokiOE6VNtEN2L/Z9XvgfZGfaiqhtyXMYZvz27UcuhVzCZDZ2oYsRu?=
 =?us-ascii?Q?fIb4sSArbuHYG+exeYf1KfqjIZaUmcAS9Gn5qIxR5YNhfzgEs6L1fR3EZqHc?=
 =?us-ascii?Q?zz1h5Uj0HLRzv/A+37dXkBEkzTMkgsgpz6GgGuZTC/9lBtjLaFQ7uenX9OtO?=
 =?us-ascii?Q?GPqeioY6doxvMAkbvYXDvadpIPfuh8sJW1z0IutjzMyCE4uVv3NCiPshY/G9?=
 =?us-ascii?Q?e9GQoC6ldeKOl7gBqtq41n1ooSJHpIwaOs+o7hcsAOb1tXjtSsXqZ6D0GT+x?=
 =?us-ascii?Q?Vl8fPWFapfsZ7Vf68uZFJyC77T9qyrJyfLSqJ9MlmNKp8AcWFaNsOqLlewi2?=
 =?us-ascii?Q?RgJO11L/1ZTw5pptHU64uVNpBaz3f9r7trGXtuZcgW0N3sxfiG51LpJNNB3U?=
 =?us-ascii?Q?1i87fJUcUUDy9TsVC8c7B1gt2pldfVIUXz58ms0ffDHfyrNUDr8ZJ4dNyZBr?=
 =?us-ascii?Q?lPvhR2Ork3IeLILRe47YiibKjahoHInK5oU8wnjtpu3Su192bHvDcpzFsms+?=
 =?us-ascii?Q?7EYZXsjckO0M8dC6f4dPvCGU3Q7qlpssvCKhZTVfG+tjxkTuWaEq1bBh5+S5?=
 =?us-ascii?Q?nOLFv9YllJ96iHKWno+OKUe+ftVaQ1yf0tgmBJxoQg77sQL6LoH0jdlF7xZZ?=
 =?us-ascii?Q?+Mn5jT7UETnL+9zjWdPsdLmdFtCzwq9FphsAWYzcPlvPDDrABKcOgHuX6tXP?=
 =?us-ascii?Q?hSWFWV2OnGewcQ5EMdYo+tlnbLXnecRDJtkeqB5DxH1nA0H/q0KkSrB8YU4U?=
 =?us-ascii?Q?TLPLefZ/7sUKMuLCsomXbtWXP9PdWKLDYeiyn0aXq9BM//io1ftFa+DTPLe7?=
 =?us-ascii?Q?mHR2wg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 06:37:40.3352
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bb00716-48ff-4603-cdb9-08de5f00e671
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FC0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9782
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69507-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[13];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shivansh.dhiman@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,amd.com:dkim,amd.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: B8AA3AC431
X-Rspamd-Action: no action

From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>

The upcoming AMD FRED (Flexible Return and Event Delivery) feature
introduces several new fields to the VMCB save area. These fields include
FRED-specific stack pointers (fred_rsp[0-3], fred_ssp[1-3]), stack level
tracking (fred_stklvls), and configuration (fred_config).

Ensure that a vCPU starts with a clean and valid FRED state on
capable hardware. Also update the size of save areas of VMCB.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Co-developed-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
Signed-off-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/svm.h | 33 ++++++++++++++++++++++++++++++---
 arch/x86/kvm/svm/svm.c     | 10 ++++++++++
 2 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 17f6c3fedeee..a42ed39aa8fb 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -165,7 +165,10 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u8 reserved_9[22];
 	u64 allowed_sev_features;	/* Offset 0x138 */
 	u64 guest_sev_features;		/* Offset 0x140 */
-	u8 reserved_10[664];
+	u8 reserved_10[40];
+	u64 exit_int_data;		/* Offset 0x170 */
+	u64 event_inj_data;
+	u8 reserved_11[608];
 	/*
 	 * Offset 0x3e0, 32 bytes reserved
 	 * for use by hypervisor/software.
@@ -360,6 +363,18 @@ struct vmcb_save_area {
 	u64 last_excp_to;
 	u8 reserved_0x298[72];
 	u64 spec_ctrl;		/* Guest version of SPEC_CTRL at 0x2E0 */
+	u8 reserved_0x2e8[448];
+	u64 guest_exit_int_data;        /* GUEST_EXITINTDATA 0x4A8 */
+	u64 guest_event_inj_data;
+	u64 fred_rsp0;
+	u64 fred_rsp1;
+	u64 fred_rsp2;
+	u64 fred_rsp3;
+	u64 fred_stklvls;
+	u64 fred_ssp1;
+	u64 fred_ssp2;
+	u64 fred_ssp3;
+	u64 fred_config;
 } __packed;
 
 /* Save area definition for SEV-ES and SEV-SNP guests */
@@ -472,6 +487,18 @@ struct sev_es_save_area {
 	u8 fpreg_x87[80];
 	u8 fpreg_xmm[256];
 	u8 fpreg_ymm[256];
+	u8 reserved_0x670[568];
+	u64 guest_exit_int_data;        /* GUEST_EXITINTDATA 0x8A8 */
+	u64 guest_event_inj_data;
+	u64 fred_rsp0;
+	u64 fred_rsp1;
+	u64 fred_rsp2;
+	u64 fred_rsp3;
+	u64 fred_stklvls;
+	u64 fred_ssp1;
+	u64 fred_ssp2;
+	u64 fred_ssp3;
+	u64 fred_config;
 } __packed;
 
 struct ghcb_save_area {
@@ -542,9 +569,9 @@ struct vmcb {
 	};
 } __packed;
 
-#define EXPECTED_VMCB_SAVE_AREA_SIZE		744
+#define EXPECTED_VMCB_SAVE_AREA_SIZE		1280
 #define EXPECTED_GHCB_SAVE_AREA_SIZE		1032
-#define EXPECTED_SEV_ES_SAVE_AREA_SIZE		1648
+#define EXPECTED_SEV_ES_SAVE_AREA_SIZE		2304
 #define EXPECTED_VMCB_CONTROL_AREA_SIZE		1024
 #define EXPECTED_GHCB_SIZE			PAGE_SIZE
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f4ccb3e66635..5cec971a1f5a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1110,6 +1110,16 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
 	save->idtr.base = 0;
 	save->idtr.limit = 0xffff;
 
+	save->fred_rsp0 = 0;
+	save->fred_rsp1 = 0;
+	save->fred_rsp2 = 0;
+	save->fred_rsp3 = 0;
+	save->fred_stklvls = 0;
+	save->fred_ssp1 = 0;
+	save->fred_ssp2 = 0;
+	save->fred_ssp3 = 0;
+	save->fred_config = 0;
+
 	init_sys_seg(&save->ldtr, SEG_TYPE_LDT);
 	init_sys_seg(&save->tr, SEG_TYPE_BUSY_TSS16);
 
-- 
2.43.0


