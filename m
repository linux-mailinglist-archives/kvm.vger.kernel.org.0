Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A46668A69
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 04:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbjAMDuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 22:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjAMDuK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 22:50:10 -0500
Received: from mail-ot1-x34a.google.com (mail-ot1-x34a.google.com [IPv6:2607:f8b0:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D65C1A3A5
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:50:09 -0800 (PST)
Received: by mail-ot1-x34a.google.com with SMTP id e8-20020a9d63c8000000b006704cedcfe2so10086231otl.19
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:50:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jNJ/QahVWN0jZIoUQ1jgvhpTISkbQRg3HWBwcBAUB8Q=;
        b=jm0+bUOJ3mDeey09UoZ0K1vIDMCBj+tFUgrbwxmIcVKdV/6vOjsiE91Z+YAsIKjPWu
         2kpQ50Z4WNB9r7nym2XtMF/iO4yRZgvA3R4WmjEgkBI6mc0bVMLMiffonCYNjBoMCj8A
         sBVYWLfHCLn5nGR1VCPdDZQMeVS0gYvXQIx7Ev6TqxjI1WZRueWtRaFiGUISNolXtz5Z
         a/R2ZJsbH5ale00jO+gWq8rlz23NDTGWYJrXQ5a9wSdW57IG8ckAT49lbxGmUIP29nks
         jI8VybzlUq0TKFxHmXys9gUBDe2VJJnvlh6+enRRL+4X9iiZ36Z6EckhT5/CxKcopKow
         16Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jNJ/QahVWN0jZIoUQ1jgvhpTISkbQRg3HWBwcBAUB8Q=;
        b=7fgo+F5riMRAjiGW+k6ugBPafC5AIcCFZXDaoBzqMQBec9lvIKsqcAE5q/3Ndx3Krh
         5349JaXSP3FYBI8VjYGuVe2Rk0Qfk0a4ZEkxDRG2G6OWpJ4LXk6FcpZQ23K8PuKWMTMv
         DRSmp27OCjwSFR5JZv6QS82464PP048qjU7Wb7aZC2YFaz2+8S+aeMYrjnxgqwC2DUGq
         lIMfCnPYwKaXE9dirsaZUJ8SX/uTLVk+7rqwKrdeMwd7upTAjY2BSTr6WStui816320W
         qDhUj1lR1p80h42T5v0SJHd9JUkbf0b1/WZBIwWEdA5Sr+FNX27hqItqsxstlV9JnGGq
         zstQ==
X-Gm-Message-State: AFqh2kr+uCItKUJGvVeHnNVhbUEEHK6eDAv2ox2FqSWScySH65Vq4JSa
        2Tce4tv28ZaAa5bi4g3y9Wk29CsVQ+Jc3A==
X-Google-Smtp-Source: AMrXdXtPfxk0qn/HIjWb+HtpyhFViCmVAVNxVfGLg7Z5Hw6JRRZ2JEjSNtm1ZCbxYwHrgd1azKVdovB2Qlsjaw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6808:628e:b0:364:45c4:93b with SMTP
 id du14-20020a056808628e00b0036445c4093bmr1421665oib.209.1673581808676; Thu,
 12 Jan 2023 19:50:08 -0800 (PST)
Date:   Fri, 13 Jan 2023 03:49:55 +0000
In-Reply-To: <20230113035000.480021-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230113035000.480021-5-ricarkol@google.com>
Subject: [PATCH 4/9] KVM: arm64: Refactor kvm_arch_commit_memory_region()
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
index 31d7fa4c7c14..dbcd5d9bc260 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1758,20 +1758,27 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
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
2.39.0.314.g84b9a713c41-goog

