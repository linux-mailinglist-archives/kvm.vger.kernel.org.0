Return-Path: <kvm+bounces-25444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D15DB96566C
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 06:37:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F14731C224B9
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 04:37:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAC681586C0;
	Fri, 30 Aug 2024 04:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E48Ai+wI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D551531F6
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 04:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724992577; cv=none; b=iewTUY4zmVM/geoSQwTgFP7Ku5rvSB3xQ57FD8v224uZd1U7E7PRgD7PlWqiimrxlAQx4k6uPTFp0cwDbw4z6Iqf0yU+JKkOoCRs4peNFZ90eiNUOAXxGyw7I500pFwNsem7vtxlNJ2JZN6+7jNhI6sA/C64D6mvxhgb1BgkuAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724992577; c=relaxed/simple;
	bh=guZPEi4HnZ68kmunYREUsW0wJ0a79wE6zG0LOWaHkWk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qBHYpZ5wqhLsZVKArOCVkRNkWAKA6X67jqvk+IyY2TCDUUEzR4TAQUZpEQqPwy+5PVDGVzdvmtibonOznX28i9A7mKzAxMuYqld7D15acepU0CyH05JqadOWB22sFVFLLvuZgkImrE50MeLFO8mwG2wwM4a5TXRdyu0MMiWfYi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E48Ai+wI; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6b0f068833bso37014477b3.0
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 21:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724992574; x=1725597374; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=udiDa1YXNVQe9YQdq8pNqA0v4AMGb+sHHwac6qQVu4U=;
        b=E48Ai+wInrWTdcy7S1ymgbdRLype09ekVwfhbZzYuZG9TQGCkRJAfbqRUkjrifDcWC
         Eg3fujG5pwARBQuhXfgrrCUe79ZNnqtD53MtJ7LApWzNGnWxo1IqL1RB8JViSP2AhDSt
         ARS+TMI8b1uJVDVzfgQ094PqeOTELAuVaZ2F93wQNi4CGj5DlJx3VxvIHLvY0UIfxI7C
         h1oIK137kuPN6nCVv6mh3CUzY9TuzBkzwutGkyiS13G8yR+/+hEmJQVnTdgjzMGNaEK8
         tyd2/ZcHaZVggvtZnRDng7QRh19ke6TmUMjTFUQJNG2iP3Btyf5EwMhNQFwilyetUzy0
         TukA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724992574; x=1725597374;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=udiDa1YXNVQe9YQdq8pNqA0v4AMGb+sHHwac6qQVu4U=;
        b=shV+Qb4AKsV5WBaBlXI3E2NAAWFyd4NYGKSUNa6Au4C+RZEEWaHxfz+79eFXJkRxI8
         8WVeqJM3L3eJ7caKGhadp/LRMNEAsKo8YVJCloEmLfmPkODaSPApA1nMNUFGkqyfD3Xy
         tFeGNOmJnmb9n/bGrtklzvl/Ob4piPxH36knC6SHyAl4BLMUiuiWNDSWorsWhB/8B8nl
         pfchcGQ3erkWCsMTIeRymsuu7jyRhpoOjQKLlFRNQkkEAefxmdQDbSCgOy/TCTXjD+Cc
         2UtkniVDS1RqAzv6vtCkJtCKv7BdqEUhOIFfq+4l9WneW9wF6hR/wkOUQ48pjPb6pA2F
         2c3A==
X-Gm-Message-State: AOJu0YwETIX92OJ59FSh6YsrGgGsVsePJGB4NHFAfZwjBMSFrgXZ6Z14
	P+ruzFJWB65yrDBQrB0kHER2sYdw9sYrQfKJ7nRcKslZ2rhvpZUMlTOHPWcP9Ubs5nNi/WMPYEj
	3tA==
X-Google-Smtp-Source: AGHT+IF7AfgBrJe8PwdncYuFwENH9bcWVSUBeh2Gmsa0ZJKxp7DrJ4HVnhtseSn5Ja9qHK89gyQHI56lkSI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6681:b0:665:24b0:e936 with SMTP id
 00721157ae682-6d286f64db5mr2502337b3.4.1724992574565; Thu, 29 Aug 2024
 21:36:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 Aug 2024 21:35:55 -0700
In-Reply-To: <20240830043600.127750-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240830043600.127750-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240830043600.127750-6-seanjc@google.com>
Subject: [PATCH v4 05/10] KVM: MIPS: Rename virtualization {en,dis}abling APIs
 to match common KVM
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Farrah Chen <farrah.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"

Rename MIPS's trampoline hooks for virtualization enabling to match the
recently renamed arch hooks.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/mips/include/asm/kvm_host.h | 4 ++--
 arch/mips/kvm/mips.c             | 4 ++--
 arch/mips/kvm/vz.c               | 8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 6743a57c1ab4..f7222eb594ea 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -728,8 +728,8 @@ struct kvm_mips_callbacks {
 	int (*handle_fpe)(struct kvm_vcpu *vcpu);
 	int (*handle_msa_disabled)(struct kvm_vcpu *vcpu);
 	int (*handle_guest_exit)(struct kvm_vcpu *vcpu);
-	int (*hardware_enable)(void);
-	void (*hardware_disable)(void);
+	int (*enable_virtualization_cpu)(void);
+	void (*disable_virtualization_cpu)(void);
 	int (*check_extension)(struct kvm *kvm, long ext);
 	int (*vcpu_init)(struct kvm_vcpu *vcpu);
 	void (*vcpu_uninit)(struct kvm_vcpu *vcpu);
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 52e1f275351e..60b43ea85c12 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -127,12 +127,12 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 
 int kvm_arch_enable_virtualization_cpu(void)
 {
-	return kvm_mips_callbacks->hardware_enable();
+	return kvm_mips_callbacks->enable_virtualization_cpu();
 }
 
 void kvm_arch_disable_virtualization_cpu(void)
 {
-	kvm_mips_callbacks->hardware_disable();
+	kvm_mips_callbacks->disable_virtualization_cpu();
 }
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index 99d5a71e4300..ccab4d76b126 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -2869,7 +2869,7 @@ static unsigned int kvm_vz_resize_guest_vtlb(unsigned int size)
 	return ret + 1;
 }
 
-static int kvm_vz_hardware_enable(void)
+static int kvm_vz_enable_virtualization_cpu(void)
 {
 	unsigned int mmu_size, guest_mmu_size, ftlb_size;
 	u64 guest_cvmctl, cvmvmconfig;
@@ -2983,7 +2983,7 @@ static int kvm_vz_hardware_enable(void)
 	return 0;
 }
 
-static void kvm_vz_hardware_disable(void)
+static void kvm_vz_disable_virtualization_cpu(void)
 {
 	u64 cvmvmconfig;
 	unsigned int mmu_size;
@@ -3280,8 +3280,8 @@ static struct kvm_mips_callbacks kvm_vz_callbacks = {
 	.handle_msa_disabled = kvm_trap_vz_handle_msa_disabled,
 	.handle_guest_exit = kvm_trap_vz_handle_guest_exit,
 
-	.hardware_enable = kvm_vz_hardware_enable,
-	.hardware_disable = kvm_vz_hardware_disable,
+	.enable_virtualization_cpu = kvm_vz_enable_virtualization_cpu,
+	.disable_virtualization_cpu = kvm_vz_disable_virtualization_cpu,
 	.check_extension = kvm_vz_check_extension,
 	.vcpu_init = kvm_vz_vcpu_init,
 	.vcpu_uninit = kvm_vz_vcpu_uninit,
-- 
2.46.0.469.g59c65b2a67-goog


