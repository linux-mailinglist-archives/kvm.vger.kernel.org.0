Return-Path: <kvm+bounces-37114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C8B4AA25490
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 09:38:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F8AF162609
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 08:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00CF0207E0E;
	Mon,  3 Feb 2025 08:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RGJWXad2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8465207A34
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 08:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738571812; cv=none; b=OmQz2GZXIO/d9lEuUnCu6r2eRPtqjKwDryAHNTiH3WDeNHVbmMu8Hsf8CAehEvqrM4edQExtha4qhA3cyF4naYEpGgX2HULk10LsRZy3Cwaj7rIOTWmIywweT+NkRAwVJyJpfRNTwZdZU5h/XQd5AcI8sQS7mV5N+R4PxrH097c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738571812; c=relaxed/simple;
	bh=QgIgDmHBWQLIlLmPXvPPpAH6TyX/HsFAOYoG09vxduc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqN/TPvZ4sDRWrbsCarUnzC66lRzrzSiD52dG3DCTYxMu6oJZlmCKTujHAHt380CggujDsDDdK2pjc/j/u+yj6ue2LB/BcFHl8wSGrhZncU+pTed1OwuFngXzPwc+O8AeTa2LJY2fPJj5Ne5zXxOMpzis5dyics66XVc9bnT4QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RGJWXad2; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 512Lkikh027628;
	Mon, 3 Feb 2025 08:36:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=rK7nLPSkYzBi6IbwR
	YJCpEg+Y2mdefaJ0CHctJF3igg=; b=RGJWXad2LMB0pdklBmUeA3q7T6ff5Mkn+
	zbJfCHtxx42o/ZtHcgKFDSxsQ/UfxzbsDECIxz7Mq/323lMykqVeqOwcZY7CHl5Y
	QahzGtK9+xLUxoD/iDDE/jrUcL4/oNp4CBXS4CvnOZSjuQ7FsDWQolQG5Bwbp1qu
	CcLbD5ShGFpRpGcSLFtwtYZHQZaPg1I7jMZsI96RUttGB94iKmiLYoyIkYYONvyS
	Cl3DeYexmmP9v5U4QtZMpxm6/kQXHVes8hZQR8gBfOUGDdBVFvPt52XzWqklMEOp
	hBDaqWbCGfYSnxy+4HqeWR8IK+cyqP1AcyoZAxiq/cV+mM0Azo6jw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44jayyba24-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:36 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5134qERh021483;
	Mon, 3 Feb 2025 08:36:35 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 44j0n153hn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:34 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5138aV0447382874
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Feb 2025 08:36:31 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4572520040;
	Mon,  3 Feb 2025 08:36:31 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CD7C520043;
	Mon,  3 Feb 2025 08:36:30 +0000 (GMT)
Received: from t14-nrb.lan (unknown [9.171.84.16])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Feb 2025 08:36:30 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 13/18] s390x/Makefile: Add more comments
Date: Mon,  3 Feb 2025 09:35:21 +0100
Message-ID: <20250203083606.22864-14-nrb@linux.ibm.com>
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
X-Proofpoint-GUID: 81eXtxhi3KNkLeOwt_nLhjOWECsOX_t2
X-Proofpoint-ORIG-GUID: 81eXtxhi3KNkLeOwt_nLhjOWECsOX_t2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_03,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501
 phishscore=0 impostorscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2501170000 definitions=main-2502030068

From: Janosch Frank <frankja@linux.ibm.com>

More comments in Makefiles can only make them more approachable.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20240806084409.169039-3-frankja@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/s390x/Makefile b/s390x/Makefile
index e41a6433..63e96d86 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -51,12 +51,15 @@ pv-tests += $(TEST_DIR)/pv-diags.elf
 pv-tests += $(TEST_DIR)/pv-icptcode.elf
 pv-tests += $(TEST_DIR)/pv-ipl.elf
 
+# Add PV host tests if we're able to generate them
+# The host key document and a tool to generate SE headers are the prerequisite
 ifneq ($(HOST_KEY_DOCUMENT),)
 ifneq ($(GEN_SE_HEADER),)
 tests += $(pv-tests)
 endif
 endif
 
+# Add binary flat images for use in non-KVM hypervisors
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 ifneq ($(HOST_KEY_DOCUMENT),)
 tests_pv_binary = $(patsubst %.bin,%.pv.bin,$(tests_binary))
@@ -146,6 +149,7 @@ $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/loop.gbin
 $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-icpt-vir-timing.gbin
 $(TEST_DIR)/pv-ipl.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-diag-308.gbin
 
+# Add PV tests and snippets if GEN_SE_HEADER is set
 ifneq ($(GEN_SE_HEADER),)
 snippets += $(pv-snippets)
 tests += $(pv-tests)
@@ -154,6 +158,7 @@ else
 snippet-hdr-obj =
 endif
 
+# Generate loader script
 lds-autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d -MT $@
 %.lds: %.lds.S $(asm-offsets)
 	$(CPP) $(lds-autodepend-flags) $(CPPFLAGS) -P -C -o $@ $<
-- 
2.47.1


