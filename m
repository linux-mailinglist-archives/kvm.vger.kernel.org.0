Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65266F164A
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 13:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731366AbfKFMrk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 07:47:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47239 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731055AbfKFMrj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 07:47:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573044458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oZ5DlZZRn/H8QWvlIUGoovruvTB43OZ3JDNZPnaz2gs=;
        b=C+QUuuPoyQNYk93PuatZ5t0cSwLRJ6uEm2TayaVQfGaGJMjbFyA6fZXV+KAjYlIeV7PYg8
        L/4KaXarRIwWgR0BOkDTmi8Dh91U048W2gyeKiN3NWWGk0/xc0lkUfBtXpoQvhyVddou5a
        Q012Wa2DEEpuK6iYYaJcXocgZn4G3Vg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-z2Q2i2huO4yiu-HLLVnw9g-1; Wed, 06 Nov 2019 07:47:36 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3920A1800D6B
        for <kvm@vger.kernel.org>; Wed,  6 Nov 2019 12:47:35 +0000 (UTC)
Received: from virtlab512.virt.lab.eng.bos.redhat.com (virtlab512.virt.lab.eng.bos.redhat.com [10.19.152.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6512D600CC;
        Wed,  6 Nov 2019 12:47:29 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, thuth@redhat.com,
        mtosatti@redhat.com
Subject: [kvm-unit-tests Patch v1 2/2] x86: ioapic: Test physical and logical destination mode
Date:   Wed,  6 Nov 2019 07:47:09 -0500
Message-Id: <1573044429-7390-3-git-send-email-nitesh@redhat.com>
In-Reply-To: <1573044429-7390-1-git-send-email-nitesh@redhat.com>
References: <1573044429-7390-1-git-send-email-nitesh@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: z2Q2i2huO4yiu-HLLVnw9g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch tests the physical destination mode by sending an
interrupt to one of the vcpus and logical destination mode by
sending an interrupt to more than one vcpus.

Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
---
 x86/ioapic.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++
 1 file changed, 65 insertions(+)

diff --git a/x86/ioapic.c b/x86/ioapic.c
index c32dabd..31aec03 100644
--- a/x86/ioapic.c
+++ b/x86/ioapic.c
@@ -405,12 +405,73 @@ static void test_ioapic_self_reconfigure(void)
 =09report("Reconfigure self", g_isr_84 =3D=3D 1 && e.remote_irr =3D=3D 0);
 }
=20
+static volatile int g_isr_85;
+
+static void ioapic_isr_85(isr_regs_t *regs)
+{
+=09++g_isr_85;
+=09set_irq_line(0x0e, 0);
+=09eoi();
+}
+
+static void test_ioapic_physical_destination_mode(void)
+{
+=09ioapic_redir_entry_t e =3D {
+=09=09.vector =3D 0x85,
+=09=09.delivery_mode =3D 0,
+=09=09.dest_mode =3D 0,
+=09=09.dest_id =3D 0x1,
+=09=09.trig_mode =3D TRIGGER_LEVEL,
+=09};
+=09handle_irq(0x85, ioapic_isr_85);
+=09ioapic_write_redir(0xe, e);
+=09set_irq_line(0x0e, 1);
+=09do {
+=09=09pause();
+=09} while(g_isr_85 !=3D 1);
+=09report("ioapic physical destination mode", g_isr_85 =3D=3D 1);
+}
+
+static volatile int g_isr_86;
+
+static void ioapic_isr_86(isr_regs_t *regs)
+{
+=09++g_isr_86;
+=09set_irq_line(0x0e, 0);
+=09eoi();
+}
+
+static void test_ioapic_logical_destination_mode(void)
+{
+=09/* Number of vcpus which are configured/set in dest_id */
+=09int nr_vcpus =3D 3;
+=09ioapic_redir_entry_t e =3D {
+=09=09.vector =3D 0x86,
+=09=09.delivery_mode =3D 0,
+=09=09.dest_mode =3D 1,
+=09=09.dest_id =3D 0xd,
+=09=09.trig_mode =3D TRIGGER_LEVEL,
+=09};
+=09handle_irq(0x86, ioapic_isr_86);
+=09ioapic_write_redir(0xe, e);
+=09set_irq_line(0x0e, 1);
+=09do {
+=09=09pause();
+=09} while(g_isr_86 < nr_vcpus);
+=09report("ioapic logical destination mode", g_isr_86 =3D=3D nr_vcpus);
+}
+
+static void update_cr3(void *cr3)
+{
+=09write_cr3((ulong)cr3);
+}
=20
 int main(void)
 {
 =09setup_vm();
 =09smp_init();
=20
+=09on_cpus(update_cr3, (void *)read_cr3());
 =09mask_pic_interrupts();
=20
 =09if (enable_x2apic())
@@ -448,7 +509,11 @@ int main(void)
 =09=09test_ioapic_edge_tmr_smp(true);
=20
 =09=09test_ioapic_self_reconfigure();
+=09=09test_ioapic_physical_destination_mode();
 =09}
=20
+=09if (cpu_count() > 3)
+=09=09test_ioapic_logical_destination_mode();
+
 =09return report_summary();
 }
--=20
1.8.3.1

