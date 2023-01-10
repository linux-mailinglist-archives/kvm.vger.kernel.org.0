Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE5F6664EFE
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 23:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234938AbjAJWsU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 17:48:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235389AbjAJWrn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 17:47:43 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502C61EEEF;
        Tue, 10 Jan 2023 14:47:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FAqXYbNHZxYRrI8emdObG8eIoZrKSNl8eR9W4P8p0xktg/i9nVl0/+kKapRjM+emWZw6iyq1eRY/TJC4K7ZTunV9XrIZ8G17YoBYdZLkzXXBj5iJcfGgJuXDPi+bqgRutr9jLIxJo9B6vMLpt5eiSZbAt5YrFAoGBE6HSlCBdxrbv8OlswQflh7e5HExBf88M7ajNyQhLpCt2KIDxqoXpEHHJR5u27C7Wn2PVmMXRk3YoYFWnaURgzw1S4jxwTou/ZlZn7MAm28vLxJEhXqr7uj8Tg8BPDcSWWy6gg5gKtsnJp7Pf5DlrV24M0Lq7w/GEMruaWJaCiTwZSLOOSegKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VUEXrz9qd5mfbHiyr6f57Sg1HV5PVFCdwzdvhqvpqQA=;
 b=Fst9xJVXyUjopDpG21gKoQSOohTMM4cK/1JwwC/2JICgFoxFvMXheEmsnRLsY9nFffL88JFC3S3K9FKDrMkP3nSgJUdQzp4zrW8hXPJelqUw4MmniddOP8KvL3KC+D9m11/s6Xa7Bdz5/1/+sr7v097mKpoxWhYpcS2dRcWGiOSALkm7yIHuTdRJ69mfzADWsq3i3XZjZUF1fpllAahs7h7DAqIL8pNM7MAwTxjauO5doeEc+IBNTvkHh7qLV2ksnFyk2UYTpZR4ltcr2NMbPHJVn5czt0jQDeotvFRhM1EcE8z33JIb9hz/nOcdDq1x3We5GzMBhSX3nleeWGe9YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VUEXrz9qd5mfbHiyr6f57Sg1HV5PVFCdwzdvhqvpqQA=;
 b=XVPAWWmy48XYQZXu8A7l5+dFgmii/8AGXcQMaZDOCc4dQEKu1ovcxcDhPLAFZ3Dh6LQ598NVLlkLM/wyqt+sFMyfPm+m5P3jxK0YDAJO4nlUyn8N0XDnIx5B2CTqwVbJZBk3MKxw8aQRDRCtdf2pyNRx0WuV0aDZMphWfRMNhr4=
Received: from SJ0PR03CA0045.namprd03.prod.outlook.com (2603:10b6:a03:33e::20)
 by CY5PR12MB6106.namprd12.prod.outlook.com (2603:10b6:930:29::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 22:47:30 +0000
Received: from CO1PEPF00001A63.namprd05.prod.outlook.com
 (2603:10b6:a03:33e:cafe::52) by SJ0PR03CA0045.outlook.office365.com
 (2603:10b6:a03:33e::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Tue, 10 Jan 2023 22:47:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF00001A63.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.11 via Frontend Transport; Tue, 10 Jan 2023 22:47:30 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 10 Jan
 2023 16:47:27 -0600
From:   Kim Phillips <kim.phillips@amd.com>
To:     <x86@kernel.org>
CC:     Kim Phillips <kim.phillips@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Borislav Petkov <borislav.petkov@amd.com>,
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
Subject: [PATCH v6 2/7] x86/cpu, kvm: Add the NO_NESTED_DATA_BP feature
Date:   Tue, 10 Jan 2023 16:46:38 -0600
Message-ID: <20230110224643.452273-4-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230110224643.452273-1-kim.phillips@amd.com>
References: <20230110224643.452273-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A63:EE_|CY5PR12MB6106:EE_
X-MS-Office365-Filtering-Correlation-Id: 07bc9dcf-0047-4c40-c743-08daf35ca7d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pyB+sLq3chMkfxR2ApdquE8DgD3TPwSPhyLMpxKQjKKUPwgNT24rwhKgOyJhrsqo5qSZA/v/Uje67OPtsiSWhVMgK5lLigdUBB+n9p+YiJ9kw77v5hyRA69qzX1GsUH/41lw3JdZLT+S0EpcfgyZvLWwI4o1aKrXZZDgHQRRI1VHBY5uqOlIsiOmg1Nkdoc/1aooqBUQSWmtvVykz3IstEMX0Y9ZuNdRA3DyRusgVXEDtmKVPtP7WvVYw5oUDT7gC8oMZDqidF7cyPuWfyHlA1nV7fny8N0QVrMEBLlVVs5x//XDu9leXg2OGyvS2ghv/yYaKZ6HuUN0NPB6HKiUX8njQHxdHsGknViSadEv3TPIoaJ9rY7sljKJd1TgvxkGcB8w7zQ049EAkA4pq8KQmRPjqhr0dIygeg+ZFegAvj6IKuP7nBFlBN7P8d59J48yHAlXVUBg7LIutrTjn5x47x/CILEDGkW6aLaO6UCUzExZr+/nAzBvT8ngzKnBQ4OVnOsfPY0SGNaR4DG5hRe7zJsooOPbn58KIeu62FaffFAjwAtagyyDNYEFv6HizFzVfi9AixXQG5c4Kjbzykt2QhFFhKm7G1farTMxfYxJtBEF+EJrpbosHbYLoOKqvSiS+2uF49XiyG8fYFA85uUHg4k2dFtEtg5TrdZ9u0ecuFTfdU92+jqYJ0meKww3foA8RN15sY0w/SCxMlotXFMdNqVQWHCg0A+4/gdSr0us8GU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(136003)(376002)(451199015)(36840700001)(40470700004)(46966006)(2616005)(186003)(44832011)(5660300002)(1076003)(316002)(478600001)(16526019)(7416002)(26005)(7696005)(40480700001)(426003)(41300700001)(47076005)(40460700003)(336012)(8676002)(6916009)(54906003)(70206006)(70586007)(4326008)(8936002)(83380400001)(82310400005)(36756003)(86362001)(356005)(36860700001)(82740400003)(6666004)(2906002)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 22:47:30.2933
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07bc9dcf-0047-4c40-c743-08daf35ca7d2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A63.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6106
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
open-coded for KVM in __do_cpuid_func().  Add it to its newly added
CPUID leaf 0x80000021 EAX proper, and propagate it in kvm_set_cpu_caps()
instead.

Also drop the bit description comments now it's more self-describing.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 3 +++
 arch/x86/kvm/cpuid.c               | 8 ++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index d53e13048d2e..0cd7b4afd528 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -426,6 +426,9 @@
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 
+/* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
+#define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* "" AMD No Nested Data Breakpoints */
+
 /*
  * BUG word(s)
  */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b14653b61470..69e433e4e9ff 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -741,6 +741,10 @@ void kvm_set_cpu_caps(void)
 		0 /* SME */ | F(SEV) | 0 /* VM_PAGE_FLUSH */ | F(SEV_ES) |
 		F(SME_COHERENT));
 
+	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
+		F(NO_NESTED_DATA_BP)
+	);
+
 	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
 		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
 		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
@@ -1222,9 +1226,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		break;
 	case 0x80000021:
 		entry->ebx = entry->ecx = entry->edx = 0;
+		cpuid_entry_override(entry, CPUID_8000_0021_EAX);
 		/*
 		 * Pass down these bits:
-		 *    EAX      0      NNDBP, Processor ignores nested data breakpoints
 		 *    EAX      2      LAS, LFENCE always serializing
 		 *    EAX      6      NSCB, Null selector clear base
 		 *
@@ -1235,7 +1239,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		 * KVM doesn't support SMM_CTL.
 		 *   EAX       9     SMM_CTL MSR is not supported
 		 */
-		entry->eax &= BIT(0) | BIT(2) | BIT(6);
+		entry->eax &= BIT(2) | BIT(6);
 		entry->eax |= BIT(9);
 		if (static_cpu_has(X86_FEATURE_LFENCE_RDTSC))
 			entry->eax |= BIT(2);
-- 
2.34.1

