Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D312F24300F
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 22:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgHLUdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 16:33:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41787 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726030AbgHLUdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Aug 2020 16:33:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597264379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Nrc8DX2DPQVNxelk2BXjTZZut7+A4fYjP1T2AupKx4=;
        b=LHF4v1p47kJevpVttVH9ZIqBS2RdUk9DiVqNQ4ONXWaMu8I0j/6nN5wRLhUFmV6VewcQBg
        Y71OqdSbG9u4/tzhA1lAHBPiXSnE4fMRKQttNY7dBtANYB/zhaFW89h7s93QwzD0YEGaud
        J38m3IfbBNaO2ToD1iDd0XiOwhcUMFU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-nuFdfxTSMGe6KBa0-yNnFw-1; Wed, 12 Aug 2020 16:32:57 -0400
X-MC-Unique: nuFdfxTSMGe6KBa0-yNnFw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B61AD79ED5;
        Wed, 12 Aug 2020 20:32:55 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D9CDA60E1C;
        Wed, 12 Aug 2020 20:32:54 +0000 (UTC)
Date:   Wed, 12 Aug 2020 14:32:54 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     bhelgaas@google.com, schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        mpe@ellerman.id.au, oohall@gmail.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2] PCI: Introduce flag for detached virtual functions
Message-ID: <20200812143254.2f080c38@x1.home>
In-Reply-To: <1597260071-2219-2-git-send-email-mjrosato@linux.ibm.com>
References: <1597260071-2219-1-git-send-email-mjrosato@linux.ibm.com>
        <1597260071-2219-2-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 12 Aug 2020 15:21:11 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> s390x has the notion of providing VFs to the kernel in a manner
> where the associated PF is inaccessible other than via firmware.
> These are not treated as typical VFs and access to them is emulated
> by underlying firmware which can still access the PF.  After
> abafbc55 however these detached VFs were no longer able to work
> with vfio-pci as the firmware does not provide emulation of the
> PCI_COMMAND_MEMORY bit.  In this case, let's explicitly recognize
> these detached VFs so that vfio-pci can allow memory access to
> them again.
> 

Might as well include a fixes tag too.

Fixes: abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on disabled memory")

You might also extend the sha1 in the log to 12 chars as well, or
replace it with a reference to the fixes tag.

> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  arch/s390/pci/pci.c                |  8 ++++++++
>  drivers/vfio/pci/vfio_pci_config.c | 11 +++++++----
>  include/linux/pci.h                |  1 +
>  3 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
> index 3902c9f..04ac76d 100644
> --- a/arch/s390/pci/pci.c
> +++ b/arch/s390/pci/pci.c
> @@ -581,6 +581,14 @@ int pcibios_enable_device(struct pci_dev *pdev, int mask)
>  {
>  	struct zpci_dev *zdev = to_zpci(pdev);
>  
> +	/*
> +	 * If we have a VF on a non-multifunction bus, it must be a VF that is
> +	 * detached from its parent PF.  We rely on firmware emulation to
> +	 * provide underlying PF details.
> +	 */
> +	if (zdev->vfn && !zdev->zbus->multifunction)
> +		pdev->detached_vf = 1;
> +
>  	zpci_debug_init_device(zdev, dev_name(&pdev->dev));
>  	zpci_fmb_enable_device(zdev);
>  
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index d98843f..ee45216 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -406,7 +406,8 @@ bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev)
>  	 * PF SR-IOV capability, there's therefore no need to trigger
>  	 * faults based on the virtual value.
>  	 */
> -	return pdev->is_virtfn || (cmd & PCI_COMMAND_MEMORY);
> +	return pdev->is_virtfn || pdev->detached_vf ||
> +	       (cmd & PCI_COMMAND_MEMORY);
>  }
>  
>  /*
> @@ -420,7 +421,7 @@ static void vfio_bar_restore(struct vfio_pci_device *vdev)
>  	u16 cmd;
>  	int i;
>  
> -	if (pdev->is_virtfn)
> +	if (pdev->is_virtfn || pdev->detached_vf)
>  		return;
>  
>  	pci_info(pdev, "%s: reset recovery - restoring BARs\n", __func__);
> @@ -521,7 +522,8 @@ static int vfio_basic_config_read(struct vfio_pci_device *vdev, int pos,
>  	count = vfio_default_config_read(vdev, pos, count, perm, offset, val);
>  
>  	/* Mask in virtual memory enable for SR-IOV devices */
> -	if (offset == PCI_COMMAND && vdev->pdev->is_virtfn) {
> +	if ((offset == PCI_COMMAND) &&
> +	    (vdev->pdev->is_virtfn || vdev->pdev->detached_vf)) {
>  		u16 cmd = le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
>  		u32 tmp_val = le32_to_cpu(*val);
>  
> @@ -1734,7 +1736,8 @@ int vfio_config_init(struct vfio_pci_device *vdev)
>  				 vconfig[PCI_INTERRUPT_PIN]);
>  
>  		vconfig[PCI_INTERRUPT_PIN] = 0; /* Gratuitous for good VFs */
> -
> +	}
> +	if (pdev->is_virtfn || pdev->detached_vf) {
>  		/*
>  		 * VFs do no implement the memory enable bit of the COMMAND
>  		 * register therefore we'll not have it set in our initial
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 8355306..23a6972 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -445,6 +445,7 @@ struct pci_dev {
>  	unsigned int	is_probed:1;		/* Device probing in progress */
>  	unsigned int	link_active_reporting:1;/* Device capable of reporting link active */
>  	unsigned int	no_vf_scan:1;		/* Don't scan for VFs after IOV enablement */
> +	unsigned int	detached_vf:1;		/* VF without local PF access */

Is there too much implicit knowledge in defining a "detached VF"?  For
example, why do we know that we can skip the portion of
vfio_config_init() that copies the vendor and device IDs from the
struct pci_dev into the virtual config space?  It's true on s390x, but
I think that's because we know that firmware emulates those registers
for us.  We also skip the INTx pin register sanity checking.  Do we do
that because we haven't installed the broken device into an s390x
system?  Because we know firmware manages that for us too?  Or simply
because s390x doesn't support INTx anyway, and therefore it's another
architecture implicit decision?

If detached_vf is really equivalent to is_virtfn for all cases that
don't care about referencing physfn on the pci_dev, then we should
probably have a macro to that effect.  Otherwise, if we're just trying
to describe that the memory bit of the command register is
unimplemented but always enabled, like a VF, should we specifically
describe that attribute instead?  If so, should we instead do that with
pci_dev_flags_t?  Thanks,

Alex

>  	pci_dev_flags_t dev_flags;
>  	atomic_t	enable_cnt;	/* pci_enable_device has been called */
>  

