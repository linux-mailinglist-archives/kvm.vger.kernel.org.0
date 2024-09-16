Return-Path: <kvm+bounces-26971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0433B979FA8
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 12:46:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 54545B20F98
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 10:46:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AD33155C97;
	Mon, 16 Sep 2024 10:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="P7T1/hrU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67D81547C8;
	Mon, 16 Sep 2024 10:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726483556; cv=none; b=R9hZn+S2ahNQJmffoW/nfzc8osTrRIJQ9fbJkvLbWzt0msqV/sdzLW7wHyznF2VaXJPPkpymcxbdqv2hN24GJxCE22FJ2Tbl0xJgqjoSq23fLHHmjV+2Ov42S14OT12I/L+ookw+ibI7IqeLuOM7i9ooSv+UZaFvCLaM9AoP+oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726483556; c=relaxed/simple;
	bh=NY8RAeZyhJn0mfbPuJlwU4JqS4GRA6Q9CWtxsiXARKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRqopv5gaN6TnEYLgmdYGCUPxCcRRWFcoCQCgPFm2biF4tvezb4QNycCOucH9WkAfmDsb7SkgrVrd6ozEtUVADkJxl0vVO1QeJBN9/aPk4LPLi0BWZWHhYeYxonjcRuZap94V2f/381y8NdMGwYeAdGHKUIEtgJRVOEyOx19yzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=P7T1/hrU; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48G9ARBH004522;
	Mon, 16 Sep 2024 10:45:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:mime-version; s=pp1; bh=huwLcGqX6csiV
	LUuZiG3gpLE2gCS/JSdZVt0xXP7WNQ=; b=P7T1/hrUAqDTKCuZI317+R8YjSWyt
	BuwjvLHg/HXgb3mcltxyxeO01Yy9Q9B0JQ6+JOJcaTckOUzN05/UcuXOXAzDQrzP
	TPAPvoG6zWWG1K0N2CYlz+JJwBuDWiaHMD+EjGjVt9PgWxrEQM9wPz369CfNUdOL
	lfqRr67fhX+oOzmYOnKwb+19hsQ+S6x3s3YI27nP7dNAzhfURQehb4cfIK6gv9RY
	y+r9KDf56jxFBa0pyRL7zGu2KAekDz1Th1g+0v+rR/FnsV+aXNn467Ipb0Sx00GI
	bXyzm7N8QIt3SWeimk6L9hU/jy9gsjDufhNkWcTBqXKKQ1iffFi0O5hHA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41pht88f7m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Sep 2024 10:45:48 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 48GAjl1T015428;
	Mon, 16 Sep 2024 10:45:47 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41pht88f7h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Sep 2024 10:45:47 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48GAaSx3001960;
	Mon, 16 Sep 2024 10:45:46 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 41nmtuf0de-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Sep 2024 10:45:46 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48GAjhWs41157042
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 10:45:43 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 16CB020049;
	Mon, 16 Sep 2024 10:45:43 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB4FC2004D;
	Mon, 16 Sep 2024 10:45:42 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.179.30.170])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 16 Sep 2024 10:45:42 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
Subject: [GIT PULL 4/8] selftests: kvm: s390: Add s390x ucontrol test suite with hpage test
Date: Mon, 16 Sep 2024 12:42:59 +0200
Message-ID: <20240916104458.66521-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916104458.66521-1-frankja@linux.ibm.com>
References: <20240916104458.66521-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PU4twOuysaig1X8h8qMjs-HLRKcCbPOI
X-Proofpoint-ORIG-GUID: AejXhaYyjikldyixxJxVx8qA4HkSF58H
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-16_06,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 bulkscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 mlxlogscore=985 mlxscore=0 clxscore=1015 malwarescore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409160065

From: Christoph Schlameuss <schlameuss@linux.ibm.com>

Add test suite to validate the s390x architecture specific ucontrol KVM
interface.

Make use of the selftest test harness.

* uc_cap_hpage testcase verifies that a ucontrol VM cannot be run with
  hugepages.

To allow testing of the ucontrol interface the kernel needs a
non-default config containing CONFIG_KVM_S390_UCONTROL.
This config needs to be set to built-in (y) as this cannot be built as
module.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20240807154512.316936-4-schlameuss@linux.ibm.com
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-ID: <20240807154512.316936-4-schlameuss@linux.ibm.com>
---
 tools/testing/selftests/kvm/.gitignore        |  1 +
 tools/testing/selftests/kvm/Makefile          |  1 +
 tools/testing/selftests/kvm/s390x/config      |  2 +
 .../selftests/kvm/s390x/ucontrol_test.c       | 76 +++++++++++++++++++
 4 files changed, 80 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/s390x/config
 create mode 100644 tools/testing/selftests/kvm/s390x/ucontrol_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 6d9381d60172..f2a30a58cd71 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -5,3 +5,4 @@
 !*.h
 !*.S
 !*.sh
+!config
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 48d32c5aa3eb..b3dc0a5bf0d4 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -186,6 +186,7 @@ TEST_GEN_PROGS_s390x += s390x/tprot
 TEST_GEN_PROGS_s390x += s390x/cmma_test
 TEST_GEN_PROGS_s390x += s390x/debug_test
 TEST_GEN_PROGS_s390x += s390x/shared_zeropage_test
+TEST_GEN_PROGS_s390x += s390x/ucontrol_test
 TEST_GEN_PROGS_s390x += demand_paging_test
 TEST_GEN_PROGS_s390x += dirty_log_test
 TEST_GEN_PROGS_s390x += guest_print_test
diff --git a/tools/testing/selftests/kvm/s390x/config b/tools/testing/selftests/kvm/s390x/config
new file mode 100644
index 000000000000..23270f2d679f
--- /dev/null
+++ b/tools/testing/selftests/kvm/s390x/config
@@ -0,0 +1,2 @@
+CONFIG_KVM=y
+CONFIG_KVM_S390_UCONTROL=y
diff --git a/tools/testing/selftests/kvm/s390x/ucontrol_test.c b/tools/testing/selftests/kvm/s390x/ucontrol_test.c
new file mode 100644
index 000000000000..cd68e7e37d35
--- /dev/null
+++ b/tools/testing/selftests/kvm/s390x/ucontrol_test.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Test code for the s390x kvm ucontrol interface
+ *
+ * Copyright IBM Corp. 2024
+ *
+ * Authors:
+ *  Christoph Schlameuss <schlameuss@linux.ibm.com>
+ */
+#include "kselftest_harness.h"
+#include "kvm_util.h"
+
+#include <linux/capability.h>
+#include <linux/sizes.h>
+
+/* so directly declare capget to check caps without libcap */
+int capget(cap_user_header_t header, cap_user_data_t data);
+
+/**
+ * In order to create user controlled virtual machines on S390,
+ * check KVM_CAP_S390_UCONTROL and use the flag KVM_VM_S390_UCONTROL
+ * as privileged user (SYS_ADMIN).
+ */
+void require_ucontrol_admin(void)
+{
+	struct __user_cap_data_struct data[_LINUX_CAPABILITY_U32S_3];
+	struct __user_cap_header_struct hdr = {
+		.version = _LINUX_CAPABILITY_VERSION_3,
+	};
+	int rc;
+
+	rc = capget(&hdr, data);
+	TEST_ASSERT_EQ(0, rc);
+	TEST_REQUIRE((data->effective & CAP_TO_MASK(CAP_SYS_ADMIN)) > 0);
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_S390_UCONTROL));
+}
+
+/**
+ * Assert HPAGE CAP cannot be enabled on UCONTROL VM
+ */
+TEST(uc_cap_hpage)
+{
+	int rc, kvm_fd, vm_fd, vcpu_fd;
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_S390_HPAGE_1M,
+	};
+
+	require_ucontrol_admin();
+
+	kvm_fd = open_kvm_dev_path_or_exit();
+	vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, KVM_VM_S390_UCONTROL);
+	ASSERT_GE(vm_fd, 0);
+
+	/* assert hpages are not supported on ucontrol vm */
+	rc = ioctl(vm_fd, KVM_CHECK_EXTENSION, KVM_CAP_S390_HPAGE_1M);
+	EXPECT_EQ(0, rc);
+
+	/* Test that KVM_CAP_S390_HPAGE_1M can't be enabled for a ucontrol vm */
+	rc = ioctl(vm_fd, KVM_ENABLE_CAP, cap);
+	EXPECT_EQ(-1, rc);
+	EXPECT_EQ(EINVAL, errno);
+
+	/* assert HPAGE CAP is rejected after vCPU creation */
+	vcpu_fd = ioctl(vm_fd, KVM_CREATE_VCPU, 0);
+	ASSERT_GE(vcpu_fd, 0);
+	rc = ioctl(vm_fd, KVM_ENABLE_CAP, cap);
+	EXPECT_EQ(-1, rc);
+	EXPECT_EQ(EBUSY, errno);
+
+	close(vcpu_fd);
+	close(vm_fd);
+	close(kvm_fd);
+}
+
+TEST_HARNESS_MAIN
-- 
2.46.0


