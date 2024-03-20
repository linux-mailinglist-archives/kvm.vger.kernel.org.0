Return-Path: <kvm+bounces-12253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BCA34880DE8
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:54:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 732A7282D1A
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:54:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 169D138DED;
	Wed, 20 Mar 2024 08:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UJnbGJl6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2057.outbound.protection.outlook.com [40.107.95.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E02538DE8
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924787; cv=fail; b=AHxnA+SfzrPKJ0yV5lCK8z4Qdy+tjire1AnCTE5vCYKbytYyw8RzTaFdzjPkUddQesZ+JwHDSphTrEM7dWLv5iLX9gHeIyj/7Vk03wJKVsqKv8Ar0y6WvSHe5gtid/nZyNXXD4NqZSfpB41bm/q/5oBGRnIKtYAvmRFUIkJh4x4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924787; c=relaxed/simple;
	bh=Wz0SOvEeij66MiyoINbiM2lNIdqf0dCZ2xCLS+Noucg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qDLc11Lm0x257ojSzo13+u7yQBOucOLFDyMHPpNmE5+akyKCE06rhIxwLylEBGWK9gbJiWCUv9qleGWmKJZBRZND6z7homL8L64nZ1q/GlBA/9/AGtlYhbURM24ECgItx5AoggwHxCElUocDg+JYjHMKVDr7KpKeDI5Ehz8UiYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UJnbGJl6; arc=fail smtp.client-ip=40.107.95.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MQ6cEHvME7YGx7bYkJeWp9uDOYd/FRldMgrb1Pk/BtO73PsWdh2Iged2j/+7CI1iLUuHEAsMbTkAMX/YIAt0rEd492azOrwevsA/d5TIgGF7kQALH0iiJ/T9Kbo1fxZzHKbv+pFv1p579K5DnlJSqDTfhfYlpynRyYE+lrululWu/gnPqYQaSWaxzgn9dhk/KpKejLFeoXH8dUOU3dBz+mjGkiXbRI4M/r7brsYdIsrobSxGBQUd67yefgSWKeJvmLK1o2zNagLQTAGpReMRVsZdzrNcxTBrzKfVxqniqgUasXoHcMyLTjr/CJdF4JoKMPl+Fxz9CqFysFxAGZ57RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DXZ6Vcykvow/rJgShLM+EiS1n8t73FPvxJCq+B8NpqY=;
 b=cS62bmGVH+KxdayzDzRWhrymYNte2YgTVh+yuR2JprwEAWisROVoUBolj3gErBFXNf/NstROkvA2FYxP0mf39cuQBdu3ccUyiLQQoKQHP/u91P7hnDQVqxmtNfPjLujTvJVNEl60C1xEQRLeBieAH7XFXa071reBtqCrh36wvghDgNJTLpDh5YhhxEbKji0dbfU8OTaUWu8uxRgb9rx0Y5dv9JNsxeHtd76z8EzlOR4cZXnWyJiRg7tjWVvH/Rnkybhf2czLWuT6mOiSw7aogX3B/0/ow8K88a7vihLfphaqA6OwgDpf+EJIAzFP8Ce0XTTDGJqDzUSRhwyaIrdrfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DXZ6Vcykvow/rJgShLM+EiS1n8t73FPvxJCq+B8NpqY=;
 b=UJnbGJl6xvJn43o5tU+BPI9oAdkM0Oc9sHXab0n/M4n42HlRrbdepTGQDOnLoIkt6Rzfu/bwexPbRu4dVkd4GRKsdvHVJx8aDXISB6kamdmZS69ze+t5IsY7P0226Bf+8Il9PhXddUgacqOeeJ9Agq9XgZypgcbHV+dQkiMDZJU=
Received: from BN9PR03CA0056.namprd03.prod.outlook.com (2603:10b6:408:fb::31)
 by DM3PR12MB9349.namprd12.prod.outlook.com (2603:10b6:0:49::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.34; Wed, 20 Mar
 2024 08:53:03 +0000
Received: from BN1PEPF0000467F.namprd03.prod.outlook.com
 (2603:10b6:408:fb:cafe::15) by BN9PR03CA0056.outlook.office365.com
 (2603:10b6:408:fb::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.28 via Frontend
 Transport; Wed, 20 Mar 2024 08:53:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF0000467F.mail.protection.outlook.com (10.167.243.84) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:53:03 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:53:01 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>, Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v3 40/49] hw/i386/sev: Add function to get SEV metadata from OVMF header
Date: Wed, 20 Mar 2024 03:39:36 -0500
Message-ID: <20240320083945.991426-41-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000467F:EE_|DM3PR12MB9349:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f738c6a-27d5-4b54-234c-08dc48bb2753
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7ybF6KMqkplJlSZF9pvUfyMEK64ijM8mGTDyMnRKkckrS/xc6jc5MJ4e+iDHU4h65XMAlej9NciI6ZMwW+TAAzEXvFVvzXJLJZw0OgpXnONxEDnmzmtsjLpLfYOLbLrhRcqgc3MVK52pveBIdBnsCi/1bzRjzpbRXOZ5i+BnzDyGRoKX7o0/aATnM1px4XY0DGms1fe0AVAqzIT8O8XWsH+oficjHeFQPm4xxhdIXCDl4HFNwif7v+JYhwxXG0Jky+gnVAj4qsuEP7lMVxBAd4rygNj/70sLeIe+FVoMEVz714VFzSRlW6TShGeRYgmwLunEKd2myzx66biOt7nKGyUxvV49H3kwhR1H4b7f4la5LWTL6wPemwqYbA+i9MQs7nsQ/WzrAu+takHOWv9N2juG+4z5ff6golcn05wjWjyECIMVv2HqSnV1jofZI7A+0+5dYCe5E1YlGNPMODNd/Sbj7Vpeq6fEeTyU7nuhOdwoe9sZqsSCRN+IoGwMjXYv706EDn/3mgo0aAjemtji19SwphhScMKRO7mTBRrZnmW9H3QaDfcnulnoiQW1KzKFMm8TwgjaHKt70mqpTU1RR3fwJI491F/5vVAOVYOxmcXg+Ynz0Y95dhtV/NTxJEnQmBudKdyiHo1c/m/vK0yiXhl1wMQkuEyyAD5mcvHPn8UNrS5hDEx/ghao6x9jxJ8LkAFjpg+grPTQF2SJdEIv9xszYovpdgmwqfti/LbVEhBOngx3Zd0fYFLMSr/sE4jZ
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400014)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:53:03.5143
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f738c6a-27d5-4b54-234c-08dc48bb2753
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000467F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9349

From: Brijesh Singh <brijesh.singh@amd.com>

A recent version of OVMF expanded the reset vector GUID list to add
SEV-specific metadata GUID. The SEV metadata describes the reserved
memory regions such as the secrets and CPUID page used during the SEV-SNP
guest launch.

The pc_system_get_ovmf_sev_metadata_ptr() is used to retieve the SEV
metadata pointer from the OVMF GUID list.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 hw/i386/pc_sysfw_ovmf.c | 33 +++++++++++++++++++++++++++++++++
 include/hw/i386/pc.h    | 26 ++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/hw/i386/pc_sysfw_ovmf.c b/hw/i386/pc_sysfw_ovmf.c
index 07a4c267fa..32efa34614 100644
--- a/hw/i386/pc_sysfw_ovmf.c
+++ b/hw/i386/pc_sysfw_ovmf.c
@@ -35,6 +35,31 @@ static const int bytes_after_table_footer = 32;
 static bool ovmf_flash_parsed;
 static uint8_t *ovmf_table;
 static int ovmf_table_len;
+static OvmfSevMetadata *ovmf_sev_metadata_table;
+
+#define OVMF_SEV_META_DATA_GUID "dc886566-984a-4798-A75e-5585a7bf67cc"
+typedef struct __attribute__((__packed__)) OvmfSevMetadataOffset {
+    uint32_t offset;
+} OvmfSevMetadataOffset;
+
+static void pc_system_parse_sev_metadata(uint8_t *flash_ptr, size_t flash_size)
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
 
 void pc_system_parse_ovmf_flash(uint8_t *flash_ptr, size_t flash_size)
 {
@@ -90,6 +115,9 @@ void pc_system_parse_ovmf_flash(uint8_t *flash_ptr, size_t flash_size)
      */
     memcpy(ovmf_table, ptr - tot_len, tot_len);
     ovmf_table += tot_len;
+
+    /* Copy the SEV metadata table (if exist) */
+    pc_system_parse_sev_metadata(flash_ptr, flash_size);
 }
 
 /**
@@ -159,3 +187,8 @@ bool pc_system_ovmf_table_find(const char *entry, uint8_t **data,
     }
     return false;
 }
+
+OvmfSevMetadata *pc_system_get_ovmf_sev_metadata_ptr(void)
+{
+    return ovmf_sev_metadata_table;
+}
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index fb1d4106e5..df9a61540d 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -163,6 +163,32 @@ void pc_acpi_smi_interrupt(void *opaque, int irq, int level);
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
-- 
2.25.1


