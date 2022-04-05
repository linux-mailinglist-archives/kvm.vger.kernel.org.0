Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3314E4F5500
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 07:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237492AbiDFFYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 01:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1451719AbiDFBQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 21:16:58 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2044.outbound.protection.outlook.com [40.107.102.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F373506E5;
        Tue,  5 Apr 2022 16:09:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IB1q++RHpOtMam/mG84yYYzExPDTQjF+/eLJGy1mSoo8tjFlkW+rMdUBoP3IpalndDJubkryKwL8AOZVSud9+AbY6Z4/Ib+mr/aEpNsYdO3N7Z+FCNBI2yvdUHJgxR66/d69XqxfaC0P0KIwB6Ut/5vsT9gEgzRQe/5V6DX+VUYcQXmT0NYvUHFX708JRLJWIOqFe/GT56WwIHk1AM0Hnc8rxWE1vWHk5gPEgQoYJjLUxMe1uL6X1SsNb6C5sKH/LlP2YTq3TKMf7vjxaCEbsnM0DXblXDMEjCU1Kgu9FU1lIV7Zxml9yy5qjRCiK6CnL6HV71f5lMgTvT6Or/P/mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jBnhw+lwG7sVQIWSPBhkwt3pkafCbuboFVVxYdtm65w=;
 b=SHnSS3uMBj3N6fny5mUO0f9WmdsrPW6tG7Df+eUt9UGnxqZdO0vutAusllAYq3d6ym0l4mFVw5uyzqZDQouSQCDZxGC2LHaQNGduqYzAXzsve2jdTzutklu1R7zaKo1gG2a8gs2dZhY4sZxrChrAQJYklQKTlBRaVxOnzZxxYQstoktAlDg/6q1HmPfqKpZFnUyY2CWxuDgDJ61jC3+jlM7BuaSOv5m3Jg+lU6sNRFEtpKPZQDhjfOLzIA6v87wRvuhvtWTkdBIKgCo/D1FWauH61J/S7eni+C0tX4OF6ajHF3WTGqMTQcVtAAgTqiICOyYckz+imb6QjVffpwQ1Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jBnhw+lwG7sVQIWSPBhkwt3pkafCbuboFVVxYdtm65w=;
 b=PVo/j95RSe+BBPCRGNZo9K4LLdOJm0vQtc8g1rCs4ZqyXkt9EaoGBnn4AVbsmkuzCXipBa8tyfV+Bv4IqaFCmrCUYbCpk//VHFOMH2M95L0KrnbwRUsdtrYgHeBeu4PWEva/78sf3/qsocWcI7txiQfkiiS4d1gq+a7WIiVsWQc=
Received: from MW4PR04CA0085.namprd04.prod.outlook.com (2603:10b6:303:6b::30)
 by BN8PR12MB3044.namprd12.prod.outlook.com (2603:10b6:408:45::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 23:09:30 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::61) by MW4PR04CA0085.outlook.office365.com
 (2603:10b6:303:6b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31 via Frontend
 Transport; Tue, 5 Apr 2022 23:09:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Tue, 5 Apr 2022 23:09:29 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 5 Apr
 2022 18:09:23 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <joro@8bytes.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <peterz@infradead.org>, <hpa@zytor.com>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 07/12] KVM: SVM: Adding support for configuring x2APIC MSRs interception
Date:   Tue, 5 Apr 2022 18:08:50 -0500
Message-ID: <20220405230855.15376-8-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220405230855.15376-1-suravee.suthikulpanit@amd.com>
References: <20220405230855.15376-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13a8a095-fdcb-4b63-8b14-08da175956a2
X-MS-TrafficTypeDiagnostic: BN8PR12MB3044:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3044D2BD01DFB2A4EB1AD104F3E49@BN8PR12MB3044.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yidp4XyKsVeN9pYlant6lZku8XY7dECt62UNvMQJYokZFLRjqzK5Kk/NEqfxE3NuYys7HK7AugGGrdSjocOhMdNrgcAA7gyLoqTFl0Tw3zZemTT/5bx04SLEEFC/IU4t2RdfwzQuwXftqDEEsTInntGiFcppjb0Qy8wlxo1LzOIAu47oe4TxDNTFpLAtRjbO7jRrlts2jZ8fvRGXsPrhL1nVm2JefeZmtoPTjU0S3If3IzcZOQ0277oPDzMWADGg0RoIGLoXCmfnXuRU/QYOUkYJlVBBLqYQbInH3H6NR8njicvfLEjx8HFF0cAB90oimxKj7/JZQ2gVUmGRFOZUZdXJ0IlzfQPRAf9xActU0rP7I07qTcrP5jzywDqasQTpOg4yYng8LeZM52ID0Bpc7lOB7L4BEIsx6LRLcVl5JDzW67JC5u4hTOFl4K8PtulGSmlZQWul50+YOaBfMWXlzjN8yEEhSBmaAeppCb5e4eD7y937zFXGntjAcIsQcHw2EsVl5LtwuzV9s2krhTZhzkf+vwsxuHVix2MPie8XfBJYZJrTFdt7nmuEfZr2hpsgh65jGdgEi/+UlqpPO3AucB8/IFU3ocCgafNou46oXkGlqcifB1Wg4cfD0ZS55x0Csqdx3DcWxfi52DgRNDOg4qUPb9FQPCiH32iPZO/eRWgfNSuQMkYBgas3C7IWk68dnIqAziCNvrQiJCTOB8Mi0w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(7696005)(47076005)(36860700001)(86362001)(82310400005)(6666004)(508600001)(2616005)(2906002)(44832011)(316002)(356005)(16526019)(40460700003)(70586007)(4326008)(186003)(81166007)(8676002)(70206006)(54906003)(1076003)(110136005)(83380400001)(26005)(36756003)(426003)(336012)(8936002)(5660300002)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 23:09:29.7024
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13a8a095-fdcb-4b63-8b14-08da175956a2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3044
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
 arch/x86/kvm/svm/svm.c | 30 +++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h |  5 +++--
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index bbdc16c4b6d7..56ad9ba05111 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -89,7 +89,7 @@ static uint64_t osvw_len = 4, osvw_status;
 static DEFINE_PER_CPU(u64, current_tsc_ratio);
 #define TSC_RATIO_DEFAULT	0x0100000000ULL
 
-static const struct svm_direct_access_msrs {
+static struct svm_direct_access_msrs {
 	u32 index;   /* Index of the MSR */
 	bool always; /* True if intercept is initially cleared */
 } direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
@@ -786,6 +786,33 @@ static void add_msr_offset(u32 offset)
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
+		direct_access_msrs[i + j].index = boot_cpu_has(X86_FEATURE_X2AVIC) ?
+						  (APIC_BASE_MSR + j) : MSR_INVALID;
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
@@ -4765,6 +4792,7 @@ static __init int svm_hardware_setup(void)
 	memset(iopm_va, 0xff, PAGE_SIZE * (1 << order));
 	iopm_base = page_to_pfn(iopm_pages) << PAGE_SHIFT;
 
+	init_direct_access_msrs();
 	init_msrpm_offsets();
 
 	supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index b53c83a44ec2..0bbbe8d6a87a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -27,8 +27,9 @@
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

