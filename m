Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 106CC6B56AB
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 01:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbjCKAZg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 19:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbjCKAYm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 19:24:42 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07FB13FF07
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:23:56 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id n139-20020a25d691000000b00b1f2dad8a21so7480250ybg.10
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678494224;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=N+pTW/7tamt2IbWqj09PuRke2TPGqju0w/Y+Ey0MO8s=;
        b=TX207gWxU4fl6z+RQW+zgREYFd4cytj/8tZI2zkqObrsMjl10KdJrGM7q7WTP5BOZO
         DLzQ5VWBQnNxCbVf2+cQfzIXI2zYHKEkWEpr61vTyWUf1I6R86u7aEJttHbobxIZO1Rr
         wVnaUWJDjIJy9hGRnN9kp5vaAQq8hjOjzD3OwUEvbaSXDsqjfNp+/9yet1+LMyjg+hSH
         Z9+g65wP4Zbnz/J9mWJkkvJA7OGYRysmwD27lA/eCXxws3+k9tERGBRPk5aJu3/Qu5AP
         cC1dzmy98Ceg7CX3vuaG00oNgtqXqbPeF9m0P0uprlHmrwBfXlYgWw3L9RzBsjlqF1nF
         Fqkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678494224;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N+pTW/7tamt2IbWqj09PuRke2TPGqju0w/Y+Ey0MO8s=;
        b=XqKENYC6yl+s9tE2EWGfahIYP4zK1Ku7c6MGYPGCLiuwi7ZFL7Iz58v+ZFPnuPwRrV
         gw6XXx1UD018Z3MHMINMc64fsoUHSDgscfzD8sOFoWQOQ2rNULo5vMI+zKrbqmbTYwoe
         Ze1Npjco+h381Y/shKcnhLqFzVTPVXXle60c8QPQg9u1WUJ6IxBcStprRDflMZX+UpB5
         eiKX6wY8ZGokVYXHBSXTyIEw8yB54v9IjgYAKXJeYjmAw9hLsGgvQoR/Y3mUizPBXBRl
         cVZHlT9M3ylrAbECQ8+72fBrjrqq6sjHF9Fy2ZYx613b0D8QekbRemqMu4/DCeF+8cls
         Fsbg==
X-Gm-Message-State: AO0yUKW7LCHCHtN1f9ElzuVix7PAogtVlq4727yfG7uf1J5VeFq/XvW2
        tTofYyauFqIOg8AUOw39E8O124dvSEg=
X-Google-Smtp-Source: AK7set+PhmN8Vt5Sg9+9k+BbkcNTAAL0L3IO4DJekk9kppHHOYe5KBYbxmQ3nKmARwfzkGtntaBVjMChv4E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:c0b:0:b0:80b:4f92:1623 with SMTP id
 f11-20020a5b0c0b000000b0080b4f921623mr9ybq.370.1678494223739; Fri, 10 Mar
 2023 16:23:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 16:22:51 -0800
In-Reply-To: <20230311002258.852397-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230311002258.852397-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230311002258.852397-21-seanjc@google.com>
Subject: [PATCH v2 20/27] KVM: x86/mmu: Use page-track notifiers iff there are
 external users
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Disable the page-track notifier code at compile time if there are no
external users, i.e. if CONFIG_KVM_EXTERNAL_WRITE_TRACKING=n.  KVM itself
now hooks emulated writes directly instead of relying on the page-track
mechanism.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h       |  2 ++
 arch/x86/include/asm/kvm_page_track.h |  2 ++
 arch/x86/kvm/mmu/page_track.c         |  9 ++++-----
 arch/x86/kvm/mmu/page_track.h         | 29 +++++++++++++++++++++++----
 4 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1a4225237564..a3423711e403 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1265,7 +1265,9 @@ struct kvm_arch {
 	 * create an NX huge page (without hanging the guest).
 	 */
 	struct list_head possible_nx_huge_pages;
+#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
 	struct kvm_page_track_notifier_head track_notifier_head;
+#endif
 	/*
 	 * Protects marking pages unsync during page faults, as TDP MMU page
 	 * faults only take mmu_lock for read.  For simplicity, the unsync
diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index deece45936a5..53c2adb25a07 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -55,6 +55,7 @@ void kvm_slot_page_track_remove_page(struct kvm *kvm,
 				     struct kvm_memory_slot *slot, gfn_t gfn,
 				     enum kvm_page_track_mode mode);
 
+#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
 enum pg_level kvm_page_track_max_mapping_level(struct kvm *kvm, gfn_t gfn,
 					       enum pg_level max_level);
 
@@ -64,5 +65,6 @@ kvm_page_track_register_notifier(struct kvm *kvm,
 void
 kvm_page_track_unregister_notifier(struct kvm *kvm,
 				   struct kvm_page_track_notifier_node *n);
+#endif /* CONFIG_KVM_EXTERNAL_WRITE_TRACKING */
 
 #endif
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index a21200df515d..619ec8e5fd32 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -194,6 +194,7 @@ bool kvm_slot_page_track_is_active(struct kvm *kvm,
 	return !!READ_ONCE(slot->arch.gfn_track[mode][index]);
 }
 
+#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
 void kvm_page_track_cleanup(struct kvm *kvm)
 {
 	struct kvm_page_track_notifier_head *head;
@@ -255,14 +256,13 @@ EXPORT_SYMBOL_GPL(kvm_page_track_unregister_notifier);
  * The node should figure out if the written page is the one that node is
  * interested in by itself.
  */
-void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
-			  int bytes)
+void __kvm_page_track_write(struct kvm *kvm, gpa_t gpa, const u8 *new, int bytes)
 {
 	struct kvm_page_track_notifier_head *head;
 	struct kvm_page_track_notifier_node *n;
 	int idx;
 
-	head = &vcpu->kvm->arch.track_notifier_head;
+	head = &kvm->arch.track_notifier_head;
 
 	if (hlist_empty(&head->track_notifier_list))
 		return;
@@ -273,8 +273,6 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 		if (n->track_write)
 			n->track_write(gpa, new, bytes, n);
 	srcu_read_unlock(&head->track_srcu, idx);
-
-	kvm_mmu_track_write(vcpu, gpa, new, bytes);
 }
 
 /*
@@ -317,3 +315,4 @@ enum pg_level kvm_page_track_max_mapping_level(struct kvm *kvm, gfn_t gfn,
 	return max_level;
 }
 EXPORT_SYMBOL_GPL(kvm_page_track_max_mapping_level);
+#endif
diff --git a/arch/x86/kvm/mmu/page_track.h b/arch/x86/kvm/mmu/page_track.h
index 89712f123ad3..931b26b8fc8f 100644
--- a/arch/x86/kvm/mmu/page_track.h
+++ b/arch/x86/kvm/mmu/page_track.h
@@ -6,8 +6,6 @@
 
 #include <asm/kvm_page_track.h>
 
-int kvm_page_track_init(struct kvm *kvm);
-void kvm_page_track_cleanup(struct kvm *kvm);
 
 bool kvm_page_track_write_tracking_enabled(struct kvm *kvm);
 int kvm_page_track_write_tracking_alloc(struct kvm_memory_slot *slot);
@@ -21,13 +19,36 @@ bool kvm_slot_page_track_is_active(struct kvm *kvm,
 				   const struct kvm_memory_slot *slot,
 				   gfn_t gfn, enum kvm_page_track_mode mode);
 
-void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
-			  int bytes);
+#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
+int kvm_page_track_init(struct kvm *kvm);
+void kvm_page_track_cleanup(struct kvm *kvm);
+
+void __kvm_page_track_write(struct kvm *kvm, gpa_t gpa, const u8 *new, int bytes);
 void kvm_page_track_delete_slot(struct kvm *kvm, struct kvm_memory_slot *slot);
 
 static inline bool kvm_page_track_has_external_user(struct kvm *kvm)
 {
 	return hlist_empty(&kvm->arch.track_notifier_head.track_notifier_list);
 }
+#else
+static inline int kvm_page_track_init(struct kvm *kvm) { return 0; }
+static inline void kvm_page_track_cleanup(struct kvm *kvm) { }
+
+static inline void __kvm_page_track_write(struct kvm *kvm, gpa_t gpa,
+					  const u8 *new, int bytes) { }
+static inline void kvm_page_track_delete_slot(struct kvm *kvm,
+					      struct kvm_memory_slot *slot) { }
+
+static inline bool kvm_page_track_has_external_user(struct kvm *kvm) { return false; }
+
+#endif /* CONFIG_KVM_EXTERNAL_WRITE_TRACKING */
+
+static inline void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
+					const u8 *new, int bytes)
+{
+	__kvm_page_track_write(vcpu->kvm, gpa, new, bytes);
+
+	kvm_mmu_track_write(vcpu, gpa, new, bytes);
+}
 
 #endif /* __KVM_X86_PAGE_TRACK_H */
-- 
2.40.0.rc1.284.g88254d51c5-goog

