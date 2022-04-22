Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1FC450C3C0
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 01:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbiDVWQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 18:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232447AbiDVWPh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 18:15:37 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD05F31A163
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 14:06:08 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id q13-20020a638c4d000000b003821725ad66so5625461pgn.23
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 14:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=K3CLnYXYtvwizIx0k/SHLSP8rSxb5Vb9/+Ons8DtsNg=;
        b=l2jbmncxyjqZKtjNxBwQjGGI5g04tJzYsGlUZdx53H4OmCl7Mb8VVw6NQr06/u5sIm
         t7o9fZY1KQubggYso4Hk8sVINmzelJOkDXmo4A3b0OvzrgMUHpJfM5GxpywlO8GiaglK
         boESpTsBCImRP9pHIN6HhIgSF8AVf860FSrJpiJk5cCfpoMa8Uutbu1v1IJjbjHKip5P
         OmoUnN2F8FYsQ9FiQJc5WB5DzQ4wQW5qYVEoc2/ebZ6AAXM7SCjgglwzsMQFgp/GNklH
         4O8m1AQ4dX5M6yymiWkhpE5eycUOVcGs06KWM6JBv7y+h9hHVc2cO/wykNVd1YFzJahw
         gK3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=K3CLnYXYtvwizIx0k/SHLSP8rSxb5Vb9/+Ons8DtsNg=;
        b=Ri9disfRjbiZf5a6mveaGet5o2gq/SvOMY51u2qSFUGNF0ZuFRTtAspR93qYACpiH8
         PrFxJQ0m5OuZ+OEzn2QlSSbIO+duudOar+CjzABO06/ciMEqh8CoTDV+ALN7fb7fXn24
         NUSqKxXKZZMf+9IKzkaWo9zgkrMLA4qkcexUfoRgzuDShlmZkhutMa6lbqss0m5L4yw3
         vkniOXCX3McDFpZlzariUD91rOPc49iD/VmDYOKLdFgQ6AmImJuQ9qPx0p0+XSa7BUB7
         vaa4vXI0RedIzHF7SURhKhnCqox205+l3DXmxuITDPM31+fcQSNl64QjSoAPfm9+3bdO
         oPeg==
X-Gm-Message-State: AOAM531cFD+eZmrR+ueA21PGKM1Y40iKCdiKNjC1AGnVbOBHkoocG3IH
        ERkJqlLDKJjlN7VfzY7pOPhGi+KKaCzmeA==
X-Google-Smtp-Source: ABdhPJxo16FW5saOeBbKmUkcRSzAGnKKyvc+JzAJ2fwc+QXYy7JIR3KSk+h5wZyUpeyuzG8nBdVfN7Odw8S7VQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:9105:b0:1d2:9e98:7e1e with SMTP
 id k5-20020a17090a910500b001d29e987e1emr620451pjo.0.1650661567820; Fri, 22
 Apr 2022 14:06:07 -0700 (PDT)
Date:   Fri, 22 Apr 2022 21:05:38 +0000
In-Reply-To: <20220422210546.458943-1-dmatlack@google.com>
Message-Id: <20220422210546.458943-13-dmatlack@google.com>
Mime-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v4 12/20] KVM: x86/mmu: Pass const memslot to rmap_add()
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
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
index 21407bd4435a..142c2f357f1b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1595,7 +1595,7 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 #define RMAP_RECYCLE_THRESHOLD 1000
 
-static void rmap_add(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
+static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
 		     u64 *spte, gfn_t gfn)
 {
 	struct kvm_mmu_page *sp;
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

