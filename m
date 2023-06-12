Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7166272B681
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbjFLEdp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234325AbjFLEdE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:33:04 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2086.outbound.protection.outlook.com [40.107.95.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661741FD2;
        Sun, 11 Jun 2023 21:32:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l5dqAoni8U7DvhaUFVyjNAH5i55tKrKmpNV/NPxsivGBxVJ7Mcl7KvFYB/UsKIKcWBNENyj2IDo8IF3xOPGe/+avB/J8DL2A+icF92I+oaBgaMNaJvNT9pA8mwXJG84dUvykIGeKiexF2R/j5xSwWdERcZJ1XEcpUPwlh6jnFUae4WWu/d5+jrm3a1qdZD4n9Xwf1t7xslo7nQJd1Og/7N1jFvcg6f2jL0tTUTbilSo+wg2e9QRDFk0GcJPeYhohph/DXziom/zB9MxJ12DCWKvpft5SahHeTRyEjaTlivbjf3sxyoXWHrDpFD3ywISls2KCd84A1wM1y0hzZ3t4sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gEd/MCK8LB8MNsiER/01EW7HgLCLIvaG50Hd8XNvNzg=;
 b=mzhy7sN7tIKjhYaD/9AMUKHhsTZi5BHcb0hKNZXZyAZ77eRGamgJFc4Q3KJFLBw4eZyW4JMD1vKIu4lrOvfckUJStDtKOcELnukE9qtrGFFrfx2kJQ+5rNbuLdCtnWqf02ZEJBXwex9obRh8nc7F78hVi/Djj8+jR8ufLt18bb6Pla9OsupNKEfFU2HlypzygOZkQPK9HVshHEypL6HlT12tIjbpixknkpi2X/8e8kru4j6qmwPeUESxybkH1EbaepYhXATRlI8qkkUyISY/zSbe61n1Yddl9THSSnga4P3rpcs3uJDYcZ/ZGJgAGoHd92czOdDUh1U1LPYpJo0B9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gEd/MCK8LB8MNsiER/01EW7HgLCLIvaG50Hd8XNvNzg=;
 b=wrgBiGt0FO4uFsCPHIj+JBuQvEhng2hP8I8bNpinvE+kF2l6oTQBv7SK0OfPm4gJDL94QX2ZQybqbq7uBvHaKgyajgz0tMblb3BP8vCuhLKgDKf3uSKLzLw/nUXTAsiv5iYMXesmFgJblceGAvzKChn8sio5HGrSnylZGX8MScQ=
Received: from DS7PR05CA0032.namprd05.prod.outlook.com (2603:10b6:8:2f::31) by
 PH7PR12MB7355.namprd12.prod.outlook.com (2603:10b6:510:20e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 12 Jun
 2023 04:32:26 +0000
Received: from CY4PEPF0000E9D4.namprd03.prod.outlook.com
 (2603:10b6:8:2f:cafe::24) by DS7PR05CA0032.outlook.office365.com
 (2603:10b6:8:2f::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.21 via Frontend
 Transport; Mon, 12 Jun 2023 04:32:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D4.mail.protection.outlook.com (10.167.241.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.21 via Frontend Transport; Mon, 12 Jun 2023 04:32:26 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:32:25 -0500
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
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH RFC v9 19/51] x86/sev: Introduce snp leaked pages list
Date:   Sun, 11 Jun 2023 23:25:27 -0500
Message-ID: <20230612042559.375660-20-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230612042559.375660-1-michael.roth@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D4:EE_|PH7PR12MB7355:EE_
X-MS-Office365-Filtering-Correlation-Id: 1660822a-76c1-4ebb-d3f6-08db6afe064c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pg8/+Sf+npALiYaoZ2JZsTyszQWVPMSC384tr/tp6/43WpoR5REFrs4u+S9/hKqE6dj069oECbl6FWPI9hjIF6bgbqqNtaHeqvcJHoVsfK/sTu7k5twIEaXHUu+2scWDROXEJBeiMfzKJFO+1eyA0FuTOv+otbJt6C7pYgdNWAdd2/penWh8ZVtOemlHChqyv0DOyQWgMYzJ9pN6kCqQpVuWjiF7RqgIorQ/qwPKTOmBKv+Jsg9KyHTh1R88v7T/z1jE/YM13hkYgLk2nnhGKvlTb0P6m1Oams7RqNI4/gbpYJQzg0Yy9nNLqaFvMJF3yChsZDA1DcT9v18h4h/1qwd0O2pohEbfvXXAkrZu08DTLw0CMS9PjwHl9SlUklbNUWemhG9lbot6BBqUnDQaPqWYx+atarCc0Tg0/GXNVeuKmiGIkJcDBhrDQccLyYSmnKIz43TL4VeeWCsu+rEgs0J2zHfbEOq2x8+NOZ8fjS/Hlp45NIbWWHEZw9LU5ZJzTez4ZchLjn5KbYucqZzt2f+cg3zPOPHL29KfDdXWfiQLDMEyYTBEP+4dksXGKsKnOfLXfCnVl8SAuZeIt4PEHEPIQyHekljr3Gf2mpcmNoHaZk7yd4GewipQu3ET0HhTCzHofSmghVjjXOpTx5UOvJW2huxQ8jm3FpHd59olulp6n2hAXr0+gSXsHPtBvukt17m42AAJio+CGjgTUwMCnuHwu13E3NGKu2604CCEgSSaEOwW61XwiDzK4Xh5AUSwe2vuTg4jvEcKZkVBIOd71g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199021)(36840700001)(46966006)(40470700004)(36756003)(2906002)(82310400005)(7406005)(86362001)(7416002)(44832011)(40480700001)(47076005)(186003)(16526019)(83380400001)(36860700001)(40460700003)(426003)(336012)(5660300002)(26005)(1076003)(82740400003)(478600001)(356005)(81166007)(54906003)(70586007)(6916009)(4326008)(2616005)(70206006)(41300700001)(316002)(8936002)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:32:26.1586
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1660822a-76c1-4ebb-d3f6-08db6afe064c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7355
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Pages are unsafe to be released back to the page-allocator, if they
have been transitioned to firmware/guest state and can't be reclaimed
or transitioned back to hypervisor/shared state. In this case add
them to an internal leaked pages list to ensure that they are not freed
or touched/accessed to cause fatal page faults.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: relocate to arch/x86/coco/sev/host.c]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/coco/sev/host.c        | 28 ++++++++++++++++++++++++++++
 arch/x86/include/asm/sev-host.h |  3 +++
 2 files changed, 31 insertions(+)

diff --git a/arch/x86/coco/sev/host.c b/arch/x86/coco/sev/host.c
index cd3b4c6a25bc..373e91f5a337 100644
--- a/arch/x86/coco/sev/host.c
+++ b/arch/x86/coco/sev/host.c
@@ -64,6 +64,12 @@ struct rmpentry {
 static unsigned long rmptable_start __ro_after_init;
 static unsigned long rmptable_end __ro_after_init;
 
+/* list of pages which are leaked and cannot be reclaimed */
+static LIST_HEAD(snp_leaked_pages_list);
+static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
+
+static atomic_long_t snp_nr_leaked_pages = ATOMIC_LONG_INIT(0);
+
 #undef pr_fmt
 #define pr_fmt(fmt)	"SEV-SNP: " fmt
 
@@ -494,3 +500,25 @@ int rmp_make_shared(u64 pfn, enum pg_level level)
 	return rmpupdate(pfn, &val);
 }
 EXPORT_SYMBOL_GPL(rmp_make_shared);
+
+void snp_leak_pages(unsigned long pfn, unsigned int npages)
+{
+	struct page *page = pfn_to_page(pfn);
+
+	WARN(1, "psc failed, pfn 0x%lx pages %d (marked offline)\n", pfn, npages);
+
+	spin_lock(&snp_leaked_pages_list_lock);
+	while (npages--) {
+		/*
+		 * Reuse the page's buddy list for chaining into the leaked
+		 * pages list. This page should not be on a free list currently
+		 * and is also unsafe to be added to a free list.
+		 */
+		list_add_tail(&page->buddy_list, &snp_leaked_pages_list);
+		sev_dump_rmpentry(pfn);
+		pfn++;
+	}
+	spin_unlock(&snp_leaked_pages_list_lock);
+	atomic_long_inc(&snp_nr_leaked_pages);
+}
+EXPORT_SYMBOL_GPL(snp_leak_pages);
diff --git a/arch/x86/include/asm/sev-host.h b/arch/x86/include/asm/sev-host.h
index 753e80d16433..bab3b226777a 100644
--- a/arch/x86/include/asm/sev-host.h
+++ b/arch/x86/include/asm/sev-host.h
@@ -19,6 +19,8 @@ void sev_dump_rmpentry(u64 pfn);
 int psmash(u64 pfn);
 int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable);
 int rmp_make_shared(u64 pfn, enum pg_level level);
+void snp_leak_pages(unsigned long pfn, unsigned int npages);
+
 #else
 static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return 0; }
 static inline void sev_dump_rmpentry(u64 pfn) {}
@@ -29,6 +31,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int as
 	return -ENODEV;
 }
 static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
+void snp_leak_pages(unsigned long pfn, unsigned int npages) {}
 #endif
 
 #endif
-- 
2.25.1

