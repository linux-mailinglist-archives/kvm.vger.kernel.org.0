Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A31CF57DB22
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 09:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbiGVHUe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 03:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234381AbiGVHUd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 03:20:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD7513D01
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 00:20:32 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26M6jxoJ028334
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 07:20:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=we/tewrJ0bkWO24sKDKC3KhrVuVzIxaV9O4xtLL++TM=;
 b=Q66ZUw2LJj3tuHRbR+Hn/zz2o28yiLTwx/GiTz562RFkW83sBJoArFFASwbWGCBvGfo+
 9hWXliXE2oJtHN/Dj/ps91FYr1GdZWFLVCNCFuURFDQas42tVGJAoxpL3LX4wu7KrgPm
 FUL8nK22T8ctfDWyE1rCESCCVLWwpwvPWdwPW0wpH2fsBQ7K4F30Wpyz9pDhJf7i7cDQ
 0aGwXwfWknl4GMyeUmsnjRZ8b9H0Ay/+sSADkLiRAoOCNSRpaCuZkcL4+z4VuIMWmfjP
 VAC9q9B5ITNtUJBCEnPtAVF8Px/54KUQS1eGmIksL+jUrNfbHdZx7KCawUIT606yFmZc mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfpws0tfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 07:20:32 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26M6m8es009102
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 07:20:31 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfpws0te5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 07:20:31 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26M7JYX2030070;
        Fri, 22 Jul 2022 07:20:08 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3hbmy8p16h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 07:20:08 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26M7K5uF13435296
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jul 2022 07:20:05 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40F814C046;
        Fri, 22 Jul 2022 07:20:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01BC74C04A;
        Fri, 22 Jul 2022 07:20:05 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Jul 2022 07:20:04 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/3] s390x: add tests for SIGP call orders in enabled wait
Date:   Fri, 22 Jul 2022 09:20:01 +0200
Message-Id: <20220722072004.800792-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JGa-9NcU8o7ELGO76X74V14uUVVX7021
X-Proofpoint-ORIG-GUID: goFoL4eNO_F8NGoaHtZd1ZWtIoDHFtUo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_28,2022-07-21_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxlogscore=793
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207220029
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1->v2:
---
* rebase to latest master to align with Claudio's SMP changes, drop
  patch which adds the ext int clean up since it is already in Claudio's
  series
* make sure ctl0 register bit is cleared

When a CPU is in enabled wait, it can still receive SIGP calls from
other CPUs.

Since this requires some special handling in KVM, we should have tests
for it. This has already revealed a KVM bug with ecall under PV, which
is why this test currently fails there.

Some refactoring is done as part of this series to reduce code
duplication.

Nico Boehr (3):
  s390x: smp: move sigp calls with invalid cpu address to array
  s390x: smp: use an array for sigp calls
  s390x: smp: add tests for calls in wait state

 s390x/smp.c | 190 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 108 insertions(+), 82 deletions(-)

-- 
2.36.1

