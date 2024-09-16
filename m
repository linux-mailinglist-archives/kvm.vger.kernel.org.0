Return-Path: <kvm+bounces-26973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E679979FAA
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 12:46:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33502286A54
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 10:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 010D6156228;
	Mon, 16 Sep 2024 10:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rf3P7VEv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841FE4087C;
	Mon, 16 Sep 2024 10:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726483557; cv=none; b=kD2Dk6vhYjAzkJ5IKURVfqZZLiZ3DZBGdoPugPw+Q8aaTrANCxQq2To68dyixLN7R5PbIYvrIPrLQnz0D4RtXkuiwmLemynp75GYvo3J1qd1Dl16oPYJyicJ6azCQcozKyBO5fs6yDxJWniRVNh1iV9HyTF+TObp6OJ7FzaLKy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726483557; c=relaxed/simple;
	bh=hdvE+HiNANePqSEQEklwUyaXVjv7kALUaLBR0X96zKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+Sys7PzgTuwl8dUmzvgB2LIKxqk95MTF6JOYGKooW/wLumMb0+c4kgo8Tlq1O8wOf6POXRlLkADcFu2Uqeh2Ym4k2MyWt97doQJqq28raSsgP5tMD8v57znGkXDE6X+857YgPY5I/WJ1pe60aeYq1C7ZUNeDcBTVFguTB+eys8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rf3P7VEv; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48FKw6Sc008611;
	Mon, 16 Sep 2024 10:45:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:mime-version; s=pp1; bh=IJxf646lAabkD
	vJCelOT71lwheMQDKQEbR7CvQWZvdQ=; b=rf3P7VEvVpVTx8jVe9QBrz3AFINJJ
	wpP7mHEMQYuItuyxvTRVyOimMXlGLsLbSN5im8yvPwaJxyefj44aCOx/ffbrEEha
	TpcJJRdDHxqQlKtpZIKVV0bq92EJ+F1aOzNNYhRllxXVMDGE6qsNlhUTnPSv0cm+
	GZKQFAiC5X3db3GHSfbUTrKPoHxJLgbKn9EgZkbK6M+nesOK/pcP5b/nK35FGxM4
	tvLqsFZIHpS/ALsh4w5ufvmZhguSBrEA/kjrfgCb8FiW9mzOlUSDZ765505v8Qed
	IU5SLBjMQGwavN8V96hxuQwMEGOj3Whre6xbx4XQwoTded2NWFwQ5cs5Q==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n3vd99v7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Sep 2024 10:45:48 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 48GAi2kX026523;
	Mon, 16 Sep 2024 10:45:48 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n3vd99v2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Sep 2024 10:45:48 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48G9lDaH024627;
	Mon, 16 Sep 2024 10:45:47 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 41nq1mpfu8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Sep 2024 10:45:47 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48GAjiG459703628
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 10:45:44 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F07E620040;
	Mon, 16 Sep 2024 10:45:43 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 934A52004B;
	Mon, 16 Sep 2024 10:45:43 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.179.30.170])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 16 Sep 2024 10:45:43 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
Subject: [GIT PULL 6/8] selftests: kvm: s390: Add debug print functions
Date: Mon, 16 Sep 2024 12:43:01 +0200
Message-ID: <20240916104458.66521-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916104458.66521-1-frankja@linux.ibm.com>
References: <20240916104458.66521-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: L9o9v_qBAbOkjjkyhSxZEwcNjALuYuP9
X-Proofpoint-GUID: M2oRlWkzQk7NcTJGO6Ymt3Sd8m8548Ud
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=1015 mlxscore=0
 malwarescore=0 mlxlogscore=967 priorityscore=1501 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409160065

From: Christoph Schlameuss <schlameuss@linux.ibm.com>

Add functions to simply print some basic state information in selftests.

The output can be enabled by setting:

    #define TH_LOG_ENABLED 1
    #define DEBUG 1

* print_psw: current SIE state description and VM run state
* print_hex_bytes: print memory with some counting markers
* print_hex: PRINT_HEX with 512 bytes
* print_run: use print_psw and print_hex to print contents of VM run
  state and SIE state description
* print_regs: print content of general and control registers

All prints use pr_debug for the output and can be configured using
DEBUG.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20240807154512.316936-6-schlameuss@linux.ibm.com
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-ID: <20240807154512.316936-6-schlameuss@linux.ibm.com>
---
 .../selftests/kvm/include/s390x/debug_print.h | 69 +++++++++++++++++++
 1 file changed, 69 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/s390x/debug_print.h

diff --git a/tools/testing/selftests/kvm/include/s390x/debug_print.h b/tools/testing/selftests/kvm/include/s390x/debug_print.h
new file mode 100644
index 000000000000..1bf275631cc6
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/s390x/debug_print.h
@@ -0,0 +1,69 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Definition for kernel virtual machines on s390x
+ *
+ * Copyright IBM Corp. 2024
+ *
+ * Authors:
+ *  Christoph Schlameuss <schlameuss@linux.ibm.com>
+ */
+
+#ifndef SELFTEST_KVM_DEBUG_PRINT_H
+#define SELFTEST_KVM_DEBUG_PRINT_H
+
+#include "asm/ptrace.h"
+#include "kvm_util.h"
+#include "sie.h"
+
+static inline void print_hex_bytes(const char *name, u64 addr, size_t len)
+{
+	u64 pos;
+
+	pr_debug("%s (%p)\n", name, (void *)addr);
+	pr_debug("            0/0x00---------|");
+	if (len > 8)
+		pr_debug(" 8/0x08---------|");
+	if (len > 16)
+		pr_debug(" 16/0x10--------|");
+	if (len > 24)
+		pr_debug(" 24/0x18--------|");
+	for (pos = 0; pos < len; pos += 8) {
+		if ((pos % 32) == 0)
+			pr_debug("\n %3lu 0x%.3lx ", pos, pos);
+		pr_debug(" %16lx", *((u64 *)(addr + pos)));
+	}
+	pr_debug("\n");
+}
+
+static inline void print_hex(const char *name, u64 addr)
+{
+	print_hex_bytes(name, addr, 512);
+}
+
+static inline void print_psw(struct kvm_run *run, struct kvm_s390_sie_block *sie_block)
+{
+	pr_debug("flags:0x%x psw:0x%.16llx:0x%.16llx exit:%u %s\n",
+		 run->flags,
+		 run->psw_mask, run->psw_addr,
+		 run->exit_reason, exit_reason_str(run->exit_reason));
+	pr_debug("sie_block psw:0x%.16llx:0x%.16llx\n",
+		 sie_block->psw_mask, sie_block->psw_addr);
+}
+
+static inline void print_run(struct kvm_run *run, struct kvm_s390_sie_block *sie_block)
+{
+	print_hex_bytes("run", (u64)run, 0x150);
+	print_hex("sie_block", (u64)sie_block);
+	print_psw(run, sie_block);
+}
+
+static inline void print_regs(struct kvm_run *run)
+{
+	struct kvm_sync_regs *sync_regs = &run->s.regs;
+
+	print_hex_bytes("GPRS", (u64)sync_regs->gprs, 8 * NUM_GPRS);
+	print_hex_bytes("ACRS", (u64)sync_regs->acrs, 4 * NUM_ACRS);
+	print_hex_bytes("CRS", (u64)sync_regs->crs, 8 * NUM_CRS);
+}
+
+#endif /* SELFTEST_KVM_DEBUG_PRINT_H */
-- 
2.46.0


