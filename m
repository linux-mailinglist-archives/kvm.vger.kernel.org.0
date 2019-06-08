Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35CEA39A65
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2019 05:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730740AbfFHDtI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 23:49:08 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36747 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730353AbfFHDtH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 23:49:07 -0400
Received: by mail-pf1-f196.google.com with SMTP id u22so2232972pfm.3
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2019 20:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5iFtOAxSpyEwrNGKsnJSAuPHnmB6sZsxY7o3VcURDbs=;
        b=H67pCnfy+inYwtx7CHiN5h4f1U/pgcnleLkOrUnW4+QdjbqfAr9cQdSkm3W08ImQFl
         MKpSL+Xxt/SE/t0ZUnbh42ewav3Rgd/mWolnnSDbYBR+Ld/cLmR9BtGJ7sEbWVa+oHPR
         1hTMHtgCUOMHLDYeeHgvIO8Lm0UyCIchcEask=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5iFtOAxSpyEwrNGKsnJSAuPHnmB6sZsxY7o3VcURDbs=;
        b=QaiYhmOUGjFggjwCxicdcK9gykYZLwuLM9L9IdomRo6sG2SgyXXN09uBIABcTPu0QZ
         laaTNXtYYYJj6OfaU+qluMOYpYFHPYQ87omqaQUgfd/Ksu6B/2BNkrBVPxKstSQ7NliS
         Oy+BkN7/ju9cEy4hMdnnIXCJEIl4M6fSqmXRCk1T4KQXZxOgV2aRAmXsfOjLB8MTbntx
         0O7+j6l9GE0EHXjE6my0vKP41sfBuHLdQ4349oX64l7ypAm6jNb5XZ53jovlIS2uERDk
         jJNWlJCv2rkc+4KCE38ghVclVZnUgb2o2GiuQZ24H8InRGL65WTsHoqRnu8fGzp2Hn6H
         hV6g==
X-Gm-Message-State: APjAAAWFj6I2xChU0LGbQ3mbq4Xk2rtfXdLMrgwAf7GCrYDjrU2Er3Rx
        DmtR7lNqHQFKykF+HKcTWiXyiA==
X-Google-Smtp-Source: APXvYqyjpXWbpUp/M/TNwB1KLrsvdqCimHBytjvPEw0jUB6ar1HA2nI5YlI2gocy+KHTqRtIofNEIA==
X-Received: by 2002:a63:5247:: with SMTP id s7mr5637363pgl.29.1559965746908;
        Fri, 07 Jun 2019 20:49:06 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y12sm3218417pgi.10.2019.06.07.20.49.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 07 Jun 2019 20:49:06 -0700 (PDT)
Date:   Fri, 7 Jun 2019 20:49:05 -0700
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
Subject: Re: [PATCH v16 04/16] mm: untag user pointers in do_pages_move
Message-ID: <201906072049.C71D545@keescook>
References: <cover.1559580831.git.andreyknvl@google.com>
 <e410843d00a4ecd7e525a7a949e605ffc6c394c4.1559580831.git.andreyknvl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e410843d00a4ecd7e525a7a949e605ffc6c394c4.1559580831.git.andreyknvl@google.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 03, 2019 at 06:55:06PM +0200, Andrey Konovalov wrote:
> This patch is a part of a series that extends arm64 kernel ABI to allow to
> pass tagged user pointers (with the top byte set to something else other
> than 0x00) as syscall arguments.
> 
> do_pages_move() is used in the implementation of the move_pages syscall.
> 
> Untag user pointers in this function.
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  mm/migrate.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index f2ecc2855a12..3930bb6fa656 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1617,6 +1617,7 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
>  		if (get_user(node, nodes + i))
>  			goto out_flush;
>  		addr = (unsigned long)p;
> +		addr = untagged_addr(addr);
>  
>  		err = -ENODEV;
>  		if (node < 0 || node >= MAX_NUMNODES)
> -- 
> 2.22.0.rc1.311.g5d7573a151-goog
> 

-- 
Kees Cook
