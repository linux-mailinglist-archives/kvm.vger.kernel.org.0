Return-Path: <kvm+bounces-15272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 90A098AAEEC
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 14:59:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47C3D283B7B
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 12:59:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B42D126F3F;
	Fri, 19 Apr 2024 12:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2vpqsrbD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2047.outbound.protection.outlook.com [40.107.93.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E016C8595F
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 12:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713531558; cv=fail; b=aeupnXYIcmVG4yyRPmsfEAGR5ngNzbBYi1NBdkEfl2xTH0AEUOqZNl9SGrfUJmhJXt4zqOCK7XIyx1o7a3AZxZ58wmVQCKZRR6pVAV8DnRkAmUwIUatMHy5MWtbDkpOjf+9KmpQmcQGrfSg/nLmHHJBJ7kylujkzYPEGasYkXUE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713531558; c=relaxed/simple;
	bh=Yl9EyhtFxlH+gveDrr7JcdVMEJJTNVCydKs8tqzgvpc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RTvoA4nSoO+IFK1t1AcYkuZxIq8p3xvxv1q4TpUmO7uPwUzrYsLnG8ilXknNae2NN2hsB/vS1NWZAKspbVCx53VEXpwzshtob84b6/Y/ZTCJXW3Dy0VOihTo0MaV1pejhb3orYUmR3M7W5y3uWH+B6BUhUMsaatdY6gmfZ/u7XA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2vpqsrbD; arc=fail smtp.client-ip=40.107.93.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H7qc+cYD5oCoBv/Lk/fWn/ymp6abPqDO7qjm58UA2DjSbJUqxhPjqVo/0P5TlfhV7n01qyGIEk5Fkebr6xxQQhLpvyShvNydQY5mKvM4XRq1m7Rvo2O8QGNDcIM02k2VlrxZg/LL4SjQlYGOY6WYVsK68rJd3kCsf0LYhCUwOBcAW4V6OC3bosdwUp4C8iekTpMHUZ8RrYUGI5aToeo9YZAGFoeolELrnWZzQS4sZ058yZUuicq7L15gaPy3pc9/rdOPr7ypzZE6Ub015DXz8kpwm9Z+AakPGX9owpF6b1TfaHgjgQIdiI5hrlswUEQMyHOsWqmcDBw46A1ydcUBFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ccc9K4l5iixIu1XBWG/iHLGqC9WfkP54y+M3cNVxpWU=;
 b=FkAaSupWo4mAVPuhJj4mC8/CoDxb0oEHDzKOA4izOuGGWSUmGbwrB6y7XMnWkYQw/wtqNKXPwR0Nhex0L5oOjXbL2Ex0K3KzLwmH/Zycf0irlumuDl2NsDaMVvN3fQF9XrmpxWrd/scKHQBi4NZ7bktaZc0pjKs6ECorQq2hvnBiIfc8LN2uWWvzWSO083oVq9MP0BuVDrXzCPtvnoFicc4/1eFJdYy2XIOPYQqb85nO8pIr2IPsAM6E4DPJISPpOT+NXFI4+9CWkHN1GFGDzfMC+7xwY6I4zNsFJ4gyq/jpSur9K8Ntn9oSL/XL0nnPRpb+I/uNonFvdyhKNdzmYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ccc9K4l5iixIu1XBWG/iHLGqC9WfkP54y+M3cNVxpWU=;
 b=2vpqsrbDK18dYmFAkzqQCi2Lb43JMzzKQ9Xuwrg/VvoC1r3KoO+YDOzhxdMrH+rFH7W1Oypo8E7ePOTAxL3qReGZLkBsLiVDowhJUmXNJAZEgi2gwQKP0vxd+PBafDo7MF+v0FSglQQVyqEbQIAFkhJNSW265DEZcIgthwDbV3c=
Received: from SA0PR12CA0008.namprd12.prod.outlook.com (2603:10b6:806:6f::13)
 by BL3PR12MB6401.namprd12.prod.outlook.com (2603:10b6:208:3b1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.43; Fri, 19 Apr
 2024 12:59:13 +0000
Received: from SN1PEPF00036F43.namprd05.prod.outlook.com
 (2603:10b6:806:6f:cafe::cd) by SA0PR12CA0008.outlook.office365.com
 (2603:10b6:806:6f::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.31 via Frontend
 Transport; Fri, 19 Apr 2024 12:59:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F43.mail.protection.outlook.com (10.167.248.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Fri, 19 Apr 2024 12:59:13 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 19 Apr
 2024 07:59:12 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests RFC PATCH 05/13] x86 AMD SEV-SNP: Enable SEV-SNP support
Date: Fri, 19 Apr 2024 07:57:51 -0500
Message-ID: <20240419125759.242870-6-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240419125759.242870-1-papaluri@amd.com>
References: <20240419125759.242870-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F43:EE_|BL3PR12MB6401:EE_
X-MS-Office365-Filtering-Correlation-Id: ffbd4300-278f-45bf-0ea8-08dc6070834d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZM04aoNRtDdtaoOccPA8836fnthA9n2p8bvdM/wRQsKFOsBHKHQHbR8SkCKvChyYAxZ+y67BWbYbz3Nob2YULxiryaYoAs1wi7MHD5TwUkO3zgERn7yHXQTsbjQUDo76cSSDLC0SGvUQ+fY/chCYmiRpf25G7r0z3qJzc0xGpp6f/J6nPmWAjmv5vtYW3Gx3DIADPytflrGICbx7/n6A+QOBZYUSL2ZUxOGYT3u77ONEmhw/z0lMc/hikU7nh3bOh4WmkjvYKAIIHtkGMvkZ15eYgmtzslGII0GjtYJIWfZk0JKIHICtJUMHrM3S4vZ4EebrF/A2MOFKvlYnI+npx/z32hc4yVcd9mzR4DfwJZg51Zmd1byq3IY50Fv8AOHtHK6iMopumGzd/Ohtw+F1Bbn7r0wLxvk8H60CpLHY8MCukyzRZTmhpYqeJsdMQvVFLKseNPQLhAkSmOMqE812yQ4hOSY9ql1K/4Kyui7hsXtwXOzjA8VPb1vmqwyA+xuukPH8DfYUFnE8ZlbuOoJv5dI0uywR5Sq/kXY5gchNLIEcI0fwcytolrQQmgkQaS2QRobylc1Cd9g6fT1EpvEh5QMlcZYH+MkBcbaC+KJ5D+sa3lTZ6jQA4eKqpXFaxykQu+8Uuzwj4MrtjufMVOUBnmNY0Wgcv//xE/NCkmYPwAnEtnkPVdynwampnRdOAoj5NmBUz1Nah5MUW21Fvc/SzrFd4w0Oz1DSb2M6ivVijWgI3hgEjEpcnq58HjVPomiC
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(1800799015)(82310400014)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 12:59:13.3986
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ffbd4300-278f-45bf-0ea8-08dc6070834d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F43.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6401

Incorporate support for SEV-SNP enablement. Provide a simple activation
test to determine whether SEV-SNP is enabled or not.

SKIP this activation test if the guest is not an SEV-SNP guest.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 lib/x86/amd_sev.c | 16 ++++++++++++++++
 lib/x86/amd_sev.h |  2 ++
 lib/x86/setup.c   |  6 +++---
 x86/amd_sev.c     | 11 +++++++++++
 4 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index ff435c90eeea..8af772ec09b3 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -89,6 +89,22 @@ bool amd_sev_es_enabled(void)
 	return sev_es_enabled;
 }
 
+bool amd_sev_snp_enabled(void)
+{
+	static bool sev_snp_enabled;
+	static bool initialized;
+
+	/* Test if SEV-SNP is enabled */
+	if (!initialized) {
+		if (amd_sev_es_enabled())
+			sev_snp_enabled = rdmsr(MSR_SEV_STATUS) &
+					  SEV_SNP_ENABLED_MASK;
+		initialized = true;
+	}
+
+	return sev_snp_enabled;
+}
+
 efi_status_t setup_vc_handler(void)
 {
 	struct descriptor_table_ptr idtr;
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index b5715082284b..4c58e761c4af 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -122,6 +122,7 @@ struct es_em_ctxt {
 #define MSR_SEV_STATUS      0xc0010131
 #define SEV_ENABLED_MASK    0b1
 #define SEV_ES_ENABLED_MASK 0b10
+#define SEV_SNP_ENABLED_MASK 0b100
 
 bool amd_sev_enabled(void);
 efi_status_t setup_amd_sev(void);
@@ -140,6 +141,7 @@ efi_status_t setup_amd_sev(void);
 
 bool amd_sev_es_enabled(void);
 efi_status_t setup_vc_handler(void);
+bool amd_sev_snp_enabled(void);
 void setup_ghcb_pte(pgd_t *page_table);
 void handle_sev_es_vc(struct ex_regs *regs);
 
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index d79a9f86eda4..023aa6951183 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -331,9 +331,9 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	phase = "AMD SEV";
 	status = setup_amd_sev();
 
-	/* Continue if AMD SEV is not supported, but skip SEV-ES setup */
-	if (status == EFI_SUCCESS) {
-		phase = "AMD SEV-ES";
+	/* Continue if AMD SEV is not supported, but skip SEV-ES or SEV-SNP setup */
+	if (status == EFI_SUCCESS && amd_sev_es_enabled()) {
+		phase = amd_sev_snp_enabled() ? "AMD SEV-SNP" : "AMD SEV-ES";
 		status = setup_vc_handler();
 	}
 
diff --git a/x86/amd_sev.c b/x86/amd_sev.c
index 7757d4f85b7a..241e1472e333 100644
--- a/x86/amd_sev.c
+++ b/x86/amd_sev.c
@@ -69,6 +69,16 @@ static void test_sev_es_activation(void)
 	}
 }
 
+static void test_sev_snp_activation(void)
+{
+	if (!(rdmsr(MSR_SEV_STATUS) & SEV_SNP_ENABLED_MASK)) {
+		report_skip("SEV-SNP is not enabled");
+		return;
+	}
+
+	report_info("SEV-SNP is enabled");
+}
+
 static void test_stringio(void)
 {
 	int st1_len = sizeof(st1) - 1;
@@ -92,6 +102,7 @@ int main(void)
 	rtn = test_sev_activation();
 	report(rtn == EXIT_SUCCESS, "SEV activation test.");
 	test_sev_es_activation();
+	test_sev_snp_activation();
 	test_stringio();
 	return report_summary();
 }
-- 
2.34.1


