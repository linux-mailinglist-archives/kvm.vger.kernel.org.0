Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A4243B4CB
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 16:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235211AbhJZOxw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 10:53:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36015 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230324AbhJZOxv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Oct 2021 10:53:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635259887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QiyqNdatw3NhazMeX0fRhEhJxRWOX6NB4RyRlxaJtOo=;
        b=CJTNyxjEjxajVy+bxeJtcR7deSuasp7rw9ea3QnRKTFFXt/7n3ypr7LLifWLxf7VQ/FMnu
        X9hVwkJXyLO6ihNIzsj94M+WSOZpwS2e9bpBPq2Zsvcqrxqk5QI22sabjDIPwn/0JnpWNH
        XVGpB6xXaoDqLHa41+K1m9YoJ+RV/ko=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-I3XLLqBaNcq_R3PRr0_hGA-1; Tue, 26 Oct 2021 10:51:26 -0400
X-MC-Unique: I3XLLqBaNcq_R3PRr0_hGA-1
Received: by mail-wm1-f71.google.com with SMTP id u14-20020a05600c19ce00b0030d8549d49aso772766wmq.0
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 07:51:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QiyqNdatw3NhazMeX0fRhEhJxRWOX6NB4RyRlxaJtOo=;
        b=5rbgtEr4iXZTO0XG5BfNxNV+NdhDxN9hwN/JjQks6V8HsLaR9Z58rvbNxlYiiYR1pF
         LVhFR3n1g9HoLthv/Fj/rcN10u1oCt3WiW+BkND9Gp/mkFF76j+5F2E9S7AquC7Ih7ub
         EqnJ1hxz80W2S3OlzaDtWUrLM/N8Jlm9qk4owhAmAAqmvx4cwsBVDvz51EdojyElfDJp
         Ani5L0xKVrl2QlIsitRyHgTWl2aVeOB5iFfFvK6c5MD2KKspdtoOeuPQ2G61e5hBBWpN
         CYsTc5CBmHsDIENkq5PfSCmZ9GigkaemCme824h3xK3kfSrbSu67K3cuMnJTA88e5IPG
         Ei2g==
X-Gm-Message-State: AOAM531DMevxCIiVZ/twwrxNFUrfd6Almk9rPDk0y//j20ZmoaI0+nFQ
        Lb+SeKssMB2RAqrokruA6jhLcIsmlmwJSYIRpP/eDBKm+jA/eDjhrm4CSiejuGHfNb1g1ix105g
        vpPomx1by6Kpc
X-Received: by 2002:a7b:cb56:: with SMTP id v22mr33926997wmj.77.1635259884719;
        Tue, 26 Oct 2021 07:51:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmzKviO2aTymPZ9XHNdwt+tg8/6pDTBfRAG1Cu7P2+mHxfgMMP94xGln5DErv9xT3PJAICxw==
X-Received: by 2002:a7b:cb56:: with SMTP id v22mr33926975wmj.77.1635259884518;
        Tue, 26 Oct 2021 07:51:24 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id n15sm2162091wmq.3.2021.10.26.07.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 07:51:23 -0700 (PDT)
Date:   Tue, 26 Oct 2021 15:51:21 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <YXgV6ehhsSlydiEl@work-vm>
References: <20211019124352.74c3b6ba.alex.williamson@redhat.com>
 <20211019192328.GZ2744544@nvidia.com>
 <20211019145856.2fa7f7c8.alex.williamson@redhat.com>
 <20211019230431.GA2744544@nvidia.com>
 <5a496713-ae1d-11f2-1260-e4c1956e1eda@nvidia.com>
 <20211020105230.524e2149.alex.williamson@redhat.com>
 <YXbceaVo0q6hOesg@work-vm>
 <20211025115535.49978053.alex.williamson@redhat.com>
 <YXb7wejD1qckNrhC@work-vm>
 <20211026082920.1f302a45.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026082920.1f302a45.alex.williamson@redhat.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Alex Williamson (alex.williamson@redhat.com) wrote:
> On Mon, 25 Oct 2021 19:47:29 +0100
> "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
> 
> > * Alex Williamson (alex.williamson@redhat.com) wrote:
> > > On Mon, 25 Oct 2021 17:34:01 +0100
> > > "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
> > >   
> > > > * Alex Williamson (alex.williamson@redhat.com) wrote:  
> > > > > [Cc +dgilbert, +cohuck]
> > > > > 
> > > > > On Wed, 20 Oct 2021 11:28:04 +0300
> > > > > Yishai Hadas <yishaih@nvidia.com> wrote:
> > > > >     

<snip>

> > > In a way.  We're essentially recognizing that we cannot stop a single
> > > device in isolation of others that might participate in peer-to-peer
> > > DMA with that device, so we need to make a pass to quiesce each device
> > > before we can ask the device to fully stop.  This new device state bit
> > > is meant to be that quiescent point, devices can accept incoming DMA
> > > but should cease to generate any.  Once all device are quiesced then we
> > > can safely stop them.  
> > 
> > It may need some further refinement; for example in that quiesed state
> > do counters still tick? will a NIC still respond to packets that don't
> > get forwarded to the host?
> 
> I'd think no, but I imagine it's largely device specific to what extent
> a device can be fully halted yet minimally handle incoming DMA.

That's what worries me; we're adding a new state here as we understand
more about trying to implement a device; but it seems that we need to
nail something down as to what the state means.

> > Note I still think you need a way to know when you have actually reached
> > these states; setting a bit in a register is asking nicely for a device
> > to go into a state - has it got there?
> 
> It's more than asking nicely, we define the device_state bits as
> synchronous, the device needs to enter the state before returning from
> the write operation or return an errno.

I don't see how it can be synchronous in practice; can it really wait to
complete if it has to take many cycles to finish off an inflight DMA
before it transitions?

> > > > Now, you could be a *little* more sloppy; you could allow a device carry
> > > > on doing stuff purely with it's own internal state up until the point
> > > > it needs to serialise; but that would have to be strictly internal state
> > > > only - if it can change any other devices state (or issue an interrupt,
> > > > change RAM etc) then you get into ordering issues on the serialisation
> > > > of multiple devices.  
> > > 
> > > Yep, that's the proposal that doesn't require a uAPI change, we loosen
> > > the definition of stopped to mean the device can no longer generate DMA
> > > or interrupts and all internal processing outside or responding to
> > > incoming DMA should halt (essentially the same as the new quiescent
> > > state above).  Once all devices are in this state, there should be no
> > > incoming DMA and we can safely collect per device migration data.  If
> > > state changes occur beyond the point in time where userspace has
> > > initiated the collection of migration data, drivers have options for
> > > generating errors when userspace consumes that data.  
> > 
> > How do you know that last device has actually gone into that state?
> 
> Each device cannot, the burden is on the user to make sure all devices
> are stopped before proceeding to read migration data.

Yeh this really ties to the previous question; if it's synchronous
you're OK.

> > Also be careful; it feels much more delicate where something might
> > accidentally start a transaction.
> 
> This sounds like a discussion of theoretically broken drivers.  Like
> the above device_state, drivers still have a synchronization point when
> the user reads the pending_bytes field to initiate retrieving the
> device state.  If the implementation requires the device to be fully
> stopped to snapshot the device state to provide to the user, this is
> where that would happen.  Thanks,

Yes, but I worry that some ways of definining it are harder to get right
in drivers, so less likely to be theoretical.

Dave

> Alex
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

