Return-Path: <kvm+bounces-3025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 163BB7FFCB5
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 21:37:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FA381C20FCD
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 20:37:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07F445B211;
	Thu, 30 Nov 2023 20:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WoHDYjhk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA5F10DC
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 12:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701376650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+iKxVT3Aoxm2ETYbHgSKpvUXyQ0XJ8rFvA2vgboplHU=;
	b=WoHDYjhkWvUNMfzjEK6PZ0HXews1WDTt9so/SenbNYE1HA+vZFbBw3YmZQcZ/QHjg0PjGb
	1gAkW1XaCsKosYmFfaxmPBGTDhz3bAhdgfoh2Ol8dZR/YjwqRH0rhBw6EGS3VNDm6d1zuR
	EwzU0fYTJUyWoFmJufYYS7eT80IXIFQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-259-V_vuTiG0PmOl3weveDAFBQ-1; Thu, 30 Nov 2023 15:37:24 -0500
X-MC-Unique: V_vuTiG0PmOl3weveDAFBQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C821101389B;
	Thu, 30 Nov 2023 20:37:21 +0000 (UTC)
Received: from localhost (unknown [10.39.192.46])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DDF641C060BD;
	Thu, 30 Nov 2023 20:37:19 +0000 (UTC)
Date: Thu, 30 Nov 2023 15:37:18 -0500
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
Subject: Re: [PATCH 6/6] Rename "QEMU global mutex" to "BQL" in comments and
 docs
Message-ID: <20231130203718.GD1184658@fedora>
References: <20231129212625.1051502-1-stefanha@redhat.com>
 <20231129212625.1051502-7-stefanha@redhat.com>
 <fcaff24d-0ced-4547-898f-a9b8bf49be45@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="rAX955JzN10OrQ/Q"
Content-Disposition: inline
In-Reply-To: <fcaff24d-0ced-4547-898f-a9b8bf49be45@linaro.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7


--rAX955JzN10OrQ/Q
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 30, 2023 at 02:49:48PM +0100, Philippe Mathieu-Daud=E9 wrote:
> On 29/11/23 22:26, Stefan Hajnoczi wrote:
> > The term "QEMU global mutex" is identical to the more widely used Big
> > QEMU Lock ("BQL"). Update the code comments and documentation to use
> > "BQL" instead of "QEMU global mutex".
> >=20
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > ---
> >   docs/devel/multi-thread-tcg.rst   |  7 +++----
> >   docs/devel/qapi-code-gen.rst      |  2 +-
> >   docs/devel/replay.rst             |  2 +-
> >   docs/devel/multiple-iothreads.txt | 16 ++++++++--------
> >   include/block/blockjob.h          |  6 +++---
> >   include/io/task.h                 |  2 +-
> >   include/qemu/coroutine-core.h     |  2 +-
> >   include/qemu/coroutine.h          |  2 +-
> >   hw/block/dataplane/virtio-blk.c   |  8 ++++----
> >   hw/block/virtio-blk.c             |  2 +-
> >   hw/scsi/virtio-scsi-dataplane.c   |  6 +++---
> >   net/tap.c                         |  2 +-
> >   12 files changed, 28 insertions(+), 29 deletions(-)
>=20
>=20
> > diff --git a/include/block/blockjob.h b/include/block/blockjob.h
> > index e594c10d23..b2bc7c04d6 100644
> > --- a/include/block/blockjob.h
> > +++ b/include/block/blockjob.h
> > @@ -54,7 +54,7 @@ typedef struct BlockJob {
> >       /**
> >        * Speed that was set with @block_job_set_speed.
> > -     * Always modified and read under QEMU global mutex (GLOBAL_STATE_=
CODE).
> > +     * Always modified and read under BQL (GLOBAL_STATE_CODE).
>=20
> "under the BQL"
>=20
> >        */
> >       int64_t speed;
> > @@ -66,7 +66,7 @@ typedef struct BlockJob {
> >       /**
> >        * Block other operations when block job is running.
> > -     * Always modified and read under QEMU global mutex (GLOBAL_STATE_=
CODE).
> > +     * Always modified and read under BQL (GLOBAL_STATE_CODE).
>=20
> Ditto,
>=20
> >        */
> >       Error *blocker;
> > @@ -89,7 +89,7 @@ typedef struct BlockJob {
> >       /**
> >        * BlockDriverStates that are involved in this block job.
> > -     * Always modified and read under QEMU global mutex (GLOBAL_STATE_=
CODE).
> > +     * Always modified and read under BQL (GLOBAL_STATE_CODE).
>=20
> Ditto.
>=20
> >        */
> >       GSList *nodes;
> >   } BlockJob;

Will fix in v2.

Stefan

--rAX955JzN10OrQ/Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmVo8n4ACgkQnKSrs4Gr
c8hqqggAtuleOhegca1BHCQqICnBO4Olum6obo9K4B6RhmNaK9kIfqeO3kNFY9K0
xy7SGfNACel07j3Lttl6p+xHJOe1zaE7IV2o9jKqMK0J09vpTZSXq06ssaTJrYZn
p2hGeneWnTJU5O3qUpotRsBp19PdMJLL3o2V7fJ+FRmE+0bc1KTCfzaIDC0IWFQD
rc5d8Et49WwA+aKWhDsn3GeRlvfxIxk/TFHsfdkLSdpU/LVU9lP/ExNVLqwYTNl9
OChcXKr+5mvuONgflXwub4uzX8FbIS/HoPIIC7uBG5xE+gao+EYmNRXVFFHRC+CP
/rjI7iW5qJHCSKa8tj2XY0KwbTSlcQ==
=hoap
-----END PGP SIGNATURE-----

--rAX955JzN10OrQ/Q--


