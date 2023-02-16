Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E8C699ADF
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 18:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjBPRNG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 12:13:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBPRNE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 12:13:04 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768AD4E5C6
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 09:13:01 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31GF8e5w030547
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 17:13:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=9hglFhuIUExouHqxi4pxF7UYkOu4Y91Pznqyj05de3o=;
 b=tdjQbf/CsEFyusdQSx95d2GFiYFMln5ZYCUksqxng+mFEV2SEmXqEhqFwTgvZhwR0hKr
 T2ZwGsDSogQd0u3dTPnn8rUO3MuIFkSeq3uCMveA9rnZgdvSGcqAYa9YTjUyEXIUXNdC
 QWHDiZG3LMpHb3YTFKEUOZo4DX0sy+9sYvrdyyvEMjw7UoXZF5YTYe9cBN2G9Az6GYJo
 fw8nLzP+BuSKmUHq/LpOgcZEH7aYEvcRFV17UqeyTbgz2MqlVc4JNIW0moRyu0G4DBQ2
 D83wie4G6lZysBM5Pq4iHG3BRSHbQQ07i79s+hF29MXQsOlgq4pH4RMaps37f9ZP42k7 uQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nspv2k5es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 17:13:00 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31GGHSOg000780
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 17:13:00 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nspv2k5e1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 17:12:59 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31G4w7o1011623;
        Thu, 16 Feb 2023 17:12:58 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3np2n6xyn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 17:12:58 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31GHCuvA47186420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 17:12:56 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E81622004F;
        Thu, 16 Feb 2023 17:12:55 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C68142004B;
        Thu, 16 Feb 2023 17:12:55 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.56])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 16 Feb 2023 17:12:55 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 00/10] s390x: storage key migration tests, snippets and linker cleanups
Date:   Thu, 16 Feb 2023 18:12:45 +0100
Message-Id: <20230216171255.48799-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: U2F8c8NOAeBJNy1GA7nvpGbFhiIknhK2
X-Proofpoint-ORIG-GUID: YKOOKReeV3Ib1vhAsbNIxS-FlkRPnrYv
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_13,2023-02-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 impostorscore=0 phishscore=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=972 malwarescore=0 adultscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302160144
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo and/or Thomas,


please merge the following changes:

* storage key concurrent migration test
* new utility macros for PSWs
* linker and snippets cleanups
* fix backtrace when exceptions happen during VM execution

MERGE: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/40

PIPELINE: https://gitlab.com/imbrenda/kvm-unit-tests/-/pipelines/780085043

PULL: https://gitlab.com/imbrenda/kvm-unit-tests.git s390x-next-2023-02


Claudio Imbrenda (2):
  lib: s390x: add PSW and PSW_WITH_CUR_MASK macros
  s390x: use the new PSW and PSW_WITH_CUR_MASK macros

Janosch Frank (7):
  s390x: Cleanup flat.lds
  s390x: snippets: c: Cleanup flat.lds
  s390x: Add a linker script to assembly snippets
  s390x: snippets: Fix SET_PSW_NEW_ADDR macro
  lib: s390x: sie: Set guest memory pointer
  s390x: Clear first stack frame and end backtrace early
  lib: s390x: Handle debug prints for SIE exceptions correctly

Nico Boehr (1):
  s390x: add parallel skey migration test

 s390x/Makefile              |   5 +-
 lib/s390x/asm/arch_def.h    |   4 +
 lib/s390x/sie.h             |   2 +
 lib/s390x/snippet.h         |   3 +-
 lib/s390x/interrupt.c       |  46 +++++++-
 lib/s390x/sie.c             |   1 +
 lib/s390x/stack.c           |   2 +
 s390x/flat.lds              |  19 +---
 s390x/snippets/asm/flat.lds |  41 +++++++
 s390x/snippets/c/flat.lds   |  28 ++---
 s390x/cpu.S                 |   6 +-
 s390x/cstart64.S            |   2 +
 s390x/snippets/asm/macros.S |   2 +-
 s390x/adtl-status.c         |  24 +---
 s390x/firq.c                |   5 +-
 s390x/migration-skey.c      | 218 ++++++++++++++++++++++++++++++++----
 s390x/migration.c           |   6 +-
 s390x/mvpg-sie.c            |   2 +-
 s390x/pv-diags.c            |   6 +-
 s390x/skrf.c                |   7 +-
 s390x/smp.c                 |  53 ++-------
 s390x/uv-host.c             |   5 +-
 s390x/unittests.cfg         |  15 ++-
 23 files changed, 348 insertions(+), 154 deletions(-)
 create mode 100644 s390x/snippets/asm/flat.lds

-- 
2.39.1

