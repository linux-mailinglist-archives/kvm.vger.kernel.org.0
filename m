Return-Path: <kvm+bounces-15794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B8848B07E7
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 13:01:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7DE5A1C20AA8
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 11:01:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AF0415ADA1;
	Wed, 24 Apr 2024 10:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aKRBmvzR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4957215A492
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 10:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713956397; cv=none; b=fn1Zii0mpboBLO8YBEkW+zYNPXG4Cb77okmsxdo9jIFeqL4eL57+EeH83In1ALUzhymYXaxIM/RA0HPeFtU4pfZx4aHFZ78/K2T1SpSSeV3cwnoPxX74KFsr3OFjh1uTQleFXR91ZSo04mmawxqIR8obX4q+rdw3ALjJT79J4NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713956397; c=relaxed/simple;
	bh=PlvHQCRrR3gCxl/GzZFcIhsa+ijU6S3mD8g/1OmsUzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGx4mMNRrCgkNkuTr+wrncZWpo32pWx3MBmAucNLFnAqn2s2a/06sSEY1lEmoUzgTI7OBQKVqsi8sgcJVFbR4yKnegZsU75dg7ZGQpvvlHYRhRUkVscrva+ZqnZ6DeAUMF1r0JPUUnspou4AjumvuRyXQgTXXU0tOEVijMfQqjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aKRBmvzR; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43OAsXkb006810;
	Wed, 24 Apr 2024 10:59:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=soz8Hl5pG2vWUWFe9/WqiFW0AWglRDFBfa50LY/AZyU=;
 b=aKRBmvzRFKardYC8w4oTpdTd8jYEENz+3TITw0AVm4/br32dHV47d2UaNVVlBQP3uS7x
 Tha7xEIAoronn+n29cjyQ3FZvBLt2wQCS6Y00qqjAGaP/vQvA5BtAe49AJEMQLgPtw/a
 3yfGuqzc4Qs5DxPIn6zSRvBwau2S02ZTSx9fJMeg22jkgfgUXZRQhHdA/qGEYv+dXw2+
 oYBaEqcFK5YEcYVEo9qQEG3YPAnwPkuLfQyo9ngTkou8qzC/uJQk/h3QZOIrHVuqZGwY
 PZa8BjJ9Q1nAnKWeeLbUe4JwMZMg2xxRVJk7+RrS0Y9lelmKZGsmip8rLHcb/cuSn0B3 jA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xpy12g6xn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:47 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43OAxlVp015390;
	Wed, 24 Apr 2024 10:59:47 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xpy12g6xj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:47 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43OAUtsW029873;
	Wed, 24 Apr 2024 10:59:46 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xmr1tkeg1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:46 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43OAxfvM50594072
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Apr 2024 10:59:43 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 117952006E;
	Wed, 24 Apr 2024 10:59:41 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D83A120043;
	Wed, 24 Apr 2024 10:59:40 +0000 (GMT)
Received: from t14-nrb.boeblingen.de.ibm.com (unknown [9.152.224.21])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Apr 2024 10:59:40 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 12/13] lib: s390: fix guest length in uv_create_guest()
Date: Wed, 24 Apr 2024 12:59:31 +0200
Message-ID: <20240424105935.184138-13-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424105935.184138-1-nrb@linux.ibm.com>
References: <20240424105935.184138-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0zxm9l80RyFoba_lJTflT-mkC_b6bD-p
X-Proofpoint-ORIG-GUID: xAPBke_NKZgO4VBftpQFmKDQI4p8Cqne
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

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

The current code creates secure guests with significantly more memory
than expected, but since none of that memory is ever touched,
everything still works.

Fix the issue by specifying the actual guest length.

The MSL does not contain the length of the guest, but the address of
the last 1M block of guest memory. In order to get the length, MSO
needs to be subtracted, and 1M needs to be added.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20240418110140.62406-1-imbrenda@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
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


