Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F63B3E84BE
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 22:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234232AbhHJUyH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 16:54:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53514 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234229AbhHJUyA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 16:54:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628628818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sqm2puIWzRIrXYVCKUmjkyYrUeYKMUz3cpqMAsvPeys=;
        b=XHJvXp8qZRTV6dmQUynk4hVclciZVcfF+O6STMBiOC5fXYfn/z85v+dlxGXkTFq9Twstmg
        Ilek/KopMYu88ZtG6aAGNmSXRbJEIK3c/WZL1yCjlcdopP83Lskq6eIkX4B/UnnHNWRkek
        WjtR/okzUYu2Ql5VAuJnD4zjvKikPwA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-wCf6JSq4Ooyqr02-hvDehQ-1; Tue, 10 Aug 2021 16:53:36 -0400
X-MC-Unique: wCf6JSq4Ooyqr02-hvDehQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50B1C1853026;
        Tue, 10 Aug 2021 20:53:35 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8DF07421F;
        Tue, 10 Aug 2021 20:53:31 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 08/16] KVM: x86: don't disable APICv memslot when inhibited
Date:   Tue, 10 Aug 2021 23:52:43 +0300
Message-Id: <20210810205251.424103-9-mlevitsk@redhat.com>
In-Reply-To: <20210810205251.424103-1-mlevitsk@redhat.com>
References: <20210810205251.424103-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks to the former patches, it is now possible to keep the APICv
memslot always enabled, and it will be invisible to the guest
when it is inhibited

This code is based on a suggestion from Sean Christopherson:
https://lkml.org/lkml/2021/7/19/2970

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 -
 arch/x86/include/asm/kvm_host.h    |  1 -
 arch/x86/kvm/svm/avic.c            | 21 ++++++---------------
 arch/x86/kvm/svm/svm.c             |  1 -
 arch/x86/kvm/svm/svm.h             |  1 -
 arch/x86/kvm/x86.c                 | 21 ++++++++-------------
 6 files changed, 14 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index a12a4987154e..cefe1d81e2e8 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -72,7 +72,6 @@ KVM_X86_OP(enable_nmi_window)
 KVM_X86_OP(enable_irq_window)
 KVM_X86_OP(update_cr8_intercept)
 KVM_X86_OP(check_apicv_inhibit_reasons)
-KVM_X86_OP_NULL(pre_update_apicv_exec_ctrl)
 KVM_X86_OP(refresh_apicv_exec_ctrl)
 KVM_X86_OP(hwapic_irr_update)
 KVM_X86_OP(hwapic_isr_update)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4c567b05edad..d800ee894c92 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1346,7 +1346,6 @@ struct kvm_x86_ops {
 	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
 	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
 	bool (*check_apicv_inhibit_reasons)(ulong bit);
-	void (*pre_update_apicv_exec_ctrl)(struct kvm *kvm, bool activate);
 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
 	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
 	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index a8ad78a2faa1..d0acbeeab3d6 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -225,31 +225,26 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
  * field of the VMCB. Therefore, we set up the
  * APIC_ACCESS_PAGE_PRIVATE_MEMSLOT (4KB) here.
  */
-static int avic_update_access_page(struct kvm *kvm, bool activate)
+static int avic_alloc_access_page(struct kvm *kvm)
 {
 	void __user *ret;
 	int r = 0;
 
 	mutex_lock(&kvm->slots_lock);
-	/*
-	 * During kvm_destroy_vm(), kvm_pit_set_reinject() could trigger
-	 * APICv mode change, which update APIC_ACCESS_PAGE_PRIVATE_MEMSLOT
-	 * memory region. So, we need to ensure that kvm->mm == current->mm.
-	 */
-	if ((kvm->arch.apic_access_memslot_enabled == activate) ||
-	    (kvm->mm != current->mm))
+
+	if (kvm->arch.apic_access_memslot_enabled)
 		goto out;
 
 	ret = __x86_set_memory_region(kvm,
 				      APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
 				      APIC_DEFAULT_PHYS_BASE,
-				      activate ? PAGE_SIZE : 0);
+				      PAGE_SIZE);
 	if (IS_ERR(ret)) {
 		r = PTR_ERR(ret);
 		goto out;
 	}
 
-	kvm->arch.apic_access_memslot_enabled = activate;
+	kvm->arch.apic_access_memslot_enabled = true;
 out:
 	mutex_unlock(&kvm->slots_lock);
 	return r;
@@ -270,7 +265,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	if (kvm_apicv_activated(vcpu->kvm)) {
 		int ret;
 
-		ret = avic_update_access_page(vcpu->kvm, true);
+		ret = avic_alloc_access_page(vcpu->kvm);
 		if (ret)
 			return ret;
 	}
@@ -918,10 +913,6 @@ bool svm_check_apicv_inhibit_reasons(ulong bit)
 	return supported & BIT(bit);
 }
 
-void svm_pre_update_apicv_exec_ctrl(struct kvm *kvm, bool activate)
-{
-	avic_update_access_page(kvm, activate);
-}
 
 static inline int
 avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9d72b1df426e..4feff53dd1d3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4583,7 +4583,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.set_virtual_apic_mode = svm_set_virtual_apic_mode,
 	.refresh_apicv_exec_ctrl = svm_refresh_apicv_exec_ctrl,
 	.check_apicv_inhibit_reasons = svm_check_apicv_inhibit_reasons,
-	.pre_update_apicv_exec_ctrl = svm_pre_update_apicv_exec_ctrl,
 	.load_eoi_exitmap = svm_load_eoi_exitmap,
 	.hwapic_irr_update = svm_hwapic_irr_update,
 	.hwapic_isr_update = svm_hwapic_isr_update,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index bd0fe94c2920..bd41f2a32838 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -534,7 +534,6 @@ void avic_post_state_restore(struct kvm_vcpu *vcpu);
 void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
 bool svm_check_apicv_inhibit_reasons(ulong bit);
-void svm_pre_update_apicv_exec_ctrl(struct kvm *kvm, bool activate);
 void svm_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 void svm_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr);
 void svm_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index df71f5e3e23b..b8952001ee44 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9255,13 +9255,6 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
 
-/*
- * NOTE: Do not hold any lock prior to calling this.
- *
- * In particular, kvm_request_apicv_update() expects kvm->srcu not to be
- * locked, because it calls __x86_set_memory_region() which does
- * synchronize_srcu(&kvm->srcu).
- */
 void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 {
 	unsigned long old, new, expected;
@@ -9282,14 +9275,16 @@ void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 		old = cmpxchg(&kvm->arch.apicv_inhibit_reasons, expected, new);
 	} while (old != expected);
 
-	if (!!old == !!new)
-		return;
+	if (!!old != !!new) {
+		trace_kvm_apicv_update_request(activate, bit);
+		kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
+		if (new) {
+			unsigned long gfn = gpa_to_gfn(APIC_DEFAULT_PHYS_BASE);
 
-	trace_kvm_apicv_update_request(activate, bit);
-	if (kvm_x86_ops.pre_update_apicv_exec_ctrl)
-		static_call(kvm_x86_pre_update_apicv_exec_ctrl)(kvm, activate);
+			kvm_zap_gfn_range(kvm, gfn, gfn+1);
+		}
+	}
 
-	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
 }
 EXPORT_SYMBOL_GPL(kvm_request_apicv_update);
 
-- 
2.26.3

