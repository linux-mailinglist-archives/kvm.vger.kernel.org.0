Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626BE31520E
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 15:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbhBIOvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 09:51:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39422 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232277AbhBIOu5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 09:50:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612882167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IyV+/RZbMd1V4ot+Ujhb1YcPbeTc6ZeVELAjKHBVzjQ=;
        b=ECWro7m6770jWcEYNBrGHV+iKqvAyHx1sbcNfTVIiByJAbdPbDuifLUnR1xCV6Hii1znZK
        YGAfjpi5Fj48QmBXbFa1guWCV2yANAoeSYweNvlJK1frG4WXGXX1+XN5i62bsj2CkDHynX
        /szbeqQIInxgBKThTjK4dsmY/3JM854=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-RVdegxXxOpi_2FNdZBP4mA-1; Tue, 09 Feb 2021 09:49:24 -0500
X-MC-Unique: RVdegxXxOpi_2FNdZBP4mA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3EDCB100CCC0;
        Tue,  9 Feb 2021 14:49:23 +0000 (UTC)
Received: from localhost (ovpn-115-93.ams2.redhat.com [10.36.115.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCE7860C04;
        Tue,  9 Feb 2021 14:49:22 +0000 (UTC)
Date:   Tue, 9 Feb 2021 14:49:21 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org,
        jag.raman@oracle.com, elena.ufimtseva@oracle.com
Subject: Re: [RFC v2 2/4] KVM: x86: add support for ioregionfd signal handling
Message-ID: <20210209144921.GA92126@stefanha-x1.localdomain>
References: <cover.1611850290.git.eafanasova@gmail.com>
 <aa049c6e5bade3565c5ffa820bbbb67bd5d1bf4b.1611850291.git.eafanasova@gmail.com>
 <909c71c9-e83e-e6d8-0a33-92dac5b0b5c6@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <909c71c9-e83e-e6d8-0a33-92dac5b0b5c6@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 09, 2021 at 02:21:22PM +0800, Jason Wang wrote:
> On 2021/1/29 =E4=B8=8A=E5=8D=882:32, Elena Afanasova wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index ddb28f5ca252..a04516b531da 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -5799,19 +5799,33 @@ static int vcpu_mmio_write(struct kvm_vcpu *vcp=
u, gpa_t addr, int len,
> >   {
> >   	int handled =3D 0;
> >   	int n;
> > +	int ret =3D 0;
> > +	bool is_apic;
> >   	do {
> >   		n =3D min(len, 8);
> > -		if (!(lapic_in_kernel(vcpu) &&
> > -		      !kvm_iodevice_write(vcpu, &vcpu->arch.apic->dev, addr, n, v))
> > -		    && kvm_io_bus_write(vcpu, KVM_MMIO_BUS, addr, n, v))
> > -			break;
> > +		is_apic =3D lapic_in_kernel(vcpu) &&
> > +			  !kvm_iodevice_write(vcpu, &vcpu->arch.apic->dev,
> > +					      addr, n, v);
>=20
>=20
> A better name is needed since "is_apic" only covers the first condition.

The kvm_iodevice_write() call is specific to vcpu->arch.apic->dev (the
in-kernel APIC device). It's not a generic kvm_io_bus_write() call, so
"is_apic" seems correct to me.

> > @@ -6428,16 +6468,27 @@ static int emulator_pio_in_out(struct kvm_vcpu =
*vcpu, int size,
> >   			       unsigned short port, void *val,
> >   			       unsigned int count, bool in)
> >   {
> > +	int ret =3D 0;
> > +
> >   	vcpu->arch.pio.port =3D port;
> >   	vcpu->arch.pio.in =3D in;
> >   	vcpu->arch.pio.count  =3D count;
> >   	vcpu->arch.pio.size =3D size;
> > -	if (!kernel_pio(vcpu, vcpu->arch.pio_data)) {
> > +	ret =3D kernel_pio(vcpu, vcpu->arch.pio_data);
> > +	if (!ret) {
>=20
>=20
> Unnecessary changes.
[...]
> >   		vcpu->arch.pio.count =3D 0;
> >   		return 1;
> >   	}
> > +#ifdef CONFIG_KVM_IOREGION
> > +	if (ret =3D=3D -EINTR) {
> > +		vcpu->run->exit_reason =3D KVM_EXIT_INTR;
> > +		++vcpu->stat.signal_exits;
> > +		return 0;
> > +	}
> > +#endif

ret is used here. The change above looks necessary to me.

> > diff --git a/include/uapi/linux/ioregion.h b/include/uapi/linux/ioregio=
n.h
> > new file mode 100644
> > index 000000000000..7898c01f84a1
> > --- /dev/null
> > +++ b/include/uapi/linux/ioregion.h
> > @@ -0,0 +1,32 @@
> > +/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
> > +#ifndef _UAPI_LINUX_IOREGION_H
> > +#define _UAPI_LINUX_IOREGION_H
> > +
> > +/* Wire protocol */
> > +struct ioregionfd_cmd {
> > +	__u32 info;
> > +	__u32 padding;
> > +	__u64 user_data;
> > +	__u64 offset;
> > +	__u64 data;
> > +};
> > +
> > +struct ioregionfd_resp {
> > +	__u64 data;
> > +	__u8 pad[24];
> > +};
> > +
> > +#define IOREGIONFD_CMD_READ    0
> > +#define IOREGIONFD_CMD_WRITE   1
> > +
> > +#define IOREGIONFD_SIZE_8BIT   0
> > +#define IOREGIONFD_SIZE_16BIT  1
> > +#define IOREGIONFD_SIZE_32BIT  2
> > +#define IOREGIONFD_SIZE_64BIT  3
> > +
> > +#define IOREGIONFD_SIZE_OFFSET 4
> > +#define IOREGIONFD_RESP_OFFSET 6
> > +#define IOREGIONFD_SIZE(x) ((x) << IOREGIONFD_SIZE_OFFSET)
> > +#define IOREGIONFD_RESP(x) ((x) << IOREGIONFD_RESP_OFFSET)
>=20
>=20
> Instead of using macros, why not explicitly define them in struct
> ioregionfd_cmd instead of using info?

Good idea, these macros are a little confusing. They produce the info
field value but when reading the code quickly one might think they parse
it instead.

I would go all the way and use a union type:

  struct ioregionfd_cmd {
      __u8 cmd;
      union {
          /* IOREGIONFD_CMD_READ */
          struct {
              __u8 size_exponent : 4;
	      __u8 padding[6];
	      __u64 user_data;
	      __u64 offset;
	  } read;

          /* IOREGIONFD_CMD_WRITE */
          struct {
              __u8 size_exponent : 4;
	      __u8 padding[6];
	      __u64 user_data;
	      __u64 offset;
	      __u64 data;
	  } write;

	  __u8 padding[31];
      };
  };

That way we're not restricted to putting data into a single set of
struct fields for all commands. New commands can easily be added with
totally different fields.

(I didn't check whether the syntax above results in the desired memory
layout, buit you can check with pahole or similar tools.)

(Also, I checked that C bit-fields can be used in Linux uapi headers.
Although their representation is implementation-defined according to the
C standard there is a well-defined representation in the System V ABI
that gcc, clang, and other compilers follow on Linux.)

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAioPEACgkQnKSrs4Gr
c8i+Xgf+Phb3uyz3VHRpn1+jtWTNOwVDwzGRG/EumbPXqYFAc7CcJygpXmmx/Xhk
jbJ0RGOi9iOKv6UQATHY3247kaSIlGg2ovF2FekxoKGt/uZXPilicP6KwRksC7iJ
qRSkXjlc8xm4qUqrT/nXoZv1sXb+qxuYW9vwg6g6voKg0MyAaH7Qbk79FLgljfIf
Wb5xVZ1+dMa0urm+lOHoNkBy8dpqYsvj9vUHh5H/pF4xiuwzl+JjKo6Qxi9rju6B
rtBFj1egGVyXi6+5jeDEuBPG+s62iYAwJ8KQERo7TbzfJndeqS2LzjKF17wbaEcr
j3MpMAEYckiYSUeraSU0wKKvFzZD3w==
=2mY7
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--

