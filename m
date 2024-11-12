Return-Path: <kvm+bounces-31642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4642B9C5F08
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 18:33:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9FB37B8138C
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 16:28:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57A392071F1;
	Tue, 12 Nov 2024 16:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GdB0j0Xi"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFAF206E7C;
	Tue, 12 Nov 2024 16:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731428785; cv=none; b=IOINERmOvlErsqYjGHMtFzpmCns5BtouGtZV0hALVfnerN4CgfoKxzjhw1LaCRZHIRvO5ounhg/7RBYS70kxKQHn0q7HMzMc6eqPKlxcj7jjAFRQ835ZVr16qc+6hqoULTGE6i3AFVxD9K6fTTVjA4WuFv2ULIVeRzb0P55jtKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731428785; c=relaxed/simple;
	bh=Ls2C5dAbn1TuHV0GGTkJv3icv2+cvSrD8LtkUTi0Tno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Up/REFFeu0+SxrQdDZeiIfawSZ0oa1M7zrn4xC+5/I1R1EePzJRAmRkj76AxGfPxi7DPIx+9b2KG1wsze0lP1KwDwu0wHzoViY0vuK6HdFUIiIoofl6cFQubsF53XMVdH0JBFuqsmt/KKl3czqLR+vEuGd1FbvhPUQ3OO0I/VsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GdB0j0Xi; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACFe178001995;
	Tue, 12 Nov 2024 16:26:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Tw506hrZ4T0Ft6pUS
	0eidGEC0mgU2GmEStUjpwpYmEY=; b=GdB0j0Xi2JxFFsHvMSP2dLKv02mOKg5eR
	wjEOg1CNOY2sIXheY28eHjYF1y+ETnRI5jmskbja3qVB/o28PArUueXiETQeCZvL
	+5qq4SNuTxWo+SmPeL+vWV5qbx46LHKaTtEIiC3uqqCjRHVwAmh7rg5gTiUE7QzF
	+b45YA58c5qItppGAUgF6Vu12M3Nd3q4bpydadOs96oHjvWTz/Vxli+ivjXxlXhD
	qCRjNlA6lBvdpD+XaBpVTSGOoLMplO/ze6yBge4ZiCi2GqAu0cIhxqwG9ns4d35q
	H7ow1KTbLONGFQoqe4TDLbfEymbsRG8embaiiXFbSgFTnG3NZDExA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42v9uy85ns-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 16:26:17 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AC9ODUZ026315;
	Tue, 12 Nov 2024 16:26:17 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 42tms14dgx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 16:26:17 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4ACGQDm457999766
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 16:26:13 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CB5F120049;
	Tue, 12 Nov 2024 16:26:13 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5BBE120040;
	Tue, 12 Nov 2024 16:26:13 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.179.25.251])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 12 Nov 2024 16:26:13 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        Hendrik Brueckner <brueckner@linux.ibm.com>,
        Hariharan Mari <hari55@linux.ibm.com>
Subject: [GIT PULL 14/14] KVM: s390: selftests: Add regression tests for PFCR subfunctions
Date: Tue, 12 Nov 2024 17:23:28 +0100
Message-ID: <20241112162536.144980-15-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112162536.144980-1-frankja@linux.ibm.com>
References: <20241112162536.144980-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DUGMi_mmSBAlqTZ3l6MNmzVXAuFvnZUR
X-Proofpoint-GUID: DUGMi_mmSBAlqTZ3l6MNmzVXAuFvnZUR
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411120128

From: Hendrik Brueckner <brueckner@linux.ibm.com>

Check if the PFCR query reported in userspace coincides with the
kernel reported function list. Right now we don't mask the functions
in the kernel so they have to be the same.

Signed-off-by: Hendrik Brueckner <brueckner@linux.ibm.com>
Reviewed-by: Hariharan Mari <hari55@linux.ibm.com>
Link: https://lore.kernel.org/r/20241107152319.77816-5-brueckner@linux.ibm.com
[frankja@linux.ibm.com: Added commit description]
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-ID: <20241107152319.77816-5-brueckner@linux.ibm.com>
---
 tools/arch/s390/include/uapi/asm/kvm.h            |  3 ++-
 .../selftests/kvm/s390x/cpumodel_subfuncs_test.c  | 15 +++++++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/arch/s390/include/uapi/asm/kvm.h b/tools/arch/s390/include/uapi/asm/kvm.h
index 05eaf6db3ad4..60345dd2cba2 100644
--- a/tools/arch/s390/include/uapi/asm/kvm.h
+++ b/tools/arch/s390/include/uapi/asm/kvm.h
@@ -469,7 +469,8 @@ struct kvm_s390_vm_cpu_subfunc {
 	__u8 kdsa[16];		/* with MSA9 */
 	__u8 sortl[32];		/* with STFLE.150 */
 	__u8 dfltcc[32];	/* with STFLE.151 */
-	__u8 reserved[1728];
+	__u8 pfcr[16];		/* with STFLE.201 */
+	__u8 reserved[1712];
 };
 
 #define KVM_S390_VM_CPU_PROCESSOR_UV_FEAT_GUEST	6
diff --git a/tools/testing/selftests/kvm/s390x/cpumodel_subfuncs_test.c b/tools/testing/selftests/kvm/s390x/cpumodel_subfuncs_test.c
index 222ba1cc3cac..27255880dabd 100644
--- a/tools/testing/selftests/kvm/s390x/cpumodel_subfuncs_test.c
+++ b/tools/testing/selftests/kvm/s390x/cpumodel_subfuncs_test.c
@@ -214,6 +214,19 @@ static void test_dfltcc_asm_block(u8 (*query)[32])
 			: "cc", "0", "1");
 }
 
+/*
+ * Testing Perform Function with Concurrent Results (PFCR)
+ * CPU subfunctions's ASM block
+ */
+static void test_pfcr_asm_block(u8 (*query)[16])
+{
+	asm volatile("	lghi	0,0\n"
+			"	.insn   rsy,0xeb0000000016,0,0,%[query]\n"
+			: [query] "=QS" (*query)
+			:
+			: "cc", "0");
+}
+
 typedef void (*testfunc_t)(u8 (*array)[]);
 
 struct testdef {
@@ -249,6 +262,8 @@ struct testdef {
 	{ "SORTL", cpu_subfunc.sortl, sizeof(cpu_subfunc.sortl), test_sortl_asm_block, 150 },
 	/* DFLTCC - Facility bit 151 */
 	{ "DFLTCC", cpu_subfunc.dfltcc, sizeof(cpu_subfunc.dfltcc), test_dfltcc_asm_block, 151 },
+	/* Concurrent-function facility - Facility bit 201 */
+	{ "PFCR", cpu_subfunc.pfcr, sizeof(cpu_subfunc.pfcr), test_pfcr_asm_block, 201 },
 };
 
 int main(int argc, char *argv[])
-- 
2.47.0


