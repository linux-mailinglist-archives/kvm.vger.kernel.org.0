Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6BCEDC86
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 11:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbfKDK30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 05:29:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5810 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726364AbfKDK30 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Nov 2019 05:29:26 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA49xYiO086778
        for <kvm@vger.kernel.org>; Mon, 4 Nov 2019 05:29:25 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w2hubrs04-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2019 05:29:24 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Mon, 4 Nov 2019 10:29:22 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 4 Nov 2019 10:29:20 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA4ASiML40698146
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Nov 2019 10:28:45 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 988D4AE04D;
        Mon,  4 Nov 2019 10:29:19 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9EC54AE059;
        Mon,  4 Nov 2019 10:29:18 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.70.20])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 Nov 2019 10:29:18 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH v2] alloc: Add memalign error checks
Date:   Mon,  4 Nov 2019 05:29:16 -0500
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19110410-0012-0000-0000-000003607A50
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110410-0013-0000-0000-0000219BCE50
Message-Id: <20191104102916.10554-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-04_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1911040100
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's test for size and alignment in memalign to catch invalid input
data. Also we need to test for NULL after calling the memalign
function of the registered alloc operations.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/alloc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/alloc.c b/lib/alloc.c
index ecdbbc4..b763c70 100644
--- a/lib/alloc.c
+++ b/lib/alloc.c
@@ -47,6 +47,8 @@ void *memalign(size_t alignment, size_t size)
 	uintptr_t mem;
 
 	assert(alloc_ops && alloc_ops->memalign);
+	if (!size || !alignment)
+		return NULL;
 	if (alignment <= sizeof(uintptr_t))
 		alignment = sizeof(uintptr_t);
 	else
@@ -55,6 +57,7 @@ void *memalign(size_t alignment, size_t size)
 	blkalign = MAX(alignment, alloc_ops->align_min);
 	size = ALIGN(size + METADATA_EXTRA, alloc_ops->align_min);
 	p = alloc_ops->memalign(blkalign, size);
+	assert(p);
 
 	/* Leave room for metadata before aligning the result.  */
 	mem = (uintptr_t)p + METADATA_EXTRA;
-- 
2.20.1

