Return-Path: <kvm+bounces-23548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3306594AC90
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 17:17:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D2D221F2148F
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 15:17:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CA4A7D3E4;
	Wed,  7 Aug 2024 15:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="G9lpFs7W"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516BD84D12
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 15:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043811; cv=none; b=MPRE7Bopnice2ZSVIo1hTjJZ/n9LagGXl8cK4cj/9kJ3Z5PWf1cFPW+KtHpAGsPzm+MRFHF5Ue1jNnLSMUFAYEycGbaEg3obhQwXo8IhNJ9tqxC141L2x3EHD/ehy8tcR+hnQ96kkWLxQpwnGNhDDwX7bQElUk7PqYwqnEmMUN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043811; c=relaxed/simple;
	bh=xMMD6lbF1Q8SU34AXHQ+A7gAtY/+5St/83LVg8jlPAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozLMdho4Ce5y3wnT7u9TPmGFIzKgHNpysKhD+jDXUklkYmlwxhkMP7HFqL7NRKK03L91BDhLloHXT3WmbntgabPQmlOp7TK4CvlSilgWpIWSWlUvzWUq8gr1MAIqTYSbscUe6QvHz2LYlPaY3GuRhMHL+FbBhzyEiFlzJlfQwXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=G9lpFs7W; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723043807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3M9iRKgv8aV/QZsAf7pAIKygkuBgiAEBkmW/A2oWcjU=;
	b=G9lpFs7WQxJkKeHOXcwA5oebDhhNL1I0JIyvp9EL9sJ7Twn+lfK0kXc5xuaBikT+BmkCmh
	PQZOrlLV4ClFc/Fnu9rpqD+8rLvzIC1RcYuemQ3BpuG6lOYWS0ZcN3g0oLJyT3X3VzzFaQ
	rOfGNLf8Z7sy6gMMmlDS/osutI8Hi6g=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 2/3] riscv: setup: Apply VA_BASE check to rv64
Date: Wed,  7 Aug 2024 17:16:32 +0200
Message-ID: <20240807151629.144168-7-andrew.jones@linux.dev>
In-Reply-To: <20240807151629.144168-5-andrew.jones@linux.dev>
References: <20240807151629.144168-5-andrew.jones@linux.dev>
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


