Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06B7F6EF949
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 19:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236239AbjDZRYJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 13:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235174AbjDZRX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 13:23:59 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC75783C0
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 10:23:53 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-b99f3aee8e0so164907276.0
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 10:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682529833; x=1685121833;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eA3wfGEyelK4T3XkIQJrJEaWip/EMGSfHILspNym0zM=;
        b=M8cRku5Zf+KEyeiSh+7Z//LvxeT26I9o6CgjbFwLf5MDJVRKf1hpuER9/jCGS02raJ
         ULzVAVM94N9FAxfBK5oE4/0VuYugt5aZ496v3ObI7NvZSnoieoFVvn0MUPsmBQtPNJDE
         FFBbbKvOpV4odfojWlI3l43pyxeBmIO+jjH58vaHZBb8zZDtmYLBNiNJaFJksbJM3s4P
         3c7wI4OLW8B5WbsTHxQLg17zH+yMui28Ewx37jmCIMSzPFGYbaK/A6TcDG3Gk8BejpFk
         QZn2XcA++u05u3apfSVAROlYCpF8rKdklRnieD7qZgsUQ6uqyo2/QTQfTNiIhQU/qXMt
         99QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682529833; x=1685121833;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eA3wfGEyelK4T3XkIQJrJEaWip/EMGSfHILspNym0zM=;
        b=KvHCUMwrZBgU5Din2QAjPh/5mz811SRZeE32U2acTI2jubAQ5/7t/O8T2n0xGCHl7W
         hurPBMZQdgWK+da/lefqHms/AbpC7FPh1tCzNCN7pGCwHgb3a3K7oxdhVGI6eISblJTo
         VDCzedCn7fryly5f0tnmC8s1ECzNlzl2nMSjh2TRsOuw40EWfgJV5lCLydmVvp9uTDCy
         JMlH41qYJtMZbeguwdb4wiTuZLgSulKnp2ewe7iLKMZdABstKiiOOfLm+l4HCKdu6Twb
         q2k6nNuEf+CeYoNEZ797zpocVbqzNdG/rCmZQ5t/PoVnCKZDqDKhS1QJiEB959W98EwR
         1l+w==
X-Gm-Message-State: AC+VfDyrcAhn9OPj6olRgPpusCKCJphZdp33tXYS9+7QTbC7c272QddH
        7kZHaLvGBZzguPwhhCg5+DOcz6nkrhUhyA==
X-Google-Smtp-Source: ACHHUZ7IDAeUDhr/0GGBPV+4GA8AMVpEewL25NCDu+zbaCcBOeXbfDCfAxRRuyfrJQ8J87Zk+zqkI931RGTwaA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:690c:986:b0:54c:15ad:11e4 with SMTP
 id ce6-20020a05690c098600b0054c15ad11e4mr1978890ywb.0.1682529833173; Wed, 26
 Apr 2023 10:23:53 -0700 (PDT)
Date:   Wed, 26 Apr 2023 17:23:29 +0000
In-Reply-To: <20230426172330.1439644-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230426172330.1439644-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230426172330.1439644-12-ricarkol@google.com>
Subject: [PATCH v8 11/12] KVM: arm64: Split huge pages during KVM_CLEAR_DIRTY_LOG
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/mmu.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 835e4b8f4e5c3..7a68398517c95 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1095,8 +1095,8 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
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
@@ -1109,6 +1109,17 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
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
2.40.1.495.gc816e09b53d-goog

