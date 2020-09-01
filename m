Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC19C258ED3
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 15:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgIANCd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 09:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727986AbgIALzh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 07:55:37 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E194EC061245;
        Tue,  1 Sep 2020 04:55:27 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id b124so635285pfg.13;
        Tue, 01 Sep 2020 04:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=r0QoArXlGym3eWpJEYZx+lz57ZLvZb2kHtV5tNtHzJ4=;
        b=NjMzwBPSfFvdU2O/KMV3opnSnYvg/vZTty9uMb1o23rL9uxH4u0UZOoL+j0tkXZ4F6
         lz3q9pGjs75qa3zXVM7dp3MmS9PSiwX7RayOXSQWftB1aDQ8Dlfin+1RxD6LCaKtxnU3
         XFiWt3IQyvuyI2lK5A+EwjMlT7bkpJQQxHw3wnqJKmWd8/ZNYs0ETXUonKvIIDjBLow4
         FsbgiDkWaM4yJa5kOdi3lphACsU84efVDBmxUZImyJeTFzWfEjSiNQ42WZbvce/wK/Cx
         JTmCWptmtzSGRrWbtYcZTcHVN7u3X2ZnyUKAqXtCbM1mIcRE+gCSnixUxgPT6aGl7mXw
         aJJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=r0QoArXlGym3eWpJEYZx+lz57ZLvZb2kHtV5tNtHzJ4=;
        b=qcaMvx5dL/bkOwPt1lGYxBMHdESXlUMnJgyf7ZSPeLZAK4dbQ5h6SBdMCshIR/Zy1K
         OLLNcA3LePdjuaJXpY3MUD3Gz6rT9TfbVIb6xg6TEeB/0FeRHDe6UvDZ+8MmPGarL5G6
         pd4TjnV7uxKqfYogwm5kk4w0lPJ+Fq7mJcUg6tPzdeDM6bnT8kH048+H3kfg9SoC3gNS
         wq4Q9FOqVIGdBS8aT+QwaI+bZmtyiC5prsc2m46co28YlJZlaJ8pW7aPZtdnOL4nTtl0
         xNhLtPYx/IdMfo0x86DSFHEjXJJACeWKnMX7n4kyUgECmQIURGB+WLHIh6aZtQxYPc6A
         ogRA==
X-Gm-Message-State: AOAM53272+qA07pMbil98W4HjdXzBLf2ay/yUOwyfhuXS1M93AXP6w4B
        e2j3ijMTynOe837pyXg7yU6kX2Uasl4=
X-Google-Smtp-Source: ABdhPJwIfk+L03i7+RG1LZTgGssrXJ8ifRcqMziLfzmkhsyzdMfmxtCxY0Ji3Rc8Kxlro/rMjBg9Hg==
X-Received: by 2002:a63:f909:: with SMTP id h9mr1182770pgi.250.1598961327411;
        Tue, 01 Sep 2020 04:55:27 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.53])
        by smtp.gmail.com with ESMTPSA id z17sm1738614pfq.38.2020.09.01.04.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 04:55:27 -0700 (PDT)
From:   yulei.kernel@gmail.com
X-Google-Original-From: yuleixzhang@tencent.com
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        junaids@google.com, bgardon@google.com, vkuznets@redhat.com,
        xiaoguangrong.eric@gmail.com, kernellwp@gmail.com,
        lihaiwei.kernel@gmail.com, Yulei Zhang <yulei.kernel@gmail.com>,
        Yulei Zhang <yuleixzhang@tencent.com>
Subject: [RFC V2 6/9] Apply the direct build EPT according to the memory slots change
Date:   Tue,  1 Sep 2020 19:56:22 +0800
Message-Id: <1f8000f25664b4feb97db2c72e68f6740e680e60.1598868204.git.yulei.kernel@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1598868203.git.yulei.kernel@gmail.com>
References: <cover.1598868203.git.yulei.kernel@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yulei Zhang <yulei.kernel@gmail.com>

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
index 7de85d2253ff..05d053a53ebf 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -267,6 +267,19 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
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
index 13999123b735..c6964cbeb6da 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -715,6 +715,19 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
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
index 6b74b92c1a58..d6f7cf1a30a3 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5021,6 +5021,19 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
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
index fda6c4196854..47d2a1c18f36 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5206,13 +5206,20 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 {
 	int r;
 
-	r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->direct_map);
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
+		r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->direct_map);
+		if (r)
+			goto out;
+		r = mmu_alloc_roots(vcpu);
+		kvm_mmu_sync_roots(vcpu);
+		if (r)
+			goto out;
+	}
 	kvm_mmu_load_pgd(vcpu);
 	kvm_x86_ops.tlb_flush_current(vcpu);
 out:
@@ -6464,6 +6471,17 @@ int direct_build_mapping_level(struct kvm *kvm, struct kvm_memory_slot *slot, gf
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
@@ -6498,6 +6516,7 @@ int kvm_direct_tdp_populate_page_table(struct kvm *kvm, struct kvm_memory_slot *
 		direct_build_tdp_map(kvm, slot, gfn, pfn, host_level);
 	}
 
+	kvm_make_direct_build_update(kvm);
 	return 0;
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8901862ba2a3..b2aa0daad6dd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -694,6 +694,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
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
index 47fc18b05c53..fd1b419f4eb4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -876,6 +876,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 #endif
 	kvm_arch_destroy_vm(kvm);
 	kvm_destroy_devices(kvm);
+	kvm_direct_tdp_release_global_root(kvm);
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
 		kvm_free_memslots(kvm, __kvm_memslots(kvm, i));
 	cleanup_srcu_struct(&kvm->irq_srcu);
@@ -1195,6 +1196,10 @@ static int kvm_set_memslot(struct kvm *kvm,
 		 * in the freshly allocated memslots, not in @old or @new.
 		 */
 		slot = id_to_memslot(slots, old->id);
+		/* Remove pre-constructed page table */
+		if (!as_id)
+			kvm_direct_tdp_remove_page_table(kvm, slot);
+
 		slot->flags |= KVM_MEMSLOT_INVALID;
 
 		/*
@@ -1222,6 +1227,14 @@ static int kvm_set_memslot(struct kvm *kvm,
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

