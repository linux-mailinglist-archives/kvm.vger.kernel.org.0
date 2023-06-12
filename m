Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A80572B706
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 07:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbjFLEza (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235813AbjFLEyu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:54:50 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298D1268A;
        Sun, 11 Jun 2023 21:54:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lcw/0SkLEgUMhS2rbtls+xYPYwN7YJjzp+1X3+EmQg/ZEmAoOxHF0oOpyBSkYi62h0M/2yjVl7wuz2E4hZ5WQ8KZZFxV0ic98chYIbEBwGFJCi1ns+GEArqSxNIVi6cWmDM4psj7ch46Dl65hqUcGZFXZgNJ99R26B6CmNTTP/7P9UrPl8e3cF5EHx4/wWeTnpPQlFT4O6woOjzgnw06TZnl968geHyu8BkP+oW1alrG3NYDR1Cvy+f7CZSmqjMDoST17uOYUGZQR/XxR/a1Bpy2xzfe11LI2DcrPFGPmZZlk/Y1q7+OSoVt+Ff7x0pjHo7Gqob+nVPOPC1PHxHpXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W7mzzYO76w209ixfz6AUBtX4bKrAJTU7/Cj1iL+ERcw=;
 b=Qd0v7n0P7UKHHtbZYiWrCvgx2i2P1Ec1zJ7hpzNQyV0/uahqK4nn0aX+gTq+CPCeQO4LrdvxAaWzKekFdzeUobRe8klT3Fe+K8SDGWOXRcYqR1KJt0Pm0jDMOvJCBF8AfaPcwokEx1uLVmgQ1n0ERTacgLI/qLBrU8Q40XgsDthLfEfNmlPy48Gcj7n+JRhV0iKgcPhHPO/pvjtZG1zIjqpZZMkey7TjEuoEqb8PmaQYEfc30R2PuMbkCgib/8brVlzZz2D3GZZMdsX+cApDs7FA02pcv7bd37RQlm15FF8dcdwDD47pTAiMEu6Q8iQd6tJeKjBiKWjG1EV0OJsTog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W7mzzYO76w209ixfz6AUBtX4bKrAJTU7/Cj1iL+ERcw=;
 b=CyTDyF8dQbEeJP9GphGEJz8lMj+iqLesa4TWDm/RAr7qBfzq7tqJ4P3lOA1D0fUtEZI2H5lVgw8WLam47WT1ynS0uIJOg/ML2RRNe1ahC2kMikER9mDlapWarpAn0DVzL13O9I/8Gn1kTtSkxg7iF8O/I6d03zmq6nBzrHE3Atw=
Received: from CYXPR03CA0084.namprd03.prod.outlook.com (2603:10b6:930:d3::8)
 by CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 04:54:17 +0000
Received: from CY4PEPF0000E9D6.namprd05.prod.outlook.com
 (2603:10b6:930:d3:cafe::dd) by CYXPR03CA0084.outlook.office365.com
 (2603:10b6:930:d3::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:54:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D6.mail.protection.outlook.com (10.167.241.80) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 04:54:16 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:54:16 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH RFC v9 47/51] iommu/amd: Add IOMMU_SNP_SHUTDOWN support
Date:   Sun, 11 Jun 2023 23:25:55 -0500
Message-ID: <20230612042559.375660-48-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230612042559.375660-1-michael.roth@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D6:EE_|CH0PR12MB5330:EE_
X-MS-Office365-Filtering-Correlation-Id: 24cc878b-6a36-43ee-53a1-08db6b01139a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zId6Rx0KWJvdknOLotHWFbZMQccpKFohyIcqZHwOp2tL/AbmvAUWk0CyHdU7xkOi51lfzojxnE9gYdE30fWM5+RAxoAN/h6wY13rUFnFLg/mFQxQK/iG2mUFlRJvCMMIlSDbiszRVkkwGNoIzIO+VXWz9EqHqV0/pKn4aeycwsFbqI0I5uvZZ7dQP1KJhIzWP7ov0rDcFM5auMvQncdtJE6438WsMnWWKGrGNdkBfQywz8QrsjsdlTG/DRONluliUVIqMegWS823JeZ3F5Y8vEE840Blz47ExW22U5Xbwh/OMpnjqTDGvc4xahE9YT0ch9XQBukLvznBRLa1J2NxZZVIk1rDUL4kbcannC695gfBn/zWFzjO5hnXdBdZyO0qFspzmTTiBtEi6EMnZli+qHwNYtYJvD6E8CwiBlWa0Jl+1FZk2LRYph26qvI0T1jbrHQ/zc9LWSMdO5Qx+tLfpcHeUsZHu/CtpIRJvh8ASeQ6uq6vALjjdeMDLSPwdy/3pkhzgzOMKBQYGaQgpDlZKhU1EvZrwr3HLxo914fD1fKbtnFQwPFZIDPLXPtGNvGDm4bWdpnm0LL6UdlfFqSWwCnUYtLNlUOlz6G+yx1FUzAceVlqv7VRsuiSbwNlSLtGL5pnnda843qTR7XKLI4hk+4hQdEyQ/7hTxLRK7dg9heNkAuN7yftmOkK7E0mLXOMjZog16omGZ8eLraFikcNvLYv/5veo47d6zM6+XkoxcFaeMDVWWN1a5aU+8l9SXj4TpNvDB/SSdgM4yme8JbrZw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39860400002)(136003)(396003)(451199021)(46966006)(36840700001)(40470700004)(40460700003)(6666004)(47076005)(36756003)(426003)(336012)(83380400001)(2616005)(86362001)(82310400005)(82740400003)(81166007)(1076003)(26005)(356005)(40480700001)(36860700001)(186003)(16526019)(2906002)(54906003)(44832011)(4326008)(6916009)(316002)(7406005)(7416002)(70206006)(70586007)(41300700001)(5660300002)(478600001)(8936002)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:54:16.9827
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24cc878b-6a36-43ee-53a1-08db6b01139a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5330
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Add a new IOMMU API interface amd_iommu_snp_disable() to transition
IOMMU pages to Hypervisor state from Reclaim state after SNP_SHUTDOWN_EX
command. Invoke this API from the CCP driver after SNP_SHUTDOWN_EX
command.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 20 +++++++++++++
 drivers/iommu/amd/init.c     | 55 ++++++++++++++++++++++++++++++++++++
 include/linux/amd-iommu.h    |  1 +
 3 files changed, 76 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 0bfe9721c977..b8e8c4da4025 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -24,6 +24,7 @@
 #include <linux/cpufeature.h>
 #include <linux/fs.h>
 #include <linux/fs_struct.h>
+#include <linux/amd-iommu.h>
 
 #include <asm/smp.h>
 #include <asm/cacheflush.h>
@@ -1508,6 +1509,25 @@ static int __sev_snp_shutdown_locked(int *error)
 		return ret;
 	}
 
+	/*
+	 * SNP_SHUTDOWN_EX with IOMMU_SNP_SHUTDOWN set to 1 disables SNP
+	 * enforcement by the IOMMU and also transitions all pages
+	 * associated with the IOMMU to the Reclaim state.
+	 * Firmware was transitioning the IOMMU pages to Hypervisor state
+	 * before version 1.53. But, accounting for the number of assigned
+	 * 4kB pages in a 2M page was done incorrectly by not transitioning
+	 * to the Reclaim state. This resulted in RMP #PF when later accessing
+	 * the 2M page containing those pages during kexec boot. Hence, the
+	 * firmware now transitions these pages to Reclaim state and hypervisor
+	 * needs to transition these pages to shared state. SNP Firmware
+	 * version 1.53 and above are needed for kexec boot.
+	 */
+	ret = amd_iommu_snp_disable();
+	if (ret) {
+		dev_err(sev->dev, "SNP IOMMU shutdown failed\n");
+		return ret;
+	}
+
 	sev->snp_initialized = false;
 	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
 
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 33ea62d93540..a84ec81cfbb5 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -30,6 +30,7 @@
 #include <asm/io_apic.h>
 #include <asm/irq_remapping.h>
 #include <asm/set_memory.h>
+#include <asm/sev-host.h>
 
 #include <linux/crash_dump.h>
 
@@ -3701,4 +3702,58 @@ int amd_iommu_snp_enable(void)
 
 	return 0;
 }
+
+static int iommu_page_make_shared(void *page)
+{
+	unsigned long paddr, pfn;
+
+	paddr = iommu_virt_to_phys(page);
+	/* Cbit maybe set in the paddr */
+	pfn = __sme_clr(paddr) >> PAGE_SHIFT;
+	return rmp_make_shared(pfn, PG_LEVEL_4K);
+}
+
+static int iommu_make_shared(void *va, size_t size)
+{
+	void *page;
+	int ret;
+
+	if (!va)
+		return 0;
+
+	for (page = va; page < (va + size); page += PAGE_SIZE) {
+		ret = iommu_page_make_shared(page);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+int amd_iommu_snp_disable(void)
+{
+	struct amd_iommu *iommu;
+	int ret;
+
+	if (!amd_iommu_snp_en)
+		return 0;
+
+	for_each_iommu(iommu) {
+		ret = iommu_make_shared(iommu->evt_buf, EVT_BUFFER_SIZE);
+		if (ret)
+			return ret;
+
+		ret = iommu_make_shared(iommu->ppr_log, PPR_LOG_SIZE);
+		if (ret)
+			return ret;
+
+		ret = iommu_make_shared((void *)iommu->cmd_sem, PAGE_SIZE);
+		if (ret)
+			return ret;
+	}
+
+	amd_iommu_snp_en = false;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(amd_iommu_snp_disable);
 #endif
diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
index 8f0cde2d451c..7ba46118d0f1 100644
--- a/include/linux/amd-iommu.h
+++ b/include/linux/amd-iommu.h
@@ -208,6 +208,7 @@ struct amd_iommu *get_amd_iommu(unsigned int idx);
 
 #ifdef CONFIG_KVM_AMD_SEV
 int amd_iommu_snp_enable(void);
+int amd_iommu_snp_disable(void);
 #endif
 
 #endif /* _ASM_X86_AMD_IOMMU_H */
-- 
2.25.1

