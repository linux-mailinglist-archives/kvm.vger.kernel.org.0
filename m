Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6976469D2F9
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbjBTSpM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbjBTSpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:45:11 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2CD1E5EE;
        Mon, 20 Feb 2023 10:44:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YbVjny7Alf9EebGhN9aVJxLbPByfm8J6u+JfSKOVDSSVidiIgfRPcEtrRQlOb3SqKBhgM81OlZ8xmdAh5DQ5G4yz20d8B3TtvJhxkTDrrPmmXvjWVplIANeRcDNHkSBQ60uwvEjSUd1Qfidp3KddBpMMi1oCb21tvX3DdF4w34OUxtLRcSaHEHNK7dAiSXmtsoWlhQBWoix88tCANzPAYKBfzJ7Py3VdLz0lHFMI7JBQZpHCi7Z/A/6vtAoTuSfcrkymSqhTRsVVbhNtsOxIiseDIzD8Z0J5H7Z9kdOojkks/KYOe76bnvYtJsAa5WB3JWc8OkhB4CtJxczxwfmrnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F2kvs1P/l4ZozOxsEC0d23b+JIIcSAMRctM1la8Mn4o=;
 b=IxGZ5YT2jwwxB6OvNDv6aNoytVhqjEpAukNGcF7Oj/wcRea1w1X4n5Kpeae+3g8C5RSlXQpWonoyEG8NkNeJhd/1rACLbgXpbi7yczHfRKJusd2/CH0yApOYem7/PwMpBACFHeNFkV69bXgztJ6CXdTSpF/Zu+oRV6LQ6XSONeEs0rw2pHkehoqMxfbYakgo8eRXrvKmKTrZrjTswiGTlum2A0ok1SI4Px7NqRXc+wAvlayfgHJrQUF4mKjTYaYFGmCEDJpKnJMWPDuZ71BYc/4SHkbfLsdrvP3y8RQ3YxTZQulPrH/O67K/TAVM6j4ukeq2WrWGhZF/fdi/asTuCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2kvs1P/l4ZozOxsEC0d23b+JIIcSAMRctM1la8Mn4o=;
 b=UkpYSvrnwaSykb28m6Gtf6DYlINfGtBgD0VVYyKWZq4zJt5TIlpXaYZSPQm2+lqYs14ZzHnMaKJkf9P86uJZvzFURRxeKpAzNLacMGsX2QlKAonTlsurxzRfKeFSCLuwfUTro8PIsvzcmHMN/Zlwjmie927Ms0bsOPnLPbnz/rI=
Received: from DM6PR07CA0062.namprd07.prod.outlook.com (2603:10b6:5:74::39) by
 CY8PR12MB7754.namprd12.prod.outlook.com (2603:10b6:930:86::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.13; Mon, 20 Feb 2023 18:44:57 +0000
Received: from DM6NAM11FT090.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::cb) by DM6PR07CA0062.outlook.office365.com
 (2603:10b6:5:74::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:44:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT090.mail.protection.outlook.com (10.13.172.184) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.20 via Frontend Transport; Mon, 20 Feb 2023 18:44:56 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:44:55 -0600
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
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v8 13/56] x86/fault: Add helper for dumping RMP entries
Date:   Mon, 20 Feb 2023 12:38:04 -0600
Message-ID: <20230220183847.59159-14-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT090:EE_|CY8PR12MB7754:EE_
X-MS-Office365-Filtering-Correlation-Id: 26894fc4-1c33-4779-bf79-08db1372903a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k5MHBK56RFlQC5aKaQjyU5GLAIjushZvHab6ynl6l11i3+wRrEl2YX02kTaow3mM3+Lsd06bQyQVAok4+l1mp3vk1KWnLmvFOebF0IgKl8vQb9zGTG/MXrq6+MHQoObiLfc3m16tju6Uaih9xKzs6s22s0O0MBErbQETRzCUsm7OwJkPzrLaBMhaFnzGURjUt2diAoazru6g+U3NITYG9xpI8WU3yoDZhoi6otijm+u4QNBc1ypnBFzaqUgEpdg2/kn2Dug6iLiYhJbzyH/YghFy6AzIpIrslIZpGiUiEnpSTWwVvS9NdMIvV7Oksxhr9GbPt4vT793MY52qXcSEMYzb+9CTqxZRbUT9RAbAqMPWC4GxD7U04/PTWHvitr/IQTxIoGxeFctkFlyVve20UUGZS3w3rGFgXky8Boo+LnWpuPDUQVPAxJzu+ZDFUjp7qr3fGaOSahlDr/lhPjBDiGGve9L+ADITEspKfa0p3JP1Fx82BbColqjKSLz/yNyQmX5uXiT4t6qXWvDFkDJxOJqjWEFk23qzqRgy02nIbkK1sAuWh0gRTl7rO3Zw4fSZEHLom5TbsLpB+pJLdh1BiLznMr75RfewTvkHy5AJIipWnbsZ/OOsS+X0D1FHSdH/ad5s8OTzHGN0Cy9x7goApcuLG4zKnvAaJsRG3QY2opbeJd9x+r5KvJtZKK5vI2/DXoQ7z0Sn0WZBXhkhDzQ727g1M8FalQ+qKWMUrVxC6ZM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(376002)(396003)(451199018)(36840700001)(46966006)(40470700004)(40460700003)(1076003)(40480700001)(83380400001)(47076005)(82740400003)(426003)(36860700001)(86362001)(81166007)(82310400005)(356005)(6666004)(16526019)(336012)(478600001)(36756003)(186003)(2616005)(26005)(5660300002)(7416002)(4326008)(70206006)(54906003)(70586007)(41300700001)(8936002)(6916009)(8676002)(2906002)(316002)(44832011)(7406005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:44:56.9088
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26894fc4-1c33-4779-bf79-08db1372903a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT090.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7754
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This information will be useful for debugging things like page faults
due to RMP access violations and RMPUPDATE failures.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: move helper to standalone patch]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev.h |  2 ++
 arch/x86/kernel/sev.c      | 48 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 8d3ce2ad27da..edbb7fa488af 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -198,6 +198,7 @@ bool snp_init(struct boot_params *bp);
 void __init __noreturn snp_abort(void);
 int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, unsigned long *fw_err);
 int snp_lookup_rmpentry(u64 pfn, int *level);
+void sev_dump_rmpentry(u64 pfn);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
@@ -223,6 +224,7 @@ static inline int snp_issue_guest_request(u64 exit_code, struct snp_req_data *in
 	return -ENOTTY;
 }
 static inline int snp_lookup_rmpentry(u64 pfn, int *level) { return 0; }
+static inline void sev_dump_rmpentry(u64 pfn) {}
 #endif
 
 #endif
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index a063c1b98034..a01741c4a1b8 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2504,6 +2504,54 @@ static struct rmpentry *__snp_lookup_rmpentry(u64 pfn, int *level)
 	return entry;
 }
 
+void sev_dump_rmpentry(u64 pfn)
+{
+	unsigned long pfn_end;
+	struct rmpentry *e;
+	int level;
+
+	e = __snp_lookup_rmpentry(pfn, &level);
+	if (IS_ERR(e)) {
+		pr_info("Failed to read RMP entry for PFN 0x%llx\n", pfn);
+		return;
+	}
+
+	if (rmpentry_assigned(e)) {
+		pr_info("RMPEntry paddr 0x%llx [assigned=%d immutable=%d pagesize=%d gpa=0x%lx asid=%d vmsa=%d validated=%d]\n",
+			pfn << PAGE_SHIFT, rmpentry_assigned(e), e->info.immutable,
+			rmpentry_pagesize(e), (unsigned long)e->info.gpa, e->info.asid,
+			e->info.vmsa, e->info.validated);
+
+		/* Dump all the non-zero entries if debug enabled */
+		if (!sev_cfg.debug)
+			return;
+	}
+
+	/*
+	 * If the RMP entry at the faulting pfn was not assigned, then not sure
+	 * what caused the RMP violation. To get some useful debug information,
+	 * iterate through the entire 2MB region, and dump the RMP entries if
+	 * one of the bit in the RMP entry is set.
+	 */
+	pfn = pfn & ~(PTRS_PER_PMD - 1);
+	pfn_end = pfn + PTRS_PER_PMD;
+
+	while (pfn < pfn_end) {
+		e = __snp_lookup_rmpentry(pfn, &level);
+		if (IS_ERR(e)) {
+			pr_info("Failed to read RMP entry for PFN 0x%llx\n", pfn);
+			pfn++;
+			continue;
+		}
+
+		if (e->low || e->high)
+			pr_info("RMPEntry paddr 0x%llx: [high=0x%016llx low=0x%016llx]\n",
+				pfn << PAGE_SHIFT, e->high, e->low);
+		pfn++;
+	}
+}
+EXPORT_SYMBOL_GPL(sev_dump_rmpentry);
+
 /*
  * Return 1 if the RMP entry is assigned, 0 if it exists but is not assigned,
  * and -errno if there is no corresponding RMP entry.
-- 
2.25.1

