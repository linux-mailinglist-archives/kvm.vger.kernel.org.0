Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAEC84EF943
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 19:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350672AbiDAR6F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 13:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236237AbiDAR6B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 13:58:01 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FDA1834D4
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 10:56:11 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id l6-20020a170903120600b0014f43ba55f3so1808110plh.11
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 10:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IyIPSk2/EaBUB0UobyNpb06WjR6I1O9i3ZizvW3fhmY=;
        b=diK+NDVVMnH1euNmcgNZkZR+RNe+RtbEPnphRRHdwnohQBdcNG3DKV2+OalZZ9dtiO
         4U1BmQRB9ltXsq1iribzjEnPiYHQfyjaB/RIv7u3RQME2nqt4UISDss9FwhaKRI73n2M
         bMU+zTqvPQzdMjCfjifjO/HgM4CjFbg0oko4cVui9/LHWSrFQKcR1tLhe7lbcKG+MY6Q
         lj9/alcDyXKJ/nW3dpp0m5fF9issvOVGtIPN401aoBG2OVH4cv2Xqlye/tg/RF+3/hn7
         WxjoFGMkrlclU9nEnzQJ5GSO36yNskFztCeAocXYe1LYhR2jSCTTrWpJUtyLXPUObvDR
         s/ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IyIPSk2/EaBUB0UobyNpb06WjR6I1O9i3ZizvW3fhmY=;
        b=F7ZAM2UEXFADa4OLKdt3br7oI/NIqvlulzdP0r8D/P1ZTJkt3xcfWo+vJiD4afRhaf
         BMiQXIVrcGEtcPxYDfIEY7SJx2BoSAXt4NgMIDSnry2eEgjuSIJ/HgLFK48wfcBBtRmY
         2SKbD3pnBfoHDTNfuCwGiH1xaDoP7eOOZAbsT4gvtns5V+eDxaT2OKjNVtepD0wMw2eH
         rWLKUF3JKjAa7zb86Heul4hyS/lbZbDSPmIs53mhKtjlDhehI/HQ7Zjut7MDwQcMMtsY
         aMRt2crVXJwTCRsIRdjqNTDbYrwt149DsSd1wQscnvvmcLC7INDM4ntjw+pCcqprQWgZ
         5FHw==
X-Gm-Message-State: AOAM533rlZ1+raSs1+FONCt64JuWUawiHmDfgPObDdK0SKJ0M+xDtPQX
        EOU4buWGLiT2Nu7nkYhd/Q1sBl2L/u575Q==
X-Google-Smtp-Source: ABdhPJw+3njlRranWemDGRAFfxcGs6Z7lxR+Q6odwZANW7lQMpZ7k6xIEK9JVJtusBFO1h+uHnsiH7sfkuQYbQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:2d0:b0:4f4:1f34:e39d with SMTP
 id b16-20020a056a0002d000b004f41f34e39dmr12123192pft.14.1648835771030; Fri,
 01 Apr 2022 10:56:11 -0700 (PDT)
Date:   Fri,  1 Apr 2022 17:55:37 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-7-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 06/23] KVM: x86/mmu: Pass memslot to kvm_mmu_new_shadow_page()
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Passing the memslot to kvm_mmu_new_shadow_page() avoids the need for the
vCPU pointer when write-protecting indirect 4k shadow pages. This moves
us closer to being able to create new shadow pages during VM ioctls for
eager page splitting, where there is not vCPU pointer.

This change does not negatively impact "Populate memory time" for ept=Y
or ept=N configurations since kvm_vcpu_gfn_to_memslot() caches the last
use slot. So even though we now look up the slot more often, it is a
very cheap check.

Opportunistically move the code to write-protect GFNs shadowed by
PG_LEVEL_4K shadow pages into account_shadowed() to reduce indentation
and consolidate the code. This also eliminates a memslot lookup.

No functional change intended.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dc1825de0752..abfb3e5d1372 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -793,16 +793,14 @@ void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn)
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
@@ -810,6 +808,9 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 						    KVM_PAGE_TRACK_WRITE);
 
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
+
+	if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
+		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
 }
 
 void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
@@ -2123,6 +2124,7 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
 }
 
 static struct kvm_mmu_page *kvm_mmu_new_shadow_page(struct kvm_vcpu *vcpu,
+						    struct kvm_memory_slot *slot,
 						    gfn_t gfn,
 						    union kvm_mmu_page_role role)
 {
@@ -2138,11 +2140,8 @@ static struct kvm_mmu_page *kvm_mmu_new_shadow_page(struct kvm_vcpu *vcpu,
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
@@ -2151,13 +2150,15 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 						    gfn_t gfn,
 						    union kvm_mmu_page_role role)
 {
+	struct kvm_memory_slot *slot;
 	struct kvm_mmu_page *sp;
 	bool created = false;
 
 	sp = kvm_mmu_find_shadow_page(vcpu, gfn, role);
 	if (!sp) {
 		created = true;
-		sp = kvm_mmu_new_shadow_page(vcpu, gfn, role);
+		slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+		sp = kvm_mmu_new_shadow_page(vcpu, slot, gfn, role);
 	}
 
 	trace_kvm_mmu_get_page(sp, created);
-- 
2.35.1.1094.g7c7d902a7c-goog

