Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45BF21F9375
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 11:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbgFOJcJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 05:32:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60442 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728411AbgFOJcJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Jun 2020 05:32:09 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05F84I4i005997;
        Mon, 15 Jun 2020 05:32:07 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31p54p2gu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 05:32:07 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05F84sQF008047;
        Mon, 15 Jun 2020 05:32:07 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31p54p2gsu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 05:32:07 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05F9JxEF023011;
        Mon, 15 Jun 2020 09:32:05 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 31mpe839ed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 09:32:05 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05F9W37m2949598
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jun 2020 09:32:03 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 161A252052;
        Mon, 15 Jun 2020 09:32:03 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.1.141])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id ABB1252057;
        Mon, 15 Jun 2020 09:32:02 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v9 00/12] s390x: Testing the Channel Subsystem I/O
Date:   Mon, 15 Jun 2020 11:31:49 +0200
Message-Id: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-15_01:2020-06-15,2020-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 clxscore=1015 cotscore=-2147483648 mlxscore=0
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 suspectscore=1 bulkscore=0 spamscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006150066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi All,

Goal of the series is to have a framework to test Channel-Subsystem I/O with
QEMU/KVM.
  
To be able to support interrupt for CSS I/O and for SCLP we need to modify
the interrupt framework to allow re-entrant interruptions.
  
We add a registration for IRQ callbacks to the test program to define its own
interrupt handler. We need to do special work under interrupt like acknowledging
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
        effectively enabled, retrying a predefined count on failure
	to enable the channel
        Checks MSCH       
 
- Sense:
        If the channel is enabled this test sends a SENSE_ID command
        to the reference channel, analyzing the answer and expecting
        the Control unit type being 0x3832, a.k.a. virtio-net-ccw.
        Checks SSCH(READ) and IO-IRQ

Note:
- The following patches are general usage and may be pulled first:
  s390x: Use PSW bits definitions in cstart
  s390x: Move control register bit definitions and add AFP to them
  s390x: saving regs for interrupts
  s390x: interrupt registration
  s390x: export the clock get_clock_ms() utility
  s390x: clock and delays caluculations
  s390x: define function to wait for interrupt
  s390x: retrieve decimal and hexadecimal kernel parameters

- These 4 patches are really I/O oriented:
  s390x: Library resources for CSS tests
  s390x: css: stsch, enumeration test
  s390x: css: msch, enable test
  s390x: css: ssch/tsch with sense and interrupt

Regards,
Pierre

Pierre Morel (12):
  s390x: Use PSW bits definitions in cstart
  s390x: Move control register bit definitions and add AFP to them
  s390x: saving regs for interrupts
  s390x: interrupt registration
  s390x: export the clock get_clock_ms() utility
  s390x: clock and delays caluculations
  s390x: define function to wait for interrupt
  s390x: retrieve decimal and hexadecimal kernel parameters
  s390x: Library resources for CSS tests
  s390x: css: stsch, enumeration test
  s390x: css: msch, enable test
  s390x: css: ssch/tsch with sense and interrupt

 lib/s390x/asm/arch_def.h |  32 ++++-
 lib/s390x/asm/time.h     |  51 ++++++++
 lib/s390x/css.h          | 276 +++++++++++++++++++++++++++++++++++++++
 lib/s390x/css_dump.c     | 153 ++++++++++++++++++++++
 lib/s390x/css_lib.c      | 176 +++++++++++++++++++++++++
 lib/s390x/interrupt.c    |  23 +++-
 lib/s390x/interrupt.h    |   8 ++
 lib/s390x/kernel-args.c  |  60 +++++++++
 lib/s390x/kernel-args.h  |  18 +++
 s390x/Makefile           |   4 +
 s390x/css.c              | 208 +++++++++++++++++++++++++++++
 s390x/cstart64.S         |  58 ++++++--
 s390x/intercept.c        |  11 +-
 s390x/unittests.cfg      |   4 +
 14 files changed, 1056 insertions(+), 26 deletions(-)
 create mode 100644 lib/s390x/asm/time.h
 create mode 100644 lib/s390x/css.h
 create mode 100644 lib/s390x/css_dump.c
 create mode 100644 lib/s390x/css_lib.c
 create mode 100644 lib/s390x/interrupt.h
 create mode 100644 lib/s390x/kernel-args.c
 create mode 100644 lib/s390x/kernel-args.h
 create mode 100644 s390x/css.c

-- 
2.25.1

Changelog:

from v8 to v9:

- rename PSW_EXCEPTION_MASK to PSW_MASK_ON_EXCEPTION
  (Thomas)

- changed false max microseconds in delay calculation
  (Thomas)

- fix bug in decimal parameter calculation
  (Thomas)

- fix bug in msch inline assembly
  (Thomas)

- add report_abort() for unprobable result of tsch
  in I/O IRQ
  (Thomas)

- use of existing lctlg() wrapper instead of new function
  (Thomas)

from v7 to v8

* Suppress ccw-pong specific remote device
  (Thomas, Janosch)

* use virtio-net-ccw as device instead of a specific
  device: no more need for QEMU patch
  (Connie)

* Add kernel parameter to access a different device.
  (Connie)

* Add tests on subschannel reading, length, garbage.
  (Connie)

* Several naming changes and reorganizations of definitions.
  (Connie)

* Take wrapping into account for delay calculation

* Align CCW1 on 8 bytes boundary

* Reorganize the first three patches
  (Janosch)

from v6 to v7

* s390x: saving regs for interrupts
- macro name modificatio for SAVE_REGS_STACK
  (David)
- saving the FPC
  (David)

* s390x: Use PSW bits definitions in cstart
- suppress definition for PSW_RESET_MASK
  use PSW_EXCEPTION_MASK | PSW_MASK_SHORT_PSW
  (David)

* s390x: Library resources for CSS tests
* s390x: css: stsch, enumeration test
  move library definitions from stsch patche
  to the Library patch
  add the library to the s390 Makefile here
  (Janosch)
  
* s390x: css: msch, enable test
  Add retries when enable fails
  (Connie)
  Re-introduce the patches for delay implementation
  to add a delay between retries

* s390x: define function to wait for interrupt
  Changed name from wfi to wait_for_interrupt
  (Janosch)

* s390x: css: ssch/tsch with sense and interrupt
  add a flag parameter to ssch and use it to add
  SLI (Suppress Length Indication) flag for SENSE_ID
  (Connie)


from v5 to v6
- Added comments for IRQ handling in
  s390x: saving regs for interrupts
  (Janosch) 

- fixed BUG on reset_psw, added PSW_MASK_PSW_SHORT
  and PSW_RESET_MASK

- fixed several lines over 80 chars

- fixed licenses, use GPL V2 (no more LGPL)

- replacing delay() with wfi() (Wait For Interrupt)
  during the css tests
  (suggested by Connie's comments)

- suppressing delay() induces suppressing the patch
  "s390x: export the clock get_clock_ms() utility"
  which is already reviewed but can be picked from
  the v5 series.

- changed the logic of the tests, the 4 css tests
  are always run one after the other so no need to 
  re-run enumeration and enabling at the begining
  of each tests, it has alredy been done.
  This makes code simpler.

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

