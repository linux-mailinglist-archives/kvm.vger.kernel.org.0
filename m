Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6C3A65286
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 09:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbfGKHdq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 03:33:46 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34971 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728193AbfGKHdp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 03:33:45 -0400
Received: by mail-pg1-f195.google.com with SMTP id s27so2514258pgl.2
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 00:33:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=upOxCp123gm02y/UADhOmi9VBJg/BvipJqDODPZqH8g=;
        b=Z9lI/691yVd3YJ2RRD9Lknv0TBNFkX0qqCdX6Pt86BOutrjgsGILQn3peTHUIh0oFL
         LSxaimy20JjMRDnKFH4fa3rc3TyPZhijqpY958AoOYOB8EjLho/ESiIw0+xdxhXHxk8D
         WGIhZnjQG54/1gWxLrAHQ5Hl5C1nRjd6/BRjCjVgmuprOoiWOv94LyiYVBOkyZcVH3U8
         26o9rJSFr/Gjg1uW8YjXPieP5LCiVyPuxoFvMl1psidndaXqrwYLP9YuRhIJ1aAdV38J
         1kR5/H8W1Aaf0EVqAmHLgg8SalmevkZGdprrmdYhPgG15jldihpYNft+IogpoZ9oE98M
         J6XA==
X-Gm-Message-State: APjAAAWgOzvH/Z1PzLdY8H2sU9s58AiGyqaCdDnlKlbe8u+eZdFnPJV5
        jFwXKVs0Lt58dw+Yyi7P7EfWQg==
X-Google-Smtp-Source: APXvYqzyIDDDRdnMKLRmi1drAv8TmaZpqQTBx+gvtO7KtxtkIFD/pQCzT7yzgJGT6crrWtzn76X5vA==
X-Received: by 2002:a63:5550:: with SMTP id f16mr2972966pgm.426.1562830424963;
        Thu, 11 Jul 2019 00:33:44 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b1sm4358593pfi.91.2019.07.11.00.33.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 00:33:44 -0700 (PDT)
From:   Peter Xu <zhexu@redhat.com>
X-Google-Original-From: Peter Xu <peterx@redhat.com>
Date:   Thu, 11 Jul 2019 15:33:35 +0800
To:     Peter Xu <zhexu@redhat.com>
Cc:     kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] tscdeadline_latency: Check condition
 first before loop
Message-ID: <20190711073335.GC7847@xz-x1>
References: <20190711071756.2784-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190711071756.2784-1-peterx@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 11, 2019 at 03:17:56PM +0800, Peter Xu wrote:
> This patch fixes a tscdeadline_latency hang when specifying a very
> small breakmax value.  It's easily reproduced on my host with
> parameters like "200000 10000 10" (set breakmax to 10 TSC clocks).
> 
> The problem is test_tsc_deadline_timer() can be very slow because
> we've got printf() in there.  So when reach the main loop we might
> have already triggered the IRQ handler for multiple times and we might
> have triggered the hitmax condition which will turn IRQ off.  Then
> with no IRQ that first HLT instruction can last forever.
> 
> Fix this by simply checking the condition first in the loop.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  x86/tscdeadline_latency.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/x86/tscdeadline_latency.c b/x86/tscdeadline_latency.c
> index 0617a1b..4ee5917 100644
> --- a/x86/tscdeadline_latency.c
> +++ b/x86/tscdeadline_latency.c
> @@ -118,9 +118,9 @@ int main(int argc, char **argv)
>      test_tsc_deadline_timer();
>      irq_enable();
>  
> -    do {
> +    /* The condition might have triggered already, so check before HLT. */
> +    while (!hitmax && table_idx < size)

Hmm... I think this is not ideal too in that variables (e.g., hitmax)
could logically still change between the condition check and HLT below
(though this patch already runs nicely here).  Maybe we can simply use
"nop" or "pause" instead of "hlt".

I tested that using pause fixes the problem too.

>          asm volatile("hlt");
> -    } while (!hitmax && table_idx < size);
>  
>      for (i = 0; i < table_idx; i++) {
>          if (hitmax && i == table_idx-1)
> -- 
> 2.21.0
> 

Regards,

-- 
Peter Xu
