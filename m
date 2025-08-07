Return-Path: <kvm+bounces-54253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B29B5B1D7FE
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 14:34:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A4CB1AA1EC1
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 12:34:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26BE9251791;
	Thu,  7 Aug 2025 12:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JP99wDpX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E7726290
	for <kvm@vger.kernel.org>; Thu,  7 Aug 2025 12:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754570047; cv=none; b=htaXXeYjId4j5S251DJVGL23QItnsV75Un2NICQoq9h/TQDtA2pi1S3pTHC0AiGA+Xrmbv2gr1HXdnz72k0zvutKisS5+UGzLVU0llcglP+NSR7bIs1BQ8/B6IiBmW81RXOb+KmdQtNNLP1qwoxlfoLv/0jIoYRRY3zKKOMrpcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754570047; c=relaxed/simple;
	bh=x67tPOz+z795FOsR1PlLJQP038SmfddfCfDhYklGAws=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hHSGIaaZWd8epBrKwVZlmIk3eeCVblRjcnzi7eNOc1YM5cTh6egF4pg6bleeb/ImtJVOO5pdVk+LJI/lAtqaUTQa3MVm4F34WIBnyksw0khUONzg69gfv2jJVO5RdrfmpxBwOb8jPzjc0zV6aEdm5VgmFssRWa+mVJ4YBGeeaNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JP99wDpX; arc=none smtp.client-ip=209.85.128.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-459d55ba939so415825e9.3
        for <kvm@vger.kernel.org>; Thu, 07 Aug 2025 05:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1754570043; x=1755174843; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Vwhi8rjC0/ZrUnzAnEoimoRQ2TDhcxTBumKozfzs2Xk=;
        b=JP99wDpXtE0MufXyVdDXqdZD0+caXr2Nc5iQtkQ03X0YTsq4UYaq8Egtv9AU34d/Hz
         o/PCaQm8IR0q3ntja7C984R0gBec/sim2NURSAWpL+NCgm0BLnobYTlhpfxanzUwNWTb
         nskhtaxcb8kk/yDe1Gpk0DSRjGx5WQ4Q3yGI0fq2/xuhiNPQ8liDgVPpHGblaJuuY23D
         WBbj54K8AZHY75yN2OtqKh1GVSf4/tnSnXMMyLQB6sxeSbE14SXBlyB77qKRrye16Mwo
         TwDw7CnMNov/2ZqkpSjjbAk0oRkW5xbBf/B7HqcNAv8KWNpX9t9V1+oMPGsxUnumljyv
         DkYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754570043; x=1755174843;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vwhi8rjC0/ZrUnzAnEoimoRQ2TDhcxTBumKozfzs2Xk=;
        b=uCqlB8M6NbJXsRHitFZbTM7QcJITN7AnB6G+8JYnTA0ptc+j/rytbK7qB0JNSyab0x
         9uWnXHzgPbtHb6nEj6pcIw0dP+G1uLJCDT+GVLThqieBZIACAkEttur0tHMCPun48+op
         ELf9mpTeScRuvPvqqNhpipOnA8UzUHuwFnK7kMS4plddR31M1sBDIoACbH0WixECUdeC
         iZNGXQcuFOHv2rOnZNXWH1ayKhZvRpRsdvSuV9fkwt+fr2Wup9PM0BykQpZ6DhXYHoIX
         SHl1YXr8d37UKKsiJh0y28H7L7FDN+a6VAMrsdnq9gq2tALfeb4BsKPEG4oTqSN9WTg2
         0/PQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2+DC2KMObharJMCmFviT7TOgCm3a/F38I/F9URFb8+fNwBFZag3yBHM+6D72/TSAYBG4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzuUk5AImfmlFumHG2CyhSs4sKFwdptdVlUJoHhRnshMGVW20XL
	8UK2+38zOTK6EJaXo/TPqEr/NMRt13chqZWj3a5jWy6kLOrOv4FqL7yWUaiQrBDiSLk=
X-Gm-Gg: ASbGncuSnS2t/wNhm3f92gFdFhY6X6ZDZkvMxph+NkgBHdb5af1FO7uTAperzX+u58F
	LD3BTllX+ebehpl7ic7Zvrn1ISjkBoSjI6X78eKdjkq4BxJLE24LoiAUvhgROiuppCP4BiBcaTr
	uWjdsZsdr9lr1td8RcpLNewOL4k9PIYfcIDXk8ohwVfMvXcjNFLzaG69f4QGbB7mrCK+6Ai4V1F
	1EOmgKf77r9G6g3fGFLw9zwLMXhA5ZlIZnBBhA/5P1dHhmukKjD8GuD5rb8K/7ivdSFvt/Dp66+
	kLURSLy2bzlW0CJAZrryfJJzhK1XC6E5isHGxGf90L8ogJhxVpi4EoZgGTP5bwvGQ+l84R4ExH2
	9yYgvBtPkeMxpcgoju5AcIygkgv6I5GVJahlk/PnWiJVe1OG5YLNg74+q8w6fRaB9Ihr4iBiJlb
	mDYMhO
X-Google-Smtp-Source: AGHT+IGxwzOKjqBJACV8aOq5t96aSfoeFdqe2f+vIDI4ZXtL8yy3rgTOzp5cyNBKX9tEBDi+zCfAZw==
X-Received: by 2002:a05:600c:3b97:b0:459:dd09:856c with SMTP id 5b1f17b1804b1-459f3a7e2b6mr1076535e9.6.1754570042841;
        Thu, 07 Aug 2025 05:34:02 -0700 (PDT)
Received: from ?IPV6:2a02:2455:86a0:a300:6570:b777:80f4:22f9? ([2a02:2455:86a0:a300:6570:b777:80f4:22f9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e6867193sm85948925e9.6.2025.08.07.05.34.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Aug 2025 05:34:02 -0700 (PDT)
Message-ID: <2549e6d3-7664-4d12-b84e-ec4a326dec60@suse.com>
Date: Thu, 7 Aug 2025 14:34:01 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/29] KVM: VM planes
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: roy.hopkins@suse.com, seanjc@google.com, thomas.lendacky@amd.com,
 ashish.kalra@amd.com, michael.roth@amd.com, nsaenz@amazon.com,
 anelkz@amazon.de, James.Bottomley@HansenPartnership.com,
 =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
References: <20250401161106.790710-1-pbonzini@redhat.com>
Content-Language: en-US
From: Vaishali Thakkar <vaishali.thakkar@suse.com>
Autocrypt: addr=vaishali.thakkar@suse.com; keydata=
 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
In-Reply-To: <20250401161106.790710-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Adding Joerg's functional email id.

On 4/1/25 6:10 PM, Paolo Bonzini wrote:
> I guess April 1st is not the best date to send out such a large series
> after months of radio silence, but here we are.
> 
> AMD VMPLs, Intel TDX partitions, Microsoft Hyper-V VTLs, and ARM CCA planes.
> are all examples of virtual privilege level concepts that are exclusive to
> guests.  In all these specifications the hypervisor hosts multiple
> copies of a vCPU's register state (or at least of most of it) and provides
> hypercalls or instructions to switch between them.
> 
> This is the first draft of the implementation according to the sketch that
> was prepared last year between Linux Plumbers and KVM Forum.  The initial
> version of the API was posted last October, and the implementation only
> needed small changes.
> 
> Attempts made in the past, mostly in the context of Hyper-V VTLs and SEV-SNP
> VMPLs, fell into two categories:
> 
> - use a single vCPU file descriptor, and store multiple copies of the state
>   in a single struct kvm_vcpu.  This approach requires a lot of changes to
>   provide multiple copies of affected fields, especially MMUs and APICs;
>   and complex uAPI extensions to direct existing ioctls to a specific
>   privilege level.  While more or less workable for SEV-SNP VMPLs, that
>   was only because the copies of the register state were hidden
>   in the VMSA (KVM does not manage it); it showed all its problems when
>   applied to Hyper-V VTLs.
> 
>   The main advantage was that KVM kept the knowledge of the relationship
>   between vCPUs that have the same id but belong to different privilege
>   levels.  This is important in order to accelerate switches in-kernel.
> 
> - use multiple VM and vCPU file descriptors, and handle the switch entirely
>   in userspace.  This got gnarly pretty fast for even more reasons than
>   the previous case, for example because VMs could not share anymore
>   memslots, including dirty bitmaps and private/shared attributes (a
>   substantial problem for SEV-SNP since VMPLs share their ASID).
> 
>   Opposite to the other case, the total lack of kernel-level sharing of
>   register state, and lack of control that vCPUs do not run in parallel,
>   is what makes this approach problematic for both kernel and userspace.
>   In-kernel implementation of privilege level switch becomes from
>   complicated to impossible, and userspace needs a lot of complexity
>   as well to ensure that higher-privileged VTLs properly interrupted a
>   lower-privileged one.
> 
> This design sits squarely in the middle: it gives the initial set of
> VM and vCPU file descriptors the full set of ioctls + struct kvm_run,
> whereas other privilege levels ("planes") instead only support a small
> part of the KVM API.  In fact for the vm file descriptor it is only three
> ioctls: KVM_CHECK_EXTENSION, KVM_SIGNAL_MSI, KVM_SET_MEMORY_ATTRIBUTES.
> For vCPUs it is basically KVM_GET/SET_*.
> 
> Most notably, memslots and KVM_RUN are *not* included (the choice of
> which plane to run is done via vcpu->run), which solves a lot of
> the problems in both of the previous approaches.  Compared to the
> multiple-file-descriptors solution, it gets for free the ability to
> avoid parallel execution of the same vCPUs in different privilege levels.
> Compared to having a single file descriptor churn is more limited, or
> at least can be attacked in small bites.  For example in this series
> only per-plane interrupt controllers are switched to use the new struct
> kvm_plane in place of struct kvm, and that's more or less enough in
> the absence of complex interrupt delivery scenarios.
> 
> Changes to the userspace API are also relatively small; they boil down
> to the introduction of a single new kind of file descriptor and almost
> entirely fit in common code.  Reviewing these VM-wide and architecture-
> independent changes should be the main purpose of this RFC, since 
> there are still some things to fix:
> 
> - I named some fields "plane" instead of "plane_id" because I expected no
>   fields of type struct kvm_plane*, but in retrospect that wasn't a great
>   idea.
> 
> - online_vcpus counts across all planes but x86 code is still using it to
>   deal with TSC synchronization.  Probably I will try and make kvmclock
>   synchronization per-plane instead of per-VM.
> 

Hi Paolo,

Is there still a plan to make kvmclock synchronization per-plane instead
of per-VM? Do you plan to handle it as part of this patchset or you
think it should be handled separately on top of this patchset?

I'm asking as coconut-svsm needs a monotonic clock source which adheres
to wall-clock time. And we have been exploring several approaches to
achieve this. One of the idea is to use kvmclock, provided it can
support a per-plane instance that remains synchronized across planes.

Thanks.


> - we're going to need a struct kvm_vcpu_plane similar to what Roy had in
>   https://lore.kernel.org/kvm/cover.1726506534.git.roy.hopkins@suse.com/
>   (probably smaller though).  Requests are per-plane for example, and I'm
>   pretty sure any simplistic solution would have some corner cases where
>   it's wrong; but it's a high churn change and I wanted to avoid that
>   for this first posting.
> 
> There's a handful of locking TODOs where things should be checked more
> carefully, but clearly identifying vCPU data that is not per-plane will
> also simplify locking, thanks to having a single vcpu->mutex for the
> whole plane.  So I'm not particularly worried about that; the TDX saga
> hopefully has taught everyone to move in baby steps towards the intended
> direction.
> 
> The handling of interrupt priorities is way more complicated than I
> anticipated, unfortunately; everything else seems to fall into place
> decently well---even taking into account the above incompleteness,
> which anyway should not be a blocker for any VTL or VMPL experiments.
> But do shout if anything makes you feel like I was too lazy, and/or you
> want to puke.
> 
> Patches 1-2 are documentation and uAPI definitions.
> 
> Patches 3-9 are the common code for VM planes, while patches 10-14
> are the common code for vCPU file descriptors on non-default planes.
> 
> Patches 15-26 are the x86-specific code, which is organized as follows:
> 
> - 15-20: convert APIC code to place its data in the new struct
> kvm_arch_plane instead of struct kvm_arch.
> 
> - 21-24: everything else except the new userspace exit, KVM_EXIT_PLANE_EVENT
> 
> - 25: KVM_EXIT_PLANE_EVENT, which is used when one plane interrupts another.
> 
> - 26: finally make the capability available to userspace
> 
> Patches 27-29 finally are the testcases.  More are possible and planned,
> but these are enough to say that, despite the missing bits, what exits
> is not _completely_ broken.  I also didn't want to write dozens of tests
> before committing to a selftests API.
> 
> Available for now at https://git.kernel.org/pub/scm/virt/kvm/kvm.git
> branch planes-20250401.  I plan to place it in kvm-coco-queue, for lack
> of a better place, as soon as TDX is merged into kvm/next and I test it
> with the usual battery of kvm-unit-tests and real world guests.
> 
> Thanks,
> 
> Paolo
> 
> Paolo Bonzini (29):
>   Documentation: kvm: introduce "VM plane" concept
>   KVM: API definitions for plane userspace exit
>   KVM: add plane info to structs
>   KVM: introduce struct kvm_arch_plane
>   KVM: add plane support to KVM_SIGNAL_MSI
>   KVM: move mem_attr_array to kvm_plane
>   KVM: do not use online_vcpus to test vCPU validity
>   KVM: move vcpu_array to struct kvm_plane
>   KVM: implement plane file descriptors ioctl and creation
>   KVM: share statistics for same vCPU id on different planes
>   KVM: anticipate allocation of dirty ring
>   KVM: share dirty ring for same vCPU id on different planes
>   KVM: implement vCPU creation for extra planes
>   KVM: pass plane to kvm_arch_vcpu_create
>   KVM: x86: pass vcpu to kvm_pv_send_ipi()
>   KVM: x86: split "if" in __kvm_set_or_clear_apicv_inhibit
>   KVM: x86: block creating irqchip if planes are active
>   KVM: x86: track APICv inhibits per plane
>   KVM: x86: move APIC map to kvm_arch_plane
>   KVM: x86: add planes support for interrupt delivery
>   KVM: x86: add infrastructure to share FPU across planes
>   KVM: x86: implement initial plane support
>   KVM: x86: extract kvm_post_set_cpuid
>   KVM: x86: initialize CPUID for non-default planes
>   KVM: x86: handle interrupt priorities for planes
>   KVM: x86: enable up to 16 planes
>   selftests: kvm: introduce basic test for VM planes
>   selftests: kvm: add plane infrastructure
>   selftests: kvm: add x86-specific plane test
> 
>  Documentation/virt/kvm/api.rst                | 245 +++++++--
>  Documentation/virt/kvm/locking.rst            |   3 +
>  Documentation/virt/kvm/vcpu-requests.rst      |   7 +
>  arch/arm64/include/asm/kvm_host.h             |   5 +
>  arch/arm64/kvm/arm.c                          |   4 +-
>  arch/arm64/kvm/handle_exit.c                  |   6 +-
>  arch/arm64/kvm/hyp/nvhe/gen-hyprel.c          |   4 +-
>  arch/arm64/kvm/mmio.c                         |   4 +-
>  arch/loongarch/include/asm/kvm_host.h         |   5 +
>  arch/loongarch/kvm/exit.c                     |   8 +-
>  arch/loongarch/kvm/vcpu.c                     |   4 +-
>  arch/mips/include/asm/kvm_host.h              |   5 +
>  arch/mips/kvm/emulate.c                       |   2 +-
>  arch/mips/kvm/mips.c                          |  32 +-
>  arch/mips/kvm/vz.c                            |  18 +-
>  arch/powerpc/include/asm/kvm_host.h           |   5 +
>  arch/powerpc/kvm/book3s.c                     |   2 +-
>  arch/powerpc/kvm/book3s_hv.c                  |  46 +-
>  arch/powerpc/kvm/book3s_hv_rm_xics.c          |   8 +-
>  arch/powerpc/kvm/book3s_pr.c                  |  22 +-
>  arch/powerpc/kvm/book3s_pr_papr.c             |   2 +-
>  arch/powerpc/kvm/powerpc.c                    |   6 +-
>  arch/powerpc/kvm/timing.h                     |  28 +-
>  arch/riscv/include/asm/kvm_host.h             |   5 +
>  arch/riscv/kvm/vcpu.c                         |   4 +-
>  arch/riscv/kvm/vcpu_exit.c                    |  10 +-
>  arch/riscv/kvm/vcpu_insn.c                    |  16 +-
>  arch/riscv/kvm/vcpu_sbi.c                     |   2 +-
>  arch/riscv/kvm/vcpu_sbi_hsm.c                 |   2 +-
>  arch/s390/include/asm/kvm_host.h              |   5 +
>  arch/s390/kvm/diag.c                          |  18 +-
>  arch/s390/kvm/intercept.c                     |  20 +-
>  arch/s390/kvm/interrupt.c                     |  48 +-
>  arch/s390/kvm/kvm-s390.c                      |  10 +-
>  arch/s390/kvm/priv.c                          |  60 +--
>  arch/s390/kvm/sigp.c                          |  50 +-
>  arch/s390/kvm/vsie.c                          |   2 +-
>  arch/x86/include/asm/kvm_host.h               |  46 +-
>  arch/x86/kvm/cpuid.c                          |  57 +-
>  arch/x86/kvm/cpuid.h                          |   2 +
>  arch/x86/kvm/debugfs.c                        |   2 +-
>  arch/x86/kvm/hyperv.c                         |   7 +-
>  arch/x86/kvm/i8254.c                          |   7 +-
>  arch/x86/kvm/ioapic.c                         |   4 +-
>  arch/x86/kvm/irq_comm.c                       |  14 +-
>  arch/x86/kvm/kvm_cache_regs.h                 |   4 +-
>  arch/x86/kvm/lapic.c                          | 147 +++--
>  arch/x86/kvm/mmu/mmu.c                        |  41 +-
>  arch/x86/kvm/mmu/tdp_mmu.c                    |   2 +-
>  arch/x86/kvm/svm/sev.c                        |   4 +-
>  arch/x86/kvm/svm/svm.c                        |  21 +-
>  arch/x86/kvm/vmx/tdx.c                        |   8 +-
>  arch/x86/kvm/vmx/vmx.c                        |  20 +-
>  arch/x86/kvm/x86.c                            | 319 ++++++++---
>  arch/x86/kvm/xen.c                            |   1 +
>  include/linux/kvm_host.h                      | 130 +++--
>  include/linux/kvm_types.h                     |   1 +
>  include/uapi/linux/kvm.h                      |  28 +-
>  tools/testing/selftests/kvm/Makefile.kvm      |   2 +
>  .../testing/selftests/kvm/include/kvm_util.h  |  48 ++
>  .../selftests/kvm/include/x86/processor.h     |   1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  65 ++-
>  .../testing/selftests/kvm/lib/x86/processor.c |  15 +
>  tools/testing/selftests/kvm/plane_test.c      | 103 ++++
>  tools/testing/selftests/kvm/x86/plane_test.c  | 270 ++++++++++
>  virt/kvm/dirty_ring.c                         |   5 +-
>  virt/kvm/guest_memfd.c                        |   3 +-
>  virt/kvm/irqchip.c                            |   5 +-
>  virt/kvm/kvm_main.c                           | 500 ++++++++++++++----
>  69 files changed, 1991 insertions(+), 614 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/plane_test.c
>  create mode 100644 tools/testing/selftests/kvm/x86/plane_test.c
> 


