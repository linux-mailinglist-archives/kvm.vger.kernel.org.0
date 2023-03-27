Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292FE6C9D8F
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 10:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbjC0IVh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 04:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbjC0IV2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 04:21:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D5835A9;
        Mon, 27 Mar 2023 01:21:27 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32R6Sddu025649;
        Mon, 27 Mar 2023 08:21:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=qiaJnmg33mrt03scm2Qrkwu7WuUufyYh7x5n51F0o7I=;
 b=nxylrYcSUmpxy4ZOTu6M4LMpj5RbPJ8AQCVhw2nQ8luEKVx7YKMHiiEmkXAYYWhRm9jQ
 f5fytQx+02b3eDPGtRkF8gW1Ziv1OaI8LkKfxxv/dOVX0X3x+QLC+/JnMoDH3cVcLzfv
 LtT1OFZvJRyox8ci1ExwPbfnwSET8YJiTdpmL12uzIKIKErejrrDLyiCZT/U+x0t7kSV
 GOUj2kfvAQ2JpDNohqKpwou453aTCoKtWF4Fe7XFqqC4d1T42kf5jzwTAC0/CgdlyXlv
 RuAEktfBCwrfznLxkuabBCBuhb9l/Lid2Rbo6KjEv/DTR+hppDgmtOd5Gop6XSDG869x GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pjadkt01t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Mar 2023 08:21:26 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32R8LPwX014597;
        Mon, 27 Mar 2023 08:21:25 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pjadkt00n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Mar 2023 08:21:25 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32R279Cw024202;
        Mon, 27 Mar 2023 08:21:22 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3phrk6j5mj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Mar 2023 08:21:22 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32R8LIBH6488688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 08:21:19 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E22A52004D;
        Mon, 27 Mar 2023 08:21:18 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1C8F2004B;
        Mon, 27 Mar 2023 08:21:18 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 27 Mar 2023 08:21:18 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 0/4] s390x: Add support for running guests without MSO/MSL
Date:   Mon, 27 Mar 2023 10:21:14 +0200
Message-Id: <20230327082118.2177-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: R4FDButajGpYu_SnXbN81jxyY3dCX4i_
X-Proofpoint-ORIG-GUID: 6T0LH9Lb6QXltKxgUk7n7U8jZXha666v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=342 clxscore=1015 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303270065
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Right now, all SIE tests in kvm-unit-tests (i.e. where kvm-unit-test is the
hypervisor) run using MSO/MSL.

This is convenient, because it's simple. But it also comes with
disadvantages, for example some features are unavailabe with MSO/MSL.

This series adds support for running guests without MSO/MSL with dedicated
guest page tables for the GPA->HPA translation.

Since SIE implicitly uses the primary space mode for the guest, the host
can't run in the primary space mode, too. To avoid moving all tests to the
home space mode, only switch to home space mode when it is actually needed.

This series also comes with various bugfixes that were caught while
develoing this.

Nico Boehr (4):
  s390x: sie: switch to home space mode before entering SIE
  s390x: lib: don't forward PSW when handling exception in SIE
  s390x: lib: sie: don't reenter SIE on pgm int
  s390x: add a test for SIE without MSO/MSL

 lib/s390x/asm/arch_def.h   |   2 +
 lib/s390x/interrupt.c      |   7 +++
 lib/s390x/sie.c            |  36 ++++++++++-
 lib/s390x/sie.h            |   2 +
 s390x/Makefile             |   2 +
 s390x/sie-dat.c            | 121 +++++++++++++++++++++++++++++++++++++
 s390x/snippets/c/sie-dat.c |  58 ++++++++++++++++++
 s390x/unittests.cfg        |   3 +
 8 files changed, 230 insertions(+), 1 deletion(-)
 create mode 100644 s390x/sie-dat.c
 create mode 100644 s390x/snippets/c/sie-dat.c

-- 
2.39.1

