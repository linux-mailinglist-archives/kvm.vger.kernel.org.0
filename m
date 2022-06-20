Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75CF552779
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344975AbiFTXDz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346739AbiFTXD2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:03:28 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2049.outbound.protection.outlook.com [40.107.243.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CA51FF;
        Mon, 20 Jun 2022 16:03:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lTni4sMccrV03LGNxuwGTWlYp5RE9+hQDynGi9o/iAg/e1rWkIGAz7dtHa9tnkGGsLSxkT7tRdDcL7HBpcKmc7nmI9vd114BH98Jz7tbu5I+U7Kk8r+o2T+FGFdBCsrZfBYX8Bc1aoSmlbC/WaucPf7x3kExNu6oVuXFJvh63x3WyZOaqo80tljGgcLNl9LSEES7/A5aV9TcDY5Vb1VNa8poAzXXWIs5GsuYyrTpZMmgqyL3y2ANz69Qxk1nxSddQiul4/6eDq8qeFoL9ke41NU6ehZ0mcg+v0Tm+NEWVniDZG1xgQT+62a1tOU5tMsBe9phAZ2Q1xKw1hsF56+tuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PnLDIqzDK1TsF+nZWbBjoq7rFJfwCu6AY1fo4ygDXys=;
 b=mPkSasDmIujjIVAV2/whqshLx5AtY6lcOACo7BAUqS4yFmad3KWRQL7Pd0ZWaORJ2I2OcJ/e9s6r5dtx+iGNSId2XyBbZHijCJjopb2qa9QvTSxLYSuolzOWeJbNMUyh6/VD00ODvfZxETXMn4pFs6BiGo5adBGmm0pmb7gSfqarTP/H4nPaNq8lQzRDvSGGDHgFfzxSdn4+1/4AQpKw6n1qQhIcjWoivyFpCxmARYkQHOWxKulo+BENPIidaZzW3X2OL27UblyuT6tW8glDjVMiD80CnaykkvtH3lap+x0Cw5Gf5PzBDDqhqz1dddq+sK+CqJp1BfxQB9R6wgVFXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PnLDIqzDK1TsF+nZWbBjoq7rFJfwCu6AY1fo4ygDXys=;
 b=A3/Jlp853ULladX/9h4eqMhub0dFJc8VYgG+oRzuEmCiVFCzWfxVHjnsF0N7M03KUx5nftrpbfSzieIIwiQpaI3QJwjNEPtqC6Ibw+JyiTGqTzkbSeP/k0nfQtt9xz2IlLyIrz3VU72b8q4RNGSyis0T44eJ6QN/bIvvfj9MWz4=
Received: from DM5PR19CA0046.namprd19.prod.outlook.com (2603:10b6:3:9a::32) by
 CH0PR12MB5347.namprd12.prod.outlook.com (2603:10b6:610:d6::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.18; Mon, 20 Jun 2022 23:03:19 +0000
Received: from DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:9a:cafe::7e) by DM5PR19CA0046.outlook.office365.com
 (2603:10b6:3:9a::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22 via Frontend
 Transport; Mon, 20 Jun 2022 23:03:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT014.mail.protection.outlook.com (10.13.173.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:03:19 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:03:17 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 07/49] x86/sev: Invalid pages from direct map when adding it to RMP table
Date:   Mon, 20 Jun 2022 23:03:07 +0000
Message-ID: <243778c282cd55a554af9c11d2ecd3ff9ea6820f.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2263a6dd-fdc8-4385-66ed-08da53111167
X-MS-TrafficTypeDiagnostic: CH0PR12MB5347:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB5347ED53AC8E82EEE4590D188EB09@CH0PR12MB5347.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FgTVhDiVBRe1kRRdlwbT+TrPEZRMv1ZAtZDE6/zfW9W36N1D8MGK8iUfTrMHuvf3Sd0OlEk2R0JiQT8s3AwOTV0cLLdlRkoBgQLA4ZEQvt3bJ4Cp+mv2PGwPNDSGwQseL8Lym8kAPRTSXn04wS1UBZSw5KgiOqXCkt57K8ae4rvbot1TCNJqDbQsmHIQCku1g5nunxrthgcEXG3LwTXSs04jt/2F0KkuG3xvqx+sJB19phAvKgIP6by5WvDrw1OL3qB/8fuAXaVmfTyx28aqySU7JFL31foKpKOKwO9YqarBBxIxthmUGjdHXhTrCe/YCFtYnC63EkPBSsIA4DMCkXsT6+kZoo73oZ1p0SB+i9bSxy5WKS6OCo571Lh5TNNmYbPgx/B64U7o4JYk0EPZyExUArLcoqv01kBAJkizHQIxY0sqHfqHMY0nj1FCJY89boubogpbzzpoBWLiQ6EcpGG/tUjhdwijGhHBpR5kBZw3tXu89AtV8aQeJse+hm46Qrte5ihNePCbBIn8TVk8t4FNadHxr139tspi98s8obpG2oZCOeiOWODaYmXsyzSZz8wThGv0fMGWRTWMyr17JlOI4VUIezNAH8lXwgOaDotm0lyjZM0J7jWWj0i8FLYYMrYh4I2LcWGwihSDtK0VI0Nz0muitkaCRynfvp5qs9wvE1yzCDPlwe1kqICICoyE1zUvjlS7EffrMkQ25DcXfThMTp2abuwX85dLQBe+AFieqFYuFfNAtofkXreF46cWg/1XnR51CKQPkA+QfH5CNw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(346002)(39860400002)(36840700001)(46966006)(40470700004)(36756003)(82310400005)(40480700001)(4326008)(8936002)(7406005)(70206006)(7416002)(83380400001)(5660300002)(70586007)(8676002)(478600001)(110136005)(2906002)(40460700003)(316002)(426003)(81166007)(186003)(47076005)(2616005)(41300700001)(336012)(82740400003)(16526019)(86362001)(26005)(7696005)(356005)(6666004)(54906003)(36860700001)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:03:19.6791
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2263a6dd-fdc8-4385-66ed-08da53111167
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5347
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The integrity guarantee of SEV-SNP is enforced through the RMP table.
The RMP is used with standard x86 and IOMMU page tables to enforce memory
restrictions and page access rights. The RMP check is enforced as soon as
SEV-SNP is enabled globally in the system. When hardware encounters an
RMP checks failure, it raises a page-fault exception.

The rmp_make_private() and rmp_make_shared() helpers are used to add
or remove the pages from the RMP table. Improve the rmp_make_private() to
invalid state so that pages cannot be used in the direct-map after its
added in the RMP table, and restore to its default valid permission after
the pages are removed from the RMP table.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kernel/sev.c | 61 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 60 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index f6c64a722e94..734cddd837f5 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2451,10 +2451,42 @@ int psmash(u64 pfn)
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
+static int invalid_direct_map(unsigned long pfn, int npages)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < npages; i++) {
+		ret = set_direct_map_invalid_noflush(pfn_to_page(pfn + i));
+		if (ret)
+			goto cleanup;
+	}
+
+	return 0;
+
+cleanup:
+	restore_direct_map(pfn, i);
+	return ret;
+}
+
 static int rmpupdate(u64 pfn, struct rmpupdate *val)
 {
 	unsigned long paddr = pfn << PAGE_SHIFT;
-	int ret;
+	int ret, level, npages;
 
 	if (!pfn_valid(pfn))
 		return -EINVAL;
@@ -2462,11 +2494,38 @@ static int rmpupdate(u64 pfn, struct rmpupdate *val)
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
+		if (invalid_direct_map(pfn, npages)) {
+			pr_err("Failed to unmap pfn 0x%llx pages %d from direct_map\n",
+			       pfn, npages);
+			return -EFAULT;
+		}
+	}
+
 	/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
 	asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
 		     : "=a"(ret)
 		     : "a"(paddr), "c"((unsigned long)val)
 		     : "memory", "cc");
+
+	/*
+	 * Restore the direct map after the page is removed from the RMP table.
+	 */
+	if (!ret && !val->assigned) {
+		if (restore_direct_map(pfn, npages)) {
+			pr_err("Failed to map pfn 0x%llx pages %d in direct_map\n",
+			       pfn, npages);
+			return -EFAULT;
+		}
+	}
+
 	return ret;
 }
 
-- 
2.25.1

