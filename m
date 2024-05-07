Return-Path: <kvm+bounces-16845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CD1058BE708
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 17:10:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84388284D8C
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 15:10:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1452D1635D8;
	Tue,  7 May 2024 15:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DGqOJ2pV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C9D161318
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 15:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715094575; cv=none; b=h409gBuMxBtaAA99RbzgodsUgOBZjwBBxo6CiHJs2jpmt8Sp6MsghM6dOjR2NefcVisNgCTTaXzlWyeeLDDkUVaybSxEQ+3FYfmRAYsJTdGbTPwfwF7LZP3OI+fXq10xKTQj72B8v63Br3UEhZKm+apD9MicPzvqCmjY/d7hFUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715094575; c=relaxed/simple;
	bh=nVFd+LTD+ZasaPoO7HR/lIoIYtajnvD2wdGwA14r9FI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RLgaG7qJUBKlar9NBRk+EEvBov+A0a8aCOlFvMGlzhdOIM3hp9pp2xcziSN7O7pYo5ZxFGYq6Yh02FjS7W5oOIwG/rI7+iNthcYItbqvTnONNGjjC1/agrgon3vzZYH3tK5ga92vWTPrAGUIwrWMqEcOXNSHC8Xx75DG/LRqiXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DGqOJ2pV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715094572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IAMmzCwLtdG5RVdAgwNgLH0bsE7H0cYhJOrp1QsvG/c=;
	b=DGqOJ2pVyrarRhxOkPKtbqePmwyu/ofd/c4Zu+apKG7BIFHFFAKUtKTJrTksj9RJ1iIlvF
	ZY292MiBhEZaEwvGWKGRJKIaOpqUdo8mtZT+6xUIAkafF1tEf3hEm83x2RVc1b8SEl/PD3
	zLmx2pOToV6FvYsBceKriHk6My5zoJQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-642-cMH_NkvYNBO7fhiLbC7z4g-1; Tue,
 07 May 2024 11:09:29 -0400
X-MC-Unique: cMH_NkvYNBO7fhiLbC7z4g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BCB741C01516;
	Tue,  7 May 2024 15:09:28 +0000 (UTC)
Received: from localhost (unknown [10.39.192.114])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C11AA1C060AE;
	Tue,  7 May 2024 15:09:26 +0000 (UTC)
Date: Tue, 7 May 2024 11:09:19 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org, Richard Henderson <rth@twiddle.net>,
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
	Julia Suvorova <jusual@redhat.com>,
	Aarushi Mehta <mehta.aaru20@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>, kvm@vger.kernel.org,
	=?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Raphael Norwitz <raphael.norwitz@nutanix.com>,
	qemu-block@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Hanna Reitz <hreitz@redhat.com>, Eric Blake <eblake@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Fam Zheng <fam@euphon.net>, Sam Li <faithilikerun@gmail.com>,
	Hannes Reinecke <hare@suse.de>,
	Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: Re: [PULL v2 03/16] block/block-backend: add block layer APIs
 resembling Linux ZonedBlockDevice ioctls
Message-ID: <20240507150919.GE105913@fedora.redhat.com>
References: <20230515160506.1776883-1-stefanha@redhat.com>
 <20230515160506.1776883-4-stefanha@redhat.com>
 <CAFEAcA9U8jtHFYY1xZ69=PoR1imgzrTB9aK5aoe+vZJtQrU1Jg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="evVfc2bZ/OH8O6xW"
Content-Disposition: inline
In-Reply-To: <CAFEAcA9U8jtHFYY1xZ69=PoR1imgzrTB9aK5aoe+vZJtQrU1Jg@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7


--evVfc2bZ/OH8O6xW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 03, 2024 at 01:33:51PM +0100, Peter Maydell wrote:
> On Mon, 15 May 2023 at 17:07, Stefan Hajnoczi <stefanha@redhat.com> wrote:
> >
> > From: Sam Li <faithilikerun@gmail.com>
> >
> > Add zoned device option to host_device BlockDriver. It will be presente=
d only
> > for zoned host block devices. By adding zone management operations to t=
he
> > host_block_device BlockDriver, users can use the new block layer APIs
> > including Report Zone and four zone management operations
> > (open, close, finish, reset, reset_all).
> >
> > Qemu-io uses the new APIs to perform zoned storage commands of the devi=
ce:
> > zone_report(zrp), zone_open(zo), zone_close(zc), zone_reset(zrs),
> > zone_finish(zf).
> >
> > For example, to test zone_report, use following command:
> > $ ./build/qemu-io --image-opts -n driver=3Dhost_device, filename=3D/dev=
/nullb0
> > -c "zrp offset nr_zones"
>=20
> Hi; Coverity points out an issue in this commit (CID 1544771):
>=20
> > +static int zone_report_f(BlockBackend *blk, int argc, char **argv)
> > +{
> > +    int ret;
> > +    int64_t offset;
> > +    unsigned int nr_zones;
> > +
> > +    ++optind;
> > +    offset =3D cvtnum(argv[optind]);
> > +    ++optind;
> > +    nr_zones =3D cvtnum(argv[optind]);
>=20
> cvtnum() can fail and return a negative value on error
> (e.g. if the number in the string is out of range),
> but we are not checking for that. Instead we stuff
> the value into an 'unsigned int' and then pass that to
> g_new(), which will result in our trying to allocate a large
> amount of memory.
>=20
> Here, and also in the other functions below that use cvtnum(),
> I think we should follow the pattern for use of that function
> that is used in the pre-existing code in this function:
>=20
>  int64_t foo; /* NB: not an unsigned or some smaller type */
>=20
>  foo =3D cvtnum(arg)
>  if (foo < 0) {
>      print_cvtnum_err(foo, arg);
>      return foo; /* or otherwise handle returning an error upward */
>  }
>=20
> It looks like all the uses of cvtnum in this patch should be
> adjusted to handle errors.

Thanks for letting me know. I will send a patch.

Stefan

--evVfc2bZ/OH8O6xW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmY6RB8ACgkQnKSrs4Gr
c8g8kAgAxj4bwKXeYT8BKNFRjR/8G+m/TrpTmXgPwgOBCGGBcA4XvLNzMqDXlM4T
H+dv8UrKzKWI0l3RlQ37/DgWd7T4Wcc/f7BeUFTtFnOovPJ/CPtIuEgK28WwBZ0V
IRIP+yHusXY+AJ7TDvdrfrQlcY/tyZFoWUaQGw+DJDhWQWUcgGNBSs7y7IVBwf+f
XNjPFHLywD0Ct5leYJ50spSZlsBRPUZn+bqSoLcg6hb8OrWGR0j0DEAnqf3YqkVQ
A6e2sWnX5aRFnQJiy3HGretXG7IhTlP9oNRdlpNb076RawCUVshf9TmGIytxbTnm
H59Wlb6Tbi7aFVkbLj+Ufy7Qd8ELEg==
=h4Ah
-----END PGP SIGNATURE-----

--evVfc2bZ/OH8O6xW--


