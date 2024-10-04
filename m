Return-Path: <kvm+bounces-27894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A95DB98FF36
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 11:02:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A66D1C212F9
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 09:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B000B1459E0;
	Fri,  4 Oct 2024 09:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QIaYgd9Z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2FF136345
	for <kvm@vger.kernel.org>; Fri,  4 Oct 2024 09:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728032524; cv=none; b=kzSqYmx7joqrZItvQWrPngRebica10oGWrV4BOfPk0S3yJIcEOyeeJzAAhF4SI1q0N2Si4Lgxpisfp1qtc29C6SysJq/J7HTaqp/8xLKuqt/6xmDRv5CIwMvg4bv9e7MyM1gJif4mKBuwV8mfzP8fH1xPNFM1EyT7JXUHRX2QXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728032524; c=relaxed/simple;
	bh=K6RjSowYDV8x8lw781oPwNYuDXn1WNFaXKuNUq8iXHk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=IzD4ANxm3x87U+btBqYHeiyOwsD4jHvlWleNjqt0KsQy4BUyBvLtcibpI4X0k3cxP/vHtuVBAGGukq9AZnzznrl9BtHk3s9eHkwKlgfJxqeFyt0NqV8E7nBOwgVRLzY1XttiguOLqAWvZJU9B6nnfe0NmnQFO5PRwZl39JO7Y/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QIaYgd9Z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728032521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U+3eo4iK9z7/n8Wmk//3sJ9t56oZ2LuK5IcguLduS5A=;
	b=QIaYgd9Z4xRM7A3W1ke7ir070cRL//5YIXYxlxAzjtg7LttSW7tTwTHi8PIFnEp2itS+yk
	+Qn5xPiyHnqrddFxMzgVdtUZKc+QCxTAM0vzLQ/rYwwu3SRoIyQe/qCGESimVcvrbiovsW
	iuWbrEKLsd4UAuN7+hSGGAGLDUAga/s=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-i49XxmJMM3OYhnIwIS0wHQ-1; Fri, 04 Oct 2024 05:01:59 -0400
X-MC-Unique: i49XxmJMM3OYhnIwIS0wHQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-37cd2044558so977806f8f.1
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2024 02:01:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728032519; x=1728637319;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U+3eo4iK9z7/n8Wmk//3sJ9t56oZ2LuK5IcguLduS5A=;
        b=YhJMVa2EcbvYtacDI2I9iL7xoivWOjkdYgXbnhj8rhci6VaAzOrMuQnLJiDf3kKOu5
         ZmDohWWF+ec6XqnQnoe+3jGloG+JV33onKA2OA+ULLHDOZW1NFa6EGqpMafEL4wknsQl
         6oeaM9VpFEM6ohBboSwSzzQAetMBEfmR5yfzL27F1YEl91jkFkpZKH8+8dXfgZWHLoNJ
         CioFgNubr0dr0iSL3MKc+sYpRGyxzaSJaKu1lmcNxnABwOoOywrCH//Xk1Y8962N/oiH
         paOqwyOlRwKl08bAD/Sb1Nbx/g5fp8rHO0aqcslSnLyd+urufk88GfgB941uz7dXtGJc
         utYA==
X-Gm-Message-State: AOJu0Yz3VeF4WmQ0tMYbLl88qAAO9uwtV3oAHbdJirm5pGOZncR7a6+K
	nr3zGM/Pfz2Gkd1RgstOfCqcKRkxogLzB8GQv/0iJIxLkhaUjGaRuXTqlPr7EwOLIi4zTVM+Ckr
	L5J0Kfpje8xklPLcZ+nBcsrKO75h37bnXFhbSZxkEfSfZlmZoKw==
X-Received: by 2002:a05:600c:3b85:b0:42c:b843:792b with SMTP id 5b1f17b1804b1-42f85a70062mr14437645e9.2.1728032518612;
        Fri, 04 Oct 2024 02:01:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFYRonOhr++6qnkM35HJn1KTHsg8KzsNVLzBVT4yx85Do+FJx0SSL2WjQVeFN2IB7BmwcXR7w==
X-Received: by 2002:a05:600c:3b85:b0:42c:b843:792b with SMTP id 5b1f17b1804b1-42f85a70062mr14437415e9.2.1728032518178;
        Fri, 04 Oct 2024 02:01:58 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d082d116asm2813849f8f.90.2024.10.04.02.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2024 02:01:57 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/11] KVM: selftests: Configure XCR0 to max supported
 value by default
In-Reply-To: <20241003234337.273364-6-seanjc@google.com>
References: <20241003234337.273364-1-seanjc@google.com>
 <20241003234337.273364-6-seanjc@google.com>
Date: Fri, 04 Oct 2024 11:01:56 +0200
Message-ID: <87v7y8i6m3.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> To play nice with compilers generating AVX instructions, set CR4.OSXSAVE
> and configure XCR0 by default when creating selftests vCPUs.  Some distros
> have switched gcc to '-march=x86-64-v3' by default, and while it's hard to
> find a CPU which doesn't support AVX today, many KVM selftests fail with
>
>   ==== Test Assertion Failure ====
>     lib/x86_64/processor.c:570: Unhandled exception in guest
>     pid=72747 tid=72747 errno=4 - Interrupted system call
>     Unhandled exception '0x6' at guest RIP '0x4104f7'
>
> due to selftests not enabling AVX by default for the guest.  The failure
> is easy to reproduce elsewhere with:
>
>    $ make clean && CFLAGS='-march=x86-64-v3' make -j && ./x86_64/kvm_pv_test
>
> E.g. gcc-13 with -march=x86-64-v3 compiles this chunk from selftests'
> kvm_fixup_exception():
>
>         regs->rip = regs->r11;
>         regs->r9 = regs->vector;
>         regs->r10 = regs->error_code;
>
> into this monstronsity (which is clever, but oof):
>
>   405313:       c4 e1 f9 6e c8          vmovq  %rax,%xmm1
>   405318:       48 89 68 08             mov    %rbp,0x8(%rax)
>   40531c:       48 89 e8                mov    %rbp,%rax
>   40531f:       c4 c3 f1 22 c4 01       vpinsrq $0x1,%r12,%xmm1,%xmm0
>   405325:       49 89 6d 38             mov    %rbp,0x38(%r13)
>   405329:       c5 fa 7f 45 00          vmovdqu %xmm0,0x0(%rbp)
>
> Alternatively, KVM selftests could explicitly restrict the compiler to
> -march=x86-64-v2, but odds are very good that punting on AVX enabling will
> simply result in tests that "need" AVX doing their own thing, e.g. there
> are already three or so additional cleanups that can be done on top.

Ideally, we may still want to precisely pin the set of instructions
which are used to generete guest code in selftests as the environment
where this code runs is defined by us and it may not match the host. I
can easily imaging future CPU features leading to similar issues in case
they require explicit enablement. To achive this, we can probably
separate guest code from each test into its own compilation unit.

>
> Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Closes: https://lore.kernel.org/all/20240920154422.2890096-1-vkuznets@redhat.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/include/x86_64/processor.h  |  5 ++++
>  .../selftests/kvm/lib/x86_64/processor.c      | 24 +++++++++++++++++++
>  .../selftests/kvm/x86_64/xcr0_cpuid_test.c    |  6 ++---
>  3 files changed, 32 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index e247f99e0473..645200e95f89 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -1049,6 +1049,11 @@ static inline void vcpu_set_cpuid(struct kvm_vcpu *vcpu)
>  	vcpu_ioctl(vcpu, KVM_GET_CPUID2, vcpu->cpuid);
>  }
>  
> +static inline void vcpu_get_cpuid(struct kvm_vcpu *vcpu)
> +{
> +	vcpu_ioctl(vcpu, KVM_GET_CPUID2, vcpu->cpuid);
> +}
> +
>  void vcpu_set_cpuid_property(struct kvm_vcpu *vcpu,
>  			     struct kvm_x86_cpu_property property,
>  			     uint32_t value);
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 974bcd2df6d7..636b29ba8985 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -506,6 +506,8 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
>  
>  	sregs.cr0 = X86_CR0_PE | X86_CR0_NE | X86_CR0_PG;
>  	sregs.cr4 |= X86_CR4_PAE | X86_CR4_OSFXSR;
> +	if (kvm_cpu_has(X86_FEATURE_XSAVE))
> +		sregs.cr4 |= X86_CR4_OSXSAVE;
>  	sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
>  
>  	kvm_seg_set_unusable(&sregs.ldt);
> @@ -519,6 +521,20 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
>  	vcpu_sregs_set(vcpu, &sregs);
>  }
>  
> +static void vcpu_init_xcrs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_xcrs xcrs = {
> +		.nr_xcrs = 1,
> +		.xcrs[0].xcr = 0,
> +		.xcrs[0].value = kvm_cpu_supported_xcr0(),
> +	};
> +
> +	if (!kvm_cpu_has(X86_FEATURE_XSAVE))
> +		return;
> +
> +	vcpu_xcrs_set(vcpu, &xcrs);
> +}
> +
>  static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
>  			  int dpl, unsigned short selector)
>  {
> @@ -675,6 +691,7 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
>  	vcpu = __vm_vcpu_add(vm, vcpu_id);
>  	vcpu_init_cpuid(vcpu, kvm_get_supported_cpuid());
>  	vcpu_init_sregs(vm, vcpu);
> +	vcpu_init_xcrs(vm, vcpu);
>  
>  	/* Setup guest general purpose registers */
>  	vcpu_regs_get(vcpu, &regs);
> @@ -686,6 +703,13 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
>  	mp_state.mp_state = 0;
>  	vcpu_mp_state_set(vcpu, &mp_state);
>  
> +	/*
> +	 * Refresh CPUID after setting SREGS and XCR0, so that KVM's "runtime"
> +	 * updates to guest CPUID, e.g. for OSXSAVE and XSAVE state size, are
> +	 * reflected into selftests' vCPU CPUID cache, i.e. so that the cache
> +	 * is consistent with vCPU state.
> +	 */
> +	vcpu_get_cpuid(vcpu);
>  	return vcpu;
>  }
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
> index 95ce192d0753..a4aecdc77da5 100644
> --- a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
> @@ -48,16 +48,16 @@ do {									\
>  
>  static void guest_code(void)
>  {
> -	uint64_t xcr0_reset;
> +	uint64_t initial_xcr0;
>  	uint64_t supported_xcr0;
>  	int i, vector;
>  
>  	set_cr4(get_cr4() | X86_CR4_OSXSAVE);
>  
> -	xcr0_reset = xgetbv(0);
> +	initial_xcr0 = xgetbv(0);
>  	supported_xcr0 = this_cpu_supported_xcr0();
>  
> -	GUEST_ASSERT(xcr0_reset == XFEATURE_MASK_FP);
> +	GUEST_ASSERT(initial_xcr0 == supported_xcr0);
>  
>  	/* Check AVX */
>  	ASSERT_XFEATURE_DEPENDENCIES(supported_xcr0,

Reviewed-and-tested-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Thanks!

-- 
Vitaly


