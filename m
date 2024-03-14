Return-Path: <kvm+bounces-11860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 142B987C667
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 00:34:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 370511C214C5
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 23:34:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BE1052F81;
	Thu, 14 Mar 2024 23:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b/TOSVnV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E25D4F890
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 23:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710458822; cv=none; b=sSzOySkQlSfWoh10nmWbAh7sjhe21YSMo4+6IuuuRZp9G1b6bj6N2GmygmhUNPeNMbUcakJVjS77DC81diRNvfGYcaeRa4fDXbBN11RtA5wnfNP5EBoc4WzoYB+HrehntzkX4wcSxko0CKI+UJ2MQKxY+G8FJdcoHvtzpajQ/Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710458822; c=relaxed/simple;
	bh=AqTYa7MHtMGSvPyMPSqX9mCVN3CkOd0u5L3U2bv1DqM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Xo2guBwpgIkDKS7Fec9bYKmROZpiAbzpVNSWiAZUaLiF2/1ezZCdH8IEuP2TNrPO0ABG9EIcRwfd5z7hhYJc2u53bvvSB+WGK5nfD5lY1isXqj1glbUmK1n5YChPefhwnRVpUapr0iBnpjKLhmHWE5aGmWefPWD1amDhUmu7SA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b/TOSVnV; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbf618042daso2233783276.0
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 16:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710458820; x=1711063620; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=j/j/mb3JtyoyPDhLhkSAITq95aQFSMlle8Dlg66amAk=;
        b=b/TOSVnVnpVC4rqCCy8xH/0ZGckMu9PxCPpI8uDHGF/0A7MjJQWj0n0gW2xB8yTIcF
         ufYT6JhmdccVkQNF+lTR/m6zqg+gKebs93eE/lE5wpgn3ZNOjPJNQkg1JmubxcZFG6gl
         IaxPIU5rL4TyqaToixLk1hLBebnam87pLwcAvdY2XUC7xCCgdS+kIsBjZRtyDFgWrrdg
         bhuCvsrdDZVGqRYi/EPlS4k4B5q8XS7hCf0cPFaxkW9mRLLiF6uY8BUfdDXUbUWy5Bo5
         QQQpjA3tEdQZ3iWfnoORwr5/TRv/kZScDsl3q6d2317eJtb+J9WmXZZV4smHXrIkOcR9
         WrAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710458820; x=1711063620;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j/j/mb3JtyoyPDhLhkSAITq95aQFSMlle8Dlg66amAk=;
        b=O0Y80dyzuyAxOBmLRTlEoFngiZudIhTwnCGT2cWlkqu8GphBQmIC5iO79d4PPSML0h
         JJrVHf8iRxGd6quv2VF/odhSSWuq2bPri6JDODZuT6dhGykJxr6xUW+0aXzXXoaiAh+2
         jHzCs4BmalWPKAuhs8esviHRJPmrz7/5IUdcq6zXDpglqWgULSXqh8vR/i0m9VPaWdBA
         WNc19n2A8Su/OEI8cZgQ245/s/ezZAzGfcPC+1kqMP2ZknPDihepyLD1LmJ0pOl+vdFK
         0tJluNhemwsgKuWPElqpQJpdqxFcVg7X4N6ZXMP1iIVjn9T6Oj15daNYWGKg1Gl63EDv
         ZaMg==
X-Forwarded-Encrypted: i=1; AJvYcCV/2uA8BeCj8qMt0Ghs1dQRnPTBPF3FYlldAcOgHwygWpuW4dF46kX7jeNA21/uj9GnMyS0gaEnhHw1enAdAvkMc68s
X-Gm-Message-State: AOJu0YxCltcMu2ydppp9dkyNH+sa6+gXRSQdDkjNtKlzi5OlZryjll6p
	UeJTQaWv99EXVO2FskP9c8/gD0/OOCzlh56ImNfn1pjyOzsoyCZ/sGjmdryVeCLkDhh5yZEzoQF
	Nmw==
X-Google-Smtp-Source: AGHT+IEgFldUzAavXJ42YJM5+Q6BHlgBbuisK5vIFOhA5ma+0WFPVDRLg0oxmN/Zi21+BucUmJd5KHT651s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:72e:b0:dcc:94b7:a7a3 with SMTP id
 l14-20020a056902072e00b00dcc94b7a7a3mr183110ybt.12.1710458820208; Thu, 14 Mar
 2024 16:27:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 16:26:30 -0700
In-Reply-To: <20240314232637.2538648-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314232637.2538648-12-seanjc@google.com>
Subject: [PATCH 11/18] KVM: selftests: Map x86's exception_handlers at VM
 creation, not vCPU setup
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

Map x86's exception handlers at VM creation, not vCPU setup, as the
mapping is per-VM, i.e. doesn't need to be (re)done for every vCPU.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 5813d93b2e7c..f4046029f168 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -552,7 +552,6 @@ static void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu)
 	sregs.gdt.limit = getpagesize() - 1;
 	kvm_seg_set_kernel_data_64bit(NULL, DEFAULT_DATA_SELECTOR, &sregs.gs);
 	vcpu_sregs_set(vcpu, &sregs);
-	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
 }
 
 static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
@@ -651,6 +650,8 @@ static void vm_init_descriptor_tables(struct kvm_vm *vm)
 	for (i = 0; i < NUM_INTERRUPTS; i++)
 		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0,
 			DEFAULT_CODE_SELECTOR);
+
+	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
 }
 
 void vm_install_exception_handler(struct kvm_vm *vm, int vector,
-- 
2.44.0.291.gc1ea87d7ee-goog


