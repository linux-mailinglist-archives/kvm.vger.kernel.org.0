Return-Path: <kvm+bounces-32423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DC6B9D84D9
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 12:51:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0478228BF27
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 11:51:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBD0B16C687;
	Mon, 25 Nov 2024 11:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RD8rop15"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6867A1A0700;
	Mon, 25 Nov 2024 11:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732535451; cv=none; b=JpWLcX/AfnNFg2871drPig0A87ItGIiGoWvRpBubH8qD2UTBIRXS3np4EmwXI1cI6OoSLibIpCAXe/dE7+yOpQyDN9Y5JvUuF4gKi7NdWWR0Wt4dpyGRoCpdmU+EcmwvVoY4uKC8UOJTebumg4dFAVptwpVRmVMkT6SHcgIdM3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732535451; c=relaxed/simple;
	bh=XS9DdNxhDaILBmAmGWRnWA/SLkzSOGksu3KqHaTaojc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RsP5luf8XmliBvTbHGpTGGPg0b2LkUvXR02A+s5Upl//hP/01JO7rRXaQZ6iyOiV0QY1l7/dfMVE4ZXsufb5zdhLX5LbDNOH4ePc1HMEoPM0qvW2tHtKDsINLHLvGPijLRkOFXYkpvCO31DDfThMFnpeeeQmNGYhdjgqpQXuEBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RD8rop15; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AOMieiv009519;
	Mon, 25 Nov 2024 11:50:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=0CMODce1hyg6PwG+V
	CYBzmcEpCZoiSuGLFJQOw2aATI=; b=RD8rop15T9fyPJOo50tcLegKNPqOOpqlA
	s1FCZzSWusz4jXxRuREthjf+ZBXbdg3KCky6PCvsmZXHmDtL3WfB9eL88Ckxb87e
	RGJu1NivfTXVEsD0KZOBgy5rdmyZEEVNDsVrZOmIBi9ip3/CUz//RNSowAYuVn4E
	Pn9FIlySrq/s4aghIu6yJO4jpYeMrJtvnKwAiblGO3ByyqN7BaK+BvVS+174/Wfr
	D/5+bOKLgwvTabTWHVIDtM1GmuUueU9TPzfGeq2NzhJ7ZFTRuiBEPCGnECwlZ82g
	mIoSPDqHnjm6UuqiC208+m1J6B/EFszOGePYNol9oBdTo3LeEYQtQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43386jqwrj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 11:50:44 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AP5apEk027220;
	Mon, 25 Nov 2024 11:50:43 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 433ukj2cyq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 11:50:43 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4APBoeTV56557988
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 11:50:40 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0D3742004D;
	Mon, 25 Nov 2024 11:50:40 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DF49C2004B;
	Mon, 25 Nov 2024 11:50:39 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 25 Nov 2024 11:50:39 +0000 (GMT)
From: Heiko Carstens <hca@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] KVM: s390: Remove one byte cmpxchg() usage
Date: Mon, 25 Nov 2024 12:50:38 +0100
Message-ID: <20241125115039.1809353-3-hca@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241125115039.1809353-1-hca@linux.ibm.com>
References: <20241125115039.1809353-1-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: a6K4xVPleESxgCAbo4yBKA50sVjBgnag
X-Proofpoint-GUID: a6K4xVPleESxgCAbo4yBKA50sVjBgnag
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 mlxlogscore=944 spamscore=0 suspectscore=0 phishscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411250094

Within sca_clear_ext_call() cmpxchg() is used to clear one or two bytes
(depending on sca format). The cmpxchg() calls are not supposed to fail; if
so that would be a bug. Given that cmpxchg() usage on one and two byte
areas generates very inefficient code, replace them with block concurrent
WRITE_ONCE() calls, and remove the WARN_ON().

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/kvm/interrupt.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index eff69018cbeb..3fd21037479f 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -118,8 +118,6 @@ static int sca_inject_ext_call(struct kvm_vcpu *vcpu, int src_id)
 
 static void sca_clear_ext_call(struct kvm_vcpu *vcpu)
 {
-	int rc, expect;
-
 	if (!kvm_s390_use_sca_entries())
 		return;
 	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_ECALL_PEND);
@@ -128,23 +126,16 @@ static void sca_clear_ext_call(struct kvm_vcpu *vcpu)
 		struct esca_block *sca = vcpu->kvm->arch.sca;
 		union esca_sigp_ctrl *sigp_ctrl =
 			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
-		union esca_sigp_ctrl old;
 
-		old = READ_ONCE(*sigp_ctrl);
-		expect = old.value;
-		rc = cmpxchg(&sigp_ctrl->value, old.value, 0);
+		WRITE_ONCE(sigp_ctrl->value, 9);
 	} else {
 		struct bsca_block *sca = vcpu->kvm->arch.sca;
 		union bsca_sigp_ctrl *sigp_ctrl =
 			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
-		union bsca_sigp_ctrl old;
 
-		old = READ_ONCE(*sigp_ctrl);
-		expect = old.value;
-		rc = cmpxchg(&sigp_ctrl->value, old.value, 0);
+		WRITE_ONCE(sigp_ctrl->value, 0);
 	}
 	read_unlock(&vcpu->kvm->arch.sca_lock);
-	WARN_ON(rc != expect); /* cannot clear? */
 }
 
 int psw_extint_disabled(struct kvm_vcpu *vcpu)
-- 
2.45.2


