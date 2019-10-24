Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1582EE30AA
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 13:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439089AbfJXLlw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 07:41:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18914 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436528AbfJXLlw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 07:41:52 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9OBbD4S174610
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:41:50 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vt294fejq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:41:50 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 24 Oct 2019 12:41:48 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 24 Oct 2019 12:41:45 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9OBfifA46858288
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 11:41:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB5B75204F;
        Thu, 24 Oct 2019 11:41:43 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5AAFE52054;
        Thu, 24 Oct 2019 11:41:42 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com, frankja@linux.ibm.com
Subject: [RFC 00/37] KVM: s390: Add support for protected VMs
Date:   Thu, 24 Oct 2019 07:40:22 -0400
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102411-0012-0000-0000-0000035CCA83
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102411-0013-0000-0000-00002197FCDF
Message-Id: <20191024114059.102802-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-24_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=418 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910240115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Protected VMs (PVM) are KVM VMs, where KVM can't access the VM's state
like guest memory and guest registers anymore. Instead the PVMs are
mostly managed by a new entity called Ultravisor (UV), which provides
an API, so KVM and the PV can request management actions.

PVMs are encrypted at rest and protected from hypervisor access while
running. They switch from a normal operation into protected mode, so
we can still use the standard boot process to load a encrypted blob
and then move it into protected mode.

Rebooting is only possible by passing through the unprotected/normal
mode and switching to protected again.

All patches are in the protvirt branch of the korg s390 kvm git.

Claudio will present the technology at his presentation at KVM Forum
2019.

Christian Borntraeger (1):
  KVM: s390: protvirt: Add SCLP handling

Claudio Imbrenda (2):
  KVM: s390: add missing include in gmap.h
  KVM: s390: protvirt: Implement on-demand pinning

Janosch Frank (27):
  DOCUMENTATION: protvirt: Protected virtual machine introduction
  KVM: s390: protvirt: Add initial lifecycle handling
  s390: KVM: Export PV handle to gmap
  s390: UV: Add import and export to UV library
  KVM: s390: protvirt: Secure memory is not mergeable
  DOCUMENTATION: protvirt: Interrupt injection
  KVM: s390: protvirt: Handle SE notification interceptions
  DOCUMENTATION: protvirt: Instruction emulation
  KVM: s390: protvirt: Handle spec exception loops
  KVM: s390: protvirt: Add new gprs location handling
  KVM: S390: protvirt: Introduce instruction data area bounce buffer
  KVM: S390: protvirt: Instruction emulation
  KVM: s390: protvirt: Make sure prefix is always protected
  KVM: s390: protvirt: Write sthyi data to instruction data area
  KVM: s390: protvirt: STSI handling
  KVM: s390: protvirt: Only sync fmt4 registers
  KVM: s390: protvirt: SIGP handling
  KVM: s390: protvirt: Add program exception injection
  KVM: s390: protvirt: Sync pv state
  DOCUMENTATION: protvirt: Diag 308 IPL
  KVM: s390: protvirt: Add diag 308 subcode 8 - 10 handling
  KVM: s390: protvirt: UV calls diag308 0, 1
  KVM: s390: Introduce VCPU reset IOCTL
  KVM: s390: protvirt: Report CPU state to Ultravisor
  KVM: s390: Fix cpu reset local IRQ clearing
  KVM: s390: protvirt: Support cmd 5 operation state
  KVM: s390: protvirt: Add UV debug trace

Michael Mueller (4):
  KVM: s390: protvirt: Add interruption injection controls
  KVM: s390: protvirt: Implement interruption injection
  KVM: s390: protvirt: Add machine-check interruption injection controls
  KVM: s390: protvirt: Implement machine-check interruption injection

Vasily Gorbik (3):
  s390/protvirt: introduce host side setup
  s390/protvirt: add ultravisor initialization
  s390: add (non)secure page access exceptions handlers

 .../admin-guide/kernel-parameters.txt         |   5 +
 Documentation/virtual/kvm/s390-pv-boot.txt    |  62 +++
 Documentation/virtual/kvm/s390-pv.txt         |  97 ++++
 arch/s390/boot/Makefile                       |   2 +-
 arch/s390/boot/uv.c                           |  20 +-
 arch/s390/include/asm/gmap.h                  |   4 +
 arch/s390/include/asm/kvm_host.h              | 103 +++-
 arch/s390/include/asm/uv.h                    | 255 +++++++++-
 arch/s390/include/uapi/asm/kvm.h              |   5 +-
 arch/s390/kernel/Makefile                     |   1 +
 arch/s390/kernel/pgm_check.S                  |   4 +-
 arch/s390/kernel/setup.c                      |   7 +-
 arch/s390/kernel/uv.c                         | 121 +++++
 arch/s390/kvm/Kconfig                         |   9 +
 arch/s390/kvm/Makefile                        |   2 +-
 arch/s390/kvm/diag.c                          |   7 +
 arch/s390/kvm/intercept.c                     |  91 +++-
 arch/s390/kvm/interrupt.c                     | 208 ++++++--
 arch/s390/kvm/kvm-s390.c                      | 476 +++++++++++++++---
 arch/s390/kvm/kvm-s390.h                      |  58 +++
 arch/s390/kvm/priv.c                          |   9 +-
 arch/s390/kvm/pv.c                            | 317 ++++++++++++
 arch/s390/mm/fault.c                          |  64 +++
 arch/s390/mm/gmap.c                           |  28 +-
 include/uapi/linux/kvm.h                      |  42 ++
 25 files changed, 1848 insertions(+), 149 deletions(-)
 create mode 100644 Documentation/virtual/kvm/s390-pv-boot.txt
 create mode 100644 Documentation/virtual/kvm/s390-pv.txt
 create mode 100644 arch/s390/kernel/uv.c
 create mode 100644 arch/s390/kvm/pv.c

-- 
2.20.1

