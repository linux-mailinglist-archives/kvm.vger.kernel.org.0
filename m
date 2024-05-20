Return-Path: <kvm+bounces-17748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 078528C99C0
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 10:21:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB83F1C212AB
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 08:21:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C58F22EE4;
	Mon, 20 May 2024 08:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GwSaaqAx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C58208A7;
	Mon, 20 May 2024 08:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716193260; cv=none; b=CvujqDfSvCetZst9w9s76A63o//s9l07tXUxPoE3c8dK7/bE4Cep7ug44VeOtkmH26bW8qqR0C3z5gc3fOBThWwwDkKiX3cjrBB39uZ5KId3RIDNmaYNYVwVPgXhWk1s8lj7uzclIrWuHLxD0FdlsG4rfLHSRkGg6TJVX4RO3Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716193260; c=relaxed/simple;
	bh=fxNefskKpD2OANrNxXrnrAAT0Q0jJDzhonaTjHySxxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SC47B8pr/eP+GcWDO3XkJD9zShzqJJQFThcGHwEsdU0rfWgaIuD4+6QOcxte+ulLoJxbftASBbdDs37vhrN0rSzdmpkXDABNgxrtiSzgTS8lUWDOMn284/xPshO1tb/LlpKc41HlZyD1UNhfutT+NYj/QnUePIIraZQPCKp4dN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GwSaaqAx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44K684Ft008783;
	Mon, 20 May 2024 08:20:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=kMBRKF0m+ZIYkax/WD20be0LrYx6C1oQnvg851lGN1U=;
 b=GwSaaqAxU7fBS45CbPzdk+Eh1M2bMy1+RCeu+HwXyRFB30p/7e0ZSb4rnYe7S/GJd4Wd
 Aa1+6Zv1UCvtzOSX/kqhbOvbJ2EyiEhO80MxHz7Uq1EzpTir57ahLKc1ACDlY+Fv9UFM
 lQ0wdniDzT0qzd4j1hMjM9HQwJUnOZI9rqkBN+mJhyDDE3ZucSede9AFFoN5grad5mgy
 GJnok1psKZc12jLXb5m5iyJskvX2vbteA01NkfGSk2GLhWW34sZ+Qx+hVDgh12oa1HgQ
 hxLVikcWK5Yo5jT2T7wGPYNLyOx/aWI+SmJ7nKdhrx9XUVGX1oXir67V2RMd6jrM2tfw 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y80ypg8w5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 May 2024 08:20:43 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44K8KT6c014300;
	Mon, 20 May 2024 08:20:42 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y80ypg8w3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 May 2024 08:20:42 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44K6bAZB026443;
	Mon, 20 May 2024 08:20:41 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3y785m6kjv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 May 2024 08:20:41 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44K8KaJe40042904
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 May 2024 08:20:38 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0203120040;
	Mon, 20 May 2024 08:20:36 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 350FC2004B;
	Mon, 20 May 2024 08:20:34 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.in.ibm.com (unknown [9.204.206.66])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 20 May 2024 08:20:34 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        naveen.n.rao@linux.ibm.com, clg@kaod.org
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 2/3] arch/powerpc/kvm: Optimize the server number -> ICP lookup
Date: Mon, 20 May 2024 13:50:09 +0530
Message-ID: <20240520082014.140697-3-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240520082014.140697-1-gautam@linux.ibm.com>
References: <20240520082014.140697-1-gautam@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PltlRD2anSDEkJRtIzHJsy7VWpiniW7Z
X-Proofpoint-ORIG-GUID: UMKHA2d_CikoIcN3Wo1bJNJlLclWVs95
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-20_04,2024-05-17_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=19 impostorscore=0
 mlxlogscore=62 clxscore=1015 bulkscore=0 suspectscore=0 adultscore=0
 malwarescore=0 spamscore=19 phishscore=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=19 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2405010000 definitions=main-2405200068

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


