Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89E2819E5C7
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 16:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgDDOip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Apr 2020 10:38:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23457 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726605AbgDDOip (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Apr 2020 10:38:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586011124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1LCVI6Q4/Ny0Rm6fGm4deZaX1vxgVnpBC6xTC+/9SMI=;
        b=E7UDU0aXO7PC8iQxb8nnWLg/j2NRgex0QZt4yW/6/05E8xzV21S/4JLFsePeNvx2DMdA0k
        IXQCEGxCQMetD3lkPQCYTEy9Uibyf0o+2nw1kn1juJUkNvrToObZv/4wFCewvB2v0qY68Q
        KXatm4XmH+8hiyttY3Vx7Zfe1ujDNJ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-ps8eJ8gOO--NCAUGHPGUAA-1; Sat, 04 Apr 2020 10:38:42 -0400
X-MC-Unique: ps8eJ8gOO--NCAUGHPGUAA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6187E1005513;
        Sat,  4 Apr 2020 14:38:41 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C2D79B912;
        Sat,  4 Apr 2020 14:38:39 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Eric Auger <eric.auger@redhat.com>
Subject: [PULL kvm-unit-tests 25/39] arm: gic: Introduce gic_irq_set_clr_enable() helper
Date:   Sat,  4 Apr 2020 16:37:17 +0200
Message-Id: <20200404143731.208138-26-drjones@redhat.com>
In-Reply-To: <20200404143731.208138-1-drjones@redhat.com>
References: <20200404143731.208138-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

Allows to set or clear the enable state of a PPI/SGI/SPI.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/arm/asm/gic.h |  4 ++++
 lib/arm/gic.c     | 31 +++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index 922cbe95750c..afb33096078d 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -82,5 +82,9 @@ extern void gic_ipi_send_single(int irq, int cpu);
 extern void gic_ipi_send_mask(int irq, const cpumask_t *dest);
 extern enum gic_irq_state gic_irq_state(int irq);
=20
+void gic_irq_set_clr_enable(int irq, bool enable);
+#define gic_enable_irq(irq) gic_irq_set_clr_enable(irq, true)
+#define gic_disable_irq(irq) gic_irq_set_clr_enable(irq, false)
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM_GIC_H_ */
diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index c3c5f6bc5b0e..8a1a8c84bf29 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -147,6 +147,36 @@ void gic_ipi_send_mask(int irq, const cpumask_t *des=
t)
 	gic_common_ops->ipi_send_mask(irq, dest);
 }
=20
+void gic_irq_set_clr_enable(int irq, bool enable)
+{
+	u32 offset, split =3D 32, shift =3D (irq % 32);
+	u32 reg, mask =3D BIT(shift);
+	void *base;
+
+	assert(irq < 1020);
+
+	switch (gic_version()) {
+	case 2:
+		offset =3D enable ? GICD_ISENABLER : GICD_ICENABLER;
+		base =3D gicv2_dist_base();
+		break;
+	case 3:
+		if (irq < 32) {
+			offset =3D enable ? GICR_ISENABLER0 : GICR_ICENABLER0;
+			base =3D gicv3_sgi_base();
+		} else {
+			offset =3D enable ? GICD_ISENABLER : GICD_ICENABLER;
+			base =3D gicv3_dist_base();
+		}
+		break;
+	default:
+		assert(0);
+	}
+	base +=3D offset + (irq / split) * 4;
+	reg =3D readl(base);
+	writel(reg | mask, base);
+}
+
 enum gic_irq_state gic_irq_state(int irq)
 {
 	enum gic_irq_state state;
@@ -191,3 +221,4 @@ enum gic_irq_state gic_irq_state(int irq)
=20
 	return state;
 }
+
--=20
2.25.1

