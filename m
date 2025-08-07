Return-Path: <kvm+bounces-54272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CA94B1DDD0
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 22:17:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C9F618C5F67
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 20:17:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02137239567;
	Thu,  7 Aug 2025 20:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KUNPzBGX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5282222B6
	for <kvm@vger.kernel.org>; Thu,  7 Aug 2025 20:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754597801; cv=none; b=jSxCTEX/L3kGSPWirYEZFV7FKB3xR9JdXh9QQ3DsQCZOqd2GmCnwro7P5+l21ReRK9qDIkjlS1XvQsRJPMw3DbYiLcLHh0laxz1FmhBuntXntPtXQpR3XRBTJhqKQYDFwcycZ/h5E620UTqJD6liLyy7izLVvRBy7tN6ubLoYjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754597801; c=relaxed/simple;
	bh=ZGm78cVu0eE8NMdDtBRB7S6EsWyYptmULKCe3VJEPzw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K3oI5NIDzmldkh4MCzwoXBgCIpM8YJZwP2HLk8zlgW79ENPx7pOERw+EiGpv6Wwf05jOV/kzSg71ImHn4Gn3twqMgNjNeBqppnrx+WReStxcZSU4HJVXw5VphjOEeN1mttQ2suuKgqirY8zvknEIh89ofwjFoK63DOE7PfDV8Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KUNPzBGX; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32147620790so1481342a91.1
        for <kvm@vger.kernel.org>; Thu, 07 Aug 2025 13:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754597799; x=1755202599; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z4PvKVoMzsbWuS6ZNQkHyRpKtVjC8q7nP9qV4BuVoxE=;
        b=KUNPzBGXuk1sv+jl+byzxQRbS/vJ9iOIor2YSOXTcPW0eFYZwJmm+2mS8oIwraujsR
         Qtf59XKVr4Qp29P7lRnQYcTkxlqY/bSmozJoJLKzbrsiGd0CqX+IRdkZdkVzCzneN5pu
         NcuyVD2TAzr0n715DDJYruVl4kWEiMEV2OOTxqik6+o2nupHnAibL8AobsbaB+hTaWuA
         8y2O992f8vYqbBtZDyoGpyVBRy8TpcmSI8wbLDrWllcCrFYlwnMBwobWVfF2rPLEi5ew
         4WITXpntEKoNyNntbbN+Bxd07IOdzwCFWrq3ouMTqv+e9i0AIPSWFIeBr0CB0d4LZsZ5
         KUow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754597799; x=1755202599;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z4PvKVoMzsbWuS6ZNQkHyRpKtVjC8q7nP9qV4BuVoxE=;
        b=kAwOSrIu7z99JeXsAReUTgDI1tbOci6I/Ze72qb4o6rYbICyzm+6MmjxFDr6n3tMjE
         /LVgK0aR3BvZdNcP88s33Nx5MUt4j7e2SHDiB6m1MwvGw+E+eG4sM/JzUTYgSa/Yg6+9
         cb4b7oIGfl73yB8XL5zL1pYAGLOICWif4MakR3Dg3KaWbEaKgqkSnD6PRULkQvyMOXhq
         9ZNPmUnQkP4ZMAL4K8fXKljmZbw5MetJjZDO1L34vvZd/wc4YjtIV8vUMPO08OkVWj1z
         QhrVEDc/n6u4A530fa69LnIESbfr62CYIWfV8hcxEjJbDx/lb68hCPw+UDt+21ChzcoB
         Y7qw==
X-Forwarded-Encrypted: i=1; AJvYcCUdnAFDhLZmvu+PM8wMykbY3l2KYNSGOT4Lhj2lWyGE+u+KNmOAAC8E5vmJDOCAMx5qBqI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0UvumDQwPuouJXDCwq41Wm3nq71nPlJClsBH4pO36hfCzxGLj
	sDgS9Jew1P4iLDL4gB/QtAFCZFaiDkUzFAey5AmIAPl7jzn7xmSXEXQh1H5RbIFABOrQQX4c/gj
	gqA==
X-Google-Smtp-Source: AGHT+IHlHTUzlI4XwfrvCHdPuSXY+IAAqyr2BEu6Hs2JizbOH4J+KBh8PsRSDzHe1VZ8MTVIYlqnupSA+w==
X-Received: from pjx13.prod.google.com ([2002:a17:90b:568d:b0:31e:fe0d:f464])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:28c5:b0:31a:ab75:6e45
 with SMTP id 98e67ed59e1d1-32183c42d6dmr439441a91.28.1754597799003; Thu, 07
 Aug 2025 13:16:39 -0700 (PDT)
Date: Thu,  7 Aug 2025 13:15:57 -0700
In-Reply-To: <20250807201628.1185915-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250807201628.1185915-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
Message-ID: <20250807201628.1185915-2-sagis@google.com>
Subject: [PATCH v8 01/30] KVM: selftests: Add function to allow one-to-one GVA
 to GPA mappings
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

One-to-one GVA to GPA mappings can be used in the guest to set up boot
sequences during which paging is enabled, hence requiring a transition
from using physical to virtual addresses in consecutive instructions.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  3 +++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 27 +++++++++++++++----
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index bee65ca08721..9994861d2acb 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -650,6 +650,9 @@ vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
 vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz,
 				 vm_vaddr_t vaddr_min,
 				 enum kvm_mem_region_type type);
+vm_vaddr_t vm_vaddr_identity_alloc(struct kvm_vm *vm, size_t sz,
+				   vm_vaddr_t vaddr_min,
+				   enum kvm_mem_region_type type);
 vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
 vm_vaddr_t __vm_vaddr_alloc_page(struct kvm_vm *vm,
 				 enum kvm_mem_region_type type);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index a055343a7bf7..8f3dbf749afa 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1460,15 +1460,14 @@ vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
 }
 
 static vm_vaddr_t ____vm_vaddr_alloc(struct kvm_vm *vm, size_t sz,
-				     vm_vaddr_t vaddr_min,
+				     vm_vaddr_t vaddr_min, vm_paddr_t paddr_min,
 				     enum kvm_mem_region_type type,
 				     bool protected)
 {
 	uint64_t pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
 
 	virt_pgd_alloc(vm);
-	vm_paddr_t paddr = __vm_phy_pages_alloc(vm, pages,
-						KVM_UTIL_MIN_PFN * vm->page_size,
+	vm_paddr_t paddr = __vm_phy_pages_alloc(vm, pages, paddr_min,
 						vm->memslots[type], protected);
 
 	/*
@@ -1492,7 +1491,7 @@ static vm_vaddr_t ____vm_vaddr_alloc(struct kvm_vm *vm, size_t sz,
 vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
 			    enum kvm_mem_region_type type)
 {
-	return ____vm_vaddr_alloc(vm, sz, vaddr_min, type,
+	return ____vm_vaddr_alloc(vm, sz, vaddr_min, KVM_UTIL_MIN_PFN * vm->page_size, type,
 				  vm_arch_has_protected_memory(vm));
 }
 
@@ -1500,7 +1499,25 @@ vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz,
 				 vm_vaddr_t vaddr_min,
 				 enum kvm_mem_region_type type)
 {
-	return ____vm_vaddr_alloc(vm, sz, vaddr_min, type, false);
+	return ____vm_vaddr_alloc(vm, sz, vaddr_min, KVM_UTIL_MIN_PFN * vm->page_size, type, false);
+}
+
+/*
+ * Allocate memory in @vm of size @sz beginning with the desired virtual address
+ * of @vaddr_min and backed by physical address equal to returned virtual
+ * address.
+ *
+ * Return the address where the memory is allocated.
+ */
+vm_vaddr_t vm_vaddr_identity_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
+				   enum kvm_mem_region_type type)
+{
+	vm_vaddr_t gva = ____vm_vaddr_alloc(vm, sz, vaddr_min,
+					    (vm_paddr_t)vaddr_min, type,
+					    vm_arch_has_protected_memory(vm));
+	TEST_ASSERT_EQ(gva, addr_gva2gpa(vm, gva));
+
+	return gva;
 }
 
 /*
-- 
2.51.0.rc0.155.g4a0f42376b-goog


