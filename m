Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF2F9654A41
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 02:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235773AbiLWBAc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 20:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235901AbiLWA7l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 19:59:41 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741E92180A
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 16:58:24 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id k22-20020aa79736000000b0057f3577fdbaso1825813pfg.8
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 16:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2SF5s6q4/xQUtKV/+KulhfW7DVgHuWHr5hL3mzoDnJI=;
        b=YdyYiN/HfbomLEuoFTeN/yJRSYqp7WrvTDJCOomo3um5lS7K21Qcg1TnOovAxV2rjB
         e4tJI/oGsixBSZKxqJKrHwugFrPyqi16zf68pdsutFUeSEbtOOvQ9ShyozwKlqqbni3c
         jsw19AG0tt3LC59gkMVC2WP0A4DfveSohjEnkIO1k3V2Ax7nO0XOLGhIEh+97Gg8KAjy
         NaAIKLU4QFTYnrdYvYdnCLBHbK1Sd4jEO+Buld9qws+5f/xqz8kvoSsWzUm/UompVcOC
         Qoslt+SebQaRVkTaNf3sT7kRT9/tsUP96ovnJdXU7SeULDICSHpY8nZskPJ9kb7ub6NQ
         BaFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2SF5s6q4/xQUtKV/+KulhfW7DVgHuWHr5hL3mzoDnJI=;
        b=hPnLAVFHn01Q+j9DPFrXOKKaMLadamhjWR5K9xcbdShu+5BDY+e3IMy1RDOWKdk/Z7
         06zOCKW8pyMtPSJmxoeRawlTMaP0Q9mmOV7Ycfn9PmsajlLQeResDzhziZoDSfRM2Apr
         19opdkJ59ipZG96PfMGZ3goVJFjfJC+4xko+W1RoGY7qt8+L7K3Y6W/leiPlvj5zkMBH
         GNhQ4qTcA8kVUEgp4S/nSM2KWXIw9itRaW55961cXqq+EYVBdNXwN/+4QOO7KKL7kI1q
         y6I0jMFZntUwwVbUahfq7TlF2Sn2SnGdXIZGKXRcVAKtDvJ2wNSMUaS+hc+WKZe0+xAy
         YnsA==
X-Gm-Message-State: AFqh2kp9XvZB8zKHpOr9XWAUSrH1yH5BVtANJSBbB3RW9l04j0KcRZB4
        KaSwJJgmgTxsol7tLPtzUXMVPJ0/Qww=
X-Google-Smtp-Source: AMrXdXt0uH8Enm7A+uwjDx/JWL6mLB2GLLsrANJvONxxpHaK9UdS9/AhfXkVYLxnfSrgM4rXXqMd/X6qfkg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:5a4c:0:b0:457:7285:fd2d with SMTP id
 z12-20020a655a4c000000b004577285fd2dmr479521pgs.580.1671757096173; Thu, 22
 Dec 2022 16:58:16 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Dec 2022 00:57:30 +0000
In-Reply-To: <20221223005739.1295925-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221223005739.1295925-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221223005739.1295925-19-seanjc@google.com>
Subject: [PATCH 18/27] KVM: x86/mmu: Move KVM-only page-track declarations to
 internal header
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
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
 arch/x86/include/asm/kvm_page_track.h | 26 ++++-----------------
 arch/x86/kvm/mmu/mmu.c                |  3 ++-
 arch/x86/kvm/mmu/page_track.c         |  8 +------
 arch/x86/kvm/mmu/page_track.h         | 33 +++++++++++++++++++++++++++
 arch/x86/kvm/x86.c                    |  1 +
 5 files changed, 42 insertions(+), 29 deletions(-)
 create mode 100644 arch/x86/kvm/mmu/page_track.h

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index e5eb98ca4fce..deece45936a5 100644
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
@@ -46,28 +48,15 @@ struct kvm_page_track_notifier_node {
 				    struct kvm_page_track_notifier_node *node);
 };
 
-int kvm_page_track_init(struct kvm *kvm);
-void kvm_page_track_cleanup(struct kvm *kvm);
-
-bool kvm_page_track_write_tracking_enabled(struct kvm *kvm);
-int kvm_page_track_write_tracking_alloc(struct kvm_memory_slot *slot);
-enum pg_level kvm_page_track_max_mapping_level(struct kvm *kvm, gfn_t gfn,
-					       enum pg_level max_level);
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
+
+enum pg_level kvm_page_track_max_mapping_level(struct kvm *kvm, gfn_t gfn,
+					       enum pg_level max_level);
 
 void
 kvm_page_track_register_notifier(struct kvm *kvm,
@@ -75,10 +64,5 @@ kvm_page_track_register_notifier(struct kvm *kvm,
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
index dfeddea8148a..6477ef435575 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -24,6 +24,7 @@
 #include "kvm_cache_regs.h"
 #include "smm.h"
 #include "kvm_emulate.h"
+#include "page_track.h"
 #include "cpuid.h"
 #include "spte.h"
 
@@ -51,7 +52,7 @@
 #include <asm/io.h>
 #include <asm/set_memory.h>
 #include <asm/vmx.h>
-#include <asm/kvm_page_track.h>
+
 #include "trace.h"
 
 extern bool itlb_multihit_kvm_mitigation;
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index d2b9f7f183cc..2b302fd2c5dd 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -14,10 +14,9 @@
 #include <linux/kvm_host.h>
 #include <linux/rculist.h>
 
-#include <asm/kvm_page_track.h>
-
 #include "mmu.h"
 #include "mmu_internal.h"
+#include "page_track.h"
 
 bool kvm_page_track_write_tracking_enabled(struct kvm *kvm)
 {
@@ -317,8 +316,3 @@ enum pg_level kvm_page_track_max_mapping_level(struct kvm *kvm, gfn_t gfn,
 	return max_level;
 }
 EXPORT_SYMBOL_GPL(kvm_page_track_max_mapping_level);
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
index f372c41ee2c2..41d47a23396c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -24,6 +24,7 @@
 #include "tss.h"
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
+#include "mmu/page_track.h"
 #include "x86.h"
 #include "cpuid.h"
 #include "pmu.h"
-- 
2.39.0.314.g84b9a713c41-goog

