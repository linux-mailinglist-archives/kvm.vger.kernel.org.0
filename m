Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D057E3DDF50
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 20:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbhHBSer (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 14:34:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39278 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232342AbhHBSed (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 14:34:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627929263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=exFFL29OKp757/ioCgv9r/o3ktgyW9NlCP94Ok52aqE=;
        b=Gabyo99FcyvNf18OKnIJ5hBKpP6+HVoYnS6SOv5qWh2638JmWX8NFT3mEA8Qign6sx6bqE
        /ul5foRiB1duD3hsWSmXTnxLtoYQb0o0AyuGCGAHLHlA66GWukGBoatO0YG34UA2HrAghz
        XUAeKqGp5kSLvua9B9Qhyp5A8PmooCM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-cdQpgnIEMga_Jhbzvl5q-Q-1; Mon, 02 Aug 2021 14:34:22 -0400
X-MC-Unique: cdQpgnIEMga_Jhbzvl5q-Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5D9087505F;
        Mon,  2 Aug 2021 18:34:20 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3620B3AE1;
        Mon,  2 Aug 2021 18:34:17 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 11/12] KVM: SVM: call avic_vcpu_load/avic_vcpu_put when enabling/disabling AVIC
Date:   Mon,  2 Aug 2021 21:33:28 +0300
Message-Id: <20210802183329.2309921-12-mlevitsk@redhat.com>
In-Reply-To: <20210802183329.2309921-1-mlevitsk@redhat.com>
References: <20210802183329.2309921-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently it is possible to have the following scenario:

1. AVIC is disabled by svm_refresh_apicv_exec_ctrl
2. svm_vcpu_blocking calls avic_vcpu_put which does nothing
3. svm_vcpu_unblocking enables the AVIC (due to KVM_REQ_APICV_UPDATE)
   and then calls avic_vcpu_load
4. warning is triggered in avic_vcpu_load since
   AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK was never cleared

While it is possible to just remove the warning, it seems to be more robust
to fully disable/enable AVIC in svm_refresh_apicv_exec_ctrl by calling the
avic_vcpu_load/avic_vcpu_put

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 43 ++++++++++++++++++++++-------------------
 arch/x86/kvm/svm/svm.c  |  8 ++++++--
 arch/x86/kvm/x86.c      |  9 ++++++++-
 3 files changed, 37 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 1def54c26259..a39f7888b587 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -80,6 +80,28 @@ enum avic_ipi_failure_cause {
 	AVIC_IPI_FAILURE_INVALID_BACKING_PAGE,
 };
 
+
+static void __avic_set_running(struct kvm_vcpu *vcpu, bool is_run)
+{
+	if (is_run)
+		avic_vcpu_load(vcpu, vcpu->cpu);
+	else
+		avic_vcpu_put(vcpu);
+}
+
+/*
+ * This function is called during VCPU halt/unhalt.
+ */
+static void avic_set_running(struct kvm_vcpu *vcpu, bool is_run)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm->avic_is_running = is_run;
+
+	if (kvm_vcpu_apicv_active(vcpu))
+		__avic_set_running(vcpu, is_run);
+}
+
 /* Note:
  * This function is called from IOMMU driver to notify
  * SVM to schedule in a particular vCPU of a particular VM.
@@ -651,6 +673,7 @@ void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 	}
 	vmcb_mark_dirty(vmcb, VMCB_AVIC);
 
+	__avic_set_running(vcpu, activated);
 	svm_set_pi_irte_mode(vcpu, activated);
 }
 
@@ -940,9 +963,6 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (!kvm_vcpu_apicv_active(vcpu))
-		return;
-
 	/*
 	 * Since the host physical APIC id is 8 bits,
 	 * we can support host APIC ID upto 255.
@@ -970,9 +990,6 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	u64 entry;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (!kvm_vcpu_apicv_active(vcpu))
-		return;
-
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
 	if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
 		avic_update_iommu_vcpu_affinity(vcpu, -1, 0);
@@ -981,20 +998,6 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
 }
 
-/*
- * This function is called during VCPU halt/unhalt.
- */
-static void avic_set_running(struct kvm_vcpu *vcpu, bool is_run)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	svm->avic_is_running = is_run;
-	if (is_run)
-		avic_vcpu_load(vcpu, vcpu->cpu);
-	else
-		avic_vcpu_put(vcpu);
-}
-
 void svm_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
 	avic_set_running(vcpu, false);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c8827de49c75..61b5faba36cf 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1483,12 +1483,16 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		sd->current_vmcb = svm->vmcb;
 		indirect_branch_prediction_barrier();
 	}
-	avic_vcpu_load(vcpu, cpu);
+
+	if (kvm_vcpu_apicv_active(vcpu))
+		avic_vcpu_load(vcpu, cpu);
 }
 
 static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	avic_vcpu_put(vcpu);
+	if (kvm_vcpu_apicv_active(vcpu))
+		avic_vcpu_put(vcpu);
+
 	svm_prepare_host_switch(vcpu);
 
 	++vcpu->stat.host_state_reload;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9d2e4594c4eb..67bea0809636 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9239,12 +9239,18 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm)
 
 void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 {
+	bool activate;
+
 	if (!lapic_in_kernel(vcpu))
 		return;
 
 	mutex_lock(&vcpu->kvm->arch.apicv_update_lock);
 
-	vcpu->arch.apicv_active = kvm_apicv_activated(vcpu->kvm);
+	activate = kvm_apicv_activated(vcpu->kvm);
+	if (vcpu->arch.apicv_active == activate)
+		goto out;
+
+	vcpu->arch.apicv_active = activate;
 	kvm_apic_update_apicv(vcpu);
 	static_call(kvm_x86_refresh_apicv_exec_ctrl)(vcpu);
 
@@ -9257,6 +9263,7 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	if (!vcpu->arch.apicv_active)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 
+out:
 	mutex_unlock(&vcpu->kvm->arch.apicv_update_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
-- 
2.26.3

