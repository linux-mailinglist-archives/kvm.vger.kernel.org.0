Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4EB2CD975
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 15:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730944AbgLCOmJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 09:42:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46868 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730679AbgLCOmJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 09:42:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607006441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T5j/qaDVRz25VY+iI2jcR1uQXols0jMpdkcdY1NruHM=;
        b=R1pTpCXXCMBRSaa6n8gihMyn1LphYBgFk+9euJXw1BIb9V/vyCGWpE0cE6jWaHjCei0uSK
        jazQXLXokjbvgOrzEDl7FZmW2fn1pWyGkH0FbwZnpa2XccGakoJvR9ATjR52MP4xEHCHap
        jE/1sY3JJrHMz8HijHqd4ufdPrktMBk=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-qWXL6DPGPxafWGpczODlRQ-1; Thu, 03 Dec 2020 09:40:40 -0500
X-MC-Unique: qWXL6DPGPxafWGpczODlRQ-1
Received: by mail-qv1-f71.google.com with SMTP id l15so1781215qvu.8
        for <kvm@vger.kernel.org>; Thu, 03 Dec 2020 06:40:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T5j/qaDVRz25VY+iI2jcR1uQXols0jMpdkcdY1NruHM=;
        b=Csghj7inhn2G36yQjvhIaB7IBGG0g4alaZdnn8h25I9BCZU/E/IfnLLitifrtZdRfY
         klicFmpuFI7fcqMcEILwM4bpf+9v2owgGzjlvfmLfy7EHoEh1rulymlxwg/66wRWiFxU
         GW2Lb6L5Pd/B+aRMirqFdXgrcM17GugyHuzROKdioU3lrlEdk+2/KXt/V7yw+oF4FAm9
         +wpRFbCpUoSVK92qvO/AYA71uuTPRTQUIK8mmDRSEX/OpwO65uCK2VyYsVpO2KykQF1j
         +gpUxMkvRePG5snvHDJxejvn03zzCaNxekDsmipKpt5E7cGRUSiFJr33xxO/4AhdCcvv
         JWLA==
X-Gm-Message-State: AOAM531z/BNWusqwTUAtqIVJN0e4Oh+KoLYXv1ac7Svsn81SyiOZrGai
        aEZ7KMhzLKoW4HtP1665KT4dG0hI8GK+Avj2WZKd6XrRPRsb+VVFv+NMsJNysbuWnBCVcTTk3Pp
        54LWZvJZV9dXi
X-Received: by 2002:a0c:9003:: with SMTP id o3mr3502843qvo.62.1607006440075;
        Thu, 03 Dec 2020 06:40:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyEhsCczS2n7a26uwOlTW2+3VP7AsM5GQQ4R8zClSG6uUWjKYZzwgu7tzRH0bcAdATued7tnQ==
X-Received: by 2002:a0c:9003:: with SMTP id o3mr3502811qvo.62.1607006439785;
        Thu, 03 Dec 2020 06:40:39 -0800 (PST)
Received: from xz-x1 ([142.126.94.187])
        by smtp.gmail.com with ESMTPSA id 72sm1573006qkn.44.2020.12.03.06.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 06:40:39 -0800 (PST)
Date:   Thu, 3 Dec 2020 09:40:37 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org,
        mst@redhat.com, john.g.johnson@oracle.com, dinechin@redhat.com,
        cohuck@redhat.com, jasowang@redhat.com, felipe@nutanix.com,
        elena.ufimtseva@oracle.com, jag.raman@oracle.com
Subject: Re: MMIO/PIO dispatch file descriptors (ioregionfd) design discussion
Message-ID: <20201203144037.GG108496@xz-x1>
References: <88ca79d2e378dcbfb3988b562ad2c16c4f929ac7.camel@gmail.com>
 <20201202180628.GA100143@xz-x1>
 <20201203111036.GD689053@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
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

Yes I think kvm capability can be used as a way for the handshake between VMM
and KVM.  However I'm not sure how to do similar things to the emulation
process besides passing over the ioregionfd, because that's between VMM and the
emulation process.  Is there a way to do so with current proposasl?

The out-of-order feature may not be a good enough example if it's destined to
be useless... but let's just imagine we have such a requirement as an extention
to the current wire protocol.  What I was thinking was whether we could have
another handshake somehow to the emulation process, so that we can identify "ok
this emulation process supports out-of-band" or vice versa.  Only with that
information could VMM enable/disable the out-of-band in KVM.

The handshake to the emulation process can start from either VMM or KVM.  And
my previous idea was simply let KVM and emualtion process talk rather than VMM
against the emulation, because they really look like two isolated protocols:

  - The VMM <-> KVM talks via KVM_SET_IOREGIONFD, it is only responsible to
    setup a mmio/pio region in the guest and create the fd. As long as the
    region is properly setup, and the fd is passed over to emulation process,
    it's done as a proxy layer.

  - The KVM <-> emulation process talks via the wire protocol (so this protocol
    can be irrelevant to KVM_SET_IOREGIONFD protocol itself).  For example the
    out-of-band feature changes the behavior of the wire protocol.  Ideally it
    does not even need a new KVM capability because KVM_SET_IOREGIONFD
    functionality shouldn't be touched.

I thought it would be cleaner to have these protocols separate, but I could
also be wrong or over-engineering.

Thanks,

-- 
Peter Xu

