Return-Path: <kvm+bounces-31344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7D209C2AB2
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 07:34:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5564C283239
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 06:34:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94ABC146D53;
	Sat,  9 Nov 2024 06:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="c7B2RHXW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E552BAF9;
	Sat,  9 Nov 2024 06:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731134024; cv=none; b=uE9YnpIeDwaehQ5QiJ4SfGpFURbItm1Y9vqbM84ewu/Hyx0SfV10boNKqpmkZnnxRyduQ+3uug377wWg2/HBs0DBdVRwss9ibY78cesj0kYOKi7gqX+KZa4+DZOofpUbFm1AeXxAh7+gdYLCr/DBUmsh6lNbpcj1fpGpMLXP1Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731134024; c=relaxed/simple;
	bh=IO71OHVoxvynERWdA5dQ+sa75o7luafJEikXzKMaZbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lC87cQD295pbBZXcR5xj5/T5rEiwyktjm+SCrUm4jsH5/9QvuJRR0fGubxUFIXKIv7/TW3WUfs4dQUi+4radO+R3+iDGIuZOpREA8Q2Q+YdIuxtg7XW6f1qtzcgV636GzEIR86QnxaJuw28TxcFZzQyybtFoo+iCLmkd0jvUj5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=c7B2RHXW; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A96AEmB014431;
	Sat, 9 Nov 2024 06:33:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=7TK3Xn/Gfmok9H1Vv
	gxttfEsdUnmZ5GHiiHZRWMPjJY=; b=c7B2RHXWDDgL8ndJGl/IsDffzKJL2M3HP
	bMo0m8KQvl6eTGUyOFxnh4BQ9r7xnE4MbCNoCeSajL1df4go5TCveMUVRoIOPIEW
	uqbnRJCC8BxI52n3jWa+L1pHZs4KNIwu4HofNGwVdfAxhxVaOlpJ1T8a9lCsL+sU
	wQOr8KknYJAfXZkGHJnldyUITQe02Uh1xMiWq8imzDQ/qdC5ACiyeSH64hwIZkAm
	VxM7hvGJJUt3GZPjIfH5a0SZlTIRgIdy9Qi4mH3HPs7FvU08r9LyJSBOAmMfagwq
	TAVIb8ce2AbZ2BPMfyAQHPLOFRF4IINu2Jn03Wb7RqSLZgFCfwPVw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42t27q82ms-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 09 Nov 2024 06:33:31 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4A96XVRC025301;
	Sat, 9 Nov 2024 06:33:31 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42t27q82mq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 09 Nov 2024 06:33:31 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4A91MOdi017188;
	Sat, 9 Nov 2024 06:33:30 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 42nxdsbmtm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 09 Nov 2024 06:33:30 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4A96XQFk52953352
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 9 Nov 2024 06:33:26 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB9BD20043;
	Sat,  9 Nov 2024 06:33:26 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 22BE220040;
	Sat,  9 Nov 2024 06:33:24 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com.com (unknown [9.124.214.93])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sat,  9 Nov 2024 06:33:23 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        naveen@kernel.org, maddy@linux.ibm.com, vaibhav@linux.ibm.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: PPC: Book3S HV: Avoid returning to nested hypervisor on pending doorbells
Date: Sat,  9 Nov 2024 12:02:57 +0530
Message-ID: <20241109063301.105289-4-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241109063301.105289-1-gautam@linux.ibm.com>
References: <20241109063301.105289-1-gautam@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JfVhh2hWQ7V-vAgrmL58tcAVr8iCFS9t
X-Proofpoint-ORIG-GUID: WsQzCeNEzCIichotoXifWUNxOUma5OcL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=657
 impostorscore=0 suspectscore=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411090049

Commit 6398326b9ba1 ("KVM: PPC: Book3S HV P9: Stop using vc->dpdes")
dropped the use of vcore->dpdes for msgsndp / SMT emulation. Prior to that
commit, the below code at L1 level (see [1] for terminology) was
responsible for setting vc->dpdes for the respective L2 vCPU:

if (!nested) {
	kvmppc_core_prepare_to_enter(vcpu);
	if (vcpu->arch.doorbell_request) {
		vc->dpdes = 1;
		smp_wmb();
		vcpu->arch.doorbell_request = 0;
	}

L1 then sent vc->dpdes to L0 via kvmhv_save_hv_regs(), and while
servicing H_ENTER_NESTED at L0, the below condition at L0 level made sure
to abort and go back to L1 if vcpu->arch.doorbell_request = 1 so that L1
sets vc->dpdes as per above if condition:

} else if (vcpu->arch.pending_exceptions ||
	   vcpu->arch.doorbell_request ||
	   xive_interrupt_pending(vcpu)) {
	vcpu->arch.ret = RESUME_HOST;
	goto out;
}

This worked fine since vcpu->arch.doorbell_request was used more like a
flag and vc->dpdes was used to pass around the doorbell state. But after
Commit 6398326b9ba1 ("KVM: PPC: Book3S HV P9: Stop using vc->dpdes"),
vcpu->arch.doorbell_request is the only variable used to pass around
doorbell state.
With the plumbing for handling doorbells for nested guests updated to use
vcpu->arch.doorbell_request over vc->dpdes, the above "else if" stops
doorbells from working correctly as L0 aborts execution of L2 and
instead goes back to L1.

Remove vcpu->arch.doorbell_request from the above "else if" condition as
it is no longer needed for L0 to correctly handle the doorbell status
while running L2.

[1] Terminology
1. L0 : PowerNV linux running with HV privileges
2. L1 : Pseries KVM guest running on top of L0
2. L2 : Nested KVM guest running on top of L1

Fixes: 6398326b9ba1 ("KVM: PPC: Book3S HV P9: Stop using vc->dpdes")
Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_hv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index b93a93777237..8385d4db1763 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4894,7 +4894,6 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 			lpcr &= ~LPCR_MER;
 		}
 	} else if (vcpu->arch.pending_exceptions ||
-		   vcpu->arch.doorbell_request ||
 		   xive_interrupt_pending(vcpu)) {
 		vcpu->arch.ret = RESUME_HOST;
 		goto out;
-- 
2.45.2


