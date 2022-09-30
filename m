Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8C85F0CE9
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 16:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbiI3OCF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 10:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbiI3OB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 10:01:59 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B0612477C;
        Fri, 30 Sep 2022 07:01:58 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28UDnWG9010887;
        Fri, 30 Sep 2022 14:01:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=S8c6sUr6AFbx9JlLmOoBsRB56ukYkox76clX6oT288o=;
 b=FfVHCSLXRGUwWcIj2efi8YgCKmtNPpEGHqTZow1c5nMdz468lnjrdJ5HDFZnRkSD+/xn
 OhFZttmqoufMxZbDSGZVnTyJXc7sqOpsZmpitUr0b1Y+4KOwBdcPBR0AZs/dCRjzHyPI
 yt7t2UDzeynCqn5EhQG3ZX8eFcYQ+CnJO9cI0ADmS9ALBl/3+1UGf6vqIWOsc54teEYL
 BLpJu+lgDI4ryKWGaapfk7j+MrT1zdgpALZ1igIXPKNpw5dUF8Q7WSR0QhKfxrQduYaH
 nJk0T1qnpf7kRtMowce3gTvonSSaIeB7++6FPOQyEJhbIUvlE5t0ILu/3PoepFnrs9of rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jx1pagd4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Sep 2022 14:01:57 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28UDoJ7c013568;
        Fri, 30 Sep 2022 14:01:56 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jx1pagd3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Sep 2022 14:01:56 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28UDpLZc004831;
        Fri, 30 Sep 2022 14:01:54 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3jssh9658f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Sep 2022 14:01:54 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28UDvVn721758380
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Sep 2022 13:57:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EE54A4040;
        Fri, 30 Sep 2022 14:01:51 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29401A404D;
        Fri, 30 Sep 2022 14:01:51 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.242])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 30 Sep 2022 14:01:51 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v14 0/6] KVM: s390: pv: implement lazy destroy for reboot
Date:   Fri, 30 Sep 2022 16:01:44 +0200
Message-Id: <20220930140150.37463-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xP_JoddyHi2jtuK_UQE2yf3YkQu159SH
X-Proofpoint-GUID: EEo5D1fMQueLvW0vozetwBCCaO-gqsGP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-30_04,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 mlxlogscore=895 impostorscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209300086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

KVM_PV_ASYNC_CLEANUP_PREPARE: prepares the current protected VM for
asynchronous teardown. The current VM will then continue immediately
as non-protected. If a protected VM had already been set aside without
starting the teardown process, this call will fail. In this case the
userspace process should issue a normal KVM_PV_DISABLE

KVM_PV_ASYNC_CLEANUP_PERFORM: tears down the protected VM previously
set aside for asychronous teardown. This PV command should ideally be
issued by userspace from a separate thread. If a fatal signal is
received (or the process terminates naturally), the command will
terminate immediately without completing. The rest of the normal KVM
teardown process will take care of properly cleaning up all leftovers.

The idea is that userspace should first issue the
KVM_PV_ASYNC_CLEANUP_PREPARE command, and in case of success, create a
new thread and issue KVM_PV_ASYNC_CLEANUP_PERFORM from there. This also
allows for proper accounting of the CPU time needed for the
asynchronous teardown.

This means that the same address space can have memory belonging to
more than one protected guest, although only one will be running, the
others will in fact not even have any CPUs.

The shutdown case should be dealt with in userspace (e.g. using
clone(CLONE_VM)).

A module parameter is also provided to disable the new functionality,
which is otherwise enabled by default. This should not be an issue
since the new functionality is opt-in anyway. This is mainly thought to
aid debugging.

v13->v14
* improve wording of commit messages
* improve wording of documentation
* improve wording of comments
* add if (!async_destroy) check in ioctl handler
* use UVC_RC_EXECUTED macro instead of hardcoded value
* use kzalloc instead of kmalloc with __GFP_ZERO flag
* rebase

v12->v13
* drop the patches that have been already merged
* rebase

Claudio Imbrenda (6):
  KVM: s390: pv: asynchronous destroy for reboot
  KVM: s390: pv: api documentation for asynchronous destroy
  KVM: s390: pv: add KVM_CAP_S390_PROTECTED_ASYNC_DISABLE
  KVM: s390: pv: avoid export before import if possible
  KVM: s390: pv: support for Destroy fast UVC
  KVM: s390: pv: module parameter to fence asynchronous destroy

 Documentation/virt/kvm/api.rst   |  37 +++-
 arch/s390/include/asm/kvm_host.h |   2 +
 arch/s390/include/asm/uv.h       |  10 +
 arch/s390/kernel/uv.c            |   7 +
 arch/s390/kvm/kvm-s390.c         |  58 +++++-
 arch/s390/kvm/kvm-s390.h         |   3 +
 arch/s390/kvm/pv.c               | 331 ++++++++++++++++++++++++++++++-
 include/uapi/linux/kvm.h         |   3 +
 8 files changed, 429 insertions(+), 22 deletions(-)

-- 
2.37.3

