Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A655A6297
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 13:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbiH3L4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 07:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiH3L4c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 07:56:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199C0D0753
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 04:56:30 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27UBoXq9009912
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 11:56:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=xwv/CxnEJwIATc4vhaRf6L3yQPzpLvVG/kajSRc9o3o=;
 b=iNVGyiQ91wRzGiHVBW6XApCkRcCnM1qTx1eC8l1j9qVsLr7RZWJbqNfs8uAbYhdlvVkB
 nMQYbYE3Tsba73v1WFOJayyeul7GE6GKm6YE9wI5uHvK1AfhjeFxscPZHl+2gUdHQuWI
 PSFq2oENJNgfkPLWvGU0xLHDP1neoX1U3jbk0F9bII2l7V89d00bvWU7m8ZxugtD4Xus
 ELSeKpzwosuPAqJH0F49omBJHpwbs+gP6pNKHbqDaVe9eWNAPbHcVduN711h3xhFC5v8
 7jDV6zoyxd09rjNOKpZRA/lOIhNRvx71z/llcJHHgaT3LKP252QsMN1eCiQfgBoDhAe2 Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j9j1hg410-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 11:56:29 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27UBpcYb016701
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 11:56:29 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j9j1hg3ys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 11:56:29 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27UBpW1D013041;
        Tue, 30 Aug 2022 11:56:26 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3j7aw8unux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 11:56:26 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27UBuNfU44302808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Aug 2022 11:56:23 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F43211C04C;
        Tue, 30 Aug 2022 11:56:23 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5560D11C04A;
        Tue, 30 Aug 2022 11:56:23 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Aug 2022 11:56:23 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 0/2] s390x: Add exit time test
Date:   Tue, 30 Aug 2022 13:56:21 +0200
Message-Id: <20220830115623.515981-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gTwIABSOVxnvvqFCydJDzD-NVnZSP4Qz
X-Proofpoint-GUID: CwVi6JtJw_ZLIa7Atn7pD00KuGhP2D2d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-30_06,2022-08-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=594 malwarescore=0 spamscore=0
 mlxscore=0 clxscore=1015 bulkscore=0 suspectscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208300057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sometimes, it is useful to measure the exit time of certain instructions
to e.g. identify performance regressions in instructions emulated by the
hypervisor.

This series adds a test which executes some instructions and measures
their execution time. Since their execution time depends a lot on the
environment at hand, all tests are reported as PASS currently.

The point of this series is not so much the instructions which have been
chosen here (but your ideas are welcome), but rather the general
question whether it makes sense to have a test like this in
kvm-unit-tests.

Nico Boehr (2):
  lib/s390x: time: add wrapper for stckf
  s390x: add exittime tests

 lib/s390x/asm/time.h |   9 ++
 s390x/Makefile       |   1 +
 s390x/exittime.c     | 258 +++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg  |   4 +
 4 files changed, 272 insertions(+)
 create mode 100644 s390x/exittime.c

-- 
2.36.1

