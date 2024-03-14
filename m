Return-Path: <kvm+bounces-11863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FCF487C66D
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 00:35:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 755211F20F0F
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 23:35:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85EEE55C2E;
	Thu, 14 Mar 2024 23:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="igkw4nuE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10D5548EE
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 23:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710458828; cv=none; b=TXgkEmudM9OBcbeXzpSqmuRJBy43n3FN5ORz31/XIssntVA4zBJLvpdmZNcV3h4X7TthU0FpcshsFo1z0zLSbpJ763Jf4PMCeq++KHSnKzkZEkFeMv4yySLLFOiBMARPqVLWp3E24zNtEnsAfYcuGOOSDjyJl6T2si7EPcd1ha0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710458828; c=relaxed/simple;
	bh=PqA36j9IQANN0GTDJLwJ7hsqDDDFB01NLUyYfZ1HmNs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j2zN1dswANUjg1qi9/aciqX9q3LXwAgM9gyk8g4siiAZC5dbtp2+D2uPu87EeNWvdL93hiaXKrqUZFqy6dJPbrtG3FsXCwN32zq7xXGSiH2u57NF9oerbuv7RhTLM8V1sBMv8KQjCcSStZsF8jW27u8/KRASbqdPCUKfjFlTn4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=igkw4nuE; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-607838c0800so27942157b3.1
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 16:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710458826; x=1711063626; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ugMj11YssaThk53XXo2XJuyaCSbRC3vd2rkkLMOH5EU=;
        b=igkw4nuEnDrK94g5ybsx14WxA7MYzRuWXqcSTJQZCOVmkKBWmfJ2yp410joBh2Gly3
         eh24ueNeqRQcOTdifcERYMIREfvDIPKNjmo+Ei6RnDp7N2pQkQtOiQ4NzS4IkkorsbGk
         5ncMTetg11+ZqyOKKeunqIIEGXCcaHigRPF3PRTRzEgWXLsvMoNzcnjTHAKpoImV9+B7
         8MliT02Z8mWTc7LwRkgGvZ2HjrL6WIjeNHXSaY/Ai0HuQKmqANa+pouxG4VDW+6LVzRG
         +tY2upUPFZUBOkW5IGpbLeKMuOxzFRxa9LyoVI3eTdqz1ojdSfwkgtTGw8zfEb5WNFtm
         qiqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710458826; x=1711063626;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ugMj11YssaThk53XXo2XJuyaCSbRC3vd2rkkLMOH5EU=;
        b=U1kzFcawEf6M9neJXDa3XCkKvUI+2pfMvyDoHA4kRvsRDghDFV544pa7ywebXT1H4b
         AryD2JIbMpcaHm2WvW+maLAOaQ0uN5K/jzupqmeUnaSzdDlcj5mYArHQdG0akwUcAtmn
         qpzroF0Dw/eRWuHpiq5m/lUJK8gZfGqYnIYo4YXyjAEbDMHpAzuJAgRTY6ReX8gIktCa
         TffHhB3HJqIfCg4wJCn4/5XWhP1lsa9zp7zQz4Y7slz98qH64z9Y6INFWDYsaAPVlu3p
         rqchPX1pw5cd82O3UhAV8hdwtvEOJyQ92TYkrc1F58lOmI1vYcR1R5jC4JlDzP9IYicw
         FnnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWTWGshqFZSJjn0vL2mGqEbAGzrBb2XD+6GfCamo6UBQkg/ZDtmQMSM+vqRtunl9uFAdJjdaKkijdrED0sPNFHaw0kj
X-Gm-Message-State: AOJu0YxNXeUNCyFUOVx09f2ZtGddOarMoECv39jYGXLDiK6Qm+8whNmu
	RBf8f5YbFROAC4meudwynjzNsjlTPBzKcLXhxqV9drQaMEMyg7nq/HxzAAefb1tXgA4XIUMvvrp
	cAQ==
X-Google-Smtp-Source: AGHT+IE5/WiqwibvrYrQwLJotN6HL86HBYfSMTMXmq7TGIVKVjhGwMzToGYfAqrqDOL2A5xHSs/EAtgRugA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:bc0a:0:b0:60a:13b8:6a5c with SMTP id
 a10-20020a81bc0a000000b0060a13b86a5cmr1757713ywi.0.1710458825983; Thu, 14 Mar
 2024 16:27:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 16:26:33 -0700
In-Reply-To: <20240314232637.2538648-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314232637.2538648-15-seanjc@google.com>
Subject: [PATCH 14/18] KVM: selftests: Fold x86's descriptor tables helpers
 into vcpu_init_sregs()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that the per-VM, on-demand allocation logic in kvm_setup_gdt() and
vcpu_init_descriptor_tables() is gone, fold them into vcpu_init_sregs().

Note, both kvm_setup_gdt() and vcpu_init_descriptor_tables() configured the
GDT, which is why it looks like kvm_setup_gdt() disappears.

Opportunistically delete the pointless zeroing of the IDT limit (it was
being unconditionally overwritten by vcpu_init_descriptor_tables()).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/lib/x86_64/processor.c      | 32 ++++---------------
 1 file changed, 6 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 561c0aa93608..5cf845975f66 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -516,12 +516,6 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 	return vm_untag_gpa(vm, PTE_GET_PA(*pte)) | (gva & ~HUGEPAGE_MASK(level));
 }
 
-static void kvm_setup_gdt(struct kvm_vm *vm, struct kvm_dtable *dt)
-{
-	dt->base = vm->arch.gdt;
-	dt->limit = getpagesize() - 1;
-}
-
 static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
 				int selector)
 {
@@ -537,32 +531,19 @@ static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
 	kvm_seg_fill_gdt_64bit(vm, segp);
 }
 
-static void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu)
+static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 {
-	struct kvm_vm *vm = vcpu->vm;
 	struct kvm_sregs sregs;
 
+	TEST_ASSERT_EQ(vm->mode, VM_MODE_PXXV48_4K);
+
+	/* Set mode specific system register values. */
 	vcpu_sregs_get(vcpu, &sregs);
+
 	sregs.idt.base = vm->arch.idt;
 	sregs.idt.limit = NUM_INTERRUPTS * sizeof(struct idt_entry) - 1;
 	sregs.gdt.base = vm->arch.gdt;
 	sregs.gdt.limit = getpagesize() - 1;
-	kvm_seg_set_kernel_data_64bit(NULL, DEFAULT_DATA_SELECTOR, &sregs.gs);
-	vcpu_sregs_set(vcpu, &sregs);
-}
-
-static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
-{
-	struct kvm_sregs sregs;
-
-	TEST_ASSERT_EQ(vm->mode, VM_MODE_PXXV48_4K);
-
-	/* Set mode specific system register values. */
-	vcpu_sregs_get(vcpu, &sregs);
-
-	sregs.idt.limit = 0;
-
-	kvm_setup_gdt(vm, &sregs.gdt);
 
 	sregs.cr0 = X86_CR0_PE | X86_CR0_NE | X86_CR0_PG;
 	sregs.cr4 |= X86_CR4_PAE | X86_CR4_OSFXSR;
@@ -572,12 +553,11 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	kvm_seg_set_kernel_code_64bit(vm, DEFAULT_CODE_SELECTOR, &sregs.cs);
 	kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.ds);
 	kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.es);
+	kvm_seg_set_kernel_data_64bit(NULL, DEFAULT_DATA_SELECTOR, &sregs.gs);
 	kvm_setup_tss_64bit(vm, &sregs.tr, 0x18);
 
 	sregs.cr3 = vm->pgd;
 	vcpu_sregs_set(vcpu, &sregs);
-
-	vcpu_init_descriptor_tables(vcpu);
 }
 
 static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
-- 
2.44.0.291.gc1ea87d7ee-goog


