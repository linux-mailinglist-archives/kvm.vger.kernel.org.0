Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C801A6D1F14
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 13:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbjCaLcK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 07:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbjCaLcI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 07:32:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16951EA06
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 04:31:35 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32V9EGlu021038;
        Fri, 31 Mar 2023 11:30:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=l5l4q23RGMnutNa/7XCsxjMtV7gtI0yTPTrgJQkADdc=;
 b=KlW+oxKnFJZN1A5+iqQCbYYQgBXo6dSEVQZIkRfxUkmhDUCaUhMcL0x5N9BGgZCg685v
 EFduwRc3XqAVnZiGCvJmTA/vyfSjjBXWIzQ3HnSCkuEjGhZArbDteC6xFnyW8N3OuyxF
 bvbtSo6BiKNfrt1fJ9vB1LD0qWwU6DKPdMvkB4Fx6eu7o1jipN9AeJSumFA0CPyC4xoR
 kxSfsn/cXXfH6ce0jiq/1FfXivdSMHjgzBG0RkBQL+y4pdK5EmULkKAfHo/lCrTc+z9h
 qNwgpv490a5OanX86bjzTAD1JKCfYvdGlvg3m07bRxZv0PyOgg3qxpSNtbms+/Cwgoam Iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnvq9k8px-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 11:30:53 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32VBOeJl009206;
        Fri, 31 Mar 2023 11:30:53 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnvq9k8p5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 11:30:53 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32UMQnrh009344;
        Fri, 31 Mar 2023 11:30:51 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3phrk6ppgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 11:30:50 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32VBUlnI13959804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 11:30:47 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E8AB20040;
        Fri, 31 Mar 2023 11:30:47 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C46F2004D;
        Fri, 31 Mar 2023 11:30:46 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.9.190])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 31 Mar 2023 11:30:46 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 04/14] s390x/Makefile: refactor CPPFLAGS
Date:   Fri, 31 Mar 2023 13:30:18 +0200
Message-Id: <20230331113028.621828-5-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230331113028.621828-1-nrb@linux.ibm.com>
References: <20230331113028.621828-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 46qhvvx8tPAoq4M6-mnMoNMbKKaVet8Y
X-Proofpoint-ORIG-GUID: _1FOd_7S8MW42GbkyUF8R2e-ZquL5mGO
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_06,2023-03-30_04,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303310091
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Hartmayer <mhartmay@linux.ibm.com>

This change makes it easier to reuse them. While at it, add a comment
why the `lib` include path is required.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Link: https://lore.kernel.org/r/20230331082709.35955-1-mhartmay@linux.ibm.com
[ nrb: remove trailing space after INCLUDE_PATHS ]
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Tested-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index 71e6563..50171f3 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -63,9 +63,14 @@ test_cases: $(tests)
 test_cases_binary: $(tests_binary)
 test_cases_pv: $(tests_pv_binary)
 
+INCLUDE_PATHS = $(SRCDIR)/lib $(SRCDIR)/lib/s390x
+# Include generated header files (e.g. in case of out-of-source builds)
+INCLUDE_PATHS += lib
+CPPFLAGS = $(addprefix -I,$(INCLUDE_PATHS))
+
 CFLAGS += -std=gnu99
 CFLAGS += -ffreestanding
-CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/s390x -I lib
+CFLAGS += $(CPPFLAGS)
 CFLAGS += -O2
 CFLAGS += -march=zEC12
 CFLAGS += -mbackchain
-- 
2.39.2

