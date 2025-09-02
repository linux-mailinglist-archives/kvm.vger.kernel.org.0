Return-Path: <kvm+bounces-56600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50C5EB4063B
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 16:11:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 451111715C5
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 14:05:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ECCB2882DC;
	Tue,  2 Sep 2025 14:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RyvNESov"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B55026CE2A
	for <kvm@vger.kernel.org>; Tue,  2 Sep 2025 14:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756821931; cv=none; b=Des2qPlPohSfGSX4bWDwu13xf62pnSauzo3VMjKoN1L+vxRSFmTL9BQR1P6Mt+TH1nLfxU9f5ILSXvjJR6ZhZQ7rA5dLtU2NkU2osXfpgX3pZXkx4TnyFyBLLBEft81UA3k5POf+86xmrxP+Uj/Nu4upBo1zl9uL/v2fNGaloEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756821931; c=relaxed/simple;
	bh=PwUQnu+wLL8onkmCVUP+5m5RJjNDrAbL6abi+EGBeXY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lEi9nO6ND3jrgqk0LcYWZwwGGlC+guWBNhWRZzj276Mj0X9uyLFqv8Vx0R1CFAfradyGseP3i8ok2RH8/l++5ZH41UfdDM8LCY7esMnoyFGl5Pg7EQHnPHiXisAk0mznwlF3UwG/85DqbqwXNmmlqWgZe52fGsYSjDC/eKzu3Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RyvNESov; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756821929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BHe4X/K6k3rkK/u0AV7eJP1IQOoAyGnryLMjjYMWfYQ=;
	b=RyvNESovtEIBimpPnO1i9H4hgKdoPxXbZNPxvDhxOD9kHNcv0fIDGdp1nEb8FJjNbPZqYX
	aCkXHuN4h37zoVHyNpuEDRspbtFF3bmnmCnx1ThvYCG24EHupYr3BuPvetBLRBF2yalTi4
	nfXr++Rq4cZfgMrAPmYaOuGg2aqEk9M=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-257-ylBzQdvwOtSJo9ZzSB5AIQ-1; Tue,
 02 Sep 2025 10:05:24 -0400
X-MC-Unique: ylBzQdvwOtSJo9ZzSB5AIQ-1
X-Mimecast-MFC-AGG-ID: ylBzQdvwOtSJo9ZzSB5AIQ_1756821919
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E8F9180044F;
	Tue,  2 Sep 2025 14:05:19 +0000 (UTC)
Received: from localhost (unknown [10.2.16.110])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 98BC2180028B;
	Tue,  2 Sep 2025 14:05:18 +0000 (UTC)
Date: Tue, 2 Sep 2025 10:05:17 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
	qemu-ppc@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Chinmay Rath <rathc@linux.ibm.com>, kvm@vger.kernel.org,
	Glenn Miles <milesg@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Subject: Re: [PATCH v2 1/3] target/ppc/kvm: Avoid using alloca()
Message-ID: <20250902140517.GE80770@fedora>
References: <20250901132626.28639-1-philmd@linaro.org>
 <20250901132626.28639-2-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jd0fcGbAJA6igup7"
Content-Disposition: inline
In-Reply-To: <20250901132626.28639-2-philmd@linaro.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111


--jd0fcGbAJA6igup7
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 01, 2025 at 03:26:24PM +0200, Philippe Mathieu-Daud=E9 wrote:
> kvmppc_load_htab_chunk() is used for migration, thus is not
> a hot path. Use the heap instead of the stack, removing the
> alloca() call.
>=20
> Reported-by: Peter Maydell <peter.maydell@linaro.org>
> Signed-off-by: Philippe Mathieu-Daud=E9 <philmd@linaro.org>
> ---
>  target/ppc/kvm.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--jd0fcGbAJA6igup7
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmi2+Z0ACgkQnKSrs4Gr
c8h3sgf/eoM1bEv4uB6rZVlcxL1mnhvRmYV8QDeYpJGUN5TqRW7ahmJlv7PihWIh
/UdnUjXYbpp+wPhP5p8MFcHOWmazYha17z7q99Kyd0bKLnUR+WvPTJFGzSClSUKf
6D1yaGNzrrbidJoZ3xC9BJC+3yz6B9I4BNYg0Z9htdjIYkQtuuR88+Zx+Fj2jDWO
ZPsB7iq0XrUoF8kVB7J8dXcL5rs+nK5rfGVUlAe7D7D6h9wN0uQxCPReVqlNh3Jr
3dJbVDu6AClCkAj4fNU5q0L+R14ci/3vGLY9Qy4jtv+zxSeC4QY5+qfnV4j52In5
JLT1YGlDCBa5XfJDERQCbVR4Wcd5qA==
=MiVV
-----END PGP SIGNATURE-----

--jd0fcGbAJA6igup7--


