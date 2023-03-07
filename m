Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB276AD5D8
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 04:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjCGDqR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 22:46:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjCGDqN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 22:46:13 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD8F4D61A
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 19:46:07 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id o17-20020a17090ab89100b0023752c22f38so4452822pjr.4
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 19:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678160766;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j/rvnSUPkFYod+qtoGkjVnQK76DLzlbuECq38DHxQ5A=;
        b=fb1Gvc769uSZciENcHpUJql9DAUpW3BmIfMoSuuGM7TRqKwudVfqotQvwUJCQtiWVG
         siwJ97O8ckmab6z6OQKYBQ2NX42GiV28Qpes8eQW3ie3+eXHi8/oOXaaGFx3qeaGS/ar
         oWVYjXOHTnUR6j0g1a/lZ6A1DRaO4waasQAX/lyuYJY577MJSyCJwEr+BoRALiy8gbGb
         5pSHP1OdbqLIhFi1DVa6g8w0An+r9iZhBmG7PCXJT3fMaYaU0k1Rmrskxjq3Zsc17pF5
         lrzYOPJUJWq9irRijnygLpDD9GA+WMS+WZpA2ctrf6C1m9pWxMeted/cMSBIXvAX+jd6
         3a2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678160766;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j/rvnSUPkFYod+qtoGkjVnQK76DLzlbuECq38DHxQ5A=;
        b=DRvlFaSjewEb00Jl9fCUHjp42x+VbahGCLSfljLH9FH4euLC4iP9WB3+bnYwetTVeQ
         QCSPHVIa1mdIZepm+D4mhQB1BXpdZUytp7NrcPa6mUqGbhFfHW/gwlboD0TZXRcT/b7E
         BP+RBk32X/mSa4JfPjsbW10tvSKxJsHQb7tF/Ihro6ATg38OHnfvDwcDzb0znad9RdyB
         vmxdvs7RdHATvG/LIhWYCsg6OvSltHjOxU8BnqWDsLT0FmDgT5uRVER1ZItTgelExc0u
         3Ud+sg9B2s1BKnEC50KrqyvjnamvIo7/hjPDjqUwGq4QoTK7yrgGrX4AX60Eanl6WN0V
         7uyw==
X-Gm-Message-State: AO0yUKWM4h2/1A8TEZd8qIvL2ikZtubwL0eQIqc8tN+5BpMV+ON7JcyR
        4ElCbZLsC2Eap0QgcZM0jAhSmi8mOJCn7g==
X-Google-Smtp-Source: AK7set+xmVQmajo5oH9Jd2T7h/jPslono/c3fXukdsoDK6T1PUjeCXYT1WC9c3DWD2cvqTn1Iu5v8aQY1k1FYw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:903:4285:b0:19c:da35:6699 with SMTP
 id ju5-20020a170903428500b0019cda356699mr5125398plb.7.1678160766547; Mon, 06
 Mar 2023 19:46:06 -0800 (PST)
Date:   Tue,  7 Mar 2023 03:45:48 +0000
In-Reply-To: <20230307034555.39733-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230307034555.39733-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307034555.39733-6-ricarkol@google.com>
Subject: [PATCH v6 05/12] KVM: arm64: Refactor kvm_arch_commit_memory_region()
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>,
        Shaoqin Huang <shahuang@redhat.com>
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
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/kvm/mmu.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index efdaab3f154d..37d7d2aa472a 100644
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
2.40.0.rc0.216.gc4246ad0f0-goog

