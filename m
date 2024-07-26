Return-Path: <kvm+bounces-22385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D587393DB88
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:00:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 88CDD1F21A51
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:00:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE81A17BB27;
	Fri, 26 Jul 2024 23:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p0leuphP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DD4176250
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038005; cv=none; b=JRidLz9JobEhWGUpJVPE7N8z+NZoSnHeo1GEzlLRI+LHUkfyzlfIkMgYVCEEnPyfH9cMNwn+0vTanGZrP9Bt3lCNjsOd5ykOdvLymCuLuANXlnbjAy+bL9kcbIWf2SKZd6ADMZwt+pZsTe3RaUQyB+ebEX2cql/1o4sHQZoGAAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038005; c=relaxed/simple;
	bh=Zgha2xAFcY7KucmW/flV9fGS6Q5hSOiwMmi0KjWZqtM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JwDpoF3pq7hzC3KU336OTa5HJA5yY/nT1F4VlRDRpbhpcXEv6pwaJ7uPCbcH7QgKn/F4GD47Ar05GAM/yUmS3pFqV9rPPJkhbCUsX5w4d0Lgbj6SjW6RiFQBQBRX8Wm+GQnCLAoRQ3I1Fwcelh/6QlP96M7lYG9LOMOqRiyqsP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p0leuphP; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70d2ab42082so1262553b3a.0
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038003; x=1722642803; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nY4qfmLxHYNbNwSwtMKIrsjqMbHvtDgV5qSHM3zuSO0=;
        b=p0leuphPA1pHQ6LdzTUqg+gAuwHJENizil4IUlrkbKDvfMcouEqM0DaIxVuSB1mU00
         5jZgvi3wdfIgV2zV7jRg1+cB06FTewjQIGbNzhu+UpfuyJkMZqXwLFs8SJesVmHhfsuQ
         1FQhM+J/PJDV9WXVgXlT84OXCVfdYgLIFpW9EWPq+zvhS6GYKtBXSz5HKWMr1RuK4lIa
         6eOzLcZ2Z5f93S0fUWHL8wdvWYtsIXWAaXFJiuQ7zupAvtIVkyU5lHPkSaaN0iBgbYTv
         dw3ujCnR6xY+b4vmetGSmY1M8Y3nYsnG3S9aXezG7XP4uTKAVZL7sQOzbyw9QmDOrQuC
         qHyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038003; x=1722642803;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nY4qfmLxHYNbNwSwtMKIrsjqMbHvtDgV5qSHM3zuSO0=;
        b=pzpFtQZ+fxYH9y2dzzWbWqVrno9Wx1WryrbLcNcuZuMahZcfnJ7+aO/0Zu3DsGFUMd
         +iKL3jRpwlFPw/1tar8yBQD+aAbY6lw4boszR3ImF3nHDRlwTAQIOTGj2sb31ywvps9j
         Isk/Qe8a/cTZwHaMfMAtYs8U62wlhORxe65MTHx/QdrQnn/cPxnGwfJOY31q/4GHnbu8
         y6X4NF86SEJSlh/Tcs03zo2qxFAoHppTOSh1J+MYRPhXYD7+7K+WVAhJ0Tn9Sf3Xh0TR
         zLKAIAVYqg5kq3rKV6+yygMFohOALUkoeRqKMJ3o1UrcTQ9rPxLhqj90ama0XoqendHb
         Juig==
X-Gm-Message-State: AOJu0YxMzM07raxJDqcwPYkvI9ZdBuYXDyuF+V7Xr1hNZzD1l0tuiNef
	nnvWJTqz0D/5N3h6r/NPwnoXdSSdhkGGFXCko/V2Us6AAzH5otwgHZuZ0z8LrWX9ihGmnoPr4JL
	ENA==
X-Google-Smtp-Source: AGHT+IH3GR1gDSsaIiyxz/X29dplakZOpWNN6FppUWgXRDWsCZD6dFhJbJXFL2hO7f6rIpjA8QVwSQZzxjA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6f1c:b0:70d:138a:bee8 with SMTP id
 d2e1a72fcca58-70ece533146mr8919b3a.0.1722038002674; Fri, 26 Jul 2024 16:53:22
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:31 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-23-seanjc@google.com>
Subject: [PATCH v12 22/84] KVM: nVMX: Drop pointless msr_bitmap_map field from
 struct nested_vmx
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Remove vcpu_vmx.msr_bitmap_map and instead use an on-stack structure in
the one function that uses the map, nested_vmx_prepare_msr_bitmap().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 8 ++++----
 arch/x86/kvm/vmx/vmx.h    | 2 --
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a34b49ea64b5..372d005e09e7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -621,7 +621,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	int msr;
 	unsigned long *msr_bitmap_l1;
 	unsigned long *msr_bitmap_l0 = vmx->nested.vmcs02.msr_bitmap;
-	struct kvm_host_map *map = &vmx->nested.msr_bitmap_map;
+	struct kvm_host_map msr_bitmap_map;
 
 	/* Nothing to do if the MSR bitmap is not in use.  */
 	if (!cpu_has_vmx_msr_bitmap() ||
@@ -644,10 +644,10 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 			return true;
 	}
 
-	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->msr_bitmap), map))
+	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->msr_bitmap), &msr_bitmap_map))
 		return false;
 
-	msr_bitmap_l1 = (unsigned long *)map->hva;
+	msr_bitmap_l1 = (unsigned long *)msr_bitmap_map.hva;
 
 	/*
 	 * To keep the control flow simple, pay eight 8-byte writes (sixteen
@@ -711,7 +711,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
 
-	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
+	kvm_vcpu_unmap(vcpu, &msr_bitmap_map, false);
 
 	vmx->nested.force_msr_bitmap_recalc = false;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 42498fa63abb..889c6c42ee27 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -204,8 +204,6 @@ struct nested_vmx {
 	struct kvm_host_map virtual_apic_map;
 	struct kvm_host_map pi_desc_map;
 
-	struct kvm_host_map msr_bitmap_map;
-
 	struct pi_desc *pi_desc;
 	bool pi_pending;
 	u16 posted_intr_nv;
-- 
2.46.0.rc1.232.g9752f9e123-goog


