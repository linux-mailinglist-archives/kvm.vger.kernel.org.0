Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBCC4EF952
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 19:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350697AbiDAR6S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 13:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350712AbiDAR6P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 13:58:15 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69121AF501
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 10:56:25 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id t66-20020a625f45000000b004fabd8f5cc1so1999646pfb.11
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 10:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=M8diawJ0a5+6KeqCTlFavoigvh5ZH93bmgpmzfeJdKU=;
        b=RKIqIHqTnVlf04If3sQSSAHbqv3QjMDqucAB4bBcWHE84GJh7XwJyqak7+P6HFLJ6n
         +L1EoCVaxTwBwzeLwEZ0Mnk42VtiBqYSiLFEinADKf1v/Yjbv09HeUnW2aHu/sANey8q
         cjo663yO9FAQ7xYig94gQ5SsFEJK87TpzlrwfQpq1FmDouuBdRw3HLf/GzCksxq6h6Qd
         dHPc1eGJ/weS0TRiejDzlpOCxn9sAZnBRZi0jKPd4b8sUEQnMpL4KP+7rN83HYMRmSNw
         x95OtGAk1v69jDYVtvnNR9Y1eLvJJQfdxffJ5OeETA4K9WvDstqnYfAG9CmLiSo2fVV2
         anFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=M8diawJ0a5+6KeqCTlFavoigvh5ZH93bmgpmzfeJdKU=;
        b=34sHCez34r9znyt0bjDclQezw2sW5FCAd6Fzw3E1tAs0cV3W2OaTx/vjWZkkKHm33S
         7A8sFBn6ce/1j2F8JMNNnMHJAbyxHI7FwYkbnXb1rDRCnjp7r2TaLHOWC/VkFZuo3pYE
         aDRZJmo02hecXx02UGwe0DHSIdNkcFLyFmFeL5l5VUK+/88RmFYvdwjfQuoXdSHX6zsS
         +1AfKYB8aGpd6g4K2EIvdCT8v9jVCB+tFaz5rDSvM7q6UDmWqwh8rqT6bawnc88oVHMp
         s7bLwzqUn8Va8NuO3xw6s2rLtRiLnweTDy83e0BkMmy4awyLh7xV/l9zJToeb5QjmHAF
         p2Bg==
X-Gm-Message-State: AOAM533P1ab/5sbskmcEfksiQPHn2aauMvVCzhJCVnblRBpOcM0xIs0n
        HmFgGGcpr9Nl14AmO0UWXM+QWcAcQMCS0w==
X-Google-Smtp-Source: ABdhPJzPFkqyWE5YerNB8OHSTmxQmbipoI1rO0qgKI7jWDlomyQ1zN1wSQvVwslRKXespEzPjv+VbOwMvNn3Mg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:ec8c:b0:154:7cee:774e with SMTP
 id x12-20020a170902ec8c00b001547cee774emr11782718plg.61.1648835785152; Fri,
 01 Apr 2022 10:56:25 -0700 (PDT)
Date:   Fri,  1 Apr 2022 17:55:46 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-16-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 15/23] KVM: x86/mmu: Update page stats in __rmap_add()
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
index 7305a8c625c0..5e1002d57689 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1602,6 +1602,8 @@ static void __rmap_add(struct kvm *kvm,
 
 	sp = sptep_to_sp(spte);
 	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
+	kvm_update_page_stats(kvm, sp->role.level, 1);
+
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
 	rmap_count = pte_list_add(cache, spte, rmap_head);
 
@@ -2839,7 +2841,6 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 
 	if (!was_rmapped) {
 		WARN_ON_ONCE(ret == RET_PF_SPURIOUS);
-		kvm_update_page_stats(vcpu->kvm, level, 1);
 		rmap_add(vcpu, slot, sptep, gfn);
 	}
 
-- 
2.35.1.1094.g7c7d902a7c-goog

