Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7924C44B91E
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 23:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240938AbhKIXAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 18:00:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236847AbhKIXAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Nov 2021 18:00:35 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6126C04FD87
        for <kvm@vger.kernel.org>; Tue,  9 Nov 2021 14:54:04 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id n23so448043pgh.8
        for <kvm@vger.kernel.org>; Tue, 09 Nov 2021 14:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EWvkAGj5H4GmNZccNSp87GWIiS6lrzmxOtudbU+fbXU=;
        b=iJ3Si5HCWKW7G53uQYZ0Cmt5+Yj3saYoaVqp8Uy1aRA461ZJ2f+I7S7DLKgFVeMwbY
         CGYZmvztPi6pR6tNxPQneF2/Ffzv6wiyhbjg+swdi3uLXxIZF0tav5qg0Kxcl6QzG3OW
         QSl1Wi73EBrK2B+KcB2aBBfiptFBJgjS7Fbt1Zgc3YNhcRGpt0ITt5mqmWJma9KAKV+G
         WILVn5bANohdb6AzZPryjC/xCG7o+Z+bWuZ67Tz1JQNLfjxDfm1D74iWdW9M5JGHeqec
         7nld8MdvDdN3zMQfey94f2/pnUqwNg1FTOQF3O5KLjBK+w+Gtp+d82TIMH+auldvmACi
         eXuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EWvkAGj5H4GmNZccNSp87GWIiS6lrzmxOtudbU+fbXU=;
        b=fhRwzbQQMs9EjBd8aqKeq3Om4uptjGzzgDAfaitH/9YD5VriTZGoM4H0oyM5h6GKT4
         t48mEnjhsq1cQ763OauyPPwGJYKcHnJtgBtjH3pCUHYkw0Oko8AmO90HnzDZtYlalTXV
         mtV3qu2qcVAOF1Tcu98OMYh76uVb3p11c6f35hPT9rGfZohrZnIZMQxmKLWmBgFoO1fp
         ZPIEiEYaeW6ePoWRccytYBiZUKvDTxxfJXqCa6jgRjXaCRc0omNLQNqboozc/AGw7A0w
         sHe8lH3cRd7mgfDpXObgUen4OLXDRa1tXe5nRAxCU01AjCuwckZkpL0JYchdkxGHQ/XL
         0WDg==
X-Gm-Message-State: AOAM532uLgn4hmU0x3y2y0qT3MbEt0NiYvV18j08OF901sjlfE4/ZeVg
        v7xu4P4usSEyVq/h9Dkv3HZCHalzEKjxrA==
X-Google-Smtp-Source: ABdhPJz/Pkat5s50DEE4dJhykpWExipM5B6W1AWLMMbYjkWE1UaIiq5Lx8n7WKywK06gv4WpZW/NBg==
X-Received: by 2002:a65:5b01:: with SMTP id y1mr8764139pgq.451.1636498443869;
        Tue, 09 Nov 2021 14:54:03 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u10sm19728605pfh.49.2021.11.09.14.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 14:54:03 -0800 (PST)
Date:   Tue, 9 Nov 2021 22:54:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [kvm-unit-tests PATCH v2] x86: Look up the PTEs rather than
 assuming them
Message-ID: <YYr8CA/64vmft+TD@google.com>
References: <20211102221456.2662560-1-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102221456.2662560-1-aaronlewis@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 02, 2021, Aaron Lewis wrote:
> Rather than assuming which PTEs the SMEP test runs on, look them up to
> ensure they are correct.  If this test were to run on a different page
> table (ie: run in an L2 test) the wrong PTEs would be set.  Switch to
> looking up the PTEs to avoid this from happening.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  lib/libcflat.h |  1 +
>  lib/x86/vm.c   | 19 +++++++++++++++++++
>  lib/x86/vm.h   |  3 +++
>  x86/access.c   | 23 +++++++++++++++--------
>  x86/cstart64.S |  1 -
>  x86/flat.lds   |  1 +
>  6 files changed, 39 insertions(+), 9 deletions(-)
> 
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index 9bb7e08..c1fd31f 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -35,6 +35,7 @@
>  #define __ALIGN_MASK(x, mask)	(((x) + (mask)) & ~(mask))
>  #define __ALIGN(x, a)		__ALIGN_MASK(x, (typeof(x))(a) - 1)
>  #define ALIGN(x, a)		__ALIGN((x), (a))
> +#define ALIGN_DOWN(x, a)	__ALIGN((x) - ((a) - 1), (a))
>  #define IS_ALIGNED(x, a)	(((x) & ((typeof(x))(a) - 1)) == 0)
>  
>  #define MIN(a, b)		((a) < (b) ? (a) : (b))
> diff --git a/lib/x86/vm.c b/lib/x86/vm.c
> index 5cd2ee4..cbecddc 100644
> --- a/lib/x86/vm.c
> +++ b/lib/x86/vm.c
> @@ -281,3 +281,22 @@ void force_4k_page(void *addr)
>  	if (pte & PT_PAGE_SIZE_MASK)
>  		split_large_page(ptep, 2);
>  }
> +
> +/*
> + * Call the callback, function, on each page from va_start to va_end.
> + */
> +void walk_pte(void *va_start, void *va_end,

To align with other helpers in vm.c, "void *virt, size_t len" would be more
approriate.  That would also avoid having to document whether or not va_end is
inclusive or exclusive.

> +	      void (*function)(pteval_t *pte, void *va)){

Curly brace goes on a separate line for functions.

> +    struct pte_search search;
> +    uintptr_t curr_addr;

Maybe just curr?  To match other code and maybe squeeze the for-loop on a single
line?

	for (curr = virt; curr < end; curr = ALIGN_DOWN(curr + page_size, page_size)) {

	}

If you do split the loop, it's usually easier to read if all three parts are on
separate lines, e.g.

	for (curr = virt;
	     curr < end;
	     curr = curr = ALIGN_DOWN(curr + page_size, page_size)) {

	}

> +    u64 page_size;

Probably should be size_t.

> +    for (curr_addr = (uintptr_t)va_start; curr_addr < (uintptr_t)va_end;
> +         curr_addr = ALIGN_DOWN(curr_addr + page_size, page_size)) {


> +        search = find_pte_level(current_page_table(), (void *)curr_addr, 1);

Probably worth caching current_page_table().  On x86 with shadow paging, that'll
trigger an exit on every iteration to read CR3.

> +        assert(found_leaf_pte(search));
> +        page_size = 1ul << PGDIR_BITS(search.level);
> +
> +        function(search.pte, (void *)curr_addr);
> +    }
> +}
> diff --git a/lib/x86/vm.h b/lib/x86/vm.h
> index d9753c3..f4ac2c5 100644
> --- a/lib/x86/vm.h
> +++ b/lib/x86/vm.h
> @@ -52,4 +52,7 @@ struct vm_vcpu_info {
>          u64 cr0;
>  };
>  
> +void walk_pte(void *va_start, void *va_end,
> +	      void (*function)(pteval_t *pte, void *va));

A typedef for the function pointer would be helpful.  Maybe pte_callback_t?
And pass "struct pte_search" instead of pteval_t so that future users can get
at the level?

>  #endif
> diff --git a/x86/access.c b/x86/access.c
> index 4725bbd..17a6ef9 100644
> --- a/x86/access.c
> +++ b/x86/access.c
> @@ -201,10 +201,21 @@ static void set_cr0_wp(int wp)
>      }
>  }
>  
> +static void clear_user_mask(pteval_t *pte, void *va) {

Curly brace thing again.

> +	*pte &= ~PT_USER_MASK;
> +}
> +
> +static void set_user_mask(pteval_t *pte, void *va) {

And here.

> +	*pte |= PT_USER_MASK;
> +
> +	/* Flush to avoid spurious #PF */
> +	invlpg(va);
> +}
> +
>  static unsigned set_cr4_smep(int smep)
>  {
> +    extern char stext, etext;
>      unsigned long cr4 = shadow_cr4;
> -    extern u64 ptl2[];
>      unsigned r;
>  
>      cr4 &= ~CR4_SMEP_MASK;
