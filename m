Return-Path: <kvm+bounces-22458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D64B93E04B
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 19:11:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 209E31F21AD2
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 17:11:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCE74186E50;
	Sat, 27 Jul 2024 17:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.net header.i=j.neuschaefer@gmx.net header.b="UcecXxtU"
X-Original-To: kvm@vger.kernel.org
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC46717D378
	for <kvm@vger.kernel.org>; Sat, 27 Jul 2024 17:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722100275; cv=none; b=a7WWk4UDkCRMkmmOes3O0kJ8LEezBdyqGR3470Fy9LC2+5hH/OTS/IkO3sJHlObS6noBYQgcM7ddhs8TXCKtv3YWWLR7/n1q3cbI0TGcuhAdTbmEm7ZnQtGyBbUvkdYklokN0POfJ0Xoe85GrBEyGbHwy0NVm88eHp/qXnml+UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722100275; c=relaxed/simple;
	bh=+QGizWLkG/bwzGD47n/r3cVTOgICOkcfpeC8DqQsJvw=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=gcO/IDuMLodeS2bRWAsKzy3aO6bO72V14qpyjn3Sz7PblWzB17SGdrvy/UDdwofKGY9vqQtdSLvKoAgYG+hD4N6mZbCWyQ4L1jRtjlnasojIMr1sUOXsdzodrhrXgdAnxLl24Vk3WZpFwnAcrBMKOMp0ts0mN3lUasASIcmzm2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net; spf=pass smtp.mailfrom=gmx.net; dkim=pass (2048-bit key) header.d=gmx.net header.i=j.neuschaefer@gmx.net header.b=UcecXxtU; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.net;
	s=s31663417; t=1722100267; x=1722705067; i=j.neuschaefer@gmx.net;
	bh=aM0XqP3f4aRUq0CuyRI0CgQQUhDZ0QNd8Qzog5myM94=;
	h=X-UI-Sender-Class:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:To:Cc:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=UcecXxtUsFZI2gq9DvjhdmpQrRgF644wKxJgNz5iX6r/LDfCJqNhuc7W3913q1xz
	 XvItcEm7N5LPk4/XlIDF1+f9P+qRiLMFlIlhCPIwLiLeIbS7LR/Ad7AMkzTkoSR3c
	 6mOATfCSwmFfL+yRMSmrHLp+Ctt0upKPPCwgt/+0OCYEgXx1MlRHs/WUvulc+3rjr
	 p8Xk8BU4He8f8rExO9159UDDBlMqUg3op/4Gk2xdGAGhjTpl+p4eL+k9xtM5Yk7fW
	 saGgYyLGDfOr1s1Msby+r7ijME9bfmDHXcaX5pvXET6UGXbtxkXvFU1rw5Pm2NRGX
	 2Q72LdQRMw0ArWTVpA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from probook ([89.1.58.183]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MWics-1snCMM46tk-00Ned9; Sat, 27
 Jul 2024 19:11:07 +0200
From: =?utf-8?q?J=2E_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Subject: [PATCH kvmtool v2 0/2] Fix compilation with musl-libc based
 toolchains
Date: Sat, 27 Jul 2024 19:11:01 +0200
Message-Id: <20240727-musl-v2-0-b106252a1cba@gmx.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-B4-Tracking: v=1; b=H4sIACUqpWYC/13MQQ6CMBCF4auQWVvTToWKK+9hWCAdYBIppMUGQ
 3p3K0uX/8vLt0MgzxTgVuzgKXLg2eXAUwHd2LqBBNvcgBIv0qAR0zu8xLXUXVVZetZaQb4unnr
 eDubR5B45rLP/HGpUv/UPiEpIoUuptMW+Nq28D9N2drRCk1L6Ai+mgaqWAAAA
To: kvm@vger.kernel.org
Cc: Alyssa Ross <hi@alyssa.is>, 
 =?utf-8?q?J=2E_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1722100266; l=724;
 i=j.neuschaefer@gmx.net; s=20240329; h=from:subject:message-id;
 bh=1giGqHatKP2OutmLNTLEafvs7x9MpV5wdKSXJS/2nsU=;
 b=kwVfnpnFPYWLh9uk+RGF7o8a0ZpR+dShvCXwT1bdUmMjXRLD/eRKFe7NoP5Mw9Vkbl0H0d4m9
 i1RQVmtSPIuCzzkBc4Ijs5a/vXOkq4DHGMfdQQRN+A0D0b0YJQwzRX2
X-Developer-Key: i=j.neuschaefer@gmx.net; a=ed25519;
 pk=NIe0bK42wNaX/C4bi6ezm7NJK0IQE+8MKBm7igFMIS4=
X-Provags-ID: V03:K1:/cJthvZ9h4FKVakpOEBbiIM8SM+cOFIp2PwJb0agoZNDylAi9iB
 Hk833KVD49UuOzyi41qaOJBJSP0OIdxlUEThtf/XvkcOCsz6Epl8DMSIrZQwTYQe2wO/5Dp
 FypkLMzOmmA+gpNPD6WQQptE4/GOroGHVXDg0KBVF6/HiM1B8zvKXVKcSnryyDQmR60/H9b
 uDz/JI3VRy7X11qFVT8ew==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:o/6uAGlYDRI=;qIWh7bn47s4OJ8ydmptgbPwIdE5
 GgO9V+a4W+53rRl37YdWcvx85j/SwI51kkBCAlMODIKnNi5EHJHZ5VEb9yexlh81yj6byemwk
 +VAT5KLwXe5BFypb713IzS3cuA6qclrD8kqEc7iD+7F4//KEbKzxc5no79WBveVK+s04ekK42
 hj15xA0pw7nwZOiqxv+DcqcH88eUNuBs6FVZf97ASRblOQL9BoGsafy1jrRbSxUMkpf2eXJQZ
 H6D+5eQzKAaN4MPusZ8M6psQyYf7gTxo83XRALiro7CvKzM/Q9Zzu812sgXTqaFJ2IUIWg5DN
 kCPRswhJbUrs9sBo3KVH90pfnYgb8ZdDM2LCCHYPJnzUAQEauByIg6ZO+GsN79McPfF4DlrlX
 jLy3k34cQmMGotLN8V7gPyK43xLDLz73n/1Fmn5Q4TYqSvGr/+3XT4Eynea3mKDVs34+VNJGz
 QZeyGOLm2WJ4Q3zkELn8b3Ih7h0dSWr9XPGPyofvEQQ3EKwZJNlP/oKU2iL15cfTCiDDht6Qq
 IsUF4TGrH++rVSlFJ3ZyxTweAR01hPwJSXjWaUkFz+Mn4HEJqMLvFZwl3TmVzFlRW0p9MAhqD
 3Vw1aNJ/WFrQyNm0vM7IlbFiHTpmU7H0s91pGagELyGZWzTGxdlJTNk61evBplYdvTwBFItUE
 evScpB351xBn4xL3rKZQ2/yJxFYnt4R8JT8xSTrmQ9hgrWlJA8NZ/IR5YU6t+UfdbjJoL/abh
 ioSCSCLQp7ZYGsErFPM+fwWJRkTQj5iSwrY/p1vi+rWqLZOQ9T4S5HQkyr5n3nv6fBczxtUuW
 Wbw1k7LlhZjotiEr732KUNCw==

This patchset enables kvmtool to build on musl-libc.
I have also tested that it still builds on glibc.

Signed-off-by: J. Neusch=C3=A4fer <j.neuschaefer@gmx.net>
=2D--
Changes in v2:
- Be explicit about GNU vs. POSIX versions of basename
- Link to v1: https://lore.kernel.org/r/20240727-musl-v1-0-35013d2f97a0@gm=
x.net

=2D--
J. Neusch=C3=A4fer (2):
      Switch to POSIX version of basename()
      Get __WORDSIZE from <sys/reg.h> for musl compat

 include/linux/bitops.h | 2 +-
 vfio/core.c            | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)
=2D--
base-commit: ca31abf5d9c3453c852b263ccb451751b29b944b
change-id: 20240727-musl-853c66deb931

Best regards,
=2D-
J. Neusch=C3=A4fer <j.neuschaefer@gmx.net>


