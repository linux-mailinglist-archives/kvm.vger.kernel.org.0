Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49BE2717D41
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 12:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbjEaKhY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 06:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbjEaKhQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 06:37:16 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF41BB3;
        Wed, 31 May 2023 03:37:15 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34V9b6wr028808;
        Wed, 31 May 2023 10:37:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=bKeT5GTqgF+vsiHsWxnmPry5jfAZQAR6idVy2R86zlU=;
 b=WwytYHzRVWhaj+/5kjkBDHFKNm2hxR9udN8w28dJPReu3dxBvMFFvRrO/BYnzX3833VV
 Cjyj/o4Va8cp8EKGTkDTBNM/7AWqbvoB/MNu06X2FFafLycrmSbIAnx6EkR4nyz2138r
 u4j2+G066ytvs96f4acKhbbD/55kwYS3rBJUFg9qlSyG4ev0xZYNTLREh6uLwH1bYG/e
 2RsGNI13GnKoH0eIX+TX8SyK2+msJBswv3CbureO6EDT7yu7ehTm6sdtuZqBcbZRC/as
 v0RFg9VH6yzBnzOMUyh+oa/l6WskPOL41IT582p5fKV7/kMMXBRmVrobWbP75Yfw9IjX GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwjvftvta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 10:37:12 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34VAa8EX023460;
        Wed, 31 May 2023 10:37:12 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwjvfttq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 10:37:12 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34V48EEL008758;
        Wed, 31 May 2023 10:32:32 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3qu94e9mea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 10:32:31 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34VAWSmg46072484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 May 2023 10:32:28 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 644FC2004B;
        Wed, 31 May 2023 10:32:28 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D3CB20040;
        Wed, 31 May 2023 10:32:28 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 31 May 2023 10:32:27 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com, andrew.jones@linux.dev, david@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1] runtime: don't run pv-host tests when gen-se-header is unavailable
Date:   Wed, 31 May 2023 12:32:27 +0200
Message-Id: <20230531103227.1385324-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WUJ_iLDaQOT9q3gQKkHIuEHYtHeaFc0Y
X-Proofpoint-GUID: GPALIMW6yYBsieCiJHCI1gCGP4gCCz9y
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_06,2023-05-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 suspectscore=0
 mlxlogscore=999 adultscore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 mlxscore=0 impostorscore=0 phishscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305310092
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

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 scripts/runtime.bash | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 07b62b0e1fe7..486dbeda8179 100644
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
2.39.1

