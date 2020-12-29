Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523722E6FFE
	for <lists+kvm@lfdr.de>; Tue, 29 Dec 2020 12:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725986AbgL2LiA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Dec 2020 06:38:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22977 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725866AbgL2Lh7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Dec 2020 06:37:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609241791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bd3QIoBDzpZ9pG+z57wiY1KS3xtz8Z35nRS73E+tu+4=;
        b=L7zpMeMaMgb56nv2gGCkkaJoqoHWxrZ4C8SVKZJgao/zV79HM5kK/rvJWuokjRm0Mryfk/
        p7NDGVPyLDI5Wz3BfV+qN1MhfeuZDvyli8kdG/FvqxMsagHs63Cu7nckefh0ldT8uS2kkT
        2hgO+puxAbxmqF0XSPakvZXfVzXsbpc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-LpTJmXZwNkmhzGT81uf2Wg-1; Tue, 29 Dec 2020 06:36:28 -0500
X-MC-Unique: LpTJmXZwNkmhzGT81uf2Wg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE10D1005504;
        Tue, 29 Dec 2020 11:36:27 +0000 (UTC)
Received: from localhost (ovpn-113-76.ams2.redhat.com [10.36.113.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B26D19C45;
        Tue, 29 Dec 2020 11:36:26 +0000 (UTC)
Date:   Tue, 29 Dec 2020 11:36:26 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Elena Afanasova <eafanasova@gmail.com>
Cc:     kvm@vger.kernel.org, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com
Subject: Re: [RFC 1/2] KVM: add initial support for KVM_SET_IOREGION
Message-ID: <20201229113626.GB55616@stefanha-x1.localdomain>
References: <cover.1609231373.git.eafanasova@gmail.com>
 <d4af2bcbd2c6931a24ba99236248529c3bfb6999.1609231374.git.eafanasova@gmail.com>
MIME-Version: 1.0
In-Reply-To: <d4af2bcbd2c6931a24ba99236248529c3bfb6999.1609231374.git.eafanasova@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tjCHc7DPkfUGtrlw"
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--tjCHc7DPkfUGtrlw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 29, 2020 at 01:02:43PM +0300, Elena Afanasova wrote:
> This vm ioctl adds or removes an ioregionfd MMIO/PIO region. Guest
> read and write accesses are dispatched through the given ioregionfd
> instead of returning from ioctl(KVM_RUN). Regions can be deleted by
> setting fds to -1.
>=20
> Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
> ---
>  arch/x86/kvm/Kconfig     |   1 +
>  arch/x86/kvm/Makefile    |   1 +
>  arch/x86/kvm/x86.c       |   1 +
>  include/linux/kvm_host.h |  17 +++
>  include/uapi/linux/kvm.h |  23 ++++
>  virt/kvm/Kconfig         |   3 +
>  virt/kvm/eventfd.c       |  25 +++++
>  virt/kvm/eventfd.h       |  14 +++
>  virt/kvm/ioregion.c      | 233 +++++++++++++++++++++++++++++++++++++++
>  virt/kvm/ioregion.h      |  15 +++
>  virt/kvm/kvm_main.c      |  20 +++-
>  11 files changed, 350 insertions(+), 3 deletions(-)
>  create mode 100644 virt/kvm/eventfd.h
>  create mode 100644 virt/kvm/ioregion.c
>  create mode 100644 virt/kvm/ioregion.h
>=20
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index f92dfd8ef10d..b914ef375199 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -33,6 +33,7 @@ config KVM
>  =09select HAVE_KVM_IRQ_BYPASS
>  =09select HAVE_KVM_IRQ_ROUTING
>  =09select HAVE_KVM_EVENTFD
> +=09select KVM_IOREGION
>  =09select KVM_ASYNC_PF
>  =09select USER_RETURN_NOTIFIER
>  =09select KVM_MMIO

TODO non-x86 arch support

> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index b804444e16d4..b3b17dc9f7d4 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -12,6 +12,7 @@ KVM :=3D ../../../virt/kvm
>  kvm-y=09=09=09+=3D $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
>  =09=09=09=09$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
>  kvm-$(CONFIG_KVM_ASYNC_PF)=09+=3D $(KVM)/async_pf.o
> +kvm-$(CONFIG_KVM_IOREGION)=09+=3D $(KVM)/ioregion.o
> =20
>  kvm-y=09=09=09+=3D x86.o emulate.o i8259.o irq.o lapic.o \
>  =09=09=09   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e545a8a613b1..ddb28f5ca252 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3739,6 +3739,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, l=
ong ext)
>  =09case KVM_CAP_X86_USER_SPACE_MSR:
>  =09case KVM_CAP_X86_MSR_FILTER:
>  =09case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
> +=09case KVM_CAP_IOREGIONFD:
>  =09=09r =3D 1;
>  =09=09break;
>  =09case KVM_CAP_SYNC_REGS:
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 7f2e2a09ebbd..7cd667dddba9 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -470,6 +470,10 @@ struct kvm {
>  =09=09struct mutex      resampler_lock;
>  =09} irqfds;
>  =09struct list_head ioeventfds;
> +#endif
> +#ifdef CONFIG_KVM_IOREGION
> +=09struct list_head ioregions_mmio;
> +=09struct list_head ioregions_pio;
>  #endif
>  =09struct kvm_vm_stat stat;
>  =09struct kvm_arch arch;
> @@ -1262,6 +1266,19 @@ static inline int kvm_ioeventfd(struct kvm *kvm, s=
truct kvm_ioeventfd *args)
> =20
>  #endif /* CONFIG_HAVE_KVM_EVENTFD */
> =20
> +#ifdef CONFIG_KVM_IOREGION
> +void kvm_ioregionfd_init(struct kvm *kvm);
> +int kvm_ioregionfd(struct kvm *kvm, struct kvm_ioregion *args);
> +
> +#else
> +
> +static inline void kvm_ioregionfd_init(struct kvm *kvm) {}
> +static inline int kvm_ioregionfd(struct kvm *kvm, struct kvm_ioregion *a=
rgs)
> +{
> +=09return -ENOSYS;
> +}
> +#endif
> +
>  void kvm_arch_irq_routing_update(struct kvm *kvm);
> =20
>  static inline void kvm_make_request(int req, struct kvm_vcpu *vcpu)
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index ca41220b40b8..81e775778c66 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -732,6 +732,27 @@ struct kvm_ioeventfd {
>  =09__u8  pad[36];
>  };
> =20
> +enum {
> +=09kvm_ioregion_flag_nr_pio,
> +=09kvm_ioregion_flag_nr_posted_writes,
> +=09kvm_ioregion_flag_nr_max,
> +};
> +
> +#define KVM_IOREGION_PIO (1 << kvm_ioregion_flag_nr_pio)
> +#define KVM_IOREGION_POSTED_WRITES (1 << kvm_ioregion_flag_nr_posted_wri=
tes)
> +
> +#define KVM_IOREGION_VALID_FLAG_MASK ((1 << kvm_ioregion_flag_nr_max) - =
1)
> +
> +struct kvm_ioregion {
> +=09__u64 guest_paddr; /* guest physical address */
> +=09__u64 memory_size; /* bytes */
> +=09__u64 user_data;
> +=09__s32 rfd;
> +=09__s32 wfd;
> +=09__u32 flags;
> +=09__u8  pad[28];
> +};
> +
>  #define KVM_X86_DISABLE_EXITS_MWAIT          (1 << 0)
>  #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
>  #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
> @@ -1053,6 +1074,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_X86_USER_SPACE_MSR 188
>  #define KVM_CAP_X86_MSR_FILTER 189
>  #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
> +#define KVM_CAP_IOREGIONFD 191
> =20
>  #ifdef KVM_CAP_IRQ_ROUTING
> =20
> @@ -1308,6 +1330,7 @@ struct kvm_vfio_spapr_tce {
>  =09=09=09=09=09struct kvm_userspace_memory_region)
>  #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
>  #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
> +#define KVM_SET_IOREGION          _IOW(KVMIO,  0x49, struct kvm_ioregion=
)
> =20
>  /* enable ucontrol for s390 */
>  struct kvm_s390_ucas_mapping {
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 1c37ccd5d402..5e6620bbf000 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -17,6 +17,9 @@ config HAVE_KVM_EVENTFD
>         bool
>         select EVENTFD
> =20
> +config KVM_IOREGION
> +       bool
> +
>  config KVM_MMIO
>         bool
> =20
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index c2323c27a28b..aadb73903f8b 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -27,6 +27,7 @@
>  #include <trace/events/kvm.h>
> =20
>  #include <kvm/iodev.h>
> +#include "ioregion.h"
> =20
>  #ifdef CONFIG_HAVE_KVM_IRQFD
> =20
> @@ -755,6 +756,23 @@ static const struct kvm_io_device_ops ioeventfd_ops =
=3D {
>  =09.destructor =3D ioeventfd_destructor,
>  };
> =20
> +#ifdef CONFIG_KVM_IOREGION
> +/* assumes kvm->slots_lock held */
> +bool kvm_eventfd_collides(struct kvm *kvm, int bus_idx,
> +=09=09=09  u64 start, u64 size)
> +{
> +=09struct _ioeventfd *_p;
> +
> +=09list_for_each_entry(_p, &kvm->ioeventfds, list)
> +=09=09if (_p->bus_idx =3D=3D bus_idx &&
> +=09=09    overlap(start, size, _p->addr,
> +=09=09=09    !_p->length ? 8 : _p->length))
> +=09=09=09return true;
> +
> +=09return false;
> +}
> +#endif
> +
>  /* assumes kvm->slots_lock held */
>  static bool
>  ioeventfd_check_collision(struct kvm *kvm, struct _ioeventfd *p)
> @@ -770,6 +788,13 @@ ioeventfd_check_collision(struct kvm *kvm, struct _i=
oeventfd *p)
>  =09=09       _p->datamatch =3D=3D p->datamatch))))
>  =09=09=09return true;
> =20
> +#ifdef CONFIG_KVM_IOREGION
> +=09if (p->bus_idx =3D=3D KVM_MMIO_BUS || p->bus_idx =3D=3D KVM_PIO_BUS)
> +=09=09if (kvm_ioregion_collides(kvm, p->bus_idx, p->addr,
> +=09=09=09=09=09  !p->length ? 8 : p->length))
> +=09=09=09return true;
> +#endif
> +
>  =09return false;
>  }
> =20
> diff --git a/virt/kvm/eventfd.h b/virt/kvm/eventfd.h
> new file mode 100644
> index 000000000000..73a621eebae3
> --- /dev/null
> +++ b/virt/kvm/eventfd.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef __KVM_EVENTFD_H__
> +#define __KVM_EVENTFD_H__
> +
> +#ifdef CONFIG_KVM_IOREGION
> +bool kvm_eventfd_collides(struct kvm *kvm, int bus_idx, u64 start, u64 s=
ize);
> +#else
> +static inline bool
> +kvm_eventfd_collides(struct kvm *kvm, int bus_idx, u64 start, u64 size)
> +{
> +=09return false;
> +}
> +#endif
> +#endif
> diff --git a/virt/kvm/ioregion.c b/virt/kvm/ioregion.c
> new file mode 100644
> index 000000000000..a200c3761343
> --- /dev/null
> +++ b/virt/kvm/ioregion.c
> @@ -0,0 +1,233 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <linux/kvm_host.h>
> +#include <linux/fs.h>
> +#include <kvm/iodev.h>
> +#include "eventfd.h"
> +
> +void
> +kvm_ioregionfd_init(struct kvm *kvm)
> +{
> +=09INIT_LIST_HEAD(&kvm->ioregions_mmio);
> +=09INIT_LIST_HEAD(&kvm->ioregions_pio);
> +}
> +
> +struct ioregion {

Please add comments describing the purpose of the fields, locking, etc.
For example, the list field is used with kvm->ioregions_mmio/pio. paddr
is a guest physical address. size is in bytes. wf is for writing struct
ioregion_cmd. rf is for reading struct ioregion_resp.

> +=09struct list_head     list;
> +=09u64                  paddr;
> +=09u64                  size;
> +=09struct file         *rf;
> +=09struct file         *wf;
> +=09u64                  user_data;
> +=09struct kvm_io_device dev;
> +=09bool                 posted_writes;

TODO implement posted_writes

> +};
> +
> +static inline struct ioregion *
> +to_ioregion(struct kvm_io_device *dev)
> +{
> +=09return container_of(dev, struct ioregion, dev);
> +}
> +
> +/* assumes kvm->slots_lock held */
> +static void
> +ioregion_release(struct ioregion *p)
> +{
> +=09fput(p->rf);
> +=09fput(p->wf);
> +=09list_del(&p->list);
> +=09kfree(p);
> +}
> +
> +static int
> +ioregion_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t a=
ddr,
> +=09      int len, void *val)
> +{
> +=09return 0;
> +}
> +
> +static int
> +ioregion_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t =
addr,
> +=09=09int len, const void *val)
> +{
> +=09return 0;
> +}

The unimplemented ->read()/->write() should probably return errors.

> +
> +/*
> + * This function is called as KVM is completely shutting down.  We do no=
t
> + * need to worry about locking just nuke anything we have as quickly as =
possible
> + */
> +static void
> +ioregion_destructor(struct kvm_io_device *this)
> +{
> +=09struct ioregion *p =3D to_ioregion(this);
> +
> +=09ioregion_release(p);
> +}
> +
> +static const struct kvm_io_device_ops ioregion_ops =3D {
> +=09.read       =3D ioregion_read,
> +=09.write      =3D ioregion_write,
> +=09.destructor =3D ioregion_destructor,
> +};
> +
> +static inline struct list_head *
> +get_ioregion_list(struct kvm *kvm, enum kvm_bus bus_idx)
> +{
> +=09return (bus_idx =3D=3D KVM_MMIO_BUS) ?
> +=09=09&kvm->ioregions_mmio : &kvm->ioregions_pio;
> +}
> +
> +/* check for not overlapping case and reverse */
> +inline bool
> +overlap(u64 start1, u64 size1, u64 start2, u64 size2)
> +{
> +=09u64 end1 =3D start1 + size1 - 1;
> +=09u64 end2 =3D start2 + size2 - 1;
> +
> +=09return !(end1 < start2 || start1 >=3D end2);
> +}
> +
> +/* assumes kvm->slots_lock held */
> +bool
> +kvm_ioregion_collides(struct kvm *kvm, int bus_idx,
> +=09=09      u64 start, u64 size)
> +{
> +=09struct ioregion *_p;
> +=09struct list_head *ioregions;
> +
> +=09ioregions =3D get_ioregion_list(kvm, bus_idx);
> +=09list_for_each_entry(_p, ioregions, list)
> +=09=09if (overlap(start, size, _p->paddr, _p->size))
> +=09=09=09return true;
> +
> +=09return false;
> +}
> +
> +/* assumes kvm->slots_lock held */
> +static bool
> +ioregion_collision(struct kvm *kvm, struct ioregion *p, enum kvm_bus bus=
_idx)
> +{
> +=09if (kvm_ioregion_collides(kvm, bus_idx, p->paddr, p->size) ||
> +=09    kvm_eventfd_collides(kvm, bus_idx, p->paddr, p->size))
> +=09=09return true;
> +
> +=09return false;
> +}
> +
> +static enum kvm_bus
> +get_bus_from_flags(__u32 flags)
> +{
> +=09if (flags & KVM_IOREGION_PIO)
> +=09=09return KVM_PIO_BUS;
> +=09return KVM_MMIO_BUS;
> +}
> +
> +int
> +kvm_set_ioregion(struct kvm *kvm, struct kvm_ioregion *args)
> +{
> +=09struct ioregion *p;
> +=09bool is_posted_writes;
> +=09struct file *rfile, *wfile;
> +=09enum kvm_bus bus_idx;
> +=09int ret =3D 0;
> +
> +=09if (!args->memory_size)
> +=09=09return -EINVAL;
> +=09if ((args->guest_paddr + args->memory_size - 1) < args->guest_paddr)
> +=09=09return -EINVAL;
> +=09if (args->flags & ~KVM_IOREGION_VALID_FLAG_MASK)
> +=09=09return -EINVAL;
> +
> +=09rfile =3D fget(args->rfd);
> +=09if (!rfile)
> +=09=09return -EBADF;
> +=09wfile =3D fget(args->wfd);
> +=09if (!wfile) {
> +=09=09fput(rfile);
> +=09=09return -EBADF;
> +=09}
> +=09if ((rfile->f_flags & O_NONBLOCK) || (wfile->f_flags & O_NONBLOCK)) {

This check prevents most user errors, but the userspace process can
still change the file descriptor flags later. Therefore the code needs
to be written to fail cleanly on -EAGAIN/-EWOULDBLOCK (no infinite loops
or crashes). It's worth noting this in a comment here so others reading
the code are aware of this constraint.

> +=09=09ret =3D -EINVAL;
> +=09=09goto fail;
> +=09}
> +=09p =3D kzalloc(sizeof(*p), GFP_KERNEL_ACCOUNT);
> +=09if (!p) {
> +=09=09ret =3D -ENOMEM;
> +=09=09goto fail;
> +=09}
> +
> +=09INIT_LIST_HEAD(&p->list);
> +=09p->paddr =3D args->guest_paddr;
> +=09p->size =3D args->memory_size;
> +=09p->user_data =3D args->user_data;
> +=09p->rf =3D rfile;
> +=09p->wf =3D wfile;
> +=09is_posted_writes =3D args->flags & KVM_IOREGION_POSTED_WRITES;
> +=09p->posted_writes =3D is_posted_writes ? true : false;
> +=09bus_idx =3D get_bus_from_flags(args->flags);
> +
> +=09mutex_lock(&kvm->slots_lock);
> +
> +=09if (ioregion_collision(kvm, p, bus_idx)) {
> +=09=09ret =3D -EEXIST;
> +=09=09goto unlock_fail;
> +=09}
> +=09kvm_iodevice_init(&p->dev, &ioregion_ops);
> +=09ret =3D kvm_io_bus_register_dev(kvm, bus_idx, p->paddr, p->size,
> +=09=09=09=09      &p->dev);
> +=09if (ret < 0)
> +=09=09goto unlock_fail;
> +=09list_add_tail(&p->list, get_ioregion_list(kvm, bus_idx));
> +
> +=09mutex_unlock(&kvm->slots_lock);
> +
> +=09return 0;
> +
> +unlock_fail:
> +=09mutex_unlock(&kvm->slots_lock);
> +=09kfree(p);
> +fail:
> +=09fput(rfile);
> +=09fput(wfile);
> +
> +=09return ret;
> +}
> +
> +static int
> +kvm_rm_ioregion(struct kvm *kvm, struct kvm_ioregion *args)
> +{
> +=09struct ioregion         *p, *tmp;
> +=09enum kvm_bus             bus_idx;
> +=09int                      ret =3D -ENOENT;
> +=09struct list_head        *ioregions;
> +
> +=09if (args->rfd !=3D -1 || args->wfd !=3D -1)
> +=09=09return -EINVAL;
> +
> +=09bus_idx =3D get_bus_from_flags(args->flags);
> +=09ioregions =3D get_ioregion_list(kvm, bus_idx);
> +
> +=09mutex_lock(&kvm->slots_lock);
> +
> +=09list_for_each_entry_safe(p, tmp, ioregions, list) {
> +=09=09if (p->paddr =3D=3D args->guest_paddr  &&
> +=09=09    p->size =3D=3D args->memory_size) {
> +=09=09=09kvm_io_bus_unregister_dev(kvm, bus_idx, &p->dev);
> +=09=09=09ioregion_release(p);
> +=09=09=09ret =3D 0;
> +=09=09=09break;
> +=09=09}
> +=09}
> +
> +=09mutex_unlock(&kvm->slots_lock);
> +
> +=09return ret;
> +}
> +
> +int
> +kvm_ioregionfd(struct kvm *kvm, struct kvm_ioregion *args)
> +{

The following check can be done here to make sure the ioctl always
returns EINVAL if unsupported flags are passed:

  if (args->flags & ~KVM_IOREGION_VALID_FLAG_MASK)
  =09return -EINVAL;

(It's currently missing in kvm_rm_ioregion().)

> +=09if (args->rfd =3D=3D -1 || args->wfd =3D=3D -1)
> +=09=09return kvm_rm_ioregion(kvm, args);
> +=09return kvm_set_ioregion(kvm, args);
> +}
> diff --git a/virt/kvm/ioregion.h b/virt/kvm/ioregion.h
> new file mode 100644
> index 000000000000..23ffa812ec7a
> --- /dev/null
> +++ b/virt/kvm/ioregion.h
> @@ -0,0 +1,15 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef __KVM_IOREGION_H__
> +#define __KVM_IOREGION_H__
> +
> +#ifdef CONFIG_KVM_IOREGION
> +inline bool overlap(u64 start1, u64 size1, u64 start2, u64 size2);
> +bool kvm_ioregion_collides(struct kvm *kvm, int bus_idx, u64 start, u64 =
size);
> +#else
> +static inline bool
> +kvm_ioregion_collides(struct kvm *kvm, int bus_idx, u64 start, u64 size)
> +{
> +=09return false;
> +}
> +#endif
> +#endif
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2541a17ff1c4..385d8ec6350d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -747,6 +747,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  =09mmgrab(current->mm);
>  =09kvm->mm =3D current->mm;
>  =09kvm_eventfd_init(kvm);
> +=09kvm_ioregionfd_init(kvm);
>  =09mutex_init(&kvm->lock);
>  =09mutex_init(&kvm->irq_lock);
>  =09mutex_init(&kvm->slots_lock);
> @@ -3708,6 +3709,16 @@ static long kvm_vm_ioctl(struct file *filp,
>  =09=09r =3D kvm_vm_ioctl_set_memory_region(kvm, &kvm_userspace_mem);
>  =09=09break;
>  =09}
> +=09case KVM_SET_IOREGION: {
> +=09=09struct kvm_ioregion data;
> +
> +=09=09r =3D -EFAULT;
> +=09=09if (copy_from_user(&data, argp, sizeof(data)))
> +=09=09=09goto out;
> +
> +=09=09r =3D kvm_ioregionfd(kvm, &data);
> +=09=09break;
> +=09}
>  =09case KVM_GET_DIRTY_LOG: {
>  =09=09struct kvm_dirty_log log;
> =20
> @@ -4301,9 +4312,12 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum =
kvm_bus bus_idx, gpa_t addr,
>  =09if (!bus)
>  =09=09return -ENOMEM;
> =20
> -=09/* exclude ioeventfd which is limited by maximum fd */
> -=09if (bus->dev_count - bus->ioeventfd_count > NR_IOBUS_DEVS - 1)
> -=09=09return -ENOSPC;
> +=09/* enforce hard limit if kmemcg is disabled and
> +=09 * exclude ioeventfd which is limited by maximum fd
> +=09 */
> +=09if (!memcg_kmem_enabled())
> +=09=09if (bus->dev_count - bus->ioeventfd_count > NR_IOBUS_DEVS - 1)
> +=09=09=09return -ENOSPC;
> =20
>  =09new_bus =3D kmalloc(struct_size(bus, range, bus->dev_count + 1),
>  =09=09=09  GFP_KERNEL_ACCOUNT);

Please move this change to a separate patch.

--tjCHc7DPkfUGtrlw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/rFLkACgkQnKSrs4Gr
c8hKZQf/eddD9nSb6H2WfWwr7TmGEkvyR7WuHHq7gktiamizlZdaxos7EM/1j6vc
LFwWG/lpWJk+hMluACM6QY8kRxFfjPOyMoVmh387sgTbbrdrd5JFeTK71Bs2qop8
ltVPT3ITMbn5XSgDPuN6If2N2jeodR6QUqH0XLNqGPy41Vu5zDlm+3bFV2g+AjiW
Md6jR24xguzulqwOXFeaXQgJpP/YpDIVsOfBQp3wLpJ8qYN7aaymvIg40xyTvKK2
JcuRTD5rVYL3JjGE4x8W9PLP3qm0d27qYO+RR5TmOnOiNzCVsORJtikl+cZcO601
+bc310vUV1YH1DG/owuQOcfLkIJLcQ==
=/kBy
-----END PGP SIGNATURE-----

--tjCHc7DPkfUGtrlw--

