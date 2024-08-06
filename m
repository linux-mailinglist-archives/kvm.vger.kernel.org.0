Return-Path: <kvm+bounces-23328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CC7E9948B8B
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 10:46:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 64635B2479B
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 08:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE9CA1BDA9E;
	Tue,  6 Aug 2024 08:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="h8EGCOZl"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF33813A884;
	Tue,  6 Aug 2024 08:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722933949; cv=none; b=FjAKoW5t+QKt5aDul1tks0hCGaI8/lJr+k0R2M3m+rrH9RqK42YjhAZPFaLdn/8AEjMrxdhflNreUL+s8sNoq4f9z1ZSPRY5IPElwec5dW9ySc4lkvoLs3ElFFkDGgSV3JCmJcv0GJIS8W5bpFcDqR4CRWwsOKRfJ1KF66i4S+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722933949; c=relaxed/simple;
	bh=noIaPItZwjlk1PNP9giz5EN1knZ5OX5VbJ8ji4+7Tco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mV/NvX0jtku0zUIVOBg1rN2TXUXOYc9dydMJKQ+cdtQFfnSABRMGtsWVB+GxIgCN0nkemw0x5NXoIlSSbyCjanOLDeW1d1z0xtvyuWJ5Xu4XGjSPQ9sqqD50Pe6/AtzH0gCGNabY7IpsM43wDPhrw+rHIytmNypPQaZUM0i2cnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=h8EGCOZl; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4766wXmH002535;
	Tue, 6 Aug 2024 08:45:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=LxlGasScveNEJ
	SO9FqswPeTgcieOeDFP8kNH0QVHkYA=; b=h8EGCOZl/QQvXnPh9nQY/0+SJz7ic
	tW5c+3pELfCThG7HUcB9//vV0Cxzf3y2Jp/Dza8KcE9fyWTVWgOwnrFHwmqXfdoQ
	P+eaAeyqlTWsDK2E5RCFlqINVJsd600gE9j40kgBW0h1ON+qsOT7Zhtncat9Fgwt
	AmGA8vi16O82IDRsTI5tKNgBS20invK3myiMIDSU69AczGz+IZ4+e8yROmLs9vLN
	oyuZ4uzny7q+xRm8WH5V7lFKNpdn76jhPBsa2D+0OwqQneVVMrjUQkZpQ9STkHEL
	o2oeKSBA8A51ZeLp4zrB12ky53wKhlTFQCDQAPpWZkDbwfmW4kWrjfzew==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40uf1hr7aa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Aug 2024 08:45:40 +0000 (GMT)
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4768jeMP019908;
	Tue, 6 Aug 2024 08:45:40 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40uf1hr7a6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Aug 2024 08:45:40 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 47673t0M024311;
	Tue, 6 Aug 2024 08:45:39 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 40sy90jwm2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Aug 2024 08:45:39 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4768jXRk56230324
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 6 Aug 2024 08:45:35 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C995820067;
	Tue,  6 Aug 2024 08:45:33 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 98C882006A;
	Tue,  6 Aug 2024 08:45:33 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  6 Aug 2024 08:45:33 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
        schlameuss@linux.ibm.com, nsg@linux.ibm.com, npiggin@gmail.com,
        mhartmay@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 2/4] s390x/Makefile: Add more comments
Date: Tue,  6 Aug 2024 08:42:28 +0000
Message-ID: <20240806084409.169039-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240806084409.169039-1-frankja@linux.ibm.com>
References: <20240806084409.169039-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5_B23k4QLYgiPH0VnXup8PuWcqeh_bFj
X-Proofpoint-ORIG-GUID: ubEib-Q9ZX73pK4W09T0ioEbTfux_qxe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-06_06,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 clxscore=1015 spamscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2407110000 definitions=main-2408060060

More comments in Makefiles can only make them more approachable.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/s390x/Makefile b/s390x/Makefile
index aa55b470..f09bccfc 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -49,12 +49,15 @@ pv-tests += $(TEST_DIR)/pv-diags.elf
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
@@ -140,6 +143,7 @@ $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/loop.gbin
 $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-icpt-vir-timing.gbin
 $(TEST_DIR)/pv-ipl.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-diag-308.gbin
 
+# Add PV tests and snippets if GEN_SE_HEADER is set
 ifneq ($(GEN_SE_HEADER),)
 snippets += $(pv-snippets)
 tests += $(pv-tests)
@@ -148,6 +152,7 @@ else
 snippet-hdr-obj =
 endif
 
+# Generate loader script
 lds-autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d -MT $@
 %.lds: %.lds.S $(asm-offsets)
 	$(CPP) $(lds-autodepend-flags) $(CPPFLAGS) -P -C -o $@ $<
-- 
2.43.0


