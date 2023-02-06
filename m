Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40BB168B56E
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 07:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjBFGGb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 01:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjBFGGa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 01:06:30 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC46199E7;
        Sun,  5 Feb 2023 22:06:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U6EmanKsIBkDjq1NPT9FYaVL2z+UqxcDHaM27HVs57CBWDq8IYpRAhmHIKxBgyvDd2f7L/fs8k3PCruLysX1kjs9+JdqZpY8TWi77bDiIFQSFErEj8jzOQoJWADEfCZWGBJD1R7KMTKuBHM/UuHmGidnO/yVult9b8OQeZCMT6sz50Ae+8FAIiOcLfDoWMf5ddY/IiYiz1XzAiJioj+7ydqPz83pt+UYyDQ3LfilOCFFjATC7LZM0rHaZ69X5mH1kIr0T6+ajqR7rlLHwVsG0ex/CYumiVNYhRBh1ZwI/7R5gmjkiUgk06sSQDImcNbPfy5b7bmMWL1TucMh9nzcMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dmm7OMSsPQY39WozqzvNmQYqOIGmZ/xyDPcmLLxaADI=;
 b=WSqzla6NXSt7BS8ZE2FcdI1hR8Ix1fAl7tvFlI6n8nng/pulyLyw2vgYGjz262/IthxH0+uMGlIj0yB5VTIvxZeyGR9kK0pffkTyQ7KfqSQ9gFEXwRjDMDU/CmFgIhgCSyDnqSEz5aeiX0kqy1HuamolJbMkXgPEwWmsrvKaFLlb6dtVDOyP8UZQmOtn/VtPXN9wY8t1Z+vznf+xJ0DkcO7Oy31nWnw9w5kcCfjnfgGzg6UrhXIVLXap0wABAM3eDPqnwGDLVfBx36NZIpAEsVEEvzlj13fx7PhNBaiulO2PiLBnHoCw6N9j9YGD5tnQNmj4y4nhjrCqPwS6v1M25Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dmm7OMSsPQY39WozqzvNmQYqOIGmZ/xyDPcmLLxaADI=;
 b=OCoBNpJqVgcB0sTeLnIrw81nyDggDzB/7l6N1Y95cZWPQaYVzmrazl1dupbeVbFQa4xD9TH2aMm6KyLveAfqp5Uh9B12f1Kw73gduajYSZpVaMaWX+gCmlLkdYC5sRYVV0GzRt+l5bCRDGoRUCmSDqpK0IhbtMiyOlf31DZPmdk=
Received: from DM6PR21CA0015.namprd21.prod.outlook.com (2603:10b6:5:174::25)
 by IA0PR12MB8205.namprd12.prod.outlook.com (2603:10b6:208:400::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Mon, 6 Feb
 2023 06:06:18 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:174:cafe::1a) by DM6PR21CA0015.outlook.office365.com
 (2603:10b6:5:174::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.0 via Frontend
 Transport; Mon, 6 Feb 2023 06:06:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.34 via Frontend Transport; Mon, 6 Feb 2023 06:06:18 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 6 Feb
 2023 00:05:55 -0600
From:   Manali Shukla <manali.shukla@amd.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <peterz@infradead.org>, <mingo@redhat.com>, <acme@kernel.org>,
        <jolsa@kernel.org>, <namhyung@kernel.org>, <tglx@linutronix.de>,
        <bp@alien8.de>, <dave.hansen@linux.intel.com>, <seanjc@google.com>,
        <pbonzini@redhat.com>, <jpoimboe@kernel.org>,
        <pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
        <sandipan.das@amd.com>, <jmattson@google.com>,
        <thomas.lendacky@amd.com>, <nikunj@amd.com>,
        <ravi.bangoria@amd.com>, <eranian@google.com>,
        <irogers@google.com>, <kvm@vger.kernel.org>, <x86@kernel.org>,
        <linux-perf-users@vger.kernel.org>, <manali.shukla@amd.com>
Subject: [RFC PATCH kernel 1/2] perf/x86/amd: Add amd_prevent_hostibs_window() to set per-cpu ibs_flags
Date:   Mon, 6 Feb 2023 06:05:44 +0000
Message-ID: <20230206060545.628502-2-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230206060545.628502-1-manali.shukla@amd.com>
References: <20230206060545.628502-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT016:EE_|IA0PR12MB8205:EE_
X-MS-Office365-Filtering-Correlation-Id: 2593ba35-0b5e-424f-6589-08db08084358
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hgl/l1sM9YYQ09g87P/dXOVGJG0EbqOcsO+6yXbczMZyPgZGsNVRvgsYQxwfYddZFuAGGJOZvE7RT5D7pteJTyfBGKJuSl1y251bsdWQ7+lXeTYcASkdRB5uhvxLAm1qS+bdNMY+shHjIUconMB0dPxnIEcoi9VybzirPneTlVS+zSSeCbS/feOj+LNcyr4giG8cfG0isP6Gw8ZS0WnKtw8JYFUV+rdTMXAFU6RBOqglKXcXEaSgXEhwG8Ca5tynGFBA5Hw4P9W9U4DosQ95uxgdxaTCw5ybqyiWijTyq8vdv4LHDkgZauXKlb+SqNyoB3YexDNABPNm9WYUDJ9AQVxsLGTEdRiKEUAkpCfFeuuVI6tv1JVyqIhMrHHr1oQJKysboiXercxCPpNZnztdufOhU4eG5Dn7WunZrnLcTHI5nk6o9Yh0pQ1tXGsWzdtnJhjZjtX5ndrC/ROT4c7iSJHJ6j7NEj1XpKJVFzN5+6pXss8tSylWYNxOuHoA1ZfojXIXRiPBTn2sUKcxUh3GXrMwpiFrOOVG2FK8sE+kPXr8YbrMZKbsQxE1QVvchgZ+Kv3RaZX1d/j/x0dFXDxIWvaQMcR5m+u1R6QJxvMVsvYXymdibB+nqtyDjMj1U7fgG/WNwfztwVXH/ThVVyPsvGfpKGlF9lPvN3nUkSzGAkYVNHMxyDrmbjRMeQWK+TXF5ws3tRBpBYmjx9mWMU9LZ9HzhHzGVv8VQZz0sA5hX38=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(376002)(39860400002)(346002)(451199018)(36840700001)(40470700004)(46966006)(82310400005)(40460700003)(316002)(6666004)(40480700001)(2616005)(478600001)(1076003)(16526019)(26005)(186003)(4326008)(8676002)(6916009)(70206006)(7696005)(36756003)(54906003)(356005)(86362001)(82740400003)(70586007)(47076005)(83380400001)(2906002)(426003)(36860700001)(336012)(44832011)(5660300002)(7416002)(41300700001)(8936002)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 06:06:18.4903
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2593ba35-0b5e-424f-6589-08db08084358
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8205
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a function to set per-cpu ibs_flags based on an active or inactive
PreventHostIBS window.

MSR_AMD64_IBSFETCHCTL[IbsFetchEn] and MSR_AMD64_IBSOPCTL[IbsOpEn] bits
need to be cleared for PreventHostIBS feature to be enabled before VMRUN
is executed.

ENABLE bit and VALID bit for MSR_AMD64_IBSFETCHCTL are contained in the
same MSR and same is the case with MSR_AMD64_IBSOPCTL.

Consider the following scenario:
- The IBS MSR which has ENABLE bit set and VALID bit clear is read.
- During the process of clearing the ENABLE bit and writing the IBS MSR
  to disable IBS, an IBS event can occur that sets the VALID bit.
- The write operation on IBS MSR can clear the newly set VALID bit.
- Since this situation is occurring in the CLGI/STGI window
  (PreventHostIBS window), the actual NMI is not taken.
- Once VMRUN is issued, it will exit with VMEXIT_NMI. As soon as STGI is
  executed, the pending NMI will trigger.
- The IBS NMI handler checks for the VALID bit to determine if the NMI
  is generated because of IBS.
- Since VALID bit is now clear, it doesn't recognize that an IBS event
  is occurred. Due to this reason, the dazed and confused unknown NMI
  messages are generated.

amd_prevent_hostibs_window() is added to avoid these messages when
PreventHostIBS window is active and PreventHostIBS feature is enabled
for the guest.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/events/amd/ibs.c         | 64 +++++++++++++++++++++++++++++++
 arch/x86/include/asm/perf_event.h | 20 ++++++++++
 2 files changed, 84 insertions(+)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index da3f5ebac4e1..e96a4c9ff4ba 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -30,7 +30,9 @@ static u32 ibs_caps;
 
 #define IBS_FETCH_CONFIG_MASK	(IBS_FETCH_RAND_EN | IBS_FETCH_MAX_CNT)
 #define IBS_OP_CONFIG_MASK	IBS_OP_MAX_CNT
+#define PREVENT_HOSTIBS_WINDOW  BIT(0)
 
+static DEFINE_PER_CPU(unsigned int, ibs_flags);
 
 /*
  * IBS states:
@@ -1035,6 +1037,18 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 		if (test_and_clear_bit(IBS_STOPPED, pcpu->state))
 			return 1;
 
+		/*
+		 * Catch NMIs generated in an active PreventHostIBS window:
+		 * incoming NMIs from an active PreventHostIBS window might have
+		 * the VALID bit cleared when it is supposed to be set due to
+		 * a race. The reason for the race is ENABLE and VALID bits for
+		 * MSR_AMD64_IBSFETCHCTL and MSR_AMD64_IBSOPCTL being in their
+		 * same respective MSRs.  Ignore all such NMIs and treat them as
+		 * handled.
+		 */
+		if (__this_cpu_read(ibs_flags) & PREVENT_HOSTIBS_WINDOW)
+			return 1;
+
 		return 0;
 	}
 
@@ -1540,3 +1554,53 @@ static __init int amd_ibs_init(void)
 
 /* Since we need the pci subsystem to init ibs we can't do this earlier: */
 device_initcall(amd_ibs_init);
+
+void amd_prevent_hostibs_window(bool active)
+{
+	if (active)
+		__this_cpu_write(ibs_flags,
+				 __this_cpu_read(ibs_flags) |
+				 PREVENT_HOSTIBS_WINDOW);
+	else
+		__this_cpu_write(ibs_flags,
+				 __this_cpu_read(ibs_flags) &
+				 ~PREVENT_HOSTIBS_WINDOW);
+}
+EXPORT_SYMBOL_GPL(amd_prevent_hostibs_window);
+
+bool amd_disable_ibs_fetch(u64 *ibs_fetch_ctl)
+{
+	*ibs_fetch_ctl = __rdmsr(MSR_AMD64_IBSFETCHCTL);
+	if (!(*ibs_fetch_ctl & IBS_FETCH_ENABLE))
+		return false;
+
+	native_wrmsrl(MSR_AMD64_IBSFETCHCTL,
+		      *ibs_fetch_ctl & ~IBS_FETCH_ENABLE);
+
+	return true;
+}
+EXPORT_SYMBOL(amd_disable_ibs_fetch);
+
+bool amd_disable_ibs_op(u64 *ibs_op_ctl)
+{
+	*ibs_op_ctl = __rdmsr(MSR_AMD64_IBSOPCTL);
+	if (!(*ibs_op_ctl & IBS_OP_ENABLE))
+		return false;
+
+	native_wrmsrl(MSR_AMD64_IBSOPCTL, *ibs_op_ctl & ~IBS_OP_ENABLE);
+
+	return true;
+}
+EXPORT_SYMBOL(amd_disable_ibs_op);
+
+void amd_restore_ibs_fetch(u64 ibs_fetch_ctl)
+{
+	native_wrmsrl(MSR_AMD64_IBSFETCHCTL, ibs_fetch_ctl);
+}
+EXPORT_SYMBOL(amd_restore_ibs_fetch);
+
+void amd_restore_ibs_op(u64 ibs_op_ctl)
+{
+	native_wrmsrl(MSR_AMD64_IBSOPCTL, ibs_op_ctl);
+}
+EXPORT_SYMBOL(amd_restore_ibs_op);
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 5d0f6891ae61..1005505e23b1 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -561,6 +561,26 @@ static inline void intel_pt_handle_vmx(int on)
 }
 #endif
 
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_CPU_SUP_AMD)
+extern void amd_prevent_hostibs_window(bool active);
+extern bool amd_disable_ibs_fetch(u64 *ibs_fetch_ctl);
+extern bool amd_disable_ibs_op(u64 *ibs_op_ctl);
+extern void amd_restore_ibs_fetch(u64 ibs_fetch_ctl);
+extern void amd_restore_ibs_op(u64 ibs_op_ctl);
+#else
+static inline void amd_prevent_hostibs_window(bool active) {}
+static inline bool amd_disable_ibs_fetch(u64 *ibs_fetch_ctl)
+{
+	return false;
+}
+static inline bool amd_disable_ibs_op(u64 *ibs_op_ctl)
+{
+	return false;
+}
+static inline void amd_restore_ibs_fetch(u64 ibs_fetch_ctl) {}
+static inline void amd_restore_ibs_op(u64 ibs_op_ctl) {}
+#endif
+
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
  extern void amd_pmu_enable_virt(void);
  extern void amd_pmu_disable_virt(void);
-- 
2.34.1

