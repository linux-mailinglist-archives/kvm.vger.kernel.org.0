Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAF469826D
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 18:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjBORlV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 12:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjBORlU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 12:41:20 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCE83BDA6
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:41:09 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id y28-20020a056a001c9c00b005a8c5cd5ae9so4473797pfw.22
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vu28Y8xmwb9cUbiZLOcUlnlRr/eoSKPO/7e0jwLh0zg=;
        b=fi5dr/Uea0vWmNPTbL8OTE7Sg/ja0hoM43OAqbCs0x3g9IKAZGWp/yvpN92i7p1Pqk
         HDiqy8ftwQlT1NnGwLBeG3r2RNUuNo42LD9XyKLyZK1OBNVyPjfLSx8x/qiZoat58ED4
         ZhMjD1xnNQHDltJUUIBshDHFj+1otVDLMxZi4ClCnhyAiANNXSDcGXpYYEtgKi6BY+sJ
         0llIR230lm3+FX0UJ0yOANAbMm8We6kBlNyi6mgvHTbJbe9l2CtlTkhxRZbeDU2Ad5VZ
         JvrTUPjKhMZOS3R8PQ6jJfttf0zKpEaqfLC8U4pjEfdMhnhx9rFD+r+kns0343NShOQo
         i9eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vu28Y8xmwb9cUbiZLOcUlnlRr/eoSKPO/7e0jwLh0zg=;
        b=VRXCL45/2T3jXTXcsjeJtjK67J5tQy6Ifl6S3KOJ+CNWZv9ien3K9iy8Lhbg6hxZZN
         eh8hun5TC61eJSP41VpVsNaeTe12+aQSsJK5ijVYWz4E8T7Ir8Qrtm9kEjAX0+nEU6Na
         5QMcDO5MEDJLA3i0CC+9gPw09op4IjQELUJYVfd9zei3EyINElqskmRGGxk//0sb9xMW
         Fpy8g0/UAVqVEwAQjaxaUZIhASNpMzcXzti4sZTQBGqeRDbhcCaMRM137xpgpqW0EFKZ
         PtDbSVxiw7Up9AZ68drozqfeEO/NeiT2gUXy46ZD0SOdzB+wq8/ToPuay0BVc4mY/e8J
         ywyg==
X-Gm-Message-State: AO0yUKXtdbXHg53gf15484Z1gbiKBYuP7M8shfEWk8z2WGOdXkZbWACi
        uKZOmzymxelP7T7cu9fYwpaAKoR24pibpQ==
X-Google-Smtp-Source: AK7set8FvdjfeCrotVKOoVGb7sZBHpXmtdM1wOtJMGO9tmeqveUBHmj/eNHuv8/HOqcKyZxF5XRd4OT1S6jTJQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a63:7419:0:b0:4fb:b856:a30f with SMTP id
 p25-20020a637419000000b004fbb856a30fmr488302pgc.11.1676482868552; Wed, 15 Feb
 2023 09:41:08 -0800 (PST)
Date:   Wed, 15 Feb 2023 17:40:45 +0000
In-Reply-To: <20230215174046.2201432-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230215174046.2201432-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.637.g21b0678d19-goog
Message-ID: <20230215174046.2201432-12-ricarkol@google.com>
Subject: [PATCH v3 11/12] KVM: arm64: Split huge pages during KVM_CLEAR_DIRTY_LOG
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
2.39.1.637.g21b0678d19-goog

