Return-Path: <kvm+bounces-65993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 46C4DCBF2A3
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 18:11:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5D676304E57E
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 17:02:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 145CB341ADF;
	Mon, 15 Dec 2025 16:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MbO/NS1e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95214341076
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 16:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765817523; cv=none; b=FT23FHVfxGSRnnd66x+Z/PgGzeYDSEv2jtXaC+6mRttWgVtItPqITEwze1RUFaVHtArb8RSFNtqW8qlSuDSgyKXQa+o4fM8zTvXORbJldkHL847OSFMilXydl5L9pc9q1vFIDKVBLbCt9SeI4cVbuJgC4WJ2XzYXFwFiQ+gBhmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765817523; c=relaxed/simple;
	bh=ayln4Fw+8UlRvvb+n2Kfq+LyehdpOH5myyhVGffmoAA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CvQTKLZwJFiEQyQNRsxRSQtJNfL2g2T2vPrhezMr5h1brKWEGkO0DYPt2gjyoJqpNufKM0HKsXX+gCpRO4ncr+0DmG7LttCmpPzbguIe3hp7atTH71to3knjuMNgug4/u7zON1YNeJPhwvzmas/1JCl/c0EDc5okmd9pFOGj16I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MbO/NS1e; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477cf2230c8so35923115e9.0
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 08:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765817520; x=1766422320; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VGTJpqAtjnaQAGGRy8gsotmE8IXAZ0B2ScsPjP/ESd0=;
        b=MbO/NS1e8Qs8+CdPAEuqvg76eJMLmcRT7rsL1/T1q7f2/VlxZNErOFoTM8wtACYwYW
         JCz7wYr6sUu4NvW+S2CWQSRyEGzRgoIOQLSRL2mcezvLu0u4CpW09cQw+7TOZo6ibHxi
         ddKQyLq+0o0KX5zIIeeMSgYjhtWkvXqKbagkpJjGXJbecKkJtJNlq6igw3/TNOrst3ts
         8XS4djG6vuEMrfF6FFUkjJ+UJxWWg4Oev+BfEnSRGVw2e8AdS4A8lBHTyGlTjY5Fw2dM
         BrGtjv9R1R5SX0cev7UY8qEx6cHJ6eQR7oH/6RzfldtCJ5ajHYsLhHPFBigXP00/zWnq
         iBlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765817520; x=1766422320;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VGTJpqAtjnaQAGGRy8gsotmE8IXAZ0B2ScsPjP/ESd0=;
        b=n/Ij3zEh4Xy84PYrooCWWGPsSgiX5bY1iOnfW9m5ifJn4krr+K/TVUd9zWNA6fsw/t
         VLBT4htwD6iS358omTCjs0FCbXeun1TmL7BWIgIGD6ddjCKd9bt+zdcNCCY/c4NMk9rJ
         ug+T3tGiRIQ9r24NVP5YWrSwDrPO3ZX81X8LvEwHmPPKNDi/tYESgndH6EQ7rH+QaWN/
         2B45LFjjBYoj4NY08sfnOCueCcIG0HFEwXRaM6d6OMAurYzH8nG/pjEvcrrl5fLkZseV
         FQtr+YvGK2EifANSQsbCqiftzDMGuJcuuKDgsKlsEW9F50zwBDOveD0TB35gbR3+Vid2
         W4VQ==
X-Gm-Message-State: AOJu0YynXIrswCPzpwcwvhuuGTvq9vUdLOuB2GPauyr6LBaLzO/mep4e
	atyDaCZfgX9UV0MABuNREiikmpPDZq+NgHvkPJpOYQu5e7B8cktSdp80OG7sYWl3LZgN/thi2nA
	K9DkzDoLrpCePDD8EAUhYtIZDWniJQMzq/XfsqEEJGCmQfbQkPzrA7XqcPnJhX3klxbIGafx8Lg
	sI4v9PkkyHwsmG28C+CwI6Ngr5GyM=
X-Google-Smtp-Source: AGHT+IHdmoXymTwmtDhUo4OPKD55NjfIa2ZaYkUMxOGs0DQTenx1wSRtOp2+NPGnkVJnbSiUoA2tLeeLYg==
X-Received: from wmbgz10.prod.google.com ([2002:a05:600c:888a:b0:47a:8fa6:6a57])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f89:b0:477:7a95:b971
 with SMTP id 5b1f17b1804b1-47a8f90c5b0mr124657005e9.31.1765817519823; Mon, 15
 Dec 2025 08:51:59 -0800 (PST)
Date: Mon, 15 Dec 2025 16:51:54 +0000
In-Reply-To: <20251215165155.3451819-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251215165155.3451819-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215165155.3451819-5-tabba@google.com>
Subject: [PATCH v2 4/5] KVM: selftests: Move page_align() to shared header
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

To avoid code duplication, move page_align() to the shared `kvm_util.h`
header file.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h    | 5 +++++
 tools/testing/selftests/kvm/lib/arm64/processor.c | 5 -----
 tools/testing/selftests/kvm/lib/riscv/processor.c | 5 -----
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 81f4355ff28a..dabbe4c3b93f 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -1258,6 +1258,11 @@ static inline int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
 	return __vm_enable_cap(vm, KVM_CAP_VM_DISABLE_NX_HUGE_PAGES, 0);
 }
 
+static inline uint64_t page_align(struct kvm_vm *vm, uint64_t v)
+{
+	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
+}
+
 /*
  * Arch hook that is invoked via a constructor, i.e. before exeucting main(),
  * to allow for arch-specific setup that is common to all tests, e.g. computing
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 607a4e462984..143632917766 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -21,11 +21,6 @@
 
 static vm_vaddr_t exception_handlers;
 
-static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
-{
-	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
-}
-
 static uint64_t pgd_index(struct kvm_vm *vm, vm_vaddr_t gva)
 {
 	unsigned int shift = (vm->pgtable_levels - 1) * (vm->page_shift - 3) + vm->page_shift;
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index d5e8747b5e69..f8ff4bf938d9 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -26,11 +26,6 @@ bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext)
 	return !ret && !!value;
 }
 
-static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
-{
-	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
-}
-
 static uint64_t pte_addr(struct kvm_vm *vm, uint64_t entry)
 {
 	return ((entry & PGTBL_PTE_ADDR_MASK) >> PGTBL_PTE_ADDR_SHIFT) <<
-- 
2.52.0.239.gd5f0c6e74e-goog


