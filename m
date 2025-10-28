Return-Path: <kvm+bounces-61362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 568DDC17426
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 23:59:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 882CC4FABA2
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 22:59:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8B4D36A619;
	Tue, 28 Oct 2025 22:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F7Sn5K4V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5415F36A5F1
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 22:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761692335; cv=none; b=T1/OQZsMEFfbZtL6FUYM7v1Rn3IiWd+EUhqxj5kXD3i4Xxk5kcIC/v5QdLicTRyS7VP3gg2wCrf9z+98oZ91c3UlL2196AT2ztuc9XLTz/yPlo7qP5DEG8nAqE0RA0OGFf0ksdvsogJLGMehaOcYjshTGlnjdRVIxeBVxNhoclQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761692335; c=relaxed/simple;
	bh=JS15vNThAeh2jui9xeWUCKiqlGy+OUZg2+5NBKAugBA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=txNqsfLj62yIEvSwkEaWWkd+30EaYuIpT95pJhcxoYmpsT3QaDoafEO8V3PoiZKay30hY1elyhfB9TF4EIUXLbmvBufb5m15dZxEzFOP63Tdj/Kd8XCXpydvI0tZGtBcN83LDn0NRp/VQAEU0JFQwKg1Q1Bb1IvjtzFo8Wb50Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F7Sn5K4V; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33d75897745so15323302a91.0
        for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 15:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761692334; x=1762297134; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B288Y6TAy0Oj1t/N3Z1wYBH55x8/0e/DLaA7QkeLdXk=;
        b=F7Sn5K4VbY48l9uBP6f1VJeTzTz6tU14P+eeW5J2R0Wr4GX0J6hnmR6WDb2hcu7wwI
         Zv83Utu1pM5HOD6Fnmd0yPe10xe2ub6d+yBoxjffXsEQt5cE9HRcrvMv6Tw/Cep+c1XJ
         Wja4H3XLbGv6p+vhvqFu/rGdkapChbchk/JjNVxVfy5EdCoOTUNcgeA0kCM1viaDjsuB
         aIZc3rxX+30EHSvvmoKEaNcgcMGi6omuuBeM/rfdZUL+QknLpnsuv29OkFylKYy3s1ax
         2kKgD+iQ6J/4Ng6YFK2AIV8vMX0vycGh7JLLagkyogjlRkbqIQ6mLSQDYznQQbKTxuQP
         jreg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761692334; x=1762297134;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B288Y6TAy0Oj1t/N3Z1wYBH55x8/0e/DLaA7QkeLdXk=;
        b=VCnFGQ9vnLtCisNpHBeS7wxtDRH8NK4ZCsIun1gW7+/E3UkLqhbGQ/nv3eI71aNHeK
         m/ZQaHHQ3l62rU4PFQVLxo8g+QXJvlk7XgL0VwmR3rHRqhUPC6DoPETPNdFXKMWq0Oe/
         k6P0/O4Hw7Ra6urptdxhXMM8XinO6Jgy9/TVoyxTBnZcsSrze8Mtz1q7jC6ZuIfEC7wr
         3/boLQtqKPI1AvlMLc4Ys4P/gPjhrw27slqTobYDM8oKN2HlWRvODppXMwlGTRooHj7N
         EoHEe6XkuIJ8/O1OjYihuDg1yFxMI8VGB9z6EsYENxp72DX0S1WggJTzulqS553oGVcl
         0s8g==
X-Forwarded-Encrypted: i=1; AJvYcCX0GSClZ+mTwtMMwsK6HzsWOZ+BT3/BtQJBaTiBYDIgol157kmIblq4Vgo7HP+vtd825GI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTLBddD8lMHRygknlyIBWvuWz7rsBboHFDta6+NmDEs/BMFDY5
	5O6kaHJtwDTJzETWwvp/gMPTCrPz3QwSy0LaAKWT5kXRf5VhMosCttUevamKfXy6f5xYiMeBx3v
	3+rGZZIdHZjFuNg==
X-Google-Smtp-Source: AGHT+IHUBNt+yVkmaDzMVABj692uUI0JHObl1P4P9tqPjQ42MTaBcOUyDM9YJNfeKyaxLDAtJvc+QR92G8cTPA==
X-Received: from pjso22.prod.google.com ([2002:a17:90a:c096:b0:33b:b387:9850])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:586c:b0:330:a454:c31a with SMTP id 98e67ed59e1d1-3403a2f2d62mr821811a91.32.1761692333727;
 Tue, 28 Oct 2025 15:58:53 -0700 (PDT)
Date: Tue, 28 Oct 2025 15:30:39 -0700
In-Reply-To: <20251028225827.2269128-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251028225827.2269128-1-jmattson@google.com>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251028225827.2269128-2-jmattson@google.com>
Subject: [PATCH v2 1/4] KVM: selftests: Use a loop to create guest page tables
From: Jim Mattson <jmattson@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Bibo Mao <maobibo@loongson.cn>, Jim Mattson <jmattson@google.com>, 
	"Pratik R. Sampat" <prsampat@amd.com>, James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Walk the guest page tables via a loop when creating new mappings,
instead of using unique variables for each level of the page tables.

This simplifies the code and makes it easier to support 5-level paging
in the future.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 .../testing/selftests/kvm/lib/x86/processor.c | 25 ++++++++-----------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index b418502c5ecc..738f2a44083f 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -218,8 +218,8 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 {
 	const uint64_t pg_size = PG_LEVEL_SIZE(level);
-	uint64_t *pml4e, *pdpe, *pde;
-	uint64_t *pte;
+	uint64_t *pte = &vm->pgd;
+	int current_level;
 
 	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K,
 		    "Unknown or unsupported guest mode, mode: 0x%x", vm->mode);
@@ -243,20 +243,17 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 	 * Allocate upper level page tables, if not already present.  Return
 	 * early if a hugepage was created.
 	 */
-	pml4e = virt_create_upper_pte(vm, &vm->pgd, vaddr, paddr, PG_LEVEL_512G, level);
-	if (*pml4e & PTE_LARGE_MASK)
-		return;
-
-	pdpe = virt_create_upper_pte(vm, pml4e, vaddr, paddr, PG_LEVEL_1G, level);
-	if (*pdpe & PTE_LARGE_MASK)
-		return;
-
-	pde = virt_create_upper_pte(vm, pdpe, vaddr, paddr, PG_LEVEL_2M, level);
-	if (*pde & PTE_LARGE_MASK)
-		return;
+	for (current_level = vm->pgtable_levels;
+	     current_level > PG_LEVEL_4K;
+	     current_level--) {
+		pte = virt_create_upper_pte(vm, pte, vaddr, paddr,
+					    current_level, level);
+		if (*pte & PTE_LARGE_MASK)
+			return;
+	}
 
 	/* Fill in page table entry. */
-	pte = virt_get_pte(vm, pde, vaddr, PG_LEVEL_4K);
+	pte = virt_get_pte(vm, pte, vaddr, PG_LEVEL_4K);
 	TEST_ASSERT(!(*pte & PTE_PRESENT_MASK),
 		    "PTE already present for 4k page at vaddr: 0x%lx", vaddr);
 	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & PHYSICAL_PAGE_MASK);
-- 
2.51.1.851.g4ebd6896fd-goog


