Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239A75EF882
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 17:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235853AbiI2PS7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 11:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235858AbiI2PSz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 11:18:55 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F80114F8F5
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 08:18:53 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id n7so1550337plp.1
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 08:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Ga7Wq6aD2ebMvSDNvAGT7MduWJCGTvC2mzBwQ2LHRCU=;
        b=UgD3Cw43X1U5TDmVbCANXUxQimTv+mdSmfQ0CuqGXddG15c7j5qAp8Dmp3aFoH5eyz
         3sh5foOmN0YCP1FzXrjOw6/CZt7cTSSE1YgUxnGLccS5gJYPw63aW4eES+BfivBlQaQz
         Tvqy0fist8KREDnDjhXNxAnOx0CQKyt49tmHj+zxsUPraIooOmqp0o7JuawPf48eaGRd
         vSN8iLvL9YCv7MXfNXNPbkPZp1glTmA5k8YvBYNKhBqde/uqj0Pp4xFv5JziD+8V4iu9
         y8vyMZA2hto+sMTVkWoTtKMTrXqhwSyJct87hM8LHqL4b+LX0mF9qL3/nXzN3UBZgxKS
         500g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Ga7Wq6aD2ebMvSDNvAGT7MduWJCGTvC2mzBwQ2LHRCU=;
        b=v/epQVOpw/cdsH8jtgaDQYmCi6VCkimh7pPvYylJ3FDbwgW1wSVOwHtnIcqraDCzpL
         l8r8lP6qir8FE4QY/Gdqbf5ckJyzjX8yq8jYQx4D5rgvvsyv2GEbhijBKX2PputklMVq
         a73w0MOpWavfUSNwlqfs3jXIxhe4IeweISHqe309SQ1AtJAvN/x8JAlcLIK+C3fmi+Rv
         SRnrjvumx1ZNXv9Y/MJc0uPx6RiQ+YZyu5uA8+Xgkuf17WrKxIb4nS6mWDoHkBwsrszL
         7uGGc6++NqLQBBh/uUgMYRYlnZNnHSdt7NExsFf7i/yKJz1InixmrmYUkB0UGtcf85S1
         HShg==
X-Gm-Message-State: ACrzQf3lx5NiegV+jDck9iM/n1NM/h/Px2+g8vbyy218FyJ90o1NbDjJ
        Ivs6RUBFIr5qDCVS8aub0oRtVA==
X-Google-Smtp-Source: AMsMyM776dZC7Zy6WEQgOE8NUXltB/XDmd9NhL7eTPiJ3NIsvSIt/1hmAh0SJLF5hq3k0kl7GWaQ0Q==
X-Received: by 2002:a17:902:848e:b0:178:2773:12d0 with SMTP id c14-20020a170902848e00b00178277312d0mr3799891plo.166.1664464732847;
        Thu, 29 Sep 2022 08:18:52 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t18-20020a17090340d200b0017315b11bb8sm5981283pld.213.2022.09.29.08.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 08:18:50 -0700 (PDT)
Date:   Thu, 29 Sep 2022 15:18:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
Subject: Re: [RFC PATCH 0/9] kvm: implement atomic memslot updates
Message-ID: <YzW3VxqZTb2hnXCy@google.com>
References: <111a46c1-7082-62e3-4f3a-860a95cd560a@redhat.com>
 <14d5b8f2-7cb6-ce24-c7a7-32aa9117c953@redhat.com>
 <YzIZhn47brWBfQah@google.com>
 <3b04db9d-0177-7e6e-a54c-a28ada8b1d36@redhat.com>
 <YzMdjSkKaJ8HyWXh@google.com>
 <dd6db8c9-80b1-b6c5-29b8-5eced48f1303@redhat.com>
 <YzRvMZDoukMbeaxR@google.com>
 <8534dfe4-bc71-2c14-b268-e610a3111d14@redhat.com>
 <YzSxhHzgNKHL3Cvm@google.com>
 <637e7ef3-e204-52fc-a4ff-1f0df5227a3e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <637e7ef3-e204-52fc-a4ff-1f0df5227a3e@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 29, 2022, Emanuele Giuseppe Esposito wrote:
> 
> Am 28/09/2022 um 22:41 schrieb Sean Christopherson:
> > Beyond that, there's no explanation of why this exact API is necessary, i.e. there
> > are no requirements given.
> > 
> >   - Why can't this be solved in userspace?
> 
> Because this would provide the "feature" only to QEMU, leaving each
> other hypervisor to implement its own.

But there's no evidence that any other VMM actually needs this feature.

> >   - When is KVM required to invalidate and flush?  E.g. if a memslot is deleted
> >     and recreated with a different HVA, how does KVM ensure that there are no
> >     outstanding references to the old HVA without introducing non-determinstic
> >     behavior.  The current API works by forcing userspace to fully delete the
> >     memslot, i.e. KVM can ensure all references are gone in all TLBs before
> >     allowing userspace to create new, conflicting entries.  I don't see how this
> >     can work with batched updates.  The update needs to be "atomic", i.e. vCPUs
> >     must never see an invalid/deleted memslot, but if the memslot is writable,
> >     how does KVM prevent some writes from hitting the old HVA and some from hitting
> >     the new HVA without a quiescent period?
> 
> Sorry this might be my fault in providing definitions, even though I
> think I made plenty of examples. Delete/move operations are not really
> "atomic" in the sense that the slot disappears immediately.
> 
> The slot(s) is/are first "atomically" invalidated, allowing the guest to
> retry the page fault

I completely forgot that KVM x86 now retries on KVM_MEMSLOT_INVALID[*].  That is
somewhat arbitrary behavior, e.g. if x86 didn't do MMIO SPTE caching it wouldn't
be "necessary" and x86 would still treat INVALID as MMIO.  It's also x86 specific,
no other architecture retries on invalid memslots, i.e. relying on that behavior
to provide "atomicity" won't work without updating all other architectures.

That's obviously doable, but since these updates aren't actually atomic, I don't
see any meaningful benefit over adding e.g. KVM_MEM_DISABLED.

[*] e0c378684b65 ("KVM: x86/mmu: Retry page faults that hit an invalid memslot")

> >   - If a memslot is truncated while dirty logging is enabled, what happens to
> >     the bitmap?  Is it preserved?  Dropped?
> 
> Can you explain what you mean with "truncated memslot"?

Shrink the size of the memslot.

> Regarding the bitmap, currently QEMU should (probably wrongly) update it
> before even committing the changes to KVM. But I remember upstream
> someone pointed that this could be solved later.

These details can't be punted, as they affect the ABI.  My interpretation of
"atomic" memslot updates was that KVM would truly honor the promise of atomic
updates, e.g. that a DELETE=>CREATE sequence would effectively allow truncating
a memslot without losing any data.  Those details aren't really something that
can be punted down the road to be fixed at a later point because they very much
matter from an ABI perspective.

> > Again, I completely agree that the current memslots API is far from perfect, but
> > I'm not convinced that simply extending the existing API to batch updates is the
> > best solution from a KVM perspective.
> > 
> >>> E.g. why do a batch update and not provide KVM_SET_ALL_USER_MEMORY_REGIONS to
> >>> do wholesale replacement?  That seems like it would be vastly simpler to handle
> >>> on KVM's end.  Or maybe there's a solution in the opposite direction, e.g. an
> >>> API that allows 1->N or N->1 conversions but not arbitrary batching.
> >>
> >> Wholesale replacement was my first idea when I looked at the issue, I think
> >> at the end of 2020.  I never got to a full implementation, but my impression
> >> was that allocating/deallocating dirty bitmaps, rmaps etc. would make it any
> >> easier than arbitrary batch updates.
> > 
> > It's not obvious to me that the memslot metadata is going to be easy to handle
> > regardless of what we do.  E.g. I'm pretty sure that batching updates will "corrupt"
> > the dirty bitmap if a hole is punched in a memslot that's being dirty logged.
> > 
> 
> Could you provide an example?
> I mean I am not an expert but to me it looks like I preserved the same
> old functionalities both here and in QEMU. I just batched and delayed
> some operations, which in this case should cause no harm.

As above, my confusion is due to calling these updates "atomic".  The new API is
really just "allow batching memslot updates and subtly rely on restarting page
faults on KVM_MEMSLOT_INVALID".

IMO, KVM_MEM_DISABLED or similar is the way to go.  I.e. formalize the "restart
page faults" semantics without taking on the complexity of batched updates.
