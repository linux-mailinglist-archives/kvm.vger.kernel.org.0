Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E3C4F550E
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 07:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379591AbiDFF0Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 01:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450695AbiDFBQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 21:16:47 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2063.outbound.protection.outlook.com [40.107.95.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE0C4FC65;
        Tue,  5 Apr 2022 16:09:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jEKsXYSLfDxiNZk0NFB9sOq7+n0mpgJgn5JGUNn0udBEodV7yf5xXqwXapSCnwSYO48GIi+DBHIeNFonv/+r+qulAQc2owqt1he6W9O/lmvW8OKqG6cHqbw5dccxMnazegQXXATlpU4HtIcG9oeJz23gUdMQ1k6snfkax7/Ox73CFvhwWizZqHQ2CXf5P2DKardz1zjeZD7cZHyiMW0RykHLXeQSZg8f+77Ncle6IKJei8uYCWs60Md+46jC3+DD2vfICwhaSFPj0TgN2HSqAzKun1rYmSjZy6ARhBfjHgG1SQ53WbilfYxZBKhohwjx/o1W9KZ0VtXvzycCGgvibw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q0h1Sd5Uytsq4DgLBMUXW3SofQZck62aB+61gnxfgRY=;
 b=ff+QFVREOHdGuvA2agTUZPIPMHS4He2UKNc5mNvtB0K8Y4m+rM758DkYoYpgD9gG6tG+rEW2P6OgIVeTMufp1dZvJNz3Nloc+oOZaJH2yulEO/MevfftOh3mpVPC07JLEZnarIlBowWUIDqrU+PUdRt5nIUk7sHxTfuWdlHCZ+PSNa0ymM+50i+Isapsp8FdLa2RyIpg/rGVCHrkoRNu/WRkdmUl+PB35owhN+CEC+QOPl9aIUCzaaJLKvN7+IDT/cONUR3kbhDoj6sVWfQY4MmdxMKlL5LfO74H0EEsyESoj7/xUr4bHVFPd4ozOGs2t3IvbBNuCinK9JwiGZgBSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0h1Sd5Uytsq4DgLBMUXW3SofQZck62aB+61gnxfgRY=;
 b=ym7oFHOpNvRKusSjL+R+KAKLNNjsgjwCuHjQE42sybVceGiG8dgso2s45f0HOu64/aSb8ZUQa447r0f/LeeV35RdStSzHXViLrgzLniQzIHniG4y6cvlNPmfFSFWoy6RzSW+4NYNaZEbO6qVE2YfhTxmD+H0CQvarAA8wFKdvGY=
Received: from MW4PR04CA0079.namprd04.prod.outlook.com (2603:10b6:303:6b::24)
 by MN2PR12MB4159.namprd12.prod.outlook.com (2603:10b6:208:1da::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 23:09:26 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::3f) by MW4PR04CA0079.outlook.office365.com
 (2603:10b6:303:6b::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31 via Frontend
 Transport; Tue, 5 Apr 2022 23:09:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Tue, 5 Apr 2022 23:09:26 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 5 Apr
 2022 18:09:19 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <joro@8bytes.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <peterz@infradead.org>, <hpa@zytor.com>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 03/12] KVM: SVM: Detect X2APIC virtualization (x2AVIC) support
Date:   Tue, 5 Apr 2022 18:08:46 -0500
Message-ID: <20220405230855.15376-4-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220405230855.15376-1-suravee.suthikulpanit@amd.com>
References: <20220405230855.15376-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9be89e64-fffb-4fc7-4824-08da175954b0
X-MS-TrafficTypeDiagnostic: MN2PR12MB4159:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB41593D7AD4E5A64BA2C9C6D8F3E49@MN2PR12MB4159.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PT808s8j5E4cOk6btVHeW6NQ3ydjM1S0hgYByV1jvGxx21SL2LJAL7rqZCx1h9SCNiguW3no9RFAeYZ0waO5n43vD8/M+lsSpY7GbePcQ7nUNPtj4vzhhblrTwW6HbH4q9RUWWTuHvsrxjYpxF6hpxSpu6Jl1mZpzCXv9KOM8XAgl21sMvNJLIaxQf14+wBybO8E420W9oS1Jb3JvZmAJ6E25PzJMtHixy+WBJNhPFi5Iln/QGPTEbY71ySGS8hIugdVmWNu8aK8zw+GkOlysdHnvYPcQrfJlBnjvXh3ZsA1X9U3lblDTtgcyLJ33jrG/wBaUl7aDdyDmMEU+zRI4H3x23fwE7z/dKBiUjTx02Jpen6iLKcbsgEqTmS503af4RfipXpgsoLXzylqzX5x1+/ZKBz+r1Yj8WuzE2uRFBnDbmYqfSzcP9QdpvOXdS6zHys0cJ4t1P/UZ3Y6pMrWygqvhEIgVb/zaa3+9rJ9zg33yTvpPY1YMiJk0s+xaubFyiS65yTBW0asAKgL9A3N0r4D9oEvaSw1SEfhlGkG23ZLiu2VkOIoSUieUUr0YPPgtNCDP+a+Gudi0aOl/APA6P7n30qEFjNM+pVC6B/+Xil3wsKXmZOYUTk9ogwhmzYHHwpfvN/tIrIPoklvNZMqDtrKbV8b8e1oiHftGs3NUriR3FHwE5sNIFjxqKZ6Ah9HcXEwgvj2rkRoX+cilbqQhpf0opi28dUXH+8CqRjmUGPB8vManKpchUa1rgLErQhb
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(16526019)(186003)(426003)(83380400001)(81166007)(47076005)(356005)(82310400005)(86362001)(36860700001)(40460700003)(26005)(336012)(2906002)(6666004)(54906003)(2616005)(508600001)(4326008)(70206006)(8676002)(70586007)(110136005)(316002)(7696005)(44832011)(7416002)(5660300002)(36756003)(8936002)(1076003)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 23:09:26.4213
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9be89e64-fffb-4fc7-4824-08da175954b0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4159
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add CPUID check for the x2APIC virtualization (x2AVIC) feature.
If available, the SVM driver can support both AVIC and x2AVIC modes
when load the kvm_amd driver with avic=1. The operating mode will be
determined at runtime depending on the guest APIC mode.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/svm.h |  3 +++
 arch/x86/kvm/svm/avic.c    | 34 ++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c     |  8 ++------
 arch/x86/kvm/svm/svm.h     |  1 +
 4 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 7eb2df5417fb..7a7a2297165b 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -195,6 +195,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define AVIC_ENABLE_SHIFT 31
 #define AVIC_ENABLE_MASK (1 << AVIC_ENABLE_SHIFT)
 
+#define X2APIC_MODE_SHIFT 30
+#define X2APIC_MODE_MASK (1 << X2APIC_MODE_SHIFT)
+
 #define LBR_CTL_ENABLE_MASK BIT_ULL(0)
 #define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
 
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 70a8b67ae800..3dd345ec3345 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -40,6 +40,12 @@
 #define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VCPU_ID_BITS) & AVIC_VM_ID_MASK)
 #define AVIC_GATAG_TO_VCPUID(x)		(x & AVIC_VCPU_ID_MASK)
 
+enum avic_modes {
+	AVIC_MODE_NONE = 0,
+	AVIC_MODE_X1,
+	AVIC_MODE_X2,
+};
+
 /* Note:
  * This hash table is used to map VM_ID to a struct kvm_svm,
  * when handling AMD IOMMU GALOG notification to schedule in
@@ -50,6 +56,7 @@ static DEFINE_HASHTABLE(svm_vm_data_hash, SVM_VM_DATA_HASH_BITS);
 static u32 next_vm_id = 0;
 static bool next_vm_id_wrapped = 0;
 static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
+static enum avic_modes avic_mode;
 
 /*
  * This is a wrapper of struct amd_iommu_ir_data.
@@ -1018,3 +1025,30 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
 	put_cpu();
 }
+
+/*
+ * Note:
+ * - The module param avic enable both xAPIC and x2APIC mode.
+ * - Hypervisor can support both xAVIC and x2AVIC in the same guest.
+ * - The mode can be switched at run-time.
+ */
+bool avic_hardware_setup(struct kvm_x86_ops *x86_ops)
+{
+	if (!npt_enabled)
+		return false;
+
+	if (boot_cpu_has(X86_FEATURE_AVIC)) {
+		avic_mode = AVIC_MODE_X1;
+		pr_info("AVIC enabled\n");
+	}
+
+	if (boot_cpu_has(X86_FEATURE_X2AVIC)) {
+		avic_mode = AVIC_MODE_X2;
+		pr_info("x2AVIC enabled\n");
+	}
+
+	if (avic_mode != AVIC_MODE_NONE)
+		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
+
+	return !!avic_mode;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fd3a00c892c7..bbdc16c4b6d7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4832,13 +4832,9 @@ static __init int svm_hardware_setup(void)
 			nrips = false;
 	}
 
-	enable_apicv = avic = avic && npt_enabled && boot_cpu_has(X86_FEATURE_AVIC);
+	enable_apicv = avic = avic && avic_hardware_setup(&svm_x86_ops);
 
-	if (enable_apicv) {
-		pr_info("AVIC enabled\n");
-
-		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
-	} else {
+	if (!enable_apicv) {
 		svm_x86_ops.vcpu_blocking = NULL;
 		svm_x86_ops.vcpu_unblocking = NULL;
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index fa98d6844728..b53c83a44ec2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -558,6 +558,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 
 /* avic.c */
 
+bool avic_hardware_setup(struct kvm_x86_ops *ops);
 int avic_ga_log_notifier(u32 ga_tag);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);
-- 
2.25.1

