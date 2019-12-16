Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8DFD1207F0
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 15:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbfLPOEI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 09:04:08 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24068 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727906AbfLPOEI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Dec 2019 09:04:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576505046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J4yj3ipSn03wddNlzO5ReaAlW0xImmllc7BWwVZtIu4=;
        b=GmSkT6+piM9hFNuV9f9tDD6sAKvK4gMPVi0B+vava7JOSErORkMp1TppqLccjV1mjzJuVB
        TdHqzj3nEmQpiLaDuBXdBfVTVy2aR+/8AERW1MgalYx7c58AKCAq+syo5+d3ib5auo4N4z
        Pi87qmXz4SA5r6mZ0X2UJW4EpejVomQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-AMQbqdvGO9uyh3GUAy7FKQ-1; Mon, 16 Dec 2019 09:04:05 -0500
X-MC-Unique: AMQbqdvGO9uyh3GUAy7FKQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92B8B100728B;
        Mon, 16 Dec 2019 14:04:03 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D0E6675B8;
        Mon, 16 Dec 2019 14:03:58 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH 07/16] arm/arm64: ITS: Set the LPI config and pending tables
Date:   Mon, 16 Dec 2019 15:02:26 +0100
Message-Id: <20191216140235.10751-8-eric.auger@redhat.com>
In-Reply-To: <20191216140235.10751-1-eric.auger@redhat.com>
References: <20191216140235.10751-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allocate the LPI configuration and per re-distributor pending table.
Set redistributor's PROPBASER and PENDBASER. The LPIs are enabled
by default in the config table.

Also introduce a helper routine that allows to set the pending table
bit for a given LPI.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 lib/arm/asm/gic-v3-its.h |  3 ++
 lib/arm/asm/gic-v3.h     | 79 ++++++++++++++++++++++++++++++++++++++++
 lib/arm/gic-v3-its.c     | 65 +++++++++++++++++++++++++++++++++
 3 files changed, 147 insertions(+)

diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
index 0c0178d..0d11aed 100644
--- a/lib/arm/asm/gic-v3-its.h
+++ b/lib/arm/asm/gic-v3-its.h
@@ -128,6 +128,9 @@ extern void its_init(void);
 extern int its_parse_baser(int i, struct its_baser *baser);
 extern void its_setup_baser(int i, struct its_baser *baser);
 extern struct its_baser *its_lookup_baser(int type);
+extern void set_lpi_config(int n, u8 val);
+extern u8 get_lpi_config(int n);
+extern void set_pending_table_bit(int rdist, int n, bool set);
=20
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM_GIC_V3_ITS_H_ */
diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index d02f4a4..5bf9a92 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -47,6 +47,83 @@
 #define MPIDR_TO_SGI_AFFINITY(cluster_id, level) \
 	(MPIDR_AFFINITY_LEVEL(cluster_id, level) << ICC_SGI1R_AFFINITY_## level=
 ## _SHIFT)
=20
+#define GIC_BASER_CACHE_nCnB            0ULL
+#define GIC_BASER_CACHE_SameAsInner     0ULL
+#define GIC_BASER_CACHE_nC              1ULL
+#define GIC_BASER_CACHE_RaWt            2ULL
+#define GIC_BASER_CACHE_RaWb            3ULL
+#define GIC_BASER_CACHE_WaWt            4ULL
+#define GIC_BASER_CACHE_WaWb            5ULL
+#define GIC_BASER_CACHE_RaWaWt          6ULL
+#define GIC_BASER_CACHE_RaWaWb          7ULL
+#define GIC_BASER_CACHE_MASK            7ULL
+#define GIC_BASER_NonShareable          0ULL
+#define GIC_BASER_InnerShareable        1ULL
+#define GIC_BASER_OuterShareable        2ULL
+#define GIC_BASER_SHAREABILITY_MASK     3ULL
+
+#define GIC_BASER_CACHEABILITY(reg, inner_outer, type)                  =
\
+	(GIC_BASER_CACHE_##type << reg##_##inner_outer##_CACHEABILITY_SHIFT)
+
+#define GIC_BASER_SHAREABILITY(reg, type)                               =
\
+	(GIC_BASER_##type << reg##_SHAREABILITY_SHIFT)
+
+#define GICR_PROPBASER_SHAREABILITY_SHIFT               (10)
+#define GICR_PROPBASER_INNER_CACHEABILITY_SHIFT         (7)
+#define GICR_PROPBASER_OUTER_CACHEABILITY_SHIFT         (56)
+#define GICR_PROPBASER_SHAREABILITY_MASK                                =
\
+	GIC_BASER_SHAREABILITY(GICR_PROPBASER, SHAREABILITY_MASK)
+#define GICR_PROPBASER_INNER_CACHEABILITY_MASK                          =
\
+	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, MASK)
+#define GICR_PROPBASER_OUTER_CACHEABILITY_MASK                          =
\
+	GIC_BASER_CACHEABILITY(GICR_PROPBASER, OUTER, MASK)
+#define GICR_PROPBASER_CACHEABILITY_MASK GICR_PROPBASER_INNER_CACHEABILI=
TY_MASK
+
+#define GICR_PROPBASER_InnerShareable                                   =
\
+	GIC_BASER_SHAREABILITY(GICR_PROPBASER, InnerShareable)
+
+#define GICR_PROPBASER_nCnB     GIC_BASER_CACHEABILITY(GICR_PROPBASER, I=
NNER, nCnB)
+#define GICR_PROPBASER_nC       GIC_BASER_CACHEABILITY(GICR_PROPBASER, I=
NNER, nC)
+#define GICR_PROPBASER_RaWt     GIC_BASER_CACHEABILITY(GICR_PROPBASER, I=
NNER, RaWt)
+#define GICR_PROPBASER_RaWb     GIC_BASER_CACHEABILITY(GICR_PROPBASER, I=
NNER, RaWt)
+#define GICR_PROPBASER_WaWt     GIC_BASER_CACHEABILITY(GICR_PROPBASER, I=
NNER, WaWt)
+#define GICR_PROPBASER_WaWb     GIC_BASER_CACHEABILITY(GICR_PROPBASER, I=
NNER, WaWb)
+#define GICR_PROPBASER_RaWaWt   GIC_BASER_CACHEABILITY(GICR_PROPBASER, I=
NNER, RaWaWt)
+#define GICR_PROPBASER_RaWaWb   GIC_BASER_CACHEABILITY(GICR_PROPBASER, I=
NNER, RaWaWb)
+
+#define GICR_PROPBASER_IDBITS_MASK                      (0x1f)
+
+#define GICR_PENDBASER_SHAREABILITY_SHIFT               (10)
+#define GICR_PENDBASER_INNER_CACHEABILITY_SHIFT         (7)
+#define GICR_PENDBASER_OUTER_CACHEABILITY_SHIFT         (56)
+#define GICR_PENDBASER_SHAREABILITY_MASK                                =
\
+	GIC_BASER_SHAREABILITY(GICR_PENDBASER, SHAREABILITY_MASK)
+#define GICR_PENDBASER_INNER_CACHEABILITY_MASK                          =
\
+	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, MASK)
+#define GICR_PENDBASER_OUTER_CACHEABILITY_MASK                          =
\
+	GIC_BASER_CACHEABILITY(GICR_PENDBASER, OUTER, MASK)
+#define GICR_PENDBASER_CACHEABILITY_MASK GICR_PENDBASER_INNER_CACHEABILI=
TY_MASK
+
+#define GICR_PENDBASER_InnerShareable                                   =
\
+	GIC_BASER_SHAREABILITY(GICR_PENDBASER, InnerShareable)
+
+#define GICR_PENDBASER_nCnB     GIC_BASER_CACHEABILITY(GICR_PENDBASER, I=
NNER, nCnB)
+#define GICR_PENDBASER_nC       GIC_BASER_CACHEABILITY(GICR_PENDBASER, I=
NNER, nC)
+#define GICR_PENDBASER_RaWt     GIC_BASER_CACHEABILITY(GICR_PENDBASER, I=
NNER, RaWt)
+#define GICR_PENDBASER_RaWb     GIC_BASER_CACHEABILITY(GICR_PENDBASER, I=
NNER, RaWt)
+#define GICR_PENDBASER_WaWt     GIC_BASER_CACHEABILITY(GICR_PENDBASER, I=
NNER, WaWt)
+#define GICR_PENDBASER_WaWb     GIC_BASER_CACHEABILITY(GICR_PENDBASER, I=
NNER, WaWb)
+#define GICR_PENDBASER_RaWaWt   GIC_BASER_CACHEABILITY(GICR_PENDBASER, I=
NNER, RaWaWt)
+#define GICR_PENDBASER_RaWaWb   GIC_BASER_CACHEABILITY(GICR_PENDBASER, I=
NNER, RaWaWb)
+
+#define GICR_PENDBASER_PTZ                              BIT_ULL(62)
+
+#define LPI_PROP_GROUP1		(1 << 1)
+#define LPI_PROP_ENABLED	(1 << 0)
+#define LPI_PROP_DEFAULT_PRIO   0xa0
+#define LPI_PROP_DEFAULT	(LPI_PROP_DEFAULT_PRIO |			\
+				LPI_PROP_GROUP1 | LPI_PROP_ENABLED)
+
 #include <asm/arch_gicv3.h>
=20
 #ifndef __ASSEMBLY__
@@ -63,6 +140,8 @@ struct gicv3_data {
 	void *dist_base;
 	void *redist_bases[GICV3_NR_REDISTS];
 	void *redist_base[NR_CPUS];
+	void *lpi_prop;
+	void *lpi_pend[NR_CPUS];
 	unsigned int irq_nr;
 };
 extern struct gicv3_data gicv3_data;
diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
index 303022f..0b5a700 100644
--- a/lib/arm/gic-v3-its.c
+++ b/lib/arm/gic-v3-its.c
@@ -123,3 +123,68 @@ void its_setup_baser(int i, struct its_baser *baser)
 	writeq(val, gicv3_its_base() + GITS_BASER + i * 8);
 }
=20
+inline void set_lpi_config(int n, u8 value)
+{
+	u8 *entry =3D (u8 *)(gicv3_data.lpi_prop + (n - 8192));
+	*entry =3D value;
+}
+
+inline u8 get_lpi_config(int n)
+{
+	u8 *entry =3D (u8 *)(gicv3_data.lpi_prop + (n - 8192));
+	return *entry;
+}
+
+/* alloc_lpi_tables: Allocate LPI config and pending tables */
+void alloc_lpi_tables(void);
+void alloc_lpi_tables(void)
+{
+	unsigned long n =3D SZ_64K >> PAGE_SHIFT;
+	unsigned long order =3D fls(n);
+	u64 prop_val;
+	int cpu;
+
+	gicv3_data.lpi_prop =3D (void *)virt_to_phys(alloc_pages(order));
+
+	/* ID bits =3D 13, ie. up to 14b LPI INTID */
+	prop_val =3D ((u64)gicv3_data.lpi_prop |
+			GICR_PROPBASER_InnerShareable |
+			GICR_PROPBASER_WaWb |
+			(13 & GICR_PROPBASER_IDBITS_MASK));
+
+	/*
+	 * Allocate pending tables for each redistributor
+	 * and set PROPBASER and PENDBASER
+	 */
+	for_each_present_cpu(cpu) {
+		u64 pend_val;
+		void *ptr;
+
+		ptr =3D gicv3_data.redist_base[cpu];
+
+		writeq(prop_val, ptr + GICR_PROPBASER);
+
+		gicv3_data.lpi_pend[cpu] =3D
+			(void *)virt_to_phys(alloc_pages(order));
+
+		pend_val =3D ((u64)gicv3_data.lpi_pend[cpu] |
+			GICR_PENDBASER_InnerShareable |
+			GICR_PENDBASER_WaWb);
+
+		writeq(pend_val, ptr + GICR_PENDBASER);
+	}
+}
+
+void set_pending_table_bit(int rdist, int n, bool set)
+{
+	u8 *ptr =3D phys_to_virt((phys_addr_t)gicv3_data.lpi_pend[rdist]);
+	u8 mask =3D 1 << (n % 8), byte;
+
+	ptr +=3D (n / 8);
+	byte =3D *ptr;
+	if (set)
+		byte |=3D  mask;
+	else
+		byte &=3D ~mask;
+	*ptr =3D byte;
+}
--=20
2.20.1

