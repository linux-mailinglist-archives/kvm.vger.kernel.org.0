Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C624529529
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 01:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350409AbiEPXWJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 19:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350325AbiEPXV4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 19:21:56 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0183C2FFD1
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:21:55 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 15-20020aa7920f000000b0050cf449957fso6798738pfo.9
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=va6jnjP+dVTFd61IW1SLfHEpANInDsPUK47j5zyNesg=;
        b=m6awzy0zf+d/TUzmk59URkI0NakeAaQoC0dqNJsXsPjGxxJtt/Sqdt7/K2AdHHEYLZ
         yYm81xVPlvVJ2J90+CnW/ELKKKlwsE3xnAGaispBdZcfy5bjkRM13XbzlTi0TCvwVMto
         P2Ca04/1dCr9DVYw3S7Rk5sW6i2kzAm8yhzyTCYYjbq2PzpfzRbSN7jepHlhAh/4c+c2
         G/AoduRoCiyhWPIQmYXlToMqmgvtS5znsJKLvNlYI3uo8qzenxkvw041K7UdW+7qB1OM
         cGKkfrAPC0utjsEhJIWOxEhgRG0+7QINlRxNaGWnhMBd2//U0SSAMwu/c6BsRMMg0Ci1
         FKeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=va6jnjP+dVTFd61IW1SLfHEpANInDsPUK47j5zyNesg=;
        b=Z/QgZfeg4EorMFxKOfg2XznYrBL+QbPhnVzGkEPW1rlbCUC5WdTyyWbaHRbIqv+860
         AqjUgyj4AC4H/jo8/5pi6c43iQeMoOkvbrRvue3DSGNjzVyr+lpIeknKahbsI/RthdFG
         VbGm0a2V+lY8hKxvVCkE90BsY9UzgpcmuJ4HQnsfjnGE3w6r+Zkjm/4aMBGC+cw1y/B+
         Sbaowihkm9H9qboj0XHsQSplFQvibOI3uO5XDd1N3TmfD+4X7N8XeX3GscIAfmvFhFXM
         wfxtxkA3lTtGWiWNzbsfV6pGSRXThXL7b5MSeZI2d1staX0hUgIhqBEFYD6EMsDCzFv/
         b7tA==
X-Gm-Message-State: AOAM531E6zbcpMDklAUODpiUmie+3+hzENGPjEicyUFdz7Hna7YgGTBZ
        2a1EiLJtv+DXz5naV31zmdnAzpfs/aikQQ==
X-Google-Smtp-Source: ABdhPJxVTNcRlZzKf8IiwYxUecqvC2n1d2hOZ23A/8uLFP7ir3PZoPX3x9WU00kz/JKXyDTTRH4+1G0nIF92pQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:3708:b0:1df:56ac:65c6 with SMTP
 id mg8-20020a17090b370800b001df56ac65c6mr7512962pjb.23.1652743314388; Mon, 16
 May 2022 16:21:54 -0700 (PDT)
Date:   Mon, 16 May 2022 23:21:24 +0000
In-Reply-To: <20220516232138.1783324-1-dmatlack@google.com>
Message-Id: <20220516232138.1783324-9-dmatlack@google.com>
Mime-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v6 08/22] KVM: x86/mmu: Rename shadow MMU functions that deal
 with shadow pages
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename 2 functions:

  kvm_mmu_get_page() -> kvm_mmu_get_shadow_page()
  kvm_mmu_free_page() -> kvm_mmu_free_shadow_page()

This change makes it clear that these functions deal with shadow pages
rather than struct pages. It also aligns these functions with the naming
scheme for kvm_mmu_find_shadow_page() and kvm_mmu_alloc_shadow_page().

Prefer "shadow_page" over the shorter "sp" since these are core
functions and the line lengths aren't terrible.

No functional change intended.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0b14097f8771..d342fcc5813d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1652,7 +1652,7 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
 }
 
-static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
+static void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp)
 {
 	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
 	hlist_del(&sp->hash_link);
@@ -2107,8 +2107,9 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
-static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
-					     union kvm_mmu_page_role role)
+static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
+						    gfn_t gfn,
+						    union kvm_mmu_page_role role)
 {
 	struct hlist_head *sp_list;
 	struct kvm_mmu_page *sp;
@@ -2172,7 +2173,7 @@ static struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu,
 	union kvm_mmu_page_role role;
 
 	role = kvm_mmu_child_role(sptep, direct, access);
-	return kvm_mmu_get_page(vcpu, gfn, role);
+	return kvm_mmu_get_shadow_page(vcpu, gfn, role);
 }
 
 static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterator,
@@ -2448,7 +2449,7 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 
 	list_for_each_entry_safe(sp, nsp, invalid_list, link) {
 		WARN_ON(!sp->role.invalid || sp->root_count);
-		kvm_mmu_free_page(sp);
+		kvm_mmu_free_shadow_page(sp);
 	}
 }
 
@@ -3432,7 +3433,7 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
 	WARN_ON_ONCE(quadrant && !role.has_4_byte_gpte);
 	WARN_ON_ONCE(role.direct && role.has_4_byte_gpte);
 
-	sp = kvm_mmu_get_page(vcpu, gfn, role);
+	sp = kvm_mmu_get_shadow_page(vcpu, gfn, role);
 	++sp->root_count;
 
 	return __pa(sp->spt);
-- 
2.36.0.550.gb090851708-goog

