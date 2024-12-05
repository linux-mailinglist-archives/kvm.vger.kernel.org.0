Return-Path: <kvm+bounces-33163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CE0669E5A9F
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 17:02:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 721281698B3
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 16:01:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC422225777;
	Thu,  5 Dec 2024 16:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZvknxtmE"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C32222584;
	Thu,  5 Dec 2024 16:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733414433; cv=none; b=NwNehCWWs+umfJzCfKm9zbTDYvMKqWb0SS0PxrnWL7pYkVJ+TXRHXGknb8Jn93LqlSbG+AbJxBrqkNQo5OYZpOv5Z79RX5A0B9wOEWbcwXYaf/tXdQVkDMRy6x7k9/u3RGXbGB+9uXg8evRnKPTbbAa7ZNxGuw0WeEK8eUGYwNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733414433; c=relaxed/simple;
	bh=Y3BC4etPPl/b4w9eUGX/QBIjVLYvrkp6s24ROrPuWho=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kDVt6pxDCaUQmepyLbPFqZayPwbU7hI0tUG9ZDFwpLhmD4VNExc03vR4WDOps+wEljR90pzgc1XDN+5jgzU4Hm5IBE0UiZOqTCGzx/iTpTxvivRDt9Jr+xAKziMjEN0q8sej/ODyqg1aWckTOpKYgv9Z8K7qz2/hUEBI4/s+74g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZvknxtmE; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5FiQOO030884;
	Thu, 5 Dec 2024 16:00:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=jD/Em2Ai3/jlpSYYChWHqflvo706SNuYTQqdF1rgf
	tg=; b=ZvknxtmEHJK7kbguRwi6TjoI5LXbfKEWpYH9RWj8ZpzXQegOB3nuftVz9
	RQqZcg4eZ2JyiJklmWzrjl49JwDyUU7+/7KcjpKkRWTbLcOANuEl90ILbeGUzvxL
	Ay0Ymx/+HuiEGxtZAqNN+uLLrzFw59dgmeHa3m/UCi6IPedZzxaGgtENijjzEWr1
	sG4+mqnOXQnkjijFUF2SpHEECyJaAA+005heZMZaBCbvnrzFqX7C/NoBHWToJcJ+
	I50gJ75O3g/AAjvaKHAwLLp5XmW8lzbQlpalCIqREC1fXnjkr+ZkJfE9Rxo1izK4
	sWhIAfd5cXaFccOzlIQQNeUD9MdKw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43b6hb2wu9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Dec 2024 16:00:27 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5FWIqm006819;
	Thu, 5 Dec 2024 16:00:26 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 438f8jtej2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Dec 2024 16:00:26 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4B5G0NL718546992
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Dec 2024 16:00:23 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 257C520040;
	Thu,  5 Dec 2024 16:00:23 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B968920043;
	Thu,  5 Dec 2024 16:00:22 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com.com (unknown [9.179.10.218])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  5 Dec 2024 16:00:22 +0000 (GMT)
From: Marc Hartmayer <mhartmay@linux.ibm.com>
To: <linux-s390@vger.kernel.org>, Thomas Huth <thuth@redhat.com>
Cc: <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH] s390x: Support newer version of genprotimg
Date: Thu,  5 Dec 2024 17:00:11 +0100
Message-ID: <20241205160011.100609-1-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3bV3g36pHsuvoc_6hfXyEo_uXePSOVgR
X-Proofpoint-GUID: 3bV3g36pHsuvoc_6hfXyEo_uXePSOVgR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 clxscore=1011 impostorscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412050116

Since s390-tools commit f4cf4ae6ebb1 ("rust: Add a new tool called 'pvimg'") the
genprotimg command checks if a given image/kernel is a s390x Linux kernel, and
it does no longer overwrite the output file by default. Disable the component
check, since a KUT test is being prepared, and use the '--overwrite' option to
overwrite the output.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 s390x/Makefile | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index 23342bd64f44..3da3bebb6775 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -197,17 +197,26 @@ $(comm-key):
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
@@ -221,7 +230,7 @@ endif
 $(patsubst %.parmfile,%.pv.bin,$(wildcard s390x/*.parmfile)): %.pv.bin: %.parmfile
 %.pv.bin: %.bin $(HOST_KEY_DOCUMENT) $(comm-key)
 	$(eval parmfile_args = $(if $(filter %.parmfile,$^),--parmfile $(filter %.parmfile,$^),))
-	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify $(GENPROTIMG_COMM_OPTION) $(comm-key) --x-pcf $(GENPROTIMG_PCF) $(parmfile_args) --image $(filter %.bin,$^) -o $@
+	$(GENPROTIMG) $(GENPROTIMG_DEFAULT_ARGS) --host-key-document $(HOST_KEY_DOCUMENT) $(GENPROTIMG_COMM_OPTION) $(comm-key) --x-pcf $(GENPROTIMG_PCF) $(parmfile_args) --image $(filter %.bin,$^) -o $@
 
 $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
 	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<

base-commit: 0ed2cdf3c80ee803b9150898e687e77e4d6f5db2
-- 
2.47.1


