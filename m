Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F376DBEE8
	for <lists+kvm@lfdr.de>; Sun,  9 Apr 2023 08:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbjDIGad (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Apr 2023 02:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjDIGaa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Apr 2023 02:30:30 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C345FD1
        for <kvm@vger.kernel.org>; Sat,  8 Apr 2023 23:30:24 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id nr15-20020a17090b240f00b0024673943bb2so591083pjb.1
        for <kvm@vger.kernel.org>; Sat, 08 Apr 2023 23:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681021823; x=1683613823;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t9rdDM0DIHaJA1wTPBjn9eVH40DD8OG4+XbeMa8HFig=;
        b=RKxUOB3y7sFWAACxhdDtnYlSmJsZekw+A8rGo8ThBPr9MqCSHcpYLbxIcFIbz+OFWm
         D34DLtaHrSki64Q2UBRZsBC2H3lsa1jM52NQX48I4phlQzdYNucEwlJ1Q+o9hMPBjn6P
         AacxQXGuVAKeG1xPKPX/MZq7XRtjlRM85dDHQvH541BC4Odc7LrnqQ0o5hD4W4qcSgG8
         ZZYQvSl0SQ5OpQJYGhY/9ZPcWOuvRvoE35OnnyNtI9yFXAKdBUMvOcXUW/zSoYH6m4Om
         ErkMfxyRsggpukJOEPHn2yQwq833yYgCWy3flZwjuJ52Oj+cu9UNGcueaFX6p0oer4NC
         pbQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681021823; x=1683613823;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t9rdDM0DIHaJA1wTPBjn9eVH40DD8OG4+XbeMa8HFig=;
        b=GuZvHmTB9yiyf1tLx82+dEt9pDDhtsAu6nl8GELf7iZrHj2AflICRTHxbDfHqmiyNo
         HY/MaWFuUWfpZZvvOCZdMO3EL+qtm33IOayriuq//51HE+Xd2lv4k7zjYuTuqRvpbsog
         0tGAsgcrNQuaPlsLqfHu/R3NYUJNW97KNBM0/7G5Osc0sdY16JWOt7zgCHjItORs9Exy
         0pACw+azY5YqwlGijodKgeV4R9OYqBmkAfoGbD+gte56bdSLYSSI1xH+GbWlZjsAMb2c
         UdRmgkv2UFltFkHjwuaqAgIIDG4qBwXmLI6j331JH11YXw6l1HlvGGBhlIb90MwTFnxB
         eRpQ==
X-Gm-Message-State: AAQBX9eDNsg6+E75ZIvG4XGQ/imqG0XqXph0b3kKSJi0nYIbeMOEcFjD
        QyRLdBDB4SDum6X1weA/P9dakNNCj1kiKA==
X-Google-Smtp-Source: AKy350biOI9x2UVlkdbQxs6COE9ClrZsaVxSEeLj8cGsL5GkgmswBxG2pljsUVDWjOuoSIaH7RrYg3tH/kgY5w==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:902:da85:b0:19f:2aa4:b1e5 with SMTP
 id j5-20020a170902da8500b0019f2aa4b1e5mr2459015plx.2.1681021823248; Sat, 08
 Apr 2023 23:30:23 -0700 (PDT)
Date:   Sun,  9 Apr 2023 06:29:59 +0000
In-Reply-To: <20230409063000.3559991-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230409063000.3559991-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230409063000.3559991-13-ricarkol@google.com>
Subject: [PATCH v7 11/12] KVM: arm64: Split huge pages during KVM_CLEAR_DIRTY_LOG
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
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
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
 arch/arm64/kvm/mmu.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 16fa24f761152..50488daab0f4d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1094,8 +1094,8 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
  * @mask:	The mask of pages at offset 'gfn_offset' in this memory
  *		slot to enable dirty logging on
  *
- * Writes protect selected pages to enable dirty logging for them. Caller must
- * acquire kvm->mmu_lock.
+ * Writes protect selected pages to enable dirty logging, and then
+ * splits them to PAGE_SIZE. Caller must acquire kvm->mmu_lock.
  */
 void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		struct kvm_memory_slot *slot,
@@ -1108,6 +1108,17 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	stage2_wp_range(&kvm->arch.mmu, start, end);
+
+	/*
+	 * Eager-splitting is done when manual-protect is set.  We
+	 * also check for initially-all-set because we can avoid
+	 * eager-splitting if initially-all-set is false.
+	 * Initially-all-set equal false implies that huge-pages were
+	 * already split when enabling dirty logging: no need to do it
+	 * again.
+	 */
+	if (kvm_dirty_log_manual_protect_and_init_set(kvm))
+		kvm_mmu_split_huge_pages(kvm, start, end);
 }
 
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
-- 
2.40.0.577.gac1e443424-goog

