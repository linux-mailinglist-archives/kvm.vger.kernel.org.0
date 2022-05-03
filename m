Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444CA5187F6
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 17:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237884AbiECPLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 11:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237858AbiECPK4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 11:10:56 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B1B3A5F6;
        Tue,  3 May 2022 08:07:18 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id l11-20020a17090a49cb00b001d923a9ca99so2251052pjm.1;
        Tue, 03 May 2022 08:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iUSTq+s1gQDs5H6ehxJIoCO5vQZkO8iY3BJ1TJmophE=;
        b=E/4LdQqt6Ro1YVXQRP4mVH7mCiLGBws2dx4U5On3L9ZsZjeH9hUWVf0l8MOLZBwxJo
         VvblK36P2dYeKH0EMepyVr+3EMuCAcOZTuLBIvJT/1KtVBSKIw1JMWCa2wN6plkFDrLy
         wO4qb0xZdX8COICxEnLojiXFm5XiDHt9MBxS4udOarW/Ve6fPz/el5W68fsR86rM6jYL
         L91D6SqQSI+JmOb9zlzk7RTYVfT6rmX1evcOnR4apBgrXMWe5HCXRZavOkS5dlwXF3we
         QZVd84W+kdpwAAEd3kTSJiOflUUZmlLrk+bqc5gSHy5PTR0o8BV/Y5dGPTRRPEqcT0Kt
         QVKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iUSTq+s1gQDs5H6ehxJIoCO5vQZkO8iY3BJ1TJmophE=;
        b=YSQWC8Il9s5lhC0GmiO1pTErHJzbbcHBtbYrBX4vi6ERWutYUtuNfZYtamX4b0IrdN
         hJl4CBLKl97Ypk/SdopO70H0ahtgzz0S7NPxXzVkfM6WQwhZHEQliCWtjuEKbBjTieKq
         IBVtU5yb3aFOKwVzCM61v05IFgeN1b9LxadcMeDlkeF+rCiNgO7+LU1g/9wKbBNyVwVb
         V6j8erbjuQJO0nLZMiKJ5sGvdnQ35gHxVVjtSFnd4fc6p3pl/kcpI0c5Fj69/3zxiYGW
         SuKNa2OmWZAhFho8D+8KkriqXl2rrsEKK9WU7hz9k+a2fG+aJXp7+MGJElEWMaXxAjwl
         Nxcg==
X-Gm-Message-State: AOAM532cSH/ItjmGFuCu65OBnsqabbpzcLL16zkQ5BeA1nUGSdY4oHBG
        E9L4Vec7I5hQeB6skqOW+P7uZoHYpy8=
X-Google-Smtp-Source: ABdhPJwC1iU2IJgPDM+k8K91Pb0syPaC6446uFe1sPO/hX7T69Q6EKcOyW+ypDl/VfRAQRiugpNaBQ==
X-Received: by 2002:a17:903:1212:b0:15e:7d94:e21d with SMTP id l18-20020a170903121200b0015e7d94e21dmr16705851plh.92.1651590437441;
        Tue, 03 May 2022 08:07:17 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id q9-20020a170902c9c900b0015e8d4eb2e0sm6432528pld.298.2022.05.03.08.07.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 May 2022 08:07:17 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH V2 3/7] KVM: X86/MMU: Link PAE root pagetable with its children
Date:   Tue,  3 May 2022 23:07:31 +0800
Message-Id: <20220503150735.32723-4-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220503150735.32723-1-jiangshanlai@gmail.com>
References: <20220503150735.32723-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

When special shadow pages are activated, link_shadow_page() might link
a special shadow pages which is the PAE root for PAE paging with its
children.

Add make_pae_pdpte() to handle it.

The code is not activated since special shadow pages are not activated
yet.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c  | 6 +++++-
 arch/x86/kvm/mmu/spte.c | 7 +++++++
 arch/x86/kvm/mmu/spte.h | 1 +
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 126f0cd07f98..3fe70ad3bda2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2277,7 +2277,11 @@ static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	BUILD_BUG_ON(VMX_EPT_WRITABLE_MASK != PT_WRITABLE_MASK);
 
-	spte = make_nonleaf_spte(sp->spt, sp_ad_disabled(sp));
+	if (unlikely(sp->role.level == PT32_ROOT_LEVEL &&
+		     vcpu->arch.mmu->root_role.level == PT32E_ROOT_LEVEL))
+		spte = make_pae_pdpte(sp->spt);
+	else
+		spte = make_nonleaf_spte(sp->spt, sp_ad_disabled(sp));
 
 	mmu_spte_set(sptep, spte);
 
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 75c9e87d446a..ccd9267a58ca 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -251,6 +251,13 @@ u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
 	return child_spte;
 }
 
+u64 make_pae_pdpte(u64 *child_pt)
+{
+	/* The only ignore bits in PDPTE are 11:9. */
+	BUILD_BUG_ON(!(GENMASK(11,9) & SPTE_MMU_PRESENT_MASK));
+	return __pa(child_pt) | PT_PRESENT_MASK | SPTE_MMU_PRESENT_MASK |
+		shadow_me_value;
+}
 
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled)
 {
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index fbbab180395e..09a7e4ba017a 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -413,6 +413,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       u64 old_spte, bool prefetch, bool can_unsync,
 	       bool host_writable, u64 *new_spte);
 u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index);
+u64 make_pae_pdpte(u64 *child_pt);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
-- 
2.19.1.6.gb485710b

