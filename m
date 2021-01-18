Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DE22F9808
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 04:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbhARDFS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Jan 2021 22:05:18 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:55595 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726592AbhARDFR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Jan 2021 22:05:17 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DJxTZ1PcDz9sW8; Mon, 18 Jan 2021 14:04:34 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610939074;
        bh=IY+EtdUcdbw4Y7gyTL/tzbEUdbfdDC6K5ehntJd5eb4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dSlE3HKvknUv+8MfV/Pqiy4MaPK4emj2IILCD3Q1SX5VkQ8MOJlPY6Jr4tqsGsqpK
         tl/JT9eHq4ZTa/Oi+ygCA0pmx4ypgDtKLlcJU0KI6xGlr0smEYVlRnHgU72iR5UPmR
         N7nHmVxwOuO3s8KgJ/INPRCOFZqHMZGjbqERZub4=
Date:   Mon, 18 Jan 2021 13:59:15 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     brijesh.singh@amd.com, pair@us.ibm.com, dgilbert@redhat.com,
        pasic@linux.ibm.com, qemu-devel@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Hildenbrand <david@redhat.com>, borntraeger@de.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, mst@redhat.com,
        jun.nakajima@intel.com, thuth@redhat.com,
        pragyansri.pathi@intel.com, kvm@vger.kernel.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org, frankja@linux.ibm.com,
        Greg Kurz <groug@kaod.org>, mdroth@linux.vnet.ibm.com,
        berrange@redhat.com, andi.kleen@intel.com
Subject: Re: [PATCH v7 03/13] sev: Remove false abstraction of flash
 encryption
Message-ID: <20210118025915.GF2089552@yekko.fritz.box>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
 <20210113235811.1909610-4-david@gibson.dropbear.id.au>
 <20210115135425.7fd94aed.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1Ow488MNN9B9o/ov"
Content-Disposition: inline
In-Reply-To: <20210115135425.7fd94aed.cohuck@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--1Ow488MNN9B9o/ov
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 15, 2021 at 01:54:25PM +0100, Cornelia Huck wrote:
> On Thu, 14 Jan 2021 10:58:01 +1100
> David Gibson <david@gibson.dropbear.id.au> wrote:
>=20
> > When AMD's SEV memory encryption is in use, flash memory banks (which a=
re
> > initialed by pc_system_flash_map()) need to be encrypted with the guest=
's
> > key, so that the guest can read them.
> >=20
> > That's abstracted via the kvm_memcrypt_encrypt_data() callback in the K=
VM
> > state.. except, that it doesn't really abstract much at all.
> >=20
> > For starters, the only called is in code specific to the 'pc' family of
>=20
> s/called/call site/

Fixed, thanks.

>=20
> > machine types, so it's obviously specific to those and to x86 to begin
> > with.  But it makes a bunch of further assumptions that need not be true
> > about an arbitrary confidential guest system based on memory encryption,
> > let alone one based on other mechanisms:
> >=20
> >  * it assumes that the flash memory is defined to be encrypted with the
> >    guest key, rather than being shared with hypervisor
> >  * it assumes that that hypervisor has some mechanism to encrypt data i=
nto
> >    the guest, even though it can't decrypt it out, since that's the who=
le
> >    point
> >  * the interface assumes that this encrypt can be done in place, which
> >    implies that the hypervisor can write into a confidential guests's
> >    memory, even if what it writes isn't meaningful
> >=20
> > So really, this "abstraction" is actually pretty specific to the way SEV
> > works.  So, this patch removes it and instead has the PC flash
> > initialization code call into a SEV specific callback.
> >=20
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > ---
> >  accel/kvm/kvm-all.c    | 31 ++-----------------------------
> >  accel/kvm/sev-stub.c   |  9 ++-------
> >  accel/stubs/kvm-stub.c | 10 ----------
> >  hw/i386/pc_sysfw.c     | 17 ++++++-----------
> >  include/sysemu/kvm.h   | 16 ----------------
> >  include/sysemu/sev.h   |  4 ++--
> >  target/i386/sev-stub.c |  5 +++++
> >  target/i386/sev.c      | 24 ++++++++++++++----------
> >  8 files changed, 31 insertions(+), 85 deletions(-)
>=20
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--1Ow488MNN9B9o/ov
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmAE+YEACgkQbDjKyiDZ
s5JqpxAA2JPKpVmOQc2xg4NC6iOvJisQ7ELyJmraenLUuf6UyaxJFrdMsuWAxQkF
UNYhYqeFWv+d3wcC1Y98Yudqd7A+hlOrKkybwByD9XPr0iBTEFOXKvA1kVusYkPR
2QBL9YOPpiLoteG4kDIJXlCzL6AItS2N1PN4mraBE25JHLkvcedbQtzZkslB/+aF
8vJFpTkRCUnKvyROVC9uDU5bFlbYKX55seDZ2xDj2ezM1oPCVCdC0exMcUoIsBs2
Tw9BzNvavrwsBFaa2c8aG1uDGlJuo+O7wFbZg1SPx+p2apq0BYm74i7dY/5y62ne
jU4xu3+pA53HlDM4KfH8xSyDTYkHSQ+gbTzxIvxjwu/vkkoN+fBGBrO7VrsVN+z+
0GmW/xG6MdDps9fkvzhB5anc6MgZOaFGqWhCb6sxovf+EsvJ5IhG5k8n9C8Ap+r9
EYEbNzDxCO29UqzuYlGGUnsnRGdIjH6Ti5BnVH35wAteZCs9GA91nHEDT23gqoMV
h6fbISfoT3yloLjQBP6bD+uIn79nD8V7uOuIxM4JyAuVScuWE7W6ojvq7KoQy9Wv
tFKPeNH8dzR65AjvvONLJ261M6JxYsOJZtTX0tL92gFTYyQUD81SYFF2ZDGktFJw
InUJptHHR1SxryMAc+4eiuwjePiPUXOdCb2uFkSR9vF+Jd3uBRg=
=PCsc
-----END PGP SIGNATURE-----

--1Ow488MNN9B9o/ov--
