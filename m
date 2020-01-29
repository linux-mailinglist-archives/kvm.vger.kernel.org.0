Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A317614D1AC
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 21:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgA2UD2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 15:03:28 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60290 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726259AbgA2UD2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Jan 2020 15:03:28 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00TJtkxH063564
        for <kvm@vger.kernel.org>; Wed, 29 Jan 2020 15:03:27 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xu5q5f34x-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 29 Jan 2020 15:03:27 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 29 Jan 2020 20:03:25 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 29 Jan 2020 20:03:22 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00TK2Tr644827116
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jan 2020 20:02:29 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE42A11C04C;
        Wed, 29 Jan 2020 20:03:20 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BFD611C050;
        Wed, 29 Jan 2020 20:03:19 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.2.173])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Jan 2020 20:03:19 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com, david@redhat.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
Subject: [PATCH v8 0/4] KVM: s390: Add new reset vcpu API
Date:   Wed, 29 Jan 2020 15:03:08 -0500
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20012920-0028-0000-0000-000003D5957E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20012920-0029-0000-0000-00002499E1ED
Message-Id: <20200129200312.3200-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-29_06:2020-01-28,2020-01-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 mlxlogscore=852
 clxscore=1015 mlxscore=0 bulkscore=0 spamscore=0 suspectscore=1
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001290154
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's implement the remaining resets, namely the normal and clear
reset to improve architectural compliance. 

While we're at it, let's also start testing the new API.
Those tests are not yet complete, but will be extended in the future.

Janosch Frank (3):
  KVM: s390: Add new reset vcpu API
  selftests: KVM: Add fpu and one reg set/get library functions
  selftests: KVM: s390x: Add reset tests

Pierre Morel (1):
  selftests: KVM: testing the local IRQs resets

 Documentation/virt/kvm/api.txt                |  43 ++++
 arch/s390/kvm/kvm-s390.c                      | 103 +++++---
 include/uapi/linux/kvm.h                      |   5 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   6 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  48 ++++
 tools/testing/selftests/kvm/s390x/resets.c    | 222 ++++++++++++++++++
 7 files changed, 399 insertions(+), 29 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/s390x/resets.c

-- 
2.20.1

