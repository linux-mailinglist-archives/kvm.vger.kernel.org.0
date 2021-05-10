Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFFA0378FEA
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 16:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240315AbhEJN53 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 09:57:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44790 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237019AbhEJNxQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 09:53:16 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14ADWic0009795;
        Mon, 10 May 2021 09:52:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3uZmSI77E5TGNyfkRuQlpsM6Hja+QeN+kVV0qwniZ1M=;
 b=DiUp2kV0DgerFvFHiHsR9sn9aESMgjcZutrLRyI6v5mdAc3tIlT9FB4TIEtzzVvWFvQ9
 H89Jv8pKLfDTQPdN53q4Nc8ExoKXAW+25iBD3WbB9BaNRdNlzm+mvsDqIowZV+qo/+cY
 9r0YB4ys5nygKUSoqRjLZR5Mvi9hrj44M7ycLFfmVBtDHeBu6dqMa1mSj/S3goh39UuE
 STVOqAOCq1FcPuqp0+OcTr+7WRG1g6YYRDiej06feIkFs4kibDJvnE+LDro39wDA8645
 TrWwoTv0KQEdvihgAVzqR/Kn/4PdTDgefLGdBnXGcbO+3kgbIY3mCc3jFKblNgfgUrwI Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f3s44xuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 09:52:08 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14ADWxD8010911;
        Mon, 10 May 2021 09:52:08 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f3s44xu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 09:52:07 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14ADggrl006433;
        Mon, 10 May 2021 13:52:05 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 38dj988hpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 13:52:05 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14ADq28m54133182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 13:52:02 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3FDEA4059;
        Mon, 10 May 2021 13:52:02 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D84DDA4055;
        Mon, 10 May 2021 13:52:01 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 May 2021 13:52:01 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 1/6] s390x: uv-guest: Add invalid share location test
Date:   Mon, 10 May 2021 13:51:43 +0000
Message-Id: <20210510135148.1904-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210510135148.1904-1-frankja@linux.ibm.com>
References: <20210510135148.1904-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AEnDYgOtnMfhnwDXmQ60d_cfyrzDe_gQ
X-Proofpoint-GUID: Bs1GzVKTzmTRmInuUKNpajyOo938glOG
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_07:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 priorityscore=1501
 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105100096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's also test sharing unavailable memory.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/uv-guest.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
index 99544442..a13669ab 100644
--- a/s390x/uv-guest.c
+++ b/s390x/uv-guest.c
@@ -15,6 +15,7 @@
 #include <asm/interrupt.h>
 #include <asm/facility.h>
 #include <asm/uv.h>
+#include <sclp.h>
 
 static unsigned long page;
 
@@ -99,6 +100,10 @@ static void test_sharing(void)
 	uvcb.header.len = sizeof(uvcb);
 	cc = uv_call(0, (u64)&uvcb);
 	report(cc == 0 && uvcb.header.rc == UVC_RC_EXECUTED, "share");
+	uvcb.paddr = get_ram_size() + PAGE_SIZE;
+	cc = uv_call(0, (u64)&uvcb);
+	report(cc == 1 && uvcb.header.rc == 0x101, "invalid memory");
+	uvcb.paddr = page;
 	report_prefix_pop();
 
 	report_prefix_push("unshare");
-- 
2.30.2

