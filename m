Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA4D5604DF
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 17:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbiF2Prh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 11:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbiF2Prf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 11:47:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1362226560
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 08:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656517654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U8Ds3TbgTN/BrvT8Bwf0Lryi8VbFB5ioWWlf5jjfYQo=;
        b=D8c8PakH6L0C4svJ1dKfkTLCpxDoimpziNrXoY5P/0+TpdArUkUT8Q2VW3nepErlQfSuQP
        eorQRih/AMrwUr8yDjNycqLxamzQqS/ZfNmu8pRYFmFZ/yWUfSjt3n4cnBbUwQVp67SvNr
        zO3463NmHnTmHv6NBr1rBa+EEc/LQTg=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-145-fkDbHEaJN_OKb2UAs19TZQ-1; Wed, 29 Jun 2022 11:47:33 -0400
X-MC-Unique: fkDbHEaJN_OKb2UAs19TZQ-1
Received: by mail-il1-f197.google.com with SMTP id o17-20020a056e02115100b002d95d6881e4so9126442ill.19
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 08:47:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U8Ds3TbgTN/BrvT8Bwf0Lryi8VbFB5ioWWlf5jjfYQo=;
        b=hiL1mtZDpFCLBOa9C1mqTSqpW1uOVjuP7n3qR/8tGJoPaJ+Lmb9waytO0Qjg+U/PJV
         MucB4bWsL3d2aWNH4d/bAez3uyLxN0xkvYBIWOVfieI0ylEfATnf3tds5VMGI4Ddx3Nb
         eO2XqyIB4Vmg+CzAHcg4+EB8Bsbr7kuGwbo4IMCgob+zKkJNlj7VmRRdbTKLp6Og3S2J
         nbwmRD6fFSqnaB0wpuf2/GUwVM9KK7VP18Es9W6L5OKk/VOLcjvNTDuhFjSNKtoJRoI0
         OZ/IhWnj+XJSqXmEVd7T4+Zjf3DN2nDgh4ra83THnrIBkir7KBBm1ulTlNm5IxsDAq/t
         KAYA==
X-Gm-Message-State: AJIora/FuITuxGURYMQypCjyV6RBSNrHaPfQw3GVITH6axKK5QPDfuwJ
        w28bBHlFVLM88BHEZcffcMHgX2I63kzsJ+3C33j+rSvFJjRQf3tlMhBSnBzPFPwEDQ+NBgG9HdZ
        xX6I3uZz+nYas
X-Received: by 2002:a05:6602:2cce:b0:675:544e:da0b with SMTP id j14-20020a0566022cce00b00675544eda0bmr1865132iow.123.1656517652115;
        Wed, 29 Jun 2022 08:47:32 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uu/XLV/wT9doTP58QoaWMZhzxtKJWV9+WuLdJ85w0ChD+SfmtkCnXBya/7EZkV1EBDilbTMQ==
X-Received: by 2002:a05:6602:2cce:b0:675:544e:da0b with SMTP id j14-20020a0566022cce00b00675544eda0bmr1865111iow.123.1656517651766;
        Wed, 29 Jun 2022 08:47:31 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id a22-20020a027356000000b00331cfbce17csm7439570jae.100.2022.06.29.08.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 08:47:30 -0700 (PDT)
Date:   Wed, 29 Jun 2022 11:47:29 -0400
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
Message-ID: <Yrx0ETyb2kk4fO4M@xz-m1.local>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-2-peterx@redhat.com>
 <c196a140-6ee4-850c-004a-9c9d1ff1faa6@nvidia.com>
 <YrtXGf20oa5eYgIU@xz-m1.local>
 <16c181d3-09ef-ace4-c910-0a13fc245e48@nvidia.com>
 <YruBzuJf9s/Nmr6W@xz-m1.local>
 <177284f9-416d-c142-a826-e9a497751fca@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <177284f9-416d-c142-a826-e9a497751fca@nvidia.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 28, 2022 at 05:31:43PM -0700, John Hubbard wrote:
> On 6/28/22 15:33, Peter Xu wrote:
> > > The key point is the connection between "locked" and killable. If the comment
> > > explained why "locked" means "killable", that would help clear this up. The
> > > NOWAIT sentence is also confusing to me, and adding "mostly NOWAIT" does not
> > > clear it up either... :)
> > 
> > Sorry to have a comment that makes it feels confusing.  I tried to
> > explicitly put the comment to be after setting FAULT_FLAG_KILLABLE but
> > obviously I didn't do my job well..
> > 
> > Maybe that NOWAIT thing adds more complexity but not even necessary.
> > 
> > Would below one more acceptable?
> > 
> > 		/*
> > 		 * We'll only be able to respond to signals when "locked !=
> > 		 * NULL".  When with it, we'll always respond to SIGKILL
> > 		 * (as implied by FAULT_FLAG_KILLABLE above), and we'll
> > 		 * respond to non-fatal signals only if the GUP user has
> > 		 * specified FOLL_INTERRUPTIBLE.
> > 		 */
> 
> 
> It looks like part of this comment is trying to document a pre-existing
> concept, which is that faultin_page() only ever sets FAULT_FLAG_KILLABLE
> if locked != NULL.

I'd say that's not what I wanted to comment.. I wanted to express that
INTERRUPTIBLE should rely on KILLABLE, that's also why I put the comment to
be after KILLABLE, not before.  IMHO it makes sense already to have
"interruptible" only if "killable", no matter what's the pre-requisite for
KILLABLE (in this case it's having "locked" being non-null).

> The problem I am (personally) having is that I don't yet understand why
> or how those are connected: what is it about having locked non-NULL that
> means the process is killable? (Can you explain why that is?)

Firstly RETRY_KILLABLE relies on ALLOW_RETRY, because if we don't allow
retry at all it means we'll never wait in handle_mm_fault() anyway, then no
need to worry on being interrupted by any kind of signal (fatal or not).

Then if we allow retry, we need some way to know "whether mmap_sem is
released or not" during the process for the caller (because the caller
cannot see VM_FAULT_RETRY).  That's why we added "locked" parameter, so
that we can set *locked=false to tell the caller we have released mmap_sem.

I think that's why we have "locked" defined as "we allow this page fault
request to retry and wait, during wait we can always allow fatal signals".
I think that's defined throughout the gup call interfaces too, and
faultin_page() is the last step to talk to handle_mm_fault().

To make this whole picture complete, NOWAIT is another thing that relies on
ALLOW_RETRY but just to tell "oh please never release the mmap_sem at all".
For example, when we want to make sure no vma will be released after
faultin_page() returned.

> 
> If that were clear, I think I could suggest a good comment wording.

IMHO it's a little bit weird to explain "locked" here, especially after
KILLABLE is set, that's why I didn't try to mention "locked" in my 2nd
attempt.  There are some comments for "locked" above the definition of
faultin_page(), I think that'll be a nicer place to enrich explanations for
"locked", and it seems even more suitable as a separate patch?

Thanks,

-- 
Peter Xu

