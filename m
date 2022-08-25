Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027455A11B3
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 15:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242442AbiHYNQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 09:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242426AbiHYNQK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 09:16:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AD0A99E9
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 06:16:07 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27PCUUJo023734
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 13:16:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=OXqyE3w+/wqcfrrkmec3XAXn6FfsZ59NTdqzaUtdHmc=;
 b=Pfrd3N/nL33HM1jRjst55n4sVvvSfLx7T1nvn1thVagNWpFt8Et+ewP6iDzb24LLMS5F
 R5vUgc5VPjpxhpMWr/EB4B2O5wWPB794Em5L0EZGI0q/10ARMGZViLU3MMUg0SjTS7gj
 yUD6db+ZuINTRYLAc6/Fu4VzsmffZkxOfit8Dwl63cEH9/n+kLpF4y6d30HcxIVlAWkW
 71DDSWye/kLFYme3zROSCwMssCN3hkoHdGafEMzIr147nKIy/HrPg04QB81kZwr9MZ3r
 rezHfZ1WAX25WqCKL7z9T9LYz7JDB0Xj+kVAlZYRWmK9/xDf7dxOeKe6ZT+qjmqn45BM og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j6958sgh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 13:16:06 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27PCUedS024196
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 13:16:06 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j6958sgga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 13:16:06 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27PCpPnJ014979;
        Thu, 25 Aug 2022 13:16:04 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3j2q88xeww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 13:16:03 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27PDGLK241550080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 13:16:21 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D812A5204F;
        Thu, 25 Aug 2022 13:16:00 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9814D52051;
        Thu, 25 Aug 2022 13:16:00 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 1/2] s390x: factor out common args for genprotimg
Date:   Thu, 25 Aug 2022 15:15:59 +0200
Message-Id: <20220825131600.115920-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220825131600.115920-1-nrb@linux.ibm.com>
References: <20220825131600.115920-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: v2YGJKv-x8QOlosmpaIqOVM2-cieFhX7
X-Proofpoint-GUID: W7mpG1wvTb7DG6C0WyBcO6hE-2muypfn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_05,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 suspectscore=0 spamscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208250050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Upcoming changes will add more arguments to genprotimg. To avoid
duplicating this logic, move the arguments to genprotimg to a variable.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/Makefile | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index efd5e0c13102..d17055ebe6a8 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -165,11 +165,13 @@ $(SNIPPET_DIR)/c/%.hdr: $(SNIPPET_DIR)/c/%.gbin $(HOST_KEY_DOCUMENT)
 %.bin: %.elf
 	$(OBJCOPY) -O binary  $< $@
 
+genprotimg_args = --host-key-document $(HOST_KEY_DOCUMENT) --no-verify
+
 %selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bin,%.parmfile,$@)
-	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --parmfile $(patsubst %.pv.bin,%.parmfile,$@) --no-verify --image $< -o $@
+	$(GENPROTIMG) $(genprotimg_args) --parmfile $(patsubst %.pv.bin,%.parmfile,$@) --image $< -o $@
 
 %.pv.bin: %.bin $(HOST_KEY_DOCUMENT)
-	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify --image $< -o $@
+	$(GENPROTIMG) $(genprotimg_args) --image $< -o $@
 
 $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
 	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
-- 
2.36.1

