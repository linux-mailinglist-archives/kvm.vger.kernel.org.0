Return-Path: <kvm+bounces-15793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20BAA8B07E8
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 13:01:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 66A21B22C55
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 11:01:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E29215B12E;
	Wed, 24 Apr 2024 10:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lP6HnFV5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE6115AD9D
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 10:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713956397; cv=none; b=WujaybFhyyreQw218VTF1vSNohZTkWCJAaE39rxkAzskm7pwRtf8VRRj8nJOB7YhSN3+vgTnrrtUhHAH1y8lrB1eNe2WZf7ipoVfbQsvwf6nZTKAfrD2TiWnOAiRLmlWs/iAD3rQ3HQ7Ei0Bj26yQPD5dn99KDm4wxFKTu2dARw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713956397; c=relaxed/simple;
	bh=+pyxLdjVDknc7LukF3dyU8va0T0nsShCZFQfNguCN2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RbHEkFe+iLoy1oXfRH2q19DDElh0ITYJy1Z1ljIM6ludK9Gcl8EAsKxw4iJTGYtCdT7n2Gl6iR26AH3/7Fo92s1Nbwk0zCm9Sq4UK58Q+eApWKtrgh+rphRXCUmyKCwOJFixPjrucuHA6e5V7PsMR/Nn57xovE5d5ZU8RaTsLAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lP6HnFV5; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43O8wG0b000580;
	Wed, 24 Apr 2024 10:59:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=jI9fPRk1uXVn/yLSVxcW4Lrj7E6INbu52SOwpy9zqUE=;
 b=lP6HnFV56+InAXZLFite17bZKjLgmoQEUpJ4gtIygkfB6ZoRmstZAghSg7FX6muc0CPS
 LLUwPKUD3vhJJq1QWkbn6xAgHMRKjfqY1NGWdur2QJgQsrrTSZ+MpsyFLlp+m/wzOGoX
 RGuGjt19+2sR8xtuwpO2n0gFBtPTUhaJ84Dt//K1dQMXExe6rbvSsFOqqIEtH+GgdVSn
 +MWwLX5SEw6e10cZaRCNe3Bg3OYLC33P7O+bQ/9E/NW4mcHtj57n/wy/3HhxjxwxseSc
 M6l1jQXgCmDGoEGcIG91ahW56lXDFMku6nUY6JMQHvlzJ5r7yo2APSfIjYqAx8YOh8vY ag== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xpy12g8bn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:46 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43OAxjWG026709;
	Wed, 24 Apr 2024 10:59:46 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xpy12g8bk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:45 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43O8C4C6015343;
	Wed, 24 Apr 2024 10:59:44 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xmshmb253-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:44 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43OAxdCP31261300
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Apr 2024 10:59:41 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 248962004F;
	Wed, 24 Apr 2024 10:59:39 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EA9A72004B;
	Wed, 24 Apr 2024 10:59:38 +0000 (GMT)
Received: from t14-nrb.boeblingen.de.ibm.com (unknown [9.152.224.21])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Apr 2024 10:59:38 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 03/13] lib: s390x: uv: Dirty CC before uvc execution
Date: Wed, 24 Apr 2024 12:59:22 +0200
Message-ID: <20240424105935.184138-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424105935.184138-1-nrb@linux.ibm.com>
References: <20240424105935.184138-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TCUgr9oELpvjCj8j9A4e9MUEs3sVTje9
X-Proofpoint-GUID: uhSQr28ENz5Em4hDK-gXM4_Au858BDSV
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=997 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404240045

From: Janosch Frank <frankja@linux.ibm.com>

Dirtying the CC allows us to find missing CC changes.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20240131074427.70871-3-frankja@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/uv.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index e9fb19af..611dcd3f 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -216,14 +216,16 @@ struct uv_cb_ssc {
 
 static inline int uv_call_once(unsigned long r1, unsigned long r2)
 {
+	uint64_t bogus_cc = 1;
 	int cc;
 
 	asm volatile(
+		"	tmll    %[bogus_cc],3\n"
 		"0:	.insn rrf,0xB9A40000,%[r1],%[r2],0,0\n"
 		"		ipm	%[cc]\n"
 		"		srl	%[cc],28\n"
 		: [cc] "=d" (cc)
-		: [r1] "a" (r1), [r2] "a" (r2)
+		: [r1] "a" (r1), [r2] "a" (r2), [bogus_cc] "d" (bogus_cc)
 		: "memory", "cc");
 
 	if (UVC_ERR_DEBUG && cc == 1)
-- 
2.44.0


