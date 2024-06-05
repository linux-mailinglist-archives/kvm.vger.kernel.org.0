Return-Path: <kvm+bounces-18923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CBA5E8FD22F
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 17:58:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD9D31C23353
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 15:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E92DA1494BD;
	Wed,  5 Jun 2024 15:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZN2d+Sib"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7563F3D548
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 15:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717603088; cv=none; b=qig91J975lPgkbjxKLdd/BM7UM84FjZLJ8BbEwlNnLcq1H7CVTL59kI2A6RBNx88T4Gg1YhF+rCThsmbLPJnFd7krbEYLRZNvxVGnbCk0lUB0qdHuz0GOB5ciVc+JAcroOyNMu0qMgBsbjYejR9N47CIGeyC+QCatDJREwEHN28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717603088; c=relaxed/simple;
	bh=2nOC8hp7tIJfyawybwFsG/g4JzixWpM3T1oUBP9Lrcs=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TYzaf5tcGFboQgkZmirMhuhoAtoWHpeUUyC2ddKWOHhWsoNn8RAi97txwHdeTkl9K+oDBNtFGkiQep+BwdDrdBBtKrgmVGFNuQkZSZevNCTCM1iv8vRKAp+PRPlMjK+YT8wnRFcLED0P2yxXlBuhX5QGZpGATjjME4CP/vi7J5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZN2d+Sib; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 455FofE0032097;
	Wed, 5 Jun 2024 15:58:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=ODVxZWtOLfR1PhbdyFJZvkezWLbzU/DTTtLASzrhuSI=;
 b=ZN2d+SibnVN7ux4P9DjfYLMbm4zhe7eghOhcSja6h6GrlzuXxzCA4eiV+qw675r1lNZf
 6VmQXxk0961MBA5Eo2Gy1NmSgY8JX2zE1f3bCp0MUIsIOlg7spYbOq0w8AWNE9EpdSdL
 S3NIMcyTfiR407LeVa4WOvkHqFxNhxJq0KYDZ6DOkU4B42y21n/jNJU+vIicxELFGfx/
 yIl0bJkw8DjWBfeXNiyYrLjdGfPSAENEaS9lT60yXmFYANyC7D4SP3bYDu8j88ZsdR0j
 zHz/ceX4ZP2jyD/30YRZbLT0y3fKvjF6RBOcHxW2e+P+uRz+6JSB1mCdBfKhnu2od2Em VA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjth984e3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 15:58:01 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 455FrJ7D004662;
	Wed, 5 Jun 2024 15:58:01 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjth984dx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 15:58:01 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 455Dbb9E031114;
	Wed, 5 Jun 2024 15:58:00 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygeypn25b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 15:57:59 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 455Fvsrp22413702
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Jun 2024 15:57:56 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B75520043;
	Wed,  5 Jun 2024 15:57:54 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C232A20040;
	Wed,  5 Jun 2024 15:57:52 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Jun 2024 15:57:52 +0000 (GMT)
Subject: [PATCH v2 1/4] linux-header: PPC: KVM: Update one-reg ids for DEXCR,
 HASHKEYR and HASHPKEYR
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: cohuck@redhat.com, pbonzini@redhat.com, npiggin@gmail.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org
Cc: mst@redhat.com, danielhb413@gmail.com, qemu-ppc@nongnu.org,
        sbhat@linux.ibm.com, harshpb@linux.ibm.com, vaibhav@linux.ibm.com
Date: Wed, 05 Jun 2024 15:57:52 +0000
Message-ID: <171760305282.1127.16831339459353942369.stgit@ad1b393f0e09>
In-Reply-To: <171760304518.1127.12881297254648658843.stgit@ad1b393f0e09>
References: <171760304518.1127.12881297254648658843.stgit@ad1b393f0e09>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 77DBWMWTuAu3t2dtKcYoDoMw-zzg20-y
X-Proofpoint-ORIG-GUID: hnayKemnZ3yGO56Wj0gH6CP_Hruflitn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-05_02,2024-06-05_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 mlxscore=0 adultscore=0
 clxscore=1015 malwarescore=0 lowpriorityscore=0 mlxlogscore=711
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406050121

This is a placeholder change for these SPRs until the full linux
header update.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 linux-headers/asm-powerpc/kvm.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/linux-headers/asm-powerpc/kvm.h b/linux-headers/asm-powerpc/kvm.h
index 1691297a76..eaeda00178 100644
--- a/linux-headers/asm-powerpc/kvm.h
+++ b/linux-headers/asm-powerpc/kvm.h
@@ -645,6 +645,9 @@ struct kvm_ppc_cpu_char {
 #define KVM_REG_PPC_SIER3	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc3)
 #define KVM_REG_PPC_DAWR1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc4)
 #define KVM_REG_PPC_DAWRX1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc5)
+#define KVM_REG_PPC_DEXCR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc6)
+#define KVM_REG_PPC_HASHKEYR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc7)
+#define KVM_REG_PPC_HASHPKEYR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc8)
 
 /* Transactional Memory checkpointed state:
  * This is all GPRs, all VSX regs and a subset of SPRs



