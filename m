Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9795F4FE086
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 14:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353614AbiDLMlJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 08:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354984AbiDLMir (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 08:38:47 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4577E1F637;
        Tue, 12 Apr 2022 04:59:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rg47KPz1svRCNjzBnLlIs5SNyaMqKlthXS95/AtSUo+uEO+fBMNffLOO4e+KmooNjG/ecsSO89F0RsSWhSKAeHpnmVpP9mAO2g2ewU9rIMgHMKOesRHFrooDECUv2PIO7kSmsN5TWae7XviZW2A1zuz+/6JzxSUaAXHOqSgSd71cPcbIqg7FD93V5a0EbV2OmRzJOfLpHztZ7RQ+MgTaqJZMnWTmMeyK4OTKWUYerk6AsIntgU2HdNMTq72Z7gf8/DQ0Jd5Ft1/DSvtQrhlPJf9IumHdMB9UBv5KrwVRdDyQLKWzaV4Cj6QUv4Yw1rCcuOt/okiMxmxspopDe+80aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OgtqhG2N2EJ/NS3JDTa9ioIpolwfpjBaAq4CuyFgylA=;
 b=X8YJBDsQmekHkzjZpjpGKs+tyTkT5xpa6krUSbbaO90BGS79VuQhGdRoUz/rj6wzdmMeDRjqjV6TNWLUwUt6/xEb4WcfhnXVDxjtN82Yhc3orQfOgher/L5ZX6x62HPyIpqNdLoZbLIFkls2a+OzF5tJs3SNoUQOFtB12C/r++ogN1VR4nMYtNZ0NlU7FMOPOQIa5+hD3H/RtQtRyXwUsS1kJ40w+rw4/JPmWaK+3yGWlxLrxYWAAz4HdZmhiF/H3mIJhfoY8x3Vd3DxY5WSaWbE3aHUFr/Y0J1X03RMczJ4cgcTjAbY+lgL03yHPjCX2I3g8re7Ob6NNMmAWMOCNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OgtqhG2N2EJ/NS3JDTa9ioIpolwfpjBaAq4CuyFgylA=;
 b=lGRv8vosOd9KV453mVzDp2ClSxvAv7KFPucYfVegQsKV0fON2mcliJxSw1xiR5Zt7qq0vrsWeLdXU8UBEj0hPgCiZXx7DRS3ecOMOpkIvN1DUvRkR2o/7Qz6tg65hV0He7k5UAucG0PJ/48YKS/+L7duyKXcWZGIel7c7aw9D7Y=
Received: from BN6PR2001CA0006.namprd20.prod.outlook.com
 (2603:10b6:404:b4::16) by BY5PR12MB4305.namprd12.prod.outlook.com
 (2603:10b6:a03:213::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 11:59:10 +0000
Received: from BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:b4:cafe::b1) by BN6PR2001CA0006.outlook.office365.com
 (2603:10b6:404:b4::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.30 via Frontend
 Transport; Tue, 12 Apr 2022 11:59:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT054.mail.protection.outlook.com (10.13.177.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Tue, 12 Apr 2022 11:59:09 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 12 Apr
 2022 06:59:08 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v2 03/12] KVM: SVM: Detect X2APIC virtualization (x2AVIC) support
Date:   Tue, 12 Apr 2022 06:58:13 -0500
Message-ID: <20220412115822.14351-4-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
References: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a06259b2-2971-45af-616a-08da1c7bda95
X-MS-TrafficTypeDiagnostic: BY5PR12MB4305:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4305D36C377196E7ABC9A1ADF3ED9@BY5PR12MB4305.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XLHxu+VCQuXsGbGJv0n4McfX+nMZPLQE8kwqv2zx4iylOCUMR/SlwTa0T8YHf/MGGc5Myuo57igVJH0UNfAqZqLAPv5ns+YP9HCiSTwCNhGkh7FnFf7RlIhbgXT/BEO3n4o2ZGKuupzIbRcKQq83JBnYZTEH7cIw4Bw5DovXBdaAg9K6fYjEYxP6nN7xju3ENqEZoKOCZfyfF7ksHygECaxNZBa8d3sAEzMEYiKlGCZqx2eqm3rRNoKNggCJJtswmrAF/ZRjT6YIHWDw5nAcsE6kFtIddpGMWGKX6cniPwylRDnkZFRAJsLns3d0HvfC/vz1mpWrZGKeBQkm1RfNtIgMwmwDgXKVUIOUDVFqL2hi7MnBDPuTptNOc3RSABNEXyOZxQAFoB9Nu0cFbeOWz/cyG3Lv+qv/B7IhXm6eASWx6jjdR5XRL2a0E1jYBGwJcXtUGjW5VsAgH0j3f4xQwcimxWWhJ3qx0MJURDxBn7W10IWBSS7g5t8O23Vgly4t5JYgVrFeLfFmEtYWxGpnhs0eSbvkER4mpQaShfCxB61/iUIu5LWVnH7kGTVlgsJv4Kb18fawHy0w2ZQo207l6i+p/VKWTNZxrHqu9ZHbp5HfsIEI0AgdnylJVbmfQUVuL9ikSkxED38qmMRyCfFW9Ceb2jWOSu+N/spoiNt5DlwWYP2j0JZH4Ksc0Po3A7SU5IC7Vox+ujSQLRZTdL92/awGet2qB2mPyWvb77pblD4Jj4re8bZjk8YTI0Fd+//Y
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(16526019)(26005)(508600001)(336012)(186003)(2616005)(83380400001)(426003)(82310400005)(47076005)(1076003)(36756003)(36860700001)(110136005)(54906003)(316002)(6666004)(7696005)(8676002)(5660300002)(44832011)(86362001)(8936002)(70586007)(70206006)(40460700003)(356005)(81166007)(4326008)(2906002)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 11:59:09.9499
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a06259b2-2971-45af-616a-08da1c7bda95
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4305
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
index f70a5108d464..2c2a104b777e 100644
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
index 655a7d20f8ee..fefac51063d3 100644
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
@@ -1004,3 +1011,30 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
 	avic_vcpu_load(vcpu);
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
index bd4c64b362d2..5ec770a1b4e8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4806,13 +4806,9 @@ static __init int svm_hardware_setup(void)
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
index f77a7d2d39dd..c44326eeb3f2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -571,6 +571,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 
 /* avic.c */
 
+bool avic_hardware_setup(struct kvm_x86_ops *ops);
 int avic_ga_log_notifier(u32 ga_tag);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);
-- 
2.25.1

