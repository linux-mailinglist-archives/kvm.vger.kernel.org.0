Return-Path: <kvm+bounces-29513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E7C29ACB15
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:21:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 604CE2825F1
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:21:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20A911AE009;
	Wed, 23 Oct 2024 13:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Px1Hzl1g"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A931AB6ED
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 13:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729689703; cv=none; b=fkhRjPzfnbgIPobo5/iQrXIiv6xsGWei4oW3vjBZR9JjjsHt6BwmDrByyWNMSbwfOzqHa60FbHG4AF/Sif0AOgaSoEDvx25MCV5iF5BGf4YlRH9tSUbtYltT8NeHj9onwtmMYJqO1EcVLZn003Jvawq18PWPXjHJ3DtSeFQrgyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729689703; c=relaxed/simple;
	bh=eproeieP2guIsENpttWunUHTCzySL//7W9mGNrZ9PHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hagKcs4cb7KuBqYt6huK0QUo3fFoDyY18Bzi/5VPOmxfJ2LqoRHfi3Pr2BwVmdr/8GNFzOOiwKG5yOyK2UlZ+6QbwmWVV/3WXX69AoBlbp8hGPBsuNC9ANc0Sg+imTc6bQnxhDJPeIiEJO5OhtxSLjFmjfgYqShr4WdDcKKDh6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Px1Hzl1g; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729689699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cgbOwzQMc+kT3Z3Q0ZRUFULWs2irjvHdzSBuM71eWkA=;
	b=Px1Hzl1g/+LfykaXLvfKi/Q5H4a9cxu4Y09Q8bOiHxdQLRulSY0CEfWMWiCgDwsY86tLX+
	Xb4hLvZViQVV8G22QsYzbBEJIzUWGvi4ldLpc9HHBJQSR11Oq9c/zMiaASLUFShQ9Jo8S9
	MoP4nX+6zLozg9m+Q6gywE7JM9eqKzg=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 1/4] riscv: Bump NR_CPUS to 256
Date: Wed, 23 Oct 2024 15:21:32 +0200
Message-ID: <20241023132130.118073-7-andrew.jones@linux.dev>
In-Reply-To: <20241023132130.118073-6-andrew.jones@linux.dev>
References: <20241023132130.118073-6-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Besides a bit more memory used for the .bss section, where there are
NR_CPUS sized arrays, and a tiny bit more stack used by functions
with cpumasks on their stacks, then there's no harm in bumping
NR_CPUS. Bump it to 256, which should cover us for quite a while.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/asm/setup.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/riscv/asm/setup.h b/lib/riscv/asm/setup.h
index a13159bfe395..a031ebe7d762 100644
--- a/lib/riscv/asm/setup.h
+++ b/lib/riscv/asm/setup.h
@@ -4,7 +4,7 @@
 #include <libcflat.h>
 #include <asm/processor.h>
 
-#define NR_CPUS 16
+#define NR_CPUS 256
 extern struct thread_info cpus[NR_CPUS];
 extern int nr_cpus;
 extern uint64_t timebase_frequency;
-- 
2.47.0


