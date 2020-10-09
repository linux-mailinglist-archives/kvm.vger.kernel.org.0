Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E0B288720
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 12:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387775AbgJIKmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 06:42:03 -0400
Received: from mga17.intel.com ([192.55.52.151]:53580 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387763AbgJIKmC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 06:42:02 -0400
IronPort-SDR: WrvfIwYBRrG7Sd5TxuGgMevs8BNLVe53ACF5mgUoU7eO18SzhxMkZjdOMC+w7+aqtrDa7/Ju31
 F5+AYR8WmFmA==
X-IronPort-AV: E=McAfee;i="6000,8403,9768"; a="145334129"
X-IronPort-AV: E=Sophos;i="5.77,354,1596524400"; 
   d="scan'208";a="145334129"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 03:42:01 -0700
IronPort-SDR: D5eqKzTjS4VWkdDx7L10EJhvpJmbWpaNFT2AjYNswUUzxVgophba1dI0Vl4ciDLSRhrLHR2HwJ
 Z2f9ybtMlUDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,354,1596524400"; 
   d="scan'208";a="316996829"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by orsmga006.jf.intel.com with SMTP; 09 Oct 2020 03:41:55 -0700
Received: by stinkbox (sSMTP sendmail emulation); Fri, 09 Oct 2020 13:41:54 +0300
Date:   Fri, 9 Oct 2020 13:41:54 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Kees Cook <keescook@chromium.org>,
        KVM list <kvm@vger.kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 17/17] drm/i915: Properly request PCI BARs
Message-ID: <20201009104154.GR6112@intel.com>
References: <20201009075934.3509076-1-daniel.vetter@ffwll.ch>
 <20201009075934.3509076-18-daniel.vetter@ffwll.ch>
 <20201009094750.GQ6112@intel.com>
 <CAKMK7uH3o3hnRkTDqr93PR=wuRejpty+AbyMacoEFDDb6OgJeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKMK7uH3o3hnRkTDqr93PR=wuRejpty+AbyMacoEFDDb6OgJeQ@mail.gmail.com>
X-Patchwork-Hint: comment
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 09, 2020 at 12:01:39PM +0200, Daniel Vetter wrote:
> On Fri, Oct 9, 2020 at 11:47 AM Ville Syrjälä
> <ville.syrjala@linux.intel.com> wrote:
> >
> > On Fri, Oct 09, 2020 at 09:59:34AM +0200, Daniel Vetter wrote:
> > > When trying to test my CONFIG_IO_STRICT_DEVMEM changes I realized they
> > > do nothing for i915. Because i915 doesn't request any regions, like
> > > pretty much all drm pci drivers. I guess this is some very old
> > > remnants from the userspace modesetting days, when we wanted to
> > > co-exist with the fbdev driver. Which usually requested these
> > > resources.
> > >
> > > But makes me wonder why the pci subsystem doesn't just request
> > > resource automatically when we map a bar and a pci driver is bound?
> > >
> > > Knowledge about which pci bars we need kludged together from
> > > intel_uncore.c and intel_gtt.c from i915 and intel-gtt.c over in the
> > > fake agp driver.
> > >
> > > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > > Cc: Kees Cook <keescook@chromium.org>
> > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: John Hubbard <jhubbard@nvidia.com>
> > > Cc: Jérôme Glisse <jglisse@redhat.com>
> > > Cc: Jan Kara <jack@suse.cz>
> > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > Cc: linux-mm@kvack.org
> > > Cc: linux-arm-kernel@lists.infradead.org
> > > Cc: linux-samsung-soc@vger.kernel.org
> > > Cc: linux-media@vger.kernel.org
> > > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > > Cc: linux-pci@vger.kernel.org
> > > ---
> > >  drivers/gpu/drm/i915/intel_uncore.c | 25 +++++++++++++++++++++++--
> > >  1 file changed, 23 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/gpu/drm/i915/intel_uncore.c b/drivers/gpu/drm/i915/intel_uncore.c
> > > index 54e201fdeba4..ce39049d8919 100644
> > > --- a/drivers/gpu/drm/i915/intel_uncore.c
> > > +++ b/drivers/gpu/drm/i915/intel_uncore.c
> > > @@ -1692,10 +1692,13 @@ static int uncore_mmio_setup(struct intel_uncore *uncore)
> > >       struct pci_dev *pdev = i915->drm.pdev;
> > >       int mmio_bar;
> > >       int mmio_size;
> > > +     int bar_selection;
> >
> > Signed bitmasks always make me uneasy. But looks like
> > that's what it is in the pci api. So meh.
> 
> Yeah it's surprising.
> 
> > > +     int ret;
> > >
> > >       mmio_bar = IS_GEN(i915, 2) ? 1 : 0;
> > > +     bar_selection = BIT (2) | BIT(mmio_bar);
> >                            ^
> > spurious space
> >
> > That's also not correct for gen2 I think.
> >
> > gen2:
> > 0 = GMADR
> > 1 = MMADR
> > 2 = IOBAR
> >
> > gen3:
> > 0 = MMADR
> > 1 = IOBAR
> > 2 = GMADR
> > 3 = GTTADR
> >
> > gen4+:
> > 0+1 = GTTMMADR
> > 2+3 = GMADR
> > 4 = IOBAR
> >
> > Maybe we should just have an explicit list of bars like that in a
> > comment?
> >
> > I'd also suggest sucking this bitmask calculation into a small helper
> > so you can reuse it for the release.
> 
> tbh I just hacked this up for testing. Given how almost no other drm
> driver does this, I'm wondering whether we should or not.
> 
> Also the only reason why I didn't just use the pci_request_regions
> helper is to avoid the vga ioport range, since that's managed by
> vgaarbiter.

VGA io range isn't part of any bar. Or do you mean just the io decode
enable bit in the pci command register? That should be just a matter
or pci_enable_device() vs. pci_enable_device_mem() I think. So nothing
to do with which bars we've requested IIRC.

> 
> So I think if we go for this for real we should:
> - register the vga ioport range in the vgaarbiter
> - have a pci_request_iomem_regions helper that grabs all mem bars
> - roll that out to all drm pci drivers
> 
> Or something like that. The other complication is when we resize the
> iobar. So not really sure what to do here.

We resize it?

-- 
Ville Syrjälä
Intel
