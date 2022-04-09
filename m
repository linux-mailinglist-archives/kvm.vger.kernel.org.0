Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701084FA065
	for <lists+kvm@lfdr.de>; Sat,  9 Apr 2022 02:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240119AbiDIAEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 20:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbiDIAEh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 20:04:37 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5A8350E61
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 17:02:32 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id q19so9078361pgm.6
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 17:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=e2UFjk4BMnk+zP4UK0Oe7cRWvUTvvv2vQZFG2iTsfwM=;
        b=mdX7iP5bZ0QKDVpxEfl6JaRv0SNJilcGM7Go8YYeEz4gRMixSlW3qkCfkPK79y6RlU
         7/F17ratHj7AGZmESWeAsvGLabxpVpOu8N2tikaIOw7/UAqJv+g+iG30qnes71/NujAQ
         2zz/5YDsD9xVfIKxApF2cVw8CAb0LCjXj33B5MetmlMhp5ZSZSLnwuW8PIsjywbaqicX
         Rlo7KwTT7w36OlXkiyh4WBwIjEEgEopDHnOLsTV9NwPjmYV2cZXzlD/ilmsX/IHdjQmw
         3gV/E7Z8D+MjQVn04swpk/fD42Z0WN0IvoNmshVAofDlSGfpwESdiI3owTY0tkT8NFLA
         G0YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=e2UFjk4BMnk+zP4UK0Oe7cRWvUTvvv2vQZFG2iTsfwM=;
        b=8A+VfWQ99L547U85odTLB26nkF57SOZzCvjlV9OoTxMU7TuOcxWmnOlYxapetRR7Wr
         Uo1pXMs5X2FYO8QPvFHK+qXEUI89Iu36WKjckYYNRLhlNCYhWxNHSFEQHrMf+0Ww2pjA
         Bra+QBHFVQzauoM5BFyDmvJ+SEs9tSbFiHmc5H0SNSFT/OrYwYlNa+hAKfo3PFueXdyY
         Jsdu+MaxKXA32Ej7O/62QY4wk2UUSBu5M4FVCyp8Ksm7miOxbDiUttpt+tvou4rsLcIQ
         kYDynlWau7ky2IMpl8177kB3DFzNxzk9RTeKI9iTXfW+bqJ8VkMcHOWR8cgTx5SuRG9g
         u4ug==
X-Gm-Message-State: AOAM530s/8hO9Ofu+w3vIEow9vpf2Qixq1POLF7jP+8bmWltAEVfwQrf
        6bjUbTU6kjbqMjGJaJI+QGdmNg==
X-Google-Smtp-Source: ABdhPJz2NQbeCFpFKvK/llHsQ85xKlEatkwNAY/T4PMI36jEC0CY8gsBFafanPSUhYPrIUBR0RTv+g==
X-Received: by 2002:a05:6a00:1a10:b0:4fa:ed5a:6697 with SMTP id g16-20020a056a001a1000b004faed5a6697mr22026865pfv.81.1649462551487;
        Fri, 08 Apr 2022 17:02:31 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v4-20020a622f04000000b005057a24d478sm3641759pfv.121.2022.04.08.17.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 17:02:30 -0700 (PDT)
Date:   Sat, 9 Apr 2022 00:02:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
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
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH v3 16/23] KVM: x86/mmu: Cache the access bits of shadowed
 translations
Message-ID: <YlDNE55k9DNf/v2+@google.com>
References: <20220401175554.1931568-1-dmatlack@google.com>
 <20220401175554.1931568-17-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220401175554.1931568-17-dmatlack@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 01, 2022, David Matlack wrote:
> @@ -733,7 +733,7 @@ static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
>  static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
>  {
>  	if (!sp->role.direct)
> -		return sp->gfns[index];
> +		return sp->shadowed_translation[index].gfn;
>  
>  	return sp->gfn + (index << ((sp->role.level - 1) * PT64_LEVEL_BITS));
>  }
> @@ -741,7 +741,7 @@ static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
>  static void kvm_mmu_page_set_gfn(struct kvm_mmu_page *sp, int index, gfn_t gfn)

This should be replaced with a single helper to set the gfn+access.  Under no
circumstance should _just_ the gfn change, and that will allow us to optimize
writing the entry.  More below.

>  {
>  	if (!sp->role.direct) {
> -		sp->gfns[index] = gfn;
> +		sp->shadowed_translation[index].gfn = gfn;
>  		return;
>  	}
>  
> @@ -752,6 +752,47 @@ static void kvm_mmu_page_set_gfn(struct kvm_mmu_page *sp, int index, gfn_t gfn)
>  				   kvm_mmu_page_get_gfn(sp, index), gfn);
>  }
>  
> +static void kvm_mmu_page_set_access(struct kvm_mmu_page *sp, int index, u32 access)
> +{
> +	if (!sp->role.direct) {
> +		sp->shadowed_translation[index].access = access;
> +		return;
> +	}
> +
> +	if (WARN_ON(access != sp->role.access))
> +		pr_err_ratelimited("access mismatch under direct page %llx "

LOL, I realize this is not your code, but ratelimiting under a WARN ain't gonna
help much :-)

This also generates a warning and fails to compile with KVM_WERROR=y, though I
believe the test bots already reported that.


arch/x86/kvm/mmu/mmu.c: In function ‘kvm_mmu_page_set_access’:
include/linux/kern_levels.h:5:25: error: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘int’ [-Werror=format=]
    5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
      |                         ^~~~~~
include/linux/printk.h:418:25: note: in definition of macro ‘printk_index_wrap’
  418 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
      |                         ^~~~
include/linux/printk.h:640:17: note: in expansion of macro ‘printk’
  640 |                 printk(fmt, ##__VA_ARGS__);                             \
      |                 ^~~~~~
include/linux/printk.h:654:9: note: in expansion of macro ‘printk_ratelimited’
  654 |         printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
      |         ^~~~~~~~~~~~~~~~~~
include/linux/kern_levels.h:11:25: note: in expansion of macro ‘KERN_SOH’
   11 | #define KERN_ERR        KERN_SOH "3"    /* error conditions */
      |                         ^~~~~~~~
include/linux/printk.h:654:28: note: in expansion of macro ‘KERN_ERR’
  654 |         printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
      |                            ^~~~~~~~
arch/x86/kvm/mmu/mmu.c:763:17: note: in expansion of macro ‘pr_err_ratelimited’
  763 |                 pr_err_ratelimited("access mismatch under direct page %llx "
      |                 ^~~~~~~~~~~~~~~~~~


> +				   "(expected %llx, got %llx)\n",
> +				   kvm_mmu_page_get_gfn(sp, index),
> +				   sp->role.access, access);
> +}
> +
> +/*
> + * For leaf SPTEs, fetch the *guest* access permissions being shadowed. Note
> + * that the SPTE itself may have a more constrained access permissions that
> + * what the guest enforces. For example, a guest may create an executable
> + * huge PTE but KVM may disallow execution to mitigate iTLB multihit.
> + */
> +static u32 kvm_mmu_page_get_access(struct kvm_mmu_page *sp, int index)
> +{
> +	if (!sp->role.direct)
> +		return sp->shadowed_translation[index].access;
> +
> +	/*
> +	 * For direct MMUs (e.g. TDP or non-paging guests) there are no *guest*
> +	 * access permissions being shadowed. So we can just return ACC_ALL
> +	 * here.
> +	 *
> +	 * For indirect MMUs (shadow paging), direct shadow pages exist when KVM
> +	 * is shadowing a guest huge page with smaller pages, since the guest
> +	 * huge page is being directly mapped. In this case the guest access
> +	 * permissions being shadowed are the access permissions of the huge
> +	 * page.
> +	 *
> +	 * In both cases, sp->role.access contains exactly what we want.
> +	 */
> +	return sp->role.access;
> +}

...

> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index b6e22ba9c654..3f76f4c1ae59 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -32,6 +32,18 @@ extern bool dbg;
>  
>  typedef u64 __rcu *tdp_ptep_t;
>  
> +/*
> + * Stores the result of the guest translation being shadowed by an SPTE. KVM
> + * shadows two types of guest translations: nGPA -> GPA (shadow EPT/NPT) and
> + * GVA -> GPA (traditional shadow paging). In both cases the result of the
> + * translation is a GPA and a set of access constraints.
> + */
> +struct shadowed_translation_entry {
> +	/* Note, GFNs can have at most 64 - PAGE_SHIFT = 52 bits. */
> +	u64 gfn:52;
> +	u64 access:3;

A bitfield is completely unnecessary and generates bad code.  As is, it generates
_really_ bad code because extracting and setting requires non-standard 64-bit value
masks, multiple operations, and accesses to unaligned data.  The generated code can
be made slightly less awful by using a fully byte for access and 64 bits for GFN,
but it still sucks compared to what we can hand generate.

The other aspect of this is that retrieving the GFN is a frequent operation,
whereas the access is almost never read.  I.e. we should bias for reading the GFN
above all else.

The simple and obvious thing is to not reinvent the wheel.  GFN = (GPA >> PAGE_SHIFT),
and ignoring NX, access lives in the lower 12 bits of a PTE.  Then reading the GFN is
a simple SHR, and reading access info is a simple AND.

We might also be able to optimize FNAME(sync_page), but I don't care much about
that, it's rarely used for nested TDP.

So, keep translation_entry a gfn_t *, then do:

static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
{
	if (!sp->role.direct)
		return sp->shadowed_translation[index] >> PAGE_SHIFT;

	return sp->gfn + (index << ((sp->role.level - 1) * PT64_LEVEL_BITS));
}

static void kvm_mmu_page_set_translation(struct kvm_mmu_page *sp, int index,
					 gfn_t gfn, unsigned int access)
{
	if (!sp->role.direct) {
		sp->shadowed_translation[index] = (gfn << PAGE_SHIFT) | access;
		return;
	}

	if (WARN_ON(gfn != kvm_mmu_page_get_gfn(sp, index)))
		pr_err_ratelimited("gfn mismatch under direct page %llx "
				   "(expected %llx, got %llx)\n",
				   sp->gfn,
				   kvm_mmu_page_get_gfn(sp, index), gfn);
}

static void kvm_mmu_page_set_access(struct kvm_mmu_page *sp, int index,
				    unsigned int access)
{
	if (sp->role.direct)
		return;

	sp->shadowed_translation[index] &= PAGE_MASK;
	sp->shadowed_translation[index] |= access;
}

