Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0143D52FCC8
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 15:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355199AbiEUNQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 09:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355069AbiEUNQd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 09:16:33 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7A92F389;
        Sat, 21 May 2022 06:16:23 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id c14so9895582pfn.2;
        Sat, 21 May 2022 06:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8ROpEEdq4nhDPA6XwmM5rgE6fsdyhfYYyZpEn0MjbA0=;
        b=WXJMcvF8UyenHRio4TyF0ZVna5wzsZMKyZeKkf5TsZiN/7a1KmGZLofwZhbOeM2fNz
         wDH1nspnL1M4pIoZ8RWSbailZpSqNxW4RTyVP4eS32loFVPTKkSgR07AyYNdjbxFWwc9
         JJBGfOry3leV5BP++RMrTwrFSE0qp0B4uYCm1yFqC9WsPWTT2J5PCUrEoXqHDLoGxl38
         417Yub0Kuf/QpnEKg6+2gYBkwdPx7GzgxPdtTenVifKVqVCpHkXmnNg7uDoi3pLYMUx/
         jRMGONc1UVyVu0b2I0zGo2RXRaOeeEgdA58MHBqth0oF2DxJytWXme6uIbtD3r4bSCzd
         wjVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8ROpEEdq4nhDPA6XwmM5rgE6fsdyhfYYyZpEn0MjbA0=;
        b=fuVgE+QVxHxTgUdWn2k1wW22U5jrUd0NbR50dRpgiktAcSOsSLr6hXC9bWmWeQCfq/
         7zhlesp6RXEgC5q7QdIYeH1sF/MXBpH0fwU9CdXu1HQEBQUcBq9fYQw2OB2jm7mhmWxp
         hpupgeHjU9rjD5ZlJXNX4jPMVRP27lJYImP9Rkb4Wee7E/wLmoM5781ErhL1Jd5DT3DS
         pXCf8tN3TInxI7JhQ3MIQn7cIBVDp0DLzYlIn0mqBL1o49ScUl66UVueZZD6v1dTymh1
         9DEWRwyKxCPXJF4gLY2o++sthCqUBU2gpWa1lgdlj0VNxf5lp89inWIxY6mzuqNa9uXt
         ZMug==
X-Gm-Message-State: AOAM531cvdmh1Q849hpeBHM0x/uShYa/wQNs0siLoD45YmfoaUpCnryy
        RilqaaZfqZ/3oSNGCSplyCinpjY83AM=
X-Google-Smtp-Source: ABdhPJxsGi1W5zHRaktBq+gMKlpquJATrPPVKNLUyuxBANt7P539OMcrGL1S7UGdibbl60YB/bP5rQ==
X-Received: by 2002:a63:e513:0:b0:3ab:a3fb:f100 with SMTP id r19-20020a63e513000000b003aba3fbf100mr12487336pgh.70.1653138983340;
        Sat, 21 May 2022 06:16:23 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id v11-20020a170902d68b00b0015e8d4eb284sm1552865ply.206.2022.05.21.06.16.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 May 2022 06:16:23 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH V3 05/12] KVM: X86/MMU: Link PAE root pagetable with its children
Date:   Sat, 21 May 2022 21:16:53 +0800
Message-Id: <20220521131700.3661-6-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220521131700.3661-1-jiangshanlai@gmail.com>
References: <20220521131700.3661-1-jiangshanlai@gmail.com>
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

When local shadow pages are activated, link_shadow_page() might link
a local shadow pages which is the PAE root for PAE paging with its
children.

Add make_pae_pdpte() to handle it.

The code is not activated since local shadow pages are not activated
yet.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c  | 6 +++++-
 arch/x86/kvm/mmu/spte.c | 7 +++++++
 arch/x86/kvm/mmu/spte.h | 1 +
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c941a5931bc3..e1a059dd9621 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2340,7 +2340,11 @@ static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	BUILD_BUG_ON(VMX_EPT_WRITABLE_MASK != PT_WRITABLE_MASK);
 
-	spte = make_nonleaf_spte(sp->spt, sp_ad_disabled(sp));
+	if (unlikely(sp->role.level == PT32_ROOT_LEVEL &&
+		     vcpu->arch.mmu->root_role.level == PT32E_ROOT_LEVEL))
+		spte = make_pae_pdpte(sp->spt);
+	else
+		spte = make_nonleaf_spte(sp->spt, sp_ad_disabled(sp));
 
 	mmu_spte_set(sptep, spte);
 
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index b5960bbde7f7..5c31fa1d2b61 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -279,6 +279,13 @@ u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
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
index 0127bb6e3c7d..2408ba1361d5 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -426,6 +426,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       u64 old_spte, bool prefetch, bool can_unsync,
 	       bool host_writable, u64 *new_spte);
 u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index);
+u64 make_pae_pdpte(u64 *child_pt);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
-- 
2.19.1.6.gb485710b

