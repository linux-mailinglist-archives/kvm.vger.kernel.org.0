Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C563B4EB0C0
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 17:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238814AbiC2PhO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 11:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238809AbiC2PhN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 11:37:13 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB73824F2A1;
        Tue, 29 Mar 2022 08:35:29 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id t2so16203269pfj.10;
        Tue, 29 Mar 2022 08:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZaW1ShDM/2OnGyJMP0bodXnVQNIFn7WzT1GlIkRksjI=;
        b=aaN6MeHg94Te4I7Cta6tWpMAP48QzzbdXtyKtQcmJhXBSppoWEBehBQxN3CiutZyKk
         25MgVQg7jcZIGeWDsuiou57WsZGo8lRLVLLkRyrCHHuvcuCiepsoEYwuDNRQ8oXhJJTP
         LcvswQ1ojfMcbVzgX939FhqAfnXo3D92dJWvyOtypFfUET7zNMKep2y1NsHeZhoJLCag
         E9OG7aQJSwXBM3d0JAU7BRIjcVYCOMR6Gfp9ipt2Gq/YfJIG/y1Piyn93joxp+f0vnm/
         6H+mih7UgzIL2lbVci6bgxGto6K61ZF2QU0BdeTMnwQlycKznLX+NZr0zdABGXe0IaP8
         auvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZaW1ShDM/2OnGyJMP0bodXnVQNIFn7WzT1GlIkRksjI=;
        b=vz1qzv/RATkdG2I9ViIUz/uoBv2MjEVWG/saqym+Nn/JOvSoGvTsPCw8h0gmSPPNYU
         oiulyr817ybQN1KNIyGm7YA+XFkS3oxnujUOHTaGwmmdtryhHdLR4jOsgWOgb4FKmEax
         WB7HcpWCbB20J69Z2aMqA2B4sW/Dfm83D920x0H3Tg2SA4U2FWwp2LobDRWFEdki5oga
         4oAT8l4FZ0stGxiPmhH1mziOxGeueTPv1200EopYXHyYh1bne4rWJepLC0EA6MrweSsy
         0NmFRHd3DxarXWVpPNUKnkmY0phZz3WK9ZPrWr0ofs6ztoKZ7+QimSih3YDtdhqxTJeM
         1f0g==
X-Gm-Message-State: AOAM533iv7zoGuHl9pl4YT9oewjGaONZ5pGF+O15wxV0ljtpHMg7vTmv
        mHxrOt1ajHV1LtLVjOyUU9bVi6D/h6o=
X-Google-Smtp-Source: ABdhPJzMZGcLUB+u0PAc7F/aUR6QHUYJvodEUQrvUOixwzoxts5ogPz/PzbJAPFg4ZixNSganJluWw==
X-Received: by 2002:a63:7b4a:0:b0:398:1337:e304 with SMTP id k10-20020a637b4a000000b003981337e304mr2407519pgn.371.1648568129045;
        Tue, 29 Mar 2022 08:35:29 -0700 (PDT)
Received: from localhost ([47.251.3.230])
        by smtp.gmail.com with ESMTPSA id s4-20020a056a00194400b004fb358ffe84sm12474241pfk.104.2022.03.29.08.35.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Mar 2022 08:35:28 -0700 (PDT)
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
Subject: [RFC PATCH V2 1/4] KVM: X86: Add arguement gfn and role to kvm_mmu_alloc_page()
Date:   Tue, 29 Mar 2022 23:36:01 +0800
Message-Id: <20220329153604.507475-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220329153604.507475-1-jiangshanlai@gmail.com>
References: <20220329153604.507475-1-jiangshanlai@gmail.com>
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

kvm_mmu_alloc_page() will access to more bits of the role.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a7cb877f3784..8449ae089593 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1706,13 +1706,14 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
+static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, gfn_t gfn,
+					       union kvm_mmu_page_role role)
 {
 	struct kvm_mmu_page *sp;
 
 	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
-	if (!direct)
+	if (!role.direct)
 		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
@@ -1724,6 +1725,8 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
 	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
 	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
+	sp->gfn = gfn;
+	sp->role = role;
 	return sp;
 }
 
@@ -2107,10 +2110,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 
 	++vcpu->kvm->stat.mmu_cache_miss;
 
-	sp = kvm_mmu_alloc_page(vcpu, direct);
-
-	sp->gfn = gfn;
-	sp->role = role;
+	sp = kvm_mmu_alloc_page(vcpu, gfn, role);
 	hlist_add_head(&sp->hash_link, sp_list);
 	if (!direct) {
 		account_shadowed(vcpu->kvm, sp);
-- 
2.19.1.6.gb485710b

