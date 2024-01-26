Return-Path: <kvm+bounces-7062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 69DF983D39F
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:45:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED01C1F24C27
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:45:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A0CFBE65;
	Fri, 26 Jan 2024 04:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iCYTuyQX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62D012B84;
	Fri, 26 Jan 2024 04:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706244264; cv=fail; b=Pf29fdsp+dGH8VPHHPeJmFRgkRe/4jkXIViPY2c39isUymvsSlGgvETZLCEJiHYtdG+WMYxJRkkWlnJScZX176jCaHUzgRlxzeagEpvl+eQZAlwmpP9xfB6vwFvRlFnyPW+swf/I2cgrOfHeGmSywu3fn+s5Dm7uKyo2z6uKh8I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706244264; c=relaxed/simple;
	bh=rFQHte2t4t3G1/OOE02HGpFuvyVgpIu9vJi2P9nJRZg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YuQnMDCAMIcv+laK0wWcT25jgm5M0vPFBlB8je4Oje0pgaiYtp41PMjNwfoesOpEllvHoLAVmBT7c8od+fcTmMJyixeAF/mlbiX5CrmdcSBQ8LlpWFOcMfrFGzqfIMZRsTwzN/jSEFHBE8y2u60i9BGEU/IJO+v7WG5VVivZYbo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iCYTuyQX; arc=fail smtp.client-ip=40.107.237.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=arIXtEDaW2ZrrZdfdRWg6FDXMREgjXCopdMb673d6b1hgWTbFIaygcXcjdQhCYkVPrvQg4K6c1DGFGIXIuI+HFYF2huxYmXpAgGmLcgn2hrwPDlXk7YoEaDAq9vSs8KDXd2wJYP0OwajB5zO2YtJSNxgMSug9LMj1vbtkiyxMNdYviRS2n9UP2jqGqWoXihINzN0CltLIqhTIAHZaDig9obn0LtqGOWfGN1j/aqhXrNKgviPJcHLvOYETZmtbRuNgjjxbWKDKJFR0kBuuRmNl+5RB30JSuHFijjlT4tQUsT4cq3QYsS1YoKMpYvtOvMKpYqv4qa0O6X/9iPiQ70sMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+qG75r4WHkgWbMzwHKr0H1I3Mb70xWCu5pDmxLxzbm0=;
 b=FCFdqCGWmi9ZHUZhSUNMEAniKR0J4+9hEWV5TIvnFfAEyw2ovdLPQlzGc1UGKHcRTBL8Gup3dGViUtSFQ3GHs68YLM9VrE2iSU8FccSrczg2zS/9lOdDYtzDxjpZQczclxX0xO2XEHg5wffx93rQ992u4adBo1c1yoiARtym1X1ehdyme7AKoLl5qgZAxu+Y8p66QkTYwq3R5VK4I6Xg1doW6GjOw/1KBXU0pNwoOD57VhQMaTbYUvAD3SwdNVTfv+Xhv0axY7z1ry0up1GAxwFYvrWwJdZaip1nxREQbatowbQLEOCpynRDY5Y8zrhk4SxMBSLuFdZ9SN4HmzohpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+qG75r4WHkgWbMzwHKr0H1I3Mb70xWCu5pDmxLxzbm0=;
 b=iCYTuyQXK9QqQXk+8+TeDi6mI7k8g7wYKx3vfgFNIrFc+qzXjbgYbkYDcBfVQYQ+WuNKK+vhigzeVCWu7tYAT27fmcf078+Cvej+O0HQNA9wj/l6of5CSXpVtAtkz7AoVEz13sdxk+qVKKoQ+I3TGC4uRgZLLQw3btH2z+XK5yg=
Received: from BY5PR16CA0027.namprd16.prod.outlook.com (2603:10b6:a03:1a0::40)
 by IA1PR12MB6555.namprd12.prod.outlook.com (2603:10b6:208:3a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Fri, 26 Jan
 2024 04:44:19 +0000
Received: from MWH0EPF000971E7.namprd02.prod.outlook.com
 (2603:10b6:a03:1a0:cafe::a5) by BY5PR16CA0027.outlook.office365.com
 (2603:10b6:a03:1a0::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26 via Frontend
 Transport; Fri, 26 Jan 2024 04:44:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000971E7.mail.protection.outlook.com (10.167.243.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 04:44:18 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:44:17 -0600
From: Michael Roth <michael.roth@amd.com>
To: <x86@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v2 19/25] iommu/amd: Clean up RMP entries for IOMMU pages during SNP shutdown
Date: Thu, 25 Jan 2024 22:11:19 -0600
Message-ID: <20240126041126.1927228-20-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240126041126.1927228-1-michael.roth@amd.com>
References: <20240126041126.1927228-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E7:EE_|IA1PR12MB6555:EE_
X-MS-Office365-Filtering-Correlation-Id: ce8654d0-eb09-4f90-6a13-08dc1e29753c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	c1/N+NOdlDEYkL8nup6ZrqkbaTUwNTx4w1tb1kYLBF2ZsRUeoE/t4rCcWjHvSbOskC3cZ3B/D1Z4m4Dj9X31dfu/fKaKzwuoqfGO+iO0wqy6dTi/W1e2g3vLPSmO6K5ShdywZCLi+EPavjm3W8nicVnWvVQMUTNB0yiuYpdifelJd2jrgFT5O9X9JSzpK9ZcQbXmkabI92VThui4MTF0YR1TW8j97jWjVUVuLQwrLAMBk5zrHYbyVe0SUSbTF3qWMwisNZLJUEdVaI+7r+3qubvVtKWwK4bavN6LPixo4hEZ/T8LlYo8a4Y6KT1K7GDjAQHOTOhUvPnNukiY4oMVoyLOfXCSIKBsG6XyljAE7mPr+YlrAavs18G8K3LfmkCzRSaEUEMbXPifsR3F0mMHoOQ37KFWu8xj+diXpGq/iE0pQBKVwDxVVNsgJZ+YfpzkiyMbcT89heNQ8IAsmtgPYO6MMVnKDJbeM4lFmrtC5/08d2YmUjIMXLPk5x/H101OZRw4TAn6yc6Io4VucyT1P9kkFTsXKhgyCXufEA27X4R7F3P/9617yVnYS8Oaw/V3JMrRVUyyT5hI4MpNm0VncYs9RWAEnZo9q6xtE0TUh9ERq8HP6JPgdwLhUg2clR/l9BTwCnLQArCW7rQsp8Usgtq2ls+qV/Rk69kB6rk1HizZkvwx7pNbs3oUDudfPGW0rswQZ3XSu9kPTn56lnby1PisRRKjomyNU27UiemNwbazxDGQZxi4oPrxY5yn3JcBTToQ9fGqY9qtxXOX3oiSpA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(376002)(39860400002)(346002)(230922051799003)(186009)(1800799012)(82310400011)(64100799003)(451199024)(36840700001)(40470700004)(46966006)(8936002)(8676002)(4326008)(36860700001)(5660300002)(82740400003)(7406005)(7416002)(2616005)(1076003)(70586007)(70206006)(54906003)(83380400001)(44832011)(47076005)(6916009)(316002)(36756003)(356005)(81166007)(40460700003)(40480700001)(2906002)(336012)(426003)(478600001)(26005)(16526019)(86362001)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:44:18.7591
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ce8654d0-eb09-4f90-6a13-08dc1e29753c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E7.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6555

From: Ashish Kalra <ashish.kalra@amd.com>

Add a new IOMMU API interface amd_iommu_snp_disable() to transition
IOMMU pages to Hypervisor state from Reclaim state after SNP_SHUTDOWN_EX
command. Invoke this API from the CCP driver after SNP_SHUTDOWN_EX
command.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 20 +++++++++
 drivers/iommu/amd/init.c     | 79 ++++++++++++++++++++++++++++++++++++
 include/linux/amd-iommu.h    |  6 +++
 3 files changed, 105 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index b2ad41ce5f77..d26bff55ec93 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -26,6 +26,7 @@
 #include <linux/fs.h>
 #include <linux/fs_struct.h>
 #include <linux/psp.h>
+#include <linux/amd-iommu.h>
 
 #include <asm/smp.h>
 #include <asm/cacheflush.h>
@@ -1633,6 +1634,25 @@ static int __sev_snp_shutdown_locked(int *error)
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
index 3a4eeb26d515..88bb08ae39b2 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -30,6 +30,7 @@
 #include <asm/io_apic.h>
 #include <asm/irq_remapping.h>
 #include <asm/set_memory.h>
+#include <asm/sev.h>
 
 #include <linux/crash_dump.h>
 
@@ -3797,3 +3798,81 @@ int amd_iommu_pc_set_reg(struct amd_iommu *iommu, u8 bank, u8 cntr, u8 fxn, u64
 
 	return iommu_pc_get_set_reg(iommu, bank, cntr, fxn, value, true);
 }
+
+#ifdef CONFIG_KVM_AMD_SEV
+static int iommu_page_make_shared(void *page)
+{
+	unsigned long paddr, pfn;
+
+	paddr = iommu_virt_to_phys(page);
+	/* Cbit maybe set in the paddr */
+	pfn = __sme_clr(paddr) >> PAGE_SHIFT;
+
+	if (!(pfn % PTRS_PER_PMD)) {
+		int ret, level;
+		bool assigned;
+
+		ret = snp_lookup_rmpentry(pfn, &assigned, &level);
+		if (ret)
+			pr_warn("IOMMU PFN %lx RMP lookup failed, ret %d\n",
+				pfn, ret);
+
+		if (!assigned)
+			pr_warn("IOMMU PFN %lx not assigned in RMP table\n",
+				pfn);
+
+		if (level > PG_LEVEL_4K) {
+			ret = psmash(pfn);
+			if (ret) {
+				pr_warn("IOMMU PFN %lx had a huge RMP entry, but attempted psmash failed, ret: %d, level: %d\n",
+					pfn, ret, level);
+			}
+		}
+	}
+
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
+	return 0;
+}
+EXPORT_SYMBOL_GPL(amd_iommu_snp_disable);
+#endif
diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
index 7365be00a795..2b90c48a6a87 100644
--- a/include/linux/amd-iommu.h
+++ b/include/linux/amd-iommu.h
@@ -85,4 +85,10 @@ int amd_iommu_pc_get_reg(struct amd_iommu *iommu, u8 bank, u8 cntr, u8 fxn,
 		u64 *value);
 struct amd_iommu *get_amd_iommu(unsigned int idx);
 
+#ifdef CONFIG_KVM_AMD_SEV
+int amd_iommu_snp_disable(void);
+#else
+static inline int amd_iommu_snp_disable(void) { return 0; }
+#endif
+
 #endif /* _ASM_X86_AMD_IOMMU_H */
-- 
2.25.1


