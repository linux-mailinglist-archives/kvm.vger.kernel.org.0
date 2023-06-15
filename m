Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5268E7322E2
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 00:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239068AbjFOWy5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 18:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239619AbjFOWyz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 18:54:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DC7270E
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 15:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686869646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UjIxrezudtYoDdL6VbqFOqNMSYsjVlPNoONx5NzynO8=;
        b=IUPtN0S3icSE7oOciXxOlnLOLgzRrqcavXvbn1PoCQ4H4U1FrtdQWSYlK9s15vzozhSxHl
        tGCmfcnkLbgIRc54b2Fz+Kp2uDb/frSU989V1XwaCiRe5BfogdrizVyHn/GbU+cXbOjt0Q
        JN/gEE8jnh4UIfGDZZGrEd5LBO8YVE8=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-220-RtCPj1rmPxKyMsre0l8u2w-1; Thu, 15 Jun 2023 18:54:05 -0400
X-MC-Unique: RtCPj1rmPxKyMsre0l8u2w-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3406b5ef400so811765ab.1
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 15:54:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686869644; x=1689461644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UjIxrezudtYoDdL6VbqFOqNMSYsjVlPNoONx5NzynO8=;
        b=lXlD894KaemZbzHK3ZMBPce7dRopu4SRkOYWJ8j1hoDh1kIsLrOLNgXflVP1dmeIb8
         onQk1vE/qaU7daJMJUj7AMM37yCIanw62V1vDxaDHgnZYFnFslLTbq7Gd+ItHmjr9WqM
         a/IJa/hFkr9pZQXHjcxhUp9DFrcIbzkrgS2c4Ips8ElvUiGxP+qoFoC79NHefreJ0oMQ
         /CETL4jiqGoPyT4IBOG4/H48wI0HYHPcDd6V1GmOGKFCXP0KsA7eNupzd0qvmZ/XFbpC
         nlUIQLsmdbOPhBNE74VxqyPjzPQEnwxwkEZ2PdAMRP5loOgQrbIWG2yTnSc0EaxcyF2t
         rSgA==
X-Gm-Message-State: AC+VfDya2Fv1S/EUwM33yjyIBT0pETHgoTXufSS5B/PGrsQ026Y5m8Bx
        nvArsGMXSpn0iB0rz8P68iFWKnjivyBkfkvQ5x4LCjBGmrSn+avYlR4mcbqiky7dUhfg6DBF0xF
        Xlypmveig+vw5S5ITUhg9
X-Received: by 2002:a92:cc03:0:b0:341:da64:d832 with SMTP id s3-20020a92cc03000000b00341da64d832mr842461ilp.9.1686869644158;
        Thu, 15 Jun 2023 15:54:04 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7mO2mMmO0hEJ2GyXmS7ICxy15lx3Wr1Vqr2vq1xVEKelnVA/M3Ish4NZ3m5qMxPhqYJEhJcg==
X-Received: by 2002:a92:cc03:0:b0:341:da64:d832 with SMTP id s3-20020a92cc03000000b00341da64d832mr842449ilp.9.1686869643763;
        Thu, 15 Jun 2023 15:54:03 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id dj13-20020a0566384b8d00b0040fadba66b0sm5861490jab.58.2023.06.15.15.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 15:54:02 -0700 (PDT)
Date:   Thu, 15 Jun 2023 16:54:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Grzegorz Jaszczyk <jaz@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, dmy@semihalf.com, tn@semihalf.com,
        dbehr@google.com, dbehr@chromium.org, upstream@semihalf.com,
        dtor@google.com, jgg@ziepe.ca, kevin.tian@intel.com,
        cohuck@redhat.com, abhsahu@nvidia.com, yishaih@nvidia.com,
        yi.l.liu@intel.com, kvm@vger.kernel.org, libvir-list@redhat.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com,
        mjrosato@linux.ibm.com
Subject: Re: [PATCH v5] vfio/pci: Propagate ACPI notifications to user-space
 via eventfd
Message-ID: <20230615165401.5d17fd9a.alex.williamson@redhat.com>
In-Reply-To: <20230609133950.2197552-1-jaz@semihalf.com>
References: <20230609133950.2197552-1-jaz@semihalf.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  9 Jun 2023 13:39:50 +0000
Grzegorz Jaszczyk <jaz@semihalf.com> wrote:

> To allow pass-through devices receiving ACPI notifications, permit to
> register ACPI notify handler (via VFIO_DEVICE_SET_IRQS) for a given
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
> 
> Signed-off-by: Grzegorz Jaszczyk <jaz@semihalf.com>
> ---
> Changelog v4..v5
> Address Alex Williamson's feedback:
> - s/vfio_acpi_notify.{c,o}/acpi_notify.{c,o}
> - Do not put acpi_notify to its own module but fold it into main
>   vfio.ko. Additionally select it from VFIO_PCI_CORE instead of VFIO_PCI.
> - Cleanup acpi notify under igate mutex (in vfio_pci_core_close_device).
> - Add extra check for ACPI companion in vfio_pci_get_irq_count and
>   extend vfio_pci_ioctl_get_irq_info.
> - Drop acpi.h include - linux/vfio_acpi_notify.h includes it already.
> - Send device check notification value for DATA_NONE and non-zero count
>   and for DATA_BOOL and non-zero count  (as for loopback testing).
> - Drop some redundant !acpi_notify->acpi_notify_trigger checks.
> - Move some common code to new helper functions:
>   1) acpi_notification_dequeue
>   2) vfio_acpi_notify_cleanup and rename previous
>      vfio_acpi_notify_cleanup into vfio_remove_acpi_notify which uses it
> - Add rate limited logging for dropped notifications.
> - Move vdev->acpi_notification pointer cleanup to the
>   vfio_acpi_notify_cleanup function this also fixes two bigger issues
>   caught by Alex.
> - Allow the eventfd to be swapped.
> - s/GFP_KERNEL/GFP_KERNEL_ACCOUNT.
> - s/VFIO_PCI_ACPI_NTFY_IRQ_INDEX/VFIO_PCI_ACPI_IRQ_INDEX.
> - Add header protection for multiple includes.
> - v4: https://patchwork.kernel.org/project/kvm/patch/20230522165811.123417-1-jaz@semihalf.com/
> 
> Changelog v3..v4
> Address Alex Williamson feedback:
> - Instead of introducing new ioctl used for eventfd registration, take
>   advantage of VFIO_DEVICE_SET_IRQS which already supports virtual IRQs
>   for things like error notification and device release requests.
> - Introduced mechanism preventing creation of large queues.
> Other:
> - Move the implementation into the newly introduced VFIO_ACPI_NOTIFY
>   helper module. It is actually not bound to VFIO_PCI but VFIO_PCI
>   enables it whenever ACPI support is enabled. This change is introduced
>   since ACPI notifications are not limited to PCI devices, making it PCI
>   independent will allow to re-use it also for other VFIO_* like
>   supports: e.g. VFIO_PLATFORM in the future if needed. Moving it out of
>   drivers/vfio/pci/ was also suggested offline.
> - s/notify_val_next/node
> - v3: https://patchwork.kernel.org/project/kvm/patch/20230502132700.654528-1-jaszczyk@google.com/
> 
> Changelog v2..v3:
> - Fix compilation warnings when building with "W=1"
> 
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
>  drivers/vfio/Kconfig              |   5 +
>  drivers/vfio/Makefile             |   1 +
>  drivers/vfio/acpi_notify.c        | 249 ++++++++++++++++++++++++++++++
>  drivers/vfio/pci/Kconfig          |   1 +
>  drivers/vfio/pci/vfio_pci_core.c  |  13 ++
>  drivers/vfio/pci/vfio_pci_intrs.c |  85 ++++++++++
>  include/linux/vfio_acpi_notify.h  |  45 ++++++
>  include/linux/vfio_pci_core.h     |   1 +
>  include/uapi/linux/vfio.h         |   1 +
>  9 files changed, 401 insertions(+)
>  create mode 100644 drivers/vfio/acpi_notify.c
>  create mode 100644 include/linux/vfio_acpi_notify.h
> 
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index 89e06c981e43..cd9df43a4eb4 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -12,6 +12,11 @@ menuconfig VFIO
>  	  If you don't know what to do here, say N.
>  
>  if VFIO
> +config VFIO_ACPI_NOTIFY
> +	bool
> +	depends on ACPI
> +	default n
> +
>  config VFIO_CONTAINER
>  	bool "Support for the VFIO container /dev/vfio/vfio"
>  	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index 70e7dcb302ef..003c2b041785 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -7,6 +7,7 @@ vfio-y += vfio_main.o \
>  vfio-$(CONFIG_IOMMUFD) += iommufd.o
>  vfio-$(CONFIG_VFIO_CONTAINER) += container.o
>  vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
> +vfio-$(CONFIG_VFIO_ACPI_NOTIFY) += acpi_notify.o
>  
>  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
> diff --git a/drivers/vfio/acpi_notify.c b/drivers/vfio/acpi_notify.c
> new file mode 100644
> index 000000000000..8d3f063502fe
> --- /dev/null
> +++ b/drivers/vfio/acpi_notify.c
> @@ -0,0 +1,249 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * VFIO ACPI notification propagation
> + *
> + * Author: Grzegorz Jaszczyk <jaz@semihalf.com>
> + */
> +#include <linux/vfio_acpi_notify.h>
> +
> +#define NOTIFICATION_QUEUE_SIZE 20
> +
> +struct notification_queue {
> +	int notification_val;
> +	struct list_head node;
> +};
> +
> +static int vfio_eventfd_wakeup(wait_queue_entry_t *wait, unsigned int mode,
> +				   int sync, void *key)
> +{
> +	struct vfio_acpi_notification *acpi_notify =
> +		container_of(wait, struct vfio_acpi_notification, wait);
> +	__poll_t flags = key_to_poll(key);

Lockdep annotation would be useful throughout:

	lockdep_assert_held(&acpi_notify->notification_lock);

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

Shouldn't we also handle EPOLLHUP here?  For example, isn't there a
deadlock if the user configures a notification eventfd, a notification
fires, the user closes the eventfd without reading it, and then tries
to swap in a different eventfd ctx?

Having this mutex held indefinitely waiting on the user to poll the
eventfd looks problematic.

> +
> +	return 0;
> +}
> +
> +static void vfio_ptable_queue_proc(struct file *file,
> +				       wait_queue_head_t *wqh, poll_table *pt)
> +{
> +	struct vfio_acpi_notification *acpi_notify =
> +		container_of(pt, struct vfio_acpi_notification, pt);
> +
> +	add_wait_queue(wqh, &acpi_notify->wait);
> +}
> +
> +static struct notification_queue *
> +acpi_notification_dequeue(struct vfio_acpi_notification *acpi_notify)
> +{
> +	struct notification_queue *oldest_entry;
> +

	lockdep_assert_held(&&acpi_notify->notification_list_lock);
	lockdep_assert_held(&&acpi_notify->notification_lock);

> +	oldest_entry = list_first_entry(&acpi_notify->notification_list,
> +					struct notification_queue,
> +					node);
> +	list_del(&oldest_entry->node);
> +	acpi_notify->notification_queue_count--;
> +
> +	return oldest_entry;
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
> +	if (list_empty(&acpi_notify->notification_list))
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
> +	entry = acpi_notification_dequeue(acpi_notify);
> +
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
> +static void
> +vfio_acpi_notify_cleanup(struct vfio_acpi_notification **acpi_notify_ptr,
> +			 struct acpi_device *adev)
> +{
> +	struct vfio_acpi_notification *acpi_notify = *acpi_notify_ptr;
> +	struct notification_queue *entry, *entry_tmp;
> +	u64 cnt;
> +
> +	eventfd_ctx_remove_wait_queue(acpi_notify->acpi_notify_trigger,
> +				      &acpi_notify->wait, &cnt);
> +
> +	flush_work(&acpi_notify->acpi_notification_work);

At this point we have no idea the state of notification_lock, we'd need
something like:

	if (mutex_trylock(&acpi_notify->notification_lock))
		mutex_unlock(&acpi_notify->notification_lock);

But that is super sketchy.

> +
> +	mutex_lock(&acpi_notify->notification_list_lock);
> +	list_for_each_entry_safe(entry, entry_tmp,
> +				 &acpi_notify->notification_list,
> +				 node) {
> +		list_del(&entry->node);
> +		kfree(entry);
> +	}
> +	mutex_unlock(&acpi_notify->notification_list_lock);
> +
> +	eventfd_ctx_put(acpi_notify->acpi_notify_trigger);
> +
> +	kfree(acpi_notify);
> +
> +	*acpi_notify_ptr = NULL;
> +}
> +
> +void vfio_acpi_notify(acpi_handle handle, u32 event, void *data)
> +{
> +	struct vfio_acpi_notification *acpi_notify = (struct vfio_acpi_notification *)data;
> +	struct notification_queue *entry;
> +
> +	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
> +	if (!entry)
> +		return;
> +
> +	entry->notification_val = event;
> +	INIT_LIST_HEAD(&entry->node);
> +
> +	mutex_lock(&acpi_notify->notification_list_lock);
> +	if (acpi_notify->notification_queue_count > NOTIFICATION_QUEUE_SIZE) {
> +		struct notification_queue *oldest_entry =
> +			acpi_notification_dequeue(acpi_notify);
> +
> +		if (printk_ratelimit())
> +			acpi_handle_warn(handle,
> +					 "dropping notification value %d\n",
> +					 oldest_entry->notification_val);
> +
> +		kfree(oldest_entry);
> +	}
> +	list_add_tail(&entry->node, &acpi_notify->notification_list);
> +	acpi_notify->notification_queue_count++;
> +	mutex_unlock(&acpi_notify->notification_list_lock);
> +
> +	schedule_work(&acpi_notify->acpi_notification_work);
> +}
> +EXPORT_SYMBOL_GPL(vfio_acpi_notify);
> +
> +void vfio_remove_acpi_notify(struct vfio_acpi_notification **acpi_notify_ptr,
> +			     struct acpi_device *adev)
> +{
> +	struct vfio_acpi_notification *acpi_notify = *acpi_notify_ptr;
> +
> +	if (!acpi_notify)
> +		return;
> +
> +	acpi_remove_notify_handler(adev->handle, ACPI_DEVICE_NOTIFY,
> +				   vfio_acpi_notify);
> +
> +	vfio_acpi_notify_cleanup(acpi_notify_ptr, adev);
> +}
> +EXPORT_SYMBOL_GPL(vfio_remove_acpi_notify);
> +
> +int vfio_register_acpi_notify_handler(struct vfio_acpi_notification **acpi_notify_ptr,
> +					  struct acpi_device *adev, int32_t fd)
> +{
> +	struct vfio_acpi_notification *acpi_notify = *acpi_notify_ptr;
> +	struct file *acpi_notify_trigger_file;
> +	struct eventfd_ctx *efdctx;
> +	acpi_status status;
> +
> +	if (fd < -1)
> +		return -EINVAL;
> +	else if (fd == -1) {
> +		vfio_remove_acpi_notify(acpi_notify_ptr, adev);
> +		return 0;
> +	}
> +
> +	efdctx = eventfd_ctx_fdget(fd);
> +	if (IS_ERR(efdctx))
> +		return PTR_ERR(efdctx);
> +
> +	/* Allow eventfd to be swapped */
> +	if (acpi_notify) {
> +		u64 cnt;
> +
> +		acpi_notify_trigger_file = eventfd_fget(fd);

Where's the fput() for any of these eventfd_fget() calls?

> +
> +		mutex_lock(&acpi_notify->notification_lock);

A pending signal deadlocks here.

> +		eventfd_ctx_remove_wait_queue(acpi_notify->acpi_notify_trigger,
> +					      &acpi_notify->wait, &cnt);
> +		eventfd_ctx_put(acpi_notify->acpi_notify_trigger);
> +		acpi_notify->acpi_notify_trigger = efdctx;
> +		vfs_poll(acpi_notify_trigger_file, &acpi_notify->pt);
> +		mutex_unlock(&acpi_notify->notification_lock);
> +
> +		/*
> +		 * The ACPI notifications could arrive and be queued during
> +		 * eventfd swap, retrigger the worker after notification
> +		 * replication unlocking.
> +		 */
> +		schedule_work(&acpi_notify->acpi_notification_work);
> +
> +		return 0;
> +	}
> +
> +	acpi_notify = kzalloc(sizeof(*acpi_notify), GFP_KERNEL_ACCOUNT);
> +	if (!acpi_notify)
> +		return -ENOMEM;
> +
> +	*acpi_notify_ptr = acpi_notify;
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
> +	init_waitqueue_func_entry(&acpi_notify->wait, vfio_eventfd_wakeup);
> +	init_poll_funcptr(&acpi_notify->pt, vfio_ptable_queue_proc);
> +
> +	acpi_notify_trigger_file = eventfd_fget(fd);
> +	vfs_poll(acpi_notify_trigger_file, &acpi_notify->pt);
> +
> +	status = acpi_install_notify_handler(adev->handle, ACPI_DEVICE_NOTIFY,
> +					vfio_acpi_notify, (void *)acpi_notify);
> +	if (ACPI_FAILURE(status)) {
> +		dev_err(&adev->dev, "Failed to install notify handler: %s",
> +			acpi_format_exception(status));
> +
> +		vfio_acpi_notify_cleanup(acpi_notify_ptr, adev);
> +
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(vfio_register_acpi_notify_handler);
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index f9d0c908e738..f03ca773dfd9 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -4,6 +4,7 @@ config VFIO_PCI_CORE
>  	tristate
>  	select VFIO_VIRQFD
>  	select IRQ_BYPASS_MANAGER
> +	select VFIO_ACPI_NOTIFY if ACPI
>  
>  config VFIO_PCI_MMAP
>  	def_bool y if !S390
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index a5ab416cf476..1cc4a9c05403 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -27,6 +27,7 @@
>  #include <linux/vgaarb.h>
>  #include <linux/nospec.h>
>  #include <linux/sched/mm.h>
> +#include <linux/vfio_acpi_notify.h>
>  #if IS_ENABLED(CONFIG_EEH)
>  #include <asm/eeh.h>
>  #endif
> @@ -683,6 +684,7 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
>  {
>  	struct vfio_pci_core_device *vdev =
>  		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +	struct acpi_device *adev = ACPI_COMPANION(&vdev->pdev->dev);
>  
>  	if (vdev->sriov_pf_core_dev) {
>  		mutex_lock(&vdev->sriov_pf_core_dev->vf_token->lock);
> @@ -704,6 +706,8 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
>  		eventfd_ctx_put(vdev->req_trigger);
>  		vdev->req_trigger = NULL;
>  	}
> +	if (adev)
> +		vfio_remove_acpi_notify(&vdev->acpi_notification, adev);
>  	mutex_unlock(&vdev->igate);
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_close_device);
> @@ -725,6 +729,8 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_finish_enable);
>  
>  static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_type)
>  {
> +	struct acpi_device *adev = ACPI_COMPANION(&vdev->pdev->dev);
> +
>  	if (irq_type == VFIO_PCI_INTX_IRQ_INDEX) {
>  		u8 pin;
>  
> @@ -761,6 +767,8 @@ static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_typ
>  			return 1;
>  	} else if (irq_type == VFIO_PCI_REQ_IRQ_INDEX) {
>  		return 1;
> +	} else if (adev && irq_type == VFIO_PCI_ACPI_IRQ_INDEX) {
> +		return 1;
>  	}
>  
>  	return 0;
> @@ -1084,6 +1092,7 @@ static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
>  				       struct vfio_irq_info __user *arg)
>  {
>  	unsigned long minsz = offsetofend(struct vfio_irq_info, count);
> +	struct acpi_device *adev = ACPI_COMPANION(&vdev->pdev->dev);
>  	struct vfio_irq_info info;
>  
>  	if (copy_from_user(&info, arg, minsz))
> @@ -1096,6 +1105,10 @@ static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
>  	case VFIO_PCI_INTX_IRQ_INDEX ... VFIO_PCI_MSIX_IRQ_INDEX:
>  	case VFIO_PCI_REQ_IRQ_INDEX:
>  		break;
> +	case VFIO_PCI_ACPI_IRQ_INDEX:
> +		if (adev)
> +			break;
> +		return -EINVAL;
>  	case VFIO_PCI_ERR_IRQ_INDEX:
>  		if (pci_is_pcie(vdev->pdev))
>  			break;
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index bffb0741518b..410f517f8b2c 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -19,6 +19,7 @@
>  #include <linux/vfio.h>
>  #include <linux/wait.h>
>  #include <linux/slab.h>
> +#include <linux/vfio_acpi_notify.h>
>  
>  #include "vfio_pci_priv.h"
>  
> @@ -667,6 +668,76 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_core_device *vdev,
>  					       count, flags, data);
>  }
>  
> +static int
> +vfio_pci_set_acpi_ntfy_trigger(struct vfio_pci_core_device *vdev,
> +			       unsigned int index, unsigned int start,
> +			       unsigned int count, uint32_t flags, void *data)
> +{
> +	struct acpi_device *adev = ACPI_COMPANION(&vdev->pdev->dev);
> +	acpi_handle handle;
> +
> +	if (index != VFIO_PCI_ACPI_IRQ_INDEX || start != 0 || count > 1)
> +		return -EINVAL;
> +
> +	if (!adev)
> +		return -ENODEV;
> +
> +	if (!vdev->acpi_notification)
> +		return -EINVAL;
> +
> +#if IS_ENABLED(CONFIG_ACPI)
> +	handle = adev->handle;
> +#endif

Seems this is only needed because vfio_acpi_notify() takes an
acpi_handle, why didn't we use the solution from
vfio_remove_acpi_notify() and pass the whole adev?  vfio_acpi_notify()
could also return int and pass back an -ENOMEM since we've got the
return path.  Thanks,

Alex

> +
> +	/*
> +	 * Disable notifications: flags = (DATA_NONE|ACTION_TRIGGER), count = 0
> +	 * Enable loopback testing: (DATA_BOOL|ACTION_TRIGGER) or
> +	 *			    (DATA_NONE|ACTION_TRIGGER), count != 0
> +	 */
> +	if (flags & VFIO_IRQ_SET_DATA_NONE) {
> +		if (count)
> +			vfio_acpi_notify(handle, ACPI_NOTIFY_DEVICE_CHECK,
> +					 vdev->acpi_notification);
> +		else
> +			vfio_remove_acpi_notify(&vdev->acpi_notification, adev);
> +
> +		return 0;
> +	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
> +		uint8_t trigger;
> +
> +		if (!count)
> +			return -EINVAL;
> +
> +		trigger = *(uint8_t *)data;
> +		if (trigger)
> +			vfio_acpi_notify(handle, ACPI_NOTIFY_DEVICE_CHECK,
> +					 vdev->acpi_notification);
> +
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int
> +vfio_pci_set_acpi_ntfy_eventfd_trigger(struct vfio_pci_core_device *vdev,
> +				       unsigned int index, unsigned int start,
> +				       unsigned int count, uint32_t flags, void *data)
> +{
> +	struct acpi_device *adev = ACPI_COMPANION(&vdev->pdev->dev);
> +	int32_t fd;
> +
> +	if (index != VFIO_PCI_ACPI_IRQ_INDEX || start != 0 || count != 1)
> +		return -EINVAL;
> +
> +	if (!adev)
> +		return -ENODEV;
> +
> +	fd = *(int32_t *)data;
> +
> +	return vfio_register_acpi_notify_handler(&vdev->acpi_notification, adev, fd);
> +}
> +
>  int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
>  			    unsigned index, unsigned start, unsigned count,
>  			    void *data)
> @@ -716,6 +787,20 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
>  			break;
>  		}
>  		break;
> +	case VFIO_PCI_ACPI_IRQ_INDEX:
> +		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
> +		case VFIO_IRQ_SET_ACTION_TRIGGER:
> +			switch (flags & VFIO_IRQ_SET_DATA_TYPE_MASK) {
> +			case VFIO_IRQ_SET_DATA_BOOL:
> +			case VFIO_IRQ_SET_DATA_NONE:
> +				func = vfio_pci_set_acpi_ntfy_trigger;
> +				break;
> +			case VFIO_IRQ_SET_DATA_EVENTFD:
> +				func = vfio_pci_set_acpi_ntfy_eventfd_trigger;
> +				break;
> +			}
> +		}
> +		break;
>  	}
>  
>  	if (!func)
> diff --git a/include/linux/vfio_acpi_notify.h b/include/linux/vfio_acpi_notify.h
> new file mode 100644
> index 000000000000..4bf1d055a014
> --- /dev/null
> +++ b/include/linux/vfio_acpi_notify.h
> @@ -0,0 +1,45 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * VFIO ACPI notification replication
> + *
> + * Author: Grzegorz Jaszczyk <jaz@semihalf.com>
> + */
> +#include <linux/acpi.h>
> +#include <linux/eventfd.h>
> +#include <linux/poll.h>
> +
> +#ifndef VFIO_ACPI_NOTIFY_H
> +#define VFIO_ACPI_NOTIFY_H
> +
> +struct vfio_acpi_notification {
> +	struct eventfd_ctx	*acpi_notify_trigger;
> +	struct work_struct	acpi_notification_work;
> +	struct list_head	notification_list;
> +	struct mutex		notification_list_lock;
> +	struct mutex		notification_lock;
> +	int			notification_queue_count;
> +	poll_table		pt;
> +	wait_queue_entry_t	wait;
> +};
> +
> +#if IS_ENABLED(CONFIG_ACPI)
> +void vfio_acpi_notify(acpi_handle handle, u32 event, void *data);
> +int vfio_register_acpi_notify_handler(struct vfio_acpi_notification **acpi_notify,
> +				      struct acpi_device *adev, int32_t fd);
> +void vfio_remove_acpi_notify(struct vfio_acpi_notification **acpi_notify,
> +			     struct acpi_device *adev);
> +#else
> +static inline void vfio_acpi_notify(acpi_handle handle, u32 event, void *data) {}
> +static inline int
> +vfio_register_acpi_notify_handler(struct vfio_acpi_notification **acpi_notify,
> +				  struct acpi_device *adev, int32_t fd)
> +{
> +	return -ENODEV;
> +}
> +
> +static inline void
> +vfio_remove_acpi_notify(struct vfio_acpi_notification **acpi_notify,
> +			struct acpi_device *adev) {}
> +#endif /* CONFIG_ACPI */
> +
> +#endif /* VFIO_ACPI_NOTIFY_H */
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 367fd79226a3..a4491b3d8064 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -96,6 +96,7 @@ struct vfio_pci_core_device {
>  	struct mutex		vma_lock;
>  	struct list_head	vma_list;
>  	struct rw_semaphore	memory_lock;
> +	struct vfio_acpi_notification	*acpi_notification;
>  };
>  
>  /* Will be exported for vfio pci drivers usage */
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 0552e8dcf0cb..6b20ef3d202c 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -625,6 +625,7 @@ enum {
>  	VFIO_PCI_MSIX_IRQ_INDEX,
>  	VFIO_PCI_ERR_IRQ_INDEX,
>  	VFIO_PCI_REQ_IRQ_INDEX,
> +	VFIO_PCI_ACPI_IRQ_INDEX,
>  	VFIO_PCI_NUM_IRQS
>  };
>  

