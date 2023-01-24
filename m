Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABB0679EBB
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 17:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbjAXQek (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 11:34:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234243AbjAXQeh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 11:34:37 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2068.outbound.protection.outlook.com [40.107.93.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6698F4ABF5;
        Tue, 24 Jan 2023 08:34:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hehFvAqSTyaABLC75awCYFHDuQzVGIxgU+k+4da8HFnfjjGjKR3XJKLMvzn2Y+SO21z3Lq4H4Ms3Ey75QY3Vvs9LE56zdLSJsyT+b1ttpnag6XDudjqMCDVxNXpReF/ZwzASyvDbMumpXsh7nCTM/1aHbImJ8wImf0mO/2+q+h0CJ4rPzGusgGSAR1jRBoNE00V64Vh5e4XcCmIVIEYjMHlqfrPcaslinw8+kpgWFS3WuptbdKO+HXOr8y/+cafl4ykiJwwiYRKL/4tt+V4sawbpHMvIG22p4ioJjsPkxn4K/ZZ/BxtubugcNQuWTin2eFje42euNjgYLH0Uum5HrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DhC2F3TI+mw7QDiGSq9QBBGKm8yRcn2UXO4vbye+Lt0=;
 b=OqDXJAtfJzZPSohF1bfrMvtK24XfSC2swwnXTHYJ4OlMaC3Sp1fKjBpDOxsarP4oG6Q62hgGHjt0uvvGM0JlNyH8VxNj54fGv5TbS4LcbafTJYHnYvPXbUfQlfhVOv75qaUyjfG+ZfGoyqP/v4Y+y/YJ9Tk+Y59QOwxYc8/lAulmm8WAkd8uRBLWjATNUo6X/TTLl8nXZQxdDEul0mdaQqX07SBLngUW3/oe4wK/Y2SV6JO3bYdmgj0ppu1D92aczd3qvXGCT630wyvc0RuHmrKZbRy4Q0jukI9QJCFvtzwlV3fqGo6PjNbL5z/EmpAKOLaLlJdfQoOv9BNSTc04sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DhC2F3TI+mw7QDiGSq9QBBGKm8yRcn2UXO4vbye+Lt0=;
 b=rTmOD4Q8lRj3gIsa+K9JmXhdx6PVnOPgKLiV4yseh7ZV+1Y/KxJUsqNL8YwhoLIf94b7TGMD4orY58fSONv83L8TKS683zMqtaJVWP2MCiJtg4cfZhmRKQvbKUH2SCsEumLxLPEwhsMSrO1a6prLVDKJTfuY/ZlqchHizcEFvb4=
Received: from BN8PR15CA0070.namprd15.prod.outlook.com (2603:10b6:408:80::47)
 by BL1PR12MB5061.namprd12.prod.outlook.com (2603:10b6:208:310::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 16:34:19 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:80:cafe::2) by BN8PR15CA0070.outlook.office365.com
 (2603:10b6:408:80::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Tue, 24 Jan 2023 16:34:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.17 via Frontend Transport; Tue, 24 Jan 2023 16:34:19 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 24 Jan
 2023 10:34:17 -0600
From:   Kim Phillips <kim.phillips@amd.com>
To:     <x86@kernel.org>
CC:     Kim Phillips <kim.phillips@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Alexey Kardashevskiy" <aik@amd.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v9 3/8] x86/cpu, kvm: Add the NO_NESTED_DATA_BP feature
Date:   Tue, 24 Jan 2023 10:33:14 -0600
Message-ID: <20230124163319.2277355-4-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124163319.2277355-1-kim.phillips@amd.com>
References: <20230124163319.2277355-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT049:EE_|BL1PR12MB5061:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b39b77a-717c-434c-e1fa-08dafe28d75f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ClAN5hh6dDf0IZT7HA3A+lqiIj3bA/SClIQrZcpqyjoXf6AS5A3zzKpUJDkJAHs4sRs+jXF5stc5achzQGpvgC+8YVofdSl+J1C2nzgpfXPpfQhHAM/i0sxGNGE2vwoO8B//zAUl8kpgf2mxwmqB+Fq3ceDC2VavmQQxmnfSM9u7W1jSbj1zce60uWPcHEQcZDlDFcu4rRvqkApFHUkGAt3A+m8RFkLA4jux3o2DwUPy8uL5FLpZQaUervtV0rlJ+ct9ilttqW7bNN/ZQNCL9sMAflaI31YXf3mI2njO3szZgpohx4xXGY7xR5WnrPu+embhER2KASTutA0IgWunvnrmMgGNMigQb78kfvDdR4HDfAKPW4sOl2PpoII54MaouEznKtsWsirGa0lBwTYZd0/gQiYsLG7aEYNIUC/+Qw7X3WfWfcB8nAVLRbvRzDqoyYcPOG29VgmApNSG/XY5WZwqNpZnQdqXb/x+dcLkAD6Jth26kmVDW49kJCIy7xOu/TLUE0ukK7jlpoMKwQ/oh7C7n0s3E5p0C8Ba6/Jx2rOyAfvyGrkcrpYQSzI2nJHDVWKXbnq20SFXQ6Dw3dSu7Q2m5cjZqVW6NCogX70Fvw+3rcBYfvkUNuAgywyttQDXF3wq1iKlQ0wtbUpaEDDZcXab20brK/wmNBHGg1O0jJVxSPqjFQe9/IvNWQWLaFOIvg0XDYx8ELRIaSr/zV0YyzYg+KSg0g7fsYsOjNtJL5s=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(396003)(376002)(451199015)(40470700004)(46966006)(36840700001)(36756003)(81166007)(356005)(2906002)(7416002)(82740400003)(8936002)(4326008)(44832011)(82310400005)(41300700001)(5660300002)(83380400001)(36860700001)(86362001)(26005)(478600001)(7696005)(186003)(16526019)(6916009)(40480700001)(54906003)(40460700003)(70206006)(2616005)(8676002)(316002)(70586007)(426003)(47076005)(336012)(1076003)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 16:34:19.1409
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b39b77a-717c-434c-e1fa-08dafe28d75f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5061
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "Processor ignores nested data breakpoints" feature was being
open-coded for KVM.  Add the feature to its newly introduced
CPUID leaf 0x80000021 EAX proper.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 3 +++
 arch/x86/kvm/cpuid.c               | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 552bd3943370..4637fd7a84d6 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -430,6 +430,9 @@
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 
+/* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
+#define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* "" No Nested Data Breakpoints */
+
 /*
  * BUG word(s)
  */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index a1047763fdd3..9764499acce2 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -742,7 +742,7 @@ void kvm_set_cpu_caps(void)
 		F(SME_COHERENT));
 
 	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
-		BIT(0) /* NO_NESTED_DATA_BP */ |
+		F(NO_NESTED_DATA_BP) |
 		BIT(2) /* LFENCE Always serializing */ | 0 /* SmmPgCfgLock */ |
 		BIT(6) /* NULL_SEL_CLR_BASE */ | 0 /* PrefetchCtlMsr */
 	);
-- 
2.34.1

