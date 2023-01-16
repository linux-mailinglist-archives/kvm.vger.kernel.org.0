Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1BB666D276
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 00:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbjAPXC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 18:02:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235144AbjAPXCo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 18:02:44 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CA6298C2;
        Mon, 16 Jan 2023 15:02:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OoAfkp/6tB0XvC6VNxslATHSFVLsNTQF7n+ctdgK9WA4uEbzP49+4K6nziCunPgG8INU55/flkVcTiPvzqUY+9h8eYGWjeiQtUBXEaXqHhiRpEdqXgqakKKrdGA8dENcNVynNfbP4gW0umzhYgfj4OiFzXxWbwM67rN7avSfpzJQGPMxzmu81pZkt3qXTvrNO5Ht3gbWOYVv3ZlFYreIVoaaQvIqktIteKJRvbnXlLhijA0bx4ibgdvW4O0RACQI8jOni3Z/nXYIcIdjwSkOSuX82kr/2z41yNtTyo+QULoSJJr4vaSn3kz/PfIDE2ke0djoAf4fJKbVzUfjDf5sPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P0iJzoPzSoRaNGBZtjRpVCd4JeVDNvGfupd6n6MCwc4=;
 b=MVyY8FpxnuHQvJbwWEOrNbWacz+48Wov4HHaAvp+4wczjOIRMI74/33hhGXbDDBgMHUsikSkI97DL8Sw50/Ha/NKRWk+mgwBwjDGtFmhKkGzaIyshBZvpusVkiVvZRqWTmzV/aCbdGLl8FVq0bZkKGjHBjd9NqMOmbFvwqxnmxVzIROsKsy/XLA1XpEgHH6iXRTCVRAl5dBqoPpEmxn+oR+VJHgbxFpF81NKRgR9WtCHwCHpKc97YLVYFtO7d9txIq8puybH8N/M+uSAUbFv9OFvyjtJNvUxHRMrx8TiDrJ/VJ5B4D6mFWunsatUGGdMzP+9b8yze5KHwfSEMU0hyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P0iJzoPzSoRaNGBZtjRpVCd4JeVDNvGfupd6n6MCwc4=;
 b=4ouqzmTl05VEqS/0SpioG8kqj87VAl6PkySDkjU/9cH5lhwGvwYKqUPs3+YELJtBx0jld3MZ2jPaN/23OnaO6okD6NVnuY75cU/gZINfC0oX9v6+MJfu2EDk6clwO7BUC+iBcViT60wE1fuXDurAWpAYKE1Jrs7d99easII7R6M=
Received: from DS7PR03CA0013.namprd03.prod.outlook.com (2603:10b6:5:3b8::18)
 by PH8PR12MB7025.namprd12.prod.outlook.com (2603:10b6:510:1bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Mon, 16 Jan
 2023 23:02:33 +0000
Received: from DS1PEPF0000B074.namprd05.prod.outlook.com
 (2603:10b6:5:3b8:cafe::66) by DS7PR03CA0013.outlook.office365.com
 (2603:10b6:5:3b8::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Mon, 16 Jan 2023 23:02:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000B074.mail.protection.outlook.com (10.167.17.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.11 via Frontend Transport; Mon, 16 Jan 2023 23:02:33 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 16 Jan
 2023 17:02:31 -0600
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
Subject: [PATCH v7 2/7] x86/cpu, kvm: Add the NO_NESTED_DATA_BP feature
Date:   Mon, 16 Jan 2023 17:01:54 -0600
Message-ID: <20230116230159.1511393-3-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230116230159.1511393-1-kim.phillips@amd.com>
References: <20230116230159.1511393-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B074:EE_|PH8PR12MB7025:EE_
X-MS-Office365-Filtering-Correlation-Id: 620d73ac-ca5e-47f4-7065-08daf815c0a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sIsnQkEVSW1easYSeJAzyYnFvib8bOT2SFHInmWjLdzHfE72KnD3XC3vgaZw3TQ43Zy8Id8BzVG7o6H4bLw0CqAvk+nkVZ/ahlnvjyZWcaew+pKB05bh76jzP1DmZ6tNIcbqeO+UeVJMALrY2TDS08R4u804A8Gxt9XlqehdHcFZhqV8O0NqO16zqXNkJcQbOKMiLfyVj/n+iFx1oyPceGrjvYus5GcI5a+dCgrJmvV38j7FuDuRIx12dB6k8Y/HOTQm9h51d4Vm4xbMBNHfVNwJLf4mWyUXtOwaM91qNFCHfXVwjQp9JH1EMHYlWsog9ftt08J1/5x315mnr7+qDmIFNZa62yTS8uo6srtuLRzKQms4/kQBTTL2LqoQgkAzZfwQSq8eLtF2K81wYowD5/rdmTBd0TgF8IZAgtNhMCcqqNTqwDFnuqhWNjE0lXVoDHhDF0iDzKHSKFsL6If/lVLdjySpLzL9+5jt9pjdKtwqVcHdQtiHME2bPpvl4TjM9qaZKcsaBXHJJSD+hpTNHhOTeug8LaT9XosaHg8M1DEgvwPhfTmIk5lljbVITn/a4J/EIudn5KlhVADUfYDvKM1g4uW+7eM+eQwQLeFwej3Zy7zUZEMceS5nCSWfuWlS4uWKgbGoDvZ2aY5syZrPx4lgtRfZbUvXcuKPBv4/clKc01qoV2VmLlla8xcjOseeEx5kcPuEwsvGBWSgJhkH/GF5k8I/43vIPXAAXAFssgI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199015)(46966006)(36840700001)(40470700004)(36756003)(6666004)(26005)(82310400005)(16526019)(186003)(4326008)(478600001)(82740400003)(81166007)(356005)(7696005)(40460700003)(40480700001)(83380400001)(2616005)(86362001)(336012)(1076003)(36860700001)(47076005)(426003)(44832011)(8936002)(7416002)(5660300002)(2906002)(8676002)(70586007)(70206006)(6916009)(54906003)(41300700001)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 23:02:33.5567
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 620d73ac-ca5e-47f4-7065-08daf815c0a4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B074.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7025
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
index a84536876794..8255b95a7987 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -428,6 +428,9 @@
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 
+/* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
+#define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* "" AMD No Nested Data Breakpoints */
+
 /*
  * BUG word(s)
  */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 596061c1610e..c9081e3a1b66 100644
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

