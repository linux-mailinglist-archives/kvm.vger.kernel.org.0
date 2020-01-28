Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEA4B14B2C2
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 11:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgA1KgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 05:36:22 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:60672 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725948AbgA1KgW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Jan 2020 05:36:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580207781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=78G0omYBZtnhpn3J/dduj+Q41/b0ahCr4I2teh8jw18=;
        b=Y8wufg168fsx2zz69IBuywVl65yAc3CR4GfPfE6tpMgYpRGUdGemsjNtMuZl8YvVugyWbM
        9gZhEfUZd1PyVnqaWPi9Y1wStYRO1iVgp5zXCq3s5o4KMW/5WU1Hb9ztxAboU0PgrqzRhJ
        gNXcTk6u849euCuhUVo0eXbyBcj6Ip4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-QHcEkjAAPcSg6VQP7dxRFA-1; Tue, 28 Jan 2020 05:36:07 -0500
X-MC-Unique: QHcEkjAAPcSg6VQP7dxRFA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB695107ACC4;
        Tue, 28 Jan 2020 10:36:05 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 50F401001DD8;
        Tue, 28 Jan 2020 10:35:58 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 07/14] arm/arm64: gicv3: Enable/Disable LPIs at re-distributor level
Date:   Tue, 28 Jan 2020 11:34:52 +0100
Message-Id: <20200128103459.19413-8-eric.auger@redhat.com>
In-Reply-To: <20200128103459.19413-1-eric.auger@redhat.com>
References: <20200128103459.19413-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This helper function controls the signaling of LPIs at
redistributor level.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v2 -> v3:
- move the helper in lib/arm/gic-v3.c
- rename the function with gicv3_lpi_ prefix
- s/report_abort/assert
---
 lib/arm/asm/gic-v3.h |  1 +
 lib/arm/gic-v3.c     | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index ec2a6f0..734c0c0 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -96,6 +96,7 @@ extern void gicv3_lpi_set_config(int n, u8 val);
 extern u8 gicv3_lpi_get_config(int n);
 extern void gicv3_lpi_set_pending_table_bit(int rdist, int n, bool set);
 extern void gicv3_lpi_alloc_tables(void);
+extern void gicv3_lpi_rdist_ctrl(u32 redist, bool set);
=20
 static inline void gicv3_do_wait_for_rwp(void *base)
 {
diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
index c33f883..7865d01 100644
--- a/lib/arm/gic-v3.c
+++ b/lib/arm/gic-v3.c
@@ -210,4 +210,21 @@ void gicv3_lpi_set_pending_table_bit(int rdist, int =
n, bool set)
 		byte &=3D ~mask;
 	*ptr =3D byte;
 }
+
+void gicv3_lpi_rdist_ctrl(u32 redist, bool set)
+{
+	void *ptr;
+	u64 val;
+
+	assert(redist < nr_cpus);
+
+	ptr =3D gicv3_data.redist_base[redist];
+	val =3D readl(ptr + GICR_CTLR);
+	if (set)
+		val |=3D GICR_CTLR_ENABLE_LPIS;
+	else
+		val &=3D ~GICR_CTLR_ENABLE_LPIS;
+	writel(val,  ptr + GICR_CTLR);
+}
 #endif /* __aarch64__ */
+
--=20
2.20.1

