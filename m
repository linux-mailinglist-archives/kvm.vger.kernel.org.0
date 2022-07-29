Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE94C584D59
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 10:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234869AbiG2I2U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 04:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235640AbiG2I2F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 04:28:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEC083206
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 01:27:19 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26T8IjdN027654
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 08:27:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=AHeR5+dpWE7fp+ZIdF4DGTiQnrFeIceriJqfUkXFPsU=;
 b=Rh8ob93+WSwev40d0Fm4oiEdYNAOtjXZqwg5lvV2kL16W9eUb2WNZ3cCD14ZlbOdETm5
 UO7xSq9VCAJrgep25koOCVgQf9tjrQorzP6LPqVn5ldK6AtymMGfTHh9OEWz5M4i8fwe
 HRbb2eqyrqtGLhTzbJhT2gDekFxp5cvk5pAZ61HKdcIRRsXNxrk/3o4rQv+hgMeJnMS2
 eM1ewSASZrThfq4ygHMEb0Wa8S3IbpT2yZLNGlQDIeAFAxTq36MS3hlfrhn2BRVCyKr/
 axbPg4CRyuV+gax4VisZP/1gz2ubPrMMvGhYi17jpKF0rnXhSVjc4UWDZgSp98k9AhST pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hmbx7g61p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 08:27:18 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26T8JEtv028556
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 08:27:18 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hmbx7g60r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Jul 2022 08:27:18 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26T8NqVd027104;
        Fri, 29 Jul 2022 08:27:15 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3hg98fjk7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Jul 2022 08:27:15 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26T8RC4I26739070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jul 2022 08:27:12 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8ED555204F;
        Fri, 29 Jul 2022 08:27:12 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id D5F515204E;
        Fri, 29 Jul 2022 08:27:11 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH 2/6] s390x: MAKEFILE: Use $< instead of pathsubst
Date:   Fri, 29 Jul 2022 08:26:29 +0000
Message-Id: <20220729082633.277240-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220729082633.277240-1-frankja@linux.ibm.com>
References: <20220729082633.277240-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kwD6VvZJHZz4N3y4m1wDJJpJQhhLkq4L
X-Proofpoint-ORIG-GUID: 3VqdrE2AfVsOt8lRNiWY3FuLLGncLiVH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_06,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 spamscore=0 malwarescore=0 clxscore=1015
 mlxscore=0 priorityscore=1501 adultscore=0 impostorscore=0 mlxlogscore=689
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207290032
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No need to mangle strings if we already have the value at hand.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index efd5e0c1..ee34a1d7 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -134,7 +134,7 @@ $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o
 	truncate -s '%4096' $@
 
 $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS)
-	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/c/flat.lds $(patsubst %.gbin,%.o,$@) $(snippet_lib) $(FLATLIBS)
+	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/c/flat.lds $< $(snippet_lib) $(FLATLIBS)
 	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
 	truncate -s '%4096' $@
 
-- 
2.34.1

