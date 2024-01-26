Return-Path: <kvm+bounces-7074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AD1683D3C4
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:50:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8ED49B25DFD
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:50:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BBDA134B0;
	Fri, 26 Jan 2024 04:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="F62Oz/Lm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A159473;
	Fri, 26 Jan 2024 04:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706244513; cv=fail; b=hrwEomA54ntNZvKN1yADtUwn4x+f5Rz4NoEz2YQWDikLxaOtRAnopV6yw/+OylFl3AOVQSM1W/AyjxykMHxDiED1kj64YbWvhBw5mD9sSrHRJXekbynlpE08IoaEvacz6douCQsIUKLmQoYT1wLQlOP8LP9gUcyt/MlZ7hh+9Lc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706244513; c=relaxed/simple;
	bh=l/IbKFSeRnsQmscad2gyqnPdcznbC47bJ1JMuvdP1Cs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TMHWf1Shoqb7OEx+JFRx2V2YgrzFuqt6N7JPFFckbFAcnvJErGWyVL+dTCsK9FqK9w4P0g0srjjHIybSlsikHH39wzrg8z2VavhCacRphf5fCZa5UrITiiTkQgt5RVWbkjn1jFB1b0fTZto6zpQqXYRzAH1GZadbtcqYeJGvpQk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=F62Oz/Lm; arc=fail smtp.client-ip=40.107.244.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJoKw6rhuXmJuUwVqt5/5wDop+qAHhnejFnBwOAp75+7vK0ll7t1gtxrkFo2UrTpMgwPVOBk0FI3hNP4cCbSCJ/V1IBWgHjaGmS233Q7sNSLqYP3j3bDvnoncbKKvOKSlsLMeY+Iz0g7gpv/YE018Ndne44hd3I3ooXBdqKZjU/p3T1zP38THaLVwXyaBNP+g9mn1KUx8W34jFHeJwGC8W0+5VZlld14H8k/BFLnGQJrA8iZh0+TnYsoBvgf2xepNYmGEVQe8d535YpTdzOUUud1gjHcdE6QkJZFhmIv6obbJwRAbLiF3VsZN5V5ExD1Eg5uxRMNUFLDkQ4itYeT3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3YVWcXzm+jfjuUhzMCYYR4/BYYox6gPlIYPWdG/TcLU=;
 b=MpapJ8nr231R0e31PMYJyNuWsMCzoU2Pl7e8OMIWk3JT/QwwY23iQSxLxmF7AD9vablVQFW5gmeP6Ze/Oz1uCIqfp+UOCkZzhfitKW6/rL/SvRSmlHUeMGh2exokyFw0nl96noJ2l1PDhcuzlLgpXihMHRRpi1VMqsxE6omnPJ25j+BDNOWIvlaqnHDa5FIasJZstWI2jipgtm61DvNpAXqLgluj3cT09Q2CjAKUO4iLEjIcaR3LahW0KFgHOODwyh/ne/wtgKf87UMFD00RlgU35cSzCdE/KcJWh7fuGRGvnsOIp9W9eJ4tt3h84fZa4IZiMLOkacRvUHqnjOwwyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3YVWcXzm+jfjuUhzMCYYR4/BYYox6gPlIYPWdG/TcLU=;
 b=F62Oz/LmNGvjnxumsssaQ3zEm10Vkm8eXwXuGEncMPDM9tsZXbwfiOYa6WRYwjhxiFXI/XC477ziE+Lcp2pNe81ica4rJNO/2LCw+gwDSoH+YfeLQFmf6Xv3+cGvInohGjERSLvVcdsoiHg4H//g/FQgCi0iF/AsoU6aIvf9jaE=
Received: from CH0PR08CA0012.namprd08.prod.outlook.com (2603:10b6:610:33::17)
 by DM6PR12MB4925.namprd12.prod.outlook.com (2603:10b6:5:1b7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26; Fri, 26 Jan
 2024 04:48:28 +0000
Received: from DS2PEPF0000343C.namprd02.prod.outlook.com
 (2603:10b6:610:33:cafe::e5) by CH0PR08CA0012.outlook.office365.com
 (2603:10b6:610:33::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26 via Frontend
 Transport; Fri, 26 Jan 2024 04:48:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343C.mail.protection.outlook.com (10.167.18.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 04:48:28 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:48:28 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v2 06/25] x86/sev: Add RMP entry lookup helpers
Date: Thu, 25 Jan 2024 22:11:06 -0600
Message-ID: <20240126041126.1927228-7-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343C:EE_|DM6PR12MB4925:EE_
X-MS-Office365-Filtering-Correlation-Id: a81e195e-16cf-4947-e7ae-08dc1e2a0a32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OEtPTSsE7CU9mO1D/RCzrp+9NQFIwleRRdOKv+/shvDy4Rz7x6u0M4Lt598UE5fLL/7FB/aiTChVpZcLFvWBXsfukuPiRkN55//nOfhm3yCT5AABLwFkEWWc57u9qB2Yqmo7gYjRoMLJu/3a1gOfiBxomcZfRAUmI45+QQBU/SZ+8bXF/9T5jZclzYebXLyAmVrQlJzgqXjBK5mMu+EABoaomq8F4V4NJpYma81ONQ8DTTk1pYy/WsBtKIlyiqkkDWSIMOkBhUyfpl+/ZwEAa3nbXhlCMyqDTlSXssLzrVL3GM3wtJuWM3weysXIlei3zSDXeqVLJbixajkN9yhv7pnxyfSe2RKyyJ6uQIpfdjGLF9JciE/Rh5rd4u2roqLpPchE1LC80IZs0rRNsrighzwKm0h8WGuGEUA4m8Yutt9O024/20DT1bOF8vmae0nfOqgSqWi/ZUWyNn9FBda19j7FDD5uWjvGRoMdAPzJO3Sa/G1ZcAEhtQ+bB4MQisPFV1VA/o8mQBit+2Llbk/jBRGEtx/FYLy+7mLEPfYg18GGt+4XyMaeuWywoLBj8KD+Fh+lUUSh9TYU/JIiurtl13uck0Otef80Nsbgo9xOUJMAydF7T5D0VQFnNulnW/8FjX2TWJTg9lIcPlPmSNavU9ntLJIpyIo6eo5RWyUjN3Bj/uC4Z1M3w+N3R7WY74mdgZu0NYfK/3dI2XYT0/Oa9nwnr+DP4MYFROuHo6TKLA0xw+rB0MHUr2g4TSG4ho0eNDRQQuZVhdXtyKMXRMzU65n0OuH5yhlsTC2YpX71AtQ=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(39860400002)(136003)(396003)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(82310400011)(46966006)(36840700001)(40470700004)(83380400001)(47076005)(1076003)(2616005)(26005)(36860700001)(316002)(4326008)(82740400003)(426003)(336012)(70586007)(5660300002)(44832011)(8936002)(8676002)(41300700001)(70206006)(7406005)(7416002)(478600001)(6666004)(6916009)(2906002)(54906003)(36756003)(86362001)(356005)(81166007)(16526019)(40460700003)(40480700001)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:48:28.7554
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a81e195e-16cf-4947-e7ae-08dc1e2a0a32
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4925

From: Brijesh Singh <brijesh.singh@amd.com>

Add a helper that can be used to access information contained in the RMP
entry corresponding to a particular PFN. This will be needed to make
decisions on how to handle setting up mappings in the NPT in response to
guest page-faults and handling things like cleaning up pages and setting
them back to the default hypervisor-owned state when they are no longer
being used for private data.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: separate 'assigned' indicator from return code, and simplify
      function signatures for various helpers]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev.h |  3 +++
 arch/x86/virt/svm/sev.c    | 49 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 1f59d8ba9776..01ce61b283a3 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -90,6 +90,7 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
 /* RMP page size */
 #define RMP_PG_SIZE_4K			0
 #define RMP_PG_SIZE_2M			1
+#define RMP_TO_PG_LEVEL(level)		(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
 
 #define RMPADJUST_VMSA_PAGE_BIT		BIT(16)
 
@@ -245,8 +246,10 @@ static inline u64 sev_get_status(void) { return 0; }
 
 #ifdef CONFIG_KVM_AMD_SEV
 bool snp_probe_rmptable_info(void);
+int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
+static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return -ENODEV; }
 #endif
 
 #endif
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 575a9ff046cb..7669b2ff0ec7 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -53,6 +53,9 @@ struct rmpentry {
  */
 #define RMPTABLE_CPU_BOOKKEEPING_SZ	0x4000
 
+/* Mask to apply to a PFN to get the first PFN of a 2MB page */
+#define PFN_PMD_MASK	GENMASK_ULL(63, PMD_SHIFT - PAGE_SHIFT)
+
 static u64 probed_rmp_base, probed_rmp_size;
 static struct rmpentry *rmptable __ro_after_init;
 static u64 rmptable_max_pfn __ro_after_init;
@@ -214,3 +217,49 @@ static int __init snp_rmptable_init(void)
  * This must be called after the IOMMU has been initialized.
  */
 device_initcall(snp_rmptable_init);
+
+static struct rmpentry *get_rmpentry(u64 pfn)
+{
+	if (WARN_ON_ONCE(pfn > rmptable_max_pfn))
+		return ERR_PTR(-EFAULT);
+
+	return &rmptable[pfn];
+}
+
+static struct rmpentry *__snp_lookup_rmpentry(u64 pfn, int *level)
+{
+	struct rmpentry *large_entry, *entry;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return ERR_PTR(-ENODEV);
+
+	entry = get_rmpentry(pfn);
+	if (IS_ERR(entry))
+		return entry;
+
+	/*
+	 * Find the authoritative RMP entry for a PFN. This can be either a 4K
+	 * RMP entry or a special large RMP entry that is authoritative for a
+	 * whole 2M area.
+	 */
+	large_entry = get_rmpentry(pfn & PFN_PMD_MASK);
+	if (IS_ERR(large_entry))
+		return large_entry;
+
+	*level = RMP_TO_PG_LEVEL(large_entry->pagesize);
+
+	return entry;
+}
+
+int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level)
+{
+	struct rmpentry *e;
+
+	e = __snp_lookup_rmpentry(pfn, level);
+	if (IS_ERR(e))
+		return PTR_ERR(e);
+
+	*assigned = !!e->assigned;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
-- 
2.25.1


