Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F276D7732
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 10:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237572AbjDEIpp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 04:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237334AbjDEIpm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 04:45:42 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98BA1271C
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 01:45:41 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33566Ntf036386;
        Wed, 5 Apr 2023 08:45:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=TjfFo4xmo0DzslTSyxbkiwnNOCoceQDllmcY9S6/NuA=;
 b=gofyyi6c7F77UZKJ/s1tpGGIm0ykgLnXew3FGmJX7a9KdSkHk0Lh7G1GLcmK9kXMUk0Q
 w3APJ7hD+ULwZ5kZR+i2kLccQHueLq9agp+s5POujrjqA1666EEYcA55TPxdqI7KHmZF
 4UhP26QptaRZ3B9iJoL/lykOJwxcD1X1IJ9tTk2Jf8puoyiEatrSLxzOBEGPhq6nd8OM
 C6iPKRLDXEx4wdwTdqqalH56yIeTZ700WwrS4Lg3I7SOY4cBaC63dMrxHu5zHlIN6tHX
 2jFv7Tztl8O4N3ngbigosIaKG6+nhZVyPRoboGMJiwaOZViFWh8iNZ/vAnSFRfOgNavn XQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ps2p1vs38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 08:45:39 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3358WR3J031839;
        Wed, 5 Apr 2023 08:45:38 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ps2p1vs2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 08:45:38 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3342FJ2v015573;
        Wed, 5 Apr 2023 08:45:36 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3ppc86td3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 08:45:35 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3358jWRm47448326
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Apr 2023 08:45:32 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 635C920049;
        Wed,  5 Apr 2023 08:45:32 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECAA520040;
        Wed,  5 Apr 2023 08:45:31 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.30.226])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  5 Apr 2023 08:45:31 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL v3 03/14] s390x/Makefile: fix `*.gbin` target dependencies
Date:   Wed,  5 Apr 2023 10:45:17 +0200
Message-Id: <20230405084528.16027-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230405084528.16027-1-nrb@linux.ibm.com>
References: <20230405084528.16027-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: v7SB_D5bQxXuIJaoSuXKTK34zTKeFhS0
X-Proofpoint-GUID: 3qxxUXP78AHJ25FrRvyzXmKEbvQf2Vjv
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-05_04,2023-04-04_05,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 adultscore=0 impostorscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=999 suspectscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304050079
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Hartmayer <mhartmay@linux.ibm.com>

If the linker scripts change, then the .gbin binaries must be rebuilt.
While at it, replace `$(SRCDIR)/s390x/snippets` with `$(SNIPPET_DIR)`
for these Makefile rules.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20230307091051.13945-4-mhartmay@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index 660ff06..71e6563 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -135,13 +135,13 @@ $(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
 $(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
 	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
 
-$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o
-	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/asm/flat.lds $<
+$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(SNIPPET_DIR)/asm/flat.lds
+	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/asm/flat.lds $<
 	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
 	truncate -s '%4096' $@
 
-$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS)
-	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/c/flat.lds $< $(snippet_lib) $(FLATLIBS)
+$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) $(SNIPPET_DIR)/c/flat.lds
+	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds $< $(snippet_lib) $(FLATLIBS)
 	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
 	truncate -s '%4096' $@
 
-- 
2.39.2

