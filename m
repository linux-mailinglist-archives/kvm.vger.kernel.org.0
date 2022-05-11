Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1837C523630
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 16:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245105AbiEKOva (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 10:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241067AbiEKOv2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 10:51:28 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B48D8083
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 07:51:27 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id cn13-20020a056a00340d00b0050e0f04e467so1236458pfb.21
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 07:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=h9AY4Q2GsOxacDvqFN4YTojc7TEqJHbfnq0d8zy0AUI=;
        b=hWZVPP8lhK4N0Mg6bmSbEhxF+gTB9MnL6ots52Urd2t0/BbHCNlxwcd2S2G9HVpmZq
         WmD2LolLlgxmVrCerQpCgU2RyoXFU1cnXXKL1/ze0GW3SwsPVU9p4BMCz9YZjRPSu1Gq
         LpZPXrCle99UgoCrYsg8ziEgsdZG3s9z6BCs0zXngM96DOAUY1OfwxQcnMOUAy3je8Ng
         Hn9U7LT6RXjR/aL9JuxTmTHHaUX8k3W8UFszC98BIPak2Mf3ZIHsM90lozNIQG8dqZeM
         QNUJGagLQlGtMLj4FUewa4YXht/Q+BRa1AC0fHSf1jil2ipAA9/lI2RIT/goUp2fIwl4
         niJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=h9AY4Q2GsOxacDvqFN4YTojc7TEqJHbfnq0d8zy0AUI=;
        b=mi/sYuXf78YualHaiSQu8GQ03v2E0KfQr5TfQZnUgI8U9uggKnIwtx91W6N2HrnCpa
         r0D5Zn2MNKoJ9/1VjiI244ntmrJNdjz+RXoxpXX+Iema4kgUT8wPBynYMLbxuLdjMlbu
         nFintYEbneD7vQyYD7fUBzR9aolv201vZCor/LMv8wBlalakUCYKm1I64CStEGxiMS0h
         Mzj/HnXZC5eVC8FNlx/7MxwQT1FGailxylCWJev4y/GK0E/UyOfG1SdJLJlpASssgnaW
         LSectDBkWL6qrseQnC/sazxNg+AHa7eTL/8cDxNlMdY++w4H4QiK+PEHtHNG+FNdYrtL
         WXyA==
X-Gm-Message-State: AOAM531RgjJ9TWGHRViVbKwIiR4NdrP9Izydw23B53qFPeUAkD0ItVjG
        lPMbyPwCaX9a/AFcp4RYk+c/WDU+rnE=
X-Google-Smtp-Source: ABdhPJz0W4ie8Ct1S+dUr/07VAZls1XaOK8YaewpQK6DMZLh8ZJFn1XA7xpKaUkkvdiTRxdXAG4dIYHi6l4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:5752:0:b0:3c2:1c59:666f with SMTP id
 h18-20020a635752000000b003c21c59666fmr20961499pgm.59.1652280687130; Wed, 11
 May 2022 07:51:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 11 May 2022 14:51:22 +0000
Message-Id: <20220511145122.3133334-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v3] KVM: x86/mmu: Update number of zapped pages even if page
 list is stable
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
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

When zapping obsolete pages, update the running count of zapped pages
regardless of whether or not the list has become unstable due to zapping
a shadow page with its own child shadow pages.  If the VM is backed by
mostly 4kb pages, KVM can zap an absurd number of SPTEs without bumping
the batch count and thus without yielding.  In the worst case scenario,
this can cause a soft lokcup.

 watchdog: BUG: soft lockup - CPU#12 stuck for 22s! [dirty_log_perf_:13020]
   RIP: 0010:workingset_activation+0x19/0x130
   mark_page_accessed+0x266/0x2e0
   kvm_set_pfn_accessed+0x31/0x40
   mmu_spte_clear_track_bits+0x136/0x1c0
   drop_spte+0x1a/0xc0
   mmu_page_zap_pte+0xef/0x120
   __kvm_mmu_prepare_zap_page+0x205/0x5e0
   kvm_mmu_zap_all_fast+0xd7/0x190
   kvm_mmu_invalidate_zap_pages_in_memslot+0xe/0x10
   kvm_page_track_flush_slot+0x5c/0x80
   kvm_arch_flush_shadow_memslot+0xe/0x10
   kvm_set_memslot+0x1a8/0x5d0
   __kvm_set_memory_region+0x337/0x590
   kvm_vm_ioctl+0xb08/0x1040

Fixes: fbb158cb88b6 ("KVM: x86/mmu: Revert "Revert "KVM: MMU: zap pages in batch""")
Reported-by: David Matlack <dmatlack@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

v3:
 - Collect David's review.
 - "Rebase".  The v2 patch still applies cleanly, but Paolo apparently has
   a filter configured to ignore all emails related to the v2 submission.

v2:
 - https://lore.kernel.org/all/20211129235233.1277558-1-seanjc@google.com
 - Rebase to kvm/master, commit 30d7c5d60a88 ("KVM: SEV: expose...")
 - Collect Ben's review, modulo bad splat.
 - Copy+paste the correct splat and symptom. [David].

 arch/x86/kvm/mmu/mmu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 909372762363..7429ae1784af 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5665,6 +5665,7 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
 	int nr_zapped, batch = 0;
+	bool unstable;
 
 restart:
 	list_for_each_entry_safe_reverse(sp, node,
@@ -5696,11 +5697,12 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 			goto restart;
 		}
 
-		if (__kvm_mmu_prepare_zap_page(kvm, sp,
-				&kvm->arch.zapped_obsolete_pages, &nr_zapped)) {
-			batch += nr_zapped;
+		unstable = __kvm_mmu_prepare_zap_page(kvm, sp,
+				&kvm->arch.zapped_obsolete_pages, &nr_zapped);
+		batch += nr_zapped;
+
+		if (unstable)
 			goto restart;
-		}
 	}
 
 	/*

base-commit: 2764011106d0436cb44702cfb0981339d68c3509
-- 
2.36.0.512.ge40c2bad7a-goog

