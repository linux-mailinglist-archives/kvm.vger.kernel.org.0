Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3535C70413D
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 01:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245196AbjEOXBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 19:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245075AbjEOXBI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 19:01:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F30DC59
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 16:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684191618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6kMUoqXP3L5QE8C9BpwBjLxKbBZNhuRqAJUpr0glKx4=;
        b=G3qHj2LM7asujda8pzSMwi+Kk5s06Cw5+ZJGmQ6yT7lokzmTrPSJlOi+s+3szxW27DNNfh
        BAidFDAp7XHS9zC49DQn77+jVNbS/gxfbNZp54W9EWXmrEMWCS/4S7N+JD3BivH2lreY+k
        LJ4dTiPkUn8NoX34zCzXuLveE8Ghalo=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-eyvw0WibMuKweWG4Ng3xUA-1; Mon, 15 May 2023 19:00:17 -0400
X-MC-Unique: eyvw0WibMuKweWG4Ng3xUA-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3314c25ae45so191840335ab.0
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 16:00:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684191616; x=1686783616;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6kMUoqXP3L5QE8C9BpwBjLxKbBZNhuRqAJUpr0glKx4=;
        b=Lh4j1WIlODxLd9kXawr6EqI7A36fAKEf37okznRVD1QkI1ykpeGUGSMp5t6GAejQim
         18agS25SsawLRgt3rR/kbMwRi3DFPZGX0Qp/ndtXNOeWvep89VT9nYLlNOHnOYWiIPAC
         Gc+t55KgQV+g7vgX9jpXTI2CP73d7dbWJECXUbVMYdAOIIVXXP/EweUxaQpHoqaIP1pM
         Cw8ljWtjlRFdfBl7NeR+pAA4wW8MNBFp8YXvLtcfqJDhrLApYwW6ZU2pTY0rNyVWr/av
         9STcoFGBxeG4dKB7HQwkIlvTfg3SbewbNil9bplTCyE+umJXIp9LL0j6FDRwIXHEKVma
         ar8A==
X-Gm-Message-State: AC+VfDxtMgS/OrUD3Z8hAWHYlgfkRGJikheprkXV5EXO/uhSCfPUqUww
        cW2ypFq1oZHzXzi3ZzXd9Zhjmk+hJkk/RqZQp4WR2B856oKHgc2vd+rFaBdyD8XldlMxu097GPV
        JgR36hmWew47F
X-Received: by 2002:a92:d98a:0:b0:332:8376:5133 with SMTP id r10-20020a92d98a000000b0033283765133mr24134210iln.32.1684191616168;
        Mon, 15 May 2023 16:00:16 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5UdSJAqgHHtZlZU2BmfXGSrSaVw4zHIl9hp4PBONnBEpJVkK4WZAWCFXGgkugcQZ4raoZlbA==
X-Received: by 2002:a92:d98a:0:b0:332:8376:5133 with SMTP id r10-20020a92d98a000000b0033283765133mr24134191iln.32.1684191615865;
        Mon, 15 May 2023 16:00:15 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id y6-20020a92c746000000b003354fc8a77dsm5250467ilp.70.2023.05.15.16.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 16:00:15 -0700 (PDT)
Date:   Mon, 15 May 2023 17:00:13 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Grzegorz Jaszczyk <jaz@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, dmy@semihalf.com, tn@semihalf.com,
        dbehr@google.com, dbehr@chromium.org, upstream@semihalf.com,
        dtor@google.com, jgg@ziepe.ca, kevin.tian@intel.com,
        cohuck@redhat.com, abhsahu@nvidia.com, yishaih@nvidia.com,
        yi.l.liu@intel.com, kvm@vger.kernel.org, libvir-list@redhat.com
Subject: Re: [PATCH v3] vfio/pci: Propagate ACPI notifications to user-space
 via eventfd
Message-ID: <20230515170013.639f32b6.alex.williamson@redhat.com>
In-Reply-To: <20230502132700.654528-1-jaszczyk@google.com>
References: <20230502132700.654528-1-jaszczyk@google.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  2 May 2023 13:27:00 +0000
Grzegorz Jaszczyk <jaz@semihalf.com> wrote:

> From: Grzegorz Jaszczyk <jaz@semihalf.com>
> 
> To allow pass-through devices receiving ACPI notifications, permit to
> register ACPI notify handler (via introduced new ioctl) for a given

This shouldn't require a new ioctl, it should fit within the
abstraction of the VFIO_DEVICE_SET_IRQS ioctl which already supports
virtual IRQs for things like error notification and device release
requests.  Support for this IRQ index on a given device should also be
discoverable via VFIO_DEVICE_GET_IRQ_INFO that way.

> device. The handler role is to receive and propagate such ACPI
> notifications to the user-space through the user provided eventfd. This
> allows VMM to receive and propagate them further to the VM, where the
> actual driver for pass-through device resides and can react to device
> specific notifications accordingly.
> 
> The eventfd usage ensures VMM and device isolation: it allows to use a
> dedicated channel associated with the device for such events, such that
> the VMM has direct access.
> 
> Since the eventfd counter is used as ACPI notification value
> placeholder, the eventfd signaling needs to be serialized in order to
> not end up with notification values being coalesced. Therefore ACPI
> notification values are buffered and signalized one by one, when the
> previous notification value has been consumed.

I don't see anything that prevents this queuing mechanism from creating
an arbitrarily large queue, don't we need to drop events at some point
to avoid introducing an exploit vector?  Aren't these notifications
often for things like "device check", where queuing duplicate entries
doesn't make sense and perhaps the most recent notification is the only
relevant value otherwise?  If we only need to avoid calling
eventfd_signal() while a non-zero value is pending, couldn't we call
eventfd_ctx_do_read() ourselves to clear the old value rather than
queuing?  Thanks,

Alex
 
> Signed-off-by: Grzegorz Jaszczyk <jaz@semihalf.com>
> ---
> Changelog v2..v3:
> - Fix compilation warnings when building with "W=1"
> Changelog v1..v2:
> - The v2 implementation is actually completely different then v1:
>   instead of using acpi netlink events for propagating ACPI
>   notifications to the user space take advantage of eventfd, which can
>   provide better VMM and device isolation: it allows to use a dedicated
>   channel associated with the device for such events, such that the VMM
>   has direct access.
> - Using eventfd counter as notification value placeholder was suggested
>   in v1 and requires additional serialization logic introduced in v2.
> - Since the vfio-pci supports non-ACPI platforms address !CONFIG_ACPI
>   case.
> - v1 discussion: https://patchwork.kernel.org/project/kvm/patch/20230307220553.631069-1-jaz@semihalf.com/
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 214 +++++++++++++++++++++++++++++++
>  include/linux/vfio_pci_core.h    |  11 ++
>  include/uapi/linux/vfio.h        |  15 +++
>  3 files changed, 240 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index a5ab416cf476..2d6101e89fde 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -10,6 +10,7 @@
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
> +#include <linux/acpi.h>
>  #include <linux/aperture.h>
>  #include <linux/device.h>
>  #include <linux/eventfd.h>
> @@ -679,6 +680,70 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_disable);
>  
> +struct notification_queue {
> +	int notification_val;
> +	struct list_head notify_val_next;
> +};
> +
> +#if IS_ENABLED(CONFIG_ACPI)
> +static void vfio_pci_core_acpi_notify(acpi_handle handle, u32 event, void *data)
> +{
> +	struct vfio_pci_core_device *vdev = (struct vfio_pci_core_device *)data;
> +	struct vfio_acpi_notification *acpi_notify = vdev->acpi_notification;
> +	struct notification_queue *entry;
> +
> +	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
> +	if (!entry)
> +		return;
> +
> +	entry->notification_val = event;
> +	INIT_LIST_HEAD(&entry->notify_val_next);
> +
> +	mutex_lock(&acpi_notify->notification_list_lock);
> +	list_add_tail(&entry->notify_val_next, &acpi_notify->notification_list);
> +	mutex_unlock(&acpi_notify->notification_list_lock);
> +
> +	schedule_work(&acpi_notify->acpi_notification_work);
> +}
> +
> +static void vfio_pci_acpi_notify_close_device(struct vfio_pci_core_device *vdev)
> +{
> +	struct vfio_acpi_notification *acpi_notify = vdev->acpi_notification;
> +	struct pci_dev *pdev = vdev->pdev;
> +	struct acpi_device *adev = ACPI_COMPANION(&pdev->dev);
> +	struct notification_queue *entry, *entry_tmp;
> +	u64 cnt;
> +
> +	if (!acpi_notify || !acpi_notify->acpi_notify_trigger)
> +		return;
> +
> +	acpi_remove_notify_handler(adev->handle, ACPI_DEVICE_NOTIFY,
> +				   vfio_pci_core_acpi_notify);
> +
> +	eventfd_ctx_remove_wait_queue(acpi_notify->acpi_notify_trigger,
> +				      &acpi_notify->wait, &cnt);
> +
> +	flush_work(&acpi_notify->acpi_notification_work);
> +
> +	mutex_lock(&acpi_notify->notification_list_lock);
> +	list_for_each_entry_safe(entry, entry_tmp,
> +				 &acpi_notify->notification_list,
> +				 notify_val_next) {
> +		list_del(&entry->notify_val_next);
> +		kfree(entry);
> +	}
> +	mutex_unlock(&acpi_notify->notification_list_lock);
> +
> +	eventfd_ctx_put(acpi_notify->acpi_notify_trigger);
> +
> +	kfree(acpi_notify);
> +
> +	vdev->acpi_notification = NULL;
> +}
> +#else
> +static void vfio_pci_acpi_notify_close_device(struct vfio_pci_core_device *vdev) {}
> +#endif /* CONFIG_ACPI */
> +
>  void vfio_pci_core_close_device(struct vfio_device *core_vdev)
>  {
>  	struct vfio_pci_core_device *vdev =
> @@ -705,6 +770,8 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
>  		vdev->req_trigger = NULL;
>  	}
>  	mutex_unlock(&vdev->igate);
> +
> +	vfio_pci_acpi_notify_close_device(vdev);
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_close_device);
>  
> @@ -882,6 +949,151 @@ int vfio_pci_core_register_dev_region(struct vfio_pci_core_device *vdev,
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_register_dev_region);
>  
> +#if IS_ENABLED(CONFIG_ACPI)
> +static int vfio_pci_eventfd_wakeup(wait_queue_entry_t *wait, unsigned int mode,
> +				   int sync, void *key)
> +{
> +	struct vfio_acpi_notification *acpi_notify =
> +		container_of(wait, struct vfio_acpi_notification, wait);
> +	__poll_t flags = key_to_poll(key);
> +
> +	/*
> +	 * eventfd_read signalize EPOLLOUT at the end of its function - this
> +	 * means previous eventfd with its notification value was consumed so
> +	 * the next notification can be signalized now if pending - schedule
> +	 * proper work.
> +	 */
> +	if (flags & EPOLLOUT) {
> +		mutex_unlock(&acpi_notify->notification_lock);
> +		schedule_work(&acpi_notify->acpi_notification_work);
> +	}
> +
> +	return 0;
> +}
> +
> +static void vfio_pci_ptable_queue_proc(struct file *file,
> +				       wait_queue_head_t *wqh, poll_table *pt)
> +{
> +	struct vfio_acpi_notification *acpi_notify =
> +		container_of(pt, struct vfio_acpi_notification, pt);
> +
> +	add_wait_queue(wqh, &acpi_notify->wait);
> +}
> +
> +static void acpi_notification_work_fn(struct work_struct *work)
> +{
> +	struct vfio_acpi_notification *acpi_notify;
> +	struct notification_queue *entry;
> +
> +	acpi_notify = container_of(work, struct vfio_acpi_notification,
> +				   acpi_notification_work);
> +
> +	mutex_lock(&acpi_notify->notification_list_lock);
> +	if (list_empty(&acpi_notify->notification_list) || !acpi_notify->acpi_notify_trigger)
> +		goto out;
> +
> +	/*
> +	 * If the previous eventfd was not yet consumed by user-space lets hold
> +	 * on and exit. The notification function will be rescheduled when
> +	 * signaling eventfd will be possible (when the EPOLLOUT will be
> +	 * signalized and unlocks notify_events).
> +	 */
> +	if (!mutex_trylock(&acpi_notify->notification_lock))
> +		goto out;
> +
> +	entry = list_first_entry(&acpi_notify->notification_list,
> +				 struct notification_queue, notify_val_next);
> +
> +	list_del(&entry->notify_val_next);
> +	mutex_unlock(&acpi_notify->notification_list_lock);
> +
> +	eventfd_signal(acpi_notify->acpi_notify_trigger, entry->notification_val);
> +
> +	kfree(entry);
> +
> +	return;
> +out:
> +	mutex_unlock(&acpi_notify->notification_list_lock);
> +}
> +
> +static int vfio_pci_ioctl_acpi_notify_eventfd(struct vfio_pci_core_device *vdev, struct
> +				       vfio_irq_info __user *arg)
> +{
> +	struct file *acpi_notify_trigger_file;
> +	struct vfio_acpi_notification *acpi_notify;
> +	struct pci_dev *pdev = vdev->pdev;
> +	struct acpi_device *adev = ACPI_COMPANION(&pdev->dev);
> +	struct vfio_acpi_notify_eventfd entry;
> +	struct eventfd_ctx *efdctx;
> +	acpi_status status;
> +
> +	if (!adev)
> +		return -ENODEV;
> +
> +	if (copy_from_user(&entry, arg, sizeof(entry)))
> +		return -EFAULT;
> +
> +	if (entry.notify_eventfd < 0)
> +		return -EINVAL;
> +
> +	efdctx = eventfd_ctx_fdget(entry.notify_eventfd);
> +	if (IS_ERR(efdctx))
> +		return PTR_ERR(efdctx);
> +
> +	vdev->acpi_notification = kzalloc(sizeof(*acpi_notify), GFP_KERNEL);
> +	if (!vdev->acpi_notification)
> +		return -ENOMEM;
> +
> +	acpi_notify = vdev->acpi_notification;
> +
> +	INIT_WORK(&acpi_notify->acpi_notification_work, acpi_notification_work_fn);
> +	INIT_LIST_HEAD(&acpi_notify->notification_list);
> +
> +	acpi_notify->acpi_notify_trigger = efdctx;
> +
> +	mutex_init(&acpi_notify->notification_lock);
> +
> +	/*
> +	 * Install custom wake-up handler to be notified whenever underlying
> +	 * eventfd is consumed by the user-space.
> +	 */
> +	init_waitqueue_func_entry(&acpi_notify->wait, vfio_pci_eventfd_wakeup);
> +	init_poll_funcptr(&acpi_notify->pt, vfio_pci_ptable_queue_proc);
> +
> +	acpi_notify_trigger_file = eventfd_fget(entry.notify_eventfd);
> +	vfs_poll(acpi_notify_trigger_file, &acpi_notify->pt);
> +
> +	status = acpi_install_notify_handler(adev->handle, ACPI_DEVICE_NOTIFY,
> +					vfio_pci_core_acpi_notify, (void *)vdev);
> +
> +	if (ACPI_FAILURE(status)) {
> +		u64 cnt;
> +
> +		pci_err(pdev, "Failed to install notify handler: %s",
> +			acpi_format_exception(status));
> +
> +		eventfd_ctx_remove_wait_queue(acpi_notify->acpi_notify_trigger,
> +					      &acpi_notify->wait, &cnt);
> +
> +		flush_work(&acpi_notify->acpi_notification_work);
> +
> +		eventfd_ctx_put(acpi_notify->acpi_notify_trigger);
> +
> +		kfree(acpi_notify);
> +
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +#else
> +static int vfio_pci_ioctl_acpi_notify_eventfd(struct vfio_pci_core_device *vdev, struct
> +				       vfio_irq_info __user *arg)
> +{
> +	return -ENODEV;
> +}
> +#endif /* CONFIG_ACPI */
> +
>  static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
>  				   struct vfio_device_info __user *arg)
>  {
> @@ -1398,6 +1610,8 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>  		return vfio_pci_ioctl_reset(vdev, uarg);
>  	case VFIO_DEVICE_SET_IRQS:
>  		return vfio_pci_ioctl_set_irqs(vdev, uarg);
> +	case VFIO_ACPI_NOTIFY_EVENTFD:
> +		return vfio_pci_ioctl_acpi_notify_eventfd(vdev, uarg);
>  	default:
>  		return -ENOTTY;
>  	}
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 367fd79226a3..3711e8a1c6f0 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -49,6 +49,16 @@ struct vfio_pci_region {
>  	u32				flags;
>  };
>  
> +struct vfio_acpi_notification {
> +	struct eventfd_ctx	*acpi_notify_trigger;
> +	struct work_struct	acpi_notification_work;
> +	struct list_head	notification_list;
> +	struct mutex		notification_list_lock;
> +	struct mutex		notification_lock;
> +	poll_table		pt;
> +	wait_queue_entry_t	wait;
> +};
> +
>  struct vfio_pci_core_device {
>  	struct vfio_device	vdev;
>  	struct pci_dev		*pdev;
> @@ -96,6 +106,7 @@ struct vfio_pci_core_device {
>  	struct mutex		vma_lock;
>  	struct list_head	vma_list;
>  	struct rw_semaphore	memory_lock;
> +	struct vfio_acpi_notification	*acpi_notification;
>  };
>  
>  /* Will be exported for vfio pci drivers usage */
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 0552e8dcf0cb..d4b602d8f4b2 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1622,6 +1622,21 @@ struct vfio_iommu_spapr_tce_remove {
>  };
>  #define VFIO_IOMMU_SPAPR_TCE_REMOVE	_IO(VFIO_TYPE, VFIO_BASE + 20)
>  
> +/**
> + * VFIO_ACPI_NOTIFY_EVENTFD - _IOW(VFIO_TYPE, VFIO_BASE + 21, struct vfio_acpi_notify_eventfd)
> + *
> + * Register ACPI notify handler for a given device which will allow to receive
> + * and propagate ACPI notifications to the user-space through the user provided
> + * eventfd.
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +struct vfio_acpi_notify_eventfd {
> +	__s32 notify_eventfd;
> +	__u32 reserved;
> +};
> +#define VFIO_ACPI_NOTIFY_EVENTFD	_IO(VFIO_TYPE, VFIO_BASE + 21)
> +
>  /* ***************************************************************** */
>  
>  #endif /* _UAPIVFIO_H */

