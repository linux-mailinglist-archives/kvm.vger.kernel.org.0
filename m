Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10806386FC2
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 04:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344678AbhERCDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 22:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235741AbhERCDD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 22:03:03 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692CEC061756
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 19:01:46 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id t11so7811672iol.9
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 19:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eiOP4WhukkqWvHIe+lpGPImxAkNhpIv8Q/xSjCssMYE=;
        b=tfxl3LXoKZOqzT25D2GmW0+3xhRoFtBHcapsoEUgP/Y+G+IIEd26DVi4XfSTMt/FFE
         CZdH1dKND7CZCr6KMu83xPt5UNz5++3PAuzjUBR1xSSRia6faT3U/sR7mnmJQUIpmO9a
         fm7tfJ2vVKDCgCeA5fQ2lOj79nZGfv9jv4Rihxkc8Jenn/IaTDtftEJSyDHTh+LkMbtM
         04kZjdWbalMCbROilNT+Mv2OwxWvis3o0IQL32EbYQ9Fx/JMxSY93CWQ1E8H1L3Q8uVm
         IMIOseFJEsXXwiDeA0I1NVrmDH99Vjp7K5zMD+D3HeP2DhDoc/wQz+gQVN4blXZI8ZF9
         qTvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eiOP4WhukkqWvHIe+lpGPImxAkNhpIv8Q/xSjCssMYE=;
        b=XAxQavHDuv0i4oIk3aMD/yX3ZvwFaifSMpiNkESVK4NCOF0mCubBMjXrWeuW6qwG4c
         z6XaCM9vDOWGM/DT/Wc9Zk8tTu9hj6K16/rusWD71fXfm+avdMdqXRQvZu/sFaBcUKAk
         D9M4vmCqRpcixkw+jtf7s7s7n0ZIV7InE4KbTOsOrfhaqO8ca4kwURqqdfAVEcD1d/9u
         ccL6l/S8YLXId38XKL314RXeBaRKiJNo1aXBFsQNyaaa5AwFcEneaYnea8IN10FkomU2
         fSwW5r3yx1qLBAvDzPv+NZXhvukHx/S8qB07EDL7UIaDyXRSuJf76clDK6QYzjetoRBv
         z8Lw==
X-Gm-Message-State: AOAM533lyvaIdYV26dgwXvImK0XZykE1bma3p/ZkB7R7Cfdfo+L1RCux
        RawxxyjmMV2hbZ6DZergmHSq64RQr3zlVjUsf07Wpw==
X-Google-Smtp-Source: ABdhPJyQ2ALt/nIOyU7QFJ0S3oRqnCZ9G8SnQnBWadudtIeZwYLkxXAmel1aWJfQRhfAFy7e60kwaVSwFvWGe3Vpg6M=
X-Received: by 2002:a05:6638:b14:: with SMTP id a20mr2975623jab.132.1621303305671;
 Mon, 17 May 2021 19:01:45 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1619193043.git.ashish.kalra@amd.com> <ff68a73e0cdaf89e56add5c8b6e110df881fede1.1619193043.git.ashish.kalra@amd.com>
 <YJvU+RAvetAPT2XY@zn.tnic> <20210513043441.GA28019@ashkalra_ubuntu_server>
 <YJ4n2Ypmq/7U1znM@zn.tnic> <7ac12a36-5886-cb07-cc77-a96daa76b854@redhat.com>
 <20210514090523.GA21627@ashkalra_ubuntu_server> <YJ5EKPLA9WluUdFG@zn.tnic> <20210514100519.GA21705@ashkalra_ubuntu_server>
In-Reply-To: <20210514100519.GA21705@ashkalra_ubuntu_server>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 17 May 2021 19:01:09 -0700
Message-ID: <CABayD+e9NHytm5RA7MakRq5EqPJ+U11jWkEFpJKSqm0otBidaQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] mm: x86: Invoke hypercall when page encryption
 status is changed
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 14, 2021 at 3:05 AM Ashish Kalra <ashish.kalra@amd.com> wrote:
>
> On Fri, May 14, 2021 at 11:34:32AM +0200, Borislav Petkov wrote:
> > On Fri, May 14, 2021 at 09:05:23AM +0000, Ashish Kalra wrote:
> > > Ideally we should fail/stop migration even if a single guest page
> > > encryption status cannot be notified and that should be the way to
> > > proceed in this case, the guest kernel should notify the source
> > > userspace VMM to block/stop migration in this case.
> >
> > Yap, and what I'm trying to point out here is that if the low level
> > machinery fails for whatever reason and it cannot recover, we should
> > propagate that error up the chain so that the user is aware as to why it
> > failed.
> >
>
> I totally agree.
>
> > WARN is a good first start but in some configurations those splats don't
> > even get shown as people don't look at dmesg, etc.
> >
> > And I think it is very important to propagate those errors properly
> > because there's a *lot* of moving parts involved in a guest migration
> > and you have encrypted memory which makes debugging this probably even
> > harder, etc, etc.
> >
> > I hope this makes more sense.
> >
> > > From a practical side, i do see Qemu's migrate_add_blocker() interface
> > > but that looks to be a static interface and also i don't think it will
> > > force stop an ongoing migration, is there an existing mechanism
> > > to inform userspace VMM from kernel about blocking/stopping migration ?
> >
> > Hmm, so __set_memory_enc_dec() which calls
> > notify_addr_enc_status_changed() is called by the guest, right, when it
> > starts migrating.
> >
>
> No, actually notify_addr_enc_status_changed() is called whenever a range
> of memory is marked as encrypted or decrypted, so it has nothing to do
> with migration as such.
>
> This is basically modifying the encryption attributes on the page tables
> and correspondingly also making the hypercall to inform the hypervisor about
> page status encryption changes. The hypervisor will use this information
> during an ongoing or future migration, so this information is maintained
> even though migration might never be initiated here.
>
> > Can an error value from it be propagated up the callchain so it can be
> > turned into an error messsage for the guest owner to see?
> >
>
> The error value cannot be propogated up the callchain directly
> here, but one possibility is to leverage the hypercall and use Sean's
> proposed hypercall interface to notify the host/hypervisor to block/stop
> any future/ongoing migration.
>
> Or as from Paolo's response, writing 0 to MIGRATION_CONTROL MSR seems
> more ideal.
>
> Thanks,
> Ashish

How realistic is this type of failure? If you've gotten this deep, it
seems like something has gone very wrong if the memory you are about
to mark as shared (or encrypted) doesn't exist and isn't mapped. In
particular, is the kernel going to page fault when it tries to
reinitialize the page it's currently changing the c-bit of? From what
I recall, most paths that do either set_memory_encrypted or
set_memory_decrypted memset the region being toggled. Note: dma_pool
doesn't immediately memset, but the VA it's providing to set_decrypted
is freshly fetched from a recently allocated region (something has to
have gone pretty wrong if this is invalid if I'm not mistaken. No one
would think twice if you wrote to that freshly allocated page).

The reason I mention this is that SEV migration is going to be the
least of your concerns if you are already on a one-way train towards a
Kernel oops. I'm not certain I would go so far as to say this should
BUG() instead (I think the page fault on access might be easier to
debug a BUG here), but I'm pretty skeptical that the kernel is going
to do too well if it doesn't know if its kernel VAs are valid.

If, despite the above, we expect to infrequently-but-not-never disable
migration with no intention of reenabling it, we should signal it
differently than we currently signal migration enablement. Currently,
if you toggle migration from on to off there is an implication that
you are about to reboot, and you are only ephemerally unable to
migrate. Having permanent disablement be indistinguishable from a
really long reboot is a recipe for a really sad long timeout in
userspace.
