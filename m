Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E8D69B7EF
	for <lists+kvm@lfdr.de>; Sat, 18 Feb 2023 04:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjBRDXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 22:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjBRDXn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 22:23:43 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE51A6D789
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 19:23:35 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5365a29685dso22396987b3.12
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 19:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s/7R5ej6h5zuscnhDtO9neYKca8wJ2+Nh25+D9oE7OQ=;
        b=QWh2YpfYuo1Bfp/DWb7P1qu9AZTfi4z3+0VDnUgv9G8S/FKTe0KwQIo2XnOwqOUNCD
         Qqb3gg7L7eUd+HW1qxOdJkLGa6RO3/wMiSQX+crjekFgmKhpMEQRy1MAr+BTBEN6OE9A
         FILlJ+jDXycDLFwBrqWce2U3kZpZaqhkkNk/i5VeDLcM805jSPv2S2rG/juJMzCAgEHz
         eRzynL7TEmbH4KK21ecLpK9lZqwXv6fQCPFymTtDku1V3MfY61ABXV9i9FgltsxwyFrc
         WVLkuuWWiqbsdmOmVs/TSlZIY4Bp+SARwyaFujoZEbICpOdM+WpWG6Z9XMKjJEFBUaxS
         Czfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s/7R5ej6h5zuscnhDtO9neYKca8wJ2+Nh25+D9oE7OQ=;
        b=4tOuj0AUHd0SGxBuJqnpmTEhJfcweK2h4GbYTmcOcVnhhYOft8iF9mLs5dv4pVazcC
         crs3s1PYr3pbGlKXfFOtc9JulpbHDQ13Rxw9WN6tU9fyhCCMkAt5FCYBRmusLw9S/qB5
         OpkyKPJzMVe8pyC1pV2uKCHuGQHTBfrpK5Z5jVCzy51nT48/B7hSbQiAbj3F0jLTMDBz
         Dnb3bR9lpxS/2AkafVBnYQ0/epn6n3k0lyqYBPKfUHsAnI0bfig5HVwO9xEs8WNoOk7q
         ir/1U7zJuZjFpcMJf2IVp1KZTpZLOhehcyNves4lZPD9+/16K7Hu5/RZrU9s2mOkJlAV
         FCfg==
X-Gm-Message-State: AO0yUKWFiXLGrgdTr1W9fh1FhdMxYcRBzhNAk5reiKl7nupAZ6Wb+5w0
        oKkfg1CnoecrbgDOjHToxOr7GxY/9EzUhg==
X-Google-Smtp-Source: AK7set/aW9Y72FZsVzf91MozQGe+Q5u8KbHZsA4913mkF0aisI+PQiLGbO+5m+8JXKTzoIvJ3HdXMG8LAlFMCg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:9e92:0:b0:900:c3fd:a093 with SMTP id
 p18-20020a259e92000000b00900c3fda093mr897185ybq.684.1676690614628; Fri, 17
 Feb 2023 19:23:34 -0800 (PST)
Date:   Sat, 18 Feb 2023 03:23:13 +0000
In-Reply-To: <20230218032314.635829-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230218032314.635829-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230218032314.635829-12-ricarkol@google.com>
Subject: [PATCH v4 11/12] KVM: arm64: Split huge pages during KVM_CLEAR_DIRTY_LOG
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
 arch/arm64/kvm/mmu.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8e9d612dda00..5dae0e6a697f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1089,8 +1089,8 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
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
@@ -1103,6 +1103,13 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	stage2_wp_range(&kvm->arch.mmu, start, end);
+
+	/*
+	 * If initially-all-set mode is not set, then huge-pages were already
+	 * split when enabling dirty logging: no need to do it again.
+	 */
+	if (kvm_dirty_log_manual_protect_and_init_set(kvm))
+		kvm_mmu_split_huge_pages(kvm, start, end);
 }
 
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
@@ -1889,7 +1896,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 		 * this when deleting, moving, disabling dirty logging, or
 		 * creating the memslot (a nop). Doing it for deletes makes
 		 * sure we don't leak memory, and there's no need to keep the
-		 * cache around for any of the other cases.
+		 * cache around for any of the other cases. Keeping the cache
+		 * is useful for successive KVM_CLEAR_DIRTY_LOG calls, which is
+		 * not handled in this function.
 		 */
 		kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
 	}
-- 
2.39.2.637.g21b0678d19-goog

