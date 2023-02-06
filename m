Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E60D68C409
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 17:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbjBFQ7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 11:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbjBFQ7O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 11:59:14 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7026629E21
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 08:59:13 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id z129-20020a256587000000b0089da1e9b65cso2580983ybb.22
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 08:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lfnhNEO0qYqIhXOTY/DBVHuHgYeXN1mb64E/Y2nHvZo=;
        b=OY7lNGmecD6RBy6Mhr6OImmD0/FXI0fhdJXYXMiw0o1/dLG4IgaHT0JQPRHBTeUf58
         5msr1aZj1lI9GcLS3wNywd8pPkEPwX7CktwYIK2exFcSNz3XIykgMYJa1y9i/sn4QfU3
         uTyEyl2awA7X1QdbQctHSB+ITmUtfAp/b7mZkHE/76pFn/J7kOo5at3a5Jb/PHS7Rxe1
         2hI8UeRYIsfuT2KoZ7FedmvXfz1NAL3CIqA+oKq6tSknbCcF2k3REZLEbHJlSy5fC6nL
         cyJLwUo5vCVDbSeX+DFhFUfNAR+U9E0+NFVNp9CGunZ4nImhdk1gSffO6QDHbCZbJfgu
         uziQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lfnhNEO0qYqIhXOTY/DBVHuHgYeXN1mb64E/Y2nHvZo=;
        b=2+dU4xC8GDJgMUBonda3AOfcaX9I0UQ2P+MF5Gj/LJK4bMDEyrKlxRo7UfYofzr32g
         at/sKBNg0zy9gR1nyyk+tmUSXQGLqOHp6XEgfnfG52i6VfKYeK90KGGEv4rZcWqLU6yd
         qd7cmXZvKSbz5F2d5qWvqKfSLtSB/Ib1m89sWQHM6NoH00Cdt1+eOgTdcGca6Iqqmgyh
         qDhYimqYsPzO/SrU/UyyidbQkP1hpq9KhDbnpxk2uGeLPvSVIHSWXqmXkKSNmaGkvV/R
         BuJe8gOuZkc90QAHGVzvg7+oJasKyvtjgdRdj2OFefnk3PMTQTNF3SbAtPs2VhgIO2M3
         w1OA==
X-Gm-Message-State: AO0yUKXNxltJLeQD8+NbhikmSvV/ZvjP1HvCPHPKTUMh81t8bCdTVzEK
        P3n6p7UjvIOySkxzzCKs44LSM7qCw/yuJw==
X-Google-Smtp-Source: AK7set+7/xe5sxL/rI27WlC2RLSsQTQOrFJS8uuHs7s4BpRCKIiQCqgpucmxVo0v5s3NXepw3PwSRNz7QMdrRg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:a046:0:b0:525:b3c5:f175 with SMTP id
 x67-20020a81a046000000b00525b3c5f175mr1462276ywg.453.1675702752713; Mon, 06
 Feb 2023 08:59:12 -0800 (PST)
Date:   Mon,  6 Feb 2023 16:58:50 +0000
In-Reply-To: <20230206165851.3106338-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230206165851.3106338-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206165851.3106338-12-ricarkol@google.com>
Subject: [PATCH v2 11/12] KVM: arm64: Split huge pages during KVM_CLEAR_DIRTY_LOG
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
index f6fb2bdaab71..da2fbd04fb01 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1084,8 +1084,8 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
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
@@ -1098,6 +1098,13 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
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
@@ -1884,7 +1891,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
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
2.39.1.519.gcb327c4b5f-goog

