Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C3D69D3D6
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 20:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbjBTTI5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 14:08:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbjBTTIx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 14:08:53 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA32166DA;
        Mon, 20 Feb 2023 11:08:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z/Zt95TYguED0j75IMIetOmHnYQyZDjUneQsiw/UtNo+/1/LFd0iGB4Jb6hA4EUY/tIOYSWGFcJnxgAysB6TRUo5o/jN2ROgz6mtJr4g8o5fthDxhPtCSs4/R9B74gsB1VTAIR0chLuF5DBD/jZxGF/mGrn9XjZVwO+tqWB6e+1plYOvzYfChsQxGv3Fb3TC4YIa9tdXH8CloAHaMqtKjHeRs6E4s5FvyHtIk5IuvmvjafnGvhySMQStzeXYFG3PUACBMF/f+P+JnqrU4e6wMUIlOAylDveCievsQmHlJZurdRACyMQkh9ThsmXOKy0RnWpTPB+1UIZdrhcceZejhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xfgvNgPkzXxiD3rUfJwSEsnsZDwFqlVnWGrip+638u0=;
 b=CdXECGTskGdUt58NZqxEZg3D0Bd9XbtEUzzArPSedjhUqpkDjCI8FLlvBAkqL7ZM8MLwBQoBW1xRGrtAjaPdrnICSWdrT4Q22isicUOEmYN2+ZzPPj0ANTzqk/dKoEDHz72occEP3UGlvbI6BXoHgu4qelN2wNVlhZvsHlaZtc+vCyTGJgKoJL5fI8m9FtP8TDDbE7O08oMcuEjKk46MtWfaUCWXKbxkwqSKmjk8PdvFqqplHh5TouuQidiajZTvK8ByZrpQlKXVVNxr93I4vf+vnwNq0QHp/0VUWttL3O+4GNDTvDxjwrWrd1urA1Z6g/c68vemr3NnmEOi0X/FLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xfgvNgPkzXxiD3rUfJwSEsnsZDwFqlVnWGrip+638u0=;
 b=sCzOp8ro4SFWXtWwIr143m2wbwzFpF050yzqxY2bzyhR3kRQ3HL4X+XUgAohQ92O4Vw2qZjSwUcwLc+ek7MPGY/hGlMpj+dl0nWFNgogWUojUI4WJYemHiI0S8AvvZ+q8g30e5FC2DfbuW7OSR7fINPOCnq9zJviZ2aLX0+/+kw=
Received: from MW4PR04CA0049.namprd04.prod.outlook.com (2603:10b6:303:6a::24)
 by SN7PR12MB7936.namprd12.prod.outlook.com (2603:10b6:806:347::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 19:01:23 +0000
Received: from CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::48) by MW4PR04CA0049.outlook.office365.com
 (2603:10b6:303:6a::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 19:01:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT003.mail.protection.outlook.com (10.13.175.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.20 via Frontend Transport; Mon, 20 Feb 2023 19:01:23 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 13:01:22 -0600
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
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>
Subject: [PATCH RFC v8 56/56] iommu/amd: Add IOMMU_SNP_SHUTDOWN support
Date:   Mon, 20 Feb 2023 12:38:47 -0600
Message-ID: <20230220183847.59159-57-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT003:EE_|SN7PR12MB7936:EE_
X-MS-Office365-Filtering-Correlation-Id: b369f4ba-f405-4719-1d71-08db1374dc2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: InLlUBpeVAYIg/MCVuuByIk89FbaZCdlRaVm9cviSpw20tuDsXRgA7avVWo8QYnwlZN17YjjLQ1/KsRHm/aWU9M2vHCrf+TMo+f/h8R5z4zMBvoU8O5PzvJ/IV5J9yGQ6TdnTP+5lbhdvXvkamd66QLV2bwaQbxZ6ZeLK+4UUuffBQQwZoTcQhigB2WF7AhbRIGD3S45WUzjPqc0pH2ETKCfWaGzTIogSRvkXrYIjdM/d6wu4JDUnQ+WJMYO3Eygl/Y1zlxyzGNVuOxRiZm2kBOr7l0OI9GadNKqI2b2Sdl5hfCEuA55R9gfAwiZz2V/agopa/l18f0gMm0uMC7VWndPfUx7xPtrxrS8zIPyGbUbREjJnqyrvUKVYYzYN4quVnyzQycZz+nY63ZjjjblwF1eAC1EGXGGRYnMjVm+o+l6XTluFOEHakbmPLpaJPCbj2EwQeQlhys/KEcP6EOKGnNHXDudZelvxmIlWZbzz5MqFV/uZ95pgzq/egpJTrHrZJEbbCSV7VlphcF1HFJM712E6TjqvPCubfaXk+L7hNyX0N2Q2gvSeazIgNPqqqtwV9KcaUj/ZyekjquDo8B+Chu4wdKoMveoIiAlz+OGrenHpQ4W721ACZPDcEGQTsX42kJmYeMm2YDmtML5buV6gx9qa13bxcMJT2ICIdkdIn/Rt24stqrklW8X5b1tSzp6uy7cC7VD+Sv7CV98WrVoQCYEROplhYxd4OpIZlKxZlY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(39860400002)(396003)(451199018)(46966006)(40470700004)(36840700001)(2906002)(186003)(26005)(16526019)(5660300002)(7406005)(6666004)(7416002)(44832011)(2616005)(36860700001)(47076005)(426003)(40480700001)(86362001)(40460700003)(1076003)(336012)(8676002)(6916009)(70206006)(356005)(70586007)(4326008)(81166007)(41300700001)(54906003)(82310400005)(316002)(83380400001)(478600001)(8936002)(82740400003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 19:01:23.2729
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b369f4ba-f405-4719-1d71-08db1374dc2d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7936
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
index bf5167b2acfc..7ded2f9111e0 100644
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

