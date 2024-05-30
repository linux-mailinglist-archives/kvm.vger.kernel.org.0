Return-Path: <kvm+bounces-18407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EFC5A8D4A3D
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:18:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 200361C21C03
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:18:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9740217FAC9;
	Thu, 30 May 2024 11:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="35WQAj4V"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326F517E477
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067821; cv=fail; b=NgUaL+Zg1HYJ+t3u++Aa2Qe+Y/piGkwOfd+/VTmkNAelPM/Zm4p+4x88rV4VTt5CaQF57n/BUuqxmzijkHyCN0sqzSp3D+BrKXz6gX7EjDyLO1ahwwcLv+dT6ADlWRLYnqNP3lCvbY4Ze/uvC5XXxXDf/rgdRBald00lbL7lROc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067821; c=relaxed/simple;
	bh=6tqyp+tB0MOr7suZjIe9E35EltkKY7ejWIkMjUyPMes=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UhEjQSWtSr3l7bwm4N9J8g66WHcLoqQPfrjjZtUEQJYrOn+vsLFkT9iApn3WdNuvpbHgUvfCEGQKGk8tFqQ3r1DPJ6ZlYjAfOrwkR4hT8yLssx18qbOE2w2JTbxtvrm3QOeMZDCMH4YHfpT71MzxzoacXTb2nPh4pfkpH/EcSFM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=35WQAj4V; arc=fail smtp.client-ip=40.107.94.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=REgLEV0MHbtQiKU8alIeZ1Bibkxt8h+DowJbbC+/Ur4y+YxEZ4lQHf3JOv/d6vCBkGnzLgUrvQdZq+D1pqK8yhZPd8DyZBXq82KXve34w51XvbOoDozDizNwf6sTuGRT+PWEyDUtX1vwd8BRBYYAHdZhfMbWiOLa7AGvMM7wLFFf4dJ1DsXdoW4S/GCeGrqdoGyj67ci1TxwODcVcngj9Cgl/PfwZn75TTDEk8r3RaBz4txIba84O3yShBanoFALAOmUkSpHKbZeELvdV/zmvkSVFbfRBn/89WRr5Yd/owdFMpbAn3gpstyfqorQmFTnUIBXwyOcAH6lG0tASYd1rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=myz/OvrCeXJ+Ohz2p34NR0s0hNu/t1UoCES5N6izqV4=;
 b=S7A7y8UmsGGKSNtqPweWGO6TQagxCm/m9Hw683JMTWfhwHInfIxFP+ZzPoENO1OyD4Jxv1nEWbVPpps859cFmKL5pkczmS/cMBanUysPb7Yi0l+6zsWi3vK4Ul5xT9HpWkIIEENLFS8b/nYaw9vMwdYqm/pl/3MMOCE4lsTXbtS/4tnmATdd4iRTyplcIOfR1Wtxo+XoOjhjsqS76C40036OcaAZQ2QApig3Rl8N/49J1TxcNzJXklf/F2yxTdw3LgwUj2aCFhxXLnF/yv6hFfSs3GI8gC/7BLzxG9nbZ43WTMpgWL/9Wzv+kFvfVTuXyDv7nmyfwrzY22xzDhK7hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=myz/OvrCeXJ+Ohz2p34NR0s0hNu/t1UoCES5N6izqV4=;
 b=35WQAj4VtZrvY7flbQDixetU4rYfJ+M3YBkOhJJb4hvoqo+0EObS6UUsXkh+oVcyfj0G96jdUW00hocRziGCI5FZsZfU4A+OlsCqtrCo9NCnBwK2CGjuPZjwm6RPyP7rB0wbcyN2FDmMWb/gqCY/60MveJi9GChdcmP85AufpmE=
Received: from BN9PR03CA0763.namprd03.prod.outlook.com (2603:10b6:408:13a::18)
 by SN7PR12MB6982.namprd12.prod.outlook.com (2603:10b6:806:262::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Thu, 30 May
 2024 11:16:58 +0000
Received: from BN2PEPF00004FBF.namprd04.prod.outlook.com
 (2603:10b6:408:13a:cafe::15) by BN9PR03CA0763.outlook.office365.com
 (2603:10b6:408:13a::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.18 via Frontend
 Transport; Thu, 30 May 2024 11:16:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN2PEPF00004FBF.mail.protection.outlook.com (10.167.243.185) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:16:57 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:57 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:56 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:16:56 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 20/31] i386/sev: Add support for SNP CPUID validation
Date: Thu, 30 May 2024 06:16:32 -0500
Message-ID: <20240530111643.1091816-21-pankaj.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530111643.1091816-1-pankaj.gupta@amd.com>
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBF:EE_|SN7PR12MB6982:EE_
X-MS-Office365-Filtering-Correlation-Id: 05576c1d-3b98-421f-10c4-08dc809a04f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|1800799015|36860700004|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XJmNklQ27txhHDYsrTOdfi/nLHYpKGjiO1vV7Q29j0szCEKHFWCeGksxPkx3?=
 =?us-ascii?Q?eBqvEv8UVsfPCkDBdqRi/UzJcOIDC6Vc7f9E2n5MfXudUa8ZyedokJBNPL+J?=
 =?us-ascii?Q?cev/IDA1aTlxgTspfbQhCoWXbfX95P2O7avoo17ce2YJ1ZNUz/Cczn0hY6lt?=
 =?us-ascii?Q?Vw3bt0Wq+8PvW9BVjiQJJDjX5wEBaNr/EB0OWWQPLuwV7p0+fR5FHY26/Kh7?=
 =?us-ascii?Q?0DLB8j6cA7NDBsJ4YJ0rGHw9a7OgyMR8o+m950Ijf3jxZnmAdQFp8sE+1+pq?=
 =?us-ascii?Q?896w5dqhojrMA6UWU2bvgHvJprU37FiZKHLokQ5gaOrnH7G2LzbQrRj81VTa?=
 =?us-ascii?Q?q+zKYnzLYgcfIojLVZBRYsLfgzvoYEShjz/5h/LannueCr4xKTvGsp/pbiJs?=
 =?us-ascii?Q?cr4PPd2RPziN9eG9J8WYSy/56bDfv8YGZCw3TuFVmdHz7wZgMzubKgK813Le?=
 =?us-ascii?Q?SQtdHGCAuNIlDZPrGDJj1EcyWMyOs0mo2w/ETncqUvHycd4ebYXo42ijd0e0?=
 =?us-ascii?Q?x+qSoIu8a36PCISt3gWsuz2QVtenAUqzRSoI/e43muMIHcqjIxnlkN9elnHB?=
 =?us-ascii?Q?pZw75CKLiN4W7I+Q4BkgOvF0N+V2btxkaC3WIF4XAA6LTj9ZOa5Q1ErxfT1h?=
 =?us-ascii?Q?M1sPxitUZ5V0BB/t5JjFPO/MSdjzhCVgDMgK69IXktwXxZoj3bmRjHAn2H86?=
 =?us-ascii?Q?E/usJ0DzkIntSvlAOynaYltMtHxSr3e/q2MVpHhYQt3uuxFFed3LNAEeC996?=
 =?us-ascii?Q?HJTRXTE9XZnmzwBVlfouIySL0zeOgBdpQuztKvjQbIq7O3UInDM8zeNxzlCo?=
 =?us-ascii?Q?shBnSGoYSErJFkzduNKC2zfOqR+WWNDNHxqq7dpztlvzlWj8s3OGB5yjItqY?=
 =?us-ascii?Q?7nXoCHXYCRs4ktKtOC3W7HI0MPSqJIef263DMJ88OMFSfdNq+562Mi3XXFoi?=
 =?us-ascii?Q?lwqO8B/nVRzwD5znc2zEn0fscJrGuD0xJDjVQr3UQmfnr2OWG8Wf6zqbQUcQ?=
 =?us-ascii?Q?Dnvx+01gN8+2q80rPoY1m7J2TSdeMydNSPPrFsdvaIMwzcXM0C1Re7GGdH82?=
 =?us-ascii?Q?5/oDYBv1oWgi5jbekCiBH00GhwlxXwEPmu4/nv5HUfDhR6MepPevoemnAoBD?=
 =?us-ascii?Q?GhjnGh/f6JSn/XKlGELsMJTQWP2570MjCwHt/zaqmtYOxKwI8km35dInk/KS?=
 =?us-ascii?Q?0HxkGOlCeRRTLnW3MGEayHMyQ7wlIXncVMWUFzAZSSAWwKQ7qgUXwh1AsQ0U?=
 =?us-ascii?Q?JmDpwJAZPQ9TFFGTu2GSr1O2pukKnSRgUHqOF/hNkxRAj4HToOPPXK/+zyZ1?=
 =?us-ascii?Q?KTUCONLV2Y+50pTV62O49qibaVGh6lHJYO9MdW2etjih3nHv9pI6Iij8MK57?=
 =?us-ascii?Q?O0EC9Rv6xSk49oYbVAYYPxeqid6O?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(1800799015)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:16:57.5984
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 05576c1d-3b98-421f-10c4-08dc809a04f8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6982

From: Michael Roth <michael.roth@amd.com>

SEV-SNP firmware allows a special guest page to be populated with a
table of guest CPUID values so that they can be validated through
firmware before being loaded into encrypted guest memory where they can
be used in place of hypervisor-provided values[1].

As part of SEV-SNP guest initialization, use this interface to validate
the CPUID entries reported by KVM_GET_CPUID2 prior to initial guest
start and populate the CPUID page reserved by OVMF with the resulting
encrypted data.

[1] SEV SNP Firmware ABI Specification, Rev. 0.8, 8.13.2.6

Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 target/i386/sev.c | 164 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 162 insertions(+), 2 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 504f641038..4388ffe867 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -214,6 +214,36 @@ static const char *const sev_fw_errlist[] = {
 
 #define SEV_FW_MAX_ERROR      ARRAY_SIZE(sev_fw_errlist)
 
+/* <linux/kvm.h> doesn't expose this, so re-use the max from kvm.c */
+#define KVM_MAX_CPUID_ENTRIES 100
+
+typedef struct KvmCpuidInfo {
+    struct kvm_cpuid2 cpuid;
+    struct kvm_cpuid_entry2 entries[KVM_MAX_CPUID_ENTRIES];
+} KvmCpuidInfo;
+
+#define SNP_CPUID_FUNCTION_MAXCOUNT 64
+#define SNP_CPUID_FUNCTION_UNKNOWN 0xFFFFFFFF
+
+typedef struct {
+    uint32_t eax_in;
+    uint32_t ecx_in;
+    uint64_t xcr0_in;
+    uint64_t xss_in;
+    uint32_t eax;
+    uint32_t ebx;
+    uint32_t ecx;
+    uint32_t edx;
+    uint64_t reserved;
+} __attribute__((packed)) SnpCpuidFunc;
+
+typedef struct {
+    uint32_t count;
+    uint32_t reserved1;
+    uint64_t reserved2;
+    SnpCpuidFunc entries[SNP_CPUID_FUNCTION_MAXCOUNT];
+} __attribute__((packed)) SnpCpuidInfo;
+
 static int
 sev_ioctl(int fd, int cmd, void *data, int *error)
 {
@@ -801,6 +831,35 @@ out:
     return ret;
 }
 
+static void
+sev_snp_cpuid_report_mismatches(SnpCpuidInfo *old,
+                                SnpCpuidInfo *new)
+{
+    size_t i;
+
+    if (old->count != new->count) {
+        error_report("SEV-SNP: CPUID validation failed due to count mismatch,"
+                     "provided: %d, expected: %d", old->count, new->count);
+        return;
+    }
+
+    for (i = 0; i < old->count; i++) {
+        SnpCpuidFunc *old_func, *new_func;
+
+        old_func = &old->entries[i];
+        new_func = &new->entries[i];
+
+        if (memcmp(old_func, new_func, sizeof(SnpCpuidFunc))) {
+            error_report("SEV-SNP: CPUID validation failed for function 0x%x, index: 0x%x"
+                         "provided: eax:0x%08x, ebx: 0x%08x, ecx: 0x%08x, edx: 0x%08x"
+                         "expected: eax:0x%08x, ebx: 0x%08x, ecx: 0x%08x, edx: 0x%08x",
+                         old_func->eax_in, old_func->ecx_in,
+                         old_func->eax, old_func->ebx, old_func->ecx, old_func->edx,
+                         new_func->eax, new_func->ebx, new_func->ecx, new_func->edx);
+        }
+    }
+}
+
 static const char *
 snp_page_type_to_str(int type)
 {
@@ -819,6 +878,7 @@ sev_snp_launch_update(SevSnpGuestState *sev_snp_guest,
                       SevLaunchUpdateData *data)
 {
     int ret, fw_error;
+    SnpCpuidInfo snp_cpuid_info;
     struct kvm_sev_snp_launch_update update = {0};
 
     if (!data->hva || !data->len) {
@@ -828,6 +888,11 @@ sev_snp_launch_update(SevSnpGuestState *sev_snp_guest,
         return 1;
     }
 
+    if (data->type == KVM_SEV_SNP_PAGE_TYPE_CPUID) {
+        /* Save a copy for comparison in case the LAUNCH_UPDATE fails */
+        memcpy(&snp_cpuid_info, data->hva, sizeof(snp_cpuid_info));
+    }
+
     update.uaddr = (__u64)(unsigned long)data->hva;
     update.gfn_start = data->gpa >> TARGET_PAGE_BITS;
     update.len = data->len;
@@ -855,6 +920,11 @@ sev_snp_launch_update(SevSnpGuestState *sev_snp_guest,
         if (ret && ret != -EAGAIN) {
             error_report("SNP_LAUNCH_UPDATE ret=%d fw_error=%d '%s'",
                          ret, fw_error, fw_error_to_str(fw_error));
+
+            if (data->type == KVM_SEV_SNP_PAGE_TYPE_CPUID) {
+                sev_snp_cpuid_report_mismatches(&snp_cpuid_info, data->hva);
+                error_report("SEV-SNP: failed update CPUID page");
+            }
             break;
         }
     }
@@ -1017,7 +1087,8 @@ sev_launch_finish(SevCommonState *sev_common)
 }
 
 static int
-snp_launch_update_data(uint64_t gpa, void *hva, uint32_t len, int type)
+snp_launch_update_data(uint64_t gpa, void *hva,
+                       uint32_t len, int type)
 {
     SevLaunchUpdateData *data;
 
@@ -1032,6 +1103,90 @@ snp_launch_update_data(uint64_t gpa, void *hva, uint32_t len, int type)
     return 0;
 }
 
+static int
+sev_snp_cpuid_info_fill(SnpCpuidInfo *snp_cpuid_info,
+                        const KvmCpuidInfo *kvm_cpuid_info)
+{
+    size_t i;
+
+    if (kvm_cpuid_info->cpuid.nent > SNP_CPUID_FUNCTION_MAXCOUNT) {
+        error_report("SEV-SNP: CPUID entry count (%d) exceeds max (%d)",
+                     kvm_cpuid_info->cpuid.nent, SNP_CPUID_FUNCTION_MAXCOUNT);
+        return -1;
+    }
+
+    memset(snp_cpuid_info, 0, sizeof(*snp_cpuid_info));
+
+    for (i = 0; i < kvm_cpuid_info->cpuid.nent; i++) {
+        const struct kvm_cpuid_entry2 *kvm_cpuid_entry;
+        SnpCpuidFunc *snp_cpuid_entry;
+
+        kvm_cpuid_entry = &kvm_cpuid_info->entries[i];
+        snp_cpuid_entry = &snp_cpuid_info->entries[i];
+
+        snp_cpuid_entry->eax_in = kvm_cpuid_entry->function;
+        if (kvm_cpuid_entry->flags == KVM_CPUID_FLAG_SIGNIFCANT_INDEX) {
+            snp_cpuid_entry->ecx_in = kvm_cpuid_entry->index;
+        }
+        snp_cpuid_entry->eax = kvm_cpuid_entry->eax;
+        snp_cpuid_entry->ebx = kvm_cpuid_entry->ebx;
+        snp_cpuid_entry->ecx = kvm_cpuid_entry->ecx;
+        snp_cpuid_entry->edx = kvm_cpuid_entry->edx;
+
+        /*
+         * Guest kernels will calculate EBX themselves using the 0xD
+         * subfunctions corresponding to the individual XSAVE areas, so only
+         * encode the base XSAVE size in the initial leaves, corresponding
+         * to the initial XCR0=1 state.
+         */
+        if (snp_cpuid_entry->eax_in == 0xD &&
+            (snp_cpuid_entry->ecx_in == 0x0 || snp_cpuid_entry->ecx_in == 0x1)) {
+            snp_cpuid_entry->ebx = 0x240;
+            snp_cpuid_entry->xcr0_in = 1;
+            snp_cpuid_entry->xss_in = 0;
+        }
+    }
+
+    snp_cpuid_info->count = i;
+
+    return 0;
+}
+
+static int
+snp_launch_update_cpuid(uint32_t cpuid_addr, void *hva, uint32_t cpuid_len)
+{
+    KvmCpuidInfo kvm_cpuid_info = {0};
+    SnpCpuidInfo snp_cpuid_info;
+    CPUState *cs = first_cpu;
+    int ret;
+    uint32_t i = 0;
+
+    assert(sizeof(snp_cpuid_info) <= cpuid_len);
+
+    /* get the cpuid list from KVM */
+    do {
+        kvm_cpuid_info.cpuid.nent = ++i;
+        ret = kvm_vcpu_ioctl(cs, KVM_GET_CPUID2, &kvm_cpuid_info);
+    } while (ret == -E2BIG);
+
+    if (ret) {
+        error_report("SEV-SNP: unable to query CPUID values for CPU: '%s'",
+                     strerror(-ret));
+        return 1;
+    }
+
+    ret = sev_snp_cpuid_info_fill(&snp_cpuid_info, &kvm_cpuid_info);
+    if (ret) {
+        error_report("SEV-SNP: failed to generate CPUID table information");
+        return 1;
+    }
+
+    memcpy(hva, &snp_cpuid_info, sizeof(snp_cpuid_info));
+
+    return snp_launch_update_data(cpuid_addr, hva, cpuid_len,
+                                  KVM_SEV_SNP_PAGE_TYPE_CPUID);
+}
+
 static int
 snp_metadata_desc_to_page_type(int desc_type)
 {
@@ -1066,7 +1221,12 @@ snp_populate_metadata_pages(SevSnpGuestState *sev_snp,
             exit(1);
         }
 
-        ret = snp_launch_update_data(desc->base, hva, desc->len, type);
+        if (type == KVM_SEV_SNP_PAGE_TYPE_CPUID) {
+            ret = snp_launch_update_cpuid(desc->base, hva, desc->len);
+        } else {
+            ret = snp_launch_update_data(desc->base, hva, desc->len, type);
+        }
+
         if (ret) {
             error_report("%s: Failed to add metadata page gpa 0x%x+%x type %d",
                          __func__, desc->base, desc->len, desc->type);
-- 
2.34.1


