Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C27847CAAB0
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 16:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbjJPOBN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 10:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbjJPOBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 10:01:06 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2046.outbound.protection.outlook.com [40.107.244.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629181BD9;
        Mon, 16 Oct 2023 06:50:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XKpySyAJZPf2sjy/vhRkOozeDbbz6J95hoqLT5gXiqfLL7rgM4PoeYNMFRMfkoUCZySsdehDD08Dja3QRXLQt6R/QS8jHVqr+xfNhPkWWmG4fHilhf+C/n0/JAmn6aVPv3J6aoUfvwi56TsDVb4Di6QQ5YEnh6QhPb8k4A5gntosXsbUwXcqk/OLHWnkfq2Xx5a+dryOS/0cGS1OIQtNgQNj5x0jQhk0HQAYAcNlGvtlDlKIP4zEuNdPhQuclmItDv4Cptm8pkvHV0K6pLkg54lHtElABbNsDuHGD8SEcB8h4fFifXnGaIH0nSRB5KYZI+OkoWouqPIPiMohy8DkEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K2jPFq3zSaAuWNyG4jBNg/BHf5AYOaiRiCgR8TmXnYg=;
 b=GCHUujVsvgCGpwoL/fe6+uEEevCrdXc50t2+Wwm5Xkw8AdsYcEekW8Njft46Pqzhk/qpG5iT5byzujs8AuprVad3+Zck0TaLL6b0I849ZOt1EKz2duCND9xJXKd/3+atB9szdiJP86HxEFePe5TDyeXuBrs/aga6ivGjCyGf3o3TfT9SSQ5WR7uhlDZ96eQajOrQDvW10/YXJtG9JJZ7ijNBZTdZIA139ycnuN9Tx5lca2ibH0vQvLus5Vbko46RfRVgg5ElzuUkwXW15TFuFXGbwkVfu6OMkwKRAXhBpwGUm2HSKDszQBuateRWzxku1++H68S9XMipseJcG7JCpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2jPFq3zSaAuWNyG4jBNg/BHf5AYOaiRiCgR8TmXnYg=;
 b=cR4TA750sF6P35N4nqGNslFPyR8MCRn3QMbBCE48P0pdmQXcuKhX6VVSu74sl5kIQdyf5eMUon9nHmJx1yPyBoJC2P5Yuoz/IciQhAEfBHQF/sZEF3yDkRZNCwNZ+b6wq9tEqToD5Yiju9emXM/8Yx7aLKITk8YHCyT4NGAPw9I=
Received: from MN2PR05CA0034.namprd05.prod.outlook.com (2603:10b6:208:c0::47)
 by DM8PR12MB5399.namprd12.prod.outlook.com (2603:10b6:8:34::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6886.34; Mon, 16 Oct 2023 13:50:08 +0000
Received: from MN1PEPF0000F0E0.namprd04.prod.outlook.com
 (2603:10b6:208:c0:cafe::45) by MN2PR05CA0034.outlook.office365.com
 (2603:10b6:208:c0::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.18 via Frontend
 Transport; Mon, 16 Oct 2023 13:50:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E0.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:50:08 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:50:07 -0500
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
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v10 08/50] x86/fault: Add helper for dumping RMP entries
Date:   Mon, 16 Oct 2023 08:27:37 -0500
Message-ID: <20231016132819.1002933-9-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E0:EE_|DM8PR12MB5399:EE_
X-MS-Office365-Filtering-Correlation-Id: 3171d637-841f-4052-16dd-08dbce4ecf87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xl20aVboR70WIe8Xh3rdB/oQQ0cWBgrRIpCUPBzbusv4mW+tf9Ewae/m7p3fOCc871IpzYU2/NYedPgOHtvWVcmBwbXz01XU2WPx5UJrehdFG9DXoFdlun5UPg2XCYbPoDFhqyOt9/5aX1M4e13E9Yqp+16VHNV7/2fil3w2FqOCM/36GzweyVGX3zYkNgYgZPRgl3sidam548O/ZfmAIIBdaVY29pxQLIHDzjg7zoPi6No6B6xwxsB8kfPN4bpkqXimKyHekMWGv183+2ox9ULLv0io4/Hr82jhLAevZvdXPbxP67isM8OzrgL8Rg56XGlqHOP0HKeQmp6QdpAWi80Dn/aNd523mIUPfVqysd3y4FvaJVg6483e6+tnmow8Mc5fu9stZfVUB8tHL7N40Amist/vU30n0qokTeCK42Tg77dwM0RgT0uCEoWAlmVsWU1/7ay5aPJq2CUlFmvalyxCtzSFvnba461r1KkHPEXhmtErgaDUzZThZr11zUchpWCcEqkIKuyFXby6Sup57NDkijevrDCfRFZHCMxBeydE5ajobcu3uOZptsx3U9bn8Ofh2zbXHSBbIAo+mMtK3u7L9WFyFUlzGFplYPmuqx3Ll06SnxQQ0XCgRPQ604T7fHmkc2yC6Q2U/3Z96BlMZHC5LUUJ5Wqx2KhTHofReEKZG/YcFPtq33BQOAxHxzlupUhs6Y6ja+ru6IDcUkV3s616vCTsXpJCkdmJJI0XD4p+6uds/qfhOs0cA7nb/G1T6lu09bvNmfsRGVZaH+9GLw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(346002)(39860400002)(396003)(230922051799003)(451199024)(82310400011)(186009)(64100799003)(1800799009)(40470700004)(36840700001)(46966006)(40460700003)(40480700001)(82740400003)(36756003)(81166007)(36860700001)(47076005)(83380400001)(356005)(26005)(6666004)(16526019)(316002)(70586007)(70206006)(6916009)(478600001)(336012)(1076003)(54906003)(2616005)(426003)(2906002)(7416002)(7406005)(44832011)(41300700001)(86362001)(8676002)(8936002)(4326008)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:50:08.6783
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3171d637-841f-4052-16dd-08dbce4ecf87
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MN1PEPF0000F0E0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5399
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

This information will be useful for debugging things like page faults
due to RMP access violations and RMPUPDATE failures.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: move helper to standalone patch]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev-host.h |  2 +
 arch/x86/virt/svm/sev.c         | 77 +++++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+)

diff --git a/arch/x86/include/asm/sev-host.h b/arch/x86/include/asm/sev-host.h
index 4c487ce8457f..bb06c57f2909 100644
--- a/arch/x86/include/asm/sev-host.h
+++ b/arch/x86/include/asm/sev-host.h
@@ -15,8 +15,10 @@
 
 #ifdef CONFIG_KVM_AMD_SEV
 int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level);
+void sev_dump_hva_rmpentry(unsigned long address);
 #else
 static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return -ENXIO; }
+static inline void sev_dump_hva_rmpentry(unsigned long address) {}
 #endif
 
 #endif
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 7d3802605376..cac3e311c38f 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -290,3 +290,80 @@ int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
+
+/*
+ * Dump the raw RMP entry for a particular PFN. These bits are documented in the
+ * PPR for a particular CPU model and provide useful information about how a
+ * particular PFN is being utilized by the kernel/firmware at the time certain
+ * unexpected events occur, such as RMP faults.
+ */
+static void sev_dump_rmpentry(u64 dumped_pfn)
+{
+	struct rmpentry e;
+	u64 pfn, pfn_end;
+	int level, ret;
+	u64 *e_data;
+
+	ret = __snp_lookup_rmpentry(dumped_pfn, &e, &level);
+	if (ret) {
+		pr_info("Failed to read RMP entry for PFN 0x%llx, error %d\n",
+			dumped_pfn, ret);
+		return;
+	}
+
+	e_data = (u64 *)&e;
+	if (e.assigned) {
+		pr_info("RMP entry for PFN 0x%llx: [high=0x%016llx low=0x%016llx]\n",
+			dumped_pfn, e_data[1], e_data[0]);
+		return;
+	}
+
+	/*
+	 * If the RMP entry for a particular PFN is not in an assigned state,
+	 * then it is sometimes useful to get an idea of whether or not any RMP
+	 * entries for other PFNs within the same 2MB region are assigned, since
+	 * those too can affect the ability to access a particular PFN in
+	 * certain situations, such as when the PFN is being accessed via a 2MB
+	 * mapping in the host page table.
+	 */
+	pfn = ALIGN(dumped_pfn, PTRS_PER_PMD);
+	pfn_end = pfn + PTRS_PER_PMD;
+
+	while (pfn < pfn_end) {
+		ret = __snp_lookup_rmpentry(pfn, &e, &level);
+		if (ret) {
+			pr_info_ratelimited("Failed to read RMP entry for PFN 0x%llx\n", pfn);
+			pfn++;
+			continue;
+		}
+
+		if (e_data[0] || e_data[1]) {
+			pr_info("No assigned RMP entry for PFN 0x%llx, but the 2MB region contains populated RMP entries, e.g.: PFN 0x%llx: [high=0x%016llx low=0x%016llx]\n",
+				dumped_pfn, pfn, e_data[1], e_data[0]);
+			return;
+		}
+		pfn++;
+	}
+
+	pr_info("No populated RMP entries in the 2MB region containing PFN 0x%llx\n",
+		dumped_pfn);
+}
+
+void sev_dump_hva_rmpentry(unsigned long hva)
+{
+	unsigned int level;
+	pgd_t *pgd;
+	pte_t *pte;
+
+	pgd = __va(read_cr3_pa());
+	pgd += pgd_index(hva);
+	pte = lookup_address_in_pgd(pgd, hva, &level);
+
+	if (pte) {
+		pr_info("Can't dump RMP entry for HVA %lx: no PTE/PFN found\n", hva);
+		return;
+	}
+
+	sev_dump_rmpentry(pte_pfn(*pte));
+}
+EXPORT_SYMBOL_GPL(sev_dump_hva_rmpentry);
-- 
2.25.1

