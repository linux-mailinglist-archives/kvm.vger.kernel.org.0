Return-Path: <kvm+bounces-15271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEE1E8AAEEB
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 14:59:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99F27283B64
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 12:59:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B054C8624B;
	Fri, 19 Apr 2024 12:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QzfOtDcC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2B085631
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 12:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713531548; cv=fail; b=lAT+G+jsNREOD66PmCDP3BWEkxbRTQck4M6OH/LcFkS6waw4PXWBt1KaL3WfxbyKA+tSzcuLJ5CnurKdVmI7ip0wlUEBMdIo7PsipvsEZWN5qsHDRKBFb/WMlNrZCXkYisZFiv2UjUGtlB1ax/qd3SA5G3Ijwh3+vWJ6217ILpY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713531548; c=relaxed/simple;
	bh=TB5y/FVK6vMsYYA0u+m/BtBaoNDKHBtmZNdksMS+Ofw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bbc12irIO+yT+46QTbqLiA0e5Al2j22kRXG1yEmC4EDcSYgUlWWD7WNQTt3TBtzygDObzLRLbZTqoDVM3zr7y1gsCr9b2Hw0291vR8OAwAFPi3YbNzTmA08dNHei6XBFUSafFMsuzzFJR6j40ngsao9Qutmso1wHcnONoYQbT1U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QzfOtDcC; arc=fail smtp.client-ip=40.107.93.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQCw3k29OCnoQ+GXwsz6ukHBvAe1WPZY13yx7Gg5guBi46qodLh1l7+W6S/HpAzjve+mjqbgBhB/yLHeKWFWtNoPJX2FJnsB4iCptA8BgGDuga1anJbuJ1MtziYdssnckbsV9PBZ2uxmfEW/NVMf7e4L3gKZKsbAxxb3BRUSQBd0+ZwC23+4LJzovRi45qnuvOyZn2+SCTocj75tI4IRgZvbNa7j3SnPaIz6Ln2RHmg8eR2fSTUyQG/NPsJmV/oYVQk2JpcRzY+6uHSj9DEserlAN8ZlXEY+V4W4yJ/+UspKPaubY1YFBhDRUSVFl6ZxGa9TqoZR6/TXnfVCy6cajw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZscgyGl0PqcqsV7PmYgd7ckXX4NGNZ0XHTk8Plo3KL8=;
 b=SQZVrqHzsBvwjbsrrz+l4DNQlxt0Y1wAfin+PVjuRpWWEF+TjwJBjHDqxvLJJjrz4ErLzvtzHdJiDs3xl4f5gQ1kLNgrtW7t9W9tzFWi+yclAacoaoIWsFw97O1x7lTRdppJRYE27IiNlsbfal1WvDGMeHP95tOTof9M86F72AB6sEKGaypy6xfz9nXbPj/kpNAiZOA5wsiu0ai68t1YdUsHeIAYUAQi6GECzJNVUBxge3mb9427ybxGR0IZNj1rTJCxJdbUGn8n087qRVqUnr47GIzQg/muNmxsfZ0oAfYuYey5GGsAGBF3MYRLA62G4zmN3cmgs7iH9ds9/SE/gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZscgyGl0PqcqsV7PmYgd7ckXX4NGNZ0XHTk8Plo3KL8=;
 b=QzfOtDcCd/hdNrUeUMkUgXaojI4bhBvNm6gYggGt4JU3dFQ9mRSFjdhVGsYujImSFQgidGhEfwBuiaSjz8V5qyiVe/IiyMdoYMujwfnSl2leVCNguXw++jBMfVhyas2dJUluKqHIo8HtHIc8unKsehbwFLGDx3hvkBlUdgLmcv8=
Received: from SN6PR08CA0030.namprd08.prod.outlook.com (2603:10b6:805:66::43)
 by SA0PR12MB7001.namprd12.prod.outlook.com (2603:10b6:806:2c0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.42; Fri, 19 Apr
 2024 12:59:04 +0000
Received: from SN1PEPF00036F41.namprd05.prod.outlook.com
 (2603:10b6:805:66:cafe::cf) by SN6PR08CA0030.outlook.office365.com
 (2603:10b6:805:66::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.28 via Frontend
 Transport; Fri, 19 Apr 2024 12:59:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F41.mail.protection.outlook.com (10.167.248.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Fri, 19 Apr 2024 12:59:04 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 19 Apr
 2024 07:59:01 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests RFC PATCH 04/13] x86 AMD SEV-ES: Rename setup_amd_sev_es() to setup_vc_handler()
Date: Fri, 19 Apr 2024 07:57:50 -0500
Message-ID: <20240419125759.242870-5-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F41:EE_|SA0PR12MB7001:EE_
X-MS-Office365-Filtering-Correlation-Id: de55222c-94c0-439f-5856-08dc60707e22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8vb0xPrqLkfqNauoPV9z1xYcHB+49HwFdvpUa43LD7XTK26lJGp5i6F2jmIwdwdfjXG36In/U0Q5Sx7wA21OqCePqPqTpq0s1NxyhsIzTTK3PXICwtEAK6eVR9dRD0t9QX5RXA5xZ0XlzgwiK1QU5tIDdakdvYblFTbOuNLTCEfIbI1hXm1slCqgQf6sNO6/NNM7LJLfRTz6l60xD/gPaMdZghEKLZgGPr8uSI4kvdca6i0MDGzMR8gaFDZlu93Jm1AEVznoKLpHIRIOisjkElxthvUXV9IYzk0v7B8yvqeuAeklIGLirzE4WxKHpvPEYuIRosJ7UhSrvNcehAVyjRKWWJc3aLpOrpNX24VoE3JXZWd8TdTQfyOk4MKwEc/QSqICl2jVew3yuIxit1BjJvJZv3w2QHlI6r6rnDL6YSceZTKOpcK7HrjCmc5feB8k945o9fjKHQms93Hw0TLMBYRMCqqHvduI5/UEFYRASlgSSYTk11zaWqppb5c4cgBqK6KC8EKNqZN2qWbcDUZ/gxfSnF2l4Vq1eagy7AIisLhYCRHvwOMb9IEj1kBEyKg9t4ULwmd9jUNR4bolevj/8Z2r+OFcj24R004RYV5G47LwYS6Rul8bRXtDZtsR8jjhSrMyDRxw407mjh3vLUv1zwNnKCuRNjkLfpKo4AcKcU2hwBqet3wOviAcMMomjVw4v4mV66ymQ5y3+ahCDiiLJCIb/Dz0jbMUvRE4UhM8d7p3aZTQhFIMYH7k9IPHNH7w
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(1800799015)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 12:59:04.6989
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de55222c-94c0-439f-5856-08dc60707e22
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F41.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7001

Re-organize the existing code to include a common helper function
setup_vc_handler() to setup #VC handler that now serves as a common #VC
handler for both SEV-ES and SEV-SNP guests.

On configuring KUT with --amdsev-efi-vc flag, This setup_vc_handler()
continues to re-use UEFI's #VC handler. This will be useful
in understanding how UEFI modifies SNP CPUID table and also useful in
studying the behavior of OVMF's IOIO and MSR #VC handlers as well.

However, if one prefers using SEV-ES/SNP's #VC handler, then
--amdsev-efi-vc flag should not be passed during configuration.

No functional change has been introduced in this patch.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 lib/x86/amd_sev.c | 6 +++++-
 lib/x86/amd_sev.h | 2 +-
 lib/x86/setup.c   | 2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index 987b59f9d650..ff435c90eeea 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -89,12 +89,16 @@ bool amd_sev_es_enabled(void)
 	return sev_es_enabled;
 }
 
-efi_status_t setup_amd_sev_es(void)
+efi_status_t setup_vc_handler(void)
 {
 	struct descriptor_table_ptr idtr;
 	idt_entry_t *idt;
 	idt_entry_t vc_handler_idt;
 
+	/*
+	 * If AMD SEV-SNP is enabled, then SEV-ES is also enabled, so
+	 * checking for SEV-ES covers both.
+	 */
 	if (!amd_sev_es_enabled()) {
 		return EFI_UNSUPPORTED;
 	}
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index efd439fb5036..b5715082284b 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -139,7 +139,7 @@ efi_status_t setup_amd_sev(void);
 #define SEV_ES_GHCB_MSR_INDEX 0xc0010130
 
 bool amd_sev_es_enabled(void);
-efi_status_t setup_amd_sev_es(void);
+efi_status_t setup_vc_handler(void);
 void setup_ghcb_pte(pgd_t *page_table);
 void handle_sev_es_vc(struct ex_regs *regs);
 
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 65f5972adb29..d79a9f86eda4 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -334,7 +334,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	/* Continue if AMD SEV is not supported, but skip SEV-ES setup */
 	if (status == EFI_SUCCESS) {
 		phase = "AMD SEV-ES";
-		status = setup_amd_sev_es();
+		status = setup_vc_handler();
 	}
 
 	if (status != EFI_SUCCESS && status != EFI_UNSUPPORTED) {
-- 
2.34.1


