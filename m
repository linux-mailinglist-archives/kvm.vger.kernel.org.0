Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC934EEC25
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 13:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345387AbiDALS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 07:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345489AbiDALSV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 07:18:21 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2E5183811
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 04:16:31 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 231AKRon040002
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=JFZVLPTCHGNHZHbgOLOecg76TvDB07xQyr8jIRmB1+U=;
 b=bmYE3MhbEQUdXc92zMJ52ce5E4JdDwmKgWvhxBPUNCkAx3y8cSqg4yvfYPzSrPOtJuIw
 olz0FvFiAUg1qBmyDusQqAmxmY/9gnY5j11vAZ4WrmpMspjPxdVxWgy+H/3NTO4OIVpc
 EhTb2IvQzH2z2YolAK5HhPyOCRqhaVgB3FSFXVgFaGT35qlgL8iaiaVivbMO125EP3/2
 ArTohVN6yxVk31sI4LoygoZTtxa/dPAmALM1Bc5VCLMaSAX5li6U8UeRa30JQ6GnyO2B
 aCB8YxzyuzZ87qM+ec0J6Oh9XS+1L8BYi4pjhw7RUfolGNGot8InwTj7X8fGcLNYxKZ5 Zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5yj0s13s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 11:16:30 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 231B9GLq004337
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:30 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5yj0s133-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:30 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 231B7mPu019708;
        Fri, 1 Apr 2022 11:16:28 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3f3rs3qumr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:28 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 231B4LmI52167166
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 11:04:21 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 785824C062;
        Fri,  1 Apr 2022 11:16:25 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D4854C059;
        Fri,  1 Apr 2022 11:16:25 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 11:16:25 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 00/27] s390x: smp, vm lib updates; I/O and smp tests
Date:   Fri,  1 Apr 2022 13:15:53 +0200
Message-Id: <20220401111620.366435-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ks62XFizuJeWXgQGh9KFH75FuZ_vZ5jH
X-Proofpoint-ORIG-GUID: mogCLfsBVShF4SdSVBlU6QS2U1L-xFCA
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_04,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=693
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204010050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

please merge the following changes:
* refactoring and renaming of lib/s390x/vm.[ch]
* SIGP infrastructure improvements
* fix for floating point register for snippets
* tests for I/O instructions
* more SIGP tests

MERGE:
https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/29

PIPELINE:
https://gitlab.com/imbrenda/kvm-unit-tests/-/pipelines/506807795

PULL:
https://gitlab.com/imbrenda/kvm-unit-tests.git s390x-next-2022-04

Claudio Imbrenda (5):
  s390x: remove spurious includes
  s390x: skey: remove check for old z/VM version
  lib: s390x: rename and refactor vm.[ch]
  lib: s390x: functions for machine models
  lib: s390x: stidp wrapper and move get_machine_id

Eric Farman (6):
  lib: s390x: smp: Retry SIGP SENSE on CC2
  s390x: smp: Test SIGP RESTART against stopped CPU
  s390x: smp: Fix checks for SIGP STOP STORE STATUS
  s390x: smp: Create and use a non-waiting CPU stop
  s390x: smp: Create and use a non-waiting CPU restart
  lib: s390x: smp: Remove smp_sigp_retry

Janosch Frank (1):
  s390x: snippets: c: Load initial cr0

Nico Boehr (15):
  s390x: Add more tests for MSCH
  s390x: Add test for PFMF low-address protection
  s390x: Add sck tests
  s390x: Add tests for STCRW
  s390x: Add more tests for SSCH
  s390x: Add more tests for STSCH
  s390x: Add tests for TSCH
  s390x: Add EPSW test
  s390x: smp: add tests for several invalid SIGP orders
  s390x: smp: stop already stopped CPU
  s390x: smp: add tests for SET_PREFIX
  s390x: smp: add test for EMERGENCY_SIGNAL with invalid CPU address
  s390x: smp: add tests for CONDITIONAL EMERGENCY
  s390x: add TPROT tests
  s390x: stsi: check zero and ignored bits in r0 and r1

 s390x/Makefile            |   5 +-
 lib/s390x/asm/arch_def.h  |   7 +-
 lib/s390x/css.h           |  17 +++
 lib/s390x/hardware.h      |  55 +++++++
 lib/s390x/smp.h           |   3 +-
 lib/s390x/vm.h            |  15 --
 lib/s390x/css_lib.c       |  60 ++++++++
 lib/s390x/hardware.c      |  69 +++++++++
 lib/s390x/smp.c           |  63 +++++++--
 lib/s390x/vm.c            |  92 ------------
 s390x/snippets/c/cstart.S |   6 +
 s390x/cpumodel.c          |   4 +-
 s390x/css.c               | 291 ++++++++++++++++++++++++++++++++++++++
 s390x/epsw.c              | 113 +++++++++++++++
 s390x/mvpg-sie.c          |   1 -
 s390x/mvpg.c              |   4 +-
 s390x/pfmf.c              |  29 ++++
 s390x/pv-diags.c          |   1 -
 s390x/sck.c               | 136 ++++++++++++++++++
 s390x/skey.c              |  37 +----
 s390x/smp.c               | 231 +++++++++++++++++++++++++++---
 s390x/spec_ex-sie.c       |   1 -
 s390x/stsi.c              |  42 ++++--
 s390x/tprot.c             | 108 ++++++++++++++
 s390x/uv-host.c           |   4 +-
 s390x/unittests.cfg       |  10 ++
 26 files changed, 1208 insertions(+), 196 deletions(-)
 create mode 100644 lib/s390x/hardware.h
 delete mode 100644 lib/s390x/vm.h
 create mode 100644 lib/s390x/hardware.c
 delete mode 100644 lib/s390x/vm.c
 create mode 100644 s390x/epsw.c
 create mode 100644 s390x/sck.c
 create mode 100644 s390x/tprot.c

-- 
2.34.1

