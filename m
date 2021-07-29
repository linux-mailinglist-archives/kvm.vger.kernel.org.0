Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEF53DA4AB
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 15:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237686AbhG2Nsd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 09:48:33 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24068 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237816AbhG2Ns1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 09:48:27 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TDkTj7150426;
        Thu, 29 Jul 2021 09:48:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=USVgL8ddNGk6Y9ZyApptJZKXs5YWa+xUZsE8cNHY09o=;
 b=J9I6PWd1RJG14HAktljyN/6vdy/u8MUBjeesuRokkQP3fAcSOl+mwdTOZuHEbuBNgFSV
 dg3GHM9l5vZy1dNQyoAc1WdhwmDrVB1FiiuVW3Uo30G/VLSMfhwY1STQpL3GRLuMkWKd
 WEoOmeAQfRU4m6vIMMe+/2qn8PqTNRrci2e+XBmE1iZi6Dg3o2U9f5tQLTnWFR3BsAX2
 hM5A1omuMFt5CTMoFV7CzykhZNNcLRj/c/OFhQzjgX+zO+3MuhvS0gsfkGh8CwznPUbq
 zTmR3artCiR4GzBnKwWAepCbLoVgXUIDCjr30eANqezoNzihdCv2qGby5KcPraIzaQgN mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3wgw01gc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 09:48:15 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16TDkkeU151191;
        Thu, 29 Jul 2021 09:48:15 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3wgw01fj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 09:48:15 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16TDaYlr008219;
        Thu, 29 Jul 2021 13:48:13 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3a235kh544-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 13:48:13 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16TDmBNB28836184
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 13:48:11 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB4E34C0B0;
        Thu, 29 Jul 2021 13:48:10 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74C744C070;
        Thu, 29 Jul 2021 13:48:10 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 29 Jul 2021 13:48:10 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 1/4] s390x: sie: Add sie lib validity handling
Date:   Thu, 29 Jul 2021 13:48:00 +0000
Message-Id: <20210729134803.183358-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210729134803.183358-1-frankja@linux.ibm.com>
References: <20210729134803.183358-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9d_HXLttQ_T_fFkJb9nzhgQ2Ek-CI1P3
X-Proofpoint-GUID: P7gIFfRnQsNCSoTq7NnjwBOeZ7qY4z92
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_10:2021-07-29,2021-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 clxscore=1015 spamscore=0
 malwarescore=0 suspectscore=0 impostorscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's start off the SIE lib with validity handling code since that has
the least amount of dependencies to other files.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/sie.c  | 41 +++++++++++++++++++++++++++++++++++++++++
 lib/s390x/sie.h  |  3 +++
 s390x/Makefile   |  1 +
 s390x/mvpg-sie.c |  2 +-
 s390x/sie.c      |  7 +------
 5 files changed, 47 insertions(+), 7 deletions(-)
 create mode 100644 lib/s390x/sie.c

diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
new file mode 100644
index 00000000..9107519f
--- /dev/null
+++ b/lib/s390x/sie.c
@@ -0,0 +1,41 @@
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
+static uint16_t vir;
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
+	mb();
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

