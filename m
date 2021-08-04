Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46F33E0462
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 17:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239178AbhHDPlP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 11:41:15 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2436 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230361AbhHDPlO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Aug 2021 11:41:14 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 174FYOis193846;
        Wed, 4 Aug 2021 11:41:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=QFfUJN4ET8VWY7yaS4y7s3d7yVgFJ3J+VHp39obfvis=;
 b=OCSszvDyYFFgJVIxk8hb76tnMHqeZtaQMJ1QFowsu9VgIZkshCqNwSsammf5WQkeI0zT
 A5hwLZ/mmA4O63WpRxmGgf5ECp9PCMayYT+7LEUUJ7VkmRJhIeJtrkiuLaXAqv7AfPhd
 uihrhm0u7Z/y4Gy43qt9kJcyz3ce/UrzrDEdwujlfjEKQGe2K+S5moNJvJ5vcESpLJRD
 +NVtPTBf3xssus4m3wkf3fMGnzaXwpZ7DItOQs9OCRL1FcCdsvfd8UD09wB9wF0xg1LM
 cVqef2h7/LUvR24mzqRAmNdRxaHnoudMbdoYactaIh51TovgR1KVCRSPh3LxPOFHsqr8 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a76d84yqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 11:41:00 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 174FYNRj193571;
        Wed, 4 Aug 2021 11:41:00 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a76d84yq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 11:41:00 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 174FYXBI001184;
        Wed, 4 Aug 2021 15:40:58 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3a4x58rhgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 15:40:58 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 174FerhS44433764
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Aug 2021 15:40:53 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 591624C063;
        Wed,  4 Aug 2021 15:40:53 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA74A4C05A;
        Wed,  4 Aug 2021 15:40:52 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.2.150])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  4 Aug 2021 15:40:52 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: [PATCH v3 00/14] KVM: s390: pv: implement lazy destroy
Date:   Wed,  4 Aug 2021 17:40:32 +0200
Message-Id: <20210804154046.88552-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LQ9Qs6KshTSbzNK-25DsHKQ2_hE6nP1i
X-Proofpoint-GUID: KF7W9iXifi0jgCjpT-tEz3DcV9zmH2eD
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-04_03:2021-08-04,2021-08-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=999 impostorscore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108040089
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
guests. When a protected guest is destroyed, its memory is cleared in
background, allowing the guest to restart or terminate significantly
faster than before.

There are 2 possibilities when a protected VM is torn down:
* it still has an address space associated (reboot case)
* it does not have an address space anymore (shutdown case)

For the reboot case, the reference count of the mm is increased, and
then a background thread is started to clean up. Once the thread went
through the whole address space, the protected VM is actually
destroyed.

For the shutdown case, a list of pages to be destroyed is formed when
the mm is torn down. Instead of just unmapping the pages when the
address space is being torn down, they are also set aside. Later when
KVM cleans up the VM, a thread is started to clean up the pages from
the list.

This means that the same address space can have memory belonging to
more than one protected guest, although only one will be running, the
others will in fact not even have any CPUs.

When a guest is destroyed, its memory still counts towards its memory
control group until it's actually freed (I tested this experimentally)

When the system runs out of memory, if a guest has terminated and its
memory is being cleaned asynchronously, the OOM killer will wait a
little and then see if memory has been freed. This has the practical
effect of slowing down memory allocations when the system is out of
memory to give the cleanup thread time to cleanup and free memory, and
avoid an actual OOM situation.

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

Claudio Imbrenda (14):
  KVM: s390: pv: add macros for UVC CC values
  KVM: s390: pv: avoid stall notifications for some UVCs
  KVM: s390: pv: leak the ASCE page when destroy fails
  KVM: s390: pv: properly handle page flags for protected guests
  KVM: s390: pv: handle secure storage violations for protected guests
  KVM: s390: pv: handle secure storage exceptions for normal guests
  KVM: s390: pv: refactor s390_reset_acc
  KVM: s390: pv: usage counter instead of flag
  KVM: s390: pv: add export before import
  KVM: s390: pv: lazy destroy for reboot
  KVM: s390: pv: extend lazy destroy to handle shutdown
  KVM: s390: pv: module parameter to fence lazy destroy
  KVM: s390: pv: add OOM notifier for lazy destroy
  KVM: s390: pv: avoid export before import if possible

 arch/s390/include/asm/gmap.h        |   6 +-
 arch/s390/include/asm/mmu.h         |   3 +
 arch/s390/include/asm/mmu_context.h |   2 +
 arch/s390/include/asm/pgtable.h     |  16 +-
 arch/s390/include/asm/uv.h          |  31 +++-
 arch/s390/kernel/uv.c               | 162 +++++++++++++++++++-
 arch/s390/kvm/kvm-s390.c            |   6 +-
 arch/s390/kvm/kvm-s390.h            |   2 +-
 arch/s390/kvm/pv.c                  | 223 ++++++++++++++++++++++++++--
 arch/s390/mm/fault.c                |  20 ++-
 arch/s390/mm/gmap.c                 | 141 ++++++++++++++----
 11 files changed, 555 insertions(+), 57 deletions(-)

-- 
2.31.1

