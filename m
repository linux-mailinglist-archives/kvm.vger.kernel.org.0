Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47BED39ABC
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2019 06:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbfFHEDq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 Jun 2019 00:03:46 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34831 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfFHEDq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Jun 2019 00:03:46 -0400
Received: by mail-pf1-f196.google.com with SMTP id d126so2248579pfd.2
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2019 21:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2OBpahu1EQjx5jm6yrfBCMrimRWI/S6HKVQllmyKwms=;
        b=fLmt71olPLiQkxDGGLQPrvCgYkZj1mqoJ4PBg/f8Tk54bfcewYSZXr//1iYtcLODaG
         AZveCJmWVDOJ368vf6zoV+293mE/hykWvD1eLbEkiRUKR99tKynL4WvEtWLecnVqE/K5
         NXI3dW3eaM1dHfIA1jf7g8U4v53Yd/wL4GPXA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2OBpahu1EQjx5jm6yrfBCMrimRWI/S6HKVQllmyKwms=;
        b=crRxKaKJGMNGS1eekrDgfeXQ/gtk3ocqERcCx3mzGGIs0qHtRrQ9DCX3eGJCX+zpEK
         zSTNMGaCyLoJ9CTkTdnahp1T41s849fUMThNPPWxQz/JbRRs7k/GXqGnRmd0KqDvocP7
         vRFjWk5QReUZN7iWRRZC1SFa1rnl9dYmIcVYvjGtArKUEligRnfDhxXUgg20ZRN3JUtr
         wroQPIj4402vXEIORO18Wp7/EmGZheCcD9v2KMoVQ3hE99eH264/j8qaTDREpCxM6hUU
         Yno4eB5oc2hxhqvU+P3L35VkR82IfJVxXoWMogQAVv/5zzTl78xlCm9YRimSMrvvofmY
         neMQ==
X-Gm-Message-State: APjAAAXm/+nwkxOF2DDDYL7KkKJ0zi9D2L5BghO5xr4lNoXibb4ImBRl
        2QrTLmJC/ZrtiyFe+lt9+ngsbQ==
X-Google-Smtp-Source: APXvYqyWrZDig2mXPzxoViG3lFlq1Wog/XberFCBwcpmN8vyxrNB4Pcdt7BQoh0EWedzEWISCi/OFA==
X-Received: by 2002:a63:5a4b:: with SMTP id k11mr5562393pgm.143.1559966625274;
        Fri, 07 Jun 2019 21:03:45 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id m1sm3115007pjv.22.2019.06.07.21.03.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 07 Jun 2019 21:03:44 -0700 (PDT)
Date:   Fri, 7 Jun 2019 21:03:43 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Andrey Konovalov <andreyknvl@google.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
        linux-media@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Christian Koenig <Christian.Koenig@amd.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Khalid Aziz <khalid.aziz@oracle.com>, enh <enh@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christoph Hellwig <hch@infradead.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Evgeniy Stepanov <eugenis@google.com>,
        Lee Smith <Lee.Smith@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        Jacob Bramley <Jacob.Bramley@arm.com>,
        Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Subject: Re: [PATCH v16 09/16] fs, arm64: untag user pointers in
 fs/userfaultfd.c
Message-ID: <201906072102.B58E6A609C@keescook>
References: <cover.1559580831.git.andreyknvl@google.com>
 <7d6fef00d7daf647b5069101da8cf5a202da75b0.1559580831.git.andreyknvl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d6fef00d7daf647b5069101da8cf5a202da75b0.1559580831.git.andreyknvl@google.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 03, 2019 at 06:55:11PM +0200, Andrey Konovalov wrote:
> This patch is a part of a series that extends arm64 kernel ABI to allow to
> pass tagged user pointers (with the top byte set to something else other
> than 0x00) as syscall arguments.
> 
> userfaultfd code use provided user pointers for vma lookups, which can
> only by done with untagged pointers.
> 
> Untag user pointers in validate_range().
> 
> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>

"userfaultfd: untag user pointers"

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  fs/userfaultfd.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index 3b30301c90ec..24d68c3b5ee2 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -1263,21 +1263,23 @@ static __always_inline void wake_userfault(struct userfaultfd_ctx *ctx,
>  }
>  
>  static __always_inline int validate_range(struct mm_struct *mm,
> -					  __u64 start, __u64 len)
> +					  __u64 *start, __u64 len)
>  {
>  	__u64 task_size = mm->task_size;
>  
> -	if (start & ~PAGE_MASK)
> +	*start = untagged_addr(*start);
> +
> +	if (*start & ~PAGE_MASK)
>  		return -EINVAL;
>  	if (len & ~PAGE_MASK)
>  		return -EINVAL;
>  	if (!len)
>  		return -EINVAL;
> -	if (start < mmap_min_addr)
> +	if (*start < mmap_min_addr)
>  		return -EINVAL;
> -	if (start >= task_size)
> +	if (*start >= task_size)
>  		return -EINVAL;
> -	if (len > task_size - start)
> +	if (len > task_size - *start)
>  		return -EINVAL;
>  	return 0;
>  }
> @@ -1327,7 +1329,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
>  		goto out;
>  	}
>  
> -	ret = validate_range(mm, uffdio_register.range.start,
> +	ret = validate_range(mm, &uffdio_register.range.start,
>  			     uffdio_register.range.len);
>  	if (ret)
>  		goto out;
> @@ -1516,7 +1518,7 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
>  	if (copy_from_user(&uffdio_unregister, buf, sizeof(uffdio_unregister)))
>  		goto out;
>  
> -	ret = validate_range(mm, uffdio_unregister.start,
> +	ret = validate_range(mm, &uffdio_unregister.start,
>  			     uffdio_unregister.len);
>  	if (ret)
>  		goto out;
> @@ -1667,7 +1669,7 @@ static int userfaultfd_wake(struct userfaultfd_ctx *ctx,
>  	if (copy_from_user(&uffdio_wake, buf, sizeof(uffdio_wake)))
>  		goto out;
>  
> -	ret = validate_range(ctx->mm, uffdio_wake.start, uffdio_wake.len);
> +	ret = validate_range(ctx->mm, &uffdio_wake.start, uffdio_wake.len);
>  	if (ret)
>  		goto out;
>  
> @@ -1707,7 +1709,7 @@ static int userfaultfd_copy(struct userfaultfd_ctx *ctx,
>  			   sizeof(uffdio_copy)-sizeof(__s64)))
>  		goto out;
>  
> -	ret = validate_range(ctx->mm, uffdio_copy.dst, uffdio_copy.len);
> +	ret = validate_range(ctx->mm, &uffdio_copy.dst, uffdio_copy.len);
>  	if (ret)
>  		goto out;
>  	/*
> @@ -1763,7 +1765,7 @@ static int userfaultfd_zeropage(struct userfaultfd_ctx *ctx,
>  			   sizeof(uffdio_zeropage)-sizeof(__s64)))
>  		goto out;
>  
> -	ret = validate_range(ctx->mm, uffdio_zeropage.range.start,
> +	ret = validate_range(ctx->mm, &uffdio_zeropage.range.start,
>  			     uffdio_zeropage.range.len);
>  	if (ret)
>  		goto out;
> -- 
> 2.22.0.rc1.311.g5d7573a151-goog
> 

-- 
Kees Cook
