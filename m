Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306BF493D39
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 16:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355703AbiASPc1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 10:32:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46741 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238390AbiASPc0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 10:32:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642606346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+HB+fYL0hLN4RNs9/F3dnnsrhWkgsUgJj1l1i2s/KNM=;
        b=HW3nALXxu83uSGt7l/WwYZpTDpnXg7Alh9RquBLvhEJJKht9MNCXXHib1pKDlu0rSFnaLQ
        7+/N2D646IOWQh8g5MkyldAgtqlvVnT1EAdeA5tTSuizC0nnPcg2ULtjH2528kU95O0lDa
        fx2uYRs0OjXxazVUXhj2z6qPwDNjYH0=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-JoJWRmoLOm-Lh9Ur5mDAMQ-1; Wed, 19 Jan 2022 10:32:24 -0500
X-MC-Unique: JoJWRmoLOm-Lh9Ur5mDAMQ-1
Received: by mail-oi1-f200.google.com with SMTP id q127-20020aca5c85000000b002c724c26e41so1955475oib.1
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 07:32:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+HB+fYL0hLN4RNs9/F3dnnsrhWkgsUgJj1l1i2s/KNM=;
        b=FYhTn2nJqRjneyVb0Ffm/I43DvY0sB1up7vnClE1MoVDLY9z3dnyyr6WcSll1JryHZ
         r5zzaCcoSk9W8CYiBuAiOIXmHMM2ZiMoyy18ZVGYPoQSLVJbcCQJFJwYwoXjojvilcxp
         1a/gxZQvwaBOtqygVen97FTd4mPzERNRsBs6bv2ai/PqL+qFwFc0HZqYk/G8QEOfuzs1
         1DC1senHGfQ3/TEire8DqBf6UWm8p4HR7KsP0Q1kGvpgRW1NLAyylQwfCdqjXwlnAoPY
         IiFuXkNQKGlEwwxFoU3szkFR1vrpxU7LFliEMRH4MATTiq13vH+X/Xbq0h382Uf3reiK
         Bf5A==
X-Gm-Message-State: AOAM532MTCojnXJwKuUCT7AoPTZcttA6rPY5IN8QiS4wTAgHocVPZNJV
        8Qh5nnaOA9gpveLsyi8fdYqxy+7vKrvjyq40NEauyhVlD46BadwxPSP9XXAql2f4JgARLY+dwN3
        FM7mxkRXKC4pJ
X-Received: by 2002:aca:1008:: with SMTP id 8mr3467364oiq.52.1642606344082;
        Wed, 19 Jan 2022 07:32:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyYfRKyZ3FttVsjca9b1NVGH9Zd2cRZOmoDjkdXrCfypoHqatilmKkR2wKak40MPjLvrKvRMQ==
X-Received: by 2002:aca:1008:: with SMTP id 8mr3467341oiq.52.1642606343804;
        Wed, 19 Jan 2022 07:32:23 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id 44sm5760otl.15.2022.01.19.07.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 07:32:23 -0800 (PST)
Date:   Wed, 19 Jan 2022 08:32:22 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Message-ID: <20220119083222.4dc529a4.alex.williamson@redhat.com>
In-Reply-To: <20220118210048.GG84788@nvidia.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
        <20220118125522.6c6bb1bb.alex.williamson@redhat.com>
        <20220118210048.GG84788@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Jan 2022 17:00:48 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Jan 18, 2022 at 12:55:22PM -0700, Alex Williamson wrote:
> > On Fri, 14 Jan 2022 15:35:14 -0400
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > Clarify how the migration API works by recasting its specification from a
> > > bunch of bits into a formal FSM. This describes the same functional
> > > outcome, with no practical ABI change.  
> > 
> > I don't understand why we're so reluctant to drop the previous
> > specification and call this v2.   
> 
> I won't object - but I can't say it is really necessary.
> 
> > Yes, it's clever that the enum for the FSM matches the bit
> > definitions, but we're also inserting previously invalid states as a
> > standard part of the device flow... (see below)  
> 
> This is completely invisible to userspace, if userspace never writes
> the new states to device_state it can never read them back.
> 
> > > This is RFC because the full series is not fully tested yet, that should be
> > > done next week. The series can be previewed here:
> > > 
> > >   https://github.com/jgunthorpe/linux/commits/mlx5_vfio_pci
> > > 
> > > The mlx5 implementation of the state change:
> > > 
> > >   https://github.com/jgunthorpe/linux/blob/0a6416da226fe8ee888aa8026f1e363698e137a8/drivers/vfio/pci/mlx5/main.c#L264
> > > 
> > > Has turned out very clean. Compare this to the v5 version, which is full of
> > > subtle bugs:
> > > 
> > >   https://lore.kernel.org/kvm/20211027095658.144468-12-yishaih@nvidia.com/
> > > 
> > > This patch adds the VFIO_DEVICE_MIG_ARC_SUPPORTED ioctl:
> > > 
> > >   https://github.com/jgunthorpe/linux/commit/c92eff6c2afd1ecc9ed5c67a1f81c7f270f6e940
> > > 
> > > And this shows how the Huawei driver should opt out of P2P arcs:
> > > 
> > >   https://github.com/jgunthorpe/linux/commit/dd2571c481d27546a33ff4583ce8ad49847fe300  
> > 
> > We've been bitten several times by device support that didn't come to
> > be in this whole vfio migration effort.  
> 
> Which is why this patch is for Huawei not mlx5..
> 
> > At some point later hns support is ready, it supports the migration
> > region, but migration fails with all existing userspace written to the
> > below spec.  I can't imagine that a device advertising migration, but it
> > being essentially guaranteed to fail is a viable condition and we can't
> > retroactively add this proposed ioctl to existing userspace binaries.
> > I think our recourse here would be to rev the migration sub-type again
> > so that userspace that doesn't know about devices that lack P2P won't
> > enable migration support.  
> 
> Global versions are rarely a good idea. What happens if we have three
> optional things, what do you set the version to in order to get
> maximum compatibility?
> 
> For the scenario you describe it is much better for qemu to call
> VFIO_DEVICE_MIG_ARC_SUPPORTED on every single transition it intends to
> use when it first opens the device. If any fail then it can deem the
> device as having some future ABI and refuse to use it with migration.

This misses the point of the thought experiment,
VFIO_DEVICE_MIG_ARC_SUPPORTED is not defined here, it's defined in some
adjacent commit.  The migration region sub-type is not a global
version, it's one of the means we have built in to the device specific
region API for allowing compatibility breaks.  Userspace that only
knows about v1 migration sub-types will not look at v2 sub-types.

> > So I think this ends up being a poor example of how to extend the uAPI.
> > An opt-out for part of the base specification is hard, it's much easier
> > to opt-in P2P as a feature.  
> 
> I'm not sure I understand this 'base specification'. 
> 
> My remark was how we took current qemu as an ABI added P2P to the
> specification and defined it in a way that is naturally backwards
> compatible and is still well specified.

Ok, this is backwards.  In the patch proposed here, ie. what I'm
referring to as the base specification, we're adding new states that
effectively userspace isn't allowed to use because we're trying to
subtly maintain backwards compatibility with existing userspace, but
then in a follow-on patch add a new ioctl that userspace is required to
use to validate state transitions.  Isn't the requirement to use the
new ioctl enough to demand a compatibility break?

If the order was to propose a new FSM uAPI compatible to the existing
bit definitions without the P2P states, then add a new ioctl and P2P
states, and require userspace to use the ioctl to validate support for
those new P2P states, I might be able to swallow that.

The value of maintaining compatibility with the v1 migration sub-type
is essentially nil afaict.  If we consider proprietary drivers with
existing releases that include v1 migration support and hypervisor
vendors that might ignore the experimental nature of QEMU support, I'd
just rather avoid any potential headaches.  In-kernel drivers
should expose a v2 migration sub-type based on the FSM uAPI and probing
ioctl, v1 is deprecated and dropped from QEMU.  Thanks,

Alex

