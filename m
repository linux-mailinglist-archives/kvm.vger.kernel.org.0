Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A1B66CE80
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 19:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbjAPSNT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 13:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233268AbjAPSMr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 13:12:47 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA4C305FB
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 09:59:05 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30GHVDo3012049
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:59:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=M+OsLmN6RcecBaj8CrwX7rYIHPOmZ0rKOOYMJzeYzcc=;
 b=HJGry9/gzeycWxk7sGf3rHgOedlXQyhR52cVDjl0NuNUcXMpA7KwV6MeTC1dCd9kDFoo
 bIv0VH3gptxhVpi9flKCFFe8uJVvVsq8RYYnTbrhVj/Lzi7ILMANze0pkMkzHmgKtzd9
 1i5Eexi/1E1DlNa33grisu6cqKvo3wXmrkHNqUwTs4xiadRPkoLLNV3kBWDNNxYX7Ekb
 nuHfR4Cx1cuNyvJ5lVSPGJ5x42zY9vb37MTGycEyesO2oKKsYLPGNOmQ3LW0bqX6u2jz
 xTdobhKEgIYRSA4qKy7rRnED4WRTncik9H5HSSq6QHkgsVemsqFgnbh1a3SAXBFytq3J Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n584n4vwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:59:05 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30GHd8o1030363
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:59:04 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n584n4vw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 17:59:04 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30GFebfN023789;
        Mon, 16 Jan 2023 17:59:02 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3n3m16jrt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 17:59:02 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30GHww3C43385280
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 17:58:58 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD32920043;
        Mon, 16 Jan 2023 17:58:58 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3386B20040;
        Mon, 16 Jan 2023 17:58:58 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com.com (unknown [9.171.31.34])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 17:58:58 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH 3/9] s390x/Makefile: fix `*.gbin` target dependencies
Date:   Mon, 16 Jan 2023 18:57:51 +0100
Message-Id: <20230116175757.71059-4-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116175757.71059-1-mhartmay@linux.ibm.com>
References: <20230116175757.71059-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: y3OH0YVAghG25Xjm_MHUjUyVzKNYHZod
X-Proofpoint-GUID: j-OW2wPnOj2_caX00sD2M-nqyfQt-ZV-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_15,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 mlxlogscore=930 bulkscore=0 spamscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160131
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the linker scripts change, then the .gbin binaries must be rebuilt.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 s390x/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index 660ff06f1e7c..b6bf2ed99afd 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -135,12 +135,12 @@ $(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
 $(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
 	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
 
-$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o
+$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(SRCDIR)/s390x/snippets/asm/flat.lds
 	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/asm/flat.lds $<
 	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
 	truncate -s '%4096' $@
 
-$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS)
+$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) $(SRCDIR)/s390x/snippets/c/flat.lds
 	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/c/flat.lds $< $(snippet_lib) $(FLATLIBS)
 	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
 	truncate -s '%4096' $@
-- 
2.34.1

