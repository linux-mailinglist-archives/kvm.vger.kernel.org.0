Return-Path: <kvm+bounces-28528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3146F9990EE
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:42:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF8181F21D99
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:42:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E08FB2071ED;
	Thu, 10 Oct 2024 18:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TkN0pgzM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EF1206E80
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584804; cv=none; b=q+9pjwjWbTcwWh6OWSaYnN4eSSn2zdb758IcSZj1wML8RpBOsCRqCR3GpgWmBAVDNPmMr1QjwTiTzs6e3tcMhP35fynoxXlfb0wChnW7BofEFj8vEjdG6ZypUge/L3mpsZQB8JeD8xg3jQSJ8/nfG0HwJZmhW9DJI2/jE4M2cZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584804; c=relaxed/simple;
	bh=ux21RVGWhz9JRdIoM/Dq30UYNcfog+x0iowAjNZ/4XU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K3by/HccWZXHpEmxm7z5YiXAeyixVUIKYGUfjcBEtxMBOWeugOVXdALNWVPDXNF8P5LroKCPyYIooVUzQ5RWZrlLrAIFN0IuMvzpf7EfQjagu9So7fsAn0GA08c4SlbwHDhfdUx4WIzzSZBXaDIgusAe896TE+2858y6Ip9wAjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TkN0pgzM; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e31e5d1739so25048267b3.1
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584801; x=1729189601; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W6Zzl9AmyqedpEIwNpLXiwPcmrnHw6ZPa/9pyFpLcZ0=;
        b=TkN0pgzMcbtXcehOT3G5lQY8rkiUBvkBcxM6gFvQBdXPdSHR+Bdw7nrzPweN+yVkaN
         uTb/gUN2mQ2Vg1tKjaOAVMtsZSWMylN5yuKIXvVBtG2VEPvienlnVdJRXRAHwEu0kkyK
         9Ofhzp0jp3Ck9eoskAcxSdzp6PspHPEsug9npp829r5JsnbCN9OEKkWW2XlQrAVK1qDz
         HR2epCDdOmr5wBKAPBrQzUwIntkDyltheKd/ormx9zR0906kw75/PioCQuOEzlpeTg8X
         zE3iJHzZ2VWDViZQG9tcL7+JnaOlpG6gu6+8GDdZFhQ//6LMtrKiMkaqGEETsqG0K2s3
         zyjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584801; x=1729189601;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=W6Zzl9AmyqedpEIwNpLXiwPcmrnHw6ZPa/9pyFpLcZ0=;
        b=rKmH+WI03ZDqrGQvioh4yPejyCY5Ofb6Vkg/HRxiCewlw33zyvuWfJ7ZV/F/P56JJH
         ZLI1G6NURNkrZEEMzaKekomGpWN+O4i1N9r9vDAIQWJrLMC3LKJ/VUFsR3+DACL7in5Z
         BPfh3bUrddKScvIc43hVTu31AyzPs6C4rJTndLmtp7+9HBEIoj7w03KpP7EO9PSQlmYd
         QNCf9S8xdvtktyfOcoyq6mxTJp4Qlo/Ug7wJtH8W5yy5Mn/41//C+kt8q2fKwjJVWTy4
         IvBtlke62D8GwRoL/4pb4re6/pN0QCArldHf1nCDyQkaIeWrg2GToxeSLtxAy2FolkxF
         8zHQ==
X-Gm-Message-State: AOJu0YxtDXh/OfVkExEUc2BK3HpPIOhfKsfrLa0M5jHunJXvakRAo2PE
	/WDYxvJchN7ihoTjkVDn/RSONuZYS8ZfWPOXSoDdd5W0jHSOTwz1sw4UogKAaPoRdQfwtMu6YgH
	GFQ==
X-Google-Smtp-Source: AGHT+IGFUTZueI+Si3awRWj8jA+YGlhXMEzUcm/2nm7iA7dHF8070ZlvI1MSF0nUJUhFBhXPPz9v/uVg5Fg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2f08:b0:6e2:2c72:3abb with SMTP id
 00721157ae682-6e3224db667mr816567b3.7.1728584801239; Thu, 10 Oct 2024
 11:26:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:53 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-52-seanjc@google.com>
Subject: [PATCH v13 51/85] KVM: VMX: Use __kvm_faultin_page() to get APIC
 access page/pfn
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
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Use __kvm_faultin_page() get the APIC access page so that KVM can
precisely release the refcounted page, i.e. to remove yet another user
of kvm_pfn_to_refcounted_page().  While the path isn't handling a guest
page fault, the semantics are effectively the same; KVM just happens to
be mapping the pfn into a VMCS field instead of a secondary MMU.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 851be0820e04..44cc25dfebba 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6790,8 +6790,10 @@ void vmx_set_apic_access_page_addr(struct kvm_vcpu *=
vcpu)
 	struct kvm *kvm =3D vcpu->kvm;
 	struct kvm_memslots *slots =3D kvm_memslots(kvm);
 	struct kvm_memory_slot *slot;
+	struct page *refcounted_page;
 	unsigned long mmu_seq;
 	kvm_pfn_t pfn;
+	bool writable;
=20
 	/* Defer reload until vmcs01 is the current VMCS. */
 	if (is_guest_mode(vcpu)) {
@@ -6827,7 +6829,7 @@ void vmx_set_apic_access_page_addr(struct kvm_vcpu *v=
cpu)
 	 * controls the APIC-access page memslot, and only deletes the memslot
 	 * if APICv is permanently inhibited, i.e. the memslot won't reappear.
 	 */
-	pfn =3D gfn_to_pfn_memslot(slot, gfn);
+	pfn =3D __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, &writable, &refcounted_p=
age);
 	if (is_error_noslot_pfn(pfn))
 		return;
=20
@@ -6838,10 +6840,13 @@ void vmx_set_apic_access_page_addr(struct kvm_vcpu =
*vcpu)
 		vmcs_write64(APIC_ACCESS_ADDR, pfn_to_hpa(pfn));
=20
 	/*
-	 * Do not pin apic access page in memory, the MMU notifier
-	 * will call us again if it is migrated or swapped out.
+	 * Do not pin the APIC access page in memory so that it can be freely
+	 * migrated, the MMU notifier will call us again if it is migrated or
+	 * swapped out.  KVM backs the memslot with anonymous memory, the pfn
+	 * should always point at a refcounted page (if the pfn is valid).
 	 */
-	kvm_release_pfn_clean(pfn);
+	if (!WARN_ON_ONCE(!refcounted_page))
+		kvm_release_page_clean(refcounted_page);
=20
 	/*
 	 * No need for a manual TLB flush at this point, KVM has already done a
--=20
2.47.0.rc1.288.g06298d1525-goog


