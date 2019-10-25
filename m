Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB24DE51F5
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 19:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409759AbfJYRGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 13:06:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63686 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726511AbfJYRGo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Oct 2019 13:06:44 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9PH4Dj4018983
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 13:06:43 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vv47qj14c-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 13:06:42 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Fri, 25 Oct 2019 18:06:40 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 25 Oct 2019 18:06:38 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9PH6aSV42926234
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 17:06:36 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D304A404D;
        Fri, 25 Oct 2019 17:06:36 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46333A4057;
        Fri, 25 Oct 2019 17:06:36 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.39])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 25 Oct 2019 17:06:36 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 4/5] s390x: sclp: add service call instruction wrapper
Date:   Fri, 25 Oct 2019 19:06:33 +0200
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572023194-14370-1-git-send-email-imbrenda@linux.ibm.com>
References: <1572023194-14370-1-git-send-email-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19102517-0012-0000-0000-0000035D9A5C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102517-0013-0000-0000-00002198D1C4
Message-Id: <1572023194-14370-5-git-send-email-imbrenda@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-25_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910250157
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a wrapper for the service call instruction, and use it for SCLP
interactions instead of using inline assembly everywhere.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/arch_def.h | 13 +++++++++++++
 lib/s390x/sclp.c         |  7 +------
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 96cca2e..b3caff6 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -269,4 +269,17 @@ static inline int stsi(void *addr, int fc, int sel1, int sel2)
 	return cc;
 }
 
+static inline int servc(uint32_t command, unsigned long sccb)
+{
+	int cc;
+
+	asm volatile(
+		"       .insn   rre,0xb2200000,%1,%2\n"  /* servc %1,%2 */
+		"       ipm     %0\n"
+		"       srl     %0,28"
+		: "=&d" (cc) : "d" (command), "a" (sccb)
+		: "cc", "memory");
+	return cc;
+}
+
 #endif
diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 7798f04..e35c282 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -116,12 +116,7 @@ int sclp_service_call(unsigned int command, void *sccb)
 	int cc;
 
 	sclp_setup_int();
-	asm volatile(
-		"       .insn   rre,0xb2200000,%1,%2\n"  /* servc %1,%2 */
-		"       ipm     %0\n"
-		"       srl     %0,28"
-		: "=&d" (cc) : "d" (command), "a" (__pa(sccb))
-		: "cc", "memory");
+	cc = servc(command, __pa(sccb));
 	sclp_wait_busy();
 	if (cc == 3)
 		return -1;
-- 
2.7.4

