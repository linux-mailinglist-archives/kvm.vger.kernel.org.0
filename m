Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF9C10C8CC
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 13:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfK1MqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 07:46:16 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33154 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726227AbfK1MqQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Nov 2019 07:46:16 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xASCgxqV038937
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2019 07:46:15 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2whcxrujxh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2019 07:46:14 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 28 Nov 2019 12:46:12 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 28 Nov 2019 12:46:10 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xASCk9hv62259226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Nov 2019 12:46:09 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9023DAE045;
        Thu, 28 Nov 2019 12:46:09 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DB8AAE056;
        Thu, 28 Nov 2019 12:46:09 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.185.119])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Nov 2019 12:46:09 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/9] s390x: Testing the Channel Subsystem I/O
Date:   Thu, 28 Nov 2019 13:45:58 +0100
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
x-cbid: 19112812-0028-0000-0000-000003C11C66
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112812-0029-0000-0000-000024842715
Message-Id: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-28_03:2019-11-28,2019-11-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 suspectscore=1 spamscore=0 phishscore=0 mlxlogscore=711 bulkscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911280112
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


Pierre Morel (9):
  s390x: saving regs for interrupts
  s390x: Define the PSW bits
  s390x: irq: make IRQ handler weak
  s390x: export the clock get_clock_ms() utility
  s390x: Library resources for CSS tests
  s390x: css: stsch, enumeration test
  s390x: css: msch, enable test
  s390x: css: ssch/tsch with sense and interrupt
  s390x: css: ping pong

 lib/s390x/asm/arch_bits.h |  20 +++
 lib/s390x/asm/arch_def.h  |   6 +-
 lib/s390x/asm/clock.h     |  25 ++++
 lib/s390x/css.h           | 282 ++++++++++++++++++++++++++++++++++++
 lib/s390x/css_dump.c      | 147 +++++++++++++++++++
 lib/s390x/interrupt.c     |   2 +-
 s390x/Makefile            |   4 +-
 s390x/css.c               | 294 ++++++++++++++++++++++++++++++++++++++
 s390x/cstart64.S          |  38 +++--
 s390x/intercept.c         |  11 +-
 s390x/unittests.cfg       |   4 +
 11 files changed, 809 insertions(+), 24 deletions(-)
 create mode 100644 lib/s390x/asm/arch_bits.h
 create mode 100644 lib/s390x/asm/clock.h
 create mode 100644 lib/s390x/css.h
 create mode 100644 lib/s390x/css_dump.c
 create mode 100644 s390x/css.c

-- 
2.17.0

Changelog:
- saving floating point registers (David, Janosh)
- suppress unused PSW bits defintions (Janosh)
- added Thomas reviewed-by
- style and comments modifications (Connie, Janosh)
- moved get_clock_ms() into headers and use it (Thomas)
- separate header and library utility from tests
- Suppress traces, separate tests, make better usage of reports

