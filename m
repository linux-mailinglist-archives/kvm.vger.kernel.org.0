Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59531323B4C
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 12:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234928AbhBXLaB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 06:30:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44715 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233942AbhBXL3h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Feb 2021 06:29:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614166090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ptFkP4h8NqGvXq9lBCHj1SFiq2P7tuFr8vw8zXjZQaM=;
        b=JLynwMeScpCHlOpgTpDsiEnkByLYC0eZPgHLx2TXKr0e+a6WmoWnYJa46st5ErvkGuSz+R
        kG7ac84tPDZiPPznc/jCSsz+JA5u9IV2XIgDLhyxQO94ToEWcQIfFN+hECtpro534sz7I7
        BE4Ymn/EZgSRh9NLe0HW3lRYTCrSMQo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-MzFDP29kMMamZA176hssWw-1; Wed, 24 Feb 2021 06:28:08 -0500
X-MC-Unique: MzFDP29kMMamZA176hssWw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 850D11083E9B;
        Wed, 24 Feb 2021 11:28:06 +0000 (UTC)
Received: from localhost (ovpn-115-137.ams2.redhat.com [10.36.115.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C12F360C61;
        Wed, 24 Feb 2021 11:27:59 +0000 (UTC)
Date:   Wed, 24 Feb 2021 11:27:58 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Elena Afanasova <eafanasova@gmail.com>
Cc:     kvm@vger.kernel.org, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, cohuck@redhat.com,
        john.levon@nutanix.com
Subject: Re: [RFC v3 4/5] KVM: add ioregionfd context
Message-ID: <YDY4PuCnniBfYlSP@stefanha-x1.localdomain>
References: <cover.1613828726.git.eafanasova@gmail.com>
 <4436ef071e55d88ff3996b134cc2303053581242.1613828727.git.eafanasova@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mLRzepf1IHytWqDc"
Content-Disposition: inline
In-Reply-To: <4436ef071e55d88ff3996b134cc2303053581242.1613828727.git.eafanasova@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--mLRzepf1IHytWqDc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 21, 2021 at 03:04:40PM +0300, Elena Afanasova wrote:
> +/* ioregions that share the same rfd are serialized so that only one vCPU
> + * thread sends a struct ioregionfd_cmd to userspace at a time. This
> + * ensures that the struct ioregionfd_resp received from userspace will
> + * be processed by the one and only vCPU thread that sent it.
> + *
> + * A waitqueue is used to wake up waiting vCPU threads in order. Most of
> + * the time the waitqueue is unused and the lock is not contended.
> + * For best performance userspace should set up ioregionfds so that there
> + * is no contention (e.g. dedicated ioregionfds for queue doorbell
> + * registers on multi-queue devices).
> + */
> +struct ioregionfd {
> +	wait_queue_head_t	  wq;
> +	struct file		 *rf;
> +	struct kref		  kref;
> +	bool			  busy;
> +};
> +
> +struct ioregion {
> +	struct list_head	  list;
> +	u64			  paddr;   /* guest physical address */
> +	u64			  size;    /* size in bytes */
> +	struct file		 *wf;
> +	u64			  user_data; /* opaque token used by userspace */
> +	struct kvm_io_device	  dev;
> +	bool			  posted_writes;
> +	struct ioregionfd	 *ctx;

The name "ctx" is a little confusion since there is also an ioregion_ctx
in struct kvm_vcpu now. Maybe s/struct ioregionfd/struct
ioregion_resp_file/ and s/ctx/resp_file/?

> @@ -90,6 +118,30 @@ ioregion_save_ctx(struct kvm_vcpu *vcpu, bool in, gpa=
_t addr, u8 state, void *va
>  	vcpu->ioregion_ctx.in =3D in;
>  }
> =20
> +static inline void
> +ioregion_lock_ctx(struct ioregionfd *ctx)
> +{
> +	if (!ctx)
> +		return;
> +
> +	spin_lock(&ctx->wq.lock);
> +	wait_event_interruptible_exclusive_locked(ctx->wq, !ctx->busy);

What happens if this function call is interrupted by a signal?

> @@ -129,14 +185,15 @@ ioregion_read(struct kvm_vcpu *vcpu, struct kvm_io_=
device *this, gpa_t addr,
>  	}
>  	if (ret !=3D sizeof(buf.cmd)) {
>  		ret =3D (ret < 0) ? ret : -EIO;
> -		return (ret =3D=3D -EAGAIN || ret =3D=3D -EWOULDBLOCK) ? -EINVAL : ret;
> +		ret =3D (ret =3D=3D -EAGAIN || ret =3D=3D -EWOULDBLOCK) ? -EINVAL : re=
t;
> +		goto out;
>  	}
> -	if (!p->rf)
> +	if (!p->ctx)
>  		return 0;

I think this should be goto out so that ioregion_unlock_ctx() gets
called.

> @@ -322,6 +420,12 @@ kvm_set_ioregion_idx(struct kvm *kvm, struct kvm_ior=
egion *args, enum kvm_bus bu
>  		ret =3D -EEXIST;
>  		goto unlock_fail;
>  	}
> +
> +	if (rfile && !ioregion_get_ctx(kvm, p, rfile, bus_idx)) {
> +		ret =3D -ENOMEM;
> +		goto unlock_fail;
> +	}
> +
>  	kvm_iodevice_init(&p->dev, &ioregion_ops);
>  	ret =3D kvm_io_bus_register_dev(kvm, bus_idx, p->paddr, p->size,
>  				      &p->dev);
> @@ -335,6 +439,8 @@ kvm_set_ioregion_idx(struct kvm *kvm, struct kvm_iore=
gion *args, enum kvm_bus bu
> =20
>  unlock_fail:
>  	mutex_unlock(&kvm->slots_lock);
> +	if (p->ctx)
> +		kref_put(&p->ctx->kref, ctx_free);

Please move the kref_put() before mutex_unlock(&kvm->slots_lock) since
ioregion_get_ctx() depends on kvm->slots_lock to avoid race conditions
with struct ioregionfds that are being created/destroyed.

--mLRzepf1IHytWqDc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmA2OD4ACgkQnKSrs4Gr
c8hPogf+MxLU4ay/kZG4XUvBr0H8sh33eyZldGiYT5sa7oGh8T5HQl8F8x0KYSIY
2B6SIVuVaryjNntkLEHUoOs+/4aV1ac7lkKln9FeO2Y18ZsGhNUx3cHgGeT8ehHD
7yIXW8eA/AE60RCCf77GfT4lMNXzwdRQ2PAkXR/BouuuBwElUXJEbHITtBKo4ONQ
XOnqI2EqwkWC1W5i6AjIVg01EE44tuhnsgQG0+e3oCKsCuQlsXiAB7LZYpTdMEla
Yi3ig2Sk502SOKwScL+5vSQawn26Y4MBCz/p/9mh+iya6Gz5ftytGaPd6hSm+WSU
JQLmMPI81owY385XMMzy2XdXl+nHCQ==
=Ue7N
-----END PGP SIGNATURE-----

--mLRzepf1IHytWqDc--

