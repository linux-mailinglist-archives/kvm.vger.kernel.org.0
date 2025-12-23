Return-Path: <kvm+bounces-66617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 66D57CD9E52
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 17:07:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E40323014A29
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 16:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D672E2C21F9;
	Tue, 23 Dec 2025 16:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N5Si2CCc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DA72BF002
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 16:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766505999; cv=none; b=qCfHHOyL5icwyR3jVweGDXlwtV1OK8lVgeAVgh3vLMy3abfVwDksBu8cFD9q4TkERnftJz0GpkmvQuwjnyQaqm6V3lT89HZRJ0/CdXiw7YIB6hQqSL3R8jCa18quDRc24yyPM4yNe6WNhqenljcUVPZqSVEcSozVy70hM6zBc4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766505999; c=relaxed/simple;
	bh=c2TO72/iqGV73V05ob94a59Oh5LHei+cJu8EUvYbHYc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Kbofvw0BAkOp4AcidY6UQN/VYb+5bV2PcC1guXlePXUGqt6lbL/Ht2C6sK+89ZP/vjOkqVGunb5H6dSTbgI19qXPXdk8iKhrpnaGmrf5WMYAXaIIrzu1D+h3OR9hxP28ikIFXey7L+EKoIiLenHuk/msDov53zYoT/bo41AIX5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N5Si2CCc; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7bf5cdef41dso8779456b3a.0
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 08:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766505997; x=1767110797; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f0id+v0RQ7dPGJFkKMzUF3z52grtJKOfftvzQrgbet0=;
        b=N5Si2CCc80McUxhOZrJIik/q7RzBV2DbXOL/sTpX1YmPo5mHSaGHWKupEkhKHs/BTT
         5rUUS2bL4POr6e67N5pjgCjeIz9R+7R1d6j5H/cCZAeAAiYez+J4hpJf6aVctThIZTqC
         kx8CLDPDb5dzMJOAKEyWVArl/UhisSlm7X0yZJmT1NO0HRSk2m+9e9LyVM/JUl71um6r
         1rM0dR8TsOp5Lt24acPU87Bi8fa1VteDUzI6OCpy4RiJfO9ajFJwBJlMC4X64nJEy7Mc
         ZyyyELEm5ckjs6kNam1qH3B8DzOyHXrvU2U7Wd2BAMHZ/1j+TxO8Hnv0zNo6jyYfjAbL
         FQrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766505997; x=1767110797;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f0id+v0RQ7dPGJFkKMzUF3z52grtJKOfftvzQrgbet0=;
        b=XvXS2W/tqEmxvkDIvd1+OQbCJhLn7QErucdMq5Ktuqb/ZxlRMyWxavvS/b3vfaoieL
         jWyfScalBXcotI+BqjuZSqG2U3V1NYh6DYEUvTE3scLLNYVg7ZswFu1nvoxhhWxJuaBD
         3Th98+UBbiaNpvFDZVhcgeKK2jdGuLyHnUG2LD107tGMFHAi704a9Ylx9vpFlW8sHcqM
         gj6lnUGbrxiHMI5mmMgGUVgN94NaIWSLCMa3Yqv0idL7WGmpYbsqM2FXW6/VeZg9ufXt
         BFNphs6/ZpoXt+TTUbVZdeJLC/14+6a6LRA2xYK731pY4Do0TCypylYDD5slrm4wwvr/
         z6Sg==
X-Forwarded-Encrypted: i=1; AJvYcCWPtKpMSCFa4RXsrw1NyXWO9iFr5zlDDJMBhGvqj72sMWY9OWMP60HmODZFB+CcEXHEGlU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz67RoekpS6tUc8imzG8su7ALCGhh4fY4GmjbPu+CFMhhkSihi4
	jaxJfD70w7roSuiJ1xXeBcWjuAQnMNfovdQMClBtRop0DJq1K3+Yr7BBf2hEpM3yP95U84QqrVU
	O8TAlCg==
X-Google-Smtp-Source: AGHT+IEoLtVjGHkwIuHHlXoLsKN782fTmS8CLHyiLG+vfSC3Y0+7fluy3sdYU+OgPJT1Wcc6+j5lWgSdHEU=
X-Received: from pfjd20.prod.google.com ([2002:a05:6a00:2454:b0:7b8:d5a9:9eff])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:f95:b0:7e8:4471:ae5f
 with SMTP id d2e1a72fcca58-7ff67456610mr12940606b3a.43.1766505996819; Tue, 23
 Dec 2025 08:06:36 -0800 (PST)
Date: Tue, 23 Dec 2025 08:06:35 -0800
In-Reply-To: <fcqjl5a7m27f2mfpblnhgmozbipdjmvpdyk3m5hhzwcenp4cpg@m2ooa7ykrcvs>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com> <20240809190319.1710470-2-seanjc@google.com>
 <fcqjl5a7m27f2mfpblnhgmozbipdjmvpdyk3m5hhzwcenp4cpg@m2ooa7ykrcvs>
Message-ID: <aUq9_cUDWeEW_qli@google.com>
Subject: Re: [PATCH 01/22] KVM: x86: Disallow read-only memslots for SEV-ES
 and SEV-SNP (and TDX)
From: Sean Christopherson <seanjc@google.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>, 
	Nikunj A Dadhania <nikunj@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Dec 03, 2025, Naveen N Rao wrote:
> Hi Sean,
> 
> On Fri, Aug 09, 2024 at 12:02:58PM -0700, Sean Christopherson wrote:
> > Disallow read-only memslots for SEV-{ES,SNP} VM types, as KVM can't
> > directly emulate instructions for ES/SNP, and instead the guest must
> > explicitly request emulation.  Unless the guest explicitly requests
> > emulation without accessing memory, ES/SNP relies on KVM creating an MMIO
> > SPTE, with the subsequent #NPF being reflected into the guest as a #VC.
> > 
> > But for read-only memslots, KVM deliberately doesn't create MMIO SPTEs,
> > because except for ES/SNP, doing so requires setting reserved bits in the
> > SPTE, i.e. the SPTE can't be readable while also generating a #VC on
> > writes.  Because KVM never creates MMIO SPTEs and jumps directly to
> > emulation, the guest never gets a #VC.  And since KVM simply resumes the
> > guest if ES/SNP guests trigger emulation, KVM effectively puts the vCPU
> > into an infinite #NPF loop if the vCPU attempts to write read-only memory.
> > 
> > Disallow read-only memory for all VMs with protected state, i.e. for
> > upcoming TDX VMs as well as ES/SNP VMs.  For TDX, it's actually possible
> > to support read-only memory, as TDX uses EPT Violation #VE to reflect the
> > fault into the guest, e.g. KVM could configure read-only SPTEs with RX
> > protections and SUPPRESS_VE=0.  But there is no strong use case for
> > supporting read-only memslots on TDX, e.g. the main historical usage is
> > to emulate option ROMs, but TDX disallows executing from shared memory.
> > And if someone comes along with a legitimate, strong use case, the
> > restriction can always be lifted for TDX.
> > 
> > Don't bother trying to retroactively apply the restriction to SEV-ES
> > VMs that are created as type KVM_X86_DEFAULT_VM.  Read-only memslots can't
> > possibly work for SEV-ES, i.e. disallowing such memslots is really just
> > means reporting an error to userspace instead of silently hanging vCPUs.
> > Trying to deal with the ordering between KVM_SEV_INIT and memslot creation
> > isn't worth the marginal benefit it would provide userspace.
> > 
> > Fixes: 26c44aa9e076 ("KVM: SEV: define VM types for SEV and SEV-ES")
> > Fixes: 1dfe571c12cf ("KVM: SEV: Add initial SEV-SNP support")
> > Cc: Peter Gonda <pgonda@google.com>
> > Cc: Michael Roth <michael.roth@amd.com>
> > Cc: Vishal Annapurve <vannapurve@google.com>
> > Cc: Ackerly Tng <ackerleytng@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h | 2 ++
> >  include/linux/kvm_host.h        | 7 +++++++
> >  virt/kvm/kvm_main.c             | 5 ++---
> >  3 files changed, 11 insertions(+), 3 deletions(-)
> 
> As discussed in one of the previous PUCK calls, this is causing Qemu to 
> throw an error when trying to enable debug-swap for a SEV-ES guest when 
> using a pflash drive for OVMF. Sample qemu invocation (*):
>   qemu-system-x86_64 ... \
>     -drive if=pflash,format=raw,unit=0,file=/path/to/OVMF_CODE.fd,readonly=on \
>     -drive if=pflash,format=raw,unit=1,file=/path/to/OVMF_VARS.fd \
>     -machine q35,confidential-guest-support=sev0 \
>     -object sev-guest,id=sev0,policy=0x5,cbitpos=51,reduced-phys-bits=1,debug-swap=on
> 
> This is expected since enabling debug-swap requires use of 
> KVM_SEV_INIT2, which implies a VM type of KVM_X86_SEV_ES_VM. However, 
> SEV-ES VMs that do not enable any VMSA SEV features (and are hence 
> KVM_X86_DEFAULT_VM type) are allowed to continue to launch though they 
> are also susceptible to this issue.
> 
> One of the suggestions in the call was to consider returning an error to 
> userspace instead. Is this close to what you had in mind:
> 
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 73cdcbccc89e..19e27ed27e17 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -387,8 +387,10 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>          * they can fix it by changing memory to shared, or they can
>          * provide a better error.
>          */
> -       if (r == RET_PF_EMULATE && fault.is_private) {
> -               pr_warn_ratelimited("kvm: unexpected emulation request on private memory\n");
> +       if (r == RET_PF_EMULATE && (fault.is_private ||
> +           (!fault.map_writable && fault.write && vcpu->arch.guest_state_protected))) {
> +               if (fault.is_private)
> +                       pr_warn_ratelimited("kvm: unexpected emulation request on private memory\n");
>                 kvm_mmu_prepare_memory_fault_exit(vcpu, &fault);
>                 return -EFAULT;
>         }
> 
> This seems to work though Qemu seems to think we are asking it to 
> convert the memory to shared (so we probably need to signal this error 
> some other way?):
>   qemu-system-x86_64: Convert non guest_memfd backed memory region (0xf0000 ,+ 0x1000) to shared
> 
> Thoughts?

The choke point would be kvm_handle_error_pfn() (see below), where the RET_PF_EMULATE
originates.  But looking at all of this again, I am opposed to changing KVM's
ABI to allow KVM_MEM_READONLY for SEV-ES guests, it simply can't work.  And KVM
enumerates as much.

	case KVM_CAP_READONLY_MEM:
		r = kvm ? kvm_arch_has_readonly_mem(kvm) : 1;
		break;

More importantly, if QEMU wants to provide a not-fully-functional configuration
to allow KVM_SEV_INIT2 with pflash, QEMU can fudge around the lack of read-only
memory without KVM's assistance.  It likely won't be pretty, but it's doable,
by clearing PROT_WRITE in the backing VMA that's handed to the KVM memslot.

KVM will see a normal memslot that the guest can read/execute, and if the guest
attempts to write to the memory, hva_to_pfn() will return KVM_PFN_RR_FAULT and
kvm_handle_error_pfn() will send that out to userspace as -EFAULT.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f17324546900..27dc909b8225 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3493,8 +3493,12 @@ static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
         * into the spte otherwise read access on readonly gfn also can
         * caused mmio page fault and treat it as mmio access.
         */
-       if (fault->pfn == KVM_PFN_ERR_RO_FAULT)
+       if (fault->pfn == KVM_PFN_ERR_RO_FAULT) {
+               if (kvm_arch_has_readonly_mem(vcpu->kvm))
+                       return -EFAULT;
+
                return RET_PF_EMULATE;
+       }
 
        if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
                kvm_send_hwpoison_signal(fault->slot, fault->gfn);

