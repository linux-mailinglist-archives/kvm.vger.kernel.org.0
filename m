Return-Path: <kvm+bounces-43740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 76953A95C47
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 04:43:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 42B6F189299F
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 02:43:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51FBF185955;
	Tue, 22 Apr 2025 02:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="V2sBaJpa"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2EA33C9;
	Tue, 22 Apr 2025 02:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745289798; cv=none; b=c2IuNHlXiEdi8rz49ye6Il9V06vjElV8cjRADDyce81XbSDl8Uyx0OexD0Ku3KmRyCTUufeHzH637M7oX5KI2Dr1Kx8QKQodg3RPPBf/f2Dzv/M4u1Ooy2DKiY4W03z76d06uGZQTvM1BFSEAWTNRjXnO80E0kr4igOmSyhjcjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745289798; c=relaxed/simple;
	bh=TJfQO+DshFOJkto2hWQcgDo93KVaWTH1PQ+Ax9cD2qg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=PeNkGH9sHShYfzBFL1juU9L4i47liYTRHTaRMek9e5EsSkzEVYlI6Vi4UbSPff9Wx4owoMpmOjlXOo2EdJ4kV8tKSgPXb7uEqQZ7iZ1KHfZ7AnXKgGaP7y5ETVsxqGBHFm9lymZZvn7DasuxmEC2RYzYb61QJBQdurA1bBY6PiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=V2sBaJpa; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=202503; t=1745289790;
	bh=DVluLmRCk8ERoH1K+KEao07gB+Gu6l/bbm5Re1+V0vk=;
	h=Date:From:To:Cc:Subject:From;
	b=V2sBaJpa/Z367VwJB+LVFBysrES2uWyoK80qt0Tc8skiGt4EC0stXKihlyJrVYSG2
	 NAYTNXZqvFM1gWzuic1FzbAbvRjkR1Pjl5IU6EeEByw3m/7HZP6zcvSoREUzlNpBXI
	 QTNLUhodPwQtfjr4vaVL6HGrYRH4mN4sF3gcTomuO2TXOHowbSgiAnG7D5ns8aa/ik
	 WEtj2UPPl7x6j6CN8awEOfJCg1qeiln9MZg3UG8bl30vBfB6oPo7zst1Fducrgz8lj
	 tALbxeSgO74wn495NAMyDPXVIeELIL0IQRP5Q6PLEGkYrGirjPWg7FRpWd+/ll9bwh
	 MMX6O5k+j5tJg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4ZhRPB5HhYz4wnp;
	Tue, 22 Apr 2025 12:43:10 +1000 (AEST)
Date: Tue, 22 Apr 2025 12:43:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the kvm-fixes tree
Message-ID: <20250422124310.2e9aee0d@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/b+zvbcCTedLmAmzK9u=mk7I";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/b+zvbcCTedLmAmzK9u=mk7I
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm-fixes tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: modpost: "kvm_arch_has_irq_bypass" [arch/x86/kvm/kvm-amd.ko] undefin=
ed!

Caused by commit

  73e0c567c24a ("KVM: SVM: Don't update IRTEs if APICv/AVIC is disabled")

I have used the kvm-fixes tree from next-20250417 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/b+zvbcCTedLmAmzK9u=mk7I
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmgHAj4ACgkQAVBC80lX
0Gw7iAf8DDOhycy17JVB2w14DpVbtnmNG/Spy/e0AxaG1Sx3n1ILQh34MKfAmqOh
eSNNIgwaZ89NYBDdN1DZy2MRpDN1PVkCR9L7KPaM1b2YbnohhLV1+d3eCIpYtm2L
CZwMwgIpAdjgx7zs/8hte64pGJyoEv6Y7+0fXwsEsTl2Iz8P/4ybuS9LQ+GubDTu
W9Yd/RCS1XgglC5hgyyVj4kjJub/u9EbzMmdRic74rqOcvkgQoLM8Nbz6oPYQeBP
sCaeL8qP4wk5E2+sBWgktMl5mHTGVCclkEKTH66JHHyh1k+YfOn9mQIKWgPE3zoi
K5t2kFmZQfFJ1LazKIWpPNc9Q1WR8Q==
=B4eX
-----END PGP SIGNATURE-----

--Sig_/b+zvbcCTedLmAmzK9u=mk7I--

