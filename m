Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDC52929EB
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 17:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729704AbgJSPA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 11:00:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47580 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729589AbgJSPAz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Oct 2020 11:00:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603119653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eeEwkWd2inwelOxnZFWrV6qJ4loEm7oC47tsgU5zrNE=;
        b=iA8HNFocT1/DkBga57FL/R8kedhw7xfgit+abZdmC0wkt7fqZrEsVKh4/Xj8Y48AyqxoVf
        6KnmXMwx6f/Q2yjJjUUeSylDIOOC1csSEdDgS848zWe0eavhXxJ/z1ksHfsrHsCNBZxR83
        3Fefa4962dSXPR2sxcVveSEm5L+7s6o=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-eQzDkAr4Ppq5aptPfPlR3Q-1; Mon, 19 Oct 2020 11:00:52 -0400
X-MC-Unique: eQzDkAr4Ppq5aptPfPlR3Q-1
Received: by mail-wr1-f71.google.com with SMTP id f11so7498951wro.15
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 08:00:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eeEwkWd2inwelOxnZFWrV6qJ4loEm7oC47tsgU5zrNE=;
        b=aowv9ih93xv8q6gy8qsFdJgipOuXOVtonJvXNa0ilDdZArsC3sKMjTH8cJ4RuessOd
         ZGiEuTPFWRLHiu6qP90T9hbnHHRaVx77XCHIn6GJRDD+ij9cs69WrofnMN/j7INgPdRV
         fS4bpnLWoBbQYwPdsbyGRYFtxuXO9S9CVNT6DKUhOR1AtYfyOZnLqkd9NJ9xqSWDkRA1
         DMcsq9uqAxNPs0XJ29R3jNwh1guZ5xy/N0Xrdphw+C1nnoEem7xFV67gPIHbb0k47Xp0
         WRMjqP0jMrKzpMSHOJAoyVWf2kXPw8Y6Z+ep9x01QhvLURi6nJ5uPETWuaYVhOowpUYe
         DBEQ==
X-Gm-Message-State: AOAM531+mEw1ScuFI5WgDEJtPirA9gSDbjCkdnmDLeX0RV7zwwL2zzDq
        yfE5zxOPHV1lTAfygnuUH+ATOvqNJRTfiyG9qivGrB8PhHHn9asLrQqH5OuFSKwVBCpk0ES9xAP
        PfYGx4dD3Py8I
X-Received: by 2002:a7b:c081:: with SMTP id r1mr17940621wmh.158.1603119650865;
        Mon, 19 Oct 2020 08:00:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx1K7foO6zAsERSnzDbqpvWg8Yzks+2b30SB3/GCrweUhcJIelqhNOTssKhNwAEMU36/iuvgw==
X-Received: by 2002:a7b:c081:: with SMTP id r1mr17940572wmh.158.1603119650551;
        Mon, 19 Oct 2020 08:00:50 -0700 (PDT)
Received: from redhat.com (bzq-79-176-118-93.red.bezeqint.net. [79.176.118.93])
        by smtp.gmail.com with ESMTPSA id e15sm8898wro.13.2020.10.19.08.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 08:00:49 -0700 (PDT)
Date:   Mon, 19 Oct 2020 11:00:45 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jann Horn <jannh@google.com>, Willy Tarreau <w@1wt.eu>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Catangiu, Adrian Costin" <acatan@amazon.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "open list:VIRTIO GPU DRIVER" 
        <virtualization@lists.linux-foundation.org>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "Woodhouse, David" <dwmw@amazon.co.uk>, bonzini@gnu.org,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>, oridgar@gmail.com,
        ghammer@redhat.com, Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Qemu Developers <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH] drivers/virt: vmgenid: add vm generation id driver
Message-ID: <20201019105118-mutt-send-email-mst@kernel.org>
References: <CAG48ez1ZtvjOs2CEq8-EMosPCd_o7WQ3Mz_+1mDe7OrH2arxFA@mail.gmail.com>
 <20201017053712.GA14105@1wt.eu>
 <CAG48ez1h0ynXfGap_KiHiPVTfcB8NBQJ-2dnj08ZNfuhrW0jWA@mail.gmail.com>
 <20201017064442.GA14117@1wt.eu>
 <CAG48ez3pXLC+eqAXDCniM0a+5yP2XJODDkZqiUTZUOttCE_LbA@mail.gmail.com>
 <CAHmME9qHGSF8w3DoyCP+ud_N0MAJ5_8zsUWx=rxQB1mFnGcu9w@mail.gmail.com>
 <20201018114625-mutt-send-email-mst@kernel.org>
 <CALCETrXBJZnKXo2QLKVWSgAhSMdwEVHeut6pRw4P92CR_5A-fQ@mail.gmail.com>
 <20201018115524-mutt-send-email-mst@kernel.org>
 <CALCETrUeRAhmEFR6EFXz8HzDYd2doZ2TMyZmu1pU_-yAPA6KDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUeRAhmEFR6EFXz8HzDYd2doZ2TMyZmu1pU_-yAPA6KDw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 18, 2020 at 09:14:00AM -0700, Andy Lutomirski wrote:
> On Sun, Oct 18, 2020 at 8:59 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Sun, Oct 18, 2020 at 08:54:36AM -0700, Andy Lutomirski wrote:
> > > On Sun, Oct 18, 2020 at 8:52 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Sat, Oct 17, 2020 at 03:24:08PM +0200, Jason A. Donenfeld wrote:
> > > > > 4c. The guest kernel maintains an array of physical addresses that are
> > > > > MADV_WIPEONFORK. The hypervisor knows about this array and its
> > > > > location through whatever protocol, and before resuming a
> > > > > moved/snapshotted/duplicated VM, it takes the responsibility for
> > > > > memzeroing this memory. The huge pro here would be that this
> > > > > eliminates all races, and reduces complexity quite a bit, because the
> > > > > hypervisor can perfectly synchronize its bringup (and SMP bringup)
> > > > > with this, and it can even optimize things like on-disk memory
> > > > > snapshots to simply not write out those pages to disk.
> > > > >
> > > > > A 4c-like approach seems like it'd be a lot of bang for the buck -- we
> > > > > reuse the existing mechanism (MADV_WIPEONFORK), so there's no new
> > > > > userspace API to deal with, and it'd be race free, and eliminate a lot
> > > > > of kernel complexity.
> > > >
> > > > Clearly this has a chance to break applications, right?
> > > > If there's an app that uses this as a non-system-calls way
> > > > to find out whether there was a fork, it will break
> > > > when wipe triggers without a fork ...
> > > > For example, imagine:
> > > >
> > > > MADV_WIPEONFORK
> > > > copy secret data to MADV_DONTFORK
> > > > fork
> > > >
> > > >
> > > > used to work, with this change it gets 0s instead of the secret data.
> > > >
> > > >
> > > > I am also not sure it's wise to expose each guest process
> > > > to the hypervisor like this. E.g. each process needs a
> > > > guest physical address of its own then. This is a finite resource.
> > > >
> > > >
> > > > The mmap interface proposed here is somewhat baroque, but it is
> > > > certainly simple to implement ...
> > >
> > > Wipe of fork/vmgenid/whatever could end up being much more problematic
> > > than it naively appears -- it could be wiped in the middle of a read.
> > > Either the API needs to handle this cleanly, or we need something more
> > > aggressive like signal-on-fork.
> > >
> > > --Andy
> >
> >
> > Right, it's not on fork, it's actually when process is snapshotted.
> >
> > If we assume it's CRIU we care about, then I
> > wonder what's wrong with something like
> > MADV_CHANGEONPTRACE_SEIZE
> > and basically say it's X bytes which change the value...
> 
> I feel like we may be approaching this from the wrong end.  Rather
> than saying "what data structure can the kernel expose that might
> plausibly be useful", how about we try identifying some specific
> userspace needs and see what a good solution could look like.  I can
> identify two major cryptographic use cases:

Well, I'm aware of a non-cryptographic use-case:
https://bugzilla.redhat.com/show_bug.cgi?id=1118834

this seems to just ask for the guest to have a way to detect that
a VM cloning triggered.


-- 
MST

