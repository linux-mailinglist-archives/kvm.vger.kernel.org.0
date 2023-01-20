Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 420AA6749C4
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 04:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjATDMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 22:12:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjATDM3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 22:12:29 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2078.outbound.protection.outlook.com [40.107.223.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA929DCB8;
        Thu, 19 Jan 2023 19:12:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FvyOvENqsqf90RJZlnkHEPbtGpSK5tTLnnDgYKaz2DvEgJF+0GPoJ7V5T4uhKvrnj6iXP6UmC9ckRoAxVPOvjKD2hceNdbEl+jH5RIPL0zC19VCQMo95VyYqkLie4t1qLQwITgjhAvpGyslsjKQxphH3cSgmfDqqukF6nofLaTSmx1XEqiXjoAx1IlgBCAJzvCpOZRQUTObTGFUu+1hsprn8Y+DfA/lcdP8gMhT8pc1DRwkE+hwh9tcNRm1dyr6mivKhU/rT0pIS+gulX2vNKElFWHht0pDztFWb0jMy7lByF5G5dlV2x2pVh0RpasvV0Agt10Vh0YDoNoOYVfLtFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EG9uZE9uvblo8xfS/iechtqdPkTHXUcTtI07AbvVj8I=;
 b=m4DLBTL/jehuQfewTazpuiweAN7eYVOAjH/HxueqjXL5k+KU1xK1+tPJIHJ06FJQJVB68twT6GPBRpBes9PvH7iwIcOwghlGxFf4GL7O95eDegGmOxhrTjcDGq3ZX91oVKpD95fwdsqNScUnO8dRlpjcm0w1PRgX8ShOh06LN6QJsJo56tv0FdKOJdT73PtRWfnAjStqaeIpQmgUB20R1YbttfP5sMv0NfEueXI+mu6KuYh1Xbg1fPCoylK04aEmQbpvKoytKerP9sKEWk2VlkKOWakrHi35gXtxhAqZOcO9anCe49DbLJSO2ZTWG/hdTJjQZ2iMSAnD7YqIZstDXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EG9uZE9uvblo8xfS/iechtqdPkTHXUcTtI07AbvVj8I=;
 b=AidqOi0nOR4Bjf83aOmUrZdQeum33NY6tSIMyfivsTlxbX7uAoezJNkbANf8fp1aWO9yJ9fIlsi4RpuPVrfG36RMZKt2hewIC0Fa1iN+m+nnMPEeKcreFp6qufNIN7nwbyP+jW1VWTPGOpfaEgLQwGP4ns361noWpinLUZzOEms=
Received: from DM6PR06CA0059.namprd06.prod.outlook.com (2603:10b6:5:54::36) by
 CY5PR12MB6647.namprd12.prod.outlook.com (2603:10b6:930:40::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.25; Fri, 20 Jan 2023 03:12:26 +0000
Received: from DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::96) by DM6PR06CA0059.outlook.office365.com
 (2603:10b6:5:54::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26 via Frontend
 Transport; Fri, 20 Jan 2023 03:12:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT058.mail.protection.outlook.com (10.13.172.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Fri, 20 Jan 2023 03:12:25 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 21:11:50 -0600
From:   Alexey Kardashevskiy <aik@amd.com>
To:     Alexey Kardashevskiy <aik@amd.com>
CC:     <kvm@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Yury Norov <yury.norov@gmail.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sean Christopherson" <seanjc@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH kernel v3 1/3] x86/amd: Cache debug register values in percpu variables
Date:   Fri, 20 Jan 2023 14:10:45 +1100
Message-ID: <20230120031047.628097-2-aik@amd.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230120031047.628097-1-aik@amd.com>
References: <20230120031047.628097-1-aik@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT058:EE_|CY5PR12MB6647:EE_
X-MS-Office365-Filtering-Correlation-Id: 3474bb54-6ed3-4278-fa2d-08dafa942804
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LL//HUOJZPb2A0n9zNw2roP4Ef6rwCHnFVRBdqf8wxie4GKBhoKkGRYfPP9FUardLGKN0uslrH9+dMmhpADGEDNwlS90NkIIpvT+B7MQiiucgdsK4H0jRap8D79d92ivVth4W9x+iyZeOC1KvpkgU7HCOZoWO5GKVCYZgEqe041eu9uoyIpzO/NdtCHfjcOWpzng6CFTWP/jTIGRGkJS+hnuVNS8M/tPX9sxzsCEg4mlcLqFOw1UG9J9belsI2KHDrIV4JVCR4SQmt7RRCGZzqHn97YGCjsb3WzPmKkVUPVQOrpraCxtAbTjR40rrJ0/zR+y0Gpf0UAwYrdlSx6JmuMVFqBjczZD0v/8HG2lUBRkLmUgS/Ixz22X8aa+l7It+nAlMzRgBhUxHxWnct7yX2qT8jKXd0ndetxyFzlku0IRUQhIVV1q0grn3dG41zVzvTjqK6quQLFj8bcdlV/98A4TshUxiPs+G/Lfqzcl/UhGMLH5wvbEu6iEH/VWOYJSPD5eJCeQxQUkD4zx+UIVNZIHIxxldvYj7/8d58CA7OKXrmkhhxD0yf6upsYCU1WhP3agVu/IjySmIgtHIPa5L5XqMLFdmK4aBcdSUWsR+OpSM15VIa/kflAIm4OeKK6XJJywsGsrlkfDe0pTYfYDODooQI9chwaKVGolVeRJUcInKc6JJVeP9C7enFiV5j4kR1huREKhAnQkuZtX8iriuPViKB9k3N/j48cSphPkNOU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(396003)(346002)(451199015)(46966006)(40470700004)(36840700001)(6666004)(70586007)(70206006)(4326008)(336012)(478600001)(1076003)(16526019)(26005)(8676002)(186003)(426003)(47076005)(41300700001)(83380400001)(5660300002)(6862004)(7416002)(8936002)(2906002)(36860700001)(6200100001)(81166007)(356005)(40480700001)(82740400003)(7049001)(2616005)(37006003)(316002)(54906003)(40460700003)(36756003)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 03:12:25.8771
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3474bb54-6ed3-4278-fa2d-08dafa942804
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6647
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reading DR[0-3]_ADDR_MASK MSRs takes about 250 cycles which is going to
be noticeable with the AMD KVM SEV-ES DebugSwap feature enabled.
KVM is going to store host's DR[0-3] and DR[0-3]_ADDR_MASK before
switching to a guest; the hardware is going to swap these on VMRUN
and VMEXIT.

Store MSR values passed to set_dr_addr_mask() in percpu variables
(when changed) and return them via new amd_get_dr_addr_mask().
The gain here is about 10x.

As set_dr_addr_mask() uses the array too, change the @dr type to
unsigned to avoid checking for <0. And give it the amd_ prefix to match
the new helper as the whole DR_ADDR_MASK feature is AMD-specific anyway.

While at it, replace deprecated boot_cpu_has() with cpu_feature_enabled()
in set_dr_addr_mask().

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
Changes:
v3:
* fixed commit log
* amd_msr_dr_addr_masks do not do "-1"
* store processor id in a local variable
* s/set_dr_addr_mask/amd_set_dr_addr_mask/

v2:
* reworked to use arrays
* set() skips wrmsr() when the mask is not changed
* added stub for get_dr_addr_mask()
* changed @dr type to unsigned
* s/boot_cpu_has/cpu_feature_enabled/
* added amd_ prefix
---
 arch/x86/include/asm/debugreg.h |  9 +++-
 arch/x86/kernel/cpu/amd.c       | 47 ++++++++++++++------
 arch/x86/kernel/hw_breakpoint.c |  4 +-
 3 files changed, 42 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
index b049d950612f..f126b2ee890f 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -126,9 +126,14 @@ static __always_inline void local_db_restore(unsigned long dr7)
 }
 
 #ifdef CONFIG_CPU_SUP_AMD
-extern void set_dr_addr_mask(unsigned long mask, int dr);
+extern void amd_set_dr_addr_mask(unsigned long mask, unsigned int dr);
+extern unsigned long amd_get_dr_addr_mask(unsigned int dr);
 #else
-static inline void set_dr_addr_mask(unsigned long mask, int dr) { }
+static inline void amd_set_dr_addr_mask(unsigned long mask, unsigned int dr) { }
+static inline unsigned long amd_get_dr_addr_mask(unsigned int dr)
+{
+	return 0;
+}
 #endif
 
 #endif /* _ASM_X86_DEBUGREG_H */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 208c2ce8598a..380753b14cab 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1158,24 +1158,43 @@ static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum)
 	return false;
 }
 
-void set_dr_addr_mask(unsigned long mask, int dr)
+static DEFINE_PER_CPU_READ_MOSTLY(unsigned long[4], amd_dr_addr_mask);
+
+static unsigned int amd_msr_dr_addr_masks[] = {
+	MSR_F16H_DR0_ADDR_MASK,
+	MSR_F16H_DR1_ADDR_MASK,
+	MSR_F16H_DR1_ADDR_MASK + 1,
+	MSR_F16H_DR1_ADDR_MASK + 2
+};
+
+void amd_set_dr_addr_mask(unsigned long mask, unsigned int dr)
 {
-	if (!boot_cpu_has(X86_FEATURE_BPEXT))
+	int cpu = smp_processor_id();
+
+	if (!cpu_feature_enabled(X86_FEATURE_BPEXT))
 		return;
 
-	switch (dr) {
-	case 0:
-		wrmsr(MSR_F16H_DR0_ADDR_MASK, mask, 0);
-		break;
-	case 1:
-	case 2:
-	case 3:
-		wrmsr(MSR_F16H_DR1_ADDR_MASK - 1 + dr, mask, 0);
-		break;
-	default:
-		break;
-	}
+	if (WARN_ON_ONCE(dr >= ARRAY_SIZE(amd_msr_dr_addr_masks)))
+		return;
+
+	if (per_cpu(amd_dr_addr_mask, cpu)[dr] == mask)
+		return;
+
+	wrmsr(amd_msr_dr_addr_masks[dr], mask, 0);
+	per_cpu(amd_dr_addr_mask, cpu)[dr] = mask;
+}
+
+unsigned long amd_get_dr_addr_mask(unsigned int dr)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_BPEXT))
+		return 0;
+
+	if (WARN_ON_ONCE(dr >= ARRAY_SIZE(amd_msr_dr_addr_masks)))
+		return 0;
+
+	return per_cpu(amd_dr_addr_mask[dr], smp_processor_id());
 }
+EXPORT_SYMBOL_GPL(amd_get_dr_addr_mask);
 
 u32 amd_get_highest_perf(void)
 {
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index bbb0f737aab1..b01644c949b2 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -127,7 +127,7 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
 
 	set_debugreg(*dr7, 7);
 	if (info->mask)
-		set_dr_addr_mask(info->mask, i);
+		amd_set_dr_addr_mask(info->mask, i);
 
 	return 0;
 }
@@ -166,7 +166,7 @@ void arch_uninstall_hw_breakpoint(struct perf_event *bp)
 
 	set_debugreg(dr7, 7);
 	if (info->mask)
-		set_dr_addr_mask(0, i);
+		amd_set_dr_addr_mask(0, i);
 
 	/*
 	 * Ensure the write to cpu_dr7 is after we've set the DR7 register.
-- 
2.38.1

