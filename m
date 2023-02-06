Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B7468C406
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 17:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbjBFQ7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 11:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbjBFQ7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 11:59:04 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0CA298E2
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 08:59:03 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-517f8be4b00so120445737b3.3
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 08:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8zrNUdMOQOUCJgLNSlqpWBpwPg1ysQqMfJW7ug17pk8=;
        b=OhogaDmxK2A4kV6+TTY9E1br3vwEnQWAXP4ItIL5FD1Y3YQ5dt5/DbUeN2hySyWDqS
         9fLNvLxT88V3LYBi+kPyBlwcie/evnfpfJtMNUdhmIzve8VkYv6BRKl3pks0VuN9TfLA
         5cREu96AzkOJpObRjU9/AoKblo5ztdPmcipREktbavYR3DrY7vg6fdHjQf8Hqsu8hmaK
         yvDcx+jU9yapfiu7bODzfejb2YyxXRzuG9pvwLSqreYZEKs8f4yT7IvCvX7nAOQhf3X3
         dNIJHt65wWlTiwvNzcfT0DdBZp9V8AwPjH0TzAl+hYWnc0uz46bbjHQxVH2Lnvt9pSyr
         KGyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8zrNUdMOQOUCJgLNSlqpWBpwPg1ysQqMfJW7ug17pk8=;
        b=jjStMwUy4xp17ydscQKsm6TWisr39b4K85hNJoiwu1FtkGbvBbDVtQlr98OS24wvQl
         FBpEZsdNh/Hux69tTyViKwj+tHBjl5xYWp7AfwM1MYkq2YzlnavPpk60dhRDyeWmyuYN
         R8ZRzGwGzu0vQ9BRPIdPplQVHf4mrqPjwPLaUsENXVKQ8+/tXgkKrfikr5Sz43Gf4hrK
         mOIyz/46eNJ8/9H0cHhMHPlTkIPn5ZpgLS3iJFv2DnsUnFxDeOxtKeqzsOSQhRrFsDBF
         Rhu2sxyr/UKbwUoVdZsVhV8k4J5gXRv2Q3gkuQsxfOUgXlTL/BqG/gLAh0YaOgO9lNbd
         66lg==
X-Gm-Message-State: AO0yUKXGxD2mCZMh26g99uZU3eAn6gt+WcpfDZVhIEwbyCmgoaIIKRtT
        qL8/cSCNiO2m+U3nQ00faJ2Sj8xm4ZCPAg==
X-Google-Smtp-Source: AK7set94430d3TW0rOSOGdcCMwmeKCK2QLWM9dIYTScifN3Lhaw6SVCQvu82gV70yChRGOpb9SbRNDBzgZ4dCA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:13c6:0:b0:855:fdcb:4467 with SMTP id
 189-20020a2513c6000000b00855fdcb4467mr0ybt.0.1675702742440; Mon, 06 Feb 2023
 08:59:02 -0800 (PST)
Date:   Mon,  6 Feb 2023 16:58:44 +0000
In-Reply-To: <20230206165851.3106338-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230206165851.3106338-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206165851.3106338-6-ricarkol@google.com>
Subject: [PATCH v2 05/12] KVM: arm64: Refactor kvm_arch_commit_memory_region()
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

Refactor kvm_arch_commit_memory_region() as a preparation for a future
commit to look cleaner and more understandable. Also, it looks more
like its x86 counterpart (in kvm_mmu_slot_apply_flags()).

No functional change intended.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/mmu.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9bd3c2cfb476..d2c5e6992459 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1761,20 +1761,27 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   const struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
+	bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
+
 	/*
 	 * At this point memslot has been committed and there is an
 	 * allocated dirty_bitmap[], dirty pages will be tracked while the
 	 * memory slot is write protected.
 	 */
-	if (change != KVM_MR_DELETE && new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
+	if (log_dirty_pages) {
+
+		if (change == KVM_MR_DELETE)
+			return;
+
 		/*
 		 * If we're with initial-all-set, we don't need to write
 		 * protect any pages because they're all reported as dirty.
 		 * Huge pages and normal pages will be write protect gradually.
 		 */
-		if (!kvm_dirty_log_manual_protect_and_init_set(kvm)) {
-			kvm_mmu_wp_memory_region(kvm, new->id);
-		}
+		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
+			return;
+
+		kvm_mmu_wp_memory_region(kvm, new->id);
 	}
 }
 
-- 
2.39.1.519.gcb327c4b5f-goog

