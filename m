Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0735B32B576
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356206AbhCCHRU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:17:20 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10178 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1580770AbhCBSVM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 13:21:12 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 122HYaJb059787;
        Tue, 2 Mar 2021 12:44:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Az/fcfN6DK/osVtNd+1QC/ij+aqzjlyFRETwA+EL+vQ=;
 b=Z/IDWObxm1imV7V1dNAiNoT9P/7lV6FUatussw1NpTHEwmG3P4uRa5Hx9ubcC1Ar7AEu
 5JsSzFsS1XqXK0d5X6WO6xCdQyF27o/C0hZlYU7DoLS/0ycJLyJ0nl1JuuFi/zVtw9lr
 /obbPhpuqV7OoNestQzN5qJ9PffXwV6hOJ6DjPdvf5VCDefRSkcuYuXFhnnmasO21K4L
 FzAXTczA4Cj0yWf03q1lhPbnPdGeEpJMY39KJpc5Xb2IA2rBIm8SCQ2+d91pYRgdOkKc
 HRwfaByguS+sZjYGUGYiZOf5oesUy1FWqRltPPtA6pQfmKdh2sigk8TsSf6e5SD81DPQ Vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 371qgpwx6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 12:44:49 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 122HYotG063795;
        Tue, 2 Mar 2021 12:44:48 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 371qgpwx5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 12:44:48 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 122Hh5kE025623;
        Tue, 2 Mar 2021 17:44:46 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 370c59t464-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 17:44:46 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 122Hih4F39191012
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Mar 2021 17:44:43 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9DC452052;
        Tue,  2 Mar 2021 17:44:43 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.10.194])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 46AC952050;
        Tue,  2 Mar 2021 17:44:43 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v5 0/3] s390/kvm: fix MVPG when in VSIE
Date:   Tue,  2 Mar 2021 18:44:40 +0100
Message-Id: <20210302174443.514363-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-02_08:2021-03-01,2021-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxlogscore=674 bulkscore=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020136
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current handling of the MVPG instruction when executed in a nested
guest is wrong, and can lead to the nested guest hanging.

This patchset fixes the behaviour to be more architecturally correct,
and fixes the hangs observed.

v4->v5
* split kvm_s390_logical_to_effective so it can be reused for vSIE
* fix existing comments and add some more comments
* use the new split _kvm_s390_logical_to_effective in vsie_handle_mvpg

v3->v4
* added PEI_ prefix to DAT_PROT and NOT_PTE macros
* added small comment to explain what they are about

v2->v3
* improved some comments
* improved some variable and parameter names for increased readability
* fixed missing handling of page faults in the MVPG handler
* small readability improvements

v1->v2
* complete rewrite

Claudio Imbrenda (3):
  s390/kvm: split kvm_s390_logical_to_effective
  s390/kvm: extend kvm_s390_shadow_fault to return entry pointer
  s390/kvm: VSIE: correctly handle MVPG when in VSIE

 arch/s390/kvm/gaccess.c |  30 ++++++++++--
 arch/s390/kvm/gaccess.h |  35 ++++++++++---
 arch/s390/kvm/vsie.c    | 106 ++++++++++++++++++++++++++++++++++++----
 3 files changed, 151 insertions(+), 20 deletions(-)

-- 
2.26.2

