Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60B55A11B5
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 15:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242456AbiHYNQS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 09:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242435AbiHYNQL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 09:16:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB83CA61F9
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 06:16:07 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27PCx4I1019317
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 13:16:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=/YeuYxev/EWxt+otdXIgKPbZJV3E8lEkBsfdI1XOcFo=;
 b=HvpHfJdppR4YwGxxwr+77BsQ5b5ZyUz7dM3gGqfCx/v10wJtRqWDYCjqpEOsEvsaHxS1
 aiPNnJxf8hn/0DjUSdd1Adfeu0rwVQrgyBzUulugHYljiCt1fqHJqgBzEyBhHkoVyGce
 i+xHuwAN/5B/DB9pgkA1P2OFWsTpY5Xh3kkDM0IvgNxg9MiJ3b/Cn9NMwUw91v479Sq3
 LGtHoWMgRtHtobq6FR1puiei1Ruh6BF8A2Xxh9kWG057TU50pOn1jSycKjmXzZ8ShZUg
 jHQWRYASCJfhK9aIGamFplRykCfcgj7DoC16F9Lnaxu5KSbtpeA8WOs+czKNFLhq91/e 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j69jn8p6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 13:16:07 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27PCxfwt022137
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 13:16:06 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j69jn8p5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 13:16:06 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27PCpEEu030597;
        Thu, 25 Aug 2022 13:16:04 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3j2q88xf7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 13:16:04 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27PDG1Fh39387420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 13:16:01 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C2BE5204F;
        Thu, 25 Aug 2022 13:16:01 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id DA14152050;
        Thu, 25 Aug 2022 13:16:00 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 2/2] s390x: create persistent comm-key
Date:   Thu, 25 Aug 2022 15:16:00 +0200
Message-Id: <20220825131600.115920-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220825131600.115920-1-nrb@linux.ibm.com>
References: <20220825131600.115920-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9gyqILO3wacFqjc0kpr1A8xAVZXAS8Eo
X-Proofpoint-GUID: piwGqRlj2qJzWaUtkQbLg9gpUc1-Xqed
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_05,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 phishscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=999
 impostorscore=0 clxscore=1015 adultscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208250050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To decrypt the dump of a PV guest, the comm-key (CCK) is required. Until
now, no comm-key was provided to genprotimg, therefore decrypting the
dump of a kvm-unit-test under PV was not possible.

This patch makes sure that we create a random CCK if there's no
$(TEST_DIR)/comm.key file.

Also allow dumping of PV tests by passing the appropriate PCF to
genprotimg (bit 34). --x-pcf is used to be compatible with older
genprotimg versions, which don't support --enable-dump. 0xe0 is the
default PCF value and only bit 34 is added.

Unfortunately, recent versions of genprotimg removed the --x-comm-key
argument which was used by older versions to specify the CCK. To support
these versions, we need to parse the genprotimg help output and decide
which argument to use.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index d17055ebe6a8..4e268f47b6ab 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -162,15 +162,30 @@ $(SNIPPET_DIR)/c/%.hdr: $(SNIPPET_DIR)/c/%.gbin $(HOST_KEY_DOCUMENT)
 	$(RM) $(@:.elf=.aux.o)
 	@chmod a-x $@
 
+# Secure Execution Customer Communication Key file
+# 32 bytes of key material, uses existing one if available
+comm-key = $(TEST_DIR)/comm.key
+$(comm-key):
+	dd if=/dev/urandom of=$@ bs=32 count=1 status=none
+
 %.bin: %.elf
 	$(OBJCOPY) -O binary  $< $@
 
-genprotimg_args = --host-key-document $(HOST_KEY_DOCUMENT) --no-verify
+GENPROTIMG_HAS_COMM_KEY = $(shell $(GENPROTIMG) --help | grep -q -- --comm-key && echo yes)
+ifeq ($(GENPROTIMG_HAS_COMM_KEY),yes)
+	GENPROTIMG_COMM_KEY = --comm-key $(comm-key)
+else
+	GENPROTIMG_COMM_KEY = --x-comm-key $(comm-key)
+endif
+# use x-pcf to be compatible with old genprotimg versions
+# allow dumping + PCKMO
+genprotimg_pcf = 0x200000e0
+genprotimg_args = --host-key-document $(HOST_KEY_DOCUMENT) --no-verify $(GENPROTIMG_COMM_KEY) --x-pcf $(genprotimg_pcf)
 
-%selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bin,%.parmfile,$@)
+%selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bin,%.parmfile,$@) $(comm-key)
 	$(GENPROTIMG) $(genprotimg_args) --parmfile $(patsubst %.pv.bin,%.parmfile,$@) --image $< -o $@
 
-%.pv.bin: %.bin $(HOST_KEY_DOCUMENT)
+%.pv.bin: %.bin $(HOST_KEY_DOCUMENT) $(comm-key)
 	$(GENPROTIMG) $(genprotimg_args) --image $< -o $@
 
 $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
@@ -178,7 +193,7 @@ $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
 
 
 arch_clean: asm_offsets_clean
-	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d
+	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-key)
 
 generated-files = $(asm-offsets)
 $(tests:.elf=.o) $(asmlib) $(cflatobjs): $(generated-files)
-- 
2.36.1

