Return-Path: <kvm+bounces-25957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7963396DB95
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 16:19:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23FB61F27645
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 14:19:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C68911CABF;
	Thu,  5 Sep 2024 14:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G8XEziJ6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB9227715
	for <kvm@vger.kernel.org>; Thu,  5 Sep 2024 14:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725545877; cv=none; b=NsfG6xoT6q6jgJCrv1wmhbgugTkifPxUAx9dNgns32ho41phlHveTurgsnKGTxO1BZsDo294swpuw6LtHqTtipdyCtZHE51VXP5SxXh7faXwjhnfNem6dQsDPEhluXXqyDZfeArFyKRMlAwh+fHSHIHGv2HGCXO0pt40NJVW/z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725545877; c=relaxed/simple;
	bh=K+l9mMxcfSbXEO7japsfxlObUe3Pdx0hdSfrik3j3ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fkRjNQsJpdAhFfXFt2iXMKOpsHnjm0QahE1673y5o8Ypk5oVUNy28oWILNDiJHq8LeNC8VuNkrOS7rK66TV0vnbyzsVL5u6vzpeLe4mNXSgAsf0h8dhJ3f7sNF6gSynRFfRWSsxWP5ALX/0wP3irstIKOjpN5SVP5TgXBifaWuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G8XEziJ6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725545874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aI4n4X4EeQia228ZkrTYWhYjJj0SeU3OGZPxnQ2jneY=;
	b=G8XEziJ6hSS9Nd4vC7qEI3Er7SFiiER/t1ypTYfGCcMx6QQFyvjxdY6X3MRVyrpLIbz/ju
	eVYlcOYmDVkZiFVn/ikjHZ1G02bl99fBmuSLHGv0dQQmZGHj+NfIqJSN563jInu/nRrNaL
	310KCxTZOflO24UrgXF8fg4aTaEQRps=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-258-ae0AT1hMM2OsKvJhcI_BTg-1; Thu,
 05 Sep 2024 10:17:50 -0400
X-MC-Unique: ae0AT1hMM2OsKvJhcI_BTg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 72CDF195E93C;
	Thu,  5 Sep 2024 14:17:46 +0000 (UTC)
Received: from localhost (unknown [10.2.16.181])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B292D195608A;
	Thu,  5 Sep 2024 14:17:45 +0000 (UTC)
Date: Thu, 5 Sep 2024 10:17:44 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Max Gurtovoy <mgurtovoy@nvidia.com>
Cc: virtualization@lists.linux.dev, mst@redhat.com,
	Miklos Szeredi <mszeredi@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, kvm@vger.kernel.org,
	Jingbo Xu <jefflexu@linux.alibaba.com>, pgootzen@nvidia.com,
	smalin@nvidia.com, larora@nvidia.com, ialroy@nvidia.com,
	oren@nvidia.com, izach@nvidia.com
Subject: Re: [PATCH v1 1/2] virtio_fs: introduce virtio_fs_put_locked helper
Message-ID: <20240905141744.GB1922502@fedora>
References: <20240825130716.9506-1-mgurtovoy@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="PmPZWAVlJaaoA0L+"
Content-Disposition: inline
In-Reply-To: <20240825130716.9506-1-mgurtovoy@nvidia.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15


--PmPZWAVlJaaoA0L+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 25, 2024 at 04:07:15PM +0300, Max Gurtovoy wrote:
> Introduce a new helper function virtio_fs_put_locked to encapsulate the
> common pattern of releasing a virtio_fs reference while holding a lock.
> The existing virtio_fs_put helper will be used to release a virtio_fs
> reference while not holding a lock.
>=20
> Also add an assertion in case the lock is not taken when it should.
>=20
> Reviewed-by: Idan Zach <izach@nvidia.com>
> Reviewed-by: Shai Malin <smalin@nvidia.com>
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---
>  fs/fuse/virtio_fs.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--PmPZWAVlJaaoA0L+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmbZvYgACgkQnKSrs4Gr
c8gFJQf/dfAOvhA3E79RBsBGd6CmuOQagcK6ixD60cMHKFI/C2WM8VhBWyW9fVIm
FhQcYJRgxOPy9IkDGED3jbi+i9UFbKulo81tT/7kwEgHbTXxB9xMUJF/kKk24ls4
QbG+jkoeYnV98Dr/sJsHDXTntRVmYmSYdB/VRV5zmD9cmxBis3ixNIfjFA7Si9pi
Lmy8YdUuwSPK9BKRpzOGqJkQB/BEmMtcsiV/SxWpzppZIt97Cxcqn182ecETJMk1
KbmEwKGeyYHOqaU3bQQk337vwK/fzc+xi78T0ZzEaeEWwsXm+uvvtVb9ZpyWm4Y8
Qql3XQNfedb9NEh5boqMn8CuXy+nFw==
=UAVw
-----END PGP SIGNATURE-----

--PmPZWAVlJaaoA0L+--


