Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20774A7D1B
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 02:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348662AbiBCBBL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 20:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348654AbiBCBBK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 20:01:10 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED3EC061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 17:01:10 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id b9-20020a63e709000000b00362f44b02aeso553471pgi.17
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 17:01:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=P2nMI/ec0k+rgC8gRDLK+pDpIPlzWQwlvtvvXy44AgM=;
        b=ZJytYEy/Q/1huO5wjouG616p7mPrgOPz53jOUe6r6aEcGKu2nCD5kkr+i6QNS9mQen
         /U0XcxT5QlExhb6AhScqBjFU6JGJPNEAyZyX+cjWtonmdHxVAZOBYeaRuqQnlaXwj50g
         X4iT/zXNeuKsufWZEiz6FQOqCmhStEA0Cep1CYJXfGPOypLQhnW9DgOZyruvo2V9AM/D
         Iiv6V4y1LsW0Fm2V/Rw1GEB7kcWVq4lFMqQM5lNM+4Qhq8G7lHCDbahpHiDjy8erVYtW
         7Fm5vj1rnrSDGGmA5E2dAurtEXgNqBDERJCQMOG4Qe0/351kQZOkbO17zZtfuAik/BBL
         5pPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=P2nMI/ec0k+rgC8gRDLK+pDpIPlzWQwlvtvvXy44AgM=;
        b=lTCXtue6mwt2a67+YovcVAvlgelRIqqO6f0uS3gYU0tuatat602RXkyGuj+xzinCFw
         liskVXHVVL61eiWm23uWJkqyqwWbnqf7PSnsDVHDoOLYxMuZxMtWceK+zo9ddWEEjFa6
         gIupJ7SBfrxnQ/gtHrP0TkrvlqSSyVjWEO6mmZMa6iNvBAFPcHHe7OtVsOf6reCShjY1
         qgN1txn4A9ToBm6vZIsC3tAp6iEMkALefdb9OlBU/d3LMcpvPpuU3daDi9vR0buS6hA3
         hA0xSr3XqsKQ78+duLUE59AV1S890G1fA6ACjQIHKU87ma5c8/Ro1RGQDrF7ru1eXvNi
         iZhg==
X-Gm-Message-State: AOAM531OmhL05/Z+/imifMmd3FF5I4oco3ptfJ95Y/y7+avbvgAuf9Ip
        si1wBbQdiFbE+fmwf5iTM4oIn1AgMr7f0w==
X-Google-Smtp-Source: ABdhPJwgr824OCtUNEUAY+htDI5fMYyvkuo+dbXjawJ6uSYTVedYJfXg2tID0VJ3vagPNzm4/W1ePm2izX/Jkw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:3648:: with SMTP id
 nh8mr11125338pjb.145.1643850070308; Wed, 02 Feb 2022 17:01:10 -0800 (PST)
Date:   Thu,  3 Feb 2022 01:00:34 +0000
In-Reply-To: <20220203010051.2813563-1-dmatlack@google.com>
Message-Id: <20220203010051.2813563-7-dmatlack@google.com>
Mime-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 06/23] KVM: x86/mmu: Separate shadow MMU sp allocation from initialization
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

Separate the code that allocates a new shadow page from the vCPU caches
from the code that initializes it. This is in preparation for creating
new shadow pages from VM ioctls for eager page splitting, where we do
not have access to the vCPU caches.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 44 +++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 49f82addf4b5..d4f90a10b652 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1718,7 +1718,7 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_sp(struct kvm_vcpu *vcpu, int direct)
+static struct kvm_mmu_page *kvm_mmu_alloc_sp(struct kvm_vcpu *vcpu, bool direct)
 {
 	struct kvm_mmu_page *sp;
 
@@ -1726,16 +1726,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_sp(struct kvm_vcpu *vcpu, int direct)
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
 	if (!direct)
 		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
-	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
-	/*
-	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
-	 * depends on valid pages being added to the head of the list.  See
-	 * comments in kvm_zap_obsolete_pages().
-	 */
-	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
-	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
-	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
 	return sp;
 }
 
@@ -2144,27 +2135,34 @@ static struct kvm_mmu_page *kvm_mmu_get_existing_sp(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
-static struct kvm_mmu_page *kvm_mmu_create_sp(struct kvm_vcpu *vcpu,
-					      struct kvm_memory_slot *slot,
-					      gfn_t gfn,
-					      union kvm_mmu_page_role role)
+
+static void kvm_mmu_init_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
+			    struct kvm_memory_slot *slot, gfn_t gfn,
+			    union kvm_mmu_page_role role)
 {
-	struct kvm_mmu_page *sp;
 	struct hlist_head *sp_list;
 
-	++vcpu->kvm->stat.mmu_cache_miss;
+	++kvm->stat.mmu_cache_miss;
+
+	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
-	sp = kvm_mmu_alloc_sp(vcpu, role.direct);
 	sp->gfn = gfn;
 	sp->role = role;
+	sp->mmu_valid_gen = kvm->arch.mmu_valid_gen;
 
-	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
+	/*
+	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
+	 * depends on valid pages being added to the head of the list.  See
+	 * comments in kvm_zap_obsolete_pages().
+	 */
+	list_add(&sp->link, &kvm->arch.active_mmu_pages);
+	kvm_mod_used_mmu_pages(kvm, 1);
+
+	sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 	hlist_add_head(&sp->hash_link, sp_list);
 
 	if (!role.direct)
-		account_shadowed(vcpu->kvm, slot, sp);
-
-	return sp;
+		account_shadowed(kvm, slot, sp);
 }
 
 static struct kvm_mmu_page *kvm_mmu_get_sp(struct kvm_vcpu *vcpu, gfn_t gfn,
@@ -2179,8 +2177,10 @@ static struct kvm_mmu_page *kvm_mmu_get_sp(struct kvm_vcpu *vcpu, gfn_t gfn,
 		goto out;
 
 	created = true;
+	sp = kvm_mmu_alloc_sp(vcpu, role.direct);
+
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	sp = kvm_mmu_create_sp(vcpu, slot, gfn, role);
+	kvm_mmu_init_sp(vcpu->kvm, sp, slot, gfn, role);
 
 out:
 	trace_kvm_mmu_get_page(sp, created);
-- 
2.35.0.rc2.247.g8bbb082509-goog

