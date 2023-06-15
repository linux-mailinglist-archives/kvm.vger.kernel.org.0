Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8FD731F71
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 19:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237994AbjFORnL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 13:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236206AbjFORnE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 13:43:04 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6AD2294C
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 10:42:59 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b521e4e88bso3736795ad.2
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 10:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686850979; x=1689442979;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3VaVpYnKKIXM0ZMJBv2BahWS6rKgSDR5ikxQlp7Qm5M=;
        b=CRqM4fJoSy0TOwQEM+dwNf4YLmN8ZNvadtNeqmejsTpkrhB3fUKCS5gVORcT3YAFGF
         i/3D4htNDkxjLmMQr6ex9h88D9Mn3b3BcimZjQyHYDLLHrnhvGGLYYK4DnkhEsQ6CVaZ
         cXJTMz7MEXsf3MpnUFcr6Mx0t4RSwdzHZHJMQ/Gw529RF41s9TMoKGTDzFQ40JREZYAz
         j/q5bFPXA1TGS/pjeQnxzb2ibh5u61Yat52z5h2i3whlu/NZWmrHHKlNBlQzVnj3NGqb
         fUd5ZYUT6Xx5VG3C07mjHJV5Ti0lFZylCk6cioTWTVk9aptHHtPLM7okEk048bn6RBzX
         EGGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686850979; x=1689442979;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3VaVpYnKKIXM0ZMJBv2BahWS6rKgSDR5ikxQlp7Qm5M=;
        b=GwGKaEumGo8cEcEgBGaU82KBDzBzPCRHsB9z7haQb+ZzotULYz5fTFgTOv3yGMxIOl
         stASviVFvq/TmDO/lCklW7QFvBnwso8d88jNFvsRGjVrxyW8ao9FZnoNPL30HtkifO4h
         lnubm7X0T1rz32h6VlJrQfcjzg6bk6fAcDY972GdBEiVlIDQMEhP+SwZ7jJsw6MXAqs/
         ZjdledLttABwAHA3EWPEA2a/jtJnataR/0nZ24IsaGyB5ES3huHXe+ANoQvBvGazHA0q
         LNxlaxRhMm6wz6bG4Ux+7w/pBpXCSSj/pZ5x6f52zuFOX9YDwWCe2h7a4a2HzsD55ySy
         BVyg==
X-Gm-Message-State: AC+VfDwHvsym0fChKf7QrAyUh3VU1ywsxzGqP48/hlfLk8Sc5QPmZ6Na
        Neb9mQ3vQf7R0sksK+wF5T/6okmSry4=
X-Google-Smtp-Source: ACHHUZ4cQlpzVe0KczazAvYqGjGYoNkXv8UVqui26XxKS9kOBWmazT/WNj+BhRRRMGskVfw0J/AilzSk6Q0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f7d3:b0:1b5:147f:d8d1 with SMTP id
 h19-20020a170902f7d300b001b5147fd8d1mr547182plw.3.1686850979254; Thu, 15 Jun
 2023 10:42:59 -0700 (PDT)
Date:   Thu, 15 Jun 2023 10:42:57 -0700
In-Reply-To: <20230526234435.662652-2-yuzhao@google.com>
Mime-Version: 1.0
References: <20230526234435.662652-1-yuzhao@google.com> <20230526234435.662652-2-yuzhao@google.com>
Message-ID: <ZItNoeWriZgLUaon@google.com>
Subject: Re: [PATCH mm-unstable v2 01/10] mm/kvm: add mmu_notifier_ops->test_clear_young()
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 26, 2023, Yu Zhao wrote:
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 0e571e973bc2..374262545f96 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -258,6 +258,7 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
>  #ifdef KVM_ARCH_WANT_MMU_NOTIFIER
>  struct kvm_gfn_range {
>  	struct kvm_memory_slot *slot;
> +	void *args;

There's no reason to make this "void *", just declare "struct test_clear_young_args"
in the header.  Arch code won't be able to use it regardless.  And I vote for
something more like "test_clear_young_metadata", as there's far more information
in there than just function arguments.

And to stave off the argument that "void *" would allow reuse, take this opportunity
to unionize the test_clear_young field with the change_pte field, e.g.

	/* comment about these fields being callback specific. */
	union {
		struct test_clear_young_metadata *metadata;
		pte_t pte;
		unsigned long callback_arg; /* needs a better name */
	};

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 51e4882d0873..31ee58754b19 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -541,6 +541,7 @@ typedef void (*on_lock_fn_t)(struct kvm *kvm, unsigned long start,
>  typedef void (*on_unlock_fn_t)(struct kvm *kvm);
>  
>  struct kvm_hva_range {
> +	void *args;

Same feedback as kvm_gfn_range.

>  	unsigned long start;
>  	unsigned long end;
>  	pte_t pte;
> @@ -549,6 +550,7 @@ struct kvm_hva_range {
>  	on_unlock_fn_t on_unlock;
>  	bool flush_on_ret;
>  	bool may_block;
> +	bool lockless;
>  };
>  
>  /*
> @@ -602,6 +604,8 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
>  			hva_end = min(range->end, slot->userspace_addr +
>  						  (slot->npages << PAGE_SHIFT));
>  
> +			gfn_range.args = range->args;

And this goes away because the generic callback_arg is what gets propagated.

> +
>  			/*
>  			 * To optimize for the likely case where the address
>  			 * range is covered by zero or one memslots, don't
> @@ -619,7 +623,7 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
>  			gfn_range.end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, slot);
>  			gfn_range.slot = slot;
>  
> -			if (!locked) {
> +			if (!range->lockless && !locked) {
>  				locked = true;
>  				KVM_MMU_LOCK(kvm);
>  				if (!IS_KVM_NULL_FN(range->on_lock))
> @@ -628,6 +632,9 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
>  					break;
>  			}
>  			ret |= range->handler(kvm, &gfn_range);
> +
> +			if (range->lockless && ret)

I don't like overloading "lockless" to also mean "stop on ret".  Just add another
flag, there's literally no cost for most callbacks as everything is constant at
compile time and gets optimized away.

> +		range.args = &args;
> +		range.lockless = true;

The lockless and stop_on_ret behavior needs comments.

> +		range.handler = kvm_arch_test_clear_young;
> +
> +		if (!__kvm_handle_hva_range(kvm, &range))
> +			return args.young ? MMU_NOTIFIER_RANGE_LOCKLESS : 0;
> +	}
> +
> +	if (bitmap)
> +		return 0;
> +
> +	range.args = NULL;
> +	range.lockless = false;

No need to manually clear these, they'll be zeroed by the initialization code.

E.g. all in all, something like so

---
 include/linux/kvm_host.h |  9 +++++++--
 virt/kvm/kvm_main.c      | 29 +++++++++++++++++------------
 2 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7a0922cbc36f..e04605061f5e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -256,12 +256,17 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #endif
 
 #ifdef KVM_ARCH_WANT_MMU_NOTIFIER
+struct test_clear_young_metadata;
+
 struct kvm_gfn_range {
 	struct kvm_memory_slot *slot;
-	void *args;
 	gfn_t start;
 	gfn_t end;
-	pte_t pte;
+	union {
+		struct test_clear_young_metadata *metadata;
+		pte_t pte;
+		unsigned long callback_arg;
+	};
 	bool may_block;
 };
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ac83cfb30771..8cf4fee9cd8b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -536,16 +536,20 @@ typedef void (*on_lock_fn_t)(struct kvm *kvm, unsigned long start,
 typedef void (*on_unlock_fn_t)(struct kvm *kvm);
 
 struct kvm_hva_range {
-	void *args;
 	unsigned long start;
 	unsigned long end;
-	pte_t pte;
 	hva_handler_t handler;
+	union {
+		struct test_clear_young_metadata *metadata;
+		pte_t pte;
+		unsigned long callback_arg;
+	};
 	on_lock_fn_t on_lock;
 	on_unlock_fn_t on_unlock;
 	bool flush_on_ret;
 	bool may_block;
 	bool lockless;
+	bool stop_on_ret;
 };
 
 /*
@@ -576,6 +580,9 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 	struct kvm_memslots *slots;
 	int i, idx;
 
+	BUILD_BUG_ON(sizeof(gfn_range.callback_arg) != sizeof(gfn_range.pte) ||
+		     sizeof(gfn_range.callback_arg) != sizeof(gfn_range.metadata));
+
 	if (WARN_ON_ONCE(range->end <= range->start))
 		return 0;
 
@@ -599,16 +606,14 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 			hva_end = min(range->end, slot->userspace_addr +
 						  (slot->npages << PAGE_SHIFT));
 
-			gfn_range.args = range->args;
-
 			/*
 			 * To optimize for the likely case where the address
 			 * range is covered by zero or one memslots, don't
 			 * bother making these conditional (to avoid writes on
 			 * the second or later invocation of the handler).
 			 */
-			gfn_range.pte = range->pte;
 			gfn_range.may_block = range->may_block;
+			gfn_range.callback_arg = range->callback_arg;
 
 			/*
 			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
@@ -628,7 +633,8 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 			}
 			ret |= range->handler(kvm, &gfn_range);
 
-			if (range->lockless && ret)
+			/* comment goes here. */
+			if (range->stop_on_ret && ret)
 				break;
 		}
 	}
@@ -830,7 +836,7 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 	return kvm_handle_hva_range(mn, start, end, __pte(0), kvm_age_gfn);
 }
 
-struct test_clear_young_args {
+struct test_clear_young_metadata {
 	unsigned long *bitmap;
 	unsigned long end;
 	bool clear;
@@ -839,7 +845,7 @@ struct test_clear_young_args {
 
 bool kvm_should_clear_young(struct kvm_gfn_range *range, gfn_t gfn)
 {
-	struct test_clear_young_args *args = range->args;
+	struct test_clear_young_metadata *args = range->metadata;
 
 	VM_WARN_ON_ONCE(gfn < range->start || gfn >= range->end);
 
@@ -880,14 +886,15 @@ static int kvm_mmu_notifier_test_clear_young(struct mmu_notifier *mn, struct mm_
 	trace_kvm_age_hva(start, end);
 
 	if (kvm_test_clear_young) {
-		struct test_clear_young_args args = {
+		struct test_clear_young_metadata args = {
 			.bitmap	= bitmap,
 			.end	= end,
 			.clear	= clear,
 		};
 
-		range.args = &args;
 		range.lockless = true;
+		range.stop_on_ret = true;
+		range.metadata = &args;
 		range.handler = kvm_test_clear_young;
 
 		if (!__kvm_handle_hva_range(kvm, &range))
@@ -897,8 +904,6 @@ static int kvm_mmu_notifier_test_clear_young(struct mmu_notifier *mn, struct mm_
 	if (bitmap)
 		return 0;
 
-	range.args = NULL;
-	range.lockless = false;
 	range.handler = clear ? kvm_age_gfn : kvm_test_age_gfn;
 
 	return __kvm_handle_hva_range(kvm, &range) ? MMU_NOTIFIER_RANGE_YOUNG : 0;

base-commit: 7a5d8be2c18415b73b9380741095f439d6983a40
-- 

