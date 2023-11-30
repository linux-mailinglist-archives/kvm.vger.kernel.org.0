Return-Path: <kvm+bounces-3023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 590CA7FFC87
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 21:31:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0ED81281B0D
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 20:31:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03EBE5A0EA;
	Thu, 30 Nov 2023 20:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="heDlhXI/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3093B10FF
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 12:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701376299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8KFoHugi6jgybVjDl52fW0YxT+ePBaAxcnqZf4SllrU=;
	b=heDlhXI/eB2NqkLln5jkWdECVhZvTFBp12RcOfRJ/uHW+h7RA0jrJK8lYvm9CExDbMBm/X
	VU6HgItSvbUuo041hily0ojyNRJbiiXpjGexFGzGeMQ927lVLHaXViVeCSJm31rpkjxUvn
	kRFJb10nwSCPV9x2jbpQX22sKp0Lm1A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-155-7dZ0JHFOMOCb8JLtKgw87A-1; Thu, 30 Nov 2023 15:31:35 -0500
X-MC-Unique: 7dZ0JHFOMOCb8JLtKgw87A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F218101A550;
	Thu, 30 Nov 2023 20:31:34 +0000 (UTC)
Received: from localhost (unknown [10.39.192.46])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 768DF492BE0;
	Thu, 30 Nov 2023 20:31:33 +0000 (UTC)
Date: Thu, 30 Nov 2023 15:31:32 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
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
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	=?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
	qemu-ppc@nongnu.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Leonardo Bras <leobras@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: Re: [PATCH 4/6] system/cpus: rename qemu_global_mutex to qemu_bql
Message-ID: <20231130203132.GB1184658@fedora>
References: <20231129212625.1051502-1-stefanha@redhat.com>
 <20231129212625.1051502-5-stefanha@redhat.com>
 <01ebd72d-affc-4b03-b491-f40964520f1c@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="sn71hyyf1gpGKJP8"
Content-Disposition: inline
In-Reply-To: <01ebd72d-affc-4b03-b491-f40964520f1c@linaro.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9


--sn71hyyf1gpGKJP8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 30, 2023 at 02:44:07PM +0100, Philippe Mathieu-Daud=E9 wrote:
> Hi Stefan,
>=20
> On 29/11/23 22:26, Stefan Hajnoczi wrote:
> > The APIs using qemu_global_mutex now follow the Big QEMU Lock (BQL)
> > nomenclature. It's a little strange that the actual QemuMutex variable
> > that embodies the BQL is called qemu_global_mutex instead of qemu_bql.
> > Rename it for consistency.
> >=20
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > ---
> >   system/cpus.c | 20 ++++++++++----------
> >   1 file changed, 10 insertions(+), 10 deletions(-)
> >=20
> > diff --git a/system/cpus.c b/system/cpus.c
> > index eb24a4db8e..138720a540 100644
> > --- a/system/cpus.c
> > +++ b/system/cpus.c
> > @@ -65,7 +65,7 @@
> >   #endif /* CONFIG_LINUX */
> > -static QemuMutex qemu_global_mutex;
> > +static QemuMutex qemu_bql;
>=20
> I thought we were using _cond/_sem/_mutex suffixes, but
> this is not enforced:

I'm open to alternative names. Here are some I can think of:
- big_qemu_lock (although grepping for "bql" won't find it)
- qemu_bql_mutex

If there is no strong feeling about this then let's leave it at
qemu_bql. Otherwise, please discuss.

Thanks,
Stefan

--sn71hyyf1gpGKJP8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmVo8SQACgkQnKSrs4Gr
c8j+pAf/bHckak+kCTFY6THF9fWYuY9tKxDh1TAsmCqS02YPBAPs1z0YH+99X3km
es2S24gx5+JuX1lEM4Cq3AGZibmA2Vrs+TcKe6DyN6hT5mtNrfeoTcFLiUGNHFVx
s+czVZPIfsxatmrt9FobrI2Ih51wyLzqPPI9ibJTSbz849aMGdjCfB+///3zKHW5
JsvpwUhaL7gomsRHXZZSyQq9f/yJrxcl7BP/tM4eJhLul0Q/3xsdQsme8PS4ImLz
srpkocFet7WKPXnBwXpDaZ21znv5VvTybFpRqCXpFJlQoWwZR5m+bF/Jo1vdCKBU
R3KRE4Yg7YPFP70oH/H5T7bSCUiOKg==
=zmh7
-----END PGP SIGNATURE-----

--sn71hyyf1gpGKJP8--


