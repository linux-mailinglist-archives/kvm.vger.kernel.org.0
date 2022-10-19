Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA6BC604A36
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 16:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbiJSO7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 10:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbiJSO7S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 10:59:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E70C069A
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 07:53:28 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JEbIcR021528
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 14:53:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=aQCgPi3qYev2JfoU7sAhYBGc2ivTWm1c0PHlQPvhums=;
 b=LfJqfTlhuSeKjmoMaKFnuuex6FNs0lDBsDQm6OVF/ivDs7CboaYpdZo4J9lB94OdzTcY
 Hwpo+jIJhacXFIaahl4pJi9ygd8X2QIUrF0NecDsH0AskIPpB4fDIG4JgxZn0NLtQD0n
 WmDX4QSov54cyzPo4NZQeHmMosEZZP+Ml6FInoGFxQJdV86usJldJzqzRBCN6sog40qY
 /vFxrVNnsuH01rrB3mTFA3XB7odIB4jlGPnxaqKSLTZdGibpzjlu71vr3c2QJFB7NPID
 XkMcd19KapKoQNHs4mvRqy7fkEO3eTKgDsrIFt83wqnN9bP4pEFNL4N/Sv0rIsgPFR5f DA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kajskhk8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 14:53:27 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29JEbML5022479
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 14:53:26 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kajskhk6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 14:53:26 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29JEpTYL003855;
        Wed, 19 Oct 2022 14:53:23 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3k7mg95g5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 14:53:23 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29JErKVN65274252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 14:53:20 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B56EE11C04C;
        Wed, 19 Oct 2022 14:53:20 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 804F311C052;
        Wed, 19 Oct 2022 14:53:20 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Oct 2022 14:53:20 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 1/1] s390x: do not enable PV dump support by default
Date:   Wed, 19 Oct 2022 16:53:20 +0200
Message-Id: <20221019145320.1228710-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221019145320.1228710-1-nrb@linux.ibm.com>
References: <20221019145320.1228710-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yTgZThGfa_SVnJ46KEaqmPT22U3xIb9U
X-Proofpoint-ORIG-GUID: Vmzh01Qs-omYXuj0bbFlhE8iFf9Ez_1m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_08,2022-10-19_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 spamscore=0 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210190081
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

qemu-system-s390x: KVM PV command 2 (KVM_PV_SET_SEC_PARMS) failed: header rc 106 rrc 0 IOCTL rc: -22

Hence, by default, disable dump support to preserve compatibility with
older machines. Users can enable dumping support by passing
--enable-dump to the configure script.

Fixes: 3043685825d9 ("s390x: create persistent comm-key")
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 configure      | 11 +++++++++++
 s390x/Makefile | 26 +++++++++++++++++---------
 2 files changed, 28 insertions(+), 9 deletions(-)

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
index 649486f2d4a0..271b6803a1c5 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -173,18 +173,26 @@ $(comm-key):
 %.bin: %.elf
 	$(OBJCOPY) -O binary  $< $@
 
-# The genprotimg arguments for the cck changed over time so we need to
-# figure out which argument to use in order to set the cck
-GENPROTIMG_HAS_COMM_KEY = $(shell $(GENPROTIMG) --help | grep -q -- --comm-key && echo yes)
-ifeq ($(GENPROTIMG_HAS_COMM_KEY),yes)
-	GENPROTIMG_COMM_KEY = --comm-key $(comm-key)
-else
-	GENPROTIMG_COMM_KEY = --x-comm-key $(comm-key)
+# Will only be filled when dump has been enabled
+GENPROTIMG_COMM_KEY =
+# allow PCKMO
+genprotimg_pcf = 0x000000e0
+
+ifeq ($(CONFIG_DUMP),yes)
+	# The genprotimg arguments for the cck changed over time so we need to
+	# figure out which argument to use in order to set the cck
+	GENPROTIMG_HAS_COMM_KEY = $(shell $(GENPROTIMG) --help | grep -q -- --comm-key && echo yes)
+	ifeq ($(GENPROTIMG_HAS_COMM_KEY),yes)
+		GENPROTIMG_COMM_KEY = --comm-key $(comm-key)
+	else
+		GENPROTIMG_COMM_KEY = --x-comm-key $(comm-key)
+	endif
+
+	# allow dumping + PCKMO
+	genprotimg_pcf = 0x200000e0
 endif
 
 # use x-pcf to be compatible with old genprotimg versions
-# allow dumping + PCKMO
-genprotimg_pcf = 0x200000e0
 genprotimg_args = --host-key-document $(HOST_KEY_DOCUMENT) --no-verify $(GENPROTIMG_COMM_KEY) --x-pcf $(genprotimg_pcf)
 
 %selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bin,%.parmfile,$@) $(comm-key)
-- 
2.36.1

