Return-Path: <kvm+bounces-36043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A0DAA17077
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 17:44:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5B27169F77
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 16:44:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6110F1EE032;
	Mon, 20 Jan 2025 16:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MJr8eRoJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02341EBA09;
	Mon, 20 Jan 2025 16:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737391450; cv=none; b=BLfjPXPfITSZwNwEV9OpdBNeF0zSFjaoNXtu8kMwCA+4xNiNj7TuUlQpaI472er44kzKXnX8UrkXqARxflJ7DRcpZ7C358TaRVatebOeP6tMybnyE+fFKTZ9Oo4x/SfgnKngyGJ2MtODCfYUCjmtfsmk9ywEWIvRZj6smyk+oos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737391450; c=relaxed/simple;
	bh=Bhaz6HwAMlKSMz7Ft5tGRHH17H9GBssSq5TkTZsy3Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KehidWSkd3OY+oS/cCMjyVv4mmX9i0o3BLRDmw26uuXyypCwUEjYRUk/ngs15rGKbpQI5TAhKWrEt5UU/VHHMu0xa8G89OIXbiwBi2wmJMF67CueLBoWY/qzgNur7/o+SsDy7kIdcAEEjT/eupRqvxX/BIOaY5NAaMq5LZwdmH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MJr8eRoJ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50KF1WYb004516;
	Mon, 20 Jan 2025 16:44:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=XmrgOnz+coGd8vNa0W7ubihq3ILrBNP9i4xzPR4A8
	1Y=; b=MJr8eRoJDoboMgfcS/7PbJcR+DTM7WeHkUNlypNqEbLNfsI/9HnWF+ykK
	w3sfUCHelmItMXjic7f6yG/fpAx7XRLx3E5wmL9B+afQfd2JVWI10YmGIGR+6UKY
	D45I3gBLZnF/5pT26Uy7hpBqx1gn1i1DVAGsqz5Yadi5deWtJMoKqpjMcCTVxsis
	pQMl8tzsfC5OMkADk5tl013CybZJNmf7TkUyUHUD8BGth1Yv36zo42C7UOc/LTjB
	TJoZ6sVa21s1XKWPnV/yYGoEuSD6kvfvEetnsnGoTtvwlXswiIvyQb0t7fKAMHqn
	wX6giEh6FlHdefWPAMuVyVs0MW9tw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 449rry8f13-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 16:44:05 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50KGGRaJ022449;
	Mon, 20 Jan 2025 16:44:04 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 448r4jy3ac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 16:44:04 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50KGi0F557475522
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Jan 2025 16:44:00 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BEE8720049;
	Mon, 20 Jan 2025 16:44:00 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9123320040;
	Mon, 20 Jan 2025 16:44:00 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 20 Jan 2025 16:44:00 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1] s390x: pv: fix arguments for out-of-tree-builds
Date: Mon, 20 Jan 2025 17:43:29 +0100
Message-ID: <20250120164400.2261408-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8_Wu87rllANVlYk7kmNk91Yn-oXAUmbl
X-Proofpoint-ORIG-GUID: 8_Wu87rllANVlYk7kmNk91Yn-oXAUmbl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-20_04,2025-01-20_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 phishscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 bulkscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501200136

When building out-of-tree, the parmfile was not passed to genprotimg,
causing the selftest-setup_PV test to fail.

Fix the Makefile rule s.t. parmfile is correctly passed.

Suggested-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index 23342bd64f44..a6cf3c144fbf 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -218,7 +218,7 @@ else
 	GENPROTIMG_PCF := 0x000000e0
 endif
 
-$(patsubst %.parmfile,%.pv.bin,$(wildcard s390x/*.parmfile)): %.pv.bin: %.parmfile
+$(TEST_DIR)/selftest.pv.bin: $(SRCDIR)/s390x/selftest.parmfile
 %.pv.bin: %.bin $(HOST_KEY_DOCUMENT) $(comm-key)
 	$(eval parmfile_args = $(if $(filter %.parmfile,$^),--parmfile $(filter %.parmfile,$^),))
 	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify $(GENPROTIMG_COMM_OPTION) $(comm-key) --x-pcf $(GENPROTIMG_PCF) $(parmfile_args) --image $(filter %.bin,$^) -o $@
-- 
2.47.1


