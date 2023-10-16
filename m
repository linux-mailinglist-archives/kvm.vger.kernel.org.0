Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5CD7CAA20
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbjJPNpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233943AbjJPNpe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:45:34 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E6FCD42;
        Mon, 16 Oct 2023 06:45:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBL4QsRUpewUI8Ved8gkgHnR1mI29W66fGcdsoexzlt7akLlWWLilwmBYJ4KL26IyI4qvhkEsyxvdpO808Zbs+RZHBwJ94bhx6Ke2pgRc8vp5ezgI7owPcJRFZPenuQdlA/P0lpIzrXCPWQ8Lnk9uNaotLlKuSe8f8tLMUVO7gvEHwtTLEtCaR9WAI6xa+mvnfrAX3prOoNlBpgcY9PcVI1TCygEDeNOHXLU/UubVDvl/Kw7txm67pUIdqlnvCePooEtDyEnvbXAh4i7x3cWs4G8NvsLFghXc2vsbX3/pU7UuckYqtlrvWWZ/EwDKChothOeYZSnE78XempPrkjQ+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bhbXIE0ano0OyIuW3N/el7ObSSoUCNHdYim0IDKn0KU=;
 b=nxaAyoOJXeqVLZIFK9NVPc6wtfcJvQ7O9S9TewewMdZhxxk3cgvG8zzfuc6osPNhvDbhSgvoUzl9IV2YFC8VEFfvzzBldkjlg/IrzLC3blsUkIi0q6um6v0pFIfgh/YOk7WUf0ujdIbJPVc793VtMGHC1lGRI8q60NNUM7/SXfxa8JMDFGO/4ioXvZTvkoVrvERpdztx8L/c9PGsBEP3RVW8CCc9gyG+0C1kaQnf5yH04u0gt15p8k0SrbiYE23JF8rOrFag/nZpkubJKw1LgZyQRMSeA8nXgKSVcEgi1MW3Xa0nai1Do6hDy8fW/kpabdkCkRhqR5ZRMeg4d/n84w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bhbXIE0ano0OyIuW3N/el7ObSSoUCNHdYim0IDKn0KU=;
 b=HK6U59+bpuNswD+hkEq2zMDxj5kCELel8KLLslnRqFSJUovTWJfVC/W943CTY0L2v3OVe+DovZgVS4k6I+0PYrHAn6K25GBD+DbUaNPzhuTN6DQgS2yWiZjKYl0oVPoL9r6OEeuIAqcg1/daVWvVgRJHwPnAAcwrUKpzpECQpVY=
Received: from SA9PR13CA0152.namprd13.prod.outlook.com (2603:10b6:806:28::7)
 by LV8PR12MB9406.namprd12.prod.outlook.com (2603:10b6:408:20b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 13:45:29 +0000
Received: from SN1PEPF000252A4.namprd05.prod.outlook.com
 (2603:10b6:806:28:cafe::e2) by SA9PR13CA0152.outlook.office365.com
 (2603:10b6:806:28::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.17 via Frontend
 Transport; Mon, 16 Oct 2023 13:45:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000252A4.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:45:29 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:45:28 -0500
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
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v10 44/50] iommu/amd: Add IOMMU_SNP_SHUTDOWN support
Date:   Mon, 16 Oct 2023 08:28:13 -0500
Message-ID: <20231016132819.1002933-45-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016132819.1002933-1-michael.roth@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A4:EE_|LV8PR12MB9406:EE_
X-MS-Office365-Filtering-Correlation-Id: ac3b2969-72b5-431a-0dab-08dbce4e2904
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3pNmMIIast1rFX9qob05w5+eDRSvz84DtdPA/+i5sJOKVozzqU1LFeCGW9BsYK+09kDJSNx36fqeF6kAPkmQwmarAjerq2cV/Nh1sQg5mGWNtrIbvTZrKUlqvE2qzoPnn5UgaPYsDrGRDLCcGIzCH+/S63Kxf0SHRcVb9OSY7ke65P0O3iSbLyp5d5DGxm7fbc3UCQi2vQ/7VGN4rC+qaaO0qaYEQlyw//uR7WPG6AlE0v0Y5b88LwNxmIJiUvGXMLZRGSWufRfG80vQBJ7zQWnh5Tp4gXdoif0nysorJLzjYRkiwcNh56TZMexIKlZehtpaTYBV4lufzhlTT6RskJe+CxNaohjJUJhMuxii2M9OFsqjPWBK2tPfQsSqE4gU4ZYx2xdWVhWXc+SFsUxpVUqZAbKyB7xec/WD6X32dVsJQBlYz+ylxJ+O8e2TFYWJo9HwwjFTK5WXRIKAE//qkhy2PGBEHQgmELH/klVGKmIdvZjOh1zi0OKUPQE0/zG3IMQ9VBVr7sGiKi274yj/a+lc/MqV6HblxZpDyGxK2fhCcoVbgyC9er2k+peaKUJFx5J2L3LmM/l/QxCcwPG9GtkSVs2d6ULQd7+q9E+jxNUJ8hvfuRtNUbdYjUuGMPKGS0cn9gIH4b2/v6ar9rtglcoLNZiVJ/wgQbJxOkALWVrsumwJ0hN3AqNb7Qt+tojxnCKCumOmhUf9Lb7GIoEkWu80nXHq3on8tCOX7PmpGDZvl+/JDXIAOyr6uypauTkvHLScdInReWseErUYyCTH/w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(376002)(39860400002)(396003)(230922051799003)(82310400011)(1800799009)(186009)(64100799003)(451199024)(46966006)(36840700001)(40470700004)(40460700003)(6916009)(70586007)(316002)(70206006)(54906003)(16526019)(1076003)(26005)(336012)(36756003)(426003)(83380400001)(2616005)(356005)(81166007)(47076005)(82740400003)(86362001)(36860700001)(40480700001)(478600001)(6666004)(41300700001)(5660300002)(44832011)(7416002)(7406005)(2906002)(8676002)(4326008)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:45:29.3334
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac3b2969-72b5-431a-0dab-08dbce4e2904
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF000252A4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9406
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
 include/linux/amd-iommu.h    |  3 ++
 3 files changed, 78 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 679b8d6fc09a..0626c0feff9b 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -26,6 +26,7 @@
 #include <linux/fs.h>
 #include <linux/fs_struct.h>
 #include <linux/psp.h>
+#include <linux/amd-iommu.h>
 
 #include <asm/smp.h>
 #include <asm/cacheflush.h>
@@ -1513,6 +1514,25 @@ static int __sev_snp_shutdown_locked(int *error)
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
index 1c9924de607a..6af208a4f66b 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -30,6 +30,7 @@
 #include <asm/io_apic.h>
 #include <asm/irq_remapping.h>
 #include <asm/set_memory.h>
+#include <asm/sev-host.h>
 
 #include <linux/crash_dump.h>
 
@@ -3838,4 +3839,58 @@ int amd_iommu_snp_enable(void)
 
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
index 55fc03cb3968..b04f2d3201b1 100644
--- a/include/linux/amd-iommu.h
+++ b/include/linux/amd-iommu.h
@@ -207,6 +207,9 @@ struct amd_iommu *get_amd_iommu(unsigned int idx);
 
 #ifdef CONFIG_KVM_AMD_SEV
 int amd_iommu_snp_enable(void);
+int amd_iommu_snp_disable(void);
+#else
+static inline int amd_iommu_snp_disable(void) { return 0; }
 #endif
 
 #endif /* _ASM_X86_AMD_IOMMU_H */
-- 
2.25.1

