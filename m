Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA22F63E7C4
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 03:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiLACVh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 21:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbiLACVF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 21:21:05 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBAE9A13D2;
        Wed, 30 Nov 2022 18:20:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LJdIK6T6jfLj4dtTMafJ2VJxncCfjVrBmnH+LIqYg48sJbDTExUsARR7+wYKrBh1g8XIeBB3Q5TBBOQzRiMCUfyyPYBwI53PvfztY9xMn3APkcukC+dghBUYbAxSu+zRBh43nb+TqgJ2CON6bY2QfE3zAqQJxodVwhrHC6aIgLEHxRWpK7QeEEMUIJiBg/0Lxmqg8ywdDH6rKwDTst90eVXSeJh1GJ1OXKWtfDO3rHp5bOzTTcPQ4e7jgOZs9YzSaOs82Fm8zsMk/ROgxV73P2ghQLhxhcw9/b7xORp7V/yR3cxvCNJmQ8m40EHzH4QJlmGCh4boziI1RnMy0TVFCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lp76VTxDs0OlO4s1fAPkZZ8difGoTPNp0BwYKAeFZrE=;
 b=V4lVVyt0v9lEg1MMhA9TrkP/IyyAhSK/j8Xl1sOs4qvjVDn+qYk0lwdkMgDRdvsTzWXxY2Sr9rH5u/eoui42LpYGN9ufPFNmI5xuMXJiJjit4a0tOUyNm2Bbir9g92lxW+xLgLxwkMrMeAcrjDVzX5CP05TQy37OugOmnuOgxE7Z/HHe+DisT+2hx6ioqa/TFsUSsewU5irxbX2EI4iYSLfoxcvdF5BSItBdT+bz2m0g5iaoe3LqIww2BkEIyBYdmEg4s/MgWa2wZpXncg1GyoWcYu4GWpNYl0f43Sl5ugsm2yYI5KsVuKb5xbtEYgmsDIUGmt8pll/Ds71pnhhRlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lp76VTxDs0OlO4s1fAPkZZ8difGoTPNp0BwYKAeFZrE=;
 b=SvbLjDa9EMpysxzWlwtDMmWtGd/VJF+a6MC4poBjvQ+aYcc1oDiuX+8xuiPS18a98duXK6KDCeIymV3Qzf5Kc5pWgu+49CaQz/lpruVO52a/Q4rZPxqvFnklhZaNi7qH5U06BhE2BzpPHyNx9RfDa04xK5q8ab09h5cgsjrfbOY=
Received: from BN0PR03CA0002.namprd03.prod.outlook.com (2603:10b6:408:e6::7)
 by CY8PR12MB7610.namprd12.prod.outlook.com (2603:10b6:930:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 02:20:44 +0000
Received: from BN8NAM11FT115.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::3) by BN0PR03CA0002.outlook.office365.com
 (2603:10b6:408:e6::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 02:20:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT115.mail.protection.outlook.com (10.13.177.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5857.23 via Frontend Transport; Thu, 1 Dec 2022 02:20:43 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 30 Nov
 2022 20:20:33 -0600
From:   Alexey Kardashevskiy <aik@amd.com>
To:     Alexey Kardashevskiy <aik@amd.com>
CC:     <kvm@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Sterritt <sterritt@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "Andrew Cooper" <andrew.cooper3@citrix.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH kernel 1/3] x86/amd/dr_addr_mask: Cache values in percpu variables
Date:   Thu, 1 Dec 2022 13:19:46 +1100
Message-ID: <20221201021948.9259-2-aik@amd.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221201021948.9259-1-aik@amd.com>
References: <20221201021948.9259-1-aik@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT115:EE_|CY8PR12MB7610:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d418dcf-13e6-4d0d-99af-08dad342a645
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JbPmWF9OQ4dUoAh6eLdQ+K9rrflc7V3sN3hR5FFUn6Mkk30Y/4Cuc6noMV9yMqqBEI4OacR4rOQMhmTwmWBfLsQUuF8JDPuJAUxdHo8dWv7b3jWOKJcmOkgCTtb3y0yL7/tyIiw0hS3NrDm/lV05oCHSGXu75ChXS0fdiLPKt9aVFncQYMVQWECj9M9hxibxcggT0BEFirhEGGwc92GIwXzXcpe+NRy0IRBC8jYUmOg6+4U6NQu7TLirIJD4yhkc336//dGU78/M5Qztjoa4JOamIclDJi4VaS2Djh9HzFhVL/pKNWFUmtEQPyyeYwK8mchESUoDB6sFOu8gwcezhEh5ruZfgwWXJU/GB9S27XlTjM0oudZYG9pxNn1fmcA495sL+3SSoDstYKyBjTTOMi2DkDtILF1gL5DHk1UTgtQjNQC6DXY5fxvMsDRj3OYuDUBqkfHxEENm4BdEWCj68dauyQMCmYp4O0N4keXOvZwcYE1u4EWzp7Fm51w+ouvVCV6OazyHvgThO6xgqSG/1LgFx588+2bWKTt8BJDIirn5DqxVcJFvcjgRcYVvV0M0rx/YDq7Gk4SKNEGkcBiepx2kDf2tFHf0IqGKjNe58tDnxEptFkEb9VNCSrP6wsxBsu+d0egCK5Web3zgDcJi14YD4EQHw0BRjdTNUvGQjHgqUCK/NkFoxVcsdy32FnWg43hqFTf3QpuA+jW1xqemxiAREeUh6azOVAgrmu5rDQA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(136003)(396003)(451199015)(40470700004)(36840700001)(46966006)(7049001)(7416002)(5660300002)(26005)(54906003)(8936002)(316002)(6862004)(8676002)(4326008)(36756003)(37006003)(36860700001)(70586007)(41300700001)(83380400001)(40460700003)(40480700001)(81166007)(356005)(47076005)(82740400003)(478600001)(6666004)(2616005)(426003)(70206006)(82310400005)(336012)(186003)(16526019)(1076003)(2906002)(6200100001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 02:20:43.6759
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d418dcf-13e6-4d0d-99af-08dad342a645
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT115.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7610
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
be noticeable when the AMD KVM SEV-ES's DebugSwap feature is enabled and
KVM needs to store these before switching to a guest; the DebugSwitch
hardware support restores them as type B swap.

This stores MSR values from set_dr_addr_mask() in percpu values and
returns them via new get_dr_addr_mask(). The gain here is about 10x.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 arch/x86/include/asm/debugreg.h |  1 +
 arch/x86/kernel/cpu/amd.c       | 32 ++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
index cfdf307ddc01..c4324d0205b5 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -127,6 +127,7 @@ static __always_inline void local_db_restore(unsigned long dr7)
 
 #ifdef CONFIG_CPU_SUP_AMD
 extern void set_dr_addr_mask(unsigned long mask, int dr);
+extern unsigned long get_dr_addr_mask(int dr);
 #else
 static inline void set_dr_addr_mask(unsigned long mask, int dr) { }
 #endif
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index c75d75b9f11a..ec7efcef4e14 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1158,6 +1158,11 @@ static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum)
 	return false;
 }
 
+DEFINE_PER_CPU_READ_MOSTLY(unsigned long, dr0_addr_mask);
+DEFINE_PER_CPU_READ_MOSTLY(unsigned long, dr1_addr_mask);
+DEFINE_PER_CPU_READ_MOSTLY(unsigned long, dr2_addr_mask);
+DEFINE_PER_CPU_READ_MOSTLY(unsigned long, dr3_addr_mask);
+
 void set_dr_addr_mask(unsigned long mask, int dr)
 {
 	if (!boot_cpu_has(X86_FEATURE_BPEXT))
@@ -1166,17 +1171,44 @@ void set_dr_addr_mask(unsigned long mask, int dr)
 	switch (dr) {
 	case 0:
 		wrmsr(MSR_F16H_DR0_ADDR_MASK, mask, 0);
+		per_cpu(dr0_addr_mask, smp_processor_id()) = mask;
 		break;
 	case 1:
+		wrmsr(MSR_F16H_DR1_ADDR_MASK - 1 + dr, mask, 0);
+		per_cpu(dr1_addr_mask, smp_processor_id()) = mask;
+		break;
 	case 2:
+		wrmsr(MSR_F16H_DR1_ADDR_MASK - 1 + dr, mask, 0);
+		per_cpu(dr2_addr_mask, smp_processor_id()) = mask;
+		break;
 	case 3:
 		wrmsr(MSR_F16H_DR1_ADDR_MASK - 1 + dr, mask, 0);
+		per_cpu(dr3_addr_mask, smp_processor_id()) = mask;
 		break;
 	default:
 		break;
 	}
 }
 
+unsigned long get_dr_addr_mask(int dr)
+{
+	if (!boot_cpu_has(X86_FEATURE_BPEXT))
+		return 0;
+
+	switch (dr) {
+	case 0:
+		return per_cpu(dr0_addr_mask, smp_processor_id());
+	case 1:
+		return per_cpu(dr1_addr_mask, smp_processor_id());
+	case 2:
+		return per_cpu(dr2_addr_mask, smp_processor_id());
+	case 3:
+		return per_cpu(dr3_addr_mask, smp_processor_id());
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(get_dr_addr_mask);
+
 u32 amd_get_highest_perf(void)
 {
 	struct cpuinfo_x86 *c = &boot_cpu_data;
-- 
2.38.1

