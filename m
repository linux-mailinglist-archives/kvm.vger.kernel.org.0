Return-Path: <kvm+bounces-12247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C5299880DD4
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:53:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E35F31C2146B
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:52:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAFC93BB2A;
	Wed, 20 Mar 2024 08:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ERPUC+XM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2073.outbound.protection.outlook.com [40.107.212.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1B83B78E
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924660; cv=fail; b=VLpOMx55I3jRRTPeRAXZ8cZZaygmYt1ZtCJOkTA3wm+0MbxD7bI0Mijlv6cePzpPhXPYJQmT5XiblPE4SLh2W3A+Tm2x50dUqzdnNgLfYm6aBXubLcqqZSBMGCZUlmTKPJSibktBBvXRnkD22UOtd7aKWOpezWQQ6fRzqTFW6GE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924660; c=relaxed/simple;
	bh=TvPXxJXqge5i+DVj3F4tCO80v970DtXvZXHzdFE/Z+s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G7OrzcuEs+YVvDfmc591qgvtkzkkSWIPYFDBkcOxSbWdwguQ8yHJR9hDrE/AmaHSAYbaETxTr0zJWAc5YkcIRbfprxFOgOjw4NmIhIpujRAGoxspeKj4okouV4Ije7UyfuuYQoPGiylffMMGsgEc9Hz23GyDOz0SCOtvhlfDEAA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ERPUC+XM; arc=fail smtp.client-ip=40.107.212.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GIGoYE25qyBi4tBSQEXOTgKpUEVOzaumQKlZyplu7qgKGJkmSvJO6ybnJy/nzGt1ra/DKGUbs20bVY3tQf66jBnprTOpm3325SlN6koXEMEnQXM8mRqI/6Cex0ZGX+D5Z6cH3AQ2Rlf7IbiLHB0GUhkGNF3i7IankG8sjx7Y82aU9o6YzCeTPTahVNtmyj71cBydNaTAXC3TOm87OEDqh9axz6+UvdeS3n3UW+N3vmgt5o6mKKhi+9BHvuXq89IAE7bZLEfHupZmO1dAf6E2/rgkcurLQsOsbMN6PXdHU+uJl80VAeUiV5rFtaBfmOxGYkIeG6ip4CPU6jsFxV8/Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KlIQYJOoXidCNOb2sQQuAUDRz0tgA6k+4/7j+Dhpo8g=;
 b=AqYzzdLgrNSZlJ0ZXHMwDGY9dwBrEOVv36Ju04zMhiRmmfhaLiyyZGcqVYmYABPYyciyx73FJ0okOFJxq2Qd8g3lhWLau6tIlMUzV//i/Ut0a4IACgDmNV+AvNQxP2FuYSmMORPyJbFivTr+RZKO+RqGlc5RFRywxbFFEsIBLm/arNo6K7WruMSdCpLr4Al5UBxNTGlsA5L3YWE5r4r1J1Ed7aQM/MBgUmKKiRUIDj47qejZ5TBQVmSIaPJ59hxElZr6BP8O+Gdc5mH3W/slPOOy8dSmZp/TA2ZiKTyw+VZ1YTol6Hf78mqs4Y8KWj0kBf0CFLqiWGSn3r9TetC6og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KlIQYJOoXidCNOb2sQQuAUDRz0tgA6k+4/7j+Dhpo8g=;
 b=ERPUC+XMTB2/+jHaSj4MRwrs3b0K3rxfHEt3zNVh7hW8vSUrGFFs64vpILMyQTmT8zCcpuTpRBTvEPH5/6FGrbFkL3GDuJ/7kQmAWvfyXt+3LWW1DASGU0KN9x/CQiflyTx4xFS+2b6uOp/gNkJtkfDWi6ZAoadlSBfUDvp1gkY=
Received: from BN9PR03CA0190.namprd03.prod.outlook.com (2603:10b6:408:f9::15)
 by DM6PR12MB4122.namprd12.prod.outlook.com (2603:10b6:5:214::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.30; Wed, 20 Mar
 2024 08:50:55 +0000
Received: from BN1PEPF00004686.namprd03.prod.outlook.com
 (2603:10b6:408:f9:cafe::90) by BN9PR03CA0190.outlook.office365.com
 (2603:10b6:408:f9::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.28 via Frontend
 Transport; Wed, 20 Mar 2024 08:50:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004686.mail.protection.outlook.com (10.167.243.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:50:55 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:50:55 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 34/49] i386/sev: Add KVM_EXIT_VMGEXIT handling for Page State Changes
Date: Wed, 20 Mar 2024 03:39:30 -0500
Message-ID: <20240320083945.991426-35-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240320083945.991426-1-michael.roth@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004686:EE_|DM6PR12MB4122:EE_
X-MS-Office365-Filtering-Correlation-Id: f72474fd-e66c-4137-be23-08dc48badb1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	KK+hkd5ByJq+uBPGh89DD/HSNhbda70+eTtoVdCgKMdc+6d/a/ys6VloxAOFH5Nqf9yqWbUKpfxrIzW27heAaT/Qwvq3MiGI8CZ+UmBx8Ib9v+iwz9PxxEiBh+do0r+C+tiGbaHYslP549tW48vOUMZ0mhgxMuXcJa67Y0XxHPJxVlGR46IWIYwcxP6hmAqs3bImQUoHGDto48vI5TRw70cqHRhCPz+Mmo+ZVFgGNe5nstlIH1cLzf5tt2J+WTvlBMC+cI2WznIOr0mUf12GkndD5sa+6C94viNg+a5NPYYsKkJG8W5w2k7z151k7zQQVSKlWPwbNn0PnEiaZG0okBVkZct5eaZuYc4aRDqApGfTJ7TL/qFknTPksUDntSnRSGHAlCxl1h2GLlpSzjyjKr9b04LmOihYUFqL7jLBMErRooYjtIG9FyUSJH5XxhPy8OPNtUOsWjmXMLtVGo3SK1REm+dEzgEwEN9KH3N8nzVrSMuwy9qlvWHCuIZmOjs7zsgo+1s1nDWQ3TFUUQsQsbACtiKnHAE2bHmUTp5J5IZEBFZ1L41Oec3aoPUpBikg6AbC40vsbkgR24GckCxlWDiKKBcE+P0IDAC0lZzfD2cRJyDts5v//XKnk0uuGof+Fxri578dlU/M0jpWV0klokMEhizTdPWNS9MOwCGRNlCHbrdhy4NAFa/C8PQzS1BLzvniMi2shOTG7mXi1bLOxA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(36860700004)(82310400014)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:50:55.6575
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f72474fd-e66c-4137-be23-08dc48badb1d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004686.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4122

When running SEV-SNP guests, the kernel may forward some subset of
VMGEXIT-based guest hypercalls to userspace. One of these is for Page
State Change requests, as documented by the GHCB specification[1].

Userspace does not directly have control over the SNP RMP table to
actually satisfy these requests, but will instead make use of the
kvm_convert_memory() interface, which makes use of the
KVM_SET_MEMORY_ATTRIBUTES ioctl to instruct KVM to map these these
GPAs using private/shared memory and make the appropriate RMP changes
via the associated kernel hooks.

Add the basic infrastructure for handling KVM_EXIT_VMGEXIT events, and
then implement handling for Page State Change requests on top of that.

[1] https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/56421.pdf

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 target/i386/kvm/kvm.c |   3 +
 target/i386/sev.c     | 152 ++++++++++++++++++++++++++++++++++++++++++
 target/i386/sev.h     |   2 +
 3 files changed, 157 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 59e9048e61..22eb21a2f3 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5409,6 +5409,9 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
         ret = kvm_xen_handle_exit(cpu, &run->xen);
         break;
 #endif
+    case KVM_EXIT_VMGEXIT:
+        ret = kvm_handle_vmgexit(run);
+        break;
     default:
         fprintf(stderr, "KVM: unknown exit reason %d\n", run->exit_reason);
         ret = -1;
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 0c8e4bdb4c..0c6a253138 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1423,6 +1423,158 @@ bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
     return ret;
 }
 
+typedef struct __attribute__((__packed__)) PscHdr {
+    uint16_t cur_entry;
+    uint16_t end_entry;
+    uint32_t reserved;
+} PscHdr;
+
+typedef struct __attribute__((__packed__)) PscEntry {
+    uint64_t cur_page    : 12,
+             gfn         : 40,
+             operation   : 4,
+             pagesize    : 1,
+             reserved    : 7;
+} PscEntry;
+
+#define VMGEXIT_PSC_MAX_ENTRY 253
+
+typedef struct __attribute__((__packed__)) SnpPscDesc {
+    PscHdr hdr;
+    PscEntry entries[VMGEXIT_PSC_MAX_ENTRY];
+} SnpPscDesc;
+
+static int next_contig_gpa_range(SnpPscDesc *desc, uint16_t *entries_processed,
+                                 hwaddr *gfn_base, int *gfn_count,
+                                 bool *range_to_private)
+{
+    int i;
+
+    *entries_processed = 0;
+    *gfn_base = 0;
+    *gfn_count = 0;
+    *range_to_private = false;
+
+    for (i = desc->hdr.cur_entry; i <= desc->hdr.end_entry; i++) {
+        PscEntry *entry = &desc->entries[i];
+        bool to_private = entry->operation == 1;
+        int page_count = entry->pagesize ? 512 : 1;
+
+        if (!*gfn_count) {
+            *range_to_private = to_private;
+            *gfn_base = entry->gfn;
+        }
+
+        /* When first non-adjacent entry is seen, report the previous range */
+        if (entry->gfn != *gfn_base + *gfn_count || (to_private != *range_to_private)) {
+            return 0;
+        }
+
+        *gfn_count += page_count;
+
+        /*
+         * Currently entry-specific PSC_ERROR_INVALID_ENTRY errors are not
+         * returned. Instead only the more general GENERIC/INVALID_HDR
+         * errors are returned. If support for PSC_ERROR_INVALID_ENTRY errors
+         * are added, this logic will need to be re-worked to either not
+         * increment entries_processed until the request is issued
+         * successfully, or to rewind it after failure. Guests don't
+         * currently do anything useful with entry-specific errors so vs.
+         * the other errors types so this is unlikely to be an issue in the
+         * meantime.
+         */
+        entry->cur_page = page_count;
+        *entries_processed += 1;
+    }
+
+    return *gfn_count ? 0 : -ENOENT;
+}
+
+#define GHCB_SHARED_BUF_SIZE    0x7f0
+#define PSC_ERROR_GENERIC       (0x100UL << 32)
+#define PSC_ERROR_INVALID_HDR   ((0x1UL << 32) | 1)
+#define PSC_ERROR_INVALID_ENTRY ((0x1UL << 32) | 2)
+#define PSC_ENTRY_COUNT_MAX     253
+
+static int kvm_handle_vmgexit_psc(__u64 shared_gpa, __u64 *psc_ret)
+{
+    hwaddr len = GHCB_SHARED_BUF_SIZE;
+    MemTxAttrs attrs = { 0 };
+    SnpPscDesc *desc;
+    void *ghcb_shared_buf;
+    uint8_t shared_buf[GHCB_SHARED_BUF_SIZE];
+    uint16_t entries_processed;
+    hwaddr gfn_base = 0;
+    int gfn_count = 0;
+    bool range_to_private;
+
+    *psc_ret = 0;
+    ghcb_shared_buf = address_space_map(&address_space_memory, shared_gpa,
+                                        &len, true, attrs);
+    if (len < GHCB_SHARED_BUF_SIZE) {
+        g_warning("unable to map entire shared GHCB buffer, mapped size %ld (expected %d)",
+                  len, GHCB_SHARED_BUF_SIZE);
+        *psc_ret = PSC_ERROR_GENERIC;
+        goto out_unmap;
+    }
+    memcpy(shared_buf, ghcb_shared_buf, GHCB_SHARED_BUF_SIZE);
+    address_space_unmap(&address_space_memory, ghcb_shared_buf, len, true, len);
+
+    desc = (SnpPscDesc *)shared_buf;
+
+    if (desc->hdr.end_entry >= PSC_ENTRY_COUNT_MAX) {
+        *psc_ret = PSC_ERROR_INVALID_HDR;
+        goto out_unmap;
+    }
+
+    /* No more entries left to process. */
+    if (desc->hdr.cur_entry > desc->hdr.end_entry) {
+        goto out_unmap;
+    }
+
+    while (!next_contig_gpa_range(desc, &entries_processed,
+                                  &gfn_base, &gfn_count, &range_to_private)) {
+        int ret = kvm_convert_memory(gfn_base * 0x1000, gfn_count * 0x1000,
+                                     range_to_private);
+        if (ret) {
+            *psc_ret = 0x100ULL << 32; /* Indicate interrupted processing */
+            g_warning("error doing memory conversion: %d", ret);
+            break;
+        }
+
+        desc->hdr.cur_entry += entries_processed;
+    }
+
+    ghcb_shared_buf = address_space_map(&address_space_memory, shared_gpa,
+                                        &len, true, attrs);
+    if (len < GHCB_SHARED_BUF_SIZE) {
+        g_warning("unable to map entire shared GHCB buffer, mapped size %ld (expected %d)",
+                  len, GHCB_SHARED_BUF_SIZE);
+        *psc_ret = PSC_ERROR_GENERIC;
+        goto out_unmap;
+    }
+    memcpy(ghcb_shared_buf, shared_buf, GHCB_SHARED_BUF_SIZE);
+out_unmap:
+    address_space_unmap(&address_space_memory, ghcb_shared_buf, len, true, len);
+
+    return 0;
+}
+
+int kvm_handle_vmgexit(struct kvm_run *run)
+{
+    int ret;
+
+    if (run->vmgexit.type == KVM_USER_VMGEXIT_PSC) {
+        ret = kvm_handle_vmgexit_psc(run->vmgexit.psc.shared_gpa,
+                                     &run->vmgexit.psc.ret);
+    } else {
+        warn_report("KVM: unknown vmgexit type: %d", run->vmgexit.type);
+        ret = -1;
+    }
+
+    return ret;
+}
+
 static char *
 sev_common_get_sev_device(Object *obj, Error **errp)
 {
diff --git a/target/i386/sev.h b/target/i386/sev.h
index 5dc4767b1e..5cbfc3365b 100644
--- a/target/i386/sev.h
+++ b/target/i386/sev.h
@@ -66,4 +66,6 @@ int sev_inject_launch_secret(const char *hdr, const char *secret,
 int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size);
 void sev_es_set_reset_vector(CPUState *cpu);
 
+int kvm_handle_vmgexit(struct kvm_run *run);
+
 #endif
-- 
2.25.1


