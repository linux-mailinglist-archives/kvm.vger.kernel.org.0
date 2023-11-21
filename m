Return-Path: <kvm+bounces-2205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 558837F34E5
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 18:24:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 118542810B8
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 17:24:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED4885B1F0;
	Tue, 21 Nov 2023 17:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="X//pW6dA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4512E113;
	Tue, 21 Nov 2023 09:23:53 -0800 (PST)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ALHC5bp025351;
	Tue, 21 Nov 2023 17:23:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=li09p8rzNlRBgPpKrO6Q07ekfcAX/GJk2GVXZNp2bvg=;
 b=X//pW6dAP5z2TZGTwn8+a+54lzJdFdJkHeyRRbzoHO0o1ppjUDr+uSuX4GDQ4/oUTECb
 FTkvUBXDIO7/Eq4vRCYCosHBvAzHWQhqCoLbwP62igu4E7JJ2tqNTT8Y0SwOOfXtJUKP
 ty68L5OID7lH/iVxIXd10z3NnBqQd9LU3yEsHXHd3B0VcofMRykzDe0TNmTa0bxNkeBD
 BhBFiYrjc51Yjv66hc65K3/bXfn8i7WqH4c/5PZuIju0cs5kDs/ILg4NMqQhgNCtUMP7
 1YGDRF4Ve4heLdb/ysQXtRQ8shvH4GSd83yIJ425dc5nzn9+614wVz2DBvprlsM6x/cE Iw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ugyt9jns1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Nov 2023 17:23:52 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3ALHF3tN000562;
	Tue, 21 Nov 2023 17:23:51 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ugyt9jnrw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Nov 2023 17:23:51 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3ALGIpmu010190;
	Tue, 21 Nov 2023 17:23:51 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uf9tk9ub6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Nov 2023 17:23:50 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3ALHNmOC10814098
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Nov 2023 17:23:48 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 132B320040;
	Tue, 21 Nov 2023 17:23:48 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9294320049;
	Tue, 21 Nov 2023 17:23:47 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.fritz.box (unknown [9.171.34.247])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 21 Nov 2023 17:23:47 +0000 (GMT)
From: Marc Hartmayer <mhartmay@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Cc: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>
Subject: [kvm-unit-tests PATCH v1] s390x/Makefile: simplify Secure Execution boot image generation
Date: Tue, 21 Nov 2023 18:23:38 +0100
Message-ID: <20231121172338.146006-1-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wl-V9LjRhyblu4ujNkokO1WOsD71ia7B
X-Proofpoint-ORIG-GUID: BkYO8YkwPh6C1k-jsWa9jvxi2fG7T6VR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-21_10,2023-11-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0 clxscore=1011
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311210136

Changes:
+ merge Makefile rules for the generation of the Secure Execution boot
  image
+ fix `parmfile` dependency for the `selftest.pv.bin` target
+ rename `genprotimg_pcf` to `GENPROTIMG_PCF` to match the coding style
  in the file
+ always provide a customer communication key - not only for the
  confidential dump case. Makes the code little easier and doesn't hurt.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 s390x/Makefile | 40 +++++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index f79fd0098312..be89d8de1cba 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -194,33 +194,27 @@ $(comm-key):
 %.bin: %.elf
 	$(OBJCOPY) -O binary  $< $@
 
-# Will only be filled when dump has been enabled
-GENPROTIMG_COMM_KEY =
-# allow PCKMO
-genprotimg_pcf = 0x000000e0
-
-ifeq ($(CONFIG_DUMP),yes)
-	# The genprotimg arguments for the cck changed over time so we need to
-	# figure out which argument to use in order to set the cck
-	GENPROTIMG_HAS_COMM_KEY = $(shell $(GENPROTIMG) --help | grep -q -- --comm-key && echo yes)
-	ifeq ($(GENPROTIMG_HAS_COMM_KEY),yes)
-		GENPROTIMG_COMM_KEY = --comm-key $(comm-key)
-	else
-		GENPROTIMG_COMM_KEY = --x-comm-key $(comm-key)
-	endif
-
-	# allow dumping + PCKMO
-	genprotimg_pcf = 0x200000e0
+# The genprotimg arguments for the cck changed over time so we need to
+# figure out which argument to use in order to set the cck
+GENPROTIMG_HAS_COMM_KEY = $(shell $(GENPROTIMG) --help | grep -q -- --comm-key && echo yes)
+ifeq ($(GENPROTIMG_HAS_COMM_KEY),yes)
+	GENPROTIMG_COMM_OPTION := --comm-key
+else
+	GENPROTIMG_COMM_OPTION := --x-comm-key
 endif
 
-# use x-pcf to be compatible with old genprotimg versions
-genprotimg_args = --host-key-document $(HOST_KEY_DOCUMENT) --no-verify $(GENPROTIMG_COMM_KEY) --x-pcf $(genprotimg_pcf)
-
-%selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bin,%.parmfile,$@) $(comm-key)
-	$(GENPROTIMG) $(genprotimg_args) --parmfile $(patsubst %.pv.bin,%.parmfile,$@) --image $< -o $@
+ifeq ($(CONFIG_DUMP),yes)
+	# allow dumping + PCKMO
+	GENPROTIMG_PCF := 0x200000e0
+else
+	# allow PCKMO
+	GENPROTIMG_PCF := 0x000000e0
+endif
 
+$(patsubst %.parmfile,%.pv.bin,$(wildcard s390x/*.parmfile)): %.pv.bin: %.parmfile
 %.pv.bin: %.bin $(HOST_KEY_DOCUMENT) $(comm-key)
-	$(GENPROTIMG) $(genprotimg_args) --image $< -o $@
+	$(eval parmfile_args = $(if $(filter %.parmfile,$^),--parmfile $(filter %.parmfile,$^),))
+	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify $(GENPROTIMG_COMM_OPTION) $(comm-key) --x-pcf $(GENPROTIMG_PCF) $(parmfile_args) --image $(filter %.bin,$^) -o $@
 
 $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
 	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<

base-commit: d0891021d5ad244c99290b4515152a1f997a9404
-- 
2.34.1


