Return-Path: <kvm+bounces-39570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EBA7A47E98
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 14:11:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E75CE1891D0C
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 13:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3A5122F167;
	Thu, 27 Feb 2025 13:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jnEKSkRn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB1F224246;
	Thu, 27 Feb 2025 13:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740661840; cv=none; b=ESQFcRFpLI0QJXmNc/+CGJdNmaJyzQCFIJ+QQroJzOz5Kc9S78AdN53j+4lTSkmhCCNpHTf5ZSW9jE5zaRt7f1Xg2zUg7/e60awpRPBQxEq3s6MEIDRl5UN8dBOhTpunSOqAGh0kNONwFiMP9zYral1NirULrrXeDlkJswPYke0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740661840; c=relaxed/simple;
	bh=WeOKcXNNwvX8YtSHvDdZKzG7v2fT3IaDYq2EJKKIiZo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T0crvDt96guLh95kw2142behBqXBWl45zz+rA20BZFe7ofRUzSxrJzKNjGY0UD5LOL2PbGo8KFKEIG+JbiQC8iUcTkN86Elp4GjHWKb2O8yzB2OstwoVlWVLmMfU6m7Htg2oKb6TP6aMEs7Nfsjrr0V5qSdW7pIC+b+rgRkTtyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jnEKSkRn; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51R6Pgt7007171;
	Thu, 27 Feb 2025 13:10:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=sq2khIOyh56V9eMmcUwZHVfAwmWJQcXauAglqm6YA
	6M=; b=jnEKSkRnT6CAg8yCFLqiXtLyS2RKEVAfyAS5FhATxnSz2sfB2iOIW2rdq
	Re0ozAEDBfyQ+ushe4Aagl99hOMOTS+lSW4EEsCGT49Jo372mvMAE/tHvv4RttpZ
	Xym7huEwHLXuVJFLgx64DutYs5xUCHFHoHvdtx1TJEtGOE6VwOgO311a9upwyB6c
	NKmKwP3FlBRDboVQWcK0KWJsBWDF2EfQpI5LyBdG7JWC9ej1uHNjImmnbfjtbwZX
	zsB9YfVuRk+ylOGa1fHkohyDx70tiTypNXzfx8++eI3wnhruldJifWdfEBGesvBG
	j+KgPrdSNmEnu+YQBkyplHthXQGRQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 452js6suc8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Feb 2025 13:10:36 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51RBc5hc012100;
	Thu, 27 Feb 2025 13:10:35 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44ys9yrxr2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Feb 2025 13:10:35 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51RDAVke44630418
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Feb 2025 13:10:31 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B484D2004B;
	Thu, 27 Feb 2025 13:10:31 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B5C120040;
	Thu, 27 Feb 2025 13:10:31 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 27 Feb 2025 13:10:31 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1] s390x: pv: fix arguments for out-of-tree-builds
Date: Thu, 27 Feb 2025 14:10:20 +0100
Message-ID: <20250227131031.3811206-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9TmHCsuHeQEZuSVk1LOOD-MKHSMBtjIF
X-Proofpoint-ORIG-GUID: 9TmHCsuHeQEZuSVk1LOOD-MKHSMBtjIF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-27_06,2025-02-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 priorityscore=1501 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 adultscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502270099

When building out-of-tree, the parmfile was not passed to genprotimg,
causing the selftest-setup_PV test to fail.

Fix the Makefile rule s.t. parmfile is correctly passed.

Suggested-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index 47dda6d26a6f..97ed0b473af5 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -213,7 +213,7 @@ else
 	GENPROTIMG_PCF := 0x000000e0
 endif
 
-$(patsubst %.parmfile,%.pv.bin,$(wildcard s390x/*.parmfile)): %.pv.bin: %.parmfile
+$(TEST_DIR)/selftest.pv.bin: $(SRCDIR)/s390x/selftest.parmfile
 %.pv.bin: %.bin $(HOST_KEY_DOCUMENT) $(comm-key)
 	$(eval parmfile_args = $(if $(filter %.parmfile,$^),--parmfile $(filter %.parmfile,$^),))
 	$(GENPROTIMG) $(GENPROTIMG_DEFAULT_ARGS) --host-key-document $(HOST_KEY_DOCUMENT) $(GENPROTIMG_COMM_OPTION) $(comm-key) --x-pcf $(GENPROTIMG_PCF) $(parmfile_args) --image $(filter %.bin,$^) -o $@
-- 
2.47.1


