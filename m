Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5259B529533
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 01:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350504AbiEPXWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 19:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350363AbiEPXWG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 19:22:06 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324DB434AC
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:21:58 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id y17-20020a637d11000000b003ab06870074so7999901pgc.15
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bjfKVQfFw+YVVLZ97EII30OJ+Br3uJ0BC6may3PgpYs=;
        b=R4/AJWKf2qGzFXsfnVKiM4NNw7/pARoBX+tBkZuy41e0vtzqxlmnCIrHsQyNeZoskD
         XraDZ4xEbhjWRsO4ud9nIRt+pA+wjqK5o3fIn1CK+p4lU+dGKQwWq/iDt1GIxFlr9B1a
         2Wjxmd3k+bw3KcOa/o+3zb2uocmxn4vCpjhW5cJjw755kBixn+PUy7UQLVaDgbIRwymi
         tIyc5O33fJZZLDGodsZHg1OB/7JDFWtI2q0O92V3K2/AfimK7Q/3LY69R1mtjOY9NgXg
         2fqt7x/qSXIUWrSEnkNpXDG1ie6gjpa+pnne4MgjFqbedNT0TUIHSa0CoxNXTs3IHyAD
         Wd7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bjfKVQfFw+YVVLZ97EII30OJ+Br3uJ0BC6may3PgpYs=;
        b=KCDJ/bbBcQJQrZOvZ6pL8DgSpG7z1CQHDJQxsf8pjmbBqO4b2jPcbkEqB6ybVQ+lKq
         DZErViQQ+U/HTvFSAEPs1YCtjRayFq//1N5ZW3o/N1jAq04+/q5xAdNt/0ej5YlAtCbq
         2qpnDRa2jSeotEvJaaW14ut/d4YWUt33vpaPidG+7tfahzlc4roDmtFyZVPxHTAsz7Db
         TY0ZJxnm9/lYmxBEBT3Kfl3qTrMTZzsnu2BP5OEELIGpaisfjzyq8IGvb9ZSfM9ZmhI8
         DZMTGlroN9FYPlmpqw/Lkw1VDatxUU6llSJkfVMsCwB4u5/0NZU4uOL7nk3CYm4WddHE
         mDOA==
X-Gm-Message-State: AOAM533jzDIzq4QbfF1rMlFomudFp8d9lD9i+A2JiVJ+CjQA/V6strA/
        CKQ12/BfkhoEF+72Z0cseV2mXGNeEFTfrg==
X-Google-Smtp-Source: ABdhPJyvVuGCncfVPBz1KFyVt0l5qHY6IpW2GqHJPL6xkWghdrwJY5Nn6kxvrEpBk+Mmnzjq21O5/WGcXwqEMQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:3654:b0:1db:fc80:584d with SMTP
 id nh20-20020a17090b365400b001dbfc80584dmr32992556pjb.215.1652743317317; Mon,
 16 May 2022 16:21:57 -0700 (PDT)
Date:   Mon, 16 May 2022 23:21:26 +0000
In-Reply-To: <20220516232138.1783324-1-dmatlack@google.com>
Message-Id: <20220516232138.1783324-11-dmatlack@google.com>
Mime-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v6 10/22] KVM: x86/mmu: Pass memory caches to allocate SPs separately
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
        Lai Jiangshan <jiangshanlai@gmail.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor kvm_mmu_alloc_shadow_page() to receive the caches from which it
will allocate the various pieces of memory for shadow pages as a
parameter, rather than deriving them from the vcpu pointer. This will be
useful in a future commit where shadow pages are allocated during VM
ioctls for eager page splitting, and thus will use a different set of
caches.

Preemptively pull the caches out all the way to
kvm_mmu_get_shadow_page() since eager page splitting will not be calling
kvm_mmu_alloc_shadow_page() directly.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6a3b1b00f02b..bad4dd5aa051 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2075,17 +2075,25 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
+/* Caches used when allocating a new shadow page. */
+struct shadow_page_caches {
+	struct kvm_mmu_memory_cache *page_header_cache;
+	struct kvm_mmu_memory_cache *shadow_page_cache;
+	struct kvm_mmu_memory_cache *gfn_array_cache;
+};
+
 static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
+						      struct shadow_page_caches *caches,
 						      gfn_t gfn,
 						      struct hlist_head *sp_list,
 						      union kvm_mmu_page_role role)
 {
 	struct kvm_mmu_page *sp;
 
-	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
-	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	sp = kvm_mmu_memory_cache_alloc(caches->page_header_cache);
+	sp->spt = kvm_mmu_memory_cache_alloc(caches->shadow_page_cache);
 	if (!role.direct)
-		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
+		sp->gfns = kvm_mmu_memory_cache_alloc(caches->gfn_array_cache);
 
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
@@ -2107,9 +2115,10 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
-static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
-						    gfn_t gfn,
-						    union kvm_mmu_page_role role)
+static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
+						      struct shadow_page_caches *caches,
+						      gfn_t gfn,
+						      union kvm_mmu_page_role role)
 {
 	struct hlist_head *sp_list;
 	struct kvm_mmu_page *sp;
@@ -2120,13 +2129,26 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 	sp = kvm_mmu_find_shadow_page(vcpu, gfn, sp_list, role);
 	if (!sp) {
 		created = true;
-		sp = kvm_mmu_alloc_shadow_page(vcpu, gfn, sp_list, role);
+		sp = kvm_mmu_alloc_shadow_page(vcpu, caches, gfn, sp_list, role);
 	}
 
 	trace_kvm_mmu_get_page(sp, created);
 	return sp;
 }
 
+static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
+						    gfn_t gfn,
+						    union kvm_mmu_page_role role)
+{
+	struct shadow_page_caches caches = {
+		.page_header_cache = &vcpu->arch.mmu_page_header_cache,
+		.shadow_page_cache = &vcpu->arch.mmu_shadow_page_cache,
+		.gfn_array_cache = &vcpu->arch.mmu_gfn_array_cache,
+	};
+
+	return __kvm_mmu_get_shadow_page(vcpu, &caches, gfn, role);
+}
+
 static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, u32 access)
 {
 	struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
-- 
2.36.0.550.gb090851708-goog

