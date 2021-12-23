Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821A247E958
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 23:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350644AbhLWWYL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 17:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350450AbhLWWXz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 17:23:55 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB8BC06175C
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:23:55 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id i8-20020a639d08000000b00340a257c531so3867628pgd.16
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=mXdSrY6OMtNZUL6SBm5FhuqN7QxidhmmvtoR0HoEp0w=;
        b=eF2q4Zt9YAbIih9a3n0/rfpvUWpw8rDGnz16pJJ3XtJpmUbV2YOJ2F5YZP+91TIFad
         PuBpIMzR3JQ3MIqr9Nfd7EMKtpLkf/dLver+tZntBKf047SChjpKatVzV9G5UclCkFit
         UclKd8ehDVIT2k8w95gs3j3l4p54SoR9ACuoWJDqFmrTB0DcI5ntW4pySEDaW/SXtgEG
         rgqR/kmyG81kdaadahZ7ua/XmYXN9455w/QG+UaNKKOEornHEaTmUdsNqEeFTfAydVE8
         O8MOsHIcFbz98H0kruDzkUffXKq8u0yJrATJIA7dDCI/GcUoE/J61phobhKhNIJvCOFY
         SwCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=mXdSrY6OMtNZUL6SBm5FhuqN7QxidhmmvtoR0HoEp0w=;
        b=6Ywh4cQO/TA0L87qnH33YkTlyFX3BqxxWFLGbU98ArEKuh/J+i7JiYaNtCqw5WAbSI
         RWM77WrAuv0Qp2vvT11h9C5TJC4Xz8Ox0xvTUOSxNKOnmM1EjYJfsbu8yueHIicRVQUg
         FFsFJOl+n2mpSl0E+qhKXpC/Z4zX/G8u8Ut3YV6qitFunNhKLB1L0A9OfBSjgJgfEfbR
         M5F0E4o7QOsKmItopSOjxUA9BkbvMBtALI84bfsYiijncJCBfWemprRc52q3U+zEvMO4
         VVGdl4BOnVG8jRCCSxjGe2D5pNugFvxq4yF4zBJSPALyfhKr6K78ol/tSIN2H0FJnZ8J
         kp0Q==
X-Gm-Message-State: AOAM532eyjUYfdlWjfmMFFkBxC1VqbMFDmXS8EosQxBq1dsHFv6+6VTK
        XOnk30wvf1H020u020hshxODHvtnbK4=
X-Google-Smtp-Source: ABdhPJxDEcHm77MbBJGQXPXjeuSUz5e9A1qqA8iTW9llI8YtYRxrojoUl4/366Zjo9YyB/JNzSp7+7Wx/6Q=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:2243:: with SMTP id
 hk3mr5061652pjb.72.1640298234740; Thu, 23 Dec 2021 14:23:54 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 23 Dec 2021 22:22:56 +0000
In-Reply-To: <20211223222318.1039223-1-seanjc@google.com>
Message-Id: <20211223222318.1039223-9-seanjc@google.com>
Mime-Version: 1.0
References: <20211223222318.1039223-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v2 08/30] KVM: x86/mmu: Document that zapping invalidated
 roots doesn't need to flush
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the misleading flush "handling" when zapping invalidated TDP MMU
roots, and document that flushing is unnecessary for all flavors of MMUs
when zapping invalid/obsolete roots/pages.  The "handling" in the TDP MMU
is dead code, as zap_gfn_range() is called with shared=true, in which
case it will never return true due to the flushing being handled by
tdp_mmu_zap_spte_atomic().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 10 +++++++---
 arch/x86/kvm/mmu/tdp_mmu.c | 15 ++++++++++-----
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6549c13e89d9..f660906c8230 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5645,9 +5645,13 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 	}
 
 	/*
-	 * Trigger a remote TLB flush before freeing the page tables to ensure
-	 * KVM is not in the middle of a lockless shadow page table walk, which
-	 * may reference the pages.
+	 * Kick all vCPUs (via remote TLB flush) before freeing the page tables
+	 * to ensure KVM is not in the middle of a lockless shadow page table
+	 * walk, which may reference the pages.  The remote TLB flush itself is
+	 * not required and is simply a convenient way to kick vCPUs as needed.
+	 * KVM performs a local TLB flush when allocating a new root (see
+	 * kvm_mmu_load()), and the reload in the caller ensure no vCPUs are
+	 * running with an obsolete MMU.
 	 */
 	kvm_mmu_commit_zap_page(kvm, &kvm->arch.zapped_obsolete_pages);
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 66b75c197c94..87785dce1bd4 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -844,12 +844,20 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 {
 	struct kvm_mmu_page *root;
-	bool flush = false;
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
 	for_each_invalid_tdp_mmu_root_yield_safe(kvm, root) {
-		flush = zap_gfn_range(kvm, root, 0, -1ull, true, flush, true);
+		/*
+		 * A TLB flush is unnecessary, invalidated roots are guaranteed
+		 * to be unreachable by the guest (see kvm_tdp_mmu_put_root()
+		 * for more details), and unlike the legacy MMU, no vCPU kick
+		 * is needed to play nice with lockless shadow walks as the TDP
+		 * MMU protects its paging structures via RCU.  Note, zapping
+		 * will still flush on yield, but that's a minor performance
+		 * blip and not a functional issue.
+		 */
+		(void)zap_gfn_range(kvm, root, 0, -1ull, true, false, true);
 
 		/*
 		 * Put the reference acquired in kvm_tdp_mmu_invalidate_roots().
@@ -857,9 +865,6 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 		 */
 		kvm_tdp_mmu_put_root(kvm, root, true);
 	}
-
-	if (flush)
-		kvm_flush_remote_tlbs(kvm);
 }
 
 /*
-- 
2.34.1.448.ga2b2bfdf31-goog

