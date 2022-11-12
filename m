Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3708C626813
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 09:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234837AbiKLIRg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Nov 2022 03:17:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234830AbiKLIRc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Nov 2022 03:17:32 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718C15BD57
        for <kvm@vger.kernel.org>; Sat, 12 Nov 2022 00:17:30 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-370624ca2e8so63660857b3.16
        for <kvm@vger.kernel.org>; Sat, 12 Nov 2022 00:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XowvsvOcOv2Dze5DffbrE0m7myhjg52x/AYqKu/6H0Q=;
        b=EsW5Gdp75rU2DUuHrGdfowsd3Xg7XJrLSdam+fpUtlwTdh1xrokqMFBjDQfu3ZSN5v
         3WNIAfsqOLgz9ApP/xZH1HRwWly+toBAPueZXyk9cB7bHX4lZw9gZFw4kGeCmEHf6xww
         tgIkAGZLt+9amtGXX3/mSDXUkXfTwEy7EGY+SR6BC7T6OygBkq45p4xA35d9sDiVisW6
         rs966VJsnUdF16OGJeOV5eAMSKeo90JTQ5w2yVogPJnhnlnsJXskfaWTBhhwD2JHSNut
         04cT72ye0o4MEN0FBYX5wuczQ8IkaZcFUgY2DAv5Ajod7vm1m9BGTFuDSumglosNjDzp
         7GZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XowvsvOcOv2Dze5DffbrE0m7myhjg52x/AYqKu/6H0Q=;
        b=OOcemz5KZ56M0HrnLNwSkOhGCBlsH7kyCwnxnteQpG3/JlkAV+X8Ji7+UU6yF4Sbnr
         Dv/8uqHzO8/ur5/RZgn6oF6I+2WrHGavxO6K0wZxR+KCD5tnZRNDIv17XhGuSKUPtjPF
         5t9PUONiljZ9hR3GZ3C55evrGhFhgdsF3qZcemKhrrBeyspjlaHP3TB1fOplbQ16epNh
         mIxCwgzSgU6nz4q7mmIF1KkHHmYXBP7+TW0tXLdCpd88WJtI4oYJpN2hBdQbn2NIj17I
         GOjsbsFNXyOT/8oxWY6rNy4ZrcmjbYEDDURfHkFT5Qpe81quZH6WsgUZz63bfOU3zGgn
         +f/Q==
X-Gm-Message-State: ANoB5pkeUPr70cLnQG0XQZrsX9I7c1DdbY+K8aCJsplruSkj7i5sNzU5
        Ob/uoEXAbCgUEaYFy9/q1a/5NwqhjqzkRg==
X-Google-Smtp-Source: AA0mqf5J4lgPyBB5y+f3Nq56r3EX+3f3XVFGVpba92grsCihrLzXFlwxYutDNVRoff367ywYqhaBZFCdb+AbvQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a0d:cc86:0:b0:368:738a:b13b with SMTP id
 o128-20020a0dcc86000000b00368738ab13bmr5277155ywd.97.1668241049641; Sat, 12
 Nov 2022 00:17:29 -0800 (PST)
Date:   Sat, 12 Nov 2022 08:17:09 +0000
In-Reply-To: <20221112081714.2169495-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221112081714.2169495-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221112081714.2169495-8-ricarkol@google.com>
Subject: [RFC PATCH 07/12] KVM: arm64: Refactor kvm_arch_commit_memory_region()
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        dmatlack@google.com, qperret@google.com, catalin.marinas@arm.com,
        andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, ricarkol@gmail.com,
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
commit to look cleaner and more understandable. Also, it looks more like
its x86 counterpart (in kvm_mmu_slot_apply_flags()).

No functional change intended.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/mmu.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 318f7b0aa20b..6599a45eebf5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1770,20 +1770,27 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
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
2.38.1.431.g37b22c650d-goog

