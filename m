Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1695526CE63
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 00:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgIPWKd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 18:10:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbgIPWKa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 18:10:30 -0400
Received: from localhost (52.sub-72-107-123.myvzw.com [72.107.123.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E0FF2220A;
        Wed, 16 Sep 2020 21:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600293314;
        bh=5Fpi6OQa8IxjUT2FP7sUxhyFcgPeG9M+tTW+C8SdAFk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=1FkSmcTykCL/zqkaPTTTtxzFybHV52zt+7fV2sexve+QjzmljN4s5sh4dV+pzUf9x
         bvmPikerzuBmKwnWF/aVNQnfnHV1SbcHUZoDhCpydjrkcSC7vDyPsj0D89+RjyeeL0
         m6l774wtQbVbK+auQSubJ8TeH6i/4GTAHSu8PYRQ=
Date:   Wed, 16 Sep 2020 16:55:13 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, bhelgaas@google.com,
        schnelle@linux.ibm.com, pmorel@linux.ibm.com, mpe@ellerman.id.au,
        oohall@gmail.com, cohuck@redhat.com, kevin.tian@intel.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v5 1/3] PCI/IOV: Mark VFs as not implementing
 PCI_COMMAND_MEMORY
Message-ID: <20200916215513.GA1588138@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1599749997-30489-2-git-send-email-mjrosato@linux.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 10, 2020 at 10:59:55AM -0400, Matthew Rosato wrote:
> For VFs, the Memory Space Enable bit in the Command Register is
> hard-wired to 0.
> 
> Add a new bit to signify devices where the Command Register Memory
> Space Enable bit does not control the device's response to MMIO
> accesses.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/pci/iov.c   | 1 +
>  include/linux/pci.h | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index b37e08c..4afd4ee 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -180,6 +180,7 @@ int pci_iov_add_virtfn(struct pci_dev *dev, int id)
>  	virtfn->device = iov->vf_device;
>  	virtfn->is_virtfn = 1;
>  	virtfn->physfn = pci_dev_get(dev);
> +	virtfn->no_command_memory = 1;
>  
>  	if (id == 0)
>  		pci_read_vf_config_common(virtfn);
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 8355306..3ff72312 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -445,6 +445,7 @@ struct pci_dev {
>  	unsigned int	is_probed:1;		/* Device probing in progress */
>  	unsigned int	link_active_reporting:1;/* Device capable of reporting link active */
>  	unsigned int	no_vf_scan:1;		/* Don't scan for VFs after IOV enablement */
> +	unsigned int	no_command_memory:1;	/* No PCI_COMMAND_MEMORY */
>  	pci_dev_flags_t dev_flags;
>  	atomic_t	enable_cnt;	/* pci_enable_device has been called */
>  
> -- 
> 1.8.3.1
> 
