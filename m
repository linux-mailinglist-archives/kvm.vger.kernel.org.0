Return-Path: <kvm+bounces-20687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EFA3291C3D7
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 18:38:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 971DC284E07
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 16:38:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 345451C9ED8;
	Fri, 28 Jun 2024 16:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="F9/8Xzhw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A641C9EA1;
	Fri, 28 Jun 2024 16:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719592672; cv=none; b=cZlFZN8ntvzipt2feH5lPqKWClIgpDVa7ee9te5OL7Hd0Qr908rYS73FyJv5S3MPierFJZt2ZNKinwVIwufzhiDx5g7E1beG21m0quNBnhKX/jJvPQnFkyIH5Ajyr3Jge9AGtQy6Fj2O57+WdxKzCrt2QPCMpoMArWLMv51zXOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719592672; c=relaxed/simple;
	bh=diDmk6lh36euLLibWiB8nlrDa2dMe9l4zluxmU6MhH0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Lmz2TMWYxRRSgiQiKJjfDh8EiICxsMUdoOGSKbO9LYiqbjwPWwKBz37ml1X4RNcjcYIAGYM3TWb6BmKBrPZqxdmi2yWmPRJmQ9qe/TdA3ZlHhipkTPUBBIPOSGd7AYZXl/CbEcDR1YAr38r5ivy+C7n3yHewPRa7ZyzhmmyQa6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=F9/8Xzhw; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45SGbnuK012702;
	Fri, 28 Jun 2024 16:37:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:content-transfer-encoding
	:mime-version; s=pp1; bh=w7Af+UOzoo5Wr5+ifRNqH5SY/bGEakCOIUhRmiA
	YMlo=; b=F9/8Xzhwqsy4aWuDL1R4KoFXRi4QEDr2+psd6rybTfeuRhrxlTBo7ky
	+lylCgkygZi4ZrWNWCESchAkAIpZ45lFWiI3PbIR8UrAtIjRctaqqlo6JhoHzEo+
	FoL5sRJJQ6cy16Qq7kBG9NZNNhy/teTn1p3k81c+ayD1yJ2nymSBhteyM5dMe1cd
	8Nuad1YLg8XG+AIlRvXmIZDdxeT+rHuxTe8KEnatHdhNqYadOwwaqmpahfo0Wxsi
	x8BYXpoKwRZc72IF2sx1ko0L2jPp3ukqUDkPqImG5CHisMXvDZQvsc5BvJ5qiMaD
	y4QaguKOsELnH2OMLuN7az8YcKNjJyw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 401kyustbf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 16:37:48 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45SGQupj018099;
	Fri, 28 Jun 2024 16:37:48 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yx8xusj7y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 16:37:48 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45SGbg0D53608822
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Jun 2024 16:37:44 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 982102004D;
	Fri, 28 Jun 2024 16:37:42 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 87E8120040;
	Fri, 28 Jun 2024 16:37:42 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 28 Jun 2024 16:37:42 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
	id 1A87FE030B; Fri, 28 Jun 2024 18:37:42 +0200 (CEST)
From: Eric Farman <farman@linux.ibm.com>
To: Matthew Rosato <mjrosato@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Cc: Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2] s390/vfio_ccw: Fix target addresses of TIC CCWs
Date: Fri, 28 Jun 2024 18:37:38 +0200
Message-Id: <20240628163738.3643513-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5TU4kN3lpvoabxDI51DFBc5F9VIQaKSQ
X-Proofpoint-ORIG-GUID: 5TU4kN3lpvoabxDI51DFBc5F9VIQaKSQ
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-28_12,2024-06-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 mlxscore=0 suspectscore=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2406140001
 definitions=main-2406280121

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

Notes:
    v2:
     - [HC] Fix dma32/int warning on make C=1
     - [HC] Rename cda variable to offset
     - [HC] Fix similar bug in cp_update_scsw()
    v1: https://lore.kernel.org/r/20240627200740.373192-1-farman@linux.ibm.com/

 drivers/s390/cio/vfio_ccw_cp.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 6e5c508b1e07..5f6e10225627 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -490,13 +490,14 @@ static int ccwchain_fetch_tic(struct ccw1 *ccw,
 			      struct channel_program *cp)
 {
 	struct ccwchain *iter;
-	u32 cda, ccw_head;
+	u32 offset, ccw_head;
 
 	list_for_each_entry(iter, &cp->ccwchain_list, next) {
 		ccw_head = iter->ch_iova;
 		if (is_cpa_within_range(ccw->cda, ccw_head, iter->ch_len)) {
-			cda = (u64)iter->ch_ccw + dma32_to_u32(ccw->cda) - ccw_head;
-			ccw->cda = u32_to_dma32(cda);
+			/* Calculate offset of TIC target */
+			offset = dma32_to_u32(ccw->cda) - ccw_head;
+			ccw->cda = virt_to_dma32((void *)iter->ch_ccw + offset);
 			return 0;
 		}
 	}
@@ -914,7 +915,7 @@ void cp_update_scsw(struct channel_program *cp, union scsw *scsw)
 	 * in the ioctl directly. Path status changes etc.
 	 */
 	list_for_each_entry(chain, &cp->ccwchain_list, next) {
-		ccw_head = (u32)(u64)chain->ch_ccw;
+		ccw_head = dma32_to_u32(virt_to_dma32(chain->ch_ccw));
 		/*
 		 * On successful execution, cpa points just beyond the end
 		 * of the chain.
-- 
2.40.1


