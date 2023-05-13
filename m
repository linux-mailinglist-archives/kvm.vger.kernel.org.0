Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B523701365
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 02:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241937AbjEMAiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 20:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241490AbjEMAhK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 20:37:10 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874A983E1
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:36:50 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-560ee0df572so61600837b3.0
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683938203; x=1686530203;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hNTik0/0UAnGvXxFBg6CjU0vW+QeN858B9iSPENSKds=;
        b=Kdiw20OuBRsezAHx+rIgkcONlr0U5XnnkhugCfPaLfNs5PJZcjDn+jpkzCXdWoJ9Lm
         P8rK21jB07nt1HXRZoGfuxGkDjCJiQGc84BrP9bhexBJHk8pEKT5F4kpACqEkC+XNz4w
         om26S1hCuLKLdPMeB+FEN2VFduzG2+Gba9FIvjPaK2PmD4cYtxNVP9m6FpsNE26sn0SN
         yJf6+nlkK8NBSH/CCjL9A8n9NJpe1Swm4WrFdNHIpRrThUmv1Iwxyf/o/rgz1vtQR/YN
         revnbZGzBpDNd5Kxs9Oi2AS7p1ARdu2Oz80Fcy2G1SGH6hHZKRyaAGgPrCAIdYaKAVYx
         oBZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683938203; x=1686530203;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hNTik0/0UAnGvXxFBg6CjU0vW+QeN858B9iSPENSKds=;
        b=hgEiNK1tTNvvVarmHMTUeY4lxcJzSNIehijAkmpZ3CZjm2VhveDL7raACCQbkSKU9u
         huBZvmWQfPT1ll0qGSxhTe+YZ8glcu6fVhRcJD4AJ/2pnckd8WVzwsDs2oxQ7mKiSI11
         PDJC3mC7KLHf+0eVzl8OAiAnJqGjCgetxLK+YUJZAtLnkEkUAmZ2+3Rafgecos6RMk2W
         FKT71/GRxYF4EZPg134dy6n2gJBpm8pDyE3VK0/0Yg09roNOOPJRCND8+aOL3Ibgu2IN
         z4U0eJVrJsTqw1XdpKNz6X+6Q3ixQbwqxyB86ynPRFI2iQF9ac8VkercJlOHFlHei/zL
         KxCg==
X-Gm-Message-State: AC+VfDzayvZNtYY0Zv8NqMyVsMcmfODx3SbLcjrbHMhJFzxT7GHM28sF
        lfYl3PsnwasJ13dxb+QXeFVIviSBY5Q=
X-Google-Smtp-Source: ACHHUZ7qa7XG4WcWo9X8HH4DPF0ACsPuRYcUe6lP1TURWV4tQYl2ES3JidqkBWzm78+cCjHPRDUyR4yhjy8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ad55:0:b0:561:3149:d684 with SMTP id
 l21-20020a81ad55000000b005613149d684mr1092128ywk.10.1683938203590; Fri, 12
 May 2023 17:36:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 May 2023 17:35:52 -0700
In-Reply-To: <20230513003600.818142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230513003600.818142-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230513003600.818142-21-seanjc@google.com>
Subject: [PATCH v3 20/28] KVM: x86/mmu: Move KVM-only page-track declarations
 to internal header
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bury the declaration of the page-track helpers that are intended only for
internal KVM use in a "private" header.  In addition to guarding against
unwanted usage of the internal-only helpers, dropping their definitions
avoids exposing other structures that should be KVM-internal, e.g. for
memslots.  This is a baby step toward making kvm_host.h a KVM-internal
header in the very distant future.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_page_track.h | 21 ++---------------
 arch/x86/kvm/mmu/mmu.c                |  3 ++-
 arch/x86/kvm/mmu/page_track.c         |  8 +------
 arch/x86/kvm/mmu/page_track.h         | 33 +++++++++++++++++++++++++++
 arch/x86/kvm/x86.c                    |  1 +
 5 files changed, 39 insertions(+), 27 deletions(-)
 create mode 100644 arch/x86/kvm/mmu/page_track.h

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 5c348ffdc194..76c0070dfe2a 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -2,6 +2,8 @@
 #ifndef _ASM_X86_KVM_PAGE_TRACK_H
 #define _ASM_X86_KVM_PAGE_TRACK_H
 
+#include <linux/kvm_types.h>
+
 enum kvm_page_track_mode {
 	KVM_PAGE_TRACK_WRITE,
 	KVM_PAGE_TRACK_MAX,
@@ -46,26 +48,12 @@ struct kvm_page_track_notifier_node {
 				    struct kvm_page_track_notifier_node *node);
 };
 
-int kvm_page_track_init(struct kvm *kvm);
-void kvm_page_track_cleanup(struct kvm *kvm);
-
-bool kvm_page_track_write_tracking_enabled(struct kvm *kvm);
-int kvm_page_track_write_tracking_alloc(struct kvm_memory_slot *slot);
-
-void kvm_page_track_free_memslot(struct kvm_memory_slot *slot);
-int kvm_page_track_create_memslot(struct kvm *kvm,
-				  struct kvm_memory_slot *slot,
-				  unsigned long npages);
-
 void kvm_slot_page_track_add_page(struct kvm *kvm,
 				  struct kvm_memory_slot *slot, gfn_t gfn,
 				  enum kvm_page_track_mode mode);
 void kvm_slot_page_track_remove_page(struct kvm *kvm,
 				     struct kvm_memory_slot *slot, gfn_t gfn,
 				     enum kvm_page_track_mode mode);
-bool kvm_slot_page_track_is_active(struct kvm *kvm,
-				   const struct kvm_memory_slot *slot,
-				   gfn_t gfn, enum kvm_page_track_mode mode);
 
 void
 kvm_page_track_register_notifier(struct kvm *kvm,
@@ -73,10 +61,5 @@ kvm_page_track_register_notifier(struct kvm *kvm,
 void
 kvm_page_track_unregister_notifier(struct kvm *kvm,
 				   struct kvm_page_track_notifier_node *n);
-void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
-			  int bytes);
-void kvm_page_track_delete_slot(struct kvm *kvm, struct kvm_memory_slot *slot);
-
-bool kvm_page_track_has_external_user(struct kvm *kvm);
 
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3f9030650c3d..0d9fe54ecb01 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -25,6 +25,7 @@
 #include "kvm_cache_regs.h"
 #include "smm.h"
 #include "kvm_emulate.h"
+#include "page_track.h"
 #include "cpuid.h"
 #include "spte.h"
 
@@ -53,7 +54,7 @@
 #include <asm/io.h>
 #include <asm/set_memory.h>
 #include <asm/vmx.h>
-#include <asm/kvm_page_track.h>
+
 #include "trace.h"
 
 extern bool itlb_multihit_kvm_mitigation;
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 2a6ab7c455c0..e15329d48f95 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -15,10 +15,9 @@
 #include <linux/kvm_host.h>
 #include <linux/rculist.h>
 
-#include <asm/kvm_page_track.h>
-
 #include "mmu.h"
 #include "mmu_internal.h"
+#include "page_track.h"
 
 bool kvm_page_track_write_tracking_enabled(struct kvm *kvm)
 {
@@ -300,8 +299,3 @@ void kvm_page_track_delete_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
 			n->track_remove_region(slot->base_gfn, slot->npages, n);
 	srcu_read_unlock(&head->track_srcu, idx);
 }
-
-bool kvm_page_track_has_external_user(struct kvm *kvm)
-{
-	return hlist_empty(&kvm->arch.track_notifier_head.track_notifier_list);
-}
diff --git a/arch/x86/kvm/mmu/page_track.h b/arch/x86/kvm/mmu/page_track.h
new file mode 100644
index 000000000000..89712f123ad3
--- /dev/null
+++ b/arch/x86/kvm/mmu/page_track.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_X86_PAGE_TRACK_H
+#define __KVM_X86_PAGE_TRACK_H
+
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_page_track.h>
+
+int kvm_page_track_init(struct kvm *kvm);
+void kvm_page_track_cleanup(struct kvm *kvm);
+
+bool kvm_page_track_write_tracking_enabled(struct kvm *kvm);
+int kvm_page_track_write_tracking_alloc(struct kvm_memory_slot *slot);
+
+void kvm_page_track_free_memslot(struct kvm_memory_slot *slot);
+int kvm_page_track_create_memslot(struct kvm *kvm,
+				  struct kvm_memory_slot *slot,
+				  unsigned long npages);
+
+bool kvm_slot_page_track_is_active(struct kvm *kvm,
+				   const struct kvm_memory_slot *slot,
+				   gfn_t gfn, enum kvm_page_track_mode mode);
+
+void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
+			  int bytes);
+void kvm_page_track_delete_slot(struct kvm *kvm, struct kvm_memory_slot *slot);
+
+static inline bool kvm_page_track_has_external_user(struct kvm *kvm)
+{
+	return hlist_empty(&kvm->arch.track_notifier_head.track_notifier_list);
+}
+
+#endif /* __KVM_X86_PAGE_TRACK_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6ae2b612f8c6..5b689b144516 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -25,6 +25,7 @@
 #include "tss.h"
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
+#include "mmu/page_track.h"
 #include "x86.h"
 #include "cpuid.h"
 #include "pmu.h"
-- 
2.40.1.606.ga4b1b128d6-goog

