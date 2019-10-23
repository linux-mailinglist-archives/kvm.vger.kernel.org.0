Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1BBE147B
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 10:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390150AbfJWIka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 04:40:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43010 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390034AbfJWIk3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Oct 2019 04:40:29 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9N8atcC023281
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2019 04:40:28 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vtgjrwr1w-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2019 04:40:28 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 23 Oct 2019 09:40:26 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 23 Oct 2019 09:40:23 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9N8eMNd41157048
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Oct 2019 08:40:23 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB77611C050;
        Wed, 23 Oct 2019 08:40:22 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02E5E11C058;
        Wed, 23 Oct 2019 08:40:22 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Oct 2019 08:40:21 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com
Subject: [kvm-unit-tests PATCH] s390x: Fix selftest malloc check
Date:   Wed, 23 Oct 2019 04:40:17 -0400
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102308-0020-0000-0000-0000037CF971
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102308-0021-0000-0000-000021D339B5
Message-Id: <20191023084017.13142-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-23_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=878 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910230086
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit c09c54c ("lib: use an argument which doesn't require default
argument promotion") broke the selftest. Let's fix it by converting
the binary operations to bool.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/selftest.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/s390x/selftest.c b/s390x/selftest.c
index f4acdc4..9cd6943 100644
--- a/s390x/selftest.c
+++ b/s390x/selftest.c
@@ -49,9 +49,9 @@ static void test_malloc(void)
 	*tmp2 = 123456789;
 	mb();
 
-	report("malloc: got vaddr", (uintptr_t)tmp & 0xf000000000000000ul);
+	report("malloc: got vaddr", !!((uintptr_t)tmp & 0xf000000000000000ul));
 	report("malloc: access works", *tmp == 123456789);
-	report("malloc: got 2nd vaddr", (uintptr_t)tmp2 & 0xf000000000000000ul);
+	report("malloc: got 2nd vaddr", !!((uintptr_t)tmp2 & 0xf000000000000000ul));
 	report("malloc: access works", (*tmp2 == 123456789));
 	report("malloc: addresses differ", tmp != tmp2);
 
-- 
2.20.1

