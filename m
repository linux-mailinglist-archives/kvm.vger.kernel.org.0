Return-Path: <kvm+bounces-20853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27D049242F6
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 17:56:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E08A828BCBA
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 15:56:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A448F1BD002;
	Tue,  2 Jul 2024 15:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="i43a3zt0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C014326AE4;
	Tue,  2 Jul 2024 15:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719935779; cv=none; b=Xw7okwRUCsB8FAlVjqShw38UrZx8oVpvhBU5Y5JUoa32sIUdeVUGcMj0lUX07i9XOwCt2ZvaDn+mM+DaX5q6POju3+QaO2o4d3DyfYxJ1zV57xJVH5cFB66WB+npg1p2LLMa92TvvTEEZ6sawN/WDym9x/FgVjJFpdHiWtJ2vUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719935779; c=relaxed/simple;
	bh=1+gzNbPlpcRYJgNGJGSRAyloxA2ydKZJokzw9VBOuMc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sL5iH8t2UmVuimDizsjn0mkAXLjOn711DXM/guPnIxpqCnmJzu2Qjgi1z2pwsA7z5Fi+55KYiMErxOwNjWal+8siDHo2qykiAfdp9WXVjtDoUd41lPD4PTPqr3gBZ6qRi3kywEBOBeMjtd5b2N4bSHUC+fXFT6bE5K/HZsHdnE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=i43a3zt0; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 462FSOsa020096;
	Tue, 2 Jul 2024 15:56:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=0MCtPccUAv/HyOA5SIGH355/4W
	OzGzAz1a93r83mZlE=; b=i43a3zt0wFoSxGEF8NS1wzom4JXP7Lq/BTcNdayNfN
	fpXRfZ4KEh3xt0r3jonp3RDD6h69ZWFp1my9UAH+8kH1xfPv5KMzX5t9HvzL9UJw
	Lsf4c6Tm2txz7dUFk8qmpkm7dpvF1HTJbNHFBPVS2LpC8S5MCYTbq2d//pcBMqFp
	zUPocpRcx2wzC3nBW5y/ma9CUXDolcdvgiVXlXiI8VmWhsN7dfXymtGUb6Magmq2
	Iae457+YkkrB1lAVDQkbf/uX/UEkxO38ITNgRRv2PPYS6eYpBdtDSjc+gk6fcSLL
	TRRTIQ+N1u5quPDVGKLkZdaSxaVqXGTrev4Lbk6SQUaw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 404m7j82tu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jul 2024 15:56:15 +0000 (GMT)
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 462FuFbf032583;
	Tue, 2 Jul 2024 15:56:15 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 404m7j82tk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jul 2024 15:56:15 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 462D8enu005942;
	Tue, 2 Jul 2024 15:56:14 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 402vku5w0k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jul 2024 15:56:14 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 462Fu6K156164852
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 2 Jul 2024 15:56:08 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9A5B22004E;
	Tue,  2 Jul 2024 15:56:06 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6C40920043;
	Tue,  2 Jul 2024 15:56:06 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  2 Jul 2024 15:56:06 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, seiden@linux.ibm.com, david@redhat.com
Subject: [PATCH v1 1/1] KVM: s390: remove useless include
Date: Tue,  2 Jul 2024 17:56:06 +0200
Message-ID: <20240702155606.71398-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0hwgbO1KruNFT2MfLeSYV6--RUqPwABr
X-Proofpoint-ORIG-GUID: CrUXzvGo2326g7e36vx9EoHdMCaJf3V2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-02_11,2024-07-02_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=1 priorityscore=1501
 impostorscore=0 phishscore=0 spamscore=1 mlxlogscore=198 adultscore=0
 suspectscore=0 mlxscore=1 malwarescore=0 clxscore=1015 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407020117

arch/s390/include/asm/kvm_host.h includes linux/kvm_host.h, but
linux/kvm_host.h includes asm/kvm_host.h .

It turns out that arch/s390/include/asm/kvm_host.h only needs
linux/kvm_types.h, which it already includes.

Stop including linux/kvm_host.h from arch/s390/include/asm/kvm_host.h .

Due to the #ifdef guards, the code works as it is today, but it's ugly
and it will get in the way of future patches.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 95990461888f..736cc88f497d 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -15,7 +15,6 @@
 #include <linux/hrtimer.h>
 #include <linux/interrupt.h>
 #include <linux/kvm_types.h>
-#include <linux/kvm_host.h>
 #include <linux/kvm.h>
 #include <linux/seqlock.h>
 #include <linux/module.h>
-- 
2.45.2


