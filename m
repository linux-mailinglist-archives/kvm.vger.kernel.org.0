Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7AC73097B4
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 19:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbhA3Szu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 13:55:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31174 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230045AbhA3Szt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 30 Jan 2021 13:55:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612032862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1Ov9d4j/dLr2l+97bVEX2opM5HTQ6CfGiRe+Tx/Qzy8=;
        b=cywqiOChy6pSVi1TmqMuwInQFEazjLxjUXedjyVlWx2maYxrMJL6qIj0c5d2jykj+Vdl/9
        P+HQNZiQq9kbUu2S6XMwScPi49RDIkw5q6XhusD/z0/Lhl7fMgHeK5runsugeTyuKNQBTO
        SQ+AIJnwY6pI20t0O3gSFinz3dO7oCQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-kT74L8TMMgiVTWWLnTZlXA-1; Sat, 30 Jan 2021 13:54:18 -0500
X-MC-Unique: kT74L8TMMgiVTWWLnTZlXA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 285AB18C8C00;
        Sat, 30 Jan 2021 18:54:17 +0000 (UTC)
Received: from localhost (ovpn-112-96.ams2.redhat.com [10.36.112.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA3345D9D3;
        Sat, 30 Jan 2021 18:54:16 +0000 (UTC)
Date:   Sat, 30 Jan 2021 18:54:15 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Elena Afanasova <eafanasova@gmail.com>
Cc:     kvm@vger.kernel.org, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com
Subject: Re: [RFC v2 3/4] KVM: add support for ioregionfd cmds/replies
 serialization
Message-ID: <20210130185415.GD98016@stefanha-x1.localdomain>
References: <cover.1611850290.git.eafanasova@gmail.com>
 <294d8a0e08eff4ec9c8f8f62492f29163e6c4319.1611850291.git.eafanasova@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="48TaNjbzBVislYPb"
Content-Disposition: inline
In-Reply-To: <294d8a0e08eff4ec9c8f8f62492f29163e6c4319.1611850291.git.eafanasova@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--48TaNjbzBVislYPb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 28, 2021 at 09:32:22PM +0300, Elena Afanasova wrote:
> Add ioregionfd context and kvm_io_device_ops->prepare/finish()
> in order to serialize all bytes requested by guest.
>=20
> Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
> ---
>  arch/x86/kvm/x86.c       |  19 ++++++++
>  include/kvm/iodev.h      |  14 ++++++
>  include/linux/kvm_host.h |   4 ++
>  virt/kvm/ioregion.c      | 102 +++++++++++++++++++++++++++++++++------
>  virt/kvm/kvm_main.c      |  32 ++++++++++++
>  5 files changed, 157 insertions(+), 14 deletions(-)
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a04516b531da..393fb0f4bf46 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5802,6 +5802,8 @@ static int vcpu_mmio_write(struct kvm_vcpu *vcpu, g=
pa_t addr, int len,
>  	int ret =3D 0;
>  	bool is_apic;
> =20
> +	kvm_io_bus_prepare(vcpu, KVM_MMIO_BUS, addr, len);
> +
>  	do {
>  		n =3D min(len, 8);
>  		is_apic =3D lapic_in_kernel(vcpu) &&
> @@ -5823,8 +5825,10 @@ static int vcpu_mmio_write(struct kvm_vcpu *vcpu, =
gpa_t addr, int len,
>  	if (ret =3D=3D -EINTR) {
>  		vcpu->run->exit_reason =3D KVM_EXIT_INTR;
>  		++vcpu->stat.signal_exits;
> +		return handled;
>  	}
>  #endif
> +	kvm_io_bus_finish(vcpu, KVM_MMIO_BUS, addr, len);

Hmm...it would be nice for kvm_io_bus_prepare() to return the idx or the
device pointer so the devices don't need to be searched in
read/write/finish. However, it's complicated by the loop which may
access multiple devices.

> @@ -9309,6 +9325,7 @@ static int complete_ioregion_mmio(struct kvm_vcpu *=
vcpu)
>  		vcpu->mmio_cur_fragment++;
>  	}
> =20
> +	vcpu->ioregion_ctx.dev->ops->finish(vcpu->ioregion_ctx.dev);
>  	vcpu->mmio_needed =3D 0;
>  	if (!vcpu->ioregion_ctx.in) {
>  		srcu_read_unlock(&vcpu->kvm->srcu, idx);
> @@ -9333,6 +9350,7 @@ static int complete_ioregion_pio(struct kvm_vcpu *v=
cpu)
>  		vcpu->ioregion_ctx.val +=3D vcpu->ioregion_ctx.len;
>  	}
> =20
> +	vcpu->ioregion_ctx.dev->ops->finish(vcpu->ioregion_ctx.dev);
>  	if (vcpu->ioregion_ctx.in)
>  		r =3D kvm_emulate_instruction(vcpu, EMULTYPE_NO_DECODE);
>  	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> @@ -9352,6 +9370,7 @@ static int complete_ioregion_fast_pio(struct kvm_vc=
pu *vcpu)
>  	complete_ioregion_access(vcpu, vcpu->ioregion_ctx.addr,
>  				 vcpu->ioregion_ctx.len,
>  				 vcpu->ioregion_ctx.val);
> +	vcpu->ioregion_ctx.dev->ops->finish(vcpu->ioregion_ctx.dev);
>  	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> =20
>  	if (vcpu->ioregion_ctx.in) {

Normally userspace will invoke ioctl(KVM_RUN) and reach one of these
completion functions, but what if the vcpu fd is closed instead?
->finish() should still be called to avoid leaks.

> diff --git a/include/kvm/iodev.h b/include/kvm/iodev.h
> index d75fc4365746..db8a3c69b7bb 100644
> --- a/include/kvm/iodev.h
> +++ b/include/kvm/iodev.h
> @@ -25,6 +25,8 @@ struct kvm_io_device_ops {
>  		     gpa_t addr,
>  		     int len,
>  		     const void *val);
> +	void (*prepare)(struct kvm_io_device *this);
> +	void (*finish)(struct kvm_io_device *this);
>  	void (*destructor)(struct kvm_io_device *this);
>  };
> =20
> @@ -55,6 +57,18 @@ static inline int kvm_iodevice_write(struct kvm_vcpu *=
vcpu,
>  				 : -EOPNOTSUPP;
>  }
> =20
> +static inline void kvm_iodevice_prepare(struct kvm_io_device *dev)
> +{
> +	if (dev->ops->prepare)
> +		dev->ops->prepare(dev);
> +}
> +
> +static inline void kvm_iodevice_finish(struct kvm_io_device *dev)
> +{
> +	if (dev->ops->finish)
> +		dev->ops->finish(dev);
> +}

A performance optimization: keep a separate list of struct
kvm_io_devices that implement prepare/finish. That way the search
doesn't need to iterate over devices that don't support this interface.

Before implementing an optimization like this it would be good to check
how this patch affects performance on guests with many in-kernel devices
(e.g. a guest that has many multi-queue virtio-net/blk devices with
ioeventfd). ioregionfd shouldn't reduce performance of existing KVM
configurations, so it's worth measuring.

> diff --git a/virt/kvm/ioregion.c b/virt/kvm/ioregion.c
> index da38124e1418..3474090ccc8c 100644
> --- a/virt/kvm/ioregion.c
> +++ b/virt/kvm/ioregion.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  #include <linux/kvm_host.h>
> -#include <linux/fs.h>
> +#include <linux/wait.h>
>  #include <kvm/iodev.h>
>  #include "eventfd.h"
>  #include <uapi/linux/ioregion.h>
> @@ -12,15 +12,23 @@ kvm_ioregionfd_init(struct kvm *kvm)
>  	INIT_LIST_HEAD(&kvm->ioregions_pio);
>  }
> =20
> +/* Serializes ioregionfd cmds/replies */

Please expand on this comment:

  ioregions that share the same rfd are serialized so that only one vCPU
  thread sends a struct ioregionfd_cmd to userspace at a time. This
  ensures that the struct ioregionfd_resp received from userspace will
  be processed by the one and only vCPU thread that sent it.

  A waitqueue is used to wake up waiting vCPU threads in order. Most of
  the time the waitqueue is unused and the lock is not contended.
  For best performance userspace should set up ioregionfds so that there
  is no contention (e.g. dedicated ioregionfds for queue doorbell
  registers on multi-queue devices).

A comment along these lines will give readers an idea of why the code
does this.

--48TaNjbzBVislYPb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAVq1cACgkQnKSrs4Gr
c8il4Qf/VkDAtPpTSWZQuPX8F+6fSyz08YpBTvviKk7jbwixTWz/G0qNAdlY2AQN
DX0z7iWhfc0jxlTj9PLxObSvHTARxk9yYzA+cCYIuL+KjqxUHObE70aQgjFAqEP7
u9pFjbyav45v8ca9TuGYD3+21TAZrOOwuFgh3DU2vsMzNxZ02rrgPY5q6kIC96jA
fF0AXj2IBTPq/lwEj/dJmubLsw4yc/+XWr7EZorMJK1cmg3D6lGx9IkHw0DaDMeP
XOcGEarN1DM9d1TSySztcY71I1cHUWaui/Nhg2nPykb7c0dkagV36WGTDL+hJYCg
bTCwMQnYhPoTc6S55dTuFAsbPSeZGA==
=sLwO
-----END PGP SIGNATURE-----

--48TaNjbzBVislYPb--

