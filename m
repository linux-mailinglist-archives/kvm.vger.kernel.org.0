Return-Path: <kvm+bounces-66891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E1939CEAD5F
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 00:08:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D8B953076334
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 23:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C71D1330D32;
	Tue, 30 Dec 2025 23:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IAmq9RMt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC7932F76D
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 23:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135753; cv=none; b=B5MKBEV4YeqlDtdV3cFOxdCrBYQsqp07yJMOb/zhACQiJbEu5jP7+UnnOuR6o6TFEvsTMAPvejaMrtgCE9fEgZ6+xJyG5004ZyI13URg/OKM2qeDSRfM73AqQM6v3zU/R4YPzTLrsVvGfty9eG4bY4Uhv/WYhLeBlSRsklLmM4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135753; c=relaxed/simple;
	bh=p2Pgz/yRJSbUlMESZ6664VqIIQNLSRXLMLize367QyE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LcK3CzIxOBreBr1Uuk1KYgZCKRpTUW5EivPGuDZg1UWN19w1uSE1jaTATh1JzASPLx3j7/JVDqPjuW5RdekVPI9XbDUPsgqvupkJ9F2xNxElGR/CJmjVaT1mEvIvGMv1kOiAlFOsyY+K+3NIyT411zlVfbJj9Jf3wNrpZEl6uCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IAmq9RMt; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34cc8bf226cso23074061a91.3
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 15:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135749; x=1767740549; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ykxeCu2rd9E7NdPIA3m898BLFxasNeM9KWtJ/FC5NbY=;
        b=IAmq9RMtPLYgJBWPNQ5CFowVLi7+XjbabhZEpKBDiq98e2oHgxclRfY4Jg/5P/m54B
         4S33dJtnhUQvoKBCqZFZMsATU7TxAtmxVUVRU65HxoGRrU1RBGkE7/QNCFZcji95JcJZ
         pPdtkZR31TT16mEKQE1HoHN+og23DwCh9+0Bpon2gFkZgjfhMdroLByb64vXu0KlUeN7
         Axr0Y1TNkhnF7J6lqdIw/f3Z6GnBWfF0WCjSxQ9ZwHXWaeBdke0TwtnJ0imWoHpawn/d
         C/izWTTEXs+N9GvIvatLxWLbzHeexXYT7i62Gbn6x9v2q1OYEmXYRfCGikQ/do2imGA5
         2xRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135749; x=1767740549;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ykxeCu2rd9E7NdPIA3m898BLFxasNeM9KWtJ/FC5NbY=;
        b=f5v1RulCajRRBaTOzbeK+NPaFM0Avzq/J0QWcbmtB+ZpU/s36jyB3CzR/c6UOl0gSE
         HK9c8MYHRUGNVY8smUV9x9kXyNQvGj0JbVEuAoeQvdTkkZioXVvvogXEYAepd4A+/OOS
         63mixtwu1CCJ6K+MzPSbUmA5yh/X7r88OgwQ0Nk5uR51bdroVz1yR0IexYZiPVP/5Dd+
         hOPP6gzzhv3JShaSTWYskS2qUY6Sz9UD/sTldFS/W1iNMQuzyVEm57+jszJ5jyV+oLgD
         0dvd7ixO8PM4aWFvKBmAvUqAr+bE7rfzHoCmeeasA8ex+NA+xJC5lcqbt2nUXIrVEH/W
         AhFQ==
X-Gm-Message-State: AOJu0YyHwXU2uyxxyUgB7OX71fHs6dfP1lb21SA9sZzsfpH+XWruGog7
	goO9yWH92v0jNqAHPq9beqxA9gqokWMXlUdbYqYi1VTVWPDcBQ9sHYDmM3NGNKJ7corD6yVNfRq
	sfq8E7g==
X-Google-Smtp-Source: AGHT+IEpuChkB0izCaZM7wAnBEmg/NFDOHvlk8mvLyNibHqxg0YqGOIPaICPmBipc+pvYA8R48I/lk77pf0=
X-Received: from pjbqe11.prod.google.com ([2002:a17:90b:4f8b:b0:34a:9e02:ffa0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:dfc6:b0:340:d1a1:af8e
 with SMTP id 98e67ed59e1d1-34e921e60d9mr30599932a91.37.1767135748870; Tue, 30
 Dec 2025 15:02:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:49 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-21-seanjc@google.com>
Subject: [PATCH v4 20/21] KVM: selftests: Rename vm_get_page_table_entry() to vm_get_pte()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Shorten the API to get a PTE as the "PTE" acronym is ubiquitous, and the
"page table entry" makes it unnecessarily difficult to quickly understand
what callers are doing.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86/processor.h           | 2 +-
 tools/testing/selftests/kvm/lib/x86/processor.c               | 2 +-
 tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c            | 2 +-
 .../selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c     | 4 +---
 4 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 7b7d962244d6..ab29b1c7ed2d 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1357,7 +1357,7 @@ static inline bool kvm_is_ignore_msrs(void)
 	return get_kvm_param_bool("ignore_msrs");
 }
 
-uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr);
+uint64_t *vm_get_pte(struct kvm_vm *vm, uint64_t vaddr);
 
 uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 		       uint64_t a3);
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 5a3385d48902..ab869a98bbdc 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -390,7 +390,7 @@ static uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm,
 	return virt_get_pte(vm, mmu, pte, vaddr, PG_LEVEL_4K);
 }
 
-uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr)
+uint64_t *vm_get_pte(struct kvm_vm *vm, uint64_t vaddr)
 {
 	int level = PG_LEVEL_4K;
 
diff --git a/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
index a3b7ce155981..c542cc4762b1 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
@@ -619,7 +619,7 @@ int main(int argc, char *argv[])
 	 */
 	gva = vm_vaddr_unused_gap(vm, NTEST_PAGES * PAGE_SIZE, KVM_UTIL_MIN_VADDR);
 	for (i = 0; i < NTEST_PAGES; i++) {
-		pte = vm_get_page_table_entry(vm, data->test_pages + i * PAGE_SIZE);
+		pte = vm_get_pte(vm, data->test_pages + i * PAGE_SIZE);
 		gpa = addr_hva2gpa(vm, pte);
 		virt_pg_map(vm, gva + PAGE_SIZE * i, gpa & PAGE_MASK);
 		data->test_pages_pte[i] = gva + (gpa & ~PAGE_MASK);
diff --git a/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c b/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c
index fabeeaddfb3a..0e8aec568010 100644
--- a/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c
+++ b/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c
@@ -47,7 +47,6 @@ int main(int argc, char *argv[])
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct ucall uc;
-	uint64_t *pte;
 	uint64_t *hva;
 	uint64_t gpa;
 	int rc;
@@ -73,8 +72,7 @@ int main(int argc, char *argv[])
 	hva = addr_gpa2hva(vm, MEM_REGION_GPA);
 	memset(hva, 0, PAGE_SIZE);
 
-	pte = vm_get_page_table_entry(vm, MEM_REGION_GVA);
-	*pte |= BIT_ULL(MAXPHYADDR);
+	*vm_get_pte(vm, MEM_REGION_GVA) |= BIT_ULL(MAXPHYADDR);
 
 	vcpu_run(vcpu);
 
-- 
2.52.0.351.gbe84eed79e-goog


