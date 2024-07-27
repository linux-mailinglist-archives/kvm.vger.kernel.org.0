Return-Path: <kvm+bounces-22457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3436D93E04A
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 19:11:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D96F12810DF
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 17:11:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9B71186E4F;
	Sat, 27 Jul 2024 17:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.net header.i=j.neuschaefer@gmx.net header.b="f2WJCzos"
X-Original-To: kvm@vger.kernel.org
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E29153362
	for <kvm@vger.kernel.org>; Sat, 27 Jul 2024 17:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722100274; cv=none; b=lDYGvYZi1GA5Ap/D4HkQO55ddjpcwCBt53xxC+cDiMZnztHrOUytpMrGrLeqUBNOwa5yqkWw5/NFsA9MJvoMBM2uFTg9icUL8LI4Fz03X75nVybO+z4xuUYyjGo/15OfSR6h9c6Vfz5H/W5EYuCsMkBm0tXm048kSv0LwFB1HCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722100274; c=relaxed/simple;
	bh=G1UG7Ym5QWsBDQqrKrtbV3yC3R4jZ+ZAMXPrVuycTlc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YTkP34szDdC48wqnoly5vzWyVK2UiG5FjiDcprinc2bw5iBpG0nWowsc37m0Qn19APDJ3+D3N3fXxlFG/31rkoaKWNoIXnblb+pGBs/xlmB/0f2mYc9RwW5r6tG6tpF8AvA+dUCOlMv5gXkOAA5rD3WDJgWhe+6pFpzS6NnFNwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net; spf=pass smtp.mailfrom=gmx.net; dkim=pass (2048-bit key) header.d=gmx.net header.i=j.neuschaefer@gmx.net header.b=f2WJCzos; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.net;
	s=s31663417; t=1722100267; x=1722705067; i=j.neuschaefer@gmx.net;
	bh=G1UG7Ym5QWsBDQqrKrtbV3yC3R4jZ+ZAMXPrVuycTlc=;
	h=X-UI-Sender-Class:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=f2WJCzosSh7HOEJhOD50wKYFkjZJhAW52HE4nsCamrOxyKcSgtEoO/TuKsdzG3Bj
	 BfK0/5SBuLrn8wVTX7VUBPEkV4Qxit0S+2nhmSnZxUU+p32P+26X0cCEePHxTNuGU
	 QeyHsgLxSZvaLlicKnBVBVu8SdBnhlX2wN2halN4IhhpgId54CpLwaixCSWehMK/k
	 BrqR+eoYXb/GkI0coI4IMOSPjCUkyjIsB+YTmYuj0hyRNZXSIZ2nwR4Y5LSKSKadq
	 rzFxKmh9gJ2XcKrWOr3ZVuHzbTGfchdveaquG3J53IRVrGT9EfeUCVYWOJcUR+6z6
	 UKbfeLJNZtT9HKxaXQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from probook ([89.1.58.183]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M72oH-1sdXi039Ch-00058L; Sat, 27
 Jul 2024 19:11:07 +0200
From: =?utf-8?q?J=2E_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Date: Sat, 27 Jul 2024 19:11:03 +0200
Subject: [PATCH kvmtool v2 2/2] Get __WORDSIZE from <sys/reg.h> for musl
 compat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <20240727-musl-v2-2-b106252a1cba@gmx.net>
References: <20240727-musl-v2-0-b106252a1cba@gmx.net>
In-Reply-To: <20240727-musl-v2-0-b106252a1cba@gmx.net>
To: kvm@vger.kernel.org
Cc: Alyssa Ross <hi@alyssa.is>, 
 =?utf-8?q?J=2E_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1722100266; l=613;
 i=j.neuschaefer@gmx.net; s=20240329; h=from:subject:message-id;
 bh=tVOKWKwYU+dVSuJDiqNEpg66SUP9EyIq3cbfmNfFK8Y=;
 b=hK+P0jWNoM9nH+1tVHNZxUHQ1xDZ4rkvhuplKz6IShimJP7cFD8y6ldeERO7FLy93E1oxHRKI
 1EAFbJISvGND0JvRyqf+eL+stDf3Eb8soaxgWFWwKpN2mGhw50UFZa3
X-Developer-Key: i=j.neuschaefer@gmx.net; a=ed25519;
 pk=NIe0bK42wNaX/C4bi6ezm7NJK0IQE+8MKBm7igFMIS4=
X-Provags-ID: V03:K1:cps0hYPM52FIxxZbADOopOzlR/CKTRTWsr52WuficotDgm6Ad/T
 Vd2bxvCiop3VgDFeW31gmS8OG33PUMJiRTZFPJTGO0scxH6Co9ayOa5Q334OIN5jiVY+opn
 vUF0BvUpdBLTq1N6a3kYvE9plE5UDbHJ4t0vIYmoDxZdGejSsr0uOhAnZeBofJl0hZKrIeF
 kMesFcrOjmu2wpVE50NWw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:SKoYa5LO7T4=;/QvVM+OtAjcBRgaNJv9bzP2TQsU
 W7mEoZWfDayFG6NtxPrBf8vr08j7g3N14Nl/n/JePUj40bm0P/usz3L5+peRUNcHzjUhLjY8t
 NdhQfccMVy0MbMnaerABUoHHI5tLyRprnmrM90bttUlsmTxJvd5vcpXpwtws+b9lxTk8Loudk
 KKN/ary+VKJSOKqyhZRr2RsigAGgx0Ro4oXjnCgPgrLSKiE3Jo9/i4N8Mb/PH6FwbpNBxIput
 Mq27bfRLEs75kUbjHYJRP/H/FF/cwcB/EnRzLh7+YV7+a7cblUQOLaQ5dOhGOJhpPvah4W3qS
 XAYCshVSEXUomSOArmW9wFTInNxjIT1DhSZeu+yUjtZuEaG6gLOF4Ya8PuSGQTRFI+JOrIPlE
 Ie7Hwmm+7TWN7Snqy6zlQT0+SyuVtKwz/t8r4GDrZd7/5QLZdAW91zGOIdwEXTzX26jZpCdEE
 uXNytYgj32sbQioaDuhgdihEEbAKLf1fRSMI/OyHt10O0dlKDxHBwy7Gyc5CRn3bPKJpCLBNh
 RtXubr3PVC9ti89HqedgFSp3xP0iqHay5w7cUONOj5EzB2RtX/9wTbYG7gv5A8CUPGUoAvokR
 yFtO8zz3ByL44Pg9F9Zg2vfyivcuibmK23ypNtHhXoP0KWkaSC2zXvWeJYUGcRSdgfoV+M4Yy
 9cPid4uKeLvCc7/fhzkv9tI/lx7xJfu0RLw2w4BZW3jrWps1IgNHWlIa3ozVMlGvfYtYdhT0O
 z5dOyCGEVJgEje4vU4KtMom9wUzS2IgXt1l1PCfUDJW5l5EAW/SHJzxmFqcZE5cj9EG/kMljO
 w15zmpNy75aTYHJn0olAqscA==

musl-libc doesn't provide <bits/wordsize.h>, but it defines __WORDSIZE
in <sys/reg.h> and <sys/user.h>.

Signed-off-by: J. Neusch=C3=A4fer <j.neuschaefer@gmx.net>
=2D--
 include/linux/bitops.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index ae33922..4f133ba 100644
=2D-- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -1,7 +1,7 @@
 #ifndef _KVM_LINUX_BITOPS_H_
 #define _KVM_LINUX_BITOPS_H_

-#include <bits/wordsize.h>
+#include <sys/reg.h>

 #include <linux/kernel.h>
 #include <linux/compiler.h>

=2D-
2.43.0


