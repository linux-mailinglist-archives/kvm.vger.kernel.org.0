Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37E67137055
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 15:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgAJOzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 09:55:13 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48584 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728422AbgAJOzM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jan 2020 09:55:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578668111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gBKAcnxc2MYZzCoP970ndMhL3JY30iNVMqi2oK57oys=;
        b=RNJzlConDDNJyLKfAVOIcB28NlVTMKWNNfwAP1WZ9wxnoAS9E+xe4A9SndEUoZx3SrHtBW
        HUvjkqVQauMzL0NSNQSYT9lpbCeb9X97jCr4IEFZjEBFGVT4HAGPioUP7LzCdRCRFifDzG
        yxbNrCcpHsD8lwvicvKTmzrFHqIvYkE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-JQMSqK-yNEazhUrjO_r2Cg-1; Fri, 10 Jan 2020 09:55:10 -0500
X-MC-Unique: JQMSqK-yNEazhUrjO_r2Cg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 841A6108838E;
        Fri, 10 Jan 2020 14:55:07 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-117-108.ams2.redhat.com [10.36.117.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5DB427BA5F;
        Fri, 10 Jan 2020 14:54:59 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 09/16] arm/arm64: ITS: Enable/Disable LPIs at re-distributor level
Date:   Fri, 10 Jan 2020 15:54:05 +0100
Message-Id: <20200110145412.14937-10-eric.auger@redhat.com>
In-Reply-To: <20200110145412.14937-1-eric.auger@redhat.com>
References: <20200110145412.14937-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This helper function enables or disables the signaling of LPIs
at redistributor level.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 lib/arm/asm/gic-v3-its.h |  1 +
 lib/arm/gic-v3-its.c     | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
index 93814f7..d2db292 100644
--- a/lib/arm/asm/gic-v3-its.h
+++ b/lib/arm/asm/gic-v3-its.h
@@ -99,6 +99,7 @@ extern struct its_baser *its_lookup_baser(int type);
 extern void set_lpi_config(int n, u8 val);
 extern u8 get_lpi_config(int n);
 extern void set_pending_table_bit(int rdist, int n, bool set);
+extern void gicv3_rdist_ctrl_lpi(u32 redist, bool set);
=20
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM_GIC_V3_ITS_H_ */
diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
index 3037c84..c7c6f80 100644
--- a/lib/arm/gic-v3-its.c
+++ b/lib/arm/gic-v3-its.c
@@ -199,3 +199,21 @@ void init_cmd_queue(void)
 	its_data.cmd_write =3D its_data.cmd_base;
 	writeq(0, its_data.base + GITS_CWRITER);
 }
+
+void gicv3_rdist_ctrl_lpi(u32 redist, bool set)
+{
+	void *ptr;
+	u64 val;
+
+	if (redist >=3D nr_cpus)
+		report_abort("%s redist=3D%d >=3D cpu_count=3D%d\n",
+			     __func__, redist, nr_cpus);
+
+	ptr =3D gicv3_data.redist_base[redist];
+	val =3D readl(ptr + GICR_CTLR);
+	if (set)
+		val |=3D GICR_CTLR_ENABLE_LPIS;
+	else
+		val &=3D ~GICR_CTLR_ENABLE_LPIS;
+	writel(val,  ptr + GICR_CTLR);
+}
--=20
2.20.1

