Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C72678B39
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 23:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbjAWW7C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 17:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbjAWW66 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 17:58:58 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28AAE46B2;
        Mon, 23 Jan 2023 14:58:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JY1/jz6xMt32QA9e6bc6qxjmrAIBf65F43tVZLJnjv2A1ZAdW6PZMM26UXvqW6rW217GkxIcbdxiOAiYU3wTvADOygW1TF0NFIRbLF46rfhNV8zOhiPDI7BXdgp4jMQhUJBnp2+exm1SelpoECakeknHiMeh/dmxnuk68DthhRK0ND9p0Ygb3fk3OlGT1g0M5h1xNt408gL8Z11zBjF8L04P9o4A3J0E66WThuHfnndX9ZqHI1Zt92jKF1h3gycH7AYwCngZ4Jz01HIJXbOyYCZgB3rPe1Zbo42We3ThyPEPqAwV1ZdHGOS9rm4vaQTxB4SrgmIVOV3N0+cllOWgkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DbM4eQmZM7N52LEpv5jH1Qpz6m9vbh9AxilHVdiiIUg=;
 b=GHZGiAM2msBUmPqflj59w2IemOew0JQMjXcyJpBxGOPCzDuO0ySSPMYabkjZZ1/sLKUH7QH9rOsoN2hN+SUtRDrgRCbweLkROxHqrRD5uqlttGc4c1Swu3/lCV8wQ1x7x9+ezsePFh40f5Zb7R6pmNnze6G3QScij/ju8PuxaQGX9zp6VbDt+MTiWQrdxuxHNQW84Qm+NFOWWdK28/Y5Izne6+1avB6QQ6aBXoyzcHLa9fNPqJwCYFbL7yVESFrZWxl2jEyJNahGRlAouHHwz8Np4QSaT0H55iIIAGSIWkoRlnbwgoLHeHl/hg7hTsUznM3KrNYD+HoRmItb2DVAYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DbM4eQmZM7N52LEpv5jH1Qpz6m9vbh9AxilHVdiiIUg=;
 b=abP/sbiWX9Ve1Y5Vuy2HoZDJ/iw3vtMqdWYSFLpKyz9IBS18ohqZr9uJw67OQ/C9vxlMGCD1MHIb8fzX5JVNBBsmWU5IozjfMA198tS0RQ59Q6/le36b9ov9xZ3EtPcHASm3aUJfPBOkfgGwTOr7R+ALcF9AcyFlIsv6YL4s9bw=
Received: from BN9PR03CA0940.namprd03.prod.outlook.com (2603:10b6:408:108::15)
 by BL1PR12MB5994.namprd12.prod.outlook.com (2603:10b6:208:39a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 22:58:27 +0000
Received: from BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:108:cafe::e2) by BN9PR03CA0940.outlook.office365.com
 (2603:10b6:408:108::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Mon, 23 Jan 2023 22:58:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT048.mail.protection.outlook.com (10.13.177.117) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Mon, 23 Jan 2023 22:58:27 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 23 Jan
 2023 16:58:25 -0600
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
Subject: [PATCH v8 6/8] x86/cpu, kvm: Add the SMM_CTL MSR not present feature
Date:   Mon, 23 Jan 2023 16:56:58 -0600
Message-ID: <20230123225700.2224063-7-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT048:EE_|BL1PR12MB5994:EE_
X-MS-Office365-Filtering-Correlation-Id: 4549386e-15ea-4253-448a-08dafd955694
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /KtFf18JNJ1PDJORWUHWEiTrg7i9pfGbwXbInipyXO4uLpZ+Qx733KN1PKmMXJIG70CMzj2sfXM8XRP8QcAMZ+lVj2/6+HWwcZuSpwjVLRBtufsScv7dxnGl6kMs7b/fiQ8PtLhZ/OGaX5afgUarBcaFJZzGl2pMHsPn4UdsMU2C3PsQsuHNQS7rdYu4tr/k5k81/eI7kXMm7d0/irGceJKVOnqUxw1NSonNo4TDc+ihJ9ENU68fNBjkMZVmdiYoh51cxygyJsMUQ3N49N9bFZK/lzLPLQenGon+DohG43J8F+0mCILcSFb4137BgK9ygj3ViUNSaHkpzDLZIsWKuz/hy0JUBDLNc9n2zV9Kj9bpuA3NBPlpwIyDt+jbob3G2SRyDrkXPY0fFmm7IwhX0D6lejngOMdKXuu3i4kEsqGiy+/HvcrzZdUB+dTUP1xfIftdIBk5XdbaOgHGj8JYiQc5OUkorXTlaoVdTNadGvB41a/v/JMZNozCeB67YY495nhJ+7BOyKstQxtspDuUoArGzPS/XpF+H8fMwCl8wHI0RMMwkJXKKTSII9/ztyDyR7Z8mUjFx/ioBXSs8rNnrvxn5bU7KZ2inMz6lwPtmvXu1j72BSXulpZH1CfNIKsWQ7N/94g9pk3kEF8ri4MhU1oaFsz/h3Pm+M65jnePMQL7oqVWnfN1HTrAu0EFhD+Wcnv6FiKM1uecrdaqKxY7yMibmJRGvGn6/gArgz013Xs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(346002)(376002)(451199015)(40470700004)(36840700001)(46966006)(47076005)(426003)(336012)(1076003)(83380400001)(2616005)(40480700001)(86362001)(40460700003)(36860700001)(81166007)(82310400005)(356005)(36756003)(82740400003)(6916009)(4326008)(8676002)(70586007)(70206006)(7416002)(5660300002)(2906002)(44832011)(41300700001)(8936002)(16526019)(6666004)(478600001)(26005)(186003)(54906003)(316002)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:58:27.0389
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4549386e-15ea-4253-448a-08dafd955694
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5994
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SMM_CTL MSR not present feature was being open-coded for KVM.
Add it to its newly added CPUID leaf 0x80000021 EAX proper.

Also drop the bit description comments now the code is more
self-describing.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/cpuid.c               | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 403a534691cc..6dcc3c3d0c8d 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -432,6 +432,7 @@
 #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* "" No Nested Data Breakpoints */
 #define X86_FEATURE_LFENCE_RDTSC	(20*32+ 2) /* "" LFENCE always serializing / synchronizes RDTSC */
 #define X86_FEATURE_NULL_SEL_CLR_BASE	(20*32+ 6) /* "" Null Selector Clears Base */
+#define X86_FEATURE_NO_SMM_CTL_MSR	(20*32+ 9) /* "" SMM_CTL MSR is not present */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f1625a58b5ec..9ba75ad9d976 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -749,7 +749,7 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_LFENCE_RDTSC);
 	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
 		kvm_cpu_cap_set(X86_FEATURE_NULL_SEL_CLR_BASE);
-	kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(9) /* NO_SMM_CTL_MSR */;
+	kvm_cpu_cap_set(X86_FEATURE_NO_SMM_CTL_MSR);
 
 	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
 		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
-- 
2.34.1

