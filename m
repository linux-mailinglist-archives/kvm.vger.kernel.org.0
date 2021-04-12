Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED17535D07D
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 20:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242841AbhDLSkq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 14:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237179AbhDLSkq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 14:40:46 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0F6C061574
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 11:40:28 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id q10so10082640pgj.2
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 11:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4Ofe5so/FF1HqcAtMYQtXtCYPWnn99X/hwaa9t8tWmk=;
        b=TmroJtpYDJKf/SFsdN+0q6AQ/2k2PU6lw3BYTOWtP6v0CccBc2AclU9X8lMPuQeUgP
         Z9rvatoT9OF4Dwe3VSVUBEq1WZQM0zQtj3h1iVE0SyXYIoBVWM6cmjsK9z3D8pMF513E
         K4g8MTECFjtl9b+E1Bd2pI00nEuq5ELo2Id4vb+DD70X1VHb/44MnOGfLs6gY3DVr06F
         ziEAahjw3vU25GvKITnnS0W3R3FNlILVx4onSH9lFnHFqc4079RW15REiICQOFoLpEFY
         546EZ/DnDE7CKSii9Wc8tma2RXxqXmshjOHU7AwU9zS6Rcdopahbez16ZUsBrrA421ZH
         KdLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4Ofe5so/FF1HqcAtMYQtXtCYPWnn99X/hwaa9t8tWmk=;
        b=lsGYYNLzIYoJ+UC2UnNw/R2RH8I6NZF6pesnT8ta96FDB+ax5lNmu9IqYJg94qX8Qp
         kVLGwab4zfd+Jc0Lh0KhCbJriHjHnpBdJ0w1eogFwvbcjngmIguXGq885MF4y69FAqnH
         u99ns2MKovyVRkbwovIU/e9K+TroDU3Cg97KBLURK8jYqxwgVyTMpzAkywLr48pTbzsx
         RYvP1ZBL9kigckpwcsk044l4sGh4HqRx/hAwCDBSisK2ce64ug+izUjOsmxfnhzjvRW1
         ZWsFvNYIJpE2YdbvmfFFgJBRYRK/ZT6oB5R8AcpeqfQCtfKSWXdqqRJ/Ken+9r3fCQ+n
         kdmg==
X-Gm-Message-State: AOAM532nX/wA8Yj3kEmzSAA7w/jnDLkFe4pLq/aXJaERNSOUUfunwz15
        YCE6l8DRE82gtt5ca3qvdWnVfw==
X-Google-Smtp-Source: ABdhPJwVcD7zxPOMeL0I4ZuKagbFCO7oMZG3so+yQ6qTU/4yUY0XnW3nuG7lxxE/vYI28V5Hw2lFRg==
X-Received: by 2002:a05:6a00:cc8:b029:217:4606:5952 with SMTP id b8-20020a056a000cc8b029021746065952mr26579962pfv.50.1618252827378;
        Mon, 12 Apr 2021 11:40:27 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id f187sm10410960pfa.104.2021.04.12.11.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 11:40:26 -0700 (PDT)
Date:   Mon, 12 Apr 2021 18:40:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Yang Weijiang <weijiang.yang@intel.com>
Subject: Re: [PATCH kvm-unit-tests] access: change CR0/CR4/EFER before TLB
 flushes
Message-ID: <YHSUFn9HRMrmtQvB@google.com>
References: <20210410144234.32124-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210410144234.32124-2-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 10, 2021, Paolo Bonzini wrote:
> After CR0/CR4/EFER changes a stale TLB entry can be observed, because MOV
> to CR4 only invalidates TLB entries if CR4.SMEP is changed from 0 to 1.
> 
> The TLB is already flushed in ac_set_expected_status,
> but if kvm-unit-tests is migrated to another CPU and CR4 is
> changed after the flush, a stale entry can be used.

I don't think the issue is CR0/CR4/EFER being changed after at->virt, I think
it's more precisely setting PT_USER_MASK in ptl2[2] without an INVPLG.  That
happens after CR4.SMEP is cleared, so theoretically it could cause problems even
if the TLB were flushed on _any_ CR4 write, e.g. if the CPU prefetched at->virt
after clearing CR4.SMEP and before setting ptl2[2].PT_USER_MASK.

If my guess is correct, that also means this isn't strictly a migration issue,
it's just that the window is small without migration since it would require the
CPU to grab at->virt between the beginning of ac_set_expected_status() and the
toggling of PT_USER_MASK in ac_test_do_access().

> Reported-by: Yang Weijiang <weijiang.yang@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  x86/access.c | 25 ++++++++++++-------------
>  1 file changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/x86/access.c b/x86/access.c
> index 66bd466..e5d5c00 100644
> --- a/x86/access.c
> +++ b/x86/access.c
> @@ -448,8 +448,6 @@ fault:
>  
>  static void ac_set_expected_status(ac_test_t *at)
>  {
> -    invlpg(at->virt);
> -
>      if (at->ptep)
>  	at->expected_pte = *at->ptep;
>      at->expected_pde = *at->pdep;
> @@ -561,6 +559,18 @@ static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool,
>  	root = vroot[index];
>      }
>      ac_set_expected_status(at);
> +
> +    set_cr0_wp(F(AC_CPU_CR0_WP));
> +    set_efer_nx(F(AC_CPU_EFER_NX));
> +    set_cr4_pke(F(AC_CPU_CR4_PKE));
> +    if (F(AC_CPU_CR4_PKE)) {
> +        /* WD2=AD2=1, WD1=F(AC_PKU_WD), AD1=F(AC_PKU_AD) */
> +        write_pkru(0x30 | (F(AC_PKU_WD) ? 8 : 0) |
> +                   (F(AC_PKU_AD) ? 4 : 0));
> +    }
> +
> +    set_cr4_smep(F(AC_CPU_CR4_SMEP));
> +    invlpg(at->virt);
>  }
>  
>  static void ac_test_setup_pte(ac_test_t *at, ac_pool_t *pool)
> @@ -644,17 +654,6 @@ static int ac_test_do_access(ac_test_t *at)
>      *((unsigned char *)at->phys) = 0xc3; /* ret */
>  
>      unsigned r = unique;
> -    set_cr0_wp(F(AC_CPU_CR0_WP));
> -    set_efer_nx(F(AC_CPU_EFER_NX));
> -    set_cr4_pke(F(AC_CPU_CR4_PKE));
> -    if (F(AC_CPU_CR4_PKE)) {
> -        /* WD2=AD2=1, WD1=F(AC_PKU_WD), AD1=F(AC_PKU_AD) */
> -        write_pkru(0x30 | (F(AC_PKU_WD) ? 8 : 0) |
> -                   (F(AC_PKU_AD) ? 4 : 0));
> -    }
> -
> -    set_cr4_smep(F(AC_CPU_CR4_SMEP));
> -
>      if (F(AC_ACCESS_TWICE)) {
>  	asm volatile (
>  	    "mov $fixed2, %%rsi \n\t"
> -- 
> 2.30.1
> 
