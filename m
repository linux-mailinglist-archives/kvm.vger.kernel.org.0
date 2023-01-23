Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05329678B2E
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 23:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbjAWW6U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 17:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233417AbjAWW6S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 17:58:18 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2044.outbound.protection.outlook.com [40.107.94.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD4318176;
        Mon, 23 Jan 2023 14:57:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kJQJkKuQVEK2HeEZGs7VkxbNvEIJtaReDWB/PjTlN69hq7I4A9jbfjK/0iP2J6vVzyQje0b1ofs5tvv6OpEw1S66C6RnwQMBw/OdCvHoXclBUHn0lQkvfsHHVBmfABSyXXi3sYaQE0v2qnWH0cRdy14F0RtJ1adaRxG51GkvMv7jVA6D1Mq6xKlUNR5V8k/4q+PGIgOOApjSedVPBdZnZHZHJavHLD5jhiYXkrqtB4aTPDudHlbnQpuza3c5m0mjoQiXVMpXl0TuFzPWitQyDV3pchM5UWT/vOEizCJat7xfSVNHPWD4SCZOpQ0UIw4I8Wu0EW6s1wsge4ngd/SXYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5FfqCsvEAVPCNalYUaEV/E58Nk534dZaVTkYflQikK8=;
 b=Q3RGrKUO6025Jl1huyw8lUyff4EnEv4x6/N92IFav6ABiAlRaraMjCpDaZa1+ZHfWxaNa4qg9k1ITe+Q4NFxGudNmon4PHfl17J5KAebxp6J2qky8TU9t/LKwLRfbq7TUmNVwFO+ez+vI12szclx3tZvT7hcvuIldjd4WJhavatWTG62jpizzzZw8cegY2KzuT4Uy5SuobAeZosiwrN+nUGSnzJkO00uQl7MbJqZHsYkzUrD9ycdGsyAskYAuIjjSNgjq5KtoyXr/e3GY3sBGmdu5SGGpBh8vA4XtKKqUgt/YBFPJOLHMlEgCgcMR35f6s5ZXEzr/Y8jT0hP9sHqyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5FfqCsvEAVPCNalYUaEV/E58Nk534dZaVTkYflQikK8=;
 b=GdbyfoISdivmfilnl4zO1QlPAW4T/uXiTNOltagaUrFkD8X4obNaIznZ2vsGOFtZYZ3ZPI4UNbnvrKXrENvOd47qwtS3ZbGeeYCxssHwqk7bptDUvg0//auV34in1LOKaJwhrNDQK1elZIhO0oA1u/9daPacIAs0vHarxRJv710=
Received: from BN6PR17CA0058.namprd17.prod.outlook.com (2603:10b6:405:75::47)
 by PH0PR12MB8151.namprd12.prod.outlook.com (2603:10b6:510:299::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 22:57:51 +0000
Received: from BN8NAM11FT101.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::3b) by BN6PR17CA0058.outlook.office365.com
 (2603:10b6:405:75::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Mon, 23 Jan 2023 22:57:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT101.mail.protection.outlook.com (10.13.177.126) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.13 via Frontend Transport; Mon, 23 Jan 2023 22:57:51 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 23 Jan
 2023 16:57:50 -0600
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
Subject: [PATCH v8 3/8] x86/cpu, kvm: Add the NO_NESTED_DATA_BP feature
Date:   Mon, 23 Jan 2023 16:56:55 -0600
Message-ID: <20230123225700.2224063-4-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230123225700.2224063-1-kim.phillips@amd.com>
References: <20230123225700.2224063-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT101:EE_|PH0PR12MB8151:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e05d274-fd5a-42c3-ef11-08dafd954186
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NVJkWh6YuGKixCpdRj0VcqU4/TPF+AUNvcPpaS/jyVD6TB7BZFJ6wAmInUVSkqXIfvOLAKONwIi64dyQ0Wn24szplmGpzVbEGrRrwleToLJuzsFpP8e1JIBfovqI5CN5g1ZShKpGiOy9BawhxnTrvG8f32/PiMa+gimHXfiTm+F9jnYDenQXhOCm8z2ELiek339/YqdnjDHfxJLkfAY+gB9WRI2LFxGK1OYsTgwgTryMkYcR3+eV9QVTVzFdP25iOVC3DoJWkpw3fJ9ccmdb+obi+TVktrjxhPC/QuXx6bOfUuTHwRFQuq+MzjL9QPiC6dZdUYQ5CPXjkT51qlQDmQDIlZZMQ8U24r7R7/R7LZ0R3yMy8wOfK0guKdItSbCajYlO4sdS3/mgmR3i8pAT9OdBB+cYMtuJwP+0NoFPkTpbf15JtuoB9SdOtiIt45BMO4J/gLm3IVIkownYC2U2s+mFvgddLPs0S4fvdSBoEc+Qz7d9/KOmsb9wQgQTzrTRQyF2IWOpORNYCCSOK1T/t/cxskcyxbO7g6NxYiduqoYCzerhjhywJAktDFH20l5lWyB3KoP/vPv28mbFNLdJz+55R32LPlazI2EcQnePF7sLQVVG1h2wzFZYfwux1R+xSD2vyf/jM8R/spZeH+xj8h3HA6ngCq45om0MjEKnm6t7aWBrojnEODcMcqm7CZOxlJdW9Yt+noOcfu0xfkokYaoNGXqSMFCVk+LBli1s0AM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39860400002)(136003)(376002)(451199015)(46966006)(40470700004)(36840700001)(83380400001)(36860700001)(82310400005)(81166007)(82740400003)(7416002)(41300700001)(86362001)(356005)(44832011)(2906002)(8936002)(5660300002)(4326008)(40460700003)(40480700001)(16526019)(8676002)(6916009)(26005)(186003)(47076005)(336012)(426003)(70206006)(316002)(70586007)(2616005)(54906003)(1076003)(478600001)(7696005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:57:51.7194
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e05d274-fd5a-42c3-ef11-08dafd954186
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT101.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8151
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
index a84536876794..7f0fb894e432 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -428,6 +428,9 @@
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 
+/* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
+#define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* "" No Nested Data Breakpoints */
+
 /*
  * BUG word(s)
  */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 3930452bf06e..13bd2769fa5a 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -742,7 +742,7 @@ void kvm_set_cpu_caps(void)
 		F(SME_COHERENT));
 
 	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
-		BIT(0) /* NO_NESTED_DATA_BP */ | 0 /* SmmPgCfgLock */ |
+		F(NO_NESTED_DATA_BP) | 0 /* SmmPgCfgLock */ |
 		BIT(6) /* NULL_SEL_CLR_BASE */ | 0 /* PrefetchCtlMsr */
 	);
 	if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
-- 
2.34.1

