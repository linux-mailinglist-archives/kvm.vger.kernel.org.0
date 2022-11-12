Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BED1062681B
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 09:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234810AbiKLISE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Nov 2022 03:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234876AbiKLIRt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Nov 2022 03:17:49 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5CA6036A
        for <kvm@vger.kernel.org>; Sat, 12 Nov 2022 00:17:37 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-348608c1cd3so64045707b3.10
        for <kvm@vger.kernel.org>; Sat, 12 Nov 2022 00:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3ei5KTNcwhvdEV4DEpNFWL2FLBtddGkRWDZ/PZs/pyI=;
        b=a19I5M6QD8ehxktbvDkxtPw0UrpG81hnIry+JL2VyC+pmJlCLjUTQU9D3tS4gRNcCU
         qdp/5z/jxiSnVMaqHsIyg8amm+Nl2PQ+GVBxqPMbV7Y+4Qel7yqwPcuWWOFzFhQZIN0R
         GYroxUY6ffo0v/rEOhQml+75jUUl6lAOZiTa2QnBE68tXsAFz0+PBWKHa+BOGDaZ5IER
         a11qT3xsYQfdwNbi3qNoxzKIkwtdV1D+8O1INKn/UsojFZXoTVb7znNF/s0uoMPeg2o6
         XqTzxzckjG64tlCy9itEM7wEL74IrzNod9jraA/KC4u6PP+bao/Vj3O8nlguA7aDZaUT
         2FZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3ei5KTNcwhvdEV4DEpNFWL2FLBtddGkRWDZ/PZs/pyI=;
        b=V8H3OdfjxBzf/N+0fwBKqDH/BMtYUAeJ2M9Op8a6QNfoYd5/WmaY1x6FkwIKYbrag6
         SO4Qga/8wrQK8sx2giwaXMjXpMd0V+USn6owwTkju/4iChPSdOZOHGCVawgM5ro+OXIm
         SwZZkTpSFsmuKeT/x4zMdTi9nNeTeR7aIsJ93w+ee+usiHiNjY3FvgoJ7e7UZQqO8o33
         fa2fYJzs1/PIF4+thF0XGXcCbCjUylf9B/ibrouaD41dafmozVNvlxxglHusy+XhViwB
         rbqWMWOi2g0EwiEsX0NOfRUMTlsALWpzTUvh/PeemTRVmDuJA83azw3GIGHoNpfO1RH0
         Ipww==
X-Gm-Message-State: ANoB5pkzVwPPlNaKZjKwL+Pr2YgIYvYQv3Ll0jLY2CYSuM07n1Oxq/Bb
        BMIpcD9x/vBksyCcCN+U1A5m2T3EAts/AQ==
X-Google-Smtp-Source: AA0mqf76MOJIlJMgyK8SACjurwBgdmgD8UMbYjNn4NyBxOTE9EDQqi80GPLESjM3J7HUUAm7YnPRl075qddTHg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:50e:0:b0:6dd:657d:ffc8 with SMTP id
 14-20020a25050e000000b006dd657dffc8mr3797725ybf.269.1668241056148; Sat, 12
 Nov 2022 00:17:36 -0800 (PST)
Date:   Sat, 12 Nov 2022 08:17:13 +0000
In-Reply-To: <20221112081714.2169495-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221112081714.2169495-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221112081714.2169495-12-ricarkol@google.com>
Subject: [RFC PATCH 11/12] KVM: arm64: Split huge pages during KVM_CLEAR_DIRTY_LOG
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

This is the arm64 counterpart of commit cb00a70bd4b7 ("KVM: x86/mmu:
Split huge pages mapped by the TDP MMU during KVM_CLEAR_DIRTY_LOG"),
which has the benefit of splitting the cost of splitting a memslot
across multiple ioctls.

Split huge pages on the range specified using KVM_CLEAR_DIRTY_LOG.  And
do not split when enabling dirty logging if KVM_DIRTY_LOG_INITIALLY_SET
is set.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/mmu.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7881df411643..b8211d833cc1 100644
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
@@ -1474,10 +1482,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 */
 	if (fault_status == FSC_PERM && vma_pagesize == fault_granule)
 		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
-	else
+	else {
 		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
 					     __pfn_to_phys(pfn), prot,
 					     memcache, KVM_PGTABLE_WALK_SHARED);
+	}
 
 	/* Mark the page dirty only if the fault is handled successfully */
 	if (writable && !ret) {
@@ -1887,7 +1896,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
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
2.38.1.431.g37b22c650d-goog

