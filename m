Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBFD56FC4B6
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 13:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbjEILM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 07:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235480AbjEILMN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 07:12:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8217249ED;
        Tue,  9 May 2023 04:12:11 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 349AK84u026559;
        Tue, 9 May 2023 11:12:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=fReovrQemhbPdjzSZblb8eM+RD1007AF30q+npR60Ik=;
 b=T7SXfmcH+szRdzqUp4X0RcqKDKNbjRUXHHMUDhV+BVolhnL5e4MYipCvoh7V0bhQK/YX
 /oeyxPPDDttCFGL87wf+uCd3dva3Oycfb3lo+gZmIc3KaaKjTrioJ3/fRUtqs+qmUgqj
 lZRBtsOZTw22yo41Pk3nZpg2Szp7SWma5hT0LeUPxHFWXj4Q97Q6Wmd9lt54rT13RpW0
 10g+gN1B0o6CLLn6Z1dB6xDvdc5J3Jx4snzZBg6JYxzTdVzv4BGGM+l/miqD2Tybih2b
 bgL1YyU16VM2gPKDT3FH6T+YYagKsStWqMtxj/n7pVqiQJ3a0P9v8gBmPaK0w/H+qijF Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfmb3168n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 11:12:10 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 349Aq3rT023575;
        Tue, 9 May 2023 11:12:10 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfmb3166d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 11:12:10 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3491pcuD006862;
        Tue, 9 May 2023 11:12:06 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qf84e8cww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 11:12:06 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 349BC2Dl131716
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 May 2023 11:12:02 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B850E2005A;
        Tue,  9 May 2023 11:12:02 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97C682004E;
        Tue,  9 May 2023 11:12:02 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  9 May 2023 11:12:02 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v1 0/3] KVM: s390: add counters for vsie performance
Date:   Tue,  9 May 2023 13:11:59 +0200
Message-Id: <20230509111202.333714-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cd4lKSc6uhQApBDLaeCyL9bh5kA0GYA5
X-Proofpoint-GUID: X90HW7GHTKwpt-Yn7zPUzNkABfx-hpvP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-09_07,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 bulkscore=0 adultscore=0
 mlxlogscore=992 clxscore=1015 spamscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305090088
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running a guest-3 via VSIE, guest-1 needs to shadow the page table
structures of guest-2.

To reflect changes of the guest-2 in the _shadowed_ page table structures,
the _shadowing_ sturctures sometimes need to be rebuilt. Since this is a
costly operation, it should be avoided whenever possible.

This series adds kvm stat counters to count the number of shadow gmaps
created and a tracepoint whenever something is unshadowed. This is a first
step to try and improve VSIE performance.

Please note that "KVM: s390: add tracepoint in gmap notifier" has some
checkpatch --strict findings. I did not fix these since the tracepoint
definition would then look completely different from all the other
tracepoints in arch/s390/kvm/trace-s390.h. If you want me to fix that,
please let me know.

While developing this, a question regarding the stat counters came up:
there's usually no locking involved when the stat counters are incremented.
On s390, GCC accidentally seems to do the right thing(TM) most of the time
by generating a agsi instruction (which should be atomic given proper
alignment). However, it's not guaranteed, so would we rather want to go
with an atomic for the stat counters to avoid losing events? Or do we just
accept the fact that we might loose events sometimes? Is there anything
that speaks against having an atomic in kvm_stat?

Nico Boehr (3):
  KVM: s390: fix space before open parenthesis
  KVM: s390: add stat counter for shadow gmap events
  KVM: s390: add tracepoint in gmap notifier

 arch/s390/include/asm/kvm_host.h |  7 ++++++-
 arch/s390/kvm/gaccess.c          |  6 ++++++
 arch/s390/kvm/kvm-s390.c         |  9 ++++++++-
 arch/s390/kvm/trace-s390.h       | 23 +++++++++++++++++++++++
 arch/s390/kvm/vsie.c             |  1 +
 5 files changed, 44 insertions(+), 2 deletions(-)

-- 
2.39.1

