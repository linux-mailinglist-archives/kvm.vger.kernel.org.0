Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAD92746D8
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 18:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgIVQkk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 12:40:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57293 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726739AbgIVQkj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 12:40:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600792837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g/MCLyHoyvURQHbumQLHytYYwHvt80kkvgPCoRYfLTU=;
        b=aBCXJdEx6aGQaZ7S/8RsfcCOnYBRhZle49KCRlxgr6J0jb+aXqs4viSls0wB/py2Nx7Qkk
        La5ZuqT/coVd26Ub1AuInNufop8VqvAyBOWfyumFzW+YKKEKKH/9gp9iEUCw+ofABaZUl9
        ppqkKlkdC8wnrY0EvNLeU7SkYl3r9u0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-EWnkbm9VPH61cn_uCdsxUA-1; Tue, 22 Sep 2020 12:40:33 -0400
X-MC-Unique: EWnkbm9VPH61cn_uCdsxUA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E43E7188C12B;
        Tue, 22 Sep 2020 16:40:31 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D388178825;
        Tue, 22 Sep 2020 16:40:30 +0000 (UTC)
Date:   Tue, 22 Sep 2020 10:40:30 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     bhelgaas@google.com, schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        mpe@ellerman.id.au, oohall@gmail.com, cohuck@redhat.com,
        kevin.tian@intel.com, hca@linux.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v5 3/3] vfio/pci: Decouple PCI_COMMAND_MEMORY bit checks
 from is_virtfn
Message-ID: <20200922104030.07e0dfd9@x1.home>
In-Reply-To: <08afc6b2-7549-5440-a947-af0b598288c2@linux.ibm.com>
References: <1599749997-30489-1-git-send-email-mjrosato@linux.ibm.com>
        <1599749997-30489-4-git-send-email-mjrosato@linux.ibm.com>
        <08afc6b2-7549-5440-a947-af0b598288c2@linux.ibm.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 21 Sep 2020 08:43:29 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> On 9/10/20 10:59 AM, Matthew Rosato wrote:
> > While it is true that devices with is_virtfn=1 will have a Memory Space
> > Enable bit that is hard-wired to 0, this is not the only case where we
> > see this behavior -- For example some bare-metal hypervisors lack
> > Memory Space Enable bit emulation for devices not setting is_virtfn
> > (s390). Fix this by instead checking for the newly-added
> > no_command_memory bit which directly denotes the need for
> > PCI_COMMAND_MEMORY emulation in vfio.
> > 
> > Fixes: abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on disabled memory")
> > Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
> > Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>  
> 
> Polite ping on this patch as the other 2 have now received maintainer 
> ACKs or reviews.  I'm concerned about this popping up in distros as 
> abafbc551fdd was a CVE fix.  Related, see question from the cover:
> 
> - Restored the fixes tag to patch 3 (but the other 2 patches are
>    now pre-reqs -- cc stable 5.8?)

I've got these queued in my local branch which I'll push to next for
v5.10.  I'm thinking that perhaps the right thing would be to add the
fixes tag to all three patches, otherwise I could see that the PCI/VF
change might get picked as a dependency, but not the s390 specific one.
Does this sound correct to everyone?  Thanks,

Alex

> > ---
> >   drivers/vfio/pci/vfio_pci_config.c | 24 ++++++++++++++----------
> >   1 file changed, 14 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> > index d98843f..5076d01 100644
> > --- a/drivers/vfio/pci/vfio_pci_config.c
> > +++ b/drivers/vfio/pci/vfio_pci_config.c
> > @@ -406,7 +406,7 @@ bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev)
> >   	 * PF SR-IOV capability, there's therefore no need to trigger
> >   	 * faults based on the virtual value.
> >   	 */
> > -	return pdev->is_virtfn || (cmd & PCI_COMMAND_MEMORY);
> > +	return pdev->no_command_memory || (cmd & PCI_COMMAND_MEMORY);
> >   }
> >   
> >   /*
> > @@ -520,8 +520,8 @@ static int vfio_basic_config_read(struct vfio_pci_device *vdev, int pos,
> >   
> >   	count = vfio_default_config_read(vdev, pos, count, perm, offset, val);
> >   
> > -	/* Mask in virtual memory enable for SR-IOV devices */
> > -	if (offset == PCI_COMMAND && vdev->pdev->is_virtfn) {
> > +	/* Mask in virtual memory enable */
> > +	if (offset == PCI_COMMAND && vdev->pdev->no_command_memory) {
> >   		u16 cmd = le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
> >   		u32 tmp_val = le32_to_cpu(*val);
> >   
> > @@ -589,9 +589,11 @@ static int vfio_basic_config_write(struct vfio_pci_device *vdev, int pos,
> >   		 * shows it disabled (phys_mem/io, then the device has
> >   		 * undergone some kind of backdoor reset and needs to be
> >   		 * restored before we allow it to enable the bars.
> > -		 * SR-IOV devices will trigger this, but we catch them later
> > +		 * SR-IOV devices will trigger this - for mem enable let's
> > +		 * catch this now and for io enable it will be caught later
> >   		 */
> > -		if ((new_mem && virt_mem && !phys_mem) ||
> > +		if ((new_mem && virt_mem && !phys_mem &&
> > +		     !pdev->no_command_memory) ||
> >   		    (new_io && virt_io && !phys_io) ||
> >   		    vfio_need_bar_restore(vdev))
> >   			vfio_bar_restore(vdev);
> > @@ -1734,12 +1736,14 @@ int vfio_config_init(struct vfio_pci_device *vdev)
> >   				 vconfig[PCI_INTERRUPT_PIN]);
> >   
> >   		vconfig[PCI_INTERRUPT_PIN] = 0; /* Gratuitous for good VFs */
> > -
> > +	}
> > +	if (pdev->no_command_memory) {
> >   		/*
> > -		 * VFs do no implement the memory enable bit of the COMMAND
> > -		 * register therefore we'll not have it set in our initial
> > -		 * copy of config space after pci_enable_device().  For
> > -		 * consistency with PFs, set the virtual enable bit here.
> > +		 * VFs and devices that set pdev->no_command_memory do not
> > +		 * implement the memory enable bit of the COMMAND register
> > +		 * therefore we'll not have it set in our initial copy of
> > +		 * config space after pci_enable_device().  For consistency
> > +		 * with PFs, set the virtual enable bit here.
> >   		 */
> >   		*(__le16 *)&vconfig[PCI_COMMAND] |=
> >   					cpu_to_le16(PCI_COMMAND_MEMORY);
> >   
> 

