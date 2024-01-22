Return-Path: <kvm+bounces-6570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 640AC836EBC
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 19:01:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4CA38B29186
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 17:23:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06FEE54BE5;
	Mon, 22 Jan 2024 16:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bi+v3KXA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08E254663;
	Mon, 22 Jan 2024 16:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705940739; cv=none; b=auynNEIuiZ5ttqdiIz+aK1WMDNmN24X0wyv5HuEh5Pbj3CCz7cUaoEpwaLfQkki9d12UliCEq6Ys7DflajqpiXzwwkp2Wu4wy8jUlK8JQH5h6LzY70Y0YxgQx2Ykr0yh6spg95jMzQdB0ycZ21NBok74zGQPBxiAMA9DSN8ZOYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705940739; c=relaxed/simple;
	bh=GXfpiZy75DQjR//caZM/AN4ckEsyL2pXpAfiknNV99w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxFuyWvywDeG4Lu+TO63ekKxPYhBy9G0bUmydz/IXtKEvnuakXHGZwy2NY0iSHxopbT2InBTmuUNHRTeEiqDHC7Y51CK0U1ro97N71iB2QMYrPTYk4wdZyAmUX+9ly1yR7SXYG7PA0V8zdHk7FVgyanuv4JW77CGYlvwjMvzJbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bi+v3KXA; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40MGOUFT014744;
	Mon, 22 Jan 2024 16:25:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=pcbyBJfYRoPozlsdcR2+q6C9REjLiGGGvZ0jXXJvEEs=;
 b=bi+v3KXAmAMPuas+Hg0S6KycquuGy/nAmFZilBAKjJWJPRAiDJSD+yZSPMgz3rX24S2A
 RxCWmLHgkpemdu/1VaNQgAYyoKjjBZ/OmNcV+foBVehb1bCbFswZRnLJlTd4Nrputmrq
 jkZ0C6jFFn2Ia8mbsxd319p3+EdM9QCKggaMOOE5mVSorWpSRa0A7IQwqXSawO2smvhh
 HIhCqkFuNvTg7UoeLPfgJ7b/1uCuKGbHgjlrVXxhxJoNkpXpitqPBDdJ5zXTX0OlGUlK
 GkoyTtMnkZ6CF6GBaIiaI1uqSyfhoue5AZa8dyRhfMjTO1dioxpqqKQkRD5RJrpVx9Xh uw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vstjtu1ax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Jan 2024 16:25:36 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40MGP2nJ018511;
	Mon, 22 Jan 2024 16:25:36 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vstjtu19p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Jan 2024 16:25:36 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40MG3Cxu025892;
	Mon, 22 Jan 2024 16:25:34 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vrsgnsshu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Jan 2024 16:25:34 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40MGPV2Q41812592
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Jan 2024 16:25:31 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0A7B320043;
	Mon, 22 Jan 2024 16:25:31 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F9A320040;
	Mon, 22 Jan 2024 16:25:30 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.78.16])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Jan 2024 16:25:30 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [GIT PULL 2/2] KVM: s390: fix cc for successful PQAP
Date: Mon, 22 Jan 2024 17:22:31 +0100
Message-ID: <20240122162445.107260-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122162445.107260-1-frankja@linux.ibm.com>
References: <20240122162445.107260-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4S5hFnxMaOQHeUumhKdyUDKXYw65E6Zt
X-Proofpoint-GUID: g2u_ia_O3cBsUcaxWIjknEjjbr-p_J4V
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-22_07,2024-01-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=859
 impostorscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401220112

From: Eric Farman <farman@linux.ibm.com>

The various errors that are possible when processing a PQAP
instruction (the absence of a driver hook, an error FROM that
hook), all correctly set the PSW condition code to 3. But if
that processing works successfully, CC0 needs to be set to
convey that everything was fine.

Fix the check so that the guest can examine the condition code
to determine whether GPR1 has meaningful data.

Fixes: e5282de93105 ("s390: ap: kvm: add PQAP interception for AQIC")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
Link: https://lore.kernel.org/r/20231201181657.1614645-1-farman@linux.ibm.com
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20231201181657.1614645-1-farman@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 arch/s390/kvm/priv.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 621a17fd1a1b..f875a404a0a0 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -676,8 +676,12 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
 	if (vcpu->kvm->arch.crypto.pqap_hook) {
 		pqap_hook = *vcpu->kvm->arch.crypto.pqap_hook;
 		ret = pqap_hook(vcpu);
-		if (!ret && vcpu->run->s.regs.gprs[1] & 0x00ff0000)
-			kvm_s390_set_psw_cc(vcpu, 3);
+		if (!ret) {
+			if (vcpu->run->s.regs.gprs[1] & 0x00ff0000)
+				kvm_s390_set_psw_cc(vcpu, 3);
+			else
+				kvm_s390_set_psw_cc(vcpu, 0);
+		}
 		up_read(&vcpu->kvm->arch.crypto.pqap_hook_rwsem);
 		return ret;
 	}
-- 
2.43.0


