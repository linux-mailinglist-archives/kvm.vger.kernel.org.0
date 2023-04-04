Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7DF86D5F27
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 13:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234950AbjDDLhJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 07:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234588AbjDDLhF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 07:37:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4890430E2
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 04:36:55 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334BFDtL017356;
        Tue, 4 Apr 2023 11:36:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=WnXWZAqIQ2A/wQiQEx4XIntIlOdTAaGggtEddE9W7bY=;
 b=LNxr4kgiMtbbjqvVWAkfgNPlpjvCwjd5L3/Zy297cIRrJGoeOdnGaGnVdZYbiR86JUJ2
 5v64Y4tKnqmoKaIh7+/3cHvuIV3KbJ9hxQtnAcazByUBB7dYfAt3UjfGNFNHfERe49QV
 4+/OxXDcp1Vscp5a8WGWEnr4pWMRDSCrzMdfEL4tVdAfOY6XYFNQ86MuhjDyGtRGlJMe
 JpM4YrTbVKnS4uCMt5wbBrGKUHVUlpco+hdZke0SzrHBe8hebDq6LZxL6ThhVbDYcfY9
 V5j//SlRC3meI+uZMRiyGBjovworjwjq1eDEQfvchbDc4G43pTgxG5yJl4RbqMwfupVa Jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr2mcc6dh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:52 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334BFTuB019542;
        Tue, 4 Apr 2023 11:36:52 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr2mcc6ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:52 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33422puu001053;
        Tue, 4 Apr 2023 11:36:49 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3ppc871uv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:49 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334Bak4V12845330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 11:36:46 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4222E2004B;
        Tue,  4 Apr 2023 11:36:46 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B195F20043;
        Tue,  4 Apr 2023 11:36:45 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.55.238])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 11:36:45 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL v2 04/14] s390x/Makefile: refactor CPPFLAGS
Date:   Tue,  4 Apr 2023 13:36:29 +0200
Message-Id: <20230404113639.37544-5-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404113639.37544-1-nrb@linux.ibm.com>
References: <20230404113639.37544-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: b7MrFvp_wv17_BqpQRvMsASHtpjeAiT_
X-Proofpoint-ORIG-GUID: dy4MPPfwZ8L8dVhauj9KoY5C-NAMtU9H
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_04,2023-04-04_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 mlxlogscore=978
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040107
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
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Tested-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20230331082709.35955-1-mhartmay@linux.ibm.com
[ nrb: remove trailing whitespace after INCLUDE_PATH ]
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
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

