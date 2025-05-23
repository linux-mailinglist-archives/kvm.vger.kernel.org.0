Return-Path: <kvm+bounces-47582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8E70AC235E
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 15:05:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5730A22FCF
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 13:04:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E02CC1991DD;
	Fri, 23 May 2025 13:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Fa6iZKAt"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E64174EE4;
	Fri, 23 May 2025 13:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748005439; cv=none; b=tSKWSNC5G4ktFY/s7KcpK9YKIA+f8Jm6BfJLTFm8X9KN6Aw5fcqcVUEj5g2b9PXzxGmh+SLaKPM1Wr2JF6+vqyZ3FpItKjFmFLnM7Jdwl/qa5HZ070AczVJyddrQM0s1HdkUJtZgFu2Wvc23K/lH/5Equz2ZPG18oBPLIsK1Hc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748005439; c=relaxed/simple;
	bh=PRCnL8WgpuqQESSocaZd0VvV0Rpn66eBwNGP90uDevE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hV39etJIu7L9PN97PgA0bJ33cQ6mU39flMxmWYsJBOVsoalx6SAq14j4D1ntkdpknPw7rXcyX67+ZBpNCIA35u0SxzZzxRDRjN5xE0IAcQ9GM6sOfDdX0cnaAwpc//NCD7dmOz7KLZb1NAmBVD9Sjuyq4f03JxP2HTtWdej683A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Fa6iZKAt; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54N3dOfR003761;
	Fri, 23 May 2025 13:03:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=f0EkbI+JTUvluLo/f
	zHmqTzfYD56MIaFBBtnL8OTGXA=; b=Fa6iZKAtx3BHvHe3GuwIiCfMsMQHFw+1P
	tGa5CNm9dYl5BTHiUWF1qRTZ+HHmLh+Ske5qai7cmcuIWAV8VS2RZBSzAcGW4zp4
	27r/VGU2+AvyQoNGc62N/3VUXc5i5bsFKZ+hz2p6j2x5RGee11ujB1xfdwdFHbWy
	31HNtjZo8dd3Vm86j9sPJXAw2WHgu+wfy54Y8zy5kmYzGFbGUqCo5chQwR/xMNRj
	0WYxrTD8VMy3a76JAsYVIMNILIvWs7eryA8ZA4jAewQ9o5L40puYF+v8+YnGbSdj
	OKJfpFTWV7vg22Ibs29U5C5Lm4lcLZtwb5AoH7iXimgRsvjRQNb4A==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46t14jpy6b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 May 2025 13:03:54 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54NARXg2032087;
	Fri, 23 May 2025 13:03:53 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwnmpm3b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 May 2025 13:03:53 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54ND3oFh59638132
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 May 2025 13:03:50 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2BC8B2004B;
	Fri, 23 May 2025 13:03:50 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C00A72004E;
	Fri, 23 May 2025 13:03:49 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 23 May 2025 13:03:49 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, gor@linux.ibm.com,
        schlameuss@linux.ibm.com
Subject: [PATCH v4 2/4] KVM: s390: remove unneeded srcu lock
Date: Fri, 23 May 2025 15:03:46 +0200
Message-ID: <20250523130348.247446-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250523130348.247446-1-imbrenda@linux.ibm.com>
References: <20250523130348.247446-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 34Gv8UwrG291WKL20GOIaBYvTrvJQKRz
X-Authority-Analysis: v=2.4 cv=XOkwSRhE c=1 sm=1 tr=0 ts=6830723a cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=-g0RikXFz7zMAnJmuvsA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIzMDExNSBTYWx0ZWRfX1R/Z2r5JT/tr IDEm8PtqiuzgFA59yatpGuaPuQrLV61158Dc4h29RYm+wymcNc9FKhKF+WxQeLD0vFRtQ9fyjOK d6XPHAu3CLNLyqXEX+2eZiYcP34/nkEKvYhxAM5UsNniYVryKtouvhwhKj0FRaoMATjkTVvwtbF
 hG3dnCTmm1LsC7GdyVoj0wYWQjv+De/QxVOO8l5NhcrKaTLHsJxTbmNbDl9a+Z+9N+3FzxERDPz MVuyMHtgB1oGp0m9X4KmbR+bzZFoCbXjOR9UM35YkjmBzZxhSkcAQRpoeMEcdyfOA9AfNEeVD0p POobs5XAp2Y3aMGrwkULu5NZtnyU9YyqJIYYHjtb/jl65FnB0bR3kxxP+KfnxRJOUFQ6a1kPKYq
 +2UTN7aiB5yw0x0yGa6m5gp2sRIPfmbkuRBFZph5l9y10fZTGI1VFRzj+SQmbPYvR07Dfp+l
X-Proofpoint-GUID: 34Gv8UwrG291WKL20GOIaBYvTrvJQKRz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-23_03,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 mlxlogscore=770 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 spamscore=0 phishscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505230115

All paths leading to handle_essa() already hold the kvm->srcu.
Remove unneeded srcu locking from handle_essa().
Add lockdep assertion to make sure we will always be holding kvm->srcu
when entering handle_essa().

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/kvm/priv.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 1a49b89706f8..9253c70897a8 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -1248,6 +1248,8 @@ static inline int __do_essa(struct kvm_vcpu *vcpu, const int orc)
 
 static int handle_essa(struct kvm_vcpu *vcpu)
 {
+	lockdep_assert_held(&vcpu->kvm->srcu);
+
 	/* entries expected to be 1FF */
 	int entries = (vcpu->arch.sie_block->cbrlo & ~PAGE_MASK) >> 3;
 	unsigned long *cbrlo;
@@ -1297,12 +1299,8 @@ static int handle_essa(struct kvm_vcpu *vcpu)
 		/* Retry the ESSA instruction */
 		kvm_s390_retry_instr(vcpu);
 	} else {
-		int srcu_idx;
-
 		mmap_read_lock(vcpu->kvm->mm);
-		srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 		i = __do_essa(vcpu, orc);
-		srcu_read_unlock(&vcpu->kvm->srcu, srcu_idx);
 		mmap_read_unlock(vcpu->kvm->mm);
 		if (i < 0)
 			return i;
-- 
2.49.0


