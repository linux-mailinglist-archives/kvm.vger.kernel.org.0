Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFB01F0289
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 23:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgFEVoK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 17:44:10 -0400
Received: from mga04.intel.com ([192.55.52.120]:22537 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728418AbgFEVjK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 17:39:10 -0400
IronPort-SDR: uIc5YCn6PR90XQU4J8UYqd9wwHW38E2GscHOZfTegIYLYgGyx8o7lfjOqsMUMfSm0wPLa+vkxD
 jgI62UOGwVPQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2020 14:39:09 -0700
IronPort-SDR: H8FtkyTkq+kfR3GM/MSnkl6Fv5ZNCYmvyGw5Iw2YQz/49QgCjYUqVBtIE3U1lDEulgImpTXOAe
 egrvLr8RD3rQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,477,1583222400"; 
   d="scan'208";a="287860911"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga002.jf.intel.com with ESMTP; 05 Jun 2020 14:39:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Zyngier <maz@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>,
        Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 15/21] KVM: Move x86's MMU memory cache helpers to common KVM code
Date:   Fri,  5 Jun 2020 14:38:47 -0700
Message-Id: <20200605213853.14959-16-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200605213853.14959-1-sean.j.christopherson@intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move x86's memory cache helpers to common KVM code so that they can be
reused by arm64 and MIPS in future patches.

Suggested-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c   | 53 --------------------------------------
 include/linux/kvm_host.h |  7 +++++
 virt/kvm/kvm_main.c      | 55 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+), 53 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b85d3e8e8403..a627437f73fd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1060,47 +1060,6 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 	local_irq_enable();
 }
 
-static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
-					       gfp_t gfp_flags)
-{
-	gfp_flags |= mc->gfp_zero;
-
-	if (mc->kmem_cache)
-		return kmem_cache_alloc(mc->kmem_cache, gfp_flags);
-	else
-		return (void *)__get_free_page(gfp_flags);
-}
-
-static int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
-{
-	void *obj;
-
-	if (mc->nobjs >= min)
-		return 0;
-	while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
-		obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
-		if (!obj)
-			return mc->nobjs >= min ? 0 : -ENOMEM;
-		mc->objects[mc->nobjs++] = obj;
-	}
-	return 0;
-}
-
-static int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
-{
-	return mc->nobjs;
-}
-
-static void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
-{
-	while (mc->nobjs) {
-		if (mc->kmem_cache)
-			kmem_cache_free(mc->kmem_cache, mc->objects[--mc->nobjs]);
-		else
-			free_page((unsigned long)mc->objects[--mc->nobjs]);
-	}
-}
-
 static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 {
 	int r;
@@ -1132,18 +1091,6 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
 
-static void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
-{
-	void *p;
-
-	if (WARN_ON(!mc->nobjs))
-		p = mmu_memory_cache_alloc_obj(mc, GFP_ATOMIC | __GFP_ACCOUNT);
-	else
-		p = mc->objects[--mc->nobjs];
-	BUG_ON(!p);
-	return p;
-}
-
 static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
 {
 	return kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d38d6b9c24be..802b9e2306f0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -815,6 +815,13 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
 void kvm_flush_remote_tlbs(struct kvm *kvm);
 void kvm_reload_remote_mmus(struct kvm *kvm);
 
+#ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
+int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
+int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc);
+void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc);
+void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
+#endif
+
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 				 struct kvm_vcpu *except,
 				 unsigned long *vcpu_bitmap, cpumask_var_t tmp);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4db151f6101e..fead5f1d5594 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -342,6 +342,61 @@ void kvm_reload_remote_mmus(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
 }
 
+#ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
+static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
+					       gfp_t gfp_flags)
+{
+	gfp_flags |= mc->gfp_zero;
+
+	if (mc->kmem_cache)
+		return kmem_cache_alloc(mc->kmem_cache, gfp_flags);
+	else
+		return (void *)__get_free_page(gfp_flags);
+}
+
+int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
+{
+	void *obj;
+
+	if (mc->nobjs >= min)
+		return 0;
+	while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
+		obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
+		if (!obj)
+			return mc->nobjs >= min ? 0 : -ENOMEM;
+		mc->objects[mc->nobjs++] = obj;
+	}
+	return 0;
+}
+
+int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
+{
+	return mc->nobjs;
+}
+
+void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
+{
+	while (mc->nobjs) {
+		if (mc->kmem_cache)
+			kmem_cache_free(mc->kmem_cache, mc->objects[--mc->nobjs]);
+		else
+			free_page((unsigned long)mc->objects[--mc->nobjs]);
+	}
+}
+
+void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
+{
+	void *p;
+
+	if (WARN_ON(!mc->nobjs))
+		p = mmu_memory_cache_alloc_obj(mc, GFP_ATOMIC | __GFP_ACCOUNT);
+	else
+		p = mc->objects[--mc->nobjs];
+	BUG_ON(!p);
+	return p;
+}
+#endif
+
 static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 {
 	mutex_init(&vcpu->mutex);
-- 
2.26.0

