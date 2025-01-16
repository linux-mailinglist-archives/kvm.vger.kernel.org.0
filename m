Return-Path: <kvm+bounces-35671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1EE3A13D92
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 16:24:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E9B4166AE6
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 15:24:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D645722B8B9;
	Thu, 16 Jan 2025 15:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RqyOwaaN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A7678F2B
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 15:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737041085; cv=none; b=qkc5feDu+TPM3kFaCFK7OX1kzdjIYyPCNQKyTOTja0Am4aFAI8MOB7DHi9cJ1POd50K0suknr0VRhBbjhagwK18qirBpMTXApfWvChZd7EwF7z6EyIteSmShEmB6cqxlhtnJ2Oi6cDRjI9+o7rFIAZRWu1HMOElCBPlY3dj+6OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737041085; c=relaxed/simple;
	bh=qRU+G/ICvNjSpda689qHwFWzx6ROcuNqtJyvPx2bLpE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Hj1qAH2LIFppcJPk+YmjndB52gqoNH0qgdhtQE8+8PByyxGcxWRYcaU4O4KMFHTh8YWrn2OcOlLPiSaM+gSYJoFH7Ap8mGZKgU7K6/U9vL95GaKRucG4PjN/dKktEbHC88X+9/0N9euoY/SpFZqiw5PFnM+HwbWOqpGWzvJl7jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RqyOwaaN; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef79403c5eso3206895a91.0
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 07:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737041082; x=1737645882; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ogc4PdmAGEvRxwmEx7kBGkRo+slthN0a5iOoXNsY9Rc=;
        b=RqyOwaaNDptbFFTqtjeJiLFzon3bkPObqxleFzwsz5oXXzUtFS8+DPNi/tCaHIajVE
         XXlOcZkO/az5OOqg1oYiupNvkxdZBGfMP47WYsbDw4LmeVODA7fuITwhvVQY4dSi+DTO
         rBaLB9R6G+aevv/nG05t9p8MCr8AMpd0uT+4bSc8vN+pB7pCk3aoJQYB5obEvPPl/cR0
         /5xPkvWdySLcIhGCpH1s4H738SGi30nt9mSnCWisicYJCttGsiatqVYsdDhJ/r1udDhj
         RQ3+ZBQZS23qHPnrBF4JY4oZYnEL6z4Q/4pn8gVRxe8667KlBTtkxA/Ng9mevGq0ZG8Z
         YkEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737041082; x=1737645882;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ogc4PdmAGEvRxwmEx7kBGkRo+slthN0a5iOoXNsY9Rc=;
        b=FosjoWdJMk8OJx5F1NWvVlAuaTFrGPJO4OFhuUsZ6H227CFKMDP/XDVhMYrJpeKSAK
         u6ocTmRCuigemS96vPfL4dkBpj98+lvhKLA+BnXPjigyuZiiSMRp9R5lwZble33HTkvG
         SXunaYXdrK4ss0EXxCozhRbFnPMyD3WEYPK6bsIhhV1W1XUoHZ1fbp4ILCiYkbI4mKTM
         t75M7wt8z1XEA3+2Bl5vLd2WgYo/oG0DQZwb6dIprQF5OfA4UiEr5fK5tr2b3kBm+cf6
         C4HlzzvCWI8zJRBlJpDi/VFyXUnlNVgscTCmeSj4vTmYobPVkiPO1Jcj0lGlsjf5mg6A
         ivwA==
X-Forwarded-Encrypted: i=1; AJvYcCWW6f+m3GDt0dyX6i5cMKUkpO5Bohv5xFxqIUw12kvnNu0eS0SPW9VUJVAP25u5IZoi8z8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyo1Lz6B2DgJfoLVdl8ZVETHXD/h47gGzXa847TFgq684c54Wq8
	Rt2Z/2LvvRfNl1S0CFw0aHeIBEhjGvzIAQFxnepjWHVFwPn87xAekKae7OZKzuOqNvG+aQl3l6D
	24Q==
X-Google-Smtp-Source: AGHT+IEc8ve7rFeYMBGxZNR6kPwRfkW4GzPtmE6qgJP7td0M778NtMjJKXXvNWNZVi/nqCGJMlh53eGvyZM=
X-Received: from pjbqn5.prod.google.com ([2002:a17:90b:3d45:b0:2ea:61ba:b8f7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:da8e:b0:2ee:b0b0:8e02
 with SMTP id 98e67ed59e1d1-2f5490ac09cmr47207653a91.28.1737041082706; Thu, 16
 Jan 2025 07:24:42 -0800 (PST)
Date: Thu, 16 Jan 2025 15:24:41 +0000
In-Reply-To: <E5C85B8E-D8F8-408F-B00B-A3650C9320EA@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAFtZq1FwJOtxmbf_NPgYP_ZH=PkXJfF0=cXo0xbGkT5TGv66-A@mail.gmail.com>
 <CAHk-=whnVemumt5AJ1f=rsGdLz4Fk95nZfoBchGmMWCGG63foQ@mail.gmail.com>
 <CAFtZq1FpLfbnJzqc_s=j9TBLyGxe9D_ZYZU2qiES5dgsBAWv+g@mail.gmail.com>
 <2025011646-chariot-revision-5753@gregkh> <E5C85B8E-D8F8-408F-B00B-A3650C9320EA@gmail.com>
Message-ID: <Z4kkuaY_mJ6z0sa2@google.com>
Subject: Re: Potential Denial-of-Service Vulnerability in KVM When Emulating
 'hlt' Instruction in L2 Guests
From: Sean Christopherson <seanjc@google.com>
To: chichen241 <chichen241@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, 
	Linus Torvalds <torvalds@linuxfoundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	"security@kernel.org" <security@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

+KVM and LKML to for archival, as this is not a DoS

On Thu, Jan 16, 2025, chichen241 wrote:
> It seems that the attachment content is not convenient for you to see, so I
> will reuse the email content to describe it.

...

> syz_kvm_setup_cpu(/*fd=*/vmfd, /*cpufd=*/vcpufd, /*usermem=*/mem,
> /*text=*/&nop_text, /*ntext*/ 1,/*flags=*/-1, /*opts=*/opts, /*nopt=*/1); //
> The nested vm will run '\x90\xf4', the vm will try to emulate the hlt
> instruction and fail, entry endless loop.  ioctl(vcpufd, KVM_RUN, NULL);
> printf("The front kvm_run will caught in loop. This code will not be
> executed") } ```
> linux kernel version: 6.12-rc7
> Also I checked my mailbox and didn't see any quesiton from Sean. Maybe there's some mistake?

For posterity:

  > > virtualization. When an L2 guest attempts to emulate an instruction
  
  How did you coerce KVM into emulating HLT from L2?
  
  > > using the x86_emulate_instruction() function, and the instruction to
  > > be emulated is hlt, the x86_decode_emulated_instruction() function
  > > used for instruction decoding does not support parsing the hlt
  > > instruction.
  
  KVM should parse HLT just fine, I suspect the issue is that KVM _intentionally_
  refuses to emulate HLT from L2, because encountering HLT in the emulator when L2
  is active either requires the guest to be playing TLB games (e.g. generate an
  emulated MMIO exit on a MOV, patch the MOV into a HLT), or it requires enabling
  an off-by-default, "for testing purposes only" KVM module param.
  
  > > As a result, x86_decode_emulated_instruction() returns
  > > ctxt->execute as null, causing the L2 guest to fail to execute the hlt
  > > instruction properly. Subsequently, KVM enters an infinite loop,
  
  Define "infinite loop", i.e. what are the bounds of the loop?  If the "loop" is
  KVM re-entering the guest on the same instruction over and over, then everything
  is working as intended.
  
  > > repeatedly invoking x86_emulate_instruction() to perform the same
  > > operation. This issue does not occur when the instruction to be
  > > emulated by L2 is another standard instruction.
  > >
  > > Therefore, I am wondering whether this constitutes a denial-of-service
  > > (DoS) vulnerability and whether a CVE number can be assigned.
  
  Unless your reproducer causes a hard hang in KVM, or prevents L1 from gaining
  control from L2, e.g. via a (virtual) interrupt, this is not a DoS.  I can imagine
  scenarios where L2 can put itself into an infinite loop, i.e. DoS itself, but
  that's not a vulnerability in any reasonable sense of things.
  
  > > Generally, for software emulation in L1 guests, KVM's
  > > x86_emulate_instruction() function will, after parsing the instruction
  > > with x86_decode_emulated_instruction(), attempt to use
  > > retry_instruction() to retry instruction execution.
  
  No, retry_instruction() is specifically for cases where KVM fails to emulate an
  instruction _and_ the emulation was triggered by a write to guest PTE that KVM
  is shadowing, i.e. a guest page that KVM has made read-only.  If certain criteria
  were met, KVM will unprotect the page, i.e. make it writable again, and resume
  the guest to let the CPU retry the instruction.
 
> ## DESCRIPTION in this file, the most code is from
> syzkaller(executor/common_kvm_amd64.h), I mainly call the `syz_kvm_setup_cpu`
> function and run the vm using ioctl `kvm_run`.  First I use
> `syz_kvm_setup_cpu` to setup the vm to run a nested vm.  The second time the
> `syz_kvm_setup_cpu` will turn on the TF bit in the eflag register of the
> nested vm and let the nested vm run `nop;hlt` code.
> When running kvm_run, the code will begin looping.
> ## ANALYSE
> The nested vm try to emulate the `hlt` code but failed, it will always try, caught in an endless loop.

The guest loops because the the guest's IDT is located in emulated MMIO space,
and as suspected above, KVM refuses to emulates HLT for L2.

The single-step #DB induced by RFLAGS.TF=1 triggers an EPT Violation as a result
of the CPU trying to vector the #DB with the IDT residing in non-existent memory.
At this point KVM *should* kick out to host userspace, as userspace is responsible
for dealing with the emulate MMIO access during exception vectoring.

           repro-1289    [019] d....   140.314684: kvm_exit: vcpu 0 reason EXCEPTION_NMI rip 0x1 info1 0x0000000000004000 info2 0x0000000000000000 intr_info 0x80000301 error_code 0x00000000
           repro-1289    [019] .....   140.314685: kvm_nested_vmexit: vcpu 0 reason EXCEPTION_NMI rip 0x1 info1 0x0000000000004000 info2 0x0000000000000000 intr_info 0x80000301 error_code 0x00000000
           repro-1289    [019] .....   140.314688: kvm_inj_exception: #DB
           repro-1289    [019] d....   140.314688: kvm_entry: vcpu 0, rip 0x1
           repro-1289    [019] d....   140.314704: kvm_exit: vcpu 0 reason EPT_VIOLATION rip 0x1 info1 0x0000000000000181 info2 0x0000000080000301 intr_info 0x00000000 error_code 0x00000000
           repro-1289    [019] .....   140.314706: kvm_nested_vmexit: vcpu 0 reason EPT_VIOLATION rip 0x1 info1 0x0000000000000181 info2 0x0000000080000301 intr_info 0x00000000 error_code 0x00000000
           repro-1289    [019] .....   140.314706: kvm_page_fault: vcpu 0 rip 0x1 address 0x0000000000001050 error_code 0x181
           repro-1289    [019] .....   140.314708: kvm_inj_exception: #DB [reinjected]
           repro-1289    [019] d....   140.314709: kvm_entry: vcpu 0, rip 0x1

KVM misses the weird edge case, and instead ends up trying to emulate the
instruction at the current RIP.  That instruction happens to be HLT, which KVM
doesn't support for L2 (nested guests), and so KVM injects #UD.

           repro-1289    [019] d....   140.314732: kvm_exit: vcpu 0 reason EPT_VIOLATION rip 0x1 info1 0x00000000000001aa info2 0x0000000080000301 intr_info 0x00000000 error_code 0x00000000
           repro-1289    [019] .....   140.314749: kvm_emulate_insn: 0:1:f4 (prot32)
           repro-1289    [019] .....   140.314751: kvm_emulate_insn: 0:1:f4 (prot32) failed
           repro-1289    [019] .....   140.314752: kvm_inj_exception: #UD

Vectoring the #UD suffers the same fate as the #DB, and so KVM unintentionally
puts the vCPU into an endless loop.

           repro-1289    [019] d....   140.314767: kvm_exit: vcpu 0 reason EPT_VIOLATION rip 0x1 info1 0x00000000000001aa info2 0x0000000080000306 intr_info 0x00000000 error_code 0x00000000
           repro-1289    [019] .....   140.314767: kvm_nested_vmexit: vcpu 0 reason EPT_VIOLATION rip 0x1 info1 0x00000000000001aa info2 0x0000000080000306 intr_info 0x00000000 error_code 0x00000000
           repro-1289    [019] .....   140.314768: kvm_page_fault: vcpu 0 rip 0x1 address 0x0000000000000f78 error_code 0x1aa
           repro-1289    [019] .....   140.314778: kvm_emulate_insn: 0:1:f4 (prot32)
           repro-1289    [019] .....   140.314779: kvm_emulate_insn: 0:1:f4 (prot32) failed

> ## QUESTION
> The phenomenon is due to the kvm's emulate function can't emulate all the
> instructions.

No, the issue is that KVM doesn't detect a weird edge case where the *guest* has
messed up, and instead of effectively terminating the VM, KVM puts it into an
infinite loop of sorts.

Amusingly, this edge case was just "fixed" for both VMX and SVM[*] (expected to
to land in v6.14).  In quotes because "fixing" the problem really means killing
the VM instead of letting it loop.

  [1/7] KVM: x86: Add function for vectoring error generation
        https://github.com/kvm-x86/linux/commit/11c98fa07a79
  [2/7] KVM: x86: Add emulation status for unhandleable vectoring
        https://github.com/kvm-x86/linux/commit/5c9cfc486636
  [3/7] KVM: x86: Unprotect & retry before unhandleable vectoring check
        https://github.com/kvm-x86/linux/commit/704fc6021b9e
  [4/7] KVM: VMX: Handle vectoring error in check_emulate_instruction
        https://github.com/kvm-x86/linux/commit/47ef3ef843c0
  [5/7] KVM: SVM: Handle vectoring error in check_emulate_instruction
        https://github.com/kvm-x86/linux/commit/7bd7ff99110a
  [6/7] selftests: KVM: extract lidt into helper function
        https://github.com/kvm-x86/linux/commit/4e9427aeb957
  [7/7] selftests: KVM: Add test case for MMIO during vectoring
        https://github.com/kvm-x86/linux/commit/62e41f6b4f36

[*] https://lore.kernel.org/all/173457555486.3295983.11848882309599168611.b4-ty@google.com

