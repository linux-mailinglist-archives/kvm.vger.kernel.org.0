Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139967CA96B
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbjJPNbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233613AbjJPNaz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:30:55 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2052.outbound.protection.outlook.com [40.107.100.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5BF114;
        Mon, 16 Oct 2023 06:30:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dvYRiSGtxTPR31VZ9Nz+PSpZZr6Vb76UmTXccXliHSQmZg5m4scWbSrlAikoB2OyoDzDPEH8r/y6S92CN4AC8/fgLhUsHWxKcaY72NaOMrxxhOnYSXIyZObg1KJ/Tqta3ennU6RayJVPYdUW7K5n7rhbCxVPzYVAPVfcvsjpHA30yr6XFItGgsFxGAYuG+tMALrIlji+LpPQA/WlH6Jun9He0dAI3VXnCPx6XMzmcjNTWKCquDJ6rzeK3nUTg0rfDCicD9kZbbqqkGProegxR/wygPXvmzhmpgqpXv3VKN0H4E7+tfh8l8UvZ08KAqmk5vpOKiWNjanpT9wqRjr30Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CYrbyDcHXWtSbej9FlmrAnCuP7pJWHMGL7rWpm0bZ8Q=;
 b=cAP2gJnBe0k4jI5JlTwRF1cs9UmSUbaMfkMgmsO26eLeePgeRipTTm6u1xq1e7XeqTujgRaMmIDCb1LlNc+9Dy7Y6laFPx+ZQcORsXGzgt2iYO4emNzcO9lb1tzQvjQpdHiU2H4EjYLQG8ahbwFtW3xlGgDgW0daQCkkBXH4k/NQVhsYmQaJ/r1IYNT4wfwnjhqyPbHPxnIqDjer6wHX7JHwWCgQoDevPeeU8FFj++4OQH7Si/uFwCCfYHkBWI8+HAlo8PsBxEw6jIgTUcDrLgFxX7OfhM0jw/aDhBIioyHREBdQsPIlUjGe/43qtHBBykn0RwJgWO8sUWv1rPvVGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CYrbyDcHXWtSbej9FlmrAnCuP7pJWHMGL7rWpm0bZ8Q=;
 b=l814euXkGiLDmn6zdj1IvUzUudJv/QHZnZQ+bCTXGsai7y7hQyHiDlAOub9YZqlNgLDOsnsrHWaztnncvSlNLQfvpstKg+VPu6A5S/7fvNNRVRSL4IrrFq1Xqb79uYZL5QQYOK/mMhohmbufV9JGsydgrv2vZFNAcTOQZoX4V8U=
Received: from CY8PR19CA0038.namprd19.prod.outlook.com (2603:10b6:930:6::26)
 by MW6PR12MB8664.namprd12.prod.outlook.com (2603:10b6:303:23c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 13:30:50 +0000
Received: from CY4PEPF0000E9DB.namprd05.prod.outlook.com
 (2603:10b6:930:6:cafe::a6) by CY8PR19CA0038.outlook.office365.com
 (2603:10b6:930:6::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35 via Frontend
 Transport; Mon, 16 Oct 2023 13:30:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9DB.mail.protection.outlook.com (10.167.241.81) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:30:49 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:30:48 -0500
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
Subject: [PATCH v10 12/50] x86/sev: Invalidate pages from the direct map when adding them to the RMP table
Date:   Mon, 16 Oct 2023 08:27:41 -0500
Message-ID: <20231016132819.1002933-13-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9DB:EE_|MW6PR12MB8664:EE_
X-MS-Office365-Filtering-Correlation-Id: 95859bed-5e69-47a4-b395-08dbce4c1cdf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N/mHF0YBqcSVZOmd1jJJHlcYF+JQc+b2AaCLn+U0GfWi/mYkEehsiEOUmUIIProLVf1XDEVBv11UuFyooAC7xby+2xsonMQjvRq6wANNiC6HZxDMrYFE/KZg1dgL/efKGUQXGo8/hVMJg6Tbw2bpX86rqne33DnjTl5R3oZvdcRQTpqhgVATugiQAtqMnN0yRCsF4+5HYbkNXam14rW6A3Mt8abCnvVuZmtDfJI21EAfwB4r0rK4tTlWQFmK3dyELPW2KOoU3BT6iW3/DHNnvoBMmJJh9c/P3SrVXIWuG9PVe+MK0tLJkZnRVb76hnpn/sX0gStTl0Sz9TPCqo2uS/upl0IMPrKtlw7JL5eLDYJ5rC966kHbBb8kpAFVvtbYUqTLJbpj2kpb2x7/Dbwx3/PlGWlEGGxr5pddzZAz1XEpOx5Dc1u0Jl8fFLY5xPY/L3EsdMoL+Uu/FnJ20egwOQQZiYpwsaQNUUhXC/8Bp5uvbZ97TwtcIpnbtEtp7+ZL7iZ0CHGlgeR2rSsIGGc3UCrmUxIfJ8ea5879paxxsG8M+cq/eGFgnPlyyaqxRv+O47m4Udmi6WqlBd5EXKpvGvqBNgGi4u5iAxTZvsoUkdNVvXzyK9X2/vyWGiC0Nq5geGXaJIvluD3X269VZlG2rahdtBNOFc1X2DRcRePPfVDmt7ZWpU2acmN4QE4HT2mN02wozL8Nef8JZe7fGdmT2/Kmlxb5OWDicwoSIvgoYqVlnNMsql9RaXhZm2HlwaYzMlXaspZgTU4yWwzF9SLCBw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(396003)(376002)(39860400002)(230922051799003)(82310400011)(451199024)(1800799009)(186009)(64100799003)(40470700004)(36840700001)(46966006)(40480700001)(5660300002)(44832011)(40460700003)(6666004)(2906002)(1076003)(26005)(36756003)(2616005)(426003)(336012)(83380400001)(16526019)(82740400003)(356005)(81166007)(86362001)(36860700001)(47076005)(7406005)(7416002)(41300700001)(316002)(6916009)(54906003)(70586007)(70206006)(8676002)(4326008)(8936002)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:30:49.9222
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95859bed-5e69-47a4-b395-08dbce4c1cdf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9DB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8664
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
---
 arch/x86/virt/svm/sev.c | 62 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 24a695af13a5..bf9b97046e05 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -395,6 +395,42 @@ int psmash(u64 pfn)
 }
 EXPORT_SYMBOL_GPL(psmash);
 
+static int restore_direct_map(u64 pfn, int npages)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < npages; i++) {
+		ret = set_direct_map_default_noflush(pfn_to_page(pfn + i));
+		if (ret)
+			break;
+	}
+
+	if (ret)
+		pr_warn("Failed to restore direct map for pfn 0x%llx, ret: %d\n",
+			pfn + i, ret);
+
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
+			break;
+	}
+
+	if (ret) {
+		pr_warn("Failed to invalidate direct map for pfn 0x%llx, ret: %d\n",
+			pfn + i, ret);
+		restore_direct_map(pfn, i);
+	}
+
+	return ret;
+}
+
 static int rmpupdate(u64 pfn, struct rmp_state *val)
 {
 	unsigned long paddr = pfn << PAGE_SHIFT;
@@ -404,6 +440,21 @@ static int rmpupdate(u64 pfn, struct rmp_state *val)
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
@@ -422,6 +473,17 @@ static int rmpupdate(u64 pfn, struct rmp_state *val)
 		return -EFAULT;
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

