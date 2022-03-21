Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B8E4E242C
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 11:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346270AbiCUKUo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 06:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346219AbiCUKUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 06:20:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3AC32A249;
        Mon, 21 Mar 2022 03:19:11 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22L9fxaE002656;
        Mon, 21 Mar 2022 10:19:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=aAgt471lXsfSn4erfRqj/lNsapYn8Umi6CYHvKKEo8Q=;
 b=IEJW6+rSNL4PlU372bdSnArsq/08CRIo1cd/UQAhLduwJU+1q0d13rWvoQv51+9n+w47
 IGG2R1JsoKMJvarF5k4XCtjFXFaIfwQvY0njtOe+1sqdz65zrIFLoq5Od3RcHlHwQo0l
 BLYYmK9bcairEFHTROmJ12cJ8C9dvpWbscPlFZwdoLS700ECSAtRU0GriPPGGYTQVoRq
 mvbPq71xCNNc6dh4jTNFd9zqQ6ylipcKbqhoJRLGpkTdH9XSKrX5hgZ5ngjhXCiXY32g
 eYAKfrnGJu1lj4Cip5N9UPZ2sCAhaohg3JqjXM83yVjoWWCuUKXI6vH0yaRztpbwbWPY 6g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3expy08pcx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:10 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22LA3vvK016974;
        Mon, 21 Mar 2022 10:19:10 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3expy08pcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:10 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22LACXSN012490;
        Mon, 21 Mar 2022 10:19:08 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3ew6t8k3ax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:08 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22LA7Q2S5964170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 10:07:26 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 179B411C04A;
        Mon, 21 Mar 2022 10:19:05 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C43DC11C04C;
        Mon, 21 Mar 2022 10:19:04 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Mar 2022 10:19:04 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 0/9] s390x: Further extend instruction interception tests
Date:   Mon, 21 Mar 2022 11:18:55 +0100
Message-Id: <20220321101904.387640-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ytmcmc_XhfJCYmIKP6-XgKyaKmk4g4e5
X-Proofpoint-GUID: hWZflxI5KmCZXxv8ZXriL3NGQrEYV_-Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_04,2022-03-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxscore=0 mlxlogscore=636 phishscore=0 impostorscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

 lib/s390x/gs.h      |  80 ++++++++
 s390x/Makefile      |   1 +
 s390x/gs.c          |  65 +------
 s390x/smp.c         | 437 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/stsi.c        |  42 ++++-
 s390x/tprot.c       | 108 +++++++++++
 s390x/unittests.cfg |   9 +
 7 files changed, 668 insertions(+), 74 deletions(-)
 create mode 100644 lib/s390x/gs.h
 create mode 100644 s390x/tprot.c

-- 
2.31.1

