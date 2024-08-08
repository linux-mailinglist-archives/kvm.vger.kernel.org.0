Return-Path: <kvm+bounces-23636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E75994C1A6
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 17:42:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D811A283A1A
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 15:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CADA18FDA6;
	Thu,  8 Aug 2024 15:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="F15Wj0G7"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91D118FC8C
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 15:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723131753; cv=none; b=OcwiS8Z6kp6VHQb4kJB37S6uiR3T+T9D4UEOCul5dBvbhKj6lJ6hhFyM+EA8R7RsZopvkYI0xdaRgEOmrBqZJrACvJGqjwRUxV317QKxhm75svTr3vcTzo+xkdZqFYdEd8p4thNmukY28Nwp0toUN4KZNvg3A2DTkd2KOcpS8Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723131753; c=relaxed/simple;
	bh=rKSJEDrFm0LsGwyPo1J07z1qzweYYC/6axFo1NYLnEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJLOX9de6kU/LchJDT9K/pMPL5woqMsrmNyvdSJALgddZmL8+VLBVi3QNg1bhHIaPefwd3AHL4gDe1sFPAllj+CniMU+2fWNory7VzSIvMlvnERTFU+nj1mZvjON65FY4XawEZm/BsPQGEpfVTps5+XXQc2bsC9HuZqQweXdkCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=F15Wj0G7; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723131748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=St1yXTnto1ifHTnWGgBbt3nQwVVou+kbdMZSsEu7UiU=;
	b=F15Wj0G7YAkfRDa8n4yneuwWVl8nqRfRXe6wU1ZcOGWG/xPVj9h3SnmLNU4u9QflWIGRIV
	aGe7aUEUCPc1ENsVnD4Y266zZUv9B9tJo8lelYcy+OKKD+Yy8gBqrVnAtR/smw4xDUXepD
	S4kcOQeOH/g5Ba+uwZUtL6l773leXFY=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH v2 1/4] lib: Add limits.h
Date: Thu,  8 Aug 2024 17:42:25 +0200
Message-ID: <20240808154223.79686-7-andrew.jones@linux.dev>
In-Reply-To: <20240808154223.79686-6-andrew.jones@linux.dev>
References: <20240808154223.79686-6-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We already include limits.h from a couple places (libfdt and the
sbi test for riscv). We should provide our own limits.h rather than
depend on the build environment as some cross environments may not
support it (building riscv with a ilp32d toolchain fails, for
example).

We guard each definition to ensure we only provide them when the
sizes match our expectations. If something is strange then the
define won't be created, and either the includer won't notice since
it wasn't used or the build will break and limits.h can be extended.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/limits.h | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 lib/limits.h

diff --git a/lib/limits.h b/lib/limits.h
new file mode 100644
index 000000000000..650085c68e5d
--- /dev/null
+++ b/lib/limits.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _LIMITS_H_
+#define _LIMITS_H_
+
+#if __CHAR_BIT__ == 8
+# if __CHAR_UNSIGNED__
+#  define CHAR_MIN	0
+#  define CHAR_MAX	__UINT8_MAX__
+# else
+#  define CHAR_MAX	__INT8_MAX__
+#  define CHAR_MIN	(-CHAR_MAX - 1)
+# endif
+#endif
+
+#if __SHRT_WIDTH__ == 16
+# define SHRT_MAX	__INT16_MAX__
+# define SHRT_MIN	(-SHRT_MAX - 1)
+# define USHRT_MAX	__UINT16_MAX__
+#endif
+
+#if __INT_WIDTH__ == 32
+# define INT_MAX	__INT32_MAX__
+# define INT_MIN	(-INT_MAX - 1)
+# define UINT_MAX	__UINT32_MAX__
+#endif
+
+#if __LONG_WIDTH__ == 64
+# define LONG_MAX	__INT64_MAX__
+# define LONG_MIN	(-LONG_MAX - 1)
+# define ULONG_MAX	__UINT64_MAX__
+#elif __LONG_WIDTH__ == 32
+# define LONG_MAX	__INT32_MAX__
+# define LONG_MIN	(-LONG_MAX - 1)
+# define ULONG_MAX	__UINT32_MAX__
+#endif
+
+#if __LONG_LONG_WIDTH__ == 64
+# define LLONG_MAX	__INT64_MAX__
+# define LLONG_MIN	(-LLONG_MAX - 1)
+# define ULLONG_MAX	__UINT64_MAX__
+#endif
+
+#endif /* _LIMITS_H_ */
-- 
2.45.2


