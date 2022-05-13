Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04E67526B5F
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 22:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384393AbiEMU3Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 16:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384323AbiEMU3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 16:29:13 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561E313D79
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:28:57 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id j187-20020a638bc4000000b003c1922b0f1bso4671893pge.3
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=R2k5lQSqINgMzSg3h1Jv/V+x4VA+8gcfFTJByzEmdDA=;
        b=EU3henCftOq2Phx82RY7J6BqUQU+5NnYx5FkdAcZ0AjTnM/NEfcaeb8QdDyAd2mn87
         Ofot1wIIOg7d/ZxD2XEKWbYLKnHccAJ2tqSzLFxbb/YOleCCNYnl4lxWlgAbnQukzWPu
         72LMPoClWYE+XWiNBre8Goc/f9udtUpYva7+hvc7GU2wnamgH0z+Eqw9vLj0LpGEb6KM
         70CPZdMsZAUBI5mjCNpQRCQ8n7Xr9qtR6WPrqaCm5k9pIE4OhYSORd4IigD2RIyJ1bp4
         oYhPb2mL8IIoTjyJ0FnJcfLzLVFuR31s36OqUpDHmT3XZkVUVX6kdG+1wHL0K+KFgtsG
         BGww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=R2k5lQSqINgMzSg3h1Jv/V+x4VA+8gcfFTJByzEmdDA=;
        b=vtmNLYeRllfnfXXQ2yfA05pc2hZULyp2Sp7WQ4uTOoQFYHFkOf+HoBIoKZekNYszeW
         KEH+Lf4FIXzr5FLhI9/GXE5U2TqwJXBWy5aodiZgSHmB1duqNMpFIrXIbsQNIXs1utnc
         vqaK/OyTBo9oi1kAdWg5JYk0uol0L0ZjyTgrHfjB2qQnaC4oloIMB8h0plLaXbwT3r/a
         h/m/jY6dkKz2l1rwEJ7w/kaJA5RZwJfhibyDF8cUgZ493vTZWzYTzIFgZjxsHA/Eiekk
         rWTY3d3+lSGitFnoeir+qft4qwMWBW2gA/k+u2iHhxSb52Vcz3rJtcI78hUnB06K0utJ
         PBqg==
X-Gm-Message-State: AOAM531Jzi9v39ITjAsf8ySEZrVaRtj33IRRADpsZD/gg6aHc2k2ak53
        YjOsUWoUQikwfWRXTzG5meiCvzP2zZVhfg==
X-Google-Smtp-Source: ABdhPJxY2BhZKf4uGbUq4BeYViiLb0nNkU/Ef26vfAz8aiDUZBG4gjV5YebQ/CaStCtCadWMLVYtA+Ydny+dSA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:174a:b0:4fd:ac35:6731 with SMTP
 id j10-20020a056a00174a00b004fdac356731mr5985955pfc.71.1652473737018; Fri, 13
 May 2022 13:28:57 -0700 (PDT)
Date:   Fri, 13 May 2022 20:28:13 +0000
In-Reply-To: <20220513202819.829591-1-dmatlack@google.com>
Message-Id: <20220513202819.829591-16-dmatlack@google.com>
Mime-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v5 15/21] KVM: x86/mmu: Update page stats in __rmap_add()
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

Update the page stats in __rmap_add() rather than at the call site. This
will avoid having to manually update page stats when splitting huge
pages in a subsequent commit.

No functional change intended.

Reviewed-by: Ben Gardon <bgardon@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0a14320fb148..c7cc552440f7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1588,6 +1588,8 @@ static void __rmap_add(struct kvm *kvm,
 
 	sp = sptep_to_sp(spte);
 	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
+	kvm_update_page_stats(kvm, sp->role.level, 1);
+
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
 	rmap_count = pte_list_add(cache, spte, rmap_head);
 
@@ -2810,7 +2812,6 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 
 	if (!was_rmapped) {
 		WARN_ON_ONCE(ret == RET_PF_SPURIOUS);
-		kvm_update_page_stats(vcpu->kvm, level, 1);
 		rmap_add(vcpu, slot, sptep, gfn);
 	}
 
-- 
2.36.0.550.gb090851708-goog

