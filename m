Return-Path: <kvm+bounces-21403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B04D92E5AF
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 13:14:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 071902823CF
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 11:14:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2825D16D9C4;
	Thu, 11 Jul 2024 11:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZlCWpqIK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7216D16D321;
	Thu, 11 Jul 2024 11:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720696120; cv=none; b=O6GYESEM8rhpKjwVRiujDmJO0MS4+j2tRTkqfZMGGxxkYxy7o0xrnO+Y/stIcStckAbBpsoCp1parn53fWiC2Ba8wg/8nWQgf1FCNhcVW8Gs3y/15JWxghXlGp9kjJ0rXXzYnNK8amLiOH/Pez3dMOQTj6geHJZfobvYNIoGoBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720696120; c=relaxed/simple;
	bh=yh0BHoY1BLA0lcs0XgvzlpB4DY9vXmV+XIWT4bVZ9cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUOm0MPZk68QIes/h+YAov9jrRGypsRFjsE5vxbKEpEqDCE+JslnTS99+GBxCZs3D7TzmQQS9l/qVF4pvQSfyWqxMCnHXY2wsRSDam+IcaNPZlhAISfNOxq8NPWlGh1bIAFny96SCIIx+X0GvqjyIHcakrjkd/T/mQhKh6k8Jmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZlCWpqIK; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46BAueU8001374;
	Thu, 11 Jul 2024 11:08:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:mime-version; s=pp1; bh=SDm7egWgGB+6P
	F0dXLEK+dmNsE1P6KTHHxIBAVf+qYE=; b=ZlCWpqIK6HjnBMCQKiIU8h5CUzuQ1
	SdvWX+N013P8b2arw1utymPNrDRcccshxwdoyBRLAXdWoUAdeW5kVnHt79BNAaF7
	as7U5rPIv0YwnCRQ9nvTLUOtRhiDtDMKrFiq0siF0QohOhjaePuSfi7xa2skVfXl
	VQnyTlK9dcd7EHu7uA+4OKFl7YN9yZ2nH0TO5k68sqBEtQVVLSyNg82H1AykRIz6
	XIybwkInoec75yGtADN/H/lSSOq0aM3VGZpQ+d7SNW6UJi0Ct1qChTxWl+qOAgY/
	sZv9CJLG2qWKObXL6lRMH2lOk7W8mMs6q2ZLLwqVF5uDBypDrctXuNcpQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40adnvg2r7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 11:08:36 +0000 (GMT)
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46BB8a3A018802;
	Thu, 11 Jul 2024 11:08:36 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40adnvg2r5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 11:08:36 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46B7V3Ob024690;
	Thu, 11 Jul 2024 11:08:35 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 407g8ugmq0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 11:08:35 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46BB8TIF52101618
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 11:08:31 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A479520040;
	Thu, 11 Jul 2024 11:08:29 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 714802004B;
	Thu, 11 Jul 2024 11:08:29 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.boeblingen.de.ibm.com (unknown [9.152.224.253])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Jul 2024 11:08:29 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [GIT PULL 1/3] KVM: s390: remove useless include
Date: Thu, 11 Jul 2024 13:00:04 +0200
Message-ID: <20240711110654.40152-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240711110654.40152-1-frankja@linux.ibm.com>
References: <20240711110654.40152-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iSOoIhkAmV9gGjZBnUnBmaQ4fLx8fZaF
X-Proofpoint-GUID: rGqPOvUYjHiVmpJ_CdWfuuSnJbhAgyDR
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
 definitions=2024-07-11_06,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxscore=0 clxscore=1015 adultscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=274 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407110077

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

arch/s390/include/asm/kvm_host.h includes linux/kvm_host.h, but
linux/kvm_host.h includes asm/kvm_host.h .

It turns out that arch/s390/include/asm/kvm_host.h only needs
linux/kvm_types.h, which it already includes.

Stop including linux/kvm_host.h from arch/s390/include/asm/kvm_host.h .

Due to the #ifdef guards, the code works as it is today, but it's ugly
and it will get in the way of future patches.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20240702155606.71398-1-imbrenda@linux.ibm.com
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-ID: <20240702155606.71398-1-imbrenda@linux.ibm.com>
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


