Return-Path: <kvm+bounces-37104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C2DB4A25486
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 09:37:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5EC9A1882FF3
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 08:37:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0318D2063D1;
	Mon,  3 Feb 2025 08:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="c5PyKqmg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAADA1FC7D6
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 08:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738571806; cv=none; b=NW82Thc+AFfyPerBa3oH8ZvFMyNsq2NpmmQ8WLEbKuVUviZmns1rjhQfZ3EANl7r2ByQGITOcqEnZFJH54xlWKP1/Nngv4f1rx3+1bQDkGz3OuWqmvfTjmSFfbalM3sxkerEj0VLccvP9GFHN5f0iA6VHoJpx/Q7559Y/pM2+tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738571806; c=relaxed/simple;
	bh=gVT1Jtu9kQIxSNCGfxdKVFekaMA+76rtRYHvfqD86Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCcMb2wSZ0ceANDFOlPjzGvj1Xpl+Mgk48LdK9+BwTN50hPiiDnhf7/LHZtp6ZS5l+vfwER8VCnPYuG8sWilfxN0VNOU8F1zH4zBLjZZoInEFYJPFG2rXz/6FbJ8TfB8AEikr3CgVjHmqp8uFm8zgmKu46wgNlnZY+XgAIZSrng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=c5PyKqmg; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51319rlx029261;
	Mon, 3 Feb 2025 08:36:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=zP1InfUjIPB2SqFQd
	V3++4s5WM/mlnE0zERE2wdGJh8=; b=c5PyKqmgUH4Lpi0m8EerIfYeP8V3ad47S
	bM46dQK60X/nu04gK3XXTEcFRJNmg+dtZBLZb6u1l+Lb2dW/mSdy7Vs+YiwU3eUL
	6qtATBLJgGFxDd42xYPhZ5HCT64KCPDEFXSXIX2ys4uqTrlPAf8IqIgNtziRam5p
	1QKsyI+aBzpSF0vazIuSSC1o9ctlRcpxpC6SvEm0azWGFvUZM8+J6Qx21HUzPqTu
	6B+VYLWIImw6kapAVeyTO5m70RaxTqXyHjYyrG382SUlDAa03EcJIQw8LIcMNqbA
	bI1LefD/KJ9WL7XMAWMxOmsIlzIXdpPrH7sv93VJg70tfAHuzbh5g==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44jkv91n9w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:38 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5134cwYj005292;
	Mon, 3 Feb 2025 08:36:37 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44j05jn6cf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:37 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5138aWcn20185540
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Feb 2025 08:36:33 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD08E20040;
	Mon,  3 Feb 2025 08:36:32 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6F0202004B;
	Mon,  3 Feb 2025 08:36:32 +0000 (GMT)
Received: from t14-nrb.lan (unknown [9.171.84.16])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Feb 2025 08:36:32 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 16/18] s390x: Support newer version of genprotimg
Date: Mon,  3 Feb 2025 09:35:24 +0100
Message-ID: <20250203083606.22864-17-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250203083606.22864-1-nrb@linux.ibm.com>
References: <20250203083606.22864-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Pa2_iY2u6nm9SVWIQO-kuNwN807EM1qJ
X-Proofpoint-ORIG-GUID: Pa2_iY2u6nm9SVWIQO-kuNwN807EM1qJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_03,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502030068

From: Marc Hartmayer <mhartmay@linux.ibm.com>

Since s390-tools commit f4cf4ae6ebb1 ("rust: Add a new tool called
'pvimg'") the genprotimg command checks if a given image/kernel is a
s390x Linux kernel, and it does no longer overwrite the output file by
default. Disable the component check, since a KUT test is being
prepared, and use the '--overwrite' option to overwrite the output.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20241205160011.100609-1-mhartmay@linux.ibm.com
[ nrb: re-wrapped commit message ]
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index e5572cb6..8970a85b 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -182,17 +182,26 @@ $(comm-key):
 %.bin: %.elf
 	$(OBJCOPY) -O binary  $< $@
 
+define test_genprotimg_opt
+$(shell $(GENPROTIMG) --help | grep -q -- "$1" && echo yes || echo no)
+endef
+
+GENPROTIMG_DEFAULT_ARGS := --no-verify
+ifneq ($(HOST_KEY_DOCUMENT),)
 # The genprotimg arguments for the cck changed over time so we need to
 # figure out which argument to use in order to set the cck
-ifneq ($(HOST_KEY_DOCUMENT),)
-GENPROTIMG_HAS_COMM_KEY = $(shell $(GENPROTIMG) --help | grep -q -- --comm-key && echo yes)
-ifeq ($(GENPROTIMG_HAS_COMM_KEY),yes)
+ifeq ($(call test_genprotimg_opt,--comm-key),yes)
 	GENPROTIMG_COMM_OPTION := --comm-key
 else
 	GENPROTIMG_COMM_OPTION := --x-comm-key
 endif
-else
-GENPROTIMG_HAS_COMM_KEY =
+# Newer version of the genprotimg command checks if the given image/kernel is a
+# s390x Linux kernel and it does not overwrite the output file by default.
+# Disable the component check, since a KUT test is being prepared, and always
+# overwrite the output.
+ifeq ($(call test_genprotimg_opt,--overwrite),yes)
+	GENPROTIMG_DEFAULT_ARGS += --overwrite --no-component-check
+endif
 endif
 
 ifeq ($(CONFIG_DUMP),yes)
@@ -206,7 +215,7 @@ endif
 $(patsubst %.parmfile,%.pv.bin,$(wildcard s390x/*.parmfile)): %.pv.bin: %.parmfile
 %.pv.bin: %.bin $(HOST_KEY_DOCUMENT) $(comm-key)
 	$(eval parmfile_args = $(if $(filter %.parmfile,$^),--parmfile $(filter %.parmfile,$^),))
-	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify $(GENPROTIMG_COMM_OPTION) $(comm-key) --x-pcf $(GENPROTIMG_PCF) $(parmfile_args) --image $(filter %.bin,$^) -o $@
+	$(GENPROTIMG) $(GENPROTIMG_DEFAULT_ARGS) --host-key-document $(HOST_KEY_DOCUMENT) $(GENPROTIMG_COMM_OPTION) $(comm-key) --x-pcf $(GENPROTIMG_PCF) $(parmfile_args) --image $(filter %.bin,$^) -o $@
 
 $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
 	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
-- 
2.47.1


