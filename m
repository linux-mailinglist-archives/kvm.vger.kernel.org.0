Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 103FF8A8AB
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2019 22:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfHLUwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 16:52:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36940 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726707AbfHLUw3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 16:52:29 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A1B9E3001C62;
        Mon, 12 Aug 2019 20:52:29 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C4B980340;
        Mon, 12 Aug 2019 20:52:29 +0000 (UTC)
Date:   Mon, 12 Aug 2019 14:52:28 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Denis Efremov <efremov@linux.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] vfio_pci: Use PCI_STD_NUM_BARS in loops instead of
 PCI_STD_RESOURCE_END
Message-ID: <20190812145228.0e194a3b@x1.home>
In-Reply-To: <20190812200234.GE11785@google.com>
References: <20190811150802.2418-1-efremov@linux.com>
        <20190811150802.2418-8-efremov@linux.com>
        <20190812200234.GE11785@google.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Mon, 12 Aug 2019 20:52:29 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 12 Aug 2019 15:02:34 -0500
Bjorn Helgaas <helgaas@kernel.org> wrote:

> On Sun, Aug 11, 2019 at 06:08:04PM +0300, Denis Efremov wrote:
> > This patch refactors the loop condition scheme from
> > 'i <= PCI_STD_RESOURCE_END' to 'i < PCI_STD_NUM_BARS'.
> > 
> > Signed-off-by: Denis Efremov <efremov@linux.com>
> > ---
> >  drivers/vfio/pci/vfio_pci.c         | 4 ++--
> >  drivers/vfio/pci/vfio_pci_config.c  | 2 +-
> >  drivers/vfio/pci/vfio_pci_private.h | 4 ++--
> >  3 files changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > index 703948c9fbe1..13f5430e3f3c 100644
> > --- a/drivers/vfio/pci/vfio_pci.c
> > +++ b/drivers/vfio/pci/vfio_pci.c
> > @@ -115,7 +115,7 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
> >  
> >  	INIT_LIST_HEAD(&vdev->dummy_resources_list);
> >  
> > -	for (bar = PCI_STD_RESOURCES; bar <= PCI_STD_RESOURCE_END; bar++) {
> > +	for (bar = 0; bar < PCI_STD_NUM_BARS; bar++) {
> >  		res = vdev->pdev->resource + bar;  
> 
> PCI_STD_RESOURCES is indeed 0, but since the original went to the
> trouble of avoiding that assumption, I would probably do this:
> 
>         for (bar = 0; bar < PCI_STD_NUM_BARS; bar++) {
>                 res = vdev->pdev->resource + bar + PCI_STD_RESOURCES;
> 
> or maybe even this:
> 
>                 res = &vdev->pdev->resource[bar + PCI_STD_RESOURCES];
> 
> which is more common outside vfio.  But I wouldn't change to using the
> &dev->resource[] form if other vfio code that you're *not* changing
> uses the dev->resource + bar form.

I don't think we have any other instances like that, so the latter form
is fine with me if it's more broadly used.  I do spot one use of [bar]
in drivers/vfio/pci/vfio_pci_rdwr.c that could also take on this form
to void the same assumption though.  Thanks,

Alex

> >  		if (!IS_ENABLED(CONFIG_VFIO_PCI_MMAP))
> > @@ -399,7 +399,7 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
> >  
> >  	vfio_config_free(vdev);
> >  
> > -	for (bar = PCI_STD_RESOURCES; bar <= PCI_STD_RESOURCE_END; bar++) {
> > +	for (bar = 0; bar < PCI_STD_NUM_BARS; bar++) {
> >  		if (!vdev->barmap[bar])
> >  			continue;
> >  		pci_iounmap(pdev, vdev->barmap[bar]);
> > diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> > index f0891bd8444c..6035a2961160 100644
> > --- a/drivers/vfio/pci/vfio_pci_config.c
> > +++ b/drivers/vfio/pci/vfio_pci_config.c
> > @@ -455,7 +455,7 @@ static void vfio_bar_fixup(struct vfio_pci_device *vdev)
> >  
> >  	bar = (__le32 *)&vdev->vconfig[PCI_BASE_ADDRESS_0];
> >  
> > -	for (i = PCI_STD_RESOURCES; i <= PCI_STD_RESOURCE_END; i++, bar++) {
> > +	for (i = 0; i < PCI_STD_NUM_BARS; i++, bar++) {
> >  		if (!pci_resource_start(pdev, i)) {
> >  			*bar = 0; /* Unmapped by host = unimplemented to user */
> >  			continue;
> > diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
> > index ee6ee91718a4..8a2c7607d513 100644
> > --- a/drivers/vfio/pci/vfio_pci_private.h
> > +++ b/drivers/vfio/pci/vfio_pci_private.h
> > @@ -86,8 +86,8 @@ struct vfio_pci_reflck {
> >  
> >  struct vfio_pci_device {
> >  	struct pci_dev		*pdev;
> > -	void __iomem		*barmap[PCI_STD_RESOURCE_END + 1];
> > -	bool			bar_mmap_supported[PCI_STD_RESOURCE_END + 1];
> > +	void __iomem		*barmap[PCI_STD_NUM_BARS];
> > +	bool			bar_mmap_supported[PCI_STD_NUM_BARS];
> >  	u8			*pci_config_map;
> >  	u8			*vconfig;
> >  	struct perm_bits	*msi_perm;
> > -- 
> > 2.21.0
> >   

