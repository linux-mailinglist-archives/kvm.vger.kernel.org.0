Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFDCD19D0F4
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 09:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389758AbgDCHOX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 03:14:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20012 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389878AbgDCHOX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 03:14:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585898062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aafjbtXSHBMixYKwM8RWXU8749gRXQWdvAvew/5369c=;
        b=NoY+2DIDU0hRscPyA1Z2eERIJMbjvWhL0r5GBWwT+zQrLaxRTmY9EO8pf8LjpCQhZB3Cnz
        3hLMJpFcapD5t/XTKF5C8yPNALg+N6wFF8fUDdetoHx43nlClvksayttJlha2f96ea8Gwq
        A0vhMJ+QhPo4EWSGTAtQm6eNKZZknso=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-v4Eu734rPNWjFwtx4ek6jA-1; Fri, 03 Apr 2020 03:14:19 -0400
X-MC-Unique: v4Eu734rPNWjFwtx4ek6jA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F3FE8017F5;
        Fri,  3 Apr 2020 07:14:17 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-58.ams2.redhat.com [10.36.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A78A85C1C6;
        Fri,  3 Apr 2020 07:14:14 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andrew.murray@arm.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH v4 11/12] arm: gic: Introduce gic_irq_set_clr_enable() helper
Date:   Fri,  3 Apr 2020 09:13:25 +0200
Message-Id: <20200403071326.29932-12-eric.auger@redhat.com>
In-Reply-To: <20200403071326.29932-1-eric.auger@redhat.com>
References: <20200403071326.29932-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allows to set or clear the enable state of a PPI/SGI/SPI.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
---
 lib/arm/asm/gic.h |  4 ++++
 lib/arm/gic.c     | 31 +++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index 922cbe9..57e81c6 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -82,5 +82,9 @@ extern void gic_ipi_send_single(int irq, int cpu);
 extern void gic_ipi_send_mask(int irq, const cpumask_t *dest);
 extern enum gic_irq_state gic_irq_state(int irq);
=20
+void gic_irq_set_clr_enable(int irq, bool enable);
+#define gic_enable_irq(irq) gic_irq_set_clr_enable(irq, true);
+#define gic_disable_irq(irq) gic_irq_set_clr_enable(irq, false);
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM_GIC_H_ */
diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index c3c5f6b..8a1a8c8 100644
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
2.20.1

