Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848EB4EF949
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 19:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239207AbiDAR6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 13:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350669AbiDAR6F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 13:58:05 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C1E1DB3F8
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 10:56:15 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id r16-20020a638f50000000b00386086767c6so2010997pgn.6
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 10:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=iIUi4j5dTF9zBg27X61yXEUlsha95IziaYqw02FJyl4=;
        b=XUYkEsDRY+yxOCCR/ISvExrk4TUU/9GP5XtZIVgZZDgY9kQP/XNnlk8fvUiSOISjYK
         R5m/JMOu+EmpXbr04dXRQa3x0NDxA+wEK3Kuz/EnkzaIX58tYbeh5VIO1ePqPEADkcP+
         Bxr9baz/W/j0udZ76lWfRF8cYFvhRj3MFWoWUBcTG0gE/u6V6q5Pr6lM/mJiJpFcEG/M
         Ypf+ihXzgburWCxjfnncvi45fUrEjlfc6Kk10teb6t1BFUYa7k9dsG5WHjomwRREcHD9
         UGOO5aksD6e2p7VRKL8vpkBf9oXsHOu3bl1zFvbHF0S6ZiuWYOv4Gib1FOulsahDO063
         e0wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=iIUi4j5dTF9zBg27X61yXEUlsha95IziaYqw02FJyl4=;
        b=wZsCpvbCmOU6y/e9k1Vt0KqhMSYc0mTPeDV9Ox5RxFwG3enZYCxFNrGK8s6Gs8D3jJ
         sXXSjnqHrhBy5vdesPgB2uK9LyGTikVH/YNyeL+Lbtl/8n0uiVqCg7nCnI1IlU/qQbHO
         uPj1Xz1qOlw1EcangI0xaQAOY4mA30+6SjBa+YYbsiejJEouZtlSNBLPNHlKAbUorOFF
         jfleTGUX9A0Zbw2IiuOpSMDnCsA12baCB9l7T7lo4nXSGVsOxJpXYWsR00XYFMyJ1jlZ
         B8hDMJnHKaEsh66+/E924aH13D4vjSYcoCXA8r9c3uzreoIZFZ5Bq84LefsphTkil0Ea
         rrXw==
X-Gm-Message-State: AOAM533JzDaoyJjVdPoLOk5K/u2y1LxSjw5j2DSUYUrQtQqrgQg0ZdG1
        RmAv1JQaT24LgOl0e46MlH7RwV+ysj1vnA==
X-Google-Smtp-Source: ABdhPJzO4HC0kF89hVPwzXPdQHYPWNvD/kUD++1/OnBDK4J5ailVX4fYbPj+olrmsSjzQDC0shWUbcvlHeR7vQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:e81:b0:1c6:5a9c:5afa with SMTP id
 fv1-20020a17090b0e8100b001c65a9c5afamr587543pjb.1.1648835774239; Fri, 01 Apr
 2022 10:56:14 -0700 (PDT)
Date:   Fri,  1 Apr 2022 17:55:39 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-9-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 08/23] KVM: x86/mmu: Link spt to sp during allocation
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
index b3b6426725d4..17354e55735f 100644
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
@@ -1435,6 +1434,8 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
 		return NULL;
 	}
 
+	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
+
 	return sp;
 }
 
-- 
2.35.1.1094.g7c7d902a7c-goog

