Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FBC467BE9
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 17:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382237AbhLCRBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 12:01:46 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1796 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240527AbhLCRBq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Dec 2021 12:01:46 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B3GIJFg015330;
        Fri, 3 Dec 2021 16:58:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Srv5VCJ2D5KvzxADRBHhOU8B6d/fo6TUR/8qPva/6w0=;
 b=Q4TvyJIT2Vi+gAGoRGWGs1Yqv6UuOwmOVpYOjpDG9JTvPrTTCS0oPJhJcVFe6U/gJ5P6
 t86+FqB8M0GkZzlyUC/dpgC4pCh0gYrE8TwhQU8HkSyrERnRdFgpaX14Ag7EN8+1hZQ/
 vj0D9ppRSSWS6uwqRCEilksV4DLuQYJ2frJyxcrbvdxGCBt+voBQFjCamWvl+vaarflV
 ViK10CXRC807uWmNDvAd40OzfRbF7ZsoKdtEvZpgrElCeNqC9jb9kMA8/h/raSRI5yjR
 vUk8U/mDhVeKx6EHVXGC1LbDF0geUbR4AAEIGQFHgF95ELjhIZCifm7sGawpjscotwYr BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cqpn28rwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:21 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B3GfO8T022194;
        Fri, 3 Dec 2021 16:58:21 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cqpn28rvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:21 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B3GwGZh023119;
        Fri, 3 Dec 2021 16:58:19 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3ckbxkyv8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:18 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B3GwF7T29295042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Dec 2021 16:58:15 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7584152051;
        Fri,  3 Dec 2021 16:58:15 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.14.21])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E60E352054;
        Fri,  3 Dec 2021 16:58:14 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 00/17] KVM: s390: pv: implement lazy destroy for reboot
Date:   Fri,  3 Dec 2021 17:57:57 +0100
Message-Id: <20211203165814.73016-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KvNVnndubEgsOxDleDnomS18gTT96_0k
X-Proofpoint-ORIG-GUID: kBDC5uEAN2XxS470W9tx2sz8K0NcbUl5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-03_07,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 mlxlogscore=887 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112030105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Previously, when a protected VM was rebooted or when it was shut down,
its memory was made unprotected, and then the protected VM itself was
destroyed. Looping over the whole address space can take some time,
considering the overhead of the various Ultravisor Calls (UVCs). This
means that a reboot or a shutdown would take a potentially long amount
of time, depending on the amount of used memory.

This patchseries implements a deferred destroy mechanism for protected
guests. When a protected guest is destroyed, its memory can be cleared
in background, allowing the guest to restart or terminate significantly
faster than before.

There are 2 possibilities when a protected VM is torn down:
* it still has an address space associated (reboot case)
* it does not have an address space anymore (shutdown case)

For the reboot case, two new commands are available for the
KVM_S390_PV_COMMAND:

KVM_PV_ASYNC_DISABLE_PREPARE: prepares the current protected VM for
asynchronous teardown. The current VM will then continue immediately
as non-protected. If a protected VM had already been set aside without
starting the teardown process, this call will fail. In this case the
userspace process should issue a normal KVM_PV_DISABLE

KVM_PV_ASYNC_DISABLE: tears down the protected VM previously set aside
for asychronous teardown. This PV command should ideally be issued by
userspace from a separate thread. If a fatal signal is received (or
the process terminates naturally), the command will terminate
immediately without completing.

The idea is that userspace should first issue the
KVM_PV_ASYNC_DISABLE_PREPARE command, and in case of success, create a
new thread and issue KVM_PV_ASYNC_DISABLE from there. This also allows
for proper accounting of the CPU time needed for the asynchronous
teardown.

This means that the same address space can have memory belonging to
more than one protected guest, although only one will be running, the
others will in fact not even have any CPUs.

The shutdown case should be dealt with in userspace (e.g. using
clone(CLONE_VM)).

A module parameter is also provided to disable the new functionality,
which is otherwise enabled by default. This should not be an issue
since the new functionality is opt-in anyway. This is mainly thought to
aid debugging.

v5->v6
* completely reworked the series
* removed kernel thread for asynchronous teardown
* added new commands to KVM_S390_PV_COMMAND ioctl

v4->v5
* fixed and improved some patch descriptions
* added some comments to better explain what's going on
* use vma_lookup instead of find_vma
* rename is_protected to protected_count since now it's used as a counter

v3->v4
* added patch 2
* split patch 3
* removed the shutdown part -- will be a separate patchseries
* moved the patch introducing the module parameter

v2->v3
* added definitions for CC return codes for the UVC instruction
* improved make_secure_pte:
  - renamed rc to cc
  - added comments to explain why returning -EAGAIN is ok
* fixed kvm_s390_pv_replace_asce and kvm_s390_pv_remove_old_asce:
  - renamed
  - added locking
  - moved to gmap.c
* do proper error management in do_secure_storage_access instead of
  trying again hoping to get a different exception
* fix outdated patch descriptions

v1->v2
* rebased on a more recent kernel
* improved/expanded some patch descriptions
* improves/expanded some comments
* added patch 1, which prevents stall notification when the system is
  under heavy load.
* rename some members of struct deferred_priv to improve readability
* avoid an use-after-free bug of the struct mm in case of shutdown
* add missing return when lazy destroy is disabled
* add support for OOM notifier

Claudio Imbrenda (17):
  KVM: s390: pv: leak the topmost page table when destroy fails
  KVM: s390: pv: handle secure storage violations for protected guests
  KVM: s390: pv: handle secure storage exceptions for normal guests
  KVM: s390: pv: refactor s390_reset_acc
  KVM: s390: pv: usage counter instead of flag
  KVM: s390: pv: add export before import
  KVM: s390: pv: module parameter to fence lazy destroy
  KVM: s390: pv: make kvm_s390_cpus_from_pv global
  KVM: s390: pv: clear the state without memset
  KVM: s390: pv: add mmu_notifier
  s390/mm: KVM: pv: when tearing down, try to destroy protected pages
  KVM: s390: pv: refactoring of kvm_s390_pv_deinit_vm
  KVM: s390: pv: cleanup leftover protected VMs if needed
  KVM: s390: pv: asynchronous destroy for reboot
  KVM: s390: pv: api documentation for asynchronous destroy
  KVM: s390: pv: add KVM_CAP_S390_PROT_REBOOT_ASYNC
  KVM: s390: pv: avoid export before import if possible

 Documentation/virt/kvm/api.rst      |  21 ++-
 arch/s390/include/asm/gmap.h        |  38 +++-
 arch/s390/include/asm/kvm_host.h    |   3 +
 arch/s390/include/asm/mmu.h         |   2 +-
 arch/s390/include/asm/mmu_context.h |   2 +-
 arch/s390/include/asm/pgtable.h     |  11 +-
 arch/s390/include/asm/uv.h          |   1 +
 arch/s390/kernel/uv.c               |  64 +++++++
 arch/s390/kvm/kvm-s390.c            |  59 ++++++-
 arch/s390/kvm/kvm-s390.h            |   3 +
 arch/s390/kvm/pv.c                  | 259 ++++++++++++++++++++++++++--
 arch/s390/mm/fault.c                |  20 ++-
 arch/s390/mm/gmap.c                 | 152 +++++++++++++---
 include/uapi/linux/kvm.h            |   3 +
 14 files changed, 591 insertions(+), 47 deletions(-)

-- 
2.31.1

