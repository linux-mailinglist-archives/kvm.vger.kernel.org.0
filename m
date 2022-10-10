Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 398555FA099
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 16:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiJJOzF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 10:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiJJOyx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 10:54:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79F3140A8;
        Mon, 10 Oct 2022 07:54:49 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29AE5m1I003082;
        Mon, 10 Oct 2022 14:54:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=MNllhxLP8eX778MTVCjQg9W7CjVu5l43psMt8gtpb1Q=;
 b=Pxn1tYLMTU0lQ/4pCzpIGRANFLKOg0C3RoVMeeiFPpgjQ8/dtdbfMg11wwNA1yrmonBh
 oveRIgFd6QBZmAeHeBZvmeNSmmgqSqYknGjUsD70j7B7OtyJrMq4Uv+yyoXHxtsT+ZUD
 hHopjlYmfJAXRBFphBT4tbz1LaPIKAUFyIsaeoBpnn5wycoQhwc65WpXmoSYywjIr6UO
 or79KP6u/GmRtDSSVzurbZqY4u9JHPgZ+mQLP/8yKm5lj9ZdeSFgwYSlotMdignIMZQA
 dVKRdF2qs9i/fWt+RcwVkLUM9BS842qosVcS8adOOzDgz0qqlVMJzg2noV+PdjbsnnrI yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3k3k98g9vu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 14:54:48 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29AEoeDA013758;
        Mon, 10 Oct 2022 14:54:48 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3k3k98g9v5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 14:54:48 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29AEowQx023153;
        Mon, 10 Oct 2022 14:54:46 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3k30u9j653-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 14:54:46 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29AEshFM066072
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Oct 2022 14:54:43 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 289D652050;
        Mon, 10 Oct 2022 14:54:43 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.242])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id CE1375204F;
        Mon, 10 Oct 2022 14:54:42 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v15 0/6] KVM: s390: pv: implement lazy destroy for reboot
Date:   Mon, 10 Oct 2022 16:54:36 +0200
Message-Id: <20221010145442.85867-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5F5Ni2pU0REBOa0oYuNpnOyHnm9w5iGD
X-Proofpoint-ORIG-GUID: cBq1Xg4c3Z9cdKE54gXFclL5t0IFWZUN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-10_08,2022-10-10_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 mlxscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=849 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210100086
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

v14->v15
* fix some variable names
* improve comment in kvm_s390_pv_deinit_vm
* use existing macros instead of magic values for UVC_RC_EXECUTED
* add lockdep_assert_held to kvm_s390_pv_set_aside

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
 arch/s390/kvm/pv.c               | 336 ++++++++++++++++++++++++++++++-
 include/uapi/linux/kvm.h         |   3 +
 8 files changed, 434 insertions(+), 22 deletions(-)

-- 
2.37.3

