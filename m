Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16F14A7D21
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 02:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348672AbiBCBBQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 20:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348666AbiBCBBQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 20:01:16 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB8CC061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 17:01:16 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id e130-20020a255088000000b006126feb051eso2634412ybb.18
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 17:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DcQvm0EnB27B5c1LzMvvmcIJJOtlNTGQ0W7y9yZFrLE=;
        b=UN7sv8X5yib9iHjcaUAjCimKFp5qmLsvKdHpM0Z4GZROXjVmmyDD6Yl8XQjTIcFalZ
         VW70bey5N68XuYooFebdEOEGxYIkeL8vnhB5PwtwcUJaOK8jo9qxopbNAQ3kNMNtbVVv
         woxKLaYAisxTHLeurTU3BKQV/4scJTXJc5MtJSx3WvC4xvAe15J26RQDdXOAruMI9/r9
         2H5x3mEP2frMjrJwQAMpgy8oTtndhGyExiuXimJujQ78DgYE7/y0WjT7iv8uRcJimMEX
         l80advOSJAl5b/kcgJOo6JVSg3A6rU2LgW3qTSvRHchu9U1ATVb7WNQNZ+XdpdcpoHnz
         +Iqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DcQvm0EnB27B5c1LzMvvmcIJJOtlNTGQ0W7y9yZFrLE=;
        b=v5uOmJ7YwMvT5rRrWk85HI8ZxFzhDQdqBCGS//Yph6nIWVp5UmDcP1/wiEXc/fPdZT
         hLrjNEGrXs+tMqTO9DYrZD+axHbQ+DNh2RvhgeDPw0ammt3Dmq+tVwohVoHkmXGCymYi
         oMagrV+/UYedKuygG1+XJjVqdzMANtVZX8+7od023cB3ELDrzqeNJgUDUIM9t++WaDHJ
         gIylraYlw/pf/uszTYNm3N4gOxSip+E1efiqQwJWbwzgVQBTx5VIkcnXHbwXO8fA/xGd
         /nbsVUom5BRBs30RZofWpyB17VeRV4QXooyzNuv+1bM1YcIKjQUqWmfvDuzD2ncVrWld
         CVWw==
X-Gm-Message-State: AOAM531KJEJaX6Fxf3CR9zZgzZYsJOpLInUpUYBCytopVVeWlElvR+/g
        ZTabNMpgCBsKCDJz0+3YwQuCf8QtevHbrA==
X-Google-Smtp-Source: ABdhPJxibXTS8LAl6H9Rho8QdNL2VBve0j4bcdZ4cruygJ7zAniN7Duh1kRxfaGB/RYz6vJm5ruaMBV8uKu6vQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a81:18c1:: with SMTP id
 184mr2631374ywy.304.1643850075181; Wed, 02 Feb 2022 17:01:15 -0800 (PST)
Date:   Thu,  3 Feb 2022 01:00:37 +0000
In-Reply-To: <20220203010051.2813563-1-dmatlack@google.com>
Message-Id: <20220203010051.2813563-10-dmatlack@google.com>
Mime-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 09/23] KVM: x86/mmu: Use common code to allocate kvm_mmu_page
 structs from vCPU caches
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>, maciej.szmigiero@oracle.com,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that allocating a kvm_mmu_page struct is isolated to a helper
function, it can be re-used in the TDP MMU.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 2 +-
 arch/x86/kvm/mmu/mmu_internal.h | 1 +
 arch/x86/kvm/mmu/tdp_mmu.c      | 7 +------
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 09a178e64a04..48ebf2bebb90 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1715,7 +1715,7 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_sp(struct kvm_vcpu *vcpu, bool direct)
+struct kvm_mmu_page *kvm_mmu_alloc_sp(struct kvm_vcpu *vcpu, bool direct)
 {
 	struct kvm_mmu_page *sp;
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index c68f45c4a745..c5f2c0b9177d 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -162,6 +162,7 @@ void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
 struct kvm_mmu_page *kvm_mmu_alloc_direct_sp_for_split(gfp_t gfp);
 
+struct kvm_mmu_page *kvm_mmu_alloc_sp(struct kvm_vcpu *vcpu, bool direct);
 void kvm_mmu_free_sp(struct kvm_mmu_page *sp);
 
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 60bb29cd2b96..4ff1af24b5aa 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -172,12 +172,7 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 
 static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 {
-	struct kvm_mmu_page *sp;
-
-	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
-	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
-
-	return sp;
+	return kvm_mmu_alloc_sp(vcpu, true);
 }
 
 static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, gfn_t gfn,
-- 
2.35.0.rc2.247.g8bbb082509-goog

