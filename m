Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1D60529531
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 01:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350472AbiEPXWW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 19:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350406AbiEPXWJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 19:22:09 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D67647388
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:22:05 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id z16-20020a17090a015000b001dbc8da29a1so370811pje.7
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rGzh5GvsV5L2zEqZPzXFz37QyRFi+koDaicRtP2dkmU=;
        b=OPhWIYxaFR2dtemS1rpu36wC5OAd8tOZ8Uy2j4Sg+WmZABVjAcyDohNhu+23Yq9S3i
         lo9dvAU0C2WlPy4wPB/0ufQBWEYovz7uf/zJMgR9WCwBx1KAg2LfO9cHzZRiv3nMmsWp
         rK6uGwu6ZWNC5ACoMjwmE/Djab2jF+ubLqAbGpWr2k6vL2WscKZdZXJ2wR+5v497WQPy
         P8IuV7t04tfEA9/qnPS8z0vRzSxQiXp4Gv3P0w+YCkXoi69Ani0G3bbldBY1bAY33Plj
         0Dtf7YNPhcD3HSt+A297W/OcRbYZVZQn4hgkC5h0dLMFuNzmU0xrtmyPuQEf5QUZhAdP
         yfUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rGzh5GvsV5L2zEqZPzXFz37QyRFi+koDaicRtP2dkmU=;
        b=cMRS/W+zbaZ7WHDwlOPS0soN5eFyAJdIpjilf7b9st3Dvp4XqRGNJu9pZzv3V9HeAK
         6vw7oTaMELZVNOXsGTRZEFo20nmKTP/EeMHZrimcUlDjl6JQ+0UmI9zIlxRg+9LfiUwE
         NO2Cy2r5rF66WM/JBt8mpL2q0oZQdFpYUSrYpkjx50h2+rbfdNWaMJ+qdTgsfTDBltRM
         YYoBt9HXBl+w3A4oPh686A4cuGwRcnOx1VtCcLsWQJs59cBYyYR5LQbR3ipqtyibOJoI
         WvtiKRIfXA6U0aH4ewNqq1J5wqb01Q/n7ZsEW4KptXo15gV672Ij34Jf8Kr/7azDivfW
         s/lw==
X-Gm-Message-State: AOAM532mxEKzebivnSh7qsCgIxn+brFKD59eQYJM+gwBPYfmtrcgY1kf
        e2DvaCU1OUZxshVMJtFNPgaM+A32GLl1VQ==
X-Google-Smtp-Source: ABdhPJzOidTi35Ysu50FwznFojTNwKrHJzIVcpYJbrQfhWJlsKRUbKWh5n19ouRkc2VuKRGIDM46saF5Yjcz2A==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:2a8a:b0:1df:26ba:6333 with SMTP
 id j10-20020a17090a2a8a00b001df26ba6333mr4145pjd.0.1652743324001; Mon, 16 May
 2022 16:22:04 -0700 (PDT)
Date:   Mon, 16 May 2022 23:21:30 +0000
In-Reply-To: <20220516232138.1783324-1-dmatlack@google.com>
Message-Id: <20220516232138.1783324-15-dmatlack@google.com>
Mime-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v6 14/22] KVM: x86/mmu: Pass const memslot to rmap_add()
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

rmap_add() only uses the slot to call gfn_to_rmap() which takes a const
memslot.

No functional change intended.

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index acb54d6e0ea5..1c0c1f82067d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1582,7 +1582,7 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 #define RMAP_RECYCLE_THRESHOLD 1000
 
-static void rmap_add(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
+static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
 		     u64 *spte, gfn_t gfn)
 {
 	struct kvm_mmu_page *sp;
-- 
2.36.0.550.gb090851708-goog

