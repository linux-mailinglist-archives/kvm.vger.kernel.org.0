Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 952F316A53C
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 12:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgBXLls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 06:41:48 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29334 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727440AbgBXLlQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 06:41:16 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01OBck2O114993;
        Mon, 24 Feb 2020 06:41:13 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yax37hm39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 06:41:12 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01OBfCUV120356;
        Mon, 24 Feb 2020 06:41:12 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yax37hm2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 06:41:12 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01OBZBYd031965;
        Mon, 24 Feb 2020 11:41:11 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02dal.us.ibm.com with ESMTP id 2yaux6fuqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 11:41:11 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01OBf9QW34079156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 11:41:09 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7CF7728059;
        Mon, 24 Feb 2020 11:41:09 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F98028058;
        Mon, 24 Feb 2020 11:41:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 24 Feb 2020 11:41:09 +0000 (GMT)
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
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org
Subject: [PATCH v4 00/36] KVM: s390: Add support for protected VMs
Date:   Mon, 24 Feb 2020 06:40:31 -0500
Message-Id: <20200224114107.4646-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-24_02:2020-02-21,2020-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mm-related patches CCed on linux-mm, the complete list can be found on
the KVM and linux-s390 list. 

Andrew, any chance to take " mm:gup/writeback: add callbacks for
inaccessible pages" for 5.7? I can then carry the s390/kvm part. There
is no build dependency on this patch (just a logical one).  As an
alternative I can take an ack and carry that patch myself. 

This series contains a "pretty small" common code memory management
change that will allow paging, guest backing with files etc almost
just like normal VMs. It should be a no-op for all architectures not
opting in. And it should be usable for others that also try to get
notified on "the pages are in the process of being used for things
like I/O". This time I included error handling and an ACK from Will
Deacon as well as a Reviewed-by: from David Hildenbrand.
This patch will be used by
"[PATCH v4 05/36] s390/mm: provide memory management functions for
protected KVM guests".
We need to call into the "make accessible" architecture function when
the refcount is already increased the writeback bit is set. This will
make sure that we do not call the reverse function (convert to secure)
until the host operation has finished.


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
https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git/log/?h=protvirtv6

Claudio presented the technology at his presentation at KVM Forum
2019.

https://static.sched.com/hosted_files/kvmforum2019/3b/ibm_protected_vms_s390x.pdf


v3 -> v4:
general
-------
- copyright updates
- Reviewedby + acked by tags

KVM: s390/interrupt: do not pin adapter interrupt pages
-------------------------------------------------------
- more comments
- get rid of now obsolete adapter parameter

s390/mm: provide memory management functions for protected KVM guests
---------------------------------------------------------------------
- improved patch description

KVM: s390: protvirt: Add initial vm and cpu lifecycle handling
--------------------------------------------------------------
- rework tweak logic to not use an array
- remove _VM_ part of the subfunction names of PV_COMMAND
- merge alloc/create/destroy/dealloc into init/deinit
- handle cmma deallocation on failures
- rework error handling to pass along the first rc/rrc if VCPU or VM CREATE/DESTROY fails
This was tested successfully with error injection and tracing. We do not deallocate on
destroy failure and we pass along the first rc/rrc when vcpu destroy fails.

 KVM: s390: protvirt: Add KVM api documentation
-----------------------------------------------
- mention new MP_STATE
- remove "old" interfaces that are no longer in the previous patch
- move to the end

KVM: s390: protvirt: Secure memory is not mergeable
---------------------------------------------------
- rebase on new lifecycle patch

KVM: s390: protvirt: UV calls in support of diag308 0,1
-------------------------------------------------------
- remove _VM_ part of the subfunction names of PV_COMMAND

KVM: s390: rstify new ioctls in api.rst
---------------------------------------
- removed from this patch queue



v2 -> v3
- rebase against v5.6-rc2
- move some checks into the callers
- typo fixes
- extend UV query size
- do a tlb flush when entering/exiting protected mode
- more comments
- change interface to PV_ENABLE/DISABLE instead of vcpu/vm
  create/destroy
- lockdep checks for *is_protected calls
- locking improments
- move facility 161 to qemu
- checkpatch fixes
- merged error handling in mm patch
- removed vcpu pv commands
- use mp_state for setting the IPL PSW


v1 -> v2
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



Christian Borntraeger (4):
  KVM: s390/mm: Make pages accessible before destroying the guest
  KVM: s390: protvirt: Add SCLP interrupt handling
  KVM: s390: protvirt: do not inject interrupts after start
  KVM: s390: protvirt: introduce and enable KVM_CAP_S390_PROTECTED

Claudio Imbrenda (3):
  mm/gup/writeback: add callbacks for inaccessible pages
  s390/mm: provide memory management functions for protected KVM guests
  KVM: s390/mm: handle guest unpin events

Janosch Frank (24):
  KVM: s390: protvirt: Add UV debug trace
  KVM: s390: add new variants of UV CALL
  KVM: s390: protvirt: Add initial vm and cpu lifecycle handling
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
  KVM: s390: protvirt: UV calls in support of diag308 0, 1
  KVM: s390: protvirt: Report CPU state to Ultravisor
  KVM: s390: protvirt: Support cmd 5 operation state
  KVM: s390: protvirt: Mask PSW interrupt bits for interception 104 and
    112
  KVM: s390: protvirt: Add UV cpu reset calls
  DOCUMENTATION: Protected virtual machine introduction and IPL
  s390: protvirt: Add sysfs firmware interface for Ultravisor
    information
  KVM: s390: protvirt: Add KVM api documentation

Michael Mueller (1):
  KVM: s390: protvirt: Implement interrupt injection

Ulrich Weigand (1):
  KVM: s390/interrupt: do not pin adapter interrupt pages

Vasily Gorbik (3):
  s390/protvirt: introduce host side setup
  s390/protvirt: add ultravisor initialization
  s390/mm: add (non)secure page access exceptions handlers

 .../admin-guide/kernel-parameters.txt         |   5 +
 Documentation/virt/kvm/api.rst                |  61 +-
 Documentation/virt/kvm/devices/s390_flic.rst  |  11 +-
 Documentation/virt/kvm/index.rst              |   2 +
 Documentation/virt/kvm/s390-pv-boot.rst       |  83 +++
 Documentation/virt/kvm/s390-pv.rst            | 116 ++++
 MAINTAINERS                                   |   1 +
 arch/s390/boot/Makefile                       |   2 +-
 arch/s390/boot/uv.c                           |  21 +-
 arch/s390/include/asm/gmap.h                  |   6 +
 arch/s390/include/asm/kvm_host.h              | 113 +++-
 arch/s390/include/asm/mmu.h                   |   2 +
 arch/s390/include/asm/mmu_context.h           |   1 +
 arch/s390/include/asm/page.h                  |   5 +
 arch/s390/include/asm/pgtable.h               |  35 +-
 arch/s390/include/asm/uv.h                    | 252 ++++++++-
 arch/s390/kernel/Makefile                     |   1 +
 arch/s390/kernel/pgm_check.S                  |   4 +-
 arch/s390/kernel/setup.c                      |   9 +-
 arch/s390/kernel/uv.c                         | 413 ++++++++++++++
 arch/s390/kvm/Makefile                        |   2 +-
 arch/s390/kvm/diag.c                          |   6 +-
 arch/s390/kvm/intercept.c                     | 117 +++-
 arch/s390/kvm/interrupt.c                     | 399 +++++++------
 arch/s390/kvm/kvm-s390.c                      | 532 +++++++++++++++---
 arch/s390/kvm/kvm-s390.h                      |  51 +-
 arch/s390/kvm/priv.c                          |  13 +-
 arch/s390/kvm/pv.c                            | 298 ++++++++++
 arch/s390/mm/fault.c                          |  78 +++
 arch/s390/mm/gmap.c                           |  65 ++-
 include/linux/gfp.h                           |   6 +
 include/uapi/linux/kvm.h                      |  43 +-
 mm/gup.c                                      |  15 +-
 mm/page-writeback.c                           |   5 +
 34 files changed, 2461 insertions(+), 312 deletions(-)
 create mode 100644 Documentation/virt/kvm/s390-pv-boot.rst
 create mode 100644 Documentation/virt/kvm/s390-pv.rst
 create mode 100644 arch/s390/kernel/uv.c
 create mode 100644 arch/s390/kvm/pv.c

-- 
2.25.0

