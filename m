Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82E5915490A
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 17:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbgBFQYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 11:24:53 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38493 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727518AbgBFQYx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 11:24:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581006291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qVS9VeKQ7sPL5aAR8Mfs0fXxdVqjDuH2BdPfhYaOpK0=;
        b=Gae8FnJWRzJ5ZCcBR2FoqTILsPcyoudWS192Q0Sq4eQ9iadITElOPEckyanHlWRzW2dc9n
        IgPVfskNKEQrI9neeNR3GqqtmeYQVOExP4aGZMLz3ubLtAuDWP/KeQCJuO45dn879q+Yus
        c1isOclxlKsbvTrf5VUKdgs8FeXLiOc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-fJeSZeE7OIamLC8dDbk0Pw-1; Thu, 06 Feb 2020 11:24:48 -0500
X-MC-Unique: fJeSZeE7OIamLC8dDbk0Pw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D0A8800D54;
        Thu,  6 Feb 2020 16:24:47 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4015E100164D;
        Thu,  6 Feb 2020 16:24:46 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PULL kvm-unit-tests 06/10] arm64: timer: EOIR the interrupt after masking the timer
Date:   Thu,  6 Feb 2020 17:24:30 +0100
Message-Id: <20200206162434.14624-7-drjones@redhat.com>
In-Reply-To: <20200206162434.14624-1-drjones@redhat.com>
References: <20200206162434.14624-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

Writing to the EOIR register before masking the HW mapped timer
interrupt can cause taking another timer interrupt immediately after
exception return. This doesn't happen all the time, because KVM
reevaluates the state of pending HW mapped level sensitive interrupts on
each guest exit. If the second interrupt is pending and a guest exit
occurs after masking the timer interrupt and before the ERET (which
restores PSTATE.I), then KVM removes it.

Move the write after the IMASK bit has been set to prevent this from
happening.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/timer.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index 82f891147b35..b6f9dd10162d 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -157,19 +157,20 @@ static void irq_handler(struct pt_regs *regs)
 	u32 irqstat =3D gic_read_iar();
 	u32 irqnr =3D gic_iar_irqnr(irqstat);
=20
-	if (irqnr !=3D GICC_INT_SPURIOUS)
-		gic_write_eoir(irqstat);
-
 	if (irqnr =3D=3D PPI(vtimer_info.irq)) {
 		info =3D &vtimer_info;
 	} else if (irqnr =3D=3D PPI(ptimer_info.irq)) {
 		info =3D &ptimer_info;
 	} else {
+		if (irqnr !=3D GICC_INT_SPURIOUS)
+			gic_write_eoir(irqstat);
 		report_info("Unexpected interrupt: %d\n", irqnr);
 		return;
 	}
=20
 	info->write_ctl(ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE);
+	gic_write_eoir(irqstat);
+
 	info->irq_received =3D true;
 }
=20
--=20
2.21.1

