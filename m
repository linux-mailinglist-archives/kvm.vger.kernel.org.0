Return-Path: <kvm+bounces-1344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B8F47E6AAE
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 13:36:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D3671C20A90
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 12:36:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 391871DDF1;
	Thu,  9 Nov 2023 12:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OGfbZp8o"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A1F1DDD4
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 12:36:35 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272A82590;
	Thu,  9 Nov 2023 04:36:35 -0800 (PST)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A9CIhTJ014827;
	Thu, 9 Nov 2023 12:36:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=8M+6oE/mGzBR3l5KMdntkJh/cY/+e85xL1ajn5Bglik=;
 b=OGfbZp8oiUDCHbLPpzrWR3tf+EWaoHZE2JS8Vrdm2hzEqEQKjwsTTUr/Bp/gng/Ub7gu
 WItNQf17BBIGMEohY06snuxZhTzEzBf3skFHZprBF4dAY7/c3xaOVyH+vKzWU6Qj+CyI
 iBURYURC/yWuTcCPloV3Fcoz55Xrz4ITKJWVEdKJcMzbar/4GE8Vtj+k5soDi0JYb2mg
 iJ883uP/OHOXLsSK2h8frZ3DYb0lETxgBs6O7IZbFhvJTzNA8G7jgsCnXJzBbwTzuqRB
 5tRei91GI+gIdhNPgpIQFsFcd+fXD7I7luRMNNbYdbsAOSJDYxvHNQT+I66474xGJaS6 0g== 
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u8y1x12s0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Nov 2023 12:36:33 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A9BA6dh019224;
	Thu, 9 Nov 2023 12:36:30 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u7w243paq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Nov 2023 12:36:30 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A9CaPel15729308
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Nov 2023 12:36:25 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9ACF520043;
	Thu,  9 Nov 2023 12:36:25 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3F50F20040;
	Thu,  9 Nov 2023 12:36:25 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Nov 2023 12:36:25 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        borntraeger@de.ibm.com, hca@linux.ibm.com, gerald.schaefer@de.ibm.com,
        gor@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com
Subject: [PATCH v1 1/1] KVM: s390/mm: Properly reset no-dat
Date: Thu,  9 Nov 2023 13:36:24 +0100
Message-ID: <20231109123624.37314-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: myYyJj0L8_5WghP5f341tFr1DjuECp_V
X-Proofpoint-ORIG-GUID: myYyJj0L8_5WghP5f341tFr1DjuECp_V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-09_10,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=564 clxscore=1015 phishscore=0 adultscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311090094

When the CMMA state needs to be reset, the no-dat bit also needs to be
reset. Failure to do so could cause issues in the guest, since the
guest expects the bit to be cleared after a reset.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/mm/pgtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 3bd2ab2a9a34..5cb92941540b 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -756,7 +756,7 @@ void ptep_zap_unused(struct mm_struct *mm, unsigned long addr,
 		pte_clear(mm, addr, ptep);
 	}
 	if (reset)
-		pgste_val(pgste) &= ~_PGSTE_GPS_USAGE_MASK;
+		pgste_val(pgste) &= ~(_PGSTE_GPS_USAGE_MASK | _PGSTE_GPS_NODAT);
 	pgste_set_unlock(ptep, pgste);
 	preempt_enable();
 }
-- 
2.41.0


