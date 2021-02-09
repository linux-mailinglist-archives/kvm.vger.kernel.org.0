Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB5E315245
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 16:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbhBIPBM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 10:01:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56693 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230318AbhBIPBG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 10:01:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612882780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KcOe0GN9pF5Dw/zjO0zgHlm657pw5f7rrM5PtyL6D1s=;
        b=ImNHaHrOY6YSo/iHEf0j1Enj9cbFHOAQiJ4lfXbfLmXBYrOu1aNEdWoyS1Idv4vMXW8ZVI
        9rVO2IM8dzfHXl7JLVRaV6elzE9N4qkNOQpuCNDOFXCJjN3fyimMSbY65lAW5BfKjOY/Rm
        LJih6wge2/1rYPs9SuzFosxoLQ8LK2w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-5Z0Lgm3UM5Gs_mQQBkwtFQ-1; Tue, 09 Feb 2021 09:59:35 -0500
X-MC-Unique: 5Z0Lgm3UM5Gs_mQQBkwtFQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F687107ACE3;
        Tue,  9 Feb 2021 14:59:34 +0000 (UTC)
Received: from localhost (ovpn-115-93.ams2.redhat.com [10.36.115.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D3071002382;
        Tue,  9 Feb 2021 14:59:33 +0000 (UTC)
Date:   Tue, 9 Feb 2021 14:59:32 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org,
        jag.raman@oracle.com, elena.ufimtseva@oracle.com
Subject: Re: [RESEND RFC v2 1/4] KVM: add initial support for KVM_SET_IOREGION
Message-ID: <20210209145932.GB92126@stefanha-x1.localdomain>
References: <cover.1611850290.git.eafanasova@gmail.com>
 <de84fca7e7ad62943eb15e4e9dd598d4d0f806ef.1611850291.git.eafanasova@gmail.com>
 <a3794e77-54ec-7866-35ba-c3d8a3908aa6@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="i9LlY+UWpKt15+FH"
Content-Disposition: inline
In-Reply-To: <a3794e77-54ec-7866-35ba-c3d8a3908aa6@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--i9LlY+UWpKt15+FH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 08, 2021 at 02:21:35PM +0800, Jason Wang wrote:
> On 2021/1/30 =E4=B8=8A=E5=8D=882:48, Elena Afanasova wrote:
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index ca41220b40b8..81e775778c66 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -732,6 +732,27 @@ struct kvm_ioeventfd {
> >   	__u8  pad[36];
> >   };
> > +enum {
> > +	kvm_ioregion_flag_nr_pio,
> > +	kvm_ioregion_flag_nr_posted_writes,
> > +	kvm_ioregion_flag_nr_max,
> > +};
> > +
> > +#define KVM_IOREGION_PIO (1 << kvm_ioregion_flag_nr_pio)
> > +#define KVM_IOREGION_POSTED_WRITES (1 << kvm_ioregion_flag_nr_posted_w=
rites)
> > +
> > +#define KVM_IOREGION_VALID_FLAG_MASK ((1 << kvm_ioregion_flag_nr_max) =
- 1)
> > +
> > +struct kvm_ioregion {
> > +	__u64 guest_paddr; /* guest physical address */
> > +	__u64 memory_size; /* bytes */
>=20
>=20
> Do we really need __u64 here?

I think 64-bit PCI BARs can be >4 GB. There is plenty of space in this
struct to support a 64-bit field.

That said, userspace could also add more ioregions if it needs to cover
more than 4 GB. That would slow down ioregion lookups though since the
in-kernel data structure would become larger.

Making it 64-bit seems more future-proof and cleaner than having to work
around the limitation using multiple ioregions. Did you have a
particular reason in mind why this field should not be 64 bits?

--i9LlY+UWpKt15+FH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAio1QACgkQnKSrs4Gr
c8jOtAgAnyH4Ea5EXtLAEwv10poXJySalJQPKbz5oZAzV7XHstrqaK/8fLF+FPlx
ip++H9VifJeyqZei7WrvwST8m5wwXW+/NUZVpfB//qVax3J1qFXGsNzQKiockjIC
IjnOQS5l4F2u9l/otZDPoNZR5Gch+rHnVpX5hAKDB6ofUElR6NVetfiOojZvpgGx
u/Nf3i4HPgfZCrtMqFyBwAHcogD80hz9GzTLu8Fwb4wKP3W99zr64/yzMfDCW6Ff
TXkjRwFa8yST51H8ayeolIdIKVIyWs2F+Qt9DYHgD2ggtALGIA2TGOlhCDV34DER
6FFpLTEgtcp4KKlDhFJ/h5pP37SW3Q==
=sTDY
-----END PGP SIGNATURE-----

--i9LlY+UWpKt15+FH--

