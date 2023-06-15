Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C381D731E95
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 19:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbjFORA1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 13:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbjFOQ7r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 12:59:47 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A60123
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 09:59:45 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5704995f964so4762987b3.2
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 09:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686848385; x=1689440385;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ncA8NUQ/d7RIXyoqKxF4dofBT4rINO6z44852n+jNFs=;
        b=3+BLFa+Gex3JLa4Zjt1LnKcKFDqyW7CVf7F+H6cOlGpsVINgPgwXyBezn84ilCScQj
         VEgywmnKY7GLPanOVXUespMiUXuOxLzFqwmDxyyFm/8z1IeyCs1FdebyMF5ykXWTVQ2A
         Bg9EKrWtul41ll1LOjDjwTKcngzEwIE4oEdWfe7MaFsWgzqDFmUy/H10RvQ+RdMw19f4
         bTnyN5swJ/XbJCyti74SLgwiuR94BWZwLL2oAgVBWrbe0rAc6d5feHQ2wSyJ1AzgvxUg
         vFa/cNJqTGbNSlx8MrOWVgEIWOT+lK1n7ifu70g4+RsV/MQ/oHanzxaWgeajwqAffE3K
         6K0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686848385; x=1689440385;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ncA8NUQ/d7RIXyoqKxF4dofBT4rINO6z44852n+jNFs=;
        b=VSFk9ePECh5K3rj2L/+DWCHi5k8/NnNuNuTgkqo2E10IWY4z+sq59/3f5yOK8CWIsS
         /OtaIBSVijlRTLPSwzXSOKe0XimVCo0g7dQPZ7wM5nnou3auXs8Zu2/1AyELC/BHViTX
         G6X9h7eTIr3G75xud9qGcWx6WR9qQO+lHZUusN7XY85W59EmnP6XTgd9eFit/bxx68SC
         lX/4LM51UQlfvs0c9+BH8y2GSAUHJxDmUp1uygvj9vgY0E7sicEmd5C1bEOdgaj95h4z
         mEAXuAHVjOfzMqbhGfugMN/8uO3arj88MuyBTLS1qYKOk3uji6UCRNIItCTDrjoEhp9z
         4YHw==
X-Gm-Message-State: AC+VfDwWdLh+qmUAyE0BKzsvosctIVnxm4ft6PgBt38+51jMXgxr/ZL4
        eEDv6ajl89omKSLSExNYL1WJaBMegiM=
X-Google-Smtp-Source: ACHHUZ58VbUpKiHJn4yWrs3hFzFVgLfs2NAcssDwAzKOV57o1C8oPk/BJPOHvBI5DAEtAMIVLjSdWrCDPAY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:3495:0:b0:bc3:9cd9:6e0e with SMTP id
 b143-20020a253495000000b00bc39cd96e0emr732274yba.10.1686848384875; Thu, 15
 Jun 2023 09:59:44 -0700 (PDT)
Date:   Thu, 15 Jun 2023 09:59:43 -0700
In-Reply-To: <20230526234435.662652-9-yuzhao@google.com>
Mime-Version: 1.0
References: <20230526234435.662652-1-yuzhao@google.com> <20230526234435.662652-9-yuzhao@google.com>
Message-ID: <ZItDf5lpKJz7uezP@google.com>
Subject: Re: [PATCH mm-unstable v2 08/10] kvm/x86: move tdp_mmu_enabled and shadow_accessed_mask
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhao <yuzhao@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alistair Popple <apopple@nvidia.com>,
        Anup Patel <anup@brainfault.org>,
        Ben Gardon <bgardon@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Gaosheng Cui <cuigaosheng1@huawei.com>,
        Gavin Shan <gshan@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        James Morse <james.morse@arm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Larabel <michael@michaellarabel.com>,
        Mike Rapoport <rppt@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paul Mackerras <paulus@ozlabs.org>,
        Peter Xu <peterx@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        linux-trace-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@google.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 26, 2023, Yu Zhao wrote:
> tdp_mmu_enabled and shadow_accessed_mask are needed to implement
> kvm_arch_has_test_clear_young().
> 
> Signed-off-by: Yu Zhao <yuzhao@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 6 ++++++
>  arch/x86/kvm/mmu.h              | 6 ------
>  arch/x86/kvm/mmu/spte.h         | 1 -
>  3 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index fb9d1f2d6136..753c67072c47 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1772,6 +1772,7 @@ struct kvm_arch_async_pf {
>  
>  extern u32 __read_mostly kvm_nr_uret_msrs;
>  extern u64 __read_mostly host_efer;
> +extern u64 __read_mostly shadow_accessed_mask;
>  extern bool __read_mostly allow_smaller_maxphyaddr;
>  extern bool __read_mostly enable_apicv;
>  extern struct kvm_x86_ops kvm_x86_ops;
> @@ -1855,6 +1856,11 @@ void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
>  			     bool mask);
>  
>  extern bool tdp_enabled;
> +#ifdef CONFIG_X86_64
> +extern bool tdp_mmu_enabled;
> +#else
> +#define tdp_mmu_enabled false
> +#endif

I would much prefer that these be kept in kvm/mmu.h.  And looking at all the arch
code, there's no reason to make kvm_arch_has_test_clear_young() a runtime callback,
all of the logic is constant relative to when KVM is loaded.

So rather than have generic KVM pull from arch code, what if we have arch code
push info to generic KVM?  We could even avoid #ifdefs if arch code passed in its
handler.  That might result in an extra indirect branch though, so it might be
better to just use a flag?  E.g. the x86 conversion would be something like this.

---
 arch/x86/kvm/mmu/mmu.c     |  5 +++++
 arch/x86/kvm/mmu/tdp_mmu.c |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.h |  1 +
 include/linux/kvm_host.h   | 24 ++++--------------------
 virt/kvm/kvm_main.c        | 14 ++++++++++----
 5 files changed, 21 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c8ebe542c565..84a4a83540f0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5809,6 +5809,11 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 		max_huge_page_level = PG_LEVEL_1G;
 	else
 		max_huge_page_level = PG_LEVEL_2M;
+
+	if (tdp_mmu_enabled && kvm_ad_enabled())
+		kvm_init_test_clear_young(kvm_tdp_mmu_test_clear_young);
+	else
+		kvm_init_test_clear_young(NULL);
 }
 EXPORT_SYMBOL_GPL(kvm_configure_mmu);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f463d54228f8..e878c88f0e02 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1308,7 +1308,7 @@ bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	return kvm_tdp_mmu_handle_gfn(kvm, range, test_age_gfn);
 }
 
-bool kvm_arch_test_clear_young(struct kvm *kvm, struct kvm_gfn_range *range)
+bool kvm_tdp_mmu_test_clear_young(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	struct kvm_mmu_page *root;
 	int offset = ffs(shadow_accessed_mask) - 1;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 0a63b1afabd3..aaa0b75b3896 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -34,6 +34,7 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 bool kvm_tdp_mmu_age_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
+bool kvm_tdp_mmu_test_clear_young(struct kvm *kvm, struct kvm_gfn_range *range);
 
 bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 			     const struct kvm_memory_slot *slot, int min_level);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1714f82a0c47..7a0922cbc36f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -264,31 +264,15 @@ struct kvm_gfn_range {
 	pte_t pte;
 	bool may_block;
 };
+
+typedef bool (*hva_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
+
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_should_clear_young(struct kvm_gfn_range *range, gfn_t gfn);
-bool kvm_arch_test_clear_young(struct kvm *kvm, struct kvm_gfn_range *range);
-#endif
-
-/*
- * Architectures that implement kvm_arch_test_clear_young() should override
- * kvm_arch_has_test_clear_young().
- *
- * kvm_arch_has_test_clear_young() is allowed to return false positive, i.e., it
- * can return true if kvm_arch_test_clear_young() is supported but disabled due
- * to some runtime constraint. In this case, kvm_arch_test_clear_young() should
- * return true; otherwise, it should return false.
- *
- * For each young KVM PTE, kvm_arch_test_clear_young() should call
- * kvm_should_clear_young() to decide whether to clear the accessed bit.
- */
-#ifndef kvm_arch_has_test_clear_young
-static inline bool kvm_arch_has_test_clear_young(void)
-{
-	return false;
-}
+void kvm_init_test_clear_young(hva_handler_t arch_test_clear_young);
 #endif
 
 enum {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ef2790469fda..ac83cfb30771 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -530,8 +530,6 @@ static void kvm_mmu_notifier_invalidate_range(struct mmu_notifier *mn,
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
-typedef bool (*hva_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
-
 typedef void (*on_lock_fn_t)(struct kvm *kvm, unsigned long start,
 			     unsigned long end);
 
@@ -859,6 +857,14 @@ bool kvm_should_clear_young(struct kvm_gfn_range *range, gfn_t gfn)
 	return args->clear;
 }
 
+static hva_handler_t kvm_test_clear_young;
+
+void kvm_init_test_clear_young(hva_handler_t arch_test_clear_young)
+{
+	WARN_ON_ONCE(!list_empty(&vm_list));
+	kvm_test_clear_young = arch_test_clear_young;
+}
+
 static int kvm_mmu_notifier_test_clear_young(struct mmu_notifier *mn, struct mm_struct *mm,
 					     unsigned long start, unsigned long end,
 					     bool clear, unsigned long *bitmap)
@@ -873,7 +879,7 @@ static int kvm_mmu_notifier_test_clear_young(struct mmu_notifier *mn, struct mm_
 
 	trace_kvm_age_hva(start, end);
 
-	if (kvm_arch_has_test_clear_young()) {
+	if (kvm_test_clear_young) {
 		struct test_clear_young_args args = {
 			.bitmap	= bitmap,
 			.end	= end,
@@ -882,7 +888,7 @@ static int kvm_mmu_notifier_test_clear_young(struct mmu_notifier *mn, struct mm_
 
 		range.args = &args;
 		range.lockless = true;
-		range.handler = kvm_arch_test_clear_young;
+		range.handler = kvm_test_clear_young;
 
 		if (!__kvm_handle_hva_range(kvm, &range))
 			return args.young ? MMU_NOTIFIER_RANGE_LOCKLESS : 0;

base-commit: 39ca80f27cc0d2a37b4e3d07bbf763d4954934d7
-- 

