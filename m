Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77262B68ED
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 16:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgKQPnD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 10:43:03 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15098 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726479AbgKQPnC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Nov 2020 10:43:02 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHFVuG4147819;
        Tue, 17 Nov 2020 10:43:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gdSqEHS6cMQxbcyRcfGRqJBkOH7x72iI7DFPSPeC5QY=;
 b=MFzOFKJ272N3bH9h63qZsIpMUGNX9fcY6YPIcbvudBiZngal6R5bjYndPlOcbr56/M9C
 P68tRWAPQPtiYyDQHfwhlgDlJAN3YPsb3eJHC32YqPzZLt8LytdBedoGvX1+AMz3KC4z
 UmilrIvWltwZezkhcizZTHPVaoFVVlsCKDmpWhMgdSyzUnVZ4QXnDIpruYWJPh7H9R8M
 7ZV+zKl/W1f1D1ummf4SBaESwpM3PJphG7l/VvlMCqds29y0PDz4W16Qml7qpfoRxM/4
 M+ODFU+9LQmRIG+F3Az0Y54N1qfmw+mZeHh11po9j+QvPOamIYqQL1Q03/gMgbp6d56A TA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34veev6x4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 10:43:01 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AHFdp54011024;
        Tue, 17 Nov 2020 10:43:00 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34veev6x3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 10:43:00 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHFgv9x010893;
        Tue, 17 Nov 2020 15:42:58 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 34t6v8b83a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 15:42:58 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHFgtsO4522498
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 15:42:55 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B66C4C040;
        Tue, 17 Nov 2020 15:42:55 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78C904C044;
        Tue, 17 Nov 2020 15:42:54 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 Nov 2020 15:42:54 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 3/5] s390x: SCLP feature checking
Date:   Tue, 17 Nov 2020 10:42:13 -0500
Message-Id: <20201117154215.45855-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201117154215.45855-1-frankja@linux.ibm.com>
References: <20201117154215.45855-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_04:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=1
 priorityscore=1501 adultscore=0 lowpriorityscore=0 spamscore=0
 phishscore=0 malwarescore=0 impostorscore=0 mlxlogscore=999 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Availability of SIE is announced via a feature bit in a SCLP info CPU
entry. Let's add a framework that allows us to easily check for such
facilities.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/io.c   |  1 +
 lib/s390x/sclp.c | 19 +++++++++++++++++++
 lib/s390x/sclp.h | 15 +++++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/lib/s390x/io.c b/lib/s390x/io.c
index e19a1f3..e843601 100644
--- a/lib/s390x/io.c
+++ b/lib/s390x/io.c
@@ -37,6 +37,7 @@ void setup(void)
 	setup_args_progname(ipl_args);
 	setup_facilities();
 	sclp_read_info();
+	sclp_facilities_setup();
 	sclp_console_setup();
 	sclp_memory_setup();
 	smp_setup();
diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index ea6324e..599e022 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -11,6 +11,7 @@
  */
 
 #include <libcflat.h>
+#include <bitops.h>
 #include <asm/page.h>
 #include <asm/arch_def.h>
 #include <asm/interrupt.h>
@@ -27,6 +28,7 @@ static uint64_t max_ram_size;
 static uint64_t ram_size;
 char _read_info[PAGE_SIZE] __attribute__((__aligned__(4096)));
 static ReadInfo *read_info;
+struct sclp_facilities sclp_facilities;
 
 char _sccb[PAGE_SIZE] __attribute__((__aligned__(4096)));
 static volatile bool sclp_busy;
@@ -128,6 +130,23 @@ CPUEntry *sclp_get_cpu_entries(void)
 	return (void *)read_info + read_info->offset_cpu;
 }
 
+void sclp_facilities_setup(void)
+{
+	unsigned short cpu0_addr = stap();
+	CPUEntry *cpu;
+	int i;
+
+	assert(read_info);
+
+	cpu = (void *)read_info + read_info->offset_cpu;
+	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
+		if (cpu->address == cpu0_addr) {
+			sclp_facilities.has_sief2 = test_bit_inv(SCLP_CPU_FEATURE_SIEF2_BIT, (void *)&cpu->address);
+			break;
+		}
+	}
+}
+
 /* Perform service call. Return 0 on success, non-zero otherwise. */
 int sclp_service_call(unsigned int command, void *sccb)
 {
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 6620531..bcc9f4b 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -101,6 +101,20 @@ typedef struct CPUEntry {
     uint8_t reserved1;
 } __attribute__((packed)) CPUEntry;
 
+extern struct sclp_facilities sclp_facilities;
+
+struct sclp_facilities {
+	u64 has_sief2 : 1;
+};
+
+/*
+ * test_bit() uses unsigned long ptrs so we give it the ptr to the
+ * address member and offset bits by 16.
+ */
+enum sclp_cpu_feature_bit {
+	SCLP_CPU_FEATURE_SIEF2_BIT = 16 + 4,
+};
+
 typedef struct ReadInfo {
     SCCBHeader h;
     uint16_t rnmax;
@@ -274,6 +288,7 @@ void sclp_print(const char *str);
 void sclp_read_info(void);
 int sclp_get_cpu_num(void);
 CPUEntry *sclp_get_cpu_entries(void);
+void sclp_facilities_setup(void);
 int sclp_service_call(unsigned int command, void *sccb);
 void sclp_memory_setup(void);
 uint64_t get_ram_size(void);
-- 
2.25.1

