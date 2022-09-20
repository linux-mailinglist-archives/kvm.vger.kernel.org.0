Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADCDF5BDE60
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 09:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiITHhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 03:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiITHhU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 03:37:20 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CDA606B4;
        Tue, 20 Sep 2022 00:37:18 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28K7JhFH003403;
        Tue, 20 Sep 2022 07:37:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=cD+v84j6lTvUofwhz5cILra8bqEbQk/dHqf+ffSrRZs=;
 b=WuJbhctw2vZ7L12jcxgQ0T+g5Kojbe2luyGsKpBzvI+G6CLR0aTFgbgPasr+eEJc/zeV
 12dbkv1X+qC37swbh5oY6kA12KD693zyfQb9PuXPExCknCvurJzHaLPdPU/ITkKGEZHg
 6tbNZqW4geVVBRahkEUUbpnruSmjBog0iFMOtu8FWjqeLoDaWUXssq3oAtiaVQNzaOzE
 9kp40vcU/8baR9a1cid7mbkIEln4VBv4pLGq3TB1uyepxvqShSLEkozQN6TueqQ+YdVv
 ONLUj5Fcrp/XF+YIVv2qpXG9uzc40VkpCB7rp4sHgqjV+lYY+Qfz20EyL+vrXsf286jV iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jq91j8eqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:37:17 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28K7LUxF008920;
        Tue, 20 Sep 2022 07:37:17 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jq91j8epb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:37:17 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28K7LoLf026014;
        Tue, 20 Sep 2022 07:32:15 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3jn5ghjk08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:32:14 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28K7WBtJ48562556
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 07:32:12 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCEC711C050;
        Tue, 20 Sep 2022 07:32:11 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E156511C04A;
        Tue, 20 Sep 2022 07:32:10 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Sep 2022 07:32:10 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 11/11] s390x: create persistent comm-key
Date:   Tue, 20 Sep 2022 07:30:35 +0000
Message-Id: <20220920073035.29201-12-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220920073035.29201-1-frankja@linux.ibm.com>
References: <20220920073035.29201-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qpVH3qM3mSUC9N5mePuU9xNyUC3kT6E1
X-Proofpoint-ORIG-GUID: IwYVTwR21lqrkOoQ845O73F4THGX4kw2
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_02,2022-09-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 suspectscore=0 adultscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209200045
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

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
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20220909121453.202548-3-nrb@linux.ibm.com
Message-Id: <20220909121453.202548-3-nrb@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/Makefile | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index a3647689..649486f2 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -164,15 +164,33 @@ $(SNIPPET_DIR)/c/%.hdr: $(SNIPPET_DIR)/c/%.gbin $(HOST_KEY_DOCUMENT)
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
+# The genprotimg arguments for the cck changed over time so we need to
+# figure out which argument to use in order to set the cck
+GENPROTIMG_HAS_COMM_KEY = $(shell $(GENPROTIMG) --help | grep -q -- --comm-key && echo yes)
+ifeq ($(GENPROTIMG_HAS_COMM_KEY),yes)
+	GENPROTIMG_COMM_KEY = --comm-key $(comm-key)
+else
+	GENPROTIMG_COMM_KEY = --x-comm-key $(comm-key)
+endif
 
-%selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bin,%.parmfile,$@)
+# use x-pcf to be compatible with old genprotimg versions
+# allow dumping + PCKMO
+genprotimg_pcf = 0x200000e0
+genprotimg_args = --host-key-document $(HOST_KEY_DOCUMENT) --no-verify $(GENPROTIMG_COMM_KEY) --x-pcf $(genprotimg_pcf)
+
+%selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bin,%.parmfile,$@) $(comm-key)
 	$(GENPROTIMG) $(genprotimg_args) --parmfile $(patsubst %.pv.bin,%.parmfile,$@) --image $< -o $@
 
-%.pv.bin: %.bin $(HOST_KEY_DOCUMENT)
+%.pv.bin: %.bin $(HOST_KEY_DOCUMENT) $(comm-key)
 	$(GENPROTIMG) $(genprotimg_args) --image $< -o $@
 
 $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
@@ -180,7 +198,7 @@ $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
 
 
 arch_clean: asm_offsets_clean
-	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d
+	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-key)
 
 generated-files = $(asm-offsets)
 $(tests:.elf=.o) $(asmlib) $(cflatobjs): $(generated-files)
-- 
2.34.1

