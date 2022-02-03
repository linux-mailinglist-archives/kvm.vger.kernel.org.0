Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E34964A7D15
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 02:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348661AbiBCBBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 20:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245258AbiBCBBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 20:01:09 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691B3C061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 17:01:09 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id e37-20020a635465000000b00364dfbc8031so566548pgm.10
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 17:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CP4dB5ZYlRM1sQ3kgtH5k4DQM/Cy6892DHpE9lMRSSg=;
        b=pDaDLECbrKjt9eSgi8bK0sQSvctNeEZ81cUxhrK+N9YwlryjExu3neYJU42R+f/YVO
         bEtkgPANhdzItEeQqt8pd0nw/YXqDoPPiRUFYALlQ1QrVDRAG4mbB5FVT/p6neZ547dL
         ce3+Bgp1Y8auWtvXJBFyOcynQMhdLmChKCAAZHc24r3i/Q69WW38xBnZZyjXQDhN4vYj
         VGH3Er78H4ptteZ0a6GHT7eVNuns/lbimtFH+799HmHEPHDjQ+NNAkAKp1haCD5Xo/Es
         tGRB528vDh4hMYYF9s4xlenQ2qa2uewIpEZHI6UO29DqHFnWbgpHXVif9yZmXbzSarhq
         FoCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CP4dB5ZYlRM1sQ3kgtH5k4DQM/Cy6892DHpE9lMRSSg=;
        b=4agsCHsJ3YAnANBYdFePhxpbdeOgGa9roz6zCaUItS7YY2fibNIs7Fwg3D1NollCh+
         7jF7JP9veJVbrxS/GfnccwopQ3rfFgxOnIhxFKbh/ny5AXXmFZtPR0du1SbzkZS755g4
         NmIvC0ouY/f2D8GCuYChkwrIyQW73+TxhALgtC/0g1gnZu5QJkcD+pU6LVfVVo/O7jl+
         lFSPOZ0N7zRBsEM0YK/bDUhoy8HHNWtv6rjvHsexE+XA6HSrljb0JLdz2wfyvXgbNa/D
         1+oQrJFeQH8Meieexm2kP2FnWi6I8Zd38lIpY1EyIZ2YUZmFnIiYHjFm+QhzfHAFr1PR
         BZtg==
X-Gm-Message-State: AOAM533u8F1RYUfpX1oZPiOyk9l//ob7MKo2fYfUQqGZAFsKeVpPYLMO
        5v4ETDJDpa+k99kP5KOsNcgdWrd9wwy/Vw==
X-Google-Smtp-Source: ABdhPJyOXRBsMg9DgG+NXK8VQuqflvVK7oZKFYN8OLvqHYtvUcRswbreMjpWjJF8naLaUMWcImaz/bTkYxq/rA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:1513:: with SMTP id
 q19mr31896218pfu.12.1643850068867; Wed, 02 Feb 2022 17:01:08 -0800 (PST)
Date:   Thu,  3 Feb 2022 01:00:33 +0000
In-Reply-To: <20220203010051.2813563-1-dmatlack@google.com>
Message-Id: <20220203010051.2813563-6-dmatlack@google.com>
Mime-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 05/23] KVM: x86/mmu: Pass memslot to kvm_mmu_create_sp()
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

Passing the memslot to kvm_mmu_create_sp() avoids the need for the vCPU
pointer when write-protecting indirect 4k shadow pages. This moves us
closer to being able to create new shadow pages during VM ioctls for
eager page splitting, where there is not vCPU pointer.

This change does not negatively impact "Populate memory time" for ept=Y
or ept=N configurations since kvm_vcpu_gfn_to_memslot() caches the last
use slot. So even though we now look up the slot more often, it is a
very cheap check.

Opportunistically move the code to write-protect GFNs shadowed by
PG_LEVEL_4K shadow pages into account_shadowed() to reduce indentation
and consolidate the code. This also eliminates a memslot lookup.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6f55af9c66db..49f82addf4b5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -804,16 +804,14 @@ void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn)
 	update_gfn_disallow_lpage_count(slot, gfn, -1);
 }
 
-static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
+static void account_shadowed(struct kvm *kvm,
+			     struct kvm_memory_slot *slot,
+			     struct kvm_mmu_page *sp)
 {
-	struct kvm_memslots *slots;
-	struct kvm_memory_slot *slot;
 	gfn_t gfn;
 
 	kvm->arch.indirect_shadow_pages++;
 	gfn = sp->gfn;
-	slots = kvm_memslots_for_spte_role(kvm, sp->role);
-	slot = __gfn_to_memslot(slots, gfn);
 
 	/* the non-leaf shadow pages are keeping readonly. */
 	if (sp->role.level > PG_LEVEL_4K)
@@ -821,6 +819,9 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 						    KVM_PAGE_TRACK_WRITE);
 
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
+
+	if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
+		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
 }
 
 void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
@@ -2144,6 +2145,7 @@ static struct kvm_mmu_page *kvm_mmu_get_existing_sp(struct kvm_vcpu *vcpu,
 }
 
 static struct kvm_mmu_page *kvm_mmu_create_sp(struct kvm_vcpu *vcpu,
+					      struct kvm_memory_slot *slot,
 					      gfn_t gfn,
 					      union kvm_mmu_page_role role)
 {
@@ -2159,11 +2161,8 @@ static struct kvm_mmu_page *kvm_mmu_create_sp(struct kvm_vcpu *vcpu,
 	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 	hlist_add_head(&sp->hash_link, sp_list);
 
-	if (!role.direct) {
-		account_shadowed(vcpu->kvm, sp);
-		if (role.level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
-			kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
-	}
+	if (!role.direct)
+		account_shadowed(vcpu->kvm, slot, sp);
 
 	return sp;
 }
@@ -2171,6 +2170,7 @@ static struct kvm_mmu_page *kvm_mmu_create_sp(struct kvm_vcpu *vcpu,
 static struct kvm_mmu_page *kvm_mmu_get_sp(struct kvm_vcpu *vcpu, gfn_t gfn,
 					   union kvm_mmu_page_role role)
 {
+	struct kvm_memory_slot *slot;
 	struct kvm_mmu_page *sp;
 	bool created = false;
 
@@ -2179,7 +2179,8 @@ static struct kvm_mmu_page *kvm_mmu_get_sp(struct kvm_vcpu *vcpu, gfn_t gfn,
 		goto out;
 
 	created = true;
-	sp = kvm_mmu_create_sp(vcpu, gfn, role);
+	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+	sp = kvm_mmu_create_sp(vcpu, slot, gfn, role);
 
 out:
 	trace_kvm_mmu_get_page(sp, created);
-- 
2.35.0.rc2.247.g8bbb082509-goog

