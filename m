Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06AFE348D32
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 10:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhCYJj4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 05:39:56 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44826 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229879AbhCYJjO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 05:39:14 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12P9YKw2168406
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 05:39:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=oh+j/snZUCtMHYB/MmSkEOoqubIfPJSMPMQd9uHSFxU=;
 b=T+WXsLIddG1SAinzupiQ5X1TsK48S8jz8s/vEFSFkfiador6ToiU479+YJkj2w6VAFOC
 ozFb/rs+EJ6w7srLA4LMyUVCHDhyyHQxI8POZGts6e06NPkcs/IOgWAAaYRa/G3jAn4y
 blwAAycxb1vXla/mMEDt5uMcDqAvOTaQcNVji/u3C5xjrHNTh/j9ujhiStnuwK4mN7Pe
 avRm7vUOT5k9YX5C02IWpoucAHStjUGh81Y5CFrqlg8XiqFTLEYViYQb9KFMYGZWoyK4
 PxoemezdyMqjnccLfe3A7OO2VjnyaoZw9qe0jigmOGm+He6aL8cEZ/G2Az3PLsvaNU/B Fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37ghp0s2c9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 05:39:13 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12P9YNEm168595
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 05:39:13 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37ghp0s2bk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 05:39:13 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12P9Slni020238;
        Thu, 25 Mar 2021 09:39:11 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 37df68csn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 09:39:11 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12P9d9W341025820
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 09:39:09 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E28D511C04C;
        Thu, 25 Mar 2021 09:39:08 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1E9D11C066;
        Thu, 25 Mar 2021 09:39:08 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.41.31])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Mar 2021 09:39:08 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 0/8] Testing SSCH, CSCH and HSCH for errors
Date:   Thu, 25 Mar 2021 10:38:59 +0100
Message-Id: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_02:2021-03-24,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 priorityscore=1501 malwarescore=0
 adultscore=0 impostorscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250072
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


Pierre Morel (8):
  s390x: lib: css: disabling a subchannel
  s390x: lib: css: SCSW bit definitions
  s390x: css: simplify skipping tests on no device
  s390x: lib: css: separate wait for IRQ and check I/O completion
  s390x: lib: css: add SCSW ctrl expectations to check I/O completion
  s390x: css: testing ssch error response
  s390x: css: testing halt subchannel
  s390x: css: testing clear subchannel

 lib/s390x/css.h     |  35 +++++-
 lib/s390x/css_lib.c | 104 ++++++++++++++++--
 s390x/css.c         | 251 ++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 363 insertions(+), 27 deletions(-)

-- 
2.17.1

log:

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
