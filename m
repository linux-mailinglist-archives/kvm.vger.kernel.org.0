Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8146321151E
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 23:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgGAV2Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 17:28:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgGAV2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 17:28:15 -0400
Received: from localhost (mobile-166-175-191-139.mycingular.net [166.175.191.139])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5104206B7;
        Wed,  1 Jul 2020 21:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593638895;
        bh=Us/5Jy9tEk6lKrONtGQfRf0LzdvM7mLYjwXq0weXD2o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=LkEgNJHnln0VSwyeu9MKg2oQSVELTF7r1btaK4RxPrGOUquprOxOqADHd3+0e6Rsd
         yLrLwI2iCv968/h4T0d0jyDfrAq0V/1F8SN5Gk3q/fy3rwL6/0Me0nOLAbj4NtASkQ
         8T5+TwNcXpLurasyEoJ8ru+lUDn+3LDyM2hSJcUM=
Date:   Wed, 1 Jul 2020 16:28:12 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     alex.williamson@redhat.com, herbert@gondor.apana.org.au,
        cohuck@redhat.com, nhorman@redhat.com, vdronov@redhat.com,
        bhelgaas@google.com, mark.a.chambers@intel.com,
        gordon.mcfadden@intel.com, ahsan.atta@intel.com,
        qat-linux@intel.com, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] vfio/pci: add qat devices to blocklist
Message-ID: <20200701212812.GA3661715@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200701110302.75199-4-giovanni.cabiddu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 01, 2020 at 12:03:00PM +0100, Giovanni Cabiddu wrote:
> The current generation of Intel® QuickAssist Technology devices
> are not designed to run in an untrusted environment because of the
> following issues reported in the release notes in
> https://01.org/intel-quickassist-technology:

It would be nice if this link were directly clickable, e.g., if there
were no trailing ":" or something.

And it would be even better if it went to a specific doc that
described these issues.  I assume these are errata, and it's not easy
to figure out which doc mentions them.

> QATE-39220 - GEN - Intel® QAT API submissions with bad addresses that
>              trigger DMA to invalid or unmapped addresses can cause a
>              platform hang
> QATE-7495  - GEN - An incorrectly formatted request to Intel® QAT can
>              hang the entire Intel® QAT Endpoint
> 
> This patch adds the following QAT devices to the blocklist: DH895XCC,
> C3XXX and C62X.
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index ea5904ca6cbf..dcac5408c764 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -75,6 +75,21 @@ static inline bool vfio_vga_disabled(void)
>  
>  static bool vfio_pci_dev_in_blocklist(struct pci_dev *pdev)
>  {
> +	switch (pdev->vendor) {
> +	case PCI_VENDOR_ID_INTEL:
> +		switch (pdev->device) {
> +		case PCI_DEVICE_ID_INTEL_QAT_C3XXX:
> +		case PCI_DEVICE_ID_INTEL_QAT_C3XXX_VF:
> +		case PCI_DEVICE_ID_INTEL_QAT_C62X:
> +		case PCI_DEVICE_ID_INTEL_QAT_C62X_VF:
> +		case PCI_DEVICE_ID_INTEL_QAT_DH895XCC:
> +		case PCI_DEVICE_ID_INTEL_QAT_DH895XCC_VF:
> +			return true;
> +		default:
> +			return false;
> +		}
> +	}
> +
>  	return false;
>  }
>  
> -- 
> 2.26.2
> 
