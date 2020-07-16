Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8593221E2C
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 10:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgGPIXl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jul 2020 04:23:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59228 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727033AbgGPIXi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Jul 2020 04:23:38 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06G82lWi144866;
        Thu, 16 Jul 2020 04:23:38 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32afv05t94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 04:23:38 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06G830rn145967;
        Thu, 16 Jul 2020 04:23:37 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32afv05t85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 04:23:37 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06G7fW7o016076;
        Thu, 16 Jul 2020 08:23:35 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3274pgw795-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 08:23:35 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06G8NW4Z21496314
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jul 2020 08:23:33 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C601C4C04A;
        Thu, 16 Jul 2020 08:23:32 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53D234C046;
        Thu, 16 Jul 2020 08:23:32 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.61.186])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 Jul 2020 08:23:32 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        drjones@redhat.com
Subject: [kvm-unit-tests PATCH v13 2/9] s390x: I/O interrupt registration
Date:   Thu, 16 Jul 2020 10:23:22 +0200
Message-Id: <1594887809-10521-3-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594887809-10521-1-git-send-email-pmorel@linux.ibm.com>
References: <1594887809-10521-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-16_04:2020-07-16,2020-07-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 clxscore=1015 mlxscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=741 lowpriorityscore=0 malwarescore=0 suspectscore=1
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007160058
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

