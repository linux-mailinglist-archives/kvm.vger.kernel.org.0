Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C967A4E5709
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 18:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238031AbiCWRFE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 13:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235622AbiCWRFD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 13:05:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B40BF47;
        Wed, 23 Mar 2022 10:03:32 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NF6Tpt015654;
        Wed, 23 Mar 2022 17:03:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=8nxkMhs/LRNZND5IlgHAM7ntpYmHhl23UvZ2Due/Rbc=;
 b=oaenWQb8OIwBSQj0kV1fZv2rC/97Oye6fBM+rGGtlXaqfdzMrymznUmWoIpC7hp+cgR8
 c0+GfbAZKDf9e8sdMvbNUZrDxddcfqkUj0QuSP3YszYeC/5rMEHLbkXDq4coq0raDwtv
 +dfuSCRC0p0TacoIdEhD4rOxut9ZWBgDFoOFsoBQyYYttXIdcuKwWM4PddagJhxGKU1I
 W9UeNWDYSGRgUBPHc8FXPCjZklQ95cF/NoC/+VWO709NVOxDXOjxJ2l6O07VQrpiZVOp
 +VFB7X7Rw1V+9ciR3M5UQhx8Lfk8aBEbznHWoAEEwTJfu6NANaB4XwjVvXM52CKxsm50 rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f05wbapvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:32 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22NGx3D4001996;
        Wed, 23 Mar 2022 17:03:31 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f05wbapv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:31 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22NGx3iV011987;
        Wed, 23 Mar 2022 17:03:29 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3ew6ej13j6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:29 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22NH3QgM44761556
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Mar 2022 17:03:26 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C4204C04E;
        Wed, 23 Mar 2022 17:03:26 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C17254C040;
        Wed, 23 Mar 2022 17:03:25 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Mar 2022 17:03:25 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 0/9] s390x: Further extend instruction interception tests
Date:   Wed, 23 Mar 2022 18:03:16 +0100
Message-Id: <20220323170325.220848-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: D01V_IptXkDC-aFKk-QUNtFVlV8v2TWG
X-Proofpoint-ORIG-GUID: Yk9uFxAXFwim8S5syox-FN4XFaMObWbj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_07,2022-03-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 impostorscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 priorityscore=1501 adultscore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203230091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changelog from v1:
* check reserved fields in store adtl status (thanks Claudio)
* check all possible length codes for vector and gs store adtl status (thanks
  Claudio)
* store adtl status: fix run under TCG
* store adtl status: avoid 0 in vector reg 0, use a struct instead of offsets
  for the mcesa, add some comments (thanks Claudio)

Further extend the instruction interception tests for s390x. This series focuses
on SIGP, STSI and TPROT instructions.

Some instructions such as STSI already had some coverage and the existing tests
were extended to increase coverage.

The SIGP instruction has coverage, but not for all orders. Orders
STORE_ADTL_STATUS, SET_PREFIX and CONDITIONAL_EMERGENCY didn't
have coverage before and new tests are added. For EMERGENCY_SIGNAL, the existing
test is extended to cover an invalid CPU address. Additionally, new tests are
added for quite a few invalid arguments to SIGP.

TPROT was used in skrf tests, but only for storage keys, so add tests for the
other uses as well.

Nico Boehr (9):
  s390x: smp: add tests for several invalid SIGP orders
  s390x: smp: stop already stopped CPU
  s390x: gs: move to new header file
  s390x: smp: add test for SIGP_STORE_ADTL_STATUS order
  s390x: smp: add tests for SET_PREFIX
  s390x: smp: add test for EMERGENCY_SIGNAL with invalid CPU address
  s390x: smp: add tests for CONDITIONAL EMERGENCY
  s390x: add TPROT tests
  s390x: stsi: check zero and ignored bits in r0 and r1

 lib/s390x/gs.h      |  80 +++++++
 s390x/Makefile      |   1 +
 s390x/gs.c          |  65 +-----
 s390x/smp.c         | 519 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/stsi.c        |  42 +++-
 s390x/tprot.c       | 108 +++++++++
 s390x/unittests.cfg |  25 ++-
 7 files changed, 765 insertions(+), 75 deletions(-)
 create mode 100644 lib/s390x/gs.h
 create mode 100644 s390x/tprot.c

-- 
2.31.1

