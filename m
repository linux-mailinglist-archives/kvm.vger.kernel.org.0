Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF6266CE82
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 19:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbjAPSNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 13:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbjAPSMs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 13:12:48 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C03539B8D
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 09:59:07 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30GHRbDk016770
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:59:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gKleBRFZY2G7y5DigUGFjM4CDHZ32kawKuAlrP2L1O0=;
 b=a0Y7zrnvapKZ3o3SY5YTOZ0YjSYoHwW7PQjTJEFtVYHf4wNaxkcOlBeMNJBwN4obhQ+e
 TZBa8uWYRePlVQRA/PdDRFVyw/0bdj0iPWxs0i34ynqmwYZJkmEE/Tmxig8b2YsOkz43
 G/ackSax90F+oC+wr0ogEmG2tOkgwUF4848pXpZrgPr4qotCpjSib/W2GvYdN1+77/+Q
 4pyXv36bwSrLptdnTkOXpuFIknwlWmqtDIv+dvLlrxB+KhKp0he0dSOL3H48tTwVDeul
 ppu3Ng6eK80NVxaNq8PBiW6Slaek4As4igXuukpyh3ourX7NhBSLyPF+suByMoLm9Ytk ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n54a7kckw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:59:06 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30GHgdZD015133
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:59:05 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n54a7kckk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 17:59:05 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30GFbHge025842;
        Mon, 16 Jan 2023 17:59:03 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3n3m16j0j1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 17:59:03 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30GHx0C541681212
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 17:59:00 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36A222004D;
        Mon, 16 Jan 2023 17:59:00 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9672020040;
        Mon, 16 Jan 2023 17:58:59 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com.com (unknown [9.171.31.34])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 17:58:59 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH 5/9] s390x/Makefile: remove unused include path
Date:   Mon, 16 Jan 2023 18:57:53 +0100
Message-Id: <20230116175757.71059-6-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116175757.71059-1-mhartmay@linux.ibm.com>
References: <20230116175757.71059-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lRLmnNWwInjqDJzxAstlPI7ZSTH0D4Im
X-Proofpoint-ORIG-GUID: urfpA23Y-hI49zhaJ-07dB5KCSoT4r4o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_15,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 clxscore=1015 mlxscore=0 adultscore=0 phishscore=0 mlxlogscore=799
 priorityscore=1501 bulkscore=0 malwarescore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160131
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

`lib` seems to be unused therefore let's remove it.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 s390x/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index 032524373593..31f6db11213d 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -63,7 +63,7 @@ test_cases: $(tests)
 test_cases_binary: $(tests_binary)
 test_cases_pv: $(tests_pv_binary)
 
-INCLUDE_PATHS = $(SRCDIR)/lib $(SRCDIR)/lib/s390x lib
+INCLUDE_PATHS = $(SRCDIR)/lib $(SRCDIR)/lib/s390x
 CPPFLAGS = $(addprefix -I,$(INCLUDE_PATHS))
 
 CFLAGS += -std=gnu99
-- 
2.34.1

