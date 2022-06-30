Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2AFB56192C
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 13:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235075AbiF3LbJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 07:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235036AbiF3LbH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 07:31:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B37951B33;
        Thu, 30 Jun 2022 04:31:06 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25UBButd036425;
        Thu, 30 Jun 2022 11:31:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=8COJDVceVWD+6s0g2Q2/h/NnO6X+leeuP+A4VvEKdDU=;
 b=YSaUjkZw4r2ZuX08RItufTEZaAGIhQKB8g9E2rIMdzxFhg/5DgXP6SqhDDe+uqmi51q6
 eOhYWkp2hOBVQ/aBysN/y4X1E/MirEIhjO6WXQLtvdVrq39LP+vfEl+BAccsinZAe6Ij
 bQV0m7idgVopEUCnkhMhHLhsP5xQVJpZIEm7/6A3xYClib2t3vAN6zkycXv8F+xUMa36
 us7T75m9MlzWSnFhVDM32p5wWRXCmB4+62229kAbcI4UBxbBejemwmJxKQSQvLXclb5x
 T4uXDUM3eQ+ijJLmC/hnl616jLxWKVu8Muw9Su7Eq93hE4frSol2MwtBFSjcsRMm83m+ oA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1ar6gg3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 11:31:05 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25UBTDcn024405;
        Thu, 30 Jun 2022 11:31:05 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1ar6gg2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 11:31:05 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25UBLOJP013483;
        Thu, 30 Jun 2022 11:31:02 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3gwsmj8219-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 11:31:02 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25UBV7wc23462240
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jun 2022 11:31:07 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95BB7A405F;
        Thu, 30 Jun 2022 11:30:59 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51E8FA405B;
        Thu, 30 Jun 2022 11:30:59 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Jun 2022 11:30:59 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 0/3] Add panic test support
Date:   Thu, 30 Jun 2022 13:30:56 +0200
Message-Id: <20220630113059.229221-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4qoX4p2MPQGDTWWaRqb6Zr7csyZ4wIkg
X-Proofpoint-ORIG-GUID: Ukqc5w3_PSaoqZEwc8ghIx81JvIEAXsG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_07,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=637 suspectscore=0 mlxscore=0 phishscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206300045
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QEMU suports a guest state "guest-panicked" which indicates something in
the guest went wrong, for example on s390x, when an external interrupt
loop was triggered.

Since the guest does not continue to run when it is in the
guest-panicked state, it is currently impossible to write panicking
tests in kvm-unit-tests. Support from the runtime is needed to check
that the guest enters the guest-panicked state.

This series adds the required support to the runtime together with two
tests for s390x which cause guest panics.

Nico Boehr (3):
  runtime: add support for panic tests
  s390x: add extint loop test
  s390x: add pgm spec interrupt loop test

 s390x/Makefile        |  2 ++
 s390x/extint-loop.c   | 64 +++++++++++++++++++++++++++++++++++++++++++
 s390x/pgmint-loop.c   | 46 +++++++++++++++++++++++++++++++
 s390x/run             |  2 +-
 s390x/unittests.cfg   |  8 ++++++
 scripts/arch-run.bash | 47 +++++++++++++++++++++++++++++++
 scripts/runtime.bash  |  3 ++
 7 files changed, 171 insertions(+), 1 deletion(-)
 create mode 100644 s390x/extint-loop.c
 create mode 100644 s390x/pgmint-loop.c

-- 
2.36.1

