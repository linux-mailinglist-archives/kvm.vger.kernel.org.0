Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344A96DBEE5
	for <lists+kvm@lfdr.de>; Sun,  9 Apr 2023 08:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjDIGa0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Apr 2023 02:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjDIGaW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Apr 2023 02:30:22 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFEE06A57
        for <kvm@vger.kernel.org>; Sat,  8 Apr 2023 23:30:19 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-632cf80572bso217439b3a.3
        for <kvm@vger.kernel.org>; Sat, 08 Apr 2023 23:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681021818; x=1683613818;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LTdZbFSU/751OSOyYOxKL9fHdH3jkfed2ZTa4dAt9zk=;
        b=HZDs7aqDNXsJ9RN4aH5phzvvTEmpG3V+78mv8742KdY47AFk63ErxhAifXU2Yeiz1e
         bjdI5s2FkJalGQ51FlpYfFmKqJjsXHS8wMi/wzfWSu9XAdHE6u+O3rM/WC70uEGtdcoi
         aibmOVHG7tsN98CeOrx04/lP3opX6GnCFxH0651QziUWtBDS8Qb8N43Fc0Eb57HvE01g
         c2MSmWLemNwkCj7/etuBFKmTJhs53DtA1uNJwGGS3slQeP8Crsub4gqKeGTFhh+cb4Ba
         Pm8+Y6fVJMDAhXQjHAHOdYtHUAJOQHT+FRKcsaJtwdnkiQ0vHbhCcuIbkuBJpvUpuEfM
         NvTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681021818; x=1683613818;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LTdZbFSU/751OSOyYOxKL9fHdH3jkfed2ZTa4dAt9zk=;
        b=KMu2A5L5Dk2G/PVhG7pNJXvXheGYPqJ/w+Ec+Ofpy9fRzh2H4nYR0dj7L3mz9l94oP
         gjzY/Je52WziEMC4mkcz9V6ULoPpqdB0CyoeT4tpqP2HWGRa/uGz4+U/Zu3wa8LfmsRm
         iM1gvXzM6FT6Q+iPcbxrW20tIxRYiPz0H11IJL4VBDNXXXO8qu6Phw4QbASlIKHZ5JYj
         E5haaEYcDf++CaBqoryTstrGvjKBmjPozRPb8PBTGGC9WVaSukdOyU4k8csxhE8C69D8
         2TIlvNP2GRJKg8nKy2icRCQWFjZzgR0ak9m0I1IVHMzoyQX6ojAKgHvqa7ohAOaa7srQ
         6yxQ==
X-Gm-Message-State: AAQBX9em7ygVeZnaeC8MpJ+iLTHT8bCGMl83ho/rlsAV0nyHCDBr7wl6
        LEH7hZqA5jP+yQg80EQLFOh2D+dTkiMTYg==
X-Google-Smtp-Source: AKy350bCvyUyyfSycEw9EqPn5D3eqNmd/GH5Ut255EHU6PpSDn+jysdSgW847z4k/QCqWgSdLregKQNOXTT4xQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:2e8c:b0:5e6:f9a1:e224 with SMTP
 id fd12-20020a056a002e8c00b005e6f9a1e224mr3519311pfb.6.1681021818686; Sat, 08
 Apr 2023 23:30:18 -0700 (PDT)
Date:   Sun,  9 Apr 2023 06:29:56 +0000
In-Reply-To: <20230409063000.3559991-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230409063000.3559991-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230409063000.3559991-10-ricarkol@google.com>
Subject: [PATCH v7 08/12] KVM: arm64: Add KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
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
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
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
---
 Documentation/virt/kvm/api.rst       | 28 ++++++++++++++++++++++++++
 arch/arm64/include/asm/kvm_host.h    | 15 ++++++++++++++
 arch/arm64/include/asm/kvm_pgtable.h | 18 +++++++++++++++++
 arch/arm64/kvm/arm.c                 | 30 ++++++++++++++++++++++++++++
 arch/arm64/kvm/mmu.c                 |  3 +++
 include/uapi/linux/kvm.h             |  2 ++
 6 files changed, 96 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 62de0768d6aa5..f8faa80d87057 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8380,6 +8380,34 @@ structure.
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
+block sizes is exposed in KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES as a 64bit
+bitmap (each bit describing a block size). Setting
+KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE to 0 disables Eager Page Splitting;
+this is the default value.
+
 9. Known KVM API problems
 =========================
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a1892a8f60323..b87da1ebc3454 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -158,6 +158,21 @@ struct kvm_s2_mmu {
 	/* The last vcpu id that ran on each physical CPU */
 	int __percpu *last_vcpu_ran;
 
+#define KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT 0
+	/*
+	 * Memory cache used to split
+	 * KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE worth of huge pages. It
+	 * is used to allocate stage2 page tables while splitting huge
+	 * pages. Note that the choice of EAGER_PAGE_SPLIT_CHUNK_SIZE
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
index 32e5d42bf020f..889bd7afeb355 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -92,6 +92,24 @@ static inline bool kvm_level_supports_block_mapping(u32 level)
 	return level >= KVM_PGTABLE_MIN_BLOCK_LEVEL;
 }
 
+static inline u64 kvm_supported_block_sizes(void)
+{
+	u32 level = KVM_PGTABLE_MIN_BLOCK_LEVEL;
+	u64 res = 0;
+
+	for (; level < KVM_PGTABLE_MAX_LEVELS; level++)
+		res |= BIT(kvm_granule_shift(level));
+
+	return res;
+}
+
+static inline bool kvm_is_block_size_supported(u64 size)
+{
+	bool is_power_of_two = !((size) & ((size)-1));
+
+	return is_power_of_two && (size & kvm_supported_block_sizes());
+}
+
 /**
  * struct kvm_pgtable_mm_ops - Memory management callbacks.
  * @zalloc_page:		Allocate a single zeroed memory page.
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3bd732eaf0872..34fd3c59a9b82 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -67,6 +67,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap)
 {
 	int r;
+	u64 new_cap;
 
 	if (cap->flags)
 		return -EINVAL;
@@ -91,6 +92,26 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		r = 0;
 		set_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags);
 		break;
+	case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
+		new_cap = cap->args[0];
+
+		mutex_lock(&kvm->lock);
+		mutex_lock(&kvm->slots_lock);
+		/*
+		 * To keep things simple, allow changing the chunk
+		 * size only if there are no memslots already created.
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
+		mutex_unlock(&kvm->lock);
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -288,6 +309,15 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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
index a2800e5c42712..898985b09321a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -756,6 +756,9 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	for_each_possible_cpu(cpu)
 		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
 
+	mmu->split_page_cache.gfp_zero = __GFP_ZERO;
+	mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
+
 	mmu->pgt = pgt;
 	mmu->pgd_phys = __pa(pgt->pgd);
 	return 0;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d77aef872a0a0..f18b48fcd25ba 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1184,6 +1184,8 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
 #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
 #define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
+#define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 227
+#define KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES 228
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.40.0.577.gac1e443424-goog

