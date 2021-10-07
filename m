Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE969424F84
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 10:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240546AbhJGIyM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 04:54:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12812 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240543AbhJGIyA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 04:54:00 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1978BVmS027117;
        Thu, 7 Oct 2021 04:52:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=sk/SL9bO8Au60GOs1QxqvJjiN3uuVfgGw1KTEmB7+XU=;
 b=fi0pSIWsWBiESodOSwfUo0kpOQv1Fnf3EkUU7aN0GKEbux83htrjO3Wnlm0pGpnUELV4
 4W57o+F36Pi9z+dZ4W5ohWNaWlga+V61qXKlXowucM9F+EDPWQUE/Vk4NlPsXnYPGJOb
 Hz1o8EUtF3VNauu2ebxQM1GQ6kgsJU6bVU5JJ6pgC7n2S6FFuJfIuWpuEO4MM7iE2fwQ
 95+DaloH0wE+DxFlCCuiPkaXZm6n+5OavUR0qwRhas5SyjesbNdruXhq29WAGBi2V6Ej
 urLIeB7D58MIgAeN+1Mpu52EPnUELT9kLcVhGUvI5vA44T1V8nRDeBa5KldSLmkFz9z7 /w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bhsgpdsfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 04:52:07 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19766v2A026765;
        Thu, 7 Oct 2021 04:52:06 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bhsgpdsew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 04:52:06 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1978hM38004926;
        Thu, 7 Oct 2021 08:52:04 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3bef2ap0pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 08:52:03 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1978pt3P64815468
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Oct 2021 08:51:55 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30EB8AE079;
        Thu,  7 Oct 2021 08:51:54 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1311AE076;
        Thu,  7 Oct 2021 08:51:51 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Oct 2021 08:51:51 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 4/9] lib: s390x: uv: Add UVC_ERR_DEBUG switch
Date:   Thu,  7 Oct 2021 08:50:22 +0000
Message-Id: <20211007085027.13050-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211007085027.13050-1-frankja@linux.ibm.com>
References: <20211007085027.13050-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0sUcOFBtKxSaMrDLB65VlgPpIGKV3Cgy
X-Proofpoint-ORIG-GUID: 8OCpFkguO4yCeXext9EuVtsGFgBDZGs6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_04,2021-10-07_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110070059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Every time something goes wrong in a way we don't expect, we need to
add debug prints to some UVC to get the unexpected return code.

Let's just put the printing behind a macro so we can enable it if
needed via a simple switch.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/asm/uv.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index 2f099553..16db086d 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -12,6 +12,11 @@
 #ifndef _ASMS390X_UV_H_
 #define _ASMS390X_UV_H_
 
+/* Enables printing of command code and return codes for failed UVCs */
+#ifndef UVC_ERR_DEBUG
+#define UVC_ERR_DEBUG	0
+#endif
+
 #define UVC_RC_EXECUTED		0x0001
 #define UVC_RC_INV_CMD		0x0002
 #define UVC_RC_INV_STATE	0x0003
@@ -194,6 +199,13 @@ static inline int uv_call_once(unsigned long r1, unsigned long r2)
 		: [cc] "=d" (cc)
 		: [r1] "a" (r1), [r2] "a" (r2)
 		: "memory", "cc");
+
+	if (UVC_ERR_DEBUG && cc)
+		printf("UV call error: call %x rc %x rrc %x\n",
+		       ((struct uv_cb_header *)r2)->cmd,
+		       ((struct uv_cb_header *)r2)->rc,
+		       ((struct uv_cb_header *)r2)->rrc);
+
 	return cc;
 }
 
-- 
2.30.2

