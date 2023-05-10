Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C49C66FDD91
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 14:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236964AbjEJMSe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 08:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236476AbjEJMSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 08:18:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221DAE76;
        Wed, 10 May 2023 05:18:31 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34AC7xGK004468;
        Wed, 10 May 2023 12:18:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=GRVrtUk7C8C2h82cA6+vgRaSaN4PJCF0pMDPHJAzOy4=;
 b=K7VupLLh5WCjUXQEIBcG2yO/7U+bGMzuNX0rpiMBEU6T5+kad8pLvg1Km2wZwmlmEj36
 dnjUqhd4/13xlA853VfA6e7GDdbcOV8UtVXhVr8d5O0NbNp9N8DwdhxnRzdQi+lF/kSO
 6BAiQDCnNxTsMqn7LpIm4HHAQMaA4iu6tKO4ZUUY3/Tg+ShvDXzSbWhKZBTEsl9oO8gM
 P/O6LJI45RhW8n+0jGPQ687+0j1fD+gZFd/WqKCl1z2i6WNMYpAa1Vlm4HVXEpVIiiFd
 3ju2BJ764Km+v3HR5p7DbHfNbD157nwv/BBJUYg4wmvOZRS73mQM4hZmwWXvXb3RE80d sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qgaqu8mu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 12:18:29 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34AC87bk005918;
        Wed, 10 May 2023 12:18:29 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qgaqu8mt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 12:18:28 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34A3utdK020719;
        Wed, 10 May 2023 12:18:26 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3qf7s8gukv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 12:18:26 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34ACINeP23069296
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 May 2023 12:18:23 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2ED1320043;
        Wed, 10 May 2023 12:18:23 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E508E20040;
        Wed, 10 May 2023 12:18:22 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 10 May 2023 12:18:22 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v2 0/2] KVM: s390: add counters for vsie performance
Date:   Wed, 10 May 2023 14:18:20 +0200
Message-Id: <20230510121822.546629-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PruPin4-r9c7GxsbeUsUVrscSIGXZEGD
X-Proofpoint-GUID: IwnJKDv1qkfR4l2bApeJ4QFZ36492M_r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 bulkscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 mlxscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305100095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

 arch/s390/include/asm/kvm_host.h |  6 ++++++
 arch/s390/kvm/gaccess.c          |  7 +++++++
 arch/s390/kvm/kvm-s390.c         | 10 +++++++++-
 arch/s390/kvm/trace-s390.h       | 23 +++++++++++++++++++++++
 arch/s390/kvm/vsie.c             |  1 +
 5 files changed, 46 insertions(+), 1 deletion(-)

-- 
2.39.1

