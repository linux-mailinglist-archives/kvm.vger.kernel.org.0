Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 962D367372C
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 12:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbjASLmA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 06:42:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbjASLlM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 06:41:12 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8417E358A
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 03:41:08 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30JBcX5b034520
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:41:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gIVH8+Yqe1lNmrtjIq0FQEstA4pMEK4au/ZpVOgetEU=;
 b=onGnAjh+kAhALWCYzS+y3X+MfE4DeOdXtRJI4hYgUcyo/x2bsn21PbxqTb54UF5zyuKA
 lFZBQqqavG2cJ+nUZ7giO5XuzW8q0i+lsp+F8XyOIi2kyCj94X9A+ijF3F6uGtNvLJHp
 DfE/osGoclir0wU7SY5I0czaB8yANgiNH/q5SeC7cAYwFs9BJ0BoN/3LIdYdqSy/dALJ
 2Q1nxRHmNCFATEutH1tWnDRSbVTvMVErZwonX6I+Kw0Qt4ZDSlsGiUZ/EbgJYDmPPf+l
 3DgsbP8iMhtt4EorvobshyqBGrLotDVBv5HVk6Yt7+rt1vLbdtlH8K9Gp4xrACF2T/Hb 4w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n72624emj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:41:07 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30JBdStr039013
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:41:07 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n72624eky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 11:41:07 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30IMlW8u030244;
        Thu, 19 Jan 2023 11:41:05 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3n3m16mt38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 11:41:05 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30JBf21Z47710610
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 11:41:02 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0189720040;
        Thu, 19 Jan 2023 11:41:02 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8277620043;
        Thu, 19 Jan 2023 11:41:01 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com.com (unknown [9.171.91.27])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 19 Jan 2023 11:41:01 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH v2 2/8] s390x/Makefile: simplify `%.hdr` target rules
Date:   Thu, 19 Jan 2023 12:40:39 +0100
Message-Id: <20230119114045.34553-3-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230119114045.34553-1-mhartmay@linux.ibm.com>
References: <20230119114045.34553-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ceMX3ZmlRJbMkkiByGxAPPR1YxSVI_X6
X-Proofpoint-ORIG-GUID: zvQeBuf3nJcyLFRQZqFbS375iVnXFqsP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-19_09,2023-01-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 impostorscore=0 mlxlogscore=881
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301190091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Merge the two Makefile target rules `$(SNIPPET_DIR)/asm/%.hdr` and
`$(SNIPPET_DIR)/c/%.hdr` into one target rule.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/Makefile | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index 97a616111680..660ff06f1e7c 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -145,10 +145,7 @@ $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS)
 	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
 	truncate -s '%4096' $@
 
-$(SNIPPET_DIR)/asm/%.hdr: $(SNIPPET_DIR)/asm/%.gbin $(HOST_KEY_DOCUMENT)
-	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
-
-$(SNIPPET_DIR)/c/%.hdr: $(SNIPPET_DIR)/c/%.gbin $(HOST_KEY_DOCUMENT)
+%.hdr: %.gbin $(HOST_KEY_DOCUMENT)
 	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
 
 .SECONDARY:
-- 
2.34.1

