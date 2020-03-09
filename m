Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5388617DD65
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 11:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgCIKZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 06:25:08 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50339 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726490AbgCIKZI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 06:25:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583749506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UHE2jaHMx2EkPvI2/FqDuVO4fkyIww/LmhYOOZFcS78=;
        b=dN/qkxynARjEe9s/IriRGOdDmQ8cMfmRPiitW1+pzzuVFbHCaRIFzIEoIWEtd1gZvvTA1L
        TS0BOfPjX0e0Hnfi2ZuwiQuITHgTFSZ3nQQ2W3YgJ9HmES5ZvDfBK11tXCfBINO+kWZnNN
        hu64sAD7kVFkOnRjFEVOHvKmIMWOv3U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-ZnfUZy5rOuqfB01fqZXnvQ-1; Mon, 09 Mar 2020 06:25:05 -0400
X-MC-Unique: ZnfUZy5rOuqfB01fqZXnvQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA15C477;
        Mon,  9 Mar 2020 10:25:03 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-59.ams2.redhat.com [10.36.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B508F87B08;
        Mon,  9 Mar 2020 10:25:00 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v4 07/13] arm/arm64: ITS: its_enable_defaults
Date:   Mon,  9 Mar 2020 11:24:14 +0100
Message-Id: <20200309102420.24498-8-eric.auger@redhat.com>
In-Reply-To: <20200309102420.24498-1-eric.auger@redhat.com>
References: <20200309102420.24498-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

its_enable_defaults() enable LPIs at distributor level
and ITS level.

gicv3_enable_defaults must be called before.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v3 -> v4:
- use GITS_BASER_INDIRECT & GITS_BASER_VALID in its_setup_baser()
- don't parse BASERs again in its_enable_defaults
- rename its_setup_baser into its_baser_alloc_table
- All allocations moved to the init function
- squashed "arm/arm64: gicv3: Enable/Disable LPIs at re-distributor level=
"
  into this patch
- introduce gicv3_lpi_rdist_enable and gicv3_lpi_rdist_disable
- pend and prop table bases stored as virt addresses
- move some init functions from enable() to its_init
- removed GICR_PROPBASER_IDBITS_MASK
- introduced LPI_OFFSET
- lpi_prop becomes u8 *
- gicv3_lpi_set_config/get_config became macro
- renamed gicv3_lpi_set_pending_table_bit into gicv3_lpi_set_clr_pending

v2 -> v3:
- introduce its_setup_baser in this patch
- squash "arm/arm64: ITS: Init the command queue" in this patch.
---
 lib/arm/asm/gic-v3.h       | 28 +++++++++++------
 lib/arm/gic-v3.c           | 64 ++++++++++++++++++++++----------------
 lib/arm64/asm/gic-v3-its.h |  1 +
 lib/arm64/gic-v3-its.c     | 16 ++++++++--
 4 files changed, 71 insertions(+), 38 deletions(-)

diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index 12134ef..ea9ae8e 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -50,15 +50,16 @@
 #define MPIDR_TO_SGI_AFFINITY(cluster_id, level) \
 	(MPIDR_AFFINITY_LEVEL(cluster_id, level) << ICC_SGI1R_AFFINITY_## level=
 ## _SHIFT)
=20
-#define GICR_PROPBASER_IDBITS_MASK                      (0x1f)
+#define GICR_PENDBASER_PTZ		BIT_ULL(62)
=20
-#define GICR_PENDBASER_PTZ                              BIT_ULL(62)
+#define LPI_PROP_GROUP1			(1 << 1)
+#define LPI_PROP_ENABLED		(1 << 0)
+#define LPI_PROP_DEFAULT_PRIO		0xa0
+#define LPI_PROP_DEFAULT		(LPI_PROP_DEFAULT_PRIO | LPI_PROP_GROUP1 | LPI=
_PROP_ENABLED)
=20
-#define LPI_PROP_GROUP1		(1 << 1)
-#define LPI_PROP_ENABLED	(1 << 0)
-#define LPI_PROP_DEFAULT_PRIO   0xa0
-#define LPI_PROP_DEFAULT	(LPI_PROP_DEFAULT_PRIO | LPI_PROP_GROUP1 | \
-				 LPI_PROP_ENABLED)
+#define LPI_ID_BASE			8192
+#define LPI(lpi)			((lpi) + LPI_ID_BASE)
+#define LPI_OFFSET(intid)		((intid) - LPI_ID_BASE)
=20
 #include <asm/arch_gicv3.h>
=20
@@ -76,7 +77,7 @@ struct gicv3_data {
 	void *dist_base;
 	void *redist_bases[GICV3_NR_REDISTS];
 	void *redist_base[NR_CPUS];
-	void *lpi_prop;
+	u8 *lpi_prop;
 	void *lpi_pend[NR_CPUS];
 	unsigned int irq_nr;
 };
@@ -96,8 +97,10 @@ extern void gicv3_ipi_send_mask(int irq, const cpumask=
_t *dest);
 extern void gicv3_set_redist_base(size_t stride);
 extern void gicv3_lpi_set_config(int n, u8 val);
 extern u8 gicv3_lpi_get_config(int n);
-extern void gicv3_lpi_set_pending_table_bit(int rdist, int n, bool set);
+extern void gicv3_lpi_set_clr_pending(int rdist, int n, bool set);
 extern void gicv3_lpi_alloc_tables(void);
+extern void gicv3_lpi_rdist_enable(int redist);
+extern void gicv3_lpi_rdist_disable(int redist);
=20
 static inline void gicv3_do_wait_for_rwp(void *base)
 {
@@ -143,5 +146,12 @@ static inline u64 mpidr_uncompress(u32 compressed)
 	return mpidr;
 }
=20
+#define gicv3_lpi_set_config(intid, value) ({		\
+	gicv3_data.lpi_prop[LPI_OFFSET(intid)] =3D value; \
+})
+
+#define gicv3_lpi_get_config(intid) (gicv3_data.lpi_prop[LPI_OFFSET(inti=
d)])
+
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM_GIC_V3_H_ */
diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
index 949a986..a3b55b2 100644
--- a/lib/arm/gic-v3.c
+++ b/lib/arm/gic-v3.c
@@ -150,7 +150,14 @@ void gicv3_ipi_send_single(int irq, int cpu)
 }
=20
 #if defined(__aarch64__)
-/* alloc_lpi_tables: Allocate LPI config and pending tables */
+
+/**
+ * alloc_lpi_tables - Allocate LPI config and pending tables
+ * and set PROPBASER (shared by all rdistributors) and per
+ * redistributor PENDBASER.
+ *
+ * gicv3_set_redist_base() must be called before
+ */
 void gicv3_lpi_alloc_tables(void)
 {
 	unsigned long n =3D SZ_64K >> PAGE_SHIFT;
@@ -161,13 +168,9 @@ void gicv3_lpi_alloc_tables(void)
 	gicv3_data.lpi_prop =3D alloc_pages(order);
=20
 	/* ID bits =3D 13, ie. up to 14b LPI INTID */
-	prop_val =3D (u64)virt_to_phys(gicv3_data.lpi_prop) | 13;
+	prop_val =3D (u64)(virt_to_phys(gicv3_data.lpi_prop)) | 13;
=20
-	/*
-	 * Allocate pending tables for each redistributor
-	 * and set PROPBASER and PENDBASER
-	 */
-	for_each_present_cpu(cpu) {
+	for (cpu =3D 0; cpu < nr_cpus; cpu++) {
 		u64 pend_val;
 		void *ptr;
=20
@@ -176,30 +179,14 @@ void gicv3_lpi_alloc_tables(void)
 		writeq(prop_val, ptr + GICR_PROPBASER);
=20
 		gicv3_data.lpi_pend[cpu] =3D alloc_pages(order);
-
-		pend_val =3D (u64)virt_to_phys(gicv3_data.lpi_pend[cpu]);
-
+		pend_val =3D (u64)(virt_to_phys(gicv3_data.lpi_pend[cpu]));
 		writeq(pend_val, ptr + GICR_PENDBASER);
 	}
 }
=20
-void gicv3_lpi_set_config(int n, u8 value)
+void gicv3_lpi_set_clr_pending(int rdist, int n, bool set)
 {
-	u8 *entry =3D (u8 *)(gicv3_data.lpi_prop + (n - 8192));
-
-	*entry =3D value;
-}
-
-u8 gicv3_lpi_get_config(int n)
-{
-	u8 *entry =3D (u8 *)(gicv3_data.lpi_prop + (n - 8192));
-
-	return *entry;
-}
-
-void gicv3_lpi_set_pending_table_bit(int rdist, int n, bool set)
-{
-	u8 *ptr =3D phys_to_virt((phys_addr_t)gicv3_data.lpi_pend[rdist]);
+	u8 *ptr =3D gicv3_data.lpi_pend[rdist];
 	u8 mask =3D 1 << (n % 8), byte;
=20
 	ptr +=3D (n / 8);
@@ -210,4 +197,29 @@ void gicv3_lpi_set_pending_table_bit(int rdist, int =
n, bool set)
 		byte &=3D ~mask;
 	*ptr =3D byte;
 }
+
+static void gicv3_lpi_rdist_ctrl(u32 redist, bool set)
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
+
+void gicv3_lpi_rdist_enable(int redist)
+{
+	gicv3_lpi_rdist_ctrl(redist, true);
+}
+void gicv3_lpi_rdist_disable(int redist)
+{
+	gicv3_lpi_rdist_ctrl(redist, false);
+}
 #endif /* __aarch64__ */
diff --git a/lib/arm64/asm/gic-v3-its.h b/lib/arm64/asm/gic-v3-its.h
index 331ba0e..1e95977 100644
--- a/lib/arm64/asm/gic-v3-its.h
+++ b/lib/arm64/asm/gic-v3-its.h
@@ -88,5 +88,6 @@ extern struct its_data its_data;
 extern void its_parse_typer(void);
 extern void its_init(void);
 extern int its_baser_lookup(int i, struct its_baser *baser);
+extern void its_enable_defaults(void);
=20
 #endif /* _ASMARM64_GIC_V3_ITS_H_ */
diff --git a/lib/arm64/gic-v3-its.c b/lib/arm64/gic-v3-its.c
index 23b0d06..2f480ae 100644
--- a/lib/arm64/gic-v3-its.c
+++ b/lib/arm64/gic-v3-its.c
@@ -94,9 +94,19 @@ void its_init(void)
 	its_baser_alloc_table(&its_data.device_baser, SZ_64K);
 	its_baser_alloc_table(&its_data.coll_baser, SZ_64K);
=20
-	/* Allocate LPI config and pending tables */
-	gicv3_lpi_alloc_tables();
-
 	its_cmd_queue_init();
 }
=20
+/* must be called after gicv3_enable_defaults */
+void its_enable_defaults(void)
+{
+	int i;
+
+	/* Allocate LPI config and pending tables */
+	gicv3_lpi_alloc_tables();
+
+	for (i =3D 0; i < nr_cpus; i++)
+		gicv3_lpi_rdist_enable(i);
+
+	writel(GITS_CTLR_ENABLE, its_data.base + GITS_CTLR);
+}
--=20
2.20.1

