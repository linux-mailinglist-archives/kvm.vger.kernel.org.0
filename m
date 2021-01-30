Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83AE03096FC
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 18:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhA3RAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 12:00:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38056 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229851AbhA3RAf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 30 Jan 2021 12:00:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612025947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ff3uW0OQOdof4v0/LGeTTqD7WmLrOvPdVpmGtc8EjAc=;
        b=KYp1aOE+sbcvHgMy0wnxdpTHySQoEjIckttjG4NowDn7Bophcd6ilDcCk+TLTo+u0otsAS
        2iKdkYr1N+9yNhQppfuhdayzR9Mc260KyEkgZ2nkNfyUIKqbR2X9FnxVZHoIEOmK/MDqKk
        9ZloH2QPYLT7WBWcGKPeTKOeUeLAHBg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-knMRBZSIMXG_YYwI_2OEjA-1; Sat, 30 Jan 2021 11:59:03 -0500
X-MC-Unique: knMRBZSIMXG_YYwI_2OEjA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C43A2800D53;
        Sat, 30 Jan 2021 16:59:01 +0000 (UTC)
Received: from localhost (ovpn-112-96.ams2.redhat.com [10.36.112.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A07B5C1BD;
        Sat, 30 Jan 2021 16:59:00 +0000 (UTC)
Date:   Sat, 30 Jan 2021 16:58:59 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Elena Afanasova <eafanasova@gmail.com>
Cc:     kvm@vger.kernel.org, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com
Subject: Re: [RFC v2 2/4] KVM: x86: add support for ioregionfd signal handling
Message-ID: <20210130165859.GC98016@stefanha-x1.localdomain>
References: <cover.1611850290.git.eafanasova@gmail.com>
 <aa049c6e5bade3565c5ffa820bbbb67bd5d1bf4b.1611850291.git.eafanasova@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Y5rl02BVI9TCfPar"
Content-Disposition: inline
In-Reply-To: <aa049c6e5bade3565c5ffa820bbbb67bd5d1bf4b.1611850291.git.eafanasova@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Y5rl02BVI9TCfPar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 28, 2021 at 09:32:21PM +0300, Elena Afanasova wrote:
> The vCPU thread may receive a signal during ioregionfd communication,
> ioctl(KVM_RUN) needs to return to userspace and then ioctl(KVM_RUN)
> must resume ioregionfd.
>=20
> Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
> ---
> Changes in v2:
>   - add support for x86 signal handling
>   - changes after code review
>=20
>  arch/x86/kvm/x86.c            | 196 +++++++++++++++++++++++++++++++---
>  include/linux/kvm_host.h      |  13 +++
>  include/uapi/linux/ioregion.h |  32 ++++++
>  virt/kvm/ioregion.c           | 177 +++++++++++++++++++++++++++++-
>  virt/kvm/kvm_main.c           |  16 ++-
>  5 files changed, 415 insertions(+), 19 deletions(-)
>  create mode 100644 include/uapi/linux/ioregion.h
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ddb28f5ca252..a04516b531da 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5799,19 +5799,33 @@ static int vcpu_mmio_write(struct kvm_vcpu *vcpu,=
 gpa_t addr, int len,
>  {
>  	int handled =3D 0;
>  	int n;
> +	int ret =3D 0;
> +	bool is_apic;
> =20
>  	do {
>  		n =3D min(len, 8);
> -		if (!(lapic_in_kernel(vcpu) &&
> -		      !kvm_iodevice_write(vcpu, &vcpu->arch.apic->dev, addr, n, v))
> -		    && kvm_io_bus_write(vcpu, KVM_MMIO_BUS, addr, n, v))
> -			break;
> +		is_apic =3D lapic_in_kernel(vcpu) &&
> +			  !kvm_iodevice_write(vcpu, &vcpu->arch.apic->dev,
> +					      addr, n, v);
> +		if (!is_apic) {
> +			ret =3D kvm_io_bus_write(vcpu, KVM_MMIO_BUS,
> +					       addr, n, v);
> +			if (ret)
> +				break;
> +		}
>  		handled +=3D n;
>  		addr +=3D n;
>  		len -=3D n;
>  		v +=3D n;
>  	} while (len);
> =20
> +#ifdef CONFIG_KVM_IOREGION
> +	if (ret =3D=3D -EINTR) {
> +		vcpu->run->exit_reason =3D KVM_EXIT_INTR;
> +		++vcpu->stat.signal_exits;
> +	}
> +#endif
> +
>  	return handled;
>  }

There is a special case for crossing page boundaries:
1. ioregion in the first 4 bytes (page 1) but not the second 4 bytes (page =
2).
2. ioregion in the second 4 bytes (page 2) but not the first 4 bytes (page =
1).
3. The first 4 bytes (page 1) in one ioregion and the second 4 bytes (page =
2) in another ioregion.
4. The first 4 bytes (page 1) in one ioregion and the second 4 bytes (page =
2) in the same ioregion.

Cases 3 and 4 are tricky. If I'm reading the code correctly we try
ioregion accesses twice, even if the first one returns -EINTR?

> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 7cd667dddba9..5cfdecfca6db 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -318,6 +318,19 @@ struct kvm_vcpu {
>  #endif
>  	bool preempted;
>  	bool ready;
> +#ifdef CONFIG_KVM_IOREGION
> +	bool ioregion_interrupted;

Can this field move into ioregion_ctx?

> +	struct {
> +		struct kvm_io_device *dev;
> +		int pio;
> +		void *val;
> +		u8 state;
> +		u64 addr;
> +		int len;
> +		u64 data;
> +		bool in;
> +	} ioregion_ctx;

This struct can be reordered to remove holes between fields.

> +#endif
>  	struct kvm_vcpu_arch arch;
>  };
> =20
> diff --git a/include/uapi/linux/ioregion.h b/include/uapi/linux/ioregion.h
> new file mode 100644
> index 000000000000..7898c01f84a1
> --- /dev/null
> +++ b/include/uapi/linux/ioregion.h
> @@ -0,0 +1,32 @@
> +/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */

To encourage people to implement the wire protocol even beyond the Linux
syscall environment (e.g. in other hypervisors and VMMs) you could make
the license more permissive:

  /* SPDX-License-Identifier: ((GPL-2.0-only WITH Linux-syscall-note) OR BS=
D-3-Clause) */

Several other <linux/*.h> files do this so that the header can be used
outside Linux without license concerns.

Here is the BSD 3-Clause license:
https://opensource.org/licenses/BSD-3-Clause

> +#ifndef _UAPI_LINUX_IOREGION_H
> +#define _UAPI_LINUX_IOREGION_H

Please add the wire protocol specification/documentation into this file.
That way this header file will serve as a comprehensive reference for
the protocol and changes to the header will also update the
documentation.

(The ioctl KVM_SET_IOREGIONFD parts belong in
Documentation/virt/kvm/api.rst but the wire protocol should be in this
header file instead.)

> +
> +/* Wire protocol */
> +struct ioregionfd_cmd {
> +	__u32 info;
> +	__u32 padding;
> +	__u64 user_data;
> +	__u64 offset;
> +	__u64 data;
> +};
> +
> +struct ioregionfd_resp {
> +	__u64 data;
> +	__u8 pad[24];
> +};
> +
> +#define IOREGIONFD_CMD_READ    0
> +#define IOREGIONFD_CMD_WRITE   1
> +
> +#define IOREGIONFD_SIZE_8BIT   0
> +#define IOREGIONFD_SIZE_16BIT  1
> +#define IOREGIONFD_SIZE_32BIT  2
> +#define IOREGIONFD_SIZE_64BIT  3

It's possible that larger read/write operations will be needed in the
future. For example, the PCI Express bus supports much larger
transactions than just 64 bits.

You don't need to address this right now but I wanted to mention it.

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 88b92fc3da51..df387857f51f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4193,6 +4193,7 @@ static int __kvm_io_bus_write(struct kvm_vcpu *vcpu=
, struct kvm_io_bus *bus,
>  			      struct kvm_io_range *range, const void *val)
>  {
>  	int idx;
> +	int ret =3D 0;
> =20
>  	idx =3D kvm_io_bus_get_first_dev(bus, range->addr, range->len);
>  	if (idx < 0)
> @@ -4200,9 +4201,12 @@ static int __kvm_io_bus_write(struct kvm_vcpu *vcp=
u, struct kvm_io_bus *bus,
> =20
>  	while (idx < bus->dev_count &&
>  		kvm_io_bus_cmp(range, &bus->range[idx]) =3D=3D 0) {
> -		if (!kvm_iodevice_write(vcpu, bus->range[idx].dev, range->addr,
> -					range->len, val))
> +		ret =3D kvm_iodevice_write(vcpu, bus->range[idx].dev, range->addr,
> +					 range->len, val);
> +		if (!ret)
>  			return idx;
> +		if (ret < 0 && ret !=3D -EOPNOTSUPP)
> +			return ret;

I audited all kvm_io_bus_read/write() callers to check that it's safe to
add error return values besides -EOPNOTSUPP. Extending the meaning of
the return value is fine but any arches that want to support ioregionfd
need to explicitly handle -EINTR return values now. Only x86 does after
this patch.

--Y5rl02BVI9TCfPar
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAVkFMACgkQnKSrs4Gr
c8hs3QgAr7Thy+FO9FRs6Go3bnZsFouORvrsLmKn/MK2ZCdJfNkwcNDMO5l1HroN
ILzf8DBYp7GLXT6VWc3ltaZSvd229gBwwaasnpckdn1MrFM8B9YgJhFuurDDielw
FobQFwvXQzhxsTcY3SHK3FtkQWsTf1+Jug87FjwArelnUwbr3XBz8vsUFEjCijsR
SAgKykL2YNyXYaStLKKyqENlxOeSHZgiw3YP76jMoU4rdQgMuUzb+dwqex+b+KLG
zB8rvhoYgItavJEGSHCUH62T9ic1n2aZA6BJ4RPhibyP41cbG9Um+qNrnZawzk5V
f4rY94iUsYFtwNtVf3Q3ph1lL0cx0A==
=Tbva
-----END PGP SIGNATURE-----

--Y5rl02BVI9TCfPar--

