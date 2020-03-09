Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAAD17DD61
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 11:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgCIKZD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 06:25:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37418 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726670AbgCIKZD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 06:25:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583749502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sjeRUItsN5QZDklzdwBPo763iQ3rNcg6V7tG1clJXvA=;
        b=cGUjZf5STHzj3qRvEgplADnASJyCXWwDz3kyaI3fQrlHTpXYWgt8JWUkz8aVjfmn7xVq2N
        wwNm3iDoO7BnwkXKMuM5n5rvUqA7/2myRCJN6cWHcOiMHQmHoCR7Gv4BwYTjjQYVZzxfQK
        c57c7YQJMxk/McAZWDeAD6J4OcX7/K4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-FvqzZegDMhq6hmfT8eg4Ow-1; Mon, 09 Mar 2020 06:24:58 -0400
X-MC-Unique: FvqzZegDMhq6hmfT8eg4Ow-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D8AFDB25;
        Mon,  9 Mar 2020 10:24:57 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-59.ams2.redhat.com [10.36.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3560F87B08;
        Mon,  9 Mar 2020 10:24:54 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v4 05/13] arm/arm64: gicv3: Set the LPI config and pending tables
Date:   Mon,  9 Mar 2020 11:24:12 +0100
Message-Id: <20200309102420.24498-6-eric.auger@redhat.com>
In-Reply-To: <20200309102420.24498-1-eric.auger@redhat.com>
References: <20200309102420.24498-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

v2 -> v3:
- Move the helpers in lib/arm/gic-v3.c and prefix them with "gicv3_"
  and add _lpi prefix too

v1 -> v2:
- remove memory attributes
---
 lib/arm/asm/gic-v3.h | 16 +++++++++++
 lib/arm/gic-v3.c     | 64 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index 47df051..12134ef 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -50,6 +50,16 @@
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
@@ -66,6 +76,8 @@ struct gicv3_data {
 	void *dist_base;
 	void *redist_bases[GICV3_NR_REDISTS];
 	void *redist_base[NR_CPUS];
+	void *lpi_prop;
+	void *lpi_pend[NR_CPUS];
 	unsigned int irq_nr;
 };
 extern struct gicv3_data gicv3_data;
@@ -82,6 +94,10 @@ extern void gicv3_write_eoir(u32 irqstat);
 extern void gicv3_ipi_send_single(int irq, int cpu);
 extern void gicv3_ipi_send_mask(int irq, const cpumask_t *dest);
 extern void gicv3_set_redist_base(size_t stride);
+extern void gicv3_lpi_set_config(int n, u8 val);
+extern u8 gicv3_lpi_get_config(int n);
+extern void gicv3_lpi_set_pending_table_bit(int rdist, int n, bool set);
+extern void gicv3_lpi_alloc_tables(void);
=20
 static inline void gicv3_do_wait_for_rwp(void *base)
 {
diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
index feecb5e..949a986 100644
--- a/lib/arm/gic-v3.c
+++ b/lib/arm/gic-v3.c
@@ -5,6 +5,7 @@
  */
 #include <asm/gic.h>
 #include <asm/io.h>
+#include <alloc_page.h>
=20
 void gicv3_set_redist_base(size_t stride)
 {
@@ -147,3 +148,66 @@ void gicv3_ipi_send_single(int irq, int cpu)
 	cpumask_set_cpu(cpu, &dest);
 	gicv3_ipi_send_mask(irq, &dest);
 }
+
+#if defined(__aarch64__)
+/* alloc_lpi_tables: Allocate LPI config and pending tables */
+void gicv3_lpi_alloc_tables(void)
+{
+	unsigned long n =3D SZ_64K >> PAGE_SHIFT;
+	unsigned long order =3D fls(n);
+	u64 prop_val;
+	int cpu;
+
+	gicv3_data.lpi_prop =3D alloc_pages(order);
+
+	/* ID bits =3D 13, ie. up to 14b LPI INTID */
+	prop_val =3D (u64)virt_to_phys(gicv3_data.lpi_prop) | 13;
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
+		gicv3_data.lpi_pend[cpu] =3D alloc_pages(order);
+
+		pend_val =3D (u64)virt_to_phys(gicv3_data.lpi_pend[cpu]);
+
+		writeq(pend_val, ptr + GICR_PENDBASER);
+	}
+}
+
+void gicv3_lpi_set_config(int n, u8 value)
+{
+	u8 *entry =3D (u8 *)(gicv3_data.lpi_prop + (n - 8192));
+
+	*entry =3D value;
+}
+
+u8 gicv3_lpi_get_config(int n)
+{
+	u8 *entry =3D (u8 *)(gicv3_data.lpi_prop + (n - 8192));
+
+	return *entry;
+}
+
+void gicv3_lpi_set_pending_table_bit(int rdist, int n, bool set)
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
+#endif /* __aarch64__ */
--=20
2.20.1

