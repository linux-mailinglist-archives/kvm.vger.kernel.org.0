Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6356529540
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 01:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350470AbiEPXX3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 19:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350417AbiEPXWe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 19:22:34 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E14847391
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:22:27 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id t70-20020a638149000000b0039daafb0a84so8014923pgd.7
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pOEpw0U33jr850+hJHIZzPyg7hTIgQtXSLis/i9XW2k=;
        b=Xnun/wU2caTw/TxytZw8C9PSMZVLpb/VyRFu9noez6eaQwaXPIj0voai+u3SrfupAL
         tP5/68go2tx/JL6YYh00U0kUNwS4PgBrY+jFy91J+yf6yDzRikismgT8ytU+bWiZwOMD
         H82NvsF6117s1fVl5CE9EceBQAbMUpO4iBiKZlBlW6Q/ZqRi93hpNNBO0nyyyVFEjSz2
         vIcOaJ+EmqapsNP8M806ZHqZphJjZQk/lcJKZWO+f8o4XXFOWGFyjZGIDY3e6xqPI7Hs
         O72sKJDdIDLNTAI1//4vvfnI/CyvRfgOoG4K4GQjO2GKr68kjxK/vwA1xJirWnp9W+Ef
         VU8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pOEpw0U33jr850+hJHIZzPyg7hTIgQtXSLis/i9XW2k=;
        b=jiVOa+AKp6/jNRVqdme/KrZBfaxaAxeJWwgHdOXvNV9I7PgasjeW3U0b/IOfsxxj3U
         3BI+a/Gj+/1qAlikayH7k7cZ2qxSlGqCATc9ZUYTewGhS8AqmX6WkeAGOmDyI2PVQyTJ
         TneTAycUgrv/Eu632uT9XDalzgVHnPCo8MjPM/TG4Bys5zFLab/zVuFWoHNnZcyCNOg/
         bpjzqE3To3I1Jo+kfQ5/jkS4lEohxHrOhvYYzTougAlDT9yp8JXwxUjUe+VroUGWouQ7
         ApgJganmy3Z4oMLxxXN8SI99Z9zl3xgjlEBEVm1s6fGGnNzC6VkZb1ZQtgG2wpBwF0T+
         /5yQ==
X-Gm-Message-State: AOAM533jAHZO9a17qiD1pVLNCdp5f5HWDbhGXKCbnqwZup9APkBoNMZE
        WUzd+KAVr5GJEec4eCOJkFdgQWeN4aLc1g==
X-Google-Smtp-Source: ABdhPJz0ymAkSZMwmu2LJ3LS8G7Tkc01yfF7lgaeQlHMPPCk+C7g1qkIdP9NE7LK1ED0+F/WsKGsJCum8ZRNqg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:e80d:b0:15e:b27b:931c with SMTP
 id u13-20020a170902e80d00b0015eb27b931cmr19808069plg.5.1652743333371; Mon, 16
 May 2022 16:22:13 -0700 (PDT)
Date:   Mon, 16 May 2022 23:21:36 +0000
In-Reply-To: <20220516232138.1783324-1-dmatlack@google.com>
Message-Id: <20220516232138.1783324-21-dmatlack@google.com>
Mime-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v6 20/22] KVM: x86/mmu: Refactor drop_large_spte()
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
 arch/x86/kvm/mmu/mmu.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a5d96d452f42..964a8fa63e1b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1161,26 +1161,26 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
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
+	if (!is_large_pte(*sptep))
+		return;
+
+	sp = sptep_to_sp(sptep);
+	WARN_ON(sp->role.level == PG_LEVEL_4K);
+
+	drop_spte(kvm, sptep);
+
+	if (flush)
+		kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
+			KVM_PAGES_PER_HPAGE(sp->role.level));
 }
 
 static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
 {
-	if (__drop_large_spte(vcpu->kvm, sptep)) {
-		struct kvm_mmu_page *sp = sptep_to_sp(sptep);
-
-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
-			KVM_PAGES_PER_HPAGE(sp->role.level));
-	}
+	return __drop_large_spte(vcpu->kvm, sptep, true);
 }
 
 /*
-- 
2.36.0.550.gb090851708-goog

