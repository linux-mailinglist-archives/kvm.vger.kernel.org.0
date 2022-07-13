Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E82573C18
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 19:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236298AbiGMRkR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 13:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbiGMRkQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 13:40:16 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4750621E2A;
        Wed, 13 Jul 2022 10:40:15 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26DGELRE025211;
        Wed, 13 Jul 2022 17:40:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=iRbODVvBLkzI1kay3hHZFehvOAKgDgSpcxx4EuWIpys=;
 b=lIi3fkXIlZoHgDk7GrcFX64+QJBDfPkTuxGSF6QDm4z4Ez3oQOPDIE4LRbS901NNh/G9
 0Jh6F7KCjjf3eUfQRcqe+SXNmPcGpJI4bxMerxtHUqSFCuLBRMzw54GJY9xFHd0JDb5i
 SLtCVLoT28Vn4KXwIACAmw5zOXiVSAhJUup8c5odFg3KYO3rTRw3s1lkWAqconNwrKHh
 58OiAm8ulnVl2PtbBoXaFwUDuwI+DY0fAp1hdy57zUWsft2Skwweh/a64uG3LXAwn0eX
 USlqRD5s80jibC5agt6lZSxRAuKX8JL1ThniHZ+eYDiU68OwNCJ2m27bwMM/Kh7iLtFr tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ha1cx20jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 17:40:14 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26DHbR4b026527;
        Wed, 13 Jul 2022 17:40:13 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ha1cx20j6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 17:40:13 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26DHKDvw007329;
        Wed, 13 Jul 2022 17:40:12 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3h70xhx0eu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 17:40:12 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26DHe95t19923366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jul 2022 17:40:09 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0EB755204E;
        Wed, 13 Jul 2022 17:40:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.0.75])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B0C2D52051;
        Wed, 13 Jul 2022 17:40:08 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        scgl@linux.ibm.com, nrb@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v4 0/3] better smp interrupt checks
Date:   Wed, 13 Jul 2022 19:39:57 +0200
Message-Id: <20220713174000.195695-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4uLfNQ-LHhoZ6m8Z91C2rGFRjtLG8AZe
X-Proofpoint-ORIG-GUID: 80G6DACra-G7jvQvkZOqOiMjzUrHWW_l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-13_07,2022-07-13_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=695 bulkscore=0
 adultscore=0 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207130072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use per-CPU flags and callbacks for Program and External interrupts
instead of global variables.
    
This allows for more accurate error handling; a CPU waiting for an
interrupt will not have it "stolen" by a different CPU that was not
supposed to wait for one, and now two CPUs can wait for interrupts at
the same time.

Also fix skey.c to be compatible with the new interrupt handling.

Add some utility functions to manipulate bits in the PSW mask, to
improve readability.

v3->v4
* re-introduce ext_cleanup_func
* re-introduce psw_mask_set_and_clear_bits
* cleanup functions now take a pointer to the stack frame

v2->v3
* improve commit messages and fix some comments
* remove unused psw_mask_set_clear_bits
* remove ext_cleanup_func from struct cpu
* minor code style changes

Claudio Imbrenda (3):
  lib: s390x: add functions to set and clear PSW bits
  s390x: skey.c: rework the interrupt handler
  lib: s390x: better smp interrupt checks

 lib/s390x/asm/arch_def.h  | 75 ++++++++++++++++++++++++++++++++++----
 lib/s390x/asm/interrupt.h |  3 +-
 lib/s390x/asm/pgtable.h   |  2 -
 lib/s390x/smp.h           |  8 +---
 lib/s390x/interrupt.c     | 77 +++++++++++++++++++++++++++++++--------
 lib/s390x/mmu.c           | 14 +------
 lib/s390x/sclp.c          |  7 +---
 lib/s390x/smp.c           | 11 ++++++
 s390x/diag288.c           |  6 +--
 s390x/selftest.c          |  4 +-
 s390x/skey.c              | 23 ++++--------
 s390x/skrf.c              | 14 ++-----
 s390x/smp.c               | 18 ++-------
 13 files changed, 163 insertions(+), 99 deletions(-)

-- 
2.36.1

