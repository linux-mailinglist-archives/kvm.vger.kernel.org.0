Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D80DCA9FFB
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 12:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732848AbfIEKkH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 06:40:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52190 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726162AbfIEKkH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Sep 2019 06:40:07 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x85AcvF9075232
        for <kvm@vger.kernel.org>; Thu, 5 Sep 2019 06:40:06 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2utwrv87pc-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2019 06:40:06 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 5 Sep 2019 11:40:04 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 5 Sep 2019 11:40:02 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x85AdbAb41746696
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Sep 2019 10:39:37 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 476CD52050;
        Thu,  5 Sep 2019 10:40:01 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 86CE95204E;
        Thu,  5 Sep 2019 10:40:00 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/6] s390x: Add multiboot and smp
Date:   Thu,  5 Sep 2019 12:39:45 +0200
X-Mailer: git-send-email 2.17.0
X-TM-AS-GCONF: 00
x-cbid: 19090510-4275-0000-0000-0000036176B5
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19090510-4276-0000-0000-00003873BEA8
Message-Id: <20190905103951.36522-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-05_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=674 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909050106
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cross testing emulated instructions has in the past brought up some
issues on all available IBM Z hypervisors. So let's upstream the last
part of multiboot: sclp interrupts and line mode console.

SMP tests are a great way to excercise external interruptions, cpu
resets and sigp. The smp library is always initialized and provides
very rudimentary CPU management for now.

v2:
* Fixed cr0 masks
* Replaced gotos with loops
* Addressed other review comments

Janosch Frank (6):
  s390x: Use interrupts in SCLP and add locking
  s390x: Add linemode console
  s390x: Add linemode buffer to fix newline on every print
  s390x: Add initial smp code
  s390x: Prepare for external calls
  s390x: SMP test

 lib/s390x/asm/arch_def.h  |  13 ++
 lib/s390x/asm/interrupt.h |   5 +
 lib/s390x/asm/sigp.h      |  28 +++-
 lib/s390x/interrupt.c     |  28 +++-
 lib/s390x/io.c            |   5 +-
 lib/s390x/sclp-console.c  | 243 ++++++++++++++++++++++++++++++---
 lib/s390x/sclp.c          |  55 +++++++-
 lib/s390x/sclp.h          |  59 +++++++-
 lib/s390x/smp.c           | 276 ++++++++++++++++++++++++++++++++++++++
 lib/s390x/smp.h           |  51 +++++++
 s390x/Makefile            |   2 +
 s390x/cstart64.S          |   7 +
 s390x/smp.c               | 242 +++++++++++++++++++++++++++++++++
 s390x/unittests.cfg       |   4 +
 14 files changed, 991 insertions(+), 27 deletions(-)
 create mode 100644 lib/s390x/smp.c
 create mode 100644 lib/s390x/smp.h
 create mode 100644 s390x/smp.c

-- 
2.17.0

