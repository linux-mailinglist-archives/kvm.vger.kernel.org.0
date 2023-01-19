Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4567967401B
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 18:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjASRge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 12:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbjASRgX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 12:36:23 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC29E90841
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 09:36:21 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id l15-20020a170902f68f00b001948ddc7cddso1738636plg.2
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 09:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uRsWL56kSi67VtsSY7eQAHDzJKepa9d7c1+Ibj0vcQE=;
        b=gdGKLjSmqiX0cZ4pDCgzo2Y0Hyb2rjNgz7MfmYG1QliR3dntIqZmp0W8DNiCubrZO1
         XsKZLH7MrwgaCgv+5+A2LrwtrkYwB/JhwPa0G9QSb1a+ZOBIs/d+0rd6/3sCTB3he/EF
         w+T3HbOsaFwiWm2ryF+AZedsM3RjPq7l/aAuD6VoXBPScK1ekZ0lYVASS6RGuJaLya4i
         y4D1SF2w+A4KK/c/bvLEOBKiq8/KzVXEUr+4XVpi7H/56swFVF2GGkxBdeI5TeL1PB5t
         UFJqbf3AxHGvKpyee1QezxYYmacb1TRuX4uDlTJBNOQNoQU7VIrHZHHOLMTZcAImPV3R
         mrNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uRsWL56kSi67VtsSY7eQAHDzJKepa9d7c1+Ibj0vcQE=;
        b=lPr4O/QFBNWwORYTLIfBypmw6msM4CW34OBFgK9l/lsyO4CAncCXMrBFMgxf/O3Ft0
         SMPlwC91h6b9FITEFSd0jiBmHgJqtLgfAlsZHAj4W1HSkJb/mUAtWoh0Oalf+MVZPGEJ
         TVaghcTgwwwApSlCM8IjVjOeWieonxJC02LNgJPhRAmuKD8q8Dy9LedpH2QkGV721O/t
         qAlEcbzzrmbfFbezL+2TCy3jm0ZUTwATaTkoyE8XDx5AyAcpJ/NurewXIhN7wjGqOvrs
         aJW9j67W8+BoDOPXSMMSpJBJ/26AYvf7Dosy+zaCRhSBI5AosrNvM2lyRNs1RcZK/BIR
         hZ6Q==
X-Gm-Message-State: AFqh2krebYEfcgmcfGXBbRl3DLCMY3zT0VagzBuwEGu80tYkDf2VkJea
        sQUKgJ+9QGD+1tUQydfaZw85of7HvfjYyg==
X-Google-Smtp-Source: AMrXdXt+vZkjJ1zTNoZ5Qo+DVNwjuzxDWfY3Xw9nwrJNx+t6oQZNxW3uxoy7KZtRAAY7IFKfRsyg6/TxW0wYVw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a63:3116:0:b0:477:7f69:2749 with SMTP id
 x22-20020a633116000000b004777f692749mr930497pgx.372.1674149781458; Thu, 19
 Jan 2023 09:36:21 -0800 (PST)
Date:   Thu, 19 Jan 2023 09:35:58 -0800
In-Reply-To: <20230119173559.2517103-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20230119173559.2517103-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230119173559.2517103-7-dmatlack@google.com>
Subject: [PATCH 6/7] KVM: Allow range-based TLB invalidation from common code
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org,
        David Matlack <dmatlack@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make kvm_flush_remote_tlbs_range() visible in common code and create a
default implementation that just invalidates the whole TLB.

This paves the way for several future cleanups:
 - Introduction of range-based TLBI on ARM.
 - Eliminating kvm_arch_flush_remote_tlbs_memslot()
 - Moving the KVM/x86 TDP MMU to common code.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/mmu/mmu.c          |  5 ++---
 arch/x86/kvm/mmu/mmu_internal.h |  1 -
 include/linux/kvm_host.h        |  9 +++++++++
 virt/kvm/kvm_main.c             | 13 +++++++++++++
 5 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1bacc3de2432..420713ac8916 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1799,6 +1799,9 @@ static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 		return -ENOTSUPP;
 }
 
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
+
 #define kvm_arch_pmi_in_guest(vcpu) \
 	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1e2c2d711dbb..491c28d22cbe 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -246,7 +246,7 @@ static inline bool kvm_available_flush_tlb_with_range(void)
 	return kvm_x86_ops.tlb_remote_flush_with_range;
 }
 
-void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages)
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages)
 {
 	struct kvm_tlb_range range;
 	int ret = -EOPNOTSUPP;
@@ -257,8 +257,7 @@ void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages)
 	if (kvm_x86_ops.tlb_remote_flush_with_range)
 		ret = static_call(kvm_x86_tlb_remote_flush_with_range)(kvm, &range);
 
-	if (ret)
-		kvm_flush_remote_tlbs(kvm);
+	return ret;
 }
 
 static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 851982a25502..d5599f2d3f96 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -164,7 +164,6 @@ void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn,
 				    int min_level);
-void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
 
 extern int nx_huge_pages;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 76711afe4d17..acfb17d9b44d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1356,6 +1356,7 @@ int kvm_vcpu_yield_to(struct kvm_vcpu *target);
 void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
 
 void kvm_flush_remote_tlbs(struct kvm *kvm);
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 pages);
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
@@ -1484,6 +1485,14 @@ static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 }
 #endif
 
+#ifndef __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
+static inline int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
+						   gfn_t gfn, u64 pages)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 #ifdef __KVM_HAVE_ARCH_NONCOHERENT_DMA
 void kvm_arch_register_noncoherent_dma(struct kvm *kvm);
 void kvm_arch_unregister_noncoherent_dma(struct kvm *kvm);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fefd3e3c8fe1..c9fc693a39d9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -368,6 +368,19 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
 
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 pages)
+{
+	if (!kvm_arch_flush_remote_tlbs_range(kvm, gfn, pages))
+		return;
+
+	/*
+	 * Fall back to a flushing entire TLBs if the architecture range-based
+	 * TLB invalidation is unsupported or can't be performed for whatever
+	 * reason.
+	 */
+	kvm_flush_remote_tlbs(kvm);
+}
+
 static void kvm_flush_shadow_all(struct kvm *kvm)
 {
 	kvm_arch_flush_shadow_all(kvm);
-- 
2.39.0.246.g2a6d74b583-goog

