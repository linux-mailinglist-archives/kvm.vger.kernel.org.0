Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE845A9B46
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 17:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbiIAPKL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 11:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbiIAPKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 11:10:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4FD1262D
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 08:10:02 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 281Effvt023294
        for <kvm@vger.kernel.org>; Thu, 1 Sep 2022 15:10:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=ASIUTAS+5jc99nL950Hy73iAd4VTvfx7RAZVgUZd0QU=;
 b=UGnvsnes12itIlCC3yeBk/hTg3s8evThfQ401dFQGG7e1sc5by2vPEW40nZF5DJDIb+F
 i38w+RT3N9eeF4WMdw389F2gLYq+Shuvj7kferP1bTflLL4xyEDiAJuJv23nIr6f1GLl
 T4NKI3/yobShwVZqmYJAUX9MiQEEiK90O7oIjWcb0HdMHr/hwMmDAov03qu1N/4+fVwH
 Zfqs/d1Z5MZbFcFD6fPySrZHvQDoEzz6CGajt7OmVPkYCTlrS7V9OWX5b+YAPRvQIfhd
 5IoyP63WTmPJlzkOUCcp0ngt3ZtCRT0QMljLpoZFzc7yp5n6B4imbJP+D9tlsPkSt1XN Zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jaxqp99mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 15:10:02 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 281Eguuk028392
        for <kvm@vger.kernel.org>; Thu, 1 Sep 2022 15:10:02 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jaxqp99jg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Sep 2022 15:10:01 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 281F5ioi004348;
        Thu, 1 Sep 2022 15:09:59 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3j7aw8xy2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Sep 2022 15:09:59 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 281F9uKj39846190
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Sep 2022 15:09:56 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DE5AAE053;
        Thu,  1 Sep 2022 15:09:56 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 421FDAE04D;
        Thu,  1 Sep 2022 15:09:56 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Sep 2022 15:09:56 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/2] s390x: Add exit time test
Date:   Thu,  1 Sep 2022 17:09:54 +0200
Message-Id: <20220901150956.1075828-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bi0ArO36cdGOo5mSGXBaRtkgm1GEGeGm
X-Proofpoint-ORIG-GUID: 3j6qYm0OLoXhDrHRDLmayqQK9U0JsckM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_10,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 adultscore=0 mlxscore=0 phishscore=0 spamscore=0 bulkscore=0
 mlxlogscore=652 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2209010068
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1->v2:
---
* add missing cc clobber, fix constraints for get_clock_us() (thanks
  Thomas)
* avoid array and use pointer to const char* (thanks Thomas)
* add comment why testing nop makes sense (thanks Thomas)
* rework constraints and clobbers (thanks Thomas)

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

 lib/s390x/asm/time.h |  11 +-
 s390x/Makefile       |   1 +
 s390x/exittime.c     | 255 +++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg  |   4 +
 4 files changed, 270 insertions(+), 1 deletion(-)
 create mode 100644 s390x/exittime.c

-- 
2.36.1

