Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65007552760
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346016AbiFTXAK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346037AbiFTW7u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 18:59:50 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2054.outbound.protection.outlook.com [40.107.236.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87703205E8;
        Mon, 20 Jun 2022 15:59:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tk2dEX4b2KLhHMfixP65J7XawgJjop2VsOpVsAEq/5fm8i29Yond5EGE15FvmsthOGNIU4Qck02C1LO9IOLdp4uBY7xBQEo9aicYTNg41NrMSukfA+PeeNHh+X/xb6xNySoOsqtwyVu0ijTbiyyDyVkjmKVvKwHQCMVqA5LDq4JLXCpkl7ET7xRzkWT9Cz5GV9/HDs72n4JDQ+xAgRz30rStWtkuS6xHsip/xj6mOxVM9K6m4CeCAx44jHBPLkQG6WP3qWRpvH2odkpNu6rT65xphhAExpMrpmUs15t8FepcYaEbIQA6ZJZ7GYLo4YhagW907AWhlJJ+bM3Xw5ncuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qWtkoywXsFUOi7HV75QlnjfiZABOS8Pl5BSeXom/RJo=;
 b=kmqokeZKPg4BT62eVIRMQ9EoBm8gjIrMkZfzXbua7pItAMdGY0JqxYk7foux1Y1/PWa/QV+CkR8lDW0nMugTlYzMmo12nsQjqWGPfjIeKLqbHr2NuLrvzuCC7k7iHCk6eOvtbUckfxlvvLNnGIJZlWofCj7ZjQcZdRR0wAGue7zh6Kw5Jsy1+50bzE+OhPluAhltj64m811Ra7lNVO3biqb8UDyKomseM7A2D4sVM5I8GEXZRq8YTxFSyN11EfTYGI+tXlXMHknUnk347XoFWcdRaHcgUBPXdtLUXBqbB1bG+M50SZzBfZKymysH7lp5SpgKhOZwWRJjc1JQ808SRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qWtkoywXsFUOi7HV75QlnjfiZABOS8Pl5BSeXom/RJo=;
 b=3B4OVeW26zqCeQFUD8o/1y12WqTVC9LpkOSF9KtYvp3+AolIv0xQUwp5Hsk/vgmfaT0mD8WH/hstaY2gFVSB6jqIPGgCXG7IlMuZwdBLr8yUnRLuOyyBqeWO5jVOIbubBlA6iNQwn7FgmeEWzU/sVq7EcV1oWzgAQB6U/2MZ5H8=
Received: from BN6PR14CA0018.namprd14.prod.outlook.com (2603:10b6:404:79::28)
 by BYAPR12MB3142.namprd12.prod.outlook.com (2603:10b6:a03:de::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.19; Mon, 20 Jun
 2022 22:59:31 +0000
Received: from BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:79:cafe::5f) by BN6PR14CA0018.outlook.office365.com
 (2603:10b6:404:79::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Mon, 20 Jun 2022 22:59:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT011.mail.protection.outlook.com (10.13.176.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 22:59:31 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 17:59:29 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 02/49] iommu/amd: Introduce function to check SEV-SNP support
Date:   Mon, 20 Jun 2022 22:59:19 +0000
Message-ID: <12df64394b1788156c8a3c2ee8dfd62b51ab3a81.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82e25892-27e4-4c49-59f7-08da53108979
X-MS-TrafficTypeDiagnostic: BYAPR12MB3142:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3142439479E0AC110E3957668EB09@BYAPR12MB3142.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tnS6Wu1aG/WUizIotX28K1Pl2ZTxiDaLpBhsRQ/2zCJ2gpwI9cpAeyyU4We6zV1an/RPTwxUEvr9xbtbnD31ejfb8OuQ+CuaCCZ3EIktnFisLF+DjKfsYKUbh1x0WmjGhk2d4JvDOq1alxS8ZHu2SdCyZ5Um0RLSUFU9aJCTydNORx3loxQyieouxAdqFKL6l9VO7D4F/EdTRjNjDiiYIC88OghUX6oVMFHdpzR5Os0t2Fu49oVVHskK/XU7Q7JktyW5J9TiaF2OTn4pLqzcWp8Y3gQJTGngz8vPIIgzNrqvcC7FxlfFtsbw1R5h7wZQ+koBgG9eYmcw4xbqO0T4hScs0s1JTTQwSxomchiwppLYqyyXmjucRaLulf3y2qsXLBPLp16hKN4s9DjNCLERSvOTekvjm5K+BO77Ppz+YcXfdOwXhHGTVtqwktL+RAlqFvQge5XsfZ/UlIHBgS5qmRi7V+qjVy4X7WnxSZxPthRR+765YUJPe9N0HnClDjLv2ZngQwb1XsZZrycYBBk16wPqkDrQdPRgL+11QAYEjybSbNNSRJ3oi7VvbpSfDUrH0qF1AW2G8Hq8+gdDtgBRaXmrOT3VZT7Xk+ubCEoFTht5gbynKx4cGV3pzBCTRKaKtNIF2IhrrTX9T4iz4/DzT7kITO4izYyfHMQ+0NXGTRJMDxV/23OYNdrOIXsqDC9lxWLkuo+qVv9MtDT8DmM3jSy1yCq+NygitMq6FqyKwb/lcdA78Snxa99uYzilM67JAf5fSA55OzvkHffaeLKBeQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(136003)(346002)(39860400002)(46966006)(36840700001)(40470700004)(41300700001)(2616005)(426003)(82310400005)(186003)(16526019)(336012)(26005)(83380400001)(47076005)(36860700001)(36756003)(40480700001)(7696005)(7416002)(81166007)(356005)(2906002)(6666004)(54906003)(5660300002)(8936002)(478600001)(86362001)(70206006)(70586007)(4326008)(8676002)(316002)(40460700003)(110136005)(82740400003)(7406005)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 22:59:31.6735
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82e25892-27e4-4c49-59f7-08da53108979
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3142
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The SEV-SNP support requires that IOMMU must to enabled, see the IOMMU
spec section 2.12 for further details. If IOMMU is not enabled or the
SNPSup extended feature register is not set then the SNP_INIT command
(used for initializing firmware) will fail.

The iommu_sev_snp_supported() can be used to check if IOMMU supports the
SEV-SNP feature.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/iommu/amd/init.c | 30 ++++++++++++++++++++++++++++++
 include/linux/iommu.h    |  9 +++++++++
 2 files changed, 39 insertions(+)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 1a3ad58ba846..82be8067ddf5 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3361,3 +3361,33 @@ int amd_iommu_pc_set_reg(struct amd_iommu *iommu, u8 bank, u8 cntr, u8 fxn, u64
 
 	return iommu_pc_get_set_reg(iommu, bank, cntr, fxn, value, true);
 }
+
+bool iommu_sev_snp_supported(void)
+{
+	struct amd_iommu *iommu;
+
+	/*
+	 * The SEV-SNP support requires that IOMMU must be enabled, and is
+	 * not configured in the passthrough mode.
+	 */
+	if (no_iommu || iommu_default_passthrough()) {
+		pr_err("SEV-SNP: IOMMU is either disabled or configured in passthrough mode.\n");
+		return false;
+	}
+
+	/*
+	 * Iterate through all the IOMMUs and verify the SNPSup feature is
+	 * enabled.
+	 */
+	for_each_iommu(iommu) {
+		if (!iommu_feature(iommu, FEATURE_SNP)) {
+			pr_err("SNPSup is disabled (devid: %02x:%02x.%x)\n",
+			       PCI_BUS_NUM(iommu->devid), PCI_SLOT(iommu->devid),
+			       PCI_FUNC(iommu->devid));
+			return false;
+		}
+	}
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(iommu_sev_snp_supported);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 9208eca4b0d1..fecb72e1b11b 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -675,6 +675,12 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev,
 void iommu_sva_unbind_device(struct iommu_sva *handle);
 u32 iommu_sva_get_pasid(struct iommu_sva *handle);
 
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+bool iommu_sev_snp_supported(void);
+#else
+static inline bool iommu_sev_snp_supported(void) { return false; }
+#endif
+
 #else /* CONFIG_IOMMU_API */
 
 struct iommu_ops {};
@@ -1031,6 +1037,9 @@ static inline struct iommu_fwspec *dev_iommu_fwspec_get(struct device *dev)
 {
 	return NULL;
 }
+
+static inline bool iommu_sev_snp_supported(void) { return false; }
+
 #endif /* CONFIG_IOMMU_API */
 
 /**
-- 
2.25.1

