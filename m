Return-Path: <kvm+bounces-56599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E8318B40639
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 16:10:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11FF6205585
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 14:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD7E42D8DC0;
	Tue,  2 Sep 2025 14:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H9UWft1a"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFF62DAFA1
	for <kvm@vger.kernel.org>; Tue,  2 Sep 2025 14:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756821894; cv=none; b=Iwxq+xtGoTJdC27eZKktmOMkh3ogQZazK1nRwnhCjRXHoFmTLG/mB5rsAHSN2ePXEgZM0X+aD906a8uBbV3GHrikEdwsEuLC4pYXp9BcfJrice5NtxGzR7lvpzE/nSG8zHDqkAVySaRBKRTvfhFvbm3a5jBv7PJhMz6Sim8l82Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756821894; c=relaxed/simple;
	bh=imSmzS1HpbN7hf/PUqCKVoiFzWrqt83yGtcpbv3BkeY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dCkfr9ldtB8TTB2s2F8p+TApO1v0Xf+ztIXMEcKtPhemhRq6dO/Hqy6pQsDkmUWIQp7lG0V4BxjJ/1fo0aQ/PjBNtst6g7+DWibo4ss/gEZw6y/j0DL49bVZrE8BD4YUQ64Ld3iqGmK+2IKGHOrIMSoWDAwg/tDLgrcM1pmKFHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H9UWft1a; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756821890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=27FljAt8ZgnHBaHsGm/oVGEpRbHzo1W6WqsKJicY7Co=;
	b=H9UWft1akMBrEZqyFFOx1zaE2nqojvsMgjjWN24K3avzwHxTlCXtVmCTgti7o/lnHzkJvc
	SI+h/12iYB+S3CXRTu0dU3xg8Y/TzTH0527V7KWrLOpifNNSStGBtTPA3HnbnalwOAgyj0
	lxdHcucBOZh06yTHRhC/tCQ25CKWXJc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-568-EHE_RY8AN6K6UBR2AsQ1aQ-1; Tue,
 02 Sep 2025 10:04:47 -0400
X-MC-Unique: EHE_RY8AN6K6UBR2AsQ1aQ-1
X-Mimecast-MFC-AGG-ID: EHE_RY8AN6K6UBR2AsQ1aQ_1756821885
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5CC4A18009C7;
	Tue,  2 Sep 2025 14:04:45 +0000 (UTC)
Received: from localhost (unknown [10.2.16.110])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4F47F19560B4;
	Tue,  2 Sep 2025 14:04:44 +0000 (UTC)
Date: Tue, 2 Sep 2025 10:04:43 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
	qemu-ppc@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Chinmay Rath <rathc@linux.ibm.com>, kvm@vger.kernel.org,
	Glenn Miles <milesg@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
	Markus Armbruster <armbru@redhat.com>
Subject: Re: [PATCH v2 3/3] docs/devel/style: Mention alloca() family API is
 forbidden
Message-ID: <20250902140443.GD80770@fedora>
References: <20250901132626.28639-1-philmd@linaro.org>
 <20250901132626.28639-4-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="BiY07yRuXfrm8PrN"
Content-Disposition: inline
In-Reply-To: <20250901132626.28639-4-philmd@linaro.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12


--BiY07yRuXfrm8PrN
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 01, 2025 at 03:26:26PM +0200, Philippe Mathieu-Daud=E9 wrote:
> Suggested-by: Alex Benn=E9e <alex.bennee@linaro.org>
> Signed-off-by: Philippe Mathieu-Daud=E9 <philmd@linaro.org>
> ---
>  docs/devel/style.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--BiY07yRuXfrm8PrN
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmi2+XsACgkQnKSrs4Gr
c8iAwQf/e8ZkuM4Kmn7cSoCj+cUMi2jtFYQWeKJq0Y7z/9BLtCqV4pNVCJUKcLpv
9D3937e+5nMqErDCuQuGC0JT7T+NIC0TiO5CwKSgSJG/e+S8J/btrOE09mAVnS0i
pbXGPSWQHxgoM3tDIB56vRfwWBP12VcF55grM+UmCHKupVaAgVKt2A8S8HmbEYgL
wpSS1vIG4Ya3xLfaZjWs2cJka206MzLv9GeDkxw+Jc6jojFgfn0R2oCVzsyFU76Q
ldfVimbD5pNZkfjhfOnn4INZxl1aGi+Lt96RPZpzAOzKz97CfCPd3L00KrdOIBYp
cXJcOTMsF3f/iX5ShnKS3EyWDJHoaA==
=SKK2
-----END PGP SIGNATURE-----

--BiY07yRuXfrm8PrN--


