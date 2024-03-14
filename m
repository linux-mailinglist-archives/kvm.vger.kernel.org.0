Return-Path: <kvm+bounces-11865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAC0A87C671
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 00:36:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7BEEBB235F2
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 23:36:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10ABF58ADE;
	Thu, 14 Mar 2024 23:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BjvkzChM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEF556445
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 23:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710458832; cv=none; b=kliVDNdhlSyGZ4w1Ojk5cpcMT/BB02MufI9ZhtecG7+6kjxeq0+lvJHuAv1yCF54k2OKYUgeFkitOaH+9NC5XoaK2/rcJU28wHCx7TLnl4qHARAVKMkP8Fl482F3HGEf3LV8Dl7gRcOuLzJw4IHlClekVQhKbhHlD1O9Yz5Ic8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710458832; c=relaxed/simple;
	bh=S54X56NK5jNme/p0rG61PtklInYwE0kYzZmEDcMwUuY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ie9VPoHW0DAUN5Uc3oqTnNUtYzTh/OAScG6s0OorF2awcR/i4skmELJO55UoKGczTumedHIvjAjUNMtyrOmyKHPN97P/sGnievcNLUv6lfwcHEkmPbhHfo83+NsfAT5ZEbyH7hd3/lHI3qom1ZkZfyAx21va47gbYlzwEx6Mwck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BjvkzChM; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e6b3bff094so1779343b3a.3
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 16:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710458829; x=1711063629; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pXWQ17U6pSp+5gsIGCX5tAdB4RHln2KoUo+gy6g2jBc=;
        b=BjvkzChMXehMoQ5nogNfNe70MZx5JionWKesWPc85kHEmXg/Lt6TuEbDzeuZ4UHEKp
         R+fGyoQClDg+bc4jU7r94mQDrF0c6T0w62atV4zddfrDiOYr9s1447n2FaekrOoDnevp
         PWQbVTonyzR1cESr8OG6iGCc08KBKokI/2eO9ROcHHs7jg8S+BdxioGZSFza0EO36di/
         +ItfcjSZJArHMiYRM7+n4VYTjPc4zVhq03knf6jJdBm+wiwjW2UukT8xHzqqX1QHxxLR
         AzVYTBWQNcOFiP6P51fxyq1R2YSwrQn5Yg8vFZesMlucoZQE0rFWIiLqbFN8en8ECU55
         OmnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710458829; x=1711063629;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pXWQ17U6pSp+5gsIGCX5tAdB4RHln2KoUo+gy6g2jBc=;
        b=W6QTUI1XVFPuL/6Xz1ErvbEEQnuUuuZHEb6XRaBjolV8Q+rJnh2ExEo9Dt6tGzHC92
         xfwKg6XHqhcfxRnRpwtCBcagu6iXhiAY6CLkFG3tbFe2ry6EO/7/UIlB7Q4mgrVxRhnD
         c3LCI11rHT1OP3LIYsRwJ5PRwG3IMte8CK2zKnGcmOM5gBX6CwrxWNGecvRx1tRaHHRC
         XuVDOEMaO0x6qchPRqyoi3aKGXIEOCpWdqEUpqbqcCHALSC6EjYMA6yxqMQOVnnUut9o
         AuOEFRh+IJbCnKnsfumrV5BaKlA+N3RwEJzNtFe5dx/WYIBnW45tscyOg49LJs889iP8
         6lig==
X-Forwarded-Encrypted: i=1; AJvYcCVCVj3pMjFKu5tye9bVWD8Xfd4sFW7CEUnM/0rp3WvCu+YFJAGRNcUHwWKyx/Gvm+vfkME9Ds5hOg6nRWHQhEdCnb1e
X-Gm-Message-State: AOJu0Yy85y3eSiDyqmyOae/8QvM8NWrSBhTkcdH+sfGddnodZvN0LHzG
	ks0IH2lhuZXdgxctiQ4qMyz1VBFSxG7J7tqPo+p34URyYIp815W1r1MTCt9TPDNY3Tt5JS+8dW+
	xWg==
X-Google-Smtp-Source: AGHT+IGB88xDhOmLkYM8uO8zQxI10w4y/bqJWwoieXGYn8llJcu4nyCnZH6T1De8EEh7OBqPBXy+MKkQjwI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9298:b0:6e6:c3bc:721e with SMTP id
 jw24-20020a056a00929800b006e6c3bc721emr129688pfb.1.1710458829531; Thu, 14 Mar
 2024 16:27:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 16:26:35 -0700
In-Reply-To: <20240314232637.2538648-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314232637.2538648-17-seanjc@google.com>
Subject: [PATCH 16/18] KVM: selftests: Add macro for TSS selector, rename up
 code/data macros
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

Add a proper #define for the TSS selector instead of open coding 0x18 and
hoping future developers don't use that selector for something else.

Opportunistically rename the code and data selector macros to shorten the
names, align the naming with the kernel's scheme, and capture that they
are *kernel* segments.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/lib/x86_64/processor.c       | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 03b9387a1d2e..67235013f6f9 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -15,8 +15,9 @@
 #define NUM_INTERRUPTS 256
 #endif
 
-#define DEFAULT_CODE_SELECTOR 0x8
-#define DEFAULT_DATA_SELECTOR 0x10
+#define KERNEL_CS	0x8
+#define KERNEL_DS	0x10
+#define KERNEL_TSS	0x18
 
 #define MAX_NR_CPUID_ENTRIES 100
 
@@ -547,11 +548,11 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
 
 	kvm_seg_set_unusable(&sregs.ldt);
-	kvm_seg_set_kernel_code_64bit(vm, DEFAULT_CODE_SELECTOR, &sregs.cs);
-	kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.ds);
-	kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.es);
-	kvm_seg_set_kernel_data_64bit(NULL, DEFAULT_DATA_SELECTOR, &sregs.gs);
-	kvm_setup_tss_64bit(vm, &sregs.tr, 0x18);
+	kvm_seg_set_kernel_code_64bit(vm, KERNEL_CS, &sregs.cs);
+	kvm_seg_set_kernel_data_64bit(vm, KERNEL_DS, &sregs.ds);
+	kvm_seg_set_kernel_data_64bit(vm, KERNEL_DS, &sregs.es);
+	kvm_seg_set_kernel_data_64bit(NULL, KERNEL_DS, &sregs.gs);
+	kvm_setup_tss_64bit(vm, &sregs.tr, KERNEL_TSS);
 
 	sregs.cr3 = vm->pgd;
 	vcpu_sregs_set(vcpu, &sregs);
@@ -620,8 +621,7 @@ static void vm_init_descriptor_tables(struct kvm_vm *vm)
 
 	/* Handlers have the same address in both address spaces.*/
 	for (i = 0; i < NUM_INTERRUPTS; i++)
-		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0,
-			DEFAULT_CODE_SELECTOR);
+		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0, KERNEL_CS);
 
 	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
 }
-- 
2.44.0.291.gc1ea87d7ee-goog


