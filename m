Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F5C6EF943
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 19:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236151AbjDZRX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 13:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235034AbjDZRXw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 13:23:52 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4DC7EC1
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 10:23:43 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-556011695d1so98517897b3.1
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 10:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682529822; x=1685121822;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IFzo8XjuuizBeGWowIZmgP246/LseFE5Cr2zD0Zbm28=;
        b=ztvcXADxnzYDYOZIx+RsRBmYMhcqkE5mTKB+wjIS2o8Tqp9sFSk3Y41+ry4f80sLrV
         /8uQvJs4/42xQkOU1qpqETJamHe+Ro0x1G3JPb7wSftVna3Ztde6jKofDDt1/Pa3hV8H
         EwDuTZjGF2p3/uJiaEkHShf9afC+Vyi+JF5naMUOsIgeez7PbObJR2/TwWNc4fLq0irS
         MhKC8OSvXO6x1l8K/xrmDamF8zdVakRt6ZcEjVM6Pb0vVocIAslumWv2UtSiA8Stic2u
         ey0jtgaErIWEexLBcXiHzJCZzy/HAahv7+9Ame63sNhkZcM+Z3qCudAA59f+msgm54jF
         qqEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682529822; x=1685121822;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IFzo8XjuuizBeGWowIZmgP246/LseFE5Cr2zD0Zbm28=;
        b=dI29x7pXLszsPaJ/IALMyK/QM7E1Z+fsxCYWLT1rJJWMQxgqysCLJOLuhbXB/mIGIz
         cgc6BeK0CTIpK5IteVE5MSlqT+FWed6nPCXOjtwI1sKMyqTJQKBaf7BC2PWPgy8/pdOB
         qMqh5/2htYmvUWclVHz4QrzEWWeHP9G4l14NgfL1pMyMRDnGUOIDcRkJhxmKAPZTLUJg
         zbcJg5RXGiaEAmw292dH6EZ7qpmO/0z0fYTZZDLNY9jgqw17OLW1pxXMdzKcgPZhwCUJ
         gI7W3DMMEGVFZTtuascI5q0WZXchd3nlRsPtZSo9O6WFbkmvTZs4wbUI8rU17//0+Wex
         DQNw==
X-Gm-Message-State: AAQBX9cE7bNL/erQvaCUVKsuCeTfUgKt9+tdLuUp8xY6PHpQSSw3Whb8
        +HvC5Sc/uQYrFt1gUgMUm1WlkuWzbabMVA==
X-Google-Smtp-Source: AKy350bIGzA5VVaovdV+YSloPikoydxymoxdKvjC6CjXkkXp+5p2mRB4oGJjS4IHmEcoLyBaGva9YeGsO0z3uQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a0d:ec48:0:b0:54f:ae82:3f92 with SMTP id
 r8-20020a0dec48000000b0054fae823f92mr10195988ywn.2.1682529822745; Wed, 26 Apr
 2023 10:23:42 -0700 (PDT)
Date:   Wed, 26 Apr 2023 17:23:23 +0000
In-Reply-To: <20230426172330.1439644-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230426172330.1439644-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230426172330.1439644-6-ricarkol@google.com>
Subject: [PATCH v8 05/12] KVM: arm64: Add KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a capability for userspace to specify the eager split chunk size.
The chunk size specifies how many pages to break at a time, using a
single allocation. Bigger the chunk size, more pages need to be
allocated ahead of time.

Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
 Documentation/virt/kvm/api.rst       | 27 +++++++++++++++++++++++++++
 arch/arm64/include/asm/kvm_host.h    | 15 +++++++++++++++
 arch/arm64/include/asm/kvm_pgtable.h | 18 ++++++++++++++++++
 arch/arm64/kvm/arm.c                 | 28 ++++++++++++++++++++++++++++
 arch/arm64/kvm/mmu.c                 |  4 ++++
 include/uapi/linux/kvm.h             |  2 ++
 6 files changed, 94 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 42403dfe94969..7bf8227bce6b3 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8443,6 +8443,33 @@ structure.
 When getting the Modified Change Topology Report value, the attr->addr
 must point to a byte where the value will be stored or retrieved from.
 
+8.40 KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
+---------------------------------------
+
+:Capability: KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
+:Architectures: arm64
+:Type: vm
+:Parameters: arg[0] is the new split chunk size.
+:Returns: 0 on success, -EINVAL if any memslot was already created.
+
+This capability sets the chunk size used in Eager Page Splitting.
+
+Eager Page Splitting improves the performance of dirty-logging (used
+in live migrations) when guest memory is backed by huge-pages.  It
+avoids splitting huge-pages (into PAGE_SIZE pages) on fault, by doing
+it eagerly when enabling dirty logging (with the
+KVM_MEM_LOG_DIRTY_PAGES flag for a memory region), or when using
+KVM_CLEAR_DIRTY_LOG.
+
+The chunk size specifies how many pages to break at a time, using a
+single allocation for each chunk. Bigger the chunk size, more pages
+need to be allocated ahead of time.
+
+The chunk size needs to be a valid block size. The list of acceptable
+block sizes is exposed in KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES as a
+64-bit bitmap (each bit describing a block size). The default value is
+0, to disable the eager page splitting.
+
 9. Known KVM API problems
 =========================
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ce7530968e39c..8d0a4c8a2d13b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -159,6 +159,21 @@ struct kvm_s2_mmu {
 	/* The last vcpu id that ran on each physical CPU */
 	int __percpu *last_vcpu_ran;
 
+#define KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT 0
+	/*
+	 * Memory cache used to split
+	 * KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE worth of huge pages. It
+	 * is used to allocate stage2 page tables while splitting huge
+	 * pages. The choice of KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
+	 * influences both the capacity of the split page cache, and
+	 * how often KVM reschedules. Be wary of raising CHUNK_SIZE
+	 * too high.
+	 *
+	 * Protected by kvm->slots_lock.
+	 */
+	struct kvm_mmu_memory_cache split_page_cache;
+	uint64_t split_page_chunk_size;
+
 	struct kvm_arch *arch;
 };
 
diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 00c8bef4f3ca0..4182d5df70c93 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -92,6 +92,24 @@ static inline bool kvm_level_supports_block_mapping(u32 level)
 	return level >= KVM_PGTABLE_MIN_BLOCK_LEVEL;
 }
 
+static inline u32 kvm_supported_block_sizes(void)
+{
+	u32 level = KVM_PGTABLE_MIN_BLOCK_LEVEL;
+	u32 r = 0;
+
+	for (; level < KVM_PGTABLE_MAX_LEVELS; level++)
+		r |= BIT(kvm_granule_shift(level));
+
+	return r;
+}
+
+static inline bool kvm_is_block_size_supported(u64 size)
+{
+	bool is_power_of_two = IS_ALIGNED(size, size);
+
+	return is_power_of_two && (size & kvm_supported_block_sizes());
+}
+
 /**
  * struct kvm_pgtable_mm_ops - Memory management callbacks.
  * @zalloc_page:		Allocate a single zeroed memory page.
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index bb21d0c25de75..c3056749338a6 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -67,6 +67,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap)
 {
 	int r;
+	u64 new_cap;
 
 	if (cap->flags)
 		return -EINVAL;
@@ -91,6 +92,24 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		r = 0;
 		set_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags);
 		break;
+	case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
+		new_cap = cap->args[0];
+
+		mutex_lock(&kvm->slots_lock);
+		/*
+		 * To keep things simple, allow changing the chunk
+		 * size only when no memory slots have been created.
+		 */
+		if (!kvm_are_all_memslots_empty(kvm)) {
+			r = -EINVAL;
+		} else if (new_cap && !kvm_is_block_size_supported(new_cap)) {
+			r = -EINVAL;
+		} else {
+			r = 0;
+			kvm->arch.mmu.split_page_chunk_size = new_cap;
+		}
+		mutex_unlock(&kvm->slots_lock);
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -303,6 +322,15 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
 		r = system_has_full_ptr_auth();
 		break;
+	case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
+		if (kvm)
+			r = kvm->arch.mmu.split_page_chunk_size;
+		else
+			r = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
+		break;
+	case KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES:
+		r = kvm_supported_block_sizes();
+		break;
 	default:
 		r = 0;
 	}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index efdaab3f154de..7e1cb38d0fc97 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -756,6 +756,10 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	for_each_possible_cpu(cpu)
 		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
 
+	 /* The eager page splitting is disabled by default */
+	mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
+	mmu->split_page_cache.gfp_zero = __GFP_ZERO;
+
 	mmu->pgt = pgt;
 	mmu->pgd_phys = __pa(pgt->pgd);
 	return 0;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 16287a996c324..94e09619b5a48 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1190,6 +1190,8 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
 #define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
 #define KVM_CAP_COUNTER_OFFSET 227
+#define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 228
+#define KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES 229
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.40.1.495.gc816e09b53d-goog

