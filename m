Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0214219A77
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 10:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgGIIH5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 04:07:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14546 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726311AbgGIIH4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jul 2020 04:07:56 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06982Zsd012968;
        Thu, 9 Jul 2020 04:07:55 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 325r2c9pay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 04:07:55 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06982fGB013546;
        Thu, 9 Jul 2020 04:07:55 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 325r2c9pa3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 04:07:55 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0698649H007141;
        Thu, 9 Jul 2020 08:07:53 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 325k2c0a8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 08:07:53 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06987p8I62062956
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Jul 2020 08:07:51 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42E39A405B;
        Thu,  9 Jul 2020 08:07:51 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3DA6A4060;
        Thu,  9 Jul 2020 08:07:50 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.34.67])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Jul 2020 08:07:50 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        drjones@redhat.com
Subject: [kvm-unit-tests PATCH v11 2/9] s390x: I/O interrupt registration
Date:   Thu,  9 Jul 2020 10:07:41 +0200
Message-Id: <1594282068-11054-3-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594282068-11054-1-git-send-email-pmorel@linux.ibm.com>
References: <1594282068-11054-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-09_04:2020-07-08,2020-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxlogscore=725
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007090059
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's make it possible to add and remove a custom io interrupt handler,
that can be used instead of the normal one.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/s390x/interrupt.c | 23 ++++++++++++++++++++++-
 lib/s390x/interrupt.h |  8 ++++++++
 2 files changed, 30 insertions(+), 1 deletion(-)
 create mode 100644 lib/s390x/interrupt.h

diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 3a40cac..243b9c2 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -10,9 +10,9 @@
  * under the terms of the GNU Library General Public License version 2.
  */
 #include <libcflat.h>
-#include <asm/interrupt.h>
 #include <asm/barrier.h>
 #include <sclp.h>
+#include <interrupt.h>
 
 static bool pgm_int_expected;
 static bool ext_int_expected;
@@ -144,12 +144,33 @@ void handle_mcck_int(void)
 		     stap(), lc->mcck_old_psw.addr);
 }
 
+static void (*io_int_func)(void);
+
 void handle_io_int(void)
 {
+	if (io_int_func)
+		return io_int_func();
+
 	report_abort("Unexpected io interrupt: on cpu %d at %#lx",
 		     stap(), lc->io_old_psw.addr);
 }
 
+int register_io_int_func(void (*f)(void))
+{
+	if (io_int_func)
+		return -1;
+	io_int_func = f;
+	return 0;
+}
+
+int unregister_io_int_func(void (*f)(void))
+{
+	if (io_int_func != f)
+		return -1;
+	io_int_func = NULL;
+	return 0;
+}
+
 void handle_svc_int(void)
 {
 	report_abort("Unexpected supervisor call interrupt: on cpu %d at %#lx",
diff --git a/lib/s390x/interrupt.h b/lib/s390x/interrupt.h
new file mode 100644
index 0000000..1973d26
--- /dev/null
+++ b/lib/s390x/interrupt.h
@@ -0,0 +1,8 @@
+#ifndef INTERRUPT_H
+#define INTERRUPT_H
+#include <asm/interrupt.h>
+
+int register_io_int_func(void (*f)(void));
+int unregister_io_int_func(void (*f)(void));
+
+#endif /* INTERRUPT_H */
-- 
2.25.1

