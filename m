Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFB03B07FE
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 16:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhFVPAQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 11:00:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230185AbhFVPAP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 11:00:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71BE760FEA;
        Tue, 22 Jun 2021 14:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624373879;
        bh=VwMIe4cYe/W3nLlDB3Fbw/+ECa70qefUiyNfPw6sEP4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=JmOlbsDiK3T2O385xlYkCENWOmuHB7ZpPYZhlhAmDXqQ+o0HANIXCII8YnvhMerWS
         saTgOUOP1tFtfjUl6uRuQHQ6gqzOLM8TyEWZv0RWXAXeMzpIbgUY2p7k6AM3n0NNll
         SU58NY8wjl1MJfkkspKDe9r0eC7ZZ/lDLIVeJS+eqSrj9bEJ2qLP/lX3UrA2SQ3PfT
         bi03/lXYjDDjERiTtwz3uitGUIELqRQAshhbaoz+p6VYXWg+l5JqP/hRAd8N1MDhSx
         PJdWX3svLEawxIdaJx8mROYD6JKSpedlem4hehcAx2+rLTAs1F7rqOlmBJA2dtNA2r
         aSdSyJQv6nIcQ==
Date:   Tue, 22 Jun 2021 09:57:58 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     bhelgaas@google.com, alex.williamson@redhat.com, cohuck@redhat.com,
        jgg@ziepe.ca, kevin.tian@intel.com, eric.auger@redhat.com,
        giovanni.cabiddu@intel.com, mjrosato@linux.ibm.com,
        jannh@google.com, kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        minchan@kernel.org, gregkh@linuxfoundation.org, jeyu@kernel.org,
        ngupta@vflare.org, sergey.senozhatsky.work@gmail.com,
        axboe@kernel.dk, mbenes@suse.com, jpoimboe@redhat.com,
        tglx@linutronix.de, keescook@chromium.org, jikos@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] pci: export pci_dev_unlock() and the respective
 unlock
Message-ID: <20210622145758.GA3336253@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622000310.728294-1-mcgrof@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please update the subject line to match the convention:

  PCI: Export pci_dev_trylock() and pci_dev_unlock()

On Mon, Jun 21, 2021 at 05:03:09PM -0700, Luis Chamberlain wrote:
> Other places in the kernel use this form, and so just
> provide a common path for it.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

With tweaks mentioned here:

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/pci/pci.c   | 6 ++++--
>  include/linux/pci.h | 3 +++
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index f09821af1d2e..b1d9bb3f5ae2 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -5027,7 +5027,7 @@ static void pci_dev_lock(struct pci_dev *dev)
>  }
>  
>  /* Return 1 on successful lock, 0 on contention */
> -static int pci_dev_trylock(struct pci_dev *dev)
> +int pci_dev_trylock(struct pci_dev *dev)
>  {
>  	if (pci_cfg_access_trylock(dev)) {
>  		if (device_trylock(&dev->dev))
> @@ -5037,12 +5037,14 @@ static int pci_dev_trylock(struct pci_dev *dev)
>  
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(pci_dev_trylock);
>  
> -static void pci_dev_unlock(struct pci_dev *dev)
> +void pci_dev_unlock(struct pci_dev *dev)
>  {
>  	device_unlock(&dev->dev);
>  	pci_cfg_access_unlock(dev);
>  }
> +EXPORT_SYMBOL_GPL(pci_dev_unlock);
>  
>  static void pci_dev_save_and_disable(struct pci_dev *dev)
>  {
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 6248e044dd29..c55368f58965 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1353,6 +1353,9 @@ int devm_request_pci_bus_resources(struct device *dev,
>  /* Temporary until new and working PCI SBR API in place */
>  int pci_bridge_secondary_bus_reset(struct pci_dev *dev);
>  
> +int pci_dev_trylock(struct pci_dev *dev);
> +void pci_dev_unlock(struct pci_dev *dev);

Move next to pci_cfg_access_lock(), which seems a little more related.

>  #define pci_bus_for_each_resource(bus, res, i)				\
>  	for (i = 0;							\
>  	    (res = pci_bus_resource_n(bus, i)) || i < PCI_BRIDGE_RESOURCE_NUM; \
> -- 
> 2.30.2
> 
