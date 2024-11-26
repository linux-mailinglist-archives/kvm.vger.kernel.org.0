Return-Path: <kvm+bounces-32514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 95D9B9D958B
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 11:27:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 94133B29E88
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 10:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39B6B1CD21E;
	Tue, 26 Nov 2024 10:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="napG3UMQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E08195FEF;
	Tue, 26 Nov 2024 10:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732616725; cv=none; b=fowsAQRkQWt3gkWSS21D6D0LsfPr3tV03wsV/GiViXWJFzU1ST9SUY2q1XXGdfmiRtXQAEbU2LIFsnQRrxF0NxcgNmtV2lCF9qkVSNU0pCqFqOSigRBEDl/QbjaIZdXBxnGWzZoTj25zd0mbXqYA3+gqSHzobmoLcQNRr0Yxhjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732616725; c=relaxed/simple;
	bh=KRRHVbmHfv7a0GjaWgtrBM521TCMysRPfuKXqff72sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iH3bxiId+Fmot1SsXs0UcSnrME6/w6HrBr1pSrjVDoOrb+L10HqV00WPpbi+dIxvNmHdPN4J50GCopNFmSY2gjweQrlkV5y493764D/h09kqOkQe+u4mt12UE6LXgutsUfCANkGMUHu0Foe8XhBrXSXgWLav/Cxb+uRZKh+uR9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=napG3UMQ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AQ6r004020137;
	Tue, 26 Nov 2024 10:25:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Z5PQGf94hDkjfa+R4
	Y+KBYYblAtkWCHqKfOzDX4wmaY=; b=napG3UMQYTBBCu144xB5MT49UKFB6fzJC
	MVCsrnszCJ4hKstVQjlBmarMg91AVm8hIreQ8zac08ynJxdsBDu968Dd11M87SzN
	mAcvJD2ijPpUr1yKVuU54HrK3+OSMDGtuaiDXcb0jan3YL/PTS11abx2j6Zu9h3x
	VtNUsq67CwI+f3Yeha52yHULxc0qPTUxPSDqw9kplbAC+doyqxRW2gwuwDFmw/za
	4CS6y32nAzss5qzWB+YQyaElH6/LZ+Ie08zzpOrzeGz0rYkjubdZU92ADX4ZBSbw
	+1ZHZ/KuuUjACKogCOnOc/FlK0D3B+KK5ARtDcTfKSQKf/HenmkSw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43386jw0yj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 10:25:20 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AQ3xd28027470;
	Tue, 26 Nov 2024 10:25:20 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 433ukj46rr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 10:25:20 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AQAPGdF27198006
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Nov 2024 10:25:16 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 977C120077;
	Tue, 26 Nov 2024 10:25:16 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 73E5B2007A;
	Tue, 26 Nov 2024 10:25:16 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 26 Nov 2024 10:25:16 +0000 (GMT)
From: Heiko Carstens <hca@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] KVM: s390: Remove one byte cmpxchg() usage
Date: Tue, 26 Nov 2024 11:25:14 +0100
Message-ID: <20241126102515.3178914-3-hca@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241126102515.3178914-1-hca@linux.ibm.com>
References: <20241126102515.3178914-1-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0UO_Ox1IU_CK-A74SclxwLpWQPRF6zto
X-Proofpoint-GUID: 0UO_Ox1IU_CK-A74SclxwLpWQPRF6zto
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 mlxlogscore=998 spamscore=0 suspectscore=0 phishscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411260079

Within sca_clear_ext_call() cmpxchg() is used to clear one or two bytes
(depending on sca format). The cmpxchg() calls are not supposed to fail; if
so that would be a bug. Given that cmpxchg() usage on one and two byte
areas generates very inefficient code, replace them with block concurrent
WRITE_ONCE() calls, and remove the WARN_ON().

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/kvm/interrupt.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index eff69018cbeb..ea8dce299954 100644
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
+		WRITE_ONCE(sigp_ctrl->value, 0);
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


