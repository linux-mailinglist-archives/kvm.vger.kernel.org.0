Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A52955EDDE
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 21:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbiF1Tl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 15:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiF1TlE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 15:41:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D2683AA64
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 12:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656444702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aM7N7xOZQpVcWKhBhevjLYz+PsasfZgbqn1eTYJzU7E=;
        b=dccDbxioVQqfFR9VnWFFn5/PTnmJxFw317J687kUmemrPiNFIIfPVCKbzHcELmDOnKKYiZ
        0SUIBSt2A8qrhRrVlZzdbzwcjDrRxUNlJspaRaU3TH1IuRD+/pktQ851TFZI9fnBvjMc4D
        WepHa/5/gFj3AWSi2ztiriQRvK2CuuE=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-77-dlU97GxdNxm_2C8lSOcFIQ-1; Tue, 28 Jun 2022 15:31:41 -0400
X-MC-Unique: dlU97GxdNxm_2C8lSOcFIQ-1
Received: by mail-il1-f197.google.com with SMTP id i2-20020a056e021d0200b002d8ff49e7c4so7831225ila.8
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 12:31:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aM7N7xOZQpVcWKhBhevjLYz+PsasfZgbqn1eTYJzU7E=;
        b=VM0RzNZErBjlfvnmrHcdjFdhnO2tW8JrxTmVQEYC3uJEM/4Ay3EXOKT62Pc/H2UfZu
         whQOkp7757FN521hRl5wg8ydde1Mu307zS0IOn5IPupRoJS+hrlflilVRpmAtoxqAiBJ
         ypkMQuY61XxynidlQH6abxHOSWk0r7yCvk5L34a6KHtr/M/YUghE+FInp2KXptHUheAj
         7NBoQJI5DTv/ZL7uFxje86K5qcqMiO75YISKbJ1omXIcvg9kCx5bpFpf21U9SJO1jD3h
         g5HWQ+58jD2Ql1aGqrwlnRUCMpD8wsgsV3zaOY96WT/uYH5wNhax5SEfMp9PwTz0dAGk
         Oj4g==
X-Gm-Message-State: AJIora9NktuutlKvCotF4S5IIs900/PJRq9ePocqw30tC6WY6rWjcuIo
        ZQhYvaoj/KTlj2KxeQiHRr38XWBeUFknC/xA7ibSeWgRzWdYExwgCqUqV6eccIxQczZZ/xbUCHK
        IQda/IyIQafON
X-Received: by 2002:a05:6638:3802:b0:32e:3d9a:9817 with SMTP id i2-20020a056638380200b0032e3d9a9817mr12530755jav.206.1656444700421;
        Tue, 28 Jun 2022 12:31:40 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1to+EXCpnTsEmC5xi0MGItOFv+6X/o+CybOlBIbsbLbyXX0AmgJOhw77pJBXL2meXzcD8YUgw==
X-Received: by 2002:a05:6638:3802:b0:32e:3d9a:9817 with SMTP id i2-20020a056638380200b0032e3d9a9817mr12530733jav.206.1656444700166;
        Tue, 28 Jun 2022 12:31:40 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id h8-20020a92d848000000b002da9f82c703sm2049757ilq.5.2022.06.28.12.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:31:39 -0700 (PDT)
Date:   Tue, 28 Jun 2022 15:31:37 -0400
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
Message-ID: <YrtXGf20oa5eYgIU@xz-m1.local>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-2-peterx@redhat.com>
 <c196a140-6ee4-850c-004a-9c9d1ff1faa6@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c196a140-6ee4-850c-004a-9c9d1ff1faa6@nvidia.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, John,

Thanks for your comments!

On Mon, Jun 27, 2022 at 07:07:28PM -0700, John Hubbard wrote:

[...]

> > @@ -2941,6 +2941,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
> >   #define FOLL_SPLIT_PMD	0x20000	/* split huge pmd before returning */
> >   #define FOLL_PIN	0x40000	/* pages must be released via unpin_user_page */
> >   #define FOLL_FAST_ONLY	0x80000	/* gup_fast: prevent fall-back to slow gup */
> > +#define FOLL_INTERRUPTIBLE  0x100000 /* allow interrupts from generic signals */
> 
> Perhaps, s/generic/non-fatal/ ?

Sure.

> > diff --git a/mm/gup.c b/mm/gup.c
> > index 551264407624..ad74b137d363 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -933,8 +933,17 @@ static int faultin_page(struct vm_area_struct *vma,
> >   		fault_flags |= FAULT_FLAG_WRITE;
> >   	if (*flags & FOLL_REMOTE)
> >   		fault_flags |= FAULT_FLAG_REMOTE;
> > -	if (locked)
> > +	if (locked) {
> >   		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
> > +		/*
> > +		 * We should only grant FAULT_FLAG_INTERRUPTIBLE when we're
> > +		 * (at least) killable.  It also mostly means we're not
> > +		 * with NOWAIT.  Otherwise ignore FOLL_INTERRUPTIBLE since
> > +		 * it won't make a lot of sense to be used alone.
> > +		 */
> 
> This comment seems a little confusing due to its location. We've just
> checked "locked", but the comment is talking about other constraints.
> 
> Not sure what to suggest. Maybe move it somewhere else?

I put it here to be after FAULT_FLAG_KILLABLE we just set.

Only if we have "locked" will we set FAULT_FLAG_KILLABLE.  That's also the
key we grant "killable" attribute to this GUP.  So I thought it'll be good
to put here because I want to have FOLL_INTERRUPTIBLE dependent on "locked"
being set.

> 
> > +		if (*flags & FOLL_INTERRUPTIBLE)
> > +			fault_flags |= FAULT_FLAG_INTERRUPTIBLE;
> > +	}
> >   	if (*flags & FOLL_NOWAIT)
> >   		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT;
> >   	if (*flags & FOLL_TRIED) {
> > @@ -1322,6 +1331,22 @@ int fixup_user_fault(struct mm_struct *mm,
> >   }
> >   EXPORT_SYMBOL_GPL(fixup_user_fault);
> > +/*
> > + * GUP always responds to fatal signals.  When FOLL_INTERRUPTIBLE is
> > + * specified, it'll also respond to generic signals.  The caller of GUP
> > + * that has FOLL_INTERRUPTIBLE should take care of the GUP interruption.
> > + */
> > +static bool gup_signal_pending(unsigned int flags)
> > +{
> > +	if (fatal_signal_pending(current))
> > +		return true;
> > +
> > +	if (!(flags & FOLL_INTERRUPTIBLE))
> > +		return false;
> > +
> > +	return signal_pending(current);
> > +}
> > +
> 
> OK.
> 
> >   /*
> >    * Please note that this function, unlike __get_user_pages will not
> >    * return 0 for nr_pages > 0 without FOLL_NOWAIT
> > @@ -1403,11 +1428,11 @@ static __always_inline long __get_user_pages_locked(struct mm_struct *mm,
> >   		 * Repeat on the address that fired VM_FAULT_RETRY
> >   		 * with both FAULT_FLAG_ALLOW_RETRY and
> >   		 * FAULT_FLAG_TRIED.  Note that GUP can be interrupted
> > -		 * by fatal signals, so we need to check it before we
> > +		 * by fatal signals of even common signals, depending on
> > +		 * the caller's request. So we need to check it before we
> >   		 * start trying again otherwise it can loop forever.
> >   		 */
> > -
> > -		if (fatal_signal_pending(current)) {
> > +		if (gup_signal_pending(flags)) {
> 
> This is new and bold. :) Signals that an application was prepared to
> handle can now cause gup to quit early. I wonder if that will break any
> use cases out there (SIGPIPE...) ?

Note: I introduced the new FOLL_INTERRUPTIBLE flag, so only if the caller
explicitly passing in that flag could there be a functional change.

IOW, no functional change intended for this single patch, not before I
start to let KVM code passing over that flag.

> 
> Generally, gup callers handle failures pretty well, so it's probably
> not too bad. But I wanted to mention the idea that handled interrupts
> might be a little surprising here.

Yes as I mentioned anyway it'll be an opt-in flag, so by default we don't
need to worry at all, IMHO, because it should really work exactly like
before, otherwise I had a bug somewhere else.. :)

Thanks,

-- 
Peter Xu

