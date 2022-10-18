Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F836029FC
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 13:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiJRLPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 07:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiJRLPh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 07:15:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7996D4F
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 04:15:35 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29IBC9nB004132
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 11:15:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=fd+bciPqzE52eAyQClDuggmV+kmpSakn9MgN/tYRRQg=;
 b=EU3xHsZsq/aOrI/gumA+8ob8QrOwcppdq4gYPMfD0FAc7uuhyJjpj8dy7Xiyo1nLhDGT
 EW0BqIdken/7Of6dFk5BAr/aU9yWE5cyLN3jZlHWRz2wnFcEmHqtpFkSGV30Jzs7p6SV
 g4HuPg0TA4gi4wlJMIhzp1Og10xAmby2FseCDVIeH2vKbJ8nNTUFyTLy/WpokR7d+4Kl
 RKiaDEFlmz2xeuEhbEmbBkXEvu4QexsReIGmRxxZPALpKL+v+l5C6iSJNM9YnvYKDl6p
 0qLZ3jVLdZcZnCJU69JMnLHudvJcLobl0wjsbh1bN9F/SQsWk/aocZxcTJc37p2jb7s8 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k9u2b031v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 11:15:35 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29IBEHkF012595
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 11:15:34 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k9u2b0303-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Oct 2022 11:15:34 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29IB56ed013397;
        Tue, 18 Oct 2022 11:15:32 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3k7mg953rp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Oct 2022 11:15:32 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29IBFTlA5046886
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Oct 2022 11:15:29 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E7F7A405B;
        Tue, 18 Oct 2022 11:15:29 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B972A4054;
        Tue, 18 Oct 2022 11:15:29 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Oct 2022 11:15:28 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1] s390x: do not enable PV dump support by default
Date:   Tue, 18 Oct 2022 13:15:28 +0200
Message-Id: <20221018111528.173989-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 78Akfypc82IsX8SZYpt2BOXd3KPRwXSJ
X-Proofpoint-ORIG-GUID: PHMn18C2mStCr7emwrGkPZIkDvOaiJfy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-18_03,2022-10-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210180063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, dump support is always enabled by setting the respective
plaintext control flag (PCF). Unfortunately, older machines without
support for PV dump will not start the guest when this PCF is set. This
will result in an error message like this:

qemu-system-s390x: KVM PV command 2 (KVM_PV_SET_SEC_PARMS) failed: header rc 106 rrc 30 IOCTL rc: -22

Hence, by default, disable dump support to preserve compatibility with
older machines. Users can enable dumping support by passing
--enable-dump to the configure script.

Fixes: 3043685825d9 ("s390x: create persistent comm-key")
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 configure      | 11 +++++++++++
 s390x/Makefile |  9 ++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/configure b/configure
index 5b7daac3c6e8..b81f20942c9c 100755
--- a/configure
+++ b/configure
@@ -28,6 +28,7 @@ errata_force=0
 erratatxt="$srcdir/errata.txt"
 host_key_document=
 gen_se_header=
+enable_dump=no
 page_size=
 earlycon=
 efi=
@@ -67,6 +68,9 @@ usage() {
 	    --gen-se-header=GEN_SE_HEADER
 	                           Provide an executable to generate a PV header
 	                           requires --host-key-document. (s390x-snippets only)
+	    --[enable|disable]-dump
+	                           Allow PV guests to be dumped. Requires at least z16.
+	                           (s390x only)
 	    --page-size=PAGE_SIZE
 	                           Specify the page size (translation granule) (4k, 16k or
 	                           64k, default is 64k, arm64 only)
@@ -146,6 +150,12 @@ while [[ "$1" = -* ]]; do
 	--gen-se-header)
 	    gen_se_header="$arg"
 	    ;;
+	--enable-dump)
+	    enable_dump=yes
+	    ;;
+	--disable-dump)
+	    enable_dump=no
+	    ;;
 	--page-size)
 	    page_size="$arg"
 	    ;;
@@ -387,6 +397,7 @@ U32_LONG_FMT=$u32_long
 WA_DIVIDE=$wa_divide
 GENPROTIMG=${GENPROTIMG-genprotimg}
 HOST_KEY_DOCUMENT=$host_key_document
+CONFIG_DUMP=$enable_dump
 CONFIG_EFI=$efi
 CONFIG_WERROR=$werror
 GEN_SE_HEADER=$gen_se_header
diff --git a/s390x/Makefile b/s390x/Makefile
index 649486f2d4a0..5b4aff5e57ef 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -173,6 +173,11 @@ $(comm-key):
 %.bin: %.elf
 	$(OBJCOPY) -O binary  $< $@
 
+GENPROTIMG_COMM_KEY =
+# allow PCKMO
+genprotimg_pcf = 0x000000e0
+
+ifeq ($(CONFIG_DUMP),yes)
 # The genprotimg arguments for the cck changed over time so we need to
 # figure out which argument to use in order to set the cck
 GENPROTIMG_HAS_COMM_KEY = $(shell $(GENPROTIMG) --help | grep -q -- --comm-key && echo yes)
@@ -182,9 +187,11 @@ else
 	GENPROTIMG_COMM_KEY = --x-comm-key $(comm-key)
 endif
 
-# use x-pcf to be compatible with old genprotimg versions
 # allow dumping + PCKMO
 genprotimg_pcf = 0x200000e0
+endif
+
+# use x-pcf to be compatible with old genprotimg versions
 genprotimg_args = --host-key-document $(HOST_KEY_DOCUMENT) --no-verify $(GENPROTIMG_COMM_KEY) --x-pcf $(genprotimg_pcf)
 
 %selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bin,%.parmfile,$@) $(comm-key)
-- 
2.35.3

