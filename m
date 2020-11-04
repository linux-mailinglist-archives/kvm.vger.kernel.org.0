Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19C32A5FC9
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 09:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgKDIoS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 03:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbgKDIoS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Nov 2020 03:44:18 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB586C0401C1
        for <kvm@vger.kernel.org>; Wed,  4 Nov 2020 00:44:15 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id t16so4045286oie.11
        for <kvm@vger.kernel.org>; Wed, 04 Nov 2020 00:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ycqoIkcF9lPtiJBVMgjq7zwCX8Gyu6JCtVXT12jKTV8=;
        b=SO6a9eIH6r+EzFThZ6MTARjwHEtx6LFHOpOvFgwKmnw7LjZXHcgycyhZfUmdSwXoni
         9VPCbgc6ODqmZSPJVN4eXwn3IqpRr3uXKNjrMKGfBOBHLutZLHhso+mS3OiPqxM7Q6/l
         K5a5NNqZWoxju2yJSN+OURI61y0XID3dk0Roo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ycqoIkcF9lPtiJBVMgjq7zwCX8Gyu6JCtVXT12jKTV8=;
        b=ewJeitFBpUpy4+ObkDP9s9/ExTEi0rXH/OstUj3n2BdLv6j8NmeAltVl2fTnzm8nGo
         dSa2zpihEuwfmC3AEiJmwTpw9rMGejv/4pj+PABQafb5xOgdt0EwAdYFfKq1JUQ6JhfJ
         iJD3D9EDjYTuGQCW6y3Qfql//c3WCo1nUFGJyGnwwW77h69iptc3AYxzN9rJ3TZrw08e
         TMXGEiJ9xzX86tQQkrqNObhR81Hn3LjSjUuYD25Ubq/9giTP4lxToPUTaajd/1naT+Wm
         RYgpi4SrxEczjKiSviXYetPI6rgOG3JH6Cozja5R+0ejlm6R9dNc584xoKY4F3Cp+bqt
         N7Rw==
X-Gm-Message-State: AOAM532Bg20eeQIFO2oPKm83pqhQeW/YEPJCsFfT6TxICgPgS2kB5KMm
        B4tUEfx2HI0xvygDXqebN9bhqHpNZCTGK8bdLw7/TA==
X-Google-Smtp-Source: ABdhPJzFeuCQlV5NJZ+3HUxdvXgtCAFGX/0rEF7qnn1uI6qUI3Z5/MsHqFAcH2CxUPAQE20CBPAAF7SeJ5phPHzYaRc=
X-Received: by 2002:aca:b141:: with SMTP id a62mr1813813oif.101.1604479455139;
 Wed, 04 Nov 2020 00:44:15 -0800 (PST)
MIME-Version: 1.0
References: <20201030100815.2269-12-daniel.vetter@ffwll.ch>
 <20201103212840.GA266427@bjorn-Precision-5520> <CAPcyv4jCGxWG0opLv4VzBRk5iLwu6CRse4DwF-otWkfXoGWe6A@mail.gmail.com>
In-Reply-To: <CAPcyv4jCGxWG0opLv4VzBRk5iLwu6CRse4DwF-otWkfXoGWe6A@mail.gmail.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Wed, 4 Nov 2020 09:44:04 +0100
Message-ID: <CAKMK7uF0QjesaNs97N-G8cZkXuAmFgcmTfHvoCP94br_WVcV6Q@mail.gmail.com>
Subject: Re: [PATCH v5 11/15] PCI: Obey iomem restrictions for procfs mmap
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
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
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 3, 2020 at 11:09 PM Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, Nov 3, 2020 at 1:28 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > On Fri, Oct 30, 2020 at 11:08:11AM +0100, Daniel Vetter wrote:
> > > There's three ways to access PCI BARs from userspace: /dev/mem, sysfs
> > > files, and the old proc interface. Two check against
> > > iomem_is_exclusive, proc never did. And with CONFIG_IO_STRICT_DEVMEM,
> > > this starts to matter, since we don't want random userspace having
> > > access to PCI BARs while a driver is loaded and using it.
> > >
> > > Fix this by adding the same iomem_is_exclusive() check we already have
> > > on the sysfs side in pci_mmap_resource().
> > >
> > > References: 90a545e98126 ("restrict /dev/mem to idle io memory ranges")
> > > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> >
> > This is OK with me but it looks like IORESOURCE_EXCLUSIVE is currently
> > only used in a few places:
> >
> >   e1000_probe() calls pci_request_selected_regions_exclusive(),
> >   ne_pci_probe() calls pci_request_regions_exclusive(),
> >   vmbus_allocate_mmio() calls request_mem_region_exclusive()
> >
> > which raises the question of whether it's worth keeping
> > IORESOURCE_EXCLUSIVE at all.  I'm totally fine with removing it
> > completely.
>
> Now that CONFIG_IO_STRICT_DEVMEM upgrades IORESOURCE_BUSY to
> IORESOURCE_EXCLUSIVE semantics the latter has lost its meaning so I'd
> be in favor of removing it as well.

Still has some value since it enforces exclusive access even if the
config isn't enabled, and iirc e1000 had some fun with userspace tools
clobbering the firmware and bricking the chip.

Another thing I kinda wondered, since pci maintainer is here: At least
in drivers/gpu I see very few drivers explicitly requestion regions
(this might be a historical artifact due to the shadow attach stuff
before we had real modesetting drivers). And pci core doesn't do that
either, even when a driver is bound. Is this intentional, or
should/could we do better? Since drivers work happily without
reserving regions I don't think "the drivers need to remember to do
this" will ever really work out well.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
