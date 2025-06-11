Return-Path: <kvm+bounces-49096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D06DEAD5DFD
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 20:17:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 953A0178266
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 18:17:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E20527CCF8;
	Wed, 11 Jun 2025 18:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IzSW3ppB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F299B1ABEA5
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 18:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749665840; cv=none; b=BWcNZf5OrlRdNTXP5nl/VeUyQ0pWoS07VowXZ1tDVRQrf4xUQhquhVM24Pef1ogf2hYRIctOu/GXybdsJHk1drvaSWtlcMRl9G9r8T0vF+4XBQnq5smmUZQm6UgH9UJVrWY3b89FlIhw0uU0sWCIiC+zadbUTMXKXXqLvYHovRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749665840; c=relaxed/simple;
	bh=1c4s7Lji5Nnz3Z5x1vCWg8zk5kajAvQcU8JPpA7A1ZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wgc4Qqd9dZ1lqs6Bb29Ci7JZ8bu+99LeccvGW9Gs9IVF1zJMFy2uy5VETzVc/bPCKaE6ccDTb/CtTxzZkPU0dUhLQi+8JuVgrqpGveDZELXhFnqARqG/TfkQB8oq2euWYrtGv3xAD1+OLwHCiyKNTAeq4jQ1/RYZ/RvDlAQTMl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IzSW3ppB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749665837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1JMhrtoc6VGTvPWyUNfrznOPKUCtOzmnixDC1vIpkrE=;
	b=IzSW3ppBcyk7ShPRGfI402IB4PI8oX2pVUDyeW2hT3T5ei5tmNwlWkptZsgAX4ZxNbz0Vp
	kec2xmr9EXlQlhe0AHGjp2NVvg/mImAGXYKySi0rwm1IBbGs+3AUeZR2dyazOVCuKy7LYz
	rD6cgN1gDlwoteVRaa2+Krz8wsuhZb8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-149-gtno2Wf_M-iaVTwhr2GpoA-1; Wed,
 11 Jun 2025 14:17:13 -0400
X-MC-Unique: gtno2Wf_M-iaVTwhr2GpoA-1
X-Mimecast-MFC-AGG-ID: gtno2Wf_M-iaVTwhr2GpoA_1749665832
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 643A11800289;
	Wed, 11 Jun 2025 18:17:12 +0000 (UTC)
Received: from localhost (unknown [10.2.16.122])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 93C0219560AF;
	Wed, 11 Jun 2025 18:17:11 +0000 (UTC)
Date: Wed, 11 Jun 2025 14:17:10 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: mst@redhat.com, jasowang@redhat.com, michael.christie@oracle.com,
	pbonzini@redhat.com, eperezma@redhat.com,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	darren.kenny@oracle.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vhost-scsi: Improve error handling in
 vhost_scsi_make_nexus and tpg
Message-ID: <20250611181710.GB190743@fedora>
References: <20250611143932.2443796-1-alok.a.tiwari@oracle.com>
 <20250611143932.2443796-2-alok.a.tiwari@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="UaYLH/pZI3CB/ihz"
Content-Disposition: inline
In-Reply-To: <20250611143932.2443796-2-alok.a.tiwari@oracle.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12


--UaYLH/pZI3CB/ihz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2025 at 07:39:22AM -0700, Alok Tiwari wrote:
> Use PTR_ERR to return the actual error code when vhost_scsi_make_nexus
> fails to create a session, instead of returning -ENOMEM.
> This ensures more accurate error propagation.
>=20
> Replace NULL with ERR_PTR(ret) in vhost_scsi_make_tpg to follow kernel
> conventions for pointer-returning functions, allowing callers to use
> IS_ERR and PTR_ERR for proper error handling.
>=20
> Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
> ---
>  drivers/vhost/scsi.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--UaYLH/pZI3CB/ihz
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmhJyCYACgkQnKSrs4Gr
c8jsnAf+LyyAkSoBI7A+MjiUFeFjRBvGlsTqBrICWJL8lwGcy8xUuQSzQVJeyZOu
baPKiWlkudJvy+kO8hEXMhhnD3bhRhcbV846F1Ql1cmLIYqdpwKjGZngmAqKVtpY
OVJ7iByOfZWEdD+/Yhn55cfK7gzhJYcFsAKy08e0DCdb2X5AGaMbFllhzNN836nL
ikBm1H66C80IAYYZdJfZeULJmoV8CEpL9A253hB4/aMoM3J93tj/5erd3r/IP6Ub
ypaFuPImR1/5vZEhNxxjEfyswdIUcEfd2Kw2YpvZ9eBZVPqjDhjN/9VHfW/USdih
2zNYY0AfVAzpKq1dhvZJDSaY85QrIg==
=ZF3e
-----END PGP SIGNATURE-----

--UaYLH/pZI3CB/ihz--


