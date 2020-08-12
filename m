Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37CC1242D86
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 18:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgHLQn7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 12:43:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35856 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726477AbgHLQn6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Aug 2020 12:43:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597250636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gsodrOBkuGGMrWQQ/WcGVThXndk64nl920OW047Dgr4=;
        b=Lr4R58f32NwaAo9uO7qzc2r/zPCPdpp1zs4tSnZb5KPBWraIhZT38FBcheqVB839YeRzlD
        AekcAP3FZFTJkRG4ibpLbk3Y6WKHT+RQxRvLlberqNGQVA5+V/g2Vut3CM+1qKsnsQc8Qw
        9lKdZBoeXv9jmWxWoHPRMmADF2xUX/4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-Fksr6dsHPQGAfCXkAmSBwg-1; Wed, 12 Aug 2020 12:43:54 -0400
X-MC-Unique: Fksr6dsHPQGAfCXkAmSBwg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A8B357;
        Wed, 12 Aug 2020 16:43:52 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8AC3F5D9D7;
        Wed, 12 Aug 2020 16:43:51 +0000 (UTC)
Date:   Wed, 12 Aug 2020 10:43:51 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     bhelgaas@google.com, schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        mpe@ellerman.id.au, oohall@gmail.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI: Introduce flag for detached virtual functions
Message-ID: <20200812104351.3668cc0f@x1.home>
In-Reply-To: <1597243817-3468-2-git-send-email-mjrosato@linux.ibm.com>
References: <1597243817-3468-1-git-send-email-mjrosato@linux.ibm.com>
        <1597243817-3468-2-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 12 Aug 2020 10:50:17 -0400
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
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
> ---
>  arch/s390/pci/pci.c                | 8 ++++++++
>  drivers/vfio/pci/vfio_pci_config.c | 3 ++-
>  include/linux/pci.h                | 1 +
>  3 files changed, 11 insertions(+), 1 deletion(-)
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
> index d98843f..17845fc 100644
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

Wouldn't we also want to enable the is_virtfn related code in
vfio_basic_config_read() and at least the initial setting of the
command register in vfio_config_init()?  Otherwise we're extending the
incomplete emulation out to userspace.  Thanks,

Alex


> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 8355306..23a6972 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -445,6 +445,7 @@ struct pci_dev {
>  	unsigned int	is_probed:1;		/* Device probing in progress */
>  	unsigned int	link_active_reporting:1;/* Device capable of reporting link active */
>  	unsigned int	no_vf_scan:1;		/* Don't scan for VFs after IOV enablement */
> +	unsigned int	detached_vf:1;		/* VF without local PF access */
>  	pci_dev_flags_t dev_flags;
>  	atomic_t	enable_cnt;	/* pci_enable_device has been called */
>  

