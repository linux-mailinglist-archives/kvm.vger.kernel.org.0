Return-Path: <kvm+bounces-9455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60F188607D1
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 01:45:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DA269B23636
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 00:44:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DFD511CAE;
	Fri, 23 Feb 2024 00:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vFzrhBBh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126F310A2A
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 00:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708648995; cv=none; b=CI6EnF+wL/oxB4A6nqsWk+2mdORa/J/SZlU6RdzQTre6WYvO2/cwO5xovIER0y/Q4URbm2soqTI34f/hvX3GhciWsxr6G/sEVZOe+JB9YHzbtTzFb58QCN3xbd8alZQOevSH+mvIt7zbkqc+hHIgB13hlewE32MQ4m1CCaTMLxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708648995; c=relaxed/simple;
	bh=EB42Jl+Du5RKKydkq6dHRGJLTaF7jM5r9fOKhUyQo/g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NCODju+FnLP9ax1IQQXUswkCUuZoUv87wnqieudD5ZTFw5Rln3kJwogrbnrW0L826IT1S6o3p06eQ7X/CrQjHjVvKxg1TAjj7saLxX217SBsDhC01jz9WCKo3ZLu6hZXsAEiyTx2nolepu7ap+Q8hLzzh0WJzHcHg2eip2moeDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vFzrhBBh; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5dcab65d604so242259a12.3
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708648993; x=1709253793; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VHEHpfFT3fq5ZUYVbA7KHyxL3TWLbo6jAAmdD67Ha7M=;
        b=vFzrhBBhTezHo0kb7LOE2J0LcyWbanHqcemwq0hIMfhF1i3CfkDnDhX3shykLXn1YL
         DI79oknmC3xBVYnxnxHJ2EZdaUW3ZwScpkpW2+J4n3Atum54OsDq+1ujx2ecDLYVVICE
         qJDo4FW0QtJAwXGAGRQF4MXIR8ch3VbngenolC0nTDueFFjuMH6hAceIVKypxK385hHZ
         YBe0BJdG4TGcF2MCeVtznBHzhacE0wRv2Uf0Yba8CtScjaxd0j3qQPl4MmST/Wok8EON
         UeYeW+Y9N4lPSlrC09eGE9y419d9svPPc4gTPkIi/ghf7uJkkAipSKBO+mT0RzdanXgA
         cGKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708648993; x=1709253793;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VHEHpfFT3fq5ZUYVbA7KHyxL3TWLbo6jAAmdD67Ha7M=;
        b=lCi0TCQMJm2BRS+WKL54ipoKrCyZA1JJM1uLHvygIVRAET0uG0bSJLQbts4ZFLLhO0
         S6EVxd47HTsO/McWFzpG4q73PnkRdkj0LCcU7dO7EULg6UUqpNUMWHpiXu2rHG7Yc3Hw
         6MY3PMa/8FoszfIvXMh03OHe0Pt2yu0FTv+F0pl2qzQgXASsymkJ2jbKYSxfk7XTMooW
         AeWddnYcIsxMp5sLG0dTsfQLc5dEafpWQTrLyw0Ucl+Xsvg/pV5hCL0vIaVjvuy4SI/P
         0YmY6zdYrn2HA1B6TSvZAZQUtuAAENsEIUSvRIsrBot+52CVxiP2k9xPeNbhCnNLBM/Z
         MOoA==
X-Gm-Message-State: AOJu0YwzU5/lTIJMDC7Ers2uruapteL9mhJcM0HZ2QaagUpbF0K8hTlI
	24CHabQ83Cl/igTLs+1y5XGleLbeyko0cJ9uCSu+vuwdpqkhQ9bqM9u3gyXVgKZkhbxi6l/OIbC
	hoQ==
X-Google-Smtp-Source: AGHT+IHOzHa69AmDUbZ+OQC4gdWd8eKNcA+4/Rl+KkHknT13uIbfHPqOmsB/BAUR4nyvpq5uPcFzKjJ/Uj0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6d14:0:b0:5cd:9ea4:c99 with SMTP id
 bf20-20020a656d14000000b005cd9ea40c99mr900pgb.6.1708648993312; Thu, 22 Feb
 2024 16:43:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 Feb 2024 16:42:53 -0800
In-Reply-To: <20240223004258.3104051-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223004258.3104051-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223004258.3104051-7-seanjc@google.com>
Subject: [PATCH v9 06/11] KVM: selftests: Explicitly ucall pool from shared memory
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Carlos Bilbao <carlos.bilbao@amd.com>, 
	Peter Gonda <pgonda@google.com>, Itaru Kitayama <itaru.kitayama@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

From: Peter Gonda <pgonda@google.com>

Allocate the common ucall pool using vm_vaddr_alloc_shared() so that the
ucall structures will be placed in shared (unencrypted) memory for VMs
with support for protected (encrypted) memory, e.g. x86's SEV.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerly Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Tested-by: Carlos Bilbao <carlos.bilbao@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
[sean: massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/ucall_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 816a3fa109bf..f5af65a41c29 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -29,7 +29,8 @@ void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 	vm_vaddr_t vaddr;
 	int i;
 
-	vaddr = __vm_vaddr_alloc(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR, MEM_REGION_DATA);
+	vaddr = vm_vaddr_alloc_shared(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR,
+				      MEM_REGION_DATA);
 	hdr = (struct ucall_header *)addr_gva2hva(vm, vaddr);
 	memset(hdr, 0, sizeof(*hdr));
 
-- 
2.44.0.rc0.258.g7320e95886-goog


