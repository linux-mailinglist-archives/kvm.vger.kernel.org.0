Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2DCC74F18C
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 16:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbjGKORA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 10:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232635AbjGKOQ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 10:16:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C090F1701
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 07:16:40 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BDlcFO027045;
        Tue, 11 Jul 2023 14:16:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=gM4I86yYwBWAsKizR4IoxK1mTOaXSZVBWaAqCofz4yI=;
 b=ZHjsO1wa5VeHW+/acR5O+eQ4Uq4rqAUmGHQLxqpsS+0N3DKowVbpAgaQglHFhVMLc+u3
 HQE1dGfsx9+35AAJl1W4st/f33i2MOaKvSq7rykWv9G6rSM2pHNwPB8YrpS6ZKK/Ad21
 HfEgzBX2U5jP1743SvDQJtKPq6pl1tuD4cnHTSxb1dc7v/szJWgsOBMctDuKr7wq+W9R
 jKzo1xeas8fUnEbgNgcFVA8AfZn7aPvzbxuPgk4gHAbFnh65zGw4QOiX60ijtR22PQJS
 R9hG2VggW0Oc0QweiiAa4uzQtgmq10bUNFmLcdk84iHWPulOiFAL/7ATVsF0+0Swpg3L +g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs89a13eb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:29 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36BDnRQI031728;
        Tue, 11 Jul 2023 14:16:18 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs89a13c8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:18 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36B902cd016714;
        Tue, 11 Jul 2023 14:16:14 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3rpy2e9cd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:14 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36BEGBtk41026074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 14:16:11 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4471C2004E;
        Tue, 11 Jul 2023 14:16:11 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6FDB2004D;
        Tue, 11 Jul 2023 14:16:10 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.51.229])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jul 2023 14:16:10 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [PATCH 02/22] runtime: don't run pv-host tests when gen-se-header is unavailable
Date:   Tue, 11 Jul 2023 16:15:35 +0200
Message-ID: <20230711141607.40742-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230711141607.40742-1-nrb@linux.ibm.com>
References: <20230711141607.40742-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5D2hKde5t4gBwApfh_mqddPQEnctb5nF
X-Proofpoint-ORIG-GUID: PaHYSJZ-q92PsNMLyM6UNGmftTsWWGqx
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_08,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 mlxscore=0 impostorscore=0 clxscore=1015 mlxlogscore=991
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the gen-se-header tool is not given as an argument to configure,
all tests which act as a PV host will not be built by the makefiles.

run_tests.sh will fail when a test binary is missing. This means
when we add the pv-host tests to unittest.cfg we will have FAILs when
gen-se-header is missing.

Since it is desirable to have the tests in unittest.cfg, add a new group
pv-host which designates tests that act as a PV host. These will only
run if the gen-se-header tool is available.

The pv-host group is currently not used, but will be with Janoschs
series "s390x: Add PV SIE intercepts and ipl tests" here:
https://lore.kernel.org/all/20230502115931.86280-1-frankja@linux.ibm.com/

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 scripts/runtime.bash | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 54f8ade..0a87aac 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -98,6 +98,11 @@ function run()
         return
     fi
 
+    if [ -z "$GEN_SE_HEADER" ] && find_word "pv-host" "$groups"; then
+        print_result "SKIP" $testname "" "no gen-se-header available for pv-host test"
+        return
+    fi
+
     if [ -z "$only_group" ] && find_word nodefault "$groups" &&
             skip_nodefault; then
         print_result "SKIP" $testname "" "test marked as manual run only"
-- 
2.41.0

