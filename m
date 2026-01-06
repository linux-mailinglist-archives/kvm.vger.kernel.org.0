Return-Path: <kvm+bounces-67107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A1F51CF782C
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 10:25:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8A3D03042B5F
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 09:24:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F4273128B5;
	Tue,  6 Jan 2026 09:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PPQbeFEf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE44314A7A
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 09:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767691478; cv=none; b=e+D56TzXV9fw9j7qmMah17i/BjXxUV496gsqDSmQqO0+egIWZ5ByLPRONilOUsQ2ij06UXBzyWElHfF9ZkmAc+pp0LiYYqvza5v6MgW6wSIdc8wW+9nr6+y4OdldNhA5KHb9CZSKhNC7PYABedoSa8gzHbG0iIK/h6FY+iyiIwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767691478; c=relaxed/simple;
	bh=Zkyr2U5TIQLa0eYA/VB8e1CqJ2IJkIo9zqfz9opS2DM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IRTewZVpapuU3RQQExuBoTZk2LciIM+9AlZd/iRhdGsYgqbTud/1z3VtIJm8lG3uV8Cdu+DRCBZfjULbcbasBeWoBrgAu0U6ePDkXgJsgDblyPF/wDzMfJa1gmO6LFjS7qdN7lQ1VGx3eq/HjQ+O4RuUYRqlqG7SABAzaFr5IQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PPQbeFEf; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47d28e7960fso8650705e9.0
        for <kvm@vger.kernel.org>; Tue, 06 Jan 2026 01:24:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767691471; x=1768296271; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CY0nmexOazthmZ5H6pdtIqZB8AItwvhQd/s34gISyww=;
        b=PPQbeFEfOl7XpOV49Fsp3ilbDIQ4SaA4BFsmkZx1IAnnpOcvuaZlt+rCn7hlxGGASv
         mVbZDIZmUW48VHP7VwYq0K4+WJhuQv8+qc5iU+w3A7diNm6vpAx9be3llTKwo/VMzLLp
         qnQZ3F6nHIjp8q72xNTdl3kUz3T7+jmfo+yB3BE3nDkFdH1/GmlzN1QsgJ19feg390dq
         HTNKZnYwG2enbToXwlxBu5JcjV0vC+K8IcwagDRksAEZKgqpVkiPLAqgwwrl4bRbEEvJ
         VlSE+12cG6IgzVSfuH8mKjjXdVGRm7UFGK78i6oK0f60zPd3eDYE912myvO+Zkz71z39
         9o+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767691471; x=1768296271;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CY0nmexOazthmZ5H6pdtIqZB8AItwvhQd/s34gISyww=;
        b=VpDcGS9k7eB04YO1KybKYBPU2hdsXi15RCVg9R+2601h1q5q6t7fZwtxMcNT88y9Nm
         duuT9Iy66MrimBI6ywfHH+N+y7HOqC2HABymiXjAdQIkcB9KXumNze419knOHFnDld6z
         GEiCnNEpn6jpdv0Be/58fuwQ/DaeVfMjDid5g+Odyd3xTC4NuO5UNVEORxiuYubzuvlK
         592xQIVjQKWxKlhYeg+9nxMTa6ceKP8CqQZzKZhVZLXiNBTBpT/IlTfSoceV6B2MUHSs
         4L9ZwTwIy46yhRorka3j2rr8BL6ZXtKrTm0RM0vCLp8RHjtHZeJOzC87nfjDnsffHKO7
         l/YQ==
X-Gm-Message-State: AOJu0YzNBDJWbvlkrEQ7gpCOYFcUfUXmY0OHdfj6Kf0qTmuQYJTbusIW
	skhOTzA0El8QcmNrvDLLUpct1w8Vb+gIkn+0utf09gK32q07YtJ+Tj4SWCk6HlfrGHu2aJcZbrp
	DAsk61mW6uA//asZwJt35BWc1xHT8//xdjeDw1mo6JY9ycHfLP9+9qVbJq6vWO1HCpmBeCbKYJV
	LH1vleAsM2iSw+gqxufeoDfuvIEdY=
X-Google-Smtp-Source: AGHT+IH4a3WanlofrHZQi1TFDZ2kdHhieJiwoT4O4SCA7gXcrGwc3UiWaYl27kXqMWKHd9vR2euGSEKV6g==
X-Received: from wmsm16.prod.google.com ([2002:a05:600c:3b10:b0:479:3624:3472])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3155:b0:47b:deb9:f8a
 with SMTP id 5b1f17b1804b1-47d7f09b87cmr27122825e9.30.1767691471353; Tue, 06
 Jan 2026 01:24:31 -0800 (PST)
Date: Tue,  6 Jan 2026 09:24:25 +0000
In-Reply-To: <20260106092425.1529428-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106092425.1529428-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260106092425.1529428-6-tabba@google.com>
Subject: [PATCH v3 5/5] KVM: selftests: Fix typos and stale comments in kvm_util
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, 
	itaru.kitayama@fujitsu.com, andrew.jones@linux.dev, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fix minor documentation errors in `kvm_util.h` and `kvm_util.c`.

- Correct the argument description for `vcpu_args_set` in `kvm_util.h`,
  which incorrectly listed `vm` instead of `vcpu`.
- Fix a typo in the comment for `kvm_selftest_arch_init` ("exeucting" ->
  "executing").
- Correct the return value description for `vm_vaddr_unused_gap` in
  `kvm_util.c` to match the implementation, which returns an address "at
  or above" `vaddr_min`, not "at or below".

No functional change intended.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 4 ++--
 tools/testing/selftests/kvm/lib/kvm_util.c     | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index dabbe4c3b93f..e29b2cbcb82b 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -939,7 +939,7 @@ void *vcpu_map_dirty_ring(struct kvm_vcpu *vcpu);
  * VM VCPU Args Set
  *
  * Input Args:
- *   vm - Virtual Machine
+ *   vcpu - vCPU
  *   num - number of arguments
  *   ... - arguments, each of type uint64_t
  *
@@ -1264,7 +1264,7 @@ static inline uint64_t page_align(struct kvm_vm *vm, uint64_t v)
 }
 
 /*
- * Arch hook that is invoked via a constructor, i.e. before exeucting main(),
+ * Arch hook that is invoked via a constructor, i.e. before executing main(),
  * to allow for arch-specific setup that is common to all tests, e.g. computing
  * the default guest "mode".
  */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 8279b6ced8d2..fab6b62d7810 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1351,7 +1351,7 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
  * Output Args: None
  *
  * Return:
- *   Lowest virtual address at or below vaddr_min, with at least
+ *   Lowest virtual address at or above vaddr_min, with at least
  *   sz unused bytes.  TEST_ASSERT failure if no area of at least
  *   size sz is available.
  *
-- 
2.52.0.351.gbe84eed79e-goog


