Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499DD64D102
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiLNUUI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiLNUTg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:19:36 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061.outbound.protection.outlook.com [40.107.244.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A7F4877D;
        Wed, 14 Dec 2022 12:08:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aqAwigH2I0kR7P7hkeoHLS7Y/nzwmn4vvLNm8PkW8Ta8sjEA1c4ol2YBQ0Z3MgyzvN2YbjClEDJo3ulTqG9xJVclTXirqm1i5+r0r5bupkmlLlA9zhuQ+8/vrGTX0Skz1kZSRrI/1wchEmy95s5JgQhypVWypbZ8l4AoVQHx6SMmGsXMq5Y6WOFm3alNptLSMTioEIQWeET7BAYr7jZ/RMirg6Zj8iWMTGUX1E0C3hnL83vsx0usRJsdL4lnCzFlPREU/NQOVaYtz8xDbfnI3btOxrlhAiYzCOj/ShWDJkWnBbgxMq8Ojrsj90xWuoZ566AKlkvS1Gn2lz+1odCnbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=usdDmXcJMmcLw3KYUul5HJCtUTgF2Nhc7TpOXVijSeg=;
 b=hmhg9KeHlOk4HewIOT0+2oJCX11LVaXoChqKH0Twu0Y8OXFcaO3lGuVLSUgF4yVt7clSob6Tr8QITG3NbSWPkAm9Ut+OnuM1Zs4GLX2cPYdKERg0RxU2d0UpgUD9QHW0qi4frgd8MmZPIh/SM4e1PIrWTAn4ihZfZ7TCI9vd1Y9gBkKg0G1J8wDh7svJCcQ6oS+Xrku6HcC7HSK2hflletEJ9xtpAAIIK0RLB6Q1Oq+PAuXCYFJuxYBIYiuIGGwOfb3Y3e27S1MXuysFTjQ3+Gfjy77oE5+xK9gnjSIGpkS93/gDt9QR29wykrzVWtgdlLbgrRhk0V7TQtRz7xYD9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=usdDmXcJMmcLw3KYUul5HJCtUTgF2Nhc7TpOXVijSeg=;
 b=L1O/IH/Ix7vxJnbehYDLQ9liOghjkQD1Az218hcQCYXP+X+0NwiJ/my3/WShMp8h8B8JQhxqnUJe2yjy+kKlEd4GS4MP6jT4rnbChN2iw9bMS5vVYDDnuHKB7RVhMpIhcNw4vO2VjLxuqvyhPk9D9q83PX7EoZiHF0gE8A1oY4w=
Received: from MW4PR03CA0103.namprd03.prod.outlook.com (2603:10b6:303:b7::18)
 by MW4PR12MB7285.namprd12.prod.outlook.com (2603:10b6:303:22e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Wed, 14 Dec
 2022 20:08:06 +0000
Received: from CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b7:cafe::64) by MW4PR03CA0103.outlook.office365.com
 (2603:10b6:303:b7::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 20:08:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT035.mail.protection.outlook.com (10.13.175.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.11 via Frontend Transport; Wed, 14 Dec 2022 20:08:05 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:08:05 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>
Subject: [PATCH RFC v7 64/64] iommu/amd: Add IOMMU_SNP_SHUTDOWN support
Date:   Wed, 14 Dec 2022 13:40:56 -0600
Message-ID: <20221214194056.161492-65-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT035:EE_|MW4PR12MB7285:EE_
X-MS-Office365-Filtering-Correlation-Id: 7dce4a32-8379-4710-13b0-08dade0ee9cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b2+L6GruvxCW4T89GjBwMM36vRjU5Su1Jjgi8uIGi06/wCUych8U+VvxqDLNMgwo54ExX8uOMubAWwuGWY/Fa0CCS5wt4Lc6k5UisUj8H4Idil8lmVmHzo0RoS2kAsWZL+u703FAuCo9zAEkxZVr5H34iVqLOs8smmfiTFD82PJHhwo0P+Q+PbcC9XB4NqadC8HnU1WBMvK9BtG2gehPBzIz5p/E2mC7hujrtn363ul1Fcrtu7qg40Zbjc+7iI2BFFXiQVkAALHouHg13JvqGgJcduB/EwVma5lY9WtU8dsDfGPzduIOsR9XFhF+Wz0WEPG85ksYQjBFIee8Fi35k66sO6C/b+q84kKFSUdo3Ka42G59z+ErTaNgOpAXF9s7EFdzXtCsznR2gGbN0/0laId6G6vVygpaYi35LIrJSz16iUtcOwbV25CwEqeECsLVc1pRR6xPATarK7ilN8DQ3duFHwysIzN1i4xM/B0Fa/dxajZ78RLMIHZrlPqjEd3nhe26GzG0aAiatwd0nzzgr5ZoNVMR7Qvm6/iY/MyDoxATqA/HsdszfAUBBAgO7GnF6bugR+ZwR3EN7sbpPbDnWxenySjjOqT+WsCfEZwy+9CC3EX0BH0AbncAufskOLgqf1S/309vb2EQZa1EUv4Xmp7qriBIlXJkDAWk8/ZsCncqly7I46KPXLr3nbKh6md2dcpz267l3TTsrhhk+fPwB670LdE0aMVvQjDf2MM+4W0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199015)(46966006)(40470700004)(36840700001)(426003)(47076005)(1076003)(8936002)(336012)(36756003)(8676002)(316002)(6916009)(7406005)(2616005)(4326008)(70586007)(70206006)(41300700001)(36860700001)(81166007)(40480700001)(54906003)(82740400003)(7416002)(83380400001)(86362001)(5660300002)(356005)(44832011)(186003)(2906002)(26005)(40460700003)(16526019)(478600001)(82310400005)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:08:05.8354
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dce4a32-8379-4710-13b0-08dade0ee9cf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7285
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
 drivers/crypto/ccp/sev-dev.c | 20 ++++++++++++++
 drivers/iommu/amd/init.c     | 53 ++++++++++++++++++++++++++++++++++++
 include/linux/amd-iommu.h    |  1 +
 3 files changed, 74 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 052190bdb8a6..6c4fdcaed72b 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -24,6 +24,7 @@
 #include <linux/cpufeature.h>
 #include <linux/fs.h>
 #include <linux/fs_struct.h>
+#include <linux/amd-iommu.h>
 
 #include <asm/smp.h>
 #include <asm/e820/types.h>
@@ -1503,6 +1504,25 @@ static int __sev_snp_shutdown_locked(int *error)
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
index 1a2d425bf568..d1270e3c5baf 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -30,6 +30,7 @@
 #include <asm/io_apic.h>
 #include <asm/irq_remapping.h>
 #include <asm/set_memory.h>
+#include <asm/sev.h>
 
 #include <linux/crash_dump.h>
 
@@ -3651,4 +3652,56 @@ int amd_iommu_snp_enable(void)
 
 	return 0;
 }
+
+static int iommu_page_make_shared(void *page)
+{
+	unsigned long pfn;
+
+	pfn = iommu_virt_to_phys(page) >> PAGE_SHIFT;
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
index 953e6f12fa1c..a1b33b838842 100644
--- a/include/linux/amd-iommu.h
+++ b/include/linux/amd-iommu.h
@@ -208,6 +208,7 @@ struct amd_iommu *get_amd_iommu(unsigned int idx);
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 int amd_iommu_snp_enable(void);
+int amd_iommu_snp_disable(void);
 #endif
 
 #endif /* _ASM_X86_AMD_IOMMU_H */
-- 
2.25.1

