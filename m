Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA975FCF6F
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 21:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfKNUPo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 15:15:44 -0500
Received: from mail-eopbgr730059.outbound.protection.outlook.com ([40.107.73.59]:60877
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726474AbfKNUPn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 15:15:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dataV1sr/1Ch6/x70o5QOB32sEMCO4OinrsPcydebk9li+L6eeuuxZCtyGpy5e1PiHz1sJepNDB7/D7lLMLo17ElxR2WCIyBs5HTt3ECJ/q+zPL5ok67VEfwlHk6DVdyui57KYGnvbENL/Vhja0chaYMRUsgO4D3xBx86GCd74rUbOMRfx39fYK5Cgx+EnGFwVjwWkMzufkJ8OzmI2jeEevLnd2DDr+2qtw+uqcBRghpmgQ2Ph/RyUDzgsmvDeLeIQJvQRL8+pAtu3O01CpEPudDDwDszgyerx9j7/IYliweS/r0L15CB3UVO/6GEj4VW947OG345V8TTQVtWCswOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g/tTaWTDy79ANhXHxbiFAHA+rqBMsyt9P5MnwSqU73o=;
 b=ZBsMhrEVK8fGFyq0slWAUrAB9fVJ79G2fdtV5U3e77OQ4OvZ6QpMOdkf0ZwJJtTW3f2jtE6J2vgc+Hs+WpiCkAYnjhlKtvVVjWBjfflXbhI8h8KmsFYACrnJMhx/d0v5j/FwSUmIb9bfjsjXo/F41vyj2DfUm7VB5M9vcKL+aNw5kZ8pCIBd/U98a9LsBBbbDRf+QoTR98AVoQbnX/Dq2+fYq2cZoOLsMhCRodKCkyVZWTRLOAn6b72cXX5mzOWp/Ud+SedK3CJDzry4U94Tr2CGiI8OiBa61xn3DSUgq/ACm57+ljVYie8lm1sD8BIbShR+2PpWz5gErmlW/OjGpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g/tTaWTDy79ANhXHxbiFAHA+rqBMsyt9P5MnwSqU73o=;
 b=mPVz1x89/+gaIPB8jcKskmDskeccj1WJ9KiRodvqbQSGwaoVIpjBDq203zPq55aoIsC29h4eY22gXVYEYr6uooZvEbZ12qpjm8oIoZomdz5W/ugY/hIRtUnsnlsoX8VReDFdP0VH+icSgl/9BEFo+6MwnPwvAygbKjY9nV1fWmc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3739.namprd12.prod.outlook.com (10.255.172.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 20:15:36 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 20:15:36 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, joro@8bytes.org,
        vkuznets@redhat.com, rkagan@virtuozzo.com, graf@amazon.com,
        jschoenh@amazon.de, karahmed@amazon.de, rimasluk@amazon.com,
        jon.grimm@amd.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 04/18] kvm: x86: Add support for dynamic APICv
Date:   Thu, 14 Nov 2019 14:15:06 -0600
Message-Id: <1573762520-80328-5-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573762520-80328-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1573762520-80328-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0099.namprd12.prod.outlook.com
 (2603:10b6:802:21::34) To DM6PR12MB3865.namprd12.prod.outlook.com
 (2603:10b6:5:1c8::18)
MIME-Version: 1.0
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [165.204.78.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 33d5b8fc-8fb5-476c-d87c-08d7693f6902
X-MS-TrafficTypeDiagnostic: DM6PR12MB3739:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3739300826CF0B5BC2FDA221F3710@DM6PR12MB3739.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 02213C82F8
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(39860400002)(346002)(136003)(189003)(199004)(6506007)(25786009)(86362001)(6512007)(6436002)(8676002)(47776003)(7416002)(66066001)(6486002)(50226002)(4326008)(3846002)(8936002)(4720700003)(81156014)(2906002)(16586007)(7736002)(66556008)(305945005)(66476007)(2616005)(6116002)(66946007)(186003)(316002)(14454004)(486006)(478600001)(99286004)(81166006)(26005)(14444005)(476003)(5660300002)(44832011)(386003)(446003)(52116002)(51416003)(76176011)(50466002)(6666004)(36756003)(11346002)(48376002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3739;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZrNd9DdMTOXNTf5NHIAe74ROwHw8U5cTafpu6WkDW3Pju8SBbMbRatUuzCS3jR8tkXK8l3NQZAqjR7OSEP616rtGEUBsB6QvoUZhRDGvlDFURjR36olCxoBIlCroY2YgPuq6kHDLtD+YcEYOndIF83hOdbtAStVYc50nYKs0B8zIcmWbaw8gImp01K95bXXIgrE4yLpjRmEzV3KYinWlfeyrs7JyPtMiVIXrRRO7B2zgQyCpUv6h0fm8+bhBQ/nZjeKgQL50VDOKJ4pRYCrP4QXrkA2HfFEWz5RS8mC8OTPnzBycHu/bmiiPlRcAHCRDguCYFJO8bcf2kGObn66l9w8s1EPmiN8NoRU4E/B+CqpqJ7vQNU6kHR9IKflvQICgCzacqw0vuupQweJIkLCsUw9TYdaCPwJ9i34B+mFjgkIlL5s6f0V/kmvuiA7WAGME
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33d5b8fc-8fb5-476c-d87c-08d7693f6902
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2019 20:15:36.4823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l1jIUw8i2RKmOe+Yk2v4cOAMOK77SmFlHfWgD/QkNQ266Svk+U4nR6YvqmoDxeO8oAb4o2HWfj+DmMagzCQ5sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3739
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Certain runtime conditions require APICv to be temporary deactivated
during runtime. However, current implementation only support
deactivate APICv (mainly used when running Hyper-V SynIC).

In addition, for AMD, when (de)activate APICv during runtime,
all vcpus in the VM has to be operating in the same APICv mode, which
requires the requesting (main) vcpu to notify others.

So, introduce the following:
 * A new KVM_REQ_APICV_UPDATE request bit
 * Interfaces to request all vcpus to update ((de)activate) APICv
 * Interface to update APICV-related parameters for each vcpu

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +++++
 arch/x86/kvm/x86.c              | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c60786a..25383b6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -78,6 +78,8 @@
 #define KVM_REQ_HV_STIMER		KVM_ARCH_REQ(22)
 #define KVM_REQ_LOAD_EOI_EXITMAP	KVM_ARCH_REQ(23)
 #define KVM_REQ_GET_VMCS12_PAGES	KVM_ARCH_REQ(24)
+#define KVM_REQ_APICV_UPDATE \
+	KVM_ARCH_REQ_FLAGS(25, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -1446,6 +1448,9 @@ gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
 void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu);
 bool kvm_apicv_activated(struct kvm *kvm);
 void kvm_apicv_init(struct kvm *kvm, bool enable);
+void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
+void kvm_request_apicv_update(struct kvm *kvm, bool activate,
+			      unsigned long bit);
 
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4d19566..03318a2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -26,6 +26,7 @@
 #include "cpuid.h"
 #include "pmu.h"
 #include "hyperv.h"
+#include "lapic.h"
 
 #include <linux/clocksource.h>
 #include <linux/interrupt.h>
@@ -7860,6 +7861,41 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_SCAN_IOAPIC);
 }
 
+void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
+{
+	if (!lapic_in_kernel(vcpu))
+		return;
+
+	vcpu->arch.apicv_active = kvm_apicv_activated(vcpu->kvm);
+	kvm_apic_update_apicv(vcpu);
+	kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
+}
+EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
+
+/*
+ * NOTE: Do not hold any lock prior to calling this.
+ *
+ * kvm_request_apicv_update() expects a prior read unlock
+ * on the the kvm->srcu since it subsequently calls read lock
+ * and re-unlock in __x86_set_memory_region() when updating
+ * APIC_ACCESS_PAGE_PRIVATE_MEMSLOT.
+ */
+void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
+{
+	if (activate) {
+		if (!test_and_clear_bit(bit, &kvm->arch.apicv_inhibit_reasons) ||
+		    !kvm_apicv_activated(kvm))
+			return;
+	} else {
+		if (test_and_set_bit(bit, &kvm->arch.apicv_inhibit_reasons) ||
+		    kvm_apicv_activated(kvm))
+			return;
+	}
+
+	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
+}
+EXPORT_SYMBOL_GPL(kvm_request_apicv_update);
+
 static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_apic_present(vcpu))
@@ -8050,6 +8086,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		 */
 		if (kvm_check_request(KVM_REQ_HV_STIMER, vcpu))
 			kvm_hv_process_stimers(vcpu);
+		if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu))
+			kvm_vcpu_update_apicv(vcpu);
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
-- 
1.8.3.1

