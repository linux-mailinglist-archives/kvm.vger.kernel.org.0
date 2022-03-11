Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87BF64D5685
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 01:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345181AbiCKA0z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 19:26:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242902AbiCKA0w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 19:26:52 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6AD1A1C7A
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 16:25:50 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id b4-20020a170902a9c400b001532ec9005aso769921plr.10
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 16:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zCJDCK8B0lL6JubhIyGfaHMZb5Qp7vvPx+3RInS6vEE=;
        b=bEo8CbzbHriKnkqNIGJfYKHguuXOz576eX2T4cHlipuA8XvhukRnyam2cGRz+vvTpw
         RKJ42EslOVMjlUZ5CqQ4Ro08rbQLot9XVom2AtVhJJsFRpPuXeGRD7+kE5bpRt8Qchq7
         mMho4sxejFkUfAZbxPpKnDuYiyy3NfeZqL47umZAHwKfmYzRsaUKEQSMQF6uEpU395dt
         bTBuze3KrAItL51NXFJk8Yx6OLDDZZ+pkLmxqY+EN/KoiYLwEqHKxOtAT/Xc+klpzLNy
         L6eSziMkwAPaIASt9BXbcqjCoVM19WcMyU3KXGrS5/AslQMgCIEuuN29MySTWd/dS5VG
         L/aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zCJDCK8B0lL6JubhIyGfaHMZb5Qp7vvPx+3RInS6vEE=;
        b=KU1TJtLMSLW/IztfxtJmu9BCdMTNg++CwwdL4T7oVxkvOkextgmzi3FoRlDdUAakUV
         KLwknDgkyePyfKjwTCJPFRMKuhYY5V6UlmVaWP8XYS7x9h8hTH9joEtjy9CoEoRIQITZ
         L0WxhzCivErYAxyT3/EWADx3SDmdD4Y13DPSlrh0/gpKctJgt6pqWK3MfiOtLcq79uQk
         3FoD+vSn13bYtlLhW6ZLgL5tjzC7RNIk69BJJtytFRXhj8x7WNC/tPJuKoCwASx5WjAN
         shqTTcFHehTU2F6RGC3dlTM3SmhiKrsYucbE1MTMK4MaJN2I1SZHjUgWPZMP8GJV2mZd
         j6rw==
X-Gm-Message-State: AOAM532qWDht+DVEU3g3jgqpicSzyWZZWu57Sz/l96uZj85KURrDpRyg
        i6KaHLiFtNWqgG8KE6ItpLv9NRYJ5TPZww==
X-Google-Smtp-Source: ABdhPJz4xnTY2m6Isi4IBgbuJhluKtEZACOCW6bqOZj5r5ynVvnXZt7dHD/2bSBFHfhe17fyQtZKmIVyCTxRMw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:238f:b0:4f7:78b1:2f6b with SMTP
 id f15-20020a056a00238f00b004f778b12f6bmr4873058pfc.17.1646958350133; Thu, 10
 Mar 2022 16:25:50 -0800 (PST)
Date:   Fri, 11 Mar 2022 00:25:13 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-12-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 11/26] KVM: x86/mmu: Use common code to allocate
 kvm_mmu_page structs from vCPU caches
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

Now that allocating a kvm_mmu_page struct is isolated to a helper
function, it can be re-used in the TDP MMU.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 3 +--
 arch/x86/kvm/mmu/mmu_internal.h | 1 +
 arch/x86/kvm/mmu/tdp_mmu.c      | 8 +-------
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2dcafbef5ffc..4c8feaeb063d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1704,8 +1704,7 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
-						      bool direct)
+struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu, bool direct)
 {
 	struct kvm_mmu_page *sp;
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 5f91e4d07a95..d4e2de5f2a6d 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -173,6 +173,7 @@ void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
 struct kvm_mmu_page *kvm_mmu_alloc_direct_sp_for_split(bool locked);
 
+struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu, bool direct);
 void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp);
 
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 184874a82a1b..f285fd76717b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -269,13 +269,7 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 
 static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 {
-	struct kvm_mmu_page *sp;
-
-	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
-	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
-	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
-
-	return sp;
+	return kvm_mmu_alloc_shadow_page(vcpu, true);
 }
 
 static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
-- 
2.35.1.723.g4982287a31-goog

