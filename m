Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8CB52F3AB
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 21:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353183AbiETTJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 15:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236050AbiETTI6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 15:08:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CC5197F62;
        Fri, 20 May 2022 12:08:58 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KHCV2Z032650;
        Fri, 20 May 2022 19:08:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=vG9DebvDL9vCL5v7NuiG+lQYYq9RRXP6CckG+TBoBSk=;
 b=FsqLQQXGJsxwiEULGtKmTzh/zwhffLK1wGy36WCKJo8VU7QnbkJtAU8QDd558ZWdyFdd
 M36llHrE6gne8UvcjjXOpnvjApBZ8Qb2Xis5bF1w2SNPnnG6UkCRUeUT1O05swvT1RB5
 yxuee+VYSnBJxQm8UxzyBVtpBJB0M8Hvmb8CwTI3bIfOjzBh0W7A51gCBGv1FvOkPBeB
 4yDon/TXG3afJggAxi7L2c/YwBD/7EHQuq+Gja1Q5NT+yKq/Wc4bD4AblL3GpETRlPt7
 IpRgumtgSTd4dO77yHUSc1+CKsHdlN7OnH+uyEF8o3fnW6hFdw9vnI/dssDaQeDL/h7B FQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g6f661wvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 19:08:57 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24KJ4R7J019026;
        Fri, 20 May 2022 19:08:57 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g6f661wus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 19:08:57 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24KIr3YD010520;
        Fri, 20 May 2022 19:08:55 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3g2428r3x8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 19:08:55 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24KJ8pmk34865442
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 19:08:52 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6247AE053;
        Fri, 20 May 2022 19:08:51 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C934AE04D;
        Fri, 20 May 2022 19:08:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 May 2022 19:08:51 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 0/3] s390x: Rework TEID decoding and usage
Date:   Fri, 20 May 2022 21:08:47 +0200
Message-Id: <20220520190850.3445768-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qKeQuGFgQcU5xGCzyd9l_3sNX2qMP1gM
X-Proofpoint-GUID: RyrC3vfg218CDOkXBWe5HfuYqdGCDgXa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_06,2022-05-20_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 mlxscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=891
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205200119
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The translation-exception identification (TEID) contains information to
identify the cause of certain program exceptions, including translation
exceptions occurring during dynamic address translation, as well as
protection exceptions.
The meaning of fields in the TEID is complex, depending on the exception
occurring and various potentially installed facilities.

Add function to query which suppression-on-protection facility is
installed.
Rework the type describing the TEID, in order to ease decoding.
Change the existing code interpreting the TEID and extend it to take the
installed suppression-on-protection facility into account.

Also fix the sclp bit order.
This series is based on  v2 of series s390x: Avoid gcc 12 warnings .
The sclp fix is taken from v2 More skey instr. emulation test,
and could be picked independently from the rest of the series.

Janis Schoetterl-Glausch (3):
  s390x: Fix sclp facility bit numbers
  s390x: lib: SOP facility query function
  s390x: Rework TEID decoding and usage

 lib/s390x/asm/facility.h  | 21 +++++++++++
 lib/s390x/asm/interrupt.h | 66 ++++++++++++++++++++++++++--------
 lib/s390x/fault.h         | 30 ++++------------
 lib/s390x/sclp.h          | 18 ++++++----
 lib/s390x/fault.c         | 74 +++++++++++++++++++++++++++------------
 lib/s390x/interrupt.c     |  2 +-
 lib/s390x/sclp.c          |  2 ++
 s390x/edat.c              | 20 +++++++----
 8 files changed, 158 insertions(+), 75 deletions(-)


base-commit: 8719e8326101c1be8256617caf5835b57e819339
prerequisite-patch-id: aa682f50e4eba0e9b6cacd245d568f5bcca05e0f
prerequisite-patch-id: 55b90f625ada542f074cecb82cf63e2980205ce1
-- 
2.33.1

