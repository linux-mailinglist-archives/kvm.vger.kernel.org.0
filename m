Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 512B665EA81
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 13:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbjAEMPu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 07:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233083AbjAEMPp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 07:15:45 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3928D559DE
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 04:15:45 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 305BLYxJ027816
        for <kvm@vger.kernel.org>; Thu, 5 Jan 2023 12:15:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=jZcMnKLNQtqV6hHoEgyFSBhpZM1VPhQWx4pHtMCLzEA=;
 b=mPg0PjtCoqRQzj2AUdu5AVwjmmTHuTRpW62iyC6VifvS5O9RAXLuNMMX+7C1bk37UCCj
 301+4+Vfag5Wj0EdAvzZsVtWn4A4BhC0EE4NHClDT50qnSri+VUd1eHr/WOGTJzMVUxR
 7MHxaXJkRU5DKnfaRNvXu1ojiJ+CTNHwRQuQlraf7KcOKGl+MS7iI4kF2Wgnbz2GtIeN
 4hlo7byARaUMnh+ecn0TDvm32WbJHlhcyN5KLWCynpyp6QipfrT0zO1n85nxpUD3pDSW
 2PorFT1Y2irRXqo77kimM/TAZVnp0S0e4zcHJZpPMdb9+zoLFrp+aNopmmTBasuS7+6l eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mwwky92rj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 12:15:44 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 305Bwmok031713
        for <kvm@vger.kernel.org>; Thu, 5 Jan 2023 12:15:44 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mwwky92qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 12:15:44 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3055BxdN020202;
        Thu, 5 Jan 2023 12:15:42 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3mtcq6er0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 12:15:41 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 305CFd9T20054346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Jan 2023 12:15:39 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53AC720049;
        Thu,  5 Jan 2023 12:15:39 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF6D120040;
        Thu,  5 Jan 2023 12:15:38 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.26.82])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  5 Jan 2023 12:15:38 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 0/4] s390x: storage key and CMM concurrent tests
Date:   Thu,  5 Jan 2023 13:15:34 +0100
Message-Id: <20230105121538.52008-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.39.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rx1GqDmq7Y_OzS7i00kqK0Yp3qoMwO0t
X-Proofpoint-GUID: rIxCTinHEiaDEEqLgKJrEvBeTm73SF1B
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_04,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=891
 suspectscore=0 mlxscore=0 impostorscore=0 bulkscore=0 adultscore=0
 phishscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2301050095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo and/or Thomas,


please merge the following changes:

* storage key and cmm concurrent migration test
* new utility macros for PSWs


MERGE: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/38

PIPELINE: https://gitlab.com/imbrenda/kvm-unit-tests/-/pipelines/739008304

PULL: https://gitlab.com/imbrenda/kvm-unit-tests.git s390x-next-2023-01

Claudio Imbrenda (2):
  lib: s390x: add PSW and PSW_WITH_CUR_MASK macros
  s390x: use the new PSW and PSW_WITH_CUR_MASK macros

Nico Boehr (2):
  s390x: add parallel skey migration test
  s390x: add CMM test during migration

 lib/s390x/asm/arch_def.h |   4 +
 s390x/adtl-status.c      |  24 +---
 s390x/firq.c             |   5 +-
 s390x/migration-cmm.c    | 258 ++++++++++++++++++++++++++++++++++-----
 s390x/migration-skey.c   | 218 ++++++++++++++++++++++++++++++---
 s390x/migration.c        |   6 +-
 s390x/skrf.c             |   7 +-
 s390x/smp.c              |  53 ++------
 s390x/uv-host.c          |   5 +-
 s390x/unittests.cfg      |  30 +++--
 10 files changed, 473 insertions(+), 137 deletions(-)

-- 
2.39.0

