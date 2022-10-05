Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8385F584E
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 18:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiJEQdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 12:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiJEQdF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 12:33:05 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272D97C196
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 09:33:05 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 295FcQnU014195
        for <kvm@vger.kernel.org>; Wed, 5 Oct 2022 16:33:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=ghTlRqX3cSK/qO6vXtvWY95XMeQRRKsbC2qLM9q1528=;
 b=j1+1RBZ7UiA3fPEBvsaQL4f0okEJ5q2JNj4WvE4+yxaPnXKfvivkFSZieWB0do1ohrmq
 aILfE15ZGIDj1hSmyw9xLIA1DeJsI2nukIe4yudOgiyCVn8QYJVQF7mFOzxyHPOygjiz
 ma5S0aLYm/GyXzdkB3Elr7cV+IY5851DOrDANDU7sbU2fF58IlOKypzaHeMfJYGz+LA3
 CJutXUOL/OUpZSDPx6vxfyU+pBqHyVvOyPuEcaIYglqOhcvnz0aas5KlagTdje+R8NXL
 99bv/sGUDH3RpfV72QZUE4Pd3a8p3zmj9N1FQHrkpqEhRqN3lGgL88WRbaWgMUhaGrcM qQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k1b6mw5mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 16:33:04 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 295GMPwo015937
        for <kvm@vger.kernel.org>; Wed, 5 Oct 2022 16:33:02 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3jxctj5tq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 16:33:02 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 295GWxG76750946
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Oct 2022 16:32:59 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E575CAE053;
        Wed,  5 Oct 2022 16:32:58 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0720AE04D;
        Wed,  5 Oct 2022 16:32:58 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 Oct 2022 16:32:58 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com
Subject: [PATCH v3 0/2] KVM: s390: pv: fix clock comparator late after suspend/resume
Date:   Wed,  5 Oct 2022 18:32:56 +0200
Message-Id: <20221005163258.117232-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PLzrKjM9G3CQzv002FEc91t_5buiPAHE
X-Proofpoint-ORIG-GUID: PLzrKjM9G3CQzv002FEc91t_5buiPAHE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-05_03,2022-10-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
 clxscore=1015 suspectscore=0 impostorscore=0 mlxlogscore=880 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210050100
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

Nico Boehr (2):
  KVM: s390: pv: don't allow userspace to set the clock under PV
  KVM: s390: remove now unused function kvm_s390_set_tod_clock

 arch/s390/kvm/kvm-s390.c | 22 +++++++++++++---------
 arch/s390/kvm/kvm-s390.h |  1 -
 2 files changed, 13 insertions(+), 10 deletions(-)

-- 
2.36.1

