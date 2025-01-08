Return-Path: <kvm+bounces-34796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 20F90A06004
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 16:24:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B26833A5C4B
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 15:24:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C4FF1FF1C1;
	Wed,  8 Jan 2025 15:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hWLQhQXq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E098B1FE457;
	Wed,  8 Jan 2025 15:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736349841; cv=none; b=SHSNLotka23Pma5wTjDlCaEgAE6IQnOzrdU+F1iADCzWzJ9A2v5ZnU0N70XagyxJVF6SuQB3UzH+X++5P8qGPUl0IPt4S4jUPHUdzVnmhTt4qnwO2+4nsUgrys3Tt+UjMPCYMHiD+Rt/weRK9X3uNBlL37si2yc/fCq9kxS6Bj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736349841; c=relaxed/simple;
	bh=AgBUjslbvaEhi2CBxS6HSyzRa+UVv04QaN0KeG/fQEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oloJSZiQNNBqZxlU4uLDCJHU8MdoQPY33IbahKZWrmxcq4lRq/70B125uBMvIPz0azBnb1+PAYvxDKpQGg1ahSM9eOI3Kr7H7+bYngfaJl5ChAmUFhwfOy0eOth/BNRNb+qwBX/wcv1mnWUd8k9xc4iWa4KKXeGSzB9Lo5n8M8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hWLQhQXq; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 508D8T2h023466;
	Wed, 8 Jan 2025 15:23:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=3WKwMxV0ryo+9oZbd
	sqKkPCWNGJ37V5SgpiOpgFtZHM=; b=hWLQhQXqbCASTSr/nZOKURCmD+v2BPHT7
	Vt6Ast5TChEQhbdlKM3dqgsZ5eCxOdo5a2IjYV79mAMN0zxrZ3gVjT51N+cTv2QH
	hmpAEOxOXjk8FrxDB01pM/nqEf68D3nZHzQR/eQyKfHVYfCNC/quISw8YnXrAoTn
	grKxrH7js0Q9NuTx46PH0kWpXdn5Fc96T7GiLdE24H0XNA1WDeiDlMUH/NzWo88B
	mFjRkmuufNJ0NBNk6qLouh24EinNmf+SREkS7Qq96Jr+CR5iN/gPNxiDb6nNhpg3
	Xk0sPf2LwypummEKJmlPDJvmf5YCFMEV8XCygNU+o7EQlMdbZnyXA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441edj3qq2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 15:23:56 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 508Dlg9J016144;
	Wed, 8 Jan 2025 15:23:55 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43ygtm083h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 15:23:55 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 508FNpfj32244410
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jan 2025 15:23:51 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6AA6C2004B;
	Wed,  8 Jan 2025 15:23:51 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4C4A12004E;
	Wed,  8 Jan 2025 15:23:51 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jan 2025 15:23:51 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 5/6] KVM: s390: selftests: Add ucontrol gis routing test
Date: Wed,  8 Jan 2025 16:23:49 +0100
Message-ID: <20250108152350.48892-6-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: hsUsYzEOaTo4A9A9x7KvuktwGWu_CNK6
X-Proofpoint-ORIG-GUID: hsUsYzEOaTo4A9A9x7KvuktwGWu_CNK6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501080125

From: Christoph Schlameuss <schlameuss@linux.ibm.com>

Add a selftests for the interrupt routing configuration when using
ucontrol VMs.

Calling the test may trigger a null pointer dereferences on kernels not
containing the fixes in this patch series.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Tested-by: Hariharan Mari <hari55@linux.ibm.com>
Reviewed-by: Hariharan Mari <hari55@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20241216092140.329196-5-schlameuss@linux.ibm.com
Message-ID: <20241216092140.329196-5-schlameuss@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 .../selftests/kvm/s390x/ucontrol_test.c       | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/kvm/s390x/ucontrol_test.c b/tools/testing/selftests/kvm/s390x/ucontrol_test.c
index b003abda8495..8f306395696e 100644
--- a/tools/testing/selftests/kvm/s390x/ucontrol_test.c
+++ b/tools/testing/selftests/kvm/s390x/ucontrol_test.c
@@ -783,4 +783,23 @@ TEST_F(uc_kvm, uc_flic_attrs)
 	close(cd.fd);
 }
 
+TEST_F(uc_kvm, uc_set_gsi_routing)
+{
+	struct kvm_irq_routing *routing = kvm_gsi_routing_create();
+	struct kvm_irq_routing_entry ue = {
+		.type = KVM_IRQ_ROUTING_S390_ADAPTER,
+		.gsi = 1,
+		.u.adapter = (struct kvm_irq_routing_s390_adapter) {
+			.ind_addr = 0,
+		},
+	};
+	int rc;
+
+	routing->entries[0] = ue;
+	routing->nr = 1;
+	rc = ioctl(self->vm_fd, KVM_SET_GSI_ROUTING, routing);
+	ASSERT_EQ(-1, rc) TH_LOG("err %s (%i)", strerror(errno), errno);
+	ASSERT_EQ(EINVAL, errno) TH_LOG("err %s (%i)", strerror(errno), errno);
+}
+
 TEST_HARNESS_MAIN
-- 
2.47.1


