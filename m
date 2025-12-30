Return-Path: <kvm+bounces-66879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 81170CEAD32
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 00:04:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C6F67302B12A
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 23:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29FAA2FD1C2;
	Tue, 30 Dec 2025 23:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Nf4Pib9v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977652E8B81
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 23:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135730; cv=none; b=fMMl2J3KPuDeR4M1kLVf8JvEbL+wSmZ73BxzJsz/aomKkhO9ODEqp+JG6gtXSrSILK92r6HoL5JZ9AgzMFKqFN5DBllPH7Dw1RxE+GuAcA37s3PzNidMuxyBEUEuOdUQrOMNfmq4sKKxovLTaY/pY4yUtEp5OSmcg8TrvdXiXN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135730; c=relaxed/simple;
	bh=pyBUiyOamhL8LS5/W09JA+DscggetuA4FZPbkkaVrm8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J/TiUtqhhFfyPxf7neKJGnzDYReYHqKXcy7SVCUqai3HKen0QRIaKzuYjIpro+rnyj/c2iaRGHGWCiF/N0MCCzirCm4pdZ43Jf33iA0JDHlY6n3w054T6RLWeaATtMaoamD2TLlegsA3enXlH8wWP+yhPHeAxq0XXFMvqC87YZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Nf4Pib9v; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0bb1192cbso205119215ad.1
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 15:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135727; x=1767740527; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=sUaPNsiWybrsN14UDe2YJDAR+cxy5ZbGWPMbDaaniZw=;
        b=Nf4Pib9vVgG/sLPiis7httwoX01KDFNxQFYr598a7rUzRSOUgPRPPcO5ZOA3o+X0I3
         xs24LO1/Cdg7icax11d6wG3bKaaZPhSk/uqGlxboaTJp0rztINAm2ubzOliqGQJ0bXnX
         m98nNy9W9lR940q1v/A86w4lHN77RdYPVTEsyPqXuOHGbcNRWCQ8H4r4l47sq/v9KWOm
         IhUuwYpKmayCIJ9sTFjHKlQOZxn560yLGv37nXbGqyUQV7DlUxbjlkKcVU7Cwa2coYQh
         0WwlX4C3VPGvUqL1o1xuK5jNLqQEm5XyAyAYCJu7tjq5fymPngPzi+gFt1QkWzf/vYvJ
         GhMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135727; x=1767740527;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sUaPNsiWybrsN14UDe2YJDAR+cxy5ZbGWPMbDaaniZw=;
        b=iME4e+3AXhpNmnq5p1FKGh/wyJ631sNgVK2fm8NYLJlpvddODuzoy9J3rB881l3ASg
         CFsWuqQVcKPjv44+Bv/1jHYYIusE78ftS1WnBSl/JiWBY/fUmJb26hrGlsXQ5rUE6hRK
         zSXyXii6rpCtAeJlK3U20Zk9Nl7On+UhzBL9VbmpolJUMlagLM5tePcaRY1p6TTRrzBp
         jwpQvHXZbhX1vmHLPTwGVegC1zQaKVMAExjhKjzCqqXRqf9J+/g5kGJiu7TOj5Qpl4rQ
         zfIErx+H8iOE3AA97qn1MMavtUA4/gSbSVY+7XEKsD6o5VtuAvwIH8efrju1KsVZ/mN2
         +Hsw==
X-Gm-Message-State: AOJu0YxoKraSaP6MiJrr90PkFRRKNvVpKef/3h7TPe5U49YjxoF9llKt
	kADLA7dV3z5mCqm05+TOib8HVdYXnypBJhO4mVWxfKk0mz+erUonqyXT8rTJrxMhk1om9WY08aZ
	RebqvNw==
X-Google-Smtp-Source: AGHT+IFQnOuwYC0g4+LirB1coBfKvkA6ZwCBuTM8ay+vZ/F6ieVjqX4SvnIiidBDol06ehcl6JagnUzMopM=
X-Received: from plxx9.prod.google.com ([2002:a17:902:e049:b0:2a0:9ab8:a28d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2f0b:b0:2a0:9970:13fd
 with SMTP id d9443c01a7336-2a2f293cf1emr298922605ad.43.1767135726838; Tue, 30
 Dec 2025 15:02:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:37 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-9-seanjc@google.com>
Subject: [PATCH v4 08/21] KVM: selftests: Add a "struct kvm_mmu_arch arch"
 member to kvm_mmu
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

Add an arch structure+field in "struct kvm_mmu" so that architectures can
track arch-specific information for a given MMU.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/arm64/kvm_util_arch.h     | 2 ++
 tools/testing/selftests/kvm/include/kvm_util.h                | 2 ++
 tools/testing/selftests/kvm/include/loongarch/kvm_util_arch.h | 1 +
 tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h     | 1 +
 tools/testing/selftests/kvm/include/s390/kvm_util_arch.h      | 1 +
 tools/testing/selftests/kvm/include/x86/kvm_util_arch.h       | 2 ++
 6 files changed, 9 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/arm64/kvm_util_arch.h b/tools/testing/selftests/kvm/include/arm64/kvm_util_arch.h
index b973bb2c64a6..4a2033708227 100644
--- a/tools/testing/selftests/kvm/include/arm64/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/arm64/kvm_util_arch.h
@@ -2,6 +2,8 @@
 #ifndef SELFTEST_KVM_UTIL_ARCH_H
 #define SELFTEST_KVM_UTIL_ARCH_H
 
+struct kvm_mmu_arch {};
+
 struct kvm_vm_arch {
 	bool	has_gic;
 	int	gic_fd;
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 39558c05c0bf..c1497515fa6a 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -92,6 +92,8 @@ struct kvm_mmu {
 	bool pgd_created;
 	uint64_t pgd;
 	int pgtable_levels;
+
+	struct kvm_mmu_arch arch;
 };
 
 struct kvm_vm {
diff --git a/tools/testing/selftests/kvm/include/loongarch/kvm_util_arch.h b/tools/testing/selftests/kvm/include/loongarch/kvm_util_arch.h
index e43a57d99b56..d5095900e442 100644
--- a/tools/testing/selftests/kvm/include/loongarch/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/loongarch/kvm_util_arch.h
@@ -2,6 +2,7 @@
 #ifndef SELFTEST_KVM_UTIL_ARCH_H
 #define SELFTEST_KVM_UTIL_ARCH_H
 
+struct kvm_mmu_arch {};
 struct kvm_vm_arch {};
 
 #endif  // SELFTEST_KVM_UTIL_ARCH_H
diff --git a/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h b/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
index e43a57d99b56..d5095900e442 100644
--- a/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
@@ -2,6 +2,7 @@
 #ifndef SELFTEST_KVM_UTIL_ARCH_H
 #define SELFTEST_KVM_UTIL_ARCH_H
 
+struct kvm_mmu_arch {};
 struct kvm_vm_arch {};
 
 #endif  // SELFTEST_KVM_UTIL_ARCH_H
diff --git a/tools/testing/selftests/kvm/include/s390/kvm_util_arch.h b/tools/testing/selftests/kvm/include/s390/kvm_util_arch.h
index e43a57d99b56..d5095900e442 100644
--- a/tools/testing/selftests/kvm/include/s390/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/s390/kvm_util_arch.h
@@ -2,6 +2,7 @@
 #ifndef SELFTEST_KVM_UTIL_ARCH_H
 #define SELFTEST_KVM_UTIL_ARCH_H
 
+struct kvm_mmu_arch {};
 struct kvm_vm_arch {};
 
 #endif  // SELFTEST_KVM_UTIL_ARCH_H
diff --git a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
index 972bb1c4ab4c..456e5ca170df 100644
--- a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
@@ -10,6 +10,8 @@
 
 extern bool is_forced_emulation_enabled;
 
+struct kvm_mmu_arch {};
+
 struct kvm_vm_arch {
 	vm_vaddr_t gdt;
 	vm_vaddr_t tss;
-- 
2.52.0.351.gbe84eed79e-goog


