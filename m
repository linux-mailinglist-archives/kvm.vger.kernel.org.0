Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8366606057
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 14:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiJTMhO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 08:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiJTMhH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 08:37:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A361495E4
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 05:36:58 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29KCRxMM021072
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 12:36:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=jddIxnfJphxBnJscy9w+vUXf+UgvDgQ2IeIRr3nSCCc=;
 b=sThD1ROqjHMahfnltTihxS46aFFka4//jji4wBZATEQGaM1UE3/Lh97uS7wvAwzKpv5n
 TzJE7pIMCo2dBqQWEi80CB1XV4dj4u6QVpLrNq3xFHm00LnTXh9/uiJdj30IhZ4cXrtN
 AfVUvCR0VsuzmXFSr7iOB+HUiqJJZi7Jpz56uNpqUb65xlO7+hStv2R6Tfd0UBmgr3g6
 mPDyKiKuaEvXKGgz10kxTE16VSk/5TOk3FS4SDNkkqUbO2tDPLe9UvL0foEqRsLeuzwJ
 0/Hd9/Z9sUTJF6HRmXUj598WPV8ypjziYI+qyq83C3MXbgol8PnVdjRRWTzSxp9mY1sX Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb6c3g8b4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 12:36:56 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29KCWakg006753
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 12:36:56 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb6c3g897-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 12:36:56 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29KCMnGW017319;
        Thu, 20 Oct 2022 12:31:54 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3k99fn46g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 12:31:54 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29KCVpdw45351388
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 12:31:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 535F842042;
        Thu, 20 Oct 2022 12:31:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED3DC42041;
        Thu, 20 Oct 2022 12:31:50 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.8.239])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 12:31:50 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/2] s390x misc fixes
Date:   Thu, 20 Oct 2022 14:31:41 +0200
Message-Id: <20221020123143.213778-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ehd4drDPBA9ByO33wh5NPTFqcMUcAfOG
X-Proofpoint-ORIG-GUID: azqz1X9ouoUZbshW21GBEgPZ_c_HVc5e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_04,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 impostorscore=0 clxscore=1015 adultscore=0
 bulkscore=0 spamscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=644 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210200074
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two unrelated misc fixes for s390x:

* abort immediately and without printing anything if a program interrupt is
  received inside an interrupt handler
* fix the uv-host test so that it allocates UV memory properly

v1->v2
* set the flag to abort immediately also during program interrupts

Claudio Imbrenda (2):
  lib: s390x: terminate if PGM interrupt in interrupt handler
  s390x: uv-host: fix allocation of UV memory

 lib/s390x/asm/arch_def.h | 11 +++++++++++
 lib/s390x/interrupt.c    | 20 ++++++++++++++++----
 s390x/uv-host.c          |  2 +-
 3 files changed, 28 insertions(+), 5 deletions(-)

-- 
2.37.3

