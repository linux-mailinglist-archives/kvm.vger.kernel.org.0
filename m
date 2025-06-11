Return-Path: <kvm+bounces-49059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A649BAD573B
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 15:35:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 550AF173976
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 13:35:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DD5E2BDC25;
	Wed, 11 Jun 2025 13:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gw77aLaW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8542BD588
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 13:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749648841; cv=none; b=fjFNGdMQRCBtFS9p/g8vdnw+lbhAhsxC2lutof2HpEceEramW9XpwJsO9RG5ab0HkWQfn5dfNOq5LFpuq+vaRd6CXdVATjpPkq4vPyCopExFEUcAe3tcUNfNGL0szhVwU89yQZ+78oXBbFMmMnkeIwK+itzw9RFUxRcgy20hxsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749648841; c=relaxed/simple;
	bh=tYG9no4G4/4JoJdOu43WxRTdUoeN59thOVKVvS8wFCQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ONsVFvd31q8Phyhzn+2hWUpUYd5cRGt+2uHtl1IOYjoeXFB+Tq3IYDO9xIHHCZ3W0hZlcSVulKySB8xKodUoax9aidT+dO8csnpeXkz4hUIYO1r1qyMfZIWvmzi+frfMiwwAUqTsqXbl8oZLBtkyMaBoVtMffXYLtMMh1ZwqP1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gw77aLaW; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a4eeed54c2so4365881f8f.3
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 06:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749648838; x=1750253638; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q0GmgHpBmCA6zvNGFoi1Z/wq5QrRCsY3MSz2+Tp46gs=;
        b=gw77aLaWuvO1wWRnr7zReOJZJMaCcdeyvnE5NRhDXgG3j+E2qqzPwHlG8ChEmqCmX/
         qOepddLwY7vX4gFQErTMDxjlQqXNvweJF14pExbi3P9ibLb+/HcQbymrDk6ei/FnEb/+
         2ZkkkNw2p4h7OQWv6tM0xEHXOjVVDUrTTtoa5Y4NhjRSWrT3StL47rPGZ9bS74oZbD9Z
         HRASczhNG+oEfsm36GYLxLYCwjuEWRJtUyVtLMtHaQ16NSeJUhCOQH0iZs8mXWMPzwbj
         hrya8cbniDN2aJ1GxEiXce/i13/JKWtHTCQBYjV4R4WZgpjd8LQax0pilF2T7K5UB8vd
         ceSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749648838; x=1750253638;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q0GmgHpBmCA6zvNGFoi1Z/wq5QrRCsY3MSz2+Tp46gs=;
        b=SjZA0nb4vn8HlyyLNKdUuxNtDWMmz5olHHNM+/EngxVGL9d9mvwBIKBZ36Z4fLgorO
         uALuMBAO6uu21tLB4oEbuYXDOws80eO/etsi8ViBXicbW9GP/DqGUA8Xw+YBHElOlgG7
         /uRnI9g7DOzSKv/kvE/OIWlccZptKrUXPRM/KAF2oLw1+YHcxvNLb1Bc5O92LMuH0HfM
         Z5yPXj4HYgOr1vKPIiIF5OFRvEpjw142m1EmW2Z6VwM8McbiHIs7NPMegVUCR8cV/viq
         N8hF+3oxEJtdbQ7kmNiKiFMppz1bKCfgteTrdOMNHw/M/F+TOvn/GrR+OCTNmK3apTbZ
         blEQ==
X-Gm-Message-State: AOJu0YwAaatiz5S+62mPUhUBzUbwX2+/qnsGvWxMU8tQi/lVvcy3lm8e
	VXBM5rjAPJE0qKJ1+W8xN0uACg+VBGq0EE7Suuia8x24+vtRgMKto4wekRl/lnNd3VRpu1wQkdj
	Su0V5WdWKwPXTuyfVXmgGuj1uBG+2nZj/AgGjHCe/eUt1cMqgMvxsYVIQM67EfdUz/Q+1QhYN7Q
	5J5U4Xdf2FyH9b1Vbxw8+OZ7gKwyQ=
X-Google-Smtp-Source: AGHT+IFsqWff+6T7vsnYAkU42VVIgmr2bH+P6xTa1OxLp26jM0y9wIP/2qeKEvMKHtR2cbUL2VHzGV2row==
X-Received: from wmbji2.prod.google.com ([2002:a05:600c:a342:b0:453:910:1a18])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:290d:b0:3a5:2ef8:3512
 with SMTP id ffacd0b85a97d-3a558aa3a1fmr2525369f8f.14.1749648837456; Wed, 11
 Jun 2025 06:33:57 -0700 (PDT)
Date: Wed, 11 Jun 2025 14:33:24 +0100
In-Reply-To: <20250611133330.1514028-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611133330.1514028-13-tabba@google.com>
Subject: [PATCH v12 12/18] KVM: x86: Enable guest_memfd shared memory for
 non-CoCo VMs
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Define the architecture-specific macro to enable shared memory support
in guest_memfd for ordinary, i.e., non-CoCo, VM types, specifically
KVM_X86_DEFAULT_VM and KVM_X86_SW_PROTECTED_VM.

Enable the KVM_GMEM_SHARED_MEM Kconfig option if KVM_SW_PROTECTED_VM is
enabled.

Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm_host.h | 10 ++++++++++
 arch/x86/kvm/Kconfig            |  1 +
 arch/x86/kvm/x86.c              |  3 ++-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4bc50c1e21bd..7b9ccdd99f32 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2271,8 +2271,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 
 #ifdef CONFIG_KVM_GMEM
 #define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
+
+/*
+ * CoCo VMs with hardware support that use guest_memfd only for backing private
+ * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
+ */
+#define kvm_arch_supports_gmem_shared_mem(kvm)			\
+	(IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&			\
+	 ((kvm)->arch.vm_type == KVM_X86_SW_PROTECTED_VM ||		\
+	  (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM))
 #else
 #define kvm_arch_supports_gmem(kvm) false
+#define kvm_arch_supports_gmem_shared_mem(kvm) false
 #endif
 
 #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 9151cd82adab..29845a286430 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -47,6 +47,7 @@ config KVM_X86
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_PRE_FAULT_MEMORY
 	select KVM_GENERIC_GMEM_POPULATE if KVM_SW_PROTECTED_VM
+	select KVM_GMEM_SHARED_MEM if KVM_SW_PROTECTED_VM
 	select KVM_WERROR if WERROR
 
 config KVM
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 401256ee817f..e21f5f2fe059 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12778,7 +12778,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		return -EINVAL;
 
 	kvm->arch.vm_type = type;
-	kvm->arch.supports_gmem = (type == KVM_X86_SW_PROTECTED_VM);
+	kvm->arch.supports_gmem =
+		type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
 	/* Decided by the vendor code for other VM types.  */
 	kvm->arch.pre_fault_allowed =
 		type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
-- 
2.50.0.rc0.642.g800a2b2222-goog


