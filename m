Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D884562E11
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 04:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfGICXp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 22:23:45 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36699 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbfGICXp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jul 2019 22:23:45 -0400
Received: by mail-pl1-f193.google.com with SMTP id k8so9261322plt.3
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2019 19:23:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FftJaRbYWHNa3kHaHykrZd5QPuju+ZHzp0iECf6zExs=;
        b=sO22OKEkWiL+1NR6BcKR5nB2tczjZTKLIRDw5sTckotWAVi2Ds+tmtq+lrUWyaGGZV
         rEtiZXd1hIvZbaq7L0MJ6G+Aw/x0ZDZwkLF+8jAiZsGPUvS2hWxrzzogkJA1G4BIvqAU
         sNg52lro0WJMsLflYpnW3r1PjPG8y4Mo9eQXyqJMZFJmiksLuU/to6qQwi4+SdeLOAM5
         ySO8fsT34QB+jiWPlvEvUQn/zih8N/US7n33Ivew9V59IUKS47IJ2mPGzXx9nYu/DnQ9
         2Nw870sPv1LEk3l9DtB5NR8IlGUW9C+HeW5WURuSgDO2O+Rx3CPqQiz7u0MbSpKCn99p
         RTdQ==
X-Gm-Message-State: APjAAAXcFpMfLMPbDKlOjJNREdq8iibewpWIOCGHOEBJnUObUkbMPRLj
        E950q9kKEgq1kAsMIuG62yabDQ==
X-Google-Smtp-Source: APXvYqwzmKpI5EesOO0vk+59pI/520HJ89u6q7GGPvTwITw0dJNDabjnRhXuYY8/ZwR5FdtuFXypUQ==
X-Received: by 2002:a17:902:b944:: with SMTP id h4mr28322101pls.179.1562639024360;
        Mon, 08 Jul 2019 19:23:44 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 30sm881340pjk.17.2019.07.08.19.23.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 19:23:43 -0700 (PDT)
From:   Peter Xu <zhexu@redhat.com>
X-Google-Original-From: Peter Xu <peterx@redhat.com>
Date:   Tue, 9 Jul 2019 10:23:32 +0800
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, tianyu.lan@intel.com,
        kevin.tian@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v1 05/18] vfio/pci: add pasid alloc/free implementation
Message-ID: <20190709022332.GC5178@xz-x1>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-6-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1562324511-2910-6-git-send-email-yi.l.liu@intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 05, 2019 at 07:01:38PM +0800, Liu Yi L wrote:
> This patch adds vfio implementation PCIPASIDOps.alloc_pasid/free_pasid().
> These two functions are used to propagate guest pasid allocation and
> free requests to host via vfio container ioctl.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
> ---
>  hw/vfio/pci.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 61 insertions(+)
> 
> diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
> index ce3fe96..ab184ad 100644
> --- a/hw/vfio/pci.c
> +++ b/hw/vfio/pci.c
> @@ -2690,6 +2690,65 @@ static void vfio_unregister_req_notifier(VFIOPCIDevice *vdev)
>      vdev->req_enabled = false;
>  }
>  
> +static int vfio_pci_device_request_pasid_alloc(PCIBus *bus,
> +                                               int32_t devfn,
> +                                               uint32_t min_pasid,
> +                                               uint32_t max_pasid)
> +{
> +    PCIDevice *pdev = bus->devices[devfn];
> +    VFIOPCIDevice *vdev = DO_UPCAST(VFIOPCIDevice, pdev, pdev);
> +    VFIOContainer *container = vdev->vbasedev.group->container;
> +    struct vfio_iommu_type1_pasid_request req;
> +    unsigned long argsz;
> +    int pasid;
> +
> +    argsz = sizeof(req);
> +    req.argsz = argsz;
> +    req.flag = VFIO_IOMMU_PASID_ALLOC;
> +    req.min_pasid = min_pasid;
> +    req.max_pasid = max_pasid;
> +
> +    rcu_read_lock();

Could I ask what's this RCU lock protecting?

> +    pasid = ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req);
> +    if (pasid < 0) {
> +        error_report("vfio_pci_device_request_pasid_alloc:"
> +                     " request failed, contanier: %p", container);

Can use __func__, also since we're going to dump the error after all,
we can also include the errno (pasid) here which seems to be more
helpful than the container pointer at least to me. :)

> +    }
> +    rcu_read_unlock();
> +    return pasid;
> +}
> +
> +static int vfio_pci_device_request_pasid_free(PCIBus *bus,
> +                                              int32_t devfn,
> +                                              uint32_t pasid)
> +{
> +    PCIDevice *pdev = bus->devices[devfn];
> +    VFIOPCIDevice *vdev = DO_UPCAST(VFIOPCIDevice, pdev, pdev);
> +    VFIOContainer *container = vdev->vbasedev.group->container;
> +    struct vfio_iommu_type1_pasid_request req;
> +    unsigned long argsz;
> +    int ret = 0;
> +
> +    argsz = sizeof(req);
> +    req.argsz = argsz;
> +    req.flag = VFIO_IOMMU_PASID_FREE;
> +    req.pasid = pasid;
> +
> +    rcu_read_lock();
> +    ret = ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req);
> +    if (ret != 0) {
> +        error_report("vfio_pci_device_request_pasid_free:"
> +                     " request failed, contanier: %p", container);
> +    }
> +    rcu_read_unlock();
> +    return ret;
> +}
> +
> +static PCIPASIDOps vfio_pci_pasid_ops = {
> +    .alloc_pasid = vfio_pci_device_request_pasid_alloc,
> +    .free_pasid = vfio_pci_device_request_pasid_free,
> +};
> +
>  static void vfio_realize(PCIDevice *pdev, Error **errp)
>  {
>      VFIOPCIDevice *vdev = PCI_VFIO(pdev);
> @@ -2991,6 +3050,8 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
>      vfio_register_req_notifier(vdev);
>      vfio_setup_resetfn_quirk(vdev);
>  
> +    pci_setup_pasid_ops(pdev, &vfio_pci_pasid_ops);
> +
>      return;
>  
>  out_teardown:
> -- 
> 2.7.4
> 

Regards,

-- 
Peter Xu
