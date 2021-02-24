Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AAB323AB3
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 11:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234892AbhBXKoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 05:44:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24720 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234872AbhBXKoX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Feb 2021 05:44:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614163376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UTVd4S7ljIh8nNs+MiuU7+qAtTiHBayqj5CsLuUeR1g=;
        b=Ur8kNTJNmreg7Ck8D/giIn3eJf6OrrYmKqZwAwTZAQWifLyhLTa9q/sR8GH0RzjET0QEgz
        uDZOqNxXlLwPdhWwJ1mbVeh0+he+1U+5e8mXoxPDiHb+shaKKRdqACGJlLyHhFu1IXpcXZ
        6mxIey3dPfjnlOuAAkLQSd7FKvDbl84=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-23SowbrHP5mqAOthw7XO6w-1; Wed, 24 Feb 2021 05:42:52 -0500
X-MC-Unique: 23SowbrHP5mqAOthw7XO6w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 096FF801978;
        Wed, 24 Feb 2021 10:42:51 +0000 (UTC)
Received: from localhost (ovpn-115-137.ams2.redhat.com [10.36.115.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0D3919C46;
        Wed, 24 Feb 2021 10:42:47 +0000 (UTC)
Date:   Wed, 24 Feb 2021 10:42:46 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Elena Afanasova <eafanasova@gmail.com>
Cc:     kvm@vger.kernel.org, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, cohuck@redhat.com,
        john.levon@nutanix.com
Subject: Re: [RFC v3 2/5] KVM: x86: add support for ioregionfd signal handling
Message-ID: <YDYtpuiMcxnyRa/E@stefanha-x1.localdomain>
References: <cover.1613828726.git.eafanasova@gmail.com>
 <575df1656277c55f26e660b7274a7c570b448636.1613828727.git.eafanasova@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PKAe4kVN/j8SF5Oj"
Content-Disposition: inline
In-Reply-To: <575df1656277c55f26e660b7274a7c570b448636.1613828727.git.eafanasova@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--PKAe4kVN/j8SF5Oj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 21, 2021 at 03:04:38PM +0300, Elena Afanasova wrote:
> The vCPU thread may receive a signal during ioregionfd communication,
> ioctl(KVM_RUN) needs to return to userspace and then ioctl(KVM_RUN)
> must resume ioregionfd.
>=20
> Signed-off-by: Elena Afanasova <eafanasova@gmail.com>

Functionally what this patch does makes sense to me. I'm not familiar
enough with the arch/x86/kvm mmio/pio code to say whether it's possible
to unify mmio/pio/ioregionfd state somehow so that this code can be
simplified.

> +static int complete_ioregion_io(struct kvm_vcpu *vcpu)
> +{
> +	if (vcpu->mmio_needed)
> +		return complete_ioregion_mmio(vcpu);
> +	if (vcpu->arch.pio.count)
> +		return complete_ioregion_pio(vcpu);

Can this be written as:

  if ... {
  } else if ... {
  } else {
      BUG();
  }

?

In other words, I'm not sure if ever get here without either
vcpu->mmio_needed or vcpu->arch.pio.count set.

> +}
> +#endif /* CONFIG_KVM_IOREGION */
> +
>  static void kvm_save_current_fpu(struct fpu *fpu)
>  {
>  	/*
> @@ -9309,6 +9549,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  	else
>  		r =3D vcpu_run(vcpu);
> =20
> +#ifdef CONFIG_KVM_IOREGION
> +	if (vcpu->ioregion_ctx.is_interrupted &&
> +	    vcpu->run->exit_reason =3D=3D KVM_EXIT_INTR)
> +		r =3D -EINTR;
> +#endif

Userspace can write to vcpu->run->exit_reason memory so its value cannot
be trusted. It's not obvious to me what happens when is_interrupted =3D=3D
true if userspace has corrupted vcpu->run->exit_reason. Since I can't
easily tell if it's safe, I suggest finding another way to perform this
check that does not rely on vcpu->run->exit_reason. Is just checking
vcpu->ioregion_ctx.is_interrupted enough?

(The same applies to other instances of vcpu->run->exit_reason in this
patch.)

> +
>  out:
>  	kvm_put_guest_fpu(vcpu);
>  	if (kvm_run->kvm_valid_regs)
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f35f0976f5cf..84f07597d131 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -318,6 +318,16 @@ struct kvm_vcpu {
>  #endif
>  	bool preempted;
>  	bool ready;
> +#ifdef CONFIG_KVM_IOREGION
> +	struct {

A comment would be nice to explain the purpose of this struct:

/*
 * MMIO/PIO state kept when a signal interrupts ioregionfd. When
 * ioctl(KVM_RUN) is invoked again we resume from this state.
 */

> +		u64 addr;
> +		void *val;
> +		int pio;

"int pio" could be a boolean indicating whether this is pio or mmio.
Calling it cur_pio or pio_offset might be clearer.

> +		u8 state; /* SEND_CMD/GET_REPLY */
> +		bool in;

/* true - read, false - write */

> +		bool is_interrupted;
> +	} ioregion_ctx;
> +#endif

The ioregion_ctx fields are not set in this patch. Either they are
unused or a later patch will set them. You can help reviewers by noting
this in the commit description. That way they won't need to worry about
whether there are unused fields that were accidentally left in the code.

--PKAe4kVN/j8SF5Oj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmA2LaYACgkQnKSrs4Gr
c8jJBgf9HwfGABlCOK1b6g/+LLY6aq7zBe9Et74+HWHqy2QaujfeyLmu0L+I3V4u
K9TiVpQbYAGcK+h5G+DcpD3Ns3KWkc9I25QXUvySKcBRONN6wUzlyPnnd+6TzlCR
pId6tkVCZE4DG++k/DtlXITBUNxkTVleT13Rzye9rG9pn4JOgmRU4BZcjelmUFCO
OBIjjl/hgyhrbQkKuq4TSRXFQ0APXNGwKNrNmAkZlz6OwuNFNxPonoF37wmccl0f
IB7vGnJy+ufO6cYXmRpWdrQ4db4PNGHhAkOw9UObtp76jIozBO+GuMTCw3w/EQnc
o9duYwQXDIsODZht6u3RLE2MG7YtAQ==
=V3m/
-----END PGP SIGNATURE-----

--PKAe4kVN/j8SF5Oj--

