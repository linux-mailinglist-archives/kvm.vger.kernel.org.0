Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59EBB377A6A
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 05:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhEJDPd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 May 2021 23:15:33 -0400
Received: from mga07.intel.com ([134.134.136.100]:43874 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230129AbhEJDPd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 May 2021 23:15:33 -0400
IronPort-SDR: 8QbKD3xmsXv2il6mkgKDKbLWunUbN+Rg7dfJCT7yEYjgmmRsdJMNVkajCTiS8YsYlvvstKmT3V
 3krScytyKeYQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9979"; a="263032956"
X-IronPort-AV: E=Sophos;i="5.82,286,1613462400"; 
   d="scan'208";a="263032956"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2021 20:14:28 -0700
IronPort-SDR: WCxSB8qlULFEg27R7YRx1U/xAVu5Dtt9mv946s7i7zI5uP4EzZ3iN9OfCfcrwc5sbVddZeaqlm
 9NAWJThKybvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,286,1613462400"; 
   d="scan'208";a="621047218"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.38])
  by fmsmga006.fm.intel.com with ESMTP; 09 May 2021 20:14:27 -0700
Date:   Mon, 10 May 2021 11:14:26 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     tkffaul@outlook.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: Sanity check IGD OpRegion Size
Message-ID: <20210510031426.gs2jcnswn2h4atow@yy-desk-7060>
References: <162041357421.21800.16214130780777455390.stgit@omen>
 <20210510011014.q6xfcmqopbqgepbq@yy-desk-7060>
 <20210509193408.22ae2b2a@x1.home.shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210509193408.22ae2b2a@x1.home.shazbot.org>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 09, 2021 at 07:34:08PM -0600, Alex Williamson wrote:
> On Mon, 10 May 2021 09:10:14 +0800
> Yuan Yao <yuan.yao@linux.intel.com> wrote:
> 
> > On Fri, May 07, 2021 at 12:53:17PM -0600, Alex Williamson wrote:
> > > The size field of the IGD OpRegion table is supposed to indicate table
> > > size in KB, but we've seen at least one report of a BIOS that appears
> > > to incorrectly report size in bytes.  The default size is 8 (*1024 =
> > > 8KB), but an incorrect implementation may report 8192 (*1024 = 8MB)
> > > and can cause a variety of mapping errors.
> > > 
> > > It's believed that 8MB would be an implausible, if not absurd, actual
> > > size, so we can probably be pretty safe in assuming this is a BIOS bug
> > > where the intended size is likely 8KB.
> > > 
> > > Reported-by: Travis Faulhaber <tkffaul@outlook.com>
> > > Tested-by: Travis Faulhaber <tkffaul@outlook.com>
> > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > ---
> > >  drivers/vfio/pci/vfio_pci_igd.c |   11 ++++++++++-
> > >  1 file changed, 10 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
> > > index 228df565e9bc..c89a4797cd18 100644
> > > --- a/drivers/vfio/pci/vfio_pci_igd.c
> > > +++ b/drivers/vfio/pci/vfio_pci_igd.c
> > > @@ -86,7 +86,16 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
> > >  		return -EINVAL;
> > >  	}
> > >  
> > > -	size *= 1024; /* In KB */
> > > +	/*
> > > +	 * The OpRegion size field is specified as size in KB, but there have been
> > > +	 * user reports where this field appears to report size in bytes.  If we
> > > +	 * read 8192, assume this is the case.
> > > +	 */
> > > +	if (size == OPREGION_SIZE)  
> > 
> > Is "size >= OPREGION_SIZE" or "size >= smaller but still implausible value
> > (like 4096)" better for covering more bad BIOS implementation cases ?
> 
> We haven't seen such cases and it seems like a BIOS implementation
> competent enough to use something other than the default size, probably
> might get the units correct for this field.  Our footing for assuming
> this specific implementation error gets shakier if we try to apply it
> beyond the default size, imo.  Thanks,

OK, make sense to me, thanks.

> 
> Alex
> 
