Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF2C4ECA1C
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 18:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349078AbiC3Q5A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 12:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345089AbiC3Q47 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 12:56:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 55FE738D90
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 09:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648659312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PSeEyveBA7E0qgl3uhMV5ChCVs00db6iBLbnZKBTXs8=;
        b=N6Eu/3frCyXirQcF9ZTe+P2yq2E374/lci4w4XfReuUno/zbbh6rw1DaJ4aSJkIq0DBq9p
        j5jj/2xZaeQ7+5/8ubhaOif8GjUFnTV6JcAi7WRHw/tJ22PEN/OOf9Fo2gBkMD2GN68L+m
        UrU82dKJ8OtwSBftn2SHi6PvyrQ4QrI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-501-H2VXSEa7Os-ua4FKAy_TlA-1; Wed, 30 Mar 2022 12:55:11 -0400
X-MC-Unique: H2VXSEa7Os-ua4FKAy_TlA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC3CF101A54C;
        Wed, 30 Mar 2022 16:55:10 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A50CEC08F11;
        Wed, 30 Mar 2022 16:55:10 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: MMU: propagate alloc_workqueue failure
Date:   Wed, 30 Mar 2022 12:55:10 -0400
Message-Id: <20220330165510.213111-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If kvm->arch.tdp_mmu_zap_wq cannot be created, the failure has
to be propagated up to kvm_mmu_init_vm and kvm_arch_init_vm.
kvm_arch_init_vm also has to undo all the initialization, so
group all the MMU initialization code at the beginning and
handle cleaning up of kvm_page_track_init.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 11 +++++++++--
 arch/x86/kvm/mmu/tdp_mmu.c      | 17 ++++++++++-------
 arch/x86/kvm/mmu/tdp_mmu.h      |  4 ++--
 arch/x86/kvm/x86.c              | 15 ++++++++++-----
 5 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0ddc2e67a731..469c7702fad9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1584,7 +1584,7 @@ void kvm_mmu_module_exit(void);
 
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_mmu_create(struct kvm_vcpu *vcpu);
-void kvm_mmu_init_vm(struct kvm *kvm);
+int kvm_mmu_init_vm(struct kvm *kvm);
 void kvm_mmu_uninit_vm(struct kvm *kvm);
 
 void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 51671cb34fb6..857ba93b5c92 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5768,17 +5768,24 @@ static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
 	kvm_mmu_zap_all_fast(kvm);
 }
 
-void kvm_mmu_init_vm(struct kvm *kvm)
+int kvm_mmu_init_vm(struct kvm *kvm)
 {
 	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
+	int r;
 
+	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
+	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
+	INIT_LIST_HEAD(&kvm->arch.lpage_disallowed_mmu_pages);
 	spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);
 
-	kvm_mmu_init_tdp_mmu(kvm);
+	r = kvm_mmu_init_tdp_mmu(kvm);
+	if (r < 0)
+		return r;
 
 	node->track_write = kvm_mmu_pte_write;
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
 	kvm_page_track_register_notifier(kvm, node);
+	return 0;
 }
 
 void kvm_mmu_uninit_vm(struct kvm *kvm)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e7e7876251b3..d7c112a29fe9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -14,21 +14,24 @@ static bool __read_mostly tdp_mmu_enabled = true;
 module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);
 
 /* Initializes the TDP MMU for the VM, if enabled. */
-bool kvm_mmu_init_tdp_mmu(struct kvm *kvm)
+int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 {
+	struct workqueue_struct *wq;
+
 	if (!tdp_enabled || !READ_ONCE(tdp_mmu_enabled))
-		return false;
+		return 0;
+
+	wq = alloc_workqueue("kvm", WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE, 0);
+	if (IS_ERR(wq))
+		return PTR_ERR(wq);
 
 	/* This should not be changed for the lifetime of the VM. */
 	kvm->arch.tdp_mmu_enabled = true;
-
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
 	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
-	kvm->arch.tdp_mmu_zap_wq =
-		alloc_workqueue("kvm", WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE, 0);
-
-	return true;
+	kvm->arch.tdp_mmu_zap_wq = wq;
+	return 1;
 }
 
 /* Arbitrarily returns true so that this may be used in if statements. */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 5e5ef2576c81..647926541e38 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -72,7 +72,7 @@ u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
 					u64 *spte);
 
 #ifdef CONFIG_X86_64
-bool kvm_mmu_init_tdp_mmu(struct kvm *kvm);
+int kvm_mmu_init_tdp_mmu(struct kvm *kvm);
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
 static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return sp->tdp_mmu_page; }
 
@@ -93,7 +93,7 @@ static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
 	return sp && is_tdp_mmu_page(sp) && sp->root_count;
 }
 #else
-static inline bool kvm_mmu_init_tdp_mmu(struct kvm *kvm) { return false; }
+static inline int kvm_mmu_init_tdp_mmu(struct kvm *kvm) { return 0; }
 static inline void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm) {}
 static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
 static inline bool is_tdp_mmu(struct kvm_mmu *mmu) { return false; }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fe2171b11441..89b6efb7f504 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11629,12 +11629,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	ret = kvm_page_track_init(kvm);
 	if (ret)
-		return ret;
+		goto out;
+
+	ret = kvm_mmu_init_vm(kvm);
+	if (ret)
+		goto out_page_track;
 
 	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
-	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
-	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
-	INIT_LIST_HEAD(&kvm->arch.lpage_disallowed_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
 	atomic_set(&kvm->arch.noncoherent_dma_count, 0);
 
@@ -11666,10 +11667,14 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	kvm_apicv_init(kvm);
 	kvm_hv_init_vm(kvm);
-	kvm_mmu_init_vm(kvm);
 	kvm_xen_init_vm(kvm);
 
 	return static_call(kvm_x86_vm_init)(kvm);
+
+out_page_track:
+	kvm_page_track_cleanup(kvm);
+out:
+	return ret;
 }
 
 int kvm_arch_post_init_vm(struct kvm *kvm)
-- 
2.31.1

