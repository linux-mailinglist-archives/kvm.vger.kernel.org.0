Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5452C54B422
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 17:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355424AbiFNPBF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 11:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355960AbiFNPA7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 11:00:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F9C427C3
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 08:00:57 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25EEqGih019841
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 15:00:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=h4UpysPbW91ClOAjXIS/7N55kYU1qJVn0QhvkNoeum8=;
 b=jX42cpOf1grpUAorRVoZpdLMEIJ+Rl3zphOUVcPhiN2i2JsKajMaR2sRpBXqbymaGFzQ
 U1p4v3eGoEFFATG6JyYTO65ZDns8l5kPZfscfXsrIdqfWj+3f70Oh/KePvApWG6ZLgCJ
 c8a9S+OrcrVK0On7drct7ItTUCmdAuaKvo8nXLxQ+gGQvATpGYTrQKfkFxykV7XNdSmi
 l5zEoulj77kghhuJwMCz5Ml+C/G1fvbzRwbrdBWgW/3nasWpd1NqVNO5wvNnHXsVK7tO
 p+jyebsi1oo01VVATE6yvjILn/Sb0ZdgphdDSQrDhU0dK2A/AFCrhE69mR39Zy1Day0H aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpqmvtk0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 15:00:55 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25EEt94W002214
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 15:00:54 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpqmvtjym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 15:00:54 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25EEodct027215;
        Tue, 14 Jun 2022 15:00:53 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3gmjp9chm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 15:00:52 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25EF0omp15204818
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jun 2022 15:00:50 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACCDA42049;
        Tue, 14 Jun 2022 15:00:50 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4038642045;
        Tue, 14 Jun 2022 15:00:50 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.3.94])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jun 2022 15:00:50 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 0/5] s390x: some migration tests and gcc12 support
Date:   Tue, 14 Jun 2022 17:00:44 +0200
Message-Id: <20220614150049.55787-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0w7FaW-ZM6Xk5vcxK9w8yFWIchgXVCWs
X-Proofpoint-ORIG-GUID: aMB6UBiBHxGOdf_UyvOG0JcbKLb0v3e-
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-14_05,2022-06-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=793 spamscore=0
 adultscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206140057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

please merge the following changes:
* support for gcc12
* cmm migration test
* storage key migration test

MERGE:
https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/33

PIPELINE:
https://gitlab.com/imbrenda/kvm-unit-tests/-/pipelines/563551059

PULL:
https://gitlab.com/imbrenda/kvm-unit-tests.git s390x-next-2022-06


Janis Schoetterl-Glausch (2):
  s390x: Introduce symbol for lowcore and use it
  s390x: Fix gcc 12 warning about array bounds

Nico Boehr (3):
  lib: s390x: add header for CMM related defines
  s390x: add cmm migration test
  s390x: add migration test for storage keys

 s390x/Makefile             |  2 +
 lib/s390x/asm/arch_def.h   |  2 +
 lib/s390x/asm/cmm.h        | 50 +++++++++++++++++++++++
 lib/s390x/asm/facility.h   |  4 +-
 lib/s390x/asm/mem.h        |  4 ++
 lib/s390x/css.h            |  2 -
 lib/s390x/css_lib.c        | 12 +++---
 lib/s390x/fault.c          | 10 ++---
 lib/s390x/interrupt.c      | 61 ++++++++++++++--------------
 lib/s390x/mmu.c            |  3 +-
 s390x/flat.lds             |  1 +
 s390x/snippets/c/flat.lds  |  1 +
 s390x/cmm.c                | 25 ++----------
 s390x/css.c                |  4 +-
 s390x/diag288.c            |  4 +-
 s390x/edat.c               |  5 +--
 s390x/emulator.c           | 15 ++++---
 s390x/migration-cmm.c      | 77 +++++++++++++++++++++++++++++++++++
 s390x/migration-skey.c     | 83 ++++++++++++++++++++++++++++++++++++++
 s390x/mvpg.c               |  7 ++--
 s390x/sclp.c               |  3 +-
 s390x/skey.c               |  2 +-
 s390x/skrf.c               | 11 ++---
 s390x/smp.c                | 23 +++++------
 s390x/snippets/c/spec_ex.c |  5 +--
 s390x/unittests.cfg        |  8 ++++
 26 files changed, 306 insertions(+), 118 deletions(-)
 create mode 100644 lib/s390x/asm/cmm.h
 create mode 100644 s390x/migration-cmm.c
 create mode 100644 s390x/migration-skey.c

-- 
2.36.1

