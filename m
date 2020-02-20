Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E664C165D1E
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 13:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgBTMAx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 07:00:53 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25817 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727962AbgBTMAx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 07:00:53 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01KBxiOG103106
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 07:00:51 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y93kfxnx7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 07:00:51 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 20 Feb 2020 12:00:48 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 20 Feb 2020 12:00:45 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01KC0iox23068750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 12:00:44 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3601CAE051;
        Thu, 20 Feb 2020 12:00:44 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08CA1AE055;
        Thu, 20 Feb 2020 12:00:44 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.41])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Feb 2020 12:00:43 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v5 00/10] s390x: Testing the Channel Subsystem I/O
Date:   Thu, 20 Feb 2020 13:00:33 +0100
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
x-cbid: 20022012-0016-0000-0000-000002E893E2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022012-0017-0000-0000-0000334BAFF8
Message-Id: <1582200043-21760-1-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-20_03:2020-02-19,2020-02-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 impostorscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=1 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200091
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Goal of the series is to have a framwork to test Channel-Subsystem I/O with
QEMU/KVM.
  
To be able to support interrupt for CSS I/O and for SCLP we need to modify
the interrupt framework to allow re-entrant interruptions.
  
We add a registration for IRQ callbacks to the test programm to define its own
interrupt handler. We need to do special work under interrupt like acknoledging
the interrupt.
  
Being working on PSW bits to allow I/O interrupt, we define new PSW bits
in arch_def.h and use __ASSEMBLER__ define to be able to include this header
in an assembler source file.

This series presents four major tests:
- Enumeration:
        The CSS is enumerated using the STSCH instruction recursively on all
        potentially existing channels.
        Keeping the first channel found as a reference for future use.
        Checks STSCH
 
- Enable:
        If the enumeration succeeded the tests enables the reference
        channel with MSCH and verifies with STSCH that the channel is
        effectively enabled  
        Checks MSCH       
 
- Sense:
        If the channel is enabled this test sends a SENSE_ID command
        to the reference channel, analysing the answer and expecting
        the Control unit type being 0xc0ca
        Checks SSCH(READ) and IO-IRQ

- ping-pong:
        If the reference channel leads to the PONG device (0xc0ca),
        the test exchanges a string containing a 9 digit number with
        the PONG device and expecting this number to be incremented
        by the PONG device.
        Checks SSCH(WRITE)


Pierre Morel (10):
  s390x: saving regs for interrupts
  s390x: Use PSW bits definitions in cstart
  s390x: cr0: adding AFP-register control bit
  s390x: interrupt registration
  s390x: export the clock get_clock_ms() utility
  s390x: Library resources for CSS tests
  s390x: css: stsch, enumeration test
  s390x: css: msch, enable test
  s390x: css: ssch/tsch with sense and interrupt
  s390x: css: ping pong

 lib/s390x/asm/arch_def.h |  19 ++-
 lib/s390x/asm/time.h     |  36 +++++
 lib/s390x/css.h          | 277 +++++++++++++++++++++++++++++++
 lib/s390x/css_dump.c     | 157 ++++++++++++++++++
 lib/s390x/css_lib.c      |  55 +++++++
 lib/s390x/interrupt.c    |  22 ++-
 lib/s390x/interrupt.h    |   7 +
 s390x/Makefile           |   3 +
 s390x/css.c              | 341 +++++++++++++++++++++++++++++++++++++++
 s390x/cstart64.S         |  40 +++--
 s390x/intercept.c        |  11 +-
 s390x/unittests.cfg      |   4 +
 12 files changed, 946 insertions(+), 26 deletions(-)
 create mode 100644 lib/s390x/asm/time.h
 create mode 100644 lib/s390x/css.h
 create mode 100644 lib/s390x/css_dump.c
 create mode 100644 lib/s390x/css_lib.c
 create mode 100644 lib/s390x/interrupt.h
 create mode 100644 s390x/css.c

-- 
2.17.0

Changelog:
from v4 to v5
- add a patch to explicitely define the initial_cr0
  value
  (Janosch)
- add RB from Janosh on interrupt registration
- several formating, typo correction and removing
  unnecessary initialization in "linrary resources..."
  (Janosch)
- several formating and typo corrections on
  "stsch enumeration test"
  (Connie)
- reworking the msch test
  (Connie)
- reworking of ssch test, pack the sense-id structure
  (Connie)

from v3 to v4
- add RB from David and Thomas for patchs 
  (3) irq registration and (4) clock export
- rework the PSW bit definitions
  (Thomas)
- Suppress undef DEBUG from css_dump
  (Thomas)
- rework report() functions using new scheme
  (Thomas)
- suppress un-necessary report_info()
- more spelling corrections
- add a loop around enable bit testing
  (Connie)
- rework IRQ testing
  (Connie)
- Test data addresses to be under 2G
  (Connie)

from v2 to v3:
- Rework spelling
  (Connie)
- More descriptions
  (Connie)
- use __ASSEMBLER__ preprocessing to keep
  bits definitions and C structures in the same file
  (David)
- rename the new file clock.h as time.h
  (Janosch, David?)
- use registration for the IO interruption
  (David, Thomas)
- test the SCHIB to verify it has really be modified
  (Connie)
- Lot of simplifications in the tests
  (Connie)

from v1 to v2:
- saving floating point registers (David, Janosh)
- suppress unused PSW bits defintions (Janosh)
- added Thomas reviewed-by
- style and comments modifications (Connie, Janosh)
- moved get_clock_ms() into headers and use it (Thomas)
- separate header and library utility from tests
- Suppress traces, separate tests, make better usage of reports

