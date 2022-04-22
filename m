Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766CE50C46C
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 01:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbiDVWQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 18:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232513AbiDVWPj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 18:15:39 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC6423E82B
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 14:06:18 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id m11-20020a170902f64b00b0015820f8038fso5388813plg.23
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 14:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=csGYTTgLO7JTG/MJ5ZHEQ2SmxGLM+rnUmtz6vs2mn6s=;
        b=l6jEQB9U0csYEWcZJhqMEDMGTLs5di/EI5F8Zl27LVUFQVVbi0H8o/zOFCcleLtiY+
         DloYUdzhQnpql77qPuxt/n7StWTAaWm6cLKHG8wRlJyx6oTE2RRQMC0Yno3+3qbu/tSs
         0lUXlo2suXJfMDuaOLenwPemb5XB88+bVHvMZL/08yLuT21GdYaE5z2agCUHVTlHs8mr
         8b+WLywouaTvocy1dbYHvhiHpRAFotAB6zRcoBC1Uidlucu3YR5/JJT3PjudfZp+ZzGy
         RXiOMXICz8LY6gLoV4fXLR77uTv0/nY8mThs4Fi/vx3UcL3wZfMcEOrAqbbJbMLUxsUD
         Grcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=csGYTTgLO7JTG/MJ5ZHEQ2SmxGLM+rnUmtz6vs2mn6s=;
        b=Dq3XA+rfmoVUn1NzB6kM+xJil4+6w0dbcz3muXidvTFsGvBfYFlaKlyEDJWpgamgPz
         fu7QXcfb8GDo2L8UNq5mjvvngeOLNQtdUoERWpLJr7nQG2fu8jd6j3E8mg4cCa4Z3sy5
         BYFN/2GmXoc5sv2vv1KrRXO9y+gyMulYq0y1QnZX43t6ZTsrO4R41m63pAsMJvgJRAHq
         mjUwLInPTkTN2/KcM1TCzSvA9IPIH+xhomDpTMke5An+b4awZ9iKcDkQ0IuV482tNmbr
         GLPnCqn/ZYjFVIGwaAn/1F1m8xiqntHZ3xdm2TxlaupfkA8+CD5mQOEPmk9UTdVEPLsa
         mBbg==
X-Gm-Message-State: AOAM531AhelYae63JUqIz3aWXyFBWKqrWp37ls95eNolqdP39k1JVaUj
        gMq6bn67nDK0As+UZa+hQfMhyKOE4mjYTg==
X-Google-Smtp-Source: ABdhPJxwGKSMoT7a6vuDBG/9QPLNL6WSI7Wg6RWBF/U9+Ei6+zMEnYYjdJzGj5E995zo4cGyM9VmfiTBeQH5gw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:6d96:b0:1c9:c1de:ef2f with SMTP
 id a22-20020a17090a6d9600b001c9c1deef2fmr18212154pjk.210.1650661577643; Fri,
 22 Apr 2022 14:06:17 -0700 (PDT)
Date:   Fri, 22 Apr 2022 21:05:44 +0000
In-Reply-To: <20220422210546.458943-1-dmatlack@google.com>
Message-Id: <20220422210546.458943-19-dmatlack@google.com>
Mime-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v4 18/20] KVM: x86/mmu: Refactor drop_large_spte()
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

drop_large_spte() drops a large SPTE if it exists and then flushes TLBs.
Its helper function, __drop_large_spte(), does the drop without the
flush.

In preparation for eager page splitting, which will need to sometimes
flush when dropping large SPTEs (and sometimes not), push the flushing
logic down into __drop_large_spte() and add a bool parameter to control
it.

No functional change intended.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 479c581e8a96..a5961c17eb36 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1183,28 +1183,29 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 		rmap_remove(kvm, sptep);
 }
 
-
-static bool __drop_large_spte(struct kvm *kvm, u64 *sptep)
+static void __drop_large_spte(struct kvm *kvm, u64 *sptep, bool flush)
 {
-	if (is_large_pte(*sptep)) {
-		WARN_ON(sptep_to_sp(sptep)->role.level == PG_LEVEL_4K);
-		drop_spte(kvm, sptep);
-		return true;
-	}
+	struct kvm_mmu_page *sp;
 
-	return false;
-}
+	if (!is_large_pte(*sptep))
+		return;
 
-static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
-{
-	if (__drop_large_spte(vcpu->kvm, sptep)) {
-		struct kvm_mmu_page *sp = sptep_to_sp(sptep);
+	sp = sptep_to_sp(sptep);
+	WARN_ON(sp->role.level == PG_LEVEL_4K);
 
-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
+	drop_spte(kvm, sptep);
+
+	if (flush) {
+		kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
 			KVM_PAGES_PER_HPAGE(sp->role.level));
 	}
 }
 
+static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
+{
+	return __drop_large_spte(vcpu->kvm, sptep, true);
+}
+
 /*
  * Write-protect on the specified @sptep, @pt_protect indicates whether
  * spte write-protection is caused by protecting shadow page table.
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

