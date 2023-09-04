Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12687917B6
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 15:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347189AbjIDNCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 09:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235732AbjIDNCB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 09:02:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3415A90;
        Mon,  4 Sep 2023 06:01:58 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 384CmuAB011384;
        Mon, 4 Sep 2023 13:01:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=23/sdTOmVJG1sM6WThFxXbD4365onbaN9jukllWf84Q=;
 b=JMl5Zw78TOHAMpDD7HfFZhZPHBYf+E5Gab+rbo2ej7CDPkhqy6IVJFS9Rxhnr9+NP4Ea
 QeatJ4O5OuUJPh5bvqWwGvZcLLNdiee7icgWo6FVw8ZmvpesaQkRD3hvVa/HoECqUxT6
 2f3kZDELLyI8+WuVBCoYyyYB0+Nm0zUCo+Hu7iNnD6yVmHyNACDVd2VVOCH/3mkziY6e
 SMXtPuq4Nu5ne3wMc0JBVPKqp2AtKxuLlM+lLT+wB8KiRLXvI3pZfPSfClQP4rRKmz+O
 AAMsXlSsmfusdy9F6+5CrMS45KNqjYUqVYMNh69d4R7dJ0LJq+ruU+ZFkIouqovp0vjV pA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sw80jauw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 13:01:56 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 384C7eC9017949;
        Mon, 4 Sep 2023 13:01:55 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sw80jaumj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 13:01:54 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 384Aq4jj012232;
        Mon, 4 Sep 2023 13:01:44 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3svhkjjbtx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 13:01:44 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 384D1fYn18940480
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Sep 2023 13:01:41 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40F5D2004D;
        Mon,  4 Sep 2023 13:01:41 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0549420040;
        Mon,  4 Sep 2023 13:01:41 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  4 Sep 2023 13:01:40 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v3 0/2] KVM: s390: add counters for vsie performance
Date:   Mon,  4 Sep 2023 15:01:37 +0200
Message-ID: <20230904130140.22006-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ce0-OogtNlVRUdbZhR16vSYm8wJoVPZp
X-Proofpoint-ORIG-GUID: eAAd4Y-g0spAAsXi1kEnIlV5bDlnAhEx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-04_07,2023-08-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 mlxscore=0 impostorscore=0
 priorityscore=1501 adultscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309040117
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v3:
---
* rename te -> entry (David)
* add counters for gmap reuse and gmap create (David)

v2:
---
* also count shadowing of pages (Janosch)
* fix naming of counters (Janosch)
* mention shadowing of multiple levels is counted in each level (Claudio)
* fix inaccuate commit description regarding gmap notifier (Claudio)

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

Nico Boehr (2):
  KVM: s390: add stat counter for shadow gmap events
  KVM: s390: add tracepoint in gmap notifier

 arch/s390/include/asm/kvm_host.h |  7 +++++++
 arch/s390/kvm/gaccess.c          |  7 +++++++
 arch/s390/kvm/kvm-s390.c         | 11 ++++++++++-
 arch/s390/kvm/trace-s390.h       | 23 +++++++++++++++++++++++
 arch/s390/kvm/vsie.c             |  5 ++++-
 5 files changed, 51 insertions(+), 2 deletions(-)

-- 
2.41.0

