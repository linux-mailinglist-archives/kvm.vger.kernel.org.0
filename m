Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD05C529520
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 01:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350332AbiEPXV5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 19:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344310AbiEPXVw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 19:21:52 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0676427F9
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:21:50 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id u1-20020a17090a2b8100b001d9325a862fso8820155pjd.6
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zRMoSkvlQMP0J3ZIrEKBPQbye/eobLBhFHUHq0UrotA=;
        b=i4b8Sslhrx4Dwm3WSL32Kj53fMSbDzAQvsPQPAktc+O5vIsHbyIEY27MK7N6q7UBN3
         mz4EBbel/cl83mS7bOt2BVROPvsrBHTIYINgpbiPLpvhdPYB5E7jlHgR46KRIhjSxSDV
         GK4sTqMGhwWliylW0By2yW6CNjL4QKa8QHIBtqOuYcAF5+CXL2+rTW5pk16pM9TSOlVk
         FFygOSZ122EqPc1ySnPkEiL185tl1JSLSBPplBYXXzNdmYSjAVQ0RKdzONodYoyC4ZC+
         zJ0g4GncB0koOyAjBByr0BTyp4yRdGijrNYa4GoDtUxtyMwLyyDlbE41kDKfdLCAHsrD
         tqsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zRMoSkvlQMP0J3ZIrEKBPQbye/eobLBhFHUHq0UrotA=;
        b=B66pJ19z14ybTsVXURFkkm+B5cOajYxwBDEXuHtyh6iO36CVOtS49C7Vh4jUDV9qdm
         LzSqMdMFx409ipRu7FweJMx2gDOKciV11aO5Qm1bUvd/gDKov3ecQSmxqXEEdng+vJBW
         M8luw8Dxe5AZhdppugEfl14xrV/VJSs0Kx3z1b4+29HGRbnNUtGWLXs81QbdWXHg6rQ0
         7yX/wd/zYXUh7PoB44RTu9hZmixzECr/jcRxDBz36u2Nx8mApDcXt0sWERQ+4ZmjbyDv
         x2NhIuV05g2iputXW3hglhT2fAHZixW02HqIvkQ5dq6pVhTbW3HR52wj1JJyOxxyknf5
         g7Yg==
X-Gm-Message-State: AOAM531kKJZHTzW4koYi3E/OFJVFozwscUdThAJBFqkSeUdxLBJoPAmL
        6vOOi+n+TmRtGCqRFSlVtUd/NzgRI6Dfpg==
X-Google-Smtp-Source: ABdhPJwy2kPS7xTJ6DpUF909sFIWOnposTjd2jt6sbppESZNKwX/KGB2h4UmBZiOf2Df48+ykx72Muh7GNZbZA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:8d83:b0:1dd:258c:7c55 with SMTP
 id d3-20020a17090a8d8300b001dd258c7c55mr4003pjo.1.1652743309580; Mon, 16 May
 2022 16:21:49 -0700 (PDT)
Date:   Mon, 16 May 2022 23:21:21 +0000
In-Reply-To: <20220516232138.1783324-1-dmatlack@google.com>
Message-Id: <20220516232138.1783324-6-dmatlack@google.com>
Mime-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v6 05/22] KVM: x86/mmu: Always pass 0 for @quadrant when gptes
 are 8 bytes
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

The quadrant is only used when gptes are 4 bytes, but
mmu_alloc_{direct,shadow}_roots() pass in a non-zero quadrant for PAE
page directories regardless. Make this less confusing by only passing in
a non-zero quadrant when it is actually necessary.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 515e0b33144a..8508c4bfddb5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3406,9 +3406,10 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
 	struct kvm_mmu_page *sp;
 
 	role.level = level;
+	role.quadrant = quadrant;
 
-	if (role.has_4_byte_gpte)
-		role.quadrant = quadrant;
+	WARN_ON_ONCE(quadrant && !role.has_4_byte_gpte);
+	WARN_ON_ONCE(role.direct && role.has_4_byte_gpte);
 
 	sp = kvm_mmu_get_page(vcpu, gfn, role);
 	++sp->root_count;
@@ -3444,7 +3445,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		for (i = 0; i < 4; ++i) {
 			WARN_ON_ONCE(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
 
-			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT), i,
+			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT), 0,
 					      PT32_ROOT_LEVEL);
 			mmu->pae_root[i] = root | PT_PRESENT_MASK |
 					   shadow_me_mask;
@@ -3529,6 +3530,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	u64 pdptrs[4], pm_mask;
 	gfn_t root_gfn, root_pgd;
+	unsigned int quadrant;
 	hpa_t root;
 	unsigned i;
 	int r;
@@ -3614,7 +3616,15 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 			root_gfn = pdptrs[i] >> PAGE_SHIFT;
 		}
 
-		root = mmu_alloc_root(vcpu, root_gfn, i, PT32_ROOT_LEVEL);
+		/*
+		 * If shadowing 32-bit non-PAE page tables, each PAE page
+		 * directory maps one quarter of the guest's non-PAE page
+		 * directory. Othwerise each PAE page direct shadows one guest
+		 * PAE page directory so that quadrant should be 0.
+		 */
+		quadrant = (mmu->cpu_role.base.level == PT32_ROOT_LEVEL) ? i : 0;
+
+		root = mmu_alloc_root(vcpu, root_gfn, quadrant, PT32_ROOT_LEVEL);
 		mmu->pae_root[i] = root | pm_mask;
 	}
 
-- 
2.36.0.550.gb090851708-goog

