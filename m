Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350072EB373
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 20:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730719AbhAETWl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 14:22:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727790AbhAETWl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 14:22:41 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D3AC061574
        for <kvm@vger.kernel.org>; Tue,  5 Jan 2021 11:22:00 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id w18so446840iot.0
        for <kvm@vger.kernel.org>; Tue, 05 Jan 2021 11:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NI7JRZUNfaLXyoeGZ8aqowVREIgk5DG9F7C0+4KUbB0=;
        b=cKXPT0s20xckt3pn4JszbxoqroM4ZFtl1KTkYSLpKTVM4pxFdo8qyExlNNGT8BYpMb
         NZ2RIqDP3gWJ6bkmP4nvlIVvZXmWQ5joEet2CujZKwpWcJ7N5n/auk1BW+/+tVoS+/s4
         lT8gVE8FyVV7Ciz+NDT9hiz3e4292ghz1R8TSVmowELFoufgEE91l6yLtA+GErZZEkDD
         YbByOYNSLpJO+b4s+aYQ+miKLn/QmnSxdVQZ0VKNvimxO5HFTijBWlM7SZ7oh+QA3lXf
         zI3VjqvvmueJ2mny9sPweOKYQ1sjfncPveIewLrgy3QOtiSHODxs+Eow1AFox5W0KogK
         VNpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NI7JRZUNfaLXyoeGZ8aqowVREIgk5DG9F7C0+4KUbB0=;
        b=IGCtc603m6ksTAV787XLzYdzmFIeKMnx/1DbZumMOR4lFS41xKoHH1ym+BcfYN03Ai
         ghHFqwd2BgkeqGFSCL1ua+PW9jynnuADe72rewisiTU6Zm01pOGjCt3cT6ydaPiN1e6z
         p6tPZWFOwjIDsVyuBmZgiwFZLgwHw7fu58IFJ2WB3EKiGYikQu9jNqGJSZ+mi5rA2V7b
         3MsMC2dpyAsjZo0PuwapY1lAoXTAsIrrPCW5JrZE1KuJwlJjm6c9ZuBJAz2trdb6BY1L
         rbTHeaHlfhflYBi9+nk/D7JmKBukDMcq4Ab8n3afVGIIev5mIXDAMRihLNyqjSlPORY3
         7gQg==
X-Gm-Message-State: AOAM53009rvx4i0Db1hb9jQEkVKX9WRtl4F73YccpHtJoFZZw+3cxToC
        UKoh1hAZ07zhuVclwvrXCjlgRvh2jQC4/qIYy5DVnQ==
X-Google-Smtp-Source: ABdhPJw5T3ZD5Nh/LmPjdcOum0L2dSnap3Ff/F39q59yI07xzT2lqKNuTShCiEntAgb6CBTKQgFfqrnYlspLoTObUFk=
X-Received: by 2002:a02:cf9a:: with SMTP id w26mr958587jar.25.1609874519283;
 Tue, 05 Jan 2021 11:21:59 -0800 (PST)
MIME-Version: 1.0
References: <4bf6fcae-20e7-3eae-83ec-51fb52110487@oracle.com>
 <8A352C2E-E7D2-4873-807F-635A595DCAEF@gmail.com> <CANgfPd_cbBxWHmPsw0x5NfKrMXzij3YAAiaq665zxn5nnraPGg@mail.gmail.com>
 <CANgfPd8fFB6QM3bOhxQ0WPjw6f5FLqBm1ynCenAxymByq4Lz5g@mail.gmail.com>
 <f360715b-e61b-7e68-1aa9-84df51331d95@redhat.com> <X/Sz9EN0cKbyd1gQ@google.com>
In-Reply-To: <X/Sz9EN0cKbyd1gQ@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 5 Jan 2021 11:21:48 -0800
Message-ID: <CANgfPd80nXP8o5_o3wb2x2ahgWS6a8ubHFNzBp3TSQYi=cS9Yg@mail.gmail.com>
Subject: Re: reproducible BUG() in kvm_mmu_get_root() in TDP MMU
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        leohou1402 <leohou1402@gmail.com>,
        "maciej.szmigiero@oracle.com" <maciej.szmigiero@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "cannonmatthews@google.com" <cannonmatthews@google.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "pshier@google.com" <pshier@google.com>,
        "pfeiner@google.com" <pfeiner@google.com>,
        "junaids@google.com" <junaids@google.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "yulei.kernel@gmail.com" <yulei.kernel@gmail.com>,
        "kernellwp@gmail.com" <kernellwp@gmail.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 5, 2021 at 10:46 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jan 05, 2021, Paolo Bonzini wrote:
> > On 05/01/21 18:49, Ben Gardon wrote:
> > > for_each_tdp_mmu_root(kvm, root) {
> > >          kvm_mmu_get_root(kvm, root);
> > >          <Do something, yield the MMU lock>
> > >          kvm_mmu_put_root(kvm, root);
> > > }
> > >
> > > In these cases the get and put root calls are there to ensure that the
> > > root is not freed while the function is running, however they do this
> > > too well. If the put root call reduces the root's root_count to 0, it
> > > should be removed from the roots list and freed before the MMU lock is
> > > released. However the above pattern never bothers to free the root.
> > > The following would fix this bug:
> > >
> > > -kvm_mmu_put_root(kvm, root);
> > > +if (kvm_mmu_put_root(kvm, root))
> > > +       kvm_tdp_mmu_free_root(kvm, root);
> >
> > Is it worth writing a more complex iterator struct, so that
> > for_each_tdp_mmu_root takes care of the get and put?
>
> Ya, and maybe with an "as_id" variant to avoid the get/put?  Not sure that's a
> worthwhile optimization though.

I'll see about adding such an iterator. I don't think avoiding the get
/ put is really worthwhile in this case since they're cheap operations
and putting them in the iterator makes it less obvious that they're
missing if those functions ever need to yield.

>
> On a related topic, there are a few subtleties with respect to
> for_each_tdp_mmu_root() that we should document/comment.  The flows that drop
> mmu_lock while iterating over the roots don't protect against the list itself
> from being modified.  E.g. the next entry could be deleted, or a new root
> could be added.  I think I've convinced myself that there are no existing bugs,
> but we should document that the exact current behavior is required for
> correctness.
>
> The use of "unsafe" list_for_each_entry() in particular is unintuitive, as using
> the "safe" variant would dereference a deleted entry in the "next entry is
> deleted" scenario.
>
> And regarding addomg a root, using list_add_tail() instead of list_add() in
> get_tdp_mmu_vcpu_root() would cause iteration to visit a root that was added
> after the iteration started (though I don't think this would ever be problematic
> in practice?).

A lot of these observations are safe because the operations using this
iterator only consider one root at a time and aren't really interested
in the state of the list.
Your point about the dangers of adding and removing roots while one of
these functions is running is valid, but like the legacy / shadow MMU
implementation, properties which need to be guaranteed across multiple
roots need to be managed at a higher level.
I believe that with the legacy / shadow MMU the creation of a new
root, while enabling write protection dirty logging for example, could
result in entries in the new root being considered, and others not
considered. That's why we set the dirty logging flag on the memslot
before we write protect SPTEs.
I'm not sure where exactly to document these properties, but I agree
it would be a good thing to do in a future patch set.
