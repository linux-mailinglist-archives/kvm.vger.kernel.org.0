Return-Path: <kvm+bounces-67105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BB8BACF789E
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 10:30:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4D2993161514
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 09:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E48C31618B;
	Tue,  6 Jan 2026 09:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gU3qLk+C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FEF3164D4
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 09:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767691474; cv=none; b=UmE8z0JOFyMQAGKc0oqQyo2xS6uvwBcT7QPNxXem72h1TnqdrL+IZ3ciIjvPjZPW8/1NZW4FU2FgpVXsRHiqtLgD2BqR7x3+hmjU5UaQb3Ld98NOHIwaguoqqME74P5ARd1qIRC8EZQAXZ8akwdZbe+6m/8PPhiro1+vyPFZgII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767691474; c=relaxed/simple;
	bh=EQHAbDhoMMWd1fJVwjNDq+g85R6n47J4t4SvxSjZdfM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U/nyIQbYuSZMqj08qKj+KgtCWppTsDfHb2Pfr7s6MFS2CuDdXUQUb3kcpoGeZ5FjuIi3qfMTfHchJaz/MtI5rWXas8MwpZ0ytvVZ5SwEu6bGuEPeO3UM7ErO0Eg4yQh7N3jGxVX9L9HOhOpu5nF4DDsQDruW1BC5FK9uqxo0gzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gU3qLk+C; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4792bd2c290so7747495e9.1
        for <kvm@vger.kernel.org>; Tue, 06 Jan 2026 01:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767691469; x=1768296269; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QWAfw8yq+s9cE6S8gitEzWpZURZyId6sqJW9pySZvio=;
        b=gU3qLk+CzlDgI9xhDaXE671K9/+kGwCI8DdJh/PYAAsyF2IVeL82nKBTmyvpxWqwTW
         qV1664RBAukZKcxWQlFvVgMJhDVB1i82SilXyfRdH3fWdg/NvA+QoGYcJRtZS8gsgXZa
         DXp+o2DyZIXtYfMQoVZbq2F5qzJB9VEZo6e/wPFmP/AJmR3iaxX4V60Iawwf/1ius1CK
         4138fU7BS+8JyAVf+iOHP6Qv7cejVuFEN237UsYTssCdm1MRun5p5NjGXvkGxvuSqwWc
         z3n7lfEwT3SJxG+7JazFi6yNZV8EDAhjtAs4k5m5pmR5EG9uJTMuciI3nF0C1+Murc2W
         0ccQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767691469; x=1768296269;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QWAfw8yq+s9cE6S8gitEzWpZURZyId6sqJW9pySZvio=;
        b=vjgmkGTsaQYO7e+mSPiQ5efOQ/u+vxXddRIGWRtYTumJfJMBBX2Hp3MkVWSfXKxPDw
         RdY8M0LWYZIPKsQ60eqgHhAzRy/9UuETBE1Tgl8Olj+LVQf09Q8QVELxaBVe7bx1wDh/
         q1GIqsuFaLE9a3zix0sljRDHrx2g3Ceia8A8QrgsFAiVqDcBMkCGHn6NygPERvHJiHjC
         KoKl0SG8Qg8cDPNUITOQinBeRUG0sdqNUYERM1q0r+9U2UGKzoJYwE8CLS4P8LE1TqN+
         5jnQw2TAySSeKlHT9mtmutMzuVSyA+0WDzo8cumQJ2N4G0s35bfWcOdL6WiwboVkCPJB
         Livw==
X-Gm-Message-State: AOJu0YzBg5ObiyO3Wzh2DlDLFywiaKz3RYp4AfJBynJ/MG+xCSvwO7oN
	hcvu3ne6off9L9tfA8/tNdsMcZ1mbM7VOQhyE283hym3D8zpClW//rWpiutdPGrJtIjjOBbIAUH
	6+sGnhr2ezKsAfM2HAAZNhbZtN0+FbOBdXeVfKjvS64442PrAnIqTZwZxSIHM/XpLLOom06FMqb
	23pQJlonp/tnXDD5MUTf2HxzYIDFY=
X-Google-Smtp-Source: AGHT+IGZ6zPBR0nFFmX4Tnz3UVY5AHveG185k93WRJRP+p2A5F0uEf6W3hst4bbUZ2pAc94raYUDWeGeZQ==
X-Received: from wmxb6-n2.prod.google.com ([2002:a05:600d:8446:20b0:47a:9289:c5d8])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:46c4:b0:47d:403e:90c9
 with SMTP id 5b1f17b1804b1-47d7f07031emr25675035e9.11.1767691469448; Tue, 06
 Jan 2026 01:24:29 -0800 (PST)
Date: Tue,  6 Jan 2026 09:24:23 +0000
In-Reply-To: <20260106092425.1529428-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106092425.1529428-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260106092425.1529428-4-tabba@google.com>
Subject: [PATCH v3 3/5] KVM: riscv: selftests: Fix incorrect rounding in page_align()
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

Fixes: 3e06cdf10520 ("KVM: selftests: Add initial support for RISC-V 64-bit")
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
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
2.52.0.351.gbe84eed79e-goog


