Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A617069D303
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbjBTSqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbjBTSp7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:45:59 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E6A212AC;
        Mon, 20 Feb 2023 10:45:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M1L6SGKpp9ocXlZdXp0N3Us/tZIlA6KIrYrwWnF92htZIqOJZF4vtspXPSMe1EauxRmKP1BW0SUVDmZ0+WPd55iH4u7yiibHzTK1blVPioMqON0OdL6LXMVRwpuc4ATknu/tEg1Z+IRKzRtjboq3UzuX+hG4YQ8o44gb4uiPTkptzy4zSkvBz+gmOIbtw+gi6r50Xaf6N50CTruN30O5JHLHGstsfsA8dwpqVqdXLS4rbQDdobMPN0N0HCL+7m5kw18JeBPijm3rgcWyYlwt2iMMXXXYMv9d+jxrgBBoiS8jmTUrNET8xU4/XAae2YmTJ29KaFWPywVNjhc6y5saAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YbUe5MPV5IcipfQc+HmmLC3mcPpmVfsdPBM6AWSlV6s=;
 b=IRSDhQPsurvL+0oEmU1QqbLhgeyOe4GmR25ISNi4U/HrFYxBOwhepntf8MBTzKiHDjL4L+eBHcJlaefI578i+8Np4Lmq4re6I6v9HbevQEz6crOY6/2eM9S18SCsOmuQV3O/ootKrCV8qoG81cOUL0mZoKcPImkuLa3FN/8d3ZHGHh2fQypEnPDtaqkALf4KDiRbcZvAGVvYmKWvKBaOGCDdbT6fmE8Zxy5bqHoZYLNs8hZMGeXKgQWg30zzpEEzGtkDor+GU8sWBgpTsbSFP1x8v/qVcE0ZW+BlbY/eIZl9pZMG3EtAr2OOVVFXDUcSZ5O0vIWtfEhagyN+cbPV0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YbUe5MPV5IcipfQc+HmmLC3mcPpmVfsdPBM6AWSlV6s=;
 b=iTRJU2R8wg/ieKSHtq75FVVJyby9r3WrsNP2qRqVGZdCQ0ReWqFvt0KTdUUYA43EuQp5JdqTnHSRZsaxQE6MPW0TED4mfR1AgirJgPVodz4W/JLJuguMs7AawD9g/VodkUWU4inkI4v1cW88to9uDZMKYdd1TanGWKfyE0KoxVU=
Received: from CY8PR19CA0002.namprd19.prod.outlook.com (2603:10b6:930:44::11)
 by IA0PR12MB8277.namprd12.prod.outlook.com (2603:10b6:208:3de::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 18:45:39 +0000
Received: from CY4PEPF0000C96A.namprd02.prod.outlook.com
 (2603:10b6:930:44:cafe::43) by CY8PR19CA0002.outlook.office365.com
 (2603:10b6:930:44::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:45:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C96A.mail.protection.outlook.com (10.167.241.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Mon, 20 Feb 2023 18:45:38 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:45:37 -0600
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
Subject: [PATCH RFC v8 15/56] x86/sev: Invalidate pages from the direct map when adding them to the RMP table
Date:   Mon, 20 Feb 2023 12:38:06 -0600
Message-ID: <20230220183847.59159-16-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C96A:EE_|IA0PR12MB8277:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fb6eb3b-8dec-40c1-12d5-08db1372a920
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jvQ48W5gzOiaKIfldMU6eOipFaHDQEN93lXnmKlUHh2g+hjw59RYzpTOl6yfxSpM658lv8Ak+1WPE1wxnjpLbn28GPc7vS5XhlrbbGWs7N2R13OXOVmMIpCSSE/myAqZHlLpRMYLDUFPumysJQN8JwMfyoyyE7yFd7OxdrOsQ0WZUz+jz2KFluvVSib8PyCmd8JdBmxK0VrOmQGCtF2xcxg++jcWuEKLOuZgNTCvqEvORV9HFc0ocAjmUjFn0I9ydZhW59kUf+khoIyv2+wWuo95cBcxSO6QVb1zveo/1jjWBLbIVfMCSPgJ8IZcH4WKzqZmYU8chcKbbcwbWG6DrpA+XDvUTxqR8VFjBILp14HveGQCa9JmcGJLkbY/NY7APZJzJphNZKTbqtixelV4MXK+EPb43mdnMuQCtWfPX5F0aqTx72hb0FxMmeVbNGwgy63bsPhabZIfMay0GJaeTzNLEjlpZ7LvHCGOR8HAqeYzZhrozdvbQ870MzEOLlO3eGP/yxbk/Ewxffw8ltg4BEInhXQkDtO+43nvNTmzkiz3STsMveutICFcfQ93gztjx7T6A0ImgeOLkHItdCKFx8sDMTtbSD+Y/ueg/leOBSsb5sEmoRswfsOyMwTMP5lxa20Z5j/+lV67QNzN//iJK9dh2uwg9eBAz20oD1lfptk5niZhE7+sxv9MffqDRwcYrzjic32iBdN7/qV0RCmRtzw97WUxUVvHfeFEatL2PqY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(376002)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(70206006)(40480700001)(40460700003)(6666004)(8936002)(83380400001)(7416002)(7406005)(5660300002)(41300700001)(47076005)(44832011)(426003)(86362001)(16526019)(26005)(186003)(1076003)(8676002)(2906002)(70586007)(6916009)(316002)(4326008)(336012)(54906003)(478600001)(2616005)(356005)(36860700001)(36756003)(82310400005)(81166007)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:45:38.6770
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fb6eb3b-8dec-40c1-12d5-08db1372a920
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C96A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8277
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The integrity guarantee of SEV-SNP is enforced through the RMP table.
The RMP is used with standard x86 and IOMMU page tables to enforce
memory restrictions and page access rights. The RMP check is enforced as
soon as SEV-SNP is enabled globally in the system. When hardware
encounters an RMP-check failure, it raises a page-fault exception.

The rmp_make_private() and rmp_make_shared() helpers are used to add
or remove the pages from the RMP table. Improve the rmp_make_private()
to invalidate state so that pages cannot be used in the direct-map after
they are added the RMP table, and restored to their default valid
permission after the pages are removed from the RMP table.

Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kernel/sev.c | 57 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index a49f30c10dc1..3e5ff5934e83 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2595,6 +2595,37 @@ int psmash(u64 pfn)
 }
 EXPORT_SYMBOL_GPL(psmash);
 
+static int restore_direct_map(u64 pfn, int npages)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < npages; i++) {
+		ret = set_direct_map_default_noflush(pfn_to_page(pfn + i));
+		if (ret)
+			goto cleanup;
+	}
+
+cleanup:
+	WARN(ret > 0, "Failed to restore direct map for pfn 0x%llx\n", pfn + i);
+	return ret;
+}
+
+static int invalidate_direct_map(u64 pfn, int npages)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < npages; i++) {
+		ret = set_direct_map_invalid_noflush(pfn_to_page(pfn + i));
+		if (ret)
+			goto cleanup;
+	}
+
+cleanup:
+	WARN(ret > 0, "Failed to invalidate direct map for pfn 0x%llx\n", pfn + i);
+	restore_direct_map(pfn, i);
+	return ret;
+}
+
 static int rmpupdate(u64 pfn, struct rmp_state *val)
 {
 	int max_attempts = 4 * num_present_cpus();
@@ -2605,6 +2636,21 @@ static int rmpupdate(u64 pfn, struct rmp_state *val)
 	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
 		return -ENXIO;
 
+	level = RMP_TO_X86_PG_LEVEL(val->pagesize);
+	npages = page_level_size(level) / PAGE_SIZE;
+
+	/*
+	 * If page is getting assigned in the RMP table then unmap it from the
+	 * direct map.
+	 */
+	if (val->assigned) {
+		if (invalidate_direct_map(pfn, npages)) {
+			pr_err("Failed to unmap %d pages at pfn 0x%llx from the direct_map\n",
+			       npages, pfn);
+			return -EFAULT;
+		}
+	}
+
 	do {
 		/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
 		asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
@@ -2630,6 +2676,17 @@ static int rmpupdate(u64 pfn, struct rmp_state *val)
 			 attempts, val->asid, ret, pfn, npages);
 	}
 
+	/*
+	 * Restore the direct map after the page is removed from the RMP table.
+	 */
+	if (!val->assigned) {
+		if (restore_direct_map(pfn, npages)) {
+			pr_err("Failed to map %d pages at pfn 0x%llx into the direct_map\n",
+			       npages, pfn);
+			return -EFAULT;
+		}
+	}
+
 	return 0;
 }
 
-- 
2.25.1

