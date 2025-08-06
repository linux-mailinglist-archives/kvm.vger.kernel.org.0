Return-Path: <kvm+bounces-54082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2B9CB1C020
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 07:57:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8A78B7B017E
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 05:55:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FD8A1FECD4;
	Wed,  6 Aug 2025 05:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZXeo0DYA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B7B1EB9F2
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 05:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754459785; cv=none; b=sXLbVZo3Q9irKqonsFbjOAPiAnNkK0nkKMGAyRojeaiGqiiYPJeWnRoKY3UZZvA6UWlGf6+JJWNL8DU0RLn79e8k8NZrFj2wx5QUXnAyVYS3tAHSbxoEqYs04X+eiKq9Syx7F4KiWPze7Mf4+aI6y0w0j5KwgcsFIxAyL6nWQPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754459785; c=relaxed/simple;
	bh=w9lIf9C0rHUJEMvcyE7P/Pa+NMrCLfpR6rbMywii3AM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=gI+i3dYUvbDlJGIpwclpMfawSW1JRB1eEB2dwyUGyDcAxwQF8ZeBLPYCb9orOcUOD/Af2HYgTdOKAH3VF7UI+luRL1Blek2m+i2H1a5d/Iqi7CKeDIbiHArBCkvNM2UE18ZjDd4t2CqwzIqjFO4W3z9OGAL5y38zRtk0AOLC3cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZXeo0DYA; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 575IpRra012314;
	Wed, 6 Aug 2025 05:56:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=YS/ILQBjmDtK+sCleswm9x2dCFYN64fiPVefPUMny
	P0=; b=ZXeo0DYAzzny6hYPyzWWAnu2GlfVaHmGgkwrKolOgVnOZc0gB8/KZrESK
	4brO8yU1Xb4bACJbUwwTNdj7GUULpZuG2LBJop8e6zxXHvHIPzcb8HVlu0QH1AB4
	HmTXHjotWYVbqvAdgWJUSOPadwaSayfCfSJoshpgVbTx6Tk1ThlhiACQUCyTE2Tb
	neXjuSSjgbugYDjZ5Siyaz1FDN5QaN1gYX5zVxJS5D9af8qkA++5VfhVp+reOCg8
	iVzUgIJH65pq0LQtGWO2++AEPYE4ye3hEr5TzMwefcKAxiP/bO6Vse3+lfWETtOL
	Y+2kRRwNWqLh5PjM1HSIh8KkuKraw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48bq63jaxt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 Aug 2025 05:56:18 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5763Dri8020600;
	Wed, 6 Aug 2025 05:56:17 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48bpwmt75m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 Aug 2025 05:56:17 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5765uHkT20775660
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 6 Aug 2025 05:56:17 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E251658056;
	Wed,  6 Aug 2025 05:56:16 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 735965803F;
	Wed,  6 Aug 2025 05:56:15 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com.com (unknown [9.36.0.205])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  6 Aug 2025 05:56:15 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: PPC: Fix misleading interrupts comment in kvmppc_prepare_to_enter()
Date: Wed,  6 Aug 2025 15:56:07 +1000
Message-ID: <20250806055607.17081-1-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDAzMCBTYWx0ZWRfX1n0iGyoe2r0m
 +N5bkh1eON6MyfxhwFeRIQlQYqicEJKaXlu9Cljl1yrrKSQjARftd2gqkkHz40BhABLx2xpbJyD
 +41CRyC7ly18r1Uv1JkFcNqNy00FZ3VIodT17TJjPGhLZwXxVCNXfgWDdwRz+vt5pWOhStycNVr
 5Sax8sCa9Ou1YAJyWqh3/L46h9tSVfzwN9rfiQV8H8EtTqeAewlB890iQdqP9kO4SZH67zhqjBn
 BQ2jXfk0p2IolYT3Cqn07QubUEgFB9/NnxNIUp6deAHvY5Vk3uJwdZXfhqjWG5gkw0/wW3CnmzP
 eT6c1MfpK5cHeEfMgGIwRR9xtKRrOQ+TeVFQaEtzpR6rTeCL6gvoab1fsBc1cG8CwIKgtcqagHd
 gW/1R7cnqxLKNhZyf4SBMBqxeced55dS7QUD5Kqo9m8T0AYQBYshpiFpORfcrhMpGHBxtGow
X-Proofpoint-ORIG-GUID: RiK7N33Soo0SePg9LqJA9kXtJqAvnHwF
X-Authority-Analysis: v=2.4 cv=LreSymdc c=1 sm=1 tr=0 ts=6892ee82 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=gr7D_48Ji271olD-KTQA:9
X-Proofpoint-GUID: RiK7N33Soo0SePg9LqJA9kXtJqAvnHwF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_05,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 mlxlogscore=618 bulkscore=0
 malwarescore=0 mlxscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2507300000
 definitions=main-2508060030

Until commit 6c85f52b10fd ("kvm/ppc: IRQ disabling cleanup"),
kvmppc_prepare_to_enter() was called with interrupts already disabled by
the caller, which was documented in the comment above the function.

Post-cleanup, the function is now called with interrupts enabled, and
disables interrupts itself.

Fix the comment to reflect the current behaviour.

Fixes: 6c85f52b10fd ("kvm/ppc: IRQ disabling cleanup")
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
---
 arch/powerpc/kvm/powerpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 153587741864..2ba057171ebe 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -69,7 +69,7 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 
 /*
  * Common checks before entering the guest world.  Call with interrupts
- * disabled.
+ * enabled.
  *
  * returns:
  *
-- 
2.50.1


