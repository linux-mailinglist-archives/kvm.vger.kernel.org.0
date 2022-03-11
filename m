Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD2F04D568F
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 01:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240061AbiCKA0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 19:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345170AbiCKA0r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 19:26:47 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4911A2701
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 16:25:45 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id y3-20020a1709029b8300b0014c8bcb70a1so3567657plp.3
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 16:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hUhTNfsRlcAhlCAEwuaf6qTSRETsPLu85xICgb6Pw2I=;
        b=Ux2f+mr/mK9ysuQSi/sBCmxVVqyTzZtZcuO+SYe9GBnc8TQpBaRNkuO26UcTq9+K7m
         9XCEug+JYAx7QgnxtFzMKpDzCZ2Kl3NLGHYaMWkmd4Ic4q6ryxK1fh3eirtILH29GWRl
         y4ndBbNMnsnmerSi8z/TQIBMaNCb13Zxm6I81Hm3D5/Iw1XB83q9r0puc/5thPme9yUe
         5CQHUvdH3HOyCN2dpgX6tbRevneUEVUCc5bYxwqg6D0Njsn05gMV/tq0tNKd8PUtrCZL
         TKX0vUgoYTO6j6iEsFtBVDflNzJ0qcKCJCSdpf3D5PzBxpdR1jblF6G0g4UsVDlY5RTe
         t19g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hUhTNfsRlcAhlCAEwuaf6qTSRETsPLu85xICgb6Pw2I=;
        b=D9j/d4qZ8UAY5eQSbrnx5yqFnl5yW7P7d2Wbws1IVidorGfH25FmjHpm9FfzLeY4sm
         A48wY8uIbvgF1TNy0EW+DsUqlLTN8yKCZepixc2gLx3saXYbCw8VzbgPqGaP3XV/N5PJ
         4QJ2SMZefk9HpApNaiJQl+B4asu3QWUFLLjCvkWcxHCT4DJOfwxNw3fpNARugx8D14DB
         Rk0O5mIkVleu9WZU/Z50lMwkz6g8ypVuPCbvo/RKgyxlxTjF3tiUqVRrd9O5Th18kUif
         GqOLBzSWUe52EfWpfTFAECet6osPsH4h07SqhOwN+i44OG5HHhZ6g4XhHJ3dRyKKTYMb
         z23w==
X-Gm-Message-State: AOAM5318nD0/Q1pl8WQK1LLpru66qv8UIXtd6IPqDyQ457cDqy3vJPi8
        vpBmgckAoJbtfVC4aM+lPYYODqD2EJkZrQ==
X-Google-Smtp-Source: ABdhPJyVkv6e6MFwOzwVPNnjhMEMTwjec6c9yLeYXj0Dnt6k4PAJzbfaJIjMW+/lDxdSlSq9DXN35GK1V5t4+g==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a63:9d8c:0:b0:378:4b73:5b3b with SMTP id
 i134-20020a639d8c000000b003784b735b3bmr6119017pgd.564.1646958344889; Thu, 10
 Mar 2022 16:25:44 -0800 (PST)
Date:   Fri, 11 Mar 2022 00:25:10 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-9-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 08/26] KVM: x86/mmu: Link spt to sp during allocation
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Link the shadow page table to the sp (via set_page_private()) during
allocation rather than initialization. This is a more logical place to
do it because allocation time is also where we do the reverse link
(setting sp->spt).

This creates one extra call to set_page_private(), but having multiple
calls to set_page_private() is unavoidable anyway. We either do
set_page_private() during allocation, which requires 1 per allocation
function, or we do it during initialization, which requires 1 per
initialization function.

No functional change intended.

Suggested-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index af60922906ef..eecb0215e636 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -274,6 +274,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 
 	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
 	return sp;
 }
@@ -281,8 +282,6 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
 			    gfn_t gfn, union kvm_mmu_page_role role)
 {
-	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
-
 	sp->role = role;
 	sp->gfn = gfn;
 	sp->ptep = sptep;
@@ -1410,6 +1409,8 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
 		return NULL;
 	}
 
+	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
+
 	return sp;
 }
 
-- 
2.35.1.723.g4982287a31-goog

