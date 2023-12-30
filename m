Return-Path: <kvm+bounces-5355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A540B820749
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:27:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8CCB1C214BB
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:27:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A0AA14A9E;
	Sat, 30 Dec 2023 16:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ue7TFx/O"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C92915484;
	Sat, 30 Dec 2023 16:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bv8o4HKlm4uK0eF9SVRiDrjXosc+kYv7NNm91ATXUiLlEz9mYN8WyDLDB3/ebAcc1XuzK9nm4lvGjOWyLcBjlXI+w1pYPlZ7HHHhB+mble7+zmAAyI/ZkQxDd5pA4YI016612DJB4jT3du1GACzmxZXGzYTdPn3qw3Pk6AwA5mngYS7JVRtBVGFGiEazW1Et4fhksVic1m+Ku5CZ+NEFeBPlBh/5KmMFfoTowBlz/Ix8B6v1koohbTMFcun4O/WWTSqKpv48Xm244ZAS7ZdPIYZzD4skK4g2J+3Bl9DQoRkxxcGg4lLo5AEx4ru8+EWChOPvjdd+4LypZ6oNKnuWXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TnnZAnV/zJlnoSdwRXMjN05tLynu44lZtGj03GoCDQE=;
 b=mc+OvD8S2G2nL6gp5bE+M4gnravyQ47rHyDn4+Wyhefl1Fx8lRofj8V+O0PFNPNVSY1JOo84oqocZZ7rM8oOiFweD8Be1r5y/LcJ9txebqjUJUUuR2Zr6kk/Dzvpoh0SUWBfGoRsyuxk2xeLSzzHVTOxkypkU0OpFjlwsI7TTOW3gxodNm+5EX3tISW7CnNTAXnoUT7PDQqtOwQvJBMHLSv0e6kWCGKwukmhxyW91A28eH2eU80hKG9R/MmEFT14kJsxQ7Cq9AfgG5JPDNxNs3wRAAISoUDPPO/TFAb5T39Qimb7M09g1f3K9U1yLpRR9ZUfgIdsXIyQTOxqmr3wFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TnnZAnV/zJlnoSdwRXMjN05tLynu44lZtGj03GoCDQE=;
 b=ue7TFx/Oxv+0wezYlTVXZLWYPisDtnsXtyvrO99OvG6bTUuV2D9ES2KWKruCIysRLXolBtkF/eza5uyXW93rgWT9uTplX0wYk6d2/dZNO0vvaUesiCVx0L7ChfYyWHeK0obhB63/Pvsl8GIgpltzBqX+Mm0BnB9Y8V0+ilTh/tk=
Received: from DM6PR08CA0056.namprd08.prod.outlook.com (2603:10b6:5:1e0::30)
 by DM6PR12MB4862.namprd12.prod.outlook.com (2603:10b6:5:1b7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 16:25:35 +0000
Received: from DS1PEPF0001709B.namprd05.prod.outlook.com
 (2603:10b6:5:1e0:cafe::45) by DM6PR08CA0056.outlook.office365.com
 (2603:10b6:5:1e0::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.28 via Frontend
 Transport; Sat, 30 Dec 2023 16:25:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0001709B.mail.protection.outlook.com (10.167.18.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:25:35 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:25:34 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v1 19/26] iommu/amd: Clean up RMP entries for IOMMU pages during SNP shutdown
Date: Sat, 30 Dec 2023 10:19:47 -0600
Message-ID: <20231230161954.569267-20-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230161954.569267-1-michael.roth@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0001709B:EE_|DM6PR12MB4862:EE_
X-MS-Office365-Filtering-Correlation-Id: 399e0284-045b-4bd8-80c7-08dc0953f3b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8vOf7U2vw1Bh0kDMQsAZmIg63PJhoPGu+l405Kt0Z9qPSJtK2AULvLYVrObXxfXDpeqki5b32qguub9cA97y40oBGBsBQXXgwxjUdTYI1YSUMfCWUsw8pFhqKl+Vap4rDIXk/PGkB9zcb3dhGhI7WSKYwszHlA0f5iS3BLFjtjTJ7X7Gw8pZcw6CQDi8xVH/MPLYiwh7tD/bbYwSdc7cDl/EdSleLqcrTsmV6dq34aHfxb5Tfe6XjYivz2cpburSfIM8dJDf2rx1pdeGOonk1Z8v1SSwC4kNJ5F3ZTmTNjqbq25o3jUCxxdkW+9eSBLOp3yL5weJhRnyyJeocTt9LFKduMmZy6a0bNVHdgfvjfnzULB18ralPL9/8pHCRDxssrHeB98IxO1o14bQbh5K2b3oRIJuJIgeFfyNUjgt3E6L/X66/abKO5gn3dTGDdPbsEX7+lTzMR9aSw0Fld3x/O+i3wBKlGTVbXwMDVcVaYUGzpaKsvY6Prn+QGECt3H0skxa+S3FDK9O7r3zmSrQAGA0BevGfm3zHiv8u3SlEAO8JgzCnkLZ25ntNoIjIiLFOzTFbLjrRqRvlbA0eQwrl1MjE74CJn4aOAaMk+2ojG7DOi/QZkbcrVkR43rz9YDs8UCzW7HW7Y0vBBpIMAIa8HGYFoSL4Z+fGMacN48pNUdbCdy9wptYu/CBkTJfr0sFntjwxLxJmjiEJVq4v09tZ9VNC5xeyjY8OQIZLtBKppvUw/XRzNiI2ZAidk8EklXjlC2Qv1BtZVS65/BnDA7g4A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(346002)(136003)(39860400002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(82310400011)(36840700001)(40470700004)(46966006)(47076005)(40480700001)(6916009)(4326008)(54906003)(81166007)(86362001)(316002)(40460700003)(8936002)(8676002)(36756003)(356005)(44832011)(70586007)(70206006)(36860700001)(6666004)(5660300002)(7416002)(7406005)(478600001)(2616005)(41300700001)(1076003)(26005)(16526019)(426003)(336012)(2906002)(83380400001)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:25:35.4877
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 399e0284-045b-4bd8-80c7-08dc0953f3b8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001709B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4862

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
index 8cfb376ca2e7..47fc58ed9e6a 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -26,6 +26,7 @@
 #include <linux/fs.h>
 #include <linux/fs_struct.h>
 #include <linux/psp.h>
+#include <linux/amd-iommu.h>
 
 #include <asm/smp.h>
 #include <asm/cacheflush.h>
@@ -1675,6 +1676,25 @@ static int __sev_snp_shutdown_locked(int *error)
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
index 96a1a7fed470..3d95b2e67784 100644
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


