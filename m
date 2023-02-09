Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9CD3690499
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 11:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjBIKZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 05:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjBIKZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 05:25:13 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15BDE193D6;
        Thu,  9 Feb 2023 02:25:12 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 319AL5mS029426;
        Thu, 9 Feb 2023 10:25:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=NyzG4HZC/IAgi2zFR56A/daeBoQnV5drt/XBlDIa4Ds=;
 b=OLj4Uz2ZiaOGk7vJMffFQEcLd2X2H/RJr/RYHjK953wPwJDQ4K8HQyiZ7lgd0pWdBLzS
 2kZPELE45Mru1DNmZ91w14TWUo5Y8I63se4So9xVTMRHiTwmyU1EEIEueDwrLBTm1W44
 A5l2KDao2+pOFs4yXFuaNrE+bg+YfTbd6bcAX8vEqfLZ9o1DtroNOVZZ6O2lsWhM6jHQ
 SsYwZIEn07PNy0izt48eieB37E3hXRXeGLY4+DrbjqzHBVtClzWOS6vcfcOI4bbdDtL2
 QgW+VrqHi+e1Y0pfM+OYHryrkBmejexvtpCCXtUgnrTkvHU375EtkQDERix+dMX9ZvgM sQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmy0m02q9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:11 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 319AMWmP004410;
        Thu, 9 Feb 2023 10:25:10 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmy0m02pg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:10 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3194sPVe018248;
        Thu, 9 Feb 2023 10:25:08 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3nhf06m8mv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:08 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 319AP4AX26280418
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Feb 2023 10:25:05 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D9EF420073;
        Thu,  9 Feb 2023 10:25:04 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B47D72006A;
        Thu,  9 Feb 2023 10:25:04 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com (unknown [9.152.224.253])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  9 Feb 2023 10:25:04 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com
Subject: [GIT PULL 00/18] KVM: s390x: KVM s390x changes for 6.3
Date:   Thu,  9 Feb 2023 11:22:42 +0100
Message-Id: <20230209102300.12254-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: R8651w9715NRAn-PGuM3sRA97G6MajtT
X-Proofpoint-ORIG-GUID: 4aPi6Q4AeutgYPQAT8ZTTyrFbFusn3xP
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_07,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 spamscore=0 priorityscore=1501 bulkscore=0 mlxscore=0 mlxlogscore=566
 impostorscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

the following changes are ready for pulling for 6.3:
* Two more V!=R patches
* The last part of the cmpxchg patches
* A few fixes

This pull includes the s390 cmpxchg_user_key feature branch which is
the base for the KVM cmpxchg patches by Janis.

Cheers,
Janosch

The following changes since commit a2ce98d69fabc7d3758063366fe830f682610cf7:

  Merge remote-tracking branch 'l390-korg/cmpxchg_user_key' into kvm-next (2023-02-07 18:04:23 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-next-6.3-1

for you to fetch changes up to 5fc5b94a273655128159186c87662105db8afeb5:

  s390/virtio: sort out physical vs virtual pointers usage (2023-02-08 09:59:46 +0100)

----------------------------------------------------------------

Alexander Gordeev (1):
  s390/virtio: sort out physical vs virtual pointers usage

Janis Schoetterl-Glausch (14):
  KVM: s390: selftest: memop: Pass mop_desc via pointer
  KVM: s390: selftest: memop: Replace macros by functions
  KVM: s390: selftest: memop: Move testlist into main
  KVM: s390: selftest: memop: Add bad address test
  KVM: s390: selftest: memop: Fix typo
  KVM: s390: selftest: memop: Fix wrong address being used in test
  KVM: s390: selftest: memop: Fix integer literal
  KVM: s390: Move common code of mem_op functions into function
  KVM: s390: Dispatch to implementing function at top level of vm mem_op
  KVM: s390: Refactor absolute vm mem_op function
  KVM: s390: Refactor vcpu mem_op function
  KVM: s390: Extend MEM_OP ioctl by storage key checked cmpxchg
  Documentation: KVM: s390: Describe KVM_S390_MEMOP_F_CMPXCHG
  KVM: s390: selftest: memop: Add cmpxchg tests

Nico Boehr (2):
  KVM: s390: disable migration mode when dirty tracking is disabled
  KVM: s390: GISA: sort out physical vs virtual pointers usage

Nina Schoetterl-Glausch (1):
  KVM: selftests: Compile s390 tests with -march=z10

 Documentation/virt/kvm/api.rst            |  46 +-
 Documentation/virt/kvm/devices/vm.rst     |   4 +
 arch/s390/kvm/gaccess.c                   | 109 ++++
 arch/s390/kvm/gaccess.h                   |   3 +
 arch/s390/kvm/interrupt.c                 |  11 +-
 arch/s390/kvm/kvm-s390.c                  | 268 +++++----
 drivers/s390/virtio/virtio_ccw.c          |  46 +-
 include/uapi/linux/kvm.h                  |   8 +
 tools/testing/selftests/kvm/Makefile      |   3 +
 tools/testing/selftests/kvm/s390x/memop.c | 676 +++++++++++++++++-----
 10 files changed, 889 insertions(+), 285 deletions(-)

-- 
2.39.1

