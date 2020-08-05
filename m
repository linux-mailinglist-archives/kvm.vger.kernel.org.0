Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02BB023D15C
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 22:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbgHET71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727923AbgHEQmM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 12:42:12 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E27DC0086CC;
        Wed,  5 Aug 2020 07:14:06 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id kr4so4596050pjb.2;
        Wed, 05 Aug 2020 07:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=E6c0vghDkgEJ0a17A5+nuiHJ8D+179IgnQgcYz9dqaY=;
        b=YyYLES4lVVS0AwqF8KdFgvecU0rZ54MrgMfyenfeLVgPDjqeuE0TXmuAwbL39GI83J
         +brndbF+IwazD77a1klVuX3ccA7g93HF0Jhw/5QZqelQ5ejP+7SdCxbEgepXRveNIakf
         fWKicNGvCF+nNVi7kGy87yWOaspd6wZV4f+I0fSYIzNQ30POtG1mhkdMsTWz0ymGOJNa
         PouGZ2f5APwS3hygkDzHtxk9sZGHV9Z/3LWxkzdAkEkX+7jfsU2yKEMQhxZFcJpwKaMG
         Y2Vhxv/9VGGTXx695Mr4MizLST/MMzRNNimq54cwCS2JUY2tFJTiiCNGa9Cb7ypzWOXR
         L3lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=E6c0vghDkgEJ0a17A5+nuiHJ8D+179IgnQgcYz9dqaY=;
        b=kG6jjb2MlMARf54JssL0VErD5V8l4e1RviW8DNLtBKN3xHNt2oVmcDj0ymdkXoZ1gS
         c/imZo/mBb87jqPoghozo1JJhjO5Lanj4tOzsfuMi3Gp3AIbQzXg6UxFsMrtPRxmKabv
         mNYKufABxbb+Z0hQrV0MYbn/jU6pT4Rz+8CA/1xjvPwSZkvl9s+3PeM0dmkTfwfyrUVN
         /Ta/UVOgPzsZFIISP/r2fisrCLKS9JuB2BLCF8E7jLbNCCRRuVVE5pCzeVZkidapI+s+
         Dn0MpugDv5lDlAkWWBdTLDbtjqfWeyUwW/JH/gJvdXDAwS+KTU6bLk0mSshti5lW4X1T
         6TbQ==
X-Gm-Message-State: AOAM530hFfA6lZYiIivb/SE96OTJTJ3bnRNekdOsN80wLQgthdhOWSBH
        9Sfn+B9uPpL25GYZfpFFFS8u7BeW
X-Google-Smtp-Source: ABdhPJzGOtBj5jUOCmkzH/oXkJ+Jepgq3ah12aPXmimlVn1IaRS0eaGFAJXfoQebV2bsdecMhUPtWQ==
X-Received: by 2002:a17:90a:3d02:: with SMTP id h2mr3432297pjc.15.1596636845691;
        Wed, 05 Aug 2020 07:14:05 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.62])
        by smtp.gmail.com with ESMTPSA id p20sm3141184pjz.49.2020.08.05.07.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 07:14:04 -0700 (PDT)
From:   Yulei Zhang <yulei.kernel@gmail.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, xiaoguangrong.eric@gmail.com,
        kernellwp@gmail.com, lihaiwei.kernel@gmail.com,
        Yulei Zhang <yuleixzhang@tencent.com>
Subject: [RFC 6/9] Apply the direct build EPT according to the memory slots change
Date:   Wed,  5 Aug 2020 22:14:56 +0800
Message-Id: <20200805141456.9234-1-yulei.kernel@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yulei Zhang <yuleixzhang@tencent.com>

Construct the direct build ept when guest memory slots have been
changed, and issue mmu_reload request to update the CR3 so that
guest could use the pre-constructed EPT without page fault.

Signed-off-by: Yulei Zhang <yuleixzhang@tencent.com>
---
 arch/mips/kvm/mips.c       | 13 +++++++++++++
 arch/powerpc/kvm/powerpc.c | 13 +++++++++++++
 arch/s390/kvm/kvm-s390.c   | 13 +++++++++++++
 arch/x86/kvm/mmu/mmu.c     | 33 ++++++++++++++++++++++++++-------
 include/linux/kvm_host.h   |  3 +++
 virt/kvm/kvm_main.c        | 13 +++++++++++++
 6 files changed, 81 insertions(+), 7 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 8f05dd0a0f4e..7e5608769696 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -257,6 +257,19 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	}
 }
 
+int kvm_direct_tdp_populate_page_table(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	return 0;
+}
+
+void kvm_direct_tdp_remove_page_table(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+}
+
+void kvm_direct_tdp_release_global_root(struct kvm *kvm)
+{
+}
+
 static inline void dump_handler(const char *symbol, void *start, void *end)
 {
 	u32 *p;
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index ad2f172c26a6..93066393e09d 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -712,6 +712,19 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	kvmppc_core_commit_memory_region(kvm, mem, old, new, change);
 }
 
+int kvm_direct_tdp_populate_page_table(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	return 0;
+}
+
+void kvm_direct_tdp_remove_page_table(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+}
+
+void kvm_direct_tdp_release_global_root(struct kvm *kvm)
+{
+}
+
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot)
 {
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d05bb040fd42..594c38a7cc9f 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5008,6 +5008,19 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	return;
 }
 
+int kvm_direct_tdp_populate_page_table(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	return 0;
+}
+
+void kvm_direct_tdp_remove_page_table(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+}
+
+void kvm_direct_tdp_release_global_root(struct kvm *kvm)
+{
+}
+
 static inline unsigned long nonhyp_mask(int i)
 {
 	unsigned int nonhyp_fai = (sclp.hmfai << i * 2) >> 30;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b59a4502d1f6..33252e432c1b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5203,13 +5203,20 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 {
 	int r;
 
-	r = mmu_topup_memory_caches(vcpu);
-	if (r)
-		goto out;
-	r = mmu_alloc_roots(vcpu);
-	kvm_mmu_sync_roots(vcpu);
-	if (r)
-		goto out;
+	if (vcpu->kvm->arch.global_root_hpa) {
+		vcpu->arch.direct_build_tdp = true;
+		vcpu->arch.mmu->root_hpa = vcpu->kvm->arch.global_root_hpa;
+	}
+
+	if (!vcpu->arch.direct_build_tdp) {
+		r = mmu_topup_memory_caches(vcpu);
+		if (r)
+			goto out;
+		r = mmu_alloc_roots(vcpu);
+		kvm_mmu_sync_roots(vcpu);
+		if (r)
+			goto out;
+	}
 	kvm_mmu_load_pgd(vcpu);
 	kvm_x86_ops.tlb_flush(vcpu, true);
 out:
@@ -6438,6 +6445,17 @@ int direct_build_mapping_level(struct kvm *kvm, struct kvm_memory_slot *slot, gf
 	return host_level;
 }
 
+static void kvm_make_direct_build_update(struct kvm *kvm)
+{
+	int i;
+	struct kvm_vcpu *vcpu;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
+		kvm_vcpu_kick(vcpu);
+	}
+}
+
 int kvm_direct_tdp_populate_page_table(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
 	gfn_t gfn;
@@ -6472,6 +6490,7 @@ int kvm_direct_tdp_populate_page_table(struct kvm *kvm, struct kvm_memory_slot *
 		direct_build_tdp_map(kvm, slot, gfn, pfn, host_level);
 	}
 
+	kvm_make_direct_build_update(kvm);
 	return 0;
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d1f75ad5038b..767e5c4ed295 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -693,6 +693,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change);
+int kvm_direct_tdp_populate_page_table(struct kvm *kvm, struct kvm_memory_slot *slot);
+void kvm_direct_tdp_remove_page_table(struct kvm *kvm, struct kvm_memory_slot *slot);
+void kvm_direct_tdp_release_global_root(struct kvm *kvm);
 void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, gfn_t gfn);
 /* flush all memory translations */
 void kvm_arch_flush_shadow_all(struct kvm *kvm);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 46217b1c8353..eb0f6ad2f369 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -820,6 +820,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 #endif
 	kvm_arch_destroy_vm(kvm);
 	kvm_destroy_devices(kvm);
+	kvm_direct_tdp_release_global_root(kvm);
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
 		kvm_free_memslots(kvm, __kvm_memslots(kvm, i));
 	cleanup_srcu_struct(&kvm->irq_srcu);
@@ -1139,6 +1140,10 @@ static int kvm_set_memslot(struct kvm *kvm,
 		 * in the freshly allocated memslots, not in @old or @new.
 		 */
 		slot = id_to_memslot(slots, old->id);
+		/* Remove pre-constructed page table */
+		if (!as_id)
+			kvm_direct_tdp_remove_page_table(kvm, slot);
+
 		slot->flags |= KVM_MEMSLOT_INVALID;
 
 		/*
@@ -1166,6 +1171,14 @@ static int kvm_set_memslot(struct kvm *kvm,
 	update_memslots(slots, new, change);
 	slots = install_new_memslots(kvm, as_id, slots);
 
+	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) {
+		if (!as_id) {
+			r = kvm_direct_tdp_populate_page_table(kvm, new);
+			if (r)
+				goto out_slots;
+		}
+	}
+
 	kvm_arch_commit_memory_region(kvm, mem, old, new, change);
 
 	kvfree(slots);
-- 
2.17.1

