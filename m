Return-Path: <kvm+bounces-23538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DE5094A8BA
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 15:38:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4CC9289C1B
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 13:38:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3308E201268;
	Wed,  7 Aug 2024 13:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZlEuGnLb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44C81E7A4A
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 13:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723037856; cv=none; b=pZyaKM6ez53165y3Hoy2DY1Bd9GF5JlyuLuoik+fsbTtgdafGW5wrpAufEbllcMpwQXGwQck5ZLnBlIi48N58zK6DkDi+x67NkZEvjBac4o41K14fbEdRbFo4Pi7JoR7BQSKjavbAlvMTO3dlheICfUcpoE2pSyjsnqbBxYYA7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723037856; c=relaxed/simple;
	bh=AH5u9Prl1rkLsQ1Kf8FoyAoSa8IfInzLpyaiM4il+EU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j8xuZH56Vwdtdgmb46neP3h080twgyaAh7WoyXNgiGcoOobijp4fCiR03uubkMVATUIkn3oIk0fnOTvJQoecIS7N4wF1ZksTq/dwgsgiaxb8IX7SEGhTeJQeY6iQcTbs+UwRoJAb6SR6WDhAGjde0cy2p/vIsXxqiqwrMynR6nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZlEuGnLb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723037853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CXtghNOz3y4xEz92upQOZ8I4uzio8wn2w5m97HXYVt8=;
	b=ZlEuGnLbntDTrpE0P09Xqe70uSx+5xr7mCjD/7lCzOCXGmmgAiHBzH/H099v7QNlxUZ+DS
	wL7natvBnKIOoC61zCgBvKs8UPKRRPjnSOgJ3Yk54Rte/2Vyd4T1/sV9rO4wt+tvFNTXgV
	JjIpko1NRv/PD5RvWgx/m5XRR81HwDo=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-673-MQ802H5FO1mEv5LTuqiT9w-1; Wed,
 07 Aug 2024 09:37:30 -0400
X-MC-Unique: MQ802H5FO1mEv5LTuqiT9w-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 531061944B2C;
	Wed,  7 Aug 2024 13:37:29 +0000 (UTC)
Received: from localhost (unknown [10.2.16.129])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DFC4A300018D;
	Wed,  7 Aug 2024 13:37:28 +0000 (UTC)
Date: Wed, 7 Aug 2024 09:37:27 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Claudio Fontana <cfontana@suse.de>
Cc: kvm@vger.kernel.org
Subject: Re: kvm_stat issue running in the background
Message-ID: <20240807133727.GB131475@fedora.redhat.com>
References: <f21ffdee-1f29-4d89-9237-470dad9b0ef9@suse.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="198BXQKJrW15q+Hs"
Content-Disposition: inline
In-Reply-To: <f21ffdee-1f29-4d89-9237-470dad9b0ef9@suse.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4


--198BXQKJrW15q+Hs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 03, 2024 at 11:23:21AM +0200, Claudio Fontana wrote:
> Hello Stefan,
>=20
> did not know where to report this, but the man page mentions you specific=
ally so here I am.

Hi Claudio,
I wrote the man page for kvm_stat(1) but am not the maintainer of the
tool. I have CCed the KVM mailing list although it's possible that no
one actively maintains the tool :).

>=20
>=20
> There seems to be an issue when kvm_stat is run with:
>=20
> kvm_stat -p xxx -d -t -s yy -c -L FILENAME.csv &
>=20
> specifically due to the ampersand (&), thus running in the background.
>=20
>=20
> It seems that kvm_stat gets the interrupt signal (SIGINT), and does write=
 as a result the output to disk,
> but then instead of terminating, it just hangs there forever.

That is strange. The only signal handler installed by kvm_stat is for
SIGHUP, so Python should perform the default behavior for SIGINT and
terminate. I'm not sure why the process would hang.

>=20
> So to avoid ending up with a large number of kvm_stat processes lingering=
 on the system,
> we needed to put a random sleep, and then send a SIGTERM to terminate the=
 kvm_stat processes.
>=20
> Just sending a SIGTERM (without the SIGINT) does terminate the kvm_stat p=
rocesses, but NO DATA is written to disk (the files show as 0 size).

That makes sense since kvm_stat does not handle SIGTERM. The default
SIGTERM behavior is to terminal and any output in Python's I/O buffers
may not have been written to the file.

Maybe kvm_stat should catch SIGINT and SIGTERM. That would give it a
chance to write out the log before terminating. Do you want to try
implementing that?

>=20
> This is the workaround script that we currently have:
>=20
> ----
>=20
> #! /bin/bash                                                             =
                                              =20
>=20
> VM_PIDS=3D`pgrep qemu-system-`
>=20
> for VM_PID in ${VM_PIDS} ; do
>     # warning: kvm_stat is very fragile, change with care                =
                                              =20
>     kvm_stat -p ${VM_PID} -d -t -s 1 -c -L kvm_stat_${VM_PID}.csv &
> done
>=20
> if test "x${VM_PID}" !=3D "x" ; then
>     echo "launched kvm_stat processes, capturing 10 seconds..."
>     sleep 10
>     echo "signaling all kvm_stat processes to write to disk..."
>     pkill -INT -P $$
>     sleep 5
>     sync
>     echo "signaling all kvm_stat processes to die..."
>     pkill -TERM -P $$
>     echo "waiting for kvm_stat processes to exit..."
>     while pgrep -P $$ > /dev/null; do
>     sleep 2
>     echo "still waiting for kvm_stat processes to exit..."
>     done
> fi
>=20
> echo "Done."
>=20
> ----
>=20
> Feel free to forward to the appropriate mailing list if needed,
>=20
> thanks!
>=20
> Claudio
>=20
> --=20
> Claudio Fontana
> Engineering Manager Virtualization, SUSE Labs Core
>=20
> SUSE Software Solutions Italy Srl
>=20

--198BXQKJrW15q+Hs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmazeJcACgkQnKSrs4Gr
c8jDfggAh53gemLACTNJgv/5/uCV0Y8L4l9TSjoCZPoPgzdfzTeDdwvl/W8h02bc
cFH9CDr7RFEClu2XMQzurnZq21iojmOXSNJk+BXQPHpTJlKXN3Lcc72N2hbDPEgh
BgE5Tm44b1wrJe7Q68SUNEgApr8rpMvXp2pOTwQg68sMVvZtW2XDxSdENnhGBaOm
Q3Pa9l4XtoS26s32suYZm8HaKt+RCDxhkPMdQJw1gVWQtq449/OMpjT3FCYsW8/T
LJFIWrQz8qj1q3XE9cC7UVY3C44OFvrrrQtmkMns27WX69tp4yYZYmYYdp+1//4x
pNz+FMCSyS+OAJg8wzU7ZssQb217sQ==
=Gruk
-----END PGP SIGNATURE-----

--198BXQKJrW15q+Hs--


