Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF2E75FB7EA
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 18:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbiJKQHV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 12:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiJKQHU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 12:07:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60ECC5208F
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 09:07:19 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29BEiJcx020944
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 16:07:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=4MO8DEKSxzJYxo25hsUnFJ5b0UrY+upeG7+dg8xYlj4=;
 b=J+mc5/aeVRuvwMr7/zWTZpS10Y4CSy1K6RB2Zk0bWv8DNMc2uJIuG5dIDPmGbjxABdKc
 ZzPqR/ZEn1WlQiCZH/3TjtsMyN87jPmCY39YQtxnr0Knv0CNnVzVRNuizeYzJZ0CtXOc
 UUrKdgWzj3MGnybJFHLK46i8MrUOXXPPnGhkDP8euGZv/ftFtWZIAOyFMuLLj5hQs1oQ
 hvnHOkNvCrvLyFhWyyhSd5r8DtR4qj7N5x9kijzlMT399fUG/p1sGXdd8lxNQCvNidmO
 60qZJ912HaEYof+nLYE8G0ZDygHNdUNDw2oWq1V+JBlJHb3t5ql0Fc6aKd1kRt0MyMPZ 4Q== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3k584erc1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 16:07:18 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29BG6gDd030761
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 16:07:16 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3k30fjcqsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 16:07:16 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29BG7iZL41877770
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Oct 2022 16:07:44 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D52BA405C;
        Tue, 11 Oct 2022 16:07:13 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC9F0A4054;
        Tue, 11 Oct 2022 16:07:12 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Oct 2022 16:07:12 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com
Subject: [PATCH v4 0/1] KVM: s390: pv: fix clock comparator late after suspend/resume
Date:   Tue, 11 Oct 2022 18:07:11 +0200
Message-Id: <20221011160712.928239-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: e16Y6j3P5b3j6pi7tWjD58u3S1sQi-DR
X-Proofpoint-ORIG-GUID: e16Y6j3P5b3j6pi7tWjD58u3S1sQi-DR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-11_08,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 suspectscore=0 phishscore=0 clxscore=1015 spamscore=0 bulkscore=0
 mlxlogscore=856 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210110092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v3->v4:
---
- squash both commits
- update docs (thanks Janosch)
- add a comment (thanks Janosch)

v2->v3:
---
- add commit to remove kvm_s390_set_tod_clock() function (thanks Claudio)

v1->v2:
---
- fix broken migration due to deadlock

After a PV guest in QEMU has been paused and resumed, clock comparator
interrupts are delivered to the guest much too late.

This is caused by QEMU's tod-kvm device restoring the guest's TOD clock
upon guest resume. This is not possible with PV, since the guest's TOD
clock is controlled by the ultravisor.

Even if not allowed under PV, KVM allowed the respective call from
userspace (VM attribute KVM_S390_VM_TOD) and updated its internal data
structures on this call. This can make the ultravisor's and KVM's view
of the guest TOD clock inconsistent. This in turn can lead to the late
delivery of clock comparator interrupts when KVM calculates when to wake
the guest.

This fixes the kernel portion of the problem by disallowing the vm attr
call for the guest TOD clock so userspace cannot mess up KVM's view of
the guest TOD. This fix causes an ugly warning in QEMU though, hence
another fix is due for QEMU to simply not even attempt to set the guest
TOD on resume.

Nico Boehr (1):
  KVM: s390: pv: don't allow userspace to set the clock under PV

 Documentation/virt/kvm/devices/vm.rst |  3 +++
 arch/s390/kvm/kvm-s390.c              | 26 +++++++++++++++++---------
 arch/s390/kvm/kvm-s390.h              |  1 -
 3 files changed, 20 insertions(+), 10 deletions(-)

-- 
2.36.1

