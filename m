Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24646C7DE7
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 13:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbjCXMSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 08:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbjCXMSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 08:18:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADFD6A44
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 05:18:17 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OBoxPY022265
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=5wVFF2b7vPWfOAtiQ+7khtoeBG7igqP1BaciFWK+e/k=;
 b=Sahcl/FXOLQ600xGJbcKHAuG7stCJgTJ9D+WqrlNv+mUd5iSfAuVN5brCWBIAEvXlon/
 2945RGqjb11DQqWg/B7MZebaGjbE3jvwBoBj4mmWs4/bSREUShxo7nxK2PTBMuh+ZysB
 o7ImYPAw5rvTUA7acuk6T8NK4KK3FX4X0XUQI1Yb5npJX3HBlYkCZF/uONR6/ggFsdAT
 1+iPmizgtprAABFsAyDzPfVpI3AfxEfzu1t0ycgaFh7cUBNR1lvfjHldQ4fh8JkAbunu
 Tana9unT/TwwHBUlUlmLFs1Sc8oyWpriSSowVx6taT6gDg9NsQXNDeNJov4Uxfrw1//G ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3phbbr8myg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:17 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OC8q9S029170
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:16 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3phbbr8mxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:18:16 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NLuljo013860;
        Fri, 24 Mar 2023 12:18:14 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3pgy3s0t23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:18:14 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32OCIAqC32899622
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 12:18:10 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8FC172004D;
        Fri, 24 Mar 2023 12:18:10 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E47ED20067;
        Fri, 24 Mar 2023 12:18:09 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Mar 2023 12:18:09 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 3/9] s390x: Add PV tests to unittests.cfg
Date:   Fri, 24 Mar 2023 12:17:18 +0000
Message-Id: <20230324121724.1627-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230324121724.1627-1-frankja@linux.ibm.com>
References: <20230324121724.1627-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Cvp6gVwU_fYA5iTrKnDDZPyxUIF3CViM
X-Proofpoint-GUID: 79KsQKRw_i1CxRxP3pfgxQZxgnJQJfIM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_06,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 impostorscore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=899 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240099
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Even if the first thing those tests do is skipping they should still
be run to make sure the tests boots and the skipping works.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/unittests.cfg | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index d97eb5e9..e9271f9a 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -215,3 +215,20 @@ file = migration-skey.elf
 smp = 2
 groups = migration
 extra_params = -append '--parallel'
+
+[pv-diags]
+file = pv-diags.elf
+extra_params = -m 2200
+
+[pv-icptcode]
+file = pv-icptcode.elf
+extra_params = -m 2200 -smp 3
+
+[pv-ipl]
+file = pv-ipl.elf
+extra_params = -m 2200
+
+[uv-host]
+file = uv-host.elf
+extra_params = -m 2200 -smp 2
+
-- 
2.34.1

