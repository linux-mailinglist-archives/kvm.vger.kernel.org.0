Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEBD86D03B2
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 13:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbjC3LpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 07:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbjC3Lo6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 07:44:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2048030D2;
        Thu, 30 Mar 2023 04:44:35 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32UB87ZO001662;
        Thu, 30 Mar 2023 11:43:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=rVhbR7MKEeHG77z6o6s8YFBemK5FgKPjMtzctant/so=;
 b=BWLlSKIqV2TccbcZW4HcJK77e2zxIts8z0unLIdNtUnNqaJdh0xX/qC0Zb3B1XvUCIVl
 hKlR+h1o/R0dovK4p0CXJSSsQhc0el48+o0e6V4jE0mEP//gvSQZuna/8i6h7YWnDGbw
 uiWsd9ao53914w5i6FazfxiXF9KcboEowKbsl5JBd4//UJ96oO268o4L0Aw8zYW5MU++
 gwBqE8lJn2LwCPFpS3bpd4neNxv1JpkjGDvu9vDzLzTLiyYaBaLgkVveEPPdhb6AMSzr
 E3CN4GbvOkSgAYeOIrpfjd8WVgdvStqIsPpr1sRjnAWyj3AKzfNQOBnN1Wu3MNlSNgIN dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmp7jwuet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 11:43:45 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32UB99xt005027;
        Thu, 30 Mar 2023 11:43:45 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmp7jwue6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 11:43:45 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32THp9c0032379;
        Thu, 30 Mar 2023 11:43:42 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3phrk6nt7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 11:43:42 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32UBhdRa21234180
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Mar 2023 11:43:39 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E45620049;
        Thu, 30 Mar 2023 11:43:39 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FF2A20043;
        Thu, 30 Mar 2023 11:43:38 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 30 Mar 2023 11:43:38 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 0/5] s390x: Add base AP support
Date:   Thu, 30 Mar 2023 11:42:39 +0000
Message-Id: <20230330114244.35559-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7zTj1WqTvewtpnjHtm60aRtDox6mwNd3
X-Proofpoint-GUID: qRCbEG9FKXUOyUCaKDmnuKRweH6d0xoN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_07,2023-03-30_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303300095
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As KVM supports passing Adjunct Processor (AP) crypto devices to
guests, we should make sure that the interface works as expected.

Three instructions provide the interface to the AP devices:
 - nqap: Enqueues a crypto request
 - dqap: Dequeues a crypto request
 - pqap: Provides information and processes support functions

nqap & dqap work on crypto requests for which we currently don't want
to add tests due to their complexity.

Which leaves us with pqap which is partly emulated for a guest 2 and
hence is a prime target for testing.

Janosch Frank (5):
  lib: s390x: Add ap library
  s390x: Add guest 2 AP test
  lib: s390x: ap: Add ap_setup
  s390x: ap: Add pqap aqic tests
  s390x: ap: Add reset tests

 lib/s390x/ap.c      | 246 ++++++++++++++++++++++++++
 lib/s390x/ap.h      | 104 +++++++++++
 s390x/Makefile      |   2 +
 s390x/ap.c          | 421 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   4 +
 5 files changed, 777 insertions(+)
 create mode 100644 lib/s390x/ap.c
 create mode 100644 lib/s390x/ap.h
 create mode 100644 s390x/ap.c

-- 
2.34.1

