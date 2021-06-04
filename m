Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAD439B100
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 05:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhFDDmB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 23:42:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51745 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229775AbhFDDmA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Jun 2021 23:42:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622778014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aFUnYpKRreDc48wVwuXCdbokDvF9b+3ny8yIoFA0wCM=;
        b=amDeYvdCtCn1iUg1XfCfRvzF+WZn1mR2WDOmWc+VGfybhwYMmtskVlp5kw8i5N1WX7Hgdw
        yKIEATS9jwDKFa5mHOqtk0OCGmLnA1p76Q1SWdDiDTvQbOgKLsGHlErveLnVcSGPSAcNOQ
        pArJlzk92lTCllTJK/skI2o0vunJUUk=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578-rYu-BtsWOluyMGMy03v64g-1; Thu, 03 Jun 2021 23:40:12 -0400
X-MC-Unique: rYu-BtsWOluyMGMy03v64g-1
Received: by mail-ot1-f70.google.com with SMTP id u12-20020a9d4d8c0000b02902dcb6679ca2so4345968otk.20
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 20:40:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aFUnYpKRreDc48wVwuXCdbokDvF9b+3ny8yIoFA0wCM=;
        b=uRhPfXMFCKYOqm4XUgLiCqvonaRC58tIxwdN6lKxKoqZ9Do82lKzlNbPFHnpPhW+ZM
         pD6fJz39aO6vE1f3yTtd77EYHWGPiHAbXOR6/AcMByTn/saA/dN2ynK7o2ahRd2aE914
         kgOTA2abpphnthygMUID1gGWQxus0OFGfV54wjaHucGA5n00Efyoz0v3bsNda/IrIH3R
         ohWUUkdjytVA69Dit7B7igGgYJ1vofZgwTrsav5wFzueeFAik7EstOznictYuuxE1SUB
         aR5OGUZZpfD/IDdRvRlckVqS4m+jbfpwWdJiZZT/1O6hPKSCcbA+ZUWlS5hpfzagehlO
         EWRw==
X-Gm-Message-State: AOAM533CrRQJyGhBp96jUBtIKj4JWOFi/Wkz1SHK+BRyKKrAFiVWnzv2
        vo/wHhOO5K5cZcul8fAs+j6gCbRqcnl6YYOG+4C+3RZ87FV5Hq6a7tG2zsrz8LKr9kXAGVgJHiU
        WDPGnzAEOViHx
X-Received: by 2002:a54:4494:: with SMTP id v20mr1624073oiv.74.1622778012140;
        Thu, 03 Jun 2021 20:40:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxyoQSP7oUcYQgpMaIhA3jFP+XxgrJ7TW7ji9ff5F2mCl2XeqDgdz5AJt7rZgUmclwKq5uEIg==
X-Received: by 2002:a54:4494:: with SMTP id v20mr1624062oiv.74.1622778011907;
        Thu, 03 Jun 2021 20:40:11 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id d1sm223468otu.9.2021.06.03.20.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 20:40:11 -0700 (PDT)
Date:   Thu, 3 Jun 2021 21:40:09 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Dey, Megha" <megha.dey@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 00/20] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Message-ID: <20210603214009.68fac0c4.alex.williamson@redhat.com>
In-Reply-To: <MWHPR11MB1886D613948986530E9B61CB8C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
        <20210523232219.GG1002214@nvidia.com>
        <86cde154-37c7-c00d-b0c6-06b15b50dbf7@intel.com>
        <20210602231747.GK1002214@nvidia.com>
        <MWHPR11MB188664D9E7CA60782B75AC718C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210603014932.GN1002214@nvidia.com>
        <MWHPR11MB1886D613948986530E9B61CB8C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 3 Jun 2021 05:52:58 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, June 3, 2021 9:50 AM
> > 
> > On Thu, Jun 03, 2021 at 01:11:37AM +0000, Tian, Kevin wrote:
> >   
> > > Jason, can you clarify your attitude on mdev guid stuff? Are you
> > > completely against it or case-by-case? If the former, this is a big
> > > decision thus it's better to have consensus with Alex/Kirti. If the
> > > latter, would like to hear your criteria for when it can be used
> > > and when not...  
> > 
> > I dislike it generally, but it exists so <shrug>. I know others feel
> > more strongly about it being un-kernely and the wrong way to use sysfs.
> > 
> > Here I was remarking how the example in the cover letter made the mdev
> > part seem totally pointless. If it is pointless then don't do it.  
> 
> Is your point about that as long as a mdev requires pre-config
> through driver specific sysfs then it doesn't make sense to use
> mdev guid interface anymore?

Can you describe exactly what step 1. is doing in this case from the
original cover letter ("Enable wq with "mdev" wq type")?  That does
sound a bit like configuring something to use mdev then separately
going to the trouble of creating the mdev.  As Jason suggests, if a wq
is tagged for mdev/vfio, it could just register itself as a vfio bus
driver.

But if we want to use mdev, why doesn't available_instances for your
mdev type simply report all unassigned wq and the `echo $UUID > create`
grabs a wq for mdev?  That would remove this pre-config contention,
right?

> The value of mdev guid interface is providing a vendor-agnostic
> interface for mdev life-cycle management which allows one-
> enable-fit-all in upper management stack. Requiring vendor
> specific pre-config does blur the boundary here.

We need to be careful about using work-avoidance in the upper
management stack as a primary use case for an interface though.

> Alex/Kirt/Cornelia, what about your opinion here? It's better 
> we can have an consensus on when and where the existing
> mdev sysfs could be used, as this will affect every new mdev
> implementation from now on.

I have a hard time defining some fixed criteria for using mdev.  It's
essentially always been true that vendors could write their own vfio
"bus driver", like vfio-pci or vfio-platform, specific to their device.
Mdevs were meant to be a way for the (non-vfio) driver of a device to
expose portions of the device through mediation for use with vfio.  It
seems like that's largely being done here.

What I think has changed recently is this desire to make it easier to
create those vendor drivers and some promise of making module binding
work to avoid the messiness around picking a driver for the device.  In
the auxiliary bus case that I think Jason is working on, it sounds like
the main device driver exposes portions of itself on an auxiliary bus
where drivers on that bus can integrate into the vfio subsystem.  It
starts to get pretty fuzzy with what mdev already does, but it's also a
more versatile interface.  Is it right for everyone?  Probably not.

Is the pre-configuration issue here really a push vs pull problem?  I
can see the requirement in step 1. is dedicating some resources to an
mdev use case, so at that point it seems like the argument is whether we
should just create aux bus devices that get automatically bound to a
vendor vfio-pci variant and we avoid the mdev lifecycle, which is both
convenient and ugly.  On the other hand, mdev has more of a pull
interface, ie. here are a bunch of device types and how many of each we
can support, use create to pull what you need.

> > Remember we have stripped away the actual special need to use
> > mdev. You don't *have* to use mdev anymore to use vfio. That is a
> > significant ideology change even from a few months ago.
> >   
> 
> Yes, "don't have to" but if there is value of doing so  it's
> not necessary to blocking it? One point in my mind is that if
> we should minimize vendor-specific contracts for user to
> manage mdev or subdevice...

Again, this in itself is not a great justification for using mdev,
we're creating vendor specific device types with vendor specific
additional features, that could all be done via some sort of netlink
interface too.  The thing that pushes this more towards mdev for me is
that I don't think each of these wqs appear as devices to the host,
they're internal resources of the parent device and we want to compose
them in ways that are slightly more amenable to traditional mdevs... I
think.  Thanks,

Alex

