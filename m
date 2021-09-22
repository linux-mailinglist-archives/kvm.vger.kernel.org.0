Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349FF41427C
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 09:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbhIVHUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 03:20:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7620 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233227AbhIVHUf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 03:20:35 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M5fsis008680;
        Wed, 22 Sep 2021 03:19:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=9rBWPSrop83tVPgKchgXiibsfD/1nZGS0SScpy9DODU=;
 b=L8SCW8xTTkdLaXsfnwNdi1mUv1+ttVXCkTQ0D+u+m8yWJ3TH4kbwKRPGOYzlXk8X9byD
 xRh2q7eqyOV5aTn2mKJTHdWh6x3mvZsRb7x5oA5mcNLiO5XIQPhHsXkW/38ifkwlD0Am
 Dgtp11RISURlvQ5CYV2E1I0ObzI3kftg7XoB9REMgn61ldFxmLF+NdA4khRNuSQM2nbK
 QVuUpjFITu7ieqR4NTtt6pLB+3RF7Angltnjq2GZvHlZGlIpc2hew3Ld4CNGjsldqP+u
 K0dYD3ii5jBHbwTXD5QbK24fmQ1+79kLbtiOiJvnxsC6yDXIoBB6sxxm1Ln23F4GBIgU fQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7xjf9xy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 03:19:04 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18M6Q1K3012530;
        Wed, 22 Sep 2021 03:19:04 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7xjf9xxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 03:19:04 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18M77hVO011603;
        Wed, 22 Sep 2021 07:19:01 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3b7q6juagu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 07:19:01 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18M7E8qO57016606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 07:14:08 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2951A405B;
        Wed, 22 Sep 2021 07:18:57 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 241E6A4055;
        Wed, 22 Sep 2021 07:18:57 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Sep 2021 07:18:57 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, linux-s390@vger.kernel.org,
        seiden@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 5/9] lib: s390x: uv: Add UVC_ERR_DEBUG switch
Date:   Wed, 22 Sep 2021 07:18:07 +0000
Message-Id: <20210922071811.1913-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210922071811.1913-1-frankja@linux.ibm.com>
References: <20210922071811.1913-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uxYw-SB77IEMm9tidhorLXHRtbbY4VxX
X-Proofpoint-GUID: RqMCdpsMz2UfrhQ6fkiEBYdEU3tHx9TF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_02,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 mlxscore=0 priorityscore=1501 adultscore=0 spamscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220048
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Every time something goes wrong in a way we don't expect, we need to
add debug prints to some UVC to get the unexpected return code.

Let's just put the printing behind a macro so we can enable it if
needed via a simple switch.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/uv.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index 2f099553..0e958ad7 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -12,6 +12,9 @@
 #ifndef _ASMS390X_UV_H_
 #define _ASMS390X_UV_H_
 
+/* Enables printing of command code and return codes for failed UVCs */
+#define UVC_ERR_DEBUG	0
+
 #define UVC_RC_EXECUTED		0x0001
 #define UVC_RC_INV_CMD		0x0002
 #define UVC_RC_INV_STATE	0x0003
@@ -194,6 +197,15 @@ static inline int uv_call_once(unsigned long r1, unsigned long r2)
 		: [cc] "=d" (cc)
 		: [r1] "a" (r1), [r2] "a" (r2)
 		: "memory", "cc");
+
+#if UVC_ERR_DEBUG
+	if (cc)
+		printf("UV call error: call %x rc %x rrc %x\n",
+		       ((struct uv_cb_header *)r2)->cmd,
+		       ((struct uv_cb_header *)r2)->rc,
+		       ((struct uv_cb_header *)r2)->rrc);
+#endif
+
 	return cc;
 }
 
-- 
2.30.2

