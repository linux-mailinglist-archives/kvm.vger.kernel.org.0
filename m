Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3D4552775
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346300AbiFTXDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346316AbiFTXCn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:02:43 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7617522504;
        Mon, 20 Jun 2022 16:02:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEuGsB7BAOPfiu0ZG3kXa438+aRti7Run1rmYEXdP5n1cMko6CQJnu+ekzeq0laugHUQGeqAVaM8H38gC3vvMJRd2DT0FsAZwNZ/lA8ULFXWq978hsNrkmxX+DAqySFQIf6KDTrkjNHfzKopjWvuBd4hj1Dk/Hefqm8usKP25wOVEI6skseqzI2vA2DJE5HNx49o9s0jP+XETtFBOYefHLufuwR6eQOSP9OCmGt7c4eRYBzJeLAsEXVqIZDga44XNZlb8NBqLIltJPjbAC1+bUI/VExZGOx7/B8FmtGjWMc77zJhdY8WAEoKIrmxg51xqBnwEXQ3kWREFZZrBsfNHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7pozSeZao7Z2npXstCLIoiInAiGRAfDTAxJosOGZlHo=;
 b=PDYkaCCl+miZTH+R7q679qiw8QRA1PvLp65W2VuNSEAnFzh18wRWmFVpq72lHdj1Om3sAqoqtY40DIbLbefsVBOt1ucDJ1IbmlD0y0hSrt+HOBlK4GEHd4Y83VGR5zKIr63NtkxHapaNM/+Q0F28pCsuqHBivsPKsZHDn1y02yB4YMCCDHvhBYlkCu8ifX8TRnjlhGtUf75BGON+4N/kXlIAL0v0gVRIv9cRm7eTv8FScEJ38D59S3/xOcYjxXqigC6WYtXTnHl7EIHFg0Ob1ppyeaLp+W9sS27zz4+YBQCfSPEaKiDzWFLdU84cjGbcmH2cWyHZbMNKJzNuna8caA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7pozSeZao7Z2npXstCLIoiInAiGRAfDTAxJosOGZlHo=;
 b=ocdo8SMKl5VjVOXNbUTe4OquIJlCXsbGP4+CZ7V3VEwE3CYaCRnj7SjMfxUDLK8Vf7jndSVSYxoaVEzRG8BIEaEMM2D7VnNhpJxJZGmDGINLaI687Bnc9DEBEGal4VAoby7zkxNmcYICUR+hoCpEBEwoE4tNf/WaTb9xGmvZlsk=
Received: from DM6PR02CA0131.namprd02.prod.outlook.com (2603:10b6:5:1b4::33)
 by BN6PR12MB1555.namprd12.prod.outlook.com (2603:10b6:405:5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Mon, 20 Jun
 2022 23:02:30 +0000
Received: from DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::d3) by DM6PR02CA0131.outlook.office365.com
 (2603:10b6:5:1b4::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.20 via Frontend
 Transport; Mon, 20 Jun 2022 23:02:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT021.mail.protection.outlook.com (10.13.173.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:02:29 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:02:27 -0500
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
Subject: [PATCH Part2 v6 04/49] x86/sev: set SYSCFG.MFMD
Date:   Mon, 20 Jun 2022 23:02:18 +0000
Message-ID: <c933e87762d78e5dce78e9bbf9c41aa0b30ddba2.1655761627.git.ashish.kalra@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8c5b5990-885b-4fb5-9c15-08da5310f3be
X-MS-TrafficTypeDiagnostic: BN6PR12MB1555:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1555D1D3D9031B03DC3C11B98EB09@BN6PR12MB1555.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D89wrd1AASr983GeR0KcIozQGRLwuwTWVKhgdNw3naKasCwC7rGu7QsLKWtreaGFVHXBtznIOgDnVXUzLYwAEomNwFsVMci2Pws2UwlM16/rmGb4oUTBjzReikSMslCUa/dn7rHYD4LgQBGzYdHIexVzTwrlatc57Fhq/0EJ7OSUHiQgYKEj67G4PbbeS2NsGgXS10GQ3svIZZHT0CAg7DntayACPIyqvUs+0wnjBbnxYAb4XC90+Cefi5bcGfvFPmc32PAqPRfnyodquiP2Vch6LL02MO/3G+BnRgqRFc1/l3vhiFC1fnB9sB1WSyHMzdFeZvO+vQao0Dd7t8mhUfAzGspLDEHsn0s4tRpg4uKRoaOv5i5qivIlsABuAq/REygfhok5fO2kZhSlsqv16T26ShGLNngpbbkVPiJkaDNYObsUHgDbW/XfS2AcM+0wl3MZce43wHnC/YI+Or9JNy6SQ4sdkOmS1HYVqO/yupdhdOg7TAmwFHj3ftKCqhGNmhjqwMGUUoJWW8SK74V5UaLPozxr0YmocLk0M5vVp5wQ5KkdBLt4siy75ZrzF+cg2OHMJq62sHuH5ZIxf/HaNJNMcoyt8hcs9oEsrVkIR5kaiFrZgkxXWVmNa/pq35axHXSWOnAYXj+MNLJs9VdemiUhK8bZe50cZrtv7b09RNb5mBEKADRgVaPNvKXhrvqL8OuHsVAmYqnsQ2TcKwCEOLk4lXImO21rLDqYBO/zrZr65uJxs5xiLWoDmmN0jLu4Wl72nppcjhxZaAtsJOgiqw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(396003)(346002)(46966006)(40470700004)(36840700001)(478600001)(336012)(36756003)(6666004)(4326008)(70586007)(41300700001)(8676002)(70206006)(86362001)(26005)(83380400001)(40480700001)(8936002)(186003)(40460700003)(47076005)(426003)(81166007)(82310400005)(7406005)(5660300002)(7416002)(54906003)(110136005)(7696005)(316002)(36860700001)(16526019)(2616005)(82740400003)(356005)(2906002)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:02:29.9190
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c5b5990-885b-4fb5-9c15-08da5310f3be
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1555
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

SEV-SNP FW >= 1.51 requires that SYSCFG.MFMD must be set.

Subsequent CCP patches while require 1.51 as the minimum SEV-SNP
firmware version.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/msr-index.h |  3 +++
 arch/x86/kernel/sev.c            | 24 ++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 57a8280e283a..1e36f16daa56 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -587,6 +587,9 @@
 #define MSR_AMD64_SYSCFG_SNP_EN		BIT_ULL(MSR_AMD64_SYSCFG_SNP_EN_BIT)
 #define MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT	25
 #define MSR_AMD64_SYSCFG_SNP_VMPL_EN	BIT_ULL(MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT)
+#define MSR_AMD64_SYSCFG_MFDM_BIT		19
+#define MSR_AMD64_SYSCFG_MFDM		BIT_ULL(MSR_AMD64_SYSCFG_MFDM_BIT)
+
 #define MSR_K8_INT_PENDING_MSG		0xc0010055
 /* C1E active bits in int pending message */
 #define K8_INTP_C1E_ACTIVE_MASK		0x18000000
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 3a233b5d47c5..25c7feb367f6 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2257,6 +2257,27 @@ static __init void snp_enable(void *arg)
 	__snp_enable(smp_processor_id());
 }
 
+static int __mfdm_enable(unsigned int cpu)
+{
+	u64 val;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return 0;
+
+	rdmsrl(MSR_AMD64_SYSCFG, val);
+
+	val |= MSR_AMD64_SYSCFG_MFDM;
+
+	wrmsrl(MSR_AMD64_SYSCFG, val);
+
+	return 0;
+}
+
+static __init void mfdm_enable(void *arg)
+{
+	__mfdm_enable(smp_processor_id());
+}
+
 static bool get_rmptable_info(u64 *start, u64 *len)
 {
 	u64 calc_rmp_sz, rmp_sz, rmp_base, rmp_end, nr_pages;
@@ -2325,6 +2346,9 @@ static __init int __snp_rmptable_init(void)
 	/* Flush the caches to ensure that data is written before SNP is enabled. */
 	wbinvd_on_all_cpus();
 
+	/* MFDM must be enabled on all the CPUs prior to enabling SNP. */
+	on_each_cpu(mfdm_enable, NULL, 1);
+
 	/* Enable SNP on all CPUs. */
 	on_each_cpu(snp_enable, NULL, 1);
 
-- 
2.25.1

