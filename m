Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31391288657
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 11:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733247AbgJIJsA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 05:48:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:44973 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733239AbgJIJr7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 05:47:59 -0400
IronPort-SDR: TT5eHq9C9NfcP3rTT4Lx/9biR7QcRrZnSVekCQ7QtdeIJSOO8fRk30zJcwBUnEvVg79MdnKxCQ
 Tgfne2NKF2Hg==
X-IronPort-AV: E=McAfee;i="6000,8403,9768"; a="165579189"
X-IronPort-AV: E=Sophos;i="5.77,354,1596524400"; 
   d="scan'208";a="165579189"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 02:47:57 -0700
IronPort-SDR: pPywwhoQ8IZ0oqnSyAy7Si9u7fhcqFsuiRTRfdjMWfQODPzT5+PsDTX8QsBMudIyk2KOf3VcKr
 TS88VD5e6ZZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,354,1596524400"; 
   d="scan'208";a="298385120"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by fmsmga008.fm.intel.com with SMTP; 09 Oct 2020 02:47:51 -0700
Received: by stinkbox (sSMTP sendmail emulation); Fri, 09 Oct 2020 12:47:50 +0300
Date:   Fri, 9 Oct 2020 12:47:50 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-s390@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Kees Cook <keescook@chromium.org>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-pci@vger.kernel.org,
        linux-mm@kvack.org,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 17/17] drm/i915: Properly request PCI BARs
Message-ID: <20201009094750.GQ6112@intel.com>
References: <20201009075934.3509076-1-daniel.vetter@ffwll.ch>
 <20201009075934.3509076-18-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201009075934.3509076-18-daniel.vetter@ffwll.ch>
X-Patchwork-Hint: comment
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 09, 2020 at 09:59:34AM +0200, Daniel Vetter wrote:
> When trying to test my CONFIG_IO_STRICT_DEVMEM changes I realized they
> do nothing for i915. Because i915 doesn't request any regions, like
> pretty much all drm pci drivers. I guess this is some very old
> remnants from the userspace modesetting days, when we wanted to
> co-exist with the fbdev driver. Which usually requested these
> resources.
> 
> But makes me wonder why the pci subsystem doesn't just request
> resource automatically when we map a bar and a pci driver is bound?
> 
> Knowledge about which pci bars we need kludged together from
> intel_uncore.c and intel_gtt.c from i915 and intel-gtt.c over in the
> fake agp driver.
> 
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Jérôme Glisse <jglisse@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: linux-mm@kvack.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/gpu/drm/i915/intel_uncore.c | 25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_uncore.c b/drivers/gpu/drm/i915/intel_uncore.c
> index 54e201fdeba4..ce39049d8919 100644
> --- a/drivers/gpu/drm/i915/intel_uncore.c
> +++ b/drivers/gpu/drm/i915/intel_uncore.c
> @@ -1692,10 +1692,13 @@ static int uncore_mmio_setup(struct intel_uncore *uncore)
>  	struct pci_dev *pdev = i915->drm.pdev;
>  	int mmio_bar;
>  	int mmio_size;
> +	int bar_selection;

Signed bitmasks always make me uneasy. But looks like
that's what it is in the pci api. So meh.

> +	int ret;
>  
>  	mmio_bar = IS_GEN(i915, 2) ? 1 : 0;
> +	bar_selection = BIT (2) | BIT(mmio_bar);
                           ^
spurious space			   

That's also not correct for gen2 I think.

gen2:
0 = GMADR
1 = MMADR
2 = IOBAR

gen3:
0 = MMADR
1 = IOBAR
2 = GMADR
3 = GTTADR

gen4+:
0+1 = GTTMMADR
2+3 = GMADR
4 = IOBAR

Maybe we should just have an explicit list of bars like that in a
comment?

I'd also suggest sucking this bitmask calculation into a small helper
so you can reuse it for the release.

>  	/*
> -	 * Before gen4, the registers and the GTT are behind different BARs.
> +	 * On gen3 the registers and the GTT are behind different BARs.
>  	 * However, from gen4 onwards, the registers and the GTT are shared
>  	 * in the same BAR, so we want to restrict this ioremap from
>  	 * clobbering the GTT which we want ioremap_wc instead. Fortunately,
> @@ -1703,6 +1706,8 @@ static int uncore_mmio_setup(struct intel_uncore *uncore)
>  	 * generations up to Ironlake.
>  	 * For dgfx chips register range is expanded to 4MB.
>  	 */
> +	if (INTEL_GEN(i915) == 3)
> +		bar_selection |= BIT(3);
>  	if (INTEL_GEN(i915) < 5)
>  		mmio_size = 512 * 1024;
>  	else if (IS_DGFX(i915))
> @@ -1710,8 +1715,15 @@ static int uncore_mmio_setup(struct intel_uncore *uncore)
>  	else
>  		mmio_size = 2 * 1024 * 1024;
>  
> +	ret = pci_request_selected_regions(pdev, bar_selection, "i915");
> +	if (ret < 0) {
> +		drm_err(&i915->drm, "failed to request pci bars\n");
> +		return ret;
> +	}
> +
>  	uncore->regs = pci_iomap(pdev, mmio_bar, mmio_size);
>  	if (uncore->regs == NULL) {
> +		pci_release_selected_regions(pdev, bar_selection);
>  		drm_err(&i915->drm, "failed to map registers\n");
>  		return -EIO;
>  	}
> @@ -1721,9 +1733,18 @@ static int uncore_mmio_setup(struct intel_uncore *uncore)
>  
>  static void uncore_mmio_cleanup(struct intel_uncore *uncore)
>  {
> -	struct pci_dev *pdev = uncore->i915->drm.pdev;
> +	struct drm_i915_private *i915 = uncore->i915;
> +	struct pci_dev *pdev = i915->drm.pdev;
> +	int mmio_bar;
> +	int bar_selection;
> +
> +	mmio_bar = IS_GEN(i915, 2) ? 1 : 0;
> +	bar_selection = BIT (2) | BIT(mmio_bar);
> +	if (INTEL_GEN(i915) == 3)
> +		bar_selection |= BIT(3);
>  
>  	pci_iounmap(pdev, uncore->regs);
> +	pci_release_selected_regions(pdev, bar_selection);
>  }
>  
>  void intel_uncore_init_early(struct intel_uncore *uncore,
> -- 
> 2.28.0
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Ville Syrjälä
Intel
