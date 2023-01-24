Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4FA3679EB4
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 17:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234159AbjAXQeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 11:34:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbjAXQeA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 11:34:00 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2044.outbound.protection.outlook.com [40.107.101.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1BC470A2;
        Tue, 24 Jan 2023 08:33:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ezGNv9qYgzOOsOvRgwm+ziikF66srqnHVBbQIeYI/SLD08OaN58+WbIMUhXt1X5Zu+sWIfyAn/ibjQFV3FCBx0PPEDO+59ddCArt6ptSqd+PO2+w3VBv4F4TxN4l5obhTIO6oc6q2pBiHXA25dptUMi5F05f6x/5nYC6vekleBrvGNqCtX1fXEIDXISqT9abz/BjPE9LOzKPfKVn5RepalSxDUxQ3TQ1ZjdoZJv5wJwB63jZdboyb+aVT6Y0AAuaTBvz9DaZRS5ckBTLaYYSnKEjgWJr5r82u7AtvmWkjD5ofE/LnSjwgdmHlVBfpagUOnn12Daxm8knmYxusT848A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZeAiB3rGFTulM1pkSxEmZeh3iMFa/6h68alVtmANw2I=;
 b=hJbpRMVygrOv+663msNirIvkLk5zLSIHpjrCErNMfn0vAaveAj+2G9DD2R8SOwOsGIOr1DP8Mtcqtc27to93ke6BZVixY6Ha56fMGdVYujnyxITqOkQoKMdv2uSkr/UO3k4ocvwrPPG6Sjct1hbK2WT2gC1F0F5Skkg90m26jgd4XyozZkPfcCYJbCE+zoMFND5eTkoYjkrfigHiy+zZQ1GdgGqTm2+EfMUWKYmnpgRm/JD88ekdFi77ctZ2ZEPyYTzE0QxgjwfgAph0naImsTvfiCcLIUfI8di+Fp9tfSmS8s4N0xBhdffwlTG/a2RUCkCzkde6uZmPCMVuPHZ1dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZeAiB3rGFTulM1pkSxEmZeh3iMFa/6h68alVtmANw2I=;
 b=mUkJ8a8DOh6c2Bklrv9ag3Fvd6tnTN0z6TL7ycmal/RCQjGPQpA+1nclLtMiTemaqDdwHU1alGi3N5CYGQE7LPb4vk+gy86GVR9NUg0RmMPAHKrY6nHPk9wT/z84iJhGwW9flHJRpRJ7Lzzo+IjwTQDipmfFBHFxh6gGXnYTxJU=
Received: from BN9PR03CA0283.namprd03.prod.outlook.com (2603:10b6:408:f5::18)
 by DS7PR12MB6168.namprd12.prod.outlook.com (2603:10b6:8:97::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.33; Tue, 24 Jan 2023 16:33:46 +0000
Received: from BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::f3) by BN9PR03CA0283.outlook.office365.com
 (2603:10b6:408:f5::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Tue, 24 Jan 2023 16:33:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT041.mail.protection.outlook.com (10.13.177.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.17 via Frontend Transport; Tue, 24 Jan 2023 16:33:45 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 24 Jan
 2023 10:33:44 -0600
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
Subject: [PATCH v9 1/8] x86/cpu, kvm: Add support for CPUID_80000021_EAX
Date:   Tue, 24 Jan 2023 10:33:12 -0600
Message-ID: <20230124163319.2277355-2-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT041:EE_|DS7PR12MB6168:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d08c122-475b-4b8b-8002-08dafe28c380
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8EM7gfCSr56GMSXDbK5YS6rzkGhRhDDqwBrawUz3Tzqpv5tUWYz/XGJtAUBNoon5b8Yc0V1CyQJ4M0wnsb1BlpNX1uGF8aarDUL5Evxv5Ne/Mzp7dFVdv48OT4MflSdUkHzryDdVzj5G5xyBbv6RhU+CmYI7zx02iIvA+NT8Qxcjt9wlrMfxZum5l4AchjQUI60egFCsSTcJjurrgN9a0mtWpeSfqGO+TlmyiZPaVbYDEwNLK1lm9zF8VvvmDM7fR5fkVsYAlGd7VelgVf9lLtQpFZOPnLSZVeuPeO5C64gQoNqOzj171dVAQ5lInLRa6PCYwe+ZGbJgv9B+uEoQP9n0jONB8JLowVaJtlE1fRGQgVZbicFT5gYeoENlPT4FQ0CPhCq95cfdttjAn8zQpnQBLQEO4NYG+f2MqdrCthMbR8S1mCnv3ZP1D96Q7kH+VrP6PeYVYvZZk1DIliRuHr3L/+HYHna8QtyaJKL3Mx/zM8wui8foVziAbdi3JelbOFx38nA33enbj1ixpi0GvY1QmjNpxb0hEi3yCnstcdi//jcz0GYBGoLxlZyeovRBB/2OB5nboTgtSNTEg+hYh92l7O/QVfVPFxMl69c9SpTz29FFcZ0tko5uak4ox5xni2UYgeLV257A3Irz+18SF2DCSlD06L/b94urc62km+hFdbK6pmlcOkQre+gpNQ26cy2S23HIsuO5Dicu44nyaltO6dA+rru3tecnMaJpsYA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(39860400002)(396003)(451199015)(36840700001)(46966006)(40470700004)(36756003)(41300700001)(86362001)(356005)(82740400003)(81166007)(7416002)(8936002)(5660300002)(4326008)(44832011)(2906002)(82310400005)(83380400001)(36860700001)(478600001)(7696005)(6916009)(26005)(8676002)(186003)(40460700003)(16526019)(40480700001)(316002)(6666004)(70206006)(70586007)(54906003)(2616005)(1076003)(336012)(426003)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 16:33:45.8003
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d08c122-475b-4b8b-8002-08dafe28c380
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6168
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for CPUID leaf 80000021, EAX. The majority of the features will be
used in the kernel and thus a separate leaf is appropriate.

Include KVM's reverse_cpuid entry because features are used by KVM guests, too.

  [ bp: Massage commit message. ]

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/cpufeature.h        | 7 +++++--
 arch/x86/include/asm/cpufeatures.h       | 2 +-
 arch/x86/include/asm/disabled-features.h | 3 ++-
 arch/x86/include/asm/required-features.h | 3 ++-
 arch/x86/kernel/cpu/common.c             | 3 +++
 arch/x86/kvm/reverse_cpuid.h             | 1 +
 6 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 1a85e1fb0922..ce0c8f7d3218 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -32,6 +32,7 @@ enum cpuid_leafs
 	CPUID_8000_0007_EBX,
 	CPUID_7_EDX,
 	CPUID_8000_001F_EAX,
+	CPUID_8000_0021_EAX,
 };
 
 #define X86_CAP_FMT_NUM "%d:%d"
@@ -94,8 +95,9 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 17, feature_bit) ||	\
 	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 18, feature_bit) ||	\
 	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 19, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 20, feature_bit) ||	\
 	   REQUIRED_MASK_CHECK					  ||	\
-	   BUILD_BUG_ON_ZERO(NCAPINTS != 20))
+	   BUILD_BUG_ON_ZERO(NCAPINTS != 21))
 
 #define DISABLED_MASK_BIT_SET(feature_bit)				\
 	 ( CHECK_BIT_IN_MASK_WORD(DISABLED_MASK,  0, feature_bit) ||	\
@@ -118,8 +120,9 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 17, feature_bit) ||	\
 	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 18, feature_bit) ||	\
 	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 19, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 20, feature_bit) ||	\
 	   DISABLED_MASK_CHECK					  ||	\
-	   BUILD_BUG_ON_ZERO(NCAPINTS != 20))
+	   BUILD_BUG_ON_ZERO(NCAPINTS != 21))
 
 #define cpu_has(c, bit)							\
 	(__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 :	\
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 123613cdae93..552bd3943370 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -13,7 +13,7 @@
 /*
  * Defines x86 CPU feature bits
  */
-#define NCAPINTS			20	   /* N 32-bit words worth of info */
+#define NCAPINTS			21	   /* N 32-bit words worth of info */
 #define NBUGINTS			1	   /* N 32-bit bug flags */
 
 /*
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index c44b56f7ffba..5dfa4fb76f4b 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -124,6 +124,7 @@
 #define DISABLED_MASK17	0
 #define DISABLED_MASK18	0
 #define DISABLED_MASK19	0
-#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
+#define DISABLED_MASK20	0
+#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 21)
 
 #endif /* _ASM_X86_DISABLED_FEATURES_H */
diff --git a/arch/x86/include/asm/required-features.h b/arch/x86/include/asm/required-features.h
index aff774775c67..7ba1726b71c7 100644
--- a/arch/x86/include/asm/required-features.h
+++ b/arch/x86/include/asm/required-features.h
@@ -98,6 +98,7 @@
 #define REQUIRED_MASK17	0
 #define REQUIRED_MASK18	0
 #define REQUIRED_MASK19	0
-#define REQUIRED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
+#define REQUIRED_MASK20	0
+#define REQUIRED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 21)
 
 #endif /* _ASM_X86_REQUIRED_FEATURES_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 5fe56f0ec9d7..094dbcd63f2a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1093,6 +1093,9 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 	if (c->extended_cpuid_level >= 0x8000001f)
 		c->x86_capability[CPUID_8000_001F_EAX] = cpuid_eax(0x8000001f);
 
+	if (c->extended_cpuid_level >= 0x80000021)
+		c->x86_capability[CPUID_8000_0021_EAX] = cpuid_eax(0x80000021);
+
 	init_scattered_cpuid_features(c);
 	init_speculation_control(c);
 
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 042d0aca3c92..81f4e9ce0c77 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -68,6 +68,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
 	[CPUID_8000_001F_EAX] = {0x8000001f, 0, CPUID_EAX},
 	[CPUID_7_1_EDX]       = {         7, 1, CPUID_EDX},
+	[CPUID_8000_0021_EAX] = {0x80000021, 0, CPUID_EAX},
 };
 
 /*
-- 
2.34.1

