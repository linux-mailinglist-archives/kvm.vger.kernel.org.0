Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32D1760CB19
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 13:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbiJYLny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 07:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbiJYLnw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 07:43:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9216C17535B
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 04:43:51 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PB7vDT006340
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=DHDIQkR+VHnKkAXph5VltlIYTgerTeQgEqNtTxxVv2s=;
 b=c/cJzsvnOHF/uERbr4Rwcc66bPvcTWNOCsSogXRYERs38DfsM1MfpQWJpLXyPGHOSr27
 dWTFGajfVoQdPDt46pqsLKAwNwxijnEyMYMY88Dehi+gwuzkbemYbjSVojdcav9V9eGz
 jM7Un/F4HzptfM7iojQtdT3LA/riOfIVv3Yj3wUuGkwg7fwq9WQNjERBkSFKQErGP2+y
 oRq0XpsWDWFxw5BLfntHlwH/Q4WyKKXYKL5DjI91HaLiPoxmBqoEnIw6j4NixZN+IYyD
 v6LTod4BIExZV0JtbuC7gjE89VJYgKxTjFHRkJKDqrbuC+x4+RF1X5du/1VGfazECU1o AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ked6qvf9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:51 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29PB8MEY009083
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:50 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ked6qvf8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:50 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29PBcQJW031685;
        Tue, 25 Oct 2022 11:43:48 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3kc859mdr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:48 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29PBhj1526411590
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 11:43:45 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DC6FAE051;
        Tue, 25 Oct 2022 11:43:45 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FF92AE045;
        Tue, 25 Oct 2022 11:43:45 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 11:43:45 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 00/22] s390x: tests and fixes for PV, timing
Date:   Tue, 25 Oct 2022 13:43:23 +0200
Message-Id: <20221025114345.28003-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xXlFO7qv-V1_7RR2zG5KXBCOkXGh-14J
X-Proofpoint-ORIG-GUID: H5_u6gtCZB9OJ50xl1AJXnCLxIjYXO3f
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_05,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 clxscore=1015 bulkscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

please merge the following changes:

* library fixes to allow multi-cpu PV guests
* additional tests and fixes for uv-host
* timing tests and library improvements
* misc fixes


MERGE: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/36

PIPELINE: https://gitlab.com/imbrenda/kvm-unit-tests/-/pipelines/676271045

PULL: https://gitlab.com/imbrenda/kvm-unit-tests.git s390x-next-2022-10


Claudio Imbrenda (2):
  lib: s390x: terminate if PGM interrupt in interrupt handler
  s390x: uv-host: fix allocation of UV memory

Janis Schoetterl-Glausch (2):
  s390x: Add specification exception test
  s390x: Test specification exceptions during transaction

Janosch Frank (14):
  s390x: uv-host: Add access checks for donated memory
  s390x: uv-host: Add uninitialized UV tests
  s390x: uv-host: Test uv immediate parameter
  s390x: uv-host: Add access exception test
  s390x: uv-host: Add a set secure config parameters test function
  s390x: uv-host: Remove duplicated +
  s390x: uv-host: Fence against being run as a PV guest
  s390x: uv-host: Fix init storage origin and length check
  s390x: snippets: asm: Add a macro to write an exception PSW
  s390x: MAKEFILE: Use $< instead of pathsubst
  lib: s390x: sie: Improve validity handling and make it vm specific
  lib: s390x: Use a new asce for each PV guest
  lib: s390x: Enable reusability of VMs that were in PV mode
  lib: s390x: sie: Properly populate SCA

Nico Boehr (4):
  lib/s390x: move TOD clock related functions to library
  s390x: add migration TOD clock test
  s390x: add exittime tests
  s390x: do not enable PV dump support by default

 configure                                |  11 +
 s390x/Makefile                           |  31 +-
 lib/s390x/asm/arch_def.h                 |  17 +
 lib/s390x/asm/time.h                     |  50 ++-
 lib/s390x/sie.h                          |  43 ++-
 lib/s390x/uv.h                           |   5 +-
 lib/s390x/asm-offsets.c                  |   2 +
 lib/s390x/interrupt.c                    |  20 +-
 lib/s390x/sie.c                          |  35 +-
 lib/s390x/uv.c                           |  35 +-
 s390x/cpu.S                              |   6 +
 s390x/snippets/asm/macros.S              |  28 ++
 s390x/snippets/asm/snippet-pv-diag-288.S |   4 +-
 s390x/snippets/asm/snippet-pv-diag-500.S |   6 +-
 s390x/exittime.c                         | 296 +++++++++++++++++
 s390x/migration-sck.c                    |  54 ++++
 s390x/sck.c                              |  32 --
 s390x/spec_ex.c                          | 392 +++++++++++++++++++++++
 s390x/uv-host.c                          | 266 ++++++++++++++-
 s390x/unittests.cfg                      |  11 +
 20 files changed, 1260 insertions(+), 84 deletions(-)
 create mode 100644 s390x/snippets/asm/macros.S
 create mode 100644 s390x/exittime.c
 create mode 100644 s390x/migration-sck.c
 create mode 100644 s390x/spec_ex.c

-- 
2.37.3

