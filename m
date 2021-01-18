Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951F62F9AFB
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 09:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733246AbhARIFg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 03:05:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26754 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733251AbhARIFd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 03:05:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610957046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SOIGD2G2ecJQm9UNfLUiX/V/JUlu/fKIPOOxEnfsWYw=;
        b=hwJ6zWyAzVAcm6QB9x3fFczxi6f/uNPcuTPJniaaf8OkIw5oOuUW9BpGVJJVYdKsUpNQj8
        tqnA9zNQe+5XtYxxBVjgiWZawtkZ/r0D+4qA4zgJ1NVgmTN+Gkm49533R4EgW10z3dDPbI
        6fWJlFuH8ToKvobJXbgPtDZaXROHim4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-kmAeKK5TOxWGEMqrOhLPiA-1; Mon, 18 Jan 2021 03:04:02 -0500
X-MC-Unique: kmAeKK5TOxWGEMqrOhLPiA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72013801817;
        Mon, 18 Jan 2021 08:03:59 +0000 (UTC)
Received: from gondolin (ovpn-114-2.ams2.redhat.com [10.36.114.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ADCE460622;
        Mon, 18 Jan 2021 08:03:48 +0000 (UTC)
Date:   Mon, 18 Jan 2021 09:03:36 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
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
Subject: Re: [PATCH v7 08/13] confidential guest support: Move SEV
 initialization into arch specific code
Message-ID: <20210118090336.1e708346.cohuck@redhat.com>
In-Reply-To: <20210118030308.GG2089552@yekko.fritz.box>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
        <20210113235811.1909610-9-david@gibson.dropbear.id.au>
        <20210115142425.540b6126.cohuck@redhat.com>
        <20210118030308.GG2089552@yekko.fritz.box>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/WkEXjtwJyWPKs=NWbty5zOm";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/WkEXjtwJyWPKs=NWbty5zOm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Jan 2021 14:03:08 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

> On Fri, Jan 15, 2021 at 02:24:25PM +0100, Cornelia Huck wrote:
> > On Thu, 14 Jan 2021 10:58:06 +1100
> > David Gibson <david@gibson.dropbear.id.au> wrote:
> >  =20
> > > While we've abstracted some (potential) differences between mechanism=
s for
> > > securing guest memory, the initialization is still specific to SEV.  =
Given
> > > that, move it into x86's kvm_arch_init() code, rather than the generic
> > > kvm_init() code.
> > >=20
> > > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > > ---
> > >  accel/kvm/kvm-all.c   | 14 --------------
> > >  accel/kvm/sev-stub.c  |  4 ++--
> > >  target/i386/kvm/kvm.c | 12 ++++++++++++
> > >  target/i386/sev.c     |  7 ++++++-
> > >  4 files changed, 20 insertions(+), 17 deletions(-)
> > >  =20
> >=20
> > (...)
> >  =20
> > > @@ -2135,6 +2136,17 @@ int kvm_arch_init(MachineState *ms, KVMState *=
s)
> > >      uint64_t shadow_mem;
> > >      int ret;
> > >      struct utsname utsname;
> > > +    Error *local_err =3D NULL;
> > > +
> > > +    /*
> > > +     * if memory encryption object is specified then initialize the
> > > +     * memory encryption context (no-op otherwise)
> > > +     */
> > > +    ret =3D sev_kvm_init(ms->cgs, &local_err); =20
> >=20
> > Maybe still leave a comment here, as the code will still need to be
> > modified to handle non-SEV x86 mechanisms? =20
>=20
> Uh.. I'm confused.. this hunk is adding a comment, not removing one..

Yes, but there was a "TODO: handle non-SEV" comment before. This will
probably need some massaging if we add Intel mechanisms?

>=20
> >  =20
> > > +    if (ret < 0) {
> > > +        error_report_err(local_err);
> > > +        return ret;
> > > +    }
> > > =20
> > >      if (!kvm_check_extension(s, KVM_CAP_IRQ_ROUTING)) {
> > >          error_report("kvm: KVM_CAP_IRQ_ROUTING not supported by KVM"=
);

--Sig_/WkEXjtwJyWPKs=NWbty5zOm
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw9DWbcNiT/aowBjO3s9rk8bwL68FAmAFQNgACgkQ3s9rk8bw
L6+rVA//YG3RYaH7PAb1Wxo1thCQnDUklKSye2aqzmkoPAe3RCqWur2vajE5vX3R
rdOJvofTSloYZo0QzMSahu7gBXvh8r1R3O/LEysaOYAUMkguyN9Np2SOZLOpmOwg
Ix+U/cfF5050isQenpKg5Aa9zvsuYaA7soTkZY113MAz/K9eD8ZGQfJWFj36a/Nh
oCyM3BeDq5ByUTJbXruDxV61pMEFRmmpIGOIBlVUOuEA/Vzi5NF1CrkaTA2OOwiM
clj6JU4+VxRgglSckK7c9BBjyvKzb2IIfc4KUkwlsWUmVN0hySDIJnOOqj5KxqRo
hKoW/QVCmkP5p95DA9A+l+K06YdL/ZpLUhTyMOz4+IW47zf1QVh/ndoUWhaZYZPS
NzmAc7KE36WsfSH2XtkyY+PKbcASF+RWja0/+AtASYlbtD3POAz8IFmyAUBpulz2
cEsVc3Rq0F3iU6EteHe74cPFQuw03AOnnILUriQDb7zQZlWiZIQEdAJAyv3f/D2i
/zOPQ7aeqivJf/kK2h6AIA7PrfZPD2CBuonRM2WGEE8HYiVYCYoC8qQkTE0WICrX
nksCDEC5v4sSeRv5+8bMhPR7BRNxNPJWhA06Z4ARB7921TH4Rz9qL38d3OyMvVc8
UyVXOsMqdHnKGzGeZ3uimgx9lzmNfMkRJSmijEpLWWzlepGdC0M=
=du0m
-----END PGP SIGNATURE-----

--Sig_/WkEXjtwJyWPKs=NWbty5zOm--

