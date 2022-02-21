Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 875E44BD3CF
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 03:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245545AbiBUCXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Feb 2022 21:23:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343572AbiBUCXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Feb 2022 21:23:17 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5603C712;
        Sun, 20 Feb 2022 18:22:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2MH/FbAlWB/ubkff6C3OPaM+SJnvjrXUQK/jJoJgb8Sg0QrBXLrGdwUOOLFpz26eZ5FS6cd6j8Hzf4em5+ga5Fe8y8zg7Oc7IfD34n4RX3+zhSYxyvoil0Mtc1S+2JOOuNrhzQHTvkyxLsDkJ/fgyjGVqs9VstFSthViE8bunCFEsG3ZptcTNc2jUAJT0upZgISKY2FAEw8nz+Jjd0y/O7DDgCbBBr9T3U1TwckerlUyK+ajdH00oH1uAP/DuFTGtugKv+HjHZoQ6GOzEbXESg94zJZF63cRfBt2O42FcudZ6i/AqAlheoEBFaydxGoA1sdVQ8zS383keCjUWvphQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dU4z0k3HK7n3HU9iFxEbzj6pL6niYs2Wsujfl8vd27w=;
 b=Z1/wnzf5aRmTfRQT9wABovD9sh1EWU/OuI1CxHqnRdZLxjJpr+dgBVOavz/g4enxJaYl2xIS8luUTo5EtT5QvkrADHKsnKdk2BY2cghMfJbVF+bFgsDipHrILZIUtZcuH8ecMOEUCJ/kD+mJLpv1V0cliQzEHswkAxwNG+C4nCtDK2ak6EfPkHTUCk4uN+whOnBg6CYbaTh/QVjiubJ612FqXNVJCkPQBj9IiqBUwX+7G0ZLxGnbGVxzUqY7Cn9riqR/RLCDg8L4RklyFMvl5eRi0n2yZsXCQcR7o4iSAM+oqLfbyiqvGHO+HzJ9p/uwPJR2Lb5AChb95AWOHYG66A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dU4z0k3HK7n3HU9iFxEbzj6pL6niYs2Wsujfl8vd27w=;
 b=o5WKZEej4gaPxazr27QzbkYIKFdugdgl1qmtA0yP5WIINCoe1IvsEhLMt4LAV3vpB9akQsDGSWKj5ehkTPso5HpAJT/EGlV0Ltzxd6vL9rfLSb/Wg5D4KKe6G6QhtEQDscutcys5QKnfQl8hTkyuyWPDSztd7PrY+RASXcMWL7U=
Received: from MWHPR1401CA0002.namprd14.prod.outlook.com
 (2603:10b6:301:4b::12) by CH0PR12MB5219.namprd12.prod.outlook.com
 (2603:10b6:610:d2::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Mon, 21 Feb
 2022 02:22:53 +0000
Received: from CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4b:cafe::8) by MWHPR1401CA0002.outlook.office365.com
 (2603:10b6:301:4b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14 via Frontend
 Transport; Mon, 21 Feb 2022 02:22:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT037.mail.protection.outlook.com (10.13.174.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4995.15 via Frontend Transport; Mon, 21 Feb 2022 02:22:52 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Sun, 20 Feb
 2022 20:22:48 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <seanjc@google.com>, <joro@8bytes.org>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>
Subject: [RFC PATCH 10/13] KVM: SVM: Adding support for configuring x2APIC MSRs interception
Date:   Sun, 20 Feb 2022 20:19:19 -0600
Message-ID: <20220221021922.733373-11-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 910c40a2-a075-4fb1-113a-08d9f4e1103a
X-MS-TrafficTypeDiagnostic: CH0PR12MB5219:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB521980E7B46E89B3566E5255F33A9@CH0PR12MB5219.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VE3A/esDaH64zGeulunjegWa1IU7V+ONygt9WYTUX87BQ/NsfrEq0PQ+oq3p4buh/rxUVzvjw+ylKpUMW1L0SlkSgJFD+20J8U4zmOL8d2mua+eVVA5rWMLv4pAU3xtXPTyCHjoQQs2n64eO4lCS6wHA8OKmkMV65euV8rD9eIsVQJTBkcsjkr7SzdQAQq8jLFB3fXsw/OMjaCW51moTK50C7yjdX4Fbsj0xCgbgl/vLxz9LE3xd6IoHjG0E/sGH477+llIsu0NZY1b067xTlypown8vOwbdQZ+z2NL0NQlhf84BwJxKLJp8sn7M4Ypegmpn7wAZm55CJICbADv7jMzNwb7zVGQZe+553j71raei04Y38WQstKBr1Qhy6UEV8YUvw9uviRaWKsbeFtygBZ22RVB2+kFDzGW2xskHuhWJmnzO3IIxraOPPpPwHCoJdC3rndKTsE8RL/jejlX8wycsgCveSDL7/xbgQiGUN/fTRPRClqdVtAzbIJrDDIc/ATsNo593jfetL866zFhzaWXCZ52gbJDrJNsU+S49sOiDWT55q85I1iXtp4LsyWCXgqW8JL515BhLWaS6UntXFzCBxk6cOvcdtUbZlF6A1Yw6EZqwM+tNRHbEXXN4qceE/yTzflsiE2apLB+wy0GOfWF0hmflVkhPa6YCSA4GSuVO1FRCnjjy/bqiexosyX2XPcilA/57Y6y4B4x59bytSA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(110136005)(54906003)(1076003)(8936002)(26005)(186003)(16526019)(5660300002)(70586007)(70206006)(83380400001)(4326008)(8676002)(81166007)(356005)(82310400004)(316002)(44832011)(86362001)(336012)(426003)(508600001)(40460700003)(7696005)(36756003)(6666004)(2906002)(36860700001)(2616005)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 02:22:52.4664
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 910c40a2-a075-4fb1-113a-08d9f4e1103a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5219
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When enabling x2APIC virtualization (x2AVIC), the interception of
x2APIC MSRs must be disabled to let the hardware virtualize guest
MSR accesses.

Current implementation keeps track of MSR interception state
for generic MSRs in the svm_direct_access_msrs array.
For x2APIC MSRs, introduce direct_access_x2apic_msrs array.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/svm.c | 67 +++++++++++++++++++++++++++++++-----------
 arch/x86/kvm/svm/svm.h |  7 +++++
 2 files changed, 57 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4e6dc1feeac7..afca26aa1f40 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -89,7 +89,7 @@ static uint64_t osvw_len = 4, osvw_status;
 static DEFINE_PER_CPU(u64, current_tsc_ratio);
 #define TSC_RATIO_DEFAULT	0x0100000000ULL
 
-static const struct svm_direct_access_msrs {
+static struct svm_direct_access_msrs {
 	u32 index;   /* Index of the MSR */
 	bool always; /* True if intercept is initially cleared */
 } direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
@@ -117,6 +117,9 @@ static const struct svm_direct_access_msrs {
 	{ .index = MSR_INVALID,				.always = false },
 };
 
+static struct svm_direct_access_msrs
+direct_access_x2apic_msrs[NUM_DIRECT_ACCESS_X2APIC_MSRS + 1];
+
 /*
  * These 2 parameters are used to config the controls for Pause-Loop Exiting:
  * pause_filter_count: On processors that support Pause filtering(indicated
@@ -609,41 +612,42 @@ static int svm_cpu_init(int cpu)
 
 }
 
-static int direct_access_msr_slot(u32 msr)
+static int direct_access_msr_slot(u32 msr, struct svm_direct_access_msrs *msrs)
 {
 	u32 i;
 
-	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++)
-		if (direct_access_msrs[i].index == msr)
+	for (i = 0; msrs[i].index != MSR_INVALID; i++)
+		if (msrs[i].index == msr)
 			return i;
 
 	return -ENOENT;
 }
 
-static void set_shadow_msr_intercept(struct kvm_vcpu *vcpu, u32 msr, int read,
-				     int write)
+static void set_shadow_msr_intercept(struct kvm_vcpu *vcpu,
+				     struct svm_direct_access_msrs *msrs, u32 msr,
+				     int read, void *read_bits,
+				     int write, void *write_bits)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-	int slot = direct_access_msr_slot(msr);
+	int slot = direct_access_msr_slot(msr, msrs);
 
 	if (slot == -ENOENT)
 		return;
 
 	/* Set the shadow bitmaps to the desired intercept states */
 	if (read)
-		set_bit(slot, svm->shadow_msr_intercept.read);
+		set_bit(slot, read_bits);
 	else
-		clear_bit(slot, svm->shadow_msr_intercept.read);
+		clear_bit(slot, read_bits);
 
 	if (write)
-		set_bit(slot, svm->shadow_msr_intercept.write);
+		set_bit(slot, write_bits);
 	else
-		clear_bit(slot, svm->shadow_msr_intercept.write);
+		clear_bit(slot, write_bits);
 }
 
-static bool valid_msr_intercept(u32 index)
+static bool valid_msr_intercept(u32 index, struct svm_direct_access_msrs *msrs)
 {
-	return direct_access_msr_slot(index) != -ENOENT;
+	return direct_access_msr_slot(index, msrs) != -ENOENT;
 }
 
 static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
@@ -674,9 +678,12 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
 
 	/*
 	 * If this warning triggers extend the direct_access_msrs list at the
-	 * beginning of the file
+	 * beginning of the file. The direct_access_x2apic_msrs is only for
+	 * x2apic MSRs.
 	 */
-	WARN_ON(!valid_msr_intercept(msr));
+	WARN_ON(!valid_msr_intercept(msr, direct_access_msrs) &&
+		(boot_cpu_has(X86_FEATURE_X2AVIC) &&
+		 !valid_msr_intercept(msr, direct_access_x2apic_msrs)));
 
 	/* Enforce non allowed MSRs to trap */
 	if (read && !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ))
@@ -704,7 +711,16 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
 void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
 			  int read, int write)
 {
-	set_shadow_msr_intercept(vcpu, msr, read, write);
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (msr < 0x800 || msr > 0x8ff)
+		set_shadow_msr_intercept(vcpu, direct_access_msrs, msr,
+					 read, svm->shadow_msr_intercept.read,
+					 write, svm->shadow_msr_intercept.write);
+	else
+		set_shadow_msr_intercept(vcpu, direct_access_x2apic_msrs, msr,
+					 read, svm->shadow_x2apic_msr_intercept.read,
+					 write, svm->shadow_x2apic_msr_intercept.write);
 	set_msr_interception_bitmap(vcpu, msrpm, msr, read, write);
 }
 
@@ -786,6 +802,22 @@ static void add_msr_offset(u32 offset)
 	BUG();
 }
 
+static void init_direct_access_x2apic_msrs(void)
+{
+	int i;
+
+	/* Initialize x2APIC direct_access_x2apic_msrs entries */
+	for (i = 0; i < NUM_DIRECT_ACCESS_X2APIC_MSRS; i++) {
+		direct_access_x2apic_msrs[i].index = boot_cpu_has(X86_FEATURE_X2AVIC) ?
+						  (0x800 + i) : MSR_INVALID;
+		direct_access_x2apic_msrs[i].always = false;
+	}
+
+	/* Initialize last entry */
+	direct_access_x2apic_msrs[i].index = MSR_INVALID;
+	direct_access_x2apic_msrs[i].always = false;
+}
+
 static void init_msrpm_offsets(void)
 {
 	int i;
@@ -4752,6 +4784,7 @@ static __init int svm_hardware_setup(void)
 	memset(iopm_va, 0xff, PAGE_SIZE * (1 << order));
 	iopm_base = page_to_pfn(iopm_pages) << PAGE_SHIFT;
 
+	init_direct_access_x2apic_msrs();
 	init_msrpm_offsets();
 
 	supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index bfbebb933da2..41514df5107e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -29,6 +29,8 @@
 
 #define MAX_DIRECT_ACCESS_MSRS	20
 #define MSRPM_OFFSETS	16
+#define NUM_DIRECT_ACCESS_X2APIC_MSRS	0x100
+
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
 extern bool intercept_smi;
@@ -242,6 +244,11 @@ struct vcpu_svm {
 		DECLARE_BITMAP(write, MAX_DIRECT_ACCESS_MSRS);
 	} shadow_msr_intercept;
 
+	struct {
+		DECLARE_BITMAP(read, NUM_DIRECT_ACCESS_X2APIC_MSRS);
+		DECLARE_BITMAP(write, NUM_DIRECT_ACCESS_X2APIC_MSRS);
+	} shadow_x2apic_msr_intercept;
+
 	struct vcpu_sev_es_state sev_es;
 
 	bool guest_state_loaded;
-- 
2.25.1

