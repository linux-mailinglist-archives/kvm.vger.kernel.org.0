Return-Path: <kvm+bounces-15787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DCDCC8B07E1
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 13:00:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 552EC1F23570
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 11:00:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4187515AD92;
	Wed, 24 Apr 2024 10:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="owAIi0kw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1666215991B
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 10:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713956394; cv=none; b=o4PXgmxvHy+XWQOadcK99bsblpihyJLKWUOnsB/po0JDGa8ueiz5b87udLLIlVVRX288+8YdQQhh4Xju6NNGtb6x2mQgsERgpywxVohh3d4n6PXIh0boSNTBoj23mfbH/355LL0tcOOpY5D7Ze6HBt1VoVq66nAYp/PYB5qBvxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713956394; c=relaxed/simple;
	bh=dyJ7FRvh0wAmB0CoarZWSw/OPx8V71j6Fgs6Mfvdk2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zua7+vdCxzRcp6Dt+6nTa9Ihq8je7TGB18E7sXL2GI7GBgjIDtX+dRqCsOhg1AgODRJr64y3W3u2r9QeGuW/v571NJ9yeuFlfBJMy9ibvPuS3ngC6UuqqRdowKNCRQb2K8GNbvz+d+NST7R918qhTgK3SvI98snMnLetWPHG3dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=owAIi0kw; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43OAwgnF030686;
	Wed, 24 Apr 2024 10:59:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=HaoajYLKFTXItkkLN+X6gEMoldb+xE2959U4/IwiR7I=;
 b=owAIi0kwjGj1Utsl3flK4OIUTMru5eGkSFRew47b+ObkI3tQca+w/NGjyy5JaQr8QCDS
 5Q7epdCxArg+rhSgB2TB13LZegqvYKQwnHk39rdgi8EU0z4UIfKNu7d1kUtMuq3y1Cgo
 GcCtfOG/N26ySfYIOdjIlylAabHI8GXi7E8dr8xpNcihQgY4AaIjvwNvBSYRRCAbW6yp
 BkMaglYBCzLTmRufxYJj/NDMv+FCQEcdtFQvCd6IZ6kULpqqAV2FBR+1nlX+PH43yotb
 gs34X4qpd00WpdHVocYubojGXUEbxcpo5p/s/gwABizVgXhg//9W/nkjbEJ/ot7N9kPk Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xq0sm803u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:45 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43OAxiIr032315;
	Wed, 24 Apr 2024 10:59:44 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xq0sm803s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:44 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43O7ZQYH020943;
	Wed, 24 Apr 2024 10:59:44 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xmre03afp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:44 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43OAxcbm32178508
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Apr 2024 10:59:40 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ADC0520043;
	Wed, 24 Apr 2024 10:59:38 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 83D092004E;
	Wed, 24 Apr 2024 10:59:38 +0000 (GMT)
Received: from t14-nrb.boeblingen.de.ibm.com (unknown [9.152.224.21])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Apr 2024 10:59:38 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Steffen Eiden <seiden@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 01/13] s390x/Makefile: simplify Secure Execution boot image generation
Date: Wed, 24 Apr 2024 12:59:20 +0200
Message-ID: <20240424105935.184138-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424105935.184138-1-nrb@linux.ibm.com>
References: <20240424105935.184138-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1j1D_VuGUv8-p_2qD4v-89cypclaZCIu
X-Proofpoint-ORIG-GUID: 5V2X6s6TtJyOl0H6Bb5YoOFkxasdCuUo
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-24_08,2024-04-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 adultscore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 clxscore=1015 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404240045

From: Marc Hartmayer <mhartmay@linux.ibm.com>

Changes:
+ merge Makefile rules for the generation of the Secure Execution boot
  image
+ fix `parmfile` dependency for the `selftest.pv.bin` target
+ rename `genprotimg_pcf` to `GENPROTIMG_PCF` to match the coding style
  in the file
+ always provide a customer communication key - not only for the
  confidential dump case. Makes the code little easier and doesn't hurt.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Link: https://lore.kernel.org/r/20231121172338.146006-1-mhartmay@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile | 36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index ddc0969f..8603a523 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -197,33 +197,27 @@ $(comm-key):
 %.bin: %.elf
 	$(OBJCOPY) -O binary  $< $@
 
-# Will only be filled when dump has been enabled
-GENPROTIMG_COMM_KEY =
-# allow PCKMO
-genprotimg_pcf = 0x000000e0
+# The genprotimg arguments for the cck changed over time so we need to
+# figure out which argument to use in order to set the cck
+GENPROTIMG_HAS_COMM_KEY = $(shell $(GENPROTIMG) --help | grep -q -- --comm-key && echo yes)
+ifeq ($(GENPROTIMG_HAS_COMM_KEY),yes)
+	GENPROTIMG_COMM_OPTION := --comm-key
+else
+	GENPROTIMG_COMM_OPTION := --x-comm-key
+endif
 
 ifeq ($(CONFIG_DUMP),yes)
-	# The genprotimg arguments for the cck changed over time so we need to
-	# figure out which argument to use in order to set the cck
-	GENPROTIMG_HAS_COMM_KEY = $(shell $(GENPROTIMG) --help | grep -q -- --comm-key && echo yes)
-	ifeq ($(GENPROTIMG_HAS_COMM_KEY),yes)
-		GENPROTIMG_COMM_KEY = --comm-key $(comm-key)
-	else
-		GENPROTIMG_COMM_KEY = --x-comm-key $(comm-key)
-	endif
-
 	# allow dumping + PCKMO
-	genprotimg_pcf = 0x200000e0
+	GENPROTIMG_PCF := 0x200000e0
+else
+	# allow PCKMO
+	GENPROTIMG_PCF := 0x000000e0
 endif
 
-# use x-pcf to be compatible with old genprotimg versions
-genprotimg_args = --host-key-document $(HOST_KEY_DOCUMENT) --no-verify $(GENPROTIMG_COMM_KEY) --x-pcf $(genprotimg_pcf)
-
-%selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bin,%.parmfile,$@) $(comm-key)
-	$(GENPROTIMG) $(genprotimg_args) --parmfile $(patsubst %.pv.bin,%.parmfile,$@) --image $< -o $@
-
+$(patsubst %.parmfile,%.pv.bin,$(wildcard s390x/*.parmfile)): %.pv.bin: %.parmfile
 %.pv.bin: %.bin $(HOST_KEY_DOCUMENT) $(comm-key)
-	$(GENPROTIMG) $(genprotimg_args) --image $< -o $@
+	$(eval parmfile_args = $(if $(filter %.parmfile,$^),--parmfile $(filter %.parmfile,$^),))
+	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify $(GENPROTIMG_COMM_OPTION) $(comm-key) --x-pcf $(GENPROTIMG_PCF) $(parmfile_args) --image $(filter %.bin,$^) -o $@
 
 $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
 	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
-- 
2.44.0


