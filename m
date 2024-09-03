Return-Path: <kvm+bounces-25772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 024DA96A45F
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 18:31:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35A281C2426F
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 16:31:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3DB218BC30;
	Tue,  3 Sep 2024 16:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t/f9dess"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C73A1885A0
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 16:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725381060; cv=none; b=Mros9rMM+hJW5P0bIGb+5bqDwwqxmdFkHziJ8dMktVafhp9gXdyisRDJ5BczSS31BM8kj1/FmqQgT4E825Bdxc897VcYEA/93Fw2ZnTUKeZ8a0CUZUEGu/zriOcaOeUWDFeu5TvdJ8MaNVWhMvdJvYq7J0ioZT6S7pR+CPlx1MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725381060; c=relaxed/simple;
	bh=dC1akU4IyAlJTp7JJHPQ3wE3CKtyM0HaBL/1deTZtUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZbF4Rxk7SJbUxnnl4xQJeYa6yqRmyKD8w9F2X5Ys6AjlXCnQS9uc58W/X7NxoY4tK0yLNns5x3tdyfrt/kLJYJhDt8s9x6qPO6LR39pG22xtqVOh2tKQ5lCe9Ij7J5LTh6dRKaDXQD5pnDCUVv4SOQ0nXy7dJpuzVduIoZQrP8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t/f9dess; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725381056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3UxheV3LaB96UvBMKdu1CVVmJDUPIpuIrbtZKkMPtcQ=;
	b=t/f9dessP1gbOkieG//YAQXRph3gSAkFIlqtbV8X+u4B2ZB8CqL6HKtaQ+2yg5v5b5qHAB
	Kvg6v4fCSYhDvH7/nPjBz1jJ402Uf6c6zAuQ4LJGCGLSZ6gxoVX9xKhmsDG1KHgaxk8h7z
	DbGiBbDKjeGY9q7gQ/Bf3UfmzsNm+CQ=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com,
	lvivier@redhat.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com,
	nrb@linux.ibm.com,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 1/3] riscv: Drop mstrict-align
Date: Tue,  3 Sep 2024 18:30:48 +0200
Message-ID: <20240903163046.869262-6-andrew.jones@linux.dev>
In-Reply-To: <20240903163046.869262-5-andrew.jones@linux.dev>
References: <20240903163046.869262-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The spec says unaligned accesses are supported, so this isn't required
and clang doesn't support it. A platform might have slow unaligned
accesses, but kvm-unit-tests isn't about speed anyway.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 riscv/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/riscv/Makefile b/riscv/Makefile
index 179a373dbacf..2ee7c5bb5ad8 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -76,7 +76,7 @@ LDFLAGS += -melf32lriscv
 endif
 CFLAGS += -DCONFIG_RELOC
 CFLAGS += -mcmodel=medany
-CFLAGS += -mstrict-align
+#CFLAGS += -mstrict-align
 CFLAGS += -std=gnu99
 CFLAGS += -ffreestanding
 CFLAGS += -O2
-- 
2.46.0


