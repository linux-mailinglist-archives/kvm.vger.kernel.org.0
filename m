Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC1A5B8BCA
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 09:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404834AbfITHue (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 03:50:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11549 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404836AbfITHue (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Sep 2019 03:50:34 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8K7ccXx056682
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2019 03:50:32 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2v4r31w17d-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2019 03:50:31 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 20 Sep 2019 08:50:30 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 20 Sep 2019 08:50:29 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8K7oSPj51970298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 07:50:28 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D41342041;
        Fri, 20 Sep 2019 07:50:28 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB5944203F;
        Fri, 20 Sep 2019 07:50:26 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.165.207])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 Sep 2019 07:50:26 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH] s390x: Fix stsi unaligned test and add selector tests
Date:   Fri, 20 Sep 2019 09:50:20 +0200
X-Mailer: git-send-email 2.17.2
X-TM-AS-GCONF: 00
x-cbid: 19092007-0028-0000-0000-000003A05D75
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19092007-0029-0000-0000-000024626749
Message-Id: <20190920075020.1698-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-20_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=954 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909200077
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alignment and selectors test order is not specified and so, if you
have an unaligned address and invalid selectors it's up to the
hypervisor to decide which error is presented.

Let's add valid selectors to the unalignmnet test and add selector
tests.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/stsi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/s390x/stsi.c b/s390x/stsi.c
index 7232cb0..c5bd0a2 100644
--- a/s390x/stsi.c
+++ b/s390x/stsi.c
@@ -35,7 +35,7 @@ static void test_specs(void)
 
 	report_prefix_push("unaligned");
 	expect_pgm_int();
-	stsi(pagebuf + 42, 1, 0, 0);
+	stsi(pagebuf + 42, 1, 1, 1);
 	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
 	report_prefix_pop();
 
@@ -71,6 +71,8 @@ static inline unsigned long stsi_get_fc(void *addr)
 static void test_fc(void)
 {
 	report("invalid fc",  stsi(pagebuf, 7, 0, 0) == 3);
+	report("invalid selector 1", stsi(pagebuf, 1, 0, 1) == 3);
+	report("invalid selector 2", stsi(pagebuf, 1, 1, 0) == 3);
 	report("query fc >= 2",  stsi_get_fc(pagebuf) >= 2);
 }
 
-- 
2.17.2

