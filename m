Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D855920C5AB
	for <lists+kvm@lfdr.de>; Sun, 28 Jun 2020 06:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbgF1EJG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Jun 2020 00:09:06 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36175 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725908AbgF1EJG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 28 Jun 2020 00:09:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593317344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UHB77KARZdF1vV3ZfBH83U0JFNf2h7Rv/Mt18RREFk0=;
        b=hH1fNMhwSf6kjekomdIRSE5B9hkz4eQIABExJ1nGMMXbi7NhxSmjhVFmSPDAjmmrcTCQBI
        JW7oFEHscEnJqakqv+U1+SmNDV8ulhrYKzC0f5tk9adE4rGnB8/rOdInOBlzXVzOEm/3iG
        HbqCMSwf817GL7m//6n9kSYykI8Z00k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-bJQLMeiAOw-i5WaS6gap0A-1; Sun, 28 Jun 2020 00:09:00 -0400
X-MC-Unique: bJQLMeiAOw-i5WaS6gap0A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2364BFC0;
        Sun, 28 Jun 2020 04:08:59 +0000 (UTC)
Received: from x1.home (ovpn-112-156.phx2.redhat.com [10.3.112.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A66A60BF1;
        Sun, 28 Jun 2020 04:08:52 +0000 (UTC)
Date:   Sat, 27 Jun 2020 22:08:52 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Wang, Haiyue" <haiyue.wang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        David Marchand <david.marchand@redhat.com>,
        Kevin Traynor <ktraynor@redhat.com>
Subject: Re: [PATCH] vfio/pci: Fix SR-IOV VF handling with MMIO blocking
Message-ID: <20200627220852.13b3fa7f@x1.home>
In-Reply-To: <BN8PR11MB3795C3338B3C7F67A6EDB43AF7910@BN8PR11MB3795.namprd11.prod.outlook.com>
References: <159310421505.27590.16617666489295503039.stgit@gimli.home>
        <BN8PR11MB3795C3338B3C7F67A6EDB43AF7910@BN8PR11MB3795.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 28 Jun 2020 03:12:12 +0000
"Wang, Haiyue" <haiyue.wang@intel.com> wrote:

> > -----Original Message-----
> > From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org> On Behalf Of Alex Williamson
> > Sent: Friday, June 26, 2020 00:57
> > To: alex.williamson@redhat.com
> > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org; maxime.coquelin@redhat.com
> > Subject: [PATCH] vfio/pci: Fix SR-IOV VF handling with MMIO blocking
> > 
> > SR-IOV VFs do not implement the memory enable bit of the command
> > register, therefore this bit is not set in config space after
> > pci_enable_device().  This leads to an unintended difference
> > between PF and VF in hand-off state to the user.  We can correct
> > this by setting the initial value of the memory enable bit in our
> > virtualized config space.  There's really no need however to
> > ever fault a user on a VF though as this would only indicate an
> > error in the user's management of the enable bit, versus a PF
> > where the same access could trigger hardware faults.
> > 
> > Fixes: abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on disabled memory")
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_config.c |   17 ++++++++++++++++-
> >  1 file changed, 16 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> > index 8746c943247a..d98843feddce 100644
> > --- a/drivers/vfio/pci/vfio_pci_config.c
> > +++ b/drivers/vfio/pci/vfio_pci_config.c
> > @@ -398,9 +398,15 @@ static inline void p_setd(struct perm_bits *p, int off, u32 virt, u32 write)
> >  /* Caller should hold memory_lock semaphore */
> >  bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev)
> >  {
> > +	struct pci_dev *pdev = vdev->pdev;
> >  	u16 cmd = le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
> > 
> > -	return cmd & PCI_COMMAND_MEMORY;
> > +	/*
> > +	 * SR-IOV VF memory enable is handled by the MSE bit in the
> > +	 * PF SR-IOV capability, there's therefore no need to trigger
> > +	 * faults based on the virtual value.
> > +	 */
> > +	return pdev->is_virtfn || (cmd & PCI_COMMAND_MEMORY);  
> 
> Hi Alex,
> 
> After set up the initial copy of config space for memory enable bit for VF, is it worth
> to trigger SIGBUS into the bad user space process which intentionally try to disable the
> memory access command (even it is VF) then access the memory to trigger CVE-2020-12888 ?

We're essentially only trying to catch the user in mismanaging the
enable bit if we trigger a fault based on the virtualized enabled bit,
right?  There's no risk that the VF would trigger a UR based on the
state of our virtual enable bit.  So is it worth triggering a user
fault when, for instance, the user might be aware that the device is a
VF and know that the memory enable bit is not relative to the physical
device?  Thanks,

Alex

> >  }
> > 
> >  /*
> > @@ -1728,6 +1734,15 @@ int vfio_config_init(struct vfio_pci_device *vdev)
> >  				 vconfig[PCI_INTERRUPT_PIN]);
> > 
> >  		vconfig[PCI_INTERRUPT_PIN] = 0; /* Gratuitous for good VFs */
> > +
> > +		/*
> > +		 * VFs do no implement the memory enable bit of the COMMAND
> > +		 * register therefore we'll not have it set in our initial
> > +		 * copy of config space after pci_enable_device().  For
> > +		 * consistency with PFs, set the virtual enable bit here.
> > +		 */
> > +		*(__le16 *)&vconfig[PCI_COMMAND] |=
> > +					cpu_to_le16(PCI_COMMAND_MEMORY);
> >  	}
> > 
> >  	if (!IS_ENABLED(CONFIG_VFIO_PCI_INTX) || vdev->nointx)  
> 

