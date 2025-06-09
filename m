Return-Path: <kvm+bounces-48739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DB97AD2033
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 15:55:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 581071661CF
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 13:53:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF24C263889;
	Mon,  9 Jun 2025 13:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e/NF97Gy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94527262D14
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 13:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749476970; cv=none; b=FLbGqmh8GdUQFF6Gw0JvqstN8eoyCFZ3PkI5Y7daKn18FhMt+jcaFizV/CJUUqoX7Isk7Hzjjfb7Hyr+w4B3AjmHHTSqdyyX/wu/4e42O5FVCTwyCOn9YIiEAEz9acoPInmZ3apKHJKBwJjh93ZoeGz3YdyMd4Vs+YShUrT1Mqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749476970; c=relaxed/simple;
	bh=iNoS61OEsbcdQlABb8O+pgwQJJ1cN1tEonuvj6R1tk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dy97as6ZUyWG9B6b2uEAblcvTOXtEl969nTN809wfWbRSdII2TAuYn0k0vsz6owQp3XbFncOOu4nMdl/SHXSh92TfXgujMqkzo2cqdKflt+a6vwsPoSGlwObMWuqsyS3em4PXIedY57apy9SG509AP/+Lykn24vcDhDzCqBIuFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e/NF97Gy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749476967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DhBsIpSQu/NKsYwFg9wGKiohX1VuHWd2Yx6z4NZMEoY=;
	b=e/NF97Gy98IFgqMUPdIPcWM8EjNG367whbaI5vlUi8s0VR3vvk7IOyEdGRMSVQBgFczBX3
	7dGLnelGze9ixaRfSYsAvfIk7cCooowqKVACAAWIGLuVTuOWv2Y8qUtA4jldhQmm20hFm2
	EDRHtpxV+oE+a/ysbOdkoQ2ZN/OD5GM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-542-vn1MlWajNxSzx8MNAREzTg-1; Mon,
 09 Jun 2025 09:49:22 -0400
X-MC-Unique: vn1MlWajNxSzx8MNAREzTg-1
X-Mimecast-MFC-AGG-ID: vn1MlWajNxSzx8MNAREzTg_1749476955
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C72D3188EA6A;
	Mon,  9 Jun 2025 13:49:08 +0000 (UTC)
Received: from localhost (unknown [10.2.16.92])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 283EB19560B0;
	Mon,  9 Jun 2025 13:49:06 +0000 (UTC)
Date: Mon, 9 Jun 2025 09:49:05 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: mst@redhat.com, jasowang@redhat.com, michael.christie@oracle.com,
	pbonzini@redhat.com, eperezma@redhat.com,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	darren.kenny@oracle.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-scsi: Fix check for inline_sg_cnt exceeding
 preallocated limit
Message-ID: <20250609134905.GC29452@fedora>
References: <20250607194103.1770451-1-alok.a.tiwari@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fKc30he2vAi3wglk"
Content-Disposition: inline
In-Reply-To: <20250607194103.1770451-1-alok.a.tiwari@oracle.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12


--fKc30he2vAi3wglk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 07, 2025 at 12:40:29PM -0700, Alok Tiwari wrote:
> The condition comparing ret to VHOST_SCSI_PREALLOC_SGLS was incorrect,
> as ret holds the result of kstrtouint() (typically 0 on success),
> not the parsed value. Update the check to use cnt, which contains the
> actual user-provided value.
>=20
> prevents silently accepting values exceeding the maximum inline_sg_cnt.
>=20
> Fixes: bca939d5bcd0 ("vhost-scsi: Dynamically allocate scatterlists")
> Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
> ---
>  drivers/vhost/scsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--fKc30he2vAi3wglk
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmhG5lEACgkQnKSrs4Gr
c8h7EggAwgrah7g9s99SLzlFTYoWemYYpP3EqdHUzutA0bJbSpZTG7mLOsKvxs3M
s0ZoQzikIgYVgHtIZwZSlrv1kq1DQnL61WlDWESMWCfB6oX7W7BjAKu+nDt56tP0
p3qv2O/wsiMLQie8ES2criSD2tswseSmEMhCiBV8UWs+FA1IOXAG1BKyLhcGLqpo
aFp/YsYRUBRFTty4WlRxzkN2+10V86DjUYEnpDjZn1FedfLtDL4OQ4MczJR6u3U2
+cSQ2dJv/l2LHcVghYxrQJKDCEKUQoNzx20+UDd1Xg8/mt4FDO96G3G90mozLaZX
rhn64IwB/wBz8DaLJJIrr7CM04c3Jw==
=pLmm
-----END PGP SIGNATURE-----

--fKc30he2vAi3wglk--


