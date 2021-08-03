Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F8B3DEF76
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 15:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236201AbhHCN6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 09:58:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59328 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236045AbhHCN6e (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 09:58:34 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 173DlLa7115964;
        Tue, 3 Aug 2021 09:58:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=h1JqjpHC0b+G93gxOOBVXmJGYAKUla3/oKBAm9JDJqU=;
 b=eVlH6Yl6lIhrBydtOQlQuVbKXtXUMia8Z7pOJz16fWI5Vw0x8q0emN40HEs6UPXEEjRi
 1kHypLdP9cLZvMhlFd4+9muS+9foQbBUFtYAr+AnDVA3xfO1tYckiRql7Qav0v9bF+65
 3rpYnk6ouSRXDfuMhU+efHaW6BwTzbx8853dlEsnj5PAGWnOdkgS+tWTH5GrUw+OFQNx
 ymDG/KKeyo8cP1jqJ0NjgqJZRKh0IRbRdUTkBcdSDDhnOTFtjGBXv3DErhkQLEcRE/iX
 FOkTzD46sDtJue/5eBTwnAbBIy2Sb5ylLBq4zIZPs7whT8LT1fz8MZPihMkMM3UQgbLr yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a76djhf6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 09:58:22 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 173DmQG6119663;
        Tue, 3 Aug 2021 09:58:22 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a76djhf5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 09:58:22 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 173DipeZ017815;
        Tue, 3 Aug 2021 13:58:20 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3a4wshxf4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 13:58:20 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 173DwHfr55771610
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Aug 2021 13:58:17 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94F0511C06C;
        Tue,  3 Aug 2021 13:58:17 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E1CA11C054;
        Tue,  3 Aug 2021 13:58:17 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  3 Aug 2021 13:58:17 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v2] s390x: sie: Add sie lib validity handling
Date:   Tue,  3 Aug 2021 13:57:39 +0000
Message-Id: <20210803135739.21624-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210729134803.183358-2-frankja@linux.ibm.com>
References: <20210729134803.183358-2-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: q-n3sEcTqmwbo5FUc0349nxp02fFPyMV
X-Proofpoint-GUID: ozrPSkwEQ95PVME25MlWek1QDszeeW7f
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-03_03:2021-08-03,2021-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108030090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's start off the SIE lib with validity handling code since that has
the least amount of dependencies to other files.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/sie.c  | 40 ++++++++++++++++++++++++++++++++++++++++
 lib/s390x/sie.h  |  3 +++
 s390x/Makefile   |  1 +
 s390x/mvpg-sie.c |  2 +-
 s390x/sie.c      |  7 +------
 5 files changed, 46 insertions(+), 7 deletions(-)
 create mode 100644 lib/s390x/sie.c

diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
new file mode 100644
index 00000000..15ba407c
--- /dev/null
+++ b/lib/s390x/sie.c
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Virtualization library that speeds up managing guests.
+ *
+ * Copyright (c) 2021 IBM Corp
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ */
+
+#include <asm/barrier.h>
+#include <libcflat.h>
+#include <sie.h>
+
+static bool validity_expected;
+static uint16_t vir;		/* Validity interception reason */
+
+void sie_expect_validity(void)
+{
+	validity_expected = true;
+	vir = 0;
+}
+
+void sie_check_validity(uint16_t vir_exp)
+{
+	report(vir_exp == vir, "VALIDITY: %x", vir);
+	vir = 0;
+}
+
+void sie_handle_validity(struct vm *vm)
+{
+	if (vm->sblk->icptcode != ICPT_VALIDITY)
+		return;
+
+	vir = vm->sblk->ipb >> 16;
+
+	if (!validity_expected)
+		report_abort("VALIDITY: %x", vir);
+	validity_expected = false;
+}
diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index 6ba858a2..7ff98d2d 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -197,5 +197,8 @@ struct vm {
 extern void sie_entry(void);
 extern void sie_exit(void);
 extern void sie64a(struct kvm_s390_sie_block *sblk, struct vm_save_area *save_area);
+void sie_expect_validity(void);
+void sie_check_validity(uint16_t vir_exp);
+void sie_handle_validity(struct vm *vm);
 
 #endif /* _S390X_SIE_H_ */
diff --git a/s390x/Makefile b/s390x/Makefile
index 6565561b..ef8041a6 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -71,6 +71,7 @@ cflatobjs += lib/s390x/css_dump.o
 cflatobjs += lib/s390x/css_lib.o
 cflatobjs += lib/s390x/malloc_io.o
 cflatobjs += lib/s390x/uv.o
+cflatobjs += lib/s390x/sie.o
 
 OBJDIRS += lib/s390x
 
diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
index 5e70f591..2ac91eec 100644
--- a/s390x/mvpg-sie.c
+++ b/s390x/mvpg-sie.c
@@ -39,7 +39,7 @@ static void sie(struct vm *vm)
 
 	while (vm->sblk->icptcode == 0) {
 		sie64a(vm->sblk, &vm->save_area);
-		assert(vm->sblk->icptcode != ICPT_VALIDITY);
+		sie_handle_validity(vm);
 	}
 	vm->save_area.guest.grs[14] = vm->sblk->gg14;
 	vm->save_area.guest.grs[15] = vm->sblk->gg15;
diff --git a/s390x/sie.c b/s390x/sie.c
index 134d3c4f..5c798a9e 100644
--- a/s390x/sie.c
+++ b/s390x/sie.c
@@ -24,17 +24,12 @@ static u8 *guest;
 static u8 *guest_instr;
 static struct vm vm;
 
-static void handle_validity(struct vm *vm)
-{
-	report(0, "VALIDITY: %x", vm->sblk->ipb >> 16);
-}
 
 static void sie(struct vm *vm)
 {
 	while (vm->sblk->icptcode == 0) {
 		sie64a(vm->sblk, &vm->save_area);
-		if (vm->sblk->icptcode == ICPT_VALIDITY)
-			handle_validity(vm);
+		sie_handle_validity(vm);
 	}
 	vm->save_area.guest.grs[14] = vm->sblk->gg14;
 	vm->save_area.guest.grs[15] = vm->sblk->gg15;
-- 
2.30.2

