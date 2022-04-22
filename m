Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532B550C3C3
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 01:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbiDVWQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 18:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbiDVWPh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 18:15:37 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE21731A152
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 14:06:04 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id z5-20020a170902ccc500b0015716eaec65so5386835ple.14
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 14:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eu8VJbJguY6ZXLXdguLoPmTx5E277sRGDrrNJcFdDls=;
        b=mm+KqjDQ8J0VSRw/QbSRolONpDUykCEYi89d8db8fl+iMViZR8v5A2X+QebpfJFc6B
         C8OURrG9LEQ4a3Wytvf4Ke9Q4CLrkDEndf5ycAdjvcdDkpbRxN0Yl+KrHS7izEFDlTwz
         c60cSQk5zb2UrX23tjZkqU3oH6gqEVS09yNyvaqqAH1hcARFFV1SltSJ/hCHEk8urLQl
         aRxdC99NmJrI6wfB5XGr20cRyUEx0oF3aql6vDmSs5mcnQ4VKFMevlqhMefHONh7+Oxk
         PfA3mhq70dtJJldDxC9vfyjDn822V20AWlkPT4ytIG7T7bQaaHlOPvaTeK89XHUFktN4
         Evtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eu8VJbJguY6ZXLXdguLoPmTx5E277sRGDrrNJcFdDls=;
        b=rvYUxNuGtf5E4U7ujtG5LvNArlekUMMIi4coaanZKkQfcy8iAuuuagWG9WYQ6vvn8/
         L5ieUrUAzIX8qmZAKr6QSksXWJw+GnNum/ItzjZC2D4wm9IeoUOZWeT//oiOahGNFbYo
         74gJmYsWq266F6sEsp7eu8mLhTSnEvIQ5YxvicUFqmDx+00Vw00hRK0vW431FSKF9r6T
         8Kdgo2aJI3GXTbf2aKkyzDhTHc8dofzHzz9L030KMMq67GPCd3/r3XlyWuHgimSucJAp
         oIA7DkzfqrbZ4pS7snavMS59i4d9ZQwAaAterhp9bTM83Qu0F3OUWKVPEdr2c1wX7NK5
         XvGA==
X-Gm-Message-State: AOAM531XKE+lpqyAmttTMDhgYug7/93je/wnZj4FdlzAHpPtcHEkoFtr
        3W0fjIraSlu0Mdvx1GLjUq2Niq1g2FubsA==
X-Google-Smtp-Source: ABdhPJzGn8bnFbc/Hfs0LpuWfl2EI/jAUqlaxIL7OMkYkvAkhScJ3fiquDkJMS7/S7081qV96um484xUT08c2g==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:e803:b0:15c:e281:de8f with SMTP
 id u3-20020a170902e80300b0015ce281de8fmr838250plg.13.1650661564401; Fri, 22
 Apr 2022 14:06:04 -0700 (PDT)
Date:   Fri, 22 Apr 2022 21:05:36 +0000
In-Reply-To: <20220422210546.458943-1-dmatlack@google.com>
Message-Id: <20220422210546.458943-11-dmatlack@google.com>
Mime-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v4 10/20] KVM: x86/mmu: Pass kvm pointer separately from vcpu
 to kvm_mmu_find_shadow_page()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Get the kvm pointer from the caller, rather than deriving it from
vcpu->kvm, and plumb the kvm pointer all the way from
kvm_mmu_get_shadow_page(). With this change in place, the vcpu pointer
is only needed to sync indirect shadow pages. In other words,
__kvm_mmu_get_shadow_page() can now be used to get *direct* shadow pages
without a vcpu pointer. This enables eager page splitting, which needs
to allocate direct shadow pages during VM ioctls.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index df110e0d57cf..04029c01aebd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2003,7 +2003,8 @@ static void clear_sp_write_flooding_count(u64 *spte)
 	__clear_sp_write_flooding_count(sptep_to_sp(spte));
 }
 
-static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
+static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
+						     struct kvm_vcpu *vcpu,
 						     gfn_t gfn,
 						     struct hlist_head *sp_list,
 						     union kvm_mmu_page_role role)
@@ -2013,7 +2014,7 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
 	int collisions = 0;
 	LIST_HEAD(invalid_list);
 
-	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
+	for_each_valid_sp(kvm, sp, sp_list) {
 		if (sp->gfn != gfn) {
 			collisions++;
 			continue;
@@ -2030,7 +2031,7 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
 			 * upper-level page will be write-protected.
 			 */
 			if (role.level > PG_LEVEL_4K && sp->unsync)
-				kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
+				kvm_mmu_prepare_zap_page(kvm, sp,
 							 &invalid_list);
 			continue;
 		}
@@ -2058,7 +2059,7 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
 
 			WARN_ON(!list_empty(&invalid_list));
 			if (ret > 0)
-				kvm_flush_remote_tlbs(vcpu->kvm);
+				kvm_flush_remote_tlbs(kvm);
 		}
 
 		__clear_sp_write_flooding_count(sp);
@@ -2067,13 +2068,13 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
 	}
 
 	sp = NULL;
-	++vcpu->kvm->stat.mmu_cache_miss;
+	++kvm->stat.mmu_cache_miss;
 
 out:
-	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
+	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
-	if (collisions > vcpu->kvm->stat.max_mmu_page_hash_collisions)
-		vcpu->kvm->stat.max_mmu_page_hash_collisions = collisions;
+	if (collisions > kvm->stat.max_mmu_page_hash_collisions)
+		kvm->stat.max_mmu_page_hash_collisions = collisions;
 	return sp;
 }
 
@@ -2118,7 +2119,8 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 	return sp;
 }
 
-static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
+static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
+						      struct kvm_vcpu *vcpu,
 						      struct shadow_page_caches *caches,
 						      gfn_t gfn,
 						      union kvm_mmu_page_role role)
@@ -2127,12 +2129,12 @@ static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 	struct kvm_mmu_page *sp;
 	bool created = false;
 
-	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
+	sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 
-	sp = kvm_mmu_find_shadow_page(vcpu, gfn, sp_list, role);
+	sp = kvm_mmu_find_shadow_page(kvm, vcpu, gfn, sp_list, role);
 	if (!sp) {
 		created = true;
-		sp = kvm_mmu_alloc_shadow_page(vcpu->kvm, caches, gfn, sp_list, role);
+		sp = kvm_mmu_alloc_shadow_page(kvm, caches, gfn, sp_list, role);
 	}
 
 	trace_kvm_mmu_get_page(sp, created);
@@ -2149,7 +2151,7 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 		.gfn_array_cache = &vcpu->arch.mmu_gfn_array_cache,
 	};
 
-	return __kvm_mmu_get_shadow_page(vcpu, &caches, gfn, role);
+	return __kvm_mmu_get_shadow_page(vcpu->kvm, vcpu, &caches, gfn, role);
 }
 
 static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, u32 access)
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

