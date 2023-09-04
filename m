Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A41B7791540
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 11:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236158AbjIDJ46 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 05:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233977AbjIDJ45 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 05:56:57 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2069.outbound.protection.outlook.com [40.107.100.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8761AC;
        Mon,  4 Sep 2023 02:56:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XkezT17YpCE9XH/tCrXUuL71bKMs2b9RBFupbWLsstUtQeETIhtRhWor6yeWr+Be9nSVhXKpA0hz3+YgvZKVE8G2Bg7rCp9OMCIaNpY8zZxP/MOnKx3/YE6vfr6Rd+NY/0H/iwMEVLQ32M1u2LKQT+Hvdt/dY/IB0+04VbL2VUncyNsgIo3eSsDS0+Tl4j6en7BKYO19WxaQShk+yI85vGDE4DtLz3y8A9t5o4tuqb4PA2MCH6ZOjwckljz+8SCs1/n63iH1/pAIJS6yltNFcFXnYSxW6sgeMimDS7qfR6BWHb6FMuwhNlwBXfP51UUQMeHiHHejB5g9HjBLq03cpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=glVnzG9XCJ+4K13xqccDVQSz9aoSLG442usEAi1R78Q=;
 b=SXyPhr0cwP0vZpbdPH6rPNYjoi/XWcq9rn2+3CHsE/xR0iV2DDJv4Ich4nylHNTH6i1hacw1yyNUvO2VOWMvQL0d4w5EmilEnDO/g3PQ0GUvWvr2yLNsbF8hHfq7BRfSqgDzmyMDEBKBb6u5Pvj1UpUSCiWSD48/OUCV0Euww4/jTh+JVFGSIS0KSnW9K3/n2rQi6OkKQZJzOJu9WpUvlI7PZ7QvGQ3y0UiiUOJumEpXXi736WruCULk8TjC5QBZbIAM4rD5BEgoqEvdMpR3HAzoJtve4U95GXjQzcE277SHe5814l5LMjhlkzBvDQgIic7EXU1DmRdjwH/1BLZCPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=glVnzG9XCJ+4K13xqccDVQSz9aoSLG442usEAi1R78Q=;
 b=XRrcccsl102Jg27mXlpo8ovcKo7wpffg6I7DxRFSMSq9Q5FeJPwT5weF26xAYjZvLNYtKuIzfEUkfCN1khbHbRZZICd+hcn3zAcG++lS1YNmHDf4/UIyEwvSFMyL5NaB5K2ivnF33i8wrmOvYXLxo8UvLttdN0rTtWoEHU4KyBM=
Received: from DM6PR07CA0089.namprd07.prod.outlook.com (2603:10b6:5:337::22)
 by CY8PR12MB8364.namprd12.prod.outlook.com (2603:10b6:930:7f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.30; Mon, 4 Sep
 2023 09:55:41 +0000
Received: from DS2PEPF0000343E.namprd02.prod.outlook.com
 (2603:10b6:5:337:cafe::58) by DM6PR07CA0089.outlook.office365.com
 (2603:10b6:5:337::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33 via Frontend
 Transport; Mon, 4 Sep 2023 09:55:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343E.mail.protection.outlook.com (10.167.18.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6768.25 via Frontend Transport; Mon, 4 Sep 2023 09:55:40 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 4 Sep
 2023 04:54:49 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <linux-doc@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
        <x86@kernel.org>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <bp@alien8.de>, <santosh.shukla@amd.com>, <ravi.bangoria@amd.com>,
        <thomas.lendacky@amd.com>, <nikunj@amd.com>,
        <manali.shukla@amd.com>
Subject: [PATCH 08/13] perf/x86/amd: Add framework to save/restore host IBS state
Date:   Mon, 4 Sep 2023 09:53:42 +0000
Message-ID: <20230904095347.14994-9-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230904095347.14994-1-manali.shukla@amd.com>
References: <20230904095347.14994-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343E:EE_|CY8PR12MB8364:EE_
X-MS-Office365-Filtering-Correlation-Id: 343c5311-4d66-4868-9544-08dbad2d1928
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gQ+VWFPFXdOeWYcdsY6P8uwkO8ZIJVIoQZtEqE/2W1WCl+TO22xYD/CYXZl751Nn5kpndw5vZf/HK7nzsuqEfW4Y0tsoPc3VI4VbSsidKIsa/TTjUQm4d8G1TYqIcy1VB+pcvqYirf1dGDy9Ma+9rDCjvjI2puCsR3skm1YYgkW/ihZz1ig5Ifpv8yHR/fEy4muwFxL7MS59DNYwXGwmncLDhKz/BBk+xxpa85VXGIC5hjlPWIZ3YA/qaPvFmZ+aWxN8IvDaQNoHuotUO/QiiPXtGLRDjyijcbqJJOcewijeFES8OeQFljoF1AqBDcA0nYYC01jZVoxz0KtXc2SOtp7VgKR8ppbqprw3lnd8eJEfckjSUZO12Kr6cqD2ixGZoDwGvkTB0K8JAVh5Ldq6WbI2ruBqeuzRCe2XBzaa0zQg2dxQyJVgdtDl+M5gpVhbYJINMj1WxiMQ43eApPtmDLJwnJy328sCWRKDRlHULAV8xstbOCQ23ZL5Wg+eimgXB88BS3at871nYr+PBr02vI7ImUZZ8NNOO2i1+LWGX0lgGoq6TRTghHiiDoGSfgKHkw+uU0uUGygCMKnsuQCyV43W3qbnMrgATBgEG+E4AWCv3Xlc8g0C/d7ZjqdP/CsjvoDznmdsw0fkp2CXDrWX7xUaxOPgf+tBm522+kvi46CdnBDlbbSLvOVVPiLeq2EVmcBwZ2r0sEANe0kgC+RKyXE+YjF+vk8Kvy9nNWDpuHts3ywmaLx1BzWB8JGfQfnZnSH0xqUuCT1PiGzo2PH4NA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199024)(1800799009)(186009)(82310400011)(40470700004)(36840700001)(46966006)(316002)(110136005)(36756003)(54906003)(2906002)(86362001)(70206006)(70586007)(40480700001)(8936002)(5660300002)(44832011)(4326008)(8676002)(41300700001)(40460700003)(36860700001)(426003)(2616005)(83380400001)(336012)(1076003)(26005)(16526019)(47076005)(966005)(478600001)(81166007)(356005)(82740400003)(7696005)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 09:55:40.9499
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 343c5311-4d66-4868-9544-08dbad2d1928
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF0000343E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8364
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since IBS registers falls under swap type C [1], only the guest state
is saved and restored automatically by the hardware. Host state needs
to be saved and restored manually by the hypervisor. Note that, saving
and restoring of host IBS state happens only when IBS is active on
host to avoid unnecessary rdmsrs/wrmsrs.

Also, hypervisor needs to disable host IBS before VMRUN and re-enable
it after VMEXIT [2]. However, disabling and enabling of IBS leads to
subtle races between software and hardware since IBS_*_CTL registers
contain both control and result bits in the same MSR.

Consider the following scenario, hypervisor reads IBS control MSR and
finds enable=1 (control bit) and valid=0 (result bit). While kernel is
clearing enable bit in its local copy, IBS hardware sets valid bit to
1 in the MSR. Software, who is unaware of the change done by IBS
hardware, overwrites IBS MSR with enable=0 and valid=0. Note that,
this situation occurs while NMIs are disabled. So CPU will receive IBS
NMI only after STGI. However, the IBS driver won't handle NMI because
of the valid bit being 0. Since the real source of NMI was IBS, nobody
else will also handle it which will result in the unknown NMIs.

Handle the above mentioned race by keeping track of different actions
performed by KVM on IBS:

  WINDOW_START: After CLGI and before VMRUN. KVM informs IBS driver
                about its intention to enable IBS for the guest. Thus
		IBS should be disabled on host and IBS host register
		state should be saved.
  WINDOW_STOPPING: After VMEXIT and before STGI. KVM informs IBS driver
                that it's done using IBS inside the guest and thus host
		IBS state should be restored followed by re-enabling
		IBS for host.
  WINDOW_STOPPED: After STGI. CPU will receive any pending NMI if it
                was raised between CLGI and STGI. NMI will be marked
		as handled by IBS driver if WINDOW_STOPPED action is
                _not performed, valid bit is _not_ set and a valid
                IBS event exists. However, IBS sample won't be generated.

[1]: https://bugzilla.kernel.org/attachment.cgi?id=304653
     AMD64 Architecture Programmer’s Manual, Vol 2, Appendix B Layout
     of VMCB, Table B-3 Swap Types.

[2]: https://bugzilla.kernel.org/attachment.cgi?id=304653
     AMD64 Architecture Programmer’s Manual, Vol 2, Section 15.38
     Instruction-Based Sampling Virtualization.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/events/amd/Makefile      |   2 +-
 arch/x86/events/amd/ibs.c         |  23 +++++++
 arch/x86/events/amd/vibs.c        | 101 ++++++++++++++++++++++++++++++
 arch/x86/include/asm/perf_event.h |  27 ++++++++
 4 files changed, 152 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/events/amd/vibs.c

diff --git a/arch/x86/events/amd/Makefile b/arch/x86/events/amd/Makefile
index 527d947eb76b..13c2980db9a7 100644
--- a/arch/x86/events/amd/Makefile
+++ b/arch/x86/events/amd/Makefile
@@ -2,7 +2,7 @@
 obj-$(CONFIG_CPU_SUP_AMD)		+= core.o lbr.o
 obj-$(CONFIG_PERF_EVENTS_AMD_BRS)	+= brs.o
 obj-$(CONFIG_PERF_EVENTS_AMD_POWER)	+= power.o
-obj-$(CONFIG_X86_LOCAL_APIC)		+= ibs.o
+obj-$(CONFIG_X86_LOCAL_APIC)		+= ibs.o vibs.o
 obj-$(CONFIG_PERF_EVENTS_AMD_UNCORE)	+= amd-uncore.o
 amd-uncore-objs				:= uncore.o
 ifdef CONFIG_AMD_IOMMU
diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 6911c5399d02..359464f2910d 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -1039,6 +1039,16 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 		 */
 		if (test_and_clear_bit(IBS_STOPPED, pcpu->state))
 			return 1;
+		/*
+		 * Catch NMIs generated in an active IBS window: Incoming NMIs
+		 * from an active IBS window might have the VALID bit cleared
+		 * when it is supposed to be set due to a race. The reason for
+		 * the race is ENABLE and VALID bits for MSR_AMD64_IBSFETCHCTL
+		 * and MSR_AMD64_IBSOPCTL being in their same respective MSRs.
+		 * Ignore all such NMIs and treat them as handled.
+		 */
+		if (amd_vibs_ignore_nmi())
+			return 1;
 
 		return 0;
 	}
@@ -1542,3 +1552,16 @@ static __init int amd_ibs_init(void)
 
 /* Since we need the pci subsystem to init ibs we can't do this earlier: */
 device_initcall(amd_ibs_init);
+
+static inline bool get_ibs_state(struct perf_ibs *perf_ibs)
+{
+	struct cpu_perf_ibs *pcpu = this_cpu_ptr(perf_ibs->pcpu);
+
+	return test_bit(IBS_STARTED, pcpu->state);
+}
+
+bool is_amd_ibs_started(void)
+{
+	return get_ibs_state(&perf_ibs_fetch) || get_ibs_state(&perf_ibs_op);
+}
+EXPORT_SYMBOL_GPL(is_amd_ibs_started);
diff --git a/arch/x86/events/amd/vibs.c b/arch/x86/events/amd/vibs.c
new file mode 100644
index 000000000000..273a60f1cb7f
--- /dev/null
+++ b/arch/x86/events/amd/vibs.c
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ *  Virtualized Performance events - AMD VIBS
+ *
+ *  Copyright (C) 2023 Advanced Micro Devices, Inc., Manali Shukla
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+
+#include <linux/perf_event.h>
+
+DEFINE_PER_CPU(bool, vibs_window_active);
+
+static bool amd_disable_ibs_fetch(u64 *ibs_fetch_ctl)
+{
+	*ibs_fetch_ctl = __rdmsr(MSR_AMD64_IBSFETCHCTL);
+	if (!(*ibs_fetch_ctl & IBS_FETCH_ENABLE))
+		return false;
+
+	native_wrmsrl(MSR_AMD64_IBSFETCHCTL, *ibs_fetch_ctl & ~IBS_FETCH_ENABLE);
+
+	return true;
+}
+
+static u64 amd_disable_ibs_op(u64 *ibs_op_ctl)
+{
+	*ibs_op_ctl = __rdmsr(MSR_AMD64_IBSOPCTL);
+	if (!(*ibs_op_ctl & IBS_OP_ENABLE))
+		return false;
+
+	native_wrmsrl(MSR_AMD64_IBSOPCTL, *ibs_op_ctl & ~IBS_OP_ENABLE);
+
+	return true;
+}
+
+static void amd_restore_ibs_fetch(u64 ibs_fetch_ctl)
+{
+	native_wrmsrl(MSR_AMD64_IBSFETCHCTL, ibs_fetch_ctl);
+}
+
+static void amd_restore_ibs_op(u64 ibs_op_ctl)
+{
+	native_wrmsrl(MSR_AMD64_IBSOPCTL, ibs_op_ctl);
+}
+
+bool amd_vibs_ignore_nmi(void)
+{
+	return __this_cpu_read(vibs_window_active);
+}
+EXPORT_SYMBOL_GPL(amd_vibs_ignore_nmi);
+
+bool amd_vibs_window(enum amd_vibs_window_state state, u64 *f_ctl,
+		     u64 *o_ctl)
+{
+	bool f_active, o_active;
+
+	switch (state) {
+	case WINDOW_START:
+		if (!f_ctl || !o_ctl)
+			return false;
+
+		if (!is_amd_ibs_started())
+			return false;
+
+		f_active = amd_disable_ibs_fetch(f_ctl);
+		o_active = amd_disable_ibs_op(o_ctl);
+		__this_cpu_write(vibs_window_active, (f_active || o_active));
+		break;
+
+	case WINDOW_STOPPING:
+		if (!f_ctl || !o_ctl)
+			return false;
+
+		if (__this_cpu_read(vibs_window_active))
+			return false;
+
+		if (*f_ctl & IBS_FETCH_ENABLE)
+			amd_restore_ibs_fetch(*f_ctl);
+		if (*o_ctl & IBS_OP_ENABLE)
+			amd_restore_ibs_op(*o_ctl);
+
+		break;
+
+	case WINDOW_STOPPED:
+		/*
+		 * This state is executed right after STGI (which is executed
+		 * after VMEXIT).  By this time, host IBS states are already
+		 * restored in WINDOW_STOPPING state, so f_ctl and o_ctl will
+		 * be passed as NULL for this state.
+		 */
+		if (__this_cpu_read(vibs_window_active))
+			__this_cpu_write(vibs_window_active, false);
+		break;
+
+	default:
+		return false;
+	}
+
+	return __this_cpu_read(vibs_window_active);
+}
+EXPORT_SYMBOL_GPL(amd_vibs_window);
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 85a9fd5a3ec3..b87c235e0e1e 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -486,6 +486,12 @@ struct pebs_xmm {
 #define IBS_OP_MAX_CNT_EXT_MASK	(0x7FULL<<20)	/* separate upper 7 bits */
 #define IBS_RIP_INVALID		(1ULL<<38)
 
+enum amd_vibs_window_state {
+	WINDOW_START = 0,
+	WINDOW_STOPPING,
+	WINDOW_STOPPED,
+};
+
 #ifdef CONFIG_X86_LOCAL_APIC
 extern u32 get_ibs_caps(void);
 extern int forward_event_to_ibs(struct perf_event *event);
@@ -584,6 +590,27 @@ static inline void intel_pt_handle_vmx(int on)
 }
 #endif
 
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_CPU_SUP_AMD)
+extern bool amd_vibs_window(enum amd_vibs_window_state state, u64 *vibs_fetch_ctl,
+			    u64 *vibs_op_ctl);
+extern bool is_amd_ibs_started(void);
+extern bool amd_vibs_ignore_nmi(void);
+#else
+static inline bool amd_vibs_window(enum amd_vibs_window_state state, u64 *vibs_fetch_ctl,
+				  u64 *vibs_op_ctl)
+{
+	return false;
+}
+static inline bool is_amd_ibs_started(void)
+{
+	return false;
+}
+static inline bool amd_vibs_ignore_nmi(void)
+{
+	return false;
+}
+#endif
+
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
  extern void amd_pmu_enable_virt(void);
  extern void amd_pmu_disable_virt(void);
-- 
2.34.1

