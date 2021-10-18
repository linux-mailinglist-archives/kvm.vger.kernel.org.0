Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00FBF432296
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 17:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbhJRPVi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 11:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbhJRPVh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 11:21:37 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FC7C06161C
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 08:19:24 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id qe4-20020a17090b4f8400b0019f663cfcd1so14724397pjb.1
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 08:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=czal1qNOtKk9xnT6l0Db7SWWxlXhnLj4uvnaE7zg/2c=;
        b=B45Rdd0U0YbJrl+qJNpToamvdf0A7PmvmhvxlDVWVkdvgeYXpjCsNvOSipe9Xg90ZY
         sKk3b/3X6haO/TV89sKV5PabEPMpqDA2DywAPORUxZmya5muVlH1M/DyyLkmIISdhzpq
         VKtxw3+iEIDmWfj1wkZ8IkE35bhJFgf4VxiD8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=czal1qNOtKk9xnT6l0Db7SWWxlXhnLj4uvnaE7zg/2c=;
        b=ukcvq1sghd1GBV27Gebu4xojoES3UrHgN5msLN0UpUz5fevYIoiW+m2Zab1W4Hgmrs
         81upYx3GEcvK0Q/kKA0PvA7AiMT2s5bWs2KT43OoVVODQksAdefYSyfqcSJfTkF2z28m
         5qDFr3/3bUz4T4N8n9QaFHL7b8kzEzt7Xkf5YjZuz1aOH7BtBHQQ4cnHMrESnNjusDVO
         g2eJaudmWprqd8ihIzPmama+VmYsRwpv/Ai37ncpYRUJs+gXgGUI86kTYJhjeHzG/A4i
         paZEt2oqpKnv5DyLF7EPdfnPDuTDgUOs7CJJoGVrdRG9pKV5gk1ggdfWft+DFdIOVDb8
         krWA==
X-Gm-Message-State: AOAM533n2+Jz8svXzifkJnWyPlqdMtNMVQPAm7k5qyQ6t3KTWqwjbvyR
        HfMxkBQkKTU4m3gPeGBbppRXs65G1xRCYg==
X-Google-Smtp-Source: ABdhPJzqA2lBag16BYyNP2K3qHdpYZW1I1CGub5S4r+WsfHz0A3OuwwD8CVusln4nihMuiv0GPknNg==
X-Received: by 2002:a17:90a:6542:: with SMTP id f2mr43828041pjs.159.1634570364428;
        Mon, 18 Oct 2021 08:19:24 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id r130sm13487262pfc.89.2021.10.18.08.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 08:19:24 -0700 (PDT)
Date:   Mon, 18 Oct 2021 08:19:23 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Willy Tarreau <w@1wt.eu>,
        syzbot+e0de2333cbf95ea473e8@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm: allow huge kvmalloc() calls if they're accounted to
 memcg
Message-ID: <202110180817.A2C3AE34@keescook>
References: <20211016064302.165220-1-pbonzini@redhat.com>
 <CAHk-=wijGo_yd7GiTMcgR+gv0ESRykwnOn+XHCEvs3xW3x6dCg@mail.gmail.com>
 <510287f2-84ae-b1d2-13b5-22e847284588@redhat.com>
 <CAHk-=whZ+iCW5yMc3zuTpZrZzjb082xtVyzk3rV+S0SUNrtAAw@mail.gmail.com>
 <10e3d402-017e-1a0d-b6c7-112117067b03@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10e3d402-017e-1a0d-b6c7-112117067b03@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 17, 2021 at 01:17:56AM +0200, Paolo Bonzini wrote:
> On 16/10/21 20:10, Linus Torvalds wrote:
> > That said, I also do wonder if we could possibly change "kvcalloc()"
> > to avoid the warning. The reason I didn't like your patch is that
> > kvmalloc_node() only takes a "size_t", and the overflow condition
> > there is that "MAX_INT".
> > 
> > But the "kvcalloc()" case that takes a "number of elements and size"
> > should _conceptually_ warn not when the total size overflows, but when
> > either number or the element size overflows.
> 
> That makes sense, but the number could still overflow in KVM's case; the
> size is small, just 8, it's the count that's humongous.  In general,
> users of kvcalloc of kvmalloc_array *should* not be doing
> multiplications (that's the whole point of the functions), and that
> lowers a lot the risk of overflows, but the safest way is to provide
> a variant that does not warn.  See the (compile-tested only) patch
> below.
> 
> Pulling the WARN in the inline function is a bit ugly.  For kvcalloc()
> and kvmalloc_array(), one of the two is almost always constant, but
> it is unlikely that the compiler eliminates both.  The impact on a
> localyesconfig build seems to be minimal though (about 150 bytes
> larger out of 20 megabytes of code).
> 
> Paolo
> 
> ---------------- 8< -----------------
> From: Paolo Bonzini <pbonzini@redhat.com>
> Subject: [PATCH] mm: add kvmalloc variants that do not to warn
> 
> Commit 7661809d493b ("mm: don't allow oversized kvmalloc() calls")
> restricted memory allocation with 'kvmalloc()' to sizes that fit
> in an 'int', to protect against trivial integer conversion issues.
> However, the WARN triggers with KVM when it allocates ancillary page
> data, whose size essentially depends on whatever userspace has passed to
> the KVM_SET_USER_MEMORY_REGION ioctl.  The warnings are quickly found by
> syzkaller, but they can also happen with huge but real-world VMs.
> The largest allocation that KVM can do is 8 bytes per page of guest
> memory, meaning a 1 TiB memslot will cause a warning even outside fuzzing.
> In fact, Google already has VMs that create 1.5 TiB memslots (12 TiB of
> total guest memory spread across 8 virtual NUMA nodes).
> 
> For kvcalloc() and kvmalloc_array(), Linus suggested warning if either
> the number or the size are big.  However, this would only move the
> goalpost for KVM's warning without fully avoiding it.  Therefore,
> provide a "double underscore" version of kvcalloc(), kvmalloc_array()
> and kvmalloc_node() that omits the check.
> 
> Cc: Willy Tarreau <w@1wt.eu>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Ah, so memcg wasn't doing sanity checks?

Is there a cheap way to resolve the question "does this much memory
exist"? The "__" versions end up lacking context for why they're "__"
versions. I.e. do we want something more descriptive, like
__huge_kvmalloc_node() or __unbounded_kvmalloc_node()?

-Kees

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 73a52aba448f..92aba7327bd8 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -799,7 +799,15 @@ static inline int is_vmalloc_or_module_addr(const void *x)
>  }
>  #endif
> -extern void *kvmalloc_node(size_t size, gfp_t flags, int node);
> +extern void *__kvmalloc_node(size_t size, gfp_t flags, int node);
> +static inline void *kvmalloc_node(size_t size, gfp_t flags, int node)
> +{
> +	/* Don't even allow crazy sizes */
> +	if (WARN_ON(size > INT_MAX))
> +		return NULL;
> +	return __kvmalloc_node(size, flags, node);
> +}
> +
>  static inline void *kvmalloc(size_t size, gfp_t flags)
>  {
>  	return kvmalloc_node(size, flags, NUMA_NO_NODE);
> @@ -813,14 +821,31 @@ static inline void *kvzalloc(size_t size, gfp_t flags)
>  	return kvmalloc(size, flags | __GFP_ZERO);
>  }
> -static inline void *kvmalloc_array(size_t n, size_t size, gfp_t flags)
> +static inline void *__kvmalloc_array(size_t n, size_t size, gfp_t flags)
>  {
>  	size_t bytes;
>  	if (unlikely(check_mul_overflow(n, size, &bytes)))
>  		return NULL;
> -	return kvmalloc(bytes, flags);
> +	return __kvmalloc_node(bytes, flags, NUMA_NO_NODE);
> +}
> +
> +static inline void *kvmalloc_array(size_t n, size_t size, gfp_t flags)
> +{
> +	/*
> +	 * Don't allow crazy sizes here, either.  For 64-bit,
> +	 * this also lets the compiler avoid the overflow check.
> +	 */
> +	if (WARN_ON(size > INT_MAX || n > INT_MAX))
> +		return NULL;
> +
> +	return __kvmalloc_array(n, size, flags);
> +}
> +
> +static inline void *__kvcalloc(size_t n, size_t size, gfp_t flags)
> +{
> +	return __kvmalloc_array(n, size, flags | __GFP_ZERO);
>  }
>  static inline void *kvcalloc(size_t n, size_t size, gfp_t flags)
> diff --git a/mm/util.c b/mm/util.c
> index 499b6b5767ed..0406709d8097 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -558,7 +558,7 @@ EXPORT_SYMBOL(vm_mmap);
>   *
>   * Return: pointer to the allocated memory of %NULL in case of failure
>   */
> -void *kvmalloc_node(size_t size, gfp_t flags, int node)
> +void *__kvmalloc_node(size_t size, gfp_t flags, int node)
>  {
>  	gfp_t kmalloc_flags = flags;
>  	void *ret;
> @@ -593,14 +593,10 @@ void *kvmalloc_node(size_t size, gfp_t flags, int node)
>  	if (ret || size <= PAGE_SIZE)
>  		return ret;
> -	/* Don't even allow crazy sizes */
> -	if (WARN_ON_ONCE(size > INT_MAX))
> -		return NULL;
> -
>  	return __vmalloc_node(size, 1, flags, node,
>  			__builtin_return_address(0));
>  }
> -EXPORT_SYMBOL(kvmalloc_node);
> +EXPORT_SYMBOL(__kvmalloc_node);
>  /**
>   * kvfree() - Free memory.
> 
> > So I would also accept a patch that just changes how "kvcalloc()"
> > works (or how "kvmalloc_array()" works).
> > 
> > It's a bit annoying how we've ended up losing that "n/size"
> > information by the time we hit kvmalloc().
> > 
> >                 Linus
> > 
> 

-- 
Kees Cook
