Return-Path: <kvm+bounces-65992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CDB9CBF270
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 18:09:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3D9B730C1B4D
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 17:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D185341ACA;
	Mon, 15 Dec 2025 16:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cTk66yW9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39DB34164B
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 16:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765817522; cv=none; b=M15hDvLSCk/tqHcxKId8He41CTjPRovbVgWllKZ9whFvxL4BGeLAhAeL8wKSm2Aarf0XRaL+y0qrFJ89fMAoXHQ4ZpLLNoAM4p5WNmJ6jkd6Paa3yJIf2bm3GOBsd1XhKlZJROy0AI6ZkDkVlb6uC3oadTCXsAbujBS0zAv8Tn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765817522; c=relaxed/simple;
	bh=RV/SRDs2NYKR4bNyg9iD41K74i8IniewHpHDgBIC6Q4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=filICBlont5uK7hMYuHklbP4M6fjnc6PnLwhgsql07wLnno9gvoYcpEzCJuuFU6Sm99fHSciKil1kyzAHAOly6Pz2E1FVFiOJX5a78sEDDnlepIYjRm0jj0Mg1lE8HM+wIgnvRcPCGQ3Yw3B4OxLgG+ly3pRtHIszaC7UgJuSjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cTk66yW9; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4788112ec09so26841355e9.3
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 08:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765817519; x=1766422319; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ozb3WNjr0r/hE1f6GMZd7Idc+wYYTjRgIGjeMMU1tjI=;
        b=cTk66yW9JMT12Wx/qurgbYtBwsZwWNwJ5NsOyyUzFUcm/uTqw4tmOw3hVPEyTlTQ/y
         PU6+sYpY7LkpxzM6zYnZqKsPfN/pfsgo/1BkFgkZA4NZ4tHhVZw8A3XkCobR827kgw8Y
         o7vT6fRsovLPgeWTXUL0xSZLt3TejXnzYp0QciH41q868KALsl2yA23R7zI7Rq0UNduS
         faefz+6XWVXMgV7armFHbqxM5RVslkqUnaUDfw6DZztmp1fDD5nbE1QKR2aVjPKtmwqQ
         7rLU9+DqMnBdWWhAq5XQbnHQBd1b83k4Io4pbl1vXRKux+cgO1BLweH9BRuk75q+5Fpq
         laCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765817519; x=1766422319;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ozb3WNjr0r/hE1f6GMZd7Idc+wYYTjRgIGjeMMU1tjI=;
        b=X5QTMgBpeqOawhJSmpKM0KddBhtbrNxp+OzJ2kwWgkdu3AF3eiVXofvt2P/Nhcu0MO
         s6KCVPgpUHaVk73F67fRDwTNVj0l9Q1QGeK2nL5X4mbBG+yY6l6R7dFB5Bi1Lk/kvgLt
         NCxYBGTUcY6VNgdTBYPpqDzJq6qQlMfHpPtbQLL7iLo3KYbXKeOile+hDWaRHathfCM6
         Ky1XdPxj0zI8viBPNX0O6CFB/htqYINIxyHWbgSmR0U8KS44DJSUOrimtAN9aCay59ro
         XyK+qZC7heme/bIrBmTPkgdHCv8JNwlokCu6PR+dm+gbZGc2lKuXDj8kUQU2qHg2VVEd
         3Jdw==
X-Gm-Message-State: AOJu0Yye5q/LM0906TBJ/uhR7wLqgeylUUcRkpOZAa8WcHJ5yTeJxTV+
	ooqVehCQD9Gd7gAq9lDAzcseupK8i4ygQsCahzx8MIVRKCBFv1Ikm4zPdRg96lXNIi9moEkt2l5
	/7YpRPjWP+I4XMuuyf8Y6OdThbJfHaGK3Kd04cytT4sdCdnPCbOw+Lad3S3YNkCbzcFmiGRokBA
	2edj2G453zUpNM7pA/Mn5EE35fFGQ=
X-Google-Smtp-Source: AGHT+IEXfGMQYTlXaZjDRjEyi8ps8t9i1lBXKwi2r5crX0EL+3ytnijgNklZSLLzPd74DIRXBqTJZjRKHA==
X-Received: from wmbil2.prod.google.com ([2002:a05:600c:a582:b0:47a:7fdc:6925])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:35c9:b0:479:3046:6bb3
 with SMTP id 5b1f17b1804b1-47a8f906f07mr127619025e9.23.1765817519032; Mon, 15
 Dec 2025 08:51:59 -0800 (PST)
Date: Mon, 15 Dec 2025 16:51:53 +0000
In-Reply-To: <20251215165155.3451819-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251215165155.3451819-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215165155.3451819-4-tabba@google.com>
Subject: [PATCH v2 3/5] KVM: riscv: selftests: Fix incorrect rounding in page_align()
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

Fixes: 3e06cdf10520 ("KVM: selftests: Add initial support for RISC-V 64-bit")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/lib/riscv/processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index 2eac7d4b59e9..d5e8747b5e69 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -28,7 +28,7 @@ bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext)
 
 static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
 {
-	return (v + vm->page_size) & ~(vm->page_size - 1);
+	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
 }
 
 static uint64_t pte_addr(struct kvm_vm *vm, uint64_t entry)
-- 
2.52.0.239.gd5f0c6e74e-goog


