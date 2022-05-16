Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBFB6529535
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 01:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350484AbiEPXW0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 19:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350392AbiEPXWG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 19:22:06 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF32942EFE
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:22:02 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id g5-20020a17090a4b0500b001df2807132fso400428pjh.7
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=A6CVaoOuq2onvCNWimXYpavQumfN27L5Xs2b3S02gqQ=;
        b=bcwsxBglOBT4ZMVcMYItKNA0ZXLA0rV5EG2SQ5hQYnPtPtavU8lCYwMOUrK0CF/3/Z
         GAZ5SE/AFjz6wbTCtxZVlBnxdb9ONyz51LENidkTwYadfda963XbV0U96/xbrAN2RHWl
         zbPrybTDO7h17b1zmyv8x54rr7IjJ0tbGwzq/zxnHDqoGr/Flesx6upKd4aNlQ5552D/
         0+2IH/aMiLKSoEvKrd5KW4r42n2ARj+Oel56xhrDVgm5FK51oek4doTlm9nt4Bu9Bcy0
         QnakT0ka/TDa3fVDGIuyGZdr96UfKNygkvuRPBTNCSHxMC0Sw+6Rpsix8IViN7Sgi343
         cpIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=A6CVaoOuq2onvCNWimXYpavQumfN27L5Xs2b3S02gqQ=;
        b=GEE6wkStSDrLrq/ADU643Y3hNxhVlFeSEUPswy6t3FckblQQffQLSWyAv9KQBg+ZnI
         Mx7/y70vdDSiMBuOOVLEvvkNAOxjDoCev7AD2W1jTSwHjIsJxnzokcAIdo7Ld6iZ/TTm
         icm2LvKN1YhnxVGQcYnt3EgC8rQ5ygYTSauNSYt73KoG/Vt0pNXrDlTs0uCN1kFTF9s6
         krwog+nIV3twQWtDM8NiaQRBye3FqFKaKZgQ8gyQKJq935xAjINeSgPqepvBI+f4b96s
         6DTcXaHMFD3+SAqvvbJAfV88pwRuauDFgw8oxfT+Hpr3FUJPth8kqDcWaATbATxZAnu2
         YAKg==
X-Gm-Message-State: AOAM532kptka7WXfhIUssX4R7uWLPn9+l92Z3GXQyTGge4rnHd5w9/ld
        AmKh0eN007qOySZQBbj/VtV8Hy8ky18xow==
X-Google-Smtp-Source: ABdhPJwbkPyHCHgoWRkNMjiw3yFJAqcG0ROERSd4sGrkNJEIJIVAScIP5FlL7jgS9O1xF6hECroMyEfuaoOXnA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:ad2:b0:4f1:2734:a3d9 with SMTP
 id c18-20020a056a000ad200b004f12734a3d9mr19554806pfl.61.1652743322409; Mon,
 16 May 2022 16:22:02 -0700 (PDT)
Date:   Mon, 16 May 2022 23:21:29 +0000
In-Reply-To: <20220516232138.1783324-1-dmatlack@google.com>
Message-Id: <20220516232138.1783324-14-dmatlack@google.com>
Mime-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v6 13/22] KVM: x86/mmu: Allow NULL @vcpu in kvm_mmu_find_shadow_page()
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

Allow @vcpu to be NULL in kvm_mmu_find_shadow_page() (and its only
caller __kvm_mmu_get_shadow_page()). @vcpu is only required to sync
indirect shadow pages, so it's safe to pass in NULL when looking up
direct shadow pages.

This will be used for doing eager page splitting, which allocates direct
shadow pages from the context of a VM ioctl without access to a vCPU
pointer.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4fbc2da47428..acb54d6e0ea5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1850,6 +1850,7 @@ static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 
 	if (ret < 0)
 		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
+
 	return ret;
 }
 
@@ -2001,6 +2002,7 @@ static void clear_sp_write_flooding_count(u64 *spte)
 	__clear_sp_write_flooding_count(sptep_to_sp(spte));
 }
 
+/* Note, @vcpu may be NULL if @role.direct is true. */
 static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
 						     struct kvm_vcpu *vcpu,
 						     gfn_t gfn,
@@ -2039,6 +2041,16 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
 			goto out;
 
 		if (sp->unsync) {
+			/*
+			 * A vCPU pointer should always be provided when finding
+			 * indirect shadow pages, as that shadow page may
+			 * already exist and need to be synced using the vCPU
+			 * pointer. Direct shadow pages are never unsync and
+			 * thus do not require a vCPU pointer.
+			 */
+			if (KVM_BUG_ON(!vcpu, kvm))
+				break;
+
 			/*
 			 * The page is good, but is stale.  kvm_sync_page does
 			 * get the latest guest state, but (unlike mmu_unsync_children)
@@ -2116,6 +2128,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 	return sp;
 }
 
+/* Note, @vcpu may be NULL if @role.direct is true. */
 static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
 						      struct kvm_vcpu *vcpu,
 						      struct shadow_page_caches *caches,
-- 
2.36.0.550.gb090851708-goog

