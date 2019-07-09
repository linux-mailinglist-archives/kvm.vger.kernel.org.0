Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7B462DF2
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 04:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbfGICMV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 22:12:21 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36819 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfGICMV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jul 2019 22:12:21 -0400
Received: by mail-pl1-f194.google.com with SMTP id k8so9248254plt.3
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2019 19:12:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=p4fDztI4yK31b1rF1iA4XA0Zx6iti4MMOhx5dDcCLyE=;
        b=pUuF6KVSey85tyHZ27aBtUS1uz6T6c6w6YCybtxxKYE+EVQJYpeOwKU0SebcSLLwmd
         rZvFzvZeBptJWPYNwKs6BMduNs89tMoX82ik7O7BoFK0PGnj/YultkmA/1Jwk+FP5HmV
         qQiziFf1LzN+FJpquKqS4JACxsKqbeM0EMcuNdc1EKZdZBpuPjLH53XQHkt8kZfm7qW5
         xs8U2+YL2i3mX82rIoD4ictzA9rCyYLpeJOl7kc2nhnMyZMLcSL9fpHOSgBRgqQCMHrr
         UFuAOeWqIDum1XhK4wA3CtAlCD05JocZg/E0z0i3uVWTHmDVDd7sFv1qMv2L7bZM3mE2
         du8A==
X-Gm-Message-State: APjAAAU/p8AjFLPi2yZ+MAy9xLjaRVQfgUD23heGXAnx6xRr7XpResyC
        0CLlL9oajFNBUFu1a+/6wXeZWg==
X-Google-Smtp-Source: APXvYqyDXF+Yj2ZJU2o9g+rr0hX8h4xaruANo3s6o4ynyp6Dm020aqXWZ83GJ+YvwWGkq45XhF1A5A==
X-Received: by 2002:a17:902:7043:: with SMTP id h3mr29873175plt.10.1562638340979;
        Mon, 08 Jul 2019 19:12:20 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 34sm7144861pgl.15.2019.07.08.19.12.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 19:12:20 -0700 (PDT)
From:   Peter Xu <zhexu@redhat.com>
X-Google-Original-From: Peter Xu <peterx@redhat.com>
Date:   Tue, 9 Jul 2019 10:12:09 +0800
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, tianyu.lan@intel.com,
        kevin.tian@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v1 03/18] hw/pci: introduce PCIPASIDOps to PCIDevice
Message-ID: <20190709021209.GA5178@xz-x1>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-4-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1562324511-2910-4-git-send-email-yi.l.liu@intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 05, 2019 at 07:01:36PM +0800, Liu Yi L wrote:
> +void pci_setup_pasid_ops(PCIDevice *dev, PCIPASIDOps *ops)
> +{
> +    assert(ops && !dev->pasid_ops);
> +    dev->pasid_ops = ops;
> +}
> +
> +bool pci_device_is_ops_set(PCIBus *bus, int32_t devfn)

Name should be "pci_device_is_pasid_ops_set".  Or maybe you can simply
drop this function because as long as you check it in helper functions
like [1] below always then it seems even unecessary.

> +{
> +    PCIDevice *dev;
> +
> +    if (!bus) {
> +        return false;
> +    }
> +
> +    dev = bus->devices[devfn];
> +    return !!(dev && dev->pasid_ops);
> +}
> +
> +int pci_device_request_pasid_alloc(PCIBus *bus, int32_t devfn,
> +                                   uint32_t min_pasid, uint32_t max_pasid)

From VT-d spec I see that the virtual command "allocate pasid" does
not have bdf information so it's global, but here we've got bus/devfn.
I'm curious is that reserved for ARM or some other arch?

> +{
> +    PCIDevice *dev;
> +
> +    if (!bus) {
> +        return -1;
> +    }
> +
> +    dev = bus->devices[devfn];
> +    if (dev && dev->pasid_ops && dev->pasid_ops->alloc_pasid) {

[1]

> +        return dev->pasid_ops->alloc_pasid(bus, devfn, min_pasid, max_pasid);
> +    }
> +    return -1;
> +}
> +
> +int pci_device_request_pasid_free(PCIBus *bus, int32_t devfn,
> +                                  uint32_t pasid)
> +{
> +    PCIDevice *dev;
> +
> +    if (!bus) {
> +        return -1;
> +    }
> +
> +    dev = bus->devices[devfn];
> +    if (dev && dev->pasid_ops && dev->pasid_ops->free_pasid) {
> +        return dev->pasid_ops->free_pasid(bus, devfn, pasid);
> +    }
> +    return -1;
> +}
> +
>  static void pci_dev_get_w64(PCIBus *b, PCIDevice *dev, void *opaque)
>  {
>      Range *range = opaque;
> diff --git a/include/hw/pci/pci.h b/include/hw/pci/pci.h
> index d082707..16e5b8e 100644
> --- a/include/hw/pci/pci.h
> +++ b/include/hw/pci/pci.h
> @@ -262,6 +262,13 @@ struct PCIReqIDCache {
>  };
>  typedef struct PCIReqIDCache PCIReqIDCache;
>  
> +typedef struct PCIPASIDOps PCIPASIDOps;
> +struct PCIPASIDOps {
> +    int (*alloc_pasid)(PCIBus *bus, int32_t devfn,
> +                         uint32_t min_pasid, uint32_t max_pasid);
> +    int (*free_pasid)(PCIBus *bus, int32_t devfn, uint32_t pasid);
> +};
> +
>  struct PCIDevice {
>      DeviceState qdev;
>  
> @@ -351,6 +358,7 @@ struct PCIDevice {
>      MSIVectorUseNotifier msix_vector_use_notifier;
>      MSIVectorReleaseNotifier msix_vector_release_notifier;
>      MSIVectorPollNotifier msix_vector_poll_notifier;
> +    PCIPASIDOps *pasid_ops;
>  };
>  
>  void pci_register_bar(PCIDevice *pci_dev, int region_num,
> @@ -484,6 +492,12 @@ typedef AddressSpace *(*PCIIOMMUFunc)(PCIBus *, void *, int);
>  AddressSpace *pci_device_iommu_address_space(PCIDevice *dev);
>  void pci_setup_iommu(PCIBus *bus, PCIIOMMUFunc fn, void *opaque);
>  
> +void pci_setup_pasid_ops(PCIDevice *dev, PCIPASIDOps *ops);
> +bool pci_device_is_ops_set(PCIBus *bus, int32_t devfn);
> +int pci_device_request_pasid_alloc(PCIBus *bus, int32_t devfn,
> +                                   uint32_t min_pasid, uint32_t max_pasid);
> +int pci_device_request_pasid_free(PCIBus *bus, int32_t devfn, uint32_t pasid);
> +
>  static inline void
>  pci_set_byte(uint8_t *config, uint8_t val)
>  {
> -- 
> 2.7.4
> 

Regards,

-- 
Peter Xu
