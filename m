Return-Path: <kvm+bounces-30767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DC3539BD493
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:31:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1AD731C224C0
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 18:31:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A247A1E882C;
	Tue,  5 Nov 2024 18:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="q4/6g4yV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955D11D2B2C;
	Tue,  5 Nov 2024 18:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730831505; cv=none; b=aNbGz2Ci/zkITleRJTtfmjjTG8ZQCPXMgLRk/WKv32wpZKbsdM3rvwVJjrUqvJkLOycjZ5pmPTGEtcYqv4nndMqHuQDege+CF5Pw0xr3d8paihc5dgzxW0GwSUEm1WQhdBKR7aMyzAIWe1gsBtap3UM8DtqBxhnJtAWarldV5wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730831505; c=relaxed/simple;
	bh=SagvYHKJt5auxGJRJjhhxBCccjHkSwJYzBlZUkeQVJw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PIeyGhIQt9urIf/9a3wwRTtKjnPTz5gpOE3+938tvpGPSHb3eVoYgR/ggfjlakQqGbY9GN1o59eUcnVOkpqc2bia2yAJBVHtbDQB8LnupQgXIhGQ4H624LZ+DpdAz82+4fe+lsCYzQAvHEvHTY1NMxmZj1+4HHJd52eZbxu3cpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=q4/6g4yV; arc=none smtp.client-ip=52.119.213.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1730831504; x=1762367504;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bT6rRx7a7sWccvBSdvoPKKTuXoItJoU+EpMvF26uVsc=;
  b=q4/6g4yVcoJJcEP3lmqXJIY+zo/mB3ptDXxMj0EdHC9cbw2crAbBM6Rb
   FL/xqn2Na+EZie6vKU+Vvl4pkLEr+C+yarE8i/hpLf2BTrEeM660eDyBt
   tQm0n3e6pgVyZDE+gfDkfKolxhj0+T56rBjNwOL9lo5tfnAY/ePOhuebU
   Q=;
X-IronPort-AV: E=Sophos;i="6.11,260,1725321600"; 
   d="scan'208";a="245128567"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 18:31:40 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.21.151:50603]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.28.125:2525] with esmtp (Farcaster)
 id 39bb5814-4f48-4caf-ba41-fae750bfbae2; Tue, 5 Nov 2024 18:31:40 +0000 (UTC)
X-Farcaster-Flow-ID: 39bb5814-4f48-4caf-ba41-fae750bfbae2
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 5 Nov 2024 18:31:39 +0000
Received: from u34cccd802f2d52.amazon.com (10.106.239.17) by
 EX19D001UWA003.ant.amazon.com (10.13.138.211) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Tue, 5 Nov 2024 18:31:34 +0000
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
Subject: [PATCH 1/5] asm-generic: add smp_vcond_load_relaxed()
Date: Tue, 5 Nov 2024 12:30:37 -0600
Message-ID: <20241105183041.1531976-2-harisokn@amazon.com>
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

Relaxed poll until desired mask/value is observed at the specified
address or timeout.

This macro is a specialization of the generic smp_cond_load_relaxed(),
which takes a simple mask/value condition (vcond) instead of an
arbitrary expression. It allows architectures to better specialize the
implementation, e.g. to enable wfe() polling of the address on arm.

Signed-off-by: Haris Okanovic <harisokn@amazon.com>
---
 include/asm-generic/barrier.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/asm-generic/barrier.h b/include/asm-generic/barrier.h
index d4f581c1e21d..112027eabbfc 100644
--- a/include/asm-generic/barrier.h
+++ b/include/asm-generic/barrier.h
@@ -256,6 +256,31 @@ do {									\
 })
 #endif
 
+/**
+ * smp_vcond_load_relaxed() - (Spin) wait until an expected value at address
+ * with no ordering guarantees. Spins until `(*addr & mask) == val` or
+ * `nsecs` elapse, and returns the last observed `*addr` value.
+ *
+ * @nsecs: timeout in nanoseconds
+ * @addr: pointer to an integer
+ * @mask: a bit mask applied to read values
+ * @val: Expected value with mask
+ */
+#ifndef smp_vcond_load_relaxed
+#define smp_vcond_load_relaxed(nsecs, addr, mask, val) ({	\
+	const u64 __start = local_clock_noinstr();		\
+	u64 __nsecs = (nsecs);					\
+	typeof(addr) __addr = (addr);				\
+	typeof(*__addr) __mask = (mask);			\
+	typeof(*__addr) __val = (val);				\
+	typeof(*__addr) __cur;					\
+	smp_cond_load_relaxed(__addr, (				\
+		(VAL & __mask) == __val ||			\
+		local_clock_noinstr() - __start > __nsecs	\
+	));							\
+})
+#endif
+
 /**
  * smp_cond_load_acquire() - (Spin) wait for cond with ACQUIRE ordering
  * @ptr: pointer to the variable to wait on
-- 
2.34.1


