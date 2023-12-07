Return-Path: <kvm+bounces-3850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F9A58086E8
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 12:44:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 763601C20F09
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 11:44:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EBB437D2B;
	Thu,  7 Dec 2023 11:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hge8bc3P"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B02D62
	for <kvm@vger.kernel.org>; Thu,  7 Dec 2023 03:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701949482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CsscwaTR3+4z+GEJpfoX3rBQXEHIy7L+AXtx2hqmFDs=;
	b=Hge8bc3PDlyAVnSm+jeINwZ1DBcOy78Pw+vS2Knx5qX5msQn2ffKNQDyJ6km3PNQUqRcnj
	vR/sAGimyWiWz8Lv8lGpmBW9tmF7a+VaOX9LUXAC37I5JMp14hr5/qr+zpNUW0zTg5M83y
	6/qAJVHW7lTBbSv2d6xoyTBBgmaMyaw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-191-kAaQSZdeMqqqZJVsh4xDuw-1; Thu, 07 Dec 2023 06:44:38 -0500
X-MC-Unique: kAaQSZdeMqqqZJVsh4xDuw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7192C832D20;
	Thu,  7 Dec 2023 11:44:37 +0000 (UTC)
Received: from localhost (unknown [10.39.194.155])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 46EA7492BC6;
	Thu,  7 Dec 2023 11:44:34 +0000 (UTC)
Date: Thu, 7 Dec 2023 06:44:32 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Harsh Prateek Bora <harshpb@linux.ibm.com>
Cc: qemu-devel@nongnu.org, Jean-Christophe Dubois <jcd@tribudubois.net>,
	Fabiano Rosas <farosas@suse.de>, qemu-s390x@nongnu.org,
	Song Gao <gaosong@loongson.cn>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Thomas Huth <thuth@redhat.com>, Hyman Huang <yong.huang@smartx.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Andrey Smirnov <andrew.smirnov@gmail.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Kevin Wolf <kwolf@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
	Artyom Tarasenko <atar4qemu@gmail.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Paul Durrant <paul@xen.org>,
	Jagannathan Raman <jag.raman@oracle.com>,
	Juan Quintela <quintela@redhat.com>,
	Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
	qemu-arm@nongnu.org, Jason Wang <jasowang@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
	=?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>,
	BALATON Zoltan <balaton@eik.bme.hu>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Hailiang Zhang <zhanghailiang@xfusion.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Huacai Chen <chenhuacai@kernel.org>, Fam Zheng <fam@euphon.net>,
	Eric Blake <eblake@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
	Alexander Graf <agraf@csgraf.de>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Weiwei Li <liwei1518@gmail.com>, Eric Farman <farman@linux.ibm.com>,
	Stafford Horne <shorne@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Cameron Esfahani <dirty@apple.com>, xen-devel@lists.xenproject.org,
	Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, qemu-riscv@nongnu.org,
	Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
	John Snow <jsnow@redhat.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Michael Roth <michael.roth@amd.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Bin Meng <bin.meng@windriver.com>,
	Stefano Stabellini <sstabellini@kernel.org>, kvm@vger.kernel.org,
	qemu-block@nongnu.org, Halil Pasic <pasic@linux.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	Anthony Perard <anthony.perard@citrix.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	=?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
	qemu-ppc@nongnu.org,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Leonardo Bras <leobras@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: Re: [PATCH 1/6] system/cpus: rename qemu_mutex_lock_iothread() to
 qemu_bql_lock()
Message-ID: <20231207114432.GA2137208@fedora>
References: <20231129212625.1051502-1-stefanha@redhat.com>
 <20231129212625.1051502-2-stefanha@redhat.com>
 <8f89fbbf-454b-c5e5-5e8f-46ea42ec20ed@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="0duhWLao8zUYzEym"
Content-Disposition: inline
In-Reply-To: <8f89fbbf-454b-c5e5-5e8f-46ea42ec20ed@linux.ibm.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9


--0duhWLao8zUYzEym
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 01, 2023 at 10:42:43AM +0530, Harsh Prateek Bora wrote:
> On 11/30/23 02:56, Stefan Hajnoczi wrote:
> > diff --git a/hw/remote/mpqemu-link.c b/hw/remote/mpqemu-link.c
> > index 9bd98e8219..ffb2c25145 100644
> > --- a/hw/remote/mpqemu-link.c
> > +++ b/hw/remote/mpqemu-link.c
> > @@ -33,7 +33,7 @@
> >    */
> >   bool mpqemu_msg_send(MPQemuMsg *msg, QIOChannel *ioc, Error **errp)
> >   {
> > -    bool iolock =3D qemu_mutex_iothread_locked();
> > +    bool iolock =3D qemu_bql_locked();
>=20
> Should var name (one more below) be updated to reflect this update ?

Yes. I'll grep for that tree-wide because there might be other
instances.

Stefan

--0duhWLao8zUYzEym
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmVxsCAACgkQnKSrs4Gr
c8i1rQgAnF5hLI7FnDMNxncR8cyzsclzHlBL3lW0nptTddMxVMVSgpepQqo6yITp
7C02PzbGoKbRWSa8b95tpYbHeVbakCnrKjMsojhx5N50uYa7odEtNpXrPedhUh4l
ZcOC1N5E1uU55koqEGYWFSDoEC3BApk9qN0RFngsKFtoTears5RgyhSpuYYrdpyL
LN15OOQjSBJYsGNtYggDfIyN5hT4H55c8hsQF0b+kw/UwWoNRdjsdyMNelsHheII
+KODOArdtF9lNCVXL4kbZmuQbwmmHbAdfytMIurhnKWa+ENSZZ42DY9Z+XBIReto
Fj4JhmDsI3ewnZLjTxZ/jQHHNcV8Ew==
=KX5N
-----END PGP SIGNATURE-----

--0duhWLao8zUYzEym--


