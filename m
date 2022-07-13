Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC14573487
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 12:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbiGMKqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 06:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbiGMKqL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 06:46:11 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78D2FE500;
        Wed, 13 Jul 2022 03:46:09 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26DAiSVc006720;
        Wed, 13 Jul 2022 10:46:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=/jpiMPY4COh6tulFlJAJqSios5yAm/5Oc1GCP3SdHKY=;
 b=gW2RSvv4WKzLQzjAddNUlaps0NsaoU13PU91k6XLNRSJfbI8qaV6UxHC4gOvAyRjD4cI
 zP+3T023PA+zGCSKA5m/et68SRMPXmjCjAegwn92fVmQXZWBBpM19oUeMJU+uWczflRi
 kvPsyKkUUdfyEniMk5Qy2kd2kj2nuxRzAxxHn6ZcURZNeEHKKNh20xFEmKcFkMy0HXRI
 xHGTAHBAmNPtflEtKxv9qF5J0Et5XdpiJf9RMqHLFIu6FblIlT0vaXTtM0jVbTRjMjcw
 oVhW1cUqWAB1lgs/tYX2QtEbd2yEVDxE/L4aaCUHsW0SuuSNd9mOgmFrFGFwi5Al5ErR Vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9u85t1a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 10:46:08 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26DACx5o019429;
        Wed, 13 Jul 2022 10:46:08 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9u85t19g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 10:46:08 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26DAZM1Z017481;
        Wed, 13 Jul 2022 10:46:06 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3h71a8msmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 10:46:06 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26DAk3op24117576
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jul 2022 10:46:03 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19B72A4051;
        Wed, 13 Jul 2022 10:46:03 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC5DBA404D;
        Wed, 13 Jul 2022 10:46:02 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.0.75])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jul 2022 10:46:02 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        scgl@linux.ibm.com, nrb@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 0/3] better smp interrupt checks
Date:   Wed, 13 Jul 2022 12:45:54 +0200
Message-Id: <20220713104557.168113-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -vP5Xq56Zc3Lxm_JCjUAiMHRVdwEMGKO
X-Proofpoint-ORIG-GUID: 6ZAc-uHGfMkIytOJAc9slVtzuosrBoBT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_14,2022-07-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 phishscore=0 impostorscore=0 malwarescore=0 adultscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=690
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207130043
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

v2->v3
* improve commit messages and fix some comments
* remove unused psw_mask_set_clear_bits
* remove ext_cleanup_func from struct cpu
* minor code style changes

Claudio Imbrenda (3):
  lib: s390x: add functions to set and clear PSW bits
  s390x: skey.c: rework the interrupt handler
  lib: s390x: better smp interrupt checks

 lib/s390x/asm/arch_def.h | 61 ++++++++++++++++++++++++++++++++++------
 lib/s390x/asm/pgtable.h  |  2 --
 lib/s390x/smp.h          |  8 +-----
 lib/s390x/interrupt.c    | 57 +++++++++++++++++++++++++++----------
 lib/s390x/mmu.c          | 14 +--------
 lib/s390x/sclp.c         |  7 +----
 lib/s390x/smp.c          | 11 ++++++++
 s390x/diag288.c          |  6 ++--
 s390x/selftest.c         |  4 +--
 s390x/skey.c             | 23 ++++++---------
 s390x/skrf.c             | 12 ++------
 s390x/smp.c              | 18 ++----------
 12 files changed, 127 insertions(+), 96 deletions(-)

-- 
2.36.1

