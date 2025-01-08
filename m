Return-Path: <kvm+bounces-34794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5F3BA06000
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 16:24:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 778C77A143E
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 15:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D4B71FF1A5;
	Wed,  8 Jan 2025 15:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="a0gA1Et2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDA71FE44A;
	Wed,  8 Jan 2025 15:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736349840; cv=none; b=Chy5KmhP0z/QeonG6+6YVILfWd1i42oV1cunctE+KA4z7DxzNUpPARQc9xTviYHCCQPSENuctAaKWk4dMCQM6pCkIEGO6vrNcVhbSsjAHyY8MWtAkyH/Dx5n1z6HtGyOZQehOs7W4iYN2CMs9kiCS7sl/nUINmZXEVgLB7tyOnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736349840; c=relaxed/simple;
	bh=2aWGuw/P7lMnTTI3J+xRkeX5efYfymkW6XYnjjP3rK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYgaii8gzfnDe4ZBu6SDZr8ipBML3AW5jzVVZj4I0ANmums2V4JPIcQT2WGeSIkTeLwoSU9kduGLcSfM4BYGZ3/Ty3saXzDd+QP1hxmdTmCTNWVeuOiF8DSLwV6r9fGTaXcSewXfedlpTW6I9+Hb3BC3Z2NYvdOMVuMdrMaOyCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=a0gA1Et2; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 508Eev2Z007759;
	Wed, 8 Jan 2025 15:23:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=DoygBlcyPfOhfa4HX
	dadrGC0NHkbjGDlycAcpUzYs2Y=; b=a0gA1Et2jdpncfBezWXoBfdDzrvKNjHFf
	e2xPWtr7zEldZoCfBdRxJh7YkNsuYr5+Ui4UDG3p4O5ozjfXJ22qyB38NuCZzTgS
	g4DlIiwJfXdgAQpfg8/tTHTzCcjsV7rzwovCP55SR1kywxOYGmNT8D0y3CYKkT9R
	xAHjUZ/JPKv8rniTWIzI2AlbhE2u8nxVB6owI5H+CRmEeMHvYBNNKKoKsA2cwQpS
	GhjXPlqDaG1K06cdT57Lrl+aft+6qcKy76KFj7MkAEW+Bw1iAbxBlF8ixNOykrh8
	WHvmafEAr4Q5lzkbUpKGdqpGE4sDZVX0pRBlP382qQe32yGXM8HDA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441hupu164-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 15:23:55 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 508E367C027938;
	Wed, 8 Jan 2025 15:23:55 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 43yhhk848c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 15:23:54 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 508FNpOd32244406
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jan 2025 15:23:51 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 252102004B;
	Wed,  8 Jan 2025 15:23:51 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 041652005A;
	Wed,  8 Jan 2025 15:23:51 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jan 2025 15:23:50 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 3/6] KVM: s390: selftests: Add ucontrol flic attr selftests
Date: Wed,  8 Jan 2025 16:23:47 +0100
Message-ID: <20250108152350.48892-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250108152350.48892-1-imbrenda@linux.ibm.com>
References: <20250108152350.48892-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7QLVN9S9prRrsxO8KfAiWm4__-RRri1p
X-Proofpoint-GUID: 7QLVN9S9prRrsxO8KfAiWm4__-RRri1p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 bulkscore=0 impostorscore=0 mlxlogscore=981
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501080125

From: Christoph Schlameuss <schlameuss@linux.ibm.com>

Add some superficial selftests for the floating interrupt controller
when using ucontrol VMs. These tests are intended to cover very basic
calls only.

Some of the calls may trigger null pointer dereferences on kernels not
containing the fixes in this patch series.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Tested-by: Hariharan Mari <hari55@linux.ibm.com>
Reviewed-by: Hariharan Mari <hari55@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20241216092140.329196-3-schlameuss@linux.ibm.com
Message-ID: <20241216092140.329196-3-schlameuss@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 .../selftests/kvm/s390x/ucontrol_test.c       | 148 ++++++++++++++++++
 1 file changed, 148 insertions(+)

diff --git a/tools/testing/selftests/kvm/s390x/ucontrol_test.c b/tools/testing/selftests/kvm/s390x/ucontrol_test.c
index 0c112319dab1..b003abda8495 100644
--- a/tools/testing/selftests/kvm/s390x/ucontrol_test.c
+++ b/tools/testing/selftests/kvm/s390x/ucontrol_test.c
@@ -635,4 +635,152 @@ TEST_F(uc_kvm, uc_skey)
 	uc_assert_diag44(self);
 }
 
+static char uc_flic_b[PAGE_SIZE];
+static struct kvm_s390_io_adapter uc_flic_ioa = { .id = 0 };
+static struct kvm_s390_io_adapter_req uc_flic_ioam = { .id = 0 };
+static struct kvm_s390_ais_req uc_flic_asim = { .isc = 0 };
+static struct kvm_s390_ais_all uc_flic_asima = { .simm = 0 };
+static struct uc_flic_attr_test {
+	char *name;
+	struct kvm_device_attr a;
+	int hasrc;
+	int geterrno;
+	int seterrno;
+} uc_flic_attr_tests[] = {
+	{
+		.name = "KVM_DEV_FLIC_GET_ALL_IRQS",
+		.seterrno = EINVAL,
+		.a = {
+			.group = KVM_DEV_FLIC_GET_ALL_IRQS,
+			.addr = (u64)&uc_flic_b,
+			.attr = PAGE_SIZE,
+		},
+	},
+	{
+		.name = "KVM_DEV_FLIC_ENQUEUE",
+		.geterrno = EINVAL,
+		.a = { .group = KVM_DEV_FLIC_ENQUEUE, },
+	},
+	{
+		.name = "KVM_DEV_FLIC_CLEAR_IRQS",
+		.geterrno = EINVAL,
+		.a = { .group = KVM_DEV_FLIC_CLEAR_IRQS, },
+	},
+	{
+		.name = "KVM_DEV_FLIC_ADAPTER_REGISTER",
+		.geterrno = EINVAL,
+		.a = {
+			.group = KVM_DEV_FLIC_ADAPTER_REGISTER,
+			.addr = (u64)&uc_flic_ioa,
+		},
+	},
+	{
+		.name = "KVM_DEV_FLIC_ADAPTER_MODIFY",
+		.geterrno = EINVAL,
+		.seterrno = EINVAL,
+		.a = {
+			.group = KVM_DEV_FLIC_ADAPTER_MODIFY,
+			.addr = (u64)&uc_flic_ioam,
+			.attr = sizeof(uc_flic_ioam),
+		},
+	},
+	{
+		.name = "KVM_DEV_FLIC_CLEAR_IO_IRQ",
+		.geterrno = EINVAL,
+		.seterrno = EINVAL,
+		.a = {
+			.group = KVM_DEV_FLIC_CLEAR_IO_IRQ,
+			.attr = 32,
+		},
+	},
+	{
+		.name = "KVM_DEV_FLIC_AISM",
+		.geterrno = EINVAL,
+		.seterrno = ENOTSUP,
+		.a = {
+			.group = KVM_DEV_FLIC_AISM,
+			.addr = (u64)&uc_flic_asim,
+		},
+	},
+	{
+		.name = "KVM_DEV_FLIC_AIRQ_INJECT",
+		.geterrno = EINVAL,
+		.a = { .group = KVM_DEV_FLIC_AIRQ_INJECT, },
+	},
+	{
+		.name = "KVM_DEV_FLIC_AISM_ALL",
+		.geterrno = ENOTSUP,
+		.seterrno = ENOTSUP,
+		.a = {
+			.group = KVM_DEV_FLIC_AISM_ALL,
+			.addr = (u64)&uc_flic_asima,
+			.attr = sizeof(uc_flic_asima),
+		},
+	},
+	{
+		.name = "KVM_DEV_FLIC_APF_ENABLE",
+		.geterrno = EINVAL,
+		.seterrno = EINVAL,
+		.a = { .group = KVM_DEV_FLIC_APF_ENABLE, },
+	},
+	{
+		.name = "KVM_DEV_FLIC_APF_DISABLE_WAIT",
+		.geterrno = EINVAL,
+		.seterrno = EINVAL,
+		.a = { .group = KVM_DEV_FLIC_APF_DISABLE_WAIT, },
+	},
+};
+
+TEST_F(uc_kvm, uc_flic_attrs)
+{
+	struct kvm_create_device cd = { .type = KVM_DEV_TYPE_FLIC };
+	struct kvm_device_attr attr;
+	u64 value;
+	int rc, i;
+
+	rc = ioctl(self->vm_fd, KVM_CREATE_DEVICE, &cd);
+	ASSERT_EQ(0, rc) TH_LOG("create device failed with err %s (%i)",
+				strerror(errno), errno);
+
+	for (i = 0; i < ARRAY_SIZE(uc_flic_attr_tests); i++) {
+		TH_LOG("test %s", uc_flic_attr_tests[i].name);
+		attr = (struct kvm_device_attr) {
+			.group = uc_flic_attr_tests[i].a.group,
+			.attr = uc_flic_attr_tests[i].a.attr,
+			.addr = uc_flic_attr_tests[i].a.addr,
+		};
+		if (attr.addr == 0)
+			attr.addr = (u64)&value;
+
+		rc = ioctl(cd.fd, KVM_HAS_DEVICE_ATTR, &attr);
+		EXPECT_EQ(uc_flic_attr_tests[i].hasrc, !!rc)
+			TH_LOG("expected dev attr missing %s",
+			       uc_flic_attr_tests[i].name);
+
+		rc = ioctl(cd.fd, KVM_GET_DEVICE_ATTR, &attr);
+		EXPECT_EQ(!!uc_flic_attr_tests[i].geterrno, !!rc)
+			TH_LOG("get dev attr rc not expected on %s %s (%i)",
+			       uc_flic_attr_tests[i].name,
+			       strerror(errno), errno);
+		if (uc_flic_attr_tests[i].geterrno)
+			EXPECT_EQ(uc_flic_attr_tests[i].geterrno, errno)
+				TH_LOG("get dev attr errno not expected on %s %s (%i)",
+				       uc_flic_attr_tests[i].name,
+				       strerror(errno), errno);
+
+		rc = ioctl(cd.fd, KVM_SET_DEVICE_ATTR, &attr);
+		EXPECT_EQ(!!uc_flic_attr_tests[i].seterrno, !!rc)
+			TH_LOG("set sev attr rc not expected on %s %s (%i)",
+			       uc_flic_attr_tests[i].name,
+			       strerror(errno), errno);
+		if (uc_flic_attr_tests[i].seterrno)
+			EXPECT_EQ(uc_flic_attr_tests[i].seterrno, errno)
+				TH_LOG("set dev attr errno not expected on %s %s (%i)",
+				       uc_flic_attr_tests[i].name,
+				       strerror(errno), errno);
+	}
+
+	close(cd.fd);
+}
+
 TEST_HARNESS_MAIN
-- 
2.47.1


