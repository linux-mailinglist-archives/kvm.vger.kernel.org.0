Return-Path: <kvm+bounces-3112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAB8B800BCE
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 14:27:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96E41281B26
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 13:27:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F319C38DD6;
	Fri,  1 Dec 2023 13:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cutsJ9WW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F85410FC;
	Fri,  1 Dec 2023 05:26:54 -0800 (PST)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B1DKZuW024224;
	Fri, 1 Dec 2023 13:26:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=reBjbPAr8Lkq8KH0ouJiy4zNFmnDKKwSU4TDkA31Z8w=;
 b=cutsJ9WWoIoTfhaQcqd+PZgdeA2hm2jYz6ITFEi/7AMW+aupyNTuexfyYXcPLeB9FrKO
 KfkWGy88EuPsQ3vq56FAtZsruW/WT5cgUHc4qRBl3nzCgpGmhtvI1knU41t6KXEv1lpL
 bHl6eaktKL0EK432SxMBt4XgzQccUh1zOHR83td85TWh0F8zUDVCYLJG1JcXDl02+Oh+
 oQVrmdHYvSKi+aP73fqBIE3uxHui3LCJAPltO3vzICBnj2H1LgfkGQ2wQ55j44MbcAAS
 K8XLx8evFP+Omy3mxLqbK335gtQ16uk8CQEOxbHED6pbzzglR/LkYLBhAhRNvwo5ttfe Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqg5pgas6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 13:26:42 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B1DKnWO026405;
	Fri, 1 Dec 2023 13:26:42 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqg5pgarp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 13:26:41 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B1AXqV2017327;
	Fri, 1 Dec 2023 13:26:41 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ukwy2cpp8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 13:26:40 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B1DQcEi22020696
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 1 Dec 2023 13:26:38 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1975C20043;
	Fri,  1 Dec 2023 13:26:38 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 65F6520040;
	Fri,  1 Dec 2023 13:26:34 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.171.33.138])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri,  1 Dec 2023 13:26:34 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Fri, 01 Dec 2023 18:56:33 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jordan Niethe <jniethe5@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, mikey@neuling.org,
        paulus@ozlabs.org, sbhat@linux.ibm.com, gautam@linux.ibm.com,
        kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com,
        David.Laight@ACULAB.COM
Subject: [PATCH 02/12] KVM: PPC: Book3S HV nestedv2: Avoid reloading the tb offset
Date: Fri,  1 Dec 2023 18:56:07 +0530
Message-ID: <20231201132618.555031-3-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231201132618.555031-1-vaibhav@linux.ibm.com>
References: <20231201132618.555031-1-vaibhav@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 81ERVNiWMnhXug-5T7_6O1UY1zhYZLRm
X-Proofpoint-ORIG-GUID: toCyy_pzqNcXE-ExZ1Y6S_r9gSatfJc_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-01_11,2023-11-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxlogscore=696 spamscore=0
 malwarescore=0 impostorscore=0 mlxscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2312010092

From: Jordan Niethe <jniethe5@gmail.com>

The kvmppc_get_tb_offset() getter reloads KVMPPC_GSID_TB_OFFSET from the
L0 for nestedv2 host. This is unnecessary as the value does not change.
KVMPPC_GSID_TB_OFFSET also need not be reloaded in
kvmppc_{s,g}et_dec_expires().

Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
---
 arch/powerpc/include/asm/kvm_book3s.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index a37736ed3728..3e1e2a698c9e 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -594,13 +594,17 @@ static inline u##size kvmppc_get_##reg(struct kvm_vcpu *vcpu)		\
 
 
 KVMPPC_BOOK3S_VCORE_ACCESSOR(vtb, 64, KVMPPC_GSID_VTB)
-KVMPPC_BOOK3S_VCORE_ACCESSOR(tb_offset, 64, KVMPPC_GSID_TB_OFFSET)
 KVMPPC_BOOK3S_VCORE_ACCESSOR_GET(arch_compat, 32, KVMPPC_GSID_LOGICAL_PVR)
 KVMPPC_BOOK3S_VCORE_ACCESSOR_GET(lpcr, 64, KVMPPC_GSID_LPCR)
+KVMPPC_BOOK3S_VCORE_ACCESSOR_SET(tb_offset, 64, KVMPPC_GSID_TB_OFFSET)
+
+static inline u64 kvmppc_get_tb_offset(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.vcore->tb_offset;
+}
 
 static inline u64 kvmppc_get_dec_expires(struct kvm_vcpu *vcpu)
 {
-	WARN_ON(kvmhv_nestedv2_cached_reload(vcpu, KVMPPC_GSID_TB_OFFSET) < 0);
 	WARN_ON(kvmhv_nestedv2_cached_reload(vcpu, KVMPPC_GSID_DEC_EXPIRY_TB) < 0);
 	return vcpu->arch.dec_expires;
 }
@@ -608,7 +612,6 @@ static inline u64 kvmppc_get_dec_expires(struct kvm_vcpu *vcpu)
 static inline void kvmppc_set_dec_expires(struct kvm_vcpu *vcpu, u64 val)
 {
 	vcpu->arch.dec_expires = val;
-	WARN_ON(kvmhv_nestedv2_cached_reload(vcpu, KVMPPC_GSID_TB_OFFSET) < 0);
 	kvmhv_nestedv2_mark_dirty(vcpu, KVMPPC_GSID_DEC_EXPIRY_TB);
 }
 
-- 
2.42.0


