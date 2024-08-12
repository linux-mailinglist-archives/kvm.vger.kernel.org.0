Return-Path: <kvm+bounces-23868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 125B894F1D9
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 17:34:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1B50282CD5
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 15:34:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A32CD186E20;
	Mon, 12 Aug 2024 15:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EcrKxlnY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C171862B8
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 15:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723476827; cv=none; b=TFxUcjj+1tvrA75DiIgIsk/AIo5GwBv/E4YfDCUDI0hD5B1rPPX0sBKV8J4vtPUbP848iuJCN1sQB+ZxKtpL/Hymt1jWmS/1bOcf+NaiVSghwGjxml2lnWXz2d6MCUmY+gxgUBTFK5svFl+NlSV8ue6Yw7o3xAdXN72Z5ISBFxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723476827; c=relaxed/simple;
	bh=nf2yU2C1LEGJzdcmbC4AxnJr1pfzUWFKKBYNrs6KMkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lvf/5DQJXeCHWGMvnw1vHiUUbfqatSgqiKBUTyutP+Q5Zyxtp9oJOmIdibaP1xFLmUUI5HByzw5/kF77lrawJxA7phqf/ui2kCtD5h6YM1R/2ENt/8fajzTAVCJnQMt+8vcSkTLNd3/6j7D7COIMXSPkmSybyVvaOExGU39NG4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EcrKxlnY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723476824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ISivz3QVMK0YqxtQGiH1IzKubmSDjlJgV/Bsw6ZYd84=;
	b=EcrKxlnYr+ADEfbWhQZ6G8RUSq8DUOa9zs1FQfJ431bwPck21zpW2ZvNDHQCiljKK5Mj8T
	CjQiZkbsXi7Hee+KXyuJCFiSTylriag6wjmzfGX5vIhCUKL1pmjI3JWdLkREtW0Tgf4sgw
	nB0vch8s6i62I5JmM5xajlp1sHemch8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-hZOD2NFPOYmWp3CtGIkzqw-1; Mon,
 12 Aug 2024 11:33:41 -0400
X-MC-Unique: hZOD2NFPOYmWp3CtGIkzqw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 49BCF192DE39;
	Mon, 12 Aug 2024 15:33:40 +0000 (UTC)
Received: from localhost (unknown [10.2.16.252])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9D9B719560AE;
	Mon, 12 Aug 2024 15:33:39 +0000 (UTC)
Date: Mon, 12 Aug 2024 11:33:16 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Claudio Fontana <cfontana@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	Dario Faggioli <dfaggioli@suse.com>,
	Fabiano Rosas <farosas@suse.de>
Subject: Re: [PATCH] tools/kvm_stat: fix termination behavior when not on a
 terminal
Message-ID: <20240812153316.GA68729@fedora>
References: <20240807172334.1006-1-cfontana@suse.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="h4vvNh8u369CmSpy"
Content-Disposition: inline
In-Reply-To: <20240807172334.1006-1-cfontana@suse.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12


--h4vvNh8u369CmSpy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 07, 2024 at 07:23:34PM +0200, Claudio Fontana wrote:
> For the -l and -L options (logging mode), replace the use of the
> KeyboardInterrupt exception to gracefully terminate in favor
> of handling the SIGINT and SIGTERM signals.
>=20
> This allows the program to be run from scripts and still be
> signaled to gracefully terminate without an interactive terminal.
>=20
> Before this change, something like this script:
>=20
> kvm_stat -p 85896 -d -t -s 1 -c -L kvm_stat_85896.csv &
> sleep 10
> pkill -TERM -P $$
>=20
> would yield an empty log:
> -rw-r--r-- 1 root root     0 Aug  7 16:17 kvm_stat_85896.csv
>=20
> after this commit:
> -rw-r--r-- 1 root root 13466 Aug  7 16:57 kvm_stat_85896.csv
>=20
> Signed-off-by: Claudio Fontana <cfontana@suse.de>
> Cc: Dario Faggioli <dfaggioli@suse.com>
> Cc: Fabiano Rosas <farosas@suse.de>
> ---
>  tools/kvm/kvm_stat/kvm_stat     | 64 ++++++++++++++++-----------------
>  tools/kvm/kvm_stat/kvm_stat.txt | 12 +++++++
>  2 files changed, 44 insertions(+), 32 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--h4vvNh8u369CmSpy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAma6KzwACgkQnKSrs4Gr
c8hNIgf+IBtgVOhpHP/PelURMNl6b0OoqRxILDdybVHk4o717W1mGy+kTDbxbFCV
XajPoViIU3bMZmpM5EfkNv25hzkGC9PkInu0FAlQQP5qTwmD6tpx82byD8FFl/pY
KlSL8bOLjDSHI+xJOG26hBRhcBEFeglXWaixKXfAGW/5xjGRTMWEGGlehLMlkWzh
mqm/gztRwqIK7INqj/nIbt6hsjwt9Ly5/JMQgcO5mcvvoPmaEmfSAJwjODrfwfbM
uZkGy4UYNDypBnz/R6748GwG2H1agmeXIwVq9lCrxgBWrZCdEpcNY2y7z0cMruSK
cJY4dc3YiwSs8saEXQq9gKBqrQYj7Q==
=wVWm
-----END PGP SIGNATURE-----

--h4vvNh8u369CmSpy--


