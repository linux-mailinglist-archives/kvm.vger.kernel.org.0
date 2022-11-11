Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F850625FFF
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 18:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbiKKRGt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 12:06:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbiKKRGp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 12:06:45 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D110C7341C;
        Fri, 11 Nov 2022 09:06:44 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABGrd0A027640;
        Fri, 11 Nov 2022 17:06:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=zNCjohwldqQCYdUHYeTYgWAlrebk1tcr3tJef2EKY+A=;
 b=V7fWYZoGRy/eAATQuFXsCk9HwCEqKW9gYnf4WKyl6L7gsKVeZXcaatPchCc30TAHEY5k
 T7c7MVOtIt8UIfPpJqpnChXZWNNkwgckvsi/GQT9Huxbu+4Y96UkDjv7MC3+34sTOgSw
 Qr2Z7MHw0WRA3SfSCoxgR7jsFQTHujGy4SZER98nCcgPrn40feVuvOvJgy2JfJ4Qh687
 ua636/VeArNRkZ+RSZynxl5mxKKpBWyzqcLmdGdscUIGflOCm2OQGPAo2lNoaFShgusp
 ClRksfcGj4IyMSTkYi4fWZTxotEvk8vM3JGF2fPMlrrsAOG/d54BxyjukZ6tkbb510e6 xA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kstag8b7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 17:06:43 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ABGwoee015159;
        Fri, 11 Nov 2022 17:06:43 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kstag8b5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 17:06:43 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ABH6A5t026491;
        Fri, 11 Nov 2022 17:06:41 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3kngqgh12b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 17:06:41 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ABH0mW545154640
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 17:00:48 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18F794C044;
        Fri, 11 Nov 2022 17:06:38 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 865DA4C040;
        Fri, 11 Nov 2022 17:06:37 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.171.65.74])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Nov 2022 17:06:37 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v16 0/6] KVM: s390: pv: implement lazy destroy for reboot
Date:   Fri, 11 Nov 2022 18:06:26 +0100
Message-Id: <20221111170632.77622-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: INJjQR_5VlvG2CHQWZVYVk6lG9AmheNZ
X-Proofpoint-ORIG-GUID: 69eJ_cx44fmneb-5KXA2b9ftr1PuORKl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_08,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=875 clxscore=1015
 suspectscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211110115
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

v15->v16
* rebased on -next
* added :Capability: tag to documentation where appropriate
* fixed a warning when vhost devices are used by a secure guest and
  destroy configuration fast is enabled

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

 Documentation/virt/kvm/api.rst   |  41 +++-
 arch/s390/include/asm/kvm_host.h |   2 +
 arch/s390/include/asm/uv.h       |  10 +
 arch/s390/kernel/uv.c            |   7 +
 arch/s390/kvm/kvm-s390.c         |  58 +++++-
 arch/s390/kvm/kvm-s390.h         |   3 +
 arch/s390/kvm/pv.c               | 340 ++++++++++++++++++++++++++++++-
 include/uapi/linux/kvm.h         |   3 +
 8 files changed, 442 insertions(+), 22 deletions(-)

-- 
2.38.1

