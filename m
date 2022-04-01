Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9113F4EF93C
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 19:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350639AbiDAR6B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 13:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350640AbiDAR5y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 13:57:54 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96062C4E2A
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 10:56:04 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id gk23-20020a17090b119700b001c65a1baa01so1637406pjb.5
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 10:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jbEbkPKHHe1JjNjX3H5iG4xlTs9fnMsds5ok0hlcBBc=;
        b=VV57lG6jUHDDUIO2Lve/uFa7PUGIIl+l6vrjKQogFkiWK8u49u3fcY3FaY1VnX4SWU
         lAhHv82539GUIUhq5aY9Du6ih9DNPH3fkNleGNlcSEwXfPzGL+uipqnqtPitwZgwY1En
         57IYSOhVR6QY6lWhxuALbHeIrXgCjKYELkI6V4Xg8HggG1c7xMCmklb0Ukj4j2O9z6nQ
         YHOCnhTZhVGdpOaQG3eacojXN34VLFVPbQS8nVMFlhHg4igvU1YVx1PAf6nhmFbJBGl2
         y61oE1GKqMOOrtIH+uzY9fU55CkheYZRQEPwA//BTrqovqruJ4S0W1hVj+wMXZn/uESV
         wioA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jbEbkPKHHe1JjNjX3H5iG4xlTs9fnMsds5ok0hlcBBc=;
        b=C5A2IsGCXmJkALJlc6QJ2BQspFitxOhCzFQJwsCH4xgURZxrEnjC2Iz3918ixOWrkr
         UOqlz/NXHRbhXofqGdeJVPzOjeoeoR4Zs/RyxG4H0WcsqdREt4IkGnxWPTAwj3a8rZ3W
         0uFA66b/nXwE5M6RhzW2TBb/lZmkGlls+ew0oaV94f22gynRLfr4L8HkjFhTlJIdbTrP
         nda5jlQImGigRprPPHyhu1OZ/KjfKQAKT34psP7FTkObIIov5yuaLOoWWN70EM3G+j0t
         kFlIDxX1zOlrBt9Aa1gdp2CGPDwigBPhlPuFrg7Jw4ObpOLxiWwm4INTbpVSfM/a15vd
         +owg==
X-Gm-Message-State: AOAM531m4HMO8OXrV8SXCbpjmxn9kEjwFl4mC7afmbTmNg6chg/3qbkt
        ualfCq4+KBnRbXBrJv1C05sG1q7moGEHmA==
X-Google-Smtp-Source: ABdhPJyXx7LaJtvQMH0HZ9aVW4MOJlG+noLjDvNAF17gJHNyl1HpSw9eMVXCjPkuG58rcMsky7HoJ7Kj5bLngA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:ccc4:b0:156:5d37:b42f with SMTP
 id z4-20020a170902ccc400b001565d37b42fmr7667666ple.157.1648835764076; Fri, 01
 Apr 2022 10:56:04 -0700 (PDT)
Date:   Fri,  1 Apr 2022 17:55:33 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 02/23] KVM: x86/mmu: Use a bool for direct
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

The parameter "direct" can either be true or false, and all of the
callers pass in a bool variable or true/false literal, so just use the
type bool.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dbfda133adbe..1c8d157c097b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1706,7 +1706,7 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
+static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, bool direct)
 {
 	struct kvm_mmu_page *sp;
 
@@ -2031,7 +2031,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     gfn_t gfn,
 					     gva_t gaddr,
 					     unsigned level,
-					     int direct,
+					     bool direct,
 					     unsigned int access)
 {
 	union kvm_mmu_page_role role;
-- 
2.35.1.1094.g7c7d902a7c-goog

