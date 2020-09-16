Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A968F26C936
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 21:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgIPTE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 15:04:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32298 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727422AbgIPRqU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Sep 2020 13:46:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600278367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZLmHQQTvYZ1vyzqk0TBru3JZL4lsKVfVuFbc/jCl0b0=;
        b=VtIYidXfFA6uvgpsyl6DS7Fw7UHcmMOZXlnFiQ4+gR2qEUYEadf1MwU7wPVpAEN23YQwcs
        gABbFKoPFUEVIUwPcMZdvgJ0mF23tTFLfcqeIY0zvG1cxPqpw4FxeCp/i52jTCorYMdVxB
        EagJWQqmXb5n4QCnRfzphjxpDUBtpPs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-XOPxXcRAN1KoDzSHz7IBQQ-1; Wed, 16 Sep 2020 07:05:42 -0400
X-MC-Unique: XOPxXcRAN1KoDzSHz7IBQQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5300080EF84;
        Wed, 16 Sep 2020 11:05:41 +0000 (UTC)
Received: from gondolin (ovpn-112-252.ams2.redhat.com [10.36.112.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7815F5FC36;
        Wed, 16 Sep 2020 11:05:27 +0000 (UTC)
Date:   Wed, 16 Sep 2020 13:05:24 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, pmorel@linux.ibm.com,
        schnelle@linux.ibm.com, rth@twiddle.net, david@redhat.com,
        thuth@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 5/5] s390x/pci: Honor DMA limits set by vfio
Message-ID: <20200916130524.48e11b26.cohuck@redhat.com>
In-Reply-To: <1600197283-25274-6-git-send-email-mjrosato@linux.ibm.com>
References: <1600197283-25274-1-git-send-email-mjrosato@linux.ibm.com>
        <1600197283-25274-6-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Sep 2020 15:14:43 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> When an s390 guest is using lazy unmapping, it can result in a very
> large number of oustanding DMA requests, far beyond the default
> limit configured for vfio.  Let's track DMA usage similar to vfio
> in the host, and trigger the guest to flush their DMA mappings
> before vfio runs out.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  hw/s390x/s390-pci-bus.c  | 56 +++++++++++++++++++++++++++++++++++++++++++-----
>  hw/s390x/s390-pci-bus.h  |  9 ++++++++
>  hw/s390x/s390-pci-inst.c | 34 +++++++++++++++++++++++------
>  hw/s390x/s390-pci-inst.h |  3 +++
>  4 files changed, 91 insertions(+), 11 deletions(-)

(...)

> @@ -737,6 +740,41 @@ static void s390_pci_iommu_free(S390pciState *s, PCIBus *bus, int32_t devfn)
>      object_unref(OBJECT(iommu));
>  }
>  
> +static S390PCIDMACount *s390_start_dma_count(S390pciState *s, VFIODevice *vdev)

Should these go into the new vfio-related file?

> +{
> +    int id = vdev->group->container->fd;
> +    S390PCIDMACount *cnt;
> +    uint32_t avail;
> +
> +    if (!s390_pci_update_dma_avail(id, &avail)) {
> +        return NULL;
> +    }
> +
> +    QTAILQ_FOREACH(cnt, &s->zpci_dma_limit, link) {
> +        if (cnt->id  == id) {
> +            cnt->users++;
> +            return cnt;
> +        }
> +    }
> +
> +    cnt = g_new0(S390PCIDMACount, 1);
> +    cnt->id = id;
> +    cnt->users = 1;
> +    cnt->avail = avail;
> +    QTAILQ_INSERT_TAIL(&s->zpci_dma_limit, cnt, link);
> +    return cnt;
> +}
> +
> +static void s390_end_dma_count(S390pciState *s, S390PCIDMACount *cnt)
> +{
> +    assert(cnt);
> +
> +    cnt->users--;
> +    if (cnt->users == 0) {
> +        QTAILQ_REMOVE(&s->zpci_dma_limit, cnt, link);
> +    }
> +}
> +
>  static void s390_pcihost_realize(DeviceState *dev, Error **errp)
>  {
>      PCIBus *b;
> @@ -764,6 +802,7 @@ static void s390_pcihost_realize(DeviceState *dev, Error **errp)
>      s->bus_no = 0;
>      QTAILQ_INIT(&s->pending_sei);
>      QTAILQ_INIT(&s->zpci_devs);
> +    QTAILQ_INIT(&s->zpci_dma_limit);
>  
>      css_register_io_adapters(CSS_IO_ADAPTER_PCI, true, false,
>                               S390_ADAPTER_SUPPRESSIBLE, errp);
> @@ -902,6 +941,7 @@ static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
>  {
>      S390pciState *s = S390_PCI_HOST_BRIDGE(hotplug_dev);
>      PCIDevice *pdev = NULL;
> +    VFIOPCIDevice *vpdev = NULL;
>      S390PCIBusDevice *pbdev = NULL;
>  
>      if (object_dynamic_cast(OBJECT(dev), TYPE_PCI_BRIDGE)) {
> @@ -941,17 +981,20 @@ static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
>              }
>          }
>  
> +        pbdev->pdev = pdev;
> +        pbdev->iommu = s390_pci_get_iommu(s, pci_get_bus(pdev), pdev->devfn);
> +        pbdev->iommu->pbdev = pbdev;
> +        pbdev->state = ZPCI_FS_DISABLED;
> +
>          if (object_dynamic_cast(OBJECT(dev), "vfio-pci")) {
>              pbdev->fh |= FH_SHM_VFIO;
> +            vpdev = container_of(pbdev->pdev, VFIOPCIDevice, pdev);
> +            pbdev->iommu->dma_limit = s390_start_dma_count(s,
> +                                                           &vpdev->vbasedev);

I think you can just pass s and pbdev to that function... that would
move dealing with vfio specifics from this file.

>          } else {
>              pbdev->fh |= FH_SHM_EMUL;
>          }
>  
> -        pbdev->pdev = pdev;
> -        pbdev->iommu = s390_pci_get_iommu(s, pci_get_bus(pdev), pdev->devfn);
> -        pbdev->iommu->pbdev = pbdev;
> -        pbdev->state = ZPCI_FS_DISABLED;
> -
>          if (s390_pci_msix_init(pbdev)) {
>              error_setg(errp, "MSI-X support is mandatory "
>                         "in the S390 architecture");

(...)

> diff --git a/hw/s390x/s390-pci-inst.c b/hw/s390x/s390-pci-inst.c
> index 2f7a7d7..cc34b17 100644
> --- a/hw/s390x/s390-pci-inst.c
> +++ b/hw/s390x/s390-pci-inst.c
> @@ -32,6 +32,9 @@
>          }                                                          \
>      } while (0)
>  
> +#define inc_dma_avail(iommu) if (iommu->dma_limit) iommu->dma_limit->avail++;

I was thinking more of something like

static inline void inc_dma_avail(S390PCIIOMMU *iommu)
{
    if (iommu->dma_limit) {
        iommu->dma_limit->avail++;
    }
}

> +#define dec_dma_avail(iommu) if (iommu->dma_limit) iommu->dma_limit->avail--;
> +
>  static void s390_set_status_code(CPUS390XState *env,
>                                   uint8_t r, uint64_t status_code)
>  {

(...)

