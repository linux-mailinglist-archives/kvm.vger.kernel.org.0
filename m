Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28099130FE1
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 11:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgAFKD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 05:03:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52974 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726340AbgAFKD6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 05:03:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578305037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KVFxRbez22q9Gf2bVcqgToctJQkjnrtfbjDduZGgw1E=;
        b=PZ1/oFAyhzeWw9zoi5cIMDGoKUXbDBPc79/GkFZMUJ3UMrSuuAaD6Rgcmf1UuNUMSdlQfT
        KkfyT4YeGotG2MLkfZCnIpDd16gTJ01UDZMptt6jK1tmQeG+p6AdJzEjfbgcl8lmtLzqr1
        y6PnTb3azAhdbaoNzrG9YgsQBX6yQJ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-Jry93YcuPnaq8rozuMQdSA-1; Mon, 06 Jan 2020 05:03:54 -0500
X-MC-Unique: Jry93YcuPnaq8rozuMQdSA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFDFE800D48;
        Mon,  6 Jan 2020 10:03:53 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD78863BCA;
        Mon,  6 Jan 2020 10:03:52 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Alexander Graf <graf@amazon.com>
Subject: [PULL kvm-unit-tests 03/17] arm/arm64: PL031: Fix check_rtc_irq
Date:   Mon,  6 Jan 2020 11:03:33 +0100
Message-Id: <20200106100347.1559-4-drjones@redhat.com>
In-Reply-To: <20200106100347.1559-1-drjones@redhat.com>
References: <20200106100347.1559-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arm/pl031.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arm/pl031.c b/arm/pl031.c
index a6adf6845f55..86035fa407e6 100644
--- a/arm/pl031.c
+++ b/arm/pl031.c
@@ -143,8 +143,8 @@ static void irq_handler(struct pt_regs *regs)
 		report(readl(&pl031->ris) =3D=3D 1, "  RTC RIS =3D=3D 1");
 		report(readl(&pl031->mis) =3D=3D 1, "  RTC MIS =3D=3D 1");
=20
-		/* Writing any value should clear IRQ status */
-		writel(0x80000000ULL, &pl031->icr);
+		/* Writing one to bit zero should clear IRQ status */
+		writel(1, &pl031->icr);
=20
 		report(readl(&pl031->ris) =3D=3D 0, "  RTC RIS =3D=3D 0");
 		report(readl(&pl031->mis) =3D=3D 0, "  RTC MIS =3D=3D 0");
--=20
2.21.0

