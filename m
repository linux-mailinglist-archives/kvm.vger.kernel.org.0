Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C14A38653B
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 22:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237576AbhEQUJW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 16:09:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46510 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236354AbhEQUJW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 16:09:22 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14HK3YOe092009;
        Mon, 17 May 2021 16:08:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=j1vLWN6i9enhktiCETvIhTZ3O+xze4qWVqlCsrnxkWw=;
 b=qYbr/kNsUYqSygtI7mDr1Bxrrw916PVN+6zUPw1OUiGfyRbhFsAD5fb2DHN3h3qXUt4q
 tnmtdQArdviB9H+o1UzcFFhyJgnIQROw5z6+8V+J7dJVRBdY2AAdFDbkpqIAlhrUrwwg
 +UT1KSt11LFfpG0FZQOlSkJRPAfXR6Mtz0olnmm0PdUefi5EnuEeun72CDKaqQk5s+2o
 T9pqFxwGvI1X75EaiASLtERMji+o7KGxt85NeVnkT7xMxU9gQzv4G97ha/dZ4v5a98kf
 a5+eSViD3XKnpqHOMAtZdhSA5XpDR9JQkkiu4FTsCb1txaBLz4wVrnRS+LlWzDnTuIlf Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38kuk3egbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 16:08:04 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14HK4RoL098401;
        Mon, 17 May 2021 16:08:04 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38kuk3egbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 16:08:04 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14HK7SPm028451;
        Mon, 17 May 2021 20:08:02 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 38j5jgs2ua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 20:08:02 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14HK7Vmu21561750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 May 2021 20:07:31 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7356A52051;
        Mon, 17 May 2021 20:07:59 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.14.34])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 109B052050;
        Mon, 17 May 2021 20:07:59 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 00/11] KVM: s390: pv: implement lazy destroy
Date:   Mon, 17 May 2021 22:07:47 +0200
Message-Id: <20210517200758.22593-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ExXuGPCt5hxBFRYdGVfjbCtb4H7e0DRc
X-Proofpoint-ORIG-GUID: hm8PRwMcf2gCUfsos0KqPNdvMdqEfIW0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-17_08:2021-05-17,2021-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1011 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0
 spamscore=0 priorityscore=1501 mlxlogscore=873 suspectscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105170140
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Previously, when a protected VM was rebooted or when it was shut down,
its memory was made unprotected, and then the protected VM itself was
destroyed. Looping over the whole address space can take some time,
considering the overhead of the various Ultravisor Calls (UVCs).  This
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

Claudio Imbrenda (11):
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
  KVM: s390: pv: add support for UV feature bits

 arch/s390/boot/uv.c                 |   1 +
 arch/s390/include/asm/gmap.h        |   5 +-
 arch/s390/include/asm/mmu.h         |   3 +
 arch/s390/include/asm/mmu_context.h |   2 +
 arch/s390/include/asm/pgtable.h     |  16 +-
 arch/s390/include/asm/uv.h          |  35 ++++-
 arch/s390/kernel/uv.c               | 133 +++++++++++++++-
 arch/s390/kvm/kvm-s390.c            |   6 +-
 arch/s390/kvm/kvm-s390.h            |   2 +-
 arch/s390/kvm/pv.c                  | 230 ++++++++++++++++++++++++++--
 arch/s390/mm/fault.c                |  22 ++-
 arch/s390/mm/gmap.c                 |  86 +++++++----
 12 files changed, 490 insertions(+), 51 deletions(-)

-- 
2.31.1

