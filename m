Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B97B6D19C9
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 10:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjCaI1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 04:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbjCaI1e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 04:27:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11327B46F
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 01:27:33 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32V6eZmV002482
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 08:27:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mUc+xBt7OfyHHld434uYoIdowf6jdJHZwqOXF0lvAg8=;
 b=ODZKHsDG3zRSKDTiKYEdfizvoXtAg14IWsEClXprXHhhOvAhZWYocobExnSQYeHPpwDb
 o5MPXW57PXl9kJGJfob3M3BPwe/E8iaSRlCDSj9BhYR/tLiu680tL0CTXD/KKkNkHVqq
 NpIbwYb8yDu4vLXa2Kbp/YsUygHWU4lz3DKlpbILwg9dePxirDtbiBxB51ocQ6zpuZXM
 ob5iqzI+PqJRI88vb/u7GBqv6htK8Jn7vZ4jNP5G0VHg9tVejuSPP/eJ3cParFMOOm+B
 57oeGiuUURwdjfkAm8h83kLWyxE4kdkAKe+Ps2rxZ5k/I7XaNOCZYssLdJDc0XhaqJg6 vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnssak3v8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 08:27:32 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32V8O2ch015209
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 08:27:32 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnssak3th-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 08:27:32 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32UMQnih009344;
        Fri, 31 Mar 2023 08:27:26 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3phrk6pjcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 08:27:26 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32V8RMDm44499394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 08:27:23 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7C8020049;
        Fri, 31 Mar 2023 08:27:22 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B11120043;
        Fri, 31 Mar 2023 08:27:22 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.fritz.box (unknown [9.171.68.115])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 31 Mar 2023 08:27:22 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH v4] s390x/Makefile: refactor CPPFLAGS
Date:   Fri, 31 Mar 2023 10:27:09 +0200
Message-Id: <20230331082709.35955-1-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <168024782639.521366.8153497247119888695@t14-nrb>
References: <168024782639.521366.8153497247119888695@t14-nrb>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LUrr6CQSCr6HImt6K-pNrnoqG0Ha_hV7
X-Proofpoint-GUID: SW5yFA3nTkmDOY1k1wU0pZSrilgYURWB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_04,2023-03-30_04,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 mlxlogscore=825 clxscore=1015 phishscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303310061
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This change makes it easier to reuse them. While at it, add a comment
why the `lib` include path is required.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 s390x/Makefile | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index 71e6563bbb61..06720aace828 100644
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
2.34.1

