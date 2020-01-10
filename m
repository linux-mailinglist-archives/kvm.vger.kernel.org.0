Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0E6813704B
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 15:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgAJOy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 09:54:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30908 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728223AbgAJOy5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 09:54:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578668096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hnzALuqyh0uZ601oQnRmWo1hHMGDJqgYfkqYRybw578=;
        b=dTiq6sRM+EpnTaav4mR8F2LEqwoi2QL60RXCksdtSroJEsVcnqc/cl/rE5vME8147whV3y
        jfgURfQ/NB3VcnaJot8RBYXDhXYALs6fP3iVb6xQdGNSCn9ArqUPv9XaVhkNyXUDTW1VEx
        2/5svbpNJJo99585GmFnNlSSI7RR81E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-L6q4vxrGMBe3EPeq3xolFw-1; Fri, 10 Jan 2020 09:54:55 -0500
X-MC-Unique: L6q4vxrGMBe3EPeq3xolFw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 408CE2F63;
        Fri, 10 Jan 2020 14:54:53 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-117-108.ams2.redhat.com [10.36.117.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 520987BA5F;
        Fri, 10 Jan 2020 14:54:50 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 07/16] arm/arm64: ITS: Set the LPI config and pending tables
Date:   Fri, 10 Jan 2020 15:54:03 +0100
Message-Id: <20200110145412.14937-8-eric.auger@redhat.com>
In-Reply-To: <20200110145412.14937-1-eric.auger@redhat.com>
References: <20200110145412.14937-1-eric.auger@redhat.com>
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

v1 -> v2:
- remove memory attributes
---
 lib/arm/asm/gic-v3-its.h |  3 ++
 lib/arm/asm/gic-v3.h     | 12 ++++++++
 lib/arm/gic-v3-its.c     | 60 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 75 insertions(+)

diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
index 5a4dfe9..2f8b8f1 100644
--- a/lib/arm/asm/gic-v3-its.h
+++ b/lib/arm/asm/gic-v3-its.h
@@ -90,6 +90,9 @@ extern void its_init(void);
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
index ffb2e26..90a7304 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -48,6 +48,16 @@
 #define MPIDR_TO_SGI_AFFINITY(cluster_id, level) \
 	(MPIDR_AFFINITY_LEVEL(cluster_id, level) << ICC_SGI1R_AFFINITY_## level=
 ## _SHIFT)
=20
+#define GICR_PROPBASER_IDBITS_MASK                      (0x1f)
+
+#define GICR_PENDBASER_PTZ                              BIT_ULL(62)
+
+#define LPI_PROP_GROUP1		(1 << 1)
+#define LPI_PROP_ENABLED	(1 << 0)
+#define LPI_PROP_DEFAULT_PRIO   0xa0
+#define LPI_PROP_DEFAULT	(LPI_PROP_DEFAULT_PRIO | LPI_PROP_GROUP1 | \
+				 LPI_PROP_ENABLED)
+
 #include <asm/arch_gicv3.h>
=20
 #ifndef __ASSEMBLY__
@@ -64,6 +74,8 @@ struct gicv3_data {
 	void *dist_base;
 	void *redist_bases[GICV3_NR_REDISTS];
 	void *redist_base[NR_CPUS];
+	void *lpi_prop;
+	void *lpi_pend[NR_CPUS];
 	unsigned int irq_nr;
 };
 extern struct gicv3_data gicv3_data;
diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
index 79946c3..6c97569 100644
--- a/lib/arm/gic-v3-its.c
+++ b/lib/arm/gic-v3-its.c
@@ -117,3 +117,63 @@ void its_setup_baser(int i, struct its_baser *baser)
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
+	prop_val =3D (u64)gicv3_data.lpi_prop | 13;
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
+		pend_val =3D (u64)gicv3_data.lpi_pend[cpu];
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

