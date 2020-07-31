Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97468233CC8
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 03:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731076AbgGaBKC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 21:10:02 -0400
Received: from ozlabs.org ([203.11.71.1]:57877 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730983AbgGaBKB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 21:10:01 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4BHq2H1gFJz9sT6; Fri, 31 Jul 2020 11:09:59 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1596157799;
        bh=7VgGDwT3OKlgn9JXnGBkda/dZYFxw64xeUpfKeok+eo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EByECIduzBXugaJMgcKRMtdLJNKtwKFFO5SIDfNS9K+kWEXTUSC5Qkjv54KwSRYiO
         WibygjXUHqv6IpwUBbZCEBUgWpR7tl9PzOb0UUIaMG+ZUF5UKrzq1fjRo5k3yVvfJZ
         NONtXodpgcWsbvSdxDhn1f8pd1iwgBqQiJqJCjwU=
Date:   Fri, 31 Jul 2020 10:10:14 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Stefano Garzarella <sgarzare@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Max Reitz <mreitz@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        qemu-block@nongnu.org, qemu-ppc@nongnu.org,
        Kaige Li <likaige@loongson.cn>, Kevin Wolf <kwolf@redhat.com>,
        kvm@vger.kernel.org, Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Bruce Rogers <brogers@suse.com>
Subject: Re: [PATCH-for-5.1? v2 2/2] util/pagesize: Make
 qemu_real_host_page_size of type size_t
Message-ID: <20200731001014.GB12398@yekko.fritz.box>
References: <20200730141245.21739-1-philmd@redhat.com>
 <20200730141245.21739-3-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gj572EiMnwbLXET9"
Content-Disposition: inline
In-Reply-To: <20200730141245.21739-3-philmd@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--gj572EiMnwbLXET9
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2020 at 04:12:45PM +0200, Philippe Mathieu-Daud=C3=A9 wrote:
> We use different types to hold 'qemu_real_host_page_size'.
> Unify picking 'size_t' which seems the best candidate.
>=20
> Doing so fix a format string issue in hw/virtio/virtio-mem.c
> reported when building with GCC 4.9.4:
>=20
>   hw/virtio/virtio-mem.c: In function =E2=80=98virtio_mem_set_block_size=
=E2=80=99:
>   hw/virtio/virtio-mem.c:756:9: error: format =E2=80=98%x=E2=80=99 expect=
s argument of type =E2=80=98unsigned int=E2=80=99, but argument 7 has type =
=E2=80=98uintptr_t=E2=80=99 [-Werror=3Dformat=3D]
>          error_setg(errp, "'%s' property has to be at least 0x%" PRIx32, =
name,
>          ^
>=20
> Fixes: 910b25766b ("virtio-mem: Paravirtualized memory hot(un)plug")
> Reported-by: Bruce Rogers <brogers@suse.com>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>

Reviewed-by: David Gibson <david@gibson.dropbear.id.au>

and ppc parts
Acked-by: David Gibson <david@gibson.dropbear.id.au>

> ---
>  include/exec/ram_addr.h  | 4 ++--
>  include/qemu/osdep.h     | 2 +-
>  accel/kvm/kvm-all.c      | 3 ++-
>  block/qcow2-cache.c      | 2 +-
>  exec.c                   | 8 ++++----
>  hw/ppc/spapr_pci.c       | 2 +-
>  hw/virtio/virtio-mem.c   | 2 +-
>  migration/migration.c    | 2 +-
>  migration/postcopy-ram.c | 2 +-
>  monitor/misc.c           | 2 +-
>  util/pagesize.c          | 2 +-
>  11 files changed, 16 insertions(+), 15 deletions(-)
>=20
> diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
> index 3ef729a23c..e07532266e 100644
> --- a/include/exec/ram_addr.h
> +++ b/include/exec/ram_addr.h
> @@ -93,8 +93,8 @@ static inline unsigned long int ramblock_recv_bitmap_of=
fset(void *host_addr,
> =20
>  bool ramblock_is_pmem(RAMBlock *rb);
> =20
> -long qemu_minrampagesize(void);
> -long qemu_maxrampagesize(void);
> +size_t qemu_minrampagesize(void);
> +size_t qemu_maxrampagesize(void);
> =20
>  /**
>   * qemu_ram_alloc_from_file,
> diff --git a/include/qemu/osdep.h b/include/qemu/osdep.h
> index 085df8d508..77115a8270 100644
> --- a/include/qemu/osdep.h
> +++ b/include/qemu/osdep.h
> @@ -635,10 +635,10 @@ char *qemu_get_pid_name(pid_t pid);
>   */
>  pid_t qemu_fork(Error **errp);
> =20
> +extern size_t qemu_real_host_page_size;
>  /* Using intptr_t ensures that qemu_*_page_mask is sign-extended even
>   * when intptr_t is 32-bit and we are aligning a long long.
>   */
> -extern uintptr_t qemu_real_host_page_size;
>  extern intptr_t qemu_real_host_page_mask;
> =20
>  extern int qemu_icache_linesize;
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 63ef6af9a1..59becfbd6c 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -674,7 +674,8 @@ static int kvm_log_clear_one_slot(KVMSlot *mem, int a=
s_id, uint64_t start,
>      KVMState *s =3D kvm_state;
>      uint64_t end, bmap_start, start_delta, bmap_npages;
>      struct kvm_clear_dirty_log d;
> -    unsigned long *bmap_clear =3D NULL, psize =3D qemu_real_host_page_si=
ze;
> +    unsigned long *bmap_clear =3D NULL;
> +    size_t psize =3D qemu_real_host_page_size;
>      int ret;
> =20
>      /*
> diff --git a/block/qcow2-cache.c b/block/qcow2-cache.c
> index 7444b9c4ab..4ad9f5929f 100644
> --- a/block/qcow2-cache.c
> +++ b/block/qcow2-cache.c
> @@ -74,7 +74,7 @@ static void qcow2_cache_table_release(Qcow2Cache *c, in=
t i, int num_tables)
>  /* Using MADV_DONTNEED to discard memory is a Linux-specific feature */
>  #ifdef CONFIG_LINUX
>      void *t =3D qcow2_cache_get_table_addr(c, i);
> -    int align =3D qemu_real_host_page_size;
> +    size_t align =3D qemu_real_host_page_size;
>      size_t mem_size =3D (size_t) c->table_size * num_tables;
>      size_t offset =3D QEMU_ALIGN_UP((uintptr_t) t, align) - (uintptr_t) =
t;
>      size_t length =3D QEMU_ALIGN_DOWN(mem_size - offset, align);
> diff --git a/exec.c b/exec.c
> index 6f381f98e2..4b6d52e01f 100644
> --- a/exec.c
> +++ b/exec.c
> @@ -1657,7 +1657,7 @@ static int find_max_backend_pagesize(Object *obj, v=
oid *opaque)
>   * TODO: We assume right now that all mapped host memory backends are
>   * used as RAM, however some might be used for different purposes.
>   */
> -long qemu_minrampagesize(void)
> +size_t qemu_minrampagesize(void)
>  {
>      long hpsize =3D LONG_MAX;
>      Object *memdev_root =3D object_resolve_path("/objects", NULL);
> @@ -1666,7 +1666,7 @@ long qemu_minrampagesize(void)
>      return hpsize;
>  }
> =20
> -long qemu_maxrampagesize(void)
> +size_t qemu_maxrampagesize(void)
>  {
>      long pagesize =3D 0;
>      Object *memdev_root =3D object_resolve_path("/objects", NULL);
> @@ -1675,11 +1675,11 @@ long qemu_maxrampagesize(void)
>      return pagesize;
>  }
>  #else
> -long qemu_minrampagesize(void)
> +size_t qemu_minrampagesize(void)
>  {
>      return qemu_real_host_page_size;
>  }
> -long qemu_maxrampagesize(void)
> +size_t qemu_maxrampagesize(void)
>  {
>      return qemu_real_host_page_size;
>  }
> diff --git a/hw/ppc/spapr_pci.c b/hw/ppc/spapr_pci.c
> index 363cdb3f7b..a9da84fe30 100644
> --- a/hw/ppc/spapr_pci.c
> +++ b/hw/ppc/spapr_pci.c
> @@ -1810,7 +1810,7 @@ static void spapr_phb_realize(DeviceState *dev, Err=
or **errp)
>      char *namebuf;
>      int i;
>      PCIBus *bus;
> -    uint64_t msi_window_size =3D 4096;
> +    size_t msi_window_size =3D 4096;
>      SpaprTceTable *tcet;
>      const unsigned windows_supported =3D spapr_phb_windows_supported(sph=
b);
>      Error *local_err =3D NULL;
> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
> index c12e9f79b0..34344cec39 100644
> --- a/hw/virtio/virtio-mem.c
> +++ b/hw/virtio/virtio-mem.c
> @@ -753,7 +753,7 @@ static void virtio_mem_set_block_size(Object *obj, Vi=
sitor *v, const char *name,
>      }
> =20
>      if (value < VIRTIO_MEM_MIN_BLOCK_SIZE) {
> -        error_setg(errp, "'%s' property has to be at least 0x%" PRIx32, =
name,
> +        error_setg(errp, "'%s' property has to be at least 0x%zx", name,
>                     VIRTIO_MEM_MIN_BLOCK_SIZE);
>          return;
>      } else if (!is_power_of_2(value)) {
> diff --git a/migration/migration.c b/migration/migration.c
> index 8fe36339db..b8abbbeabb 100644
> --- a/migration/migration.c
> +++ b/migration/migration.c
> @@ -2433,7 +2433,7 @@ static struct rp_cmd_args {
>  static void migrate_handle_rp_req_pages(MigrationState *ms, const char* =
rbname,
>                                         ram_addr_t start, size_t len)
>  {
> -    long our_host_ps =3D qemu_real_host_page_size;
> +    size_t our_host_ps =3D qemu_real_host_page_size;
> =20
>      trace_migrate_handle_rp_req_pages(rbname, start, len);
> =20
> diff --git a/migration/postcopy-ram.c b/migration/postcopy-ram.c
> index 1bb22f2b6c..f296efd612 100644
> --- a/migration/postcopy-ram.c
> +++ b/migration/postcopy-ram.c
> @@ -345,7 +345,7 @@ static int test_ramblock_postcopiable(RAMBlock *rb, v=
oid *opaque)
>   */
>  bool postcopy_ram_supported_by_host(MigrationIncomingState *mis)
>  {
> -    long pagesize =3D qemu_real_host_page_size;
> +    size_t pagesize =3D qemu_real_host_page_size;
>      int ufd =3D -1;
>      bool ret =3D false; /* Error unless we change it */
>      void *testarea =3D NULL;
> diff --git a/monitor/misc.c b/monitor/misc.c
> index e847b58a8c..7970f4ff72 100644
> --- a/monitor/misc.c
> +++ b/monitor/misc.c
> @@ -740,7 +740,7 @@ static uint64_t vtop(void *ptr, Error **errp)
>      uint64_t pinfo;
>      uint64_t ret =3D -1;
>      uintptr_t addr =3D (uintptr_t) ptr;
> -    uintptr_t pagesize =3D qemu_real_host_page_size;
> +    size_t pagesize =3D qemu_real_host_page_size;
>      off_t offset =3D addr / pagesize * sizeof(pinfo);
>      int fd;
> =20
> diff --git a/util/pagesize.c b/util/pagesize.c
> index 998632cf6e..a08bf1717a 100644
> --- a/util/pagesize.c
> +++ b/util/pagesize.c
> @@ -8,7 +8,7 @@
> =20
>  #include "qemu/osdep.h"
> =20
> -uintptr_t qemu_real_host_page_size;
> +size_t qemu_real_host_page_size;
>  intptr_t qemu_real_host_page_mask;
> =20
>  static void __attribute__((constructor)) init_real_host_page_size(void)

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--gj572EiMnwbLXET9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl8jYWYACgkQbDjKyiDZ
s5LKLBAArH9YridmfjEUqaRgn+kQwXgBXk0ROEZjvHeOfAh8ndmGIYSq/oMS7kEF
hogP9k5fnqmsCWa43TmMpr/QuxFkyJsI1eevuta8eML3OO3KEk+0LgDGJXaXm0t1
ltL6rbyLduawWrvZFDOIMJLpRVD5k4EeXpkHWbicQUyKSHXp+/ZKK132t+KqgXJF
iZL/bFhPevRtbCIYc8uPBtCy4Ymq0iYJyLBZgii7leXD8mbBafquCWAhkcTR45GC
NpKTTuYWqgbD+09P3h6kbQMFMiV4sHDioT7WXlA5QTiBjrOSnGq9Evif/3e0WbGk
wfQRSwWgL17Hem3lwvS405Jh3DuDpxtooq01P6rCtpI01dKx/PS6MOdnootJ40Ga
jriZ8oRxk4Su62RX7DzwnVOiU9LLLgZSV5uEP9wU6xHjnPVYz1AwjnSRJt8t2S/v
Jv7fgGbP5BJaLEhWEsAHLXD6bsDGnBw2V04kecWvAtCUb3uTRBWQ5+B6Pmpx0joU
VqlZAFpAgGXnixdeSxYWFSFJmW6Y8xui9CfaD1B16ZYkmTV7u1SpVyCV33o2/HP1
c4Bn1mqEDJUnP90t9VjsrOefPpSaiKor8XhTbF4cdmsaKgNb0fZOfKVbSdkWLGxz
RIsylLCNMOj0wCuaj3RvKwBuz5YvolDl0Hk2jZnAyZ3iX1UIWtM=
=sz58
-----END PGP SIGNATURE-----

--gj572EiMnwbLXET9--
