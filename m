Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C000F15F968
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 23:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgBNW1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 17:27:13 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50894 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727620AbgBNW1M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 17:27:12 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EMNtuQ012917;
        Fri, 14 Feb 2020 17:27:07 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y4j8h1d8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 17:27:07 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01EMOrtM014415;
        Fri, 14 Feb 2020 17:27:06 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y4j8h1d85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 17:27:06 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01EMP5hN011565;
        Fri, 14 Feb 2020 22:27:05 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 2y5bc09wq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 22:27:05 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01EMR2X156951146
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 22:27:02 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E162136094;
        Fri, 14 Feb 2020 22:27:02 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FF33136091;
        Fri, 14 Feb 2020 22:27:01 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Feb 2020 22:27:01 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v2 00/42] KVM: s390: Add support for protected VMs
Date:   Fri, 14 Feb 2020 17:26:16 -0500
Message-Id: <20200214222658.12946-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_08:2020-02-14,2020-02-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 phishscore=0 impostorscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002140165
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mm people: This series contains a "pretty small" common code memory
management change that will allow paging, guest backing with files etc
almost just like normal VMs. It should be a no-op for all architectures
not opting in. And it should be usable for others that also try to get
notified on "the pages are in the process of being used for things like
I/O". At the end of the series are two sample patches as these hooks
seem to be useful for other with error handling/call information.  I
would suggest to keep the patch as is and add the additional things when
intel/arm know exactly what they need.

mm-related patches CCed on linux-mm, the complete list can be found on
the KVM and linux-s390 list. 

Andrew, any chance to either take " mm:gup/writeback: add callbacks for
inaccessible pages" or ACK so that I can take it?

Overview
--------
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

All patches are in the protvirtv4 branch of the korg s390 kvm git
https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git/log/?h=protvirtv4

Claudio presented the technology at his presentation at KVM Forum
2019.

https://static.sched.com/hosted_files/kvmforum2019/3b/ibm_protected_vms_s390x.pdf


v-> v2
- rebase on top of kvm/master
- pipe through rc and rrc. This might have created some churn here and
  there
- turn off sclp masking when rebooting into "unsecure"
- memory management simplification
- prefix page handling now via intercept 112
- io interrupt intervention request fix (do not use GISA)
- api.txt conversion to rst
- sample patches on top of mm/gup/writeback
- tons of review feedback
- kvm_uv debug feature fixes and unifications
- ultravisor information for /sys/firmware
- 

RFCv2 -> v1 (you can diff the protvirtv2 and the protvirtv3 branch)
- tons of review feedback integrated (see mail thread)
- memory management now complete and working
- Documentation patches merged
- interrupt patches merged
- CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST removed
- SIDA interface integrated into memop
- for merged patches I removed reviews that were not in all patches

Christian Borntraeger (5):
  KVM: s390/mm: Make pages accessible before destroying the guest
  KVM: s390: protvirt: Add SCLP interrupt handling
  KVM: s390: protvirt: do not inject interrupts after start
  s390/uv: Fix handling of length extensions (already in s390 tree)
  KVM: s390: rstify new ioctls in api.rst

Claudio Imbrenda (6):
  mm:gup/writeback: add callbacks for inaccessible pages
  s390/mm: provide memory management functions for protected KVM guests
  KVM: s390/mm: handle guest unpin events
  example for future extension: mm:gup/writeback: add callbacks for
    inaccessible pages: error cases
  example for future extension: mm:gup/writeback: add callbacks for
    inaccessible pages: source indication
  potential fixup for "s390/mm: provide memory management functions for
    protected KVM guests"

Janosch Frank (25):
  KVM: s390: protvirt: Add UV debug trace
  KVM: s390: add new variants of UV CALL
  KVM: s390: protvirt: Add initial vm and cpu lifecycle handling
  KVM: s390: protvirt: Add KVM api documentation
  KVM: s390: protvirt: Secure memory is not mergeable
  KVM: s390: protvirt: Handle SE notification interceptions
  KVM: s390: protvirt: Instruction emulation
  KVM: s390: protvirt: Handle spec exception loops
  KVM: s390: protvirt: Add new gprs location handling
  KVM: S390: protvirt: Introduce instruction data area bounce buffer
  KVM: s390: protvirt: handle secure guest prefix pages
  KVM: s390: protvirt: Write sthyi data to instruction data area
  KVM: s390: protvirt: STSI handling
  KVM: s390: protvirt: disallow one_reg
  KVM: s390: protvirt: Do only reset registers that are accessible
  KVM: s390: protvirt: Only sync fmt4 registers
  KVM: s390: protvirt: Add program exception injection
  KVM: s390: protvirt: Add diag 308 subcode 8 - 10 handling
  KVM: s390: protvirt: UV calls in support of diag308 0, 1
  KVM: s390: protvirt: Report CPU state to Ultravisor
  KVM: s390: protvirt: Support cmd 5 operation state
  KVM: s390: protvirt: Mask PSW interrupt bits for interception 104 and
    112
  KVM: s390: protvirt: Add UV cpu reset calls
  DOCUMENTATION: Protected virtual machine introduction and IPL
  s390: protvirt: Add sysfs firmware interface for Ultravisor
    information

Michael Mueller (2):
  KVM: s390: protvirt: Add interruption injection controls
  KVM: s390: protvirt: Implement interruption injection

Ulrich Weigand (1):
  KVM: s390/interrupt: do not pin adapter interrupt pages

Vasily Gorbik (3):
  s390/protvirt: introduce host side setup
  s390/protvirt: add ultravisor initialization
  s390/mm: add (non)secure page access exceptions handlers

 .../admin-guide/kernel-parameters.txt         |   5 +
 Documentation/virt/kvm/api.rst                | 108 +++-
 Documentation/virt/kvm/devices/s390_flic.rst  |  11 +-
 Documentation/virt/kvm/index.rst              |   2 +
 Documentation/virt/kvm/s390-pv-boot.rst       |  83 +++
 Documentation/virt/kvm/s390-pv.rst            | 116 +++++
 MAINTAINERS                                   |   1 +
 arch/s390/boot/Makefile                       |   2 +-
 arch/s390/boot/uv.c                           |  23 +-
 arch/s390/include/asm/gmap.h                  |   6 +
 arch/s390/include/asm/kvm_host.h              | 113 ++++-
 arch/s390/include/asm/mmu.h                   |   2 +
 arch/s390/include/asm/mmu_context.h           |   1 +
 arch/s390/include/asm/page.h                  |   5 +
 arch/s390/include/asm/pgtable.h               |  35 +-
 arch/s390/include/asm/uv.h                    | 251 ++++++++-
 arch/s390/kernel/Makefile                     |   1 +
 arch/s390/kernel/pgm_check.S                  |   4 +-
 arch/s390/kernel/setup.c                      |   9 +-
 arch/s390/kernel/uv.c                         | 412 +++++++++++++++
 arch/s390/kvm/Makefile                        |   2 +-
 arch/s390/kvm/intercept.c                     | 111 +++-
 arch/s390/kvm/interrupt.c                     | 391 ++++++++------
 arch/s390/kvm/kvm-s390.c                      | 479 ++++++++++++++++--
 arch/s390/kvm/kvm-s390.h                      |  40 ++
 arch/s390/kvm/priv.c                          |  11 +-
 arch/s390/kvm/pv.c                            | 295 +++++++++++
 arch/s390/mm/fault.c                          |  78 +++
 arch/s390/mm/gmap.c                           |  65 ++-
 include/linux/gfp.h                           |  12 +
 include/uapi/linux/kvm.h                      |  44 +-
 mm/gup.c                                      |  15 +-
 mm/page-writeback.c                           |   5 +
 33 files changed, 2438 insertions(+), 300 deletions(-)
 create mode 100644 Documentation/virt/kvm/s390-pv-boot.rst
 create mode 100644 Documentation/virt/kvm/s390-pv.rst
 create mode 100644 arch/s390/kernel/uv.c
 create mode 100644 arch/s390/kvm/pv.c

-- 
2.25.0

