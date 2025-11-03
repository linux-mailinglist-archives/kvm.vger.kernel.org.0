Return-Path: <kvm+bounces-61803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5172DC2AD1D
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 10:43:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9753A1892D4E
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 09:43:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 942852F5308;
	Mon,  3 Nov 2025 09:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LodP0x8Q"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4767F2F39BC;
	Mon,  3 Nov 2025 09:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762162981; cv=none; b=YkpdpvVpvFEcmqUu+N3W9LKt7TU3J1VPfPdS5rR3EC4i2SKuxI2i8/ODaOo4UgPCCwPtcDOGdOAH2giQUh3eJHrKB2B50wh/oFu80oIrvRxl58ZNlactTdZ5RBlU2mKx53QaY/KunjR7H0bu8zuiczjw1QKd74CHlBPXeP1+zkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762162981; c=relaxed/simple;
	bh=VMM7WkrTqK5ZHberSXhN4kmwzR0fhv+CvpkYzVpC8cI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mS0JuB088S8jRzu3Isb0KNkBrXc+RSOndbwNcbxkZLpNF2NfAHbdDL0wn/wxwW0i6hxqIHLI0P2b78n1t7VbOK57dT+23BsngBO1fQpnPH+Zry7Ocx0oNxNsW/5KgrJcVFNFv74GtyN21pT1G48RFtr7R4bxRB1/GSDjMBDRk/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LodP0x8Q; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A2Kt0s9007542;
	Mon, 3 Nov 2025 09:42:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=QvIcX3YAFG7o+1VFLMGKEaZcbpwrRBOZbTrFoCXki
	3U=; b=LodP0x8Q/4bMBB/KCU5ZwzARbvrqXLTy4isbEXmvK5tYvdnOH+0XldQqg
	98tKq8mTb32lZiW1y4SL3QhABnbR4Fby3P5QE2OL6nKl1xD5hR06x9CgRZDeIrdT
	k1DAlxc3XZId9dpO+Y++8XZUFWSFTHgX5K+dSIGex49AvF7JFWICkwuv6Ix0Mknx
	cpYDIV8IhqSQWWGfbM+Lo3dy0df72oYESIHf4Fs/jg7jKpiDLJDM3dDCc1cJweK+
	rZMfm0ChqpzgPXeh+TrHdzEbWho78UzdmhBKoRJkwi81E+nWjS/5UZA3x7myN3IE
	nTD58//jAG6Wo0xApeErZv0f+oHTw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59vu5v4s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Nov 2025 09:42:55 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5A39gt1F024527;
	Mon, 3 Nov 2025 09:42:55 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59vu5v4q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Nov 2025 09:42:55 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A37Wcuc018667;
	Mon, 3 Nov 2025 09:42:54 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a5whn4xfh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Nov 2025 09:42:54 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A39goqH34013662
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Nov 2025 09:42:50 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1893020043;
	Mon,  3 Nov 2025 09:42:50 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A4D1E20040;
	Mon,  3 Nov 2025 09:42:48 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.43.78.64])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Nov 2025 09:42:48 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: maddy@linux.ibm.com, npiggin@gmail.com, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
Cc: Gautam Menghani <gautam@linux.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS : Add myself as reviewer for PPC KVM
Date: Mon,  3 Nov 2025 15:12:43 +0530
Message-Id: <20251103094243.57593-1-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nMMvrVO35cp6ftXiOuCho-PDF9hF2OoG
X-Proofpoint-GUID: 2b8DNA0x1DEN-VD5dvQueVzgoZyig-wY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAyMSBTYWx0ZWRfX37waHzcThYpx
 w9+IG7kyePN+Twb8C41xxYSlTiVjGD/nX0U7oxBmfrcTcrUiM7+VSH0Eg1t3RTKAwN2kTkEX+Kp
 dX0EEbimSosaT72DrggbHe9zaToxqZseYDs3Vgs1TMPYYv6Q6UsnqUu7gyfb6fxPwHOPl9WTnJA
 H6v3HNzJmUvOosr9/uO6Xqk2j7BL4yes8LKFrZLYwVaTzTqcS8DaYXcpmawVO9NxD5jpc4VZgw0
 dAstXywSuPChmLVfw0M79bHpYOSS0btHG8MXVmAl4bk5ggqLSv1RcE3UjdBiN1FC8acqSYedjAo
 U0Pj8u5zv5VlQN277G3+kP4Z1UXa+pz3B6J1VGns7MYKzwzaQGD/bymad16ff6P3ZzgOpPasfFK
 FMUsRuQ1J7rdxXmtip570rfEf411Gw==
X-Authority-Analysis: v=2.4 cv=U6qfzOru c=1 sm=1 tr=0 ts=6908791f cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8 a=pGLkceISAAAA:8
 a=voM4FWlXAAAA:8 a=VwQbUJbxAAAA:8 a=yhTyijjmqU1LCZgUPtIA:9
 a=IC2XNlieTeVoXbcui8wp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-02_02,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 impostorscore=0 spamscore=0 phishscore=0
 clxscore=1015 malwarescore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511010021

I have been contributing to PPC KVM for sometime now and would like to get
notified of incoming changes to help with code reviews as well.

Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 46bd8e033042..3f2f60486222 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13701,6 +13701,7 @@ F:	arch/mips/kvm/
 KERNEL VIRTUAL MACHINE FOR POWERPC (KVM/powerpc)
 M:	Madhavan Srinivasan <maddy@linux.ibm.com>
 R:	Nicholas Piggin <npiggin@gmail.com>
+R:	Gautam Menghani <gautam@linux.ibm.com>
 L:	linuxppc-dev@lists.ozlabs.org
 L:	kvm@vger.kernel.org
 S:	Maintained (Book3S 64-bit HV)
-- 
2.51.0


