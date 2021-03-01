Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC44432895E
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 18:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbhCARzr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 12:55:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39244 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237836AbhCARth (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Mar 2021 12:49:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614620876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8PS1UBHm7kdpG76VmouLZO2eri439g/lUh+CW0ZVORI=;
        b=foCmOLTqgZqTsBtrckfCk44AZHvMGGAZ7VCSRjrBzUDYfv0ZFLTY5m+dN8KXsDjZVAk2Wi
        UyfxAK4emZca0tcPoigydBIXqZ/xDoKpwjMkLh2cCaZ7hs/Lfj6hZtKJC+IBeMmgMAkpSP
        nqts7WEsZQ8qRNcTSWUGRKJyOmOtgmg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-ErL2pmFWNCubwJ7hWFD4WA-1; Mon, 01 Mar 2021 12:47:50 -0500
X-MC-Unique: ErL2pmFWNCubwJ7hWFD4WA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A707186840D;
        Mon,  1 Mar 2021 17:47:49 +0000 (UTC)
Received: from localhost (ovpn-115-54.ams2.redhat.com [10.36.115.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E08215D6CF;
        Mon,  1 Mar 2021 17:47:48 +0000 (UTC)
Date:   Mon, 1 Mar 2021 17:47:41 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Elena Afanasova <eafanasova@gmail.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com
Subject: Re: [PATCH RFC] hw/misc/pc-testdev: add support for ioregionfd
 testing
Message-ID: <YD0ovavIuThCSS5J@stefanha-x1.localdomain>
References: <20210301131628.5211-1-eafanasova@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Zele8yAvao3CFGfa"
Content-Disposition: inline
In-Reply-To: <20210301131628.5211-1-eafanasova@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Zele8yAvao3CFGfa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 01, 2021 at 04:16:28PM +0300, Elena Afanasova wrote:

Thanks for posting this piece of the ioregionfd testing infrastructure!

Please include a commit description even if it's just an RFC patch.
People on qemu-devel may not be aware of ioregionfd or the purpose of
this patch.

Something like:

  Add ioregionfd support to pc-testdev for use with kvm-unit-tests that
  exercise the new KVM ioregionfd API. ioregionfd is a new MMIO/PIO
  dispatch mechanism for KVM. The kernel patches implementing ioregionfd
  are available here:

    https://patchwork.kernel.org/project/kvm/list/?series=3D436083

  The kvm-unit-test will create one read FIFO and one write FIFO and
  then invoke QEMU like this:

    --device pc-testdev,addr=3D0x100000000,size=3D4096,rfifo=3Dpath/to/rfif=
o,wfifo=3Dpath/to/wfifo

  QEMU does not actually process the read FIFO or write FIFO. It simply
  registers an ioregionfd with KVM. From then on KVM will communicate
  directly with the kvm-unit-test via the read FIFO and write FIFO that
  were provided. This allows test cases to handle MMIO/PIO accesses.

Elena and I discussed the long-term QEMU API for ioregionfd on IRC.
Eventually this test device could use it instead of directly calling
kvm_vm_ioctl(). The new QEMU API would be
memory_region_set_aio_context(AioContext *aio_context).

When ioregionfd is available an ioregion would be registered with KVM
and AioContext will have a read fd to handle MMIO/PIO accesses for any
of its ioregions. This way device emulation can run outside the vcpu
thread.

When ioregionfd is not available QEMU can emulate it by writing a struct
ioregionfd_cmd to the write fd from the vcpu thread. The relevant
AioContext will handle the read fd as normal and dispatch the MMIO/PIO
access to the MemoryRegion.

> Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
> ---
>  hw/misc/pc-testdev.c      | 74 +++++++++++++++++++++++++++++++++++++++
>  include/sysemu/kvm.h      |  4 +--
>  linux-headers/linux/kvm.h | 24 +++++++++++++
>  3 files changed, 100 insertions(+), 2 deletions(-)
>=20
> diff --git a/hw/misc/pc-testdev.c b/hw/misc/pc-testdev.c
> index e389651869..38355923ca 100644
> --- a/hw/misc/pc-testdev.c
> +++ b/hw/misc/pc-testdev.c
> @@ -40,6 +40,9 @@
>  #include "hw/irq.h"
>  #include "hw/isa/isa.h"
>  #include "qom/object.h"
> +#include "sysemu/kvm.h"
> +#include <linux/kvm.h>
> +#include "hw/qdev-properties.h"
> =20
>  #define IOMEM_LEN    0x10000
> =20
> @@ -53,6 +56,15 @@ struct PCTestdev {
>      MemoryRegion iomem;
>      uint32_t ioport_data;
>      char iomem_buf[IOMEM_LEN];
> +
> +    uint64_t guest_paddr;
> +    uint64_t memory_size;
> +    char *read_fifo;
> +    char *write_fifo;
> +    bool posted_writes;
> +    bool pio;
> +    int rfd;
> +    int wfd;
>  };
> =20
>  #define TYPE_TESTDEV "pc-testdev"
> @@ -169,6 +181,9 @@ static const MemoryRegionOps test_iomem_ops =3D {
> =20
>  static void testdev_realizefn(DeviceState *d, Error **errp)
>  {
> +    struct kvm_ioregion ioreg;

Zero this so that user_data is always 0 instead of undefined data from
the stack?

> +    int flags =3D 0;
> +
>      ISADevice *isa =3D ISA_DEVICE(d);
>      PCTestdev *dev =3D TESTDEV(d);
>      MemoryRegion *mem =3D isa_address_space(isa);
> @@ -191,14 +206,73 @@ static void testdev_realizefn(DeviceState *d, Error=
 **errp)
>      memory_region_add_subregion(io,  0xe8,       &dev->ioport_byte);
>      memory_region_add_subregion(io,  0x2000,     &dev->irq);
>      memory_region_add_subregion(mem, 0xff000000, &dev->iomem);
> +
> +    if (!dev->guest_paddr || !dev->write_fifo) {
> +        return;
> +    }
> +
> +    dev->wfd =3D open(dev->write_fifo, O_WRONLY);
> +    if (dev->wfd < 0) {
> +        error_report("failed to open write fifo %s", dev->write_fifo);
> +        return;
> +    }
> +
> +    if (dev->read_fifo) {
> +        dev->rfd =3D open(dev->read_fifo, O_RDONLY);
> +        if (dev->rfd < 0) {
> +            error_report("failed to open read fifo %s", dev->read_fifo);
> +            close(dev->wfd);
> +            return;
> +        }
> +    }
> +
> +    flags |=3D dev->pio ? KVM_IOREGION_PIO : 0;
> +    flags |=3D dev->posted_writes ? KVM_IOREGION_POSTED_WRITES : 0;
> +    ioreg.guest_paddr =3D dev->guest_paddr;
> +    ioreg.memory_size =3D dev->memory_size;
> +    ioreg.write_fd =3D dev->wfd;
> +    ioreg.read_fd =3D dev->rfd;
> +    ioreg.flags =3D flags;
> +    kvm_vm_ioctl(kvm_state, KVM_SET_IOREGION, &ioreg);

Printing an error message would be useful when this fails (e.g. when the
region overlaps with an existing ioeventfd/ioregionfd).=20

> +}
> +
> +static void testdev_unrealizefn(DeviceState *d)
> +{
> +    struct kvm_ioregion ioreg;
> +    PCTestdev *dev =3D TESTDEV(d);
> +
> +    if (!dev->guest_paddr || !dev->write_fifo) {
> +        return;
> +    }
> +
> +    ioreg.guest_paddr =3D dev->guest_paddr;
> +    ioreg.memory_size =3D dev->memory_size;
> +    ioreg.flags =3D KVM_IOREGION_DEASSIGN;
> +    kvm_vm_ioctl(kvm_state, KVM_SET_IOREGION, &ioreg);
> +    close(dev->wfd);
> +    if (dev->rfd > 0) {
> +        close(dev->rfd);
> +    }
>  }
> =20
> +static Property ioregionfd_properties[] =3D {
> +    DEFINE_PROP_UINT64("addr", PCTestdev, guest_paddr, 0),
> +    DEFINE_PROP_UINT64("size", PCTestdev, memory_size, 0),
> +    DEFINE_PROP_STRING("rfifo", PCTestdev, read_fifo),
> +    DEFINE_PROP_STRING("wfifo", PCTestdev, write_fifo),
> +    DEFINE_PROP_BOOL("pio", PCTestdev, pio, false),
> +    DEFINE_PROP_BOOL("pw", PCTestdev, posted_writes, false),
> +    DEFINE_PROP_END_OF_LIST(),
> +};
> +
>  static void testdev_class_init(ObjectClass *klass, void *data)
>  {
>      DeviceClass *dc =3D DEVICE_CLASS(klass);
> =20
>      set_bit(DEVICE_CATEGORY_MISC, dc->categories);
>      dc->realize =3D testdev_realizefn;
> +    dc->unrealize =3D testdev_unrealizefn;
> +    device_class_set_props(dc, ioregionfd_properties);
>  }
> =20
>  static const TypeInfo testdev_info =3D {
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index 687c598be9..d68728764a 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -234,6 +234,8 @@ int kvm_has_intx_set_mask(void);
>  bool kvm_arm_supports_user_irq(void);
> =20
> =20
> +int kvm_vm_ioctl(KVMState *s, int type, ...);
> +
>  #ifdef NEED_CPU_H
>  #include "cpu.h"
> =20
> @@ -257,8 +259,6 @@ void phys_mem_set_alloc(void *(*alloc)(size_t, uint64=
_t *align, bool shared));
> =20
>  int kvm_ioctl(KVMState *s, int type, ...);
> =20
> -int kvm_vm_ioctl(KVMState *s, int type, ...);
> -
>  int kvm_vcpu_ioctl(CPUState *cpu, int type, ...);
> =20
>  /**
> diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
> index 020b62a619..c426fa1e56 100644
> --- a/linux-headers/linux/kvm.h
> +++ b/linux-headers/linux/kvm.h
> @@ -733,6 +733,29 @@ struct kvm_ioeventfd {
>  	__u8  pad[36];
>  };
> =20
> +enum {
> +	kvm_ioregion_flag_nr_pio,
> +	kvm_ioregion_flag_nr_posted_writes,
> +	kvm_ioregion_flag_nr_deassign,
> +	kvm_ioregion_flag_nr_max,
> +};
> +
> +#define KVM_IOREGION_PIO (1 << kvm_ioregion_flag_nr_pio)
> +#define KVM_IOREGION_POSTED_WRITES (1 << kvm_ioregion_flag_nr_posted_wri=
tes)
> +#define KVM_IOREGION_DEASSIGN (1 << kvm_ioregion_flag_nr_deassign)
> +
> +#define KVM_IOREGION_VALID_FLAG_MASK ((1 << kvm_ioregion_flag_nr_max) - =
1)
> +
> +struct kvm_ioregion {
> +	__u64 guest_paddr; /* guest physical address */
> +	__u64 memory_size; /* bytes */
> +	__u64 user_data;
> +	__s32 read_fd;
> +	__s32 write_fd;
> +	__u32 flags;
> +	__u8  pad[28];
> +};
> +
>  #define KVM_X86_DISABLE_EXITS_MWAIT          (1 << 0)
>  #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
>  #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
> @@ -1311,6 +1334,7 @@ struct kvm_vfio_spapr_tce {
>  					struct kvm_userspace_memory_region)
>  #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
>  #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
> +#define KVM_SET_IOREGION          _IOW(KVMIO,  0x49, struct kvm_ioregion)
> =20
>  /* enable ucontrol for s390 */
>  struct kvm_s390_ucas_mapping {
> --=20
> 2.25.1
>=20

--Zele8yAvao3CFGfa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmA9KL0ACgkQnKSrs4Gr
c8i93Af+MWXbS3Km3jjUS7rZtX6TSmAc4cXmI6Ls1rJ2TU3O0FT9PMYi+IeHs1vr
C/dAUSUppo5j/qHll4YJLSoEFe0CHojT2OUmfZD5AFqXhYQ42VFsPQssB+O0Qiec
8NbrWPuwwEnf0UfEt7J47+EkbHlL1NOyh4n+hcey0berimExqhEmRCbYxs2sN9Yy
dEPnKm9wAJWDhTe/Fzce+C9fzkrp28lSa++uMutSSh8cKjlt1du2lAMgGDW35Hdp
lVC8xByKA/R5e87j+dMWV30XB+QVrBDxxkk7VpYLx9TwaNzO1+t4LG6S231jB/1d
+CmEGHAf2mi3f+FNdPXXYFYoJ7tBJQ==
=qGgi
-----END PGP SIGNATURE-----

--Zele8yAvao3CFGfa--

