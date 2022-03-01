Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFA694C9336
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 19:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236989AbiCAS3W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 13:29:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiCAS3U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 13:29:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E1ADC36E37
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 10:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646159310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PCDXN8uVeWOuUFeyGQEkeCI1l4GKs1v4j1S1C45OtjU=;
        b=XYKcfgKiy9XUeChylfSxO3IMe8N16G7DVvOFfxyLuf3XeIJ7YG14OeQ4iP6JGAlsXGz9pv
        EhXuqztgnJT9P2xjkETx6WtdVdW80RWXvd7iWtnuKcIZts1xX0zeQwNZVRXYICv+ba/TmN
        ER3d526KYyUKJ+fqAnvBXrnf2d3MI+o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-ZPCHC60wNiuHsEf4z4wzZw-1; Tue, 01 Mar 2022 13:28:26 -0500
X-MC-Unique: ZPCHC60wNiuHsEf4z4wzZw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5340C1006AA6;
        Tue,  1 Mar 2022 18:28:23 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0E9D86C41;
        Tue,  1 Mar 2022 18:28:16 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        x86@kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Joerg Roedel <joro@8bytes.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        dri-devel@lists.freedesktop.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 08/11] KVM: x86: SVM: move avic state to separate struct
Date:   Tue,  1 Mar 2022 20:26:36 +0200
Message-Id: <20220301182639.559568-9-mlevitsk@redhat.com>
In-Reply-To: <20220301182639.559568-1-mlevitsk@redhat.com>
References: <20220301182639.559568-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will make the code a bit easier to read when nested AVIC support
is added.

No functional change intended.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 49 +++++++++++++++++++++++------------------
 arch/x86/kvm/svm/svm.h  | 14 +++++++-----
 2 files changed, 36 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 90f106d4af45e..406cdb63646e0 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -69,6 +69,8 @@ int avic_ga_log_notifier(u32 ga_tag)
 	unsigned long flags;
 	struct kvm_svm *kvm_svm;
 	struct kvm_vcpu *vcpu = NULL;
+	struct kvm_svm_avic *avic;
+
 	u32 vm_id = AVIC_GATAG_TO_VMID(ga_tag);
 	u32 vcpu_id = AVIC_GATAG_TO_VCPUID(ga_tag);
 
@@ -76,9 +78,13 @@ int avic_ga_log_notifier(u32 ga_tag)
 	trace_kvm_avic_ga_log(vm_id, vcpu_id);
 
 	spin_lock_irqsave(&svm_vm_data_hash_lock, flags);
-	hash_for_each_possible(svm_vm_data_hash, kvm_svm, hnode, vm_id) {
-		if (kvm_svm->avic_vm_id != vm_id)
+	hash_for_each_possible(svm_vm_data_hash, avic, hnode, vm_id) {
+
+
+		if (avic->vm_id != vm_id)
 			continue;
+
+		kvm_svm = container_of(avic, struct kvm_svm, avic);
 		vcpu = kvm_get_vcpu_by_id(&kvm_svm->kvm, vcpu_id);
 		break;
 	}
@@ -98,18 +104,18 @@ int avic_ga_log_notifier(u32 ga_tag)
 void avic_vm_destroy(struct kvm *kvm)
 {
 	unsigned long flags;
-	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
+	struct kvm_svm_avic *avic = &to_kvm_svm(kvm)->avic;
 
 	if (!enable_apicv)
 		return;
 
-	if (kvm_svm->avic_logical_id_table_page)
-		__free_page(kvm_svm->avic_logical_id_table_page);
-	if (kvm_svm->avic_physical_id_table_page)
-		__free_page(kvm_svm->avic_physical_id_table_page);
+	if (avic->logical_id_table_page)
+		__free_page(avic->logical_id_table_page);
+	if (avic->physical_id_table_page)
+		__free_page(avic->physical_id_table_page);
 
 	spin_lock_irqsave(&svm_vm_data_hash_lock, flags);
-	hash_del(&kvm_svm->hnode);
+	hash_del(&avic->hnode);
 	spin_unlock_irqrestore(&svm_vm_data_hash_lock, flags);
 }
 
@@ -117,10 +123,9 @@ int avic_vm_init(struct kvm *kvm)
 {
 	unsigned long flags;
 	int err = -ENOMEM;
-	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
-	struct kvm_svm *k2;
 	struct page *p_page;
 	struct page *l_page;
+	struct kvm_svm_avic *avic = &to_kvm_svm(kvm)->avic;
 	u32 vm_id;
 
 	if (!enable_apicv)
@@ -131,14 +136,14 @@ int avic_vm_init(struct kvm *kvm)
 	if (!p_page)
 		goto free_avic;
 
-	kvm_svm->avic_physical_id_table_page = p_page;
+	avic->physical_id_table_page = p_page;
 
 	/* Allocating logical APIC ID table (4KB) */
 	l_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!l_page)
 		goto free_avic;
 
-	kvm_svm->avic_logical_id_table_page = l_page;
+	avic->logical_id_table_page = l_page;
 
 	spin_lock_irqsave(&svm_vm_data_hash_lock, flags);
  again:
@@ -149,13 +154,15 @@ int avic_vm_init(struct kvm *kvm)
 	}
 	/* Is it still in use? Only possible if wrapped at least once */
 	if (next_vm_id_wrapped) {
-		hash_for_each_possible(svm_vm_data_hash, k2, hnode, vm_id) {
-			if (k2->avic_vm_id == vm_id)
+		struct kvm_svm_avic *avic2;
+
+		hash_for_each_possible(svm_vm_data_hash, avic2, hnode, vm_id) {
+			if (avic2->vm_id == vm_id)
 				goto again;
 		}
 	}
-	kvm_svm->avic_vm_id = vm_id;
-	hash_add(svm_vm_data_hash, &kvm_svm->hnode, kvm_svm->avic_vm_id);
+	avic->vm_id = vm_id;
+	hash_add(svm_vm_data_hash, &avic->hnode, avic->vm_id);
 	spin_unlock_irqrestore(&svm_vm_data_hash_lock, flags);
 
 	return 0;
@@ -170,8 +177,8 @@ void avic_init_vmcb(struct vcpu_svm *svm)
 	struct vmcb *vmcb = svm->vmcb;
 	struct kvm_svm *kvm_svm = to_kvm_svm(svm->vcpu.kvm);
 	phys_addr_t bpa = __sme_set(page_to_phys(svm->avic_backing_page));
-	phys_addr_t lpa = __sme_set(page_to_phys(kvm_svm->avic_logical_id_table_page));
-	phys_addr_t ppa = __sme_set(page_to_phys(kvm_svm->avic_physical_id_table_page));
+	phys_addr_t lpa = __sme_set(page_to_phys(kvm_svm->avic.logical_id_table_page));
+	phys_addr_t ppa = __sme_set(page_to_phys(kvm_svm->avic.physical_id_table_page));
 
 	vmcb->control.avic_backing_page = bpa & AVIC_HPA_MASK;
 	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
@@ -194,7 +201,7 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
 	if (index >= AVIC_MAX_PHYSICAL_ID_COUNT)
 		return NULL;
 
-	avic_physical_id_table = page_address(kvm_svm->avic_physical_id_table_page);
+	avic_physical_id_table = page_address(kvm_svm->avic.physical_id_table_page);
 
 	return &avic_physical_id_table[index];
 }
@@ -386,7 +393,7 @@ static u32 *avic_get_logical_id_entry(struct kvm_vcpu *vcpu, u32 ldr, bool flat)
 		index = (cluster << 2) + apic;
 	}
 
-	logical_apic_id_table = (u32 *) page_address(kvm_svm->avic_logical_id_table_page);
+	logical_apic_id_table = (u32 *) page_address(kvm_svm->avic.logical_id_table_page);
 
 	return &logical_apic_id_table[index];
 }
@@ -762,7 +769,7 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 			/* Try to enable guest_mode in IRTE */
 			pi.base = __sme_set(page_to_phys(svm->avic_backing_page) &
 					    AVIC_HPA_MASK);
-			pi.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id,
+			pi.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic.vm_id,
 						     svm->vcpu.vcpu_id);
 			pi.is_guest_mode = true;
 			pi.vcpu_data = &vcpu_info;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 3ef2681244e84..469d9fc6e5f15 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -85,15 +85,17 @@ struct kvm_sev_info {
 	atomic_t migration_in_progress;
 };
 
-struct kvm_svm {
-	struct kvm kvm;
 
-	/* Struct members for AVIC */
-	u32 avic_vm_id;
-	struct page *avic_logical_id_table_page;
-	struct page *avic_physical_id_table_page;
+struct kvm_svm_avic {
+	u32 vm_id;
+	struct page *logical_id_table_page;
+	struct page *physical_id_table_page;
 	struct hlist_node hnode;
+};
 
+struct kvm_svm {
+	struct kvm kvm;
+	struct kvm_svm_avic avic;
 	struct kvm_sev_info sev_info;
 };
 
-- 
2.26.3

