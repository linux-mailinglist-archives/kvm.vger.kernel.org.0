Return-Path: <kvm+bounces-20623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C58991B019
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 22:08:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39DE31F21EBD
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 20:08:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 775F819CCF9;
	Thu, 27 Jun 2024 20:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hAKUb/Wd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3783945BE4;
	Thu, 27 Jun 2024 20:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719518873; cv=none; b=Jv0Qx5f6hYO0rKsLeG0bl2Av0SjpXDky1On7IdlBPVe7NF0NJZ6zrP229Nc5YXyKXYmx/hjzO1JQbJCugyNTi3YCTCNOdFFjYMZyhg4Xugdg7cpruT7NvGXL3iFSgdwP+YofWPo7aUd+BhrhLeE1LSOkYd510twrCK+hEIJ73II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719518873; c=relaxed/simple;
	bh=83yGZ3R1Ly3XPruqqMAsZ1YGaheFcdjcFyebTzNiK18=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WIxHuobZPv5EKuZkqvsMRvQ/C9mPGI79doOvG3VYwJnT3OFwTcMm+1pvO0/fNry4TOaSh8+LOFL5R9k1SNhIT6tcXyPFntM07mpVV1gmHPHTTRrTGFCNWrHFy2J6o34/Uwpa/iQ/X/fa1OS138uXfZHsyK8DxUHGLEtFcemvA7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hAKUb/Wd; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45RJusSN026670;
	Thu, 27 Jun 2024 20:07:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=lvB63fX9XV6cYgWhJCwCq9Puai
	YYLnCqY5W6u+PzBRw=; b=hAKUb/WdLVuZE9z2Fbv3AaHZY6YRu2iU9aLQEfaJ4e
	+XJKf7gcL5cvCfRtnDGvWUkvAtZOKsd/6vQHdwP+Tw3FWuuMs8ktWJ1pRrxd3Y/2
	fXEWV88JfIwrSxrBm3NT+kI+zRLCZv2rSAfRz1nyKlNFdIHxdVytfax6ZY2sn6Ar
	Xsg3UlaBYJglyrHFh+Saa0nnMqIygjWYZKWzqR57LLNHPxeNj81psQSJXyJa1n16
	wdcQHd8gE8EpFVh8BwKd5jGpUCM9gVqF9flF0mqxsohhMdqa43+DV2yYh+e551c3
	PlVH3ySdt49YKmoeJtcGUMrQ/mWzFw7d83yC7t9kYDWQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 401dtyg4nm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 20:07:48 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45RIOhgI000564;
	Thu, 27 Jun 2024 20:07:48 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yxaench6a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 20:07:47 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45RK7g9v18743580
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 20:07:44 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E89A220043;
	Thu, 27 Jun 2024 20:07:41 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D89A42004B;
	Thu, 27 Jun 2024 20:07:41 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 27 Jun 2024 20:07:41 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
	id 78EABE030B; Thu, 27 Jun 2024 22:07:41 +0200 (CEST)
From: Eric Farman <farman@linux.ibm.com>
To: Matthew Rosato <mjrosato@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Cc: Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH] s390/vfio_ccw: Fix target addresses of TIC CCWs
Date: Thu, 27 Jun 2024 22:07:40 +0200
Message-Id: <20240627200740.373192-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Sc4KRCwRu6D9OuaA84j0TJCrPOnfPlVH
X-Proofpoint-ORIG-GUID: Sc4KRCwRu6D9OuaA84j0TJCrPOnfPlVH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-27_14,2024-06-27_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999 adultscore=0
 clxscore=1015 impostorscore=0 mlxscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406270147

The processing of a Transfer-In-Channel (TIC) CCW requires locating
the target of the CCW in the channel program, and updating the
address to reflect what will actually be sent to hardware.

An error exists where the 64-bit virtual address is truncated to
32-bits (variable "cda") when performing this math. Since s390
addresses of that size are 31-bits, this leaves that additional
bit enabled such that the resulting I/O triggers a channel
program check. This shows up occasionally when booting a KVM
guest from a passthrough DASD device:

  ..snip...
  Interrupt Response Block Data:
  : 0x0000000000003990
      Function Ctrl : [Start]
      Activity Ctrl :
      Status Ctrl : [Alert] [Primary] [Secondary] [Status-Pending]
      Device Status :
      Channel Status : [Program-Check]
      cpa=: 0x00000000008d0018
      prev_ccw=: 0x0000000000000000
      this_ccw=: 0x0000000000000000
  ...snip...
  dasd-ipl: Failed to run IPL1 channel program

The channel program address of "0x008d0018" in the IRB doesn't
look wrong, but tracing the CCWs shows the offending bit enabled:

  ccw=0x0000012e808d0000 cda=00a0b030
  ccw=0x0000012e808d0008 cda=00a0b038
  ccw=0x0000012e808d0010 cda=808d0008
  ccw=0x0000012e808d0018 cda=00a0b040

Fix the calculation of the TIC CCW's data address such that it points
to a valid 31-bit address regardless of the input address.

Fixes: bd36cfbbb9e1 ("s390/vfio_ccw_cp: use new address translation helpers")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 6e5c508b1e07..fd8cb052f096 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -495,8 +495,9 @@ static int ccwchain_fetch_tic(struct ccw1 *ccw,
 	list_for_each_entry(iter, &cp->ccwchain_list, next) {
 		ccw_head = iter->ch_iova;
 		if (is_cpa_within_range(ccw->cda, ccw_head, iter->ch_len)) {
-			cda = (u64)iter->ch_ccw + dma32_to_u32(ccw->cda) - ccw_head;
-			ccw->cda = u32_to_dma32(cda);
+			/* Calculate offset of TIC target */
+			cda = dma32_to_u32(ccw->cda) - ccw_head;
+			ccw->cda = virt_to_dma32(iter->ch_ccw) + cda;
 			return 0;
 		}
 	}
-- 
2.40.1


