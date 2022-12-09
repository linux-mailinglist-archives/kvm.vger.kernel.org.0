Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB29C647CF8
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 05:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiLIEj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 23:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiLIEjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 23:39:16 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0872F3E0B0;
        Thu,  8 Dec 2022 20:39:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OUC4HLOxyUcos7A6DeYfhw0nmmjOes+yQQWAATAgks0hOruW06qIPDBqne7z5SfntIP99fNA3fndBCJdY1EP81sqDo7QjtFkbqI5PIXKGuNNWiUi0v2O3Q8R0y9VlZP7kIWR74bCG/TVo2cISO2VHw1GyPtg9Su2MVOJaGXIEtlGIORI4TWiwtVZXRmLJ0L1cle9jcP4Q9ZaVLj8Eq9dFYJLRvbvFRTnNU1EIXBKX5KBvEoLKPa8ZBYaJTuPvj7oD9ONkERkU1oe0NVYpN4xM7vS8Tglc2Lsiq18XgHi54o7f1Cyid4f/hOHYbrGHwEckvIgCgbHaNLici9KENNwEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rYb4Sqq0bz3tifXBpFQRNsv0gNXD2bEeWCiPDH1VwbM=;
 b=FjyVCIY+mHNK4lCH4j9Cvi+nDOozPi0oSK30g2BFQ2ANolVZFW3CObcVWxQErSsq6OP1j1/BsedGrSi6uWpY1jPFtpKawVYzGEH/dMMtrJ6kKpyynqWPN/8xooH8sEhw7cfGTEwYoHnkwRFJ+Mc6hzxWM8EgmQeMBvs/3Ln00bHurnnpgAMRXZFFDol8B+lRC4h6plZz+FluARySpNit/xwuHf/z6quCWvQjYighbjyCkAVBSlYNH74mfRAQP9Sojk8B3oq++WuCGAAdOq3RM5/I65zSVsnxkkXQlYYPu7PDdeBYpGV6JPPqSq08jemEwVRCJxnQ8/BPm/QRz3fN9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rYb4Sqq0bz3tifXBpFQRNsv0gNXD2bEeWCiPDH1VwbM=;
 b=uJOrfZ3MQXnKO7xS1R1WZfwEj/PXtMkUPkk4nNh5SPpJV94WEv2vLCex7yngwjY0G5zhOQONi5mQWxkn0SPCPS4wDiOLQ90BWYkuPxHbbbm6ll0PlWqj5d0lploZeZbXD9ruU13hNyLhsEKUKI4mh6pLHnR8l9U2IgZ9WjtD4VY=
Received: from MW4PR04CA0361.namprd04.prod.outlook.com (2603:10b6:303:81::6)
 by MN2PR12MB4109.namprd12.prod.outlook.com (2603:10b6:208:1d9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16; Fri, 9 Dec
 2022 04:39:11 +0000
Received: from CO1NAM11FT105.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::55) by MW4PR04CA0361.outlook.office365.com
 (2603:10b6:303:81::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16 via Frontend
 Transport; Fri, 9 Dec 2022 04:39:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT105.mail.protection.outlook.com (10.13.175.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.17 via Frontend Transport; Fri, 9 Dec 2022 04:39:11 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 8 Dec
 2022 22:38:46 -0600
From:   Alexey Kardashevskiy <aik@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sean Christopherson" <seanjc@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Huang Rui <ray.huang@amd.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH kernel v2 1/3] x86/amd: Cache values in percpu variables
Date:   Fri, 9 Dec 2022 15:38:02 +1100
Message-ID: <20221209043804.942352-2-aik@amd.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221209043804.942352-1-aik@amd.com>
References: <20221209043804.942352-1-aik@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT105:EE_|MN2PR12MB4109:EE_
X-MS-Office365-Filtering-Correlation-Id: 0af23deb-bee8-412b-0377-08dad99f517f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iTyU4mXKeZbfp84yWzFEZm4QMTD1XnKd2JquxRicw9JLRVyWez0QOCgUhK7k5N8/zPXhYvpVVEz0IKpN4EJQ5i6hSb8ODt5fHAOfDeOqMXyXKJBtZMvgTF5rJNO7f6i62mZVAsm6EpNIzHhPprcy5aikCeXkbABCbGK1SFbPOwIhA5plllIcv+6YiQjC8FQ7BNMOnRdkLBqFGB9opv9vK6tpkyT+RKVUjKVNRk+DBzkeP1/XGqmHTp61RdohM4aTN7IVlhp6XyD3ta14sbSfCy9fcCtuB1SvJqrcWa5m/LrkOF8zxG0+N3jDQQCk9Uav5vmVKNIpThxeTna6PwoRfj9M2BJzVIvzagEIsXafz9LIdAnKfF1sLg2eK1eUCIkgVmqNasjAWT6xRhs2hOYVqQ17O4knlCm/RUwgOy3vmWFFTKJ9MGeZnL/ldP9DKv18jshXqjhbwyhb6FmkS88lTh7zkmZaqefaA3tZEkVMZRcZCIeTJPXxNaDTRJvWqFc3eSyYHIGVfA0k6m21M5Jnb9yfXNOWT8tNBKgDxUXgPOZOKC57lPPBMU4iIPxNRMF+o1tdOhobgiM7wafPkT2BZX7jhhSPe9te9EzF0cVPSaxLgqJ11KWiNYlS8UmZcWZmpxj706jn3YN3qEWizVY2wqOT3vQzMJ+zBqzp5S8vqInCY+Avo5Dcp5bYAzU1CT1Aly78HPShmrVtmX6ABeJNnKs7P2ocO376N3WNVjWEghw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(39860400002)(396003)(451199015)(46966006)(40470700004)(36840700001)(36860700001)(8676002)(336012)(7416002)(1076003)(16526019)(83380400001)(40480700001)(2906002)(2616005)(70586007)(40460700003)(36756003)(5660300002)(8936002)(41300700001)(356005)(54906003)(316002)(6916009)(70206006)(4326008)(81166007)(6666004)(47076005)(426003)(478600001)(26005)(82740400003)(82310400005)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 04:39:11.5246
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0af23deb-bee8-412b-0377-08dad99f517f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT105.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4109
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

Store MSR values passsed to set_dr_addr_mask() in percpu values
(when changed) and return them via new amd_get_dr_addr_mask().
The gain here is about 10x.

As amd_set_dr_addr_mask() uses the array too, change the @dr type to
unsigned to avoid checking for <0.

While at it, replace deprecated boot_cpu_has() with cpu_feature_enabled()
in set_dr_addr_mask().

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
Changes:
v2:
* reworked to use arrays
* set() skips wrmsr() when the mask is not changed
* added stub for get_dr_addr_mask()
* changed @dr type to unsigned
* s/boot_cpu_has/cpu_feature_enabled/
* added amd_ prefix
---
 arch/x86/include/asm/debugreg.h |  9 +++-
 arch/x86/kernel/cpu/amd.c       | 45 ++++++++++++++------
 2 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
index cfdf307ddc01..59f97ba25d5f 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -126,9 +126,14 @@ static __always_inline void local_db_restore(unsigned long dr7)
 }
 
 #ifdef CONFIG_CPU_SUP_AMD
-extern void set_dr_addr_mask(unsigned long mask, int dr);
+extern void set_dr_addr_mask(unsigned long mask, unsigned int dr);
+extern unsigned long amd_get_dr_addr_mask(unsigned int dr);
 #else
-static inline void set_dr_addr_mask(unsigned long mask, int dr) { }
+static inline void set_dr_addr_mask(unsigned long mask, unsigned int dr) { }
+static inline unsigned long amd_get_dr_addr_mask(unsigned int dr)
+{
+	return 0;
+}
 #endif
 
 #endif /* _ASM_X86_DEBUGREG_H */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index c75d75b9f11a..9ac5a19f89b9 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1158,24 +1158,41 @@ static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum)
 	return false;
 }
 
-void set_dr_addr_mask(unsigned long mask, int dr)
+DEFINE_PER_CPU_READ_MOSTLY(unsigned long[4], amd_dr_addr_mask);
+
+static unsigned int amd_msr_dr_addr_masks[] = {
+	MSR_F16H_DR0_ADDR_MASK,
+	MSR_F16H_DR1_ADDR_MASK - 1 + 1,
+	MSR_F16H_DR1_ADDR_MASK - 1 + 2,
+	MSR_F16H_DR1_ADDR_MASK - 1 + 3
+};
+
+void set_dr_addr_mask(unsigned long mask, unsigned int dr)
 {
-	if (!boot_cpu_has(X86_FEATURE_BPEXT))
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
+	if (per_cpu(amd_dr_addr_mask, smp_processor_id())[dr] == mask)
+		return;
+
+	wrmsr(amd_msr_dr_addr_masks[dr], mask, 0);
+	per_cpu(amd_dr_addr_mask, smp_processor_id())[dr] = mask;
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
-- 
2.38.1

