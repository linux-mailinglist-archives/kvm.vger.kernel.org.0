Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B95E44BE78
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 11:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhKJKVb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 05:21:31 -0500
Received: from mail-co1nam11on2073.outbound.protection.outlook.com ([40.107.220.73]:61701
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231209AbhKJKV1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 05:21:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UW9MugQ+GUYdfdjf5yYIJGfpPwihrQy43QZ49XOTtAXZYmg6Sj8FVDyRCOf10l7Zuj0S0HmNU6vk+JLl6ooNrD6USWUk67SSP8Z0/MWDW/Yls3tdQFabwCBCWGavonNM7tFeajH/dmaJaO1RaA3xbIPzBU7DErIGIH2gpWLZtSFsWk9iuesBgLwCDk5dRDWXFJ1YEZblFAHYda64a1z3wQmwIjZ+/G4Pz+EE1bUpvattFhsL3aQyzKgpjSjlOYWtaXstwZVfOjv0bYk9Mwc8ZAiEXKFO1vbVnE+pGdfFNvxUg6Y6K1LcR97hLqphnTZzpT67MuLUswmS37UonTSuvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sN3KTU2T3+BSLdubD5iCle52NOu4cmjSf5Z5AGhMixQ=;
 b=DDHF8RwDvN/fpZobLSAtuc0eC1Sigyvjce4Kiu4xo3EgoEYK1QCbo2KPHqKBjG5dj4sXiA8af03FdpdDk7WMKyyLrhltAViGxh7QbmuH+asDoJQcGhPHlJjm3k5QlBf9FPdDIwh2VuYn+jygWNID+UQWSG6dj5yw6K/FoeqvoO+/81jlxuT7SDBNnuZy97putpmPxtBMouYR5SV9uL2NYeERt+nLP+cmj5UBl3i8gGi7x40FmkIjwge5mSdAiLPcZsJcTU/EaLPqa3tGtjgXTdsPLODrUrEQFXjDZ8qepOxiKEIaYMk0qM+41E/znD7rlk02GImEn23wPS9rvUq40Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sN3KTU2T3+BSLdubD5iCle52NOu4cmjSf5Z5AGhMixQ=;
 b=qGU7TzOXDAxHRWUGgZi8kINTTz6cQmbD5dUtsF8Mr/7qPvzsacN3FqKs7m6oawcGbxiMMafbbs3OPERbMqD/dAOxAyccl4HwgqVEXiFhjmZwo3EwCSWY3ai0XpofgpG0lLyxtEK0+haVB+nQjhfrsEzYHb52iUVouvlGc5O/zd0=
Received: from DM6PR14CA0043.namprd14.prod.outlook.com (2603:10b6:5:18f::20)
 by SJ0PR12MB5405.namprd12.prod.outlook.com (2603:10b6:a03:3af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Wed, 10 Nov
 2021 10:18:36 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:18f:cafe::ae) by DM6PR14CA0043.outlook.office365.com
 (2603:10b6:5:18f::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend
 Transport; Wed, 10 Nov 2021 10:18:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4690.15 via Frontend Transport; Wed, 10 Nov 2021 10:18:36 +0000
Received: from sos-ubuntu2004-quartz01.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 10 Nov 2021 04:18:35 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <pbonzini@redhat.com>, <joro@8bytes.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <peterz@infradead.org>,
        <hpa@zytor.com>, <thomas.lendacky@amd.com>, <jon.grimm@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 2/2] KVM: SVM: Extend host physical APIC ID field to support more than 8-bit
Date:   Wed, 10 Nov 2021 04:18:05 -0600
Message-ID: <20211110101805.16343-3-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211110101805.16343-1-suravee.suthikulpanit@amd.com>
References: <20211110101805.16343-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b4dfdbd-ea52-48be-b4bc-08d9a4337523
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5405:
X-Microsoft-Antispam-PRVS: <SJ0PR12MB540503C30710DF8A127C4E12F3939@SJ0PR12MB5405.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 99Zz3j+GREiMM8R+5+red5bd+hQQSeClHVRk29uUK4nknsZE0cLbSvZe4qXe5vbsFl17O6ydfPZUry/Dtv2aFkAByuPCwN5Uq2EckcsSlzlYRav2fXriEQO+08THMcQJL4vcUmKB0RBMRyTPfTJEogT/PI/VHDKaVZWO2YodkG30YkfFaoyXIP17mbq1bYDOqxRNycLqgLT5Vj+4p0jHtJiispCQzntNA9vwPqiW1tBrk0Md5t/iDeFI690HyU6g10t6LBy73+Vf9q+ld2Go2Wf3KBUOrt0oyPogfg9W/3Dz5Fl17vVIQVs3G1m1w9S/kIu0xUFT0HGPNlfYjmmj2lOtBEgxdv7aKXbDGRJt+jUPH+thjWNrXFtbtWeL4sf1Cjczu8ErpbO29td9FT0Q03JDBHFIEBqmpuvzLI6a81/kzxv61sgiaCoGGsZ90UaGKlL4JTA/J2uHGVWpk1sNESe6NB0mx4FrOdudKMzMtT9cV91FE1Z7ZOzRYCnetVQqcvf+vCPkrUvOkTydLlDIZlLvawl45brtsXmipA4dn4RVuuZWUU/XAdpWYLdQ8i+hoveYi7hX9uX7q4CuxXs3okP/NCzJvydi/lG3rRpKeu56Fd+wRPLtbtIoD0Iko4DWkiwd+UrYG/6/VjjF4OOiBpG7w6LR7llcxgd91vh7gq1cUYcZKtae4Bhn6SpgF4puqaHKZ+tSHSdPc+ooAsHC8/Y6hpflvv4vSOQD/RchuXM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(356005)(186003)(70586007)(1076003)(5660300002)(16526019)(83380400001)(26005)(86362001)(36860700001)(47076005)(2906002)(8936002)(44832011)(2616005)(70206006)(36756003)(316002)(7416002)(7696005)(82310400003)(336012)(426003)(8676002)(54906003)(6666004)(110136005)(81166007)(4326008)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2021 10:18:36.4198
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b4dfdbd-ea52-48be-b4bc-08d9a4337523
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5405
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The AVIC physical APIC ID table entry contains the host physical
APIC ID field, which the hardware uses to keep track of where each
vCPU is running. Originally, the field is an 8-bit value, which can
only support physical APIC ID up to 255.

To support system with larger APIC ID, the AVIC hardware extends
this field to support up to the largest possible physical APIC ID
available on the system.

Therefore, replace the hard-coded mask value with the value
calculated from the maximum possible physical APIC ID in the system.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

---
 arch/x86/kvm/svm/avic.c | 53 ++++++++++++++++++++++++++++++++++-------
 arch/x86/kvm/svm/svm.c  |  6 +++++
 arch/x86/kvm/svm/svm.h  |  2 +-
 3 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 8052d92069e0..0b073f63dabd 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -19,6 +19,7 @@
 #include <linux/amd-iommu.h>
 #include <linux/kvm_host.h>
 
+#include <asm/apic.h>
 #include <asm/irq_remapping.h>
 
 #include "trace.h"
@@ -63,6 +64,7 @@
 static DEFINE_HASHTABLE(svm_vm_data_hash, SVM_VM_DATA_HASH_BITS);
 static u32 next_vm_id = 0;
 static bool next_vm_id_wrapped = 0;
+static u64 avic_host_physical_id_mask;
 static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
 
 /*
@@ -133,6 +135,46 @@ void avic_vm_destroy(struct kvm *kvm)
 	spin_unlock_irqrestore(&svm_vm_data_hash_lock, flags);
 }
 
+int avic_init_host_physical_apicid_mask(void)
+{
+	unsigned int eax, ebx, ecx, edx;
+	u32 level_type, core_mask_width, max_phys_mask_width;
+
+	/*
+	 * Calculate minimum number of bits required to represent
+	 * host physical APIC ID for each processor (level type 2)
+	 * using CPUID leaf 0xb sub-leaf 0x1.
+	 */
+	cpuid_count(0xb, 0x1, &eax, &ebx, &ecx, &edx);
+	level_type = (ecx >> 8) & 0xff;
+
+	/*
+	 * If level-type 2 (i.e. processor type) not available,
+	 * or host is in xAPIC mode, default to only 8-bit mask.
+	 */
+	if (level_type != 2 || !x2apic_mode) {
+		avic_host_physical_id_mask = 0xffULL;
+		goto out;
+	}
+
+	core_mask_width = eax & 0xF;
+
+	max_phys_mask_width = get_count_order(apic_get_max_phys_apicid());
+
+	/*
+	 * Sanity check to ensure core_mask_width for a processor does not
+	 * exceed the calculated mask.
+	 */
+	if (WARN_ON(core_mask_width > max_phys_mask_width))
+		return -EINVAL;
+
+	avic_host_physical_id_mask = BIT(max_phys_mask_width) - 1;
+out:
+	pr_debug("Using AVIC host physical APIC ID mask %#0llx\n",
+		 avic_host_physical_id_mask);
+	return 0;
+}
+
 int avic_vm_init(struct kvm *kvm)
 {
 	unsigned long flags;
@@ -943,22 +985,17 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	u64 entry;
-	/* ID = 0xff (broadcast), ID > 0xff (reserved) */
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	/*
-	 * Since the host physical APIC id is 8 bits,
-	 * we can support host APIC ID upto 255.
-	 */
-	if (WARN_ON(h_physical_id > AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
+	if (WARN_ON(h_physical_id > avic_host_physical_id_mask))
 		return;
 
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
 	WARN_ON(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 
-	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
-	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
+	entry &= ~avic_host_physical_id_mask;
+	entry |= h_physical_id;
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 	if (svm->avic_is_running)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 989685098b3e..0b066bb5149d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1031,6 +1031,12 @@ static __init int svm_hardware_setup(void)
 			nrips = false;
 	}
 
+	if (avic) {
+		r = avic_init_host_physical_apicid_mask();
+		if (r)
+			avic = false;
+	}
+
 	enable_apicv = avic = avic && npt_enabled && boot_cpu_has(X86_FEATURE_AVIC);
 
 	if (enable_apicv) {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5d30db599e10..e215092d0411 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -497,7 +497,6 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 #define AVIC_LOGICAL_ID_ENTRY_VALID_BIT			31
 #define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		(1 << 31)
 
-#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	(0xFFULL)
 #define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	(0xFFFFFFFFFFULL << 12)
 #define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		(1ULL << 62)
 #define AVIC_PHYSICAL_ID_ENTRY_VALID_MASK		(1ULL << 63)
@@ -525,6 +524,7 @@ int avic_init_vcpu(struct vcpu_svm *svm);
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void avic_vcpu_put(struct kvm_vcpu *vcpu);
 void avic_post_state_restore(struct kvm_vcpu *vcpu);
+int avic_init_host_physical_apicid_mask(void);
 void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
 bool svm_check_apicv_inhibit_reasons(ulong bit);
-- 
2.25.1

