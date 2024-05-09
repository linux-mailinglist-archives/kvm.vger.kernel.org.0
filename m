Return-Path: <kvm+bounces-17128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED7AC8C1334
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 18:43:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5EFBCB209BA
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 16:43:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3D1BD50F;
	Thu,  9 May 2024 16:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U8xs/M5U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FB2C8E2
	for <kvm@vger.kernel.org>; Thu,  9 May 2024 16:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715272972; cv=none; b=AOEwTpqul/S33N1wukqHsb3t8oQ3h/6PwK9KkCGz7sBNFINgp1EqtywagXM4S9U0ckN3maAIf4o15Q8T71bCfkZRjcdOyezx1SU8orKDdP2s7SV0gffCyJtAhSDBw6HXqWt4hpoVkQZEOGjI4SM7sxQOBCGbXFBpfTqc33oq1mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715272972; c=relaxed/simple;
	bh=XpVz8Ta9vWl+Q2TCA6cP9Pv0KSquiHUbOO++9BBK5eY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cuWvVbA9EUIsEcQ3o4RAO/+5NdIUmRf/zGAon1U9OQhqW+8wxxAqsTr5LCIMsr+KFof6d1es1y9vq9dKCcCRZcyp+UYgaCBePtcr9G3huEYlq1CN5nxYUCB2TKCZcYsCbdnilefe+7FzVwpMtgChytEoTn1wGX4IeLcagvq1etI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U8xs/M5U; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-de468af2b73so1824303276.0
        for <kvm@vger.kernel.org>; Thu, 09 May 2024 09:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715272970; x=1715877770; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5rHnFr6vKDzMq4yMlIUQc7iGULXQ2sByeq4kGS0fY80=;
        b=U8xs/M5UOhF0IAz4dECu4CHxTzCQQEXvEtcBch6nqpLYqzRNmV7/VEeij3puKeZyi6
         kiX8/QxQYU2GE2u8Fn4MlR6XlR5kp+jLnLtsyWLP31ULD4CF59Y+bYkBRJzKDneKM07d
         i0YzrgYAQAhvVYGYOfvZASZa0tLiJWOlb9D8ibVMryfG1by4Q2IOPHSWfLmEbdpRsNGa
         cjcS/5yrVodliZDxe+dfZed19Ye/XF1UaQNm4OGoDhSUwTUVeGAN5NoK7iDkRlnYS8tX
         YdPssja61T7rje8bDDajOKmcnqMQ3svdMeltrJDR7bbRK174D8aOAT7YNxfj/+Ux1J0d
         LSWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715272970; x=1715877770;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5rHnFr6vKDzMq4yMlIUQc7iGULXQ2sByeq4kGS0fY80=;
        b=dAGR2FpF1djiooYp87mFuH4JPipcJdPcinAvJSMetj7zw9H2q4Lu4/8cUnmNFFTW0T
         ioPaJUjS0PGE0VMT29udZKJnVGfBwnNFU97nEGeZYa9ojlXsXIUYX5g2dnsI55cdfkXE
         PJLXwgMbHBc/4SkdyxuH3jSI6MPtk+bVx3sP7sNwpD135L++olsR9sqzoudX+DUThtAB
         brcCIY+IeM9ldzq6mhzrJ/1qW2U1/C3VmzokvsWymwO2EELSlXWaSfEJZIG5TkXzp7Qx
         ym4Bg9mw0yys7dMbNlQc0qEydZ5mWlzW4Z8znfnSoAbkTmT2dFvP1aLwfhMiu8U1ilVv
         lY4g==
X-Forwarded-Encrypted: i=1; AJvYcCVkVuQ16vQtpR23kz3RoD7CFWtrbePcx+6suqiBWinLG5a73TZvuvTmA7VQQnEvdIQPQYjPzUovDI1eqAwQB8+8c0Nv
X-Gm-Message-State: AOJu0YxC1mvxHv+dN+n4LKw1WuHgktFjJN5XKaMvkUwmOiZatgwbcxAo
	IX4o5AUILT7sP4trCGSOk10loiwdpFBYynzpt/bqYQB/Yyo1LYqw15j71U6XdTUoRyC6yA1ekCG
	M4w==
X-Google-Smtp-Source: AGHT+IEdpCuX8CupAV8q5WtcM5afueuGqMsE0YRtrcJLU0gvOO6gn2vj45vQL4z2rB9c8Zm44vWaDKurH3A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:6988:0:b0:de5:1b63:9ee5 with SMTP id
 3f1490d57ef6-dee4f30f5a0mr13111276.7.1715272970152; Thu, 09 May 2024 09:42:50
 -0700 (PDT)
Date: Thu, 9 May 2024 09:42:48 -0700
In-Reply-To: <20240509090146.146153-1-leitao@debian.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240509090146.146153-1-leitao@debian.org>
Message-ID: <Zjz9CLAIxRXlWe0F@google.com>
Subject: Re: [PATCH] KVM: Addressing a possible race in kvm_vcpu_on_spin:
From: Sean Christopherson <seanjc@google.com>
To: Breno Leitao <leitao@debian.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, rbc@meta.com, paulmck@kernel.org, 
	"open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, May 09, 2024, Breno Leitao wrote:
> There are two workflow paths that access the same address
> simultaneously, creating a potential data race in kvm_vcpu_on_spin. This
> occurs when one workflow reads kvm->last_boosted_vcpu while another
> parallel path writes to it.
> 
> KCSAN produces the following output when enabled.
> 
> 	BUG: KCSAN: data-race in kvm_vcpu_on_spin [kvm] / kvm_vcpu_on_spin [kvm]
> 
> 	write to 0xffffc90025a92344 of 4 bytes by task 4340 on cpu 16:
> 	kvm_vcpu_on_spin (arch/x86/kvm/../../../virt/kvm/kvm_main.c:4112) kvm
> 	handle_pause (arch/x86/kvm/vmx/vmx.c:5929) kvm_intel
> 	vmx_handle_exit (arch/x86/kvm/vmx/vmx.c:? arch/x86/kvm/vmx/vmx.c:6606) kvm_intel
> 	vcpu_run (arch/x86/kvm/x86.c:11107 arch/x86/kvm/x86.c:11211) kvm
> 	kvm_arch_vcpu_ioctl_run (arch/x86/kvm/x86.c:?) kvm
> 	kvm_vcpu_ioctl (arch/x86/kvm/../../../virt/kvm/kvm_main.c:?) kvm
> 	__se_sys_ioctl (fs/ioctl.c:52 fs/ioctl.c:904 fs/ioctl.c:890)
> 	__x64_sys_ioctl (fs/ioctl.c:890)
> 	x64_sys_call (arch/x86/entry/syscall_64.c:33)
> 	do_syscall_64 (arch/x86/entry/common.c:?)
> 	entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
> 
> 	read to 0xffffc90025a92344 of 4 bytes by task 4342 on cpu 4:
> 	kvm_vcpu_on_spin (arch/x86/kvm/../../../virt/kvm/kvm_main.c:4069) kvm
> 	handle_pause (arch/x86/kvm/vmx/vmx.c:5929) kvm_intel
> 	vmx_handle_exit (arch/x86/kvm/vmx/vmx.c:? arch/x86/kvm/vmx/vmx.c:6606) kvm_intel
> 	vcpu_run (arch/x86/kvm/x86.c:11107 arch/x86/kvm/x86.c:11211) kvm
> 	kvm_arch_vcpu_ioctl_run (arch/x86/kvm/x86.c:?) kvm
> 	kvm_vcpu_ioctl (arch/x86/kvm/../../../virt/kvm/kvm_main.c:?) kvm
> 	__se_sys_ioctl (fs/ioctl.c:52 fs/ioctl.c:904 fs/ioctl.c:890)
> 	__x64_sys_ioctl (fs/ioctl.c:890)
> 	x64_sys_call (arch/x86/entry/syscall_64.c:33)
> 	do_syscall_64 (arch/x86/entry/common.c:?)
> 	entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
> 
> 	value changed: 0x00000012 -> 0x00000000
> 
> Given that both operations occur simultaneously without any locking
> mechanisms in place, let's ensure atomicity to prevent possible data
> corruption. We'll achieve this by employing READ_ONCE() for the reading
> operation and WRITE_ONCE() for the writing operation.

Please state changelogs as a commands, e.g.

  Use {READ,WRITE}_ONCE() to access kvm->last_boosted_vcpu to ensure ...

And I think it's worth calling out that corruption is _extremely_ unlikely to
happen in practice.  It would require the compiler to generate truly awful code,
and it would require a VM with >256 vCPUs.

That said, I do think this should be sent to stable kernels, as it's (very, very)
theoretically possible to generate an out-of-bounds access, and this seems like a
super safe fix.  How about this?

---
KVM: Fix a data race on last_boosted_vcpu in kvm_vcpu_on_spin() 

Use {READ,WRITE}_ONCE() to access kvm->last_boosted_vcpu to ensure the
loads and stores are atomic.  In the extremely unlikely scenario the
compiler tears the stores, it's theoretically possible for KVM to attempt
to get a vCPU using an out-of-bounds index, e.g. if the write is split
into multiple 8-bit stores, and is paired with a 32-bit load on a VM with
257 vCPUs:

  CPU0                              CPU1
  last_boosted_vcpu = 0xff;                                       

                                    (last_boosted_vcpu = 0x100)
                                    last_boosted_vcpu[15:8] = 0x01;
  i = (last_boosted_vcpu = 0x1ff)                                               
                                    last_boosted_vcpu[7:0] = 0x00;

  vcpu = kvm->vcpu_array[0x1ff];

As detected by KCSAN:

  BUG: KCSAN: data-race in kvm_vcpu_on_spin [kvm] / kvm_vcpu_on_spin [kvm]
  
  write to 0xffffc90025a92344 of 4 bytes by task 4340 on cpu 16:
  kvm_vcpu_on_spin (arch/x86/kvm/../../../virt/kvm/kvm_main.c:4112) kvm
  handle_pause (arch/x86/kvm/vmx/vmx.c:5929) kvm_intel
  vmx_handle_exit (arch/x86/kvm/vmx/vmx.c:? arch/x86/kvm/vmx/vmx.c:6606) kvm_intel
  vcpu_run (arch/x86/kvm/x86.c:11107 arch/x86/kvm/x86.c:11211) kvm
  kvm_arch_vcpu_ioctl_run (arch/x86/kvm/x86.c:?) kvm
  kvm_vcpu_ioctl (arch/x86/kvm/../../../virt/kvm/kvm_main.c:?) kvm
  __se_sys_ioctl (fs/ioctl.c:52 fs/ioctl.c:904 fs/ioctl.c:890)
  __x64_sys_ioctl (fs/ioctl.c:890)
  x64_sys_call (arch/x86/entry/syscall_64.c:33)
  do_syscall_64 (arch/x86/entry/common.c:?)
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
  
  read to 0xffffc90025a92344 of 4 bytes by task 4342 on cpu 4:
  kvm_vcpu_on_spin (arch/x86/kvm/../../../virt/kvm/kvm_main.c:4069) kvm
  handle_pause (arch/x86/kvm/vmx/vmx.c:5929) kvm_intel
  vmx_handle_exit (arch/x86/kvm/vmx/vmx.c:? arch/x86/kvm/vmx/vmx.c:6606) kvm_intel
  vcpu_run (arch/x86/kvm/x86.c:11107 arch/x86/kvm/x86.c:11211) kvm
  kvm_arch_vcpu_ioctl_run (arch/x86/kvm/x86.c:?) kvm
  kvm_vcpu_ioctl (arch/x86/kvm/../../../virt/kvm/kvm_main.c:?) kvm
  __se_sys_ioctl (fs/ioctl.c:52 fs/ioctl.c:904 fs/ioctl.c:890)
  __x64_sys_ioctl (fs/ioctl.c:890)
  x64_sys_call (arch/x86/entry/syscall_64.c:33)
  do_syscall_64 (arch/x86/entry/common.c:?)
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
  
  value changed: 0x00000012 -> 0x00000000

Fixes: 217ece6129f2 ("KVM: use yield_to instead of sleep in kvm_vcpu_on_spin")
Cc: stable@vger.kernel.org
---

> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  virt/kvm/kvm_main.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ff0a20565f90..9768307d5e6c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4066,12 +4066,13 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
>  {
>  	struct kvm *kvm = me->kvm;
>  	struct kvm_vcpu *vcpu;
> -	int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
> +	int last_boosted_vcpu;
>  	unsigned long i;
>  	int yielded = 0;
>  	int try = 3;
>  	int pass;
>  
> +	last_boosted_vcpu = READ_ONCE(me->kvm->last_boosted_vcpu);

Nit, this could opportunistically use "kvm" without the silly me->kvm.

>  	kvm_vcpu_set_in_spin_loop(me, true);
>  	/*
>  	 * We boost the priority of a VCPU that is runnable but not
> @@ -4109,7 +4110,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
>  
>  			yielded = kvm_vcpu_yield_to(vcpu);
>  			if (yielded > 0) {
> -				kvm->last_boosted_vcpu = i;
> +				WRITE_ONCE(kvm->last_boosted_vcpu, i);
>  				break;
>  			} else if (yielded < 0) {
>  				try--;

Side topic #1: am I the only one that finds these loops unnecessarily hard to
read?  Unless I'm misreading the code, it's really just an indirect way of looping
over all vCPUs, starting at last_boosted_vcpu+1 and the wrapping.

IMO, reworking it to be like this is more straightforward:

	int nr_vcpus, start, i, idx, yielded;
	struct kvm *kvm = me->kvm;
	struct kvm_vcpu *vcpu;
	int try = 3;

	nr_vcpus = atomic_read(&kvm->online_vcpus);
	if (nr_vcpus < 2)
		return;

	/* Pairs with the smp_wmb() in kvm_vm_ioctl_create_vcpu(). */
	smp_rmb();

	kvm_vcpu_set_in_spin_loop(me, true);

	start = READ_ONCE(kvm->last_boosted_vcpu) + 1;
	for (i = 0; i < nr_vcpus; i++) {
		idx = (start + i) % nr_vcpus;
		if (idx == me->vcpu_idx)
			continue;

		vcpu = xa_load(&kvm->vcpu_array, idx);
		if (!READ_ONCE(vcpu->ready))
			continue;
		if (kvm_vcpu_is_blocking(vcpu) && !vcpu_dy_runnable(vcpu))
			continue;

		/*
		 * Treat the target vCPU as being in-kernel if it has a pending
		 * interrupt, as the vCPU trying to yield may be spinning
		 * waiting on IPI delivery, i.e. the target vCPU is in-kernel
		 * for the purposes of directed yield.
		 */
		if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
		    !kvm_arch_dy_has_pending_interrupt(vcpu) &&
		    !kvm_arch_vcpu_preempted_in_kernel(vcpu))
			continue;

		if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
			continue;

		yielded = kvm_vcpu_yield_to(vcpu);
		if (yielded > 0) {
			WRITE_ONCE(kvm->last_boosted_vcpu, i);
			break;
		} else if (yielded < 0 && !--try) {
			break;
		}
	}

	kvm_vcpu_set_in_spin_loop(me, false);

	/* Ensure vcpu is not eligible during next spinloop */
	kvm_vcpu_set_dy_eligible(me, false);

Side topic #2, intercepting PAUSE on x86 when there's only a single vCPU in the
VM is silly.  I don't know if it's worth the complexity, but we could defer
enabling PLE exiting until a second vCPU is created, e.g. via a new request.

Hmm, but x86 at least already has KVM_X86_DISABLE_EXITS_PAUSE, so this could be
more easily handled in userspace, e.g. by disabing PAUSE exiting if userspace
knows it's creating a single-vCPU VM.

