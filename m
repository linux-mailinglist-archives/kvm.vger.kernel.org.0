Return-Path: <kvm+bounces-7054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C678783D387
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:42:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B6FB1F24443
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21219BE62;
	Fri, 26 Jan 2024 04:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="S1OFy/N+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2070.outbound.protection.outlook.com [40.107.212.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6D911701;
	Fri, 26 Jan 2024 04:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706244100; cv=fail; b=OphD8OxLeuo3Ciz77PHfk+J3SRa2Nb1VU6NsK0YDBipC471GSwqtXda9hXTBMNGOQUtjD30PmvrlvpchHBJJxVEBNk31afYw/vV2GVCW1QwX5C58GEJwkc7prTdKje/W+PN2dh8p7Gg+/xp74tY8qf30hhz9OxP7AiuLwLdHW9Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706244100; c=relaxed/simple;
	bh=oMhffWMH4gBDKpXTOEQua4Uit8ORyMhn4p8Xg1w3Dp4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TQQ83IxGD2OnzCkBU7cXeo4Cx8BVGRyCjhysexdy+cnrRbMxFrv1CECXToW45iFNzrvA0c9kOOy94gpIwyl/TdFDUyUU/9HKPtDM1lYOjWQ7pRmXU40aqb1RIQqwETi3LSZzMbuopAuIik0BxSPnZuSdglVzHTyBkw7TJxNM9Ko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=S1OFy/N+; arc=fail smtp.client-ip=40.107.212.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fO4d3+LsIpzF4A9aewJtDNAS5cz80Tm76FCsb7V1BeCa49AF+Aw1GXEVxAGWHVBXn27eRY7V+JwGddDd9L3TFqKT0WLQBuc8qzjQcjycCzbpzrB7ljaPuwTa1ZX1VkdRXQIiT3Cnohq5Ri4RcJum84zweRieqU/z4VBx/0VXqNFCHSG6GfB8Xa0JfBC53VTzNfB4fLPvHJ2eVAv4m65IcJjzW1FcARR7aEPAPrRPEmZmuL1yo21qubGeHodG+FAyH9s/nfXbvMcTMdMHfZw25COQrdhDtQ9sley+9eeg4iSvPrD4hhe/0hp8tl0K0vmi/q+/HjUfujWA5RJb/buWVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ieXJvlkx0ARe4Dlb1EX+7YF5/vwoMHH96EazENT13Fs=;
 b=P5YTGBuosp3dA87a1NT+FIDR5RfnSqRMfDivs543Ih7nktM7cx9vhekEnWAyI4cT2z7KDSXhmhr0j3yenQf/UOy/fo58nDdB9CYW3ygI26IsajKpcZDuhYLD0+HgpZuBUzG9kcN9e554Cvl9E4sGgHWQSpF6mrWAf6DiYg8ylZ75mW6WWFynZg/R2s6P3XwFy+pVoT+dbkGiNiHJu9ebfQiaqdnKfvcznaErTNL9WhuqtJRuywdxtM5rsOGvG9C9My6N4OKqp5LlHY0J1wsJx9dD3jut6eLzNnyXWAkSPQV7o/cu1YjZzTYstKAYiSUQxwurbyARb7eE/gQLhx/nJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ieXJvlkx0ARe4Dlb1EX+7YF5/vwoMHH96EazENT13Fs=;
 b=S1OFy/N+fIm6BHMIkkW3Npopu4kla6Oix4WQ7HWEgZDSlzhvUQYXCveRWUssMnQHlHGJlRWny6A+ahf0Aixk8z6O7VvJIBNDEophXv7xt1kGjH40ZR08wric2965EnVtVwcqzaiU2fzy7EpMjg/cjXnblq+eYHC7A9cqTyUMkm8=
Received: from MW4PR03CA0279.namprd03.prod.outlook.com (2603:10b6:303:b5::14)
 by IA1PR12MB6233.namprd12.prod.outlook.com (2603:10b6:208:3e7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.24; Fri, 26 Jan
 2024 04:41:35 +0000
Received: from MWH0EPF000971E4.namprd02.prod.outlook.com
 (2603:10b6:303:b5:cafe::10) by MW4PR03CA0279.outlook.office365.com
 (2603:10b6:303:b5::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26 via Frontend
 Transport; Fri, 26 Jan 2024 04:41:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000971E4.mail.protection.outlook.com (10.167.243.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 04:41:34 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:41:32 -0600
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
Subject: [PATCH v2 11/25] x86/sev: Adjust directmap to avoid inadvertant RMP faults
Date: Thu, 25 Jan 2024 22:11:11 -0600
Message-ID: <20240126041126.1927228-12-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E4:EE_|IA1PR12MB6233:EE_
X-MS-Office365-Filtering-Correlation-Id: 443f62dd-9e6a-4b06-a1b7-08dc1e291371
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lqKkq3OIPj0YoZqJN8zaR/lu25NFzon3JReU10qoBWHzdU8K92JplpoQV2Z/f4FbpwraHSTbGQuPByj7elzh+QeitFwCwO4oXaR84MiO85vX5WZyfneIdnQOd3mpZWCVV/AG7UztY8TkV+ofmZcDGt3ETU5fyRFyHw8WMmP+M049LwEgG/gcOpLVLd/ZeA70WkSZ4xLDyF0HFux3LEdu+MhgEkEwhRDxqXtDWSSgeoqKdGG4338NjFn8gsAjBn4nc7zFZ2hBImfh73bAGfxKZllDBqRTFwLno4WJy1q4lGD+1EcYjHddGX4xei44/uqxjzksJ72ErRPe7iW/VQGV1yDBosaXyOYxY4m7H02hMGszex3cbb8v3dCU2QBvjMmuamJ1/vwtdSMUnWc0HTPDAqlQSma/pZwW6L378u9RxDKTYMnJSqGLAkbG0K0tJWNA1gzulDiuOx6fssgNLjiziOHVwtvtQvJg88ppm8lgeFBtirn2Uqcm6mJj1Y1A7gqGX30AOxMMFhrEcm4Mg2aYE94iMlm/HkjNFU5o9F7NZ+OkwzMrK19F8lj8tzSEWGFkOF57apaF5vBhosnKm025XLdkCwrHXkYXRX8SiRpj+JlxkVtfPSCj8LaWe2ulnYh14q9fnVzYaQBOs/KPANa0ZfpfMhB6oz8a09ZUIslfu4pLtSBLulnqi2n24J7d59LJjg3NqN4lvvIQKWKT7OlXijiE3CBqX0hu1Yxb6nUjqhvvNkxmPhG6fUtCQMsJwkVjmg13CZZKe+1MP9F1DT7Mmg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(396003)(39860400002)(136003)(230922051799003)(64100799003)(186009)(1800799012)(82310400011)(451199024)(40470700004)(46966006)(36840700001)(40460700003)(40480700001)(83380400001)(47076005)(41300700001)(356005)(86362001)(81166007)(36756003)(82740400003)(426003)(1076003)(5660300002)(36860700001)(2616005)(26005)(16526019)(336012)(70206006)(54906003)(70586007)(478600001)(6666004)(316002)(6916009)(2906002)(4326008)(44832011)(7406005)(7416002)(8676002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:41:34.6911
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 443f62dd-9e6a-4b06-a1b7-08dc1e291371
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6233

If the kernel uses a 2MB or larger directmap mapping to write to an
address, and that mapping contains any 4KB pages that are set to private
in the RMP table, an RMP #PF will trigger and cause a host crash.
SNP-aware code that owns the private PFNs will never attempt such a
write, but other kernel tasks writing to other PFNs in the range may
trigger these checks inadvertantly due to writing to those other PFNs
via a large directmap mapping that happens to also map a private PFN.

Prevent this by splitting any 2MB+ mappings that might end up containing
a mix of private/shared PFNs as a result of a subsequent RMPUPDATE for
the PFN/rmp_level passed in.

Another way to handle this would be to limit the directmap to 4K
mappings in the case of hosts that support SNP, but there is potential
risk for performance regressions of certain host workloads. Handling it
as-needed results in the directmap being slowly split over time, which
lessens the risk of a performance regression since the more the
directmap gets split as a result of running SNP guests, the more likely
the host is being used primarily to run SNP guests, where a mostly-split
directmap is actually beneficial since there is less chance of TLB
flushing and cpa_lock contention being needed to perform these splits.

Cases where a host knows in advance it wants to primarily run SNP guests
and wishes to pre-split the directmap can be handled by adding a
tuneable in the future, but preliminary testing has shown this to not
provide a signficant benefit in the common case of guests that are
backed primarily by 2MB THPs, so it does not seem to be warranted
currently and can be added later if a need arises in the future.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/virt/svm/sev.c | 75 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 73 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 16b3d8139649..1a13eff78c9d 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -368,6 +368,71 @@ int psmash(u64 pfn)
 }
 EXPORT_SYMBOL_GPL(psmash);
 
+/*
+ * If the kernel uses a 2MB or larger directmap mapping to write to an address,
+ * and that mapping contains any 4KB pages that are set to private in the RMP
+ * table, an RMP #PF will trigger and cause a host crash. Hypervisor code that
+ * owns the PFNs being transitioned will never attempt such a write, but other
+ * kernel tasks writing to other PFNs in the range may trigger these checks
+ * inadvertantly due a large directmap mapping that happens to overlap such a
+ * PFN.
+ *
+ * Prevent this by splitting any 2MB+ mappings that might end up containing a
+ * mix of private/shared PFNs as a result of a subsequent RMPUPDATE for the
+ * PFN/rmp_level passed in.
+ *
+ * Note that there is no attempt here to scan all the RMP entries for the 2MB
+ * physical range, since it would only be worthwhile in determining if a
+ * subsequent RMPUPDATE for a 4KB PFN would result in all the entries being of
+ * the same shared/private state, thus avoiding the need to split the mapping.
+ * But that would mean the entries are currently in a mixed state, and so the
+ * mapping would have already been split as a result of prior transitions.
+ * And since the 4K split is only done if the mapping is 2MB+, and there isn't
+ * currently a mechanism in place to restore 2MB+ mappings, such a check would
+ * not provide any usable benefit.
+ *
+ * More specifics on how these checks are carried out can be found in APM
+ * Volume 2, "RMP and VMPL Access Checks".
+ */
+static int adjust_direct_map(u64 pfn, int rmp_level)
+{
+	unsigned long vaddr = (unsigned long)pfn_to_kaddr(pfn);
+	unsigned int level;
+	int npages, ret;
+	pte_t *pte;
+
+	/* Only 4KB/2MB RMP entries are supported by current hardware. */
+	if (WARN_ON_ONCE(rmp_level > PG_LEVEL_2M))
+		return -EINVAL;
+
+	if (WARN_ON_ONCE(rmp_level == PG_LEVEL_2M && !IS_ALIGNED(pfn, PTRS_PER_PMD)))
+		return -EINVAL;
+
+	/*
+	 * If an entire 2MB physical range is being transitioned, then there is
+	 * no risk of RMP #PFs due to write accesses from overlapping mappings,
+	 * since even accesses from 1GB mappings will be treated as 2MB accesses
+	 * as far as RMP table checks are concerned.
+	 */
+	if (rmp_level == PG_LEVEL_2M)
+		return 0;
+
+	pte = lookup_address(vaddr, &level);
+	if (!pte || pte_none(*pte))
+		return 0;
+
+	if (level == PG_LEVEL_4K)
+		return 0;
+
+	npages = page_level_size(rmp_level) / PAGE_SIZE;
+	ret = set_memory_4k(vaddr, npages);
+	if (ret)
+		pr_warn("Failed to split direct map for PFN 0x%llx, ret: %d\n",
+			pfn, ret);
+
+	return ret;
+}
+
 /*
  * It is expected that those operations are seldom enough so that no mutual
  * exclusion of updaters is needed and thus the overlap error condition below
@@ -384,11 +449,16 @@ EXPORT_SYMBOL_GPL(psmash);
 static int rmpupdate(u64 pfn, struct rmp_state *state)
 {
 	unsigned long paddr = pfn << PAGE_SHIFT;
-	int ret;
+	int ret, level;
 
 	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
 		return -ENODEV;
 
+	level = RMP_TO_PG_LEVEL(state->pagesize);
+
+	if (adjust_direct_map(pfn, level))
+		return -EFAULT;
+
 	do {
 		/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
 		asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
@@ -398,7 +468,8 @@ static int rmpupdate(u64 pfn, struct rmp_state *state)
 	} while (ret == RMPUPDATE_FAIL_OVERLAP);
 
 	if (ret) {
-		pr_err("RMPUPDATE failed for PFN %llx, ret: %d\n", pfn, ret);
+		pr_err("RMPUPDATE failed for PFN %llx, pg_level: %d, ret: %d\n",
+		       pfn, level, ret);
 		dump_rmpentry(pfn);
 		dump_stack();
 		return -EFAULT;
-- 
2.25.1


