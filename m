Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18500594EC8
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 04:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbiHPCjP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 22:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233745AbiHPCiv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 22:38:51 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB865D117
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 16:01:22 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3238ce833beso79224127b3.11
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 16:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=M+nfQilWC9cZraYcqyhIFW5aSVPILsZzzMM4Mf2MT1M=;
        b=SBZufQamGMqBF1EDLReFItt49RuzfGEjvIYsosojb248aUvc89WQrrhY7WbeXdfCFN
         buXRfIMz0yiDC1XIFSC1Gp26xWr6aE9OWUCYjKkUF4uJmlsss5lasJ9cdRc04zNIW6Sq
         RGfw3hhQ0/PP8HJB8kGihoMT9dS0WT/PVb4pEunfGwghqX6drw1NiennQ+zshN4m9dVS
         M/0zFlAMbMAchbf9vHxInQpygOMlEsIyFlRUWuuT0Mpu2QDzwDh0ibm9dSAmTTNrAX5r
         6GT9Y/oaafFNvjFskjNugUJMBv5PeIU7akRtja2v5lEWSqFKDCfCvKVGwXMQLM4459bB
         +8Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=M+nfQilWC9cZraYcqyhIFW5aSVPILsZzzMM4Mf2MT1M=;
        b=xO9U/p0KHF9wHMfOzaTKFFOmp3zb61yFtFLciGuY30brAdZlXBUGbCI9d0vH5tzF9+
         AXL2V0CtKM9PYUwdOhq7zBCq7VxnVKBbnTRie24e9R1o+f/OHQ5rkjrfMip2GRVzqzDy
         3QZ+Aov2iCJh4ifpfpMaFR6cuMyz7c8ZJ58+uBCVu2goGG6q3ylJE/v+3ZBrtvCdjDKk
         dj8X0ifAGKoZAEjTGqU2rdvAR/TRvY24Py/VUewep7ls8PGpoe599Aglj26HX9SSGKkL
         fP8XDp3bhnazjThjPGDKkj2csLX7PB6Q7d0w2vAo3xn7NV9xUn4zBIGgMbY/rzrZOKw3
         BltQ==
X-Gm-Message-State: ACgBeo1Q9PNUnnEH4CjtfITUNLHuuyiPxaSzHt69iHtEISqS8SO5joYH
        DBe9p3Fx6QF921mY30v51FnZ+FQTaIaCQA==
X-Google-Smtp-Source: AA6agR7o4SHIupdgy/9JSRVpr8fjneKxjH5JWiDFGcgqDkuNQeIqUtIUgstuol60xaLZzdHCSm6eiEjTdUF0qQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:148d:0:b0:32a:8e40:cdc0 with SMTP id
 135-20020a81148d000000b0032a8e40cdc0mr14305150ywu.425.1660604482208; Mon, 15
 Aug 2022 16:01:22 -0700 (PDT)
Date:   Mon, 15 Aug 2022 16:01:05 -0700
In-Reply-To: <20220815230110.2266741-1-dmatlack@google.com>
Message-Id: <20220815230110.2266741-5-dmatlack@google.com>
Mime-Version: 1.0
References: <20220815230110.2266741-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 4/9] KVM: x86/mmu: Rename __direct_map() to nonpaging_map()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
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

Rename __direct_map() to nonpaging_map() since it is only used to handle
faults for non-paging guests on TDP-disabled hosts.

Opportunistically make some trivial cleanups to comments that had to be
modified anyway since they mentioned __direct_map(). Specifically, use
"()" when referring to functions, and include kvm_tdp_mmu_map() among
the various callers of disallowed_hugepage_adjust().

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 14 +++++++-------
 arch/x86/kvm/mmu/mmu_internal.h |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index af1b7e7fb4fb..3e03407f1321 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3072,11 +3072,11 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 	    is_shadow_present_pte(spte) &&
 	    !is_large_pte(spte)) {
 		/*
-		 * A small SPTE exists for this pfn, but FNAME(fetch)
-		 * and __direct_map would like to create a large PTE
-		 * instead: just force them to go down another level,
-		 * patching back for them into pfn the next 9 bits of
-		 * the address.
+		 * A small SPTE exists for this pfn, but FNAME(fetch),
+		 * nonpaging_map(), and kvm_tdp_mmu_map() would like to create a
+		 * large PTE instead: just force them to go down another level,
+		 * patching back for them into pfn the next 9 bits of the
+		 * address.
 		 */
 		u64 page_mask = KVM_PAGES_PER_HPAGE(cur_level) -
 				KVM_PAGES_PER_HPAGE(cur_level - 1);
@@ -3085,7 +3085,7 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 	}
 }
 
-static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+static int nonpaging_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_shadow_walk_iterator it;
 	struct kvm_mmu_page *sp;
@@ -4253,7 +4253,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (is_tdp_mmu_fault)
 		r = kvm_tdp_mmu_map(vcpu, fault);
 	else
-		r = __direct_map(vcpu, fault);
+		r = nonpaging_map(vcpu, fault);
 
 out_unlock:
 	if (is_tdp_mmu_fault)
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 1c0a1e7c796d..f65892c2fdeb 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -198,7 +198,7 @@ struct kvm_page_fault {
 
 	/*
 	 * Maximum page size that can be created for this fault; input to
-	 * FNAME(fetch), __direct_map and kvm_tdp_mmu_map.
+	 * FNAME(fetch), nonpaging_map() and kvm_tdp_mmu_map().
 	 */
 	u8 max_level;
 
-- 
2.37.1.595.g718a3a8f04-goog

