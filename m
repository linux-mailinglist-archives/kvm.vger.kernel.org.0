Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79EC94A7D23
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 02:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiBCBBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 20:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348654AbiBCBBI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 20:01:08 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E70C061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 17:01:07 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id i23-20020a635417000000b00364c29f39aaso569611pgb.8
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 17:01:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cj2jh92JV4tPPaqu2IJj/uC6sjmdjzSptfF46c+3oo8=;
        b=P1yqX+Yx7OHPoM8icN+XvQEpmdYP9PFhOmc19vsJBBzBHbD6Nh8wAYlh9YtAG/x3TQ
         S50J3uMQw8kUewpJ/eVpo2q2QYK9vWOvym/0qyA29i7Zth5ZQBjGi6BagifIQDBMoN5O
         88ImHOQmPI4mZgc1G3CEXZ20qwmOsJ7oTr3ideTiwJSHytelygGSLCXpbiIv5WaLLOEM
         b+OoRwpLPxcPeB3NSuSZxjxfxoo8RQMnfRxtm4BqpR0cOhgvidLNTgaem1wXfblt75nD
         USUET4TDR6T/d4ibIdRNDweR3e5YMlp5pZtQ52CgBF08My8unwvjwa/n9YTWCfw3Kv0T
         lc5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cj2jh92JV4tPPaqu2IJj/uC6sjmdjzSptfF46c+3oo8=;
        b=YuI7cXwhQQhfE/mdSLiHsKKprrDLxJiP8Q2ZK1XVCw3ixU2rlfefGB9eSBJVwORxLr
         a8ne4IAD08Jt+qcaoV0EC2mkKw3HtdObxdmDvAMZ8uAOlWIzm+s3eKtH1x8w4JbfVAcF
         PEHYnlX6YmstA9I35QhmEGwzawPIYnk4PKIiaa8NNN3T3HoApdgQvywgUqDKH5gzQDPD
         MQMzdKrFc8OYCieUjLaM/IImrMRRNVKGlO54u/RFmexVtGGt8cxKLnCfyuJTL/mUqxxh
         0XYIKsRJZSfi5upiBUnAL2QdvNsZtsc1YVVNbVRHSKx5Uc96W+lTOx/Yu4qdm//ZuIrS
         zDsg==
X-Gm-Message-State: AOAM532BwD96v7o3z4UBQzLaAAfNuSLRf2/xHGQS3PUiUkHpId4jTF9H
        +diywKZuvq87WqZVPiQpcPyPtW/ly4jXXQ==
X-Google-Smtp-Source: ABdhPJz+CcTaXA/f9HJ9QAGYSxF2rMkcxBlYoYfF058AErM+9ZNxYG/rxvAoC/+6KjQCgaELY5+0b8QBavbuDg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:f54b:: with SMTP id
 h11mr33157406plf.91.1643850067203; Wed, 02 Feb 2022 17:01:07 -0800 (PST)
Date:   Thu,  3 Feb 2022 01:00:32 +0000
In-Reply-To: <20220203010051.2813563-1-dmatlack@google.com>
Message-Id: <20220203010051.2813563-5-dmatlack@google.com>
Mime-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 04/23] KVM: x86/mmu: Rename shadow MMU functions that deal
 with shadow pages
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

Rename 3 functions:

  kvm_mmu_get_page()   -> kvm_mmu_get_sp()
  kvm_mmu_alloc_page() -> kvm_mmu_alloc_sp()
  kvm_mmu_free_page()  -> kvm_mmu_free_sp()

This change makes it clear that these functions deal with shadow pages
rather than struct pages.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 24b3cf53aa12..6f55af9c66db 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1679,7 +1679,7 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
 }
 
-static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
+static void kvm_mmu_free_sp(struct kvm_mmu_page *sp)
 {
 	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
 	hlist_del(&sp->hash_link);
@@ -1717,7 +1717,7 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
+static struct kvm_mmu_page *kvm_mmu_alloc_sp(struct kvm_vcpu *vcpu, int direct)
 {
 	struct kvm_mmu_page *sp;
 
@@ -2152,7 +2152,7 @@ static struct kvm_mmu_page *kvm_mmu_create_sp(struct kvm_vcpu *vcpu,
 
 	++vcpu->kvm->stat.mmu_cache_miss;
 
-	sp = kvm_mmu_alloc_page(vcpu, role.direct);
+	sp = kvm_mmu_alloc_sp(vcpu, role.direct);
 	sp->gfn = gfn;
 	sp->role = role;
 
@@ -2168,8 +2168,8 @@ static struct kvm_mmu_page *kvm_mmu_create_sp(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
-static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
-					     union kvm_mmu_page_role role)
+static struct kvm_mmu_page *kvm_mmu_get_sp(struct kvm_vcpu *vcpu, gfn_t gfn,
+					   union kvm_mmu_page_role role)
 {
 	struct kvm_mmu_page *sp;
 	bool created = false;
@@ -2208,7 +2208,7 @@ static struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu,
 
 	role = kvm_mmu_child_role(parent_sp, direct, access);
 
-	return kvm_mmu_get_page(vcpu, gfn, role);
+	return kvm_mmu_get_sp(vcpu, gfn, role);
 }
 
 static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterator,
@@ -2478,7 +2478,7 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 
 	list_for_each_entry_safe(sp, nsp, invalid_list, link) {
 		WARN_ON(!sp->role.invalid || sp->root_count);
-		kvm_mmu_free_page(sp);
+		kvm_mmu_free_sp(sp);
 	}
 }
 
@@ -3406,7 +3406,7 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
 		role.quadrant = quadrant;
 	}
 
-	sp = kvm_mmu_get_page(vcpu, gfn, role);
+	sp = kvm_mmu_get_sp(vcpu, gfn, role);
 	++sp->root_count;
 
 	return __pa(sp->spt);
-- 
2.35.0.rc2.247.g8bbb082509-goog

