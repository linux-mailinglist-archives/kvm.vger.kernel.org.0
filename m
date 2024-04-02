Return-Path: <kvm+bounces-13394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD7FB895DC4
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 22:35:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 42FC21F26FE1
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 20:35:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DCA215ECE0;
	Tue,  2 Apr 2024 20:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ABEi68is"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26AC15E7F9
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 20:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712090056; cv=none; b=oopsbs+qI6mL+tWZwNrlqQGNWgA5b+2i2woosrukJdpyAxiRoEt13N9CSrR80gRtlGYKaB5Rb1ImVSBqEABFdCI9kUpf87w+LJ5L/W/2Q4gp2WalWpdB8pmGu4JjW4rScUUbdtY1KtP3QNipNax1uEhGOzg598/1pHlfQ7v0dQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712090056; c=relaxed/simple;
	bh=bmmXl9802fqjQBn/Jkyn+cPSqGGb+PgZV0INCHN8xQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QYgeIEtb7FdtHtKDrb+PiGzEGhUHZhacec7FnZfjTMlNl75GGMwbo6TuQZka8avZyb1Z6WWQ9Tud813525MDgHcjGTkGxmjG5XT7Pylogw6WM5/tTcW5Y7Dg6WoVpqu8Qpag6L56GwBCXJi/TT/NZZQydzYP0EhvxudHhBoNJrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ABEi68is; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712090053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k+RL3GcJX3cDss5q+sY+fk2hjsigjZNfwAD2FrDBS7E=;
	b=ABEi68istgfKk6hVhOX41p1GtVsQdV72P3MPDfSzOrBgX/unO8Mx6dzD/ld5BlQX9O3y0o
	WnhBm4eWrR9EpAatsWi0hR2F702ZTujzoL8BLU1OWB2hmHf5Ma7OgwXD03WTpGRCwphgLu
	GpywN1cOZUsaFMBJeMatx696P4iqmkk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-508-hGfxmj0VPgOOtA_C43PRWw-1; Tue, 02 Apr 2024 16:34:10 -0400
X-MC-Unique: hGfxmj0VPgOOtA_C43PRWw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6CEA85A58B;
	Tue,  2 Apr 2024 20:34:08 +0000 (UTC)
Received: from localhost (unknown [10.39.193.21])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9B5012166B31;
	Tue,  2 Apr 2024 20:34:07 +0000 (UTC)
Date: Tue, 2 Apr 2024 16:34:02 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jonathan Corbet <corbet@lwn.net>,
	David Hildenbrand <david@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Paolo Bonzini <pbonzini@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Amit Shah <amit@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Gonglei <arei.gonglei@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Viresh Kumar <vireshk@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	David Airlie <airlied@redhat.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Daniel Vetter <daniel@ffwll.ch>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Alexander Graf <graf@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Kalle Valo <kvalo@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
	Anton Yakovlev <anton.yakovlev@opensynergy.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	virtualization@lists.linux.dev, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-um@lists.infradead.org,
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev, netdev@vger.kernel.org, v9fs@lists.linux.dev,
	kvm@vger.kernel.org, linux-wireless@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-remoteproc@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	alsa-devel@alsa-project.org, linux-sound@vger.kernel.org
Subject: Re: [PATCH v2 23/25] scsi: virtio: drop owner assignment
Message-ID: <20240402203402.GF2507314@fedora>
References: <20240331-module-owner-virtio-v2-0-98f04bfaf46a@linaro.org>
 <20240331-module-owner-virtio-v2-23-98f04bfaf46a@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="SdnH/2DvDGR9ROwI"
Content-Disposition: inline
In-Reply-To: <20240331-module-owner-virtio-v2-23-98f04bfaf46a@linaro.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6


--SdnH/2DvDGR9ROwI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 31, 2024 at 10:44:10AM +0200, Krzysztof Kozlowski wrote:
> virtio core already sets the .owner, so driver does not need to.
>=20
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>=20
> ---
>=20
> Depends on the first patch.
> ---
>  drivers/scsi/virtio_scsi.c | 1 -
>  1 file changed, 1 deletion(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--SdnH/2DvDGR9ROwI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmYMa7oACgkQnKSrs4Gr
c8i1eAf+MLJRFV0ReS0TcAxQ+rR1jKUab1SBLeUTszPuKgXc/iozA1gMDlecO6Va
kcBlhSRh2WIBmWmb/Zixp1fhkCo2yQjvOS2t4x6po9gH4YxAhUGTfsCGVK6TDTeI
MxEodu79iPW81/dZ0Sz4XxNKTWN0UKwdDDxivNVfAjGKRX7Ug7ojT1bY04/UH+B7
M6G/LYvcqIQPuU90RkeZYDxV8odWVMnyresdB4gVZMZ2J91//XRuJBl294JTil+P
dQLKeFSnoXA002bIy+vlZUhxz8fANlOWqe5+TedLa/S/1FB+cDjQY6plBLIIEYSs
0XHoSaVTwf2D+3pavZKFIL1sIWbMNw==
=BxEA
-----END PGP SIGNATURE-----

--SdnH/2DvDGR9ROwI--


