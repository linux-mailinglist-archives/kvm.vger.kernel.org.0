Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC879197BB9
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 14:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730024AbgC3MUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 08:20:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4496 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729848AbgC3MUx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 08:20:53 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02UC4Zak024738
        for <kvm@vger.kernel.org>; Mon, 30 Mar 2020 08:20:53 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 302344fs1f-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 30 Mar 2020 08:20:52 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Mon, 30 Mar 2020 13:20:34 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 30 Mar 2020 13:20:32 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02UCKibS60293138
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Mar 2020 12:20:44 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6A53AE04D;
        Mon, 30 Mar 2020 12:20:44 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1091AE053;
        Mon, 30 Mar 2020 12:20:43 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.43.209])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 Mar 2020 12:20:43 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com,
        borntraeger@de.ibm.com
Subject: [kvm-unit-tests PATCH] s390x: Add stsi 3.2.2 tests
Date:   Mon, 30 Mar 2020 08:20:35 -0400
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20033012-0020-0000-0000-000003BE3BDA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20033012-0021-0000-0000-00002216D768
Message-Id: <20200330122035.19607-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-30_01:2020-03-27,2020-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=1 mlxlogscore=999
 adultscore=0 malwarescore=0 mlxscore=0 priorityscore=1501 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003300111
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Subcode 3.2.2 is handled by KVM/QEMU and should therefore be tested
a bit more thorough.

In this test we set a custom name and uuid through the QEMU command
line. Both parameters will be passed to the guest on a stsi subcode
3.2.2 call and will then be checked.

We also compare the total and configured cpu numbers against the smp
reported numbers.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/stsi.c        | 62 +++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |  1 +
 2 files changed, 63 insertions(+)

diff --git a/s390x/stsi.c b/s390x/stsi.c
index e9206bca137d2edb..10e588a78cc05186 100644
--- a/s390x/stsi.c
+++ b/s390x/stsi.c
@@ -14,7 +14,28 @@
 #include <asm/page.h>
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
+#include <smp.h>
 
+struct stsi_322 {
+    uint8_t  reserved[31];
+    uint8_t  count;
+    struct {
+        uint8_t  reserved2[4];
+        uint16_t total_cpus;
+        uint16_t conf_cpus;
+        uint16_t standby_cpus;
+        uint16_t reserved_cpus;
+        uint8_t  name[8];
+        uint32_t caf;
+        uint8_t  cpi[16];
+        uint8_t reserved5[3];
+        uint8_t ext_name_encoding;
+        uint32_t reserved3;
+        uint8_t uuid[16];
+    } vm[8];
+    uint8_t reserved4[1504];
+    uint8_t ext_names[8][256];
+};
 static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
 
 static void test_specs(void)
@@ -76,11 +97,52 @@ static void test_fc(void)
 	report(stsi_get_fc(pagebuf) >= 2, "query fc >= 2");
 }
 
+static void test_3_2_2(void)
+{
+	int rc;
+	/* EBCDIC for "kvm-unit" */
+	uint8_t vm_name[] = { 0x92, 0xa5, 0x94, 0x60, 0xa4, 0x95, 0x89, 0xa3 };
+	uint8_t uuid[] = { 0x0f, 0xb8, 0x4a, 0x86, 0x72, 0x7c,
+			   0x11, 0xea, 0xbc, 0x55, 0x02, 0x42, 0xac, 0x13,
+			   0x00, 0x03 };
+	/* EBCDIC for "KVM/" */
+	uint8_t cpi_kvm[] = { 0xd2, 0xe5, 0xd4, 0x61 };
+	const char *vm_name_ext = "kvm-unit-test";
+	struct stsi_322 *data = (void *)pagebuf;
+
+	/* Is the function code available at all? */
+	if (stsi_get_fc(pagebuf) < 3)
+		return;
+
+	report_prefix_push("3.2.2");
+	rc = stsi(pagebuf, 3, 2, 2);
+	report(!rc, "call");
+
+	/* For now we concentrate on KVM/QEMU */
+	if (memcmp(&data->vm[0].cpi, cpi_kvm, sizeof(cpi_kvm)))
+		goto out;
+
+	report(data->vm[0].total_cpus == smp_query_num_cpus(), "cpu # total");
+	report(data->vm[0].conf_cpus == smp_query_num_cpus(), "cpu # configured");
+	report(data->vm[0].standby_cpus == 0, "cpu # standby");
+	report(data->vm[0].reserved_cpus == 0, "cpu # reserved");
+	report(!memcmp(data->vm[0].name, vm_name, sizeof(data->vm[0].name)),
+	       "VM name == kvm-unit-test");
+	report(data->vm[0].ext_name_encoding == 2, "ext name encoding UTF-8");
+	report(!memcmp(data->ext_names[0], vm_name_ext, sizeof(vm_name_ext)),
+		       "ext VM name == kvm-unit-test");
+	report(!memcmp(data->vm[0].uuid, uuid, sizeof(uuid)), "uuid");
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
index 12d46c5b402328bb..16e876344e1957ec 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -71,6 +71,7 @@ extra_params=-device diag288,id=watchdog0 --watchdog-action inject-nmi
 
 [stsi]
 file = stsi.elf
+extra_params=-name kvm-unit-test --uuid 0fb84a86-727c-11ea-bc55-0242ac130003
 
 [smp]
 file = smp.elf
-- 
2.25.1

