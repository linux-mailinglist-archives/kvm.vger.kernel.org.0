Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1CC706BCC
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 16:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbjEQOyE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 10:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbjEQOxp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 10:53:45 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F341AA24F
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 07:53:15 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1ae3a5dfa42so7471615ad.0
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 07:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1684335195; x=1686927195;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tiCQSukBKsjmooO5+UEsVRyKdZyzNlEpcoD3yW9niMk=;
        b=F6VYt+z7qY44QsiuYgOxFx1yTxAs6s52pWKbBJgs6xpFp3KCwk9z87DetrfhRvA/iB
         2muX88xPdHSWOEcxFoFmujoRYmQeYk54VeOg5Em+YDVx9MZWTpDECma29FHmnDC77LKl
         68A/gO9zIKrFk0BbUEv0RojykZSWKwc8nil1NqVjloiBWg8KhNDcdWF+2xDFVG9gfyc4
         AOb2T/jo1EpHgxv26xy8eNtv3VYQ+7MRISgMWiQIVIlZDwRxzJLtmBW25y2nxNfHUyh7
         on21vhpFSnb04Tgv5V9mNm82J7lE360Ld7GmZTWExfjSCFy3iIBX6g3hI0GDC/sS4L/0
         +ImQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684335195; x=1686927195;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tiCQSukBKsjmooO5+UEsVRyKdZyzNlEpcoD3yW9niMk=;
        b=ZZ8t0MK/f1jIApmO1M4zlhruGZ1Kp4ODxiNLFiZ8jt4Ak86eJ5FouRRSaxP8atE9yo
         yxbsCpu11qMelUN6SH18Vu6xvCIycApc5XA/xIysdFdLELAirt57LJ3RHic0cuYh0QE1
         FORMzmGbC1eVoatmNfS+583Mq4GXGDV4nlGj8rc+2p8RPeXCyzSog9FJdcw7kTu4ABAi
         D12w5Qb6m3NJdU/qKqWzQPYxZyBJKTK0CGqhtWP0r6JtLh8S8j2qob5oyqQiDohs1olX
         6QC0GOqsPJB1Hn7oAWYcGzZ9Xa7thU0j6HIM00nJPYcyHjv//7AvxkudAt5e8JYxB53O
         ghiw==
X-Gm-Message-State: AC+VfDxT0idjZuNO+ItOYR5/TIJ302r+4rBEFuS/SiZX5fJVa2/TWTLc
        oTTSy+/UyZXthujhfa76XFdXdeURNudnZigcAhDSTA==
X-Google-Smtp-Source: ACHHUZ6FEwkS4o7ndpT8GeI30Lm+uIbRSv3Tc1VjavW6yJisR7xBhyiE+xe8fmXrREZPg2efTDgKCMDSJeDOKEFY42c=
X-Received: by 2002:a17:902:db02:b0:1ad:e633:ee96 with SMTP id
 m2-20020a170902db0200b001ade633ee96mr22318357plx.55.1684335195277; Wed, 17
 May 2023 07:53:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230502132700.654528-1-jaszczyk@google.com> <20230515170013.639f32b6.alex.williamson@redhat.com>
In-Reply-To: <20230515170013.639f32b6.alex.williamson@redhat.com>
From:   Grzegorz Jaszczyk <jaz@semihalf.com>
Date:   Wed, 17 May 2023 16:53:04 +0200
Message-ID: <CAH76GKNzu7Ld8j_X6=p+eox-pnJ8BRuBqsWAzO+SMWtwtsfOAQ@mail.gmail.com>
Subject: Re: [PATCH v3] vfio/pci: Propagate ACPI notifications to user-space
 via eventfd
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-kernel@vger.kernel.org, dmy@semihalf.com, tn@semihalf.com,
        dbehr@google.com, dbehr@chromium.org, upstream@semihalf.com,
        dtor@google.com, jgg@ziepe.ca, kevin.tian@intel.com,
        cohuck@redhat.com, abhsahu@nvidia.com, yishaih@nvidia.com,
        yi.l.liu@intel.com, kvm@vger.kernel.org, libvir-list@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

wt., 16 maj 2023 o 01:00 Alex Williamson <alex.williamson@redhat.com>
napisa=C5=82(a):
>
> On Tue,  2 May 2023 13:27:00 +0000
> Grzegorz Jaszczyk <jaz@semihalf.com> wrote:
>
> > From: Grzegorz Jaszczyk <jaz@semihalf.com>
> >
> > To allow pass-through devices receiving ACPI notifications, permit to
> > register ACPI notify handler (via introduced new ioctl) for a given
>
> This shouldn't require a new ioctl, it should fit within the
> abstraction of the VFIO_DEVICE_SET_IRQS ioctl which already supports
> virtual IRQs for things like error notification and device release
> requests.  Support for this IRQ index on a given device should also be
> discoverable via VFIO_DEVICE_GET_IRQ_INFO that way.

Ok, I will try utilizing VFIO_DEVICE_SET_IRQS instead of introducing new IO=
CTL.

>
> > device. The handler role is to receive and propagate such ACPI
> > notifications to the user-space through the user provided eventfd. This
> > allows VMM to receive and propagate them further to the VM, where the
> > actual driver for pass-through device resides and can react to device
> > specific notifications accordingly.
> >
> > The eventfd usage ensures VMM and device isolation: it allows to use a
> > dedicated channel associated with the device for such events, such that
> > the VMM has direct access.
> >
> > Since the eventfd counter is used as ACPI notification value
> > placeholder, the eventfd signaling needs to be serialized in order to
> > not end up with notification values being coalesced. Therefore ACPI
> > notification values are buffered and signalized one by one, when the
> > previous notification value has been consumed.
>
> I don't see anything that prevents this queuing mechanism from creating
> an arbitrarily large queue, don't we need to drop events at some point
> to avoid introducing an exploit vector?  Aren't these notifications
> often for things like "device check", where queuing duplicate entries
> doesn't make sense and perhaps the most recent notification is the only
> relevant value otherwise?  If we only need to avoid calling
> eventfd_signal() while a non-zero value is pending, couldn't we call
> eventfd_ctx_do_read() ourselves to clear the old value rather than
> queuing?  Thanks,

I think we have to queue. There are multiple different notifications
values, some common across devices, some reserved by vendors for
hardware specific notifications and other device specific ones. The
notification values signifies the purpose of the notification. So the
most recent notification may not be the only relevant one.

Indeed there is a missing mechanism preventing creation of large
queues. I will fix it in the next version and probably allow a certain
number of notifications to be queued e.g. 20 most recent (I do not
expect to have multiple notifications values queued but just want to
prevent losing several different kinds if they are received in a row).

Thank you,
Grzegorz
>
>
> Alex
>
> > Signed-off-by: Grzegorz Jaszczyk <jaz@semihalf.com>
> > ---
> > Changelog v2..v3:
> > - Fix compilation warnings when building with "W=3D1"
> > Changelog v1..v2:
> > - The v2 implementation is actually completely different then v1:
> >   instead of using acpi netlink events for propagating ACPI
> >   notifications to the user space take advantage of eventfd, which can
> >   provide better VMM and device isolation: it allows to use a dedicated
> >   channel associated with the device for such events, such that the VMM
> >   has direct access.
> > - Using eventfd counter as notification value placeholder was suggested
> >   in v1 and requires additional serialization logic introduced in v2.
> > - Since the vfio-pci supports non-ACPI platforms address !CONFIG_ACPI
> >   case.
> > - v1 discussion: https://patchwork.kernel.org/project/kvm/patch/2023030=
7220553.631069-1-jaz@semihalf.com/
> > ---
> >  drivers/vfio/pci/vfio_pci_core.c | 214 +++++++++++++++++++++++++++++++
> >  include/linux/vfio_pci_core.h    |  11 ++
> >  include/uapi/linux/vfio.h        |  15 +++
> >  3 files changed, 240 insertions(+)
> >
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_p=
ci_core.c
> > index a5ab416cf476..2d6101e89fde 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -10,6 +10,7 @@
> >
> >  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >
> > +#include <linux/acpi.h>
> >  #include <linux/aperture.h>
> >  #include <linux/device.h>
> >  #include <linux/eventfd.h>
> > @@ -679,6 +680,70 @@ void vfio_pci_core_disable(struct vfio_pci_core_de=
vice *vdev)
> >  }
> >  EXPORT_SYMBOL_GPL(vfio_pci_core_disable);
> >
> > +struct notification_queue {
> > +     int notification_val;
> > +     struct list_head notify_val_next;
> > +};
> > +
> > +#if IS_ENABLED(CONFIG_ACPI)
> > +static void vfio_pci_core_acpi_notify(acpi_handle handle, u32 event, v=
oid *data)
> > +{
> > +     struct vfio_pci_core_device *vdev =3D (struct vfio_pci_core_devic=
e *)data;
> > +     struct vfio_acpi_notification *acpi_notify =3D vdev->acpi_notific=
ation;
> > +     struct notification_queue *entry;
> > +
> > +     entry =3D kmalloc(sizeof(*entry), GFP_KERNEL);
> > +     if (!entry)
> > +             return;
> > +
> > +     entry->notification_val =3D event;
> > +     INIT_LIST_HEAD(&entry->notify_val_next);
> > +
> > +     mutex_lock(&acpi_notify->notification_list_lock);
> > +     list_add_tail(&entry->notify_val_next, &acpi_notify->notification=
_list);
> > +     mutex_unlock(&acpi_notify->notification_list_lock);
> > +
> > +     schedule_work(&acpi_notify->acpi_notification_work);
> > +}
> > +
> > +static void vfio_pci_acpi_notify_close_device(struct vfio_pci_core_dev=
ice *vdev)
> > +{
> > +     struct vfio_acpi_notification *acpi_notify =3D vdev->acpi_notific=
ation;
> > +     struct pci_dev *pdev =3D vdev->pdev;
> > +     struct acpi_device *adev =3D ACPI_COMPANION(&pdev->dev);
> > +     struct notification_queue *entry, *entry_tmp;
> > +     u64 cnt;
> > +
> > +     if (!acpi_notify || !acpi_notify->acpi_notify_trigger)
> > +             return;
> > +
> > +     acpi_remove_notify_handler(adev->handle, ACPI_DEVICE_NOTIFY,
> > +                                vfio_pci_core_acpi_notify);
> > +
> > +     eventfd_ctx_remove_wait_queue(acpi_notify->acpi_notify_trigger,
> > +                                   &acpi_notify->wait, &cnt);
> > +
> > +     flush_work(&acpi_notify->acpi_notification_work);
> > +
> > +     mutex_lock(&acpi_notify->notification_list_lock);
> > +     list_for_each_entry_safe(entry, entry_tmp,
> > +                              &acpi_notify->notification_list,
> > +                              notify_val_next) {
> > +             list_del(&entry->notify_val_next);
> > +             kfree(entry);
> > +     }
> > +     mutex_unlock(&acpi_notify->notification_list_lock);
> > +
> > +     eventfd_ctx_put(acpi_notify->acpi_notify_trigger);
> > +
> > +     kfree(acpi_notify);
> > +
> > +     vdev->acpi_notification =3D NULL;
> > +}
> > +#else
> > +static void vfio_pci_acpi_notify_close_device(struct vfio_pci_core_dev=
ice *vdev) {}
> > +#endif /* CONFIG_ACPI */
> > +
> >  void vfio_pci_core_close_device(struct vfio_device *core_vdev)
> >  {
> >       struct vfio_pci_core_device *vdev =3D
> > @@ -705,6 +770,8 @@ void vfio_pci_core_close_device(struct vfio_device =
*core_vdev)
> >               vdev->req_trigger =3D NULL;
> >       }
> >       mutex_unlock(&vdev->igate);
> > +
> > +     vfio_pci_acpi_notify_close_device(vdev);
> >  }
> >  EXPORT_SYMBOL_GPL(vfio_pci_core_close_device);
> >
> > @@ -882,6 +949,151 @@ int vfio_pci_core_register_dev_region(struct vfio=
_pci_core_device *vdev,
> >  }
> >  EXPORT_SYMBOL_GPL(vfio_pci_core_register_dev_region);
> >
> > +#if IS_ENABLED(CONFIG_ACPI)
> > +static int vfio_pci_eventfd_wakeup(wait_queue_entry_t *wait, unsigned =
int mode,
> > +                                int sync, void *key)
> > +{
> > +     struct vfio_acpi_notification *acpi_notify =3D
> > +             container_of(wait, struct vfio_acpi_notification, wait);
> > +     __poll_t flags =3D key_to_poll(key);
> > +
> > +     /*
> > +      * eventfd_read signalize EPOLLOUT at the end of its function - t=
his
> > +      * means previous eventfd with its notification value was consume=
d so
> > +      * the next notification can be signalized now if pending - sched=
ule
> > +      * proper work.
> > +      */
> > +     if (flags & EPOLLOUT) {
> > +             mutex_unlock(&acpi_notify->notification_lock);
> > +             schedule_work(&acpi_notify->acpi_notification_work);
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static void vfio_pci_ptable_queue_proc(struct file *file,
> > +                                    wait_queue_head_t *wqh, poll_table=
 *pt)
> > +{
> > +     struct vfio_acpi_notification *acpi_notify =3D
> > +             container_of(pt, struct vfio_acpi_notification, pt);
> > +
> > +     add_wait_queue(wqh, &acpi_notify->wait);
> > +}
> > +
> > +static void acpi_notification_work_fn(struct work_struct *work)
> > +{
> > +     struct vfio_acpi_notification *acpi_notify;
> > +     struct notification_queue *entry;
> > +
> > +     acpi_notify =3D container_of(work, struct vfio_acpi_notification,
> > +                                acpi_notification_work);
> > +
> > +     mutex_lock(&acpi_notify->notification_list_lock);
> > +     if (list_empty(&acpi_notify->notification_list) || !acpi_notify->=
acpi_notify_trigger)
> > +             goto out;
> > +
> > +     /*
> > +      * If the previous eventfd was not yet consumed by user-space let=
s hold
> > +      * on and exit. The notification function will be rescheduled whe=
n
> > +      * signaling eventfd will be possible (when the EPOLLOUT will be
> > +      * signalized and unlocks notify_events).
> > +      */
> > +     if (!mutex_trylock(&acpi_notify->notification_lock))
> > +             goto out;
> > +
> > +     entry =3D list_first_entry(&acpi_notify->notification_list,
> > +                              struct notification_queue, notify_val_ne=
xt);
> > +
> > +     list_del(&entry->notify_val_next);
> > +     mutex_unlock(&acpi_notify->notification_list_lock);
> > +
> > +     eventfd_signal(acpi_notify->acpi_notify_trigger, entry->notificat=
ion_val);
> > +
> > +     kfree(entry);
> > +
> > +     return;
> > +out:
> > +     mutex_unlock(&acpi_notify->notification_list_lock);
> > +}
> > +
> > +static int vfio_pci_ioctl_acpi_notify_eventfd(struct vfio_pci_core_dev=
ice *vdev, struct
> > +                                    vfio_irq_info __user *arg)
> > +{
> > +     struct file *acpi_notify_trigger_file;
> > +     struct vfio_acpi_notification *acpi_notify;
> > +     struct pci_dev *pdev =3D vdev->pdev;
> > +     struct acpi_device *adev =3D ACPI_COMPANION(&pdev->dev);
> > +     struct vfio_acpi_notify_eventfd entry;
> > +     struct eventfd_ctx *efdctx;
> > +     acpi_status status;
> > +
> > +     if (!adev)
> > +             return -ENODEV;
> > +
> > +     if (copy_from_user(&entry, arg, sizeof(entry)))
> > +             return -EFAULT;
> > +
> > +     if (entry.notify_eventfd < 0)
> > +             return -EINVAL;
> > +
> > +     efdctx =3D eventfd_ctx_fdget(entry.notify_eventfd);
> > +     if (IS_ERR(efdctx))
> > +             return PTR_ERR(efdctx);
> > +
> > +     vdev->acpi_notification =3D kzalloc(sizeof(*acpi_notify), GFP_KER=
NEL);
> > +     if (!vdev->acpi_notification)
> > +             return -ENOMEM;
> > +
> > +     acpi_notify =3D vdev->acpi_notification;
> > +
> > +     INIT_WORK(&acpi_notify->acpi_notification_work, acpi_notification=
_work_fn);
> > +     INIT_LIST_HEAD(&acpi_notify->notification_list);
> > +
> > +     acpi_notify->acpi_notify_trigger =3D efdctx;
> > +
> > +     mutex_init(&acpi_notify->notification_lock);
> > +
> > +     /*
> > +      * Install custom wake-up handler to be notified whenever underly=
ing
> > +      * eventfd is consumed by the user-space.
> > +      */
> > +     init_waitqueue_func_entry(&acpi_notify->wait, vfio_pci_eventfd_wa=
keup);
> > +     init_poll_funcptr(&acpi_notify->pt, vfio_pci_ptable_queue_proc);
> > +
> > +     acpi_notify_trigger_file =3D eventfd_fget(entry.notify_eventfd);
> > +     vfs_poll(acpi_notify_trigger_file, &acpi_notify->pt);
> > +
> > +     status =3D acpi_install_notify_handler(adev->handle, ACPI_DEVICE_=
NOTIFY,
> > +                                     vfio_pci_core_acpi_notify, (void =
*)vdev);
> > +
> > +     if (ACPI_FAILURE(status)) {
> > +             u64 cnt;
> > +
> > +             pci_err(pdev, "Failed to install notify handler: %s",
> > +                     acpi_format_exception(status));
> > +
> > +             eventfd_ctx_remove_wait_queue(acpi_notify->acpi_notify_tr=
igger,
> > +                                           &acpi_notify->wait, &cnt);
> > +
> > +             flush_work(&acpi_notify->acpi_notification_work);
> > +
> > +             eventfd_ctx_put(acpi_notify->acpi_notify_trigger);
> > +
> > +             kfree(acpi_notify);
> > +
> > +             return -ENODEV;
> > +     }
> > +
> > +     return 0;
> > +}
> > +#else
> > +static int vfio_pci_ioctl_acpi_notify_eventfd(struct vfio_pci_core_dev=
ice *vdev, struct
> > +                                    vfio_irq_info __user *arg)
> > +{
> > +     return -ENODEV;
> > +}
> > +#endif /* CONFIG_ACPI */
> > +
> >  static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
> >                                  struct vfio_device_info __user *arg)
> >  {
> > @@ -1398,6 +1610,8 @@ long vfio_pci_core_ioctl(struct vfio_device *core=
_vdev, unsigned int cmd,
> >               return vfio_pci_ioctl_reset(vdev, uarg);
> >       case VFIO_DEVICE_SET_IRQS:
> >               return vfio_pci_ioctl_set_irqs(vdev, uarg);
> > +     case VFIO_ACPI_NOTIFY_EVENTFD:
> > +             return vfio_pci_ioctl_acpi_notify_eventfd(vdev, uarg);
> >       default:
> >               return -ENOTTY;
> >       }
> > diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_cor=
e.h
> > index 367fd79226a3..3711e8a1c6f0 100644
> > --- a/include/linux/vfio_pci_core.h
> > +++ b/include/linux/vfio_pci_core.h
> > @@ -49,6 +49,16 @@ struct vfio_pci_region {
> >       u32                             flags;
> >  };
> >
> > +struct vfio_acpi_notification {
> > +     struct eventfd_ctx      *acpi_notify_trigger;
> > +     struct work_struct      acpi_notification_work;
> > +     struct list_head        notification_list;
> > +     struct mutex            notification_list_lock;
> > +     struct mutex            notification_lock;
> > +     poll_table              pt;
> > +     wait_queue_entry_t      wait;
> > +};
> > +
> >  struct vfio_pci_core_device {
> >       struct vfio_device      vdev;
> >       struct pci_dev          *pdev;
> > @@ -96,6 +106,7 @@ struct vfio_pci_core_device {
> >       struct mutex            vma_lock;
> >       struct list_head        vma_list;
> >       struct rw_semaphore     memory_lock;
> > +     struct vfio_acpi_notification   *acpi_notification;
> >  };
> >
> >  /* Will be exported for vfio pci drivers usage */
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 0552e8dcf0cb..d4b602d8f4b2 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -1622,6 +1622,21 @@ struct vfio_iommu_spapr_tce_remove {
> >  };
> >  #define VFIO_IOMMU_SPAPR_TCE_REMOVE  _IO(VFIO_TYPE, VFIO_BASE + 20)
> >
> > +/**
> > + * VFIO_ACPI_NOTIFY_EVENTFD - _IOW(VFIO_TYPE, VFIO_BASE + 21, struct v=
fio_acpi_notify_eventfd)
> > + *
> > + * Register ACPI notify handler for a given device which will allow to=
 receive
> > + * and propagate ACPI notifications to the user-space through the user=
 provided
> > + * eventfd.
> > + *
> > + * Return: 0 on success, -errno on failure.
> > + */
> > +struct vfio_acpi_notify_eventfd {
> > +     __s32 notify_eventfd;
> > +     __u32 reserved;
> > +};
> > +#define VFIO_ACPI_NOTIFY_EVENTFD     _IO(VFIO_TYPE, VFIO_BASE + 21)
> > +
> >  /* ***************************************************************** *=
/
> >
> >  #endif /* _UAPIVFIO_H */
>
