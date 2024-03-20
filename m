Return-Path: <kvm+bounces-12260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C6AE3880DF4
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:55:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52D551F26F50
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:55:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A1AA383B5;
	Wed, 20 Mar 2024 08:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ExKzrtIU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0981B5A4
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924934; cv=fail; b=a1fKuangxE0zKdZxiN7EJhJTCXOt7izeIL1lNPFokkkXbsdphltqfDyZJTJBQWHx46u8vXnzpi7q4WQpClCprYoELLDWSEK+rQMpzixAtctHYaJ0Oua0z80zZX/X6mpUnxpy9YowlFWXHuKFVCLUI3Ztui1ZXihIhOXzuuT7wU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924934; c=relaxed/simple;
	bh=CBAhJguajUwrhIjZJ1qYZwolusw+2g7rmydv0cijDQs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mS5iN+FoP1poLQJO+CXu/ivscHd78s0sn4ssYkBLDQeF+EE29sA/u3kiiKYd12dLdL4OTdxc+Kz44wdtKnz0c7vl6/yaJfp1krGpIzO1QaLB+7sm0eYLvDCB9aNyxF0oZ7HuA9K5ix/kXpmUUjJGE6jFSGW94OK+mXChKkD7yRI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ExKzrtIU; arc=fail smtp.client-ip=40.107.243.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hba/c/kxHH0UJA1s2cnBQ+iXxH1BtZF1qxtq7GfmPCnBztlmgamNRZ4Zc9KDY+IT3b/r95zGmy2//pr3XKkn4lJRlWoe849cM9eTHhQ6eyDzK1TYoCj/RH/7LPVS0eNdYFb1vyEKyYAORbeZyFoJGdmBKcN+Oz7glRzSm6SbNz0PeKCLzxPGzYI76F3nvAwpnQASel6dWEqqYjSoJAd3RtncXxcCBRd8aCqh6nnlvjmXtiDFJZ58bDRZVZYno4nxy+E7oeY4MsOtX9K8JacLiqptLCHeCnRzwVnYCTn9dg6VqP/AED7n0JJLuXONMRKKHT/frrhKhIaudFmFUMuJaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m1GjgWN+0ziFXpiGnyC60nIhOfw2pfPyQgo0dSBqZxc=;
 b=D8BNlB2gRRtR/qtlQRWtqAGJCkWMHL96hgcMI+tw4Qpq7aerlJFsp73u+qraXlwMDeADvEMgT2eGXfwFR9jGIiZoD5QUv14+4uyUJ1EGMNkL5Q53I5G3proOL2h46Z+tVslM0xApOWbyWFHUQXcxOKtVmp2aFg2i8dFOCO8hxkCktiJxnngWHonEJhjeikaW2pE5unOfJYtWZsuhX/6zErWP8bWe+ZOmfp1O0iQS+SN5Xe3DPa2SHK/g8V2+IvScja5ZQcKuf1rIZZRr9+BN9zQGKY5HmgK0RYKnODztuH23Lz5jAbzQgF/e7+9HTg9cSDUrBSdL5zlF5kAwRlBjFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m1GjgWN+0ziFXpiGnyC60nIhOfw2pfPyQgo0dSBqZxc=;
 b=ExKzrtIU1NZAx/qJUzXZ+yoHiZG0Pf8jBAyvQgxIFYUe0QwRyZXwlorymNBLYzr/g4wq6mj0l47Ztlmir/Kb4iOrtNzCshH1YJfSnif2ZI17wDr5LKK9FcAnVaI32rYxgtLUYnetvWRo2T8Ji4k1w/5tN5bxZjG0CAtTqGaCzKs=
Received: from SJ0PR03CA0109.namprd03.prod.outlook.com (2603:10b6:a03:333::24)
 by PH7PR12MB7212.namprd12.prod.outlook.com (2603:10b6:510:207::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.28; Wed, 20 Mar
 2024 08:55:29 +0000
Received: from CO1PEPF000044EE.namprd05.prod.outlook.com
 (2603:10b6:a03:333:cafe::20) by SJ0PR03CA0109.outlook.office365.com
 (2603:10b6:a03:333::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.26 via Frontend
 Transport; Wed, 20 Mar 2024 08:55:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044EE.mail.protection.outlook.com (10.167.241.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:55:28 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:55:27 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>, Dov Murik <dovmurik@linux.ibm.com>
Subject: [PATCH v3 46/49] i386/sev: Allow measured direct kernel boot on SNP
Date: Wed, 20 Mar 2024 03:39:42 -0500
Message-ID: <20240320083945.991426-47-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EE:EE_|PH7PR12MB7212:EE_
X-MS-Office365-Filtering-Correlation-Id: 304193d4-6a46-4e3d-36f1-08dc48bb7de2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0Cn7DEeqqq4bdIdg+9PdBq8R0mOFr1mZ+WvICaNoIxSVdEEU+Hh5VsgJpE1DzS2qSAFG2QKP4Y5QFUzxg8VVIMXH6b3eoNsrxXf6MQQrU1ay2BXhcDSkE5oKRlPQ65fD0KPQmRN4Cds0VS/iJDuz8BfyGXRcsQfcwvPZ2kTAqp5Wu+wp9IQixiuSTPUkrdVD86PREmL7vNaghXK+GH4Xjyc4Elr0Tw5ClMWCyapUbQOLM/Sp1ZkPa0AReOP69qSUpCtarIG0JHQ68I+/PPK79UlfZxEnCSpmL0sHLv+bmfav/uKcELlpcz9LOOvbMYn1h3ov3+CT23g+CDqH8WFApU0bF25p1rQ6J0a3Kgj8Kqb3ZABpdS6w9LWJY+9KPx+04cxWj9nc2MZSjU2YlehoyZql6+ntgByjEHbe1zii2BJKB+NtnekXpFEcPayDAciabFlOMU5TASwBWi1TLQn1f3JqAA2HH6INiNJHUbJh1ceepH8QPyt7t3iHAOs7byi7PAJozv11NWzS7fynmEtPzo/MdMrrJp77RAi1m3FbWODrCzU+p1N5o1jfzvkC86BDI38IlkkkOEFpID7SSTnfh3Rfqz2ggG3eq/PTfaImR7bBNR651CJgWR2jCH0BWpnTfdyTMg2WXW0x8NqN0vnomOzLFCADqsoWjPjrCUABF3RdzhsxZFU/LhM22xnoHV4xchn3BWQsg0HdZE2jxywOtRbzucBL/+0dWkNoutvBiNIVTvrRVIwAu366TokRLPvO
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(376005)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:55:28.6266
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 304193d4-6a46-4e3d-36f1-08dc48bb7de2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7212

From: Dov Murik <dovmurik@linux.ibm.com>

In SNP, the hashes page designated with a specific metadata entry
published in AmdSev OVMF.

Therefore, if the user enabled kernel hashes (for measured direct boot),
QEMU should prepare the content of hashes table, and during the
processing of the metadata entry it copy the content into the designated
page and encrypt it.

Note that in SNP (unlike SEV and SEV-ES) the measurements is done in
whole 4KB pages.  Therefore QEMU zeros the whole page that includes the
hashes table, and fills in the kernel hashes area in that page, and then
encrypts the whole page.  The rest of the page is reserved for SEV
launch secrets which are not usable anyway on SNP.

If the user disabled kernel hashes, QEMU pre-validates the kernel hashes
page as a zero page.

Signed-off-by: Dov Murik <dovmurik@linux.ibm.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 include/hw/i386/pc.h |  2 ++
 target/i386/sev.c    | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index df9a61540d..d9d3a5b5b8 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -171,6 +171,8 @@ typedef enum {
     SEV_DESC_TYPE_SNP_SECRETS,
     /* The section contains address that can be used as a CPUID page */
     SEV_DESC_TYPE_CPUID,
+    /* The section contains the region for kernel hashes for measured direct boot */
+    SEV_DESC_TYPE_SNP_KERNEL_HASHES = 0x10,
 
 } ovmf_sev_metadata_desc_type;
 
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 4bc6004037..e2506f74da 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -129,6 +129,9 @@ struct SevSnpGuestState {
 
     struct kvm_sev_snp_launch_start kvm_start_conf;
     struct kvm_sev_snp_launch_finish kvm_finish_conf;
+
+    uint32_t kernel_hashes_offset;
+    PaddedSevHashTable *kernel_hashes_data;
 };
 
 #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
@@ -1117,6 +1120,23 @@ snp_launch_update_cpuid(uint32_t cpuid_addr, void *hva, uint32_t cpuid_len)
     return snp_launch_update_data(cpuid_addr, hva, cpuid_len, KVM_SEV_SNP_PAGE_TYPE_CPUID);
 }
 
+static int
+snp_launch_update_kernel_hashes(SevSnpGuestState *sev_snp, uint32_t addr,
+                                void *hva, uint32_t len)
+{
+    int type = KVM_SEV_SNP_PAGE_TYPE_ZERO;
+    if (sev_snp->sev_common.kernel_hashes) {
+        assert(sev_snp->kernel_hashes_data);
+        assert((sev_snp->kernel_hashes_offset +
+                sizeof(*sev_snp->kernel_hashes_data)) <= len);
+        memset(hva, 0, len);
+        memcpy(hva + sev_snp->kernel_hashes_offset, sev_snp->kernel_hashes_data,
+               sizeof(*sev_snp->kernel_hashes_data));
+        type = KVM_SEV_SNP_PAGE_TYPE_NORMAL;
+    }
+    return snp_launch_update_data(addr, hva, len, type);
+}
+
 static int
 snp_metadata_desc_to_page_type(int desc_type)
 {
@@ -1125,6 +1145,7 @@ snp_metadata_desc_to_page_type(int desc_type)
     case SEV_DESC_TYPE_SNP_SEC_MEM: return KVM_SEV_SNP_PAGE_TYPE_ZERO;
     case SEV_DESC_TYPE_SNP_SECRETS: return KVM_SEV_SNP_PAGE_TYPE_SECRETS;
     case SEV_DESC_TYPE_CPUID: return KVM_SEV_SNP_PAGE_TYPE_CPUID;
+    case SEV_DESC_TYPE_SNP_KERNEL_HASHES: return KVM_SEV_SNP_PAGE_TYPE_NORMAL;
     default: return -1;
     }
 }
@@ -1155,6 +1176,9 @@ snp_populate_metadata_pages(SevSnpGuestState *sev_snp, OvmfSevMetadata *metadata
 
         if (type == KVM_SEV_SNP_PAGE_TYPE_CPUID) {
             ret = snp_launch_update_cpuid(desc->base, hva, desc->len);
+        } else if (desc->type == SEV_DESC_TYPE_SNP_KERNEL_HASHES) {
+            ret = snp_launch_update_kernel_hashes(sev_snp, desc->base, hva,
+                                                  desc->len);
         } else {
             ret = snp_launch_update_data(desc->base, hva, desc->len, type);
         }
@@ -1781,6 +1805,18 @@ bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
         return false;
     }
 
+    if (sev_snp_enabled()) {
+        /*
+         * SNP: Populate the hashes table in an area that later in
+         * snp_launch_update_kernel_hashes() will be copied to the guest memory
+         * and encrypted.
+         */
+        SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(sev_common);
+        sev_snp_guest->kernel_hashes_offset = area->base & ~TARGET_PAGE_MASK;
+        sev_snp_guest->kernel_hashes_data = g_new0(PaddedSevHashTable, 1);
+        return build_kernel_loader_hashes(sev_snp_guest->kernel_hashes_data, ctx, errp);
+    }
+
     /*
      * Populate the hashes table in the guest's memory at the OVMF-designated
      * area for the SEV hashes table
-- 
2.25.1


