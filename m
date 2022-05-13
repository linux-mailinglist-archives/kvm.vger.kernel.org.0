Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD8F526B41
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 22:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384207AbiEMU2g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 16:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384187AbiEMU2c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 16:28:32 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F15913D38
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:28:31 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id s18-20020a17090aa11200b001d92f7609e8so4843426pjp.3
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=X4uCUUh1rGfmOD3/lWwoQuwN7ClE8CziC7hFPLNCRtY=;
        b=D+SqHN8mdRc8BL1rfGtiekRaSJl3f0YnaNXNdnFgl1ETHNpYxoGN5Kuo+1V2x/byIN
         1THOBeRRMM1zoYJwvw9u+wIldGQs8IuK7mR7B9torY0FsExnkwks6TxEqaSnWjT/NvHI
         Hm27XGxIrCJRT66NrEDN8zpTavZ+IdfY4bLYRsznH4FaxFfZGZRdebnJN49+PYibFfQp
         9hE98DfIiUW5591QIxsQ5wOwZam050l45UcMYxlKpn6kxACsv8krs+MmqfQHZ6IqAKgO
         UX4hMR8H48v8JGBzc1tnMpzVaf5QgcJkc5UCGRBUMbDRHGKZNAgGgEHNi8UY3eXby53U
         p8gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=X4uCUUh1rGfmOD3/lWwoQuwN7ClE8CziC7hFPLNCRtY=;
        b=sEIMH1Skw19x5k07OwB37M58r6J5SE/ZbjYYwhXOhLuOALVztYbz/VEJ1MXf3TX60v
         4mytp7wMN191FCBr2GCI+unSlqVZQ/RtNHwfzD7XbBglCrPT0mdinwVphsLKXfT9ucIf
         7vO05NqEschggGtewTMPyvyvZGkRVpR0d/CYAsf0F02g0OmBfqmobtiE9HvuSfzfPYUg
         egrA1PFB8RTWASE1QGHu1RoAPD9Y+irZBnY6cqjihnXxuI39hoXvnxciFflkmgHeVAaV
         r4WYB05WLmW2WF1GFhmS2JcfAalJElGQPzahU0ot70TjkrD4iszvXSR73wT3pRd7ihHT
         jBRw==
X-Gm-Message-State: AOAM5321UZJKHwlTNWrZWWNMtcCb/icEVh30y8iFnxgJAP1MugFx6smP
        gPfmbexFLbqMubb+jOpEO2XAsqk4oQGp/Q==
X-Google-Smtp-Source: ABdhPJx0ATiV54nUGtkWD0IQzoJ65BdVb90HAJIfXF6d3Rj+J9RZCZbycBpEb2AXQ0VGCPF6D/fUa0OxUbxRZQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:dac2:b0:15e:c69c:d2fb with SMTP
 id q2-20020a170902dac200b0015ec69cd2fbmr6215793plx.135.1652473710888; Fri, 13
 May 2022 13:28:30 -0700 (PDT)
Date:   Fri, 13 May 2022 20:28:00 +0000
In-Reply-To: <20220513202819.829591-1-dmatlack@google.com>
Message-Id: <20220513202819.829591-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v5 02/21] KVM: x86/mmu: Use a bool for direct
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The parameter "direct" can either be true or false, and all of the
callers pass in a bool variable or true/false literal, so just use the
type bool.

No functional change intended.

Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 774810d8a2ed..34fb0cddff2b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1690,7 +1690,7 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
+static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, bool direct)
 {
 	struct kvm_mmu_page *sp;
 
@@ -2023,7 +2023,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     gfn_t gfn,
 					     gva_t gaddr,
 					     unsigned level,
-					     int direct,
+					     bool direct,
 					     unsigned int access)
 {
 	union kvm_mmu_page_role role;
-- 
2.36.0.550.gb090851708-goog

