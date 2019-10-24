Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1757E3370
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393532AbfJXNHO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:07:14 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55625 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726484AbfJXNHN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 09:07:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571922432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iqMbBKNFFm9xU6vDXXB3AgHKcot1wlVfLwjUAzgtL3A=;
        b=KQnGUrHKVRJyo7PpFO3BZMhHEmGQyKZ+PxQc1bzYvFUWnKupVWWt6vqnCLsE8s96a1Djq9
        Uo7HhLJ2QvupFWf7DTHxqA6VPecFWsX6trvSGh7+Sfg+zhU90pU3iyBsjerZuUBjib/3/A
        n62Dh6PTgcdirGvXgWkh/b9BAEA/N2M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-QI-8RY-pPf6VPTQLgr-OMQ-1; Thu, 24 Oct 2019 09:07:07 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB55280183D;
        Thu, 24 Oct 2019 13:07:06 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E05E454560;
        Thu, 24 Oct 2019 13:07:05 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Andre Przywara <andre.przywara@arm.com>
Subject: [PULL 02/10] arm: gic: Split variable output data from test name
Date:   Thu, 24 Oct 2019 15:06:53 +0200
Message-Id: <20191024130701.31238-3-drjones@redhat.com>
In-Reply-To: <20191024130701.31238-1-drjones@redhat.com>
References: <20191024130701.31238-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: QI-8RY-pPf6VPTQLgr-OMQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

For some tests we mix variable diagnostic output with the test name,
which leads to variable test line, confusing some higher level
frameworks.

Split the output to always use the same test name for a certain test,
and put diagnostic output on a separate line using the INFO: tag.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/gic.c | 45 ++++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 2ec4070fbaf9..02d292807c9b 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -353,8 +353,8 @@ static void test_typer_v2(uint32_t reg)
 {
 =09int nr_gic_cpus =3D ((reg >> 5) & 0x7) + 1;
=20
-=09report("all %d CPUs have interrupts", nr_cpus =3D=3D nr_gic_cpus,
-=09       nr_gic_cpus);
+=09report_info("nr_cpus=3D%d", nr_cpus);
+=09report("all CPUs have interrupts", nr_cpus =3D=3D nr_gic_cpus);
 }
=20
 #define BYTE(reg32, byte) (((reg32) >> ((byte) * 8)) & 0xff)
@@ -370,16 +370,21 @@ static void test_typer_v2(uint32_t reg)
 static void test_byte_access(void *base_addr, u32 pattern, u32 mask)
 {
 =09u32 reg =3D readb(base_addr + 1);
+=09bool res;
=20
-=09report("byte reads successful (0x%08x =3D> 0x%02x)",
-=09       reg =3D=3D (BYTE(pattern, 1) & (mask >> 8)),
-=09       pattern & mask, reg);
+=09res =3D (reg =3D=3D (BYTE(pattern, 1) & (mask >> 8)));
+=09report("byte reads successful", res);
+=09if (!res)
+=09=09report_info("byte 1 of 0x%08x =3D> 0x%02x", pattern & mask, reg);
=20
 =09pattern =3D REPLACE_BYTE(pattern, 2, 0x1f);
 =09writeb(BYTE(pattern, 2), base_addr + 2);
 =09reg =3D readl(base_addr);
-=09report("byte writes successful (0x%02x =3D> 0x%08x)",
-=09       reg =3D=3D (pattern & mask), BYTE(pattern, 2), reg);
+=09res =3D (reg =3D=3D (pattern & mask));
+=09report("byte writes successful", res);
+=09if (!res)
+=09=09report_info("writing 0x%02x into bytes 2 =3D> 0x%08x",
+=09=09=09    BYTE(pattern, 2), reg);
 }
=20
 static void test_priorities(int nr_irqs, void *priptr)
@@ -399,15 +404,16 @@ static void test_priorities(int nr_irqs, void *priptr=
)
 =09pri_mask =3D readl(first_spi);
=20
 =09reg =3D ~pri_mask;
-=09report("consistent priority masking (0x%08x)",
+=09report("consistent priority masking",
 =09       (((reg >> 16) =3D=3D (reg & 0xffff)) &&
-=09        ((reg & 0xff) =3D=3D ((reg >> 8) & 0xff))), pri_mask);
+=09        ((reg & 0xff) =3D=3D ((reg >> 8) & 0xff))));
+=09report_info("priority mask is 0x%08x", pri_mask);
=20
 =09reg =3D reg & 0xff;
 =09for (pri_bits =3D 8; reg & 1; reg >>=3D 1, pri_bits--)
 =09=09;
-=09report("implements at least 4 priority bits (%d)",
-=09       pri_bits >=3D 4, pri_bits);
+=09report("implements at least 4 priority bits", pri_bits >=3D 4);
+=09report_info("%d priority bits implemented", pri_bits);
=20
 =09pattern =3D 0;
 =09writel(pattern, first_spi);
@@ -452,9 +458,9 @@ static void test_targets(int nr_irqs)
 =09/* Check that bits for non implemented CPUs are RAZ/WI. */
 =09if (nr_cpus < 8) {
 =09=09writel(0xffffffff, targetsptr + GIC_FIRST_SPI);
-=09=09report("bits for %d non-existent CPUs masked",
-=09=09       !(readl(targetsptr + GIC_FIRST_SPI) & ~cpu_mask),
-=09=09       8 - nr_cpus);
+=09=09report("bits for non-existent CPUs masked",
+=09=09       !(readl(targetsptr + GIC_FIRST_SPI) & ~cpu_mask));
+=09=09report_info("%d non-existent CPUs", 8 - nr_cpus);
 =09} else {
 =09=09report_skip("CPU masking (all CPUs implemented)");
 =09}
@@ -465,8 +471,10 @@ static void test_targets(int nr_irqs)
 =09pattern =3D 0x0103020f;
 =09writel(pattern, targetsptr + GIC_FIRST_SPI);
 =09reg =3D readl(targetsptr + GIC_FIRST_SPI);
-=09report("register content preserved (%08x =3D> %08x)",
-=09       reg =3D=3D (pattern & cpu_mask), pattern & cpu_mask, reg);
+=09report("register content preserved", reg =3D=3D (pattern & cpu_mask));
+=09if (reg !=3D (pattern & cpu_mask))
+=09=09report_info("writing %08x reads back as %08x",
+=09=09=09    pattern & cpu_mask, reg);
=20
 =09/* The TARGETS registers are byte accessible. */
 =09test_byte_access(targetsptr + GIC_FIRST_SPI, pattern, cpu_mask);
@@ -505,9 +513,8 @@ static void gic_test_mmio(void)
 =09       test_readonly_32(gic_dist_base + GICD_IIDR, false));
=20
 =09reg =3D readl(idreg);
-=09report("ICPIDR2 is read-only (0x%08x)",
-=09       test_readonly_32(idreg, false),
-=09       reg);
+=09report("ICPIDR2 is read-only", test_readonly_32(idreg, false));
+=09report_info("value of ICPIDR2: 0x%08x", reg);
=20
 =09test_priorities(nr_irqs, gic_dist_base + GICD_IPRIORITYR);
=20
--=20
2.21.0

