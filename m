Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D957310F33E
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 00:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfLBXOK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 18:14:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21960 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725834AbfLBXOK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 18:14:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575328448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tAwoXaf+koWSufi/dRhjSH/eAtPIzFUnI9AFQ6G4Vdk=;
        b=bRnFbr+0FIYPGGe6CyKMcfUiOYPv2PTybhKa00eWhyuQkjCYnGJGPp6Fl6klsfRZsNwOV9
        jTTn/I1Q8QoowBQwM/i371BSuGmZ5HBReIk6BMlx/Wbnd1sxYewkRAQnoU+vJqLGEtR1gJ
        rzaRDRIVLppX/DKuyASKVAGDU4GoLGg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-_XxVkZQfPG-SFlabSV-FKQ-1; Mon, 02 Dec 2019 18:14:05 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F41CDBA3;
        Mon,  2 Dec 2019 23:14:03 +0000 (UTC)
Received: from x1.home (ovpn-116-56.phx2.redhat.com [10.3.116.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3FA25C28C;
        Mon,  2 Dec 2019 23:14:01 +0000 (UTC)
Date:   Mon, 2 Dec 2019 16:14:01 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Jiang Yi <giangyi@amazon.com>, kvm@vger.kernel.org,
        adulea@amazon.de, jschoenh@amazon.de, cohuck@redhat.com,
        "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [PATCH] vfio: call irq_bypass_unregister_producer() before
 freeing irq
Message-ID: <20191202161401.7e532e34@x1.home>
In-Reply-To: <86sgm9yye9.wl-maz@kernel.org>
References: <20191127164910.15888-1-giangyi@amazon.com>
        <86sgm9yye9.wl-maz@kernel.org>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: _XxVkZQfPG-SFlabSV-FKQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 27 Nov 2019 18:20:14 +0000
Marc Zyngier <maz@kernel.org> wrote:

> On Wed, 27 Nov 2019 16:49:10 +0000,
> Jiang Yi <giangyi@amazon.com> wrote:
> 
> Hi Jiang,
> 
> Thanks for spotting this!
> 
> > Since irq_bypass_register_producer() is called after request_irq(), we
> > should do tear-down in reverse order: irq_bypass_unregister_producer()
> > then free_irq().  
> 
> More importantly, free_irq() is going to releases resources that can
> still be required by the del_producer callback. Notably, for arm64 and
> GICv4:
> 
> free_irq(irq)
>   __free_irq(irq)
>     irq_domain_deactivate_irq(irq)
>       its_irq_domain_deactivate()
>         [unmap the VLPI from the ITS]
> 
> kvm_arch_irq_bypass_del_producer(cons, prod)
>   kvm_vgic_v4_unset_forwarding(kvm, irq, ...)
>     its_unmap_vlpi(irq)
>       [Unmap the VLPI from the ITS (again), remap the original LPI]
> 
> which isn't great, and has the potential to wedge the HW. Reversing
> the two makes more sense: Unmap the VLPI, remap the LPI, and finally
> unmap the LPI. I haven't checked what it does with VT-D.

Yep, it seems a lot safer to reverse this but we need to incorporate
some of Marc's rationale above into the commit log to justify the
stable and fixes tags.  Here's an attempt:

--
free_irq() may release resources required by the irqbypass
del_producer() callback.  Notably on arm64 with GICv4:

 free_irq(irq)
   __free_irq(irq)
     irq_domain_deactivate_irq(irq)
       its_irq_domain_deactivate()
         [unmap the VLPI from the ITS]
 
 kvm_arch_irq_bypass_del_producer(cons, prod)
   kvm_vgic_v4_unset_forwarding(kvm, irq, ...)
     its_unmap_vlpi(irq)
       [Unmap the VLPI from the ITS (again), remap the original LPI]

This has the potential to wedge hardware.  Re-order to free the IRQ
after unregistering the irqbypass producer, which also provides the
proper mirror of setup ordering.
--

Cc'ing some usual suspects from AMD, Intel, and Power where the
kvm_arch_irq_bypass_del_producer() callback is also implemented.
Thanks,

Alex

> > Signed-off-by: Jiang Yi <giangyi@amazon.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_intrs.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> > index 3fa3f728fb39..2056f3f85f59 100644
> > --- a/drivers/vfio/pci/vfio_pci_intrs.c
> > +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> > @@ -289,18 +289,18 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
> >  	int irq, ret;
> >  
> >  	if (vector < 0 || vector >= vdev->num_ctx)
> >  		return -EINVAL;
> >  
> >  	irq = pci_irq_vector(pdev, vector);
> >  
> >  	if (vdev->ctx[vector].trigger) {
> > -		free_irq(irq, vdev->ctx[vector].trigger);
> >  		irq_bypass_unregister_producer(&vdev->ctx[vector].producer);
> > +		free_irq(irq, vdev->ctx[vector].trigger);
> >  		kfree(vdev->ctx[vector].name);
> >  		eventfd_ctx_put(vdev->ctx[vector].trigger);
> >  		vdev->ctx[vector].trigger = NULL;
> >  	}
> >  
> >  	if (fd < 0)
> >  		return 0;
> >  
> > -- 
> > 2.17.1
> > 
> >   
> 
> FWIW:
> 
> Cc: stable@vger.kernel.org # v4.4+
> Fixes: 6d7425f109d26 ("vfio: Register/unregister irq_bypass_producer")
> Reviewed-by: Marc Zyngier <maz@kernel.org>
> 
> Thanks again,
> 
> 	M.
> 

