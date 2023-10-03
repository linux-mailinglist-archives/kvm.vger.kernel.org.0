Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2B67B651F
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 11:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239535AbjJCJNS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 05:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239601AbjJCJNG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 05:13:06 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4319BB;
        Tue,  3 Oct 2023 02:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696324371; x=1727860371;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=lCXreDDaQlIfmi5598SMGDo0c2nFpIo2njqzrc8NFU0=;
  b=dW4nBQOnbbAo8kFLBlxrXY5BG63yyXYZ264ZJnTeKyL389km68+iYfBu
   KtzsHwUqCtO1vaO9/fLyazJF7kLBKRRxQp8R4E0EMbS68t3aIVVfKW/2K
   GHQpqyTA8ivEvNEXYC1PiwXDbWa2Zt6gt0QUlQfum8a7+UCvV7gPzt2W/
   +nuXWMgUknB9s4zek4Tg73YZWsV7tqPFfWy2TOWphI896mGUfZ1l+8CpM
   LhEhK3OXajQz14mfOJ4CHTOpEJGU1j8z4gcVwfszzXpnIaWNKBaUy4YFy
   pspSJmFSWJwHAz8r3fERT+cB8Z247R21U31lfKZggMcZXTSyuIRImjztB
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="367877673"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="367877673"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 02:12:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="780235331"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="780235331"
Received: from tciutacu-mobl.ger.corp.intel.com ([10.252.40.114])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 02:12:43 -0700
Date:   Tue, 3 Oct 2023 12:12:40 +0300 (EEST)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Lukas Wunner <lukas@wunner.de>
cc:     Bjorn Helgaas <helgaas@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-pci@vger.kernel.org, linux-cxl@vger.kernel.org,
        linux-coco@lists.linux.dev, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linuxarm@huawei.com, David Box <david.e.box@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Wilfred Mallawa <wilfred.mallawa@wdc.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH 12/12] PCI/CMA: Grant guests exclusive control of
 authentication
In-Reply-To: <467bff0c4bab93067b1e353e5b8a92f1de353a3f.1695921657.git.lukas@wunner.de>
Message-ID: <d517dad-95eb-17c2-de47-2dd2bc7070c9@linux.intel.com>
References: <cover.1695921656.git.lukas@wunner.de> <467bff0c4bab93067b1e353e5b8a92f1de353a3f.1695921657.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 28 Sep 2023, Lukas Wunner wrote:

> At any given time, only a single entity in a physical system may have
> an SPDM connection to a device.  That's because the GET_VERSION request
> (which begins an authentication sequence) resets "the connection and all
> context associated with that connection" (SPDM 1.3.0 margin no 158).
> 
> Thus, when a device is passed through to a guest and the guest has
> authenticated it, a subsequent authentication by the host would reset
> the device's CMA-SPDM session behind the guest's back.
> 
> Prevent by letting the guest claim exclusive CMA ownership of the device
> during passthrough.  Refuse CMA reauthentication on the host as long.

Is something missing after "as long" ? Perhaps "as long as the device is 
passed through"?

Also "Prevent by" feels incomplete grammarwise, it begs a question prevent 
what? Perhaps it's enough to start just with "Let the guest ..." as the 
next sentence covers the prevent part anyway.

-- 
 i.


> After passthrough has concluded, reauthenticate the device on the host.
> 
> Store the flag indicating guest ownership in struct pci_dev's priv_flags
> to avoid the concurrency issues observed by commit 44bda4b7d26e ("PCI:
> Fix is_added/is_busmaster race condition").
> 
> Side note:  The Data Object Exchange r1.1 ECN (published Oct 11 2022)
> retrofits DOE with Connection IDs.  In theory these allow simultaneous
> CMA-SPDM connections by multiple entities to the same device.  But the
> first hardware generation capable of CMA-SPDM only supports DOE r1.0.
> The specification also neglects to reserve unique Connection IDs for
> hosts and guests, which further limits its usefulness.
> 
> In general, forcing the transport to compensate for SPDM's lack of a
> connection identifier feels like a questionable layering violation.
> 
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/pci/cma.c                | 41 ++++++++++++++++++++++++++++++++
>  drivers/pci/pci.h                |  1 +
>  drivers/vfio/pci/vfio_pci_core.c |  9 +++++--
>  include/linux/pci.h              |  8 +++++++
>  include/linux/spdm.h             |  2 ++
>  lib/spdm_requester.c             | 11 +++++++++
>  6 files changed, 70 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/cma.c b/drivers/pci/cma.c
> index c539ad85a28f..b3eee137ffe2 100644
> --- a/drivers/pci/cma.c
> +++ b/drivers/pci/cma.c
> @@ -82,9 +82,50 @@ int pci_cma_reauthenticate(struct pci_dev *pdev)
>  	if (!pdev->cma_capable)
>  		return -ENOTTY;
>  
> +	if (test_bit(PCI_CMA_OWNED_BY_GUEST, &pdev->priv_flags))
> +		return -EPERM;
> +
>  	return spdm_authenticate(pdev->spdm_state);
>  }
>  
> +#if IS_ENABLED(CONFIG_VFIO_PCI_CORE)
> +/**
> + * pci_cma_claim_ownership() - Claim exclusive CMA-SPDM control for guest VM
> + * @pdev: PCI device
> + *
> + * Claim exclusive CMA-SPDM control for a guest virtual machine before
> + * passthrough of @pdev.  The host refrains from performing CMA-SPDM
> + * authentication of the device until passthrough has concluded.
> + *
> + * Necessary because the GET_VERSION request resets the SPDM connection
> + * and DOE r1.0 allows only a single SPDM connection for the entire system.
> + * So the host could reset the guest's SPDM connection behind the guest's back.
> + */
> +void pci_cma_claim_ownership(struct pci_dev *pdev)
> +{
> +	set_bit(PCI_CMA_OWNED_BY_GUEST, &pdev->priv_flags);
> +
> +	if (pdev->cma_capable)
> +		spdm_await(pdev->spdm_state);
> +}
> +EXPORT_SYMBOL(pci_cma_claim_ownership);
> +
> +/**
> + * pci_cma_return_ownership() - Relinquish CMA-SPDM control to the host
> + * @pdev: PCI device
> + *
> + * Relinquish CMA-SPDM control to the host after passthrough of @pdev to a
> + * guest virtual machine has concluded.
> + */
> +void pci_cma_return_ownership(struct pci_dev *pdev)
> +{
> +	clear_bit(PCI_CMA_OWNED_BY_GUEST, &pdev->priv_flags);
> +
> +	pci_cma_reauthenticate(pdev);
> +}
> +EXPORT_SYMBOL(pci_cma_return_ownership);
> +#endif
> +
>  void pci_cma_destroy(struct pci_dev *pdev)
>  {
>  	if (pdev->spdm_state)
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index d80cc06be0cc..05ae6359b152 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -388,6 +388,7 @@ static inline bool pci_dev_is_disconnected(const struct pci_dev *dev)
>  #define PCI_DEV_ADDED 0
>  #define PCI_DPC_RECOVERED 1
>  #define PCI_DPC_RECOVERING 2
> +#define PCI_CMA_OWNED_BY_GUEST 3
>  
>  static inline void pci_dev_assign_added(struct pci_dev *dev, bool added)
>  {
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 1929103ee59a..6f300664a342 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -487,10 +487,12 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>  	if (ret)
>  		goto out_power;
>  
> +	pci_cma_claim_ownership(pdev);
> +
>  	/* If reset fails because of the device lock, fail this path entirely */
>  	ret = pci_try_reset_function(pdev);
>  	if (ret == -EAGAIN)
> -		goto out_disable_device;
> +		goto out_cma_return;
>  
>  	vdev->reset_works = !ret;
>  	pci_save_state(pdev);
> @@ -549,7 +551,8 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>  out_free_state:
>  	kfree(vdev->pci_saved_state);
>  	vdev->pci_saved_state = NULL;
> -out_disable_device:
> +out_cma_return:
> +	pci_cma_return_ownership(pdev);
>  	pci_disable_device(pdev);
>  out_power:
>  	if (!disable_idle_d3)
> @@ -678,6 +681,8 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>  
>  	vfio_pci_dev_set_try_reset(vdev->vdev.dev_set);
>  
> +	pci_cma_return_ownership(pdev);
> +
>  	/* Put the pm-runtime usage counter acquired during enable */
>  	if (!disable_idle_d3)
>  		pm_runtime_put(&pdev->dev);
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 2c5fde81bb85..c14ea0e74fc4 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -2386,6 +2386,14 @@ static inline resource_size_t pci_iov_resource_size(struct pci_dev *dev, int res
>  static inline void pci_vf_drivers_autoprobe(struct pci_dev *dev, bool probe) { }
>  #endif
>  
> +#ifdef CONFIG_PCI_CMA
> +void pci_cma_claim_ownership(struct pci_dev *pdev);
> +void pci_cma_return_ownership(struct pci_dev *pdev);
> +#else
> +static inline void pci_cma_claim_ownership(struct pci_dev *pdev) { }
> +static inline void pci_cma_return_ownership(struct pci_dev *pdev) { }
> +#endif
> +
>  #if defined(CONFIG_HOTPLUG_PCI) || defined(CONFIG_HOTPLUG_PCI_MODULE)
>  void pci_hp_create_module_link(struct pci_slot *pci_slot);
>  void pci_hp_remove_module_link(struct pci_slot *pci_slot);
> diff --git a/include/linux/spdm.h b/include/linux/spdm.h
> index 69a83bc2eb41..d796127fbe9a 100644
> --- a/include/linux/spdm.h
> +++ b/include/linux/spdm.h
> @@ -34,6 +34,8 @@ int spdm_authenticate(struct spdm_state *spdm_state);
>  
>  bool spdm_authenticated(struct spdm_state *spdm_state);
>  
> +void spdm_await(struct spdm_state *spdm_state);
> +
>  void spdm_destroy(struct spdm_state *spdm_state);
>  
>  #endif
> diff --git a/lib/spdm_requester.c b/lib/spdm_requester.c
> index b2af2074ba6f..99424d6aebf5 100644
> --- a/lib/spdm_requester.c
> +++ b/lib/spdm_requester.c
> @@ -1483,6 +1483,17 @@ struct spdm_state *spdm_create(struct device *dev, spdm_transport *transport,
>  }
>  EXPORT_SYMBOL_GPL(spdm_create);
>  
> +/**
> + * spdm_await() - Wait for ongoing spdm_authenticate() to finish
> + *
> + * @spdm_state: SPDM session state
> + */
> +void spdm_await(struct spdm_state *spdm_state)
> +{
> +	mutex_lock(&spdm_state->lock);
> +	mutex_unlock(&spdm_state->lock);
> +}
> +
>  /**
>   * spdm_destroy() - Destroy SPDM session
>   *
> 
