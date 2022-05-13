Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D7B526B45
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 22:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384246AbiEMU2m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 16:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384214AbiEMU2i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 16:28:38 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5753A17E0E
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:28:37 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id s18-20020a17090aa11200b001d92f7609e8so4843426pjp.3
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wGHIzUdkImHbOgCE37BkR/+UNfqdKdFelxzR1hh/jTU=;
        b=AW85gt8Cm/akM6fN9YF1VI56V5qXCSMYonkm5FLUHZmqUsPnuhCTTXnBtgi9DFNwcn
         lj1Uwa/0VEsJQYRr9wQ3+UjaZWq8uJG7fLbKkyERC0L8JC2D3iot3WmxCKvtFjImh4xD
         xGivzkup6jQN70pJM4gSbe1QGqAurA9yISloGSd7fmpHI225Zi4f2zMdXPe5FBZz/2MU
         3vdJN+sPmDEcwZag+FclmZI/8GrsXPDO7sTuMsFGNuF/I5yRtjZDVCGP3adLsCmRIPHe
         gAEFJbvUCcNJ4pRE9G+UuIthYkITZL9tRzZHkxVAVDuMrnxwVze4xwuduMVNOWpNhKMx
         pSiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wGHIzUdkImHbOgCE37BkR/+UNfqdKdFelxzR1hh/jTU=;
        b=m6Dti0hGiamurkoAkyyUDlTI8bNHoEsCQvIf1TN6YrfhMZvk/zOCRF5J9aJHe+atPu
         oFWgPo8tzq8No8tCpUyy5C/G5inWHqi2fDAofgKOd8fIhRueYvPdd78rGxyWWb7PuN5H
         YX2yO5DtP9JM1T/V2+w9oGvA3CzGT6v86v6bMqRgFLSuWm0wWWu96hhFkRsnJpkhoAMc
         vkuk+FBLIxtt9HwaAjWn9lCvJW61IUZxXuRXJlqht2vJIELQPNWaAcIbyTb5oaWXw0qH
         O+wgrXHEbFe8PYBMQd9rCxMX+XqO4Gdjh5dtKnzSaUGEHpUmqruDTPc5xTZb+Yf2IFkR
         NPyw==
X-Gm-Message-State: AOAM531+jJzMYvFvYqun771d2HnlhWQ94BtQ7DiuCF8pmetMBhiQ6TFF
        AGz9nLW5YKrcK8eVgWvAEp823cmnzHLItw==
X-Google-Smtp-Source: ABdhPJwKUE0zCOcwZVsO97x6AhzKjnMvIvYyLucVAPqidHDvTm6P1AHwrq6LuBKpW9p7xKHAdpS8f31uCrjI/A==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:8d83:b0:1dd:258c:7c55 with SMTP
 id d3-20020a17090a8d8300b001dd258c7c55mr250781pjo.1.1652473715329; Fri, 13
 May 2022 13:28:35 -0700 (PDT)
Date:   Fri, 13 May 2022 20:28:02 +0000
In-Reply-To: <20220513202819.829591-1-dmatlack@google.com>
Message-Id: <20220513202819.829591-5-dmatlack@google.com>
Mime-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v5 04/21] KVM: x86/mmu: Always pass 0 for @quadrant when gptes
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
        autolearn=ham autolearn_force=no version=3.4.6
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
index a927a062a598..34786244ebad 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3409,9 +3409,10 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
 	role.level = level;
 	role.direct = direct;
 	role.access = ACC_ALL;
+	role.quadrant = quadrant;
 
-	if (role.has_4_byte_gpte)
-		role.quadrant = quadrant;
+	WARN_ON_ONCE(quadrant && !role.has_4_byte_gpte);
+	WARN_ON_ONCE(direct && role.has_4_byte_gpte);
 
 	if (level <= vcpu->arch.mmu->cpu_role.base.level)
 		role.passthrough = 0;
@@ -3450,7 +3451,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		for (i = 0; i < 4; ++i) {
 			WARN_ON_ONCE(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
 
-			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT), i,
+			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT), 0,
 					      PT32_ROOT_LEVEL, true);
 			mmu->pae_root[i] = root | PT_PRESENT_MASK |
 					   shadow_me_mask;
@@ -3535,6 +3536,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	u64 pdptrs[4], pm_mask;
 	gfn_t root_gfn, root_pgd;
+	unsigned int quadrant;
 	hpa_t root;
 	unsigned i;
 	int r;
@@ -3620,7 +3622,15 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 			root_gfn = pdptrs[i] >> PAGE_SHIFT;
 		}
 
-		root = mmu_alloc_root(vcpu, root_gfn, i, PT32_ROOT_LEVEL, false);
+		/*
+		 * If shadowing 32-bit non-PAE page tables, each PAE page
+		 * directory maps one quarter of the guest's non-PAE page
+		 * directory. Othwerise each PAE page direct shadows one guest
+		 * PAE page directory so that quadrant should be 0.
+		 */
+		quadrant = (mmu->cpu_role.base.level == PT32_ROOT_LEVEL) ? i : 0;
+
+		root = mmu_alloc_root(vcpu, root_gfn, quadrant, PT32_ROOT_LEVEL, false);
 		mmu->pae_root[i] = root | pm_mask;
 	}
 
-- 
2.36.0.550.gb090851708-goog

