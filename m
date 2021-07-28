Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60FD3D907B
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 16:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237089AbhG1O0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 10:26:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31608 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236976AbhG1O0p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 10:26:45 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SENRY2042272;
        Wed, 28 Jul 2021 10:26:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=hvAOTiEKaEgvFj0kPp3Kt/7BfN6vnah/Lx98H8heYGo=;
 b=KZeTNDQv7RhCwpggu9N3aVWFREBSaIkq9VmobF6nSgQsNDJs49VjZ+J7iB45JdS7/gsq
 9CCXeUleYtTEal8BzcUaOG27wcm7BsdJkYv9fyxZiZ8kwoS4eTb2aLb3TsQtE/o22N1F
 C8tzBHD7zTOXEy5d/UPvZPuCkLDdF++Q1OMOxAsnaq2NwSj01gkbXZYPzkkN9Bkw4KxX
 O5xumTlAWSvcTJ4DrUGJZp4cRcr+cjHNH7/sfAy/a/URKxWhCw7+QULpt079f3olp5DK
 agfj+3w74KAUPNIRtWK+oHCGijRcVyWi11POo0++1WwnqLOnIuWi+lsgoQqxmKMdoy5T Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a38cthnmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 10:26:43 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16SENQKh042178;
        Wed, 28 Jul 2021 10:26:42 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a38cthnkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 10:26:42 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16SEJDH7024351;
        Wed, 28 Jul 2021 14:26:40 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3a235yh4k0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 14:26:40 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16SEQaxf25886980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 14:26:37 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4BB0A405D;
        Wed, 28 Jul 2021 14:26:36 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6ACFEA4053;
        Wed, 28 Jul 2021 14:26:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.9.194])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Jul 2021 14:26:36 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/13] KVM: s390: pv: implement lazy destroy
Date:   Wed, 28 Jul 2021 16:26:18 +0200
Message-Id: <20210728142631.41860-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iZSBioiGCCgkctBGdC9NOTFXxvz_znRv
X-Proofpoint-GUID: esy9GRG-S1MbUUYnatQ5Ov9nHA3MBnai
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_08:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 suspectscore=0
 malwarescore=0 clxscore=1011 impostorscore=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2107280079
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

Claudio Imbrenda (13):
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
  KVM: s390: pv: add support for UV feature bits

 arch/s390/include/asm/gmap.h        |   5 +-
 arch/s390/include/asm/mmu.h         |   3 +
 arch/s390/include/asm/mmu_context.h |   2 +
 arch/s390/include/asm/pgtable.h     |  16 +-
 arch/s390/include/asm/uv.h          |  26 ++-
 arch/s390/kernel/uv.c               | 144 ++++++++++++++-
 arch/s390/kvm/kvm-s390.c            |   6 +-
 arch/s390/kvm/kvm-s390.h            |   2 +-
 arch/s390/kvm/pv.c                  | 272 ++++++++++++++++++++++++++--
 arch/s390/mm/fault.c                |  22 ++-
 arch/s390/mm/gmap.c                 |  86 ++++++---
 11 files changed, 530 insertions(+), 54 deletions(-)

-- 
2.31.1

