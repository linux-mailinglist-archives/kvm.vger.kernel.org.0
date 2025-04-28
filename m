Return-Path: <kvm+bounces-44596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 370D5A9F8F2
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 20:56:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 824711A8599E
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 18:56:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F00F32957D2;
	Mon, 28 Apr 2025 18:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tE7X3LMO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2086.outbound.protection.outlook.com [40.107.101.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57BB26F478;
	Mon, 28 Apr 2025 18:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745866568; cv=fail; b=bwg4XCZI3xuAkxKqHX10ZKRYtFi0oTC1pD5NyVCb/NVp4XBzk1Sd8hKGAkGIC2dprHihOCbc5kN6T2ob0p8ABXd4CgdLFFDWFFaJ3omz2GbTUcTMv96Rax7s1bYbUK3ikj9FVq80s82ePhiRZ1OuCWaJkl0Jm/MdPVTTeWqeAeo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745866568; c=relaxed/simple;
	bh=rGzQkblUQJ58ZDa090HkYLMIru3SHdA9DONBOqvqIiA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZHLrwwSp/a7uZ+nbny93mm0z3SdzpJ+vspIf22AFzlV/33jg7FpWc3m3M0yBleaYj2WJQyImvFx6nnT4pMSZETpF0coceDCxQgha9nPUXlSbsrURIaHyq6G+E0jWxgtRwnQkHqTStXv68yHTan0DeT5hvYlPlhmUjYNbDn/JseA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tE7X3LMO; arc=fail smtp.client-ip=40.107.101.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rSCG80+3ZNUoEnvY7mrhycMfTH+VZuWm2PL2H3NV1w1V5IuXyy4XMiXx7VZVwkstYWl+7YHUvz+J4vhP1ZAoI0d7gBYF2WARw185szyL8HSX8acdfQTPEBwo5MG0gRJdFvTa6YtgQPkk57EkqQms+7hHHrS1cx7qNz7eI8DBh+DF7gKTMfqjD0I58EPXatMEdaCarvk7YhSh4lAzevvica38lOzd3qDO/lhC6UA4wvNWKNgrj1WCDADs9kbYgOlZsI183BqvkW7hJjf+YdHHsKPyRQrWohvqVclUnmeJfIfnvJPXyn00rtT/Vlz7SY/d3/4WVJfMMPSNdgJm0ihycw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=orO2zDYqEWC6sv1W9FavRWeI0EJwnWu2GzMIp3xJRXU=;
 b=JtIu+ANEIN/WgM/XFrc1GoouuXZ8Dkc7Jk6v8alLcMpQKRlhCa4zIRR6416yPz7vhFRwkEbiIJzwBZSlGzs0JynPFSB6Zze5F9Hhqnz3GIsspdZuxFx23tRZRtcR5c6p+oijNuA9Xkpy9NC5bUGBuzErpVeo9C5JD1pw8ivXzpRNXZ5lSnf+5S9fuCvgGFaXtj/XkBeuUQA4NjKY+dFtl81jWaaGPy2mq3yQVsuyB4keyTPnVidTF1KhuQ6lJICgrBw+xvDrSIxpPtHHh/XAy6ji6p6g96k9eXHkcc4TB8o+fx5Qk+pqxxoE3/qkYSfJMr0ByMc3RejSplyv3etCmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=orO2zDYqEWC6sv1W9FavRWeI0EJwnWu2GzMIp3xJRXU=;
 b=tE7X3LMOPGBA77A9t6HzKodvvB0r0lICuH/T+53humHYtNY8mrA7C/+8Z6gRRWIhtLCkJGQsr8ILp+3ZL0bbMaX4cSXbQzRmro3O4T75Xz+5SNxq9chGlDgLxz1Ief2cQFmKLEOh9bKnYAsPcSeGWKvYGWoKjlZjVvBTWoQtNd4=
Received: from MW4PR03CA0210.namprd03.prod.outlook.com (2603:10b6:303:b8::35)
 by CH3PR12MB8726.namprd12.prod.outlook.com (2603:10b6:610:17b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.33; Mon, 28 Apr
 2025 18:56:02 +0000
Received: from MWH0EPF000971E3.namprd02.prod.outlook.com
 (2603:10b6:303:b8:cafe::7b) by MW4PR03CA0210.outlook.office365.com
 (2603:10b6:303:b8::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.36 via Frontend Transport; Mon,
 28 Apr 2025 18:56:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000971E3.mail.protection.outlook.com (10.167.243.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.33 via Frontend Transport; Mon, 28 Apr 2025 18:56:02 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 28 Apr
 2025 13:55:43 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
Subject: [PATCH] KVM: SVM: Update dump_ghcb() to use the GHCB snapshot fields
Date: Mon, 28 Apr 2025 13:55:31 -0500
Message-ID: <8f03878443681496008b1b37b7c4bf77a342b459.1745866531.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.46.2
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E3:EE_|CH3PR12MB8726:EE_
X-MS-Office365-Filtering-Correlation-Id: d498a802-3e34-4757-6250-08dd868652ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oO574gOmyNiGQDOv2IslB/zS3V51WpuspnwD/TaBOOCNFqA4f/IdK4mJqzh6?=
 =?us-ascii?Q?bZJJ1BDYrjsIcrnx6BDbxK9K1ilf0eM0tQAMz1fhLYFytmooTE6DfR5/uxkx?=
 =?us-ascii?Q?kJd9eNkuW8LOhoCzulpII/LnuxC9VOHc4PNyvRWuw7Ak9D6A08hx9GMmGdlE?=
 =?us-ascii?Q?ANFgzsHwiz0OliQgU6aIpp9z1Z/eLg0QOY4rcfq6cjA7uRc+1Gw+M1T/oO8W?=
 =?us-ascii?Q?drFZ6vT9wk9lYpwkC/4/jyEG6MfHVZHuL5bWy0vSMCMIpbIjsdFxr3APEnDo?=
 =?us-ascii?Q?EWbXiXEANGD47Rle4CdbkOBx7Ir1sBtEtRcm2tA5owUvXOb4rTi3lYfzn2B/?=
 =?us-ascii?Q?JZd8/s3BkZ/aIeGqVZiunI6I2vry/2QD12YsE5mp5NNlAoozTaE8hUtPmW7a?=
 =?us-ascii?Q?0gzsAhjrjzxHEqHhgDOKzSc7TM0QWKyS1mzt5qmCppAQ+aCMZxvbKB+HXB6q?=
 =?us-ascii?Q?49dJYycdfKh0e2xxIVsJTGscy55C2XLD3/zNNMixkjLpAkWQnPAuPQt0ArWf?=
 =?us-ascii?Q?hdtllDEnsLAjP1ml+YqxtD7qxKSVBrSOebzdH7fqj8DEQSAbmy1ITukj47xV?=
 =?us-ascii?Q?rd+r1MNbwFRy2p47W743p9UBvJWNodU1gF5O8BI3TX2eThgs88p92yvMIrwG?=
 =?us-ascii?Q?yt1lbnKe2FJeDXf56HpTMU70juD0TQ//oDck50TzVLEVXC/2wLaVvA7zs+a9?=
 =?us-ascii?Q?hrfwRIC25XCvhVqYYyl/O6oQTSVq5DeR8ExmJosE8n6be4+sWAfg/iukDCx5?=
 =?us-ascii?Q?+NBJ4qN+0h1wG5nHGoxBXrCSmN1F8PjkpUwh7zdE+OkUBMhCwfChfkwtyhXO?=
 =?us-ascii?Q?jdAqNYDsHldaOAY2nXqD3brpeSWqsuUl226OtFNDcmqY160zRM1nSydGu9Ej?=
 =?us-ascii?Q?ZRU6xK50gl4XhVJWXTC6RGTAkFfMOSXg74UuqkZNFa0CsDQQLAAj5KENB5w/?=
 =?us-ascii?Q?zNvawWIC525Bp6R6JOG69z+rTF1gifs9qmULUIZVieQwMGUjWmOxLBylyxyC?=
 =?us-ascii?Q?9PHPUW5SMVTjd5T2u7H1K1EHevQ+vOXH6HpXgjYS3bKU2pEOpk3NXEJZxCCO?=
 =?us-ascii?Q?YHVI8V7bmOfUyuo9bLbWrNo6Ov8nrZ0XP/Lxrn2Gcubyd3v4DSMRss2qY0cL?=
 =?us-ascii?Q?2yCRyLqewNgwUhcJI7beJk6je+G6un4c4fbIG0snO4yu9pDU96/o/ZhJFmhv?=
 =?us-ascii?Q?T+fBSZfycJZV7CopNbeIjYe7WRoDyJtj5KaRk9F5eRMsVNx9v2IpCxs65ceD?=
 =?us-ascii?Q?DPOoAn3wNP2dOCNap9qbjqRlEpGd/xMw3VnTuC3YcLpbqHtJE/fTucE2yy5A?=
 =?us-ascii?Q?EnBH9qWNfjjaKhzcyxXBjicF+OojnF+9YoR+1M8G16uUsAGtt9rI/UaEagt2?=
 =?us-ascii?Q?JjKgpRh37cCBPOX0sRRx8vw3DJJgZNeV3M+wZlpjj0DcDj1cH+JK6JwZmyHJ?=
 =?us-ascii?Q?yKzsIuFYNdCJG5R6+KhLAuAAyT5YdP79hDHtV6zp3zzUs/LDFJh4GZ57Y3OM?=
 =?us-ascii?Q?4oUJ3UNdJvwMjo9eVkWbIjmme2hNEY1MTzqV?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2025 18:56:02.6629
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d498a802-3e34-4757-6250-08dd868652ba
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8726

Commit 4e15a0ddc3ff ("KVM: SEV: snapshot the GHCB before accessing it")
updated the SEV code to take a snapshot of the GHCB before using it. But
the dump_ghcb() function wasn't updated to use the snapshot locations.
This results in incorrect output from dump_ghcb() for the "is_valid" and
"valid_bitmap" fields.

Update dump_ghcb() to use the proper locations.

Fixes: 4e15a0ddc3ff ("KVM: SEV: snapshot the GHCB before accessing it")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0bc708ee2788..91e514d07f8a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3173,9 +3173,14 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 		kvfree(svm->sev_es.ghcb_sa);
 }
 
+static u64 kvm_ghcb_get_sw_exit_code(struct vmcb_control_area *control)
+{
+	return (((u64)control->exit_code_hi) << 32) | control->exit_code;
+}
+
 static void dump_ghcb(struct vcpu_svm *svm)
 {
-	struct ghcb *ghcb = svm->sev_es.ghcb;
+	struct vmcb_control_area *control = &svm->vmcb->control;
 	unsigned int nbits;
 
 	/* Re-use the dump_invalid_vmcb module parameter */
@@ -3184,18 +3189,18 @@ static void dump_ghcb(struct vcpu_svm *svm)
 		return;
 	}
 
-	nbits = sizeof(ghcb->save.valid_bitmap) * 8;
+	nbits = sizeof(svm->sev_es.valid_bitmap) * 8;
 
 	pr_err("GHCB (GPA=%016llx):\n", svm->vmcb->control.ghcb_gpa);
 	pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_code",
-	       ghcb->save.sw_exit_code, ghcb_sw_exit_code_is_valid(ghcb));
+	       kvm_ghcb_get_sw_exit_code(control), kvm_ghcb_sw_exit_code_is_valid(svm));
 	pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_info_1",
-	       ghcb->save.sw_exit_info_1, ghcb_sw_exit_info_1_is_valid(ghcb));
+	       control->exit_info_1, kvm_ghcb_sw_exit_info_1_is_valid(svm));
 	pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_info_2",
-	       ghcb->save.sw_exit_info_2, ghcb_sw_exit_info_2_is_valid(ghcb));
+	       control->exit_info_2, kvm_ghcb_sw_exit_info_2_is_valid(svm));
 	pr_err("%-20s%016llx is_valid: %u\n", "sw_scratch",
-	       ghcb->save.sw_scratch, ghcb_sw_scratch_is_valid(ghcb));
-	pr_err("%-20s%*pb\n", "valid_bitmap", nbits, ghcb->save.valid_bitmap);
+	       svm->sev_es.sw_scratch, kvm_ghcb_sw_scratch_is_valid(svm));
+	pr_err("%-20s%*pb\n", "valid_bitmap", nbits, svm->sev_es.valid_bitmap);
 }
 
 static void sev_es_sync_to_ghcb(struct vcpu_svm *svm)
@@ -3266,11 +3271,6 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
 }
 
-static u64 kvm_ghcb_get_sw_exit_code(struct vmcb_control_area *control)
-{
-	return (((u64)control->exit_code_hi) << 32) | control->exit_code;
-}
-
 static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;

base-commit: 2d7124941a273c7233849a7a2bbfbeb7e28f1caa
-- 
2.46.2


