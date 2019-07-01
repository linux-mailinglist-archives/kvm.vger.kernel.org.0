Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0DBE10F68
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 00:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfEAWyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 May 2019 18:54:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34356 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726125AbfEAWyU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 May 2019 18:54:20 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x41MsFBX070825;
        Wed, 1 May 2019 18:54:18 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2s7k1tjkhs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 May 2019 18:54:17 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x41GsCTx029328;
        Wed, 1 May 2019 16:56:33 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01dal.us.ibm.com with ESMTP id 2s4eq3ut8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 May 2019 16:56:33 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x41MpLha27263158
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 May 2019 22:51:21 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8723AC05F;
        Wed,  1 May 2019 22:51:21 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAF28AC05B;
        Wed,  1 May 2019 22:51:21 +0000 (GMT)
Received: from collin-T470p.pok.ibm.com (unknown [9.56.58.88])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  1 May 2019 22:51:21 +0000 (GMT)
From:   Collin Walling <walling@linux.ibm.com>
To:     cohuck@redhat.com, david@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v4 0/2] Use DIAG318 to set Control Program Name & Version Codes
Date:   Wed,  1 May 2019 18:51:01 -0400
Message-Id: <1556751063-21835-1-git-send-email-walling@linux.ibm.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-01_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905010141
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changelog:

    v4
        - removed setup.c changes introduced in bullet 1 of v3
        - kept diag318_info struct cleanup
        - analogous QEMU patches:
            https://lists.gnu.org/archive/html/qemu-devel/2019-05/msg00164.html

    v3
        - kernel patch for diag 0x318 instruction call fixup [removed in v4]
        - removed CPU model code
        - cleaned up diag318_info struct
        - cpnc is no longer unshadowed as it was not needed
        - rebased on 5.1.0-rc3

This instruction call is executed once-and-only-once during Kernel setup.
The availability of this instruction depends on Read SCP Info byte 134, bit 0.
Diagnose318's functionality is also emulated by KVM, which means we can 
enable this feature for a guest even if the host kernel cannot support it.

The CPNC and CPVC are used for problem diagnosis and allows IBM to identify 
control program information by answering the following question:

    "What environment is this guest running in?" (CPNC)
    "What are more details regarding the OS?" (CPVC)

In the future, we will implement the Control Program Version Code (CPVC) to
convey more information about the OS. For now, we set this field to 0 until
we come up with a solid plan.

Collin Walling (2):
  s390/setup: diag318: refactor struct
  s390/kvm: diagnose 318 handling

 Documentation/virtual/kvm/devices/vm.txt | 14 ++++++
 arch/s390/include/asm/diag.h             |  6 +--
 arch/s390/include/asm/kvm_host.h         |  7 ++-
 arch/s390/include/uapi/asm/kvm.h         |  4 ++
 arch/s390/kernel/setup.c                 |  3 +-
 arch/s390/kvm/diag.c                     | 17 +++++++
 arch/s390/kvm/kvm-s390.c                 | 83 ++++++++++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h                 |  1 +
 arch/s390/kvm/vsie.c                     |  2 +
 9 files changed, 129 insertions(+), 8 deletions(-)

-- 
2.7.4

