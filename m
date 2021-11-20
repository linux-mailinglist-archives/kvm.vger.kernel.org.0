Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DF2457B96
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 05:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236533AbhKTE4M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 23:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236230AbhKTEym (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 23:54:42 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10FCC0613FD
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:05 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id p16-20020a170902e75000b0014271728fd6so5699916plf.18
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=MH2AUHVRIZhtROi1wUUoi6p64S7AM5UJwN9jo7kK5K4=;
        b=HEAD2MGrJh1JZxqAXwtHth0dcTykme8tJfJVnbHH9ARwbHpPa6bI89XSMrWgypcvWs
         4ZMSLRGthF9dbN/v8+bh/hwwm1iwI8yHxP5Qyuz7QShTYivvH2VFSUkRLi6fYUkVOCgu
         rIpCm1cQOkuaIvLm9y/qtbIe3c3ws1JhtX0QJjtBqo8nD4eKE6pHS3T979iRhZnP+YoE
         CrxkDsVJHQvTTIR/SDZQ++lWXBeyY8FFcMDz8+ZnwhPLMrVVrHSppLtosLO03ADV700K
         uqobkZ9AN0fNPTzulf4uKPlEFmW3fd19aYxMU99QkISBOioTV5gSnlG8FlzL0Q3VeRJ4
         BOSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=MH2AUHVRIZhtROi1wUUoi6p64S7AM5UJwN9jo7kK5K4=;
        b=BzXhCmoF5duqsiLplq98FbL8OeYMkU/llmVYaunYSWkGPf0kckX617G/LOBgSnLDLg
         cyHoQy1+KfsQ5ZWYz5VXgZ85EfF7A9sx25RCwH/kOivvtJWjklvZ6AaMrPz7UHisQbL4
         GO/KhfeQlwJUIK7Rq5xSeelhRKBINJUCTGGo//SQGej7iF1Vj1s0XMSp8sS4YRiOnMQg
         4Q0Uzb/qHvqNisyMx7Wq9A8sFMOReYlwouFcYcOymyxhQMplMZaLhDHoqxQsyiRKtHEk
         53CroSTiyPn8bw6OwttDuD/AoNhYNBGoPiFQZ/qaA6M+/AWCsyfWlwAZ28yweRT4Uwo2
         GHRQ==
X-Gm-Message-State: AOAM533uqzv2BR6p0Z6X6AHSwacSsBTbtFElRrnX6iFc6MPUkt/CwfWt
        KYzB2ByiG7Vf5hHItmkWqhiuQJ6KWwA=
X-Google-Smtp-Source: ABdhPJwkXsHa1ZxWg33eTBjj65cC+yUKS21/OClqJHqBL3Lo/EIK+5K+Z5udYfgnQan4eUH1w7c4a0lyBjY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:1103:b0:143:a593:dc41 with SMTP id
 n3-20020a170903110300b00143a593dc41mr83678976plh.5.1637383865389; Fri, 19 Nov
 2021 20:51:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 04:50:25 +0000
In-Reply-To: <20211120045046.3940942-1-seanjc@google.com>
Message-Id: <20211120045046.3940942-8-seanjc@google.com>
Mime-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 07/28] KVM: x86/mmu: Document that zapping invalidated roots
 doesn't need to flush
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Ben Gardon <bgardon@google.com>
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
index 3adac2630c4c..e00e46205730 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5642,9 +5642,13 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
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
index 981fb0517384..4305ee8e3de3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -833,7 +833,6 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 {
 	struct kvm_mmu_page *next_root;
 	struct kvm_mmu_page *root;
-	bool flush = false;
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
@@ -846,7 +845,16 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 
 		rcu_read_unlock();
 
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
 		 * Put the reference acquired in
@@ -860,9 +868,6 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 	}
 
 	rcu_read_unlock();
-
-	if (flush)
-		kvm_flush_remote_tlbs(kvm);
 }
 
 /*
-- 
2.34.0.rc2.393.gf8c9666880-goog

