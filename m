Return-Path: <kvm+bounces-59614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 00099BC2E45
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 00:45:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 28A784E7E06
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 22:45:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5464B25A2A7;
	Tue,  7 Oct 2025 22:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gutkNNvr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F140025A2A2
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 22:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759877120; cv=none; b=EY6s5QnDBIfwqX8W04eFMBIJpdQkQ9MNBBKx6lEtvjaMjFLM4PxPTep15itdCFYo5pQVbASNyDHCFBJHcobav19XeIykITLTeAr69BjC9oIjXC0zV75tzPa8BvzFDy2hwsAsgjbKgkdk4FhFd8q/6j5vvk32/RPz4mi2tfLwu3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759877120; c=relaxed/simple;
	bh=eC9JReDks8Bh1ObFeTrelVJadmhwQypwM4JvFQpMPFs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=cDz1CRLs1SaJ7NjN1cyDcIpghcG1iRFcXlHvTATMuUnEm1KUVxAwoLh62jASYnPofG8TgSeicZ8s2mpJNu/46RNQ3MKUu/spuFHunndNYQ/015BABhQJ4V6Wcm7ij8gLowmUhRcLszWPrybhh0ShxQhXgIRussAoIjeqbVUXV3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gutkNNvr; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-28bd8b3fa67so61602845ad.2
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 15:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759877118; x=1760481918; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GeTuGOZuqOzgsIuRkdvDy8a0bTpK5eYCrWELv8gOHrc=;
        b=gutkNNvrBcXq3hjbRhPeQ5XAejdxFpTNFkzwypnz9VKNlpx0JwolA6OO91gO04x2Ih
         db/gidWSo2fabVDUuKwyL5K3Nmz2qSCg9efawpubdkTR99AP6Kbra9UjzXbXKchsc8C6
         WvDPShSWdOuHzKSvPTu/qehGsrHEaNa7DPfGXwjq2ko9j0t/fhLwdrpM8hJJ7dzZ8vYx
         YIDU6fFY1wW5HpOemhEy9W3IRjDy2iJFXO3Zem00ZRClSeij7yo2njGH9XmUrlCh3CgS
         A291QPFMS4XoeHdfJiCvCDQXioYM4qa8zW8BK6fJZNjWu77xDXwW3ZPF71pSMr6197NR
         7ngg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759877118; x=1760481918;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GeTuGOZuqOzgsIuRkdvDy8a0bTpK5eYCrWELv8gOHrc=;
        b=XbqH2CVw9iGRCFo4N93C/I/0CxMKjVHRrHB8d5VUllpTlBTa7suyyGGkPjROHxpDKS
         2F/n+3tIEfVsy3n5zvCzrH85fygQqNDUHEp09O8vSdsHfW6nTxqzncxvNCI1eX/GtFIL
         HUF0QuqI4zDtF96tcTnml+Eu6BuziDvCwmp5xU9Tluv0JGhZtouKitTqQJBfPXb3eBOb
         IK2PwB1X8TFk+xRS7Iy1mED7cjqpqkZCkzkskcUC0MX9S4BaVFzquKN+1IoN5M2x5cbs
         HdbO308uQ7kfhWBpU8Xp3OA14B2cRc/PPUyD5lQa8fjfNBm0BVRq1EP3SkljQFchK6pL
         kStQ==
X-Gm-Message-State: AOJu0YyWgUqBPzLOqXGxYR9bnc1YKLOngpH0YkcVYVOpihr1tDdzUQGU
	aq0i2ujl8rX4qP0ihiQEz3ajAleBGf5ds5M9Hk6opSTKJ+c7YnBhFnaCfQXiRwXqescnUw328OI
	FkKeGLQ==
X-Google-Smtp-Source: AGHT+IEZNteKaNr4z9Ryhu8t036SIAgvFyeU2oJCWflX22nsnzNhdVKwA0CcUPbt/5r8MAm+htSw5wx28xU=
X-Received: from pjbfh9.prod.google.com ([2002:a17:90b:349:b0:329:ec3d:72ad])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38c1:b0:32e:a54a:be5d
 with SMTP id 98e67ed59e1d1-33b51124890mr1214710a91.2.1759877118188; Tue, 07
 Oct 2025 15:45:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Oct 2025 15:45:15 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251007224515.374516-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Use "gpa" and "gva" for local variable names
 in pre-fault test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Rename guest_test_{phys,virt}_mem to g{p,v}a in the pre-fault memory test
to shorten line lengths and to use standard terminology.

No functional change intended.

Cc: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/pre_fault_memory_test.c     | 27 +++++++++----------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index f04768c1d2e4..6db75946a4f8 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -161,6 +161,7 @@ static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 base_gpa, u64 offset,
 
 static void __test_pre_fault_memory(unsigned long vm_type, bool private)
 {
+	uint64_t gpa, gva, alignment, guest_page_size;
 	const struct vm_shape shape = {
 		.mode = VM_MODE_DEFAULT,
 		.type = vm_type,
@@ -170,35 +171,31 @@ static void __test_pre_fault_memory(unsigned long vm_type, bool private)
 	struct kvm_vm *vm;
 	struct ucall uc;
 
-	uint64_t guest_test_phys_mem;
-	uint64_t guest_test_virt_mem;
-	uint64_t alignment, guest_page_size;
-
 	vm = vm_create_shape_with_one_vcpu(shape, &vcpu, guest_code);
 
 	alignment = guest_page_size = vm_guest_mode_params[VM_MODE_DEFAULT].page_size;
-	guest_test_phys_mem = (vm->max_gfn - TEST_NPAGES) * guest_page_size;
+	gpa = (vm->max_gfn - TEST_NPAGES) * guest_page_size;
 #ifdef __s390x__
 	alignment = max(0x100000UL, guest_page_size);
 #else
 	alignment = SZ_2M;
 #endif
-	guest_test_phys_mem = align_down(guest_test_phys_mem, alignment);
-	guest_test_virt_mem = guest_test_phys_mem & ((1ULL << (vm->va_bits - 1)) - 1);
+	gpa = align_down(gpa, alignment);
+	gva = gpa & ((1ULL << (vm->va_bits - 1)) - 1);
 
-	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
-				    guest_test_phys_mem, TEST_SLOT, TEST_NPAGES,
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, gpa,
+				    TEST_SLOT, TEST_NPAGES,
 				    private ? KVM_MEM_GUEST_MEMFD : 0);
-	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, TEST_NPAGES);
+	virt_map(vm, gva, gpa, TEST_NPAGES);
 
 	if (private)
-		vm_mem_set_private(vm, guest_test_phys_mem, TEST_SIZE);
+		vm_mem_set_private(vm, gpa, TEST_SIZE);
 
-	pre_fault_memory(vcpu, guest_test_phys_mem, 0, SZ_2M, 0, private);
-	pre_fault_memory(vcpu, guest_test_phys_mem, SZ_2M, PAGE_SIZE * 2, PAGE_SIZE, private);
-	pre_fault_memory(vcpu, guest_test_phys_mem, TEST_SIZE, PAGE_SIZE, PAGE_SIZE, private);
+	pre_fault_memory(vcpu, gpa, 0, SZ_2M, 0, private);
+	pre_fault_memory(vcpu, gpa, SZ_2M, PAGE_SIZE * 2, PAGE_SIZE, private);
+	pre_fault_memory(vcpu, gpa, TEST_SIZE, PAGE_SIZE, PAGE_SIZE, private);
 
-	vcpu_args_set(vcpu, 1, guest_test_virt_mem);
+	vcpu_args_set(vcpu, 1, gva);
 	vcpu_run(vcpu);
 
 	run = vcpu->run;

base-commit: efcebc8f7aeeba15feb1a5bde70af74d96bf1a76
-- 
2.51.0.710.ga91ca5db03-goog


