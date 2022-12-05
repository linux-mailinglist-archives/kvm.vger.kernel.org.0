Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C17B164398F
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 00:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbiLEXeJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 18:34:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbiLEXdz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 18:33:55 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8962518372;
        Mon,  5 Dec 2022 15:33:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6OX0nBCf48vM8+oJPJbPYOwkxem03kv6QgXxGcE4qmn/GybHVYpW6iQ9T8ESpkpbA1hIkz7JOGJhKF5gHex8UNXM6eo+zImgRwBGKa14mbeTChmQsXwHdQElhkNwquhmiUOUnkZLuaMpV2JMMjKUaxu8rbrfkWCQTUEYTAgIyg46QoFr/Qq/CS75dRZuZ0LJQhIyWAHVg40LV/wtEF/mAU8nsiZ8GOaHfv3RUUM6rmeWnYmk8GDoUfC7JdikYJXJL/OiNK7XczdgDMSIm+AMgaQWGlVdWPBpxUiVIXCCfb6jV/1lDLiuJv2PmEevUspHkc9pgX+e3NpbbttL6On1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aJNYRfHM869rcVG5ek02QXWp90OIOOF7VmnPInzVI0g=;
 b=KcNpU7TJH/cxi+Sw3C1UjgSE5iUrC8LmHrOQVkMlIskF4EY8W+98zpGW3Jbm45dwy02ri9EEL6TrktzrIed6IZJPgeSjooSX8oZHpX54xLh2r7P+k+tIhCPnaHX/3B9bFnHvLEa8+78vFmFc2ovo3/FLWlryEuUPtmDAVZd68HkreLJMXGIoXiJjGNnREgKVZ9Is+0G/6Rs6EQllEl8JiyqV+oL5GrZZBdxcnQLK2gfB/XGiTKAQfCIt1tCq3XpXoQiHWL2mTyvYkItKz29iAixfF14LI0kF0bKNRm+2WS/n2gzPbmJDT/kChpp4DU44IYrigSFuM8Ha05a9jA4eqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aJNYRfHM869rcVG5ek02QXWp90OIOOF7VmnPInzVI0g=;
 b=ZoTYCvQyk0MHaWLmNUl+4IHmHJqwQ5I2ZOyiyqriFj19b0YPBY7PwyITPs19ncNxQFIoy0UowHXt8odp7T7LY1jAS5Hq38GprpV/RuCZkODAVidsgf5uoUoHe/GnowExiEICY5pGkdYMq0MsqcVTZu+1z2gJ+KkLEeT4JOpdrwQ=
Received: from DS7PR03CA0273.namprd03.prod.outlook.com (2603:10b6:5:3ad::8) by
 MW4PR12MB7357.namprd12.prod.outlook.com (2603:10b6:303:219::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 23:33:43 +0000
Received: from DS1PEPF0000E642.namprd02.prod.outlook.com
 (2603:10b6:5:3ad:cafe::12) by DS7PR03CA0273.outlook.office365.com
 (2603:10b6:5:3ad::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Mon, 5 Dec 2022 23:33:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E642.mail.protection.outlook.com (10.167.17.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Mon, 5 Dec 2022 23:33:42 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 5 Dec
 2022 17:33:40 -0600
From:   Kim Phillips <kim.phillips@amd.com>
To:     <x86@kernel.org>
CC:     Kim Phillips <kim.phillips@amd.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@amd.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 4/7] x86/cpu, kvm: Move CPUID 0x80000021 EAX feature bits propagation to kvm_set_cpu_caps()
Date:   Mon, 5 Dec 2022 17:32:32 -0600
Message-ID: <20221205233235.622491-5-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221205233235.622491-1-kim.phillips@amd.com>
References: <20221205233235.622491-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E642:EE_|MW4PR12MB7357:EE_
X-MS-Office365-Filtering-Correlation-Id: 83d102b9-eccb-4651-b83a-08dad7192554
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sfFixoy256pbkMw+oX6f/GCsm06z1AmEnq83DsxcUWgEoY/ExL7Kw910wYxMnQagPlIQugWnJvoKK14v6ATQB1iN5p/y5zujVQbIY8x/NjZO4jhqF/k+gzJwxiKT9ly748qB9axykccVKFs6wi0I4i1TkT/Ac9wuamcNlZHAxSQb2RstLz69rI+4RA9JGDYprrb7VpKhZORTkX8pfk+RyAZzbVMva4XDwqtQBKExFYfdlhHi7bENQWh5K2wYcUV8PFC/H1PiXXom/WdXhcYN+RaMqWhgO7ur/FuB5b0e6/rRbU7vUq0UPfaKD1mIlcOPbONYA3D1/R5uuGb41ORh9EE7AC0Wv8LAGxYIVOt4CrhDVTDehMd3DgxsDRdB29i0itY7BDmXl2v0HdgP2Y/uyFAGalp+3xl+jLJAiS69ZVQIVwnEkUGxmrFsXjKgfncvltx9FHmmOILKt8XEPzhFhNXcbHVfLFGxUc9JKkxmvY+eP6CdiLJhMuMph2UAYNQUFiiegk3Guj9VbtogXH/nb9JbkAWNyreq7fqIz3bU6nOTLXQqbJ1FukcuGy/HzRdT4UJj/LcpKiNfUKg4CylwUDOrqpDCV2hd04SNS6xCy0QAGhg/LcJYQDCORoO3kq3xwN/jHgMFP2kY9N+Qu+l31/n8pgdBVdRZ5suGNUn+/C3plcavyjccyBUAtFokqwYSEBjzE7NDTp7i9F/G3OIFs44G2zg68dsEw1jvVrlmvmQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(136003)(346002)(451199015)(36840700001)(40470700004)(46966006)(8936002)(70586007)(356005)(81166007)(36860700001)(54906003)(316002)(82310400005)(82740400003)(6916009)(4326008)(41300700001)(70206006)(86362001)(7416002)(8676002)(40460700003)(44832011)(36756003)(2906002)(478600001)(5660300002)(40480700001)(6666004)(186003)(26005)(7696005)(426003)(47076005)(16526019)(336012)(83380400001)(2616005)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 23:33:42.6028
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 83d102b9-eccb-4651-b83a-08dad7192554
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E642.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7357
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move CPUID 0x80000021 EAX feature bits guest propagation to
kvm_set_cpu_caps() instead of open-coding them in __do_cpuid_func().
Drop the bit description comments now the code is more self-describing.

Whilst there, switch to using the more efficient cpu_feature_enabled()
instead of static_cpu_has().

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/kvm/cpuid.c         | 25 ++++++++++---------------
 arch/x86/kvm/reverse_cpuid.h | 22 ++++++++++++++++------
 2 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c92c49a0b35b..dd0fe79521eb 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -730,6 +730,15 @@ void kvm_set_cpu_caps(void)
 		0 /* SME */ | F(SEV) | 0 /* VM_PAGE_FLUSH */ | F(SEV_ES) |
 		F(SME_COHERENT));
 
+	kvm_cpu_cap_init_scattered(CPUID_8000_0021_EAX,
+		SF(NO_NESTED_DATA_BP) | SF(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
+		SF(NULL_SEL_CLR_BASE) | 0 /* PrefetchCtlMsr */
+	);
+	if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
+		kvm_cpu_cap_set(X86_FEATURE_LFENCE_RDTSC);
+	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
+		kvm_cpu_cap_set(X86_FEATURE_NULL_SEL_CLR_BASE);
+
 	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
 		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
 		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
@@ -1211,21 +1220,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		break;
 	case 0x80000021:
 		entry->ebx = entry->ecx = entry->edx = 0;
-		/*
-		 * Pass down these bits:
-		 *    EAX      0      NNDBP, Processor ignores nested data breakpoints
-		 *    EAX      2      LAS, LFENCE always serializing
-		 *    EAX      6      NSCB, Null selector clear base
-		 *
-		 * Other defined bits are for MSRs that KVM does not expose:
-		 *   EAX      3      SPCL, SMM page configuration lock
-		 *   EAX      13     PCMSR, Prefetch control MSR
-		 */
-		entry->eax &= BIT(0) | BIT(2) | BIT(6);
-		if (static_cpu_has(X86_FEATURE_LFENCE_RDTSC))
-			entry->eax |= BIT(2);
-		if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
-			entry->eax |= BIT(6);
+		cpuid_entry_override(entry, CPUID_8000_0021_EAX);
 		break;
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 4e5b8444f161..184614e27d5b 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -13,6 +13,7 @@
  */
 enum kvm_only_cpuid_leafs {
 	CPUID_12_EAX	 = NCAPINTS,
+	CPUID_8000_0021_EAX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
@@ -25,6 +26,11 @@ enum kvm_only_cpuid_leafs {
 #define KVM_X86_FEATURE_SGX2		KVM_X86_FEATURE(CPUID_12_EAX, 1)
 #define KVM_X86_FEATURE_SGX_EDECCSSA	KVM_X86_FEATURE(CPUID_12_EAX, 11)
 
+/* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX) */
+#define KVM_X86_FEATURE_NO_NESTED_DATA_BP	KVM_X86_FEATURE(CPUID_8000_0021_EAX, 0)
+#define KVM_X86_FEATURE_LFENCE_RDTSC		KVM_X86_FEATURE(CPUID_8000_0021_EAX, 2)
+#define KVM_X86_FEATURE_NULL_SEL_CLR_BASE	KVM_X86_FEATURE(CPUID_8000_0021_EAX, 6)
+
 struct cpuid_reg {
 	u32 function;
 	u32 index;
@@ -49,6 +55,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
 	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
 	[CPUID_8000_001F_EAX] = {0x8000001f, 0, CPUID_EAX},
+	[CPUID_8000_0021_EAX] = {0x80000021, 0, CPUID_EAX},
 };
 
 /*
@@ -75,12 +82,15 @@ static __always_inline void reverse_cpuid_check(unsigned int x86_leaf)
  */
 static __always_inline u32 __feature_translate(int x86_feature)
 {
-	if (x86_feature == X86_FEATURE_SGX1)
-		return KVM_X86_FEATURE_SGX1;
-	else if (x86_feature == X86_FEATURE_SGX2)
-		return KVM_X86_FEATURE_SGX2;
-	else if (x86_feature == X86_FEATURE_SGX_EDECCSSA)
-		return KVM_X86_FEATURE_SGX_EDECCSSA;
+	switch (x86_feature) {
+	case X86_FEATURE_SGX1:			return KVM_X86_FEATURE_SGX1;
+	case X86_FEATURE_SGX2:			return KVM_X86_FEATURE_SGX2;
+	case X86_FEATURE_SGX_EDECCSSA:		return KVM_X86_FEATURE_SGX_EDECCSSA;
+	case X86_FEATURE_NO_NESTED_DATA_BP:	return KVM_X86_FEATURE_NO_NESTED_DATA_BP;
+	case X86_FEATURE_LFENCE_RDTSC:		return KVM_X86_FEATURE_LFENCE_RDTSC;
+	case X86_FEATURE_NULL_SEL_CLR_BASE:	return KVM_X86_FEATURE_NULL_SEL_CLR_BASE;
+	default: break;
+	}
 
 	return x86_feature;
 }
-- 
2.34.1

