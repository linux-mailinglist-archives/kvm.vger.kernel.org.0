Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66E105FE971
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 09:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiJNHXV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 03:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiJNHXU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 03:23:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3335F196B61
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 00:23:19 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29E63ALL008155
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 07:23:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=C1vPgcSV5N9iPf70021f88PqhxcwyPmTG0qLa3j6wT8=;
 b=MC+iVU/tmEDoYBXSHh7JCTFfuTPmOJZHvetsNVamrgQamIAyUT37uz0CzFiVSN82ZWr5
 0gtFYUvli+lO2qck5mwipaAc/TsNWvOWtSEuTUM/qbkTYi38iPgTLx7eHAjLnEjEl8Yi
 v1oT7J5S+yhUJr05BSP65DnJ50oaqAB3hP+qylmqmKOXC3SuJWV2MMIVqsNTQ8Wh94w1
 cPSGX3pxd+BrlG+srxCNHn/eFjyhkRk3vjqFSHaNGx9cskMW+rgXgMm78jDYkIKZdQ0y
 QmrIRgbv9XWZTEYHMoRxRCxfYSh4vPYRmVj2yIVyZ9jZ2Fb/7s6OHS8gcxfMJuBXARyF nA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k6j8cdvrn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 07:23:18 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29E6qOGA031929
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 07:23:18 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k6j8cdvqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Oct 2022 07:23:18 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29E7L1KM016207;
        Fri, 14 Oct 2022 07:23:15 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3k30u9ekdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Oct 2022 07:23:15 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29E7NCcd60948866
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Oct 2022 07:23:12 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 772B5A405C;
        Fri, 14 Oct 2022 07:23:12 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40CCDA4054;
        Fri, 14 Oct 2022 07:23:12 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Oct 2022 07:23:12 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v6 0/1] s390x: Add exit time test
Date:   Fri, 14 Oct 2022 09:23:11 +0200
Message-Id: <20221014072312.198606-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Cv74SBR7PJyIreKDGl93ywKbL3fSKXFb
X-Proofpoint-GUID: gGiwwftHSvJUQhrWUZiGD51wXY22NWQH
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-14_03,2022-10-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 mlxscore=0 adultscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 suspectscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=733
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210140041
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v5->v6:
---
* multiply first, then divide when normalizing (thanks Claudio)
* print fractions of us (thanks Claudio)
* remove non-normalized output (thanks Claudio)
* fence dag9c since not supported under TCG

v4->v5:
---
* print normalized runtime to be able to compare runtime of
  instructions in a single run (thanks Claudio)

v3->v4:
---
* remove merge conflict markers (thanks Christian)

v2->v3:
---
* print average (thanks Claudio)
* have asm constraints look the same everywhere (thanks Claudio)
* rebase patchset on top of my migration sck patches[1] to make use of the
  time.h improvements

v1->v2:
---
* add missing cc clobber, fix constraints for get_clock_us() (thanks
  Thomas)
* avoid array and use pointer to const char* (thanks Thomas)
* add comment why testing nop makes sense (thanks Thomas)
* rework constraints and clobbers (thanks Thomas)

Sometimes, it is useful to measure the exit time of certain instructions
to e.g. identify performance regressions in instructions emulated by the
hypervisor.

This series adds a test which executes some instructions and measures
their execution time. Since their execution time depends a lot on the
environment at hand, all tests are reported as PASS currently.

The point of this series is not so much the instructions which have been
chosen here (but your ideas are welcome), but rather the general
question whether it makes sense to have a test like this in
kvm-unit-tests.

This series is based on my migration sck patches[1] to make use of the
time.h improvements there.

[1] https://lore.kernel.org/all/20221011170024.972135-1-nrb@linux.ibm.com/

Nico Boehr (1):
  s390x: add exittime tests

 s390x/Makefile      |   1 +
 s390x/exittime.c    | 296 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   4 +
 3 files changed, 301 insertions(+)
 create mode 100644 s390x/exittime.c

-- 
2.36.1

