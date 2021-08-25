Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D090D3F7A60
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 18:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242025AbhHYQVa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 12:21:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64452 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241738AbhHYQVR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Aug 2021 12:21:17 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17PG8c69090311
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 12:20:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=Id3xgql1xP6Kr/fNo1brGibdVk6WwllnU5sxlvzYp1I=;
 b=HgeJM1buR+CleGZWG2OFmQajpoBFqlTgNeXYMprfBl0cYSCjRPWf8ROccQmldaEANMq8
 RawzJkMfdm7sW4nQ+NTILgPc7m3LDh+phLnCu5d/kg/7hLdYe/NiTQrj3RT8hbmKwVFB
 BSxmZeYySOpbLpVXazj2Xqt4n4xrN4xygx7Pw87brrxLFKi2fADy2Ov8vsORFTkKBYDI
 mA7RJi23lt6t/ix9IuRd6Y3HvzmGgnELt7fj4IBTt18LaD5vnpNCPBY6AptFi6TRmHWN
 KipFMMLZIveNMxhfy++PErPdw8jGChyf6MZPEESSPalKB5H95S6f2AtT047JetEylWVI pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3anrs7h1fu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 12:20:30 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17PG90Yq093043
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 12:20:29 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3anrs7h1er-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Aug 2021 12:20:29 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17PGGAG6024306;
        Wed, 25 Aug 2021 16:20:27 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3ajs48ebqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Aug 2021 16:20:27 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17PGGbo152429106
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Aug 2021 16:16:37 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D308F11C058;
        Wed, 25 Aug 2021 16:20:23 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99D3B11C077;
        Wed, 25 Aug 2021 16:20:23 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.34.28])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 25 Aug 2021 16:20:23 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 2/2] s390x: fixing I/O memory allocation
Date:   Wed, 25 Aug 2021 18:20:21 +0200
Message-Id: <1629908421-8543-3-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1629908421-8543-1-git-send-email-pmorel@linux.ibm.com>
References: <1629908421-8543-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -4K6GXAS_F7tSwmQeFo9ZCoefRT4-dWg
X-Proofpoint-ORIG-GUID: Y28QTGmfGLHoRMxAMDLm1vT8JrO3KXzl
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-25_06:2021-08-25,2021-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 adultscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108250096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The allocator allocate pages it follows the size must be rounded
to pages before the allocation.

Fixes: b0fe3988 "s390x: define UV compatible I/O allocation"

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/malloc_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
index 78582eac..080fc694 100644
--- a/lib/s390x/malloc_io.c
+++ b/lib/s390x/malloc_io.c
@@ -41,7 +41,7 @@ static void unshare_pages(void *p, int count)
 
 void *alloc_io_mem(int size, int flags)
 {
-	int order = get_order(size >> PAGE_SHIFT);
+	int order = get_order(PAGE_ALIGN(size) >> PAGE_SHIFT);
 	void *p;
 	int n;
 
@@ -62,7 +62,7 @@ void *alloc_io_mem(int size, int flags)
 
 void free_io_mem(void *p, int size)
 {
-	int order = get_order(size >> PAGE_SHIFT);
+	int order = get_order(PAGE_ALIGN(size) >> PAGE_SHIFT);
 
 	assert(IS_ALIGNED((uintptr_t)p, PAGE_SIZE));
 
-- 
2.25.1

