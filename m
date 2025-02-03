Return-Path: <kvm+bounces-37108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DACB8A2548C
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 09:37:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC2073A4F8D
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 08:37:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4C85207A25;
	Mon,  3 Feb 2025 08:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lu8+wmeX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A822066FD
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 08:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738571809; cv=none; b=Tj/EY9D1Hfntv2Orm9LLx5Ggo6NRIbHxHQ1XB6ZCyibqmQtL/D+y5fqn01b7m/NmXt8oFxzTbQM3dfv80PxN6QEh5pDboNlzpRM7I5spXaEccK6UjL1oUdsmgCoJ+0AB0N9kW42T7QVv7N3T9L4rxPB3aa4nO4lPAtj7uiWdBjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738571809; c=relaxed/simple;
	bh=o4HClkW9EZDL1ZWfTKxgiodH/+5gSjgtu37be43xmS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkppGP4KRT1YZXB85YNOGd1mT+H8AP0zQOOowkk9BsqilX/uXSaacTWOoW1KvUQqKboOjEfsQ6volWRVFEZfCimIzWwZ/9R48KLdZB8xTePbVZPiwqXBPo7kqw/9c8rxRpMdkPTOCKaR6zhWLTCo3EroV54yo/KqquzFJsj3smE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lu8+wmeX; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 512NkVYc003245;
	Mon, 3 Feb 2025 08:36:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=JJe7eTSjIdWlLw1gF
	mc3NDBc1Gs5MJuuRX7PV6TZDdE=; b=lu8+wmeXXi26Re5tMW3zzSKxk174L6XdN
	uqyB2BUNx7zmMF3xAPElBckzl3c3LBZsq0xwK0VysB9OoDmcNRhHQRGWfs4KA9FH
	tYc9FHcFRYD5+Rqw+KWk70D/8MtbfnossZbDGBo3rPY5IuedVbvCBcFD9RqpCjIM
	F99UjthyNV3fK5k137YV8oADPBu/r7dlzeuU01XrW8iAuRAzRLiiREzvAGF6ICyR
	YDnEmrBvM9g5rcbb+tOquS6cnvTCR13R/4v+c1gvzTZZq1IqWUcdyZ3SGTV+VrpM
	PFCYdPr+7lg8M1r7idEqMgbjO0zp948R8+1JypH7LJH2AvkaOfcWw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44jbht2xd8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:37 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5137xAAR024506;
	Mon, 3 Feb 2025 08:36:37 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44hxxmwe62-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:37 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5138aXbC34406814
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Feb 2025 08:36:33 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6A19B20040;
	Mon,  3 Feb 2025 08:36:33 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F06C220043;
	Mon,  3 Feb 2025 08:36:32 +0000 (GMT)
Received: from t14-nrb.lan (unknown [9.171.84.16])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Feb 2025 08:36:32 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 17/18] s390x/Makefile: Make sure the linker script is generated in the build directory
Date: Mon,  3 Feb 2025 09:35:25 +0100
Message-ID: <20250203083606.22864-18-nrb@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: AI9Obrac0Gfxs__74b67CyH81bShoI8Q
X-Proofpoint-GUID: AI9Obrac0Gfxs__74b67CyH81bShoI8Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_03,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 impostorscore=0 phishscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2501170000 definitions=main-2502030068

From: Marc Hartmayer <mhartmay@linux.ibm.com>

This change makes sure that the 'flat.lds' linker script is actually
generated in the build directory and not source directory - this makes a
difference in case of an out-of-source build.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20250128100639.41779-2-mhartmay@linux.ibm.com
[ nrb: use TEST_DIR instead of s390x, wrap commit msg ]
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index 8970a85b..eb3d5431 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -167,8 +167,8 @@ lds-autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d -MT $@
 	$(CC) $(CFLAGS) -c -o $@ $< -DPROGNAME=\"$(@:.aux.o=.elf)\"
 
 .SECONDEXPANSION:
-%.elf: $(FLATLIBS) $(asmlib) $(SRCDIR)/s390x/flat.lds $$(snippets-obj) $$(snippet-hdr-obj) %.o %.aux.o
-	@$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \
+%.elf: $(FLATLIBS) $(asmlib) $(TEST_DIR)/flat.lds $$(snippets-obj) $$(snippet-hdr-obj) %.o %.aux.o
+	@$(CC) $(LDFLAGS) -o $@ -T $(TEST_DIR)/flat.lds \
 		$(filter %.o, $^) $(FLATLIBS) $(snippets-obj) $(snippet-hdr-obj) || \
 		{ echo "Failure probably caused by missing definition of gen-se-header executable"; exit 1; }
 	@chmod a-x $@
-- 
2.47.1


