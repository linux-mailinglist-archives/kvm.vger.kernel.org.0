Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A92B791351
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 10:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237889AbjIDIXm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 04:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245484AbjIDIXi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 04:23:38 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9186718D;
        Mon,  4 Sep 2023 01:23:25 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38487DhD028071;
        Mon, 4 Sep 2023 08:23:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0cigm3CYcACZoik9aGFi+X8F8bPN5/9r8Qme/yUFvzA=;
 b=QF2L5c15ERJCU0fO+RQvZm1mE4D4e6p1orMZY1J/WVk4xbDgIfpPbQcvopFAuvlLovz8
 egS0UtKGUl9mvjKuHoO4MH2wsttqkM0Yufyj+zoQnMJ6QqZ2iSMe9cVGjDvHAycTqKM4
 AiROVNoNC72qT4HttFsJ169PHEbXHzyo+UKTV3w3g6NX9PxC8ykkEUvGAj/4Cqq8KwBx
 bg2rnCh4r3/tm8M/296SoJOIrFq8Iq8mjHfnnZXAuZnqbsQVm9prn6PsvlaQuy75FqRy
 N0xmrhZnLRAcbJcanfPS0Y+J5AVluzs7URShTnZz/wR8XY0FTJ53jXl8NhYUAADIQqF8 Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sw82ac39m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 08:23:24 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38487ZQE030696;
        Mon, 4 Sep 2023 08:23:24 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sw82ac39d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 08:23:24 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3846s8To001624;
        Mon, 4 Sep 2023 08:23:23 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3svfcs9ccb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 08:23:23 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3848NKc022610514
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Sep 2023 08:23:20 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CF3120040;
        Mon,  4 Sep 2023 08:23:20 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5DD022004D;
        Mon,  4 Sep 2023 08:23:20 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  4 Sep 2023 08:23:20 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v6 6/8] s390x: add test source dir to include paths
Date:   Mon,  4 Sep 2023 10:22:24 +0200
Message-ID: <20230904082318.1465055-7-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230904082318.1465055-1-nrb@linux.ibm.com>
References: <20230904082318.1465055-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IqaHBMQ_RxNw8zsz5kzStCSxKoJrSDk0
X-Proofpoint-GUID: KttPWS1-lja5at9ZLgVW2idS_YmBj25d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-04_05,2023-08-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=854 adultscore=0 phishscore=0 impostorscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309040072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sometimes, it is useful to share some defines between a snippet and a
test. By adding the source directory to include paths, header files can
be placed in the snippet directory and included from the test (or vice
versa).

This is a prerequisite for "s390x: add a test for SIE without MSO/MSL".

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index 706be7920406..9d5c08339d16 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -67,7 +67,7 @@ test_cases: $(tests)
 test_cases_binary: $(tests_binary)
 test_cases_pv: $(tests_pv_binary)
 
-INCLUDE_PATHS = $(SRCDIR)/lib $(SRCDIR)/lib/s390x
+INCLUDE_PATHS = $(SRCDIR)/lib $(SRCDIR)/lib/s390x $(SRCDIR)/s390x
 # Include generated header files (e.g. in case of out-of-source builds)
 INCLUDE_PATHS += lib
 CPPFLAGS = $(addprefix -I,$(INCLUDE_PATHS))
-- 
2.41.0

