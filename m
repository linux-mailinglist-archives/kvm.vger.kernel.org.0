Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0B83779D0
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 03:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhEJBfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 May 2021 21:35:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56979 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230114AbhEJBfR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 9 May 2021 21:35:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620610453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G6F/Zc94YePQW7AcfQRcHnmyKkKZaaJbaatLrem/2Q0=;
        b=ZdK+P1QulnKbhuYtOZWkJSuESXR9zawK8b2g2hWWJEKwbfzkFU/JmBhoOPJOhBMD3wyBLO
        J67k/a/ifWw87r/beuOh9mdkowbl5l+N9ECdupWTLHBF/p7dsDfp0mNOlmEXGtB1XdKvG4
        G2ukL3UQt1h0rNQBWnMkymsSKpIDvh8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-ixLWuBhbNBWuRm1ScIgBgA-1; Sun, 09 May 2021 21:34:09 -0400
X-MC-Unique: ixLWuBhbNBWuRm1ScIgBgA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE192107ACCA;
        Mon, 10 May 2021 01:34:08 +0000 (UTC)
Received: from x1.home.shazbot.org (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C3CD610D0;
        Mon, 10 May 2021 01:34:08 +0000 (UTC)
Date:   Sun, 9 May 2021 19:34:08 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     tkffaul@outlook.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: Sanity check IGD OpRegion Size
Message-ID: <20210509193408.22ae2b2a@x1.home.shazbot.org>
In-Reply-To: <20210510011014.q6xfcmqopbqgepbq@yy-desk-7060>
References: <162041357421.21800.16214130780777455390.stgit@omen>
        <20210510011014.q6xfcmqopbqgepbq@yy-desk-7060>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 May 2021 09:10:14 +0800
Yuan Yao <yuan.yao@linux.intel.com> wrote:

> On Fri, May 07, 2021 at 12:53:17PM -0600, Alex Williamson wrote:
> > The size field of the IGD OpRegion table is supposed to indicate table
> > size in KB, but we've seen at least one report of a BIOS that appears
> > to incorrectly report size in bytes.  The default size is 8 (*1024 =
> > 8KB), but an incorrect implementation may report 8192 (*1024 = 8MB)
> > and can cause a variety of mapping errors.
> > 
> > It's believed that 8MB would be an implausible, if not absurd, actual
> > size, so we can probably be pretty safe in assuming this is a BIOS bug
> > where the intended size is likely 8KB.
> > 
> > Reported-by: Travis Faulhaber <tkffaul@outlook.com>
> > Tested-by: Travis Faulhaber <tkffaul@outlook.com>
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_igd.c |   11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
> > index 228df565e9bc..c89a4797cd18 100644
> > --- a/drivers/vfio/pci/vfio_pci_igd.c
> > +++ b/drivers/vfio/pci/vfio_pci_igd.c
> > @@ -86,7 +86,16 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
> >  		return -EINVAL;
> >  	}
> >  
> > -	size *= 1024; /* In KB */
> > +	/*
> > +	 * The OpRegion size field is specified as size in KB, but there have been
> > +	 * user reports where this field appears to report size in bytes.  If we
> > +	 * read 8192, assume this is the case.
> > +	 */
> > +	if (size == OPREGION_SIZE)  
> 
> Is "size >= OPREGION_SIZE" or "size >= smaller but still implausible value
> (like 4096)" better for covering more bad BIOS implementation cases ?

We haven't seen such cases and it seems like a BIOS implementation
competent enough to use something other than the default size, probably
might get the units correct for this field.  Our footing for assuming
this specific implementation error gets shakier if we try to apply it
beyond the default size, imo.  Thanks,

Alex

