Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8391D69B7EC
	for <lists+kvm@lfdr.de>; Sat, 18 Feb 2023 04:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjBRDXe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 22:23:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjBRDXc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 22:23:32 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90ABF6C018
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 19:23:30 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id g63-20020a25db42000000b00889c54916f2so2061241ybf.14
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 19:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gbSTlN/R7sFLt7NEbeV1LfkNJ13li3QgpciXxHucdPA=;
        b=E0v+pTVBD+PSap3EzWQTe4YgZHdD3KpfYSMjGDEHoHtzSZA1YJl3ulfRCks+5Owyt5
         K6bRvtd7t4remMKuC1QA4CbInOm8Az9V70RCAmA4TTxkqVnGM3kryG4h/xiYALh/WZn+
         w+A0HqPccdEyRgRY0A5xCezTI1SSIYjvDzBSVfaRn+YCUIOK2xRRIlz88uDHe+G0p7n4
         lkeU7LLh50RJJ1qAuNVL5TfJuMwNIJNl501QI1ZVV13ldXugMj40GTYVUYC4IUMSBUjB
         fqGcKmqbuvYciJjKCMa/1ST96oCjo+imza9ssRGIstb5qvD397xkVtqaceDQKchyWNkn
         82qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gbSTlN/R7sFLt7NEbeV1LfkNJ13li3QgpciXxHucdPA=;
        b=zzKNLgMeNARGtnkgYm/5Utw7M3V14zX6ygLR5l0J/cyW2AEBFF/+jCAqYMLhB+vDEI
         5objTAzaxuel21GFQoVNASthrS/D684FpIzsOPUu0nwkt47TFiNmaa73WMgqEekethC3
         6axV2bdKiTRVnW3fYuBpXtHfHK+E1+jnJeVUZRSs6oTQHNRyCn7nbTQ4gyZQwwvxPax8
         HOWdmIovZpK96cTwLR3BVvZB7eMAZgdhfz7i0bzip20T5as3OeMZu1k/VSPTMt10bPvI
         ntWYkCyRkDzURkia5EhEASZj036sPlHT7Um9VwoKmqrng/ZxNvhAfTg8WNxBm7mhCQJL
         g3EQ==
X-Gm-Message-State: AO0yUKUjpeV6Trga2/T2Cf0PpCulaHGnw7QWMhZ9PSFnAxKHyx7GG9bC
        JplnyGfFKgzzKp9M84Zgg7WDSxJWY91h4Q==
X-Google-Smtp-Source: AK7set+v9+2nJ8bLXXnFa4tQDFP6zCdWRXjm1KjqbKbtydcgLmUPwO9K33R4Fjrw+bmLxEo8QVvkvA80BWj83w==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:4703:0:b0:527:3e8:5a94 with SMTP id
 u3-20020a814703000000b0052703e85a94mr1004218ywa.68.1676690609825; Fri, 17 Feb
 2023 19:23:29 -0800 (PST)
Date:   Sat, 18 Feb 2023 03:23:10 +0000
In-Reply-To: <20230218032314.635829-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230218032314.635829-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230218032314.635829-9-ricarkol@google.com>
Subject: [PATCH v4 08/12] KVM: arm64: Add KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
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
 Documentation/virt/kvm/api.rst    | 26 ++++++++++++++++++++++++++
 arch/arm64/include/asm/kvm_host.h | 19 +++++++++++++++++++
 arch/arm64/kvm/arm.c              | 22 ++++++++++++++++++++++
 arch/arm64/kvm/mmu.c              |  3 +++
 include/uapi/linux/kvm.h          |  1 +
 5 files changed, 71 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9807b05a1b57..a9332e331cce 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8284,6 +8284,32 @@ structure.
 When getting the Modified Change Topology Report value, the attr->addr
 must point to a byte where the value will be stored or retrieved from.
 
+8.40 KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
+---------------------------------------
+
+:Capability: KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
+:Architectures: arm64
+:Type: vm
+:Parameters: arg[0] is the new chunk size.
+:Returns: 0 on success, -EINVAL if any memslot has been created.
+
+This capability sets the chunk size used in Eager Page Splitting.
+
+Eager Page Splitting improves the performance of dirty-logging (used
+in live migrations) when guest memory is backed by huge-pages.  This
+optimization is enabled by default on arm64. It avoids splitting
+huge-pages (into PAGE_SIZE pages) on fault, by doing it eagerly when
+enabling dirty logging (with the KVM_MEM_LOG_DIRTY_PAGES flag for a
+memory region), or when using KVM_CLEAR_DIRTY_LOG.
+
+The chunk size specifies how many pages to break at a time, using a
+single allocation for each chunk. Bigger the chunk size, more pages
+need to be allocated ahead of time. A good heuristic is to pick the
+size of the huge-pages as the chunk size.
+
+If the chunk size (arg[0]) is zero, then no eager page splitting is
+performed. The default value PMD size (e.g., 2M when PAGE_SIZE is 4K).
+
 9. Known KVM API problems
 =========================
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 35a159d131b5..1445cbf6295e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -153,6 +153,25 @@ struct kvm_s2_mmu {
 	/* The last vcpu id that ran on each physical CPU */
 	int __percpu *last_vcpu_ran;
 
+#define KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT	PMD_SIZE
+	/*
+	 * Memory cache used to split
+	 * KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE worth of huge pages. It
+	 * is used to allocate stage2 page tables while splitting huge
+	 * pages. Note that the choice of EAGER_PAGE_SPLIT_CHUNK_SIZE
+	 * influences both the capacity of the split page cache, and
+	 * how often KVM reschedules. Be wary of raising CHUNK_SIZE
+	 * too high.
+	 *
+	 * A good heuristic to pick CHUNK_SIZE is that it should be
+	 * the size of the huge-pages backing guest memory. If not
+	 * known, the PMD size (usually 2M) is a good guess.
+	 *
+	 * Protected by kvm->slots_lock.
+	 */
+	struct kvm_mmu_memory_cache split_page_cache;
+	uint64_t split_page_chunk_size;
+
 	struct kvm_arch *arch;
 };
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9c5573bc4614..c80617ced599 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -101,6 +101,22 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		r = 0;
 		set_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags);
 		break;
+	case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
+		mutex_lock(&kvm->lock);
+		mutex_lock(&kvm->slots_lock);
+		/*
+		 * To keep things simple, allow changing the chunk
+		 * size only if there are no memslots created.
+		 */
+		if (!kvm_are_all_memslots_empty(kvm)) {
+			r = -EINVAL;
+		} else {
+			r = 0;
+			kvm->arch.mmu.split_page_chunk_size = cap->args[0];
+		}
+		mutex_unlock(&kvm->slots_lock);
+		mutex_unlock(&kvm->lock);
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -298,6 +314,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
 		r = system_has_full_ptr_auth();
 		break;
+	case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
+		if (kvm)
+			r = kvm->arch.mmu.split_page_chunk_size;
+		else
+			r = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
+		break;
 	default:
 		r = 0;
 	}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 812633a75e74..e2ada6588017 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -755,6 +755,9 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	for_each_possible_cpu(cpu)
 		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
 
+	mmu->split_page_cache.gfp_zero = __GFP_ZERO;
+	mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
+
 	mmu->pgt = pgt;
 	mmu->pgd_phys = __pa(pgt->pgd);
 	return 0;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 55155e262646..02e05f7918e2 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1175,6 +1175,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
 #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
 #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
+#define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 226
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.39.2.637.g21b0678d19-goog

