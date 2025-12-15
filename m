Return-Path: <kvm+bounces-65991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B7FACBF2D3
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 18:12:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2A63B30E975F
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 17:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 721CC341AAE;
	Mon, 15 Dec 2025 16:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RfVJk7wh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA26341065
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 16:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765817521; cv=none; b=mswMpa/Xrai+VzlIDFWBRUURv2AdAUBz3zuNke/J1AMxB+zgYD38EZjFHh4hEcrPb6Qp0UHeU+oPFE7SHsShPM4tniAlc6OkotA38YlG0ghQQCD7m4ccgeDWw9MHlqdV01DGoB48eruNl3vakSEfgCEhRszLOs2EeqX096CQ0Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765817521; c=relaxed/simple;
	bh=/VCI7DQ+7GTI8zeB2aLIPeI3jA56WcE85XhXuFDRCp4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BFKhqvjrPsKEUBDN/HIgWzU12wl0tJA3cIe9uJTyiha0Sjv0kTc/oleWS8BvCk0r700RNIFLvi7U+1UmdAMkCVFdQeM9n5ZNoji2JPns7bSCCQdMd5B0wcaEzf2Etoo4eQM6MSEvtUKNtuLaqIQIwmYWpZuRfJglfL7mj5Jx2Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RfVJk7wh; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4779b432aecso19304775e9.0
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 08:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765817518; x=1766422318; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YA7YNO0BIUCF/IaZgjS1+s+NSnXmnEjkXZMNklvVQWE=;
        b=RfVJk7whDacWh+IoNt4KDy6TtoC3EkSPRqwOCzLc/IyA6VlM1h+p4SmbS/UCoEuWsy
         qk3uQFtDkEfFjoHuzZVKfv5etRTryUGFKeKxAK+b9VExd3WtkqeVNcP00f18RM/lUrjH
         601ySYisy7ekgmPPItA0aVpVQ/tYcA863DDPT2qm8dPzSEtL8wpTJFJUSlfeEwFvPFFJ
         kWlM6Z2rbgGoTmbiQoi4nRnJ8guM0URPft2xBcHeBO9l9TkLdFNreR4CEVz38XKhF3p8
         D+CEYjCMQUP/esMhZmhC2obMTzRKmFkZdTBGmTDDUy0fRoXXnCNZrDnOPGVC8Lm6i6Lt
         dX8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765817518; x=1766422318;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YA7YNO0BIUCF/IaZgjS1+s+NSnXmnEjkXZMNklvVQWE=;
        b=gbFwqNYD5ySJlkZpRID9zeyRSSivuX4Pa5OxqI19NfyNAshcnMx5KyfWCqYtazgqFl
         WjzVhugxHMq98oSufQaDxf+X5n/MuVwaGPFBN3lPrbdW73/kriwPZD67SxPxOQdR6KhW
         iRor/GJui609In/tHxHztcaTNBWr8pAJAqZlcVSRjWOlBJLXSwOC0QqV1BWUdEvZRa/n
         f8KMooVU1KtcCGdHp0pzfNZvJ4uOgYpjaiV6mMaE4NDPRfsEpXLXUnV8qSEWRCriatI8
         URHNOyiDfsDvDbObsmqWuZwJYrsg3JxysUa/kpA1RGejowpwbq5i+cND1txoBTDWarhn
         H2LQ==
X-Gm-Message-State: AOJu0YwbKgOiLcu7zWDj0cHUShFjLHqOEhJJSFQNRy0Afp70exSL3v/o
	8WFZiKt3FSpS7bfs1wishwN635PfvpJ9kzAwn6Kmc+5iIEFYTGSOPSdpZkQOT7GrDBSINMY65lo
	hJThEXL0KH/7w+eiIJi+0SaVpXRG03DjOMEyxzWoT+7C0FvmgWxfOAxv07iAKh6rS9kbmXfXf+h
	kf74Xgwf1+qeeiqbWVqpz9/XGtuR4=
X-Google-Smtp-Source: AGHT+IHUB40lOCD80Q5A00V1WQKvc1RxNXM54i1GatM+tLTBSJUgVajSxluMfJ5vbUhuhTOMyPxhV+F0hQ==
X-Received: from wmpo35.prod.google.com ([2002:a05:600c:33a3:b0:477:14b1:69d7])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a012:b0:479:3a88:de5e
 with SMTP id 5b1f17b1804b1-47a8f92029emr95871135e9.37.1765817518200; Mon, 15
 Dec 2025 08:51:58 -0800 (PST)
Date: Mon, 15 Dec 2025 16:51:52 +0000
In-Reply-To: <20251215165155.3451819-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251215165155.3451819-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215165155.3451819-3-tabba@google.com>
Subject: [PATCH v2 2/5] KVM: arm64: selftests: Fix incorrect rounding in page_align()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The implementation of `page_align()` in `processor.c` calculates
alignment incorrectly for values that are already aligned. Specifically,
`(v + vm->page_size) & ~(vm->page_size - 1)` aligns to the *next* page
boundary even if `v` is already page-aligned, potentially wasting a page
of memory.

Fix the calculation to use standard alignment logic: `(v + vm->page_size
- 1) & ~(vm->page_size - 1)`.

Fixes: 7a6629ef746d ("kvm: selftests: add virt mem support for aarch64")
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
2.52.0.239.gd5f0c6e74e-goog


