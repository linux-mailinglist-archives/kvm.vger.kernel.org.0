Return-Path: <kvm+bounces-65004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D692C97680
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 13:55:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E48F3A5346
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 12:49:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E3A8313E0A;
	Mon,  1 Dec 2025 12:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sZhFH6HC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A98313274;
	Mon,  1 Dec 2025 12:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764593131; cv=none; b=alkhIKDt0jZEESfVUWXaiaRPxGznCkf/foEptnHWF5wmdtLglJQQ/qxHClDTI6DIAnBGgphvLV8BULawKTlH1NE0YYjCIkhlYX6P+VEEQ4+19nd3CeG7gGP9o4C8ErpAdQb5KrvjhNRiyLR170rfAIexD0u0eiHneMYspTnbI/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764593131; c=relaxed/simple;
	bh=6Q2wTjG5vCCfSP7KPh7bMAu/oXm8sQvs6WPZQtCyCcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKNVwisPxh4XJjvvh7eboWn0ACXwK+VRSYJX2Q1lVyRTAyMUerSTqK2xoYbQdLPwFzNaSYTx4yeVRkTx/Wy14QkiTJJwZHqIEk1Pdc8on5cAzZN0c0ZVl7a1h/YbmWSDoykWYM5qu83FX66oODlLXT26uOA1y2ykqOG40qEFooE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sZhFH6HC; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5B17bWd7010434;
	Mon, 1 Dec 2025 12:45:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=tfd5X2tmSqjuYhivA
	KhbyTyWHQIzxoPX8+6PkL/2hjA=; b=sZhFH6HCtZ1GYzfrWVgTw4Hm2Y3m4wNqI
	xdWCJoE6rV6yIquvoxdkDGakRoZ9fm5E7l0dV0OgRUGhSlAM9ezLtRfrdiDJr0NW
	7rMtw23MjO8J1uuKU9sa2XzfS5wKPVZgVYaPnr7etk4qURJVqbfUKCh69QoLKkjs
	92Flp/vfZKhX6UO8n43+K0RIkylOjU85c+xpmeZCdwFCuIXq0XcMPzrQqPG/HaFJ
	0KGyHmJ/3BQwRSuQHdQGFFMuv0lnjW9Y0LKTGPoVo9Yo9E3XOLzRFzZfJ9nd4W5D
	JWlPqqOT3ZROZBhrBJTCfxGrGPqdDx1T6cbYUgqw+3Iw+O1v1qWig==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aqrh6q3pq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 12:45:15 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5B1Aa2pM029323;
	Mon, 1 Dec 2025 12:45:14 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ardv164bx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 12:45:14 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5B1CjAT157475536
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Dec 2025 12:45:10 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 55EB420040;
	Mon,  1 Dec 2025 12:45:10 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AF38B20043;
	Mon,  1 Dec 2025 12:45:09 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.111.74.48])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  1 Dec 2025 12:45:09 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        Thorsten Blum <thorsten.blum@linux.dev>
Subject: [GIT PULL 03/10] KVM: s390: Remove unused return variable in kvm_arch_vcpu_ioctl_set_fpu
Date: Mon,  1 Dec 2025 13:33:45 +0100
Message-ID: <20251201124334.110483-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201124334.110483-1-frankja@linux.ibm.com>
References: <20251201124334.110483-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=dK+rWeZb c=1 sm=1 tr=0 ts=692d8ddb cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=1KetFzxxlWrMbJfAoEMA:9
X-Proofpoint-GUID: VV0_oASkRks9AQj_DhM2pzD16OGM9trh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDAyMCBTYWx0ZWRfX9OkXEHwFa8uA
 /LwHS8k8KBAjLbLDN5krs2YUtZLEdpluRCLa+2QYmtx6MIMn1akp3Su2zmCdOdRmhzoNEMd1DlD
 AZzrPG5VHNFya7Jjg1dULOWF2qQmI7w0ey+E5xYJHsRKDWuC0SjXmMOVLWwHMrrcaTRo4KB2/xh
 dDB7XLXSM05cMlGTZ32BKZugMbE2T/9D0XeZl/+l5+b9YIvmJXzJDcI/hpcsSd0Sa2x9/BeX/o/
 joyZh/3rv4M7c7grFKOUqugV/1NBFFmAd20fw2kD/a20rzx6eAws8r2/qf27sQfPi+U/taKltes
 KQPsvee+9ou2U/BSp5eSwcklSFjnI5MPim31SZ/5vnV9pk1HFJZ6NdS8IdZk3b5FKlKfP4wzTZn
 TPaykMx5x8iJcUc+UBUdbRIibqmF7w==
X-Proofpoint-ORIG-GUID: VV0_oASkRks9AQj_DhM2pzD16OGM9trh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 adultscore=0 phishscore=0 impostorscore=0 spamscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511290020

From: Thorsten Blum <thorsten.blum@linux.dev>

kvm_arch_vcpu_ioctl_set_fpu() always returns 0 and the local return
variable 'ret' is not used anymore. Remove it.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 769820e3a243..677aa5c7d226 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4249,8 +4249,6 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 
 int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
-	int ret = 0;
-
 	vcpu_load(vcpu);
 
 	vcpu->run->s.regs.fpc = fpu->fpc;
@@ -4261,7 +4259,7 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 		memcpy(vcpu->run->s.regs.fprs, &fpu->fprs, sizeof(fpu->fprs));
 
 	vcpu_put(vcpu);
-	return ret;
+	return 0;
 }
 
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
-- 
2.52.0


