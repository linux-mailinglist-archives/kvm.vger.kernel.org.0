Return-Path: <kvm+bounces-18410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 043D28D4A42
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:19:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B01C92827A7
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:19:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9C411822CC;
	Thu, 30 May 2024 11:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4jhal/t5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2049.outbound.protection.outlook.com [40.107.93.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C78F17FAC7
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067824; cv=fail; b=TQ+rTfBIc6XSyfTwFOnNBVbRZ1cFJJnNb0BPKU0RNBxtXpaYGhqPIrFVvoMBx/pfsqGrxMCpbnXyGQ51kmbhr4znmHoiIXJBsnFMK/ysQ0drI5o3BSy+uESahq+TEOnFnWnTXE3aq8t+EQJCdGmLA6DjM8b3wOSOobdk7eSR+e4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067824; c=relaxed/simple;
	bh=vLXXfpKgUOuJsDYlYvUMLPrKNLn7gMPFAmnT0X97dp0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n39+F3GcAIoc+feF9LuD960b75FxNUWQQCWzqPOMT8b0c4/0ClBnyFcgFtwqA+vlf3hPxuGL+WPgR9LzspiCA9Xrw3ojYdVu9dNM2uGgPdlI4n6KhhM5hZB/eKJhMRaA1nKfTSx61jqFutcFbkcFCnFrgSsorLPIN7ArVJXEQNY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4jhal/t5; arc=fail smtp.client-ip=40.107.93.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YaurlcbBov9RxFIUpyEeg7DR/U12pmvUNP1sl91sMw3SHv3SkJu1lgE+jlX6uN0E4aXLkZ4Nr3NkL7sgALJuLy+FZdDWT2GpRDNKhS81vor5F9uPJe8eaNyLAY6UB7PO7lnDan6YYKFfgKj8lpZatb+lKVf/CsHaSFac0EByGf/ON97C62PgjW6yJ89F/L0QVMalmHQSeKszPAO6Rpkj/i61AG5U/H8ltF6O99zL5jWE2dg2xdiYBDpj0hHpmh+wgS6GiKeQEfRcX30D1Isi0KqUR6y+zClCb4Sgk/6B+r7jG0Xj7z44dWaFlLKomAzwH1nNf5LgN2nfZp6jK7Eq2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gTmz5Y+I5Y3Cfre/deyExTeyRcr++l+yG61WncPA2zo=;
 b=BpBQJYqRolZex2xEic4+n8tc23TVknHMmXaDP4jl2tzucG8uTaAkTTi/NJXlemsJ/kembNuHdgeYHjsghdirKwnxeRRnon00bvwloVl9fOjkZTvixWhAKW0S5HScHuZ+/f69rMLwOIKnHtm2NmAkLFa71DTAyYgfEtx8EWSgcY8NNdL8F2zaT1P6fwNl3h5UOdjYezPYNHhZYBl8LG9L5a+4uYHStLf2JjYvulWjsTWZPZA9DHg3UA62HQw+W9+BcrXQ93RAcoIFQ+RhvvEMCCQbtesDlHJfTp7UUKXuZDXeU5xulrmLKYHoTMQcwYL3UsoJIX/DfvJ6nrE79xh3bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gTmz5Y+I5Y3Cfre/deyExTeyRcr++l+yG61WncPA2zo=;
 b=4jhal/t5SRgQLeSVtPYnGaH6GTxgAj1ZZF27mAw/3xF32lFYhqhQ3EazlrLjRxHux2gwqBUnIdjSrt+JRLrJ1wjUrUvEqL3b7bzj/4bXProQvupla6YTAzOERJiBX+WYo1CEJzl1uh6+eQm4xHqod5S/uDHldul+TKINTCiUdZ4=
Received: from BN1PR14CA0016.namprd14.prod.outlook.com (2603:10b6:408:e3::21)
 by SN7PR12MB7201.namprd12.prod.outlook.com (2603:10b6:806:2a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.35; Thu, 30 May
 2024 11:16:56 +0000
Received: from BN2PEPF00004FBC.namprd04.prod.outlook.com
 (2603:10b6:408:e3:cafe::d6) by BN1PR14CA0016.outlook.office365.com
 (2603:10b6:408:e3::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30 via Frontend
 Transport; Thu, 30 May 2024 11:16:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN2PEPF00004FBC.mail.protection.outlook.com (10.167.243.182) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:16:56 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:56 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:55 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:16:55 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 18/31] hw/i386/sev: Add function to get SEV metadata from OVMF header
Date: Thu, 30 May 2024 06:16:30 -0500
Message-ID: <20240530111643.1091816-19-pankaj.gupta@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBC:EE_|SN7PR12MB7201:EE_
X-MS-Office365-Filtering-Correlation-Id: 58954654-5eaf-4d24-bd20-08dc809a0442
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|376005|82310400017|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8p8Om6+h39y+KRV1DrXHJqpARG1avIjTNq57hHN5Qnm0IpMAx1y97hjhIpOT?=
 =?us-ascii?Q?G7+eRMeCAiYU7RmlYRW7tw9LBPHbGweg5KVt6fUwjEXWzuMDY1m6ygR6DsGL?=
 =?us-ascii?Q?4RNWfzgZEKBgW09BxSyk8LK8JzB85z67WKbNC50okuezfjH7HTx8vY+rsNxC?=
 =?us-ascii?Q?y4D/cWirM/0dHxGp9hEkTRM6B3lBCJaVYWByquSkm52qk3B+N6VUJjK5Bsv1?=
 =?us-ascii?Q?8d6Hw2m2Iu13Zzr8nqVDz2yv36th3fNNSTGHJAeOK9U4i1KNK9lD8cuMBl16?=
 =?us-ascii?Q?LmtgGS2z7UzLHU3yNfK+Je5qSm5DO9slqJEjocbRUpePgj+vXaxX9Lhli54b?=
 =?us-ascii?Q?ZdsCUeNwS61uxu3yrj4FQc5DIyf2VwdgyX8G+TBKvoUHJrEM4boslsbMIoe1?=
 =?us-ascii?Q?O4SlRahoAl7uvm7qfeYeljrzhI3tkeyuhG+Rbn9X9l4/UKXugUPti47Lfs9+?=
 =?us-ascii?Q?yoOa3SpYT6NIaccDviBP7uoxZoFehosfJlsgUlNDuDn9/tHRXCBlOKCc8gw3?=
 =?us-ascii?Q?+H5ABt7ZAVr9zQCG64mZQZof5STX2STCuVVxbfphi1yA6aflMNxOrVH3KQk2?=
 =?us-ascii?Q?dHwyWWJoqMmDcfTEK9bF2U9Vs7bkhGcffhh5euEQHRbAShYR1BysZ1q9ImqX?=
 =?us-ascii?Q?HFxxe+fejn+lEP/Qi1KNujVO46JwmgdBHctGhR1vNPK08Z3Fj0VzjAUbWPX0?=
 =?us-ascii?Q?KDpdb4Yy/6Mj/SvclswpCoyJKab2YOn8u+BPHWcIr9eysDO/M2ExnzRL3oTD?=
 =?us-ascii?Q?J6bSBYmSe/98RIqvKqZUrBAXYS3XQKIxymft9ZKzGcNWG5SRXUp4fNInbjaj?=
 =?us-ascii?Q?JH/+i0wy58LTUx76ttBCjKkzGkoWgaNyusmkePGEvIrOR5CVAIdPygYFgP4L?=
 =?us-ascii?Q?/T86WpiB7hSbzJScFwEWJF4LuJkxmqVk6SeuhwERqxB+V7qlQQFtTzR/pdw7?=
 =?us-ascii?Q?xEzJasLFykvQCEa9TDblW6sMQlupM/nhwtbCyRskWJlEL84ieXS8nN5OY9wJ?=
 =?us-ascii?Q?xrSApbIUot9JnCGm9NOYUGshOxY3Z+b65CtvRJwfSiKdJlq7nKL0G4mWKIMT?=
 =?us-ascii?Q?OQIBoYmY2bC+vvSZ6trolKrh9j/Gc64+fDRyhn1Ir0598XVZbs3/raH4Uvvn?=
 =?us-ascii?Q?sqv4UTMqBC7YFHqsQLqhIdAL4o0t1h1PRBRGYyew4PAM87gL33G23ii8EHKU?=
 =?us-ascii?Q?yUle5THkO3sHpDh1nEXo+wTW+tCrKgBktxQFt1CKkswTz6ot7FRZB6rszqQW?=
 =?us-ascii?Q?64sYU+AJT8hgYochXbKuz0GS6DivCNXlhUclzOiYURYUu5K3PNp8Fw0C5LhH?=
 =?us-ascii?Q?3wxWtWknShefykEIqvWk2BmsRrW+0MdXJ6BLv/fdQOhswnx7kQGR0D8mxROE?=
 =?us-ascii?Q?NEDVUNE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(376005)(82310400017)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:16:56.4100
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 58954654-5eaf-4d24-bd20-08dc809a0442
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7201

From: Brijesh Singh <brijesh.singh@amd.com>

A recent version of OVMF expanded the reset vector GUID list to add
SEV-specific metadata GUID. The SEV metadata describes the reserved
memory regions such as the secrets and CPUID page used during the SEV-SNP
guest launch.

The pc_system_get_ovmf_sev_metadata_ptr() is used to retieve the SEV
metadata pointer from the OVMF GUID list.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 hw/i386/pc_sysfw.c   |  4 ++++
 include/hw/i386/pc.h | 26 ++++++++++++++++++++++++++
 target/i386/sev.c    | 31 +++++++++++++++++++++++++++++++
 target/i386/sev.h    |  2 ++
 4 files changed, 63 insertions(+)

diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
index ac88ad4eb9..048d0919c1 100644
--- a/hw/i386/pc_sysfw.c
+++ b/hw/i386/pc_sysfw.c
@@ -260,6 +260,10 @@ void x86_firmware_configure(void *ptr, int size)
     pc_system_parse_ovmf_flash(ptr, size);
 
     if (sev_enabled()) {
+
+        /* Copy the SEV metadata table (if exist) */
+        pc_system_parse_sev_metadata(ptr, size);
+
         ret = sev_es_save_reset_vector(ptr, size);
         if (ret) {
             error_report("failed to locate and/or save reset vector");
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index ad9c3d9ba8..c653b8eeb2 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -164,6 +164,32 @@ void pc_acpi_smi_interrupt(void *opaque, int irq, int level);
 #define PCI_HOST_ABOVE_4G_MEM_SIZE     "above-4g-mem-size"
 #define PCI_HOST_PROP_SMM_RANGES       "smm-ranges"
 
+typedef enum {
+    SEV_DESC_TYPE_UNDEF,
+    /* The section contains the region that must be validated by the VMM. */
+    SEV_DESC_TYPE_SNP_SEC_MEM,
+    /* The section contains the SNP secrets page */
+    SEV_DESC_TYPE_SNP_SECRETS,
+    /* The section contains address that can be used as a CPUID page */
+    SEV_DESC_TYPE_CPUID,
+
+} ovmf_sev_metadata_desc_type;
+
+typedef struct __attribute__((__packed__)) OvmfSevMetadataDesc {
+    uint32_t base;
+    uint32_t len;
+    ovmf_sev_metadata_desc_type type;
+} OvmfSevMetadataDesc;
+
+typedef struct __attribute__((__packed__)) OvmfSevMetadata {
+    uint8_t signature[4];
+    uint32_t len;
+    uint32_t version;
+    uint32_t num_desc;
+    OvmfSevMetadataDesc descs[];
+} OvmfSevMetadata;
+
+OvmfSevMetadata *pc_system_get_ovmf_sev_metadata_ptr(void);
 
 void pc_pci_as_mapping_init(MemoryRegion *system_memory,
                             MemoryRegion *pci_address_space);
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 2ca9a86bf3..d9d1d97f0c 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -611,6 +611,37 @@ SevCapability *qmp_query_sev_capabilities(Error **errp)
     return sev_get_capabilities(errp);
 }
 
+static OvmfSevMetadata *ovmf_sev_metadata_table;
+
+#define OVMF_SEV_META_DATA_GUID "dc886566-984a-4798-A75e-5585a7bf67cc"
+typedef struct __attribute__((__packed__)) OvmfSevMetadataOffset {
+    uint32_t offset;
+} OvmfSevMetadataOffset;
+
+OvmfSevMetadata *pc_system_get_ovmf_sev_metadata_ptr(void)
+{
+    return ovmf_sev_metadata_table;
+}
+
+void pc_system_parse_sev_metadata(uint8_t *flash_ptr, size_t flash_size)
+{
+    OvmfSevMetadata     *metadata;
+    OvmfSevMetadataOffset  *data;
+
+    if (!pc_system_ovmf_table_find(OVMF_SEV_META_DATA_GUID, (uint8_t **)&data,
+                                   NULL)) {
+        return;
+    }
+
+    metadata = (OvmfSevMetadata *)(flash_ptr + flash_size - data->offset);
+    if (memcmp(metadata->signature, "ASEV", 4) != 0) {
+        return;
+    }
+
+    ovmf_sev_metadata_table = g_malloc(metadata->len);
+    memcpy(ovmf_sev_metadata_table, metadata, metadata->len);
+}
+
 static SevAttestationReport *sev_get_attestation_report(const char *mnonce,
                                                         Error **errp)
 {
diff --git a/target/i386/sev.h b/target/i386/sev.h
index 5dc4767b1e..cc12824dd6 100644
--- a/target/i386/sev.h
+++ b/target/i386/sev.h
@@ -66,4 +66,6 @@ int sev_inject_launch_secret(const char *hdr, const char *secret,
 int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size);
 void sev_es_set_reset_vector(CPUState *cpu);
 
+void pc_system_parse_sev_metadata(uint8_t *flash_ptr, size_t flash_size);
+
 #endif
-- 
2.34.1


