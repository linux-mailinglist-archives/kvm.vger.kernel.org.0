Return-Path: <kvm+bounces-23623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 239A994BE1D
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 15:02:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C477E1F23892
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 13:02:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5410318B462;
	Thu,  8 Aug 2024 13:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KEk8LKSH"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49FAEEA9
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 13:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723122167; cv=none; b=RDkTf1c1H2RM2VyIRgtmDLUzeQtXka4TXOjcGWUSrDlk4GDIcrvr1zAPAI8P+3mHHRgOv+tDyeOfIgkTT+dRppmhymrJl411aPrx4gxex1mB142ZCC8+hWLHx37AAerRPXTVdmRY+G32450QOpg02IvOFbzH6aefmISxC2EApWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723122167; c=relaxed/simple;
	bh=cqguEQOOz9SxEfl7Q34++2N6CN96V1dOcnzn+wHexno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQ4t3ix1TeP0WRL224DYNiDcuk6FiC20KQi56lgUeTZAmFzsu9JJyFu81m1/fD7T80FQyVF50mhjFTMihdB8Nv5oRrawd83tKjuqfbJICRfuo+9iiitYICn2a4Ul7eg6scs/MEteBjyq7EqX32iywgptdD/IG9ZLwIV1CCFOLKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KEk8LKSH; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723122160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lU26pXhquuCdnTqhFaYsIK4k779MOEn2WOTwMpCQRsk=;
	b=KEk8LKSH4I5EZ1+/rpAaibTsGN+xSZVA4AwyBXmJogf4eKElKP91SbIJBdvX/fwIK5uJ2Y
	yDYDP5LhwB3WkGQBCRhlhb6zTnxlc8QhDzKqgfOCGR5DvyIzowAhT5yC8wpqpQwijqi/0x
	PieYZwWQ149rGS1mQphqEdT63/JQ8FE=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 1/3] lib: Add limits.h
Date: Thu,  8 Aug 2024 15:02:31 +0200
Message-ID: <20240808130229.47415-6-andrew.jones@linux.dev>
In-Reply-To: <20240808130229.47415-5-andrew.jones@linux.dev>
References: <20240808130229.47415-5-andrew.jones@linux.dev>
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
index 000000000000..234ef5325f92
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
+#define SHRT_MAX	__INT16_MAX__
+#define SHRT_MIN	(-SHRT_MAX - 1)
+#define USHRT_MAX	__UINT16_MAX__
+#endif
+
+#if __INT_WIDTH__ == 32
+#define INT_MAX		__INT32_MAX__
+#define INT_MIN		(-INT_MAX - 1)
+#define UINT_MAX	__UINT32_MAX__
+#endif
+
+#if __LONG_WIDTH__ == 64
+#define LONG_MAX	__INT64_MAX__
+#define LONG_MIN	(-LONG_MAX - 1)
+#define ULONG_MAX	__UINT64_MAX__
+#elif __LONG_WIDTH__ == 32
+#define LONG_MAX	__INT32_MAX__
+#define LONG_MIN	(-LONG_MAX - 1)
+#define ULONG_MAX	__UINT32_MAX__
+#endif
+
+#if __LONG_LONG_WIDTH__ == 64
+#define LLONG_MAX	__INT64_MAX__
+#define LLONG_MIN	(-LLONG_MAX - 1)
+#define ULLONG_MAX	__UINT64_MAX__
+#endif
+
+#endif /* _LIMITS_H_ */
-- 
2.45.2


