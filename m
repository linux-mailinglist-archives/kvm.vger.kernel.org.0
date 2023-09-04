Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 181C879152E
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 11:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352738AbjIDJyf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 05:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352733AbjIDJyX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 05:54:23 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C62910F8;
        Mon,  4 Sep 2023 02:54:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JaIarI+HCHXPX/D/rSnoRJk31cG2tbUKfQLqvmgoUfnJfwpuVQ43IfCKK2vE1LHSfz3qlRpWa/tQ8QCLO7pf11ksTs8Jz3NjE9FVwk1i4dX9tHmg2Q7cdAlx1ZXzuWEDdX+gZj6uaUTDch5iczgz0/kXWIGlLriLZ8S2naSMuTcP5JW/Df9myVw3ZKrTw7++dfT1lv0C+0nlHoaeYifgUKesHP5rWzxJs7asRZbjOAjKl2lEYOzLBYzWmDwC8Lk9Ue9H61rjwh214C6BCwx0Y94I8X0l/43nGaCVdoCyj9n9ImHBOYL3ZREb6bGuK42FclCEdNk3KWJ/VUxUfCiQtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6MGPSlufF/mbDfMpAx/wXOCT3CqGNZMxEz3X9MH/2EE=;
 b=kbRF7zHvS87IOULIeKCzoSf8IK5KQe28VXdvrZL9FgJAuKIHj6QKZHJmxir2bG/5WZf3gYx51m7SRPgUo2/rOp0NK5yE1uarCwcRXe1DH/DbImKX/xcxD/oAqstLr4/f26wmZ1AoN+11DFgKzFwuomnEgL8LYqRziJfIEaa8GFYBsG7Omoslu6gg7y+/zvg2dqNvO4BW+qJ4fsLk9Ooz7tu2USvTSAy6OAV04w8a5Hxj+/Rta4Uv2KMD0CQRb4ZtrTJiNML2LrBeKW4xe3Yj524z1w6I7RLxp0yv6HVYiSDZH08qd+YgiH5kp8BpQrfRnLLXLEq9bS+OBiLnuQZJLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6MGPSlufF/mbDfMpAx/wXOCT3CqGNZMxEz3X9MH/2EE=;
 b=HkhTIadpt5Ebut+fWv+97z/KmbHzibZVSthGnRrdezx4hzMVN3m64XKeMlyhX8Bcn4T+prVRYaZ96dPf2Qj73qR7lOjlyJbVBiuVr1pAWAuVoFnP7zyLoJ7vku8obZGxkUkyJi55n0jt60gG1aLTEytVzHMh65uDS6jCu/271n8=
Received: from BY5PR20CA0012.namprd20.prod.outlook.com (2603:10b6:a03:1f4::25)
 by MN2PR12MB4285.namprd12.prod.outlook.com (2603:10b6:208:1d7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.30; Mon, 4 Sep
 2023 09:54:01 +0000
Received: from CO1PEPF000042AE.namprd03.prod.outlook.com
 (2603:10b6:a03:1f4:cafe::8e) by BY5PR20CA0012.outlook.office365.com
 (2603:10b6:a03:1f4::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.32 via Frontend
 Transport; Mon, 4 Sep 2023 09:54:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000042AE.mail.protection.outlook.com (10.167.243.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6768.25 via Frontend Transport; Mon, 4 Sep 2023 09:54:00 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 4 Sep
 2023 04:52:45 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <linux-doc@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
        <x86@kernel.org>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <bp@alien8.de>, <santosh.shukla@amd.com>, <ravi.bangoria@amd.com>,
        <thomas.lendacky@amd.com>, <nikunj@amd.com>,
        <manali.shukla@amd.com>
Subject: [PATCH 03/13] KVM: x86: Add emulation support for Extented LVT registers
Date:   Mon, 4 Sep 2023 09:53:37 +0000
Message-ID: <20230904095347.14994-4-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230904095347.14994-1-manali.shukla@amd.com>
References: <20230904095347.14994-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AE:EE_|MN2PR12MB4285:EE_
X-MS-Office365-Filtering-Correlation-Id: bb36c809-7e20-4228-cef4-08dbad2cdd3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ygNV5zyoms8Mu9OeEEwzqTIDJkU3U7nNWT6a2D1aoFwYxy7ki8tknbIZsix8gKH11SxR4/EdmDuFKki//wnvVMJ2aDGcWyUjSrRPnhAElBSfiLHOo1NVnLNxlcT12lL2j7Ik7PG810fwcVuQD/rZctRui/9OWmekx2UBwlMJowSy264Ar8WoXNAnMFSuYSrn6km1dPZUKAfLHC1MgYp0BENCybNLwxWnZ/Hg8vv7p6FZNTDq5cSR4T2hEaypthDrSjDD7BtpoFnFCNtpqHaJPEevMs6VjV9eTXM9enJfF75Oi4QU8Ha7qkAIVkW31UQ371k8DJUViCw2c412DpwW/AAEcAQnnXAild8q3p6dCFI/FPR23w181LFY6VwePUxJFcZ9XCEk0KSaNzYu6YMovKG1LYiP6bXHmjofBvjWfa/3BAEubmsowsNfJ7Z0RvNN8qGZ3jAvebg9I/eJtbYmdhjnaLnBtYv43JmAMX2YjDxp8uEVAkr/QwwXOTw5gL7DWQEnJjux8fmO2Wg/9K6bSak345d6kPKXtz+71DqKtcudKW+IxBvHHvMR1uJ3b46lpKz+sWtXOky3Ke4LLhPd3sd6hM62vThUKI1etGlN1VRwHgrX7OCITywF+3ri22N+sphlS1tXMXxWHHzRCY41lZphMNUpjExh5KNoj2TT8qBEcQU704TyemuC8230AEpEnUXTBOONWcvqN5yErKh/tQSRggP6lnEFnZfFpSr7YHtWR5QCH1wKEQsczFhWLSBoLBVZAtDfrt8mY60iLMeqNQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199024)(186009)(1800799009)(82310400011)(36840700001)(46966006)(40470700004)(16526019)(26005)(44832011)(426003)(336012)(40480700001)(6666004)(8936002)(8676002)(4326008)(36860700001)(47076005)(83380400001)(5660300002)(2616005)(1076003)(7696005)(41300700001)(40460700003)(110136005)(70586007)(478600001)(54906003)(70206006)(86362001)(316002)(356005)(36756003)(2906002)(966005)(82740400003)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 09:54:00.3163
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb36c809-7e20-4228-cef4-08dbad2cdd3d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF000042AE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4285
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Santosh Shukla <santosh.shukla@amd.com>

The local interrupts are extended to include more LVT registers in
order to allow additional interrupt sources, like Instruction Based
Sampling (IBS) and many more.

Currently there are four additional LVT registers defined and they are
located at APIC offsets 500h-530h.

AMD IBS driver is designed to use EXTLVT (Extended interrupt local
vector table) by default for driver initialization.

Extended LVT registers are required to be emulated to initialize the
guest IBS driver successfully.

Please refer to Section 16.4.5 in AMD Programmer's Manual Volume 2 at
https://bugzilla.kernel.org/attachment.cgi?id=304653 for more details
on EXTLVT.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
Co-developed-by: Manali Shukla <manali.shukla@amd.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/include/asm/apicdef.h | 14 ++++++++
 arch/x86/kvm/lapic.c           | 66 ++++++++++++++++++++++++++++++++--
 arch/x86/kvm/lapic.h           |  1 +
 arch/x86/kvm/svm/avic.c        |  4 +++
 4 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 4b125e5b3187..ac50919d10be 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -139,6 +139,20 @@
 #define		APIC_EILVT_MSG_EXT	0x7
 #define		APIC_EILVT_MASKED	(1 << 16)
 
+/*
+ * Initialize extended APIC registers to the default value when guest is started
+ * and EXTAPIC feature is enabled on the guest.
+ *
+ * APIC_EFEAT is a read only Extended APIC feature register, whose default value
+ * is 0x00040007.
+ *
+ * APIC_ECTRL is a read-write Extended APIC control register, whose default value
+ * is 0x0.
+ */
+
+#define		APIC_EFEAT_DEFAULT	0x00040007
+#define		APIC_ECTRL_DEFAULT	0x0
+
 #define APIC_BASE (fix_to_virt(FIX_APIC_BASE))
 #define APIC_BASE_MSR		0x800
 #define APIC_X2APIC_ID_MSR	0x802
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 7c1bd8594f1b..88985c481fe8 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1599,9 +1599,13 @@ static inline struct kvm_lapic *to_lapic(struct kvm_io_device *dev)
 }
 
 #define APIC_REG_MASK(reg)	(1ull << ((reg) >> 4))
+#define APIC_REG_EXT_MASK(reg)	(1ull << (((reg) >> 4) - 0x40))
 #define APIC_REGS_MASK(first, count) \
 	(APIC_REG_MASK(first) * ((1ull << (count)) - 1))
 
+#define APIC_LAST_REG_OFFSET		0x3f0
+#define APIC_EXT_LAST_REG_OFFSET	0x530
+
 u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic)
 {
 	/* Leave bits '0' for reserved and write-only registers. */
@@ -1643,6 +1647,8 @@ EXPORT_SYMBOL_GPL(kvm_lapic_readable_reg_mask);
 static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 			      void *data)
 {
+	u64 valid_reg_ext_mask = 0;
+	unsigned int last_reg = APIC_LAST_REG_OFFSET;
 	unsigned char alignment = offset & 0xf;
 	u32 result;
 
@@ -1652,13 +1658,44 @@ static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 	 */
 	WARN_ON_ONCE(apic_x2apic_mode(apic) && offset == APIC_ICR);
 
+	/*
+	 * The local interrupts are extended to include LVT registers to allow
+	 * additional interrupt sources when the EXTAPIC feature bit is enabled.
+	 * The Extended Interrupt LVT registers are located at APIC offsets 400-530h.
+	 */
+	if (guest_cpuid_has(apic->vcpu, X86_FEATURE_EXTAPIC)) {
+		valid_reg_ext_mask =
+			APIC_REG_EXT_MASK(APIC_EFEAT) |
+			APIC_REG_EXT_MASK(APIC_ECTRL) |
+			APIC_REG_EXT_MASK(APIC_EILVTn(0)) |
+			APIC_REG_EXT_MASK(APIC_EILVTn(1)) |
+			APIC_REG_EXT_MASK(APIC_EILVTn(2)) |
+			APIC_REG_EXT_MASK(APIC_EILVTn(3));
+		last_reg = APIC_EXT_LAST_REG_OFFSET;
+	}
+
 	if (alignment + len > 4)
 		return 1;
 
-	if (offset > 0x3f0 ||
-	    !(kvm_lapic_readable_reg_mask(apic) & APIC_REG_MASK(offset)))
+	if (offset > last_reg)
 		return 1;
 
+	switch (offset) {
+	/*
+	 * Section 16.3.2 in the AMD Programmer's Manual Volume 2 states:
+	 * "APIC registers are aligned to 16-byte offsets and must be accessed
+	 * using naturally-aligned DWORD size read and writes."
+	 */
+	case KVM_APIC_REG_SIZE ... KVM_APIC_EXT_REG_SIZE - 16:
+		if (!(valid_reg_ext_mask & APIC_REG_EXT_MASK(offset)))
+			return 1;
+		break;
+	default:
+		if (!(kvm_lapic_readable_reg_mask(apic) & APIC_REG_MASK(offset)))
+			return 1;
+
+	}
+
 	result = __apic_read(apic, offset & ~0xf);
 
 	trace_kvm_apic_read(offset, result);
@@ -2386,6 +2423,12 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		else
 			kvm_apic_send_ipi(apic, APIC_DEST_SELF | val, 0);
 		break;
+	case APIC_EILVTn(0):
+	case APIC_EILVTn(1):
+	case APIC_EILVTn(2):
+	case APIC_EILVTn(3):
+		kvm_lapic_set_reg(apic, reg, val);
+		break;
 	default:
 		ret = 1;
 		break;
@@ -2664,6 +2707,25 @@ void kvm_inhibit_apic_access_page(struct kvm_vcpu *vcpu)
 	kvm_vcpu_srcu_read_lock(vcpu);
 }
 
+/*
+ * Initialize extended APIC registers to the default value when guest is
+ * started. The extended APIC registers should only be initialized when the
+ * EXTAPIC feature is enabled on the guest.
+ */
+void kvm_apic_init_eilvt_regs(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+	int i;
+
+	if (guest_cpuid_has(vcpu, X86_FEATURE_EXTAPIC)) {
+		kvm_lapic_set_reg(apic, APIC_EFEAT, APIC_EFEAT_DEFAULT);
+		kvm_lapic_set_reg(apic, APIC_ECTRL, APIC_ECTRL_DEFAULT);
+		for (i = 0; i < APIC_EILVT_NR_MAX; i++)
+			kvm_lapic_set_reg(apic, APIC_EILVTn(i), APIC_EILVT_MASKED);
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_apic_init_eilvt_regs);
+
 void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index ad6c48938733..b0c7393cd6af 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -93,6 +93,7 @@ int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu);
 int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu);
 int kvm_apic_accept_events(struct kvm_vcpu *vcpu);
 void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event);
+void kvm_apic_init_eilvt_regs(struct kvm_vcpu *vcpu);
 u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
 void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index cfc8ab773025..081075674b1d 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -679,6 +679,10 @@ static bool is_avic_unaccelerated_access_trap(u32 offset)
 	case APIC_LVTERR:
 	case APIC_TMICT:
 	case APIC_TDCR:
+	case APIC_EILVTn(0):
+	case APIC_EILVTn(1):
+	case APIC_EILVTn(2):
+	case APIC_EILVTn(3):
 		ret = true;
 		break;
 	default:
-- 
2.34.1

