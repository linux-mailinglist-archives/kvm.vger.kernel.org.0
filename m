Return-Path: <kvm+bounces-11042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 14CC9872540
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 18:09:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF1521F25FAE
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:09:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 534D117581;
	Tue,  5 Mar 2024 17:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iG2l4nRZ"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1D2171A2
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 17:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709658547; cv=none; b=T6i6011JcJZ5wgB72KE02dm1ov7o3INqtey3QEnkBv9JBPkDDUIaw8U9FsQnbeuTcuOb5e6aYV74sjT6spKrjCETBfyMMaWsCkq3ztKYfPN96aM+ZyXQqyK12Sscj+gEpzcUN99Fis3Y19bRDI8k0kYnRJMDjyLqnIiq2/GtSs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709658547; c=relaxed/simple;
	bh=JIqiAzBFi4fAdFk8n7N7aKJvg52Jv8kU1jH4N9ePoqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=lVpHv4J3JXl/KLAPFlBzLm+zLdbDMBVFrK4BDMa6k7SwUmb6gR8JcJa9+Olo+bqJ6bOBwUKS5GhCm3CoE90Bb+HR/GKDInHWtbh9mKHk18TB0Zzex48/UYsUOvSHoW71L4CMq9nEjE0ovsMBc2E+1GTMD9HQFs+13IInURGqzdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iG2l4nRZ; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709658543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pyNpBUKcARGpXHjRUw7DJh9Dq78hNbBbT/1+T9CAHjU=;
	b=iG2l4nRZ+a7QyDVk+XleURCzZV28ZCTeHBUS1A16xBsxWVr2jm5tJQ1IaBQZPnrHPPiV3s
	jBmiKOQpejihjvMUGCXI7XumtL0OWfQHKJ2U3SrbSTDrZbjI6MUBiTxJ+BCY1/5C7S0HsY
	zl/ojmL19LEmu0kE+Tf95m9t3TsbrHc=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 01/13] riscv: Call abort instead of assert on unhandled exceptions
Date: Tue,  5 Mar 2024 18:09:00 +0100
Message-ID: <20240305170858.395836-16-andrew.jones@linux.dev>
In-Reply-To: <20240305170858.395836-15-andrew.jones@linux.dev>
References: <20240305170858.395836-15-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We should call abort() instead of assert() on an unhandled
exception since assert() calls abort() anyway after a useless
"assert failed: 0" message. We can also skip dumping the
exception stack and just unwind from the stack frame where
the exception occurred.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/processor.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/riscv/processor.c b/lib/riscv/processor.c
index e0904209c0da..6c868b805cf7 100644
--- a/lib/riscv/processor.c
+++ b/lib/riscv/processor.c
@@ -43,7 +43,8 @@ void do_handle_exception(struct pt_regs *regs)
 	}
 
 	show_regs(regs);
-	assert(0);
+	dump_frame_stack((void *)regs->epc, (void *)regs->s0);
+	abort();
 }
 
 void install_exception_handler(unsigned long cause, void (*handler)(struct pt_regs *))
-- 
2.44.0


