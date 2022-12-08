Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 190C9647672
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 20:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiLHTjn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 14:39:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiLHTjc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 14:39:32 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2340F99F30
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 11:39:26 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3bd1ff8fadfso24704487b3.18
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 11:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jgO+J07Uxt+qL/UpUVJ8WFrJDihM9AG5kpD8vJwjTTs=;
        b=QrMj5zLDlUXO+ZJ45hsRtxdfgmeW4IfijEqSAU7FIBqFwathovRwq/mzAGouVficrL
         gQcJIU9VmUG2hiNERRKbyTP3Lu3VIHMZ2AloTdIYXMt+wMOuMe8kDJQZMRgSvO6lAwNU
         Y6eBROrQrZ0gTi3qA1W8jY3mdXkghgQbhZG8f+ggIaWBggOtbOEtA4aAL9qoZ6wA6iTL
         UulvutyuA0lBG+LimgEdM3A93jCX+bLrq+G1CQa39qEIq4rZ4XwAKrU+qa0csJ6wjd9Z
         9Ua/MZeoHkveM5nl5wYxeuSnKf6S8qPxrJT/LRGNG++VotU8B0SenTfkKWEFNecwApXV
         JVtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jgO+J07Uxt+qL/UpUVJ8WFrJDihM9AG5kpD8vJwjTTs=;
        b=nh4VjEe6IO2LepQLLp3u9aCb3tFAH2WL+CmvY4yL/Evi6UlAypF2/4omZ5Wf7RkRaS
         MI7bB4yt/QkkeeaUHpO/LfgsSQkXRgLP2I970Psbj4eNG20p7M3KAv2JfEeBg30mPZQ9
         PtD1c5u0n4kpnY0OK0tdBeA1aTFe87avch3XhInPzse+qiEq9AS4YswuDCB6CUwzU8yD
         t/di1L92Ey4q18D81YL+i+nrx+hSzZrGYCN9wd54MSEJq09peNVOSTSLFDw52Arr2eSY
         APY/dvUYYlqdgRzPNLKan9Q8QgqxfBUTnhi2z8sZRTQ9RCI8PJC3zsmlDo08xIxLQ0tE
         E/jg==
X-Gm-Message-State: ANoB5pmXctZgd9mwciuW4jPsbkrgd/gwkWGJoquTzBazwQldTpM1l4YL
        2W+cfePGwVlmY06CXUpFJ9wnZVFKKDcMjg==
X-Google-Smtp-Source: AA0mqf4cuymNRC2hTArY/T3ebCSKh1ZW9fvhwu59cqHtPCYYXp2h3U5rWse1hGwJtXv7Z28ATD5Q6YFLoVGbsg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:d03:0:b0:706:e165:f752 with SMTP id
 3-20020a250d03000000b00706e165f752mr8717208ybn.510.1670528365193; Thu, 08 Dec
 2022 11:39:25 -0800 (PST)
Date:   Thu,  8 Dec 2022 11:38:31 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-12-dmatlack@google.com>
Subject: [RFC PATCH 11/37] KVM: MMU: Move RET_PF_* into common code
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the RET_PF_* enum into common code in preparation for moving the
TDP MMU into common code.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 28 ----------------------------
 include/kvm/mmu_types.h         | 26 ++++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 4abb80a3bd01..d3c1d08002af 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -79,34 +79,6 @@ static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
 
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
-/*
- * Return values of handle_mmio_page_fault(), mmu.page_fault(), fast_page_fault(),
- * and of course kvm_mmu_do_page_fault().
- *
- * RET_PF_CONTINUE: So far, so good, keep handling the page fault.
- * RET_PF_RETRY: let CPU fault again on the address.
- * RET_PF_EMULATE: mmio page fault, emulate the instruction directly.
- * RET_PF_INVALID: the spte is invalid, let the real page fault path update it.
- * RET_PF_FIXED: The faulting entry has been fixed.
- * RET_PF_SPURIOUS: The faulting entry was already fixed, e.g. by another vCPU.
- *
- * Any names added to this enum should be exported to userspace for use in
- * tracepoints via TRACE_DEFINE_ENUM() in mmutrace.h
- *
- * Note, all values must be greater than or equal to zero so as not to encroach
- * on -errno return values.  Somewhat arbitrarily use '0' for CONTINUE, which
- * will allow for efficient machine code when checking for CONTINUE, e.g.
- * "TEST %rax, %rax, JNZ", as all "stop!" values are non-zero.
- */
-enum {
-	RET_PF_CONTINUE = 0,
-	RET_PF_RETRY,
-	RET_PF_EMULATE,
-	RET_PF_INVALID,
-	RET_PF_FIXED,
-	RET_PF_SPURIOUS,
-};
-
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 					u32 err, bool prefetch)
 {
diff --git a/include/kvm/mmu_types.h b/include/kvm/mmu_types.h
index 9f0ca920bf68..07c9962f9aea 100644
--- a/include/kvm/mmu_types.h
+++ b/include/kvm/mmu_types.h
@@ -110,4 +110,30 @@ struct kvm_page_fault {
 	struct kvm_page_fault_arch arch;
 };
 
+/*
+ * Return values for page fault handling routines.
+ *
+ * RET_PF_CONTINUE: So far, so good, keep handling the page fault.
+ * RET_PF_RETRY: let CPU fault again on the address.
+ * RET_PF_EMULATE: mmio page fault, emulate the instruction directly.
+ * RET_PF_INVALID: the spte is invalid, let the real page fault path update it.
+ * RET_PF_FIXED: The faulting entry has been fixed.
+ * RET_PF_SPURIOUS: The faulting entry was already fixed, e.g. by another vCPU.
+ *
+ * Any names added to this enum should be exported to userspace for use in
+ * tracepoints via TRACE_DEFINE_ENUM() in arch/x86/kvm/mmu/mmutrace.h.
+ *
+ * Note, all values must be greater than or equal to zero so as not to encroach
+ * on -errno return values.  Somewhat arbitrarily use '0' for CONTINUE, which
+ * will allow for efficient machine code when checking for CONTINUE.
+ */
+enum {
+	RET_PF_CONTINUE = 0,
+	RET_PF_RETRY,
+	RET_PF_EMULATE,
+	RET_PF_INVALID,
+	RET_PF_FIXED,
+	RET_PF_SPURIOUS,
+};
+
 #endif /* !__KVM_MMU_TYPES_H */
-- 
2.39.0.rc1.256.g54fd8350bd-goog

