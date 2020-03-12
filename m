Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42F37183545
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 16:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgCLPov (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 11:44:51 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55257 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727790AbgCLPov (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Mar 2020 11:44:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584027890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aafjbtXSHBMixYKwM8RWXU8749gRXQWdvAvew/5369c=;
        b=dF2NeWytV8hGE2QZelkeBtPPQhPPnNI1/aTuEwdbKy+ejcgZG0wU8i/Ogy/Jax5cd57hwt
        2s9mmDMvlxWQudGCYEuxQ1zSHDVwraOqnzRgfJG5e6HpLyJc0QGo4nN7pliVkxZDg/rAWC
        BRqSP3mjpT+llVt/eyGE4gulaLi6+dQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-YXlDPYgvO8iokUUPdlF-6g-1; Thu, 12 Mar 2020 11:44:48 -0400
X-MC-Unique: YXlDPYgvO8iokUUPdlF-6g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68109802CAD;
        Thu, 12 Mar 2020 15:44:46 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.36.118.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBB885C1D8;
        Thu, 12 Mar 2020 15:44:40 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andrew.murray@arm.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH v3 11/12] arm: gic: Introduce gic_irq_set_clr_enable() helper
Date:   Thu, 12 Mar 2020 16:43:00 +0100
Message-Id: <20200312154301.9130-12-eric.auger@redhat.com>
In-Reply-To: <20200312154301.9130-1-eric.auger@redhat.com>
References: <20200312154301.9130-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

