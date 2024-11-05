Return-Path: <kvm+bounces-30768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7918F9BD496
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:32:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46267284014
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 18:32:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B9EF1E882C;
	Tue,  5 Nov 2024 18:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="lgahfxVR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDCC1DA62E;
	Tue,  5 Nov 2024 18:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.190.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730831518; cv=none; b=Bgj+GkB3aZFtXfPT1yn7GtGBZMmjzV8dDOFkzNwilwS8wJRAVUv+5HDtF/Ds70I7fiZhGpqe/sh5fCP+zvk3jSDYhfSenkSPFbWmwcKTn9dtWKo6PXAZIJ7ZPArxZLR8tJvmKxdiScja+lxTdTcoQ3d8SQLW8W1KRwqeCS+KKMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730831518; c=relaxed/simple;
	bh=g3RI6aaPgmokkAIMFdNnpTUOZMxevHUOt3dhCDGsmO4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UEdqFvS2zOon1Owf9Wq1rtxzi9BCwgCRTLkmPwuVcwLEW1WcsNXwCJ+trN2iNjO51B6tr0NHA+GccFsYZnZ1dAhk3jJdLBNEg1VQHBBF+2ZsVytXzFGDDDNP3uKrZQ37XNYKqa7RavEaCLaPqY+P01BLsOh8+0hX+omltATKMDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=lgahfxVR; arc=none smtp.client-ip=207.171.190.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1730831517; x=1762367517;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aZOVkbd/aqSS6wL2tHU2ZYavLfm4wZ7pJZkt2CDBd7U=;
  b=lgahfxVR8Rr5NjZ0abKtetzZwqeJURjgg3Hv4o01q7EFbRgrC7j5nFfC
   R3DLEpPdkRzEg45t9i70KDfuaxB9L6zgLPTpk0VA/cwNURlwxNp+eXAPq
   HNDVRVsASJ6xIvcOAiQFr95WTXZnTCmnIIDoFS6oGOqaa7F3xVP9cTmUk
   A=;
X-IronPort-AV: E=Sophos;i="6.11,260,1725321600"; 
   d="scan'208";a="382672781"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 18:31:56 +0000
Received: from EX19MTAUWB001.ant.amazon.com [10.0.38.20:51046]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.10.37:2525] with esmtp (Farcaster)
 id 3cfefb00-6800-4172-8693-375f47215f5a; Tue, 5 Nov 2024 18:31:55 +0000 (UTC)
X-Farcaster-Flow-ID: 3cfefb00-6800-4172-8693-375f47215f5a
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 5 Nov 2024 18:31:55 +0000
Received: from u34cccd802f2d52.amazon.com (10.106.239.17) by
 EX19D001UWA003.ant.amazon.com (10.13.138.211) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Tue, 5 Nov 2024 18:31:50 +0000
From: Haris Okanovic <harisokn@amazon.com>
To: <ankur.a.arora@oracle.com>, <catalin.marinas@arm.com>
CC: <linux-pm@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<will@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<pbonzini@redhat.com>, <wanpengli@tencent.com>, <vkuznets@redhat.com>,
	<rafael@kernel.org>, <daniel.lezcano@linaro.org>, <peterz@infradead.org>,
	<arnd@arndb.de>, <lenb@kernel.org>, <mark.rutland@arm.com>,
	<harisokn@amazon.com>, <mtosatti@redhat.com>, <sudeep.holla@arm.com>,
	<cl@gentwo.org>, <misono.tomohiro@fujitsu.com>, <maobibo@loongson.cn>,
	<joao.m.martins@oracle.com>, <boris.ostrovsky@oracle.com>,
	<konrad.wilk@oracle.com>
Subject: [PATCH 2/5] arm64: add __READ_ONCE_EX()
Date: Tue, 5 Nov 2024 12:30:38 -0600
Message-ID: <20241105183041.1531976-3-harisokn@amazon.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241105183041.1531976-1-harisokn@amazon.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <20241105183041.1531976-1-harisokn@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D033UWA004.ant.amazon.com (10.13.139.85) To
 EX19D001UWA003.ant.amazon.com (10.13.138.211)

Perform an exclusive load, which atomically loads a word and arms the
exclusive monitor to enable wfet()/wfe() accelerated polling.

https://developer.arm.com/documentation/dht0008/a/arm-synchronization-primitives/exclusive-accesses/exclusive-monitors

Signed-off-by: Haris Okanovic <harisokn@amazon.com>
---
 arch/arm64/include/asm/readex.h | 46 +++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)
 create mode 100644 arch/arm64/include/asm/readex.h

diff --git a/arch/arm64/include/asm/readex.h b/arch/arm64/include/asm/readex.h
new file mode 100644
index 000000000000..51963c3107e1
--- /dev/null
+++ b/arch/arm64/include/asm/readex.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Based on arch/arm64/include/asm/rwonce.h
+ *
+ * Copyright (C) 2020 Google LLC.
+ * Copyright (C) 2024 Amazon.com, Inc. or its affiliates.
+ */
+
+#ifndef __ASM_READEX_H
+#define __ASM_READEX_H
+
+#define __LOAD_EX(sfx, regs...) "ldaxr" #sfx "\t" #regs
+
+#define __READ_ONCE_EX(x)						\
+({									\
+	typeof(&(x)) __x = &(x);					\
+	int atomic = 1;							\
+	union { __unqual_scalar_typeof(*__x) __val; char __c[1]; } __u;	\
+	switch (sizeof(x)) {						\
+	case 1:								\
+		asm volatile(__LOAD_EX(b, %w0, %1)			\
+			: "=r" (*(__u8 *)__u.__c)			\
+			: "Q" (*__x) : "memory");			\
+		break;							\
+	case 2:								\
+		asm volatile(__LOAD_EX(h, %w0, %1)			\
+			: "=r" (*(__u16 *)__u.__c)			\
+			: "Q" (*__x) : "memory");			\
+		break;							\
+	case 4:								\
+		asm volatile(__LOAD_EX(, %w0, %1)			\
+			: "=r" (*(__u32 *)__u.__c)			\
+			: "Q" (*__x) : "memory");			\
+		break;							\
+	case 8:								\
+		asm volatile(__LOAD_EX(, %0, %1)			\
+			: "=r" (*(__u64 *)__u.__c)			\
+			: "Q" (*__x) : "memory");			\
+		break;							\
+	default:							\
+		atomic = 0;						\
+	}								\
+	atomic ? (typeof(*__x))__u.__val : (*(volatile typeof(__x))__x);\
+})
+
+#endif
-- 
2.34.1


