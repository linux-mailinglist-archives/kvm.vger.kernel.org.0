Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E50BF8AA5D
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 00:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbfHLWYW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 18:24:22 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:33867 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfHLWYV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 18:24:21 -0400
Received: by mail-ot1-f68.google.com with SMTP id n5so165178522otk.1
        for <kvm@vger.kernel.org>; Mon, 12 Aug 2019 15:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FD1szyxYIZRFxBXLh6OsEaGEchmLGdiUNjpQeITxC5M=;
        b=x0gRCKA2MXc6jwpdoG/TD2IO5bNpn+KvoJBHqbuTFvYsphI9ZOW3AsLFTvGTGaBcYf
         RXeEQjAS7obV+BaMTdZMP8wgP9cCdfivoRhOSSJlo1Z5CZcFaW9WRf5Nbz2vuEwz9BHO
         CTPVnpm6p1Svao0hA1gPSbLM8aO2CgSELXaqp4B3NEVb2TYyFBGnZyWvtKuElCmEg9Y9
         2684+SERAdl0y8BhILj5oAWGrfdVI2IqGuBac1Xq6S8MrelSVVIf8h5B+ZX8xtZ+Y4j8
         0cIiaBzKvNv833gjthAES+x42kYGE7WEjgb+I7K5IyHz3cyOXJYFYRXUt4EGdLKdJPuu
         QMeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FD1szyxYIZRFxBXLh6OsEaGEchmLGdiUNjpQeITxC5M=;
        b=B4cJdwjDDAIFGTudfqE+StwHHjkTnwj7SBkFr4+b42WrF6D0nVXwYS3Rj9wcmUaCJw
         OYSWb//36urpOpD/iotiglH0yP467DxFRvI0kA2UM9AcNrkjuPYx28F/GlfMDx6w4bAt
         Ad2+cfiSR9Wdl5ZfYmgcQgAsfQ3Ed099inatT/xSmduxyA0oU4HwtsHzo/Z/kiRVOpRj
         QZOBXA1kehhZaBLhtB0n8KglqJDBQmU00QpBwa0nQO9h1eWlCSimJlkNxWlm0FGX8PeQ
         yc9vrSI1Zg0OKIwt4NwPrIxHt7bFNyZd5wA1WxDtShAyorAFeXptTkNVyiLp4pdiH/d/
         TqSw==
X-Gm-Message-State: APjAAAU8JuJo9DY+shBLvD8l9IzMg80cRpajGAWUG/obQagSdBOjKkkl
        3fAMHefoiV0hhNw5lwjOb5e7wSXaWdfFMl9c5Sfwtw==
X-Google-Smtp-Source: APXvYqyTjBOGgU/+dTdLpyuKWrW67Z3rfVh/4MI7eXiUUJ6wgK016/SnhTUKO42pQZXtyuBZxQKUvdSL/kBmh0RvuUc=
X-Received: by 2002:aca:be43:: with SMTP id o64mr912541oif.149.1565648660956;
 Mon, 12 Aug 2019 15:24:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190812213158.22097.30576.stgit@localhost.localdomain> <20190812213324.22097.30886.stgit@localhost.localdomain>
In-Reply-To: <20190812213324.22097.30886.stgit@localhost.localdomain>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 12 Aug 2019 15:24:09 -0700
Message-ID: <CAPcyv4jEvPL3qQffDsJxKxkCJLo19FN=gd4+LtZ1FnARCr5wBw@mail.gmail.com>
Subject: Re: [PATCH v5 1/6] mm: Adjust shuffle code to allow for future coalescing
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     nitesh@redhat.com, KVM list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        virtio-dev@lists.oasis-open.org,
        Oscar Salvador <osalvador@suse.de>, yang.zhang.wz@gmail.com,
        Pankaj Gupta <pagupta@redhat.com>,
        Rik van Riel <riel@surriel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        lcapitulino@redhat.com, "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 12, 2019 at 2:33 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>
> This patch is meant to move the head/tail adding logic out of the shuffle

s/This patch is meant to move/Move/

> code and into the __free_one_page function since ultimately that is where
> it is really needed anyway. By doing this we should be able to reduce the
> overhead

Is the overhead benefit observable? I would expect the overhead of
get_random_u64() dominates.

> and can consolidate all of the list addition bits in one spot.

This sounds the better argument.

[..]
> diff --git a/mm/shuffle.h b/mm/shuffle.h
> index 777a257a0d2f..add763cc0995 100644
> --- a/mm/shuffle.h
> +++ b/mm/shuffle.h
> @@ -3,6 +3,7 @@
>  #ifndef _MM_SHUFFLE_H
>  #define _MM_SHUFFLE_H
>  #include <linux/jump_label.h>
> +#include <linux/random.h>
>
>  /*
>   * SHUFFLE_ENABLE is called from the command line enabling path, or by
> @@ -43,6 +44,32 @@ static inline bool is_shuffle_order(int order)
>                 return false;
>         return order >= SHUFFLE_ORDER;
>  }
> +
> +static inline bool shuffle_add_to_tail(void)
> +{
> +       static u64 rand;
> +       static u8 rand_bits;
> +       u64 rand_old;
> +
> +       /*
> +        * The lack of locking is deliberate. If 2 threads race to
> +        * update the rand state it just adds to the entropy.
> +        */
> +       if (rand_bits-- == 0) {
> +               rand_bits = 64;
> +               rand = get_random_u64();
> +       }
> +
> +       /*
> +        * Test highest order bit while shifting our random value. This
> +        * should result in us testing for the carry flag following the
> +        * shift.
> +        */
> +       rand_old = rand;
> +       rand <<= 1;
> +
> +       return rand < rand_old;
> +}

This function seems too involved to be a static inline and I believe
each compilation unit that might call this routine gets it's own copy
of 'rand' and 'rand_bits' when the original expectation is that they
are global. How about leave this bit to mm/shuffle.c and rename it
coin_flip(), or something more generic, since it does not
'add_to_tail'? The 'add_to_tail' action is something the caller
decides.
