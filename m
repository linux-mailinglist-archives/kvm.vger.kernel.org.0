Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE98378FF0
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 16:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238068AbhEJN5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 09:57:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9438 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237257AbhEJNxQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 09:53:16 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14ADXir0190205;
        Mon, 10 May 2021 09:52:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=RSNtd0/6ioIV/Ddy1fOfeoNUssVrs/rsyrk/vjg82dM=;
 b=qnHEacRATbL8sgTrNPIMxV4hf4LWU0iG5LmNbiwFTNtiGSvSazpXZ9e+mn1D2It6OdEI
 GYsHkHgw33BtvQTHs1BHaLU6uNvM75n/5LI5AfkB6Bhqj8FCHh8OVYZ6+Pch8HCwOKzM
 oKrPyHx0DbbhDrDxPLLkAXMXlHzhoHPhAD8Sg96Fu/VBN0/EoHWEofjHYYvxE2oI/3LF
 19+wttyF2JPAsEP/kGUDHzt8/QzqP+JXALFgtTreDMRlhKo8ZwwXDxqbvOKWcwjmyovr
 yYDJh5L3LAdfes8L42Oce8VkFaBBk54AOAHvgQObjIUE9bwRKlGH4jhTLOEWXKESqwFc 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f5hrhdmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 09:52:11 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14ADXpWF190729;
        Mon, 10 May 2021 09:52:11 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f5hrhdm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 09:52:11 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14ADq8r9010219;
        Mon, 10 May 2021 13:52:08 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 38ef37gb64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 13:52:08 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14ADq5sj27787692
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 13:52:05 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FE1BA4059;
        Mon, 10 May 2021 13:52:05 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CD73A404D;
        Mon, 10 May 2021 13:52:04 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 May 2021 13:52:04 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 4/6] s390x: Test for share/unshare call support before using them
Date:   Mon, 10 May 2021 13:51:46 +0000
Message-Id: <20210510135148.1904-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210510135148.1904-1-frankja@linux.ibm.com>
References: <20210510135148.1904-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aR9bkLZsVNVE7KSF4AZ2Rs-zLtHGYSid
X-Proofpoint-ORIG-GUID: byretbqy5HQ3MDeXoYuoyp0W6AtEoooN
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_07:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 mlxscore=0 malwarescore=0 priorityscore=1501 spamscore=0 impostorscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105100096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Testing for facility only means the UV Call facility is available.
The UV will only indicate the share/unshare calls for a protected
guest 2, so let's also check that.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/malloc_io.c | 5 +++--
 s390x/uv-guest.c      | 6 ++++++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
index 1dcf1691..78582eac 100644
--- a/lib/s390x/malloc_io.c
+++ b/lib/s390x/malloc_io.c
@@ -19,6 +19,7 @@
 #include <alloc_page.h>
 #include <asm/facility.h>
 #include <bitops.h>
+#include <uv.h>
 
 static int share_pages(void *p, int count)
 {
@@ -47,7 +48,7 @@ void *alloc_io_mem(int size, int flags)
 	assert(size);
 
 	p = alloc_pages_flags(order, AREA_DMA31 | flags);
-	if (!p || !test_facility(158))
+	if (!p || !uv_os_is_guest())
 		return p;
 
 	n = share_pages(p, 1 << order);
@@ -65,7 +66,7 @@ void free_io_mem(void *p, int size)
 
 	assert(IS_ALIGNED((uintptr_t)p, PAGE_SIZE));
 
-	if (test_facility(158))
+	if (uv_os_is_guest())
 		unshare_pages(p, 1 << order);
 	free_pages(p);
 }
diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
index 393d7f5c..e99029a7 100644
--- a/s390x/uv-guest.c
+++ b/s390x/uv-guest.c
@@ -16,6 +16,7 @@
 #include <asm/facility.h>
 #include <asm/uv.h>
 #include <sclp.h>
+#include <uv.h>
 
 static unsigned long page;
 
@@ -142,6 +143,11 @@ int main(void)
 		goto done;
 	}
 
+	if (!uv_os_is_guest()) {
+		report_skip("Not a protected guest");
+		goto done;
+	}
+
 	page = (unsigned long)alloc_page();
 	test_priv();
 	test_invalid();
-- 
2.30.2

