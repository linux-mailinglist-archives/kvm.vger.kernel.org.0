Return-Path: <kvm+bounces-16736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E3FD08BD272
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 18:19:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9960C2869EE
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 16:19:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E277156C76;
	Mon,  6 May 2024 16:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Zl5mrDT5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D94315664B;
	Mon,  6 May 2024 16:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715012303; cv=none; b=XHoEx2wxkEeYoouZdyJaNmaVTS5Zgp4HIP1JtugRzmH9672YolsPBXENuMnwLZ6x5igP31zxfOVBP+pApV1alvMtrV+hg0EsX8oJKZaFwb5uL+6hbpyi8ZyL44sfuAjSLXjEyI3CBlhE/1r9VuI4UIJ7z9oFQXZP6/iQ8PfwIlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715012303; c=relaxed/simple;
	bh=fxNefskKpD2OANrNxXrnrAAT0Q0jJDzhonaTjHySxxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fM8UgBtEmGaC9ozx9CkRg+T0tAyiw5JV8tzZWKoDAb7wodxu0XchyFeE6Ju5FYAE7bgpbrM099dCkAsgxCfDWzO4FatjxM2v7vyunGjaShpKEy0NblnFIN1vm0tOyLDyqSz41gQ7R+F3yqZ+ERqAjop41ee9AfNSN8OIpR4ANr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Zl5mrDT5; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446FEDnQ006374;
	Mon, 6 May 2024 16:18:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=kMBRKF0m+ZIYkax/WD20be0LrYx6C1oQnvg851lGN1U=;
 b=Zl5mrDT5E/gnrFcd57mYQEDskqCsM/DYWyxnlk24i+4JEDVhyia1Q97BdBvlS0xzHcto
 eJ/MnMWhpgyXjNs4RybzO79C5YblFikQfLIyJtWBYPoLXe0oiFiVXXDqbIdcJs9Frjvo
 nYSTaUffMQCneTNcN9luweU8m012XUePy2Pl0/ohLoBshkBJ9PwUF5N6h0uQnWe49590
 ovVyNuUfGzhex/XQWrwkld81agaDOUyGoPtLHPuZknLVVvlanRsgSsi7m5cl2qa4JTDd
 iy7yxHg37hcQdLrGmt7AWjTGAPEvnU9YFO0M0iZH8NJPoCeS6R0DkC4Dj5MYGtQR6zC+ SA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xy11k89ny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 16:18:13 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 446GIDHe011646;
	Mon, 6 May 2024 16:18:13 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xy11k89nw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 16:18:13 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 446G9qJ8010635;
	Mon, 6 May 2024 16:18:12 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xx0bp0vec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 16:18:12 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 446GI6Dj48103934
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 May 2024 16:18:08 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A3D0C20043;
	Mon,  6 May 2024 16:18:06 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 12A1D20040;
	Mon,  6 May 2024 16:18:00 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com.com (unknown [9.43.105.31])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 May 2024 16:17:58 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        naveen.n.rao@linux.ibm.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] arch/powerpc/kvm: Optimize the server number -> ICP lookup
Date: Mon,  6 May 2024 21:47:30 +0530
Message-ID: <20240506161735.83358-3-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240506161735.83358-1-gautam@linux.ibm.com>
References: <20240506161735.83358-1-gautam@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UU-kyuhKFyzoEfxvb1KalCQhcwB5PbDh
X-Proofpoint-ORIG-GUID: Br6O1nZSQbn2vhMdQCbldY1bQydJLiY6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_11,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=1 lowpriorityscore=0
 mlxlogscore=220 impostorscore=0 mlxscore=1 adultscore=0 clxscore=1015
 priorityscore=1501 spamscore=1 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405060114

Given a server number, kvmppc_xics_find_server() does a linear search
over the vcpus of a VM. Optimize this logic by using an array to
maintain the mapping between server number -> icp.

Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_xics.c |  4 ++--
 arch/powerpc/kvm/book3s_xics.h | 10 ++--------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_xics.c b/arch/powerpc/kvm/book3s_xics.c
index 12de526f04c4..1dc2f77571e7 100644
--- a/arch/powerpc/kvm/book3s_xics.c
+++ b/arch/powerpc/kvm/book3s_xics.c
@@ -47,8 +47,6 @@
  * TODO
  * ====
  *
- * - Speed up server# -> ICP lookup (array ? hash table ?)
- *
  * - Make ICS lockless as well, or at least a per-interrupt lock or hashed
  *   locks array to improve scalability
  */
@@ -1062,6 +1060,7 @@ static struct kvmppc_ics *kvmppc_xics_create_ics(struct kvm *kvm,
 static int kvmppc_xics_create_icp(struct kvm_vcpu *vcpu, unsigned long server_num)
 {
 	struct kvmppc_icp *icp;
+	struct kvm *kvm = vcpu->kvm;
 
 	if (!vcpu->kvm->arch.xics)
 		return -ENODEV;
@@ -1078,6 +1077,7 @@ static int kvmppc_xics_create_icp(struct kvm_vcpu *vcpu, unsigned long server_nu
 	icp->state.mfrr = MASKED;
 	icp->state.pending_pri = MASKED;
 	vcpu->arch.icp = icp;
+	kvm->arch.xics->icps[server_num] = icp;
 
 	XICS_DBG("created server for vcpu %d\n", vcpu->vcpu_id);
 
diff --git a/arch/powerpc/kvm/book3s_xics.h b/arch/powerpc/kvm/book3s_xics.h
index 8fcb34ea47a4..feeb0897d555 100644
--- a/arch/powerpc/kvm/book3s_xics.h
+++ b/arch/powerpc/kvm/book3s_xics.h
@@ -111,19 +111,13 @@ struct kvmppc_xics {
 	u32 err_noics;
 	u32 err_noicp;
 	struct kvmppc_ics *ics[KVMPPC_XICS_MAX_ICS_ID + 1];
+	DECLARE_FLEX_ARRAY(struct kvmppc_icp *, icps);
 };
 
 static inline struct kvmppc_icp *kvmppc_xics_find_server(struct kvm *kvm,
 							 u32 nr)
 {
-	struct kvm_vcpu *vcpu = NULL;
-	unsigned long i;
-
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (vcpu->arch.icp && nr == vcpu->arch.icp->server_num)
-			return vcpu->arch.icp;
-	}
-	return NULL;
+	return kvm->arch.xics->icps[nr];
 }
 
 static inline struct kvmppc_ics *kvmppc_xics_find_ics(struct kvmppc_xics *xics,
-- 
2.44.0


