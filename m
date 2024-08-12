Return-Path: <kvm+bounces-23847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D870B94EE97
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 15:46:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9619928320F
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 13:46:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06FE9183CC5;
	Mon, 12 Aug 2024 13:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CFr4KKRU"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2805183CB5
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 13:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723470304; cv=none; b=GAlovJRYbjlXz494zoFXdwkXfzM2GpxbnJ5qbhh8GXB6wTHD3bLEsYfWUr1607AxWFMwYq+4LYQ2vX5ZYvkAIuVnYWX6WRTB8x3Z1aT1d4tA4c0fr4Ll4BheTWLQrI1ychzuAXmQsfnePRUVWYUGtTE61y/lm2BS9GB0E/OSBGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723470304; c=relaxed/simple;
	bh=xMMD6lbF1Q8SU34AXHQ+A7gAtY/+5St/83LVg8jlPAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZ4+FCX4RvBW50zYUoHBgzS6d52iXW+DpzXwNPFMz8ZpQL2Blv3hkL5jQ95wqE7iaI7WuUqVohaVr9mrdgk8/HmxsedYMqIqUlOv1WdJJmU99n48njMcE8qB9AlsZMtk5qft9yJifwkv2I+Ed3ot2icBFmGxqcNnrXsnV5wCE9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CFr4KKRU; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723470299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3M9iRKgv8aV/QZsAf7pAIKygkuBgiAEBkmW/A2oWcjU=;
	b=CFr4KKRUymigKA+2Uu9AdwmCHJE18lUGxfIXQoPy7vCVq40k4ttkVneCfMRc1Fg/pKaA9l
	6Ix5s8GhsDkZZHlRkB21rqQ9XYmqKy+qVw6Go8IcdxQ5dHDyxCINSQ5hK7XGBxLs5U+Uds
	SXQCeziSaHbvXEsUht3fjoXKMYhNSvw=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH v2 2/7] riscv: setup: Apply VA_BASE check to rv64
Date: Mon, 12 Aug 2024 15:44:54 +0200
Message-ID: <20240812134451.112498-11-andrew.jones@linux.dev>
In-Reply-To: <20240812134451.112498-9-andrew.jones@linux.dev>
References: <20240812134451.112498-9-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The VA_BASE check in setup() also applies to rv64, as is clear from
the later VA_BASE check in mem_allocator_init(), which ensures
freemem_start < freemem_end < VA_BASE.

Fixes: 6895ce6dc618 ("riscv: Populate memregions and switch to page allocator")
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/riscv/setup.c b/lib/riscv/setup.c
index e0b5f6f7daf5..2c7792a5b0bd 100644
--- a/lib/riscv/setup.c
+++ b/lib/riscv/setup.c
@@ -193,7 +193,7 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 	const char *bootargs;
 	int ret;
 
-	assert(sizeof(long) == 8 || freemem_start < VA_BASE);
+	assert(freemem_start < VA_BASE);
 	freemem = __va(freemem_start);
 
 	freemem_push_fdt(&freemem, fdt);
-- 
2.45.2


