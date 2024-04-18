Return-Path: <kvm+bounces-15068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A2428A9814
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 13:01:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EEA101F21A57
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 11:01:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9374315E1FB;
	Thu, 18 Apr 2024 11:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aW9YowTr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7528D15E1FC
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 11:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713438111; cv=none; b=Wikt5IzQJ0UBIeCV7GAr/VUZMGAQX8pOZA8le7VTSfMKV9GmsV2W152hEoXKyBAU2K9LKy8JSNTGzc9zRSaV+J3SjisCkU0SQTvquIQEDSu/ZN0hrDM3Ym5FwBQ8sGzSCbr5SzUTHX9fpkKlCqcc4jyfFQVe6dkO5ZmlF7UNVuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713438111; c=relaxed/simple;
	bh=13nhuonmBLYSNOad7B48j6rx0irTpmy1jQIUVp2xOVc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a7Hu6ACVTAPCUUmuVOvM74jgEPFdqqqdrNfxvUoo/ilPoYoNEdqBVSseF2oN4t1x5UDWS6W/CJOicXWQqqTxzeek3Vo9cqtaOywRKb6gDQJ3l2t/QiQvXm1wgADA2sxbyYr6tc0g33SgYVV/S8AbvP0ZuFmv8gDO6i3MwCDxMMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aW9YowTr; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43IB18Vq007884
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 11:01:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=w9JlTb4LRoUj1d0Ut/33Ur60jjyNG3lXKI1iX5T8BiM=;
 b=aW9YowTrmq7RqI6SHbCOOvPcbnCDe67rqNibs+Lysf6TFjeSV89EWVXMM2JAy12bkpl7
 ZuLoncjGNwiTVzI/P7sULUbWrTloh+LLYpjKajUmLs1q4D8abiwwFI1TLUFssXT9JAGI
 XNU0d41XYdZQkj5LHrRLsICVvEsd8ad28tPYg9XMx//PEe0mQonSYKTAv4egv1uRTxdO
 9XTzNR42BbrBXuLiu2BiXsyzbepmf36zJNQpDjgctbOvYsbxEVF7Mhsu21s0d8ZJS9DM
 lsucasfELTD1AVE7jmNcx1wkaVyhQirvFY+D7rz2+ZTaG3XczIVaWlY7ezEXDhKSwbxn qg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xk28p0071-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 11:01:47 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43IB1lNZ008683
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 11:01:47 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xk28p006y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Apr 2024 11:01:47 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43I7P6Tp027289;
	Thu, 18 Apr 2024 11:01:46 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xg4s0absv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Apr 2024 11:01:46 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43IB1fAY13304220
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Apr 2024 11:01:43 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1CED320067;
	Thu, 18 Apr 2024 11:01:41 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E83B22004E;
	Thu, 18 Apr 2024 11:01:40 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Apr 2024 11:01:40 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: nrb@linux.ibm.com, frankja@linux.ibm.com
Cc: david@redhat.com, thuth@redhat.com, kvm@vger.kernel.org
Subject: [PATCH v1 1/1] lib: s390: fix guest length in uv_create_guest()
Date: Thu, 18 Apr 2024 13:01:40 +0200
Message-ID: <20240418110140.62406-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fN-P5zq47xreNYRgC5fYmKBWWuSxKVCy
X-Proofpoint-ORIG-GUID: d6qjpKE8K8Xl05ejCvxN26jQOfMU9LEF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-18_09,2024-04-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 impostorscore=0 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404180078

The current code creates secure guests with significantly more memory
than expected, but since none of that memory is ever touched,
everything still works.

Fix the issue by specifying the actual guest length.

The MSL does not contain the length of the guest, but the address of
the last 1M block of guest memory. In order to get the length, MSO
needs to be subtracted, and 1M needs to be added.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/uv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
index 23a86179..723bb4f2 100644
--- a/lib/s390x/uv.c
+++ b/lib/s390x/uv.c
@@ -146,7 +146,7 @@ void uv_create_guest(struct vm *vm)
 	int cc;
 
 	uvcb_cgc.guest_stor_origin = vm->sblk->mso;
-	uvcb_cgc.guest_stor_len = vm->sblk->msl;
+	uvcb_cgc.guest_stor_len = vm->sblk->msl - vm->sblk->mso + SZ_1M;
 
 	/* Config allocation */
 	vsize = uvcb_qui.conf_base_virt_stor_len +
-- 
2.44.0


