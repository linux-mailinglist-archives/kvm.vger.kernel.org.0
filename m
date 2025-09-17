Return-Path: <kvm+bounces-57947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B2BE7B8206A
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 23:51:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E819C188F951
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 21:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A7F130E0D6;
	Wed, 17 Sep 2025 21:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mOuBjO3u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B532F9DBF
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 21:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758145873; cv=none; b=gTd8rLa503hY2oVliQnty1BoSJ+mpLiI65lQzcuI74jioJCKFjyBWj0TkO176VGHSs6GGsDI58tnCS0w9PDpT1JmT0s7E3noEBGI7iPvXRB4GK65FGDLJiSrst0lhCDakAngpxyI0fOVr1rtFhkBC8o5a9DF/pBH58ToU2yQur0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758145873; c=relaxed/simple;
	bh=LqGmDErC+0rvfwTlCCv3MATKWOoGiTAPnRm7qx/uRIQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jRh78uGn8AtNey8aj5boQvV1OpGuJx92//dUDqhbnGySj87HkC+sbjYwbZ4V0OFwpr5JWor1ph1isxYaMnCGjgTI+d/c/bbUxGgLjOi1DLQjvkecGofTBFVgBbWO/shQ6LW1Lpr8Q3lixVG5FOVA82IWeiMZXQH18ZOz8RNFMD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mOuBjO3u; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7761dc1b36dso596968b3a.1
        for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 14:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758145871; x=1758750671; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=raX33s8++blO4FFDhhuZ1t5E6VYJ8jLOCEs3GGXrhy4=;
        b=mOuBjO3uNlzXGe83rw/7pDmuO2CChgbdyCz8NaqLayWeQBsCc/WyAtoOp+hEnVxGGn
         ulWLdl4GcNKz/6OZFFm2HpXm6Otxs3x+F05aVKYQ6EA17QKROAjkasrAugUgJ5s0dFf2
         Yi/b1PokCjFLfClg0NQRStVxg+9HW2IcUxnQ006I8aEWVC5JmHyjYFeRjUDgLyyxO25n
         PeJnDri2Aa4mM9iRS4DClZ9WuYDatCnwwyNMgofRmCsYmxuEcGOcPmuiqWIlutv0DLQ7
         NPps1KlamvGCSEsipKclnxUn0ZuexsYe87NVwDXWKuHNz2VZ4RP7CypzpvxaVbM3Ak6J
         H/JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758145871; x=1758750671;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=raX33s8++blO4FFDhhuZ1t5E6VYJ8jLOCEs3GGXrhy4=;
        b=fVAXfKMPQB6yvcCn37VlHExCyOVsqLcdK/esKT8D7WkjYUgeArQQtrfKoymLh2iTHj
         OSW4fKIoe7Udz6Lv5CnW5t4YPajtyoYLbglsGd1xfw8JSOmsvNTVTOyAH/aiYkS+nwH2
         CEzj16l1Bnk16vAZSeZ5SqYxBchUSsF9f8GbnwO/RWNjEm07FYw1QQN+KzNMpaNzIJa8
         m3d/CTI74m4zjXtBhyVOwX6TTf2Q4QOLnV6OvH8dtnmq39wAIQFMyCKahXeqjaKzI2Ax
         UwQt9+SV1gfWYwTbsybDvlEeF+DTk90ioa0r1042HPXTGEnVUjGr7HhASq59dqh/yNuX
         YBpA==
X-Forwarded-Encrypted: i=1; AJvYcCU8RlCHOz6FOkSq2wteMN/yV9wyDngtfDyiddk/cmjmUWOYZ/nTw+lRB42I8eBZRTTyjAE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUshYqbFPSG8bxkTYnRQv6FhbMzHLVmThicLTK312f2QQsCU4T
	3VghRUfYCx/izGZLjeLjF6skYVNOwKskjr644OIudx0CTRy28MGURX88SgU3Ds80P24grtyjHPo
	+nplv024JDrbtWw==
X-Google-Smtp-Source: AGHT+IEXHIfe31iHTiPUjWBrijjL9dOd26voZYrj2f7+bWGKHk6sS7I2FWWtoOYTdxUvPxMvYQxGk7MANH51Kg==
X-Received: from pfaq4.prod.google.com ([2002:a05:6a00:a884:b0:772:32b1:58f9])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:4328:b0:24e:2cee:9585 with SMTP id adf61e73a8af0-27aa99bdb8fmr5600927637.54.1758145871359;
 Wed, 17 Sep 2025 14:51:11 -0700 (PDT)
Date: Wed, 17 Sep 2025 14:48:37 -0700
In-Reply-To: <20250917215031.2567566-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250917215031.2567566-1-jmattson@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250917215031.2567566-2-jmattson@google.com>
Subject: [PATCH 1/4] KVM: selftests: Use a loop to create guest page tables
From: Jim Mattson <jmattson@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Andrew Jones <ajones@ventanamicro.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, "Pratik R. Sampat" <prsampat@amd.com>, 
	Kai Huang <kai.huang@intel.com>, Eric Auger <eric.auger@redhat.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Walk the guest page tables via a loop when creating new mappings,
instead of using unique variables for each level of the page tables.

This simplifies the code and makes it easier to support 5-level paging
in the future.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 .../testing/selftests/kvm/lib/x86/processor.c | 22 +++++++------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index d4c19ac885a9..0238e674709d 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -184,8 +184,8 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 {
 	const uint64_t pg_size = PG_LEVEL_SIZE(level);
-	uint64_t *pml4e, *pdpe, *pde;
-	uint64_t *pte;
+	uint64_t *pte = &vm->pgd;
+	int current_level;
 
 	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K,
 		    "Unknown or unsupported guest mode, mode: 0x%x", vm->mode);
@@ -209,20 +209,14 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
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
+	for (current_level = vm->pgtable_levels; current_level > 0; current_level--) {
+		pte = virt_create_upper_pte(vm, pte, vaddr, paddr, current_level, level);
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
2.51.0.470.ga7dc726c21-goog


