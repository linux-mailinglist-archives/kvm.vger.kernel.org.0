Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0883010CC37
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 16:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbfK1PzY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 10:55:24 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29751 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726446AbfK1PzY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Nov 2019 10:55:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574956523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=LNRtx2eKuvnZpDiZLFUivmjg1FNYd4r9ipgtCcuMY/A=;
        b=c3/How7g/CWIXLrM86SQ8UwCPoQPS+zhkPeblVZWjMeICUZ1ivJprI8MQbxNSOrwq69AN2
        scVBWcjRFTUX6cisoZ7qoqIzgsc19gNWMrzKTNKEabDVd62MKgjlFrbw1rEyE+uhdxiXe+
        0ctUyqx0sCFvJQmcOspgNDVs+DB/uio=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-iyWJQaPYPIOma8rkjdpifw-1; Thu, 28 Nov 2019 10:55:19 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06D86100A162;
        Thu, 28 Nov 2019 15:55:18 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C85925C1B0;
        Thu, 28 Nov 2019 15:55:16 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, Alexander Graf <graf@amazon.com>
Subject: [PATCH kvm-unit-tests] arm/arm64: PL031: Fix check_rtc_irq
Date:   Thu, 28 Nov 2019 16:55:15 +0100
Message-Id: <20191128155515.19013-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: iyWJQaPYPIOma8rkjdpifw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since QEMU commit 83ad95957c7e ("pl031: Expose RTCICR as proper WC
register") the PL031 test gets into an infinite loop. Now we must
write bit zero of RTCICR to clear the IRQ status. Before, writing
anything to RTCICR would work. As '1' is a member of 'anything'
writing it should work for old QEMU as well.

Cc: Alexander Graf <graf@amazon.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/pl031.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arm/pl031.c b/arm/pl031.c
index 1f63ef13994f..3b75fd653e96 100644
--- a/arm/pl031.c
+++ b/arm/pl031.c
@@ -143,8 +143,8 @@ static void irq_handler(struct pt_regs *regs)
 =09=09report(readl(&pl031->ris) =3D=3D 1, "  RTC RIS =3D=3D 1");
 =09=09report(readl(&pl031->mis) =3D=3D 1, "  RTC MIS =3D=3D 1");
=20
-=09=09/* Writing any value should clear IRQ status */
-=09=09writel(0x80000000ULL, &pl031->icr);
+=09=09/* Writing one to bit zero should clear IRQ status */
+=09=09writel(1, &pl031->icr);
=20
 =09=09report(readl(&pl031->ris) =3D=3D 0, "  RTC RIS =3D=3D 0");
 =09=09report(readl(&pl031->mis) =3D=3D 0, "  RTC MIS =3D=3D 0");
--=20
2.21.0

