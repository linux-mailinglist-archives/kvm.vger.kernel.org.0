Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 136B75BDE94
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 09:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbiITHma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 03:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiITHmA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 03:42:00 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C156B63F14;
        Tue, 20 Sep 2022 00:40:43 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28K7KrpV034391;
        Tue, 20 Sep 2022 07:40:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=PIuprFDbkMjIt34ysiZkVAMo84wNnFOSGS14TDl0QiM=;
 b=JrvIGEEjb3qiOQwclsT86Svu8kyFIXusQo8DcyZesSIkdlFTT5+x76+pZ6zKS2+lw/i4
 fc2Aj9Lb0LbvZ4NER28omEg+UxIFJh+GXMSIAOdfUeiNzE3c9hmyb/znQgIw7t4PFdqO
 pU/jQ2SD6xPmOiK4zeAcHGqutoDzXNBRsDFaeHpJcg1j6BYU108uzBdAY6sLQMfZtnuL
 +ZbZ+bs9+uBj1GxiI/+I43Kize4ha2gZVp6scKpFCREoUkU7F9LDHUIcPXpt2U5j/Fci
 5Uh4Bbc5XApxgd9Upsd8XhomdA/TmvaOrISkYqt0bCYt8NdjtxUVe3ajFaBpEraQA+J2 QA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jq924rj8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:40:16 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28K7L5jE035440;
        Tue, 20 Sep 2022 07:40:16 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jq924rj7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:40:15 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28K7KlB9021815;
        Tue, 20 Sep 2022 07:32:02 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3jn5v8tj8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:32:02 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28K7WPPr34930962
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 07:32:25 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A09F11C052;
        Tue, 20 Sep 2022 07:31:59 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6070E11C050;
        Tue, 20 Sep 2022 07:31:58 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Sep 2022 07:31:58 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 00/11] s390x: LPAR boot fix and additional tests
Date:   Tue, 20 Sep 2022 07:30:24 +0000
Message-Id: <20220920073035.29201-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DIWQOlnQjwnurK_aetF8Phq00FbY-skJ
X-Proofpoint-ORIG-GUID: SSl6vHeWPALsv_K-ZZ6J5j44UVGE1xQh
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_02,2022-09-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=641 adultscore=0
 spamscore=0 mlxscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209200045
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Paolo,

please merge or pull the following changes:
 - SMP setup fix that broke LPAR boot (Claudio)
 - Strict mode for specification exception interpretation (Janis)
 - Panic test support & tests (Nico)
 - SIGP Wait state test (Nico)
 - PV dump support (Nico)

MERGE:
https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/35

PULL:
The following changes since commit 7362976db651a2142ec64b5cea2029ab77a5b157:

  x86/pmu: Run the "emulation" test iff forced emulation is available (2022-08-10 12:47:18 -0400)

are available in the Git repository at:

  https://gitlab.com/frankja/kvm-unit-tests.git s390x-pull-2022-20-09

for you to fetch changes up to 3043685825d906e478ecc3b1bee32b6a7986a6e4:

  s390x: create persistent comm-key (2022-09-14 10:27:04 +0000)

----------------------------------------------------------------
Claudio Imbrenda (1):
  lib/s390x: fix SMP setup bug

Janis Schoetterl-Glausch (1):
  s390x: Add strict mode to specification exception interpretation test

Nico Boehr (9):
  s390x: smp: move sigp calls with invalid cpu address to array
  s390x: smp: use an array for sigp calls
  s390x: smp: add tests for calls in wait state
  runtime: add support for panic tests
  lib/s390x: add CPU timer related defines and functions
  s390x: add extint loop test
  s390x: add pgm spec interrupt loop test
  s390x: factor out common args for genprotimg
  s390x: create persistent comm-key

 lib/s390x/asm/arch_def.h  |   1 +
 lib/s390x/asm/time.h      |  17 ++-
 lib/s390x/io.c            |   9 ++
 lib/s390x/smp.c           |   1 +
 s390x/Makefile            |  32 +++++-
 s390x/panic-loop-extint.c |  59 ++++++++++
 s390x/panic-loop-pgm.c    |  38 ++++++
 s390x/run                 |   2 +-
 s390x/smp.c               | 235 +++++++++++++++++++++++---------------
 s390x/spec_ex-sie.c       |  53 ++++++++-
 s390x/unittests.cfg       |  12 ++
 scripts/arch-run.bash     |  49 ++++++++
 scripts/runtime.bash      |   3 +
 13 files changed, 413 insertions(+), 98 deletions(-)
 create mode 100644 s390x/panic-loop-extint.c
 create mode 100644 s390x/panic-loop-pgm.c

-- 
2.34.1

