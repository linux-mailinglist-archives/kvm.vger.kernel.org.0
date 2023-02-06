Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653EC68C404
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 17:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbjBFQ7O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 11:59:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbjBFQ7J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 11:59:09 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19092298F8
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 08:59:08 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id u3-20020a056a00124300b0056d4ab0c7cbso6681788pfi.7
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 08:59:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zzlWyFCqYcyGZzCULhoOstPX7ibhNXtVEONcSJrj+Jc=;
        b=HLLwmkjhmxTQyNCpagTXJVAaLKpNx2dLM8cXIXmhfJJrAbw7EzlGzw9IIkSRHpWfB8
         yZwe45G0Sz7zaQstlj05xgJ7A0wYxWQa4KELG/b8qLQqrtwFJP2oJX0cxvA+xtaW0UJd
         OJlWkCjV9c/dHAjZUXQsrgcYU2kqrCPF9CzUpK7Sn9ppmsadmTh7vnl8e/ZvlfCTthdu
         nMcMxOxHEQcfRGFDT6iWKL7Bcm4DZdsFoIkUe3aZNVb5wrBqcOVwzuEEc1VCvy3h7Jny
         pZkPEo7joA2IZE0YvtDqIFuoiXw8UQkOf8jTTtJwvL+4pC1CCTVyx3X0PEqycNfnXSQj
         IdSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zzlWyFCqYcyGZzCULhoOstPX7ibhNXtVEONcSJrj+Jc=;
        b=EN12PnqEt7WS5dK9DRmM9zvL7R6nlbTQmzHZLO/NtWCeTAnxltdMjrstQ05BA4GKLf
         jL6sYew2FxITJ4qKk62EA/Zrsa+e3ixX1kEsodBHpM6fGG+UGs+XjaFY2Ofp2lraWRhE
         hFQZxiu5XHsg2U5Ss0iOJ5HXZIRESbCosrsxGlZuA1gm2Q6VHdATCvX/L0zfqOajnBXb
         2ADqXqu7F3WyN3xEqud0Hwg4FeGoXKw4JAs3H0KuH+e139dYj6lWV7Zoh3P9cOyw9w6f
         DOAHouVp1RdGWdnbkiN2Ig+qO3IaivBY19cEqVU+vC7mSddjZ07qUVY+7xJ0aEcTh695
         BSvA==
X-Gm-Message-State: AO0yUKVuU9M1LDqLG0cSNaAfvL3ZUpdY6zEnZRHm19hSPzxqvygXPt4K
        +0v3cEe/rNytSbA7rh1XJ8IF1abMRMl2EA==
X-Google-Smtp-Source: AK7set9Sa9xH8cDy8qU28rf3Jsx4C/c70O1Yy7vzzH+DlFlqSo6pRcMhNRkBnC7LJI7dyxBps1pSsMsrhU2vDA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:2c05:b0:230:97d5:a224 with SMTP
 id m5-20020a17090a2c0500b0023097d5a224mr56108pjd.122.1675702747618; Mon, 06
 Feb 2023 08:59:07 -0800 (PST)
Date:   Mon,  6 Feb 2023 16:58:47 +0000
In-Reply-To: <20230206165851.3106338-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230206165851.3106338-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206165851.3106338-9-ricarkol@google.com>
Subject: [PATCH v2 08/12] KVM: arm64: Add KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
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
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/arm.c              | 22 ++++++++++++++++++++++
 arch/arm64/kvm/mmu.c              |  3 +++
 include/uapi/linux/kvm.h          |  1 +
 5 files changed, 54 insertions(+)

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
index 35a159d131b5..a69a815719cf 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -153,6 +153,8 @@ struct kvm_s2_mmu {
 	/* The last vcpu id that ran on each physical CPU */
 	int __percpu *last_vcpu_ran;
 
+#define KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT	PMD_SIZE
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
2.39.1.519.gcb327c4b5f-goog

