Return-Path: <kvm+bounces-22451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E255A93DDD0
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 10:11:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C360281E88
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 08:11:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2614643AAB;
	Sat, 27 Jul 2024 08:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.net header.i=j.neuschaefer@gmx.net header.b="cgonqJV6"
X-Original-To: kvm@vger.kernel.org
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFBE39FE5
	for <kvm@vger.kernel.org>; Sat, 27 Jul 2024 08:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722067889; cv=none; b=LB/dcaqNfEY5XcIxADBc+FNGXY9phvGO4GgxC3+YzF6hxekyAOT8hXcpaactcPVUfaSB9n2+ugPwfFgMvshYWkR+jeLLqY/bLRZY+ksdMfdw7GbRzb5Tds5IRDCtsYNxMAcemZ0lcTTbTQAd1qrJAwN+7zL72VlpVvb7DI+Cz6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722067889; c=relaxed/simple;
	bh=G1UG7Ym5QWsBDQqrKrtbV3yC3R4jZ+ZAMXPrVuycTlc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=L5K2RjMP4Lgz0kNCIeNvF7gDK1MQfVCsTVxjDy6qZM9w2+TS7w4nhxuxzZ2LhEDZL3QNS8e7YyNpboFvmeR+NtPGIPN/PDCvSkJ4AfRFUsHFYZO51IRHdbyuoWAfM9suLV6HIge3Cvd8phPjPDRXXJ13BenC5GdyYJfp1RnjNwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net; spf=pass smtp.mailfrom=gmx.net; dkim=pass (2048-bit key) header.d=gmx.net header.i=j.neuschaefer@gmx.net header.b=cgonqJV6; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.net;
	s=s31663417; t=1722067885; x=1722672685; i=j.neuschaefer@gmx.net;
	bh=G1UG7Ym5QWsBDQqrKrtbV3yC3R4jZ+ZAMXPrVuycTlc=;
	h=X-UI-Sender-Class:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=cgonqJV6cuf/ArCpGrwamnumqDb7+ji171D14AB/fqpFIIcLKhohfVxEBJ1cZNyA
	 5SdjAGCOT4jNadSgSEXXtyuLNbh9vant/F/KoJ5+9V2CaXJdrRp1mhwtpUlcHfTKK
	 CIai0FXQJllx5toA33q6+r8HsR2RO+C2BNxU+ZV5JoMOoNyCFCesnlvndOgmpcI5S
	 7uawx4Sg0b8XAHlJNKc+NX1PKi+4/Sr7cZjdMZb0Y+B/Wqxlo+dOQi8raj8HeoToK
	 C5xSUGeM1dxm03fZHWItZJSkJEpQAqAuVBYYhIUGn6RzPSJE8hPz+SooJXBeepI48
	 hnxm8oh6GdQOe2wFWg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from probook ([89.1.58.183]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N6KUT-1sE06G02OX-00y4i0; Sat, 27
 Jul 2024 10:11:25 +0200
From: =?utf-8?q?J=2E_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Date: Sat, 27 Jul 2024 10:11:15 +0200
Subject: [PATCH kvmtool 2/2] Get __WORDSIZE from <sys/reg.h> for musl
 compat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <20240727-musl-v1-2-35013d2f97a0@gmx.net>
References: <20240727-musl-v1-0-35013d2f97a0@gmx.net>
In-Reply-To: <20240727-musl-v1-0-35013d2f97a0@gmx.net>
To: kvm@vger.kernel.org
Cc: =?utf-8?q?J=2E_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1722067883; l=613;
 i=j.neuschaefer@gmx.net; s=20240329; h=from:subject:message-id;
 bh=tVOKWKwYU+dVSuJDiqNEpg66SUP9EyIq3cbfmNfFK8Y=;
 b=/V3hmu8UlIP4tFM9aT2ocY+U4ORxQByq5Xbg4APWL69oHL3Vz0QvB1o0sme16qwVIqQZBIVH3
 kdZ5oTHpI1xB6A7tL7sgXpMrvpl2uizgmWcRy2M0HwmnQvq5mA4/7me
X-Developer-Key: i=j.neuschaefer@gmx.net; a=ed25519;
 pk=NIe0bK42wNaX/C4bi6ezm7NJK0IQE+8MKBm7igFMIS4=
X-Provags-ID: V03:K1:OnkjK+lUROzUJOS6kAdqGvtVZG5mE8Mz6RnxjjZjHub7ea1fssB
 qU1J6XaaAR51R8hEIU7EFA30LV92GQ3l7sLs1BmtPgzZ7AuZR7aHHUjzQKu94LtPdPie3b4
 yCmmOCOmHW180cJT5f6fBaMHL8hjy6NtvBhd8qt9qGrWurj4jHGIR41OCe7D5ccDZdmf656
 q7yUpyhL5f7NLvuIC11Mg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:3rS76tPaokc=;tw+cSM7CYdu5bnQ2nuwndcyUH/k
 q3U07KPnbpIbIuGAb7jwfOlDJ8YCFo0W2MmbeWjV1A/qMtkvBvEm+1BDkGcHSQgTLxkSYa44z
 abjGNd40NHHHikVRl0xbZRaOjcOoqCpywNUxlvAFPqcJCzoajYo0mqFw/iNFv3+G8HjexkYbK
 HByZjeamjeCjrA/ceidFD7/cGZ6eDlw6Ny2jj4dKCHTCEUsLYLsUuHZP9hLMMb65vhQaDjTHf
 KmIQVZswkyUKI1uWDxPiYHT63GoKptoj51Y15YPo1xsIIP2zqhrF6yNOU80eCC/g/STD+Fe7R
 JGkkK6ScxWr+Jy5iT/AsT8T/PMZ4rkBuT0/UpOyXnHLdnvdmbBSvUwcxBx+1+Sv5DyRisJU6o
 0V3HMXWBWfxbyGLfwzO1SH2wG48//4yaQbF105ExqgB9wc1hvbqYu3agu7Mm/rAnNLQJzLwaK
 zSFAf6LtzbORM5/+wGF4Szlar+a3P7xNllL0tJt98I2ccQkAmJmAsBDwJBp1Vl4KiG+WcVu7A
 rj1fgL6Kw4+Q+Llb6bbf9mwjezZeRqU25ZkZDm4V5y4RhJ5ekH7qvo6zAKyDXOXudAIS7YF4o
 rHzrmx3WgfiQ0go8a3NCnaatIeQxaK6f77gx0/dArQVo02SYmX5+tgGmp/Tk7iXc52+JH3r1x
 DJ/0BQoTQwmv/T6QMne5OPb/nQTT5XPx5kRI5XbjlMv9Rg+5mauaafP0jvs1ASlT9zPXiT6kk
 8LnJho+vPb78dyNx3Bcof8LLfb9AekemCz8XCACU5PNbX4MKONxHyA5EAO/CNueA1MUYhrFGh
 6IFBfJ4oQf6QZwSUqcokaQyg==

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


