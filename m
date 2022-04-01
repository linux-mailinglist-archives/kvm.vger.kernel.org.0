Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 795D04EF955
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 19:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350712AbiDAR6T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 13:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350714AbiDAR6M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 13:58:12 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22CD28D536
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 10:56:22 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id fh22-20020a17090b035600b001c6a163499cso1647745pjb.2
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 10:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=98QuPuIamNZ4VXhVyk60fd3jtdaNhZOSrUDoLns0RNg=;
        b=aUeZagy6oSm/W0IESWczDjmWRTSG4Npvh1AoFSuKwIbezAKth9hVIv88sZ1PVSs54P
         QuQzvJ5uvlUy4BZeBvhbx8V7VTbmtyOFBlVK6TO1Y5OqSJrdAWIzlesY9Y7Ef0+ulNiw
         etoPUBWitef9pf0CbOSZCO7DfbbKKlk5tLH4vpNPAoXH3otLyid9PS7TlLRXA2o/s6Zx
         14w18b1jE0xK/QCtfi7eO05rYdM47uPTnLEBVIcuO8jOAe+Yt04t1s8B7z6YuNT78vLP
         UhF/qof2Hy5JcUFWeN8ucBOI/LTmnlgblwP0QMCgT702dp28RE7ENQrHUu79Ry4+dba8
         IV1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=98QuPuIamNZ4VXhVyk60fd3jtdaNhZOSrUDoLns0RNg=;
        b=47lf5J+RIs316zqzODshOE+nysRU9j7ciO4HS5bRPKmrJm/UenalwrNAULLp1SW4t6
         5/cPCQw3eTggA6ZmKt/VAlRSUPQlJLhpiv3nE185eyo9j1PGt4S2fsZAk6gcYeKF906w
         LLkC0mFyiqFI/4EsUsuZQFzcUWYsJjHbnPheFsAywk1VsoVLtK1+ftSH1XMXuslu4oHA
         ouE4j9NZxL5XDhfhD1eWoKrR0CwNyzeRgGjasx0L25bmP7i7p3PWlfgMtt2jRLih3qav
         Qj4Xf1pxIWHwMok8Fw2grvGQDfqGEJx9C9TM/9XOLFJj2BCVGWc/b+zSHgiKGdUCCOB5
         2oRg==
X-Gm-Message-State: AOAM532FraTZFfPO+HBSnwRptUlmRI+jHzL4brU+Z8v7iznlQtoG7lD3
        awiavXOcheFU8UUFmYY7MYeH6hBuYd4M7A==
X-Google-Smtp-Source: ABdhPJz698nbKbYgL2dF565iPEoR7WzCc+Wp0S/qIabLKC8pciUWRSwlWFExH/GdxxtVuQGJTVkUd+56ESvveA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:1acb:b0:4fb:358f:fe87 with SMTP
 id f11-20020a056a001acb00b004fb358ffe87mr12183610pfv.75.1648835782098; Fri,
 01 Apr 2022 10:56:22 -0700 (PDT)
Date:   Fri,  1 Apr 2022 17:55:44 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-14-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 13/23] KVM: x86/mmu: Pass const memslot to
 init_shadow_page() and descendants
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

Use a const pointer so that init_shadow_page() can be called from
contexts where we have a const pointer.

No functional change intended.

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_page_track.h | 2 +-
 arch/x86/kvm/mmu/mmu.c                | 6 +++---
 arch/x86/kvm/mmu/mmu_internal.h       | 2 +-
 arch/x86/kvm/mmu/page_track.c         | 4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c            | 2 +-
 arch/x86/kvm/mmu/tdp_mmu.h            | 2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index eb186bc57f6a..3a2dc183ae9a 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -58,7 +58,7 @@ int kvm_page_track_create_memslot(struct kvm *kvm,
 				  unsigned long npages);
 
 void kvm_slot_page_track_add_page(struct kvm *kvm,
-				  struct kvm_memory_slot *slot, gfn_t gfn,
+				  const struct kvm_memory_slot *slot, gfn_t gfn,
 				  enum kvm_page_track_mode mode);
 void kvm_slot_page_track_remove_page(struct kvm *kvm,
 				     struct kvm_memory_slot *slot, gfn_t gfn,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1efe161f9c02..39d9cccbdc7e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -794,7 +794,7 @@ void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn)
 }
 
 static void account_shadowed(struct kvm *kvm,
-			     struct kvm_memory_slot *slot,
+			     const struct kvm_memory_slot *slot,
 			     struct kvm_mmu_page *sp)
 {
 	gfn_t gfn;
@@ -1373,7 +1373,7 @@ int kvm_cpu_dirty_log_size(void)
 }
 
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
-				    struct kvm_memory_slot *slot, u64 gfn,
+				    const struct kvm_memory_slot *slot, u64 gfn,
 				    int min_level)
 {
 	struct kvm_rmap_head *rmap_head;
@@ -2150,7 +2150,7 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
 }
 
 static void init_shadow_page(struct kvm *kvm, struct kvm_mmu_page *sp,
-			     struct kvm_memory_slot *slot, gfn_t gfn,
+			     const struct kvm_memory_slot *slot, gfn_t gfn,
 			     union kvm_mmu_page_role role)
 {
 	struct hlist_head *sp_list;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index d4e2de5f2a6d..b6e22ba9c654 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -134,7 +134,7 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
 void kvm_mmu_gfn_disallow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
-				    struct kvm_memory_slot *slot, u64 gfn,
+				    const struct kvm_memory_slot *slot, u64 gfn,
 				    int min_level);
 void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 					u64 start_gfn, u64 pages);
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 2e09d1b6249f..3e7901294573 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -84,7 +84,7 @@ int kvm_page_track_write_tracking_alloc(struct kvm_memory_slot *slot)
 	return 0;
 }
 
-static void update_gfn_track(struct kvm_memory_slot *slot, gfn_t gfn,
+static void update_gfn_track(const struct kvm_memory_slot *slot, gfn_t gfn,
 			     enum kvm_page_track_mode mode, short count)
 {
 	int index, val;
@@ -112,7 +112,7 @@ static void update_gfn_track(struct kvm_memory_slot *slot, gfn_t gfn,
  * @mode: tracking mode, currently only write track is supported.
  */
 void kvm_slot_page_track_add_page(struct kvm *kvm,
-				  struct kvm_memory_slot *slot, gfn_t gfn,
+				  const struct kvm_memory_slot *slot, gfn_t gfn,
 				  enum kvm_page_track_mode mode)
 {
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f6201b89045b..a04262bc34e2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1793,7 +1793,7 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
  * Returns true if an SPTE was set and a TLB flush is needed.
  */
 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
-				   struct kvm_memory_slot *slot, gfn_t gfn,
+				   const struct kvm_memory_slot *slot, gfn_t gfn,
 				   int min_level)
 {
 	struct kvm_mmu_page *root;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 5e5ef2576c81..c139635d4209 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -48,7 +48,7 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				       const struct kvm_memory_slot *slot);
 
 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
-				   struct kvm_memory_slot *slot, gfn_t gfn,
+				   const struct kvm_memory_slot *slot, gfn_t gfn,
 				   int min_level);
 
 void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
-- 
2.35.1.1094.g7c7d902a7c-goog

