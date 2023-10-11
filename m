Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 376F77C4DC8
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 10:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345753AbjJKI5C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 04:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345642AbjJKI47 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 04:56:59 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3F2B9;
        Wed, 11 Oct 2023 01:56:57 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39B8srlu020451;
        Wed, 11 Oct 2023 08:56:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=4/mmlVY23hNd4XObcfWjmPpJJofa3FfeI+lgw7ei5iM=;
 b=LkMyNfmnfoyhE45Pl3cuz7jX0YijAfmyyMEbYh4nX4qeZWyP+fjgTw8tGIKzTwiCOTVS
 nLyU5h/ZCQrB55Sj65be0ptbX1bfGRVuDBaEsEU/+RI5Ls14S+wHlylLaIBMdoXHx/tR
 lECyul4CbLPI2bauEUPwdlrLmXM7sxElQZfNFuAYyxUgkeWugFA1mwgO7+Vc6QTSMBOt
 Twk2dRXqBH9ui9xsM8x/fNUnj/iFmq7VLr+D+NOmo/D7OGdd5lfmlQCmbhc6tobSPuQP
 ksd7ZZCgXVmaoj+2x7iu7QnUl7voeyd9WnBtkj/kVGUwDoVwt5gS1iXJNnpRiVnVsWpc eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tnrkw01e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 08:56:43 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39B8uXAR025398;
        Wed, 11 Oct 2023 08:56:43 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tnrkw01dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 08:56:42 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39B7i78f028188;
        Wed, 11 Oct 2023 08:56:42 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tkj1y72hj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 08:56:42 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39B8udXq24511116
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Oct 2023 08:56:39 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1640920043;
        Wed, 11 Oct 2023 08:56:39 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C423220040;
        Wed, 11 Oct 2023 08:56:38 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 11 Oct 2023 08:56:38 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Andrew Jones <andrew.jones@linux.dev>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Colton Lewis <coltonlewis@google.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Shaoqin Huang <shahuang@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH 0/9] s390x: topology: Fixes and extension
Date:   Wed, 11 Oct 2023 10:56:23 +0200
Message-Id: <20231011085635.1996346-1-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Q3oACzEB_lb_3bI9679V7T1F_NX8DeDt
X-Proofpoint-GUID: dkvVxc7dGEYnYdJZ7Ea536c2xuBmWIHG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-11_06,2023-10-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 impostorscore=0
 mlxscore=0 spamscore=0 clxscore=1011 suspectscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310110077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a number of issues as well as rewrite and extend the topology list
checking.
Add a test case with a complex topology configuration.
In order to keep the unittests.cfg file readable, implement multiline
strings for extra_params.

Nina Schoetterl-Glausch (9):
  s390x: topology: Fix report message
  s390x: topology: Use parameter in stsi_get_sysib
  s390x: topology: Fix parsing loop
  s390x: topology: Don't use non unique message
  s390x: topology: Refine stsi header test
  s390x: topology: Rename topology_core to topology_cpu
  s390x: topology: Rewrite topology list test
  scripts: Implement multiline strings for extra_params
  s390x: topology: Add complex topology test

 scripts/common.bash  |  11 +++
 scripts/runtime.bash |   4 +-
 lib/s390x/stsi.h     |  36 ++++---
 s390x/topology.c     | 228 ++++++++++++++++++++++++++-----------------
 s390x/unittests.cfg  | 133 +++++++++++++++++++++++++
 5 files changed, 303 insertions(+), 109 deletions(-)


base-commit: 09e8c119b4cd7b615ea0ece16c92c79054dfb38d
-- 
2.41.0

