Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 313E95FC50E
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 14:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiJLMLk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 08:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiJLMLg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 08:11:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33ED18053F
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 05:11:35 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29CBUgH4003367
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 12:11:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=on2d2JVi31Ye+h/cWxTyNctxp0qYO76YyPbmOJ6vsqE=;
 b=Y+MWYiR0ZNqMjo/uyNnIYrel2+3632Hbu4ZNzyBxLHz/Y7sY3Y2sOSr3K99HzjaHycF+
 SHKL1KgbsWtZo1IjjidEWt2675rL3L4LY0JCzTjKIN/SBNrldV5FnRqCdHZF6Nz3PDnu
 yhTSe2kJAa880FyRfb3cFWmdCgrZGQZtH6Vby9i0Y0uASVvwDvDG+pslTm0FAo/k6fgW
 wP3DyjRJ1kEwMkA33BetikGyWzdwVRXTP2Trmz2aN4JyJj55lJ8LMBJ38/xD6ff6KY/0
 6t2Vhg3S3KVP+9x8zlPQZ3F6MdpXSqwnMQnoLUhDIlL70Yg9lYdY6VTLhT6qZlhBNBR9 Dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5vs814qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 12:11:34 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29CBUuEJ004113
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 12:11:34 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5vs814pw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 12:11:34 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29CC6TmF013128;
        Wed, 12 Oct 2022 12:11:32 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3k30fjdyt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 12:11:31 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29CCBSUq66978246
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 12:11:28 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88C52AE04D;
        Wed, 12 Oct 2022 12:11:28 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52EFBAE045;
        Wed, 12 Oct 2022 12:11:28 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Oct 2022 12:11:28 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 0/1] s390x: Add exit time test
Date:   Wed, 12 Oct 2022 14:11:27 +0200
Message-Id: <20221012121128.1179252-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: esSyGXZMP_dtQzDd-ilaUr44uxqswreq
X-Proofpoint-GUID: dBDKKo96BddA75hyzn-xXxa0QKDr1-CO
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-12_06,2022-10-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=711 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210120079
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
 s390x/exittime.c    | 253 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   5 +
 3 files changed, 259 insertions(+)
 create mode 100644 s390x/exittime.c

-- 
2.36.1

