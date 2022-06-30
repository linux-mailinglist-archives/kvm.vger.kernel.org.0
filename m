Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1408A561C46
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 15:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235538AbiF3Nwz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 09:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235806AbiF3Nwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 09:52:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 42FFE43EC8
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 06:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656596979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kAIsAO8/q3xt7t8QmRZnKGg22p7TRVULhh/Oocusryo=;
        b=YfnsrSjAeJ44q5QhuCTU0dHtE3oLjGNW229Tn53xxhrJ53uOT1P9AyjVK3c2vT1SNrgfFO
        ohyDG2Rj4b5Ur8sk9jM0VlQ1mV0ljuTQYS0sY92dWmog6Srb1jiY5x5GYuOEqHh91pX2k6
        CoVU3LoLWZHzIWWNHaMbPYUlAFMyU6k=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55--7-Ux14nPtOsQjEtbJj5tQ-1; Thu, 30 Jun 2022 09:49:37 -0400
X-MC-Unique: -7-Ux14nPtOsQjEtbJj5tQ-1
Received: by mail-il1-f199.google.com with SMTP id b11-20020a92340b000000b002d3dbbc7b15so10553126ila.5
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 06:49:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kAIsAO8/q3xt7t8QmRZnKGg22p7TRVULhh/Oocusryo=;
        b=QTQ05C86zIrL8DBvNt8UUC21x1AYOPwBsHZp5D2nkky6DtuXNm7ZR1kcR5SuNdzZgn
         3gKhw1HHEgzjQI8ZR02FzuaedzS0nSVa1aseaavD9m+2cMlQPNlIzdICxQ41OZI/e6oN
         TD/ZNNILGl7yKVZLrW2X3OGqllxFZ8o2/PoV2QtU5+pEqjYmLKsaPoRzekhqNimHkK2M
         DBBrHjJAwd5tEzOZt6q05d/iXgI4DtB5Yc3FUr8igm4d3nR3BccrcDmE9HQ8dr6PN7X6
         cfQAybH3gA+OUgvlI2Ht1XUfSwYXEsS2dpnvpKcJCvdlV2SDxJKpD5mS6xBBjvDnTEeL
         B5qg==
X-Gm-Message-State: AJIora+4tX15oVA2wX6Ug/dY0SBWBu8p4r67mGcfajOXjxDZdH0F7SLj
        xajY2oMXQmeZs5wWTkjJFw1oRE1IiwaEGSCB1zu38rvxMPp+Bjxb3LAACmH848M6Duk/hWiNnTH
        esQH/Fr5WZfY2
X-Received: by 2002:a05:6638:264d:b0:33c:ba2d:72e6 with SMTP id n13-20020a056638264d00b0033cba2d72e6mr5277436jat.173.1656596976982;
        Thu, 30 Jun 2022 06:49:36 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tD4itwXAHEpqybOS05iyJ+cl7zul4Mwu95L2o5RF+XJkhqbNNhgR6ApJoHe/080Tk2rhwsPw==
X-Received: by 2002:a05:6638:264d:b0:33c:ba2d:72e6 with SMTP id n13-20020a056638264d00b0033cba2d72e6mr5277419jat.173.1656596976660;
        Thu, 30 Jun 2022 06:49:36 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id g18-20020a05663810f200b00339d5108b60sm8680220jae.17.2022.06.30.06.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 06:49:36 -0700 (PDT)
Date:   Thu, 30 Jun 2022 09:49:34 -0400
From:   Peter Xu <peterx@redhat.com>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 1/4] mm/gup: Add FOLL_INTERRUPTIBLE
Message-ID: <Yr2p7sR3IjiGTGd3@xz-m1.local>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-2-peterx@redhat.com>
 <c196a140-6ee4-850c-004a-9c9d1ff1faa6@nvidia.com>
 <YrtXGf20oa5eYgIU@xz-m1.local>
 <16c181d3-09ef-ace4-c910-0a13fc245e48@nvidia.com>
 <YruBzuJf9s/Nmr6W@xz-m1.local>
 <177284f9-416d-c142-a826-e9a497751fca@nvidia.com>
 <Yrx0ETyb2kk4fO4M@xz-m1.local>
 <17f9eae0-01bb-4793-201e-16ee267c07f2@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <17f9eae0-01bb-4793-201e-16ee267c07f2@nvidia.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 29, 2022 at 06:53:30PM -0700, John Hubbard wrote:
> On 6/29/22 08:47, Peter Xu wrote:
> > > It looks like part of this comment is trying to document a pre-existing
> > > concept, which is that faultin_page() only ever sets FAULT_FLAG_KILLABLE
> > > if locked != NULL.
> > 
> > I'd say that's not what I wanted to comment.. I wanted to express that
> > INTERRUPTIBLE should rely on KILLABLE, that's also why I put the comment to
> > be after KILLABLE, not before.  IMHO it makes sense already to have
> > "interruptible" only if "killable", no matter what's the pre-requisite for
> > KILLABLE (in this case it's having "locked" being non-null).
> > 
> 
> OK, I think I finally understand both the intention of the comment,
> and (thanks to your notes, below) the interaction between *locked and
> _RETRY, _KILLABLE, and _INTERRUPTIBLE. Really appreciate your leading
> me by the nose through that. The pre-existing code is abusing *locked
> a bit, by treating it as a flag when really it is a side effect of
> flags, but at least now that's clear to me.

I agree, alternatively we could have some other FOLL_ flags to represent
"locked != NULL" and do sanity check to make sure when the flag is there
locked is always set correctly.  Current code is a more "dense" way to do
this, even though it could be slightly harder to follow.

> 
> Anyway...this leads to finally getting into the comment, which I now
> think is not quite what we want: there is no need for a hierarchy of
> "_INTERRUPTIBLE should depend upon _KILLABLE". That is: even though an
> application allows a fatal signal to get through, it's not clear to me
> that that implies that non-fatal signal handling should be prevented.
> 
> The code is only vaguely enforcing such a thing, because it just so
> happens that both cases require the same basic prerequisites. So the
> code looks good, but I don't see a need to claim a hierarchy in the
> comments.
> 
> So I'd either delete the comment entirely, or go with something that is
> doesn't try to talk about hierarchy nor locked/retry either. Does this
> look reasonable to you:
> 
> 
> 	/*
> 	 * FAULT_FLAG_INTERRUPTIBLE is opt-in: kernel callers must set
> 	 * FOLL_INTERRUPTIBLE. That's because some callers may not be
> 	 * prepared to handle early exits caused by non-fatal signals.
> 	 */
> 
> ?

Looks good to me, I'd tune a bit to make it less ambiguous on a few places:

		/*
		 * FAULT_FLAG_INTERRUPTIBLE is opt-in. GUP callers must set
		 * FOLL_INTERRUPTIBLE to enable FAULT_FLAG_INTERRUPTIBLE.
		 * That's because some callers may not be prepared to
		 * handle early exits caused by non-fatal signals.
		 */

Would that be okay to you?

> 
> > > The problem I am (personally) having is that I don't yet understand why
> > > or how those are connected: what is it about having locked non-NULL that
> > > means the process is killable? (Can you explain why that is?)
> > 
> > Firstly RETRY_KILLABLE relies on ALLOW_RETRY, because if we don't allow
> > retry at all it means we'll never wait in handle_mm_fault() anyway, then no
> > need to worry on being interrupted by any kind of signal (fatal or not).
> > 
> > Then if we allow retry, we need some way to know "whether mmap_sem is
> > released or not" during the process for the caller (because the caller
> > cannot see VM_FAULT_RETRY).  That's why we added "locked" parameter, so
> > that we can set *locked=false to tell the caller we have released mmap_sem.
> > 
> > I think that's why we have "locked" defined as "we allow this page fault
> > request to retry and wait, during wait we can always allow fatal signals".
> > I think that's defined throughout the gup call interfaces too, and
> > faultin_page() is the last step to talk to handle_mm_fault().
> > 
> > To make this whole picture complete, NOWAIT is another thing that relies on
> > ALLOW_RETRY but just to tell "oh please never release the mmap_sem at all".
> > For example, when we want to make sure no vma will be released after
> > faultin_page() returned.
> > 
> 
> Again, thanks for taking the time to explain that for me. :)

My thanks for reviewing!

> 
> > > 
> > > If that were clear, I think I could suggest a good comment wording.
> > 
> > IMHO it's a little bit weird to explain "locked" here, especially after
> > KILLABLE is set, that's why I didn't try to mention "locked" in my 2nd
> > attempt.  There are some comments for "locked" above the definition of
> > faultin_page(), I think that'll be a nicer place to enrich explanations for
> > "locked", and it seems even more suitable as a separate patch?
> > 
> 
> Totally agreed. I didn't intend to ask for that kind of documentation
> here.
> 
> For that, I'm thinking a combination of cleaning up *locked a little
> bit, plus maybe some higher level notes like what you wrote above, added
> to either pin_user_pages.rst or a new get_user_pages.rst or some .rst
> anyway. Definitely a separately thing.

Sounds good.

Thanks,

-- 
Peter Xu

