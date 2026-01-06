Return-Path: <kvm+bounces-67104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 202B2CF781D
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 10:24:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8BC8F300B9ED
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 09:24:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB59F3191B9;
	Tue,  6 Jan 2026 09:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="up6qDi1I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B213161A8
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 09:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767691474; cv=none; b=FK4xDyLjOX+ubMwJmdPS89w3xv+r7XRGL2MlF/3Eeli4kEYkiM3dLp6Ap8nUM3qPBiwOj4nA9p3+BR/ONxzYjFVQM1LSkY/o0nFfK63v6j95EeYDeXxAvNauciDDN+YdTNUa3zRJm44g34vRH6IcW1N/2mlyzCHyb2Kh8IhZj2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767691474; c=relaxed/simple;
	bh=KEPsyHYvNUPbRxGvG9QC9U7StdlbPwsF3guoMEOlj/0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nZN8mcFtvUwGUIkBJ7q5P/FDvQVxyFOMuE9TDV4tHtkvBhNgrKxUVXMD7brcQp0AzpFAg9Psayof91bLUCudME49GrbRJiIAUIptZ1is44bStp+N0ks3+ScX/RYDl5LyimaoWvChlsc8KGT2Px+rEH6r5xvXkLG83oDLX+FLEM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=up6qDi1I; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4792bd2c290so7747315e9.1
        for <kvm@vger.kernel.org>; Tue, 06 Jan 2026 01:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767691468; x=1768296268; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/BHQuplAEgEU3wnDUhoItFqsIohZcJhUp7mBGwtJYNU=;
        b=up6qDi1IPCFqGDjbziBEWDPe5TvwONTy4lFRckbRgG5u3IaAx5bJZDNT2wftIKVWPv
         oCqbt3hXLZBAe7cUt4YXNwuPyjGq+i3RfadyL3X3ZPnEQ2uWR30aW2hWdjyg7CPEjgYB
         Vgi68tNrE+Eo85cFmQCq313+sXIOLMlS/EOkmA6VaPc1uZ6Hszrxk7QHHoCYHS+m5fHG
         RYIEupJzmA8eqYGmOfzouftsR/iX+WGIxKIIZ9oAERJiuhmGGNHacgb6YmYSOjmEKKy1
         CS4/v0d2zm3Hl6y5lMc5liCI4J4x3IQH2Z4zKyQbcg+c1XyPz9q0ljzg8BqjetHMy9hF
         Uuuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767691468; x=1768296268;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/BHQuplAEgEU3wnDUhoItFqsIohZcJhUp7mBGwtJYNU=;
        b=Hz3LpOSIv13V0vQFJoS2Bmd6P85TTIn6HspI+VhhRDORThIqgpf2kG1N5S0AK2S6oZ
         3yZjB9oU/eUA5A8UBNjs4ujpsJiKZuxfpTCPjOZxI6XczL1W9YDUvOusntyQ+EkXFKpJ
         /eS8RayqnTa56SS7yq5RXRcVFhAI/LmTPQc1ljytv5VIIkAlgjA2VvsGm8ofm4HqZacP
         6yXMOxFi9qE4aQoQCO0/luqaECm56OtQVeVZ/+wTr5zbAT8Gn2aWypFQZDwRntSbx03M
         MDzdEfNTTHdKWgjP6HuIQLnOPm9spEdbMJPI2AY3Y1kIcOANeIO3FTq3CmnWmHS0WF50
         /cQw==
X-Gm-Message-State: AOJu0YwN5ANiAoLwycy6iEtX+bs7kaDEcbFfB3VpH7ZgoQnb4QngX8vn
	+/EgXTjHREnE7xca+mNfdIaK2Gqul9bVFRXceHqP+BXD+sYyM4Sf7xUVscW1ltF2xAVqsl8ZkTa
	DoB8EWeRcUT2dMy4sCYWJsm190SOaEIJZRyvw6GevOHJU47RmhsbwCLDgj7LdlMJRau2flk+dWl
	DRS5VP7E2nF+MG1dAodWJWx1/rF/w=
X-Google-Smtp-Source: AGHT+IEg8lPbC98Q9JebA2jYPeK+hKxfS04QHQm5CsFqWbT7d+JjvRp5WM7FCPdf80Bu6YTWW9INVq/0XA==
X-Received: from wmbju16.prod.google.com ([2002:a05:600c:56d0:b0:477:9945:466d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b27:b0:475:da1a:5418
 with SMTP id 5b1f17b1804b1-47d7f062feamr25842635e9.1.1767691468308; Tue, 06
 Jan 2026 01:24:28 -0800 (PST)
Date: Tue,  6 Jan 2026 09:24:22 +0000
In-Reply-To: <20260106092425.1529428-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106092425.1529428-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260106092425.1529428-3-tabba@google.com>
Subject: [PATCH v3 2/5] KVM: arm64: selftests: Fix incorrect rounding in page_align()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, 
	itaru.kitayama@fujitsu.com, andrew.jones@linux.dev, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The implementation of `page_align()` in `processor.c` calculates
alignment incorrectly for values that are already aligned. Specifically,
`(v + vm->page_size) & ~(vm->page_size - 1)` aligns to the *next* page
boundary even if `v` is already page-aligned, potentially wasting a page
of memory.

Fix the calculation to use standard alignment logic: `(v + vm->page_size
- 1) & ~(vm->page_size - 1)`.

Fixes: 7a6629ef746d ("kvm: selftests: add virt mem support for aarch64")
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/lib/arm64/processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 5b379da8cb90..607a4e462984 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -23,7 +23,7 @@ static vm_vaddr_t exception_handlers;
 
 static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
 {
-	return (v + vm->page_size) & ~(vm->page_size - 1);
+	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
 }
 
 static uint64_t pgd_index(struct kvm_vm *vm, vm_vaddr_t gva)
-- 
2.52.0.351.gbe84eed79e-goog


