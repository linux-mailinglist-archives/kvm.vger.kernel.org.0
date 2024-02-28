Return-Path: <kvm+bounces-10270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4322E86B29B
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 16:05:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C796CB24DD7
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 15:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E6AE12E1DD;
	Wed, 28 Feb 2024 15:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VFRxr+Ux"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8463515B11F
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 15:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709132671; cv=none; b=Uq6IUdJEQm6Y71rn+0bvcIQqvznNkx+kXkWI38jN96iydltWtO8QZ3bdQMRqnhn1+65Z037ha/G7fb0+6VpYcYSC1Z4G4YVdGw+SS+CqaLEfblKduoBbZHsNVvV40MCEtqr0s7oXq2cJAyOGW7uKy+GPk2V8rcbrKy9Xclj9Onw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709132671; c=relaxed/simple;
	bh=VnWfDZZX+RsAm0n1jDTYqDWn80RDp9msxDshyrWngx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=t1Vtx3WMbi09d+GsuMhu5Kn+rSH+qZmRMkPI7nh/7hSypKVDC7UH7HXpyO2BAwom/DVHQPEYHivzBHgNaP0cWCkGEi5M1hrF6Cemdn31k8WBWd3h2rCJNDwJsvAVn1A9aJcIZPhc9JTkfuBkvloJTEwAaKRphT+TQdGgEboy9uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VFRxr+Ux; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709132665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/mBo73FGUd2a53VN5FvK+tAOXqvCxAGvq5nQH2n9ppA=;
	b=VFRxr+UxVkjFfbrfz6qWyY5iKc9n23sGktqXnwLx3CjJfFSpjgFWI45OOb+IgsaJ6QpnnB
	8vU1w5QO7znJJYP+kGGlBrGYDw+k0elfbBeVQBcBjA0gia0pvLXdexTF/TfPf6r3ItmUlW
	qITwjG6fNeO89CFInAyYOU7eYevulu0=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH 01/13] riscv: Call abort instead of assert on unhandled exceptions
Date: Wed, 28 Feb 2024 16:04:17 +0100
Message-ID: <20240228150416.248948-16-andrew.jones@linux.dev>
In-Reply-To: <20240228150416.248948-15-andrew.jones@linux.dev>
References: <20240228150416.248948-15-andrew.jones@linux.dev>
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
2.43.0


