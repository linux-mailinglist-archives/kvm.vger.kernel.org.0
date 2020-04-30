Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6EF1C0018
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 17:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgD3PYv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 11:24:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50994 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727023AbgD3PYu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 11:24:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588260289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q5GKqRnjYp5mTrr/vaK3WIjudXVRWTOcF+rQCTHEjYE=;
        b=a8utEhas7uYcRqXHDmvdk/xd17ofJmXRQMmqw7Bx5ivkrdxPfPl+0JgW/KJH4KWQqCnTRj
        ALn019zdu+yKROx7ouu00lr3FnzIFw8zQn4ssdVcG1vU2dLNIOyCcD3BzAUtwH6ojso+VT
        a7a/Z1UA7sRCCk/FhavvHwMFpkhe4X0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-zdbk4-LxPXKYXB-rP9WeQQ-1; Thu, 30 Apr 2020 11:24:44 -0400
X-MC-Unique: zdbk4-LxPXKYXB-rP9WeQQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31D8E1B18BC0;
        Thu, 30 Apr 2020 15:24:43 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A42595EDE3;
        Thu, 30 Apr 2020 15:24:41 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PULL 04/17] s390x: Add stsi 3.2.2 tests
Date:   Thu, 30 Apr 2020 17:24:17 +0200
Message-Id: <20200430152430.40349-5-david@redhat.com>
In-Reply-To: <20200430152430.40349-1-david@redhat.com>
References: <20200430152430.40349-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Subcode 3.2.2 is handled by KVM/QEMU and should therefore be tested
a bit more thoroughly.

In this test we set a custom name and uuid through the QEMU command
line. Both parameters will be passed to the guest on a stsi subcode
3.2.2 call and will then be checked.

We also compare the configured cpu numbers against the smp reported
numbers and if the reserved + configured add up to the total number
reported.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <20200331071456.3302-1-frankja@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 s390x/stsi.c        | 73 +++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |  1 +
 2 files changed, 74 insertions(+)

diff --git a/s390x/stsi.c b/s390x/stsi.c
index e9206bc..66b4257 100644
--- a/s390x/stsi.c
+++ b/s390x/stsi.c
@@ -14,7 +14,28 @@
 #include <asm/page.h>
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
+#include <smp.h>
=20
+struct stsi_322 {
+	uint8_t reserved[31];
+	uint8_t count;
+	struct {
+		uint8_t reserved2[4];
+		uint16_t total_cpus;
+		uint16_t conf_cpus;
+		uint16_t standby_cpus;
+		uint16_t reserved_cpus;
+		uint8_t name[8];
+		uint32_t caf;
+		uint8_t cpi[16];
+		uint8_t reserved5[3];
+		uint8_t ext_name_encoding;
+		uint32_t reserved3;
+		uint8_t uuid[16];
+	} vm[8];
+	uint8_t reserved4[1504];
+	uint8_t ext_names[8][256];
+};
 static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE *=
 2)));
=20
 static void test_specs(void)
@@ -76,11 +97,63 @@ static void test_fc(void)
 	report(stsi_get_fc(pagebuf) >=3D 2, "query fc >=3D 2");
 }
=20
+static void test_3_2_2(void)
+{
+	int rc;
+	/* EBCDIC for "kvm-unit" */
+	const uint8_t vm_name[] =3D { 0x92, 0xa5, 0x94, 0x60, 0xa4, 0x95, 0x89,
+				    0xa3 };
+	const uint8_t uuid[] =3D { 0x0f, 0xb8, 0x4a, 0x86, 0x72, 0x7c,
+				 0x11, 0xea, 0xbc, 0x55, 0x02, 0x42, 0xac, 0x13,
+				 0x00, 0x03 };
+	/* EBCDIC for "KVM/" */
+	const uint8_t cpi_kvm[] =3D { 0xd2, 0xe5, 0xd4, 0x61 };
+	const char *vm_name_ext =3D "kvm-unit-test";
+	struct stsi_322 *data =3D (void *)pagebuf;
+
+	report_prefix_push("3.2.2");
+
+	/* Is the function code available at all? */
+	if (stsi_get_fc(pagebuf) < 3) {
+		report_skip("Running under lpar, no level 3 to test.");
+		goto out;
+	}
+
+	rc =3D stsi(pagebuf, 3, 2, 2);
+	report(!rc, "call");
+
+	/* For now we concentrate on KVM/QEMU */
+	if (memcmp(&data->vm[0].cpi, cpi_kvm, sizeof(cpi_kvm))) {
+		report_skip("Not running under KVM/QEMU.");
+		goto out;
+	}
+
+	report(!memcmp(data->vm[0].uuid, uuid, sizeof(uuid)), "uuid");
+	report(data->vm[0].conf_cpus =3D=3D smp_query_num_cpus(), "cpu # config=
ured");
+	report(data->vm[0].total_cpus =3D=3D
+	       data->vm[0].reserved_cpus + data->vm[0].conf_cpus,
+	       "cpu # total =3D=3D conf + reserved");
+	report(data->vm[0].standby_cpus =3D=3D 0, "cpu # standby");
+	report(!memcmp(data->vm[0].name, vm_name, sizeof(data->vm[0].name)),
+	       "VM name =3D=3D kvm-unit-test");
+
+	if (data->vm[0].ext_name_encoding !=3D 2) {
+		report_skip("Extended VM names are not UTF-8.");
+		goto out;
+	}
+	report(!memcmp(data->ext_names[0], vm_name_ext, sizeof(vm_name_ext)),
+		       "ext VM name =3D=3D kvm-unit-test");
+
+out:
+	report_prefix_pop();
+}
+
 int main(void)
 {
 	report_prefix_push("stsi");
 	test_priv();
 	test_specs();
 	test_fc();
+	test_3_2_2();
 	return report_summary();
 }
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 07013b2..535db21 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -71,6 +71,7 @@ extra_params=3D-device diag288,id=3Dwatchdog0 --watchdo=
g-action inject-nmi
=20
 [stsi]
 file =3D stsi.elf
+extra_params=3D-name kvm-unit-test --uuid 0fb84a86-727c-11ea-bc55-0242ac=
130003 -smp 1,maxcpus=3D8
=20
 [smp]
 file =3D smp.elf
--=20
2.25.3

