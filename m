Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C3C33D07D
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 10:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236005AbhCPJU3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 05:20:29 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21070 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235958AbhCPJUK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 05:20:10 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G94RQQ030236;
        Tue, 16 Mar 2021 05:20:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=SssSl1wjs41a6BgcmEpj3X3SkkIta76MF1NJ44c4Iq0=;
 b=maWPYtEU/yWYpDXzWnauZZ3xdE/OAUdhH3RV58QFx0qRb3/qBaE30HGNeh7Hz0R/TPhm
 ETKJ3/c0VJt60LOMkY0pntCvBhvBIb9i2SauZ8eHHsSEPb5YDhj5APL3+EhuEsydhewS
 BsY2g/XO02qDNcGImYB0KLmUeRbhboLSmzt2eBr4/OzAfjRQ8p1QqprFVGjR6NZyvdiW
 oCygonRv1FIlgkwqAJo+JVVlgTkRmDyPx96frSJ5ddic6fd+ysBrRYa0h9ImzMB5UPPG
 6EGWBh1PXtMn0eNerg+4EGMpOs1rnwq2VyJYjx1uP9qznoR4EBVI+D+Iu8qaVDLfTroL iQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37ap2t6ae8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 05:20:09 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12G952F0036085;
        Tue, 16 Mar 2021 05:20:09 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37ap2t6ad6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 05:20:09 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12G9C2Wx005478;
        Tue, 16 Mar 2021 09:20:07 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 378mnh2pg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 09:20:07 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12G9K5Dq46596528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 09:20:05 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCBE74C052;
        Tue, 16 Mar 2021 09:20:04 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD17D4C06A;
        Tue, 16 Mar 2021 09:20:03 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.146.129])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 16 Mar 2021 09:20:03 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 4/6] s390x: Test for share/unshare call support before using them
Date:   Tue, 16 Mar 2021 09:16:52 +0000
Message-Id: <20210316091654.1646-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210316091654.1646-1-frankja@linux.ibm.com>
References: <20210316091654.1646-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_03:2021-03-15,2021-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 lowpriorityscore=0 adultscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 phishscore=0 clxscore=1015
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103160063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Testing for facility only means the UV Call facility is available.
The UV will only indicate the share/unshare calls for a protected
guest 2, so let's also check that.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
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
index 95a968c5..8915b2f1 100644
--- a/s390x/uv-guest.c
+++ b/s390x/uv-guest.c
@@ -16,6 +16,7 @@
 #include <asm/facility.h>
 #include <asm/uv.h>
 #include <sclp.h>
+#include <uv.h>
 
 static unsigned long page;
 
@@ -141,6 +142,11 @@ int main(void)
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
2.27.0

