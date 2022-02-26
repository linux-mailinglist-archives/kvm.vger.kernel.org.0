Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A65C4C5278
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 01:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240418AbiBZAQy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 19:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240295AbiBZAQv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 19:16:51 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCD921BC56
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:10 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id x194-20020a627ccb000000b004e103c5f726so3963750pfc.8
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=zez4Gs30dxckwmE+XcZFyy9DVdQB//tN93t4s3+TKo8=;
        b=GqRA+N2Xdwf0MftL4IZRlc9dGRi5XcOybgeQMHWIYaYTTz6Hx8v2f47ehCxN/l/R9M
         kotSaU4HDuDWT5tALQFjZhRpfwcjnlxxivgLf2wCd5sEECtGOVrWWSu0r2rWXsyrNp3u
         4kjtaVXDixoCG8jke13IHkMA8j4gSxD7ioBSj8yGRVaQXp9sIJmzq8yGgy50q+0UOQib
         5sW88eKK0j2TDfwRPwjzzV8XJSA7IUyWpebMlxF9WIRudTDECqhWPwkEdpDoOzUcPL3f
         /KXhHnJJUBVsiuk67rQp7rnPQFUqSJpSR242fcjiM7/lQm8dGASJE6QUaGjD2KMzjQeW
         QomQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=zez4Gs30dxckwmE+XcZFyy9DVdQB//tN93t4s3+TKo8=;
        b=SiIuJP6czscp5mpoUMfHBqesNppX9XBRhh/lsRSJNqW0sqNBTNyRgCJaRRBD4u3TuU
         ofkm5S+Apgz6qbEcIxVSkTkHgxkI6cfF4f2VFBO54iyhmD45dtAJ5DyWVNi2L/AQvYz+
         C3ayP4mplq6IDFZo0/RKhMDGTWjLAfNsGdbZrkA5EsMLlRV8+u1/IUGtyLHrgWC1+YN2
         lyi5YuPZ1+mUmDouFVYRri8DDGVGBNMeOVsedChWHbxE5c1U3UGyz6uxXEMgkxK+i7pm
         0HcPRAQPONljGrU3ZZpo5NY8XQlRfMpnFqytUqAKiS+1ovB6jLsJYZEncMeWdxWxX1ii
         Dk/g==
X-Gm-Message-State: AOAM53376uF1Ua7NqEeZVuw3PP6n1U1KdC7v4C+A9/50ACq3dBigRh3R
        cRlnkI04RX/9PqcqkhQ9c1IWOVd/Rbw=
X-Google-Smtp-Source: ABdhPJyMKt5K1hday9KJX2febmO2RNxhZGslMxjGB3MrHRn5iFHo+/U2JORNEGrCHZPM5iVC7xM4YIWEgGI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:f68b:b0:14f:c84c:ad6d with SMTP id
 l11-20020a170902f68b00b0014fc84cad6dmr9734294plg.155.1645834569885; Fri, 25
 Feb 2022 16:16:09 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 26 Feb 2022 00:15:23 +0000
In-Reply-To: <20220226001546.360188-1-seanjc@google.com>
Message-Id: <20220226001546.360188-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 05/28] KVM: x86/mmu: Document that zapping invalidated
 roots doesn't need to flush
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
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
index 5a931c89d27b..1c4b84e80841 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5615,9 +5615,13 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
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
index e35bd88d92fd..5994db5d5226 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -843,12 +843,20 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
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
@@ -856,9 +864,6 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 		 */
 		kvm_tdp_mmu_put_root(kvm, root, true);
 	}
-
-	if (flush)
-		kvm_flush_remote_tlbs(kvm);
 }
 
 /*
-- 
2.35.1.574.g5d30c73bfb-goog

