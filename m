Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7237678B34
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 23:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbjAWW6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 17:58:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbjAWW6X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 17:58:23 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2076.outbound.protection.outlook.com [40.107.220.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C28B138B53;
        Mon, 23 Jan 2023 14:58:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mAAai0qE44XotIKkkLJ1tFsKgNjy7MqivVxU/VCd6l69tjoAJh8wdPf5gRtVYPrdbyknuOSn/GxGAOhAtoyXizF2QjxH9C5JbpkLN5RsqEoH0GZic2H9sLltXx+FZOOTudTGw3P22biEr5912hRy/TlctbJ1zYFvRUBqLTwQt5G+cQf3AytVb+iZRoa4gv7B+ssQb0Bi3dNB9p2HWrjPmaD4OUmBJERMFGZeHsbAJ5BSjnjW2ETjc7lvlVKTHOXCdqlII0Pr56XdVtv6u3IBpiRFZtAN/6rihvfY1+tzAAfCJLVg6+3FTbKzImOnu61Sv5os/DDbNkJjaK8hek6ydQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TGNQiin84mFW0kJA8uiHt2++Qo+0t+ZVpaNagY7/T4U=;
 b=UeG/IRS+qFHnJ/GHDirLYdllN08ry82vCh4qru4BVBlAgWDrKPjOjbB6gGSUHUPgoQ3D64U2tufFkRPXFx5JCj/xVZ5pHgkrSLI0A9jKJcZP9cmCXckBrNdr43/1ludmdokzrQjvHfZbW5wYFzLMg4kFIGE3Y+dedI4ElLgj5jk74ukPhG/4TleCzTL3HSy6LFGa6si7cGgrzE14KLfW5JmNZSDMocNq2gsgF4LbTTEzJG1JAbFbskLNm7Np+4PU64tpAqKXxFo2kLXWMW9pKnu/xJJ3cVgTPxnvz8ZHRUD9cYXDuGLFHvILPXiAANK88QW1DgMEqfO+BPw3BQ1UdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TGNQiin84mFW0kJA8uiHt2++Qo+0t+ZVpaNagY7/T4U=;
 b=gkVBLNGJq2rCR+Jjo30Qaq73+gZzWeLqFjT7SABe2LZPFbImAZivpA7MGjSwqO4bj/CUw+5hIU3uRJcL5DouDa5U0GSshh2KnOwakdB8qaU1bZklP9Hjc+qZpNKwsuY9yYBfquULifx7rx6QXjbEcoVADd2xzKH9AdvvscrOOBs=
Received: from BN9PR03CA0544.namprd03.prod.outlook.com (2603:10b6:408:138::9)
 by SA0PR12MB7001.namprd12.prod.outlook.com (2603:10b6:806:2c0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Mon, 23 Jan
 2023 22:58:15 +0000
Received: from BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:138:cafe::1) by BN9PR03CA0544.outlook.office365.com
 (2603:10b6:408:138::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.14 via Frontend
 Transport; Mon, 23 Jan 2023 22:58:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT007.mail.protection.outlook.com (10.13.177.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Mon, 23 Jan 2023 22:58:15 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 23 Jan
 2023 16:58:13 -0600
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
Subject: [PATCH v8 5/8] x86/cpu, kvm: Add the Null Selector Clears Base feature
Date:   Mon, 23 Jan 2023 16:56:57 -0600
Message-ID: <20230123225700.2224063-6-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT007:EE_|SA0PR12MB7001:EE_
X-MS-Office365-Filtering-Correlation-Id: ea2e7d54-2ca8-4f16-137b-08dafd954f8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SZJAG7n2N1bagPCE/zJNZ9QwldmZST2jwA2rgHJbxxJdk2YMnuKXdcSitVgLZdTZCb47onJgzIKGMv25kVHHTEc5jkM3eeYiIiIwNH5W79IOzEyOEHyfS/g3N9HDfe8KohrRhCZID/jSZ6ad6PqfuXjOIZcIlgbtouU5K9zTQCIBlwsr8MMux4M6d7LtaO2/su2/MfXPFgmhgfoXmhEAsOVRKM8HtCm+yxK0i6y7jhePNJGBSHIiY5f2aVgpfpOisnXyMIlWKyrA6NlUE9i1Z9MOdlt9Fw4qit3vGnJ5Rx17U4CKOhYiFnaH3158EL72nTVxrgFxZxGNBAtLYnjVtHUEPnp7E8DLbcWoKW1jSPM7DfI98LQalnW3OQapvNwDH+Bx6qr7aVIHlnWgWPSexMwmtu6vf/9XBDJGf1Q8Wv4cZeN6MzL2zTOkfnqjhQC3u4TQvIaUX8sW4qBch6w2X3O9N/NCSlwptEbX4PIR/sKOTITA2Aa3bkEbqbN0sevr+V1m9OMXkeQC28gyPZS8vO3mzTNX49g3Kq5V5d1L932Fi1GGVVgsFvy8eOO8nadLNFOFI3ITMOR+Y3AGvj31ADbj7BAdh2Stdh7EHnqWxe/D7CYmQYx/IQv8qNdQI/7irUBtWpCb1SXIzI3mJDZRGOXbLDLQ9uRUa9Xj+oC442En51mglUQS/WNKmCyHYoyuyuUagtnLLay4suy8+5PxJayLMrkSoC+vJmCKb2oZslk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(39860400002)(376002)(396003)(451199015)(46966006)(40470700004)(36840700001)(8936002)(316002)(7696005)(40460700003)(6666004)(86362001)(36756003)(478600001)(5660300002)(83380400001)(426003)(336012)(82310400005)(47076005)(54906003)(6916009)(81166007)(2906002)(70206006)(8676002)(7416002)(40480700001)(2616005)(44832011)(82740400003)(1076003)(16526019)(70586007)(186003)(26005)(356005)(4326008)(41300700001)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:58:15.2477
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea2e7d54-2ca8-4f16-137b-08dafd954f8d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7001
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Null Selector Clears Base feature was being open-coded for KVM.
Add it to its newly added native CPUID leaf 0x80000021 EAX proper.

Also drop the bit description comments now it's more self-describing.

  [ bp: Convert test in check_null_seg_clears_base() too. ]

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/common.c       | 4 +---
 arch/x86/kvm/cpuid.c               | 4 ++--
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 4f22d828c753..403a534691cc 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -431,6 +431,7 @@
 /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
 #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* "" No Nested Data Breakpoints */
 #define X86_FEATURE_LFENCE_RDTSC	(20*32+ 2) /* "" LFENCE always serializing / synchronizes RDTSC */
+#define X86_FEATURE_NULL_SEL_CLR_BASE	(20*32+ 6) /* "" Null Selector Clears Base */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 094dbcd63f2a..162352d42ce0 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1685,9 +1685,7 @@ void check_null_seg_clears_base(struct cpuinfo_x86 *c)
 	if (!IS_ENABLED(CONFIG_X86_64))
 		return;
 
-	/* Zen3 CPUs advertise Null Selector Clears Base in CPUID. */
-	if (c->extended_cpuid_level >= 0x80000021 &&
-	    cpuid_eax(0x80000021) & BIT(6))
+	if (cpu_has(c, X86_FEATURE_NULL_SEL_CLR_BASE))
 		return;
 
 	/*
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 601eeb03ebc9..f1625a58b5ec 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -743,12 +743,12 @@ void kvm_set_cpu_caps(void)
 
 	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
 		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
-		BIT(6) /* NULL_SEL_CLR_BASE */ | 0 /* PrefetchCtlMsr */
+		F(NULL_SEL_CLR_BASE) | 0 /* PrefetchCtlMsr */
 	);
 	if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
 		kvm_cpu_cap_set(X86_FEATURE_LFENCE_RDTSC);
 	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
-		kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(6) /* NULL_SEL_CLR_BASE */;
+		kvm_cpu_cap_set(X86_FEATURE_NULL_SEL_CLR_BASE);
 	kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(9) /* NO_SMM_CTL_MSR */;
 
 	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
-- 
2.34.1

