Return-Path: <kvm+bounces-31638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38E719C5E10
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 18:01:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 45366B6734D
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 16:27:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4300C206E65;
	Tue, 12 Nov 2024 16:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZDxAjgOL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEB8206073;
	Tue, 12 Nov 2024 16:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731428781; cv=none; b=g0fX1Xfy+YQ43D7au+xqmqKPzQ1xXDIffdBeoWerQfwdXxCEz+mdO8x3lWUEgxO+ZSTAwUqqN0X/gWk88KIxdOhLWWlvNAMs1GOYR3NspQgrUaeQW27E/sVZQAKmSP3u6VrrPYqCSzq2vYzwjPqOi1sRvWFyWLx5sduJR1uQxuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731428781; c=relaxed/simple;
	bh=AexSQRVS5rKkt0DgL+/WM9FNpcv1C7TCztKXRMJFIHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUHDRzMqzyu6wcEIjgN3R3d5r2x0u1ZmQBA2ZHhfZ1ixtct8hbRMonnvBrnbqDNxf9Wt711gt0BylDXwiEKFJi/M3PrvR0CfJ3ox5pgxl2s0TBYYvrtrpsrbm3NVDbUfIQrKoiYgmvbD+Kj60hdxSNTuw6lhqVrMjovunWgRFBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZDxAjgOL; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACEZ57o007745;
	Tue, 12 Nov 2024 16:26:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=3tW+kfFb+rFkrfbVF
	leFFTT2ZpCN9vS0dENP8mTN54M=; b=ZDxAjgOLgmiDoAZ7WfRb9DXD4Ez+n1yj/
	Um2TlbImuWbJDzPvdqTtud9lV1wpiaOwz4sWrMsOp2dW2HwHjZsNLawHUIxhBfzV
	FEotpmfKTWkvv/G27tlN6C7+WJnDc+vGeYFSimsSBsjnqwzBnMsZ7caKE5DJSBQ1
	bDd71Wj2Sb3OPfM0fSN3QRxfB8RxnJfmeJdN6oKckFgQ5MGcdo+d29XOXDHBHEZK
	qCItsU/fnC4rBJIDxnEgDYEFdgI3rAeNMerANC44BjUAVKiWO/KIkzenfPsWScYU
	y6hglBKuIv8PeTKWiHljT+BXP1QfRhWSGdzmb9OlmFxRVT9bAaLWw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42v8wmghmj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 16:26:16 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AC995cR021445;
	Tue, 12 Nov 2024 16:26:15 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 42tms14dgw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 16:26:15 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4ACGQCv256230366
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 16:26:12 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E4A120040;
	Tue, 12 Nov 2024 16:26:12 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A51A720049;
	Tue, 12 Nov 2024 16:26:11 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.179.25.251])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 12 Nov 2024 16:26:11 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        Hendrik Brueckner <brueckner@linux.ibm.com>
Subject: [GIT PULL 11/14] KVM: s390: add concurrent-function facility to cpu model
Date: Tue, 12 Nov 2024 17:23:25 +0100
Message-ID: <20241112162536.144980-12-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112162536.144980-1-frankja@linux.ibm.com>
References: <20241112162536.144980-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pEF_gbjiFN1jy9DsFYlkwhrXNqPlH0-L
X-Proofpoint-GUID: pEF_gbjiFN1jy9DsFYlkwhrXNqPlH0-L
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=544 impostorscore=0
 clxscore=1015 bulkscore=0 mlxscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411120125

From: Hendrik Brueckner <brueckner@linux.ibm.com>

Adding support for concurrent-functions facility which provides
additional subfunctions.

Signed-off-by: Hendrik Brueckner <brueckner@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Link: https://lore.kernel.org/r/20241107152319.77816-2-brueckner@linux.ibm.com
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-ID: <20241107152319.77816-2-brueckner@linux.ibm.com>
---
 arch/s390/include/uapi/asm/kvm.h |  3 ++-
 arch/s390/kvm/kvm-s390.c         | 22 ++++++++++++++++++++++
 arch/s390/tools/gen_facilities.c |  1 +
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
index 05eaf6db3ad4..60345dd2cba2 100644
--- a/arch/s390/include/uapi/asm/kvm.h
+++ b/arch/s390/include/uapi/asm/kvm.h
@@ -469,7 +469,8 @@ struct kvm_s390_vm_cpu_subfunc {
 	__u8 kdsa[16];		/* with MSA9 */
 	__u8 sortl[32];		/* with STFLE.150 */
 	__u8 dfltcc[32];	/* with STFLE.151 */
-	__u8 reserved[1728];
+	__u8 pfcr[16];		/* with STFLE.201 */
+	__u8 reserved[1712];
 };
 
 #define KVM_S390_VM_CPU_PROCESSOR_UV_FEAT_GUEST	6
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index bb7134faaebf..74f385b5efbd 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -348,6 +348,16 @@ static inline int plo_test_bit(unsigned char nr)
 	return cc == 0;
 }
 
+static __always_inline void pfcr_query(u8 (*query)[16])
+{
+	asm volatile(
+		"	lghi	0,0\n"
+		"	.insn   rsy,0xeb0000000016,0,0,%[query]\n"
+		: [query] "=QS" (*query)
+		:
+		: "cc", "0");
+}
+
 static __always_inline void __sortl_query(u8 (*query)[32])
 {
 	asm volatile(
@@ -429,6 +439,9 @@ static void __init kvm_s390_cpu_feat_init(void)
 	if (test_facility(151)) /* DFLTCC */
 		__dfltcc_query(&kvm_s390_available_subfunc.dfltcc);
 
+	if (test_facility(201))	/* PFCR */
+		pfcr_query(&kvm_s390_available_subfunc.pfcr);
+
 	if (MACHINE_HAS_ESOP)
 		allow_cpu_feat(KVM_S390_VM_CPU_FEAT_ESOP);
 	/*
@@ -1543,6 +1556,9 @@ static int kvm_s390_set_processor_subfunc(struct kvm *kvm,
 		 ((unsigned long *) &kvm->arch.model.subfuncs.dfltcc)[1],
 		 ((unsigned long *) &kvm->arch.model.subfuncs.dfltcc)[2],
 		 ((unsigned long *) &kvm->arch.model.subfuncs.dfltcc)[3]);
+	VM_EVENT(kvm, 3, "GET: guest PFCR   subfunc 0x%16.16lx.%16.16lx",
+		 ((unsigned long *) &kvm_s390_available_subfunc.pfcr)[0],
+		 ((unsigned long *) &kvm_s390_available_subfunc.pfcr)[1]);
 
 	return 0;
 }
@@ -1757,6 +1773,9 @@ static int kvm_s390_get_processor_subfunc(struct kvm *kvm,
 		 ((unsigned long *) &kvm->arch.model.subfuncs.dfltcc)[1],
 		 ((unsigned long *) &kvm->arch.model.subfuncs.dfltcc)[2],
 		 ((unsigned long *) &kvm->arch.model.subfuncs.dfltcc)[3]);
+	VM_EVENT(kvm, 3, "GET: guest PFCR   subfunc 0x%16.16lx.%16.16lx",
+		 ((unsigned long *) &kvm_s390_available_subfunc.pfcr)[0],
+		 ((unsigned long *) &kvm_s390_available_subfunc.pfcr)[1]);
 
 	return 0;
 }
@@ -1825,6 +1844,9 @@ static int kvm_s390_get_machine_subfunc(struct kvm *kvm,
 		 ((unsigned long *) &kvm_s390_available_subfunc.dfltcc)[1],
 		 ((unsigned long *) &kvm_s390_available_subfunc.dfltcc)[2],
 		 ((unsigned long *) &kvm_s390_available_subfunc.dfltcc)[3]);
+	VM_EVENT(kvm, 3, "GET: host  PFCR   subfunc 0x%16.16lx.%16.16lx",
+		 ((unsigned long *) &kvm_s390_available_subfunc.pfcr)[0],
+		 ((unsigned long *) &kvm_s390_available_subfunc.pfcr)[1]);
 
 	return 0;
 }
diff --git a/arch/s390/tools/gen_facilities.c b/arch/s390/tools/gen_facilities.c
index 68580cbea4e6..1d0efd3c3e7c 100644
--- a/arch/s390/tools/gen_facilities.c
+++ b/arch/s390/tools/gen_facilities.c
@@ -113,6 +113,7 @@ static struct facility_def facility_defs[] = {
 			194, /* rdp enhancement facility */
 			196, /* processor activity instrumentation facility */
 			197, /* processor activity instrumentation extension 1 */
+			201, /* concurrent-functions facility */
 			-1  /* END */
 		}
 	},
-- 
2.47.0


