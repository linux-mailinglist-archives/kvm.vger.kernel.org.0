Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68BA1774F12
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 01:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbjHHXNw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 19:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbjHHXNl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 19:13:41 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE971995
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 16:13:40 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d4e1be2dd10so4149213276.0
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 16:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691536420; x=1692141220;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EbIRM778vEtJ8vWvhEMC2KLHHOEdIHGrq5z82YRomuQ=;
        b=bKvtNHGSvuJp2zqnSdoMkiGVpjkiGLOxNjSdkIgER1Zdna1MWeHTf9G9gAIOW6bDNu
         ZJm9xaGVD14fHa3fYBaKXTeFMtYpHZo20pdswwAUkBImXBacCufsZFDb5raNvi4h+28W
         i3AOuKTe1lqg90upzZfwofEHk1NTsWkytPLN6wQ/qeOLTv8ZxQQLGXH6Q0qxQz1An7xM
         Ku6ZWNtvVot/oo9ROsoKcbt4dAQdiDq8etGt/0YX943OPvbH+t/iOzucdKC/SFHiFYb7
         OTWFNaQW3q3Otg2LOg2Qd4esvihImxDOuOGWjRln2q12LolXg4KMvnUbhd4/HPRsTcfv
         Sh+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691536420; x=1692141220;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EbIRM778vEtJ8vWvhEMC2KLHHOEdIHGrq5z82YRomuQ=;
        b=ZowYbRHN31guHhjkySWBRpYNdSbHmq5+xXu/joRtGMEf+f5/aON4G9EM14e/AfhE8S
         IJF8OAz8d/gE9RDnE40xjtdTRtbCMVyyYUSluwJX5Dqjex/NOUQ9Yd2aV+p/iWD2Zfjl
         WNUMqypuh+fvsG2Xb/xxVyPGVFyrsTmpre8Xpo9oqj6U8jgQhYt7ellfXRgYIIhbzx3F
         qComBiI17CWmSMG1OlZcQyyT3Ixo1vwRzQhD+UfcuA/5dBHK+PF3GApW0xJY+/dujiWX
         W0tH+KhoLOmQILUH9G+iGzodD+ySbhj4aqFk0kz7pjIAQgoSnaYyEwPkD0ZZjbOfA+1g
         No/g==
X-Gm-Message-State: AOJu0YyHfWtSuGMJa4rgrqgTsZB7bhkWScr8lOt7CSlWGVX7qC6+l00/
        kdPvO95dbVdegkh8BoUwxEGEZ0RBicej
X-Google-Smtp-Source: AGHT+IHaShLlv9O1yBtKO3H2sibMGhr0bad7TgyyGlfrw9JZmZ9g7Xq+c+3UitlQEGZVwD9RTySQ7Yzi+Jp+
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a25:860e:0:b0:d5d:511b:16da with SMTP id
 y14-20020a25860e000000b00d5d511b16damr19364ybk.2.1691536419844; Tue, 08 Aug
 2023 16:13:39 -0700 (PDT)
Date:   Tue,  8 Aug 2023 23:13:21 +0000
In-Reply-To: <20230808231330.3855936-1-rananta@google.com>
Mime-Version: 1.0
References: <20230808231330.3855936-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230808231330.3855936-6-rananta@google.com>
Subject: [PATCH v8 05/14] KVM: Allow range-based TLB invalidation from common code
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        David Matlack <dmatlack@google.com>,
        Fuad Tabba <tabba@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>,
        Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Matlack <dmatlack@google.com>

Make kvm_flush_remote_tlbs_range() visible in common code and create a
default implementation that just invalidates the whole TLB.

This paves the way for several future features/cleanups:

 - Introduction of range-based TLBI on ARM.
 - Eliminating kvm_arch_flush_remote_tlbs_memslot()
 - Moving the KVM/x86 TDP MMU to common code.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu/mmu.c          |  8 ++++----
 arch/x86/kvm/mmu/mmu_internal.h |  3 ---
 include/linux/kvm_host.h        | 12 ++++++++++++
 virt/kvm/kvm_main.c             | 13 +++++++++++++
 5 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a2d3cfc2eb75c..b547d17c58f63 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1804,6 +1804,8 @@ static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 		return -ENOTSUPP;
 }
 
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
+
 #define kvm_arch_pmi_in_guest(vcpu) \
 	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ec169f5c7dce2..6adbe6c870982 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -278,16 +278,16 @@ static inline bool kvm_available_flush_remote_tlbs_range(void)
 	return kvm_x86_ops.flush_remote_tlbs_range;
 }
 
-void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,
-				 gfn_t nr_pages)
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,
+				      u64 nr_pages)
 {
 	int ret = -EOPNOTSUPP;
 
 	if (kvm_x86_ops.flush_remote_tlbs_range)
 		ret = static_call(kvm_x86_flush_remote_tlbs_range)(kvm, start_gfn,
 								   nr_pages);
-	if (ret)
-		kvm_flush_remote_tlbs(kvm);
+
+	return ret;
 }
 
 static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index d39af5639ce97..86cb83bb34804 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -170,9 +170,6 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn,
 				    int min_level);
 
-void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,
-				 gfn_t nr_pages);
-
 /* Flush the given page (huge or not) of guest memory. */
 static inline void kvm_flush_remote_tlbs_gfn(struct kvm *kvm, gfn_t gfn, int level)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ade5d4500c2ce..f0be5d9c37dd1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1359,6 +1359,7 @@ int kvm_vcpu_yield_to(struct kvm_vcpu *target);
 void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool yield_to_kernel_mode);
 
 void kvm_flush_remote_tlbs(struct kvm *kvm);
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 nr_pages);
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
@@ -1488,6 +1489,17 @@ static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
 #endif
 
+#ifndef __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
+static inline int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
+						    gfn_t gfn, u64 nr_pages)
+{
+	return -EOPNOTSUPP;
+}
+#else
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
+				      gfn_t gfn, u64 nr_pages);
+#endif
+
 #ifdef __KVM_HAVE_ARCH_NONCOHERENT_DMA
 void kvm_arch_register_noncoherent_dma(struct kvm *kvm);
 void kvm_arch_unregister_noncoherent_dma(struct kvm *kvm);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d6b0507861550..26e91000f579d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -366,6 +366,19 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
 
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 nr_pages)
+{
+	if (!kvm_arch_flush_remote_tlbs_range(kvm, gfn, nr_pages))
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
2.41.0.640.ga95def55d0-goog

