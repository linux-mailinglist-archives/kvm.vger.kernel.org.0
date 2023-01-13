Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D71668A6E
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 04:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236012AbjAMDuZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 22:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234010AbjAMDuR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 22:50:17 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E46A62191
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:50:15 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id p18-20020a25bd52000000b007c8919c86efso4044039ybm.13
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:50:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JVcZViDTJ/Xiw4oMrZSedmVu2/tzeU9wThwbdEKpe08=;
        b=tePKvf6EmWYEBoYG9dRY4Kc8Qa6b9fp4S9s+0RT8gROI7YwOZchFJ5EsJVYghMGX+x
         WBc8oMtmtcO4PQPQlfnA/XSMktZ3rue8sW2/gapg4HbgqZLi/j3ND5J4QHgPpPTk0OEt
         LLKbhbWwmeMkA4BB20XBwkrg5Uaw3EWSIMGU8AHp/KrJ3s/+fP4zbE+gZhWjfmh++4yR
         KA1WImaDcpohYUoQtSG+BJMBt0cSgVRPfy3EWDC7oDJo4hCZRYxIAYWJJoZV12T8h6i5
         aJGw4oFdJSkc/5JMHgpTkvdhVyFww+Hc+Kgi/5tq/0sA3pvuTKqHdjiQfth3a5fozvBP
         YLzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JVcZViDTJ/Xiw4oMrZSedmVu2/tzeU9wThwbdEKpe08=;
        b=WOeAwMmkCJTBP8SEVf6OieYhdPHZzM7W9ClkIzetdYPIDW4mt5WLGtfA9HxZanDQy1
         Cl2yYJ+yApdF2/Dgi0VJGqwYf9NEIL6scmaRrBqvDsKW/uMBI/pqmAClkcjcMLaOEbq9
         3pQWdC+/YBhkhRPz0gKsQOMHsGucN9QUowpB0xM9UbnW183VUmt9pu6Juz6y2EKbqWrR
         VejcTFh6tseJT92bwAPlVMNeifMCrZ/4K16LH+cf2A/ryXqVg+QOD2VHHDJLh574JQbc
         ci2ImtNurZKJeW8zFlfXUKKvJgd3XlBTvatUb+1OsyrsWt8VBGpBOUrPMbIs00TF61e6
         HhYA==
X-Gm-Message-State: AFqh2kpclvVwYMNs0P/LntuabXCOK615H0Fvk4chHoZUluqLGWxy6Evf
        QoZXgfpd4tOYH66X23xGqB4YfMZmLaqy3Q==
X-Google-Smtp-Source: AMrXdXurHATa35Vs0camgUzuMOcgp363aVN8cu0eKnDnrIA6eR0vdxPzlHA3NYSk3s3xZZQ5OWqvfp1tYgEdyQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a0d:d087:0:b0:3c7:38d8:798f with SMTP id
 s129-20020a0dd087000000b003c738d8798fmr3727770ywd.489.1673581814930; Thu, 12
 Jan 2023 19:50:14 -0800 (PST)
Date:   Fri, 13 Jan 2023 03:49:59 +0000
In-Reply-To: <20230113035000.480021-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230113035000.480021-9-ricarkol@google.com>
Subject: [PATCH 8/9] KVM: arm64: Split huge pages during KVM_CLEAR_DIRTY_LOG
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>
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

This is the arm64 counterpart of commit cb00a70bd4b7 ("KVM: x86/mmu:
Split huge pages mapped by the TDP MMU during KVM_CLEAR_DIRTY_LOG"),
which has the benefit of splitting the cost of splitting a memslot
across multiple ioctls.

Split huge pages on the range specified using KVM_CLEAR_DIRTY_LOG.
And do not split when enabling dirty logging if
KVM_DIRTY_LOG_INITIALLY_SET is set.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/mmu.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 009468822bca..08f28140c4a9 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1076,8 +1076,8 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
  * @mask:	The mask of pages at offset 'gfn_offset' in this memory
  *		slot to enable dirty logging on
  *
- * Writes protect selected pages to enable dirty logging for them. Caller must
- * acquire kvm->mmu_lock.
+ * Splits selected pages to PAGE_SIZE and then writes protect them to enable
+ * dirty logging for them. Caller must acquire kvm->mmu_lock.
  */
 void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		struct kvm_memory_slot *slot,
@@ -1090,6 +1090,14 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	stage2_wp_range(&kvm->arch.mmu, start, end);
+
+	/*
+	 * If initially-all-set mode is not set, then huge-pages were already
+	 * split when enabling dirty logging: no need to do it again.
+	 */
+	if (kvm_dirty_log_manual_protect_and_init_set(kvm) &&
+	    READ_ONCE(eager_page_split))
+		kvm_mmu_split_huge_pages(kvm, start, end);
 }
 
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
@@ -1875,7 +1883,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 		 * this when deleting, moving, disabling dirty logging, or
 		 * creating the memslot (a nop). Doing it for deletes makes
 		 * sure we don't leak memory, and there's no need to keep the
-		 * cache around for any of the other cases.
+		 * cache around for any of the other cases. Keeping the cache
+		 * is useful for succesive KVM_CLEAR_DIRTY_LOG calls, which is
+		 * not handled in this function.
 		 */
 		kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
 	}
-- 
2.39.0.314.g84b9a713c41-goog

