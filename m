Return-Path: <kvm+bounces-67537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CDFFED07C70
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 09:24:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AC088306F8D1
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 08:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25D83318EE9;
	Fri,  9 Jan 2026 08:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GmbU8VXC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8EA316905
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 08:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767946954; cv=none; b=tdcVDWaZDBHppDo99M1Lc+t0WEIr8M9YJXGeoA2Qxniz52LazYG6dFF0AjhLP8rglAJNkMc55hGD5i82Apx+VhaAwqmvKoQpo12ZwhEqtjpSifPLSsKKhYzQMAc2NsOpnd7plmAZ6NlTH80b8I61pS2m1V4BdpqLtI3IFkKol3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767946954; c=relaxed/simple;
	bh=w96ilePjNJnlQ+ySS5jk59GZnLjBMn9Q5Jdzxz6KvAk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UjzNu7kwsCxCjUq2M5gOK7CT7/hfECnHZZlwheFg9GJRE6S/usAtus80HHFDXp0qDqCWOOGzWD6CTfC6oGQ0p6uL4ZBUrbRfSdwBzwMUli+kraQ4PU2pMIQKYKlsuvv9pGte4Q1aRIpxzfT0sD9KXkCSRUIZwYCQMx7TPPlzQNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GmbU8VXC; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477b8a667bcso44363855e9.2
        for <kvm@vger.kernel.org>; Fri, 09 Jan 2026 00:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767946944; x=1768551744; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pq9O7d6wzhTity1EvTGcuuOU01Kl/XBUCmwyUjTCy1A=;
        b=GmbU8VXCNY22ARpRg7riJXUc2JrJAs7KK5tJdI7g/Ob3SI7Xmo1AGoIEJ2YDQx8oGB
         aIMfnzOIsYWiQHn83kq3lMUFGCHUNG3mD6gzN6lpPaM89wQDzzgAZdmvod6mjYDqfUaE
         c3rMC66J0bEjttX7Fl0LSj31gX5pdzFHLCSzWBRgtuPbSf+osrzJnXYlTCnoKWXHYbPW
         /t2THmMoHQKrLgutoQ+f0Tblx4nmoi2nymclzemMuOq931yCBibZqBby4EAMkb3zOUTs
         EiGVlFOUuAgQILRSvSiZ3Ybfk8ShEixXTGKKgW7hPSstsnjKcTJBsyPeYnBgLJCX/OWi
         sJhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767946944; x=1768551744;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pq9O7d6wzhTity1EvTGcuuOU01Kl/XBUCmwyUjTCy1A=;
        b=vkzkIHnEZEuAlNwjcijAyhQVNrs9LlVP7pCCGsQ8xGWsLD2ZNkWAT2GriloMeyFRe+
         caSR1W5VmF61pf1YeeXo/oJFRXO6yElUuaJL1oRXeDXPT3CE2CcJGq7KpIu3agS7M4WU
         7EWR413qp4x/74zW5wt8HeTlHxXmdrupcZFaolX/lSmceLy3uluVhAyhqtk//x5En8S+
         wHpBoY10OGG1x7/mArHwHZIirS8b0l7O5AfXXw83M5uSxGCBVU8NnI1ggLupzmUkArz7
         bkCklbs09uY0sAHn1jPlVkpFzU1oNlSWk6Sln6/WOGiXi8XesbRS7bDJPfXAQUy8aAn5
         6xQA==
X-Gm-Message-State: AOJu0YyENT9ukhusRT031CpgancGlOm15dsbvjOUUdehxeG0bDDXbDqj
	gXuK2RQBDwriujgXnIpKVDlbL4TkoqEl6Oe2EzAnzQaaGTbOG1cgBPT8XeGsmmSNAqrLShacafE
	331lzaL6JW84np3RwJGJEys8gSKaES4e4kYG6yN5/aznfNWfFq9mWxc1r3Lrygl7ghU0GW6DcMY
	B3xRrq4smEHowJP5q+fhEmw4PdI0o=
X-Google-Smtp-Source: AGHT+IGWTLfUDmVjhmRk/6xaUs6XXjTDY4nThSKMpmNBWodgPyJb8+1XA5L2Dn6202jXo8K9XP5BtW0DRQ==
X-Received: from wrbew19.prod.google.com ([2002:a05:6000:2413:b0:430:f703:f9cb])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4709:b0:479:1348:c614
 with SMTP id 5b1f17b1804b1-47d84b41b2dmr100673355e9.26.1767946943756; Fri, 09
 Jan 2026 00:22:23 -0800 (PST)
Date: Fri,  9 Jan 2026 08:22:17 +0000
In-Reply-To: <20260109082218.3236580-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260109082218.3236580-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109082218.3236580-5-tabba@google.com>
Subject: [PATCH v4 4/5] KVM: selftests: Move page_align() to shared header
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, 
	atish.patra@linux.dev, itaru.kitayama@fujitsu.com, andrew.jones@linux.dev, 
	seanjc@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

To avoid code duplication, move page_align() to the shared `kvm_util.h`
header file. Rename it to vm_page_align(), to make it clear that the
alignment is done with respect to the guest's base page size.

No functional change intended.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h    | 5 +++++
 tools/testing/selftests/kvm/lib/arm64/processor.c | 7 +------
 tools/testing/selftests/kvm/lib/riscv/processor.c | 7 +------
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 81f4355ff28a..747effa614f1 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -1258,6 +1258,11 @@ static inline int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
 	return __vm_enable_cap(vm, KVM_CAP_VM_DISABLE_NX_HUGE_PAGES, 0);
 }
 
+static inline uint64_t vm_page_align(struct kvm_vm *vm, uint64_t v)
+{
+	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
+}
+
 /*
  * Arch hook that is invoked via a constructor, i.e. before exeucting main(),
  * to allow for arch-specific setup that is common to all tests, e.g. computing
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 607a4e462984..1605dc740d1e 100644
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
@@ -115,7 +110,7 @@ static uint64_t __maybe_unused ptrs_per_pte(struct kvm_vm *vm)
 
 void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
-	size_t nr_pages = page_align(vm, ptrs_per_pgd(vm) * 8) / vm->page_size;
+	size_t nr_pages = vm_page_align(vm, ptrs_per_pgd(vm) * 8) / vm->page_size;
 
 	if (vm->pgd_created)
 		return;
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index d5e8747b5e69..401245fe31db 100644
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
@@ -68,7 +63,7 @@ static uint64_t pte_index(struct kvm_vm *vm, vm_vaddr_t gva, int level)
 
 void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
-	size_t nr_pages = page_align(vm, ptrs_per_pte(vm) * 8) / vm->page_size;
+	size_t nr_pages = vm_page_align(vm, ptrs_per_pte(vm) * 8) / vm->page_size;
 
 	if (vm->pgd_created)
 		return;
-- 
2.52.0.457.g6b5491de43-goog


