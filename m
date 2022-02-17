Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44FAF4BA314
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 15:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241772AbiBQOf7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 09:35:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241939AbiBQOfl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 09:35:41 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2152B1A92
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 06:35:24 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21HC9K2Z005478
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 14:35:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=10fAhm8dXrpq2JyUULON8gI1QP3F+MYegBwrxAsZ368=;
 b=l1O1ALwqDAupZrL79UD+VLSr2Zn5P7linD5qlkRUQBbJ27LCeWjfQKY7y9WXbd2wc34N
 v0gTxCM4JPxU9GnVrPT0/v+BbhSctQ6QMqm3O0bTBsE9XpTGjf6dATCN3g1hXDZRDR/1
 uOBGwlSBaueIoB6PDm7uIAWVArBTYZKtnGMnqxLu6GKemhlrOLoSmVIAKokhMCl8ztAW
 m3GQOYEG/bnHmrdTBgSw4EW3N6zVhx0yindgZ+m+nYSDOLgL12mb6jukFVHAUcST5OCO
 scUMdlas2/vLgI+F0auTbQ8S/+2uXEKQbXls47Ir0hfatakGR1j+26fYbNOY0Etnlh7W /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e9nr5kst8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 14:35:24 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21HCWhuY022080
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 14:35:24 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e9nr5ksse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 14:35:24 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21HEXIGW022246;
        Thu, 17 Feb 2022 14:35:21 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3e64hah582-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 14:35:21 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21HEZD4g37552428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 14:35:13 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 260CB42041;
        Thu, 17 Feb 2022 14:35:13 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9FE14204B;
        Thu, 17 Feb 2022 14:35:12 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.2.54])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Feb 2022 14:35:12 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 0/9] s390x: smp lib improvements and more
Date:   Thu, 17 Feb 2022 15:34:55 +0100
Message-Id: <20220217143504.232688-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LHrNqM6u76ZdZRwqHSNOvj2inYcbYiEQ
X-Proofpoint-GUID: jFaVlgSdPNdpsd8ErI1FJ2dfd5Nf3Fnh
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_05,2022-02-17_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 phishscore=0
 adultscore=0 mlxlogscore=907 priorityscore=1501 mlxscore=0 bulkscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202170066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

please merge the following changes:
* SMP lib improvements to increase correctness of SMP tests
* fix some tests so that each test has a unique output line
* add a few function to detect the hypervisor
* rename some macros to bring them in line with the kernel

MERGE:
https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/25

PIPELINE:
https://gitlab.com/imbrenda/kvm-unit-tests/-/pipelines/473371669

PULL:
https://gitlab.com/imbrenda/kvm-unit-tests.git s390x-next-20220217

Christian Borntraeger (1):
  s390x/cpumodel: give each test a unique output line

Claudio Imbrenda (6):
  s390x: firq: fix running in PV
  lib: s390x: smp: guarantee that boot CPU has index 0
  lib: s390x: smp: refactor smp functions to accept indexes
  s390x: smp: use CPU indexes instead of addresses
  s390x: firq: use CPU indexes instead of addresses
  s390x: skrf: use CPU indexes instead of addresses

Janosch Frank (1):
  s390x: uv: Fix UVC cmd prepare reset name

Pierre Morel (1):
  s390x: stsi: Define vm_is_kvm to be used in different tests

 lib/s390x/asm/uv.h  |   4 +-
 lib/s390x/smp.h     |  20 +++--
 lib/s390x/stsi.h    |  32 ++++++++
 lib/s390x/vm.h      |   2 +
 lib/s390x/smp.c     | 173 +++++++++++++++++++++++++++-----------------
 lib/s390x/vm.c      |  51 ++++++++++++-
 s390x/cpumodel.c    |   5 +-
 s390x/firq.c        |  26 ++-----
 s390x/skrf.c        |   2 +-
 s390x/smp.c         |  22 +++---
 s390x/stsi.c        |  23 +-----
 s390x/uv-guest.c    |   2 +-
 s390x/uv-host.c     |   2 +-
 s390x/unittests.cfg |  18 ++++-
 14 files changed, 243 insertions(+), 139 deletions(-)
 create mode 100644 lib/s390x/stsi.h

-- 
2.34.1

