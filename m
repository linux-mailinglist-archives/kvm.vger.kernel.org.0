Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 055F0FB056
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 13:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfKMMX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 07:23:27 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3858 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726543AbfKMMX1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 07:23:27 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xADCJJVh042875
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 07:23:26 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w8gk835tv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 07:23:25 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Wed, 13 Nov 2019 12:23:24 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 13 Nov 2019 12:23:21 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xADCMiR921561696
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 12:22:44 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B5574C04E;
        Wed, 13 Nov 2019 12:23:20 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 052144C059;
        Wed, 13 Nov 2019 12:23:20 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.55])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Nov 2019 12:23:19 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com
Subject: [PATCH v1 0/4] s390x: Testing the Subchannel I/O
Date:   Wed, 13 Nov 2019 13:23:15 +0100
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
x-cbid: 19111312-0028-0000-0000-000003B686E8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111312-0029-0000-0000-000024798E7E
Message-Id: <1573647799-30584-1-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-13_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=472 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911130116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Goal of the series is to have a framwork to test Channel-Subsystem I/O with
QEMU/KVM.

To be able to support interrupt for CSS I/O and for SCLP we need to modify
the interrupt framework to allow re-entrant interruptions.

Making the interrupt handler weak allows the test programm to define its own
interrupt handler. We need to do special work under interrupt like acknoledging
the interrupt.

Being working on PSW bits to allow I/O interrupt, we define all PSW bits in a
dedicated file.

The simple test tests the I/O reading by the SUB Channel. It needs QEMU to
be patched to have the pong device defined.
The pong device answers, for now, with a Hello World to the read request.


Pierre Morel (4):
  s390x: saving regs for interrupts
  s390x: Define the PSW bits
  s390x:irq: make IRQ handler weak
  s390x: Testing the Subchannel I/O read

 lib/s390x/asm/arch_bits.h |  32 ++++++
 lib/s390x/asm/arch_def.h  |   6 +-
 lib/s390x/asm/interrupt.h |  15 ++-
 lib/s390x/css.h           | 244 ++++++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/css_dump.c      | 141 +++++++++++++++++++++++++++
 lib/s390x/interrupt.c     |  16 +--
 s390x/Makefile            |   2 +
 s390x/css.c               | 222 +++++++++++++++++++++++++++++++++++++++++
 s390x/cstart64.S          |  30 ++++--
 s390x/unittests.cfg       |   4 +
 10 files changed, 686 insertions(+), 26 deletions(-)
 create mode 100644 lib/s390x/asm/arch_bits.h
 create mode 100644 lib/s390x/css.h
 create mode 100644 lib/s390x/css_dump.c
 create mode 100644 s390x/css.c

-- 
2.7.4

