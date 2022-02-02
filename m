Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9152A4A6ACE
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 05:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244041AbiBBENm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 23:13:42 -0500
Received: from mail-bn8nam12on2085.outbound.protection.outlook.com ([40.107.237.85]:44129
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244284AbiBBENj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 23:13:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PIfFjswjtWYs1gU9SEx9JDG5egB5+bgBNciurJVaSCDjTqW+1IKV/479zVThca3qkeftCJi5G4KSLPh7tQ0RA2O5hkawhKwQcIzh00NxwGe4I2Of8StlA2QL58kgDLYhrvS1VYY+QN1mOloF7O0oEZzZoEBBLvvBK1CenFLtrI4bmmZgcZNRfBwMsWcMEQ+3HvqnjzrViOVR7rZEz3uGbWlxLR8VRiKDu/QivwfgkHBfmPCdqg4C55b2qDAwtHrCsldaN3dzwsNlYQgdNDNJLcP9YMVsPJttaX6OmNTnpND5JF58W+vMViLVleiaYZhKo2DSs+0Ijbpnf+jwREX1Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jQhHVcB3XSF5DeZCvqLESGm6Wktrl8qqMwb0pA1Zt0s=;
 b=bKLyYlZGamr1j/0nJSibcpcHtB1XeWaTGdJmNqFlgnWxPUEVh+blNXt4mD+oLtPNnw4D+xKBnA1aYe95Yb3Hx/+WKdsA9Fvo2344BAVgohhDhDYKQzG5hbcQTKU/4iVTVOnVTBuRLKt+6UkOM8vru85fXJVY3CcarMJFA1HQ+pxnoqA1n8q8wkWKjs+1ao2DZpxIGGpQGscj6NCaftriEgaxOPF23+xMCOQUubUD8ZRsVG69fMEGGsK81F3c2Qc/icij7RAQfPLlBGxXd0H27pCZ1hx23EthtsQo7ZLGycG2uQtNvuxHBHrpAuRdHXnoGEXSeArIChjZ7M3MdPVT4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jQhHVcB3XSF5DeZCvqLESGm6Wktrl8qqMwb0pA1Zt0s=;
 b=TeJEPF1OG3HbZ7YgDHrZ1qwgjTlrGYVDF5vsm3pqAxkx6OemUh8F80oZlSjIRXOZ1Q1hYeZPLYg5wEIzEisZI2DYDrwQjLuW/B7hz2pmrmsCNEVztVdJMDgK13ipHesyLZTFuPX0ZxtzwK4F4MFW6i5bF1lMduZoAuMOsSbhn0U=
Received: from DM6PR02CA0152.namprd02.prod.outlook.com (2603:10b6:5:332::19)
 by BL0PR12MB2436.namprd12.prod.outlook.com (2603:10b6:207:42::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Wed, 2 Feb
 2022 04:13:34 +0000
Received: from DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::6c) by DM6PR02CA0152.outlook.office365.com
 (2603:10b6:5:332::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15 via Frontend
 Transport; Wed, 2 Feb 2022 04:13:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT027.mail.protection.outlook.com (10.13.172.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4951.12 via Frontend Transport; Wed, 2 Feb 2022 04:13:33 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 1 Feb
 2022 22:13:31 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <seanjc@google.com>, <mlevitsk@redhat.com>, <pbonzini@redhat.com>,
        <joro@8bytes.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <peterz@infradead.org>, <hpa@zytor.com>,
        <jon.grimm@amd.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>
Subject: [PATCH v4 3/3] KVM: SVM: Add support for 12-bit host physical APIC ID
Date:   Tue, 1 Feb 2022 22:11:12 -0600
Message-ID: <20220202041112.273017-4-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220202041112.273017-1-suravee.suthikulpanit@amd.com>
References: <20220202041112.273017-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d104e1c-bcf9-439c-2942-08d9e60260eb
X-MS-TrafficTypeDiagnostic: BL0PR12MB2436:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB243687A8BA3641EA5A8839EBF3279@BL0PR12MB2436.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:883;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /92hMAsgBUDVhqdCdJjHATu81Y2CjoAxUi+lqXH9IkJEbWsWw0XeWqUMEoDwqij6f4MwHSsK1BGQhh0r0u2MZuYPLl44Y7MpkGA/thIhXk0f3rHOA/R60M4RiR/9o+DMp+D22QTpo8dWfuABY4W0ztcD851Qba25wZA72E9jcDoPAMeAazNaow4HgYol3zweY9NCwH/CLA7xVIlCt+QddCbBsYpMafFy8dqBHySdUW3wFjWEI2+XngRb2C8dNyaSdPlTXD6h+iBiGLkwVX+ecqbgyVdT96idGdeELnUrDhvzxeVfhj8LKXyrNUbVuG/x4KzAZ8Oq6WK9/GGb76w0N6eeDZmXoNEeq1p/1hV+t+WwDW09JSpnlT8l0evPqJCClJbSD8ORldD6HmkHglnYE38ytyvWI7V653KuM2pxMPvpUZWiHpvlXugtaOGZU8a9wDr6P0DyUXsETGdhUkjvmUcg5b8UgphXSapw9yfCIfYOys88o2iuKtoq3nVlin3+Dv8dxP+nysp0/SiFZRPiVYCQjR1tAyZk1WbLboF/hCTHwzi3Aj4Wr9XsSzxi7ueWtXp+JwicG2ndKTyrFikCg3pxHQiyCVHbtrX4R7lxoVdSw0Qr1LQPX4pyYFsQDb6CqcjN6gScf7FwplkhyZVloOLJNYfJ0gMC6mhPOj7w8URyYJC9HUjSTPILeY5tcpM6YHdAqSsDQ8Avwz0cZOjz3Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(36860700001)(8676002)(8936002)(7696005)(70206006)(6666004)(508600001)(186003)(16526019)(83380400001)(70586007)(4326008)(82310400004)(110136005)(316002)(26005)(54906003)(36756003)(1076003)(426003)(336012)(47076005)(86362001)(2906002)(81166007)(356005)(40460700003)(5660300002)(44832011)(2616005)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 04:13:33.8889
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d104e1c-bcf9-439c-2942-08d9e60260eb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2436
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The AVIC physical APIC ID table entry contains the host physical
APIC ID field, which the hardware uses to keep track of where each
vCPU is running. Originally, the field is an 8-bit value. For system
w/ maximum physical APIC ID larger than 255, AVIC can support
upto 12-bit value.

However, there is no CPUID bit to help determine the AVIC capability
to support 12-bit host physical APIC ID. Therefore, use the maximum
physical APIC ID available on the system to determine the proper
host physical APIC ID mask size.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 33 ++++++++++++++++++++++++---------
 arch/x86/kvm/svm/svm.h  |  1 -
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index f5c6cab42d74..3ca5776348a8 100644
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
+static u16 avic_host_physical_id_mask;
 static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
 
 /*
@@ -133,6 +135,23 @@ void avic_vm_destroy(struct kvm *kvm)
 	spin_unlock_irqrestore(&svm_vm_data_hash_lock, flags);
 }
 
+static void avic_init_host_physical_apicid_mask(void)
+{
+	u32 count = get_count_order(apic_get_max_phys_apicid());
+
+	/*
+	 * Depending on the maximum host physical APIC ID available
+	 * on the system, AVIC can support upto 8-bit or 12-bit host
+	 * physical APIC ID.
+	 */
+	if (count <= 8)
+		avic_host_physical_id_mask = GENMASK(7, 0);
+	else
+		avic_host_physical_id_mask = GENMASK(11, 0);
+	pr_debug("Using AVIC host physical APIC ID mask %#0x\n",
+		 avic_host_physical_id_mask);
+}
+
 int avic_vm_init(struct kvm *kvm)
 {
 	unsigned long flags;
@@ -974,17 +993,12 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	u64 entry;
-	/* ID = 0xff (broadcast), ID > 0xff (reserved) */
-	int h_physical_id = kvm_cpu_get_apicid(cpu);
+	u16 h_physical_id = (u16)kvm_cpu_get_apicid(cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	lockdep_assert_preemption_disabled();
 
-	/*
-	 * Since the host physical APIC id is 8 bits,
-	 * we can support host APIC ID upto 255.
-	 */
-	if (WARN_ON(h_physical_id > AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
+	if (WARN_ON((h_physical_id & avic_host_physical_id_mask) != h_physical_id))
 		return;
 
 	/*
@@ -1000,8 +1014,8 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
 	WARN_ON(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 
-	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
-	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
+	entry &= ~((u64)avic_host_physical_id_mask);
+	entry |= h_physical_id;
 	entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
@@ -1076,6 +1090,7 @@ bool avic_hardware_setup(struct kvm_x86_ops *x86_ops)
 	x86_ops->vcpu_unblocking = avic_vcpu_unblocking,
 
 	pr_info("AVIC enabled\n");
+	avic_init_host_physical_apicid_mask();
 	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
 	return true;
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f2507d11a31a..70c55f20c0f1 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -565,7 +565,6 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 #define AVIC_LOGICAL_ID_ENTRY_VALID_BIT			31
 #define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		(1 << 31)
 
-#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	(0xFFULL)
 #define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	(0xFFFFFFFFFFULL << 12)
 #define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		(1ULL << 62)
 #define AVIC_PHYSICAL_ID_ENTRY_VALID_MASK		(1ULL << 63)
-- 
2.25.1

