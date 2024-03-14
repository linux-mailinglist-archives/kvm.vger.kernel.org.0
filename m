Return-Path: <kvm+bounces-11858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E922687C663
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 00:33:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 187951C2121D
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 23:33:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A54B376F9;
	Thu, 14 Mar 2024 23:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vzbz7azS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C36D2942C
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 23:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710458818; cv=none; b=DS6zBlPHhV2U/Evl3om//Yzey02CVjKbBb1YIF8hQ2mcBry1JGGLHQD5DmHRwuUr+D8M49b08y3oobS0aqbT4NXJuDQNeZYuRS4VWd77mLaPIzXYXg8PfafFfjr2Ay2plXm7Jx7lnE6leiV+tbW6VjAcLg0r8cx3s6sBvg1hss4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710458818; c=relaxed/simple;
	bh=o49cGQaFGV2lqCGlt41zmvUnsUxiYRWJVSbJwfYRFlM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V0t9lFs6AFXfPkwdMf680fYFr3rZtISm65jrlN91EFyt6q2z9gwcOnPqqVLjBCjhlVjZcrO8hMwuUqxA9lgwComyG4OOGUcf2rYCnoIuFh+ohBjajbvu1E3h9ZOyHeLheAeSRmlRv8L6Gg774zC0twkz4Rql5ZJjCAfNKldx8FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vzbz7azS; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1dda642853eso15348295ad.2
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 16:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710458816; x=1711063616; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pTVZRdXyCVTnuQGgLheWcCsaF7bim4F1PK5VbaXQ+t0=;
        b=Vzbz7azSdWAECY3/f9td/ZB9C0I5KLZtFHpys5R31pciTd4riUy0It6QEH8PqFYETl
         toaGEnvc322SQ8bVrLu3UvYSJJCL957+e2uXNkduoqUt9PhDwFeBQpjezCHrQvKkYPcM
         rst7FdqOvxa7yW1VboqJZkXWySV4bBTphasFJQmfKk5vB+ZAFqV35POtdwwBevJH7Enj
         VvrhGYRHZJ9E+jodxVCq++/bIl74NfLQ4zRNrQhJSHcJFifBnVK5ryb0dC+BRxoqs+fj
         aa30aVd82R0W+i7HC2lt1Kjh2O9eTuQ4tTX+zrI1WSnB7WgqwDaCVTpXf/D0rMBj0G5H
         sv1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710458816; x=1711063616;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pTVZRdXyCVTnuQGgLheWcCsaF7bim4F1PK5VbaXQ+t0=;
        b=qVHSdmLFy5P4eNSphlPRIqB2aScb2t2B54+VRTMEFlLTa/0dQRrbNalgV+hIkonoNR
         0KjVGMSGKWaume8VF7TVg9ZgH4rczOzqXrg01JhQv3JPfp5eafVWRwmLZzaYWGNq1FXW
         a748mNqTFa4lIk7tDvQZ2EprxWEYrbxjQqB0zSIHA67EOuoHpq9v7ErHHGn2ko0HmbeI
         27XIjdCYk01PFG7tkuDDcFzMTTend6VdvfNtKMdvvZCToSjTe5rli3w2ZPQzMMXPGsjO
         5m6P8B38bJ6lYREndUPj7x4HdHqKCFWoM6QTsHwBcXgMADjXaYC0WzIS8WnUjWw/Ojz/
         PTGA==
X-Forwarded-Encrypted: i=1; AJvYcCXqw7a6b28qTPigQuY2LCbx7TqQBPLk3Xua8J9VyF3nB3GPMYvKMDpH4fq1SObXlf6i1XVjcYS0AsjqD2rlbWunYS6i
X-Gm-Message-State: AOJu0Yz9CrZYRkHZl654qa8lwp9VNdd4/eOWDkEw+ldJn27fSY+OeU9g
	fAno457+rt8ygj9qIIy8064tl+SJpMtSjuQ2UmkIMpC2c7n+pvhGydzjGv8ivkiqxAKoviSbTko
	U/w==
X-Google-Smtp-Source: AGHT+IH7S37OXvdlnB5BIBxBCKNBsO+Ay6MTHPEIT19iC3iZ0sD1f7oPcvL0HSDVvR5Ys+olPa2yoMgb6k0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4ca:b0:1dd:a324:30b5 with SMTP id
 o10-20020a170902d4ca00b001dda32430b5mr9294plg.9.1710458816466; Thu, 14 Mar
 2024 16:26:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 16:26:28 -0700
In-Reply-To: <20240314232637.2538648-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314232637.2538648-10-seanjc@google.com>
Subject: [PATCH 09/18] KVM: selftests: Rename x86's vcpu_setup() to vcpu_init_sregs()
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

Rename vcpu_setup() to be more descriptive and precise, there is a whole
lot of "setup" that is done for a vCPU that isn't in said helper.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 3640d3290f0a..d6bfe96a6a77 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -555,7 +555,7 @@ void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu)
 	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
 }
 
-static void vcpu_setup(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 {
 	struct kvm_sregs sregs;
 
@@ -716,7 +716,7 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 
 	vcpu = __vm_vcpu_add(vm, vcpu_id);
 	vcpu_init_cpuid(vcpu, kvm_get_supported_cpuid());
-	vcpu_setup(vm, vcpu);
+	vcpu_init_sregs(vm, vcpu);
 
 	/* Setup guest general purpose registers */
 	vcpu_regs_get(vcpu, &regs);
-- 
2.44.0.291.gc1ea87d7ee-goog


