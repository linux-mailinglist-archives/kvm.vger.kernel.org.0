Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64DB2143BDC
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 12:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbgAULPD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 06:15:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24412 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729159AbgAULPC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 06:15:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579605300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Sas8QSfTms5SHYNUYcSN2fpX+ktGIKgMkg1A/nzCkbg=;
        b=DK9ug1zBLqwyxPvKKxwSRUs19D6tKDjmNSUd+tMMz+tn8M9dbA2I0hodFUbsipj+6aSh1J
        PxOcQ0TFfyE/Rbs4h/ZGwurDxo44uVfzEvHMtRc8NuDB8VHsl3Vu/f+p/UnOrmg1tot8CV
        5EsHewQgVeAYvXOgceumx5Znfmk+IhU=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-I3OVcuzgN7mYFOLx3TrUkA-1; Tue, 21 Jan 2020 06:14:56 -0500
X-MC-Unique: I3OVcuzgN7mYFOLx3TrUkA-1
Received: by mail-qk1-f200.google.com with SMTP id u10so1550221qkk.1
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 03:14:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Sas8QSfTms5SHYNUYcSN2fpX+ktGIKgMkg1A/nzCkbg=;
        b=FWTq2EmkSMmRtm4r6qrVI4e+wQNK7IhX08vzuZRPQXm7S/kF5gv+ptuIalFZo2tJmA
         Ev5crcdU2/ZiikucCmpFeF6ploGskSXh+SdOqWvCPUuS306/EStKPTZs4tP7DKwDrVAM
         sLa0yRoPYA0BlJrS+hhToQMY51vrxis6HGOiCfBG5V+CW9SsY7bF5ZuWi+Sw9pRj4SHh
         xrYhSBrH2+GLi90p3QGDxLb2I7nBOcuSWETrHiSAcdyfSDPaJyiHtCXHNG61Oe1Ad3mP
         ulqrZ8vN6m6qeRM/RqGgvGQ4MXZ+RiTw3XPeT7m3tzxj/dKoxdmTq4QKFuZ1EhRFJtb+
         tOLg==
X-Gm-Message-State: APjAAAWhwEtvImFIXZwKLmuBZ5ma5EyDkLzJ9pRhO2f3CSbqk9RksH4u
        nHe1BODdJOtpezoiAUllxGXBVXoOPCAx7OunGZFX2KdPeWPZN/UNt4J5+dPLDzZk3Ug2upJ8NCX
        +S66VhNrnTz28
X-Received: by 2002:aed:2a12:: with SMTP id c18mr3777310qtd.200.1579605296052;
        Tue, 21 Jan 2020 03:14:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqxBa53GZjQgDfeEt/mKYlPCXxhcFat/NW2g7/j2dAOcNMjdacdZ6bp3qye4cVZNWRDKUgo3aw==
X-Received: by 2002:aed:2a12:: with SMTP id c18mr3777280qtd.200.1579605295708;
        Tue, 21 Jan 2020 03:14:55 -0800 (PST)
Received: from redhat.com (bzq-79-179-85-180.red.bezeqint.net. [79.179.85.180])
        by smtp.gmail.com with ESMTPSA id k133sm428981qke.134.2020.01.21.03.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 03:14:54 -0800 (PST)
Date:   Tue, 21 Jan 2020 06:14:48 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jorgen Hansen <jhansen@vmware.com>,
        Jason Wang <jasowang@redhat.com>, kvm <kvm@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>
Subject: Re: [PATCH net-next 1/3] vsock: add network namespace support
Message-ID: <20200121055403-mutt-send-email-mst@kernel.org>
References: <20200116172428.311437-1-sgarzare@redhat.com>
 <20200116172428.311437-2-sgarzare@redhat.com>
 <20200120.100610.546818167633238909.davem@davemloft.net>
 <20200120101735.uyh4o64gb4njakw5@steredhat>
 <20200120060601-mutt-send-email-mst@kernel.org>
 <CAGxU2F6VH8Eb5UH_9KjN6MONbZEo1D7EHAiocVVus6jW55BJDg@mail.gmail.com>
 <20200120110319-mutt-send-email-mst@kernel.org>
 <CAGxU2F5=DQJ56sH4BUqp_7rvaXSF9bFHp4QkpLApJQK0bmd4MA@mail.gmail.com>
 <20200120170120-mutt-send-email-mst@kernel.org>
 <CAGxU2F4uW7FNe5xC0sb3Xxr_GABSXuu1Z9n5M=Ntq==T7MaaVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGxU2F4uW7FNe5xC0sb3Xxr_GABSXuu1Z9n5M=Ntq==T7MaaVw@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 21, 2020 at 10:07:06AM +0100, Stefano Garzarella wrote:
> On Mon, Jan 20, 2020 at 11:02 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > On Mon, Jan 20, 2020 at 05:53:39PM +0100, Stefano Garzarella wrote:
> > > On Mon, Jan 20, 2020 at 5:04 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > On Mon, Jan 20, 2020 at 02:58:01PM +0100, Stefano Garzarella wrote:
> > > > > On Mon, Jan 20, 2020 at 1:03 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > On Mon, Jan 20, 2020 at 11:17:35AM +0100, Stefano Garzarella wrote:
> > > > > > > On Mon, Jan 20, 2020 at 10:06:10AM +0100, David Miller wrote:
> > > > > > > > From: Stefano Garzarella <sgarzare@redhat.com>
> > > > > > > > Date: Thu, 16 Jan 2020 18:24:26 +0100
> > > > > > > >
> > > > > > > > > This patch adds 'netns' module param to enable this new feature
> > > > > > > > > (disabled by default), because it changes vsock's behavior with
> > > > > > > > > network namespaces and could break existing applications.
> > > > > > > >
> > > > > > > > Sorry, no.
> > > > > > > >
> > > > > > > > I wonder if you can even design a legitimate, reasonable, use case
> > > > > > > > where these netns changes could break things.
> > > > > > >
> > > > > > > I forgot to mention the use case.
> > > > > > > I tried the RFC with Kata containers and we found that Kata shim-v1
> > > > > > > doesn't work (Kata shim-v2 works as is) because there are the following
> > > > > > > processes involved:
> > > > > > > - kata-runtime (runs in the init_netns) opens /dev/vhost-vsock and
> > > > > > >   passes it to qemu
> > > > > > > - kata-shim (runs in a container) wants to talk with the guest but the
> > > > > > >   vsock device is assigned to the init_netns and kata-shim runs in a
> > > > > > >   different netns, so the communication is not allowed
> > > > > > > But, as you said, this could be a wrong design, indeed they already
> > > > > > > found a fix, but I was not sure if others could have the same issue.
> > > > > > >
> > > > > > > In this case, do you think it is acceptable to make this change in
> > > > > > > the vsock's behavior with netns and ask the user to change the design?
> > > > > >
> > > > > > David's question is what would be a usecase that's broken
> > > > > > (as opposed to fixed) by enabling this by default.
> > > > >
> > > > > Yes, I got that. Thanks for clarifying.
> > > > > I just reported a broken example that can be fixed with a different
> > > > > design (due to the fact that before this series, vsock devices were
> > > > > accessible to all netns).
> > > > >
> > > > > >
> > > > > > If it does exist, you need a way for userspace to opt-in,
> > > > > > module parameter isn't that.
> > > > >
> > > > > Okay, but I honestly can't find a case that can't be solved.
> > > > > So I don't know whether to add an option (ioctl, sysfs ?) or wait for
> > > > > a real case to come up.
> > > > >
> > > > > I'll try to see better if there's any particular case where we need
> > > > > to disable netns in vsock.
> > > > >
> > > > > Thanks,
> > > > > Stefano
> > > >
> > > > Me neither. so what did you have in mind when you wrote:
> > > > "could break existing applications"?
> > >
> > > I had in mind:
> > > 1. the Kata case. It is fixable (the fix is not merged on kata), but
> > >    older versions will not work with newer Linux.
> >
> > meaning they will keep not working, right?
> 
> Right, I mean without this series they work, with this series they work
> only if the netns support is disabled or with a patch proposed but not
> merged in kata.
> 
> >
> > > 2. a single process running on init_netns that wants to communicate with
> > >    VMs handled by VMMs running in different netns, but this case can be
> > >    solved opening the /dev/vhost-vsock in the same netns of the process
> > >    that wants to communicate with the VMs (init_netns in this case), and
> > >    passig it to the VMM.
> >
> > again right now they just don't work, right?
> 
> Right, as above.
> 
> What do you recommend I do?
> 
> Thanks,
> Stefano

If this breaks userspace, then we need to maintain compatibility.
For example, have two devices, /dev/vhost-vsock and /dev/vhost-vsock-netns?

-- 
MST

