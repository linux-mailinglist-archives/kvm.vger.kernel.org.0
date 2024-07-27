Return-Path: <kvm+bounces-22449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 172BB93DDCE
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 10:11:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 485F81C215CC
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 08:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E14242058;
	Sat, 27 Jul 2024 08:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.net header.i=j.neuschaefer@gmx.net header.b="p6ZE6nZm"
X-Original-To: kvm@vger.kernel.org
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAA7381BE
	for <kvm@vger.kernel.org>; Sat, 27 Jul 2024 08:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722067888; cv=none; b=oUPf87g3dA8wDTf75SGJ6fRf3sz0rq5EoTCEfEbsNurPqnUA7HamvF+q0WQZyw7ZCHYqeiT3Ay6SIk4SVJimjyHUSLBd/UzNLcI4dhuxp2vd+0tNALtRwdDeYocVLriamZLDb9Hry39xjyA3fw4t/jpK2Sma+q+1VTvq1tn9iwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722067888; c=relaxed/simple;
	bh=NPQBan003xEKL1xN/oa3jKi0LYVVQVNrv3DgrkTuo5w=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=sOduZa2xe9bstaU1jK3v/F1WQo2ro95gSS6IHYCvAA7wXVWvEr5nY8HkFqo0T1VBybsr6eQK51wKtzxdhbL47ptlKfs/R3P11CkJjPu1XAM6MSyO7zahgTvQ/qp8s7xXvnaYY51dPUnIq3b+MqcMJGFhDooTxvpE4iJz6cHgD9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net; spf=pass smtp.mailfrom=gmx.net; dkim=pass (2048-bit key) header.d=gmx.net header.i=j.neuschaefer@gmx.net header.b=p6ZE6nZm; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.net;
	s=s31663417; t=1722067884; x=1722672684; i=j.neuschaefer@gmx.net;
	bh=TJQRtvBzqpxrRsLfCXvDiD1Roovd0bKqxUAqdiIVHtA=;
	h=X-UI-Sender-Class:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:To:Cc:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=p6ZE6nZm8xboYK40/fTmezh+9ualnEsuWtp3Qhe6ieKhT5jNktOhn2Y875fUnOJB
	 lArmrM/A+76GaP0UhaitMvs7+TTVaUkLPMl651ODhQhaR1cEeKycDvb/ZRxJTdUKy
	 dV6XTRbbs40mJ3hSV8dkXrETf2agMgh4adnQYJqC9LahbAOhjtFBa2np9FfjVeKgL
	 14QyRuZoueSkXVQshbcNhqOthw08jnsc1WZMS68WsRUlYpB2nkwcg/Smdw4plpPli
	 v8Xi8sBGvHkVGtI0CLU+OpZrgmHsUk8qj0IbAJSnf8MsG9T2g3GuU7iGBadqC+Xbh
	 9UR5FFduj4CUH1xpfA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from probook ([89.1.58.183]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MA7GM-1sRWdi0P3C-006nLr; Sat, 27
 Jul 2024 10:11:24 +0200
From: =?utf-8?q?J=2E_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Subject: [PATCH kvmtool 0/2] Fix compilation with musl-libc based
 toolchains
Date: Sat, 27 Jul 2024 10:11:13 +0200
Message-Id: <20240727-musl-v1-0-35013d2f97a0@gmx.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-B4-Tracking: v=1; b=H4sIAKGrpGYC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIxMDcyNz3dzS4hxdC1PjZDOzlNQkS2NDJaDSgqLUtMwKsDHRsbW1ABZ4wyF
 WAAAA
To: kvm@vger.kernel.org
Cc: =?utf-8?q?J=2E_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1722067883; l=573;
 i=j.neuschaefer@gmx.net; s=20240329; h=from:subject:message-id;
 bh=Bzp+grm500h9wdDVsdIBjo9qHq/I5UYNIIYBKuPkuEI=;
 b=rXYMco6dkO9Bg5gTsVearma6EfnzJOOi5LQM5hDOnc27MmfaVOQ+6pvArMPOgIc03NVjkKIJH
 F9EGBvMxCuEBXHbNsFuXyxBs7rFMNmR7XG0GajFqw3tT8PHgxZ3rxH+
X-Developer-Key: i=j.neuschaefer@gmx.net; a=ed25519;
 pk=NIe0bK42wNaX/C4bi6ezm7NJK0IQE+8MKBm7igFMIS4=
X-Provags-ID: V03:K1:DPL1IBJweTlS+yuJC5G3ooYwJtFz4BTmstqiUyphZEN4C/mjKeF
 AZMHVSt/Tplrb3I2XRNjF7JCDlPf0qLm9gbmsL/yvfATFvzHRZ6KQwjfT4LXtBh9F0mVxUG
 AGIj5Dy8YmCWSJcKU1Q9opSOC73bhh6x5zJW+lp01aEAMqjmpM8tNRHIdE0wpcpFJcdYcZN
 hcNOojqtMM+peiX94Q+CA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:OwqquDGncG8=;9VQN7OS7690bGR6nf3vyVhVPu3T
 46m+PrX/wWCJ4xtsiVxD4AFkxxASUBcmr9pWy5/a3ySg4IqlxIlb8d0DiwfQK9I61v9JpROnq
 KBciFFgAOC1eMyLOtxp8OEtZaIKVVAguXITzOal15HKAATXpKwLH4jH81MBCEUgiZgjyu3HTf
 deSgqIuLdQ5HtazOY+pb0S6TLsBzEFomJ406srG8GnZMfTH6NhZ891e6ZODD92muXQqoFhvx1
 8wLMWFuhpik+d8uPqky0potytUMTwHsdB5YNqS6VhzGeO6zIJ8/S/PeXfRs2YPySzdyvVrMhw
 qtOR3Y+4+ykkmi5BbMUYmeBERfLp/D+Vqnh12WWKf6SKxy6nBVtsTgq8ADCZvgDDdRv9LbwLG
 0gGDGNCigAy5Cs9b/iG1fUaowRHgL8nL96gZjUviXjRhs44zWVNH8yRHD6mXll0R4eDcZfdAy
 bjO9tQUsvzsUfN29xgukmTfKBD++E/u4gmmHyZ/tVTChQcqR3FpMRTspVzYZfhQCpBrL7OnBp
 8ZLVuXiuUvO+FIsqpRX71h7M2PMfRXUs2n5Q5Is3N0jELH7gMN1DTq6br5BL/BcigyKoSaJQn
 hQ7N8NPgPWA779zK+/i8ge+zx7LPOqKGGt1kJivjon+STWmuRZYdUPGWnUkMJNduAnHz0ar+4
 blsJ6STNgbx7c0UJYr3L5fOK9dl5u7yqrJr2dYW6FaW6YWQvCSaJKumkPOLqgBI+yGCEsgktV
 VJWUCZXZLaxu9a6A9wXu1YFg0euVrXLCJRQ7jNw81YHoe00J8hiYuZv0YC2r5oWKQoX1cAv8F
 lICIwWWPa2qsb923WpKkvzAw==

This patchset enables kvmtool to build on musl-libc.
I have also tested that it still builds on glibc.

Signed-off-by: J. Neusch=C3=A4fer <j.neuschaefer@gmx.net>
=2D--
J. Neusch=C3=A4fer (2):
      Get basename() from <libgen.h> for musl compat
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


