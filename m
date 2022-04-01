Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD9E4EF95C
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 19:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350852AbiDAR63 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 13:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350749AbiDAR6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 13:58:22 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51F526481A
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 10:56:31 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id k7-20020aa79727000000b004fdc86d9b79so1986594pfg.8
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 10:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SFXm2KwniaE00QEj2NzqHgvf1ASQ84rh2AbpNytHfco=;
        b=qJlGcvodbGXModlH9jGukKmgTNEjWAOITQQu62mFHP6LKDJbwZqskUJsLcP86ZbJU6
         ci9SF25lZR0byT8KkjvNOzhD5SdjyuAbbl77X2sYflrRrmhCGM3luPp1sOeeEkV+3EAL
         72SOwJfxzbZxHxeJw0r5hmFUuOz8+1rGkoNZg9n+oGWFvq9KXzbUDF9pwFZSsRX7F7CU
         QAYlhUtNCoVt4sAs4aFJDgnE2BjvLy8UVhToIBfsNEPPIcfoYrdvQP2Y5Al9np8aW+3Z
         vZlfv9GdlmFaj4JXon3BM18j1zorzjZSDNDzm7hgwuUh83hha4yb45BqMoS1/CXJ+Jpn
         +MMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SFXm2KwniaE00QEj2NzqHgvf1ASQ84rh2AbpNytHfco=;
        b=qIvf4+93Od+vE9b6Y2OgadFluED2B2Vz1243dHQtupg8peSMJRPi4Sf2DdP7YK+xUT
         zKTCrz4LEkw2BfaxQFfX26IPG55hTRl/pmwJusAW7/VUJ4kwxIcPwc/XkHE8t4ruO08T
         d12Dx/esMl9a2nZu3rO98pwNwPcan7ZI13Hspo8XHxWJ+7NTNOBMilHJRbZAuuKYmxiF
         mBHdKakkZM/RsWbV+OYKatc7xSo48q/EOQ0Hxo47tGAmkIlp9WGlXFHXH/VRWHJSrJ/M
         ChH78+lO7bi3XYwzqib+QtGtovw/PerfgQpXQZf1w0aklFelJ7G7xMgeXqVPyP+qgmnw
         +rWg==
X-Gm-Message-State: AOAM531gy14n5qn2EbEIZUB0gymrhba2iarTaZ6rOXVGmPI3eaRoa5ez
        RGV9gy1TQrJglRK9qbKNtC7+MzJD6yMtOg==
X-Google-Smtp-Source: ABdhPJy5g1z/iSbFZBwpj7J/HiTUYMlrOwh+Ud1JO3xyCytgN0gs7EbKQm2V60MVCQpu5tAlITqiMh3TNmIocA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:e78f:b0:156:3b3b:e4ce with SMTP
 id cp15-20020a170902e78f00b001563b3be4cemr17310175plb.8.1648835791370; Fri,
 01 Apr 2022 10:56:31 -0700 (PDT)
Date:   Fri,  1 Apr 2022 17:55:50 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-20-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 19/23] KVM: x86/mmu: Refactor drop_large_spte()
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
index 6390b23d286a..f058f28909ea 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1184,28 +1184,29 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
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
2.35.1.1094.g7c7d902a7c-goog

