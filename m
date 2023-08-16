Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3305277EB30
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 23:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346309AbjHPVA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 17:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346251AbjHPVAm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 17:00:42 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6482735
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 14:00:36 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d4ddbcbbaacso5762164276.1
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 14:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692219636; x=1692824436;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mEKCsNAdQtsP5aYZXuXtRCirnaLNuizB4J6R93XEmoU=;
        b=MD16cjoR0K1HMlo0H/xbNVvBx5YSivolQqz/f7DPhaxbb0pBoZ5vpRco9aTKjQNeOq
         Bbldshr40dC8nnhFfQQpBpWIwGc2S9sD0RKBlUwrehKJGuUi1yNZqOgoa2VjGLFGe5x8
         7YvpmqXmRe9A6FtgxQ4ZeKxUjjBPN6VwzXq/JbxANwzdHgRYRz2Vqepa3jXTb4a+ksth
         DyL3gu6oLgOTm/JrphBHF3TynJG6g3/pAim7l3pG0qRYQ9ZUPJXQPam6BLurLLhzzGEZ
         IMR5NQNVOJ7nLv8so8JlkvNC1zRHpGtYOi5uCy7FGIuAHXuprn96m627q9ZaXKqlZTjg
         Mwkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692219636; x=1692824436;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mEKCsNAdQtsP5aYZXuXtRCirnaLNuizB4J6R93XEmoU=;
        b=dRx2MY59+CEham7khVV/aENdyOTtEWkTQahkw+pbTd+4xTiXUlcwOMD4tHY8B6kzuR
         ZplyfvKWiOwAazKiyQCxANx2UkMJ6zWdaxZRVU5lNFfhGJOfUSBR34DRa7fPAoNgsCJB
         9e235ZeIhHGX+M7fOE7bAeESw8yQtDZf70c9P8G4maElM9jsyun/D+wu8n77ZIwWQypf
         Xgu8Oh+O/FJ85ciwX/EobviwsODhkxBNs8+5bUBjcE/MqxeE1mvP8mokoHMUarCjFPhE
         xOg2j7E06j8XTlq5yPnGpR25Iy48GwkDgzWdvbV9Cwzx5PPVYD44kNC33mKLCKz7jNXE
         mrOA==
X-Gm-Message-State: AOJu0Yw9eQ8gZjPQf0gBYLmRHVH2HPrf4/nTHgO3KYKuLglfLFyZUark
        ETIUYZ3ROLi73hjSD52ULC6TyBXfVLw=
X-Google-Smtp-Source: AGHT+IGtmkH20GX7f4dZ9plMJAihmnuy0mIGZ1YWKc/0uhrE3EJ6VKwRoOa33zghHSgI7WW2mrPYn78qvqU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d84c:0:b0:d62:e781:5f02 with SMTP id
 p73-20020a25d84c000000b00d62e7815f02mr44598ybg.13.1692219636034; Wed, 16 Aug
 2023 14:00:36 -0700 (PDT)
Date:   Wed, 16 Aug 2023 14:00:23 -0700
In-Reply-To: <20230719144131.29052-2-binbin.wu@linux.intel.com>
Mime-Version: 1.0
References: <20230719144131.29052-1-binbin.wu@linux.intel.com> <20230719144131.29052-2-binbin.wu@linux.intel.com>
Message-ID: <ZN0454peMb3z/0Bg@google.com>
Subject: Re: [PATCH v10 1/9] KVM: x86/mmu: Use GENMASK_ULL() to define __PT_BASE_ADDR_MASK
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@aculab.com, robert.hu@linux.intel.com,
        guang.zeng@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 19, 2023, Binbin Wu wrote:
> Use GENMASK_ULL() to define __PT_BASE_ADDR_MASK.

Using GENMASK_ULL() is an opportunistic cleanup, it is not the main purpose for
this patch.  The main purpose is to extract the maximum theoretical mask for guest
MAXPHYADDR so that it can be used to strip bits from CR3.

And rather than bury the actual use in "KVM: x86: Virtualize CR3.LAM_{U48,U57}",
I think it makes sense to do the masking in this patch.  That change only becomes
_necessary_ when LAM comes along, but it's completely valid without LAM.

That will also provide a place to explain why we decided to unconditionally mask
the pgd (it's harmless for 32-bit guests, querying 64-bit mode would be more
expensive, and for EPT the mask isn't tied to guest mode).  And it should also
explain that using PT_BASE_ADDR_MASK would actually be wrong (PAE has 64-bit
elements _except_ for CR3).

E.g. end up with a shortlog for this patch along the lines of:

  KVM: x86/mmu: Drop non-PA bits when getting GFN for guest's PGD

and write the changelog accordingly.

> No functional change intended.
> 
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
>  arch/x86/kvm/mmu/mmu_internal.h | 1 +
>  arch/x86/kvm/mmu/paging_tmpl.h  | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index d39af5639ce9..7d2105432d66 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -21,6 +21,7 @@ extern bool dbg;
>  #endif
>  
>  /* Page table builder macros common to shadow (host) PTEs and guest PTEs. */
> +#define __PT_BASE_ADDR_MASK GENMASK_ULL(51, 12)
>  #define __PT_LEVEL_SHIFT(level, bits_per_level)	\
>  	(PAGE_SHIFT + ((level) - 1) * (bits_per_level))
>  #define __PT_INDEX(address, level, bits_per_level) \
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 0662e0278e70..00c8193f5991 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -62,7 +62,7 @@
>  #endif
>  
>  /* Common logic, but per-type values.  These also need to be undefined. */
> -#define PT_BASE_ADDR_MASK	((pt_element_t)(((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1)))
> +#define PT_BASE_ADDR_MASK	((pt_element_t)__PT_BASE_ADDR_MASK)
>  #define PT_LVL_ADDR_MASK(lvl)	__PT_LVL_ADDR_MASK(PT_BASE_ADDR_MASK, lvl, PT_LEVEL_BITS)
>  #define PT_LVL_OFFSET_MASK(lvl)	__PT_LVL_OFFSET_MASK(PT_BASE_ADDR_MASK, lvl, PT_LEVEL_BITS)
>  #define PT_INDEX(addr, lvl)	__PT_INDEX(addr, lvl, PT_LEVEL_BITS)
> -- 
> 2.25.1
> 
