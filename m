Return-Path: <kvm+bounces-67539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AE45D07C9D
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 09:24:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B08763090A51
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 08:22:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C539318EF0;
	Fri,  9 Jan 2026 08:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iSn+ie8L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A309314D07
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 08:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767946957; cv=none; b=Bzr/Rs6aOxb+M0/m9sc4ATYgMfnhqsYkf5W+fRukmvf6d/PbXJlmnzBaLfOtEQ1eiltwflgWPGJpo1dzc8VrKG3a+1ilh1ndqlh6mb5+bHlPFa5JcybKEXR55t3LoFvVbnImCljS/X524abp0Itdq9adJWQ0VrUMdLNbOA6enQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767946957; c=relaxed/simple;
	bh=x6qRQWFnnMwvN/oed3S0rLIDrotCBFv7ItG+p4ucujU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kLsa9yzkokTsNHAz54l8z4ek4XZoJx1Bcp91cavjoMmvuDE8dzXKKiweUN1K85BnS8AIVb5YBzwETbN+6t1AtIX6JuFpW5I0TovvAhFZ310vElTfiuG9JLEc/NzwPFtM5Llp2O0DpKWLzcL+ugsEWw8kPq2VW7JkD6yHRSpSoss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iSn+ie8L; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47918084ac1so42298785e9.2
        for <kvm@vger.kernel.org>; Fri, 09 Jan 2026 00:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767946943; x=1768551743; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WTwC3FF8o3D1tLIxF1rzohdijBesrjYjdFLpGAMOcJc=;
        b=iSn+ie8LWHa0jyR8ecHalg/mZi+dupcvKEz+un3esGMfNTSQ8K5wPXU8TmnUXxRu3i
         5TLBd5a6y6A+t55NSacrtx4pKJjJYmAFtJ9n90cgG7WmTBPOZwXtWQojzYUzvK3NH98s
         /fMds3Va5JGDNp8Vfd6KxsNaRNr6DLgqnhR3BuPH41vDb8BipEuA/+ZtPbvIWOvc4hw/
         uJCFzAjQfqTF6lcdO+xi9EbVMRF0Nln+SG1ZwO2OZMfoCwzoVbiMRNA3C73o1a1Vbu+B
         TBbqFeni5McHI/4u8CgVVDhaXwB8u+vrWZ5LqUczgkeC7z+wTyyn6QzR/BQ4j193R9TD
         M/Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767946943; x=1768551743;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WTwC3FF8o3D1tLIxF1rzohdijBesrjYjdFLpGAMOcJc=;
        b=RZJAJX2FmgxOW8CWipIXH+O7LbpCjderPHsdc2HtMtcxyzdrFcp6BVpShfKIX+vvET
         dKQwwOkGeye52irV4vm+SzBXfXf8qGltuaCjTXYLi3b9MoxEaqhnHNFDDEvY1RXTcZqj
         9upcfRmZFVMbKcJ/Nq+KznKPUqKU/pGAff8dN32bQHIcSRYxhS0K5mudhSNOnes+OqDu
         YC5W6NU5Ddmu+DyR4h2HneNonLyJMSGZ1bfe04t1aKsxs6tyNqS4+C9S1TQTdUUyza+d
         P16DMgbasGXI05PArG9ovE0gsEg1tKksG27jzGqJnrn84vAMUCIBV3WTYONv73i9xwVc
         zagA==
X-Gm-Message-State: AOJu0YzcqdjjpFMH/zOHvpZoD5PYeNkoHL3vg1sWdVpTUFh2UXDdJWwr
	/z9P6NcSUsvCkR9WhWgjW+9oJlFoTr085iYts3pJiFubAo1z7KxsPcH1pVuYYLYUTp0jYv9RFD6
	vqo9w8XTWhNOn+4pea7m0jwJSJy0uGm0mH15gtwEFSU71lAhqWKVVowhecEny8h9XSpXgpSXOqF
	UgLKZkQ1FHjQkcNbEt29QblTdcvA0=
X-Google-Smtp-Source: AGHT+IEbTZ+JAQZIIX5R/diRf8NtI3qcRyEYMj72NqYPRiSA2F4mmy/NK7W30kPtTdFlYjIQg8wuM2wdbA==
X-Received: from wman14.prod.google.com ([2002:a05:600c:6c4e:b0:475:dadb:c8f2])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:6287:b0:475:dcbb:7903
 with SMTP id 5b1f17b1804b1-47d84b17b7cmr101603035e9.9.1767946942620; Fri, 09
 Jan 2026 00:22:22 -0800 (PST)
Date: Fri,  9 Jan 2026 08:22:16 +0000
In-Reply-To: <20260109082218.3236580-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260109082218.3236580-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109082218.3236580-4-tabba@google.com>
Subject: [PATCH v4 3/5] KVM: riscv: selftests: Fix incorrect rounding in page_align()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, 
	atish.patra@linux.dev, itaru.kitayama@fujitsu.com, andrew.jones@linux.dev, 
	seanjc@google.com, tabba@google.com
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
2.52.0.457.g6b5491de43-goog


