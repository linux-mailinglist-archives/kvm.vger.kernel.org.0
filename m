Return-Path: <kvm+bounces-66873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D47ECEAD26
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 00:03:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C4B0A3040A50
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 23:02:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49D392E6CC4;
	Tue, 30 Dec 2025 23:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wlMnN8ZA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC20F28506A
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 23:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135718; cv=none; b=Pyl4Ms0za/o0uODb7XUnBM2UakCJYtt/opsSYNigst8gqw64qe2e1VTVinV6iy7Ao5+x4NA1SOfEmBaIYip+q6+TM2q6ByEFR8n9KxHHNGZIlQYrrEFO1JO+jWNIcF7N5yIxo5+/DlMYKtD82bl1QSt6XTazKYJyiMThbgwPi/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135718; c=relaxed/simple;
	bh=eN5uc7pSFzMybyeyIg1wl+tq2Gr7dbaFYRW0/rdIHyY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I/2Gu5fyt7MZ3QZCIB3pHIwps5YNoyRd5CnXqFXmVfkpj0FaDeu9PnkZlTagvHB34XHtjNuWefVvGqpVKJWTjQ1rkPgnekM2erQckBDgpnzOQk0f4GponLK1XobcX9DpnlVVYMYGbao7HvGaZjfgd314ezT8Qfxa7YEttsSWPX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wlMnN8ZA; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a31087af17so205317195ad.1
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 15:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135716; x=1767740516; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=A1x3Jv4hKAWrGgMmMHZE2moCxnL8NNPpEDvW/jENOxU=;
        b=wlMnN8ZAQuUzwfITHfJfa3XuaGu02njfpBrkUDdIY5RLM2I6T+xKA1AoHVbdSdqcN9
         gk7GgO19gGVi4nhmAQzsU2d/gFzeta0scJga3TtUnCvyhkuJ5JNXTfZUTTRgvEqyr/eN
         yAvt6cZ2+obN+xIv+kw9oas0R2onbxgWnFCo3NkXlYeutKyaKeAdgldRvcBnYU9N6rHG
         ZTPFYWJ3xkGh/z9+cnZqq5vUt2R8v/fQ2k307HBhXHPOlL1C91Pp0pmWfkxkOAC/nYZ9
         RXdQ87MVhEZ2EzC7c9C4CqIiSsdf4fQWSxaoj2JY6EeGmqOZxFj3hGw8AvsNS/hzLXBN
         f4pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135716; x=1767740516;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A1x3Jv4hKAWrGgMmMHZE2moCxnL8NNPpEDvW/jENOxU=;
        b=epMWQoz7KhQTIMSRSPy1wBhvZIrtJkxZTgpvSRpN/O2nPF3F22JwMH1Jj/+foBmsei
         I2AYmD/P9Ole4vY6OI2cWeIyuydGx8vw4UEh8PjAqDyHd/fYWkknfRqolAwzTkPkRDMy
         q8tyfg1UKOnga2bxBSYx9+nQV6GM6E0atG7Ykemdj4B4eWyhNHqWcNprWSNc9aJborkx
         RV9GBvnO/8jV3d4bI/Avskw5mGg2PSJTDa6ecbHuy2wXCkjAqv4IR9nXKpOdnTdag8HI
         K0UAKefRVwaTHqZqvXhLpuCcmVF9NbxmAF1vj93KdwLD3EDJPGr/mA7QII+p/W1mB7Gp
         ItHg==
X-Gm-Message-State: AOJu0Yzi8ebJM/bC0ZkfjE7/zpKBpbsNamE3otux9RB7M6hyn5Bv27ia
	Iuatpt5wmBPyDiZ+vaizuX6RdpNO79j7MuQnzMVtvROdIxh8PefC/Jd7bptGeZK9Hw6NW5IK6H1
	V8GR3dQ==
X-Google-Smtp-Source: AGHT+IEv+GX7evZLjKnG5+SJTBFZGdYgiJ8sh+9jSGp5VMcqldVrrbZx+5CrciujOKyo6Zq9eBa3EV2km6w=
X-Received: from pjbpm1.prod.google.com ([2002:a17:90b:3c41:b0:34c:2ca6:ff3e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:32d1:b0:293:e12:1bec
 with SMTP id d9443c01a7336-2a2f2229207mr365100115ad.20.1767135715930; Tue, 30
 Dec 2025 15:01:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:31 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-3-seanjc@google.com>
Subject: [PATCH v4 02/21] KVM: selftests: Stop passing a memslot to nested_map_memslot()
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

From: Yosry Ahmed <yosry.ahmed@linux.dev>

On x86, KVM selftests use memslot 0 for all the default regions used by
the test infrastructure. This is an implementation detail.
nested_map_memslot() is currently used to map the default regions by
explicitly passing slot 0, which leaks the library implementation into
the caller.

Rename the function to a very verbose
nested_identity_map_default_memslots() to reflect what it actually does.
Add an assertion that only memslot 0 is being used so that the
implementation does not change from under us.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86/vmx.h        |  4 ++--
 tools/testing/selftests/kvm/lib/x86/vmx.c            | 12 ++++++++----
 tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c |  2 +-
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
index 96e2b4c630a9..91916b8aa94b 100644
--- a/tools/testing/selftests/kvm/include/x86/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86/vmx.h
@@ -563,8 +563,8 @@ void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 		   uint64_t nested_paddr, uint64_t paddr);
 void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 		 uint64_t nested_paddr, uint64_t paddr, uint64_t size);
-void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
-			uint32_t memslot);
+void nested_identity_map_default_memslots(struct vmx_pages *vmx,
+					  struct kvm_vm *vm);
 void nested_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
 			    uint64_t addr, uint64_t size);
 bool kvm_cpu_has_ept(void);
diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index 29b082a58daa..eec33ec63811 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -494,12 +494,16 @@ void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 /* Prepare an identity extended page table that maps all the
  * physical pages in VM.
  */
-void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
-			uint32_t memslot)
+void nested_identity_map_default_memslots(struct vmx_pages *vmx,
+					  struct kvm_vm *vm)
 {
+	uint32_t s, memslot = 0;
 	sparsebit_idx_t i, last;
-	struct userspace_mem_region *region =
-		memslot2region(vm, memslot);
+	struct userspace_mem_region *region = memslot2region(vm, memslot);
+
+	/* Only memslot 0 is mapped here, ensure it's the only one being used */
+	for (s = 0; s < NR_MEM_REGIONS; s++)
+		TEST_ASSERT_EQ(vm->memslots[s], 0);
 
 	i = (region->region.guest_phys_addr >> vm->page_shift) - 1;
 	last = i + (region->region.memory_size >> vm->page_shift);
diff --git a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
index 98cb6bdab3e6..aab7333aaef0 100644
--- a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
@@ -121,7 +121,7 @@ static void test_vmx_dirty_log(bool enable_ept)
 	 */
 	if (enable_ept) {
 		prepare_eptp(vmx, vm);
-		nested_map_memslot(vmx, vm, 0);
+		nested_identity_map_default_memslots(vmx, vm);
 		nested_map(vmx, vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, PAGE_SIZE);
 		nested_map(vmx, vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, PAGE_SIZE);
 	}
-- 
2.52.0.351.gbe84eed79e-goog


