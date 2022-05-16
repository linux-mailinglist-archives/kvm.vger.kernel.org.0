Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E076A529524
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 01:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbiEPXVy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 19:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347287AbiEPXVs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 19:21:48 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348D73FD9A
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:21:47 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id s25-20020a656459000000b003c6086e82f2so8000365pgv.8
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zkwVRlCBK+wAm9y2qZnwJE+dWQNdd4JJmhlMHaSmu7M=;
        b=SGzud3XII9ilZZ9cJ3NATl2Luk5qA/LwCNuOYjpzH9/NNzuV3KE0B346ImYvfsFQCc
         0tLA6vX+cj5T0JRstiFPYMnv70aHhmjTyTbm2lXjOCKi9Lx4rHnaRk/Cai3P/fGpwcKQ
         /oMLInVXPjO0nLXXDaNjCwNLJPOTDNi3uPQvuu87ZdfYqCcXO6RwhrNeq6GnRNJfsWrW
         nGCqj+DbMUHntM27KcB4Urc2ysW7SAnYBM7SbRlbYXrTDqqNj151FR48GSNq1Np503Mh
         LzIQZ9K1g0eU3RKZeI8fpekfOxvTE12ARh7w8l+hazJRQeVT/+D/VPVkmyBUW3LKkXFS
         mL8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zkwVRlCBK+wAm9y2qZnwJE+dWQNdd4JJmhlMHaSmu7M=;
        b=4Ow/13Y8UpfSqVSIw1URwrzxDeL1atTKklCIqhgb3Ih5mX1UXHfaqc8PF1Y98dgfAk
         qyeais9QdUsLFhoRiUiOedmu7Hc6fEyDcWcnzdpRjefbW4AgM0bmBvgVBKVXvYYAyx3J
         2zhLxfy9Ee9FNut7dJDzfTgClJ5QhtakLI9Ewmx1iYan1JzLrXOqzFIgpokPreqXb/mm
         59Ym8OCPtqjHvTsoe3TnEliwuPs0JE1EEVsndShyaCvWfmK4F6YA5sw2UyQTN03JmFX8
         Q+03CyBVXBweVy2Jh5VPPPlB8wHzwoPdp9dn9nLDq//lUA+zR8OncvVSMjwzzCyhzY94
         BDjQ==
X-Gm-Message-State: AOAM533u3qDwGJuePVY2f5Z5nzA3PM3lzSKnF9AF0ooFeOobSzScqLhV
        JEalEeaXaVcCbogq8jddwzxLOpE5+cqt/A==
X-Google-Smtp-Source: ABdhPJz8uccrEg4IPlytWVMEEgGF+hD2GjvQMOQbByqnliBhoAzZpHlwpUaLTsvf9VDP6uHQSyDcXWSqIuJRug==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:903:40d1:b0:15e:f8ee:c278 with SMTP
 id t17-20020a17090340d100b0015ef8eec278mr19695401pld.100.1652743306698; Mon,
 16 May 2022 16:21:46 -0700 (PDT)
Date:   Mon, 16 May 2022 23:21:19 +0000
In-Reply-To: <20220516232138.1783324-1-dmatlack@google.com>
Message-Id: <20220516232138.1783324-4-dmatlack@google.com>
Mime-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v6 03/22] KVM: x86/mmu: Stop passing @direct to mmu_alloc_root()
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

The argument @direct is vcpu->arch.mmu->root_role.direct, so just use
that.

Suggested-by: Lai Jiangshan <jiangshanlai@gmail.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 34fb0cddff2b..a9d28bcabcbb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3370,8 +3370,9 @@ static int mmu_check_root(struct kvm_vcpu *vcpu, gfn_t root_gfn)
 }
 
 static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
-			    u8 level, bool direct)
+			    u8 level)
 {
+	bool direct = vcpu->arch.mmu->root_role.direct;
 	struct kvm_mmu_page *sp;
 
 	sp = kvm_mmu_get_page(vcpu, gfn, gva, level, direct, ACC_ALL);
@@ -3397,7 +3398,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
 		mmu->root.hpa = root;
 	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
-		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level, true);
+		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level);
 		mmu->root.hpa = root;
 	} else if (shadow_root_level == PT32E_ROOT_LEVEL) {
 		if (WARN_ON_ONCE(!mmu->pae_root)) {
@@ -3409,7 +3410,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 			WARN_ON_ONCE(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
 
 			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT),
-					      i << 30, PT32_ROOT_LEVEL, true);
+					      i << 30, PT32_ROOT_LEVEL);
 			mmu->pae_root[i] = root | PT_PRESENT_MASK |
 					   shadow_me_mask;
 		}
@@ -3533,7 +3534,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 */
 	if (mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL) {
 		root = mmu_alloc_root(vcpu, root_gfn, 0,
-				      mmu->root_role.level, false);
+				      mmu->root_role.level);
 		mmu->root.hpa = root;
 		goto set_root_pgd;
 	}
@@ -3579,7 +3580,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		}
 
 		root = mmu_alloc_root(vcpu, root_gfn, i << 30,
-				      PT32_ROOT_LEVEL, false);
+				      PT32_ROOT_LEVEL);
 		mmu->pae_root[i] = root | pm_mask;
 	}
 
-- 
2.36.0.550.gb090851708-goog

