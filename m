Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B80A526B52
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 22:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384314AbiEMU3F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 16:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384257AbiEMU3A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 16:29:00 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0451D90
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:28:46 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id h19-20020aa796d3000000b0050d3c025470so4495911pfq.0
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Q2iE0Cxpa01PZtydAP3+0EHT9/ovzFKtM4CTxOqopNo=;
        b=kBtgOZb6L01L9Scbsk0n3b6QXUjGTLwW6lXEIWk5vM2VilLkNRKTThEc67CyICmcwF
         vcTVppd0iFdeeb7Mmnohtzf86ll0NLPKIcb7HUv41efPtdWaC1ZEjj4ncSlKRpTNQnpT
         IuzmjMIAHKXiE33XdF3CkiVjrjYuKO5/cEELlNw3aYcqjBupe4yRnxeO+cS9LVBdF/hc
         V4ThqGXHdwel8AZNGb+m+R0GgCp0iEuSIz5bzLEtilh6UiTkOKdKCw1qHh5j+KPoBR2Q
         sL1eCqMeYRkaY5jCFp8Dfe8PAjC3dwvlrjkPo8fMjPM2zM96H1fjPXQyAwNdAKOdvh6T
         fLEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Q2iE0Cxpa01PZtydAP3+0EHT9/ovzFKtM4CTxOqopNo=;
        b=K8JAXuoDaSLZJhNj8jBnWjWXmkplrXoQNDKPkvPqSirQkJPOE7xsf20PW9pPBdcxN5
         2b3rL/cRo8EgeCDeHf6vtaDuniHimB6f09XC38J2oP5IdYHEASl/wgg7em0h0NlVYgZq
         MQVsftF0c7CHYJBqFhEs1IO+TzDYObSWeIaKFBTlWI0xA1ID4Zxl/w3BKfn5BEWTr+CU
         v00LEWwfHkzmApGIysVBfklsskQgrB5wB9xP/naPQG9g4VJVtmIAxPwcj9CCJrCFz+dE
         1xbqP5HJrwQ69cFMLr1KIBrrDEXRMvNBhVlk+enz+K4DlvtcExpOJF67M3XXHeKEBsoG
         Z6fA==
X-Gm-Message-State: AOAM5322X5Pl9K5cTBu8eVu/oz+yUbFP+5pq2vngbAfO8jC011UA19eO
        yMGTur6pHutvJUuQ1nip9oyoqHTLEuG7Mw==
X-Google-Smtp-Source: ABdhPJwh6exFnjxzxfjImvwwYdeFhG/KUqrwnYKnvqBxa4wxH/fbyWqIfWK/ivcZQfvxLjg8cRc5PB46PP8o3w==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:3b46:b0:1dc:b314:52e6 with SMTP
 id ot6-20020a17090b3b4600b001dcb31452e6mr6594921pjb.134.1652473725945; Fri,
 13 May 2022 13:28:45 -0700 (PDT)
Date:   Fri, 13 May 2022 20:28:07 +0000
In-Reply-To: <20220513202819.829591-1-dmatlack@google.com>
Message-Id: <20220513202819.829591-10-dmatlack@google.com>
Mime-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v5 09/21] KVM: x86/mmu: Pass memory caches to allocate SPs separately
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
index 16001b019e1a..44431c0b797f 100644
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

