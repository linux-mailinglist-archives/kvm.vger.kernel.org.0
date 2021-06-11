Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8B43A43C0
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 16:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbhFKOJO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 10:09:14 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26764 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231720AbhFKOJL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Jun 2021 10:09:11 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15BE4ta1187131;
        Fri, 11 Jun 2021 10:07:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Eru8csAi3k0UHTwjjkNu3G0xlTfvcIGRi9MF2WHCllc=;
 b=K+RdnRUdA24RPwYLawJVMv89KOpbbZ9X85kzTkCwBZ3ohdWKHFQcbaRqSI2Wvfs/vzuc
 omaYG/yMKzhhQDgJi03fc6dMmqUZD8a4rOokw1cRQrvbJFwegIms6HffUv5iY9NjztWI
 C5MqDeKombx3UBO2acXy9cdUxnZk1y9GU+aS/SY/w2g6TVZWUi4TIERqp+U7HBDW0LvT
 hTQRPnYqCPcLjx41A+KDH+fSVDN/IwEENOBT0ZxCD38RFF1/uU4xll9amQ7wi237B5Pz
 AtxovpX/qp2/KK7WoUTwfKh38xUPU3xiB7HbjyR9lm47f8b+KeMfg+tWswgbHkjPkGlo zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3948ye0qfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 10:07:13 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15BE5YPD189506;
        Fri, 11 Jun 2021 10:07:13 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3948ye0qeg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 10:07:12 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15BDx1db029962;
        Fri, 11 Jun 2021 14:07:10 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3900hhhx9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 14:07:10 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15BE6CUN30343488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 14:06:12 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F34FE52057;
        Fri, 11 Jun 2021 14:07:07 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.5.240])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A491A5205A;
        Fri, 11 Jun 2021 14:07:07 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v5 5/7] s390x: lib: add teid union and clear teid from lowcore
Date:   Fri, 11 Jun 2021 16:07:03 +0200
Message-Id: <20210611140705.553307-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210611140705.553307-1-imbrenda@linux.ibm.com>
References: <20210611140705.553307-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Uo0ZGPlEYk3Pyao_LZYWyLuNirAESSax
X-Proofpoint-GUID: QOOi0xWPpaMsW0mvBtvgdo7JjeLGZu8r
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_05:2021-06-11,2021-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 clxscore=1015 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106110090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a union to represent Translation-Exception Identification (TEID).

Clear the TEID in expect_pgm_int clear_pgm_int.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/interrupt.h | 24 ++++++++++++++++++++++++
 lib/s390x/interrupt.c     |  2 ++
 2 files changed, 26 insertions(+)

diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
index bf0eb40d..d9ab0bd7 100644
--- a/lib/s390x/asm/interrupt.h
+++ b/lib/s390x/asm/interrupt.h
@@ -13,6 +13,30 @@
 #define EXT_IRQ_EXTERNAL_CALL	0x1202
 #define EXT_IRQ_SERVICE_SIG	0x2401
 
+#define TEID_ASCE_PRIMARY	0
+#define TEID_ASCE_AR		1
+#define TEID_ASCE_SECONDARY	2
+#define TEID_ASCE_HOME		3
+
+union teid {
+	unsigned long val;
+	struct {
+		unsigned long addr:52;
+		unsigned long fetch:1;
+		unsigned long store:1;
+		unsigned long reserved:6;
+		unsigned long acc_list_prot:1;
+		/*
+		 * depending on the exception and the installed facilities,
+		 * the m field can indicate several different things,
+		 * including whether the exception was triggered by a MVPG
+		 * instruction, or whether the addr field is meaningful
+		 */
+		unsigned long m:1;
+		unsigned long asce_id:2;
+	};
+};
+
 void register_pgm_cleanup_func(void (*f)(void));
 void handle_pgm_int(struct stack_frame_int *stack);
 void handle_ext_int(struct stack_frame_int *stack);
diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index ce0003de..b627942f 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -22,6 +22,7 @@ void expect_pgm_int(void)
 {
 	pgm_int_expected = true;
 	lc->pgm_int_code = 0;
+	lc->trans_exc_id = 0;
 	mb();
 }
 
@@ -39,6 +40,7 @@ uint16_t clear_pgm_int(void)
 	mb();
 	code = lc->pgm_int_code;
 	lc->pgm_int_code = 0;
+	lc->trans_exc_id = 0;
 	pgm_int_expected = false;
 	return code;
 }
-- 
2.31.1

