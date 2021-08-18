Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E790F3F049B
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 15:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237130AbhHRN1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 09:27:08 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32826 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237008AbhHRN1F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 09:27:05 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17ID2unw131842;
        Wed, 18 Aug 2021 09:26:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=mUOjUwhOg1TZwyuf8+PsacD68XEMl2xjesMrps7k50c=;
 b=mq0PAKjbq+jRma050zrpbvRRAcTjVxCIlN0Fauqg8IKeynwddgE8/HfW6/x5eDyWjgJM
 z7DoSoacuVL2unfe91H8l6+NCdPViFwN4MySYYhyDLm6FgjMT70BBIfPdRHj1y01rEDe
 KPHa4iLlCzyFK8rOim9SU9Dobo8Gj8rwkQRBials3BhKb9Qg5tewSxt/UW6VP37pOCV7
 PWHjAvuDrHfgKKac2hOWkGl0nx+P/ZTq3DCTTgJI4Q8mfXFli6Kt7UOyp+BJ6fcxIMEZ
 mdppecdNKgvqQeAwIGWepcLorQt0yMMkVKJXcGnqaK4BLaZ+SPEajzo6QRaW3dHeB5Qe 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3agp1yknj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 09:26:27 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17ID3S7Y137158;
        Wed, 18 Aug 2021 09:26:27 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3agp1yknh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 09:26:27 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17IDCPRS007447;
        Wed, 18 Aug 2021 13:26:25 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3ae53hdrjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 13:26:25 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17IDQLG256754586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 13:26:21 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0318F4C062;
        Wed, 18 Aug 2021 13:26:21 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7219F4C059;
        Wed, 18 Aug 2021 13:26:20 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.14.177])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Aug 2021 13:26:20 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: [PATCH v4 00/14] KVM: s390: pv: implement lazy destroy for reboot
Date:   Wed, 18 Aug 2021 15:26:06 +0200
Message-Id: <20210818132620.46770-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JR3QSBUheSgf3km6gZoA80_7BqPyroUP
X-Proofpoint-GUID: o2RMMCMGx3hGSPMf39ierqi7Wijms6LO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_04:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 impostorscore=0 suspectscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108180082
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

This means that the same address space can have memory belonging to
more than one protected guest, although only one will be running, the
others will in fact not even have any CPUs.

The shutdown case is more controversial, and it will be dealt with in a
future patchseries.

When a guest is destroyed, its memory still counts towards its memory
control group until it's actually freed (I tested this experimentally)

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

Claudio Imbrenda (14):
  KVM: s390: pv: add macros for UVC CC values
  KVM: s390: pv: avoid double free of sida page
  KVM: s390: pv: avoid stalls for kvm_s390_pv_init_vm
  KVM: s390: pv: avoid stalls when making pages secure
  KVM: s390: pv: leak the ASCE page when destroy fails
  KVM: s390: pv: properly handle page flags for protected guests
  KVM: s390: pv: handle secure storage violations for protected guests
  KVM: s390: pv: handle secure storage exceptions for normal guests
  KVM: s390: pv: refactor s390_reset_acc
  KVM: s390: pv: usage counter instead of flag
  KVM: s390: pv: add export before import
  KVM: s390: pv: module parameter to fence lazy destroy
  KVM: s390: pv: lazy destroy for reboot
  KVM: s390: pv: avoid export before import if possible

 arch/s390/include/asm/gmap.h    |   6 +-
 arch/s390/include/asm/pgtable.h |   9 +-
 arch/s390/include/asm/uv.h      |  16 ++-
 arch/s390/kernel/uv.c           | 115 ++++++++++++++++++--
 arch/s390/kvm/kvm-s390.c        |   6 +-
 arch/s390/kvm/kvm-s390.h        |   2 +-
 arch/s390/kvm/pv.c              | 185 ++++++++++++++++++++++++++++----
 arch/s390/mm/fault.c            |  20 +++-
 arch/s390/mm/gmap.c             | 141 +++++++++++++++++++-----
 9 files changed, 434 insertions(+), 66 deletions(-)

-- 
2.31.1

