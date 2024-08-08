Return-Path: <kvm+bounces-23629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 81E9994C075
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 17:01:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 07E1B1F2BEAB
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 15:01:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21ADE18EFD3;
	Thu,  8 Aug 2024 15:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="c8uHoEvJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF9325570;
	Thu,  8 Aug 2024 15:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723129305; cv=none; b=nOerr+3TZENiwSJ/nnIXfkVMcOxDWK6GmFkJnn+uXL86/VA9uiMJ0xvOH9cvksbWuaq27djFK0vjfW2SAdB1Lt6ARlKqepVJd17CLMEf408oqR7NZ7lZ59y/vQRCIE3ABM7OrDopDRqY3awamgo09zOgd18teLctSHSH6L66xsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723129305; c=relaxed/simple;
	bh=sgjfVfijeWWj+meR8ZMo9VaB7Jn0DSJk72V/MHNRPEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgKCvjx0dMCutFvHloO+B1OSE3UY/fR4POaxiV2Wc1B3wFWwXgaXt+eM4wdoP7DRlCtm1uCRD3RcR+q7k8jhnJUKG7QXyd7YYfEPm46YlDkfGCmizBnYL6K1SkvdPrVeCZQt272oNjTQsSs+v3Ow1tnlgZQAqYOVMmZgSrReClo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=c8uHoEvJ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 478CaJfg024954;
	Thu, 8 Aug 2024 15:01:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:mime-version; s=pp1; bh=JMFDGGQiQschd
	gv+u+Yj27Nvdqg47ExYi2Q4W/mBKk0=; b=c8uHoEvJkHQNB/u4rm8yH1TSsc6Rg
	N5OJO/gQtDEDssDvGeO96l8FDYo/O1X2jqizNqxJAzFqps2IxQKcv6LLJYiqil0L
	YlE6k5X7zBj1kZeN10k/jTfIntiF4H5pUQdJ5DwWhAXPVbgZkn0JOHwpRz6Gi1HA
	ArAsPLSKzeIJiQBA/g/12bybNgqZ4EgI1DhOMXbJKamSdYZAT5oaEkVoPDnSDaDf
	aLtnAzsgF1lz0Rj5du18Przds+IZONNHWSR0k4Z4d0JvuPP8hc8vkKaCXsbGjSAH
	PZJTfn5bl/kq2Htd9FIR31I+QZVheDe9RZKKQakGm5Uia1KPnqnWOYp+w==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40vwkbre94-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Aug 2024 15:01:39 +0000 (GMT)
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 478F1dh5016870;
	Thu, 8 Aug 2024 15:01:39 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40vwkbre92-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Aug 2024 15:01:39 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 478C1UDk018004;
	Thu, 8 Aug 2024 15:01:38 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 40t0cmxq7j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Aug 2024 15:01:38 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 478F1W2a48366008
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 Aug 2024 15:01:34 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BC37520075;
	Thu,  8 Aug 2024 15:01:30 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 38A962004B;
	Thu,  8 Aug 2024 15:01:30 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.38.33])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  8 Aug 2024 15:01:30 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        Steffen Eiden <seiden@linux.ibm.com>
Subject: [GIT PULL 2/2] s390/uv: Panic for set and remove shared access UVC errors
Date: Thu,  8 Aug 2024 16:52:13 +0200
Message-ID: <20240808150026.11404-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240808150026.11404-1-frankja@linux.ibm.com>
References: <20240808150026.11404-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Em8wYqHNHejInlUH_tI3ceVZyfCpgchs
X-Proofpoint-ORIG-GUID: JS78gups867CFs-r7lkzMTwNJLlhJG-_
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
 definitions=2024-08-08_15,2024-08-07_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=590 spamscore=0 clxscore=1015 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408080103

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

The return value uv_set_shared() and uv_remove_shared() (which are
wrappers around the share() function) is not always checked. The system
integrity of a protected guest depends on the Share and Unshare UVCs
being successful. This means that any caller that fails to check the
return value will compromise the security of the protected guest.

No code path that would lead to such violation of the security
guarantees is currently exercised, since all the areas that are shared
never get unshared during the lifetime of the system. This might
change and become an issue in the future.

The Share and Unshare UVCs can only fail in case of hypervisor
misbehaviour (either a bug or malicious behaviour). In such cases there
is no reasonable way forward, and the system needs to panic.

This patch replaces the return at the end of the share() function with
a panic, to guarantee system integrity.

Fixes: 5abb9351dfd9 ("s390/uv: introduce guest side ultravisor code")
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20240801112548.85303-1-imbrenda@linux.ibm.com
Message-ID: <20240801112548.85303-1-imbrenda@linux.ibm.com>
[frankja@linux.ibm.com: Fixed up patch subject]
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/uv.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 0b5f8f3e84f1..153d93468b77 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -441,7 +441,10 @@ static inline int share(unsigned long addr, u16 cmd)
 
 	if (!uv_call(0, (u64)&uvcb))
 		return 0;
-	return -EINVAL;
+	pr_err("%s UVC failed (rc: 0x%x, rrc: 0x%x), possible hypervisor bug.\n",
+	       uvcb.header.cmd == UVC_CMD_SET_SHARED_ACCESS ? "Share" : "Unshare",
+	       uvcb.header.rc, uvcb.header.rrc);
+	panic("System security cannot be guaranteed unless the system panics now.\n");
 }
 
 /*
-- 
2.46.0


