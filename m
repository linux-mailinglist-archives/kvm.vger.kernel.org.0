Return-Path: <kvm+bounces-11862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 678E387C66A
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 00:35:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 70DC5B22B47
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 23:35:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89E2454909;
	Thu, 14 Mar 2024 23:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j8Nsw8Xg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EF0535D6
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 23:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710458826; cv=none; b=UL9eQ60P931SBy//o8YIN0kpQhYurmaTkrPb4URDMwvt9BXGtd7ZDJCTZjBfjpnazR4NWR1rAbkX4YFYVn00a9Lw1viu8wTPHEYCFcLYfFdPz3IdLxy70cL29LIQabEhnEB+ZP4a41kd6fHFrYBO0SDQF1VWW3GCKzf9W395gw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710458826; c=relaxed/simple;
	bh=rKle47E4nZDDqOFkGZ++A7yOb91DTrGSOJRrZ2XcVV8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kTZoHxMJCV4bKn5F/GHI9jNzrv8RDPm+/TU3Kb8m0hXwpWsmVxRahQiPTDzpsmSxO87NHGF8YNJbn157GsR8NtyEXDRQmzhbLJ6H4IFR2wZezamEOedkg8sgwuWV/MA/H4snn++TElBtdhIlUW0gOhJA1OwdL4LFFq3WqP9W+iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j8Nsw8Xg; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcc15b03287so1936370276.3
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 16:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710458824; x=1711063624; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WoFzTDbs1SGZWiz/BWvPtXOQrZCNvORTtjaiRTPj8cA=;
        b=j8Nsw8XgYz98IxPIuOucqiB8hDxfbOlXh8KQgi6thRV9O9bUYiEA2WmEzvak8CGZui
         xGgUYBiXgbOcOdVu5NKbvRN6cDwrHT7bIg+sy+1ruv3m1BOw3vj2FRmTI9sw3Vb0JhEL
         sbeJXN3ES50gyuAzuPyEYrv2V5eMHny01AqxK/VmsZDmxbV/sEeT2b9IocmHL5Mgv+Ex
         p70N0os1uXF67VStutvoZkufK0Wqnui+8mdLly7GV6TJMPrE4KqQqAQ7VDGEBTstYlPu
         VY760/mmXBReSWQc9Cu2RcHy93cxgydrQA3EihlWddwNkZwyET/oR3j4egCOp8MPcjOg
         7FBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710458824; x=1711063624;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WoFzTDbs1SGZWiz/BWvPtXOQrZCNvORTtjaiRTPj8cA=;
        b=dK2VeDJygC+00aWWUm5KFoUZyP8Bps//4g0h+lK1y4ps2k4G1IfpUOeM/nKz2fofUM
         DeS45AA3/awNkk9n2noG3h4mMxOQxlwccDG2EMO6xV3D3306UeR1LO/bfFuBfmaqB80U
         oqZTpOz3TgOIS6sI1/98oVGarTc53P6aejQjx04qm/i+ob+KXXzWkQhcmCkE8oMD+yh4
         aMSwNyPSV2DMYnUztM05dUPwkjZASTOJg2cIgM8K1RxWhcJLwK+HeCVL5ecmzCqmRyQP
         xK/3c8gj4ECAdzqZP+GHLCb0wGV5t8Ae0BusNWGJaNCotuBeT1cZF6KAySMAEh/o7xWr
         SjeA==
X-Forwarded-Encrypted: i=1; AJvYcCVvvbs7Ccz34VcpdBfhBI3XdGyik7urbhUFag/XulzX15KFDh1XaR7HsGzGB7s6AhzuHt0hqCYLjAS8wFgyupzl5ts2
X-Gm-Message-State: AOJu0YzXTU4j5CEnYxfg3iWcQce45/hv7zdUKeKpPy5PghC6QPcsBvdI
	0AYDRUPIjssQ2BvHLFbuKm1jXxm23UinuZyWKBtvzu4pwZmbkdDrMT7RDYQzouTCs4lS7IAFeA5
	O5Q==
X-Google-Smtp-Source: AGHT+IHcMDu3QEHM/t3996zb5RxqsBHPTHwvDMlP8Tv3VDnGeL/s0WR7fo9rdGQ7MgRJw43RolfNSTpIRT8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2009:b0:dcd:c091:e86 with SMTP id
 dh9-20020a056902200900b00dcdc0910e86mr147737ybb.13.1710458824203; Thu, 14 Mar
 2024 16:27:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 16:26:32 -0700
In-Reply-To: <20240314232637.2538648-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314232637.2538648-14-seanjc@google.com>
Subject: [PATCH 13/18] KVM: selftests: Drop superfluous switch() on vm->mode
 in vcpu_init_sregs()
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

Replace the switch statement on vm->mode in x86's vcpu_init_sregs()'s with
a simple assert that the VM has a 48-bit virtual address space.  A switch
statement is both overkill and misleading, as the existing code incorrectly
implies that VMs with LA57 would need different to configuration for the
LDT, TSS, and flat segments.  In all likelihood, the only difference that
would be needed for selftests is CR4.LA57 itself.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/lib/x86_64/processor.c      | 25 ++++++++-----------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 8547833ffa26..561c0aa93608 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -555,6 +555,8 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 {
 	struct kvm_sregs sregs;
 
+	TEST_ASSERT_EQ(vm->mode, VM_MODE_PXXV48_4K);
+
 	/* Set mode specific system register values. */
 	vcpu_sregs_get(vcpu, &sregs);
 
@@ -562,22 +564,15 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 
 	kvm_setup_gdt(vm, &sregs.gdt);
 
-	switch (vm->mode) {
-	case VM_MODE_PXXV48_4K:
-		sregs.cr0 = X86_CR0_PE | X86_CR0_NE | X86_CR0_PG;
-		sregs.cr4 |= X86_CR4_PAE | X86_CR4_OSFXSR;
-		sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
+	sregs.cr0 = X86_CR0_PE | X86_CR0_NE | X86_CR0_PG;
+	sregs.cr4 |= X86_CR4_PAE | X86_CR4_OSFXSR;
+	sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
 
-		kvm_seg_set_unusable(&sregs.ldt);
-		kvm_seg_set_kernel_code_64bit(vm, DEFAULT_CODE_SELECTOR, &sregs.cs);
-		kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.ds);
-		kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.es);
-		kvm_setup_tss_64bit(vm, &sregs.tr, 0x18);
-		break;
-
-	default:
-		TEST_FAIL("Unknown guest mode, mode: 0x%x", vm->mode);
-	}
+	kvm_seg_set_unusable(&sregs.ldt);
+	kvm_seg_set_kernel_code_64bit(vm, DEFAULT_CODE_SELECTOR, &sregs.cs);
+	kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.ds);
+	kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.es);
+	kvm_setup_tss_64bit(vm, &sregs.tr, 0x18);
 
 	sregs.cr3 = vm->pgd;
 	vcpu_sregs_set(vcpu, &sregs);
-- 
2.44.0.291.gc1ea87d7ee-goog


