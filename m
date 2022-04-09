Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 694DD4FA0C2
	for <lists+kvm@lfdr.de>; Sat,  9 Apr 2022 02:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240219AbiDIAlU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 20:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240171AbiDIAlC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 20:41:02 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5022C6ECA
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 17:38:57 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id x3-20020a17090a6c0300b001cab7230b41so6275377pjj.9
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 17:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=DzOG1dO8rYMP0yi3T5wLKRfSac9FjtUBvTnGYR4alpQ=;
        b=WtYztDD216TMxeTmU1+93Vo6j0ypbZQLo/2zSPbj43phg1CTvw3awsFCfI71alMGS9
         e8kWXpgvmRDrKh6pnVORjsJxwneusGrEBKQfmqpFXgGVejPFBToNquTD/whrAiBlcNRG
         5fHpYO6wvgcN2j6x9HxFmtPxfK2BQzDcN16jVQlcZtA7psZlaIzB+yIah8F37Swvr9qz
         pZQHygc0TEEEADDxf5MJJgxqBHiBPKzOSkC5QtKOnciPI80ly61muRqsd6qS6qVBhs+u
         m9mqkdlRq6Ww5DRdi0a5Gnlf5lUkCR1+xIZnolpVUcRXS/MjCUpYiy14rtbAhgLgIuYY
         fxRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=DzOG1dO8rYMP0yi3T5wLKRfSac9FjtUBvTnGYR4alpQ=;
        b=AVOJUTTyKCgtVMUtktnULzToqW70kYJax7EYmjjhrtj37gpHcvhpIx2tthTm22kVGd
         +eW0b8Bg2XFgwV55TO91jR+AiLEaZxRbH4cT/JDyglCxSEZo5/NSZr3dWuAZKxGDQYl9
         VG4E7bcRZ+t+UKimjmqkWhKYa075H1Y1Q5SF0LJaEM83mFkR/ViFd0tjGft3z3+D1y61
         zSpUPuNjGvgzCZvL2gGgc1YcfGcliiVtuL5LsYomgeqjutGts6OdImCtZsIZIazVqYvw
         TiSzwMrJOkqDiKNIKxXw4fEJNWem+94dWimwrVLKZgrL1W7eCKbMCCeWB4HhYkfDIlLv
         CaVw==
X-Gm-Message-State: AOAM532WcWNa+ZqhbT6Tp/9JfvZ4LuZ1MFHZG3lJJv/tIZ0izNnkriz9
        HTeqhxpWcQMBH9Cqy91C6gLSrOJEJBk=
X-Google-Smtp-Source: ABdhPJw9csYsc/Q1poUULGW/tqgne+GSOH5TWq8ojK98JToAzK/+EaEdJLeQeOF8h4a1kZ3UCKgSDEWdays=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:d2c3:b0:157:ebe:25c5 with SMTP id
 n3-20020a170902d2c300b001570ebe25c5mr10049047plc.59.1649464737391; Fri, 08
 Apr 2022 17:38:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  9 Apr 2022 00:38:45 +0000
In-Reply-To: <20220409003847.819686-1-seanjc@google.com>
Message-Id: <20220409003847.819686-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220409003847.819686-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH 4/6] KVM: x86/mmu: Track the number of TDP MMU pages, but not
 the actual pages
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>
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

Track the number of TDP MMU "shadow" pages instead of tracking the pages
themselves. With the NX huge page list manipulation moved out of the common
linking flow, elminating the list-based tracking means the happy path of
adding a shadow page doesn't need to acquire a spinlock and can instead
inc/dec an atomic.

Keep the tracking as the WARN during TDP MMU teardown on leaked shadow
pages is very, very useful for detecting KVM bugs.

Tracking the number of pages will also make it trivial to expose the
counter to userspace as a stat in the future, which may or may not be
desirable.

Note, the TDP MMU needs to use a separate counter (and stat if that ever
comes to be) from the existing n_used_mmu_pages. The TDP MMU doesn't bother
supporting the shrinker nor does it honor KVM_SET_NR_MMU_PAGES (because the
TDP MMU consumes so few pages relative to shadow paging), and including TDP
MMU pages in that counter would break both the shrinker and shadow MMUs,
e.g. if a VM is using nested TDP.

Reviewed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 11 +++--------
 arch/x86/kvm/mmu/tdp_mmu.c      | 19 +++++++++----------
 2 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e4f7e7998928..19a352b5750b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1186,6 +1186,9 @@ struct kvm_arch {
 	 */
 	bool tdp_mmu_enabled;
 
+	/* The number of TDP MMU pages across all roots. */
+	atomic64_t tdp_mmu_pages;
+
 	/*
 	 * List of struct kvm_mmu_pages being used as roots.
 	 * All struct kvm_mmu_pages in the list should have
@@ -1206,18 +1209,10 @@ struct kvm_arch {
 	 */
 	struct list_head tdp_mmu_roots;
 
-	/*
-	 * List of struct kvmp_mmu_pages not being used as roots.
-	 * All struct kvm_mmu_pages in the list should have
-	 * tdp_mmu_page set and a tdp_mmu_root_count of 0.
-	 */
-	struct list_head tdp_mmu_pages;
-
 	/*
 	 * Protects accesses to the following fields when the MMU lock
 	 * is held in read mode:
 	 *  - tdp_mmu_roots (above)
-	 *  - tdp_mmu_pages (above)
 	 *  - the link field of struct kvm_mmu_pages used by the TDP MMU
 	 *  - possible_nx_huge_pages;
 	 *  - the possible_nx_huge_page_link field of struct kvm_mmu_pages used
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 9966735601a6..d0e6b341652c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -29,7 +29,6 @@ int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 	kvm->arch.tdp_mmu_enabled = true;
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
 	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
-	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
 	kvm->arch.tdp_mmu_zap_wq = wq;
 	return 1;
 }
@@ -54,7 +53,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	/* Also waits for any queued work items.  */
 	destroy_workqueue(kvm->arch.tdp_mmu_zap_wq);
 
-	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_pages));
+	WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
 	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
 
 	/*
@@ -386,16 +385,18 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
 			      bool shared)
 {
+	atomic64_dec(&kvm->arch.tdp_mmu_pages);
+
+	if (!sp->nx_huge_page_disallowed)
+		return;
+
 	if (shared)
 		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	else
 		lockdep_assert_held_write(&kvm->mmu_lock);
 
-	list_del(&sp->link);
-	if (sp->nx_huge_page_disallowed) {
-		sp->nx_huge_page_disallowed = false;
-		untrack_possible_nx_huge_page(kvm, sp);
-	}
+	sp->nx_huge_page_disallowed = false;
+	untrack_possible_nx_huge_page(kvm, sp);
 
 	if (shared)
 		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
@@ -1123,9 +1124,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 		tdp_mmu_set_spte(kvm, iter, spte);
 	}
 
-	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
-	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
-	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+	atomic64_inc(&kvm->arch.tdp_mmu_pages);
 
 	return 0;
 }
-- 
2.35.1.1178.g4f1659d476-goog

