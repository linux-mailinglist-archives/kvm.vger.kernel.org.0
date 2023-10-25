Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2756A7D70E0
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 17:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344581AbjJYP1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 11:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344472AbjJYP0e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 11:26:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1EA9194
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 08:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698247467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xG0AIv1akX/E+5UMfXqHSrPkXyerp0xiOihdz+wjQtY=;
        b=Grtfn+HCIzqpdp6OCQMn434CM20VtFpvkmI67A70s7BJzkm/vpKmAjiBkQvwMIjEuB6D63
        aQyRhGE01nn/Hg1y8X758sgvaUgCJEp8B8kBw4b7F+WXxbzcfCWPc+jxgmj6Nn4u6O45kU
        48T4grKGJPxBeTSFAzSO4WRpEs6POr0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-GaSjdN-ROqqXDqiu4QT1Gw-1; Wed, 25 Oct 2023 11:24:10 -0400
X-MC-Unique: GaSjdN-ROqqXDqiu4QT1Gw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78B00811E7B;
        Wed, 25 Oct 2023 15:24:10 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BBA82166B26;
        Wed, 25 Oct 2023 15:24:09 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH 02/14] KVM: x86: hyper-v: Move Hyper-V partition assist page out of Hyper-V emulation context
Date:   Wed, 25 Oct 2023 17:23:54 +0200
Message-ID: <20231025152406.1879274-3-vkuznets@redhat.com>
In-Reply-To: <20231025152406.1879274-1-vkuznets@redhat.com>
References: <20231025152406.1879274-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-V partition assist page is used when KVM runs on top of Hyper-V and
is not used for Windows/Hyper-V guests on KVM, this means that 'hv_pa_pg'
placement in 'struct kvm_hv' is unfortunate. As a preparation to making
Hyper-V emulation optional, move 'hv_pa_pg' to 'struct kvm_arch' and put it
under CONFIG_HYPERV.

While on it, introduce hv_get_partition_assist_page() helper to allocate
partition assist page. Move the comment explaining why we use a single page
for all vCPUs from VMX and expand it a bit.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/kvm_onhyperv.h     | 20 ++++++++++++++++++++
 arch/x86/kvm/svm/svm_onhyperv.c | 10 +++-------
 arch/x86/kvm/vmx/vmx.c          | 14 +++-----------
 arch/x86/kvm/x86.c              |  4 +++-
 5 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d107516b4591..7fb2810f4573 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1125,7 +1125,6 @@ struct kvm_hv {
 	 */
 	unsigned int synic_auto_eoi_used;
 
-	struct hv_partition_assist_pg *hv_pa_pg;
 	struct kvm_hv_syndbg hv_syndbg;
 };
 
@@ -1447,6 +1446,7 @@ struct kvm_arch {
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t	hv_root_tdp;
 	spinlock_t hv_root_tdp_lock;
+	struct hv_partition_assist_pg *hv_pa_pg;
 #endif
 	/*
 	 * VM-scope maximum vCPU ID. Used to determine the size of structures
diff --git a/arch/x86/kvm/kvm_onhyperv.h b/arch/x86/kvm/kvm_onhyperv.h
index f9ca3e7432b2..eefab3dc8498 100644
--- a/arch/x86/kvm/kvm_onhyperv.h
+++ b/arch/x86/kvm/kvm_onhyperv.h
@@ -10,6 +10,26 @@
 int hv_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, gfn_t nr_pages);
 int hv_flush_remote_tlbs(struct kvm *kvm);
 void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp);
+static inline hpa_t hv_get_partition_assist_page(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Partition assist page is something which Hyper-V running in L0
+	 * requires from KVM running in L1 before direct TLB flush for L2
+	 * guests can be enabled. KVM doesn't currently use the page but to
+	 * comply with TLFS it still needs to be allocated. For now, this
+	 * is a single page shared among all vCPUs.
+	 */
+	struct hv_partition_assist_pg **p_hv_pa_pg =
+		&vcpu->kvm->arch.hv_pa_pg;
+
+	if (!*p_hv_pa_pg)
+		*p_hv_pa_pg = kzalloc(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
+
+	if (!*p_hv_pa_pg)
+		return INVALID_PAGE;
+
+	return __pa(*p_hv_pa_pg);
+}
 #else /* !CONFIG_HYPERV */
 static inline int hv_flush_remote_tlbs(struct kvm *kvm)
 {
diff --git a/arch/x86/kvm/svm/svm_onhyperv.c b/arch/x86/kvm/svm/svm_onhyperv.c
index 7af8422d3382..3971b3ea5d04 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.c
+++ b/arch/x86/kvm/svm/svm_onhyperv.c
@@ -18,18 +18,14 @@
 int svm_hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
 {
 	struct hv_vmcb_enlightenments *hve;
-	struct hv_partition_assist_pg **p_hv_pa_pg =
-			&to_kvm_hv(vcpu->kvm)->hv_pa_pg;
+	hpa_t partition_assist_page = hv_get_partition_assist_page(vcpu);
 
-	if (!*p_hv_pa_pg)
-		*p_hv_pa_pg = kzalloc(PAGE_SIZE, GFP_KERNEL);
-
-	if (!*p_hv_pa_pg)
+	if (partition_assist_page == INVALID_PAGE)
 		return -ENOMEM;
 
 	hve = &to_svm(vcpu)->vmcb->control.hv_enlightenments;
 
-	hve->partition_assist_page = __pa(*p_hv_pa_pg);
+	hve->partition_assist_page = partition_assist_page;
 	hve->hv_vm_id = (unsigned long)vcpu->kvm;
 	if (!hve->hv_enlightenments_control.nested_flush_hypercall) {
 		hve->hv_enlightenments_control.nested_flush_hypercall = 1;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index be20a60047b1..cb4591405f14 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -523,22 +523,14 @@ module_param(enlightened_vmcs, bool, 0444);
 static int hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
 {
 	struct hv_enlightened_vmcs *evmcs;
-	struct hv_partition_assist_pg **p_hv_pa_pg =
-			&to_kvm_hv(vcpu->kvm)->hv_pa_pg;
-	/*
-	 * Synthetic VM-Exit is not enabled in current code and so All
-	 * evmcs in singe VM shares same assist page.
-	 */
-	if (!*p_hv_pa_pg)
-		*p_hv_pa_pg = kzalloc(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
+	hpa_t partition_assist_page = hv_get_partition_assist_page(vcpu);
 
-	if (!*p_hv_pa_pg)
+	if (partition_assist_page == INVALID_PAGE)
 		return -ENOMEM;
 
 	evmcs = (struct hv_enlightened_vmcs *)to_vmx(vcpu)->loaded_vmcs->vmcs;
 
-	evmcs->partition_assist_page =
-		__pa(*p_hv_pa_pg);
+	evmcs->partition_assist_page = partition_assist_page;
 	evmcs->hv_vm_id = (unsigned long)vcpu->kvm;
 	evmcs->hv_enlightenments_control.nested_flush_hypercall = 1;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d632931fa545..cc2524598368 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12425,7 +12425,9 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 
 void kvm_arch_free_vm(struct kvm *kvm)
 {
-	kfree(to_kvm_hv(kvm)->hv_pa_pg);
+#if IS_ENABLED(CONFIG_HYPERV)
+	kfree(kvm->arch.hv_pa_pg);
+#endif
 	__kvm_arch_free_vm(kvm);
 }
 
-- 
2.41.0

