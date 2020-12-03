Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F9A2CD4AB
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 12:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388310AbgLCLff (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 06:35:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38606 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388266AbgLCLfe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 06:35:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606995247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wavkmqDxP0khrutcZKed1F8mOygRt6FLMDWhumXq1xo=;
        b=TifrwUWdW9pWEY89WYM8OIhBo2t81nasfFq2UQoxajpkTmQ5p+0BKjSRbLeyw47DykG4i7
        jMUFApSAiWbuj5hJC3Xm2vqMf7//HLxmI2gzctotYmH5LKCgFpLYGC4K30YSTZ2MCscZOl
        nbEpFDVuEM36Dci1j40oWdx+zUV1CxM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-8nD01ns3PoisopkbrKZSEQ-1; Thu, 03 Dec 2020 06:34:06 -0500
X-MC-Unique: 8nD01ns3PoisopkbrKZSEQ-1
Received: by mail-wm1-f72.google.com with SMTP id r1so1384197wmn.8
        for <kvm@vger.kernel.org>; Thu, 03 Dec 2020 03:34:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wavkmqDxP0khrutcZKed1F8mOygRt6FLMDWhumXq1xo=;
        b=HtPKzTGbbPXObugygfpremeq6Nx9lDJzF86XPSc6ejye2p+1yYbJx63/Jq3gik/KKq
         SE0aOjMfsowgibDF+/X6FlDE3Es1PodGtVXow9/mT7kNg7ImGikawZPLqPhc7Rq2tY8a
         4tQQs047ue1Pp8AFSPnxEMvc0kzeAadqWVdU1gBZMmTGZ36+d98F3M/SS8M+YNVb45i4
         t23b1iwnOSBWFmdbMQUmn5Z791iEqItxLoqa8o7GBOUF+3UABA4TKR9bV0mzHUu3YQ9+
         wAu54o4kbmLXROG3a1+Z2hUUt4A00dFPLi7Csw3x/FQG4fP6Y0XQ9oXILSEfnVboRunt
         SUGA==
X-Gm-Message-State: AOAM531p5VjcFo5l1bGgdGevGpZktwHp5EhrkgM12S7uevkvec3iKs5a
        INWKt6ZVW5IL2e+//TBM2Q00Zhby58fXVGaNO3CAoNpped+UgZLkgmdn2NeG0YUcLvqFYquxy3s
        +5Qfk7IeWEnlP
X-Received: by 2002:a1c:43c6:: with SMTP id q189mr2871935wma.7.1606995244789;
        Thu, 03 Dec 2020 03:34:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyOH5pHcWAY/Avk36sIaVcrY0V/3/zWowk79b8bbB8n88tYmVUdZryjqrNwTkL447lpjE2tsQ==
X-Received: by 2002:a1c:43c6:: with SMTP id q189mr2871917wma.7.1606995244589;
        Thu, 03 Dec 2020 03:34:04 -0800 (PST)
Received: from redhat.com (bzq-79-176-44-197.red.bezeqint.net. [79.176.44.197])
        by smtp.gmail.com with ESMTPSA id o15sm1394318wrp.74.2020.12.03.03.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 03:34:03 -0800 (PST)
Date:   Thu, 3 Dec 2020 06:34:00 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>,
        Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org,
        john.g.johnson@oracle.com, dinechin@redhat.com, cohuck@redhat.com,
        jasowang@redhat.com, felipe@nutanix.com,
        elena.ufimtseva@oracle.com, jag.raman@oracle.com
Subject: Re: MMIO/PIO dispatch file descriptors (ioregionfd) design discussion
Message-ID: <20201203062357-mutt-send-email-mst@kernel.org>
References: <88ca79d2e378dcbfb3988b562ad2c16c4f929ac7.camel@gmail.com>
 <20201202180628.GA100143@xz-x1>
 <20201203111036.GD689053@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203111036.GD689053@stefanha-x1.localdomain>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 03, 2020 at 11:10:36AM +0000, Stefan Hajnoczi wrote:
> On Wed, Dec 02, 2020 at 01:06:28PM -0500, Peter Xu wrote:
> > On Wed, Nov 25, 2020 at 12:44:07PM -0800, Elena Afanasova wrote:
> > 
> > [...]
> > 
> > > Wire protocol
> > > -------------
> > > The protocol spoken over the file descriptor is as follows. The device reads
> > > commands from the file descriptor with the following layout::
> > > 
> > >   struct ioregionfd_cmd {
> > >       __u32 info;
> > >       __u32 padding;
> > >       __u64 user_data;
> > >       __u64 offset;
> > >       __u64 data;
> > >   };
> > 
> > I'm thinking whether it would be nice to have a handshake on the wire protocol
> > before starting the cmd/resp sequence.
> > 
> > I was thinking about migration - we have had a hard time trying to be
> > compatible between old/new qemus.  Now we fixed those by applying the same
> > migration capabilities on both sides always so we do the handshake "manually"
> > from libvirt, but it really should be done with a real handshake on the
> > channel, imho..  That's another story, for sure.
> > 
> > My understanding is that the wire protocol is kind of a standalone (but tiny)
> > protocol between kvm and the emulation process.  So I'm thinking the handshake
> > could also help when e.g. kvm can fallback to an old version of wire protocol
> > if it knows the emulation binary is old.  Ideally, I think this could even
> > happen without VMM's awareness.
> > 
> > [...]
> 
> I imagined that would happen in the control plane (KVM ioctls) instead
> of the data plane (the fd). There is a flags field in
> ioctl(KVM_SET_IOREGION):
> 
>   struct kvm_ioregion {
>       __u64 guest_paddr; /* guest physical address */
>       __u64 memory_size; /* bytes */
>       __u64 user_data;
>       __s32 fd; /* previously created with KVM_CREATE_IOREGIONFD */
>       __u32 flags;
>       __u8  pad[32];
>   };
> 
> When userspace sets up the ioregionfd it can tell the kernel which
> features to enable.
> 
> Feature availability can be checked through ioctl(KVM_CHECK_EXTENSION).
> 
> Do you think this existing mechanism is enough? It's not clear to me
> what kind of additional negotiation would be necessary between the
> device emulation process and KVM after the ioregionfd has been
> registered?
> 
> > > Ordering
> > > --------
> > > Guest accesses are delivered in order, including posted writes.
> > 
> > I'm wondering whether it should prepare for out-of-order commands assuming if
> > there's no handshake so harder to extend, just in case there could be some slow
> > commands so we still have chance to reply to a very trivial command during
> > handling the slow one (then each command may require a command ID, too).  But
> > it won't be a problem at all if we can easily extend the wire protocol so the
> > ordering constraint can be extended too when really needed, and we can always
> > start with in-order-only requests.
> 
> Elena and I brainstormed out-of-order commands but didn't include them
> in the proposal because it's not clear that they are needed. For
> multi-queue devices the per-queue registers can be assigned different
> ioregionfds that are handled by dedicated threads.

The difficulty is I think the reverse: reading
any register from a PCI device is normally enough to flush any
writes and interrupts in progress.



> Out-of-order commands are only necessary if a device needs to
> concurrently process register accesses to the *same* set of registers. I
> think it's rare for hardware register interfaces to be designed like
> that.
> 
> This could be a mistake, of course. If someone knows a device that needs
> multiple in-flight register accesses, please let us know.
> 
> Stefan


