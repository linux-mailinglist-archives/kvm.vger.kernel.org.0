Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB694FE07E
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 14:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243678AbiDLMkh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 08:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355014AbiDLMis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 08:38:48 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2047.outbound.protection.outlook.com [40.107.95.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E8D580F9;
        Tue, 12 Apr 2022 04:59:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V2lbkVen7i/ZXkYcnxHMBC8zHYYwJhWvmz5SWSptPPOIxAJSplU0mIU3rk6GfI+PI3YTHOjqigBnTa0Oyb4rlD2wWArW59FA/jixl4JOHIwZCqHjLdOgaABnsfZHph0JlbObuPXJRquii1LYd93xo10mIC0UkkY2BLlNL5F+44r2BQZQe/WG/3X72/L93O0IZcNONc89SPrWDgQWUcwqQKa0O/8pp0HArsT3YnAxTzF6/vnaSwwiZMY/PG4YyqvkR8vL+AslKAi4Mk3MtppxYKOsigJ5aTLb3/Ujta0Yu6sf+t3S6eoTxNHGJ9UKfyKrg7ujHyYQqwQKrg/UZwn1Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WCVn+5SCOMNXN/rOQAD2sMpI8vn/wEzuC8wYA8quyUI=;
 b=IY17Akfoa2/luQWrrNuI9yAEItc9qnsEHT++Unxa8Iv0eGWVtUbBn28wrUkOaM/CcLikW8anjBU9LQfhnLGmeF1IcJRDS0TDgI88k2abUIm7M0z86BPF3sORBLDzQo2LQnP8TkUJAQqqZicovJq7xx96NB8kckHIyl/wj+OtN5SZHPiJHG9EjkIKReSjBkrQ4veXvALX4Ygd9C89Kmdq69HAGIZVMWZSNxB9y72969ZU3mufss0M7h6YM95gDvfSlG0q6lR3C5BrzHYRTUM76eAh0UdioykiGT4NUbkfAykASTeGmF/OWTmla6gCZqWLjAI+POd8VYbxJzYhBeK6Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WCVn+5SCOMNXN/rOQAD2sMpI8vn/wEzuC8wYA8quyUI=;
 b=au9r/vsCrsU1UU1I52k+Zfevim6Pcrp8+A9R0V5G3P/UyA8QgJl0rmvWlyebuKLIWeT/bpw/Llqb4sAVLwDBgNGoouxmRpdWmEgLvkXGnv6fWX76UeduTUlyKXrQAEgDT8Jm1DKB3EVgkLc7iW2pA5oFMZWyy1/47HoEdoZFjqY=
Received: from BN9PR03CA0737.namprd03.prod.outlook.com (2603:10b6:408:110::22)
 by DM6PR12MB2761.namprd12.prod.outlook.com (2603:10b6:5:41::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 11:59:13 +0000
Received: from BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:110:cafe::f3) by BN9PR03CA0737.outlook.office365.com
 (2603:10b6:408:110::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18 via Frontend
 Transport; Tue, 12 Apr 2022 11:59:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT035.mail.protection.outlook.com (10.13.177.116) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Tue, 12 Apr 2022 11:59:12 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 12 Apr
 2022 06:59:11 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v2 07/12] KVM: SVM: Adding support for configuring x2APIC MSRs interception
Date:   Tue, 12 Apr 2022 06:58:17 -0500
Message-ID: <20220412115822.14351-8-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
References: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07c140c1-8315-4d6f-5ba3-08da1c7bdc41
X-MS-TrafficTypeDiagnostic: DM6PR12MB2761:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB2761707BE3BEAF3B367BD10BF3ED9@DM6PR12MB2761.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 61MRIECBGDq8a1jqUc3HcoH4M7JgzUyopWelGfWdYdaK2u0mBn1VlrqIUYOr8pR2IGBP1juxzzQnnhU9Jh4pOPni2xpLM7wIZpZbyK67Xxgzoewe/v+X8IAGu3q4BPB4NVLoY4YQA7V4b9vaUwhaE4TYwEEDplSZMCeJufR1by3ROFoeRXt8jicqcQbevzC8R8IplmwvnMBUtRmL/zJ0saK1Y6bZLXR9ACm5pzp6Vremn2X2vvn9o6BfjAoE/JLPBpUU5LLYmrzfY9BMaPZawskjnPWTr6RIuNtnZztxuHGcbP9zU1e+8L7SCiWW4r282GisW6QgVKDj6YRJg7dBSRIJYe0g7uFOwyc6TVVTlsR2PfLjOE/xvzvBzpsp6Da7qXod/vhiFb2yX6RQaTJCe+osLlq/3jcRq2q/QRdX+B5EK3ck/zevN5hJdWZ8VAR47QinWpl9M+jYwlIFB60wDVP1ns9WMiOPipb62cNX/JUjJT8rbW8AIjTBNK31p8ap1jV3Eqozru0Hsg6IoWtcU/0wNEAHa+lx0PLka0uKDhBrnpi4BBeRNas+N4YUr51tPeFlAvpVFdgYEPOcDqiNJVhuakqzKt+9vjUbi5IFWzggQBeSWYzWbz7lGlFUhH4n9jreOoG/SMT+w07KQjFswjM9+k4sQPS5YWde6hyEiWjNJt6+iU0TcdNXpc32fDAZUfMHTPJc4PjnJTeBWDApiA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(82310400005)(110136005)(44832011)(2906002)(4326008)(54906003)(316002)(70206006)(70586007)(36756003)(8936002)(5660300002)(508600001)(86362001)(1076003)(40460700003)(7696005)(2616005)(8676002)(356005)(81166007)(426003)(336012)(186003)(26005)(16526019)(83380400001)(47076005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 11:59:12.7547
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07c140c1-8315-4d6f-5ba3-08da1c7bdc41
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2761
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When enabling x2APIC virtualization (x2AVIC), the interception of
x2APIC MSRs must be disabled to let the hardware virtualize guest
MSR accesses.

Current implementation keeps track of list of MSR interception state
in the svm_direct_access_msrs array. Therefore, extends the array to
include x2APIC MSRs.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/svm.c | 29 ++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h |  5 +++--
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5ec770a1b4e8..c85663b62d4e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -76,7 +76,7 @@ static uint64_t osvw_len = 4, osvw_status;
 
 static DEFINE_PER_CPU(u64, current_tsc_ratio);
 
-static const struct svm_direct_access_msrs {
+static struct svm_direct_access_msrs {
 	u32 index;   /* Index of the MSR */
 	bool always; /* True if intercept is initially cleared */
 } direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
@@ -774,6 +774,32 @@ static void add_msr_offset(u32 offset)
 	BUG();
 }
 
+static void init_direct_access_msrs(void)
+{
+	int i, j;
+
+	/* Find first MSR_INVALID */
+	for (i = 0; i < MAX_DIRECT_ACCESS_MSRS; i++) {
+		if (direct_access_msrs[i].index == MSR_INVALID)
+			break;
+	}
+	BUG_ON(i >= MAX_DIRECT_ACCESS_MSRS);
+
+	/*
+	 * Initialize direct_access_msrs entries to intercept X2APIC MSRs
+	 * (range 0x800 to 0x8ff)
+	 */
+	for (j = 0; j < 0x100; j++) {
+		direct_access_msrs[i + j].index = APIC_BASE_MSR + j;
+		direct_access_msrs[i + j].always = false;
+	}
+	BUG_ON(i + j >= MAX_DIRECT_ACCESS_MSRS);
+
+	/* Initialize last entry */
+	direct_access_msrs[i + j].index = MSR_INVALID;
+	direct_access_msrs[i + j].always = true;
+}
+
 static void init_msrpm_offsets(void)
 {
 	int i;
@@ -4739,6 +4765,7 @@ static __init int svm_hardware_setup(void)
 	memset(iopm_va, 0xff, PAGE_SIZE * (1 << order));
 	iopm_base = page_to_pfn(iopm_pages) << PAGE_SHIFT;
 
+	init_direct_access_msrs();
 	init_msrpm_offsets();
 
 	supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index c44326eeb3f2..e340c86941be 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -29,8 +29,9 @@
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	20
-#define MSRPM_OFFSETS	16
+#define MAX_DIRECT_ACCESS_MSRS	(20 + 0x100)
+#define MSRPM_OFFSETS	30
+
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
 extern bool intercept_smi;
-- 
2.25.1

