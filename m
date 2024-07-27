Return-Path: <kvm+bounces-22459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 29D9E93E04C
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 19:11:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63254B2130A
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 17:11:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5579C186E5E;
	Sat, 27 Jul 2024 17:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.net header.i=j.neuschaefer@gmx.net header.b="rnTojTub"
X-Original-To: kvm@vger.kernel.org
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347361822F8
	for <kvm@vger.kernel.org>; Sat, 27 Jul 2024 17:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722100275; cv=none; b=gjcIsVysdiyHj/A9JsRqlEmUpLEhmrYSz7k1cPFqpxiUPOrsU1eiPgQKMoPxSw5dcQOMa8HZfCiZsFA/I3A8UBem5BaFfQF+CAHfU6e8OMBdI4gJf0gSUPnXP0v+bYyjhgn8wDSx1B4AaCCAanbNJOkg2UZw0JNhybJ58MSCY3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722100275; c=relaxed/simple;
	bh=2k4psoqOPffmscdCWHgApM8s/rFOSeg/eybuLJR/yZs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MtDhvGDgX4bWNjFDjbrhkrG35lyWZe98XxRLJHXUJopUezg2++8OMhVE0f1TmsrfAuFvJkHKYtNDv2gNlE45EiCa5wa5bnjT83c6nPvTXWDo99XH54ITf0bsONP2NfZa69FjQZyca4znZjtCJC0U5hX2Z1OvbkIHxzF7capQBgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net; spf=pass smtp.mailfrom=gmx.net; dkim=pass (2048-bit key) header.d=gmx.net header.i=j.neuschaefer@gmx.net header.b=rnTojTub; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.net;
	s=s31663417; t=1722100267; x=1722705067; i=j.neuschaefer@gmx.net;
	bh=swBoFVNFjIlFqqBEQ8QUYMA2NSSds0ph4YbtsEYzyKg=;
	h=X-UI-Sender-Class:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=rnTojTubB19Up4jdlc2E9NPUrgWr7HThPmAPsEpafusSIR++UTcVW7GZtOxpz8Lj
	 RrErh9IyMwQa2FUAcdiMQv+ttWLG9mk2NvpwyphgtKPbzbUeCTpiGbCgtVeWTuGd1
	 y2nnqy6wWMGZKWVBBZlmbSAJ4mpXYibC4lLyvpZknlnlBqGHsWKopWZ6K765lg3rO
	 +LaUTbEOLxvrnk86BCLkOxN+s8ADa2d5JVYxaKI7jc/iCk0M0TD8WW9YYgjwEY+8D
	 gyEShsClNCseyaAhXMqONNSFg8k54CaZAS811Obi83bA6pDrbDmk3tyPun1dK6TWA
	 fewy9S45UTi7AHxCow==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from probook ([89.1.58.183]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M4axg-1sXCyz1Vlm-00B85O; Sat, 27
 Jul 2024 19:11:07 +0200
From: =?utf-8?q?J=2E_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Date: Sat, 27 Jul 2024 19:11:02 +0200
Subject: [PATCH kvmtool v2 1/2] Switch to POSIX version of basename()
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <20240727-musl-v2-1-b106252a1cba@gmx.net>
References: <20240727-musl-v2-0-b106252a1cba@gmx.net>
In-Reply-To: <20240727-musl-v2-0-b106252a1cba@gmx.net>
To: kvm@vger.kernel.org
Cc: Alyssa Ross <hi@alyssa.is>, 
 =?utf-8?q?J=2E_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1722100266; l=912;
 i=j.neuschaefer@gmx.net; s=20240329; h=from:subject:message-id;
 bh=2m/JDnXc4n6lAD/EHrapM+X4fY61n4spC8jbBUZkrDE=;
 b=7soL1lPuUdAGjf5pnHbwtaSNSKzMAk+d0x/+5RLnmDM+H0JEPWz7D7rDpPjpjamqrJDZAz0Dt
 2NRUFb31fXhDj9B9kzCmkN6yj+XFBSbPV6TiTGscZ2+gMMDbEkTV2bi
X-Developer-Key: i=j.neuschaefer@gmx.net; a=ed25519;
 pk=NIe0bK42wNaX/C4bi6ezm7NJK0IQE+8MKBm7igFMIS4=
X-Provags-ID: V03:K1:2oafHmtkoJKAg9jDbY4+jYbc+4LOq0EJaVnqrlbQ/QF+yEjKqCw
 KF+i12+ilpft6fygPqyq8BYsbrvwCY5MJWDMm95UvK86KN1094la7y4eixKYVCXorAf3vqa
 Q0/0qyGo9iIUKrAwa4lsINOtzr0hc95rbNVkFp6ojr1G4mK5EiUkzMBNzM6OUvUUCm7vTXO
 G15n5RbDicaYjP1pEeGkQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:nl6Nj17KOZY=;mgFxCfgGYsTwZbOuJM9ALDQcZkB
 P/NGb2tO/GgJbMHdBe8DzmcuNP3jiCAtIHvqdS3dNMp0w8zb5zdbANUfLi3vM8p60RhMea+XK
 ncEgqx4iA71hVPrWBqQP9hzEXA4BULF2T/FYXmcwU8Pbjcx88rvTLaXDabyOr6o2BaqMTZot7
 NVsyCp9DuyDo75aL9Lg0FRLjsPP9eNnXDNI1dvR6w3Uv7/r018tAeVa5IdNAJmmkE0nwlEa1r
 LaecPlj0gEBm0DGxjrFN13JaTc0RTBdwiJ3PatsqyK0AYt2MRd4asLPkj8Zm2JAbXu9x0xnOX
 Oct8iNHSpbuU8PZuMTSBsaDRhe/CgmIDHlgOx96wn8fXv24PB7ddhukk8gphFm2yNGyA+NGkI
 6tU9r0woiRu9nczCc3wToVZtnUqlPdbs9OM7dM6IrHx9KBPUW8WBPBkXSMxUSY5mb9yoyAbFg
 68fplCgWf3kVhM4R111fmJ5d0uTexDmNxjh6AYf+k21uz3BFARC/lV0jxZspMcZR/S+O0/Av/
 19/g+HqACz6elKpouJbtqgWQ48CAbqTddDX4vWogekqJ6u+v6kdnelvAuH5KMuL+o43zeq9kz
 FHBlyFAN+r7VcuyLP4KzhUDoz7s32MQKasSKVvVmDn9q0rVL32Ehexqm+FxklPFwsEO3ICO0L
 Tc/H8c0wp0QZ/XqFX5Gp0Ak+u4inMt8liwQcjq9D9Bh2VI+Pfhldz5y8KneA3aZ67lr7QHjK2
 DuHADgdBhEnqs0C/4gQAh64ZP6ESjU5B/DBpTog2l2eiOhRZbDpmgjvHsdmyANk6PK9IQ69cL
 +5CiebufMx+dJoqVRq3ABRiA==

There are two versions of the basename function: The POSIX version is
defined in <libgen.h>, and glibc additionally provides a GNU-specific
version in <string.h>. musl-libc only provides the POSIX version,
resulting in a compilation failure:

vfio/core.c:538:22: error: implicit declaration of function 'basename' [-W=
error=3Dimplicit-function-declaration]
  538 |         group_name =3D basename(group_path);
      |                      ^~~~~~~~

Reviewed-by: Alyssa Ross <hi@alyssa.is>
Signed-off-by: J. Neusch=C3=A4fer <j.neuschaefer@gmx.net>
=2D--
 vfio/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/vfio/core.c b/vfio/core.c
index 3ff2c0b..8f88489 100644
=2D-- a/vfio/core.c
+++ b/vfio/core.c
@@ -3,6 +3,7 @@
 #include "kvm/ioport.h"

 #include <linux/list.h>
+#include <libgen.h>

 #define VFIO_DEV_DIR		"/dev/vfio"
 #define VFIO_DEV_NODE		VFIO_DEV_DIR "/vfio"

=2D-
2.43.0


