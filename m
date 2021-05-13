Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A72837F6DE
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 13:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbhEMLid (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 07:38:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48335 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233413AbhEMLia (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 May 2021 07:38:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620905840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UhaBh7WNzH+s9VEh0BxBI8Vn/q+6nukasREEoL6o+Qs=;
        b=RtZLdHrhG2iYAuujkBCAap+PvDWTefkprycfIA7pJvh8ls4tz7wry5G6bkp3A9cPIqnWDF
        +rbjl496LP0p90wl4scD0yUTQFas37Xq4hc1jvOLEpeDFe01kTd+8XNipFaLjdFH6/VdFu
        /WsCHAeCivYmfmWFG7mmheROX3vpW1A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-uffO6t6JPV2W2BpK7g8hrw-1; Thu, 13 May 2021 07:37:19 -0400
X-MC-Unique: uffO6t6JPV2W2BpK7g8hrw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0A556123C;
        Thu, 13 May 2021 11:37:17 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 883AA100763C;
        Thu, 13 May 2021 11:37:15 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Kechen Lu <kechenl@nvidia.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: x86: Invert APICv/AVIC enablement check
Date:   Thu, 13 May 2021 13:37:09 +0200
Message-Id: <20210513113710.1740398-2-vkuznets@redhat.com>
In-Reply-To: <20210513113710.1740398-1-vkuznets@redhat.com>
References: <20210513113710.1740398-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, APICv/AVIC enablement is global ('enable_apicv' module parameter
for Intel, 'avic' module parameter for AMD) but there's no way to check
it from vendor-neutral code. Add 'apicv_supported()' to kvm_x86_ops and
invert kvm_apicv_init() (which now doesn't need to be called from arch-
specific code).

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/svm/svm.c          | 7 ++++++-
 arch/x86/kvm/vmx/vmx.c          | 7 ++++++-
 arch/x86/kvm/x86.c              | 6 +++---
 4 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 55efbacfc244..ffafdb7b24cb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1205,6 +1205,7 @@ struct kvm_x86_ops {
 	void (*hardware_unsetup)(void);
 	bool (*cpu_has_accelerated_tpr)(void);
 	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
+	bool (*apicv_supported)(void);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
 	unsigned int vm_size;
@@ -1661,7 +1662,6 @@ gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
 				struct x86_exception *exception);
 
 bool kvm_apicv_activated(struct kvm *kvm);
-void kvm_apicv_init(struct kvm *kvm, bool enable);
 void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
 void kvm_request_apicv_update(struct kvm *kvm, bool activate,
 			      unsigned long bit);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4dd9b7856e5b..360b3000c5a8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4470,16 +4470,21 @@ static int svm_vm_init(struct kvm *kvm)
 			return ret;
 	}
 
-	kvm_apicv_init(kvm, avic);
 	return 0;
 }
 
+static bool svm_avic_supported(void)
+{
+	return avic;
+}
+
 static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.hardware_unsetup = svm_hardware_teardown,
 	.hardware_enable = svm_hardware_enable,
 	.hardware_disable = svm_hardware_disable,
 	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
 	.has_emulated_msr = svm_has_emulated_msr,
+	.apicv_supported = svm_avic_supported,
 
 	.vcpu_create = svm_create_vcpu,
 	.vcpu_free = svm_free_vcpu,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f2fd447eed45..3b0f4f9c21b3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7034,7 +7034,6 @@ static int vmx_vm_init(struct kvm *kvm)
 			break;
 		}
 	}
-	kvm_apicv_init(kvm, enable_apicv);
 	return 0;
 }
 
@@ -7645,6 +7644,11 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 	return supported & BIT(bit);
 }
 
+static bool vmx_apicv_supported(void)
+{
+	return enable_apicv;
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.hardware_unsetup = hardware_unsetup,
 
@@ -7652,6 +7656,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.hardware_disable = hardware_disable,
 	.cpu_has_accelerated_tpr = report_flexpriority,
 	.has_emulated_msr = vmx_has_emulated_msr,
+	.apicv_supported = vmx_apicv_supported,
 
 	.vm_size = sizeof(struct kvm_vmx),
 	.vm_init = vmx_vm_init,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5bd550eaf683..fe7248e11e13 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8342,16 +8342,15 @@ bool kvm_apicv_activated(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(kvm_apicv_activated);
 
-void kvm_apicv_init(struct kvm *kvm, bool enable)
+static void kvm_apicv_init(struct kvm *kvm)
 {
-	if (enable)
+	if (kvm_x86_ops.apicv_supported())
 		clear_bit(APICV_INHIBIT_REASON_DISABLE,
 			  &kvm->arch.apicv_inhibit_reasons);
 	else
 		set_bit(APICV_INHIBIT_REASON_DISABLE,
 			&kvm->arch.apicv_inhibit_reasons);
 }
-EXPORT_SYMBOL_GPL(kvm_apicv_init);
 
 static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
 {
@@ -10727,6 +10726,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	INIT_DELAYED_WORK(&kvm->arch.kvmclock_update_work, kvmclock_update_fn);
 	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);
 
+	kvm_apicv_init(kvm);
 	kvm_hv_init_vm(kvm);
 	kvm_page_track_init(kvm);
 	kvm_mmu_init_vm(kvm);
-- 
2.31.1

