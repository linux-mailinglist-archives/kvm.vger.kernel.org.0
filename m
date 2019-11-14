Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3ABFCF8B
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 21:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfKNUPm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 15:15:42 -0500
Received: from mail-eopbgr730059.outbound.protection.outlook.com ([40.107.73.59]:60877
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726632AbfKNUPk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 15:15:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PwJr+XHGW0SIXm9La7aZwax2weSiCEvJAb31PkNv/yhJprVvkbx0d95XoTwYoIiaT5Z3FaSkR0TeQMySyNoERX/T9a+cZ7OfDqEok9vNYLD/QwTyn+AejCHfQTsbftTloKEKFm1PIBALn4BHsSn2Ea8URmpKARoMde7IR731i1NRIYXVXYv23Gs1/gNWUDH4WTiTxRWAPMfj02CcNLoNc4X6iCBKI/6QfnjLBm6NKG5DvgU+QJCnwulu8JUHRVIOCapuP3xnuHFTbdxyi7ZV2b4LWCqk6qm3Nbl3uTFG97xEM9C+NyJeduAxC1xe1z3DitCRJAzgWD8uZiDvYZOxLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aSJAE9b98wiVt7KovOkz074yVcWRPFtYJfRW5vjJ+bo=;
 b=XtJV+Hx+Z8jP1qNKOPCqY57+Y4qrz0trkZ7nMOxxnigxOCpJPHksYJEmWDLfHSeNyuHK9qeJm/b9NclI9fqcoR1ks0q0WTyV+5EIrNE0Mb8rr3ug+0GTI1Vqsl2Ma40PNZWscgo4XHZgAuomC1LS0q2e5g9HBGkr3i5HUeHX46sPTdq7+RuJk+sdj+TAj0do+dHs9VTBmoDOiDdL68h46rG5UOYly5f1yFueTy2WyietLQXrX1mm0ci5PCYMBXLOLF3n+XoYnmjHNHMD7pdi2FjeRepZeYq3ExBl66j8HEkzGVFwbxOaxVRKHQ6LTN6IY2cztFo9rcaggWKKHf52qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aSJAE9b98wiVt7KovOkz074yVcWRPFtYJfRW5vjJ+bo=;
 b=dkeRxgpnlN73M33J9SpSvlnA4dnkHA6RKVID1dCIkz2ULcSCzOW9vcMBENQy/c69ND97+p3CB2IxtIPOPVhmp4jS0S4rMRRZ/zD/MJ9o4uWJeIbMxN6UQ7lnBXQFBg7leoBvDen/7XvCa9I820UVr9dww/fNMz3pbr3+FzOut/g=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3739.namprd12.prod.outlook.com (10.255.172.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 20:15:35 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 20:15:35 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, joro@8bytes.org,
        vkuznets@redhat.com, rkagan@virtuozzo.com, graf@amazon.com,
        jschoenh@amazon.de, karahmed@amazon.de, rimasluk@amazon.com,
        jon.grimm@amd.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 03/18] kvm: x86: Introduce APICv inhibit reason bits
Date:   Thu, 14 Nov 2019 14:15:05 -0600
Message-Id: <1573762520-80328-4-git-send-email-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 29685d70-8f81-41d5-7786-08d7693f681f
X-MS-TrafficTypeDiagnostic: DM6PR12MB3739:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB373992A3DA3E5E2186D8B226F3710@DM6PR12MB3739.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-Forefront-PRVS: 02213C82F8
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(39860400002)(346002)(136003)(189003)(199004)(6506007)(25786009)(86362001)(6512007)(6436002)(8676002)(47776003)(7416002)(66066001)(6486002)(50226002)(4326008)(3846002)(8936002)(4720700003)(81156014)(2906002)(16586007)(7736002)(66556008)(305945005)(66476007)(2616005)(6116002)(66946007)(186003)(316002)(14454004)(486006)(478600001)(99286004)(81166006)(26005)(14444005)(476003)(5660300002)(44832011)(386003)(446003)(52116002)(51416003)(76176011)(50466002)(6666004)(36756003)(11346002)(48376002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3739;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dlovvzsSMik/WolETVM73twZ0Z9Lmw2/cNcdNrqCLrhnK2vpx7dK0HUGKbKEoIERKCrVeUUdD3kWwkJRAbhWRCIAxOmIcGEmjr5tLPi8AyrjtRH9OkbexOWB2yeiz/3V3u2PyUS7VfqAz2KlG4jAlTTcWr1g5agA3Yy2xKndRyuWQ84toX6UYi012mDh4EgmVHIV423Bvs8msTIR6wonLB33niTLN8JjhLkSQ2HK1H26QF3XEsVZSoKi9TSmqu5Tzkj/A3ba/XgVmA8isa2VLPDgAemslSP1OvQZ1Z56srwJdFIU+5OWNGMPZeYmpNMhKFfPI6QW133VPzSn58Xm2Ao0y1mJRQWOaIUviMc2E3wdPoYSqHMTQYC+63EoIPZI1m77AHnUGJGf87heJv2TWEyk8/EQaAUBSBjVtS8WWY1OoZOtzkw4x+rshDjE4uw2
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29685d70-8f81-41d5-7786-08d7693f681f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2019 20:15:34.9321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BtQciOidd/LqMkuDKffCUxMbWm5tgqXNtU26rGkvEYQWh8liW5bLgKxPxDklzS1/f7CutvaFwT2Q7lj9x1mNGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3739
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are several reasons in which a VM needs to deactivate APICv
e.g. disable APICv via parameter during module loading, or when
enable Hyper-V SynIC support. Additional inhibit reasons will be
introduced later on when dynamic APICv is supported,

Introduce KVM APICv inhibit reason bits along with a new variable,
apicv_inhibit_reasons, to help keep track of APICv state for each VM,

Initially, the APICV_INHIBIT_REASON_DISABLE bit is used to indicate
the case where APICv is disabled during KVM module load.
(e.g. insmod kvm_amd avic=0 or insmod kvm_intel enable_apicv=0).

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +++++
 arch/x86/kvm/svm.c              | 13 ++++++++++++-
 arch/x86/kvm/vmx/vmx.c          |  1 +
 arch/x86/kvm/x86.c              | 20 +++++++++++++++++++-
 4 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 632589a..c60786a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -847,6 +847,8 @@ enum kvm_irqchip_mode {
 	KVM_IRQCHIP_SPLIT,        /* created with KVM_CAP_SPLIT_IRQCHIP */
 };
 
+#define APICV_INHIBIT_REASON_DISABLE    0
+
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
 	unsigned long n_requested_mmu_pages;
@@ -877,6 +879,7 @@ struct kvm_arch {
 	struct kvm_apic_map *apic_map;
 
 	bool apic_access_page_done;
+	unsigned long apicv_inhibit_reasons;
 
 	gpa_t wall_clock;
 
@@ -1441,6 +1444,8 @@ gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
 				struct x86_exception *exception);
 
 void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu);
+bool kvm_apicv_activated(struct kvm *kvm);
+void kvm_apicv_init(struct kvm *kvm, bool enable);
 
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d53ffb8..3395e4c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1997,6 +1997,17 @@ static int avic_vm_init(struct kvm *kvm)
 	return err;
 }
 
+static int svm_vm_init(struct kvm *kvm)
+{
+	int ret = 0;
+
+	if (avic)
+		ret = avic_vm_init(kvm);
+
+	kvm_apicv_init(kvm, (avic && !ret));
+	return ret;
+}
+
 static inline int
 avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 {
@@ -7195,7 +7206,7 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 
 	.vm_alloc = svm_vm_alloc,
 	.vm_free = svm_vm_free,
-	.vm_init = avic_vm_init,
+	.vm_init = svm_vm_init,
 	.vm_destroy = svm_vm_destroy,
 
 	.prepare_guest_switch = svm_prepare_guest_switch,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2aa14d5..d6d1c862 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6848,6 +6848,7 @@ static int vmx_vm_init(struct kvm *kvm)
 			break;
 		}
 	}
+	kvm_apicv_init(kvm, vmx_get_enable_apicv(kvm));
 	return 0;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4cbb948..4d19566 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7329,6 +7329,23 @@ void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu)
 	kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
 }
 
+bool kvm_apicv_activated(struct kvm *kvm)
+{
+	return (READ_ONCE(kvm->arch.apicv_inhibit_reasons) == 0);
+}
+EXPORT_SYMBOL_GPL(kvm_apicv_activated);
+
+void kvm_apicv_init(struct kvm *kvm, bool enable)
+{
+	if (enable)
+		clear_bit(APICV_INHIBIT_REASON_DISABLE,
+			  &kvm->arch.apicv_inhibit_reasons);
+	else
+		set_bit(APICV_INHIBIT_REASON_DISABLE,
+			&kvm->arch.apicv_inhibit_reasons);
+}
+EXPORT_SYMBOL_GPL(kvm_apicv_init);
+
 static void kvm_sched_yield(struct kvm *kvm, unsigned long dest_id)
 {
 	struct kvm_vcpu *target = NULL;
@@ -9347,10 +9364,11 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 		goto fail_free_pio_data;
 
 	if (irqchip_in_kernel(vcpu->kvm)) {
-		vcpu->arch.apicv_active = kvm_x86_ops->get_enable_apicv(vcpu->kvm);
 		r = kvm_create_lapic(vcpu, lapic_timer_advance_ns);
 		if (r < 0)
 			goto fail_mmu_destroy;
+		if (kvm_apicv_activated(vcpu->kvm))
+			vcpu->arch.apicv_active = kvm_x86_ops->get_enable_apicv(vcpu->kvm);
 	} else
 		static_key_slow_inc(&kvm_no_apic_vcpu);
 
-- 
1.8.3.1

