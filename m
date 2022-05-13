Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1355B526B5C
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 22:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384358AbiEMU31 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 16:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384347AbiEMU3V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 16:29:21 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614382FE76
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:29:01 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id q3-20020a17090a304300b001dd2130b435so4861927pjl.0
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HdSYABheIVOM10QD4ZayPYXlWKlD3eG3FLGapADPyAM=;
        b=DKv+56mwaJWUT+G4vsPsYCrRgu169RzDr1vagq7TzGEWd8AGHodvyf1WxeUSTaQk1R
         NZpymIDqGyI73sb4uJT4lVVGGSNWJoPOGVC3ufHvKHKYMUDvpLfYxri94REs0NdLnym4
         VQlUurwgO69SpR4w7OrRXKWUnkasbPEm/KGx2WDD45/Wch+D2vSCMrwnnLxBR5Dg+i++
         RbIaYmLyPpn+RmzwOcwuiMaxrmfIOKCC9JC3SeXVyGnF3OPutmFP8inT0wwv8GBmXQ7k
         up4S9n+QdlOKGVRoYLpl3fUoIcGjM0FIiWJyGxiCbZ5/sEGDz4LRyDtCZBI7ZEf5/LAe
         dYYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HdSYABheIVOM10QD4ZayPYXlWKlD3eG3FLGapADPyAM=;
        b=BrNbuuHVVxnZYHiylOAh+vonVqnOYvTaUBtxcRDKHYXw+cGxixilYdyElJRlRbgfYe
         VSV/n81pPROBBKAjnr/IuD58P+zT6IA9fvnU0GC4v9mV8hem74aPg1ymyK4q0oam/Gcp
         jq3ja0efLM9R/DQkkq2jkeUdNdnZTWVXQldMTqxV7IZfqKGc5n8sFgnOGSNrUjb/SeHI
         I88A6CAIpjNAwkWqJ7SvWHpGnPoBNCUdlcoxh0OPaareZE/e6RbyF5S2VDWUew41jNTq
         FzunruPrkkQtpWOker0UbKKF5EtomQ+LKGHvFw94vLNzDYyMpqr1syf2ygiGYQWTZVSP
         Sz9g==
X-Gm-Message-State: AOAM531+8U6QSph9MFe9hLMgrKamgyYheo0uVRPkh6D8uP0n9Y/ZkPhW
        U4eIRaAdMIRk7Jiu7FrGVPU1hJO+hRqIow==
X-Google-Smtp-Source: ABdhPJwj07m7NSEGJMSuAfHJ7qPKyzdtRoR8FmJzEkiBVDgBAvJuoRdDpvYbVdyeM8hldK3oO0+DNeon+My0nA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:c7d2:b0:1d9:34fe:10dc with SMTP
 id gf18-20020a17090ac7d200b001d934fe10dcmr18025976pjb.109.1652473733328; Fri,
 13 May 2022 13:28:53 -0700 (PDT)
Date:   Fri, 13 May 2022 20:28:11 +0000
In-Reply-To: <20220513202819.829591-1-dmatlack@google.com>
Message-Id: <20220513202819.829591-14-dmatlack@google.com>
Mime-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v5 13/21] KVM: x86/mmu: Pass const memslot to rmap_add()
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

rmap_add() only uses the slot to call gfn_to_rmap() which takes a const
memslot.

No functional change intended.

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bc66029d837f..8a6dec1c27c8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1582,7 +1582,7 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 #define RMAP_RECYCLE_THRESHOLD 1000
 
-static void rmap_add(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
+static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
 		     u64 *spte, gfn_t gfn)
 {
 	struct kvm_mmu_page *sp;
-- 
2.36.0.550.gb090851708-goog

