Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64FD6476BD
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 20:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiLHTl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 14:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiLHTkf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 14:40:35 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1997D389C8
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 11:40:17 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id a4-20020a5b0004000000b006fdc6aaec4fso2548249ybp.20
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 11:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZDFxAZ/PI9aKYqwedjkDPDUn0PCD9WUxHYy13eGAWTI=;
        b=UW5TQakihQ1Rj8oX0fHh6ol3yHICPRAUjId2fBE9HBOx4Z4cfwRHCzOFro0DVog5Py
         z1d9aYSN4fRQh+yVjk9c6erIMnvGY+3XCA5eND2mJd3lmcs6ZMcic9/HWoIHmoYD+B1m
         XjqLDiAn+QBJHnf0vzOfnGkxZlkIa53ilOScS8egg7kyZLK+h2NKejyWCaVjbbt+sR5R
         IhfagMv7s1KO30A1KDYGC5ziILrcoD8HH6N1IH5+EVj3HMWjpbtHUPdv5fpd7dQKJ+67
         MzWuFb+b2SqNDBq56KYHPAYiPt7QBIFy/9sPV8aGa7CXG5RzY4NELQedDkJBW9qr9WbA
         evPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZDFxAZ/PI9aKYqwedjkDPDUn0PCD9WUxHYy13eGAWTI=;
        b=d0wo7syq3tbOmiPP3QDFmPe8lz7Yz1NgH/ZRwogUI1DHrtUH3arh9ur6NN1hJ+avyP
         dh5EZqRAMzb+eNTqBeDYoBF0dL2RAO+QkBKNWpnP/EQekiDEGpM6T4AaEUplbvhaM6Qw
         4Ei5r5E6n1D5D4ARxnjS0YYbXAmTdV1MZ7lFsQT8TMf1xJ+K1CFIx+xohtiHH0JXbJCn
         Hx8l2rwOSN23f8is8Yk6p1lulufV7aqxhPFXRcju5HAdsHnSyGJ2wIoeYC0Y4S30qbGB
         V55MEn193IaqyulSR9Cq3gaqLaThGQSG0zw7iLS5vagbpBERXdoTGTSHrdGYMXTvnvbP
         TmQA==
X-Gm-Message-State: ANoB5pmiuooe+a85BXeW9yAV1n4YQB8Ul9s0uV7jTuUvi65riiEp2Qmg
        LScdLuVN0Mkr1NQhI/FSm/Wz/SBCMn3GRw==
X-Google-Smtp-Source: AA0mqf4h5P1c4eLdLR7BQ8qrkqY9isQdWdfvRcIECxB1d810mucDHdG6W99tV9EeqSL89xl1lTy+w8pwh40XXQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:6a89:0:b0:6dd:989f:2af4 with SMTP id
 f131-20020a256a89000000b006dd989f2af4mr92028743ybc.38.1670528406445; Thu, 08
 Dec 2022 11:40:06 -0800 (PST)
Date:   Thu,  8 Dec 2022 11:38:55 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-36-dmatlack@google.com>
Subject: [RFC PATCH 35/37] KVM: x86/mmu: Move tdp_mmu_max_gfn_exclusive() to tdp_pgtable.c
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Matlack <dmatlack@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Nadav Amit <namit@vmware.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
        Colin Cross <ccross@google.com>,
        Hugh Dickins <hughd@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
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

Move tdp_mmu_max_gfn_exclusive() to tdp_pgtable.c since it currently
relies on the x86-specific kvm_mmu_max_gfn() function. This can be
improved in the future by implementing a common API for calculating the
max GFN.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm/tdp_pgtable.h |  3 +++
 arch/x86/kvm/mmu/tdp_mmu.c             | 11 -----------
 arch/x86/kvm/mmu/tdp_pgtable.c         | 11 +++++++++++
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm/tdp_pgtable.h b/arch/x86/include/asm/kvm/tdp_pgtable.h
index ff2691ced38b..c1047fcf1a91 100644
--- a/arch/x86/include/asm/kvm/tdp_pgtable.h
+++ b/arch/x86/include/asm/kvm/tdp_pgtable.h
@@ -67,4 +67,7 @@ u64 tdp_mmu_make_changed_pte_notifier_pte(struct tdp_iter *iter,
 					  struct kvm_gfn_range *range);
 u64 tdp_mmu_make_huge_page_split_pte(struct kvm *kvm, u64 huge_spte,
 				     struct kvm_mmu_page *sp, int index);
+
+gfn_t tdp_mmu_max_gfn_exclusive(void);
+
 #endif /* !__ASM_KVM_TDP_PGTABLE_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c035c051161c..c950d688afea 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -828,17 +828,6 @@ static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
 	return iter->yielded;
 }
 
-static inline gfn_t tdp_mmu_max_gfn_exclusive(void)
-{
-	/*
-	 * Bound TDP MMU walks at host.MAXPHYADDR.  KVM disallows memslots with
-	 * a gpa range that would exceed the max gfn, and KVM does not create
-	 * MMIO SPTEs for "impossible" gfns, instead sending such accesses down
-	 * the slow emulation path every time.
-	 */
-	return kvm_mmu_max_gfn() + 1;
-}
-
 static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			       bool shared, int zap_level)
 {
diff --git a/arch/x86/kvm/mmu/tdp_pgtable.c b/arch/x86/kvm/mmu/tdp_pgtable.c
index fb40abdb9234..4e747956d6ee 100644
--- a/arch/x86/kvm/mmu/tdp_pgtable.c
+++ b/arch/x86/kvm/mmu/tdp_pgtable.c
@@ -170,3 +170,14 @@ int tdp_mmu_max_mapping_level(struct kvm *kvm,
 {
 	return kvm_mmu_max_mapping_level(kvm, slot, iter->gfn, PG_LEVEL_NUM);
 }
+
+gfn_t tdp_mmu_max_gfn_exclusive(void)
+{
+	/*
+	 * Bound TDP MMU walks at host.MAXPHYADDR.  KVM disallows memslots with
+	 * a gpa range that would exceed the max gfn, and KVM does not create
+	 * MMIO SPTEs for "impossible" gfns, instead sending such accesses down
+	 * the slow emulation path every time.
+	 */
+	return kvm_mmu_max_gfn() + 1;
+}
-- 
2.39.0.rc1.256.g54fd8350bd-goog

