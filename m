Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A7C64D054
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 20:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239273AbiLNTvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239100AbiLNTvW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:51:22 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2080.outbound.protection.outlook.com [40.107.243.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134B82CC80;
        Wed, 14 Dec 2022 11:49:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/LHjBRAMWE7Lluf8M+RSyU4G3tTIiiKGpHXME25PsJjAxxAfqrptMWwFCEaRWb+lzrOFLCPpibBSCqBBNmfDDXqX1e/ficS/Pa6HdDShKKnRYOwFKKy/wfszeLsIccUDyok0s7wHLKqdjFatI457l4Nxg1xqNTgrPJvxDRonXZwe9vT8czldIWSZRYJJFSeC63f8d3nKKh0ohab+QaSHtCokOWG38kbAxI+BOk39tyCen8OUkuZc747afTv9jthxrBJjIYR7o4ey29obfQPVDR02jCr6SoE7EY6wFdNCmkeToI0Nnp7GLhFytqdUkZ63QDx1iandGcaQ2EZjCWhLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jm/QvkaIBQJRPPdHWTGEkZBgJM39n0PSJvku/UCbtsA=;
 b=LXEOcEZG3dDf92gTed/skioinXqZi/uF9Eq7IklSjgF6hYfiKAG8YwEWKqYCuJygDAL9f9PNmZVGagVfH35L32ip9aJuByo8KNMbyn1QfzKM1hb2hB9GECBrjK5jStnnvcZLWjci8mfvwpkPJI5RZl0AmKfVCv31WpmyxPjkrb9pZoJ8aVKFTZ/CdrR7rkhgjLwjKwF8jU/ycge2bnpP1Pflb/noDXgdO2xGEBqZue7PQErlxjVZEfmez4+4jkxrLs8PnHqKOvjU1hJOsH8RpF561wYyFOTwWIwXudJi/AQqa3OgD+Orr4tPmEKCU/r2ffHBEVA2wt9YTbucAOKkCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jm/QvkaIBQJRPPdHWTGEkZBgJM39n0PSJvku/UCbtsA=;
 b=x7m2MRCb66MyUjKw6o/WG2MwE2QHXiQ2tWRgBPOvo1A3MuyaoXDA1Dl6yymCpEeGa71RPzsN+3qP93P2cC3Og7GbgaKvEEzNWstWpETClCGyxntCytb7nA0zWOq6k8FSzl7BU8AL1LQbZ8HS5IOoje/Z9xcs5ROu9cAaCgsdSio=
Received: from CY5P221CA0019.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:b::32) by
 CH2PR12MB4104.namprd12.prod.outlook.com (2603:10b6:610:a4::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Wed, 14 Dec 2022 19:49:53 +0000
Received: from CY4PEPF0000C978.namprd02.prod.outlook.com
 (2603:10b6:930:b:cafe::c0) by CY5P221CA0019.outlook.office365.com
 (2603:10b6:930:b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 19:49:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C978.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.10 via Frontend Transport; Wed, 14 Dec 2022 19:49:53 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:49:52 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>
Subject: [PATCH RFC v7 17/64] x86/mm/pat: Introduce set_memory_p
Date:   Wed, 14 Dec 2022 13:40:09 -0600
Message-ID: <20221214194056.161492-18-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C978:EE_|CH2PR12MB4104:EE_
X-MS-Office365-Filtering-Correlation-Id: ac7eaa51-59c2-46ad-9f35-08dade0c5e8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G0jRK5W87/t82xBZlSDAkg18bzwSFG7FYgZLG/T1zrXjVNB+ednlSNn0dR0/u3N4qtpPcORWfFV9QVhbccKnmenjaTxx+y47V1XWhKhsgI6WGlmSWqURYIQ+hqYMAv7YUIE+uS3oLNAl+Zk7+lS7X2lSrgXoge5FNWlaN6xiw2SAqoyJR82AEJo7A7gVGDl0dTza6cfF41kM5a1ulFX4KVt19CT9raMzmG3F2lI/J0GHGRnBRt7B7EkGJi7COm4OoAyiWL7epESO/e6XBB+x+jfjMW5TW1YHxU69NbmjUnS9YtYXg6DbsopyZ7CssBatdWZgYhmK3VAiRpva0wZUshx4UQ0swuksNK9Z5ZN2gD7TcDPZLpvUa03BynV7wP00dyR+aLFAh8pym6DAk36gIt1SRcsfOKUl4gI29n/Ako8YN/o7HLc0lbMLvJlMLK+TL2WDan6ZOFjCRnBpfoTF85jSCW7gmKDqaZXmYVQDWjSVrdEqCIcWnixApKvueIH+8JXUJxkssMX08SwNSRbLvrVzac3kgobMN8vocsRBrNQwsYWAxupTJqiq8nZiBdq0lykn6eIXePTXbVlsSQRGA3x47B1kA0MvzHxjI3mGl70clFiGtTZbl8LF1apiGxSpn/Og1NVE2ELvyTbcPdmpJuBnOOk8oeYTw4EydFjXAB/HMtNxDQ4OTIxeMPbg4MhlbYNJKRy0ss+gVuUsvjrolPOja4pQqfSYVIDzZlerF5o=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(136003)(396003)(451199015)(36840700001)(40470700004)(46966006)(2616005)(83380400001)(336012)(41300700001)(8676002)(2906002)(16526019)(1076003)(5660300002)(7416002)(8936002)(7406005)(36860700001)(36756003)(426003)(82310400005)(40460700003)(47076005)(81166007)(44832011)(356005)(82740400003)(40480700001)(6666004)(6916009)(54906003)(70586007)(4326008)(478600001)(316002)(70206006)(26005)(86362001)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:49:53.2475
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac7eaa51-59c2-46ad-9f35-08dade0c5e8e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C978.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4104
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

set_memory_p() provides a way to change atributes of a memory range
to be marked as present.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/set_memory.h |  3 ++-
 arch/x86/mm/pat/set_memory.c      | 12 ++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index b45c4d27fd46..56be492eb2d1 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -12,7 +12,7 @@
  * Cacheability  : UnCached, WriteCombining, WriteThrough, WriteBack
  * Executability : eXecutable, NoteXecutable
  * Read/Write    : ReadOnly, ReadWrite
- * Presence      : NotPresent
+ * Presence      : NotPresent, Present
  * Encryption    : Encrypted, Decrypted
  *
  * Within a category, the attributes are mutually exclusive.
@@ -44,6 +44,7 @@ int set_memory_uc(unsigned long addr, int numpages);
 int set_memory_wc(unsigned long addr, int numpages);
 int set_memory_wb(unsigned long addr, int numpages);
 int set_memory_np(unsigned long addr, int numpages);
+int set_memory_p(unsigned long addr, int numpages);
 int set_memory_4k(unsigned long addr, int numpages);
 int set_memory_encrypted(unsigned long addr, int numpages);
 int set_memory_decrypted(unsigned long addr, int numpages);
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 2e5a045731de..b1f79062c4a5 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1993,17 +1993,12 @@ int set_mce_nospec(unsigned long pfn)
 	return rc;
 }
 
-static int set_memory_p(unsigned long *addr, int numpages)
-{
-	return change_page_attr_set(addr, numpages, __pgprot(_PAGE_PRESENT), 0);
-}
-
 /* Restore full speculative operation to the pfn. */
 int clear_mce_nospec(unsigned long pfn)
 {
 	unsigned long addr = (unsigned long) pfn_to_kaddr(pfn);
 
-	return set_memory_p(&addr, 1);
+	return set_memory_p(addr, 1);
 }
 EXPORT_SYMBOL_GPL(clear_mce_nospec);
 #endif /* CONFIG_X86_64 */
@@ -2039,6 +2034,11 @@ int set_memory_np(unsigned long addr, int numpages)
 	return change_page_attr_clear(&addr, numpages, __pgprot(_PAGE_PRESENT), 0);
 }
 
+int set_memory_p(unsigned long addr, int numpages)
+{
+	return change_page_attr_set(&addr, numpages, __pgprot(_PAGE_PRESENT), 0);
+}
+
 int set_memory_np_noalias(unsigned long addr, int numpages)
 {
 	int cpa_flags = CPA_NO_CHECK_ALIAS;
-- 
2.25.1

