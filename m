Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7784D2A7AAA
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 10:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731103AbgKEJeP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 04:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730833AbgKEJeO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 04:34:14 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09464C0613CF
        for <kvm@vger.kernel.org>; Thu,  5 Nov 2020 01:34:14 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id k18so872863wmj.5
        for <kvm@vger.kernel.org>; Thu, 05 Nov 2020 01:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=dhezt058VYAXUzsmT6wFAloMyt6Frs+cE6TCkSAcHPs=;
        b=ST87g3boTQObR5JxsvDJGIfMAlcgsXvr+F3JKuft7VsNKm+GuZmFkRWYBz/N9m+nP5
         gUOFOdjErnnQz3ZNReWuFokDdnl7uPc7ZMOj6kqNide21CEbt+Pus48kXLDRURvnNC2N
         3RAKhoWa6Hje1zG3vURpcraCOdJW7Q+XZ+t28=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=dhezt058VYAXUzsmT6wFAloMyt6Frs+cE6TCkSAcHPs=;
        b=em5zQJD9UvQX2hERmAbsWQdFNrYo/PDplC48Zng7g+JtZ5JqkldGrXJsOvu3Gq//71
         atuww07Wme/P+9JM4Eg8RZgorTbc8xmtzxt9FGqX7c1C6fT6r4UQpQMfYhDw7ibNKWDV
         GBJYMxBoLvREruU2dpmvUWIkcG9f4fz/VeeqzfRtCdMdzMXz2tXitq/glSvjzY0aSaIu
         JuB6Y8byucoRWko9B84DO0zGYcSKkcsqNPmJfC6dB7fyieKfo264lq5dPcIoU/jzMh/J
         /t1guS2pk4+XU12F9Zb8156KQCYenkJTiHpye5ZQ1qfsDpobTJzz+Z/GB6iRkIM6PPDt
         m98w==
X-Gm-Message-State: AOAM532lt9D3UbGgMU7d5XS/5R07/h66/RZjf/yF//FuVmryXxQnG0gh
        zoH4e5KXpVKjoMmfqLN9rSzCbQ==
X-Google-Smtp-Source: ABdhPJwBx2+thaZ4Z7KLrdw1GbhrDGTHyh3vgC78jGbXnmbFtcgLmot8B2SlqilS+tbAOr47w4H/Mg==
X-Received: by 2002:a1c:21c1:: with SMTP id h184mr1802586wmh.106.1604568852772;
        Thu, 05 Nov 2020 01:34:12 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id s202sm1648809wme.39.2020.11.05.01.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 01:34:11 -0800 (PST)
Date:   Thu, 5 Nov 2020 10:34:09 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v5 11/15] PCI: Obey iomem restrictions for procfs mmap
Message-ID: <20201105093409.GR401619@phenom.ffwll.local>
Mail-Followup-To: Dan Williams <dan.j.williams@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>
References: <CAKMK7uF0QjesaNs97N-G8cZkXuAmFgcmTfHvoCP94br_WVcV6Q@mail.gmail.com>
 <20201104165017.GA352206@bjorn-Precision-5520>
 <CAPcyv4idORJzHVD2vCOnO3REqWHKVn_-otOzTBf0HhcWq4iJRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4idORJzHVD2vCOnO3REqWHKVn_-otOzTBf0HhcWq4iJRQ@mail.gmail.com>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 04, 2020 at 12:12:15PM -0800, Dan Williams wrote:
> On Wed, Nov 4, 2020 at 8:50 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> >
> > On Wed, Nov 04, 2020 at 09:44:04AM +0100, Daniel Vetter wrote:
> > > On Tue, Nov 3, 2020 at 11:09 PM Dan Williams <dan.j.williams@intel.com> wrote:
> > > > On Tue, Nov 3, 2020 at 1:28 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > > > > On Fri, Oct 30, 2020 at 11:08:11AM +0100, Daniel Vetter wrote:
> > > > > > There's three ways to access PCI BARs from userspace: /dev/mem, sysfs
> > > > > > files, and the old proc interface. Two check against
> > > > > > iomem_is_exclusive, proc never did. And with CONFIG_IO_STRICT_DEVMEM,
> > > > > > this starts to matter, since we don't want random userspace having
> > > > > > access to PCI BARs while a driver is loaded and using it.
> > > > > >
> > > > > > Fix this by adding the same iomem_is_exclusive() check we already have
> > > > > > on the sysfs side in pci_mmap_resource().
> > > > > >
> > > > > > References: 90a545e98126 ("restrict /dev/mem to idle io memory ranges")
> > > > > > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > > > >
> > > > > This is OK with me but it looks like IORESOURCE_EXCLUSIVE is currently
> > > > > only used in a few places:
> > > > >
> > > > >   e1000_probe() calls pci_request_selected_regions_exclusive(),
> > > > >   ne_pci_probe() calls pci_request_regions_exclusive(),
> > > > >   vmbus_allocate_mmio() calls request_mem_region_exclusive()
> > > > >
> > > > > which raises the question of whether it's worth keeping
> > > > > IORESOURCE_EXCLUSIVE at all.  I'm totally fine with removing it
> > > > > completely.
> > > >
> > > > Now that CONFIG_IO_STRICT_DEVMEM upgrades IORESOURCE_BUSY to
> > > > IORESOURCE_EXCLUSIVE semantics the latter has lost its meaning so I'd
> > > > be in favor of removing it as well.
> > >
> > > Still has some value since it enforces exclusive access even if the
> > > config isn't enabled, and iirc e1000 had some fun with userspace tools
> > > clobbering the firmware and bricking the chip.
> >
> > There's *some* value; I'm just skeptical since only three drivers use
> > it.
> >
> > IORESOURCE_EXCLUSIVE is from e8de1481fd71 ("resource: allow MMIO
> > exclusivity for device drivers"), and the commit message says this is
> > only active when CONFIG_STRICT_DEVMEM is set.  I didn't check to see
> > whether that's still true.
> >
> > That commit adds a bunch of wrappers and "__"-prefixed functions to
> > pass the IORESOURCE_EXCLUSIVE flag around.  That's a fair bit of
> > uglification for three drivers.
> >
> > > Another thing I kinda wondered, since pci maintainer is here: At least
> > > in drivers/gpu I see very few drivers explicitly requestion regions
> > > (this might be a historical artifact due to the shadow attach stuff
> > > before we had real modesetting drivers). And pci core doesn't do that
> > > either, even when a driver is bound. Is this intentional, or
> > > should/could we do better? Since drivers work happily without
> > > reserving regions I don't think "the drivers need to remember to do
> > > this" will ever really work out well.
> >
> > You're right, many drivers don't call pci_request_regions().  Maybe we
> > could do better, but I haven't looked into that recently.  There is a
> > related note in Documentation/PCI/pci.rst that's been there for a long
> > time (it refers to "pci_request_resources()", which has never existed
> > AFAICT).  I'm certainly open to proposals.
> 
> It seems a bug that the kernel permits MMIO regions with side effects
> to be ioremap()'ed without request_mem_region() on the resource. I
> wonder how much log spam would happen if ioremap() reported whenever a
> non-IORESOURE_BUSY range was passed to it? The current state of
> affairs to trust *remap users to have claimed their remap target seems
> too ingrained to unwind now.

Yeah I think that's hopeless. I think the only feasible approach is if bus
drivers claim resources by default when a driver is bound (it should nest,
so if the driver claims again, I think that should all keep working), just
using the driver name. Probably with some special casing for legacy io
(vgaarb.c should claim these I guess). Still probably tons of fallout.

Once that's rolled out to all bus drivers we could perhaps add the ioremap
check without drowning in log spam. Still a multi-year project I think :-/
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
