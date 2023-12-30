Return-Path: <kvm+bounces-5340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DA4DF82071A
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:20:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65BB11F213BE
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:20:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 633EBBA31;
	Sat, 30 Dec 2023 16:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Qi4IGBd0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2061.outbound.protection.outlook.com [40.107.95.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F115BE4D;
	Sat, 30 Dec 2023 16:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BP/uX1FjkURr7t6F9B6rGTs+jDPvdYiAyizrsiebZQKGtHd9t/jtsEyT7z+BoJ7/cGUpYBiKP3p0/qtZ+S32ayLFJ5kxV1i2QhQPwN/cZGzsCI8QhPAFgZzEuI4FAGi3KnzSMUzNuMeuj6VVy0FtnRrsnYXRnL7hBApdmmwYWgFHq3UlD0VBQ34jyMbxYDjV0A6aKQhKOy8Ad7XqXxH/jbCXD2NpqyzHeXDP/u1z/PGXQNzeynT7qMqEVKS37l8gI7oYb5bjcpda8+aHrIyMsiXxrRH19AWRa9taDmO5ps2JKHdngXdQikB5ZVGnibgGkF5x+6VFbptSR8+NJn2s/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jT21oM7hF8GJ7QiA3VH/SoVsWv4M1q1DV5y907a+zac=;
 b=SvjNB+mIE825dobN0JAAsQltliKM1Aj1av9S3jWnJHeDx4XaPn3/ev4+VVgPjswWjj5bxK6EMqdbHTbJhxMMF9pWRZuar4m8halEZkvv6Mdp2k4SHdq5Evap0H8JMZMN1RwMr26s599b2AEI2yKGtS9Td+sIiCGM6hA8IpcJAxs/Td3ETsGNiTNhwDnbjN6d2M6EsN06pZVJoAfhj9u+GVuTvnvObWMnsQs4us9MxUOWrV6ExTnmANRHodWWYN7Eu675MT1EzWqaqpQMKjH5higqHehEl258KFnSpkEwuhsY4w6NbfoqGZXONF95774SIauIDvHl2v1bXFeRHo5jNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jT21oM7hF8GJ7QiA3VH/SoVsWv4M1q1DV5y907a+zac=;
 b=Qi4IGBd0WpQjZU24ieP1V/z14eTUkMDpByeiPzGlgrt4AHCzlc//SKIK/W76WfrIkey6MqNpJWpAChX4h5GMEexUWIA5xE+ySeEjUWtMQ6yEQ0Gb2EDIkncz+COFdPgspYxIxnNce5Y7HYt0dIjQ7l+019pIE1UkMCmk2o6pzMM=
Received: from DM6PR03CA0073.namprd03.prod.outlook.com (2603:10b6:5:333::6) by
 MW4PR12MB6951.namprd12.prod.outlook.com (2603:10b6:303:209::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 16:20:23 +0000
Received: from DS3PEPF000099DC.namprd04.prod.outlook.com
 (2603:10b6:5:333:cafe::63) by DM6PR03CA0073.outlook.office365.com
 (2603:10b6:5:333::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.27 via Frontend
 Transport; Sat, 30 Dec 2023 16:20:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099DC.mail.protection.outlook.com (10.167.17.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:20:23 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:20:22 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v1 06/26] x86/sev: Add RMP entry lookup helpers
Date: Sat, 30 Dec 2023 10:19:34 -0600
Message-ID: <20231230161954.569267-7-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DC:EE_|MW4PR12MB6951:EE_
X-MS-Office365-Filtering-Correlation-Id: e71555b1-0b8e-4803-7a0f-08dc09533987
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	HjtvCXtXmA2OCtgiLfWFCJe8EwEruu/0Lb/QuZSRk6kLZEIO4qSnIVgPSxGDzhj+VaVPniBvjrSvXYhtBRBlXdfOEQgzSjHwNg40Ml3qv+eTVvtif71kQ6rntz4BWKZ35fHHbEwn7PZlpOWDClOjgtftJuFoiVg8ZiFeNSwjhtEf0r6yuDkX2LPYeiCO1saLK2K7qmbEgkgxalOR3SCCa8Q2x9vTQCXdfdo67KYYiSIKOj3UBedNA4dxqEpaTTAadHdy0iokBxUwNdLAc3kEj7/GrUMTZgsAeYEkXDE7HYd0D9RBeRaCfHszxDCFUO8YEoWEvO+c/kN/3I7SKRjcCWCYFSUN6ytgqXJ+MqDFKzRja2pHgffc/aRfaTY1QJHdLPVqzLkqnaTDLJrKOlX9ImBeLlOr24mh+r5irqSWSgqnTHbClufbhfwx6jOfLcixh279/yhlXuv2jwIZBwuy6jYxdxilgXTQTJUvf96YEAonMCbCBD5v3z+3/AAEWVndw87qbDach36TAvlAZLILKdMTDRKu/eMjMyPQWdjojM8MtKu4EIHJ/1lmCkmsfQQPSa9XO5z0kAdOWEqsQtKclkuzRzFn4DTxLneM5IVXfjV3Qqu/2mUwjRB5OYswmenZGXW/XN4Ervcu0UheIA93FC3YxFLBlxR3B+YggerOK6WE2LM1gkpO8pGwHGy9wqLSZ1lTk/pAhBy2r6M7z3gdGLTpEVRMv8QvyeAkvjys5h7d4juQNB7d8nP6ZUyfsyT0vcoYXSx5ss3nMGKvMfjENRmuvw2rJ/MB9YGo8Hz2/GA=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(396003)(376002)(346002)(230922051799003)(82310400011)(1800799012)(186009)(451199024)(64100799003)(46966006)(36840700001)(40470700004)(26005)(1076003)(54906003)(70586007)(70206006)(40460700003)(6916009)(40480700001)(2616005)(6666004)(83380400001)(4326008)(8676002)(8936002)(36756003)(316002)(336012)(426003)(478600001)(16526019)(44832011)(7416002)(7406005)(5660300002)(47076005)(86362001)(356005)(2906002)(81166007)(36860700001)(82740400003)(41300700001)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:20:23.1102
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e71555b1-0b8e-4803-7a0f-08dc09533987
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6951

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
index ce7ede9065ed..49fdfbf4e518 100644
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
@@ -217,3 +220,49 @@ static int __init snp_rmptable_init(void)
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


