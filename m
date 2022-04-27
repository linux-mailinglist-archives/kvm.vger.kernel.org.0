Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70393511617
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 13:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiD0KvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 06:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiD0Ku5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 06:50:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED4036F8FC;
        Wed, 27 Apr 2022 03:22:01 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23R9I9ur006226;
        Wed, 27 Apr 2022 10:06:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=g57swWEwSmnDaunZdxJSa+YeJLTvtIVV67cUUIz54js=;
 b=HWsjKRvvWgQMZQH60rKUgR64Duernte3hOBtVBNfsGNrt5ybyLGxAfGUbvrYho1sAX+7
 Gb6vCvT/cYlFSYb2vBXnj5CLhSB12EO27hJQ0/Vo/WwceRFIMum7iocehEPct81R85aB
 0fyPizkGXcp9y528yIDkwQWnamzWWHd+HETbEwX5EPIMpEA8JjUojUpiemuyNKGCBmM3
 ZqsxgZ5tNKiUms46b96ix/OX7bmcSE3hMg08Wepkk/VOb4ahsHonmxnQR2JchUUP1svG
 /JCf+syW3Ps6XMyFA4I4docOuAMFUVY6T8TfO1yckliedQy/ajK8eaImkxzjOyDzWcYW rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpv1eg10s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 10:06:20 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23RA0B0h011772;
        Wed, 27 Apr 2022 10:06:20 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpv1eg0yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 10:06:20 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23R9x49L001960;
        Wed, 27 Apr 2022 10:06:17 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3fm938vhmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 10:06:17 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23RA6ECv43778372
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 10:06:14 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DDBEAE051;
        Wed, 27 Apr 2022 10:06:14 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47DC2AE045;
        Wed, 27 Apr 2022 10:06:14 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 27 Apr 2022 10:06:14 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v6 3/3] Disable s390x skey test in GitLab CI
Date:   Wed, 27 Apr 2022 12:06:11 +0200
Message-Id: <20220427100611.2119860-4-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220427100611.2119860-1-scgl@linux.ibm.com>
References: <20220427100611.2119860-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: adFsucntXGyo1wmM-1-iUYpXg7M_cOTz
X-Proofpoint-GUID: kJiXm_MAAiS2HIdsJu1nS6y0ED58AbOb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-27_03,2022-04-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 clxscore=1015 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204270067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The test cases newly added to skey.c require kernel 5.18.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 .gitlab-ci.yml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 4f3049d8..e5768f1d 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -166,7 +166,7 @@ s390x-kvm:
   - ./configure --arch=s390x
   - make -j$(nproc)
   - ACCEL=kvm ./run_tests.sh
-      selftest-setup intercept emulator sieve sthyi skey diag10 diag308 pfmf
+      selftest-setup intercept emulator sieve sthyi diag10 diag308 pfmf
       cmm vector gs iep cpumodel diag288 stsi sclp-1g sclp-3g css skrf sie
       | tee results.txt
   - grep -q PASS results.txt && ! grep -q FAIL results.txt
-- 
2.33.1

