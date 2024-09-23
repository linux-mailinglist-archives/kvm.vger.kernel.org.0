Return-Path: <kvm+bounces-27283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A045597E517
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 05:45:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63CC1281889
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 03:45:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 827358F40;
	Mon, 23 Sep 2024 03:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="tg9pYW67"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7730FDDD2;
	Mon, 23 Sep 2024 03:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727063106; cv=none; b=KUJloIPOVHwNQVT4moP3IHGOk0v66GX/ukdxWx5rAEoH3im/33tvduzKzV0r6qSZSaKj6d2YoYD4y8XkZgl4+lA7f9xjWQt+QFycUxPFsc55kFATsAItq8Y9TqqJmX/d/xVQj6G5solSW/6k6oR7paqz9Qphppw4Wk6Gg1RFI2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727063106; c=relaxed/simple;
	bh=30EwT+Tnznh3ySKKlYZkbqMe6G/58vr/AakAFlEQsSY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=kd6f9YmtW5GADMjxDAsQ24Tl0qeboWVaXx6Ci7EQXvUaXgHrybRgeLUkEw4sLDKj5SFchsqCbzbk9sSDs31V1qT5kLpZ+HFiMHeDWlvwYz428qs5qKAPA2Km3F5m27mGlly3zIKFBNnU05jjQ9f/MMCLwYqiRmk4pxtyAzGAEbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=tg9pYW67; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1727063102;
	bh=L7zz/WP3wi6yOy9OEYITIs+EwyHuCdZGPVvmr5cBxmI=;
	h=Date:From:To:Cc:Subject:From;
	b=tg9pYW67LG/gAc5nPV86Cse2C14QRFHkpKyjoJN/3y3toO37VbrhQqTS2PQLHxAfH
	 bvrOWaMTmQYhHFyfNaqTWnmY3xIAbZaLHBje7XGjZHkAHvMt9va6T/2+fJKBzJMO33
	 Hrt9g+xzISNZhagsxaIBPRiPeQnxe8bet3YdtLPoV9OeOJ80TA40c7ZAY+AEa/tV56
	 +uEf6H8Sp63XCovW4bJAMIX6QKrCBBCBszSwcUbJ2IkNlld0PzbYBp+0HHZHr/0vdt
	 qG8/DZ0Dl5IXkJG4NRHi7w5nHKyDXN8i1lqtARvJllwMDQXPl/vl0X34KDE9DT2EZL
	 Xl6AGkd3bZrVA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4XBplx5xr0z4wd0;
	Mon, 23 Sep 2024 13:45:01 +1000 (AEST)
Date: Mon, 23 Sep 2024 13:45:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, KVM <kvm@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next
 Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the kvm tree
Message-ID: <20240923134501.0a14789c@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/u.K3LrPiU61iIZLE5Sfydv2";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/u.K3LrPiU61iIZLE5Sfydv2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (htmldocs) produced
this warning:

Documentation/virt/kvm/locking.rst:31: ERROR: Unexpected indentation.

Introduced by commit

  44d174596260 ("KVM: Use dedicated mutex to protect kvm_usage_count to avo=
id deadlock")

--=20
Cheers,
Stephen Rothwell

--Sig_/u.K3LrPiU61iIZLE5Sfydv2
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmbw5D0ACgkQAVBC80lX
0GzZQwf+JPd88Ez2V0UcuMAQZngmXyigjwhvEcW9imqvREPLia1+3UkaQEMnZ1r3
Xjfds4tsSHiyHTTyEjFzLDOlJLhajO4bRK7TuTnrgBdnbbZGpUh8l83ElwuJZ2ow
AN2U11OkRgGoI/HlW3oXvYyuI6iKCwucoivUTKF+UbrVSemwhNh5XSYVrXqYBPf8
V+3dvTR4u5pN4NZ07OKe+QiOnB12sgCLiTM7AF8bijniaYm7H8FJ193izp0aR33s
vceMBW4ZAqYjk5b9w2LbH9lDSyZXrFA+MMPVqPUeQpLHhdmh/rDzjFsiaD6XGsjT
QXf9QoT7CFGzSSEQ2TdyRDSKkFYxuQ==
=qogP
-----END PGP SIGNATURE-----

--Sig_/u.K3LrPiU61iIZLE5Sfydv2--

