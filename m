Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9BB04A3BE7
	for <lists+kvm@lfdr.de>; Mon, 31 Jan 2022 00:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234915AbiA3Xq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Jan 2022 18:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233440AbiA3Xq4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Jan 2022 18:46:56 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0CBC061714
        for <kvm@vger.kernel.org>; Sun, 30 Jan 2022 15:46:56 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id r27so1482022oiw.4
        for <kvm@vger.kernel.org>; Sun, 30 Jan 2022 15:46:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=stOU701ybiBSdxbFZHlRxxmUeosrHT4r5rI9Q7PFUrs=;
        b=ljhds+aSqyLG4GcLmgiNYL5pJGpVUUiSYczpj6RuInm4E+hgVjHEkJsbQ9Tw52f3Mc
         V1d5gwQ6Rx2CAdEC0lfmKNNj/mbTGeReSbUWfQ9n3e4vmmChVOkdGZYfY+OdvHgbtqIn
         1AS1H3HSuivXtH1TgIqisHEXUAo/FvjbCd7iUeYicFFjG1pZu1caXuQkJqga8dYQolVv
         /GS4vezYDBYGxxx7EMrpmPHLy9YJ976LC2vLz3AxXnNeMClOHF2SL96+GVwQGyFc4G9s
         ITZY08tXzNlPtnz4JQQ2iUokIMY3bmHIS0h+UFzUV+LzQ/9MbyxGZlcUrnduw7sh6B8J
         jhnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=stOU701ybiBSdxbFZHlRxxmUeosrHT4r5rI9Q7PFUrs=;
        b=gFkdll+uGdLtYamM6c24tRvAohnehVg0cCLvHmOvVz8Yy2pfiHjNy6/Uo/FZyzPzT+
         01ejs2k9q1sQXn5DnWVh66XN8gi17UTlMQt5dPVypy+F9mQ9JsLCb/RyqTKQKAnzgbFT
         vQq1Mu1nav8OuTmFzTQP+vMVpDRYlMXg690Yis9nqghn9E1A7j9UO/huT/LBF1gLhA9r
         gJ4f3D+zo3YV8vUZ1mthY1CTQ25OX4/qs/OM4Fhqq1nuoYLeoTEc5K7VFJcV9yfR5aE/
         QyttF+CL8XbSSIlB+l/ko+SzTtFQTVYlljpA2b5hfw1a5o2yehF6vtabCwhD1lo9ud/N
         q2Ow==
X-Gm-Message-State: AOAM532t6UW42pW3lHSxISNT45YV/eDA1biWbW3VEDzBYqQ/Ql8FWj5r
        IOQ1uBFe13Wa3P8HXMCLm6fz6M+KVE7+CDllGbdLOw==
X-Google-Smtp-Source: ABdhPJzJjkHOWnJuQGcJ1VlwL5xlLEpJdu0ZNtDEZ3pt1T3PnGK/SBZV60WZdlp1apX39vuj6o8XpyrWNB1cVYQZIvM=
X-Received: by 2002:a05:6808:21a5:: with SMTP id be37mr10706547oib.339.1643586415444;
 Sun, 30 Jan 2022 15:46:55 -0800 (PST)
MIME-Version: 1.0
References: <fc6bea3249f26e8dd973ce1bd1e3f6f42c142469.camel@redhat.com>
 <CALMp9eT2cP7kdptoP3=acJX+5_Wg6MXNwoDh42pfb21-wdXvJg@mail.gmail.com> <11324ba7075ce90dee9d424c78db0bf97b1c4444.camel@redhat.com>
In-Reply-To: <11324ba7075ce90dee9d424c78db0bf97b1c4444.camel@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Sun, 30 Jan 2022 15:46:43 -0800
Message-ID: <CALMp9eSX8sgyF_CkKQuYP6P5ZGN+t82bmmk9aTfBivSh1+yHiQ@mail.gmail.com>
Subject: Re: Why do we need KVM_REQ_GET_NESTED_STATE_PAGES after all
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gilbert <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 30, 2022 at 6:29 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> On Thu, 2022-01-27 at 11:39 -0800, Jim Mattson wrote:
> > On Thu, Jan 27, 2022 at 8:04 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > > I would like to raise a question about this elephant in the room which I wanted to understand for
> > > quite a long time.
> > >
> > > For my nested AVIC work I once again need to change the KVM_REQ_GET_NESTED_STATE_PAGES code and once
> > > again I am asking myself, maybe we can get rid of this code, after all?
> >
> > We (GCE) use it so that, during post-copy, a vCPU thread can exit to
>
> Thank you very much for a very detailed response!
>
> > userspace and demand these pages from the source itself, rather than
> > funneling all demands through a single "demand paging listener"
> That is something I didn't think of!
>
> The question is however, can that happen between setting the nested state
> and running a vCPU first time.
>
> I guess it is possible in therory that you set the nested state, then run 1 vCPU,
> which faults and exits to userspace,
> then userspace populates the faulted memory which triggers memslots update,
> and only then you run another vCPU for first time.
> needs will be need when this request is processed, and it will fail if they aren't.

That isn't quite how our post-copy works.  There is no memslots
update. When post-copy starts, the source sends a bitmap of dirty
pages to the destination. This bitmap is installed in kvm via a
Google-local ioctl. Then, all vCPUs on the destination start running,
while the source pushes dirty pages to the destination. As EPT
violations occur for cold mappings at the destination, we check the
bitmap to see if we need to demand the page from the source
out-of-band. We know that the page will eventually come across, but we
need it *now*, so that the vCPU thread that incurred the EPT violation
can resume. If the page is in the dirty bitmap, the vCPU thread that
incurred the EPT violation will exit to userspace and request the page
from the source. When the page arrives, we overwrite the stale page in
the memslot and clear the bit in the dirty page bitmap.

For cases where kvm needs a dirty page to do software page walks or
instruction emulation or whatever, the vCPU thread sends a request to
the "demand page listener" thread via a netlink socket and then
blocks, waiting for the bit to clear in the dirty bitmap. For various
reasons, including the serialization on the listener thread and the
unreliability of the netlink socket, we didn't want to have all of the
vmcs12 pages use the netlink request path. (This concern may be
largely moot, since modification of most pages hanging off of the VMCS
while the (v)CPU is in VMX non-root mode leads to undefined behavior.)

>
> > thread, which I believe is the equivalent of qemu's userfaultfd "fault
> > handler" thread. Our (internal) post-copy mechanism scales quite well,
> > because most demand paging requests are triggered by an EPT violation,
> > which happens to be a convenient place to exit to userspace. Very few
> > pages are typically demanded as a result of
> > kvm_vcpu_{read,write}_guest, where the vCPU thread is so deep in the
> > kernel call stack that it has to request the page via the demand
> > paging listener thread. With nested virtualization, the various vmcs12
> > pages consulted directly by kvm (bypassing the EPT tables) were a
> > scalability issue.
> I assume that you patched all these calls to exit to userspace for the
> demand paging scheme you are using.
>
> >
> > (Note that, unlike upstream, we don't call nested_get_vmcs12_pages
> > directly from VMLAUNCH/VMRESUME emulation; we always call it as a
> > result of this request that you don't like.)
> Also I guess something specific to your downstream patches.
>
>
> >
> > As we work on converting from our (hacky) demand paging scheme to
> > userfaultfd, we will have to solve the scalability issue anyway
> > (unless someone else beats us to it). Eventually, I expect that our
> > need for this request will go away.
>
> Great!
>
> The question is, if we remove it now, will that affect you?

No. By the time we get to 5.17, I don't expect any of our current
post-copy scheme to survive.

> What if we depricate it (add option to keep the current behavier,
> but keep an module param to revert back to old behavier, with
> the eventual goal of removing it.

Don't bother on our account. :-)
>
> >
> > Honestly, without the exits to userspace, I don't really see how this
> > request buys you anything upstream. When I originally submitted it, I
> > was prepared for rejection, but Paolo said that qemu had a similar
> > need for it, and I happily never questioned that assertion.
>
> Exactly! I didn't questioned it as well, because I didn't knew MMU at all,
> and it is one of the harderst KVM parts - who knows what it caches,
> and what magic it needs to be up to date.

The other question, which may have been what motivated Paolo to keep
the GET_NESTED_VMCS12_PAGES request, is whether or not the memslots
have been established before userspace calls the ioctl for
SET_NESTED_STATE. If not, it is impossible to do any GPA->HPA lookups
for VMCS12 fields that are necessary for the vCPU to enter VMX
non-root mode as part of SET_NESTED_STATE. The only field I can think
of off the top of my head is the VMCS12 APIC-access address, which,
sadly, has to be backed by an L1 memslot, even though the page is
never accessed. (VMware always sets the APIC-access address to 0, for
all VMCSs, at L1 or L2. That makes things a lot easier.) If the
memslots are established before SET_NESTED_STATE, this isn't a
problem, but I don't recall that constraint being documented anywhere.

> But now, I don't think there are still large areas of MMU that I don't understand,
> thus I started asking myself why it is need.
>
> That request is a ripe source of bugs. Just off my hand, Vitaly spent at least a week
> understanding why after vmcb01/02 split, eVMCS stopped working, only to figure out that
> KVM_REQ_GET_NESTED_STATE_PAGES might not be called after nested entry since there
> could be nested VM exit before we even enter the guest, and since then one more
> hack has to be added to work that around (nothing against the hack, its not the
> root cause of the problem).
>
> I also indirectly caused and fixed a CVE like issue, which started
>  with the patch that added KVM_REQ_GET_NESTED_STATE_PAGES to SVM -
> it made KVM switch to nested msr bitmap
> and back then there was no vmcb01/02 split. Problem is that back then
> we didn't cancel that request if we have VM exit right after VM entry,
> so it would be still pending on VM entry, and it will switch to nested MSR bitmap
> even if we are no longer nested - then I added patch to free the nested state
> on demand, and boom - we have L1 using freed (and usualy zeroed) MSR bitmap - free
> access to all host msrs from L1...
>
> There is another hidden issue in this request, that it makes it impossible to
> handle failure gracefully.
>
> If for example, loading nested state pages needs to allocate memory and that
> fails, we could just fail the nested VM entry if that request wasn't there.
> While this is not ideal for the nested guest, it likely to survive, and
> might even retry entering the nested guest.
>
> On the other hand during the request if something fails, nested state is
> already loaded, and all we can do is to kill the L1.

I apologize for all of that pain.

>
> Thanks again!
> Best regards,
>         Maxim Levitsky
>
> >
>
>
>
>
