Return-Path: <kvm+bounces-27881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 662FE98FAE5
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 01:45:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 897021C21F78
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 23:45:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D72E1D26E3;
	Thu,  3 Oct 2024 23:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M1ELjmWc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231231D1F4F
	for <kvm@vger.kernel.org>; Thu,  3 Oct 2024 23:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727999032; cv=none; b=aT3O8sW8D+iknDKEdyr6ns2/8Z5LB5EUeLtymtpX7a7t7xz9Tmm2zzDtBUyokYyfLisDzJYCVRXA+OQ9YasyJYW4zcnyYRVj1Ers64aYTE8ZXKZkqPQ6pQFALn+tV4m0wqG7/vn4cMCsmDCsrF/nhybD+w3lXpQEypvd5A12YCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727999032; c=relaxed/simple;
	bh=gX+o8XXJM50peceuHqmdcWWs3o/nxzR2aXn9TDSmehw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g8w0VAW3qacQdMefeUlLtiSB56uOdkyYPGesy2mrgCbOCqPVsbbKyHzrg60TJVZ9v3b2tQC6+n4wstUQ17Vx/DbPoQjbQ0cxG/sOpGaZFBwiUIHkcydrF5ZDUJwoj4D0DYonSm0T957ECRCz0F3no121Yd/1MZrbGwR6dYK6rLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M1ELjmWc; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e2590f5bc1so23167077b3.2
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2024 16:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727999030; x=1728603830; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gk2ltXEs/6rBeGKFiAGP6lmYm5gM6rfWM1zcP38vcLM=;
        b=M1ELjmWcrKGIHv6dlzNem/9r8nXGOLAHgM6FCnhWkfQo6U8luc77hyyf7n3pNvXMgc
         MWcjAI1hOU7VnsMdJp8rqgkytznwecYJg4jhLqYwGffMoW7z4yGU+uF2tGe6Mm6YRcMQ
         A1xSzSFywBifDCISZ3soisQTn3GeJlp08WXOBM3rdClJvm8r5NZKYOIBiUYMVLb5CH91
         5rIC3ZYdSssn16JPfz9wievtg+pfYIOz5pdw7UxMLu2RXrkSO6upVeczRtTkzbEnmfDP
         Ik3oRmrXnpiI3/HbKJooZN/asg1LqEFGtF5YuO79jtSasQet5r29/0Vyd+IsGnTds+Iz
         lf4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727999030; x=1728603830;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gk2ltXEs/6rBeGKFiAGP6lmYm5gM6rfWM1zcP38vcLM=;
        b=QBecvl5m5JZa8FvF7hYbp9KVVoSEC9iRz472Om8oMXRHFWwovipcM6QrVf700ldNLq
         AC+WRQIfmt1wD8VGHv8Iz7JfQTDrVlesdrcGseHta4NayolkUtpyjKDkCzJCb5mpNt4o
         8ZUF1I0an/BzSKruY2YHxTQIu9sXc5l7E2qOIJT/YE/3s+jFfwN5FmEhhjtGQCR6mrPI
         zXwmOxXYKF8B70tkriax4ZJQBZG5FP4VrOdpfMxhCvgo8bMLeUHCtP7VebX1dbRQeRxZ
         m1TsqInwPhkdrJtvIoKChLeWOrU5H/R0VW2YHtYgXdUNPvu2XoOuEM/QrA8Homjx2hnN
         AhQw==
X-Gm-Message-State: AOJu0Yz4P/GqjXxMLcet9fBTGEveUQqRCpKY9lA+3PAIrDrMp1Opj02h
	wUl+zuRuYwUvYDqlpBoVtKwDhB/ku5GpTVg5HJ76zJrCa5ZP7eOEQVFe4tb6jmh7hymifQ0A+E7
	GvA==
X-Google-Smtp-Source: AGHT+IH1mRDr/LJ1+AGep1hMpxSXBKZFso+u/Vj+xIKpeT7s6R8CKDq8kLEN6DeZJyO2znluPHRoe2V7e78=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:361d:0:b0:e22:5bdf:39c1 with SMTP id
 3f1490d57ef6-e289394938fmr459276.10.1727999030121; Thu, 03 Oct 2024 16:43:50
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  3 Oct 2024 16:43:31 -0700
In-Reply-To: <20241003234337.273364-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241003234337.273364-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241003234337.273364-6-seanjc@google.com>
Subject: [PATCH 05/11] KVM: selftests: Configure XCR0 to max supported value
 by default
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"

To play nice with compilers generating AVX instructions, set CR4.OSXSAVE
and configure XCR0 by default when creating selftests vCPUs.  Some distros
have switched gcc to '-march=x86-64-v3' by default, and while it's hard to
find a CPU which doesn't support AVX today, many KVM selftests fail with

  ==== Test Assertion Failure ====
    lib/x86_64/processor.c:570: Unhandled exception in guest
    pid=72747 tid=72747 errno=4 - Interrupted system call
    Unhandled exception '0x6' at guest RIP '0x4104f7'

due to selftests not enabling AVX by default for the guest.  The failure
is easy to reproduce elsewhere with:

   $ make clean && CFLAGS='-march=x86-64-v3' make -j && ./x86_64/kvm_pv_test

E.g. gcc-13 with -march=x86-64-v3 compiles this chunk from selftests'
kvm_fixup_exception():

        regs->rip = regs->r11;
        regs->r9 = regs->vector;
        regs->r10 = regs->error_code;

into this monstronsity (which is clever, but oof):

  405313:       c4 e1 f9 6e c8          vmovq  %rax,%xmm1
  405318:       48 89 68 08             mov    %rbp,0x8(%rax)
  40531c:       48 89 e8                mov    %rbp,%rax
  40531f:       c4 c3 f1 22 c4 01       vpinsrq $0x1,%r12,%xmm1,%xmm0
  405325:       49 89 6d 38             mov    %rbp,0x38(%r13)
  405329:       c5 fa 7f 45 00          vmovdqu %xmm0,0x0(%rbp)

Alternatively, KVM selftests could explicitly restrict the compiler to
-march=x86-64-v2, but odds are very good that punting on AVX enabling will
simply result in tests that "need" AVX doing their own thing, e.g. there
are already three or so additional cleanups that can be done on top.

Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Closes: https://lore.kernel.org/all/20240920154422.2890096-1-vkuznets@redhat.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  5 ++++
 .../selftests/kvm/lib/x86_64/processor.c      | 24 +++++++++++++++++++
 .../selftests/kvm/x86_64/xcr0_cpuid_test.c    |  6 ++---
 3 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index e247f99e0473..645200e95f89 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1049,6 +1049,11 @@ static inline void vcpu_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu_ioctl(vcpu, KVM_GET_CPUID2, vcpu->cpuid);
 }
 
+static inline void vcpu_get_cpuid(struct kvm_vcpu *vcpu)
+{
+	vcpu_ioctl(vcpu, KVM_GET_CPUID2, vcpu->cpuid);
+}
+
 void vcpu_set_cpuid_property(struct kvm_vcpu *vcpu,
 			     struct kvm_x86_cpu_property property,
 			     uint32_t value);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 974bcd2df6d7..636b29ba8985 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -506,6 +506,8 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 
 	sregs.cr0 = X86_CR0_PE | X86_CR0_NE | X86_CR0_PG;
 	sregs.cr4 |= X86_CR4_PAE | X86_CR4_OSFXSR;
+	if (kvm_cpu_has(X86_FEATURE_XSAVE))
+		sregs.cr4 |= X86_CR4_OSXSAVE;
 	sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
 
 	kvm_seg_set_unusable(&sregs.ldt);
@@ -519,6 +521,20 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	vcpu_sregs_set(vcpu, &sregs);
 }
 
+static void vcpu_init_xcrs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+{
+	struct kvm_xcrs xcrs = {
+		.nr_xcrs = 1,
+		.xcrs[0].xcr = 0,
+		.xcrs[0].value = kvm_cpu_supported_xcr0(),
+	};
+
+	if (!kvm_cpu_has(X86_FEATURE_XSAVE))
+		return;
+
+	vcpu_xcrs_set(vcpu, &xcrs);
+}
+
 static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
 			  int dpl, unsigned short selector)
 {
@@ -675,6 +691,7 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 	vcpu = __vm_vcpu_add(vm, vcpu_id);
 	vcpu_init_cpuid(vcpu, kvm_get_supported_cpuid());
 	vcpu_init_sregs(vm, vcpu);
+	vcpu_init_xcrs(vm, vcpu);
 
 	/* Setup guest general purpose registers */
 	vcpu_regs_get(vcpu, &regs);
@@ -686,6 +703,13 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 	mp_state.mp_state = 0;
 	vcpu_mp_state_set(vcpu, &mp_state);
 
+	/*
+	 * Refresh CPUID after setting SREGS and XCR0, so that KVM's "runtime"
+	 * updates to guest CPUID, e.g. for OSXSAVE and XSAVE state size, are
+	 * reflected into selftests' vCPU CPUID cache, i.e. so that the cache
+	 * is consistent with vCPU state.
+	 */
+	vcpu_get_cpuid(vcpu);
 	return vcpu;
 }
 
diff --git a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
index 95ce192d0753..a4aecdc77da5 100644
--- a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
@@ -48,16 +48,16 @@ do {									\
 
 static void guest_code(void)
 {
-	uint64_t xcr0_reset;
+	uint64_t initial_xcr0;
 	uint64_t supported_xcr0;
 	int i, vector;
 
 	set_cr4(get_cr4() | X86_CR4_OSXSAVE);
 
-	xcr0_reset = xgetbv(0);
+	initial_xcr0 = xgetbv(0);
 	supported_xcr0 = this_cpu_supported_xcr0();
 
-	GUEST_ASSERT(xcr0_reset == XFEATURE_MASK_FP);
+	GUEST_ASSERT(initial_xcr0 == supported_xcr0);
 
 	/* Check AVX */
 	ASSERT_XFEATURE_DEPENDENCIES(supported_xcr0,
-- 
2.47.0.rc0.187.ge670bccf7e-goog


