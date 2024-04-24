Return-Path: <kvm+bounces-15797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E3E78B07EB
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 13:01:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3BD331F233AB
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 11:01:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E267715A49F;
	Wed, 24 Apr 2024 11:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QHLE6bUq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDEF15B13B
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 10:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713956400; cv=none; b=ckKY3Z7ga4ulaJcx9yM8ai+v/mCC4KXvBTqiNbcqCbxzPTwWJ8NMd8zw8sYcKdpxskLdB+uaswinRpXcoo/DB3trXGsLjB+Fli9T24NweSdpbpwuyR1YnWeigpryC8Rs8O1x5I1HDrPc91UAP3YcJPP7mPv/aj6STmm2xILKKy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713956400; c=relaxed/simple;
	bh=+AeKnnQMKECDOKFcK0V6lZgf6pvUivRxvhO6ILY3fnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=laAPq/VPUgHTiNTsY+VoJG/FQBSQpR0+MFMf2VEv3n5Gpfld6A8AlE9+ADbHLBTBV08pfZ+6lHrKG6wzjaTBkBlxUTMmV00UAOgetg3om33bik603p1r9UHXUbL+A/Q/zGso4G5vXWaMTTxySKAmN5AsPQwLE9ppt295cBnG/0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QHLE6bUq; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43OAdwD8014746;
	Wed, 24 Apr 2024 10:59:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=psZLDuBo7k6QuKOK+9njydy/ztQa22zUioypJT3sums=;
 b=QHLE6bUqtn7UiCPppcG6Sm3x73A2QFfLC00a1C/4K1Dcr9NTHEGdiD3rllzKgZMDYJVy
 Z3oATPaTpyWaItX96bGJIhk7vvM3zOdgWA2JeR22WUWbkwBVcmyAx5FQW8jx6tsCkvoY
 6w1hJcXE/thRFZu6qoJ/sDkAC83CWGubIZJ7yfqSr2Kd5mlSESqBSZJxUrh51aO3V9R4
 nPCPLQoV5SA5LCXsieUWrwuIvPjX2mqcyt74p8jP5oiUZcTi4krZ+xgeR8eT/926OdxG
 t4rbQEmSGgheiwusPrrULQyg6DBm8f4vWwXLF42QhT8PehLovt2RIw5beDJprAorYBos KA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xpy12g6xt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:50 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43OAxos0015491;
	Wed, 24 Apr 2024 10:59:50 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xpy12g6xr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:49 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43O8rcbX015299;
	Wed, 24 Apr 2024 10:59:48 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xmshmb25d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:48 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43OAxh5Y51118414
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Apr 2024 10:59:45 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 35D8820067;
	Wed, 24 Apr 2024 10:59:40 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 084F82006A;
	Wed, 24 Apr 2024 10:59:40 +0000 (GMT)
Received: from t14-nrb.boeblingen.de.ibm.com (unknown [9.152.224.21])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Apr 2024 10:59:39 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 08/13] s390x: add pv-attest to unittests.cfg
Date: Wed, 24 Apr 2024 12:59:27 +0200
Message-ID: <20240424105935.184138-9-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424105935.184138-1-nrb@linux.ibm.com>
References: <20240424105935.184138-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Uvn8KpEMLGZz8hLCnY2PbAnMqHqlNSnM
X-Proofpoint-ORIG-GUID: 4NsEBZX7fYjN9MGwV6e72ygemfmbs4wm
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 mlxscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404240045

There seems to be no obvious reason why it shouldn't be there.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20240201100713.1497439-1-nrb@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/unittests.cfg | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 3fb9e875..3a9decc9 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -389,3 +389,6 @@ extra_params = """-cpu max,ctop=on -smp cpus=1,drawers=2,books=2,sockets=2,cores
 
 [sie-dat]
 file = sie-dat.elf
+
+[pv-attest]
+file = pv-attest.elf
-- 
2.44.0


