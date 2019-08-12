Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F01C28AAB8
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 00:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfHLWtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 18:49:42 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:37125 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbfHLWtm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 18:49:42 -0400
Received: by mail-ot1-f65.google.com with SMTP id f17so29921282otq.4;
        Mon, 12 Aug 2019 15:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nHhlgYEkAMLzpeQp5iTnO0Cc38tccOHo+I1ij6totIw=;
        b=e92k/bnvuAJZMf7wPi0zDqgrta8CwAOps3mGD4JUI60fT4hHB9sJp+uFferOHrL/dE
         Qkj3IBwj9c3M+Z9goPvXZ3okY116OnbfFsy262hBGLKLVRlcFMtCToIzXLkcF3oW4NEU
         K+W1kxnyrB7kVw4a6YVD369pGDT360Oq2BdtEbneY78ShmHCG+ASHvUCcJ+WxV9kMID/
         vlUqnO9TDNQj2N17N8erBgYGv4ejoo28DxbFZVZi3tIil/Rr8UFv3xFXNJ5y9lc+WESc
         fg4uhV9qoqTJH6sJrG75GadkGvncgvxVl2k44kY13A2v1MwxFmUfFqx8BQCSacrgMjAh
         n3dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nHhlgYEkAMLzpeQp5iTnO0Cc38tccOHo+I1ij6totIw=;
        b=Z+5Nvhoszg1L18O1m/5RLK8an25HMV5o8Tv+5pPqirkMwETOscNoC3Fr9D6Yp1dXFC
         Q3XNLOxjlfLwPHV7o5zJx9+J++NTiofaQEwPlq022kqGu1TjOrkmAeRojHDa3sDyb75m
         Tr7aIXd7GO8XTe2en8M4bqzodNmNx5tdx54o6C0fQC4F4eXQzAEK1/waqyV3sZdiLXSi
         AW9r4+Fot4vPzlr+UFLeUdpv/Y7njTKKFPQA8dC2sKIZyUHeSsnxp/XcQ4HJ/F1nV/eu
         SjUXGBURRTKJG9L8wxhEz9Ox3754YcI6OKNgFbIQ09WPoNaJ2vytheL70EFjV4OA85Gc
         Fpug==
X-Gm-Message-State: APjAAAXRL59gabIJ8XjRujLg6JEWY8iC83Y+UGsH0yRtxDYuGo1Rt5De
        7Lj2Nhcg1LE9uKd9jzL6bZCzVMUrlUtKODMcj54=
X-Google-Smtp-Source: APXvYqwZ7pS16vyR1zCPDVdm0U9hbTlyCWAkwYgnJ/4qGi+bBVtiNKv9ffJ5GtcXg9KfgBsSpyc+QqxKgl44sM7rMhI=
X-Received: by 2002:a5e:8c11:: with SMTP id n17mr142032ioj.64.1565650180999;
 Mon, 12 Aug 2019 15:49:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190812213158.22097.30576.stgit@localhost.localdomain>
 <20190812213324.22097.30886.stgit@localhost.localdomain> <CAPcyv4jEvPL3qQffDsJxKxkCJLo19FN=gd4+LtZ1FnARCr5wBw@mail.gmail.com>
In-Reply-To: <CAPcyv4jEvPL3qQffDsJxKxkCJLo19FN=gd4+LtZ1FnARCr5wBw@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 12 Aug 2019 15:49:30 -0700
Message-ID: <CAKgT0UeHAXCM+aXL=SYXqVym=Vy3av21Vc6VY-rWQYE13-MNKg@mail.gmail.com>
Subject: Re: [PATCH v5 1/6] mm: Adjust shuffle code to allow for future coalescing
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        virtio-dev@lists.oasis-open.org,
        Oscar Salvador <osalvador@suse.de>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
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

On Mon, Aug 12, 2019 at 3:24 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Mon, Aug 12, 2019 at 2:33 PM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> >
> > This patch is meant to move the head/tail adding logic out of the shuffle
>
> s/This patch is meant to move/Move/

I'll update that on next submission.

> > code and into the __free_one_page function since ultimately that is where
> > it is really needed anyway. By doing this we should be able to reduce the
> > overhead
>
> Is the overhead benefit observable? I would expect the overhead of
> get_random_u64() dominates.
>
> > and can consolidate all of the list addition bits in one spot.
>
> This sounds the better argument.

Actually the overhead is the bit where we have to setup the arguments
and call the function. There is only one spot where this function is
ever called and that is in __free_one_page.

> [..]
> > diff --git a/mm/shuffle.h b/mm/shuffle.h
> > index 777a257a0d2f..add763cc0995 100644
> > --- a/mm/shuffle.h
> > +++ b/mm/shuffle.h
> > @@ -3,6 +3,7 @@
> >  #ifndef _MM_SHUFFLE_H
> >  #define _MM_SHUFFLE_H
> >  #include <linux/jump_label.h>
> > +#include <linux/random.h>
> >
> >  /*
> >   * SHUFFLE_ENABLE is called from the command line enabling path, or by
> > @@ -43,6 +44,32 @@ static inline bool is_shuffle_order(int order)
> >                 return false;
> >         return order >= SHUFFLE_ORDER;
> >  }
> > +
> > +static inline bool shuffle_add_to_tail(void)
> > +{
> > +       static u64 rand;
> > +       static u8 rand_bits;
> > +       u64 rand_old;
> > +
> > +       /*
> > +        * The lack of locking is deliberate. If 2 threads race to
> > +        * update the rand state it just adds to the entropy.
> > +        */
> > +       if (rand_bits-- == 0) {
> > +               rand_bits = 64;
> > +               rand = get_random_u64();
> > +       }
> > +
> > +       /*
> > +        * Test highest order bit while shifting our random value. This
> > +        * should result in us testing for the carry flag following the
> > +        * shift.
> > +        */
> > +       rand_old = rand;
> > +       rand <<= 1;
> > +
> > +       return rand < rand_old;
> > +}
>
> This function seems too involved to be a static inline and I believe
> each compilation unit that might call this routine gets it's own copy
> of 'rand' and 'rand_bits' when the original expectation is that they
> are global. How about leave this bit to mm/shuffle.c and rename it
> coin_flip(), or something more generic, since it does not
> 'add_to_tail'? The 'add_to_tail' action is something the caller
> decides.

The thing is there is only one caller to this function, and that is
__free_one_page. That is why I made it a static inline since that way
we can avoid having to call this as a function at all and can just
inline the code into __free_one_page.

As far as making this more generic I guess I can look into that. Maybe
I will look at trying to implement something like get_random_bool()
and then just do a macro to point to that. One other things that
occurs to me now that I am looking over the code is that I am not sure
the original or this modified version actually provide all that much
randomness if multiple threads have access to it at the same time. If
rand_bits races past the 0 you can end up getting streaks of 0s for
256+ bits.
