Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8995643224E
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 17:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbhJRPMj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 11:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbhJRPMO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 11:12:14 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DBCC061769
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 08:10:01 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id c29so14943491pfp.2
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 08:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7SQVc3XGar2veUYFqfy1yTOkYOpuBUWxEVpjFYKTxRc=;
        b=ZNn/ptCtas1mjTvGhvKxYKuEt8b+6sU57LzMgeEjbiLRpiI6Cr0dLT/KOsePcjVD0G
         a1U14//mjKeFDTufq1b9GGdYrJiSx+TSwKupby2HSpX+HkRts2zDAqa4bG533G7d36m4
         RfFwgo6RwbESGVPkx6EiftVuu/whiS1fftuO4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7SQVc3XGar2veUYFqfy1yTOkYOpuBUWxEVpjFYKTxRc=;
        b=oRZ+C7hOnHxDXdVPZ+WeeBVvjqedyzVnKd/rn8TjdfRVPBqWQCg1FdyEpygQEhgc1o
         n3/sZa7dLHT3FoC6Lmqi/ToSUEV+q1a6hpkRIT6ncyXbyH86IGmAPz0GeJya3aVbiLkY
         MlMvX35/+L1mUh+HO+UAFJGuyQAnv5SPIVfuNAKhfD4YWBZOCVuH62Y7Xd1MSizCxjix
         tJ0WyLVgwQicX+Hu8L4Es3CUd0/hj44HTSR5WObOGdnPk2JrbuZ1OXQi73OaXoiv3yjL
         Qflze3gGbt5lYcn4Gxzkywz3FAsf0Pp0ul5bfSlzv29tLpr6bnX5bjRCn4vPIxM7sXqF
         eYbw==
X-Gm-Message-State: AOAM531PmkTct8ZAh2eA6m+uJcy9Pj8eufBIaA6sVrwqlLxfZkq15WZE
        ncEJrOxQZuCkpP6WD+jrrv13YQ==
X-Google-Smtp-Source: ABdhPJzoyK7RvflmQ+QSU83OWv9SX8/m+Djcb/uQZFAAsFqxaYAFYtzIE6wJc6P2mrSKwTFFKJocxw==
X-Received: by 2002:a05:6a00:1901:b0:44b:e041:f07f with SMTP id y1-20020a056a00190100b0044be041f07fmr29295794pfi.52.1634569801041;
        Mon, 18 Oct 2021 08:10:01 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id f11sm13169823pgv.76.2021.10.18.08.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 08:10:00 -0700 (PDT)
Date:   Mon, 18 Oct 2021 08:09:59 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com,
        Willy Tarreau <w@1wt.eu>,
        syzbot+e0de2333cbf95ea473e8@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm: allow huge kvmalloc() calls if they're accounted to
 memcg
Message-ID: <202110180809.66AE562E97@keescook>
References: <20211016065130.166128-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211016065130.166128-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 16, 2021 at 02:51:30AM -0400, Paolo Bonzini wrote:
> Commit 7661809d493b ("mm: don't allow oversized kvmalloc() calls")
> restricted memory allocation with 'kvmalloc()' to sizes that fit
> in an 'int', to protect against trivial integer conversion issues.
> 
> However, the WARN triggers with KVM, when it allocates ancillary page
> data whose size essentially depends on whatever userspace has passed to
> the KVM_SET_USER_MEMORY_REGION ioctl.  The warnings are easily raised by
> syzkaller, but the largest allocation that KVM can do is 8 bytes per page
> of guest memory; therefore, a 1 TiB memslot will cause a warning even
> outside fuzzing, and those allocations are known to happen in the wild.
> Google for example already has VMs that create 1.5tb memslots (12tb of
> total guest memory spread across 8 virtual NUMA nodes).
> 
> Use memcg accounting as evidence that the crazy large allocations are
> expected---in which case, it is indeed a good idea to have them
> properly accounted---and exempt them from the warning.

Will memcg always have a "sane" upper bound? If so, yeah, this seems a
better solution than dropping the WARN completely. :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> 
> Cc: Willy Tarreau <w@1wt.eu>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Reported-by: syzbot+e0de2333cbf95ea473e8@syzkaller.appspotmail.com
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> 	Linus, what do you think of this?  It is a bit of a hack,
> 	but the reasoning in the commit message does make at least
> 	some sense.
> 
> 	The alternative would be to just use __vmalloc in KVM, and add
> 	__vcalloc too.	The two underscores would suggest that something
> 	"different" is going on, but I wonder what you prefer between
> 	this and having a __vcalloc with 2-3 uses in the whole source.
> 
>  mm/util.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/util.c b/mm/util.c
> index 499b6b5767ed..31fca4a999c6 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -593,8 +593,12 @@ void *kvmalloc_node(size_t size, gfp_t flags, int node)
>  	if (ret || size <= PAGE_SIZE)
>  		return ret;
>  
> -	/* Don't even allow crazy sizes */
> -	if (WARN_ON_ONCE(size > INT_MAX))
> +	/*
> +	 * Don't even allow crazy sizes unless memcg accounting is
> +	 * request.  We take that as a sign that huge allocations
> +	 * are indeed expected.
> +	 */
> +	if (likely(!(flags & __GFP_ACCOUNT)) && WARN_ON_ONCE(size > INT_MAX))
>  		return NULL;
>  
>  	return __vmalloc_node(size, 1, flags, node,
> -- 
> 2.27.0
> 

-- 
Kees Cook
