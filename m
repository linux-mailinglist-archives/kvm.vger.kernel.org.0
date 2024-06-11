Return-Path: <kvm+bounces-19303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 536D1903749
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 10:59:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C4521C233E7
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 08:59:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 449CF17623B;
	Tue, 11 Jun 2024 08:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XDTgesuQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE8F174EEB;
	Tue, 11 Jun 2024 08:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718096343; cv=none; b=TLJ9p288APe+qUV12N4LjBd1ZByXVrKw7adzPWEs71/xhu5xv7WTNJ5VajQbfCMYXjy3jChD/I12E3YbEKWwOeEpF8ctkXcMhdVLMEGmRPSuVfEmx7u7loyR41Jek0UAiOXivC1BsJHBXOI2BTSUvQLW5ZLxcX9lEbUIaMbXtG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718096343; c=relaxed/simple;
	bh=7qdVuppVYC28bq9ftKsexVE1MdCnmqhCkcPqyPRINqY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kkZOqlB54iQA83G4qVhm4arC+7gn6RtcjGIsrXNMoG2CRrwRmxfCT0w6cjvvnNwCtA/sa3iwB9uBvK6DCjjNY3B6EVNJTTB1CsCJccdMlteXrY7onbWpr4VFhUG4fI7grsu1RxdWJwthT2ApJnSvwVUSPVc4iOvV+uMNx/OnXDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XDTgesuQ; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-57c681dd692so3932082a12.3;
        Tue, 11 Jun 2024 01:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718096340; x=1718701140; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ta5gs6XiSzNP6Nqlq/7WpwLKj34EW0SB5yZl9DbAxWA=;
        b=XDTgesuQjOmsBnSN7CZtOLYY5WgvLeFhdWfhNV7FbPUNe+Rykppl1yod38rEb2DNBi
         Da9D82TbPlgg7VSqJu1TPxsnZSecYKXM/WEr/78HfSmpjjPqPoBdP3GzGwIAtva3sRYM
         9Fj+shRYsPpVLaSwXeNwfdOCLk8UFqOIZVxhLdAz86PB2INN74zzzIJ6ZeHtvHuMJmzg
         8hjZG9yHSBeim7eneQeeDPu9PJmHw2DTjveVgfRaglaw9PBYPTIRjpVMkgrAUpPfnAIB
         CSTGibxPbAOYJoWan6+PFtF+kWA8SFQGdv9J0xXGavc+Zj1oR9sZrxtv7bYZQqPaV6uj
         yGXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718096340; x=1718701140;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ta5gs6XiSzNP6Nqlq/7WpwLKj34EW0SB5yZl9DbAxWA=;
        b=EnlyUsEaz/tp1Gh79/r/HUYBsb8fVcWvJJ/xwnxocHhDMG2qUeFZFjzTc0l6YXkBSC
         UIW1f/2mbrcrtHKdf/R3RWXTPTKAIbVfqv+MUBPKfXilhdF0DdJD0FEAmYCDb+WxUJCE
         hawG9Qq2GNoHBN+tL+GQ09hPsxTVRXlmEy3PMab++z7UyVEkrxZe5mITlBNGOjJ6ELBH
         5oEPrAVnVWzB4Td+7M7HZ3JZvyrMqcPvt6e9+D0cMMRPalJz1P3x5Ft9I5eGGGcxwWSB
         GnXVDbUcJvy5HmYlK+vii2a4ciwwe6OSES0Ktl8EMEOjf94eCTIBfYOvJg0M+gj1Kcp0
         WKeQ==
X-Forwarded-Encrypted: i=1; AJvYcCWeMiMJluuyU/euBljWa/GCozjIK4HtmiDA6ms7rr9qE0NjqZksV4IyTT6c0YDJImM2/Bnn2N4pKmYaJPgeu91O8OYVbA3LwVOcSZzjTw2N/zxNAcN+rszHKhtNxBU5JpHYQ78lgnHrKjWLvkkH+bASsMB0jcleyVeh0Q==
X-Gm-Message-State: AOJu0Yzvuw/FuSrTJdWgoCbJwQcG8YDOg6MeY2fuos0Tbi17u1gbj+YN
	AlgzjSg/YBGuUJKc8UzCmZ42WZGx/9a7Riz0I2/JuwpC1KWCV6FwTwFNm5Sy03OiShSWADd8qqI
	QSU78mE4DsmMiE/Kw91gi/Buox88=
X-Google-Smtp-Source: AGHT+IEo5DhDHwQd10uwT+cXN3yc9yNMwVncY2l6k8Hog93c5mTUPs5asV+L5bNs6vwj+PAnYC30zmEbmh5kjuwerQo=
X-Received: by 2002:a50:9e4b:0:b0:57c:5637:b2ae with SMTP id
 4fb4d7f45d1cf-57c5637c846mr7035785a12.12.1718096339374; Tue, 11 Jun 2024
 01:58:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240610125713.86750-1-fgriffo@amazon.co.uk> <20240610125713.86750-3-fgriffo@amazon.co.uk>
 <20240610133207.7d039dab.alex.williamson@redhat.com>
In-Reply-To: <20240610133207.7d039dab.alex.williamson@redhat.com>
From: Frederic Griffoul <griffoul@gmail.com>
Date: Tue, 11 Jun 2024 09:58:48 +0100
Message-ID: <CAF2vKzMnr7LGvo6T3mrNoLQxXr3o04PQjiosNEcQfce2DgDM1g@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] vfio/pci: add msi interrupt affinity support
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Fred Griffoul <fgriffo@amazon.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Mark Rutland <mark.rutland@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Mark Brown <broonie@kernel.org>, 
	Ard Biesheuvel <ardb@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Jeremy Linton <jeremy.linton@arm.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Yi Liu <yi.l.liu@intel.com>, Kevin Tian <kevin.tian@intel.com>, 
	Eric Auger <eric.auger@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Ye Bin <yebin10@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 10, 2024 at 8:32=E2=80=AFPM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Mon, 10 Jun 2024 12:57:08 +0000
> Fred Griffoul <fgriffo@amazon.co.uk> wrote:
>
> > The usual way to configure a device interrupt from userland is to write
> > the /proc/irq/<irq>/smp_affinity or smp_affinity_list files. When using
> > vfio to implement a device driver or a virtual machine monitor, this ma=
y
> > not be ideal: the process managing the vfio device interrupts may not b=
e
> > granted root privilege, for security reasons. Thus it cannot directly
> > control the interrupt affinity and has to rely on an external command.
> >
> > This patch extends the VFIO_DEVICE_SET_IRQS ioctl() with a new data fla=
g
> > to specify the affinity of interrupts of a vfio pci device.
> >
> > The CPU affinity mask argument must be a subset of the process cpuset,
> > otherwise an error -EPERM is returned.
> >
> > The vfio_irq_set argument shall be set-up in the following way:
> >
> > - the 'flags' field have the new flag VFIO_IRQ_SET_DATA_AFFINITY set
> > as well as VFIO_IRQ_SET_ACTION_TRIGGER.
> >
> > - the variable-length 'data' field is a cpu_set_t structure, as
> > for the sched_setaffinity() syscall, the size of which is derived
> > from 'argsz'.
> >
> > Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
> > ---
> >  drivers/vfio/pci/vfio_pci_core.c  | 27 +++++++++++++++++----
> >  drivers/vfio/pci/vfio_pci_intrs.c | 39 +++++++++++++++++++++++++++++++
> >  drivers/vfio/vfio_main.c          | 13 +++++++----
> >  include/uapi/linux/vfio.h         | 10 +++++++-
> >  4 files changed, 80 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_p=
ci_core.c
> > index 80cae87fff36..2e3419560480 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -1192,6 +1192,7 @@ static int vfio_pci_ioctl_set_irqs(struct vfio_pc=
i_core_device *vdev,
> >  {
> >       unsigned long minsz =3D offsetofend(struct vfio_irq_set, count);
> >       struct vfio_irq_set hdr;
> > +     cpumask_var_t mask;
> >       u8 *data =3D NULL;
> >       int max, ret =3D 0;
> >       size_t data_size =3D 0;
> > @@ -1207,9 +1208,22 @@ static int vfio_pci_ioctl_set_irqs(struct vfio_p=
ci_core_device *vdev,
> >               return ret;
> >
> >       if (data_size) {
> > -             data =3D memdup_user(&arg->data, data_size);
> > -             if (IS_ERR(data))
> > -                     return PTR_ERR(data);
> > +             if (hdr.flags & VFIO_IRQ_SET_DATA_AFFINITY) {
> > +                     if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
> > +                             return -ENOMEM;
> > +
> > +                     if (copy_from_user(mask, &arg->data, data_size)) =
{
> > +                             ret =3D -EFAULT;
> > +                             goto out;
> > +                     }
> > +
> > +                     data =3D (u8 *)mask;
>
> Seems like this could just use the memdup_user() path, why do we care
> to copy it into a cpumask_var_t here?  If we do care, wouldn't we
> implement something like get_user_cpu_mask() used by
> sched_setaffinity(2)?
>

A valid cpu_set_t argument could be smaller than a cpumask_var_t so we
have to allocate a cpumask_var_t and zero it if the argument size is smalle=
r.
Moreover depending on the kernel configuration the cpumask_var_t could
be allocated on the stack, avoiding an actual memory allocation.

Exporting get_user_cpu_mask() may be better, although here the size
is checked in a separate function, as there are other explicit user
cpumask handling (in io_uring for instance).

> > +
> > +             } else {
> > +                     data =3D memdup_user(&arg->data, data_size);
> > +                     if (IS_ERR(data))
> > +                             return PTR_ERR(data);
> > +             }
> >       }
> >
> >       mutex_lock(&vdev->igate);
> > @@ -1218,7 +1232,12 @@ static int vfio_pci_ioctl_set_irqs(struct vfio_p=
ci_core_device *vdev,
> >                                     hdr.count, data);
> >
> >       mutex_unlock(&vdev->igate);
> > -     kfree(data);
> > +
> > +out:
> > +     if (hdr.flags & VFIO_IRQ_SET_DATA_AFFINITY && data_size)
> > +             free_cpumask_var(mask);
> > +     else
> > +             kfree(data);
> >
> >       return ret;
> >  }
> > diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_=
pci_intrs.c
> > index 8382c5834335..fe01303cf94e 100644
> > --- a/drivers/vfio/pci/vfio_pci_intrs.c
> > +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> > @@ -19,6 +19,7 @@
> >  #include <linux/vfio.h>
> >  #include <linux/wait.h>
> >  #include <linux/slab.h>
> > +#include <linux/cpuset.h>
> >
> >  #include "vfio_pci_priv.h"
> >
> > @@ -675,6 +676,41 @@ static int vfio_pci_set_intx_trigger(struct vfio_p=
ci_core_device *vdev,
> >       return 0;
> >  }
> >
> > +static int vfio_pci_set_msi_affinity(struct vfio_pci_core_device *vdev=
,
> > +                                  unsigned int start, unsigned int cou=
nt,
> > +                                  struct cpumask *irq_mask)
>
> Aside from the name, what makes this unique to MSI vectors?
>

Actually nothing, I had a use case for VFIO msi and msi-x based devices onl=
y.

> > +{
> > +     struct vfio_pci_irq_ctx *ctx;
> > +     cpumask_var_t allowed_mask;
> > +     unsigned int i;
> > +     int err =3D 0;
> > +
> > +     if (!alloc_cpumask_var(&allowed_mask, GFP_KERNEL))
> > +             return -ENOMEM;
> > +
> > +     cpuset_cpus_allowed(current, allowed_mask);
> > +     if (!cpumask_subset(irq_mask, allowed_mask)) {
> > +             err =3D -EPERM;
> > +             goto finish;
> > +     }
> > +
> > +     for (i =3D start; i < start + count; i++) {
> > +             ctx =3D vfio_irq_ctx_get(vdev, i);
> > +             if (!ctx) {
> > +                     err =3D -EINVAL;
> > +                     break;
> > +             }
> > +
> > +             err =3D irq_set_affinity(ctx->producer.irq, irq_mask);
> > +             if (err)
> > +                     break;
> > +     }
>
> Is this typical/userful behavior to set a series of vectors to the same
> cpu_set_t?  It's unusual behavior for this ioctl to apply the same data
> across multiple vectors.  Should the DATA_AFFINITY case support an
> array of cpu_set_t?
>

My main use case is to configure NVMe queues in a virtual machine monitor
to interrupt only the physical CPUs assigned to that vmm. Then we can
set the same cpu_set_t to all the admin and I/O queues with a single ioctl(=
).

I reckon another usage would be to assign a specific CPU for each interrupt
vector: with this interface it requires multiple ioctl().

I'm worried about the size of the argument if we allow an array of cpu_set_=
t
for a device with many interrupt vectors.

> > +
> > +finish:
> > +     free_cpumask_var(allowed_mask);
> > +     return err;
> > +}
> > +
> >  static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
> >                                   unsigned index, unsigned start,
> >                                   unsigned count, uint32_t flags, void =
*data)
> > @@ -713,6 +749,9 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci=
_core_device *vdev,
> >       if (!irq_is(vdev, index))
> >               return -EINVAL;
> >
> > +     if (flags & VFIO_IRQ_SET_DATA_AFFINITY)
> > +             return vfio_pci_set_msi_affinity(vdev, start, count, data=
);
> > +
> >       for (i =3D start; i < start + count; i++) {
> >               ctx =3D vfio_irq_ctx_get(vdev, i);
> >               if (!ctx)
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index e97d796a54fb..e75c5d66681c 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -1505,23 +1505,28 @@ int vfio_set_irqs_validate_and_prepare(struct v=
fio_irq_set *hdr, int num_irqs,
> >               size =3D 0;
> >               break;
> >       case VFIO_IRQ_SET_DATA_BOOL:
> > -             size =3D sizeof(uint8_t);
> > +             size =3D hdr->count * sizeof(uint8_t);
> >               break;
> >       case VFIO_IRQ_SET_DATA_EVENTFD:
> > -             size =3D sizeof(int32_t);
> > +             size =3D size_mul(hdr->count, sizeof(int32_t));
>
> Why use size_mul() in one place and not the other?
>

Right. The DATA_BOOL cannot overflow this `hdr->count` has been checked
already but it would be more consistent to use it there too.

> > +             break;
> > +     case VFIO_IRQ_SET_DATA_AFFINITY:
> > +             size =3D hdr->argsz - minsz;
> > +             if (size > cpumask_size())
> > +                     size =3D cpumask_size();
>
> Or just set size =3D (hdr->argsz - minsz) / count?
>
> Generate an error if (hdr->argsz - minsz) % count?
>
> It seems like all the cpumask'items can be contained to the set affinity
> function.
>

Ok. Indeed we can just copy the hdr->argz - minsz, then allocate and copy
the cpumask_var_t only in the set affinity function. It only costs 1 memory
allocation but the patch will be less intrusive in the generic ioctl()) cod=
e.

> >               break;
> >       default:
> >               return -EINVAL;
> >       }
> >
> >       if (size) {
> > -             if (hdr->argsz - minsz < hdr->count * size)
> > +             if (hdr->argsz - minsz < size)
> >                       return -EINVAL;
> >
> >               if (!data_size)
> >                       return -EINVAL;
> >
> > -             *data_size =3D hdr->count * size;
> > +             *data_size =3D size;
> >       }
> >
> >       return 0;
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 2b68e6cdf190..5ba2ca223550 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -580,6 +580,12 @@ struct vfio_irq_info {
> >   *
> >   * Note that ACTION_[UN]MASK specify user->kernel signaling (irqfds) w=
hile
> >   * ACTION_TRIGGER specifies kernel->user signaling.
> > + *
> > + * DATA_AFFINITY specifies the affinity for the range of interrupt vec=
tors.
> > + * It must be set with ACTION_TRIGGER in 'flags'. The variable-length =
'data'
> > + * array is a CPU affinity mask 'cpu_set_t' structure, as for the
> > + * sched_setaffinity() syscall argument: the 'argsz' field is used to =
check
> > + * the actual cpu_set_t size.
> >   */
>
> DATA_CPUSET?
>
> The IRQ_INFO ioctl should probably also report support for this
> feature.
>

Ok, I will do it in the next revision.

> Is there any proposed userspace code that takes advantage of this
> interface?  Thanks,
>

Not yet but I will work on it.

Thanks for your review.

Fred


> Alex
>
> >  struct vfio_irq_set {
> >       __u32   argsz;
> > @@ -587,6 +593,7 @@ struct vfio_irq_set {
> >  #define VFIO_IRQ_SET_DATA_NONE               (1 << 0) /* Data not pres=
ent */
> >  #define VFIO_IRQ_SET_DATA_BOOL               (1 << 1) /* Data is bool =
(u8) */
> >  #define VFIO_IRQ_SET_DATA_EVENTFD    (1 << 2) /* Data is eventfd (s32)=
 */
> > +#define VFIO_IRQ_SET_DATA_AFFINITY   (1 << 6) /* Data is cpu_set_t */
> >  #define VFIO_IRQ_SET_ACTION_MASK     (1 << 3) /* Mask interrupt */
> >  #define VFIO_IRQ_SET_ACTION_UNMASK   (1 << 4) /* Unmask interrupt */
> >  #define VFIO_IRQ_SET_ACTION_TRIGGER  (1 << 5) /* Trigger interrupt */
> > @@ -599,7 +606,8 @@ struct vfio_irq_set {
> >
> >  #define VFIO_IRQ_SET_DATA_TYPE_MASK  (VFIO_IRQ_SET_DATA_NONE | \
> >                                        VFIO_IRQ_SET_DATA_BOOL | \
> > -                                      VFIO_IRQ_SET_DATA_EVENTFD)
> > +                                      VFIO_IRQ_SET_DATA_EVENTFD | \
> > +                                      VFIO_IRQ_SET_DATA_AFFINITY)
> >  #define VFIO_IRQ_SET_ACTION_TYPE_MASK        (VFIO_IRQ_SET_ACTION_MASK=
 | \
> >                                        VFIO_IRQ_SET_ACTION_UNMASK | \
> >                                        VFIO_IRQ_SET_ACTION_TRIGGER)
>

