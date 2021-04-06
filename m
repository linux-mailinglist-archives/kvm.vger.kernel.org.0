Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15534354E03
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 09:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235458AbhDFHlJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 03:41:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21052 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232661AbhDFHlH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 03:41:07 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1367YBFb028858
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=ORSeLVk4Dk5V5xnEUjoRNmgfUYEaJiDykhMSCJhQPOw=;
 b=Eaei06gi3mrZv5spDsMhXQA6u9ZVTgNBqzun8WAt520xAitFGY2YDWTmoKkkGG6IXW9R
 M1P5UsyyFikpN348Z3meFFVKdPyZRUvkHA88HYap2aZ9V7Y6OtdG+bVJKWRMkfxUcNPq
 1IUE7TtHGc9i0/kybT+fqTac4+4iR5esW9Nipn8pT4+CCNz/78CBlwf9H4gwaUX+Fri5
 9TZ3RAd8hTJnI9w1Jxqrh4YHachLDEbwx620P86fLF4QQXJoqYUdu0fnSWvGFB5kgR8d
 fNubrSh3SYSsR3Iia5RvSo8T2ISrO8OYFoCgWax96m+rRQCepNMPxZF1nTPOazxBVEIb gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37q5tyk6hw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 03:41:00 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1367aW3A035682
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:40:59 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37q5tyk6ha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 03:40:59 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1367Wktx015585;
        Tue, 6 Apr 2021 07:40:57 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 37q2n2sx7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 07:40:57 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1367etRP30212482
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 07:40:55 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F20334C040;
        Tue,  6 Apr 2021 07:40:54 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4F904C046;
        Tue,  6 Apr 2021 07:40:54 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.42.152])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 07:40:54 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 00/16] s390x: Testing SSCH, CSCH and HSCH for errors
Date:   Tue,  6 Apr 2021 09:40:37 +0200
Message-Id: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: n0fYmORlGM2hDnBA3-YBgyuatmzCX7KC
X-Proofpoint-GUID: UUKfQ57iZ0YTNjS7yMq4bzasOQNmyVHv
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_01:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 impostorscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104030000
 definitions=main-2104060050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The goal of this series is to test some of the I/O instructions,
SSCH, CSCH and HSCH for errors like invalid parameters, addressing,
timing etc.
We can not test the sending of an instruction before the last instruction
has been proceeded by QEMU due to the QEMU serialization but we can 
check the behavior of an instruction if it is started before the status
of the last instruction is read.

To do this we first separate the waiting for the interruption and the
checking of the IRB and enable the subchannel without an I/O ISC to
avoid interruptions at this subchannel and second, we add an argument
to the routine in charge to check the IRB representing the expected
SCSW control field of the IRB.

We also need several other enhancements to the testing environment:

- definitions for the SCSW control bits
- a new function to disable a subchannel
- a macro to simplify skiping tests when no device is present
  (I know the warning about return in macro, can we accept it?)

In the new tests we assume that all the test preparation is working and
use asserts for all function for which we do not expect a failure.

regards,
Pierre

PS: Sorry, I needed to modify patches 4 and 5 for which I already had RB or AB.
    I removed them even I hope you will agree with my modifications.


Pierre Morel (16):
  s390x: lib: css: disabling a subchannel
  s390x: lib: css: SCSW bit definitions
  s390x: css: simplify skipping tests on no device
  s390x: lib: css: separate wait for IRQ and check I/O completion
  s390x: lib: css: add SCSW ctrl expectations to check I/O completion
  s390x: lib: css: checking I/O errors
  s390x: css: testing ssch errors
  s390x: css: ssch check for cpa zero
  s390x: css: ssch with mis aligned ORB
  s390x: css: ssch checking addressing errors
  s390x: css: No support for MIDAW
  s390x: css: Check ORB reserved bits
  s390x: css: checking for CSS extensions
  s390x: css: issuing SSCH when the channel is status pending
  s390x: css: testing halt subchannel
  s390x: css: testing clear subchannel

 lib/s390x/css.h     |  42 ++++-
 lib/s390x/css_lib.c | 138 ++++++++++++--
 s390x/css.c         | 425 +++++++++++++++++++++++++++++++++++++++++---
 s390x/unittests.cfg |   8 +-
 4 files changed, 565 insertions(+), 48 deletions(-)

-- 
2.17.1

log:

from v2:

- modified the patch 3 simplifying the check for no device
  to move the check once for all in the main
  (Thomas)

- modified the patch 4 separate wait for IRQ..
  to move the check for IRQ parameters inside the IRQ routine
  (Pierre)

- modified the patch 5 checking for expectations on I/O
  to return with success if the expectation is matched without
  further checks.
  (Pierre)

- rewords patch 5 commet and commit message
  (Connie)

- reworked patches on SSCH addressing memory
  (Claudio)


from v1:

- rework the buggy interrupt handling
  (Connie)

- identation and comments changes in "disabling subchannel"
  (Janosch)

- Bit definition naming
  (Connie)

- use get_ram_size() to get the maximal address
  (Janosch)

- better comments for SSCH (hopefully)
  (Pierre)
