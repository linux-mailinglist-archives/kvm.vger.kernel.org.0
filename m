Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939F539191B
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 15:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbhEZNob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 09:44:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21024 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234145AbhEZNoZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 09:44:25 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14QDY5jv089629;
        Wed, 26 May 2021 09:42:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=IeB/JoAVLfm2HXcSjCIY0Kt4DDoOFtgvZxMUmVhmUOM=;
 b=McnjBoogvZtS8iwioltlOcc4p9zP+SgJrRKD4WdNxMWgabBFOFm6w2QS8pNcRHsxINsS
 Ezgr1+1PZrkPlZQi6LiRjjlfVXhCVSJFgoEsmeoA+8NVDrEJ9SqQMLsvQvsqSScNJ2Do
 lQeES0zDE67sFAyivIL3VF9QkXlejOwmNYjwDU1VrozFJvzTeK3/xOupSw0foavJ/YyM
 DHZO6X6WnfJIG/x33m45Ybi6aAbQ7uKKr2Lix+fWn37NeHGusqP8Q4QOusMSxbbuckmv
 M2FBHHQJxwoHUesakQ++iXdh7YBDI/fzxZzFgoG9204Zzz4+6TP36sEvInE2I8NW0YdO AQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38spn7hv12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 09:42:53 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14QDY7uK089915;
        Wed, 26 May 2021 09:42:53 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38spn7hv0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 09:42:53 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14QDbnXZ030875;
        Wed, 26 May 2021 13:42:50 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 38s1r50ac2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 13:42:50 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14QDgmCe27590976
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 13:42:48 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1922E42049;
        Wed, 26 May 2021 13:42:48 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BEDFD42047;
        Wed, 26 May 2021 13:42:47 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.7.194])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 May 2021 13:42:47 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v4 5/7] s390x: lib: add teid union and clear teid from lowcore
Date:   Wed, 26 May 2021 15:42:43 +0200
Message-Id: <20210526134245.138906-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210526134245.138906-1-imbrenda@linux.ibm.com>
References: <20210526134245.138906-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hOZNVn8lvVmT5siIpJ0vA_kK_76G0dEX
X-Proofpoint-ORIG-GUID: DmTVo_9SEZGx4WT287KTseyAYbTNwPQB
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-26_08:2021-05-26,2021-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 mlxscore=0 phishscore=0 spamscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105260091
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a union to represent Translation-Exception Identification (TEID).

Clear the TEID in expect_pgm_int clear_pgm_int.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/asm/interrupt.h | 22 ++++++++++++++++++++++
 lib/s390x/interrupt.c     |  2 ++
 2 files changed, 24 insertions(+)

diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
index bf0eb40d..b40def65 100644
--- a/lib/s390x/asm/interrupt.h
+++ b/lib/s390x/asm/interrupt.h
@@ -13,6 +13,28 @@
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
+		/* depending on the exception and the installed facilities,
+		 * the m field can indicate severel different things,
+		 * including whether the exception was triggered by a MVPG
+		 * instruction, or whether the addr field is meaningful */
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

