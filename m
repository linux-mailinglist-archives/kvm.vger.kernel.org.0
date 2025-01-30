Return-Path: <kvm+bounces-36927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB649A2312C
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 16:48:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F28C16568E
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 15:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3940E1E9B3D;
	Thu, 30 Jan 2025 15:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="at2Nm7Au"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3091E7668
	for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 15:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738252127; cv=none; b=u63xixzOC6OngmGa85fM733SvEkPQKJ8CLP12lNNWyB/CUkqzaaqQHffAT2SrJm0KrOBGo0XY2HxBDBhuqe/XiochkYDunfgCZFREIcxSEhRVz3Fw3YTMTHnk/nGRa8L54pXDGU2NZMLBe0x2D5U5j78dSgFuiVWmrzmsBkFmvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738252127; c=relaxed/simple;
	bh=qrkZvwvg3OuouMLvaatKH0A8WnUk/82OCAf9pVTfo3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OguDVYAsJIRxX0myObT1RtdI4cD/rP9Lkg08LcKTTgJulziX4/R1efjo//j8SmmCWCujWzVRkUwu192rv2UHr1BWCRaqk4wdaT7ocHncQ9/zYBGXei+J+s6KZAe4erJ7V7c8po6n6+jZxOIiRk8OzVPhHHrI1+OFKy4PL36zINU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=at2Nm7Au; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738252123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hgx1GZ8+M8oa4YQkR4BkCJmoPBM2B6r3RMwPamOyFls=;
	b=at2Nm7Auc/Us0Ew/hc/edW2brqXYjAumAUY2b7lKdDh33V9SDm9m7kjTMr8l+MGY6GYAkf
	qYqufRJpg3moMo2kqyMCr+76ygIB5TMF/esxcI/kRRMaCcasUY96vMaoy6mkexmplwBDcC
	OSMhDRDUJUqsTYJS/OxeqNvcELlwykc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-6-lvdJVgEsMxerhUNdV_jlIw-1; Thu,
 30 Jan 2025 10:48:42 -0500
X-MC-Unique: lvdJVgEsMxerhUNdV_jlIw-1
X-Mimecast-MFC-AGG-ID: lvdJVgEsMxerhUNdV_jlIw
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1C80A1956083;
	Thu, 30 Jan 2025 15:48:39 +0000 (UTC)
Received: from localhost (unknown [10.2.16.138])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 43C7919560A3;
	Thu, 30 Jan 2025 15:48:38 +0000 (UTC)
Date: Thu, 30 Jan 2025 10:48:37 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Israel Rukshin <israelr@nvidia.com>
Cc: Max Gurtovoy <mgurtovoy@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Parav Pandit <parav@nvidia.com>, virtualization@lists.linux.dev,
	mst@redhat.com, Linux-block <linux-block@vger.kernel.org>,
	Nitzan Carmi <nitzanc@nvidia.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] virtio_blk: Add support for transport error recovery
Message-ID: <20250130154837.GB223554@fedora>
References: <1732690652-3065-1-git-send-email-israelr@nvidia.com>
 <1732690652-3065-3-git-send-email-israelr@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="p/RIuBFdBJg4RMjD"
Content-Disposition: inline
In-Reply-To: <1732690652-3065-3-git-send-email-israelr@nvidia.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12


--p/RIuBFdBJg4RMjD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2024 at 08:57:32AM +0200, Israel Rukshin wrote:
> Add support for proper cleanup and re-initialization of virtio-blk devices
> during transport reset error recovery flow.
> This enhancement includes:
> - Pre-reset handler (reset_prepare) to perform device-specific cleanup
> - Post-reset handler (reset_done) to re-initialize the device
>=20
> These changes allow the device to recover from various reset scenarios,
> ensuring proper functionality after a reset event occurs.
> Without this implementation, the device cannot properly recover from
> resets, potentially leading to undefined behavior or device malfunction.
>=20
> This feature has been tested using PCI transport with Function Level
> Reset (FLR) as an example reset mechanism. The reset can be triggered
> manually via sysfs (echo 1 > /sys/bus/pci/devices/$PCI_ADDR/reset).
>=20
> Signed-off-by: Israel Rukshin <israelr@nvidia.com>
> Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---
>  drivers/block/virtio_blk.c | 28 +++++++++++++++++++++++++---
>  1 file changed, 25 insertions(+), 3 deletions(-)

Acked-by: Stefan Hajnoczi <stefanha@redhat.com>

--p/RIuBFdBJg4RMjD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmebn1UACgkQnKSrs4Gr
c8j//Qf/Tv5y1Av+0bpdc9RvxLDX3Jslxlct66naW6zB5O2ZCtoOB9WGRyzNfpLM
dOq/h9PtzjcGf2H0+cJ3Wdq3ycp/4NPvl2yhDQGfbqExHP/E/rDXsBevKH+zyldv
yioc34WUgZA34CXGfsJryknxnaBv0rXfwB1xyV0o0I0XSDEkSUdFA7PoGvDAi98y
VJPcyNzABu3ACtRjCM2jWb5UyBGvitJJHdX1zjsnNaowQJhTKJy9qUD6iGbn8Qsn
UXuBVBbceAhGQPXz0UKxu35D2yNg09GMj9WI/3toZTJD77X2G1N+xJiIJmHkoRkB
Ws1c2IpQD2ua7FqvzHlhjI+ygA/6Ng==
=7B66
-----END PGP SIGNATURE-----

--p/RIuBFdBJg4RMjD--


