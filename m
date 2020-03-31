Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9038D19988D
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 16:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731234AbgCaOae (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 10:30:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56336 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730980AbgCaOad (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 10:30:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585665032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y3JQzDu41M8o39GXgIAVsohawRfa23jPDPNH2E+Xc14=;
        b=Lb5bEyr9R56OcTrLxQsZjBi9gHvlD1pVSbv0vYU8G1qf04fpPOCxcBdRXChi9fgvbbF8tB
        9xSFCx7y8bd2YpBGwqeEJKRWqYeeSnspBpgZLlX9zuW7DZT3h7vhlYyamw54GMquS5F6nS
        4BKmU1/uhx+DxLOAH3Sp5TH62LV5ruE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-JEk-THX6NiWcPUo3QNy1vQ-1; Tue, 31 Mar 2020 10:30:29 -0400
X-MC-Unique: JEk-THX6NiWcPUo3QNy1vQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C51191084433;
        Tue, 31 Mar 2020 14:30:26 +0000 (UTC)
Received: from [10.36.112.58] (ovpn-112-58.ams2.redhat.com [10.36.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CC9B100EBD4;
        Tue, 31 Mar 2020 14:30:07 +0000 (UTC)
From:   Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v2 10/22] vfio/pci: set host iommu context to vIOMMU
To:     Liu Yi L <yi.l.liu@intel.com>, qemu-devel@nongnu.org,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     pbonzini@redhat.com, mst@redhat.com, david@gibson.dropbear.id.au,
        kevin.tian@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, hao.wu@intel.com, jean-philippe@linaro.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-11-git-send-email-yi.l.liu@intel.com>
Message-ID: <564d1a55-04df-a3bd-5241-e30f958a4e89@redhat.com>
Date:   Tue, 31 Mar 2020 16:30:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1585542301-84087-11-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yi,

On 3/30/20 6:24 AM, Liu Yi L wrote:
> For vfio-pci devices, it could use pci_device_set/unset_iommu() to
> expose host iommu context to vIOMMU emulators. vIOMMU emulators
> could make use the methods provided by host iommu context. e.g.
> propagate requests to host iommu.
I think I would squash this patch into the previous one.

> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  hw/vfio/pci.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
> index 5e75a95..c140c88 100644
> --- a/hw/vfio/pci.c
> +++ b/hw/vfio/pci.c
> @@ -2717,6 +2717,7 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
>      VFIOPCIDevice *vdev = PCI_VFIO(pdev);
>      VFIODevice *vbasedev_iter;
>      VFIOGroup *group;
> +    VFIOContainer *container;
>      char *tmp, *subsys, group_path[PATH_MAX], *group_name;
>      Error *err = NULL;
>      ssize_t len;
> @@ -3028,6 +3029,11 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
>      vfio_register_req_notifier(vdev);
>      vfio_setup_resetfn_quirk(vdev);
>  
> +    container = vdev->vbasedev.group->container;
> +    if (container->iommu_ctx.initialized) {
Sin't it possible to dynamically allocate the iommu_ctx so that you can
simply check container->iommu_ctx and discard the initialized field?
> +        pci_device_set_iommu_context(pdev, &container->iommu_ctx);
> +    }
> +
>      return;
>  
>  out_deregister:
> @@ -3072,9 +3078,16 @@ static void vfio_instance_finalize(Object *obj)
>  static void vfio_exitfn(PCIDevice *pdev)
>  {
>      VFIOPCIDevice *vdev = PCI_VFIO(pdev);
> +    VFIOContainer *container;
>  
>      vfio_unregister_req_notifier(vdev);
>      vfio_unregister_err_notifier(vdev);
> +
> +    container = vdev->vbasedev.group->container;
> +    if (container->iommu_ctx.initialized) {
> +        pci_device_unset_iommu_context(pdev);
> +    }
> +
>      pci_device_set_intx_routing_notifier(&vdev->pdev, NULL);
>      if (vdev->irqchip_change_notifier.notify) {
>          kvm_irqchip_remove_change_notifier(&vdev->irqchip_change_notifier);
> 
Thanks

Eric

