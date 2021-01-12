Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0812F2A9B
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 10:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392452AbhALJCL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 04:02:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29857 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405799AbhALJCK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 04:02:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610442040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iwyfkNw2afBPRrxQMpLhiFwOVdJHGDgnNeM4Lo7myPQ=;
        b=DmJjUk281CBC1oosfsDICYCO9L6GOYJVSufM4h3AkA9m7nDSJwPlJJgW1oPneGZYcxUHRw
        53YeReG50wMIOC3xmU1P1ExX9C+NtxRB/WRV5ttzhH4oIzYYl+vBfYzjgn+Qstn8ftKM/T
        xG7yvotlHkLNMg6KgcIpoWVXsKy1Xf4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-fMQU1PC6OCOBZHkmBzohFw-1; Tue, 12 Jan 2021 04:00:38 -0500
X-MC-Unique: fMQU1PC6OCOBZHkmBzohFw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 627928145E1;
        Tue, 12 Jan 2021 09:00:36 +0000 (UTC)
Received: from [10.36.114.62] (ovpn-114-62.ams2.redhat.com [10.36.114.62])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BB9365D762;
        Tue, 12 Jan 2021 09:00:28 +0000 (UTC)
Subject: Re: [RFC v3 1/2] vfio/platform: add support for msi
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vikram Prakash <vikram.prakash@broadcom.com>,
        Srinath Mannam <srinath.mannam@broadcom.com>,
        Ashwin Kamath <ashwin.kamath@broadcom.com>,
        Zac Schroff <zachary.schroff@broadcom.com>,
        Manish Kurup <manish.kurup@broadcom.com>
References: <20201124161646.41191-1-vikas.gupta@broadcom.com>
 <20201214174514.22006-1-vikas.gupta@broadcom.com>
 <20201214174514.22006-2-vikas.gupta@broadcom.com>
 <0a8b9c66-a40c-1e0b-df36-41c566ce2fa9@redhat.com>
 <CAHLZf_u0mADmrJHuiJeizYPXGvbm6=u0xHhmFR_QmGui4CWQWA@mail.gmail.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <58d8e706-4710-7902-baf5-2e07b70ad069@redhat.com>
Date:   Tue, 12 Jan 2021 10:00:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAHLZf_u0mADmrJHuiJeizYPXGvbm6=u0xHhmFR_QmGui4CWQWA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vikas,

On 1/5/21 6:53 AM, Vikas Gupta wrote:
> On Tue, Dec 22, 2020 at 10:57 PM Auger Eric <eric.auger@redhat.com> wrote:
>>
>> Hi Vikas,
>>
>> On 12/14/20 6:45 PM, Vikas Gupta wrote:
>>> MSI support for platform devices.The MSI block
>>> is added as an extended IRQ which exports caps
>>> VFIO_IRQ_INFO_CAP_TYPE and VFIO_IRQ_INFO_CAP_MSI_DESCS.
>>>
>>> Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
>>> ---
>>>  drivers/vfio/platform/vfio_platform_common.c  | 179 +++++++++++-
>>>  drivers/vfio/platform/vfio_platform_irq.c     | 260 +++++++++++++++++-
>>>  drivers/vfio/platform/vfio_platform_private.h |  32 +++
>>>  include/uapi/linux/vfio.h                     |  44 +++
>>>  4 files changed, 496 insertions(+), 19 deletions(-)
>>>
>>> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
>>> index fb4b385191f2..c936852f35d7 100644
>>> --- a/drivers/vfio/platform/vfio_platform_common.c
>>> +++ b/drivers/vfio/platform/vfio_platform_common.c
>>> @@ -16,6 +16,7 @@
>>>  #include <linux/types.h>
>>>  #include <linux/uaccess.h>
>>>  #include <linux/vfio.h>
>>> +#include <linux/nospec.h>
>>>
>>>  #include "vfio_platform_private.h"
>>>
>>> @@ -26,6 +27,8 @@
>>>  #define VFIO_PLATFORM_IS_ACPI(vdev) ((vdev)->acpihid != NULL)
>>>
>>>  static LIST_HEAD(reset_list);
>>> +/* devices having MSI support */
>> nit: for devices using MSIs?
>>> +static LIST_HEAD(msi_list);
>>>  static DEFINE_MUTEX(driver_lock);
>>>
>>>  static vfio_platform_reset_fn_t vfio_platform_lookup_reset(const char *compat,
>>> @@ -47,6 +50,25 @@ static vfio_platform_reset_fn_t vfio_platform_lookup_reset(const char *compat,
>>>       return reset_fn;
>>>  }
>>>
>>> +static bool vfio_platform_lookup_msi(struct vfio_platform_device *vdev)
>>> +{
>>> +     bool has_msi = false;
>>> +     struct vfio_platform_msi_node *iter;
>>> +
>>> +     mutex_lock(&driver_lock);
>>> +     list_for_each_entry(iter, &msi_list, link) {
>>> +             if (!strcmp(iter->compat, vdev->compat) &&
>>> +                 try_module_get(iter->owner)) {
>>> +                     vdev->msi_module = iter->owner;
>>> +                     vdev->of_get_msi = iter->of_get_msi;
>>> +                     has_msi = true;
>>> +                     break;
>>> +             }
>>> +     }
>>> +     mutex_unlock(&driver_lock);
>>> +     return has_msi;
>>> +}
>>> +
>>>  static int vfio_platform_acpi_probe(struct vfio_platform_device *vdev,
>>>                                   struct device *dev)
>>>  {
>>> @@ -126,6 +148,19 @@ static int vfio_platform_get_reset(struct vfio_platform_device *vdev)
>>>       return vdev->of_reset ? 0 : -ENOENT;
>>>  }
>>>
>>> +static int vfio_platform_get_msi(struct vfio_platform_device *vdev)
>>> +{
>>> +     bool has_msi;
>>> +
>>> +     has_msi = vfio_platform_lookup_msi(vdev);
>>> +     if (!has_msi) {
>>> +             request_module("vfio-msi:%s", vdev->compat);
>>> +             has_msi = vfio_platform_lookup_msi(vdev);
>>> +     }
>>> +
>>> +     return has_msi ? 0 : -ENOENT;
>>> +}
>>> +
>>>  static void vfio_platform_put_reset(struct vfio_platform_device *vdev)
>>>  {
>>>       if (VFIO_PLATFORM_IS_ACPI(vdev))
>>> @@ -135,6 +170,12 @@ static void vfio_platform_put_reset(struct vfio_platform_device *vdev)
>>>               module_put(vdev->reset_module);
>>>  }
>>>
>>> +static void vfio_platform_put_msi(struct vfio_platform_device *vdev)
>>> +{
>>> +     if (vdev->of_get_msi)
>>> +             module_put(vdev->msi_module);
>>> +}
>>> +
>>>  static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
>>>  {
>>>       int cnt = 0, i;
>>> @@ -343,9 +384,17 @@ static long vfio_platform_ioctl(void *device_data,
>>>
>>>       } else if (cmd == VFIO_DEVICE_GET_IRQ_INFO) {
>>>               struct vfio_irq_info info;
>>> +             struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
>>> +             struct vfio_irq_info_cap_msi *msi_info = NULL;
>>> +             int ext_irq_index = vdev->num_irqs - vdev->num_ext_irqs;
>>> +             unsigned long capsz;
>>> +             u32 index;
>>>
>>>               minsz = offsetofend(struct vfio_irq_info, count);
>>>
>>> +             /* For backward compatibility, cannot require this */
>>> +             capsz = offsetofend(struct vfio_irq_info, cap_offset);
>>> +
>>>               if (copy_from_user(&info, (void __user *)arg, minsz))
>>>                       return -EFAULT;
>>>
>>> @@ -355,8 +404,94 @@ static long vfio_platform_ioctl(void *device_data,
>>>               if (info.index >= vdev->num_irqs)
>>>                       return -EINVAL;
>>>
>>> -             info.flags = vdev->irqs[info.index].flags;
>>> -             info.count = vdev->irqs[info.index].count;
>>> +             if (info.argsz >= capsz)
>>> +                     minsz = capsz;
>>> +
>>> +             index = info.index;
>>> +
>>> +             info.flags = vdev->irqs[index].flags;
>>> +             info.count = vdev->irqs[index].count;
>>> +
>>> +             if (ext_irq_index - index == VFIO_EXT_IRQ_MSI) {
>>> +                     struct vfio_irq_info_cap_type cap_type = {
>>> +                             .header.id = VFIO_IRQ_INFO_CAP_TYPE,
>>> +                             .header.version = 1 };
>>> +                     struct vfio_platform_irq *irq;
>>> +                     size_t msi_info_size;
>>> +                     int num_msgs;
>>> +                     int ret;
>>> +                     int i;
>>> +
>>> +                     index = array_index_nospec(index,
>>> +                                                vdev->num_irqs);
>>> +                     irq = &vdev->irqs[index];
>>> +
>>> +                     cap_type.type = irq->type;
>>> +                     cap_type.subtype = irq->subtype;
>>> +
>>> +                     ret = vfio_info_add_capability(&caps,
>>> +                                                    &cap_type.header,
>>> +                                                    sizeof(cap_type));
>>> +                     if (ret)
>>> +                             return ret;
>>> +
>>> +                     num_msgs = irq->num_ctx;
>>> +                     if (num_msgs) {
>>> +                             msi_info_size = struct_size(msi_info,
>>> +                                                         msgs, num_msgs);
>>> +
>>> +                             msi_info = kzalloc(msi_info_size, GFP_KERNEL);
>>> +                             if (!msi_info) {
>>> +                                     kfree(caps.buf);
>>> +                                     return -ENOMEM;
>>> +                             }
>>> +
>>> +                             msi_info->header.id =
>>> +                                             VFIO_IRQ_INFO_CAP_MSI_DESCS;
>> I thought you would remove this cap now the module is back. What is the
>> motivation to keep it?
> 
> Hi Eric,
> The earlier module was serving two purposes
> a)   Max number of MSI(s) supported by the device. Since the module is
> back this information can be filled in .count.
understood
> b)   Writing msi_msg(s) to devices for MSI sources.
>  We want b) to be handled in the user space so that they need not be
> dependent on the kernel.
I fail to understand the problem with the "dependency on the kernel".
What is the functional difference when exposing this to the userspace,
please could you highlight the benefits?

 VFIO_IRQ_INFO_CAP_MSI_DESCS is helping user
> space to get MSI configuration data and thus they can independently
> configure MSI sources. For example, user space can just ask for ‘N’
> MSI vectors and related msi_msg for ‘N’ vectors
this is induced by vfio_msi_enable(), right?


 is exported to user
> space using this CAP. User space can now use ‘N’ vectors to configure
> any ‘N’ MSI sources and these sources might be in any order.
> However, this design is different from vfio-pci as MSI configuration
> is being handled in kernel only.
> Let us know if implementing VFIO_IRQ_INFO_CAP_MSI_DESCS does not fit
> with the CAP framework.
I think it is OK reporting them through the cap but I fail to understand
the benefits.

Thanks

Eric
> 
> Thanks,
> Vikas
> 
>  >
>> Thanks
>>
>> Eric
>>> +                             msi_info->header.version = 1;
>>> +                             msi_info->nr_msgs = num_msgs;
>>> +
>>> +                             for (i = 0; i < num_msgs; i++) {
>>> +                                     struct vfio_irq_ctx *ctx = &irq->ctx[i];
>>> +
>>> +                                     msi_info->msgs[i].addr_lo =
>>> +                                                     ctx->msg.address_lo;
>>> +                                     msi_info->msgs[i].addr_hi =
>>> +                                                     ctx->msg.address_hi;
>>> +                                     msi_info->msgs[i].data = ctx->msg.data;
>>> +                             }
>>> +
>>> +                             ret = vfio_info_add_capability(&caps,
>>> +                                                     &msi_info->header,
>>> +                                                     msi_info_size);
>>> +                             if (ret) {
>>> +                                     kfree(msi_info);
>>> +                                     kfree(caps.buf);
>>> +                                     return ret;
>>> +                             }
>>> +                     }
>>> +             }
>>> +
>>> +             if (caps.size) {
>>> +                     info.flags |= VFIO_IRQ_INFO_FLAG_CAPS;
>>> +                     if (info.argsz < sizeof(info) + caps.size) {
>>> +                             info.argsz = sizeof(info) + caps.size;
>>> +                             info.cap_offset = 0;
>>> +                     } else {
>>> +                             vfio_info_cap_shift(&caps, sizeof(info));
>>> +                             if (copy_to_user((void __user *)arg +
>>> +                                               sizeof(info), caps.buf,
>>> +                                               caps.size)) {
>>> +                                     kfree(msi_info);
>>> +                                     kfree(caps.buf);
>>> +                                     return -EFAULT;
>>> +                             }
>>> +                             info.cap_offset = sizeof(info);
>>> +                     }
>>> +
>>> +                     kfree(msi_info);
>>> +                     kfree(caps.buf);
>>> +             }
>>>
>>>               return copy_to_user((void __user *)arg, &info, minsz) ?
>>>                       -EFAULT : 0;
>>> @@ -365,6 +500,7 @@ static long vfio_platform_ioctl(void *device_data,
>>>               struct vfio_irq_set hdr;
>>>               u8 *data = NULL;
>>>               int ret = 0;
>>> +             int max;
>>>               size_t data_size = 0;
>>>
>>>               minsz = offsetofend(struct vfio_irq_set, count);
>>> @@ -372,8 +508,14 @@ static long vfio_platform_ioctl(void *device_data,
>>>               if (copy_from_user(&hdr, (void __user *)arg, minsz))
>>>                       return -EFAULT;
>>>
>>> -             ret = vfio_set_irqs_validate_and_prepare(&hdr, vdev->num_irqs,
>>> -                                              vdev->num_irqs, &data_size);
>>> +             if (hdr.index >= vdev->num_irqs)
>>> +                     return -EINVAL;
>>> +
>>> +             max = vdev->irqs[hdr.index].count;
>>> +
>>> +             ret = vfio_set_irqs_validate_and_prepare(&hdr, max,
>>> +                                                      vdev->num_irqs,
>>> +                                                      &data_size);
>>>               if (ret)
>>>                       return ret;
>>>
>>> @@ -678,6 +820,10 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
>>>               return ret;
>>>       }
>>>
>>> +     ret = vfio_platform_get_msi(vdev);
>>> +     if (ret)
>>> +             dev_info(vdev->device, "msi not supported\n");
>> I don't think we should output this message. This is printed for
>> amd-xgbe which does not have msi so this is misleading. I would say
>> either the vfio_platform_get_msi() can return an actual error or we
>> return a void?
> Will check on this what
>>
>> Thanks
>>
>> Eric
>>> +
>>>       group = vfio_iommu_group_get(dev);
>>>       if (!group) {
>>>               dev_err(dev, "No IOMMU group for device %s\n", vdev->name);
>>> @@ -697,6 +843,7 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
>>>  put_iommu:
>>>       vfio_iommu_group_put(group, dev);
>>>  put_reset:
>>> +     vfio_platform_put_msi(vdev);
>>>       vfio_platform_put_reset(vdev);
>>>       return ret;
>>>  }
>>> @@ -744,6 +891,30 @@ void vfio_platform_unregister_reset(const char *compat,
>>>  }
>>>  EXPORT_SYMBOL_GPL(vfio_platform_unregister_reset);
>>>
>>> +void __vfio_platform_register_msi(struct vfio_platform_msi_node *node)
>>> +{
>>> +     mutex_lock(&driver_lock);
>>> +     list_add(&node->link, &msi_list);
>>> +     mutex_unlock(&driver_lock);
>>> +}
>>> +EXPORT_SYMBOL_GPL(__vfio_platform_register_msi);
>>> +
>>> +void vfio_platform_unregister_msi(const char *compat)
>>> +{
>>> +     struct vfio_platform_msi_node *iter, *temp;
>>> +
>>> +     mutex_lock(&driver_lock);
>>> +     list_for_each_entry_safe(iter, temp, &msi_list, link) {
>>> +             if (!strcmp(iter->compat, compat)) {
>>> +                     list_del(&iter->link);
>>> +                     break;
>>> +             }
>>> +     }
>>> +
>>> +     mutex_unlock(&driver_lock);
>>> +}
>>> +EXPORT_SYMBOL_GPL(vfio_platform_unregister_msi);
>>> +
>>>  MODULE_VERSION(DRIVER_VERSION);
>>>  MODULE_LICENSE("GPL v2");
>>>  MODULE_AUTHOR(DRIVER_AUTHOR);
>>> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
>>> index c5b09ec0a3c9..e0f4696afedd 100644
>>> --- a/drivers/vfio/platform/vfio_platform_irq.c
>>> +++ b/drivers/vfio/platform/vfio_platform_irq.c
>>> @@ -8,10 +8,12 @@
>>>
>>>  #include <linux/eventfd.h>
>>>  #include <linux/interrupt.h>
>>> +#include <linux/eventfd.h>
>>>  #include <linux/slab.h>
>>>  #include <linux/types.h>
>>>  #include <linux/vfio.h>
>>>  #include <linux/irq.h>
>>> +#include <linux/msi.h>
>>>
>>>  #include "vfio_platform_private.h"
>>>
>>> @@ -253,6 +255,195 @@ static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
>>>       return 0;
>>>  }
>>>
>>> +/* MSI/MSIX */
>>> +static irqreturn_t vfio_msihandler(int irq, void *arg)
>>> +{
>>> +     struct eventfd_ctx *trigger = arg;
>>> +
>>> +     eventfd_signal(trigger, 1);
>>> +     return IRQ_HANDLED;
>>> +}
>>> +
>>> +static void msi_write(struct msi_desc *desc, struct msi_msg *msg)
>>> +{
>>> +     int i;
>>> +     struct vfio_platform_irq *irq;
>>> +     u16 index = desc->platform.msi_index;
>>> +     struct device *dev = msi_desc_to_dev(desc);
>>> +     struct vfio_device *device = dev_get_drvdata(dev);
>>> +     struct vfio_platform_device *vdev = (struct vfio_platform_device *)
>>> +                                             vfio_device_data(device);
>>> +
>>> +     for (i = 0; i < vdev->num_irqs; i++)
>>> +             if (vdev->irqs[i].type == VFIO_IRQ_TYPE_MSI)
>>> +                     irq = &vdev->irqs[i];
>>> +
>>> +     irq->ctx[index].msg.address_lo = msg->address_lo;
>>> +     irq->ctx[index].msg.address_hi = msg->address_hi;
>>> +     irq->ctx[index].msg.data = msg->data;
>>> +}
>>> +
>>> +static int vfio_msi_enable(struct vfio_platform_device *vdev,
>>> +                        struct vfio_platform_irq *irq, int nvec)
>>> +{
>>> +     int ret;
>>> +     int msi_idx = 0;
>>> +     struct msi_desc *desc;
>>> +     struct device *dev = vdev->device;
>>> +
>>> +     irq->ctx = kcalloc(nvec, sizeof(struct vfio_irq_ctx), GFP_KERNEL);
>>> +     if (!irq->ctx)
>>> +             return -ENOMEM;
>>> +
>>> +     /* Allocate platform MSIs */
>>> +     ret = platform_msi_domain_alloc_irqs(dev, nvec, msi_write);
>>> +     if (ret < 0) {
>>> +             kfree(irq->ctx);
>>> +             return ret;
>>> +     }
>>> +
>>> +     for_each_msi_entry(desc, dev) {
>>> +             irq->ctx[msi_idx].hwirq = desc->irq;
>>> +             msi_idx++;
>>> +     }
>>> +
>>> +     irq->num_ctx = nvec;
>>> +     irq->config_msi = 1;
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static int vfio_msi_set_vector_signal(struct vfio_platform_irq *irq,
>>> +                                   int vector, int fd)
>>> +{
>>> +     struct eventfd_ctx *trigger;
>>> +     int irq_num, ret;
>>> +
>>> +     if (vector < 0 || vector >= irq->num_ctx)
>>> +             return -EINVAL;
>>> +
>>> +     irq_num = irq->ctx[vector].hwirq;
>>> +
>>> +     if (irq->ctx[vector].trigger) {
>>> +             free_irq(irq_num, irq->ctx[vector].trigger);
>>> +             kfree(irq->ctx[vector].name);
>>> +             eventfd_ctx_put(irq->ctx[vector].trigger);
>>> +             irq->ctx[vector].trigger = NULL;
>>> +     }
>>> +
>>> +     if (fd < 0)
>>> +             return 0;
>>> +
>>> +     irq->ctx[vector].name = kasprintf(GFP_KERNEL,
>>> +                                       "vfio-msi[%d]", vector);
>>> +     if (!irq->ctx[vector].name)
>>> +             return -ENOMEM;
>>> +
>>> +     trigger = eventfd_ctx_fdget(fd);
>>> +     if (IS_ERR(trigger)) {
>>> +             kfree(irq->ctx[vector].name);
>>> +             return PTR_ERR(trigger);
>>> +     }
>>> +
>>> +     ret = request_irq(irq_num, vfio_msihandler, 0,
>>> +                       irq->ctx[vector].name, trigger);
>>> +     if (ret) {
>>> +             kfree(irq->ctx[vector].name);
>>> +             eventfd_ctx_put(trigger);
>>> +             return ret;
>>> +     }
>>> +
>>> +     irq->ctx[vector].trigger = trigger;
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static int vfio_msi_set_block(struct vfio_platform_irq *irq, unsigned int start,
>>> +                           unsigned int count, int32_t *fds)
>>> +{
>>> +     int i, j, ret = 0;
>>> +
>>> +     if (start >= irq->num_ctx || start + count > irq->num_ctx)
>>> +             return -EINVAL;
>>> +
>>> +     for (i = 0, j = start; i < count && !ret; i++, j++) {
>>> +             int fd = fds ? fds[i] : -1;
>>> +
>>> +             ret = vfio_msi_set_vector_signal(irq, j, fd);
>>> +     }
>>> +
>>> +     if (ret) {
>>> +             for (--j; j >= (int)start; j--)
>>> +                     vfio_msi_set_vector_signal(irq, j, -1);
>>> +     }
>>> +
>>> +     return ret;
>>> +}
>>> +
>>> +static void vfio_msi_disable(struct vfio_platform_device *vdev,
>>> +                          struct vfio_platform_irq *irq)
>>> +{
>>> +     struct device *dev = vdev->device;
>>> +
>>> +     vfio_msi_set_block(irq, 0, irq->num_ctx, NULL);
>>> +
>>> +     platform_msi_domain_free_irqs(dev);
>>> +
>>> +     irq->config_msi = 0;
>>> +     irq->num_ctx = 0;
>>> +
>>> +     kfree(irq->ctx);
>>> +}
>>> +
>>> +static int vfio_set_msi_trigger(struct vfio_platform_device *vdev,
>>> +                             unsigned int index, unsigned int start,
>>> +                             unsigned int count, uint32_t flags, void *data)
>>> +{
>>> +     int i;
>>> +     struct vfio_platform_irq *irq = &vdev->irqs[index];
>>> +
>>> +     if (start + count > irq->count)
>>> +             return -EINVAL;
>>> +
>>> +     if (!count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
>>> +             vfio_msi_disable(vdev, irq);
>>> +             return 0;
>>> +     }
>>> +
>>> +     if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
>>> +             s32 *fds = data;
>>> +             int ret;
>>> +
>>> +             if (irq->config_msi)
>>> +                     return vfio_msi_set_block(irq, start, count,
>>> +                                               fds);
>>> +             ret = vfio_msi_enable(vdev, irq, start + count);
>>> +             if (ret)
>>> +                     return ret;
>>> +
>>> +             ret = vfio_msi_set_block(irq, start, count, fds);
>>> +             if (ret)
>>> +                     vfio_msi_disable(vdev, irq);
>>> +
>>> +             return ret;
>>> +     }
>>> +
>>> +     for (i = start; i < start + count; i++) {
>>> +             if (!irq->ctx[i].trigger)
>>> +                     continue;
>>> +             if (flags & VFIO_IRQ_SET_DATA_NONE) {
>>> +                     eventfd_signal(irq->ctx[i].trigger, 1);
>>> +             } else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
>>> +                     u8 *bools = data;
>>> +
>>> +                     if (bools[i - start])
>>> +                             eventfd_signal(irq->ctx[i].trigger, 1);
>>> +             }
>>> +     }
>>> +
>>> +     return 0;
>>> +}
>>> +
>>>  int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
>>>                                uint32_t flags, unsigned index, unsigned start,
>>>                                unsigned count, void *data)
>>> @@ -261,16 +452,29 @@ int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
>>>                   unsigned start, unsigned count, uint32_t flags,
>>>                   void *data) = NULL;
>>>
>>> -     switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
>>> -     case VFIO_IRQ_SET_ACTION_MASK:
>>> -             func = vfio_platform_set_irq_mask;
>>> -             break;
>>> -     case VFIO_IRQ_SET_ACTION_UNMASK:
>>> -             func = vfio_platform_set_irq_unmask;
>>> -             break;
>>> -     case VFIO_IRQ_SET_ACTION_TRIGGER:
>>> -             func = vfio_platform_set_irq_trigger;
>>> -             break;
>>> +     struct vfio_platform_irq *irq = &vdev->irqs[index];
>>> +
>>> +     if (irq->type == VFIO_IRQ_TYPE_MSI) {
>>> +             switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
>>> +             case VFIO_IRQ_SET_ACTION_MASK:
>>> +             case VFIO_IRQ_SET_ACTION_UNMASK:
>>> +                     break;
>>> +             case VFIO_IRQ_SET_ACTION_TRIGGER:
>>> +                     func = vfio_set_msi_trigger;
>>> +                     break;
>>> +             }
>>> +     } else {
>>> +             switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
>>> +             case VFIO_IRQ_SET_ACTION_MASK:
>>> +                     func = vfio_platform_set_irq_mask;
>>> +                     break;
>>> +             case VFIO_IRQ_SET_ACTION_UNMASK:
>>> +                     func = vfio_platform_set_irq_unmask;
>>> +                     break;
>>> +             case VFIO_IRQ_SET_ACTION_TRIGGER:
>>> +                     func = vfio_platform_set_irq_trigger;
>>> +                     break;
>>> +             }
>>>       }
>>>
>>>       if (!func)
>>> @@ -281,12 +485,21 @@ int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
>>>
>>>  int vfio_platform_irq_init(struct vfio_platform_device *vdev)
>>>  {
>>> -     int cnt = 0, i;
>>> +     int i;
>>> +     int cnt = 0;
>>> +     int num_irqs;
>>> +     int msi_cnt = 0;
>>>
>>>       while (vdev->get_irq(vdev, cnt) >= 0)
>>>               cnt++;
>>>
>>> -     vdev->irqs = kcalloc(cnt, sizeof(struct vfio_platform_irq), GFP_KERNEL);
>>> +     if (vdev->of_get_msi) {
>>> +             msi_cnt = vdev->of_get_msi(vdev);
>>> +             num_irqs++;
>>> +     }
>>> +
>>> +     vdev->irqs = kcalloc(num_irqs, sizeof(struct vfio_platform_irq),
>>> +                          GFP_KERNEL);
>>>       if (!vdev->irqs)
>>>               return -ENOMEM;
>>>
>>> @@ -309,7 +522,19 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
>>>               vdev->irqs[i].masked = false;
>>>       }
>>>
>>> -     vdev->num_irqs = cnt;
>>> +     /*
>>> +      * MSI block is added at last index and it is an ext irq
>>> +      */
>>> +     if (msi_cnt > 0) {
>>> +             vdev->irqs[i].flags = VFIO_IRQ_INFO_EVENTFD;
>>> +             vdev->irqs[i].count = msi_cnt;
>>> +             vdev->irqs[i].hwirq = 0;
>>> +             vdev->irqs[i].masked = false;
>>> +             vdev->irqs[i].type = VFIO_IRQ_TYPE_MSI;
>>> +             vdev->num_ext_irqs = 1;
>>> +     }
>>> +
>>> +     vdev->num_irqs = num_irqs;
>>>
>>>       return 0;
>>>  err:
>>> @@ -321,8 +546,13 @@ void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
>>>  {
>>>       int i;
>>>
>>> -     for (i = 0; i < vdev->num_irqs; i++)
>>> -             vfio_set_trigger(vdev, i, -1, NULL);
>>> +     for (i = 0; i < vdev->num_irqs; i++) {
>>> +             if (vdev->irqs[i].type == VFIO_IRQ_TYPE_MSI)
>>> +                     vfio_set_msi_trigger(vdev, i, 0, 0,
>>> +                                          VFIO_IRQ_SET_DATA_NONE, NULL);
>>> +             else
>>> +                     vfio_set_trigger(vdev, i, -1, NULL);
>>> +     }
>>>
>>>       vdev->num_irqs = 0;
>>>       kfree(vdev->irqs);
>>> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
>>> index 289089910643..1307feddda21 100644
>>> --- a/drivers/vfio/platform/vfio_platform_private.h
>>> +++ b/drivers/vfio/platform/vfio_platform_private.h
>>> @@ -9,6 +9,7 @@
>>>
>>>  #include <linux/types.h>
>>>  #include <linux/interrupt.h>
>>> +#include <linux/msi.h>
>>>
>>>  #define VFIO_PLATFORM_OFFSET_SHIFT   40
>>>  #define VFIO_PLATFORM_OFFSET_MASK (((u64)(1) << VFIO_PLATFORM_OFFSET_SHIFT) - 1)
>>> @@ -19,9 +20,21 @@
>>>  #define VFIO_PLATFORM_INDEX_TO_OFFSET(index) \
>>>       ((u64)(index) << VFIO_PLATFORM_OFFSET_SHIFT)
>>>
>>> +/* IRQ index for MSI in ext IRQs */
>>> +#define VFIO_EXT_IRQ_MSI     0
>>> +
>>> +struct vfio_irq_ctx {
>>> +     int                     hwirq;
>>> +     char                    *name;
>>> +     struct msi_msg          msg;
>>> +     struct eventfd_ctx      *trigger;
>>> +};
>>> +
>>>  struct vfio_platform_irq {
>>>       u32                     flags;
>>>       u32                     count;
>>> +     int                     num_ctx;
>>> +     struct vfio_irq_ctx     *ctx;
>>>       int                     hwirq;
>>>       char                    *name;
>>>       struct eventfd_ctx      *trigger;
>>> @@ -29,6 +42,11 @@ struct vfio_platform_irq {
>>>       spinlock_t              lock;
>>>       struct virqfd           *unmask;
>>>       struct virqfd           *mask;
>>> +
>>> +     /* for extended irqs */
>>> +     u32                     type;
>>> +     u32                     subtype;
>>> +     int                     config_msi;
>>>  };
>>>
>>>  struct vfio_platform_region {
>>> @@ -46,12 +64,14 @@ struct vfio_platform_device {
>>>       u32                             num_regions;
>>>       struct vfio_platform_irq        *irqs;
>>>       u32                             num_irqs;
>>> +     int                             num_ext_irqs;
>>>       int                             refcnt;
>>>       struct mutex                    igate;
>>>       struct module                   *parent_module;
>>>       const char                      *compat;
>>>       const char                      *acpihid;
>>>       struct module                   *reset_module;
>>> +     struct module                   *msi_module;
>>>       struct device                   *device;
>>>
>>>       /*
>>> @@ -65,11 +85,13 @@ struct vfio_platform_device {
>>>               (*get_resource)(struct vfio_platform_device *vdev, int i);
>>>       int     (*get_irq)(struct vfio_platform_device *vdev, int i);
>>>       int     (*of_reset)(struct vfio_platform_device *vdev);
>>> +     u32     (*of_get_msi)(struct vfio_platform_device *vdev);
>>>
>>>       bool                            reset_required;
>>>  };
>>>
>>>  typedef int (*vfio_platform_reset_fn_t)(struct vfio_platform_device *vdev);
>>> +typedef u32 (*vfio_platform_get_msi_fn_t)(struct vfio_platform_device *vdev);
>>>
>>>  struct vfio_platform_reset_node {
>>>       struct list_head link;
>>> @@ -78,6 +100,13 @@ struct vfio_platform_reset_node {
>>>       vfio_platform_reset_fn_t of_reset;
>>>  };
>>>
>>> +struct vfio_platform_msi_node {
>>> +     struct list_head link;
>>> +     char *compat;
>>> +     struct module *owner;
>>> +     vfio_platform_get_msi_fn_t of_get_msi;
>>> +};
>>> +
>>>  extern int vfio_platform_probe_common(struct vfio_platform_device *vdev,
>>>                                     struct device *dev);
>>>  extern struct vfio_platform_device *vfio_platform_remove_common
>>> @@ -94,6 +123,9 @@ extern int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
>>>  extern void __vfio_platform_register_reset(struct vfio_platform_reset_node *n);
>>>  extern void vfio_platform_unregister_reset(const char *compat,
>>>                                          vfio_platform_reset_fn_t fn);
>>> +void __vfio_platform_register_msi(struct vfio_platform_msi_node *n);
>>> +void vfio_platform_unregister_msi(const char *compat);
>>> +
>>>  #define vfio_platform_register_reset(__compat, __reset)              \
>>>  static struct vfio_platform_reset_node __reset ## _node = {  \
>>>       .owner = THIS_MODULE,                                   \
>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>>> index d1812777139f..53a7ff2b524e 100644
>>> --- a/include/uapi/linux/vfio.h
>>> +++ b/include/uapi/linux/vfio.h
>>> @@ -697,11 +697,55 @@ struct vfio_irq_info {
>>>  #define VFIO_IRQ_INFO_MASKABLE               (1 << 1)
>>>  #define VFIO_IRQ_INFO_AUTOMASKED     (1 << 2)
>>>  #define VFIO_IRQ_INFO_NORESIZE               (1 << 3)
>>> +#define VFIO_IRQ_INFO_FLAG_CAPS              (1 << 4) /* Info supports caps */
>>>       __u32   index;          /* IRQ index */
>>>       __u32   count;          /* Number of IRQs within this index */
>>> +     __u32   cap_offset;     /* Offset within info struct of first cap */
>>>  };
>>>  #define VFIO_DEVICE_GET_IRQ_INFO     _IO(VFIO_TYPE, VFIO_BASE + 9)
>>>
>>> +/*
>>> + * The irq type capability allows IRQs unique to a specific device or
>>> + * class of devices to be exposed.
>>> + *
>>> + * The structures below define version 1 of this capability.
>>> + */
>>> +#define VFIO_IRQ_INFO_CAP_TYPE               3
>>> +
>>> +struct vfio_irq_info_cap_type {
>>> +     struct vfio_info_cap_header header;
>>> +     __u32 type;     /* global per bus driver */
>>> +     __u32 subtype;  /* type specific */
>>> +};
>>> +
>>> +/*
>>> + * List of IRQ types, global per bus driver.
>>> + * If you introduce a new type, please add it here.
>>> + */
>>> +
>>> +/* Non PCI devices having MSI(s) support */
>>> +#define VFIO_IRQ_TYPE_MSI            (1)
>>> +
>>> +/*
>>> + * The msi capability allows the user to use the msi msg to
>>> + * configure the iova for the msi configuration.
>>> + * The structures below define version 1 of this capability.
>>> + */
>>> +#define VFIO_IRQ_INFO_CAP_MSI_DESCS  4
>>> +
>>> +struct vfio_irq_msi_msg {
>>> +     __u32   addr_lo;
>>> +     __u32   addr_hi;
>>> +     __u32   data;
>>> +};
>>> +
>>> +struct vfio_irq_info_cap_msi {
>>> +     struct vfio_info_cap_header header;
>>> +     __u32   nr_msgs;
>>> +     __u32   reserved;
>>> +     struct vfio_irq_msi_msg msgs[];
>>> +};
>>> +
>>>  /**
>>>   * VFIO_DEVICE_SET_IRQS - _IOW(VFIO_TYPE, VFIO_BASE + 10, struct vfio_irq_set)
>>>   *
>>>
>>
> 

