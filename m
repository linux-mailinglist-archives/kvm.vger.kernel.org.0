Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B65357358C
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 13:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236139AbiGMLgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 07:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiGMLga (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 07:36:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111D683F2F;
        Wed, 13 Jul 2022 04:36:29 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26DBDp6t004356;
        Wed, 13 Jul 2022 11:36:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=TOeLsDmsEc5rPHtbvc9qsAc+DAC05ANRYEm87Uwvn/0=;
 b=OEv/kXOHLRsMCMoE0CgB9GZuw/s5qc9l/O5KnLRPYlTsNBJJq+08Oe1sgHfr5XXrEkHY
 xEzVYTrOicrUHWGFmcbCLZAccBeV1rI48NVI1yEzpvDoqt/aM2GnlLqrxhuRXqoLjgaa
 kRTwU0qcIFqOu+4qFcpPwDjw/LGUM0iJMj5NK6aGpr260aQl3RUd/nPcGdJMpQqt3e8o
 /nU3PyLqg/XIgtPgXBieKNpKhjTnlb2xs4FcEcD+R2sRXr/4PNf+H/iGHsTenoIDnPRY
 8qTtrOAYgf3yakibmAZcN7OSvzzGJXuGMOsClFHG1J05Yxz6Z5zwSPVsVUV77olFOE0j mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9w028gnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 11:36:28 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26DBFtcY009604;
        Wed, 13 Jul 2022 11:36:27 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9w028gku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 11:36:27 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26DBZrjM007108;
        Wed, 13 Jul 2022 11:36:25 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3h8ncngu83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 11:36:25 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26DBaMdP19726742
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jul 2022 11:36:22 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 530EC11C04C;
        Wed, 13 Jul 2022 11:36:22 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11E4B11C04A;
        Wed, 13 Jul 2022 11:36:22 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jul 2022 11:36:22 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 0/4] s390x: add tests for SIGP call orders in enabled wait
Date:   Wed, 13 Jul 2022 13:36:17 +0200
Message-Id: <20220713113621.14778-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uFom_E-wZ3OlcN4q4TO9aFcbAhxX9t2F
X-Proofpoint-ORIG-GUID: A6EDh088yeBSdhog90igWd3razCjq0Yp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_14,2022-07-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxlogscore=694 malwarescore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207130047
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a CPU is in enabled wait, it can still receive SIGP calls from
other CPUs.

Since this requires some special handling in KVM, we should have tests
for it. This has already revealed a KVM bug with ecall under PV, which
is why this test currently fails there.

Some refactoring is done as part of this series to reduce code
duplication.

Nico Boehr (4):
  lib: s390x: add cleanup function for external interrupts
  s390x: smp: move sigp calls with invalid cpu address to array
  s390x: smp: use an array for sigp calls
  s390x: smp: add tests for calls in wait state

 lib/s390x/asm/interrupt.h |   1 +
 lib/s390x/interrupt.c     |   9 ++
 s390x/smp.c               | 190 +++++++++++++++++++++-----------------
 3 files changed, 115 insertions(+), 85 deletions(-)

-- 
2.35.3

