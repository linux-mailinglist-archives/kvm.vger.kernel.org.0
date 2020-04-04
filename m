Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 520B419E5D5
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 16:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgDDOjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Apr 2020 10:39:14 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32119 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726327AbgDDOjO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 4 Apr 2020 10:39:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586011153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7fGTGQzCIxrbMDmqtQNR/h/1yu6q0TCsonXheaRiMmE=;
        b=N3TzlgM1pkfsnwWpNvLK/9rj094NLvrqe0bhGf1NODvVqVaWWX7DTyV/p1WwE46sjzb2+V
        72KR8k8zfPNb9CIPEypQhLrT6VS0/roh+obDeRM6RziJ0rKPQol1E6NaJQ0Lif0oCr06va
        aoAn6/BfTz89pvdu+8l496lxbr03hp8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-Yc7whLBXOOu3YIHAf9MWog-1; Sat, 04 Apr 2020 10:39:10 -0400
X-MC-Unique: Yc7whLBXOOu3YIHAf9MWog-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89FC98017F3;
        Sat,  4 Apr 2020 14:39:09 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 793D29B912;
        Sat,  4 Apr 2020 14:39:05 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Eric Auger <eric.auger@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PULL kvm-unit-tests 31/39] arm/arm64: gicv3: Set the LPI config and pending tables
Date:   Sat,  4 Apr 2020 16:37:23 +0200
Message-Id: <20200404143731.208138-32-drjones@redhat.com>
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

Allocate the LPI configuration and per re-distributor pending table.
Set redistributor's PROPBASER and PENDBASER. The LPIs are enabled
by default in the config table.

Also introduce a helper routine that allows to set the pending
table bit for a given LPI and macros to set/get its configuration.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/arm/asm/gic-v3.h | 17 ++++++++++++++
 lib/arm/gic-v3.c     | 53 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index 47df05159ac8..fedffa8e0843 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -50,6 +50,13 @@
 #define MPIDR_TO_SGI_AFFINITY(cluster_id, level) \
 	(MPIDR_AFFINITY_LEVEL(cluster_id, level) << ICC_SGI1R_AFFINITY_## level=
 ## _SHIFT)
=20
+#define GICR_PENDBASER_PTZ		BIT_ULL(62)
+
+#define LPI_PROP_GROUP1			(1 << 1)
+#define LPI_PROP_ENABLED		(1 << 0)
+#define LPI_PROP_DEFAULT_PRIO		0xa0
+#define LPI_PROP_DEFAULT		(LPI_PROP_DEFAULT_PRIO | LPI_PROP_GROUP1 | LPI=
_PROP_ENABLED)
+
 #include <asm/arch_gicv3.h>
=20
 #ifndef __ASSEMBLY__
@@ -66,6 +73,8 @@ struct gicv3_data {
 	void *dist_base;
 	void *redist_bases[GICV3_NR_REDISTS];
 	void *redist_base[NR_CPUS];
+	u8 *lpi_prop;
+	void *lpi_pend[NR_CPUS];
 	unsigned int irq_nr;
 };
 extern struct gicv3_data gicv3_data;
@@ -82,6 +91,8 @@ extern void gicv3_write_eoir(u32 irqstat);
 extern void gicv3_ipi_send_single(int irq, int cpu);
 extern void gicv3_ipi_send_mask(int irq, const cpumask_t *dest);
 extern void gicv3_set_redist_base(size_t stride);
+extern void gicv3_lpi_set_clr_pending(int rdist, int n, bool set);
+extern void gicv3_lpi_alloc_tables(void);
=20
 static inline void gicv3_do_wait_for_rwp(void *base)
 {
@@ -127,5 +138,11 @@ static inline u64 mpidr_uncompress(u32 compressed)
 	return mpidr;
 }
=20
+#define gicv3_lpi_set_config(intid, value) ({		\
+	gicv3_data.lpi_prop[LPI_OFFSET(intid)] =3D value;	\
+})
+
+#define gicv3_lpi_get_config(intid) (gicv3_data.lpi_prop[LPI_OFFSET(inti=
d)])
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM_GIC_V3_H_ */
diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
index feecb5e67caf..6cf1d1d27340 100644
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
@@ -147,3 +148,55 @@ void gicv3_ipi_send_single(int irq, int cpu)
 	cpumask_set_cpu(cpu, &dest);
 	gicv3_ipi_send_mask(irq, &dest);
 }
+
+#if defined(__aarch64__)
+
+/*
+ * alloc_lpi_tables - Allocate LPI config and pending tables
+ * and set PROPBASER (shared by all rdistributors) and per
+ * redistributor PENDBASER.
+ *
+ * gicv3_set_redist_base() must be called before
+ */
+void gicv3_lpi_alloc_tables(void)
+{
+	unsigned long n =3D SZ_64K >> PAGE_SHIFT;
+	unsigned long order =3D fls(n);
+	u64 prop_val;
+	int cpu;
+
+	assert(gicv3_redist_base());
+
+	gicv3_data.lpi_prop =3D alloc_pages(order);
+
+	/* ID bits =3D 13, ie. up to 14b LPI INTID */
+	prop_val =3D (u64)(virt_to_phys(gicv3_data.lpi_prop)) | 13;
+
+	for_each_present_cpu(cpu) {
+		u64 pend_val;
+		void *ptr;
+
+		ptr =3D gicv3_data.redist_base[cpu];
+
+		writeq(prop_val, ptr + GICR_PROPBASER);
+
+		gicv3_data.lpi_pend[cpu] =3D alloc_pages(order);
+		pend_val =3D (u64)(virt_to_phys(gicv3_data.lpi_pend[cpu]));
+		writeq(pend_val, ptr + GICR_PENDBASER);
+	}
+}
+
+void gicv3_lpi_set_clr_pending(int rdist, int n, bool set)
+{
+	u8 *ptr =3D gicv3_data.lpi_pend[rdist];
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
2.25.1

