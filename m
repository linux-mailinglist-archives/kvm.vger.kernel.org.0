Return-Path: <kvm+bounces-62040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DF05EC33DF1
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 04:45:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E89FB4F1C13
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 03:42:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8571926F29F;
	Wed,  5 Nov 2025 03:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Jctr9LBz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B182698AF;
	Wed,  5 Nov 2025 03:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762314117; cv=none; b=pYpvxYX5yrETks6OqfYJnoD6dC9NKzCUNnYjaa4+WTV4+ezK9qLn+ahKD5fJmsOc0dVxElHkol+pkGGrgREDqqcK0mvDD2aEe7i9AvoQKJ67eeHtYE03a4r1sHCr37ea84F9gLkwv+heK3rfTjQ15y5ubTqJF+outBSMMGXlI8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762314117; c=relaxed/simple;
	bh=cmB0zntsfdpZqWEbZAcE2xEbY20XiO7bHuZcD4mPSkc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=lyxKL99lXej8eKQaeY46ZHUyATTrTrPhydB5P85FZ8Elj8BObqzzyZRy9cYkHT5FERQ0R6VRXkzPRfNrdc3T96z0JgtYczmMI2sJCsaDWTptOuqHdnURudy23ipi6VHvSAX3nIkMrj4YYX2X23ZJPK28Jq+AVIpLNJHmKVgydiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Jctr9LBz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A52RIhX026493;
	Wed, 5 Nov 2025 03:40:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=aG2cMM9Ypkr3k3Sb4RqU3zqoH9zN
	udrfCuI6GZ4sUKs=; b=Jctr9LBz2zdEX+om1Wu93MR3by1X308pKq9HDY5dIV00
	WD9VMYX+kY+YRLyH79VQtd+qZIPo/hgQPDp9l5TshqJhdHXBjqkif1RNLNzH4u/B
	U+kCt12eSDl164NEVdy7JoOyIGxnEXBS9keDWrQWHwtwXG+rcr4r33Xxi9yElfGB
	IFTlkAOWDC8wLOa/iIlZeeE3LQY7O+tUZsemmKzld6xSB8QnGV6tLc1h+QY97Zo4
	kJlc668HvwsGnkZGwbNMJb24IeaGtQHxA+PoOywPuBMUAsYPjwbwEG14OyAdlCmv
	YvGSJ4FCW8/Z7bMvUhDzyiK8l2pvmJchRaszz52o4A==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59v1xxuk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Nov 2025 03:40:47 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A53b7HF021467;
	Wed, 5 Nov 2025 03:40:47 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a5xrjp2fu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Nov 2025 03:40:46 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A53ekrM32244286
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Nov 2025 03:40:46 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE24058056;
	Wed,  5 Nov 2025 03:40:45 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A911758052;
	Wed,  5 Nov 2025 03:40:42 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.90.171.232])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Nov 2025 03:40:42 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
Date: Wed, 05 Nov 2025 14:40:32 +1100
Subject: [PATCH] entry: Fix ifndef around
 arch_xfer_to_guest_mode_handle_work() stub
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251105-entry-fix-ifndef-v1-1-d8d28045b627@linux.ibm.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MQQqAIBAAvyJ7bkGlReor0SFsrb1YaEQh/j3pO
 AwzBTIn4QyjKpD4lixHbGA6BX5f4sYoa2Ow2pIxmpDjlV4M8qCEuHLAgXrjtNOeAkHLzsTN/st
 prvUDjI55IGIAAAA=
X-Change-ID: 20251105-entry-fix-ifndef-95417070c5f5
To: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Nicholas Miehlbradt <nicholas@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>
X-Mailer: b4 0.14.2
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wx_FtYlGlo4R8f3xDIjdh-pM7jFELyxa
X-Proofpoint-ORIG-GUID: wx_FtYlGlo4R8f3xDIjdh-pM7jFELyxa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAyMSBTYWx0ZWRfXxbkjrmLBjwqs
 LkD/GIiXoYTZepeKecAhkrHGwax2ohKniYnxRK1rSM/NdPuRRNPwn/VLuccYUUQeFlk6qP1m6yk
 IXK0vnnuUaKUzoXZ+HFalbSeHCuSej9NzqcdEBt6HsEuxXGvl58ObUQZRKNz4Xse4ZQ2+hEuIyP
 7Ugy2WwzcE65vPm/vWyjiLk34X4tgAv7fLh8ftSjF+GNEZZgRbO7Tp7gHqazwhOWWM9Nr96aIGr
 4K5C+WI3ntQDI/1ZDXXTJ61TRmHGWNDr7PGUlNIFtPov0Cz4T5fvBkCboS7AtqJcZS4RyXHDSdm
 VPZ49vrP9kuzn3HHe4HcWX960fwhzxb4Oi7EHNWW+uKnf46xFSbqAIzShQvOijr/Idu1SqreUru
 XIVuEPn0nN1fAUIvQ7/ztqVHK67ZBA==
X-Authority-Analysis: v=2.4 cv=H8HWAuYi c=1 sm=1 tr=0 ts=690ac73f cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=NFBBov28_AGq25HD2NEA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-05_02,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 clxscore=1015 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511010021

The stub implementation of arch_xfer_to_guest_mode_handle_work() is
guarded by an #ifndef that incorrectly checks for the name
arch_xfer_to_guest_mode_work instead. It seems the function was renamed
to add "_handle" as a late change to the original patch, and the #ifndef
wasn't updated to go with it.

Change the #ifndef to match the name of the function. No users right now,
so no need to update the arch code.

Fixes: 935ace2fb5cc4 ("entry: Provide infrastructure for work before transitioning to guest mode")
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
---
 include/linux/entry-virt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/entry-virt.h b/include/linux/entry-virt.h
index 42c89e3e5ca7ac9ed90706ced5b688d909ab5f3c..bfa767702d9a691bdca599ff5a573e124a99457a 100644
--- a/include/linux/entry-virt.h
+++ b/include/linux/entry-virt.h
@@ -32,7 +32,7 @@
  */
 static inline int arch_xfer_to_guest_mode_handle_work(unsigned long ti_work);
 
-#ifndef arch_xfer_to_guest_mode_work
+#ifndef arch_xfer_to_guest_mode_handle_work
 static inline int arch_xfer_to_guest_mode_handle_work(unsigned long ti_work)
 {
 	return 0;

---
base-commit: 284922f4c563aa3a8558a00f2a05722133237fe8
change-id: 20251105-entry-fix-ifndef-95417070c5f5


--
Andrew Donnellan    OzLabs, ADL Canberra
ajd@linux.ibm.com   IBM Australia Limited


